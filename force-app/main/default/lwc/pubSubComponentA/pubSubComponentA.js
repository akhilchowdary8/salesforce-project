import { LightningElement } from "lwc";
import { publish } from "lightning/messageService";
export default class PubSubComponentA extends LightningElement {
  message = "new";
  handleChange(event) {
    this.message = event.target.value;
  }
  handleClick() {
    publish("componentA", this.message);
  }
}