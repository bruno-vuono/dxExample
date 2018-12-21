trigger EUR_CRM_FI_Account_AfterUpdate on EUR_CRM_Account__c (after update) {
    /*List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
       new EUR_CRM_FI_OPAccountHandler(),
       new EUR_CRM_FI_ContractAccountHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }*/
}