@isTest 

public with sharing class LAT_MX_AP01_Visita_TEST {

    static testMethod void unitTest() {

        User u = new User();
        u = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX_Creditos y Cobranzas');
        insert u;
        User u2 = new User();
        u2 = LAT_TestUserAdmin.userWithAdminPorf ('Nome3','Sobrenome3','NSobre3','nome3@sobrenome.com','PriceCalculationInterface3@mail.com','133jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u2.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_Vendedor');
        u2.LAT_MX_PlansVisitsAutomatically__c = true;
        insert u2;
        test.startTest();
        
        System.runAs(u2){
                
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
            Segmentation_Type_on_trade__c = 'MOP',
            Frequency_of_Visits__c = 'Mensual',
            RecordTypeId = rtOffMX
        );
        insert acc;
        
        String rtpla = Global_RecordTypeCache.getRtId('Planejamento__c' + 'LAT_MX_PLV_NewPlanning');
        
        Planejamento__c pla = new Planejamento__c(
            RecordTypeId = rtpla,
            Name = 'test',
            Ano_de_Referencia__c = string.ValueOf(date.today().year()), 
            M_s_de_Ref_rencia__c = 'Dezembro'
        );
        insert pla;
    

        
            String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
            
            Visitas__c visit = new Visitas__c(
                Conta__c = acc.Id,
                Name = 'test',
                Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
                Hora_da_Visita__c = '08:00',
                Planejamento__c = pla.Id,
                Resumo_da_Visita__c = 'test',
                LAT_MX_ClienteChannel__c = 'Off Trade',
                LAT_MX_Type__c = 'Collections'        
            );
            insert visit;
       
        
        //String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
            
        Visitas__c visit2 = new Visitas__c(
            Conta__c = acc.Id,
            Name = 'test',
            Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
            Hora_da_Visita__c = '08:00',
            Planejamento__c = pla.Id,
            Resumo_da_Visita__c = 'test',
            LAT_MX_ClienteChannel__c = 'Off Trade',
            LAT_MX_Type__c = 'Collections'        
        );
        insert visit2;
         }
        
        test.stopTest();  

        
    }

    static testMethod void unitTest2() {

        User u = new User();
        u = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX_Creditos y Cobranzas');
        insert u;
        User u2 = new User();
        u2 = LAT_TestUserAdmin.userWithAdminPorf ('Nome3','Sobrenome3','NSobre3','nome3@sobrenome.com','PriceCalculationInterface3@mail.com','133jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u2.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_Vendedor');
        u2.LAT_MX_PlansVisitsAutomatically__c = true;
        insert u2;
        test.startTest();
        Visitas__c visit;
        
        System.runAs(u){
                
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
                Segmentation_Type_on_trade__c = 'MOP',
                Frequency_of_Visits__c = 'Mensual',
                RecordTypeId = rtOffMX
            );
            insert acc;
            
            String rtpla = Global_RecordTypeCache.getRtId('Planejamento__c' + 'LAT_MX_PLV_NewPlanning');
            
            Planejamento__c pla = new Planejamento__c(
                RecordTypeId = rtpla,
                Name = 'test',
                Ano_de_Referencia__c = string.ValueOf(date.today().year()), 
                M_s_de_Ref_rencia__c = 'Dezembro'
            );
            insert pla;
        

            
            String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
            
            visit = new Visitas__c(
                Conta__c = acc.Id,
                Name = 'test',
                Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
                Hora_da_Visita__c = '08:00',
                Planejamento__c = pla.Id,
                Resumo_da_Visita__c = 'test',
                LAT_MX_ClienteChannel__c = 'Off Trade',
                LAT_MX_Type__c = 'Collections'        
            );
            insert visit;
         


           
            
            //String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
                
            Visitas__c visit2 = new Visitas__c(
                Conta__c = acc.Id,
                Name = 'test',
                Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
                Hora_da_Visita__c = '08:00',
                Planejamento__c = pla.Id,
                Resumo_da_Visita__c = 'test',
                LAT_MX_ClienteChannel__c = 'Off Trade',
                LAT_MX_Type__c = 'Collections'        
            );
            insert visit2;
            List<Visitas__c> lista = new List<Visitas__c>();
            lista.add(visit);
            lista.add(visit2);
            LAT_MX_AP01_Visita.deleteValidation(lista);
        }
        visit.LAT_MX_Type__c = 'Collections;Follow Up - On Trade';
        update visit;
        test.stopTest();  

        
    }
    static testMethod void unitTestB() {

        Utils.setMigrationDoneTest(true);
        User u = new User();
        u = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_CreditosyCobranzas');
        insert u;
        User u2 = new User();
        u2 = LAT_TestUserAdmin.userWithAdminPorf ('Nome3','Sobrenome3','NSobre3','nome3@sobrenome.com','PriceCalculationInterface3@mail.com','133jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u2.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_Vendedor');
        u2.LAT_MX_PlansVisitsAutomatically__c = true;
        insert u2;
        
        test.startTest();

        Utils.setMigrationDoneTest(true);        
        System.runAs(u2){
                
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
            Segmentation_Type_on_trade__c = 'MOP',
            Frequency_of_Visits__c = 'Mensual',
            RecordTypeId = rtOffMX
        );
        insert acc;
        
        String rtpla = Global_RecordTypeCache.getRtId('Planejamento__c' + 'LAT_MX_PLV_NewPlanning');
        
        Planejamento__c pla = new Planejamento__c(
            RecordTypeId = rtpla,
            Name = 'test',
            Ano_de_Referencia__c = string.ValueOf(date.today().year()), 
            M_s_de_Ref_rencia__c = 'Dezembro'
        );
        insert pla;
    

        
            String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
            
            Visitas__c visit = new Visitas__c(
                Conta__c = acc.Id,
                Name = 'test',
                Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
                Hora_da_Visita__c = '08:00',
                Planejamento__c = pla.Id,
                Resumo_da_Visita__c = 'test',
                LAT_MX_ClienteChannel__c = 'Off Trade',
                LAT_MX_Type__c = 'Collections'        
            );
            insert visit;
       
        
        //String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
            
        Visitas__c visit2 = new Visitas__c(
            Conta__c = acc.Id,
            Name = 'test',
            Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
            Hora_da_Visita__c = '08:00',
            Planejamento__c = pla.Id,
            Resumo_da_Visita__c = 'test',
            LAT_MX_ClienteChannel__c = 'Off Trade',
            LAT_MX_Type__c = 'Collections'        
        );
        insert visit2;
         }
        
        test.stopTest();  

        
    }

    static testMethod void unitTest2B() {

        Utils.setMigrationDoneTest(true);
        User u = new User();
        u = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_CreditosyCobranzas');
        insert u;
        User u2 = new User();
        u2 = LAT_TestUserAdmin.userWithAdminPorf ('Nome3','Sobrenome3','NSobre3','nome3@sobrenome.com','PriceCalculationInterface3@mail.com','133jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        u2.profileId = LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_Vendedor');
        u2.LAT_MX_PlansVisitsAutomatically__c = true;
        insert u2;
        test.startTest();

        Utils.setMigrationDoneTest(true);
        Visitas__c visit;
        
        System.runAs(u){
                
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
                Segmentation_Type_on_trade__c = 'MOP',
                Frequency_of_Visits__c = 'Mensual',
                RecordTypeId = rtOffMX
            );
            insert acc;
            
            String rtpla = Global_RecordTypeCache.getRtId('Planejamento__c' + 'LAT_MX_PLV_NewPlanning');
            
            Planejamento__c pla = new Planejamento__c(
                RecordTypeId = rtpla,
                Name = 'test',
                Ano_de_Referencia__c = string.ValueOf(date.today().year()), 
                M_s_de_Ref_rencia__c = 'Dezembro'
            );
            insert pla;
        

            
            String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
            
            visit = new Visitas__c(
                Conta__c = acc.Id,
                Name = 'test',
                Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
                Hora_da_Visita__c = '08:00',
                Planejamento__c = pla.Id,
                Resumo_da_Visita__c = 'test',
                LAT_MX_ClienteChannel__c = 'Off Trade',
                LAT_MX_Type__c = 'Collections'        
            );
            insert visit;
         


           
            
            //String rtvis = Global_RecordTypeCache.getRtId('Visitas__c' + 'LAT_MX_VTS_PlannedVisit');
                
            Visitas__c visit2 = new Visitas__c(
                Conta__c = acc.Id,
                Name = 'test',
                Data_da_Visita__c = date.newInstance(date.today().year(),12,31),
                Hora_da_Visita__c = '08:00',
                Planejamento__c = pla.Id,
                Resumo_da_Visita__c = 'test',
                LAT_MX_ClienteChannel__c = 'Off Trade',
                LAT_MX_Type__c = 'Collections'        
            );
            insert visit2;
            List<Visitas__c> lista = new List<Visitas__c>();
            lista.add(visit);
            lista.add(visit2);
            LAT_MX_AP01_Visita.deleteValidation(lista);
        }
        visit.LAT_MX_Type__c = 'Collections;Follow Up - On Trade';
        update visit;
        test.stopTest();  

        
    }
}