public with sharing class PaymentHandler implements ITrigger {
    public PaymentHandler() {
        
    }

    public void bulkBefore() {
        
    }



    public void bulkAfter() {
        
    }

    public void beforeInsert(SObject so) {

    }

    public void beforeUpdate(SObject oldSo, SObject so) {  

    }

    public void beforeDelete(SObject so) {

    }

    public void afterInsert(SObject so) {
		PaymentDateAndDetails.paymentDatePopulate(Trigger.new,null);
    }

    public void afterUpdate(SObject oldSo, SObject so) {
		PaymentDateAndDetails.paymentDatePopulate(Trigger.new, (Map<Id,Payment__c>) Trigger.oldMap);
    }

    public void afterDelete(SObject so) {
        PaymentDateAndDetails.paymentDatePopulate(Trigger.old,null);
    }
    public void andFinally() {

    }
}