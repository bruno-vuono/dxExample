@isTest
private class LAT_ContractPaymentsHandlerInt_Test {
	
	@isTest static void test_method_one() {
		createCreds();
		LAT_Contract2__c con = LAT_ContractsWS_Test.getContract();
		insert con;
		LAT_ContractDA__c conDA = new LAT_ContractDA__c(
			Contract__c = con.Id, 
			DANumber__c = 12345,
			Fiscal_Year__c = 'FY17', 
			Type__c = 'TE',
			status__c = 'Ativo'
			);
		insert conDA;
		Test.startTest();
		LAT_Payment__c pay = LAT_ContractsWS_Test.getPaymentProductoWithParent(con.Id);
		insert pay;
		LAT_ContractPaymentsHandlerInterface.sendPaymentToME(pay.ParentPayment__c);

		LAT_Payment__c payDinero = LAT_ContractsWS_Test.getPaymentDinheroWithParent(con.Id);
		insert payDinero;

		LAT_ContractPaymentsHandlerInterface.sendPaymentToME(payDinero.ParentPayment__c);


		LAT_Payment__c cv = new LAT_Payment__c (
				LAT_Contract__c = con.id,
				PaymentDateDone__c = Date.today(),
				PaymentDate__c	 = Date.today(),
				RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Payment__c'+'LAT_PagamentoProduto'),
				paymentGoals__c = '<table cellpadding="4" border="0" style="width: 100%;" cellspacing="0"><thead><tr><th colspan="1" rowspan="1" style="text-align: left;">Produto</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Previsto(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Comprovado(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Meta Atingida?</th></tr></thead><tbody><tr><td colspan="1" rowspan="1"><strong>CHIVAS 12</strong></td><td colspan="1" rowspan="1">3.0</td><td colspan="1" rowspan="1">2.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>ABSOLUT REGULAR</strong></td><td colspan="1" rowspan="1">41.1</td><td colspan="1" rowspan="1">6.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>JAMESON</strong></td><td colspan="1" rowspan="1">16.5</td><td colspan="1" rowspan="1">26.0</td><td colspan="1" rowspan="1">Sim</td></tr><tr><td colspan="1" rowspan="1"><strong>CHIVAS 18</strong></td><td colspan="1" rowspan="1">0</td><td colspan="1" rowspan="1">2.1</td><td colspan="1" rowspan="1">Não</td></tr></tbody><tfoot><tr><td colspan="1" rowspan="1"><strong>TOTAL</strong></td><td colspan="1" rowspan="1"><strong>60.6</strong></td><td colspan="1" rowspan="1"><strong>36.1</strong></td><td colspan="1" rowspan="1"></td></tr></tfoot></table>',
				Status__c = 'I',
				Ammount__c = 1000.00
			);
		insert cv;
		LAT_Payment__c payGroup = LAT_ContractsWS_Test.getPaymentParent(con.Id);
		payGroup.ParentPayment__c = cv.id;
		insert payGroup;

		LAT_ContractPaymentsHandlerInterface.sendPaymentToME(payGroup.ParentPayment__c);
		//LAT_ContractPaymentsHandlerInterface.generateProductItems(new List<LAT_Payment__c>{pay});
		//LAT_ContractPaymentsHandlerInterface.processMoneyPayment(pay, 10000.00);
		//LAT_ContractPaymentsHandlerInterface.sendEmailNotification(pay);
		Test.stopTest();
	}

