/**
 * 22/05/2015 Vitaly Borysenko - Transform Schedulable job into Batch
 */
global class RIC_WeeklyTaskEmail implements Schedulable,Database.Batchable<SObject> {
    
    @TestVisible
    private static final Integer EMAIL_CNT = 200;
    public Set<Id> userIds = new Set<Id>();
    
    /**
     * Prepare data
     * @param info Batch job
     * @return res
     */
    global Iterable<SObject> start(Database.BatchableContext info){
        
        Set<String> overallStatuses = new Set<String>{'Late None', 'Late In Progress'};
        DateTime expired = System.now().addYears(-1);
        List<Milestone1_Task__c> listMilestone1Tasks = [SELECT Id, Assigned_To__c, Overall_Status__c 
                                                        FROM Milestone1_Task__c 
                                                        WHERE LastModifiedDate > :expired AND (Overall_Status__c = 'Late None' OR Overall_Status__c = 'Late In Progress')
                                                        AND RIC_Status__c = 'En Cours' ]; //Ticket 150 AHA
        return listMilestone1Tasks;
    }
    
    /**
     * Send emails to users
     * @param info Batch job
     * @param scope List whom send email
     */
    global void execute(Database.BatchableContext info, List<SObject> scope){
        
        List<Id> actionsIds = new List<Id>();
        if(scope != null) {
            for(SObject sObj : scope){
                Milestone1_Task__c milestone1Task = (Milestone1_Task__c) sObj;
                if(!userIds.contains(milestone1Task.Assigned_To__c)) {
                    userIds.add(milestone1Task.Assigned_To__c);
                }
                actionsIds.add(milestone1Task.Id);
            }
        }
        
        List<RIC_Acteur__c> listOfActeurs = [SELECT Id, RIC_Acteur_User__c, RIC_Action__c FROM RIC_Acteur__c WHERE RIC_Action__c IN :actionsIds];
        if(listOfActeurs != null){
            for(RIC_Acteur__c acteur : listOfActeurs) {
                if(!userIds.contains(acteur.RIC_Acteur_User__c)) {
                    userIds.add(acteur.RIC_Acteur_User__c);
                }
            }   
        }
        List<user> listOfuser = new list<user>();
        for(Id userId : userIds){
            user u = new user();
            u.id=userId;
            u.RIC_SendEmail__c=true;
            listOfuser.add(u);
        }
        if(listOfuser!=null && listOfuser.size()>0){
            update listOfuser;
        }
    }
    
    /**
     * Required batch finish method
     * @param info Batch job
     */ 
    global void finish(Database.BatchableContext info){
        List<user> userIds = [Select id,RIC_SendEmail__c
                              from user
                              where RIC_SendEmail__c=true];
        List<Messaging.SingleEmailMessage> listEmails = new List<Messaging.SingleEmailMessage>();
        for(user userId : userIds){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();            
            email.setTemplateId(Label.RIC_WeeklyTaskEmail_ID);
            email.setSaveAsActivity(false);            
            email.setTargetObjectId(userId.id);
            listEmails.add(email);
            userId.RIC_SendEmail__c=false;
        }
        Messaging.sendEmail(listEmails);
        update userIds;
        
    } 
    
    /**
     * Run by schedule, execute batch
     * @param sc Schedulable job
     */
    global void execute(SchedulableContext sc){
        Database.executeBatch(new RIC_WeeklyTaskEmail(), EMAIL_CNT);
    }
}

/*global class RIC_WeeklyTaskEmail implements Schedulable {

    global void execute(SchedulableContext sc) {   
    
        List<AggregateResult> Res= [SELECT Assigned_To__c FROM Milestone1_Task__c WHERE Overall_Status__c = 'Late None' OR Overall_Status__c = 'Late In Progress' Group By Assigned_To__c];
        
        for(AggregateResult t: Res) {   
        
            Id Idd = (Id) t.get('Assigned_To__c');
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            email.setTemplateId(Label.RIC_WeeklyTaskEmail_ID);
            email.setSaveAsActivity(false);
            
            email.setTargetObjectId(Idd);
            System.debug('ID: ' + Idd);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});  
            
        
        }
}

}*/