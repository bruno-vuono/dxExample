/**
 * Docusign Recipient updates
 * this trigger is meant to be used by the docusign connect for salesforce API
 * from docusing some fields will be updated according to the events that happend with a certain recipient
 * we should handle the events logic in this trigger
 * @author ernesto@zimmic.com
 */
trigger LAT_DocuSign_Recipient_StatusTrigger on LAT_DocuSign_Recipient_Status__c (
	before update,
	after update) {

	public static Map<Id, Lat_Contract2__c> contractById;
	public static Set<Id> contractsIds = new Set<Id>();
	public static Set<Id> docusingStatusIds;
	docusingStatusIds = new Set<Id> ();
		for (LAT_DocuSign_Recipient_Status__c rec: trigger.new){
			docusingStatusIds.add(rec.Parent_Status_Record__c);
			contractsIds.add(rec.Lat_Contract2__c);
		}	

		contractById = LAT_BR_DocusignDataTriggerHandler.getContractsById(contractsIds);


	if (trigger.isBefore){
		if(trigger.isUpdate){
			// updates the  contract status according to the new status (if there is no assigned contract do nothing)
			LAT_BR_DocusignDataTriggerHandler.updateSignataryAndProcessStatus(trigger.newMap, trigger.oldMap,contractById,docusingStatusIds);
		}
	} else if (trigger.isAfter){
		if(trigger.isUpdate){
			// Do nothing
		}

	}


}