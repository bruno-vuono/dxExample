@isTest
public class LAT_ContractsCalculationsTest {

	public static User getLAT_SystemAdminUser() {
		Profile p = [SELECT Id FROM Profile WHERE Name='LAT_SystemAdministrator'];
     	User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
     	EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
     	LocaleSidKey='en_US',  ProfileId = p.Id,
 		TimeZoneSidKey='America/Los_Angeles', UserName='CaseAR@mail.com');
	    insert u2;
	    return u2;
	}
	
	public static User getLAT_BR2Vendas() {
		User man = getLAT_SystemAdminUser();
		Profile p = [SELECT Id FROM Profile WHERE Name='LAT_BR2_Vendas'];
     	User u2 = new User(Alias = 'newUser2', Email='newuser2@testorg.com',
     	EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
     	LocaleSidKey='en_US',  ProfileId = p.Id, managerid = man.Id,
 		TimeZoneSidKey='America/Los_Angeles', UserName='CaseAR2@mail.com');
	    insert u2;
	    return u2;
	}

	public static LAT_Contract2__c getTestContract() {
		LAT_Contract2__c con = new LAT_Contract2__c();
		con.TotalMoneyPerceivedValue__c = 1000.00;
		con.TotalMoneyPRBCost__c = 100.00;
		con.TotalProductsPerceivedValue__c = 10.00;
		con.TotalProductsPRBCost__c = 10.00;
		con.StartDate__c = Date.today().addDays(-105);
		con.EndDate__c = Date.today().addDays(105);
		con.Value__c = 100000.00;
		return con;
	}

	public static LAT_Payment__c getPaymentForContract(LAT_Contract2__c con) {
		LAT_ReferenceProductGrouping__c rpg = new LAT_ReferenceProductGrouping__c(
			Name = 'Volume',
			ExternalId__c = '1234',
			GroupType__c = 'SKU',
			Order__c = 10000 );
   		insert rpg;
		LAT_Payment__c pay = new LAT_Payment__c();
		pay.ProductGroup__c = rpg.Id;
		pay.LAT_Contract__c = con.Id;
		pay.Ammount__c = 100;
		pay.Volumen__c = 5;
		pay.Status__c = 'Previsto';
		pay.PaymentDate__c = Date.today().addDays(-5);
		pay.PaymentDateDone__c = Date.today().addDays(-5);
		return pay;
	}

	@isTest static void test_method_one() {
		User u = getLAT_SystemAdminUser();
		System.runAs(u) {
			insert new LAT_GeneralConfig__c (Name= 'LAT_PRODUCT_COST_CHANNELS', LAT_Value__c = '101,102,103,104,112,113,114,115,116');
			LAT_Contract2__c con = getTestContract();
			insert con;
			LAT_Payment__c pay = LAT_ContractsWS_Test.getPaymentProductoWithParent(con.Id);
			insert pay;
			LAT_ContractsCalculations contCalc = new LAT_ContractsCalculations();
			contCalc.calculateROI(1000,0);
			contCalc.calculateROI(1000,1100);
			contCalc.getQuarterInformation(con.Id, Date.today().addDays(-100),Date.today().addDays(100));
			Set<Id> idsContratos = new Set<Id>();
			idsContratos.add(con.Id);
			contCalc.calculatePaymentsInformation(idsContratos);
		}

		// Implement test code
	}

	@isTest static void test_method_two() {
		// Implement test code
		User u = getLAT_SystemAdminUser();
		System.runAs(u) {

			insert new LAT_GeneralConfig__c (Name= 'LAT_PRODUCT_COST_CHANNELS', LAT_Value__c = '101,102,103,104,112,113,114,115,116');
			LAT_Docusign_Config__c dSconfig = new LAT_Docusign_Config__c
							(ds_Username__c = 'testUsername',
						     ds_password__c='test',  
						     ds_integrationKey__c = 'test',
						     Enable_Docusign_Contracts__c = false
						     );

		insert new LAT_Docusign_Config__c();
			Id StaticResourceId = [Select Id from StaticResource limit 1].id;
			insert new LAT_GeneralConfig__c (Name= 'LAT_ContractMinutaPadrao', LAT_Value__c = StaticResourceId);
			LAT_Contract2__c con = getTestContract();
			insert con;
			LAT_Payment__c pay = LAT_ContractsWS_Test.getPaymentProductoWithParent(con.Id);
			insert pay;
			LAT_ContractsCalculations contCalc = new LAT_ContractsCalculations();
			List<Id> idsContratos = new List<Id>();
			idsContratos.add(con.Id);
			Test.startTest();
				LAT_ContractsCalculations.addAttachmentToContract(idsContratos);
				// The second time should regenrate contracts attachments
				LAT_ContractsCalculations.addAttachmentToContract(idsContratos);
				LAT_ContractsCalculations.updateOriginalDate(con.Id);
				LAT_ContractsCalculations.contractInfoAsList(con.Id);

			    LAT_ContractsCalculations.productCost cost = new LAT_ContractsCalculations.productCost();
			    cost.productId = con.Id;
			    cost.skuName = 's';
			    cost.nis = 10.00;
			    cost.ldCost = 10.00;
			    cost.distCost = 10.00;
			    cost.cmCase = 10.00;
			    cost.unitOfMeasurement = 'CA';
			    cost.hasSKU = false;
				contCalc.generatePayments(con.id, false);
				con.status__c = 'Ativo';
				con.SignaturesFlow__c = 'Consultor-Assinatura Cliente';
				update con;

				con.SignaturesFlow__c ='Assistente Regional-Contrato Assinado Recebido Consultor';
				update con;
				con.SignaturesFlow__c ='Assistente Regional-Contrato Assinado Entregue Trade';
				update con;
				con.SignaturesFlow__c ='Trade-Contrato Assinado Recebido Ass. Regional';
				update con;

				con.status__c = 'Cancelado';
				update con;
				

			Test.stopTest();
		}
	}

}