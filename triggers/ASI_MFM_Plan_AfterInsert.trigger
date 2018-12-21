trigger ASI_MFM_Plan_AfterInsert on ASI_MFM_Plan__c (after insert) {
     if(trigger.new[0].RecordTypeId != null &&  Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_KR')){
        ASI_MFM_KR_Plan_TriggerClass.routineAfterInsert(Trigger.new);
     }else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
        // Added by 2018-03-15 Linus@introv
        ASI_MFM_SG_Plan_TriggerClass.routineAfterInsert(Trigger.new);
     }else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
        // Added by 2018-05-30 Linus@introv
        ASI_MFM_TR_Plan_TriggerClass.routineAfterInsert(Trigger.new);
     }else if (!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP') 
         && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC')){
        //System.debug('Enter After Trigger1');
        ASI_MFM_Plan_TriggerClass.routineAfterInsert(Trigger.new);
        //System.debug('Enter After Trigger2');
        ASI_MFM_Plan_TriggerClass.routineAfterUpsert(Trigger.new, null); 
        //System.debug('Leave After Trigger');
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')){
        ASI_MFM_CAP_Plan_TriggerClass.routineAfterInsert(Trigger.new);
        ASI_MFM_CAP_Plan_TriggerClass.routineAfterUpsert(Trigger.new, null);   
    }
}