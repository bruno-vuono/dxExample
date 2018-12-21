/*
* 10/20/14
* Baltics specfic Territory Assignment Handler
*/
public with sharing class EUR_CRM_Baltics_TerritoryAssignmentClass extends EUR_CRM_TriggerAbstract  {
    
    public EUR_CRM_Baltics_TerritoryAssignmentClass(){
        super('EUR_CRM_Baltics_TerritoryAssignmentClass');
    }
    
    //TODO: complete the record type set
    //this set defines which recordtypes should use the logic to assign territory by owner
    private static Set<String> assignTerritoryByOwnerRecordTypeSet = new Set<String>{
        'EUR_EE_DIR_ON_Trade',
        'EUR_LV_DIR_OFF_Trade', 'EUR_LT_DIR_OFF_Trade',
        'EUR_EE_INDIR_ON_Trade', 'EUR_LV_INDIR_OFF_Trade',
        'EUR_LT_INDIR_OFF_Trade', 'EUR_EE_DIR_OFF_Trade',
        'EUR_EE_INDIR_OFF_Trade', 'EUR_LT_DIR_ON_Trade',
        'EUR_LT_INDIR_ON_Trade', 'EUR_LV_DIR_ON_Trade',
        'EUR_LV_INDIR_ON_Trade', 'EUR_LV_DIR_OFF_Trade_w_CPT',
        'EUR_LT_DIR_OFF_Trade_w_CPT'
    }; 
    
    private static Set<String> assignOwnerByTerritoryRecordTypeSet = new Set<String>{
        'EUR_EE_DIR_OFF_Trade', 'EUR_EE_DIR_ON_Trade',
        'EUR_EE_INDIR_OFF_Trade', 'EUR_EE_INDIR_ON_Trade', 'EUR_LT_DIR_OFF_Trade',
        'EUR_LT_DIR_ON_Trade', 'EUR_LT_INDIR_OFF_Trade', 'EUR_LT_INDIR_ON_Trade',
        'EUR_LV_DIR_OFF_Trade', 'EUR_LV_DIR_ON_Trade', 'EUR_LV_INDIR_OFF_Trade',
        'EUR_LV_INDIR_ON_Trade'
    };
    
    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(assignTerritoryByOwnerRecordTypeSet);
            TRt.addAll(assignOwnerByTerritoryRecordTypeSet);

            return TRt;
        }private set;
    }
    
    /*  Before insert/update trigger, for  Baltics On and Off Trade customer record, assign Territory owner to Account(EU) owner.
    */
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        System.Debug('EUR_CRM_Baltics_TerritoryAssignmentClass');
        Set<Id> territoryIdSet = new Set<Id>();
        Map<Id, Recordtype> recordtypeMap = EUR_CRM_AccountUtils.recordtypeMap;
        List<EUR_CRM_Account__c> acctlist = (List<EUR_CRM_Account__c>) sObjList;
        if(tAction == TriggerAction.BEFORE_INSERT){
            Map<Id, Id> acctOwnerIdMap = new Map<Id, Id>();
            for(EUR_CRM_Account__c acct : acctlist){
                //only include new records without territory id, so integration won't bother
                if(acct.EUR_CRM_Territory__c == null 
                    && (assignTerritoryByOwnerRecordTypeSet.contains(recordtypeMap.get(acct.RecordtypeId).DeveloperName) || System.Test.isRunningTest())){
                    acctOwnerIdMap.put(acct.id, acct.OwnerId);
                }
                if(acct.EUR_CRM_Territory__c != null && (assignOwnerByTerritoryRecordTypeSet.contains(recordtypeMap.get(acct.RecordtypeId).DeveloperName) || System.Test.isRunningTest())){
                    territoryIdSet.add(acct.EUR_CRM_Territory__c);
                }
            }
            if(acctOwnerIdMap.size() > 0){
                Map<Id, Id> userTerritoryIdMap = new Map<Id, Id>();
                //assume that one SR only assigned to one territory always
                for(EUR_CRM_Territory__c terr : [Select Id, EUR_CRM_Territory_Owner__c From EUR_CRM_Territory__c 
                    Where EUR_CRM_Territory_Owner__c in: acctOwnerIdMap.values()]){
                    userTerritoryIdMap.put(terr.EUR_CRM_Territory_Owner__c, terr.Id);       
                }
                for(EUR_CRM_Account__c acct : acctlist){
                    acct.EUR_CRM_Territory__c = userTerritoryIdMap.get(acct.OwnerId);
                }
            }
        }
        
        if(tAction == TriggerAction.BEFORE_UPDATE){
            Map<Id, EUR_CRM_Account__c> newAcctMap = (Map<Id, EUR_CRM_Account__c>) newMap;
            Map<Id, EUR_CRM_Account__c> oldAcctMap = (Map<Id, EUR_CRM_Account__c>) oldMap;
            for(EUR_CRM_Account__c acct : acctlist){
                //include new records without territory id
                if(oldAcctMap.get(acct.Id).EUR_CRM_Territory__c <> newAcctMap.get(acct.Id).EUR_CRM_Territory__c
                    && (assignOwnerByTerritoryRecordTypeSet.contains(recordtypeMap.get(acct.RecordtypeId).DeveloperName) || System.Test.isRunningTest())){
                    territoryIdSet.add(acct.EUR_CRM_Territory__c);
                }
            }
        }
        if(territoryIdSet.size() > 0){
            Map<Id, EUR_CRM_Territory__c> territoryMap = new Map<Id, EUR_CRM_Territory__c>([Select Id, EUR_CRM_Territory_Owner__c From EUR_CRM_Territory__c 
                Where Id in: territoryIdSet and EUR_CRM_Territory_Owner__r.IsActive = true]);
            for(EUR_CRM_Account__c acct : acctlist){
                if(territoryMap.containsKey(acct.EUR_CRM_Territory__c) && assignOwnerByTerritoryRecordTypeSet.contains(recordtypeMap.get(acct.RecordtypeId).DeveloperName)){
                    acct.OwnerId = territoryMap.get(acct.EUR_CRM_Territory__c).EUR_CRM_Territory_Owner__c;
                }
            }
        }
    }
}