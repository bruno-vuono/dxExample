/**
General Trigger Handler for Objective/Promotion.
BEFORE Insert, Update
Functions:
"Create Triggers on object: EUR_CRM_ObjPromo_Action__c 
Before Update, Before Insert"
*/

public with sharing class EUR_CRM_FI_ObjectivePromoHandler extends EUR_CRM_TriggerAbstract {
    
    public EUR_CRM_FI_ObjectivePromoHandler (){
        super('EUR_CRM_FI_ObjectivePromoHandler');
    }
    
    private final static Set<String> objPromoRecordTypeSet = new Set<String>{
        'EUR_FI_Off_Trade_O_P',
        'EUR_FI_On_Trade_O_P' 
        
    };
    
    private final static Map<String,String> opActionMap = new Map<String,String>{
       'Type 1' => 'FI_Type_01',
       'Type 2' => 'FI_Type_02' 
       
    };
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        List<Recordtype> recordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_ObjPromo__c');
        Map<Id,Recordtype> opRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : recordTypes){
           opRecordTypesMap.put(rt.id,rt);
        } 
         Set<String> externalIds = new Set<String>(); 
         List<EUR_CRM_ObjPromo__c> validOPs = new List<EUR_CRM_ObjPromo__c>();
         for(EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>)sObjList){
             String recordTypeDevName = opRecordTypesMap.get(promo.recordTypeId).developername;
             if(objPromoRecordTypeSet.contains(recordTypeDevName))
                validOPs.add(promo);
         }
         if(validOPS.size() > 0){
            Map<String,id> actionListTemplateMap = new Map<String,id>();
          
            for(EUR_CRM_OP_Action_List_Template__c actionListTemplate: [select id,EUR_CRM_External_ID__c from EUR_CRM_OP_Action_List_Template__c where EUR_CRM_External_ID__c in: opActionMap.values()]){
                 actionListTemplateMap.put(actionListTemplate.EUR_CRM_External_ID__c , actionListTemplate.id);
            }

            for(EUR_CRM_ObjPromo__c promo :validOPS){          
                String key = opActionMap.get( promo.EUR_CRM_O_P_Type__c);
                if(key != null){
                    promo.EUR_CRM_OP_Action_List_Template__c = actionListTemplateMap.get(key);
                }
            } 
         }
    }    
}