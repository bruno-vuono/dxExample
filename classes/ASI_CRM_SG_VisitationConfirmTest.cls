@isTest
public with sharing class ASI_CRM_SG_VisitationConfirmTest {
    
    
    public static testMethod void test_main() {
        ASI_HK_CRM_AccountGenerator acctGen = new ASI_HK_CRM_AccountGenerator();
        ASI_HK_CRM_VisitationPlanGenerator visitGen = new ASI_HK_CRM_VisitationPlanGenerator();
        ASI_CRM_SG_VisitationPlanDetailGenerator visitDetailGen = new ASI_CRM_SG_VisitationPlanDetailGenerator();
        
        final Integer numOfAcct = 3;
        List<Account> acctList = new List<Account>();
        for (Integer i = 0; i < numOfAcct; i++) {
          acctList.add(acctGen.generateAccount(ASI_HK_CRM_AccountGenerator.RT_JDE_CREDIT));
        }
        List<ASI_CRM_AccountsAdditionalField__c> customers= new List<ASI_CRM_AccountsAdditionalField__c>();
        if(acctList.size()>0){
            customers = ASI_CRM_SG_TestDummyData.generateCustomers(acctList.size(),acctList,true,'ASI_CRM_SG_Outlet','ASI_CRM_AccountsAdditionalField__c');
        }

        ASI_HK_CRM_Visitation_Plan__c visit = visitGen.generateVisitationPlan();
        insert visit;
        visit = [SELECT Id, Name, ASI_HK_CRM_Year__c, ASI_HK_CRM_Month__c, ASI_HK_CRM_Confirmed__c FROM ASI_HK_CRM_Visitation_Plan__c WHERE Id = :visit.Id];
        Integer visitYear = Integer.valueOf(visit.ASI_HK_CRM_Year__c);
        Integer visitMonth = ASI_HK_CRM_VisitationPlanGenerator.convertMonthPLValueToInteger(visit.ASI_HK_CRM_Month__c);
        
        List<ASI_HK_CRM_Visitation_Plan_Detail__c> visitDetails = new List<ASI_HK_CRM_Visitation_Plan_Detail__c>();
        Integer countDay = 1;
        for (ASI_CRM_AccountsAdditionalField__c cus : customers) {
          Date visitDate = Date.newInstance(visitYear, visitMonth, countDay);
          ASI_HK_CRM_Visitation_Plan_Detail__c visitDetail = visitDetailGen.generateVisitationPlanDetail(visit, cus, visitDate);
          visitDetails.add(visitDetail);
          countDay++;
        }
        insert visitDetails;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(visit);
        
        Test.startTest();
        
        PageReference testPage = Page.ASI_CRM_SG_VisitationConfirmPage;
        Test.setCurrentPageReference(testPage);
        ASI_CRM_SG_VisitationConfirmController testCon = new ASI_CRM_SG_VisitationConfirmController(stdController);
        
        PageReference initRedirectPage = testCon.initPage();
        System.assertEquals('/' + visit.Id, initRedirectPage.getUrl());
        
        // Test error
        visit = [SELECT Id, Name, ASI_HK_CRM_Year__c, ASI_HK_CRM_Month__c, ASI_HK_CRM_Confirmed__c FROM ASI_HK_CRM_Visitation_Plan__c WHERE Id = :visit.Id];
        stdController = new ApexPages.StandardController(visit);
        testCon = new ASI_CRM_SG_VisitationConfirmController(stdController);
        
        initRedirectPage = testCon.initPage();
        System.assertEquals(null, initRedirectPage);
        
        visit = [SELECT Id, Name, ASI_HK_CRM_Year__c, ASI_HK_CRM_Month__c, ASI_HK_CRM_Confirmed__c FROM ASI_HK_CRM_Visitation_Plan__c WHERE Id = :visit.Id];
        System.assertEquals(true, visit.ASI_HK_CRM_Confirmed__c);
        
        List<Event> visitEvents = [SELECT Id FROM Event WHERE WhatId IN :customers];
        System.assertEquals(visitDetails.size(), visitEvents.size());
        
        Test.stopTest();
    }
}