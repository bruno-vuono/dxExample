/*
 * LAT_ContractPaymentsHandlerInterface. MA integration
 * Author: Martin Prado (martin@zimmic.com)
 * Date: 02/13/2017
 */
public with sharing class LAT_ContractPaymentsHandlerInterface {

 //Constructor
 public LAT_ContractPaymentsHandlerInterface() {} 


 /**
  * sendPaymentToME
  * Integration with ME, check the payment on salesforce, DA number, fiscal year of the payment, and generate payments on ME
  * we have 3 types of payments: money,
  * @param paymentId
  */
 @future(callout = true)
 public static void sendPaymentToME(Id paymentId) {
  sendPaymentToMESync(paymentId);
 }


 /**
  * sendPaymentToME
  * Integration with ME, check the payment on salesforce, DA number, fiscal year of the payment, and generate payments on ME
  * we have 3 types of payments: money,
  * @param paymentId
  */
 public static void sendPaymentToMESync(Id paymentId) {

  CS001_JDEInterfaceCredentials__c setting = CS001_JDEInterfaceCredentials__c.getInstance('Brasil');

  List < LAT_Payment__c > payments = [SELECT(Select id,Sku_at_Integration__c,Finality__c,Status_IMM_Linea__c, ProductGroup__r.name, LAT_Contract__r.account__r.Business_Unit__r.Internal_Id__c, ProductGroup__c, Volumen__c, recordType.DeveloperName from Investimentos_Bonifica_es_e_Pagamentos__r),
   LAT_Contract__r.account__r.Business_Unit__r.name, LAT_Contract__r.account__c, LAT_Contract__r.account__r.Revenue_City__r.name, LAT_Contract__r.account__r.Client_code_AN8__c, Ammount__c, ApprovedPayment__c, CNPJ_Fornecedor__c,
   CreatedById, CreatedBy.email, CreatedDate, CurrencyIsoCode, Finality__c, GoalNotReached__c, Id, IDMe__c, integrationMessage__c, IntegrationStatus__c, IsDeleted, LastModifiedById, LastModifiedDate, LAT_Contract__c, LAT_Contract__r.name,
   Manager__c, Name, ParentPayment__c, PaymentDateDone__c, FY__c, WF__c, WFNumber__c, PaymentDate__c, ProductGroup__c, RecordTypeId, RecordType.DeveloperName, RegionalManager__c, Status__c, SystemModstamp, Type__c, Volumen__c, ProductGroup__r.name,Sku_at_Integration__c,Status_IMM_Linea__c,LAT_Contract__r.account__r.Business_Unit__r.Internal_Id__c FROM LAT_Payment__c where id = : paymentId
  ];
  LAT_Payment__c payment = null;
  Integer contractDA = null;
  String typeDa = null;
  Boolean hasAllTheInfo = false;

  // Check payment or return an error
  //if ( payments.size() == 0 ) return 'Pagamento (id:' + paymentId + ') não encontrado';
  if (payments.size() != 0) {
   payment = payments[0];
   if (payment.WFNumber__c != null && payment.WF__c != null) {
    hasAllTheInfo = true;
    contractDA = Integer.valueOf(payment.WFNumber__c);
    typeDa = payment.WF__c;
   }

   // Retrive the payment FY
   // Leronardo Change, take care of this, probably this would crash
   //String fiscalYear = LAT_FiscalYearHelper.getInstance().getFiscalYearCode(date.today());
   //System.debug('=======================\nfiscalYear' + fiscalYear+ '\n=======================' );

   // We must set the DA based on the FY, if the contract hasn't a valid DA we return an error
   //   List<LAT_ContractDA__c> conDAS = [SELECT Contract__c, DANumber__c,Fiscal_Year__c, Type__c FROM LAT_ContractDA__c where Contract__c =: payment.LAT_Contract__c and Fiscal_Year__c =: fiscalYear and status__c = 'Ativo' order by createddate desc limit 1];
   //   if ( conDAS.size() != 0 ) {
   //     contractDA = Integer.valueOf(conDAS.get(0).DANumber__c);
   //     typeDa = conDAS.get(0).Type__c;
   //     System.debug('=======================\ncontractDA' + contractDA+ '\n=======================' );
   //     hasAllTheInfo = true;
   //   }
  }

  if (hasAllTheInfo) {




   // Product Payment
   if (payment.recordType.DeveloperName == 'LAT_PagamentoProduto') {
    List < LAT_Payment__c > paysss = new List < LAT_Payment__c > ();
    paysss.add(payment);


    if (setting.UseIMM__c) {
      try {
        LAT_BR_IMM_RestCallHandler.GenericBodyIMM resp = LAT_BR_IMM_RestCallHandler.createFreeGood(paysss);
        processIMMResponse(resp, payment);
      } catch (LAT_BR_IMM_RestCallHandler.IMMException e){
          paysss[0].IntegrationStatus__c = 'Erro Integração';
          paysss[0].Status__c = 'Erro Integração';
          paysss[0].integrationMessage__c = e.messageBody;

        update paysss;
        sendEmailNotification(payment);

      } catch (LAT_BR_IMM_RestCallHandler.IMMNoskuException e){
        paysss[0].IntegrationStatus__c = 'SKU não cadastrado';
        paysss[0].Status__c = 'Erro Integração';
        
        update paysss;
        sendEmailNotification(payment);
      }
     
    } else {

     LAT_PaymentProductHandler.WSPagtoProdutoSoapBindingQSPort request = new LAT_PaymentProductHandler.WSPagtoProdutoSoapBindingQSPort();
     request.timeout_x = 120000;
     LAT_PaymentProductHandler.SdtMsg message = new LAT_PaymentProductHandler.SdtMsg();

     LAT_PaymentProductHandler.WSPagtoProduto_ExecuteResponse_element entireHandler = new LAT_PaymentProductHandler.WSPagtoProduto_ExecuteResponse_element();

     List < LAT_Payment__c > paym = new List < LAT_Payment__c > ();
     paym.add(payment);
     LAT_PaymentProductHandler.SDTPagtoLD sdtpagtold = generateProductItems(paym);
     String textMessage = payment.Finality__c + ' || ' + payment.Name + ' || ' + Datetime.now().format('MM/yyyy');
     try {
      entireHandler = request.Execute(1, 81, typeDa, Integer.valueOf(contractDA), checkLocation(payment.LAT_Contract__r.account__r.Business_Unit__r.name), String.valueOf(payment.LAT_Contract__r.account__r.Client_code_AN8__c), textMessage, textMessage, 'BILINSKY', sdtpagtold);

      message = entireHandler.SdtMsg;
     } catch (exception e) {
      sendEmailNotification(payment);
     }
     if (!Test.isRunningTest()) {
      processMEResponse(message, payment, entireHandler.Seqreq);
     } else {
      LAT_PaymentProductHandler.SdtMsg_SdtMsgItem testItem = new LAT_PaymentProductHandler.SdtMsg_SdtMsgItem();
      testItem.Codigo = 'TESTE';
      testItem.Mensagem = 'TESTE';
      message.SdtMsg_SdtMsgItem = new LAT_PaymentProductHandler.SdtMsg_SdtMsgItem[] {
       testItem
      };
      processMEResponse(message, payment, '123456');
     }

    }




   }
   // Money Payment 1 x plata siempre
   else if (payment.recordType.DeveloperName == 'LAT_PagamentoDinheiro') {
    if (setting.UseIMM__c) {
      try{
     LAT_BR_IMM_RestCallHandler.GenericBodyIMM resp = LAT_BR_IMM_RestCallHandler.createCashPayment(payment);
     processIMMResponse(resp, payment);
     } catch (LAT_BR_IMM_RestCallHandler.IMMException e){
        payment.IntegrationStatus__c = 'Erro Integração';
        payment.Status__c = 'Erro Integração';
        //payment.integrationMessage__c = e.messageBody;

        update payment;
        sendEmailNotification(payment);
      }
     
    } else {

     String textMessage = payment.Finality__c + ' || ' + payment.Name + ' || ' + Datetime.now().format('MM/yyyy');
     LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element payEl = processMoneyPayment(payment, contractDA, typeDA, textMessage);
     LAT_PaymentMoneyHandler.WSPagtoChequeSoapBindingQSPort r = new LAT_PaymentMoneyHandler.WSPagtoChequeSoapBindingQSPort();
     r.timeout_x = 120000;
     LAT_PaymentMoneyHandler.SdtMsg message = new LAT_PaymentMoneyHandler.SdtMsg();
     LAT_PaymentMoneyHandler.WSPagtoCheque_ExecuteResponse_element entireHandler = new LAT_PaymentMoneyHandler.WSPagtoCheque_ExecuteResponse_element();

     try {
      entireHandler = r.Execute(payEl);
      message = entireHandler.SdtMsg;
     } catch (exception e) {
      sendEmailNotification(payment);
     }
     if (!Test.isRunningTest()) {
      processMEResponse(message, payment, entireHandler.Seqreq);
     } else {
      LAT_PaymentMoneyHandler.SdtMsg_SdtMsgItem testItem = new LAT_PaymentMoneyHandler.SdtMsg_SdtMsgItem();
      testItem.Codigo = 'TESTE';
      testItem.Mensagem = 'TESTE';
      message.SdtMsg_SdtMsgItem = new LAT_PaymentMoneyHandler.SdtMsg_SdtMsgItem[] {
       testItem
      };
      processMEResponse(message, payment, '123456');
     }
    }
   }


   // Payment Group
   else if (payment.recordType.DeveloperName == 'LAT_PaymentGroup') {

    // If we have a payment ammount on the payment group type, we asume that the money payment are grouped
    if (payment.Ammount__c != null && payment.Ammount__c != 0) {
     if (setting.UseIMM__c) {

        try{

          LAT_BR_IMM_RestCallHandler.GenericBodyIMM resp = LAT_BR_IMM_RestCallHandler.createCashPayment(payment);
        processIMMResponse(resp, payment);

      } catch (LAT_BR_IMM_RestCallHandler.IMMException e){
        List<LAT_Payment__c> toUpdate = new List<LAT_Payment__c>();
        payment.IntegrationStatus__c = 'Erro Integração';
        payment.Status__c = 'Erro Integração';
        payment.integrationMessage__c = e.messageBody;
        toUpdate.add(payment);
        for (LAT_Payment__c childpay: payment.Investimentos_Bonifica_es_e_Pagamentos__r) {
          childpay.IntegrationStatus__c = 'Erro Integração';
          childpay.Status__c = 'Erro Integração';
          childpay.integrationMessage__c = e.messageBody;
              toUpdate.add(childpay);
            }
        update toUpdate;

        sendEmailNotification(payment);
      }
      
     } else {

      String textMessage = payment.Finality__c + ' || ' + payment.Name + ' || ' + Datetime.now().format('MM/yyyy');
      LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element payEl = processMoneyPayment(payment, contractDA, typeDA, textMessage);
      LAT_PaymentMoneyHandler.WSPagtoChequeSoapBindingQSPort r = new LAT_PaymentMoneyHandler.WSPagtoChequeSoapBindingQSPort();
      r.timeout_x = 120000;
      LAT_PaymentMoneyHandler.SdtMsg message = new LAT_PaymentMoneyHandler.SdtMsg();

      LAT_PaymentMoneyHandler.WSPagtoCheque_ExecuteResponse_element entireHandler = new LAT_PaymentMoneyHandler.WSPagtoCheque_ExecuteResponse_element();

      try {
       entireHandler = r.Execute(payEl);
       message = entireHandler.SdtMsg;
      } catch (exception e) {
       sendEmailNotification(payment);
      }
      if (!Test.isRunningTest()) {
       processMEResponse(message, payment, entireHandler.Seqreq);
      } else {
       LAT_PaymentMoneyHandler.SdtMsg_SdtMsgItem testItem = new LAT_PaymentMoneyHandler.SdtMsg_SdtMsgItem();
       testItem.Codigo = 'TESTE';
       testItem.Mensagem = 'TESTE';
       message.SdtMsg_SdtMsgItem = new LAT_PaymentMoneyHandler.SdtMsg_SdtMsgItem[] {
        testItem
       };
       processMEResponse(message, payment, '123456');
      }
     }
    } else {

      if (setting.UseIMM__c) {
         List < LAT_Payment__c > paysss = new List < LAT_Payment__c > ();
    paysss.add(payment);
    try{
      LAT_BR_IMM_RestCallHandler.GenericBodyIMM resp = LAT_BR_IMM_RestCallHandler.createFreeGoodGroup(payment, payment.Investimentos_Bonifica_es_e_Pagamentos__r);
      processIMMResponse(resp, payment);
      } catch (LAT_BR_IMM_RestCallHandler.IMMException e){
        List<LAT_Payment__c> toUpdate = new List<LAT_Payment__c>();
        payment.IntegrationStatus__c = 'Erro Integração';
        payment.Status__c = 'Erro Integração';
        //payment.integrationMessage__c = e.messageBody;
        
        toUpdate.add(payment);
        for (LAT_Payment__c childpay: payment.Investimentos_Bonifica_es_e_Pagamentos__r) {
          childpay.IntegrationStatus__c = 'Erro Integração';
        childpay.Status__c = 'Erro Integração';
        childpay.integrationMessage__c = e.messageBody;
              toUpdate.add(childpay);
            }
            
            update toUpdate;
            sendEmailNotification(payment);

      }catch (LAT_BR_IMM_RestCallHandler.IMMNoskuException e){
        List<LAT_Payment__c> toUpdate = new List<LAT_Payment__c>();
        payment.IntegrationStatus__c = 'SKU não cadastrado';
        payment.Status__c = 'Erro Integração';
        toUpdate.add(payment);
        for (LAT_Payment__c childpay: payment.Investimentos_Bonifica_es_e_Pagamentos__r) {
          childpay.IntegrationStatus__c = 'SKU não cadastrado';
        childpay.Status__c = 'Erro Integração';
              toUpdate.add(childpay);
            }
            
            update toUpdate;
            sendEmailNotification(payment);
      }
      
     } else {
     // Product payment with childs
     LAT_PaymentProductHandler.WSPagtoProdutoSoapBindingQSPort request = new LAT_PaymentProductHandler.WSPagtoProdutoSoapBindingQSPort();
     request.timeout_x = 120000;
     LAT_PaymentProductHandler.SdtMsg message = new LAT_PaymentProductHandler.SdtMsg();
     LAT_PaymentProductHandler.WSPagtoProduto_ExecuteResponse_element entireHandler = new LAT_PaymentProductHandler.WSPagtoProduto_ExecuteResponse_element();

     LAT_PaymentProductHandler.SDTPagtoLD sdtpagtold = generateProductItems(payment.Investimentos_Bonifica_es_e_Pagamentos__r);
     String textMessage = payment.Finality__c + ' || ' + payment.Name + ' || ' + Datetime.now().format('MM/yyyy');
     try {
      entireHandler = request.Execute(1, 81, typeDa, Integer.valueOf(contractDA), checkLocation(payment.LAT_Contract__r.account__r.Business_Unit__r.name), String.valueOf(payment.LAT_Contract__r.account__r.Client_code_AN8__c), textMessage, textMessage, 'BILINSKY', sdtpagtold);
      message = entireHandler.SdtMsg;
     } catch (exception e) {
      sendEmailNotification(payment);
     }
     if (!Test.isRunningTest()) {
      processMEResponse(message, payment, entireHandler.Seqreq);
     } else {
      LAT_PaymentProductHandler.SdtMsg_SdtMsgItem testItem = new LAT_PaymentProductHandler.SdtMsg_SdtMsgItem();
      testItem.Codigo = 'TESTE';
      testItem.Mensagem = 'TESTE';
      message.SdtMsg_SdtMsgItem = new LAT_PaymentProductHandler.SdtMsg_SdtMsgItem[] {
       testItem
      };
      processMEResponse(message, payment, '123456');
    }
     }
    }
   }

  } else {

   // Mail
   updatePayment(payment, 'Workflow não cadastrada para a Regional Cliente On Premise', '1', 'Error');


  }

 }

@TestVisible
 private static void processIMMResponse(LAT_BR_IMM_RestCallHandler.GenericBodyIMM message, LAT_Payment__c payment) {
   String status = 'Integrado com Sucesso';
   payment.IDMe__c = String.valueOf(message.id);
   payment.ApprovedPayment__c = false;
   payment.status__c = 'I';
   List < LAT_Payment__c > paymentsToUpdate = new List < LAT_Payment__c > ();

   payment.IntegrationStatus__c = status;
   //payment.integrationMessage__c = code + ' - ' + message;



   if (payment.recordType.DeveloperName == 'LAT_PaymentGroup' && (payment.Ammount__c == null || payment.Ammount__c == 0)) {
    system.debug('enter If+++');
      Map<String, LAT_Payment__c> skuToPaymentMap = new Map<String, LAT_Payment__c>();
      for (LAT_Payment__c pay:payment.Investimentos_Bonifica_es_e_Pagamentos__r){
        pay.IntegrationStatus__c = status;
        payment.status__c = 'I';
        payment.IntegrationStatus__c = status;
        skuToPaymentMap.put(pay.Sku_at_Integration__c, pay);
        system.debug('este sku+++' + pay.Sku_at_Integration__c);
      }
      system.debug('skuToPaymentMap+++' + skuToPaymentMap);

      for (LAT_BR_IMM_RestCallHandler.cls_skus skuRet:message.skus){
        system.debug('skuRet+++' + skuRet);
        LAT_Payment__c currPayment = skuToPaymentMap.get(skuRet.sku.code);
        if(currPayment!= null){
            system.debug('entronotnull+++' + currPayment);
            currPayment.productValue__c = skuRet.measureUnit.unitCost;
            currPayment.IntegrationStatus__c = payment.IntegrationStatus__c;
            currPayment.Status_IMM_Linea__c = skuRet.status.description;
        }


      }
      paymentsToUpdate.addall(payment.Investimentos_Bonifica_es_e_Pagamentos__r);
      
   } else if (payment.recordType.DeveloperName == 'LAT_PaymentGroup' && (payment.Ammount__c != null && payment.Ammount__c != 0)){
      for (LAT_Payment__c pay:payment.Investimentos_Bonifica_es_e_Pagamentos__r){
          pay.IntegrationStatus__c = status;
          payment.status__c = 'I';
          payment.IntegrationStatus__c = status;
        
     }
     paymentsToUpdate.addall(payment.Investimentos_Bonifica_es_e_Pagamentos__r);
   }



   if (payment.recordType.DeveloperName == 'LAT_PagamentoProduto'){
      payment.productValue__c = message.skus[0].measureUnit.unitCost;
      payment.IDPagoJDE__c = message.jdeId;
   }

  paymentsToUpdate.add(payment);
  update paymentsToUpdate;
  }

 /**
  * processMEResponse
  * Process products Payment
  */

 private static void processMEResponse(LAT_PaymentProductHandler.SdtMsg message, LAT_Payment__c payment, String numberCode) {
  System.debug('=======================\n numberCode: \n ' + numberCode + '\n=======================');
  updatePayment(payment, message.SdtMsg_SdtMsgItem[0].Mensagem, message.SdtMsg_SdtMsgItem[0].codigo, numberCode);
 }

 /**
  * processMEResponse
  * Process money Payment
  */
 private static void processMEResponse(LAT_PaymentMoneyHandler.SdtMsg message, LAT_Payment__c payment, String numberCode) {
  System.debug('=======================\n numberCode: \n ' + numberCode + '\n=======================');
  updatePayment(payment, message.SdtMsg_SdtMsgItem[0].Mensagem, message.SdtMsg_SdtMsgItem[0].codigo, numberCode);
 }

 /**
  * updatePayment
  * Update the integretion message and the status based on the ME code
  */
 private static void updatePayment(LAT_Payment__c payment, String message, String code, String numberCode) {
  System.debug('=======================\n Codigo: \n ' + code + '\n=======================');
  System.debug('=======================\n Message: \n ' + message + '\n=======================');
  String status = '';
  String subject = '';
  if (code == '00') {
   status = 'Integrado com Sucesso';
   payment.IDMe__c = numberCode;
   payment.ApprovedPayment__c = false;
   payment.status__c = 'I';
  } else {
   status = 'Erro Integração';
   payment.status__c = 'Erro Integração';
   subject = 'Erro Pagamento Contrato - ' + ' ' + payment.LAT_Contract__r.name;
   String html = 'O pagamento abaixo não foi processado.<br/><br/>Mensagem de erro: ' + code + ' ' + message + '<br/><br/>';
   html += '<b>Número contrato: </b>' + payment.LAT_Contract__r.name + '<br/>';
   if (payment.recordType.DeveloperName == 'LAT_PagamentoProduto') {
    html += '<b>Tipo Pagamento: </b>Produto<br/>';
    html += '<b>Produto: </b>' + payment.ProductGroup__r.name + '<br/>';
    html += '<b>Volumen: </b>' + payment.Volumen__c + '<br/>';
   } else if (payment.recordType.DeveloperName == 'LAT_PagamentoDinheiro') {
    html += '<b>Tipo Pagamento: </b>Dinheiro<br/>';
    html += '<b>Valor: </b>' + String.valueOf(payment.Ammount__c) + '<br/>';
   } else {
    // group
    LAT_Payment__c payType = payment.Investimentos_Bonifica_es_e_Pagamentos__r.get(0);
    if (payType.recordType.DeveloperName == 'LAT_PagamentoProduto') {
     html += '<b>Tipo Pagamento: </b>Produto<br/>';
     for (LAT_Payment__c payChild: payment.Investimentos_Bonifica_es_e_Pagamentos__r) {
      html += '<b>Produto: </b>' + payChild.ProductGroup__r.name + '<br/>';
      html += '<b>Volumen: </b>' + payChild.Volumen__c + '<br/>';
     }
    } else {
     html += '<b>Tipo Pagamento: </b>Dinheiro<br/>';
     html += '<b>Valor: </b>' + String.valueOf(payment.Ammount__c) + '<br/>';
    }
   }

   html += '<b>Data Previsão Pagamento: </b>' + payment.PaymentDate__c.month() + '/' + payment.PaymentDate__c.year() + '<br/>';
   html += '<b>Mensagem de Erro: </b>' + code + ' ' + message + '<br/>';

   system.debug(html);
   system.debug(subject);
   LAT_ContractDAHandlerInterface.sendTradeNotification(subject, html, payment.createdBy.email);

  }


  List < LAT_Payment__c > paymentsToUpdate = new List < LAT_Payment__c > ();

  payment.IntegrationStatus__c = status;
  payment.integrationMessage__c = code + ' - ' + message;


  paymentsToUpdate.add(payment);



  if (payment.Investimentos_Bonifica_es_e_Pagamentos__r.size() > 0) {
   for (LAT_Payment__c pay: payment.Investimentos_Bonifica_es_e_Pagamentos__r) {
    pay.IntegrationStatus__c = status;
    pay.integrationMessage__c = code + ' - ' + message;

    if (code == '00') {
     pay.IDMe__c = numberCode;
     pay.status__c = 'I';
     pay.ApprovedPayment__c = False;
    } else {
     pay.status__c = 'Erro Integração';
    }

    paymentsToUpdate.add(pay);
   }
  }

  update paymentsToUpdate;
 }


 /**
  * generateProductItems
  * Fill the ME product in the wsdl format
  * @return LAT_PaymentProductHandler.SDTPagtoLD
  */
 private static LAT_PaymentProductHandler.SDTPagtoLD generateProductItems(List < LAT_Payment__c > payments) {

  LAT_PaymentProductHandler.SDTPagtoLD mePayments = new LAT_PaymentProductHandler.SDTPagtoLD();
  LAT_PaymentProductHandler.SDTPagtoLD_ProdutosPagto product = new LAT_PaymentProductHandler.SDTPagtoLD_ProdutosPagto();
  List < LAT_PaymentProductHandler.SDTPagtoLD_ProdutosPagto > productList = new List < LAT_PaymentProductHandler.SDTPagtoLD_ProdutosPagto > ();

  Set < Id > products = new Set < Id > ();
  for (LAT_Payment__c pay: payments) {
   products.add(pay.ProductGroup__c);
  }

  List < LAT_ReferenceProduct__c > referenceProducts = [SELECT Id, Name, LAT_Product__c, LAT_Product__r.LAT_ProductCode__c, ReferenceGrouping__c FROM
   LAT_ReferenceProduct__c where ReferenceGrouping__c IN: products
  ];

  Map < String, Integer > productsSKU = new Map < String, Integer > ();
  for (LAT_ReferenceProduct__c lrg: referenceProducts) {
   productsSKU.put(lrg.ReferenceGrouping__c, Integer.valueOf(lrg.LAT_Product__r.LAT_ProductCode__c));
  }

  for (LAT_Payment__c pay: payments) {
   product.Produto = productsSKU.get(pay.ProductGroup__c); // SKU?
   product.Quantidade = pay.Volumen__c;
   product.DataEntrega = Date.today();
   productList.add(product);
  }

  mePayments.SDTPagtoLD_ProdutosPagto = productList;
  return mePayments;
 }

 /**
  * checkLocation
  * We must change the value for ME valid location based on the bussines unit
  * @param location bussines unit
  * @return location in ME format
  */
 private static String checkLocation(String location) {


  //businnes unit, location code 
  if (location == 'FABRICARESENDE') {
   location = 'Resende';
  } else if (location == 'FABRICASUAPE') {
   location = 'Suape';
  } else if (location == 'PRLOUVEIRA') {
   location = 'Louveira';
  } else if (location == 'PREXTREMA') {
   location = 'EXTREMA';
  }

  return location;
 }


 /**
  * processMoneyPayment
  * @return WSPagtoCheque_Execute_element
  */
 private static LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element processMoneyPayment(LAT_Payment__c payment, Double contractDA, String typeDa, String message) {
  LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element payEl = new LAT_PaymentMoneyHandler.WSPagtoCheque_Execute_element();
  payEl.Paicod = 1;
  payEl.Empcod = 81;
  payEl.Tdocod = typeDa; // payment.WF__c
  payEl.Domnro = Integer.valueOf(contractDA); //180;
  payEl.Fornecedor = payment.LAT_Contract__r.account__r.Client_code_AN8__c; // an8 cliente '10330';
  payEl.Motivo = message; // finalidade
  payEl.Valor = payment.Ammount__c; // valor 2
  payEl.Localidade = checkLocation(payment.LAT_Contract__r.account__r.Business_Unit__r.name); // 'São Paulo';//
  payEl.Usuario = 'BILINSKY';
  return payEl;
 }

 /**
  * sendEmailNotification
  * if the ME integration fails we send an email to the contract Owner
  * @param payment
  */
 private static void sendEmailNotification(LAT_Payment__c payment) {

  String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + payment.Id;
  String html = 'O pagamento abaixo não foi processado.<br/> Favor contatar o time de Trade. <a href="' + fullRecordURL + '">' + payment.Name + '</a>';
  String subject = 'Erro Pagamento Contrato - ' + payment.LAT_Contract__r.Name;

  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
  String[] mailAddress = new String[] {
   payment.createdBy.email
  };




    List<GroupMember>  groupMembers = [SELECT GroupId,UserOrGroupId, group.developerName FROM GroupMember where group.developerName= 'LAT_BR_ContractTrade'];
    if(!groupMembers.isEmpty()){

      Set<Id> uIds = new Set<Id>();
      List<User> userToNotify = new List<User>();

      for(GroupMember gm : groupMembers){
        uIds.add(gm.UserOrGroupId);
      }


      userToNotify = [Select email FROM User where id in:uIds];

      if(userToNotify.size()>0){
        for(User u : userToNotify){
          mailAddress.add(u.email);
        }

      }  
    }
  email.setToAddresses(mailAddress);
  email.setSaveAsActivity(false);
  email.setHtmlBody(html);
  email.setBccSender(false);
  email.setSubject(subject);
  email.setUseSignature(false);
  Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
   email
  });

 }

 public static LAT_BR_IMM_RestCallHandler.GenericBodyIMM getMockCashPayment(){
String json=    '{';
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
        json +='    "status": {';
    json +='        "idStatus": 4,';
    json +='        "description": "CRIADO"';
    json +='    },';
    json +='    "activity": {';
    json +='        "idActivity": 1';
    json +='    },';
    json +='    "currency": {';
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
    json +='        "currencyName": "Brazil - Re' ;
        json +='    "status": {';
    json +='        "idStatus": 4,';
    json +='        "description": "CRIADO"';
    json +='    },';
    json +='    "activity": {';
    json +='        "idActivity": 1';
    json +='    },';
    json +='    "currency": {';
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
    json +='        "currencyName": "Brazil - Re';
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
    
     String json2=    '{';
    json2 +='    "id": 175,';
    json2 +='    "type": "CP",';
    json2 +='    "documentType": "CP",';
    json2 +='    "description": "Lorem Ipsum",';
    json2 +='    "dateRequest": "2017-09-17T08:00:00.000Z",';
    json2 +='    "dateApproval": null}';
    json2 +='        "idConceptoGasto": 207,';
    json2 +='        "description": "SERVICO CRIACAO FOLHETOS SIMPLES POR PAGINA"';
    json2 +='    },';
     json2 +='    "amountPending": 0,';
    json2 +='    "amountReceived": 0,';
    json2 +='    "dateAccount": null,';
    json2 +='    "accountBatchNumber": null,';
    json2 +='    "subarea": {';
    json2 +='        "idS"';
    json2 +='    "provider": {';
    json2 +='        "id": 51557,';
     json2 +='    "id": 175,';
    json2 +='    "type": "CP",';
    json2 +='    "documentType": "CP",';
    json2 +='    "description": "Lorem Ipsum",';
    json2 +='    "dateRequest": "2017-09-17T08:00:00.000Z",';
    json2 +='    "dateApproval": null}';
    json2 +='        "idConceptoGasto": 207,';
    json2 +='        "description": "SERVICO CRIACAO FOLHETOS SIMPLES POR PAGINA"';
    json2 +='    },';
     json2 +='    "amountPending": 0,';
    json2 +='    "amountReceived": 0,';
    json2 +='    "dateAccount": null,';
    json2 +='    "accountBatchNumber": null,';
    json2 +='    "subarea": {';
    json2 +='        "idS"';
    json2 +='    "provider": {';
    json2 +='        "id": 51557,';
    json2 +='        "code": 16274,';
    json2 +='        "providerName": "CIA BRASILEIRA DE DISTRIBUICAO"';
    json2 +='    "dateAccount": null,';
    json2 +='    "accountBatchNumber": null,';
      json2 +='    "amountPending": 0,';
    json2 +='    "amountReceived": 0,';
    json2 +='    "dateAccount": null,';
    json2 +='    "accountBatchNumber": null,';
    json2 +='    "subarea": {';
    json2 +='        "idS"';
    json2 +='    "provider": {';
    json2 +='        "id": 51557,';
    json2 +='        "code": 16274,';
    json2 +='        "providerName": "CIA BRASILEIRA DE DISTRIBUICAO"';
      json2 +='    "dateAccount": null,';
    json2 +='    "accountBatchNumber": null,';
    json2 +='    "subarea": {';
    json2 +='        "idS"';
    json2 +='    "provider": {';
    json2 +='        "id": 51557,';
    json2 +='        "code": 16274,';
    json2 +='        "providerName": "CIA BRASILEIRA DE DISTRIBUICAO"';
    json2 +='    },';
    json2 +='    },';
    json2 +='    "almacen": {';
    json2 +='        "idAlmacen": 25,';
    json2 +='        "description": "Sao Paulo"';
    json2 +='    }';
    json2 +='}';

    LAT_BR_IMM_RestCallHandler.GenericBodyIMM obj = (LAT_BR_IMM_RestCallHandler.GenericBodyIMM) System.JSON.deserialize(json, LAT_BR_IMM_RestCallHandler.GenericBodyIMM.class);
    return obj;
    }



}