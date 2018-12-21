trigger ASI_MFM_POReceipt_AfterUpdate on ASI_MFM_PO_Receipt__c (after update) {
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_GF')){
        ASI_MFM_POReceipt_TriggerClass.routineAfterUpdate(trigger.new, trigger.oldMap);   
    }
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
        ASI_MFM_POReceipt_TriggerClass.routineAfterUpdate(trigger.new, trigger.oldMap);   
    }
}