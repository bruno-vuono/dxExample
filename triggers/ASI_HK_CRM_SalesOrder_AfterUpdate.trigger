trigger ASI_HK_CRM_SalesOrder_AfterUpdate on ASI_HK_CRM_Sales_Order__c (after update) {
    
    List<ASI_HK_CRM_TriggerAbstract> triggerClasses = new List<ASI_HK_CRM_TriggerAbstract> {
        new ASI_HK_CRM_SalesOrderRequestSubmit()
        , new ASI_HK_CRM_SalesOrderNextApprover()
    };
    
    for (ASI_HK_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(ASI_HK_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
}