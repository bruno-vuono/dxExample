/*********************************************************************************
 * Name: EUR_CRM_RU_UpdateAccountManager
 * Description: Automatically update the field 'Manager of the Account Owner' in Account 
 				when the field 'Manager' is updated in User profile
 *
 * Version History
 * Date			Developer	Comments
 * ----------	----------	-------------------------------------------------------
 *	18-1-2017	Kevin Choi		Create the handler class for all EUR affiliates			
*********************************************************************************/


public with sharing class EUR_CRM_UpdateAccountMgrHandlr extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_UpdateAccountMgrHandlr() {
        super('EUR_CRM_UpdateAccountMgrHandlr');
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        Map<Id, Id> userMap = new Map<Id, Id>();
        for (user u : [
                select user.id,isActive, user.ManagerId
                FROM user, user.profile, user.UserRole
                Where user.profile.name like 'EUR%' and user.UserRole.name like 'EUR%' and IsActive = true and ID IN :newMap.keyset()
        ]) {

            if (((User) newMap.get(u.Id)).ManagerId != ((User) oldMap.get(u.Id)).ManagerId) {
                userMap.put(u.id, u.ManagerId);
            }

        }


        List<EUR_CRM_Account__c> accountToUpdate = new List<EUR_CRM_Account__c>();
        Map<Id, Id> accountManagerMap = new Map<Id, Id>();
        for (EUR_CRM_Account__c account : [
                SELECT id, EUR_CRM_Manager_of_Account_Owner__c, RecordtypeId, CreatedById, OwnerId
                FROM EUR_CRM_Account__c
                WHERE OwnerId IN :userMap.keyset()
        ]) {

            Account.EUR_CRM_Manager_of_Account_Owner__c = userMap.get(account.OwnerId);
            accountToUpdate.add(account);
            accountManagerMap.put(account.Id, Account.EUR_CRM_Manager_of_Account_Owner__c);
        }


        if (!System.isBatch() && !System.isScheduled() && !System.isFuture()) {
            if (accountToUpdate.size() < 200) {
//			update accountToUpdate;
                updateAccounts(accountManagerMap);
            } else {
                createBatch(accountToUpdate);
            }
        }
    }

    @Future
    public static void updateAccounts(Map<Id, Id> accountManagerMap) {
        List<EUR_CRM_Account__c> accountToUpdate = new List<EUR_CRM_Account__c>();
        for (EUR_CRM_Account__c accountEur : [
                SELECT Id,
                        EUR_CRM_Manager_of_Account_Owner__c
                FROM EUR_CRM_Account__c
                WHERE Id IN :accountManagerMap.keySet()
        ]) {
            accountEur.EUR_CRM_Manager_of_Account_Owner__c = accountManagerMap.get(accountEur.Id);
            accountToUpdate.add(accountEur);
        }
        if (accountToUpdate.size() > 0) {
            update accountToUpdate;
        }
    }

    @TestVisible
    static void createBatch(List<EUR_CRM_Account__c> accounts) {
        Integer MAX_BATCHES = 10;
        Integer runningBatchJobs = [
                select count()
                from AsyncApexJob
                where JobType = 'BatchApex'
                and status in ('Queued', 'Processing', 'Preparing')
        ];
        if (runningBatchJobs < MAX_BATCHES) {
            //create the postDMLS
            Database.executeBatch(new EUR_CRM_BatchDML_Utility(accounts, 'EUR_CRM_Account__c', EUR_CRM_BatchDML_Utility.Operation.UPDATE_RECORDS, true, null));
        }
    }


}