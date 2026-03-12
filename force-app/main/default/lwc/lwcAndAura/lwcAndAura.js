import { LightningElement } from "lwc";
import { api } from "lwc";
export default class LwcAndAura extends LightningElement {
  @api title;
  handleClick() {
    this.dispatchEvent(
      new CustomEvent("buttonclick", { detail: { message: "data from lwc" } })
    );
  }
}