import { LightningElement, api } from 'lwc';

export default class AppNavigation extends LightningElement {

    @api activeTab;

    get experienceClass() {
        return this.activeTab === 'experience'
            ? 'slds-context-bar__item slds-is-active'
            : 'slds-context-bar__item';
    }

    get projectClass() {
        return this.activeTab === 'projects'
            ? 'slds-context-bar__item slds-is-active'
            : 'slds-context-bar__item';
    }

    get certClass() {
        return this.activeTab === 'certifications'
            ? 'slds-context-bar__item slds-is-active'
            : 'slds-context-bar__item';
    }

    goExperience() {
        this.dispatchEvent(new CustomEvent('tabchange', { detail: { tab: 'experience' }}));
    }

    goProjects() {
        this.dispatchEvent(new CustomEvent('tabchange', { detail: { tab: 'projects' }}));
    }

    goCert() {
        this.dispatchEvent(new CustomEvent('tabchange', { detail: { tab: 'certifications' }}));
    }
}