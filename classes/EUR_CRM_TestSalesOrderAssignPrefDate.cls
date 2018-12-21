/*

    Test class for EUR_CRM_SalesOrderAssignPreferredDate

*/
@isTest
public class EUR_CRM_TestSalesOrderAssignPrefDate {
    
    public static User eurSysUser1;
    public static User eurSysUser2;

    // Create Users
    public static void userSetup(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='EUR ZA Standard On Trade User']; 
        UserRole r = [select id from UserRole where Developername ='EMEA'];
        eurSysUser1 = new User(Alias = 'pref1', Email='EUR_CRM_TestSalesOrderAssignPrefDate@test.com', userroleid=r.id,
        EmailEncodingKey='UTF-8', LastName='TestSalesOrderAssignPrefDatelastName', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='TestSalesOrderAssignPrefDate@test.com');
        insert eurSysUser1;

        p = [SELECT Id FROM Profile WHERE Name ='EUR System Admin']; 
        eurSysUser2 = new User(Alias = 'pref2', Email='EUR_CRM_TestSalesOrderAssignPrefDateAdmin@test.com', userroleid=r.id,
        EmailEncodingKey='UTF-8', LastName='TestSalesOrderAssignPrefDatelastName2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='TestSalesOrderAssignPrefDateAdmin@test.com');
        insert eurSysUser2;
    }

    static testMethod void testExecuteAction(){
        userSetup();
        // Create config data
        System.runAs(eurSysUser2){
            EUR_CRM_Apex_Configuration__c configApex = new EUR_CRM_Apex_Configuration__c();
            configApex.EUR_CRM_Module__c = 'EUR_CRM_Running_Number';
            configApex.EUR_CRM_Prefix__c = 'ZA-SO-';
            configApex.EUR_CRM_Running_Number_Length__c = 10;
            configApex.EUR_CRM_Running_Number__c = 0;
            configApex.EUR_CRM_Country_Code__c = 'ZA';
            insert configApex;      
        }

        System.runAs(eurSysUser1){
            Test.startTest();
                // Create Accounts
                EUR_CRM_Account__c acc1 = new EUR_CRM_Account__c(
                    Name = 'EUR_CRM_TestSalesOrderAssignPrefDate acc 1',
                    EUR_CRM_Preferred_delivery_day__c = 'Monday'
                );
                insert acc1;
    
                // Create Sales Order
                EUR_CRM_Sales_Order__c so = new EUR_CRM_Sales_Order__c(
                    Name = 'EUR_CRM_TestSalesOrderAssignPrefDate SO 1',
                    EUR_CRM_Account__c = acc1.Id,
                    Recordtype = Global_RecordTypeCache.getRtRec('EUR_CRM_Sales_Order__cEUR_ZA_Free_Goods_Order') // ZA RecordType
                );
                insert so;

                EUR_CRM_Sales_Order__c updatedSo = [SELECT Id, EUR_CRM_Preferred_Delivery_Day__c FROM EUR_CRM_Sales_Order__c WHERE Id =: so.Id];
                //System.assertEquals('Monday', updatedSo.EUR_CRM_Preferred_Delivery_Day__c);
            Test.stopTest();
        }
    }
}