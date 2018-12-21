@isTest
public class ASI_TnE_KR_TestClass {
    
    private static ASI_eForm_HR_MDM__c tempMDM = new ASI_eForm_HR_MDM__c(Name='1234567', ASI_eForm_MDM_Department__c='tempHR',ASI_eForm_Employee_Company_Code__c = '222', 
                                                                         ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='none', ASI_eForm_Employee_Bank_Account_Code__c='none', 
                                                                         ASI_eForm_Employee_Bank_Name__c='none', ASI_eForm_Employee_Branch_Code__c='300-Management', ASI_eForm_Employee_Is_Salesman__c=True, ASI_eForm_Employee_Gender__c='M', 
                                                                         ASI_eForm_Employee_Work_Email__c='123.345@email.com', ASI_eForm_Employee_Eligible_PD__c = true,
                                                                         recordTypeId = Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM'));
    
    private static ASI_eForm_HR_MDM__c tempMDM2 = new ASI_eForm_HR_MDM__c(Name='0000000', ASI_eForm_MDM_Department__c='tempHR',ASI_eForm_Employee_Company_Code__c = '222', 
                                                                          ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='none', ASI_eForm_Employee_Bank_Account_Code__c='none', 
                                                                          ASI_eForm_Employee_Bank_Name__c='none', ASI_eForm_Employee_Branch_Code__c='300-Management', ASI_eForm_Employee_Is_Salesman__c=True, ASI_eForm_Employee_Gender__c='M', 
                                                                          ASI_eForm_Employee_Work_Email__c='123.345@email.com', ASI_eForm_Employee_Eligible_PD__c = true,
                                                                          recordTypeId = Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM'));
    
    private static Profile tempP = [SELECT Id FROM Profile WHERE Name='Standard User'];
    
    Private static User tempU = [select id, Name, ASI_KOR_Commission_Code__c, ProfileId from user where id = :userInfo.getUserId()];
    
    private static User tempU2 = new User(Alias = '666', Email='standarduser666@testorg.com', EmailEncodingKey='UTF-8', FirstName='Testing', LastName='666', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = tempP.Id, TimeZoneSidKey='Asia/Hong_Kong', UserName='standarduser666@testorg.com', ASI_KOR_Commission_Code__c='1234567', ManagerId = tempU.id,
                                          CompanyName = 'testUserCompanyName', Country = 'Korea');
    
    private static User tempU3 = new User(Alias = '662', Email='standarduser6662@testorg.com', EmailEncodingKey='UTF-8', FirstName='Testing2', LastName='667', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = tempP.Id, TimeZoneSidKey='Asia/Hong_Kong', UserName='standarduser667@testorg.com', ASI_KOR_Commission_Code__c='0000000', ManagerId = tempU.id,
                                          CompanyName = 'testUserCompanyName', Country = 'Korea');
    private static String fiscalYear;
    static testMethod void testTriggerClass(){
        
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        String fiscalYear1  = ASI_TnE_KR_TestClassHelper.createFY();
        List<ASI_TnE_Employee_Budget__c> tempBudgets = ASI_TnE_KR_TestClassHelper.createBudgetRecords(tempUsers,fiscalYear1); //budget list
        List<ASI_MFM_Exchange_Rate__c> tempExRates = ASI_TnE_KR_TestClassHelper.createExRateRecords(fiscalYear1); //exchange rate list
        List<ASI_TnE_Branch_Channel__c> tempBraChas = ASI_TnE_KR_TestClassHelper.createBraChannelRecords(); //branch channel list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createHeaderTriggerTestRecord(tempUsers); //claim header list
        //List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createDetailTriggerTestRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers,tempUsers); //claim detail list
        Test.startTest();
        tempHeaders[0].ASI_TnE_Status__c = tempHeaders[1].ASI_TnE_Status__c = tempHeaders[2].ASI_TnE_Status__c = 'Submitted';
        tempHeaders[3].ASI_TnE_Status__c = 'Pending for A&P Submitted';
        update tempHeaders;
        //update tempDetails;
        ASI_TnE_ClaimHeader__c tempHeader5 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111',
                                       ASI_TnE_KR_LookupTnE__c = tempHeaders[3].Id);
        insert tempHeader5;
        tempHeader5.ASI_TnE_Status__c = 'Submitted';
        update tempHeader5;
        //delete tempDetails;
        delete tempHeaders;
        Test.stopTest();
    }//end method: test Trigger
    
    static testMethod void testTriggerClass2(){
        
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        String fiscalYear1  = ASI_TnE_KR_TestClassHelper.createFY();
        List<ASI_TnE_Employee_Budget__c> tempBudgets = ASI_TnE_KR_TestClassHelper.createBudgetRecords(tempUsers,fiscalYear1); //budget list
        List<ASI_MFM_Exchange_Rate__c> tempExRates = ASI_TnE_KR_TestClassHelper.createExRateRecords(fiscalYear1); //exchange rate list
        List<ASI_TnE_Branch_Channel__c> tempBraChas = ASI_TnE_KR_TestClassHelper.createBraChannelRecords(); //branch channel list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createHeaderTriggerTestRecord(tempUsers); //claim header list
        List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createDetailTriggerTestRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers,tempUsers); //claim detail list
        Test.startTest();
        //tempHeaders[0].ASI_TnE_Status__c = tempHeaders[1].ASI_TnE_Status__c = tempHeaders[2].ASI_TnE_Status__c = 'Submitted';
        //tempHeaders[3].ASI_TnE_Status__c = 'Pending for A&P Submitted';
        //update tempHeaders;
        update tempDetails;
        //ASI_TnE_ClaimHeader__c tempHeader5 = 
        //    new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
        //                               OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
        //                               ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
        //                               ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
        //                               ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
        //                               ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111',
        //                               ASI_TnE_KR_LookupTnE__c = tempHeaders[3].Id);
        //insert tempHeader5;
        //tempHeader5.ASI_TnE_Status__c = 'Submitted';
        //update tempHeader5;
        //delete tempDetails;
        //delete tempHeaders;
        Test.stopTest();
    }//end method: test Trigger
    
