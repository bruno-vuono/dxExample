public with sharing class MMPJ_TOPG_ManipulateMilestones {

    list <MMPJ_TOPG_ProjectMilestone__c> listOfMilestonem3{get;set;}
    list <MMPJ_TOPG_ProjectMilestone__c> listOfMilestoneM4{get;set;}

    public static void AlertMilestones()
        {
        map <String,List <MMPJ_TOPG_ProjectMilestone__c>> ProjectMilestonesMap = new map <String,List <MMPJ_TOPG_ProjectMilestone__c>>();
        map <String,List <MMPJ_TOPG_ProjectMilestone__c>> ProjectMilestonesMapM3 = new map <String,List <MMPJ_TOPG_ProjectMilestone__c>>();
        map <String,List <MMPJ_TOPG_ProjectMilestone__c>> ProjectMilestonesMapM4 = new map <String,List <MMPJ_TOPG_ProjectMilestone__c>>();
        ProjectMilestonesMap = new map <String,list <MMPJ_TOPG_ProjectMilestone__c>>();
        List <MMPJ_TOPG_Project__c> lstProjects =[select id,name,MMPJ_TOPG_ProjectOwner__r.Email,(SELECT Id,MMPJ_TOPG_Project__c,MMPJ_TOPG_RemainingTime__c,MMPJ_TOPG_Project__r.name,MMPJ_TOPG_MMPJ_Status__c,MMPJ_TOPG_Date__c,MMPJ_TOPG_MilestoneTitle__c FROM Milestones__r) from MMPJ_TOPG_Project__c];
        system.debug('lstProjects ' + lstProjects);
        for (MMPJ_TOPG_Project__c project : lstProjects ){
            for(MMPJ_TOPG_ProjectMilestone__c milestone:project.Milestones__r){
                if (milestone.MMPJ_TOPG_RemainingTime__c < 1 && milestone.MMPJ_TOPG_MMPJ_Status__c!=label.MMPJ_TOPG_StatusDone)
                {
                    if (ProjectMilestonesMapM4.containsKey(project.MMPJ_TOPG_ProjectOwner__r.Email)){
                        ProjectMilestonesMapM4.get(project.MMPJ_TOPG_ProjectOwner__r.Email).add(milestone);
                    }
                    else{
                        ProjectMilestonesMapM4.put(project.MMPJ_TOPG_ProjectOwner__r.Email,new list <MMPJ_TOPG_ProjectMilestone__c>());
                    } 
                }
                else if (milestone.MMPJ_TOPG_RemainingTime__c < 10){
                    if (ProjectMilestonesMapM3.containsKey(project.MMPJ_TOPG_ProjectOwner__r.Email)){
                        ProjectMilestonesMapM3.get(project.MMPJ_TOPG_ProjectOwner__r.Email).add(milestone);
                    }
                    else {
                        ProjectMilestonesMapM3.put(project.MMPJ_TOPG_ProjectOwner__r.Email,new list <MMPJ_TOPG_ProjectMilestone__c>());
                    }
                }
            }
        }
            String messageP3 ='Please find hereunder the list of Milestones which are related to project you own, whose delivery date is inferior to ten days';
            String messageP4='Please find hereunder the list of Delayed Milestones which are related to project you own.';
        for (String receiver:ProjectMilestonesMapM3.keyset()){
            system.debug('in send mail 1');
            sendEmail(ProjectMilestonesMapM3.get(receiver),messageP3,receiver);    
        }
        for (String receiver : ProjectMilestonesMapM4.keyset()){
            system.debug('in send mail 2');
            sendEmail(ProjectMilestonesMapM4.get(receiver),messageP4,receiver);
        }

    }
    public static void sendEmail(List <MMPJ_TOPG_ProjectMilestone__c> listMilestones,String message ,String receiver){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
        mail.setToAddresses(new String[]{receiver});//'toufic.ghemrawi@ei-technologies.com'

        String body= message+'<br/>';        
        body += '<table border=1><tr><td><b>Project</b></td><td><b>Milestone title</b></td><td><b>Date</b></td><td><b>Responsible</b></td><td><b>Status</b></td></tr>' ;
        for(MMPJ_TOPG_ProjectMilestone__c m :listMilestones) {
            body +='<tr><td>'+m.MMPJ_TOPG_Project__r.name+'</td>'+'<td>'+m.MMPJ_TOPG_MilestoneTitle__c +'</td>'+'<td>'+m.MMPJ_TOPG_Date__c+'</td>'+'</td>'+'<td>'+receiver+'</td>'+'<td>'+m.MMPJ_TOPG_MMPJ_Status__c+'</td></tr>';
        }
        body +='</table>';
        system.debug('body  ==='+body );               
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            
    }
}