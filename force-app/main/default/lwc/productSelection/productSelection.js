import { LightningElement, api, wire, track } from 'lwc';
import fetchProducts from '@salesforce/apex/FetchProductdetails.fetchProducts';
import createQuoteLines from '@salesforce/apex/FetchProductdetails.createQuoteLines';
import { createRecord } from 'lightning/uiRecordApi';

import QUOTE_OBJECT from '@salesforce/schema/SBQQ__Quote__c';
import OPPORTUNITY_FIELD from '@salesforce/schema/SBQQ__Quote__c.SBQQ__Opportunity2__c';

export default class OpportunityQuoteGenerator extends LightningElement {

    @api recordId;
    @track products;
    selectedProducts = [];

    columns = [
        { label: 'Name', fieldName: 'Name' }
    ];

    @wire(fetchProducts)
    wiredProducts({ data, error }) {
        if (data) {
            this.products = data;
        }
    }

    handleSelection(event) {
        this.selectedProducts = event.detail.selectedRows;
        console.log('Selected products:', JSON.stringify(this.selectedProducts, null, 2));
    }

async createQuote() {

    try {

        // Create empty Quote
        const recordInput = {
            apiName: QUOTE_OBJECT.objectApiName,
            fields: {}
        };

        console.log('Creating Quote:', recordInput);

        const quote = await createRecord(recordInput);

        console.log('Quote Created Id:', quote.id);

        // Prepare Quote Lines
const lines = this.selectedProducts.map(row => {
    return {
        productId: row.Id,   // must match Apex variable name
        quantity: 1
    };
});

console.log('Lines sent to Apex:',
    JSON.stringify(lines, null, 2)
);
       
        // JS Discount Validation
        for (let line of lines) {
            if (line.discount > 40) {
                alert('Discount greater than 20% requires approval');
                return;
            }
        }

        // Insert Quote Lines
        await createQuoteLines({
            quoteId: quote.id,
            lines: lines
        });

        alert('Quote Created Successfully');

    } catch (error) {
        console.error('Error:', error);
        alert('Error creating Quote');
    }
}
}