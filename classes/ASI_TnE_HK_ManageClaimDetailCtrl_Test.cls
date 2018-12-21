/*********************************************************************************
 * Name: ASI_TnE_HK_ManageClaimDetailCtrl_Test
 * Description: Test class for ASI_TnE_HK_ManageClaimDetailController
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 21/12/2016       Hugo Cheung             Created          
*/
@isTest
public class ASI_TnE_HK_ManageClaimDetailCtrl_Test {

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
        
        //Create claim header
        ASI_TnE_ClaimHeader__c claimHeader = ASI_TnE_TestClassHelper.createTestClaimHeader('1234567','ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header');
        ASI_TnE_ClaimHeader__c financeClaimHeader = ASI_TnE_TestClassHelper.createTestClaimHeader('1234567','ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header_Finance');
        
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
	}

	public static testMethod void testTnEHKManageClaimDetailPage() {
		ASI_TnE_ClaimHeader__c claimHeader = [SELECT Id 
                                              FROM ASI_TnE_ClaimHeader__c 
                                              WHERE RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header')
                                              LIMIT 1];
	
        ASI_JP_TnE_Expense_Classification__c expenseClassification = [SELECT Id
                                                                      FROM ASI_JP_TnE_Expense_Classification__c
                                                                      LIMIT 1];
        
        ASI_MFM_A_C_Code__c acCode = [SELECT Id
                                      FROM ASI_MFM_A_C_Code__c
                                      LIMIT 1];
        
		PageReference pageRef = Page.ASI_TnE_HK_ManageClaimDetailPage;
		Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', claimHeader.id);       

        ApexPages.StandardController sc = new ApexPages.StandardController(claimHeader);
        ASI_TnE_HK_ManageClaimDetailController controller = new ASI_TnE_HK_ManageClaimDetailController(sc);
        
        Test.startTest();
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
        
        List<ASI_TnE_ClaimDetail__c> claimDetailList = new List<ASI_TnE_ClaimDetail__c>();
        claimDetailList.add(claimDetail);
        
        String upsertClaimDetailInJson = System.JSON.serialize(claimDetailList);
        System.currentPageReference().getParameters().put('IS_QUICK_SAVE', 'false');
        System.currentPageReference().getParameters().put('UPSERT_DATA_JSON', upsertClaimDetailInJson);
        
        controller.save();
        controller.cancel();
        Test.stopTest();
        
        //Check delete trigger handler
        claimDetailList = [SELECT Id FROM ASI_TnE_ClaimDetail__c];
        delete claimDetailList;
        
        try {
            claimHeader.ASI_TnE_Type__c = 'Corp Card';
            update claimHeader;
            delete claimHeader;
        } catch(Exception e) {
        }
	}
	
    public static testMethod void testTnEHKManageFinanceClaimDetailPage() {
        ASI_TnE_ClaimHeader__c claimHeader = [SELECT Id 
                                              FROM ASI_TnE_ClaimHeader__c 
                                              WHERE RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header_Finance')
                                              LIMIT 1];

		PageReference pageRef = Page.ASI_TnE_HK_ManageClaimDetailPage;
		Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', claimHeader.id);       

        ApexPages.StandardController sc = new ApexPages.StandardController(claimHeader);
        ASI_TnE_HK_ManageClaimDetailController controller = new ASI_TnE_HK_ManageClaimDetailController(sc);
        
        String claimDetailListJson  = controller.claimDetailListJson;
  		String categoryListJson     = controller.categoryListJson;
  		String exchangeRateMapJson  = controller.exchangeRateMapJson;
  		String tneFieldNameListJson = controller.tneFieldNameListJson;
  		String currencyListJson     = controller.currencyListJson;
  		String fieldIdMapJson       = controller.fieldIdMapJson;
    }
    
}