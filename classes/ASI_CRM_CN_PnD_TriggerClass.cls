public without sharing class ASI_CRM_CN_PnD_TriggerClass {
    
    static Map<id, ASI_CRM_Price_And_Discount__c> mapPnD; //20161011, added by Leo
    
    public static void beforeUpdateMedthod(List<ASI_CRM_Price_And_Discount__c> triggerNew, Map<id, ASI_CRM_Price_And_Discount__c> triggerOldMap){
        
        Map<String, Integer> statusValidtionMap = new Map<String, Integer>();
        Map<Integer, String> statusValidtionMap2 = new Map<Integer, String>();
        Map<id, RecordType> mapRT = new map<id, RecordType>([SELECT id,DeveloperName,Name FROM recordType WHERE sObjectType = 'ASI_CRM_Price_And_Discount__c']);
        Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixRoute = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
        Map<id, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRoute = new Map<id, ASI_CRM_Dynamic_Approval_Route__c>();
        Map<ID, User> mapUser = new Map<ID,User>([SELECT ID, Name, ManagerID FROM User WHERE CompanyName = 'Pernod Ricard China']);
        mapPnD = new Map<id, ASI_CRM_Price_And_Discount__c>([SELECT id
                                                             , ASI_CRM_Customer__r.ASI_CRM_CN_Region__c
                                                             , ASI_CRM_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c
                                                             , ASI_CRM_Customer__r.ASI_CRM_CN_NewChannel__r.Name//20160803 Ben @ Elufa
                                                             , ASI_CRM_Customer__r.ASI_CRM_CN_Commercial_Team__c
                                                             , ASI_CRM_Customer__r.ASI_CRM_VIP__c
                                                             , ASI_CRM_Customer__r.ASI_CRM_CN_Estimated_annual_order_amount__c //20161011, added by Leo
                                                             FROM ASI_CRM_Price_And_Discount__c WHERE id IN : triggerNew
                                                            ]);
        
        List<ASI_CRM_Price_And_Discount_Detail__c> lineItemList = new List<ASI_CRM_Price_And_Discount_Detail__c>([SELECT id
                                                                                                                  FROM ASI_CRM_Price_And_Discount_Detail__c 
                                                                                                                  WHERE ASI_CRM_Price_And_Discount__c IN : triggerNew
                                                                                                                 ]);
        
    	List<ASI_CRM_Dynamic_Approval_Route__c> dynamicRoute = new List<ASI_CRM_Dynamic_Approval_Route__c>([SELECT id
                                                                                                        	, ASI_CRM_End_of_Dynamic_Route__c
                                                                                                        	, ASI_CRM_User__c
                                                                                                        	, ASI_CRM_Type__c
                                                                                                        	FROM ASI_CRM_Dynamic_Approval_Route__c
                                                                                                        	WHERE ASI_CRM_Type__c LIKE 'Price%'
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
                                                                                            	FROM ASI_CRM_Fix_Approval_Route__c
                                                                                            	WHERE ASI_CRM_CN_Type__c LIKE 'Price%'
                                                                                               ]);
        
        for(ASI_CRM_Dynamic_Approval_Route__c obj : dynamicRoute)
            mapDynamicRoute.put(obj.ASI_CRM_User__c, obj);
        
        for(ASI_CRM_Fix_Approval_Route__c obj : fixRoute){
            if(obj.ASI_CRM_CN_Region_Area_Channel__c != null && obj.ASI_CRM_CN_Region_Area_Channel__c != '')
            	mapFixRoute.put(obj.ASI_CRM_CN_Type__c + obj.ASI_CRM_CN_Region_Area_Channel__c, obj);
            else
                mapFixRoute.put(obj.ASI_CRM_CN_Type__c + '', obj);
        }
        
        statusValidtionMap.put('Open', 1);
        statusValidtionMap.put('Pending for BO to PRCSW Pirce', 2);
        statusValidtionMap.put('Pending for PRCSW to PRC Price', 3);
        statusValidtionMap.put('Pending for T1 Price', 4);
        statusValidtionMap.put('Pending for add to order form', 5);
        statusValidtionMap.put('Completed', 6);
        statusValidtionMap2.put(1, 'Open');
        statusValidtionMap2.put(2, 'Pending for BO to PRCSW Pirce');
        statusValidtionMap2.put(3, 'Pending for PRCSW to PRC Price');
        statusValidtionMap2.put(4, 'Pending for T1 Price');
        statusValidtionMap2.put(5, 'Pending for add to order form');
        statusValidtionMap2.put(6, 'Completed');
        
        // Loop triggerNew
        for(ASI_CRM_Price_And_Discount__c PnDObj : triggerNew){
            
            if(triggerOldMap.get(PnDObj.id).ASI_CRM_Status__c != PnDObj.ASI_CRM_Status__c && mapRT.get(PnDObj.recordTypeid).DeveloperName == 'ASI_CRM_CN_NPL_T1_Price_Request' || mapRT.get(PnDObj.recordTypeid).DeveloperName == 'ASI_CRM_CN_NPL_T1_Price_Request_RO' || ( mapRT.get(PnDObj.recordTypeid).DeveloperName == 'ASI_CRM_CN_Repacking_Price_Request_RO' && triggerOldMap.get(PnDObj.id).ASI_CRM_Status__c == 'Pending for T1 Price' )){
                
                if( ( statusValidtionMap.get(PnDObj.ASI_CRM_Status__c) > statusValidtionMap.get( triggerOldMap.get(PnDObj.id).ASI_CRM_Status__c ) ) && statusValidtionMap.get(PnDObj.ASI_CRM_Status__c) != ( statusValidtionMap.get( triggerOldMap.get(PnDObj.id).ASI_CRM_Status__c ) + 1 )){
                    PnDObj.addError('Next status should be ' + statusValidtionMap2.get( ( statusValidtionMap.get( triggerOldMap.get(PnDObj.id).ASI_CRM_Status__c ) + 1 ) ) );
                    break;
                }
            }
            
            if(triggerOldMap.get(PnDObj.id).ASI_CRM_Customer__c != PnDObj.ASI_CRM_Customer__c){
                PnDObj.addError('Customer can not be changed.');
                break;
            }
            
            if(lineItemList.size() > 0 && triggerOldMap.get(PnDObj.id).ASI_CRM_RTD__c != PnDObj.ASI_CRM_RTD__c){
                PnDObj.addError('RTD can not be changed.');
                break;
            }
            
            if(!mapUser.containsKey(PnDObj.OwnerId)){
                PnDObj.addError('For Pernod Ricard China staff only.');
                break;
            }
            
            if(PnDObj.ASI_CRM_Status__c == 'Open'){
            
            	setApproverToNull(PnDObj);
            
            	if(mapRT.get(PnDObj.RecordTypeId).DeveloperName == 'ASI_CRM_CN_Repacking_Price_Request'){
                
                	setFixApprover(PnDObj, mapFixRoute, '', 'Price - Repack');
                
            	}else if(mapRT.get(PnDObj.RecordTypeId).DeveloperName == 'ASI_CRM_CN_T1_Price_Adjustment_Request'){
                
                	setFixApprover(PnDObj, mapFixRoute, '', 'Price - Adjustment');
                
            	}else if(mapRT.get(PnDObj.RecordTypeId).DeveloperName == 'ASI_CRM_CN_Customer_Price_and_Discount_Request'){
                
                    if((mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Is_IHBR_Outlet__c && mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Commercial_Team__c == 'HQ/Hotel') || mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_VIP__c){
                        
                        setDynamicApprover(PnDObj, mapUser, mapDynamicRoute);
                        setFixApprover(PnDObj, mapFixRoute, '', 'Price - Customer Price (IH & VIP)');
                    }else{
                		setFixApprover(PnDObj, mapFixRoute, mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Region__c, 'Price - Customer Price');
                    }/*else{
                    	
                        //if(mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Commercial_Team__c == 'HQ/Hotel'){
                    		//setFixApprover(PnDObj, mapFixRoute, '', 'Price - Customer Price (IHBR)');
                    		//setFixApprover(PnDObj, mapFixRoute, '', 'Price - Customer Price (IH & VIP)');
                        //}
                        else{//20160803 Ben @ Elufa
                            setFixApprover(PnDObj, mapFixRoute, '', 'Price - Customer Price (IBR)');
                        }
                    }*/
                }
            }
        }
    }
    
    private static void setFixApprover(ASI_CRM_Price_And_Discount__c PnDObj, Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixRoute, String region, String fixApprovalType){
        
        String fixApprover;
        String sysApprover;
        List<String> sysApproverList = new List<String>();
        String approvalLimit;
        integer k = 1;
        integer x = 0;
		
        /*for(integer i = 1 ; i <= 10 ; i++){
            
            approvalLimit = 'ASI_CRM_CN_Approval_Limit_' + k + '__c';
            sysApprover = 'ASI_CRM_Sys_Approver_' + i + '__c';
            fixApprover = 'ASI_CRM_CN_Approver_'+ k +'__c';
            
            if(PnDObj.get(sysApprover) == null){
                if(mapFixRoute.containsKey(fixApprovalType + region)){
                    PnDObj.put(sysApprover, mapFixRoute.get(fixApprovalType + region).get(fixApprover));
                	k++;
                    if(math.abs(PnDObj.ASI_CRM_CN_Total_Gross_Sales_Impact__c) <= double.valueOf(mapFixRoute.get(fixApprovalType + region).get(approvalLimit))){
                    	break;
                	}
                }
            }
                
            if(k > 6)break;
        }*/
        
        for(integer i = 1 ; i <= 10 ; i++){
            sysApprover = 'ASI_CRM_Sys_Approver_' + i + '__c';
            if(PnDObj.get(sysApprover) == null){
                sysApproverList.add(sysApprover);
            }
        }
        while(k <= 6){
            
            fixApprover = 'ASI_CRM_CN_Approver_'+ k +'__c';
            approvalLimit = 'ASI_CRM_CN_Approval_Limit_' + k + '__c';
            
            if(mapFixRoute.containsKey(fixApprovalType + region)){
                
                if(mapFixRoute.get(fixApprovalType + region).get(fixApprover) != null){
                    
                    PnDObj.put(sysApproverList[x], mapFixRoute.get(fixApprovalType + region).get(fixApprover));
                    //20161011, edited by Leo
                    /*if(math.abs(PnDObj.ASI_CRM_CN_Total_Gross_Sales_Impact__c) <= double.valueOf(mapFixRoute.get(fixApprovalType + region).get(approvalLimit))){
                    	break;
                	}*/
                    if(fixApprovalType != 'Price - Customer Price (IH & VIP)'
                       && math.abs(PnDObj.ASI_CRM_CN_Total_Gross_Sales_Impact__c) <= double.valueOf(mapFixRoute.get(fixApprovalType + region).get(approvalLimit))){
                    	break;
                	}
                    else if(fixApprovalType == 'Price - Customer Price (IH & VIP)')
                    {
                        /*Double amt = 0;
                        if(mapPnD.containsKey(PnDObj.id)
                           && mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Estimated_annual_order_amount__c != null)
                            amt = mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Estimated_annual_order_amount__c;
                        if(math.abs(amt) <= double.valueOf(mapFixRoute.get(fixApprovalType + region).get(approvalLimit)))
                        {
                            break;
                        }*/
                        //20161104, edited by Leo
                        if(PnDObj.ASI_CRM_CN_Total_Gross_Sales_Impact__c <= 0)
                        {
                            if(math.abs(PnDObj.ASI_CRM_CN_Total_Gross_Sales_Impact__c) <= double.valueOf(mapFixRoute.get(fixApprovalType + region).get(approvalLimit)))
                            {
                                break;
                            }
                        }
                        else
                        {
                            Double amt = 0;
                            if(mapPnD.containsKey(PnDObj.id)
                               && mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Estimated_annual_order_amount__c != null)
                                amt = mapPnD.get(PnDObj.id).ASI_CRM_Customer__r.ASI_CRM_CN_Estimated_annual_order_amount__c;
                            if(math.abs(amt) <= double.valueOf(mapFixRoute.get(fixApprovalType + region).get(approvalLimit)))
                            {
                                break;
                            }
                        }
                        //20161104, edited by Leo
                    }
                    //20161011, edited by Leo
                    x++;                    
                    if(x >= sysApproverList.size())
                        break;
                }
            }
            k++;
        }
    }
    
    private static void setDynamicApprover(ASI_CRM_Price_And_Discount__c PnDObj, Map<ID, User> mapUser, Map<id, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRoute){
        
        ID approverID = mapUser.get(PnDObj.OwnerId).ManagerID;
        String sysApprover;
        
        for(integer i = 1 ; i <= 10 ; i++){
            
            sysApprover = 'ASI_CRM_Sys_Approver_' + i + '__c';
            
            if(mapUser.containsKey(approverID)){
                
                PnDObj.put(sysApprover, approverID);
                
                if(mapDynamicRoute.containsKey(approverID))
                    if(mapDynamicRoute.get(approverID).ASI_CRM_End_of_Dynamic_Route__c)
                    	break;
                
                approverID = mapUser.get(approverID).ManagerID;
                
            }else break;
        }
    }
    
    public static void setApproverToNull(ASI_CRM_Price_And_Discount__c PnDObj){
        
        String sysApprover;
        
        for(integer i = 1 ; i <=10 ; i++){
            sysApprover = 'ASI_CRM_Sys_Approver_' + i + '__c';
            PnDObj.put(sysApprover,null);
        }
    }
}