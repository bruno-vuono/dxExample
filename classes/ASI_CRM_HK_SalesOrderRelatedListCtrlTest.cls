@isTest
private class ASI_CRM_HK_SalesOrderRelatedListCtrlTest {

    static testMethod void test_showSO() {
        Test.StartTest();
        
        ASI_HK_CRM_TestUtils.initSOEssentialSettings();
        ASI_HK_CRM_TestUtils.initSOWSSettings();
        ASI_HK_CRM_TestUtils.CommonData cmData = new ASI_HK_CRM_TestUtils.CommonData();
        ASI_HK_CRM_TestUtils.assignCreditAccountData(cmData, 3, 3);
        ASI_HK_CRM_TestUtils.assignSalesOrderData(cmData, 3, 3);
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
        
        Account acc=cmData.acctPA;
                
        Test.setCurrentPage(Page.ASI_CRM_HK_AccSalesOrderRelatedListPage);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ASI_CRM_HK_AccSalesOrderRelatedListCtrl c=new ASI_CRM_HK_AccSalesOrderRelatedListCtrl(sc);
        
        c.getLineItem();
        String s=c.mapSOlineJSON;
               
        Test.stopTest();
    }
}