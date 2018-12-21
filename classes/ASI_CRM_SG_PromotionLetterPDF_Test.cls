/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_PromotionLetterPDF_Test
 * Description: Test class for ASI_CRM_SG_PromotionLetterPDF_Ctrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-31       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_SG_PromotionLetterPDF_Test {
    @IsTest static void testBehavior() {
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
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion')
        );
        insert promotion;

        ASI_HK_CRM_Promotion_Detail__c promotionDetail = new ASI_HK_CRM_Promotion_Detail__c(
            ASI_HK_CRM_Promotion__c = promotion.Id,
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion_Detail__cASI_CRM_SG_Customer')
        );
        insert promotionDetail;

        ASI_CRM_SG_PromotionLetterPDF_Ctrl controller = new ASI_CRM_SG_PromotionLetterPDF_Ctrl();
        ASI_CRM_SG_TestClassHelper.customerData customerC = new ASI_CRM_SG_TestClassHelper.customerData(true);
        controller.customerId = customerC.customer.Id;
        controller.promotionId = promotion.Id;
        controller.init();
        
        ApexPages.currentPage().getParameters().put('promotionId', promotion.Id);
        ApexPages.currentPage().getParameters().put('customerId', customerC.customer.Id);
        ApexPages.currentPage().getParameters().put('contactName', 'a');
        ApexPages.currentPage().getParameters().put('contactDesignation', 'a');
        ApexPages.currentPage().getParameters().put('contactNumber', 'a');
        ASI_CRM_SG_PromotionLetter_Ctrl ctrl = new ASI_CRM_SG_PromotionLetter_Ctrl();
        
    }
}