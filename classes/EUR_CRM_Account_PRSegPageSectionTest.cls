@isTest
public class EUR_CRM_Account_PRSegPageSectionTest {
    
   // @TestSetup
    //static void setupData() {
    //    EUR_CRM_PRS_TestClassUtilityHelper.testInitBG();
    //}
    
    static testMethod void unitTest1(){
        EUR_CRM_PRS_TestClassUtilityHelper.testInitBG();
        EUR_CRM_Account__c acc = [SELECT Id FROM EUR_CRM_Account__c LIMIT 1];
        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);
        
        EUR_CRM_Account_PRSegPageSectionCntrl controller = new EUR_CRM_Account_PRSegPageSectionCntrl(standardController);
    controller.setPRSUrl();
        Object obj = controller.groupOutletType;
        obj = controller.outletType;
        obj = controller.priority;
        obj = controller.businessPotentialLabels;
        obj = controller.brandBuildingPotentialLabels;
        obj = controller.imageLevelLabels;
        obj = controller.volumePotentialLabels;
        obj = controller.potentialMap;
    }
    
     static testMethod void unitTest2(){
        EUR_CRM_PRS_TestClassUtilityHelper.testInitBG_2nd();
        EUR_CRM_Account__c acc = [SELECT Id FROM EUR_CRM_Account__c LIMIT 1];
        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);
        
        EUR_CRM_Account_PRSegPageSectionCntrl controller = new EUR_CRM_Account_PRSegPageSectionCntrl(standardController);
    controller.setPRSUrl();
        Object obj = controller.groupOutletType;
        obj = controller.outletType;
        obj = controller.priority;
        obj = controller.businessPotentialLabels;
        obj = controller.brandBuildingPotentialLabels;
        obj = controller.imageLevelLabels;
        obj = controller.volumePotentialLabels;
        obj = controller.potentialMap;
    }
    
         static testMethod void unitTest3(){
        EUR_CRM_PRS_TestClassUtilityHelper.testInitBE_OffTrade();
        EUR_CRM_Account__c acc = [SELECT Id FROM EUR_CRM_Account__c LIMIT 1];
        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);
        
        EUR_CRM_Account_PRSegPageSectionCntrl controller = new EUR_CRM_Account_PRSegPageSectionCntrl(standardController);
    controller.setPRSUrl();
        Object obj = controller.groupOutletType;
        obj = controller.outletType;
        obj = controller.priority;
        obj = controller.businessPotentialLabels;
        obj = controller.brandBuildingPotentialLabels;
        obj = controller.imageLevelLabels;
        obj = controller.volumePotentialLabels;
        obj = controller.potentialMap;
    }
}