trigger EUR_CRM_FI_Account_AfterInsert on EUR_CRM_Account__c (after insert) {
    /*List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_FI_OPAccountHandler(),
        new EUR_CRM_FI_ContractAccountHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, null);
    }*/
}