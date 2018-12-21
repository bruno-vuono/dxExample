trigger EUR_CRM_AT_ObjectiveTrigger on EUR_CRM_GB_Objective__c (before insert, before update) {
    Map<Id,RecordType> rtMap = new Map<Id,RecordType>([select id, developername from RecordType
    where SObjectType = 'EUR_CRM_GB_Objective__c']);
    
    Set<String> validRT = new Set<String>{'EUR_AT_Central_Objective'};
    
    for(EUR_CRM_GB_Objective__c obj: Trigger.new){
        if(rtMap.get(obj.recordTypeid) != null &&
            validRT.contains(rtMap.get(obj.recordTypeid).developername) ){
            obj.EUR_CRM_Achieved__c = obj.EUR_CRM_Target_Number_of_Actions__c <= obj.EUR_CRM_Achieved_Number_of_Actions__c;
        }
    }
}