trigger ASI_CRM_KR_PVAGuideline_BeforeInsert on ASI_CRM_KR_A_P_Guideline__c (before insert) {
	ASI_CRM_KR_PVAGuideline_TriggerClass.routineBeforeUpsert(trigger.new,null); 
}