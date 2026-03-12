import { LightningElement } from "lwc";

export default class ChildModal extends LightningElement {
  closemodal() {
    const closeModalEvent = new CustomEvent("closemodals", {
      bubbles: true,
      composed: true,
      detail: {
        message: "child modal"
      }
    });
    this.dispatchEvent(closeModalEvent);
  }
}