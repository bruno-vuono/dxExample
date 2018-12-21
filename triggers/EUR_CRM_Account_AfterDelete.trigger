trigger EUR_CRM_Account_AfterDelete on EUR_CRM_Account__c (after delete) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_EventCleanUpHandler()
//        , new EUR_CRM_ProsSegmentationCleanUpHandler()
    };

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_DELETE, trigger.old, null, trigger.oldMap);
    }

}