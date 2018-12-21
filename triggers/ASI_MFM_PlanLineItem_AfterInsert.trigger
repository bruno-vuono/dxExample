trigger ASI_MFM_PlanLineItem_AfterInsert on ASI_MFM_Plan_Line_Item__c (after insert) {
	ASI_MFM_PlanLineItem_TriggerClass.routineAfterAll(trigger.new, null);
}