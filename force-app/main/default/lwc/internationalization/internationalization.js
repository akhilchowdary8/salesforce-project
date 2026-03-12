import { LightningElement } from "lwc";
import Locale from "@salesforce/i18n/locale";
import currency from "@salesforce/i18n/currency";
import label1 from "@salesforce/label/c.Description";

export default class Internationalization extends LightningElement {
  descrip = label1;
  number = 123456;
  Formatednumber = new Intl.NumberFormat(Locale, {
    style: "currency",
    currency: currency
  }).format(this.number);
}