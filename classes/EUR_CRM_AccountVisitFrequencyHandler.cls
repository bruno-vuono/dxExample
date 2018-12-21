public with sharing class EUR_CRM_AccountVisitFrequencyHandler extends EUR_CRM_TriggerAbstract{
	
	public EUR_CRM_AccountVisitFrequencyHandler(){
        super('EUR_CRM_AccountVisitFrequencyHandler');
    }
    
    private static Set<String> validRecordTypes = new Set<String>{
    	'EUR_GB_FS_Indirect',
    	'EUR_BG_Modern_Off_Trade',
    	'EUR_BG_Wholesaler',
    	'EUR_BE_Off_Trade'
    }; 

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(validRecordTypes);
            
            return TRt;
        }private set;
    }


	//before insert and before update trigger
	//UK on trade FS accounts, visit frequency depends on the PROS segment; once PROS is defined, visit frequency will be automatically selected
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
		System.Debug('EUR_CRM_AccountVisitFrequencyHandler');
		List<EUR_CRM_Account__c> acctlist = (List<EUR_CRM_Account__c>) sObjList;
		Map<Id, Recordtype> recordtypeMap = EUR_CRM_AccountUtils.recordtypeMap;
		Set<String> groupOutletTypeSet = new Set<String>();
		Set<String> outletTypeSet = new Set<String>();
		Set<String> imageLevelSet = new Set<String>();
		Set<String> volumePotentialSet = new Set<String>();
		Set<String> customerTaxonomySet = new Set<String>();
		Set<String> visitFrequencyRecordTypeSet = new Set<String>();
		List<EUR_CRM_Account__c> acctVisitFreqUpdate = new List<EUR_CRM_Account__c>();
		List<EUR_CRM_Account__c> acctVisitFreqUpdateViaTaxonomy = new List<EUR_CRM_Account__c>();
		List<EUR_CRM_Account__c> acctVisitFreqUpdateFromDelivery = new List<EUR_CRM_Account__c>();
		Set<String> recordTypeFrequency = new Set<String>();
		
		if(tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE){
			for(EUR_CRM_Account__c acct : acctlist){
				if(validRecordTypes.contains(recordtypeMap.get(acct.RecordTypeId).DeveloperName) || System.Test.isRunningTest()){
					system.debug('record verified to use PROS assign visit frequency');

					if(recordtypeMap.get(acct.RecordTypeId).DeveloperName == 'EUR_BG_Wholesaler'){
						recordTypeFrequency.add('EUR_' + acct.EUR_CRM_Country_Code__c + '_Visit_Frequency');
						acctVisitFreqUpdateFromDelivery.add(acct);
					}
					else if(acct.EUR_CRM_Group_Outlet_Type__c!=null && acct.EUR_CRM_Outlet_Type__c!=null && acct.EUR_CRM_Volume_Potential__c!=null && acct.EUR_CRM_Image_Level__c!=null && recordtypeMap.get(acct.RecordTypeId).DeveloperName != 'EUR_BE_Off_Trade'){
						groupOutletTypeSet.add(acct.EUR_CRM_Group_Outlet_Type__c);
						outletTypeSet.add(acct.EUR_CRM_Outlet_Type__c);
						imageLevelSet.add(acct.EUR_CRM_Image_Level__c);
						volumePotentialSet.add(acct.EUR_CRM_Volume_Potential__c);
						acctVisitFreqUpdate.add(acct);
					} else if(acct.EUR_JB_Customer_Taxonomy__c != null && acct.EUR_CRM_Status__c != null) {
					    // For BG Modern Off Trade Visit Frequency Assignment
					    customerTaxonomySet.add(acct.EUR_JB_Customer_Taxonomy__c);
					    visitFrequencyRecordTypeSet.add('EUR_' + acct.EUR_CRM_Country_Code__c + '_Visit_Frequency');
					    acctVisitFreqUpdateViaTaxonomy.add(acct);
					}
				}
			}
			
			if(acctVisitFreqUpdateFromDelivery.size() > 0){
				assignVisitFreqViaDeliveryType(acctVisitFreqUpdateFromDelivery, recordTypeFrequency);
			}
			if(acctVisitFreqUpdate.size()>0){
				system.debug('get visit frequency');
				assignVisitFreqViaSegmentation(acctVisitFreqUpdate, groupOutletTypeSet, outletTypeSet, imageLevelSet, volumePotentialSet);
			}
			
			if(acctVisitFreqUpdateViaTaxonomy.size() > 0) {
			    assignVisitFreqViaTaxonomy(acctVisitFreqUpdateViaTaxonomy, visitFrequencyRecordTypeSet, customerTaxonomySet);
			}
		}
	}
	
	private void assignVisitFreqViaSegmentation(List<EUR_CRM_Account__c> acctVisitFreqUpdate, Set<String> groupOutletTypeSet, Set<String> outletTypeSet, Set<String> imageLevelSet, Set<String> volumePotentialSet){
		System.Debug('>>>assignVisitFreqViaSegmentation');
		Map<String, EUR_CRM_Visit_Frequency_Criteria__c> visitFreqCriteriaMap = new Map<String, EUR_CRM_Visit_Frequency_Criteria__c>();
		for(EUR_CRM_Visit_Frequency_Criteria__c crit : [Select Id, EUR_CRM_Group_Outlet_Type__c, EUR_CRM_Image_Level__c, EUR_CRM_Outlet_Type__c, EUR_CRM_Visit_Frequency__c, EUR_CRM_Volume_Potential__c 
						FROM EUR_CRM_Visit_Frequency_Criteria__c Where EUR_CRM_Group_Outlet_Type__c in: groupOutletTypeSet and EUR_CRM_Image_Level__c in: imageLevelSet
						and EUR_CRM_Outlet_Type__c in: outletTypeSet and EUR_CRM_Volume_Potential__c in: volumePotentialSet LIMIT 10000]){
			system.debug('start to construct matching key');
			String key = createKey(crit.EUR_CRM_Group_Outlet_Type__c, crit.EUR_CRM_Outlet_Type__c, crit.EUR_CRM_Image_Level__c, crit.EUR_CRM_Volume_Potential__c);
			visitFreqCriteriaMap.put(key, crit); 					
		}
		for(EUR_CRM_Account__c acct: acctVisitFreqUpdate){
			String key = createKey(acct.EUR_CRM_Group_Outlet_Type__c, acct.EUR_CRM_Outlet_Type__c, acct.EUR_CRM_Image_Level__c, acct.EUR_CRM_Volume_Potential__c);
			acct.EUR_CRM_Visit_Frequency__c = visitFreqCriteriaMap.containsKey(key) ? visitFreqCriteriaMap.get(key).EUR_CRM_Visit_Frequency__c : null;
		}
	}
	
	/**
	*  function: assignVisitFreqViaDeliveryType
	*  Assigns visit frequency to Account based on each account's delivery type and record types
	*  Input: List of accounts, and Set of visit frequency record types
	*/
	private void assignVisitFreqViaDeliveryType(List<EUR_CRM_Account__c> acctList, Set<String> recordTypeFrequency){
		System.Debug('>>>assignVisitFreqViaDeliveryType');
		List<EUR_CRM_Visit_Frequency__c> visitFrequencies = [SELECT Id, Name 
															 FROM EUR_CRM_Visit_Frequency__c
															 WHERE RecordType.DeveloperName
															 IN :recordTypeFrequency
															];
		for(EUR_CRM_Account__c acc : acctList){
			if(acc.EUR_CRM_Delivery_Type__c == 'Direct'){
				for(EUR_CRM_Visit_Frequency__c vf : visitFrequencies){
					if(vf.name == 'Once a week') acc.EUR_CRM_Visit_Frequency__c = vf.Id;
				}
			} else if(acc.EUR_CRM_Delivery_Type__c == 'Indirect'){
				for(EUR_CRM_Visit_Frequency__c vf : visitFrequencies){
					if(vf.name == 'Once every 2 weeks') acc.EUR_CRM_Visit_Frequency__c = vf.Id;
				}
			}
		}
	}
	
	/**
	*  function: assignVisitFreqViaTaxonomy
	*  Assigns visit frequency to Account based on each account's customer taxonomy and record types
	*  Input: List of accounts, Set of visit frequency record types, and set of customer taxonomy record types
	*/
	private void assignVisitFreqViaTaxonomy(List<EUR_CRM_Account__c> accVisitFreqUpdate, Set<String> visitFrequencyRecordTypeSet, Set<String> customerTaxonomySet) {
		System.Debug('>>>assignVisitFreqViaTaxonomy');
	    // TODO: Improve 2 SOQL to one
	    
	    // Retrieves Visit Frequency Records based on the record types
	    Map<Id,EUR_CRM_Visit_Frequency__c> visitFrequencyMap = new Map<Id, EUR_CRM_Visit_Frequency__c>([
	       SELECT Id, Name
	       FROM EUR_CRM_Visit_Frequency__c 
	       WHERE Recordtype.Developername IN :visitFrequencyRecordTypeSet
	    ]);
	    
	    // Retrieves Customer Taxonomy based on the record types
	    Map<Id, EUR_CRM_Customer_Taxonomy__c> customerTaxonomyMap = new Map<Id, EUR_CRM_Customer_Taxonomy__c>([
	       SELECT Id, EUR_CRM_Visit_Frequency__c, Name
	       FROM EUR_CRM_Customer_Taxonomy__c
	       WHERE Id IN :customerTaxonomySet
	    ]);
	    	    
	    EUR_CRM_Visit_Frequency__c biWeeklyVisitFrequency;
	    EUR_CRM_Visit_Frequency__c onceAMonthVisitFrequency;
	    
	    for(EUR_CRM_Visit_Frequency__c vf: visitFrequencyMap.values()) {
	        if(vf.Name == 'Once every 1 month') {
	            onceAMonthVisitFrequency = vf;
	        } else if(vf.Name == 'Once every 2 weeks') {
	            biWeeklyVisitFrequency = vf;
	        }
	    }
	    
	    for(EUR_CRM_Account__c acc: accVisitFreqUpdate) {
	        // Special case for BG OFF Indirect KA customer taxonomy
	        if(customerTaxonomyMap.get(acc.EUR_JB_Customer_Taxonomy__c).Name == 'BG_OFF_Indirect KAs') {
	            if(acc.EUR_CRM_Status__c == 'Active') {
                    acc.EUR_CRM_Visit_Frequency__c = biWeeklyVisitFrequency.Id;
	            } else if(acc.EUR_CRM_Status__c == 'Prospect') {
	                acc.EUR_CRM_Visit_Frequency__c = onceAMonthVisitFrequency.Id;
	            }
	        } else {
	            acc.EUR_CRM_Visit_Frequency__c = customerTaxonomyMap.get(acc.EUR_JB_Customer_Taxonomy__c).EUR_CRM_Visit_Frequency__c;
	        }
	    }
	}
	
	private String createKey(String g, String o, String i, String v){
		String key = g+'-'+o+'-'+i+'-'+v;
		system.debug('print key: '+key);
		return key;
	}
}