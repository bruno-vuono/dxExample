/******************************************************************************************
*   Company:Valuenet    Developers:Elena Schwarzböck-Tomás Etchegaray  Date:21/03/2013    *
*******************************************************************************************/
/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 09/11/2016
*
********************************************************************************/


@istest
public with sharing class AP01_Account_BR_TEST {

   static testMethod void unitTest() {

        system.Test.startTest();            
        Utils.setMigrationDoneTest(false);
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testudc@yahoo.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testudc@yahoo.com');

           system.runas(u){
               Account acc = new Account(
                RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'), 
                CNPJ__c = '58815921000192',
                Name = 'testAccount',
                Overdue__c = false,
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
                Billing_Country__c ='test',
                Status__c = 'Em análise - Crédito e Cobrança'
            );
            
            //insert acc;
            insert acc;//}catch(Exception e){}
            
            acc.overdue__c = true;
            acc.Client_code_AN8__c = '0';
            acc.Status__c = 'Em aprovação - Financeiro';
            
            //update acc;
            //update acc;//}catch(Exception e){}
       }
                                             
        
        
        system.Test.stopTest();                
        
    }
    
    static testMethod void unitTest2() {
   
        system.Test.startTest(); 
      
        Account acc2 = new Account(
            CNPJ__c = '92157751000134',
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'On_Trade'),
            Name = 'testAccount2',
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
        
        insert acc2;//}catch(Exception e){}
        
        system.Test.stopTest();
        
    }

    static testMethod void unitTest2C() {
   
        system.Test.startTest(); 
      
        Account acc2 = new Account(
            CNPJ__c = '66328430000145',
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Eventos'),
            Name = 'testAccount2',
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
        
        insert acc2;//}catch(Exception e){}

        Map<Id,Account> mapIdAccount = new Map<Id,Account>();
        mapIdAccount.put(acc2.Id, acc2);
        List<Account> accts = new List<Account>();
        accts.add(acc2);

        AP01_Account_BR.RegionalUpdate(accts, mapIdAccount);


        AP01_Account_BR.coverage();
        
        system.Test.stopTest();
        
    }
   static testMethod void unitTestB() {
            
        Utils.setMigrationDoneTest(true);
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testudc@yahoo.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testudc@yahoo.com');

           system.runas(u){
                                             
            Account acc = new Account(
                RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'), 
                CNPJ__c = '91370573000162',
                Name = 'testAccount',
                Overdue__c = false,
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
                Billing_Country__c ='test',
                Status__c = 'Em análise - Crédito e Cobrança'
            );
            
            //insert acc;
            insert acc;//}catch(Exception e){}
                
            system.Test.startTest();            
            Utils.setMigrationDoneTest(true);
            
            acc.overdue__c = true;
            acc.Client_code_AN8__c = '0';
            acc.Status__c = 'Em aprovação - Financeiro';
            
            //update acc;
            //update acc;//}catch(Exception e){}
        }
        system.Test.stopTest();                
        
    }

     static testMethod void unitTestC() {
            
        Utils.setMigrationDoneTest(true);
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testudc@yahoo.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testudc@yahoo.com');

           system.runas(u){

        Account acc = new Account(
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Eventos'), 
            CNPJ__c = '48665312000140',
            Name = 'testAccount',
            Overdue__c = false,
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
            Billing_Country__c ='test',
            Status__c = 'Em análise - Crédito e Cobrança'
        );
        
        //insert acc;
        insert acc;//}catch(Exception e){}
            
        system.Test.startTest();            
        Utils.setMigrationDoneTest(true);
        
        acc.overdue__c = true;
        acc.Client_code_AN8__c = '0';
        acc.Status__c = 'Em aprovação - Financeiro';
        
        //update acc;
       // update acc;//}catch(Exception e){}

    }
        
        system.Test.stopTest();                
        
    }
    
    static testMethod void unitTest2B() {
   
        system.Test.startTest(); 
        Utils.setMigrationDoneTest(true);     
        
     
        
        Account acc2 = new Account(
            CNPJ__c = '77637903000102',
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'On_Trade'),
            Name = 'testAccount2',
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
        
        insert acc2;//}catch(Exception e){}
        
        system.Test.stopTest();
        
    }

    static testMethod void unitTest4() {
        User usuario = new User();
        usuario.FirstName = 'nome';
        usuario.LastName = 'Sobrenome';
        usuario.Alias = 'NSobreU';
        usuario.Email = 'usuarioC@sobrenome.com';
        usuario.Username = 'devtestusercloud2b2@cloud2b.com.br';
        usuario.CommunityNickname = '1234jjuuu';
        usuario.EmailEncodingKey = 'ISO-8859-1';
        usuario.TimeZoneSidKey = 'GMT';
        usuario.LocaleSidKey = 'en_Us';
        usuario.LanguageLocaleKey = 'en_Us';
        usuario.C_digo_JDE__c = '235';
        usuario.ProfileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_BR2_Vendas');
        usuario.Country = 'BR';
        insert usuario;

        system.Test.startTest(); 
        Utils.setMigrationDoneTest(true);     
        
     
        
        Account acc2 = new Account(
            CNPJ__c = '77637903000102',
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'On_Trade'),
            Name = 'testAccount2',
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
            Billing_Country__c ='test',
            OwnerId = usuario.Id
        );       
        
        insert acc2;
        Titulos__c titulo = new Titulos__c(
            RecordTypeId = Global_RecordTypeCache.getRtId('Titulos__c' + 'BRA_Standard'),
            NetSRReceipts_AR__c = 200,
            Internal_id_pk__c = 'TEST',
            Cliente__c = acc2.id,
            codigoCia__c = 'TEST',
            dataEmissao__c = date.today(),
            dataVencimentoAtual__c = date.today(),
            dataVencimentoOriginal__c = date.today(),
            numeroDocumento__c = 1,
            parcela__c = 'T',
            valorOriginalTitulo__c = 10,
            valorSaldo__c = 10
        );
        insert titulo;
        Map<Id, Account> mapa = new Map<Id, Account> ();
        List<Account> lista = new List<Account>();
        lista.add(acc2);
        mapa.put(acc2.Id, acc2);
        AP01_Account_BR.ContaCriaDemanda(lista, mapa );
        AP01_Account_BR.Conta_valida_Inscricao_Estadual(lista, mapa );
        AP01_Account_BR.ContaAutomatizaEnvioAprovacao(lista, mapa );
        
        system.Test.stopTest();
        
    }

    static testMethod void unitTest5() {
        User usuario = new User();
        usuario.FirstName = 'nome';
        usuario.LastName = 'Sobrenome';
        usuario.Alias = 'NSobreU';
        usuario.Email = 'usuarioC@sobrenome.com';
        usuario.Username = 'devtestusercloud2b2@cloud2b.com.br';
        usuario.CommunityNickname = '1234jjuuu';
        usuario.EmailEncodingKey = 'ISO-8859-1';
        usuario.TimeZoneSidKey = 'GMT';
        usuario.LocaleSidKey = 'en_Us';
        usuario.LanguageLocaleKey = 'en_Us';
        usuario.C_digo_JDE__c = '235';
        usuario.ProfileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_BR2_Vendas');
        usuario.Country = 'BR';
        insert usuario; 
        
        system.Test.startTest(); 
        Utils.setMigrationDoneTest(true);     
        
     
        
        Account acc2 = new Account(
            CNPJ__c = '77637903000102',
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Eventos'),
            Name = 'testAccount2',
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
            Billing_Country__c ='test',
            OwnerId = usuario.Id
        );       
        
        insert acc2;
        Titulos__c titulo = new Titulos__c(
            RecordTypeId = Global_RecordTypeCache.getRtId('Titulos__c' + 'BRA_Standard'),
            NetSRReceipts_AR__c = 200,
            Internal_id_pk__c = 'TEST',
            Cliente__c = acc2.id,
            codigoCia__c = 'TEST',
            dataEmissao__c = date.today(),
            dataVencimentoAtual__c = date.today(),
            dataVencimentoOriginal__c = date.today(),
            numeroDocumento__c = 1,
            parcela__c = 'T',
            valorOriginalTitulo__c = 10,
            valorSaldo__c = 10
        );
        insert titulo;
        Map<Id, Account> mapa = new Map<Id, Account> ();
        List<Account> lista = new List<Account>();
        lista.add(acc2);
        mapa.put(acc2.Id, acc2);
        AP01_Account_BR.ContaCriaDemanda(lista, mapa );
        AP01_Account_BR.Conta_valida_Inscricao_Estadual(lista, mapa );
        AP01_Account_BR.ContaAutomatizaEnvioAprovacao(lista, mapa );
        
        system.Test.stopTest();
        
    }
    
}