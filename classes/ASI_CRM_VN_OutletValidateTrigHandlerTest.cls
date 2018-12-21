/***************************************************************************************************************************
 * Name:        ASI_CRM_VN_OutletValidateTrigHandlerTest
 * Description: Test class for ASI_CRM_VN_OutletValidateTriggerHandler
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-01-31       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_VN_OutletValidateTrigHandlerTest {
    @IsTest static void testBehavior() {
        ASI_CRM_VN_TestClassHelper.createRunningNumber();
        ASI_CRM_VN_TestClassHelper.createExchangeRate();

        String profileId = [SELECT Id FROM Profile WHERE Name = 'ASI VN Standard User'].Id;

        User user = ASI_CRM_VN_TestClassHelper.createUser(profileId);
        insert user;

        ASI_CRM_ServicePack__c servicePack = ASI_CRM_VN_TestClassHelper.createServicePack();
        insert servicePack;

        ASI_CRM_AccountsAdditionalField__c customer = ASI_CRM_VN_TestClassHelper.createOnTradeCustomer();
        customer.OwnerId = user.Id;
        customer.ASI_CRM_Service_Pack__c = servicePack.Id;
        insert customer;

        customer.ASI_CRM_Special_Outlet__c = true;
        try {
            update customer;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Please upload the attachment'));
        }
    }
}