trigger EUR_CRM_Account_BeforeDelete on EUR_CRM_Account__c (before delete) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_EUAccountLinkHandler(),
        //new PRH_EUSuppressIconic()
        new EUR_CRM_ProsSegmentationCleanUpHandler()
       //,new EUR_CRM_DeletePROSHandler()

    };

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_DELETE, trigger.old, null, trigger.oldMap);
    }

}