@isTest
public class EUR_CRM_TestObjPromoRedirectPageCtrl{

    @isTest
    public static void testRedirect(){
        EUR_CRM_DE_TestClassUtilityHelper.initOffTradeUsers();
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.offTradeNationalManager){
            EUR_CRM_DE_TestClassUtilityHelper.initOffTradeDataSet();  
            EUR_CRM_DE_TestClassUtilityHelper.creaActionListTemplate('test323','DE_OFF_ALT_Sales_Drive' ,EUR_CRM_DE_TestClassUtilityHelper.DE_ACTION_LIST_TEMPLATE_RECORD_TYPE  );
            EUR_CRM_ObjPromo__c objPromo = EUR_CRM_DE_TestClassUtilityHelper.createObjPromo(
            1,EUR_CRM_DE_TestClassUtilityHelper.OP_DE_SALES_DRIVE,'test')[0];
            objPromo.EUR_CRM_Active_Start_Date__c = Date.newInstance(2017, 07,02);
            //objPromo.EUR_CRM_Customer_Taxonomy__c = EUR_CRM_DE_TestClassUtilityHelper.customerTaxonomy.id;
            insert objPromo;
            objPromo = [SELECT Id, RecordTypeId, RecordType.DeveloperName From EUR_CRM_ObjPromo__c WHERE Id = :objPromo.Id];
            Apexpages.StandardController sc = new Apexpages.standardController(objPromo);
            EUR_CRM_ObjPromoRedirectPageController con = new EUR_CRM_ObjPromoRedirectPageController(sc );
            
            PageReference pr = con.redirect();
            system.Assert(pr != null ); 
        }
    }
}