@isTest
private class ASI_DFPM_PromotionalTaskTriggerTest {

    static testMethod void test_ASI_DFPM_PromotionalTaskParentSummaryUP() {
        final Integer numOfTestMst = 5;
        final Integer numOfTestTasksPerMst = 4;
        
        ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
        ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
        ASI_DFPM_PromotionalTaskGenerator taskGen = new ASI_DFPM_PromotionalTaskGenerator();
        
        ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testPj;
        List<ASI_DFPM_Project_Milestone__c> testMstList = mstGen.generateMilestonesInSequence(testPj, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testMstList;
        List<ASI_DFPM_Project_Task__c> testTaskList = taskGen.generateTasksInSequence(testMstList, ASI_DFPM_PromotionalTaskGenerator.RT_Standard, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testTaskList;
        
        Test.startTest();
        
        ASI_DFPM_Project_Milestone__c testMst;
        
        // Check summaries
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst * numOfTestTasksPerMst, testPj.ASI_DFPM_Total_Task__c);
        System.assertEquals(0, testPj.ASI_DFPM_Total_Complete_Task__c);
        testMst = getMstForSummary(testMstList.get(0).Id);
        System.assertEquals(numOfTestTasksPerMst, testMst.ASI_DFPM_Total_Task__c);
        System.assertEquals(0, testPj.ASI_DFPM_Total_Complete_Task__c);
        
        // Update tasks
        List<ASI_DFPM_Project_Task__c> updateTaskList = new List<ASI_DFPM_Project_Task__c>();
        markCompleteAndAddToList(testTaskList.get(0), true, updateTaskList);
        markCompleteAndAddToList(testTaskList.get(1), true, updateTaskList);
        markCompleteAndAddToList(testTaskList.get(numOfTestTasksPerMst), true, updateTaskList);
        markCompleteAndAddToList(testTaskList.get(numOfTestTasksPerMst + 1), true, updateTaskList);
        update updateTaskList;
        
        // Check summaries after updating tasks
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst * numOfTestTasksPerMst, testPj.ASI_DFPM_Total_Task__c);
        System.assertEquals(4, testPj.ASI_DFPM_Total_Complete_Task__c);
        testMst = getMstForSummary(testMstList.get(0).Id);
        System.assertEquals(numOfTestTasksPerMst, testMst.ASI_DFPM_Total_Task__c);
        System.assertEquals(2, testMst.ASI_DFPM_Total_Complete_Task__c);
        update updateTaskList;
        
        delete testTaskList.get(0);
        
        // Check summaries after updating tasks
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst * numOfTestTasksPerMst - 1, testPj.ASI_DFPM_Total_Task__c);
        System.assertEquals(3, testPj.ASI_DFPM_Total_Complete_Task__c);
        testMst = getMstForSummary(testMstList.get(0).Id);
        System.assertEquals(numOfTestTasksPerMst - 1, testMst.ASI_DFPM_Total_Task__c);
        System.assertEquals(1, testMst.ASI_DFPM_Total_Complete_Task__c);
        
        undelete testTaskList.get(0);
        
        // Check summaries after updating tasks
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst * numOfTestTasksPerMst, testPj.ASI_DFPM_Total_Task__c);
        System.assertEquals(4, testPj.ASI_DFPM_Total_Complete_Task__c);
        testMst = getMstForSummary(testMstList.get(0).Id);
        System.assertEquals(numOfTestTasksPerMst, testMst.ASI_DFPM_Total_Task__c);
        System.assertEquals(2, testMst.ASI_DFPM_Total_Complete_Task__c);
        
        Test.stopTest();
    }
    
    static testMethod void test_ASI_DFPM_PromotionalTaskAutoAssignPj() {
        ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
        ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
        ASI_DFPM_PromotionalTaskGenerator taskGen = new ASI_DFPM_PromotionalTaskGenerator();
        
        ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard);
        insert testPj;
        ASI_DFPM_Project_Milestone__c testMst = mstGen.generateMilestone(testPj);
        insert testMst;
        ASI_DFPM_Project_Task__c testTask = taskGen.generateTask(testMst, ASI_DFPM_PromotionalTaskGenerator.RT_Standard);
        
        Test.startTest();
        
        testTask.ASI_DFPM_Promotional_Project__c = null;
        insert testTask;
        testTask = [SELECT Id, ASI_DFPM_Promotional_Project__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(testPj.Id, testTask.ASI_DFPM_Promotional_Project__c);
        
        testTask.ASI_DFPM_Promotional_Project__c = null;
        update testTask;
        testTask = [SELECT Id, ASI_DFPM_Promotional_Project__c FROM ASI_DFPM_Project_Task__c WHERE Id = :testTask.Id];
        System.assertEquals(testPj.Id, testTask.ASI_DFPM_Promotional_Project__c);
        
        Test.stopTest();
    }
    
    private static ASI_DFPM_Promotional_Project__c getPjForSummary(Id pjId) {
        return [SELECT Id
            , ASI_DFPM_Total_Milestone__c, ASI_DFPM_Total_Complete_Milestone__c
            , ASI_DFPM_Total_Task__c, ASI_DFPM_Total_Complete_Task__c, ASI_DFPM_Total_Overdue_Task__c
            FROM ASI_DFPM_Promotional_Project__c WHERE Id = :pjId
        ];
    }
    
    private static ASI_DFPM_Project_Milestone__c getMstForSummary(Id mstId) {
        return [SELECT Id
            , ASI_DFPM_Total_Task__c, ASI_DFPM_Total_Complete_Task__c, ASI_DFPM_Total_Overdue_Task__c
            FROM ASI_DFPM_Project_Milestone__c WHERE Id = :mstId
        ];
    }
    
    private static void markCompleteAndAddToList(ASI_DFPM_Project_Task__c tk, Boolean isComplete, List<ASI_DFPM_Project_Task__c> taskList) {
        tk.ASI_DFPM_Complete__c = isComplete;
        taskList.add(tk);
    }
}