trigger ASI_CRM_Order_Status_AfterUpdate on ASI_CRM_Order_Status__c (after update) {
    if(trigger.new[0].recordTypeId != NULL){
        if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_TW')){
            ASI_CRM_TW_Order_Status_TriggerCls.routineAfterUpsert(trigger.New, trigger.oldMap);
        }
    }
}