trigger EUR_CRM_VisitAction_AfterInsert on EUR_CRM_Visit_Action__c (After Insert) {
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
       new EUR_CRM_DE_VisitActionHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, null);
    }
}