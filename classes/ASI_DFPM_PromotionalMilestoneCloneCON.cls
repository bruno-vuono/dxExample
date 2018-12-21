public with sharing class ASI_DFPM_PromotionalMilestoneCloneCON extends ASI_DFPM_AbstractPageController {
	
	public ID mstId { get; private set; }
	private ID replaceInactiveUserId;
	
	public ASI_DFPM_PromotionalMilestoneCloneCON(ApexPages.StandardController stdCon) {
		this.mstId = stdCon.getId();
		List<ASI_DFPM_Project_Milestone__c> mstList = [SELECT Id, OwnerId FROM ASI_DFPM_Project_Milestone__c WHERE Id = :mstId];
		this.replaceInactiveUserId = mstList.size() > 0 ? mstList.get(0).OwnerId : UserInfo.getUserId();
	}
	
	public PageReference startClone() {
		try {
			ID currentUserId = UserInfo.getUserId();
			ID newMstId = ASI_DFPM_ProjectCloneHelper.cloneAndSaveMilestone(this.mstId, null, null, true, this.replaceInactiveUserId, currentUserId, '{0} - Cloned');
			return new PageReference('/' + newMstId);
		} catch (Exception e) {
			showPageError(e.getMessage());
		}
		return null;
	}

    static testMethod void test_main() {
        // Initialize Data
    	final Integer numOfTestMst = 1;
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
        
        ASI_DFPM_Project_Milestone__c testMst = testMstList.get(0);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testMst);
        
        Test.startTest();
        
        // Init page
        PageReference testPage = Page.ASI_DFPM_PromotionalMilestoneClonePage;
        Test.setCurrentPageReference(testPage);
        ASI_DFPM_PromotionalMilestoneCloneCON testController = new ASI_DFPM_PromotionalMilestoneCloneCON(stdCon);
        
        // Start clone
        PageReference redirectPage = testController.startClone();
        
        // Validate result
        System.assert(null != redirectPage);
        String newMstId = redirectPage.getUrl().substring(1);
        List<ASI_DFPM_Project_Milestone__c> newMstList = [SELECT Id, (SELECT Id FROM ASI_DFPM_Project_Tasks__r) FROM ASI_DFPM_Project_Milestone__c WHERE Id = :newMstId];
        System.assertEquals(1, newMstList.size());
        System.assertEquals(numOfTestTasksPerMst, newMstList.get(0).ASI_DFPM_Project_Tasks__r.size());
        
        Test.stopTest();
    }
}