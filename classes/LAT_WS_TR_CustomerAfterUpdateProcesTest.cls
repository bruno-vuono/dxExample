@isTest
public with sharing class LAT_WS_TR_CustomerAfterUpdateProcesTest {
  static testMethod void test1() {
    Test.startTest();
      Account acc =  LAT_Account_TestFactory.getAccountOffTradeBraComplete();
      acc.Status__c = 'Account to Review in JDE';
      acc.Client_code_AN8__c = null;
      insert acc;
      List <Account> accList = new List <Account>();
      accList.add(acc);
      LAT_WS_TR_CustomerAfterUpdateProcesses.submitCustomerForApprovalAR(accList);
      LAT_WS_TR_CustomerAfterUpdateProcesses.updateCustomerStatusToRegisteredBR(accList);//

    Test.stopTest();  
  }

  static testMethod void test2() {
    Test.startTest();
      Account acc =  LAT_Account_TestFactory.getAccountOffTradeBraComplete();
      User vendas = [SELECT Id FROM user WHERE Profile.Name = 'Vendas' AND isActive = true limit 1];
      acc.OwnerId = vendas.Id;
      acc.Status__c = 'Account to Review in JDE';
      
      acc.Is_Interface_Process_AR__c = true;
      insert acc;

      Account acc2 = [SELECT Id, Name, Client_code_AN8__c FROM Account WHERE Id = :acc.Id];
      acc2.Client_code_AN8__c = null;
      List <Account> accList = new List <Account>();
      Map <Id, Account> accMap = new Map <Id, Account>();
      accList.add(acc);
      accMap.put(acc.Id, acc2);
      LAT_WS_TR_CustomerAfterUpdateProcesses.sendCustomerEmailMX(accList, accMap);

    Test.stopTest();  
  }

  static testMethod void test2B() {
     
    
      Test.startTest();  
      Account acc =  LAT_Account_TestFactory.getAccountOffTradeBraComplete();
      User vendas = [SELECT Id FROM user WHERE (Profile.Name = 'LAT_BR2_Vendas' OR Profile.Name = 'System Administrator') AND isActive = true limit 1];
      acc.OwnerId = vendas.Id;
      acc.Status__c = 'Account to Review in JDE';
      
      acc.Is_Interface_Process_AR__c = true;
      
          insert acc;
      
          Account acc2 = [SELECT Id, Name, Client_code_AN8__c FROM Account WHERE Id = :acc.Id];
          acc2.Client_code_AN8__c = null;
          List <Account> accList = new List <Account>();
          Map <Id, Account> accMap = new Map <Id, Account>();
          accList.add(acc);
          accMap.put(acc.Id, acc2);
          LAT_WS_TR_CustomerAfterUpdateProcesses.sendCustomerEmailMX(accList, accMap);
      
    Test.stopTest();  
  }
}