public class PaymentDateAndDetails {
    public static void paymentDatePopulate(List<Payment__c> newPaymentList, Map<Id,Payment__c> oldMap){ 
        try{
            System.debug('@@@newPaymentList : '+newPaymentList);
            if(!newPaymentList.isEmpty()){
                Set<Id> paymentContactIdSet = new Set<Id>();
                Set<Id> paymentProjectIdSet = new Set<Id>();
                Map<Id,Decimal> contactIdToTotalAmountMap = new Map<Id,Decimal>();
                Map<Id,Decimal> projectIdToTotalAmountMap = new Map<Id,Decimal>();
                Map<Id,Date> contactIdToRecentDateMap = new Map<Id,Date>();
                Map<Id,Date> projectIdToRecentDateMap = new Map<Id,Date>();
                for(Payment__c pay : newPaymentList){
                    if(pay.Person__c != null && pay.Project__c != null){
                        paymentContactIdSet.add(pay.Person__c);
                        paymentProjectIdSet.add(pay.Project__c);
                    }
                }
                System.debug('@@@paymentContactIdSet : '+paymentContactIdSet);
                System.debug('@@@paymentProjectIdSet : '+paymentProjectIdSet);
                
                List<Payment__c> existingPaymentContList = [SELECT Id,Person__c,Project__c,Payment_Date__c,Payment_Status__c,Payment_Amount__c FROM Payment__c WHERE Payment_Status__c = 'Billed' AND (Project__c =:paymentProjectIdSet OR Person__c =: paymentContactIdSet)];
                System.debug('@@@existingPaymentContList : '+existingPaymentContList);
                if(!existingPaymentContList.isEmpty()){
                    for(Payment__c pay :existingPaymentContList){
                         if(pay.Payment_Amount__c != null){
                             if(contactIdToTotalAmountMap.containsKey(pay.Person__c) && paymentContactIdSet.contains(pay.Person__c)){
                                Decimal totalAmount = contactIdToTotalAmountMap.get(pay.Person__c) + pay.Payment_Amount__c;
                                contactIdToTotalAmountMap.put(pay.Person__c,totalAmount);
                                 Date mostRecentDate = contactIdToRecentDateMap.get(pay.Person__c) > pay.Payment_Date__c ? contactIdToRecentDateMap.get(pay.Person__c) : pay.Payment_Date__c ;
                                 contactIdToRecentDateMap.put(pay.Person__c,mostRecentDate);
                            }else if(paymentContactIdSet.contains(pay.Person__c)){
                                contactIdToTotalAmountMap.put(pay.Person__c,pay.Payment_Amount__c);
                                contactIdToRecentDateMap.put(pay.Person__c,pay.Payment_Date__c);
                            }
                            
                            if(projectIdToTotalAmountMap.containsKey(pay.Project__c)){
                                Decimal totalAmount = projectIdToTotalAmountMap.get(pay.Project__c) + pay.Payment_Amount__c;
                                projectIdToTotalAmountMap.put(pay.Project__c,totalAmount);
                                Date mostRecentDate = projectIdToRecentDateMap.get(pay.Person__c) > pay.Payment_Date__c ? projectIdToRecentDateMap.get(pay.Person__c) : pay.Payment_Date__c ;
                                 projectIdToRecentDateMap.put(pay.Person__c,mostRecentDate);
                            }else if(paymentProjectIdSet.contains(pay.Person__c)){
                                projectIdToTotalAmountMap.put(pay.Project__c,pay.Payment_Amount__c);
                                projectIdToRecentDateMap.put(pay.Project__c,pay.Payment_Date__c);
                            }
                         }
                    }
                    System.debug('@@@contactIdToTotalAmountMap : '+contactIdToTotalAmountMap);
                    System.debug('@@@projectIdToTotalAmountMap : '+projectIdToTotalAmountMap);
                    System.debug('@@@contactIdToRecentDateMap : '+contactIdToRecentDateMap);
                System.debug('@@@projectIdToRecentDateMap : '+projectIdToRecentDateMap);
                }     
                
                if(!paymentContactIdSet.isEmpty() && !paymentProjectIdSet.isEmpty()){
                    List<Contact> contactList =[SELECT Id,Total_Amount_of_Payments__c,Most_Recent_Payment_Date__c FROM Contact Where Id =: paymentContactIdSet];
                    List<Project__c> projectList =[SELECT Id,Total_Amount__c,Most_Recent_Payment_Date__c FROM Project__c Where Id =: paymentProjectIdSet];
                    System.debug('@@@contactList : '+contactList);
                    System.debug('@@@projectList : '+projectList);
                    if(!contactList.isEmpty()){
                        for(Contact cont : contactList){
                            cont.Total_Amount_of_Payments__c = contactIdToTotalAmountMap.get(cont.Id);
                            cont.Most_Recent_Payment_Date__c = contactIdToRecentDateMap.get(cont.Id);
                        }
                        Database.Update(contactList,false);
                    }
                    
                    if(!projectList.isEmpty()){
                        for(Project__c proj : projectList){
                            proj.Total_Amount__c = projectIdToTotalAmountMap.get(proj.Id);
                            proj.Most_Recent_Payment_Date__c = projectIdToRecentDateMap.get(proj.Id);
                        }
                        Database.Update(projectList,false);
                    }
                    
                }
                
            }
        }catch(Exception exp){
            System.debug('Exceeption Occurred : '+exp.getStackTraceString());
        }
    }
}