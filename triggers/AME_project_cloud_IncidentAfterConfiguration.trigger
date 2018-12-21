trigger AME_project_cloud_IncidentAfterConfiguration on BMCServiceDesk__Incident__c (after insert, after update) {
    Set<Id> incidentIds = null;
    if(Trigger.isInsert) {
        incidentIds = Trigger.newMap.keySet();
    } else if(Trigger.isUpdate) {
        incidentIds = new Set<Id>();
        BMCServiceDesk__Incident__c oldValue;
        for(BMCServiceDesk__Incident__c incident : Trigger.new) {
            oldValue = Trigger.oldMap.get(incident.Id);
            if(incident.BMCServiceDesk__FKTemplate__c != oldValue.BMCServiceDesk__FKTemplate__c ||
                    incident.BMCServiceDesk__FKRequestDefinition__c != oldValue.BMCServiceDesk__FKRequestDefinition__c ||
                    incident.BMCServiceDesk__FKCategory__c != oldValue.BMCServiceDesk__FKCategory__c
                    /*If the Ticket should be updated when the incident fields are change, these criteria should be added to the clause:
                    incident.Summary__c != oldValue.Summary__c ||
                    incident.BMCServiceDesk__incidentDescription__c != oldValue.BMCServiceDesk__incidentDescription__c ||
                    incident.AME_Benefits__c != oldValue.AME_Benefits__c ||
                    incident.AME_Impact__c != oldValue.AME_Impact__c ||
                    incident.AME_Current_Situation__c != oldValue.AME_Current_Situation__c
                    */) {
                incidentIds.add(incident.Id);
            }
        }
    }
    if(incidentIds != null && incidentIds.size() > 0) {
        List<BMCServiceDesk__Incident__c> retrieveds = [
            SELECT
                Id,
                (
                    SELECT
                        Id
                    FROM
                        Tickets__r
                )
            FROM
                BMCServiceDesk__Incident__c
            WHERE
                Id IN :incidentIds
                AND (
                    BMCServiceDesk__FKTemplate__r.Name LIKE 'AME Demand Management Incident'
                    AND BMCServiceDesk__FKRequestDefinition__r.Name LIKE 'AME New Demand'
                    AND BMCServiceDesk__FKCategory__c != null
                )];
        if(retrieveds.size() > 0) {
            Id demandRecordTypeId = project_cloud.RecordTypeHelper.get(project_cloud__Ticket__c.SObjectType, 'AME_project_cloud_Demand').Id;
            List<project_cloud__Ticket__c> ticketsForUpsert = new List<project_cloud__Ticket__c>();
            BMCServiceDesk__Incident__c incident;
            for(BMCServiceDesk__Incident__c retrieved : retrieveds) {
                incident = Trigger.newMap.get(retrieved.Id);
                if(incident != null) {
                    if(retrieved.Tickets__r.size() == 0) {
                        ticketsForUpsert.add(new project_cloud__Ticket__c(
                            AME_project_cloud_Incident__c = incident.Id,
                            RecordTypeId = demandRecordTypeId,
                            project_cloud__Ticket_Name__c = incident.Summary__c,
                            project_cloud__Description__c = incident.BMCServiceDesk__incidentDescription__c,
                            AME_project_cloud_Demand_Description__c = incident.BMCServiceDesk__incidentDescription__c,
                            AME_project_cloud_Benefits__c = incident.AME_Benefits__c,
                            AME_project_cloud_Impact_Incident__c = incident.AME_Impact__c,
                            AME_project_cloud_Current_Situation__c = incident.AME_Current_Situation__c
                            //OwnerId = TBD
                        ));
                    } else {
                        /*if the ticket values should be updated when the incident is, this code block should be used.
                        for(project_cloud__Ticket__c ticket : retrieved.Tickets__r) {
                            ticket.project_cloud__Ticket_Name__c = incident.Summary__c;
                            ticket.project_cloud__Description__c = incident.BMCServiceDesk__incidentDescription__c;
                            ticket.AME_project_cloud_Demand_Description__c = incident.BMCServiceDesk__incidentDescription__c;
                            ticket.AME_project_cloud_Benefits__c = incident.AME_Benefits__c;
                            ticket.AME_project_cloud_Impact_Incident__c = incident.AME_Impact__c;
                            ticket.AME_project_cloud_Current_Situation__c = incident.AME_Current_Situation__c;
                            ticketsForUpsert.add(ticket);
                        }
                        */
                    }
                }
            }
            if(ticketsForUpsert.size() > 0) {
                try {
                    upsert ticketsForUpsert;
                } catch(DmlException e) {
                    project_cloud__Ticket__c failedTicket;
                    for(Integer i = 0; i < e.getNumDml(); i++) {
                        failedTicket = ticketsForUpsert.get(e.getDmlIndex(i));
                        Trigger.newMap.get(failedTicket.AME_project_cloud_Incident__c).addError(e.getDmlMessage(i));
                    }
                }
            }
        }
    }
}