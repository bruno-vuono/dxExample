public with sharing class ASI_CRM_KR_COGS_TriggerClass {
	public static void routineBeforeInsert(list<ASI_CRM_KR_COGS__c> trigger_new) {
        for(ASI_CRM_KR_COGS__c cogs:trigger_new){
            cogs.ASI_CRM_KR_ExternalID__c=null;
            
        }
    }
}