public without sharing class ASI_CRM_CN_SalesOrderRequestCtrller {
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
    public Boolean useCustPrice { get; private set; }
    public List<List<String>> sbSearchOptionsNormal { get; set; }
    public List<List<String>> sbSearchOptionsPOS { get; set; }
    Public ASI_KOR_Sales_Order_Request__c headerSO {Get; Set;}//20161124 Elufa
    
    public ASI_CRM_CN_SalesOrderRequestCtrller(ApexPages.StandardSetController stdSetController) {
        this.soHeaderId = ApexPages.currentPage().getParameters().get('id');
        this.useCustPrice = FALSE;
        this.sbSearchOptionsNormal = getSubBrandSearchOptions();
        this.sbSearchOptionsPOS = sbSearchOptionsNormal;
        this.headerSO = [SELECT id, ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c FROM ASI_KOR_Sales_Order_Request__c WHERE ID = : soHeaderId];//20161124 Elufa
    }
     
    //Retrieve the SOLineItem under the SO 
    @RemoteAction
    public static List<ASI_HK_CRM_SOLineItem> lineItemList(ID headerId) {
        
        Date todayDate = Date.today();
        Date startDate;//20170527
        Date endDate;//20170527
        
        Map<Id, ASI_CRM_Item_Group_Allocation__c> allocationMap = new Map<Id, ASI_CRM_Item_Group_Allocation__c>();
        Map<id, id> mapOrderForm = new Map<id, id>();
        List<ASI_CRM_Order_Form_Customer_Relationship__c> ofcrList;
        
        ASI_KOR_Sales_Order_Request__c soHeader = [select Id, ASI_CRM_SG_Order_Date__c
                                                   , ASI_CRM_CN_Customer__c
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Order_by_BT__c
                                                   , ASI_CRM_CN_RTD__c ,ASI_CRM_CN_Premium__c
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c //20160803 Ben @ Elufa
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_NewChannel__r.Name
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                   FROM ASI_KOR_Sales_Order_Request__c 
                                                   WHERE Id = : headerId]; //20160926, edited by Leo, add sletect field - ASI_CRM_CN_Premium__c
        
        startdate = date.newInstance(soHeader.ASI_CRM_SG_Order_Date__c.year(), soHeader.ASI_CRM_SG_Order_Date__c.month(), 1);
        endDate = date.newInstance(soHeader.ASI_CRM_SG_Order_Date__c.year(), soHeader.ASI_CRM_SG_Order_Date__c.month(), date.daysInMonth(soHeader.ASI_CRM_SG_Order_Date__c.year(), soHeader.ASI_CRM_SG_Order_Date__c.month()));
        
        for(ASI_CRM_Item_Group_Allocation__c allocationItem : [SELECT id
                                                               , ASI_CRM_Allocation_Quantity_Bottle__c
                                                               , ASI_CRM_Item_Group__c
                                                               , ASI_CRM_MTD_Order_Quantity__c
                                                               , ASI_CRM_MTD_Order_Quantity_CA__c
                                                               , ASI_CRM_Remaining_Qty_BT__c
                                                               , ASI_CRM_Remaining_Qty_CA__c
                                                               FROM ASI_CRM_Item_Group_Allocation__c
                                                               WHERE ASI_CRM_Effective_Date__c >= : startDate
                                                               AND ASI_CRM_Effective_Date__c <= : endDate
                                                               AND ASI_CRM_Commercial_Team__c = : soHeader.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c
                                                               AND ASI_CRM_Region__c = : soHeader.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                               AND recordType.developerName Like '%_CN_%'
                                                              ]){
                                                                  
            allocationMap.put(allocationItem.ASI_CRM_Item_Group__c, allocationItem);
        }
        
        if(soHeader.ASI_CRM_CN_RTD__c == TRUE)
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='RTD' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        //20160926, added by Leo
        else if(soHeader.ASI_CRM_CN_Premium__c == TRUE)
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='Premium' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        //20160926, added by Leo
        else
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='Normal Item' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        
        
        for(ASI_CRM_Order_Form_Customer_Relationship__c obj : ofcrList)
            mapOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
        
        
        system.debug('check007 ' + mapOrderForm.get(soHeader.ASI_CRM_CN_Customer__c));
        List<ASI_CRM_Order_Form_Detail__c> ofList = new List<ASI_CRM_Order_Form_Detail__c>([SELECT id, ASI_CRM_Product_Name__c, ASI_CRM_Sequence__c FROM ASI_CRM_Order_Form_Detail__c WHERE ASI_CRM_Order_Form__c =: mapOrderForm.get(soHeader.ASI_CRM_CN_Customer__c)]);
        Map<id, Decimal> mapOrderFormRemark = new Map<id, Decimal>();
        for(ASI_CRM_Order_Form_Detail__c obj : ofList){
            mapOrderFormRemark.put(obj.ASI_CRM_Product_Name__c, obj.ASI_CRM_Sequence__c);
        }
        
        List<ASI_CRM_Item_Group_Customer_Price__c> itemGroupCustomerPrice = new List<ASI_CRM_Item_Group_Customer_Price__c>([SELECT ASI_CRM_Customer__c
                                                                                                                            , ASI_CRM_Item_Group__c
                                                                                                                            , ASI_CRM_Price_Type__c
                                                                                                                            , ASI_CRM_Promotion_Code__c
                                                                                                                            , ASI_CRM_Promotion_Expiration_Date__c
                                                                                                                            , ASI_CRM_Unit_Price_BT__c
                                                                                                                            , ASI_CRM_Promotion_Code__r.Name
                                                                                                                            , ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c
                                                                                                                            , ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c
                                                                                                                            , ASI_CRM_Effective_Date_To__c//20161122 Elufa
                                                                                                                            FROM ASI_CRM_Item_Group_Customer_Price__c WHERE ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c//ASI_CRM_Promotion_Expiration_Date__c >=: todayDate
                                                                                                                           ]);
        
        Map<String, ASI_CRM_Item_Group_Customer_Price__c> mapCustomerPrice = new Map<String, ASI_CRM_Item_Group_Customer_Price__c>();
        Map<String, ASI_CRM_Item_Group_Customer_Price__c> mapPrmotionCode = new Map<String, ASI_CRM_Item_Group_Customer_Price__c>();
        
        for(ASI_CRM_Item_Group_Customer_Price__c obj : itemGroupCustomerPrice){
            mapCustomerPrice.put(obj.ASI_CRM_Customer__c + '' + obj.ASI_CRM_Item_Group__c, obj);
            if(obj.ASI_CRM_Promotion_Expiration_Date__c >= date.today()){
                mapPrmotionCode.put(obj.ASI_CRM_Customer__c + '' + obj.ASI_CRM_Item_Group__c, obj);
            }
        }
        
        List<ASI_HK_CRM_SOLineItem> result = new List<ASI_HK_CRM_SOLineItem>();
        List<ASI_KOR_Sales_Order_Transaction__c> lineItems = [
            SELECT Id, Name, ASI_CRM_CN_Product_Name__r.ASI_MFM_Sub_brand__c, ASI_CRM_CN_Product_Name__r.ASI_MFM_Sub_brand__r.Name,
            ASI_CRM_CN_Product_Name__c, ASI_CRM_CN_Remark__c, ASI_CRM_CN_Product_Name__r.Name, ASI_KOR_Order_Qty__c, ASI_CRM_CN_Logistics_Remark__c,
            ASI_CRM_CN_Product_Name__r.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_UOM__c, ASI_CRM_CN_Promotion_Code__c,
            ASI_CRM_CN_Promotion_Code__r.Name, ASI_CRM_CN_Promotion_Expiration_Date__c, ASI_CRM_CN_Unit_Price_BT_with_VAT__c, 
            ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Converion9L_C__c, ASI_CRM_CN_Unit_Price_Source__c, ASI_CRM_CN_Promotion_Code__r.ASI_CRM_Buy_X__c,
            ASI_CRM_CN_Promotion_Code__r.ASI_CRM_Get_Y__c, ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Pack_Value__c, ASI_CRM_CN_Product_Name__r.ASI_MFM_Item_Group_Code__c,
            ASI_CRM_CN_Product_Name__r.ASI_CRM_Allocation_Information__c //20170205 Elufa
            FROM ASI_KOR_Sales_Order_Transaction__c
            WHERE ASI_KOR_Sales_Order_Request__c = :headerId
        ];
        
        for (ASI_KOR_Sales_Order_Transaction__c li : lineItems) {
            ASI_HK_CRM_SOLineItem tempLi = new ASI_HK_CRM_SOLineItem();
            tempLi.id = li.Id;
            tempLi.skuId = li.ASI_CRM_CN_Product_Name__c;
            tempLi.skuLabel = li.ASI_CRM_CN_Product_Name__c != null ? li.ASI_CRM_CN_Product_Name__r.Name : null;
            tempLi.skuInventory = li.ASI_CRM_CN_Product_Name__c != null ? null : null;
            tempLi.unitPriceSource = mapCustomerPrice.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c) ? mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Price_Type__c : null;//li.ASI_CRM_CN_Unit_Price_Source__c;
            tempLi.subBrandId = li.ASI_CRM_CN_Product_Name__c != null ? li.ASI_CRM_CN_Product_Name__r.ASI_MFM_Sub_brand__c : null;
            tempLi.subBrandLabel = tempLi.subBrandId != null ? li.ASI_CRM_CN_Product_Name__r.ASI_MFM_Sub_brand__r.Name : null;
            tempLi.brandType = li.ASI_CRM_CN_Product_Name__r.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name;
            tempLi.buyX = li.ASI_CRM_CN_Promotion_Code__r.ASI_CRM_Buy_X__c;
            tempLi.getY = li.ASI_CRM_CN_Promotion_Code__r.ASI_CRM_Get_Y__c;
            tempLi.qty = li.ASI_KOR_Order_Qty__c;
            tempLi.qty9Lfactor = li.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Converion9L_C__c;
            tempLi.uom = li.ASI_CRM_CN_UOM__c; 
            tempLi.promotionCodeID = mapPrmotionCode.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c) ? mapPrmotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Code__c : Null;//li.ASI_CRM_CN_Promotion_Code__c;
            tempLi.promotionCodeName = mapPrmotionCode.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c) ? mapPrmotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Code__r.Name : Null;//li.ASI_CRM_CN_Promotion_Code__r.Name;
            tempLi.promotionExpirationDate = mapPrmotionCode.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c) ? mapPrmotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Expiration_Date__c.year() + '-' + mapPrmotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Expiration_Date__c.month() + '-' + mapPrmotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Expiration_Date__c.day() : Null;/*li.ASI_CRM_CN_Promotion_Expiration_Date__c != null ? String.valueOf(li.ASI_CRM_CN_Promotion_Expiration_Date__c.year() + '-' + li.ASI_CRM_CN_Promotion_Expiration_Date__c.month() + '-' + li.ASI_CRM_CN_Promotion_Expiration_Date__c.day()) : null;*/
            tempLi.price = mapCustomerPrice.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c) ? mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Unit_Price_BT__c * 1.16 : null;//li.ASI_CRM_CN_Unit_Price_BT_with_VAT__c; //20180430 Introv Changed Tax Rate From 17% to 16%
            tempLi.amount = null;
            tempLi.pack = li.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Pack_Value__c != NULL ? li.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Pack_Value__c : 0;
            tempLi.remark = li.ASI_CRM_CN_Remark__c;
            System.debug('ddk'+li.ASI_CRM_CN_Product_Name__c);
            tempLi.stdNum = null;
            tempLi.sequence = mapOrderFormRemark.containsKey(li.ASI_CRM_CN_Product_Name__c) ? mapOrderFormRemark.get(li.ASI_CRM_CN_Product_Name__c) : NULL;
            tempLi.itemGroupCode = li.ASI_CRM_CN_Product_Name__r.ASI_MFM_Item_Group_Code__c;
            //20161122 Elufa
            tempLi.effectiveDateTo = mapCustomerPrice.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c) && mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Effective_Date_To__c != Null ? mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Effective_Date_To__c.year() + '-' + mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Effective_Date_To__c.month() + '-' + mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Effective_Date_To__c.day() : Null;
            //20170205 Elufa
            tempLi.hasAllocation = li.ASI_CRM_CN_Product_Name__r.ASI_CRM_Allocation_Information__c;
            //20170527
            tempLi.allocatedQty_BT = allocationMap.containsKey(li.ASI_CRM_CN_Product_Name__c) && allocationMap.get(li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Remaining_Qty_BT__c != Null ? '' + allocationMap.get(li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Remaining_Qty_BT__c : '';
            tempLi.allocatedQty_CA = allocationMap.containsKey(li.ASI_CRM_CN_Product_Name__c) && allocationMap.get(li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Remaining_Qty_CA__c != Null ? '' + integer.valueOf(allocationMap.get(li.ASI_CRM_CN_Product_Name__c).ASI_CRM_Remaining_Qty_CA__c) : '';
            result.add(tempLi);
        }
            
        for (ASI_HK_CRM_SOLineItem str: result){ System.debug('kkl.5 Line Item List'+str); }
        return result;
    }
    
    @RemoteAction
    public static List<ASI_HK_CRM_NormalProduct> normalProductList(ID headerId, String custId, Boolean onlyCustPrice) {
        
        Date todayDate = Date.today();
        Date startDate;//20170527
        Date endDate;//20170527
        
        Map<Id, ASI_CRM_Item_Group_Allocation__c> allocationMap = new Map<Id, ASI_CRM_Item_Group_Allocation__c>();
        Map<id, id> mapOrderForm = new Map<id, id>();
        List<ASI_CRM_Order_Form_Customer_Relationship__c> ofcrList;
        
        ASI_KOR_Sales_Order_Request__c soHeader = [SELECT Id
                                                   , ASI_CRM_UOM__c
                                                   , ASI_CRM_CN_Customer__c
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Order_by_BT__c
                                                   , ASI_CRM_CN_RTD__c ,ASI_CRM_CN_Premium__c 
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c //20160803 Ben @ Elufa
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_NewChannel__r.Name
                                                   , ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                   , ASI_CRM_SG_Order_Date__c
                                                   FROM ASI_KOR_Sales_Order_Request__c WHERE Id = : headerId]; //20160926, edited by Leo, add sletect field - ASI_CRM_CN_Premium__c
        
        //20170920
        startDate = date.newInstance(soHeader.ASI_CRM_SG_Order_Date__c.year(), soHeader.ASI_CRM_SG_Order_Date__c.month(), 1);
        endDate = date.newInstance(soHeader.ASI_CRM_SG_Order_Date__c.year(), soHeader.ASI_CRM_SG_Order_Date__c.month(), date.daysInMonth(soHeader.ASI_CRM_SG_Order_Date__c.year(), soHeader.ASI_CRM_SG_Order_Date__c.month()));
        
        //20170527
        for(ASI_CRM_Item_Group_Allocation__c allocationItem : [SELECT id
                                                               , ASI_CRM_Allocation_Quantity_Bottle__c
                                                               , ASI_CRM_Item_Group__c
                                                               , ASI_CRM_MTD_Order_Quantity__c
                                                               , ASI_CRM_MTD_Order_Quantity_CA__c
                                                               , ASI_CRM_Remaining_Qty_BT__c
                                                               , ASI_CRM_Remaining_Qty_CA__c
                                                               FROM ASI_CRM_Item_Group_Allocation__c
                                                               WHERE ASI_CRM_Effective_Date__c >= : startDate
                                                               AND ASI_CRM_Effective_Date__c <= : endDate
                                                               AND ASI_CRM_Commercial_Team__c = : soHeader.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c
                                                               AND ASI_CRM_Region__c = : soHeader.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                               AND recordType.developerName Like '%_CN_%'
                                                              ]){
                                                                  
                                                                  allocationMap.put(allocationItem.ASI_CRM_Item_Group__c, allocationItem);
                                                              }
        
        if(soHeader.ASI_CRM_CN_RTD__c == TRUE)
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='RTD' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        //20160926, added by Leo
        else if(soHeader.ASI_CRM_CN_Premium__c == TRUE)
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='Premium' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        //20160926, added by Leo
        else
            ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>([SELECT id, ASI_CRM_Customer__c, ASI_CRM_Order_Form__c FROM ASI_CRM_Order_Form_Customer_Relationship__c WHERE ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c ='Normal Item' AND ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship']);
        
        
        for(ASI_CRM_Order_Form_Customer_Relationship__c obj : ofcrList)
            mapOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
        
        
        system.debug('check007 ' + mapOrderForm.get(soHeader.ASI_CRM_CN_Customer__c));
        List<ASI_CRM_Order_Form_Detail__c> ofList = new List<ASI_CRM_Order_Form_Detail__c>([SELECT id, ASI_CRM_Product_Name__c, ASI_CRM_Sequence__c, ASI_CRM_Remark__c FROM ASI_CRM_Order_Form_Detail__c WHERE ASI_CRM_Order_Form__c =: mapOrderForm.get(soHeader.ASI_CRM_CN_Customer__c)]);
        Map<id, ASI_CRM_Order_Form_Detail__c> mapOrderFormRemark = new Map<id, ASI_CRM_Order_Form_Detail__c>();
        Set<ID> itemGroupID = new Set<id>();
        for(ASI_CRM_Order_Form_Detail__c obj : ofList){
            itemGroupID.add(obj.ASI_CRM_Product_Name__c);
            mapOrderFormRemark.put(obj.ASI_CRM_Product_Name__c, obj);
        }
        
        List<ASI_CRM_Item_Group_Customer_Price__c> itemGroupCustomerPrice = new List<ASI_CRM_Item_Group_Customer_Price__c>([SELECT ASI_CRM_Customer__c
                                                                                                                            , ASI_CRM_Item_Group__c
                                                                                                                            , ASI_CRM_Price_Type__c
                                                                                                                            , ASI_CRM_Promotion_Code__c
                                                                                                                            , ASI_CRM_Promotion_Expiration_Date__c
                                                                                                                            , ASI_CRM_Unit_Price_BT__c
                                                                                                                            , ASI_CRM_Promotion_Code__r.Name
                                                                                                                            , ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c
                                                                                                                            , ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c
                                                                                                                            , ASI_CRM_Effective_Date_To__c//20161122
                                                                                                                            FROM ASI_CRM_Item_Group_Customer_Price__c WHERE ASI_CRM_Customer__c = : soHeader.ASI_CRM_CN_Customer__c//ASI_CRM_Promotion_Expiration_Date__c >=: todayDate
                                                                                                                           ]);
        
        Map<String, ASI_CRM_Item_Group_Customer_Price__c> mapPromotionCode = new Map<String, ASI_CRM_Item_Group_Customer_Price__c>();
        Map<String, ASI_CRM_Item_Group_Customer_Price__c> mapCustomerPrice = new Map<String, ASI_CRM_Item_Group_Customer_Price__c>();
        Set<id> ihbrItemGroup = new Set<id>();
        
        for(ASI_CRM_Item_Group_Customer_Price__c obj : itemGroupCustomerPrice){
            if(obj.ASI_CRM_Promotion_Expiration_Date__c >= todayDate)
                mapPromotionCode.put(obj.ASI_CRM_Customer__c + '' + obj.ASI_CRM_Item_Group__c, obj);
            mapCustomerPrice.put(obj.ASI_CRM_Customer__c + '' + obj.ASI_CRM_Item_Group__c, obj);
            
            //if(obj.ASI_CRM_Price_Type__c != 'T1')
            ihbrItemGroup.add(obj.ASI_CRM_Item_Group__c);
        }
        
        List<ASI_HK_CRM_NormalProduct> result = new List<ASI_HK_CRM_NormalProduct>();
        List<ASI_MFM_Item_Group__c> skuList = new List<ASI_MFM_Item_Group__c>();
        
        if(!soHeader.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c){
            skuList = [SELECT Id, Name, ASI_CRM_CN_pack__c, ASI_MFM_Sub_brand__c, ASI_MFM_Sub_brand__r.Name, ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c
                       , ASI_CRM_CN_BT_Size_C__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_Converion9L_C__c
                       , ASI_CRM_CN_Pack_Value__c, ASI_MFM_Item_Group_Code__c
                       , ASI_CRM_Allocation_Information__c//20170205 Elufa
                       FROM ASI_MFM_Item_Group__c
                       WHERE ID IN : itemGroupID
                       ORDER BY Name
                      ];
        }else{
            //20160503 Ben @ Elufa
            List<ASI_MFM_SKU_Code__c> tmpSKU = new List<ASI_MFM_SKU_Code__c>([SELECT ASI_MFM_Item_Group__c FROM ASI_MFM_SKU_Code__c 
                                                                              WHERE ASI_MFM_Item_Group__c IN : ihbrItemGroup 
                                                                              AND (ASI_CRM_SKU_Status__c LIKE '%000%' OR ASI_CRM_SKU_Status__c LIKE '%001%' OR ASI_CRM_SKU_Status__c LIKE '%997%')]);
            
            Set<Id> ihbrItemGroup2 = new Set<Id>();
            for(ASI_MFM_SKU_Code__c obj : tmpSKU)
                ihbrItemGroup2.add(obj.ASI_MFM_Item_Group__c);
            //20160503 End
            
            skuList = [SELECT Id, Name, ASI_CRM_CN_pack__c, ASI_MFM_Sub_brand__c, ASI_MFM_Sub_brand__r.Name, ASI_MFM_Sub_brand__r.ASI_HK_CRM_SYS_Brand_Type__c
                       , ASI_CRM_CN_BT_Size_C__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name, ASI_CRM_CN_Converion9L_C__c
                       , ASI_CRM_CN_Pack_Value__c, ASI_MFM_Item_Group_Code__c
                       , ASI_CRM_Allocation_Information__c//20170205 Elufa
                       FROM ASI_MFM_Item_Group__c
                       WHERE ID IN : ihbrItemGroup2
                       ORDER BY Name
                      ];
        }
        
        for (ASI_MFM_Item_Group__c sku : skuList) {
            ASI_HK_CRM_NormalProduct pd = new ASI_HK_CRM_NormalProduct();
            pd.id = sku.Id;
            pd.qty9Lfactor = sku.ASI_CRM_CN_Converion9L_C__c;
            pd.code = null;
            pd.remark = mapOrderFormRemark.containsKey(sku.id) ? mapOrderFormRemark.get(sku.id).ASI_CRM_Remark__c : '';
            pd.sequence = mapOrderFormRemark.containsKey(sku.id) ? mapOrderFormRemark.get(sku.id).ASI_CRM_Sequence__c : NULL;
            pd.name = sku.Name;
            pd.uom = soHeader.ASI_CRM_UOM__c != '' && soHeader.ASI_CRM_UOM__c != NULL ? soHeader.ASI_CRM_UOM__c : soHeader.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Order_by_BT__c ? 'BT' : 'CA' ;
            pd.promotionCodeID = mapPromotionCode.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id) ? mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Code__c : null;
            pd.promotionCodeName = pd.promotionCodeID != null ? mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Code__r.Name : null ;
            pd.promotionExpirationDate = pd.promotionCodeID != null ? String.valueOf( mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Expiration_Date__c.year() + '-' + 
                                                                                     mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Expiration_Date__c.month() + '-' + 
                                                                                     mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Expiration_Date__c.day() ) : null ;
            pd.price = mapCustomerPrice.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id) ? ( mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Unit_Price_BT__c * 1.16 ).setScale(3) : null;//20180430 Introv Changed Tax Rate From 17% to 16%
            pd.unitPriceSource = pd.price != null ? mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Price_Type__c : null ;
            pd.buyX = pd.promotionCodeID != null ? mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c : null;
            pd.getY = pd.promotionCodeID != null ? mapPromotionCode.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c : null;
            pd.subBrandId = sku.ASI_MFM_Sub_brand__c;
            pd.subBrandLabel = sku.ASI_MFM_Sub_brand__c != null ? sku.ASI_MFM_Sub_brand__r.Name : '';
            pd.inventory = null;
            pd.itemGroupCode = sku.ASI_MFM_Item_Group_Code__c;
            //20161122 Elufa
            pd.effectiveDateTo = mapCustomerPrice.containsKey(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id) && mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Effective_Date_To__c != Null ? mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Effective_Date_To__c.year() + '-' + mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Effective_Date_To__c.month() + '-' + mapCustomerPrice.get(soHeader.ASI_CRM_CN_Customer__c + '' + sku.id).ASI_CRM_Effective_Date_To__c.day() : Null;
            
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
            pd.pack = sku.ASI_CRM_CN_Pack_Value__c != NULL ? sku.ASI_CRM_CN_Pack_Value__c : 0;
            pd.stdNum = null;
            pd.dummy = null;
            //20170205 Elufa
            pd.hasAllocation = sku.ASI_CRM_Allocation_Information__c;
            //20170527
            pd.allocatedQty_BT = allocationMap.containsKey(sku.id) && allocationMap.get(sku.id).ASI_CRM_Remaining_Qty_BT__c != Null ? '' + allocationMap.get(sku.id).ASI_CRM_Remaining_Qty_BT__c : '';
            pd.allocatedQty_CA = allocationMap.containsKey(sku.id) && allocationMap.get(sku.id).ASI_CRM_Remaining_Qty_CA__c != Null ? '' + allocationMap.get(sku.id).ASI_CRM_Remaining_Qty_CA__c : '';
            
            result.add(pd);
        }
        for(ASI_HK_CRM_NormalProduct str2: result){
            System.debug('kkl.6 normal product list'+str2);
        }
        return result;
    }
    
    @RemoteAction
    public static ASI_HK_CRM_SaveResult saveChanges(String headerId, List<ASI_HK_CRM_SOLineItem> remoteLineItems) {
        ASI_HK_CRM_SaveResult result = new ASI_HK_CRM_SaveResult();
        result.success = false;
        
        try {
            if (isNonEmptyId(headerId)) {
                Map<ID, ASI_KOR_Sales_Order_Transaction__c> existingLineItemMap = new Map<ID, ASI_KOR_Sales_Order_Transaction__c>(
                (List<ASI_KOR_Sales_Order_Transaction__c>)[
                    SELECT Id, LastModifiedDate
                    FROM ASI_KOR_Sales_Order_Transaction__c
                    WHERE ASI_KOR_Sales_Order_Request__c = :headerId
                    FOR UPDATE
                ]);
                
                Set<ID> newIdSet = new Set<ID>();
                List<ASI_KOR_Sales_Order_Transaction__c> insertLineItems = new List<ASI_KOR_Sales_Order_Transaction__c>();
                List<ASI_KOR_Sales_Order_Transaction__c> updateLineItems = new List<ASI_KOR_Sales_Order_Transaction__c>();
                List<ASI_KOR_Sales_Order_Transaction__c> deleteLineItems = new List<ASI_KOR_Sales_Order_Transaction__c>();
                if (remoteLineItems != null) {
                    for (ASI_HK_CRM_SOLineItem remoteLineItem : remoteLineItems) {
                        if (remoteLineItem.id != null && remoteLineItem.id.trim() != '') {
                            ASI_KOR_Sales_Order_Transaction__c lineItem = existingLineItemMap.get(remoteLineItem.id);
                            if (lineItem != null) {
                                updateLineItemFromRemote(lineItem, remoteLineItem);
                                updateLineItems.add(lineItem);
                                newIdSet.add(remoteLineItem.id);
                            } else {
                                result.messages.add(String.format('Line item with ID {0} is not found', new String[] {remoteLineItem.id}));
                                break;
                            }
                        } else {
                            ASI_KOR_Sales_Order_Transaction__c lineItem = new ASI_KOR_Sales_Order_Transaction__c();
                            updateLineItemFromRemote(lineItem, remoteLineItem);
                            lineItem.ASI_KOR_Sales_Order_Request__c = headerId;
                            insertLineItems.add(lineItem);
                        }
                    }
                }
                
                if (existingLineItemMap.size() != newIdSet.size()) {
                    for (ASI_KOR_Sales_Order_Transaction__c existingLineItem : existingLineItemMap.values()) {
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
    private static void updateLineItemFromRemote(ASI_KOR_Sales_Order_Transaction__c lineItem, ASI_HK_CRM_SOLineItem remoteLineItem) {
        
        if (remoteLineItem.id != null && remoteLineItem.id.trim() != '') lineItem.Id = remoteLineItem.id;
        lineItem.ASI_CRM_CN_Product_Name__c = remoteLineItem.skuId;
        lineItem.RecordTypeId = Global_RecordTypeCache.getRtID('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item');
        lineitem.ASI_KOR_Order_Qty__c = remoteLineItem.qty;
        lineItem.ASI_CRM_UOM_Text__c = remoteLineItem.uomText;
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
    
    public class ASI_HK_CRM_SOLineItem {
        public String id { get; set; }
        public String skuId { get; set; }
        public String skuLabel { get; set; }
        public Decimal skuInventory { get; set; }
        public String subBrandId { get; set; }
        public String subBrandLabel { get; set; }
        public String brandType { get; set; }
        public Decimal qty { get; set; }
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
        public Decimal price { get; set; }
        public Decimal amount { get; set; }
        public Boolean available { get; set; }
        public Boolean isPOS { get; set; }
        public Decimal stdNum { get; set; }   //Std. Bottle Size
        public Decimal pack { get; set; }
        public Decimal sequence { get; set; }
        public string uomText { get; set; }
        public string itemGroupCode { get; set; }
        Public String effectiveDateTo { get; set; }//20161112 Elufa
        Public Boolean hasAllocation { get; set; }//20170205 Elufa
        Public String allocatedQty_BT {get; set;}//20170527 Introv
        Public String allocatedQty_CA {get; set;}//20170527 Introv
    }
    
    public virtual class ASI_HK_CRM_SKU {
        public String uom { get; set; }
        public Decimal qty { get; set; }
        public String id { get; set; }
        public String code { get; set; }
        public String remark { get; set; }
        public String name { get; set; }
        public Decimal buyX { get; set; }
        public Decimal getY { get; set; }
        Public String promotionCodeID { get; Set; }
        public String promotionCodeName { get; set; }
        Public String promotionExpirationDate { get; set; }
        public String unitPriceSource { get; set; }
        public Decimal qty9Lfactor { get; set; }
        public String subBrandId { get; set; }
        public String subBrandLabel { get; set; }
        public string packaging { get; set; }
        public Decimal price { get; set; }
        public Decimal inventory { get; set; }
        public String brandType { get; set; }
        public Decimal stdNum { get; set; }     //Std. Bottle Size
        public String dummy { get; set; }
        public Decimal pack { get; set; }
        public Decimal sequence { get; set; }
        public string itemGroupCode { get; set; }
        Public String effectiveDateTo { get; set; }//20161112 Elufa
        Public Boolean hasAllocation { get; set; }//20170205 Elufa
        Public String allocatedQty_BT {get; set;}//20170527 Introv
        Public String allocatedQty_CA {get; set;}//20170527 Introv
    }
    
    public class ASI_HK_CRM_NormalProduct extends ASI_HK_CRM_SKU {
    }
    
    public class ASI_HK_CRM_POSProduct extends ASI_HK_CRM_SKU {
    }
    
    public class ASI_HK_CRM_DataTableServerInput {
        public String name;
        public Object value;
    }
    
    public class ASI_HK_CRM_SaveResult {
        public Boolean success { get; set; }
        public List<String> messages { get; set; }
        
        public ASI_HK_CRM_SaveResult() {
            this.messages = new List<String>();
        }
    }
}