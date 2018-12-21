trigger ASI_DFPM_Project_Milestone_AfterUndelete on ASI_DFPM_Project_Milestone__c (after undelete) {
	
	List<ASI_DFPM_TriggerAbstract> triggerClasses = new List<ASI_DFPM_TriggerAbstract> {
		new ASI_DFPM_PromotionalMstInheritShareRule()
		, new ASI_DFPM_PromotionalMstParentSummaryUP()
	};
	
	for (ASI_DFPM_TriggerAbstract triggerClass : triggerClasses) {
		triggerClass.executeTriggerAction(ASI_DFPM_TriggerAbstract.TriggerAction.AFTER_UNDELETE, trigger.new, trigger.newMap, null);
	}
}