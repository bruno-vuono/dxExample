trigger ASI_CRM_KR_PVA_BeforeInsert on ASI_CRM_KR_PVA__c (before insert) {
	
       ASI_CRM_KR_PVA_TriggerClass.routineBeforeInsert(trigger.new);
    
}