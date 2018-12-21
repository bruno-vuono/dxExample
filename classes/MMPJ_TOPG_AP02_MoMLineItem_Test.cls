@isTest
public class MMPJ_TOPG_AP02_MoMLineItem_Test{
     private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void createTaskTest(){
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
        project.MMPJ_TOPG_StartDate__c= System.today()-20;
        project.MMPJ_TOPG_EndDate__c= System.today()+10;
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert (project);
        
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
        mom.MMPJ_TOPG_When__c = System.today();
        mom.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom.MMPJ_TOPG_RAID__c='Action';
        mom.MMPJ_TOPG_IsHighlight__c = true;
        mom.MMPJ_TOPG_RelatedProject__c=project.id;
        mom.MMPJ_TOPG_WhoU__c = u.id;
        
        MMPJ_TOPG_MoMLineItem__c mom2 = new MMPJ_TOPG_MoMLineItem__c();
        mom2.MMPJ_TOPG_Topic__c= 'Topic Mom';
        mom2.RecordTypeId  = rt.id;
        mom.MMPJ_TOPG_IsHighlight__c = false;
        mom2.MMPJ_TOPG_RAID__c=null;
        mom2.MMPJ_TOPG_When__c = System.today();
        mom2.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom2.MMPJ_TOPG_RelatedProject__c=project.id;
        mom2.MMPJ_TOPG_WhoU__c = u.id;
        
        MMPJ_TOPG_MoMLineItem__c mom3 = new MMPJ_TOPG_MoMLineItem__c();
        mom3.MMPJ_TOPG_Topic__c= 'Topic Mom';
        mom3.RecordTypeId  = rt.id;
        mom3.MMPJ_TOPG_IsHighlight__c = true;
        mom3.MMPJ_TOPG_RAID__c=null;
        mom3.MMPJ_TOPG_When__c = System.today();
        mom3.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        mom3.MMPJ_TOPG_RelatedProject__c=project.id;
        mom3.MMPJ_TOPG_WhoU__c = u.id;
        List <MMPJ_TOPG_MoMLineItem__c> listMoMLineItem = new List <MMPJ_TOPG_MoMLineItem__c> ();
        listMoMLineItem.add(mom);
        listMoMLineItem.add(mom2);
        listMoMLineItem.add(mom3);
        insert listMoMLineItem;      
       
        List<Task> listTask = new List<Task>();
        listTask = [Select id, whatId
                     From Task where whatId IN (:mom.id,:mom2.id,:mom3.id)];
        System.assertequals(listTask.size(), 0);
        
        Test.StartTest();       
        MMPJ_TOPG_AP02_MoMLineItem.createTask(listMoMLineItem);
        MMPJ_TOPG_AP02_MoMLineItem.deleteTask(new Set<ID>{mom3.id});
        Map<Id,MMPJ_TOPG_MoMLineItem__c> newLineItem = new Map<Id,MMPJ_TOPG_MoMLineItem__c> ();
        newLineItem.put(mom.id,mom);
        newLineItem.put(mom2.id,mom2);
        newLineItem.put(mom2.id,mom);
        MMPJ_TOPG_AP02_MoMLineItem.updateTask(newLineItem);
        Test.StopTest();
    }
}