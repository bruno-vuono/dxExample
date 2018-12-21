@isTest
public class MMPJ_TOPG_VF03_ToDoPDFcontroller_test{
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void myUnitTest() {
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test-supervisor@pernod-ricard.com', email = mailPrefix+'-test-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        insert u;
        //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='France ID';
        insert market;
        //create brand 
        MMPJ_TOPG_Brand__c brand= new MMPJ_TOPG_brand__c();
        brand.Name='testBrand';
        insert brand;
        RecordType rt = [select id,Name from RecordType where SobjectType='MMPJ_TOPG_MoMLineItem__c' and Name='Line Item Project' Limit 1];
        system.debug('RecordType === '+rt);
        //insert project 
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert project;
        //insert meeting 
        MMPJ_TOPG_Meeting__c meeting = new MMPJ_TOPG_Meeting__c();
        meeting.MMPJ_TOPG_Title__c ='meeting';
        meeting.MMPJ_TOPG_StartDate__c =Date.newInstance(2016,11,11);
        meeting.MMPJ_TOPG_EndDate__c =Date.newInstance(2016,11,11);
        meeting.MMPJ_TOPG_Interaction__c = 'Call';
        insert meeting;
        
        //insert minutes of meeting
        MMPJ_TOPG_MinuteOfMeeting__c minutes = new MMPJ_TOPG_MinuteOfMeeting__c();
        minutes.MMPJ_TOPG_Status__c='Draft';
        minutes.MMPJ_TOPG_Title__c ='Test minutes';
        minutes.MMPJ_TOPG_Topic__c='Test minutes';
        minutes.MMPJ_TOPG_RAID__c='Action';
        minutes.MMPJ_TOPG_Meeting__c = meeting.id;
        insert minutes;
        //insert mom line item 
        MMPJ_TOPG_MoMLineItem__c mom = new MMPJ_TOPG_MoMLineItem__c();
        mom.MMPJ_TOPG_Topic__c= 'Topic Mom';
        mom.RecordTypeId  = rt.id;
        mom.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom.MMPJ_TOPG_RAID__c='Action';
        mom.MMPJ_TOPG_RelatedProject__c=project.id;
        insert mom;
        
        //insert RAID
        MMPJ_TOPG_Raid__c raid = new MMPJ_TOPG_Raid__c ();
        raid.MMPJ_TOPG_TechStartDate__c=Date.newInstance(2016,11,11);
        raid.MMPJ_TOPG_TechEndDate__c =Date.newInstance(2016,12,12);
        raid.MMPJ_TOPG_Title__c='test Raid';
        raid.MMPJ_TOPG_ExpectedDate__c =Date.newInstance(2016,12,12);
        raid.MMPJ_TOPG_Status__c = 'Planned';
        raid.MMPJ_TOPG_RAID__c='Action';
        //RAID.MMPJ_TOPG_LineItem__c = mom.id;
        raid.MMPJ_TOPG_Project__c =project.id;
        insert raid ;
        
        MMPJ_TOPG_Raid__c raid2 = new MMPJ_TOPG_Raid__c ();
        raid2.MMPJ_TOPG_TechStartDate__c=Date.newInstance(2016,11,11);
        raid2.MMPJ_TOPG_TechEndDate__c =Date.newInstance(2016,12,12);
        raid2.MMPJ_TOPG_Title__c='test Raid';
        raid2.MMPJ_TOPG_ExpectedDate__c =Date.newInstance(2016,12,12);
        raid2.MMPJ_TOPG_Status__c = 'Planned';
        raid2.MMPJ_TOPG_RAID__c='Action';
        raid2.MMPJ_TOPG_LineItem__c = mom.id;
        raid2.MMPJ_TOPG_Project__c =project.id;
        raid2.MMPJ_TOPG_Description__c='Descriptions';
        insert raid2;
        
        MMPJ_TOPG_Raid__c raid3= new MMPJ_TOPG_Raid__c ();
        raid3.MMPJ_TOPG_TechStartDate__c=Date.newInstance(2016,11,11);
        raid3.MMPJ_TOPG_TechEndDate__c =Date.newInstance(2016,12,12);
        raid3.MMPJ_TOPG_Title__c='test Raid';
        raid3.MMPJ_TOPG_ExpectedDate__c =Date.newInstance(2016,12,12);
        raid3.MMPJ_TOPG_Status__c = 'Planned';
        raid3.MMPJ_TOPG_RAID__c='Action';
        raid3.MMPJ_TOPG_LineItem__c = mom.id;
        raid3.MMPJ_TOPG_Project__c =project.id;
        raid3.MMPJ_TOPG_Description__c='Descriptions';
        
        Test.startTest();
        PageReference PageTest  = page.MMPJ_TOPG_VF03_ToDoPDF;
        Test.setCurrentPage(PageTest);
        ApexPages.currentPage().getParameters().put('ProjectId',project.id);
        MMPJ_TOPG_VF03_ToDoPDFcontroller mmpj = new MMPJ_TOPG_VF03_ToDoPDFcontroller();
        Test.stopTest();
    }
}