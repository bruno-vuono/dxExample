/* Filename:    ASI_MFM_CN_Plan_TriggerClass .cls
 * Author:      Michael Yip (Introv Limited)
 * Purpose:     Plan Trigger Class for CN Plan, Some of the CN logic are still in general trigger class
 *
 *
 * History
 * -----------------------------------------------------------------------------
 * 2014-09-15   michael.yip@introv.com      Created
 * 
 */

public without sharing class ASI_MFM_CN_Plan_TriggerClass {
    public static void routineBeforeInsert(list<ASI_MFM_Plan__c> trigger_new) {
        for(ASI_MFM_Plan__c p : trigger_new){
            // Added by Michael Yip (Introv) 15Sep2014 to change owner to make it equal to budget owner
            if(p.ASI_MFM_Budget_Owner__c != null && p.ASI_MFM_Budget_Owner__c != p.ownerid)
                p.ownerid = p.ASI_MFM_Budget_Owner__c; 
        }


    }


}