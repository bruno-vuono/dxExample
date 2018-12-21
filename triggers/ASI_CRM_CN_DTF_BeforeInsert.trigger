trigger ASI_CRM_CN_DTF_BeforeInsert on ASI_CRM_DTF__c (before insert)
{
    //CN
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_CRM_CN'))
    {
    	ASI_CRM_CN_DTF_TriggerClass.beforeInsertMethod(Trigger.New);
    }//end if
    //CN
}//end trigger