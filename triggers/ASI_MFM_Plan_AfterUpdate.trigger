trigger ASI_MFM_Plan_AfterUpdate on ASI_MFM_Plan__c (after update) {
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
        // Added by 2018-03-15 Linus@introv
        ASI_MFM_SG_Plan_TriggerClass.routineAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    else if (!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')
            && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC_')){
        ASI_MFM_Plan_TriggerClass.routineAfterUpsert(Trigger.new, Trigger.oldMap);
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')){
        ASI_MFM_CAP_Plan_TriggerClass.routineAfterUpsert(Trigger.new, Trigger.oldMap);
    }   
    // Added by Alan Wong (Elufa) 25Feb2015
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_MFM_KR')){
       ASI_MFM_KR_Plan_TriggerClass.routineAfterUpdate(Trigger.new, Trigger.oldMap); 
    }
    //Added by Introv @20170113
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_MFM_TW')){
        ASI_MFM_Plan_TriggerClass.routineAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
}