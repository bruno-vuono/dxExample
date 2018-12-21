/*********************************************************************************
 * Name: ASI_CRM_VN_AccCreateProsSegHandlerTest
 * Description: Test Class for ASI_CRM_VN_AccCreateProsSegHandler
 *
 * Version History
 * Date                Developer             Comments
 * ---------------  --------------------  --------------------------------------------------------------------------------
 * 11/16/2015       Neha                    Created
 * 21/03/2018       Laputa: Hugo Cheung     Updated
 * 2018-04-04       Laputa: Jeffrey Cheung  Added ASI_CRM_Outlet_Sub_Type__c and ASI_CRM_Area__c to groupOutletType
*********************************************************************************/

// ASI_CRM_AccountsAdditionalField__c
@isTest
public class ASI_CRM_VN_AccCreateProsSegHandlerTest{
    @testSetup 
    static void setupTestData(){
        ASI_HK_CRM_Running_Number__c testRunningNumber = ASI_CRM_VN_TestDataFactory.getRunningNumber(
            system.Label.ASI_CRM_VN_Customer_Code,
            1,
            'VN-{YYYY}',
            date.today().month() + 2,
            Date.today().year()
        );
        insert testRunningNumber;
    }
    public static testMethod void createProsSegTest(){
        //Create Test Account record
        List<Account> accountList = ASI_CRM_VN_VisitationPlanDetailGenTest.createTestAccount(1);
        insert accountList;
        
        //Create Test Outlet Type record
        List<ASI_TH_CRM_OutletType__c> outletTypeList = ASI_CRM_VN_VisitationPlanDetailGenTest.createTestOutletType(1);
        outletTypeList[0].Name = 'TestOutletType';
        insert outletTypeList;
        
        //Create test record for Customers(ASI_CRM_AccountsAdditionalField__c)
        ASI_CRM_AccountsAdditionalField__c testCustomer = new ASI_CRM_AccountsAdditionalField__c();
        testCustomer.Name = 'TestCustomer';
        testCUstomer.recordtypeid = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_VN_Outlet_Inactive');
        testCustomer.ASI_CRM_Account__c = accountList[0].Id;
        testCustomer.ASI_TH_CRM_OutletType__c = outletTypeList[0].Id;
        testCustomer.ASI_CRM_VN_OutletType__c = 'Test';
        insert testCustomer;
        
        List<ASI_CRM_AccountsAdditionalField__c> customerList = new List<ASI_CRM_AccountsAdditionalField__c>();
        customerList.add(testCustomer);

        Id recordTypeId = [SELECT Id FROM Recordtype WHERE Developername =: 'ASI_CRM_VN_Group_Outlet_Type'][0].Id;
        List<ASI_CRM_Group_Outlet_Type__c> groupOutletTypes = new List<ASI_CRM_Group_Outlet_Type__c>();
        //Create Test Group Outlet Type record
        ASI_CRM_Group_Outlet_Type__c groupOutletTypeWithSubType = new ASI_CRM_Group_Outlet_Type__c();
        groupOutletTypeWithSubType.ASI_CRM_SG_Name__c = 'Test';
        groupOutletTypeWithSubType.recordTypeId = recordTypeId;
        groupOutletTypeWithSubType.ASI_CRM_SG_Group_Outlet_Name__c = 'Test';
        groupOutletTypeWithSubType.ASI_CRM_Outlet_Sub_Type__c = 'Family KTV; Asian Restaurant';
        groupOutletTypeWithSubType.ASI_CRM_Area__c = 'HCMC; HANOI';
        groupOutletTypes.add(groupOutletTypeWithSubType);

        ASI_CRM_Group_Outlet_Type__c groupOutletTypeWithArea = new ASI_CRM_Group_Outlet_Type__c();
        groupOutletTypeWithArea.ASI_CRM_SG_Name__c = 'Test2';
        groupOutletTypeWithArea.recordTypeId = recordTypeId;
        groupOutletTypeWithArea.ASI_CRM_SG_Group_Outlet_Name__c = 'Test';
        groupOutletTypeWithArea.ASI_CRM_Area__c = 'HCMC; HANOI';
        groupOutletTypes.add(groupOutletTypeWithArea);

        insert groupOutletTypes;

        test.startTest();
            ASI_CRM_VN_AccCreateProsSegHandler objCtrl = new ASI_CRM_VN_AccCreateProsSegHandler();
            objCtrl.createProsSegRecord(customerList);
        test.stopTest();
        
        List<ASI_CRM_Pros_Segmentation__c> prosSegList = new List<ASI_CRM_Pros_Segmentation__c>();
        prosSegList = [select Id from ASI_CRM_Pros_Segmentation__c where ASI_CRM_SG_Group_Outlet_Type__c =: groupOutletTypeWithSubType.Id];
    }      
}