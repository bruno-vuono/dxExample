@isTest
private class ASI_FOC_FreeGoodRequestCloneChildTest {

    static testMethod void test_main() {
        final Integer numOfSKU = 5;
        final Integer numOfFGReqDetail = 3;
        
        ASI_FOC_SKUGenerator skuGen = new ASI_FOC_SKUGenerator();
        ASI_FOC_FreeGoodRequestGenerator fgReqGen = new ASI_FOC_FreeGoodRequestGenerator();
        ASI_FOC_FreeGoodRequestDetailGenerator fgReqDetailGen = new ASI_FOC_FreeGoodRequestDetailGenerator();
        
        List<ASI_MFM_SKU_Code__c> skuList = new List<ASI_MFM_SKU_Code__c>();
        ASI_FOC_Free_Goods_Request__c cloneFromFGReq;
        ASI_FOC_Free_Goods_Request__c cloneToFGReq;
        List<ASI_FOC_Request_Item__c> fgReqDetailList = new List<ASI_FOC_Request_Item__c>();
        
        for (Integer i = 0; i < numOfSKU; i++) {
            skuList.add(skuGen.generateSKU(null));
        }
        insert skuList;
        
        cloneFromFGReq = fgReqGen.generateTradeFreeGoodRequest();
        insert cloneFromFGReq;
        
        for (Integer i = 0; i < numOfFGReqDetail; i++) {
            fgReqDetailList.add(fgReqDetailGen.generateFreeGoodRequestDetail(cloneFromFGReq, skuList[i]));
        }
        insert fgReqDetailList;
        
        cloneToFGReq = fgReqGen.generateTradeFreeGoodRequest();
        insert cloneToFGReq;
        
        Test.startTest();
        
        PageReference testPage = Page.ASI_FOC_FreeGoodRequestCloneChildPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put(ASI_FOC_FreeGoodRequestCloneChildCON.URL_PARAM_NEW_ID, cloneToFGReq.Id);
        Test.setCurrentPageReference(testPage);
        ASI_FOC_FreeGoodRequestCloneChildCON testController = new ASI_FOC_FreeGoodRequestCloneChildCON();
        PageReference initRedirectPage = testController.initPage();
        PageReference linkRedirectPage = testController.redirectToAnotherPage();
        String linkDisplayStr = testController.anotherPageLabel;
        
        System.assertEquals(null, initRedirectPage);
        System.assertEquals(Page.ASI_FOC_FreeGoodRequestDetailEditPage.getUrl(), linkRedirectPage.getUrl().substringBefore('?'));
        System.assertEquals(ASI_FOC_FreeGoodRequestCloneChildCON.FAIL_LINK_LABEL_Continue, linkDisplayStr);
        
        
        pageParams.put(ASI_FOC_FreeGoodRequestCloneChildCON.URL_PARAM_FROM_ID, cloneFromFGReq.Id);
        testController = new ASI_FOC_FreeGoodRequestCloneChildCON();
        initRedirectPage = testController.initPage();
        testController.showPageWarning('Hello my friend');
        //System.assertEquals(Page.ASI_FOC_FreeGoodRequestDetailEditPage.getUrl(), initRedirectPage.getUrl().substringBefore('?'));
        List<ASI_FOC_Request_Item__c> testReqItemList = [SELECT Id FROM ASI_FOC_Request_Item__c WHERE ASI_FOC_Request_Order__c = :cloneToFGReq.Id];
        //System.assertEquals(numOfFGReqDetail, testReqItemList.size());
        
        Test.stopTest();
    }
}