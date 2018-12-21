/**
"Assign Territory Owner as Account Owner (New Requirement)
-        No Postal Code mapping for AO and KE
-        1 SR can have many Territory
-        Each SR must have a default territory
-        A new checkbox field “Default”  is added to the Territory
-        When a SR creates an account, the territory field should be already populated with the default territory of the SR
-        If SR has more than 1 territory, he will be able to choose the desired territory of his own territories "
*/
public class EUR_CRM_AO_KE_AccountTerritoryHandler extends EUR_CRM_TriggerAbstract{
    


    public EUR_CRM_AO_KE_AccountTerritoryHandler(){
        super('EUR_CRM_AO_KE_AccountTerritoryHandler');
    }
    private static Set<String> validAccountRecordTypes = new Set<String>{
        'EUR_AO_Off_Trade',
        'EUR_AO_On_Trade',
        'EUR_KE_Off_Trade',
        'EUR_KE_On_Trade'
        };
    private Set<String> validTerritoryRecordTypes = new Set<String>{
        'EUR_AO_Territory',
        'EUR_KE_Territory'
        };

        public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(validAccountRecordTypes);
            return TRt;
        }private set;
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        System.Debug('EUR_CRM_AO_KE_AccountTerritoryHandler');
        List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : accountRecordTypes){
           accountRecordTypesMap.put(rt.id,rt);
        }
        
        Set<Id> territoryOwners = new Set<Id>();
        List<EUR_CRM_Account__c> validAccounts = new List<EUR_CRM_Account__c>();
        
        for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){
            if(validAccountRecordTypes.contains(accountRecordTypesMap.get(euAccount.recordTypeId).developername) &&
                euAccount.EUR_CRM_Territory__c == null){
                validAccounts.add(euAccount);
                territoryOwners.add(euAccount.ownerid);
            }
        }
        
        Map<String,EUR_CRM_Territory__c> userTerritoryMap = new Map<String,EUR_CRM_Territory__c>();
        
        if(territoryOwners.size() > 0)
        for(EUR_CRM_Territory__c territory : [select id,EUR_CRM_Territory_Owner__c,EUR_CRM_Territory_Channel__c from EUR_CRM_Territory__c
            where EUR_CRM_Territory_Owner__c in: territoryOwners and recordtype.developername in: validTerritoryRecordTypes
                and EUR_CRM_Default__c = true ]){
            userTerritoryMap.put('' + territory.EUR_CRM_Territory_Owner__c + territory.EUR_CRM_Territory_Channel__c, territory);
        } 
        
        for(EUR_CRM_Account__c euAccount :  validAccounts){
            EUR_CRM_Territory__c territory = userTerritoryMap.get(''+ euAccount.ownerid + euAccount.EUR_CRM_Channel__c);
            if(territory != null && (territory.EUR_CRM_Territory_Channel__c == euAccount.EUR_CRM_Channel__c || euAccount.EUR_CRM_Channel__c == 'Unconventional'))
                euAccount.EUR_CRM_Territory__c = territory.id;
        }
    }
}