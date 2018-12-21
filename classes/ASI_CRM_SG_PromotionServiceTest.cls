/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_PromotionServiceTest
 * Description: Test class for ASI_CRM_SG_PromotionService
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-31       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_SG_PromotionServiceTest {
    @IsTest static void rollupActualToPromotionTest() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();

        ASI_CRM_Promotion_Plan__c promotionPlan = new ASI_CRM_Promotion_Plan__c(
            Name = 'testPromotionPlan',
            ASI_CRM_Start_Date__c = Date.today().toStartOfMonth(),
            ASI_CRM_End_Date__c = Date.today().addMonths(1).toStartOfMonth().addDays(-1),
            ASI_CRM_Enrollment_Cut_off_Date__c = Date.today().addDays(15),
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan')
        );
        insert promotionPlan;


        ASI_HK_CRM_Promotion__c promotion = new ASI_HK_CRM_Promotion__c(
            Name = 'testPromotionPlan',
            ASI_CRM_Promotion_Plan__c = promotionPlan.Id,
            ASI_HK_CRM_Status__c = 'Final Approved',
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion')
        );
        insert promotion;

        ASI_CRM_SG_PromotionService.getInstance().rollupActualToPromotion(new List<ASI_HK_CRM_Promotion__c>{promotion});
    }
}