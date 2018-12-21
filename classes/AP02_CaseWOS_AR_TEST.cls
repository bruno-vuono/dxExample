/*************************************************************************************************************
*   Company:Valuenet    Developers:   Tomás Etchegaray               Date:21/03/2013     *
**************************************************************************************************************/
 /********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 21/11/2016
*
********************************************************************************/
@isTest
public with sharing class AP02_CaseWOS_AR_TEST {
    @isTest
    static void unitTest2() {
            
        Utils.setMigrationDoneTest(false);        
        User admin = [SELECT Id FROM user WHERE Profile.Name = 'System Administrator' AND isActive = true limit 1];                  
        list<RecordType> listRT = [select id, DeveloperName from RecordType WHERE (SobjectType='Case' AND DeveloperName = 'CSE_1_AccountAlteration_ARG') OR (DeveloperName = 'ACC_1_OffTrade_ARG' AND SobjectType='Account')];                  
        
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
              Name = 'AR_USERS_CLOSING_CASES',
              LAT_Value__c = admin.id);
        insert cfg;

        system.runas(admin){
  
        Account acc = new Account(
        RecordTypeId = listRT[0].Id,
        CNPJ__c = '33700964049',
        Name = 'testAccount',
        Type = 'Sale_ARG',
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
        
        Utils.setMigrationDoneTest(false);
        Case caso = new Case(
            RecordTypeId = listRT[1].Id,
            status= 'Fechado e resolvido',
            Reason = 'Alt. cliente pai',
            Description = 'TEST',
            Type = 'Account Alteration ARG',
            AccountId= acc.id
        );
        
        insert caso;

      
        system.Test.stopTest();
        
        }                             

    }


       @isTest
    static void unitTest21() {
            
        Utils.setMigrationDoneTest(false);        
        User admin = [SELECT Id FROM user WHERE Profile.Name = 'System Administrator' AND isActive = true limit 1];                  
        list<RecordType> listRT = [select id, DeveloperName from RecordType WHERE (SobjectType='Case' AND DeveloperName = 'CSE_1_AccountAlteration_ARG') OR (DeveloperName = 'ACC_1_OffTrade_ARG' AND SobjectType='Account')];                  
        
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
              Name = 'AR_USERS_CLOSING_CASES',
              LAT_Value__c = admin.id);
        insert cfg;

        system.runas(admin){
  
        String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        
        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000', 
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Status__c = 'Inactive Account',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX,
            Reason_for_Inactivation__c = 'this is one love'
        );
        insert acc;
        Test.startTest();
        String rtCraOffMX = Global_RecordTypeCache.getRtId('CRA_CredAnalysis_ARG__c' + 'LAT_MX_CRA_Standard');
        
        CRA_CredAnalysis_ARG__c cra = new CRA_CredAnalysis_ARG__c(
            SalesmanComments_ARG__c = 'test',
            CreditAnalystComment_ARG__c = 'test',
            LastFinancialPresentedDate_ARG__c = date.today(),
            Account_ARG__c = acc.Id,
            CommercialGuarantee_ARG__c = true, 
            CommercialGuarantExpDate_ARG__c = date.today(),
            CreditRiskIndex_ARG__c = '03',
            RevisionDate_ARG__c = date.today(),
            LastCreditReview_ARG__c = date.today(),
            LAT_MX_Deposit__c = 1000,
            LAT_MX_Mortgage__c = 1000,
            CreditLimitRequested_ARG__c = 100,
            CreditLimitGranted_ARG__c = 100,
            LAT_MX_ApprovalProcessAproved__c = false,
            RecordTypeId = rtCraOffMX
        );

        insert cra;

        Utils.setMigrationDoneTest(false);
           
        Case caso = new Case(
            RecordTypeId = listRT[1].Id,
            status= 'Nuevo caso',
            Reason = 'Alt. limite de crédito',
            Description = 'TEST',
            Type = 'Account Alteration ARG',
            AccountId= acc.id,
            LAT_APStep__c = 2,
            Credit_Analysis_AR__c = cra.id
        );
        System.debug('%%%%%%%%%%  en unitTest144');
        insert caso;
        caso.status = 'Fechado e resolvido';
        update caso;
        caso.LAT_APStep__c = 3;
        caso.Reason = 'Solicitação de inativação de cliente';
        acc.status__c = 'Inactive Account';
        update acc;

        //update caso;
        system.Test.stopTest();
        
        }                             

    }

    @isTest
    static void unitTest14() {
            
        Utils.setMigrationDoneTest(false);        
        User admin = [SELECT Id FROM user WHERE Profile.Name = 'System Administrator' AND isActive = true limit 1];                  
        list<RecordType> listRT = [select id, DeveloperName from RecordType WHERE (SobjectType='Case' AND DeveloperName = 'CSE_1_AccountAlteration_ARG') OR (DeveloperName = 'ACC_1_OffTrade_ARG' AND SobjectType='Account')];                  
        
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
              Name = 'AR_USERS_CLOSING_CASES',
              LAT_Value__c = admin.id);
        insert cfg;

        system.runas(admin){
  
        String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        
        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000', 
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            status__c = 'Inactive Account',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX,
            Reason_for_Inactivation__c = 'this is one love'
        );
        insert acc;
        Test.startTest();
        String rtCraOffMX = Global_RecordTypeCache.getRtId('CRA_CredAnalysis_ARG__c' + 'LAT_MX_CRA_Standard');
        
        CRA_CredAnalysis_ARG__c cra = new CRA_CredAnalysis_ARG__c(
            SalesmanComments_ARG__c = 'test',
            CreditAnalystComment_ARG__c = 'test',
            LastFinancialPresentedDate_ARG__c = date.today(),
            Account_ARG__c = acc.Id,
            CommercialGuarantee_ARG__c = true, 
            CommercialGuarantExpDate_ARG__c = date.today(),
            CreditRiskIndex_ARG__c = '03',
            RevisionDate_ARG__c = date.today(),
            LastCreditReview_ARG__c = date.today(),
            LAT_MX_Deposit__c = 1000,
            LAT_MX_Mortgage__c = 1000,
            CreditLimitRequested_ARG__c = 100,
            CreditLimitGranted_ARG__c = 100,
            LAT_MX_ApprovalProcessAproved__c = false,
            RecordTypeId = rtCraOffMX
        );

        insert cra;

        Utils.setMigrationDoneTest(false);
           
        Case caso = new Case(
            RecordTypeId = listRT[1].Id,
            status= 'Nuevo caso',
            Reason = 'Alt. limite de crédito',
            Description = 'TEST',
            Type = 'Account Alteration ARG',
            AccountId= acc.id,
            LAT_APStep__c = 2,
            Credit_Analysis_AR__c = cra.id
        );
        System.debug('%%%%%%%%%%  en unitTest14');
        insert caso;
        caso.status = 'Fechado e resolvido';
        caso.LAT_APStep__c = 3;
        update caso;
      
        system.Test.stopTest();
        
        }                             

    }

   

    //MIGRATED 21/11/2016 
    @isTest
    static void unitTestLATCase21(){
        Utils.setMigrationDoneTest(true);
                    
        User admin = [SELECT Id FROM user WHERE Profile.Name = 'System Administrator' AND isActive = true limit 1];                  
        list<RecordType> listRT = [select id, DeveloperName from RecordType WHERE SobjectType='LAT_Case__c' AND DeveloperName = 'CSE_1_AccountAlteration_ARG'];                  
        list<RecordType> listRT1 = [select id, DeveloperName from RecordType WHERE DeveloperName = 'ACC_1_OffTrade_ARG' AND SobjectType='Account'];  
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
              Name = 'AR_USERS_CLOSING_CASES',
              LAT_Value__c = admin.id);
        insert cfg;

        system.runas(admin){
  
        Account acc = new Account(
        RecordTypeId = listRT1[0].Id,
        CNPJ__c = '33700964049',
        Name = 'testAccount',
        Type = 'Sale_ARG',
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

        Utils.setMigrationDoneTest(true);            
        LAT_Case__c caso = new LAT_Case__c(
            RecordTypeId = listRT[0].Id,
            LAT_status__c = 'Fechado e resolvido',
            LAT_Reason__c = 'Alt. cliente pai',
            LAT_Description__c = 'TEST',
            LAT_Type__c = 'Account Alteration ARG',
            LAT_Account__c= acc.id
        );
        
        insert caso;
        caso.LAT_status__c = 'Fechado e resolvido';
        //update caso;
        
        system.Test.stopTest();
        
        }                             

    }
 //MIGRATED 21/11/2016 
    @isTest
    static void unitTestLATCase4(){
               
        Utils.setMigrationDoneTest(true);     
        User admin = [SELECT Id FROM user WHERE Profile.Name = 'System Administrator' AND isActive = true limit 1];                  
        list<RecordType> listRT = [select id, DeveloperName from RecordType WHERE (SobjectType='LAT_Case__c' AND DeveloperName = 'CSE_1_AccountAlteration_ARG') OR (DeveloperName = 'ACC_1_OffTrade_ARG' AND SobjectType='Account')];                  
        
        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
              Name = 'AR_USERS_CLOSING_CASES',
              LAT_Value__c = admin.id);
        insert cfg;

        system.runas(admin){
  
        String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        
        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000', 
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Status__c = 'Inactive Account',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX,
            Reason_for_Inactivation__c = 'this is one love'
        );
        insert acc;
        Test.startTest();
        Utils.setMigrationDoneTest(true);
        String rtCraOffMX = Global_RecordTypeCache.getRtId('CRA_CredAnalysis_ARG__c' + 'LAT_MX_CRA_Standard');
        
        CRA_CredAnalysis_ARG__c cra = new CRA_CredAnalysis_ARG__c(
            SalesmanComments_ARG__c = 'test',
            CreditAnalystComment_ARG__c = 'test',
            LastFinancialPresentedDate_ARG__c = date.today(),
            Account_ARG__c = acc.Id,
            CommercialGuarantee_ARG__c = true, 
            CommercialGuarantExpDate_ARG__c = date.today(),
            CreditRiskIndex_ARG__c = '03',
            RevisionDate_ARG__c = date.today(),
            LastCreditReview_ARG__c = date.today(),
            LAT_MX_Deposit__c = 1000,
            LAT_MX_Mortgage__c = 1000,
            CreditLimitRequested_ARG__c = 100,
            CreditLimitGranted_ARG__c = 100,
            LAT_MX_ApprovalProcessAproved__c = false,
            RecordTypeId = rtCraOffMX
        );

        insert cra;

                      
        
        
        //acc.Reason_for_Inactivation__c = 'this is love';
        //update acc;

        LAT_Case__c caso = new LAT_Case__c(
            RecordTypeId = listRT[0].Id,
            LAT_status__c = 'Nuevo caso',
            LAT_Reason__c = 'Alt. limite de crédito',
            LAT_Description__c = 'TEST',
            LAT_Type__c = 'Account Alteration ARG',
            LAT_Account__c= acc.id,
            LAT_IsAdmin__c = true,
            LAT_APStep__c = 2,
            LAT_AR_CreditAnalysis__c = cra.id
        );
        
        insert caso;
        
        caso.LAT_APStep__c = 3;
        caso.LAT_Reason__c = 'Solicitação de inativação de cliente';
        update caso;
        
        system.Test.stopTest();


        }
                                     

    }
    
    
}