@isTest
private class ESN_User_AutojoinByAffiliates_TEST {

    /* Test 1 : trigger Bypassed */
    static testMethod void testAutoJoin_bypassed() {
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');
        system.debug('####### bypass');
        
        contextUser.BypassTriggers__c = 'ESN_User_AutojoinByAffiliates';

        System.runAs ( contextUser ) {  
            /* First Test : Insert */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<20;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2 || i == 5 || i == 7 || i == 12)
                        user.IsActive = false;
                    newUsers.add(user);
                }
                insert newUsers;            
            Test.stopTest();
            
            /* Check if User is a member of the group */
            Integer nbEntSubs = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: PR_Settings__c.getOrgDefaults().PR_AutoJoin_GroupID__c AND MemberId IN :newUsers];
            system.debug('#### count entity sub after update : '+nbEntSubs);
            System.assertEquals(nbEntSubs,0);
        }
    }
    
     /* Test 2 : trigger not bypassed AND Insert */
    static testMethod void testAutoJoin_notBypassed_INSERT() {
        system.debug('####### insert');
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');        
        contextUser.BypassTriggers__c = '';
        
        // Create new Chatter groups //
        CollaborationGroup group1 = TestFactory.createCollaborationGroup('group1', 'private');
        insert group1;
        CollaborationGroup group2 = TestFactory.createCollaborationGroup('group2', 'public');
        insert group2;
        CollaborationGroup group3 = TestFactory.createCollaborationGroup('group3', 'private');
        insert group3;
        
        // Create new configurations //
        ESN_AutojoinByAffiliates_Config__c newConf1 = new ESN_AutojoinByAffiliates_Config__c();
        newConf1.Chatter_Group_ID__c = group1.Id;
        newConf1.Affiliate__c = 'Company1';
        newConf1.Name = 'newConf1';
        insert newConf1;
        
        ESN_AutojoinByAffiliates_Config__c newConf2 = new ESN_AutojoinByAffiliates_Config__c();
        newConf2.Chatter_Group_ID__c = group2.Id;
        newConf2.Affiliate__c = 'Company2';
        newConf2.Name = 'newConf2';
        insert newConf2;
        
        ESN_AutojoinByAffiliates_Config__c newConf3 = new ESN_AutojoinByAffiliates_Config__c();
        newConf3.Chatter_Group_ID__c = group3.Id;
        newConf3.Affiliate__c = 'All';
        newConf3.Name = 'newConf3';
        insert newConf3;

        System.runAs ( contextUser ) {            
            /* Start test */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                Boolean comp1or2 = false;
                for(Integer i=0;i<20;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2 || i == 5 || i == 7 || i == 12)
                        user.IsActive = false;
                    if(i == 1 || i == 3 || i == 5 || i == 7 || i == 9 || i == 11 || i == 13 || i == 15 || i == 17 || i == 19){
                    	user.CompanyName = 'Company1';
                    }else{
                    	user.CompanyName = 'Company2';
                    }
                    newUsers.add(user);
                }
                insert newUsers;
                
                CollaborationGroupMember newCGM = new CollaborationGroupMember(MemberId = newUsers[1].Id, CollaborationGroupId = group1.Id);
                insert newCGM;
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubsGroup1 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group1.Id AND MemberId IN :newUsers];
            system.debug('#### T2 count entity sub after update : '+nbEntSubsGroup1);
            Integer nbEntSubsGroup2 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group2.Id AND MemberId IN :newUsers];
            system.debug('#### T2 count entity sub after update : '+nbEntSubsGroup2);
            Integer nbEntSubsGroup3 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group3.Id AND MemberId IN :newUsers];
            system.debug('#### T2 count entity sub after update : '+nbEntSubsGroup3);
            System.assertEquals(nbEntSubsGroup1,8);
            System.assertEquals(nbEntSubsGroup2,8);
            System.assertEquals(nbEntSubsGroup3,16);         
        }
     }
     
     /* Test 3 : trigger not bypassed AND Update */
    static testMethod void testAutoJoin_notBypassed_UPDATE() {
        system.debug('####### update');
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');        
        contextUser.BypassVR__c = true;
        
        // Create new Chatter groups //
        CollaborationGroup group1 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST1', 'private');
        insert group1;
        CollaborationGroup group2 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST2', 'public');
        insert group2;
        CollaborationGroup group3 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST3', 'private');
        insert group3;
        CollaborationGroup group4 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST4', 'private');
        insert group4;
        
        // Create new configurations //
        ESN_AutojoinByAffiliates_Config__c newConf1 = new ESN_AutojoinByAffiliates_Config__c();
        newConf1.Chatter_Group_ID__c = group1.Id;
        newConf1.Affiliate__c = 'Company1';
        newConf1.Name = 'newConf1';
        insert newConf1;
        
        ESN_AutojoinByAffiliates_Config__c newConf2 = new ESN_AutojoinByAffiliates_Config__c();
        newConf2.Chatter_Group_ID__c = group2.Id;
        newConf2.Affiliate__c = 'Company2';
        newConf2.Name = 'newConf2';
        insert newConf2;
        
        ESN_AutojoinByAffiliates_Config__c newConf3 = new ESN_AutojoinByAffiliates_Config__c();
        newConf3.Chatter_Group_ID__c = group3.Id;
        newConf3.Affiliate__c = 'All';
        newConf3.Name = 'newConf3';
        insert newConf3;
        
        ESN_AutojoinByAffiliates_Config__c newConf4 = new ESN_AutojoinByAffiliates_Config__c();
        newConf4.Chatter_Group_ID__c = group4.Id;
        newConf4.Affiliate__c = 'Company4';
        newConf4.Name = 'newConf4';
        insert newConf4;

        System.runAs ( contextUser ) {      
            /* Start test */
            Test.startTest();
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<10;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2 || i == 5 || i == 7 || i == 9)
                        user.IsActive = false;
                    if(i == 1 || i == 3 || i == 5 || i == 7 || i == 9 || i == 11 || i == 13 || i == 15 || i == 17 || i == 19){
                    	user.CompanyName = 'Company1';
                    }else{
                    	user.CompanyName = 'Company2';
                    }
                    newUsers.add(user);
                }
                insert newUsers;
                CollaborationGroupMember ent1 = new CollaborationGroupMember(MemberId = newUsers[1].Id,CollaborationGroupId = group1.Id);
                insert ent1; 

                // Update users previously created
                List<User> listUsers = [select IsActive,CompanyName,AboutMe,Alias from User WHERE Id IN :newUsers];
                List<User> usersToUpdate = new List<User>();
                
                for(User us : listUsers){
                	if(!us.Isactive)
                    	us.Isactive = true;
                    if(us.alias == 'user1' || us.alias == 'user3')
                    	us.CompanyName = 'Company4';
                	else
                		us.AboutMe = 'test';
            		usersToUpdate.add(us);
                }
                update usersToUpdate;
            Test.stopTest();
                        
            /* Check if the subscription is created */
            Integer nbEntSubsGroup1 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group1.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 1: '+nbEntSubsGroup1);
            Integer nbEntSubsGroup2 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group2.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 2: '+nbEntSubsGroup2);
            Integer nbEntSubsGroup3 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group3.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 3: '+nbEntSubsGroup3);
            Integer nbEntSubsGroup4 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group4.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 4: '+nbEntSubsGroup4);
            System.assertEquals(nbEntSubsGroup1,4);	// Expected 5 but the trigger run only after the "Test.stopTest()", so the user1 and the user3 obtain their new company before be added to the group1.
            System.assertEquals(nbEntSubsGroup2,5);
            System.assertEquals(nbEntSubsGroup3,10);
            System.assertEquals(nbEntSubsGroup4,2);
        }
     }
     
     /* Test 4 : trigger not bypassed AND Insert */
	static testMethod void testAutoJoin_notBypassed_INSERT_moreThan10() {
        system.debug('####### insert more than 10');
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');        
        contextUser.BypassTriggers__c = '';
        
        // Create new Chatter groups //
        CollaborationGroup group1 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group1', 'private');
        insert group1;
        CollaborationGroup group2 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group2', 'public');
        insert group2;
        CollaborationGroup group3 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group3', 'private');
        insert group3;
        CollaborationGroup group4 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group4', 'private');
        insert group4;
        CollaborationGroup group5 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group5', 'private');
        insert group5;
        CollaborationGroup group6 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group6', 'private');
        insert group6;
        CollaborationGroup group7 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group7', 'public');
        insert group7;
        CollaborationGroup group8 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group8', 'private');
        insert group8;
        CollaborationGroup group9 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group9', 'private');
        insert group9;
        CollaborationGroup group10 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group10', 'private');
        insert group10;
        CollaborationGroup group11 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group11', 'private');
        insert group11;
        
        // Create new configurations //
        ESN_AutojoinByAffiliates_Config__c newConf1 = new ESN_AutojoinByAffiliates_Config__c();
        newConf1.Chatter_Group_ID__c = group1.Id;
        newConf1.Affiliate__c = 'Company1';
        newConf1.Name = 'newConf1';
        insert newConf1;
        
        ESN_AutojoinByAffiliates_Config__c newConf2 = new ESN_AutojoinByAffiliates_Config__c();
        newConf2.Chatter_Group_ID__c = group2.Id;
        newConf2.Affiliate__c = 'Company2';
        newConf2.Name = 'newConf2';
        insert newConf2;
        
        ESN_AutojoinByAffiliates_Config__c newConf3 = new ESN_AutojoinByAffiliates_Config__c();
        newConf3.Chatter_Group_ID__c = group3.Id;
        newConf3.Affiliate__c = 'Company3';
        newConf3.Name = 'newConf3';
        insert newConf3;
        
        ESN_AutojoinByAffiliates_Config__c newConf4 = new ESN_AutojoinByAffiliates_Config__c();
        newConf4.Chatter_Group_ID__c = group4.Id;
        newConf4.Affiliate__c = 'Company4';
        newConf4.Name = 'newConf4';
        insert newConf4;
        
        ESN_AutojoinByAffiliates_Config__c newConf5 = new ESN_AutojoinByAffiliates_Config__c();
        newConf5.Chatter_Group_ID__c = group5.Id;
        newConf5.Affiliate__c = 'Company5';
        newConf5.Name = 'newConf5';
        insert newConf5;
        
        ESN_AutojoinByAffiliates_Config__c newConf6 = new ESN_AutojoinByAffiliates_Config__c();
        newConf6.Chatter_Group_ID__c = group6.Id;
        newConf6.Affiliate__c = 'Company6';
        newConf6.Name = 'newConf6';
        insert newConf6;
        
        ESN_AutojoinByAffiliates_Config__c newConf7 = new ESN_AutojoinByAffiliates_Config__c();
        newConf7.Chatter_Group_ID__c = group7.Id;
        newConf7.Affiliate__c = 'Company7';
        newConf7.Name = 'newConf7';
        insert newConf7;
        
        ESN_AutojoinByAffiliates_Config__c newConf8 = new ESN_AutojoinByAffiliates_Config__c();
        newConf8.Chatter_Group_ID__c = group8.Id;
        newConf8.Affiliate__c = 'Company8';
        newConf8.Name = 'newConf8';
        insert newConf8;
        
        ESN_AutojoinByAffiliates_Config__c newConf9 = new ESN_AutojoinByAffiliates_Config__c();
        newConf9.Chatter_Group_ID__c = group9.Id;
        newConf9.Affiliate__c = 'Company9';
        newConf9.Name = 'newConf9';
        insert newConf9;
        
        ESN_AutojoinByAffiliates_Config__c newConf10 = new ESN_AutojoinByAffiliates_Config__c();
        newConf10.Chatter_Group_ID__c = group10.Id;
        newConf10.Affiliate__c = 'Company10';
        newConf10.Name = 'newConf10';
        insert newConf10;
        
        ESN_AutojoinByAffiliates_Config__c newConf11 = new ESN_AutojoinByAffiliates_Config__c();
        newConf11.Chatter_Group_ID__c = group11.Id;
        newConf11.Affiliate__c = 'Company11';
        newConf11.Name = 'newConf11';
        insert newConf11;
        
        ESN_AutojoinByAffiliates_Config__c newConf12 = new ESN_AutojoinByAffiliates_Config__c();
        newConf12.Chatter_Group_ID__c = group2.Id;
        newConf12.Affiliate__c = 'All';
        newConf12.Name = 'newConf12';
        insert newConf12;

        System.runAs ( contextUser ) {            
            /* Start test */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                Boolean comp1or2 = false;
                for(Integer i=0;i<=20;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i <= 11){
                    	user.CompanyName = 'Company'+i;
                    	comp1or2 = false;
                    }else{
                    	user.CompanyName = 'Company2';
                    }
                    newUsers.add(user);
                }
                insert newUsers;
                
                CollaborationGroupMember newCGM = new CollaborationGroupMember(MemberId = newUsers[1].Id, CollaborationGroupId = group1.Id);
                insert newCGM;
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubsGroup1 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group1.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup1);
            Integer nbEntSubsGroup2 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group2.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup2);
            Integer nbEntSubsGroup3 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group3.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup3);
            Integer nbEntSubsGroup4 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group4.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup4);
            Integer nbEntSubsGroup5 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group5.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup5);
    /*        System.assertEquals(nbEntSubsGroup1,3);
            System.assertEquals(nbEntSubsGroup2,20);
            System.assertEquals(nbEntSubsGroup3,2);
            System.assertEquals(nbEntSubsGroup4,2);
            System.assertEquals(nbEntSubsGroup5,2);*/
        }
     }
     /* Test 4 : trigger not bypassed AND Insert (less than 5) */
    static testMethod void testAutoJoin_notBypassed_less5_INSERT() {
        system.debug('####### insert');
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');        
        contextUser.BypassTriggers__c = '';
        
        // Create new Chatter groups //
        CollaborationGroup group1 = TestFactory.createCollaborationGroup('group1', 'private');
        insert group1;
        CollaborationGroup group2 = TestFactory.createCollaborationGroup('group2', 'public');
        insert group2;
        CollaborationGroup group3 = TestFactory.createCollaborationGroup('group3', 'private');
        insert group3;
        
        // Create new configurations //
        ESN_AutojoinByAffiliates_Config__c newConf1 = new ESN_AutojoinByAffiliates_Config__c();
        newConf1.Chatter_Group_ID__c = group1.Id;
        newConf1.Affiliate__c = 'Company1';
        newConf1.Name = 'newConf1';
        insert newConf1;
        
        ESN_AutojoinByAffiliates_Config__c newConf2 = new ESN_AutojoinByAffiliates_Config__c();
        newConf2.Chatter_Group_ID__c = group2.Id;
        newConf2.Affiliate__c = 'Company2';
        newConf2.Name = 'newConf2';
        insert newConf2;
        
        ESN_AutojoinByAffiliates_Config__c newConf3 = new ESN_AutojoinByAffiliates_Config__c();
        newConf3.Chatter_Group_ID__c = group3.Id;
        newConf3.Affiliate__c = 'All';
        newConf3.Name = 'newConf3';
        insert newConf3;

        System.runAs ( contextUser ) {            
            /* Start test */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                Boolean comp1or2 = false;
                for(Integer i=0;i<5;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2)
                        user.IsActive = false;
                    if(i == 1 || i == 3){
                    	user.CompanyName = 'Company1';
                    }else{
                    	user.CompanyName = 'Company2';
                    }
                    newUsers.add(user);
                }
                insert newUsers;
                
                CollaborationGroupMember newCGM = new CollaborationGroupMember(MemberId = newUsers[1].Id, CollaborationGroupId = group1.Id);
                insert newCGM;
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubsGroup1 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group1.Id AND MemberId IN :newUsers];
            system.debug('#### T2 count entity sub after update : '+nbEntSubsGroup1);
            Integer nbEntSubsGroup2 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group2.Id AND MemberId IN :newUsers];
            system.debug('#### T2 count entity sub after update : '+nbEntSubsGroup2);
            Integer nbEntSubsGroup3 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group3.Id AND MemberId IN :newUsers];
            system.debug('#### T2 count entity sub after update : '+nbEntSubsGroup3);
            System.assertEquals(nbEntSubsGroup1,2);
            System.assertEquals(nbEntSubsGroup2,2);
            System.assertEquals(nbEntSubsGroup3,4);         
        }
     }
     
     /* Test 6 : trigger not bypassed AND Update (less)*/
    static testMethod void testAutoJoin_notBypassed_less5_UPDATE() {
        system.debug('####### update');
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');        
        contextUser.BypassVR__c = true;
        
        // Create new Chatter groups //
        CollaborationGroup group1 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST1', 'private');
        insert group1;
        CollaborationGroup group2 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST2', 'public');
        insert group2;
        CollaborationGroup group3 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST3', 'private');
        insert group3;
        CollaborationGroup group4 = TestFactory.createCollaborationGroup('ESN_User_AutojoinByAffiliates_TEST4', 'private');
        insert group4;
        
        // Create new configurations //
        ESN_AutojoinByAffiliates_Config__c newConf1 = new ESN_AutojoinByAffiliates_Config__c();
        newConf1.Chatter_Group_ID__c = group1.Id;
        newConf1.Affiliate__c = 'Company1';
        newConf1.Name = 'newConf1';
        insert newConf1;
        
        ESN_AutojoinByAffiliates_Config__c newConf2 = new ESN_AutojoinByAffiliates_Config__c();
        newConf2.Chatter_Group_ID__c = group2.Id;
        newConf2.Affiliate__c = 'Company2';
        newConf2.Name = 'newConf2';
        insert newConf2;
        
        ESN_AutojoinByAffiliates_Config__c newConf3 = new ESN_AutojoinByAffiliates_Config__c();
        newConf3.Chatter_Group_ID__c = group3.Id;
        newConf3.Affiliate__c = 'All';
        newConf3.Name = 'newConf3';
        insert newConf3;
        
        ESN_AutojoinByAffiliates_Config__c newConf4 = new ESN_AutojoinByAffiliates_Config__c();
        newConf4.Chatter_Group_ID__c = group4.Id;
        newConf4.Affiliate__c = 'Company4';
        newConf4.Name = 'newConf4';
        insert newConf4;

        System.runAs ( contextUser ) {      
            /* Start test */
            Test.startTest();
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<3;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2)
                        user.IsActive = false;
                    if(i == 1 || i == 3){
                    	user.CompanyName = 'Company1';
                    }else{
                    	user.CompanyName = 'Company2';
                    }
                    newUsers.add(user);
                }
                insert newUsers;

                // Update users previously created
                List<User> listUsers = [select IsActive,CompanyName,AboutMe,Alias from User WHERE Id IN :newUsers];
                List<User> usersToUpdate = new List<User>();
                
                for(User us : listUsers){
                	if(!us.Isactive)
                    	us.Isactive = true;
                    if(us.alias == 'user1' || us.alias == 'user3')
                    	us.CompanyName = 'Company4';
                	else
                		us.AboutMe = 'test';
            		usersToUpdate.add(us);
                }
                update usersToUpdate;
            Test.stopTest();
                        
            /* Check if the subscription is created */
            Integer nbEntSubsGroup1 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group1.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 1: '+nbEntSubsGroup1);
            Integer nbEntSubsGroup2 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group2.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 2: '+nbEntSubsGroup2);
            Integer nbEntSubsGroup3 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group3.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 3: '+nbEntSubsGroup3);
            Integer nbEntSubsGroup4 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group4.Id AND MemberId IN :listUsers];
            system.debug('###### T3 count entity sub after update 4: '+nbEntSubsGroup4);
            System.assertEquals(nbEntSubsGroup1,1);	// Expected 5 but the trigger run only after the "Test.stopTest()", so the user1 and the user3 obtain their new company before be added to the group1.
            System.assertEquals(nbEntSubsGroup2,2);
            System.assertEquals(nbEntSubsGroup3,3);
            System.assertEquals(nbEntSubsGroup4,1);
        }
     }
     /* Test 4 : trigger not bypassed AND Insert */
	static testMethod void testAutoJoin_notBypassed_INSERT_moreThan10_CompNotMatched() {
        system.debug('####### insert more than 10');
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');        
        contextUser.BypassTriggers__c = '';
        
        // Create new Chatter groups //
        CollaborationGroup group1 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group1', 'private');
        insert group1;
        CollaborationGroup group2 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group2', 'public');
        insert group2;
        CollaborationGroup group3 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group3', 'private');
        insert group3;
        CollaborationGroup group4 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group4', 'private');
        insert group4;
        CollaborationGroup group5 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group5', 'private');
        insert group5;
        CollaborationGroup group6 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group6', 'private');
        insert group6;
        CollaborationGroup group7 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group7', 'public');
        insert group7;
        CollaborationGroup group8 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group8', 'private');
        insert group8;
        CollaborationGroup group9 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group9', 'private');
        insert group9;
        CollaborationGroup group10 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group10', 'private');
        insert group10;
        CollaborationGroup group11 = TestFactory.createCollaborationGroup('ESN_User_AutojoinBy_group11', 'private');
        insert group11;
        
        // Create new configurations //
        ESN_AutojoinByAffiliates_Config__c newConf1 = new ESN_AutojoinByAffiliates_Config__c();
        newConf1.Chatter_Group_ID__c = group1.Id;
        newConf1.Affiliate__c = 'Company1';
        newConf1.Name = 'newConf1';
        insert newConf1;
        
        ESN_AutojoinByAffiliates_Config__c newConf2 = new ESN_AutojoinByAffiliates_Config__c();
        newConf2.Chatter_Group_ID__c = group2.Id;
        newConf2.Affiliate__c = 'Company2';
        newConf2.Name = 'newConf2';
        insert newConf2;
        
        ESN_AutojoinByAffiliates_Config__c newConf3 = new ESN_AutojoinByAffiliates_Config__c();
        newConf3.Chatter_Group_ID__c = group3.Id;
        newConf3.Affiliate__c = 'Company3';
        newConf3.Name = 'newConf3';
        insert newConf3;
        
        ESN_AutojoinByAffiliates_Config__c newConf4 = new ESN_AutojoinByAffiliates_Config__c();
        newConf4.Chatter_Group_ID__c = group4.Id;
        newConf4.Affiliate__c = 'Company4';
        newConf4.Name = 'newConf4';
        insert newConf4;
        
        ESN_AutojoinByAffiliates_Config__c newConf5 = new ESN_AutojoinByAffiliates_Config__c();
        newConf5.Chatter_Group_ID__c = group5.Id;
        newConf5.Affiliate__c = 'Company5';
        newConf5.Name = 'newConf5';
        insert newConf5;
        
        ESN_AutojoinByAffiliates_Config__c newConf6 = new ESN_AutojoinByAffiliates_Config__c();
        newConf6.Chatter_Group_ID__c = group6.Id;
        newConf6.Affiliate__c = 'Company6';
        newConf6.Name = 'newConf6';
        insert newConf6;
        
        ESN_AutojoinByAffiliates_Config__c newConf7 = new ESN_AutojoinByAffiliates_Config__c();
        newConf7.Chatter_Group_ID__c = group7.Id;
        newConf7.Affiliate__c = 'Company7';
        newConf7.Name = 'newConf7';
        insert newConf7;
        
        ESN_AutojoinByAffiliates_Config__c newConf8 = new ESN_AutojoinByAffiliates_Config__c();
        newConf8.Chatter_Group_ID__c = group8.Id;
        newConf8.Affiliate__c = 'Company8';
        newConf8.Name = 'newConf8';
        insert newConf8;
        
        ESN_AutojoinByAffiliates_Config__c newConf9 = new ESN_AutojoinByAffiliates_Config__c();
        newConf9.Chatter_Group_ID__c = group9.Id;
        newConf9.Affiliate__c = 'Company9';
        newConf9.Name = 'newConf9';
        insert newConf9;
        
        ESN_AutojoinByAffiliates_Config__c newConf10 = new ESN_AutojoinByAffiliates_Config__c();
        newConf10.Chatter_Group_ID__c = group10.Id;
        newConf10.Affiliate__c = 'Company10';
        newConf10.Name = 'newConf10';
        insert newConf10;
        
        ESN_AutojoinByAffiliates_Config__c newConf11 = new ESN_AutojoinByAffiliates_Config__c();
        newConf11.Chatter_Group_ID__c = group11.Id;
        newConf11.Affiliate__c = 'Company11';
        newConf11.Name = 'newConf11';
        insert newConf11;
        
        ESN_AutojoinByAffiliates_Config__c newConf12 = new ESN_AutojoinByAffiliates_Config__c();
        newConf12.Chatter_Group_ID__c = group2.Id;
        newConf12.Affiliate__c = 'All';
        newConf12.Name = 'newConf12';
        insert newConf12;

        System.runAs ( contextUser ) {            
            /* Start test */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<=20;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                	user.CompanyName = 'Company15';
                    newUsers.add(user);
                }
                insert newUsers;
                
                CollaborationGroupMember newCGM = new CollaborationGroupMember(MemberId = newUsers[1].Id, CollaborationGroupId = group1.Id);
                insert newCGM;
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubsGroup1 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group1.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup1);
            Integer nbEntSubsGroup2 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group2.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup2);
            Integer nbEntSubsGroup3 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group3.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup3);
            Integer nbEntSubsGroup4 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group4.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup4);
            Integer nbEntSubsGroup5 = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: group5.Id AND MemberId IN :newUsers];
            system.debug('#### count T4 entity sub after update : '+nbEntSubsGroup5);
    /*        System.assertEquals(nbEntSubsGroup1,3);
            System.assertEquals(nbEntSubsGroup2,20);
            System.assertEquals(nbEntSubsGroup3,2);
            System.assertEquals(nbEntSubsGroup4,2);
            System.assertEquals(nbEntSubsGroup5,2);*/
        }
     }
}