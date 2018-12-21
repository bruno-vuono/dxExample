/*
  @Company:     IP-Converge Data Services, Inc.
  @Description: Test Class for EUR_CRM_DE_ListingTemplateHandler Class.
  @Author:      IPC
  @History:     SEPT.26.2014 - Created
*/
@isTest(SeeAllData = true)
private with sharing class EUR_CRM_DE_TestListingTemplateHandler {
    private static EUR_CRM_Account__c accountEU;
    private static EUR_CRM_Customer_Taxonomy__c custTaxonomyOff;
    private static User accUser ;

    static void dataInsert1() {
        accUser = EUR_CRM_DE_TestClassUtilityHelper.createUser('System Administrator', 'EUR_DE_National_Sales_Manager_Off_Trade', 'testuser123902@sales.com', 'testuser123902@sales.com', 'accTest1990');
        System.runAs(accUser) {
            EUR_CRM_Region__c region = EUR_CRM_DE_TestClassUtilityHelper.createRegion('region 1', accUser.Id, 'DE Region');

            EUR_CRM_Territory__c offTradeTerritory = EUR_CRM_DE_TestClassUtilityHelper.createTerritory('offTradeTerritory', UserInfo.getUserId(), region.id, 'DE Territory');

            EUR_CRM_Postal_Code_Territory_Mapping__c offTradeTerritoryMapping = EUR_CRM_DE_TestClassUtilityHelper.createPostalCodeMapping('offTradeTerritoryMapping', '12345', offTradeTerritory.id, 'DE Off Trade Postal Code - Territory Mapping');

            custTaxonomyOff = EUR_CRM_DE_TestClassUtilityHelper.createCustomerTaxonomy('test taxonomy', UserInfo.getUserId(), 'DE Customer Taxonomy');
            system.assertNotEquals(custTaxonomyOff, null);
        }
    }
    /*
    static testMethod void testOffTrade(){
        dataInsert1();
        System.runAs(accUser){
            Test.startTest();
                
                accountEU = EUR_CRM_DE_TestClassUtilityHelper.creaEUAccount('euAccount1 ', '12345' , 'DE OFF STD', custTaxonomyOff.Id);
                accountEU.EUR_CRM_Status_of_Customer__c = 'Active';
                update accountEU;
            Test.stopTest();
        }
    }
    */

    @isTest
    public static void testOffTrade() {
        EUR_CRM_DE_TestClassUtilityHelper.initOffTradeUsers();
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.offTradeNationalManager) {
            EUR_CRM_DE_TestClassUtilityHelper.initOffTradeDataSet();
            Test.startTest();
            String mod = 'TestModule1234';
            //create the templates.
            Id rtid = [select id from recordtype where developername = 'EUR_DE_OFF_Trade_Template' and sobjecttype = 'EUR_CRM_JB_Template__c'].id;
            EUR_CRM_JB_Template__c template = new EUR_CRM_JB_Template__c(
                    EUR_CRM_Customer_Taxonomy__c = EUR_CRM_DE_TestClassUtilityHelper.customerTaxonomy1.id,
                    EUR_CRM_Module__c = mod,
                    recordtypeid = rtid
            );
            insert template;
            EUR_CRM_DE_TestClassUtilityHelper.offTradeAccount1.EUR_CRM_Module__c = mod;
            EUR_CRM_DE_TestClassUtilityHelper.offTradeAccount1.EUR_CRM_Status_of_Customer__c = 'Active';
            update EUR_CRM_DE_TestClassUtilityHelper.offTradeAccount1;
            //update the account
            Test.stopTest();
        }
    }

    @isTest
    public static void testOnTrade() {
        EUR_CRM_DE_TestClassUtilityHelper.initUsersOntrade();
        //System.debug('### EUR_CRM_DE_TestListingTemplateHandler SOQL Limits 1:'+Limits.getQueries());
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.regionalUser) {
            EUR_CRM_DE_TestClassUtilityHelper.initDataOnTrade();
            Test.startTest();
            /*
              EUR_CRM_DE_TestClassUtilityHelper.region = EUR_CRM_DE_TestClassUtilityHelper.createRegion('region1', EUR_CRM_DE_TestClassUtilityHelper.regionalUser.id,  EUR_CRM_DE_TestClassUtilityHelper.DE_REGION_RECORD_TYPE);

            EUR_CRM_DE_TestClassUtilityHelper.territory = EUR_CRM_DE_TestClassUtilityHelper.createTerritory('territory1', EUR_CRM_DE_TestClassUtilityHelper.salesRepUser.id,EUR_CRM_DE_TestClassUtilityHelper.region.id, EUR_CRM_DE_TestClassUtilityHelper.DE_TERRITORY_RECORD_TYPE);

            EUR_CRM_DE_TestClassUtilityHelper.postalmapping = createPostalCodeMapping('postalmap' , '12345', EUR_CRM_DE_TestClassUtilityHelper.territory.id, EUR_CRM_DE_TestClassUtilityHelper.DE_POSTAL_CODE_MAPPING_RECORD_TYPE);
            EUR_CRM_DE_TestClassUtilityHelper.customerTaxonomy = createCustomerTaxonomy('testtaxonomy', EUR_CRM_DE_TestClassUtilityHelper.regionalUser.id, EUR_CRM_DE_TestClassUtilityHelper.DE_CUSTOMER_TAXONOMY_RECORD_TYPE);

            EUR_CRM_DE_TestClassUtilityHelper.euAccount = creaEUAccount('testname', '12345', EUR_CRM_DE_TestClassUtilityHelper.DE_EUACCOUNT_ON_CONSUMERS_RECORD_TYPE , EUR_CRM_DE_TestClassUtilityHelper.customerTaxonomy.id);

      */
            Id rtid = [select id from recordtype where developername = 'EUR_DE_OFF_Trade_Template' and sobjecttype = 'EUR_CRM_JB_Template__c'].id;
            String mod = 'TestModule1234';
            EUR_CRM_JB_Template__c template = new EUR_CRM_JB_Template__c(
                    EUR_CRM_Module__c = mod,
                    recordtypeid = rtid
            );

            EUR_CRM_DE_TestClassUtilityHelper.euAccount.EUR_CRM_Status_of_Customer__c = 'Active';
            update EUR_CRM_DE_TestClassUtilityHelper.euAccount;
            List<EUR_CRM_Account__c> g = new List<EUR_CRM_Account__c>();
            g.add(EUR_CRM_DE_TestClassUtilityHelper.euAccount);
            EUR_CRM_DE_ListingTemplateHandler.assignTemplateOnTradeAccounts(g, new Set<String>(), new Set<String>(), new Set<String>(), new Set<String>());
            EUR_CRM_DE_ListingTemplateHandler.createKey('', '', '', '', '');
            Test.stopTest();
        }
    }
}