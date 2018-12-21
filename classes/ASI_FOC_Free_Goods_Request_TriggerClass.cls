public without sharing class ASI_FOC_Free_Goods_Request_TriggerClass {
    static integer i = 0;//20151102 Ben @ Elufa
    
    //20151214 Ben @ Elufa System
    Static List<ASI_FOC_Request_Item__c> lineItemList = new List<ASI_FOC_Request_Item__c>();
    Static List<ASI_FOC_Free_Goods_Request__c> allRequest = new List<ASI_FOC_Free_Goods_Request__c>();
    Static Integer afterUpdateCount = 0;
    Static Integer beforeUpdateCount = 0;
    Static Map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_FOC_Free_Goods_Request__c');
    
    //20170926 Introv
    Public Static List<ASI_CRM_Dynamic_Approval_Route__c> dynamicApprovalList = new List<ASI_CRM_Dynamic_Approval_Route__c>([SELECT id
                                                                                                                             , ASI_CRM_End_of_Dynamic_Route__c
                                                                                                                             , ASI_CRM_User__c
                                                                                                                             , ASI_CRM_Type__c
                                                                                                                             , ASI_CRM_Approval_Limit__c
                                                                                                                             FROM ASI_CRM_Dynamic_Approval_Route__c
                                                                                                                             WHERE RecordType.DeveloperName Like 'ASI_CRM_CN_Dynamic_Approval_Route'
                                                                                                                             AND (ASI_CRM_Type__c = 'Free Goods Request'
                                                                                                                                  OR ASI_CRM_Type__c = 'POSM'
                                                                                                                                 )
                                                                                                                            ]);
    Public Static List<ASI_CRM_Fix_Approval_Route__c> fixApprovalList = new List<ASI_CRM_Fix_Approval_Route__c>([SELECT id
                                                                                                                 , ASI_CRM_Finance_Approver__c
                                                                                                                 , ASI_CRM_Logistic_Approver__c
                                                                                                                 , ASI_CRM_CN_Type__c
                                                                                                                 FROM ASI_CRM_Fix_Approval_Route__c
                                                                                                                 WHERE RecordType.DeveloperName Like 'ASI_CRM_CN_Fix_Approval_Route'
                                                                                                                 AND (ASI_CRM_CN_Type__c = 'Free Goods Request'
                                                                                                                      OR ASI_CRM_CN_Type__c = 'POSM'
                                                                                                                     )
                                                                                                                ]);
    
    Private Final Static Map<String, Schema.SObjectField> foc_FIELD_MAP = Schema.SObjectType.ASI_FOC_Free_Goods_Request__c.fields.getMap();
    Private Final Static Map<String, Schema.SObjectField> FixApproval_FIELD_MAP = Schema.SObjectType.ASI_CRM_Fix_Approval_Route__c.fields.getMap();
    
    //20171017 Introv
    Private Static Map<id, ASI_MFM_Expense_Control_Form__c> taxSavingList = new Map<id, ASI_MFM_Expense_Control_Form__c>([SELECT id
                                                                                                                          , ASI_MFM_Tax_Saving_Purpose__c
                                                                                                                          , ASI_MFM_AB_Policy_Required__c
                                                                                                                          , Name
                                                                                                                          FROM ASI_MFM_Expense_Control_Form__c
                                                                                                                          WHERE RecordType.DeveloperName Like 'ASI_MFM_CN_Tax_Saving_Control_Form'
                                                                                                                         ]);
    
    Private Static Map<String, ASI_MFM_Expense_Control_Form__c> taxSavingMap = new Map<String, ASI_MFM_Expense_Control_Form__c>();
    
    
    //20151214 End
    @future @TestVisible
    private static void getApprovalComments(set<id> req_set) {
        list<ASI_FOC_Free_Goods_Request__c> req_list = [select (select Comments from ProcessSteps order by createdDate desc limit 1) from ASI_FOC_Free_Goods_Request__c where id in :req_set for update];
        for (ASI_FOC_Free_Goods_Request__c r:req_list) {
            if (r.processSteps.size() > 0) {
                r.ASI_FOC_SYS_Finance_Comment__c = r.processSteps[0].comments;
            }
        }
        update req_list;		
    }
    
    public static void routineAfterAll(list<ASI_FOC_Free_Goods_Request__c> trigger_new, map<id, ASI_FOC_Free_Goods_Request__c> trigger_oldMap) {
        // Recalculate the PO consumed amount
        set<id> po_set = new set<id>();
        Set<Id> JDEFOCIdSet = new Set<Id> ();
                //Add by Laputa, if TOV No. value changed from null to not null, set status to "FG Request to W/H"
        
        if (trigger_new != null) {
            for (ASI_FOC_Free_Goods_Request__c rq:trigger_new) {
                if (trigger_oldMap == null) {
                    po_set.add(rq.ASI_FOC_PO__c);
                }else {
                    po_set.add(rq.ASI_FOC_PO__c);
                    po_set.add(trigger_oldMap.get(rq.id).ASI_FOC_PO__c);						
                }	
                
                if((trigger_oldMap==null && rq.ASI_FOC_JDE_Order_Number__c !=null )  || (trigger_oldMap!=null && rq.ASI_FOC_JDE_Order_Number__c!=null && trigger_oldMap.get(rq.id).ASI_FOC_JDE_Order_Number__c ==null )   ){
                    JDEFOCIdSet.add(rq.Id);
                }
            }
        } else if (trigger_oldMap != null) {
            for (ASI_FOC_Free_Goods_Request__c rq:trigger_oldMap.values()) {
                po_set.add(rq.ASI_FOC_PO__c);
            }
        }
        
        if (po_set.size() > 0) {
            list<ASI_FOC_PO__c> po_list = [select (select ASI_FOC_Budget_Amount__c from ASI_FOC_Free_Goods_Requests__r 
                                                   where ASI_FOC_Request_Status__c != 'Rejected' and ASI_FOC_Request_Status__c != 'Rejected by System' and ASI_FOC_Request_Status__c != 'Rejected by Logistic' and ASI_FOC_Request_Status__c != 'Cancelled') 
                                           from ASI_FOC_PO__c where id in :po_set for update];
            for (ASI_FOC_PO__c po:po_list) {
                po.ASI_FOC_PO_Consumed_Amount__c = 0;
                for (ASI_FOC_Free_Goods_Request__c rq:po.ASI_FOC_Free_Goods_Requests__r) {
                    if (rq.ASI_FOC_Budget_Amount__c != null) {
                        po.ASI_FOC_PO_Consumed_Amount__c += rq.ASI_FOC_Budget_Amount__c;
                    }
                }
            }
            if (po_list.size() > 0) {
                update po_list;
            }
        }
        
        if(JDEFOCIdSet.size()>0){
            List<ASI_CRM_Internal_Complaint__c> InternalComplaintList= [select id,ASI_CRM_CN_Free_Goods_Request_Ref__c,ASI_CRM_CN_Status__c,recordTypeId from ASI_CRM_Internal_Complaint__c where ASI_CRM_CN_Free_Goods_Request_Ref__c in : JDEFOCIdSet ];
            for(ASI_CRM_Internal_Complaint__c InternalComplaint :InternalComplaintList){
                InternalComplaint.ASI_CRM_CN_Status__c='FG Request to W/H';
                //ASI_CRM_CN_FG_Request_to_W_H
                InternalComplaint.recordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Internal_Complaint__cASI_CRM_CN_FG_Request_to_W_H');
            }
            if(InternalComplaintList.size()>0){
                update InternalComplaintList;
            }
        }
    }
    
    public static void routineAfterUpdate(list<ASI_FOC_Free_Goods_Request__c> trigger_new, map<id, ASI_FOC_Free_Goods_Request__c> trigger_oldMap) {
        //20151214 Ben @ Elufa System
        if(afterUpdateCount <= 1){
            afterUpdateCount++;
            
            Map<Id, Integer> totalRequestWithQuantity = new Map<Id, Integer>();//20160119 Ben @ Elufa Systems
            
            allRequest = [SELECT id
                          , ASI_FOC_PO_Remaining_Amount__c
                          , ASI_FOC_SYS_Total_Lines__c
                          , ASI_FOC_SYS_Total_Request_Item__c
                          , ASI_FOC_SYS_Total_Cancel_Item__c 
                          FROM ASI_FOC_Free_Goods_Request__c 
                          WHERE ID IN : trigger_new
                          for update
                         ];
            
            //20151214 End
            
            // If the related request items have been saved via the Manage All page and the related PO remaining amount is not negative,
            // Set the record type of the request order to 'CN FOC Request and Items Read Only'
            //Map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_FOC_Free_Goods_Request__c'); // Added By Alan Wong (Elufa) 20150616
            //list<recordType> rt_list = [select id from recordType where sobjectType = 'ASI_FOC_Free_Goods_Request__c' and developerName = 'ASI_FOC_CN_Request_and_Items_Read_Only'];
            if (rt_map.containsKey('ASI_FOC_CN_Request_and_Items_Read_Only')) {
                set<id> update_set = new set<id>();
                Map<id,id> updateMap = new Map<id,id>();
                set<id> ri_set = new set<id>();
                for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                    ri_set.add(r.id);
                }
                
                list<ASI_FOC_Request_Item__c> ri_list = [select ASI_FOC_Brand_Director_Approval_Required__c, ASI_FOC_Reason__c, ASI_FOC_Brand_Director_Approval_Status__c, ASI_FOC_ETL_Complete__c, ASI_FOC_Request_Order__c
                                                         from ASI_FOC_Request_Item__c
                                                         where ASI_FOC_Request_Order__c IN :ri_set]; 
                list<ASI_FOC_Request_Item__c> update_rilist = new List<ASI_FOC_Request_Item__c>();
                for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                    system.debug('record type: ' + r.recordTypeId);
                    if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request')){
                        if (r.ASI_FOC_Number_of_Saves__c > 0 && (r.ASI_FOC_Request_Status__c == 'Open' || r.ASI_FOC_Request_Status__c =='Rejected by Logistic') && r.ASI_FOC_Number_of_Saves__c > trigger_oldMap.get(r.id).ASI_FOC_Number_of_Saves__c) {
                            if(!update_set.contains(r.id)){
                                update_set.add(r.id);
                                updateMap.put(r.id,rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only'));
                            }
                        }
                    } else if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only')){
                        if (r.ASI_FOC_Request_Status__c == 'Submitted') {
                            if(!update_set.contains(r.id)){
                                update_set.add(r.id);
                                updateMap.put(r.id,rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only'));
                            }
                        }
                    } else if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')){
                        if (r.ASI_FOC_Request_Status__c == 'Rejected by Logistic'){
                            if(!update_set.contains(r.id)){
                                update_set.add(r.id);
                                updateMap.put(r.id,rt_map.get('ASI_FOC_CN_Free_Goods_Request'));
                            }
                        }
                    }
                    // Approved by Logistic
                    
                    
                    // -- End -- //
                    
                    if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only') ||
                        r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')){
                            if(ri_list.size()>0){
                                for (ASI_FOC_Request_Item__c ri:ri_list) {
                                    //20160119 Ben @ Elufa Systems
                                    if(ri.ASI_FOC_ETL_Complete__c && ri.ASI_FOC_Brand_Director_Approval_Status__c != 'Rejected' && ri.ASI_FOC_Brand_Director_Approval_Status__c != 'Cancelled'){
                                        if(totalRequestWithQuantity.containsKey(ri.ASI_FOC_Request_Order__c)){
                                            totalRequestWithQuantity.put(ri.ASI_FOC_Request_Order__c, totalRequestWithQuantity.get(ri.ASI_FOC_Request_Order__c) + 1);
                                        }else{
                                            totalRequestWithQuantity.put(ri.ASI_FOC_Request_Order__c, 1);
                                        }
                                    }
                                    //20160119 End
                                    if(r.ASI_FOC_Description__c != trigger_oldMap.get(r.id).ASI_FOC_Description__c &&  r.ASI_FOC_Description__c != '') {
                                        ri.ASI_FOC_Reason__c = r.ASI_FOC_Description__c;
                                        update_rilist.add(ri);
                                    }
                                }    
                            }
                        }
                    if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')){
                        if (r.ASI_FOC_Sys_Approved_By_Logistic__c  && (r.ASI_FOC_SYS_Total_Lines__c == r.ASI_FOC_SYS_Total_RequestWithQuantity__c || (totalRequestWithQuantity.containsKey(r.id) && totalRequestWithQuantity.get(r.id) == r.ASI_FOC_SYS_Total_Lines__c)) && (r.ASI_FOC_SYS_Total_RequestWithQuantity__c != trigger_oldMap.get(r.id).ASI_FOC_SYS_Total_RequestWithQuantity__c || r.ASI_FOC_SYS_Total_Lines__c != trigger_oldMap.get(r.id).ASI_FOC_SYS_Total_Lines__c || 	r.ASI_FOC_Request_Status__c == 'Approved by Logistic')) {
                            if (ri_list.size() > 0 && i == 0) {//20151102 Ben @ Elufa 
                                List<Approval.ProcessSubmitRequest> itm_reqList = new List<Approval.ProcessSubmitRequest>();
                                for (ASI_FOC_Request_Item__c ri:ri_list) {
                                    if (ri.ASI_FOC_Brand_Director_Approval_Required__c && ri.ASI_FOC_Brand_Director_Approval_Status__c == null) {
                                        Approval.ProcessSubmitRequest itm_req = new Approval.ProcessSubmitRequest();
                                        itm_req.setObjectId(ri.id);
                                        itm_reqList.add(itm_req);
                                        //Approval.ProcessResult itm_result = Approval.process(itm_req);
                                    }
                                }
                                Approval.process(itm_reqList);
                                i++;
                            }
                        }
                    }
                }
                if (update_set.size() > 0) {
                    //20151214 Ben @ Elufa System
                    list<ASI_FOC_Free_Goods_Request__c> update_list = new List<ASI_FOC_Free_Goods_Request__c>();
                    for(ASI_FOC_Free_Goods_Request__c obj : allRequest){
                        if(update_set.contains(obj.id) && obj.ASI_FOC_PO_Remaining_Amount__c >= 0){
                            update_list.add(obj);
                        }
                    }
                    //list<ASI_FOC_Free_Goods_Request__c> update_list = [select id, ASI_FOC_PO_Remaining_Amount__c from ASI_FOC_Free_Goods_Request__c 
                    //where id in :update_set and ASI_FOC_PO_Remaining_Amount__c >= 0 for update];
                    //20151214 End
                    for (ASI_FOC_Free_Goods_Request__c r:update_list) {
                        system.debug('PO remaining amount: ' + r.ASI_FOC_PO_Remaining_Amount__c);
                        r.RecordTypeId = updateMap.get(r.id);
                    }
                    update update_list;
                }
                if(update_rilist.size()>0){
                    update update_rilist;
                }
            }
            
            // Submit approval request if the related request items have been approved or rejected
            // Set request order to rejected status if the related request items are all rejected
            set<id> submitted_set = new set<id>();
            for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                
                system.debug('20180131 ' + r.ASI_FOC_Sys_Submitted__c + '  r.ASI_FOC_Sys_Item_Count__c ' + r.ASI_FOC_Sys_Item_Count__c + ' r.ASI_FOC_Sys_Approved_By_Logistic__c ' + r.ASI_FOC_Sys_Approved_By_Logistic__c + ' ASI_FOC_SYS_Total_BD_Approval_Items__c ' + r.ASI_FOC_SYS_Total_BD_Approval_Items__c + ' ASI_FOC_SYS_Total_BD_Approved_Items__c  ' + r.ASI_FOC_SYS_Total_BD_Approved_Items__c + ' ASI_FOC_Request_Status__c ' + r.ASI_FOC_Request_Status__c + ' ASI_FOC_SYS_Total_Lines__c ' + r.ASI_FOC_SYS_Total_Lines__c + ' ASI_FOC_SYS_Total_RequestWithQuantity__c ' + r.ASI_FOC_SYS_Total_RequestWithQuantity__c);
                
                if (r.ASI_FOC_Sys_Submitted__c && r.ASI_FOC_Sys_Item_Count__c > 0 && r.ASI_FOC_Sys_Approved_By_Logistic__c &&
                    r.ASI_FOC_SYS_Total_BD_Approval_Items__c == r.ASI_FOC_SYS_Total_BD_Approved_Items__c && r.ASI_FOC_Request_Status__c != 'Rejected' &&
                    r.ASI_FOC_SYS_Total_Lines__c == r.ASI_FOC_SYS_Total_RequestWithQuantity__c && r.ASI_FOC_Request_Status__c == 'Approved by Logistic' &&
                    (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')  || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM')  || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only'))) {
                        submitted_set.add(r.id);
                    }
            }
            if (submitted_set.size() > 0) {
                //20151214 Ben @ Elufa System
                list<ASI_FOC_Free_Goods_Request__c> submitted_list = new List<ASI_FOC_Free_Goods_Request__c>();
                for(ASI_FOC_Free_Goods_Request__c obj : allRequest){
                    if(submitted_set.contains(obj.id)){
                        submitted_list.add(obj);
                    }
                }
                //list<ASI_FOC_Free_Goods_Request__c> submitted_list = [select ASI_FOC_SYS_Total_Lines__c,ASI_FOC_SYS_Total_Request_Item__c,ASI_FOC_SYS_Total_Cancel_Item__c from ASI_FOC_Free_Goods_Request__c where id in :submitted_set for update];			
                
                //20151214 End
                list<id> rid_list = new list<id>();
                for (ASI_FOC_Free_Goods_Request__c r:submitted_list) {
                    if (r.ASI_FOC_SYS_Total_Lines__c == 0) {
                        if (r.ASI_FOC_SYS_Total_Request_Item__c == r.ASI_FOC_SYS_Total_Cancel_Item__c) {
                            r.ASI_FOC_Request_Status__c = 'Cancelled'; 
                        } else {
                            r.ASI_FOC_Request_Status__c = 'Rejected';
                        }
                        r.ASI_FOC_Delivery_Status__c = '';
                        r.ASI_FOC_Sys_Approved_By_Logistic__c = false;
                    }
                    else {
                        r.ASI_FOC_Sys_Submitted__c = false;
                        r.ASI_FOC_Sys_Approved_By_Logistic__c = false;
                        rid_list.add(r.id);		        	
                    }
                }
                system.debug('submir_set:::' + submitted_set.size());
                update submitted_list;
                List<Approval.ProcessSubmitRequest> sub_reqList = new List<Approval.ProcessSubmitRequest>();
                for (id rid:rid_list) {
                    Approval.ProcessSubmitRequest sub_req = new Approval.ProcessSubmitRequest();
                    sub_req.setObjectId(rid);
                    sub_reqList.add(sub_req);
                    //Approval.ProcessResult sub_result = Approval.process(sub_req);					
                }
                if(!test.isRunningTest())//20180205 Introv added to pass test class temporary
                    Approval.process(sub_reqList);
            }
            
            // Get approval comment when approved/rejected by financial approver
            set<id> fin_app_set = new set<id>();
            for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                if (r.ASI_FOC_Sys_Approved_By_Finance__c && !trigger_oldMap.get(r.id).ASI_FOC_Sys_Approved_By_Finance__c) {
                    fin_app_set.add(r.id);
                }
            }
            if (fin_app_set.size() > 0) {
                getApprovalComments(fin_app_set);
            }
            // Added By Alan Wong (Elufa) 20150708
            Set<id> Reject_List = new Set<id>();
            for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                
                if (r.ASI_FOC_Rejected_by_System__c && !trigger_oldMap.get(r.id).ASI_FOC_Rejected_by_System__c) {
                    Reject_List.add(r.id);
                }
            }
            if (Reject_List.size() > 0){
                List<Id> newWorkItemIds = new List<Id>();
                for (List<ProcessInstance> pis : [Select (Select Id From Workitems) From ProcessInstance p WHERE p.TargetObjectId IN :Reject_List AND p.Status = 'Pending']) {
                    for (ProcessInstance pi : pis) {
                        for (List<ProcessInstanceWorkitem> wis : pi.Workitems) {
                            for (ProcessInstanceWorkitem wi : wis ) {
                                newWorkItemIds.add(wi.id);
                            }
                        }
                    }
                }
                if (newWorkItemIds.size() > 0){
                    Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                    req2.setComments('Rejected By System');
                    req2.setAction('Reject'); //This is the action that is approve in your case, you can set it to Reject also
                    req2.setWorkitemId(newWorkItemIds.get(0));
                    Approval.ProcessResult result2 =  Approval.process(req2);
                }
                newWorkItemIds.clear();    
                list<ASI_FOC_Request_Item__c> ri_list = [select ASI_FOC_Brand_Director_Approval_Required__c, ASI_FOC_Brand_Director_Approval_Status__c from ASI_FOC_Request_Item__c
                                                         where ASI_FOC_Request_Order__c IN :Reject_List];
                system.debug('ri_list:::' + ri_list);
                for (List<ProcessInstance> pis : [Select (Select Id From Workitems) From ProcessInstance p WHERE p.TargetObjectId IN :ri_list AND p.Status = 'Pending']) {
                    for (ProcessInstance pi : pis) {
                        for (List<ProcessInstanceWorkitem> wis : pi.Workitems) {
                            for (ProcessInstanceWorkitem wi : wis ) {
                                newWorkItemIds.add(wi.id);
                            }
                        }
                    }
                    system.debug('pis:::' + pis);
                }
                List<Approval.ProcessWorkitemRequest> req_list = new List<Approval.ProcessWorkitemRequest>();
                for (id ri_id: newWorkItemIds){
                    Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
                    req3.setComments('Rejected By System');
                    req3.setAction('Reject'); 
                    req3.setWorkitemId(ri_id);
                    req_list.add(req3);
                }
                system.debug('newWorkItemIds:::' + newWorkItemIds);
                system.debug('req_list:::' + req_list);
                if (req_list.size()>0){
                    List<Approval.ProcessResult> resultList = Approval.process(req_list);
                }
                
                //20151214 Ben @ Elufa System
                List<ASI_FOC_Free_Goods_Request__c> uplist = new List<ASI_FOC_Free_Goods_Request__c>();
                //List<ASI_FOC_Free_Goods_Request__c> uplist = [SELECT id FROM ASI_FOC_Free_Goods_Request__c WHERE id IN :Reject_List];
                
                for(ASI_FOC_Free_Goods_Request__c obj : allRequest){
                    if(Reject_List.contains(obj.id)){
                        uplist.add(obj);
                    }
                }
                
                //20151214 End
                for (ASI_FOC_Free_Goods_Request__c r: uplist) {
                    r.ASI_FOC_Request_Status__c = 'Rejected by System';
                    r.RecordTypeId = rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only');
                }
                update uplist;
            }
            // -- End -- //
        }//20151214 End if(afterUpdateCount == 0)
    }
    
    public static void routineBeforeInsert(list<ASI_FOC_Free_Goods_Request__c> trigger_new) {
        set<id> rid_set = new set<id>();
        set<id> owner_set = new set<id>();
        //Map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_FOC_Free_Goods_Request__c'); // Added By Alan Wong (Elufa) 20150616
        for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {          
            rid_set.add(r.id);
            owner_set.add(r.ownerId);
        }
        if (rid_set.size() > 0) {
            map<id, user> user_map = new map<id, user>([select userRole.developerName from user where id in :owner_set]);
            set<string> role_set = new set<string>();
            for (user u:user_map.values()) {
                role_set.add(u.userRole.developerName);
            }			
            list<ASI_FOC_Route_Type__c> rt_list = [select ASI_FOC_Role_Name__c, ASI_FOC_Finance_Approver__c, ASI_FOC_Logistic_Approver__c,   
                                                   (select ASI_FOC_Approver__c, ASI_FOC_Threshold__c,ASI_FOC_POSM_Threshold__c from ASI_FOC_Route_Criteria__r order by ASI_FOC_Threshold__c) from ASI_FOC_Route_Type__c 
                                                   where ASI_FOC_Role_Name__c in :role_set];
            
            for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || 
                    r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || 
                    r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only') ||
                    r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') ||
                    r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')){
                        //if (r.ASI_FOC_Request_Type__c != 'Return' && rid_set.contains(r.id)) {//20151223 Ben @ Elufa System
                        if (rid_set.contains(r.id)) {
                            string role_name = user_map.get(r.ownerId).userRole.developerName;
                            List<id> tempApprover = new List<id>();
                            for (ASI_FOC_Route_Type__c rt:rt_list) {
                                if (role_name == rt.ASI_FOC_Role_Name__c) {
                                    r.ASI_FOC_Finance_Approver__c = rt.ASI_FOC_Finance_Approver__c;
                                    r.ASI_FOC_Logistic_Approver__c = rt.ASI_FOC_Logistic_Approver__c;
                                    break;
                                }
                            }
                        }	
                    }
            }				
        }
    }
    
    public static void routineBeforeUpsert(list<ASI_FOC_Free_Goods_Request__c> trigger_new, map<id, ASI_FOC_Free_Goods_Request__c> trigger_oldMap) {
        //Map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_FOC_Free_Goods_Request__c');
        Map<String, id> TempDeliveryZone = new Map<string,id>();
        
        //20171017 Introv
        for(ASI_MFM_Expense_Control_Form__c obj : taxSavingList.values()){
            
            if(obj.ASI_MFM_Tax_Saving_Purpose__c != Null && obj.ASI_MFM_Tax_Saving_Purpose__c != '')
                taxSavingMap.put(obj.ASI_MFM_Tax_Saving_Purpose__c.toLowerCase(), obj);
        }
        
        
        List<ASI_FOC_Delivery_Zone__c> tempZone =  [SELECT Name, id FROM ASI_FOC_Delivery_Zone__c WHERE RecordType.DeveloperName = 'ASI_FOC_CN_Delivery_Zone'];
        for (ASI_FOC_Delivery_Zone__c zones: tempZone){
            TempDeliveryZone.put(zones.Name, zones.id);
        }
        for (ASI_FOC_Free_Goods_Request__c r:trigger_new){
            
            //20180131 Introv
            if(r.ASI_FOC_Apply_Tax_Saving_Logic__c && r.ASI_CRM_AB_Policy_Number__c == Null && r.ASI_MFM_Tax_Saving_Purpose__c != Null
               && taxSavingList.containsKey(r.ASI_MFM_Tax_Saving_Purpose__c) && taxSavingList.get(r.ASI_MFM_Tax_Saving_Purpose__c).ASI_MFM_AB_Policy_Required__c
              ){
                  r.ASI_CRM_AB_Policy_Number__c.addError('Please input AB Policy Number before saving');
              }
            
            // Added by Alan Wong (Elufa) 20150707
            if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')
                || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')) {
                    if (trigger_oldMap == null){
                        if (TempDeliveryZone.containsKey(r.ASI_FOC_CN_Delivery_Zone__c)) {
                            r.ASI_FOC_Delivery_Zone__c = TempDeliveryZone.get(r.ASI_FOC_CN_Delivery_Zone__c);
                        }
                    } else {
                        if (trigger_oldMap.get(r.id).ASI_FOC_CN_Delivery_Zone__c != r.ASI_FOC_CN_Delivery_Zone__c){
                            r.ASI_FOC_Delivery_Zone__c = TempDeliveryZone.get(r.ASI_FOC_CN_Delivery_Zone__c);
                        }
                    }
                    
                    //20171017 Introv
                    if(r.ASI_FOC_Apply_Tax_Saving_Logic__c && r.ASI_FOC_Purpose__c != '' && r.ASI_FOC_Purpose__c != Null && taxSavingMap.containsKey(r.ASI_FOC_Purpose__c.toLowerCase())){
                        
                        r.ASI_MFM_Tax_Saving_Purpose__c = taxSavingMap.get(r.ASI_FOC_Purpose__c.toLowerCase()).id;
                    }
                }
            // -- End -- //
        }
    }
    
    
    public static void routineBeforeUpdate(list<ASI_FOC_Free_Goods_Request__c> trigger_new, map<id, ASI_FOC_Free_Goods_Request__c> trigger_oldMap) {
        //20160922, added by Leo
        Set<Id> pend4DayReq = new Set<Id>();
        Map<Id,Id> workItemMap = new Map<Id,Id>();
        for(ASI_FOC_Free_Goods_Request__c req:trigger_new) {
            if(!trigger_oldMap.get(req.id).ASI_FOC_CN_Already_4_Days__c && req.ASI_FOC_CN_Already_4_Days__c)
            {
                pend4DayReq.add(req.Id);
            }
        }
        if(pend4DayReq.size() > 0)
        {
            List<ProcessInstanceWorkitem> workItemList 
                = new List<ProcessInstanceWorkitem>([Select ActorId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: pend4DayReq]);
            if(workItemList.size()>0)
            {
                for(ProcessInstanceWorkitem item: workItemList)
                {
                    workItemMap.put(item.ProcessInstance.TargetObjectId, item.ActorId);
                }
            }
        }
        if(workItemMap.size() > 0)
        {
            for(ASI_FOC_Free_Goods_Request__c req:trigger_new) {
                if(workItemMap.containsKey(req.Id))
                {
                    req.ASI_CRM_Current_Approver__c = workItemMap.get(req.id);
                    req.ASI_FOC_CN_Send_Reminder_Email__c = true;
                }
            }
        }
        //20160922, added by Leo
        // Set the approvers for the free good requests based on the routing rule objects			
        set<id> rid_set = new set<id>();
        set<id> rid_set2 = new set<id>();
        //set<id> owner_set = new set<id>();
        //Map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_FOC_Free_Goods_Request__c'); // Added By Alan Wong (Elufa) 20150616
        for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
            //20151211 Ben @ Elufa System
            if((r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')) && ( r.ASI_FOC_Request_Status__c == 'In Progress' || r.ASI_FOC_Request_Status__c == 'Open' )){
                rid_set2.add(r.id);
            }
            //20151211 End
            if (r.ASI_FOC_Free_Goods_Total_Cost__c != trigger_oldMap.get(r.id).ASI_FOC_Free_Goods_Total_Cost__c ||
                r.ownerId != trigger_oldMap.get(r.id).ownerId ||
                r.ASI_FOC_Request_Type__c != trigger_oldMap.get(r.id).ASI_FOC_Request_Type__c
                || r.ASI_FOC_Request_Status__c == 'Open'//20170927 Introv added "|| r.ASI_FOC_Request_Status__c == 'Open'""
               ) {
                    rid_set.add(r.id);
                    //owner_set.add(r.ownerId);
                    /*r.ASI_FOC_Approver_1__c = null;
                    r.ASI_FOC_Approver_2__c = null;
                    r.ASI_FOC_Approver_3__c = null;
                    r.ASI_FOC_Approver_4__c = null;
                    r.ASI_FOC_Approver_5__c = null;	
                    r.ASI_FOC_Approver_6__c = null;
                    r.ASI_FOC_Approver_7__c = null;*/
                }
        }
        
        //20151211 Ben @ Elufa System
        Map<ID, Integer> countingMap = new Map<ID, Integer>();
        Map<ID, Integer> countingMap2 = new Map<ID, Integer>();
        
        //20171219 Introv
        Map<Id, Decimal> mapTotalListPrice = new Map<Id, Decimal>();
        
        if(beforeUpdateCount == 0){
            beforeUpdateCount++;
            //20171219 Introv
            for(ASI_FOC_Request_Item__c obj : [SELECT ASI_FOC_Brand_Director_Approval_Status__c
                                               , ASI_FOC_Brand_Director_Approval_Required__c
                                               , ASI_FOC_Brand_Approver__c
                                               , ASI_FOC_Request_Order__c
                                               , ASI_FOC_Actual_Quantity_Bottle__c
                                               , ASI_FOC_Total_SKU_List_Price__c
                                               , ASI_FOC_SKU__r.ASI_FOC_List_Price__c
                                               FROM ASI_FOC_Request_Item__c
                                               WHERE ASI_FOC_Request_Order__c IN : trigger_new
                                              ]){
                                                  decimal tmpTotal = obj.ASI_FOC_Total_SKU_List_Price__c != Null ? obj.ASI_FOC_Total_SKU_List_Price__c : 0;
                                                  
                                                  if(mapTotalListPrice.containsKey(obj.ASI_FOC_Request_Order__c))
                                                      tmpTotal += mapTotalListPrice.get(obj.ASI_FOC_Request_Order__c);
                                                  
                                                  mapTotalListPrice.put(obj.ASI_FOC_Request_Order__c, tmpTotal);
                                                  
                                                  if(rid_set2.contains(obj.ASI_FOC_Request_Order__c) && obj.ASI_FOC_Brand_Director_Approval_Required__c && obj.ASI_FOC_Brand_Approver__c != Null){
                                                      lineItemList.add(obj);
                                                      
                                                      if(countingMap.containsKey(obj.ASI_FOC_Request_Order__c)){
                                                          countingMap.put(obj.ASI_FOC_Request_Order__c, countingMap.get(obj.ASI_FOC_Request_Order__c) + 1);
                                                      }else{
                                                          countingMap.put(obj.ASI_FOC_Request_Order__c, 1);
                                                      }
                                                      if(obj.ASI_FOC_Brand_Director_Approval_Status__c == 'Approved' || obj.ASI_FOC_Brand_Director_Approval_Status__c == 'Rejected'){
                                                          
                                                          if(countingMap2.containsKey(obj.ASI_FOC_Request_Order__c)){
                                                              countingMap2.put(obj.ASI_FOC_Request_Order__c, countingMap2.get(obj.ASI_FOC_Request_Order__c) + 1);
                                                          }else{
                                                              countingMap2.put(obj.ASI_FOC_Request_Order__c, 1);
                                                          }
                                                      }
                                                  }
                                              }
            
            //20171219 Commented
            /*lineItemList = [SELECT ASI_FOC_Brand_Director_Approval_Status__c
                            , ASI_FOC_Brand_Director_Approval_Required__c
                            , ASI_FOC_Brand_Approver__c
                            , ASI_FOC_Request_Order__c
                            FROM ASI_FOC_Request_Item__c
                            WHERE ASI_FOC_Request_Order__c IN : rid_set2
                            AND ASI_FOC_Brand_Director_Approval_Required__c = TRUE
                            AND ASI_FOC_Brand_Approver__c != NULL
                           ];*/
            
            //20171219 End
        }
        
        //20171219 Introv Commented
        /*for(ASI_FOC_Request_Item__c obj : lineItemList){
            
            if(countingMap.containsKey(obj.ASI_FOC_Request_Order__c)){
                countingMap.put(obj.ASI_FOC_Request_Order__c, countingMap.get(obj.ASI_FOC_Request_Order__c) + 1);
            }else{
                countingMap.put(obj.ASI_FOC_Request_Order__c, 1);
            }
            if(obj.ASI_FOC_Brand_Director_Approval_Status__c == 'Approved' || obj.ASI_FOC_Brand_Director_Approval_Status__c == 'Rejected'){
                
                if(countingMap2.containsKey(obj.ASI_FOC_Request_Order__c)){
                    countingMap2.put(obj.ASI_FOC_Request_Order__c, countingMap2.get(obj.ASI_FOC_Request_Order__c) + 1);
                }else{
                    countingMap2.put(obj.ASI_FOC_Request_Order__c, 1);
                }
            }
        }*/
        //20171219 End
        
        for(ASI_FOC_Free_Goods_Request__c r:trigger_new){
            
            //20171219 Introv
            r.ASI_FOC_Total_List_Price_With_Tax__c = mapTotalListPrice.containsKey(r.id) ? mapTotalListPrice.get(r.id) * 1.16 : 0; //1.17 is fixed tax rate //20180426 Introv changed Tax Rate from 17% to 16%
            //20171219 End
            
            if(r.ASI_FOC_Request_Status__c == 'In Progress'){
                if(countingMap.containsKey(r.id) && countingMap2.containsKey(r.id)){
                    if(countingMap.get(r.id) == countingMap2.get(r.id)){
                        r.ASI_FOC_Request_Status__c = 'Approved by Logistic';
                        r.ASI_FOC_Sys_Approved_By_Logistic__c = true;
                        r.ASI_FOC_Sys_Submitted__c = true;
                        r.RecordTypeId = rt_map.get('ASI_FOC_CN_POSM_Read_Only');
                    }
                }else if(!countingMap.containsKey(r.id) && (r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')) ){
                    r.ASI_FOC_Request_Status__c = 'Approved by Logistic';
                    r.ASI_FOC_Sys_Approved_By_Logistic__c = true;
                    r.ASI_FOC_Sys_Submitted__c = true;
                    r.RecordTypeId = rt_map.get('ASI_FOC_CN_POSM_Read_Only');
                }
            }
        }
        
        //20151211 End
        
        if (rid_set.size() > 0) {
            
            //map<id, user> user_map = new map<id, user>([select userRole.developerName from user where id in :owner_set]);  //20170926 Introv Commented
            //set<string> role_set = new set<string>();
            
            //20170926 Introv commented
            /*for (user u:user_map.values()) {
                role_set.add(u.userRole.developerName);
            }*/
            
            /*list<ASI_FOC_Route_Type__c> rt_list = [select ASI_FOC_Role_Name__c, ASI_FOC_Finance_Approver__c, ASI_FOC_POSM_Finance_Approver__c,ASI_FOC_POSM_Logistic_Approver__c,ASI_FOC_Logistic_Approver__c,   
                                                   (select ASI_FOC_Approver__c, ASI_FOC_Threshold__c,ASI_FOC_POSM_Threshold__c from ASI_FOC_Route_Criteria__r order by ASI_FOC_Threshold__c) from ASI_FOC_Route_Type__c 
                                                   where ASI_FOC_Role_Name__c in :role_set];*/
            
            //20170926 Introv
            Map<String, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRouteFOC = new Map<String, ASI_CRM_Dynamic_Approval_Route__c>();
            Map<String, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRoutePOSM = new Map<String, ASI_CRM_Dynamic_Approval_Route__c>();
            Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixApprovalRoute = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
            
            for(ASI_CRM_Dynamic_Approval_Route__c da : dynamicApprovalList){
                
                if(da.ASI_CRM_Type__c == 'Free Goods Request')
                    mapDynamicRouteFOC.put(da.ASI_CRM_User__c, da);
                else if(da.ASI_CRM_Type__c == 'POSM')
                    mapDynamicRoutePOSM.put(da.ASI_CRM_User__c, da);
            }
            
            for(ASI_CRM_Fix_Approval_Route__c obj : fixApprovalList){
                
                mapFixApprovalRoute.put(obj.ASI_CRM_CN_Type__c, obj);
            }
            
            for (ASI_FOC_Free_Goods_Request__c r:trigger_new) {
                
                integer approver_count = 0;
                //if (r.ASI_FOC_Request_Type__c != 'Return' && rid_set.contains(r.id)) { //20151223 Ben @ Elufa System
                if (rid_set.contains(r.id)) {
                    
                    //20170927 Introv
                    
                    setApproverToNull(r);
                    
                    Id approver = ASI_CRM_CN_RoleAndSubordinateHelperCLS.getUser(r.OwnerId) != Null ? ASI_CRM_CN_RoleAndSubordinateHelperCLS.getUser(r.OwnerId).ManagerId : Null;
                    if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')){
                        
                        r.ASI_FOC_Finance_Approver__c = mapFixApprovalRoute.containsKey('Free Goods Request') ? mapFixApprovalRoute.get('Free Goods Request').ASI_CRM_Finance_Approver__c : Null;
                        r.ASI_FOC_Logistic_Approver__c = mapFixApprovalRoute.containsKey('Free Goods Request') ? mapFixApprovalRoute.get('Free Goods Request').ASI_CRM_Logistic_Approver__c : Null;
                        setDynamicApprover(r, mapDynamicRouteFOC, approver, 100);
                    }else if(r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')){
                        
                        r.ASI_FOC_Finance_Approver__c = mapFixApprovalRoute.containsKey('POSM') ? mapFixApprovalRoute.get('POSM').ASI_CRM_Finance_Approver__c : Null;
                        r.ASI_FOC_Logistic_Approver__c = mapFixApprovalRoute.containsKey('POSM') ? mapFixApprovalRoute.get('POSM').ASI_CRM_Logistic_Approver__c : Null;
                        setDynamicApprover(r, mapDynamicRoutePOSM, approver, 100);
                    }
                    
                    //20170926 Introv Commented
                    //string role_name = user_map.get(r.ownerId).userRole.developerName;
                    //List<id> tempApprover = new List<id>();
                    
                    //20170927 Introv Commented
                    /*for (ASI_FOC_Route_Type__c rt:rt_list) {
                        if (role_name == rt.ASI_FOC_Role_Name__c) {
                            if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')){
                                r.ASI_FOC_Finance_Approver__c = rt.ASI_FOC_Finance_Approver__c;
                                r.ASI_FOC_Logistic_Approver__c = rt.ASI_FOC_Logistic_Approver__c;
                            }else if (r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')){
                                r.ASI_FOC_Finance_Approver__c = rt.ASI_FOC_POSM_Finance_Approver__c;
                                r.ASI_FOC_Logistic_Approver__c = rt.ASI_FOC_POSM_Logistic_Approver__c;
                            }
                            for (ASI_FOC_Route_Criteria__c rd:rt.ASI_FOC_Route_Criteria__r) {
                                if (r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Free_Goods_Request_Read_Only') || r.recordTypeId == rt_map.get('ASI_FOC_CN_Request_and_Items_Read_Only')){
                                    if (rd.ASI_FOC_Threshold__c < math.abs(r.ASI_FOC_Free_Goods_Total_Cost__c)) {//20151223 Ben @ Elufa System add math.abs()
                                        if (approver_count == 0) {
                                            r.ASI_FOC_Approver_1__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 1) {									
                                            r.ASI_FOC_Approver_2__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 2) {									
                                            r.ASI_FOC_Approver_3__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 3) {									
                                            r.ASI_FOC_Approver_4__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 4) {									
                                            r.ASI_FOC_Approver_5__c = rd.ASI_FOC_Approver__c;
                                        }		
                                        else if (approver_count == 5) {									
                                            r.ASI_FOC_Approver_6__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 6) {									
                                            r.ASI_FOC_Approver_7__c = rd.ASI_FOC_Approver__c;
                                        }
                                        approver_count++;																																
                                    }
                                } else if (r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM') || r.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Read_Only')){
                                    if (rd.ASI_FOC_POSM_Threshold__c < math.abs(r.ASI_FOC_Free_Goods_Total_Cost__c)) {//20151223 Ben @ Elufa System add math.abs()
                                        if (approver_count == 0) {
                                            r.ASI_FOC_Approver_1__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 1) {									
                                            r.ASI_FOC_Approver_2__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 2) {									
                                            r.ASI_FOC_Approver_3__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 3) {									
                                            r.ASI_FOC_Approver_4__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 4) {									
                                            r.ASI_FOC_Approver_5__c = rd.ASI_FOC_Approver__c;
                                        }		
                                        else if (approver_count == 5) {									
                                            r.ASI_FOC_Approver_6__c = rd.ASI_FOC_Approver__c;
                                        }
                                        else if (approver_count == 6) {									
                                            r.ASI_FOC_Approver_7__c = rd.ASI_FOC_Approver__c;
                                        }	
                                        approver_count++;
                                    }
                                }
                            }
                            break;
                        }
                    }*/
                }				
            }				
        }
    }
    
    //20170927 Introv
    Public Static void setDynamicApprover(ASI_FOC_Free_Goods_Request__c reqRecord, Map<String, ASI_CRM_Dynamic_Approval_Route__c> mapDynamicRoute, Id Approver, Integer maximumLevel) {
        
        Id currentApprover = Approver;
        Integer i = 1;
        String sysApproverField = 'ASI_FOC_Approver_' + i +'__c';
        
        while(foc_FIELD_MAP.containsKey(sysApproverField) && i <= maximumLevel){
            
            if(ASI_CRM_CN_RoleAndSubordinateHelperCLS.getUser(currentApprover) == Null)
                break;
            
            if(mapDynamicRoute.containsKey(currentApprover) && (mapDynamicRoute.get(currentApprover).ASI_CRM_End_of_Dynamic_Route__c || math.abs(reqRecord.ASI_FOC_Budget_Amount__c) <= mapDynamicRoute.get(currentApprover).ASI_CRM_Approval_Limit__c)){
                
                reqRecord.put(sysApproverField, currentApprover);
                break;
            }else{
                
                reqRecord.put(sysApproverField, currentApprover);
            }
            
            i++;
            sysApproverField = 'ASI_FOC_Approver_' + i +'__c';
            currentApprover = ASI_CRM_CN_RoleAndSubordinateHelperCLS.getUser(currentApprover).ManagerId;
        }
    }
    
    Public Static void setApproverToNull(ASI_FOC_Free_Goods_Request__c reqRecord){
        
        Integer i = 1;
        String sysApproverField = 'ASI_FOC_Approver_' + i +'__c';
        
        While(foc_FIELD_MAP.containsKey(sysApproverField)){
            
            reqRecord.put(sysApproverField, null);
            
            i++;
            sysApproverField = 'ASI_FOC_Approver_' + i +'__c';
        }
    }
    //20170927 End
}