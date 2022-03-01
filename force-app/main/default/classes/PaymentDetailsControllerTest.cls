@isTest
public class PaymentDetailsControllerTest {
 @testSetup static void setup() {
       List<Contact> contList= TestFactory.contactCreation(1);
        insert contList;
     
        List<Project__c> projectList= TestFactory.projectCreation(1);
     projectList[0].Person__c =contList[0].id;
        insert projectList;
     
     	List<Payment__c> paymentList= TestFactory.paymentCreation(1);
     paymentList[0].Person__c =contList[0].id;
         paymentList[0].Project__c=projectList[0].id;
        insert paymentList;
    }
    
    @isTest static void testWarmTemp() {
         List<Contact> pifList = [Select Id FROM Contact];
        PaymentDetailsController.getContactDetails();
    }
    
    @isTest static void testGetPaymentListp() {
        List<Contact> contList = [Select Id FROM Contact limit 1];
         List<Payment__c> pifList = [Select Id,Name,Project__r.Name,Payment_Amount__c, Payment_Date__c, Payment_Status__c, Person__c,Method_of_Payment__c FROM Payment__c];
        PaymentDetailsController.getPaymentList(contList[0].Id);
    }
    
    @isTest static void testsubmitContact() {
        List<Contact> contList = [Select Id FROM Contact limit 1];
         List<Payment__c> pifList = [Select Id,Name,Project__r.Name,Payment_Amount__c, Payment_Date__c, Payment_Status__c, Person__c,Method_of_Payment__c FROM Payment__c];
        PaymentDetailsController.submitContact(contList);
    }
    
     @isTest static void testdeletePayment() {
        List<Contact> contList = [Select Id FROM Contact limit 1];
         List<Payment__c> pifList = [Select Id,Name,Project__r.Name,Payment_Amount__c, Payment_Date__c, Payment_Status__c, Person__c,Method_of_Payment__c FROM Payment__c];
        PaymentDetailsController.deletePayment(pifList[0].Id);
    }
    
     @isTest static void testsubmitPayment() {
        List<Contact> contList = [Select Id FROM Contact limit 1];
         List<Payment__c> pifList = [Select Id,Name,Project__r.Name,Payment_Amount__c, Payment_Date__c, Payment_Status__c, Person__c,Method_of_Payment__c FROM Payment__c];
        PaymentDetailsController.submitPayment(pifList);
    }
}