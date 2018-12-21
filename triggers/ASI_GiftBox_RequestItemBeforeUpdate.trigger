trigger ASI_GiftBox_RequestItemBeforeUpdate on ASI_GiftBox_Request_Item__c (before update) {
    If(!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_VN_POSM')){
        ASI_GiftBox_RequestItemTriggerClass.routineBeforeUpsert(trigger.new);
    }
    
    If(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_VN_POSM')){
        new ASI_CRM_VN_FOCRequestItem_CalAmount().executeTrigger(trigger.new, trigger.oldMap);
    	new ASI_CRM_VN_POSM_CheckBalance().executeTrigger(trigger.new, trigger.oldMap);
    }
    
    If(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_VN_Display_Listing')){
        new ASI_CRM_VN_FOCRequestItem_CalAmount().executeTrigger(trigger.new, trigger.oldMap);
    	new ASI_CRM_VN_DisplayListing_CheckBalance().executeTrigger(trigger.new, trigger.oldMap);
    }
    
    If(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_VN_FOC_Request_Item')){
        new ASI_CRM_VN_FOCRequestItem_CalAmount().executeTrigger(trigger.new, trigger.oldMap);
    	new ASI_CRM_VN_FOC_CheckBalance().executeTrigger(trigger.new, trigger.oldMap);
    }
}