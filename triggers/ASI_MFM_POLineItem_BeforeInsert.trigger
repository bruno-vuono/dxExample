trigger ASI_MFM_POLineItem_BeforeInsert on ASI_MFM_PO_Line_Item__c (before insert) {
    if(trigger.new[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_KR')){
    ASI_MFM_POLineItem_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null); 
        ASI_MFM_KR_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }else if(trigger.new[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_HK')){
        ASI_MFM_HK_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
    // Added by 2017-12-15 Linus@introv
        ASI_MFM_SG_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_GF')){
    // Added by 2017-12-28 Linus@introv
        ASI_MFM_GF_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
    // Added by 2018-04-30 Linus@introv
        ASI_MFM_TR_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }else if (trigger.new[0].RecordTypeId != null 
      && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_SG')
        // Added by Hugo Cheung (Laputa) 05May2016
      && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_TH')
        // Added by Hugo Cheung (Laputa) 06May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_HK')
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC')) {
        ASI_MFM_POLineItem_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    } else if (trigger.new[0].RecordTypeId != null 
      && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_TW')) {

        ASI_MFM_POLineItem_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }
}