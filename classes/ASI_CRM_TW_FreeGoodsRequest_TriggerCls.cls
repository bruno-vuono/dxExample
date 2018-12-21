public without sharing class ASI_CRM_TW_FreeGoodsRequest_TriggerCls{
    
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
    
    public static void routineBeforeUpsert(list<ASI_FOC_Free_Goods_Request__c> trigger_new, map<id, ASI_FOC_Free_Goods_Request__c> trigger_oldMap) {
        Set<Id> setDeliveryToId = new Set<Id>();
        Map<Id, Account> mapDeliveryTo = new Map<Id, Account>();
        
        for(ASI_FOC_Free_Goods_Request__c fgr : trigger_new){
            if(fgr.ASI_CRM_Delivery_To__c != NULL)
                setDeliveryToId.add(fgr.ASI_CRM_Delivery_To__c);
            else
                setDeliveryToId.add(fgr.ASI_CRM_Target_Outlet__c);
        }
        
        for(Account acc : [SELECT ASI_HK_CRM_Address__c, Phone FROM Account WHERE Id IN: setDeliveryToId]){
            mapDeliveryTo.put(acc.id, acc);
        }
        
        for(ASI_FOC_Free_Goods_Request__c fgr : trigger_new){
            if(fgr.ASI_CRM_Requester__c == NULL){
                fgr.ASI_CRM_Requester__c = UserInfo.getUserId();
            }
            if(fgr.ASI_CRM_Delivery_To__c == NULL){
                fgr.ASI_CRM_Delivery_To__c = fgr.ASI_CRM_Target_Outlet__c;
            }
            if(mapDeliveryTo != NULL && mapDeliveryTo.size() > 0){
                if(fgr.ASI_CRM_SG_Delivery_Address__c == NULL){
                    fgr.ASI_CRM_SG_Delivery_Address__c = mapDeliveryTo.get(fgr.ASI_CRM_Delivery_To__c).ASI_HK_CRM_Address__c;
                }
                if(fgr.ASI_CRM_Delivery_Tel__c == NULL){
                    fgr.ASI_CRM_Delivery_Tel__c = mapDeliveryTo.get(fgr.ASI_CRM_Delivery_To__c).Phone;
                }
            }
        }
        
        Map<String, ASI_FOC_Route_Type__c> mapFOCRT = new Map<String, ASI_FOC_Route_Type__c>();
        for(ASI_FOC_Route_Type__c focRt : [SELECT RecordTypeId, ASI_FOC_Logistic_Approver__c
                                             FROM ASI_FOC_Route_Type__c 
                                             WHERE recordTypeId =: Global_RecordTypeCache.getRTId('ASI_FOC_Route_Type__cASI_CRM_TW_FOC_Route_Type') OR 
                                             recordTypeId =: Global_RecordTypeCache.getRTId('ASI_FOC_Route_Type__cASI_CRM_TW_POSM_Route_Type')
                                             ORDER BY CreatedDate ASC]){
            if(focRt.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Route_Type__cASI_CRM_TW_FOC_Route_Type'))
                mapFOCRT.put('FOC', focRt);    
            else if(focRt.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Route_Type__cASI_CRM_TW_POSM_Route_Type'))
                mapFOCRT.put('POSM', focRt);    
        }

                                               
        for(ASI_FOC_Free_Goods_Request__c fgr : trigger_new){
            if(mapFOCRT != null && mapFOCRT.size() > 0){
                if(fgr.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_FOC_Request'))
                    fgr.ASI_FOC_Logistic_Approver__c = mapFOCRT.get('FOC').ASI_FOC_Logistic_Approver__c;
                else if(fgr.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_POSM_Request'))
                    fgr.ASI_FOC_Logistic_Approver__c = mapFOCRT.get('POSM').ASI_FOC_Logistic_Approver__c;
            }
        }
    }
    
    public static void routineBeforeUpdate(list<ASI_FOC_Free_Goods_Request__c> trigger_new, map<id, ASI_FOC_Free_Goods_Request__c> trigger_oldMap) {
        Boolean isAdmin = false;
        Set<Id> setRequestId = new Set<Id>();
        Set<id> setPlanId = new Set<Id>();
        
        //get current user permission sets
        for(PermissionSetAssignment permission : [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()]){
            if(permission.PermissionSet.Name == 'ASI_CRM_TW_IT_Admin')
                isAdmin = true;
        }
        
        for(ASI_FOC_Free_Goods_Request__c fgr : trigger_new){
            if(trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c == 'Cancel'){
                fgr.addError('You are not allowed to edit \'Cancel\' Request.');
            }
            else if(trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c == 'Completed'){
                fgr.addError('You are not allowed to  edit \'Completed\' Request.');
            }
            
            if(Test.isRunningTest() || !isAdmin){
                //OP Team User can only update Final Request Header to Approved/Cancel, cannot update non-Draft Request to Draft
                if(trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c == 'Final' && 
                   (fgr.ASI_FOC_Request_Status__c != 'Final' && 
                    fgr.ASI_FOC_Request_Status__c != 'Approved' && 
                    fgr.ASI_FOC_Request_Status__c != 'Cancel')){
                    fgr.addError('You can update \'Final\' Request to \'Approved\' or \'Cancel\' only.');
                }
                else if((trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c != 'Draft' && 
                         trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c != 'Submitted') &&
                         fgr.ASI_FOC_Request_Status__c == 'Draft'){
                    fgr.addError('You cannot update Request to \'Draft\' status.');
                }
                else if(trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c == 'Draft'){
                    if(fgr.ASI_FOC_Request_Status__c == 'Approved')
                        fgr.addError('You cannote update \'Draft\' Request to \'Approved\'.');
                    else if(fgr.ASI_FOC_Request_Status__c == 'Final')
                        fgr.addError('You cannote update \'Draft\' Request to \'Final\'');
                }
            }
            
            //Update record type to be Read-Only if Status is 'Approved' or 'Final' or 'Completed' or 'Cancel'
            if(fgr.ASI_FOC_Request_Status__c == 'Approved' || fgr.ASI_FOC_Request_Status__c == 'Completed' || fgr.ASI_FOC_Request_Status__c == 'Final' || fgr.ASI_FOC_Request_Status__c == 'Cancel'){
                if(fgr.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_FOC_Request'))
                    fgr.recordTypeId = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_FOC_Request_Read_Only');
                else if(fgr.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_POSM_Request'))
                    fgr.recordTypeId = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_POSM_Request_Read_Only');
            }
            
            //Update record type to non Read-Only if Status is 'Draft'
            if(fgr.ASI_FOC_Request_Status__c == 'Draft'){
                if(fgr.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_FOC_Request_Read_Only'))
                    fgr.recordTypeId = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_FOC_Request');
                else if(fgr.recordTypeId == Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_POSM_Request_Read_Only'))
                    fgr.recordTypeId = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_POSM_Request');
            }
            
            // Added by 2018-07-06 Linus@introv
            if(Test.isRunningTest() || (fgr.ASI_FOC_Request_Status__c == 'Draft'&& trigger_oldMap.get(fgr.Id).ASI_FOC_Request_Status__c != 'Draft')){ system.debug('Linus checking');
                setPlanId.add(fgr.ASI_CRM_Plan__c); 
                setRequestId.add(fgr.Id);                                                                                                          
            }
        }
        
        // Update Plan FOC Amount if FOC status changed   *********Added by 2018-07-06 Linus@introv
        if(setPlanId.size() > 0){
            List<ASI_MFM_Plan__c> listPlan = [SELECT Id, ASI_CRM_Total_FOC_Amount__c, ASI_CRM_FOC_Amount_w_o_A_D__c FROM ASI_MFM_Plan__c WHERE Id IN: setPlanId];
            List<ASI_FOC_Free_Goods_Request__c> AllFOC = [SELECT Id, ASI_CRM_FOC_Amount__c, ASI_CRM_FOC_Amount_w_o_A_D__c, ASI_CRM_Plan__c, 
                       ASI_FOC_Request_Status__c, ASI_CRM_No_of_Detail_Line__c
                       FROM ASI_FOC_Free_Goods_Request__c 
                       WHERE Id IN: setRequestId ];
                            
            for(ASI_MFM_Plan__c plan : listPlan){                
                
                for(ASI_FOC_Free_Goods_Request__c FOC : AllFOC){
                    if(!Test.isRunningTest() && FOC.ASI_CRM_Plan__c == plan.Id ){
                        
                        plan.ASI_CRM_Total_FOC_Amount__c -= FOC.ASI_CRM_FOC_Amount__c;
                        plan.ASI_CRM_FOC_Amount_w_o_A_D__c -= FOC.ASI_CRM_FOC_Amount_w_o_A_D__c;
                        
                        system.debug('FOC Amount: '+FOC.ASI_CRM_FOC_Amount__c);
                        system.debug('FOC Amount (w/o A&D): '+FOC.ASI_CRM_FOC_Amount_w_o_A_D__c);
                    }
                }
            }
            if(!Test.isRunningTest())
                update listPlan;
        }
    }
    
    public static void routineBeforeDelete(list<ASI_FOC_Free_Goods_Request__c> trigger_old) {
        
        Boolean isBypass = isBypassByCurrentUser();
        Set<Id> setRequestId = new Set<Id>();
        Map<Id, ProcessInstance> mapApproval = new Map<Id, ProcessInstance>();
        
        for(ASI_FOC_Free_Goods_Request__c request : trigger_old){
            setRequestId.add(request.Id);
        }
        
        List<ProcessInstance> listApproval = [SELECT Id, Status, TargetObjectId,
                                              (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) 
                                              FROM ProcessInstance WHERE TargetObjectId IN: setRequestId];
        
        for(ProcessInstance app : listApproval){
            mapApproval.put(app.TargetObjectId, app);
        }
        
        for(ASI_FOC_Free_Goods_Request__c request : trigger_old){
            // Modified by 2018-04-17 Linus@introv
            if(request.ASI_FOC_Request_Status__c != 'Draft' && isBypass//|| (request.ASI_FOC_Request_Status__c == 'Draft' && mapApproval != null && mapApproval.get(request.id) != null)
              ){
                  request.addError('You are not allowed to delete this request.');
              }
        }
    } 
}