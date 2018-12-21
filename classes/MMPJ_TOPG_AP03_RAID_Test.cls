@isTest
public class MMPJ_TOPG_AP03_RAID_Test {
     private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
     static testMethod void createTaskTest(){
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
        project.MMPJ_TOPG_StartDate__c= System.today()-10;
        project.MMPJ_TOPG_EndDate__c= System.today()+20;
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert (project);
        
        //insert meeting 
        MMPJ_TOPG_Meeting__c meeting = new MMPJ_TOPG_Meeting__c();
        meeting.MMPJ_TOPG_Title__c ='meeting';
        meeting.MMPJ_TOPG_StartDate__c =System.today()-20;
        meeting.MMPJ_TOPG_EndDate__c =System.today()+15;
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
       
        //insert RAIDs
        MMPJ_TOPG_Raid__c raid = new MMPJ_TOPG_Raid__c ();
        raid.MMPJ_TOPG_Title__c='test Raid';
        raid.MMPJ_TOPG_ExpectedDate__c = System.today();
        raid.MMPJ_TOPG_Status__c = 'Planned';
        raid.MMPJ_TOPG_RAID__c='Action';
        raid.MMPJ_TOPG_Project__c = project.id;
        raid.MMPJ_TOPG_User__c = u.id;
        raid.MMPJ_TOPG_Highlight__c = false;
         
        MMPJ_TOPG_Raid__c raid2 = new MMPJ_TOPG_Raid__c ();
        raid2.MMPJ_TOPG_Title__c ='test Raid';
        raid2.MMPJ_TOPG_ExpectedDate__c = System.today();
        raid2.MMPJ_TOPG_Status__c = 'Planned';
        raid2.MMPJ_TOPG_RAID__c ='Action';
        raid2.MMPJ_TOPG_Project__c = project.id;
        raid2.MMPJ_TOPG_User__c = null;
        
         MMPJ_TOPG_Raid__c raid3 = new MMPJ_TOPG_Raid__c ();
        raid3.MMPJ_TOPG_Title__c ='test Raid';
        raid3.MMPJ_TOPG_ExpectedDate__c = System.today();
        raid3.MMPJ_TOPG_Status__c = 'Planned';
        raid3.MMPJ_TOPG_RAID__c ='Action';
        raid3.MMPJ_TOPG_Project__c = project.id;
        raid3.MMPJ_TOPG_User__c = null;
        List <MMPJ_TOPG_RAID__c> listRAID = new List<MMPJ_TOPG_Raid__c>();
        listRAID.add(raid);
        listRAID.add(raid2);
        listRAID.add(raid3);
        insert(new List<MMPJ_TOPG_Raid__c>{raid, raid2,raid3});         
         
          //task         
         
         Task Tache = new Task();
            if(raid.MMPJ_TOPG_User__c != null)
                Tache.OwnerId = raid.MMPJ_TOPG_User__c;
            else
            Tache.Whoid= raid.MMPJ_TOPG_Contact__c;
            Tache.Description = raid.MMPJ_TOPG_Description__c;
            Tache.ActivityDate = raid.MMPJ_TOPG_ExpectedDate__c;
            Tache.WhatId = raid.id;
            Tache.Status = raid.MMPJ_TOPG_Status__c;
            Tache.Subject = raid.MMPJ_TOPG_Title__c;
            Tache.MMPJ_TOPG_ProjectRaid__c = true;
            Tache.MMPJ_TOPG_ProjectChanged__c = true;
            insert Tache; 
         
          //task
         Task Tache1 = new Task();
            if(raid.MMPJ_TOPG_User__c != null)
                Tache.OwnerId = raid2.MMPJ_TOPG_User__c;
            else
            Tache1.Whoid= raid2.MMPJ_TOPG_Contact__c;
            Tache1.Description = raid2.MMPJ_TOPG_Description__c;
            Tache1.ActivityDate = raid2.MMPJ_TOPG_ExpectedDate__c;
            Tache1.WhatId = raid2.id;
            Tache1.Status = raid2.MMPJ_TOPG_Status__c;
            Tache1.Subject = raid2.MMPJ_TOPG_Title__c;
            Tache1.MMPJ_TOPG_ProjectRaid__c = true;
            Tache1.MMPJ_TOPG_ProjectChanged__c = true;
            insert Tache1;          
       	    Test.StartTest();      
            MMPJ_TOPG_AP03_Raid.isFirstTime = true;
       
            MMPJ_TOPG_AP03_RAID.createTask(listRAID);
            MMPJ_TOPG_AP03_RAID.deleteTask(new Set<ID>{raid3.id});
            Map<Id,MMPJ_TOPG_RAID__c> mapRAID = new Map<Id,MMPJ_TOPG_RAID__c> ();
            mapRAID.put(Tache1.id,raid2);
            mapRAID.put(Tache.id,raid);
            mapRAID.put(Tache.id,raid2);
            MMPJ_TOPG_AP03_RAID.updateTask(mapRAID);
        Test.StopTest();    
     }
}