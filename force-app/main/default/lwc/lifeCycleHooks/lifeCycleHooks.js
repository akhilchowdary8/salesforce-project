import { LightningElement } from "lwc";
export default class LifeCycleHooks extends LightningElement {
  constructor() {
    super();
    console.log("Constructor Called");
  }

  connectedCallback() {
    console.log("Connected Callback Called");
  }
  // render() {
  //   console.log("Render Called");
  //   return lifeCycleHooks1;
  // }

  renderedCallback() {
    console.log("Rendered Callback Called");
  }

  disconnectedCallback() {
    console.log("Disconnected Callback Called");
  }
}