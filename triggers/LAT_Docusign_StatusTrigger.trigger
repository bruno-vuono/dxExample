/**
 * trigger that handles doucusing envelope wrapper object
 * this Objects is handled by the Docusign connect for salesforce 
 * @author ernesto@zimmic.com
 */
trigger LAT_Docusign_StatusTrigger on LAT_DocuSign_Status__c (
	before update,
	after update) {

	public  Set<Id> contractsIds = new Set<Id>();

	public  Map<Id, Lat_Contract2__c> contractById;

	for (LAT_DocuSign_Status__c status:trigger.new){
		contractsIds.add(status.Lat_Contract2__c);

	}
	contractById = LAT_BR_DocusignDataTriggerHandler.getContractsById(contractsIds);


	if (trigger.isBefore){
		if(trigger.isUpdate){
			// updates the  contract status according to the new status
			LAT_BR_DocusignDataTriggerHandler.updateContractStatus(trigger.newMap, trigger.oldMap,contractById);
		}
	} else if (trigger.isAfter){
		if(trigger.isUpdate){
			// Do nothing
		}

	}

}