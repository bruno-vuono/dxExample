public with sharing class EUR_CRM_TerritoryOwnerChanged extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_TerritoryOwnerChanged() {
        super('EUR_CRM_TerritoryOwnerChanged');
    }

    // REFACTORING: Get valid Record types from the record type helper
    // DO NOT HARD CODE RECORD TYPES ON THIS FILE
    private Set<String> validRecordTypes = EUR_CRM_RecordTypeHelper.TerritoryOwnerChanged_validRecordTypes;

    private final String TERRITORY_NG_DEV_NAME = 'EUR_CRM_NG_Territory';
    private final String TERRITORY_MA_DEV_NAME = 'EUR_MA_Territory';
//    final Set<String> COUNTRY_CODES_TO_UPDATE_ACCOUNT_OWNER = new Set<String>{
//            'RU'
//    };

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        if (tAction == TriggerAction.BEFORE_UPDATE && !isBypassByCurrentUser()) {
            beforeUpdateAction(sObjList, newMap, oldMap);
        }
        if (tAction == TriggerAction.AFTER_UPDATE) {
            afterUpdateAction(sObjList, newMap);
        }

        // MAR.16.2015
//      if(tAction == TriggerAction.AFTER_UPDATE || tAction == TriggerAction.AFTER_INSERT){
//          system.debug('### flag 1');
//        List<Recordtype> territoryRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Territory__c');
//        Map<Id,Recordtype> territoryRecordTypesMap = new Map<Id,Recordtype>();
//
//        for(Recordtype rt : territoryRecordTypes){
//           territoryRecordTypesMap.put(rt.id,rt);
//        }
//
//        Set<Id> validTerritories = new Set<Id>();
//        for(EUR_CRM_Territory__c territory : (List<EUR_CRM_Territory__c>) sObjList){
//          String territoryRTDevName = territoryRecordTypesMap.get(territory.recordtypeid).developername;
//          if(validRecordTypes.contains(territoryRTDevName) && (
//            Trigger.isInsert || (Trigger.isUpdate && territory.EUR_CRM_Territory_Owner__c
//            != ((EUR_CRM_Territory__c )oldMap.get(territory.id)).EUR_CRM_Territory_Owner__c))){
//            validTerritories.add(territory.id);
//          }
//        }
//
//          system.debug('### validTerritories ' + validTerritories);
//        if(validTerritories.size() > 0 ){
//          List<EUR_CRM_Account__c> accountForUpdate = new List<EUR_CRM_Account__c>();
//
//          for(EUR_CRM_Account__c account : [select id,EUR_CRM_Territory__c, ownerid from EUR_CRM_Account__c where EUR_CRM_Territory__c in: validTerritories]){
//
//            account.ownerid = ((EUR_CRM_Territory__c) newMap.get(account.EUR_CRM_Territory__c)).EUR_CRM_Territory_Owner__c;
//            accountForUpdate.add(account);
//          }
//           system.debug('### accountForUpdate' + accountForUpdate);
//          if(accountForUpdate.size() > 0)
//            update accountForUpdate;
//        }
//      }
    }
    void beforeUpdateAction(List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        List<EUR_CRM_Territory__c> teryList = (List<EUR_CRM_Territory__c>) sObjList;
        Map<ID, EUR_CRM_Territory__c> oldTeryMap = (Map<ID, EUR_CRM_Territory__c>) oldMap;
        List<EUR_CRM_Territory__c> teryToUpdate = new List<EUR_CRM_Territory__c>();

        List<Recordtype> territoryTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Territory__c');
        Id territoryNGId;
        Id territoryMAId;

        for (Recordtype rt : territoryTypes) {
            if (rt.DeveloperName == TERRITORY_NG_DEV_NAME) {
                territoryNGId = rt.Id;
            } else if (rt.DeveloperName == TERRITORY_MA_DEV_NAME) {
                territoryMAId = rt.Id;
            }
        }

        for (EUR_CRM_Territory__c tery : teryList) {

            if (tery.EUR_CRM_Territory_Owner__c != oldTeryMap.get(tery.id).EUR_CRM_Territory_Owner__c ||
                    tery.EUR_CRM_Off_Trade_Owner__c != oldTeryMap.get(tery.id).EUR_CRM_Off_Trade_Owner__c ||
                    tery.EUR_CRM_On_Trade_Owner__c != oldTeryMap.get(tery.id).EUR_CRM_On_Trade_Owner__c) {
                tery.EUR_CRM_IsOwnerChanged__c = true;
            }

            // IF TERRITORY is NG or MA
            // Owner can be from multiple sources, OFF Trade Owner, ON Trade Owner, or KD Owner (NG Only)
            if (tery.RecordTypeId == territoryNGId || tery.RecordTypeId == territoryMAId) {
                if ((tery.EUR_CRM_KD_Owner__c != oldTeryMap.get(tery.id).EUR_CRM_KD_Owner__c) ||
                        (tery.EUR_CRM_Off_Trade_Owner__c != oldTeryMap.get(tery.id).EUR_CRM_Off_Trade_Owner__c) ||
                        (tery.EUR_CRM_On_Trade_Owner__c != oldTeryMap.get(tery.id).EUR_CRM_On_Trade_Owner__c)) {
                    tery.EUR_CRM_IsOwnerChanged__c = true;
                }
            }

        }
    }
    void afterUpdateAction(List<sObject> sObjList, Map<ID, sObject> newMap) {
        List<EUR_CRM_Account__c> accountsToUpdate = new List<EUR_CRM_Account__c>();
        List<EUR_CRM_Account__c> accounts = [
                SELECT Id
                        ,OwnerId
                        ,EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__c
                FROM EUR_CRM_Account__c
                WHERE
                EUR_CRM_Territory__c IN :newMap.keySet()
                AND EUR_CRM_Territory__r.EUR_CRM_IsOwnerChanged__c = true
        ];
        if (accounts.size() < 100) {
            for (EUR_CRM_Account__c account : accounts) {
                if (account.EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__c !=null) {
                    account.OwnerId = account.EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__c;
                    accountsToUpdate.add(account);
                }
            }
            update accountsToUpdate;

        } else if (!System.isFuture() && !System.isBatch()) {
            createMassUpdateBatch(newMap.keySet());

        }
    }

    @TestVisible
    void createMassUpdateBatch(Set<Id> territoryIds){
        EUR_CRM_MassUpdateAccountOwner updateBatch = new EUR_CRM_MassUpdateAccountOwner(territoryIds);
        Database.executeBatch(updateBatch, 100);
    }

}