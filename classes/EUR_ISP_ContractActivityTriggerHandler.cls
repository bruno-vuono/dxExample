/**
 * Contract Activity Item Trigger class for iSPend APP
 *
 * @author afi
 * @copyright PARX
 */
public without sharing class EUR_ISP_ContractActivityTriggerHandler extends EUR_CRM_TriggerAbstract
{
	public EUR_ISP_ContractActivityTriggerHandler()
	{
		super('EUR_ISP_ContractActivityTriggerHandler');
	}

	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap)
	{
		if (TriggerAction.AFTER_UPDATE == tAction)
		{
			this.chechIfDatesChanged(sObjList, (Map<Id, EUR_CRM_Contract_Activity_Item__c>)oldMap);
		}
	}

	private void chechIfDatesChanged(List<EUR_CRM_Contract_Activity_Item__c> activities, Map<Id, EUR_CRM_Contract_Activity_Item__c> oldMap)
	{
		List<Id> contractIdsToUpdate = new List<Id>();
		for (EUR_CRM_Contract_Activity_Item__c activity : activities)
		{
			EUR_CRM_Contract_Activity_Item__c oldActivity = oldMap.get(activity.Id);
			if (activity.EUR_CRM_Contract_Activity_Total__c == oldActivity.EUR_CRM_Contract_Activity_Total__c &&
			        (activity.EUR_CRM_Start_Date__c != oldActivity.EUR_CRM_Start_Date__c || activity.EUR_CRM_End_Date__c != oldActivity.EUR_CRM_End_Date__c))
			{
				contractIdsToUpdate.add(activity.EUR_CRM_Contract__c);
			}
		}

		if (!contractIdsToUpdate.isEmpty())
		{
			EUR_ISP_ContractTransactionsServiceDE.createDraftTransactions(contractIdsToUpdate);
			EUR_ISP_ContractTransactionsServiceDE.commitTransactions();
		}
	}
}