@isTest
public class MMPJ_TOPG_AP01_Task_Test {
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
        project.MMPJ_TOPG_StartDate__c = System.today() - 20;
        project.MMPJ_TOPG_EndDate__c = System.today() + 10;
        project.MMPJ_TOPG_ProjectOwner__c = u.id;  
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
        
         
        //insert RAID
        MMPJ_TOPG_Raid__c raid = new MMPJ_TOPG_Raid__c ();
        raid.MMPJ_TOPG_Title__c='test Raid';
        raid.MMPJ_TOPG_ExpectedDate__c = System.today();
        raid.MMPJ_TOPG_Status__c = 'Planned';
        raid.MMPJ_TOPG_RAID__c='Action';
        raid.MMPJ_TOPG_Project__c = project.id;
        raid.MMPJ_TOPG_User__c = u.id;
        insert(raid);
         
        MMPJ_TOPG_Raid__c raid1 = new MMPJ_TOPG_Raid__c ();
        raid1.MMPJ_TOPG_Title__c='test Raid';
        raid1.MMPJ_TOPG_ExpectedDate__c = System.today();
        raid1.MMPJ_TOPG_Status__c = 'Planned';
        raid1.MMPJ_TOPG_RAID__c='Action';
        raid1.MMPJ_TOPG_Project__c = project.id;
        raid1.MMPJ_TOPG_User__c = u.id;
        insert(raid1);
         
         //insert mom line item
        MMPJ_TOPG_MoMLineItem__c momItem = new MMPJ_TOPG_MoMLineItem__c();
        momItem.MMPJ_TOPG_Topic__c= 'Topic Mom';
        momItem.RecordTypeId  = rt.id;
        momItem.MMPJ_TOPG_When__c = System.today();
        momItem.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        momItem.MMPJ_TOPG_RAID__c='Action';
        momItem.MMPJ_TOPG_IsHighlight__c = true;
        momItem.MMPJ_TOPG_RelatedProject__c=project.id;
        momItem.MMPJ_TOPG_WhoU__c = u.id;
        insert (momItem);  
         
         //insert mom line item
        MMPJ_TOPG_MoMLineItem__c momItem1 = new MMPJ_TOPG_MoMLineItem__c();
        momItem1.MMPJ_TOPG_Topic__c= 'Topic Mom';
        momItem1.RecordTypeId  = rt.id;
        momItem1.MMPJ_TOPG_When__c = System.today();
        momItem1.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        momItem1.MMPJ_TOPG_RAID__c='Action';
        momItem1.MMPJ_TOPG_IsHighlight__c = true;
        momItem1.MMPJ_TOPG_RelatedProject__c=project.id;
        momItem1.MMPJ_TOPG_RAID__c = raid1.id;
        momItem1.MMPJ_TOPG_WhoU__c = u.id;
        insert (momItem1);  
         
        MMPJ_TOPG_MoMLineItem__c momItem2 = new MMPJ_TOPG_MoMLineItem__c();
        momItem2.MMPJ_TOPG_Topic__c= 'Topic Mom';
        momItem2.RecordTypeId  = rt.id;
        momItem2.MMPJ_TOPG_When__c = System.today();
        momItem2.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        momItem2.MMPJ_TOPG_RAID__c='Action';
        momItem2.MMPJ_TOPG_IsHighlight__c = true;
       // momItem2.MMPJ_TOPG_RAID__c = raid.id;
        momItem2.MMPJ_TOPG_RelatedProject__c=project.id;
        momItem2.MMPJ_TOPG_RAID__c = raid1.id;
        momItem2.MMPJ_TOPG_WhoU__c = u.id;
        insert (momItem2);  
         
        MMPJ_TOPG_MoMLineItem__c momItem3 = new MMPJ_TOPG_MoMLineItem__c();
        momItem3.MMPJ_TOPG_Topic__c= 'Topic Mom';
        momItem3.RecordTypeId  = rt.id;
        momItem3.MMPJ_TOPG_When__c = System.today();
        momItem3.MMPJ_TOPG_MinutesofMeeting__c= minutes.id;
        momItem3.MMPJ_TOPG_RAID__c='Action';
        momItem3.MMPJ_TOPG_IsHighlight__c = false;       
        momItem3.MMPJ_TOPG_RelatedProject__c=project.id;
        momItem3.MMPJ_TOPG_RAID__c = raid1.id;
        momItem3.MMPJ_TOPG_WhoU__c = u.id;
        insert (momItem3);  
         
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
         
         Task TacheMomItem = new Task();
            if(momItem.MMPJ_TOPG_WhoU__c != null)
                TacheMomItem.OwnerId = momItem.MMPJ_TOPG_WhoU__c;
            else
            TacheMomItem.Whoid=  momItem.MMPJ_TOPG_WhoU__c;
            TacheMomItem.Description = 'Description';
            TacheMomItem.ActivityDate = momItem.MMPJ_TOPG_When__c;
            TacheMomItem.WhatId = momItem.id;
            TacheMomItem.Status = 'Planned';
            TacheMomItem.Subject = 'Title';
            TacheMomItem.MMPJ_TOPG_ProjectRaid__c = true;
            TacheMomItem.MMPJ_TOPG_ProjectChanged__c = true;
            insert TacheMomItem; 
         
        Test.StartTest();       
        List<Task> listTask = new List<Task>();
          List<MMPJ_TOPG_MoMLineItem__c> listMomItems = new List<MMPJ_TOPG_MoMLineItem__c>();
         listMomItems = [Select id
                     From MMPJ_TOPG_MoMLineItem__c where id =: momItem1.id];
         listMomItems[0].MMPJ_TOPG_RAID__c= null;
        listMomItems[0].MMPJ_TOPG_RelatedProject__c = project.id;
          update(listMomItems);
         
         
         listMomItems = [Select id
                     From MMPJ_TOPG_MoMLineItem__c where id =: momItem2.id];
        listMomItems[0].MMPJ_TOPG_RAID__c= raid.id;
        listMomItems[0].MMPJ_TOPG_RelatedProject__c = null;
          update(listMomItems);
         
          listMomItems = [Select id
                     From MMPJ_TOPG_MoMLineItem__c where id =: momItem3.id];
         listMomItems[0].MMPJ_TOPG_RAID__c= raid.id;
         listMomItems[0].MMPJ_TOPG_RelatedProject__c = null;
          update(listMomItems);
         
        listTask = [Select id, WhatId 
                     From Task where WhatId IN (:momItem.id,:raid.id)];
        System.assertequals(listTask.size(), 2);    
        listTask[0].ActivityDate = System.today() + 2;
        //listTask[1].ActivityDate = System.today() + 2;
        MMPJ_TOPG_AP02_MomLineItem.isFirstTime = true;
        MMPJ_TOPG_AP03_Raid.isFirstTime = true;
        Map<Id,Task> mapLineItemAndTaskToUpdateLineItem = new Map<Id,Task>();
        mapLineItemAndTaskToUpdateLineItem.put(momItem.id,TacheMomItem);
        mapLineItemAndTaskToUpdateLineItem.put(raid.id,Tache);
        MMPJ_TOPG_AP01_Task.updateMOMLineItem(mapLineItemAndTaskToUpdateLineItem);
        MMPJ_TOPG_AP01_Task.updateRAID(mapLineItemAndTaskToUpdateLineItem);
        update(listTask);
        Test.StopTest();    
     }
}