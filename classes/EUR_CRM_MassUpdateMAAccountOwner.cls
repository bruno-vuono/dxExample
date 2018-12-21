/**
*   Class: EUR_CRM_MassUpdateMAAccountOwner
*   Description: Apex Batch Job Class to update the owner and sharing access of the account related to the territories
*/
global class EUR_CRM_MassUpdateMAAccountOwner implements Database.Batchable<sObject>, Database.Stateful{
    global final String query;
    
    // Checking if user or role exist in the sharing of account. Key is made as ParentID + UserORGroupID
    // For custom object EU Account
    global Set<String> sharingAccountEUKeys;

    // Checking if user or role exist in the sharing of account. Key is made as ParentID + UserORGroupID
    // For Standard Account
    global Set<String> sharingAccountStdKeys;
    
    global EUR_CRM_MassUpdateMAAccountOwner(String q) {
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    // Main Logic Implementation
    global void execute(Database.Batchablecontext BC, List<sObject> scope) {
        List<EUR_CRM_Account__c> acctList = (List<EUR_CRM_Account__c>)scope;
        List<EUR_CRM_Account__c> acctToUpdateList = new List<EUR_CRM_Account__c>();
        
        Set<Id> territoryIDSet = new Set<Id>();
        Map<Id, Id> accountTerritoryShare = new Map<Id, Id>();
        
        String MA_ON_TRADE = 'EUR_MA_On_Trade';
        String MA_OFF_TRADE = 'EUR_MA_Off_Trade';
        
        List<RecordType> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        Map<Id, RecordType> accountRecordTypesMap = new Map<Id, RecordType>();
        
        List<EUR_CRM_Account__Share> euAcctShareList = new List<EUR_CRM_Account__Share>();
        List<AccountShare> stdAcctShareList = new List<AccountShare>();
        
        for(RecordType rt: accountRecordTypes) {
            accountRecordTypesMap.put(rt.Id, rt);
        }
        
        Set<ID> userIds = new Set<ID>();
        
        System.debug(acctList);
        for (EUR_CRM_Account__c acct: acctList) {
            Boolean isChanged = false;
            
            if(acct.EUR_CRM_Territory__c != null) {
                System.debug(accountRecordTypesMap.get(acct.RecordTypeId));
                if(accountRecordTypesMap.get(acct.RecordTypeId).DeveloperName == MA_ON_TRADE) {
                    if(acct.EUR_CRM_Territory__r.EUR_CRM_On_Trade_Owner__c != null) {
                        acct.OwnerId = acct.EUR_CRM_Territory__r.EUR_CRM_On_Trade_Owner__c;
                        territoryIDSet.add(acct.EUR_CRM_Territory__c);
                        isChanged = true;
                        userIds.add(acct.EUR_CRM_Territory__r.EUR_CRM_On_Trade_Owner__c);
                    }
                } else if(accountRecordTypesMap.get(acct.RecordTypeId).DeveloperName == MA_OFF_TRADE){
		             if (acct.EUR_CRM_Territory__r.EUR_CRM_Off_Trade_Owner__c != null){

		                acct.OwnerID = acct.EUR_CRM_Territory__r.EUR_CRM_Off_Trade_Owner__c;
		                territoryIDSet.add(acct.EUR_CRM_Territory__c);
		                isChanged  = true;
		                userIds.add(acct.EUR_CRM_Territory__r.EUR_CRM_Off_Trade_Owner__c);
		             }
                }
            }
            
		    if(isChanged) {
		        acctToUpdateList.add(acct);
		    }
        }
        
        System.debug(acctToUpdateList);
        if (acctToUpdateList.size() > 0){
            update acctToUpdateList;
        }
        
        List<EUR_CRM_Territory__c> territoriesToUpdate = [SELECT Id, Name, EUR_CRM_IsOwnerChanged__c FROM EUR_CRM_Territory__c WHERE Id IN :territoryIDSet];
        System.debug(territoriesToUpdate);
        for(EUR_CRM_Territory__c i: territoriesToUpdate) {
            i.EUR_CRM_IsOwnerChanged__c = false;
        }
        
        if(territoriesToUpdate.size() > 0) {
            update territoriesToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob apexJob = [SELECT Id FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        EUR_CRM_BatchApexUtilityClass.sendBatchResultEmail(UserInfo.getUserId(), apexJob.Id, new String[]{});
    }
}