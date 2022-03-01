trigger PaymentTrigger on Payment__c (after delete, after insert, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(Payment__c.sObjectType);
}