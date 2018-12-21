trigger ASI_MFM_PO_BeforeInsert on ASI_MFM_PO__c (before insert) {
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_GF')){ 
        // Added by 2018-03-26 Linus@introv
        ASI_MFM_GF_PO_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_GF_PO_TriggerClass.routineBeforeUpsert(trigger.new, null);
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SG')){
        // Added by 2018-03-15 Linus@introv
        ASI_MFM_SG_PO_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_SG_PO_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_TR')){
        // Added by 2018-04-30 Linus@introv
        ASI_MFM_TR_PO_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_TR_PO_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }
    else if (!Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP')){
        ASI_MFM_PO_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_PO_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }
    
    if (trigger.new[0].recordtypeId != null && (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CN')
        || Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_CN_Structure_Cost'))
       ){
           if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CN'))
               ASI_MFM_CN_PO_TriggerClass.routineBeforeInsert(trigger.new);
           else if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_CN_Structure_Cost'))
               ASI_MFM_CN_PO_StructureCost_TriggerClass.beforeInsertMethod(trigger.new);
               
    }
    
    if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP') 
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('SG')
        // Added by Hugo Cheung (Laputa) 05May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('TH')
        // Added by Hugo Cheung (Laputa) 06May2016
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('HK')
        //20170207 Elufa
        && !Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_CAP_CN_Structure_Cost')
       ){
        ASI_MFM_CAP_PO_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_CAP_PO_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }
       //for KR, added by Leo, 2015-11-23, B6
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_KR_PO')){
        
        //20180223 Introv bypass prepayment and offset payment
        List<ASI_MFM_PO__c> triggerNew = new List<ASI_MFM_PO__c>();
        for(ASI_MFM_PO__c po:trigger.new){
            if(!(po.ASI_MFM_Is_Direct_Payment__c || po.ASI_MFM_Is_Pre_Payment__c || po.ASI_MFM_Is_Offset_Payment__c)){
                triggerNew.add(po);
            }
        }        
        if(triggerNew.size()>0){
            ASI_MFM_KR_PO_TriggerClass.beforeUpsertMethod(triggerNew,null);
        }
    }
    //for KR, added by Leo, 2015-11-23, B6
    else if (Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_MFM_SC_')){
        ASI_MFM_SC_PO_TriggerClass.routineBeforeInsert(trigger.new);
        ASI_MFM_SC_PO_TriggerClass.routineBeforeUpsert(trigger.new, null); 
    }
}