/*********************************************************************************
 * Name: ASI_CRM_SG_ManagePromotionItemCtrl
 * Description: Controller class for manage Promotion Plan Item (ASI_CRM_SG_ManagePromotionItemPage)
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 22/03/2018       Hugo Cheung             Created          
*/
public class ASI_CRM_SG_ManagePromotionItemCtrl {
    //Object Record Type Developer Name
    private final static String SKU_RECORD_TYPE      = 'ASI_CRM_SG_SKU';
    private final static String GIFT_RECORD_TYPE     = 'ASI_CRM_SG_Gift_Voucher';
    private final static String SUBBRAND_RECORD_TYPE = 'ASI_CRM_SG_Sub_brand';
    private final static String OUTLET_RECORD_TYPE         = 'ASI_CRM_SG_Outlet';
    private final static String WHOLESALER_RECORD_TYPE     = 'ASI_CRM_SG_Wholesaler';
    private final static String PROMOTIONOUTLET_RECORD_TYPE         = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Outlet_Promotion_Plan');
    private final static String PROMOTIONWHOLESALER_RECORD_TYPE     = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan');
    private final static String PROMOTION_SHARINGREASON     = 'ASI_CRM_SG_Promotion__c';
    
   	//Public Data Storage Parameters
    public ASI_CRM_Promotion_Plan__c promotionPlan {get; set;}
	public Boolean isReadOnly {get; set;}
    
    //Private Data Storage Parameters
    private List<ASI_CRM_Promotion_Mechanic__c> promotionMechanicList;
    private Map<String, ASI_MFM_SKU_Code__c> promotionalSKUMap;
    private Map<String, ASI_MFM_SKU_Code__c> promotionalSKUMap_noSpace;
    private Map<String, ASI_MFM_SKU_Code__c> additionalSKUMap;
    private Map<String, ASI_MFM_SKU_Code__c> additionalSKUMap_noSpace;
    private Map<String, ASI_MFM_SKU_Code__c> giftVoucherSKUMap;
    private Map<String, ASI_MFM_SKU_Code__c> giftVoucherSKUMap_noSpace;
    private Map<String, ASI_MFM_Sub_brand__c> subBrandMap;
    private Map<String, ASI_MFM_Sub_brand__c> subBrandMap_noSpace;
    private List<ASI_HK_CRM_Promotion__c> promotionList;
    private Map<String, User> salesNameMap;
    
    //Data Stroage => JSON String for VF Page
    public String promotionMechanicListJson {get {return toJsonString(promotionMechanicList);}}
    public String promotionListJson {get {return toJsonString(promotionList);}}
    
    //Object Picklist Value Map
    private Map<String, String> buyUnitMap {get; set;}
    
    //Picklist Value Map => JSON String for VF Page
    public String buyUnitMapJson {get {return toJsonString(buyUnitMap);}}
    
    //Auto Complete Value Map => JSON String for VF Page
    public String promotionalSKUListJson {get {return toJsonString(promotionalSKUMap.keySet());}}
    public String additionalSKUListJson  {get {return toJsonString(additionalSKUMap.keySet());}}
    public String giftVoucherSKUListJson {get {return toJsonString(giftVoucherSKUMap.keySet());}}
    public String subBrandListJson       {get {return toJsonString(subBrandMap.keySet());}}
    public String salesNameListJson {get {return toJsonString(salesNameMap.keySet());}}
    
