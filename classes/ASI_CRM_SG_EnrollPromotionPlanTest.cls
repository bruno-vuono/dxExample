/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_EnrollPromotionPlanTest
 * Description: Test class for ASI_CRM_SG_EnrollPromotionPlan
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-15       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_SG_EnrollPromotionPlanTest {
    @IsTest static void testBehavior() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
        List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();

        ASI_CRM_SG_TestClassHelper.customerData customerC1 = new ASI_CRM_SG_TestClassHelper.customerData(false, 'Customer1');
        customerC1.customer.RecordtypeId = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_SG_Outlet');
        ASI_CRM_SG_TestClassHelper.customerData customerC2 = new ASI_CRM_SG_TestClassHelper.customerData(false, 'Customer2');
        customerC1.customer.RecordtypeId = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_SG_Wholesaler');

        List<ASI_CRM_AccountsAdditionalField__c> customerList = new List<ASI_CRM_AccountsAdditionalField__c>();
        customerList.add(customerC1.customer);
        customerList.add(customerC2.customer);
        insert customerList;

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

        ApexPages.currentPage().getParameters().put('id', promotion.Id);
        ApexPages.currentPage().getParameters().put('customerName', 'Customer1');
        Set<Id> skuIds = new Map<Id, ASI_MFM_SKU_Code__c>([SELECT Id FROM ASI_MFM_SKU_Code__c]).keySet();
        ApexPages.currentPage().getParameters().put('skuIds', JSON.serialize(skuIds));
        Set<Id> subBrandIds = new Map<Id, ASI_MFM_Sub_brand__c>([SELECT Id FROM ASI_MFM_Sub_brand__c]).keySet();
        ApexPages.currentPage().getParameters().put('subBrandIds', JSON.serialize(subBrandIds));
        ApexPages.currentPage().getParameters().put('upsertPromotionDetailListJson', JSON.serialize(new List<ASI_HK_CRM_Promotion_Detail__c>{promotionDetail}));


        ApexPages.StandardController sc = new ApexPages.StandardController(promotion);
        ASI_CRM_SG_EnrollPromotionPlanCtrl controller = new ASI_CRM_SG_EnrollPromotionPlanCtrl(sc);

        controller.getAllRelatedOfftakes();
        controller.getAllRelatedSalesOrderHistories();
        controller.savePromotionDetail();
    }
}