/*********************************************************************************
 * Name: EUR_CRM_RU_UpdateAccountManagerTest
 * Description: Automatically update the field 'Manager of the Account Owner' in Account 
 				when the field 'Manager' is updated in User profile
 *
 * Version History
 * Date			Developer	Comments
 * ----------	----------	-------------------------------------------------------
 *	18-1-2017	Kevin Choi		Create the test class
 *  25-7-2017	Kevin Choi		Renamed to generic: EUR_CRM_UpdateAccountMgrHandlrTest
 *  12-Oct-2017 Jay Chau		Update user name in test setup
*********************************************************************************/
@isTest
public class EUR_CRM_UpdateAccountMgrHandlrTest {

	@testSetup static void setupUser(){

		User u = EUR_CRM_RU_TestClassHelper.createUser('EUR RU Affiliate Admin', 'EUR_RU_SR_ON_South_Krasnodar','user@laputaTest.com','user@laputaTest.com','Test');
		User m = EUR_CRM_RU_TestClassHelper.createUser('EUR RU Affiliate Admin', 'EUR_RU_SR_ON_South_Krasnodar','manager@laputaTest.com','manager@laputaTest.com','Test');
		User n = EUR_CRM_RU_TestClassHelper.createUser('EUR RU Affiliate Admin', 'EUR_RU_SR_ON_South_Krasnodar','director@laputaTest.com','director@laputaTest.com','Test');
		EUR_CRM_Account__c acct = EUR_CRM_RU_TestClassHelper.createEUAccount('Test Update 502','EUR RU On Trade');

		acct.OwnerId = u.Id;
//		acct.EUR_CRM_Manager_of_Account_Owner__c = m.Id;
//		u.ManagerId = m.Id;
//
//		update u;

		system.runAs(u){
			EUR_CRM_Apex_Configuration__c apexConfig = new EUR_CRM_Apex_Configuration__c();
			apexConfig = EUR_CRM_RU_TestClassHelper.createApexConfig();
			insert apexConfig;
			insert acct;
		}
	}

	@IsTest
	static void testexecution1() {
		user originUser = [select id,ManagerId, Email from user where Email = 'user@laputaTest.com' limit 1];
		user managerToUpdate = [select id, Email from user where Email = 'director@laputaTest.com' limit 1];
		Id newRole = [SELECT Id FROM UserRole WHERE DeveloperName='EUR_RU_STM_OFF_Russia' LIMIT 1].get(0).Id;

		originUser.ManagerId = managerToUpdate.Id;
		originUser.UserRoleId = newRole;

		Test.startTest();
		update originUser;
		Test.stopTest();
//        System.assertEquals(1,[SELECT Id FROM EUR_CRM_Account__c WHERE Name='Test Update 502' AND EUR_CRM_Manager_of_Account_Owner__c=:managerToUpdate.Id].size());
	}

	@IsTest
	static void testexecution2() {
		user originUser = [select id,ManagerId, Email from user where Email = 'user@laputaTest.com' limit 1];
		user managerToUpdate = [select id, Email from user where Email = 'director@laputaTest.com' limit 1];
		List<EUR_CRM_Account__c> testAccounts = [SELECT Id FROM EUR_CRM_Account__c WHERE Name='Test Update 502' LIMIT 1];

		testAccounts[0].EUR_CRM_Manager_of_Account_Owner__c = managerToUpdate.Id;

		Test.startTest();
		EUR_CRM_UpdateAccountMgrHandlr.createBatch(testAccounts);
		Test.stopTest();
//        System.assertEquals(1,[SELECT Id FROM EUR_CRM_Account__c WHERE Name='Test Update 502' AND EUR_CRM_Manager_of_Account_Owner__c=:managerToUpdate.Id].size());
	}

}