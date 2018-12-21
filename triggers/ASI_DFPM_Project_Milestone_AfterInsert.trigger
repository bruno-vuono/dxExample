trigger ASI_DFPM_Project_Milestone_AfterInsert on ASI_DFPM_Project_Milestone__c (after insert) {
	
	List<ASI_DFPM_TriggerAbstract> triggerClasses = new List<ASI_DFPM_TriggerAbstract> {
		new ASI_DFPM_PromotionalMstInheritShareRule()
		, new ASI_DFPM_PromotionalMstParentSummaryUP()
	};
	
	for (ASI_DFPM_TriggerAbstract triggerClass : triggerClasses) {
		triggerClass.executeTriggerAction(ASI_DFPM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, trigger.oldMap);
	}
}