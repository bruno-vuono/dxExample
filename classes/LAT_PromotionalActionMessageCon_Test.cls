@isTest
private class LAT_PromotionalActionMessageCon_Test {

	@isTest static void LAT_PromotionalActionMessageController() {

		LAT_PromotionalAction__c ap = LAT_ClientByRegionHandlerTest.createAP();
		LAT_AccountInAction__c aiac = LAT_ClientByRegionHandlerTest.createAccountInAction(ap.id);
		aiac.ClientNotAdhering__c = true;
		update aiac;
		Test.startTest();
			ApexPages.CurrentPage().getparameters().put('id', ap.id);
			ApexPages.StandardController apStandard = new ApexPages.StandardController(ap);

        	LAT_PromotionalActionMessageController cl = new LAT_PromotionalActionMessageController(apStandard);
		Test.stopTest();
	}



}