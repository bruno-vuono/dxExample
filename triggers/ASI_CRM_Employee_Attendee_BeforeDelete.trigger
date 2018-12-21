/*********************************************************************************
 * Name:ASI_CRM_Employee_Attendee_BeforeDelete
 * Description: Before Delete Trigger for ASI CRM Employee Attendee
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 26/01/2015       Laputa: Conrad          Created
*********************************************************************************/
trigger ASI_CRM_Employee_Attendee_BeforeDelete on ASI_CRM_Employee_Attendee__c (before delete) {     
    List<ASI_CRM_JP_TriggerAbstract> ASI_CRM_JP_triggerClasses = new List<ASI_CRM_JP_TriggerAbstract>();
    
    if(Global_RecordTypeCache.getRt(trigger.old[0].recordTypeid).developerName.contains('ASI_CRM_JP_Employee')){
        ASI_CRM_JP_triggerClasses = new List<ASI_CRM_JP_TriggerAbstract> { 
            new ASI_CRM_JP_ProtectDeleteEmployee_Record()         
        };                    
    } 
    
    for (ASI_CRM_JP_TriggerAbstract triggerClass : ASI_CRM_JP_triggerClasses){
        triggerClass.executeTriggerAction(ASI_CRM_JP_TriggerAbstract.TriggerAction.BEFORE_DELETE, trigger.old, null, trigger.oldMap);
    }        
}