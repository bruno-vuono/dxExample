@isTest
public class ASI_KOR_VisitationConfirm_Test{
    
    public static testMethod void test_main() {
        
        userrole Role_Test= new userrole(Name='XXXTrade Marketing',developerName='test');
        insert Role_Test;
        
        user u = [select userRole.developerName, ASI_MFM_Country__c,UserRoleid,CompanyName,ASI_KOR_User_Branch_Code__c from user where id = :userInfo.getUserId() limit 1]; 
        u.UserRoleid =Role_Test.id;
        u.CompanyName = 'Pernod Ricard Korea';
        u.ASI_KOR_User_Branch_Code__c='530';
        u.ASI_MFM_Country__c  = 'KR';
        update u;
        
        System.runAs(u){ 
            
            ASI_KOR_AccountGenerator acctGen = new ASI_KOR_AccountGenerator();
            ASI_KOR_VisitationPlanGenerator visitGen = new ASI_KOR_VisitationPlanGenerator();
            
            final Integer numOfAcct = 3;
            List<Account> acctList = new List<Account>();
            for (Integer i = 0; i < numOfAcct; i++) {
                acctList.add(acctGen.generateAccount(ASI_KOR_AccountGenerator.RT_WS));
            }
            insert acctList;
            // Initialize Visitation Plan changed by Elufa support 20160629
            //ASI_KOR_Visitation_Plan__c visit = visitGen.generateVisitationPlan();
            //insert visit;
            date systoday= system.today();
            Map<Integer, string> MonthMap = new Map<Integer, string>{ 1 => 'January',2 => 'February',3 => 'March',4 => 'April',5 => 'May',6 => 'June',7 => 'July', 8 => 'August',9 => 'September',10 => 'October',11 => 'November',12 => 'December'};
                
                List<ASI_KOR_Visitation_Plan__c> vpList= new List<ASI_KOR_Visitation_Plan__c>();
            ASI_KOR_Visitation_Plan__c visit = visitGen.generateVisitationPlan();
            vpList.add(visit);
            ASI_KOR_Visitation_Plan__c vp1= new ASI_KOR_Visitation_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan__cASI_CRM_KR_Visitation_Plan'),ASI_KOR_Month__c=MonthMap.get(systoday.month()),ASI_KOR_Year__c=String.valueOf(systoday.year()-1),Name = 'Default Plan for Mobile App');
            vpList.add(vp1);
            
            insert vpList;
            // Changed by Elufa support 20160629 end
            
            
            
            
            visit = [SELECT Id, Name, ASI_KOR_Year__c, ASI_KOR_Month__c, ASI_KOR_Confirmed__c FROM ASI_KOR_Visitation_Plan__c WHERE Id = :visit.Id];
            Integer visitYear = Integer.valueOf(visit.ASI_KOR_Year__c);
            Integer visitMonth = ASI_KOR_VisitationPlanGenerator.convertMonthPLValueToInteger(visit.ASI_KOR_Month__c);
            
            List<ASI_KOR_Visitation_Plan_Detail__c> visitDetails = new List<ASI_KOR_Visitation_Plan_Detail__c>();
            Integer countDay = 1;
            for (Account acct : acctList) {
                Date visitDate = Date.newInstance(visitYear, visitMonth, countDay);
                ASI_KOR_Visitation_Plan_Detail__c visitDetail = visitGen.generateVisitationPlanDetail(visit, acct, visitDate);
                visitDetails.add(visitDetail);
                countDay++;
            }
            insert visitDetails;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(visit);
            
            Test.startTest();
            
            PageReference testPage = Page.ASI_KOR_VisitationConfirmPage;
            Test.setCurrentPageReference(testPage);
            ASI_KOR_VisitationConfirmController testCon = new ASI_KOR_VisitationConfirmController(stdController);
            
            PageReference initRedirectPage = testCon.initPage();
            System.assertEquals('/' + visit.Id, initRedirectPage.getUrl());
            
            // Test error
            visit = [SELECT Id, Name, ASI_KOR_Year__c, ASI_KOR_Month__c, ASI_KOR_Confirmed__c FROM ASI_KOR_Visitation_Plan__c WHERE Id = :visit.Id];
            stdController = new ApexPages.StandardController(visit);
            testCon = new ASI_KOR_VisitationConfirmController(stdController);
            
            initRedirectPage = testCon.initPage();
            System.assertEquals(null, initRedirectPage);
            
            visit = [SELECT Id, Name, ASI_KOR_Year__c, ASI_KOR_Month__c, ASI_KOR_Confirmed__c FROM ASI_KOR_Visitation_Plan__c WHERE Id = :visit.Id];
            System.assertEquals(true, visit.ASI_KOR_Confirmed__c);
            
            List<Event> visitEvents = [SELECT Id FROM Event WHERE WhatId IN :acctList];
            System.assertEquals(visitDetails.size(), visitEvents.size());
            
            Test.stopTest();
            
        }
    }
    
}