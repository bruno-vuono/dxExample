trigger EUR_CRM_DE_ObjPromo_BeforeInsert on EUR_CRM_ObjPromo__c (Before Insert) {
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
      new EUR_CRM_DE_ObjectivePromoHandler(),
      new EUR_CRM_FI_ObjectivePromoHandler(),
      new EUR_CRM_ZA_ObjectivePromoHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, null);
    }
}