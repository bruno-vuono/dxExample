trigger ASI_TnE_ClaimDetail_BeforeInsert on ASI_TnE_ClaimDetail__c (before insert) {
    /*Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([select id from recordType 
            where sobjectType = 'ASI_TnE_ClaimDetail__c' and developerName like '%ASI_JP_TnE%']);
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     List<ASI_TnE_ClaimDetail__c> validClaimDetails = new List<ASI_TnE_ClaimDetail__c>();
           
     for (ASI_TnE_ClaimDetail__c claimDetail : Trigger.new)
     {         
         if (recordTypeMap.containsKey(claimDetail.recordTypeId)) {    
            validClaimDetails.add(claimDetail);
         }
     }
            
     if(validClaimDetails.size()>0)
     {
      ASI_JP_TnE_ClaimDetailTriggerClass.routineBeforeUpsert(validClaimDetails, Trigger.oldMap);     
     }*/
      
     if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_JP_TnE'))
        ASI_JP_TnE_ClaimDetailTriggerClass.routineBeforeUpsert(trigger.new, Trigger.oldMap);     
    
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_TnE_VN'))
         ASI_TnE_ClaimDetailTriggerClass.routineBeforeUpsert(trigger.new,null);
    
    //for KR
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_TnE_KR_Claim_Detail')){
        ASI_TnE_KR_ClaimDetailTriggerClass.beforeInsertMethod(trigger.new);
        ASI_TnE_KR_ClaimDetailTriggerClass.routineBeforeUpsert(trigger.new,Trigger.oldMap);
        ASI_TnE_KR_CoApprover_Mapping.coApprover(Trigger.new,trigger.newMap); 
    }
    //for KR
         
    List<ASI_TnE_TriggerAbstract> ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract>();
    
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_HK_Claim_Detail') ||
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_SG_Claim_Detail') ||
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_KH_Claim_Detail') ||
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_ID_Claim_Detail') ||
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_TH_Claim_Detail') ||
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_PH_Claim_Detail') ||
            Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_MY_Claim_Detail') ){
        
        
        ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract> { 
            new ASI_TnE_AssignAutoNumber_ClaimDetail(),
            new ASI_TnE_ClaimsDetailCalcTax(),
            new ASI_TnE_ClaimsDetailGenAccountNo(),
            new ASI_TnE_ClaimsDetailValidatePO()
        };                    
    } 
    
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_TW_Claim_Detail')){
        ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract> {
            new ASI_TnE_TW_CalPaymentAmount(),
            new ASI_TnE_ClaimsDetailCalcTax(),
            new ASI_TnE_ClaimsDetailGenAccountNo(),
            new ASI_TnE_TW_ClaimsDetailValidation(),
            //new ASI_TnE_TW_ClaimsDetailValidatePlan(),
            new ASI_TnE_GnH_TW_ClaimsDetailValidation()
        }; 
    }
    
    for (ASI_TnE_TriggerAbstract triggerClass : ASI_TnE_triggerClasses){
        triggerClass.executeTriggerAction(ASI_TnE_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, trigger.oldMap);
        
    }            
}