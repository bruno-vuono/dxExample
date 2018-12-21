@isTest
private class ASI_DFPM_PromotionalProjectGanttChtTest {

    static testMethod void test_main() {
    	// Initialize Data
    	final Integer numOfTestMst = 5;
    	final Integer numOfTestTasksPerMst = 5;
    	ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
    	ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
    	ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
    	insert testPj;
    	List<ASI_DFPM_Project_Milestone__c> testMstList = mstGen.generateMilestonesInSequence(testPj, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testMstList;
        
        Test.startTest();
        
        // Initialize page and controller
        PageReference testPage = Page.ASI_DFPM_PromotionalPjGanttChartPage;
        Test.setCurrentPageReference(testPage);
        ASI_DFPM_GanttChartController testController = new ASI_DFPM_GanttChartController();
        testController.myTargetId = testPj.Id;
        
        Boolean initSuccess = testController.initVar;
        System.assertEquals(true, initSuccess);
        
        // Get gantt chart display element and validate the start dates
        List<ASI_DFPM_GanttChartElement> gcEleList = ASI_DFPM_GanttChartController.queryGanttChartElements(testController.myTargetId);
        System.assertEquals(numOfTestMst, gcEleList.size());
        Map<ID, ASI_DFPM_Project_Milestone__c> mstMap = new Map<ID, ASI_DFPM_Project_Milestone__c>([SELECT Id, ASI_DFPM_Start_Date__c FROM ASI_DFPM_Project_Milestone__c WHERE Id IN :testMstList]);
        for (Integer i = 0; i < numOfTestMst; i++) {
    		ASI_DFPM_GanttChartElement gcEle = gcEleList.get(i);
    		System.assertEquals(mstMap.get(gcEle.id).ASI_DFPM_Start_Date__c, gcEle.startDate);
    	}
    	
    	// Click the gantt chart element and redirect to detail page
    	Map<String, String> pageParams = testPage.getParameters();
    	pageParams.put('recordId', testMstList.get(0).Id);
    	PageReference redirectPage = testController.redirectToContentDetailPage();
    	System.assert(redirectPage != null);
        
        Test.stopTest();
    }
}