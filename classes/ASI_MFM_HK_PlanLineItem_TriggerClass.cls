public without sharing class ASI_MFM_HK_PlanLineItem_TriggerClass {
//Obsolete, HK MFM will used ASI_MFM_PlanLineItem_TriggerClass
/*

    public static void routineBeforeUpsert(list<ASI_MFM_Plan_Line_Item__c> trigger_new, map<id, ASI_MFM_Plan_Line_Item__c> trigger_oldMap) {
// Set default BU code if not input by user
        recordType rt = [select developerName from recordType where id = :trigger_new[0].recordTypeId];
        string country_pfx = 'ASI_MFM_' + rt.developerName.substring(8,10) + '%';
        list<ASI_MFM_BU__c> bu_list = [select id from ASI_MFM_BU__c where recordType.developerName like :country_pfx];
        if (bu_list.size() == 1) {
            for (ASI_MFM_Plan_Line_Item__c pi:trigger_new) {
                if (pi.ASI_MFM_BU_Code__c == null) {
                    pi.ASI_MFM_BU_Code__c = bu_list[0].id;
                }
            } 
        }           

        for (ASI_MFM_Plan_Line_Item__c pi:trigger_new) {
// Calculate total cost from quantity and unit cost         
            if (pi.ASI_MFM_Total_Cost__c == null && pi.ASI_MFM_Quantity__c != null && pi.ASI_MFM_Unit_Cost__c != null) {
                pi.ASI_MFM_Total_Cost__c = pi.ASI_MFM_Quantity__c * pi.ASI_MFM_Unit_Cost__c;
            }           
            System.debug('Plan Line Item Total Cost: ' + pi.ASI_MFM_Total_Cost__c);
// Set values to monthly cost fields if they are not input by user          
            if (pi.ASI_MFM_Total_Cost__c != null && pi.ASI_MFM_Plan_End_Date__c > pi.ASI_MFM_Plan_Start_Date__c &&
                pi.ASI_MFM_Month_1_Cost__c == null && pi.ASI_MFM_Month_2_Cost__c == null && 
                pi.ASI_MFM_Month_3_Cost__c == null && pi.ASI_MFM_Month_4_Cost__c == null && 
                pi.ASI_MFM_Month_5_Cost__c == null && pi.ASI_MFM_Month_6_Cost__c == null && 
                pi.ASI_MFM_Month_7_Cost__c == null && pi.ASI_MFM_Month_8_Cost__c == null &&     
                pi.ASI_MFM_Month_9_Cost__c == null && pi.ASI_MFM_Month_10_Cost__c == null && 
                pi.ASI_MFM_Month_11_Cost__c == null && pi.ASI_MFM_Month_12_Cost__c == null) {

                integer number_of_months = pi.ASI_MFM_Plan_Start_Date__c.monthsBetween(pi.ASI_MFM_Plan_End_Date__c) + 1;    
                decimal monthly_cost = (pi.ASI_MFM_Total_Cost__c / number_of_months).setScale(2);                       
                decimal rounding_err = monthly_cost * number_of_months - pi.ASI_MFM_Total_Cost__c;
                map<integer, decimal> mc_map = new map<integer, decimal>();
                for (integer i = 1; i < 13; i++) {
                    mc_map.put(i, null);
                }
                integer start_month = pi.ASI_MFM_Plan_Start_Date__c.month();
                integer end_month = start_month + number_of_months - 1;
                
                if (start_month < 7) {
                    start_month += 12;
                    end_month += 12;
                }
                decimal monthly_cost_x, cum_cost;
                integer idx;                
                for (integer i = start_month; i <= end_month; i++) {
                    monthly_cost_x = monthly_cost;
                    if (i == end_month) monthly_cost_x -= rounding_err;
                    idx = i - 6;
                    if (idx < 13) {

                        mc_map.put(idx, monthly_cost_x);
                    }
                    else {
                        cum_cost = mc_map.get(12) + monthly_cost_x;
                        mc_map.put(12, cum_cost);                       

                    }
                }
                
                pi.ASI_MFM_Month_1_Cost__c = mc_map.get(1); 
                pi.ASI_MFM_Month_2_Cost__c = mc_map.get(2); 
                pi.ASI_MFM_Month_3_Cost__c = mc_map.get(3); 
                pi.ASI_MFM_Month_4_Cost__c = mc_map.get(4); 
                pi.ASI_MFM_Month_5_Cost__c = mc_map.get(5); 
                pi.ASI_MFM_Month_6_Cost__c = mc_map.get(6);                 
                pi.ASI_MFM_Month_7_Cost__c = mc_map.get(7); 
                pi.ASI_MFM_Month_8_Cost__c = mc_map.get(8); 
                pi.ASI_MFM_Month_9_Cost__c = mc_map.get(9); 
                pi.ASI_MFM_Month_10_Cost__c = mc_map.get(10);   
                pi.ASI_MFM_Month_11_Cost__c = mc_map.get(11);   
                pi.ASI_MFM_Month_12_Cost__c = mc_map.get(12);   
            }
//Added by Wilken on 20130904 Auto fill A/C Code if user input AP Code only
            if (pi.ASI_MFM_AP_Code__c != null && pi.ASI_MFM_A_C_Code__c == null){
                System.debug('A/C Code: ' + pi.ASI_MFM_AP_Code__r.ASI_MFM_A_C_Code__c);
                ASI_MFM_AP_Code__c apCode = [select ASI_MFM_A_C_Code__c from ASI_MFM_AP_Code__c where id = :pi.ASI_MFM_AP_Code__c];
                if (apCode.ASI_MFM_A_C_Code__c != null){
                    pi.ASI_MFM_A_C_Code__c = apCode.ASI_MFM_A_C_Code__c;
                }
            }
        }
    }
    */
}