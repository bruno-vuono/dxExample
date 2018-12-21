public with sharing class MMPJ_TOPG_MyTasksExt {
    
    public MMPJ_TOPG_RAID__c theRaid{get;set;}   
    public list<MMPJ_TOPG_RAID__c> listTodos{get;set;}
            
    public MMPJ_TOPG_MyTasksExt(ApexPages.StandardController controller) {
        theRaid = (MMPJ_TOPG_RAID__c)controller.getRecord();

        if(theRaid == null || theRaid.Id == null){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a valid project.'));
        }
        else{
				 	listTodos = new list<MMPJ_TOPG_RAID__c>();		
            		listTodos = [SELECT MMPJ_TOPG_User__c, MMPJ_TOPG_Responsible__c, MMPJ_TOPG_Contact__c, MMPJ_TOPG_Brand__c, CreatedById, 
					CreatedDate, CurrencyIsoCode, IsDeleted, MMPJ_TOPG_Desc__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_TechEndDate__c, 
					MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_Highlight__c, LastActivityDate, LastModifiedById, LastModifiedDate, 
					MMPJ_TOPG_Rank__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Meeting__c, MMPJ_TOPG_LineItem__c, OwnerId, MMPJ_TOPG_Project__c, 
					MMPJ_TOPG_RAID__c, Name, Id, MMPJ_TOPG_TechEmail__c, MMPJ_TOPG_TechStartDate__c, MMPJ_TOPG_Status__c,
					SystemModstamp, MMPJ_TOPG_Tech_FocusDate__c, MMPJ_TOPG_Title__c FROM MMPJ_TOPG_RAID__c
                      where MMPJ_TOPG_User__c =:UserInfo.getUserId()
                        ];
        }
        
    }
    
    /*public void SetNewTabValue()
    {
        newTab = newTabTobe;
        system.debug('&&&& theRaid.Milestones__r ' + theRaid.Milestones__r);
        if(theRaid.id != null && theRaid.Milestones__r.size() < 1)
        {
            
            theRaid =[SELECT Id, Name, MMPJ_TOPG_Actuals__c,  MMPJ_TOPG_Brand__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_EndDate__c, MMPJ_TOPG_ForecastBudget__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Product__c, MMPJ_TOPG_ProjectOwner__c, MMPJ_TOPG_ProjectTopic__c, MMPJ_TOPG_ProjectType__c, MMPJ_TOPG_StartDate__c,MMPJ_TOPG_DelivAttachments__c,MMPJ_TOPG_ProjManagAttachments__c,owner.email
                            ,(SELECT Id, Name, MMPJ_TOPG_Contact__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_User__c, MMPJ_TOPG_Who__c FROM Project_Team_Members__r)
                            ,(SELECT Id, Name, MMPJ_TOPG_A__c, MMPJ_TOPG_C__c, MMPJ_TOPG_Date__c, MMPJ_TOPG_DeliverableDescription__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_I__c, MMPJ_TOPG_MilestoneTitle__c, MMPJ_TOPG_RAID__c, MMPJ_TOPG_R__c, MMPJ_TOPG_RemainingTime__c, MMPJ_TOPG_MMPJ_Status__c, MMPJ_TOPG_Rank__c,MMPJ_TOPG_IsDefault__c  FROM Milestones__r ORDER BY MMPJ_TOPG_Rank__c)
                            ,(SELECT Id, Name,lastModifiedDate,createdBy.name,createdBy.id,ContentType from Attachments)
                            ,(SELECT Id, Name, MMPJ_TOPG_Brand__c, MMPJ_TOPG_Desc__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_Highlight__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Meeting__c, MMPJ_TOPG_Meeting__r.name, MMPJ_TOPG_RAID__c, MMPJ_TOPG_RAID__c, MMPJ_TOPG_Responsible__c, MMPJ_TOPG_Status__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_Rank__c, MMPJ_TOPG_Contact__c, MMPJ_TOPG_User__c,MMPJ_TOPG_LineItem__c FROM RAIDs__r ORDER BY MMPJ_TOPG_Rank__c)
                            FROM MMPJ_TOPG_RAID__c
                            WHERE Id =:theRaid.Id
                        ];
            system.debug('&&&& theRaid.Milestones__r ' + theRaid.Milestones__r);
        }
    }*/

}