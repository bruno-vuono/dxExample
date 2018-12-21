public with sharing class EUR_CRM_ObjectivePromoHandler extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_ObjectivePromoHandler() {
        super('EUR_CRM_ObjectivePromoHandler');
    }
    
    private final static Map<String, String> opActionMap = EUR_CRM_RecordTypeHelper.ObjectivePromoHandler_opActionMap;
    private final static Set<String> emPricePromotionRecordTypes = new Set<String> {
        'EUR_DK_Off_Trade_EM_Price_Promotion'
    };
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
         Map<Id,RecordType> recordTypes = new Map<Id,RecordType>();
         Set<Id> recordTypesId = new Set<Id>();
         Set<String> externalIds = new Set<String>();

         for(EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>)sObjList){
             recordTypesId.add(promo.recordTypeId);
         }
         
         if(recordTypesId.size() > 0) {
             for(RecordType rt : [select id, developername from RecordType where id in:recordTypesId]){
                 recordTypes.put(rt.id,rt);
                 if(opActionMap.get(rt.developername) != null) {
                     externalIds.add(opActionMap.get(rt.developername));                     
                 }
             }
         }
         
         Map<String,id> actionListTemplateMap = new Map<String,id>();
         
         if(externalIds.size() > 0) {
             for(EUR_CRM_OP_Action_List_Template__c actionListTemplate: [select id,EUR_CRM_External_ID__c from EUR_CRM_OP_Action_List_Template__c where EUR_CRM_External_ID__c in: externalIds]){
                 actionListTemplateMap.put(actionListTemplate.EUR_CRM_External_ID__c , actionListTemplate.id);
             }             
         }
        
         for(EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>)sObjList){         
             String recordTypeDevName = recordTypes.get(promo.recordTypeId).developername;
                        
             if(opActionMap.keySet().contains(recordTypeDevName)){
                 String key = opActionMap.get(recordTypeDevName);
                 if(key != null && actionListTemplateMap.get(key) != null){
                     promo.EUR_CRM_OP_Action_List_Template__c = actionListTemplateMap.get(key);
                 }else{
                     promo.addError('No Action List Template found for this type of Objective / Promotion');
                 }
                 
                 if(tAction == EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT && !emPricePromotionRecordTypes.contains(recordTypeDevName)){
                     promo.EUR_CRM_Status__c = 'Draft';
                 }
             }             
         }
    }

}