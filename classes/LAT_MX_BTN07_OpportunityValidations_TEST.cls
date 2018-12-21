/******************************************************************************
*   Company:Valuenet    Developers:Elena Schwarzböck       Date:04/12/2013    *
*******************************************************************************/
 /********************************************************************************
*
* MIGRACION LICENCIAS
* AUTHOR: ZIMMIC                     DATE: 10/11/2016
*
********************************************************************************/

//@isTest(seeAllDAta=true)
@isTest
public with sharing class LAT_MX_BTN07_OpportunityValidations_TEST{

    static testMethod void unitTest(){
        Utils.setMigrationDoneTest(false);
        // Insert an email to deliver
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
            Name = 'LAT_MX_OpportunityValidations_Profiles',
            LAT_Value__c = 'LAT_MX_Coordinador_CRM');
        insert cfg;

        LAT_CHATTER_POST_BODY__c cpb = new LAT_CHATTER_POST_BODY__c();
        cpb.Name = 'LAT_MX_ProductoSinIndexMarca';
        cpb.Body__c = 'Tests';
        insert cpb;

        UDC__c udc1 = new UDC__c(
            Name = 'test1',
            Internal_Id__c = '1',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        UDC__c udc2 = new UDC__c(
            Name = 'test2',
            Internal_Id__c = '2',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        insert new List<UDC__c>{udc1, udc2};

        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000',
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            LAT_MX_FiscalEntityType__c = 'Individual',
            Payment_Condition__c = udc1.Id,
            SaveDuplicatedFiscalID_AR__c = true,
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade'),
            LAT_MX_CreditAndCollectionsExecutive__c = UserInfo.getUserId()
        );

        insert acc;
        acc.Client_code_AN8__c = '100';

        update acc;

        test.StartTest();
        Utils.setMigrationDoneTest(false);
        Opportunity opp = new Opportunity(
            AccountId = acc.Id,
            Name = 'test',
            NR_customer_order__c = '100',
            CloseDate = date.today(),
            Type = 'Replenish',
            DS_Message1__c = 'test',
            DS_Message2__c = 'test',
            StageName = 'Novo pedido',
            LAT_MX_OrderPaymentPeriodReference__c = udc2.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'LAT_MX_OPP_NewOrder')
        );

        insert opp;

        //Call fist without line items
        LAT_MX_BTN07_OpportunityValidations.PaymentPeridoValidation(opp.Id);


        Product2 prod1 = new Product2(Name = 'TestProd', IsActive = true, CD_Unit__c = 'CA', Internal_id__c = '444', QT_lead_time__c = 5, SKU__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('Product2' + 'BRA_Standard'));
        Product2 prod2 = new Product2(Name = 'TestProd2', IsActive = true, CD_Unit__c = 'CA', Internal_id__c = '443', SKU__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('Product2' + 'BRA_Standard'));
        insert new List<Product2>{prod1, prod2};

        id standardPB = Test.getStandardPricebookId();//[SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];

        PricebookEntry pbe1 = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 12, Pricebook2Id = standardPB, IsActive =true, UseStandardPrice = false);
        insert pbe1;

        List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(Remover__c = false,Quantity = 200, UOM_AR__c = 'CA', LAT_SkuText__c = '100', PriceBookEntryId = pbe1.Id, UnitPrice = 10, OpportunityId = opp.Id, LAT_MX_KAMPromisedDate__c = date.today(), Descricao_do_status__c = 'Faturado - test', Campo_de_formatacao__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        insert oli;

        opp.LAT_MX_CredAndCollExecutiveManager__c = UserInfo.getUserId();
        opp.LAT_MX_LastTotalAmountSentToJDE__c = 100;

        update opp;

        //Call fist without line items

        LAT_MX_BTN07_OpportunityValidations.PaymentPeridoValidation(opp.Id);

        LAT_CHATTER_POST_BODY__c lg = new LAT_CHATTER_POST_BODY__c();
        lg.Name = 'LAT_MX_OPP_Integrada_JDE';
        lg.Body__c = 'Test';
        insert lg;
        
        LAT_Opportunity__c oppLat = new LAT_Opportunity__c(
            LAT_Account__c = acc.Id,
            Name = 'test',
            LAT_NRCustomerOrder__c = '100',
            LAT_CloseDate__c = date.today(),
            LAT_Type__c = 'Replenish',
            LAT_DSMessage1__c = 'test',
            LAT_DSMessage2__c = 'test',
            LAT_StageName__c = 'Novo pedido',
            LAT_MX_OrderPaymentPeriodReference__c = udc2.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder')
        );

        insert oppLat;

        LAT_Opportunity__c oppLat2= new LAT_Opportunity__c(
            LAT_Account__c = acc.Id,
            Name = 'test',
            LAT_NRCustomerOrder__c = '100',
            LAT_CloseDate__c = date.today(),
            LAT_Type__c = 'Replenish',
            LAT_DSMessage1__c = 'test',
            LAT_DSMessage2__c = 'test',
            LAT_StageName__c = 'Approved',
            LAT_MX_OrderPaymentPeriodReference__c = udc2.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder')
        );
        insert oppLat2;
        delete oppLat2;

        //LAT_MX_BTN07_OpportunityValidations.PaymentPeridoValidation2(oppLat.Id);
        LAT_MX_BTN07_OpportunityValidations.metodo(oppLat.Id);

         test.StopTest();

    }

    static testMethod void unitTest2(){

        Utils.setMigrationDoneTest(true);
        // Insert an email to deliver
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
            Name = 'LAT_MX_OpportunityValidations_Profiles',
            LAT_Value__c = 'LAT_MX_Coordinador_CRM');
        insert cfg;

        UDC__c udc1 = new UDC__c(
            Name = 'test1',
            Internal_Id__c = '1',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        UDC__c udc2 = new UDC__c(
            Name = 'test2',
            Internal_Id__c = '2',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        insert new List<UDC__c>{udc1, udc2};

        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000',
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            LAT_MX_FiscalEntityType__c = 'Individual',
            Payment_Condition__c = udc1.Id,
            SaveDuplicatedFiscalID_AR__c = true,
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade'),
            LAT_MX_CreditAndCollectionsExecutive__c = UserInfo.getUserId()
        );

        insert acc;

        acc.Client_code_AN8__c = '100';

        test.StartTest();
        Utils.setMigrationDoneTest(true);
        update acc;

        LAT_CHATTER_POST_BODY__c cpb = new LAT_CHATTER_POST_BODY__c();
        cpb.Name = 'LAT_MX_OPP_Integrada_JDE';
        cpb.Body__c = 'Tests';
        insert cpb;
        LAT_CHATTER_POST_BODY__c cpb1 = new LAT_CHATTER_POST_BODY__c();
        cpb1.Name = 'LAT_MX_ProductoSinIndexMarca';
        cpb1.Body__c = 'Tests';
        insert cpb1;
        
        LAT_Opportunity__c opp = new LAT_Opportunity__c(
            LAT_Account__c = acc.Id,
            Name = 'test',
            LAT_NRCustomerOrder__c = '100',
            LAT_CloseDate__c = date.today(),
            LAT_Type__c = 'Replenish',
            LAT_DSMessage1__c = 'test',
            LAT_DSMessage2__c = 'test',
            LAT_StageName__c = 'Novo pedido',
            LAT_MX_OrderPaymentPeriodReference__c = udc2.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder')
        );
        insert opp;
        
        LAT_GeneralConfig__c cfg1 = new LAT_GeneralConfig__c(
            Name = 'MX_DEFAULT_INDEX_MARGIN',
            LAT_Value__c = '1');
        insert cfg1;
        LAT_GeneralConfig__c cfg2 = new LAT_GeneralConfig__c(
            Name = 'MX_IndexMarca_Notification_Users',
            LAT_Value__c = '1');
        insert cfg2;

        LAT_Product__c prod1 = new LAT_Product__c(LAT_IndexMarca__c = 10, Name = 'TestProd', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '444', LAT_QTLeadTime__c = 5, LAT_Sku__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'LAT_MX_PRD_Standard'));
        LAT_Product__c prod2 = new LAT_Product__c(LAT_IndexMarca__c = 10, Name = 'TestProd2', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '443', LAT_Sku__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'LAT_MX_PRD_Standard'));
        insert new List<LAT_Product__c>{prod1, prod2};

        List<LAT_OpportunityLineItem__c> listOli = new List<LAT_OpportunityLineItem__c>();
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c(LAT_Remover__c = false,LAT_Quantity__c = 200, LAT_C9Quantity__c =100,LAT_AR_UOM__c = 'CA', LAT_SkuText__c = '100', LAT_Product__c = prod1.Id, LAT_UnitPrice__c = 10, LAT_Opportunity__c = opp.Id, LAT_MX_KAMPromisedDate__c = date.today(), LAT_StatusDescription__c = 'Faturado - test', LAT_FormatField__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        insert oli;

        opp.LAT_MX_CredAndCollExecutiveManager__c = UserInfo.getUserId();
        opp.LAT_MX_LastTotalAmountSentToJDE__c = 100;

        update opp;

        LAT_MX_BTN07_OpportunityValidations.PaymentPeridoValidation(opp.Id);

        listOli.add(oli);
        LAT_MX_BTN07_OpportunityValidations.checkRestricciones(listOli);

        test.StopTest();
    }
    

    static testMethod void unitTest3(){

        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
            Name = 'LAT_MX_OpportunityValidations_Profiles',
            LAT_Value__c = 'LAT_MX_Coordinador_CRM');
        insert cfg;
        LAT_GeneralConfig__c cfg1 = new LAT_GeneralConfig__c(
            Name = 'MX_DEFAULT_INDEX_MARGIN',
            LAT_Value__c = '1');
        insert cfg1;
        LAT_GeneralConfig__c cfg2 = new LAT_GeneralConfig__c(
            Name = 'MX_IndexMarca_Notification_Users',
            LAT_Value__c = '1');
        insert cfg2;

        LAT_CHATTER_POST_BODY__c cpb = new LAT_CHATTER_POST_BODY__c();
        cpb.Name = 'LAT_MX_OPP_Integrada_JDE';
        cpb.Body__c = 'Tests';
        insert cpb;
        LAT_CHATTER_POST_BODY__c cpb1 = new LAT_CHATTER_POST_BODY__c();
        cpb1.Name = 'LAT_MX_ProductoSinIndexMarca';
        cpb1.Body__c = 'Tests';
        insert cpb1;

        UDC__c udc1 = new UDC__c(
            Name = 'test1',
            Internal_Id__c = '1',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        UDC__c udc2 = new UDC__c(
            Name = 'test2',
            Internal_Id__c = '2',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );
        insert new List<UDC__c>{udc1, udc2};

        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000',
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            LAT_MX_FiscalEntityType__c = 'Individual',
            Payment_Condition__c = udc1.Id,
            SaveDuplicatedFiscalID_AR__c = true,
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade'),
            LAT_MX_CreditAndCollectionsExecutive__c = UserInfo.getUserId(),
            Client_code_AN8__c = '100'
        );
        insert acc;

        test.StartTest();
        
        LAT_Opportunity__c opp = new LAT_Opportunity__c(
            LAT_Account__c = acc.Id,
            Name = 'test',
            LAT_NRCustomerOrder__c = '100',
            LAT_CloseDate__c = date.today(),
            LAT_Type__c = 'Replenish',
            LAT_DSMessage1__c = 'test',
            LAT_DSMessage2__c = 'test',
            LAT_StageName__c = 'Novo pedido',
            LAT_MX_OrderPaymentPeriodReference__c = udc2.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder'),
            LAT_MX_CredAndCollExecutiveManager__c = UserInfo.getUserId(),
            LAT_MX_LastTotalAmountSentToJDE__c = 100
        );
        insert opp;
        
        LAT_Product__c prod1 = new LAT_Product__c(
            Name = 'TestProd', 
            LAT_IsActive__c = true, 
            LAT_CDUnit__c = 'CA', 
            LAT_ExternalID__c = '444', 
            LAT_QTLeadTime__c = 5, 
            LAT_Sku__c = '5666', 
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'LAT_MX_PRD_Standard'), 
            LAT_RestrictionEnd__c = date.today().addDays(5), 
            LAT_RestrictionInit__c = date.today().addDays(-5),
            LAT_IndexMarca__c = 10
        );
        LAT_Product__c prod2 = new LAT_Product__c(
            Name = 'TestProd2', 
            LAT_IsActive__c = true, 
            LAT_CDUnit__c = 'CA', 
            LAT_ExternalID__c = '443', 
            LAT_Sku__c = '5667', 
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'LAT_MX_PRD_Standard'), 
            LAT_RestrictionEnd__c = date.today(), 
            LAT_RestrictionInit__c = date.today(),
            LAT_IndexMarca__c = 10
        );
        insert new List<LAT_Product__c>{prod1, prod2};

        List<LAT_OpportunityLineItem__c> listOli = new List<LAT_OpportunityLineItem__c>();
        LAT_OpportunityLineItem__c oli1 = new LAT_OpportunityLineItem__c(
            LAT_Remover__c = false,
            LAT_Quantity__c = 200, 
            LAT_AR_UOM__c = 'CA', 
            LAT_SkuText__c = '100', 
            LAT_Product__c = prod1.Id, 
            LAT_UnitPrice__c = 10, 
            LAT_C9Quantity__c =100,
            LAT_Opportunity__c = opp.Id, 
            LAT_MX_KAMPromisedDate__c = date.today(), 
            LAT_StatusDescription__c = 'Faturado - test', 
            LAT_FormatField__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74'
        );
        insert oli1;
        LAT_OpportunityLineItem__c oli2 = new LAT_OpportunityLineItem__c(
            LAT_Remover__c = false,
            LAT_Quantity__c = 200, 
            LAT_C9Quantity__c =100,
            LAT_AR_UOM__c = 'CA', 
            LAT_SkuText__c = '100', 
            LAT_Product__c = prod2.Id, 
            LAT_UnitPrice__c = 10, 
            LAT_Opportunity__c = opp.Id, 
            LAT_MX_KAMPromisedDate__c = date.today(), 
            LAT_StatusDescription__c = 'Faturado - test', 
            LAT_FormatField__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74'
        );
        insert oli2;

        listOli.add(oli1);
        listOli.add(oli2);
        LAT_MX_BTN07_OpportunityValidations.checkRestricciones(listOli);

        test.StopTest();
    }
    
    static testMethod void unitTest4(){

        Utils.setMigrationDoneTest(true);
        // Insert an email to deliver
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
            Name = 'LAT_MX_OpportunityValidations_Profiles',
            LAT_Value__c = 'LAT_MX_Coordinador_CRM');
        insert cfg;

        UDC__c udc1 = new UDC__c(
            Name = 'test1',
            Internal_Id__c = '1',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        UDC__c udc2 = new UDC__c(
            Name = 'test2',
            Internal_Id__c = '2',
            CodProd__c = 'CRM',
            CodUs__c = 'PT',
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'LAT_MX_UDC_Standard')
        );

        insert new List<UDC__c>{udc1, udc2};

        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000',
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            LAT_MX_FiscalEntityType__c = 'Individual',
            Payment_Condition__c = udc1.Id,
            SaveDuplicatedFiscalID_AR__c = true,
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade'),
            LAT_MX_CreditAndCollectionsExecutive__c = UserInfo.getUserId()
        );

        insert acc;

        acc.Client_code_AN8__c = '100';

        test.StartTest();
        Utils.setMigrationDoneTest(true);
        update acc;

        LAT_CHATTER_POST_BODY__c cpb = new LAT_CHATTER_POST_BODY__c();
        cpb.Name = 'LAT_MX_OPP_Integrada_JDE';
        cpb.Body__c = 'Tests';
        insert cpb;
        LAT_CHATTER_POST_BODY__c cpb1 = new LAT_CHATTER_POST_BODY__c();
        cpb1.Name = 'LAT_MX_ProductoSinIndexMarca';
        cpb1.Body__c = 'Tests';
        insert cpb1;
        
        LAT_Opportunity__c opp = new LAT_Opportunity__c(
            LAT_Account__c = acc.Id,
            Name = 'test',
            LAT_NRCustomerOrder__c = '100',
            LAT_CloseDate__c = date.today(),
            LAT_Type__c = 'Replenish',
            LAT_DSMessage1__c = 'test',
            LAT_DSMessage2__c = 'test',
            LAT_StageName__c = 'Novo pedido',
            LAT_MX_OrderPaymentPeriodReference__c = udc1.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder')
        );
        insert opp;
        
        LAT_GeneralConfig__c cfg1 = new LAT_GeneralConfig__c(
            Name = 'MX_DEFAULT_INDEX_MARGIN',
            LAT_Value__c = '1');
        insert cfg1;
        LAT_GeneralConfig__c cfg2 = new LAT_GeneralConfig__c(
            Name = 'MX_IndexMarca_Notification_Users',
            LAT_Value__c = '1');
        insert cfg2;

        LAT_Product__c prod1 = new LAT_Product__c(LAT_IndexMarca__c = 10, Name = 'TestProd', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '444', LAT_QTLeadTime__c = 5, LAT_Sku__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'LAT_MX_PRD_Standard'));
        LAT_Product__c prod2 = new LAT_Product__c(LAT_IndexMarca__c = 10, Name = 'TestProd2', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '443', LAT_Sku__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'LAT_MX_PRD_Standard'));
        insert new List<LAT_Product__c>{prod1, prod2};
        update prod1;
        update prod2;
        List<LAT_OpportunityLineItem__c> listOli = new List<LAT_OpportunityLineItem__c>();
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c(LAT_Remover__c = false,LAT_Quantity__c = 200, LAT_C9Quantity__c =100, LAT_AR_UOM__c = 'CA', LAT_SkuText__c = '100', LAT_Product__c = prod1.Id, LAT_UnitPrice__c = 10, LAT_Opportunity__c = opp.Id, LAT_MX_KAMPromisedDate__c = date.today(), LAT_StatusDescription__c = 'Faturado - test', LAT_FormatField__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        insert oli;

        opp.LAT_MX_CredAndCollExecutiveManager__c = UserInfo.getUserId();
        opp.LAT_MX_LastTotalAmountSentToJDE__c = 100;

        update opp;

        LAT_MX_BTN07_OpportunityValidations.PaymentPeridoValidation(opp.Id);

        listOli.add(oli);
        LAT_MX_BTN07_OpportunityValidations.checkRestricciones(listOli);

        test.StopTest();
    }
}