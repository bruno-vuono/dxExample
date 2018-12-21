trigger EUR_CRM_ObjPromo_BeforeInsert on EUR_CRM_ObjPromo__c (before insert) {
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_ObjectivePromoHandler(),
        new EUR_CRM_PT_ObjectivePromoHandler()
    };
    
    for(EUR_CRM_TriggerAbstract triggerClass: triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, trigger.oldMap);
    }
}