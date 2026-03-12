import { LightningElement } from "lwc";

export default class ChildCompHooks extends LightningElement {
  constructor() {
    super();
    console.log("Child Constructor Called");
  }

  connectedCallback() {
    console.log("Child Connected Callback Called");
  }

  renderedCallback() {
    console.log("Child Rendered Callback Called");
  }

  disconnectedCallback() {
    console.log("Child Disconnected Callback Called");
  }
}