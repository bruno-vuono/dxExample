trigger EUR_CRM_VisitAction_BeforeUpdate on EUR_CRM_Visit_Action__c (Before Update) {
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
       new EUR_CRM_DE_IsSucccessfulHandler(),
       new EUR_CRM_VisitActionPromoActiveHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
}