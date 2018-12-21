@isTest
/*  Test Method: 

ASI_MFM_Plan_TriggerClass
ASI_MFM_PO_TriggerClass
ASI_MFM_POLineItem_TriggerClass

ASI_MFM_SelectPaymentPrefixController
ASI_MFM_SelectPOPrefixController

***************************
*       ASI_MFM_PH_InputPlanItemsController
        ASI_MFM_PH_PlanNewPORedirectCtrl
        ASI_MFM_PH_InputPOItemsController
        ASI_MFM_PH_InputPaymentItemsController
        ASI_MFM_PH_Payment_PDF_PageController
        ASI_MFM_PH_PORelatedPaymentsController
        ASI_MFM_PH_FV_Controller
        ASI_MFM_Payment_TriggerClass
        ASI_MFM_PH_GLDate_SettingController
        ASI_MFM_PH_SupplierEditSupplierNoCtrl        
		ASI_MFM_PH_PO_PDF_PageController
        ASI_MFM_PH_BAverifyController
        ASI_MFM_SetPOStatusController
        ASI_MFM_PH_Payment_TriggerClass
        ASI_MFM_SetPaymentStatusController


ASI_MFM_RerunETLController
* History
* -----------------------------------------------------------------------------
* 2015-10-30    Elufasys      Created
*
*/


