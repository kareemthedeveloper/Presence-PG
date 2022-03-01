public class PaymentDetailsController {
    @AuraEnabled
    public static List<Contact> getContactDetails() {
        return [SELECT Id, Total_Amount_of_Payments__c, FirstName, LastName, Most_Recent_Payment_Date__c FROM Contact WHERE Total_Amount_of_Payments__c != null];
    }
 	
    @AuraEnabled
    public static List<Payment__c> getPaymentList(String contactId) {
        return [SELECT Id, Name,Project__r.Name,Payment_Amount__c, Payment_Date__c, Payment_Status__c, Person__c,Method_of_Payment__c FROM Payment__c WHERE Person__c =:contactId];
    }
    /*
    @AuraEnabled
    public static string dmlOnContacts(Object data, String removeContactIds) {
        List<Contact> updateContact = (List<Contact>) JSON.deserialize(JSON.serialize(data), List<Contact>.class);
        List<Contact> deleteContact = new List<Contact>();
 
        if(String.isNotBlank(removeContactIds)){
            List<Id> contactIds = removeContactIds.split(',');
            deleteContact = [SELECT Id FROM Contact WHERE Id IN :contactIds];
        }
 
        try {
            if(updateContact != null && !updateContact.isEmpty()){
              //  upsert updateContact;
            }
 
            if(deleteContact != null && !deleteContact.isEmpty()){    
             //   delete deleteContact;
            }
            return 'Success: Contact(s) upsert/delete successfully';
        }
        catch (Exception e) {
            String errorMsg = 'The following exception has occurred: ' + e.getMessage();
            throw new AuraHandledException(ErrorMsg);
        }
       // return '';
    } */
    
    @AuraEnabled
    public static string submitContact(Object contactList) {
        List<Contact> updateContact = (List<Contact>) JSON.deserialize(JSON.serialize(contactList), List<Contact>.class);
        List<Contact> deleteContact = new List<Contact>();
 
            if(updateContact != null && !updateContact.isEmpty()){
                Database.update(updateContact,false);
            }
 
            return 'Success: Contact(s) updated successfully';
        
      
       // return '';
    }
    
    @AuraEnabled
    public static string deletePayment(String paymentId) {
 
            System.debug('paymentId : '+paymentId);
            if(String.isNotBlank(paymentId)){
                Delete [Select Id FROM Payment__c WHERE Id=:paymentId];
                return 'Success';
            }
       return null;
    }
    
    @AuraEnabled
    public static string submitPayment(Object paymentList) {
        List<Payment__c> updatePayment = (List<Payment__c>) JSON.deserialize(JSON.serialize(paymentList), List<Payment__c>.class);
            if(updatePayment != null && !updatePayment.isEmpty()){
                Database.update(updatePayment,false); 
            }

            return 'Success: Payment(s) update successfully';
       
       
       // return '';
    }
}