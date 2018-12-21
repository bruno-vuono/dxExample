trigger ASI_HK_CRM_SalesOrder_AfterUndelete on ASI_HK_CRM_Sales_Order__c (after undelete) {
    
    List<ASI_HK_CRM_TriggerAbstract> triggerClasses = new List<ASI_HK_CRM_TriggerAbstract> {
        new ASI_HK_CRM_SalesOrderValidator()
    };
    
    for (ASI_HK_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(ASI_HK_CRM_TriggerAbstract.TriggerAction.AFTER_UNDELETE, trigger.new, trigger.newMap, null);
    }
    
}