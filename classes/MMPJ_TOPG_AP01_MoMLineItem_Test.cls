@isTest
public class MMPJ_TOPG_AP01_MoMLineItem_Test{
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void createProjectRAIDTest(){
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'test@supervisor.com', email = mailPrefix+'test@supervisor.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
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
        project.MMPJ_TOPG_StartDate__c= System.today();
        project.MMPJ_TOPG_EndDate__c= System.today()+20;
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert (project);
        
        MMPJ_TOPG_Project__c project1 = new MMPJ_TOPG_Project__c();
        project1.name = 'testProject1';
        project1.MMPJ_TOPG_StartDate__c= System.today();
        project1.MMPJ_TOPG_EndDate__c= System.today()+20;
        project1.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert (project1);
        
        //insert meeting 
        MMPJ_TOPG_Meeting__c meeting = new MMPJ_TOPG_Meeting__c();
        meeting.MMPJ_TOPG_Title__c ='meeting';
        meeting.MMPJ_TOPG_StartDate__c =System.today();
        meeting.MMPJ_TOPG_EndDate__c =System.today()+30;
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
        
        MMPJ_TOPG_MoMLineItem__c mom2 = new MMPJ_TOPG_MoMLineItem__c();
        mom2.MMPJ_TOPG_Topic__c= 'Topic Mom';
        mom2.RecordTypeId  = rt.id;
        mom2.MMPJ_TOPG_RAID__c=null;
        mom2.MMPJ_TOPG_When__c = System.today();
        mom2.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom2.MMPJ_TOPG_RelatedProject__c=project1.id;
        
        MMPJ_TOPG_MoMLineItem__c mom3 = new MMPJ_TOPG_MoMLineItem__c();
        mom3.MMPJ_TOPG_Topic__c= 'Topic Mom';
        mom3.RecordTypeId  = rt.id;
        mom3.MMPJ_TOPG_RAID__c='Action';
        mom3.MMPJ_TOPG_When__c = System.today();
        mom3.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom3.MMPJ_TOPG_RelatedProject__c=project.id;
        MMPJ_TOPG_AP01_MoMLineItem.isFirstTime = true;
        List<MMPJ_TOPG_MoMLineItem__c> listMoMLineItem = new List<MMPJ_TOPG_MoMLineItem__c>{mom,mom2,mom3};
        insert (listMoMLineItem);       

        Test.StartTest();
        MMPJ_TOPG_AP01_MoMLineItem.createProjectRAID(listMoMLineItem); 
        delete mom3;
        MMPJ_TOPG_AP01_MoMLineItem.deleteRAID(new Set<ID> {mom3.id});
        Map<Id,MMPJ_TOPG_MoMLineItem__c> newLineItem = new Map<Id,MMPJ_TOPG_MoMLineItem__c> ();
        newLineItem.put(mom.id,mom);
        newLineItem.put(mom2.id,mom2);
        MMPJ_TOPG_AP01_MoMLineItem.updateProjectRAID(newLineItem);                
        
        Test.StopTest();
    }
}