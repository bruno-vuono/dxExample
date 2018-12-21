@isTest
public class ASI_KOR_PromotionShowCalendar_Test{
  public static testMethod void test_main() {
        ASI_KOR_PromotionGenerator pmtGen = new ASI_KOR_PromotionGenerator();
        ASI_KOR_Promotion__c pmt = pmtGen.generateGlobalPromotion();
        insert pmt;
        
        pmt = [SELECT Id, Name, ASI_KOR_Promotion_Start_Date__c FROM ASI_KOR_Promotion__c WHERE Id = :pmt.Id];
        ApexPages.StandardController stdCon = new ApexPages.StandardController(pmt);
        
        Test.startTest();
        
        PageReference testPage = Page.ASI_KOR_PromotionShowCalendarPage;
        Test.setCurrentPageReference(testPage);
        ASI_KOR_PromotionShowCalendarController testCon = new ASI_KOR_PromotionShowCalendarController(stdCon);
        
        PageReference initRedirectPage = testCon.initPage();
        
        System.assertEquals(Page.ASI_KOR_PromotionCalendarYearPage.getUrl(), initRedirectPage.getUrl().substringBefore('?'));
        
        Test.stopTest();
    }
}