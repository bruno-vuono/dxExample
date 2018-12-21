/**
 * Contract Push Trigger Handler class for iSPend APP
 *
 * @author afi
 * @copyright PARX
 */
public class EUR_ISP_ContractPushTriggerHandler extends EUR_CRM_TriggerAbstract
{
	public EUR_ISP_ContractPushTriggerHandler()
	{
		super('EUR_ISP_ContractPushTriggerHandler');
	}

	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap)
	{
		if (TriggerAction.AFTER_UPDATE == tAction)
		{
			this.processTriggerAction(sObjList, (Map<Id, EUR_CRM_Contract__c>) oldMap);
		}
		if (TriggerAction.AFTER_INSERT == tAction)
		{
			this.processTriggerAction(sObjList, null);
		}
	}

	private void processTriggerAction(List<EUR_CRM_Contract__c> contracts, Map<Id, EUR_CRM_Contract__c> oldContracts)
	{
		oldContracts = oldContracts == null ? new Map<Id, EUR_CRM_Contract__c>() : oldContracts;

		Set<Id> contractsToPush = new Set<Id>();
		for (EUR_CRM_Contract__c theContract : contracts)
		{
			EUR_CRM_Contract__c theOldContract = oldContracts.get(theContract.Id);
			if ((theOldContract == null) || (theOldContract != null && theOldContract.EUR_CRM_Status__c != theContract.EUR_CRM_Status__c))
			{
				if (theContract.EUR_CRM_Status__c == EUR_ISP_ContractPushService.CONTRACT_STATUS_ACTIVATED && EUR_ISP_ContractPushService.isDeContract(theContract))
				{
					contractsToPush.add(theContract.Id);
				}
			}
		}

		try
		{
			EUR_ISP_ContractPushService.pushContractData(contractsToPush);
		}
		catch (Exception e)
		{
			EUR_ISP_LogService.addError(e.getMessage() + '\nDetails:\n' + e.getStackTraceString(), 'EUR_ISP_ContractPushTriggerHandler:processTriggerAction', null);
			EUR_ISP_LogService.commitErrors();
		}
	}
}