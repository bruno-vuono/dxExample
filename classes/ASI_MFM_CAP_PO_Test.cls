/*
*    CAPEX/OPEX
*/
@isTest
public class ASI_MFM_CAP_PO_Test {

    static testMethod void testPOTrigger()
    {
        System.Test.startTest();
        ASI_MFM_CAP_TestClassHelper.createRoutePOType();
        ASI_MFM_Plan__c plan = ASI_MFM_CAP_TestClassHelper.createPlan();
        ASI_MFM_PO__c po = ASI_MFM_CAP_TestClassHelper.createPo('CAPEX', plan);
        ASI_MFM_PO__c poClone = ASI_MFM_CAP_TestClassHelper.createPoClone(po);
        
        /*
         * DC - 01/25/2016 - Added logic to improve coverage of "ASI_MFM_CAP_PO_TriggerClass"
         */
        // DC LOGIC START
        
        ASI_MFM_PO_Line_Item__c poLineItem = ASI_MFM_CAP_TestClassHelper.createPoLines(po);

        plan.ASI_MFM_Status__c = 'Final';
        update plan;

        ASI_MFM_Payment__c payment = new ASI_MFM_Payment__c
        (
            ASI_MFM_Payment_Type__c = 'CAPEX',
            ASI_MFM_Plan__c = po.ASI_MFM_Plan__c,
            ASI_MFM_Currency__c = 'HKD',
            ASI_MFM_Prefix__c= ASI_MFM_CAP_TestClassHelper.createPrefixPayment().id,
            ASI_MFM_Supplier_Name__c = ASI_MFM_CAP_TestClassHelper.createAccSupplier().id,
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Payment__cASI_MFM_CAP_Payment'),
            ASI_MFM_Is_Direct_Payment__c = true,
            ASI_MFM_Status__c = 'Draft',
            ASI_MFM_Invoice_Date__c = date.today(),
            ASI_MFM_Invoice_Number__c = '123Tesyt'
        );
        insert payment;
        System.Test.stopTest();
        
        ASI_MFM_Payment_Line_Item__c paymentLineItem = 
            ASI_MFM_CAP_TestClassHelper.createPaymentLines(payment, poLineItem);

        // DC LOGIC END

        po.ASI_MFM_Status__c = 'Submitted';
        po.ASI_MFM_Exchange_Rate__c = 0.052;
        update po;
        po.ASI_MFM_Status__c = 'Draft';
        update po;
        try {
            delete po;
        } catch(DmlException exceptionInstance) {
            System.assert(true);
        }
        // delete paymentLineItem;
        // delete po;
        delete poClone;
        
    }

    static testMethod void testInputPOItemsController()
    {
        ASI_MFM_CAP_TestClassHelper.createRoutePOType();
        ASI_MFM_PO__c PO = ASI_MFM_CAP_TestClassHelper.createPO();
        ASI_MFM_PO_Line_Item__c poLine = ASI_MFM_CAP_TestClassHelper.createPoLines(po);
        List<ASI_MFM_PO_Line_Item__c> poLineSet = new List<ASI_MFM_PO_Line_Item__c>();
        poLineSet.add(poLine);
        ApexPages.standardSetController sc = new ApexPages.standardSetController(poLineSet);
        
        PageReference inputPOItemsPage = Page.ASI_MFM_CAP_InputPOItemsPage;
        Map<String, String> pageParams = inputPOItemsPage.getParameters();
        pageParams.put('id', po.Id);
        Test.setCurrentPageReference(inputPOItemsPage);
        
        ASI_MFM_CAP_InputPOItemsController poLineItemsController =
            new ASI_MFM_CAP_InputPOItemsController(sc);

       // PO.ASI_MFM_Plan__c = ASI_MFM_CAP_TestClassHelper.createPlan().id;
       // PO.ASI_MFM_PO_Type__c = 'CAPEX';
       // update PO;
        
        ASI_MFM_PO__c poClone = ASI_MFM_CAP_TestClassHelper.createPoClone(PO);
        
        delete PO;
    }
    
    static testMethod void testPOPrefixController()
    {
    
        //ASI_MFM_Plan__c plan1 = ASI_MFM_CAP_TestClassHelper.createPlan();
        ASI_MFM_PO__c PO = ASI_MFM_CAP_TestClassHelper.createPO();
        
        ApexPages.currentPage().getParameters().put('pid',PO.ASI_MFM_Plan__c);
        ApexPages.currentPage().getParameters().put('POType','TEST');
        ApexPages.currentPage().getParameters().put('BudgetOwnerId','TEST');
        ApexPages.currentPage().getParameters().put('supplierId','TEST');
        ApexPages.currentPage().getParameters().put('RecordType',String.valueof(po.recordtypeid).substring(0,15));
            
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
        ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
        ASI_MFM_SelectPOPrefixController.getPrefixes();
        ASI_MFM_SelectPOPrefixController.proceed();
    
    }

}