    static testMethod void testTriggerClass3(){
        
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        String fiscalYear1  = ASI_TnE_KR_TestClassHelper.createFY();
        List<ASI_TnE_Employee_Budget__c> tempBudgets = ASI_TnE_KR_TestClassHelper.createBudgetRecords(tempUsers,fiscalYear1); //budget list
        List<ASI_MFM_Exchange_Rate__c> tempExRates = ASI_TnE_KR_TestClassHelper.createExRateRecords(fiscalYear1); //exchange rate list
        List<ASI_TnE_Branch_Channel__c> tempBraChas = ASI_TnE_KR_TestClassHelper.createBraChannelRecords(); //branch channel list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createHeaderTriggerTestRecord(tempUsers); //claim header list
        List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createDetailTriggerTestRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers,tempUsers); //claim detail list
        
        // Added by 2017-09-27  Linus@introv
        List<ASI_TnE_ClaimHeader__c> tempHeaders1 = new List<ASI_TnE_ClaimHeader__c>();
        List<ASI_TnE_ClaimDetail__c> tempDetails1 = new List<ASI_TnE_ClaimDetail__c>();
        ASI_TnE_ClaimHeader__c tempHeader1 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111',
                                       ASI_TnE_KR_LookupTnE__c = tempHeaders[3].Id);
        ASI_TnE_ClaimHeader__c tempHeader2 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111',
                                       ASI_TnE_KR_LookupTnE__c = tempHeaders[3].Id);
        ASI_TnE_ClaimHeader__c tempHeader3 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_Cash'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111',
                                       ASI_TnE_KR_LookupTnE__c = tempHeaders[3].Id);
        tempHeaders1.add(tempHeader1);
        tempHeaders1.add(tempHeader2);
        tempHeaders1.add(tempHeader3);
        insert tempHeaders1;
        
        ASI_TnE_ClaimDetail__c tempDetail1 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeader1.id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25
                                      );
        ASI_TnE_ClaimDetail__c tempDetail2 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeader2.id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25
                                      );
        ASI_TnE_ClaimDetail__c tempDetail3 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeader3.id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25
                                      );
        tempDetails1.add(tempDetail1);
        tempDetails1.add(tempDetail2);
        tempDetails1.add(tempDetail3);
        insert tempDetails1;
        
        
        Test.startTest();        
        update tempDetails;
        
        // Added by 2017-09-27  Linus@introv
        tempHeaders1[0].ASI_TnE_Status__c = tempHeaders1[1].ASI_TnE_Status__c = tempHeaders1[2].ASI_TnE_Status__c = 'Submitted';
        update tempHeaders1;
        
        Test.stopTest();
    }//end method: test Trigger
    
    static testMethod void testPDFController(){
        
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        String fiscalYear1  = ASI_TnE_KR_TestClassHelper.createFY();
        List<ASI_TnE_Employee_Budget__c> tempBudgets = ASI_TnE_KR_TestClassHelper.createBudgetRecords(tempUsers,fiscalYear1); //budget list
        List<ASI_MFM_Exchange_Rate__c> tempExRates = ASI_TnE_KR_TestClassHelper.createExRateRecords(fiscalYear1); //exchange rate list
        List<ASI_TnE_Branch_Channel__c> tempBraChas = ASI_TnE_KR_TestClassHelper.createBraChannelRecords(); //branch channel list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createGeneralHeaderRecord(tempUsers); //claim header list
        List<ASI_GnH_Request__c> gnhRequestList = ASI_TnE_KR_TestClassHelper.createGnHRequest(tempUsers);
        List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createGeneralDetailRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers,tempUsers,gnhRequestList); //claim detail list
        List<ASI_KR_Schd_Setting__c> schdSettings = new List<ASI_KR_Schd_Setting__c>();
        schdSettings.add(new ASI_KR_Schd_Setting__c(Name ='For AnP Reminder',ASI_KR_isActivate__c=True,ASI_KR_numOfDays1__c=0,ASI_KR_numOfDays2__c=0,ASI_KR_schdClass__c='ASI_TnE_KR_AnPSchd'));
        schdSettings.add(new ASI_KR_Schd_Setting__c(Name ='For TnE Reminder',ASI_KR_isActivate__c=True,ASI_KR_numOfDays1__c=0,ASI_KR_numOfDays2__c=0,ASI_KR_schdClass__c='ASI_TnE_KR_TnESchd'));
        insert schdSettings;
        
        Test.startTest();
        //------------------------AnP PDF----------------------------//
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(tempHeaders[1].Id);
        req1.setNextApproverIds(new Id[] {tempUsers[1].id});
        req1.setSubmitterID(tempUsers[3].id);
        req1.setSkipEntryCriteria(true);
        req1.setProcessDefinitionNameOrId('ASI_TnE_KR_AnP_Approval_Process_v5');
        //Approval.process(req1);// !!No Approval Process Found
        
        ASI_TnE_KR_AnPSchd schdJobAnP = new ASI_TnE_KR_AnPSchd();
        String sch = '0 0 23 * * ?';
        System.schedule('Test AnP', sch, schdJobAnP);
        
        Test.setCurrentPage(Page.ASI_TnE_KR_Print_PDF_AnP);
        Apexpages.currentPage().getParameters().put('id', tempHeaders[1].id);
        Apexpages.standardController sc1 = new apexpages.standardController(tempHeaders[1]);
        ASI_TnE_KR_ClaimHeaderPDFController cx1 = new ASI_TnE_KR_ClaimHeaderPDFController(sc1);
        cx1.currentHeaderId = tempHeaders[1].id;
        cx1.getCurrentUser();
        cx1.getAmount();
        cx1.getAggregatedCategoryExpenses();
        cx1.getNumberOfDays();
        ASI_eForm_HR_MDM__c mdm1 = cx1.getBankInfo();
        //------------------------AnP PDF----------------------------//
        
        //------------------------TnE PDF----------------------------//
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('Submitting request for approval.');
        req2.setObjectId(tempHeaders[2].Id);
        req2.setNextApproverIds(new Id[] {tempUsers[1].id});
        req2.setSubmitterID(tempUsers[3].id);
        req2.setSkipEntryCriteria(true);
        req2.setProcessDefinitionNameOrId('ASI_TnE_KR_TnE_Approval_Process_v6');
        //Approval.process(req2); //20180504 Introv Commented
        
        ASI_TnE_KR_TnESchd schdJobTnE = new ASI_TnE_KR_TnESchd();
        System.schedule('Test Tne', sch, schdJobTnE);
        
        Test.setCurrentPage(Page.ASI_TnE_KR_Print_PDF_TnE);
        Apexpages.currentPage().getParameters().put('id', tempHeaders[2].id);
        Apexpages.standardController sc2 = new apexpages.standardController(tempHeaders[2]);
        ASI_TnE_KR_ClaimHeaderPDFController cx2 = new ASI_TnE_KR_ClaimHeaderPDFController(sc2);
        cx2.currentHeaderId = tempHeaders[2].id;
        cx2.getCurrentUser();
        cx2.getAmount();
        cx2.getAggregatedCategoryExpenses();
        cx2.getNumberOfDays();
        ASI_eForm_HR_MDM__c mdm2 = cx2.getBankInfo();
        //------------------------TnE PDF----------------------------//
        Test.stopTest();
    }//end method: test PDF controller
    
    static testMethod void testGenBatch(){
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        String fiscalYear1  = ASI_TnE_KR_TestClassHelper.createFY();
        List<ASI_TnE_Employee_Budget__c> tempBudgets = ASI_TnE_KR_TestClassHelper.createBudgetRecords(tempUsers,fiscalYear1); //budget list
        List<ASI_MFM_Exchange_Rate__c> tempExRates = ASI_TnE_KR_TestClassHelper.createExRateRecords(fiscalYear1); //exchange rate list
        List<ASI_TnE_Branch_Channel__c> tempBraChas = ASI_TnE_KR_TestClassHelper.createBraChannelRecords(); //branch channel list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createGeneralHeaderRecord(tempUsers); //claim header list
        List<ASI_GnH_Request__c> gnhRequestList = ASI_TnE_KR_TestClassHelper.createGnHRequest(tempUsers);
        List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createGeneralDetailRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers,tempUsers,gnhRequestList); //claim detail list
        List<ASI_TnE_Corp_Card_Employee_Mapping__c> tempCardMaps = ASI_TnE_KR_TestClassHelper.createCardMapRecords(tempUsers);
        List<ASI_TnE_Corp_Card_Statement_Upload__c> tempInTrays = ASI_TnE_KR_TestClassHelper.createInTrayRecords(Date.Today(),tempUsers); 
        Test.startTest();
        ASI_TnE_Mass_Upload_Log__c log = new ASI_TnE_Mass_Upload_Log__c();
        insert log;
        Database.executebatch(new ASI_TnE_KR_MassGenBatch(log));
        Test.stopTest();
    }//end method: test GenBatch
    
    static testMethod void testUploadController(){
        
        
        tempU.country='korea';
        update tempU;
        
        insert tempU2;
        insert tempMDM;
        
        ASI_TnE_ClaimHeader__c tempTnE = new ASI_TnE_ClaimHeader__c(OwnerID = tempU2.id,
                                                                    recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                                                    ASI_TnE_KR_Payee__c = tempU2.id,
                                                                    ASI_TnE_Status__c = 'Final',
                                                                    ASI_TnE_Date__c = date.today(),
                                                                    ASI_TnE_KR_Year__c = '2015',
                                                                    ASI_TnE_KR_Month__c = '6',
                                                                    ASI_TnE_KR_Credit_Card_No__c = '123456',
                                                                    ASI_TnE_KR_External_ID__c = '123456~2015',
                                                                    ASI_TnE_KR_Additional_Approver_1__c = tempU3.id,
                                                                    ASI_TnE_KR_Additional_Approver_2__c = tempU3.id,
                                                                    ASI_TnE_KR_Additional_Approver_3__c = tempU3.id,
                                                                    ASI_TnE_KR_Additional_Approver_4__c = tempU3.id,
                                                                    ASI_TnE_KR_Additional_Approver_5__c = tempU3.id,
                                                                    ASI_TnE_KR_Budget_Owner_1__c = tempU3.id,
                                                                    ASI_TnE_KR_Budget_Owner_2__c = tempU3.id,
                                                                    ASI_TnE_KR_Budget_Owner_3__c = tempU3.id,
                                                                    ASI_TnE_KR_Budget_Owner_4__c = tempU3.id,
                                                                    ASI_TnE_KR_Budget_Owner_5__c = tempU3.id,
                                                                    ASI_TnE_KR_CoApprover_1__c = tempU3.id,
                                                                    ASI_TnE_KR_CoApprover_2__c = tempU3.id,
                                                                    ASI_TnE_KR_CoApprover_3__c = tempU3.id,
                                                                    ASI_TnE_KR_CoApprover_4__c = tempU3.id,
                                                                    ASI_TnE_KR_CoApprover_5__c = tempU3.id
                                                                   );
        insert tempTnE;
        
        List<ASI_TnE_Corp_Card_Employee_Mapping__c> tmpCorpCardMapping = new List<ASI_TnE_Corp_Card_Employee_Mapping__c>();
        
        tmpCorpCardMapping.add(new ASI_TnE_Corp_Card_Employee_Mapping__c(ASI_TnE_Assistant_Name__c = tempU2.id,
                                                                         ASI_TnE_Card_Number_1__c = '1111-****-1111-1111',
                                                                         ASI_TnE_Employee_Name__c = tempU2.id,
                                                                         ASI_TnE_KR_Card_Type__c = 'A&P Card',
                                                                         recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Employee_Mapping__cTnE_KR_Corp_Card_Employee_Mapping')));
        tmpCorpCardMapping.add(new ASI_TnE_Corp_Card_Employee_Mapping__c(ASI_TnE_Assistant_Name__c = tempU2.id,
                                                                         ASI_TnE_Card_Number_1__c = '3333-****-3333-3333',
                                                                         ASI_TnE_Employee_Name__c = tempU2.id,
                                                                         ASI_TnE_KR_Card_Type__c = 'T&E Card',
                                                                         recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Employee_Mapping__cTnE_KR_Corp_Card_Employee_Mapping')));
        
        insert tmpCorpCardMapping;
        
        List<ASI_TnE_Corp_Card_Statement_Upload__c> tmpInTrayObj = new List<ASI_TnE_Corp_Card_Statement_Upload__c>(); 
        
        tmpInTrayObj.add(new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempU.Id
                                                                   , ASI_TnE_Card_Number__c = '1111-****-1111-1111'
                                                                   , recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                                   ASI_TnE_KR_Year__c = '2015',
                                                                   ASI_TnE_KR_Month__c = '6',
                                                                   ASI_TnE_Charge_Date__c = Date.newInstance(2015,6,12),
                                                                   ASI_TnE_Charge_Time__c = '150149',
                                                                   ASI_TnE_KR_Approval_Number__c = '46249566',
                                                                   ASI_TnE_Full_Name__c = 'Test',
                                                                   ASI_TnE_Amount__c = 100
                                                                  ));
        
        tmpInTrayObj.add(new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempU.Id
                                                                   , ASI_TnE_Card_Number__c = '2222-****-2222-2222'
                                                                   , recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload')
                                                                  ));
        
        tmpInTrayObj.add(new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempU.Id
                                                                   , ASI_TnE_Card_Number__c = '3333-****-3333-3333'
                                                                   , recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                                   ASI_TnE_KR_Year__c = '2015',
                                                                   ASI_TnE_KR_Month__c = '6',
                                                                   ASI_TnE_Charge_Date__c = Date.newInstance(2015,6,13),
                                                                   ASI_TnE_Charge_Time__c = '205316',
                                                                   ASI_TnE_KR_Approval_Number__c = '46249568',
                                                                   ASI_TnE_Full_Name__c = 'Test',
                                                                   ASI_TnE_Amount__c = 200
                                                                  ));
        
        ASI_TnE_Branch_Channel__c tmpBC = new ASI_TnE_Branch_Channel__c(OwnerID = tempU.id
                                                                        , Name = 'abc'
                                                                        , ASI_TnE_Branch_Channel_Desc__c = '1234'
                                                                        , ASI_TnE_Branch_Default__c = false
                                                                       ); 
        insert tmpBC;
        
        test.startTest();
        
        insert tmpInTrayObj[0];
        insert tmpInTrayObj[2];
        
        ASI_TnE_KR_UploadController tmpClass = new ASI_TnE_KR_UploadController();
        
        String[] myArray = new List<String>();
        
        tmpClass.ObjAPIName = 'ASI_TnE_Corp_Card_Statement_Upload__c';
        tmpClass.fields = 'ASI_TnE_Transaction_Description__c,ASI_TnE_Bill_Year__c,ASI_TnE_KR_Month__c,ASI_TnE_Card_Number__c,ASI_TnE_Charge_Date__c,ASI_TnE_Charge_Time__c,ASI_TnE_KR_Approval_Number__c,ASI_TnE_Full_Name__c,ASI_TnE_Amount__c';
        tmpClass.fieldsLabel = 'Not Use,Year,Month,Card No,Transaction Date,Transaction Time,Transaction No,Business Name,Transaction Amount';
        tmpClass.template = 'ASI_TnE_KR_Proxy_Driving_Header_Template';
        tmpClass.parentObjectAPIName = 'ASI_TnE_Mass_Upload_Log__c';
        tmpClass.ParentObjectUploadMsg = 'ASI_TnE_Error_Message__c';
        tmpClass.recEXID = 'Id';
        tmpClass.recEXIDcol = 'Id';
        tmpClass.upsertMode = true;
        tmpClass.batchMode = true;
        tmpClass.report = '';
        tmpClass.lookupEXID = 'ASI_TnE_ClaimHeader__c/ASI_TnE_ClaimHeader__c:External ID&ASI_TnE_KR_External_ID__c';
        tmpClass.DefaultValues = 'ASI_TnE_KR_Year__c:2015';
        tmpClass.opt_allOrNone = true;
        tmpClass.currentPageURL = '';
        tmpClass.inlineVF = true;
        tmpClass.emailNotification = true;
        tmpClass.namefile = '2015-05-05.csv';
        tmpClass.filesize = 2000;
        tmpClass.contentFile = blob.valueOf('Not Use,Year,Month,Card No,Transaction Date,Transaction Time,Transaction No,Business Name,Transaction Amount\rtest,2015,05,1111-****-1111-1111,2015-04-21,18888688,20:00:00,test,10000');
        
        tmpClass.uploadCSVByBatch();
        for(String a : tmpClass.StatusMsgs)
        {
            myArray.add(a);
        }
        tmpClass.generateTnERecords2();
        for(String a : tmpClass.GenStatusMsgs)
        {
            myArray.add(a);
        }
        tmpClass.deleteCorpCardStatements();
        tmpClass.refreshPage2();
        tmpClass.getItems();
        
        insert tmpIntrayObj[1];
        tmpClass.generateTnERecords2();
        
        tmpClass.contentFile = blob.valueOf('Not Use,Year,Month,Card No,Transaction Date,Transaction Time,Transaction No,Business Name,Transaction Amount\r');
        tmpClass.uploadCSVByBatch();
        
        tmpClass.contentFile = blob.valueOf('Not Use,Year,Month,Card No,Transaction Date,Transaction Time,Transaction No,Business Name,Transaction Amount\rtest,201111111115,05,1111-****-1111-1111,2015-04-21,18888688,20:00:00,test,10000');
        tmpClass.uploadCSVByBatch();
        
        //tmpClass.lookupEXID = 'ASI_TnE_ClaimHeader__c/ASI_TnE_ClaimHeader__c:External ID&ASI_TnE_KR_External_ID__c';
        //tmpClass.uploadCSVByBatch();
        
        tmpClass.fields = 'ASI_TnE_Bill_Year__c,ASI_TnE_KR_Month__c,ASI_TnE_Card_Number__c,ASI_TnE_Charge_Date__c,ASI_TnE_Charge_Time__c,ASI_TnE_KR_Approval_Number__c,ASI_TnE_Full_Name__c,ASI_TnE_Amount__c';
        tmpClass.uploadCSVByBatch();
        
        tmpClass.ObjAPIName = 'ASI_TnE_ClaimDetail__c';
        tmpClass.lookupEXID = 'ASI_TnE_Branch_Channel__c/ASI_TnE_Branch_code_Channel__c:Branch-Channel Code&Name';
        tmpClass.fields = 'ASI_TnE_Dispute__c,ASI_TnE_Branch_code_Channel__c';
        tmpClass.fieldsLabel = 'Year,BC';
        tmpClass.contentFile = blob.valueOf('Year,BC\ry,abc');
        tmpClass.uploadCSVByBatch();
        
        test.stopTest();
    }
    
    static testMethod void testFormateController(){
        ASI_TnE_Formatted_Datetime_Controller tempCtrl = new ASI_TnE_Formatted_Datetime_Controller();
        ASI_TnE_Formatted_Datetime_Controller tempCtrl1 = new ASI_TnE_Formatted_Datetime_Controller();
        ASI_TnE_Formatted_Datetime_Controller tempCtrl2 = new ASI_TnE_Formatted_Datetime_Controller();
        tempCtrl.date_time = DateTime.newInstance(2015,7,8);
        tempCtrl2.date_time = tempCtrl.date_time;
        tempCtrl2.defined_format = '/';
        String newdt = tempCtrl.getFormattedDatetime();
        String newdt1 = tempCtrl1.getFormattedDatetime();
        String newdt2 = tempCtrl2.getFormattedDatetime();
        
    }
}