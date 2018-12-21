trigger ASI_MFM_Plan_BeforeInsert on ASI_MFM_Plan__c (before insert) {
//for KR, added by Leo, 2015-11-06, B6
    if (trigger.new[0].recordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_KR_Plan')){
       ASI_MFM_KR_Plan_TriggerClass.routineBeforeInsert(Trigger.New);  
    }else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
        // Added for SG 2017-12-01 Linus@introv
        ASI_MFM_SG_Plan_TriggerClass.routineBeforeInsert(Trigger.new);
    }else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
        // Added for TR 2018-05-11 Linus@introv
        ASI_MFM_TR_Plan_TriggerClass.routineBeforeInsert(Trigger.new);
        ASI_MFM_TR_Plan_TriggerClass.routineBeforeUpsert(Trigger.new, null);
    }else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC_')){
        ASI_MFM_SC_Plan_TriggerClass.routineBeforeInsert(Trigger.New);  
        ASI_MFM_SC_Plan_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }else if (!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')){
        ASI_MFM_Plan_TriggerClass.routineBeforeInsert(Trigger.New);  
        ASI_MFM_Plan_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')){
        ASI_MFM_CAP_Plan_TriggerClass.routineBeforeInsert(Trigger.New);  
        ASI_MFM_CAP_Plan_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }
    if (trigger.new[0].recordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CN')){
        ASI_MFM_CN_Plan_TriggerClass.routineBeforeInsert(Trigger.New);  
    }
      
}