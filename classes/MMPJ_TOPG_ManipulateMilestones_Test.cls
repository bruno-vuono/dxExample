@isTest
private class MMPJ_TOPG_ManipulateMilestones_Test{
         private static  Datetime myDT = Datetime.now();
         private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test-supervisor@pernod-ricard.com', email = mailPrefix+'-test-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        insert u;
        
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='France ID';
        insert market;
        //create brand 
        MMPJ_TOPG_Brand__c brand= new MMPJ_TOPG_brand__c();
        brand.Name='testBrand';
        insert brand;
        
         //insert project 
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id; 
        project.ownerid =u.id;   
        insert project;
        
        MMPJ_TOPG_ProjectMilestone__c miles = new MMPJ_TOPG_ProjectMilestone__c();
        miles.MMPJ_TOPG_A__c='Brand';
        miles.MMPJ_TOPG_Date__c= Date.today().addDays(-12);
        miles.MMPJ_TOPG_MilestoneTitle__c ='Test miles';
        miles.MMPJ_TOPG_Project__c = project.id;
        miles.MMPJ_TOPG_MMPJ_Status__c='Planned';
        insert miles;
        
        MMPJ_TOPG_ProjectMilestone__c miles2 = new MMPJ_TOPG_ProjectMilestone__c();
        miles2.MMPJ_TOPG_A__c='Brand';
        miles2.MMPJ_TOPG_Date__c= Date.today().addDays(-2);
        miles2.MMPJ_TOPG_MilestoneTitle__c ='Test miles2';
        miles2.MMPJ_TOPG_Project__c = project.id;
        miles2.MMPJ_TOPG_MMPJ_Status__c='Planned';
        insert miles2;
        
        Test.StartTest();
        MMPJ_TOPG_ManipulateMilestones.AlertMilestones();
        Test.StopTest();
    }
}