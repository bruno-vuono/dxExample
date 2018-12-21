trigger AME_project_cloud_SuccessCriteriaBeforeConfiguration on AME_project_cloud_Success_Criteria__c (before insert, before update) {
    List<AME_project_cloud_Success_Criteria__c> criteriasToPopulate = new List<AME_project_cloud_Success_Criteria__c>();
    Map<Id, AME_project_cloud_Project_Charter__c> charters = new Map<Id, AME_project_cloud_Project_Charter__c>();
    AME_project_cloud_Success_Criteria__c oldValue = null;
    for(AME_project_cloud_Success_Criteria__c criteria : Trigger.new) {
        if(Trigger.isUpdate) {
            oldValue = Trigger.oldMap.get(criteria.Id);
            if(criteria.AME_project_cloud_Project_Charter__c != oldValue.AME_project_cloud_Project_Charter__c) {
                oldValue = null;
                //always clear the project, because if the relationship
                //to the charter was removed, this value will stay null
                criteria.AME_project_cloud_Project__c = null;
            }
        }
        //oldValue is null if the charter lookup has changed
        //or this is an insert trigger
        if(oldValue == null && criteria.AME_project_cloud_Project_Charter__c != null) {
            criteriasToPopulate.add(criteria);
            charters.put(criteria.AME_project_cloud_Project_Charter__c, null);
        }
    }
    if(criteriasToPopulate.size() > 0) {
        charters = new Map<Id, AME_project_cloud_Project_Charter__c>([
            SELECT
                Id,
                Name,
                AME_project_cloud_Project__c
            FROM
                AME_project_cloud_Project_Charter__c
            WHERE
                Id IN :charters.keySet()]);
        for(AME_project_cloud_Success_Criteria__c criteria : criteriasToPopulate) {
            criteria.AME_project_cloud_Project__c = charters.get(criteria.AME_project_cloud_Project_Charter__c).AME_project_cloud_Project__c;
        }
    }
}