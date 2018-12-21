// Le Cercle application - evolution LCS-11 - January 2017
// Test class for batch that create Competitor and Le Cercle brands linked to collects
@isTest(SeeAllData = false) 
private class PRH_BatchBrandCreationForCollectsTest {
	
	@testSetup static void setUpData() {
        List<PRH_Luxury_Accounts__c> iconicAccounts = new List<PRH_Luxury_Accounts__c>();
        PRH_Luxury_Accounts__c acc;
		DateTime dt = DateTime.now(); 
		String dateTimeStr = dt.format('YYMMDD_hhmmss'); 
		List<PRH_Collect__c> listOfNewCollects = new List<PRH_Collect__c >();
		Profile adminp = [select id from profile where Name = 'System Administrator' limit 1];    
        System.debug('dateTimeStr : '+ dateTimeStr);
        
        // Creation of 5 users (iconic account's owners)
        Profile p = [SELECT Id FROM Profile WHERE Name='PRH_Iconic_Platform']; 
        User u1 = new User(Alias = 'user1', Email='PRH_testuser1'+dateTimeStr+'@prhtestorg.com', 
            EmailEncodingKey='UTF-8', LastName='TestingUser1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='PRH_testuser1'+dateTimeStr+'@prhtestorg.com');
        insert u1;
        User u2 = new User(Alias = 'user2', Email='PRH_testuser2'+dateTimeStr+'@prhtestorg.com', 
            EmailEncodingKey='UTF-8', LastName='TestingUser2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='PRH_testuser2'+dateTimeStr+'@prhtestorg.com');
        insert u2;
        User u3 = new User(Alias = 'user3', Email='PRH_testuser3'+dateTimeStr+'@prhtestorg.com', 
            EmailEncodingKey='UTF-8', LastName='TestingUser3', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='PRH_testuser3'+dateTimeStr+'@prhtestorg.com');
        insert u3;

		User user1 = [SELECT Name, Id FROM User WHERE (UserName LIKE 'PRH_testuser1%') LIMIT 1];
		User user2 = [SELECT Name, Id FROM User WHERE (UserName LIKE 'PRH_testuser2%') LIMIT 1];
		User user3 = [SELECT Name, Id FROM User WHERE (UserName LIKE 'PRH_testuser3%') LIMIT 1];

		System.debug('==> user1.Id : '+ user1.Id);
		System.debug('==> user2.Id : '+ user2.Id);
		System.debug('==> user3.Id : '+ user3.Id);
		        
		User ic_myUser = [SELECT Id FROM User WHERE Email LIKE 'PRH_testuser3%prhtestorg.com' LIMIT 1];
        System.runAs(ic_myUser) { 
            
            // Creation of some Iconic Brands		
			PRH_Brand_Luxury_Brand__c ib1 = new PRH_Brand_Luxury_Brand__c();
            ib1.Name = 'Martell XO';
			ib1.PRH_Competitor_Brand__c = false;
			ib1.PRH_Sequence__c = 'LCEB0001';
			ib1.PRH_PIM_ID__c = 'PIM001';
			ib1.PRH_Active__c = true;
            ib1.recordTypeId = Schema.SObjectType.PRH_Brand_Luxury_Brand__c.getRecordTypeInfosByName().get('Luxury Account - Pernod').getRecordTypeId();
            insert ib1;
			
			PRH_Brand_Luxury_Brand__c ib2 = new PRH_Brand_Luxury_Brand__c();
            ib2.Name = 'PJ Belle Epoque and above';
			ib2.PRH_Competitor_Brand__c = false;
			ib2.PRH_Sequence__c = 'LCEB0002';
			ib2.PRH_PIM_ID__c = 'PIM002';
			ib2.PRH_Active__c = true;
            ib2.recordTypeId = Schema.SObjectType.PRH_Brand_Luxury_Brand__c.getRecordTypeInfosByName().get('Luxury Account - Pernod').getRecordTypeId();
            insert ib2;
			
			PRH_Brand_Luxury_Brand__c ib3 = new PRH_Brand_Luxury_Brand__c();
            ib3.Name = 'Dom Perignon';
			ib3.PRH_Competitor_Brand__c = true;
			ib3.PRH_Sequence__c = 'COMP0001';
			ib3.PRH_PIM_ID__c = 'PIMC001';
			ib3.PRH_Active__c = true;
            ib3.recordTypeId = Schema.SObjectType.PRH_Brand_Luxury_Brand__c.getRecordTypeInfosByName().get('Luxury Account - Competitor').getRecordTypeId();
            insert ib3;
            
			// Creation of the Iconic Accounts
			for (Integer i=0; i < 6; i++) { 
				if (i < 3) {
					acc = new PRH_Luxury_Accounts__c(
						Name = 'Fraccount-'+i,
                        PRH_High_Networth_Individuals__c = false,
						PRH_Suppress_and_archive__c = false,
						PRH_Account_Region__c = 'PR LATAM'
					);
					iconicAccounts.add(acc); 
				} else {
					acc = new PRH_Luxury_Accounts__c(
						Name = 'Zoo-'+i,
						PRH_High_Networth_Individuals__c = false,
						PRH_Suppress_and_archive__c = false
						//PRH_Number_of_Pernod_Ricard_products__c = 1
					);
					iconicAccounts.add(acc); 
				}
			}	
			insert iconicAccounts;
			
			PRH_Luxury_Accounts__c accountToUpdate; 
            try {         
                // Update account 
                accountToUpdate =  
                    [SELECT Name, Id FROM PRH_Luxury_Accounts__c WHERE (Name LIKE 'Fraccount-2%') LIMIT 1]; 
                // Update the owner and owner2
                accountToUpdate.OwnerId = user1.Id;
                accountToUpdate.PRH_Owner_2__c = user2.Id;
                // Make the update call
                update accountToUpdate; 
				
				// Update account 
                accountToUpdate =  
                    [SELECT Name, Id FROM PRH_Luxury_Accounts__c WHERE (Name LIKE 'Zoo-5%') LIMIT 1]; 
                // Update the owner and owner2
                accountToUpdate.OwnerId = user1.Id;
                accountToUpdate.PRH_Owner_2__c = user2.Id;
                // Make the update call
                update accountToUpdate; 
            } catch(DmlException e) { 
                System.debug('An unexpected error has occurred: ' + e.getMessage());  
            }		
		}
    }
    
	@isTest static void Test_PRH_BatchBrandCreationForCollects() {
        
        User ic_myUser = [SELECT Id FROM User WHERE Email LIKE 'PRH_testuser3%prhtestorg.com' LIMIT 1];
		System.debug('==> Test_PRH_BatchBrandCreationForCollects() ic_myUser : '+ ic_myUser);
		
        System.runAs(ic_myUser) {         	
			System.Test.startTest(); 
			
            List<PRH_Competitor_Brands__c> newCompetitorBrandsListbefore = [SELECT Id, Name FROM PRH_Competitor_Brands__c];
            System.debug('==> newCompetitorBrandsListbefore : '+ newCompetitorBrandsListbefore);
			System.assertEquals(6,newCompetitorBrandsListbefore.size());
            
            PRH_ManageCollectsForIconicAcc action = new PRH_ManageCollectsForIconicAcc();
            action.ManageCreationOfCollectsForIconicAcc();
            
			Database.executeBatch(new PRH_BatchBrandCreationForCollects());
			
			System.Test.stopTest(); 
			
            List<PRH_Collect__c> listActiveColl = [Select id From PRH_Collect__c Where PRH_Active__c=true ];
            System.debug('==> listActiveColl.size() : '+ listActiveColl.size());
            
			List<PRH_Competitor_Brands__c> newCompetitorBrandsList = [SELECT Id, Name FROM PRH_Competitor_Brands__c where PRH_Collect__c In :listActiveColl ];
            System.debug('==> newCompetitorBrandsList : '+ newCompetitorBrandsList);
			System.assertEquals(6,newCompetitorBrandsList.size());

			List<PRH_Brand_Criteria__c> newLeCercleBrandsList = [SELECT Id, Name FROM PRH_Brand_Criteria__c  where PRH_Collect__c In :listActiveColl];
			System.assertEquals(newLeCercleBrandsList.size(),12);
		}   	
    }
    
    @isTest static void Test_PRH_ScheduleBatchBrandsCreationForCollects() {
        
        User ic_myUser = [SELECT Id FROM User WHERE Email LIKE 'PRH_testuser1%prhtestorg.com' LIMIT 1];
		System.debug('==> Test_PRH_ScheduleBatchBrandsCreationForCollects() ic_myUser : '+ ic_myUser);
		
        System.runAs(ic_myUser) {         	
			System.Test.startTest(); 
			
			String CRON_EXP = '0 0 0 2 3 ? 2098';
			String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PRH_ScheduleBatchBRCreationForCollects()); 
			
			CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

			System.assertEquals(CRON_EXP, ct.CronExpression); 
			System.assertEquals(0, ct.TimesTriggered);
			
			System.Test.stopTest(); 
		}   	
    }
}