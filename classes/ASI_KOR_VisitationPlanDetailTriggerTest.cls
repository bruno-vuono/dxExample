@isTest
private class ASI_KOR_VisitationPlanDetailTriggerTest {

    static testMethod void test_ASI_KOR_VisitationPlanDtValidator() {
        ASI_KOR_AccountGenerator acctGen = new ASI_KOR_AccountGenerator();
    	ASI_KOR_VisitationPlanGenerator visitPlanGen = new ASI_KOR_VisitationPlanGenerator();
    	ASI_KOR_VisitationPlanDetailGenerator visitPlanDetailGen = new ASI_KOR_VisitationPlanDetailGenerator();
    	
    	// Initialize Accounts
    	final Integer numOfTestWS = 5;
    	List<Account> wsList = new List<Account>();
    	for (Integer i = 0; i < numOfTestWS; i++) {
    		wsList.add(acctGen.generateAccount(ASI_KOR_AccountGenerator.RT_WS));
    	}
    	insert wsList;
    	

        // Initialize Visitation Plan changed by Elufa support 20160629
        //ASI_KOR_Visitation_Plan__c visitPlan = visitPlanGen.generateVisitationPlan();
        // insert visitPlan;
        
        date systoday= system.today();
        Map<Integer, string> MonthMap = new Map<Integer, string>{ 1 => 'January',2 => 'February',3 => 'March',4 => 'April',5 => 'May',6 => 'June',7 => 'July', 8 => 'August',9 => 'September',10 => 'October',11 => 'November',12 => 'December'};
            
            
        List<ASI_KOR_Visitation_Plan__c> vpList= new List<ASI_KOR_Visitation_Plan__c>();
        ASI_KOR_Visitation_Plan__c visitPlan = visitPlanGen.generateVisitationPlan();
        vpList.add(visitPlan);
        ASI_KOR_Visitation_Plan__c vp1= new ASI_KOR_Visitation_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan__cASI_CRM_KR_Visitation_Plan'),ASI_KOR_Month__c=MonthMap.get(systoday.month()),ASI_KOR_Year__c=String.valueOf(systoday.year()-1),Name = 'Default Plan for Mobile App');
        vpList.add(vp1);
        
        insert vpList;
		// Changed by Elufa support 20160629 end
		

    	// Initialize Visitation Plan Details
    	List<ASI_KOR_Visitation_Plan_Detail__c> visitPlanDetails = new List<ASI_KOR_Visitation_Plan_Detail__c>();
    	Date visitPlanFirstDate = Date.newInstance(
    		Integer.valueOf(ASI_KOR_VisitationPlanGenerator.DEF_VALUE_YEAR)
    		, ASI_KOR_VisitationPlanGenerator.convertMonthPLValueToInteger(ASI_KOR_VisitationPlanGenerator.DEF_VALUE_MONTH)
    		, 1
		);
		visitPlanDetails.add(visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(0), visitPlanFirstDate.addDays(2))); // WS0 3rd
		visitPlanDetails.add(visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(0), visitPlanFirstDate.addDays(17))); // WS0 18th
		visitPlanDetails.add(visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(2), visitPlanFirstDate.addDays(17))); // WS2 18th
		insert visitPlanDetails;
		
		Test.startTest();
		
		// Test creating duplicate date for same account
		ASI_KOR_Visitation_Plan_Detail__c testVisitPlanDetail = visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(0), visitPlanFirstDate.addDays(2));
		Boolean hasException = false;
		try {
			insert testVisitPlanDetail;
		} catch (DmlException dmle) {
			hasException = true;
		}
		//System.assertEquals(true, hasException);
		hasException = false;
		
		// Test updating to duplicate date for same account
		testVisitPlanDetail = visitPlanDetails.get(0);
		Date origVisitDate = testVisitPlanDetail.ASI_KOR_Visit_Date__c;
		testVisitPlanDetail.ASI_KOR_Visit_Date__c = visitPlanFirstDate.addDays(17);
		try {
			update testVisitPlanDetail;
		} catch (DmlException dmle) {
			hasException = true;
		}
		//System.assertEquals(true, hasException);
		hasException = false;
		
		// Test updating unmatched date with header
		testVisitPlanDetail.ASI_KOR_Visit_Date__c = visitPlanFirstDate.addDays(-400);
		try {
			update testVisitPlanDetail;
		} catch (DmlException dmle) {
			hasException = true;
		}
		System.assertEquals(true, hasException);
		hasException = false;
		
		// Test undelete visit which has duplicate date
		delete testVisitPlanDetail;
		ASI_KOR_Visitation_Plan_Detail__c deletedVisitPlanDetail = testVisitPlanDetail;
		testVisitPlanDetail = visitPlanDetails.get(1);
		testVisitPlanDetail.ASI_KOR_Visit_Date__c = origVisitDate;
		update testVisitPlanDetail;
		try {
			undelete deletedVisitPlanDetail;
		} catch (DmlException dmle) {
			hasException = true;
		}
		//System.assertEquals(true, hasException);
		hasException = false;
		
		Test.stopTest();
    }
}