@isTest
private class ASI_DFPM_PromotionalProjectTriggerTest {
	
    static testMethod void test_ASI_DFPM_DateDurationCalculator() {
    	ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
	    
		ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard);
    	insert testPj;
    	
    	Test.startTest();
    	
    	ASI_DFPM_Promotional_Project__c queryPj = [SELECT Id, ASI_DFPM_Start_Date__c, ASI_DFPM_Duration__c, ASI_DFPM_End_Date__c FROM ASI_DFPM_Promotional_Project__c WHERE Id = :testPj.Id];
    	
    	// Change dates/duration
    	queryPj.ASI_DFPM_Start_Date__c = Date.newInstance(2013, 2, 18);
    	queryPj.ASI_DFPM_Duration__c = 6;
    	update queryPj;
    	queryPj = [SELECT Id, ASI_DFPM_Start_Date__c, ASI_DFPM_Duration__c, ASI_DFPM_End_Date__c FROM ASI_DFPM_Promotional_Project__c WHERE Id = :testPj.Id];
    	System.assertEquals(Date.newInstance(2013, 2, 25), queryPj.ASI_DFPM_End_Date__c);
    	
    	queryPj.ASI_DFPM_End_Date__c = Date.newInstance(2013, 2, 24);
    	update queryPj;
    	queryPj = [SELECT Id, ASI_DFPM_Start_Date__c, ASI_DFPM_Duration__c, ASI_DFPM_End_Date__c FROM ASI_DFPM_Promotional_Project__c WHERE Id = :testPj.Id];
    	System.assertEquals(5, queryPj.ASI_DFPM_Duration__c);
    	
    	queryPj.ASI_DFPM_Start_Date__c = Date.newInstance(2013, 2, 14);
    	queryPj.ASI_DFPM_Duration__c = 6;
    	queryPj.ASI_DFPM_End_Date__c = Date.newInstance(2013, 2, 14);
    	update queryPj;
    	queryPj = [SELECT Id, ASI_DFPM_Start_Date__c, ASI_DFPM_Duration__c, ASI_DFPM_End_Date__c FROM ASI_DFPM_Promotional_Project__c WHERE Id = :testPj.Id];
    	System.assertEquals(Date.newInstance(2013, 2, 21), queryPj.ASI_DFPM_End_Date__c);
    	
    	Test.stopTest();
    }
    
    static testMethod void test_ASI_DFPM_PromotionalProjectOwnerChange() {
		final Integer numOfTestMst = 5;
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
    	
	    	// Project owner is current user
	    	ASI_DFPM_Promotional_Project__c queryPj = [SELECT Id, OwnerId FROM ASI_DFPM_Promotional_Project__c WHERE Id = :testPj.Id];
	    	System.assertEquals(UserInfo.getUserId(), queryPj.OwnerId);
	    	
	    	// Change project owner to the new user
	    	queryPj.OwnerId = testUser.Id;
	    	update queryPj;
	    
	    	// Validate the new project owner
	    	queryPj = [SELECT Id, OwnerId FROM ASI_DFPM_Promotional_Project__c WHERE Id = :testPj.Id];
	    	System.assertEquals(testUser.Id, queryPj.OwnerId);
	    	
	    	// Check milestone sharing rules
	    	String pjOwnerRowCause = Schema.ASI_DFPM_Project_Milestone__Share.RowCause.ASI_DFPM_Project_Owner__c;
	    	List<ASI_DFPM_Project_Milestone__Share> queryMstShareList = [SELECT Id, UserOrGroupId FROM ASI_DFPM_Project_Milestone__Share WHERE ParentId IN :testMstList AND RowCause = :pjOwnerRowCause];
	    	for (ASI_DFPM_Project_Milestone__Share queryMstShare : queryMstShareList) {
	    		System.assertEquals(testUser.Id, queryMstShare.UserOrGroupId);
	    	}
	    	
	    	// Check task sharing rules
	    	pjOwnerRowCause = Schema.ASI_DFPM_Project_Task__Share.RowCause.ASI_DFPM_Project_Owner__c;
	    	List<ASI_DFPM_Project_Task__Share> queryTaskShareList = [SELECT Id, UserOrGroupId FROM ASI_DFPM_Project_Task__Share WHERE ParentId IN :testTaskList AND RowCause = :pjOwnerRowCause];
	    	for (ASI_DFPM_Project_Task__Share queryTaskShare : queryTaskShareList) {
	    		System.assertEquals(testUser.Id, queryTaskShare.UserOrGroupId);
	    	}
	    }
	    
	    testUser.IsActive = false;
	    update testUser;
    }
}