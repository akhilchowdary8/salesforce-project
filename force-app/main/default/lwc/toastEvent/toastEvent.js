import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class ToastEvent extends LightningElement {
  handleClick() {
    const event = new ShowToastEvent({
      title: "Success!",
      message: "The record has been updated successfully.",
      variant: "success"
    });
    this.dispatchEvent(event);
  }
}