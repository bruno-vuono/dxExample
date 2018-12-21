trigger ASI_MFM_Item_Group_AfterUpdate on ASI_MFM_Item_Group__c (after update) {

    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_HK_CRM_Item_Group')){
		ASI_MFM_HK_Item_Group_TriggerClass.routineAfterUpdate(trigger.new, trigger.oldMap);       
    }
}