trigger ASI_FOC_Free_Goods_Request_AfterUpdate on ASI_FOC_Free_Goods_Request__c (after update) {

    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_CN')){
        ASI_FOC_Free_Goods_Request_TriggerClass.routineAfterAll(trigger.new, trigger.oldMap);
        ASI_FOC_Free_Goods_Request_TriggerClass.routineAfterUpdate(trigger.new, trigger.oldMap);
    }     
    
    //20170630 Wilken: Invoke FOC Interface through Oracle SOA
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName == 'ASI_FOC_CN_Request_and_Items_Read_Only'){
        ASI_FOC_CN_Invoke_SOA.routineAfterUpdateSOA(trigger.new, trigger.oldMap);        
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_HK')){
        ASI_FOC_HK_Request_TriggerClass.routineAfterAll(trigger.new, trigger.oldMap);  
    }
    
    // 20160407 Laputa Vincent created
    if(trigger.new[0].recordTypeid != NULL && 
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_SG_FOC')){
                
                List<ASI_CRM_SG_TriggerAbstract> triggerClasses = new List<ASI_CRM_SG_TriggerAbstract> {
                    new ASI_CRM_SG_CalculateROIinTrigger()
                        };
                            
                            for (ASI_CRM_SG_TriggerAbstract triggerClass : triggerClasses) {
                                triggerClass.executeTriggerAction(ASI_CRM_SG_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newmap, trigger.oldmap);
                            }
            }
    
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_FOC_MY_') ){
        ASI_CRM_MY_FreeGoodsRequest_TriggerCls.routineAfterUpsert(trigger.new);
        ASI_CRM_MY_FreeGoodsRequest_TriggerCls.routineAfterUpdate(trigger.new, trigger.oldmap);
    }
    
}