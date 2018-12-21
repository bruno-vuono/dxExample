@isTest
private class RIC_WeeklyTaskEmail_Test
{
    static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest
    private static void testScheduledJob() {
        Test.startTest();

        RIC_WeeklyTaskEmail wte = new RIC_WeeklyTaskEmail();

        String jobId = System.schedule('ScheduleTest', CRON_EXP, wte);

        CronTrigger ct = [Select ID, CronExpression, TimesTriggered, NextFireTime
                          From CronTrigger where id = :jobId];

        //System.assertEquals(CRON_EXP,ct.CronExpression);

        //System.assertEquals(0, ct.TimesTriggered);

        //System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));

        Test.stopTest();

    }

    //MBAZ : Refactor and remove See All Data token
    @isTest
    private static void testEmailSent(){
        //Start tests
        Test.startTest();

        RIC_WeeklyTaskEmail wte = new RIC_WeeklyTaskEmail();
        Integer emailCtr = Limits.getEmailInvocations();
        Iterator<SObject> iterId = (wte.start(null)).iterator();
        //at least one user
       // System.assert(iterId.hasNext());
        //convert Iter to Int
        List<SObject> intId = new List<SObject>();
        while(iterId.hasNext()){
            intId.add(iterId.next());
        }
        //exec
        wte.execute(null, intId);
        //fin
        wte.finish(null);
        Test.stopTest();
    }

    //MBAZ : Refactor test initialization
    @IsTest
    private static void testBatch(){
        RIC_WeeklyTaskEmail wte = new RIC_WeeklyTaskEmail();
        Test.startTest();

        Iterator<SObject> iterId = (wte.start(null)).iterator();
        
        //no users
        //System.assert(iterId.hasNext());
        // List<Id> uIds = new List<Id>();
        
        // for (Id uid : uIds){
        //     uIds.add(uid);
        // }

        Integer emailCtr = Limits.getEmailInvocations();
        Database.executeBatch(wte);
        // wte.execute(null, uIds);
        Test.stopTest();
        // System.assertEquals(emailCtr + RIC_WeeklyTaskEmail.EMAIL_CNT, Limits.getEmailInvocations());
    }

    //MBAZ : Create generic init for tests
    @TestSetup
    private static void initializeTasks(){
        //MBAZ init some datas
        Profile p = [SELECT Id FROM Profile WHERE Name='RIC_Workflow Plann\'R'];

        //prepare Users
        List<User> users = new List<User>();
        for(Integer i = 0; i < RIC_WeeklyTaskEmail.EMAIL_CNT; i++){
            users.add(new User(Alias = 'user'+i, Email='user'+i+'@email.com',
                EmailEncodingKey='UTF-8', LastName='User'+i, LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='user'+i+'@email.com.DS78gOUds'
            ));
        }
        insert users ;

        //Use Run As Hack for allowing DML after user insertion
        User currUser =  [SELECT ID, ProfileId, UserRoleId FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
        System.runAs(currUser){
            //Project
            Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProjectActive('EmailTest');
            insert proj;

            //Millestone
            Milestone1_Milestone__c mil = Milestone1_Test_Utility.sampleMilestone(proj);
            insert mil;

            //Tasks
            List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
            for (Integer i = 0; i < RIC_WeeklyTaskEmail.EMAIL_CNT; i++){
                Milestone1_Task__c task = Milestone1_Test_Utility.sampleTask(mil);
                task.Due_Date__c = Date.Today().addDays(-5);
                task.Assigned_To__c = users.get(i).Id;
                task.RIC_Status__c = 'En Cours';
                tasks.add(task);
            }
            insert tasks;
        }
    }
}

/*@isTest (SeeAllData = True)
    private class RIC_WeeklyTaskEmail_Test
    {

        public static String CRON_EXP = '0 0 0 15 3 ? 2022';

        static testMethod void testScheduledJob() {
        Test.startTest();

            String jobId = System.schedule('ScheduleTest',
                                           CRON_EXP,
                                           new RIC_WeeklyTaskEmail());

            CronTrigger ct = [Select ID, CronExpression, TimesTriggered, NextFireTime
                             From CronTrigger where id = :jobId];

            System.assertEquals(CRON_EXP,ct.CronExpression);

            System.assertEquals(0, ct.TimesTriggered);

            System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));

            Test.stopTest();

    }

    }
*/