public with sharing class EUR_CRM_SetAccountLastVisitDateFromVisit extends EUR_CRM_TriggerAbstract{
    
    private final Set<String> validContractRecordTypes = new Set<String>{
        'EUR_CH_Visit'
    };

    public EUR_CRM_SetAccountLastVisitDateFromVisit(){
        super('EUR_CRM_SetAccountLastVisitDateFromVisit');
    }
    
    // After insert or update
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        

        // Set of Accounts to update
        List<EUR_CRM_Account__c> accsToUpdate = new List<EUR_CRM_Account__c>();

        // All visits from trigger
        List<EUR_CRM_Visit__c> allVisits = (List<EUR_CRM_Visit__c>) sObjList;
        
        // Visit recordtypes
        List<Recordtype> visitRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Visit__c');
		Map<Id,Recordtype> visitRecordTypesMap = new Map<Id,Recordtype>();
        for(Recordtype rt : visitRecordTypes){
           visitRecordTypesMap.put(rt.id,rt);
        }


        // Set of Account Ids associated with the inserted or updated Visits
        Set<Id> acctIdlist = new set<Id>();
        for(EUR_CRM_Visit__c visit : allVisits){
        	if(validContractRecordTypes.contains(visitRecordTypesMap.get(visit.recordTypeId).developername)){
        		acctIdlist.add(visit.EUR_CRM_Account__c);
        	}
        }

        // List of all visits associated with all the accounts in acctIdlist 
        List<EUR_CRM_Account__c> allaccts = [SELECT Id, EUR_CRM_Last_Visit_Date__c,  
        										(SELECT Id, EUR_CRM_Start_Datetime__c, EUR_CRM_Account__c
        										FROM Visits__r
        										ORDER BY EUR_CRM_Start_Datetime__c DESC
        										LIMIT 1)
        									FROM EUR_CRM_Account__c 
        									WHERE Id In :acctIdlist];

		// Update accounts' Last Visit Date
		for(EUR_CRM_Account__c acc : allaccts){
			EUR_CRM_Visit__c visit = acc.Visits__r;
			if(acc.EUR_CRM_Last_Visit_Date__c != visit.EUR_CRM_Start_Datetime__c){
				acc.EUR_CRM_Last_Visit_Date__c = visit.EUR_CRM_Start_Datetime__c;
				accsToUpdate.add(acc);
			}
		} 

		// DML update
		update accsToUpdate;
	}	  
}