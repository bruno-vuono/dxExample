public without sharing class ASI_CRM_CN_IGCP_TriggerClass {
    
    public static void beforeUpsertMethod(List<ASI_CRM_Item_Group_Customer_Price__c> triggerNew){
        
        Set<id> customerIDSet = new Set<id>();
        Set<id> itemGroupIDSet = new Set<id>();
        
        for(ASI_CRM_Item_Group_Customer_Price__c obj : triggerNew){
            customerIDSet.add(obj.ASI_CRM_Customer__c);
            itemGroupIDSet.add(obj.ASI_CRM_Item_Group__c);
        }
        
        List<ASI_CRM_Price_And_Discount__c> priceAndDiscount = new List<ASI_CRM_Price_And_Discount__c>([SELECT id 
                                                                                                        , ASI_CRM_Effective_From__c
                                                                                                        , ASI_CRM_Effective_To__c
                                                                                                        , ASI_CRM_Customer__c
                                                                                                        , ASI_CRM_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c
                                                                                                        , (SELECT id
                                                                                                           , ASI_CRM_Promotion_Code__c
                                                                                                           , ASI_CRM_Item_Group_Description__c
                                                                                                           , ASI_CRM_Price_And_Discount__r.ASI_CRM_Effective_To__c
                                                                                                           , ASI_CRM_Price_And_Discount__c
                                                                                                           FROM Price_And_Discount_Details__r
                                                                                                           WHERE ASI_CRM_Item_Group_Description__c IN : itemGroupIDSet
                                                                                                           //AND 	ASI_CRM_Promotion_Code__c != NULL 20161122 Elufa
                                                                                                           AND recordType.DeveloperName = 'ASI_CRM_CN_Price_And_Discount_Detail'
                                                                                                          )
                                                                                                        FROM ASI_CRM_Price_And_Discount__c
                                                                                                        WHERE ASI_CRM_Effective_From__c <=: date.today()
                                                                                                        AND ASI_CRM_Effective_To__c >=: date.today()
                                                                                                        AND ASI_CRM_Customer__c IN : customerIDSet
                                                                                                        AND ( recordType.DeveloperName = 'ASI_CRM_CN_Customer_Price_and_Discount_Request'
                                                                                                             OR recordType.DeveloperName = 'ASI_CRM_CN_Customer_Price_and_Discount_Request_RO' )
                                                                                                        AND ( ASI_CRM_Status__c = 'Approved'
                                                                                                        	 OR ASI_CRM_Status__c = 'Completed' ) 
                                                                                                        ORDER BY ASI_CRM_Approved_Date__c desc
                                                                                                       ]);
        
        //Map<id, Map<id, ASI_CRM_Price_And_Discount_Detail__c>> mapPromtionCode = new Map<id, Map<id, ASI_CRM_Price_And_Discount_Detail__c>>();
        Map<String, ASI_CRM_Price_And_Discount_Detail__c> mapItemGroup = new Map<String, ASI_CRM_Price_And_Discount_Detail__c>();
        Set<Id> IHBRSet = new Set<Id>();
        for(ASI_CRM_Price_And_Discount__c obj : priceAndDiscount){
            
            if(obj.ASI_CRM_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c){
                IHBRSet.add(obj.ASI_CRM_Customer__c);
            }
            //Map<id, ASI_CRM_Price_And_Discount_Detail__c> mapItemGroup = new Map<id, ASI_CRM_Price_And_Discount_Detail__c>();
            
            for(ASI_CRM_Price_And_Discount_Detail__c detailObj : obj.Price_And_Discount_Details__r){
                //if(detailObj.ASI_CRM_Promotion_Code__c != null) 20161122
                if(!mapItemGroup.containsKey(obj.ASI_CRM_Customer__c + '' + detailObj.ASI_CRM_Item_Group_Description__c))
                    mapItemGroup.put(obj.ASI_CRM_Customer__c + '' + detailObj.ASI_CRM_Item_Group_Description__c, detailObj);
            }
            //mapPromtionCode.put(obj.ASI_CRM_Customer__c, mapItemGroup);
        }
        
        for(ASI_CRM_Item_Group_Customer_Price__c itemGroupCustomerPrice : triggerNew){
            
            itemGroupCustomerPrice.ASI_CRM_Promotion_Expiration_Date__c = null;
            itemGroupCustomerPrice.ASI_CRM_Price_And_Discount__c = null;
            itemGroupCustomerPrice.ASI_CRM_Promotion_Code__c = null;
            
            if(mapItemGroup.containsKey(itemGroupCustomerPrice.ASI_CRM_Customer__c + '' + itemGroupCustomerPrice.ASI_CRM_Item_Group__c)){
                
                itemGroupCustomerPrice.ASI_CRM_Promotion_Code__c = mapItemGroup.get(itemGroupCustomerPrice.ASI_CRM_Customer__c + '' + itemGroupCustomerPrice.ASI_CRM_Item_Group__c).ASI_CRM_Promotion_Code__c;
                
                if(itemGroupCustomerPrice.ASI_CRM_Promotion_Code__c != null){
                    itemGroupCustomerPrice.ASI_CRM_Promotion_Expiration_Date__c = mapItemGroup.get(itemGroupCustomerPrice.ASI_CRM_Customer__c + '' + itemGroupCustomerPrice.ASI_CRM_Item_Group__c).ASI_CRM_Price_And_Discount__r.ASI_CRM_Effective_To__c;
                    itemGroupCustomerPrice.ASI_CRM_Price_And_Discount__c = mapItemGroup.get(itemGroupCustomerPrice.ASI_CRM_Customer__c + '' + itemGroupCustomerPrice.ASI_CRM_Item_Group__c).ASI_CRM_Price_And_Discount__c;
                }
                if(IHBRSet.contains(itemGroupCustomerPrice.ASI_CRM_Customer__c)){
                    itemGroupCustomerPrice.ASI_CRM_Effective_Date_To__c = mapItemGroup.get(itemGroupCustomerPrice.ASI_CRM_Customer__c + '' + itemGroupCustomerPrice.ASI_CRM_Item_Group__c).ASI_CRM_Price_And_Discount__r.ASI_CRM_Effective_To__c;
                    itemGroupCustomerPrice.ASI_CRM_Price_And_Discount__c = mapItemGroup.get(itemGroupCustomerPrice.ASI_CRM_Customer__c + '' + itemGroupCustomerPrice.ASI_CRM_Item_Group__c).ASI_CRM_Price_And_Discount__c;
                }
            }
        }
    }
}