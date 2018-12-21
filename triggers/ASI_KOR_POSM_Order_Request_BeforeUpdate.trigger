trigger ASI_KOR_POSM_Order_Request_BeforeUpdate on ASI_KOR_POSM_Order_Request__c (before update) {
    if (trigger.new[0].recordTypeId!=NULL &&  Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_KOR')){
        ASI_KOR_POSM_Order_Request_TriggerClass.BeforeUpsertMethod(Trigger.New, trigger.oldMap); 
        ASI_KOR_POSM_Order_Request_TriggerClass.BeforeUpdateMethod(Trigger.New, trigger.oldMap); 
    }
   
}