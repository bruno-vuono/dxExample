@isTest
public class MMPJ_TOPG_AP02_RAID_Test {
     private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void updateMOMLineItemTest(){
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test@supervisor.com', email = mailPrefix+'-test@supervisor.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        insert u;
        //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='France ID';
        insert market;
        //create brand 
        MMPJ_TOPG_Brand__c brand= new MMPJ_TOPG_brand__c();
        brand.Name='testBrand';
        insert brand;
        
        RecordType rt = [Select id,Name 
                         From RecordType 
                         Where SobjectType='MMPJ_TOPG_MoMLineItem__c' and Name='Line Item Project' Limit 1];
                         
        //insert project 
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert (project);
        
        //insert meeting 
        MMPJ_TOPG_Meeting__c meeting = new MMPJ_TOPG_Meeting__c();
        meeting.MMPJ_TOPG_Title__c ='meeting';
        meeting.MMPJ_TOPG_StartDate__c =System.Today()-10;
        meeting.MMPJ_TOPG_EndDate__c =System.Today()+10;
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
        mom.MMPJ_TOPG_When__c = System.today();
        mom.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom.MMPJ_TOPG_RAID__c='Action';
        mom.MMPJ_TOPG_RelatedProject__c=project.id;
        insert (mom);
        
        MMPJ_TOPG_MoMLineItem__c mom1 = new MMPJ_TOPG_MoMLineItem__c();
        mom1.MMPJ_TOPG_Topic__c= 'Topic Mom';
        mom1.RecordTypeId  = rt.id;
        mom1.MMPJ_TOPG_When__c = System.today();
        mom1.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom1.MMPJ_TOPG_RAID__c='Action';
        mom1.MMPJ_TOPG_RelatedProject__c=project.id;
        insert (mom1);
        
        MMPJ_TOPG_RAID__c raid0 = new MMPJ_TOPG_RAID__c();                
        raid0.MMPJ_TOPG_RAID__c = 'Action';
        raid0.MMPJ_TOPG_Meeting__c = meeting.id;                
        raid0.MMPJ_TOPG_Highlight__c = true;
        raid0.MMPJ_TOPG_ExpectedDate__c = date.today();
        raid0.MMPJ_TOPG_Status__c = 'Planned';
        raid0.MMPJ_TOPG_Title__c = 'Title';
        raid0.MMPJ_TOPG_Project__c=project.id;
        insert raid0;
        
        MMPJ_TOPG_RAID__c raid1 = new MMPJ_TOPG_RAID__c();                
        raid1.MMPJ_TOPG_RAID__c = 'Action';
        raid1.MMPJ_TOPG_Meeting__c = meeting.id;                
        raid1.MMPJ_TOPG_Highlight__c = true;
        raid1.MMPJ_TOPG_ExpectedDate__c = date.today();
        raid1.MMPJ_TOPG_Status__c = 'Planned';
        raid1.MMPJ_TOPG_Title__c = 'Title';
        raid1.MMPJ_TOPG_Project__c=project.id;
        insert raid1;
        
        Test.StartTest();
        Map<Id,MMPJ_TOPG_RAID__c> mapLineItemAndRAIDToUpdateLineItem =  new Map<Id,MMPJ_TOPG_RAID__c>();
        mapLineItemAndRAIDToUpdateLineItem.put(mom.id,raid0);
        mapLineItemAndRAIDToUpdateLineItem.put(mom1.id,raid1);
        MMPJ_TOPG_AP02_RAID.updateMOMLineItem(mapLineItemAndRAIDToUpdateLineItem);        
        List<MMPJ_TOPG_Raid__c> listRaid = new List<MMPJ_TOPG_Raid__c>();        
        Test.StopTest();
        
    }

}