import { LightningElement } from "lwc";

export default class SampleTable extends LightningElement {
    
    columns = [
        { label: "Account Name", fieldName: "Name" },
        { label: "Industry", fieldName: "Industry" },
        { label: "Phone", fieldName: "Phone" }
    ];

    data = [
        {
            Id: "001xx000003DGb1AAG",
            Name: "Acme Corporation",
            Industry: "Technology",
            Phone: "9876543210"
        },
        {
            Id: "001xx000003DGb2AAG",
            Name: "Global Media",
            Industry: "Entertainment",
            Phone: "9123456780"
        }
    ];
}