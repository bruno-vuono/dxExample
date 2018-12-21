trigger ASI_CRM_Credit_Debit_Note_BeforeInsert on ASI_CRM_Credit_Debit_Note__c (before insert) {
    if(trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Credit_Note')
      || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Debit_Note')
       || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Prompt_Payment_Credit_Note')
       || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Prompt_Payment_Debit_Note')
       || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Back_Rebate_Credit_Note')
       || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Back_Rebate_Debit_Note')
       || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Manual_Credit_Note')
       || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Manual_Debit_Note')
      ){
        List<ASI_CRM_SG_TriggerAbstract> triggerClasses = new List<ASI_CRM_SG_TriggerAbstract> {
            new ASI_CRM_SG_AssignAutoNumber_CreditDebit()        
        };
        
        for (ASI_CRM_SG_TriggerAbstract triggerClass : triggerClasses) {
            triggerClass.executeTriggerAction(ASI_CRM_SG_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, null, null);
        }
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordtypeid).DeveloperName.contains('ASI_CRM_SG_Manual'))
        ASI_CRM_SG_CreditNote_TriggerClass.retrieveExchangeRate(trigger.new, null);
}