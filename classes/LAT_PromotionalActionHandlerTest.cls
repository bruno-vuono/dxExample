@isTest
private class LAT_PromotionalActionHandlerTest {

    @isTest static void testBasicMethods() {
        LAT_RegionalSupervisor__c rs = LAT_ClientByRegionHandlerTest.createSupervisor(userInfo.getUserId());
        LAT_PromotionalAction__c ap = LAT_ClientByRegionHandlerTest.createAP();
        LAT_ClientByRegion__c cbrOn = LAT_ClientByRegionHandlerTest.createOnCBR(ap.id);
        LAT_ClientByRegion__c cbrOff = LAT_ClientByRegionHandlerTest.createOffCBR(ap.id);
        LAT_AccountInAction__c aiac = LAT_ClientByRegionHandlerTest.createAccountInAction(ap.id);

        Test.startTest();
        LAT_PromotionalActionHandler pah = new LAT_PromotionalActionHandler();
        LAT_PromotionalActionHandler.initAction(new List<String>{ap.id});
        LAT_PromotionalActionHandler.generateTaskForNewClients(ap.Id);

        LAT_PromotionalActionHandler.sendEmail(new List<String>{'test@test.com'}, ap);




        Test.stopTest();

    }

    @isTest static void testBasicMethodsPower() {
        LAT_RegionalSupervisor__c rs = LAT_ClientByRegionHandlerTest.createSupervisor(userInfo.getUserId());
        LAT_PromotionalAction__c ap = LAT_ClientByRegionHandlerTest.createAP();
        LAT_ClientByRegion__c cbrOn = LAT_ClientByRegionHandlerTest.createOnCBR(ap.id);
        LAT_ClientByRegion__c cbrOff = LAT_ClientByRegionHandlerTest.createOffCBR(ap.id);
        LAT_AccountInAction__c aiac = LAT_ClientByRegionHandlerTest.createAccountInAction(ap.id);

        Test.startTest();
        LAT_PromotionalActionHandler pah = new LAT_PromotionalActionHandler();
        LAT_PromotionalActionHandler.closePromotionalActionTasks(new List<String>{ap.id});
        LAT_PromotionalActionHandler.createPromotionalActionTasks(new List<String>{ap.id});
        //closePromotionalActionTasks(ids);
        //createPromotionalActionTasks(ids);
        Test.stopTest();

    }

    @isTest static void testBasicMethods2() {
        LAT_RegionalSupervisor__c rs = LAT_ClientByRegionHandlerTest.createSupervisor(userInfo.getUserId());
        LAT_PromotionalAction__c ap = LAT_ClientByRegionHandlerTest.createAP();
        LAT_ClientByRegion__c cbrOn = LAT_ClientByRegionHandlerTest.createOnCBR(ap.id);
        LAT_ClientByRegion__c cbrOff = LAT_ClientByRegionHandlerTest.createOffCBR(ap.id);
        LAT_AccountInAction__c aiac = LAT_ClientByRegionHandlerTest.createAccountInAction(ap.id);

        LAT_PromotionalActionHandler.getAmmountOfDays();
        LAT_PromotionalActionHandler.pagarPromotionalActionTasks(ap.id);
        LAT_PromotionalActionHandler.pagarClienteActionTasks(aiac.id);

        List<Task> tList = new List<Task>();
        tList.add(LAT_PromotionalActionHandler.createTask(aiac.id, UserInfo.getUserId(), 'test', 'descript', 'Coletar'));
        tList.add(LAT_PromotionalActionHandler.createTask(aiac.id, UserInfo.getUserId(), 'test', 'descript', 'Iniciada'));
        tList.add(LAT_PromotionalActionHandler.createTask(aiac.id, UserInfo.getUserId(), 'test', 'descript', 'Pagamento'));
        tList.add(LAT_PromotionalActionHandler.createTask(aiac.id, UserInfo.getUserId(), 'test', 'descript', 'Cancelada'));
        LAT_PromotionalActionHandler.closeTasks(tList);

        Test.startTest();
            //LAT_PromotionalActionHandler.sendEmail(new List<String>{'testing@testing.com'}, ap);
            LAT_PromotionalActionHandler.initPromotionalAction(ap.id);
            //LAT_PromotionalActionHandler.finaliceAction(ap.id);
            LAT_PromotionalActionHandler.cancelAction(ap.id);
            LAT_PromotionalActionHandler.sendToApproval(ap.id);
            LAT_PromotionalActionHandler.manageClosingTasks(tList.get(0).id);
        Test.stopTest();

    }

}