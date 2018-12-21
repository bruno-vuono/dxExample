trigger EUR_CRM_Territory_BeforeUpdate on EUR_CRM_Territory__c (before update) {

	List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
		new EUR_CRM_TerritoryOwnerChanged()
	};

	for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
    	triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }

}