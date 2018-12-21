trigger ASI_MFM_SKU_Code_AfterInsert on ASI_MFM_SKU_Code__c (After Insert) {

    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_FOC_CN_SKU')){
        ASI_MFM_CN_SKU_TriggerClass.afterInsertMethod(trigger.new);
    }  
    
    List<ASI_MFM_SKU_Code__c> MY_SKUs = new List<ASI_MFM_SKU_Code__c>();
    for(ASI_MFM_SKU_Code__c sku: Trigger.New){
        if(sku.recordTypeId ==Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_CRM_MY_SKU')){
            MY_SKUs.add(sku);
        }
    }
    if(MY_SKUs.size()>0){
        ASI_CRM_MY_SKU_TriggerClass.routineAfterInsert(MY_SKUs);
    }    
}