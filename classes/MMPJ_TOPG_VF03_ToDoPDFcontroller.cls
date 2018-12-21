public with sharing class MMPJ_TOPG_VF03_ToDoPDFcontroller {
    public list<MMPJ_TOPG_RAID__c> listTodos{get;set;}
    public List <MMPJ_TOPG_ProjectMilestone__c> listMilesStonesToShow{get;set;}
    public MMPJ_TOPG_Project__c project{ get;set;}
    private String ProjectId {get;set;}
        
    public MMPJ_TOPG_VF03_ToDoPDFcontroller(){
        listTodos = new List<MMPJ_TOPG_RAID__c>();
        ProjectId = ApexPages.currentPage().getParameters().get('ProjectId');
        project = ProjectValues();
        listTodos  = getToDoListValues();
        listMilesStonesToShow = getlistMilestone();
    }
    public List <MMPJ_TOPG_RAID__c> getToDoListValues(){
        List <MMPJ_TOPG_RAID__c> lst = [select id,name
                                            ,MMPJ_TOPG_Title__c
                                            ,MMPJ_TOPG_Contact__c
                                            ,MMPJ_TOPG_User__c
                                            ,MMPJ_TOPG_RAID__c
                                            ,MMPJ_TOPG_Highlight__c
                                            ,MMPJ_TOPG_ExpectedDate__c
                                            ,MMPJ_TOPG_Status__c
                                            ,MMPJ_TOPG_Desc__c
                                            ,MMPJ_TOPG_Flag__c
                                            ,MMPJ_TOPG_Project__c
                                      from MMPJ_TOPG_RAID__c where MMPJ_TOPG_Project__c=:ProjectId ];
        return lst;
    }
    
    public MMPJ_TOPG_Project__c  ProjectValues(){
        MMPJ_TOPG_Project__c theProject = [select id,name,MMPJ_TOPG_StartDate__c
                                                        ,MMPJ_TOPG_EndDate__c
                                                        ,MMPJ_TOPG_ProjectType__c
                                                        ,MMPJ_TOPG_ProjectTopic__c
                                                        ,MMPJ_TOPG_ForecastBudget__c
                                                        ,MMPJ_TOPG_ProjectOwner__c
                                                        ,MMPJ_TOPG_Actuals__c
                                                        ,MMPJ_TOPG_Description__c
                                                        ,MMPJ_TOPG_DelivAttachments__c
                                                        ,MMPJ_TOPG_ProjManagAttachments__c
                                          from MMPJ_TOPG_Project__c where id=:ProjectId];
        return theProject;
    }
    
    public list<MMPJ_TOPG_ProjectMilestone__c> getlistMilestone(){
        list<MMPJ_TOPG_ProjectMilestone__c> listMilestoneDum= [SELECT Id
                                                                    , Name
                                                                    , MMPJ_TOPG_A__c
                                                                    , MMPJ_TOPG_C__c
                                                                    , MMPJ_TOPG_Date__c
                                                                    , MMPJ_TOPG_DeliverableDescription__c
                                                                    , MMPJ_TOPG_Flag__c
                                                                    , MMPJ_TOPG_I__c
                                                                    , MMPJ_TOPG_MilestoneTitle__c
                                                                    , MMPJ_TOPG_Project__c
                                                                    , MMPJ_TOPG_R__c
                                                                    , MMPJ_TOPG_RemainingTime__c
                                                                    , MMPJ_TOPG_MMPJ_Status__c
                                                                    , MMPJ_TOPG_Rank__c
                                                                    , MMPJ_TOPG_IsDefault__c  
                                                                FROM MMPJ_TOPG_ProjectMilestone__c 
                                                                WHERE MMPJ_TOPG_Project__c =:ProjectId 
                                                                ORDER BY MMPJ_TOPG_Rank__c];
        return listMilestoneDum;
    }
}