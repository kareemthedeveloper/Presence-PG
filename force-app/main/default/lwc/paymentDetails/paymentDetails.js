import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getContactDetails from '@salesforce/apex/PaymentDetailsController.getContactDetails';
//import dmlOnContacts from '@salesforce/apex/PaymentDetailsController.dmlOnContacts';
import getPaymentList from '@salesforce/apex/PaymentDetailsController.getPaymentList';
import submitContact from '@salesforce/apex/PaymentDetailsController.submitContact';
import submitPayment from '@salesforce/apex/PaymentDetailsController.submitPayment';
import deletePayment from '@salesforce/apex/PaymentDetailsController.deletePayment';
import { refreshApex } from '@salesforce/apex';
 
export default class PaymentDetails extends LightningElement {
    @api recordId;
    @track isLoading = true;
    isShowSpinner =false;
    @track records;
    @track contactRecords;
    @track paymentRecords;
    error;
    isModalOpen=false;
    @track deleteConatctIds = '';
    noFutureDate;
    contactRec='';
    //to close quick action
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
        const todayDate = new Date();
        todayDate.setDate(todayDate.getDate());
        this.noFutureDate = todayDate.toISOString().slice(0, 10);
    }

    connectedCallback() {
       this.getContacts();
    }

    createPayment(event){
        this.isNewPaymentModal = true;
        this.isModalOpen = false;
    }

    //update table row values in list
    updateContactValues(event){
        var foundelement = this.records.find(ele => ele.Id == event.target.dataset.id);
        if(event.target.name === 'Total_Amount_of_Payments__c'){
            foundelement.Total_Amount_of_Payments__c = event.target.value;
        }else if(event.target.name === 'Most_Recent_Payment_Date__c'){
            foundelement.Most_Recent_Payment_Date__c = event.target.value;
        }
    }
    

     updatePaymentValues(event){
        var foundelement = this.paymentData.find(ele => ele.Id == event.target.dataset.id);
        if(event.target.name === 'Payment_Amount__c'){
            foundelement.Payment_Amount__c = event.target.value;
        }else if(event.target.name === 'Payment_Date__c'){
            foundelement.Payment_Date__c = event.target.value;
        }
    }

    navigateToContactList(event){
        this.isNewPaymentModal = false;
        this.isModalOpen = false;
    }
    
    handleCancel(event){
        this.records = this.contactRecords;
        this.paymentData = this.paymentRecords;
    }

    viewPaymentData(event){
        var contactId = event.target.dataset.id;
        this.contactRec = event.target.dataset.id;;
        getPaymentList({contactId : contactId})
        .then( data => {
            
 console.log('@@data getPaymentList  : '+JSON.stringify(data));
        
        if(data) {
            console.log('Data Payemtn : '+JSON.stringify(data));
             this.paymentData = data.map(key => {
                 var projectName = '';
                 if(key.Project__r != undefined && key.Project__r != null){
                     projectName = key.Project__r.Name;
                 }
             return {...key, Project__c : projectName}
        });   
        this.paymentRecords = this.paymentData;
        this.isModalOpen = true;
        }
        }).catch( error => {
            console.log(error);
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }

    getPaymentDetails(contactId){
        
        getPaymentList({contactId : contactId})
        .then( data => {
            
 console.log('@@data getPaymentList  : '+JSON.stringify(data));
        
        if(data) {
            console.log('Data Payemtn : '+JSON.stringify(data));
             this.paymentData = data.map(key => {
                 var projectName = '';
                 if(key.Project__r != undefined && key.Project__r != null){
                     projectName = key.Project__r.Name;
                 }
             return {...key, Project__c : projectName}
        });   
        this.paymentRecords = this.paymentData;
        this.isModalOpen = true;
        }
        }).catch( error => {
            console.log(error);
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }

    //remove records from table
    handleDeleteAction(event){
        var paymentId = event.target.dataset.id;
        console.log('paymentId' +paymentId);
         deletePayment({paymentId : paymentId})
        .then( data => {
            console.log('paymentIddata' +data);
            window.location.reload();
            
            this.showToast('Success', 'Payment is deleted successfully.', 'Success', 'dismissable');
        }).catch( error => {
            console.log(error);
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }
 
    //fetch account contact records
    
    getContacts() {
         getContactDetails()
        .then( data => {
            
 console.log('@@data  : '+JSON.stringify(data));
        
        if(data) {
            this.records = JSON.parse(JSON.stringify(data));
            this.contactRecords = this.records;
            this.error = undefined;
            this.handleIsLoading(false);
        }    

        }).catch( error => {
            console.log(error);
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    } 
 
    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }
 
    updateRecordView() {
       setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
       }, 3000); 
    }

    navigateToPaymentList(event){
        this.isNewPaymentModal = false;
        this.isModalOpen = true;
    }

    handleReset(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleContactSave(event){
        submitContact({contactList: this.records})
        .then( result => {
            this.handleIsLoading(false);
            this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            this.handleIsLoading(false);
            console.log(error);
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }

    handlePaymentSave(event){
        submitPayment({paymentList: this.paymentData})
        .then( result => {
            this.handleIsLoading(false);
            this.showToast('Success', result, 'Success', 'dismissable');
        }).catch( error => {
            this.handleIsLoading(false);
            console.log(error);
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        });
    }

    handleSuccess(event){
        this.navigateToPaymentList();
        this.showToast('Success', 'Payment is created successfully.', 'Success', 'dismissable');
    }


}