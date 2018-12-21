trigger AME_project_cloud_ProjectPostConfiguration on project_cloud__Project__c (after insert, after update) {
    //Retrieve Demand recordTypes
    Map<Id, RecordType> demandRTypes = new Map<Id, RecordType>([
        SELECT
            Id,
            Name
        FROM
            RecordType
        WHERE
            SObjectType = 'project_cloud__Ticket__c'
        AND 
            (Name = 'Demand' OR Name = 'Demand (Release)')]);
    //We are only concerned with projects whose status changed
    Set<Id> projectStatusChanged = new Set<Id>();
    for(project_cloud__Project__c project : Trigger.new) {
        if((Trigger.isUpdate && project.AME_project_cloud_Status__c != Trigger.oldMap.get(project.Id).AME_project_cloud_Status__c) || Trigger.isInsert) {
            projectStatusChanged.add(project.Id);
        }
    }
    //Update related Incidents
    if(projectStatusChanged.size() > 0) {
        //Query relavent fields and related tickets from projects
        Map<Id, String> projectNameByIncident = new Map<Id, String>();
        List<project_cloud__Project__c> projects = [
            SELECT
                Id,
                Name,
                project_cloud__Ticket__c,
                project_cloud__Ticket__r.AME_project_cloud_Incident__c,
                project_cloud__Ticket__r.RecordTypeId,
                AME_project_cloud_Status__c,
                (SELECT
                     Id,
                     project_cloud__Status__c,
                     AME_project_cloud_Incident__c
                 FROM
                     project_cloud__Tickets__r
                 WHERE
                     RecordTypeId IN :demandRTypes.keySet())
            FROM
                project_cloud__Project__c
            WHERE
                Id IN :projectStatusChanged];
        List<project_cloud__Ticket__c> ticketsToUpdate = new List<project_cloud__Ticket__c>();
        for(project_cloud__Project__c project : projects) {
            if(project.AME_project_cloud_Status__c == 'Completed'
            && project.project_cloud__Ticket__c != null
            && demandRTypes.keySet().contains(project.project_cloud__Ticket__r.RecordTypeId)
            && project.project_cloud__Ticket__r.AME_project_cloud_Incident__c != null) {
                projectNameByIncident.put(project.project_cloud__Ticket__r.AME_project_cloud_Incident__c, project.Name);
            }
            //Update status of all related tickets
            for(project_cloud__Ticket__c ticket : project.project_cloud__Tickets__r) {
                //Map status from project to ticket
                String status = project.AME_project_cloud_Status__c;
                if(status == 'Canceled') {
                    ticket.project_cloud__Status__c = 'Canceled';
                } else if(status == 'On Hold') {
                    ticket.project_cloud__Status__c = 'On Hold';
                } else if(status == 'In Progress' || status == 'In Progress - Late') {
                    ticket.project_cloud__Status__c = 'In Progress';
                } else if(status == 'Not Started' || status == 'Not Started - Late') {
                    ticket.project_cloud__Status__c = 'Open';
                } else if(status == 'Completed') {
                    ticket.project_cloud__Status__c = 'Closed';
                }
                ticketsToUpdate.add(ticket);
            }
        }
        update ticketsToUpdate;
        
        //Query related incidents
        List<String> ignoreStatuses = new List<String>{'RESOLVED', 'CANCELLED', 'CLOSED', 'DUPLICATED'};
        Id resolvedStatusId = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name = 'RESOLVED' LIMIT 1].Id;
        List<BMCServiceDesk__Incident__c> relatedIncidents = [
            SELECT
                Id,
                BMCServiceDesk__FKStatus__c,
                BMCServiceDesk__incidentResolution__c,
                BMCServiceDesk__ClosureCategory__c
                
            FROM
                BMCServiceDesk__Incident__c
            WHERE
                Id IN :projectNameByIncident.keySet()
            AND
                BMCServiceDesk__Status_ID__c NOT IN :ignoreStatuses];
        //Update incident fields to reflect the project closing
        for(BMCServiceDesk__Incident__c incident : relatedIncidents) {
            incident.BMCServiceDesk__FKStatus__c = resolvedStatusId;
            incident.BMCServiceDesk__incidentResolution__c = 'Completed as part of ' + projectNameByIncident.get(incident.Id);
            incident.BMCServiceDesk__ClosureCategory__c = 'Request Fullfilled';
        }
        update relatedIncidents;
    }
}