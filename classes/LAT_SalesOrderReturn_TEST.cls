/******************************************************************************
*   Company:Valuenet    Developers:Elena Schwarzböck       Date:11/12/2013    *
*******************************************************************************/

@istest

public with sharing class LAT_SalesOrderReturn_TEST {

static testMethod void SalesOrderReturnTestDen() 
    {
        Utils.setMigrationDoneTest(false); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
       
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      opp = loadData(1, acc);
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
  
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 34525;
      Integer customer_AN8_entrega = 34525;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      Test.stopTest();
    }

static testMethod void SalesOrderReturnTestDenB() 
    {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                       = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
       
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      opp = LAT_loadData(1, acc);
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
  
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 34525;
      Integer customer_AN8_entrega = 34525;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      Test.stopTest();
    }
 
    
static testMethod void SalesOrderReturnTestwaa1() 
    {
        Utils.setMigrationDoneTest(false); 
        Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
        Utils.setMigrationDoneTest(false); 
      
      opp = loadData(1, acc);
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      lSoi.Cd_product = '35';
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 34525;
      Integer customer_AN8_entrega = 34525;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      listaItem[0].orderLineStatusDescription = 'Cancelado';
  
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[0].orderLineStatusDescription = 'Aprovação';
    
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);


      Test.stopTest();
    }

static testMethod void SalesOrderReturnTestwaa1B() 
    {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                       = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
        Utils.setMigrationDoneTest(true); 
      
      opp = LAT_loadData(1, acc);
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      lSoi.Cd_product = '35';
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 34525;
      Integer customer_AN8_entrega = 34525;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      listaItem[0].orderLineStatusDescription = 'Cancelado';
  
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[0].orderLineStatusDescription = 'Aprovação';
    
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);


      Test.stopTest();
    }

    
static testMethod void SalesOrderReturnTestwaa() {
    Utils.setMigrationDoneTest(false); 
   //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;

      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      opp = loadData(1, acc);
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = '35';
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 34525;
      Integer customer_AN8_entrega = 34525;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
     
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      listaItem[0].orderLineStatusDescription = 'Cancelado';
     
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[0].orderLineStatusDescription = 'Aprovação';
     
       SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      Test.stopTest();

}

static testMethod void SalesOrderReturnTestwaaB() {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                       = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;

      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      opp = LAT_loadData(1, acc);
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = '35';
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 34525;
      Integer customer_AN8_entrega = 34525;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
     
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      listaItem[0].orderLineStatusDescription = 'Cancelado';
     
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[0].orderLineStatusDescription = 'Aprovação';
     
       SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      Test.stopTest();

}

private static Opportunity loadData(Integer pais, Account acc) {
      //Recupera os IDS de tipo de registro.

        String countryName = '';
        
        if(pais == 1){
            countryName = 'BRA_Standard';
        }else if(pais == 5){
            countryName = 'Standard_UY';
        }else if(pais == 6){
            countryName = 'Standard_AR';
        }  
      
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;

      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      insert new CS001_JDEInterfaceCredentials__c(Name='Argentina', UserName__c = 'prlatam_soaTestingUser@service.pernod-ricard2.com', Country__c = '6', EndPoint_CustomerHandler__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerHandlerReq?WSDL',
       EndPoint_CustomerVerify__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerVerifyReq?WSDL', EndPoint_PriceCalculation__c = 'http://osbdev.pramericas.com/SFDC/Price/PriceCalculationReq?WSDL', 
       EndPoint_SalesOrderHandler__c = 'http://osbdev.pramericas.com/SFDC/SalesOrder/AsyncSalesOrderHandlerReq?WSDL', RemoteHostIP__c = '200.200.10.10', SystemUserID__c = 'cloud2b', EndPoint_BalanceCheck__c = 'X',
        EndPoint_ContractManager__c = 'X', EndPoint_PaymentManager__c = 'X', EndPoint_RVManager__c = 'X',EndPoint_GetStock__c='https://osbdev.pramericas.com/JDE9/Inventory/GetStock?wsdl'); 

      insert new CS001_JDEInterfaceCredentials__c(Name='Brasil', UserName__c = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf', Country__c = '1', EndPoint_CustomerHandler__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerHandlerReq?WSDL',
       EndPoint_CustomerVerify__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerVerifyReq?WSDL', EndPoint_PriceCalculation__c = 'http://osbdev.pramericas.com/SFDC/Price/PriceCalculationReq?WSDL', 
       EndPoint_SalesOrderHandler__c = 'http://osbdev.pramericas.com/SFDC/SalesOrder/AsyncSalesOrderHandlerReq?WSDL', RemoteHostIP__c = '200.200.10.10', SystemUserID__c = 'cloud2b', EndPoint_BalanceCheck__c = 'X',
        EndPoint_ContractManager__c = 'X', EndPoint_PaymentManager__c = 'X', EndPoint_RVManager__c = 'X',EndPoint_GetStock__c='https://osbdev.pramericas.com/JDE9/Inventory/GetStock?wsdl'); 

      insert new CS001_JDEInterfaceCredentials__c(Name='Uruguay', UserName__c = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf', Country__c = '5', EndPoint_CustomerHandler__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerHandlerReq?WSDL',
       EndPoint_CustomerVerify__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerVerifyReq?WSDL', EndPoint_PriceCalculation__c = 'http://osbdev.pramericas.com/SFDC/Price/PriceCalculationReq?WSDL', 
       EndPoint_SalesOrderHandler__c = 'http://osbdev.pramericas.com/SFDC/SalesOrder/AsyncSalesOrderHandlerReq?WSDL', RemoteHostIP__c = '200.200.10.10', SystemUserID__c = 'cloud2b', EndPoint_BalanceCheck__c = 'X',
        EndPoint_ContractManager__c = 'X', EndPoint_PaymentManager__c = 'X', EndPoint_RVManager__c = 'X',EndPoint_GetStock__c='https://osbdev.pramericas.com/JDE9/Inventory/GetStock?wsdl'); 
      //Recupera o ID do perfil desejado.

      
      
      //Cria novo usuario.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','zimmicTestingUser@pernod-ricard3.com.latsb5conf','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
      insert usuario;  
        
    
      User usuario2 = new User();
      usuario2 = LAT_TestUserAdmin.userWithAdminPorf ('Nome3','Sobrenome2','NSobre3','nome3@sobrenome.com','PriceCalculationInterface2@mail.com','123jjjuuu3','ISO-8859-1','GMT','en_Us','en_Us','235','AR'); 
      insert usuario2;  

      User usuario3 = new User();
      usuario3 = LAT_TestUserAdmin.userWithAdminPorf ('Nome4','Sobrenome2','NSobre4','nome5@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu4','ISO-8859-1','GMT','en_Us','en_Us','236','UY'); 
      insert usuario3;

      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = 'Brasil'+'V00'+'-CRM-PT';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = String.valueOf(pais)+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
            
      //Cria novo catalogo
      pricebook = new Pricebook2();
      //pricebook.Name = acc.Price_Group__c;
      pricebook.IsActive = true;
      pricebook.Description = 'This is a test';
      pricebook.Id = Test.getStandardPricebookId();
      upsert pricebook;
   
      //Cria um novo produto
      produto = new Product2();
      produto.Name = 'Cloud2b';
      produto.IsActive = true;
      produto.CD_Unit__c = 'UN';      
      produto.SKU__c = '35';
      produto.Country__c = pais;
      produto.Group__c = acc.Price_Group__c;
      produto.Internal_id__c = produto.Group__c+'-'+produto.SKU__c;//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'Product2' , countryName);//'BRA_Standard'
     
      insert produto;
      System.debug('CARLOS=Internal_id__c= '+produto.Internal_id__c);
      
      //pbe = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = Test.getStandardPricebookId(), IsActive =true, UseStandardPrice = false);
       
      //insert pbe; 

      //Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
      PricebookEntry entradaCatalogoPreco = new PricebookEntry();
      entradaCatalogoPreco.Pricebook2Id = pricebook.Id;  
      entradaCatalogoPreco.Product2Id = produto.Id;
      entradaCatalogoPreco.UnitPrice = 1000.00;
      entradaCatalogoPreco.IsActive = true;
      entradaCatalogoPreco.UseStandardPrice = false;
      
      insert entradaCatalogoPreco;
      
            //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.SKU__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard' );
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;

 
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );

      //Criterio_de_cota_regional__c crit = new Criterio_de_cota_regional__c();
      //crit.Cota_nacional__c = cotaN.Id;
      //crit.Cota__c = 400;
      //crit.RecordTypeId = idRecTypeCCR;
      //insert crit;
      //List <Criterio_de_cota_regional__c> lCritList = [ SELECT id, Cliente__c  FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id limit 1 ];
      
      /*lCritList[0].Cliente__c = true;
      update lCritList[0];

      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;*/
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('Opportunity','Nova_oportunidade');
      
          //Cria nova oportunidade.
      opp = new Opportunity();
      opp.Name = 'Opp TESTE COTA';
      opp.closeDate = System.today()+1;
      opp.AccountId = acc.Id;
      opp.StageName = 'Novo Pedido';
      opp.NR_customer_order__c = '34525';
      opp.Freight__c = 'F';
      opp.NR_order_JDE__c = '12345';
      opp.CD_order_status__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.NR_order_JDE__c = pais+'-223-59-1';
      opp.Type = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;

      oli = new OpportunityLineItem();
      oli.PricebookEntryId = entradaCatalogoPreco.Id;
      oli.OpportunityId    = opp.Id;
      oli.UnitPrice        = 12;
      oli.Quantity         = 12;
      oli.cd_line_status__c = '500';
      
      insert oli;  

     
      return opp;
}

