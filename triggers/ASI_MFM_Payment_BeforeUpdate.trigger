trigger ASI_MFM_Payment_BeforeUpdate on ASI_MFM_Payment__c (before update) {
    // Added by Michael Yip (Introv) 04Jun2014 for isolating CN Payment Trigger logic
    if (trigger.new[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CN')
       || trigger.new[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_CN')){
        
           //20170213 Elufa
           if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CN')){
               ASI_MFM_CN_Payment_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
               ASI_MFM_CN_Payment_TriggerClass.routineBeforeUpdate(trigger.new,trigger.oldMap);
           }else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_CN')){
               
               ASI_MFM_CN_Payment_SC_TriggerCls.structureCostBeforeUpsert(trigger.New, trigger.oldMap);
           }
    }
    // Added by Conrad Pantua (Laputa) 07Jul2014 for isolating Capex Payment Trigger logic
    else if (trigger.new[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP') 
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('SG')
        // Added by Hugo Cheung (Laputa) 05May2016 for isolating Capex Payment TH Trigger logic
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('TH')
        // Added by Hugo Cheung (Laputa) 06May2016 for isolating Capex Payment HK Trigger logic
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('HK'))
    {
        ASI_MFM_CAP_Payment_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
        ASI_MFM_CAP_Payment_TriggerClass.routineBeforeUpdate(trigger.new,trigger.oldMap);  
    }
    // Added by Conrad Pantua (Laputa) 27May2015 for isolating Capex Payment SG Trigger logic
    
      //for KR, added by Leo, 2015-11-23, B6
    else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_KR_Payment')){
        //if(!trigger.new[0].ASI_MFM_Is_Direct_Payment__c){
            ASI_MFM_KR_Payment_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
        //}
        ASI_MFM_KR_Payment_TriggerClass.routineBeforeUpdate(trigger.new,trigger.oldMap); // ASI_MFM_KR_Payment_TriggerClass.beforeUpsertMethod(Trigger.New);  
    }

    //for KR, added by Leo, 2015-11-23, B6
    else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG_Payment')){
        // Added by 2018-03-15 Linus@introv
        ASI_MFM_SG_Payment_TriggerClass.routineBeforeUpdate(trigger.new, trigger.oldmap);
        ASI_MFM_SG_Payment_TriggerClass.routineBeforeUpsert(trigger.new, trigger.oldmap);
    }
    else if (trigger.new[0].RecordTypeId != null && 
             (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_SG') || 
              Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_HK') || 
              Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_TH')))
    {
        ASI_MFM_CAP_SG_Payment_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
        ASI_MFM_CAP_SG_Payment_TriggerClass.routineBeforeUpdate(trigger.new,trigger.oldMap); 
    }else if (trigger.new[0].RecordTypeId != null && Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC') )  {
        ASI_MFM_SC_Payment_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
        ASI_MFM_SC_Payment_TriggerClass.routineBeforeUpdate(trigger.new,trigger.oldMap);  
    }
    else{
        ASI_MFM_Payment_TriggerClass.routineBeforeUpsert(trigger.new,trigger.oldMap);
        ASI_MFM_Payment_TriggerClass.routineBeforeUpdate(trigger.new,trigger.oldMap);    
    }
}