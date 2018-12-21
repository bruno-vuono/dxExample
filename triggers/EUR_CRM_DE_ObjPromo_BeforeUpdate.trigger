trigger EUR_CRM_DE_ObjPromo_BeforeUpdate on EUR_CRM_ObjPromo__c (Before Update) {
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
      new EUR_CRM_DE_ObjectivePromoHandler(),
      new EUR_CRM_FI_ObjectivePromoHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
}