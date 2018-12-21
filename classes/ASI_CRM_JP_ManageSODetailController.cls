/*********************************************************************************
 * Name: ASI_CRM_JP_ManageSODetailController
 * Description: Controller class for JP Managing Sales Order Detail(Javascript).
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 20/02/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_JP_ManageSODetailController {

    //Inner class for storing the exception
    private class ExceptionWrapper {
        private Integer lineNumber            {get; set;}
        private String errorMessage           {get; set;}
        private List<String> fieldAPINameList {get; set;}

        private ExceptionWrapper(Integer lineNumber, String errorMessage) {
            this.lineNumber = lineNumber;
            this.errorMessage = errorMessage;
        }

        private ExceptionWrapper(Integer lineNumber, String errorMessage, List<String> fieldAPINameList) {
            this(lineNumber, errorMessage);
            this.fieldAPINameList = fieldAPINameList;
        }
    }

    //Record Type
    private final static String SKU_RECORD_TYPE_DEV_NAME               = 'ASI_CRM_JP_SKU';
    private final static String ITEM_AVAILABILITY_RECORD_TYPE_DEV_NAME = 'ASI_JP_CRM_DF_Item_Availability';

    //SO Record Type retrieve price with customer group
    private final static String DIRECT_SALES_RECORD_TYPE = 'ASI_CRM_JP_Direct_Sales';

    //SO Record Type need to retrieve price
    //Key = SO Record Type, Value = Item Base Price Record Type
    private final static Map<String, String> RETRIEVE_PRICE_RECORD_TYPE_MAP = new Map<String, String> {
        'ASI_CRM_JP_Normal_SO'      => 'ASI_CRM_JP_Duty_Paid_Product_Price',
        'ASI_CRM_JP_Employee_Sales' => 'ASI_CRM_JP_Employee_Product_Price',
        'ASI_CRM_JP_Direct_Sales'   => 'ASI_CRM_JP_Direct_Sales_Product_Price',
        'ASI_CRM_JP_Duty_Free_SO'   => 'ASI_CRM_JP_Duty_Free_Product_Price'
    };

    //Field Map
    private final static Map<String, Schema.SObjectField> SALES_ORDER_FIELD_MAP        = Schema.SObjectType.ASI_CRM_JP_Sales_Order__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> SALES_ORDER_DETAIL_FIELD_MAP = Schema.SObjectType.ASI_CRM_JP_Sales_Order_Item__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> ITEM_AVAILABILITY_FIELD_MAP  = Schema.SObjectType.ASI_CRM_JP_Item_Availability__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> SKU_FIELD_MAP                = Schema.SObjectType.ASI_MFM_SKU_Code__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> ITEM_PRICE_MAP               = Schema.SObjectType.ASI_CRM_JP_Customer_Product_Price__c.fields.getMap();

    //Parameter from VF Page Name
    private final static String SALES_ORDER_ID   = 'id';
    private final static String IS_QUICK_SAVE    = 'isQuickSave';
    private final static String UPSERT_DATA_JSON = 'upsertDataJson';
    private final static String REMOVE_DATA_JSON = 'removeDataJson';
    
    //COT User permission set
    private final static String COT_USER_PERMISSION_SET_LABEL = 'ASI CRM JP Supply Chain Add-On';
    //Duty Free User permission set
    private final static String DUTY_FREE_USER_PERMISSION_SET_LABEL = 'ASI CRM JP Duty Free User';

    //SO Record
    public ASI_CRM_JP_Sales_Order__c salesOrder                       {get; set;}
    private List<ASI_CRM_JP_Sales_Order_Item__c> salesOrderDetailList {get; set;}

    //Auto complete SKU Id/Name Map
    private Map<String, Id> skuNameIdMap {get; set;}
    private Map<String, Id> itemAvailabilityNameIdMap {get; set;}

    //Field API & Id Map
    private Map<String, Id> fieldIdMap {get; set;}

    //Picklist Value
    private Map<String, String> uomValueMap {get; set;}

    //Page Control
    public String salesOrderRecordTypeAPIName {get; set;}
    public String salesOrderRecordOrderType   {get; set;}
    public Boolean isCOTUser                  {get; set;}
    public Boolean isDutyFreeUser             {get; set;}

    //JSON String for VF Page
    public String salesOrderDetailListJson      {get {return toJsonString(salesOrderDetailList);}}
    public String skuNameIdMapJson              {get {return toJsonString(skuNameIdMap);}}
    public String itemAvailabilityNameIdMapJson {get {return toJsonString(itemAvailabilityNameIdMap);}}
    public String uomValueMapJson               {get {return toJsonString(uomValueMap);}}
    public String fieldIdMapJson                {get {return toJsonString(fieldIdMap);}}
    public String exceptionListJson             {get {return toJsonString(exceptionList);}}

    //Variable for VF Page
    public Boolean isEditable                   {get; set;}
    public String soDetailRecordTypeId          {get {return '';}}
    public Boolean hasError                     {get; set;}
    public List<ExceptionWrapper> exceptionList {get; set;}

    //Init function
    public ASI_CRM_JP_ManageSODetailController(ApexPages.StandardController standardController) {
        Id salesOrderId      = ApexPages.currentPage().getParameters().get(SALES_ORDER_ID);
        salesOrder           = retrieveSalesOrder(salesOrderId);
        salesOrderDetailList = retrieveSalesOrderDetailList(salesOrderId);
        uomValueMap          = retrievePicklistValues(ASI_CRM_JP_Sales_Order_Item__c.ASI_CRM_UOM__c.getDescribe());
        fieldIdMap           = retrieveFieldId();

        //Set SKU Map for auto complete
        skuNameIdMap = new Map<String, Id>();
        for(ASI_MFM_SKU_Code__c sku : retrieveSKUList()) {
            skuNameIdMap.put(sku.Name, sku.Id);
        }
        
        itemAvailabilityNameIdMap = new Map<String, Id>();
        for(ASI_CRM_JP_Item_Availability__c itemAvailability : retrieveItemAvailabilityMap(salesOrder.ASI_CRM_Branch_Plant__c)) {
            itemAvailabilityNameIdMap.put(itemAvailability.Name, itemAvailability.Id);
        }

        salesOrderRecordTypeAPIName = salesOrder.RecordType.DeveloperName;
        salesOrderRecordOrderType = salesOrder.ASI_CRM_Order_Type__c;
        checkUserType();
        
        if(salesOrder.ASI_CRM_Status__c == 'Submitted') {
            isEditable = false;
        } else {
            isEditable = true;
        }
    }

    private void checkUserType() {
        List<PermissionSetAssignment> permissionSetAssignment = [SELECT AssigneeId 
                                                                 FROM PermissionSetAssignment
                                                                 WHERE AssigneeId = :UserInfo.getUserId()
                                                                 AND PermissionSet.Label = :COT_USER_PERMISSION_SET_LABEL];
        if(permissionSetAssignment.size() > 0) {
            isCOTUser = true;
        } else {
            isCOTUser = false;
        }
        
        List<PermissionSetAssignment> dutyFreePermissionSetAssignment = [SELECT AssigneeId
                                                                         FROM PermissionSetAssignment
                                                                         WHERE AssigneeId = :UserInfo.getUserId()
                                                                         AND PermissionSet.Label = :DUTY_FREE_USER_PERMISSION_SET_LABEL];
        
        if(dutyFreePermissionSetAssignment.size() > 0) {
            isDutyFreeUser = true;
        } else {
            isDutyFreeUser = false;
        }
    }
    
    /***************
    View Action Handler
    ***************/
    public PageReference save() {
        hasError = false;

        Map<String, String> params = ApexPages.currentPage().getParameters();
        Boolean isQuickSave        = String.isBlank(params.get(IS_QUICK_SAVE)) ? false : Boolean.valueOf(params.get(IS_QUICK_SAVE));
        String upsertSODetailJson  = params.get(UPSERT_DATA_JSON);
        String removeSODetailJson  = params.get(REMOVE_DATA_JSON);
        
        List<ASI_CRM_JP_Sales_Order_Item__c> upsertSODetailList;
        List<String> removeSODetailIdList;

        System.Savepoint databaseSavepoint = Database.setSavepoint();
        try {
            upsertSODetailList   = (List<ASI_CRM_JP_Sales_Order_Item__c>) fromJsonString(upsertSODetailJson, List<ASI_CRM_JP_Sales_Order_Item__c>.class);
            removeSODetailIdList = (List<String>) fromJsonString(removeSODetailJson, List<String>.class);

            //Mark delete the so detail records
            if(removeSODetailIdList != null && removeSODetailIdList.size() > 0) {
                List<ASI_CRM_JP_Sales_Order_Item__c> removeSODetailList = new List<ASI_CRM_JP_Sales_Order_Item__c>();
                for(String removeId : removeSODetailIdList) {
                    removeSODetailList.add(new ASI_CRM_JP_Sales_Order_Item__c(Id = removeId));
                }
                Database.delete(removeSODetailList);
            }

            //Upsert so detail records
            if(upsertSODetailList != null && upsertSODetailList.size() > 0) {
                //Map the sku name to id
                for(ASI_CRM_JP_Sales_Order_Item__c soItem : upsertSODetailList) {
                    if(skuNameIdMap.containsKey(soItem.ASI_CRM_SKU__c)) {
                        soItem.ASI_CRM_SKU__c = skuNameIdMap.get(soItem.ASI_CRM_SKU__c);
                    }
                    if(itemAvailabilityNameIdMap.containsKey(soItem.ASI_CRM_SKU_Item__c)) {
                    	soItem.ASI_CRM_SKU_Item__c = itemAvailabilityNameIdMap.get(soItem.ASI_CRM_SKU_Item__c);
                    }
                }
                Database.upsert(upsertSODetailList);
            }
        } catch(Exception e) {
            System.debug(e);
            exceptionList = new List<ExceptionWrapper>();
            if(e.getTypeName() == 'System.DmlException') {
                DmlException dmlException = (DmlException) e;
                for(Integer i = 0 ; i < dmlException.getNumDml() ; i++) {
                    ExceptionWrapper exceptionWrapper = new ExceptionWrapper(dmlException.getDmlIndex(i), dmlException.getDmlMessage(i), dmlException.getDmlFieldNames(i));
                    exceptionList.add(exceptionWrapper);
                }
            } else {
                ExceptionWrapper exceptionWrapper = new ExceptionWrapper(e.getLineNumber(), e.getMessage());
                exceptionList.add(exceptionWrapper);
            }
            hasError = true;
            Database.rollback(databaseSavepoint);
            return null;
        }

        PageReference pageRef = null;
        if(!isQuickSave) {
            pageRef = new PageReference('/' + salesOrder.Id);
            pageRef.setRedirect(true);
        } else {
            salesOrderDetailList = retrieveSalesOrderDetailList(salesOrder.Id);
        }
        return pageRef;
    }

    public PageReference cancel() {
        PageReference pageRef = new PageReference('/' + salesOrder.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
	
    /***************
    No in use
    ***************/
    /*
    private void assignItemAvailabilityToSODetail(List<ASI_CRM_JP_Sales_Order_Item__c> soDetailList) {
        //Set Item Available
        Set<Id> skuIdSet = new Set<Id>();
        for(ASI_CRM_JP_Sales_Order_Item__c soDetail : soDetailList) {
            skuIdSet.add(soDetail.ASI_CRM_SKU__c);
        }

        if(skuIdSet.size() > 0) {
            Map<String, ASI_CRM_JP_Item_Availability__c> itemAvailabilityMap = retrieveItemAvailabilityMap(skuIdSet, salesOrder.ASI_CRM_Branch_Plant__c);

            for(ASI_CRM_JP_Sales_Order_Item__c soDetail : soDetailList) {
                String key = salesOrder.ASI_CRM_Branch_Plant__c + '_' + soDetail.ASI_CRM_SKU__c;
                if(itemAvailabilityMap.containsKey(key)) {
                    soDetail.ASI_CRM_SKU_Item__c = itemAvailabilityMap.get(key).Id;
                }
            }
        }
    }
    */
	
    /***************
    No in use
    ***************/
    /*
    private void assignDefaultUnitPriceToSODetail(ASI_CRM_JP_Sales_Order__c salesOrder, List<ASI_CRM_JP_Sales_Order_Item__c> soDetailList) {
        if(RETRIEVE_PRICE_RECORD_TYPE_MAP.containsKey(salesOrder.RecordType.DeveloperName)) {
            Id customerId          = salesOrder.RecordType.DeveloperName == DIRECT_SALES_RECORD_TYPE ? null : salesOrder.ASI_CRM_Sold_To__c;
            Id customerGroupId     = salesOrder.RecordType.DeveloperName == DIRECT_SALES_RECORD_TYPE ? salesOrder.ASI_CRM_Sold_To__r.ASI_CRM_National_Group__c : null;
            String recordType      = RETRIEVE_PRICE_RECORD_TYPE_MAP.get(salesOrder.RecordType.DeveloperName);
            Set<Id> skuIdSet       = new Set<Id>();
            Set<Id> itemGroupIdSet = new Set<Id>();

            for(ASI_CRM_JP_Sales_Order_Item__c soDetail : soDetailList) {
                skuIdSet.add(soDetail.ASI_CRM_SKU__c);
            }
            
            Map<Id, ASI_MFM_SKU_Code__c> skuItemPriceMap = retrieveSKUItemGroupMap(skuIdSet);
            for(ASI_MFM_SKU_Code__c sku : skuItemPriceMap.values()) {
                itemGroupIdSet.add(sku.ASI_MFM_Item_Group__c);
            }

            Map<String, Decimal> itemPriceMap = retrieveItemPriceMap(customerId, customerGroupId, skuIdSet, itemGroupIdSet, recordType, salesOrder.ASI_CRM_JP_Price_Effective_Date__c);
            for(ASI_CRM_JP_Sales_Order_Item__c soDetail : soDetailList) {
                
                    Decimal unitPrice = 0;
                    if(salesOrder.RecordType.DeveloperName == DIRECT_SALES_RECORD_TYPE) {
                        String keyWithSKUAndCustomerGroup            = soDetail.ASI_CRM_SKU__c + '_' + customerGroupId;
                        String keyWithSKUAndEmptyCustomerGroup       = soDetail.ASI_CRM_SKU__c + '_';
                        String keyWithItemGroupAndCustomerGroup      = skuItemPriceMap.get(soDetail.ASI_CRM_SKU__c).ASI_MFM_Item_Group__c + '_' + customerGroupId;
                        String keyWithItemGroupAndEmptyCustomerGroup = skuItemPriceMap.get(soDetail.ASI_CRM_SKU__c).ASI_MFM_Item_Group__c + '_';
                        
                        if(itemPriceMap.containsKey(keyWithSKUAndCustomerGroup)) {
                            unitPrice = itemPriceMap.get(keyWithSKUAndCustomerGroup);
                        } else if(itemPriceMap.containsKey(keyWithSKUAndEmptyCustomerGroup)) {
                            unitPrice = itemPriceMap.get(keyWithSKUAndEmptyCustomerGroup);
                        } else if(itemPriceMap.containsKey(keyWithItemGroupAndCustomerGroup)) {
                            unitPrice = itemPriceMap.get(keyWithItemGroupAndCustomerGroup);
                        } else if(itemPriceMap.containsKey(keyWithItemGroupAndEmptyCustomerGroup)) {
                            unitPrice = itemPriceMap.get(keyWithItemGroupAndEmptyCustomerGroup);
                        }
                    } else {
                        String keyWithSKUAndCustomer            = soDetail.ASI_CRM_SKU__c + '_' + customerId;
                        String keyWithSKUAndEmptyCustomer       = soDetail.ASI_CRM_SKU__c + '_';
                        System.debug(skuItemPriceMap);
                        System.debug(soDetail.ASI_CRM_SKU__c);
                        String keyWithItemGroupAndCustomer      = skuItemPriceMap.get(soDetail.ASI_CRM_SKU__c).ASI_MFM_Item_Group__c + '_' + customerId;
                        String keyWithItmeGroupAndEmptyCustomer = skuItemPriceMap.get(soDetail.ASI_CRM_SKU__c).ASI_MFM_Item_Group__c + '_';
                        if(itemPriceMap.containsKey(keyWithSKUAndCustomer)) {
                            unitPrice = itemPriceMap.get(keyWithSKUAndCustomer);
                        } else if(itemPriceMap.containsKey(keyWithSKUAndEmptyCustomer)) {
                            unitPrice = itemPriceMap.get(keyWithSKUAndEmptyCustomer);
                        } else if(itemPriceMap.containsKey(keyWithItemGroupAndCustomer)) {
                            unitPrice = itemPriceMap.get(keyWithItemGroupAndCustomer);
                        } else if(itemPriceMap.containsKey(keyWithItmeGroupAndEmptyCustomer)) {
                            unitPrice = itemPriceMap.get(keyWithItmeGroupAndEmptyCustomer);
                        }
                    }
                    soDetail.ASI_CRM_JP_Base_Price__c = unitPrice;
                    if(soDetail.ASI_CRM_Unit_Price__c == null) {
                        soDetail.ASI_CRM_Unit_Price__c = unitPrice;
                    }
                
            }
        }
    }
    */

    /***************
    Data Retrievement Function
    ***************/
    private ASI_CRM_JP_Sales_Order__c retrieveSalesOrder(Id salesOrderId) {
        String query = 'SELECT ' + genQueryField(SALES_ORDER_FIELD_MAP) + 
                       ', RecordType.DeveloperName, ASI_CRM_Sold_To__r.ASI_CRM_National_Group__c ' + 
                       'FROM ASI_CRM_JP_Sales_Order__c ' + 
                       'Where Id = :salesOrderId';

        List<ASI_CRM_JP_Sales_Order__c> salesOrderList = (List<ASI_CRM_JP_Sales_Order__c>) Database.query(query);
        return salesOrderList.size() > 0 ? salesOrderList.get(0) : null;
    }

    private List<ASI_CRM_JP_Sales_Order_Item__c> retrieveSalesOrderDetailList(Id salesOrderId) {
        String query = 'SELECT ' + genQueryField(SALES_ORDER_DETAIL_FIELD_MAP) + 
                       ', ASI_CRM_SKU__r.Name, ASI_CRM_SKU__r.ASI_MFM_Item_Group__c, ASI_CRM_SKU_Item__r.Name ' + 
                       'FROM ASI_CRM_JP_Sales_Order_Item__c ' + 
                       'Where ASI_CRM_Sales_Order__c = :salesOrderId ' + 
                       'AND ASI_CRM_Status__c != \'980-Cancelled\' ' + 
                       'ORDER BY ASI_CRM_Sorting_Number__c ';

        return (List<ASI_CRM_JP_Sales_Order_Item__c>) Database.query(query);
    }
	
    /*
    private Map<String, ASI_CRM_JP_Item_Availability__c> retrieveItemAvailabilityMap(Set<Id> skuIdSet, String warehouseLocation) {
        String query = 'SELECT ' + genQueryField(ITEM_AVAILABILITY_FIELD_MAP) + 
                       ', ASI_SKU__r.ASI_HK_CRM_Packaging_Size__c ' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_JP_Item_Availability__c ' + 
                       'Where ASI_SKU__c in :skuIdSet ' + 
                       'AND ASI_Warehouse_Location__c = :warehouseLocation';

        List<ASI_CRM_JP_Item_Availability__c> itemAvailabilityList = (List<ASI_CRM_JP_Item_Availability__c>) Database.query(query);
        
        //Map the item availability by sku id and warehouse location
        Map<String, ASI_CRM_JP_Item_Availability__c> itemAvailabilityMap = new Map<String, ASI_CRM_JP_Item_Availability__c>();
        for(ASI_CRM_JP_Item_Availability__c itemAvailability : itemAvailabilityList) {
            String key = itemAvailability.ASI_Warehouse_Location__c + '_' + itemAvailability.ASI_SKU__c;
            itemAvailabilityMap.put(key, itemAvailability);
        }

        return itemAvailabilityMap;
    }
    */

    private List<ASI_MFM_SKU_Code__c> retrieveSKUList() {
        String query = 'SELECT ' + genQueryField(SKU_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_MFM_SKU_Code__c ' + 
                       'Where RecordType.DeveloperName = :SKU_RECORD_TYPE_DEV_NAME';
        return (List<ASI_MFM_SKU_Code__c>) Database.query(query);
    }

    
    private List<ASI_CRM_JP_Item_Availability__c> retrieveItemAvailabilityMap(String warehouseLocation) {
    	String query = 'SELECT ' + genQueryField(ITEM_AVAILABILITY_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_JP_Item_Availability__c ' + 
                       'Where RecordType.DeveloperName = :ITEM_AVAILABILITY_RECORD_TYPE_DEV_NAME ' + 
                       'And ASI_Quantity_Availability__c > 0 ' + 
                       'And ASI_Warehouse_Location__c = :warehouseLocation ';

        return (List<ASI_CRM_JP_Item_Availability__c>) Database.query(query);
    }
    
    /*
    private Map<Id, ASI_MFM_SKU_Code__c> retrieveSKUItemGroupMap(Set<Id> skuIdSet) {
        String query = 'SELECT Id, ASI_MFM_Item_Group__c ' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_MFM_SKU_Code__c ' + 
                       'Where Id in :skuIdSet';
        return new Map<Id, ASI_MFM_SKU_Code__c>((List<ASI_MFM_SKU_Code__c>) Database.query(query));
    }
    
    private Map<String, Decimal> retrieveItemPriceMap(Id customerId, Id customerGroupId, Set<Id> skuIdSet, Set<Id> itemGroupIdSet, String recordType, Date orderDate) {
        String query = 'SELECT ' + genQueryField(ITEM_PRICE_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_JP_Customer_Product_Price__c ' + 
                       'Where RecordType.DeveloperName = :recordType ';
        
        if(String.isNotBlank(customerGroupId)) {
            query += 'AND (ASI_CRM_Customer_Group__c = :customerGroupId OR ASI_CRM_Customer_Group__c = NULL) ';
        } else if(String.isNotBlank(customerId)) {
            query += 'AND (ASI_Customer_Name__c = :customerId OR ASI_Customer_Name__c = NULL) ';
        }

        query += ' AND (ASI_SKU_Lookup__c in :skuIdSet OR ASI_MFM_Item_Group__c in :itemGroupIdSet) ';
        query += ' AND ASI_Effective_Date__c <= :orderDate';
        query += ' AND ASI_CRM_JP_Active__c = true';
        query += ' ORDER BY ASI_Effective_Date__c DESC ';

        List<ASI_CRM_JP_Customer_Product_Price__c> itemPriceList = (List<ASI_CRM_JP_Customer_Product_Price__c>) Database.query(query);

        Map<String, Decimal> itemPriceMap = new Map<String, Decimal>();
        for(ASI_CRM_JP_Customer_Product_Price__c itemPrice : itemPriceList) {
            String keyWithSKUAndCustomer;
            String keyWithSKUAndCustomerGroup;
            String keyWithItemGroupAndCustomer;
            String keyWithItemGroupAndCustomerGroup;
            
            String customerIdInStr      = String.isNotBlank(itemPrice.ASI_Customer_Name__c) ? String.valueOf(itemPrice.ASI_Customer_Name__c) : '';
            String customerGroupIdInStr = String.isNotBlank(itemPrice.ASI_CRM_Customer_Group__c) ? String.valueOf(itemPrice.ASI_CRM_Customer_Group__c) : '';
            if(String.isNotBlank(itemPrice.ASI_SKU_Lookup__c)) {
                keyWithSKUAndCustomer            = itemPrice.ASI_SKU_Lookup__c + '_' + customerIdInStr;
                keyWithSKUAndCustomerGroup       = itemPrice.ASI_SKU_Lookup__c + '_' + customerGroupIdInStr;
            }
            if(String.isNotBlank(itemPrice.ASI_MFM_Item_Group__c)) {
                keyWithItemGroupAndCustomer      = itemPrice.ASI_MFM_Item_Group__c + '_' + customerIdInStr;
                keyWithItemGroupAndCustomerGroup = itemPrice.ASI_MFM_Item_Group__c + '_' + customerGroupIdInStr;
            }

            if(String.isNotBlank(customerGroupId)) {
                if(String.isNotBlank(keyWithSKUAndCustomerGroup) && itemPriceMap.containsKey(keyWithSKUAndCustomerGroup) == false) {
                    itemPriceMap.put(keyWithSKUAndCustomerGroup, itemPrice.ASI_Bottle_Price__c);
                }
                if(String.isNotBlank(keyWithItemGroupAndCustomerGroup) && itemPriceMap.containsKey(keyWithItemGroupAndCustomerGroup) == false) {
                    itemPriceMap.put(keyWithItemGroupAndCustomerGroup, itemPrice.ASI_Bottle_Price__c);
                }
            } else {
                if(String.isNotBlank(keyWithSKUAndCustomer) && itemPriceMap.containsKey(keyWithSKUAndCustomer) == false) {
                    itemPriceMap.put(keyWithSKUAndCustomer, itemPrice.ASI_Bottle_Price__c);
                }
                if(String.isNotBlank(keyWithItemGroupAndCustomer) && itemPriceMap.containsKey(keyWithItemGroupAndCustomer) == false) {
                    itemPriceMap.put(keyWithItemGroupAndCustomer, itemPrice.ASI_Bottle_Price__c);
                }
            }
        }

        return itemPriceMap;
    }
    */

    private Map<String, String> retrievePicklistValues(Schema.DescribeFieldResult fieldResult) {
  		Map<String, String> picklistValueMap = new Map<String, String>();

  		List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
  		for(Schema.PicklistEntry picklistEntry : picklistEntryList) {
    		picklistValueMap.put(picklistEntry.getLabel(), picklistEntry.getValue());
    	}

    	return picklistValueMap;
  	}

    private Map<String, Id> retrieveFieldId() {
        Map<String, String> tempFieldIdMap = new Map<String, String>();
        List<ASI_CRM_Field_ID_Mappings__c> fieldIdMappingList = ASI_CRM_Field_ID_Mappings__c.getAll().values();
        for(ASI_CRM_Field_ID_Mappings__c fieldIdMapping : fieldIdMappingList) {
            tempFieldIdMap.put(fieldIdMapping.ASI_CRM_Field_Name__c, fieldIdMapping.ASI_CRM_Field_ID__c.subString(0, 15));
        }
        return tempFieldIdMap;
    }

    /***************
    Tools Function
    ***************/
    private String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
        String queryField = '';
        for(String fields : fieldMap.keySet()) {
          queryField += fields + ',';
        }
        return queryField.subString(0, queryField.length() - 1);
    }

    private void throwException(String errorMessage, String[] parameterArray) {
        if(parameterArray != null) {
            errorMessage = String.format(errorMessage, parameterArray);
        }
        throw new VisualforceException(errorMessage);
    }

    private String toJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private List<Object> fromJsonString(String jsonString, System.Type apexType) {
        if(String.isBlank(jsonString)) {
            return null;
        }
        return (List<Object>) System.JSON.deserialize(jsonString, apexType);
    }

}