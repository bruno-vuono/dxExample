trigger ASI_MFM_PO_AfterInsert on ASI_MFM_PO__c (after insert) {

    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG'))
    {
        ASI_MFM_SG_PO_TriggerClass.routineAfterInsert(trigger.new);
    }
    else if (!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC')){ 
      
        ASI_MFM_PO_TriggerClass.routineAfterInsert(trigger.new);
        ASI_MFM_PO_TriggerClass.routineAfterAll(trigger.new, null);
        ASI_MFM_PO_TriggerClass.routineAfterUpsert(trigger.new, null);
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP') 
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('SG')
        // Added by Hugo Cheung (Laputa) 05May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('TH')
        // Added by Hugo Cheung (Laputa) 06May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('HK')
        //20170207 Elufa
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_CN_Structure_Cost')
       ){ 
        ASI_MFM_CAP_PO_TriggerClass.routineAfterInsert(trigger.new);
        ASI_MFM_CAP_PO_TriggerClass.routineAfterAll(trigger.new, null);
        ASI_MFM_CAP_PO_TriggerClass.routineAfterUpsert(trigger.new, null);
    }   
}