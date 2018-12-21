@isTest
public class ASI_TnE_KR_changeGnHRequestStatusTest{


    @testSetup static void setupData(){
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        List<ASI_eForm_HR_MDM__c> tempMDMs = ASI_TnE_KR_TestClassHelper.createMDMRecords(); //MDM list
        List<ASI_TnE_Account_Mapping__c> tempACMaps = ASI_TnE_KR_TestClassHelper.createAcMapRecords(); //accounting mapping list
        List<ASI_JP_TnE_Expense_Category__c> tempCats = ASI_TnE_KR_TestClassHelper.createExCatRecords(); //expense category list
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = ASI_TnE_KR_TestClassHelper.createExClassRecords(tempCats,tempACMaps); //expense classficiation list
        List<ASI_KOR_Brand__c> tempBrands = ASI_TnE_KR_TestClassHelper.createBrandRecords(); //brand list
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = ASI_TnE_KR_TestClassHelper.createSubBrandRecords(tempBrands); //sub-brand list
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = ASI_TnE_KR_TestClassHelper.createCustomerRecords(tempUsers); //customer list

        List<ASI_GnH_Request__c> gnhRequestList = ASI_TnE_KR_TestClassHelper.createGnHRequest(tempUsers);
        List<ASI_TnE_ClaimHeader__c> tempHeaders = ASI_TnE_KR_TestClassHelper.createGeneralHeaderRecord(tempUsers); //claim header list
        List<ASI_TnE_ClaimDetail__c> tempDetails = ASI_TnE_KR_TestClassHelper.createGeneralDetailRecord(tempHeaders,tempSubBrands,tempCats,tempClasses,tempCustomers,tempUsers,gnhRequestList); //claim detail list        

    }

    static testMethod void changeStatusSubmitted(){

        List<ASI_TnE_ClaimHeader__c> draftHeaderList = [select Id, ASI_TnE_Status__c from ASI_TnE_ClaimHeader__c where ASI_TnE_Status__c = 'Draft' or ASI_TnE_Status__c = 'Submitted'];
        List<ASI_TnE_ClaimHeader__c> updateList = new List<ASI_TnE_ClaimHeader__c>();
        for (ASI_TnE_ClaimHeader__c draftHeader : draftHeaderList){
            if (draftHeader.ASI_TnE_Status__c == 'Draft'){ 
                draftHeader.ASI_TnE_Status__c = 'Submitted';
            }else if (draftHeader.ASI_TnE_Status__c == 'Submitted'){
                draftHeader.ASI_TnE_Status__c = 'Rejected';
            }
            updateList.add(draftHeader);        
        }
        update updateList;
    }

}