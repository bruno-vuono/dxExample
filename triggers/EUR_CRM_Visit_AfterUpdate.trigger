trigger EUR_CRM_Visit_AfterUpdate on EUR_CRM_Visit__c (after update) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_SetAccountLastVisitDateFromVisit()
	};
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
}