    //Page Parameters
    public String promotionMechanicRecordTypeId {get {return Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Mechanic__cASI_CRM_SG_Promotion_Mechanic');}}
    public String promotionRecordTypeId {get {return Global_RecordTypeCache.getRTId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion');}}
	
	public String RETURN_ROWID {get {return PRIVATE_ROWID;}}
	public String RETURN_FIELDNAME {get {return PRIVATE_FIELDNAME;}}
	public String RETURN_PRICECOSTWRAPPER {get {return toJsonString(PRIVATE_PRICECOSTWRAPPER);}}
    
    //Other Parameters
    private final static String IS_QUICK_SAVE                           = 'isQuickSave';
    private final static String UPSERT_PROMOTION_MECHANIC_LIST_JSON     = 'upsertPromotionMechanicListJson';
    private final static String DELETE_PROMOTION_MECHANIC_ID_LIST_JSON  = 'deletePromotionMechanicIdListJson';
    private final static String UPSERT_PROMOTION_LIST_JSON     = 'upsertpromotionListJson';
    private final static String DELETE_PROMOTION_ID_LIST_JSON  = 'deletePromotionIdListJson';
	private final static String PARA_FIELDNAME = 'fieldName';
	private final static String PARA_ROWID = 'rowId';
	private final static String PARA_SKUNAME = 'skuName';
	private final static String FIELD_PROMOTIONALSKU = 'ASI_CRM_Promotional_SKU__c';
	private final static String FIELD_ADDITIONALSKU = 'ASI_CRM_Additional_SKU_POSM__c';
	private final static String FIELD_GIFTVOUCHER = 'ASI_CRM_Gift_Voucher__c';
	private final static String STANDARD_PRICE = 'Standard Price';
	private final static String PRICE_RECORDTYPE_IGC = 'ASI_CRM_SG_IGC';
	private final static String PRICE_RECORDTYPE_PRSWS = 'ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle';
	private string PRIVATE_ROWID;
	private string PRIVATE_FIELDNAME;
	private SKUPriceWrapper PRIVATE_PRICECOSTWRAPPER;
	private map<string, SKUPriceWrapper> map_skuId_priceWrapper = new map<string, SKUPriceWrapper>();
	
	private static Set<String> SKU_PRICE_RECORD_TYPE = new Set<String> {
        PRICE_RECORDTYPE_IGC,
        PRICE_RECORDTYPE_PRSWS
    };
	
    
    public ASI_CRM_SG_ManagePromotionItemCtrl(ApexPages.StandardController standardController) {
		Map < String, String > pageParameters = ApexPages.currentPage().getParameters();
        String promotionPlanId = pageParameters.get('id');
        isReadOnly = Boolean.valueOf(pageParameters.containsKey('isReadOnly') ? pageParameters.get('isReadOnly') : 'true');
        init(promotionPlanId);
    }
    
    //Initialize controller
    private void init(String promotionPlanId) {
        if(String.isBlank(promotionPlanId)) return;
        
        //Init Page Config
        promotionalSKUMap = new Map<String, ASI_MFM_SKU_Code__c>();
        additionalSKUMap  = new Map<String, ASI_MFM_SKU_Code__c>();
        giftVoucherSKUMap = new Map<String, ASI_MFM_SKU_Code__c>();
        subBrandMap       = new Map<String, ASI_MFM_Sub_brand__c>();
        promotionalSKUMap_noSpace = new Map<String, ASI_MFM_SKU_Code__c>();
        additionalSKUMap_noSpace  = new Map<String, ASI_MFM_SKU_Code__c>();
        giftVoucherSKUMap_noSpace = new Map<String, ASI_MFM_SKU_Code__c>();
        subBrandMap_noSpace       = new Map<String, ASI_MFM_Sub_brand__c>();
        salesNameMap      = new Map<String, User>();
        
        buyUnitMap = retrievePicklistValues(ASI_CRM_Promotion_Mechanic__c.ASI_CRM_Buy_Unit__c.getDescribe());
        
		Set<string> set_skuIdWithIGC   = retrieveSKUwithPrice(PRICE_RECORDTYPE_IGC);
		Set<string> set_skuIdWithPRSWS = retrieveSKUwithPrice(PRICE_RECORDTYPE_PRSWS);
		
        for(ASI_MFM_SKU_Code__c sku : retrieveSKUList(SKU_RECORD_TYPE, false)) {
            if(set_skuIdWithIGC.contains(sku.Id) && set_skuIdWithPRSWS.contains(sku.Id)){
				promotionalSKUMap.put(sku.Name, sku);
				promotionalSKUMap_noSpace.put(sku.Name.replaceAll( '\\s+', ''), sku);
			}
        }
        
        for(ASI_MFM_SKU_Code__c sku : retrieveSKUList(SKU_RECORD_TYPE, true)) {
            if(sku.ASI_HK_CRM_IsPOSProduct__c ||
				(set_skuIdWithIGC.contains(sku.Id) && set_skuIdWithPRSWS.contains(sku.Id))
			){
				additionalSKUMap.put(sku.Name, sku);
				additionalSKUMap_noSpace.put(sku.Name.replaceAll( '\\s+', ''), sku);
			}
        }
        
        for(ASI_MFM_SKU_Code__c sku : retrieveSKUList(GIFT_RECORD_TYPE, true)) {
            giftVoucherSKUMap.put(sku.Name, sku);
			giftVoucherSKUMap_noSpace.put(sku.Name.replaceAll( '\\s+', ''), sku);
        }
        
        for(ASI_MFM_Sub_brand__c subbrand : retrieveSubBrand(SUBBRAND_RECORD_TYPE)) {
            subBrandMap.put(subbrand.Name, subbrand);
			subBrandMap_noSpace.put(subbrand.Name.replaceAll( '\\s+', ''), subbrand);
        }
        
        //Init Record
        promotionPlan         = retrievePromotionPlan(promotionPlanId);
        promotionMechanicList = retrievePromotionMechanicList(promotionPlanId);
        promotionList         = retrievepromotionList(promotionPlanId);		
		
		string customerDeveloperName = promotionPlan.recordTypeId == PROMOTIONOUTLET_RECORD_TYPE ? OUTLET_RECORD_TYPE : WHOLESALER_RECORD_TYPE;
        for(User u : retrieveUserList(customerDeveloperName)) {
            salesNameMap.put(u.Name, u);
        }
    }
    
    /***************
    Page Function
    ***************/
    public PageReference savePromotionMechanic() {
        Map<String, String> params              = ApexPages.currentPage().getParameters();
        Boolean isQuickSave                     = String.isBlank(params.get(IS_QUICK_SAVE)) ? false : Boolean.valueOf(params.get(IS_QUICK_SAVE));
	    String upsertPromotionMechanicListJson  = params.get(UPSERT_PROMOTION_MECHANIC_LIST_JSON);
	    String removePromotionMechanicIdListJson  = params.get(DELETE_PROMOTION_MECHANIC_ID_LIST_JSON);
	    String upsertpromotionListJson  = params.get(UPSERT_PROMOTION_LIST_JSON);
	    String removePromotionIdListJson  = params.get(DELETE_PROMOTION_ID_LIST_JSON);
        
		// handle promotion mechanics
        List<ASI_CRM_Promotion_Mechanic__c> upsertPromotionMechanicList;
        List<String> removePromotionMechanicIdList;
        
        upsertPromotionMechanicList   = (List<ASI_CRM_Promotion_Mechanic__c>) fromJsonString(upsertPromotionMechanicListJson, List<ASI_CRM_Promotion_Mechanic__c>.class);
        removePromotionMechanicIdList = (List<String>) fromJsonString(removePromotionMechanicIdListJson, List<String>.class);
        
        if(removePromotionMechanicIdList != null && removePromotionMechanicIdList.size() > 0) {
        	List<ASI_CRM_Promotion_Mechanic__c> removeDataList = new List<ASI_CRM_Promotion_Mechanic__c>();
            for(String removeDataId : removePromotionMechanicIdList) {
                removeDataList.add(new ASI_CRM_Promotion_Mechanic__c(Id = removeDataId));
            }
            Database.delete(removeDataList);
        }
        
        if(upsertPromotionMechanicList != null && upsertPromotionMechanicList.size() > 0) {
        	List<ASI_CRM_Promotion_Mechanic__c> insertDataList = new List<ASI_CRM_Promotion_Mechanic__c>();
            List<ASI_CRM_Promotion_Mechanic__c> updateDataList = new List<ASI_CRM_Promotion_Mechanic__c>();
            
            for(ASI_CRM_Promotion_Mechanic__c upsertData : upsertPromotionMechanicList) {
                if(upsertData.ASI_CRM_Promotional_SKU__c != null && 
					promotionalSKUMap_noSpace.containsKey(String.valueOf(upsertData.ASI_CRM_Promotional_SKU__c).replaceAll( '\\s+', ''))
				)
                    upsertData.ASI_CRM_Promotional_SKU__c = promotionalSKUMap_noSpace.get(String.valueOf(upsertData.ASI_CRM_Promotional_SKU__c).replaceAll( '\\s+', '')).Id;
                
                if(upsertData.ASI_CRM_Additional_SKU_POSM__c != null && 
					additionalSKUMap_noSpace.containsKey(String.valueOf(upsertData.ASI_CRM_Additional_SKU_POSM__c).replaceAll( '\\s+', ''))
				) 
                    upsertData.ASI_CRM_Additional_SKU_POSM__c = additionalSKUMap_noSpace.get(String.valueOf(upsertData.ASI_CRM_Additional_SKU_POSM__c).replaceAll( '\\s+', '')).Id;
                
                if(upsertData.ASI_CRM_Gift_Voucher__c != null && 
					giftVoucherSKUMap_noSpace.containsKey(String.valueOf(upsertData.ASI_CRM_Gift_Voucher__c).replaceAll( '\\s+', ''))
				)
                    upsertData.ASI_CRM_Gift_Voucher__c = giftVoucherSKUMap_noSpace.get(String.valueOf(upsertData.ASI_CRM_Gift_Voucher__c).replaceAll( '\\s+', '')).Id;
                    
                if(upsertData.ASI_CRM_Promotional_Sub_brand__c != null && 
					subBrandMap_noSpace.containsKey(String.valueOf(upsertData.ASI_CRM_Promotional_Sub_brand__c).replaceAll( '\\s+', ''))
				)
                    upsertData.ASI_CRM_Promotional_Sub_brand__c = subBrandMap_noSpace.get(String.valueOf(upsertData.ASI_CRM_Promotional_Sub_brand__c).replaceAll( '\\s+', '')).Id;
                    
                if(String.isBlank(upsertData.Id)) 
                    insertDataList.add(upsertData);
                else 
                    updateDataList.add(upsertData); 
            }
            
            if(insertDataList.size() > 0) Database.insert(insertDataList);
            if(updateDataList.size() > 0) Database.update(updateDataList);
        }
		
		// handle promotions
		
        List<ASI_HK_CRM_Promotion__c> upsertpromotionList;
        List<String> removePromotionIdList;
        
        upsertpromotionList   = (List<ASI_HK_CRM_Promotion__c>) fromJsonString(upsertpromotionListJson, List<ASI_HK_CRM_Promotion__c>.class);
        removePromotionIdList = (List<String>) fromJsonString(removePromotionIdListJson, List<String>.class);
        
        if(removePromotionIdList != null && removePromotionIdList.size() > 0) {
        	List<ASI_HK_CRM_Promotion__c> removeDataList = new List<ASI_HK_CRM_Promotion__c>();
            for(String removeDataId : removePromotionIdList) {
                removeDataList.add(new ASI_HK_CRM_Promotion__c(Id = removeDataId));
            }
            Database.delete(removeDataList);
        }
        
		List<ASI_HK_CRM_Promotion__c> insertDataList = new List<ASI_HK_CRM_Promotion__c>();
		List<ASI_HK_CRM_Promotion__c> updateDataList = new List<ASI_HK_CRM_Promotion__c>();
        if(upsertpromotionList != null && upsertpromotionList.size() > 0) {
            
            for(ASI_HK_CRM_Promotion__c upsertData : upsertpromotionList) {
                if(salesNameMap.containsKey(upsertData.ownerid))
                    upsertData.ownerid = salesNameMap.get(upsertData.ownerid).Id;
				
                if(String.isBlank(upsertData.Id)) 
                    insertDataList.add(upsertData);
                else 
                    updateDataList.add(upsertData); 
            }
            
            if(insertDataList.size() > 0) Database.insert(insertDataList);
            if(updateDataList.size() > 0) Database.update(updateDataList);
        }
		
		// handle manual sharing of promotion
		set<string> set_finalPromotionId = new set<string>();
		List<ASI_HK_CRM_Promotion__Share> newPromotionShareList = new List<ASI_HK_CRM_Promotion__Share>();
		List<ASI_CRM_Promotion_Plan__Share> newPromotionPlanShareList = new List<ASI_CRM_Promotion_Plan__Share>();
		for(ASI_HK_CRM_Promotion__c p : insertDataList){
			set_finalPromotionId.add(p.id);
			newPromotionShareList.add((ASI_HK_CRM_Promotion__Share)createCustomShare(p.id, promotionPlan.ownerid, 'ASI_HK_CRM_Promotion', 'Edit', PROMOTION_SHARINGREASON));
			newPromotionPlanShareList.add((ASI_CRM_Promotion_Plan__Share)createCustomShare(promotionPlan.id, p.ownerid, 'ASI_CRM_Promotion_Plan', 'Read', PROMOTION_SHARINGREASON));
		}
		for(ASI_HK_CRM_Promotion__c p : updateDataList){
			set_finalPromotionId.add(p.id);
			newPromotionShareList.add((ASI_HK_CRM_Promotion__Share)createCustomShare(p.id, promotionPlan.ownerid, 'ASI_HK_CRM_Promotion', 'Edit', PROMOTION_SHARINGREASON));
			newPromotionPlanShareList.add((ASI_CRM_Promotion_Plan__Share)createCustomShare(promotionPlan.id, p.ownerid, 'ASI_CRM_Promotion_Plan', 'Read', PROMOTION_SHARINGREASON));
		}
		List<ASI_HK_CRM_Promotion__Share> promotionShareList = [select id from ASI_HK_CRM_Promotion__Share where parentId In: set_finalPromotionId and RowCause = :PROMOTION_SHARINGREASON];
		List<ASI_CRM_Promotion_Plan__Share> promotionPlanShareList = [select id from ASI_CRM_Promotion_Plan__Share where parentId =: promotionPlan.id and RowCause = :PROMOTION_SHARINGREASON];
		if(promotionShareList.size()>0) delete promotionShareList;
		if(promotionPlanShareList.size()>0) delete promotionPlanShareList;
		if(newPromotionShareList.size()>0) insert newPromotionShareList;
		if(newPromotionPlanShareList.size()>0) insert newPromotionPlanShareList;
        
        // after handle all
        if(isQuickSave) {
			promotionMechanicList = retrievePromotionMechanicList(promotionPlan.Id);
			promotionList         = retrievepromotionList(promotionPlan.Id);	
        	return null;
        } else {
        	PageReference pageRef = new PageReference('/' + promotionPlan.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    public void getPriceCost() {
        Map<String, String> params               = ApexPages.currentPage().getParameters();
        String fieldName                         = params.get(PARA_FIELDNAME);
        String rowId                             = params.get(PARA_ROWID);
        String skuName                           = params.get(PARA_SKUNAME);
		Map<String, ASI_MFM_SKU_Code__c> map_SKU = new Map<String, ASI_MFM_SKU_Code__c>();
		
		if(fieldName == FIELD_PROMOTIONALSKU){
			map_SKU = promotionalSKUMap;
		} else
		if(fieldName == FIELD_ADDITIONALSKU){
			map_SKU = additionalSKUMap;
		} else
		if(fieldName == FIELD_GIFTVOUCHER){
			map_SKU = giftVoucherSKUMap;
		}
		ASI_MFM_SKU_Code__c sku = map_SKU.containsKey(skuName) ? map_SKU.get(skuName) : new ASI_MFM_SKU_Code__c();
		string skuId = sku.Id;
		
		Set<string> set_rtName = new Set<string>();
		SKUPriceWrapper w; 
		if(map_skuId_priceWrapper.containsKey(skuId)){
			w = map_skuId_priceWrapper.get(skuId);
		}else{
			w = new SKUPriceWrapper(sku);
			if(fieldName == FIELD_GIFTVOUCHER){
				w.addSKUPrice(STANDARD_PRICE, new ASI_CRM_MY_SKUPriceCost__c(ASI_CRM_Price__c = sku.ASI_CRM_Standard_Cost__c));
			} else {
				for(ASI_CRM_MY_SKUPriceCost__c p : retrieveSKUPrice(skuId)){
					if(!set_rtName.contains(p.recordType.developerName)){
						w.addSKUPrice(p.recordType.developerName, p);
						set_rtName.add(p.recordType.developerName);
					}
				}
			}
			map_skuId_priceWrapper.put(skuId, w);
		}
		PRIVATE_PRICECOSTWRAPPER = w;
		PRIVATE_FIELDNAME = fieldName;
		PRIVATE_ROWID = rowId;
    }
	
    public PageReference cancel() {
    	PageReference pageRef = new PageReference('/' + promotionPlan.Id);
	    pageRef.setRedirect(true);
	    return pageRef;
    }
    
    /***************
    Data Retrievement Function
    ***************/
    private ASI_CRM_Promotion_Plan__c retrievePromotionPlan(Id promotionPlanId) {
        String query = 'SELECT Id, Name, ownerid, ASI_CRM_Approval_Cut_off_Date__c ' 
                     + ', ASI_CRM_Description__c, ASI_CRM_End_Date__c, ASI_CRM_Enrollment_Cut_off_Date__c '
                     + ', ASI_CRM_Promotion_Period_Month__c, ASI_CRM_Start_Date__c, ASI_CRM_Status__c '
                     + ', RecordTypeId, RecordType.DeveloperName '
                     + 'FROM ASI_CRM_Promotion_Plan__c '
                     + 'WHERE Id = :promotionPlanId ';
        
        List<ASI_CRM_Promotion_Plan__c> promotionPlanList = (List<ASI_CRM_Promotion_Plan__c>) Database.query(query);
        return promotionPlanList.size() > 0 ? promotionPlanList.get(0) : null;
    }
    
    private List<ASI_CRM_Promotion_Mechanic__c> retrievePromotionMechanicList(Id promotionPlanId) {
        String query = 'SELECT Id, Name, ASI_CRM_Additional_SKU_POSM__c, ASI_CRM_Target_Qty_Bottle__c, ASI_CRM_Remark__c '
                     + ', ASI_CRM_Additional_SKU_Bottle_Qty__c, ASI_CRM_Ad_hoc_Cash__c, ASI_CRM_Buy_Qty__c '
                     + ', ASI_CRM_Buy_Unit__c, ASI_CRM_Gift_Voucher__c, ASI_CRM_Gift_Voucher_Value_Cash__c '
                     + ', ASI_CRM_IGC_Cost_Case_Promotional__c, ASI_CRM_Other_in_Kind_Cash__c, ASI_CRM_Promotional_SKU__c '
                     + ', ASI_CRM_Promotional_Sub_brand__c, ASI_CRM_Promotion_Plan__c, ASI_CRM_ROI__c '
                     + ', ASI_CRM_RTM_WS_Price_Bottle_Additional__c, ASI_CRM_RTM_WS_Price_Bottle_Promotional__c, ASI_CRM_Trade_Deal_Bottle_Qty__c '
                     + ', ASI_CRM_Promotional_SKU__r.Name, ASI_CRM_Promotional_Sub_brand__r.Name, ASI_CRM_Additional_SKU_POSM__r.Name, ASI_CRM_Gift_Voucher__r.Name '
                     + ', ASI_CRM_Packaging_Size_Promotional__c, ASI_CRM_Bottle_Size_Promotional__c, ASI_CRM_Packaging_Size_Additional__c, ASI_CRM_Bottle_Size_Additional__c '
					 + ', ASI_CRM_Mechanic_Description__c '
                     + ', RecordTypeId, RecordType.DeveloperName '
                     + 'FROM ASI_CRM_Promotion_Mechanic__c '
                     + 'WHERE ASI_CRM_Promotion_Plan__c = :promotionPlanId '
                     + 'Order by Id ';
        
        return (List<ASI_CRM_Promotion_Mechanic__c>) Database.query(query);
    }
    
    private List<ASI_MFM_SKU_Code__c> retrieveSKUList(String recordType, Boolean isPOSProduct) {
    	String query = 'SELECT Id, Name, ASI_CRM_Standard_Cost__c, ASI_HK_CRM_IsPOSProduct__c '
                     + ', ASI_HK_CRM_Packaging_Size__c, ASI_HK_CRM_Std_Bottle_Size__c '
                     + 'FROM ASI_MFM_SKU_Code__c '
                     + 'WHERE RecordType.DeveloperName = :recordType '
                     + 'AND ASI_HK_CRM_Active__c = true ';
        
       if(isPOSProduct == false) 
           query += 'AND ASI_HK_CRM_IsPOSProduct__c = false ';
        
        return (List<ASI_MFM_SKU_Code__c>) Database.query(query);
    }
    
    private List<ASI_MFM_Sub_brand__c> retrieveSubBrand(String recordType) {
        String query = 'SELECT Id, Name '
                     + 'FROM ASI_MFM_Sub_brand__c ' 
                     + 'WHERE RecordType.DeveloperName = :recordType ';
        
        return (List<ASI_MFM_Sub_brand__c>) Database.query(query);
    }
        
    private List<ASI_HK_CRM_Promotion__c> retrievePromotionList(Id promotionId) {
        String query = 'SELECT Id, OwnerId, Owner.Name '
                     + 'FROM ASI_HK_CRM_Promotion__c '
                     + 'WHERE ASI_CRM_Promotion_Plan__c = :promotionId ';
        
        return (List<ASI_HK_CRM_Promotion__c>) Database.query(query);
    }
    
    private List<User> retrieveUserList(String recordType) {
    	String query = 'SELECT Id, Name '
                     + 'FROM User '
                     + 'WHERE id in '
					 + ' (select ownerid from ASI_CRM_AccountsAdditionalField__c where RecordType.DeveloperName = :recordType and ASI_CRM_Active__c = true) ';
        
        return (List<User>) Database.query(query);
    }
	
	private List < ASI_CRM_MY_SKUPriceCost__c > retrieveSKUPrice(String skuId) {
        Date promotionStartDate = promotionPlan.ASI_CRM_Start_Date__c;
		String query = 'SELECT ASI_CRM_SKU__c, ASI_CRM_Price__c, ASI_CRM_Cost__c, ASI_CRM_EffectiveDate__c' +
            ', RecordType.DeveloperName ' +
            'FROM ASI_CRM_MY_SKUPriceCost__c ' +
            'WHERE RecordType.DeveloperName in :SKU_PRICE_RECORD_TYPE ' +
            'AND ASI_CRM_EffectiveDate__c != NULL ' +
            'AND ASI_CRM_SKU__c = :skuId ';
        query += 'AND ASI_CRM_EffectiveDate__c <= :promotionStartDate ';
        query += 'Order By ASI_CRM_EffectiveDate__c DESC';
		system.debug(Database.query(query));
        return (List < ASI_CRM_MY_SKUPriceCost__c > ) Database.query(query);
    }
	
	private Set<string> retrieveSKUwithPrice(string recordType){
		set<string> set_skuId = new set<string>();
		for(AggregateResult ar : [
			select
				ASI_CRM_SKU__c skuId
			from 
				ASI_CRM_MY_SKUPriceCost__c
			where 
				recordType.DeveloperName = :recordType and
				ASI_CRM_EffectiveDate__c != NULL and
				ASI_CRM_SKU__r.recordtype.developername = :SKU_RECORD_TYPE
			group by
				ASI_CRM_SKU__c
			order by 
				ASI_CRM_SKU__c
		]){
			string skuId = string.valueOf(ar.get('skuId'));
			set_skuId.add(skuId);
		}
		return set_skuId;
	}
    
    /***************
	Tools Function
	***************/
    private Map<String, String> retrievePicklistValues(Schema.DescribeFieldResult fieldResult) {
  		Map<String, String> picklistValueMap = new Map<String, String>();

  		List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
  		for(Schema.PicklistEntry picklistEntry : picklistEntryList) {
    		picklistValueMap.put(picklistEntry.getLabel(), picklistEntry.getValue());
    	}

    	return picklistValueMap;
  	}
    
    private String toJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private Object fromJsonString(String jsonString, System.Type apexType) {
        if(String.isBlank(jsonString)) {
            return null;
        }
        return System.JSON.deserialize(jsonString, apexType);
    }
	
	//Wrapper Class
	private class SKUPriceWrapper {
        private ASI_MFM_SKU_Code__c sku {
            get;
            set;
        }
        private Map < String, ASI_CRM_MY_SKUPriceCost__c > skuPriceRecordTypeMap {
            get;
            set;
        }

        private SKUPriceWrapper(ASI_MFM_SKU_Code__c sku) {
            this.sku = sku;
            this.skuPriceRecordTypeMap = new Map < String, ASI_CRM_MY_SKUPriceCost__c > ();
        }

        private void addSKUPrice(String recordTypeName, ASI_CRM_MY_SKUPriceCost__c skuPrice) {
            if (!skuPriceRecordTypeMap.containsKey(recordTypeName)) {
                skuPriceRecordTypeMap.put(recordTypeName, skuPrice);
            }
        }

        private Boolean checkIsValidRecord() {
            return skuPriceRecordTypeMap.size() == 7;
        }
    }
	
	public static SObject createCustomShare(String p, String userOrGroupId, String objectName, String accessLevel, String reason){
		Schema.SObjectType customShareType = Schema.getGlobalDescribe().get(objectName + '__Share');
		SObject customShare = customShareType.newSObject();		
		customShare.put('ParentId', p);
		customShare.put('AccessLevel', accessLevel);	
		customShare.put('UserOrGroupId', userOrGroupId);
		customShare.put('RowCause', reason);
		return customShare;
    } 

}