private static LAT_Opportunity__c LAT_loadData(Integer pais, Account acc) {
      //Recupera os IDS de tipo de registro.

        String countryName = '';
        
        if(pais == 1){
            countryName = 'BRA_Standard';
        }else if(pais == 5){
            countryName = 'Standard_UY';
        }else if(pais == 6){
            countryName = 'Standard_AR';
        }  
      
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                       = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;

      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      insert new CS001_JDEInterfaceCredentials__c(Name='Argentina', UserName__c = 'prlatam_soaTestingUser@service.pernod-ricard2.com', Country__c = '6', EndPoint_CustomerHandler__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerHandlerReq?WSDL',
       EndPoint_CustomerVerify__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerVerifyReq?WSDL', EndPoint_PriceCalculation__c = 'http://osbdev.pramericas.com/SFDC/Price/PriceCalculationReq?WSDL', 
       EndPoint_SalesOrderHandler__c = 'http://osbdev.pramericas.com/SFDC/SalesOrder/AsyncSalesOrderHandlerReq?WSDL', RemoteHostIP__c = '200.200.10.10', SystemUserID__c = 'cloud2b', EndPoint_BalanceCheck__c = 'X',
        EndPoint_ContractManager__c = 'X', EndPoint_PaymentManager__c = 'X', EndPoint_RVManager__c = 'X',EndPoint_GetStock__c='https://osbdev.pramericas.com/JDE9/Inventory/GetStock?wsdl'); 

      insert new CS001_JDEInterfaceCredentials__c(Name='Brasil', UserName__c = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf', Country__c = '1', EndPoint_CustomerHandler__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerHandlerReq?WSDL',
       EndPoint_CustomerVerify__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerVerifyReq?WSDL', EndPoint_PriceCalculation__c = 'http://osbdev.pramericas.com/SFDC/Price/PriceCalculationReq?WSDL', 
       EndPoint_SalesOrderHandler__c = 'http://osbdev.pramericas.com/SFDC/SalesOrder/AsyncSalesOrderHandlerReq?WSDL', RemoteHostIP__c = '200.200.10.10', SystemUserID__c = 'cloud2b', EndPoint_BalanceCheck__c = 'X',
        EndPoint_ContractManager__c = 'X', EndPoint_PaymentManager__c = 'X', EndPoint_RVManager__c = 'X',EndPoint_GetStock__c='https://osbdev.pramericas.com/JDE9/Inventory/GetStock?wsdl'); 

      insert new CS001_JDEInterfaceCredentials__c(Name='Uruguay', UserName__c = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf', Country__c = '5', EndPoint_CustomerHandler__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerHandlerReq?WSDL',
       EndPoint_CustomerVerify__c = 'http://osbdev.pramericas.com/SFDC/Customer/CustomerVerifyReq?WSDL', EndPoint_PriceCalculation__c = 'http://osbdev.pramericas.com/SFDC/Price/PriceCalculationReq?WSDL', 
       EndPoint_SalesOrderHandler__c = 'http://osbdev.pramericas.com/SFDC/SalesOrder/AsyncSalesOrderHandlerReq?WSDL', RemoteHostIP__c = '200.200.10.10', SystemUserID__c = 'cloud2b', EndPoint_BalanceCheck__c = 'X',
        EndPoint_ContractManager__c = 'X', EndPoint_PaymentManager__c = 'X', EndPoint_RVManager__c = 'X',EndPoint_GetStock__c='https://osbdev.pramericas.com/JDE9/Inventory/GetStock?wsdl'); 
      //Recupera o ID do perfil desejado.

      
      
      //Cria novo usuario.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','zimmicTestingUser@pernod-ricard3.com.latsb5conf','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
      insert usuario;  
        
    
      User usuario2 = new User();
      usuario2 = LAT_TestUserAdmin.userWithAdminPorf ('Nome3','Sobrenome2','NSobre3','nome3@sobrenome.com','PriceCalculationInterface2@mail.com','123jjjuuu3','ISO-8859-1','GMT','en_Us','en_Us','235','AR'); 
      insert usuario2;  

      User usuario3 = new User();
      usuario3 = LAT_TestUserAdmin.userWithAdminPorf ('Nome4','Sobrenome2','NSobre4','nome5@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu4','ISO-8859-1','GMT','en_Us','en_Us','236','UY'); 
      insert usuario3;

      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = 'Brasil'+'V00'+'-CRM-PT';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = String.valueOf(pais)+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
            

   
      //Cria um novo produto
      produto = new LAT_Product__c();
      produto.Name = 'Cloud2b';
      produto.LAT_IsActive__c = true;
      produto.LAT_CDUnit__c = 'UN';      
      produto.LAT_Sku__c = '35';
      produto.LAT_Country__c = pais;
      produto.LAT_Group__c = acc.Price_Group__c;
      produto.LAT_ExternalId__c = produto.LAT_Group__c+'-'+produto.LAT_SKU__c;//+'-'+produto.LAT_CdPaymentTerm__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Product__c' , countryName);//'BRA_Standard'
     
      insert produto;
      System.debug('CARLOS=LAT_ExternalId__c= '+produto.LAT_ExternalId__c);
      
      //pbe = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = Test.getStandardPricebookId(), IsActive =true, UseStandardPrice = false);
       

      
            //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.LAT_Sku__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard' );
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;

 
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );

      //Criterio_de_cota_regional__c crit = new Criterio_de_cota_regional__c();
      //crit.Cota_nacional__c = cotaN.Id;
      //crit.Cota__c = 400;
      //crit.RecordTypeId = idRecTypeCCR;
      //insert crit;
      //List <Criterio_de_cota_regional__c> lCritList = [ SELECT id, Cliente__c  FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id limit 1 ];
      
      /*lCritList[0].Cliente__c = true;
      update lCritList[0];

      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;*/
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','Nova_oportunidade');
      
          //Cria nova oportunidade.
      opp = new LAT_Opportunity__c();
      opp.Name = 'Opp TESTE COTA';
      opp.LAT_CloseDate__c = System.today()+1;
      opp.LAT_Account__c = acc.Id;
      opp.LAT_StageName__c = 'Novo Pedido';
      opp.LAT_NRCustomerOrder__c = '34525';
      opp.LAT_Freight__c = 'F';
      opp.LAT_NROrderJDE__c = '12345';
      opp.LAT_CDOrderStatus__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.LAT_NROrderJDE__c = pais+'-223-59-1';
      opp.LAT_Type__c = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;

      oli = new LAT_OpportunityLineItem__c();
      oli.LAT_Product__c = produto.Id;
      oli.LAT_Opportunity__c    = opp.Id;
      oli.LAT_UnitPrice__c        = 12;
      oli.LAT_Quantity__c         = 12;
      oli.LAT_CdLineStatus__c = '500';
      
      insert oli;  

     
      return opp;
}

