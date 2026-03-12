import { LightningElement, wire } from "lwc";
import SampleMessage from "@salesforce/messageChannel/SampleMessage__c";
import {
  subscribe,
  MessageContext,
  APPLICATION_SCOPE,
  unsubscribe
} from "lightning/messageService";
export default class LmsComponentX extends LightningElement {
  subscrtiption;
  messagereceived = "";
  @wire(MessageContext)
  messageContext;
  connectedCallback() {
    this.subscrtiption = subscribe(
      this.messageContext,
      SampleMessage,
      (message) => {
        this.handleMessage(message);
      },
      { scope: APPLICATION_SCOPE }
    );
    console.log("Subscription: coonnectedcallback ");
  }

  handleMessage(message) {
    console.log("Message received: in x " + message.Data.value1);
    this.messagereceived = message.Data.value1
      ? message.Data.value1
      : "No value";
  }
  handleunsubscribe() {
    unsubscribe(this.subscrtiption);
    this.subscrtiption = null;
  }
}