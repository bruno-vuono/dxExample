//LAT_Opportunity__c TRIGGER
/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 08/11/2016
*
********************************************************************************/

public with sharing class LAT_AR_LATOpportunityBeforeInsert   {
	
	public static void execute(){
		Set<Id> setOppRt = Global_RecordTypeCache.getRtIdSet('LAT_Opportunity__c',new set<String>{'Nova_oportunidade','OPP_1_NewOrder_ARG','OPP_2_NewOrder_URU','LAT_MX_OPP_NewOrder'});
    
	    list <Id> accIds = new list<Id>();
	    for (LAT_Opportunity__c opp : LAT_OpportunityTriggerHandler.triggerNew) {
	        if(setOppRt.contains(opp.RecordTypeId)){
	            accIds.add(opp.LAT_Account__c);
	        }
	    }
	    
	    if(!accIds.isEmpty()){
	        map <Id, Account> mapAccounts = new map <Id, Account>([SELECT Id, Name, ParentId FROM Account WHERE Id IN: accIds]);
	        for (LAT_Opportunity__c opp : LAT_OpportunityTriggerHandler.triggerNew) {
	            if(opp.LAT_Account__c != null && mapAccounts.containsKey(opp.LAT_Account__c) && opp.RecordTypeId != Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder')){
	                opp.LAT_AR_ParentAccount__c = mapAccounts.get(opp.LAT_Account__c).ParentId;
	            }
	            if(opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'Nova_oportunidade'))
	                opp.LAT_Country__c = 1;
	            else if(opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_2_NewOrder_URU'))
	                opp.LAT_Country__c = 5;
	            else if(opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_1_NewOrder_ARG'))
	                opp.LAT_Country__c = 6;
	            else if(opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder'))  
	                opp.LAT_Country__c = 12; 

	            if (opp.LAT_StageName__c == 'Mobile Order') {
	                opp.Name = mapAccounts.get(opp.LAT_Account__c).Name;
	                if (opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_1_NewOrder_ARG') 
	                    || opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_3_HeaderBlocked_ARG')
	                    || opp.RecordTypeId == Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_5_OrderBlocked_ARG')) {
	                    opp.LAT_OrderOrigin__c = 'APP';
	                }
	            }
	        }
	    }
	    
	}

}