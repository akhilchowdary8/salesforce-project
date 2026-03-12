import { LightningElement, api, wire, track } from 'lwc';
import fetchProducts from '@salesforce/apex/FetchProductdetails.fetchProducts';
import createQuoteLines from '@salesforce/apex/FetchProductdetails.createQuoteLines';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

import QUOTE_OBJECT from '@salesforce/schema/SBQQ__Quote__c';

export default class OpportunityQuoteGenerator extends NavigationMixin(LightningElement) {
  @api recordId;

  // Table columns
columns = [
  // New numbering column (read-only)
  { label: '#', fieldName: 'rowNumber', type: 'number', cellAttributes: { alignment: 'left' } },

  // Existing columns
  { label: 'Name', fieldName: 'Name' },
  { label: 'Quantity', fieldName: 'quantity', type: 'number', editable: true },
  { label: 'Discount (%)', fieldName: 'discount', type: 'number', editable: true }
];

  // Data + pagination
  @track products;
  pageSize = 10;
  offset = 0;
  isLastPage = false;

  // Selection across pages
  // Use Set for IDs (fast contains), Map for row data to preserve edits
  selectedIdSet = new Set();
  selectedRowData = new Map();

  // Bound to datatable.selected-rows (for current page only)
  @track selectedRowKeysForPage = [];

  // UI state
  @track rowErrors = {};
  isLoading = false;

  // Pagination UI getters
  get isPreviousDisabled() {
    return this.offset === 0;
  }
  get isNextDisabled() {
    return this.isLastPage;
  }

  connectedCallback() {
    this.loadProducts();
  }

  // Fetch server-side page
  loadProducts() {
  this.isLoading = true;

  fetchProducts({
    pageSize: this.pageSize,
    offsetSize: this.offset
  })
  .then(result => {
    // Baseline rows for this page
    let pageRows = result.map(row => ({
      ...row,
      quantity: 1,
      discount: 0
    }));

    // Merge any previously edited/selected values for rows that appear on this page
    pageRows = pageRows.map(r => {
      if (this.selectedRowData.has(r.Id)) {
        const prev = this.selectedRowData.get(r.Id);
        return {
          ...r,
          quantity: prev.quantity ?? r.quantity,
          discount: prev.discount ?? r.discount
        };
      }
      return r;
    });

    // 🔢 Add continuous row numbers using offset + index
    pageRows = pageRows.map((r, idx) => ({
      ...r,
      rowNumber: this.offset + idx + 1
    }));

    this.products = pageRows;
    this.isLastPage = result.length < this.pageSize;

    // Recompute selected keys for visible page
    this.recomputeSelectedForPage();
  })
  .catch(error => {
    console.error(error);
    this.dispatchEvent(
      new ShowToastEvent({
        title: 'Error',
        message: error?.body?.message || error?.message || 'Failed to load products',
        variant: 'error'
      })
    );
  })
  .finally(() => {
    this.isLoading = false;
  });
}

  handleNext() {
    this.offset += this.pageSize;
    this.loadProducts();
  }

  handlePrevious() {
    if (this.offset >= this.pageSize) {
      this.offset -= this.pageSize;
      this.loadProducts();
    }
  }

  /**
   * Recompute which selected IDs are visible in the current page.
   * Bind this to lightning-datatable via selected-rows.
   */
  recomputeSelectedForPage() {
    if (!this.products || this.products.length === 0) {
      this.selectedRowKeysForPage = [];
      return;
    }
    const visibleIds = new Set(this.products.map(r => r.Id));
    this.selectedRowKeysForPage = [...this.selectedIdSet].filter(id => visibleIds.has(id));
  }

