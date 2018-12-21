trigger ASI_KOR_POSM_Order_Request_BeforeInsert on ASI_KOR_POSM_Order_Request__c (before insert) {
   
    if (trigger.new[0].recordTypeId!=NULL && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_KOR_New_High_Value_POSM_Request')){
        ASI_KOR_POSM_Order_Request_TriggerClass.BeforeUpsertMethod(Trigger.New, NULL); 
    }
    
      
    if (trigger.new[0].recordTypeId!=NULL && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_KOR_New_POSM_Request')){
        ASI_KOR_POSM_Order_Request_TriggerClass.BeforeUpsertMethod(Trigger.New, NULL); 
    }
}