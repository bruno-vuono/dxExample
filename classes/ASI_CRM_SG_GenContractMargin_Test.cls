/*********************************************************************************
 * Name: ASI_CRM_SG_GenContractMargin_Test
 * Description: Test Class for ASI_CRM_SG_GenContractMarginBatch
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 16/05/2017       Hugo Cheung             Created          
 * 07/03/2018       Wilken Lee				[WL 1.0] Test method for Contract Margin ReGeneration
*/
@isTest
public class ASI_CRM_SG_GenContractMargin_Test {
    
    @TestSetup
    public static void setupData() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
        
        List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();
        
        ASI_CRM_SG_TestClassHelper.customerData customerData = new ASI_CRM_SG_TestClassHelper.customerData(true, 'TestingCustomer12345678');
        ASI_CRM_SG_TestClassHelper.wholesalesCustomerData wholesales = new ASI_CRM_SG_TestClassHelper.wholesalesCustomerData(true, 'TestingWholesales12345678');
        List<ASI_TH_CRM_Contract__c> contractList = new List<ASI_TH_CRM_Contract__c>();
        
        for(integer i = 0 ; i < 1 ; i++) {
        	ASI_CRM_SG_TestClassHelper.contractData contractData = new ASI_CRM_SG_TestClassHelper.contractData(false, customerData.customer);
            contractData.contract.ASI_TH_CRM_Start_Date__c = Date.today();
            contractData.contract.ASI_TH_CRM_End_Date__c = Date.today().addMonths(12);
            contractData.contract.ASI_TH_CRM_Contract_Status__c = 'Contract Approved';
            contractData.contract.ASI_CRM_Contract_Exist_Before_RTM__c = true;
            contractList.add(contractData.contract);
        }
        insert contractList;
        
        List<ASI_CRM_ContractTarget__c> contractTargetList = new List<ASI_CRM_ContractTarget__c>();
        for(ASI_TH_CRM_Contract__c contract : contractList) {
            for(ASI_MFM_SKU_Code__c sku : skuList) {
                ASI_CRM_SG_TestClassHelper.contractTargetData contractTargetData = new ASI_CRM_SG_TestClassHelper.contractTargetData(false, contract, sku, 20, 2);
                contractTargetList.add(contractTargetData.contractTarget);
            }
        }
        insert contractTargetList;
        
        List<ASI_TH_CRM_Actual_Offtake__c> offtakeList = new List<ASI_TH_CRM_Actual_Offtake__c>();
        for(ASI_MFM_SKU_Code__c sku : skuList) {
        	ASI_CRM_SG_TestClassHelper.offtakeData offtakeData = new ASI_CRM_SG_TestClassHelper.offtakeData(false, 'ASI_CRM_SG_Actual_offtake', contractList.get(0).Id, customerData.customer.Id, sku.Id);
        	offtakeData.offtake.ASI_CRM_FromWS__c = wholesales.customer.Id;
            offtakeList.add(offtakeData.offtake);
        }
        insert offtakeList;
    }
    
    public static testMethod void testBatch() {
        Database.executeBatch(new ASI_CRM_SG_GenContractMarginBatch(String.valueOf(Date.today().month()), String.valueOf(Date.today().year())));
		
		/*[WL 1.0] BEGIN*/
		/*String m = String.valueOf(Date.today().month());
		String y = String.valueOf(Date.today().year());
		List<ASI_CRM_Credit_Debit_Note__c> cNoteList = [SELECT Id, ASI_CRM_Contract__r.Name, Name, ASI_CRM_Status__c 
															FROM ASI_CRM_Credit_Debit_Note__c 
															WHERE ASI_CRM_Month__c = :m AND ASI_CRM_Year__c = :y 
																AND OwnerID = :UserInfo.getUserId() AND RecordType.DeveloperName like '%ASI_CRM_SG_Contract_Margin%'];
		system.debug('Batch Job Contract Margin Credit Note Size: ' + cNoteList.size());*/
		/*[WL 1.0] END*/
    }
	
	/*[WL 1.0] BEGIN*/
	public static testMethod void testASI_CRM_SG_FOCComputeCtrl_ReGen() {
		ASI_CRM_SG_FOCComputeController.computeContractMargin(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()));
		ASI_CRM_SG_FOCComputeController.deleteContractMargin(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()));
	
        Database.executeBatch(new ASI_CRM_SG_GenContractMarginBatch(String.valueOf(Date.today().month()), String.valueOf(Date.today().year())));
		
		ASI_TH_CRM_Contract__c contract = [Select Id, Name from ASI_TH_CRM_Contract__c where ASI_CRM_CN_Outlet_WS__r.Name = 'TestingCustomer12345678' LIMIT 1];
		
		system.debug('Test Contract: ' + contract);
		ASI_CRM_SG_FOCComputeController.checkBeforeDeleteCM(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()),contract.Name);
		ASI_CRM_SG_FOCComputeController.recomputeCM(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()),contract.Name);
		
		contract.recordTypeId = Global_RecordTypeCache.getRTId('ASI_TH_CRM_Contract__cASI_CRM_SG_Contract_Read_Only');
		update contract;
		
		ASI_CRM_Credit_Debit_Note__c cNote1 = new ASI_CRM_Credit_Debit_Note__c(ASI_CRM_Status__c = 'Draft', recordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Credit_Note'), ASI_CRM_Month__c = String.valueOf(Date.today().month()),  
			ASI_CRM_Year__c = String.valueOf(Date.today().year()), ASI_CRM_Contract__c = contract.Id);
		ASI_CRM_Credit_Debit_Note__c cNote2 = new ASI_CRM_Credit_Debit_Note__c(ASI_CRM_Status__c = 'Submitted', recordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Credit_Note'), ASI_CRM_Month__c = String.valueOf(Date.today().month()),  
			ASI_CRM_Year__c = String.valueOf(Date.today().year()), ASI_CRM_Contract__c = contract.Id);
		ASI_CRM_Credit_Debit_Note__c cNote3 = new ASI_CRM_Credit_Debit_Note__c(ASI_CRM_Status__c = 'Approved', recordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Contract_Margin_Credit_Note'), ASI_CRM_Month__c = String.valueOf(Date.today().month()),  
			ASI_CRM_Year__c = String.valueOf(Date.today().year()), ASI_CRM_Contract__c = contract.Id);
		
		List<ASI_CRM_Credit_Debit_Note__c> cNoteList = new List<ASI_CRM_Credit_Debit_Note__c>();
		cNoteList.add(cNote1);
		cNoteList.add(cNote2);
		cNoteList.add(cNote3);
		insert cNoteList;
		
		ASI_CRM_SG_FOCComputeController.deleteContractMargin(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()));
		
		ASI_CRM_SG_FOCComputeController.checkBeforeDeleteCM(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()),contract.Name);
		delete cNote1;
		
		ASI_CRM_SG_FOCComputeController.deleteContractMargin(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()));
		
		ASI_CRM_SG_FOCComputeController.checkBeforeDeleteCM(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()),contract.Name);
		cNote2.ASI_CRM_Status__c = 'Draft';
		update cNote2;
		delete cNote2;
		ASI_CRM_SG_FOCComputeController.checkBeforeDeleteCM(String.valueOf(Date.today().month()), String.valueOf(Date.today().year()),contract.Name);
    }
	/*[WL 1.0] END*/
}