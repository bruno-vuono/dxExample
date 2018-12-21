trigger ASI_CRM_KR_PVA_BeforeDelete on ASI_CRM_KR_PVA__c (before Delete) {
  if (Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_CRM_KR_PVA') ){
        ASI_CRM_KR_PVA_TriggerClass.routineBeforeDelete(trigger.old);
    }
}