public without sharing class ASI_CRM_TW_RequestItem_TriggerCls{
    //Bypass user from specific validation
    private static Boolean isBypassByCurrentUser() {
        Boolean isByPass = false;
        ID curUserId = UserInfo.getUserId();
        List<User> users = [SELECT Id, BypassTriggers__c FROM User WHERE Id = :curUserId];
        if (users.size() > 0 && users[0].BypassTriggers__c != null) {
            if (users[0].BypassTriggers__c.contains('ASI_CRM_TW_FreeGoodsRequest_TriggerCls')){
                isByPass = true;
            }
        }
        return isByPass;
    }
    
    public static void routineBeforeUpsert(list<ASI_FOC_Request_Item__c> trigger_new, map<id, ASI_FOC_Request_Item__c> trigger_oldMap) {
        Set<Id> setSKUId = new Set<Id>();
        Set<Id> setItemGpId = new Set<Id>();
        Set<Id> setPlanLineId = new Set<Id>();
        
        Map<Id, Id> mapSKUbyItemGp = new Map<Id, Id>();
        Map<Id, String> mapPlanLineType = new Map<Id, String>();
        Map<Id, Date> mapPlanLineStartDate = new Map<Id, Date>();
        Map<Id, String> mapPlanLineAccChannel = new Map<Id, String>();
        
        //retrieve default values
        Set<Id> setHeaderId = new Set<Id>();
        Set<Id> setDeliveryToAccId = new Set<Id>();
        Map<Id, ASI_FOC_Free_Goods_Request__c> mapHeader = new Map<Id, ASI_FOC_Free_Goods_Request__c>();
        Map<Id, Account> mapDeliveryToAcc = new Map<Id, Account>();
        
        for(ASI_FOC_Request_Item__c itm : trigger_new){
            setHeaderId.add(itm.ASI_FOC_Request_Order__c);
            setDeliveryToAccId.add(itm.ASI_CRM_Delivery_To__c);       
        }
        
        for(ASI_FOC_Free_Goods_Request__c header : [SELECT ASI_CRM_Target_Outlet__c, ASI_CRM_Delivery_To__c, ASI_CRM_SG_Delivery_Address__c, ASI_CRM_Delivery_Tel__c, ASI_CRM_Receiver__c, ASI_FOC_Request_Status__c FROM ASI_FOC_Free_Goods_Request__c WHERE Id IN: setHeaderId]){
            mapHeader.put(header.id, header);
            setDeliveryToAccId.add(header.ASI_CRM_Delivery_To__c);     
        }
        
        for(Account acc : [SELECT ASI_HK_CRM_Address__c, Phone FROM Account WHERE Id IN:setDeliveryToAccId]){
            mapDeliveryToAcc.put(acc.id, acc);
        }
        
        //For query SKU Price/Cost
        //String strAccChannel = '';
        List<String> listType = new List<String>();
        listType.add('A&D FOC Unit Cost');
        listType.add('A&P FOC Unit Cost');
        
        //get current user permission sets
        List<PermissionSetAssignment> listCurrentUserPerSet = [SELECT Id FROM PermissionSetAssignment
                                                               WHERE AssigneeId = :Userinfo.getUserId() AND 
                                                               PermissionSet.Name = 'ASI_CRM_TW_OP_Team'];
        
        for(ASI_FOC_Request_Item__c itm : trigger_new){
            setSKUId.add(itm.ASI_FOC_SKU__c); 
            setPlanLineId.add(itm.ASI_CRM_Plan_Line_Item__c);
        }
        
        for(ASI_MFM_SKU_Code__c sku : [SELECT Id, ASI_MFM_Item_Group__c FROM ASI_MFM_SKU_Code__c WHERE Id IN: setSKUId]){
            setItemGpId.add(sku.ASI_MFM_Item_Group__c);
            mapSKUbyItemGp.put(sku.Id, sku.ASI_MFM_Item_Group__c);
        }
        
        for(ASI_MFM_Plan_Line_Item__c pline : [SELECT Id, ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c, ASI_MFM_Customer_Name__r.ASI_MFM_Channel__c, ASI_MFM_Start_Date_Sys__c FROM ASI_MFM_Plan_Line_Item__c WHERE Id IN: setPlanLineId]){
            if(pline.ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c == 'Total A&D')
                mapPlanLineType.put(pline.id, 'A&D FOC Unit Cost');
            else if(pline.ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c == 'TOTAL A&P')
                mapPlanLineType.put(pline.id, 'A&P FOC Unit Cost');
            
            mapPlanLineStartDate.put(pline.id, pline.ASI_MFM_Start_Date_Sys__c);
            mapPlanLineAccChannel.put(pline.id, pline.ASI_MFM_Customer_Name__r.ASI_MFM_Channel__c);
            
            //strAccChannel += pline.ASI_MFM_Customer_Name__r.ASI_MFM_Channel__c+';';
        }
        
        //Get all related Item Gp's SKU Price/Cost (A&D & A&P Cost)
        ASI_CRM_TW_ItemGroup_UtilityCls utilityCls = new ASI_CRM_TW_ItemGroup_UtilityCls();
        List<ASI_CRM_MY_SKUPriceCost__c> listSKUPriceCost = utilityCls.getAllChannelSKUpc(/*strAccChannel, */setItemGpId, listType);
        system.debug('listSKUPriceCost: '+listSKUPriceCost);
        
        Boolean isByPass = isBypassByCurrentUser();
        
        for(ASI_FOC_Request_Item__c itm : trigger_new){
            //Validate required fields
            if(itm.ASI_FOC_Request_Quantity_Bottle__c == null)
                itm.addError('Error: Request Quantity cannot be blank.');
            
            //Only SKU is allowed to be edited by OP Team for Approved FOC (by pass admin)
            if(!isBypass && (listCurrentUserPerSet == null || listCurrentUserPerSet.size() <= 0)){
                if(mapHeader != NULL && mapHeader.size() > 0 && mapHeader.get(itm.ASI_FOC_Request_Order__c) != NULL && mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c == 'Approved'){
                    itm.addError('You are not allowed to update line item(s) of \'Approved\' Request.');
                }
            }
                    
            //retrieve Delivery To Address && Tel if Delivery To is not empty
            if(itm.ASI_CRM_Delivery_To__c != null && mapDeliveryToAcc != NULL && mapDeliveryToAcc.size() > 0 && mapDeliveryToAcc.get(itm.ASI_CRM_Delivery_To__c) != null){
                if(itm.ASI_CRM_Delivery_Address__c == null)
                    itm.ASI_CRM_Delivery_Address__c = mapDeliveryToAcc.get(itm.ASI_CRM_Delivery_To__c).ASI_HK_CRM_Address__c;
                if(itm.ASI_CRM_Delivery_Tel__c == null)
                    itm.ASI_CRM_Delivery_Tel__c = mapDeliveryToAcc.get(itm.ASI_CRM_Delivery_To__c).Phone;
            }   
            
            //retrieve default values from Header if empty        
            if(mapHeader != NULL && mapHeader.size() > 0 && mapHeader.get(itm.ASI_FOC_Request_Order__c) != NULL){
                if(itm.ASI_CRM_Target_Outlet__c == null)
                    itm.ASI_CRM_Target_Outlet__c = mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Target_Outlet__c;
                if(itm.ASI_CRM_Delivery_To__c == null)
                    itm.ASI_CRM_Delivery_To__c = mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Delivery_To__c;
                if(itm.ASI_CRM_Delivery_Address__c == null)
                    itm.ASI_CRM_Delivery_Address__c = mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_SG_Delivery_Address__c;
                if(itm.ASI_CRM_Delivery_Tel__c == null)
                    itm.ASI_CRM_Delivery_Tel__c = mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Delivery_Tel__c;
            }        
            
            //retrieve default value of Reviever from Header if empty
            if(itm.ASI_CRM_Receiver__c == NULL && mapHeader != NULL && mapHeader.size() > 0 && mapHeader.get(itm.ASI_FOC_Request_Order__c) != NULL){
                itm.ASI_CRM_Receiver__c = mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Receiver__c;
            }  
                 
            if(mapPlanLineType.get(itm.ASI_CRM_Plan_Line_Item__c) == 'A&D FOC Unit Cost')
                itm.ASI_CRM_A_D_or_A_P__c = 'A&D';
            else if(mapPlanLineType.get(itm.ASI_CRM_Plan_Line_Item__c) == 'A&P FOC Unit Cost')
                itm.ASI_CRM_A_D_or_A_P__c = 'A&P';
            
            for(ASI_CRM_MY_SKUPriceCost__c skupc : listSKUPriceCost){
                system.debug('Channel: '+mapPlanLineAccChannel.get(itm.ASI_CRM_Plan_Line_Item__c));
                system.debug('Item Gp: '+mapSKUbyItemGp.get(itm.ASI_FOC_SKU__c));
                system.debug('Type: '+mapPlanLineType.get(itm.ASI_CRM_Plan_Line_Item__c));
                system.debug('Plan Start Date: '+mapPlanLineStartDate.get(itm.ASI_CRM_Plan_Line_Item__c));
                
                if(/*skupc.ASI_CRM_Applied_To__c.contains(mapPlanLineAccChannel.get(itm.ASI_CRM_Plan_Line_Item__c)) &&*/
                   skupc.ASI_CRM_Item_Group__c == mapSKUbyItemGp.get(itm.ASI_FOC_SKU__c) &&
                   skupc.ASI_CRM_Type__c == mapPlanLineType.get(itm.ASI_CRM_Plan_Line_Item__c) &&
                   skupc.ASI_CRM_EffectiveDate__c <= mapPlanLineStartDate.get(itm.ASI_CRM_Plan_Line_Item__c)){
                    system.debug('SKU Cost: '+skupc.ASI_CRM_Cost__c);
                    itm.ASI_FOC_Unit_Cost_PC_BT__c = Math.abs(skupc.ASI_CRM_Cost__c);
                    break;
                }
            }
            system.debug('Line Item Cost: '+itm.Name+' '+itm.ASI_FOC_Unit_Cost_PC_BT__c);
        }
    }
    
    public static void routineAfterUpsert(list<ASI_FOC_Request_Item__c> trigger_new, map<id, ASI_FOC_Request_Item__c> trigger_oldMap) {
        Set<Id> setHeaderId = new Set<Id>();
        List<ASI_FOC_Free_Goods_Request__c> listHeader = new List<ASI_FOC_Free_Goods_Request__c>();
        Map<Id, ASI_FOC_Free_Goods_Request__c> mapHeader = new Map<Id, ASI_FOC_Free_Goods_Request__c>();
        List<ASI_FOC_Free_Goods_Request__c> listHeaderToUpdate = new List<ASI_FOC_Free_Goods_Request__c>();
        
        Set<Id> setPlanId = new Set<Id>();
        List<ASI_MFM_Plan__c> listPlan = new List<ASI_MFM_Plan__c>();
        
        // Added by 2018-07-06 Linus@introv        
        List<ASI_FOC_Request_Item__c> AllFOC = new List<ASI_FOC_Request_Item__c>();
        
        Map<Id, Boolean> mapCheckOutstanding = new Map<Id, Boolean>(); //Added by Introv for checking if any Outstanding item
        
        for(ASI_FOC_Request_Item__c itm : trigger_new){
            setHeaderId.add(itm.ASI_FOC_Request_Order__c);  
        }
        
        for(ASI_FOC_Request_Item__c itm :[SELECT id, ASI_FOC_Request_Order__c, ASI_CRM_Outstanding_Qty__c FROM ASI_FOC_Request_Item__c WHERE ASI_FOC_Request_Order__c IN: setHeaderId]){
            if(mapCheckOutstanding == null || mapCheckOutstanding.get(itm.ASI_FOC_Request_Order__c) == null)
                mapCheckOutstanding.put(itm.ASI_FOC_Request_Order__c, true);
            if(itm.ASI_CRM_Outstanding_Qty__c == null || (itm.ASI_CRM_Outstanding_Qty__c != null && itm.ASI_CRM_Outstanding_Qty__c != 0))
                mapCheckOutstanding.put(itm.ASI_FOC_Request_Order__c, false);
            
            system.debug(mapCheckOutstanding);
        }
        
        listHeader = [SELECT Id, ASI_CRM_FOC_Amount__c, ASI_CRM_FOC_Amount_w_o_A_D__c, ASI_CRM_Plan__c, 
                       ASI_FOC_Request_Status__c, ASI_CRM_No_of_Detail_Line__c
                       FROM ASI_FOC_Free_Goods_Request__c 
                       WHERE Id IN: setHeaderId]; 
        for(ASI_FOC_Free_Goods_Request__c header : listHeader){
            mapHeader.put(header.id, header);
            setPlanId.add(header.ASI_CRM_Plan__c); 
        }
        listPlan = [SELECT Id, ASI_CRM_Total_FOC_Amount__c, ASI_CRM_FOC_Amount_w_o_A_D__c FROM ASI_MFM_Plan__c WHERE Id IN: setPlanId];
        
        for(ASI_FOC_Request_Item__c itm : trigger_new){
            //Added by Introv @20170526 for update Free Goods Request status to 'Completed' if no Outstanding item
            if(mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c != 'Completed' && 
               mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_No_of_Detail_Line__c != 0 && 
               mapCheckOutstanding.get(itm.ASI_FOC_Request_Order__c)){
                mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c = 'Completed';
                listHeaderToUpdate.add(mapHeader.get(itm.ASI_FOC_Request_Order__c));
            }
        }
        update listHeaderToUpdate;
        
        //update Plan FOC Amount
        if(setPlanId.size() != 0){
            AllFOC = [SELECT Id, ASI_CRM_TW_Amount__c , ASI_FOC_Request_Order__r.ASI_CRM_Plan__c, ASI_CRM_A_D_or_A_P__c ,
                      ASI_FOC_Request_Order__r.ASI_FOC_Request_Status__c
                      FROM ASI_FOC_Request_Item__c 
                      WHERE recordtype.developerName = 'ASI_CRM_TW_POSM_Request_Item' and 
                      ASI_FOC_Request_Order__r.ASI_CRM_Plan__c IN: setPlanId ];
            List<ASI_MFM_Plan__c> listToUpdatePlan = new List<ASI_MFM_Plan__c>();
            for(ASI_MFM_Plan__c plan : listPlan){
                Decimal decPlanTotalFOCAmt = plan.ASI_CRM_Total_FOC_Amount__c;
                Decimal decPlanAPFOCAmt = plan.ASI_CRM_FOC_Amount_w_o_A_D__c;
                
                plan.ASI_CRM_Total_FOC_Amount__c = 0;
                plan.ASI_CRM_FOC_Amount_w_o_A_D__c = 0;
                
                for(ASI_FOC_Request_Item__c FOC : AllFOC){
                    
                    if(FOC.ASI_FOC_Request_Order__r.ASI_FOC_Request_Status__c != 'Draft' && FOC.ASI_FOC_Request_Order__r.ASI_FOC_Request_Status__c != 'Cancel' && FOC.ASI_FOC_Request_Order__r.ASI_CRM_Plan__c == plan.Id){
                        plan.ASI_CRM_Total_FOC_Amount__c += FOC.ASI_CRM_TW_Amount__c;
                        plan.ASI_CRM_FOC_Amount_w_o_A_D__c = FOC.ASI_CRM_A_D_or_A_P__c == 'A&P' ? plan.ASI_CRM_FOC_Amount_w_o_A_D__c + FOC.ASI_CRM_TW_Amount__c : plan.ASI_CRM_FOC_Amount_w_o_A_D__c + 0;
                        
                        system.debug('FOC Amount: '+plan.ASI_CRM_Total_FOC_Amount__c);
                        system.debug('FOC Amount (w/o A&D): '+plan.ASI_CRM_FOC_Amount_w_o_A_D__c);
                    }
                    
                }
                
                //update Plan FOC Amount only when they are changed
                if(plan.ASI_CRM_Total_FOC_Amount__c != decPlanTotalFOCAmt || plan.ASI_CRM_FOC_Amount_w_o_A_D__c != decPlanAPFOCAmt)
                    listToUpdatePlan.add(plan);  
            }
            update listToUpdatePlan;
        }
    }
    
    public static void routineBeforeDelete(list<ASI_FOC_Request_Item__c> trigger_old) {
        if(!isBypassByCurrentUser()){
            Set<Id> setHeaderId = new Set<Id>();
            Map<Id, ASI_FOC_Free_Goods_Request__c> mapHeader = new Map<Id, ASI_FOC_Free_Goods_Request__c>();
            
            //get current user permission sets
            List<PermissionSetAssignment> listCurrentUserPerSet = [SELECT Id FROM PermissionSetAssignment
                                                                   WHERE AssigneeId = :Userinfo.getUserId() AND 
                                                                   PermissionSet.Name = 'ASI_CRM_TW_OP_Team'];
            system.debug('Current User Permision: '+listCurrentUserPerSet);
            
            for(ASI_FOC_Request_Item__c itm : trigger_old){
                setHeaderId.add(itm.ASI_FOC_Request_Order__c);   
            }
            
            for(ASI_FOC_Free_Goods_Request__c header : [SELECT ASI_FOC_Request_Status__c, ASI_CRM_Target_Outlet__c, ASI_CRM_Delivery_To__c, ASI_CRM_SG_Delivery_Address__c, ASI_CRM_Delivery_Tel__c FROM ASI_FOC_Free_Goods_Request__c WHERE Id IN: setHeaderId]){
                mapHeader.put(header.id, header);
            }
            
            for(ASI_FOC_Request_Item__c itm : trigger_old){
                if(mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c == 'Submitted' ||
                   mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c == 'Final' ||
                   mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c == 'Complete' ||
                   mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c == 'Cancel'){
                    itm.addError('You are not allowed to delete line items.');
                }
                else if(mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c == 'Approved'){
                    if(listCurrentUserPerSet == null || listCurrentUserPerSet.size() <= 0)
                        itm.addError('You are not allowed to delete line items.');
                }
            }
        }
    }
    
    public static void routineAfterDelete(list<ASI_FOC_Request_Item__c> trigger_old) {
        Set<Id> setHeaderId = new Set<Id>();
        Set<Id> setPlanId = new Set<Id>();
        
        List<ASI_MFM_Plan__c> listPlan = new List<ASI_MFM_Plan__c>();
        
        Map<Id, ASI_FOC_Free_Goods_Request__c> mapHeader = new Map<Id, ASI_FOC_Free_Goods_Request__c>();
        Map<Id, Map<Id, ASI_FOC_Request_Item__c>> mapLineByPlan = new Map<Id, Map<Id, ASI_FOC_Request_Item__c>>();
        
        for(ASI_FOC_Request_Item__c itm : trigger_old){
            setHeaderId.add(itm.ASI_FOC_Request_Order__c); 
        }
        
        for(ASI_FOC_Free_Goods_Request__c header : [SELECT Id, ASI_CRM_Plan__c FROM ASI_FOC_Free_Goods_Request__c WHERE Id IN: setHeaderId]){
            setPlanId.add(header.ASI_CRM_Plan__c); 
            mapHeader.put(header.Id, header);
        }
        
        for(ASI_FOC_Request_Item__c itm : trigger_old){
            Map<Id, ASI_FOC_Request_Item__c> mapTempLine = new Map<Id, ASI_FOC_Request_Item__c>();
            
            if(mapLineByPlan != null && mapLineByPlan.get(mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Plan__c) != null){
                mapTempLine = mapLineByPlan.get(mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Plan__c);
            }
            mapTempLine.put(itm.Id, itm);
            mapLineByPlan.put(mapHeader.get(itm.ASI_FOC_Request_Order__c).ASI_CRM_Plan__c, mapTempLine);
        }
        
        listPlan = [SELECT Id, ASI_CRM_Total_FOC_Amount__c, ASI_CRM_FOC_Amount_w_o_A_D__c FROM ASI_MFM_Plan__c WHERE Id IN: setPlanId];
        for(ASI_MFM_Plan__c plan : listPlan){
            if(mapLineByPlan.get(plan.id) != null){
                Map<Id, ASI_FOC_Request_Item__c> mapTempLine = mapLineByPlan.get(plan.id);
                
                if(mapTempLine.KeySet() != null && mapTempLine.KeySet().size() > 0)
                    for(Id key : mapTempLine.KeySet()){
                        if(plan.ASI_CRM_Total_FOC_Amount__c != null && mapTempLine.get(key).ASI_CRM_TW_Amount__c != null){
                            plan.ASI_CRM_Total_FOC_Amount__c -= mapTempLine.get(key).ASI_CRM_TW_Amount__c;
                            
                            if(mapTempLine.get(key).ASI_CRM_A_D_or_A_P__c == 'A&P')
                                plan.ASI_CRM_FOC_Amount_w_o_A_D__c -= mapTempLine.get(key).ASI_CRM_TW_Amount__c;
                        }
                    }
            }
        }
        update listPlan;
    }
}