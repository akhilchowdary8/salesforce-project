import { LightningElement, api } from 'lwc';

export default class AppContainer extends LightningElement {

    @api activeTab;

    get isExperience() {
        return this.activeTab === 'experience';
    }
}