public class TestFactory {
    public static List<Contact> contactCreation(Integer count){
      list<Contact> contacList = new list<Contact>();
        if(count!=null){
            for(Integer i= 0; i<count; i++){
                Contact contactObj = new Contact();
                contactObj.FirstName = 'My Contact '+count;
                contactObj.LastName = 'Surname';
                contacList.add(contactObj);
            }
        }else{
            Contact contactObj = new Contact();
                contactObj.FirstName = 'My Contact '+count;
                contactObj.LastName = 'Surname';
                contacList.add(contactObj);
        }
        return contacList;
    }
    
    public static List<Project__c> projectCreation(Integer count){
      list<Project__c> projectList = new list<Project__c>();
        if(count!=null){
            for(Integer i= 0; i<count; i++){
                Project__c projectObj = new Project__c();
                projectObj.Name = 'My Project__c '+count;
                projectObj.Most_Recent_Payment_Date__c = System.today();
                projectObj.Total_Amount__c = 100;
                projectList.add(projectObj);
            }
        }else{
            Project__c projectObj = new Project__c();
                projectObj.Name = 'My Project__c '+count;
                projectObj.Most_Recent_Payment_Date__c = System.today();
                projectObj.Total_Amount__c = 100;
                projectList.add(projectObj);
        }
        return projectList;
    }
    
    public static List<Payment__c> paymentCreation(Integer count){
      list<Payment__c> paymentList = new list<Payment__c>();
        if(count!=null){
            for(Integer i= 0; i<count; i++){
                Payment__c paymentObj = new Payment__c();
                paymentObj.Payment_Date__c = System.today();
                 paymentObj.Payment_Amount__c = 100;
                 paymentObj.Payment_Status__c = 'Billed';
                paymentList.add(paymentObj);
            }
        }else{
             Payment__c paymentObj = new Payment__c();
                paymentObj.Payment_Date__c = System.today();
                 paymentObj.Payment_Amount__c = 100;
                 paymentObj.Payment_Status__c = 'Billed';
                paymentList.add(paymentObj);
        }
        return paymentList;
    }
}