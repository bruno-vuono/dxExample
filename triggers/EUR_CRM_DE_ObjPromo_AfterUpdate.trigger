trigger EUR_CRM_DE_ObjPromo_AfterUpdate on EUR_CRM_ObjPromo__c (After Update) {
    
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> { 
      new  EUR_CRM_DE_ExpiredObjectivePromoHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
}