@isTest
private class LAT_UpdateAccountOwner_Batch_Test
{
    @isTest
    static void updateAccountOwnerAndAccountRelatedObjects(){

        insert new LAT_GeneralConfig__c (Name = 'ACCOUNT_OWNER_UPDATE', LAT_Value__c = 'ARS;');
        insert new LAT_GeneralConfig__c (Name = 'MASIVE_OWNER_EMAIL_TARGET_ADDRESSES', LAT_Value__c =  'test10@gmail.com');

        Profile p = [SELECT Id FROM Profile WHERE Name = 'LAT_BR2_Vendas' LIMIT 1]; 
            
        User u = new User(
            Alias = 'testB', 
            Email='testAlias@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='TestUser1', 
            FirstName = 'TestUser1',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testAlias@testorg.com'
        );      
        insert u;

        Account testAccount = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        testAccount.OwnerId = u.Id;

        insert testAccount;

        LAT_Opportunity__c testOpp = LAT_Opportunity_TestFactory.LAT_getCRMOppty(testAccount.Id);
        insert testOpp;

        Contact c = new Contact(LastName= 'Contact1', FirstName = 'Surname1', AccountId = testAccount.id);
        insert c;

        String recordType = Global_RecordTypeCache.getRtId('LAT_Case__c' + 'Alteracao_cadastro_de_clientes');
        
        Utils.setMigrationDoneTest(true);
        
        Test.startTest();
        LAT_Case__c latCase = new LAT_Case__c(RecordTypeId = recordType, LAT_Type__c= 'Alteração - Cadastro de cliente', LAT_Reason__c = 'Alt. tipo cliente',  LAT_Status__c = 'Reprovado', LAT_Account__c = testAccount.id);
        insert latCase;


        LAT_VFC09_MasiveOwnerUpdateDynamic cont = new LAT_VFC09_MasiveOwnerUpdateDynamic();
        cont.accOldLookup = testAccount;
        cont.accNewLookup = testAccount;
        cont.getAccountsPerUser();
        cont.listInnerAccount[0].isSelected = true;
        cont.transferAccounts();

        List<LAT_MasiveOwnerHeader__c> header = [Select id, LAT_Status__c from LAT_MasiveOwnerHeader__c limit 1];

        if(!header.isEmpty()){
            header.get(0).LAT_Status__c = 'Approval';

            update header;

            header.get(0).LAT_Status__c = 'Execution';

            update header;

        }

        Test.stopTest();

    }

    @isTest
    static void updateAccountOwnerAndAccountRelatedObjects2(){
        
        insert new LAT_GeneralConfig__c (Name = 'ACCOUNT_OWNER_UPDATE', LAT_Value__c = 'ARS;');
        insert new LAT_GeneralConfig__c (Name = 'MASIVE_OWNER_EMAIL_TARGET_ADDRESSES', LAT_Value__c =  'test10@gmail.com');

        Profile p = [SELECT Id FROM Profile WHERE Name = 'LAT_BR2_Vendas' LIMIT 1]; 
            
        User u = new User(
            Alias = 'testB', 
            Email='testAlias@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='TestUser1', 
            FirstName = 'TestUser1',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testAlias@testorg.com'
        );      
        insert u;

        Account testAccount = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        testAccount.OwnerId = u.Id;

        insert testAccount;
        
        Utils.setMigrationDoneTest(true);
        
        LAT_FiscalNote__c fn = new LAT_FiscalNote__c( Name = 'Test', 
                                        LAT_BillingDate__c = Date.today().addMonths(-13),
                                        LAT_Client__c = testAccount.id );
        insert fn;

        LAT_ReferenceAccount__c rf = new LAT_ReferenceAccount__c();
        rf.Account__c = testAccount.id;
        rf.isActive__c = true;
        rf.OwnerId = u.Id;

        insert rf;

        LAT_SellOutCollect__c soc = new LAT_SellOutCollect__c();
        soc.CollectDate__c = Date.today();
        soc.Unit__c='CA';
        soc.ReferencedMonth__c = Date.newInstance(Integer.valueOf(Date.today().year()), Integer.valueOf(Date.today().month()), 1);
        soc.Status__c = 'Filling';
        soc.ReferenceAccount__c = rf.id;
        soc.AccountID__c = testAccount.Id;
        insert soc;

        LAT_InventoryPOP__c inv = new LAT_InventoryPOP__c();
        inv.Client__c = testAccount.id;
        insert inv;


        Test.startTest();
        
        LAT_VFC09_MasiveOwnerUpdateDynamic cont = new LAT_VFC09_MasiveOwnerUpdateDynamic();
        cont.accOldLookup = testAccount;
        cont.accNewLookup = testAccount;
        cont.getAccountsPerUser();
        cont.listInnerAccount[0].isSelected = true;
        cont.transferAccounts();

        List<LAT_MasiveOwnerHeader__c> header = [Select id, LAT_Status__c from LAT_MasiveOwnerHeader__c limit 1];

        if(!header.isEmpty()){
            header.get(0).LAT_Status__c = 'Approval';

            update header;

            header.get(0).LAT_Status__c = 'Execution';

            update header;

        }

        Test.stopTest();

    }

