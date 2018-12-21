trigger ASI_FOC_Request_Item_AfterInsert on ASI_FOC_Request_Item__c (after insert) {
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_CN')){    
        ASI_FOC_Request_Item_TriggerClass.routineAfterUpsert(trigger.new, null);
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_HK')){
        ASI_FOC_HK_Request_Item_TriggerClass.routineAfterUpsert(trigger.new, null);
    }
    
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_SG_CRM_Request_Items')){
        List<ASI_CRM_SG_TriggerAbstract> triggerClasses = new List<ASI_CRM_SG_TriggerAbstract> {
            new ASI_CRM_SG_RollUpTotal_FreeGoods()
        };
        
        for (ASI_CRM_SG_TriggerAbstract triggerClass : triggerClasses) {
            triggerClass.executeTriggerAction(ASI_CRM_SG_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, null, null);
        }
    }  
    else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_TW')){
        ASI_CRM_TW_RequestItem_TriggerCls.routineAfterUpsert(trigger.New, trigger.oldMap);
    }
}