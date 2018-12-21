trigger ASI_MFM_PlanLineItem_AfterUpdate on ASI_MFM_Plan_Line_Item__c (after update) {
	ASI_MFM_PlanLineItem_TriggerClass.routineAfterAll(trigger.new, trigger.oldMap);
}