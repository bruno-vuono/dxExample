trigger ASI_DFPM_Promotional_Project_AfterUpdate on ASI_DFPM_Promotional_Project__c (after update) {
	
	List<ASI_DFPM_TriggerAbstract> triggerClasses = new List<ASI_DFPM_TriggerAbstract> {
		new ASI_DFPM_PromotionalProjectOwnerChange()
	};
	
	for (ASI_DFPM_TriggerAbstract triggerClass : triggerClasses) {
		triggerClass.executeTriggerAction(ASI_DFPM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
	}
}