	@isTest static void test_method_three() {
		createCreds();
		LAT_Contract2__c con = LAT_ContractsWS_Test.getContract();
		insert con;
		LAT_ContractDA__c conDA = new LAT_ContractDA__c(
			Contract__c = con.Id, 
			DANumber__c = 12345,
			Fiscal_Year__c = 'FY17', 
			Type__c = 'TE',
			status__c = 'Ativo'
			);
		insert conDA;
		

		Test.startTest();
		LAT_Payment__c cv = new LAT_Payment__c (
				LAT_Contract__c = con.id,
				PaymentDateDone__c = Date.today(),
				PaymentDate__c	 = Date.today(),
				RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Payment__c'+'LAT_PagamentoDinheiro'),
				paymentGoals__c = '<table cellpadding="4" border="0" style="width: 100%;" cellspacing="0"><thead><tr><th colspan="1" rowspan="1" style="text-align: left;">Produto</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Previsto(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Comprovado(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Meta Atingida?</th></tr></thead><tbody><tr><td colspan="1" rowspan="1"><strong>CHIVAS 12</strong></td><td colspan="1" rowspan="1">3.0</td><td colspan="1" rowspan="1">2.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>ABSOLUT REGULAR</strong></td><td colspan="1" rowspan="1">41.1</td><td colspan="1" rowspan="1">6.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>JAMESON</strong></td><td colspan="1" rowspan="1">16.5</td><td colspan="1" rowspan="1">26.0</td><td colspan="1" rowspan="1">Sim</td></tr><tr><td colspan="1" rowspan="1"><strong>CHIVAS 18</strong></td><td colspan="1" rowspan="1">0</td><td colspan="1" rowspan="1">2.1</td><td colspan="1" rowspan="1">Não</td></tr></tbody><tfoot><tr><td colspan="1" rowspan="1"><strong>TOTAL</strong></td><td colspan="1" rowspan="1"><strong>60.6</strong></td><td colspan="1" rowspan="1"><strong>36.1</strong></td><td colspan="1" rowspan="1"></td></tr></tfoot></table>',
				Status__c = 'I',
				Ammount__c = 1000.00
			);
		insert cv;
		LAT_Payment__c payGroup = LAT_ContractsWS_Test.getPaymentParent(con.Id);
		payGroup.ParentPayment__c = cv.id;
		insert payGroup;

		LAT_ContractPaymentsHandlerInterface.sendPaymentToME(payGroup.ParentPayment__c);
		//LAT_ContractPaymentsHandlerInterface.generateProductItems(new List<LAT_Payment__c>{pay});
		//LAT_ContractPaymentsHandlerInterface.processMoneyPayment(pay, 10000.00);
		//LAT_ContractPaymentsHandlerInterface.sendEmailNotification(pay);
		Test.stopTest();
	}


	@isTest static void test_method_oneimm() {
		addIMMData();
		LAT_Contract2__c con = LAT_ContractsWS_Test.getContract();
		insert con;
		LAT_ContractDA__c conDA = new LAT_ContractDA__c(
			Contract__c = con.Id, 
			DANumber__c = 12345,
			Fiscal_Year__c = 'FY17', 
			Type__c = 'TE',
			status__c = 'Ativo'
			);
		//insert conDA;
		
		//LAT_Payment__c pay = LAT_ContractsWS_Test.getPaymentProductoWithParent(con.Id);
		//insert pay;
		system.debug('insert+++1');

		LAT_Payment__c payDinero = LAT_ContractsWS_Test.getPaymentDinheroWithParent(con.Id);
		insert payDinero;
		Test.startTest();
		try{
			LAT_ContractPaymentsHandlerInterface.sendPaymentToMESync(payDinero.ParentPayment__c);

		} catch (Exception e){system.debug('excception+++1');}


		system.debug('sigue+++1');

		//try{
		//	LAT_ContractPaymentsHandlerInterface.sendPaymentToMESync(pay.ParentPayment__c);

		//} catch (Exception e){system.debug('excception+++2');}
		
		system.debug('sigue+++2');
/**
		LAT_Payment__c cv = new LAT_Payment__c (
				LAT_Contract__c = con.id,
				PaymentDateDone__c = Date.today(),
				PaymentDate__c	 = Date.today(),
				RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Payment__c'+'LAT_PagamentoProduto'),
				paymentGoals__c = '<table cellpadding="4" border="0" style="width: 100%;" cellspacing="0"><thead><tr><th colspan="1" rowspan="1" style="text-align: left;">Produto</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Previsto(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Comprovado(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Meta Atingida?</th></tr></thead><tbody><tr><td colspan="1" rowspan="1"><strong>CHIVAS 12</strong></td><td colspan="1" rowspan="1">3.0</td><td colspan="1" rowspan="1">2.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>ABSOLUT REGULAR</strong></td><td colspan="1" rowspan="1">41.1</td><td colspan="1" rowspan="1">6.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>JAMESON</strong></td><td colspan="1" rowspan="1">16.5</td><td colspan="1" rowspan="1">26.0</td><td colspan="1" rowspan="1">Sim</td></tr><tr><td colspan="1" rowspan="1"><strong>CHIVAS 18</strong></td><td colspan="1" rowspan="1">0</td><td colspan="1" rowspan="1">2.1</td><td colspan="1" rowspan="1">Não</td></tr></tbody><tfoot><tr><td colspan="1" rowspan="1"><strong>TOTAL</strong></td><td colspan="1" rowspan="1"><strong>60.6</strong></td><td colspan="1" rowspan="1"><strong>36.1</strong></td><td colspan="1" rowspan="1"></td></tr></tfoot></table>',
				Status__c = 'I',
				Ammount__c = 1000.00
			);
		insert cv;
		system.debug('sigue+++3');
		LAT_Payment__c payGroup = LAT_ContractsWS_Test.getPaymentParent(con.Id);
		payGroup.ParentPayment__c = cv.id;
		insert payGroup;
		try {
			LAT_ContractPaymentsHandlerInterface.sendPaymentToMESync(payGroup.ParentPayment__c);	
		} catch (Exception e){system.debug('excception+++3');}
*/
		try {
		LAT_ContractPaymentsHandlerInterface.getMockCashPayment();
		LAT_ContractPaymentsHandlerInterface.processIMMResponse(LAT_ContractPaymentsHandlerInterface.getMockCashPayment(), payDinero);
		} catch (Exception e){system.debug('excception+++3111');}
		

		//LAT_ContractPaymentsHandlerInterface.generateProductItems(new List<LAT_Payment__c>{pay});
		//LAT_ContractPaymentsHandlerInterface.processMoneyPayment(pay, 10000.00);
		//LAT_ContractPaymentsHandlerInterface.sendEmailNotification(pay);
		Test.stopTest();
	}

