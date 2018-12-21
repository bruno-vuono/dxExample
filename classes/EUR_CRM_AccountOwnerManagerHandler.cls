public with sharing class EUR_CRM_AccountOwnerManagerHandler extends EUR_CRM_TriggerAbstract{
    
    public EUR_CRM_AccountOwnerManagerHandler(){
        super('EUR_CRM_AccountOwnerManagerHandler');
    }
    
    //before insert or update trigger to get RSM of the SR on the account record
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        List<EUR_CRM_Account__c> acctlist = (List<EUR_CRM_Account__c>) sObjList;
        Map<Id, EUR_CRM_Account__c> oldAcctMap = (Map<Id, EUR_CRM_Account__c>) oldMap; 
        Set<Id> ownerIdSet = new Set<Id>();
        for(EUR_CRM_Account__c acct : acctlist){
            if(tAction == TriggerAction.BEFORE_INSERT || (tAction == TriggerAction.BEFORE_UPDATE))
                ownerIdSet.add(acct.OwnerId);   
        }
        if(ownerIdSet.size()>0){
            Map<Id, User> userMap = new Map<Id, User>([Select Id, ManagerId From User Where Id in: ownerIdSet and ManagerId != null]);
            for(EUR_CRM_Account__c acct : acctlist){
                if(userMap.containsKey(acct.OwnerId))
                    acct.EUR_CRM_Manager_of_Account_Owner__c = userMap.get(acct.OwnerId).ManagerId;
            }
        }   
    }
    
}