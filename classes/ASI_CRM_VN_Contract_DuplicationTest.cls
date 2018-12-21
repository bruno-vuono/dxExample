/***************************************************************************************************************************
 * Name:        ASI_CRM_VN_Contract_DuplicationTest
 * Description: Apex class for ASI_CRM_VN_Contract_DuplicationTest
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-04-03       Jeffrey Cheung          Created
 ****************************************************************************************************************************/
@IsTest
public class ASI_CRM_VN_Contract_DuplicationTest {
    @IsTest static void testCompare(){
        Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];


        ASI_CRM_VN_TestClassHelper.createRunningNumber();
        ASI_CRM_VN_TestClassHelper.createExchangeRate();

        User u = ASI_CRM_VN_TestClassHelper.createUser(systemAdminProfile.Id);
        u.ManagerId = UserInfo.getUserId();
        insert u;

        ASI_MFM_Sub_brand__c subBrand = ASI_CRM_VN_TestClassHelper.createSubBrand();
        ASI_MFM_Sub_brand__c subBrand2 = ASI_CRM_VN_TestClassHelper.createSubBrand();

        List<ASI_MFM_Sub_brand__c> subBrandList = new List<ASI_MFM_Sub_brand__c>();
        subBrandList.add(subBrand);
        subBrandList.add(subBrand2);
        insert subBrandList;

        ASI_CRM_ServicePack__c servicePack = ASI_CRM_VN_TestClassHelper.createServicePack();
        insert servicePack;

        ASI_CRM_AccountsAdditionalField__c onTradeCustomer = ASI_CRM_VN_TestClassHelper.createOnTradeCustomer();
        onTradeCustomer.ASI_CRM_Service_Pack__c = servicePack.Id;
        insert onTradeCustomer;

        List<ASI_TH_CRM_Actual_Offtake__c> actualOfftakeList = new List<ASI_TH_CRM_Actual_Offtake__c>();
        ASI_TH_CRM_Actual_Offtake__c actualOfftake = ASI_CRM_VN_TestClassHelper.createActualOfftake(onTradeCustomer.Id, subBrand.Id);
        ASI_TH_CRM_Actual_Offtake__c actualOfftake2 = ASI_CRM_VN_TestClassHelper.createActualOfftake(onTradeCustomer.Id, subBrand2.Id);
        actualOfftakeList.add(actualOfftake);
        actualOfftakeList.add(actualOfftake2);
        insert actualOfftakeList;

        ASI_CRM_VN_Contract__c contract1 = ASI_CRM_VN_TestClassHelper.createContract(onTradeCustomer.Id, subBrand.Id);
        contract1.ASI_CRM_Area_Code__c       = '123456';
        contract1.ASI_CRM_Contract_Number__c = 'Testing Contract 1';
        contract1.ASI_CRM_Contract_Status__c = 'Approved';
        contract1.RecordTypeId               = Global_RecordTypeCache.getRtId('ASI_CRM_VN_Contract__c' + 'ASI_CRM_VN_Capsule_Agreement_Contract');
        contract1.ASI_CRM_Start_Date__c            = Date.today().addDays(-1);
        contract1.ASI_CRM_End_Date__c              = Date.today();

        ASI_CRM_VN_Contract__c contract2 = ASI_CRM_VN_TestClassHelper.createContract(onTradeCustomer.Id, subBrand.Id);
        contract2.ASI_CRM_Area_Code__c       = '123456';
        contract2.ASI_CRM_Contract_Number__c = 'Testing Contract 1';
        contract2.ASI_CRM_Contract_Status__c = 'Approved';
        contract2.RecordTypeId               = Global_RecordTypeCache.getRtId('ASI_CRM_VN_Contract__c' + 'ASI_CRM_VN_Capsule_Agreement_Contract');
        contract1.ASI_CRM_Start_Date__c            = Date.today().addDays(1);
        contract1.ASI_CRM_End_Date__c              = Date.today().addDays(2);

        insert contract1;
        insert contract2;

        contract2.ASI_CRM_Start_Date__c = Date.today();
        update contract2;

//        try {
//            insert contract2;
//        } catch (Exception e) {
//            System.assert(e.getMessage().contains(Label.ASI_CRM_VN_DuplicateContract));
//        }

//        ASI_CRM_VN_Contract_Duplication controller = new ASI_CRM_VN_Contract_Duplication();
//        controller.compare(contract1, contract2);
    }
}