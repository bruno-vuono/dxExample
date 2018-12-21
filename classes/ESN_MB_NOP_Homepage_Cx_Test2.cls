@isTest
public class ESN_MB_NOP_Homepage_Cx_Test2 {

    static testMethod void retrieveRubricListAsBroadcasterTest() {
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        User broadcasterUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getBroadcasterUser('brandName');
        System.RunAs(broadcasterUser) {
            // Create article
            ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, null, true, null);
    
            // Create rubric
            String rubricRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Rubric'].Id;
            ESN_MB_NodePage__c rubricNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('rubricName', rubricRTId, 10.00, 'Assets');
    
            ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article, rubricNodePage);

            List<ESN_MB_NodePage__c> nodeList = ESN_MB_NOP_Homepage_Cx.retrieveRubricList('brandName');
            //System.assertEquals(1, nodeList.size());
        }
    }

    static testMethod void retrieveRubricListAsStandardUserTest() {
        // Get the record type ids needed
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        String brandActivationRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand_Activation'].Id;
        String productRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        String rubricRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Rubric'].Id;
        
        // Create a brand
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        
        // Create a masterbrand of the brand 
        ESN_MB_NodePage__c productMasterbrand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMasterbrand('productMasterbrand', 10.0, brandNodePage.Id);
        
        // Create another product of the brand
        ESN_MB_NodePage__c productNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('productName', 20.0, brandNodePage.Id);
        
        // Create rubrics
        ESN_MB_NodePage__c rubricNodePage1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('rubric1', rubricRTId, 10.00, 'Strategy');
        ESN_MB_NodePage__c rubricNodePage2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('rubric2', rubricRTId, 10.00, 'Brand Activations Library');
        
        // Create the news cover rubric 
        ESN_MB_NodePage__c rubricNewsCover = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('News Cover', rubricRTId, 40.00, 'History & Education');
        
        // Create the news cover custom settings (contains the id of the rubric)
        ESN_MB_MyBrandsSettings__c csNewsCover = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMyBrandsCS(null, null,null,null,null,rubricNewsCover.Id, null, null, null,null,null,null);
            
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
		
        System.RunAs(standardUser) {
            // Create articles            
            ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);
            ESN_MB_Article__c article2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article2', brandNodePage.Id, 'Published', true, null);
    
            // Create activations
            ESN_MB_Activation__c activation1 =  ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(brandActivationRTId, productNodePage.Id, 'Published', null, 'rubric2', null);
    
            // Create the entries to link the articles to the rubrics
            ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article1, rubricNodePage1);
            ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleRubricEntry(article2, rubricNodePage1);
			
            List<ESN_MB_NodePage__c> nodeList = ESN_MB_NOP_Homepage_Cx.retrieveRubricList('brandName');
            //System.assertEquals(2, nodeList.size());
        }

    }

    static testMethod void retrieveParentProductIdTest() {
        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);

        String activationAssetsRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand_Activation'].Id;
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationAssetsRecordTypeId, product.Id, null, null, null, null);

        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Published', false, null);

        String parentProductId = ESN_MB_NOP_Homepage_Cx.retrieveParentProductId(activation.Id, 'activation');
        System.assert(String.isNotEmpty(parentProductId));

        String parentProductIdArticle = ESN_MB_NOP_Homepage_Cx.retrieveParentProductId(article.Id, 'article');
        System.assert(String.isNotEmpty(parentProductIdArticle));
    }

    static testMethod void retrieveLogosIdsTest() {
        String brandRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_BRAND'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand', brandRecordTypeId, 10.0);

        String cssRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_CSS'].Id;
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('logo1', cssRecordTypeId, 'Tile');

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(brandNodePage, resource);

        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);
        Attachment attachment2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment2', resource);
        Attachment attachment3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment3', resource);

        // Test Method
        List<String> logoList = ESN_MB_NOP_Homepage_Cx.retrieveLogosIds();
        System.assertEquals(3, logoList.size());
    }

    static testMethod void retrieveProductsLogosIdsTest() {
        // Create products
        String brandRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('brand1', brandRecordTypeId, 10.0, null);

        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c productNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product1', productRecordTypeId, 10.0, brandNodePage.Id);

        String cssRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_CSS'].Id;
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('logo1', cssRecordTypeId, 'Tile');

        ESN_MB_Entry__c product1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, resource.Id);
        ESN_MB_Entry__c product2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, resource.Id);
        ESN_MB_Entry__c product3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProductEntry(productNodePage.Id, resource.Id);

        // Create attachments
        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);

        // Test Method
        List<String> productList = ESN_MB_NOP_Homepage_Cx.retrieveProductsLogosIds(brandNodePage.Id);
        System.assertEquals(3, productList.size());
    }

    static testMethod void retrieveArticleTest() {
        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);

        ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Published', false, null);

        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article1 , asset1); 

        ESN_MB_NOP_Article_DTO articleDTO = ESN_MB_NOP_Homepage_Cx.retrieveArticle(article1.Id);
        System.assert(articleDTO != null);        
    }
    
    static testMethod void findUltimateParentCreatedDateTest() {
        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);

        ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Published', false, null);

        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article1 , asset1); 

        Datetime createdDateUltimateParent = ESN_MB_NOP_Homepage_Cx.findUltimateParentCreatedDate(article1.Id);
        System.assert(createdDateUltimateParent != null);        
    }

    static testMethod void retrieveAssetsByFilterTest() {
        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;

        // TODO : filter is for taxonomy' fields. retrieveAssetsByFilter() method is not well developed
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);
        ESN_MB_Asset__c asset2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);
        ESN_MB_Asset__c asset3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        // Test Method
        List<ESN_MB_Asset__c> assetList = ESN_MB_NOP_Homepage_Cx.retrieveAssetsByFilter('Whiskey');

        System.assertEquals(3, assetList.size());        
    }

    static testMethod void deleteArticleTest() {
        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);

        ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Published', false, null);

        ESN_MB_NOP_Homepage_Cx.deleteArticle(article1.Id);
        List<ESN_MB_Article__c> articleStillInBaseList = [Select Id From ESN_MB_Article__c Where Id = :article1.Id];
        System.assertEquals(0, articleStillInBaseList.size());        
    }

    static testMethod void ESN_MB_NOP_Homepage_CxTest() {
        String northPlainsUrl = 'http://www.test.com';
		// Create a brand
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);
		
        // Create a masterbrand of the brand
        ESN_MB_NodePage__c productMasterbrand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMasterbrand('productMasterbrand', 10.0, brand.Id);	
        
        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);

        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();

        // Test getNorthPlainsPortalUrl
        String urlResult = homepage.getNorthPlainsPortalUrl();
        System.assertEquals(northPlainsUrl, urlResult);        
    }

    static testMethod void retrieveBrandSocialLinksTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandWithSocialLinks('brand1', 'facebook.com', 'flickr.com', 'googlePlus.com',
                                                                                                'twitter.com', 'youtube.com');
        ESN_MB_NodePage__c result = ESN_MB_NOP_Homepage_Cx.retrieveBrandSocialLinks(brand.Id);
        System.assert(result != null);
    }

   /* NE PAS DECOMMENTER
    static testMethod void getNPUrlTest() {
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        String result = homepage.getNPUrl();
        System.assert(result != null);
    }
    
    static testMethod void getPOSUrlTest() {
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        String result = homepage.getPOSUrl();
        System.assert(result != null);
    }
	*/
    
    /* NE PAS DECOMMENTER
    static testMethod void getCurrentBrandStaticResourceTest() {
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        String result = homepage.getCurrentBrandStaticResource();
        System.assert(result != null);
    }
    
    static testMethod void getcurrentBrandCssURLTest() {
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        String result = homepage.getcurrentBrandCssURL();
    }
    
    static testMethod void getBrandResourceNameTest() {
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        String result = homepage.getBrandResourceName();
        System.assert(result != null);
    }*/

    static testMethod void getBreadCrumbValuesTest() {
        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product', productRecordTypeId, 10.0);

        ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', product.Id, 'Published', false, null);

        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article1 , asset1); 
  
        // TO FIX : error in Staging
