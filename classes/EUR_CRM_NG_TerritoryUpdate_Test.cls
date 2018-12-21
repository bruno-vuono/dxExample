/*********************************************************************************
 * Name:EUR_CRM_NG_TerritoryUpdate_Test 
 * Description: Test Class for Territory related functions
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 9/30/2015        Laputa: Conrad          Created
**********************************************************************************/
@isTest
public class EUR_CRM_NG_TerritoryUpdate_Test {
	
	public class setUser {
		User u;
		public setUser(String uName) {
		    Profile p = [SELECT Id FROM Profile WHERE Name ='EUR System Admin']; 
		    UserRole r = [select id from UserRole where Developername ='EMEA'];
		    u = new User(Alias = 'standt', Email=uName+'@test.com', userroleid=r.id,
		    EmailEncodingKey='UTF-8', LastName=uName+'lastName', LanguageLocaleKey='en_US', 
		    LocaleSidKey='en_US', ProfileId = p.Id, 
		    TimeZoneSidKey='America/Los_Angeles', UserName=uName+'@test.com');
		    insert u;
		}
	}

	static testMethod  void testTerritoryHandler(){
        User eurSysUser = new setUser('userEmail1234ng').u;
        User eurSysUserKD = new setUser('userEmail1234ngKD').u;
        User eurSysUserOff = new setUser('userEmail1234ngOFF').u;
        User eurSysUserON = new setUser('userEmail1234ngON').u;
        
        System.runAs(eurSysUser){
		    Id ngAccountRecordTypeId = Global_RecordTypeCache.getRtId('EUR_CRM_Account__cEUR_NG_On_Trade');
		    Id ngTerritoryRecordTypeId = Global_RecordTypeCache.getRtId('EUR_CRM_Territory__cEUR_CRM_NG_Territory');
		    Id ngRegionRecordTypeId = Global_RecordTypeCache.getRtId('EUR_CRM_Region__cEUR_NG_Region');
		    
		    EUR_CRM_Region__c region = new EUR_CRM_Region__c(recordtypeid=ngRegionRecordTypeId,name = 'testregion',EUR_CRM_Region_Owner__c = eurSysUser.id, ownerid = eurSysUser.id);
		    insert region;
		    EUR_CRM_Territory__c territory = new EUR_CRM_Territory__c(
		    															EUR_CRM_Region__c = region.id, 
		    															recordtypeid=ngTerritoryRecordTypeId,
		    															name = 'testterritory',
		    															EUR_CRM_Territory_Owner__c = eurSysUser.id, 
		    															EUR_CRM_Default__c = true,
		    															EUR_CRM_KD_Owner__c = eurSysUserKD.id,
		    															EUR_CRM_Off_Trade_Owner__c = eurSysUserOff.id,
		    															EUR_CRM_On_Trade_Owner__c = eurSysUserON.id);
		    insert territory; 
		   	Test.startTest();
		    eur_crm_account__C account = new eur_crm_account__C(name='test account', recordtypeid=ngAccountRecordTypeId, EUR_CRM_Territory__c =null);
		    insert account;
		    
		    ApexPages.StandardController sc = new ApexPages.StandardController(territory);
		    User eurSysUserON2 = new setUser('userEmail1234ngON2').u;
		    territory.EUR_CRM_On_Trade_Owner__c = eurSysUserON2.id;
		    update territory;
		    EUR_CRM_NG_TerritoryUpdateController tc = new EUR_CRM_NG_TerritoryUpdateController(sc);
		    tc.massUpdateNigeriaAccounts(); 
		    Test.stopTest();

    	}
	}

}