	@isTest static void test_method_threeimm() {
		addIMMData();
		LAT_Contract2__c con = LAT_ContractsWS_Test.getContract();
		insert con;
		LAT_ContractDA__c conDA = new LAT_ContractDA__c(
			Contract__c = con.Id, 
			DANumber__c = 12345,
			Fiscal_Year__c = 'FY17', 
			Type__c = 'TE',
			status__c = 'Ativo'
			);
		insert conDA;
		

		Test.startTest();
		LAT_Payment__c cv = new LAT_Payment__c (
				LAT_Contract__c = con.id,
				PaymentDateDone__c = Date.today(),
				PaymentDate__c	 = Date.today(),
				RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Payment__c'+'LAT_PagamentoDinheiro'),
				paymentGoals__c = '<table cellpadding="4" border="0" style="width: 100%;" cellspacing="0"><thead><tr><th colspan="1" rowspan="1" style="text-align: left;">Produto</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Previsto(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Volume Comprovado(LT)</th><th colspan="1" rowspan="1" style="text-align: left;">Meta Atingida?</th></tr></thead><tbody><tr><td colspan="1" rowspan="1"><strong>CHIVAS 12</strong></td><td colspan="1" rowspan="1">3.0</td><td colspan="1" rowspan="1">2.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>ABSOLUT REGULAR</strong></td><td colspan="1" rowspan="1">41.1</td><td colspan="1" rowspan="1">6.0</td><td colspan="1" rowspan="1">Não</td></tr><tr><td colspan="1" rowspan="1"><strong>JAMESON</strong></td><td colspan="1" rowspan="1">16.5</td><td colspan="1" rowspan="1">26.0</td><td colspan="1" rowspan="1">Sim</td></tr><tr><td colspan="1" rowspan="1"><strong>CHIVAS 18</strong></td><td colspan="1" rowspan="1">0</td><td colspan="1" rowspan="1">2.1</td><td colspan="1" rowspan="1">Não</td></tr></tbody><tfoot><tr><td colspan="1" rowspan="1"><strong>TOTAL</strong></td><td colspan="1" rowspan="1"><strong>60.6</strong></td><td colspan="1" rowspan="1"><strong>36.1</strong></td><td colspan="1" rowspan="1"></td></tr></tfoot></table>',
				Status__c = 'I',
				Ammount__c = 1000.00
			);
		insert cv;
		LAT_Payment__c payGroup = LAT_ContractsWS_Test.getPaymentParent(con.Id);
		payGroup.ParentPayment__c = cv.id;
		insert payGroup;
		try {
			LAT_ContractPaymentsHandlerInterface.sendPaymentToME(payGroup.ParentPayment__c);
		} catch (Exception e){}
		 
		//LAT_ContractPaymentsHandlerInterface.generateProductItems(new List<LAT_Payment__c>{pay});
		//LAT_ContractPaymentsHandlerInterface.processMoneyPayment(pay, 10000.00);
		//LAT_ContractPaymentsHandlerInterface.sendEmailNotification(pay);
		Test.stopTest();
		
	}
	