//        String result = ESN_MB_NOP_Homepage_Cx.getBreadCrumbValues('Article',article1.Id,'');
//        System.assert(result != null);
        
        String northPlainsUrl = 'http://www.test.com';

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);
        
        String result2 = ESN_MB_NOP_Homepage_Cx.getBreadCrumbValues('forum',brand.Id,'');
        System.assert(result2 != null);
                
        String result3 = ESN_MB_NOP_Homepage_Cx.getBreadCrumbValues('Influencers',product.Id,'');
        System.assert(result3 != null);

        String rubricRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Rubric'].Id;
        ESN_MB_NodePage__c rubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('rubricName', rubricRTId, 10.00, 'Assets');
        result3 = ESN_MB_NOP_Homepage_Cx.getBreadCrumbValues('Influencers',rubric.Id,'');
        System.assert(result3 != null);
        
      //  String result4 = ESN_MB_NOP_Homepage_Cx.getBreadCrumbValues('article-global-activation','','');
      //  System.assert(result4 != null);
    }

   /* NE PAS DECOMMENTER
    static testMethod void isBroadCasterUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Homepage_Cx.isBroadCasterUser();
        }
    }
    static testMethod void getIsBasicUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        System.RunAs(standardUser) {
            boolean result = homepage.getIsBasicUser();
        }
    }
    
    static testMethod void retrieveGlobalActivationTest() {
        List<ESN_MB_NodePage__c> nodeList = ESN_MB_NOP_Homepage_Cx.retrieveRubricList('brandName');
        ESN_MB_NodePage__c result = ESN_MB_NOP_Homepage_Cx.retrieveGlobalActivation();
    }
    
    
    static testMethod void isBroadCasterAssignedTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Homepage_Cx.isBroadCasterAssigned(brand.Id);
        }
    }
	*/
}