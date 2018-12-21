public without sharing class ASI_CRM_CN_SalesOrderTriggerClass {
    
    Public Static Set<Id> allocationSet = new Set<Id>();
    
    Public Static Void beforeInsertMethod(List<ASI_KOR_Sales_Order_Request__c> triggerNew){
        
        Set<Id> customerIdSet = new Set<Id>();
        
        for(ASI_KOR_Sales_Order_Request__c obj : triggerNew){
            
            customerIdSet.add(obj.ASI_CRM_CN_Customer__c);
        }
        
        Map<id, ASI_CRM_AccountsAdditionalField__c> mapCustomer = new Map<Id, ASI_CRM_AccountsAdditionalField__c>([SELECT id, ASI_CRM_CN_Commercial_Team__c 
                                                                                                                   FROM ASI_CRM_AccountsAdditionalField__c
                                                                                                                   WHERE id IN : customerIdSet
                                                                                                                  ]);
        
        for(ASI_KOR_Sales_Order_Request__c obj : triggerNew){
            
            obj.ASI_CRM_SG_Order_Date__c = date.today();
            
            if(mapCustomer.containsKey(obj.ASI_CRM_CN_Customer__c) && mapCustomer.get(obj.ASI_CRM_CN_Customer__c).ASI_CRM_CN_Commercial_Team__c == 'Premium' )
                obj.ASI_CRM_CN_Premium__c = True;
        }
    }
    
    public static void beforeUpdateMethod(List<ASI_KOR_Sales_Order_Request__c> triggerNew, Map<id, ASI_KOR_Sales_Order_Request__c> triggerOldMap){
        
        Map<ID, User> mapUser = new Map<ID,User>([SELECT ID, Name, ManagerID FROM User WHERE CompanyName = 'Pernod Ricard China']); 
        Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixRoute = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
        Map<String, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRoute = new Map<String, ASI_CRM_Dynamic_Approval_Route__c>();
        Map<id, Boolean> isPromotionCodeExist = new Map<id, Boolean>();
        
        //20170525
        Set<Id> headerId = new Set<Id>();
        Map<Id, String> allOverSO = new Map<Id, String>();
        Set<Id> regionSet = new Set<Id>();
        Set<Id> itemGroupSet = new Set<Id>();
        Set<String> commercialTeamSet = new Set<String>();
        Date startDate;
        Date endDate;
        Boolean hasError = False;
        Boolean updateAllocationRecord = False;

        Map<id, ASI_KOR_Sales_Order_Request__c> mapSalesOrder = new Map<id, ASI_KOR_Sales_Order_Request__c>([SELECT id
                                                                                                        	 , ASI_CRM_CN_Customer__c
                                                                                                        	 , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c
                                                                                                        	 , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c
                                                                                                             , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Sub_Channel__r.Name
                                                                                                             , ASI_CRM_CN_Customer__r.ASI_CRM_VIP__c
                                                                                                             , ASI_CRM_CN_Customer__r.recordType.developerName
                                                                                                             , ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c //20160803 Ben @ Elufa
                                                                                                             , ASI_CRM_CN_Customer__r.ASI_CRM_CN_NewChannel__r.Name
                                                                                                             , ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                                                                        	 FROM ASI_KOR_Sales_Order_Request__c
                                                                                                        	 WHERE id IN: triggerNew
                                                                                                       		]);
        
        List<ASI_KOR_Sales_Order_Transaction__c> salesOrderLineItem = new List<ASI_KOR_Sales_Order_Transaction__c>([SELECT id
                                                                                                                    , ASI_CRM_CN_Promotion_Code__c
                                                                                                                    , ASI_KOR_Sales_Order_Request__c
                                                                                                                    , ASI_CRM_CN_Product_Name__c
                                                                                                                    , ASI_CRM_Order_Qty_Bottle__c
                                                                                                                    , ASI_CRM_CN_Product_Name__r.Name
                                                                                                                    , ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                                                                                    , ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c
                                                                                                                    , ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c
                                                                                                                    FROM ASI_KOR_Sales_Order_Transaction__c 
                                                                                                                    WHERE ASI_KOR_Sales_Order_Request__c IN: triggerNew
                                                                                                                   ]);
        
        List<ASI_CRM_Dynamic_Approval_Route__c> dynamicRoute = new List<ASI_CRM_Dynamic_Approval_Route__c>([SELECT id
                                                                                                            , ASI_CRM_End_of_Dynamic_Route__c
                                                                                                            , ASI_CRM_User__c
                                                                                                            , ASI_CRM_Type__c
                                                                                                            , ASI_CRM_Approval_Limit__c//20170515 Added
                                                                                                            FROM ASI_CRM_Dynamic_Approval_Route__c
                                                                                                            WHERE ASI_CRM_Type__c LIKE 'Sales Order%'
                                                                                                           ]);
        
        List<ASI_CRM_Fix_Approval_Route__c> fixRoute = new List<ASI_CRM_Fix_Approval_Route__c>([SELECT id
                                                                                                , ASI_CRM_CN_Type__c
                                                                                                , ASI_CRM_CN_Regional_BA__c
                                                                                                , ASI_CRM_CN_Approval_Limit_1__c
                                                                                                , ASI_CRM_CN_Approval_Limit_2__c
                                                                                                , ASI_CRM_CN_Approval_Limit_3__c
                                                                                                , ASI_CRM_CN_Approval_Limit_4__c
                                                                                                , ASI_CRM_CN_Approval_Limit_5__c
                                                                                                , ASI_CRM_CN_Approval_Limit_6__c
                                                                                                , ASI_CRM_CN_Approver_1__c
                                                                                                , ASI_CRM_CN_Approver_2__c
                                                                                                , ASI_CRM_CN_Approver_3__c
                                                                                                , ASI_CRM_CN_Approver_4__c
                                                                                                , ASI_CRM_CN_Approver_5__c
                                                                                                , ASI_CRM_CN_Approver_6__c
                                                                                                , ASI_CRM_CN_Region_Area_Channel__c
                                                                                                , ASI_CRM_IHBR__c
                                                                                                , ASI_CRM_VIP__c
                                                                                                , ASI_CRM_Channel__c
                                                                                                , ASI_CRM_Commercial_Team__c
                                                                                                , ASI_CRM_Channel__r.Name
                                                                                                FROM ASI_CRM_Fix_Approval_Route__c
                                                                                                WHERE ASI_CRM_CN_Type__c LIKE 'Sales Order%'
                                                                                               ]);
        
        for(ASI_KOR_Sales_Order_Request__c salesOrderObj : triggerNew){
            
            if(salesOrderObj.ASI_KOR_Order_Status__c == 'Submitted' && triggerOldMap.get(salesOrderObj.id).ASI_KOR_Order_Status__c == 'Open'){
                
                //20170525 sales order allocation logic
                regionSet.add(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c);
                commercialTeamSet.add(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c);
                
                if(startDate == Null || startDate > salesOrderObj.ASI_CRM_SG_Order_Date__c)
                    startDate = salesOrderObj.ASI_CRM_SG_Order_Date__c;
                
                if(endDate == Null || endDate < salesOrderObj.ASI_CRM_SG_Order_Date__c)
                    endDate = salesOrderObj.ASI_CRM_SG_Order_Date__c;
                
                //20170525 End
                
                headerId.add(salesOrderObj.id);
                
                //20170724 Introv
                updateAllocationRecord = True;
            }
            
            //20170724 Introv
            if(salesOrderObj.ASI_KOR_Order_Status__c == 'Open' && triggerOldMap.get(salesOrderObj.id).ASI_KOR_Order_Status__c == 'Submitted'){
                
                updateAllocationRecord = True;
            }
        }
        
        for(ASI_CRM_Dynamic_Approval_Route__c obj : dynamicRoute)
            mapDynamicRoute.put(obj.ASI_CRM_User__c + '' + obj.ASI_CRM_Type__c, obj);
        
        for(ASI_CRM_Fix_Approval_Route__c obj : fixRoute){
            if(obj.ASI_CRM_CN_Type__c == 'Sales Order - RTD'){
                if(obj.ASI_CRM_CN_Region_Area_Channel__c != null && obj.ASI_CRM_CN_Region_Area_Channel__c != '')
                	mapFixRoute.put(obj.ASI_CRM_CN_Type__c + obj.ASI_CRM_CN_Region_Area_Channel__c, obj);
                else
                    mapFixRoute.put(obj.ASI_CRM_CN_Type__c + '', obj);
            }else{
                
                String Key = obj.ASI_CRM_CN_Type__c;
                Key += obj.ASI_CRM_Commercial_Team__c != NULL ? obj.ASI_CRM_Commercial_Team__c : '';
                Key += obj.ASI_CRM_VIP__c ? 'TRUE' : 'FALSE';
                key += obj.ASI_CRM_IHBR__c ? 'TRUE' : 'FALSE';
                key += obj.ASI_CRM_Channel__c != NULL ? obj.ASI_CRM_Channel__r.Name : '';
                key += obj.ASI_CRM_CN_Region_Area_Channel__c != NULL ? obj.ASI_CRM_CN_Region_Area_Channel__c : '';
                
                mapFixRoute.put(key, obj);
            }
        }
        
        for(ASI_KOR_Sales_Order_Transaction__c obj : salesOrderLineItem){
            if(obj.ASI_CRM_CN_Promotion_Code__c != null)
            	isPromotionCodeExist.put(obj.ASI_KOR_Sales_Order_Request__c, TRUE);
            
            if(headerId.contains(obj.ASI_KOR_Sales_Order_Request__c) 
               && regionSet.contains(obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c)
               && commercialTeamSet.contains(obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c)
               && obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c >= startDate
               && obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c <= endDate
              ){
                  
                  itemGroupSet.add(obj.ASI_CRM_CN_Product_Name__c);
              }
        }
        
        //20170526
        if(itemGroupSet.size() > 0 )
            allOverSO = calculateRemainingQty(headerId, regionSet, itemGroupSet, commercialTeamSet, startDate, endDate);
        
        //Loop Trigger New
        for(ASI_KOR_Sales_Order_Request__c salesOrderObj : triggerNew){
            
            if(allOverSO.containsKey(salesOrderObj.id)){
                
                hasError = True;
                salesOrderObj.addError(allOverSo.get(salesOrderObj.id));
                break;
            }
            //20151103 Ben @ Elufa
            /*if(salesOrderLineItem.size() > 0 && triggerOldMap.get(salesOrderObj.id).ASI_CRM_UOM__c != salesOrderObj.ASI_CRM_UOM__c){
                salesOrderObj.addError('UOM can not be changed.');
                break;
            }*/
            
            //20160926, added by Leo
            if(salesOrderLineItem.size() > 0 && triggerOldMap.get(salesOrderObj.id).ASI_CRM_CN_Premium__c != salesOrderObj.ASI_CRM_CN_Premium__c){
                
                hasError = True;
                salesOrderObj.addError('Premium can not be changed.');
                break;
            }
            //20160926, added by Leo
            
            if(salesOrderLineItem.size() > 0 && triggerOldMap.get(salesOrderObj.id).ASI_CRM_CN_RTD__c != salesOrderObj.ASI_CRM_CN_RTD__c){
                
                hasError = True;
                salesOrderObj.addError('RTD can not be changed.');
                break;
            }
            
            if(triggerOldMap.get(salesOrderObj.id).ASI_CRM_CN_Customer__c != salesOrderObj.ASI_CRM_CN_Customer__c){
                
                hasError = True;
                salesOrderObj.addError('Customer can not be changed.');
                break;
            }
            
            if(!mapUser.containsKey(salesOrderObj.OwnerId)){
                
                hasError = True;
                salesOrderObj.addError('For Pernod Ricard China staff only.');
                break;
            }
            
            if(salesOrderObj.ASI_KOR_Order_Status__c != 'Open')
                Continue;
            
            setApproverToNull(salesOrderObj);
            
            //boolean wsManager = mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c ? FALSE : TRUE;//recordType.developerName == 'ASI_CRM_CN_WS' ? TRUE : FALSE;
            //20160803 Ben @ Elufa
            Boolean WSorOutlet = mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.recordType.developerName.Contains('ASI_CRM_CN_WS') ? TRUE : FALSE;
            String Key = 'Sales Order - ' + (WSorOutlet ? 'WS' : 'Outlet');
            
            if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c && mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c == 'HQ/Hotel'){
                setDynamicApprover(salesOrderObj, mapUser, mapDynamicRoute, 'Sales Order - IHBR');
            }
            
            //RTD
            if(salesOrderObj.ASI_CRM_CN_RTD__c){
                
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, ('Sales Order - RTD' + mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c));
            }else{
                
                Key += mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c != NULL ? mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c : '';
                Key += mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_NewChannel__r.Name == 'VIP' || mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_VIP__c ? 'TRUE' : 'FALSE';
                Key += mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c ? 'TRUE' : 'FALSE';
                Key += mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_NewChannel__c != NULL ? mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_NewChannel__r.Name : '';
                Key += mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c != NULL ? mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c : '';
                
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, Key);
            }
            
            //20160803 End
            
            //RTD
            /*if(salesOrderObj.ASI_CRM_CN_RTD__c){
                
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c, 'Sales Order - RTD', FALSE, wsManager);
            
            // VIP & E-Commerce
            //}else if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Sub_Channel__r.Name == 'VIP' || mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Sub_Channel__r.Name == 'E-Commerce'){
              
            }else if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Sub_Channel__r.Name == 'VIP' || mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_VIP__c){
                
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, '', 'Sales Order - VIP', FALSE, wsManager);
                
            }else if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Sub_Channel__r.Name == 'E-Commerce'){
                
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, '', 'Sales Order - eCommerce', FALSE, wsManager);
                
			//Dynamic Route
            //}else if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c || mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c == 'Headquarter'){
             
            }else if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c){
                
                setDynamicApprover(salesOrderObj, mapUser, mapDynamicRoute, 'Sales Order - IHBR');
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, '', 'Sales Order - IHBR', TRUE, wsManager);
                
            }else if(mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c == 'Headquarter'){
                
                setDynamicApprover(salesOrderObj, mapUser, mapDynamicRoute, 'Sales Order - HQ');
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, 'Headquarter', 'Sales Order - HQ', TRUE, wsManager);
                
			//Fix Route
            }else{
                setFixApprover(salesOrderObj, mapFixRoute, isPromotionCodeExist, mapSalesOrder.get(salesOrderObj.id).ASI_CRM_CN_Customer__r.ASI_CRM_CN_Region__c, 'Sales Order', FALSE, wsManager);
            }*/
        }
        
        if(!system.isBatch() && !system.isFuture() && updateAllocationRecord)
            updateAllocation(allocationSet);
    }
    
    @future
    Public Static void updateAllocation(Set<Id> allocationSet){
        
        if(allocationSet.size() > 0){
            try{
                
                List<ASI_CRM_Item_Group_Allocation__c> updateList = new List<ASI_CRM_Item_Group_Allocation__c>();
                
                for(id allocationId : allocationSet){
                    
                    updateList.add(new ASI_CRM_Item_Group_Allocation__c(id = allocationId));
                }
                
                Update updateList;
                
            }catch(dmlException dmle){
                
            }
        }
    }
    
    private static void setDynamicApprover(ASI_KOR_Sales_Order_Request__c salesOrderObj, Map<ID, User> mapUser, Map<String, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRoute, String dynamicApprovalType){
        
        ID approverID = mapUser.get(salesOrderObj.OwnerId).ManagerID;
        String sysApprover;
        
        for(integer i = 1 ; i <= 10 ; i++){
            
            sysApprover = 'ASI_CRM_CN_Sys_Approver_' + i + '__c';
            
            if(mapUser.containsKey(approverID)){
                
                salesOrderObj.put(sysApprover, approverID);
                
                if(mapDynamicRoute.containsKey(approverID + dynamicApprovalType)){
                    if(mapDynamicRoute.get(approverID + dynamicApprovalType).ASI_CRM_End_of_Dynamic_Route__c || (mapDynamicRoute.get(approverID + dynamicApprovalType).ASI_CRM_Approval_Limit__c != Null && salesOrderObj.ASI_CRM_CN_Total_order_Amt__c <= mapDynamicRoute.get(approverID + dynamicApprovalType).ASI_CRM_Approval_Limit__c)){
                    	break;
                    }
                }
                
                approverID = mapUser.get(approverID).ManagerID;
                
            }else break;
        }
    }
    
    private static void setFixApprover(ASI_KOR_Sales_Order_Request__c salesOrderObj, Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixRoute, Map<id, Boolean> isPromotionCodeExist, String Key){
        
        String fixApprover;
        String fixApproverLimit;
        String sysApprover;
        List<String> sysApproverList = new List<String>();
        integer j = 1;
        integer k = 1;
        integer x = 0;
            
        for(integer i = 1 ; i <= 10 ; i++){
            sysApprover = 'ASI_CRM_CN_Sys_Approver_' + i + '__c';
            if(salesOrderObj.get(sysApprover) == null){
                sysApproverList.add(sysApprover);
            }
        }
        
        while(k <= 6){
            
            fixApprover = 'ASI_CRM_CN_Approver_'+ k +'__c';
            fixApproverLimit = 'ASI_CRM_CN_Approval_Limit_'+ k +'__c';
            
            if(mapFixRoute.containsKey(Key)){
                
                if(mapFixRoute.get(Key).get(fixApprover) != null){
                    
                    salesOrderObj.put(sysApproverList[x], mapFixRoute.get(Key).get(fixApprover));
                    x++;
                    
                    if(x >= sysApproverList.size())
                        break;
                }
                
                if(mapFixRoute.get(Key).get(fixApproverLimit) != NULL && salesOrderObj.ASI_CRM_CN_Total_order_Amt__c <= Double.valueOf(mapFixRoute.get(Key).get(fixApproverLimit))){
                    BREAK;
                }
            }
            k++;
        }
        
        if(isPromotionCodeExist.containsKey(salesOrderObj.id)){
            
            while(j <= 10){
                if(salesOrderObj.get('ASI_CRM_CN_Sys_Approver_' + j + '__c') != null)
                    j++;
                else
                    break;
            }
            if(mapFixRoute.containsKey(Key))
            	salesOrderObj.put('ASI_CRM_CN_Sys_Approver_' + j + '__c', mapFixRoute.get(Key).ASI_CRM_CN_Regional_BA__c);
        }
    }
    
    public static void setApproverToNull(ASI_KOR_Sales_Order_Request__c salesOrderObj){
        
        String sysApprover;
        
        for(integer i = 1 ; i <=10 ; i++){
            sysApprover = 'ASI_CRM_CN_Sys_Approver_' + i + '__c';
            salesOrderObj.put(sysApprover,null);
        }
    }
    
    Private Static Map<Id, String> calculateRemainingQty(Set<Id> headerId, Set<id> regionSet, Set<Id> itemGroupSet, Set<String> commercialTeamSet, Date Startdate, Date endDate){
        
        Startdate = date.newInstance(Startdate.year(), Startdate.month(), 1);
        endDate = date.newInstance(endDate.year(), endDate.month(), date.daysInMonth(endDate.year(), endDate.month()));
        Set<Id> allocatedItemGroup = new Set<Id>();
        Map<Id, String> overAllocatedQty = new Map<Id, String>();
        Map<String, ASI_CRM_Item_Group_Allocation__c> allocationMap = new Map<String, ASI_CRM_Item_Group_Allocation__c>();
        allocationSet = new Set<Id>();
        
        for(ASI_CRM_Item_Group_Allocation__c allocationItem : [SELECT id
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
                                                               AND ASI_CRM_Inactive__c = False
                                                               AND recordType.developerName Like '%_CN_%'
                                                              ]){
            
            String Key = '' + allocationItem.ASI_CRM_Item_Group__c + allocationItem.ASI_CRM_Region__c + allocationItem.ASI_CRM_Commercial_Team__c + String.valueOf(date.newInstance(allocationITem.ASI_CRM_Effective_Date__c.year(), allocationITem.ASI_CRM_Effective_Date__c.month(), 1));
            
            allocatedItemGroup.add(allocationItem.ASI_CRM_Item_Group__c);
            
            allocationItem.ASI_CRM_MTD_Order_Quantity__c = 0;
            allocationMap.put(Key, allocationItem);
            allocationSet.add(allocationItem.id);
        }

        if(allocatedItemGroup.size() > 0){
            
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
                                                          AND ((NOT ASI_KOR_Sales_Order_Request__r.ASI_KOR_Order_Status__c Like 'Open')
                                                               OR ASI_KOR_Sales_Order_Request__c IN : headerId
                                                              )
                                                          AND RecordType.developerName Like '%_CN_%']){
                
                String key = '' + obj.ASI_CRM_CN_Product_Name__c + obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c + obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Commercial_Team__c + String.valueOf(date.newInstance(obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c.year(), obj.ASI_KOR_Sales_Order_Request__r.ASI_CRM_SG_Order_Date__c.month(), 1));
                
                if(allocationMap.containsKey(Key)){
                    ASI_CRM_Item_Group_Allocation__c tmp = allocationMap.get(Key);
                    tmp.ASI_CRM_MTD_Order_Quantity__c = tmp.ASI_CRM_MTD_Order_Quantity__c + obj.ASI_CRM_Order_Qty_Bottle__c;
                    allocationMap.put(Key, tmp);
                    
                    if(tmp.ASI_CRM_MTD_Order_Quantity__c > tmp.ASI_CRM_Allocation_Quantity_Bottle__c){
                        if(overAllocatedQty.containsKey(obj.ASI_KOR_Sales_Order_Request__c)){
                            
                            String msg = overAllocatedQty.get(obj.ASI_KOR_Sales_Order_Request__c) + ', ' + obj.ASI_CRM_CN_Product_Name__r.Name;
                            overAllocatedQty.put(obj.ASI_KOR_Sales_Order_Request__c, msg);
                            
                        }else{
                            
                            String msg = 'The following item groups over the allocated Qty: ' + obj.ASI_CRM_CN_Product_Name__r.Name;
                            overAllocatedQty.put(obj.ASI_KOR_Sales_Order_Request__c, msg);
                        }
                    }
                }
            }
            
            Return overAllocatedQty;
        }
        Return new Map<Id, String>();
    }
}