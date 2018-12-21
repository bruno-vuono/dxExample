trigger ASI_KOR_POSM_Order_Request_AfterUpdate on ASI_KOR_POSM_Order_Request__c (after update ) {
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_KOR')){
        ASI_KOR_POSM_Order_Request_TriggerClass.routineAfterUpdate(trigger.new, trigger.oldMap); 
    }
    
}