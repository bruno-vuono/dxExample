trigger ASI_TH_CRM_PaymentRequestLineItem_AfterUpdate on ASI_TH_CRM_PaymentRequestLineItem__c(after update) {
    if(trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_PaymentRequestLineItem__cASI_TH_CRM_Payment_Request_Detail')){
           ASI_TH_CRM_PaymentRequestLine_TriggerCls.routineAfterUpdate(trigger.new, trigger.oldMap);
       }   
}