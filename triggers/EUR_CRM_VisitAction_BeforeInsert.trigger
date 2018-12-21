trigger EUR_CRM_VisitAction_BeforeInsert on EUR_CRM_Visit_Action__c (Before Insert) {
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
       new EUR_CRM_DE_IsSucccessfulHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, null);
    }
}