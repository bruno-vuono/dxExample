/*********************************************************************************
 * Name:ASI_MFM_CAP_Plan_TriggerClass
 * Description: Plan Trigger class tailored for Capex and Opex.
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
  * 2017-08-04       Wilken Lee			    [WL 1.0] Reduce HK CAPEX SOQL in Direct Payment. Only retrieve Plan Approver if Plan Amount Changed
*********************************************************************************/
public without sharing class ASI_MFM_CAP_Plan_TriggerClass {
    public static void routineAfterDelete(list<ASI_MFM_Plan__c> trigger_old) {     
    }

    public static void routineBeforeDelete (list<ASI_MFM_Plan__c> trigger_old) {
        // Not allowed to delete final plan
        Set<id> pid_set = new Set<id>();
        for (ASI_MFM_Plan__c plan : trigger_old){
            if (plan.ASI_MFM_Status__c == 'Final' || plan.ASI_MFM_Status__c == 'Complete')
                 plan.addError('Not allowed to delete because the plan is in \'Final\' or \'Complete\' status');
        }
        
        if (pid_set.size() > 0) {
            map<id, ASI_MFM_Plan__c> p_map = new map<id, ASI_MFM_Plan__c>([select (select id from POs__r) from ASI_MFM_Plan__c where id in :pid_set]);
            for (ASI_MFM_Plan__c p:trigger_old) {
                if (p_map.containsKey(p.id) && p_map.get(p.id).POs__r.size() > 0) {
                    system.debug('PO count: ' + p_map.get(p.id).POs__r.size());
                    p.addError('Not allowed to delete because the plan contains PO');
                }
            }
        }
    }
        
    public static void routineAfterInsert(list<ASI_MFM_Plan__c> trigger_new) {
        set<id> pid_set = new set<id>();
        map<id, id> cid_map = new map<id, id>();
        for (ASI_MFM_Plan__c p:trigger_new) {
            if (p.ASI_MFM_Cloned_Plan_ID__c != p.id) {
                pid_set.add(p.id);
                if (p.ASI_MFM_Cloned_Plan_ID__c != null) {
                    cid_map.put(p.id, p.ASI_MFM_Cloned_Plan_ID__c);
                }    
            }                
        }

// Set cloned plan ID to the new plan ID 
// Set the status to Draft for cloned plan       
        if (pid_set.size() > 0) {
            list<ASI_MFM_plan__c> plan_list = [select ASI_MFM_cloned_plan_id__c from ASI_MFM_plan__c where id in :pid_set for update];
            for (ASI_MFM_plan__c p:plan_list) {
                if (p.ASI_MFM_cloned_plan_id__c != null) {
                    p.ASI_MFM_Status__c = 'Draft';
                }
                p.ASI_MFM_cloned_plan_id__c = p.id;
                p.ASI_MFM_Sys_Sync_Time__c = datetime.now();
            }
            update plan_list;
        } 

// If cloned plan ID is not null, clone the line items of the cloned plan to the new plan         
        if (cid_map.size() > 0) {
            list<id> cid_list = cid_map.values();
            string query_string = 'select (' + ASI_MFM_Function.buildQuery('ASI_MFM_plan_line_item__c', null, 'plan_line_items__r order by name') + ') from ASI_MFM_plan__c where id in :cid_list';
            map<id, ASI_MFM_plan__c> clone_map = new map<id, ASI_MFM_plan__c>();
            
            for (ASI_MFM_plan__c p:database.query(query_string)) {
                clone_map.put(p.id, p);
            }
            
            list<ASI_MFM_plan_line_item__c> cloned_pi_list = new list<ASI_MFM_plan_line_item__c>();
            list<ASI_MFM_plan_line_item__c> pi_list = new list<ASI_MFM_plan_line_item__c>(); 
            
            for (id plan_id:cid_map.keySet()) {
                cloned_pi_list = clone_map.get(cid_map.get(plan_id)).plan_line_items__r;
                for (ASI_MFM_plan_line_item__c cloned_pi:cloned_pi_list) {
                    ASI_MFM_plan_line_item__c pi = cloned_pi.clone(false, true);
                    pi.ASI_MFM_plan__c = plan_id;
                    pi.ASI_MFM_Sys_Deduplication_Key__c = null;
                    pi.ASI_MFM_Plan_Line_Item_External_ID__c = null;
                    pi_list.add(pi);
                }
            }
            insert pi_list;
        }       
    } 

    public static void routineAfterUpsert(list<ASI_MFM_Plan__c> trigger_new, map<id, ASI_MFM_Plan__c> trigger_oldMap) {
    }

    public static void routineBeforeInsert(list<ASI_MFM_Plan__c> trigger_new) {
        //CAPEX: Approvers route type logic
        list<ASI_MFM_Brand_Route_Type_Map__c> brm_list = new list<ASI_MFM_Brand_Route_Type_Map__c>();
        set<id> px_set = new set<id>();
        
        for (ASI_MFM_Plan__c p:trigger_new) {
                px_set.add(p.ASI_MFM_Prefix__c);                                                       
        }       
        
		/*[WL 1.0 BEGIN]*/
        populateApprovers(trigger_new, null, px_set, false);
		//populateApprovers(trigger_new, px_set, false);
		/*[WL 1.0 END]*/
		
        /*if (Global_RecordTypeCache.getRt(trigger_new.get(0).recordTypeID).DeveloperName.contains('ASI_MFM_CAP_Plan')){
            //HK CAPEX OPEX Logic
            brm_list = [select ASI_MFM_Prefix__c, ASI_MFM_Route_Type__c from ASI_MFM_Brand_Route_Type_Map__c 
                    where ASI_MFM_Active__c = true and ASI_MFM_Prefix__c in :px_set order by ASI_MFM_Prefix__c desc];
        } 
        // DC - 02/09/2016 - Added logic for populating approvers if record type is "CAP TW".
        else if(Global_RecordTypeCache.getRt(trigger_new.get(0).recordTypeID).DeveloperName.contains('ASI_MFM_CAP_TW_Plan')) {
            brm_list = [SELECT ASI_MFM_Prefix__c,
                               ASI_MFM_Route_Type__c,
                               ASI_MFM_Sequence__c
                          FROM ASI_MFM_Brand_Route_Type_Map__c 
                         WHERE ASI_MFM_Active__c = true
                           AND ASI_MFM_Prefix__c in :px_set
                           AND ASI_MFM_Route_Type__r.RecordType.DeveloperName = 'ASI_MFM_CAP_OTH_Route_Type'
                      ORDER BY ASI_MFM_Prefix__c DESC];
        }
        
        set<id> rt_set = new set<id>();     
            
        for (ASI_MFM_Brand_Route_Type_Map__c brm:brm_list) {
            rt_set.add(brm.ASI_MFM_Route_Type__c);
        }     
        
        list<ASI_MFM_Route_Rule_Detail__c> rule_list = [select ASI_MFM_Approver__c, ASI_MFM_Minimum_Amount__c, ASI_MFM_Route_Type__c from ASI_MFM_Route_Rule_Detail__c 
                where ASI_MFM_Route_Type__c in :rt_set order by ASI_MFM_Route_Type__c, ASI_MFM_Minimum_Amount__c];
                
        for (ASI_MFM_Plan__c plan : trigger_new){
            id rtid;
            
            for (ASI_MFM_Brand_Route_Type_Map__c brm:brm_list) {
                if (Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_Plan')
                // DC - 02/09/2016 - Added condition for checking RecordType of "CAP TW"
                ||  Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_TW_Plan')){
                    if (brm.ASI_MFM_Prefix__c == plan.ASI_MFM_Prefix__c) {
                        rtid = brm.ASI_MFM_Route_Type__c;
                        break;
                    }
                }
            }
                
            integer approver_count = 0;
            if (rtid != null) {
                for (ASI_MFM_Route_Rule_Detail__c routeDetail:rule_list) {
                    if(Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_Plan')) {
                        if (routeDetail.ASI_MFM_Route_Type__c == rtid) {
                            if (approver_count == 0) {
                                plan.ASI_MFM_Approver_1__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 1) {                                 
                                plan.ASI_MFM_Approver_2__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 2) {                                 
                                plan.ASI_MFM_Approver_3__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 3) {                                 
                                plan.ASI_MFM_Approver_4__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 4) {                                 
                                plan.ASI_MFM_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 5) {                                 
                                plan.ASI_MFM_Approver_6__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 6) {                                 
                                plan.ASI_MFM_Approver_7__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 7) {                                 
                                plan.ASI_MFM_Approver_8__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 8) {                                 
                                plan.ASI_MFM_Approver_9__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 9) {                                 
                                plan.ASI_MFM_Approver_10__c = routeDetail.ASI_MFM_Approver__c;
                            }                                                                                                    
                            approver_count++;
                        }
                    } else if(Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_TW_Plan')) {
                        // DC - 02/09/2016 - Added conditions for checking minimum amount on route rule details.
                        if (routeDetail.ASI_MFM_Route_Type__c == rtid && routeDetail.ASI_MFM_Minimum_Amount__c <= plan.ASI_MFM_Plan_Amount__c && routeDetail.ASI_MFM_Sequence__c != 999) {
                            if (approver_count == 0) {
                                plan.ASI_MFM_Approver_2__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 1) {                                 
                                plan.ASI_MFM_Approver_3__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 2) {                                 
                                plan.ASI_MFM_Approver_4__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 3) {                                 
                                plan.ASI_MFM_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            // Comment out the following code [START]
                            else if (approver_count == 4) {                                 
                                plan.ASI_MFM_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 5) {                                 
                                plan.ASI_MFM_Approver_6__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 6) {                                 
                                plan.ASI_MFM_Approver_7__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 7) {                                 
                                plan.ASI_MFM_Approver_8__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 8) {                                 
                                plan.ASI_MFM_Approver_9__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 9) {                                 
                                plan.ASI_MFM_Approver_10__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            [END]                                                                                             
                            approver_count++;
                        }
                    }
                }
            }
        }*/
        
// Set the plan ID for new plan 
// set fiscal year  
// Set plan type    
        map<id, asi_mfm_prefix__c> px_map = new map<id, asi_mfm_prefix__c>([select name, asi_mfm_next_number__c, ASI_MFM_Fiscal_year__c, Plan_Type__c, recordtypeid,ASI_MFM_TR_Rec_Type__c from asi_mfm_prefix__c 
            where asi_mfm_module__c = 'Plan' and id in :px_set for update]);
        
        for (ASI_MFM_Plan__c p:trigger_new) {
            if (px_map.containsKey(p.asi_mfm_prefix__c)) {
                p.name = px_map.get(p.asi_mfm_prefix__c).name + string.valueOf(px_map.get(p.asi_mfm_prefix__c).asi_mfm_next_number__c + 10000).substring(1, 5);               
                px_map.get(p.asi_mfm_prefix__c).asi_mfm_next_number__c++;
                
                if (p.ASI_MFM_Fiscal_year__c == null) {
                    p.ASI_MFM_Fiscal_year__c = px_map.get(p.asi_mfm_prefix__c).ASI_MFM_Fiscal_year__c;
                }
                
                p.ASI_MFM_Sys_Plan_Type__c = px_map.get(p.asi_mfm_prefix__c).Plan_Type__c;
            }
        }
        ASI_MFM_Function.updatePrefix(px_map.values());        
    }
    
    public static void routineBeforeUpdate(list<ASI_MFM_Plan__c> trigger_new, map<id, ASI_MFM_Plan__c> trigger_oldMap) {
// Set the owner link
// Set the approvers for the plan based on the routing rule objects         
        set<id> pid_set = new set<id>();
        set<id> px_set = new set<id>();
        
// The related PO must be in Complete status before a plan can be set to Complete status
        pid_set.clear();
        for (ASI_MFM_Plan__c p:trigger_new) {
            px_set.add(p.ASI_MFM_Prefix__c);
            if (p.ASI_MFM_Status__c == 'Complete' && p.ASI_MFM_Status__c != trigger_oldMap.get(p.id).ASI_MFM_Status__c) {
                pid_set.add(p.id);
            }
        }
        if (pid_set.size() > 0) {
            map<id, ASI_MFM_Plan__c> p_map = new map<id, ASI_MFM_Plan__c>([select (select id from POs__r where ASI_MFM_Status__c != 'Complete') from ASI_MFM_Plan__c where id in :pid_set]);
            for (ASI_MFM_Plan__c p:trigger_new) {
                if (p_map.containsKey(p.id) && p_map.get(p.id).POs__r.size() > 0) {
                    system.debug('PO count: ' + p_map.get(p.id).POs__r.size());
                    p.addError('You can NOT complete the Plan before you complete all the underlying POs');
                }
            }
        }
        
// Get rejection comment when rejected
        set<id> rejected_set = new set<id>();
        map<id, ASI_MFM_Plan__c> reject_map = new map<id, ASI_MFM_Plan__c>();
        for (ASI_MFM_Plan__c p:trigger_new) { 
            if (p.ASI_MFM_Status__c == 'Draft' && trigger_oldMap.get(p.id).ASI_MFM_Status__c != 'Draft') {
                reject_map.put(p.id, p);
            }
        }
        if (reject_map.size() > 0) {
            list<ASI_MFM_Plan__c> reject_list = [select (select Comments from ProcessSteps order by createdDate desc limit 1) from ASI_MFM_Plan__c where id in :reject_map.keySet()];
            for (ASI_MFM_Plan__c r:reject_list) {
                if (r.processSteps.size() > 0 && reject_map.containsKey(r.id)) {
                    reject_map.get(r.id).ASI_MFM_Sys_Rejected__c = true;
                    reject_map.get(r.id).ASI_MFM_Sys_Reject_Comments__c = r.processSteps[0].comments;
                }
            }
        }

        /**/
	
		/*[WL 1.0 BEGIN]*/
		populateApprovers(trigger_new, trigger_oldMap, px_set, true);
        //populateApprovers(trigger_new, px_set, true);
		/*[WL 1.0 END]*/
    } 
    
    public static void routineBeforeUpsert(list<ASI_MFM_Plan__c> trigger_new, map<id, ASI_MFM_Plan__c> trigger_oldMap) {
        set<id> owner_set = new set<id>();
        set<id> prefix_set = new set<id>();
        list<ASI_MFM_Plan__c> plan_list = new list<ASI_MFM_Plan__c>();
                
        for (ASI_MFM_Plan__c p:trigger_new) {
            if (trigger_oldMap == null || p.ownerId != trigger_oldMap.get(p.id).ownerId || p.ASI_MFM_Prefix__c != trigger_oldMap.get(p.id).ASI_MFM_Prefix__c) {
                owner_set.add(p.ownerId);
                prefix_set.add(p.ASI_MFM_Prefix__c);
                plan_list.add(p);
            }
            System.debug(p.ASI_MFM_Fiscal_year__c);
            System.debug(p.recordtypeid);
        }
        
        if (plan_list.size() > 0) {
            map<id, user> owner_map = new map<id, user>([select userRole.DeveloperName from user where id in :owner_set]);
            map<id, ASI_MFM_Prefix__c> prefix_map = new map<id, ASI_MFM_Prefix__c>([select Plan_Type__c, (select ASI_MFM_Role_Name__c from ASI_MFM_Role_Prefix_Relationships__r) 
                from ASI_MFM_Prefix__c where id in :prefix_set and ASI_MFM_Module__c = 'Plan']);
            for (ASI_MFM_Plan__c p:plan_list) {
                if (!prefix_map.containsKey(p.ASI_MFM_Prefix__c)) {
                    p.ASI_MFM_Prefix__c.addError('The prefix is not valid for plan');
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
    }

	/*[WL 1.0 BEGIN]*/
    //public static void populateApprovers(list<ASI_MFM_Plan__c> trigger_new, set<id> px_set, Boolean isUpdate) {
	public static void populateApprovers(list<ASI_MFM_Plan__c> trigger_new, Map<Id,ASI_MFM_Plan__c> oldMap, set<id> px_set, Boolean isUpdate) {
	/*[WL 1.0 END]*/
        
        list<ASI_MFM_Brand_Route_Type_Map__c> brm_list = new list<ASI_MFM_Brand_Route_Type_Map__c>();

        if (Global_RecordTypeCache.getRt(trigger_new.get(0).recordTypeID).DeveloperName.contains('ASI_MFM_CAP_Plan')){
            //HK CAPEX OPEX Logic
			/*[WL 1.0 BEGIN]*/
			Boolean isAmountChanged = false;
			for (ASI_MFM_Plan__c plan:trigger_new){
				if (oldMap == null || (oldMap != null && plan.ASI_MFM_Plan_Amount__c != oldMap.get(plan.Id).ASI_MFM_Plan_Amount__c))
					isAmountChanged = true;
			}
			
			if (isAmountChanged)
				brm_list = [select ASI_MFM_Prefix__c, ASI_MFM_Route_Type__c from ASI_MFM_Brand_Route_Type_Map__c where ASI_MFM_Active__c = true and ASI_MFM_Prefix__c in :px_set order by ASI_MFM_Prefix__c desc];
			/*[WL 1.0 END]*/
        } 
        // DC - 02/09/2016 - Added logic for populating approvers if record type is "CAP TW".
        else if(Global_RecordTypeCache.getRt(trigger_new.get(0).recordTypeID).DeveloperName.contains('ASI_MFM_CAP_TW_Plan')) {
            brm_list = [SELECT ASI_MFM_Prefix__c,
                               ASI_MFM_Route_Type__c
                          FROM ASI_MFM_Brand_Route_Type_Map__c 
                         WHERE ASI_MFM_Active__c = true
                           AND ASI_MFM_Prefix__c in :px_set
                           AND ASI_MFM_Route_Type__r.RecordType.DeveloperName = 'ASI_MFM_CAP_OTH_Route_Type'
                      ORDER BY ASI_MFM_Prefix__c DESC];
        }
        
        set<id> rt_set = new set<id>();     
            
        for (ASI_MFM_Brand_Route_Type_Map__c brm:brm_list) {
            rt_set.add(brm.ASI_MFM_Route_Type__c);
        }     
        
		/*[WL 1.0 BEGIN]*/
		list<ASI_MFM_Route_Rule_Detail__c> rule_list = new list<ASI_MFM_Route_Rule_Detail__c>();
		if (rt_set.size() > 0)
			rule_list = [select ASI_MFM_Approver__c, ASI_MFM_Sequence__c, ASI_MFM_Minimum_Amount__c, ASI_MFM_Route_Type__c from ASI_MFM_Route_Rule_Detail__c 
                where ASI_MFM_Route_Type__c in :rt_set order by ASI_MFM_Route_Type__c, ASI_MFM_Minimum_Amount__c];
        /*[WL 1.0 END]*/
		
        for (ASI_MFM_Plan__c plan : trigger_new){
            id rtid;
            
            for (ASI_MFM_Brand_Route_Type_Map__c brm:brm_list) {
                if (Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_Plan')
                // DC - 02/09/2016 - Added condition for checking RecordType of "CAP TW"
                ||  Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_TW_Plan')){
                    if (brm.ASI_MFM_Prefix__c == plan.ASI_MFM_Prefix__c) {
                        rtid = brm.ASI_MFM_Route_Type__c;
                        break;
                    }
                }
            }
                
            integer approver_count = 0;
            if (rtid != null) {
                for (ASI_MFM_Route_Rule_Detail__c routeDetail:rule_list) {
                    if(Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_Plan')
                    && isUpdate == false) {
                        if (routeDetail.ASI_MFM_Route_Type__c == rtid) {
                            if (approver_count == 0) {
                                plan.ASI_MFM_Approver_1__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 1) {                                 
                                plan.ASI_MFM_Approver_2__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 2) {                                 
                                plan.ASI_MFM_Approver_3__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 3) {                                 
                                plan.ASI_MFM_Approver_4__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 4) {                                 
                                plan.ASI_MFM_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 5) {                                 
                                plan.ASI_MFM_Approver_6__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 6) {                                 
                                plan.ASI_MFM_Approver_7__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 7) {                                 
                                plan.ASI_MFM_Approver_8__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 8) {                                 
                                plan.ASI_MFM_Approver_9__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 9) {                                 
                                plan.ASI_MFM_Approver_10__c = routeDetail.ASI_MFM_Approver__c;
                            }                                                                                                    
                            approver_count++;
                        }
                    } else if(Global_RecordTypeCache.getRt(plan.recordTypeID).DeveloperName.contains('ASI_MFM_CAP_TW_Plan')
                           && isUpdate == true) {
                        // DC - 02/09/2016 - Added conditions for checking minimum amount on route rule details.
                        if (routeDetail.ASI_MFM_Route_Type__c == rtid && routeDetail.ASI_MFM_Minimum_Amount__c <= plan.ASI_MFM_Plan_Amount__c && routeDetail.ASI_MFM_Sequence__c != 999) {
                            if (approver_count == 0) {
                                plan.ASI_MFM_Approver_2__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 1) {                                 
                                plan.ASI_MFM_Approver_3__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 2) {                                 
                                plan.ASI_MFM_Approver_4__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 3) {                                 
                                plan.ASI_MFM_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            /*else if (approver_count == 4) {                                 
                                plan.ASI_MFM_Approver_5__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 5) {                                 
                                plan.ASI_MFM_Approver_6__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 6) {                                 
                                plan.ASI_MFM_Approver_7__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 7) {                                 
                                plan.ASI_MFM_Approver_8__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 8) {                                 
                                plan.ASI_MFM_Approver_9__c = routeDetail.ASI_MFM_Approver__c;
                            }
                            else if (approver_count == 9) {                                 
                                plan.ASI_MFM_Approver_10__c = routeDetail.ASI_MFM_Approver__c;
                            }*/                                                                                                   
                            approver_count++;
                        }
                    }
                }
            }
        }
    }
}