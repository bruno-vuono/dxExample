/*********************************************************************************
 * Name: ASI_CRM_SG_GenPromotionIncentive_Batch
 * Description: Generate the calculated promotion incentive
 *
 * Version History
 * Date 			Developer 			Comments
 * --------------- -------------------- --------------------------------------------------------------------------------
 * 2018-04-10		Vincent Lam			Create
*/
global class ASI_CRM_SG_GenPromotionIncentive_Batch implements Database.Batchable<sobject>, Database.stateful, Schedulable {
    
	public static final Id PROMOTIONPLAN_OUTLET_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Outlet_Promotion_Plan_Final_Approved');
	public static final Id PROMOTIONPLAN_WHOLESALER_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan_Final_Approved');
	public static final Id PROMOTIONDETAILACHIEVEMENT_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Detail_Achievement__cASI_CRM_SG_Promotion_Detail_Achievement');
	public static final Id FOC_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_SG_FOC');
	public static final Id FOCLINE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_FOC_Request_Item__cASI_SG_CRM_Request_Items');
	public static final Id PAYMENT_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_TH_CRM_PaymentRequest__cASI_CRM_SG_Payment_Request');
	public static final Id PAYMENTLINE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_TH_CRM_PaymentRequestLineItem__cASI_CRM_SG_Payment_Request_Detail');
	public static final Id VOUCHER_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Voucher__cASI_CRM_SG_Voucher');
	public static final Id VOUCHERLINE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Voucher_Detail__cASI_CRM_SG_Voucher_Detail');
	public static final Id OUTLET_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_AccountsAdditionalField__cASI_CRM_SG_Outlet');
	public static final Id WHOLESALER_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_AccountsAdditionalField__cASI_CRM_SG_Wholesaler');
		
	public static final String OUTLET = 'Outlet';
	public static final String WHOLESALER = 'Wholesaler';
	public static final String FOC_PREFIX = 'FOC_';
	public static final String PAYMENT_PREFIX = 'PAYMENT_';
	public static final String VOUCHER_PREFIX = 'VOUCHER_';
	public static final String FOC_TYPE = 'Adhoc Promotion/Sponsorship';
	public static final String FOC_CODE = '0025';
	public static final String PAYMENT_TYPE = 'Ad-hoc Promotions';
	public static final String VOUCHER_TYPE = 'Taka Voucher';
	public static final String FINAL_APPROVED = 'Final Approved';
	public static final String SYSTEMREMARK = 'SG Promotion';
	
	public static final Set<String> SET_PROMOTIONPLAN_RECORDTYPEID = new Set<String>{
        PROMOTIONPLAN_OUTLET_RECORDTYPE_ID,
		PROMOTIONPLAN_WHOLESALER_RECORDTYPE_ID
    };

	//Variable for init query
	public string monthStr, yearStr, customerId, promotionOwnerId, startQuery;
	public Map<string, list<AggregateResult>> map_customerSKUsubBrand_results;
	public Map<String, String> skuMappingMap;
	public Map<String, Set<string>> skuMappingMap_reverse;
	public Set<string> set_skuId, set_subBrandId, set_skuIdToRetrieve, set_customerId, set_promotionId;
	public Map<string, list<ASI_HK_CRM_Promotion_Detail__c>> map_customerSKUsubBrand_listPromotionDetails;
	public Date earliestStartDate, latestEndDate;
	public Date endDateOfSelectedMonth;
	public map<string, incentiveWrapper> map_customerId_wrapper;
	public map<string, ASI_FOC_Free_Goods_Request__c> map_focHeader = new map<string, ASI_FOC_Free_Goods_Request__c>();
	public map<string, string> map_wholesalerId_wholesalerOutletId = new map<string, string>();

	// calculate all promotions that a month has,
	global ASI_CRM_SG_GenPromotionIncentive_Batch(String fromYear, String fromMonth) {
		this(fromYear, fromMonth, null, null, UserInfo.getUserId(), null);
	}
    
	// calculate all promotions that a month has, trigger from automated request
	global ASI_CRM_SG_GenPromotionIncentive_Batch(String fromYear, String fromMonth, List<ASI_FOC_Free_Goods_Request__c> list_foc) {
		this(fromYear, fromMonth, null, null, UserInfo.getUserId(), list_foc);
	}
    
	// calculate all specific promotions, differentiate by outlet or wholesaler promotion
	global ASI_CRM_SG_GenPromotionIncentive_Batch(Set<string> set_promotionId) {
		this(null, null, set_promotionId, null, null, null);
	}
    
	// calculate all specific outlets, trigger from offtake adjustment page -> adjust by outlet
	global ASI_CRM_SG_GenPromotionIncentive_Batch(String fromYear, String fromMonth, String customerId) {
        this(fromYear, fromMonth, null, customerId, null, null);
	}
    
	// calculate for specific user
	global ASI_CRM_SG_GenPromotionIncentive_Batch(boolean a, String fromYear, String fromMonth, String userId) {
		this(fromYear, fromMonth, null, null, userId, null);
	}
    
	global ASI_CRM_SG_GenPromotionIncentive_Batch(String fromYear, String fromMonth, Set<string> set_promotionId, String customerId, String promotionOwnerId, List<ASI_FOC_Free_Goods_Request__c> list_foc) {
		this.yearStr = fromYear;
		this.monthStr = fromMonth;
		this.set_promotionId = set_promotionId != null ? set_promotionId : retrievePromotionId(fromYear, fromMonth);
		this.customerId = customerId;
		this.promotionOwnerId = promotionOwnerId;
		if(list_foc != null && list_foc.size()>0){
			for(ASI_FOC_Free_Goods_Request__c foc : list_foc){
				string cid = foc.ASI_CRM_Outlet__c;
				string key_foc = cid;
				this.map_focHeader.put(key_foc, foc);
			}
		}
		
		if(fromYear == null || fromMonth == null){
			this.endDateOfSelectedMonth = null;
		} else {
			Integer yearInt = Integer.valueOf(fromYear);
			Integer monthInt = Integer.valueOf(fromMonth);
			Integer endDayInt = Date.daysInMonth(yearInt, monthInt);
			this.endDateOfSelectedMonth = Date.newInstance(yearInt, monthInt, endDayInt);
		}
		
		
		this.skuMappingMap = getSKUMapping();
		
		this.startQuery = buildStartQuery(this.set_promotionId, this.customerId, this.promotionOwnerId);
		system.debug(this.promotionOwnerId);
		
		this.promotionOwnerId = this.promotionOwnerId != null ? this.promotionOwnerId : UserInfo.getUserId();
		this.map_customerId_wrapper = new map<string, incentiveWrapper>();
		
		this.map_wholesalerId_wholesalerOutletId = getWholesalerOutletIdMap();
	}
	
	private Set<string> retrievePromotionId(string yearStr, string monthStr){
		Integer yearInt = Integer.valueOf(yearStr);
		Integer monthInt = Integer.valueOf(monthStr);
		Integer endDayInt = Date.daysInMonth(yearInt, monthInt);
		Date fromDate = Date.newInstance(yearInt, monthInt, 2);
		Date toDate = Date.newInstance(yearInt, monthInt, endDayInt - 1);
		
		/*
		Set<string> set_promotionId = new Set<string>();
		for(ASI_HK_CRM_Promotion__c p : [
			select id
			from ASI_HK_CRM_Promotion__c
			where 
				recordtypeid = :PROMOTION_RECORDTYPE_ID AND
				ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c <= :fromDate AND
				ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c >= :toDate 
				
		]){
			set_promotionId.add(p.id);
		}
		*/
		Set<string> set_promotionId = new Set<string>();
		for(ASI_CRM_Promotion_Plan__c p : [
			select id
			from ASI_CRM_Promotion_Plan__c
			where 
				recordtypeid in :SET_PROMOTIONPLAN_RECORDTYPEID AND
				ASI_CRM_Start_Date__c <= :fromDate AND
				ASI_CRM_End_Date__c >= :toDate 
				
		]){
			set_promotionId.add(p.id);
		}
		return set_promotionId;
	}
		
	private String buildStartQuery(set<string> set_promotionId, string customerId, string promotionOwnerId){
		string query = '';
		query += 'select ';
		query += '	id, ASI_CRM_SG_Customer__c, ASI_HK_CRM_Promotion__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.recordtypeid, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Promotion_Period_Month__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_9L__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Packaging_Size_Promotional__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.ASI_MFM_Sub_brand__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Trade_Deal_Bottle_Qty__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Packaging_Size_Additional__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_Bottle_Qty__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Ad_hoc_Cash__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher_Value_Cash__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c, ';
		query += '	ASI_CRM_ActualConsumption_9L__c, ASI_CRM_IssuedConsumption_9L__c, ASI_CRM_Monthly_Avg_Target_Volume_9L__c, ';
		query += '	ASI_CRM_Carry_Over_Additional_Bottle__c, ASI_CRM_Carry_Over_Promotional_Bottle__c, ';
		query += '	ASI_CRM_Target_Volume_9L__c, ';
		query += '	( ';
		query += '		select id, ASI_CRM_Achievement_Year__c, ASI_CRM_Achievement_Month__c, ASI_CRM_Promotion_Detail__c, ASI_CRM_ActualConsumption_9L__c ';
		query += '		from Promotion_Detail_Achievements__r ';
		query += '		order by ASI_CRM_Achievement_Year__c, ASI_CRM_Achievement_Month__c ';
		query += '	) ';
		query += 'from  ';
		query += '	ASI_HK_CRM_Promotion_Detail__c ';
		query += 'where ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c in :set_promotionId ';
		query += ' AND ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Status__c = :FINAL_APPROVED ';
		if(customerId != null){
			query += ' AND ASI_CRM_SG_Customer__c = :customerId ';
		}
		if(promotionOwnerId != null){
			query += ' AND ASI_HK_CRM_Promotion__r.ownerid = :promotionOwnerId ';
		}
		return query;
	}
		
	global database.querylocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(this.startQuery);
    }
	
	global void execute(Database.BatchableContext contextInstance, List<sObject> list_o){
		List<ASI_HK_CRM_Promotion_Detail__c> list_pd = (List<ASI_HK_CRM_Promotion_Detail__c>)list_o;
		list<ASI_CRM_Promotion_Detail_Achievement__c> list_pdaToUpsert = new list<ASI_CRM_Promotion_Detail_Achievement__c>();
		list<ASI_FOC_Free_Goods_Request__c> list_focToInsert = new list<ASI_FOC_Free_Goods_Request__c>();
		list<ASI_TH_CRM_PaymentRequest__c> list_paymentToInsert = new list<ASI_TH_CRM_PaymentRequest__c>();
		list<ASI_CRM_Voucher__c> list_voucherToInsert = new list<ASI_CRM_Voucher__c>();
		
		// prepare to get price/cost of SKUs
		set<string> set_skuIdToGetPriceCost = new set<string>();
		map<string, date> map_promotionId_startDate = new map<string, date>();
		date latestStartDate = null;
		for(ASI_HK_CRM_Promotion_Detail__c pd : list_pd){
			string skuId_p = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c;
			string skuId_a = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__c;
			set_skuIdToGetPriceCost.add(skuId_p);
			set_skuIdToGetPriceCost.add(skuId_a);
			string pid = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c;
			date promotionStartDate = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c;
			map_promotionId_startDate.put(pid, promotionStartDate);
			if(latestStartDate == null){
				latestStartDate = promotionStartDate;
			} else
			if(promotionStartDate > latestStartDate){
				latestStartDate = latestStartDate;
			}
		}
		Map<string,Map<string,Map<string, ASI_CRM_MY_SKUPriceCost__c>>> map_promotionId_skuId_pcType_pc = getAllPriceCost(set_skuIdToGetPriceCost, map_promotionId_startDate, latestStartDate);
		
		for(ASI_HK_CRM_Promotion_Detail__c pd : list_pd){
			string pid = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c;
			string promotionId = pd.ASI_HK_CRM_Promotion__c;
			string cid = pd.ASI_CRM_SG_Customer__c;
			string skuId_p = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c;
			string skuId_a = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__c;
			decimal packSize_p = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Packaging_Size_Promotional__c;
			decimal packSize_a = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Packaging_Size_Additional__c;
			string subBrandId = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c != null ? 
								pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c : 
								pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.ASI_MFM_Sub_brand__c;
			string voucherId = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__c;
			decimal incentiveVolumePerUnit = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c;
			//string key_foc = FOC_PREFIX + cid;
			//string key_payment = PAYMENT_PREFIX + cid;
			//string key_voucher = VOUCHER_PREFIX + cid;
			Decimal average9LTargetPerPeriod = pd.ASI_CRM_Monthly_Avg_Target_Volume_9L__c;
			Decimal ytd9L_target = 0;
			Decimal ytd9L_achieved = 0;
			Decimal ytd9L_achievedToCalculate = 0;
			Decimal ytd9L_netAchieved = 0;
			Decimal ytd9L_netNetAchieved = 0;
			Decimal ytd9L_issued = pd.ASI_CRM_IssuedConsumption_9L__c;
			Decimal achievedPeriod = 0;
			Decimal incentiveFactor = 0;
			Decimal buy9L = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_9L__c;
			Decimal totalTarget9L = pd.ASI_CRM_Target_Volume_9L__c;
			Date promotionStartDate = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c;
			Date promotionEndDate = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c;
			Integer numberOfMonthInPromotion = Integer.valueOf(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Promotion_Period_Month__c);
			Date dateToPopulateIssued9L;
			
			Integer numberOfMonthYTD = this.endDateOfSelectedMonth != null ? 
										Integer.valueOf((promotionStartDate.daysBetween(this.endDateOfSelectedMonth) / 30.0).setScale(0)) :
										numberOfMonthInPromotion;
			Date startDate = promotionStartDate;
			for(integer i=0; i<numberOfMonthYTD; i++){
				ytd9L_target += pd.ASI_CRM_Monthly_Avg_Target_Volume_9L__c;
				Date achievementDate = startDate.addMonths(i);
				Integer achievementYear = achievementDate.year();
				Integer achievementMonth = achievementDate.month();
				for(ASI_CRM_Promotion_Detail_Achievement__c a : pd.Promotion_Detail_Achievements__r){
					if(a.ASI_CRM_Achievement_Year__c == achievementYear && a.ASI_CRM_Achievement_Month__c == achievementMonth){
						ytd9L_achieved += a.ASI_CRM_ActualConsumption_9L__c;
					}
				}
			}
			achievedPeriod = (ytd9L_achieved / average9LTargetPerPeriod).setScale(0, System.RoundingMode.FLOOR);
			
			// if promotion is ended OR total achievement is larger than total target, issue all achieved
			if(numberOfMonthYTD == numberOfMonthInPromotion
				&& achievedPeriod >= numberOfMonthInPromotion
			){
				dateToPopulateIssued9L = promotionEndDate;
			} 
			// if promotion is not ended OR total achievement is less than total target, only issue by month achieved
			else {
				dateToPopulateIssued9L = Date.newInstance(Integer.valueOf(this.yearStr), Integer.valueOf(this.monthStr), 15);
			}
            ytd9L_achievedToCalculate = ytd9L_achieved;
			
			String wrapper_key = cid;
			incentiveWrapper wrapper = this.map_customerId_wrapper.containsKey(wrapper_key) ? this.map_customerId_wrapper.get(wrapper_key) : new incentiveWrapper(cid);
			
			ytd9L_netAchieved = ytd9L_achievedToCalculate - ytd9L_issued;
			// 2 scenarios to issue incentive
			// 1. if total achievement more than the total target
			// 2. if total achievement less than the total target, but monthly achievement more than the monthly target
			if(ytd9L_achieved >= totalTarget9L || ytd9L_netAchieved >= average9LTargetPerPeriod){
				incentiveFactor = (ytd9L_netAchieved / buy9L).setScale(0, System.RoundingMode.FLOOR);
				ytd9L_netNetAchieved = buy9L * incentiveFactor;
				
				system.debug(ytd9L_achieved);
				system.debug(average9LTargetPerPeriod);
				system.debug(achievedPeriod);
				system.debug(average9LTargetPerPeriod);
				system.debug(ytd9L_netAchieved);
				system.debug(buy9L);
				system.debug('incentiveFactor');
				system.debug(incentiveFactor);
				
				// handle FOC
				Decimal carryOver_promotionalSKU = pd.ASI_CRM_Carry_Over_Promotional_Bottle__c;
				Decimal carryOver_additionalSKU = pd.ASI_CRM_Carry_Over_Additional_Bottle__c;
				Decimal amount_focPromotional = incentiveFactor * 
									(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Trade_Deal_Bottle_Qty__c != null ? pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Trade_Deal_Bottle_Qty__c : 0) +
									carryOver_promotionalSKU;
				Decimal amount_focAdditional = incentiveFactor * 
									(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_Bottle_Qty__c != null ? pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_Bottle_Qty__c : 0) +
									carryOver_additionalSKU;
				
				Decimal amount_focPromotional_final = Integer.valueOf(amount_focPromotional.setScale(0, System.RoundingMode.FLOOR));
				Decimal carryOver_promotionalSKU_final = amount_focPromotional - amount_focPromotional_final;
				Decimal amount_focAdditional_final = Integer.valueOf(amount_focAdditional.setScale(0, System.RoundingMode.FLOOR));
				Decimal carryOver_additionalSKU_final = amount_focAdditional - amount_focAdditional_final;
				
				if(amount_focPromotional_final > 0 || amount_focAdditional_final > 0){
					if(wrapper.foc == null){
						if(this.map_focHeader.containsKey(cid)){
							wrapper.foc = this.map_focHeader.get(cid);
						}else{
							wrapper.foc = buildFOCheader(cid, pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.recordtypeid);
							list_focToInsert.add(wrapper.foc);
						}
					}
					if(amount_focPromotional_final > 0){
						string key = pid + '_' + skuId_p;
						wrapper.addFocLine(pd, key, skuId_p, amount_focPromotional_final, packSize_p, ytd9L_netNetAchieved, true, carryOver_promotionalSKU_final, map_promotionId_skuId_pcType_pc.get(pid));
					}
					if(amount_focAdditional_final > 0){
						string key = pid + '_' + skuId_a;
						wrapper.addFocLine(pd, key, skuId_a, amount_focAdditional_final, packSize_a, ytd9L_netNetAchieved, false, carryOver_additionalSKU_final, map_promotionId_skuId_pcType_pc.get(pid));
					}
				}
				
				// handle payment
				Decimal amount_payment = incentiveFactor * 
									(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Ad_hoc_Cash__c != null ? pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Ad_hoc_Cash__c : 0);
				
				if(amount_payment > 0){
					if(wrapper.payment == null){
						wrapper.payment = buildPaymentheader(cid);
						list_paymentToInsert.add(wrapper.payment);
					}
					string key = pid + '_' + subBrandId;
					wrapper.addPaymentLine(pd, key, subBrandId, amount_payment, ytd9L_netNetAchieved);
				}
				
				// handle voucher
				Decimal amount_voucher = incentiveFactor;
				Decimal voucherValue = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher_Value_Cash__c != null ? pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher_Value_Cash__c : 0;
				
				if(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__c != null && amount_voucher > 0){
					if(wrapper.voucher == null){
						wrapper.voucher = buildVoucherheader(cid);
						list_voucherToInsert.add(wrapper.voucher);
					}
					string key = pid + '_' + voucherId;
					wrapper.addVoucherLine(pd, key, voucherId, amount_voucher, voucherValue, ytd9L_netNetAchieved);
				}
				
				// populate issued 9L into achievement record
				ASI_CRM_Promotion_Detail_Achievement__c pdaToUpsert = getAchievementToUpsert(pd, dateToPopulateIssued9L);
				pdaToUpsert.ASI_CRM_IssuedConsumption_9L__c = ytd9L_netNetAchieved;
				pdaToUpsert.ASI_CRM_Carry_Over_Promotional_Bottle__c = carryOver_promotionalSKU_final - carryOver_promotionalSKU;
				pdaToUpsert.ASI_CRM_Carry_Over_Additional_Bottle__c = carryOver_additionalSKU_final - carryOver_additionalSKU;
				list_pdaToUpsert.add(pdaToUpsert);
				
				this.map_customerId_wrapper.put(wrapper_key, wrapper);
			}
		}
		system.debug(this.map_customerId_wrapper.values());
		if(list_pdaToUpsert.size()>0) upsert list_pdaToUpsert; 
		if(list_focToInsert.size()>0) insert list_focToInsert;
		if(list_paymentToInsert.size()>0) insert list_paymentToInsert;
		if(list_voucherToInsert.size()>0) insert list_voucherToInsert;
	}
	
	global void finish(Database.BatchableContext contextInstance){
		list<ASI_FOC_Request_Item__c> list_focLineToInsert = new list<ASI_FOC_Request_Item__c>();
		list<ASI_TH_CRM_PaymentRequestLineItem__c> list_paymentLineToInsert = new list<ASI_TH_CRM_PaymentRequestLineItem__c>();
		list<ASI_CRM_Voucher_Detail__c> list_voucherLineToInsert = new list<ASI_CRM_Voucher_Detail__c>();
		Set<string> set_focId = new Set<string>();
		Set<string> set_paymentId = new Set<string>();
		Set<string> set_voucherId = new Set<string>();
		
		system.debug(this.map_customerId_wrapper.values());
		if(this.map_focHeader.values().size()>0){
			for(ASI_FOC_Free_Goods_Request__c foc : this.map_focHeader.values()){
				set_focId.add(foc.Id);
			}
		}
		
		for(incentiveWrapper wrapper : this.map_customerId_wrapper.values()){
			if(wrapper.foc != null){
				list_focLineToInsert.addall(wrapper.getFocLineToInsert());
				set_focId.add(wrapper.foc.Id);
			}
			if(wrapper.payment != null){
				list_paymentLineToInsert.addall(wrapper.getPaymentLineToInsert());
				set_paymentId.add(wrapper.payment.Id);
			}
			if(wrapper.voucher != null){
				list_voucherLineToInsert.addall(wrapper.getVoucherLineToInsert());
				set_voucherId.add(wrapper.voucher.Id);
			}
		}
		
		if(list_focLineToInsert.size()>0) insert list_focLineToInsert;
		if(list_paymentLineToInsert.size()>0) insert list_paymentLineToInsert;
		if(list_voucherLineToInsert.size()>0) insert list_voucherLineToInsert;
		
		sendEMailNotification(contextInstance.getJobId(), set_focId, set_paymentId, set_voucherId);
	}
	
	public void execute(SchedulableContext contextInstance) {}
	
    public void sendEMailNotification(Id BC_ID, set<string> set_focId, set<string> set_paymentId, set<string> set_voucherId){
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
        mail.setSubject('Free Goods Request and Promotion Incentive Generation ' + a.Status);
        if (set_focId.size()>0 || set_paymentId.size()>0 || set_voucherId.size()>0){
            map<string, incentiveWrapper> map_customerId_wrapperForEmail = new map<string, incentiveWrapper>();
			
			string ebody = '<p>The Free Goods Request and Promotion Incentive generation for ' + this.monthStr + '/' + this.yearStr + 
                ' is completed with '+ a.NumberOfErrors + ' errors.</p>';
            ebody += '<table width="100%" border="1">';
            ebody += '<tr><th>Record No.</th><th>Type</th><th>Customer</th><th>Total Taxable Amount</th><th>FOC Qty (9L)</th>';
			for (ASI_FOC_Free_Goods_Request__c p :[
                select id, name, ASI_CRM_Outlet__c, ASI_CRM_Outlet__r.name, ASI_CRM_SG_Total_Amount__c, ASI_CRM_Total_Actual_Quantity_9L__c from ASI_FOC_Free_Goods_Request__c
                where id in :set_focID
				order by ASI_CRM_Outlet__r.name
            ]){
				string key = p.ASI_CRM_Outlet__c;
				incentiveWrapper w = map_customerId_wrapperForEmail.containsKey(key) ? map_customerId_wrapperForEmail.get(key) : new incentiveWrapper(key);
				w.foc = p;
				map_customerId_wrapperForEmail.put(key, w);
			}
			for (ASI_TH_CRM_PaymentRequest__c p :[
                select id, name, ASI_CRM_CN_OutletWS__c, ASI_CRM_CN_OutletWS__r.name, ASI_TH_CRM_Total_Amount__c from ASI_TH_CRM_PaymentRequest__c
                where id in :set_paymentID
				order by ASI_CRM_CN_OutletWS__r.name
            ]){
				string key = p.ASI_CRM_CN_OutletWS__c;
				incentiveWrapper w = map_customerId_wrapperForEmail.containsKey(key) ? map_customerId_wrapperForEmail.get(key) : new incentiveWrapper(key);
				w.payment = p;
				map_customerId_wrapperForEmail.put(key, w);
			}
            for (ASI_CRM_Voucher__c p : [
                select id, name, ASI_CRM_Customer__r.name, ASI_CRM_Total_Voucher_Value__c from ASI_CRM_Voucher__c
                where id in :set_voucherID
				order by ASI_CRM_Customer__r.name
            ]){
				string key = p.ASI_CRM_Customer__c;
				incentiveWrapper w = map_customerId_wrapperForEmail.containsKey(key) ? map_customerId_wrapperForEmail.get(key) : new incentiveWrapper(key);
				w.voucher = p;
                map_customerId_wrapperForEmail.put(key, w);
            }
			for(incentiveWrapper w : map_customerId_wrapperForEmail.values()){
				if(w.foc != null){
					ASI_FOC_Free_Goods_Request__c p = w.foc;
					ebody += '<tr><td>'+p.name+'</td><td>FOC</td><td>'+p.ASI_CRM_Outlet__r.name+'</td><td style="text-align:right">'+doFormatting(p.ASI_CRM_SG_Total_Amount__c, 2, ',', '.')+'</td><td style="text-align:right">'+doFormatting(p.ASI_CRM_Total_Actual_Quantity_9L__c, 2, ',', '.')+'</td></tr>';
				}
				if(w.payment != null){
					ASI_TH_CRM_PaymentRequest__c p = w.payment;
					ebody += '<tr><td>'+p.name+'</td><td>Payment</td><td>'+p.ASI_CRM_CN_OutletWS__r.name+'</td><td style="text-align:right">'+doFormatting(p.ASI_TH_CRM_Total_Amount__c, 2, ',', '.')+'</td><td></td></tr>';
				}
				if(w.voucher != null){
					ASI_CRM_Voucher__c p = w.voucher;
					ebody += '<tr><td>'+p.name+'</td><td>Voucher</td><td>'+p.ASI_CRM_Customer__r.name+'</td><td style="text-align:right">'+doFormatting(p.ASI_CRM_Total_Voucher_Value__c, 2, ',', '.')+'</td><td></td></tr>';
				}
			}
            ebody += '</table>';
            mail.setHtmlBody(ebody);
        } else {
            mail.setPlainTextBody
           ('The Free Goods Request and Promotion Incentive generation for ' + this.monthStr + '/' + this.yearStr + 
           ' completed with '+ a.NumberOfErrors + ' errors. No FOC / payment / voucher is generated.');
        }
       
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
	private String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
		String s, tmp;
		Integer i = 4 + dec;
	   
		// If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
		if(dec==0){
		  i--;
		}
	   
		s = val.setScale(dec).toPlainString().replace(tSep, dSep);
		while(s.length() > i) {
		  tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
		  s = tmp;
		  i += 4;
		}
	   
		// If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
		if (s.substring(0,1) == '-') {
		  if (s.substring(1,2) == tSep) {
			s = '-' + s.substring(2);
		  }
		}
	   
		return s;
	}
	
	private Map<String, String> getSKUMapping() {
        Map<String, String> skuMappingMap = new Map<String, String>();

        Id sgSKUMappingRecordType = Global_RecordTypeCache.getRTId('ASI_CRM_SKU_Mapping__cSG_SKU_Mapping');

        for(ASI_CRM_SKU_Mapping__c skuMapping : [SELECT ASI_CRM_SKU__c, ASI_CRM_New_SKU__c 
                                                 FROM ASI_CRM_SKU_Mapping__c
                                                 WHERE RecordTypeId = :sgSKUMappingRecordType]
		) {
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
	
	private ASI_CRM_Promotion_Detail_Achievement__c getAchievementToUpsert(ASI_HK_CRM_Promotion_Detail__c pd, Date dateToPopulateIssued9L){
		ASI_CRM_Promotion_Detail_Achievement__c pdaToUpsert;
		Boolean achievementExist = false;
		for(ASI_CRM_Promotion_Detail_Achievement__c a : pd.Promotion_Detail_Achievements__r){
			if(a.ASI_CRM_Achievement_Year__c == dateToPopulateIssued9L.year() && a.ASI_CRM_Achievement_Month__c == dateToPopulateIssued9L.month()){
				pdaToUpsert = a;
				achievementExist = true;
			}
		}
		if(!achievementExist){
			pdaToUpsert = new ASI_CRM_Promotion_Detail_Achievement__c(
				RecordtypeId = PROMOTIONDETAILACHIEVEMENT_RECORDTYPE_ID,
				ASI_CRM_Promotion_Detail__c = pd.Id,
				ASI_CRM_Achievement_Date__c = dateToPopulateIssued9L
			);
		}
		return pdaToUpsert;
	}
	
	private ASI_FOC_Free_Goods_Request__c buildFOCheader(string cid, string promotionPlanRTID){
		ASI_FOC_Free_Goods_Request__c header = new ASI_FOC_Free_Goods_Request__c
			(
				recordtypeid = FOC_RECORDTYPE_ID,
				ASI_CRM_SG_System_Generated__c = true,
				ASI_CRM_Outlet__c = promotionPlanRTID == PROMOTIONPLAN_WHOLESALER_RECORDTYPE_ID ? this.map_wholesalerId_wholesalerOutletId.get(cid) : cid,
				ASI_CRM_SG_Year__c = this.yearStr,
				ASI_CRM_SG_Month__c = this.monthStr,
				ASI_FOC_Request_Status__c = 'Draft',
				ownerid = this.promotionOwnerId,
				ASI_CRM_System_Remark__c = SYSTEMREMARK
			);
		return header;
	}
	
	private ASI_TH_CRM_PaymentRequest__c buildPaymentheader(string cid){
		ASI_TH_CRM_PaymentRequest__c header = new ASI_TH_CRM_PaymentRequest__c
			(
				RecordTypeId = PAYMENT_RECORDTYPE_ID,
				OwnerId = this.promotionOwnerId,
				ASI_CRM_CN_OutletWS__c = cid,
				ASI_TH_CRM_Status__c = 'Draft',
				ASI_CRM_SG_Invoice_Date__c = date.today() - 1,
				ASI_CRM_System_Generated__c = true,
				ASI_CRM_Generation_From_Date__c = Date.newInstance(Integer.valueOf(this.yearStr), Integer.valueOf(this.monthStr), 1),
				ASI_CRM_Generation_To_Date__c = this.endDateOfSelectedMonth,
				ASI_CRM_System_Remark__c = SYSTEMREMARK
			);
		return header;
	}
	
	private ASI_CRM_Voucher__c buildVoucherheader(string cid){
		ASI_CRM_Voucher__c header = new ASI_CRM_Voucher__c
			(
				RecordTypeId = VOUCHER_RECORDTYPE_ID,
				OwnerId = this.promotionOwnerId,
				ASI_CRM_Customer__c = cid,
				ASI_CRM_System_Generated__c = true,
				ASI_CRM_GL_Date__c = date.today() - 1,
				ASI_CRM_Generation_Reference_Date__c = Date.newInstance(Integer.valueOf(this.yearStr), Integer.valueOf(this.monthStr), 15),
				ASI_CRM_Year__c = this.yearStr,
				ASI_CRM_Month__c = this.monthStr,
				ASI_CRM_System_Generated_Msg__c = SYSTEMREMARK
			);
		return header;
	}
	
	public class incentiveWrapper{
		public string customerId {get;set;}
		public ASI_FOC_Free_Goods_Request__c foc {get;set;}
		public map<string, ASI_FOC_Request_Item__c> map_promotionProductId_focLine {get;set;}
		public ASI_TH_CRM_PaymentRequest__c payment {get;set;}
		public map<string, ASI_TH_CRM_PaymentRequestLineItem__c> map_promotionProductId_paymentLine {get;set;}
		public ASI_CRM_Voucher__c voucher {get;set;}
		public map<string, ASI_CRM_Voucher_Detail__c> map_promotionProductId_voucherLine {get;set;}
		
		public incentiveWrapper(string customerId){
			this.customerId = customerId;
			//this.foc = new ASI_FOC_Free_Goods_Request__c();
			this.map_promotionProductId_focLine = new map<string, ASI_FOC_Request_Item__c>();
			//this.payment = new ASI_TH_CRM_PaymentRequest__c();
			this.map_promotionProductId_paymentLine = new map<string, ASI_TH_CRM_PaymentRequestLineItem__c>();
			//this.voucher = new ASI_CRM_Voucher__c();
			this.map_promotionProductId_voucherLine = new map<string, ASI_CRM_Voucher_Detail__c>();
		}
		
		public void addFocLine(ASI_HK_CRM_Promotion_Detail__c pd, string key, string skuId, decimal qty, decimal packSize, decimal volume9L, boolean isPromotionalSKU, decimal carryOverBottle, Map<string,Map<string, ASI_CRM_MY_SKUPriceCost__c>> map_sku_type_skuPrice){
			key = pd.id + '_' + String.valueOf(isPromotionalSKU);
			decimal incentiveFactor = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c;
			Decimal price_PRS_WS = 0;
			Decimal price_WS_OT = 0;
			Decimal cost_IGC = 0;
			Decimal cost_Duty = 0;
			Decimal cost_FOB = 0;
			Decimal cost_Handling = 0;
			if(map_sku_type_skuPrice != null){
				if (map_sku_type_skuPrice.containsKey(skuId)){
					Map<string, ASI_CRM_MY_SKUPriceCost__c> map_type_skuPrice = map_sku_type_skuPrice.get(skuID);
					ASI_CRM_MY_SKUPriceCost__c skuHistoricCostWS = map_type_skuPrice.containsKey('ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle') ? map_type_skuPrice.get('ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle') : new ASI_CRM_MY_SKUPriceCost__c();
					ASI_CRM_MY_SKUPriceCost__c skuHistoricCostWSOnTrade = map_type_skuPrice.containsKey('ASI_CRM_SG_Open_Outlet_Price_Per_Bottle') ? map_type_skuPrice.get('ASI_CRM_SG_Open_Outlet_Price_Per_Bottle') : new ASI_CRM_MY_SKUPriceCost__c();
					ASI_CRM_MY_SKUPriceCost__c skuHistoricCostIGC = map_type_skuPrice.containsKey('ASI_CRM_SG_IGC') ? map_type_skuPrice.get('ASI_CRM_SG_IGC') : new ASI_CRM_MY_SKUPriceCost__c();
					ASI_CRM_MY_SKUPriceCost__c skuHistoricCostDuty = map_type_skuPrice.containsKey('ASI_CRM_SG_CRM_Duty_Per_Bottle') ? map_type_skuPrice.get('ASI_CRM_SG_CRM_Duty_Per_Bottle') : new ASI_CRM_MY_SKUPriceCost__c();
					ASI_CRM_MY_SKUPriceCost__c skuHistoricCostFob = map_type_skuPrice.containsKey('ASI_CRM_SG_CRM_FOB_Per_Bottle') ? map_type_skuPrice.get('ASI_CRM_SG_CRM_FOB_Per_Bottle') : new ASI_CRM_MY_SKUPriceCost__c();
					ASI_CRM_MY_SKUPriceCost__c skuHistoricCostHandlingCost = map_type_skuPrice.containsKey('ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle') ? map_type_skuPrice.get('ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle') : new ASI_CRM_MY_SKUPriceCost__c();
					
					price_PRS_WS = skuHistoricCostWS.ASI_CRM_Price__c != null ? skuHistoricCostWS.ASI_CRM_Price__c : 0;
					price_WS_OT = skuHistoricCostWSOnTrade.ASI_CRM_Price__c != null ? skuHistoricCostWSOnTrade.ASI_CRM_Price__c : 0;
					cost_IGC = skuHistoricCostIGC.ASI_CRM_Cost__c != null ? skuHistoricCostIGC.ASI_CRM_Cost__c : 0;
					cost_Duty = skuHistoricCostDuty.ASI_CRM_Cost__c != null ? skuHistoricCostDuty.ASI_CRM_Cost__c : 0;
					cost_FOB = skuHistoricCostFob.ASI_CRM_Cost__c != null ? skuHistoricCostFob.ASI_CRM_Cost__c : 0;
					cost_Handling = skuHistoricCostHandlingCost.ASI_CRM_Cost__c != null ? skuHistoricCostHandlingCost.ASI_CRM_Cost__c : 0;
				}
			}
			ASI_FOC_Request_Item__c item = new ASI_FOC_Request_Item__c (
					recordtypeid = FOCLINE_RECORDTYPE_ID,
					ASI_FOC_SKU__c = skuId,
					ASI_FOC_Request_Quantity_Bottle__c = qty,
					ASI_FOC_Actual_Quantity_Bottle__c = qty,
					//ASI_CRM_Offtake_Quantity__c = actualOfftakeQty,
					ASI_CRM_SG_A_G_Code__c = FOC_CODE,
					ASI_CRM_SG_FOC_Type__c = FOC_TYPE,
					ASI_CRM_Promotion_Detail__c = pd.Id,
					ASI_CRM_Promotion__c = pd.ASI_HK_CRM_Promotion__c,
					ASI_CRM_SG_Unit_Price__c = price_PRS_WS,
					ASI_CRM_Duty_Per_Bottle__c = cost_Duty,
					ASI_CRM_FOB_Per_Bottle__c = cost_FOB,
					ASI_CRM_Handling_Cost_Per_Bottle__c = cost_Handling,
					ASI_CRM_IGC_Cost_Per_case__c = cost_IGC,
					ASI_CRM_Selling_Price_Btl_PRS_WS__c = price_PRS_WS,
					ASI_CRM_Selling_Price_Btl_WS_On_Trade__c = price_WS_OT,
					ASI_FOC_Free_Good_Cost__c = cost_IGC / packSize * qty,
					ASI_CRM_Incentive_Ratio__c = incentiveFactor,
					ASI_CRM_Offtake_Quantity_9L__c = volume9L,
					ASI_CRM_Buy_every_9L__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_9L__c,
					ASI_CRM_Give_Bottle__c = isPromotionalSKU ? pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Trade_Deal_Bottle_Qty__c : pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_Bottle_Qty__c,
					ASI_CRM_Carry_Over_Bottle__c = carryOverBottle
				);
			this.map_promotionProductId_focLine.put(key, item);
		}
		
		public void addPaymentLine(ASI_HK_CRM_Promotion_Detail__c pd, string key, string subBrandId, decimal amount, decimal volume9L){
			key = pd.id;
			decimal incentiveFactor = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c;
			ASI_TH_CRM_PaymentRequestLineItem__c item = this.map_promotionProductId_paymentLine.containsKey(key) ?
				this.map_promotionProductId_paymentLine.get(key) :
				new ASI_TH_CRM_PaymentRequestLineItem__c (
					RecordTypeId = PAYMENTLINE_RECORDTYPE_ID,
					ASI_CRM_SKU__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c,
					ASI_CRM_SG_Sub_brand__c = subBrandId,
					ASI_CRM_SG_Type__c = PAYMENT_TYPE,
					ASI_CRM_Incentive_Ratio__c = incentiveFactor,
					ASI_CRM_Volume_9L__c = volume9L,
					ASI_TH_CRM_Amount__c = 0,
					ASI_CRM_Adjusted_Amount__c = 0,
					ASI_CRM_Promotion_Detail__c = pd.Id,
					ASI_CRM_Promotion__c = pd.ASI_HK_CRM_Promotion__c,
					ASI_CRM_Buy_every_9L__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_9L__c,
					ASI_CRM_Give_Ad_hoc_Cash__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Ad_hoc_Cash__c
				);
			item.ASI_TH_CRM_Amount__c += amount;
			item.ASI_CRM_Adjusted_Amount__c += amount;
			this.map_promotionProductId_paymentLine.put(key, item);
		}
		
		public void addVoucherLine(ASI_HK_CRM_Promotion_Detail__c pd, string key, string voucherId, decimal amount, decimal voucherValue, decimal volume9L){
			key = pd.id;
			decimal incentiveFactor = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c;
			ASI_CRM_Voucher_Detail__c item = this.map_promotionProductId_voucherLine.containsKey(key) ?
				this.map_promotionProductId_voucherLine.get(key) :
				new ASI_CRM_Voucher_Detail__c (
					RecordTypeId = VOUCHERLINE_RECORDTYPE_ID,
					ASI_CRM_SKU__c = voucherId,
					ASI_CRM_Type__c = VOUCHER_TYPE,
					ASI_CRM_Incentive_Ratio__c = incentiveFactor,
					ASI_CRM_Offtake_Volume__c = volume9L,
					ASI_CRM_Quantity__c = 0,
					ASI_CRM_Value_per_Voucher__c = voucherValue,
					ASI_CRM_Promotion_Detail__c = pd.Id,
					ASI_CRM_Promotion__c = pd.ASI_HK_CRM_Promotion__c,
					ASI_CRM_Promotion_Plan__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c,
					ASI_CRM_Buy_every_9L__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_9L__c
				);
			item.ASI_CRM_Quantity__c += amount;
			this.map_promotionProductId_voucherLine.put(key, item);
		}
		
		public list<ASI_FOC_Request_Item__c> getFocLineToInsert(){
			for(ASI_FOC_Request_Item__c item : this.map_promotionProductId_focLine.values()){
				item.ASI_FOC_Request_Order__c = this.foc.Id;
			}
			return this.map_promotionProductId_focLine.values();
		}
		
		public list<ASI_TH_CRM_PaymentRequestLineItem__c> getPaymentLineToInsert(){
			for(ASI_TH_CRM_PaymentRequestLineItem__c item : this.map_promotionProductId_paymentLine.values()){
				item.ASI_TH_CRM_Payment_Request__c = this.payment.Id;
			}
			return this.map_promotionProductId_paymentLine.values();
		}
		
		public list<ASI_CRM_Voucher_Detail__c> getVoucherLineToInsert(){
			for(ASI_CRM_Voucher_Detail__c item : this.map_promotionProductId_voucherLine.values()){
				item.ASI_CRM_Voucher_Header__c = this.voucher.Id;
			}
			return this.map_promotionProductId_voucherLine.values();
		}
	}
	
	private Map<string,Map<string,Map<string, ASI_CRM_MY_SKUPriceCost__c>>> getAllPriceCost(set<string> set_skuIdToGetPriceCost, map<string, date> map_promotionId_startDate, date recentStartDate){
		Map<string,Map<string,Map<string, ASI_CRM_MY_SKUPriceCost__c>>> map_promotionId_skuId_pcType_pc = new Map<string,Map<string,Map<string, ASI_CRM_MY_SKUPriceCost__c>>>();
		
		Set<String> SET_PRICE_RECTYPE_DEVNAME = new Set<String>{
			'ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle',
			'ASI_CRM_SG_Open_Outlet_Price_Per_Bottle',
			'ASI_CRM_SG_IGC',
			'ASI_CRM_SG_CRM_Duty_Per_Bottle',
			'ASI_CRM_SG_CRM_FOB_Per_Bottle',
			'ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle'
		};
		String query = 
            'Select id, ASI_CRM_SKU__c, ASI_CRM_Price__c, ASI_CRM_Cost__c, ASI_CRM_EffectiveDate__c, recordtype.developername ' +
			'From ASI_CRM_MY_SKUPriceCost__c ' +
            'WHERE ASI_CRM_SKU__c IN :set_skuIdToGetPriceCost ' + 
            ' AND recordtype.developername IN :SET_PRICE_RECTYPE_DEVNAME ' +
            ' AND ASI_CRM_EffectiveDate__c <= :recentStartDate ' +
            ' ORDER BY ASI_CRM_EffectiveDate__c DESC ';
        List<ASI_CRM_MY_SKUPriceCost__c> skuPriceCost = (List<ASI_CRM_MY_SKUPriceCost__c>)Database.query(query);
        // Only retrieve the latest effective date price per bottle prs wholesaler
		
        for(ASI_CRM_MY_SKUPriceCost__c priceCost : skuPriceCost) {
            for(string pid : map_promotionId_startDate.keySet()){
                if (priceCost.ASI_CRM_EffectiveDate__c > map_promotionId_startDate.get(pid)) continue;
                
                Map<string,Map<string, ASI_CRM_MY_SKUPriceCost__c>> map_sku_type_skuPrice = map_promotionId_skuId_pcType_pc.containsKey(pid) ? map_promotionId_skuId_pcType_pc.get(pid) : new Map<string, Map<string,ASI_CRM_MY_SKUPriceCost__c>>();
                
                Map<string, ASI_CRM_MY_SKUPriceCost__c> map_type_skuPrice = map_sku_type_skuPrice.containsKey(priceCost.ASI_CRM_SKU__c) ? map_sku_type_skuPrice.get(priceCost.ASI_CRM_SKU__c) : new Map<string,ASI_CRM_MY_SKUPriceCost__c>();
                if (map_type_skuPrice.keySet()==SET_PRICE_RECTYPE_DEVNAME) {
                    continue;
                } else
                if (!map_type_skuPrice.containsKey('ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle') && priceCost.RecordType.DeveloperName=='ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle'){
                    map_type_skuPrice.put('ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle',priceCost);
                    map_sku_type_skuPrice.put(priceCost.ASI_CRM_SKU__c, map_type_skuPrice);
                } else
                if (!map_type_skuPrice.containsKey('ASI_CRM_SG_Open_Outlet_Price_Per_Bottle') && priceCost.RecordType.DeveloperName=='ASI_CRM_SG_Open_Outlet_Price_Per_Bottle'){
                    map_type_skuPrice.put('ASI_CRM_SG_Open_Outlet_Price_Per_Bottle',priceCost);
                    map_sku_type_skuPrice.put(priceCost.ASI_CRM_SKU__c, map_type_skuPrice);
                } else
                if (!map_type_skuPrice.containsKey('ASI_CRM_SG_IGC') && priceCost.RecordType.DeveloperName=='ASI_CRM_SG_IGC'){
                    map_type_skuPrice.put('ASI_CRM_SG_IGC',priceCost);
                    map_sku_type_skuPrice.put(priceCost.ASI_CRM_SKU__c, map_type_skuPrice);
                } else
                if (!map_type_skuPrice.containsKey('ASI_CRM_SG_CRM_Duty_Per_Bottle') && priceCost.RecordType.DeveloperName=='ASI_CRM_SG_CRM_Duty_Per_Bottle'){
                    map_type_skuPrice.put('ASI_CRM_SG_CRM_Duty_Per_Bottle',priceCost);
                    map_sku_type_skuPrice.put(priceCost.ASI_CRM_SKU__c, map_type_skuPrice);
                } else
                if (!map_type_skuPrice.containsKey('ASI_CRM_SG_CRM_FOB_Per_Bottle') && priceCost.RecordType.DeveloperName=='ASI_CRM_SG_CRM_FOB_Per_Bottle'){
                    map_type_skuPrice.put('ASI_CRM_SG_CRM_FOB_Per_Bottle',priceCost);
                    map_sku_type_skuPrice.put(priceCost.ASI_CRM_SKU__c, map_type_skuPrice);
                } else
                if (!map_type_skuPrice.containsKey('ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle') && priceCost.RecordType.DeveloperName=='ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle'){
                    map_type_skuPrice.put('ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle',priceCost);
                    map_sku_type_skuPrice.put(priceCost.ASI_CRM_SKU__c, map_type_skuPrice);
                }
                
                map_promotionId_skuId_pcType_pc.put(pid,map_sku_type_skuPrice);
            }
            
        }
		return map_promotionId_skuId_pcType_pc;
	}
		
	private map<string, string> getWholesalerOutletIdMap(){
		map<string, string> map_wholesalerId_wholesalerOutletId = new map<string, string>();
		for(ASI_CRM_AccountsAdditionalField__c c : [
			select id, ASI_CRM_CN_Parent_Outlet__c
			from ASI_CRM_AccountsAdditionalField__c
			where recordtypeId = :OUTLET_RECORDTYPE_ID
			and ASI_CRM_CN_Parent_Outlet__c != null
			and ASI_CRM_CN_Parent_Outlet__r.recordtypeId = :WHOLESALER_RECORDTYPE_ID
		]){
			map_wholesalerId_wholesalerOutletId.put(c.ASI_CRM_CN_Parent_Outlet__c, c.id);
		}
		return map_wholesalerId_wholesalerOutletId;
	}
}