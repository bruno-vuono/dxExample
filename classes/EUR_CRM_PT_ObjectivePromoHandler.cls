public with sharing class EUR_CRM_PT_ObjectivePromoHandler extends EUR_CRM_TriggerAbstract  {
    public EUR_CRM_PT_ObjectivePromoHandler() {
        super('EUR_CRM_PT_ObjectivePromoHandler');
    }
    private final static Set<String> ptOffTradeNoOfDisplayPromoRecordTypes = new Set<String> {
        'EUR_PT_Off_Trade_OP_No_of_Display'
    };
        
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        
        if(tAction == EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT)
        {
            Map<Id,RecordType> recordTypes = new Map<Id,RecordType>();
            Set<Id> recordTypesId = new Set<Id>();
            
            List<EUR_CRM_OP_Action_List_Template__c> staticTemplateList = new List<EUR_CRM_OP_Action_List_Template__c>();
            staticTemplateList  = [SELECT id FROM EUR_CRM_OP_Action_List_Template__c WHERE EUR_CRM_External_ID__c = 'PT_Check_Off_Trade_Display' LIMIT 1];
            
            for(EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>)sObjList){
                 recordTypesId.add(promo.recordTypeId);
            }
            
            if(recordTypesId.size() > 0) {
                for(RecordType rt : [select id, developername from RecordType where id in:recordTypesId]){
                     recordTypes.put(rt.id,rt);
                }
            }
            
            If (staticTemplateList.size() > 0) 
            {
                for(EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>)sObjList){         
                    String recordTypeDevName = recordTypes.get(promo.recordTypeId).developername;
                    if(ptOffTradeNoOfDisplayPromoRecordTypes.contains(recordTypeDevName))
                    {
                        promo.EUR_CRM_OP_Action_List_Template__c = staticTemplateList[0].Id;
                    }
                }
            }
        }

    }
}