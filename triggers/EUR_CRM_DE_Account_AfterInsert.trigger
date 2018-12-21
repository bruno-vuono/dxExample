trigger EUR_CRM_DE_Account_AfterInsert on EUR_CRM_Account__c (after insert) {
    /*List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_DE_AccountHandler(),
        new EUR_CRM_DE_PrestigeAccountHandler(),
        new EUR_CRM_DE_SalesAgencyAccountHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, null);
    }*/
}