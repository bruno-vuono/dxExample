public with sharing class MMPJ_TOPG_AP01_MileStones
{

public static void createDefaultMileStones(List <MMPJ_TOPG_Project__c> lstProjects){    
    List <MMPJ_TOPG_ProjectMilestone__c>lstmilestones= new List<MMPJ_TOPG_ProjectMilestone__c>();
    List <String> lstDefaultMilestones1 = new List <String>
    {'18 Months: Concept and pricing presentation'
    ,'12 Months: Look and feel, sampling and financials'
    ,'6 Months: Toolkit','Launch'
    };
    List <String> lstDefaultMilestones2 = new List <String>
    {'Briefing Big idea'
    ,'Idea Development'
    ,'Workshop Localization'
    ,'Campaign Shaping'
    ,'Production'
    };
     List <String> lstDefaultMilestones3 = new List <String>
    {'Briefing Design Development'
    ,'Design validation'
    ,'Mock-Up Production'
    ,'Design finalization'
    ,'Production'
    ,'Shipping'
    ,'Distribution in market'
    };
    List <String> lstDefaultMilestones4 = new List <String>
    {'Deadline for information spreadsheet'
    ,'Pre-submission deadline for offers'
    ,'Tasting approval process'
    ,'Samples submission for tasting'
    ,'Tasting'
    ,'Tasting results'
    ,'Order details'
    };
    if (Trigger.isUpdate){
    system.debug('in update');
    
   }
    Integer rankId=0;
    
    for (MMPJ_TOPG_Project__c project : lstProjects){   
     rankId=0;
     //insert default mileStones     
     if (project.MMPJ_TOPG_ProjectType__c=='Central Development' && project.MMPJ_TOPG_ProjectTopic__c =='Product')
     {
         for (String mileName :lstDefaultMilestones1)
         {
              createDefaultsMilestones(lstmilestones,mileName,project.id,rankId);
              rankId++;
         }    
     }
     else if (project.MMPJ_TOPG_ProjectType__c=='Co-Development' && project.MMPJ_TOPG_ProjectTopic__c =='Media Campaign'){
        for (String mileName :lstDefaultMilestones2)
         {
             createDefaultsMilestones(lstmilestones,mileName,project.id,rankId);
             rankId++;
         }
    }
    else if (project.MMPJ_TOPG_ProjectType__c=='Co-Development' && project.MMPJ_TOPG_ProjectTopic__c =='Product Launch')
    {
        for (String mileName :lstDefaultMilestones3)
         {
            createDefaultsMilestones(lstmilestones,mileName,project.id,rankId);
            rankId++;
         }
    }
    else if (project.MMPJ_TOPG_ProjectType__c=='Pitch')
    {
        for (String mileName :lstDefaultMilestones4)
         {
            createDefaultsMilestones(lstmilestones,mileName,project.id,rankId);
            rankId++;
         }
    }
 } 
    system.debug('lstmilestones =='+lstmilestones.size());   
    insert lstmilestones;
}

public static void createDefaultsMilestones(List<MMPJ_TOPG_ProjectMilestone__c>lstmilestones,String mileName,String projectId,Integer rankId)
 {
    MMPJ_TOPG_ProjectMilestone__c mile = new MMPJ_TOPG_ProjectMilestone__c();
    mile.name=mileName;
    mile.MMPJ_TOPG_MilestoneTitle__c=mileName;
    mile.MMPJ_TOPG_Project__c=projectId;
    mile.MMPJ_TOPG_IsDefault__c=true;
    mile.MMPJ_TOPG_MMPJ_Status__c='Planned';
    mile.MMPJ_TOPG_Date__c=System.Today();
    mile.MMPJ_TOPG_Rank__c=rankId;
    lstmilestones.add(mile);  
 } 
}