trigger ASI_MFM_PlanLineItem_BeforeInsert on ASI_MFM_Plan_Line_Item__c (before insert) {        
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TW')){
        ASI_MFM_TW_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }        
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CN')){
        ASI_MFM_CN_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
	else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
        ASI_MFM_SG_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_MY')){
        ASI_MFM_MY_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
    /*else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_HK')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_GF')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_RM')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_JP')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }    
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }    
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TH')){
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
    }*/
    else 
        ASI_MFM_PlanLineItem_TriggerClass.routineBeforeUpsert(Trigger.New, null);
}