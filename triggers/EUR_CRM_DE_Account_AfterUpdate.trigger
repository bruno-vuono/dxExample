trigger EUR_CRM_DE_Account_AfterUpdate on EUR_CRM_Account__c (after update) {
    /*List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
       new EUR_CRM_DE_AccountHandler(),
       new EUR_CRM_DE_PrestigeAccountHandler(),
       new EUR_CRM_DE_SalesAgencyAccountHandler(),
       new EUR_CRM_DE_ContactAccountHandler()
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }*/
}