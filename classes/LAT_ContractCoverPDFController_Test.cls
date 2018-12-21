@isTest
private class LAT_ContractCoverPDFController_Test {
	
	@isTest static void test_method_one() {
		LAT_Contract2__c con = LAT_ContractsWS_Test.getContract();
		con.Status__c = 'Aprovado';
		insert con;
		system.CurrentPageReference().getParameters().put('id',con.id);
		system.CurrentPageReference().getParameters().put('type','Test');
		new LAT_ContractCoverPDFController();
		// Implement test code
	}
	
}