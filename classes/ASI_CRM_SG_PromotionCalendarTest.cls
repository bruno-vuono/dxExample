@isTest
public with sharing class ASI_CRM_SG_PromotionCalendarTest {
    public static final String RECORTYPE_DEV_NAME = 'ASI_CRM_SG';
    static Id RectypeId { get{return [Select Id from Recordtype where developername=:RECORTYPE_DEV_NAME].Id;} set;}

    public static testMethod void test_main_month() {
      ASI_HK_CRM_PromotionGenerator pmtGen = new ASI_HK_CRM_PromotionGenerator();
      Date todayDate = System.today();
      final Integer numOfPmt = 4;
      final List<Date> startAndEndDateList = new List<Date>{
        todayDate.addDays(3), todayDate.addDays(4)
        , todayDate.addDays(14), todayDate.addDays(20)
        , todayDate.addDays(13), todayDate.addDays(18)
        , todayDate.addDays(35), todayDate.addDays(41)
      };
        List<ASI_HK_CRM_Promotion__c> pmtList = new List<ASI_HK_CRM_Promotion__c>();
        for (Integer i = 0; i < startAndEndDateList.size(); i += 2) {
          //pmtList.add(pmtGen.generateGlobalPromotion(startAndEndDateList.get(i), startAndEndDateList.get(i + 1)));
          ASI_HK_CRM_Promotion__c promotion = new ASI_HK_CRM_Promotion__c();
          promotion.name = 'PMT-'+i;
          promotion.ASI_HK_CRM_Promotion_Start_Date__c=startAndEndDateList.get(i);
          promotion.ASI_HK_CRM_Promotion_End_Date__c = startAndEndDateList.get(i + 1);
          promotion.ASI_HK_CRM_Promotion_Name__c='Test Promotion'+i;
          promotion.RecordTypeId = RectypeId;
          pmtList.add(promotion);

        }
        insert pmtList;
        system.debug('@pmtList'+pmtList);
        
        Test.startTest();
        
        // Initialize page and controller
        PageReference testPage = Page.ASI_CRM_SG_PromotionCalendarMonthPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put(ASI_CRM_SG_PromotionCalendarMonthCON.URL_PARAM_YEAR, String.valueOf(todayDate.year()));
        pageParams.put(ASI_CRM_SG_PromotionCalendarMonthCON.URL_PARAM_MONTH, String.valueOf(todayDate.month()));
        Test.setCurrentPageReference(testPage);
        ASI_CRM_SG_PromotionCalendarMonthCON testController = new ASI_CRM_SG_PromotionCalendarMonthCON();
        PageReference initRedirectPage = testController.initPage();
        System.assertEquals(null, initRedirectPage);
        
        List<ASI_CRM_SG_PromotionCalendarMonthCON.ASI_SG_CRM_PromotionMonthEvent> monthEventList = 
          ASI_CRM_SG_PromotionCalendarMonthCON.retrievePromotionsByTimeRange(
            ASI_CRM_SG_PromotionCalendarMonthCON.convertToRetrivalDateFormat(todayDate)
            , ASI_CRM_SG_PromotionCalendarMonthCON.convertToRetrivalDateFormat(todayDate.addDays(42))
        );
      //System.assertEquals(numOfPmt, monthEventList.size());
      
      // Redirect to promotion detail page
      testPage.getParameters().put('pmtId', pmtList.get(0).Id);
      testPage.getParameters().put('retURL', Page.ASI_CRM_SG_PromotionCalendarMonthPage.getUrl());
      PageReference pmtViewPage = testController.redirectToViewPage();
      System.assert(pmtViewPage != null);
      
      // Redirect to year view calendar
      testController.selectedCalendarType = ASI_CRM_SG_PromotionCalendarCommonClass.CALENDAR_TYPE_YEAR;
      PageReference anotherCalendarPage = testController.redirectToAnotherCalendarType();
      System.assertEquals(Page.ASI_CRM_SG_PromotionCalendarYearPage.getUrl(), anotherCalendarPage.getUrl());
        
        Test.stopTest();
    }
 
  
  public static testMethod void test_main_year() {
      ASI_HK_CRM_PromotionGenerator pmtGen = new ASI_HK_CRM_PromotionGenerator();
      ASI_HK_CRM_BrandGenerator brandGen = new ASI_HK_CRM_BrandGenerator();
      ASI_HK_CRM_SubBrandGenerator sbGen = new ASI_HK_CRM_SubBrandGenerator();
      ASI_HK_CRM_AccountGenerator acctGen = new ASI_HK_CRM_AccountGenerator();
      Date todayDate = System.today();
      final Integer numOfPmt = 4;
      final List<Date> startAndEndDateList = new List<Date>{
        todayDate.addDays(3), todayDate.addDays(4)
        , todayDate.addDays(14), todayDate.addDays(20)
        , todayDate.addDays(13), todayDate.addDays(18)
        , todayDate.addDays(35), todayDate.addDays(41)
      };
        List<ASI_HK_CRM_Promotion__c> pmtList = new List<ASI_HK_CRM_Promotion__c>();
         for (Integer i = 0; i < startAndEndDateList.size(); i += 2) {
          //pmtList.add(pmtGen.generateGlobalPromotion(startAndEndDateList.get(i), startAndEndDateList.get(i + 1)));
          ASI_HK_CRM_Promotion__c promotion = new ASI_HK_CRM_Promotion__c();
          promotion.name = 'PMT-'+i;
          promotion.ASI_HK_CRM_Promotion_Start_Date__c=startAndEndDateList.get(i);
          promotion.ASI_HK_CRM_Promotion_End_Date__c = startAndEndDateList.get(i + 1);
          promotion.ASI_HK_CRM_Promotion_Name__c='Test Promotion'+i;
          promotion.RecordTypeId = RectypeId;
          pmtList.add(promotion);

        }
        insert pmtList;
        
        ASI_MFM_Brand__c brand = brandGen.generateBrand();
        insert brand;
        List<ASI_MFM_Sub_brand__c> sbList = new List<ASI_MFM_Sub_brand__c>();
        for (Integer i = 0; i < 2; i++) {
          sbList.add(sbGen.generateSubBrand(brand));
        }
        insert sbList;
        Account ws = acctGen.generateAccount(ASI_HK_CRM_AccountGenerator.RT_JDE_CREDIT);
        insert ws;
        List<ASI_HK_CRM_Promotion_Detail__c> pmtDetailList = pmtGen.generatePromotionDetails(pmtList.get(0), sbList, new List<Account>{ws});
        insert pmtDetailList;
        
        Test.startTest();
        
        // Initialize page and controller
        PageReference testPage = Page.ASI_CRM_SG_PromotionCalendarYearPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put(ASI_CRM_SG_PromotionCalendarYearCON.URL_PARAM_YEAR, String.valueOf(todayDate.year()));
        pageParams.put(ASI_CRM_SG_PromotionCalendarYearCON.URL_PARAM_MONTH, String.valueOf(todayDate.month() - 1));
        Test.setCurrentPageReference(testPage);
        ASI_CRM_SG_PromotionCalendarYearCON testController = new ASI_CRM_SG_PromotionCalendarYearCON();
        PageReference initRedirectPage = testController.initPage();
        System.assertEquals(null, initRedirectPage);
        
        // Validate display promotions
      //System.assertEquals(sbList.size() + (pmtList.size() > 1 ? 1 : 0), testController.eventGroups.size());
      //System.assertEquals(pmtList.size() + sbList.size() - 1, testController.eventList.size());
      
      // Redirect to month view calendar
      testController.selectedCalendarType = ASI_CRM_SG_PromotionCalendarCommonClass.CALENDAR_TYPE_MONTH;
      PageReference anotherCalendarPage = testController.redirectToAnotherCalendarType();
      //System.assertEquals(Page.ASI_CRM_SG_PromotionCalendarMonthPage.getUrl(), anotherCalendarPage.getUrl());
        
        Test.stopTest();
    }

     public static testMethod void test_main_year_Outlet() {
      ASI_HK_CRM_PromotionGenerator pmtGen = new ASI_HK_CRM_PromotionGenerator();
      ASI_HK_CRM_BrandGenerator brandGen = new ASI_HK_CRM_BrandGenerator();
      ASI_HK_CRM_SubBrandGenerator sbGen = new ASI_HK_CRM_SubBrandGenerator();
      ASI_HK_CRM_AccountGenerator acctGen = new ASI_HK_CRM_AccountGenerator();
      Date todayDate = System.today();
      final Integer numOfPmt = 4;
      final List<Date> startAndEndDateList = new List<Date>{
        todayDate.addDays(3), todayDate.addDays(4)
        , todayDate.addDays(14), todayDate.addDays(20)
        , todayDate.addDays(13), todayDate.addDays(18)
        , todayDate.addDays(35), todayDate.addDays(41)
      };
        List<ASI_HK_CRM_Promotion__c> pmtList = new List<ASI_HK_CRM_Promotion__c>();
         for (Integer i = 0; i < startAndEndDateList.size(); i += 2) {
          //pmtList.add(pmtGen.generateGlobalPromotion(startAndEndDateList.get(i), startAndEndDateList.get(i + 1)));
          ASI_HK_CRM_Promotion__c promotion = new ASI_HK_CRM_Promotion__c();
          promotion.name = 'PMT-'+i;
          promotion.ASI_HK_CRM_Promotion_Start_Date__c=startAndEndDateList.get(i);
          promotion.ASI_HK_CRM_Promotion_End_Date__c = startAndEndDateList.get(i + 1);
          promotion.ASI_HK_CRM_Promotion_Name__c='Test Promotion'+i;
          promotion.RecordTypeId = RectypeId;
          pmtList.add(promotion);

        }
        insert pmtList;
        
        ASI_MFM_Brand__c brand = brandGen.generateBrand();
        insert brand;
        List<ASI_MFM_Sub_brand__c> sbList = new List<ASI_MFM_Sub_brand__c>();
        for (Integer i = 0; i < 2; i++) {
          sbList.add(sbGen.generateSubBrand(brand));
        }
        insert sbList;
        Account ws = acctGen.generateAccount(ASI_HK_CRM_AccountGenerator.RT_JDE_CREDIT);
        insert ws;
        List<ASI_HK_CRM_Promotion_Detail__c> pmtDetailList = pmtGen.generatePromotionDetails(pmtList.get(0), sbList, new List<Account>{ws});
        insert pmtDetailList;
        
        Test.startTest();
        
        // Initialize page and controller
        PageReference testPage = Page.ASI_CRM_SG_PromotionCalendarYearPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put(ASI_CRM_SG_PromotionCalendarYearCON.URL_PARAM_YEAR, String.valueOf(todayDate.year()));
        pageParams.put(ASI_CRM_SG_PromotionCalendarYearCON.URL_PARAM_MONTH, String.valueOf(todayDate.month() - 1));
        Test.setCurrentPageReference(testPage);
        ASI_CRM_SG_PromotionCalendarYearCON testController = new ASI_CRM_SG_PromotionCalendarYearCON();
        PageReference initRedirectPage = testController.initPage();
        System.assertEquals(null, initRedirectPage);
        
        // Validate display promotions
      //System.assertEquals(sbList.size() + (pmtList.size() > 1 ? 1 : 0), testController.eventGroups.size());
      //System.assertEquals(pmtList.size() + sbList.size() - 1, testController.eventList.size());
      
      // Redirect to month view calendar
      testController.selectedCalendarType = ASI_CRM_SG_PromotionCalendarCommonClass.CALENDAR_TYPE_MONTH;
      PageReference anotherCalendarPage = testController.redirectToAnotherCalendarType();
      testController.getFilters();
      testController.FilterPickListValue = 'Outlet Subtype';
      testController.initPage();
      testController.reloadData();
      testController.eventGroups.sort();
      //ASI_CRM_SG_PromotionYearGroup pyg = new ASI_CRM_SG_PromotionYearGroup(groupName  = 'Test', height  = 12,heightInt =12);
      ASI_CRM_SG_PromotionYearGroup empW = new ASI_CRM_SG_PromotionYearGroup('Test Channel');  //Covering inner/wrapper class
      empW.compareTo(empW);  
      //System.assertEquals(Page.ASI_CRM_SG_PromotionCalendarMonthPage.getUrl(), anotherCalendarPage.getUrl());
        
      Test.stopTest();
    }
    
}