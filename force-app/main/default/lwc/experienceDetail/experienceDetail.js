import { LightningElement, api } from 'lwc';

export default class ExperienceDetail extends LightningElement {

    @api recordId;
    @api records;

    get record() {
        return this.records.find(r => r.Id === this.recordId);
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}