trigger ASI_CRM_CN_Channel_Strategy_BeforeInsert on ASI_CRM_CN_Channel_Strategy__c (before insert,before update) {

    // lokman 4/5/2014
    if(trigger.new[0].recordtypeid == Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel_Strategy__cASI_CRM_CN_Area')){
    //System.Debug('Before insert');
        ASI_CRM_CN_Channel_Strategy_TriggerClass.routineBeforeInsert(Trigger.new);
      //  System.Debug('Before insert finish');
    }
    }