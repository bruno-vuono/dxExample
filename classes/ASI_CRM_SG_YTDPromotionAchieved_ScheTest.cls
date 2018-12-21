/*********************************************************************************
 * Name:ASI_CRM_SG_YTDPromotionAchieved_ScheTest
 * Description: test class for ASI_CRM_SG_YTDPromotionAchieved_Sche
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-06-15       Vincent Lam             Created
*********************************************************************************/

@isTest
private class ASI_CRM_SG_YTDPromotionAchieved_ScheTest {
  
    @TestSetup
    public static void setupTestData() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
		List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();
        List<ASI_MFM_SKU_Code__c> giftVoucherList = ASI_CRM_SG_TestClassHelper.createGiftVoucher();
		ASI_CRM_SG_TestClassHelper.customerData outlet = new ASI_CRM_SG_TestClassHelper.customerData(true);
		ASI_CRM_SG_TestClassHelper.wholesalesCustomerData wholesaler = new ASI_CRM_SG_TestClassHelper.wholesalesCustomerData(true);

		List<ASI_CRM_Promotion_Plan__c> list_promotionPlan = new List<ASI_CRM_Promotion_Plan__c>();
		
        ASI_CRM_Promotion_Plan__c promotionPlanW = new ASI_CRM_Promotion_Plan__c(
            Name = 'testPromotionPlanW',
            ASI_CRM_Start_Date__c = Date.today().addmonths(-1).toStartOfMonth(),
            ASI_CRM_End_Date__c = Date.today().addMonths(2).toStartOfMonth().addDays(-1),
            ASI_CRM_Enrollment_Cut_off_Date__c = Date.today().addDays(15),
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Wholesaler_Promotion_Plan_Final_Approved'),
            ownerid = UserInfo.getUserId()
        );
        ASI_CRM_Promotion_Plan__c promotionPlanO = new ASI_CRM_Promotion_Plan__c(
            Name = 'testPromotionPlanO',
            ASI_CRM_Start_Date__c = Date.today().addmonths(-1).toStartOfMonth(),
            ASI_CRM_End_Date__c = Date.today().addMonths(2).toStartOfMonth().addDays(-1),
            ASI_CRM_Enrollment_Cut_off_Date__c = Date.today().addDays(15),
            RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Plan__cASI_CRM_SG_Outlet_Promotion_Plan_Final_Approved'),
            ownerid = UserInfo.getUserId()
        );
		list_promotionPlan.add(promotionPlanW);
		list_promotionPlan.add(promotionPlanO);
        insert list_promotionPlan;
		
		for(ASI_CRM_Promotion_Plan__c plan : list_promotionPlan){
			list<ASI_CRM_Promotion_Mechanic__c> list_mechanics = new list<ASI_CRM_Promotion_Mechanic__c>();
			
			for(ASI_MFM_SKU_Code__c sku : skuList){
				ASI_CRM_Promotion_Mechanic__c m = new ASI_CRM_Promotion_Mechanic__c(
				  RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Mechanic__cASI_CRM_SG_Promotion_Mechanic'),
					ASI_CRM_Promotion_Plan__c = plan.id,
					ASI_CRM_Promotional_SKU__c = sku.id,
					ASI_CRM_Additional_SKU_POSM__c = sku.id,
					ASI_CRM_Additional_SKU_Bottle_Qty__c = 1,
					ASI_CRM_Bottle_Size_Additional__c = 70,
					ASI_CRM_Bottle_Size_Promotional__c = 70,
					ASI_CRM_Buy_Qty__c = 10,
					ASI_CRM_Buy_Unit__c = 'Bottle',
					ASI_CRM_Ad_hoc_Cash__c = 10,
					ASI_CRM_Gift_Voucher__c = giftVoucherList[0].id,
					ASI_CRM_Gift_Voucher_Value_Cash__c = 100,
					ASI_CRM_IGC_Cost_Case_Promotional__c = 200,
					ASI_CRM_Other_in_Kind_Cash__c = 0.5,
					ASI_CRM_Packaging_Size_Additional__c = 12,
					ASI_CRM_Packaging_Size_Promotional__c = 12,
					ASI_CRM_RTM_WS_Price_Bottle_Additional__c = 100,
					ASI_CRM_RTM_WS_Price_Bottle_Promotional__c = 100,
					ASI_CRM_Target_Qty_Bottle__c = 1000,
					ASI_CRM_Trade_Deal_Bottle_Qty__c = 1
				);
				list_mechanics.add(m);
			}
			insert list_mechanics;
			
			ASI_HK_CRM_Promotion__c p1 = new ASI_HK_CRM_Promotion__c(
			  recordtypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion'),
				ASI_CRM_Promotion_Plan__c = plan.id,
				ownerid = UserInfo.getUserId()
			);
			insert p1;
						
			List<ASI_HK_CRM_Promotion_Detail__c> list_pd = new List<ASI_HK_CRM_Promotion_Detail__c>();
			for(ASI_CRM_Promotion_Mechanic__c m : list_mechanics){
				ASI_HK_CRM_Promotion_Detail__c pd1 = new ASI_HK_CRM_Promotion_Detail__c(
				    recordtypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion_Detail__cASI_CRM_SG_Customer'),
					ASI_HK_CRM_Promotion__c = p1.id,
					ASI_CRM_Promotion_Mechanic__c = m.id,
					ASI_CRM_SG_Customer__c = outlet.customer.id,
					ASI_CRM_Target_Qty_Bottle__c = 1
				);
				ASI_HK_CRM_Promotion_Detail__c pd2 = new ASI_HK_CRM_Promotion_Detail__c(
				    recordtypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion_Detail__cASI_CRM_SG_Customer'),
					ASI_HK_CRM_Promotion__c = p1.id,
					ASI_CRM_Promotion_Mechanic__c = m.id,
					ASI_CRM_SG_Customer__c = wholesaler.customer.id,
					ASI_CRM_Target_Qty_Bottle__c = 1
				);
				list_pd.add(pd1);
				list_pd.add(pd2);
			}
			insert list_pd;
		}
        
