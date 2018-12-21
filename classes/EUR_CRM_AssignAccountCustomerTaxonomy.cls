public with sharing class EUR_CRM_AssignAccountCustomerTaxonomy extends EUR_CRM_TriggerAbstract{

    // BG Account record types which are valid
    static String BG_WHOLESALER = 'EUR_BG_Wholesaler';
    static String BG_TRADITIONAL_OFF_TRADE = 'EUR_BG_Traditional_Off_Trade';
    // Valid recordtypes list
    private static Set<String> validRTs = new Set<String>{'EUR_BG_Wholesaler', 'EUR_BG_Traditional_Off_Trade'};

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(validRTs);

            return TRt;
        }private set;
    }

    public EUR_CRM_AssignAccountCustomerTaxonomy(){
        super('EUR_CRM_AssignAccountCustomerTaxonomy');
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){ 
        // cast the trigger records to acocunts (EU)
        System.Debug('EUR_CRM_AssignAccountCustomerTaxonomy');
        List<EUR_CRM_Account__c> accountsListFromTrigger = (List<EUR_CRM_Account__c>)sObjList;

        // Account record types
        List<RecordType> accountRTList = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        Map<Id,Recordtype> accountRTMap = new Map<Id,Recordtype>();
        for(Recordtype rt : accountRTList){
            accountRTMap.put(rt.Id, rt);
        }

        // Check which accounts are valid for this change
        List<EUR_CRM_Account__c> accountsToProcessList = new List<EUR_CRM_Account__c>();
        for(EUR_CRM_Account__c acc : accountsListFromTrigger){
            if(validRTs.contains(accountRTMap.get(acc.RecordTypeId).DeveloperName)){
                accountsToProcessList.add(acc);
            }
        }

        // checkpoint
        if(accountsToProcessList.size() > 0) {
            // BG Ids of the customer taxonomies to be assigned
            EUR_CRM_Customer_Taxonomy__c BG_WHOLESALERS_CUSTOMER_TAXONOMY = [SELECT Id FROM EUR_CRM_Customer_Taxonomy__c WHERE RecordType.DeveloperName = 'EUR_BG_Wholesalers_Customer_Taxonomy'];
            EUR_CRM_Customer_Taxonomy__c BG_TRADITIONAL_OFF_TRADE_CUSTOMER_TAXONOMY = [SELECT Id FROM EUR_CRM_Customer_Taxonomy__c WHERE RecordType.DeveloperName = 'EUR_BG_Traditional_Off_Trade_Customer_Taxonomy'];

            // process accounts
            for(EUR_CRM_Account__c acc : accountsToProcessList){
                String accRT = accountRTMap.get(acc.RecordTypeId).DeveloperName;
                if(accRT == BG_WHOLESALER){
                    acc.EUR_JB_Customer_Taxonomy__c = BG_WHOLESALERS_CUSTOMER_TAXONOMY.Id;
                }
                else if(accRT == BG_TRADITIONAL_OFF_TRADE){
                    acc.EUR_JB_Customer_Taxonomy__c = BG_TRADITIONAL_OFF_TRADE_CUSTOMER_TAXONOMY.Id;
                }
            }
        }
    }
}