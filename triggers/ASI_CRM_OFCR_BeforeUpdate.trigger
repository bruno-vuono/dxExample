trigger ASI_CRM_OFCR_BeforeUpdate on ASI_CRM_Order_Form_Customer_Relationship__c (before Update) {
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_CN')){
        ASI_CRM_CN_OFCR_TriggerClass.beforeUpsertMethod(trigger.new);
    }
}