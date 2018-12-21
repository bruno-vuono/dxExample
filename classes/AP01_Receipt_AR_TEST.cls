/********************************************************************************
*  Company:Valuenet     Developer:Elena Schwarzböck      Date:09/04/2013        *
********************************************************************************/

@istest
public with sharing class AP01_Receipt_AR_TEST{

    static testMethod void unitTest1(){
                    
        Account acc = new Account(
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG'),
            CNPJ__c = '20354266645',
            Name = 'testAccount',
            Type = 'Prospect_ARG',
            Corporate_Name__c = 'test',
            Channel_Type__c = 'Direto',
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
        
        system.Test.startTest();
        
        RCP_Receipt_ARG__c receipt = new RCP_Receipt_ARG__c(
            Account_AR__c = acc.id,
            LAT_AR_DepositAccountType__c = 'C',
            RecordTypeId = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c' + 'RCP_ReceiptGeneratedDepositDone_AR')
        );
        insert receipt;
        
        DCM_Documents_ARG__c doc = new DCM_Documents_ARG__c(
            Amounttoapply_AR__c = 200,
            Internal_id_pk_AR__c = 'TEST',
            ReceiptNo_AR__c = receipt.id,
            RecordTypeId = Global_RecordTypeCache.getRtId('DCM_Documents_ARG__c' + 'DCM_Standard_AR')
        );
        insert doc;
        
        Titulos__c titulo = new Titulos__c(
            NetSRReceipts_AR__c = 200,
            Internal_id_pk__c = 'TEST',
            Cliente__c = acc.id,
            codigoCia__c = 'TEST',
            dataEmissao__c = date.today(),
            dataVencimentoAtual__c = date.today(),
            dataVencimentoOriginal__c = date.today(),
            numeroDocumento__c = 1,
            parcela__c = 'T',
            valorOriginalTitulo__c = 10,
            Ruinusebypendingreceipt_AR__c = receipt.id,
            valorSaldo__c = 10,
            RecordTypeId = Global_RecordTypeCache.getRtId('Titulos__c' + 'Standard_AR')
        );
        insert titulo;
        
        delete receipt;
        
        system.Test.stopTest();
        
    }
    
    static testMethod void unitTest2(){
        
        Account acc = new Account(
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG'),
            CNPJ__c = '20354266645',
            Name = 'testAccount',
            Type = 'Prospect_ARG',
            Corporate_Name__c = 'test',
            Channel_Type__c = 'Direto',
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
        
        system.Test.startTest();
        
        RCP_Receipt_ARG__c rece = new RCP_Receipt_ARG__c(
            Account_AR__c = acc.id,
            LAT_AR_DepositAccountType__c = 'C',
            RecordTypeId = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c' + 'RCP_ReceiptGeneratedDepositDone_AR')
        );
        
        insert rece;

        DPT_Deposit_ARG__c dep = new DPT_Deposit_ARG__c(
            ReceiptNo_AR__c = rece.id,
            Amount_AR__c = 123,
            AccType_AR__c = 'Bank Account',
            Name = '2',
            RecordTypeId = Global_RecordTypeCache.getRtId('DPT_Deposit_ARG__c' + 'DPT_Standard_AR')
        );
        
        insert dep;
        
        rece.LAT_AR_DepositAccountType__c = 'R';
        update rece;
        
        rece.LAT_AR_DepositAccountType__c = 'c';
        update rece;
        
        system.Test.stopTest();
        
    }
    
    static testMethod void unitTest3(){
                
        Account acc = new Account(
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG'),
            CNPJ__c = '20354266645',
            Name = 'testAccount',
            Type = 'Prospect_ARG',
            Corporate_Name__c = 'test',
            Channel_Type__c = 'Direto',
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
        
        system.Test.startTest();
        
        RCP_Receipt_ARG__c rece = new RCP_Receipt_ARG__c(
            Account_AR__c = acc.id,
            Status_AR__c = 'Receipt Deposited',
            LAT_AR_DepositAccountType__c = 'C',
            RecordTypeId = Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c' + 'RCP_ReceiptGeneratedDepositDone_AR')
        );
        
        insert rece;
        
        DPT_Deposit_ARG__c dep = new DPT_Deposit_ARG__c(
            ReceiptNo_AR__c = rece.id,
            Amount_AR__c = 123,
            AccType_AR__c = 'Bank Account',
            Name = '2',
            RecordTypeId = Global_RecordTypeCache.getRtId('DPT_Deposit_ARG__c' + 'DPT_Standard_AR')
        );
        
        insert dep;
        
        VLS_Values_ARG__c val = new VLS_Values_ARG__c(
            ReceiptNo_AR__c = rece.id,
            Bank_AR__c = '123',
            BranBranch_AR__c = '123',
            Name = '333458',
            RecordTypeId = Global_RecordTypeCache.getRtId('VLS_Values_ARG__c' + 'VLS_tandard_AR')
        );
        insert val;
        
        TXC_TaxCertificates_ARG__c tax = new TXC_TaxCertificates_ARG__c(
            ReceiptNo_AR__c = rece.id,
            RecordTypeId = Global_RecordTypeCache.getRtId('TXC_TaxCertificates_ARG__c' + 'TXC_Standard_AR')
        );
        insert tax;
        
        
        rece.Status_AR__c = 'Receipt Verified';
        update rece;
        
        system.Test.stopTest();
        
    }
}