/**
 *
 */
@isTest
public with sharing class LAT_BR_InactivateBtnControllerTest {

	 static testMethod void testMethodNoCadastrado() {
        Utils.setMigrationDoneTest(true);  
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Account acc = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        acc.Status__c = 'no cadastrado';
        acc.Reason_for_Inactivation__c = 'test';
        acc.Notes_1__c = 'test';
        insert acc;
        Test.startTest();
        Utils.setMigrationDoneTest(true);  

        LAT_BR_InactivateBtnController.validateAccInactivation(acc.Id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        List <Account> returnList = [SELECT Id, Rating FROM Account WHERE id = :acc.Id LIMIT 1];
        //System.assertEquals('Cliente inativo', returnList[0].Rating);

        Test.stopTest();
    }

    static testMethod void testMethodcadastradoAllFilled() {
        Utils.setMigrationDoneTest(true);  
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Account acc = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        acc.Status__c = 'Cliente cadastrado no CRM';
        acc.Reason_for_Inactivation__c =  '123';
        acc.Notes_1__c = 'test';
        insert acc;
        Test.startTest();
        Utils.setMigrationDoneTest(true);  

        LAT_BR_InactivateBtnController.validateAccInactivation(acc.Id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        List <Account> returnList = [SELECT Id, Rating FROM Account WHERE id = :acc.Id LIMIT 1];
        //System.assertEquals('Cliente inativo', returnList[0].Rating);

        Test.stopTest();
    }

    static testMethod void testMethodcadastradoJDEAllFilled() {
        Utils.setMigrationDoneTest(true);  
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Account acc = LAT_Account_TestFactory.getAccountOffTradeBraComplete();
        acc.Status__c = 'Cliente cadastrado no JDE';
        acc.Reason_for_Inactivation__c =  '123';
        acc.Notes_1__c = 'test';
        insert acc;
        Test.startTest();
        Utils.setMigrationDoneTest(true);  

        LAT_BR_InactivateBtnController.validateAccInactivation(acc.Id);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        
        List <Account> returnList = [SELECT Id, Rating FROM Account WHERE id = :acc.Id LIMIT 1];
        //System.assertEquals('Cliente inativo', returnList[0].Rating);

        Test.stopTest();
    }
}