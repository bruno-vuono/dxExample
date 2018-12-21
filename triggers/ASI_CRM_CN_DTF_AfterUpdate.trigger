trigger ASI_CRM_CN_DTF_AfterUpdate on ASI_CRM_DTF__c (after update)
{
    //CN
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_CRM_CN'))
    {
    	ASI_CRM_CN_DTF_TriggerClass.afterUpdateMethod(Trigger.New);
    }//end if
    //CN
}//end trigger