/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_VoucherSummaryTest
 * Description: Test class for ASI_CRM_SG_VoucherSummaryCtrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-18       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_SG_VoucherSummaryTest {
    @IsTest static void testBehavior() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
        ASI_CRM_SG_TestClassHelper.customerData customerC = new ASI_CRM_SG_TestClassHelper.customerData(true);
        ASI_CRM_SG_TestClassHelper.contractData contractC1 = new ASI_CRM_SG_TestClassHelper.contractData(true, customerC.customer, 'Yes');
        ASI_CRM_Voucher__c voucher = new ASI_CRM_Voucher__c();
        insert voucher;

        ApexPages.StandardController sc = new ApexPages.StandardController(voucher);
        ASI_CRM_SG_VoucherSummaryCtrl controller = new ASI_CRM_SG_VoucherSummaryCtrl(sc);

    }
}