	@isTest static void test_method_two() {
		User u = LAT_ContractsCalculationsTest.getLAT_SystemAdminUser();
		System.runAs(u) {
			Test.startTest();
			Map<String,String> mapa = new Map<String,String>();
			mapa.put('ANY key', 'ANY value');
			Test.setMock(HttpCalloutMock.class, new LAT_MockHttpResponseGenerator(1, 'Status', 'Test', mapa));
			LAT_PaymentMoneyHandler.WSPagtoCheque_ExecuteResponse_element clas = new LAT_PaymentMoneyHandler.WSPagtoCheque_ExecuteResponse_element();
			//clas.getValue();
			LAT_PaymentMoneyHandler.WSPagtoChequeSoapBindingQSPort port = new LAT_PaymentMoneyHandler.WSPagtoChequeSoapBindingQSPort();
			LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element elem = new LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element();
			port.Execute(elem);
			
			Test.stopTest();
		}
	}
	@isTest static void test_method_four() {

		User u = LAT_ContractsCalculationsTest.getLAT_SystemAdminUser();
		System.runAs(u) {
			Test.startTest();
			Map<String,String> mapa = new Map<String,String>();
			mapa.put('ANY key', 'ANY value');
			Test.setMock(HttpCalloutMock.class, new LAT_MockHttpResponseGenerator(1, 'Status', 'Test', mapa));
			
			LAT_PaymentProductHandler.WSPagtoProduto_ExecuteResponse_element clas2 = new LAT_PaymentProductHandler.WSPagtoProduto_ExecuteResponse_element();
			//clas2.getValue();
			LAT_PaymentProductHandler.SDTPagtoLD ppH = new LAT_PaymentProductHandler.SDTPagtoLD();
			LAT_PaymentProductHandler.WSPagtoProdutoSoapBindingQSPort port2 = new LAT_PaymentProductHandler.WSPagtoProdutoSoapBindingQSPort();
			port2.Execute(1,1,'TEST',1,'Test','Test','Test','Test','Test',ppH);
			Test.stopTest();
		}
	}



	public static void createCreds(){
		CS001_JDEInterfaceCredentials__c cred = new CS001_JDEInterfaceCredentials__c(
        Name = 'Brasil',
        Country__c = '1',
        EndPoint_BalanceCheck__c = 'http://crm.test.pernod-ricard.com.br/PernodRicard/BalanceCheck/BalanceCheckProxy',
        EndPoint_ContractManager__c = 'http://crm.test.pernod-ricard.com.br/SalesForce/ContractManager/ContractManagerProxy',
        EndPoint_CustomerHandler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Customer/CustomerHandlerReq',
        EndPoint_CustomerVerify__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Customer/CustomerVerifyReq',
        EndPoint_PaymentManager__c = 'http://crm.test.pernod-ricard.com.br/PernodRicard/PaymentManager/PaymentManagerProxy',
        EndPoint_PriceCalculation__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Price/PriceCalculationReq',
        EndPoint_RVManager__c = 'http://crm.test.pernod-ricard.com.br/SalesForce/RVManager/RVManagerProxy',
        EndPoint_SalesOrderHandler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/SalesOrder/AsyncSalesOrderHandlerReq',
        EndPoint_ReceiptHandeler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Collection/CollectionManagerSFDCReq',
        EndPoint_GetStock__c = 'http://crm.test.pernod-ricard.com.br/SFDC/test',
        RemoteHostIP__c = '200.200.10.10',
        System__c = 'X',
        SystemUserID__c = 'cloud2b'
    );
    insert cred;
	}

