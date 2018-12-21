/*********************************************************************************
 * Name: ASI_CRM_JP_SORedirect_CtrlTest
 * Description: Test class for ASI_CRM_JP_SORedirect_Controller
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 11/07/2017       Hugo Cheung             Created          
*/
@isTest
public class ASI_CRM_JP_SORedirect_CtrlTest {
    
    private final static String SALES_ORDER_ID  = 'salesOrderId';
    private final static String RECORD_TYPE_KEY = 'RecordType';
    private final static String SHIP_TO_KEY     = 'ASI_CRM_Ship_To__c';
    private final static String SOLD_TO_KEY     = 'ASI_CRM_Sold_To__c';
    private final static String TEMPLATE_ID     = 'templateId';
    
    @TestSetup
    public static void setupData() {
        ASI_CRM_JP_TestHelper.createRunningNumber();
   		ASI_CRM_JP_TestHelper.createApprovalRoute();
        
        Map<String, Object> postalCodeFieldValueMap = ASI_CRM_JP_TestHelper.POSTAL_CODE_DEFAULT_VALUE_MAP;
        ASI_CRM_Postal_Code__c postalCode = ASI_CRM_JP_TestHelper.createPostalCode(postalCodeFieldValueMap);
        insert postalCode;
        
        Map<String, Object> directSalesCustomerFieldValueMap = ASI_CRM_JP_TestHelper.DIRECT_SALES_CUSTOMER_DEFAULT_VALUE_MAP;
        directSalesCustomerFieldValueMap.put('RecordTypeId', ASI_CRM_JP_TestHelper.CUSTOMER_RECORD_TYPE_MAP.get('ASI_CRM_JP_Direct_Sales_Customer'));
        ASI_CRM_AccountsAdditionalField__c directSalesCustomer = ASI_CRM_JP_TestHelper.createCustomer(directSalesCustomerFieldValueMap);
        insert directSalesCustomer;
        
        Map<String, Object> directSalesShipToCustomerFieldValueMap = ASI_CRM_JP_TestHelper.DIRECT_SALES_SHIP_TO_DEFAULT_VALUE_MAP;
        directSalesShipToCustomerFieldValueMap.put('ASI_CRM_Customer__c', directSalesCustomer.Id);
        directSalesShipToCustomerFieldValueMap.remove('ASI_CRM_KR_Salesman__c');
        ASI_CRM_AccountsAdditionalField__c directSalesShipToCustomer = ASI_CRM_JP_TestHelper.createCustomer(directSalesShipToCustomerFieldValueMap);
        insert directSalesShipToCustomer;
        
        Map<String, Object> directSalesBillToCustomerFieldValueMap = ASI_CRM_JP_TestHelper.BILL_TO_CUSTOMER_DEFAULT_VALUE_MAP;
        ASI_CRM_AccountsAdditionalField__c directSalesBillToCustomer = ASI_CRM_JP_TestHelper.createCustomer(directSalesBillToCustomerFieldValueMap);
        insert directSalesBillToCustomer;
        
        insert ASI_CRM_JP_TestHelper.createBillTo(directSalesCustomer.Id, directSalesBillToCustomer.Id);
        
        Map<String, Object> advancedSearchFieldValueMap = ASI_CRM_JP_TestHelper.ADVANCED_SEARCH_DEFAULT_VALUE_MAP;
        advancedSearchFieldValueMap.put('ASI_Ship_To_Customer__c', directSalesShipToCustomer.Id);
        advancedSearchFieldValueMap.put('ASI_Sold_To_Customer__c', directSalesCustomer.Id);
        ASI_CRM_JP_Advanced_Search__c advancedSearch = ASI_CRM_JP_TestHelper.createAdvancedSearch(advancedSearchFieldValueMap);
        insert advancedSearch;
    }
    
