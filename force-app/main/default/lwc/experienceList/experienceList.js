import { LightningElement, api } from 'lwc';

export default class ExperienceList extends LightningElement {

    @api records;

    columns = [
        { label: 'Company', fieldName: 'Company__c' },
        { label: 'Role', fieldName: 'Role__c' },
        { label: 'Domain', fieldName: 'Domain__c' },
        {
            type: 'button',
            typeAttributes: {
                label: 'View',
                variant: 'brand'
            }
        }
    ];

    handleRowAction(event) {
        const recordId = event.detail.row.Id;

        this.dispatchEvent(
            new CustomEvent('recordselect', {
                detail: { id: recordId }
            })
        );
    }
}