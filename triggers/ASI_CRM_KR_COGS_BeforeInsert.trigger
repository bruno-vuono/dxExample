trigger ASI_CRM_KR_COGS_BeforeInsert on ASI_CRM_KR_COGS__c (before insert) {
	ASI_CRM_KR_COGS_TriggerClass.routineBeforeInsert(trigger.new);   
}