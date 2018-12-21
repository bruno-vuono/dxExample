@isTest
public class ASI_eForm_KR_MassCreateNUpdateCtrlTest
{
    static testMethod void testMassUpdateController()
    {
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        String fiscalYear  = ASI_TnE_KR_TestClassHelper.createFY();
        List<ASI_TnE_Employee_Budget__c> tempBudgets = ASI_TnE_KR_TestClassHelper.createBudgetRecords(tempUsers,fiscalYear); //budget list
        List<ASI_MFM_Exchange_Rate__c> tempExRates = ASI_TnE_KR_TestClassHelper.createExRateRecords(fiscalYear); //exchange rate list
        List<ASI_TnE_Branch_Channel__c> tempBraChas = ASI_TnE_KR_TestClassHelper.createBraChannelRecords(); //branch channel list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createMassCreateNUpdateHeaderTestRecord(tempUsers); //claim header list
        List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createMassCreateNUpdateDetailTestRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers); //claim detail list
        
        
        //-----------end add data---------------------//
        test.startTest();
        ApexPages.StandardController standardController1 = new ApexPages.StandardController(tempHeaders[0]);
        ApexPages.StandardController standardController2 = new ApexPages.StandardController(tempHeaders[1]);
        ApexPages.StandardController standardController3 = new ApexPages.StandardController(tempHeaders[2]);
        ApexPages.StandardController standardController4 = new ApexPages.StandardController(tempHeaders[3]);
        //----------------------------------------------------------------------------------------------------------------------------------//
        PageReference claimDetailPage1 = Page.ASI_TnE_KR_Manage_Claim_AnP;
        Map<String, String> pageParams1 = claimDetailPage1.getParameters();
        pageParams1.put('id', tempHeaders[0].Id);
        Test.setCurrentPageReference(claimDetailPage1);
        
        ASI_TnE_KR_ClaimHeaderController claimHeaderController1 = new ASI_TnE_KR_ClaimHeaderController(standardController1);
        
        ASI_TnE_ComponentInterface cController1;
        claimHeaderController1.dummyMethod();
        claimHeaderController1.getUserLanguage();
        claimHeaderController1.setComponentController(cController1);
        claimHeaderController1.getComponentController();
        claimHeaderController1.getComponentController('testKey');
        //----------------------------------------------------------------------------------------------------------------------------------//
        //----------------------------------------------------------------------------------------------------------------------------------//
        PageReference claimDetailPage2 = Page.ASI_TnE_KR_Manage_Claim_AnP;
        Map<String, String> pageParams2 = claimDetailPage2.getParameters();
        pageParams2.put('id', tempHeaders[1].Id);
        Test.setCurrentPageReference(claimDetailPage2);
        
        ASI_TnE_KR_ClaimHeaderController claimHeaderController2 = new ASI_TnE_KR_ClaimHeaderController(standardController2);
        
        ASI_TnE_ComponentInterface cController2;
        claimHeaderController2.dummyMethod();
        claimHeaderController2.getUserLanguage();
        claimHeaderController2.setComponentController(cController2);
        claimHeaderController2.getComponentController();
        claimHeaderController2.getComponentController('testKey');
        //----------------------------------------------------------------------------------------------------------------------------------//
        //----------------------------------------------------------------------------------------------------------------------------------//
        PageReference claimDetailPage3 = Page.ASI_TnE_KR_Manage_Claim_TnE;
        Map<String, String> pageParams3 = claimDetailPage3.getParameters();
        pageParams3.put('id', tempHeaders[2].Id);
        Test.setCurrentPageReference(claimDetailPage3);
        
        ASI_TnE_KR_ClaimHeaderController claimHeaderController3 = new ASI_TnE_KR_ClaimHeaderController(standardController3);
        
        ASI_TnE_ComponentInterface cController3;
        claimHeaderController3.dummyMethod();
        claimHeaderController3.getUserLanguage();
        claimHeaderController3.setComponentController(cController3);
        claimHeaderController3.getComponentController();
        claimHeaderController3.getComponentController('testKey');
        //----------------------------------------------------------------------------------------------------------------------------------//*/
        PageReference claimDetailPage4 = Page.ASI_TnE_KR_Manage_Claim_TnE;
        Map<String, String> pageParams4 = claimDetailPage4.getParameters();
        pageParams4.put('id', tempHeaders[3].Id);
        Test.setCurrentPageReference(claimDetailPage4);
        
        ASI_TnE_KR_ClaimHeaderController claimHeaderController4 = new ASI_TnE_KR_ClaimHeaderController(standardController4);
        
        ASI_TnE_ComponentInterface cController4;
        claimHeaderController4.dummyMethod();
        claimHeaderController4.getUserLanguage();
        claimHeaderController4.setComponentController(cController4);
        claimHeaderController4.getComponentController();
        claimHeaderController4.getComponentController('testKey');
        //----------------------------------------------------------------------------------------------------------------------------------//
        ASI_TnE_KR_MassCreateAndUpdateController mcauCon = new  ASI_TnE_KR_MassCreateAndUpdateController();  
        
