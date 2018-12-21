/**
    About
    -----
    Description: test class for ESN_MB_Homepage_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_Article_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_Article_Cx_Test {

    static testMethod void prepareDTOFromArticleTest() {
        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, null, true, null);

        ESN_MB_Entry__c entry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article, asset);

        List<ESN_MB_Entry__c> entryList = new List<ESN_MB_Entry__c>();
        entryList.add(entry);

        ESN_MB_NOP_Article_DTO result = ESN_MB_NOP_Article_Cx.prepareDTOFromArticle(article, entryList);
        System.assert(result != null);
    }

    static testMethod void cloneArticleStageDraftTest() {
        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        ESN_MB_Entry__c entry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article, asset);

        ESN_MB_NOP_Article_DTO result = ESN_MB_NOP_Article_Cx.cloneArticleStageDraft(article.Id);
        System.assert(result != null);
    }

    static testMethod void createArticleTest() {
        //Create a rubric in which shall be assigned the articles
        String rubricRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Rubric'].Id;
        ESN_MB_NodePage__c rubric1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('rubric1', rubricRecordTypeId, 10.0);
        ESN_MB_NodePage__c rubric2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('rubric2', rubricRecordTypeId, 10.0);

        List<String> rubricIdList = new List<String>();
        rubricIdList.add(rubric1.Id);
        rubricIdList.add(rubric2.Id);

        ESN_MB_NOP_Article_DTO result = ESN_MB_NOP_Article_Cx.createArticle(null, null, null, null, null, rubricIdList, null, null);
        System.assert(result != null);
    }

    static testMethod void publishArticleTest() {
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        ESN_MB_Article__c parentArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('parent article', brandNodePage.Id, 'Published', true, null);
        ESN_MB_Article__c draftArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('draft article', brandNodePage.Id, 'Draft', true, parentArticle.Id);

        // Test method with existing article
        ESN_MB_NOP_Article_Cx.publishArticle(draftArticle.Id, 'draft article updated', 'articleAbstract', 'articleTopText', 'articleBotText', 'embeddedVideo', new List<String> {brandNodePage.Id}, 'linkRelatedAssetsDAM', false);
        
        List<ESN_MB_Article__c> articleStillInBaseList = 
            [Select Id, Name, ESN_MB_Stage__c, ESN_MB_AlsoInMasterbrand__c From ESN_MB_Article__c Where Id = :draftArticle.Id];
        System.assertEquals(1, articleStillInBaseList.size());
        System.assertEquals('Archived', articleStillInBaseList.get(0).ESN_MB_Stage__c);
        System.assertEquals(false, articleStillInBaseList.get(0).ESN_MB_AlsoInMasterbrand__c);

        articleStillInBaseList = 
            [Select Id, Name, ESN_MB_Stage__c, ESN_MB_AlsoInMasterbrand__c From ESN_MB_Article__c Where Id = :parentArticle.Id];
        System.assertEquals(1, articleStillInBaseList.size());
        System.assertEquals('Published', articleStillInBaseList.get(0).ESN_MB_Stage__c);
        System.assertEquals(false, articleStillInBaseList.get(0).ESN_MB_AlsoInMasterbrand__c);
    }

    static testMethod void updateArticleTest() {
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        // Test method with existing article
        ESN_MB_NOP_Article_Cx.updateArticle(article.Id, 'article1 updated', 'articleAbstract', 'articleTopText', 'articleBotText', 'embeddedVideo', new List<String> {brandNodePage.Id}, 'linkRelatedAssetsDAM', false);

        List<ESN_MB_Article__c> articleStillInBaseList = 
            [Select Id, Name, ESN_MB_Abstract__c, ESN_MB_Top_Text__c, ESN_MB_Bottom_Text__c, ESN_MB_AlsoInMasterbrand__c From ESN_MB_Article__c Where Id = :article.Id];
        System.assertEquals(1, articleStillInBaseList.size());
        System.assertEquals('article1 updated', articleStillInBaseList.get(0).Name);
        System.assertEquals('articleAbstract', articleStillInBaseList.get(0).ESN_MB_Abstract__c);
        System.assertEquals('articleTopText', articleStillInBaseList.get(0).ESN_MB_Top_Text__c);
        System.assertEquals('articleBotText', articleStillInBaseList.get(0).ESN_MB_Bottom_Text__c );
        System.assertEquals(false, articleStillInBaseList.get(0).ESN_MB_AlsoInMasterbrand__c);

        // Test method with inexisting article
        try {
            ESN_MB_NOP_Article_Cx.updateArticle('99999', 'article1 updated', 'articleAbstract', 'articleTopText', 'articleBotText', 'embeddedVideo', null, 'linkRelatedAssetsDAM', false);
        } catch (QueryException e) {
           System.assert(e.getMessage().contains('no rows'), 'message=' + e.getMessage());
        }
    }

    static testMethod void retrieveArticleNodePageListTest() {
        String productRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Product'].Id;
        ESN_MB_NodePage__c product1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product1', productRecordTypeId, 10.0);
        ESN_MB_NodePage__c product2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('product2', productRecordTypeId, 10.0);

        List<ESN_MB_NodePage__c> resultList = ESN_MB_NOP_Article_Cx.retrieveArticleNodePageList();
        System.assertEquals(2, resultList.size());
    }

    static testMethod void retrieveLinkedArticlesTest() {
        // Create See Also Article entry
        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c seeAlsoArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleSeeAlso', brandNodePage.Id, 'Published', true, null);

        ESN_MB_Article__c articleParent = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleParent', brandNodePage.Id, 'Published', true, null);

        String articleRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Articles_To_Articles'].Id;
        ESN_MB_Entry__c entryArticleSeeAlso = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleSeeAlsoEntry(articleParent, seeAlsoArticle, articleRecordTypeId);

        // create MainAsset entry
        ESN_MB_Entry__c entryArticleMainAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(seeAlsoArticle, asset, 'MainAsset');

        // create articleToRubric entry
        String articleRubricRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Articles_To_Rubrics'].Id;
        ESN_MB_Entry__c entryArticleToRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleEntry(articleParent, articleRubricRTId);
        
        // Test method
        List<ESN_MB_NOP_Related_Article_DTO> resultList = ESN_MB_NOP_Article_Cx.retrieveLinkedArticles(articleParent.Id);
        //System.assertEquals(1, resultList.size());
    }

    static testMethod void retrieveLinkedAssetsTest() {
        String articlesToAssetsRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Assets');

        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        ESN_MB_Entry__c entryArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleEntry(article, articlesToAssetsRTId);

        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_Article_Cx.retrieveLinkedAssets(article.Id);
        System.assertEquals(1, resultList.size());
    }

    static testMethod void deleteRelatedArticleEntryTest() {
        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        ESN_MB_Article__c seeAlsoArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleSeeAlso', brandNodePage.Id, 'Published', true, null);
        ESN_MB_Article__c articleParent = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleParent', brandNodePage.Id, 'Published', true, null);

        String articleRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Articles_To_Articles'].Id;
        ESN_MB_Entry__c entryArticleSeeAlso = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleSeeAlsoEntry(articleParent, seeAlsoArticle, articleRecordTypeId);

        // Test method
        ESN_MB_NOP_Article_Cx.deleteRelatedArticleEntry(articleParent.Id, seeAlsoArticle.Id);

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where ESN_MB_Article__c = :articleParent.Id And ESN_MB_Article_See_Also__c = :seeAlsoArticle.Id];
        System.assertEquals(0, resultList.size());
    }

    static testMethod void createEntryAssetArticleTest() {
        // Create article
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        // Create asset
        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String roleAsset = 'MainAsset';

        // Test method
        String result = ESN_MB_NOP_Article_Cx.createEntryAssetArticle(article.Id, asset.Id, roleAsset);
        System.assert(String.isNotBlank(result));

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where ESN_MB_Article__c = :article.Id And ESN_MB_Asset__c = :asset.Id And ESN_MB_RoleAsset__c = :roleAsset];
        System.assertEquals(1, resultList.size());
    }

    static testMethod void setMainAssetTest() {
        // Create old entries
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        ESN_MB_Entry__c entry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article, asset, 'MainAsset');

        // Test method
        String result = ESN_MB_NOP_Article_Cx.setMainAsset(article.Id, asset.Id);
        System.assert(String.isNotBlank(result));

        List<ESN_MB_Entry__c> resultList = [Select Id, ESN_MB_RoleAsset__c From ESN_MB_Entry__c Where ESN_MB_Article__c = :article.Id];
        System.assertEquals(1, resultList.size());
        System.assertEquals('MainAsset', resultList.get(0).ESN_MB_RoleAsset__c);
    }

    static testMethod void deleteEntryAssetArticleTest() {
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        String assetRecordTypeId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_DAM_Asset'].Id;
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String roleAsset = 'MainAsset';

        ESN_MB_Entry__c entry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article, asset, roleAsset);

        // Test method
        String result = ESN_MB_NOP_Article_Cx.deleteEntryAssetArticle(article.Id, asset.Id, roleAsset);
        System.assert(String.isNotBlank(result));

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where ESN_MB_Article__c = :article.Id And ESN_MB_Asset__c = :asset.Id And ESN_MB_RoleAsset__c = :roleAsset];
        System.assertEquals(0, resultList.size());
    }

    static testMethod void deleteArticleTest() {
        String brandRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Brand'].Id;
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        ESN_MB_NOP_Article_Cx.deleteArticle(article.Id);

        List<ESN_MB_Article__c> resultList = [Select Id From ESN_MB_Article__c Where Id = :article.Id];
        System.assertEquals(0, resultList.size());
    }
}