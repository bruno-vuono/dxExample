/*********************************************************************************
 * Name: ASI_TnE_HK_AssignApproverCtrlTest
 * Description: Test class for ASI_TnE_HK_AssignApproverCtrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 11/7/2017        Hugo Cheung             Created          
*/

@isTest
public class ASI_TnE_HK_AssignApproverCtrlTest {
    
    @testSetup
	public static void setupTestData() {
		//Create running number for T&E claim header
        ASI_TnE_TestClassHelper.createRunningNumbers();
		
        //Create exchange rate
        ASI_MFM_Exchange_Rate__c exchangeRate1 = new ASI_MFM_Exchange_Rate__c();
        exchangeRate1.ASI_MFM_Application__c = 'T&E';
        exchangeRate1.ASI_MFM_Base_Currency__c = 'HKD';
        exchangeRate1.ASI_MFM_Counter_Currency__c = 'USD';
        exchangeRate1.ASI_MFM_Country__c = 'HK';
        exchangeRate1.ASI_MFM_Effective_Date__c = Date.Today().addMonths(-4);
        exchangeRate1.ASI_MFM_Exchange_Rate__c = 8.1;
        
        ASI_MFM_Exchange_Rate__c exchangeRate2 = new ASI_MFM_Exchange_Rate__c();
        exchangeRate2.ASI_MFM_Application__c = 'T&E';
        exchangeRate2.ASI_MFM_Base_Currency__c = 'HKD';
        exchangeRate2.ASI_MFM_Counter_Currency__c = 'USD';
        exchangeRate2.ASI_MFM_Country__c = 'HK';
        exchangeRate2.ASI_MFM_Effective_Date__c = Date.Today().addMonths(-5);
        exchangeRate2.ASI_MFM_Exchange_Rate__c = 8.0;
        
        ASI_MFM_Exchange_Rate__c exchangeRate3 = new ASI_MFM_Exchange_Rate__c();
        exchangeRate3.ASI_MFM_Application__c = 'T&E';
        exchangeRate3.ASI_MFM_Base_Currency__c = 'HKD';
        exchangeRate3.ASI_MFM_Counter_Currency__c = 'AUD';
        exchangeRate3.ASI_MFM_Country__c = 'HK';
        exchangeRate3.ASI_MFM_Effective_Date__c = Date.Today().addMonths(-1);
        exchangeRate3.ASI_MFM_Exchange_Rate__c = 5.636907;
        
        ASI_MFM_Exchange_Rate__c exchangeRate4 = new ASI_MFM_Exchange_Rate__c();
        exchangeRate4.ASI_MFM_Application__c = 'T&E';
        exchangeRate4.ASI_MFM_Base_Currency__c = 'HKD';
        exchangeRate4.ASI_MFM_Counter_Currency__c = 'AUD';
        exchangeRate4.ASI_MFM_Country__c = 'HK';
        exchangeRate4.ASI_MFM_Effective_Date__c = Date.Today().addMonths(-2);
        exchangeRate4.ASI_MFM_Exchange_Rate__c = 5.436907;
        
		List<ASI_MFM_Exchange_Rate__c> exchangeRateList = new List<ASI_MFM_Exchange_Rate__c>();
		exchangeRateList.add(exchangeRate1);
		exchangeRateList.add(exchangeRate2);
		exchangeRateList.add(exchangeRate3);
		exchangeRateList.add(exchangeRate4);
        insert exchangeRateList;
        
        User u = ASI_TnE_TestClassHelper.newUser('testApprover');
        u.ASI_Company_Name__c = 'test';
        u.ASI_Department__c = 'test';
        insert u;
        
        System.runAs(u) {
            //Create claim header
            ASI_TnE_ClaimHeader__c claimHeader = ASI_TnE_TestClassHelper.createTestClaimHeader('1234567','ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header');
			
			//Wilken Lee 20171122: financeClaimHeader was not refereence in the test class
            //ASI_TnE_ClaimHeader__c financeClaimHeader = ASI_TnE_TestClassHelper.createTestClaimHeader('1234567','ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header_Finance');

            //Create expense category and classification
            ASI_JP_TnE_Expense_Category__c expenseCategory = ASI_TnE_TestClassHelper.createExpenseCategory('ASI_JP_TnE_Expense_Category__cASI_TnE_HK_Expense_Category');
            ASI_JP_TnE_Expense_Classification__c expenseClassification = ASI_TnE_TestClassHelper.createExpenseCls('ASI_JP_TnE_Expense_Classification__cASI_TnE_HK_Expense_Classification',
                                                                                                                  expenseCategory,
                                                                                                                  ASI_TnE_TestClassHelper.createAccMap('ASI_TnE_Account_Mapping__cASI_TnE_HK_Account_Mapping')
                                                                                                                  );

            //Create A/C Code
            ASI_MFM_A_C_Code__c acCode = new ASI_MFM_A_C_Code__c();
            acCode.Name = 'Test A/C Code';
            acCode.RecordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_TnE_HK_A_C_Code');
            insert acCode;

            ASI_TnE_ClaimDetail__c claimDetail = new ASI_TnE_ClaimDetail__c();
            claimDetail.ASI_TnE_ClaimHeader__c            = claimHeader.Id; 
            claimDetail.ASI_TnE_Expense_Classification__c = expenseClassification.Id;
            claimDetail.ASI_TnE_A_C_Code__c               = acCode.Id;
            claimDetail.ASI_TnE_Receipt_Date__c           = date.today();
            claimDetail.ASI_TnE_Description__c            = 'test description';
            claimDetail.ASI_TnE_Currency__c               = 'HKD';
            claimDetail.ASI_TnE_Receipt_Amount__c         = 100;
            claimDetail.ASI_TnE_FX_Rate__c                = 1;
            claimDetail.RecordTypeId                      = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_HK_Claim_Detail');
            insert claimDetail;
        
        	ASI_TnE_Route_Type__c route = new ASI_TnE_Route_Type__c();
            List<User> userList = new List<User>();
            User u1 = ASI_TnE_TestClassHelper.newUser('test001');
			
			//Wilken Lee 20171121 - Reduce test data size to prevent too many SOQL error
            /*User u2 = ASI_TnE_TestClassHelper.newUser('test002');
            User u3 = ASI_TnE_TestClassHelper.newUser('test003');
            User u4 = ASI_TnE_TestClassHelper.newUser('test004');
            User u5 = ASI_TnE_TestClassHelper.newUser('test005');*/
            userList.add(u1);
			/*userList.add(u2);userList.add(u3);userList.add(u4);userList.add(u5);*/
            insert userList;
            
            route.ASI_TnE_Company__c = u.ASI_Company_Name__c;
            route.ASI_TnE_Department__c = u.ASI_Department__c;
            route.recordtypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Route_Type__cASI_TnE_HK_Route_Type');
            
            insert route;
            List<ASI_TnE_Route_Rule_Detail__c> detailList = new List <ASI_TnE_Route_Rule_Detail__c>(); 
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'Line Manager')); 
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u1.Id));
			//Wilken Lee 20171121 - Reduce test data size to prevent too many SOQL error
            /*detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u2.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u3.Id)); 
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u4.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u5.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u5.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u4.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u3.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u2.Id));
            detailList.add(new ASI_TnE_Route_Rule_Detail__c(ASI_TnE_Route_Type__c = route.Id, ASI_TnE_Approver_Type__c = 'User', ASI_TnE_Approver_Name__c = u1.Id));*/
            insert detailList;
        }
	}
    
    public static testMethod void testCtrl() {
		System.debug('testCtrl Start: Number of Queries used in this apex code so far: ' + Limits.getQueries());
        ASI_TnE_ClaimHeader__c claimHeader = [SELECT Id 
                                              FROM ASI_TnE_ClaimHeader__c 
                                              WHERE RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header')
                                              LIMIT 1];
        
        PageReference pageRef = Page.ASI_TnE_HK_AssignApproverPage;
        pageRef.getParameters().put('id', claimHeader.Id);
        Test.setCurrentPage(pageRef);
        
        ASI_TnE_HK_AssignApproverCtrl assignApproverCtrl = new ASI_TnE_HK_AssignApproverCtrl();
		
		System.debug('testCtrl before reassignApprover Start: Number of Queries used in this apex code so far: ' + Limits.getQueries());

        assignApproverCtrl.reassignApprover();
    }
}