        mcauCon.isFastModeBool = false;
        mcauCon.sObjTypeStr = 'ASI_TnE_ClaimDetail__c';
        mcauCon.displayFieldsStr = 'ASI_TnE_Receipt_Date__c&req=T&width=80px&read=a&ckey=a&skipClone=t&skipDelete=t&lang=t, ' +
        ' ASI_TnE_Expense_Category__c&req=T&width=120px, ' +
        ' ASI_TnE_Expense_Classification__c&req=T&width=150px, ' +                     
        ' ASI_TnE_Currency__c&req=T&width=60px, ' +
        ' ASI_TnE_Receipt_Amount__c&req=T&width=120px, ' +
        ' ASI_TnE_FX_Rate__c&width=60px, ' +
        ' ASI_TnE_Receipt_Number__c&width=30px, ' +                                
        ' ASI_TnE_Total_Number_Pax__c&req=T&width=30px, ' +
        ' ASI_TnE_Attendee_Name__c&req=T&width=150px, ' +
        ' ASI_TnE_Details_of_Expense__c&width=150px';
        mcauCon.fieldToURLParamStr = 'ASI_TnE_ClaimHeader__c=>id';
        mcauCon.whereStatm = 'ASI_TnE_ClaimHeader__c= \'' + tempHeaders[2].Id + '\'';
        mcauCon.orderByStr = 'Name';
        mcauCon.pageBlockTitleStr = 'Claim Header Items';
        mcauCon.successLink = '/' + tempHeaders[2].Id;
        mcauCon.cancelLink = '/' + tempHeaders[2].Id;
        mcauCon.mode = 'BOTH';
        mcauCon.isDefaultEditVal = true;
        mcauCon.showAllRT = false;
        mcauCon.isUseFirstRowForNew = true;
        mcauCon.includeRecordTypes='ASI_TnE_KR_Claim_Detail';
        mcauCon.componentKey = 'massCreateAndUpdate';
        mcauCon.PageController = claimHeaderController4.thisController;
        mcauCon.languageSupportedStr ='en_US';
        mcauCon.lookupToPicklist = 'ASI_TnE_Expense_Category__c,ASI_TnE_Expense_Classification__c.ASI_JP_TnE_Expense_Category__c=>ASI_TnE_Expense_Category__c';
        
        mcauCon.dummyMethod();
        mcauCon.defaultFieldValuesStr = 'ASI_TnE_Currency__c=KRW,ASI_TnE_Total_Number_Pax__c=1';
        String[] ints2 = new String[]{'1/1/2001', '1/1/2002', '1/1/2003'};
        mcauCon.checkDateTimeFieldSet = new Set<String>();
        mcauCon.initDateFields(ints2);
        ASI_TnE_KR_MassCreateAndUpdateController.DisplayField displayfieldTest = new ASI_TnE_KR_MassCreateAndUpdateController.DisplayField('dummyLabel', 'dummyName');
        ASI_TnE_KR_MassCreateAndUpdateController.DisplayField displayfieldTest2 = new ASI_TnE_KR_MassCreateAndUpdateController.DisplayField('dummyLabel', 'dummyName', false);
        ASI_TnE_KR_MassCreateAndUpdateController.PageBlockActionBtn testblock = new ASI_TnE_KR_MassCreateAndUpdateController.PageBlockActionBtn('dummyLabel', 'dummyName');  
         
        Boolean initPageBool = mcauCon.dummyVar;
        
        pageParams4.put(mcauCon.PARAM_RTID, 'ASI_TnE_KR_Claim_Detail');
        
        Integer recordIndex = 0;
        
        pageParams4.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(recordIndex).myRecordList.get(0).id);    
        
        ASI_TnE_KR_MassCreateAndUpdateController.findSObjects('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_KR');
        ASI_TnE_KR_MassCreateAndUpdateController.findSObjects('ASI_CRM_AccountsAdditionalField__c', 'ID#'+tempUsers[1].id);
        ASI_TnE_KR_MassCreateAndUpdateController.findSObjects('ASI_TnE_Branch_Channel__c', '');
        ASI_TnE_KR_MassCreateAndUpdateController.findSObjects('ASI_KOR_Sub_Brand__c', '');
        
        mcauCon.commitAll();
        
        mcauCon.enableForEdit();
        mcauCon.cloneRow();
        mcauCon.addNewRow();
        
        List<ASI_TnE_KR_MassCreateAndUpdateController.TableRow> recordList = mcauCon.theRecordTypeElementList.get(recordIndex).myRecordList;
        pageParams4.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
        mcauCon.removeNew();        
        mcauCon.addMoreBlankRows();
        
        pageParams4.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(recordIndex).myRecordList.get(0).id);
        mcauCon.deleteOld();
        
        mcauCon.clearAll();
        mcauCon.triggerPageBlockAction();
        test.stopTest();
    }//end testMassUpdateController*/
}