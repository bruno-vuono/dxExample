public with sharing class MMPJ_TOPG_NewProjectExt {
    
    public MMPJ_TOPG_Project__c theProject{get;set;}
    public integer saveComplete{get;set;}
    public string newtabTobe {get;set;}
    public string newTab{get;set;}
            
    public MMPJ_TOPG_NewProjectExt(ApexPages.StandardController controller) {
        theProject = (MMPJ_TOPG_Project__c)controller.getRecord();

        if(theProject == null || theProject.Id == null){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a valid project.'));
        }
      else{
            theProject = [SELECT Id, Name, MMPJ_TOPG_Actuals__c,  MMPJ_TOPG_Brand__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_EndDate__c, MMPJ_TOPG_ForecastBudget__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Product__c, MMPJ_TOPG_ProjectOwner__c, MMPJ_TOPG_ProjectTopic__c, MMPJ_TOPG_ProjectType__c, MMPJ_TOPG_StartDate__c,MMPJ_TOPG_DelivAttachments__c,MMPJ_TOPG_ProjManagAttachments__c,owner.email,MMPJ_TOPG_NewProjectType__c
                            ,(SELECT Id, Name, MMPJ_TOPG_Contact__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_User__c, MMPJ_TOPG_Who__c FROM Project_Team_Members__r)
                            ,(SELECT Id, Name, MMPJ_TOPG_A__c, MMPJ_TOPG_C__c, MMPJ_TOPG_Date__c, MMPJ_TOPG_DeliverableDescription__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_I__c, MMPJ_TOPG_MilestoneTitle__c, MMPJ_TOPG_Project__c, MMPJ_TOPG_R__c, MMPJ_TOPG_RemainingTime__c, MMPJ_TOPG_MMPJ_Status__c, MMPJ_TOPG_Rank__c,MMPJ_TOPG_IsDefault__c  FROM Milestones__r ORDER BY MMPJ_TOPG_Rank__c)
                            ,(SELECT Id, Name,lastModifiedDate,createdBy.name,createdBy.id,ContentType from Attachments)
                            ,(SELECT Id, Name, MMPJ_TOPG_Brand__c, MMPJ_TOPG_Desc__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_Highlight__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Meeting__c, MMPJ_TOPG_Meeting__r.name, MMPJ_TOPG_Project__c, MMPJ_TOPG_RAID__c, MMPJ_TOPG_Responsible__c, MMPJ_TOPG_Status__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_Rank__c, MMPJ_TOPG_Contact__c, MMPJ_TOPG_User__c,MMPJ_TOPG_LineItem__c FROM RAIDs__r ORDER BY MMPJ_TOPG_Rank__c)
                            FROM MMPJ_TOPG_Project__c
                            WHERE Id =:theProject.Id
                        ];
       }
        saveComplete= 0;
        newTab = 'Description';
        string TabName = ApexPages.currentPage().getParameters().get('TabName');
        if(!String.IsBlank(TabName))
            newTab = TabName; 
    }
    
    public void SetNewTabValue()
    {
        newTab = newTabTobe;
        system.debug('&&&& theProject.Milestones__r ' + theProject.Milestones__r);
        if(theProject.id != null && theProject.Milestones__r.size() < 1)
        {
            
            theProject =[SELECT Id, Name, MMPJ_TOPG_Actuals__c,  MMPJ_TOPG_Brand__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_EndDate__c, MMPJ_TOPG_ForecastBudget__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Product__c, MMPJ_TOPG_ProjectOwner__c, MMPJ_TOPG_ProjectTopic__c, MMPJ_TOPG_ProjectType__c, MMPJ_TOPG_StartDate__c,MMPJ_TOPG_DelivAttachments__c,MMPJ_TOPG_ProjManagAttachments__c,owner.email
                            ,(SELECT Id, Name, MMPJ_TOPG_Contact__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_User__c, MMPJ_TOPG_Who__c FROM Project_Team_Members__r)
                            ,(SELECT Id, Name, MMPJ_TOPG_A__c, MMPJ_TOPG_C__c, MMPJ_TOPG_Date__c, MMPJ_TOPG_DeliverableDescription__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_I__c, MMPJ_TOPG_MilestoneTitle__c, MMPJ_TOPG_Project__c, MMPJ_TOPG_R__c, MMPJ_TOPG_RemainingTime__c, MMPJ_TOPG_MMPJ_Status__c, MMPJ_TOPG_Rank__c,MMPJ_TOPG_IsDefault__c  FROM Milestones__r ORDER BY MMPJ_TOPG_Rank__c)
                            ,(SELECT Id, Name,lastModifiedDate,createdBy.name,createdBy.id,ContentType from Attachments)
                            ,(SELECT Id, Name, MMPJ_TOPG_Brand__c, MMPJ_TOPG_Desc__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_Highlight__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Meeting__c, MMPJ_TOPG_Meeting__r.name, MMPJ_TOPG_Project__c, MMPJ_TOPG_RAID__c, MMPJ_TOPG_Responsible__c, MMPJ_TOPG_Status__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_Rank__c, MMPJ_TOPG_Contact__c, MMPJ_TOPG_User__c,MMPJ_TOPG_LineItem__c FROM RAIDs__r ORDER BY MMPJ_TOPG_Rank__c)
                            FROM MMPJ_TOPG_Project__c
                            WHERE Id =:theProject.Id
                        ];
            system.debug('&&&& theProject.Milestones__r ' + theProject.Milestones__r);
        }
    }
// public PageReference MoveUpMileStones() {
       // if(MileStonesCounter > 0)
            //listMileStones.add(SelectedTodoCounter-1, listTodos.remove(SelectedTodoCounter));

        //LoadTodo();
       // return null;
   // }
}