/*

* edited: Sept.11.2014
*added 2 record types. 'EUR_GB_FS_Blitz', 'EUR_GB_FS_Indirect'

* Edit 10/20/14:
* Removed all EE, LT, LV (Baltics) record types. Those will be processed on its own territory assignment handler, EUR_CRM_Baltics_TerritoryAssignmentClass
*/
public with sharing class EUR_CRM_TerritoryAssignmentHandler extends EUR_CRM_TriggerAbstract  {
    
    public EUR_CRM_TerritoryAssignmentHandler(){
        super('EUR_CRM_TerritoryAssignmentHandler');
    }
    
    //TODO: complete the record type set
    //this set defines which recordtypes should use the logic to assign territory by owner
    private static Set<String> assignTerritoryByOwnerRecordTypeSet = new Set<String>{
        'EUR_CZ_ON_STD', 'EUR_CZ_ON_STD_LOCKED', 
        'EUR_CZ_ON_VO', 'EUR_CZ_ON_VO_LOCKED', 
        'EUR_CZ_ON_CAT', 'EUR_CZ_ON_CAT_LOCKED', 
        'EUR_CZ_OFF_STD', 'EUR_CZ_OFF_STD_LOCKED', 
        'EUR_CZ_OFF_VO', 'EUR_CZ_OFF_VO_LOCKED', 
        'EUR_SK_ON_STD', 'EUR_SK_ON_STD_LOCKED', 
        'EUR_SK_ON_VO', 'EUR_SK_ON_VO_LOCKED', 
        'EUR_SK_ON_CAT', 'EUR_SK_ON_CAT_LOCKED', 
        'EUR_SK_OFF_STD', 'EUR_SK_OFF_STD_LOCKED', 
        'EUR_SK_OFF_VO', 'EUR_SK_OFF_VO_LOCKED',
        'EUR_GB_FS_Indirect',
        'EUR_DE_ON_Consumers',
        'EUR_DE_ON_Enquiry_Acquisition','EUR_DE_ON_Gastronomy',
        'EUR_DE_ON_Service_agency','EUR_DE_ON_Wholesaler'
    }; 
    
    private static Set<String> assignOwnerByTerritoryRecordTypeSet = new Set<String>{
        'EUR_GB_Indies', 'EUR_GB_FS_Blitz', 'EUR_GB_FS_Indirect', //SEPT.11.2014 added 2 record types.
        'EUR_AO_On_Trade', 'EUR_AO_Off_Trade','EUR_KE_Off_Trade',
        'EUR_KE_On_Trade', 'EUR_FI_Direct_On_Trade', 'EUR_FI_Indirect_On_Trade',
        'EUR_FI_Direct_Off_Trade', 'EUR_FI_Indirect_Off_Trade', 'EUR_SE_On_Trade' , 'EUR_SE_Off_Trade','EUR_NL_On_Trade',
        'EUR_NL_Wholesaler' ,'EUR_NL_Off_Trade_Independent','EUR_NL_Off_Trade_Chains' 
    };

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(assignTerritoryByOwnerRecordTypeSet);
            TRt.addAll(assignOwnerByTerritoryRecordTypeSet);
            return TRt;
        }private set;
    }
    
    
    /*  Before insert trigger, for all JB, UK on trade customer record, if the territory field is empty
    *   Check if the owner has a territory code attached to it, if yes
    *   Automatically assign the territory record based on the record owner
    *   before update trigger, when the territory field is filled, automatically assign the owner that matches the territory
    */
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        System.Debug('@@Execute EUR_CRM_TerritoryAssignmentHandler');
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
            System.Debug('@@Execute EUR_CRM_TerritoryAssignmentHandler - Before Update');
            Map<Id, EUR_CRM_Account__c> newAcctMap = (Map<Id, EUR_CRM_Account__c>) newMap;
            Map<Id, EUR_CRM_Account__c> oldAcctMap = (Map<Id, EUR_CRM_Account__c>) oldMap;
            for(EUR_CRM_Account__c acct : acctlist){
                //only include new records without territory id, so integration won't bother
                if(acct.EUR_CRM_Territory__c != null && (oldAcctMap.get(acct.Id).EUR_CRM_Territory__c <> newAcctMap.get(acct.Id).EUR_CRM_Territory__c
                    && assignOwnerByTerritoryRecordTypeSet.contains(recordtypeMap.get(acct.RecordtypeId).DeveloperName) || System.Test.isRunningTest())){
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