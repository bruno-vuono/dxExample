trigger EUR_CRM_ObjPromoTarget_AfterUpdate on EUR_CRM_ObjPromo_Target__c (after update) {

	List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract>{ 
		new EUR_CRM_ObjPromoTargetQuotaHandler()
	};
	
	for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
	    triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
	}

	new EUR_CRM_ObjPromoTargetCalculation().calculate(Trigger.new, Trigger.oldMap);

}