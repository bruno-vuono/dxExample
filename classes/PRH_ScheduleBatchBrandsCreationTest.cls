// Le Cercle application - evolution LCS-11 - January 2017
// Test class for scheduler that launch batch of creation of Le Cercle Brand et Competitor brands
@isTest(SeeAllData = false) 
private class PRH_ScheduleBatchBrandsCreationTest {
	
	@testSetup static void setUpData() {
        List<PRH_Luxury_Accounts__c> iconicAccounts = new List<PRH_Luxury_Accounts__c>();
        PRH_Luxury_Accounts__c acc;
		DateTime dt = DateTime.now(); 
		String dateTimeStr = dt.format('YYMMDD_hhmmss'); 
		Profile adminp = [select id from profile where Name = 'System Administrator' limit 1];    
        System.debug('dateTimeStr : '+ dateTimeStr);
        
        // Creation of 1 user (iconic account's owners)
        Profile p = [SELECT Id FROM Profile WHERE Name='PRH_Iconic_Platform']; 
        User u1 = new User(Alias = 'user1', Email='PRH_testuser1'+dateTimeStr+'@prhtestorg.com', 
            EmailEncodingKey='UTF-8', LastName='TestingUser1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='PRH_testuser1'+dateTimeStr+'@prhtestorg.com');
        insert u1;
		        
		User ic_myUser = [SELECT Id FROM User WHERE Email LIKE 'PRH_testuser1%prhtestorg.com' LIMIT 1];
    }
    
	@isTest static void Test_PRH_ScheduleBatchBRCreationForCollects() {
        
        User ic_myUser = [SELECT Id FROM User WHERE Email LIKE 'PRH_testuser1%prhtestorg.com' LIMIT 1];
		System.debug('==> Test_PRH_ScheduleBatchBRCreationForCollects() ic_myUser : '+ ic_myUser);
		
        System.runAs(ic_myUser) {         	
			System.Test.startTest(); 
			
			String CRON_EXP = '0 0 0 2 3 ? 2097';
			String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PRH_ManageCollectsForIconicAcc()); 
			
			CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

			System.assertEquals(CRON_EXP, ct.CronExpression); 
			System.assertEquals(0, ct.TimesTriggered);

			// Verify the next time the job will run 
			System.assertEquals('2097-03-02 00:00:00', String.valueOf(ct.NextFireTime)); 

			// Verify the scheduled job hasn't run yet
			PRH_Collect__c[] collects = [SELECT Id, Name FROM PRH_Collect__c]; 
			System.assertEquals(collects.size(),0); 
			
			System.Test.stopTest(); 
		}   	
    }
}