/**
    About
    -----
    Description: test class for ESN_MB_OverviewCockpit_Cx class of MyBrands Cockpit Overview
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jan 2015

    Details
    -------
    This class contains unit tests for ESN_MB_OverviewCockpit_Cx class
    
    Update History
    --------------
    Jan 2015 / Created by Valentin PLITTA

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_OverviewCockpit_Cx_Test {
    
    static testMethod void retrieveBrandNamesTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        List<ESN_MB_NodePage__c> resultList = ESN_MB_OverviewCockpit_Cx.retrieveBrandNames();
        System.assertEquals(1, resultList.size());
        
        List<ESN_MB_NodePage__c> resultList2 = ESN_MB_OverviewCockpit_Cx.retrieveBrandNames2();
        System.assertEquals(1, resultList2.size());
       
        // Test method
        String result = ESN_MB_OverviewCockpit_Cx.getBrandNames();
        System.assert(String.isNotEmpty(result));
    }
    static testMethod void brandStatusToEnableTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        List<String> listBrandId = new List<String>();
        listBrandId.add(brandRecordTypeId);
        
        // Test method
        ESN_MB_OverviewCockpit_Cx.brandStatusToEnable(listBrandId);
    }
    
    static testMethod void brandStatusToWIPTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        List<String> listBrandId = new List<String>();
        listBrandId.add(brandRecordTypeId);
        
        // Test method
        ESN_MB_OverviewCockpit_Cx.brandStatusToWIP(listBrandId);
    }
    
    static testMethod void brandStatusToArchiveTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        List<String> listBrandId = new List<String>();
        listBrandId.add(brandRecordTypeId);
        
        // Test method
        ESN_MB_OverviewCockpit_Cx.brandStatusToArchive(listBrandId); 
    }
    
    static testMethod void reformatBrandNameTest() {
        
        // Test method
        String result = ESN_MB_OverviewCockpit_Cx.reformatBrandName('Test');
        System.assert(String.isNotEmpty(result));
    }
    
    static testMethod void updateBrandInformationsTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        
        brand.ESN_MB_NorthPlains_Portal_URL__c = 'nPUrl';
        brand.ESN_MB_ChatterGroup_Id__c = 'chatterGroupId';
        brand.ESN_MB_Default_Brand_Variant_Value__c = 'defaultBrandVariantValue';
        brand.ESN_MB_Order__c = 10.0;
        brand.ESN_MB_Brand_DAM_Id__c = 'brandDAMId';
        brand.ESN_MB_Brand_Category__c = 'brandCategory';
        
        // Test method
        ESN_MB_OverviewCockpit_Cx.updateBrandInformations('Test', 'Test','Test','Test',10.0,'noUpdateForImage',brand.Id,'Test','Test','Test','Test','Test','Test'); 
    }
    
    static testMethod void getCurrentBrandSRURLTest() {
        // Test method
        String brandCssLeCercle = ESN_MB_OverviewCockpit_Cx.getCurrentBrandSRURL('LeCercle');
        String brandCss = ESN_MB_OverviewCockpit_Cx.getCurrentBrandSRURL('TOP14');
    }
    
    static testMethod void getIsCockpitAdministratorTest() {
        User standardUer = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        ESN_MB_OverviewCockpit_Cx cx = new ESN_MB_OverviewCockpit_Cx();
        
        System.RunAs(standardUer) {
            // Test method
            boolean result = cx.getIsCockpitAdministrator();
        }
    }
    
    static testMethod void createNewBrandTest() {
       String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
       ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        
       // Test method with 'Campaign' rubric
       ESN_MB_NodePage__c campaignRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('Campaign', 10.0, null);
        
       // Test method
       ESN_MB_OverviewCockpit_Cx.createNewBrand('Test','R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=','Test');
       ESN_MB_OverviewCockpit_Cx.createNewBrand('Test','R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=','LeCercle');
    }
    
    static testMethod void updateAttachmentTileTest() {
        String brandRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_BRAND'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand', brandRecordTypeId, 10.0);

        String cssRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_CSS'].Id;
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('logo1', cssRecordTypeId, 'Tile');

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(brandNodePage, resource);

        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);
         
        // Test method
        ESN_MB_OverviewCockpit_Cx.updateAttachmentTile(brandNodePage.Id,'R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=','nameLogo');
    }
    
    static testMethod void retrieveAssignedBrandTest() {
       ESN_MB_OverviewCockpit_Cx.retrieveAssignedBrand();
    }
    
     static testMethod void retrieveLogosIdsTest() {
        String imageRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_IMAGE');
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('image.jpg', imageRTId, 'Tile');

        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(brand, resource);
        
        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);

        // Test method
        List<String> resultList = ESN_MB_OverviewCockpit_Cx.retrieveLogosIds();
        System.assertEquals(1, resultList.size());
        
        // Test method
        List<String> resultList2 = ESN_MB_OverviewCockpit_Cx.retrieveLogosIds2();
        System.assertEquals(1, resultList2.size());
        
         // Test method
        String result = ESN_MB_OverviewCockpit_Cx.getLogosIds();
        System.assert(String.isNotEmpty(result));
    }
    static testMethod void retrieveSectionsValuesTest() {
        Map<String, List<SelectOption>> resultList = ESN_MB_OverviewCockpit_Cx.retrieveSectionsValues();
    }
    static testMethod void grantSREditorPSTest() {
        ESN_MB_OverviewCockpit_Cx.grantSREditorPS();
        ESN_MB_OverviewCockpit_Cx.removeSREditorPS();
    }    
    static testMethod void getCurrentBrandStaticResourceURLTest() {
        ESN_MB_OverviewCockpit_Cx.getCurrentBrandStaticResourceURL('test');
    }
}