	public static void addIMMData(){
	LAT_IMM_Operations__c op = new LAT_IMM_Operations__c(EndpointUrl__c='http://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller', operation_Name_header__c ='GetFreeGood', Service_Name_Header__c='IMM', Name = 'GetFreeGood', Http_operation__c='GET', x_Api_key__c='FzH%pH32dyPU*F3B');
	LAT_IMM_Operations__c op2 = new LAT_IMM_Operations__c(userLDAP__c = 'BSOUZA01', idAlmacen__c = '40',Name = 'CreateCashPayment',operation_Name_header__c = 'CreateCashPayment', EndpointUrl__c='http://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller', Service_Name_Header__c='IMM', Http_operation__c='GET', x_Api_key__c='FzH%pH32dyPU*F3B');
	LAT_IMM_Operations__c op3 = new LAT_IMM_Operations__c(userLDAP__c = 'BSOUZA01', idAlmacen__c = '40',Name = 'GetCashPayment',operation_Name_header__c = 'GetCashPayment', EndpointUrl__c='http://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller', Service_Name_Header__c='IMM', Http_operation__c='GET', x_Api_key__c='FzH%pH32dyPU*F3B');
	LAT_IMM_Operations__c op4 = new LAT_IMM_Operations__c(userLDAP__c = 'BSOUZA01', idAlmacen__c = '40',Name = 'CreateAndSendFreeGood',operation_Name_header__c = 'CreateAndSendFreeGood', EndpointUrl__c='http://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller', Service_Name_Header__c='IMM', Http_operation__c='GET', x_Api_key__c='FzH%pH32dyPU*F3B');
	insert new List<LAT_IMM_Operations__c> {op,op2,op3,op4};

	CS001_JDEInterfaceCredentials__c cred = new CS001_JDEInterfaceCredentials__c(
        Name = 'Brasil',
        Country__c = '1',
        EndPoint_BalanceCheck__c = 'http://crm.test.pernod-ricard.com.br/PernodRicard/BalanceCheck/BalanceCheckProxy',
        EndPoint_ContractManager__c = 'http://crm.test.pernod-ricard.com.br/SalesForce/ContractManager/ContractManagerProxy',
        EndPoint_CustomerHandler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Customer/CustomerHandlerReq',
        EndPoint_CustomerVerify__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Customer/CustomerVerifyReq',
        EndPoint_PaymentManager__c = 'http://crm.test.pernod-ricard.com.br/PernodRicard/PaymentManager/PaymentManagerProxy',
        EndPoint_PriceCalculation__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Price/PriceCalculationReq',
        EndPoint_RVManager__c = 'http://crm.test.pernod-ricard.com.br/SalesForce/RVManager/RVManagerProxy',
        EndPoint_SalesOrderHandler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/SalesOrder/AsyncSalesOrderHandlerReq',
        EndPoint_ReceiptHandeler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Collection/CollectionManagerSFDCReq',
        EndPoint_GetStock__c = 'http://crm.test.pernod-ricard.com.br/SFDC/test',
        RemoteHostIP__c = '200.200.10.10',
        System__c = 'X',
        SystemUserID__c = 'cloud2b',
        UseIMM__c = true
    );
    insert cred;
	}


	public static LAT_BR_IMM_RestCallHandler.GenericBodyIMM getMockCashPayment(){
    	String json=		'{';
		json +='    "id": 175,';
		json +='    "type": "CP",';
		json +='    "documentType": "CP",';
		json +='    "description": "Lorem Ipsum",';
		json +='    "dateRequest": "2017-09-17T08:00:00.000Z",';
		json +='    "dateApproval": null,';
		json +='    "jdeStatus": "-",';
		json +='    "userName": "BSOUZA01 - Bruno Souza",';
		json +='    "login": "BSOUZA01",';
		json +='    "jdeId": "234234234",';
		json +='    "idErp": null,';
		json +='    "erpDocumentType": null,';
		json +='    "amount": 0,';
		json +='    "indBoi": 0,';
		json +='    "idAttachment": null,';
		json +='    "amountPending": 0,';
		json +='    "amountReceived": 0,';
		json +='    "dateAccount": null,';
		json +='    "accountBatchNumber": null,';
		json +='    "subarea": {';
		json +='        "idSubarea": 9';
		json +='    },';
		json +='    "status": {';
		json +='        "idStatus": 4,';
		json +='        "description": "CRIADO"';
		json +='    },';
		json +='    "activity": {';
		json +='        "idActivity": 1';
		json +='    },';
		json +='    "currency": {';
		json +='        "idCurrency": 1,';
		json +='        "exchangeRate": 1,';
		json +='        "currencyCode": "BRL",';
		json +='        "currencyName": "Brazil - Real"';
		json +='    },';
		json +='    "conceptoGasto": {';
		json +='        "idConceptoGasto": 207,';
		json +='        "description": "SERVICO CRIACAO FOLHETOS SIMPLES POR PAGINA"';
		json +='    },';
		json +='    "provider": {';
		json +='        "id": 51557,';
		json +='        "code": 16274,';
		json +='        "providerName": "CIA BRASILEIRA DE DISTRIBUICAO"';
		json +='    },';
		json +='    "almacen": {';
		json +='        "idAlmacen": 25,';
		json +='        "description": "Sao Paulo"';
		json +='    }';
		json +='}';
		LAT_BR_IMM_RestCallHandler.GenericBodyIMM obj = (LAT_BR_IMM_RestCallHandler.GenericBodyIMM) System.JSON.deserialize(json, LAT_BR_IMM_RestCallHandler.GenericBodyIMM.class);
		return obj;
    }
}