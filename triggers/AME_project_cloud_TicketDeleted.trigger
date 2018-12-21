trigger AME_project_cloud_TicketDeleted on project_cloud__Ticket__c (after delete) {
    Set<Id> projectIdsToSum = new Set<Id>();
    for(project_cloud__Ticket__c ticket : Trigger.old) {
        if(ticket.project_cloud__Project_CCPE_Ignore__c != null) {
            projectIdsToSum.add(ticket.project_cloud__Project_CCPE_Ignore__c);
        }
    }
    if(projectIdsToSum.size() > 0) {
        List<AggregateResult> projectSums = [
            SELECT
                project_cloud__Project_CCPE_Ignore__c projectId,
                SUM(AME_project_cloud_Effort_in_man_days__c) totalEffort
            FROM
                project_cloud__Ticket__c
            WHERE
                project_cloud__Project_CCPE_Ignore__c IN :projectIdsToSum
            GROUP BY
                project_cloud__Project_CCPE_Ignore__c];
        if(projectSums.size() > 0) {
            List<project_cloud__Project__c> projectsForUpdate = new List<project_cloud__Project__c>();
            for(AggregateResult projectSum : projectSums) {
                projectsForUpdate.add(new project_cloud__Project__c(
                    Id = (Id)projectSum.get('projectId'),
                    AME_project_cloud_Effort_in_man_days__c = (Decimal)projectSum.get('totalEffort')
                ));
            }
            if(projectsForUpdate.size() > 0) {
                update projectsForUpdate;
            }
        }
    }
}