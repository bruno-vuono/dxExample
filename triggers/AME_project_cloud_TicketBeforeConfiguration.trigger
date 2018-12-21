trigger AME_project_cloud_TicketBeforeConfiguration on project_cloud__Ticket__c (before insert, before update) {
    List<project_cloud__Ticket__c> ticketsToPopulate = new List<project_cloud__Ticket__c>();
    Map<Id, AME_project_cloud_Project_Charter__c> charters = new Map<Id, AME_project_cloud_Project_Charter__c>();
    project_cloud__Ticket__c oldValue = null;
    for(project_cloud__Ticket__c ticket : Trigger.new) {
        if(Trigger.isUpdate) {
            oldValue = Trigger.oldMap.get(ticket.Id);
            if(ticket.AME_project_cloud_Project_Charter__c != oldValue.AME_project_cloud_Project_Charter__c) {
                oldValue = null;
                //always clear the project, because if the relationship
                //to the charter was removed, this value will stay null
                ticket.project_cloud__Project__c = null;
            }
        }
        //oldValue is null if the charter lookup has changed
        //or this is an insert trigger
        if(oldValue == null && ticket.AME_project_cloud_Project_Charter__c != null) {
            ticketsToPopulate.add(ticket);
            charters.put(ticket.AME_project_cloud_Project_Charter__c, null);
        }
    }
    if(ticketsToPopulate.size() > 0) {
        charters = new Map<Id, AME_project_cloud_Project_Charter__c>([
            SELECT
                Id,
                Name,
                AME_project_cloud_Project__c
            FROM
                AME_project_cloud_Project_Charter__c
            WHERE
                Id IN :charters.keySet()]);
        for(project_cloud__Ticket__c ticket : ticketsToPopulate) {
            ticket.project_cloud__Project__c = charters.get(ticket.AME_project_cloud_Project_Charter__c).AME_project_cloud_Project__c;
        }
    }
}