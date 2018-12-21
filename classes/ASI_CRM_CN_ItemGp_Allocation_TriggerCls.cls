Public without Sharing class ASI_CRM_CN_ItemGp_Allocation_TriggerCls {

    Public Static void beforeInsertFunction(List<ASI_CRM_Item_Group_Allocation__c> triggerNew){
        
        calculateRemainingQty(triggerNew, Null);
    }
    
    Public Static void beforeUpdateFunction(List<ASI_CRM_Item_Group_Allocation__c> triggerNew, Map<Id, ASI_CRM_Item_Group_Allocation__c> triggerOldMap){
        
        calculateRemainingQty(triggerNew, triggerOldMap);
    }
    
    Public Static void calculateRemainingQty(List<ASI_CRM_Item_Group_Allocation__c> triggerNew, Map<Id, ASI_CRM_Item_Group_Allocation__c> triggerOldMap){
        
        Set<Id> regionSet = new Set<Id>();
        Set<Id> allocatedItemGroup = new Set<Id>();
        Set<String> commercialTeamSet = new Set<String>();
        Map<String, ASI_CRM_Item_Group_Allocation__c> allocationMap = new Map<String, ASI_CRM_Item_Group_Allocation__c>();
        Date startDate;
        Date endDate;
        
        for(ASI_CRM_Item_Group_Allocation__c obj : triggerNew){
            
            if( (!obj.ASI_CRM_Inactive__c && triggerOldMap == Null || !(obj.ASI_CRM_Inactive__c && triggerOldMap.get(obj.id).ASI_CRM_Inactive__c ))){
                regionSet.add(obj.ASI_CRM_Region__c);
                allocatedItemGroup.add(obj.ASI_CRM_Item_Group__c);
                commercialTeamSet.add(obj.ASI_CRM_Commercial_Team__c);
                
                if(startDate == Null || startDate > obj.ASI_CRM_Effective_Date__c)
                    startDate = obj.ASI_CRM_Effective_Date__c;
                
                if(endDate == Null || endDate < obj.ASI_CRM_Effective_Date__c)
                    endDate = obj.ASI_CRM_Effective_Date__c;
                
                String Key = '' + obj.ASI_CRM_Item_Group__c + obj.ASI_CRM_Region__c + obj.ASI_CRM_Commercial_Team__c + String.valueOf(date.newInstance(obj.ASI_CRM_Effective_Date__c.year(), obj.ASI_CRM_Effective_Date__c.month(), 1));
                
                obj.ASI_CRM_MTD_Order_Quantity__c = 0;
                
                allocationMap.put(Key, obj);
            }
        }
        
        endDate = endDate == Null ? date.today() : endDate;
        
        startDate = date.newInstance(endDate.year(), endDate.month(), 1);
        endDate = date.newInstance(endDate.year(), endDate.month(), date.daysInMonth(endDate.year(), endDate.month()));
        
        for(ASI_KOR_Sales_Order_Transaction__c obj : [SELECT id
                                                      , ASI_CRM_CN_Product_Name__c
                                                      , ASI_CRM_CN_Product_Name__r.Name
                                                      , ASI_CRM_Order_Qty_Bottle__c
                                                      , ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                      , ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c
                                                      , ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c
                                                      , ASI_KOR_Sales_Order_Request__c
                                                      FROM ASI_KOR_Sales_Order_Transaction__c
                                                      WHERE ASI_CRM_CN_Product_Name__c IN : allocatedItemGroup
                                                      AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c IN : regionSet
                                                      AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c IN : commercialTeamSet
                                                      AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c >= : startDate
                                                      AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c <= : endDate
                                                      AND (NOT ASI_KOR_Sales_Order_Request__r.ASI_KOR_Order_Status__c Like 'Open')
                                                      AND RecordType.developerName Like '%_CN_%']){
                                                          
                                                          String key = '' + obj.ASI_CRM_CN_Product_Name__c + obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c + obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c + String.valueOf(date.newInstance(obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c.year(), obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c.month(), 1));
                                                          
                                                          if(allocationMap.containsKey(key)){
                                                              
                                                              ASI_CRM_Item_Group_Allocation__c tmp = allocationMap.get(key);
                                                              tmp.ASI_CRM_MTD_Order_Quantity__c = tmp.ASI_CRM_MTD_Order_Quantity__c + obj.ASI_CRM_Order_Qty_Bottle__c;
                                                              allocationMap.put(key, tmp);
                                                          }
                                                      }
    }
}