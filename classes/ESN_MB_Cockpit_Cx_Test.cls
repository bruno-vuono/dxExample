/**
    About
    -----
    Description: test class for ESN_MB_Cockpit_Cx class of MyBrands Cockpit
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jan 2015

    Details
    -------
    This class contains unit tests for ESN_MB_Cockpit_Cx class
    
    Update History
    --------------
    Jan 2015 / Created by Valentin PLITTA

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_Cockpit_Cx_Test {
    
    static testMethod void reformatBrandNameTest() {
        String result = ESN_MB_Cockpit_Cx.reformatBrandName('Test');
        System.assert(String.isNotEmpty(result));
    }
    
    static testMethod void getCurrentBrandSRURLTest() {
        String northPlainsUrl = 'http://www.test.com';

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);

        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);
        
        ESN_MB_Cockpit_Cx cx = new ESN_MB_Cockpit_Cx();
        
        String brandCss = cx.getCurrentBrandSRURL();
        System.assert(String.isEmpty(brandCss));
    }
    
    static testMethod void retrieveBrandNamesTest() {
        String northPlainsUrl = 'http://www.test.com';

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);

        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);

        List<ESN_MB_NodePage__c> resultList = ESN_MB_Cockpit_Cx.retrieveBrandNames();
        System.assertEquals(1, resultList.size());
       
        ESN_MB_Cockpit_Cx cx = new ESN_MB_Cockpit_Cx();
        String result = cx.getBrandNames();
        System.assert(String.isNotEmpty(result));
        
        map<String,String> resultMap = cx.getBrand();
    }
    
    static testMethod void getBackgroundExistTest() {
        
        String northPlainsUrl = 'http://www.test.com';

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);

        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);
        
        ESN_MB_Cockpit_Cx.manageBackground('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', brand.Id, 'brand', false);

        String cssRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_CSS'].Id;
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('logo1', cssRecordTypeId, 'Background');

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(brand, resource);

        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);
        
        ESN_MB_Cockpit_Cx cx = new ESN_MB_Cockpit_Cx();
        String result = cx.getBackgroundExist();
        System.assert(String.isNotEmpty(result));
        
        ESN_MB_Cockpit_Cx.manageBackground('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', brand.Id, 'brand', true);
        ESN_MB_Cockpit_Cx.manageBackground('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', brand.Id, 'brand', false);
    }
    
   static testMethod void getPortfolioBackgroundExistTest() {
        String northPlainsUrl = 'http://www.test.com';

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);

        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);
        
        ESN_MB_Cockpit_Cx.managePortfolioBackground('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', brand.Id, 'brand', false);

        String cssRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_CSS'].Id;
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('logo1', cssRecordTypeId, 'PortfolioBackground');

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(brand, resource);
        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);
        
        ESN_MB_Cockpit_Cx cx = new ESN_MB_Cockpit_Cx();
        String result = cx.getPortfolioBackgroundExist();
        System.assert(String.isNotEmpty(result));
        
        ESN_MB_Cockpit_Cx.managePortfolioBackground('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', brand.Id, 'brand', true);
        ESN_MB_Cockpit_Cx.managePortfolioBackground('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', brand.Id, 'brand', false);
   }
    
    static testMethod void constructorTest() {
        String northPlainsUrl = 'http://www.test.com';

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);

        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);
        ESN_MB_Cockpit_Cx cx = new ESN_MB_Cockpit_Cx();
        cx.getBrand();
    }
    
    static testMethod void retrieveSocialLinksTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandWithSocialLinks('brand1', 'facebook.com', 'flickr.com', 'googlePlus.com',
                                                                                                'twitter.com', 'youtube.com');
        List<ESN_MB_NOP_SocialLinks_DTO> result = ESN_MB_Cockpit_Cx.retrieveSocialLinks(brand.Id);
        System.assert(result != null);
    }
    
    static testMethod void updateSocialLinksTest() {
       String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
       ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageDisable('brand1', brandRecordTypeId, 10.0);
        
       

       ESN_MB_Cockpit_Cx.updateSocialLinks('facebook.com', 'flickr.com', 'googlePlus.com','twitter.com', 'youtube.com','twitter.com', 'youtube.com',brand.Id);
    }
    
    
     static testMethod void retrieveInformationCockpitTest() {
        ESN_MB_NOP_Product_DTO product2 = new ESN_MB_NOP_Product_DTO();
         
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('brand1', brandRecordTypeId, 10.0, null);
         
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);
         
        String cssRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_CSS'].Id;
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('logo1', cssRecordTypeId, 'Background');

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(product, resource);

        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);
         
        product2.productId = product.Id;
        product2.productName = 'bottle1';
        product2.brandId = brandNodePage.Id;
        product2.order = 10.0;
        product2.image = 'noUpdateForImage';
        product2.productBrandVariant = 'newProduct2';
        product2.isMasterbrand = true;

        ESN_MB_Cockpit_Cx.retrieveInformationCockpit(brandNodePage.Id);
    }
    
    static testMethod void deleteBottleTest() {
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);
        
        List<String> productListId = new List<String>();
        productListId.add(product.Id);
        ESN_MB_Cockpit_Cx.deleteBottle(productListId);
    }
    
    static testMethod void manageListBottleTest() {
        
        ESN_MB_NOP_Product_DTO product1 = new ESN_MB_NOP_Product_DTO();
        ESN_MB_NOP_Product_DTO product2 = new ESN_MB_NOP_Product_DTO();
        List<ESN_MB_NOP_Product_DTO> listProductDTO = new List<ESN_MB_NOP_Product_DTO>();
        
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('brand1', brandRecordTypeId, 10.0, null);
        
        product1.productId = 'newProduct';
        product1.productName = 'masterbrand';
        product1.brandId = brandNodePage.Id;
        product1.order = 10.0;
        product1.image = 'R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';
        product1.productBrandVariant = 'newProduct';
        product1.isMasterbrand = true;

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c productNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product1', productRecordTypeId, 10.0, brandNodePage.Id);

        ESN_MB_Entry__c productEntry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, null);
        
        product2.productId = productNodePage.Id;
        product2.productName = 'bottle1';
        product2.brandId = brandNodePage.Id;
        product2.order = 20.0;
        product2.image = 'noUpdateForImage';
        product2.productBrandVariant = 'newProduct2';
        product2.isMasterbrand = false;
        
        listProductDTO.add(product1);
        listProductDTO.add(product2);

        ESN_MB_Cockpit_Cx.manageListBottle(listProductDTO);
    }
    static testMethod void bottleCanBeDeletedTest() {
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);
        ESN_MB_Cockpit_Cx.bottleCanBeDeleted(product.Id);
    }  
    static testMethod void grantSREditorPSTest() {
        ESN_MB_Cockpit_Cx.grantSREditorPS();
        ESN_MB_Cockpit_Cx.removeSREditorPS();
    }
}