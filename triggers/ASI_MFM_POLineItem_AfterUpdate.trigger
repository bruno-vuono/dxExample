trigger ASI_MFM_POLineItem_AfterUpdate on ASI_MFM_PO_Line_Item__c (after update) {
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_GF')){
        ASI_MFM_GF_POLineItem_TriggerClass.routineAfterUpsert(trigger.new, trigger.oldmap);
    }else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
        ASI_MFM_SG_POLineItem_TriggerClass.routineAfterUpsert(trigger.new, trigger.oldmap);
    }else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
        // Added by 2018-04-30 Linus@introv
        ASI_MFM_TR_POLineItem_TriggerClass.routineAfterUpsert(trigger.new, trigger.oldmap);
    }else if (trigger.new[0].RecordTypeId != null 
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_SG')
        // Added by Hugo Cheung (Laputa) 05May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_TH')
        // Added by Hugo Cheung (Laputa) 06May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_HK')
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC')) {
        ASI_MFM_POLineItem_TriggerClass.routineAfterUpsert(trigger.new, trigger.oldMap);
        ASI_MFM_POLineItem_TriggerClass.routineAfterAll(trigger.new, trigger.oldMap);   
    }
}