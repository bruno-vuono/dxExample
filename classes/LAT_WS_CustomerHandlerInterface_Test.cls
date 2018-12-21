@isTest
private class LAT_WS_CustomerHandlerInterface_Test {
      
      @isTest static void customerHandlerInterfaceTest () {
            //Declaração de variáveis.
      Account acc, acc2                  = null;
      UDC__c regional, bandeira, cidade    = null;
      Profile perfil                     = null;
      User usuario                       = null;
      List <RecordType> listRecType      = null;
      List <String> developerName        = null;
      Map <String, String> mapRecType    = null;
      String idAccount                   = null;
      
      //Load RecordTypes
      idAccount = RecordTypeForTest.getRecType('Account','On_Trade');
      
      //Load Profile
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        
            insert usuario;
                  //Creates UDC
                  regional                  = new UDC__c();//
                  regional.CodDefUsuario__c = '4546';
                  regional.CodProd__c       = '01';
                  regional.CodUs__c         = '01';
                  regional.Internal_Id__c   = '1234';
                  regional.RecordTypeId     = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');
            insert regional;
      
      //Creates UDC
                  bandeira                  = new UDC__c();
                  bandeira.CodDefUsuario__c = '179';
                  bandeira.CodProd__c       = '01';
                  bandeira.CodUs__c         = '06';
                  bandeira.Internal_Id__c   = '1236';
                  bandeira.RecordTypeId     = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');
                  insert bandeira;
    
      //Create Account to Update
                  Account braOnTrade               = LAT_Account_TestFactory.getAccountOnTradeBraComplete();
                  braOnTrade.OwnerId               = usuario.Id;
                  //braOnTrade.Regional__c           = regional.Id;
                  //braOnTrade.Customer_Flag__c      = bandeira.Id;
                  braOnTrade.Revenue_UF__c         = 'SP';
                  braOnTrade.State_registration__c = '110.042.490.114';
                  insert braOnTrade;
                  braOnTrade.State_registration__c = '110.042.490.115';
                  update braOnTrade;

                  Account argOnTrade               = LAT_Account_TestFactory.getAccountOnTradeArgComplete();
                  argOnTrade.OwnerId               = usuario.Id;
                  argOnTrade.Regional__c           = regional.Id;
                  argOnTrade.Customer_Flag__c      = bandeira.Id;
                  argOnTrade.Revenue_UF__c         = 'SP';
                  argOnTrade.State_registration__c = '110.042.490.114';
      //try {insert argOnTrade;} catch (Exception e){}

      //Account a = [SELECT Id FROM Account WHERE RecordTypeId IN :]
      
      
      
      Test.startTest();
      LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDE(braOnTrade.Id);
            LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDE(argOnTrade.Id);
            LAT_WS_CustomerHandlerInterface.getAccounts(new List<String>{braOnTrade.id});
            LAT_WS_CustomerHandlerInterface.updateCustomerStatus(new List<String>{braOnTrade.id});
            
      Test.stopTest();
      }

      
      @isTest static void customerHandlerInterfaceTest2 () {
            //Declaração de variáveis.
      Account acc, acc2                  = null;
      UDC__c regional, bandeira, cidade    = null;
      Profile perfil                     = null;
      User usuario                       = null;
      List <RecordType> listRecType      = null;
      List <String> developerName        = null;
      Map <String, String> mapRecType    = null;
      String idAccount                   = null;
      
      //Load RecordTypes
      idAccount = RecordTypeForTest.getRecType('Account','ACC_1_OffTrade_ARG');
      
      //Load Profile
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        
            insert usuario;
                  //Creates UDC
                  regional                  = new UDC__c();//
                  regional.CodDefUsuario__c = '4546';
                  regional.CodProd__c       = '01';
                  regional.CodUs__c         = '01';
                  regional.Internal_Id__c   = '1234';
                  regional.RecordTypeId     = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');
            insert regional;
      
      //Creates UDC
                  bandeira                  = new UDC__c();
                  bandeira.CodDefUsuario__c = '179';
                  bandeira.CodProd__c       = '01';
                  bandeira.CodUs__c         = '06';
                  bandeira.Internal_Id__c   = '1236';
                  bandeira.RecordTypeId     = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');
                  insert bandeira;
    
      //Create Account to Update
                  Account argOnTrade               = LAT_Account_TestFactory.getAccountOffTradeArgComplete();
                  argOnTrade.OwnerId               = usuario.Id;
                  //braOnTrade.Regional__c           = regional.Id;
                  //braOnTrade.Customer_Flag__c      = bandeira.Id;
                  //argOnTrade.Revenue_UF__c         = 'SP';
                  argOnTrade.State_registration__c = '110.042.490.114';
                  insert argOnTrade;
                  argOnTrade.State_registration__c = '110.042.490.115';
                  update argOnTrade;

                  
      //try {insert argOnTrade;} catch (Exception e){}

      //Account a = [SELECT Id FROM Account WHERE RecordTypeId IN :]
      
      
      
      Test.startTest();
      LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDE(argOnTrade.Id);
            //LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDE(argOnTrade.Id);
            LAT_WS_CustomerHandlerInterface.getAccounts(new List<String>{argOnTrade.id});
            LAT_WS_CustomerHandlerInterface.updateCustomerStatus(new List<String>{argOnTrade.id});
            
      Test.stopTest();
      }
      
      @isTest static void customerHandlerInterfaceTest3 () {
            //Declaração de variáveis.
      Account acc, acc2                  = null;
      UDC__c regional, bandeira, cidade    = null;
      Profile perfil                     = null;
      User usuario                       = null;
      List <RecordType> listRecType      = null;
      List <String> developerName        = null;
      Map <String, String> mapRecType    = null;
      String idAccount                   = null;
      
      //Load RecordTypes
      idAccount = RecordTypeForTest.getRecType('Account','ACC_1_OffTrade_ARG');
      
      //Load Profile
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        
            insert usuario;
                  //Creates UDC
                  regional                  = new UDC__c();//
                  regional.CodDefUsuario__c = '4546';
                  regional.CodProd__c       = '01';
                  regional.CodUs__c         = '01';
                  regional.Internal_Id__c   = '1234';
                  regional.RecordTypeId     = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');
            insert regional;
      
      //Creates UDC
                  bandeira                  = new UDC__c();
                  bandeira.CodDefUsuario__c = '179';
                  bandeira.CodProd__c       = '01';
                  bandeira.CodUs__c         = '06';
                  bandeira.Internal_Id__c   = '1236';
                  bandeira.RecordTypeId     = RecordTypeForTest.getRecType('UDC__c', 'BRA_Standard');
                  insert bandeira;
    
      //Create Account to Update
        String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        
        Account accMx = new Account(
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
            Status__c = 'Cliente cadastrado no JDE',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX
        );
                  accMx.State_registration__c = '110.042.490.114';
                  insert accMx;
                  accMx.State_registration__c = '110.042.490.115';
            Test.startTest(); 
        update accMx;

                  
      //try {insert argOnTrade;} catch (Exception e){}

      //Account a = [SELECT Id FROM Account WHERE RecordTypeId IN :]
      
      
      
      
      LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDE(accMx.Id);
            //LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDE(argOnTrade.Id);
            LAT_WS_CustomerHandlerInterface.getAccounts(new List<String>{accMx.id});
            LAT_WS_CustomerHandlerInterface.updateCustomerStatus(new List<String>{accMx.id});
            
      Test.stopTest();
      }
}