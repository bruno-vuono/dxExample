/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_ManagePromotionItemTest
 * Description: Test class for ASI_CRM_SG_ManagePromotionItemCtrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-15       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

@IsTest
private class ASI_CRM_SG_ManagePromotionItemTest {
    @IsTest static void testInit() {
        List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();


        ASI_CRM_Promotion_Plan__c promotionPlan = new ASI_CRM_Promotion_Plan__c(
            Name = 'testPromotionPlan',
            ASI_CRM_Start_Date__c = Date.today().toStartOfMonth(),
            ASI_CRM_End_Date__c = Date.today().addMonths(1).toStartOfMonth().addDays(-1),
            ASI_CRM_Enrollment_Cut_off_Date__c = Date.today().addDays(15),
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan'),
            ownerid = UserInfo.getUserId()
        );
        insert promotionPlan;
        system.debug(Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan_Read_Only'));
        
        ASI_CRM_Promotion_Mechanic__c m = new ASI_CRM_Promotion_Mechanic__c(
        	RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Mechanic__cASI_CRM_SG_Promotion_Mechanic'),
            ASI_CRM_Promotion_Plan__c = promotionPlan.id,
            ASI_CRM_Promotional_SKU__c = skuList[0].id,
            ASI_CRM_Buy_Qty__c = 10,
            ASI_CRM_Buy_Unit__c = 'Bottle',
            ASI_CRM_Ad_hoc_Cash__c = 10
        );
        insert m;
        ASI_CRM_Promotion_Mechanic__c m2 = new ASI_CRM_Promotion_Mechanic__c(
        	RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Mechanic__cASI_CRM_SG_Promotion_Mechanic'),
            ASI_CRM_Promotion_Plan__c = promotionPlan.id,
            ASI_CRM_Promotional_SKU__c = skuList[0].id,
            ASI_CRM_Buy_Qty__c = 10,
            ASI_CRM_Buy_Unit__c = 'Bottle',
            ASI_CRM_Ad_hoc_Cash__c = 10
        );
        insert m2;
        
        list<ASI_CRM_Promotion_Mechanic__c> list_mExist = new list<ASI_CRM_Promotion_Mechanic__c>();
        list_mExist.add(m);
        list<string> list_mId = new list<string>();
        list_mId.add(m2.id);
        
        ASI_HK_CRM_Promotion__c p1 = new ASI_HK_CRM_Promotion__c(
        	recordtypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion'),
            ASI_CRM_Promotion_Plan__c = promotionPlan.id,
            ownerid = UserInfo.getUserId()
        );
        insert p1;
        ASI_HK_CRM_Promotion__c p2 = new ASI_HK_CRM_Promotion__c(
        	recordtypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion'),
            ASI_CRM_Promotion_Plan__c = promotionPlan.id,
            ownerid = UserInfo.getUserId()
        );
        insert p2;
        
        ASI_HK_CRM_Promotion_Detail__c pd1 = new ASI_HK_CRM_Promotion_Detail__c(
        	recordtypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion_Detail__cASI_CRM_SG_Customer'),
            ASI_HK_CRM_Promotion__c = p1.id,
            ASI_CRM_Promotion_Mechanic__c = m.id
        );
        insert pd1;

        list<ASI_HK_CRM_Promotion__c> list_pExist = new list<ASI_HK_CRM_Promotion__c>();
        list_pExist.add(p1);
        list<string> list_pId = new list<string>();
        list_pId.add(p2.id);
        
        ApexPages.currentPage().getParameters().put('id', promotionPlan.Id);
        ApexPages.currentPage().getParameters().put('upsertPromotionMechanicListJson', objectToJsonString(list_mExist));
        ApexPages.currentPage().getParameters().put('deletePromotionMechanicIdListJson', objectToJsonString(list_mId));
        ApexPages.currentPage().getParameters().put('upsertpromotionListJson', objectToJsonString(list_pExist));
        ApexPages.currentPage().getParameters().put('deletePromotionIdListJson', objectToJsonString(list_pId));


        ApexPages.StandardController sc = new ApexPages.StandardController(promotionPlan);
        ASI_CRM_SG_ManagePromotionItemCtrl controller = new ASI_CRM_SG_ManagePromotionItemCtrl(sc);

        controller.savePromotionMechanic();
        controller.getPriceCost();
        
        test.starttest();
        
        ASI_CRM_SG_PromotionPlanEmailCtrl ctrl = new ASI_CRM_SG_PromotionPlanEmailCtrl();
        ctrl.headerId = promotionPlan.id;
        ctrl.withCustomer = true;
        ctrl.getCustomerDetail();
        ctrl.getChilds();
        ctrl.getHeader();
        
        list<ASI_CRM_Promotion_Plan__c> approvedPromotionPlanList = new list<ASI_CRM_Promotion_Plan__c>();
        approvedPromotionPlanList.add(promotionPlan);
        
        promotionPlan.ASI_CRM_SYS_Send_Email__c = true;
        ASI_CRM_SG_PromotionPlanService.getInstance().sendEmailToPromotionOwner(approvedPromotionPlanList);
        
        promotionPlan.ASI_CRM_Status__c = 'Rejected';
        ASI_CRM_SG_PromotionPlanService.getInstance().rejectAllPromotions(approvedPromotionPlanList);
        
        promotionPlan.ASI_CRM_Status__c = 'Final Approved';
        ASI_CRM_SG_PromotionPlanService.getInstance().finalApproveAllPromotions(approvedPromotionPlanList);
        
        test.stoptest();
    }
    
    private static String objectToJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

}