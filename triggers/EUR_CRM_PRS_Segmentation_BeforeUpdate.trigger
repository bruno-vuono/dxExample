trigger EUR_CRM_PRS_Segmentation_BeforeUpdate on EUR_CRM_PRS_Segmentation__c (before update) {
	List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_PRS_AssignAspectFromCustomerTax()
    };

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
        System.debug('Resources:'+ String.valueOf(triggerClass).split(':')[0] +'Queries:[' + Limits.getQueries() + ']|' + 'Rows:[' + Limits.getDmlRows() + '|Statements:[' + Limits.getDmlStatements() + ']' );
    }
}