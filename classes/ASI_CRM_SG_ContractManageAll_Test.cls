/*
 *********************************************************************************
 * Name: ASI_CRM_SG_ContractManageAll_Test
 * Description: Test class for ASI_CRM_SG_ContractManageAll_Ctrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 28/11/2017       Jeffrey Cheung          Created, only calculateBackRebatesAmountTest has assertions
 * 17/06/2018       Wilken Lee          	[WL 1.0] Phase 4.2 Gen Remaining achived back rebate payment
 */

@isTest
private class ASI_CRM_SG_ContractManageAll_Test {
    @TestSetup
    public static void setupTestData() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
        List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();
        ASI_CRM_SG_TestClassHelper.contractData contractC1 = new ASI_CRM_SG_TestClassHelper.contractData(false);
        // only approved contract can generateBackRebatesPayment
        contractC1.contract.ASI_TH_CRM_Contract_Status__c = 'Contract Approved';

        insert contractC1.contract;

        ASI_CRM_SG_TestClassHelper.contractTargetData contractTargetC1 = new ASI_CRM_SG_TestClassHelper.contractTargetData(false, contractC1.contract, skuList.get(1));
        contractTargetC1.contractTarget.ASI_CRM_Entitle_Back_Rebates__c = true;
        // for fields in ASI_CRM_Bottle_Incentive_Total__c 
        contractTargetC1.contractTarget.ASI_CRM_Bottle_Incentive__c = 10;
        contractTargetC1.contractTarget.ASI_CRM_SG_Btls_Per_Case__c = 2;
        contractTargetC1.contractTarget.ASI_CRM_TargetCase__c = 50;
        // for fields in ASI_CRM_Till_Date_Sales_Percent_Bottle__c = ASI_CRM_Till_Date_Sales_Bottle__c / ASI_CRM_Target_Bottle__c
        contractTargetC1.contractTarget.ASI_CRM_Till_Date_Sales_Bottle__c = 100;
        // for fields in ASI_CRM_Back_Rebates_Issued_Percent__c
        contractTargetC1.contractTarget.ASI_CRM_Back_Rebates_Issued_Total__c = 0;
        contractTargetC1.contractTarget.ASI_CRM_SG_Cash__c = 10;
        
