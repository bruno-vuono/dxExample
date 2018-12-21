trigger ASI_KOR_VisitationPlan_BeforeInsert on ASI_KOR_Visitation_Plan__c (before insert) {
	if (trigger.new[0].recordtypeId != null && (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_KOR_Visitation_Plan_Locked')||Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_CRM_KR_Visitation_Plan')) ){
        ASI_CRM_KR_VisitationPlan_TriggerClass.routineBeforeUpsert(trigger.new,NULL);
    }
}