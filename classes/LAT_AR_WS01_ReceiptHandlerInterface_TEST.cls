/******************************************************************************************
*   Company:Valuenet    Developers:   Elena J. Schwarzböck               Date:30/05/2014  *
*******************************************************************************************/
@istest
public with sharing class LAT_AR_WS01_ReceiptHandlerInterface_TEST {

    static testMethod void unitTest(){
            
        Account acc = new Account(
            RecordTypeId =  Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG'),
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
                
        RCP_Receipt_ARG__c receipt = new RCP_Receipt_ARG__c(
            Account_AR__c = acc.id,
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
               
        VLS_Values_ARG__c value = new VLS_Values_ARG__c(
            RecordTypeId = Global_RecordTypeCache.getRtId('VLS_Values_ARG__c' + 'VLS_tandard_AR'),
            ReceiptNo_AR__c = receipt.id,
            ValueType_AR__c = 'E',
            Name = '333458',
            Bank_AR__c = '123',
             BranBranch_AR__c = '123'
        );
        insert value;
        
        TXC_TaxCertificates_ARG__c tax = new TXC_TaxCertificates_ARG__c(
            Name = '000',
            Amount_AR__c = 100,
            ValueType_AR__c = 'TEST',
            ReceiptNo_AR__c = receipt.id,
            RecordtypeId = Global_RecordTypeCache.getRtId('TXC_TaxCertificates_ARG__c' + 'TXC_Standard_AR')
        );
        insert tax;
        
        DPT_Deposit_ARG__c deposit = new DPT_Deposit_ARG__c(
            ReceiptNo_AR__c = receipt.id,
            Amount_AR__c = 123,
            AccType_AR__c = 'Bank Account',
            Name = '2'
        );       
        insert deposit;    
        
        System.Test.startTest();
        
        LAT_AR_WS01_ReceiptHandlerInterface.ReceiptInterfaceJDE(receipt.id);
        
        CS001_JDEInterfaceCredentials__c cred = new CS001_JDEInterfaceCredentials__c(
            Name = 'Argentina',
            Country__c = '6',
            EndPoint_BalanceCheck__c = 'http://crm.test.pernod-ricard.com.br/PernodRicard/BalanceCheck/BalanceCheckProxy',
            EndPoint_ContractManager__c = 'http://crm.test.pernod-ricard.com.br/SalesForce/ContractManager/ContractManagerProxy',
            EndPoint_CustomerHandler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Customer/CustomerHandlerReq',
            EndPoint_CustomerVerify__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Customer/CustomerVerifyReq',
            EndPoint_PaymentManager__c = 'http://crm.test.pernod-ricard.com.br/PernodRicard/PaymentManager/PaymentManagerProxy',
            EndPoint_PriceCalculation__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Price/PriceCalculationReq',
            EndPoint_RVManager__c = 'http://crm.test.pernod-ricard.com.br/SalesForce/RVManager/RVManagerProxy',
            EndPoint_SalesOrderHandler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/SalesOrder/AsyncSalesOrderHandlerReq',
            EndPoint_ReceiptHandeler__c = 'http://crm.test.pernod-ricard.com.br/SFDC/Collection/CollectionManagerSFDCReq',
            Endpoint_GetStock__c = 'https://osbqa.pramericas.com/Secure/SFDC/Inventory/GetStock?wsdl',
            RemoteHostIP__c = '200.200.10.10',
            System__c = 'X',
            SystemUserID__c = 'cloud2b'
        );
        
        insert cred;

        System.Test.stopTest();
    }
    
}