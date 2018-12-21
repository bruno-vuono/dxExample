public without sharing class ASI_MFM_SC_POLineItem_TriggerClass {

    public static void routineBeforeDelete(list<ASI_MFM_PO_Line_Item__c> trigger_old) {
        set<id> pid_set = new set<id>();
        for (ASI_MFM_PO_Line_Item__c pi:trigger_old) {
            pid_set.add(pi.ASI_MFM_PO__c);
        }
        map<id, ASI_MFM_PO__c> PO_map = new map<id, ASI_MFM_PO__c>([select id from ASI_MFM_PO__c where id in :pid_set and (ASI_MFM_Status__c = 'Final' or ASI_MFM_Status__c = 'Complete')]);        
        for (ASI_MFM_PO_Line_Item__c pi:trigger_old) {                       
            if (PO_map.containsKey(pi.ASI_MFM_PO__c)) {
                if (pi.ASI_MFM_Already_Paid_or_Receipt__c)
                    pi.addError('Not allowed to delete because the PO already has PO Receipt or Payment');
            }
        }
    }  
    
}