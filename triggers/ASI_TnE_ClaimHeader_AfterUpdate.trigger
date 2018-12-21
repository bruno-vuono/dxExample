trigger ASI_TnE_ClaimHeader_AfterUpdate on ASI_TnE_ClaimHeader__c (after update) {
    List<ASI_TnE_TriggerAbstract> ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract>();
    
    if(//Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_HK') ||
       //Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_HK_Claim_Header_Finance') || //20180503 Introv Commented, HK T&E was moved to Concur System
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_SG') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_SG_Claim_Header_Finance') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_KH') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_KH_Claim_Header_Finance') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_TH') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_TH_Claim_Header_Finance') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_PH') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_PH_Claim_Header_Finance') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_ID') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_ID_Claim_Header_Finance') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_MY') ||
       Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_MY_Claim_Header_Finance')){
        ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract> { 
            new ASI_TnE_ClaimsHeaderSendEmail(),
            new ASI_TnE_ClaimsChangeManagerAccess()
        };                    
    } 
    
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_TW')){
        ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract> { 
            new ASI_TnE_ClaimsHeaderSendEmail()
        }; 
    }
    //Added by Laputa Support 20-07-2017
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_KR')){
        ASI_TnE_triggerClasses = new List<ASI_TnE_TriggerAbstract> { 
            new ASI_TnE_KR_changeGnHRequestStatus()
        }; 
    }
    //End Added by Laputa Support 20-07-2017
    
    for (ASI_TnE_TriggerAbstract triggerClass : ASI_TnE_triggerClasses){
        triggerClass.executeTriggerAction(ASI_TnE_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
    //Added by Elufa Support 4-12-2015
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeid).developerName.contains('ASI_TnE_HK')){
        ASI_TnE_HK_ClaimHeaderTriggerClass.routineAfterAll(trigger.new, trigger.oldMap);
    }
    //End Added by Elufa Support 4-12-2015
 
}