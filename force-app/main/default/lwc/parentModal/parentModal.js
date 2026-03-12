import { LightningElement, track } from "lwc";

export default class ParentModal extends LightningElement {
  parentModalText = "Parent Modal";
  @track isChildModalOpen = false;
  openChildModal(event) {
    this.isChildModalOpen = true;
  }
  closeChild(event) {
    this.isChildModalOpen = false;
    this.parentModalText = event.detail.message;
  }
}