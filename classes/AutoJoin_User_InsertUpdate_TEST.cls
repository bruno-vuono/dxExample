@isTest(seeAllData=true)
private class AutoJoin_User_InsertUpdate_TEST { 
    /* Test 1 : trigger Bypassed */
    static testMethod void testAutoJoin_bypassed() {
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');
        
        contextUser.BypassTriggers__c = 'AutoJoin_User_InsertUpdate';

        System.runAs ( contextUser ) {  
            /* First Test : Insert */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<20;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2 || i == 6 || i == 8 || i == 12)
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
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');
        
        contextUser.BypassTriggers__c = '';

        System.runAs ( contextUser ) {  
            
            /* Start test */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<20;i++){
                    User user = TestFactory.createUserWithProfile('AFuser'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2 || i == 6 || i == 8 || i == 12)
                        user.IsActive = false;
                    newUsers.add(user);
                }
                insert newUsers;
                CollaborationGroupMember ent1 = new CollaborationGroupMember(MemberId = newUsers[1].Id,CollaborationGroupId = PR_Settings__c.getOrgDefaults().PR_AutoJoin_GroupID__c);
                insert ent1;         
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubs = [SELECT count() FROM CollaborationGroupMember WHERE MemberId IN :newUsers];
            system.debug('#### count entity sub after update : '+nbEntSubs);
            System.assertEquals(nbEntSubs,16);    
        }
     }
     
     /* Test 2 : trigger not bypassed */
    static testMethod void testAutoJoin_notBypassed_UPDATE() {
        User contextUser = TestFactory.createUserWithProfile('context','System Administrator');
        
        contextUser.BypassTriggers__c = '';

        System.runAs ( contextUser ) {  
            /* First Test : Insert */
            Test.startTest();           
                // Create a list of users to insert
                List<User> newUsers = new List<User>();
                
                for(Integer i=0;i<20;i++){
                    User user = TestFactory.createUserWithProfile('user'+i, 'Chatter Only User');
                    user.IsActive = true;
                    if(i == 2 || i == 6 || i == 8 || i == 12)
                        user.IsActive = false;
                    newUsers.add(user);
                }
                insert newUsers;
                
                // Update users previously created
                List<User> updateUsers = [select IsActive from User where alias = 'user2' OR alias = 'user6' OR alias = 'user8' OR alias = 'user12'];
                for(User us : updateUsers){
                    us.Isactive = True;
                }        
                update updateUsers;         
            Test.stopTest();
            
            /* Check if the subscription is created */
            Integer nbEntSubs = [SELECT count() FROM CollaborationGroupMember WHERE CollaborationGroupId =: PR_Settings__c.getOrgDefaults().PR_AutoJoin_GroupID__c AND MemberId IN :newUsers];
            system.debug('#### count entity sub after update : '+nbEntSubs);
            System.assertEquals(nbEntSubs,20);
        }
     } 
}