@isTest
private class ESN_MB_BestPractices_Cx_Test {

	@IsTest(SeeAllData=true)
    static void bestPractices() {
        PageReference pageRef = new PageReference('/apex/ESN_chatterDAM');
        Test.setCurrentPage(pageRef);
        
        ESN_MB_BestPractices_Cx controller = new ESN_MB_BestPractices_Cx();
        controller.getListBestPractices();
        controller.getListBusinessPriorities();
		controller.getListRegions();
		controller.getListAffiliates();
        controller.getListBrands();
        controller.getListMarkets();
        controller.getListFunctions();
        controller.getListStatus();
        controller.getListYears();
		controller.getListCoordinators();
		controller.getCoordinator();
		
		String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
		
		ESN_MB_BestPractices_Cx.getBestPracticesData(activation.Id);
		ESN_MB_BestPractices_Cx.saveBestPracticesStep1(activation.Id, 'status', 'businessPriority', 'comment');
		ESN_MB_BestPractices_Cx.saveBestPracticesStep2(activation.Id, 'status', 'businessPriority', 'comment');
    }
}