trigger ASI_CRM_KR_PVA_BeforeUpdate on ASI_CRM_KR_PVA__c (before update) {
	if (Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_CRM_KR_PVA') ){
        ASI_CRM_KR_PVA_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
    }
}