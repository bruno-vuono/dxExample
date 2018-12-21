/*********************************************************************************
 * Name: ASI_CRM_SG_GenContractMarginBatch
 * Description: Generation the contract margin credit / debit not and line item
 *
 * Version History
 * Date 			Developer 			Comments
 * --------------- -------------------- --------------------------------------------------------------------------------
 * 2017-03-30		Vincent Lam			Create
 * 2018-01-19		Vincent lam			[VL 1.0] P4.1B logic, store value in bottle, group by SKU
 *										[VL 1.1] P4.1B logic, only map offtake with contract target by SKU
 *										[VL 1.2] P4.1B logic, the year/month in Reason field in header is the offtake month
 *										[VL 1.3] P4.1B logic, check CPO vs RTM PRS-WS price
 *										[VL 1.4] P4.1B logic, net the amount in each SKU level before creating credit/debit 
 * 2018-04-03		Vincent Lam			[VL 2.0] P4.1B logic change, use new calculation for Jan 2018 onwards
 *										[VL 2.1] P4.1B logic change, allow generate before Jan 2018 with specific wholesaler
 *										[VL 2.2] P4.1B logic change, allow generate for regular size SKU
*/
global class ASI_CRM_SG_GenContractMarginBatch implements Database.Batchable<sobject>, Database.stateful {

	public static final Map<String, Schema.SObjectField> CONTRACT_FIELD_MAP = Schema.SObjectType.ASI_TH_CRM_Contract__c.fields.getMap();
	public static final Map<String, Schema.SObjectField> SKU_FIELD_MAP = Schema.SObjectType.ASI_MFM_SKU_Code__c.fields.getMap();

	public static final Id CREDITNOTE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Credit_Note');
	public static final Id CREDITNOTE_LINEITEM_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note_Line_Item__cASI_CRM_SG_Contract_Margin_Credit_Note_Line_Item');
	public static final Id DEBITNOTE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Debit_Note');
	public static final Id DEBITNOTE_LINEITEM_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note_Line_Item__cASI_CRM_SG_Contract_Margin_Debit_Note_Line_Item');

    public static final map<string, string> MAP_HEADER_RTID = new map<string, string>{
        'credit'=>CREDITNOTE_RECORDTYPE_ID,
        'debit'=>DEBITNOTE_RECORDTYPE_ID
    };
    
    public static final map<string, string> MAP_LINE_RTID = new map<string, string>{
        'credit'=>CREDITNOTE_LINEITEM_RECORDTYPE_ID,
        'debit'=>DEBITNOTE_LINEITEM_RECORDTYPE_ID
    };
    
    public static final map<string, string> MAP_HEADER_RTID_CREDITORDEBIT = new map<string, string>{
        CREDITNOTE_RECORDTYPE_ID=>'Credit Note',
        DEBITNOTE_RECORDTYPE_ID=>'Debit Note'
    };
    
	public static final Integer NINE_L_CONVERSION = 900;
	public static final String REASON_PREFIX = 'ContMarg_';
	public static final String CREDITNOTE_TYPE = 'Contract Margin';
	public static final String DEFAULT_CURRENCY = 'SGD';
	public static final Integer DEFAULT_EXCHANGERATE = 1;

	//Variable for init query
	global string monthStr, yearStr;
    global Date fromDate, toDate;
    global Integer fromYearInt, fromMonthInt, toYearInt, toMonthInt;
	global Id contractOwnerId;
	global Set<Id> filterContractIdSet;
    global Map<Id, Id> skuMappingMap;
    global Map<string, string> map_subBrandId_code;

	//Global Variable using when all batch completed
	Map<Id, ASI_TH_CRM_Contract__c> contractMap;
	Map<Id, ASI_MFM_SKU_Code__c> skuMap;
	Map<Id, ASI_CRM_MY_SKUPriceCost__c> skuPriceMap;
    /* [VL 2.0] BEGIN */
	global Date cutoffDate = Date.newInstance(2018, 1, 1);
	global Boolean newMethod;
    /* [VL 2.0] END */
    /* [VL 2.1] BEGIN */
	global string wholesalerId;
    /* [VL 2.1] END */

	Map<string, OfftakeWrapper> offtakeWrapperMap;

	/* [VL 2.1] BEGIN */
	global ASI_CRM_SG_GenContractMarginBatch(String fromMonth, String fromYear, String wholesalerId){
		this(fromMonth,fromYear);
		this.contractOwnerId = null;
		this.wholesalerId = wholesalerId;
	}
	/* [VL 2.1] END */
	
	global ASI_CRM_SG_GenContractMarginBatch(String fromMonth, String fromYear) {
		monthStr = fromMonth;
		yearStr = fromYear;
		contractOwnerId = UserInfo.getUserId();
        
        fromYearInt = Integer.valueOf(fromYear);
        fromMonthInt = Integer.valueOf(fromMonth);
        toYearInt = Integer.valueOf(fromYear);
        toMonthInt = Integer.valueOf(fromMonth);
        
        Integer toDayInt = Date.daysInMonth(toYearInt, toMonthInt);
        
        fromDate = Date.newInstance(fromYearInt, fromMonthInt, 1);
        toDate = Date.newInstance(toYearInt, toMonthInt, toDayInt);

		contractMap       = new Map<Id, ASI_TH_CRM_Contract__c>();
		skuMap            = new Map<Id, ASI_MFM_SKU_Code__c>();
		offtakeWrapperMap = new Map<string, OfftakeWrapper>();
		
		/* [VL 2.0] BEGIN */
		newMethod = fromDate >= cutoffDate ? true : false;
		/* [VL 2.0] END */
		/* [VL 2.1] BEGIN */
		wholesalerId = null;
		/* [VL 2.1] END */
	}

	global ASI_CRM_SG_GenContractMarginBatch(String fromMonth, String fromYear, Set<Id> filterContractIdSet) {
		this(fromMonth,fromYear);
		this.filterContractIdSet = filterContractIdSet;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
  		
        skuMappingMap = new Map<Id, Id>();
        skuMappingMap = getSKUMapping();
        
        map_subBrandId_code = new Map<string, string>();
        map_subBrandId_code = getSubbrandCodeMap();
		
        String query = '';
		query += 'SELECT ASI_CRM_Latest_Vintage__r.ASI_HK_CRM_Packaging_Size__c, ';
		query += 'ASI_CRM_SKU__r.ASI_HK_CRM_Packaging_Size__c,ASI_CRM_SKU__r.ASI_HK_CRM_Std_Bottle_Size__c,ASI_CRM_Latest_Vintage__c, ';
		query += 'ASI_TH_CRM_Sub_brand__c,ASI_CRM_Contract__c,ASI_CRM_SG_Customer__c,ASI_TH_CRM_Year__c,ASI_TH_CRM_Month__c, ';
		query += 'ASI_CRM_FromWS__c, ASI_CRM_SKU__c,ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_CRM_SKU__r.ASI_CRM_Regular_Size__c, ';
		query += 'ASI_TH_CRM_Quantity__c,ASI_CRM_Converted_Qty_9L__c,ASI_CRM_SKU__r.ASI_CRM_SG_Wine_Category__c ';
		query += ', ASI_CRM_Contract__r.ASI_TH_CRM_Start_Date__c ';
		query += ', ASI_CRM_SG_Customer__r.name ';
		query += 'FROM ASI_TH_CRM_Actual_Offtake__c ';
		query += 'WHERE ASI_TH_CRM_Offtake_G_L_Date__c >= :fromDate AND ASI_TH_CRM_Offtake_G_L_Date__c <= :toDate ';
		/* [VL 2.1] BEGIN */
		/*
		query += 'AND ASI_CRM_Contract__r.ownerId= \'' + this.contractOwnerid + '\' ';
		*/
		if(this.contractOwnerid != null){
			query += 'AND ASI_CRM_Contract__r.ownerId= \'' + this.contractOwnerid + '\' ';
		}
		/* [VL 2.1] END */
		query += 'AND ASI_CRM_SKU__c != null ';
		query += 'AND ASI_CRM_SG_Customer__c != null ';
		query += 'AND ASI_CRM_Contract__c != null ';
		query += 'AND ASI_CRM_FromWS__c != null ';
		query += 'AND ASI_CRM_Contract__r.ASI_TH_CRM_Contract_Status__c = \'Contract Approved\' ';
		query += 'AND ASI_CRM_Contract__r.ASI_CRM_Contract_Exist_Before_RTM__c = true ';
		/* [VL 2.1] BEGIN */
		if(this.wholesalerId != null){
			query += 'AND ASI_CRM_FromWS__c = \'' + this.wholesalerId + '\' ';
		}
		/* [VL 2.1] END */

		if(filterContractIdSet != null && filterContractIdSet.size() > 0) {
			String contractIdStr = '';
			for(Id contractId : filterContractIdSet) {
				contractIdStr += '\'' + contractId + '\',';
  			}
  			contractIdStr = contractIdStr.subString(0, contractIdStr.length() - 1);
  			query += 'AND ASI_CRM_Contract__c in (' + contractIdStr + ') ';
  		}

		query += 'ORDER BY ASI_CRM_Contract__c asc ';

  		return Database.getQueryLocator(query);
  	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {

		List<ASI_TH_CRM_Actual_Offtake__c> actualOfftakeList = (List<ASI_TH_CRM_Actual_Offtake__c>) scope;

		List<ASI_TH_CRM_Actual_Offtake__c> validActualOfftakeList = new List<ASI_TH_CRM_Actual_Offtake__c>();

		Set<Id> contractIdSet = new Set<Id>();
		Set<Id> skuIdSet = new Set<Id>();

		//Find out the valid actual offtake record(s)
		for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : actualOfftakeList) {

			if(String.isNotBlank(actualOfftake.ASI_CRM_SKU__c) && String.isNotBlank(actualOfftake.ASI_CRM_Contract__c)) {

				validActualOfftakeList.add(actualOfftake);
				skuIdSet.add(actualOfftake.ASI_CRM_SKU__c);
	  			// Special case, also retrieve the SKU from the latest vintage, if it exists
	  			if(actualOfftake.ASI_CRM_Latest_Vintage__c != null) {
	  				skuIdSet.add(actualOfftake.ASI_CRM_Latest_Vintage__c);
	  			}
	  			contractIdSet.add(actualOfftake.ASI_CRM_Contract__c);

	  		}

	  	}

		//Execute if valid actual offtake record(s) were found
		if(validActualOfftakeList.size() > 0) {
			List<ASI_TH_CRM_Contract__c> contractList = getContractList(contractIdSet);
			contractMap.putAll(contractList);

			//Find out the sku related to contract target
	  		for(ASI_TH_CRM_Contract__c contract : contractList) {
	  			List<ASI_CRM_ContractTarget__c> contractTargetList = contract.Contract_Target__r;
	  			for(ASI_CRM_ContractTarget__c contractTarget : contractTargetList) {
	  				if(String.isNotBlank(contractTarget.ASI_CRM_SKU__c)) {
	  					skuIdSet.add(contractTarget.ASI_CRM_SKU__c);
	  				}
	  			}
	  		}

	  		skuMap.putAll(getSKUList(skuIdSet));

	  		for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : validActualOfftakeList) {
	  			ASI_TH_CRM_Contract__c contract = contractMap.get(actualOfftake.ASI_CRM_Contract__c);

	  			OfftakeWrapper offtakeWrapper; 
                string outletId = actualOfftake.ASI_CRM_SG_Customer__c != null ? actualOfftake.ASI_CRM_SG_Customer__c : contract.ASI_CRM_CN_Outlet_WS__c;
                string outletName = actualOfftake.ASI_CRM_SG_Customer__c != null ? actualOfftake.ASI_CRM_SG_Customer__r.name : contract.ASI_CRM_CN_Outlet_WS__r.name;
                string wholesalerId = actualOfftake.ASI_CRM_FromWS__c;
				/* [VL 1.4] BEGIN */
				/*
                string creditOrDebit = actualOfftake.ASI_TH_CRM_Quantity__c >= 0 ? 'credit' : 'debit';
				*/
				/* [VL 1.4] END */
                string wrapper_key = contract.Id+'_'+outletId+'_'+wholesalerId/* [VL 1.4] BEGIN *//*+'_'+creditOrDebit*//* [VL 1.4] END */;
	  			if(!offtakeWrapperMap.containsKey(wrapper_key)) {
	  				offtakeWrapper = new OfftakeWrapper(
						contract, 
						outletId, 
						outletName, 
						wholesalerId, 
						skuMappingMap
						/* [VL 1.4] BEGIN */
						/*
						, creditOrDebit
						*/
						/* [VL 1.4] END */
						/* [VL 2.0] BEGIN */
						, newMethod
						/* [VL 2.0] END */);
	  			} else {
	  				offtakeWrapper = offtakeWrapperMap.get(wrapper_key);
	  			}

				ASI_CRM_ContractTarget__c contractTarget;
				/* [VL 1.1] BEGIN */
				/*
                // check if map by wine category
  				if(offtakeWrapper.contractTargetWineCategoryMap.containsKey(actualOfftake.ASI_CRM_SKU__r.ASI_CRM_SG_Wine_Category__c)) {
  					contractTarget = offtakeWrapper.contractTargetWineCategoryMap.get(actualOfftake.ASI_CRM_SKU__r.ASI_CRM_SG_Wine_Category__c);
                } else                
                // check if map by sub-brand
  				if(offtakeWrapper.contractTargetSubBrandMap.containsKey(actualOfftake.ASI_TH_CRM_Sub_brand__c)) {
  					contractTarget = offtakeWrapper.contractTargetSubBrandMap.get(actualOfftake.ASI_TH_CRM_Sub_brand__c);
                } else                
				*/
				/* [VL 1.1] END */
                // check if map by SKU
  				if(offtakeWrapper.contractTargetSKUMap.containsKey(actualOfftake.ASI_CRM_SKU__c)) {
  					contractTarget = offtakeWrapper.contractTargetSKUMap.get(actualOfftake.ASI_CRM_SKU__c);
                } else                
                // check if map by new SKU
                if (skuMappingMap.containsKey(actualOfftake.ASI_CRM_SKU__c)){
                    if(offtakeWrapper.contractTargetSKUMap_newSKU.containsKey(skuMappingMap.get(actualOfftake.ASI_CRM_SKU__c))) {
                        contractTarget = offtakeWrapper.contractTargetSKUMap_newSKU.get(skuMappingMap.get(actualOfftake.ASI_CRM_SKU__c));
                    }
                }
				/* [VL 2.2] BEGIN */
				else
				if (offtakeWrapper.contractTargetRegularSizeSubBrandMap.containsKey(actualOfftake.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c) && actualOfftake.ASI_CRM_SKU__r.ASI_CRM_Regular_Size__c){
					contractTarget = offtakeWrapper.contractTargetRegularSizeSubBrandMap.get(actualOfftake.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c);
				}
				/* [VL 2.2] END */
                
                if (contractTarget != null){
					offtakeWrapper.actualOfftakeMap.put(actualOfftake, contractTarget);
					
					/* [VL 1.3] BEGIN */
					/* [VL 1.4] BEGIN */
					/*
					decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c;
					decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : (contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0);
					if (consumerOffer != null && consumerOffer > pricePRSWS_RTM){
						string creditOrDebit_reverse = actualOfftake.ASI_TH_CRM_Quantity__c >= 0 ? 'debit' : 'credit';
						String wrapper_key_reverse = contract.Id+'_'+outletId+'_'+wholesalerId+'_'+creditOrDebit_reverse;
						OfftakeWrapper offtakeWrapper_reverse; 
						if(!offtakeWrapperMap.containsKey(wrapper_key_reverse)) {
							offtakeWrapper_reverse = new OfftakeWrapper(contract, outletId, outletName, wholesalerId, skuMappingMap, creditOrDebit_reverse);
						} else {
							offtakeWrapper_reverse = offtakeWrapperMap.get(wrapper_key_reverse);
						}
						offtakeWrapper_reverse.actualOfftakeMap.put(actualOfftake, contractTarget);
						offtakeWrapperMap.put(wrapper_key_reverse, offtakeWrapper_reverse);
					}
					*/
					/* [VL 1.4] END */
					/* [VL 1.3] END */
				}
	  			offtakeWrapperMap.put(wrapper_key, offtakeWrapper);
	  		}

	  	}

  	}

  	global void finish(Database.BatchableContext BC) {

		/* [VL 1.2] BEGIN */
		/*
		Datetime dateInstance = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
		*/
  		Datetime dateInstance = Datetime.newInstance(Integer.valueOf(this.yearStr), Integer.valueOf(this.monthStr), 15);
		/* [VL 1.2] END */

  		Map<string, ASI_CRM_Credit_Debit_Note__c> map_creditNote = new Map<string, ASI_CRM_Credit_Debit_Note__c>();
  		Map<string, List<ASI_CRM_Credit_Debit_Note_Line_Item__c>> map_creditNoteLine = new Map<string, List<ASI_CRM_Credit_Debit_Note_Line_Item__c>>();

  		for(string wrapper_key : offtakeWrapperMap.keySet()) {
  			Map<Id, Decimal> totalContractMarginMap     = new Map<Id, Decimal>();
  			Map<String, Decimal> totalVolumeMap              = new Map<String, Decimal>();
  			Map<Id, Decimal> compensationRateMap      = new Map<Id, Decimal>();
  			Map<Id, Decimal> wholesalerMarginRateMap      = new Map<Id, Decimal>();
			/* [VL 1.0] BEGIN */
  			Map<string, Decimal> totalContractMarginMap_bottle     = new Map<string, Decimal>();
  			Map<string, Decimal> totalVolumeMap_bottle              = new Map<string, Decimal>();
  			Map<string, Decimal> compensationRateMap_bottle      = new Map<string, Decimal>();
  			Map<string, Decimal> wsOTpriceMap    			  = new Map<string, Decimal>();
  			Map<string, Decimal> prsWSpriceMap    			  = new Map<string, Decimal>();
  			Map<string, Decimal> consumerPriceOfferMap  	    = new Map<string, Decimal>();
  			Map<string, Decimal> wholesalerMarginRateMap_bottle      = new Map<string, Decimal>();
			Map<string, string> map_sku_subBrand = new Map<string, string>();
			/* [VL 1.0] END */
			/* [VL 1.4] BEGIN */
			Set<string> set_creditDebit = new Set<string>();
			/* [VL 1.4] END */

  			OfftakeWrapper offtakeWrapper = offtakeWrapperMap.get(wrapper_key);

  			for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : offtakeWrapper.actualOfftakeMap.keySet()) {

                ASI_CRM_ContractTarget__c contractTarget = offtakeWrapper.actualOfftakeMap.get(actualOfftake);
                                
				ASI_MFM_SKU_Code__c contractTargetSKU = skuMap.get(contractTarget.ASI_CRM_SKU__c);
				ASI_MFM_SKU_Code__c offtakeSKU = skuMap.get(actualOfftake.ASI_CRM_SKU__c);

				Decimal qty = actualOfftake.ASI_TH_CRM_Quantity__c != null ? actualOfftake.ASI_TH_CRM_Quantity__c : 0;
				
                string offtakeQtySign = qty >= 0 ? 'positive' : 'negative';
				
				String key = actualOfftake.ASI_CRM_SKU__c + '_' + actualOfftake.ASI_CRM_SG_Customer__c + '_' + offtakeQtySign;
				
				
				decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c;
				decimal priceOnTrade = contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c : 0;
				decimal pricePRSWS = contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0;
				/* [VL 1.3] BEGIN */
				/*
				decimal compensation = consumerOffer > priceOnTrade ? 0 : priceOnTrade - consumerOffer;
				decimal wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				compensationRateMap_bottle.put(key, compensation);
				wholesalerMarginRateMap_bottle.put(key, wholesalerMargin);
				*/
				decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : pricePRSWS;
				/* [VL 2.0] BEGIN */
				decimal priceOnTrade_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c : priceOnTrade;
				/* [VL 2.0] END */
				decimal wholesalerMargin = 0;
				decimal compensation = 0;
				decimal backCompensation = 0;
				/* [VL 1.4] BEGIN */
				/*
				if((offtakeWrapper.creditOrDebit == 'credit' && qty < 0) || (offtakeWrapper.creditOrDebit == 'debit' && qty >= 0)){
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > pricePRSWS_RTM ? consumerOffer - pricePRSWS_RTM : 0);
				} else {
					wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
					compensation = consumerOffer == null ? 0 : (pricePRSWS_RTM > consumerOffer ? pricePRSWS_RTM - consumerOffer : 0);
					compensationRateMap_bottle.put(key, compensation);
					wholesalerMarginRateMap_bottle.put(key, wholesalerMargin);
				}
				*/
				
				// Description (Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete)
				/*
				1. If offtake quantity >= 0
				a. if RTM WS price > CPO --> Credit Note (Amount = RTM WS price - CPO + Wholesaler Margin)
				b. if RTM WS price = CPO --> Credit Note (Amount = Wholesaler Margin)
				c. if (RTM WS price < CPO) AND (CPO - RTM WS price < Wholesaler Margin) --> Credit Note (Amount = Wholesaler Margin - CPO + RTM WS price)
				d. if (RTM WS price < CPO) AND (CPO - RTM WS price > Wholesaler Margin) --> Debit Note (Amount = CPO - RTM WS price - Wholesaler Margin)
				e. if (RTM WS price < CPO) AND (CPO - RTM WS price = Wholesaler Margin) --> none

				2. If offtake quantity < 0
				a. if RTM WS price > CPO --> Debit Note (Amount = RTM WS price - CPO + Wholesaler Margin)
				b. if RTM WS price = CPO --> Debit Note (Amount = Wholesaler Margin)
				c. if (RTM WS price < CPO) AND (CPO - RTM WS price < Wholesaler Margin) --> Debit Note (Amount = Wholesaler Margin - CPO + RTM WS price)
				d. if (RTM WS price < CPO) AND (CPO - RTM WS price > Wholesaler Margin) --> Credit Note (Amount = CPO - RTM WS price - Wholesaler Margin)
				e. if (RTM WS price < CPO) AND (CPO - RTM WS price = Wholesaler Margin) --> none
				*/
				// Description
				/*
				Contract Margin credit/debit note from Jan 2018 onwards
				- Calculation:
						1. If offtake quantity >= 0
						a. if RTM WS-OT price (W1) > CPO --> Credit Note, Amount = RTM WS-OT (W1) price - CPO
						b. if RTM WS-OT price (W1) = CPO --> none
						c. if RTM WS-OT price (W1) < CPO --> Debit Note, Amount = CPO - RTM WS-OT (W1) price
						2. If offtake quantity < 0
						a. if RTM WS-OT price (W1) > CPO --> Debit Note, Amount = RTM WS-OT (W1) price - CPO
						b. if RTM WS-OT price (W1) = CPO --> none
						c. if RTM WS-OT price (W1) < CPO --> Credit Note, Amount = CPO - RTM WS-OT (W1) price
				- The generation only applies to non-RTM contracts which have Consumer Price Offer in the contract target. 
				- Since Sales Rep. are still able to revise the non-RTM contracts and add new contract targets, we have to block the selection if the SKU does not have RTM PRS-WS (WS) price or RTM WS-OT (W1) price.

				Contract Margin credit/debit note before Jan 2018
				- Calculation:
						1. If offtake quantity >= 0
						a. if non-RTM WS price > CPO --> Credit Note (Amount = non-RTM WS price - CPO + Wholesaler Margin)
						b. if non-RTM WS price = CPO --> Credit Note (Amount = Wholesaler Margin)
						c. if ( non-RTM WS price < CPO) AND (CPO - non-RTM WS price < Wholesaler Margin) --> Credit Note (Amount = Wholesaler Margin - CPO + non-RTM WS price)
						d. if ( non-RTM WS price < CPO) AND (CPO - non-RTM WS price > Wholesaler Margin) --> Debit Note (Amount = CPO - non-RTM WS price - Wholesaler Margin)
						e. if ( non-RTM WS price < CPO) AND (CPO - non-RTM WS price = Wholesaler Margin) --> none
						2. If offtake quantity < 0
						a. if non-RTM WS price > CPO --> Debit Note (Amount = non-RTM WS price - CPO + Wholesaler Margin)
						b. if non-RTM WS price = CPO --> Debit Note (Amount = Wholesaler Margin)
						c. if ( non-RTM WS price < CPO) AND (CPO - non-RTM WS price < Wholesaler Margin) --> Debit Note (Amount = Wholesaler Margin - CPO + non-RTM WS price)
						d. if ( non-RTM WS price < CPO) AND (CPO - non-RTM WS price > Wholesaler Margin) --> Credit Note (Amount = CPO - non-RTM WS price - Wholesaler Margin)
						e. if ( non-RTM WS price < CPO) AND (CPO - non-RTM WS price = Wholesaler Margin) --> none
				*/
				
				String creditOrDebit = '';
				/* [VL 2.0] BEGIN */
				/*
				wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				if(qty >= 0){
					if (consumerOffer == null) {
						creditOrDebit = 'credit';
					} else
					if (pricePRSWS_RTM >= consumerOffer) {
						creditOrDebit = 'credit';
						compensation = pricePRSWS_RTM - consumerOffer;
					} else
					if (pricePRSWS_RTM < consumerOffer && ((consumerOffer - pricePRSWS_RTM) <= wholesalerMargin)) {
						creditOrDebit = 'credit';
						compensation = pricePRSWS_RTM - consumerOffer;
					} else {
						creditOrDebit = 'debit';
						compensation = consumerOffer - pricePRSWS_RTM;
						wholesalerMargin = - wholesalerMargin;
					}
				}else{
					if (consumerOffer == null) {
						creditOrDebit = 'debit';
					} else
					if (pricePRSWS_RTM >= consumerOffer) {
						creditOrDebit = 'debit';
						compensation = pricePRSWS_RTM - consumerOffer;
					} else
					if (pricePRSWS_RTM < consumerOffer && ((consumerOffer - pricePRSWS_RTM) <= wholesalerMargin)) {
						creditOrDebit = 'debit';
						compensation = pricePRSWS_RTM - consumerOffer;
					} else {
						creditOrDebit = 'credit';
						compensation = consumerOffer - pricePRSWS_RTM;
						wholesalerMargin = - wholesalerMargin;
					}
				}
				*/
				// Jan 2018 onwards
				if(newMethod){
					wholesalerMargin = 0;
					if(qty >= 0){
						if (consumerOffer == null) {
							creditOrDebit = 'credit';
						} else
						if (priceOnTrade_RTM >= consumerOffer) {
							creditOrDebit = 'credit';
							compensation = priceOnTrade_RTM - consumerOffer;
						} else
						if (pricePRSWS_RTM < consumerOffer) {
							creditOrDebit = 'debit';
							compensation = consumerOffer - priceOnTrade_RTM;
						}
					}else{
						if (consumerOffer == null) {
							creditOrDebit = 'debit';
						} else
						if (priceOnTrade_RTM >= consumerOffer) {
							creditOrDebit = 'debit';
							compensation = priceOnTrade_RTM - consumerOffer;
						} else
						if (pricePRSWS_RTM < consumerOffer) {
							creditOrDebit = 'credit';
							compensation = consumerOffer - priceOnTrade_RTM;
						}
					}
				} 
				// before Jan 2018
				else {
					wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
					if(qty >= 0){
						if (consumerOffer == null) {
							creditOrDebit = 'credit';
						} else
						if (pricePRSWS >= consumerOffer) {
							creditOrDebit = 'credit';
							compensation = pricePRSWS - consumerOffer;
						} else
						if (pricePRSWS < consumerOffer && ((consumerOffer - pricePRSWS) <= wholesalerMargin)) {
							creditOrDebit = 'credit';
							compensation = pricePRSWS - consumerOffer;
						} else {
							creditOrDebit = 'debit';
							compensation = consumerOffer - pricePRSWS;
							wholesalerMargin = - wholesalerMargin;
						}
					}else{
						if (consumerOffer == null) {
							creditOrDebit = 'debit';
						} else
						if (pricePRSWS >= consumerOffer) {
							creditOrDebit = 'debit';
							compensation = pricePRSWS - consumerOffer;
						} else
						if (pricePRSWS < consumerOffer && ((consumerOffer - pricePRSWS) <= wholesalerMargin)) {
							creditOrDebit = 'debit';
							compensation = pricePRSWS - consumerOffer;
						} else {
							creditOrDebit = 'credit';
							compensation = consumerOffer - pricePRSWS;
							wholesalerMargin = - wholesalerMargin;
						}
					}
				}
				/* [VL 2.0] END */
				set_creditDebit.add(creditOrDebit);
				key += '_' + creditOrDebit;
				compensationRateMap_bottle.put(key, compensation);
				wholesalerMarginRateMap_bottle.put(key, wholesalerMargin);
				/* [VL 1.4] END */
				/* [VL 1.3] END */
				
				/* [VL 1.0] BEGIN */
				/*
				Decimal bottleSize = contractTargetSKU.ASI_HK_CRM_Std_Bottle_Size__c == null ? 0 : contractTargetSKU.ASI_HK_CRM_Std_Bottle_Size__c;
				Decimal contractMarginRate = (compensation + wholesalerMargin) / (bottleSize / NINE_L_CONVERSION);
				Decimal compensationRate = compensation / (bottleSize / NINE_L_CONVERSION);
				Decimal wholesalerMarginRate = wholesalerMargin / (bottleSize / NINE_L_CONVERSION);

				compensationRateMap.put(actualOfftake.ASI_TH_CRM_Sub_brand__c, compensationRate);
				wholesalerMarginRateMap.put(actualOfftake.ASI_TH_CRM_Sub_brand__c, wholesalerMarginRate);

				Decimal offtakeSKUBottleSize = offtakeSKU.ASI_HK_CRM_Std_Bottle_Size__c == null ? 0 : offtakeSKU.ASI_HK_CRM_Std_Bottle_Size__c;

				Decimal totalContractMargin = 0;
				if(totalContractMarginMap.containsKey(actualOfftake.ASI_TH_CRM_Sub_brand__c)) {
					totalContractMargin = totalContractMarginMap.get(actualOfftake.ASI_TH_CRM_Sub_brand__c);
				}
				
				decimal volume9L = actualOfftake.ASI_TH_CRM_Quantity__c * actualOfftake.ASI_CRM_SKU__r.ASI_HK_CRM_Std_Bottle_Size__c / NINE_L_CONVERSION;
				
				totalContractMargin += volume9L * contractMarginRate;
				totalContractMarginMap.put(actualOfftake.ASI_TH_CRM_Sub_brand__c, totalContractMargin);

				Decimal totalVolume = 0;
				if(totalVolumeMap.containsKey(actualOfftake.ASI_TH_CRM_Sub_brand__c)) {
					totalVolume = totalVolumeMap.get(actualOfftake.ASI_TH_CRM_Sub_brand__c);
				}
				totalVolume += volume9L;
				totalVolumeMap.put(actualOfftake.ASI_TH_CRM_Sub_brand__c, totalVolume);
				*/
				
				/* [VL 1.3] BEGIN */
				/*
				Decimal contractMarginRate_bottle = (compensation + wholesalerMargin) * qty;
				*/
				Decimal contractMarginRate_bottle = (compensation + wholesalerMargin + backCompensation) * math.abs(qty);
				/* [VL 1.3] END */
				
				Decimal volume9L = math.abs(qty) * actualOfftake.ASI_CRM_SKU__r.ASI_HK_CRM_Std_Bottle_Size__c / NINE_L_CONVERSION;				
				Decimal totalVolume = totalVolumeMap.containsKey(key) ? totalVolumeMap.get(key) : 0;
				totalVolumeMap.put(key, totalVolume + volume9L);
				
				Decimal totalContractMargin_bottle = totalContractMarginMap_bottle.containsKey(key) ? totalContractMarginMap_bottle.get(key) : 0;
				totalContractMarginMap_bottle.put(key, totalContractMargin_bottle + contractMarginRate_bottle);
				
				Decimal totalVolume_bottle = totalVolumeMap_bottle.containsKey(key) ? totalVolumeMap_bottle.get(key) : 0;
				totalVolumeMap_bottle.put(key, totalVolume_bottle + math.abs(qty));
				
				/* [VL 2.0] BEGIN */
				/*
				prsWSpriceMap.put(key, pricePRSWS_RTM);
				wsOTpriceMap.put(key, priceOnTrade);
				*/
				prsWSpriceMap.put(key, newMethod ? pricePRSWS_RTM : pricePRSWS);
				wsOTpriceMap.put(key, newMethod ? priceOnTrade_RTM : priceOnTrade);
				/* [VL 2.0] END */
				consumerPriceOfferMap.put(key, consumerOffer);
				
				String subBrandId = actualOfftake.ASI_TH_CRM_Sub_brand__c != null ? actualOfftake.ASI_TH_CRM_Sub_brand__c : actualOfftake.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c;
				
				map_sku_subBrand.put(actualOfftake.ASI_CRM_SKU__c, subBrandId);
				/* [VL 1.0] END */

  			}

			/* [VL 1.4] BEGIN */
			for (String creditOrDebit : set_creditDebit){
			/* [VL 1.4] END */
			
				ASI_CRM_Credit_Debit_Note__c creditNote = new ASI_CRM_Credit_Debit_Note__c();
				creditNote.ASI_CRM_Outlet__c = offtakeWrapper.outletId;
				creditNote.ASI_CRM_Contract__c = offtakeWrapper.contract.Id;
				creditNote.ASI_CRM_Wholesaler__c = offtakeWrapper.wholesalerId;
				creditNote.ASI_CRM_Reason__c = REASON_PREFIX + dateInstance.format('MMMyy', UserInfo.getTimeZone().getId()) + '_' + offtakeWrapper.outletName;
				creditNote.ASI_CRM_Status__c = 'Draft';
				creditNote.ASI_CRM_Invoice_Date__c = Date.today();
				creditNote.ASI_CRM_GL_Date__c = Date.today();
				creditNote.ASI_CRM_Year__c = this.yearStr;
				creditNote.ASI_CRM_Month__c = this.monthStr;
				creditNote.ASI_CRM_SYS_System_Generated__c = true;
				creditNote.ASI_CRM_Currency__c = DEFAULT_CURRENCY;
				creditNote.ASI_CRM_Base_Currency__c = DEFAULT_CURRENCY;
				creditNote.ASI_CRM_Exchange_Rate__c = DEFAULT_EXCHANGERATE;
				creditNote.RecordTypeId = MAP_HEADER_RTID.get(/* [VL 1.4] BEGIN *//*offtakeWrapper.*//* [VL 1.4] END */creditOrDebit);

				List<ASI_CRM_Credit_Debit_Note_Line_Item__c> creditNoteLineItemList = new List<ASI_CRM_Credit_Debit_Note_Line_Item__c>();
				/* [VL 1.0] BEGIN */
				/*
				for(Id subBrandId : totalContractMarginMap.keySet()) {
					decimal amount = totalContractMarginMap.containsKey(subBrandId) ? totalContractMarginMap.get(subBrandId) : 0;
					amount = math.abs(amount);
					if (amount.setScale(2)>0) {
						ASI_CRM_Credit_Debit_Note_Line_Item__c creditNoteLine = new ASI_CRM_Credit_Debit_Note_Line_Item__c();
						creditNoteLine.ASI_CRM_Sub_brand__c = subBrandId;
						creditNoteLine.ASI_CRM_Volume_9L__c = math.abs(totalVolumeMap.containsKey(subBrandId) ? totalVolumeMap.get(subBrandId) : 0);
						creditNoteLine.ASI_CRM_Contracted_Rate_9L__c = compensationRateMap.containsKey(subBrandId) ? compensationRateMap.get(subBrandId) : 0;
						creditNoteLine.ASI_CRM_Wholesaler_Rate_9L__c = wholesalerMarginRateMap.containsKey(subBrandId) ? wholesalerMarginRateMap.get(subBrandId) : 0;
						creditNoteLine.ASI_CRM_Amount__c = amount.setScale(2);
						creditNoteLine.ASI_CRM_Actual_Amount__c = amount.setScale(2);
						creditNoteLine.ASI_CRM_Type__c = CREDITNOTE_TYPE;
						creditNoteLine.ASI_CRM_Remark__c = REASON_PREFIX + map_subBrandId_code.get(subBrandId) + '_' + offtakeWrapper.outletName;
						creditNoteLine.RecordTypeId = MAP_LINE_RTID.get(offtakeWrapper.creditOrDebit);
						creditNoteLineItemList.add(creditNoteLine);
					}
					
				}
				*/
				for(String key : totalContractMarginMap_bottle.keySet()) {
					decimal amount = totalContractMarginMap_bottle.containsKey(key) ? totalContractMarginMap_bottle.get(key) : 0;
					string skuId = key.split('_')[0];
					string outletId = key.split('_')[1];
					string offtakeQtySign = key.split('_')[2] == 'positive' ? '+' : '-';
					/* [VL 1.4] BEGIN */
					if (key.split('_')[3] == creditOrDebit){
					/* [VL 1.4] END */
						string subBrandId = map_sku_subBrand.get(skuId);
						amount = math.abs(amount);
						if (amount.setScale(2)>0) {
							ASI_CRM_Credit_Debit_Note_Line_Item__c creditNoteLine = new ASI_CRM_Credit_Debit_Note_Line_Item__c();
							creditNoteLine.ASI_CRM_SKU__c = skuId;
							creditNoteLine.ASI_CRM_Sub_brand__c = subBrandId;
							creditNoteLine.ASI_CRM_Customer__c = outletId;
							creditNoteLine.ASI_CRM_Offtake_Qty_Sign__c = offtakeQtySign;
							creditNoteLine.ASI_CRM_Volume_9L__c = math.abs(totalVolumeMap.containsKey(key) ? totalVolumeMap.get(key) : 0);
							creditNoteLine.ASI_CRM_Volume_Bottle__c = math.abs(totalVolumeMap_bottle.containsKey(key) ? totalVolumeMap_bottle.get(key) : 0);
							creditNoteLine.ASI_CRM_Contracted_Rate_Bottle__c = compensationRateMap_bottle.containsKey(key) ? compensationRateMap_bottle.get(key) : 0;
							creditNoteLine.ASI_CRM_PRS_WS_Price_per_Bottle__c = prsWSpriceMap.containsKey(key) ? prsWSpriceMap.get(key) : 0;
							creditNoteLine.ASI_CRM_WS_OT_Price_per_Bottle__c = wsOTpriceMap.containsKey(key) ? wsOTpriceMap.get(key) : 0;
							creditNoteLine.ASI_CRM_Consumer_Price_Offer_per_Bottle__c = consumerPriceOfferMap.containsKey(key) ? consumerPriceOfferMap.get(key) : 0;
							creditNoteLine.ASI_CRM_Wholesaler_Rate_Bottle__c = wholesalerMarginRateMap_bottle.containsKey(key) ? wholesalerMarginRateMap_bottle.get(key) : 0;
							creditNoteLine.ASI_CRM_Amount__c = amount.setScale(2);
							creditNoteLine.ASI_CRM_Actual_Amount__c = amount.setScale(2);
							creditNoteLine.ASI_CRM_Type__c = CREDITNOTE_TYPE;
							creditNoteLine.ASI_CRM_Remark__c = REASON_PREFIX + map_subBrandId_code.get(subBrandId) + '_' + offtakeWrapper.outletName;
							creditNoteLine.RecordTypeId = MAP_LINE_RTID.get(/* [VL 1.4] BEGIN *//*offtakeWrapper.*//* [VL 1.4] END */creditOrDebit);
							creditNoteLineItemList.add(creditNoteLine);
						}
					/* [VL 1.4] BEGIN */
					}
					/* [VL 1.4] END */
					
				}
				/* [VL 1.0] END */
				
				if (creditNoteLineItemList.size()>0){
					string creditNote_key = offtakeWrapper.contract.Id+'_'+offtakeWrapper.outletId+'_'+offtakeWrapper.wholesalerId+'_'+/* [VL 1.4] BEGIN *//*offtakeWrapper.*//* [VL 1.4] END */creditOrDebit;
					map_creditNote.put(creditNote_key, creditNote);
					map_creditNoteLine.put(creditNote_key, creditNoteLineItemList);
				}
			/* [VL 1.4] BEGIN */
			}
			/* [VL 1.4] END */
			
  			
  		}

        set<string> set_creditNoteID = new set<string>();
        List<string> set_contractID = new List<string>();
        
        if (map_creditNote!=null){
            insert map_creditNote.values();

            List<ASI_CRM_Credit_Debit_Note_Line_Item__c> paymentRequestLineItemList = new List<ASI_CRM_Credit_Debit_Note_Line_Item__c>();
    
            for(string wrapper_key : map_creditNote.keySet()) {
                Id paymentRequestId = map_creditNote.get(wrapper_key).Id;
                set_creditNoteID.add(paymentRequestId);
                set_contractID.add(map_creditNote.get(wrapper_key).ASI_CRM_Contract__c);
                for(ASI_CRM_Credit_Debit_Note_Line_Item__c paymentRequestLineItem : map_creditNoteLine.get(wrapper_key)) {
                    paymentRequestLineItem.ASI_CRM_Credit_Debit_Note__c = paymentRequestId;
                    paymentRequestLineItemList.add(paymentRequestLineItem);
                }
            }
    
            insert paymentRequestLineItemList;
            
            ASI_CRM_SG_ROI_Helper roi = new ASI_CRM_SG_ROI_Helper(set_contractID);
        	roi.calculateROI();
        }
        
        sendEMailNotification(BC.getJobId(), set_creditNoteID);
  		
  	}

	private List<ASI_TH_CRM_Contract__c> getContractList(Set<Id> contractIdSet) {
		String queryStr = 'SELECT ';
		queryStr += genQueryField(CONTRACT_FIELD_MAP);
        queryStr += ', ASI_CRM_CN_Outlet_WS__r.name ';
		queryStr += ', (SELECT ID, Name, ASI_CRM_SKU__c, ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_CRM_SKU__r.ASI_CRM_SG_Wine_Category__c, ASI_CRM_Subbrand__c, ' +
		' ASI_CRM_SG_Consumer_Price_Offer__c, ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c, ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c, ' + 
		' ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c, ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c, ASI_CRM_SG_Wholesaler_Margin__c, ' +
		' ASI_CRM_SKU__r.ASI_CRM_Regular_Size__c FROM Contract_Target__r Order by ASI_CRM_Sequence_No__c asc)';
		queryStr += ' FROM ASI_TH_CRM_Contract__c';
		queryStr += ' WHERE Id in :contractIdSet';
		return (List<ASI_TH_CRM_Contract__c>) Database.query(queryStr);
	}

	private List<ASI_MFM_SKU_Code__c> getSKUList(Set<Id> skuIdSet) {
		String queryStr = 'SELECT ';
		queryStr += genQueryField(SKU_FIELD_MAP);
		queryStr += ' FROM ASI_MFM_SKU_Code__c';
		queryStr += ' WHERE Id in :skuIdSet';
		return (List<ASI_MFM_SKU_Code__c>) Database.query(queryStr);
	}

	private String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
		String queryField = '';
		for(String field : fieldMap.keySet()) {
		queryField += field + ',';
		}
		return queryField.subString(0, queryField.length() - 1);
	}

	//Wrapper Class
	public class OfftakeWrapper {

		public ASI_TH_CRM_Contract__c contract {get; set;}
		public Id outletId {get; set;}
		public Id wholesalerId {get; set;}
		public string creditOrDebit {get; set;}
		public string outletName {get; set;}
		/* [VL 2.0] BEGIN */
		public Boolean newMethod {get; set;}
		/* [VL 2.0] END */

		public Map<ASI_TH_CRM_Actual_Offtake__c, ASI_CRM_ContractTarget__c> actualOfftakeMap {get; set;}
		public Map<Id, ASI_CRM_ContractTarget__c> contractTargetSubBrandMap {get; set;}
		public Map<Id, ASI_CRM_ContractTarget__c> contractTargetSKUMap {get; set;}
		public Map<Id, ASI_CRM_ContractTarget__c> contractTargetWineCategoryMap {get; set;}
		public Map<Id, ASI_CRM_ContractTarget__c> contractTargetSKUMap_newSKU {get; set;}
		/* [VL 2.2] BEGIN */
		public Map<Id, ASI_CRM_ContractTarget__c> contractTargetRegularSizeSubBrandMap {get; set;}
		/* [VL 2.2] END */


		public offtakeWrapper(
			ASI_TH_CRM_Contract__c contract, 
			Id outletId, 
			string outletName, 
			Id wholesalerId, 
			Map<id, id> map_newSKU
			/* [VL 1.4] BEGIN */
			/*
			, string creditOrDebit
			*/
			/* [VL 1.4] END */
			/* [VL 2.0] BEGIN */
			, Boolean newMethod
			/* [VL 2.0] END */
		) {
			actualOfftakeMap = new Map<ASI_TH_CRM_Actual_Offtake__c, ASI_CRM_ContractTarget__c>();
			contractTargetSubBrandMap = new Map<Id, ASI_CRM_ContractTarget__c>();
			contractTargetSKUMap = new Map<Id, ASI_CRM_ContractTarget__c>();
			contractTargetWineCategoryMap = new Map<Id, ASI_CRM_ContractTarget__c>();
			contractTargetSKUMap_newSKU = new Map<Id, ASI_CRM_ContractTarget__c>();
			/* [VL 2.2] BEGIN */
			contractTargetRegularSizeSubBrandMap = new Map<Id, ASI_CRM_ContractTarget__c>();
			/* [VL 2.2] END */

			this.contract = contract;
			this.outletId = outletId;
			this.wholesalerId = wholesalerId;
			/* [VL 1.4] BEGIN */
			/*
			this.creditOrDebit = creditOrDebit;
			*/
			/* [VL 1.4] END */
			this.outletName = outletName.length() > 15 ? outletName.substring(0,15) : outletName;
			/* [VL 1.1] BEGIN */
			/* [VL 2.0] END */
			this.newMethod = newMethod;
			/* [VL 2.0] BEGIN */
			/*
			setContractTargetByWineCategory();
			setContractTargetBySubBrand();
			*/
			/* [VL 1.1] END */
			setContractTargetBySKU();
			setContractTargetBySKU_newSKU(map_newSKU);
			/* [VL 2.2] BEGIN */
			setContractTargetByRegularSizeSubBrand();
			/* [VL 2.2] END */
		}

		/* [VL 1.1] BEGIN */
		/*
         // Fill the contractTarget and map them by Wine Category
        private void setContractTargetByWineCategory() {
            for(ASI_CRM_ContractTarget__c contractTarget : contract.Contract_Target__r) {
                decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c != null ? contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c : 0;
                decimal priceOnTrade = contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c : 0;
                decimal compensation = consumerOffer > priceOnTrade ? 0 : priceOnTrade - consumerOffer;
                decimal wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
                if ((compensation+wholesalerMargin)>0) {
                    if(contractTarget.ASI_CRM_SKU__r.ASI_CRM_SG_Wine_Category__c != null) {
                        contractTargetWineCategoryMap.put(contractTarget.ASI_CRM_SKU__r.ASI_CRM_SG_Wine_Category__c, contractTarget);
                    }
                }
            }
        }
           
		private void setContractTargetBySubBrand() {
			for(ASI_CRM_ContractTarget__c contractTarget : contract.Contract_Target__r) {
                decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c != null ? contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c : 0;
                decimal priceOnTrade = contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c : 0;
                decimal compensation = consumerOffer > priceOnTrade ? 0 : priceOnTrade - consumerOffer;
                decimal wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
                if ((compensation+wholesalerMargin)>0) {
                    if(String.isNotBlank(contractTarget.ASI_CRM_Subbrand__c)) {
                        contractTargetSubBrandMap.put(contractTarget.ASI_CRM_Subbrand__c, contractTarget);
                    } 
                    /*
                    // able to group sub-brand even contract target has no sub-brand input
                    else {
                        contractTargetSubBrandMap.put(contractTarget.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, contractTarget);
                    }
					*
                }
                
			}
		}
		*/
		/* [VL 1.1] END */
        
         // Fill the contractTarget and map them by SKU
        private void setContractTargetBySKU() {
            for(ASI_CRM_ContractTarget__c contractTarget : contract.Contract_Target__r) {
                decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c;
                decimal priceOnTrade = contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c : 0;
				/* [VL 2.0] BEGIN */
				/*
				/* [VL 1.3] BEGIN *
				/*
				decimal compensation = consumerOffer > priceOnTrade ? 0 : priceOnTrade - consumerOffer;
				*
				decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : (contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0);
				decimal backCompensation = consumerOffer == null ? 0 : (consumerOffer > pricePRSWS_RTM ? consumerOffer - pricePRSWS_RTM : 0);
				decimal compensation = consumerOffer == null ? 0 : (pricePRSWS_RTM > consumerOffer ? pricePRSWS_RTM - consumerOffer : 0);
				/* [VL 1.3] END *
                decimal wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				*/
				decimal pricePRSWS = contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0;
				decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : pricePRSWS;
				decimal priceOnTrade_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c : priceOnTrade;
				decimal backCompensation;
				decimal compensation;
				decimal wholesalerMargin;
				if(newMethod){
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > priceOnTrade_RTM ? consumerOffer - priceOnTrade_RTM : 0);
					compensation = consumerOffer == null ? 0 : (priceOnTrade_RTM > consumerOffer ? priceOnTrade_RTM - consumerOffer : 0);
					wholesalerMargin = 0;
				}else{
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > pricePRSWS ? consumerOffer - pricePRSWS : 0);
					compensation = consumerOffer == null ? 0 : (pricePRSWS > consumerOffer ? pricePRSWS - consumerOffer : 0);
					wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				}
				/* [VL 2.0] END */
                if ((compensation+wholesalerMargin)>0 || backCompensation>0) {
                    if(contractTarget.ASI_CRM_SKU__c != null
						/* [VL 1.0] BEGIN */
						/*
						&& contractTarget.ASI_CRM_Subbrand__c == null
						*/
						/* [VL 1.0] END */
					) {
                        contractTargetSKUMap.put(contractTarget.ASI_CRM_SKU__c, contractTarget);
						
                    }
                }
            }
        }
           
         // Fill the contractTarget and map them by New SKU
        private void setContractTargetBySKU_newSKU(Map<id, id> map_newSKU) {
            for(ASI_CRM_ContractTarget__c contractTarget : contract.Contract_Target__r) {
                decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c;
                decimal priceOnTrade = contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c : 0;
				/* [VL 2.0] BEGIN */
				/*
				/* [VL 1.3] BEGIN *
				/*
				decimal compensation = consumerOffer > priceOnTrade ? 0 : priceOnTrade - consumerOffer;
				*
				decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : (contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0);
				decimal backCompensation = consumerOffer == null ? 0 : (consumerOffer > pricePRSWS_RTM ? consumerOffer - pricePRSWS_RTM : 0);
				decimal compensation = consumerOffer == null ? 0 : (pricePRSWS_RTM > consumerOffer ? pricePRSWS_RTM - consumerOffer : 0);
				/* [VL 1.3] END *
                decimal wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				*/
				decimal pricePRSWS = contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0;
				decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : pricePRSWS;
				decimal priceOnTrade_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c : priceOnTrade;
				decimal backCompensation;
				decimal compensation;
				decimal wholesalerMargin;
				if(newMethod){
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > priceOnTrade_RTM ? consumerOffer - priceOnTrade_RTM : 0);
					compensation = consumerOffer == null ? 0 : (priceOnTrade_RTM > consumerOffer ? priceOnTrade_RTM - consumerOffer : 0);
					wholesalerMargin = 0;
				}else{
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > pricePRSWS ? consumerOffer - pricePRSWS : 0);
					compensation = consumerOffer == null ? 0 : (pricePRSWS > consumerOffer ? pricePRSWS - consumerOffer : 0);
					wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				}
				/* [VL 2.0] END */
                if ((compensation+wholesalerMargin)>0 || backCompensation>0) {
                    if (contractTarget.ASI_CRM_SKU__c != null
						/* [VL 1.0] BEGIN */
						/*
						&& contractTarget.ASI_CRM_Subbrand__c == null
						*/
						/* [VL 1.0] END */
						&& map_newSKU.containsKey(contractTarget.ASI_CRM_SKU__c)) {
                        contractTargetSKUMap_newSKU.put(map_newSKU.get(contractTarget.ASI_CRM_SKU__c), contractTarget);
                    }
                }
            }
        }
           
		/* [VL 2.2] BEGIN */
		private void setContractTargetByRegularSizeSubBrand() {
            for(ASI_CRM_ContractTarget__c contractTarget : contract.Contract_Target__r) {
                decimal consumerOffer = contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c;
                decimal priceOnTrade = contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_WS_On_Trade__c : 0;
				decimal pricePRSWS = contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c != null ? contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c : 0;
				decimal pricePRSWS_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_PRS_WS__c : pricePRSWS;
				decimal priceOnTrade_RTM = contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c != null ? contractTarget.ASI_CRM_RTM_Price_Per_Bottle_WS_OT__c : priceOnTrade;
				decimal backCompensation;
				decimal compensation;
				decimal wholesalerMargin;
				if(newMethod){
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > priceOnTrade_RTM ? consumerOffer - priceOnTrade_RTM : 0);
					compensation = consumerOffer == null ? 0 : (priceOnTrade_RTM > consumerOffer ? priceOnTrade_RTM - consumerOffer : 0);
					wholesalerMargin = 0;
				}else{
					backCompensation = consumerOffer == null ? 0 : (consumerOffer > pricePRSWS ? consumerOffer - pricePRSWS : 0);
					compensation = consumerOffer == null ? 0 : (pricePRSWS > consumerOffer ? pricePRSWS - consumerOffer : 0);
					wholesalerMargin = contractTarget.ASI_CRM_SG_Wholesaler_Margin__c != null ? contractTarget.ASI_CRM_SG_Wholesaler_Margin__c : 0;
				}
                if ((compensation+wholesalerMargin)>0 || backCompensation>0) {
					if(contractTarget.ASI_CRM_Subbrand__c != null && contractTarget.ASI_CRM_SKU__r.ASI_CRM_Regular_Size__c) {
                        if(!contractTargetRegularSizeSubBrandMap.containsKey(contractTarget.ASI_CRM_Subbrand__c)) {
							contractTargetRegularSizeSubBrandMap.put(contractTarget.ASI_CRM_Subbrand__c, contractTarget);
						}
                    } 
					if(contractTarget.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c != null && contractTarget.ASI_CRM_SKU__r.ASI_CRM_Regular_Size__c){
                        if(!contractTargetRegularSizeSubBrandMap.containsKey(contractTarget.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c)) {
							contractTargetRegularSizeSubBrandMap.put(contractTarget.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, contractTarget);
						}
                    }
                }
            }
        }
		/* [VL 2.2] END */

	}

    public void sendEMailNotification(Id BC_ID, set<string> set_creditNoteID){
         AsyncApexJob a = 
           [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC_ID];
                          
       // Send an email to the Apex job's submitter 
       //   notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Contract Margin Credit/Debit Note Generation ' + a.Status);
        if (set_creditNoteID.size()>0){
            string ebody = '<p>The Contract Margin Credit/Debit Note generation for ' + this.monthStr + '/' + this.yearStr + 
                ' is completed with '+ a.NumberOfErrors + ' errors.</p>';
            ebody += '<table width="100%" border="1">';
            ebody += '<tr><th>Credit/Debit Note No.</th><th>Type</th><th>Outlet</th><th>Wholesaler</th><th>Contract</th><th>Total Taxable Amount</th>';
            for (ASI_CRM_Credit_Debit_Note__c p : [
                select id, name, ASI_CRM_Outlet__r.name, ASI_CRM_Wholesaler__r.name, ASI_CRM_Contract__r.name, ASI_CRM_Total_Amount__c, recordtypeid from ASI_CRM_Credit_Debit_Note__c
                where id in :set_creditNoteID
            ]){
                ebody += '<tr><td>'+p.name+'</td><td>'+MAP_HEADER_RTID_CREDITORDEBIT.get(p.recordtypeid)+'</td><td>'+p.ASI_CRM_Outlet__r.name+'</td><td>'+p.ASI_CRM_Wholesaler__r.name+'</td><td>'+p.ASI_CRM_Contract__r.name+'</td><td style="text-align:right">'+p.ASI_CRM_Total_Amount__c+'</td></tr>';
            }
            ebody += '</table>';
            mail.setHtmlBody(ebody);
        } else {
            mail.setPlainTextBody
           ('The Contract Margin Credit/Debit Note generation for ' + this.monthStr + '/' + this.yearStr + 
           ' completed with '+ a.NumberOfErrors + ' errors. No credit/debit note is generated.');
        }
       
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    /*********************************************************************************
     * Description: Get the mapping of sku
     *
     * Return: SKU Mapping contain the SKU Id and the newest SKU Id
    *********************************************************************************/
    private Map<Id, Id> getSKUMapping() {
        Map<Id, Id> skuMappingMap = new Map<Id, Id>();

        Id sgSKUMappingRecordType = Global_RecordTypeCache.getRTId('ASI_CRM_SKU_Mapping__cSG_SKU_Mapping');

        for(ASI_CRM_SKU_Mapping__c skuMapping : [SELECT ASI_CRM_SKU__c, ASI_CRM_New_SKU__c 
                                                 FROM ASI_CRM_SKU_Mapping__c
                                                 WHERE RecordTypeId = :sgSKUMappingRecordType]) {
            skuMappingMap.put(skuMapping.ASI_CRM_SKU__c, skuMapping.ASI_CRM_New_SKU__c);
        }

        for(Id skuId : skuMappingMap.keySet()) {
            Id tempSKUId = skuMappingMap.get(skuId);
            while(skuMappingMap.containsKey(tempSKUId)) {
                tempSKUId = skuMappingMap.get(tempSKUId);
            }
            skuMappingMap.put(skuId, tempSKUId);
        }
        
        for(Id skuId : skuMappingMap.values()) {
            skuMappingMap.put(skuId, skuId);
        }

        return skuMappingMap;
    }
    
    private Map<string, string> getSubbrandCodeMap() {
        Map<string, string> sbMapping = new Map<string, string>();

        Id rtID = Global_RecordTypeCache.getRTId('ASI_MFM_Sub_brand__cASI_CRM_SG_Sub_brand');

        for(ASI_MFM_Sub_brand__c sb : [SELECT id, ASI_MFM_Sub_brand_Code__c 
                                                 FROM ASI_MFM_Sub_brand__c
                                                 WHERE RecordTypeId = :rtID]) {
            sbMapping.put(sb.id, sb.ASI_MFM_Sub_brand_Code__c);
        }

        return sbMapping;
    }
	
}