		List<ASI_TH_CRM_Actual_Offtake__c> list_a = new List<ASI_TH_CRM_Actual_Offtake__c>();
		for(ASI_MFM_SKU_Code__c sku : skuList){
			ASI_TH_CRM_Actual_Offtake__c a = new ASI_TH_CRM_Actual_Offtake__c(
			    RecordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_SG_Actual_offtake'),
				ASI_CRM_SKU__c = sku.id,
				ASI_CRM_SG_Customer__c = outlet.customer.id,
				ASI_CRM_FromWS__c = wholesaler.customer.id,
				ASI_TH_CRM_Offtake_G_L_Date__c = system.today().addmonths(-1),
				ASI_CRM_RTM_Wholesaler_Price__c = 100,
				ASI_TH_CRM_Quantity__c = 10
			);
			list_a.add(a);
		}
		insert list_a;
		
		Account testAccount = new Account(
            Name = 'TestWholesaler'
        );
        insert testAccount;
		
        ASI_HK_CRM_Running_Number__c runningNumber = new ASI_HK_CRM_Running_Number__c(
                                          ASI_HK_CRM_Object_Name__c = 'ASI_HK_CRM_Sales_Order__c',
                                          ASI_HK_CRM_First_Month_of_Fiscal_Year__c = 7
                                          );
    	insert runningNumber;
        
		List<ASI_HK_CRM_Sales_Order_History_Detail__c> list_b = new List<ASI_HK_CRM_Sales_Order_History_Detail__c>();
		ASI_HK_CRM_Sales_Order_History__c soh = new ASI_HK_CRM_Sales_Order_History__c(
			RecordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Sales_Order_History__cASI_CRM_SG_Sales_Order_History'),
			ASI_CRM_Sold_To__c = wholesaler.customer.id,
			ASI_HK_CRM_Order_Date__c = system.today().addmonths(-1),
			ASI_HK_CRM_Account_PA__c = testAccount.Id,
			ASI_HK_CRM_Order_Type__c = 'Singapore DF & DP Sales Order - SO'
		);
		insert soh;
		for(ASI_MFM_SKU_Code__c sku : skuList){
			ASI_HK_CRM_Sales_Order_History_Detail__c b = new ASI_HK_CRM_Sales_Order_History_Detail__c(
			    RecordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Sales_Order_History_Detail__cASI_CRM_SG_Sales_Order_History_Detail'),
				ASI_HK_CRM_Product_SKU__c = sku.id,
				ASI_HK_CRM_Sales_Order_History__c = soh.id,
				ASI_HK_CRM_Total_Amount__c = 270,
				ASI_HK_CRM_Quantity_in_Bottles__c  = 10
			);
			list_b.add(b);
		}
		insert list_b;
		
    }
    
    static testMethod void TestSchedulableClass() {

      Test.startTest(); // Start Test
          // Schedule the test job
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        
        String jobId = System.schedule('My batch Job',
                         CRON_EXP, 
                         new ASI_CRM_SG_YTDPromotionAchieved_Sche());
        
        // To track the progress of the scheduled job.
        CronTrigger ct = [SELECT TimesTriggered
                               , NextFireTime
                               , CronExpression
                            FROM CronTrigger 
                           WHERE Id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP,
                            ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

      Test.stopTest(); // End Test
    }

    static testMethod void TestBatchClass() {

      Test.startTest(); // Start Test
	  
       date lastMonth = system.today().addmonths(-1);
        string yearStr = String.valueOf(lastMonth.year());
        string monthStr = String.valueOf(lastMonth.month());
        
        Id jobId = Database.executeBatch(new ASI_CRM_SG_YTDPromotionAchieved_Batch(yearStr, monthStr), 200); 

      Test.stopTest(); // End Test
    }

}