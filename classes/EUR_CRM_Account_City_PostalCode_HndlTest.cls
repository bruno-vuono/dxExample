/*
    @Description: Test class for EUR_CRM_Account_City_PostalCode_Handler
 */
@IsTest
public with sharing class EUR_CRM_Account_City_PostalCode_HndlTest {
    private static User onTradeUser;
    private static final String POSTALCODE1 = '12345';
    private static final String POSTALCODE2 = '54321';
    private static final String CITYNAME1 = 'Test City1';
    private static final String CITYNAME2 = 'Test City2';

    @TestSetup
    static void dataSetUp(){
        Map<String, String> validRecordTypes = EUR_CRM_RecordTypeHelper.AccountCityPostalCodeMap_validRecordTypes;
        if (!validRecordTypes.isEmpty()) {
            EUR_CRM_Postal_Code_City_Mapping__c onTradeCityMapping1 = EUR_CRM_DE_TestClassUtilityHelper.createPostalCodeCityMaping(CITYNAME1,POSTALCODE1,CITYNAME1,validRecordTypes.values()[0]);
            EUR_CRM_Postal_Code_City_Mapping__c onTradeCityMapping2 = EUR_CRM_DE_TestClassUtilityHelper.createPostalCodeCityMaping(CITYNAME2,POSTALCODE2,CITYNAME2,validRecordTypes.values()[0]);
        }
    }

    static void setUpUsers() {
        onTradeUser = EUR_CRM_DE_TestClassUtilityHelper.createUser('System Administrator', 'EUR_DE_National_Sales_Manager_Off_Trade', 'testuser123902@test.com', 'testuser123902@test.com', 'test898441');
    }


    @IsTest
    static void testOnTrade() {
        setUpUsers();
        System.runAs(onTradeUser) {
            Test.startTest();

            EUR_CRM_Account__c onTradeEUAccount = EUR_CRM_DE_TestClassUtilityHelper.creaEUAccount('euAccount ', POSTALCODE1, 'DE ON Gastronomy', null);
            System.assertEquals(CITYNAME1,[SELECT EUR_CRM_City__c FROM EUR_CRM_Account__c WHERE Id=:onTradeEUAccount.Id][0].EUR_CRM_City__c);

            onTradeEUAccount.EUR_CRM_Postal_Code__c = POSTALCODE2;
            update onTradeEUAccount;
            System.assertEquals(CITYNAME2,[SELECT EUR_CRM_City__c FROM EUR_CRM_Account__c WHERE Id=:onTradeEUAccount.Id][0].EUR_CRM_City__c);

            Test.stopTest();
        }
    }
}