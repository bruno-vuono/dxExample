/*********************************************************************************
 * Name:ASI_LUX_Campaign_Contribution_AfterDelete
 * Description: Campaign Contribution Trigger After Delete: Redirection based on record types
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 16/10/2014       Laputa: Conrad          Created
*********************************************************************************/
trigger ASI_LUX_Campaign_Contribution_AfterDelete on ASI_LUX_Campaign_Contribution__c (after Delete) {


  List<ASI_LUX_TriggerAbstract> triggerClasses = new List<ASI_LUX_TriggerAbstract>();
  
  // Filter recordtype based on LUX JP record types
  if (trigger.old[0].RecordTypeId != null && (Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_LUX_JP_Campaign_Contribution')
          || Global_RecordTypeCache.getRt(trigger.old[0].recordTypeId).developerName.contains('ASI_LUX_SG_Campaign_Contribution')
          || Global_RecordTypeCache.getRt(trigger.new[0].recordTypeId).developerName.contains('ASI_BRD_Generic_Campaign_Contribution')
      )) {
      triggerClasses.add(new ASI_LUX_JP_Calculate_Expenditure());
  }
  
  for (ASI_LUX_TriggerAbstract triggerClass : triggerClasses) {
    triggerClass.executeTriggerAction(ASI_LUX_TriggerAbstract.TriggerAction.AFTER_Delete, trigger.old, null, null);
  }  

}