/*------------------------------------------------------------
Author/Company:   IP Converge Data Services,Inc.
Description:      test class for EUR_CRM_MassUpdateAccountOwner 
History
05/05/2014        IPC     Created
------------------------------------------------------------*/
@isTest
public with sharing class EUR_CRM_TestMassUpdateAccountOwner {
    private static User accUser;
    private static List<EUR_CRM_Account__c> account;
    
    static testmethod void dataInsert(){
    
        Id userId = UserInfo.getUserId();
    
        EUR_CRM_Region__c region = EUR_CRM_TestClassUtilityHelper.createRegion(1, '', userId)[0];
        insert region;
        system.assert(region.Id<>null);
        EUR_CRM_Territory__c territory = EUR_CRM_TestClassUtilityHelper.createTerritory(1, '', userId, region.Id)[0];
        insert territory;
        system.assert(territory.Id<>null);
        EUR_CRM_Postal_Code_Territory_Mapping__c territoryMap = EUR_CRM_TestClassUtilityHelper.createTerritoryMapping(1, '', territory.Id)[0];
    
        account = EUR_CRM_TestClassUtilityHelper.createAccountsEU(5, 'AT On Trade');
        for(EUR_CRM_Account__c accEU :account){
             accEU.EUR_CRM_Territory__c = territory.Id;
        }
        insert account;
        system.assert(account<>null);
        
        
    }
    static testmethod void testManager(){
        accUser = EUR_CRM_DE_TestClassUtilityHelper.createUser('System Administrator','EUR_DE_National_Sales_Manager_Off_Trade', 'testuser123902@sales.com', 'testuser123902@sales.com', 'accTest1990');
        
        System.runAs(accUser) {
            Test.startTest();
            
            dataInsert();
            EUR_CRM_MassUpdateAccountOwner massUpdateAccOwn = new EUR_CRM_MassUpdateAccountOwner('SELECT Id, Name, OwnerId, EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__c, EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__r.Id ' + 'FROM EUR_CRM_Account__c ' + 'WHERE OwnerId=\'' + UserInfo.getUserId() + '\'' + ' LIMIT 10');
            database.executeBatch(massUpdateAccOwn, 200);
        
            Test.stopTest();
        }
    }
}