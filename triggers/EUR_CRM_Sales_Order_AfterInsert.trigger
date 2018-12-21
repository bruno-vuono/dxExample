trigger EUR_CRM_Sales_Order_AfterInsert on EUR_CRM_Sales_Order__c (after insert) {
	List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> { 
        new EUR_CRM_SalesOrderAssignManager()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, null);
    }
}