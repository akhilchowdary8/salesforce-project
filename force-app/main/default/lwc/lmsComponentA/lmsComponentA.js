import { LightningElement, wire } from "lwc";
import SampleMessage from "@salesforce/messageChannel/SampleMessage__c";
import { publish, MessageContext } from "lightning/messageService";
export default class LmsComponentA extends LightningElement {
  value = "";
  @wire(MessageContext)
  messageContext;
  handleChange(event) {
    this.value = event.target.value;
  }
  handlePublish() {
    const message = {
      Data: {
        value1: this.value
      }
    };

    publish(this.messageContext, SampleMessage, message);
  }
}