    public static testMethod void createNormalSalesOrder() {
        Map<String, ASI_CRM_AccountsAdditionalField__c> customerMap = new Map<String, ASI_CRM_AccountsAdditionalField__c>();
        
        for(ASI_CRM_AccountsAdditionalField__c customer : [SELECT Id, RecordType.DeveloperName FROM ASI_CRM_AccountsAdditionalField__c]) {
        	customerMap.put(customer.RecordType.DeveloperName, customer);
        }
        
        PageReference pageRef = Page.ASI_CRM_JP_SORedirect_Page;
        pageRef.getParameters().put(RECORD_TYPE_KEY, 'ASI_CRM_JP_Normal_SO');
        pageRef.getParameters().put(SOLD_TO_KEY, customerMap.get('ASI_CRM_JP_Direct_Sales_Customer').Id);
        Test.setCurrentPage(pageRef);
        
        ASI_CRM_JP_SORedirect_Controller soRedirectController = new ASI_CRM_JP_SORedirect_Controller();
        soRedirectController.redirectPage();
    }
    
    public static testMethod void createDirectSalesOrder() {
        Map<String, ASI_CRM_AccountsAdditionalField__c> customerMap = new Map<String, ASI_CRM_AccountsAdditionalField__c>();
        
        for(ASI_CRM_AccountsAdditionalField__c customer : [SELECT Id, RecordType.DeveloperName FROM ASI_CRM_AccountsAdditionalField__c]) {
        	customerMap.put(customer.RecordType.DeveloperName, customer);
        }
        
        PageReference pageRef = Page.ASI_CRM_JP_SORedirect_Page;
        pageRef.getParameters().put(RECORD_TYPE_KEY, 'ASI_CRM_JP_Direct_Sales');
        pageRef.getParameters().put(SHIP_TO_KEY, customerMap.get('ASI_CRM_JP_Direct_Sales_Ship_To').Id);
        pageRef.getParameters().put(SOLD_TO_KEY, customerMap.get('ASI_CRM_JP_Direct_Sales_Customer').Id);
        Test.setCurrentPage(pageRef);
        
        ASI_CRM_JP_SORedirect_Controller soRedirectController = new ASI_CRM_JP_SORedirect_Controller();
        soRedirectController.redirectPage();
    }
    
    public static testMethod void testDeleteSalesOrder() {
        Map<String, ASI_CRM_AccountsAdditionalField__c> customerMap = new Map<String, ASI_CRM_AccountsAdditionalField__c>();
        
        for(ASI_CRM_AccountsAdditionalField__c customer : [SELECT Id, RecordType.DeveloperName FROM ASI_CRM_AccountsAdditionalField__c]) {
        	customerMap.put(customer.RecordType.DeveloperName, customer);
        }
        
        PageReference pageRef = Page.ASI_CRM_JP_SORedirect_Page;
        pageRef.getParameters().put(RECORD_TYPE_KEY, 'ASI_CRM_JP_Direct_Sales');
        pageRef.getParameters().put(SHIP_TO_KEY, customerMap.get('ASI_CRM_JP_Direct_Sales_Ship_To').Id);
        pageRef.getParameters().put(SOLD_TO_KEY, customerMap.get('ASI_CRM_JP_Direct_Sales_Customer').Id);
        Test.setCurrentPage(pageRef);
        
        ASI_CRM_JP_SORedirect_Controller soRedirectController = new ASI_CRM_JP_SORedirect_Controller();
        soRedirectController.redirectPage();
        
        ASI_CRM_JP_Sales_Order__c salesOrder = [SELECT Id FROM ASI_CRM_JP_Sales_Order__c LIMIT 1];
        
        pageRef.getParameters().put(SALES_ORDER_ID, salesOrder.Id);
        soRedirectController.redirectPage();
    }
    
    public static testMethod void createWithTemplate() {
    	ASI_CRM_JP_Advanced_Search__c advancedSearch = [SELECT Id FROM ASI_CRM_JP_Advanced_Search__c LIMIT 1];
        PageReference pageRef = Page.ASI_CRM_JP_SORedirect_Page;
        pageRef.getParameters().put(RECORD_TYPE_KEY, 'ASI_CRM_JP_Normal_SO');
        pageRef.getParameters().put(TEMPLATE_ID, advancedSearch.Id);
        Test.setCurrentPage(pageRef);
        
        ASI_CRM_JP_SORedirect_Controller soRedirectController = new ASI_CRM_JP_SORedirect_Controller();
        soRedirectController.redirectPage();
    }
    
}