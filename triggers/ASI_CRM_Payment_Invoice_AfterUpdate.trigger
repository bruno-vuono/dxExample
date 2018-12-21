/*********************************************************************************
 * Name:ASI_CRM_Payment_Invoice_AfterUpdate
 * Description: Trigger After Update for ASI_CRM_Payment_Invoice
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 19/12/2014       Laputa: Conrad          Created
*********************************************************************************/
trigger ASI_CRM_Payment_Invoice_AfterUpdate on ASI_CRM_Payment_Invoice__c (After Update) {     
    List<ASI_CRM_JP_TriggerAbstract> ASI_CRM_JP_triggerClasses = new List<ASI_CRM_JP_TriggerAbstract>();
    
     if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_JP')){
        ASI_CRM_JP_triggerClasses.add(new ASI_CRM_JP_PaymentInvoiceCancelled());
    } 
    
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_JP_SPTD')){
        ASI_CRM_JP_triggerClasses.add(new ASI_CRM_JP_AutoCloseContract());  
    }
    
    for (ASI_CRM_JP_TriggerAbstract triggerClass : ASI_CRM_JP_triggerClasses){
        triggerClass.executeTriggerAction(ASI_CRM_JP_TriggerAbstract.TriggerAction.AFTER_Update, trigger.new, trigger.newMap, trigger.oldMap);
    }     
}