private class ASI_MFM_PH_Plan_TestClass {
      static testMethod void testPlanDPPrefixController2()
    { 
      //Test ASI_MFM_SelectPlanPrefixController
        ASI_MFM_Plan__c plan1 = new ASI_MFM_Plan__c( Name = 'Test Plan2',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DP_Plan'),ASI_MFM_Start_Date__c = date.today().adddays(1),ASI_MFM_End_Date__c = date.today().adddays(1),ASI_MFM_Prefix__c = ASI_MFM_PH_TestClassHelper.createPHDPMultiPrefixPlan().id);
        insert plan1;
        Test.startTest();
        
        PageReference planPrefixPage = Page.ASI_MFM_SelectPlanPrefixPage;

        Test.setCurrentPage(planPrefixPage);
        // 
        ApexPages.currentPage().getParameters().put('RecordType', String.valueof(plan1.recordtypeid).substring(0,15));
        ApexPages.currentPage().getParameters().put('id', plan1.id);
        
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(Plan1);        
        ASI_MFM_SelectPlanPrefixController SelectPlanPrefixController = new ASI_MFM_SelectPlanPrefixController(stdController);
        
        SelectPlanPrefixController.getPrefixes();
        SelectPlanPrefixController.proceed();
       
        // 
        Test.stopTest();
    }
    
      static testMethod void testPlanDFPrefixController2()
    { 
      //Test ASI_MFM_SelectPlanPrefixController
        ASI_MFM_Plan__c plan1 = new ASI_MFM_Plan__c( Name = 'Test Plan2',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DF_Plan'),ASI_MFM_Start_Date__c = date.today().adddays(1),ASI_MFM_End_Date__c = date.today().adddays(1),ASI_MFM_Prefix__c = ASI_MFM_PH_TestClassHelper.createPHDFMultiPrefixPlan().id);
        insert plan1;
        Test.startTest();
        
        PageReference planPrefixPage = Page.ASI_MFM_SelectPlanPrefixPage;

        Test.setCurrentPage(planPrefixPage);
        // 
        ApexPages.currentPage().getParameters().put('RecordType', String.valueof(plan1.recordtypeid).substring(0,15));
        ApexPages.currentPage().getParameters().put('id', plan1.id);
        
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(Plan1);        
        ASI_MFM_SelectPlanPrefixController SelectPlanPrefixController = new ASI_MFM_SelectPlanPrefixController(stdController);
        
        SelectPlanPrefixController.getPrefixes();
        SelectPlanPrefixController.proceed();
       
        // 
        Test.stopTest();
    }


     static testMethod void testPlanDPPrefixController()
    { 
       //Test ASI_MFM_SelectPlanPrefixController
        ASI_MFM_Plan__c plan1 = ASI_MFM_PH_TestClassHelper.createPHDPPlan();
        
        Test.startTest();
        
        PageReference planPrefixPage = Page.ASI_MFM_SelectPlanPrefixPage;

        Test.setCurrentPage(planPrefixPage);
        // 
        ApexPages.currentPage().getParameters().put('RecordType', String.valueof(plan1.recordtypeid).substring(0,15));
        ApexPages.currentPage().getParameters().put('id', plan1.id);
        
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(Plan1);        
        ASI_MFM_SelectPlanPrefixController SelectPlanPrefixController = new ASI_MFM_SelectPlanPrefixController(stdController);
        
        SelectPlanPrefixController.getPrefixes();
        SelectPlanPrefixController.proceed();
       
        // 
        Test.stopTest();
    }

  
     static testMethod void testPlanDFPrefixController()
    { 
       //Test ASI_MFM_SelectPlanPrefixController
        ASI_MFM_Plan__c plan1 = ASI_MFM_PH_TestClassHelper.createPHDFPlan();
        
        Test.startTest();
        
        PageReference planPrefixPage = Page.ASI_MFM_SelectPlanPrefixPage;

        Test.setCurrentPage(planPrefixPage);
        // 
        ApexPages.currentPage().getParameters().put('RecordType', String.valueof(plan1.recordtypeid).substring(0,15));
        ApexPages.currentPage().getParameters().put('id', plan1.id);
        
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(Plan1);        
        ASI_MFM_SelectPlanPrefixController SelectPlanPrefixController = new ASI_MFM_SelectPlanPrefixController(stdController);
        
        SelectPlanPrefixController.getPrefixes();
        SelectPlanPrefixController.proceed();
       
        // 
        Test.stopTest();
    }

    static testMethod void InputPlanItems_Test() {
        //Test class:  ASI_MFM_Plan_TriggerClass      ASI_MFM_PH_InputPlanItemsController
        ASI_MFM_Plan__c plan = ASI_MFM_PH_TestClassHelper.createPHDPPlan();
        ASI_MFM_Plan_Line_Item__c planLine = ASI_MFM_PH_TestClassHelper.createPHPlanLines1(plan);
        List<ASI_MFM_Plan_Line_Item__c> planLineSet = new List<ASI_MFM_Plan_Line_Item__c>();
        planLineSet.add(planLine);
        
        ApexPages.standardSetController sc = new ApexPages.standardSetController(planLineSet);
        
        PageReference inputPlanItemsPage = Page.ASI_MFM_PH_InputPlanItemsPage;
        Map<String, String> pageParams = inputPlanItemsPage.getParameters();
        Test.startTest();
        
        pageParams.put('id', plan.Id);
        Test.setCurrentPageReference(inputPlanItemsPage);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(plan);        
        
        ASI_MFM_PH_InputPlanItemsController PlanManageAllController = new ASI_MFM_PH_InputPlanItemsController(stdController);
        //Test function
        PlanManageAllController.init();
        System.currentPageReference().getParameters().put('PARAM_clone_ID', (String)planLine.id);
        PlanManageAllController.cloneLine();
        PlanManageAllController.SaveItems();
        PlanManageAllController.addLineItem();
        System.currentPageReference().getParameters().put('PARAM_Line_ID', (String)planLine.id);
        PlanManageAllController.removeLine();
        
        //Test RemoteAction
        List<Account> remo= ASI_MFM_PH_InputPlanItemsController.findSObjects('Account','WHERE RecordType.DeveloperName = ASI_MFM_PH_DF_Customer');
       
        test.stopTest(); 
       
    }
    
    
     static testMethod void InputPlanItems_Test_Fail_Case() {
        //Test class:     ASI_MFM_PH_InputPlanItemsController
        ASI_MFM_PH_TestClassHelper.createMFMDefaultValues();
        
        ASI_MFM_Plan__c plan = ASI_MFM_PH_TestClassHelper.createPHDFPlan();
        ASI_MFM_Plan_Line_Item__c planLine = ASI_MFM_PH_TestClassHelper.createPHPlanLines2(plan);
        List<ASI_MFM_Plan_Line_Item__c> planLineSet = new List<ASI_MFM_Plan_Line_Item__c>();
        planLineSet.add(planLine);
        
        ApexPages.standardSetController sc = new ApexPages.standardSetController(planLineSet);
        
        PageReference inputPlanItemsPage = Page.ASI_MFM_PH_InputPlanItemsPage;
        Map<String, String> pageParams = inputPlanItemsPage.getParameters();
        Test.startTest();
        pageParams.put('id', plan.Id);
        Test.setCurrentPageReference(inputPlanItemsPage);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(plan);        
        
        ASI_MFM_PH_InputPlanItemsController PlanManageAllController = new ASI_MFM_PH_InputPlanItemsController(stdController);
        //Test function
        PlanManageAllController.init();
        System.currentPageReference().getParameters().put('PARAM_clone_ID', (String)planLine.id);
        PlanManageAllController.cloneLine();
        PlanManageAllController.SaveItems();
        PlanManageAllController.addLineItem();
        System.currentPageReference().getParameters().put('PARAM_Line_ID', (String)planLine.id);
        PlanManageAllController.removeLine();
       
        test.stopTest(); 
       
    }
     
    
    
}