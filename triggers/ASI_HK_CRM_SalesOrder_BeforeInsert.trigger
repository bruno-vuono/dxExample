trigger ASI_HK_CRM_SalesOrder_BeforeInsert on ASI_HK_CRM_Sales_Order__c (before insert) {
    
    List<ASI_HK_CRM_TriggerAbstract> triggerClasses = new List<ASI_HK_CRM_TriggerAbstract> {
        new ASI_HK_CRM_SalesOrderAssignAutoNumber()
        , new ASI_HK_CRM_SalesOrderApprovalCalculator()
        , new ASI_HK_CRM_SalesOrderDataManipulation()
        , new ASI_HK_CRM_SalesOrderAdjustDeliveryDate()
        //, new ASI_HK_CRM_SalesOrderValidator()
        , new ASI_HK_CRM_SalesOrderAssignApprover()
        , new ASI_HK_CRM_SalesOrderAutoFillPA()
        , new ASI_HK_CRM_SalesOrderFindARFromDA()
    };
    
    for (ASI_HK_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(ASI_HK_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, null, null);
    }
}