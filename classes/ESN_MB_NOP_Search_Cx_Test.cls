/**
    About
    -----
    Description: test class for ESN_MB_NOP_Search_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_Search_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest(SeeAllData=true)
private class ESN_MB_NOP_Search_Cx_Test {

    static testMethod void searchTest() {
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brand.Id, 'Published', true, null);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, null, null);

        String assetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, 'Asset1', null, null, 'brandName');
        //ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, null, null, null, 'product');

        CollaborationGroup cg = ESN_MB_NOP_Homepage_Cx_Test_Utils.insertCollaborationGroup('cg test' + Datetime.now());
        brand.ESN_MB_ChatterGroup_Id__c = cg.Id;
        update brand;

        String mentionId = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser().Id;//UserInfo.getUserId();
        String text = '{' + mentionId + '}';
        ConnectApi.FeedItem feedItem = ESN_MB_ConnectApi_Helper.postFeedItemWithMentions('internal', cg.Id, 'textWithMentions');
        ESN_MB_ConnectApi_Helper.postCommentWithMentions('internal', feedItem.Id, text);

        // Test method
        List<List<ESN_MB_NOP_Search_DTO>> resultList = ESN_MB_NOP_Search_Cx.search('article brandName', brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void searchArticleTest() {
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article', brand.Id, 'Published', true, null);

        // Test method
        List<List<ESN_MB_NOP_Search_DTO>> resultList = ESN_MB_NOP_Search_Cx.search('article', brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void search2Test() {
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article', brand.Id, 'Published', true, null);

        String assetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, 'Asset1', null, null, 'brandName');
        //ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, null, null, null, 'product');

        // Test method
        List<List<ESN_MB_NOP_Search_DTO>> resultList = ESN_MB_NOP_Search_Cx.search('Asset', brand.Id);
        System.assert(resultList != null);
    }
    static testMethod void searchLeCercleTest() {
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_NodePage__c brandLeCercle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0, 'LeCercle');
        brandLeCercle.ESN_MB_BrandParentId__c = brand.Id;
        update brandLeCercle;
        
        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article', brand.Id, 'Published', true, null);
        ESN_MB_Article__c articleLeCercle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('articleLeCercle', brandLeCercle.Id, 'Published', true, null);

        String assetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, 'Asset1', null, null, 'brandName');

        // Test method
        List<List<ESN_MB_NOP_Search_DTO>> resultList = ESN_MB_NOP_Search_Cx.search('Asset', brandLeCercle.Id);
        System.assert(resultList != null);
    }

}