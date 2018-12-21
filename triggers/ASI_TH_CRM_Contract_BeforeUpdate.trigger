trigger ASI_TH_CRM_Contract_BeforeUpdate on ASI_TH_CRM_Contract__c (before update) {
    // Modified by Michael Yip (Introv) 26Apr2014 Separate trigger class by recordtype, assume same record type for all records in trigger.new 
    if(trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_TH_CRM_Contract')){
        ASI_TH_CRM_Contract_TriggerClass.routineBeforeUpdate(trigger.newMap, trigger.oldMap);
    }
    else if(trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract')){
        //ASI_CRM_CN_Contract_TriggerClass.routineBeforeUpsert(trigger.new, trigger.oldMap);
        //ASI_CRM_CN_Contract_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
        
       if(trigger.new[0].ASI_TH_CRM_Promotion_Type__c== 'Heavy Contract On' ){ 
            ASI_CRM_CN_HeavyContract_TriggerClass.routineBeforeUpsert(trigger.new, trigger.oldMap);
            ASI_CRM_CN_HeavyContract_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
        }else{  
            ASI_CRM_CN_Contract_TriggerClass.routineBeforeUpsert(trigger.new, trigger.oldMap);
            ASI_CRM_CN_Contract_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
        }
        
        
    }else if( trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_CN_Local_Group_Contract') || 
             trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_CN_Local_Group_Contract_Final') ||
             trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_CN_Local_Group_Contract_Approved') ||
             trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_CN_Group_Contract')  ){
                 ASI_CRM_CN_HeavyLocalContract_TriggerCls.routineBeforeUpdate(trigger.new, trigger.oldMap);
                 
                 
                 
                 
             }else if (trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_MY_Contract') || trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_MY_ContractFinal')) {
                 ASI_CRM_MY_Contract_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
             } else if (trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_MO_Contract')) {
                 ASI_CRM_MO_Contract_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldMap);
    }
    else if(trigger.new[0].recordTypeid != NULL && 
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_SG_Contract')){
                
                List<ASI_CRM_SG_TriggerAbstract> triggerClasses = new List<ASI_CRM_SG_TriggerAbstract> {
                    new ASI_CRM_SG_SetTargetBenchmark(),
                        new ASI_CRM_SG_AssignApprover_Contract(),
                        new ASI_CRM_SG_ValidateOutletDate(),
                        // DC - 02/19/2016 - Added class for populating inflation rate and distribution rate.
                        new ASI_CRM_SG_PopulateInfl_Distr_Rate(),
                        // Laputa Hugo Cheung - 2016-06-29
                        new ASI_CRM_SG_CheckContract()
                        };
                            
                            for (ASI_CRM_SG_TriggerAbstract triggerClass : triggerClasses) {
                                triggerClass.executeTriggerAction(ASI_CRM_SG_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newmap, trigger.oldmap);
                            }
            }
         // Vincent Lam - 8 Apr 2016
         // for SG CRM proposal
         else if(trigger.new[0].recordTypeid != NULL && 
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_CRM_SG_Proposal')){
                
                List<ASI_CRM_SG_TriggerAbstract> triggerClasses = new List<ASI_CRM_SG_TriggerAbstract> {
                    new ASI_CRM_SG_SetTargetBenchmark(),
                        new ASI_CRM_SG_AssignApprover_Contract(),
                        new ASI_CRM_SG_ValidateOutletDate(),
                        new ASI_CRM_SG_PopulateInfl_Distr_Rate()
                        };
                            
                            for (ASI_CRM_SG_TriggerAbstract triggerClass : triggerClasses) {
                                triggerClass.executeTriggerAction(ASI_CRM_SG_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newmap, trigger.oldmap);
                            }
            }
}