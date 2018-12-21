@isTest
private class ASI_DFPM_AttachmentTriggerTest {

    static testMethod void test_ASI_DFPM_AttachParentIndicatorHandler() {
        ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
        ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
        ASI_DFPM_PromotionalTaskGenerator taskGen = new ASI_DFPM_PromotionalTaskGenerator();
        
        ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard);
        insert testPj;
        ASI_DFPM_Project_Milestone__c testMst = mstGen.generateMilestone(testPj);
        insert testMst;
        ASI_DFPM_Project_Task__c testTask = taskGen.generateTask(testMst, ASI_DFPM_PromotionalTaskGenerator.RT_Standard);
        insert testTask;
        
        Test.startTest();
        
        testTask = [SELECT Id, ASI_DFPM_Has_Attachment__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(false, testTask.ASI_DFPM_Has_Attachment__c);
        Attachment attach = new Attachment(
            Name = 'Test'
            , ParentId = testTask.Id
            , Body = Blob.toPdf('Test')
        );
        insert attach;
        testTask = [SELECT Id, ASI_DFPM_Has_Attachment__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(true, testTask.ASI_DFPM_Has_Attachment__c);
        
        attach = [SELECT Id, Name FROM Attachment WHERE Id = :attach.Id];
        attach.Name = 'Test 2';
        update attach;
        testTask = [SELECT Id, ASI_DFPM_Has_Attachment__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(true, testTask.ASI_DFPM_Has_Attachment__c);
        
        delete attach;
        testTask = [SELECT Id, ASI_DFPM_Has_Attachment__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(false, testTask.ASI_DFPM_Has_Attachment__c);
        
        undelete attach;
        testTask = [SELECT Id, ASI_DFPM_Has_Attachment__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(true, testTask.ASI_DFPM_Has_Attachment__c);
        
        Test.stopTest();
    }
}