static testMethod void SalesOrderReturnTestDeliveryDate7() 
{
      Utils.setMigrationDoneTest(false); 
     
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      
      opp = loadData(1, acc);
          
     
      usuario = [SELECT Id, isActive FROM User WHERE UserName = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf' LIMIT 1];
      //acc.OwnerId = usuario.Id;

      //update acc;

      
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      lSoi.cd_payment_term = 'V00';
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
         
      listaItem[1].realDeliveryDate = null;
      listaItem[0].orderLineStatusDescription = 'Cancelado';
      listaItem[0].realDeliveryDate = null;
      listaItem[1].orderLineStatusDescription = 'Cancelado';
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

     
      Test.stopTest();
    } 

static testMethod void SalesOrderReturnTestDeliveryDate7B() 
{
      Utils.setMigrationDoneTest(true); 
     
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                       = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      
      opp = LAT_loadData(1, acc);
          
     
      usuario = [SELECT Id, isActive FROM User WHERE UserName = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf' LIMIT 1];
      //acc.OwnerId = usuario.Id;

      //update acc;

      
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      lSoi.cd_payment_term = 'V00';
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
         
      listaItem[1].realDeliveryDate = null;
      listaItem[0].orderLineStatusDescription = 'Cancelado';
      listaItem[0].realDeliveryDate = null;
      listaItem[1].orderLineStatusDescription = 'Cancelado';
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

     
      Test.stopTest();
    } 



static testMethod void SalesOrderReturnTestDeliveryDate() 
{
      Utils.setMigrationDoneTest(false); 
     
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      
      opp = loadData(1, acc);
      
    
      //Cria novo Account.     
      usuario = [SELECT Id, isActive FROM User WHERE UserName = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf' LIMIT 1];
      //acc.OwnerId = usuario.Id;

      //update acc;

      
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      lSoi.cd_payment_term = 'V00';
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[1].realDeliveryDate = null;
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[1].realDeliveryDate = String.valueOf(Date.today());
      listaItem[0].orderLineStatusDescription = 'Faturado';
      listaItem[0].realDeliveryDate = String.valueOf(Date.today());

      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
    }    

static testMethod void SalesOrderReturnTestDeliveryDateB() 
{
      Utils.setMigrationDoneTest(true); 
     
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
     
      insert acc;  
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      
      opp = LAT_loadData(1, acc);
      
    
      //Cria novo Account.     
      usuario = [SELECT Id, isActive FROM User WHERE UserName = 'zimmicTestingUser@pernod-ricard3.com.latsb5conf' LIMIT 1];
      //acc.OwnerId = usuario.Id;

      //update acc;

      
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      lSoi.cd_payment_term = 'V00';
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[1].realDeliveryDate = null;
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[1].realDeliveryDate = String.valueOf(Date.today());
      listaItem[0].orderLineStatusDescription = 'Faturado';
      listaItem[0].realDeliveryDate = String.valueOf(Date.today());

      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
    }  

static testMethod void SalesOrderReturnTestDeliveryDate2()  {
      Utils.setMigrationDoneTest(false); 
     
       
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;

  

      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      opp = loadData(1, acc);
      //Cria novo Account.
     
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
     
      
      listaItem[0].orderLineStatusDescription = 'Cancelado';
      listaItem[1].orderLineStatusDescription = 'Cancelado';
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[0].orderLineStatusDescription = 'Aprovação';
      listaItem[1].orderLineStatusDescription = 'Aprovação';
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
  }    

static testMethod void SalesOrderReturnTestDeliveryDate2B()  {
      Utils.setMigrationDoneTest(true); 
     
       
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;

  

      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      opp = LAT_loadData(1, acc);
      //Cria novo Account.
     
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
     
      
      listaItem[0].orderLineStatusDescription = 'Cancelado';
      listaItem[1].orderLineStatusDescription = 'Cancelado';
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      listaItem[0].orderLineStatusDescription = 'Aprovação';
      listaItem[1].orderLineStatusDescription = 'Aprovação';
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
  }

static testMethod void SalesOrderReturnTestDeliveryDate3()

{
    Utils.setMigrationDoneTest(false); 
      //Declaração de variáveis.
    Account acc                           = null;
    UDC__c regional, bandeira, cidade, deposito     = null;
    Profile perfil                        = null;
    SKU__c sku                            = null;
    Criterio_nacional_de_cota__c critN    = null;
    Cota_nacional__c cotaN                = null;
    Cota_regional__c cotaR                = null;
    Opportunity opp                       = null;
    OpportunityLineItem oli               = null;
    User usuario                          = null;
    Product2 produto                      = null;
    Pricebook2 pricebook, pricebook2      = null;
    PricebookEntry pbe,pbe2               = null;
    List<RecordType> listRecType          = null;
    List<String> developerName            = null;
    Map<String, String> mapRecType        = null;
    String idAccount                      = null;
    String idOpportunity                  = null;
    
    acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc.Price_Group__c = '602037025';
    acc.Client_country_AN8__c = '1-8899';
    acc.Client_code_AN8__c = '8899';
    acc.Status__c = 'Cliente cadastrado no JDE';
    insert acc;



    Test.startTest();
    Utils.setMigrationDoneTest(false); 
    opp = loadData(1, acc);
    //Cria novo Account.
   
    SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
    lSoi.cd_line_status = '1';
    //lSoi.cd_payment_term = produto.cd_payment_term__c;
    lSoi.Cd_product = string.valueof(35);
    lSoi.CD_unit = '1';
    lSoi.cd_unit_bonif = '0';
    lSoi.NR_order_line_jde = 1;
    lSoi.orderLineStatusDescription = 'Aprovação';
    lSoi.PC_Bonus = 1;
    lSoi.pc_discount = 1;
    lSoi.priceComponents = '1';
    lSoi.QT_Bonus = 0;
    lSoi.QT_sales = 1;
    lSoi.Vl_Valor = 1;
    lSoi.realDeliveryDate = null;
    
    SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
    lSoi2.cd_line_status = '1';
    //lSoi.cd_payment_term = produto.cd_payment_term__c;
    lSoi2.Cd_product = string.valueof(35);
    lSoi2.CD_unit = '1';
    lSoi2.cd_unit_bonif = '0';
    lSoi2.NR_order_line_jde = 1;
    lSoi2.orderLineStatusDescription = 'Faturado';
    lSoi2.PC_Bonus = 1;
    lSoi2.pc_discount = 1;
    lSoi2.priceComponents = '1';
    lSoi2.QT_Bonus = 0;
    lSoi2.QT_sales = 1;
    lSoi2.Vl_Valor = 1;
    lSoi2.realDeliveryDate = String.valueOf(Date.today());

    List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
    lSalesOI.add(lSoi);
    lSalesOI.add(lSoi2);
   
    
    Integer Country = 1;
    String cd_salesman = null;
    String NR_order_crm = opp.Id;
    Integer NR_order_JDE = 59;
    Integer customer_AN8 = 8899;
    Integer customer_AN8_entrega = 8899;
    String NR_customer_order = '1';
    String companyCode = '1';
    String DS_message1 = 'MSG1';
    String DS_message2 = 'MSG2';
    String DT_delivery = String.ValueOf(System.now());
    String Freight = 'F';
    String DT_Order = String.ValueOf(System.now());
    String DT_Faturamento = String.ValueOf(System.now());
    String CD_Order_Type = 'teste';
    Integer cd_order_status = 1;
    String CD_Deposito = '4433';
    String SalesOrder_Source = 'F';
    String priceComponents = '';
    integer returnCode = 0;
    String returnMessage = 'Erro';
    String purchaseOrderUntil = '';
    String retentionReason = '';
    String paymentTerm = '';
    List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;

    SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
      DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

    SalesOrder_Source = 'C';
    opp.RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity'+'OPP_4_HeaderBlocked_URU' );
    update opp;

    SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
      DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
    

    opp.RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity'+'OPP_3_HeaderBlocked_ARG' );
    update opp;

    SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
      DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
    Test.stopTest();
}

static testMethod void SalesOrderReturnTestDeliveryDate3B()

{
    Utils.setMigrationDoneTest(true); 
     
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
    acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc.Price_Group__c = '602037025';
    acc.Client_country_AN8__c = '1-8899';
    acc.Client_code_AN8__c = '8899';
    acc.Status__c = 'Cliente cadastrado no JDE';
    insert acc;



    Test.startTest();
    Utils.setMigrationDoneTest(true); 
    opp = LAT_loadData(1, acc);
    //Cria novo Account.
   
    SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
    lSoi.cd_line_status = '1';
    //lSoi.cd_payment_term = produto.cd_payment_term__c;
    lSoi.Cd_product = string.valueof(35);
    lSoi.CD_unit = '1';
    lSoi.cd_unit_bonif = '0';
    lSoi.NR_order_line_jde = 1;
    lSoi.orderLineStatusDescription = 'Aprovação';
    lSoi.PC_Bonus = 1;
    lSoi.pc_discount = 1;
    lSoi.priceComponents = '1';
    lSoi.QT_Bonus = 0;
    lSoi.QT_sales = 1;
    lSoi.Vl_Valor = 1;
    lSoi.realDeliveryDate = null;
    
    SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
    lSoi2.cd_line_status = '1';
    //lSoi.cd_payment_term = produto.cd_payment_term__c;
    lSoi2.Cd_product = string.valueof(35);
    lSoi2.CD_unit = '1';
    lSoi2.cd_unit_bonif = '0';
    lSoi2.NR_order_line_jde = 1;
    lSoi2.orderLineStatusDescription = 'Faturado';
    lSoi2.PC_Bonus = 1;
    lSoi2.pc_discount = 1;
    lSoi2.priceComponents = '1';
    lSoi2.QT_Bonus = 0;
    lSoi2.QT_sales = 1;
    lSoi2.Vl_Valor = 1;
    lSoi2.realDeliveryDate = String.valueOf(Date.today());

    List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
    lSalesOI.add(lSoi);
    lSalesOI.add(lSoi2);
   
    
    Integer Country = 1;
    String cd_salesman = null;
    String NR_order_crm = opp.Id;
    Integer NR_order_JDE = 59;
    Integer customer_AN8 = 8899;
    Integer customer_AN8_entrega = 8899;
    String NR_customer_order = '1';
    String companyCode = '1';
    String DS_message1 = 'MSG1';
    String DS_message2 = 'MSG2';
    String DT_delivery = String.ValueOf(System.now());
    String Freight = 'F';
    String DT_Order = String.ValueOf(System.now());
    String DT_Faturamento = String.ValueOf(System.now());
    String CD_Order_Type = 'teste';
    Integer cd_order_status = 1;
    String CD_Deposito = '4433';
    String SalesOrder_Source = 'F';
    String priceComponents = '';
    integer returnCode = 0;
    String returnMessage = 'Erro';
    String purchaseOrderUntil = '';
    String retentionReason = '';
    String paymentTerm = '';
    List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;

    SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
      DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

    SalesOrder_Source = 'C';
    opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c'+'OPP_4_HeaderBlocked_URU' );
    update opp;

    SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
      DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
    

    opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c'+'OPP_3_HeaderBlocked_ARG' );
    update opp;

    SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
      DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
    Test.stopTest();
}


static testMethod void SalesOrderReturnTestDeliveryDate5() 
 {
      Utils.setMigrationDoneTest(false); 
           //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;

  

      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      opp = loadData(1, acc);
      //Cria novo Account.
     
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = Integer.valueOf(acc.Client_code_AN8__c);
      Integer customer_AN8_entrega =  Integer.valueOf(acc.Client_code_AN8__c);
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'E';//E
      String priceComponents = '';
      Integer returnCode = 1;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
     
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
    
      SalesOrder_Source = 'C';
      opp.RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity'+'OPP_4_HeaderBlocked_URU' );
      update opp;

      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      

      opp.RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity'+'OPP_3_HeaderBlocked_ARG' );
      update opp;

      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      Test.stopTest();
}

static testMethod void SalesOrderReturnTestDeliveryDate5B() 
 {
      Utils.setMigrationDoneTest(true); 
           //Declaração de variáveis.
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;

  

      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      opp = LAT_loadData(1, acc);
      //Cria novo Account.
     
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = Integer.valueOf(acc.Client_code_AN8__c);
      Integer customer_AN8_entrega =  Integer.valueOf(acc.Client_code_AN8__c);
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'E';//E
      String priceComponents = '';
      Integer returnCode = 1;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
     
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
    
      SalesOrder_Source = 'C';
      opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c'+'OPP_4_HeaderBlocked_URU' );
      update opp;

      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      

      opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c'+'OPP_3_HeaderBlocked_ARG' );
      update opp;

      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      Test.stopTest();
}

static testMethod void SalesOrderReturnTestDeliveryDate4() 
    {
      Utils.setMigrationDoneTest(false); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = TestFactory.createStandardUser('UserTest');
      usuario.isActive = false;
      insert usuario;
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      insert acc;
     
      //Recupera o catalogo de preço padrão
     
      
      //Cria novo catalogo
      pricebook = new Pricebook2();
      pricebook.IsActive = true;
      pricebook.Id = Test.getStandardPricebookId();
      upsert pricebook;
      
      //Cria um novo produto
      produto = new Product2();
      produto.Name = 'Cloud2b';
      produto.IsActive = true;
      produto.CD_Unit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.SKU__c = '35';
      produto.Country__c = 1;
      produto.Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.Internal_id__c = produto.Group__c+'-'+produto.SKU__c;//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'Product2' , 'BRA_Standard' );
      insert produto;
    
      
      //Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
      PricebookEntry entradaCatalogoPreco = new PricebookEntry();
      entradaCatalogoPreco.Pricebook2Id = pricebook.Id;  
      entradaCatalogoPreco.Product2Id = produto.Id;
      entradaCatalogoPreco.UnitPrice = 1000.00;
      entradaCatalogoPreco.IsActive = true;
      entradaCatalogoPreco.UseStandardPrice = false;
      insert entradaCatalogoPreco;
      
      //Cria nova entrada de catalogo
      //pbe = new PricebookEntry();
      //pbe.Pricebook2Id = pricebook.Id;  
      //pbe.Product2Id = produto.Id;
      //pbe.UnitPrice = 100.00;
      //pbe.IsActive = true;
      //pbe.UseStandardPrice = false;
      //insert pbe;
        
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.SKU__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard' );
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
      
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('Opportunity','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new Opportunity();
      opp.Name = 'Opp TESTE COTA';
      opp.closeDate = System.today()+1;
      opp.AccountId = acc.Id;
      opp.StageName = 'Novo Pedido';
      opp.NR_customer_order__c = '34525';
      opp.Freight__c = 'F';
      opp.NR_order_JDE__c = '12345';
      opp.CD_order_status__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.NR_order_JDE__c = '1-223-59-1';
      opp.Type = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;
      
      //Cria um novo produto da oportunidade.
      oli = new OpportunityLineItem();
      oli.PricebookEntryId = entradaCatalogoPreco.Id;
      oli.OpportunityId    = opp.Id;
      oli.UnitPrice        = 12;
      oli.Quantity         = 12;
      oli.cd_line_status__c = '500';
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = Integer.valueOf(acc.Client_code_AN8__c);
      Integer customer_AN8_entrega =  Integer.valueOf(acc.Client_code_AN8__c);
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'E';//E
      String priceComponents = '';
      Integer returnCode = 1;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
     
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
   
      listaItem[0].orderLineStatusDescription = 'Faturado';  
      listaItem[1].orderLineStatusDescription = 'Faturado'; 
       
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
    }   

static testMethod void SalesOrderReturnTestDeliveryDate4B() 
    {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
            //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = TestFactory.createStandardUser('UserTest');
      usuario.isActive = false;
      insert usuario;
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      insert acc;
     
      //Recupera o catalogo de preço padrão
   
      
      //Cria um novo produto
      produto = new LAT_Product__c();
      produto.Name = 'Cloud2b';
      produto.LAT_IsActive__c = true;
      produto.LAT_CDUnit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.LAT_Sku__c = '35';
      produto.LAT_Country__c = 1;
      produto.LAT_Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.LAT_ExternalId__c = produto.LAT_Group__c+'-'+produto.LAT_Sku__c;//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Product__c' , 'BRA_Standard' );
      insert produto;
    
 
      
      //Cria nova entrada de catalogo
      //pbe = new PricebookEntry();
      //pbe.Pricebook2Id = pricebook.Id;  
      //pbe.Product2Id = produto.Id;
      //pbe.UnitPrice = 100.00;
      //pbe.IsActive = true;
      //pbe.UseStandardPrice = false;
      //insert pbe;
        
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.LAT_Sku__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard' );
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
      
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new LAT_Opportunity__c();
      opp.Name = 'Opp TESTE COTA';
      opp.LAT_CloseDate__c = System.today()+1;
      opp.LAT_Account__c = acc.Id;
      opp.LAT_StageName__c = 'Novo Pedido';
      opp.LAT_NRCustomerOrder__c = '34525';
      opp.LAT_Freight__c = 'F';
      opp.LAT_NROrderJDE__c = '12345';
      opp.LAT_CDOrderStatus__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.LAT_NROrderJDE__c = '1-223-59-1';
      opp.LAT_Type__c = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;
      
      //Cria um novo produto da oportunidade.
      oli = new LAT_OpportunityLineItem__c();
      oli.LAT_Product__c = produto.Id;
      oli.LAT_Opportunity__c    = opp.Id;
      oli.LAT_UnitPrice__c        = 12;
      oli.LAT_Quantity__c       = 12;
      oli.LAT_CdLineStatus__c = '500';
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = Integer.valueOf(acc.Client_code_AN8__c);
      Integer customer_AN8_entrega =  Integer.valueOf(acc.Client_code_AN8__c);
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'E';//E
      String priceComponents = '';
      Integer returnCode = 1;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
     
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
   
      listaItem[0].orderLineStatusDescription = 'Faturado';  
      listaItem[1].orderLineStatusDescription = 'Faturado'; 
       
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
    }  

static testMethod void SalesOrderReturnTestDeliveryDate8() 
    {
      Utils.setMigrationDoneTest(false); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = TestFactory.createStandardUser('UserTest');
      usuario.isActive = false;
      insert usuario;
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
     
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
     
      //Recupera o catalogo de preço padrão
     
      
      //Cria novo catalogo
      pricebook = new Pricebook2();
      pricebook.IsActive = true;
      pricebook.Id = Test.getStandardPricebookId();
      upsert pricebook;
      
      //Cria um novo produto
      produto = new Product2();
      produto.Name = 'Cloud2b';
      produto.IsActive = true;
      produto.CD_Unit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.SKU__c = '35';
      produto.Country__c = 1;
      produto.Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.Internal_id__c = produto.Group__c+'-'+produto.SKU__c;//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'Product2' , 'BRA_Standard' );
      insert produto;
    
      
      //Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
      PricebookEntry entradaCatalogoPreco = new PricebookEntry();
      entradaCatalogoPreco.Pricebook2Id = pricebook.Id;  
      entradaCatalogoPreco.Product2Id = produto.Id;
      entradaCatalogoPreco.UnitPrice = 1000.00;
      entradaCatalogoPreco.IsActive = true;
      entradaCatalogoPreco.UseStandardPrice = false;
      insert entradaCatalogoPreco;
      
      //Cria nova entrada de catalogo
      //pbe = new PricebookEntry();
      //pbe.Pricebook2Id = pricebook.Id;  
      //pbe.Product2Id = produto.Id;
      //pbe.UnitPrice = 100.00;
      //pbe.IsActive = true;
      //pbe.UseStandardPrice = false;
      //insert pbe;
        
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.SKU__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard' );
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
      
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('Opportunity','Nova_oportunidade');
       Test.startTest();
      Utils.setMigrationDoneTest(false); 
      //Cria nova oportunidade.
      opp = new Opportunity();
      opp.Name = 'Opp TESTE COTA';
      opp.closeDate = System.today()+1;
      opp.AccountId = acc.Id;
      opp.StageName = 'Novo Pedido';
      opp.NR_customer_order__c = '34525';
      opp.Freight__c = 'F';
      opp.NR_order_JDE__c = '12345';
      opp.CD_order_status__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.NR_order_JDE__c = '1-223-59-1';
      opp.Type = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;
      
      //Cria um novo produto da oportunidade.
      oli = new OpportunityLineItem();
      oli.PricebookEntryId = entradaCatalogoPreco.Id;
      oli.OpportunityId    = opp.Id;
      oli.UnitPrice        = 12;
      oli.Quantity         = 12;
      oli.cd_line_status__c = '500';
      
      //insert oli;
       SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      lSoi.cd_payment_term = 'V00';
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
   
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
    }   

static testMethod void SalesOrderReturnTestDeliveryDate8B() 
    {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
           //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = TestFactory.createStandardUser('UserTest');
      usuario.isActive = false;
      insert usuario;
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
     
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
     
      //Recupera o catalogo de preço padrão
      //Cria um novo produto
      produto = new LAT_Product__c();
      produto.Name = 'Cloud2b';
      produto.LAT_IsActive__c = true;
      produto.LAT_CDUnit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.LAT_Sku__c = '35';
      produto.LAT_Country__c = 1;
      produto.LAT_Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.LAT_ExternalId__c = produto.LAT_Group__c+'-'+produto.LAT_Sku__c;//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Product__c' , 'BRA_Standard' );
      insert produto;

      //Cria nova entrada de catalogo
      //pbe = new PricebookEntry();
      //pbe.Pricebook2Id = pricebook.Id;  
      //pbe.Product2Id = produto.Id;
      //pbe.UnitPrice = 100.00;
      //pbe.IsActive = true;
      //pbe.UseStandardPrice = false;
      //insert pbe;
        
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.LAT_Sku__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard' );
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
      
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new LAT_Opportunity__c();
      opp.Name = 'Opp TESTE COTA';
      opp.LAT_CloseDate__c = System.today()+1;
      opp.LAT_Account__c = acc.Id;
      opp.LAT_StageName__c = 'Novo Pedido';
      opp.LAT_NRCustomerOrder__c = '34525';
      opp.LAT_Freight__c = 'F';
      opp.LAT_NROrderJDE__c = '12345';
      opp.LAT_CDOrderStatus__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.LAT_NROrderJDE__c = '1-223-59-1';
      opp.LAT_Type__c = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;
      
      //Cria um novo produto da oportunidade.
      oli = new LAT_OpportunityLineItem__c();
      oli.LAT_Product__c = produto.Id;
      oli.LAT_Opportunity__c    = opp.Id;
      oli.LAT_UnitPrice__c        = 12;
      oli.LAT_Quantity__c       = 12;
      oli.LAT_CdLineStatus__c = '500';
      
      //insert oli;
       SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      lSoi.cd_payment_term = 'V00';
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);
     
      
      Integer Country = 1;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega = 8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
   
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);

      Test.stopTest();
    }   


static testMethod void SalesOrderReturnTestDeliveryDateUY1() {
      Utils.setMigrationDoneTest(false); 
     Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
 

      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      opp = loadData(5, acc);
     
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);

      Integer Country = 5;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega =  8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      

      LAT_SalesOrderReturn.LAT_ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      SalesOrder_Source = 'F';
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      Test.stopTest();
  }

static testMethod void SalesOrderReturnTestDeliveryDateUY1B() {
      Utils.setMigrationDoneTest(true); 
           //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '1-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
 

      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      opp = LAT_loadData(5, acc);
     
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'Aprovação';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      SalesOrderReturn.SalesOrderItem lSoi2 = new SalesOrderReturn.SalesOrderItem();
      lSoi2.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi2.Cd_product = string.valueof(35);
      lSoi2.CD_unit = '1';
      lSoi2.cd_unit_bonif = '0';
      lSoi2.NR_order_line_jde = 1;
      lSoi2.orderLineStatusDescription = 'Faturado';
      lSoi2.PC_Bonus = 1;
      lSoi2.pc_discount = 1;
      lSoi2.priceComponents = '1';
      lSoi2.QT_Bonus = 0;
      lSoi2.QT_sales = 1;
      lSoi2.Vl_Valor = 1;
      lSoi2.realDeliveryDate = String.valueOf(Date.today());

      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      lSalesOI.add(lSoi2);

      Integer Country = 5;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega =  8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = 'teste';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      

      LAT_SalesOrderReturn.LAT_ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      SalesOrder_Source = 'F';
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      Test.stopTest();
  }

static testMethod void SalesOrderReturnTestDeliveryDateAR() 
    {
      Utils.setMigrationDoneTest(false); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','AR'); 
      insert usuario;
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
      acc = LAT_Account_TestFactory.getAccountOffTradeArg();
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '6-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
     
      //Recupera o catalogo de preço padrão
      List<Pricebook2> catalogoPreco = [SELECT Id, Description FROM Pricebook2 WHERE isStandard = true limit 1];
      
      //Cria novo catalogo
      pricebook = new Pricebook2();
      //pricebook.Name = acc.Price_Group__c;
      pricebook.IsActive = true;
      pricebook.Id = Test.getStandardPricebookId();
      upsert pricebook;
      
      //Cria um novo produto
      produto = new Product2();
      produto.Name = 'Cloud2b';
      produto.IsActive = true;
      produto.CD_Unit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.SKU__c = '35';
      produto.Country__c = 6;
      produto.Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.Internal_id__c = produto.Country__c+'-'+string.valueof(35);//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'Product2' , 'Standard_AR' );
      insert produto;
      System.debug('CARLOS=Internal_id__c= '+produto.Internal_id__c);
      
      //Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
 
      PricebookEntry pbe1 = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = Test.getStandardPricebookId(), IsActive =true);
       
      insert pbe1;
              
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.SKU__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard');
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
      
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('Opportunity','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new Opportunity();
      opp.Name = 'Opp TESTE COTA';
      opp.closeDate = System.today()+1;
      opp.AccountId = acc.Id;
      opp.StageName = 'Novo Pedido';
      opp.NR_customer_order__c = '34525';
      opp.Freight__c = 'F';
      opp.NR_order_JDE__c = '12345';
      opp.CD_order_status__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.NR_order_JDE__c = '6-223-59-1';
      //opp.Type = SalesOrderReturn.getOrderType(6, 'teste');
      insert opp;

      //Cria um novo produto da oportunidade.
      oli = new OpportunityLineItem();
      oli.PricebookEntryId = pbe1.Id;
      oli.OpportunityId    = opp.Id;
      oli.UnitPrice        = 12;
      oli.Quantity         = 12;
      oli.cd_line_status__c = '500';
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      
      Integer Country = 6;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega =  8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      LAT_SalesOrderReturn.LAT_ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      SalesOrder_Source = 'F';
      
      SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      Test.stopTest();
    }    

static testMethod void SalesOrderReturnTestDeliveryDateARB() 
    {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
           //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','AR'); 
      insert usuario;
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
      acc = LAT_Account_TestFactory.getAccountOffTradeArg();
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '6-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
      
      //Cria um novo produto
      produto = new LAT_Product__c();
      produto.Name = 'Cloud2b';
      produto.LAT_IsActive__c = true;
      produto.LAT_CDUnit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.LAT_Sku__c = '35';
      produto.LAT_Country__c = 6;
      produto.LAT_Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.LAT_ExternalId__c = produto.LAT_Country__c+'-'+string.valueof(35);//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Product__c' , 'Standard_AR' );
      insert produto;
              
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.LAT_Sku__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard');
      insert critN;
      
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
      
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      COTAr.RecordTypeId = idRecTypeCr;
      insert cotaR;

       //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new LAT_Opportunity__c();
      opp.Name = 'Opp TESTE COTA';
      opp.LAT_CloseDate__c = System.today()+1;
      opp.LAT_Account__c = acc.Id;
      opp.LAT_StageName__c = 'Novo Pedido';
      opp.LAT_NRCustomerOrder__c = '34525';
      opp.LAT_Freight__c = 'F';
      opp.LAT_NROrderJDE__c = '12345';
      opp.LAT_CDOrderStatus__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.LAT_NROrderJDE__c = '6-223-59-1';
      //opp.LAT_Type__c = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;
      
      //Cria um novo produto da oportunidade.
      oli = new LAT_OpportunityLineItem__c();
      oli.LAT_Product__c = produto.Id;
      oli.LAT_Opportunity__c    = opp.Id;
      oli.LAT_UnitPrice__c        = 12;
      oli.LAT_Quantity__c       = 12;
      oli.LAT_CdLineStatus__c = '500';
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      
      Integer Country = 6;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega =  8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      LAT_SalesOrderReturn.LAT_ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      SalesOrder_Source = 'F';
      
      SalesOrderReturn.ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      Test.stopTest();
    }  

static testMethod void SalesOrderReturnTestDeliveryDateUY() 
    {
      Utils.setMigrationDoneTest(false); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      Opportunity opp                       = null;
      OpportunityLineItem oli               = null;
      User usuario                          = null;
      Product2 produto                      = null;
      Pricebook2 pricebook, pricebook2      = null;
      PricebookEntry pbe,pbe2               = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','UY'); 
      insert usuario;  
        
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
      acc = LAT_Account_TestFactory.getAccountOffTradeArg();
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '6-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
     
      //Recupera o catalogo de preço padrão
      //List<Pricebook2> catalogoPreco = [SELECT Id, Description FROM Pricebook2 WHERE isStandard = true limit 1];
      
      //Cria novo catalogo
      pricebook = new Pricebook2();
      //pricebook.Name = acc.Price_Group__c;
      pricebook.IsActive = true;
      pricebook.Id = Test.getStandardPricebookId();  
      upsert pricebook;
      List< Pricebook2 > priceL = [select id from Pricebook2 where isStandard = true];
      System.debug('#######################################################  priceL ' + priceL);

      //Cria um novo produto
      produto = new Product2();
      produto.Name = 'Cloud2b';
      produto.IsActive = true;
      produto.CD_Unit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.SKU__c = '35';
      produto.Country__c = 5;
      produto.Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.Internal_id__c = produto.Country__c+'-'+string.valueof(35);//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'Product2' , 'Standard_UY' );
      insert produto;
      System.debug('CARLOS=Internal_id__c= '+produto.Internal_id__c);
      
      //Cria um pricebookEntry e adiciona o produto criado no catalogo de preço padrão.
 
      PricebookEntry pbe1 = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = Test.getStandardPricebookId(), IsActive =true, UseStandardPrice = false);
       
      insert pbe1;
      //Cria nova entrada de catalogo
      //pbe = new PricebookEntry();
      //pbe.Pricebook2Id = Test.getStandardPricebookId(); 
      //pbe.Product2Id = produto.Id;
      //pbe.UnitPrice = 100.00;
      //pbe.IsActive = true;
     // pbe.UseStandardPrice = false;
      //insert pbe;
        
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.SKU__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard');
      insert critN;
    
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
     
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      CotaR.RecordTypeId = idRecTypeCr;
      insert cotaR;
      
      //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('Opportunity','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new Opportunity();
      opp.Name = 'Opp TESTE COTA';
      opp.closeDate = System.today()+1;
      opp.AccountId = acc.Id;
      opp.StageName = 'Novo Pedido';
      opp.NR_customer_order__c = '34525';
      opp.Freight__c = 'F';
      opp.NR_order_JDE__c = '12345';
      opp.CD_order_status__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.NR_order_JDE__c = '5-223-59-1';
      //opp.Type = SalesOrderReturn.getOrderType(6, 'teste');
      insert opp;

      //Cria um novo produto da oportunidade.
      oli = new OpportunityLineItem();
      oli.PricebookEntryId = pbe1.Id;
      oli.OpportunityId    = opp.Id;
      oli.UnitPrice        = 12;
      oli.Quantity         = 12;
      oli.cd_line_status__c = '500';
      
      //insert oli;
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Test.startTest();
      Utils.setMigrationDoneTest(false); 
      
      Integer Country = 6;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega =  8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      LAT_SalesOrderReturn.LAT_ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      //SalesOrder_Source = 'F';
      
      //SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        //DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      Test.stopTest();
    }   


