public without sharing class ASI_CRM_CN_Payee_TriggerClass {
public ASI_CRM_CN_Payee_TriggerClass (){}
    
    public static void routineBeforeUpsert(list<ASI_CRM_CN_PH_Payee_Line_Item__c> trigger_new, map<id, ASI_CRM_CN_PH_Payee_Line_Item__c> trigger_oldMap) {
		Set<ID> AccountID = new Set<ID>();
		for(ASI_CRM_CN_PH_Payee_Line_Item__c p: trigger_new) {
            if(p.ASI_CRM_CN_Payee_T2__c != null)
            {
                if(!AccountID.contains(p.ASI_CRM_CN_Payee_T2__c))
                    AccountID.add(p.ASI_CRM_CN_Payee_T2__c);
            }
			if(p.ASI_CRM_CN_Payee_T1__c != null)
            {
                if(!AccountID.contains(p.ASI_CRM_CN_Payee_T1__c))
                    AccountID.add(p.ASI_CRM_CN_Payee_T1__c);
            }
        }
        Map<id, id> AccountMap = new Map<id, id>();
        for(ASI_CRM_AccountsAdditionalField__c c : [SELECT id, ASI_CRM_Account__c FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_Account__c in: AccountID])
        {
            if(!AccountMap.containsKey(c.ASI_CRM_Account__c))
                AccountMap.put(c.ASI_CRM_Account__c, c.id);
        }
    
		for(ASI_CRM_CN_PH_Payee_Line_Item__c p: trigger_new) {
            if(p.ASI_CRM_CN_Payee_T2__c != null && AccountMap.containsKey(p.ASI_CRM_CN_Payee_T2__c))
            {
				p.ASI_CRM_CN_Payee_Name_T2_lookup__c = AccountMap.get(p.ASI_CRM_CN_Payee_T2__c);
            }
			if(p.ASI_CRM_CN_Payee_T1__c != null && AccountMap.containsKey(p.ASI_CRM_CN_Payee_T1__c))
            {
				p.ASI_CRM_CN_Payee_Name_T1__c = AccountMap.get(p.ASI_CRM_CN_Payee_T1__c);
            }
        }
    }    
}