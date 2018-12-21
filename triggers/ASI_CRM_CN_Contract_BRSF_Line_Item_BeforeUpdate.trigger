trigger ASI_CRM_CN_Contract_BRSF_Line_Item_BeforeUpdate on ASI_CRM_CN_Contract_BRSF_Line_Item__c (Before update) {
   if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_CN_Contract_BRSF_Line_Item')){
       ASI_CRM_CN_Contract_BRSF_TriggerClass.routineBeforeUpsert(trigger.new, trigger.oldMap);   
   }
}