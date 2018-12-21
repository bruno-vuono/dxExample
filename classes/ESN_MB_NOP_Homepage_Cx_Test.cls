/**
    About
    -----
    Description: test class for ESN_MB_Homepage_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains unit tests for ESN_MB_Homepage_Cx class
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_Homepage_Cx_Test {
    
    static testMethod void retrieveArticlesAsBroadcasterTest() {

        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        
        User broadcasterUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getBroadcasterUser('brandName');
        System.RunAs(broadcasterUser) {
            //Create a product that will be used as parent nodepage for the articles
            String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
            
            // Create a masterbrand of the brand 
            ESN_MB_NodePage__c productMasterbrand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMasterbrand('productMasterbrand', 10.0, brandNodePage.Id);
            
            // Create another product of the brand
            ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('productName', 20.0, brandNodePage.Id);
            
            //Create a rubric in which shall be assigned the articles
            String rubricRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Rubric');
            ESN_MB_NodePage__c rubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('rubric', rubricRecordTypeId, 10.0);
            
            // Create the news cover rubric 
            ESN_MB_NodePage__c rubricNewsCover = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('News Cover', rubricRecordTypeId, 40.00, 'History & Education');
        
            // Create the news cover custom settings (contains the id of the rubric)
            ESN_MB_MyBrandsSettings__c csNewsCover = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMyBrandsCS(null, null,null,null,null,rubricNewsCover.Id, null, null, null,null,null,null);
            
            //Create 3 articles
            ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Draft', false, null);
            ESN_MB_Article__c article2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article2', product.Id, 'Archived', false, null);
            ESN_MB_Article__c article3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article3', product.Id, 'Published', false, null);
    
            //Create entries to match the articles on the rubric
            ESN_MB_Entry__c entryArticleRubric1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article1, rubric);
            ESN_MB_Entry__c entryArticleRubric2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article2, rubric);
            ESN_MB_Entry__c entryArticleRubric3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article3, rubric);
    
            //Add the entries to a list, from the last created to the first
            List<ESN_MB_Entry__c> entryArticleRubricList = new List<ESN_MB_Entry__c>();
            entryArticleRubricList.add(entryArticleRubric1);
            entryArticleRubricList.add(entryArticleRubric2);
            entryArticleRubricList.add(entryArticleRubric3);


            List<ESN_MB_NOP_Article_DTO> retrievedArticleRubricList = ESN_MB_NOP_Homepage_Cx.retrieveRubricArticles(product.Id, rubric.Id, brandNodePage.Id);
            //System.assertEquals(3, retrievedArticleRubricList.size());
        }
    }
    
    static testMethod void retrieveArticlesAsStandardUserTest() {
        // Get the needed record types ids
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        String rubricRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Rubric');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        // Create a masterbrand of the brand 
        ESN_MB_NodePage__c productMasterbrand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMasterbrand('productMasterbrand', 10.0, brandNodePage.Id);
        
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            // Create another product of the brand
            ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('productName', 20.0, brandNodePage.Id);
            
            //Create a rubric in which shall be assigned the articles
            ESN_MB_NodePage__c rubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('rubric', rubricRecordTypeId, 10.0);
            
            // Create the news cover rubric 
            ESN_MB_NodePage__c rubricNewsCover = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('News Cover', rubricRecordTypeId, 40.00, 'History & Education');
            
            // Create the news cover custom settings (contains the id of the rubric)
            ESN_MB_MyBrandsSettings__c csNewsCover = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMyBrandsCS(null, null,null,null,null,rubricNewsCover.Id, null, null, null,null,null,null);
            
            //Create 3 articles
            ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Draft', false, null);
            ESN_MB_Article__c article2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article2', product.Id, 'Published', false, null);
            ESN_MB_Article__c article3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article3', product.Id, 'Published', false, null);
    
            //Create entries to match the articles on the rubric
            ESN_MB_Entry__c entryArticleRubric1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article1, rubric);
            ESN_MB_Entry__c entryArticleRubric2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article2, rubric);
            ESN_MB_Entry__c entryArticleRubric3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article3, rubric);
    
            //Add the entries to a list, from the last created to the first
            List<ESN_MB_Entry__c> entryArticleRubricList = new List<ESN_MB_Entry__c>();
            entryArticleRubricList.add(entryArticleRubric1);
            entryArticleRubricList.add(entryArticleRubric2);
            entryArticleRubricList.add(entryArticleRubric3);

            List<ESN_MB_NOP_Article_DTO> retrievedArticleRubricList = ESN_MB_NOP_Homepage_Cx.retrieveRubricArticles(product.Id, rubric.Id, brandNodePage.Id);
            //System.assertEquals(2, retrievedArticleRubricList.size());
        }

        
    }

    static testMethod void retrieveAllAssetsTest() {
        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');

        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);
        ESN_MB_Asset__c asset2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);
        ESN_MB_Asset__c asset3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        // Test Method
        List<ESN_MB_Asset__c> assetList = ESN_MB_NOP_Homepage_Cx.retrieveAllAssets();

        System.assertEquals(3, assetList.size());        
    }

    static testMethod void retrieveBrandNamesTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');

        ESN_MB_NodePage__c brandNodePage1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        ESN_MB_NodePage__c brandNodePage2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand2', brandRecordTypeId, 10.0);
        ESN_MB_NodePage__c brandNodePage3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand3', brandRecordTypeId, 10.0);
        
        List<ESN_MB_NodePage__c> brandsNames = ESN_MB_NOP_Homepage_Cx.retrieveBrandNames();
        System.assertEquals(3, brandsNames.size());        
    }

    static testMethod void retrieveProductsTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('brand1', brandRecordTypeId, 10.0, null);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c productNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product1', productRecordTypeId, 10.0, brandNodePage.Id);

        ESN_MB_Entry__c product1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, null);
        ESN_MB_Entry__c product2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, null);
        ESN_MB_Entry__c product3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, null);

        // Test method
        List<ESN_MB_Entry__c> productList = ESN_MB_NOP_Homepage_Cx.retrieveProducts(brandNodePage.Id);
        System.assertEquals(3, productList.size());        
    }

    static testMethod void createActivationTest() {
        String activationId = ESN_MB_NOP_Homepage_Cx.createActivation();
        System.assert(String.isNotEmpty(activationId));
    }

    static testMethod void addAssetTest() {
        String contentId = '123456';

        String assetId = ESN_MB_NOP_Homepage_Cx.addAsset(contentId);
        System.assert(String.isNotEmpty(assetId));
    }

    static testMethod void matchEntryActivationAssetTest() {
        String activationAssetsRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationAssetsRecordTypeId);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Internal_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String entryId = ESN_MB_NOP_Homepage_Cx.matchEntryActivationAsset(activation.Id, asset.Id);
        System.assert(String.isNotEmpty(entryId));
    }

    static testMethod void matchEntryAssetArticleTest() {
        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Internal_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, null, true, null);

        String entryId = ESN_MB_NOP_Homepage_Cx.matchEntryAssetArticle(article.Id, asset.Id);
        System.assert(String.isNotEmpty(entryId));
    }

    static testMethod void retrieveBrandCssTest() {
        String cssRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_CSS');
        ESN_MB_Resource__c  resource    = ESN_MB_NOP_Homepage_Cx_Test_Utils.createCssResource('brandName.css', cssRTId);
        Attachment          attachment  = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('brandName.css', resource);

        String brandCss = ESN_MB_NOP_Homepage_Cx.retrieveBrandCss('brandName');
        System.assert(String.isNotEmpty(brandCss));
    }

    static testMethod void retrieveSplashScreensTest() {
        // Create article
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null, true);

        // Create rubric
        String rubricRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Rubric');
        ESN_MB_NodePage__c rubricNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('News Cover', rubricRTId, 10.00, null);

        // Create asset
        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createSplashScreenEntry(article, rubricNodePage, asset);
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createSplashScreenEntry(article, rubricNodePage, asset);
        ESN_MB_Entry__c entry3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createSplashScreenEntry(article, rubricNodePage, asset);

        // Test Method
        List<ESN_MB_Entry__c> entryList = ESN_MB_NOP_Homepage_Cx.retrieveSplashScreens('brandName');
        System.assertEquals(3, entryList.size());        
    }
    
    static testMethod void getLeCercleNewsIdTest() {
        String rubricRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Rubric');
        ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('Flash News', rubricRTId, 10.00, 'News');
        ESN_MB_NOP_Homepage_Cx.getLeCercleNewsId();
    }
    static testMethod void getLeCercleProductIdTest() {
        String productRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('LeCercle MasterBrand', productRTId, 10.00, null);
        ESN_MB_NOP_Homepage_Cx.getLeCercleProductId();
    }
    static testMethod void getCurrentCategoryTest() {
        ESN_MB_NOP_Homepage_Cx cx = new ESN_MB_NOP_Homepage_Cx();
        cx.getCurrentCategory();
    }
    static testMethod void getPortfolioBackgroundTest() {
        ESN_MB_NOP_Homepage_Cx cx = new ESN_MB_NOP_Homepage_Cx();
        cx.getPortfolioBackground();
    }
}