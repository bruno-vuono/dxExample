trigger AME_project_cloud_ProjectBudgetBeforeConfiguration on AME_project_cloud_Project_Budget__c (before insert, before update) {
    List<AME_project_cloud_Project_Budget__c> budgetsToPopulate = new List<AME_project_cloud_Project_Budget__c>();
    Map<Id, AME_project_cloud_Project_Charter__c> charters = new Map<Id, AME_project_cloud_Project_Charter__c>();
    AME_project_cloud_Project_Budget__c oldValue = null;
    for(AME_project_cloud_Project_Budget__c budget : Trigger.new) {
        if(Trigger.isUpdate) {
            oldValue = Trigger.oldMap.get(budget.Id);
            if(budget.AME_project_cloud_Project_Charter__c != oldValue.AME_project_cloud_Project_Charter__c) {
                oldValue = null;
                //always clear the project, because if the relationship
                //to the charter was removed, this value will stay null
                budget.AME_project_cloud_Project__c = null;
            }
        }
        //oldValue is null if the charter lookup has changed
        //or this is an insert trigger
        if(oldValue == null && budget.AME_project_cloud_Project_Charter__c != null) {
            budgetsToPopulate.add(budget);
            charters.put(budget.AME_project_cloud_Project_Charter__c, null);
        }
    }
    if(budgetsToPopulate.size() > 0) {
        charters = new Map<Id, AME_project_cloud_Project_Charter__c>([
            SELECT
                Id,
                Name,
                AME_project_cloud_Project__c
            FROM
                AME_project_cloud_Project_Charter__c
            WHERE
                Id IN :charters.keySet()]);
        for(AME_project_cloud_Project_Budget__c budget : budgetsToPopulate) {
            budget.AME_project_cloud_Project__c = charters.get(budget.AME_project_cloud_Project_Charter__c).AME_project_cloud_Project__c;
        }
    }
}