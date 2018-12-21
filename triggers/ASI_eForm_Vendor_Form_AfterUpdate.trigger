trigger ASI_eForm_Vendor_Form_AfterUpdate on ASI_eForm_Vendor_Form__c (after update) {
/*    if (Global_RecordTypeCache.getRt(trigger.new[0].recordtypeid).DeveloperName.contains('ASI_eForm_SG_Vendor_Form'))
        ASI_eForm_SG_Vendor_Form_TriggerClass.assignHODApproval(trigger.new, trigger.oldMap);*/
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordtypeid).DeveloperName.contains('ASI_eForm_HK_Vendor_Form')
       && !Global_RecordTypeCache.getRt(trigger.new[0].recordtypeid).DeveloperName.contains('ASI_eForm_HK_Vendor_Form_Archived')
      ){
        
        ASI_eForm_HK_VendorForm_TriggerClass.afterUpdateFunction(trigger.new, trigger.oldMap, trigger.newMap);
    }
}