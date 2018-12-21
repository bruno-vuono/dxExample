/*******************************************************************************************
*   Company:Valuenet    Developer:   Tomás Etchegaray               Date:05/04/2013        *
*******************************************************************************************/
@isTest
public with sharing class VFC01_ReceiptSelectController_AR_TEST {
    
@isTest (seealldata=true)   
    static void unitTest() {
        
        string recordOffTradeArg = Global_RecordTypeCache.getRtId('Account'+'ACC_1_OffTrade_ARG');
        
        Account acc = new Account(
        RecordTypeId = recordOffTradeArg, 
        CNPJ__c = '20354266645',
        Name = 'testAccount',
        Type = 'Prospect_ARG',
        Corporate_Name__c = 'test',
        Channel_Type__c = 'Direto',
        Segmentation_Type_on_trade__c = 'Restaurant_ARG',
        Sub_Channel__c = 'Delicatessen',
        AddressLine1_AR__c= 'test',
        Shipping_Neighbourhood__c = 'test',
        Revenue_Neighbourhood__c = 'test',
        Billing_Neighbourhood__c ='test',
        Shipping_Country__c ='test',
        Revenue_Country__c ='test',
        Billing_Country__c ='test'
        );
        
        insert acc;
        test.startTest();
         Titulos__c tit = new Titulos__c(
         
         Cliente__c = acc.id,
         Internal_id_pk__c= 'asd',
         codigoCia__c = '123',
         dataVencimentoAtual__c = date.today(),
         dataVencimentoOriginal__c = date.today(),
         dataEmissao__c = date.today(),
         ActualDeliveryDate_AR__c = date.today(),
         numeroDocumento__c = 123,
         observacoesTitulo__c = 'ASD',
         valorOriginalTitulo__c = 123,
         valorSaldo__c = 123,
         parcela__c = '123'
         );
         
         insert tit;
         
      //  ApexPages.standardController TestController = new ApexPages.standardController(acc.id);
        
        Apexpages.currentPage().getParameters().put('idAcc', acc.Id); 
        Apexpages.currentPage().getParameters().put('idArray', tit.Id);
        
        
        VFC01_ReceiptSelectController_AR TestController = new VFC01_ReceiptSelectController_AR();
        string record = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c'+'RCP_ReceiptGeneratedDepositDone_AR');
        TestController.value = record;
        TestController.doContinue();
        TestController.cancel();
        test.stopTest();
        
    }
@isTest (seealldata=true)
    static void unitTest2() {
        
        string recordOffTradeArg = Global_RecordTypeCache.getRtId('Account'+'ACC_1_OffTrade_ARG');
        
        Account acc = new Account(
        RecordTypeId = recordOffTradeArg, 
        CNPJ__c = '20354266645',
        Name = 'testAccount',
        Type = 'Prospect_ARG',
        Corporate_Name__c = 'test',
        Channel_Type__c = 'Direto',
        Segmentation_Type_on_trade__c = 'Restaurant_ARG',
        Sub_Channel__c = 'Delicatessen',
        AddressLine1_AR__c= 'test',
        Shipping_Neighbourhood__c = 'test',
        Revenue_Neighbourhood__c = 'test',
        Billing_Neighbourhood__c ='test',
        Shipping_Country__c ='test',
        Revenue_Country__c ='test',
        Billing_Country__c ='test'
        );
        
        insert acc;
        
         Titulos__c tit = new Titulos__c(
         
         Cliente__c = acc.id,
         Internal_id_pk__c= 'asd',
         codigoCia__c = '123',
         dataVencimentoAtual__c = date.today(),
         dataVencimentoOriginal__c = date.today(),
         dataEmissao__c = date.today(),
         ActualDeliveryDate_AR__c = date.today(),
         numeroDocumento__c = 123,
         observacoesTitulo__c = 'ASD',
         valorOriginalTitulo__c = 123,
         valorSaldo__c = 123,
         parcela__c = '123'
         );
         
         insert tit;
         
      //  ApexPages.standardController TestController = new ApexPages.standardController(acc.id);
        
        Apexpages.currentPage().getParameters().put('idAcc', acc.Id); 
        Apexpages.currentPage().getParameters().put('idArray', tit.Id);
        
        
        VFC01_ReceiptSelectController_AR TestController = new VFC01_ReceiptSelectController_AR();
        string record = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c'+'RCP_ReceiptGeneratedDepositPending_AR');
        TestController.value = record;
        TestController.doContinue();
        test.startTest();
        record = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c'+'Receipt_withholding_certificates_AR');
        TestController.value = record;
        TestController.doContinue();
        record = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c'+'RCP_ReceiptGeneratedDepositDone_UY');
        TestController.value = record;
        TestController.doContinue();
        record = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c'+'RCP_ReceiptGeneratedDepositPending_UY');
        TestController.value = record;
        TestController.doContinue();
        TestController.decodeMessage('ENTITY_IS_LOCKED');
        TestController.decodeMessage('REQUIRED_FIELD_MISSING');
        TestController.decodeMessage('blahblahblah');
        test.stopTest();
    }

}