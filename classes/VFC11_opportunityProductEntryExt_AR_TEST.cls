/**********************************************
 Dev: Juan Pablo Cubo       Version: 1
**********************************************/
 /********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 15/11/2016
*
********************************************************************************/
@istest(seeAllDAta=true)
public with sharing class VFC11_opportunityProductEntryExt_AR_TEST {
    
    static testMethod void unitTest1(){
        System.debug('%%%%%%%%%%%%%%%%%%%----------------------------- unitTest1');
        Utils.setMigrationDoneTest(false);        
        //Criacao das novas UDC
        Id idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__cBRA_Standard');
        UDC__c regional = new UDC__c(CodDefUsuario__c='4546', CodProd__c='01',  CodUs__c='01', Internal_Id__c='1234', RecordTypeId = idRecTypeUDC);
        UDC__c customerFlag = new UDC__c(CodDefUsuario__c='179',  CodProd__c='01',  CodUs__c='06', Internal_Id__c='1236', RecordTypeId = idRecTypeUDC);
        UDC__c businessUnit = new UDC__c(CodDefUsuario__c='05',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='876',  RecordTypeId = idRecTypeUDC);
        UDC__c paymentCondition = new UDC__c(CodDefUsuario__c='06',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='1237',  RecordTypeId = idRecTypeUDC);
        List<UDC__c> udcs = new List<UDC__c>{regional, customerFlag, businessUnit, paymentCondition};
        insert udcs;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 1: '+Limits.getQueries());
        
        //Cria novo Account
        Account acc = new Account();
        acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Frequency_of_Visits__c = 'Semanal';
        acc.Client_code_AN8__c = '557799';
        acc.Corporate_Name__c = 'Teste';
        acc.Checking_account__c = '000';
        acc.Carriers_Numbers__c = '123';
        acc.CNPJ__c = '48843971000120';
        acc.Current_account__c = '0';
        acc.Channel__c = 'Off Trade';
        acc.Price_Group__c = '1';
        acc.Agency__c = '000';
        acc.Type = 'Outros';
        //acc.Regional__c = regional.Id;
        //acc.Customer_Flag__c = customerFlag.Id;
        //acc.Business_Unit__c = businessUnit.Id;
        acc.RecordTypeId = Global_RecordTypeCache.getRtId('AccountOff_Trade');
        insert acc;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 2: '+Limits.getQueries());
        
        Product2 produto = new Product2();
        produto.Name = 'TestProd';
        produto.IsActive = true;
        produto.CD_Unit__c = 'UN';
        produto.Internal_id__c = '444';
        //produto.QT_lead_time__c = 5;
        produto.SKU__c = '5666';
        produto.RecordTypeId = Global_RecordTypeCache.getRtId( 'Product2BRA_Standard' );
        
        Product2 produto2 = new Product2();
        produto2.Name = 'TestProd2';
        produto2.IsActive = true;
        produto2.CD_Unit__c = 'UN';
        produto2.Internal_id__c = '445';
        //produto2.QT_lead_time__c = 5;
        produto2.SKU__c = '5667';

        produto2.RecordTypeId = Global_RecordTypeCache.getRtId( 'Product2BRA_Standard' );
        insert new List<Product2>{produto, produto2};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 3: '+Limits.getQueries());
        
        Pricebook2 standardPB = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1]; 
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = standardPB.Id, IsActive =true, UseStandardPrice = false);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = produto2.Id, UnitPrice = 11, Pricebook2Id = standardPB.Id, IsActive =true, UseStandardPrice = false);
        insert new List<PricebookEntry>{pbe1, pbe2};
        //insert pbe1;
        //Cria novo pricebook
        Pricebook2 pricebook = new Pricebook2(Name = '1', Description = '1');
        insert pricebook;
        
        //Cria novo pricebookEntry
        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = produto.Id;
        pbe3.UnitPrice = 12;
        pbe3.Pricebook2Id = pricebook.Id;
        pbe3.IsActive =true;
        pbe3.UseStandardPrice = false;
        
        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.Product2Id = produto2.Id;
        pbe4.UnitPrice = 10;
        pbe4.Pricebook2Id = pricebook.Id;
        pbe4.IsActive =true;
        pbe4.UseStandardPrice = false;
        insert new List<PricebookEntry>{pbe3, pbe4};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 4: '+Limits.getQueries());
        
        //Cria nova oportunidade.
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp TESTE COTA';
        opp.closeDate = Date.today().addDays(1);
        opp.AccountId = acc.Id;
        opp.StageName = 'Novo Pedido';
        opp.RecordTypeId = Global_RecordTypeCache.getRtId('OpportunityNova_oportunidade');
        insert opp;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 5: '+Limits.getQueries());
         
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.PricebookEntryId = pbe3.Id;
        oli.OpportunityId =opp.Id;
        oli.UnitPrice = 12;
        oli.Quantity = 12;
        insert oli;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 6: '+Limits.getQueries());
        
        LAT_Account_product_payment__c app = new LAT_Account_product_payment__c();
        app.Account__c = acc.Id;
        app.Product__c = produto2.Id;
        app.Payment__c = paymentCondition.Id;
        app.PaymentCondition__c = 'Cash';
        app.PaymentConditionDescription__c ='I will pay';
        insert app;

        LAT_Account_product_payment__c app2 = new LAT_Account_product_payment__c();
        app2.Account__c = acc.Id;
        app2.Product__c = produto.Id;
        app2.Payment__c = paymentCondition.Id;
        app2.PaymentCondition__c = 'Cash';
        app2.PaymentConditionDescription__c ='I will pay';
        insert app2;

        produto2.LAT_IsRefactorProduct__c = 'Y';
        update produto2;
        System.Test.startTest();
        Utils.setMigrationDoneTest(false);         
        //Test of class "VFC11_opportunityProductEntryExt_AR"
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE = new VFC11_opportunityProductEntryExt_AR(controller);
        VFC11_opportunityProductEntryExt_AR.productWrapper pw = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);
        oPEE.searchString = produto.Name;
        oPEE.varPaymentVal = 'Cash';
        pw.isSelected = true;
        oPEE.lstWProducts.add(pw);
        oPEE.updateAvailableListCheck();
        oPEE.addItensToShoppingCart();
        oPEE.removeFromShoppingCart();
        oPEE.paymentValues();
        oPEE.closePopup();
        oPEE.showCampoFormatado();
        oPEE.getItemX();
        oPEE.showPopup();
        //oPEE.onSave();
        oPEE.priceBookCheck();
        oPEE.changePricebook();
        oPEE.AddMsgError('TEST');
        //oPEE.calculaPrecios2();
        oPEE.removeFromShoppingCart();
        VFC11_opportunityProductEntryExt_AR.isForCC();
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys on Test1: '+Limits.getQueries());
        System.Test.stopTest();
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 7: '+Limits.getQueries());
        

    }

    static testMethod void unitTest1B(){
        System.debug('%%%%%%%%%%%%%%%%%%%----------------------------- unitTest1B');
        Utils.setMigrationDoneTest(true);        
        //Criacao das novas UDC
        Id idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__cBRA_Standard');
        UDC__c regional = new UDC__c(CodDefUsuario__c='4546', CodProd__c='01',  CodUs__c='01', Internal_Id__c='1234', RecordTypeId = idRecTypeUDC);
        UDC__c customerFlag = new UDC__c(CodDefUsuario__c='179',  CodProd__c='01',  CodUs__c='06', Internal_Id__c='1236', RecordTypeId = idRecTypeUDC);
        UDC__c businessUnit = new UDC__c(CodDefUsuario__c='05',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='876',  RecordTypeId = idRecTypeUDC);
        UDC__c paymentCondition = new UDC__c(CodDefUsuario__c='06',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='1237',  RecordTypeId = idRecTypeUDC);
        List<UDC__c> udcs = new List<UDC__c>{regional, customerFlag, businessUnit, paymentCondition};
        insert udcs;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 1: '+Limits.getQueries());
        
        //Cria novo Account
        Account acc = new Account();
        acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Frequency_of_Visits__c = 'Semanal';
        acc.Client_code_AN8__c = '557799';
        acc.Corporate_Name__c = 'Teste';
        acc.Checking_account__c = '000';
        acc.Carriers_Numbers__c = '123';
        acc.CNPJ__c = '48843971000120';
        acc.Current_account__c = '0';
        acc.Channel__c = 'Off Trade';
        acc.Price_Group__c = '1';
        acc.Agency__c = '000';
        acc.Type = 'Outros';
        //acc.Regional__c = regional.Id;
        //acc.Customer_Flag__c = customerFlag.Id;
        //acc.Business_Unit__c = businessUnit.Id;
        acc.RecordTypeId = Global_RecordTypeCache.getRtId('AccountOff_Trade');
        insert acc;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 2: '+Limits.getQueries());
        
        LAT_Product__c produto = new LAT_Product__c();
        produto.Name = 'TestProd';
        produto.LAT_IsActive__c = true;
        produto.LAT_CDUnit__c = 'UN';
        produto.LAT_ExternalId__c = '444';
        produto.LAT_IsRefactorProduct__c = 'Y';        
        //produto.QT_lead_time__c = 5;
        produto.LAT_Sku__c = '5666';
        produto.RecordTypeId = Global_RecordTypeCache.getRtId( 'LAT_Product__cBRA_Standard' );
        
        LAT_Product__c produto2 = new LAT_Product__c();
        produto2.Name = 'TestProd2';
        produto2.LAT_IsActive__c = true;
        produto2.LAT_CDUnit__c = 'UN';
        produto2.LAT_ExternalId__c = '444';
        //produto2.QT_lead_time__c = 5;
        produto2.LAT_Sku__c = '5667';
        produto2.RecordTypeId = Global_RecordTypeCache.getRtId( 'LAT_Product__cBRA_Standard' );
        insert new List<LAT_Product__c>{produto, produto2};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 3: '+Limits.getQueries());
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 4: '+Limits.getQueries());
        
        //Cria nova oportunidade.
        LAT_Opportunity__c opp = new LAT_Opportunity__c();
        opp.Name = 'Opp TESTE COTA';
        opp.LAT_CloseDate__c = Date.today().addDays(1);
        opp.LAT_Account__c = acc.Id;
        opp.LAT_StageName__c = 'Novo Pedido';
        opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__cNova_oportunidade');
        insert opp;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 5: '+Limits.getQueries());
         
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c();
        oli.LAT_Product__c = produto.Id;
        oli.LAT_Opportunity__c =opp.Id;
        oli.LAT_UnitPrice__c = 12;
        oli.LAT_Quantity__c = 12;
        insert oli;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 6: '+Limits.getQueries());
        
        LAT_Account_product_payment__c app = new LAT_Account_product_payment__c();
        app.Account__c = acc.Id;
        app.LAT_Product__c = produto.Id;
        app.PaymentCondition__c = 'Cash';
        app.Payment__c = paymentCondition.Id;
        app.PaymentConditionDescription__c = 'I will pay1';
        insert app;

        LAT_Account_product_payment__c app2 = new LAT_Account_product_payment__c();
        app2.Account__c = acc.Id;
        app2.LAT_Product__c = produto2.Id;
        app2.PaymentCondition__c = 'Cash';
        app2.Payment__c = regional.Id;
        app2.PaymentConditionDescription__c = 'I will pay2';
        insert app2;
        
        
        
        System.Test.startTest();
        Utils.setMigrationDoneTest(true);         
        //Test of class "VFC11_opportunityProductEntryExt_AR"
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE = new VFC11_opportunityProductEntryExt_AR(controller);
        VFC11_opportunityProductEntryExt_AR.productWrapper pw = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);
        oPEE.searchString = produto2.Name;
        oPEE.varPaymentVal = 'Cash';
        pw.isSelected = true;
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.paymentValues();
        oPEE.closePopup();
        oPEE.showCampoFormatado();
        oPEE.getItemX();
        oPEE.showPopup();

        //oPEE.onSave();
        //oPEE.priceBookCheck();
        oPEE.changePricebook();
        oPEE.AddMsgError('TEST');
        //oPEE.calculaPrecios2();
        oPEE.removeFromShoppingCart();
        oPEE.doCheckAvailability();
        oPEE.onCancel();

        
        system.debug(loggingLevel.ERROR, 'TOKEN querys on Test1: '+Limits.getQueries());
        System.Test.stopTest();
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 7: '+Limits.getQueries());
        

    }
    static testMethod void unitTest2(){
        System.debug('%%%%%%%%%%%%%%%%%%%----------------------------- unitTest2');
        Utils.setMigrationDoneTest(false);      
        //Criacao das novas UDC
        Id idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__cBRA_Standard');
        UDC__c regional = new UDC__c(CodDefUsuario__c='4546', CodProd__c='01',  CodUs__c='01', Internal_Id__c='1234', RecordTypeId = idRecTypeUDC);
        UDC__c customerFlag = new UDC__c(CodDefUsuario__c='179',  CodProd__c='01',  CodUs__c='06', Internal_Id__c='1236', RecordTypeId = idRecTypeUDC);
        UDC__c businessUnit = new UDC__c(CodDefUsuario__c='05',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='876',  RecordTypeId = idRecTypeUDC);
        UDC__c paymentCondition = new UDC__c(CodDefUsuario__c='06',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='1237',  RecordTypeId = idRecTypeUDC);
        List<UDC__c> udcs = new List<UDC__c>{regional, customerFlag, businessUnit, paymentCondition};
        insert udcs;
        
        //Cria novo Account
        Account acc = new Account();
        acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Frequency_of_Visits__c = 'Semanal';
        acc.Client_code_AN8__c = '557799';
        acc.Corporate_Name__c = 'Teste';
        acc.Checking_account__c = '000';
        acc.Carriers_Numbers__c = '123';
        acc.CNPJ__c = '48843971000120';
        acc.Current_account__c = '0';
        acc.Channel__c = 'Off Trade';
        acc.Price_Group__c = '1';
        acc.Agency__c = '000';
        acc.Type = 'Outros';
        //acc.Regional__c = regional.Id;
        //acc.Customer_Flag__c = customerFlag.Id;
        //acc.Business_Unit__c = businessUnit.Id;
        acc.RecordTypeId = Global_RecordTypeCache.getRtId('AccountOff_Trade');
        insert acc;
        
        Product2 produto = new Product2();
        produto.Name = 'TestProd';
        produto.IsActive = true;
        //produto.LAT_IsRefactorProduct__c = 'Y';
        produto.CD_Unit__c = 'UN';
        produto.Internal_id__c = '444';
        //produto.QT_lead_time__c = 5;
        produto.SKU__c = '5666';
        produto.RecordTypeId = Global_RecordTypeCache.getRtId( 'Product2BRA_Standard' );
        
        Product2 produto2 = new Product2();
        produto2.Name = 'TestProd2';
        produto2.IsActive = true;
        produto2.CD_Unit__c = 'UN';
        produto2.Internal_id__c = '444';
        //produto2.LAT_IsRefactorProduct__c = 'Y';
        //produto2.QT_lead_time__c = 5;
        produto2.SKU__c = '5667';
        produto2.RecordTypeId = Global_RecordTypeCache.getRtId( 'Product2BRA_Standard' );
        insert new List<Product2>{produto, produto2};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 1: '+Limits.getQueries());
        
        Pricebook2 standardPB = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1]; 
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = standardPB.Id, IsActive =true, UseStandardPrice = false);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = produto2.Id, UnitPrice = 11, Pricebook2Id = standardPB.Id, IsActive =true, UseStandardPrice = false);
        insert new List<PricebookEntry>{pbe1, pbe2};
        
        //Cria novo pricebook
        Pricebook2 pricebook = new Pricebook2(Name = '1', Description = '1');
        insert pricebook;
        
        //Cria novo pricebookEntry
        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = produto.Id;
        pbe3.UnitPrice = 12;
        pbe3.Pricebook2Id = pricebook.Id;
        pbe3.IsActive =true;
        pbe3.UseStandardPrice = false;
        
        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.Product2Id = produto2.Id;
        pbe4.UnitPrice = 10;
        pbe4.Pricebook2Id = pricebook.Id;
        pbe4.IsActive =true;
        pbe4.UseStandardPrice = false;
        insert new List<PricebookEntry>{pbe3, pbe4};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 2: '+Limits.getQueries());
        
        //Cria nova oportunidade.
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp TESTE COTA';
        opp.closeDate = Date.today().addDays(1);
        opp.AccountId = acc.Id;
        opp.StageName = 'Novo Pedido';
        opp.RecordTypeId = Global_RecordTypeCache.getRtId('OpportunityNova_oportunidade');
        insert opp;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 3: '+Limits.getQueries());
         
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.PricebookEntryId = pbe3.Id;
        oli.OpportunityId =opp.Id;
        oli.UnitPrice = 12;
        oli.Quantity = 12;
        insert oli;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 4: '+Limits.getQueries());
        
        LAT_Account_product_payment__c app = new LAT_Account_product_payment__c();
        app.Account__c = acc.Id;
        app.Product__c = produto2.Id;
        app.Payment__c = paymentCondition.Id;
        app.PaymentCondition__c = 'Cash';
        app.PaymentConditionDescription__c = 'I will pay1';
        insert app;
        
        LAT_Account_product_payment__c app2 = new LAT_Account_product_payment__c();
        app2.Account__c = acc.Id;
        app2.Product__c = produto2.Id;
        app2.Payment__c = paymentCondition.Id;
        app2.PaymentCondition__c = 'Cash';
        app2.PaymentConditionDescription__c = 'I will pay2';
        insert app2;

        System.Test.startTest();
        Utils.setMigrationDoneTest(false); 
        
        //Test of class "VFC11_opportunityProductEntryExt_AR"
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE = new VFC11_opportunityProductEntryExt_AR(controller);
        VFC11_opportunityProductEntryExt_AR.productWrapper pw = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);
        oPEE.searchString = produto.Name;
        oPEE.varPaymentVal = 'Cash';
        pw.isSelected = true;
        oPEE.lstWProducts.add(pw);
        oPEE.initAction();
        oPEE.updateAvailableListCheck();
        pw.isSelected = true;
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.removeFromShoppingCart();
        oPEE.paymentValues();
        oPEE.closePopup();
        oPEE.getCondicao();
        oPEE.priceBookCheck();
        oPEE.initAction();
        oPEE.onSaveRefresh();
        oPEE.getChosenCurrency();
        oPEE.getlstWProducts();

        opp.Pricebook2Id = null;
        update opp;
        ApexPages.StandardController controller2 = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE2 = new VFC11_opportunityProductEntryExt_AR(controller2);
        /*
        VFC11_opportunityProductEntryExt_AR.productWrapper pww = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);     
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.onCancel();
        oPEE.showCampoFormatado();
        oPEE.onSaveRefresh();
        oPEE.onSave();
        */
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys on Test2: '+Limits.getQueries());
        System.Test.stopTest();
    }

    static testMethod void unitTest2B(){
        System.debug('%%%%%%%%%%%%%%%%%%%----------------------------- unitTest2B');
        Utils.setMigrationDoneTest(true);      
        //Criacao das novas UDC
        Id idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__cBRA_Standard');
        UDC__c regional = new UDC__c(CodDefUsuario__c='4546', CodProd__c='01',  CodUs__c='01', Internal_Id__c='1234', RecordTypeId = idRecTypeUDC);
        UDC__c customerFlag = new UDC__c(CodDefUsuario__c='179',  CodProd__c='01',  CodUs__c='06', Internal_Id__c='1236', RecordTypeId = idRecTypeUDC);
        UDC__c businessUnit = new UDC__c(CodDefUsuario__c='05',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='876',  RecordTypeId = idRecTypeUDC);
        UDC__c paymentCondition = new UDC__c(CodDefUsuario__c='06',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='1237',  RecordTypeId = idRecTypeUDC);
        List<UDC__c> udcs = new List<UDC__c>{regional, customerFlag, businessUnit, paymentCondition};
        insert udcs;
        
        //Cria novo Account
        Account acc = new Account();
        acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Frequency_of_Visits__c = 'Semanal';
        acc.Client_code_AN8__c = '557799';
        acc.Corporate_Name__c = 'Teste';
        acc.Checking_account__c = '000';
        acc.Carriers_Numbers__c = '123';
        acc.CNPJ__c = '48843971000120';
        acc.Current_account__c = '0';
        acc.Channel__c = 'Off Trade';
        acc.Price_Group__c = '1';
        acc.Agency__c = '000';
        acc.Type = 'Outros';
        //acc.Regional__c = regional.Id;
        //acc.Customer_Flag__c = customerFlag.Id;
        //acc.Business_Unit__c = businessUnit.Id;
        acc.RecordTypeId = Global_RecordTypeCache.getRtId('AccountOff_Trade');
        insert acc;
        
        LAT_Product__c produto = new LAT_Product__c();
        produto.Name = 'TestProd';
        produto.LAT_IsActive__c = true;
        produto.LAT_IsRefactorProduct__c = 'Y';
        produto.LAT_CDUnit__c = 'UN';
        produto.LAT_ExternalId__c = '444';
        //produto.QT_lead_time__c = 5;
        produto.LAT_Sku__c = '5666';
        produto.RecordTypeId = Global_RecordTypeCache.getRtId( 'LAT_Product__cBRA_Standard' );
        
        LAT_Product__c produto2 = new LAT_Product__c();
        produto2.Name = 'TestProd2';
        produto2.LAT_IsRefactorProduct__c = 'Y';
        produto2.LAT_IsActive__c = true;
        produto2.LAT_CDUnit__c = 'UN';
        produto2.LAT_ExternalId__c = '444';
        //produto2.QT_lead_time__c = 5;
        produto2.LAT_Sku__c = '5667';
        produto2.RecordTypeId = Global_RecordTypeCache.getRtId( 'LAT_Product__cBRA_Standard' );
        insert new List<LAT_Product__c>{produto, produto2};
        


        system.debug(loggingLevel.ERROR, 'TOKEN querys 1: '+Limits.getQueries());
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 2: '+Limits.getQueries());
        
        //Cria nova oportunidade.
        LAT_Opportunity__c opp = new LAT_Opportunity__c();
        opp.Name = 'Opp TESTE COTA';
        opp.LAT_CloseDate__c = Date.today().addDays(1);
        opp.LAT_Account__c = acc.Id;
        opp.LAT_StageName__c = 'Novo Pedido';
        opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__cNova_oportunidade');
        insert opp;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 5: '+Limits.getQueries());
         
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c();
        oli.LAT_Product__c = produto.Id;
        oli.LAT_Opportunity__c =opp.Id;
        oli.LAT_UnitPrice__c = 12;
        oli.LAT_Quantity__c = 12;
        insert oli;
        


        system.debug(loggingLevel.ERROR, 'TOKEN querys 4: '+Limits.getQueries());
        
        LAT_Account_product_payment__c app = new LAT_Account_product_payment__c();
        app.Account__c = acc.Id;
        app.LAT_Product__c = produto2.Id;
        app.Payment__c = paymentCondition.Id;
        app.PaymentCondition__c = 'Cash';
        app.PaymentConditionDescription__c = 'I will pay1';
        insert app;

        LAT_Account_product_payment__c app2 = new LAT_Account_product_payment__c();
        app2.Account__c = acc.Id;
        app2.LAT_Product__c = produto.Id;
        app2.Payment__c = paymentCondition.Id;
        app2.PaymentCondition__c = 'Cash';
        app2.PaymentConditionDescription__c = 'I will pay2';
        insert app2;        
        
        System.Test.startTest();
        Utils.setMigrationDoneTest(true); 
        
        //Test of class "VFC11_opportunityProductEntryExt_AR"
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE = new VFC11_opportunityProductEntryExt_AR(controller);
        VFC11_opportunityProductEntryExt_AR.productWrapper pw = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);
        pw.isSelected = true;
        oPEE.searchString = produto.Name;
        oPEE.varPaymentVal = 'Cash';
        oPEE.paymentValues();
        oPEE.closePopup();
        oPEE.getCondicao();
        oPEE.lstWProducts.add(pw);        
        oPEE.addItensToShoppingCart();
        //oPEE.priceBookCheck();
        oPEE.initAction();
        oPEE.onSaveRefresh();
        oPEE.getChosenCurrency();
        oPEE.getlstWProducts();
        oPEE.LAT_shoppingCart[0].LAT_Quantity__c = 10;
        oPEE.removeFromShoppingCart();
        
        /*
        VFC11_opportunityProductEntryExt_AR.productWrapper pww = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);     
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.onCancel();
        oPEE.showCampoFormatado();
        oPEE.onSaveRefresh();
        oPEE.onSave();
        */
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys on Test2: '+Limits.getQueries());
        System.Test.stopTest();
    }    

        static testMethod void unitTest8(){
        System.debug('%%%%%%%%%%%%%%%%%%%----------------------------- unitTest8');
        Utils.setMigrationDoneTest(false);      
        //Criacao das novas UDC
        Id idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__cBRA_Standard');
        UDC__c regional = new UDC__c(CodDefUsuario__c='4546', CodProd__c='01',  CodUs__c='01', Internal_Id__c='1234', RecordTypeId = idRecTypeUDC);
        UDC__c customerFlag = new UDC__c(CodDefUsuario__c='179',  CodProd__c='01',  CodUs__c='06', Internal_Id__c='1236', RecordTypeId = idRecTypeUDC);
        UDC__c businessUnit = new UDC__c(CodDefUsuario__c='05',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='876',  RecordTypeId = idRecTypeUDC);
        UDC__c paymentCondition = new UDC__c(CodDefUsuario__c='06',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='1237',  RecordTypeId = idRecTypeUDC);
        List<UDC__c> udcs = new List<UDC__c>{regional, customerFlag, businessUnit, paymentCondition};
        insert udcs;
        
        //Cria novo Account
        Account acc = new Account();
        acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Frequency_of_Visits__c = 'Semanal';
        acc.Client_code_AN8__c = '557799';
        acc.Corporate_Name__c = 'Teste';
        acc.Checking_account__c = '000';
        acc.Carriers_Numbers__c = '123';
        acc.CNPJ__c = '48843971000120';
        acc.Current_account__c = '0';
        acc.Channel__c = 'Off Trade';
        acc.Price_Group__c = '1';
        acc.Agency__c = '000';
        acc.Type = 'Outros';
        //acc.Regional__c = regional.Id;
        //acc.Customer_Flag__c = customerFlag.Id;
        //acc.Business_Unit__c = businessUnit.Id;
        acc.RecordTypeId = Global_RecordTypeCache.getRtId('AccountOff_Trade');
        insert acc;
        
        Product2 produto = new Product2();
        produto.Name = 'TestProd';
        produto.IsActive = true;
        //produto.LAT_IsRefactorProduct__c = 'Y';
        produto.CD_Unit__c = 'UN';
        produto.Internal_id__c = '444';
        //produto.QT_lead_time__c = 5;
        produto.SKU__c = '5666';
        produto.RecordTypeId = Global_RecordTypeCache.getRtId( 'Product2BRA_Standard' );
        
        Product2 produto2 = new Product2();
        produto2.Name = 'TestProd2';
        produto2.IsActive = true;
        produto2.CD_Unit__c = 'UN';
        produto2.Internal_id__c = '444';
        //produto2.LAT_IsRefactorProduct__c = 'Y';
        //produto2.QT_lead_time__c = 5;
        produto2.SKU__c = '5667';
        produto2.RecordTypeId = Global_RecordTypeCache.getRtId( 'Product2BRA_Standard' );
        insert new List<Product2>{produto, produto2};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 1: '+Limits.getQueries());
        
        Pricebook2 standardPB = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1]; 
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id = produto.Id, UnitPrice = 12, Pricebook2Id = standardPB.Id, IsActive =true, UseStandardPrice = false);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = produto2.Id, UnitPrice = 11, Pricebook2Id = standardPB.Id, IsActive =true, UseStandardPrice = false);
        insert new List<PricebookEntry>{pbe1, pbe2};
        
        //Cria novo pricebook
        Pricebook2 pricebook = new Pricebook2(Name = '1', Description = '1');
        insert pricebook;
        
        //Cria novo pricebookEntry
        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = produto.Id;
        pbe3.UnitPrice = 12;
        pbe3.Pricebook2Id = pricebook.Id;
        pbe3.IsActive =true;
        pbe3.UseStandardPrice = false;
        
        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.Product2Id = produto2.Id;
        pbe4.UnitPrice = 10;
        pbe4.Pricebook2Id = pricebook.Id;
        pbe4.IsActive =true;
        pbe4.UseStandardPrice = false;
        insert new List<PricebookEntry>{pbe3, pbe4};
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 2: '+Limits.getQueries());
        
        //Cria nova oportunidade.
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp TESTE COTA';
        opp.closeDate = Date.today().addDays(1);
        opp.AccountId = acc.Id;
        opp.StageName = 'Novo Pedido';
        opp.RecordTypeId = Global_RecordTypeCache.getRtId('OpportunityNova_oportunidade');
        insert opp;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 3: '+Limits.getQueries());
         
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.PricebookEntryId = pbe3.Id;
        oli.OpportunityId =opp.Id;
        oli.UnitPrice = 12;
        oli.Quantity = 12;
        insert oli;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 4: '+Limits.getQueries());
        
        LAT_Account_product_payment__c app = new LAT_Account_product_payment__c();
        app.Account__c = acc.Id;
        app.Product__c = produto2.Id;
        app.Payment__c = paymentCondition.Id;
        app.PaymentCondition__c = 'Cash';
        app.PaymentConditionDescription__c = 'I will pay1';
        insert app;
        
        LAT_Account_product_payment__c app2 = new LAT_Account_product_payment__c();
        app2.Account__c = acc.Id;
        app2.Product__c = produto2.Id;
        app2.Payment__c = paymentCondition.Id;
        app2.PaymentCondition__c = 'Cash';
        app2.PaymentConditionDescription__c = 'I will pay2';
        insert app2;

        System.Test.startTest();
        Utils.setMigrationDoneTest(false); 
        
        //Test of class "VFC11_opportunityProductEntryExt_AR"
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE = new VFC11_opportunityProductEntryExt_AR(controller);
        VFC11_opportunityProductEntryExt_AR.productWrapper pw = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);
        oPEE.searchString = produto.Name;
        oPEE.varPaymentVal = 'Cash';
        pw.isSelected = true;
        oPEE.lstWProducts.add(pw);
        oPEE.initAction();
        oPEE.updateAvailableListCheck();
        pw.isSelected = true;
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.removeFromShoppingCart();
        oPEE.paymentValues();
        oPEE.closePopup();
        oPEE.getCondicao();
        oPEE.priceBookCheck();
        oPEE.initAction();
        oPEE.onSave();
        oPEE.onSaveRefresh();
        oPEE.getChosenCurrency();
        oPEE.getlstWProducts();

        opp.Pricebook2Id = null;
        update opp;
        ApexPages.StandardController controller2 = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE2 = new VFC11_opportunityProductEntryExt_AR(controller2);
        /*
        VFC11_opportunityProductEntryExt_AR.productWrapper pww = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);     
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.onCancel();
        oPEE.showCampoFormatado();
        oPEE.onSaveRefresh();
        oPEE.onSave();
        */
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys on Test2: '+Limits.getQueries());
        System.Test.stopTest();
    }

    static testMethod void unitTest8B(){
        System.debug('%%%%%%%%%%%%%%%%%%%----------------------------- unitTest8B');
        Utils.setMigrationDoneTest(true);      
        //Criacao das novas UDC
        Id idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__cBRA_Standard');
        UDC__c regional = new UDC__c(CodDefUsuario__c='4546', CodProd__c='01',  CodUs__c='01', Internal_Id__c='1234', RecordTypeId = idRecTypeUDC);
        UDC__c customerFlag = new UDC__c(CodDefUsuario__c='179',  CodProd__c='01',  CodUs__c='06', Internal_Id__c='1236', RecordTypeId = idRecTypeUDC);
        UDC__c businessUnit = new UDC__c(CodDefUsuario__c='05',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='876',  RecordTypeId = idRecTypeUDC);
        UDC__c paymentCondition = new UDC__c(CodDefUsuario__c='06',   CodProd__c='CRM', CodUs__c='DF', Internal_Id__c='1237',  RecordTypeId = idRecTypeUDC);
        List<UDC__c> udcs = new List<UDC__c>{regional, customerFlag, businessUnit, paymentCondition};
        insert udcs;
        
        //Cria novo Account
        Account acc = new Account();
        acc.Name = 'ProdutosOppVerificaCotaExistenteTeste';
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Frequency_of_Visits__c = 'Semanal';
        acc.Client_code_AN8__c = '557799';
        acc.Corporate_Name__c = 'Teste';
        acc.Checking_account__c = '000';
        acc.Carriers_Numbers__c = '123';
        acc.CNPJ__c = '48843971000120';
        acc.Current_account__c = '0';
        acc.Channel__c = 'Off Trade';
        acc.Price_Group__c = '1';
        acc.Agency__c = '000';
        acc.Type = 'Outros';
        //acc.Regional__c = regional.Id;
        //acc.Customer_Flag__c = customerFlag.Id;
        //acc.Business_Unit__c = businessUnit.Id;
        acc.RecordTypeId = Global_RecordTypeCache.getRtId('AccountOff_Trade');
        insert acc;
        
        LAT_Product__c produto = new LAT_Product__c();
        produto.Name = 'TestProd';
        produto.LAT_IsActive__c = true;
        produto.LAT_IsRefactorProduct__c = 'Y';
        produto.LAT_CDUnit__c = 'UN';
        produto.LAT_ExternalId__c = '444';
        //produto.QT_lead_time__c = 5;
        produto.LAT_Sku__c = '5666';
        produto.RecordTypeId = Global_RecordTypeCache.getRtId( 'LAT_Product__cBRA_Standard' );
        
        LAT_Product__c produto2 = new LAT_Product__c();
        produto2.Name = 'TestProd2';
        produto2.LAT_IsRefactorProduct__c = 'Y';
        produto2.LAT_IsActive__c = true;
        produto2.LAT_CDUnit__c = 'UN';
        produto2.LAT_ExternalId__c = '444';
        //produto2.QT_lead_time__c = 5;
        produto2.LAT_Sku__c = '5667';
        produto2.RecordTypeId = Global_RecordTypeCache.getRtId( 'LAT_Product__cBRA_Standard' );
        insert new List<LAT_Product__c>{produto, produto2};
        


        system.debug(loggingLevel.ERROR, 'TOKEN querys 1: '+Limits.getQueries());
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 2: '+Limits.getQueries());
        
        //Cria nova oportunidade.
        LAT_Opportunity__c opp = new LAT_Opportunity__c();
        opp.Name = 'Opp TESTE COTA';
        opp.LAT_CloseDate__c = Date.today().addDays(1);
        opp.LAT_Account__c = acc.Id;
        opp.LAT_StageName__c = 'Novo Pedido';
        opp.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__cNova_oportunidade');
        insert opp;
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys 5: '+Limits.getQueries());
         
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c();
        oli.LAT_Product__c = produto.Id;
        oli.LAT_Opportunity__c =opp.Id;
        oli.LAT_UnitPrice__c = 12;
        oli.LAT_Quantity__c = 12;
        insert oli;
        


        system.debug(loggingLevel.ERROR, 'TOKEN querys 4: '+Limits.getQueries());
        
        LAT_Account_product_payment__c app = new LAT_Account_product_payment__c();
        app.Account__c = acc.Id;
        app.LAT_Product__c = produto2.Id;
        app.Payment__c = paymentCondition.Id;
        app.PaymentCondition__c = 'Cash';
        app.PaymentConditionDescription__c = 'I will pay1';
        insert app;

        LAT_Account_product_payment__c app2 = new LAT_Account_product_payment__c();
        app2.Account__c = acc.Id;
        app2.LAT_Product__c = produto.Id;
        app2.Payment__c = paymentCondition.Id;
        app2.PaymentCondition__c = 'Cash';
        app2.PaymentConditionDescription__c = 'I will pay2';
        insert app2;        
        
        System.Test.startTest();
        Utils.setMigrationDoneTest(true); 
        
        //Test of class "VFC11_opportunityProductEntryExt_AR"
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        VFC11_opportunityProductEntryExt_AR oPEE = new VFC11_opportunityProductEntryExt_AR(controller);
        VFC11_opportunityProductEntryExt_AR.productWrapper pw = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);
        pw.isSelected = true;
        oPEE.searchString = produto.Name;
        oPEE.varPaymentVal = 'Cash';
        oPEE.paymentValues();
        oPEE.closePopup();
        oPEE.getCondicao();
        oPEE.lstWProducts.add(pw);        
        oPEE.addItensToShoppingCart();
        //oPEE.priceBookCheck();
        oPEE.initAction();
        oPEE.onSave();
        oPEE.onSaveRefresh();
        oPEE.getChosenCurrency();
        oPEE.getlstWProducts();
        oPEE.LAT_shoppingCart[0].LAT_Quantity__c = 10;
        oPEE.removeFromShoppingCart();
        
        /*
        VFC11_opportunityProductEntryExt_AR.productWrapper pww = new VFC11_opportunityProductEntryExt_AR.productWrapper(app);     
        oPEE.lstWProducts.add(pw);
        oPEE.addItensToShoppingCart();
        oPEE.onCancel();
        oPEE.showCampoFormatado();
        oPEE.onSaveRefresh();
        oPEE.onSave();
        */
        
        system.debug(loggingLevel.ERROR, 'TOKEN querys on Test2: '+Limits.getQueries());
        System.Test.stopTest();
    }  
}