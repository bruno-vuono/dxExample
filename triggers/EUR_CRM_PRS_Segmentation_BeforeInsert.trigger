trigger EUR_CRM_PRS_Segmentation_BeforeInsert on EUR_CRM_PRS_Segmentation__c (before insert) {
	List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_PRS_AssignAspectFromCustomerTax()
    };

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, null);
        System.debug('Resources:'+ String.valueOf(triggerClass).split(':')[0] +'Queries:[' + Limits.getQueries() + ']|' + 'Rows:[' + Limits.getDmlRows() + '|Statements:[' + Limits.getDmlStatements() + ']' );
    }

}