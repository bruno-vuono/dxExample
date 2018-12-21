/*********************************************************************************
 * Name : ASI_CRM_JP_AssignCustomProductPriceName
 * Description : Auto assign the customer producte price record's name
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 02/03/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_JP_AssignCustomProductPriceName extends ASI_CRM_JP_TriggerAbstract {
    
    private static final String DIRECT_SALES_RECORD_TYPE = 'ASI_CRM_JP_Direct_Sales_Product_Price';
    
    public ASI_CRM_JP_AssignCustomProductPriceName() {
		super('ASI_CRM_JP_AssignCustomProductPriceName');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	List<ASI_CRM_JP_Customer_Product_Price__c> priceList = (List<ASI_CRM_JP_Customer_Product_Price__c>) sObjList;
        
        Set<Id> itemGroupIdSet     = new Set<Id>();
        Set<Id> customerGroupIdSet = new Set<Id>();
        
        for(ASI_CRM_JP_Customer_Product_Price__c price : priceList) {
            if(price.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_JP_Customer_Product_Price__c' + DIRECT_SALES_RECORD_TYPE)) {
				itemGroupIdSet.add(price.ASI_MFM_Item_Group__c);
                customerGroupIdSet.add(price.ASI_CRM_Customer_Group__c);
            }
        }
        
        Map<Id, ASI_MFM_Item_Group__c> itemGroupMap;
        Map<Id, ASI_CRM_Customer_Group__c> customerGroupMap;
        
        itemGroupMap = retrieveItemGroupMap(itemGroupIdSet);
        customerGroupMap = retrieveCustomerGroupMap(customerGroupIdSet);
        
        for(ASI_CRM_JP_Customer_Product_Price__c price : priceList) {
            if(price.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_JP_Customer_Product_Price__c' + DIRECT_SALES_RECORD_TYPE)) {
                if(String.isNotBlank(price.ASI_MFM_Item_Group__c) &&
                   itemGroupMap.containsKey(price.ASI_MFM_Item_Group__c)) {
                    if(customerGroupMap.containsKey(price.ASI_CRM_Customer_Group__c)) {
                		price.Name = itemGroupMap.get(price.ASI_MFM_Item_Group__c).ASI_MFM_Item_Group_Code__c + '-';
                        price.Name += customerGroupMap.get(price.ASI_CRM_Customer_Group__c).Name + '-';
                    } else {
                        price.Name = itemGroupMap.get(price.ASI_MFM_Item_Group__c).ASI_MFM_Item_Group_Code__c + '-';
                    }
                    if(price.ASI_Effective_Date__c != null) {
                        List<String> effectiveDateSplitList = price.ASI_Effective_Date__c.format().split('/');
                        String effectiveDate = effectiveDateSplitList.get(0) 
                                             + effectiveDateSplitList.get(1) 
                                             + effectiveDateSplitList.get(2);
                        price.Name += effectiveDate;
                    }
                    if(price.ASI_Expiry_Date__c != null) {
                        List<String> expiryDateSplitList = price.ASI_Expiry_Date__c.format().split('/');
                        String expiryDate = expiryDateSplitList.get(0) 
                                             + expiryDateSplitList.get(1) 
                                             + expiryDateSplitList.get(2);
                        price.Name += expiryDate;
                    }
                }
            }
        }
        
    }
    
    /***************
	Data Retrievement Function
	***************/
    private Map<Id, ASI_MFM_Item_Group__c> retrieveItemGroupMap(Set<Id> itemGroupIdSet) {
		String query = 'SELECT Id, ASI_MFM_Item_Group_Code__c' + 
		               ', RecordType.DeveloperName ' + 
		               'FROM ASI_MFM_Item_Group__c ' + 
		               'Where Id in :itemGroupIdSet';
		return new Map<Id, ASI_MFM_Item_Group__c> ((List<ASI_MFM_Item_Group__c>) Database.query(query));
	}
    
    private Map<Id, ASI_CRM_Customer_Group__c> retrieveCustomerGroupMap(Set<Id> customerGroupIdSet) {
        String query = 'SELECT Id, Name' + 
		               ', RecordType.DeveloperName ' + 
		               'FROM ASI_CRM_Customer_Group__c ' + 
		               'Where Id in :customerGroupIdSet';
		return new Map<Id, ASI_CRM_Customer_Group__c> ((List<ASI_CRM_Customer_Group__c>) Database.query(query));
    }
}