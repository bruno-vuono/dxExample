trigger ASI_KOR_SalesOrderRequestTransaction_BeforeUpdate on ASI_KOR_Sales_Order_Transaction__c (before update) {
    
    if (!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_CN_SalesOrder_Item')){

    List<ASI_KOR_TriggerAbstract> triggerClasses = new List<ASI_KOR_TriggerAbstract> {
        new ASI_KOR_SalesOrderRequestDtLockSubmitted()
    };
    
    for (ASI_KOR_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(ASI_KOR_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
    }
    
    //For CN
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_CN_SalesOrder_Item')){
        ASI_CRM_CN_SalesOrderItem_TriggerClass.beforeUpsertMethod(trigger.new);
    }
}