/**
 * Contract Activity Item Trigger class for iSPend APP
 *
 * @author afi
 * @copyright PARX
 */
trigger EUR_ISP_ContractActivityItemTrigger on EUR_CRM_Contract_Activity_Item__c (after update)
{
	if (Trigger.isAfter && Trigger.isUpdate)
	{
		new EUR_ISP_ContractActivityTriggerHandler().executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, Trigger.new, Trigger.newMap, Trigger.oldMap);
	}
}