/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 21/11/2016
*
********************************************************************************/
@isTest
public class LAT_BR_AP01_Case_TEST {
    
    @isTest(SeeAllData=true)
    static void unitTest(){
        Utils.setMigrationDoneTest(false);
        String recordType = Global_RecordTypeCache.getRtId('Case' + 'Alteracao_cadastro_de_clientes');
        Id controladoriaId = [SELECT Id FROM Group WHERE Name='Controladoria' AND Type='Queue'].Id;
        
        Utils.setMigrationDoneTest(false);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        Case caseCustom = new Case(RecordTypeId = recordType, type = 'Alteração - Cadastro de cliente', Status = 'Reprovado', AccountId = acc.id);
        test.StartTest();
        insert caseCustom;
        //update caseCustom;
        
        test.stopTest();
    }

    //MIGRATED 21/11/2016 
    @isTest(SeeAllData=true)
    static void unitTestLATCase(){
        Utils.setMigrationDoneTest(true);
        String recordType = Global_RecordTypeCache.getRtId('LAT_Case__c' + 'Alteracao_cadastro_de_clientes');
        
        Utils.setMigrationDoneTest(true);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        LAT_Case__c caseCustom = new LAT_Case__c(RecordTypeId = recordType, LAT_Type__c= 'Alteração - Cadastro de cliente', LAT_Status__c = 'Reprovado', LAT_Account__c = acc.id);
        test.startTest();
        insert caseCustom;
        
        update caseCustom;
        
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    static void unitTest2(){
        Utils.setMigrationDoneTest(false);
        String recordType = Global_RecordTypeCache.getRtId('Case' + 'Alteracao_cadastro_de_clientes');
        Id controladoriaId = [SELECT Id FROM Group WHERE Name='Controladoria' AND Type='Queue'].Id;
        Utils.setMigrationDoneTest(false);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        Case caseCustom = new Case(RecordTypeId = recordType, 
            type = 'Outros', 
            Status = 'Reprovado', 
            AccountId = acc.id,
            OwnerId = controladoriaId);
        test.startTest();
        insert caseCustom;
        //update caseCustom;
        
        test.stopTest();
    }

        @isTest(SeeAllData=true)
    static void unitTest3(){
        Utils.setMigrationDoneTest(false);
        String recordType = Global_RecordTypeCache.getRtId('Case' + 'Alteracao_cadastro_de_clientes');
        Id controladoriaId = [SELECT Id FROM Group WHERE Name='Customer service' AND Type='Queue'].Id;
        
        Utils.setMigrationDoneTest(false);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        Case caseCustom = new Case(RecordTypeId = recordType, 
            type = 'Outros', 
            Status = 'Fechado e resolvido', 
            AccountId = acc.id,
            OwnerId = controladoriaId);
        test.startTest();
        insert caseCustom;
        //update caseCustom;
        
        test.stopTest();
    }

            @isTest(SeeAllData=true)
    static void unitTest2B(){
        Utils.setMigrationDoneTest(true);
        String recordType = Global_RecordTypeCache.getRtId('LAT_Case__c' + 'Alteracao_cadastro_de_clientes');
        Id controladoriaId = [SELECT Id FROM Group WHERE Name='Controladoria' AND Type='Queue'].Id;
        
        Utils.setMigrationDoneTest(true);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        LAT_Case__c caseCustom = new LAT_Case__c(RecordTypeId = recordType, 
            LAT_type__c = 'Outros', 
            LAT_Status__c = 'Reprovado', 
            LAT_Account__c = acc.id,
            OwnerId = controladoriaId);
        insert caseCustom;
        update caseCustom;
        
        Titulos__c titulo = new Titulos__c(
            NetSRReceipts_AR__c = 200,
            Internal_id_pk__c = 'TEST1',
            Cliente__c = acc.id,
            codigoCia__c = 'TEST',
            dataEmissao__c = date.today(),
            dataVencimentoAtual__c = date.today(),
            dataVencimentoOriginal__c = date.today(),
            numeroDocumento__c = 1,
            parcela__c = 'T',
            valorOriginalTitulo__c = 10,
            Status__c = false,
            valorSaldo__c = 10
        );

        test.StartTest();
        insert titulo;

        acc.Overdue__c = true;
        update acc;

        test.stopTest();
    }

        @isTest(SeeAllData=true)
    static void unitTest3B(){
        Utils.setMigrationDoneTest(true);
        String recordType = Global_RecordTypeCache.getRtId('LAT_Case__c' + 'Alteracao_cadastro_de_clientes');
        Id controladoriaId = [SELECT Id FROM Group WHERE Name='Customer service' AND Type='Queue'].Id;
        test.StartTest();
        Utils.setMigrationDoneTest(true);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Payer', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        LAT_Case__c caseCustom = new LAT_Case__c(RecordTypeId = recordType, 
            LAT_type__c = 'Outros', 
            LAT_Status__c = 'Fechado e resolvido', 
            LAT_Account__c = acc.id,
            OwnerId = controladoriaId);
        insert caseCustom;
        update caseCustom;
        
        test.stopTest();
    }

        //MIGRATED 21/11/2016 
    @isTest(SeeAllData=true)
    static void unitTestLATCase5(){
        Utils.setMigrationDoneTest(true);
        String recordType = Global_RecordTypeCache.getRtId('LAT_Case__c' + 'Alteracao_cadastro_de_clientes');
        
        Utils.setMigrationDoneTest(true);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Outros', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        LAT_Case__c caseCustom = new LAT_Case__c(RecordTypeId = recordType, LAT_Reason__c = 'Alt. tipo cliente', LAT_Type__c= 'Alteração - Cadastro de cliente', LAT_Status__c = 'Reprovado', LAT_Account__c = acc.id);
        test.startTest();
        insert caseCustom;
        caseCustom.LAT_Reason__c = 'Alt. tipo cliente';
        caseCustom.LAT_Status__c = 'Fechado e cancelado'; 
        update caseCustom;
        
        test.stopTest();
    }
    @isTest(SeeAllData=true)
    static void unitTest25(){
        Utils.setMigrationDoneTest(false);
        String recordType = Global_RecordTypeCache.getRtId('Case' + 'Alteracao_cadastro_de_clientes');
        Id controladoriaId = [SELECT Id FROM Group WHERE Name='Controladoria' AND Type='Queue'].Id;
        Utils.setMigrationDoneTest(false);
        Account acc = new Account(Name = 'TEST', AccountNumber = '1000', Status__c = 'Novo cadastro', Type = 'Outros', Phone = '11 1111-1111', Notes__c = 'TEST', AddressLine1_AR__c = 'TEST', CNPJ__c = '51987528000137', Corporate_Name__c = 'TEST', Channel__c = 'WS', RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'));
        insert acc;
        
        Case caseCustom = new Case(RecordTypeId = recordType, 
            type = 'Outros', 
            Status = 'Reprovado', 
            AccountId = acc.id,
            Reason = 'Alt. tipo cliente',
            OwnerId = controladoriaId);
        test.startTest();
        insert caseCustom;
        caseCustom.Status = 'Fechado e cancelado'; 
        update caseCustom;
        
        test.stopTest();
    }
}