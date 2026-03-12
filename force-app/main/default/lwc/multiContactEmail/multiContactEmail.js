import { LightningElement, track } from 'lwc';
import searchContacts from '@salesforce/apex/ContactEmailController.searchContacts';
import sendEmails from '@salesforce/apex/ContactEmailController.sendEmails';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MultiContactEmail extends LightningElement {

@track searchResults = [];
@track selectedContacts = [];

subject = '';
message = '';

delayTimeout;

handleSearch(event){

const searchKey = event.target.value;

clearTimeout(this.delayTimeout);

this.delayTimeout = setTimeout(() => {

    if(searchKey){

        searchContacts({searchKey})
        .then(result => {

            this.searchResults = result;

        });

    }

},300);

}

selectContact(event){

const id = event.currentTarget.dataset.id;
const name = event.currentTarget.dataset.name;
const email = event.currentTarget.dataset.email;

if(!this.selectedContacts.find(c => c.Id === id)){

this.selectedContacts = [
...this.selectedContacts,
{Id:id, Name:name, Email:email}
];

}

}

removeContact(event){

const id = event.target.name;

this.selectedContacts = this.selectedContacts.filter(
c => c.Id !== id
);

}

handleSubject(event){
this.subject = event.target.value;
}

handleMessage(event){
this.message = event.target.value;
}

sendEmail(){

if(!this.subject || !this.message){

this.showToast('Error','Subject and Message required','error');
return;

}

const ids = this.selectedContacts.map(c => c.Id);

sendEmails({
contactIds:ids,
subject:this.subject,
message:this.message
})
.then(result => {

this.showToast('Success',result,'success');

})
.catch(error => {

this.showToast('Error',error.body.message,'error');

});

}

showToast(title,message,variant){

this.dispatchEvent(
new ShowToastEvent({
title,
message,
variant
})
);

}

}