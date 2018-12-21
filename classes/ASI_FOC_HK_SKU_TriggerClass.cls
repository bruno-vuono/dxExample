public class ASI_FOC_HK_SKU_TriggerClass {

    public static void routineBeforeUpsert(list<ASI_MFM_SKU_Code__c> trigger_new, map<id, ASI_MFM_SKU_Code__c> trigger_oldMap) {
// Check for Is Premium Item
        RecordType hkExpRT = [select id from RecordType where DeveloperName = 'HK_FOC_Expensive_Items' and SobjectType = 'ASI_FOC_Expensive_Items__c' limit 1];
        List<ASI_FOC_Expensive_Items__c> expList = [select ASI_FOC_SRP0__c from ASI_FOC_Expensive_Items__c where RecordTypeId = :hkExpRT.Id];
        set<String> exp_set = new set<String>();
        
        for (ASI_FOC_Expensive_Items__c exp :expList){
            exp_set.add(exp.ASI_FOC_SRP0__c);
        }
        
        if (trigger_new != null) {
            for (ASI_MFM_SKU_Code__c sku:trigger_new) {
                if (exp_set.contains(sku.ASI_FOC_SRP0__c)){
                    sku.ASI_FOC_Is_Premium__c = true;
                }
            }
        }
    }
}