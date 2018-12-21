@isTest
private class ASI_DFPM_PromotionalMilestoneTriggerTest {

    static testMethod void test_ASI_DFPM_PromotionalMstParentSummaryUP() {
        final Integer numOfTestMst = 5;
        
        ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
        ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
        
        ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard, numOfTestMst, null, ASI_DFPM_PromotionalMilestoneGenerator.DEF_VALUE_DURATION);
        insert testPj;
        List<ASI_DFPM_Project_Milestone__c> testMstList = mstGen.generateMilestonesInSequence(testPj, numOfTestMst, null, null);
        insert testMstList;
        
        Test.startTest();
        
        // Check summaries
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst, testPj.ASI_DFPM_Total_Milestone__c);
        System.assertEquals(0, testPj.ASI_DFPM_Total_Complete_Milestone__c);
        
        // Update milestones
        testMstList.get(0).ASI_DFPM_Complete__c = true;
        testMstList.get(1).ASI_DFPM_Complete__c = true;
        List<ASI_DFPM_Project_Milestone__c> updateMstList = new List<ASI_DFPM_Project_Milestone__c>{
            testMstList.get(0)
            , testMstList.get(1)
        };
        update updateMstList;
        
        // Check summaries after updating milestones
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst, testPj.ASI_DFPM_Total_Milestone__c);
        System.assertEquals(2, testPj.ASI_DFPM_Total_Complete_Milestone__c);
        
        delete testMstList.get(0);
        // Check summaries after deleting milestone
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst - 1, testPj.ASI_DFPM_Total_Milestone__c);
        System.assertEquals(1, testPj.ASI_DFPM_Total_Complete_Milestone__c);
        
        undelete testMstList.get(0);
        // Check summaries after deleting milestone
        testPj = getPjForSummary(testPj.Id);
        System.assertEquals(numOfTestMst, testPj.ASI_DFPM_Total_Milestone__c);
        System.assertEquals(2, testPj.ASI_DFPM_Total_Complete_Milestone__c);
        
        Test.stopTest();
    }
    
    private static ASI_DFPM_Promotional_Project__c getPjForSummary(Id pjId) {
        return [SELECT Id
            , ASI_DFPM_Total_Milestone__c, ASI_DFPM_Total_Complete_Milestone__c
            , ASI_DFPM_Total_Task__c, ASI_DFPM_Total_Complete_Task__c, ASI_DFPM_Total_Overdue_Task__c
            FROM ASI_DFPM_Promotional_Project__c WHERE Id = :pjId
        ];
    }
    
    static testMethod void test_ASI_DFPM_DateDurationCalculator() {
        ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
        ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
        
        ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard);
        insert testPj;
        ASI_DFPM_Project_Milestone__c testMst = mstGen.generateMilestone(testPj);
        insert testMst;
        
        Test.startTest();
        
        testMst = [SELECT Id, ASI_DFPM_Start_Date__c, ASI_DFPM_Duration__c, ASI_DFPM_End_Date__c FROM ASI_DFPM_Project_Milestone__c WHERE Id = :testMst.Id];
        
        // Change start date
        Integer addDays = 2;
        testMst.ASI_DFPM_Start_Date__c = ASI_DFPM_PromotionalMilestoneGenerator.DEF_VALUE_START_DATE.addDays(addDays);
        testMst.ASI_DFPM_Duration__c = ASI_DFPM_PromotionalProjectGenerator.DEF_VALUE_DURATION - addDays - 1;
        update testMst;
        testMst = [SELECT Id, ASI_DFPM_Start_Date__c, ASI_DFPM_Duration__c, ASI_DFPM_End_Date__c FROM ASI_DFPM_Project_Milestone__c WHERE Id = :testMst.Id];
        
        Test.stopTest();
    }
    
    static testMethod void test_ASI_DFPM_PromotionalMilestoneOwnerChange() {
		final Integer numOfTestMst = 2;
	    final Integer numOfTestTasksPerMst = 5;
    	
	    ID curUserId = UserInfo.getUserId();
	    User curUser = [SELECT Id FROM User WHERE Id = :curUserId];
	    
    	System.runAs(curUser) {
			EXT_USR_Config__c bypassUserConfig = new EXT_USR_Config__c(EXT_USR_RQT_External_Profile_Id__c = ASI_DFPM_UserGenerator.DEF_VALUE_PROFILE_ID);
			insert bypassUserConfig;
    	}
    	
    	// Create a new user for owner change
    	ASI_DFPM_UserGenerator userGen = new ASI_DFPM_UserGenerator();
    	User testUser = userGen.generateUser('dfpmTestU');
    	insert testUser;
	    
	    System.runAs(curUser) {
	    	PermissionSetAssignment psAssign = userGen.generatePermissionSetAssignment(testUser);
	    	insert psAssign;
	    	
	    	ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
			ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
			ASI_DFPM_PromotionalTaskGenerator taskGen = new ASI_DFPM_PromotionalTaskGenerator();
		    
			ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
	    	insert testPj;
	    	List<ASI_DFPM_Project_Milestone__c> testMstList = mstGen.generateMilestonesInSequence(testPj, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
	        insert testMstList;
	    	List<ASI_DFPM_Project_Task__c> testTaskList = taskGen.generateTasksInSequence(testMstList, ASI_DFPM_PromotionalTaskGenerator.RT_Standard, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
	        insert testTaskList;
    	
    		ID testMstId = testMstList.get(0).Id;
	    	// Milestone owner is current user
	    	ASI_DFPM_Project_Milestone__c queryMst = [SELECT Id, OwnerId FROM ASI_DFPM_Project_Milestone__c WHERE Id = :testMstId];
	    	System.assertEquals(UserInfo.getUserId(), queryMst.OwnerId);
	    	
	    	// Change milestone owner to the new user
	    	queryMst.OwnerId = testUser.Id;
	    	update queryMst;
	    
	    	// Validate the new milestone owner
	    	queryMst = [SELECT Id, OwnerId FROM ASI_DFPM_Project_Milestone__c WHERE Id = :testMstId];
	    	System.assertEquals(testUser.Id, queryMst.OwnerId);
	    	
	    	// Check task sharing rules
	    	List<ASI_DFPM_Project_Task__c> testMstTaskList = [SELECT Id FROM ASI_DFPM_Project_Task__c WHERE ASI_DFPM_Project_Milestone__c = :testMstId];
	    	String mstOwnerRowCause = Schema.ASI_DFPM_Project_Task__Share.RowCause.ASI_DFPM_Milestone_Owner__c;
	    	List<ASI_DFPM_Project_Task__Share> queryTaskShareList = [SELECT Id, UserOrGroupId FROM ASI_DFPM_Project_Task__Share WHERE ParentId IN :testMstTaskList AND RowCause = :mstOwnerRowCause];
	    	for (ASI_DFPM_Project_Task__Share queryTaskShare : queryTaskShareList) {
	    		System.assertEquals(testUser.Id, queryTaskShare.UserOrGroupId);
	    	}
	    }
	    
	    testUser.IsActive = false;
	    update testUser;
    }
}