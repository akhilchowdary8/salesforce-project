import { LightningElement } from 'lwc';

export default class AkhilApp extends LightningElement {
    activeTab = 'experience';

    handleTabChange(event) {
        this.activeTab = event.detail.tab;
    }
}