trigger ASI_DFPM_Project_Milestone_BeforeInsert on ASI_DFPM_Project_Milestone__c (before insert) {
	
	List<ASI_DFPM_TriggerAbstract> triggerClasses = new List<ASI_DFPM_TriggerAbstract> {
		new ASI_DFPM_DateDurationCalculator()
	};
	
	for (ASI_DFPM_TriggerAbstract triggerClass : triggerClasses) {
		triggerClass.executeTriggerAction(ASI_DFPM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, null, null);
	}
}