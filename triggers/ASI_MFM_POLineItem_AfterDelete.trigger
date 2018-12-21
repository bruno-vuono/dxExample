trigger ASI_MFM_POLineItem_AfterDelete on ASI_MFM_PO_Line_Item__c (after delete) {
    if (trigger.old[0].RecordTypeId != null 
        && !Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_MFM_CAP_SG')
        // Added by Hugo Cheung (Laputa) 05May2016
        && !Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_MFM_CAP_TH')
        // Added by Hugo Cheung (Laputa) 06May2016
        && !Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_MFM_CAP_HK')
        && !Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_MFM_SC')) {
        ASI_MFM_POLineItem_TriggerClass.routineAfterAll(null, trigger.oldMap); 
    } 
}