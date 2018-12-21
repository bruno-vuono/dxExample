/**
* Name: EUR_CRM_ContractPaymentPlanPeriodHandler
* Description: Creates a number of Payment Plan Period records for each Contract Product Item inserted (Pouring Refund)
*			   For other mechanic types, create one Payment Plan Period record for each Contract Activity Item 
*
* Countries: DE, iSpend
*/
public with sharing class EUR_CRM_ContractPaymentPlanPeriodHandler extends EUR_CRM_TriggerAbstract{

	public EUR_CRM_ContractPaymentPlanPeriodHandler() {
		super('EUR_CRM_ContractPaymentPlanPeriodHandler');
	}

	// TODO: Refactor with RecordTypeHandler in case iSpend is expanded
	private final Set<String> validCountryCodes = new Set<String>{'DE'};

	private final String BEGINNING_CONTRACT 		= 'Nach Vertragsabschluss (einmalig)';
	private final String BEGINNING_CONTRACT_PERIOD 	= 'Zu Beginn der Vertragsposition';
	private final String AFTER_IMPLEMENTATION 		= 'Nach Umsetzung';
	private final String HALF_YEARLY				= 'Halbjährlich nach Leistungserfüllung';
	private final String THIRD_PARTY_VENDOR 		= 'Abrechnung durch Dritte';
	private final String NO_INVOICING 				= 'Keine Abrechnung';
	private final String POURING_REFUND				= 'EUR_DE_Pouring_RV_Mechanic_Type';
	private final String DE_PAYMENT_PLAN_PERIOD 	= 'EUR_DE_Contract_Payment_Plan_Period';

	private final Id pouringRefundRtId 				= Global_RecordTypeCache.getRtId('EUR_CRM_Mechanic_Type__c' + POURING_REFUND);
	private final Id paymentPlanPeriodRt 			= Global_RecordTypeCache.getRtId('EUR_CRM_Contract_Payment_Plan_Period__c' + DE_PAYMENT_PLAN_PERIOD);

	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){ 
		List<RecordType> contractProductItemRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Contract_Product_Item__c');
		// Special case for pouring refund, as they need to be split according to year

		Map<Id,Recordtype> contractProductRecordTypesMap = new Map<Id,Recordtype>();
		List<EUR_CRM_Contract_Product_Item__c> validContractProductItems = new List<EUR_CRM_Contract_Product_Item__c>();
		Set<Id> contractActivityItemIds = new Set<Id>();
		Set<Id> contractIds = new Set<Id>();
		Map<Id, EUR_CRM_Contract_Activity_Item__c> relatedContractActivityItems;
		Map<Id, EUR_CRM_Contract_Activity_Item__c> nonPouringRefundContractActivityItems = new Map<Id, EUR_CRM_Contract_Activity_Item__c>();
		// Maps ContractId to EUR_CRM_Contract_Payment_Plan__c
		Map<Id, EUR_CRM_Contract_Payment_Plan__c> relatedContractPaymentPlans = new Map<Id, EUR_CRM_Contract_Payment_Plan__c>();
		List<EUR_CRM_Contract_Payment_Plan_Period__c> newContractPaymentPlanPeriods = new List<EUR_CRM_Contract_Payment_Plan_Period__c>();
		List<EUR_CRM_Contract_Payment_Plan_Period__c> existingContractPaymentPlanPeriods = new List<EUR_CRM_Contract_Payment_Plan_Period__c>();
		Set<Id> existingContractActivityIds = new Set<Id>();

		// Maps all Contract Product Item record types to its ID. Used to retrieve the developername
		for(RecordType rt: contractProductItemRecordTypes) {
		    contractProductRecordTypesMap.put(rt.id, rt);
		}

		for(EUR_CRM_Contract_Product_Item__c cpItem: (List<EUR_CRM_Contract_Product_Item__c>) sObjList) {
			System.debug(cpItem.EUR_CRM_Contract_Activity_Item__c);
            System.debug(cpItem.EUR_CRM_Country_Code__c);

			if(validCountryCodes.contains(cpItem.EUR_CRM_Country_Code__c)) {
				validContractProductItems.add(cpItem);
				contractActivityItemIds.add(cpItem.EUR_CRM_Contract_Activity_Item__c);
			}
		}

		if(validContractProductItems.size() > 0) {

    		// Retrieve Contract Activity Items and Contract
    		relatedContractActivityItems = new Map<Id, EUR_CRM_Contract_Activity_Item__c>([SELECT Id,
    										EUR_CRM_Amount__c, EUR_CRM_Contract__c,
    										EUR_CRM_Contract__r.EUR_CRM_Start_Date__c,
    										EUR_CRM_Contract__r.EUR_CRM_End_Date__c,
    										EUR_CRM_Payment_Term_By_SR__c,
    										EUR_CRM_Mechanic_Type__r.recordTypeId,
    										EUR_CRM_Start_Date__c, EUR_CRM_End_Date__c,
    										(SELECT EUR_CRM_Brand__c, EUR_CRM_Brand__r.Name,
    										 EUR_CRM_Description__c
    										 FROM Contract_Product_Items__r)
    										FROM EUR_CRM_Contract_Activity_Item__c
    										WHERE Id IN :contractActivityItemIds]);
    		existingContractPaymentPlanPeriods = [SELECT Id, EUR_CRM_Description__c,
    												EUR_CRM_Contract_Payment_Plan__c,
    												EUR_CRM_Contract_Activity_Item__c,
    												EUR_CRM_Payment_Period_Start_Date__c,
    												EUR_CRM_Payment_Period_End_Date__c,
    												EUR_CRM_CPPP_Amount__c, EUR_CRM_CPPP_Payment_Term__c,
    												EUR_CRM_CPPP_Earliest_Date_of_Invoice__c,
    												EUR_CRM_Contract_Product_Item__c, EUR_CRM_Brand__c
    												FROM EUR_CRM_Contract_Payment_Plan_Period__c
    												WHERE EUR_CRM_Contract_Activity_Item__c IN :contractActivityItemIds];


    		for(EUR_CRM_Contract_Activity_Item__c caItem: relatedContractActivityItems.values()) {
    			// Retrieve a set of Contract Ids and use it to retrieve all related Contract Payment Plan
    			contractIds.add(caItem.EUR_CRM_Contract__c);
    		}
    		for(EUR_CRM_Contract_Payment_Plan_Period__c existingContractPaymentPlanPeriod: existingContractPaymentPlanPeriods) {
    			existingContractActivityIds.add(existingContractPaymentPlanPeriod.EUR_CRM_Contract_Activity_Item__c);
    		}
    		for(EUR_CRM_Contract_Payment_Plan__c cpPlan: [SELECT Id, EUR_CRM_Contract__c
    														FROM EUR_CRM_Contract_Payment_Plan__c
    														WHERE EUR_CRM_Contract__c IN :contractIds]) {
    			relatedContractPaymentPlans.put(cpPlan.EUR_CRM_Contract__c, cpPlan);
    		}

    		System.debug(validContractProductItems);
    		System.debug(relatedContractActivityItems);
    		System.debug(relatedContractPaymentPlans);
    		System.debug(contractIds);
    		System.debug(existingContractPaymentPlanPeriods);
    		System.debug(pouringRefundRtId);
    		System.debug(existingContractActivityIds);

    		for(EUR_CRM_Contract_Product_Item__c cpItem: validContractProductItems) {
    			EUR_CRM_Contract_Activity_Item__c caItem = relatedContractActivityItems.get(cpItem.EUR_CRM_Contract_Activity_Item__c);
    			System.debug(caItem);
    			System.debug(caItem.EUR_CRM_Mechanic_Type__r.recordTypeId);

    			// Barrier. Ignore contracts without a contract payment plan record (old contracts)
    			if(relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c) == null) {
    				continue;
    			}

    			// Barrier. Per Contract Product Item creation for CPPP is only applicable to Pouring Refund
    			if(caItem.EUR_CRM_Mechanic_Type__r.recordTypeId != pouringRefundRtId) {
    				nonPouringRefundContractActivityItems.put(caItem.Id, caItem);
    				continue;
    			}

    			if(caItem.EUR_CRM_Payment_Term_By_SR__c == AFTER_IMPLEMENTATION) {
    				createContractPaymentPlanPeriodYearly(
    					caItem.EUR_CRM_Start_Date__c,
    					caItem.EUR_CRM_End_Date__c,
    					newContractPaymentPlanPeriods,
    					cpItem,
    					caItem,
    					relatedContractPaymentPlans,
    					0, 0, 0
    				);
    			} else if(caItem.EUR_CRM_Payment_Term_By_SR__c == HALF_YEARLY) {
    				createContractPaymentPlanPeriodHalfYearly(
    					caItem.EUR_CRM_Start_Date__c,
    					caItem.EUR_CRM_End_Date__c,
    					newContractPaymentPlanPeriods,
    					cpItem,
    					caItem,
    					relatedContractPaymentPlans,
    					0, 0, 0
    				);
    			} else if(caItem.EUR_CRM_Payment_Term_By_SR__c == THIRD_PARTY_VENDOR) {
    				newContractPaymentPlanPeriods.add(new EUR_CRM_Contract_Payment_Plan_Period__c(
    					EUR_CRM_Contract_Activity_Item__c 		= caItem.Id,
    					EUR_CRM_Contract_Payment_Plan__c  		= relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c).Id,
    					EUR_CRM_Payment_Period_Start_Date__c 	= caItem.EUR_CRM_Start_Date__c,
    					EUR_CRM_Payment_Period_End_Date__c 		= caItem.EUR_CRM_End_Date__c,
    					recordTypeId 							= paymentPlanPeriodRt,
    					EUR_CRM_CPPP_Payment_Term__c			= caItem.EUR_CRM_Payment_Term_By_SR__c,
    					EUR_CRM_Contract_Product_Item__c		= cpItem.Id,
    					EUR_CRM_CPPP_Unit__c					= cpItem.EUR_CRM_Unit__c,
    					EUR_CRM_CPPP_Rate__c 					= cpItem.EUR_CRM_Amount__c,
    					EUR_CRM_CPPP_Volume__c					= cpItem.EUR_CRM_Quantity__c,
    					EUR_CRM_CPPP_Amount__c					= cpItem.EUR_CRM_Amount__c * cpItem.EUR_CRM_Quantity__c,
    					EUR_CRM_Description__c					= cpItem.EUR_CRM_Description__c
    				));
    			}
    		}

    		for(EUR_CRM_Contract_Activity_Item__c caItem: nonPouringRefundContractActivityItems.values()) {
    			if(caItem.Contract_Product_Items__r != null && !existingContractActivityIds.contains(caItem.Id)) {
    				String brandNames = '';
    				String description = '';
    				for(EUR_CRM_Contract_Product_Item__c cpItem: caItem.Contract_Product_Items__r) {
    					System.debug(cpItem);

    					// Concatenate Names
    					brandNames += cpItem.EUR_CRM_Brand__r.Name + '\n';
    					if(cpItem.EUR_CRM_Description__c != null) {
    						description += cpItem.EUR_CRM_Description__c + '\n\n';
    					}
    				}

    				System.debug(brandNames);

    				EUR_CRM_Contract_Payment_Plan_Period__c newContractPaymentPlanPeriod = new EUR_CRM_Contract_Payment_Plan_Period__c(
    					EUR_CRM_Contract_Activity_Item__c 		= caItem.Id,
    					EUR_CRM_Contract_Payment_Plan__c  		= relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c).Id,
    					EUR_CRM_Payment_Period_Start_Date__c 	= caItem.EUR_CRM_Start_Date__c,
    					EUR_CRM_Payment_Period_End_Date__c 		= caItem.EUR_CRM_End_Date__c,
    					recordTypeId 							= paymentPlanPeriodRt,
    					EUR_CRM_CPPP_Payment_Term__c			= caItem.EUR_CRM_Payment_Term_By_SR__c,
    					EUR_CRM_List_of_Brand__c				= brandNames,
    					EUR_CRM_CPPP_Amount__c					= caItem.EUR_CRM_Amount__c,
    					EUR_CRM_Description__c					= description
    				);

    				if(caItem.EUR_CRM_Payment_Term_By_SR__c == NO_INVOICING) {
    					newContractPaymentPlanPeriod.EUR_CRM_CPPP_Earliest_Date_of_Invoice__c 	= null;
    					//newContractPaymentPlanPeriod.EUR_CRM_CPPP_Amount__c 					= null;
    				} else if(caItem.EUR_CRM_Payment_Term_By_SR__c == BEGINNING_CONTRACT) {
    					newContractPaymentPlanPeriod.EUR_CRM_CPPP_Earliest_Date_of_Invoice__c 	= caItem.EUR_CRM_Contract__r.EUR_CRM_Start_Date__c;
    				} else if(caItem.EUR_CRM_Payment_Term_By_SR__c == BEGINNING_CONTRACT_PERIOD) {
    					newContractPaymentPlanPeriod.EUR_CRM_CPPP_Earliest_Date_of_Invoice__c 	= caItem.EUR_CRM_Start_Date__c;
    				} else if(caItem.EUR_CRM_Payment_Term_By_SR__c == AFTER_IMPLEMENTATION) {
    					newContractPaymentPlanPeriod.EUR_CRM_CPPP_Earliest_Date_of_Invoice__c 	= caItem.EUR_CRM_End_Date__c.addDays(1);
    				}

    				newContractPaymentPlanPeriods.add(newContractPaymentPlanPeriod);
    			}
    		}

    		System.debug(newContractPaymentPlanPeriods);
    		if(newContractPaymentPlanPeriods.size() > 0) {
    			insert newContractPaymentPlanPeriods;
    		}
        }
	}

	public void createContractPaymentPlanPeriodYearly(Date startDate, Date endDate,
			List<EUR_CRM_Contract_Payment_Plan_Period__c> newContractPaymentPlanPeriods,
			EUR_CRM_Contract_Product_Item__c cpItem, EUR_CRM_Contract_Activity_Item__c caItem,
			Map<Id, EUR_CRM_Contract_Payment_Plan__c> relatedContractPaymentPlans, Integer totalNumOfMonths,
			Decimal accumulatedVolume, Decimal accumulatedRemainder) {

		if(totalNumOfMonths == 0) {
			totalNumOfMonths = startDate.monthsBetween(endDate);

			// Round up remaining days to one month
			if(startDate.addMonths(totalNumOfMonths).daysBetween(endDate) > 0) {
				totalNumOfMonths = totalNumOfMonths + 1;
			} else if(totalNumofMonths == 0) {
				// Special case: start Date and End Date are the same date
				totalNumOfMonths = 1;
			}

			System.debug(totalNumOfMonths);
		}

		if(startDate.daysBetween(endDate) <= 365 ||
			(startDate.addYears(1).daysBetween(endDate) < 1)) {
			// Determine how many months between start date and end date (less than one year)
			// Special case when start date and end date are on the same month
			Integer numOfMonths = startDate.monthsBetween(endDate);
			// Round up remaining days to one month
			if(startDate.addMonths(numOfMonths).daysBetween(endDate) > 0) {
				numOfMonths = numOfMonths + 1;
			} else if(numOfMonths == 0) {
				// Special case: start Date and End Date are the same date
				numOfMonths = 1;
			}

			System.debug(numOfMonths);

			Decimal annualQuantity = cpItem.EUR_CRM_Quantity__c * numOfMonths / totalNumOfMonths;
			// accumulates the remainders and add one to yearly quantity if the remainder is a round number (e.g more than 1)
			accumulatedRemainder = accumulatedRemainder + annualQuantity - annualQuantity.intValue();
			if(accumulatedRemainder >= 1) {
				annualQuantity += 1;
			}

			accumulatedVolume += annualQuantity;
			// if accumulatedVolume is not the same as the actual volume, add one to annualQuantity
			if(accumulatedVolume < cpItem.EUR_CRM_Quantity__c) {
				annualQuantity += 1;
			}

			System.debug(annualQuantity);
			System.debug(accumulatedVolume);
			System.debug(relatedContractPaymentPlans);

			newContractPaymentPlanPeriods.add(new EUR_CRM_Contract_Payment_Plan_Period__c(
				EUR_CRM_Contract_Activity_Item__c 	 	= caItem.Id,
				EUR_CRM_Contract_Product_Item__c		= cpItem.Id,
				EUR_CRM_CPPP_Unit__c					= cpItem.EUR_CRM_Unit__c,
				EUR_CRM_CPPP_Rate__c 					= cpItem.EUR_CRM_Amount__c,
				EUR_CRM_CPPP_Volume__c					= annualQuantity.intValue(),
				EUR_CRM_CPPP_Amount__c					= cpItem.EUR_CRM_Amount__c * annualQuantity.intValue(),
				EUR_CRM_Contract_Payment_Plan__c  	 	= relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c).Id,
				EUR_CRM_Description__c					= cpItem.EUR_CRM_Description__c,
				recordTypeId 						 	= paymentPlanPeriodRt,
				EUR_CRM_CPPP_Earliest_Date_of_Invoice__c= endDate.addDays(1),
				EUR_CRM_Payment_Period_Start_Date__c 	= startDate,
				EUR_CRM_Payment_Period_End_Date__c   	= endDate,
				EUR_CRM_CPPP_Payment_Term__c			= 'Nach Umsetzung'
			));
		} else {
			Decimal annualQuantity = cpItem.EUR_CRM_Quantity__c * 12 / totalNumOfMonths;

			// accumulates the remainders and add one to yearly quantity if the remainder is a round number (e.g more than 1)
			accumulatedRemainder = accumulatedRemainder + annualQuantity - annualQuantity.intValue();
			if(accumulatedRemainder >= 1) {
				annualQuantity += 1;
				accumulatedRemainder -= 1;
			}

			accumulatedVolume += annualQuantity;

			System.debug(accumulatedRemainder);
			System.debug(accumulatedVolume);

			newContractPaymentPlanPeriods.add(new EUR_CRM_Contract_Payment_Plan_Period__c(
				EUR_CRM_Contract_Activity_Item__c 	 	= caItem.Id,
				EUR_CRM_Contract_Product_Item__c		= cpItem.Id,
				EUR_CRM_CPPP_Unit__c					= cpItem.EUR_CRM_Unit__c,
				EUR_CRM_CPPP_Rate__c 					= cpItem.EUR_CRM_Amount__c,
				EUR_CRM_CPPP_Volume__c					= annualQuantity.intValue(),
				EUR_CRM_CPPP_Amount__c					= cpItem.EUR_CRM_Amount__c * annualQuantity.intValue(),
				EUR_CRM_Contract_Payment_Plan__c  	 	= relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c).Id,
				EUR_CRM_Description__c					= cpItem.EUR_CRM_Description__c,
				recordTypeId 						 	= paymentPlanPeriodRt,
				EUR_CRM_CPPP_Earliest_Date_of_Invoice__c= startDate.addYears(1),
				EUR_CRM_Payment_Period_Start_Date__c 	= startDate,
				EUR_CRM_Payment_Period_End_Date__c   	= startDate.addYears(1).addDays(-1),
				EUR_CRM_CPPP_Payment_Term__c			= 'Jährlich nach Leistungserfüllung'
			));

			createContractPaymentPlanPeriodYearly(
				startDate.addYears(1),
				endDate,
				newContractPaymentPlanPeriods,
				cpItem,
				caItem,
				relatedContractPaymentPlans,
				totalNumOfMonths, accumulatedVolume, accumulatedRemainder);
		}
	}

	public void createContractPaymentPlanPeriodHalfYearly(Date startDate, Date endDate,
			List<EUR_CRM_Contract_Payment_Plan_Period__c> newContractPaymentPlanPeriods, 
			EUR_CRM_Contract_Product_Item__c cpItem ,EUR_CRM_Contract_Activity_Item__c caItem,
			Map<Id, EUR_CRM_Contract_Payment_Plan__c> relatedContractPaymentPlans, Integer totalNumOfMonths,
			Decimal accumulatedVolume, Decimal accumulatedRemainder) {

		if(totalNumOfMonths == 0) {
			totalNumOfMonths = startDate.monthsBetween(endDate);

			// Round up remaining days to one month
			if(startDate.addMonths(totalNumOfMonths).daysBetween(endDate) > 0) {
				totalNumOfMonths = totalNumOfMonths + 1;
			} else if(totalNumofMonths == 0) {
				// Special case: start Date and End Date are the same date
				totalNumOfMonths = 1;
			}

			System.debug(totalNumOfMonths);
		}

		System.debug(startDate.monthsBetween(endDate));

		if(startDate.monthsBetween(endDate) < 6 || (startDate.monthsBetween(endDate) == 6 && startDate.addMonths(6).daysBetween(endDate) <= 0)) {
			// Special case when start date and end date are on the same month
			Integer numOfMonths = startDate.monthsBetween(endDate);
			// Round up remaining days to one month
			if(startDate.addMonths(numOfMonths).daysBetween(endDate) > 0) {
				numOfMonths = numOfMonths + 1;
			} else if(numOfMonths == 0) {
				// Special case: start Date and End Date are the same date
				numOfMonths = 1;
			}

			System.debug(numOfMonths);

			Decimal annualQuantity = cpItem.EUR_CRM_Quantity__c * numOfMonths / totalNumOfMonths;
			// accumulates the remainders and add one to yearly quantity if the remainder is a round number (e.g more than 1)
			accumulatedRemainder = accumulatedRemainder + annualQuantity - annualQuantity.intValue();
			if(accumulatedRemainder >= 1) {
				annualQuantity += 1;
			}

			accumulatedVolume += annualQuantity;
			// if accumulatedVolume is not the same as the actual volume, add one to annualQuantity
			if(accumulatedVolume < cpItem.EUR_CRM_Quantity__c) {
				annualQuantity += 1;
			}

			System.debug(annualQuantity);
			System.debug(accumulatedVolume);

			newContractPaymentPlanPeriods.add(new EUR_CRM_Contract_Payment_Plan_Period__c(
				EUR_CRM_Contract_Activity_Item__c 	 	= caItem.Id,
				EUR_CRM_Contract_Product_Item__c		= cpItem.Id,
				EUR_CRM_CPPP_Unit__c					= cpItem.EUR_CRM_Unit__c,
				EUR_CRM_CPPP_Rate__c 					= cpItem.EUR_CRM_Amount__c,
				EUR_CRM_CPPP_Volume__c					= annualQuantity.intValue(),
				EUR_CRM_CPPP_Amount__c					= cpItem.EUR_CRM_Amount__c * annualQuantity.intValue(),
				EUR_CRM_Contract_Payment_Plan__c  	 	= relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c).Id,
				EUR_CRM_Description__c				= cpItem.EUR_CRM_Description__c,
				recordTypeId 						 	= paymentPlanPeriodRt,
				EUR_CRM_Payment_Period_Start_Date__c 	= startDate,
				EUR_CRM_Payment_Period_End_Date__c   	= endDate,
				EUR_CRM_CPPP_Earliest_Date_of_Invoice__c= endDate.addDays(1),
				EUR_CRM_CPPP_Payment_Term__c			= 'Nach Umsetzung'
			));
		} else {
			Decimal annualQuantity = cpItem.EUR_CRM_Quantity__c * 6 / totalNumOfMonths;

			// accumulates the remainders and add one to yearly quantity if the remainder is a round number (e.g more than 1)
			accumulatedRemainder = accumulatedRemainder + annualQuantity - annualQuantity.intValue();
			if(accumulatedRemainder >= 1) {
				annualQuantity += 1;
				accumulatedRemainder -= 1;
			}

			accumulatedVolume += annualQuantity;

			System.debug(accumulatedRemainder);
			System.debug(accumulatedVolume);

			newContractPaymentPlanPeriods.add(new EUR_CRM_Contract_Payment_Plan_Period__c(
				EUR_CRM_Contract_Activity_Item__c 	 	= caItem.Id,
				EUR_CRM_Contract_Product_Item__c		= cpItem.Id,
				EUR_CRM_CPPP_Unit__c					= cpItem.EUR_CRM_Unit__c,
				EUR_CRM_CPPP_Rate__c 					= cpItem.EUR_CRM_Amount__c,
				EUR_CRM_CPPP_Volume__c					= annualQuantity.intValue(),
				EUR_CRM_CPPP_Amount__c					= cpItem.EUR_CRM_Amount__c * annualQuantity.intValue(),
				EUR_CRM_Contract_Payment_Plan__c  	 	= relatedContractPaymentPlans.get(caItem.EUR_CRM_Contract__c).Id,
				EUR_CRM_Description__c				= cpItem.EUR_CRM_Description__c,
				recordTypeId 						 	= paymentPlanPeriodRt,
				EUR_CRM_Payment_Period_Start_Date__c 	= startDate,
				EUR_CRM_Payment_Period_End_Date__c   	= startDate.addMonths(6).addDays(-1),
				EUR_CRM_CPPP_Earliest_Date_of_Invoice__c= startDate.addMonths(6),
				EUR_CRM_CPPP_Payment_Term__c			= 'Halbjährlich nach Leistungserfüllung'
			));

			createContractPaymentPlanPeriodHalfYearly(
				startDate.addMonths(6),
				endDate,
				newContractPaymentPlanPeriods,
				cpItem,
				caItem,
				relatedContractPaymentPlans,
				totalNumOfMonths, accumulatedVolume, accumulatedRemainder);
		}
	}
}