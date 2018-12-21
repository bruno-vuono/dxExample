trigger ASI_CRM_KR_PVAGuideline_BeforeUpdate on ASI_CRM_KR_A_P_Guideline__c (before update) {
    ASI_CRM_KR_PVAGuideline_TriggerClass.routineBeforeUpsert(trigger.new,null); 
}