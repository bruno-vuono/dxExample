public with sharing class EUR_CRM_AssignAccountOwnerHandler extends EUR_CRM_TriggerAbstract{

    public EUR_CRM_AssignAccountOwnerHandler() {
        super('EUR_CRM_AssignAccountOwnerHandler');
    }
    
    // Combination of all account record type from all countries
    private static Set<String> accountRecordTypeSet = EUR_CRM_RecordTypeHelper.AssignAccountOwnerHandler_accountRecordTypeSet;
    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(accountRecordTypeSet);
            
            return TRt;
        }private set;
    }


    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        System.Debug('EUR_CRM_AssignAccountOwnerHandler');
        List<EUR_CRM_Account__c> accountList = (List<EUR_CRM_Account__c>) sObjList;
        Set<Id> territoryIds = new Set<Id>();
        
//        System.debug(accountRecordTypeSet);

        List<RecordType> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        Map<Id, RecordType> accountRecordTypesMap = new Map<Id, RecordType>();
        for(RecordType rt: accountRecordTypes) {
            accountRecordTypesMap.put(rt.Id, rt);
        }

        for(EUR_CRM_Account__c acc: accountList) {
//            System.debug(acc.recordTypeId);
//            System.debug(accountRecordTypesMap.get(acc.recordTypeId).DeveloperName);
            if(!accountRecordTypeSet.contains(accountRecordTypesMap.get(acc.recordTypeId).DeveloperName)) {
                // This account does not have account owner territory sharing rule defined
                continue;
            }
            
            if(acc.EUR_CRM_Territory__c != null) {
                territoryIds.add(acc.EUR_CRM_Territory__c);
            }
        }

        /*Map<Id, EUR_CRM_Territory__c> territoryMap = new Map<Id, EUR_CRM_Territory__c>([SELECT Id, Name, EUR_CRM_Territory_Owner__c, EUR_CRM_Territory_Owner__r.Id
                                                                                        FROM EUR_CRM_Territory__c
                                                                                        WHERE Id IN :territoryIds]);*/
        // Calls a helper function to initialize territories map
        EUR_CRM_RecordTypeHelper.getAssignAccountOwnerHandler_initTerritoryMap(territoryIds);
        for(EUR_CRM_Account__c acc: accountList) {
            
            // Calls a function to return account Id based on each account's record type
            Id accountId = EUR_CRM_RecordTypeHelper.getAssignAccountOwnerHandler_ownerId(
                acc,
                accountRecordTypesMap.get(acc.RecordTypeId).DeveloperName
            );
            
            // Only assigns newly returned account id if it exists, otherwise account owner Id is unchanged
            if(accountId != null) {
                acc.OwnerId = accountId;                
            }

        }
    }

}