import { LightningElement } from "lwc";
import { subscribe } from "lightning/messageService";
export default class PubSubComponentB extends LightningElement {
  message;
  connectedCallback() {
    subscribe("componentB", (message) => {
      this.message = message;
    });
  }
}