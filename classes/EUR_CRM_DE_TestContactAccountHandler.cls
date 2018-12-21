/*
  @Company:     IP-Converge Data Services, Inc.
  @Description: Test Class for EUR_CRM_DE_ContactAccountHandler  Class.
  @Author:      IPC
  @History:     Mar 25 2015- Created
*/

@isTest
public class EUR_CRM_DE_TestContactAccountHandler{
    static testmethod void test(){
    
        EUR_CRM_DE_TestClassUtilityHelper.initOffTradeUsers();
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.offTradeNationalManager){
            EUR_CRM_DE_TestClassUtilityHelper.initOffTradeDataSet();    
             
            EUR_CRM_Account__c euAccount = EUR_CRM_DE_TestClassUtilityHelper.offTradeAccount1;
            Contact c = new Contact(  FirstName = 'test', LastName = 'test', EUR_CRM_Account__c = euAccount.id);
            insert c;
            euAccount.ownerid = UserInfo.getUserId();
            
            test.StartTest(); 
            update euAccount;
            test.StopTest();
        }
    }
}