@isTest
private class EUR_CRM_AccountVisitFrequencyHandlerTest {

    static testMethod void myUnitTest() {
        Id rtId = [select id from recordtype where developername = 'EUR_GB_FS_Indirect' and sobjecttype = 'eur_crm_account__c' limit 1].id;
        EUR_CRM_Group_Outlet_Type__c goutletType = new EUR_CRM_Group_Outlet_Type__c(EUR_CRM_Name__c='Restaurant');
        insert goutletType;
        EUR_CRM_Outlet_Type__c outletType = new EUR_CRM_Outlet_Type__c(EUR_CRM_Name__c='Restaurant', EUR_CRM_Group_Outlet_Type__c=goutletType.Id);
        insert outletType;
        EUR_CRM_Image_Level__c imgLevel = new EUR_CRM_Image_Level__c(EUR_CRM_Name__c='Leading');
        insert imgLevel;
        EUR_CRM_Volume_Potential__c volPotential = new EUR_CRM_Volume_Potential__c(EUR_CRM_Name__c='High');
        insert volPotential;
        EUR_CRM_Visit_Frequency__c visitFreq = new EUR_CRM_Visit_Frequency__c(name='once a week');
        insert visitFreq;
        EUR_CRM_Visit_Frequency_Criteria__c visitCriteria = new EUR_CRM_Visit_Frequency_Criteria__c(EUR_CRM_Visit_Frequency__c=visitFreq.Id, 
            EUR_CRM_Group_Outlet_Type__c=goutletType.Id, EUR_CRM_Outlet_Type__c=outletType.Id, EUR_CRM_Image_Level__c=imgLevel.Id, EUR_CRM_Volume_Potential__c=volPotential.id);
        insert visitCriteria;
        
        EUR_CRM_Account__c acct = new EUR_CRM_Account__c(Name='GB test on trade account');
        acct.EUR_CRM_Group_Outlet_Type__c = goutletType.Id;
        acct.EUR_CRM_Outlet_Type__c = outletType.Id;
        acct.EUR_CRM_Image_Level__c = imgLevel.id;
        acct.EUR_CRM_Volume_Potential__c = volPotential.Id;
        acct.recordtypeid = rtId;
        insert acct;
        
        acct = [Select Id, EUR_CRM_Visit_Frequency__c From EUR_CRM_Account__c Where Id=: acct.Id];
        system.assertEquals(acct.EUR_CRM_Visit_Frequency__c, visitFreq.Id);
    }
}