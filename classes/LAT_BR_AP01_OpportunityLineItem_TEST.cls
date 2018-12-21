/******************************************************************************************
 *   Company:Valuenet    Developers: Romero Nicolas Javier                Date:11/12/2013 *
 ******************************************************************************************/
 /********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 08/11/2016
*
********************************************************************************/

@isTest(seeAllData=False)
public class LAT_BR_AP01_OpportunityLineItem_TEST{
    
    static testMethod void UnitTest(){
        Utils.setMigrationDoneTest(false);
        Account acc = new Account(Client_code_AN8__c = '100', Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        acc.Client_code_AN8__c = '100';
        //update acc;

        Opportunity opp = new Opportunity(AccountId = acc.Id, NR_order_JDE__c='143123', Name = 'test', NR_customer_order__c = '100', CloseDate = date.today(), Type = 'Replenish', DS_Message1__c = 'test', DS_Message2__c = 'test', StageName = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'Nova_oportunidade'));
        Opportunity opp2 = new Opportunity(AccountId = acc.Id, NR_order_JDE__c='173123', Name = 'test', NR_customer_order__c = '100', CloseDate = date.today(), Type = 'Replenish', DS_Message1__c = 'test', DS_Message2__c = 'test', StageName = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'Nova_oportunidade'));
        Opportunity opp3 = new Opportunity(AccountId = acc.Id, NR_order_JDE__c='123129', Name = 'test', NR_customer_order__c = '100', CloseDate = date.today(), Type = 'Replenish', DS_Message1__c = 'test', DS_Message2__c = 'test', StageName = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'Nova_oportunidade'));       
        insert new List<Opportunity>{opp, opp2, opp3};
        
        Product2 prod1 = new Product2(Name = 'TestProd', IsActive = true, CD_Unit__c = 'CA', Internal_id__c = '444', QT_lead_time__c = 5, SKU__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('Product2' + 'BRA_Standard'));
        Product2 prod2 = new Product2(Name = 'TestProd2', IsActive = true, CD_Unit__c = 'CA', Internal_id__c = '443', SKU__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('Product2' + 'BRA_Standard'));
        insert new List<Product2>{prod1, prod2};

        Id standardPB =  Test.getStandardPricebookId();
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 12, Pricebook2Id = standardPB, IsActive =true, UseStandardPrice = false);
        insert pbe1;
        
        List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(Remover__c = false,Quantity = 200, UOM_AR__c = 'CA', LAT_SkuText__c = '100', PriceBookEntryId = pbe1.Id, UnitPrice = 10, OpportunityId = opp.Id, LAT_MX_KAMPromisedDate__c = date.today(), Descricao_do_status__c = 'Faturado - test', Campo_de_formatacao__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        listOli.add(oli);
        OpportunityLineItem oli2 = new OpportunityLineItem(Remover__c = false, Quantity = 200,UOM_AR__c = 'CA', LAT_SkuText__c = '100', PriceBookEntryId = pbe1.Id, UnitPrice = 10, OpportunityId = opp2.Id, LAT_MX_KAMPromisedDate__c = date.today(), Descricao_do_status__c = 'Cancelado - test');
        listOli.add(oli2);
        
        insert listOli;
        
      //  LAT_BR_AP01_OpportunityLineItem.updateStatusOpportunity(listOli, new List<OpportunityLineItem>(), new Map<Id,OpportunityLineItem>());
        LAT_BR_AP01_OpportunityLineItem.decodeCompositionPrice(listOli);
        //LAT_BR_AP01_OpportunityLineItem.updateStatusOpportunity(listOli, null, null);

    }

    static testMethod void UnitTest2(){
        
        Utils.setMigrationDoneTest(true);
        Account acc = new Account(Client_code_AN8__c = '100', Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        acc.Client_code_AN8__c = '100';
        //update acc;

        LAT_Opportunity__c opp = new LAT_Opportunity__c(LAT_Account__c = acc.Id, LAT_NROrderJDE__c='143123', Name = 'test', LAT_NRCustomerOrder__c = '100', LAT_CloseDate__c = date.today(), LAT_Type__c = 'Replenish', LAT_DSMessage1__c = 'test', LAT_DSMessage2__c = 'test', LAT_StageName__c = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'Nova_oportunidade'));
        LAT_Opportunity__c opp2 = new LAT_Opportunity__c(LAT_Account__c = acc.Id, LAT_NROrderJDE__c='173123', Name = 'test', LAT_NRCustomerOrder__c = '100', LAT_CloseDate__c = date.today(), LAT_Type__c = 'Replenish', LAT_DSMessage1__c = 'test', LAT_DSMessage2__c = 'test', LAT_StageName__c = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'Nova_oportunidade'));
        LAT_Opportunity__c opp3 = new LAT_Opportunity__c(LAT_Account__c = acc.Id, LAT_NROrderJDE__c='123129', Name = 'test', LAT_NRCustomerOrder__c = '100', LAT_CloseDate__c = date.today(), LAT_Type__c = 'Replenish', LAT_DSMessage1__c = 'test', LAT_DSMessage2__c = 'test', LAT_StageName__c = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'Nova_oportunidade'));       
        insert new List<LAT_Opportunity__c>{opp, opp2, opp3};
        
        LAT_Product__c prod1 = new LAT_Product__c(Name = 'TestProd', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '1-444', LAT_IsRefactorProduct__c = 'Y', LAT_QTLeadTime__c = 5, LAT_Sku__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'BRA_Standard'));
        LAT_Product__c prod2 = new LAT_Product__c(Name = 'TestProd2', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '1-443', LAT_IsRefactorProduct__c = 'Y', LAT_Sku__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'BRA_Standard'));
        insert new List<LAT_Product__c>{prod1, prod2};

        
        
        List<LAT_OpportunityLineItem__c> listOli = new List<LAT_OpportunityLineItem__c>();
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c(LAT_Remover__c = false, LAT_Quantity__c = 200, LAT_AR_UOM__c = 'CA', LAT_SkuText__c = '100', LAT_UnitPrice__c = 10, LAT_Opportunity__c = opp.Id, LAT_MX_KAMPromisedDate__c = date.today(), LAT_StatusDescription__c = 'Faturado - test', LAT_FormatField__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        listOli.add(oli);
        LAT_OpportunityLineItem__c oli2 = new LAT_OpportunityLineItem__c(LAT_Remover__c = false, LAT_Quantity__c = 200,LAT_AR_UOM__c = 'CA', LAT_SkuText__c = '100', LAT_UnitPrice__c = 10, LAT_Opportunity__c = opp2.Id, LAT_MX_KAMPromisedDate__c = date.today(), LAT_StatusDescription__c = 'Cancelado - test');
        listOli.add(oli2);
        LAT_BR_AP01_OpportunityLineItem.decodeCompositionPrice(listOli);

        map<id, LAT_OpportunityLineItem__c> mapOlis = new map<id, LAT_OpportunityLineItem__c>();
        for(LAT_OpportunityLineItem__c oli5:listOli){
            mapOlis.put(oli5.Id,oli5);
        }

        insert listOli;

        LAT_OpportunityLineItem__c oli1 = listOli.get(0);
        oli1.LAT_StatusDescription__c = 'Aprovação Test';
        

        LAT_OpportunityLineItem__c oli3 = listOli.get(1);
        oli3.LAT_StatusDescription__c = 'Faturado Test';

        update new List<LAT_OpportunityLineItem__c> {oli1,oli3};
      //  LAT_BR_AP01_OpportunityLineItem.updateStatusOpportunity(listOli, new List<OpportunityLineItem>(), new Map<Id,OpportunityLineItem>());
        LAT_BR_AP01_OpportunityLineItem.decodeCompositionPrice(listOli);
        //LAT_BR_AP01_OpportunityLineItem.updateStatusOpportunity(listOli, null, null);
    }

    static testMethod void UnitTestB(){
    
       /* UDC__c udc = new UDC__c(
            RecordTypeId = Global_RecordTypeCache.getRtId('UDC__c' + 'Standard_AR'),
            Internal_Id__c = 'CRM-PT'
            /*CodUs__c = 'PT',
            CodProd__c = 'CRM'*/
        /*);
        try{insert udc;} catch(exception e){}*/
        Utils.setMigrationDoneTest(false);
        
        Account acc = new Account(Name = 'TEST',/* Payment_Condition__c = udc.id,*/AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '30641670223', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG'));
        insert acc;
        acc.Client_code_AN8__c = '100';
        update acc;
        Test.startTest();
        Utils.setMigrationDoneTest(false);
        Opportunity opp = new Opportunity(AccountId = acc.Id, NR_order_JDE__c='123923', Name = 'test', NR_customer_order__c = '100', CloseDate = date.today(), Type = 'Replenish', DS_Message1__c = 'test', DS_Message2__c = 'test', StageName = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'OPP_1_NewOrder_ARG'));
        Opportunity opp2 = new Opportunity(AccountId = acc.Id, NR_order_JDE__c='128123', Name = 'test', NR_customer_order__c = '100', CloseDate = date.today(), Type = 'Replenish', DS_Message1__c = 'test', DS_Message2__c = 'test', StageName = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'OPP_1_NewOrder_ARG'));
        Opportunity opp3 = new Opportunity(AccountId = acc.Id, NR_order_JDE__c='123723', Name = 'test', NR_customer_order__c = '100', CloseDate = date.today(), Type = 'Replenish', DS_Message1__c = 'test', DS_Message2__c = 'test', StageName = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('Opportunity' + 'OPP_1_NewOrder_ARG'));       
        insert new List<Opportunity>{opp, opp2, opp3};
        
        Product2 prod1 = new Product2(Name = 'TestProd', IsActive = true, CD_Unit__c = 'CA', Internal_id__c = '444', QT_lead_time__c = 5, SKU__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('Product2' + 'Standard_AR'));
        Product2 prod2 = new Product2(Name = 'TestProd2', IsActive = true, CD_Unit__c = 'CA', Internal_id__c = '443', SKU__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('Product2' + 'Standard_AR'));
        insert new List<Product2>{prod1, prod2};

        Id standardPB =  Test.getStandardPricebookId();
        
        PricebookEntry pbe1 = new PricebookEntry(Product2Id = prod1.Id, UnitPrice = 12, Pricebook2Id = standardPB, IsActive =true, UseStandardPrice = false);
        insert pbe1;
        
        List<OpportunityLineItem> listOli = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(Remover__c = false,Quantity = 200, UOM_AR__c = 'CA', LAT_SkuText__c = '100', PriceBookEntryId = pbe1.Id, UnitPrice = 10, OpportunityId = opp.Id, LAT_MX_KAMPromisedDate__c = date.today(), Descricao_do_status__c = 'Faturado - test', Campo_de_formatacao__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        insert oli;
        listOli.add(oli);
        
        OpportunityLineItem oli2 = new OpportunityLineItem(Remover__c = false, Quantity = 200,UOM_AR__c = 'CA', LAT_SkuText__c = '100', PriceBookEntryId = pbe1.Id, UnitPrice = 10, OpportunityId = opp2.Id, LAT_MX_KAMPromisedDate__c = date.today(), Descricao_do_status__c = 'Cancelado - test'); 
        insert oli2;
        listOli.add(oli2);
        
        OpportunityLineItem oli3 = new OpportunityLineItem(Remover__c = false, Quantity = 200,UOM_AR__c = 'CA', LAT_SkuText__c = '100', PriceBookEntryId = pbe1.Id, UnitPrice = 10, OpportunityId = opp2.Id, LAT_MX_KAMPromisedDate__c = date.today(), Descricao_do_status__c = 'Back Order');
        //insert oli3;
        //listOli.add(oli3);
        

        update listOli;
        //insert listOli;
        
        LAT_AR_AP01_OpportunityLineItem.validateStatus( listOli, new Map<Id,OpportunityLineItem>());
        LAT_AR_AP01_OpportunityLineItem.existeItemEmBackOrder(listOli);
       // LAT_AR_AP01_OpportunityLineItem.updateStatusOpportunity(listOli,listOli,new Map<Id,OpportunityLineItem>());
       Test.stopTest();
    }

    static testMethod void UnitTest2B(){
        Utils.setMigrationDoneTest(true);
        Account acc = new Account(Name = 'TEST',/* Payment_Condition__c = udc.id,*/AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '30641670223', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG'));
        insert acc;
        acc.Client_code_AN8__c = '100';
        update acc;

        Test.startTest();
        Utils.setMigrationDoneTest(true);
        LAT_Opportunity__c opp = new LAT_Opportunity__c(LAT_Account__c = acc.Id, 
            LAT_NROrderJDE__c='123923', 
            Name = 'test', 
            LAT_NRCustomerOrder__c = '100', 
            LAT_CloseDate__c = date.today(), 
            LAT_Type__c = 'Replenish', 
            LAT_DSMessage1__c = 'test', 
            LAT_DSMessage2__c = 'test', 
            LAT_StageName__c = 'Novo pedido', 
            RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_1_NewOrder_ARG'));
        LAT_Opportunity__c opp2 = new LAT_Opportunity__c(LAT_Account__c = acc.Id, LAT_NROrderJDE__c='128123', Name = 'test', LAT_NRCustomerOrder__c = '100', LAT_CloseDate__c = date.today(), LAT_Type__c = 'Replenish', LAT_DSMessage1__c = 'test', LAT_DSMessage2__c = 'test', LAT_StageName__c = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_1_NewOrder_ARG'));
        LAT_Opportunity__c opp3 = new LAT_Opportunity__c(LAT_Account__c = acc.Id, LAT_NROrderJDE__c='123723', Name = 'test', LAT_NRCustomerOrder__c = '100', LAT_CloseDate__c = date.today(), LAT_Type__c = 'Replenish', LAT_DSMessage1__c = 'test', LAT_DSMessage2__c = 'test', LAT_StageName__c = 'Novo pedido', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'OPP_1_NewOrder_ARG'));       
        insert new List<LAT_Opportunity__c>{opp, opp2, opp3};
        
        LAT_Product__c prod1 = new LAT_Product__c(Name = 'TestProd', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '444', LAT_QTLeadTime__c = 5, LAT_Sku__c = '5666', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'Standard_AR'));
        LAT_Product__c prod2 = new LAT_Product__c(Name = 'TestProd2', LAT_IsActive__c = true, LAT_CDUnit__c = 'CA', LAT_ExternalID__c = '443', LAT_Sku__c = '5667', RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Product__c' + 'Standard_AR'));
        insert new List<LAT_Product__c>{prod1, prod2};

        
        List<LAT_OpportunityLineItem__c> listOli = new List<LAT_OpportunityLineItem__c>();
        LAT_OpportunityLineItem__c oli = new LAT_OpportunityLineItem__c(
            LAT_Remover__c = false,LAT_Quantity__c = 200, 
            LAT_AR_UOM__c = 'CA', 
            LAT_SkuText__c = '100',  
            LAT_UnitPrice__c = 10, 
            LAT_Opportunity__c = opp.Id, 
            LAT_MX_KAMPromisedDate__c = date.today(), 
            LAT_StatusDescription__c = 'Faturado - test', 
            LAT_FormatField__c = 'Preço Base - Cond. Pagto com ICMS|1|133,33|1933,12|15464,96#Desconto PRB|1|-71,81|-1041,18|-8329,43#Valor NF PRB|1|61,52|891,94|7135,53#Desconto Faseamento|1|0,00|0,00|0,00#Desconto FOB|1|0,00|0,00|0,00#PIS|1|0,00|0,00|0,00#COFINS|1|0,00|0,00|0,00#Valor Mercadoria|1|61,52|891,94|7135,53#IPI|1|0,00|0,00|0,00#Valor Mercadoria + IPI|1|61,52|891,94|7135,53#Substitução Tributaria|1|8,75|126,90|1015,2#Valor Total NF|1|70,27|1018,84|8150,74');
        insert oli;
        listOli.add(oli);
        LAT_OpportunityLineItem__c oli2 = new LAT_OpportunityLineItem__c(
            LAT_Remover__c = false, 
            LAT_Quantity__c = 200,
            LAT_AR_UOM__c = 'CA', 
            LAT_SkuText__c = '100', 
            LAT_UnitPrice__c = 10, 
            LAT_Opportunity__c = opp2.Id, 
            LAT_MX_KAMPromisedDate__c = date.today(), 
            LAT_StatusDescription__c = 'Cancelado - test');
        insert oli2;
        listOli.add(oli2);
        LAT_OpportunityLineItem__c oli3 = new LAT_OpportunityLineItem__c(
            LAT_Remover__c = false, 
            LAT_Quantity__c = 200,
            LAT_AR_UOM__c = 'CA', 
            LAT_SkuText__c = '100', 
            LAT_UnitPrice__c = 10, 
            LAT_Opportunity__c = opp2.Id, 
            LAT_MX_KAMPromisedDate__c = date.today(), 
            LAT_StatusDescription__c = 'Back Order');
        //insert oli3;
        //listOli.add(oli3);

        update listOli;
        //insert listOli;
        
        LAT_AR_AP01_OpportunityLineItem.validateStatus( listOli, new Map<Id,LAT_OpportunityLineItem__c>());
        LAT_AR_AP01_OpportunityLineItem.existeItemEmBackOrder(listOli);
       // LAT_AR_AP01_OpportunityLineItem.updateStatusOpportunity(listOli,listOli,new Map<Id,OpportunityLineItem>());
       Test.stopTest();
    }
}