  /**
   * User changed selection on current page
   * event.detail.selectedRows contains only rows from the visible page.
   */
  handleSelection(event) {
    const newlySelectedRows = event.detail.selectedRows || [];
    const newlySelectedIds = new Set(newlySelectedRows.map(r => r.Id));
    console.log('daata discelected'+ JSON.stringify(newlySelectedRows, null, 2) );

    // 1) Remove all visible rows from global selection first
    (this.products || []).forEach(row => {
      const id = row.Id;
      if (this.selectedIdSet.has(id)) {
        this.selectedIdSet.delete(id);
        this.selectedRowData.delete(id); // remove stored values for those we unselect
      }
    });

    // 2) Add back current page selections + persist their latest row values
    newlySelectedRows.forEach(row => {
      this.selectedIdSet.add(row.Id);
      // Store the current values so edits persist across pages
      this.selectedRowData.set(row.Id, {
        Id: row.Id,
        Name: row.Name,
        quantity: row.quantity ?? 1,
        discount: row.discount ?? 0
      });
    });

    // 3) Reflect in the current page
    this.recomputeSelectedForPage();

    // 4) Re-run validation across ALL selected rows
    this.rowErrors = this.validateDiscounts();
  }

  /**
   * Inline cell change on this page.
   * Keep products updated and also update selectedRowData if that row is selected.
   */
  handleCellChange(event) {
    const draftValues = event.detail.draftValues || [];

    draftValues.forEach(draft => {
      const idx = this.products.findIndex(p => p.Id === draft.Id);
      if (idx !== -1) {
        // Update visible row values
        this.products[idx] = {
          ...this.products[idx],
          ...draft
        };
      }

      // If this row is selected, persist edits across pages
      if (this.selectedIdSet.has(draft.Id)) {
        const existing = this.selectedRowData.get(draft.Id) || { Id: draft.Id };
        this.selectedRowData.set(draft.Id, {
          ...existing,
          ...draft
        });
      }
    });

    // Clear draft values so datatable doesn't keep stale drafts
    event.target.draftValues = [];

    // Re-run validation with the up-to-date selectedRowData
    this.rowErrors = this.validateDiscounts();
  }

  /**
   * Validate ALL selected rows (across pages) using selectedRowData.
   * row-errors shape: { rows: { [rowKey]: { title, messages, fieldNames } } }
   */
  validateDiscounts() {
    const rowsErrorMap = {};
    for (const [id, row] of this.selectedRowData.entries()) {
      const discountNum = row.discount ? Number(row.discount) : 0;
      if (discountNum > 50) {
        rowsErrorMap[id] = {
          title: 'Invalid Discount',
          messages: ['Discount cannot exceed 50%'],
          fieldNames: ['discount']
        };
      }
    }

    if (Object.keys(rowsErrorMap).length > 0) {
      return { rows: rowsErrorMap };
    }
    return {};
  }

  /**
   * Create Quote + Quote Lines from ALL selected rows
   */
  async createQuote() {
    this.isLoading = true;

    try {
      // Inline validation before proceeding
      this.rowErrors = this.validateDiscounts();
      if (Object.keys(this.rowErrors).length > 0) {
        // Hard stop if errors present
        this.isLoading = false;
        return;
      }

      // Create empty Quote
      const recordInput = {
        apiName: QUOTE_OBJECT.objectApiName,
        fields: {}
      };
      const quote = await createRecord(recordInput);

      // Prepare Quote Lines from selectedRowData
      const lines = [...this.selectedRowData.values()].map(row => ({
        productId: row.Id,
        quantity: row.quantity ? Number(row.quantity) : 1,
        discount: row.discount ? Number(row.discount) : 0
      }));

      // Final JS validation
      for (let line of lines) {
        if (line.discount > 50) {
          // Use a toast instead of alert in LWC for consistency
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Validation',
              message: 'Discount greater than 50% requires approval',
              variant: 'warning'
            })
          );
          this.isLoading = false;
          return;
        }
      }

      // Insert Quote Lines
      await createQuoteLines({
        quoteId: quote.id,
        lines
      });

      // Success
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Success',
          message: 'Quote Created Successfully',
          variant: 'success'
        })
      );

      // Close Quick Action & navigate to Quote
      this.dispatchEvent(new CloseActionScreenEvent());
      this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
          recordId: quote.id,
          objectApiName: 'SBQQ__Quote__c',
          actionName: 'view'
        }
      });
    } catch (error) {
      let errorMessage = 'Unknown error occurred';
      if (error?.body?.message) errorMessage = error.body.message;
      else if (error?.message) errorMessage = error.message;

      // eslint-disable-next-line no-console
      console.error('Full Error:', JSON.stringify(error, null, 2));

      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error',
          message: errorMessage,
          variant: 'error'
        })
      );
    } finally {
      this.isLoading = false;
    }
  }
}