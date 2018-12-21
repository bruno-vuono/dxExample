global class EUR_CRM_MassUpdateOPAcctMapTermination implements Database.Batchable<sObject> {
    
    global final String query;
    global final String OP_STATUS_ENDED = 'Ended';

    global EUR_CRM_MassUpdateOPAcctMapTermination (){
        // TODO: Refactor using RecordTypeHelper
        String q = 'Select Id, EUR_CRM_Evaluation_Period_End_Date__c, EUR_CRM_Status__c,EUR_CRM_Active_End_Date__c FROM EUR_CRM_ObjPromo__c '+
                    'WHERE (Recordtype.DeveloperName IN (\'EUR_RU_ON_Trade_Phase_2\', \'EUR_RU_Off_Trade_Loyalty_POSM_Placement\')) AND ' +
                    'EUR_CRM_Status__c NOT IN (\'Ended\', \'Deactivated\')';
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('$$SCOPE2: '+scope);
        List<EUR_CRM_ObjPromo__c> objPromotionsList = (List<EUR_CRM_ObjPromo__c>)scope;
        List<EUR_CRM_ObjPromo_Account_Mapping__c> opAcctMapListToUpdate = new List<EUR_CRM_ObjPromo_Account_Mapping__c>();
        Set<Id> opIds = new Set<Id>();
         
        for(EUR_CRM_ObjPromo__c op: objPromotionsList) {
            if(op.EUR_CRM_Active_End_Date__c < Date.Today() && 
                op.EUR_CRM_Evaluation_Period_End_Date__c < Date.Today()) {
                
                opIds.add(op.Id);
                op.EUR_CRM_Status__c = OP_STATUS_ENDED;
            }
        }
        
        for(EUR_CRM_ObjPromo_Account_Mapping__c opMap: [SELECT Id
            FROM EUR_CRM_ObjPromo_Account_Mapping__c WHERE EUR_CRM_ObjPromo__c IN :opIds]) {
        
            opMap.EUR_CRM_Is_Active__c = FALSE;
            opMap.EUR_CRM_Evaluation_Required__c = FALSE;
            opAcctMapListToUpdate.add(opMap);      
        }                

        if(opAcctMapListToUpdate.size() > 0){
            update opAcctMapListToUpdate;
        }

        if(objPromotionsList.size() > 0){
            update objPromotionsList;
        }
                
    }
    
    global void finish(Database.BatchableContext BC) {
        EUR_CRM_BatchApexUtilityClass.sendBatchResultEmail(UserInfo.getUserId(), BC.getJobId(), new String[] {});
    }
}