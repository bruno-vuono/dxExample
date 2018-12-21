public with sharing class EUR_CRM_ZA_OPAccountFlowHandler extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_ZA_OPAccountFlowHandler(){
        super('EUR_CRM_ZA_OPAccountFlowHandler');
    } 

    private static Set<String> allEUAccountOFFTradeRecordTypeSet = new Set<String>{
          'EUR_ZA_On_Trade_Direct',
          'EUR_ZA_On_Trade_Indirect',
          'EUR_ZA_On_Trade_Informal'
    };

    private static Set<String> allEUAccountOFFTradeRecordTypeSet2 = new Set<String>{
          'EUR_ZA_Off_Trade',
          'EUR_ZA_On_Trade_Direct',
          'EUR_ZA_On_Trade_Indirect',
          'EUR_ZA_On_Trade_Informal'
    };

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(allEUAccountOFFTradeRecordTypeSet);
            TRt.addAll(allEUAccountOFFTradeRecordTypeSet2);
            return TRt;
        }private set;
    }

    private static String EUR_ZA_OFF_TRADE = 'EUR_ZA_Off_Trade';
    private static String STATUS_ACTIVE = 'Active';


    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){ 

        System.Debug('EUR_CRM_ZA_OPAccountFlowHandler');

            List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
            Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
            Set<Id> euAcctIds = new Set<Id>();
            Set<Id> oPIds = new Set<Id>();
            Map<Id,List<EUR_CRM_ObjPromo_Account_Mapping__c>> acctOPMap = new Map<Id,List<EUR_CRM_ObjPromo_Account_Mapping__c>>();
            List<EUR_CRM_ObjPromo_Account_Mapping__c> mappingToInactive = new List<EUR_CRM_ObjPromo_Account_Mapping__c>();

            for(Recordtype rt : accountRecordTypes){
               accountRecordTypesMap.put(rt.id,rt);
            }

            for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){
                euAcctIds.add(euAccount.Id);
            }

            for(EUR_CRM_ObjPromo_Account_Mapping__c opAcctMap : [SELECT Id, EUR_CRM_Is_Active__c, EUR_CRM_Evaluation_Required__c, EUR_CRM_Account__c, EUR_CRM_ObjPromo__c FROM EUR_CRM_ObjPromo_Account_Mapping__c WHERE EUR_CRM_Account__c IN :euAcctIds]){
                if(acctOPMap.containsKey(opAcctMap.EUR_CRM_Account__c)){
                    acctOPMap.get(opAcctMap.EUR_CRM_Account__c).add(opAcctMap);
                } else{
                    acctOPMap.put(opAcctMap.EUR_CRM_Account__c, new List<EUR_CRM_ObjPromo_Account_Mapping__c>{opAcctMap});
                }
            }
            
            for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){

                EUR_CRM_Account__c oldEuAccount = tAction == TriggerAction.AFTER_UPDATE ? ((EUR_CRM_Account__c) oldMap.get(euAccount.id)) : null;

                if(allEUAccountOFFTradeRecordTypeSet2.contains(accountRecordTypesMap.get(euAccount.RecordtypeId).DeveloperName)){
                    if(tAction == TriggerAction.AFTER_INSERT){
                        
                    }

                    if(tAction == TriggerAction.AFTER_UPDATE){
                        if(euAccount.EUR_CRM_Status__c != oldEuAccount.EUR_CRM_Status__c){
                            if(euAccount.EUR_CRM_Status__c != STATUS_ACTIVE){
                                if(acctOPMap.containskey(euAccount.Id)){
                                    mappingToInactive.addAll(acctOPMap.get(euAccount.Id));
                                }
                            }

                            if(euAccount.EUR_CRM_Status__c == STATUS_ACTIVE){
                                if(accountRecordTypesMap.get(euAccount.RecordtypeId).DeveloperName == EUR_ZA_OFF_TRADE){
                                    if(euAccount.EUR_CRM_Outlet_Classification__c != '' || euAccount.EUR_CRM_Outlet_Classification__c != null){

                                    }
                                }     
                            }
                        }
                    }
                }
            }

            if(mappingToInactive.size() > 0){
                for(EUR_CRM_ObjPromo_Account_Mapping__c opMap : mappingToInactive){
                    opMap.EUR_CRM_Is_Active__c = false;
                    opMap.EUR_CRM_Evaluation_Required__c = false;
                }

                update mappingToInactive;
            }
    }
}