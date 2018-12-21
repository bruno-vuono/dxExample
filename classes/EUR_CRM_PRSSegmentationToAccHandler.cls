/*Assign PRS Value from Prs Segmentation to Account Record
*User will answer PRS Question from mobile and update EUR_CRM_PRS_Segmentation__c
*This handle will populate the result from EUR_CRM_PRS_Segmentation__c to EUR_CRM_Account__c.
*Exclude Business Potential update for EUR_BE_Off_Trade, as the Value will populate fro CTax (EUR_CRM_PRS_AssignAspectFromCustomerTax)
*/


public with sharing class EUR_CRM_PRSSegmentationToAccHandler extends EUR_CRM_TriggerAbstract{
	public EUR_CRM_PRSSegmentationToAccHandler() {
		super('EUR_CRM_PRSSegmentationToAccHandler');
	}

	public static set<string> excludeUpdateBP = new set<string>{'EUR_BE_Off_Trade'};

	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
		System.Debug('>>>EUR_CRM_PRSSegmentationToAccHandler');
		EUR_CRM_Account__c euAccount;
	    Set<Id> euAccountsIdSet = new Set<Id>();
	    List<EUR_CRM_Account__c> euAccountsToUpdate = new List<EUR_CRM_Account__c>();

	    for(sObject prsSeg : newMap.values()){

	    	EUR_CRM_PRS_Segmentation__c prs = (EUR_CRM_PRS_Segmentation__c)prsSeg;
	        if(prs != null && prs.EUR_CRM_Account__c != null){
	            euAccountsIdSet.add(prs.EUR_CRM_Account__c);
	        }
	    }

	    System.Debug('>>>EUR_CRM_PRSSegmentationToAccHandler:AccCount:' + euAccountsIdSet.size());
	    Map<Id, EUR_CRM_Account__c> euAccountaMap = new Map<Id, EUR_CRM_Account__c>([SELECT Id, EUR_CRM_PRS_Group_Outlet_Type__c, EUR_CRM_PRS_Outlet_Type__c,
	                                                                                        EUR_CRM_Business_Potential__c, EUR_CRM_PRS_Priority_Level_Criteria__c,
	                                                                                        EUR_CRM_Brand_Building_Potential__c, EUR_CRM_PRS_Volume_Potential__c,
	                                                                                        EUR_CRM_PRS_Image_Level__c, RecordTYpe.DeveloperName
	                                                                                 FROM EUR_CRM_Account__c
	                                                                                 WHERE Id IN : euAccountsIdSet]);

	    for(sObject prsSeg : newMap.values()) {
	    	EUR_CRM_PRS_Segmentation__c prs = (EUR_CRM_PRS_Segmentation__c)prsSeg;



	        euAccount = euAccountaMap.get(prs.EUR_CRM_Account__c);
	        /*if(!excludeUpdateBP.contains(euAccount.RecordType.DeveloperName)){
	        	System.Debug('Exclude Update');
	        	euAccount.EUR_CRM_Business_Potential__c = prs.EUR_CRM_Business_Potential__c; 
	        }*/
	        
			System.Debug('EUR_CRM_PRSSegmentationToAccHandler: To Assign:' + prs.EUR_CRM_Business_Potential__c);
			System.Debug('EUR_CRM_PRSSegmentationToAccHandler: Current:' + euAccount.EUR_CRM_Business_Potential__c);

	        euAccount.EUR_CRM_Brand_Building_Potential__c = prs.EUR_CRM_Brand_Building_Potential__c;
	        euAccount.EUR_CRM_PRS_Priority_Level_Criteria__c = prs.EUR_CRM_PRS_Priority_Level_Criteria__c;
	        euAccount.EUR_CRM_PRS_Group_Outlet_Type__c = prs.EUR_CRM_PRS_Group_Outlet_Type__c;
	        euAccount.EUR_CRM_PRS_Outlet_Type__c = prs.EUR_CRM_PRS_Outlet_Type__c;
	        euAccount.EUR_CRM_PRS_Volume_Potential__c = prs.EUR_CRM_Volume_Potential__c;
	        euAccount.EUR_CRM_PRS_Image_Level__c = prs.EUR_CRM_Image_Level__c;
	        euAccount.EUR_CRM_Business_Potential__c = prs.EUR_CRM_Business_Potential__c; 

	        System.Debug('EUR_CRM_PRSSegmentationToAccHandler: To Update:' + euAccount.EUR_CRM_Business_Potential__c);

	        euAccountsToUpdate.add(euAccount);
	    }

	    /*if(euAccountsToUpdate.size() > 0){
	    	System.Debug('>>>EUR_CRM_PRSSegmentationToAccHandler:euAccountsToUpdate:' + euAccountsToUpdate.size());
	        EUR_CRM_CommonRoutine.dmlWithPartialSuccess('update', euAccountsToUpdate);
	    }*/
	    System.Debug('EUR_CRM_PRSSegmentationToAccHandler:' + euAccountsToUpdate);
	    update euAccountsToUpdate;
	}	
}