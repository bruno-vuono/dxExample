trigger ASI_CRM_Voucher_BeforeDelete on ASI_CRM_Voucher__c (before delete) {
    if(trigger.old[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Voucher__cASI_CRM_SG_Voucher')) {
        List<ASI_CRM_SG_TriggerAbstract> triggerClasses = new List<ASI_CRM_SG_TriggerAbstract> {
            new ASI_CRM_SG_RollbackIncentiveHandler(ASI_CRM_SG_RollbackIncentiveHandler.VOUCHER_REQUEST)        
        };
        
        for (ASI_CRM_SG_TriggerAbstract triggerClass : triggerClasses) {
            triggerClass.executeTriggerAction(ASI_CRM_SG_TriggerAbstract.TriggerAction.AFTER_DELETE, trigger.old, trigger.newMap, trigger.oldMap);
        }
    }
}