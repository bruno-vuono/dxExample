public with sharing class ASI_KOR_PromotionShowCalendarController {
    
    private Integer calendarInitYear;
    private Integer calendarInitMonth;
    
    public ASI_KOR_PromotionShowCalendarController(ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) // addFields() is not supported when testing
            stdController.addFields(new String[] {'ASI_KOR_Promotion_Start_Date__c'});
        ASI_KOR_Promotion__c pmt = (ASI_KOR_Promotion__c)stdController.getRecord();
        this.calendarInitYear = pmt.ASI_KOR_Promotion_Start_Date__c.year();
        this.calendarInitMonth = pmt.ASI_KOR_Promotion_Start_Date__c.month() - 1;
    }
    
    public PageReference initPage() {
        PageReference redirectPage = Page.ASI_KOR_PromotionCalendarYearPage;
        Map<String, String> params = redirectPage.getParameters();
        params.put(ASI_KOR_PromotionCalendarYearController.URL_PARAM_YEAR, String.valueOf(calendarInitYear));
        params.put(ASI_KOR_PromotionCalendarYearController.URL_PARAM_MONTH, String.valueOf(calendarInitMonth));
        return redirectPage;
    }
    
}