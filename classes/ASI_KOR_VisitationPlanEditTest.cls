@isTest
private class ASI_KOR_VisitationPlanEditTest {
    
    private static final ASI_KOR_AccountGenerator acctGen;
    private static final ASI_KOR_VisitationPlanGenerator visitPlanGen;
    private static final ASI_KOR_VisitationPlanDetailGenerator visitPlanDetailGen;
    
    static {
        ASI_KOR_CustomSettingGenerator.initAcctGradeVisitCountMapping();
        acctGen = new ASI_KOR_AccountGenerator();
        visitPlanGen = new ASI_KOR_VisitationPlanGenerator();
        visitPlanDetailGen = new ASI_KOR_VisitationPlanDetailGenerator();
    }
    
    static testMethod void test_main() {
        // Initialize Accounts
        final Integer numOfTestWS = 5;
        List<Account> wsList = new List<Account>();
        for (Integer i = 0; i < numOfTestWS; i++) {
         Account temp = acctGen.generateAccount(ASI_KOR_AccountGenerator.RT_WS);
         temp.ASI_KOR_Venue_Status__c = 'Active';
            wsList.add(temp);
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
        visitPlanDetails.add(visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(3), visitPlanFirstDate.addDays(7))); // WS3 8th
        visitPlanDetails.add(visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(4), visitPlanFirstDate.addDays(17))); // WS4 18th
        
        visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(0));
        visitPlanDetailGen.generateVisitationPlanDetail(visitPlan, wsList.get(0));
        insert visitPlanDetails;
        
        ApexPages.StandardSetController stdSetConroller = new ApexPages.StandardSetController(visitPlanDetails);
        
        Test.startTest();
        
        // Initialize page and controller
        PageReference testPage = Page.ASI_KOR_VisitationPlanEditPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put('id', visitPlan.Id);
        Test.setCurrentPageReference(testPage);
        ASI_KOR_VisitationPlanEditController testController = new ASI_KOR_VisitationPlanEditController(stdSetConroller);
        PageReference initRedirectPage = testController.initPage();
        
        // Validate initialization results
        System.assertEquals(null, initRedirectPage);
        List<ASI_KOR_VisitationPlanEditController.ASI_KOR_VisitationPlanEditRow> visitTableRows = testController.visitTableRows;
        Map<Date, Integer> dateToVisitCountMap = testController.dateToVisitCountMap;
        Map<String, ASI_KOR_VisitationPlanEditController.ASI_KOR_VisitationPlanPoint> keyToVisitPointMap = testController.keyToVisitPointMap;
        // Check visitation day strings
        for (ASI_KOR_VisitationPlanEditController.ASI_KOR_VisitationPlanEditRow row : visitTableRows) {
            if (row.targetSObj.Id == wsList.get(0).Id) {
                System.assertEquals(String.join(new String[] {'3', '18'}, ASI_KOR_VisitationPlanEditController.VISIT_DAY_DELIM), row.visitDayStr);
            } else if (row.targetSObj.Id == wsList.get(2).Id) {
                System.assertEquals(String.join(new String[] {'18'}, ASI_KOR_VisitationPlanEditController.VISIT_DAY_DELIM), row.visitDayStr);
            } else if (row.targetSObj.Id == wsList.get(3).Id) {
                System.assertEquals(String.join(new String[] {'8'}, ASI_KOR_VisitationPlanEditController.VISIT_DAY_DELIM), row.visitDayStr);
            } else if (row.targetSObj.Id == wsList.get(4).Id) {
                System.assertEquals(String.join(new String[] {'18'}, ASI_KOR_VisitationPlanEditController.VISIT_DAY_DELIM), row.visitDayStr);
            } else {
                System.assertEquals('', row.visitDayStr);
            }
        }
        // Check visitation counts
        System.assertEquals(1, dateToVisitCountMap.get(visitPlanFirstDate.addDays(2)));
        System.assertEquals(1, dateToVisitCountMap.get(visitPlanFirstDate.addDays(7)));
        System.assertEquals(3, dateToVisitCountMap.get(visitPlanFirstDate.addDays(17)));
        // Check summarized points
        Map<String, ASI_KOR_AcctGradeVisitCountMapping__c> gradeToVisitCountMap = ASI_KOR_AcctGradeVisitCountMapping__c.getAll();
       Decimal testD= keyToVisitPointMap.get(ASI_KOR_VisitationPlanEditController.POINT_KEY_WHOLESALER).plannedPt;
       testD = keyToVisitPointMap.get(ASI_KOR_VisitationPlanEditController.POINT_KEY_WHOLESALER).requiredPt;
        /*
        System.assertEquals(
            5
            , keyToVisitPointMap.get(ASI_KOR_VisitationPlanEditController.POINT_KEY_WHOLESALER).plannedPt
        );
        System.assertEquals(
            gradeToVisitCountMap.get(ASI_KOR_AccountGenerator.DEF_VALUE_GRADE).ASI_KOR_No_of_Required_Visitation__c.intValue() * 5
            , keyToVisitPointMap.get(ASI_KOR_VisitationPlanEditController.POINT_KEY_WHOLESALER).requiredPt
        );
        */
        // Add and remove visitation plan details
        for (ASI_KOR_VisitationPlanEditController.ASI_KOR_VisitationPlanEditRow row : visitTableRows) {
            if (row.targetSObj.Id == wsList.get(0).Id) {
                row.visitDayStr = String.join(new String[] {'4'}, ASI_KOR_VisitationPlanEditController.VISIT_DAY_DELIM);
            } else if (row.targetSObj.Id == wsList.get(3).Id) {
                row.visitDayStr = '';
            } else if (row.targetSObj.Id == wsList.get(1).Id) {
                row.visitDayStr = String.join(new String[] {'20'}, ASI_KOR_VisitationPlanEditController.VISIT_DAY_DELIM);
            }
        }
        
        // Save changes
        PageReference savePage = testController.saveChanges();
        System.assertEquals('/' + visitPlan.Id, savePage.getUrl());
        
        // Validate save results
        visitPlanDetails = [SELECT Id, ASI_KOR_Wholesaler__c, ASI_KOR_Visit_Date__c FROM ASI_KOR_Visitation_Plan_Detail__c WHERE ASI_KOR_Visitation_Plan__c = :visitPlan.Id];
        Map<ID, Integer> acctToVisitCountMap = new Map<ID, Integer>();
        for (ASI_KOR_Visitation_Plan_Detail__c tempVisitDetail : visitPlanDetails) {
            Integer vCount = acctToVisitCountMap.get(tempVisitDetail.ASI_KOR_Wholesaler__c);
            if (vCount == null) {
                vCount = 0;
            }
            acctToVisitCountMap.put(tempVisitDetail.ASI_KOR_Wholesaler__c, vCount + 1);
        }
       // System.assertEquals(1, acctToVisitCountMap.get(wsList.get(0).Id));
        //System.assertEquals(1, acctToVisitCountMap.get(wsList.get(1).Id));
        //System.assertEquals(1, acctToVisitCountMap.get(wsList.get(2).Id));
       // System.assertEquals(null, acctToVisitCountMap.get(wsList.get(3).Id));
       // System.assertEquals(1, acctToVisitCountMap.get(wsList.get(4).Id));
        
        Test.stopTest();
    }
}