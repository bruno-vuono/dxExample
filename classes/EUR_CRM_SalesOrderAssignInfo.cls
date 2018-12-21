/**
*   TriggerClass: EUR_CRM_SalesOrderAssignInfo
*
*   Assigns KD Owner's Name and Email to newly created Sales Order
*   Also assigns Sales manager (EUR_CRM_Manager__c) and Key Account Manager (EUR_CRM_Key_Account_Manager__c) on top of that
*   TriggerActions: BeforeInsert
*   
*/
public with sharing class EUR_CRM_SalesOrderAssignInfo extends EUR_CRM_TriggerAbstract{

    public EUR_CRM_SalesOrderAssignInfo() {
        super('EUR_CRM_SalesOrderAssignInfo');
    }
    
    private Set<String> validRecordTypes = new Set<String>{
        'EUR_NG_On_Trade_Reminder',
        'EUR_RU_On_Trade_Sales_Order'
    };
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        List<RecordType> salesOrderRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Sales_Order__c');
        Map<Id, RecordType> salesOrderRecordTypesMap = new Map<Id, RecordType>();
        
        for(RecordType rt: salesOrderRecordTypes) {
            salesOrderRecordTypesMap.put(rt.Id, rt);
        }
        
        List<EUR_CRM_Sales_Order__c> salesOrderList = (List<EUR_CRM_Sales_Order__c>) sObjList;
        List<EUR_CRM_Sales_Order__c> validSalesOrderList = new List<EUR_CRM_Sales_Order__c>();
        
        set<Id> accountIdSet = new Set<Id>();
        
        for(EUR_CRM_Sales_Order__c so: salesOrderList) {
            String salesOrderRTDevName = salesOrderRecordTypesMap.get(so.recordTypeId).developername;
            if(validRecordTypes.contains(salesOrderRTDevName)) {
                // For insert action
                validSalesOrderList.add(so);
                accountIDSet.add(so.EUR_CRM_Account__c);
            }
        }
        
        if(validSalesOrderList.size() > 0) {
            Map<Id, EUR_CRM_Account__c> accMap = new Map<Id, EUR_CRM_Account__c>([
                SELECT Id, EUR_CRM_Territory__r.EUR_CRM_KD_Owner__c, EUR_CRM_Territory__r.EUR_CRM_KD_Owner__r.Email, EUR_CRM_Territory__r.EUR_CRM_KD_Owner__r.Name
                FROM EUR_CRM_Account__c
                WHERE Id IN :accountIdSet
            ]);

            for(EUR_CRM_Sales_Order__c so: salesOrderList) {
                so.EUR_CRM_Key_Distributor_Sales_Rep__c = accMap.get(so.EUR_CRM_Account__c).EUR_CRM_Territory__r.EUR_CRM_KD_Owner__c;
                so.EUR_CRM_Key_Distributor_Sales_Rep_Email__c = accMap.get(so.EUR_CRM_Account__c).EUR_CRM_Territory__r.EUR_CRM_KD_Owner__r.Email;          
            }
        }
    }

}