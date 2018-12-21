/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_PromotionPlanEnrollCust_Test
 * Description: Test class for ASI_CRM_SG_PromotionPlanEnrollCust_Ctrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-18       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_SG_PromotionPlanEnrollCust_Test {
    @IsTest static void testBehavior() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
        ASI_CRM_SG_TestClassHelper.customerData customerC = new ASI_CRM_SG_TestClassHelper.customerData(true);
        ASI_CRM_SG_TestClassHelper.contractData contractC1 = new ASI_CRM_SG_TestClassHelper.contractData(true, customerC.customer, 'Yes');

        ASI_CRM_Promotion_Plan__c promotionPlan = new ASI_CRM_Promotion_Plan__c(
            Name = 'testPromotionPlan',
            ASI_CRM_Start_Date__c = Date.today().toStartOfMonth(),
            ASI_CRM_End_Date__c = Date.today().addMonths(1).toStartOfMonth().addDays(-1),
            ASI_CRM_Enrollment_Cut_off_Date__c = Date.today().addDays(15),
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan')
        );
        insert promotionPlan;

        ApexPages.currentPage().getParameters().put('id', promotionPlan.id);

        ApexPages.StandardController sc = new ApexPages.StandardController(promotionPlan);
        ASI_CRM_SG_PromotionPlanEnrollCust_Ctrl controller = new ASI_CRM_SG_PromotionPlanEnrollCust_Ctrl(sc);

    }
}