static testMethod void SalesOrderReturnTestDeliveryDateUYB() 
    {
      Utils.setMigrationDoneTest(true); 
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
          //Declaração de variáveis.
      Account acc                           = null;
      UDC__c regional, bandeira, cidade, deposito     = null;
      Profile perfil                        = null;
      SKU__c sku                            = null;
      Criterio_nacional_de_cota__c critN    = null;
      Cota_nacional__c cotaN                = null;
      Cota_regional__c cotaR                = null;
      LAT_Opportunity__c opp                = null;
      LAT_OpportunityLineItem__c oli               = null;
      User usuario                          = null;
      LAT_Product__c produto                      = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      String idOpportunity                  = null;
      
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
      

      //Recupera o ID do perfil desejado.
      
      //Cria novo usuario.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','UY'); 
      insert usuario;  
        
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = idRecTypeUDC;
      insert regional;
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = idRecTypeUDC;
      insert bandeira;
      
      //Cria nova UDC.
      deposito = new UDC__c();
      deposito.CodDefUsuario__c = '4433';
      deposito.CodProd__c     = 'CRM';
      deposito.CodUs__c     = 'DF';
      deposito.Internal_Id__c   = '4433'+'CRM'+'DF';
      deposito.RecordTypeId = idRecTypeUDC;
      insert deposito;
      
      //Cria novo Account.
      
      acc = LAT_Account_TestFactory.getAccountOffTradeArg();
      acc.Price_Group__c = '602037025';
      acc.Client_country_AN8__c = '6-8899';
      acc.Client_code_AN8__c = '8899';
      acc.Status__c = 'Cliente cadastrado no JDE';
      insert acc;
     
      //Recupera o catalogo de preço padrão
      //List<Pricebook2> catalogoPreco = [SELECT Id, Description FROM Pricebook2 WHERE isStandard = true limit 1];
            //Cria um novo produto
      produto = new LAT_Product__c();
      produto.Name = 'Cloud2b';
      produto.LAT_IsActive__c = true;
      produto.LAT_CDUnit__c = 'UN';
      //produto.QT_lead_time__c = 5;
      produto.LAT_Sku__c = '35';
      produto.LAT_Country__c = 5;
      produto.LAT_Group__c = acc.Price_Group__c;
      //produto.cd_payment_term__c = 'V00';
      produto.LAT_ExternalId__c = produto.LAT_Country__c+'-'+string.valueof(35);//+'-'+produto.cd_payment_term__c;
      produto.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Product__c' , 'Standard_UY' );
      insert produto;
      
      //Cria nova entrada de catalogo
      //pbe = new PricebookEntry();
      //pbe.Pricebook2Id = Test.getStandardPricebookId(); 
      //pbe.Product2Id = produto.Id;
      //pbe.UnitPrice = 100.00;
      //pbe.IsActive = true;
     // pbe.UseStandardPrice = false;
      //insert pbe;
        
      //Cria novo sku.
      sku = new SKU__c();
      sku.Name = produto.LAT_Sku__c ;
      sku.Nome_do_produto__c = 'TESTE';
      sku.RecordTypeId = RecordTypeForTest.getRecType( 'SKU__c' , 'BRA_Standard' );
      insert sku;
      
      //Cria novo critério nacional.
      critN = new Criterio_nacional_de_cota__c();
      critN.SKU__c = sku.Id;
      critN.Cota__c = 500;
      critN.Canal__c = true;
      critN.Bandeira__c = true;
      critN.Regional__c = true;
      critN.Subcanal__c = true;
      critN.RecordTypeId = RecordTypeForTest.getRecType( 'Criterio_nacional_de_cota__c' , 'BRA_Standard');
      insert critN;
    
      //Cria nova cota nacional.
      cotaN = new Cota_nacional__c();
      cotaN.Cota__c = 100;
      cotaN.Canal__c = 'On Trade';
      cotaN.Sub_canal__c = 'Atacadista';
      cotaN.Regional__c = regional.Id;
      cotaN.Bandeira__c = bandeira.Id;
      cotaN.Criterio_nacional_de_cota__c = critN.Id;
      cotaN.RecordTypeId = RecordTypeForTest.getRecType( 'Cota_nacional__c' , 'BRA_Standard' );
      insert cotaN;
      
      Id idRecTypeCCR = RecordTypeForTest.getRecType( 'Criterio_de_cota_regional__c' , 'BRA_Standard' );
      Id idRecTypeCr = RecordTypeForTest.getRecType( 'Cota_regional__c' , 'BRA_Standard' );
      
      List< Criterio_de_cota_regional__c > lCritList = [ SELECT id 
                                          FROM Criterio_de_cota_regional__c WHERE Cota_nacional__c =:cotaN.id 
                                          AND RecordTypeId =: idRecTypeCCR limit 1 ];
      
      lCritList[0].Cliente__c = true;
      update lCritList[0];
     
      cotaR = new Cota_regional__c();
      cotaR.Cliente__c = acc.id;
      cotaR.Cota__c = 80;
      cotaR.Criterio_regional_de_cota__c = lCritList[0].id;
      CotaR.RecordTypeId = idRecTypeCr;
      insert cotaR;

         //Inicializa as listas e maps.
      idOpportunity = RecordTypeForTest.getRecType('LAT_Opportunity__c','Nova_oportunidade');
      
      //Cria nova oportunidade.
      opp = new LAT_Opportunity__c();
      opp.Name = 'Opp TESTE COTA';
      opp.LAT_CloseDate__c = System.today()+1;
      opp.LAT_Account__c = acc.Id;
      opp.LAT_StageName__c = 'Novo Pedido';
      opp.LAT_NRCustomerOrder__c = '34525';
      opp.LAT_Freight__c = 'F';
      opp.LAT_NROrderJDE__c = '12345';
      opp.LAT_CDOrderStatus__c = 1;
      opp.OwnerId = usuario.Id;
      opp.RecordTypeId = idOpportunity;
      opp.LAT_NROrderJDE__c = '5-223-59-1';
      opp.LAT_Type__c = SalesOrderReturn.getOrderType(1, 'teste');
      insert opp;
      
      //Cria um novo produto da oportunidade.
      oli = new LAT_OpportunityLineItem__c();
      oli.LAT_Product__c = produto.Id;
      oli.LAT_Opportunity__c    = opp.Id;
      oli.LAT_UnitPrice__c        = 12;
      oli.LAT_Quantity__c       = 12;
      oli.LAT_CdLineStatus__c = '500';
 
      SalesOrderReturn.SalesOrderItem lSoi = new SalesOrderReturn.SalesOrderItem();
      lSoi.cd_line_status = '1';
      //lSoi.cd_payment_term = produto.cd_payment_term__c;
      lSoi.Cd_product = string.valueof(35);
      lSoi.CD_unit = '1';
      lSoi.cd_unit_bonif = '0';
      lSoi.NR_order_line_jde = 1;
      lSoi.orderLineStatusDescription = 'teste';
      lSoi.PC_Bonus = 1;
      lSoi.pc_discount = 1;
      lSoi.priceComponents = '1';
      lSoi.QT_Bonus = 0;
      lSoi.QT_sales = 1;
      lSoi.Vl_Valor = 1;
      lSoi.realDeliveryDate = null;
      
      List<SalesOrderReturn.SalesOrderItem> lSalesOI = new List<SalesOrderReturn.SalesOrderItem>();
      lSalesOI.add(lSoi);
      
      Test.startTest();
      Utils.setMigrationDoneTest(true); 
      
      Integer Country = 6;
      String cd_salesman = null;
      String NR_order_crm = opp.Id;
      Integer NR_order_JDE = 59;
      Integer customer_AN8 = 8899;
      Integer customer_AN8_entrega =  8899;
      String NR_customer_order = '1';
      String companyCode = '1';
      String DS_message1 = 'MSG1';
      String DS_message2 = 'MSG2';
      String DT_delivery = String.ValueOf(System.now());
      String Freight = 'F';
      String DT_Order = String.ValueOf(System.now());
      String DT_Faturamento = String.ValueOf(System.now());
      String CD_Order_Type = '223';
      Integer cd_order_status = 1;
      String CD_Deposito = '4433';
      String SalesOrder_Source = 'C';
      String priceComponents = '';
      integer returnCode = 0;
      String returnMessage = 'Erro';
      String purchaseOrderUntil = '';
      String retentionReason = '';
      String paymentTerm = '';
      List<SalesOrderReturn.SalesOrderItem> listaItem = lSalesOI;
      
      LAT_SalesOrderReturn.LAT_ETL_SalesOrderLoadMigrated(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      

      //SalesOrder_Source = 'F';
      
      //SalesOrderReturn.ETL_SalesOrderLoad(Country, cd_salesman, NR_order_crm, NR_order_JDE, customer_AN8, customer_AN8_entrega, NR_customer_order, companyCode, DS_message1, DS_message2, DT_delivery, Freight, DT_Order, 
        //DT_Faturamento, CD_Order_Type, cd_order_status, CD_Deposito, SalesOrder_Source, priceComponents, returnCode, returnMessage, purchaseOrderUntil, retentionReason, paymentTerm, listaItem);
      
      Test.stopTest();
    }   
 


    
}