trigger ASI_DFPM_Project_Task_AfterDelete on ASI_DFPM_Project_Task__c (after delete) {
	
	List<ASI_DFPM_TriggerAbstract> triggerClasses = new List<ASI_DFPM_TriggerAbstract> {
		new ASI_DFPM_PromotionalTaskParentSummaryUP()
	};
	
	for (ASI_DFPM_TriggerAbstract triggerClass : triggerClasses) {
		triggerClass.executeTriggerAction(ASI_DFPM_TriggerAbstract.TriggerAction.AFTER_DELETE, trigger.old, null, trigger.oldMap);
	}
}