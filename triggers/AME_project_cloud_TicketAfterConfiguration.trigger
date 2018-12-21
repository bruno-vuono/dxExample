trigger AME_project_cloud_TicketAfterConfiguration on project_cloud__Ticket__c (after insert, after update) {
    Set<Id> projectIdsToSum = new Set<Id>();
    
    //Used to update incidents on ticket close
    Map<Id, Id> ticketByIncident = new Map<Id, Id>();
    Map<Id, RecordType> demandRTypes = new Map<Id, RecordType>([
        SELECT
            Id,
            Name
        FROM
            RecordType
        WHERE
            SObjectType = 'project_cloud__Ticket__c'
        AND 
            (Name = 'Demand (Configuration)'
            OR Name = 'Demand (Emergency)'
            OR Name = 'Demand (Minor Enhancement)'
            OR Name = 'Demand (Release)'
            OR Name = 'Demand')]);
            
            
    project_cloud__Ticket__c oldValue;
    for(project_cloud__Ticket__c ticket : Trigger.new) {
        //only tickets related to a project need to be considered
        if(ticket.project_cloud__Project_CCPE_Ignore__c != null) {
            if(Trigger.isUpdate) {
                oldValue = Trigger.oldMap.get(ticket.Id);
                if(ticket.AME_project_cloud_Effort_in_man_days__c != oldValue.AME_project_cloud_Effort_in_man_days__c) {
                    oldValue = null;
                }
            }
            //oldValue is null if the Effort value has changed
            //or this is an insert trigger
            if(oldValue == null && ticket.project_cloud__Project_CCPE_Ignore__c != null) {
                projectIdsToSum.add(ticket.project_cloud__Project_CCPE_Ignore__c);
            }
        }
        //Only tickets with record types Demand(Configuration/Emergency/Minor Enhancement) need to be considered
        if(demandRTypes.keySet().contains(ticket.RecordTypeId) && ticket.project_cloud__Status__c == 'Closed' && ticket.AME_project_cloud_Incident__c != null) {
            ticketByIncident.put(ticket.AME_project_cloud_Incident__c, ticket.Id);
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
    if(ticketByIncident.size() > 0) {
        List<String> ignoreStatuses = new List<String>{'RESOLVED', 'CANCELLED', 'CLOSED', 'DUPLICATED'};
        List<BMCServiceDesk__Incident__c> relatedIncidents = [
            SELECT
                Id,
                BMCServiceDesk__FKStatus__c,
                BMCServiceDesk__incidentResolution__c,
                BMCServiceDesk__ClosureCategory__c
                
            FROM
                BMCServiceDesk__Incident__c
            WHERE
                Id IN :ticketByIncident.keySet()
            AND
                BMCServiceDesk__Status_ID__c NOT IN :ignoreStatuses];
        BMCServiceDesk__Status__c resolvedStatus = [SELECT Id, Name, BMCServiceDesk__inactive__c, BMCServiceDesk__appliesToIncident__c FROM BMCServiceDesk__Status__c WHERE Name = 'RESOLVED' and BMCServiceDesk__inactive__c = false];
        for(BMCServiceDesk__Incident__c incident : relatedIncidents) {
            incident.BMCServiceDesk__FKStatus__c = resolvedStatus.Id;
            incident.BMCServiceDesk__incidentResolution__c = 'Completed as ' + Trigger.newMap.get(ticketByIncident.get(incident.Id)).AME_project_cloud_Portfolio_Type__c;
            incident.BMCServiceDesk__ClosureCategory__c = 'Request Fullfilled';
        }
        update relatedIncidents;
    }
}