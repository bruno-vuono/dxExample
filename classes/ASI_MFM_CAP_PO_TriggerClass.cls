public without sharing class ASI_MFM_CAP_PO_TriggerClass {
    
    public static void routineAfterAll (list<ASI_MFM_PO__c> trigger_new, map<id, ASI_MFM_PO__c> trigger_oldMap) {
// Update Total PO Amount in Plan object        
        set<id> pid_set = new set<id>();
        if (trigger_new != null) {
            for (ASI_MFM_PO__c po:trigger_new) {
                pid_set.add(po.ASI_MFM_Plan__c);
            }
        }
        if (trigger_oldMap != null) {
            for (ASI_MFM_PO__c po:trigger_oldMap.values()) {
                pid_set.add(po.ASI_MFM_Plan__c);
            }           
        }
        if (pid_set.size() > 0) {
            list<ASI_MFM_Plan__c> p_list = [select ASI_MFM_Currency__c, (select ASI_MFM_Exchange_Rate__c, ASI_MFM_PO_Amount__c from POs__r) from ASI_MFM_Plan__c where id in :pid_set for update];
            recordType rt;
            if(trigger_new != null) {
                rt = Global_RecordTypeCache.getRt(trigger_new[0].recordTypeId);
            }
            else {
                rt = Global_RecordTypeCache.getRt(trigger_oldMap.values()[0].recordTypeId);
            }
            // end of Changes
            for (ASI_MFM_Plan__c p:p_list) {
                p.ASI_MFM_Total_PO_Amount__c = 0;
                for (ASI_MFM_PO__c po:p.POs__r) {
                    if (po.ASI_MFM_Exchange_Rate__c > 0) {
                        if (rt.developerName.startsWith('ASI_MFM_TW') && p.ASI_MFM_Currency__c == 'TWD') {
                            p.ASI_MFM_Total_PO_Amount__c += (po.ASI_MFM_PO_Amount__c * po.ASI_MFM_Exchange_Rate__c).setScale(0, roundingmode.half_up);
                        }
                        else {
                            p.ASI_MFM_Total_PO_Amount__c += (po.ASI_MFM_PO_Amount__c * po.ASI_MFM_Exchange_Rate__c).setScale(2, roundingmode.half_up);
                        }
                    }
                }
            }
            update p_list;
        }
    }

    public static void routineAfterDelete(list<ASI_MFM_PO__c> trigger_old) {
// Delete PO in Data Warehouse
        if (!ASI_MFM_Function.bypassCallouts()) {
            list<id> pid_list = new list<id>();
            for (ASI_MFM_PO__c p:trigger_old) {
                pid_list.add(p.id);
            }
        }
// Update Total PO Amount in Plan object        
        set<id> pid_set = new set<id>();
            for (ASI_MFM_PO__c po:trigger_old) {
                if(po.ASI_MFM_Plan__c != null)
                    pid_set.add(po.ASI_MFM_Plan__c);
            }
            if(pid_set.size() >0 )
            {
            list<ASI_MFM_Plan__c> p_list = [select ASI_MFM_Currency__c, (select ASI_MFM_Exchange_Rate__c, ASI_MFM_PO_Amount__c from POs__r) from ASI_MFM_Plan__c where id in :pid_set for update];
            for (ASI_MFM_Plan__c p:p_list) {
                p.ASI_MFM_Total_PO_Amount__c = 0;
                for (ASI_MFM_PO__c po:p.POs__r) {
                    // DC - 01/18/2016 - Added null check on PO Amount and Exchange Rate fields before calculating
                    // Total PO Amount on parent plan.
                    Decimal poAmount = (po.ASI_MFM_PO_Amount__c != NULL) ? po.ASI_MFM_PO_Amount__c : 0.0;
                    Decimal exchangeRate = (po.ASI_MFM_Exchange_Rate__c != NULL) ? po.ASI_MFM_Exchange_Rate__c : 0.0;
                    p.ASI_MFM_Total_PO_Amount__c += (poAmount * exchangeRate).setScale(2, roundingmode.half_up);
                }
            }
            if(p_list.size() > 0)
                update p_list;    
          }
    }

    public static void routineAfterInsert(list<ASI_MFM_PO__c> trigger_new) {
        set<id> pid_set = new set<id>();
        map<id, id> cid_map = new map<id, id>();
        //Added TR Logic check if the PO is extended from original PO, clone only line item with next year marked.
        boolean isExtended = false;
            
        for (ASI_MFM_PO__c p:trigger_new) {
            if (p.ASI_MFM_Cloned_PO_ID__c != p.id) {
                pid_set.add(p.id);
                if (p.ASI_MFM_Cloned_PO_ID__c != null) {
                    if (p.ASI_MFM_Is_Extended_PO__c)
                        isExtended = true;
                    cid_map.put(p.id, p.ASI_MFM_Cloned_PO_ID__c);
                }   
            }
        }

// Set cloned PO ID to the new PO ID 
// Set the status to Draft for cloned PO         
        if (pid_set.size() > 0) {
            list<ASI_MFM_PO__c> PO_list = [select ASI_MFM_Cloned_PO_ID__c from ASI_MFM_PO__c where id in :pid_set for update];
            for (ASI_MFM_PO__c p:PO_list) {
                if (p.ASI_MFM_Cloned_PO_ID__c != null) {
                    p.ASI_MFM_Status__c = 'Draft';
                }               
                p.ASI_MFM_cloned_PO_id__c = p.id;
            }
            update PO_list;
        } 

// If cloned PO ID is not null, clone the line items of the cloned PO to the new PO         
        if (cid_map.size() > 0) {
            
            list<id> cid_list = cid_map.values();
            string query_string = 'select ASI_MFM_Is_Extended_PO__c,(' + ASI_MFM_Function.buildQuery('ASI_MFM_PO_line_item__c', null, 'PO_line_items__r order by name') + ') from ASI_MFM_PO__c where id in :cid_list';
            map<id, ASI_MFM_PO__c> clone_map = new map<id, ASI_MFM_PO__c>();
            for (ASI_MFM_PO__c p:database.query(query_string)) {
                clone_map.put(p.id, p);
            }           
            list<ASI_MFM_PO_line_item__c> cloned_pi_list = new list<ASI_MFM_PO_line_item__c>();
            list<ASI_MFM_PO_line_item__c> pi_list = new list<ASI_MFM_PO_line_item__c>(); 
            for (id PO_id:cid_map.keySet()) {
                cloned_pi_list = clone_map.get(cid_map.get(PO_id)).PO_line_items__r;
                for (ASI_MFM_PO_line_item__c cloned_pi:cloned_pi_list) {
                    if ((!isExtended) ||  (isExtended && cloned_pi.ASI_MFM_Next_Year__c))
                    {
                        System.debug('isExtended: ' + isExtended + 'Next Year: ' + cloned_pi.ASI_MFM_Next_Year__c);
                        ASI_MFM_PO_line_item__c pi = cloned_pi.clone(false, true);
                        pi.ASI_MFM_PO__c = PO_id;
                        pi.ASI_MFM_PO_Line_Item_External_ID__c = null;
                        pi_list.add(pi);
                    }
                }
            }
            insert pi_list;
        }       
    } 

    public static void routineAfterUpsert(list<ASI_MFM_PO__c> trigger_new, map<id, ASI_MFM_PO__c> trigger_oldMap) {
// Pass PO and line item details to Data Warehouse
        if (!ASI_MFM_Function.bypassCallouts()) {       
            set<id> pid_set = new set<id>();
            for (ASI_MFM_PO__c p:trigger_new) {
                if (trigger_oldMap == null || p.ASI_MFM_Sys_Sync_Time__c == trigger_oldMap.get(p.id).ASI_MFM_Sys_Sync_Time__c) {
                    pid_set.add(p.id);
                }               
            }
        }    
    }

    public static void routineAfterUpdate(list<ASI_MFM_PO__c> trigger_new, map<id, ASI_MFM_PO__c> trigger_oldMap) {
// Populate the exchange rate to PO line items
        map<id, decimal> xrate_map = new map<id, decimal>();
        for (ASI_MFM_PO__c p:trigger_new) { 
            if (p.ASI_MFM_Exchange_Rate__c != trigger_oldMap.get(p.id).ASI_MFM_Exchange_Rate__c) {
                xrate_map.put(p.id, p.ASI_MFM_Exchange_Rate__c);
            }
        } 
        if (xrate_map.size() > 0) {
            list<ASI_MFM_PO_Line_Item__c> pol_list = [select ASI_MFM_PO__c from ASI_MFM_PO_Line_Item__c where ASI_MFM_PO__c in :xrate_map.keySet() for update]; 
            for (ASI_MFM_PO_Line_Item__c pol:pol_list) {
                pol.ASI_MFM_Exchange_Rate__c = xrate_map.get(pol.ASI_MFM_PO__c);
            }
            update pol_list;
        }       

        /*for (ASI_MFM_PO__c p:trigger_new) {           
            if (Global_RecordTypeCache.getRt(p.recordTypeId).developerName.contains('ASI_MFM_JP') || 
                Global_RecordTypeCache.getRt(p.recordTypeId).developerName.contains('ASI_MFM_RM')){    
            
                if (p.ASI_MFM_PO_Amount__c != null && p.ASI_MFM_Exchange_Rate__c > 0) {
                    if (p.ASI_MFM_Status__c == 'Final' && 
                            (trigger_oldMap.get(p.id).ASI_MFM_Status__c == 'Draft' || trigger_oldMap.get(p.id).ASI_MFM_Status__c == 'Submitted') && 
                                p.ASI_MFM_Original_PO_for_Adjustment__c != null){
                        String soql = getCreatableFieldsSOQL('ASI_MFM_PO_Line_Item__c','ASI_MFM_PO__c= \'' + p.id + '\'');
                        System.debug('SOQL: ' + soql);
                        List<ASI_MFM_PO_Line_Item__c> plList = (List<ASI_MFM_PO_Line_Item__c>)Database.query(soql);
                        List<ASI_MFM_PO_Line_Item__c> plListForInsert = new List<ASI_MFM_PO_Line_Item__c>();
                        
                        for (ASI_MFM_PO_Line_Item__c pl : plList){
                            ASI_MFM_PO_Line_Item__c pl2 = pl.clone(false, true);
                            pl2.ASI_MFM_PO__c = p.ASI_MFM_Original_PO_for_Adjustment__c;
                            pl2.ASI_MFM_Adjust_PO_Number__c = p.id;
                            plListForInsert.add(pl2);
                            
                            pl.ASI_MFM_Adjust_PO_Number__c = null;
                            pl.ASI_MFM_Adjusted_Amount__c = pl.ASI_MFM_Amount__c;
                            pl.ASI_MFM_Amount__c = 0;
                            pl.ASI_MFM_JDE_Status__c = 'Paid';
                        }
                        insert plListForInsert;
                        update plList;
                    }
                }
            }
        }*/
//End of modification       
    }
    
    public static void routineBeforeDelete(list<ASI_MFM_PO__c> trigger_old) {
// Not allowed to delete if the PO has related payment line items       
        set<id> po_set = new set<id>();
        for (ASI_MFM_PO__c p:trigger_old) { 

            if (p.ASI_MFM_Status__c == 'Final' || p.ASI_MFM_Status__c == 'Complete')
                p.addError('Not allowed to delete because the PO is in \'Final\' or \'Complete\' status');



            po_set.add(p.id);
        }
        list<ASI_MFM_Payment_Line_Item__c> pi_list = [select ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c from ASI_MFM_Payment_Line_Item__c 
            where ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c in :po_set order by ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c];
        map<id, integer> pi_map = new map<id, integer>();
        id current_pid;
        integer pi_count = 0;
        for (ASI_MFM_Payment_Line_Item__c pi:pi_list) {
            if (pi.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c != current_pid) {
                pi_map.put(current_pid, pi_count);
                current_pid = pi.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c;
                pi_count = 1;
            }
            else {
                pi_count++;
            }
        }
        if (current_pid != null) {
            pi_map.put(current_pid, pi_count);
        }
        for (ASI_MFM_PO__c p:trigger_old) { 
            if (pi_map.get(p.id) > 0) {
                p.addError('Not allowed to delete because it has related payment line items');
            }
        }
    }

    public static void routineBeforeInsert(list<ASI_MFM_PO__c> trigger_new) {

        //CAPEX: Approvers route type logic
        ID CAPEXRouteTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_Route_Type__cASI_MFM_CAP_Route_Type');
        ID ASI_MFM_CAP_TWRouteTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_Route_Type__cASI_MFM_CAP_OTH_Route_Type');
        
        List<ASI_MFM_Route_Type__c> routeTypeList = [SELECT ID, Name, RecordTypeId, ASI_MFM_Country__c, ASI_MFM_Module__c,
                                                           (SELECT ID, Name, ASI_MFM_Approver__c 
                                                            FROM ASI_MFM_Route_Rule_Details__r 
                                                            ORDER BY ASI_MFM_Sequence__c ASC)
                                                     FROM ASI_MFM_Route_Type__c
                                                     WHERE ASI_MFM_Module__c = 'PO' 
                                                     AND (recordtypeid = : CAPEXRouteTypeID 
                                                     OR recordtypeid = :  ASI_MFM_CAP_TWRouteTypeID)
                                                     AND (ASI_MFM_Country__c =  'HK' 
                                                     OR ASI_MFM_Country__c =  'TW')];
        
        if (routeTypeList.size() > 0){
            List<ASI_MFM_Route_Rule_Detail__c> routeDetailsListHK = new List<ASI_MFM_Route_Rule_Detail__c>();
            List<ASI_MFM_Route_Rule_Detail__c> routeDetailsListTW = new List<ASI_MFM_Route_Rule_Detail__c>();
            
            //Iterating Route Type to Identify Route Type Details for 'HK' adn 'TW'
            for(ASI_MFM_Route_Type__c routeType : routeTypeList){
                if(routeType.RecordTypeId == CAPEXRouteTypeID && routeType.ASI_MFM_Country__c ==  'HK'){
                    routeDetailsListHK = routeType.ASI_MFM_Route_Rule_Details__r;
                }
                else if(routeType.RecordTypeId == ASI_MFM_CAP_TWRouteTypeID && routeType.ASI_MFM_Country__c ==  'TW'){
                    routeDetailsListTW = routeType.ASI_MFM_Route_Rule_Details__r;
                }
            }//End for
            
            
            for (ASI_MFM_PO__c poRecord : trigger_new){  
                //Checking if the RecordType contains ASI_MFM_CAP_TW
                if(Global_RecordTypeCache.getRt(poRecord.recordTypeId).developerName.contains('ASI_MFM_CAP_TW') &&
                   routeDetailsListTW <> null && !routeDetailsListTW.isEmpty()){
                    populateApprover(poRecord, null, routeDetailsListTW);
                }//End if
                else if(routeDetailsListHK <> null && !routeDetailsListHK.isEmpty()){
                    populateApprover(poRecord, 'HK', routeDetailsListHK);
                }//End else
            }//End for trigger_new
        }//End if routeTypeList.size() > 0
                   
        set<id> px_set = new set<id>();
        List<ASI_MFM_PO_Date_Range__c> pr = new List<ASI_MFM_PO_Date_Range__c>();

            
        for (ASI_MFM_PO__c p:trigger_new) {
            if (p.asi_mfm_prefix__c != null) {
                px_set.add(p.asi_mfm_prefix__c);
            }
        }
        
        map<id, asi_mfm_prefix__c> px_map = new map<id, asi_mfm_prefix__c>([select name, asi_mfm_next_number__c from asi_mfm_prefix__c 
            where asi_mfm_module__c = 'PO' and id in :px_set for update]);
            
        for (ASI_MFM_PO__c p:trigger_new) {
            if (px_map.containsKey(p.asi_mfm_prefix__c)) {
                p.name = px_map.get(p.asi_mfm_prefix__c).name + string.valueOf(px_map.get(p.asi_mfm_prefix__c).asi_mfm_next_number__c + 10000).substring(1, 5);
                if (Global_RecordTypeCache.getRt(p.recordTypeId).developerName.contains('ASI_MFM_JP_PO') && pr.size() > 0){
                        p.ASI_MFM_PO_Date_Range__c = pr[0].id;
                        //p.ASI_MFM_GL_Date__c = pr[0].ASI_MFM_GL_Date__c;
                        p.name = px_map.get(p.asi_mfm_prefix__c).name + string.valueOf(px_map.get(p.asi_mfm_prefix__c).asi_mfm_next_number__c + 1000000).substring(1, 7);
                        p.ASI_MFM_JP_PO_Number__c = p.name + ' - ' + pr[0].name ;
                        /*if (pr[0].asi_mfm_next_number__c != null)
                            pr[0].asi_mfm_next_number__c  ++;
                        else
                            pr[0].asi_mfm_next_number__c = 1;*/
                }
                else{
                    p.name = px_map.get(p.asi_mfm_prefix__c).name + string.valueOf(px_map.get(p.asi_mfm_prefix__c).asi_mfm_next_number__c + 10000).substring(1, 5);
                 }
                
                
               
                px_map.get(p.asi_mfm_prefix__c).asi_mfm_next_number__c++;
            }
        }
        update pr;
        ASI_MFM_Function.updatePrefix(px_map.values());        
    }//End routineBeforeInsert method
    
    
    //The method will populate Approvers on PO record 
    public static void populateApprover(ASI_MFM_PO__c poRecord, String pType,
                                        List<ASI_MFM_Route_Rule_Detail__c> pLstRouteRuleDtls){
        Integer approverCount = 0;
        system.debug('**pLstRouteRuleDtls***' + pLstRouteRuleDtls);
        system.debug('**pLstRouteRuleDtls size***' + pLstRouteRuleDtls.size());
        if(pType == 'HK'){
            poRecord.ASI_MFM_Sys_Approver_1__c = pLstRouteRuleDtls[0].ASI_MFM_Approver__c;
            pLstRouteRuleDtls.remove(0);
        }
            
        for(ASI_MFM_Route_Rule_Detail__c routeDetail : pLstRouteRuleDtls){
            if (approverCount == 0) 
                poRecord.ASI_MFM_Sys_Approver_2__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 1)                                  
                poRecord.ASI_MFM_Sys_Approver_3__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 2)                                
                poRecord.ASI_MFM_Sys_Approver_4__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 3)                                  
                poRecord.ASI_MFM_Sys_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 4)                                  
                poRecord.ASI_MFM_Sys_Approver_6__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 5)                                  
                poRecord.ASI_MFM_Sys_Approver_7__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 6)                                 
                poRecord.ASI_MFM_Sys_Approver_8__c = routeDetail.ASI_MFM_Approver__c;
            
            else if (approverCount == 7)                                  
                poRecord.ASI_MFM_Sys_Approver_9__c = routeDetail.ASI_MFM_Approver__c;
            
           approverCount++;
        }//End for 
    }//End assignApprover method
    
    
    
    public static void routineBeforeUpdate(list<ASI_MFM_PO__c> trigger_new, map<id, ASI_MFM_PO__c> trigger_oldMap) {
// Set the approvers for the PO based on the routing rule objects           
        set<id> pid_set = new set<id>();
        set<id> px_set = new set<id>();
        set<id> pr_set = new set<id>();
        boolean isJP = false;
        boolean isTRLogic = false;
        id overrideRouteTypeId =  null;
        for (ASI_MFM_PO__c p:trigger_new) {
            
        }
        
// Get rejection comment when rejected
        set<id> rejected_set = new set<id>();
        map<id, ASI_MFM_PO__c> reject_map = new map<id, ASI_MFM_PO__c>();
        for (ASI_MFM_PO__c p:trigger_new) { 
            if (p.ASI_MFM_Status__c == 'Draft' && trigger_oldMap.get(p.id).ASI_MFM_Status__c == 'Submitted') {
                reject_map.put(p.id, p);
            }
        }
        if (reject_map.size() > 0) {
            list<ASI_MFM_PO__c> reject_list = [select (select Comments from ProcessSteps order by createdDate desc limit 1) from ASI_MFM_PO__c where id in :reject_map.keySet()];
            for (ASI_MFM_PO__c r:reject_list) {
                if (r.processSteps.size() > 0 && reject_map.containsKey(r.id)) {
                    reject_map.get(r.id).ASI_MFM_Sys_Rejected__c = true;
                    reject_map.get(r.id).ASI_MFM_Sys_Reject_Comments__c = r.processSteps[0].comments;
                }
            }
        }
        
//TW Logic: All the related payments must be in completed status before a PO can be set to completed status
        map<id, ASI_MFM_PO__c> completed_map = new map<id, ASI_MFM_PO__c>(); 
        for (ASI_MFM_PO__c p:trigger_new) { 
            if (Global_RecordTypeCache.getRt(p.recordTypeId).developerName.contains('ASI_MFM_TW')){
                if (p.ASI_MFM_Status__c == 'Complete' && trigger_oldMap.get(p.id).ASI_MFM_Status__c != 'Complete') {
                    completed_map.put(p.id, p);
                }
            }
        }
        if (completed_map.size() > 0) {
            set<id> incompleted_set = new set<id>();
            for (ASI_MFM_Payment_Line_Item__c pli:[select ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c from ASI_MFM_Payment_Line_Item__c 
                where ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c in :completed_map.keySet() and ASI_MFM_Payment__r.ASI_MFM_Status__c != 'Complete']) {
                incompleted_set.add(pli.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c);
            }
            if (incompleted_set.size() > 0) {
                for (id pid:completed_map.keySet()) {
                    if (incompleted_set.contains(pid)) {
                        completed_map.get(pid).ASI_MFM_Status__c.addError('Cannot set to \'Complete\' status because the related payments are not completed yet');                          
                    }
                }
            }
        }
//End of TW Logic for Complete PO       
    } 

    
    public static void routineBeforeUpsert(list<ASI_MFM_PO__c> trigger_new, map<id, ASI_MFM_PO__c> trigger_oldMap) {
        // Retrieve exchange rate if no input 
        set<id> po_set = new set<id>();
         set<id> acc_set = new set<id>();
        set<string> ccy_set = new set<string>(); 
        date last_effective_date;
        System.debug('routineBeforeUpsert');
        //20140410 Steve Wan Default BU for JP
        Map<string, id> MRecType = new map<string, id>();
        List<recordType> rtList = Global_RecordTypeCache.getRtList('ASI_MFM_PO__c');
        for (recordType rtt:rtList) {
            MRecType.put(rtt.DeveloperName, rtt.id);            
        }
        String JPRecTypeID = MRecType.get('ASI_MFM_JP_PO');
        String JPBUCodeDefault;
        
        String MYRecTypeID = MRecType.get('ASI_MFM_MY_PO');
        String MYBUCodeDefault;
       
        for (ASI_MFM_PO__c po:trigger_new) {
        
            // Check if there was an input in the decimal number output error
            boolean isDecimal = 
            (ASI_MFM_Function.containsDecimalValue(po.ASI_MFM_PO_Original_Amount__c) || 
            ASI_MFM_Function.containsDecimalValue(po.ASI_MFM_PO_Amount__c)) && po.ASI_MFM_Currency__c == 'TWD';
            if (isDecimal)
                po.addError(' You Cannot input a decimal number for a TWD currency.');
            
            if (po.ASI_MFM_Exchange_Rate__c == null) {
                po_set.add(po.id);
                ccy_set.add(po.ASI_MFM_Currency__c);
                if (last_effective_date == null || po.ASI_MFM_PO_Raised_Date__c > last_effective_date) {
                    last_effective_date = po.ASI_MFM_PO_Raised_Date__c;
                }
            }
            //***** edited by Leo Hui (Introv) - for CN PO change currency (start) *****
            else
            {               
                //---- check if record type = CN ----

            }
            //***** edited by Leo Hui (Introv) - for CN PO change currency (end) *****
        }
        
        if (po_set.size() > 0) {
            // retrieve record type developerName from Global cache
            //string country = [select developerName from recordType where id = :trigger_new[0].recordTypeId].developerName.substring(8, 10);
            string country = Global_RecordTypeCache.getRt(trigger_new[0].recordTypeId).developerName.substring(8, 10);
            ////
            
            //Steve Wan 20140527 Edit for special handling in TR
           
            System.debug('country '+country );
            if (country == 'TR')
            {
                //System.debug(acc_list);
                if( trigger_new[0].ASI_MFM_TR_Rec_Type__c == 'JDF')
                {
                    trigger_new[0].ASI_MFM_Sys_Local_Currency__c = 'JPY';
                    country = 'JP';
                    
                }else
                {
                    trigger_new[0].ASI_MFM_Sys_Local_Currency__c = 'HKD';
                    country = 'HK';
                }
            }
            // Conrad Pantua 20140704 Handle Capex Country (Laputa)
            if (country == 'CA')
            {
                System.debug('------ DC country ------ : ' + country);
                List<User> lstUsers = [SELECT Id,
                                              ASI_MFM_Country__c
                                         FROM User
                                        WHERE Id = :UserInfo.getUserId()
                                        LIMIT 1];

                System.debug('------ DC lstUsers ------ : ' + lstUsers[0]);

                if(!lstUsers.isEmpty() && !String.isBlank(lstUsers[0].ASI_MFM_Country__c) && lstUsers[0].ASI_MFM_Country__c.equalsIgnoreCase('TW')) {
                    country = 'TW';
                    trigger_new[0].ASI_MFM_Sys_Local_Currency__c = 'TWD';
                } else {
                    country = 'HK';
                    trigger_new[0].ASI_MFM_Sys_Local_Currency__c = 'HKD';
                }
            }
            System.debug('------ DC country ------ : ' + country);
            string base_ccy = trigger_new[0].ASI_MFM_Sys_Local_Currency__c;         
            list<ASI_MFM_Exchange_Rate__c> xr_list = [select ASI_MFM_Counter_Currency__c, ASI_MFM_Effective_Date__c, ASI_MFM_Exchange_Rate__c from ASI_MFM_Exchange_Rate__c
                where ASI_MFM_Application__c = 'MFM' and ASI_MFM_Country__c = :country and ASI_MFM_Base_Currency__c = :base_ccy
                and ASI_MFM_Counter_Currency__c in :ccy_set and ASI_MFM_Effective_Date__c <= :last_effective_date
                order by ASI_MFM_Counter_Currency__c asc, ASI_MFM_Effective_Date__c desc];
            System.debug(country+'/'+base_ccy+'/'+ccy_set+'/'+last_effective_date);
            System.debug(xr_list);
            for (ASI_MFM_PO__c po:trigger_new) {
                if (po_set.contains(po.id)) {
                    if (po.ASI_MFM_Currency__c == po.ASI_MFM_Sys_Local_Currency__c) {
                        po.ASI_MFM_Exchange_Rate__c = 1;
                    }
                    else {
                        po.ASI_MFM_Exchange_Rate__c = null; 
                        if (po.ASI_MFM_Currency__c != null && po.ASI_MFM_PO_Raised_Date__c != null) {                                                                           
                            for (ASI_MFM_Exchange_Rate__c xr:xr_list) {
                                if (xr.ASI_MFM_Counter_Currency__c == po.ASI_MFM_Currency__c && xr.ASI_MFM_Effective_Date__c <= po.ASI_MFM_PO_Raised_Date__c) {
                                    po.ASI_MFM_Exchange_Rate__c = xr.ASI_MFM_Exchange_Rate__c;
                                    break;
                                }
                                else if (xr.ASI_MFM_Counter_Currency__c > po.ASI_MFM_Currency__c) {
                                    break;
                                }
                            }
                        }
                    }               
                }
            }                       
        }
        
// Set default BU code if not input by user
        recordType rt = Global_RecordTypeCache.getRt(trigger_new[0].recordTypeId);
        string country_pfx = 'ASI_MFM_' + rt.developerName.substring(8,10) + '%';
        list<ASI_MFM_BU__c> bu_list = [select id from ASI_MFM_BU__c where recordType.developerName like :country_pfx];
        if (bu_list.size() == 1) {
            for (ASI_MFM_PO__c po:trigger_new) {
            //20140410 Steve Wan Default BU for JP
                if (po.ASI_MFM_BU_Code__c == null) {
                    po.ASI_MFM_BU_Code__c = bu_list[0].id;
                }
            } 
        }
        
    
// The prefix must be for PO
// The prefix must be valid for the owner
        set<id> owner_set = new set<id>();
        set<id> prefix_set = new set<id>();
        list<ASI_MFM_PO__c> PO_list = new list<ASI_MFM_PO__c>();
        for (ASI_MFM_PO__c p:trigger_new) {
            if (trigger_oldMap == null || p.ownerId != trigger_oldMap.get(p.id).ownerId || p.ASI_MFM_Prefix__c != trigger_oldMap.get(p.id).ASI_MFM_Prefix__c) {
                owner_set.add(p.ownerId);
                prefix_set.add(p.ASI_MFM_Prefix__c);
                PO_list.add(p);
            }
        }
        if (PO_list.size() > 0) {
            map<id, user> owner_map = new map<id, user>([select userRole.DeveloperName from user where id in :owner_set]);
            map<id, ASI_MFM_Prefix__c> prefix_map = new map<id, ASI_MFM_Prefix__c>([select (select ASI_MFM_Role_Name__c from ASI_MFM_Role_Prefix_Relationships__r) 
                from ASI_MFM_Prefix__c where id in :prefix_set and ASI_MFM_Module__c = 'PO']);
            for (ASI_MFM_PO__c p:PO_list) {
                if (!prefix_map.containsKey(p.ASI_MFM_Prefix__c)) {
                    p.ASI_MFM_Prefix__c.addError('The prefix is not valid for PO');
                }
                else {
                    string owner_role = owner_map.get(p.ownerId).userRole.DeveloperName;
                    boolean valid_prefix = false;               
                    for (ASI_MFM_Role_Prefix_Relationship__c pr:prefix_map.get(p.ASI_MFM_Prefix__c).ASI_MFM_Role_Prefix_Relationships__r) {
                        if (pr.ASI_MFM_Role_Name__c == owner_role) {
                            valid_prefix = true;
                            break;
                        }
                    }
                    if (!valid_prefix) {
                        p.ASI_MFM_Prefix__c.addError('The prefix is not valid for the owner');                  
                    }
                }
            }
        }
        
//Added by Wilken on 20140311, Clone for adjust PO should not allow user to change PO currency      
        //Modified by Wilken 20140317, reduce SOQL usage
        //map<id, recordType> rt_map = new map<id, recordType>([select id, developerName from recordType where sobjectType = 'ASI_MFM_PO__c']);
    }

 // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
   /* public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }   */
    /*
    public static String GetKeyPrefix(String ObjId)  
      {  
          // get all objects from the org  
          Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();  
            
          // to store objects and their prefixes  
          Map<String, String> keyPrefixMap = new Map<String, String>{};  
            
          //get the object prefix in IDs  
          Set<String> keyPrefixSet = gd.keySet();  
            
          // fill up the prefixes map  
          for(String sObj : keyPrefixSet)  
          {  
              Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();  
              String tempName = r.getName();  
              String tempPrefix = r.getKeyPrefix();  
              keyPrefixMap.put(tempPrefix, tempName);  
          }   
          String tPrefix = ObjId;  
          tPrefix = tPrefix.subString(0,3);  
            
          //get the object type now  
          String objectType = keyPrefixMap.get(tPrefix);  
          return objectType;  
      }  */
}