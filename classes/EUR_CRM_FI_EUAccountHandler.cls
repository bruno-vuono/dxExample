public with sharing class EUR_CRM_FI_EUAccountHandler extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_FI_EUAccountHandler(){
        super('EUR_CRM_FI_EUAccountHandler');
    } 

    private static Set<String> allEUAccountRecordTypeSet = new Set<String>{
          'EUR_FI_Direct_Off_Trade',
          'EUR_FI_Direct_On_Trade',
          'EUR_FI_Indirect_Off_Trade',
          'EUR_FI_Indirect_On_Trade'
    };

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(allEUAccountRecordTypeSet);
            return TRt;
        }private set;
    }


    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){ 

        List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        List<Recordtype> visitFrequencyTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Visit_Frequency__c');
        Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
        Map<Id,Recordtype> visitFrequencyTypesMap = new Map<Id,Recordtype>();

        Id onceInAHalfYearId;
        Id onceAQuarterId;
        Id finlandVisitFrequencyType;
        
        for(Recordtype rt : accountRecordTypes){
           accountRecordTypesMap.put(rt.id,rt);
        }

        if(tAction == TriggerAction.BEFORE_INSERT){
            for(Recordtype rt : visitFrequencyTypes){
               if(rt.DeveloperName == 'EUR_FI_Visit_Frequency'){
                    finlandVisitFrequencyType = rt.Id;
                    break;
               }
            }
            for(EUR_CRM_Visit_Frequency__c visitFrequency : [SELECT Id, Name FROM EUR_CRM_Visit_Frequency__c WHERE RecordtypeId = :finlandVisitFrequencyType]){
                if(visitFrequency.Name == 'Once a quarter'){
                    onceAQuarterId = visitFrequency.Id;
                }
                if(visitFrequency.Name == 'Once every 6 months'){
                    onceInAHalfYearId = visitFrequency.Id;
                }
            }
        }

        for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){

            String accountRecordTypeDeveloperName = accountRecordTypesMap.get(euAccount.RecordtypeId).DeveloperName;
            EUR_CRM_Account__c oldEuAccount = tAction == TriggerAction.BEFORE_UPDATE ? ((EUR_CRM_Account__c) oldMap.get(euAccount.id)) : null;

            if(euAccount.EUR_CRM_Visit_Frequency__c == null){
                if(allEUAccountRecordTypeSet.contains(accountRecordTypeDeveloperName) &&
                    (tAction == TriggerAction.BEFORE_INSERT)){

                    if(accountRecordTypeDeveloperName == 'EUR_FI_Indirect_Off_Trade' || accountRecordTypeDeveloperName == 'EUR_FI_Direct_Off_Trade'){
                        euAccount.EUR_CRM_Visit_Frequency__c = onceAQuarterId;
                    }

                    if(accountRecordTypeDeveloperName == 'EUR_FI_Direct_On_Trade' || accountRecordTypeDeveloperName == 'EUR_FI_Indirect_On_Trade'){
                        euAccount.EUR_CRM_Visit_Frequency__c = onceInAHalfYearId;
                    }

                }
            }
            
            //Added  Field update to remove the Parent account field if the outler changed to Head Office
            
            if(allEUAccountRecordTypeSet.contains(accountRecordTypeDeveloperName) && euAccount.EUR_CRM_Business_Type__c == 'Head Office' ){
                euAccount.EUR_CRM_Parent_Account__c = null;
            }
        }
    }

}