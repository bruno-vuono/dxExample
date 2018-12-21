trigger ASI_FOC_Free_Goods_Request_BeforeUpdate on ASI_FOC_Free_Goods_Request__c (before update) {
    
    if(trigger.new[0].recordTypeId != NULL){
        if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_CN')){
            ASI_FOC_Free_Goods_Request_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
            ASI_FOC_Free_Goods_Request_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
        }
        
        if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_HK')){
            ASI_FOC_HK_Request_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
            ASI_FOC_HK_Request_TriggerClass.routineBeforeUpsert(trigger.new, trigger.oldMap);
        }
        
        if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_MY')){
            ASI_CRM_MY_FreeGoodsRequest_TriggerCls.routineBeforeUpdate(trigger.new, trigger.oldMap);
        }
        else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_TW')){
            ASI_CRM_TW_FreeGoodsRequest_TriggerCls.routineBeforeUpsert(trigger.New, trigger.oldMap);
            ASI_CRM_TW_FreeGoodsRequest_TriggerCls.routineBeforeUpdate(trigger.New, trigger.oldMap);
        }
    }
}