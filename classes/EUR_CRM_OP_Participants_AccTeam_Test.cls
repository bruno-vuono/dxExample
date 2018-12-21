/*
  @Company:     IP-Converge Data Services, Inc.
  @Description: Test Class for EUR_CRM_OP_Participants_AccTeam_Handler
  @Author:      IPC
  @History:     OCT.27.2014 - Created
*/
@isTest
private class EUR_CRM_OP_Participants_AccTeam_Test{
    public static User testUser;
    public static EUR_CRM_Account__c accountEU;
    public static EUR_CRM_ObjPromo__c objPromo;
    public static EUR_CRM_ObjPromo_Account_Mapping__c accountMapping;
    public static EUR_CRM_ObjPromo_Trade_Fair_Participant__c tradeFair;
    
    public static void insert_Data() {
        testUser = EUR_CRM_DE_TestClassUtilityHelper.createUser('System Administrator','EUR_DE_CEO_Sales', 'testuser1000000@sales.com', 'testuser1200000@sales.com', 'accTest1990');
        System.runAs(testUser){
            EUR_CRM_Region__c region = EUR_CRM_DE_TestClassUtilityHelper.createRegion('region 1', UserInfo.getUserId(),'DE Region');
            EUR_CRM_Territory__c offTradeTerritory = EUR_CRM_DE_TestClassUtilityHelper.createTerritory('offTradeTerritory' , UserInfo.getUserId(), region.id, 'DE Territory');
            EUR_CRM_Postal_Code_Territory_Mapping__c offTradeTerritoryMapping = EUR_CRM_DE_TestClassUtilityHelper.createPostalCodeMapping('offTradeTerritoryMapping', '12345' , offTradeTerritory.id, 'DE Off Trade Postal Code - Territory Mapping');
            EUR_CRM_Customer_Taxonomy__c custTaxonomy = EUR_CRM_DE_TestClassUtilityHelper.createCustomerTaxonomy('test taxonomy', UserInfo.getUserId(), 'DE Customer Taxonomy');
            
            accountEU = EUR_CRM_DE_TestClassUtilityHelper.creaEUAccount('TestAccount1', '12345', 'DE OFF STD', custTaxonomy.Id);
            
            EUR_CRM_OP_Action_List_Template__c listing = EUR_CRM_DE_TestClassUtilityHelper.creaActionListTemplate('Trade Fair Action List', 'DE_OFF_ALT_Trade_Fair', 'DE O/P Action List Template');
            
            objPromo = EUR_CRM_DE_TestClassUtilityHelper.createObjPromo(1, 'DE Off Trade Trade Fair', 'OBJPROMO_DE')[0];
            insert objPromo;
            
            EUR_CRM_ObjPromo_Account_Mapping__c accMap = new EUR_CRM_ObjPromo_Account_Mapping__c();
            accMap.EUR_CRM_Account__c = accountEU.Id;
            accMap.EUR_CRM_ObjPromo__c = objPromo.Id;
            insert accMap;
            
            tradeFair =  new EUR_CRM_ObjPromo_Trade_Fair_Participant__c();
            tradeFair.EUR_CRM_Objectives_Promotions__c = objPromo.Id;
            tradeFair.EUR_CRM_Participant__c = UserInfo.getUserId();
            insert tradeFair;
        }
    }
    
    static testMethod void test_TradeFair_Insert(){
        Test.startTest();
            insert_Data();
        Test.stopTest();
    }
    
    
    
    static testMethod void test_TradeFair_Delete(){
        Test.startTest();
            insert_Data();
            System.runAs(testUser){
                delete tradeFair;
            }
        Test.stopTest();
    }
}