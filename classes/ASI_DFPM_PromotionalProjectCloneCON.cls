public with sharing class ASI_DFPM_PromotionalProjectCloneCON extends ASI_DFPM_AbstractPageController {
	
	public ID pjId { get; private set; }
	public ASI_DFPM_Promotional_Project__c pjForInput { get; set; }
	
	private ID pjOwnerId;
	
	public ASI_DFPM_PromotionalProjectCloneCON(ApexPages.StandardController stdCon) {
		this.pjId = stdCon.getId();
		this.pjForInput = new ASI_DFPM_Promotional_Project__c();
		this.pjForInput.ASI_DFPM_Start_Date__c = System.today();
		this.pjForInput.OwnerId = Userinfo.getUserId();
	}
	
	public PageReference startClone() {
		try {
			ID newPjId = ASI_DFPM_ProjectCloneHelper.cloneAndSaveProject(this.pjId, this.pjForInput.ASI_DFPM_Start_Date__c, this.pjForInput.OwnerId, true);
			if (newPjId == null) throw new ASI_DFPM_CustomException('Unknow error when cloning project');
			return new PageReference('/' + newPjId);
		} catch (Exception e) {
			showPageError(e.getMessage());
		}
		return null;
	}

    static testMethod void test_main() {
        // Initialize Data
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
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testPj);
        
        Test.startTest();
        
        // Init page
        PageReference testPage = Page.ASI_DFPM_PromotionalProjectClonePage;
        Test.setCurrentPageReference(testPage);
        ASI_DFPM_PromotionalProjectCloneCON testController = new ASI_DFPM_PromotionalProjectCloneCON(stdCon);
        
        // Enter start date and clone
        testController.pjForInput.ASI_DFPM_Start_Date__c = Date.newInstance(2013, 2, 22);
        PageReference redirectPage = testController.startClone();
        
        // Validate result
        System.assert(null != redirectPage);
        String newPjId = redirectPage.getUrl().substring(1);
        List<ASI_DFPM_Promotional_Project__c> newPjList = [SELECT Id, (SELECT Id FROM Milestones__r) FROM ASI_DFPM_Promotional_Project__c WHERE Id = :newPjId];
        System.assertEquals(1, newPjList.size());
        System.assertEquals(numOfTestMst, newPjList.get(0).Milestones__r.size());
        
        Test.stopTest();
    }
}