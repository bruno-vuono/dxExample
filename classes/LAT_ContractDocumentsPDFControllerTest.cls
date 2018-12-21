@isTest
private class LAT_ContractDocumentsPDFControllerTest {

	@isTest static void test_method_one() {

		LAT_Contract2__c c = LAT_ContractsWS_Test.getContract();
		insert c;

		LAT_ContractDocs__c lcd = new LAT_ContractDocs__c();
		lcd.name = 'MinutaPadrao';
		lcd.body__c = '[STARTDATE] [ENDATE]';
		insert lcd;


		system.CurrentPageReference().getParameters().put('id',c.id);
		LAT_ContractDocumentsPDFController lpdfc = new LAT_ContractDocumentsPDFController();
	}



}