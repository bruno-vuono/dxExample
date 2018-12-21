/**********************************************
 Dev: Juan Pablo Cubo Version: 1
**********************************************/
 /********************************************************************************
*
* MIGRACION LICENCIAS
* AUTHOR: ZIMMIC                     DATE: 16/11/2016
*
********************************************************************************/

@isTest(seeAllData=true)
public with sharing class WS03_SalesOrderHandlerInterface_AR_TEST {

    static testMethod void testBrTestCalculations(){
        LAT_BR_PriceCalculation lpc = new LAT_BR_PriceCalculation();
        LAT_BR_PriceCalculation.valueObject test = new LAT_BR_PriceCalculation.valueObject();
        LAT_BR_PriceCalculation.BusinessServiceException_x test2 = new LAT_BR_PriceCalculation.BusinessServiceException_x();
        LAT_BR_PriceCalculation.messageValueObject test3 = new LAT_BR_PriceCalculation.messageValueObject();
        LAT_BR_PriceCalculation.e1MessageList test4 = new LAT_BR_PriceCalculation.e1MessageList();
        LAT_BR_PriceCalculation.errorRecords test5 = new LAT_BR_PriceCalculation.errorRecords();
        LAT_BR_PriceCalculation.e1Message test6 = new LAT_BR_PriceCalculation.e1Message();
        LAT_BR_PriceCalculation.discountAndChargeDetailsOutput test7 = new LAT_BR_PriceCalculation.discountAndChargeDetailsOutput();
        LAT_BR_PriceCalculation.priceCatalogueDetailsOutput test8 = new LAT_BR_PriceCalculation.priceCatalogueDetailsOutput();





        // lpc.BusinessServiceException_x;
        // lpc.messageValueObject;
        // lpc.e1MessageList;
    }

    static testMethod void SalesOrderHandlerInterfaceTest(){

		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		Opportunity opp = null;
		OpportunityLineItem oli = null;
		User usuario = null;
		Product2 produto = null;
		Pricebook2 pricebook = null;
		PricebookEntry pbe = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new Product2();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.IsActive = true;
			produto.CD_Unit__c = 'UN';
			produto.Internal_id__c = '146';
			produto.QT_lead_time__c = 5;
			produto.SKU__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('Product2', 'BRA_Standard');
			insert produto;

			//Recupera o catalogo de preço padrão
			List<Pricebook2> catalogoPreco = [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1];

			//Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
			PricebookEntry entradaCatalogoPreco = new PricebookEntry();
			entradaCatalogoPreco.Pricebook2Id = catalogoPreco[0].Id;
			entradaCatalogoPreco.Product2Id = produto.Id;
			entradaCatalogoPreco.UnitPrice = 1000.00;
			entradaCatalogoPreco.IsActive = true;
			entradaCatalogoPreco.UseStandardPrice = false;
			insert entradaCatalogoPreco;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('Opportunity','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new Opportunity();
			opp.Name = 'Opp TESTE COTA';
			opp.closeDate = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.AccountId = acc.Id;
			opp.StageName = 'Novo Pedido';
			insert opp;

			//Cria um novo produto da oportunidade.
			oli = new OpportunityLineItem();
			oli.PricebookEntryId = entradaCatalogoPreco.Id;
			oli.OpportunityId = opp.Id;
			oli.UnitPrice = 12;
			oli.Quantity = 12;
			oli.Campo_de_formatacao__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74';
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
            WS03_SalesOrderHandlerInterface_AR.isForCC();
        	System.Test.startTest();
        	Utils.setMigrationDoneTest(false);
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterfaceFuture(lIdOpp);
            LAT_LATOpportunity_CodigoAcaoCancelado.isForCC();
			System.Test.stopTest();
		}
	}
    static testMethod void SalesOrderHandlerInterfaceTestB(){
        Utils.setMigrationDoneTest(true);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		LAT_Opportunity__c opp = null;
		LAT_OpportunityLineItem__c oli = null;
		User usuario = null;
		LAT_Product__c produto = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new LAT_Product__c();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.LAT_IsActive__c = true;
			produto.LAT_CDUnit__c = 'UN';
			produto.LAT_ExternalId__c = '146';
			produto.LAT_QTLeadTime__c = 5;
			produto.LAT_Sku__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('LAT_Product__c', 'BRA_Standard');
			insert produto;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new LAT_Opportunity__c();
			opp.Name = 'Opp TESTE COTA';
			opp.LAT_CloseDate__c = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.LAT_Account__c = acc.Id;
			opp.LAT_StageName__c = 'Novo Pedido';
			insert opp;

			//Cria um novo produto da oportunidade.
			oli = new LAT_OpportunityLineItem__c();
			oli.LAT_Product__c = produto.Id;
			oli.LAT_Opportunity__c = opp.Id;
			oli.LAT_UnitPrice__c = 12;
			oli.LAT_Quantity__c = 12;
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			System.Test.startTest();
        	Utils.setMigrationDoneTest(true);
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest2(){
        Utils.setMigrationDoneTest(false);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		Opportunity opp = null;
		OpportunityLineItem oli = null;
		User usuario = null;
		Product2 produto = null;
		Pricebook2 pricebook = null;
		PricebookEntry pbe = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new Product2();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.IsActive = true;
			produto.CD_Unit__c = 'UN';
			produto.Internal_id__c = '146';
			produto.QT_lead_time__c = 5;
			produto.SKU__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('Product2', 'BRA_Standard');
			insert produto;

			//Recupera o catalogo de preço padrão
			List<Pricebook2> catalogoPreco = [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1];

			//Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
			PricebookEntry entradaCatalogoPreco = new PricebookEntry();
			entradaCatalogoPreco.Pricebook2Id = catalogoPreco[0].Id;
			entradaCatalogoPreco.Product2Id = produto.Id;
			entradaCatalogoPreco.UnitPrice = 1000.00;
			entradaCatalogoPreco.IsActive = true;
			entradaCatalogoPreco.UseStandardPrice = false;
			insert entradaCatalogoPreco;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('Opportunity','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new Opportunity();
			opp.Name = 'Opp TESTE COTA';
			opp.closeDate = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.AccountId = acc.Id;
			opp.StageName = 'Novo Pedido';
			insert opp;

			//Cria um novo produto da oportunidade.
			oli = new OpportunityLineItem();
			oli.PricebookEntryId = entradaCatalogoPreco.Id;
			oli.SenttoApproveDiscount_AR__c = true;
			oli.OpportunityId = opp.Id;
			oli.UnitPrice = 12;
			oli.Quantity = 12;
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			System.Test.startTest();
        	Utils.setMigrationDoneTest(false);
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest2B(){

        Utils.setMigrationDoneTest(true);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		LAT_Opportunity__c opp = null;
		LAT_OpportunityLineItem__c oli = null;
		User usuario = null;
		LAT_Product__c produto = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');


		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new LAT_Product__c();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.LAT_IsActive__c = true;
			produto.LAT_CDUnit__c = 'UN';
			produto.LAT_ExternalId__c = '146';
			produto.LAT_QTLeadTime__c = 5;
			produto.LAT_Sku__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('LAT_Product__c', 'BRA_Standard');
			insert produto;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new LAT_Opportunity__c();
			opp.Name = 'Opp TESTE COTA';
			opp.LAT_CloseDate__c = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.LAT_Account__c = acc.Id;
			opp.LAT_StageName__c = 'Novo Pedido';
			insert opp;


			//Cria um novo produto da oportunidade.
			oli = new LAT_OpportunityLineItem__c();
			oli.LAT_Product__c = produto.Id;
			oli.LAT_AR_SentToApproveDiscount__c = true;
			oli.LAT_Opportunity__c = opp.Id;
			oli.LAT_UnitPrice__c = 12;
			oli.LAT_Quantity__c = 12;
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			System.Test.startTest();
        	Utils.setMigrationDoneTest(true);
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest3(){

		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		Opportunity opp = null;
		OpportunityLineItem oli = null;
		User usuario = null;
		Product2 produto = null;
		Pricebook2 pricebook = null;
		PricebookEntry pbe = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new Product2();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.IsActive = true;
			produto.CD_Unit__c = 'UN';
			produto.Internal_id__c = '146';
			produto.QT_lead_time__c = 5;
			produto.SKU__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('Product2', 'BRA_Standard');
			insert produto;

			//Recupera o catalogo de preço padrão
			List<Pricebook2> catalogoPreco = [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1];

			//Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
			PricebookEntry entradaCatalogoPreco = new PricebookEntry();
			entradaCatalogoPreco.Pricebook2Id = catalogoPreco[0].Id;
			entradaCatalogoPreco.Product2Id = produto.Id;
			entradaCatalogoPreco.UnitPrice = 1000.00;
			entradaCatalogoPreco.IsActive = true;
			entradaCatalogoPreco.UseStandardPrice = false;
			insert entradaCatalogoPreco;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('Opportunity','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new Opportunity();
			opp.Name = 'Opp TESTE COTA';
			opp.closeDate = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.AccountId = acc.Id;
			opp.StageName = 'Novo Pedido';
			insert opp;

			//Cria um novo produto da oportunidade.
			oli = new OpportunityLineItem();
			oli.PricebookEntryId = entradaCatalogoPreco.Id;
			oli.OpportunityId = opp.Id;
			oli.UnitPrice = 12;
			oli.Quantity = 12;
			oli.CD_Action__c = 'a';
			oli.NR_order_line__c = '1';
			oli.LAT_SkuText__c = '123';
			insert oli;


			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			Test.startTest();
			//Utils.setMigrationDoneTest(false);
			//WS03_SalesOrderHandlerInterface_AR.SalesOrderInterfaceFuture(lIdOpp);
			Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest3B(){

        Utils.setMigrationDoneTest(true);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		LAT_Opportunity__c opp = null;
		LAT_OpportunityLineItem__c oli = null;
		User usuario = null;
		LAT_Product__c produto = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new LAT_Product__c();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.LAT_IsActive__c = true;
			produto.LAT_CDUnit__c = 'UN';
			produto.LAT_ExternalId__c = '146';
			produto.LAT_QTLeadTime__c = 5;
			produto.LAT_Sku__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('LAT_Product__c', 'BRA_Standard');
			insert produto;


			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new LAT_Opportunity__c();
			opp.Name = 'Opp TESTE COTA';
			opp.LAT_CloseDate__c = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.LAT_Account__c = acc.Id;
			opp.LAT_StageName__c = 'Novo Pedido';
			insert opp;


			//Cria um novo produto da oportunidade.
			oli = new LAT_OpportunityLineItem__c();
			oli.LAT_Product__c = produto.Id;
			oli.LAT_AR_SentToApproveDiscount__c = true;
			oli.LAT_Opportunity__c = opp.Id;
			oli.LAT_UnitPrice__c = 12;
			oli.LAT_Quantity__c = 12;
			oli.LAT_CDAction__c = 'a';
			oli.LAT_NROrderLine__c = '1';
			oli.LAT_SkuText__c = '123';
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			System.Test.startTest();
			Utils.setMigrationDoneTest(true);
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest4(){
		Utils.setMigrationDoneTest(false);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		Opportunity opp = null;
		OpportunityLineItem oli = null;
		User usuario = null;
		Product2 produto = null;
		Pricebook2 pricebook = null;
		PricebookEntry pbe = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new Product2();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.IsActive = true;
			produto.CD_Unit__c = 'UN';
			produto.Internal_id__c = '146';
			produto.QT_lead_time__c = 5;
			produto.SKU__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('Product2', 'BRA_Standard');
			insert produto;

			//Recupera o catalogo de preço padrão
			List<Pricebook2> catalogoPreco = [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1];

			//Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
			PricebookEntry entradaCatalogoPreco = new PricebookEntry();
			entradaCatalogoPreco.Pricebook2Id = catalogoPreco[0].Id;
			entradaCatalogoPreco.Product2Id = produto.Id;
			entradaCatalogoPreco.UnitPrice = 1000.00;
			entradaCatalogoPreco.IsActive = true;
			entradaCatalogoPreco.UseStandardPrice = false;
			insert entradaCatalogoPreco;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('Opportunity','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new Opportunity();
			opp.Name = 'Opp TESTE COTA';
			opp.closeDate = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.AccountId = acc.Id;
			opp.StageName = 'Mobile Order';
			opp.Type = 'SV - Free Goods (Sales)';
			opp.Origem_do_pedido__c = 'APP';
			insert opp;
			System.Test.startTest();
			//Cria um novo produto da oportunidade.
			oli = new OpportunityLineItem();
			oli.PricebookEntryId = entradaCatalogoPreco.Id;
			oli.OpportunityId = opp.Id;
			oli.UnitPrice = 12;
			oli.Quantity = 12;
			oli.CD_Action__c = 'a';
			oli.NR_order_line__c = '1';
			oli.LAT_SkuText__c = '123';
			oli.cd_line_status__c = '400';
			oli.SenttoApproveDiscount_AR__c = false;


			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');

			Utils.setMigrationDoneTest(false);
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest5(){
		Utils.setMigrationDoneTest(false);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		Opportunity opp = null;
		OpportunityLineItem oli = null;
		User usuario = null;
		Product2 produto = null;
		Pricebook2 pricebook = null;
		PricebookEntry pbe = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new Product2();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.IsActive = true;
			produto.CD_Unit__c = 'UN';
			produto.Internal_id__c = '146';
			produto.QT_lead_time__c = 5;
			produto.SKU__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('Product2', 'BRA_Standard');
			insert produto;

			//Recupera o catalogo de preço padrão
			List<Pricebook2> catalogoPreco = [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1];

			//Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
			PricebookEntry entradaCatalogoPreco = new PricebookEntry();
			entradaCatalogoPreco.Pricebook2Id = catalogoPreco[0].Id;
			entradaCatalogoPreco.Product2Id = produto.Id;
			entradaCatalogoPreco.UnitPrice = 1000.00;
			entradaCatalogoPreco.IsActive = true;
			entradaCatalogoPreco.UseStandardPrice = false;
			insert entradaCatalogoPreco;

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('Opportunity','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new Opportunity();
			opp.Name = 'Opp TESTE COTA';
			opp.closeDate = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.AccountId = acc.Id;
			opp.StageName = 'Mobile Order';
			opp.Origem_do_pedido__c = 'APP';
			insert opp;
			System.Test.startTest();
			//Cria um novo produto da oportunidade.
			oli = new OpportunityLineItem();
			oli.PricebookEntryId = entradaCatalogoPreco.Id;
			oli.OpportunityId = opp.Id;
			oli.UnitPrice = 12;
			oli.Quantity = 12;
			oli.CD_Action__c = 'a';
			oli.NR_order_line__c = '1';
			oli.LAT_SkuText__c = '123';
			oli.SenttoApproveDiscount_AR__c = true;


			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');

			Utils.setMigrationDoneTest(false);
			WS03_SalesOrderHandlerInterface_AR.SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest5B(){

        Utils.setMigrationDoneTest(true);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		LAT_Opportunity__c opp = null;
		LAT_OpportunityLineItem__c oli = null;
		User usuario = null;
		LAT_Product__c produto = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new LAT_Product__c();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.LAT_IsActive__c = true;
			produto.LAT_CDUnit__c = 'UN';
			produto.LAT_ExternalId__c = '146';
			produto.LAT_QTLeadTime__c = 5;
			produto.LAT_Sku__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('LAT_Product__c', 'BRA_Standard');
			insert produto;

			System.Test.startTest();

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new LAT_Opportunity__c();
			opp.Name = 'Opp TESTE COTA';
			opp.LAT_CloseDate__c = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.LAT_Account__c = acc.Id;
			opp.LAT_StageName__c = 'Mobile Order';
			opp.LAT_OrderOrigin__c = 'APP';
			insert opp;

			opp.LAT_StageName__c = 'Approved';
			WS03_SalesOrderHandlerInterface_AR.isProcessing = false;
			update opp;

			//Cria um novo produto da oportunidade.
			oli = new LAT_OpportunityLineItem__c();
			oli.LAT_Product__c = produto.Id;
			oli.LAT_AR_SentToApproveDiscount__c = false;
			oli.LAT_Opportunity__c = opp.Id;
			oli.LAT_UnitPrice__c = 12;
			oli.LAT_Quantity__c = 12;
			oli.LAT_CDAction__c = 'a';
			oli.LAT_NROrderLine__c = '1';
			oli.LAT_SkuText__c = '123';
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			Utils.setMigrationDoneTest(true);
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
		}
	}

	static testMethod void SalesOrderHandlerInterfaceTest6B(){

        Utils.setMigrationDoneTest(true);
		//Declaração de variáveis.
		Account acc = null;
		UDC__c regional, bandeira, cidade = null;
		Profile perfil = null;
		LAT_Opportunity__c opp = null;
		LAT_OpportunityLineItem__c oli = null;
		User usuario = null;
		LAT_Product__c produto = null;
		List<RecordType> listRecType = null;
		List<String> developerName = null;
		Map<String, String> mapRecType = null;
		String idAccount = null;
		String idOpportunity = null;
		Id idRecTypeUDC = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');

		//Recupera os IDS de tipo de registro.
		idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');

		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

		System.runAs(thisUser){
			//Recupera o ID do perfil desejado.
			usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR');
		}

		System.runAs(usuario){
			//Cria nova UDC.
			regional = new UDC__c();
			regional.CodDefUsuario__c = '4546';
			regional.CodProd__c= '01';
			regional.CodUs__c= '01';
			regional.Internal_Id__c   = '1234';
			regional.RecordTypeId = idRecTypeUDC;
			insert regional;

			//Cria nova UDC.
			bandeira = new UDC__c();
			bandeira.CodDefUsuario__c = '179';
			bandeira.CodProd__c= '01';
			bandeira.CodUs__c= '06';
			bandeira.Internal_Id__c   = '1236';
			bandeira.RecordTypeId = idRecTypeUDC;
			insert bandeira;

			//Cria novo Account.
			acc = new Account();
			acc.OwnerId = usuario.Id;
			acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
			acc.CNPJ__c = '48843971000120';
			acc.Type = 'Outros';
			acc.RecordTypeId = idAccount;
			acc.Status__c = 'Cliente cadastrado no JDE';
			acc.Agency__c = '000';
			acc.Checking_account__c = '000';
			acc.Current_account__c = '0';
			acc.Corporate_Name__c = 'Teste';
			acc.Channel__c = 'Off Trade';
			//acc.Regional__c = regional.Id;
			acc.Frequency_of_Visits__c = 'Semanal';
			acc.Client_code_AN8__c = '557798';
			acc.Price_Group__c = '1';
			//acc.Customer_Flag__c = bandeira.Id;
			insert acc;

			//produto = [Select Id, Name, Sku__c From Product2 Where Sku__c = '146' AND Qtlimit 1];

			produto = new LAT_Product__c();
			produto.Name = 'Cloud2b - Produto - AtualizarEventoProdutosOportunidade';
			produto.LAT_IsActive__c = true;
			produto.LAT_CDUnit__c = 'UN';
			produto.LAT_ExternalId__c = '146';
			produto.LAT_QTLeadTime__c = 5;
			produto.LAT_Sku__c = '444';
			produto.RecordTypeId = RecordTypeForTest.getRecType('LAT_Product__c', 'BRA_Standard');
			insert produto;

			System.Test.startTest();

			//Recupera os IDS de tipo de registro.
			idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','OPP_1_NewOrder_ARG');

			//Cria nova oportunidade.
			opp = new LAT_Opportunity__c();
			opp.Name = 'Opp TESTE COTA';
			opp.LAT_CloseDate__c = System.today()+1;
			opp.RecordTypeId = idOpportunity;
			opp.LAT_Account__c = acc.Id;
			opp.LAT_StageName__c = 'Mobile Order';
			opp.LAT_OrderOrigin__c = 'APP';
			insert opp;


			//Cria um novo produto da oportunidade.
			oli = new LAT_OpportunityLineItem__c();
			oli.LAT_Product__c = produto.Id;
			oli.LAT_AR_SentToApproveDiscount__c = true;
			oli.LAT_Opportunity__c = opp.Id;
			oli.LAT_UnitPrice__c = 12;
			oli.LAT_Quantity__c = 12;
			oli.LAT_CDAction__c = 'a';
			oli.LAT_NROrderLine__c = '1';
			oli.LAT_SkuText__c = '123';
			insert oli;

			String lIdOpp = opp.Id;
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterface(lIdOpp);
			WS03_SalesOrderHandlerInterface_AR.getConnectionParameter('Argentina');
			Utils.setMigrationDoneTest(true);
			WS03_SalesOrderHandlerInterface_AR.LAT_SalesOrderInterfaceFuture(lIdOpp);
			System.Test.stopTest();
            PriceCalculationInterface.isForCC(); 
		}
	}

}