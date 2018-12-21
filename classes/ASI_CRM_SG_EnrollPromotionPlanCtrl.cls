/*********************************************************************************
 * Name: ASI_CRM_SG_EnrollPromotionPlanCtrl
 * Description: Controller class for outlet to enroll promotion plan (ASI_CRM_SG_EnrollPromotionPlanPage)
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 26/03/2018       Hugo Cheung             Created
 * 2018-04-12       Jeffrey Cheung          calculate P12M average actual consumption to promotionDetailList
*/
public class ASI_CRM_SG_EnrollPromotionPlanCtrl {
    //Promotion Plan Record Type Developer Name
    private final static String OUTLET_PROMOTION_PLAN_RECORD_TYPE     = 'ASI_CRM_SG_Outlet_Promotion_Plan';
    private final static String WHOLESALES_PROMOTION_PLAN_RECORD_TYPE = 'ASI_CRM_SG_Wholesaler_Promotion_Plan';
    
    //Outlet Record Type Developer Name
    private final static String OUTLET_RECORD_TYPE     = 'ASI_CRM_SG_Outlet';
    private final static String WHOLESALER_RECORD_TYPE = 'ASI_CRM_SG_Wholesaler';
	
    private final static String OPEN_OUTLET            = 'Open Outlet';
    
    //Public Data Storage Parameters
    public ASI_HK_CRM_Promotion__c promotion {get; set;}
	public Boolean isReadOnly {get; set;}
	public Boolean adjustTargetOnly {get; set;}
    
    //Private Data Storage Parameters
    private List<ASI_CRM_Promotion_Mechanic__c> promotionMechanicList;
    private List<ASI_HK_CRM_Promotion_Detail__c> promotionDetailList;
    private Map<String, ASI_CRM_AccountsAdditionalField__c> customerNameMap;
	private List<ASI_TH_CRM_Actual_Offtake__c> list_P12MConsumption_offtake;
	private List<ASI_HK_CRM_Sales_Order_History_Detail__c> list_P12MConsumption_SOH;
    private List<ASI_HK_CRM_Promotion_Detail__c> addedPromotionDetailList;
    
    //Data Storage => JSON String for VF Page
    public String promotionMechanicListJson {get {return toJsonString(promotionMechanicList);}}
    public String promotionDetailListJson {get {return toJsonString(promotionDetailList);}}
    public String P12MConsumption_offtakeJson {get {return toJsonString(list_P12MConsumption_offtake);}}
    public String P12MConsumption_SOHJson {get {return toJsonString(list_P12MConsumption_SOH);}}
	public String addedPromotionDetailListJson {get {return toJsonString(addedPromotionDetailList);}}
	public String returnCustomerName {get;set;}
    
    //Auto Complete Value Map => JSON String for VF Page
    public String customerListJson {get {return toJsonString(customerNameMap.keySet());}}
    public String customerMapJson {get {return toJsonString(customerNameMap);}}

    // useful dates
    public Date lastYearSameMonthStart {get;set;}
    public Date lastMonthEnd {get;set;}
    public Date lastYearLast6MonthStart {get;set;}
    public Date lastYearLastMonthEnd {get;set;}

    //Page Parameters
    public String promotionDetailRecordTypeId {get {return Global_RecordTypeCache.getRTId('ASI_HK_CRM_Promotion_Detail__cASI_CRM_SG_Customer');}}
    
    //Other Parameters
    private final static String IS_QUICK_SAVE                         = 'isQuickSave';
    private final static String UPSERT_PROMOTION_DETAIL_LIST_JSON     = 'upsertPromotionDetailListJson';
    private final static String DELETE_PROMOTION_DETAIL_ID_LIST_JSON  = 'deletePromotionDetailIdListJson';
    
    public ASI_CRM_SG_EnrollPromotionPlanCtrl(ApexPages.StandardController standardController) {
        lastYearSameMonthStart = Date.today().addYears(-1).toStartOfMonth();
        lastMonthEnd = Date.today().toStartOfMonth().addDays(-1);
        lastYearLast6MonthStart = Date.today().addYears(-1).addMonths(-6).toStartOfMonth();
        lastYearLastMonthEnd = Date.today().addYears(-1).toStartOfMonth().addDays(-1);
		
		Map < String, String > pageParameters = ApexPages.currentPage().getParameters();
        isReadOnly = Boolean.valueOf(pageParameters.containsKey('isReadOnly') ? pageParameters.get('isReadOnly') : 'true');
        adjustTargetOnly = Boolean.valueOf(pageParameters.containsKey('adjustTargetOnly') ? pageParameters.get('adjustTargetOnly') : 'true');

        String promotionId = ApexPages.currentPage().getParameters().get('id');
        init(promotionId);
    }
    
