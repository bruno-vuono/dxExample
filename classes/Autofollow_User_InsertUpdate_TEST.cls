@isTest(seeAllData=true)
private class Autofollow_User_InsertUpdate_TEST {

    /* Test 1 : trigger Bypassed */
    static testMethod void testAutoFollow_bypassed() {
        System.debug('#### test Autofollow bypassed BEGIN');
        
        /* Create the context User */
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');     
        contextUser.BypassTriggers__c = 'Autofollow_User_InsertUpdate';
        insert contextUser;

        System.runAs ( contextUser ) {  
            /* Create a user to follow */
            User userFollow = TestFactory.createStandardUser('follow1');
            userFollow.IsActive = true;
            userFollow.Autofollow__c = true;
            insert userFollow;
            System.debug('#### test Autofollow bypassed : Creation userFollow '+userFollow.Id);
            
            /* First Test : Insert */
            Test.startTest();
            
            // Create a list of users to insert
            List<User> newUsers = new List<User>();
            
            for(Integer i=0;i<5;i++){
                User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                user.IsActive = true;
                if(i == 2 || i == 3 )
                    user.IsActive = false;
                newUsers.add(user);
            }
            insert newUsers;
            
            // Used for debug
            String debug ='';
            for(User item : newUsers){
                debug += item.Id + ' ';
            }
            System.debug('#### test Autofollow bypassed : Creation users '+debug);
            
            Test.stopTest();
            
            /* Check if subscriptions are created */
            Integer nbEntSubs = [SELECT count() FROM EntitySubscription WHERE ParentId = :userFollow.Id AND SubscriberId != :contextUser.Id];
            system.debug('#### count entity sub after update : '+nbEntSubs);
            System.assertEquals(nbEntSubs,0);
        }
        System.debug('#### test Autofollow bypassed END');
    }
     
     /* Test 2 : trigger not bypassed AND Insert */
    static testMethod void testAutoFollow_notBypassed_INSERT() {
        System.debug('#### test Autofollow notbypassed Ins BEGIN');
        
        /* Create the context User */
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');     
        contextUser.BypassTriggers__c = '';
        insert contextUser;

        System.runAs ( contextUser ) {  
            /* Create a user to follow */
            User userFollow = TestFactory.createStandardUser('follow1');
            userFollow.IsActive = true;
            userFollow.Autofollow__c = true;
            insert userFollow;
        System.debug('#### test Autofollow notbypassed Ins : Creation userFollow '+userFollow.Id);
            
            /* Start test */
            Test.startTest();
            
            // Create a list of users to insert
            List<User> newUsers = new List<User>();
            
            for(Integer i=0;i<5;i++){
                User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                user.IsActive = true;
                if(i == 2 || i == 3)
                    user.IsActive = false;
                newUsers.add(user);
            }
            insert newUsers;
            
            // Used for debug
            String debug ='';
            for(User item : newUsers){
                debug += item.Id + ' ';
            }
            System.debug('#### test Autofollow notbypassed Ins : Creation users '+debug);
            
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubs = [SELECT count() FROM EntitySubscription WHERE ParentId = :userFollow.Id AND SubscriberId != :contextUser.Id];
            system.debug('#### count entity sub after update : '+nbEntSubs);
            System.assertEquals(nbEntSubs,3);          
        }
        System.debug('#### test Autofollow notbypassed Ins END');
     }
     
     /* Test 2 : trigger not bypassed */
    static testMethod void testAutoFollow_notBypassed_UPDATE() {
        System.debug('#### test Autofollow notbypassed maj BEGIN');

        /* Create the context User */
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');     
        contextUser.BypassTriggers__c = '';
        insert contextUser;

        System.runAs ( contextUser ) {  
            /* Create a user to follow */
            User userFollow = TestFactory.createStandardUser('follow1');
            userFollow.IsActive = true;
            userFollow.Autofollow__c = true;
            insert userFollow;
            System.debug('#### test Autofollow notbypassed maj : Creation userFollow '+userFollow.Id);
            
            /* First Test : Insert */
            Test.startTest();
   
            // release Licences Chatter only (5 Users).
            List<User> LicenseUsers = [select IsActive from User where IsActive = true and  ProfileId = '00eD0000001AjXDIA0' limit 5];
            for(User Lic : LicenseUsers){
                Lic.Isactive = false;
            }        
            update LicenseUsers;
          
            // Create a list of users to insert
            List<User> newUsers = new List<User>();
            
            for(Integer i=0;i<5;i++){
                User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                user.IsActive = true;
                if(i == 2 || i == 3)
                    user.IsActive = false;
                newUsers.add(user);
            }
            insert newUsers;
            
            // Used for debug
            String debug ='';
            for(User item : newUsers){
                debug += item.Id + ' ';
            }
            System.debug('#### test Autofollow notbypassed maj : Creation users '+debug);
            
            // Update users previously created
            List<User> updateUsers = [select IsActive from User where alias = 'user2' OR alias = 'user3'];
            for(User us : updateUsers){
                us.Isactive = True;
            }        
            update updateUsers;
            
            // Used for debug
            debug ='';
            for(User item : updateUsers){
                debug += item + ' ';
            }
            System.debug('#### test Autofollow notbypassed maj : update users '+debug);
            
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubs = [SELECT count() FROM EntitySubscription WHERE ParentId = :userFollow.Id AND SubscriberId != :contextUser.Id];
            system.debug('#### count entity sub after update : '+nbEntSubs);
            System.assertEquals(nbEntSubs,5);
        }
        System.debug('#### test Autofollow notbypassed maj END');
     }
}