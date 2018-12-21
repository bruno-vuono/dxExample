Trigger EUR_CRM_PRS_Segmentation_AfterInsert on EUR_CRM_PRS_Segmentation__c (after insert) {
    
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_PRSSegmentationToAccHandler()
    };

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, trigger.oldMap);
    }
}