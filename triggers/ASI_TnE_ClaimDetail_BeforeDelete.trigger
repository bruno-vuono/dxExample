trigger ASI_TnE_ClaimDetail_BeforeDelete on ASI_TnE_ClaimDetail__c (before delete) {

  Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([select id from recordType 
        where sobjectType = 'ASI_TnE_ClaimDetail__c' and developerName like '%ASI_JP_TnE%']);
        
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;

    List<ASI_TnE_ClaimDetail__c> validClaimDetails = new List<ASI_TnE_ClaimDetail__c>();
       
    for (ASI_TnE_ClaimDetail__c claimDetail : Trigger.oldMap.values())
    {         
         if (recordTypeMap.containsKey(claimDetail.recordTypeId)) {    
            validClaimDetails.add(claimDetail);
         }
     }
        
     if(validClaimDetails.size()>0)
     {
      ASI_TnE_JP_TnEDetailCheckDel.executeTrigger(validClaimDetails);
      ASI_JP_TnE_ClaimDetailTriggerClass.validateClaimDetailStatus(validClaimDetails);     
     }
    
    //For KR
    Map<Id, RecordType> KRrecordTypeMap = new Map<Id, RecordType>
        ([select id from recordType where sobjectType = 'ASI_TnE_ClaimDetail__c' and developerName =: 'ASI_TnE_KR_Claim_Detail']);
    List<ASI_TnE_ClaimDetail__c> KRvalidClaimDetails = new List<ASI_TnE_ClaimDetail__c>();
    
    for (ASI_TnE_ClaimDetail__c claimDetail : Trigger.oldMap.values())
    {         
     if (KRrecordTypeMap.containsKey(claimDetail.recordTypeId))
     {
         KRvalidClaimDetails.add(claimDetail);
     }       
    }  
    
    if(KRvalidClaimDetails.size()>0)
    {
        ASI_TnE_KR_ClaimDetailTriggerClass.beforeDeleteMethod(Trigger.old);       
    }
    //For KR
    
    List<ASI_TnE_TriggerAbstract> ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract>();
    if(Global_RecordTypeCache.getRt(trigger.old[0].recordTypeid).developerName.contains('ASI_TnE_HK_Claim_Detail')){
    	ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract> { 
            new ASI_TnE_HK_TnEDetailCheckDel()
        };
    }
    
    for (ASI_TnE_TriggerAbstract triggerClass : ASI_TnE_triggerClasses){
        triggerClass.executeTriggerAction(ASI_TnE_TriggerAbstract.TriggerAction.BEFORE_DELETE, null, null, trigger.oldMap);
    }
}