public with sharing class MMPJ_TOPG_ProjectDescriptionPDFCtrl{
public MMPJ_TOPG_Project__c Project{get;set;}

public  MMPJ_TOPG_ProjectDescriptionPDFCtrl(){
Project=ProjectValues();
}

public MMPJ_TOPG_Project__c  ProjectValues(){
String ProjectId =ApexPages.currentPage().getParameters().get('ProjectId'); 
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
}