/**********************************************************************************
 * Name : ASI_CRM_SG_ContractCloneController
 * Created : DC @02/02/2016 12:58 PM
 * Revision History:
 * 1. 02/02/2016 - [DC 1.0] Created
 **********************************************************************************/

@isTest
private class ASI_TnE_TW_ClaimHeaderTriggerClass_Test {
 
    private static TestMethod void testDeletionWithoutDetails() {

        ASI_MFM_PO__c testPo = ASI_TnE_TW_TestClassHelper.createPO();
        System.Test.startTest();
        ASI_TnE_ClaimHeader__c testHeader =
            ASI_TnE_TW_TestClassHelper.createClaimHeader('Inv-0001', 'ASI_TnE_ClaimHeader__cASI_TnE_TW_Claim_Header');

        insert testHeader;
        delete testHeader;
        System.Test.stopTest();

    }

    private static TestMethod void testDeletionWithDetails() {

        ASI_MFM_PO__c testPo = ASI_TnE_TW_TestClassHelper.createPO();
        System.Test.startTest();
        ASI_TnE_ClaimHeader__c testHeader =
            ASI_TnE_TW_TestClassHelper.createClaimHeader('Inv-0001', 'ASI_TnE_ClaimHeader__cASI_TnE_TW_Claim_Header');

        insert testHeader;
        ASI_TnE_ClaimDetail__c testDetail =
            ASI_TnE_TW_TestClassHelper.createClaimDetail(
                testHeader.Id,
                'ASI_TnE_ClaimDetail__cASI_TnE_TW_Claim_Detail',
                testPo.Id
            );

        insert testDetail;
        delete testHeader;
        System.Test.stopTest();

    }
}