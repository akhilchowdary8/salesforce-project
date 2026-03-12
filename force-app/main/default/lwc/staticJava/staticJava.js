import { LightningElement } from "lwc";
import moment1 from "@salesforce/resourceUrl/Momentjs";
import ANIMATION from "@salesforce/resourceUrl/Animatecss";
import { loadScript } from "lightning/platformResourceLoader";
import { loadStyle } from "lightning/platformResourceLoader";
export default class StaticJava extends LightningElement {
  currDate = "";
  renderedCallback() {
    Promise.all([
      loadScript(this, moment1 + "/moment/moment.min.js"),
      loadStyle(this, ANIMATION + "/animate/animate.min.css")
    ])
      .then(() => {
        this.initializeMoment();
      })
      .catch((error) => {
        console.log("error.message");
      });
  }
  initializeMoment() {
    this.currDate = moment().format("MMMM Do YYYY, h:mm:ss a");
  }
}