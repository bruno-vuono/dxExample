trigger ASI_MFM_POReceipt_BeforeUpdate on ASI_MFM_PO_Receipt__c (before update) {
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_GF')){
        ASI_MFM_POReceipt_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);   
    }
}