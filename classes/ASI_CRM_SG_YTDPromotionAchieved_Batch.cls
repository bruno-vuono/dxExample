/*********************************************************************************
 * Name: ASI_CRM_SG_YTDPromotionAchieved_Batch
 * Description: Calculate the YTD achievement of promotions
 *
 * Version History
 * Date 			Developer 			Comments
 * --------------- -------------------- --------------------------------------------------------------------------------
 * 2018-04-09		Vincent Lam			Create
*/
global class ASI_CRM_SG_YTDPromotionAchieved_Batch implements Database.Batchable<AggregateResult>, Database.stateful, Schedulable {
    
	public static final Id ACTUALOFFTAKE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake');
	public static final Id SOHD_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_HK_CRM_Sales_Order_History_Detail__cASI_CRM_SG_Sales_Order_History_Detail');
	public static final Id PROMOTION_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion_Read_Only');
	public static final Id PROMOTIONPLAN_OUTLET_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Outlet_Promotion_Plan_Final_Approved');
	public static final Id PROMOTIONPLAN_WHOLESALER_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan_Final_Approved');
	public static final Id PROMOTIONDETAILACHIEVEMENT_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Detail_Achievement__cASI_CRM_SG_Promotion_Detail_Achievement');
	public static final Id OUTLET_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_AccountsAdditionalField__cASI_CRM_SG_Outlet');
	public static final Id WHOLESALER_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_AccountsAdditionalField__cASI_CRM_SG_Wholesaler');
	public static final Id CONTRACT_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_TH_CRM_Contract__cASI_CRM_SG_Contract_Read_Only');
		
	public static final String OUTLET = 'Outlet';
	public static final String WHOLESALER = 'Wholesaler';
	public static final String CONTRACTEDOUTLET = 'Contracted Outlet';
	
	public static final Set<String> SET_SOHD_TYPE = new Set<String>{
        //'Singapore DF & DP Free Issue - F1',
		'Singapore DF & DP Sales Order - SO'
    };

	public static final Set<String> SET_PROMOTIONPLAN_RECORDTYPEID = new Set<String>{
        PROMOTIONPLAN_OUTLET_RECORDTYPE_ID,
		PROMOTIONPLAN_WHOLESALER_RECORDTYPE_ID
    };

	public static final map<String, string> MAP_PROMOTIONTYPE_RECORDTYPEID = new map<String, string>{
        OUTLET => OUTLET_RECORDTYPE_ID,
		WHOLESALER => WHOLESALER_RECORDTYPE_ID
    };

	public static final map<String, string> MAP_PROMOTIONTYPE_PROMOTIONPLANRECORDTYPEID = new map<String, string>{
        OUTLET => PROMOTIONPLAN_OUTLET_RECORDTYPE_ID,
		WHOLESALER => PROMOTIONPLAN_WHOLESALER_RECORDTYPE_ID
    };

	//Variable for init query
	public string monthStr, yearStr, promotionType, customerId;
	public boolean calculateParent;
	public Map<string, list<AggregateResult>> map_customerSKUsubBrand_results;
	public Map<String, String> skuMappingMap;
	public Map<String, Set<string>> skuMappingMap_reverse;
	public Set<string> set_skuId, set_subBrandId, set_skuIdToRetrieve, set_customerId, set_promotionId;
	public Map<string, list<ASI_HK_CRM_Promotion_Detail__c>> map_customerSKUsubBrand_listPromotionDetails;
	public Map<string, ASI_CRM_Promotion_Detail_Achievement__c> map_id_achievementToDelete;
	public Map<string, ASI_CRM_Promotion_Detail_Achievement__c> map_id_achievementSubBrandToUpsert;
	public Map<string, string> map_offtakeConditionsToUpdate;
	public Date earliestStartDate, latestEndDate;

	// calculate all promotions that a month has, trigger from offtake adjustment page -> confirm month
	global ASI_CRM_SG_YTDPromotionAchieved_Batch(String fromYear, String fromMonth) {
		this(fromYear, fromMonth, null, OUTLET, null, false);
	}
    
	// calculate all specific promotions, differentiate by outlet or wholesaler promotion
	global ASI_CRM_SG_YTDPromotionAchieved_Batch(Set<string> set_promotionId, string promotionType) {
		this(null, null, set_promotionId, promotionType, null, false);
	}
    
	// calculate all specific outlets, trigger from offtake adjustment page -> adjust by outlet
	global ASI_CRM_SG_YTDPromotionAchieved_Batch(String fromYear, String fromMonth, String customerId) {
		this(fromYear, fromMonth, null, OUTLET, customerId, false);
	}
    
	// calculate all specific promotion type
	global ASI_CRM_SG_YTDPromotionAchieved_Batch(String fromYear, String fromMonth, String promotionType, boolean dummy) {
		this(fromYear, fromMonth, null, promotionType, null, false);
	}
    
	// calculate all specific outlets /wholesalers, trigger from IT admins support
	global ASI_CRM_SG_YTDPromotionAchieved_Batch(String fromYear, String fromMonth, String customerId, string promotionType) {
		this(fromYear, fromMonth, null, promotionType, customerId, false);
	}
    
	global ASI_CRM_SG_YTDPromotionAchieved_Batch(String fromYear, String fromMonth, Set<string> set_promotionId, String promotionType, String customerId, Boolean calculateParent) {
		this.yearStr = fromYear;
		this.monthStr = fromMonth;
		this.set_promotionId = set_promotionId != null ? set_promotionId : retrievePromotionId(fromYear, fromMonth, MAP_PROMOTIONTYPE_PROMOTIONPLANRECORDTYPEID.get(promotionType));
		this.promotionType = promotionType;
		this.customerId = customerId;
		this.calculateParent = calculateParent;
		this.skuMappingMap = getSKUMapping();
		this.skuMappingMap_reverse = getSKUMapping_reverse(this.skuMappingMap);
		
		this.set_skuId = new set<string>();
		this.set_subBrandId = new set<string>();
		retrieveSKUandSubBrandList(this.set_promotionId);
		
		this.set_skuIdToRetrieve = retrieveSKU(this.set_skuId, this.skuMappingMap, this.skuMappingMap_reverse);
		
		if(!this.calculateParent){
			List<ASI_CRM_Promotion_Detail_Achievement__c> list_pdaToUpdate = clearAchievement(this.set_promotionId, this.customerId, MAP_PROMOTIONTYPE_RECORDTYPEID.get(this.promotionType));
			if(list_pdaToUpdate.size()>0){
				update list_pdaToUpdate;
			}
			 
		} 
		
		this.map_customerSKUsubBrand_listPromotionDetails = new Map<string, list<ASI_HK_CRM_Promotion_Detail__c>>();
		this.set_customerId = new set<string>();
		this.map_id_achievementToDelete = new Map<string, ASI_CRM_Promotion_Detail_Achievement__c>();
		this.map_id_achievementSubBrandToUpsert = new Map<string, ASI_CRM_Promotion_Detail_Achievement__c>();
		retrievePromotionDetails(this.set_promotionId, this.customerId, MAP_PROMOTIONTYPE_RECORDTYPEID.get(this.promotionType), true);
		
		this.map_customerSKUsubBrand_results = new Map<string, list<AggregateResult>>();
		
	}
	
	private List<ASI_CRM_Promotion_Detail_Achievement__c> clearAchievement(Set<string> set_promotionId, string customerId, string customerRTId){
		string query = '';
		query += '	select id from ASI_CRM_Promotion_Detail_Achievement__c ';
		query += '	where  ';
		query += '		ASI_CRM_Promotion_Detail__r.ASI_HK_CRM_Promotion__r.ASI_CRM_Promotion_Plan__c in :set_promotionId ';
		query += '		AND ASI_CRM_Promotion_Detail__r.ASI_CRM_SG_Customer__r.recordtypeId = :customerRTId ';
		if(customerId != null){
			query += '		AND (ASI_CRM_Promotion_Detail__r.ASI_CRM_SG_Customer__c = :customerId OR ASI_CRM_Promotion_Detail__r.ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c = :customerId) ';
		}
		List<ASI_CRM_Promotion_Detail_Achievement__c> list_pda = (List<ASI_CRM_Promotion_Detail_Achievement__c>) Database.query(query);
		
		for(ASI_CRM_Promotion_Detail_Achievement__c pda : list_pda){
			pda.ASI_CRM_ActualConsumption_9L__c = 0;
			pda.ASI_CRM_Actual_Consumption_Value__c = 0;
		}
		return list_pda;
	}
	
	private Set<string> retrievePromotionId(string yearStr, string monthStr, string promotionPlanRTID){
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
				recordtypeid = :promotionPlanRTID AND
				ASI_CRM_Start_Date__c <= :fromDate AND
				ASI_CRM_End_Date__c >= :toDate 
				
		]){
			set_promotionId.add(p.id);
		}
		return set_promotionId;
	}
		
	private void retrieveSKUandSubBrandList(Set<string> set_promotionId){
		for(ASI_CRM_Promotion_Mechanic__c pm : [
			select 
				id, ASI_CRM_Promotional_SKU__c, ASI_CRM_Promotional_Sub_brand__c,
				ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c, ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c
			from ASI_CRM_Promotion_Mechanic__c
			where ASI_CRM_Promotion_Plan__c in :set_promotionId
		]){
			if(this.earliestStartDate == null){
				this.earliestStartDate = pm.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c;
			}else
			if(pm.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c < this.earliestStartDate){
				this.earliestStartDate = pm.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c;
			}
			
			if(this.latestEndDate == null){
				this.latestEndDate = pm.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c;
			}else
			if(pm.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c > this.latestEndDate){
				this.latestEndDate = pm.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c;
			}
			
			// one-to-one mapping of sku if there is no promotional sub-brand
			if(pm.ASI_CRM_Promotional_Sub_brand__c == null){
				this.set_skuId.add(pm.ASI_CRM_Promotional_SKU__c);
			}
			if(pm.ASI_CRM_Promotional_Sub_brand__c != null){
				this.set_subBrandId.add(pm.ASI_CRM_Promotional_Sub_brand__c);
			}
		}
	}
	
	// prepare a list of sku to be retrieved from offtake / SOH included old/new sku mapping
	private set<string> retrieveSKU(set<string> set_skuId, Map<String, String> skuMappingMap, Map<String, Set<string>> skuMappingMap_reverse){
		Set<string> set_skuIdToRetrieve = new Set<string>();
		for(string skuId : set_skuId){
			set_skuIdToRetrieve.add(skuId);
			if(skuMappingMap.containsKey(skuId)){
				string newSKUid = skuMappingMap.get(skuId);
				if(skuMappingMap_reverse.containsKey(newSKUid)){
					set_skuIdToRetrieve.addAll(skuMappingMap_reverse.get(newSKUid));
				}
			}
		}
		return set_skuIdToRetrieve;
	}
	
	private void retrievePromotionDetails(Set<string> set_promotionId, string customerId, string customerRTId, boolean isInit){
		Map<string, list<ASI_HK_CRM_Promotion_Detail__c>> map_customerSKUsubBrand_listPromotionDetails_temp = new Map<string, list<ASI_HK_CRM_Promotion_Detail__c>>();
		Set<string> set_customerId_temp = new Set<string>();
		Map<string, ASI_CRM_Promotion_Detail_Achievement__c> map_id_achievementToDelete_temp = new Map<string, ASI_CRM_Promotion_Detail_Achievement__c>();
		
		string query = '';
		query += 'select ';
		query += '	id, ASI_CRM_SG_Customer__c, ASI_HK_CRM_Promotion__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_Cash__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_FOC__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_OIK__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_Voucher__c, ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c, ';
		query += '	( ';
		query += '		select id, ASI_CRM_Achievement_Year__c, ASI_CRM_Achievement_Month__c, ASI_CRM_Promotion_Detail__c, ASI_CRM_ActualConsumption_9L__c, ASI_CRM_Actual_Consumption_Value__c ';
		query += '		from Promotion_Detail_Achievements__r ';
		query += '	) ';
		query += 'from  ';
		query += '	ASI_HK_CRM_Promotion_Detail__c ';
		query += 'where ';
		query += '	ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c in :set_promotionId ';
		query += '	AND ASI_CRM_SG_Customer__r.recordtypeId = :customerRTId ';
		if(customerId != null){
			query += '	AND (ASI_CRM_SG_Customer__c = :customerId OR ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c = :customerId)';
		}
		
		for(ASI_HK_CRM_Promotion_Detail__c pd : (List<ASI_HK_CRM_Promotion_Detail__c>) Database.query(query)){
			string cid = pd.ASI_CRM_SG_Customer__c;
			string sid = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c != null ? 
							pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c : 
							(
								this.skuMappingMap.containsKey(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c) ? 
								this.skuMappingMap.get(pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c) :
								pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c
							);
			string key = cid + '_' + sid;
			
			list<ASI_HK_CRM_Promotion_Detail__c> list_pd = map_customerSKUsubBrand_listPromotionDetails_temp.containsKey(key) ? 
															map_customerSKUsubBrand_listPromotionDetails_temp.get(key) : 
															new list<ASI_HK_CRM_Promotion_Detail__c>();
			list_pd.add(pd);
			map_customerSKUsubBrand_listPromotionDetails_temp.put(key, list_pd);
			
			set_customerId_temp.add(cid);
			
			for(ASI_CRM_Promotion_Detail_Achievement__c pda : pd.Promotion_Detail_Achievements__r){
				//pda.ASI_CRM_ActualConsumption_9L__c = 0;
				map_id_achievementToDelete_temp.put(pda.id, pda);
			}
		}
		
		this.map_customerSKUsubBrand_listPromotionDetails = map_customerSKUsubBrand_listPromotionDetails_temp;
		
		if(isInit){
			this.set_customerId = set_customerId_temp;
			this.map_id_achievementToDelete = map_id_achievementToDelete_temp;
		}
	}
    
	global class AggregateResultIterable implements Iterable<AggregateResult> {
        public date startDate;  
        public date endDate;  
        public set<string> set_skuId;  
        public set<string> set_subBrandId;  
        public set<string> set_customerId;  
		public string promotionType;
		boolean calculateParent;
        global AggregateResultIterable (date startDate, date endDate, set<string> set_skuId, set<string> set_subBrandId, set<string> set_customerId, string promotionType, boolean calculateParent){
             this.startDate = startDate;
             this.endDate = endDate;
			 this.set_skuId = set_skuId;
			 this.set_subBrandId = set_subBrandId;
			 this.set_customerId = set_customerId;
			 this.promotionType = promotionType;
			 this.calculateParent = calculateParent;
         }
        global Iterator<AggregateResult> Iterator(){
            return new AggregateResultIterator(startDate, endDate, set_skuId, set_subBrandId, set_customerId, promotionType, calculateParent);
       }
    }
 
    global class AggregateResultIterator implements Iterator<AggregateResult> {
        AggregateResult [] results {get;set;}
        Integer index {get; set;} 
 
        global AggregateResultIterator(date startDate, date endDate, set<string> set_skuId, set<string> set_subBrandId, set<string> set_customerId, string promotionType, boolean calculateParent) {
            index = 0;
			if (promotionType == OUTLET) {
                if(!calculateParent){
					results = [select 
								ASI_CRM_SKU__c sku, 
								ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c subBrand,
								ASI_CRM_SG_Customer__c customer,
								calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c) year,
								calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c) month,
								sum(ASI_CRM_Converted_Qty_9L__c) volume9L,
								sum(ASI_CRM_Gross_Sales_RTM__c) actualValue
							from 
								ASI_TH_CRM_Actual_Offtake__c 
							WHERE  
								RecordTypeId = :ACTUALOFFTAKE_RECORDTYPE_ID
								AND ASI_CRM_SG_Customer__c <> null 
								AND ASI_CRM_SKU__c <> null 
								AND ASI_CRM_SG_Customer__c in :set_customerId 
								AND ASI_TH_CRM_Offtake_G_L_Date__c >= :startDate 
								AND ASI_TH_CRM_Offtake_G_L_Date__c <= :endDate
								AND (ASI_CRM_SKU__c in :set_skuId
									OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c in :set_subBrandId
									)
							group by 
								ASI_CRM_SKU__c, 
								ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
								ASI_CRM_SG_Customer__c,
								calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c),
								calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c)
							order by 
								ASI_CRM_SG_Customer__c,
								ASI_CRM_SKU__c,
								ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
								calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c),
								calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c)
						];       
				} else {
					results = [select 
								ASI_CRM_SKU__c sku, 
								ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c subBrand,
								ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c customer,
								calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c) year,
								calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c) month,
								sum(ASI_CRM_Converted_Qty_9L__c) volume9L,
								sum(ASI_CRM_Gross_Sales_RTM__c) actualValue
							from 
								ASI_TH_CRM_Actual_Offtake__c 
							WHERE  
								RecordTypeId = :ACTUALOFFTAKE_RECORDTYPE_ID
								AND ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c <> null 
								AND ASI_CRM_SKU__c <> null 
								AND ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c in :set_customerId 
								AND ASI_TH_CRM_Offtake_G_L_Date__c >= :startDate 
								AND ASI_TH_CRM_Offtake_G_L_Date__c <= :endDate
								AND (ASI_CRM_SKU__c in :set_skuId
									OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c in :set_subBrandId
									)
							group by 
								ASI_CRM_SKU__c, 
								ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
								ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c,
								calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c),
								calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c)
							order by 
								ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c,
								ASI_CRM_SKU__c,
								ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
								calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c),
								calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c)
						];     
				}
            } else {
                if(!calculateParent){
					results = [select 
								ASI_HK_CRM_Product_SKU__c sku, 
								ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c subBrand, 
								ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c customer,
								calendar_year(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) year,
								calendar_month(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) month,
								sum(ASI_CRM_Converted_Qty_9L__c) volume9L,
								sum(ASI_CRM_Total_Amount_Number__c) actualValue
							from 
								ASI_HK_CRM_Sales_Order_History_Detail__c 
							WHERE  
								RecordTypeId = :SOHD_RECORDTYPE_ID
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c <> null 
								AND ASI_HK_CRM_Product_SKU__c <> null 
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c in :set_customerId
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Type__c in :SET_SOHD_TYPE
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c >= :startDate 
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c <= :endDate 
								AND (ASI_HK_CRM_Product_SKU__c in :set_skuId
									OR ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c in :set_subBrandId
									)
							group by 
								ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c,
								ASI_HK_CRM_Product_SKU__c , 
								ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c,
								calendar_year(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) ,
								calendar_month(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) 
							order by 
								ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c,
								ASI_HK_CRM_Product_SKU__c , 
								ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c,
								calendar_year(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) ,
								calendar_month(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) 
						];     
				} else {
					results = [select 
								ASI_HK_CRM_Product_SKU__c sku, 
								ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c subBrand, 
								ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__r.ASI_CRM_CN_Parent_Outlet__c customer,
								calendar_year(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) year,
								calendar_month(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) month,
								sum(ASI_CRM_Converted_Qty_9L__c) volume9L,
								sum(ASI_CRM_Total_Amount_Number__c) actualValue
							from 
								ASI_HK_CRM_Sales_Order_History_Detail__c 
							WHERE  
								RecordTypeId = :SOHD_RECORDTYPE_ID
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c <> null 
								AND ASI_HK_CRM_Product_SKU__c <> null 
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__r.ASI_CRM_CN_Parent_Outlet__c in :set_customerId
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Type__c in :SET_SOHD_TYPE
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c >= :startDate 
								AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c <= :endDate 
								AND (ASI_HK_CRM_Product_SKU__c in :set_skuId
									OR ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c in :set_subBrandId
									)
							group by 
								ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__r.ASI_CRM_CN_Parent_Outlet__c,
								ASI_HK_CRM_Product_SKU__c , 
								ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c,
								calendar_year(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) ,
								calendar_month(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) 
							order by 
								ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__r.ASI_CRM_CN_Parent_Outlet__c,
								ASI_HK_CRM_Product_SKU__c , 
								ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c,
								calendar_year(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) ,
								calendar_month(ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c) 
						];     
				}
			}
        } 
 
        global boolean hasNext(){ 
           return results != null && !results.isEmpty() && index < results.size(); 
        }    
 
        global AggregateResult next(){ 
            return results[index++];            
        }       
    }    
 
    global Iterable<AggregateResult> start(Database.batchableContext info){
        // just instantiate the new iterable here and return
        return new AggregateResultIterable(this.earliestStartDate, this.latestEndDate, this.set_skuIdToRetrieve, this.set_subBrandId, this.set_customerId, this.promotionType, this.calculateParent);
    }
	
	global void execute(Database.BatchableContext contextInstance, list<AggregateResult> pLstFetchedRecords){
		this.map_offtakeConditionsToUpdate = new map<string, string>();
		retrievePromotionDetails(this.set_promotionId, this.customerId, MAP_PROMOTIONTYPE_RECORDTYPEID.get(this.promotionType), false);
		
		List<ASI_CRM_Promotion_Detail_Achievement__c> list_pdaToUpsert = new List<ASI_CRM_Promotion_Detail_Achievement__c>();
		map<string, ASI_CRM_Promotion_Detail_Achievement__c> map_pdaToUpsert = new map<string, ASI_CRM_Promotion_Detail_Achievement__c>();
		
		for(AggregateResult ar : pLstFetchedRecords){
			String sku = String.valueOf(ar.get('sku'));
			String subBrand = String.valueOf(ar.get('subBrand'));
			String customer = String.valueOf(ar.get('customer'));
			
			// for sku
			String key_sku = customer + '_' + 
				(this.skuMappingMap.containsKey(sku) ? this.skuMappingMap.get(sku) : sku);
			/*
			List<AggregateResult> list_ar_sku = map_customerSKUsubBrand_results.containsKey(key_sku) ? map_customerSKUsubBrand_results.get(key_sku) : new List<AggregateResult>();
			list_ar_sku.add(ar);
			map_customerSKUsubBrand_results.put(key_sku, list_ar_sku);
			*/
			
			// for subBrand
			String key_subBrand = customer + '_' + subBrand;
			/*
			List<AggregateResult> list_ar_subBrand = map_customerSKUsubBrand_results.containsKey(key_subBrand) ? map_customerSKUsubBrand_results.get(key_subBrand) : new List<AggregateResult>();
			list_ar_subBrand.add(ar);
			map_customerSKUsubBrand_results.put(key_subBrand, list_ar_subBrand);
			*/
			
			if(map_customerSKUsubBrand_listPromotionDetails.containsKey(key_sku)){
				//list_pdaToUpsert.addall(buildAchievementList(key_sku, ar));
				map_pdaToUpsert = buildAchievementMap(key_sku, ar, map_pdaToUpsert);
			}
			
			if(map_customerSKUsubBrand_listPromotionDetails.containsKey(key_subBrand)){
				//list_pdaToUpsert.addall(buildAchievementList(key_subBrand, ar));
				map_pdaToUpsert = buildAchievementMap(key_subBrand, ar, map_pdaToUpsert);
			}
			
		}
		//if(list_pdaToUpsert.size() > 0) upsert list_pdaToUpsert;
		if(map_pdaToUpsert.keySet().size() > 0) upsert map_pdaToUpsert.values();
		
		if(this.map_offtakeConditionsToUpdate.keySet().size() > 0){
			populateOfftakeWithContributeToPromotion(this.map_offtakeConditionsToUpdate);
			
		}
	}
	
	global void finish(Database.BatchableContext contextInstance){
		if(this.map_id_achievementToDelete.keySet().size()>0) update this.map_id_achievementToDelete.values();
		
		// start calculate achievement for parent customer
		if(!this.calculateParent){
			Database.executeBatch(new ASI_CRM_SG_YTDPromotionAchieved_Batch(
				this.yearStr, this.monthStr, this.set_promotionId, this.promotionType, this.customerId, true
			), 200);
		}else{
			checkActiveContract();
		}
		
		/*
		list<ASI_HK_CRM_Promotion_Detail__c> list_pdToUpdate = new list<ASI_HK_CRM_Promotion_Detail__c>();
		for(string key : map_customerSKUsubBrand_listPromotionDetails.keySet()){
			list<ASI_HK_CRM_Promotion_Detail__c> list_pd = map_customerSKUsubBrand_listPromotionDetails.get(key);
			if(!map_customerSKUsubBrand_results.containsKey(key)){
				for(ASI_HK_CRM_Promotion_Detail__c pd : list_pd){
					pd.ASI_CRM_ActualConsumption_9L__c = 0;
					list_pdToUpdate.add(pd);
				}
			}else{
				List<AggregateResult> list_ar = map_customerSKUsubBrand_results.get(key);
				for(ASI_HK_CRM_Promotion_Detail__c pd : list_pd){
					decimal totalVolume9L = 0;
					for(AggregateResult ar : list_ar){
						Integer year = Integer.valueOf(ar.get('year'));
						Integer month = Integer.valueOf(ar.get('month'));
						Decimal volume9L = (Decimal)ar.get('volume9L');
						Date consumptionDate = Date.newInstance(year, month, 15);
						if(
							pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c <= consumptionDate &&
							pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c >= consumptionDate
						){
							totalVolume9L += volume9L;
						}
					}
					pd.ASI_CRM_ActualConsumption_9L__c = totalVolume9L;
					list_pdToUpdate.add(pd);
				}
			}
		}
		
		update list_pdToUpdate;
		*/
	}
	
	public void execute(SchedulableContext contextInstance) {}
	
	/*
    public void sendEMailNotification(Id BC_ID, set<string> set_paymentID, set<string> set_creditNoteID){
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
        mail.setSubject('Wholesaler Back Rebate Generation ' + a.Status);
        if (set_creditNoteID.size()>0 || set_paymentID.size()>0){
            string ebody = '<p>The Wholesaler Back Rebate generation for ' + this.monthStr + '/' + this.yearStr + 
                ' is completed with '+ a.NumberOfErrors + ' errors.</p>';
            ebody += '<table width="100%" border="1">';
            ebody += '<tr><th>Record No.</th><th>Type</th><th>Wholesaler</th><th>Total Taxable Amount</th>';
			for (ASI_TH_CRM_PaymentRequest__c p :[
                select id, name, ASI_CRM_CN_OutletWS__r.name, ASI_TH_CRM_Total_Amount__c from ASI_TH_CRM_PaymentRequest__c
                where id in :set_paymentID
				order by ASI_CRM_CN_OutletWS__r.name
            ]){
				ebody += '<tr><td>'+p.name+'</td><td>Payment</td><td>'+p.ASI_CRM_CN_OutletWS__r.name+'</td><td style="text-align:right">'+doFormatting(p.ASI_TH_CRM_Total_Amount__c, 2, ',', '.')+'</td></tr>';
			}
            for (ASI_CRM_Credit_Debit_Note__c p : [
                select id, name, ASI_CRM_Wholesaler__r.name, ASI_CRM_Total_Amount__c, recordtypeid from ASI_CRM_Credit_Debit_Note__c
                where id in :set_creditNoteID
				order by ASI_CRM_Wholesaler__r.name, recordtype.developername
            ]){
                ebody += '<tr><td>'+p.name+'</td><td>'+MAP_HEADER_RTID_CREDITORDEBIT.get(p.recordtypeid)+'</td><td>'+p.ASI_CRM_Wholesaler__r.name+'</td><td style="text-align:right">'+doFormatting(p.ASI_CRM_Total_Amount__c, 2, ',', '.')+'</td></tr>';
            }
            ebody += '</table>';
            mail.setHtmlBody(ebody);
        } else {
            mail.setPlainTextBody
           ('The Wholesaler Back Rebate generation for ' + this.monthStr + '/' + this.yearStr + 
           ' completed with '+ a.NumberOfErrors + ' errors. No credit/debit note or payment is generated.');
        }
       
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
	*/
    
	/*
	private List<ASI_CRM_Promotion_Detail_Achievement__c> buildAchievementList(string key, AggregateResult ar){
		Integer year = Integer.valueOf(ar.get('year'));
		Integer month = Integer.valueOf(ar.get('month'));
		Decimal volume9L = (Decimal)ar.get('volume9L');
		Date consumptionDate = Date.newInstance(year, month, 15);
		
		List<ASI_CRM_Promotion_Detail_Achievement__c> list_pdaToUpsert = new List<ASI_CRM_Promotion_Detail_Achievement__c>();
		
		list<ASI_HK_CRM_Promotion_Detail__c> list_pd = map_customerSKUsubBrand_listPromotionDetails.get(key);
		for(ASI_HK_CRM_Promotion_Detail__c pd : list_pd){
			if(
				pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c <= consumptionDate &&
				pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c >= consumptionDate
			){
				Boolean achievementExist = false;
				ASI_CRM_Promotion_Detail_Achievement__c pdaToUpsert;
				
				// update existing achievement
				for(ASI_CRM_Promotion_Detail_Achievement__c pda : pd.Promotion_Detail_Achievements__r){
					if(
						pda.ASI_CRM_Achievement_Year__c == year &&
						pda.ASI_CRM_Achievement_Month__c == month
					){
						pdaToUpsert = pda;
						achievementExist = true;
						this.map_id_achievementToDelete.remove(pda.Id);
					}
				}
				
				// insert new year/month achievement
				if(!achievementExist){
					pdaToUpsert = new ASI_CRM_Promotion_Detail_Achievement__c(
						RecordtypeId = PROMOTIONDETAILACHIEVEMENT_RECORDTYPE_ID,
						ASI_CRM_Promotion_Detail__c = pd.Id,
						ASI_CRM_Achievement_Date__c = consumptionDate,
						ASI_CRM_ActualConsumption_9L__c = 0
					);
				}
				pdaToUpsert.ASI_CRM_ActualConsumption_9L__c += volume9L;
				list_pdaToUpsert.add(pdaToUpsert);
				
			}
			
		}
		return list_pdaToUpsert;
	}
	*/
	
	private map<string, ASI_CRM_Promotion_Detail_Achievement__c> buildAchievementMap(string key, AggregateResult ar, map<string, ASI_CRM_Promotion_Detail_Achievement__c> map_pdaToUpsert){
		Integer year = Integer.valueOf(ar.get('year'));
		Integer month = Integer.valueOf(ar.get('month'));
		Decimal volume9L = (Decimal)ar.get('volume9L');
		Decimal actualValue = (Decimal)ar.get('actualValue') != null ? (Decimal)ar.get('actualValue') : 0;
		Date consumptionDate = Date.newInstance(year, month, 15);
		String customer = String.valueOf(ar.get('customer'));
		
		List<ASI_CRM_Promotion_Detail_Achievement__c> list_pdaToUpsert = new List<ASI_CRM_Promotion_Detail_Achievement__c>();
		
		list<ASI_HK_CRM_Promotion_Detail__c> list_pd = map_customerSKUsubBrand_listPromotionDetails.get(key);
		for(ASI_HK_CRM_Promotion_Detail__c pd : list_pd){
			if(
				pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c <= consumptionDate &&
				pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c >= consumptionDate
			){
				Boolean achievementExist = false;
				ASI_CRM_Promotion_Detail_Achievement__c pdaToUpsert;
				
				// update existing achievement
				for(ASI_CRM_Promotion_Detail_Achievement__c pda : pd.Promotion_Detail_Achievements__r){
					if(
						pda.ASI_CRM_Achievement_Year__c == year &&
						pda.ASI_CRM_Achievement_Month__c == month
					){
						pdaToUpsert = pda;
						achievementExist = true;
						this.map_id_achievementToDelete.remove(pda.Id);
					}
				}
				
				String key_pda = customer + '_' + pd.Id + '_' + year + '_' + month;
				
				// insert new year/month achievement
				if(!achievementExist){
					pdaToUpsert = map_pdaToUpsert.containsKey(key_pda) ? 
						map_pdaToUpsert.get(key_pda) : 
						new ASI_CRM_Promotion_Detail_Achievement__c(
						RecordtypeId = PROMOTIONDETAILACHIEVEMENT_RECORDTYPE_ID,
						ASI_CRM_Promotion_Detail__c = pd.Id,
						ASI_CRM_Incentive_Value_per_9L__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L__c,
						ASI_CRM_Incentive_Value_per_9L_Cash__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_Cash__c,
						ASI_CRM_Incentive_Value_per_9L_FOC__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_FOC__c,
						ASI_CRM_Incentive_Value_per_9L_OIK__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_OIK__c,
						ASI_CRM_Incentive_Value_per_9L_Voucher__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Value_per_9L_Voucher__c,
						ASI_CRM_Incentive_Volume_per_Unit__c = pd.ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Incentive_Volume_per_Unit__c,
						ASI_CRM_Achievement_Date__c = consumptionDate,
						ASI_CRM_ActualConsumption_9L__c = 0,
						ASI_CRM_Actual_Consumption_Value__c = 0
					);
				}
				pdaToUpsert.ASI_CRM_ActualConsumption_9L__c += volume9L;
				pdaToUpsert.ASI_CRM_Actual_Consumption_Value__c += actualValue;
				
				map_pdaToUpsert.put(key_pda, pdaToUpsert);
				
				
				// prepare to update offtake with Contribute To Promotion checkbox
				if(this.promotionType == OUTLET){
					String key_offtakeCondition = key + '_' + year + '_' + month;
					this.map_offtakeConditionsToUpdate.put(key_offtakeCondition, pd.ASI_HK_CRM_Promotion__c);
				}
				
			}
			
		}
		return map_pdaToUpsert;
	}
	
	private void populateOfftakeWithContributeToPromotion(map<string, string> map_conditions){
		List<ASI_TH_CRM_Actual_Offtake__c> list_offtakesToUpdate = new List<ASI_TH_CRM_Actual_Offtake__c>();
		String query = 'Select Id ' +
					   '	, ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c, ASI_CRM_SG_Customer__c ' +
					   '	, ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_CRM_SKU__c ' +
					   '	, ASI_TH_CRM_Offtake_G_L_Date__c ' +
					   'FROM  ' +
					   '	ASI_TH_CRM_Actual_Offtake__c ' +
					   'WHERE  ' +
					   '	RecordTypeId = :ACTUALOFFTAKE_RECORDTYPE_ID AND (';
		for(string conditions : map_conditions.keySet()){
			string customer = conditions.split('_')[0];
			string skuOrSubBrand = conditions.split('_')[1];
			string year = conditions.split('_')[2];
			string month = conditions.split('_')[3];
			string subQuery = ' (';
			if(this.calculateParent){
				subQuery += 'ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c = \'' + customer + '\'';
			} else {
				subQuery += 'ASI_CRM_SG_Customer__c = \'' + customer + '\'';
			}
			subQuery += ' AND (ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c = \'' + skuOrSubBrand + '\' OR ASI_CRM_SKU__c = \'' + skuOrSubBrand + '\')';
			subQuery += ' AND calendar_year(ASI_TH_CRM_Offtake_G_L_Date__c) = ' + year ;
			subQuery += ' AND calendar_month(ASI_TH_CRM_Offtake_G_L_Date__c) = ' + month ;
			subQuery += ') OR ';
			query += subQuery;
		}
		query = query.subString(0,query.length()-4);
		query += ')';
		for (ASI_TH_CRM_Actual_Offtake__c o : (List<ASI_TH_CRM_Actual_Offtake__c>)Database.query(query)){
			string customer = this.calculateParent ? o.ASI_CRM_SG_Customer__r.ASI_CRM_CN_Parent_Outlet__c : o.ASI_CRM_SG_Customer__c;
			string sku = o.ASI_CRM_SKU__c;
			string subBrand = o.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c;
			string year = String.valueOf(o.ASI_TH_CRM_Offtake_G_L_Date__c.year());
			string month = String.valueOf(o.ASI_TH_CRM_Offtake_G_L_Date__c.month());
			string key_subBrand = customer + '_' + subBrand + '_' + year + '_' + month;
			string key_sku = customer + '_' + sku + '_' + year + '_' + month;
			
			string promotionId = '';
			if(map_conditions.containsKey(key_subBrand)) promotionId = map_conditions.get(key_subBrand);
			else 
			if(map_conditions.containsKey(key_sku)) promotionId = map_conditions.get(key_sku);
			if(promotionId != ''){
				//o.ASI_CRM_Contribute_to_Promotion__c = true;
				o.ASI_CRM_Promotion__c = promotionId;
				list_offtakesToUpdate.add(o);
			}
			
		}
		if(list_offtakesToUpdate.size()>0) update list_offtakesToUpdate;
	}
	
	/*
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
	*/
	
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
	
	private Map<String, Set<string>> getSKUMapping_reverse(Map<String, String> skuMappingMap){
		Map<String, Set<string>> skuMappingMap_reverse = new Map<String, Set<string>>();
		for(string from_skuId : skuMappingMap.keySet()){
			String to_skuId = skuMappingMap.get(from_skuId);
			Set<string> set_fromSKU = skuMappingMap_reverse.containsKey(to_skuId) ? skuMappingMap_reverse.get(to_skuId) : new Set<string>();
			set_fromSKU.add(from_skuId);
			skuMappingMap_reverse.put(to_skuId, set_fromSKU);
		}
		return skuMappingMap_reverse;
	}
	
	private void checkActiveContract(){
		List<ASI_CRM_AccountsAdditionalField__c> list_c = [
			select id, (
				select id from Contracts_CN__r
				where recordtypeId = :CONTRACT_RECORDTYPE_ID
				and ASI_TH_CRM_End_Date__c >= TODAY
			) 
			from ASI_CRM_AccountsAdditionalField__c
			where recordtypeId = :OUTLET_RECORDTYPE_ID
			and ASI_CRM_Outlet_Type__c = :CONTRACTEDOUTLET
		];
		if(list_c.size()>0){
			for(ASI_CRM_AccountsAdditionalField__c c : list_c){
				c.ASI_CRM_Has_Active_Contract__c = c.Contracts_CN__r.size()>0 ? true : false;
			}
			update list_c;
		}
		
	}
}