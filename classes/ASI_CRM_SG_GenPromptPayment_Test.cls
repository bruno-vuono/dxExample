/*********************************************************************************
 * Name: ASI_CRM_SG_GenPromptPayment_Test
 * Description: Test Class for ASI_CRM_SG_GenPromptPaymentBatch_V2
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 16/05/2017       Hugo Cheung             Created          
*/
@isTest
public class ASI_CRM_SG_GenPromptPayment_Test {
    
    @TestSetup
    public static void setupData() {
        ASI_CRM_SG_TestClassHelper.createDataSettings();
        ASI_CRM_SG_TestClassHelper.createSubBrandData();
        
        List<ASI_MFM_SKU_Code__c> skuList = ASI_CRM_SG_TestClassHelper.createSKUandPRiceData();
        
        ASI_CRM_SG_TestClassHelper.wholesalesCustomerData wholesales = new ASI_CRM_SG_TestClassHelper.wholesalesCustomerData(true);
        
        ASI_CRM_SG_TestClassHelper.receiptData receiptData = new ASI_CRM_SG_TestClassHelper.receiptData(true, wholesales.customer);
        
        List<ASI_CRM_Invoice__c> invoiceList = new List<ASI_CRM_Invoice__c>();
        for(Integer i = 0 ; i < 5 ; i++) {
            ASI_CRM_SG_TestClassHelper.invoiceData invoiceData = new ASI_CRM_SG_TestClassHelper.invoiceData(false, wholesales.customer);
            invoiceList.add(invoiceData.invoice);
        }
        insert invoiceList;
        
        List<ASI_CRM_Invoice_Line_Item__c> invoiceLineItemList = new List<ASI_CRM_Invoice_Line_Item__c>();
        for(Integer i = 0 ; i < 5 ; i++) {
        	for(ASI_CRM_Invoice__c invoice : invoiceList) {
                ASI_CRM_SG_TestClassHelper.invoiceLineItemData invoiceLineItemData = new ASI_CRM_SG_TestClassHelper.invoiceLineItemData(false, invoice);
                invoiceLineItemList.add(invoiceLineItemData.invoiceLineItem);
            }
        }
        insert invoiceLineItemList;
        
        List<ASI_CRM_Receipt_Line_Item__c> receiptLineItemList = new List<ASI_CRM_Receipt_Line_Item__c>();
        for(Integer i = 0 ; i < 5 ; i++) {
        	ASI_CRM_SG_TestClassHelper.receiptLineItemData receiptLineItemData = new ASI_CRM_SG_TestClassHelper.receiptLineItemData(false, receiptData.receipt, invoiceList.get(i));
            receiptLineItemList.add(receiptLineItemData.receiptLineItem);
        }
        insert receiptLineItemList;
    }
    
    public static testMethod void testBatch() {
        Datetime startDate = Date.today().addMonths(-1);
        Datetime endDate   = Date.today().addMonths(1);
       
        Database.executeBatch(new ASI_CRM_SG_GenPromptPaymentBatch_V2(startDate.format('yyyy-MM-dd'), endDate.format('yyyy-MM-dd')));
    }
}