    @isTest
    static void updateAccountOwnerAndAccountRelatedObjects3(){

        
        insert new LAT_GeneralConfig__c (Name = 'ACCOUNT_OWNER_UPDATE', LAT_Value__c = 'ARS;');
        insert new LAT_GeneralConfig__c (Name = 'MASIVE_OWNER_EMAIL_TARGET_ADDRESSES', LAT_Value__c =  'test10@gmail.com');

        Profile p = [SELECT Id FROM Profile WHERE Name = 'LAT_BR2_Vendas' LIMIT 1]; 
            
        User u = new User(
            Alias = 'testB', 
            Email='testAlias@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='TestUser1', 
            FirstName = 'TestUser1',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testAlias@testorg.com'
        );      
        insert u;

        Account testAccount = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        testAccount.OwnerId = u.Id;

        insert testAccount;

        Utils.setMigrationDoneTest(true);    
        
        createVisita(testAccount);
        Test.startTest();
        Utils.setMigrationDoneTest(true); 
        createContract(testAccount);
       
           
        LAT_VFC09_MasiveOwnerUpdateDynamic cont = new LAT_VFC09_MasiveOwnerUpdateDynamic();
        cont.accOldLookup = testAccount;
        cont.accNewLookup = testAccount;
        cont.getAccountsPerUser();
        cont.listInnerAccount[0].isSelected = true;
        cont.transferAccounts();

        List<LAT_MasiveOwnerHeader__c> header = [Select id, LAT_Status__c from LAT_MasiveOwnerHeader__c limit 1];

        if(!header.isEmpty()){
            header.get(0).LAT_Status__c = 'Approval';

            update header;

            header.get(0).LAT_Status__c = 'Execution';

            update header;

        }

        Test.stopTest();

    }

    @isTest
    static void updateAccountOwnerAndAccountRelatedObjects4(){
        
        insert new LAT_GeneralConfig__c (Name = 'ACCOUNT_OWNER_UPDATE', LAT_Value__c = 'ARS;');
        insert new LAT_GeneralConfig__c (Name = 'MASIVE_OWNER_EMAIL_TARGET_ADDRESSES', LAT_Value__c =  'test10@gmail.com');

        Profile p = [SELECT Id FROM Profile WHERE Name = 'LAT_BR2_Vendas' LIMIT 1]; 
            
        User u = new User(
            Alias = 'testB', 
            Email='testAlias@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='TestUser1', 
            FirstName = 'TestUser1',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='testAlias@testorg.com'
        );      
        insert u;

        Account testAccount = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        testAccount.OwnerId = u.Id;

        insert testAccount;

        String recordType = Global_RecordTypeCache.getRtId('LAT_Case__c' + 'Alteracao_cadastro_de_clientes');
        
        Utils.setMigrationDoneTest(true);
        
        LAT_Case__c latCase = new LAT_Case__c(RecordTypeId = recordType, LAT_Type__c= 'Alteração - Cadastro de cliente', LAT_Reason__c = 'Alt. tipo cliente',  LAT_Status__c = 'Reprovado', LAT_Account__c = testAccount.id);
        insert latCase;

        Test.startTest();

        LAT_VFC09_MasiveOwnerUpdateDynamic cont = new LAT_VFC09_MasiveOwnerUpdateDynamic();
        cont.accOldLookup = testAccount;
        cont.accNewLookup = testAccount;
        cont.getAccountsPerUser();
        cont.listInnerAccount[0].isSelected = true;
        cont.transferAccounts();

        List<LAT_MasiveOwnerHeader__c> header = [Select id, LAT_Status__c from LAT_MasiveOwnerHeader__c limit 1];

        if(!header.isEmpty()){
            header.get(0).LAT_Status__c = 'Approval';

            update header;

            header.get(0).LAT_Status__c = 'Execution';

            update header;

        }

        Test.stopTest();

    }

    public static void createVisita(Account myAccount){

        //Cria nova Planajemnto...      
        Planejamento__c plan = new  Planejamento__c(); 
        plan.Name = 'Plan Jan 2018'; 
        plan.M_s_de_Ref_rencia__c = 'Janeiro';
        plan.Ano_de_Referencia__c = '2018';
        insert plan;

        Visitas__c visita = new Visitas__c(); 
        visita.Conta__c = myAccount.Id;
        visita.Data_da_Visita__c = System.today();
        visita.planejamento__c = Plan.Id;
        visita.Hora_da_Visita__c = '8:00';
        visita.Resumo_da_Visita__c = 'xxxx';
        insert visita;
        
    }

    public static void createContract(Account myAccount){

        LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
        Name = 'LAT_CONTRACT_CARTA_ACORDO_MAX_VALUE',
        LAT_Value__c = '10,11');
        insert cfg;
        

        LAT_Contract2__c con = new LAT_Contract2__c();
        con.TotalMoneyPerceivedValue__c = 1000.00;
        con.TotalMoneyPRBCost__c = 100.00;
        con.TotalProductsPerceivedValue__c = 10.00;
        con.TotalProductsPRBCost__c = 10.00;
        con.StartDate__c = Date.today().addDays(-105);
        con.EndDate__c = Date.today().addDays(105);
        con.Value__c = 100000.00;
        con.Account__c = myAccount.Id;
        con.RecordTypeId = Global_RecordTypeCache.getRtId('LAT_Contract2__c' + 'LAT_OnTrade_LetterAgreementCommercialCondition');
        insert con;

    }
}