        insert contractTargetC1.contractTarget;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contractC1.contract);
        ASI_CRM_SG_ContractManageAll_Ctrl cmac = new ASI_CRM_SG_ContractManageAll_Ctrl(sc);
    }
    
    public static testMethod void testController() {
        ASI_TH_CRM_Contract__c contract = [SELECT Id FROM ASI_TH_CRM_Contract__c LIMIT 1];
        
        PageReference pageRef = Page.ASI_CRM_SG_ContractManageAll_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contract);
		ApexPages.currentPage().getParameters().put('Id', contract.id);
        ASI_CRM_SG_ContractManageAll_Ctrl cmac = new ASI_CRM_SG_ContractManageAll_Ctrl(sc);
        
        //Get JSON String
        String contractTargetListJson          = cmac.contractTargetListJson;
        String cashPaymentScheduleListJson     = cmac.cashPaymentScheduleListJson;
        String skuPriceWrapperListJson         = cmac.skuPriceWrapperListJson;
        String exceptionListJson               = cmac.exceptionListJson;
        
		Test.startTest();
		
        List<ASI_CRM_ContractTarget__c>  contractTargetList = (List<ASI_CRM_ContractTarget__c>) jsonStringToObject(contractTargetListJson, List<ASI_CRM_ContractTarget__c>.class);
        Set<Id> skuIdSet = new Set<Id>();
        for(ASI_CRM_ContractTarget__c contractTarget : contractTargetList) {
        	skuIdSet.add(contractTarget.ASI_CRM_SKU__c);
        }
        
		ApexPages.currentPage().getParameters().put('skuName', 'Test Sku 2');
        ApexPages.currentPage().getParameters().put('filterOutSKUIdListJson', objectToJsonString(skuIdSet));
        cmac.searchSKU();
        
		ApexPages.currentPage().getParameters().put('contractTargetListJson', contractTargetListJson);
        cmac.calculateROI();
        
		ApexPages.currentPage().getParameters().put('updateContractTargetListJson', contractTargetListJson);
		ApexPages.currentPage().getParameters().put('deleteContractTargetListJson', objectToJsonString(new List<Id>()));
		ApexPages.currentPage().getParameters().put('updatePaymentScheduleListJson', objectToJsonString(new List<ASI_CRM_Payment_Schedule__c>()));
		ApexPages.currentPage().getParameters().put('deletePaymentScheduleListJson', objectToJsonString(new List<Id>()));
		ApexPages.currentPage().getParameters().put('updateContractOutletListJson', objectToJsonString(new List<ASI_CRM_Contract_Outlets__c>()));
		ApexPages.currentPage().getParameters().put('deleteContractOutletListJson', objectToJsonString(new List<Id>()));

        cmac.reviseContract();
        cmac.deleteSimulation();
        cmac.getInflationRate();
        cmac.getDistributionRate();
        cmac.saveRecord();
        cmac.cancel();
		
        Test.stopTest();
    }

    
    private static testMethod void generateBackRebatesPaymentTest() {
        ASI_TH_CRM_Contract__c contract = [SELECT Id FROM ASI_TH_CRM_Contract__c LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(contract);
        ASI_CRM_SG_ContractManageAll_Ctrl cmac = new ASI_CRM_SG_ContractManageAll_Ctrl(sc);
        cmac.generateBackRebatesPayment();
        
        Test.startTest();
        ASI_CRM_ContractTarget__c ct = [select id from ASI_CRM_ContractTarget__c limit 1];
        ct.ASI_CRM_Till_Date_Sales_Bottle__c = 200;
        update ct;
        cmac.generateBackRebatesPayment();
        delete [select id from ASI_TH_CRM_PaymentRequest__c order by id desc limit 1];
		
		/*[WL 1.0] BEGIN*/
		cmac.generateBackRebatesPaymentRemain();
		/*[WL 1.0] END*/
        Test.stopTest();
    }
    
    private static testMethod void generatePaymentTest() {
        ASI_TH_CRM_Contract__c contract = [SELECT Id FROM ASI_TH_CRM_Contract__c LIMIT 1];
		List<ASI_CRM_Payment_Schedule__c> paymentScheduleList = ASI_CRM_SG_TestClassHelper.createPaymentSchedule(contract);
		
        PageReference pageRef = Page.ASI_CRM_SG_ContractManageAll_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contract);
		ApexPages.currentPage().getParameters().put('Id', contract.id);
        ASI_CRM_SG_ContractManageAll_Ctrl cmac = new ASI_CRM_SG_ContractManageAll_Ctrl(sc);
		
		ApexPages.currentPage().getParameters().put('scheduleId', paymentScheduleList.get(0).Id);
        cmac.requestPayment();
    }
    
	private static testMethod void calculateBackRebatesAmountTest() {
        ASI_TH_CRM_Contract__c contract = [SELECT Id FROM ASI_TH_CRM_Contract__c LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(contract);
        ASI_CRM_SG_ContractManageAll_Ctrl cmac = new ASI_CRM_SG_ContractManageAll_Ctrl(sc);
        
        Decimal result;

        // These cases are from 4.1 powerpoint
        result = cmac.calculateBackRebatesAmount(1000, 80, 0);
        System.assertEquals(750, result);
        result = cmac.calculateBackRebatesAmount(1000, 80, 50);
        System.assertEquals(250, result);
        result = cmac.calculateBackRebatesAmount(1000, 115, 0);
        System.assertEquals(1150, result);
        result = cmac.calculateBackRebatesAmount(1000, 115, 110);
        System.assertEquals(50, result);
        result = cmac.calculateBackRebatesAmount(1000, 10, 0);
        System.assertEquals(0, result);
	}
	
	
    private static String objectToJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private static Object jsonStringToObject(String jsonString, System.Type apexType) {
        if(String.isBlank(jsonString)) {
            return null;
        }
        return System.JSON.deserialize(jsonString, apexType);
    }

	
    public static testMethod void testControllerSimulation() {
        ASI_TH_CRM_Contract__c contract = [SELECT Id FROM ASI_TH_CRM_Contract__c LIMIT 1];
        
        PageReference pageRef = Page.ASI_CRM_SG_ContractManageAll_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contract);
		ApexPages.currentPage().getParameters().put('Id', contract.id);
		ApexPages.currentPage().getParameters().put('isSimulation', 'true');
        ASI_CRM_SG_ContractManageAll_Ctrl cmac = new ASI_CRM_SG_ContractManageAll_Ctrl(sc);
    }

}