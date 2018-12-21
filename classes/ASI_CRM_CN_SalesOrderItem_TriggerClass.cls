public without sharing class ASI_CRM_CN_SalesOrderItem_TriggerClass {
    
    Public Static Void beforeUpsertMethod(List<ASI_KOR_Sales_Order_Transaction__c> triggerNew){
        
        Set<ID> headerId = new Set<ID>();
        Set<ID> customerId = new Set<ID>();
        Set<ID> IHBRCusomterID = new Set<ID>();
        Set<ID> orderFormId = new Set<ID>();
        List<ASI_KOR_Sales_Order_Request__c> headerList = new List<ASI_KOR_Sales_Order_Request__c>();
        List<ASI_CRM_Order_Form_Customer_Relationship__c> ofcrList = new List<ASI_CRM_Order_Form_Customer_Relationship__c>();
        List<ASI_CRM_Order_Form_Detail__c> orderFormItem = new List<ASI_CRM_Order_Form_Detail__c>();
        Map<Id, Id> mapOrderForm = new Map<Id, Id>();
        Map<Id, Id> mapRTDOrderForm = new Map<Id, Id>();
        Map<Id, Id> mapPremiumOrderForm = new Map<Id, Id>();//20161019 Ben @ ELufa
        Map<Id, Id> mapCustomer = new Map<Id, Id>();
        Map<Id, Id> mapIHBRCustomer = new Map<Id, Id>();
        Map<Id, Map<id, ASI_CRM_Order_Form_Detail__c>> RTDItem = new Map<Id, Map<id, ASI_CRM_Order_Form_Detail__c>>();
        Map<Id, Map<id, ASI_CRM_Order_Form_Detail__c>> NormalItem = new Map<Id, Map<id, ASI_CRM_Order_Form_Detail__c>>();
        Map<Id, Map<id, ASI_CRM_Order_Form_Detail__c>> PremiumItem = new Map<Id, Map<id, ASI_CRM_Order_Form_Detail__c>>();//20161019 Ben @ Elufa
        Map<Id, Map<Id, ASI_CRM_Order_Form_Detail__c>> mapOrderFormItem = new Map<Id, Map<Id, ASI_CRM_Order_Form_Detail__c>>();
        List<ASI_CRM_Item_Group_Customer_Price__c> itemGroupCustomerPrice = new List<ASI_CRM_Item_Group_Customer_Price__c>();
        Map<Id, Map<Id, ASI_CRM_Item_Group_Customer_Price__c>> mapCustomerPrice = new Map<Id, Map<Id, ASI_CRM_Item_Group_Customer_Price__c>>();
        Map<Id, Map<Id, ASI_CRM_Item_Group_Customer_Price__c>> mapIHBRCustomerPrice = new Map<Id, Map<Id, ASI_CRM_Item_Group_Customer_Price__c>>();
        Date todayDate = Date.today();
        
        for(ASI_KOR_Sales_Order_Transaction__c obj : triggerNew){
            headerId.add(obj.ASI_KOR_Sales_Order_Request__c);
        }
        headerList = [SELECT id
                      , ASI_CRM_CN_RTD__c
                      , ASI_CRM_CN_Premium__c
                      , ASI_CRM_CN_Customer__c
                      , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c
                      , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c
                      , ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                      , ASI_CRM_SG_Order_Date__c
                      FROM ASI_KOR_Sales_Order_Request__c
                      WHERE ID IN : headerId
                      AND ASI_KOR_Order_Status__c LIKE 'Open'
                     ];
        
        if(headerList.size() > 0){
            
            for(ASI_KOR_Sales_Order_Request__c obj : headerList){
                
                if(!obj.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c){
                    mapCustomer.put(obj.id, obj.ASI_CRM_CN_Customer__c);
                    customerId.add(obj.ASI_CRM_CN_Customer__c);
                }else{
                    mapIHBRCustomer.put(obj.id, obj.ASI_CRM_CN_Customer__c);
                    IHBRCusomterID.add(obj.ASI_CRM_CN_Customer__c);
                }
            }
            
            itemGroupCustomerPrice = [SELECT ASI_CRM_Customer__c
                                      , ASI_CRM_Item_Group__c
                                      , ASI_CRM_Price_Type__c
                                      , ASI_CRM_Promotion_Code__c
                                      , ASI_CRM_Promotion_Expiration_Date__c
                                      , ASI_CRM_Unit_Price_BT__c
                                      , ASI_CRM_Promotion_Code__r.Name
                                      , ASI_CRM_Promotion_Code__r.ASI_CRM_Get_Y__c
                                      , ASI_CRM_Promotion_Code__r.ASI_CRM_Buy_X__c
                                      , ASI_CRM_Effective_Date_To__c //20161124 Elufa
                                      , ASI_CRM_Item_Group__r.ASI_CRM_Allocation_Information__c //20170206 Elufa
                                      FROM ASI_CRM_Item_Group_Customer_Price__c 
                                      WHERE (ASI_CRM_Customer__c IN : mapCustomer.values()
                                             OR ASI_CRM_Customer__c IN : mapIHBRCustomer.values()
                                            )
                                     ];
            
            if(itemGroupCustomerPrice.size() > 0){
                
                for(ASI_CRM_Item_Group_Customer_Price__c obj : itemGroupCustomerPrice){
                    
                    Map<Id, ASI_CRM_Item_Group_Customer_Price__c> tmpMap = new Map<Id, ASI_CRM_Item_Group_Customer_Price__c>();
                    
                    if(obj.ASI_CRM_Promotion_Expiration_Date__c < todayDate){
                        obj.ASI_CRM_Promotion_Code__c = NULL;
                    }
                    if(customerId.contains(obj.ASI_CRM_Customer__c)){
                        if(mapCustomerPrice.containsKey(obj.ASI_CRM_Customer__c))
                            tmpMap = mapCustomerPrice.get(obj.ASI_CRM_Customer__c);
                        
                        tmpMap.put(obj.ASI_CRM_Item_Group__c, obj);
                        
                        mapCustomerPrice.put(obj.ASI_CRM_Customer__c, tmpMap);
                    }else if(IHBRCusomterID.contains(obj.ASI_CRM_Customer__c)){
                        
                        if(mapIHBRCustomerPrice.containsKey(obj.ASI_CRM_Customer__c))
                            tmpMap = mapIHBRCustomerPrice.get(obj.ASI_CRM_Customer__c);
                        
                        tmpMap.put(obj.ASI_CRM_Item_Group__c, obj);
                        
                        mapIHBRCustomerPrice.put(obj.ASI_CRM_Customer__c, tmpMap);
                    }
                }
            }
            
            ofcrList = [SELECT id
                        , ASI_CRM_Customer__c
                        , ASI_CRM_Order_Form__c
                        , ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c
                        FROM ASI_CRM_Order_Form_Customer_Relationship__c
                        WHERE ( ASI_CRM_Customer__c IN : mapCustomer.values()
                               //OR ASI_CRM_Customer__c IN : mapIHBRCustomer.values()
                              )
                        AND RecordType.DeveloperName = 'ASI_CRM_CN_Order_Form_Customer_Relationship'
                       ];
            
            if(ofcrList.size() > 0){
                
                for(ASI_CRM_Order_Form_Customer_Relationship__c obj : ofcrList){
                    
                    if(obj.ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c == 'Normal Item'){
                        
                        mapOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
                    }else if(obj.ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c == 'RTD'){
                        
                        mapRTDOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
                    }else if(obj.ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c == 'Premium'){//20161019 Ben @ Elufa
                        
                        mapPremiumOrderForm.put(obj.ASI_CRM_Customer__c, obj.ASI_CRM_Order_Form__c);
                    }//20161019 End
                    orderFormId.add(obj.ASI_CRM_Order_Form__c);
                }
                
                orderFormItem = [SELECT id
                                 , ASI_CRM_Order_Form__c
                                 , ASI_CRM_Product_Name__c
                                 , ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c
                                 , ASI_CRM_Remark__c
                                 , ASI_CRM_Product_Name__r.ASI_CRM_Allocation_Information__c //20170206 Elufa
                                 FROM ASI_CRM_Order_Form_Detail__c
                                 WHERE ASI_CRM_Order_Form__c IN : orderFormId
                                ];
                
                if(orderFormItem.size() > 0){
                    for(ASI_CRM_Order_Form_Detail__c obj : orderFormItem){
                        if(obj.ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c == 'RTD'){
                            
                            Map<Id, ASI_CRM_Order_Form_Detail__c> itemGroupId = new Map<Id, ASI_CRM_Order_Form_Detail__c>();
                            
                            if(RTDItem.containsKey(obj.ASI_CRM_Order_Form__c))
                                itemGroupId = RTDItem.get(obj.ASI_CRM_Order_Form__c);
                            
                            itemGroupId.put(obj.ASI_CRM_Product_Name__c, obj);
                            
                            RTDItem.put(obj.ASI_CRM_Order_Form__c, itemGroupId);
                        }else if(obj.ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c == 'Normal Item'){
                            
                            Map<Id, ASI_CRM_Order_Form_Detail__c> itemGroupId = new Map<Id, ASI_CRM_Order_Form_Detail__c>();
                            
                            if(NormalItem.containsKey(obj.ASI_CRM_Order_Form__c))
                                itemGroupId = NormalItem.get(obj.ASI_CRM_Order_Form__c);
                            
                            itemGroupId.put(obj.ASI_CRM_Product_Name__c, obj);
                            
                            NormalItem.put(obj.ASI_CRM_Order_Form__c, itemGroupId);
                        }else if(obj.ASI_CRM_Order_Form__r.ASI_CRM_Order_Form_Type__c == 'Premium'){//20161019 Ben @ Elufa
                            
                            Map<Id, ASI_CRM_Order_Form_Detail__c> itemGroupId = new Map<Id, ASI_CRM_Order_Form_Detail__c>();
                            
                            if(PremiumItem.containsKey(obj.ASI_CRM_Order_Form__c))
                                itemGroupId = PremiumItem.get(obj.ASI_CRM_Order_Form__c);
                            
                            itemGroupId.put(obj.ASI_CRM_Product_Name__c, obj);
                            
                            PremiumItem.put(obj.ASI_CRM_Order_Form__c, itemGroupId);
                        }
                    }
                }
            }
            for(ASI_KOR_Sales_Order_Request__c obj : headerList){
                if(mapRTDOrderForm.containsKey(obj.ASI_CRM_CN_Customer__c) && RTDItem.containsKey(mapRTDOrderForm.get(obj.ASI_CRM_CN_Customer__c)) && obj.ASI_CRM_CN_RTD__c){
                    mapOrderFormItem.put(obj.id, RTDItem.get(mapRTDOrderForm.get(obj.ASI_CRM_CN_Customer__c)));
                }else if(mapPremiumOrderForm.containsKey(obj.ASI_CRM_CN_Customer__c) && PremiumItem.containsKey(mapPremiumOrderForm.get(obj.ASI_CRM_CN_Customer__c)) && obj.ASI_CRM_CN_Premium__c){//20161019 Ben @ Elufa
                    mapOrderFormItem.put(obj.id, PremiumItem.get(mapPremiumOrderForm.get(obj.ASI_CRM_CN_Customer__c)));
                }else if(mapOrderForm.containsKey(obj.ASI_CRM_CN_Customer__c) && NormalItem.containsKey(mapOrderForm.get(obj.ASI_CRM_CN_Customer__c)) && !obj.ASI_CRM_CN_RTD__c && !obj.ASI_CRM_CN_Premium__c){
                    mapOrderFormItem.put(obj.id, NormalItem.get(mapOrderForm.get(obj.ASI_CRM_CN_Customer__c)));
                }
            }
        }
        
        for(ASI_KOR_Sales_Order_Transaction__c obj : triggerNew){
            
            if(mapCustomer.containsKey(obj.ASI_KOR_Sales_Order_Request__c)){
                if(mapOrderFormItem.containsKey(obj.ASI_KOR_Sales_Order_Request__c) && !mapOrderFormItem.get(obj.ASI_KOR_Sales_Order_Request__c).containsKey(obj.ASI_CRM_CN_Product_Name__c)){
                    obj.addError('Invalid Item Group');
                    break;
                }else if(mapOrderFormItem.containsKey(obj.ASI_KOR_Sales_Order_Request__c) && mapOrderFormItem.get(obj.ASI_KOR_Sales_Order_Request__c).containsKey(obj.ASI_CRM_CN_Product_Name__c)){
                    
                    if(trigger.isInsert)//20170206 Elufa
                        obj.ASI_CRM_Allocation_Information__c = mapOrderFormItem.get(obj.ASI_KOR_Sales_Order_Request__c).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Product_Name__r.ASI_CRM_Allocation_Information__c;
                    
                    obj.ASI_CRM_CN_Remark__c = mapOrderFormItem.get(obj.ASI_KOR_Sales_Order_Request__c).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Remark__c;
                    if(mapCustomerPrice.containsKey(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c))){
                        obj.ASI_CRM_CN_Unit_Price_BT_with_VAT__c = mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Unit_Price_BT__c * 1.16 : NULL; //20180426 Introv Changed tax rate from 17% to 16%
                        obj.ASI_CRM_CN_Promotion_Code__c = mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Code__c : NULL;
                        obj.ASI_CRM_CN_Unit_Price_Source__c = mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Price_Type__c : NULL;
                        obj.ASI_CRM_CN_Promotion_Expiration_Date__c = mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapCustomerPrice.get(mapCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Expiration_Date__c : NULL;
                    }
                }
            }else if(mapIHBRCustomer.containsKey(obj.ASI_KOR_Sales_Order_Request__c) && mapIHBRCustomerPrice.containsKey(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c))){
                
                if(trigger.isInsert)//20170206 Elufa
                    obj.ASI_CRM_Allocation_Information__c = mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Item_Group__r.ASI_CRM_Allocation_Information__c : False;
                
                obj.ASI_CRM_CN_Unit_Price_BT_with_VAT__c = mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Unit_Price_BT__c * 1.16 : NULL; //20180426 Introv Changed tax rate from 17% to 16%
                obj.ASI_CRM_CN_Promotion_Code__c = mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Code__c : NULL;
                obj.ASI_CRM_CN_Unit_Price_Source__c = mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Price_Type__c : NULL;
                obj.ASI_CRM_CN_Promotion_Expiration_Date__c = mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Promotion_Expiration_Date__c : NULL;
                //20161124 Elufa
                obj.ASI_CRM_Effective_Date_To__c = mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).containsKey(obj.ASI_CRM_CN_Product_Name__c) ? mapIHBRCustomerPrice.get(mapIHBRCustomer.get(obj.ASI_KOR_Sales_Order_Request__c)).get(obj.ASI_CRM_CN_Product_Name__c).ASI_CRM_Effective_Date_To__c : NULL;
            }
        }
    }
    
    /*Public Static Map<String, ASI_CRM_Item_Group_Allocation__c> calculateRemainingQty(List<ASI_KOR_Sales_Order_Transaction__c> triggerNew, Set<id> regionSet, Set<Id> itemGroupSet, Set<String> commercialTeamSet, Date Startdate, Date endDate){
        
        Startdate = date.newInstance(Startdate.year(), Startdate.month(), 1);
        endDate = date.newInstance(endDate.year(), endDate.month(), date.daysInMonth(endDate.year(), endDate.month()));
        Set<Id> allocatedItemGroup = new Set<Id>();
        Map<String, ASI_CRM_Item_Group_Allocation__c> allocationMap = new Map<String, ASI_CRM_Item_Group_Allocation__c>();
        
        List<ASI_CRM_Item_Group_Allocation__c> allocationList = new List<ASI_CRM_Item_Group_Allocation__c>([SELECT id
                                                                                                            , ASI_CRM_Allocation_Quantity_Bottle__c
                                                                                                            , ASI_CRM_Commercial_Team__c
                                                                                                            , ASI_CRM_Effective_Date__c
                                                                                                            , ASI_CRM_Item_Group__c
                                                                                                            , ASI_CRM_Region__c
                                                                                                            , ASI_CRM_MTD_Order_Quantity__c
                                                                                                            FROM ASI_CRM_Item_Group_Allocation__c
                                                                                                            WHERE ASI_CRM_Effective_Date__c >= : startDate
                                                                                                            AND ASI_CRM_Effective_Date__c <= : endDate
                                                                                                            AND ASI_CRM_Item_Group__c IN : itemGroupSet
                                                                                                            AND ASI_CRM_Region__c IN : regionSet
                                                                                                            AND recordType.developerName Like '%_CN_%'
                                                                                                           ]);
        
        for(ASI_CRM_Item_Group_Allocation__c allocationItem : allocationList){
            
            String Key = '' + allocationItem.ASI_CRM_Item_Group__c + allocationItem.ASI_CRM_Region__c + allocationItem.ASI_CRM_Commercial_Team__c + String.valueOf(date.newInstance(allocationITem.ASI_CRM_Effective_Date__c.year(), allocationITem.ASI_CRM_Effective_Date__c.month(), 1));
            
            allocatedItemGroup.add(allocationItem.ASI_CRM_Item_Group__c);
            
            allocationItem.ASI_CRM_MTD_Order_Quantity__c = 0;
            allocationMap.put(Key, allocationItem);
        }
        
        List<ASI_KOR_Sales_Order_Transaction__c> allSOLines = new List<ASI_KOR_Sales_Order_Transaction__c>([SELECT id
                                                                                                            , ASI_CRM_CN_Product_Name__c
                                                                                                            , ASI_CRM_Order_Qty_Bottle__c
                                                                                                            , ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                                                                            , ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c
                                                                                                            , ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c
                                                                                                            , ASI_KOR_Sales_Order_Request__c
                                                                                                            FROM ASI_KOR_Sales_Order_Transaction__c
                                                                                                            WHERE ASI_CRM_CN_Product_Name__c IN : allocatedItemGroup
                                                                                                            AND id NOT IN : triggerNew
                                                                                                            AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c IN : regionSet
                                                                                                            AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c IN : commercialTeamSet
                                                                                                            AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c >= : startDate
                                                                                                            AND ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c <= : endDate
                                                                                                            AND (NOT ASI_KOR_Sales_Order_Request__r.ASI_KOR_Order_Status__c Like 'Open')
                                                                                                            AND RecordType.developerName Like '%_CN_%'
                                                                                                           ]);
        
        for(ASI_KOR_Sales_Order_Transaction__c obj : allSOLines){
            
            String key = '' + obj.ASI_CRM_CN_Product_Name__c + obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c + obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c + String.valueOf(date.newInstance(obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c.year(), obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c.month(), 1));
            
            if(allocationMap.containsKey(Key)){
                ASI_CRM_Item_Group_Allocation__c tmp = allocationMap.get(Key);
                tmp.ASI_CRM_MTD_Order_Quantity__c = tmp.ASI_CRM_MTD_Order_Quantity__c + obj.ASI_CRM_Order_Qty_Bottle__c;
                allocationMap.put(Key, tmp);
            }
        }
        
        Return allocationMap;
    }*/
}