    //Initialize controller
    private void init(String promotionId) {
      if(String.isBlank(promotionId)) return;
        
        //Init Record
        promotion             = retrievePromotion(promotionId);
        promotionDetailList   = retrievePromotionDetailList(promotionId);
        promotionMechanicList = retrievePromotionMechanicList(promotion.ASI_CRM_Promotion_Plan__c);
        customerNameMap       = new Map<String, ASI_CRM_AccountsAdditionalField__c>();
        
        String tempRT;
        if(promotion.ASI_CRM_Promotion_Plan__r.RecordType.DeveloperName.contains(OUTLET_PROMOTION_PLAN_RECORD_TYPE)) 
            tempRT = OUTLET_RECORD_TYPE;
        else if(promotion.ASI_CRM_Promotion_Plan__r.RecordType.DeveloperName.contains(WHOLESALES_PROMOTION_PLAN_RECORD_TYPE))
            tempRT = WHOLESALER_RECORD_TYPE;
        
        for(ASI_CRM_AccountsAdditionalField__c customer : retrieveCustomerList(tempRT, promotion.OwnerId)) {
            customerNameMap.put(customer.Name, customer);
        }
    }
    
    /***************
    Page Function
    ***************/
    public PageReference savePromotionDetail() {
        Map<String, String> params             = ApexPages.currentPage().getParameters();
        Boolean isQuickSave                    = String.isBlank(params.get(IS_QUICK_SAVE)) ? false : Boolean.valueOf(params.get(IS_QUICK_SAVE));
      String upsertPromotionDetailListJson   = params.get(UPSERT_PROMOTION_DETAIL_LIST_JSON);
      String removePromotionDetailIdListJson = params.get(DELETE_PROMOTION_DETAIL_ID_LIST_JSON);
        
        List<ASI_HK_CRM_Promotion_Detail__c> upsertPromotionDetailList;
        List<String> removePromotionDetailIdList;
        
        upsertPromotionDetailList   = (List<ASI_HK_CRM_Promotion_Detail__c>) fromJsonString(upsertPromotionDetailListJson, List<ASI_HK_CRM_Promotion_Detail__c>.class);
        removePromotionDetailIdList = (List<String>) fromJsonString(removePromotionDetailIdListJson, List<String>.class);
        
        if(removePromotionDetailIdList != null && removePromotionDetailIdList.size() > 0) {
          List<ASI_HK_CRM_Promotion_Detail__c> removeDataList = new List<ASI_HK_CRM_Promotion_Detail__c>();
            for(String removeDataId : removePromotionDetailIdList) {
                removeDataList.add(new ASI_HK_CRM_Promotion_Detail__c(Id = removeDataId));
            }
            Database.delete(removeDataList);
        }
        
        if(upsertPromotionDetailList != null && upsertPromotionDetailList.size() > 0) {
          List<ASI_HK_CRM_Promotion_Detail__c> insertDataList = new List<ASI_HK_CRM_Promotion_Detail__c>();
            List<ASI_HK_CRM_Promotion_Detail__c> updateDataList = new List<ASI_HK_CRM_Promotion_Detail__c>();
            
            for(ASI_HK_CRM_Promotion_Detail__c upsertData : upsertPromotionDetailList) {
                if(customerNameMap.containsKey(upsertData.ASI_CRM_SG_Customer__c))
                    upsertData.ASI_CRM_SG_Customer__c = customerNameMap.get(upsertData.ASI_CRM_SG_Customer__c).Id;
                
                if(String.isBlank(upsertData.Id)) 
                    insertDataList.add(upsertData);
                else 
                    updateDataList.add(upsertData); 
            }
            
            if(insertDataList.size() > 0) Database.insert(insertDataList);
            if(updateDataList.size() > 0) Database.update(updateDataList);
        }
        
        if(isQuickSave) {
            init(promotion.Id);
          return null;
        } else {
          PageReference pageRef = new PageReference('/' + promotion.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    public PageReference cancel() {
      PageReference pageRef = new PageReference('/' + promotion.Id);
      pageRef.setRedirect(true);
      return pageRef;
    }


//    @RemoteAction
//    public static Decimal calculateP12MAverageConsumption(String customerName, List<String> skuIds, List<String> subBrandIds) {
//        List<ASI_CRM_AccountsAdditionalField__c> accounts = [SELECT Id FROM ASI_CRM_AccountsAdditionalField__c WHERE Name = :customerName AND RecordType.DeveloperName  = 'ASI_CRM_SG_Outlet' LIMIT 1];
//        Id customerId = (accounts.size() == 1)? accounts.get(0).Id : '';
//
//
//        System.debug('customerId ' + customerId);
//
//        Date lastYearSameMonthStart = Date.today().addYears(-1).toStartOfMonth();
//        Date lastMonthEnd = Date.today().toStartOfMonth().addDays(-1);
//
//        Date lastYearLast6MonthStart = Date.today().addYears(-1).addMonths(-6).toStartOfMonth();
//        Date lastYearLastMonthEnd = Date.today().addYears(-1).toStartOfMonth().addDays(-1);
//
//                        List<AggregateResult> aggregateResults = [SELECT
//                                ASI_CRM_SKU__c sku,
//                                ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c subBrand,
//                                ASI_CRM_SG_Customer__c customer,
//                                CALENDAR_YEAR(ASI_TH_CRM_Offtake_G_L_Date__c) year,
//                                CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c) month,
//                                SUM(ASI_CRM_Converted_Qty_9L__c) volume9L
//                        FROM
//                                ASI_TH_CRM_Actual_Offtake__c
//                        WHERE
//                        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake')
//                        AND ASI_CRM_SG_Customer__c <> NULL
//                        AND ASI_CRM_SKU__c <> NULL
//                        AND ASI_CRM_SG_Customer__c IN :customerIds
//                        AND ASI_TH_CRM_Offtake_G_L_Date__c >= :Date.today().addMonths(-18).toStartOfMonth()
//                        AND ASI_TH_CRM_Offtake_G_L_Date__c <= :Date.today().toStartOfMonth().addMonths(1).addDays(-1)
//                        AND (ASI_CRM_SKU__c IN :skuIds
//                        OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c IN :subBrandIds)
//                        GROUP BY
//                                        ASI_CRM_SKU__c,
//                                        ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
//                                        ASI_CRM_SG_Customer__c,
//                                        CALENDAR_YEAR(ASI_TH_CRM_Offtake_G_L_Date__c),
//                                        CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c)
//                        ORDER BY
//                                ASI_CRM_SG_Customer__c,
//                                ASI_CRM_SKU__c,
//                                ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
//                                CALENDAR_YEAR(ASI_TH_CRM_Offtake_G_L_Date__c),
//                                CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c)
//                        ];
//        for(aggregateResults ar : ){
//            string skuId = string.valueOf(ar.get('sku'));
//        }
//
//
//                        List<ASI_TH_CRM_Actual_Offtake__c> offtakes = [
//                                SELECT ASI_CRM_SKU__c, ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_CRM_Converted_Qty_9L__c
//                                FROM ASI_TH_CRM_Actual_Offtake__c
//                                WHERE
//                                ASI_CRM_SG_Customer__c = :customerId
//                                AND ASI_CRM_SKU__c = :skuId
//                                                AND ASI_TH_CRM_Offtake_G_L_Date__c >= :Date.today().addMonths(-12).toStartOfMonth()
//                                                AND ASI_TH_CRM_Offtake_G_L_Date__c <= :Date.today().toStartOfMonth().addMonths(1).addDays(-1)
//
//                        ];
//
//
//        List<AggregateResult> aggregateResults = [SELECT
//                CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c) month,
//                SUM(ASI_CRM_Converted_Qty_9L__c) volume9L
//        FROM
//                ASI_TH_CRM_Actual_Offtake__c
//        WHERE
//        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake')
//        AND ASI_CRM_SG_Customer__c = :customerId
//        AND ASI_TH_CRM_Offtake_G_L_Date__c >= :lastYearSameMonthStart
//        AND ASI_TH_CRM_Offtake_G_L_Date__c <= :lastMonthEnd
//        AND (ASI_CRM_SKU__c IN :skuIds OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c IN :subBrandIds)
//        GROUP BY
//                        CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c)
//        ORDER BY
//                CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c)
//        ];
//
//        System.debug('aggregateResults : ' + aggregateResults);
//
//        List<ASI_TH_CRM_Actual_Offtake__c> offtakes12MonthsAgo = [SELECT Id FROM ASI_TH_CRM_Actual_Offtake__c WHERE
//        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake')
//        AND ASI_CRM_SG_Customer__c = :customerId
//        AND ASI_TH_CRM_Offtake_G_L_Date__c >= :lastYearLast6MonthStart
//        AND ASI_TH_CRM_Offtake_G_L_Date__c <= :lastYearLastMonthEnd
////        AND (ASI_CRM_SKU__c = :skuId OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c = :subBrandId)
//        ];
//
//        Integer offtakesMonth = offtakes12MonthsAgo.isEmpty()? aggregateResults.size() : 12;
//
//        return offtakesMonth == 0 ? 0 : sum(aggregateResults,'volume9L') / offtakesMonth;
//    }

	/*
    @RemoteAction
    public static List<ASI_TH_CRM_Actual_Offtake__c> getAllRelatedOfftakes(String customerName, List<String> skuIds, List<String> subBrandIds) {
        List<ASI_CRM_AccountsAdditionalField__c> accounts = [SELECT Id FROM ASI_CRM_AccountsAdditionalField__c WHERE Name = :customerName AND RecordType.DeveloperName  = 'ASI_CRM_SG_Outlet' LIMIT 1];
        Id customerId = !accounts.isEmpty()? accounts.get(0).Id : '';
        //Id customerId = customerNameMap.get(customerName).Id;


        System.debug('customerId ' + customerId);

        Date lastYearSameMonthStart = Date.today().addYears(-1).toStartOfMonth();
        Date lastMonthEnd = Date.today().toStartOfMonth().addDays(-1);

        Date lastYearLast6MonthStart = Date.today().addYears(-1).addMonths(-6).toStartOfMonth();
        Date lastYearLastMonthEnd = Date.today().addYears(-1).toStartOfMonth().addDays(-1);


        return [SELECT ASI_CRM_SKU__c, ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_TH_CRM_Offtake_G_L_Date__c, ASI_CRM_Converted_Qty_9L__c FROM ASI_TH_CRM_Actual_Offtake__c WHERE
        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake')
        AND ASI_CRM_SG_Customer__c = :customerId
        AND ASI_TH_CRM_Offtake_G_L_Date__c >= :lastYearLast6MonthStart
        AND ASI_TH_CRM_Offtake_G_L_Date__c <= :lastMonthEnd
        AND (ASI_CRM_SKU__c IN :skuIds OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c IN :subBrandIds)
        ];
    }

    @RemoteAction
    public static List<ASI_HK_CRM_Sales_Order_History_Detail__c > getAllRelatedSalesOrderHistories (String customerName, List<String> skuIds, List<String> subBrandIds) {
        List<ASI_CRM_AccountsAdditionalField__c> accounts = [SELECT Id FROM ASI_CRM_AccountsAdditionalField__c WHERE Name = :customerName AND RecordType.DeveloperName  = 'ASI_CRM_SG_Wholesaler' LIMIT 1];
        Id customerId = !accounts.isEmpty()? accounts.get(0).Id : '';
        //Id customerId = customerNameMap.get(customerName).Id;

        Date lastYearSameMonthStart = Date.today().addYears(-1).toStartOfMonth();
        Date lastMonthEnd = Date.today().toStartOfMonth().addDays(-1);

        Date lastYearLast6MonthStart = Date.today().addYears(-1).addMonths(-6).toStartOfMonth();
        Date lastYearLastMonthEnd = Date.today().addYears(-1).toStartOfMonth().addDays(-1);


        return [SELECT ASI_HK_CRM_Product_SKU__c, ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c, ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c, ASI_CRM_Converted_Qty_9L__c FROM ASI_HK_CRM_Sales_Order_History_Detail__c WHERE
        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_HK_CRM_Sales_Order_History_Detail__cASI_CRM_SG_Sales_Order_History_Detail')
        AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c = :customerId
        AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c >= :lastYearLast6MonthStart
        AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c <= :lastMonthEnd
        AND (ASI_HK_CRM_Product_SKU__c IN :skuIds OR ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c IN :subBrandIds)
        ];
    }
	*/
	
    public void getAllRelatedOfftakes() {
		Map<String, String> params               = ApexPages.currentPage().getParameters();
		String customerName                      = params.get('customerName');
        String skuIds                            = params.get('skuIds');
        String subBrandIds                       = params.get('subBrandIds');
		String mechanics                         = params.get('mechanicsJson');
		
		List<string> skuId_list                  = (List<String>) fromJsonString(skuIds, List<String>.class);
		List<string> subBrandId_list             = (List<String>) fromJsonString(subBrandIds, List<String>.class);
		addedPromotionDetailList                 = (List<ASI_HK_CRM_Promotion_Detail__c>) fromJsonString(mechanics, List<ASI_HK_CRM_Promotion_Detail__c>.class);
		returnCustomerName                       = customerName;
        System.debug('customerName' + customerName);
        System.debug('customerNameMap' + customerNameMap);
		Id customerId = customerNameMap.get(customerName).Id;

        list_P12MConsumption_offtake =
		[SELECT ASI_CRM_SKU__c, ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_TH_CRM_Offtake_G_L_Date__c, ASI_CRM_Converted_Qty_9L__c FROM ASI_TH_CRM_Actual_Offtake__c WHERE
        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake')
        AND ASI_CRM_SG_Customer__c = :customerId
        AND ASI_TH_CRM_Offtake_G_L_Date__c >= :lastYearLast6MonthStart
        AND ASI_TH_CRM_Offtake_G_L_Date__c <= :lastMonthEnd
        AND (ASI_CRM_SKU__c IN :skuId_list OR ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c IN :subBrandId_list)
        ];
    }

    public void getAllRelatedSalesOrderHistories () {
        Map<String, String> params               = ApexPages.currentPage().getParameters();
		String customerName                      = params.get('customerName');
        String skuIds                            = params.get('skuIds');
        String subBrandIds                       = params.get('subBrandIds');
		String mechanics                         = params.get('mechanicsJson');
		
		List<string> skuId_list                  = (List<String>) fromJsonString(skuIds, List<String>.class);
		List<string> subBrandId_list             = (List<String>) fromJsonString(subBrandIds, List<String>.class);
		addedPromotionDetailList                 = (List<ASI_HK_CRM_Promotion_Detail__c>) fromJsonString(mechanics, List<ASI_HK_CRM_Promotion_Detail__c>.class);
		returnCustomerName                       = customerName;
		
        Id customerId = customerNameMap.get(customerName).Id;

        list_P12MConsumption_SOH =
		[SELECT ASI_HK_CRM_Product_SKU__c, ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c, ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c, ASI_CRM_Converted_Qty_9L__c FROM ASI_HK_CRM_Sales_Order_History_Detail__c WHERE
        RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_HK_CRM_Sales_Order_History_Detail__cASI_CRM_SG_Sales_Order_History_Detail')
        AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c = :customerId
        AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c >= :lastYearLast6MonthStart
        AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Date__c <= :lastMonthEnd
        AND (ASI_HK_CRM_Product_SKU__c IN :skuId_list OR ASI_HK_CRM_Product_SKU__r.ASI_MFM_Sub_brand__c IN :subBrandId_list)
        ];
    }
	
    /***************
    Data Retrievement Function
    ***************/
    private ASI_HK_CRM_Promotion__c retrievePromotion(Id promotionId) {
        String query = 'SELECT Id, ASI_CRM_Promotion_Plan__c, ASI_CRM_Promotion_Plan__r.ASI_CRM_Promotion_Period_Month__c, '
					 + 'ASI_CRM_Promotion_Plan__r.ASI_CRM_Enrollment_Cut_off_Date__c, ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c, '
					 + 'ASI_HK_CRM_Status__c, '
					 + 'OwnerId, RecordType.DeveloperName, ASI_CRM_Promotion_Plan__r.RecordType.DeveloperName '
                     + 'FROM ASI_HK_CRM_Promotion__c '
                     + 'WHERE Id = :promotionId ';
        
        List<ASI_HK_CRM_Promotion__c> promotionList = (List<ASI_HK_CRM_Promotion__c>) Database.query(query);
        return promotionList.size() > 0 ? promotionList.get(0) : null;
    }
    
    private List<ASI_HK_CRM_Promotion_Detail__c> retrievePromotionDetailList(Id promotionId) {
        String query = 'SELECT Id, ASI_CRM_Promotion_Mechanic__c, ASI_CRM_SG_Customer__c, ASI_CRM_Target_Qty_Bottle__c, ASI_CRM_SG_Customer__r.Name ' 
           + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_Bottle_Qty__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Ad_hoc_Cash__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_Qty__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_Unit__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher_Value_Cash__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_IGC_Cost_Case_Promotional__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Other_in_Kind_Cash__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotion_Plan__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_ROI__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_RTM_WS_Price_Bottle_Additional__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_RTM_WS_Price_Bottle_Promotional__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Trade_Deal_Bottle_Qty__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.Name, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_Sub_brand__r.Name, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__r.Name, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__r.Name '
                     + ', ASI_CRM_P12M_Avg_Consumption_9L__c, ASI_CRM_ActualConsumption_9L__c '
					 + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Packaging_Size_Promotional__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Bottle_Size_Promotional__c '
                     + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Remark__c '
					 + ', ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Mechanic_Description__c '
					 + 'FROM ASI_HK_CRM_Promotion_Detail__c '
                     + 'WHERE ASI_HK_CRM_Promotion__c = :promotionId ';
        
        return (List<ASI_HK_CRM_Promotion_Detail__c>) Database.query(query);
    }
    
    private List<ASI_CRM_Promotion_Mechanic__c> retrievePromotionMechanicList(Id promotionPlanId) {
        String query = 'SELECT Id, Name, ASI_CRM_Additional_SKU_POSM__c, ASI_CRM_Remark__c '
                     + ', ASI_CRM_Additional_SKU_Bottle_Qty__c, ASI_CRM_Ad_hoc_Cash__c, ASI_CRM_Buy_Qty__c '
                     + ', ASI_CRM_Buy_Unit__c, ASI_CRM_Gift_Voucher__c, ASI_CRM_Gift_Voucher_Value_Cash__c '
                     + ', ASI_CRM_IGC_Cost_Case_Promotional__c, ASI_CRM_Other_in_Kind_Cash__c, ASI_CRM_Promotional_SKU__c '
                     + ', ASI_CRM_Promotional_Sub_brand__c, ASI_CRM_Promotion_Plan__c, ASI_CRM_ROI__c '
                     + ', ASI_CRM_RTM_WS_Price_Bottle_Additional__c, ASI_CRM_RTM_WS_Price_Bottle_Promotional__c, ASI_CRM_Trade_Deal_Bottle_Qty__c '
                     + ', ASI_CRM_Promotional_SKU__r.Name, ASI_CRM_Promotional_Sub_brand__r.Name, ASI_CRM_Additional_SKU_POSM__r.Name, ASI_CRM_Gift_Voucher__r.Name '
					 + ', ASI_CRM_Packaging_Size_Promotional__c, ASI_CRM_Bottle_Size_Promotional__c '
					 + ', ASI_CRM_Mechanic_Description__c '
                     + ', RecordTypeId, RecordType.DeveloperName '
                     + 'FROM ASI_CRM_Promotion_Mechanic__c '
                     + 'WHERE ASI_CRM_Promotion_Plan__c = :promotionPlanId ';
        
        return (List<ASI_CRM_Promotion_Mechanic__c>) Database.query(query);
    }
    
    private List<ASI_CRM_AccountsAdditionalField__c> retrieveCustomerList(String recordType, Id ownerId) {
        String query = 'SELECT Id, Name, ASI_CRM_CN_Parent_Outlet__r.Name '
                     + 'FROM ASI_CRM_AccountsAdditionalField__c '
                     + 'WHERE RecordType.DeveloperName = :recordType '
                     + 'AND ASI_CRM_Active__c = true '
                     + 'AND ASI_CRM_Outlet_Type__c <> :OPEN_OUTLET '
                     + 'AND OwnerId = :ownerId ' 
                     + 'AND ASI_CRM_CN_Parent_Outlet__c = null ';
        return (List<ASI_CRM_AccountsAdditionalField__c>) Database.query(query);
    }


    /***************
  Tools Function
  ***************/
    private String toJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private Object fromJsonString(String jsonString, System.Type apexType) {
        if(String.isBlank(jsonString)) {
            return null;
        }
        return System.JSON.deserialize(jsonString, apexType);
    }


    public static Decimal sum(List<SObject> records, String field){
        Decimal sum = 0;
        for (SObject sobj : records) {
            sum += (Decimal) sobj.get(field);
        }
        return sum;
    }
}