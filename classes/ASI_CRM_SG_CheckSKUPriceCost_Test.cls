/*********************************************************************************
 * Name:ASI_CRM_SG_CheckSKUPriceCost_Test
 * Description: Test class for ASI_CRM_SG_CheckSKUPriceCost_Batch
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2017-05-15       Laputa: Hugo Cheung     Created
*********************************************************************************/
@isTest
public class ASI_CRM_SG_CheckSKUPriceCost_Test {
    
    @TestSetup
    public static void initData() {
    	ASI_CRM_SG_TestClassHelper.createDataSettings();
        ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();
    }
    
    public static testMethod void ASI_CRM_SG_CheckSKUPriceCost_Test() {
        Database.executeBatch(new ASI_CRM_SG_CheckSKUPriceCost_Batch());
    }
}