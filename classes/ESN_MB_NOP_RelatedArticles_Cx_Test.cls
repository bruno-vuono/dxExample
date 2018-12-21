/**
    About
    -----
    Description: test class for ESN_MB_NOP_RelatedArticles_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_RelatedArticles_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_RelatedArticles_Cx_Test {

    static testMethod void searchRelatedArticlesTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brand.Id, 'Published', true, null);

        List<List<Object>> resultList = ESN_MB_NOP_RelatedArticles_Cx.searchRelatedArticles('article1 test', brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void searchMoreRelatedArticlesTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        ESN_MB_Article__c article1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brand.Id, 'Published', true, null);
        ESN_MB_Article__c article2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article2', brand.Id, 'Published', true, null);

        ESN_MB_Article__c lastArticle1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('lastArticle1', brand.Id, 'Published', true, null);
        List<String> lastArticleIdList = new List<String>();
        lastArticleIdList.add(lastArticle1.Id);

        List<List<Object>> resultList = ESN_MB_NOP_RelatedArticles_Cx.searchMoreRelatedArticles('article test', lastArticleIdList, brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void retrieveSelectedArticlesTest() {
        // create article entry
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, 'Published', true, null);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        ESN_MB_Entry__c entry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleAssetEntry(article, asset, 'MainAsset');

        // create rubric entry
        String articleRubricRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Rubrics');
        ESN_MB_Entry__c entryArticleToRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticleEntry(article, articleRubricRTId);

        // Test method
        List<String> articleList = new List<String>();
        articleList.add(article.Id);

        List<ESN_MB_NOP_Related_Article_DTO> resultList = ESN_MB_NOP_RelatedArticles_Cx.retrieveSelectedArticles(articleList);
        //System.assertEquals(2, resultList.size());
    }

    static testMethod void createEntryRelatedArticleTest() {
        ESN_MB_NodePage__c brandNodePage = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);

        ESN_MB_Article__c seeAlsoArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleSeeAlso', brandNodePage.Id, 'Published', true, null);
        ESN_MB_Article__c articleParent = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleParent', brandNodePage.Id, 'Published', true, null);

        // Test method
        String resultId = ESN_MB_NOP_RelatedArticles_Cx.createEntryRelatedArticle(articleParent.Id, seeAlsoArticle.Id);
        System.assert(String.isNotBlank(resultId));

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where ESN_MB_Article__c = :articleParent.Id And ESN_MB_Article_See_Also__c = :seeAlsoArticle.Id];
        System.assertEquals(1, resultList.size());
    }

    static testMethod void searchBrandActivationsTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', null);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', null);

        // Test method
        List<List<Object>> resultList = ESN_MB_NOP_RelatedArticles_Cx.searchBrandActivations('brand1 test', brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void searchMoreBrandActivationsTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', null);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', null);

        ESN_MB_Activation__c lastActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', null);
        List<String> lastActivationList = new List<String>();
        lastActivationList.add(lastActivation.Id);

        // Test method
        List<List<Object>> resultList = ESN_MB_NOP_RelatedArticles_Cx.searchMoreBrandActivations('brand1 test', lastActivationList, brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void retrieveSelectedActivationsTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brandNodePage1.Id);

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, null, null);

        // create entry
        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');

        List<String> activationIdsList = new List<String>();
        activationIdsList.add(activation.Id);

        // Test method
        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_RelatedArticles_Cx.retrieveSelectedActivations(activationIdsList);
        System.assertEquals(1, resultList.size());
    }
    
    static testMethod void updateOwnerTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brandNodePage1.Id);

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, null, null);
        
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage1.Id, null, true, null);
        
        // Test method
        String userId = UserInfo.getUserId();
        ESN_MB_NOP_RelatedArticles_Cx.updateOwner(userId,activation.Id, true);
        ESN_MB_NOP_RelatedArticles_Cx.updateOwner(userId,article.Id, false);

    }

    static testMethod void setParentActivationTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c parentActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        ESN_MB_NOP_RelatedArticles_Cx.setParentActivation(activation.Id, parentActivation.Id);

        List<ESN_MB_Activation__c> resultList = [Select Id, ESN_MB_Parent_Activation__c FROM ESN_MB_Activation__c WHERE Id = :activation.Id];
        System.assertEquals(1, resultList.size());
        System.assertEquals(parentActivation.Id, resultList.get(0).ESN_MB_Parent_Activation__c);
    }

    static testMethod void searchKeyContactTest() {
        User user = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();

        List<List<Object>> resultList = ESN_MB_NOP_RelatedArticles_Cx.searchKeyContact(user.Id + ' userName');
        System.assert(resultList != null);
    }

    static testMethod void searchMoreKeyContactTest() {
        User user = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();

        List<String> lastContactList = new List<String>();
        lastContactList.add('1523463577');

        List<List<Object>> resultList = ESN_MB_NOP_RelatedArticles_Cx.searchMoreKeyContact(user.Id + ' userName', lastContactList);
        System.assert(resultList != null);
    }

    static testMethod void retrieveSelectedKeyContactTest() {
        User user = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();

        List<String> contactList = new List<String>();
        contactList.add(user.Id);

        List<User> resultList = ESN_MB_NOP_RelatedArticles_Cx.retrieveSelectedKeyContact(contactList);
        System.assertEquals(1, resultList.size());
        System.assertEquals(user.Id, resultList.get(0).Id);
    }
/*
    static testMethod void createEntryActivationKeyContactTest() {
        User user = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String result = ESN_MB_NOP_RelatedArticles_Cx.createEntryActivationKeyContact(activation.Id, user.Id);
        System.assert(String.isNotBlank(result));

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where ESN_MB_Activation__c = :activation.Id And ESN_MB_KeyContact__c = :user.Id And recordType.Name = 'ESN_MB_Activations_To_keyContacts'];
        System.assertEquals(1, resultList.size());
    }*/
    
}