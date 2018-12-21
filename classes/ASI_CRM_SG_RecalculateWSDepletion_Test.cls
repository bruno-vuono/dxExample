/*********************************************************************************
 * Name: ASI_CRM_SG_RecalculateWSDepletion_Test
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 12/05/2016       Laputa:Hugo             Created
 * 03/08/2016		Laputa:Hugo				Updated. Add test setup function 
 *              
*/

@isTest
private class ASI_CRM_SG_RecalculateWSDepletion_Test {
	
    @TestSetup
    public static void setupTestData() {
        
    }
    
    public static testmethod void testRecalculateWSDepletion() {

        ASI_CRM_SG_TestClassHelper.createDataSettings();
        
        List<ASI_MFM_Sub_brand__c> subBrandList = ASI_CRM_SG_TestClassHelper.createSubBrandData();
        List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUwithSubrand(subBrandList); 

        Profile p = [SELECT Id FROM Profile WHERE Name = 'ASI SG External User'];
        
        User newUser = new User(
          profileId = p.Id,
            username = 'newUser1234@newUser1234.com',
            email = 'newUser@newUser.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias = 'nuser',
            lastname = 'user',
            ASI_Company_Name__c = 'TestCustomer'
        );
        insert newUser;

        ASI_CRM_SG_TestClassHelper.wholesalesCustomerData customerD = new ASI_CRM_SG_TestClassHelper.wholesalesCustomerData(true, 'TestCustomer');
        ASI_CRM_SG_TestClassHelper.contractData contractD = new ASI_CRM_SG_TestClassHelper.contractData(true);

        Id wsDepletionRecTypeId = Schema.SObjectType.ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c.getRecordTypeInfosByName().get('ASI_CRM_SG_WS_Depletion').getRecordTypeId();

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> testWsDepletionList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();

        ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c testWsDepletion1 =
            new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c(
                RecordTypeId = wsDepletionRecTypeId,
                ASI_CRM_Customer__c = customerD.customer.Id,
                ASI_CRM_SKU__c = skuList.get(0).Id,
                ASI_TH_CRM_Date__c = Date.today().addMonths(-1),
                ASI_TH_CRM_Sell_In__c = 10,
                ASI_TH_CRM_Total_Offtake_Final__c = 25,
                ASI_TH_CRM_FOC__c = 43
            );
        testWsDepletionList.add(testWsDepletion1);
            
        ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c testWsDepletion2 =
            new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c(
                RecordTypeId = wsDepletionRecTypeId,
                ASI_CRM_Customer__c = customerD.customer.Id,
                ASI_CRM_SKU__c = skuList.get(1).Id,
                ASI_TH_CRM_Date__c = Date.today().addMonths(-1),
                ASI_TH_CRM_Sell_In__c = 21,
                ASI_TH_CRM_Total_Offtake_Final__c = 43,
                ASI_TH_CRM_FOC__c = 51
            );
        testWsDepletionList.add(testWsDepletion2);

        ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c testWsDepletion3 =
            new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c(
                RecordTypeId = wsDepletionRecTypeId,
                ASI_CRM_Customer__c = customerD.customer.Id,
                ASI_CRM_SKU__c = skuList.get(2).Id,
                ASI_TH_CRM_Date__c = Date.today().addMonths(-1),
                ASI_TH_CRM_Sell_In__c = 72,
                ASI_TH_CRM_Total_Offtake_Final__c = 62,
                ASI_TH_CRM_FOC__c = 12
            );
        testWsDepletionList.add(testWsDepletion3);

        ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c testWsDepletion4 =
            new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c(
                RecordTypeId = wsDepletionRecTypeId,
                ASI_CRM_Customer__c = customerD.customer.Id,
                ASI_CRM_SKU__c = skuList.get(0).Id,
                ASI_TH_CRM_Date__c = Date.today().addMonths(-2),
                ASI_TH_CRM_Sell_In__c = 87,
                ASI_TH_CRM_Total_Offtake_Final__c = 34,
                ASI_TH_CRM_FOC__c = 41
            );
        testWsDepletionList.add(testWsDepletion4);

        insert testWsDepletionList;

        Id actualOfftakeRecTypeId = Schema.SObjectType.ASI_TH_CRM_Actual_Offtake__c.getRecordTypeInfosByName().get('ASI CRM SG Actual Offtake').getRecordTypeId();

        List<ASI_TH_CRM_Actual_Offtake__c> testActualOfftakeList = new List<ASI_TH_CRM_Actual_Offtake__c>();

        ASI_TH_CRM_Actual_Offtake__c testActualOfftake1 = new ASI_TH_CRM_Actual_Offtake__c(
            RecordTypeId = actualOfftakeRecTypeId,
            ASI_CRM_Contract__c = contractD.contract.Id,
            ASI_CRM_FromWS__c = customerD.customer.Id,
            ASI_CRM_SKU__c = skuList.get(0).Id,
            ASI_TH_CRM_Quantity__c = 10,
            ASI_TH_CRM_Offtake_G_L_Date__c = Date.today().addMonths(-2)
        );

        testActualOfftakeList.add(testActualOfftake1);

        ASI_TH_CRM_Actual_Offtake__c testActualOfftake2 = new ASI_TH_CRM_Actual_Offtake__c(
            RecordTypeId = actualOfftakeRecTypeId,
            ASI_CRM_Contract__c = contractD.contract.Id,
            ASI_CRM_FromWS__c = customerD.customer.Id,
            ASI_CRM_SKU__c = skuList.get(1).Id,
            ASI_TH_CRM_Quantity__c = 9,
            ASI_TH_CRM_Offtake_G_L_Date__c = Date.today().addMonths(-1)
        );

        testActualOfftakeList.add(testActualOfftake2);

        insert testActualOfftakeList;
        
        testWsDepletion4.ASI_TH_CRM_Sell_In__c = 187;

        System.Test.startTest();
            update testWsDepletion4;
            Database.executeBatch(new ASI_CRM_SG_RecalculateWSDepletion_Batch());
        System.Test.stopTest();

    }

}