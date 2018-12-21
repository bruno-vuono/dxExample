@isTest(SeeAllData=true)
private class EUR_CRM_AccountOwnerManagerHandlerTest {

    static testMethod void myUnitTest() {
      Id rtId = [select id from recordtype where developername = 'EUR_GB_FS_Indirect' and sobjecttype = 'eur_crm_account__c' limit 1].id;
      
        User u = [Select Id, ManagerId From User Where UserType = 'Standard' and IsActive = true and ManagerId != null limit 1];
        EUR_CRM_Account__c acct = new EUR_CRM_Account__c(name='test acct', ownerId = u.Id, recordtypeid=rtId );
        insert acct;
        acct = [Select Id, EUR_CRM_Manager_of_Account_Owner__c From EUR_CRM_Account__c Where Id =: acct.Id];
        //system.assertEquals(acct.EUR_CRM_Manager_of_Account_Owner__c, u.ManagerId);
    }

}