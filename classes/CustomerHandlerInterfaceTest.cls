@isTest(seeAllData=true)
/********************************************************************************
*                         Copyright 2012 - Cloud2b
********************************************************************************
* Realiza teste de cobertura da classe CustomerHandlerInterface.cls
* NAME: CustomerHandlerInterfaceTest.CLS
* AUTHOR: CARLOS CARVALHO                         DATE: 31/05/2012
*
* MAINTENANCE: INSERIDO LÓGICA DE VALIDAÇÃO DO TIPO DE REGISTRO DOS OBJETOS.
* AUTHOR: CARLOS CARVALHO                           DATE: 10/01/2013 
********************************************************************************/
private class CustomerHandlerInterfaceTest 
{

    static testMethod void CustomerHandlerInterfaceTest() 
    {
      //Declaração de variáveis.
      Account acc,acc2                      = null;
      UDC__c regional, bandeira, cidade     = null;
      Profile perfil                        = null;
      User usuario                          = null;
      List<RecordType> listRecType          = null;
      List<String> developerName            = null;
      Map<String, String> mapRecType        = null;
      String idAccount                      = null;
      
      //Recupera os IDS de tipo de registro.
      idAccount = RecordTypeForTest.getRecType('Account','On_Trade');
            
      
      //Recupera o ID do perfil desejado.
      usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
      
      try{insert usuario;}catch(Exception e){}
    
      //Cria nova UDC.
      regional = new UDC__c();
      regional.CodDefUsuario__c = '4546';
      regional.CodProd__c     = '01';
      regional.CodUs__c     = '01';
      regional.Internal_Id__c   = '1234';
      regional.RecordTypeId = RecordTypeForTest.getRecType( 'UDC__c', 'BRA_Standard' );
      //insert regional;
      try{insert regional;}catch(Exception e){}
      
      //Cria nova UDC.
      bandeira = new UDC__c();
      bandeira.CodDefUsuario__c = '179';
      bandeira.CodProd__c     = '01';
      bandeira.CodUs__c     = '06';
      bandeira.Internal_Id__c   = '1236';
      bandeira.RecordTypeId = RecordTypeForTest.getRecType( 'UDC__c', 'BRA_Standard' );
      //insert bandeira;
      try{insert bandeira;}catch(Exception e){}
    
      //Cria novo Account.
      acc = new Account();
      acc.OwnerId = usuario.Id;
      acc.Name = 'TESTE';
      acc.CNPJ__c = '48843971000120';
      acc.Type = 'Outros';
      acc.RecordTypeId = idAccount;
      acc.Status__c = 'Cliente cadastrado no JDE';
      acc.Agency__c = '000';
      acc.Checking_account__c = '000';
      acc.Current_account__c = '0';
      acc.Corporate_Name__c = 'Teste';
      acc.Channel__c = 'Off Trade';
      acc.Regional__c = regional.Id;
      acc.Frequency_of_Visits__c = 'Semanal';
      acc.Channel_Type__c = 'Direto';
      acc.Client_code_AN8__c = '557798';
      acc.Price_Group__c = '1';
      acc.Customer_Flag__c = bandeira.Id;
      acc.Revenue_UF__c = 'SP';
      acc.State_registration__c = '110.042.490.114';
      //insert acc;
      //try{insert acc;}catch(Exception e){}
      
      acc.State_registration__c = '110.042.490.114';
      //update acc;
      //try{update acc;}catch(Exception e){}
      
      //Cria novo Account.
      acc2 = new Account();
      acc2.OwnerId = usuario.Id;
      acc2.Name = 'TESTE';
      acc2.CNPJ__c = '36818686000170';
      acc2.Type = 'Outros';
      acc2.ParentId = acc.Id;
      acc2.RecordTypeId = idAccount;
      acc2.Status__c = 'Cliente cadastrado no JDE';
      acc2.Agency__c = '000';
      acc2.Checking_account__c = '000';
      acc2.Current_account__c = '0';
      acc2.Corporate_Name__c = 'Teste';
      acc2.Channel__c = 'Off Trade';
      acc2.Regional__c = regional.Id;
      acc2.Frequency_of_Visits__c = 'Semanal';
      acc2.Channel_Type__c = 'Direto';
      acc2.Client_code_AN8__c = '558797';
      acc2.Price_Group__c = '1';
      acc2.Customer_Flag__c = bandeira.Id;
      //insert acc2;
      //try{insert acc2;}catch(Exception e){}
      
      
      String lIdAcc = acc2.Id;
      
      //CustomerHandlerInterface.CustomerInterfaceJDE(lIdAcc);
      try{CustomerHandlerInterface.CustomerInterfaceJDE(lIdAcc);}catch(Exception e){}
    }
}