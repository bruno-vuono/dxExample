trigger ASI_HK_CRM_PreApprovalFormItem_AfterDelete on ASI_HK_CRM_Pre_Approval_Form_Item__c (after delete) {
    if (trigger.old[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_HK')){    
        //Trigger Record Type Check for HK CRM in ASISB5CONF
        
        List<ASI_HK_CRM_TriggerAbstract> triggerClasses = new List<ASI_HK_CRM_TriggerAbstract> {
            new ASI_HK_CRM_PAFItemParentSummaryUpdate()
        };
        
        for (ASI_HK_CRM_TriggerAbstract triggerClass : triggerClasses) {
            triggerClass.executeTriggerAction(ASI_HK_CRM_TriggerAbstract.TriggerAction.AFTER_DELETE, trigger.old, null, trigger.oldMap);
        }
    }
    else if (trigger.old[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_CRM_TW')){    
        //Trigger Record Type Check for TW CRM in ASISB6CONF
    
    }       
}