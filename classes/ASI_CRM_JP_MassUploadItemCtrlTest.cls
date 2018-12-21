/*********************************************************************************
 * Name: ASI_CRM_JP_MassUploadItemCtrlTest
 * Description: Test class for ASI_CRM_JP_MassUploadItemController
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 10/07/2017       Hugo Cheung             Created          
*/
@isTest
public class ASI_CRM_JP_MassUploadItemCtrlTest {
    
    @TestSetup
    public static void setupData() {
   		ASI_CRM_JP_TestHelper.createApprovalRoute();
    }
    
    public static testMethod void testController() {
        Map<String, Object> priceListFieldValueMap = ASI_CRM_JP_TestHelper.PRICE_LIST_DEFAULT_VALUE_MAP;
        ASI_CRM_Price_List__c priceList = ASI_CRM_JP_TestHelper.createPriceList(priceListFieldValueMap);
        insert priceList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(priceList);
        ASI_CRM_JP_MassUploadItemController massUploadItemController = new ASI_CRM_JP_MassUploadItemController(sc);
        
    }
    
}