// import { LightningElement,api } from 'lwc';
// export default class QuoteSummary extends LightningElement {

// // Displays Real-Time Quote Summary
// // Total List Price   //SBQQ__ListAmount__c
// // Total Discount %  //	SBQQ__CustomerDiscount__c
// // Net Price           //SBQQ__NetAmount__c
// // Approval Status     //SBQQ__Status__c
 
 
// // Validation Rules
// // If Discount > 20% → Show warning
// // If Discount > 30% → Disable “Submit for Approval”
// // If Credit Score < 650 → Block submission


// }
import { LightningElement, api,wire} from "lwc";

import List_Amount from "@salesforce/schema/SBQQ__Quote__c.SBQQ__ListAmount__c";
import Additional_Disc from "@salesforce/schema/SBQQ__Quote__c.SBQQ__CustomerDiscount__c";
import Net_Amount from "@salesforce/schema/SBQQ__Quote__c.SBQQ__NetAmount__c";
import Status from "@salesforce/schema/SBQQ__Quote__c.SBQQ__Status__c";
import geresult from "@salesforce/apex/quoteDetails.doSomething"
import Toast from 'lightning/toast';

export default class RecordViewFormStaticContact extends LightningElement {
  // Expose a field to make it available in the template
  listAmmount = List_Amount;
  addDiscount =Additional_Disc;
  netAmmount = Net_Amount;
  status=Status;
  resultData={};



  // Flexipage provides recordId and objectApiName
  @api recordId;
  @api objectApiName;
  
     @wire(geresult, { quoteId: '$recordId' })
    wiredQuote({ data, error }) {
        if (data) {
            this.resultData = { ...data };
            this.error = undefined;
            this.handleClick();
        } else if (error) {
            this.error = error;
            this.resultData = undefined;
            this.isSubmitDisabled = true;
            this.showToast('Error loading Quote', this.normalizeError(error), 'error');
        }
    }
  handleClick(){
    // console.log('datat from quote'+addDiscount);
    // console.log('datat from quote'+netAmmount);
    // console.log('datat from quote'+status);
 const discount = this.resultData?.SBQQ__CustomerDiscount__c ?? 0;

        // Rule 1: If Discount > 20% → Show warning (informational toast)
        if (discount > -1) {
              Toast.show({
            label: `please remove discount `,
            message: 'I want to show a {salesforceLink} and a {slackLink}',
        
            variant: 'info'
        }, this);
        }

  }


}