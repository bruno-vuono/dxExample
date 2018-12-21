public without sharing class ASI_CRM_CN_PriceAndDiscountCtrller {
//Version 0.0.1
//Last modified: 20130813 00:32
    
    //The SalesOrderItem do not allow to added if not within this range
    
    /*private static final Set<String> STATUS_ALLOW_EDIT = new Set<String>{
        'Draft',
        'SA Rejected',
        'Supervisor Rejected'
    };*/

    // TODO: Centralize the record type developer names
    private static final String RTDEVNAME_SKU = 'ASI_CRM_CN_CRM_Item_Group';
    private static final String RTDEVNAME_SB = 'ASI_FOC_CN_Sub_brand';
    private static final String RTDEVNAME_CUST_PD_PRICE = 'ASI_CRM_CN_T1_Price';
    //private static final Set<String> RTDEVNAME_ACCT_HAVE_CUST_PRICE = ASI_HK_CRM_AccountGenerator.RTDEVNAME_ACCT_HAVE_CUST_PRICE;
    //private static final Set<String> RTDEVNAME_ACCT_IS_HK_LUX = ASI_HK_CRM_AccountGenerator.RTDEVNAME_ACCT_IS_HK_LUX ;
    
    private static final String ACCT_TYPE_EXIST = 'exist';
    private static final String ACCT_TYPE_POTENTIAL = 'potential';
    
    //public static Set<String> promotionIDSet = new Set<String>();
    
    public String soHeaderId { get; private set; }
    public String acctId { get; private set; }
    public String acctDAId { get; private set; }  //Get DA Account Abel
    public String pageTitle { get; private set; }
    public Boolean allowEdit { get; private set; }
    public String ACCT_TYPE_EXIST_DISPLAY { get { return ACCT_TYPE_EXIST; } private set; }
    public String ACCT_TYPE_POTENTIAL_DISPLAY { get { return ACCT_TYPE_POTENTIAL; } private set; }
    public String acctType { get; private set; }
    public Static Boolean isOrderFormExist { get; set; }
    public Boolean useCustPrice { get; private set; }
    public List<List<String>> sbSearchOptionsNormal { get; set; }
    public List<List<String>> sbSearchOptionsPOS { get; set; }
    private static ASI_CRM_Price_And_Discount__c soHeader;
    Static List<ASI_CRM_CN_T1_Price__c> t1Price = new list<ASI_CRM_CN_T1_Price__c>([SELECT id, ASI_CRM_CN_T1_Price__c, ASI_CRM_CN_Item_Group__c FROM ASI_CRM_CN_T1_Price__c WHERE recordType.developerName = : RTDEVNAME_CUST_PD_PRICE AND ASI_CRM_CN_Effective_Date__c <= :date.today() order by ASI_CRM_CN_Effective_Date__c desc]);
    
    public ASI_CRM_CN_PriceAndDiscountCtrller(ApexPages.StandardSetController stdSetController) {
        //this.allowEdit = true;
        
        //check is Order Form Exist
        this.soHeaderId = ApexPages.currentPage().getParameters().get('id');
        
        //Map<id, Decimal> mapLineItemPrice = new map<id, Decimal>();
        Map<id, id> mapOrderForm = new Map<id, id>();
        
        soHeader = [SELECT Id, ASI_CRM_Customer__c, ASI_CRM_RTD__c, RecordType.DeveloperName, (SELECT ASI_CRM_New_Price_BT_with_VAT__c, ASI_CRM_Item_Group_Description__c FROM Price_And_Discount_Details__r) FROM ASI_CRM_Price_And_Discount__c WHERE Id = : soHeaderId];
        
        List<ASI_CRM_Order_Form_Customer_Relationship__c> ofcrList;
        
        if(soHeader.ASI_CRM_RTD__c == TRUE)
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='RTD' AND ASI_CRM_Customer__c =: soHeader.ASI_CRM_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        else
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='Normal Item' AND ASI_CRM_Customer__c =: soHeader.ASI_CRM_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        
        //List<ASI_CRM_Price_And_Discount__c> soHeaderList = new List<ASI_CRM_Price_And_Discount__c>();
        //soHeaderList.add(soHeader);
        
        for(ASI_CRM_Order_Form_Customer_Relationship__c obj : ofcrList)
            mapOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
        
        /*for(ASI_CRM_Price_And_Discount__c header : soHeaderList)
            for(ASI_CRM_Price_And_Discount_Detail__c detailobj : soHeader.Price_And_Discount_Details__r)
                mapLineItemPrice.put(detailobj.ASI_CRM_Item_Group_Description__c, detailobj.ASI_CRM_New_Price_BT_with_VAT__c);*/
        
        system.debug('check007 ' + mapOrderForm.get(soHeader.ASI_CRM_Customer__c));
        List<ASI_CRM_Order_Form_Detail__c> ofList = new List<ASI_CRM_Order_Form_Detail__c>([SELECT id, ASI_CRM_Product_Name__c, ASI_CRM_Remark__c FROM ASI_CRM_Order_Form_Detail__c WHERE ASI_CRM_Order_Form__c =: mapOrderForm.get(soHeader.ASI_CRM_Customer__c)]);
        Map<id, String> mapOrderFormRemark = new Map<id, String>();
        Set<ID> itemGroupID = new Set<id>();
        for(ASI_CRM_Order_Form_Detail__c obj : ofList){
            itemGroupID.add(obj.ASI_CRM_Product_Name__c);
            mapOrderFormRemark.put(obj.ASI_CRM_Product_Name__c, obj.ASI_CRM_Remark__c);
        }
        
        isOrderFormExist = itemGroupID.size() > 0 ? True : False;
        //End check is Order Form Exist
        
        this.useCustPrice = FALSE;
        this.sbSearchOptionsNormal = getSubBrandSearchOptions();
        this.sbSearchOptionsPOS = sbSearchOptionsNormal;
    }
     
    //Retrieve the SOLineItem under the SO 
    @RemoteAction
    public static List<ASI_HK_CRM_SOLineItem> lineItemList(ID headerId) {
        List<ASI_HK_CRM_SOLineItem> result = new List<ASI_HK_CRM_SOLineItem>();
        List<ASI_CRM_Price_And_Discount_Detail__c> lineItems = [
            SELECT Id, Name, ASI_CRM_New_Price_BT_with_VAT__c, ASI_CRM_New_Price_BT_non_VAT__c, ASI_CRM_Current_T1_Price_BT_with_VAT__c, ASI_CRM_Item_Group_Description__c, ASI_CRM_Item_Group_Description__r.Name
            , ASI_CRM_Item_Group_Description__r.ASI_MFM_Sub_brand__r.Name, ASI_CRM_Item_Group_Description__r.ASI_MFM_Sub_brand__c, ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c, ASI_CRM_CN_vs_Current_T1_Non_VAT__c, ASI_CRM_Gross_Sales_Impact__c, ASI_CRM_Total_Estimated_Vol_BT__c, ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c, ASI_CRM_Promotion_Code__r.Name, ASI_CRM_Promotion_Code__c
            FROM ASI_CRM_Price_And_Discount_Detail__c
            WHERE   ASI_CRM_Price_And_Discount__c = :headerId
        ];
        
        String pickListStr = '';
        String promotionBGStr = '';
        For(ASI_CRM_Promotion_Master__c obj : [SELECT id, ASI_CRM_Buy_X__c, ASI_CRM_Get_Y__c, Name FROM ASI_CRM_Promotion_Master__c]){
            pickListStr += obj.id + '-' + obj.Name + ';';
            if(obj.ASI_CRM_Buy_X__c != null)
            	promotionBGStr += obj.id + ',' + obj.ASI_CRM_Buy_X__c + ',' + obj.ASI_CRM_Get_Y__c + ';';
            else
                promotionBGStr += obj.id + ',' + '' + ',' + '' + ';';
        }
        
        Map<ID ,ASI_CRM_CN_T1_Price__c> mapT1Price = new Map<ID ,ASI_CRM_CN_T1_Price__c>();
        
        for(ASI_CRM_CN_T1_Price__c obj : t1Price){
            if(!mapT1Price.containsKey(obj.ASI_CRM_CN_Item_Group__c))
            	mapT1Price.put(obj.ASI_CRM_CN_Item_Group__c, obj);
        }
        
        for (ASI_CRM_Price_And_Discount_Detail__c li : lineItems) {
            ASI_HK_CRM_SOLineItem tempLi = new ASI_HK_CRM_SOLineItem();
            tempLi.id = li.Id;
            tempLi.skuId = li.ASI_CRM_Item_Group_Description__c != null ? li.ASI_CRM_Item_Group_Description__c : null;
            tempLi.skuLabel = li.ASI_CRM_Item_Group_Description__c != null ? li.ASI_CRM_Item_Group_Description__r.Name : null;
            tempLi.subBrandId = li.ASI_CRM_Item_Group_Description__c != null ? li.ASI_CRM_Item_Group_Description__r.ASI_MFM_Sub_brand__c : null;
            tempLi.subBrandLabel = tempLi.subBrandId != null ? li.ASI_CRM_Item_Group_Description__r.ASI_MFM_Sub_brand__r.Name : null;
            tempLi.promotionCodeID = li.ASI_CRM_Promotion_Code__c != null ? li.ASI_CRM_Promotion_Code__c : null ;
            tempLi.promotionCodeName = li.ASI_CRM_Promotion_Code__r.Name;
            tempLi.buyX = li.ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c;
            tempLi.getY = li.ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c;
            tempLi.currentT1PriceBTwithVAT = mapT1Price.containsKey(li.ASI_CRM_Item_Group_Description__c) ? mapT1Price.get(li.ASI_CRM_Item_Group_Description__c).ASI_CRM_CN_T1_Price__c : NULL;
            tempLi.newPriceBTNonVAT = li.ASI_CRM_New_Price_BT_non_VAT__c != Null ? ( li.ASI_CRM_New_Price_BT_non_VAT__c ).setScale(3) : Null;
            tempLi.totalEstimatedVolBT = li.ASI_CRM_Total_Estimated_Vol_BT__c;
            tempLi.price = li.ASI_CRM_New_Price_BT_with_VAT__c;
            tempLi.pickListValue = pickListStr;
            tempLi.promotionValue = promotionBGStr;
            tempLi.grossSalesImpact = li.ASI_CRM_Gross_Sales_Impact__c;
            tempLi.vsCurrentT1PriceBTNonVAT = li.ASI_CRM_CN_vs_Current_T1_Non_VAT__c != Null ? ( li.ASI_CRM_CN_vs_Current_T1_Non_VAT__c ).setScale(3) : Null;
            result.add(tempLi);
        }
        
        for (ASI_HK_CRM_SOLineItem str: result){ System.debug('kkl.5 Line Item List'+str); }
        return result;
    }
    
    @RemoteAction
    public static List<ASI_HK_CRM_NormalProduct> normalProductList(ID headerId, String custId, Boolean onlyCustPrice) {
        
        Map<ID ,ASI_CRM_CN_T1_Price__c> mapT1Price = new Map<ID ,ASI_CRM_CN_T1_Price__c>();
        Map<id, id> mapOrderForm = new Map<id, id>();
        
        for(ASI_CRM_CN_T1_Price__c obj : t1Price){
            if(mapT1Price.get(obj.ASI_CRM_CN_Item_Group__c)==null)
            	mapT1Price.put(obj.ASI_CRM_CN_Item_Group__c, obj);
        }
        
        soHeader = [SELECT Id, 	ASI_CRM_Item_Master_Reference_Number__r.ASI_CN_NPL_Item_Goup_Code__c, ASI_CRM_Customer__c, ASI_CRM_RTD__c, RecordType.DeveloperName, (SELECT ASI_CRM_New_Price_BT_with_VAT__c, ASI_CRM_Item_Group_Description__c FROM Price_And_Discount_Details__r) FROM ASI_CRM_Price_And_Discount__c WHERE Id = : headerId];
        
        List<ASI_CRM_Order_Form_Customer_Relationship__c> ofcrList;
        
        if(soHeader.ASI_CRM_RTD__c == TRUE)
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='RTD' AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_Customer__c]);
        else
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='Normal Item' AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_Customer__c]);
        
        List<ASI_CRM_Price_And_Discount__c> soHeaderList = new List<ASI_CRM_Price_And_Discount__c>();
        soHeaderList.add(soHeader);
        
        for(ASI_CRM_Order_Form_Customer_Relationship__c obj : ofcrList)
            mapOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
        
        /*for(ASI_CRM_Price_And_Discount__c header : soHeaderList)
            for(ASI_CRM_Price_And_Discount_Detail__c detailobj : soHeader.Price_And_Discount_Details__r)
                mapLineItemPrice.put(detailobj.ASI_CRM_Item_Group_Description__c, detailobj.ASI_CRM_New_Price_BT_with_VAT__c);*/
        
        system.debug('check007 ' + mapOrderForm.get(soHeader.ASI_CRM_Customer__c));
        List<ASI_CRM_Order_Form_Detail__c> ofList = new List<ASI_CRM_Order_Form_Detail__c>([SELECT id, ASI_CRM_Order_Form__r.ASI_CRM_T1_Master__c, ASI_CRM_Product_Name__c, ASI_CRM_Remark__c FROM ASI_CRM_Order_Form_Detail__c WHERE ASI_CRM_Order_Form__c =: mapOrderForm.get(soHeader.ASI_CRM_Customer__c)]);
        //Map<id, String> mapOrderFormRemark = new Map<id, String>();
        Set<ID> itemGroupID = new Set<id>();
        for(ASI_CRM_Order_Form_Detail__c obj : ofList){
            itemGroupID.add(obj.ASI_CRM_Product_Name__c);
        }
        
        Date todayDate = Date.today();
        List<ASI_HK_CRM_NormalProduct> result = new List<ASI_HK_CRM_NormalProduct>();
        List<ASI_MFM_Item_Group__c> skuList = new List<ASI_MFM_Item_Group__c>();
        
        // Customer Price and Discount Request
        if(soHeader.RecordType.DeveloperName == 'ASI_CRM_CN_Customer_Price_and_Discount_Request' && itemGroupID.size()>0){

            skuList = [
                SELECT Id, Name, ASI_CRM_CN_pack__c, ASI_MFM_Sub_brand__c, ASI_MFM_Sub_brand__r.Name, ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c
                , ASI_CRM_CN_BT_Size_C__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_Converion9L_C__c
                //, (SELECT id, ASI_CRM_CN_T1_Price__c FROM T1_Price__r WHERE ASI_CRM_CN_Effective_Date__c >=: todayDate)
                FROM ASI_MFM_Item_Group__c
                WHERE /*RecordType.DeveloperName = :RTDEVNAME_SKU AND ASI_CRM_CN_Not_In_Use__c = False AND*/ ID IN : itemGroupID
            ];
            
        // T1 Price Adjustment    
        }else if(soHeader.RecordType.DeveloperName == 'ASI_CRM_CN_T1_Price_Adjustment_Request'){
            
            List<ASI_CRM_Order_Form_Detail__c> ofdList = new List<ASI_CRM_Order_Form_Detail__c>([SELECT id, ASI_CRM_Order_Form__r.ASI_CRM_T1_Master__c, ASI_CRM_Product_Name__c, ASI_CRM_Remark__c FROM ASI_CRM_Order_Form_Detail__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_T1_Master__c = TRUE AND ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c = 'Normal Item']);
            Set<ID> t1ItemGroupID = new Set<id>();
            
            for(ASI_CRM_Order_Form_Detail__c obj : ofdList){
            	if(obj.ASI_CRM_Order_Form__r.ASI_CRM_T1_Master__c == TRUE){
                	t1ItemGroupID.add(obj.ASI_CRM_Product_Name__c);
            	}
            }
            
            skuList = [
                SELECT Id, Name, ASI_CRM_CN_pack__c, ASI_MFM_Sub_brand__c, ASI_MFM_Sub_brand__r.Name, ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c
                , ASI_CRM_CN_BT_Size_C__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_Converion9L_C__c
                //, (SELECT id, ASI_CRM_CN_T1_Price__c FROM T1_Price__r WHERE ASI_CRM_CN_Effective_Date__c >=: todayDate)
                FROM ASI_MFM_Item_Group__c
                WHERE RecordType.DeveloperName = :RTDEVNAME_SKU AND ASI_CRM_CN_Not_In_Use__c = False AND ID IN : t1ItemGroupID
                AND ASI_CRM_Competitor__c = 'No' 
            	AND ASI_CRM_CN_Gift_Set_C__c = FALSE
            	AND ASI_CRM_CN_EMPTY_BOX_C__c = FALSE
            ];
            
        //Repacking    
        }else if(soHeader.RecordType.DeveloperName == 'ASI_CRM_CN_Repacking_Price_Request'){
        	
            skuList = [
                SELECT Id, Name, ASI_CRM_CN_pack__c, ASI_MFM_Sub_brand__c, ASI_MFM_Sub_brand__r.Name, ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c
                , ASI_CRM_CN_BT_Size_C__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_Converion9L_C__c
                //, (SELECT id, ASI_CRM_CN_T1_Price__c FROM T1_Price__r WHERE ASI_CRM_CN_Effective_Date__c >=: todayDate)
                FROM ASI_MFM_Item_Group__c
                WHERE RecordType.DeveloperName = :RTDEVNAME_SKU
                AND ASI_CRM_CN_Not_In_Use__c = False
                AND ASI_CRM_Competitor__c = 'No' 
            	AND ASI_CRM_CN_Gift_Set_C__c = FALSE
            	AND ASI_CRM_CN_EMPTY_BOX_C__c = FALSE
                AND ASI_MFM_Item_Group_Code__c = : soHeader.ASI_CRM_Item_Master_Reference_Number__r.ASI_CN_NPL_Item_Goup_Code__c
                ];
            
        }else{
            
            List<ASI_MFM_SKU_Code__c> tmpSKU = new List<ASI_MFM_SKU_Code__c>([SELECT ASI_MFM_Item_Group__c FROM ASI_MFM_SKU_Code__c
                                                                              WHERE ASI_MFM_Item_Group__r.RecordType.DeveloperName = :RTDEVNAME_SKU 
                                                                              AND ASI_MFM_Item_Group__r.ASI_CRM_CN_Not_In_Use__c = False
                                                                              AND ASI_MFM_Item_Group__r.ASI_CRM_Competitor__c = 'No' 
                                                                        	  AND ASI_MFM_Item_Group__r.ASI_CRM_CN_Gift_Set_C__c = FALSE
                                                                        	  AND ASI_MFM_Item_Group__r.ASI_CRM_CN_EMPTY_BOX_C__c = FALSE
                                                                        	  AND (ASI_CRM_SKU_Status__c LIKE '%000%' OR ASI_CRM_SKU_Status__c LIKE '%001%' OR ASI_CRM_SKU_Status__c LIKE '%997%')
                                                                             ]);
            Set<Id> tmpIGId = new Set<Id>();
            
            if(tmpSKU.size() > 0){
                for(ASI_MFM_SKU_Code__c obj : tmpSKU){
                    tmpIGId.add(obj.ASI_MFM_Item_Group__c);
                }
            }
            
            skuList = [
                SELECT Id, Name, ASI_CRM_CN_pack__c, ASI_MFM_Sub_brand__c, ASI_MFM_Sub_brand__r.Name, ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c
                , ASI_CRM_CN_BT_Size_C__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_Converion9L_C__c
                //, (SELECT id, ASI_CRM_CN_T1_Price__c FROM T1_Price__r WHERE ASI_CRM_CN_Effective_Date__c >=: todayDate)
                FROM ASI_MFM_Item_Group__c
                WHERE Id IN : tmpIGId
            ];
        }
        
        /*List<ASI_CRM_Item_Group_Customer_Price__c> itemGroupCustomerPrice = new List<ASI_CRM_Item_Group_Customer_Price__c>(
            [SELECT ASI_CRM_Customer__c, ASI_CRM_Item_Group__c, ASI_CRM_Price_Type__c,
             ASI_CRM_Promotion_Code__c, ASI_CRM_Promotion_Expiration_Date__c, ASI_CRM_Unit_Price_BT__c,
             ASI_CRM_Promotion_Code__r.Name, ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c, ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c
            FROM ASI_CRM_Item_Group_Customer_Price__c WHERE RecordType.DeveloperName = 'ASI_CRM_CN_ItemGroupCustomerPrice' AND ASI_CRM_Promotion_Expiration_Date__c >=: todayDate AND ASI_CRM_Customer__c =: soHeader.ASI_CRM_Customer__c]);
        
        Map<String, ASI_CRM_Item_Group_Customer_Price__c> mapPromotionCode = new Map<String, ASI_CRM_Item_Group_Customer_Price__c>();
        
        for(ASI_CRM_Item_Group_Customer_Price__c obj : itemGroupCustomerPrice){
            mapPromotionCode.put(obj.ASI_CRM_Customer__c + '' + obj.ASI_CRM_Item_Group__c, obj);
            
            //if(obj.ASI_CRM_Price_Type__c == 'T1' && obj.ASI_CRM_Unit_Price_BT__c != null)
                //mapT1Price.put(obj.ASI_CRM_Customer__c + '' + obj.ASI_CRM_Item_Group__c, obj);
        }*/
        
        String pickListStr = '';
        String promotionBGStr = '';
        For(ASI_CRM_Promotion_Master__c obj : [SELECT id, ASI_CRM_Buy_X__c, ASI_CRM_Get_Y__c, Name FROM ASI_CRM_Promotion_Master__c WHERE recordType.developerName = 'ASI_CRM_CN_Promotion_Master']){
            pickListStr += obj.id + '-' + obj.Name + ';';
            if(obj.ASI_CRM_Buy_X__c != null)
            	promotionBGStr += obj.id + ',' + obj.ASI_CRM_Buy_X__c + ',' + obj.ASI_CRM_Get_Y__c + ';';
            else
                promotionBGStr += obj.id + ',' + '' + ',' + '' + ';';
        }
        
        for (ASI_MFM_Item_Group__c sku : skuList) {
                ASI_HK_CRM_NormalProduct pd = new ASI_HK_CRM_NormalProduct();
                pd.id = sku.Id;
                pd.qty9Lfactor = sku.ASI_CRM_CN_Converion9L_C__c;
                pd.code = null;
                pd.name = sku.Name;
                /*pd.promotionExpirationDate = pd.promotionCodeID != null ? String.valueOf( mapPromotionCode.get(soHeader.ASI_CRM_Customer__c + '' + sku.id).ASI_CRM_Promotion_Expiration_Date__c.day() + '-' + 
                                             mapPromotionCode.get(soHeader.ASI_CRM_Customer__c + '' + sku.id).ASI_CRM_Promotion_Expiration_Date__c.month() + '-' + 
                                             mapPromotionCode.get(soHeader.ASI_CRM_Customer__c + '' + sku.id).ASI_CRM_Promotion_Expiration_Date__c.year() ) : null ;
                pd.unitPriceSource = pd.promotionCodeID != null ? mapPromotionCode.get(soHeader.ASI_CRM_Customer__c + '' + sku.id).ASI_CRM_Price_Type__c : null ;
                pd.buyX = pd.promotionCodeID != null ? mapPromotionCode.get(soHeader.ASI_CRM_Customer__c + '' + sku.id).ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c : null;
                pd.getY = pd.promotionCodeID != null ? mapPromotionCode.get(soHeader.ASI_CRM_Customer__c + '' + sku.id).ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c : null;*/
                pd.subBrandId = sku.ASI_MFM_Sub_brand__c;
                pd.subBrandLabel = sku.ASI_MFM_Sub_brand__c != null ? sku.ASI_MFM_Sub_brand__r.Name : '';
                pd.currentT1PriceBTwithVAT = mapT1Price.containsKey(sku.id) ? mapT1Price.get(sku.id).ASI_CRM_CN_T1_Price__c : null;
                pd.inventory = null;
            
            	String Name = '';
            	
            	if(sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name != Null && sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name != ''){
                    if(sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name.contains('\'')){
                        
                        String[] splittedName = sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name.split('\'');
                        
                        for(integer i = 0 ; i < splittedName.size() ; i ++){
                        
                            Name += splittedName[i];
                        }
                    }else{
                        Name = sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name;
                    }
            	}
            
                pd.brandType = Name;//sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name;
                pd.packaging = sku.ASI_CRM_CN_pack__c;
                pd.newPriceBTNonVAT = null;
                pd.stdNum = null;
                pd.dummy = null;
                pd.promotionValue = promotionBGStr;
                pd.pickListValue = pickListStr;
                result.add(pd);
            //}
        }
        for(ASI_HK_CRM_NormalProduct str2: result){
            System.debug('kkl.6 normal product list'+str2);
        }
        return result;
    }
    
    /*//POS Table
    @RemoteAction
    public static ASI_HK_CRM_DataTableServerResult posProductDataTableResult(List<ASI_HK_CRM_DataTableServerInput> dataTableInputs) {
        Integer skuCount = [
            SELECT COUNT() FROM ASI_MFM_Item_Group__c
            WHERE RecordType.DeveloperName = :RTDEVNAME_SKU AND ASI_CRM_CN_Not_In_Use__c = FALSE
        ];
        System.debug('kkl8'+skuCount);
        Map<String, Object> dataTableInputMap = new Map<String, Object>();
        for (ASI_HK_CRM_DataTableServerInput input : dataTableInputs) {
            if (input.name != null)
                dataTableInputMap.put(input.name, input.value);
        }
        Integer limitNum = integerFromObject(dataTableInputMap.get('iDisplayLength'));
        Integer offsetNum = integerFromObject(dataTableInputMap.get('iDisplayStart'));
        String searchName = stringFromObject(dataTableInputMap.get('sSearch_1'));
        String subBrandStr = stringFromObject(dataTableInputMap.get('sSearch_2'));
        
        Set<String> queryFields = new Set<String> {
            'Id', 'Name', 'ASI_MFM_Sub_brand__c', 'ASI_MFM_Sub_brand__r.Name'
            
        };
        String baseWhereStatm = 'RecordType.DeveloperName = :RTDEVNAME_SKU AND ASI_CRM_CN_Not_In_Use__c = FALSE';
        String filterWhereStatm = '';
        if (!String.isBlank(searchName)) {
            searchName = '%' + escapeSOQLLikeValue(searchName.trim()) + '%';
            if (filterWhereStatm != '') filterWhereStatm += ' AND';
            filterWhereStatm += ' Name LIKE :searchName';
        }
        if (!String.isBlank(subBrandStr)) {
            if (filterWhereStatm != '') filterWhereStatm += ' AND';
            if (subBrandStr.startsWith('_')) {
                subBrandStr = subBrandStr.substringBetween('_', '_');
                //filterWhereStatm += ' ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c = :subBrandStr';
            } else {
                filterWhereStatm += ' ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name = :subBrandStr';
            }
        }
        String whereStatm = filterWhereStatm != '' ? '(' + filterWhereStatm + ') AND (' + baseWhereStatm + ')' : baseWhereStatm;
        String skuSearchCountQueryStr = ASI_HK_CRM_CommonUtils.genQueryString(new Set<String>{'COUNT()'}, 'ASI_MFM_Item_Group__c', whereStatm);
        Integer skuSearchCount = database.countQuery(skuSearchCountQueryStr);
        String extraQueryStr = '';
        if (limitNum != null) extraQueryStr += ' LIMIT :limitNum';
        if (offsetNum != null) extraQueryStr += ' OFFSET :offsetNum';
        String skuSearchQueryStr = ASI_HK_CRM_CommonUtils.genQueryString(queryFields, 'ASI_MFM_Item_Group__c', whereStatm, extraQueryStr);
        List<ASI_MFM_Item_Group__c> skuList = (List<ASI_MFM_Item_Group__c>)database.query(skuSearchQueryStr);
        
        ASI_HK_CRM_DataTableServerResult result = new ASI_HK_CRM_DataTableServerResult();
        result.iTotalRecords = skuCount;
        result.iTotalDisplayRecords = skuSearchCount;
        result.sEcho = (Decimal)dataTableInputMap.get('sEcho');
        List<ASI_HK_CRM_POSProduct> pdList = new List<ASI_HK_CRM_POSProduct>();
        for (ASI_MFM_Item_Group__c sku : skuList) {
            ASI_HK_CRM_POSProduct pd = new ASI_HK_CRM_POSProduct();
            pd.id = sku.Id;
            pd.code = null;
            pd.name = sku.Name;
            pd.subBrandId = sku.ASI_MFM_Sub_brand__c;
            pd.subBrandLabel = sku.ASI_MFM_Sub_brand__c != null ? sku.ASI_MFM_Sub_brand__r.Name : '';
            pd.brandType = sku.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name;
            pd.price = null;
            pd.inventory = null;
            pdList.add(pd);
        }
        result.aaData = pdList;
        for(ASI_HK_CRM_POSProduct res: pdList){
            System.debug('lab1'+res);
        }
        
        return result;
    }*/
    
    @RemoteAction
    public static ASI_HK_CRM_SaveResult saveChanges(String headerId, List<ASI_HK_CRM_SOLineItem> remoteLineItems) {
        ASI_HK_CRM_SaveResult result = new ASI_HK_CRM_SaveResult();
        result.success = false;
        
        try {
            if (isNonEmptyId(headerId)) {
                Map<ID, ASI_CRM_Price_And_Discount_Detail__c> existingLineItemMap = new Map<ID, ASI_CRM_Price_And_Discount_Detail__c>(
                (List<ASI_CRM_Price_And_Discount_Detail__c>)[
                    SELECT Id, LastModifiedDate
                    FROM ASI_CRM_Price_And_Discount_Detail__c
                    WHERE ASI_CRM_Price_And_Discount__c = :headerId
                    FOR UPDATE
                ]);
                
                Set<ID> newIdSet = new Set<ID>();
                List<ASI_CRM_Price_And_Discount_Detail__c> insertLineItems = new List<ASI_CRM_Price_And_Discount_Detail__c>();
                List<ASI_CRM_Price_And_Discount_Detail__c> updateLineItems = new List<ASI_CRM_Price_And_Discount_Detail__c>();
                List<ASI_CRM_Price_And_Discount_Detail__c> deleteLineItems = new List<ASI_CRM_Price_And_Discount_Detail__c>();
                if (remoteLineItems != null) {
                    for (ASI_HK_CRM_SOLineItem remoteLineItem : remoteLineItems) {
                        if (remoteLineItem.id != null && remoteLineItem.id.trim() != '') {
                            ASI_CRM_Price_And_Discount_Detail__c lineItem = existingLineItemMap.get(remoteLineItem.id);
                            if (lineItem != null) {
                                updateLineItemFromRemote(lineItem, remoteLineItem);
                                updateLineItems.add(lineItem);
                                newIdSet.add(remoteLineItem.id);
                            } else {
                                result.messages.add(String.format('Line item with ID {0} is not found', new String[] {remoteLineItem.id}));
                                break;
                            }
                        } else {
                            ASI_CRM_Price_And_Discount_Detail__c lineItem = new ASI_CRM_Price_And_Discount_Detail__c();
                            updateLineItemFromRemote(lineItem, remoteLineItem);
                            lineItem.ASI_CRM_Price_And_Discount__c = headerId;
                            insertLineItems.add(lineItem);
                        }
                    }
                }
                
                if (existingLineItemMap.size() != newIdSet.size()) {
                    for (ASI_CRM_Price_And_Discount_Detail__c existingLineItem : existingLineItemMap.values()) {
                        if (!newIdSet.contains(existingLineItem.Id))
                            deleteLineItems.add(existingLineItem);
                    }
                }
                
                System.Savepoint sp = database.setSavepoint();
                try {
                    delete deleteLineItems;
                    insert insertLineItems;
                    update updateLineItems;
                    result.success = true;
                } catch (DmlException dmle) {
                    database.rollback(sp);
                    Set<String> errMsgs = new Set<String>();
                    Integer size = dmle.getNumDml();
                    for (Integer i = 0; i < size; i++) {
                        errMsgs.add(dmle.getDmlMessage(i));
                    }
                    result.messages.addAll(errMsgs);
                }
                
            } else {
                result.messages.add('Invalid header ID');
            }
        } catch (Exception e) {
            result.messages.add(e.getMessage());
        }
        System.debug('kkl.8'+result);
        return result;
    }
    private static void updateLineItemFromRemote(ASI_CRM_Price_And_Discount_Detail__c lineItem, ASI_HK_CRM_SOLineItem remoteLineItem) {
        
        Map<ID ,ASI_CRM_CN_T1_Price__c> mapT1Price = new Map<ID ,ASI_CRM_CN_T1_Price__c>();
        
        for(ASI_CRM_CN_T1_Price__c obj : t1Price){
            if(!mapT1Price.containsKey(obj.ASI_CRM_CN_Item_Group__c))
            	mapT1Price.put(obj.ASI_CRM_CN_Item_Group__c, obj);
        }
        
        //Map<id, ASI_CRM_Promotion_Master__c> promotionIdChecking = new Map<id, ASI_CRM_Promotion_Master__c>([SELECT id FROM ASI_CRM_Promotion_Master__c WHERE id IN : promotionIdSet]);
        
        if (remoteLineItem.id != null && remoteLineItem.id.trim() != '') lineItem.Id = remoteLineItem.id;
        lineItem.ASI_CRM_New_Price_BT_with_VAT__c = remoteLineItem.price;
        lineItem.ASI_CRM_Item_Group_Description__c = remoteLineItem.skuId;
        lineItem.RecordTypeId = Global_RecordTypeCache.getRtID('ASI_CRM_Price_And_Discount_Detail__cASI_CRM_CN_Price_And_Discount_Detail');
        lineItem.ASI_CRM_Promotion_Code__c = remoteLineItem.promotionCodeID;
        lineItem.ASI_CRM_Current_T1_Price_BT_with_VAT__c = remoteLineItem.currentT1PriceBTwithVAT;//mapT1Price.containsKey(remoteLineItem.skuId) ? mapT1Price.get(remoteLineItem.skuId).ASI_CRM_CN_T1_Price__c : null;
        lineItem.ASI_CRM_Total_Estimated_Vol_BT__c = remoteLineItem.totalEstimatedVolBT;

    }
    
    public List<List<String>> getSubBrandSearchOptions() {
        List<List<String>> result = new List<List<String>>();
        List<ASI_MFM_Sub_brand__c> sbList = [
            SELECT Id, Name, ASI_MFM_Sub_brand_Description__c
            FROM ASI_MFM_Sub_brand__c
            WHERE RecordType.DeveloperName = :RTDEVNAME_SB
            ORDER BY Name
        ];
        for (ASI_MFM_Sub_brand__c sb : sbList) {
            List<String> mOption = new String[2];
            mOption[0] = String.escapeSingleQuotes(sb.Id);
            mOption[1] = sb.Name == null ? '' : sb.Name;
            result.add(mOption);
        }
        for(List<String> str3: result){
            System.debug('tky'+str3);
        }
        
        return result;
    }
    
    private void showPageMessage(ApexPages.Severity severity, String msg) { ApexPages.addMessage(new ApexPages.Message(severity, msg)); }
    private void showPageError(String msg) { showPageMessage(ApexPages.Severity.ERROR, msg); }
    
    private static Boolean isNonEmptyId(String theId) {
        if (theId != null && theId.trim() != '') {
            ID testId;
            try {
                testId = theId;
                return true;
            } catch(Exception e) {}
        }
        return false;
    }
    
    public List<String> getBrandType(){
        
        List<String> BrandType = new List<String>();
        Set<ASI_CRM_CN_Brand_Group__c> BrandTypeSet = new Set<ASI_CRM_CN_Brand_Group__c>([SELECT Name FROM ASI_CRM_CN_Brand_Group__c ORDER BY ASI_CRM_CN_Sequence2__c]);
        
        for(ASI_CRM_CN_Brand_Group__c obj: BrandTypeSet){
            String Name = '';
            
            if(obj.Name.contains('\'')){
                String[] splittedName = obj.Name.split('\'');
                for(integer i = 0 ; i < splittedName.size() ; i ++){
                    
                    Name += splittedName[i];
                }
            }else{
                Name = obj.Name;
            }
               
        	BrandType.add(Name);
        }
        
        return BrandType;
    }
    
    /*private static String escapeSOQLLikeValue(String likeVal) {
        return likeVal.replace('%', '\\%').replace('_', '\\_');
    }
    
    private static Integer integerFromObject(Object obj) {
        return obj != null ? Integer.valueOf(obj) : null;
    }
    private static String stringFromObject(Object obj) {
        return obj != null && !String.isBlank((String)obj) ? (String)obj : null;
    }*/
    
    public class ASI_HK_CRM_SOLineItem {
        public String id { get; set; }
        public String skuId { get; set; }
        public String skuLabel { get; set; }
        public Decimal skuInventory { get; set; }
        public Decimal grossSalesImpact { get; set; }
        public String subBrandId { get; set; }
        public String subBrandLabel { get; set; }
        public String brandType { get; set; }
        public Decimal qty { get; set; }
        public Decimal newPriceBTNonVAT { get; set; }
        public Decimal totalEstimatedVolBT { get; set; }
        public String uom { get; set; }
        public Decimal buyX { get; set; }
        public Decimal getY { get; set; }
        public Decimal qty9Lfactor { get; set; }
        public String promotionCodeID { get; set; }
        public String promotionCodeName { get; set; }
        Public String promotionExpirationDate { get; set; }
        public String unitPriceSource { get; set; }
        public String remark { get; set; }
        public string packaging { get; set; }
        public Decimal vsCurrentT1PriceBTNonVAT { get; set; }
        public Decimal currentT1PriceBTwithVAT { get; set; }
        public Decimal price { get; set; }
        public Decimal amount { get; set; }
        public Boolean available { get; set; }
        public Boolean isPOS { get; set; }
        public String pickListValue { get; set; }
        public String promotionValue { get; set; }
        public Decimal stdNum { get; set; }   //Std. Bottle Size
    }
    
    public virtual class ASI_HK_CRM_SKU {
        public String id { get; set; }
        public String code { get; set; }
        public String remark { get; set; }
        public String name { get; set; }
        public Decimal buyX { get; set; }
        public Decimal getY { get; set; }
        public Decimal newPriceBTNonVAT { get; set; }
        public Decimal totalEstimatedVolBT { get; set; }
        Public String promotionCodeID { get; Set; }
        public String promotionCodeName { get; set; }
        Public String promotionExpirationDate { get; set; }
        public Decimal currentT1PriceBTwithVAT { get; set; }
        public String unitPriceSource { get; set; }
        public Decimal qty9Lfactor { get; set; }
        public String subBrandId { get; set; }
        public String subBrandLabel { get; set; }
        public string packaging { get; set; }
        public Decimal price { get; set; }
        public Decimal inventory { get; set; }
        public String brandType { get; set; }
        public String pickListValue { get; set; }
        public String promotionValue { get; set; }
        public Decimal stdNum { get; set; }     //Std. Bottle Size
        public String dummy { get; set; }
        
    }
    
    public class ASI_HK_CRM_NormalProduct extends ASI_HK_CRM_SKU {
    }
    
    public class ASI_HK_CRM_POSProduct extends ASI_HK_CRM_SKU {
    }
    
    public class ASI_HK_CRM_DataTableServerInput {
        public String name;
        public Object value;
    }
    /*public class ASI_HK_CRM_DataTableServerResult {
        public Integer iTotalRecords;
        public Integer iTotalDisplayRecords;
        public Decimal sEcho;
        public List<ASI_HK_CRM_SKU> aaData;
    }*/
    
    public class ASI_HK_CRM_SaveResult {
        public Boolean success { get; set; }
        public List<String> messages { get; set; }
        
        public ASI_HK_CRM_SaveResult() {
            this.messages = new List<String>();
        }
    }
}