/**
    About
    -----
    Description: test class for ESN_MB_NOP_SearchAsset_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_SearchAsset_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_SearchAsset_Cx_Test {

    static testMethod void searchAssetsTest() {
        // create asset
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');

        // Test method brandContent
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Aged 21 Years Logo', null, null, null);

        List<List<Object>> resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'brandContent', brand.Id);
        System.assert(resultList != null);

        // Test method imageAsset
        ESN_MB_Asset__c imageAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 12 Miniature Front', 'image', 'JPG', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine', 'imageAsset', brand.Id);
        System.assert(resultList != null);

        // Test method videoAsset
        ESN_MB_Asset__c videoAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 30 YO Carton', null, 'AVI', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'videoAsset', brand.Id);
        System.assert(resultList != null);

        // Test method presentationAsset
        ESN_MB_Asset__c presentationAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s International Music Awards _ Spain', null, 'PPT', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'presentationAsset', brand.Id);
        System.assert(resultList != null);

        // Test method pdf Asset
        ESN_MB_Asset__c pdfAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Limited GTR toolkit 2012', null, 'PDF', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'other', brand.Id);
        System.assert(resultList != null);
    }

    static testMethod void searchAssetsLeCercleTest() {
        // create asset
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('LeCercle', brandRTId, 10.0);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');

        // Test method brandContent
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Aged 21 Years Logo', null, null, null);

        List<List<Object>> resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'brandContent', brand.Id);
        System.assert(resultList != null);

        // Test method imageAsset
        ESN_MB_Asset__c imageAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 12 Miniature Front', 'image', 'JPG', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine', 'imageAsset', brand.Id);
        System.assert(resultList != null);

        // Test method videoAsset
        ESN_MB_Asset__c videoAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 30 YO Carton', null, 'AVI', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'videoAsset', brand.Id);
        System.assert(resultList != null);

        // Test method presentationAsset
        ESN_MB_Asset__c presentationAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s International Music Awards _ Spain', null, 'PPT', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'presentationAsset', brand.Id);
        System.assert(resultList != null);

        // Test method pdf Asset
        ESN_MB_Asset__c pdfAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Limited GTR toolkit 2012', null, 'PDF', null);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchAssets('Ballantine whiskey', 'other', brand.Id);
        System.assert(resultList != null);
    }

    /*static testMethod void searchMoreAssetsTest() {
        // create asset
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');

        // Test method brandContent
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Aged 21 Years Logo', null, null, null);
        ESN_MB_Asset__c moreAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Aged 21 Years Logo', null, null, null);

        List<String> lastAssetIdList = new List<String>();
        lastAssetIdList.add(moreAsset.Id);

        List<List<Object>> resultList = ESN_MB_NOP_SearchAsset_Cx.searchMoreAssets('Ballantine whiskey', lastAssetIdList, 'brandContent', brand.Id);
        System.assert(resultList != null);

        // Test method imageAsset
        ESN_MB_Asset__c imageAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 12 Miniature Front', 'image', 'JPG', null);
        ESN_MB_Asset__c moreImageAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 12 Miniature Front', 'image', 'JPG', null);
        lastAssetIdList.add(moreImageAsset.Id);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchMoreAssets('Ballantine whiskey', lastAssetIdList, 'imageAsset', brand.Id);
        System.assert(resultList != null);

        // Test method videoAsset
        ESN_MB_Asset__c videoAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 30 YO Carton', null, 'AVI', null);
        ESN_MB_Asset__c moreVideoAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s 30 YO Carton', null, 'AVI', null);
        lastAssetIdList.add(moreVideoAsset.Id);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchMoreAssets('Ballantine whiskey', lastAssetIdList, 'videoAsset', brand.Id);
        System.assert(resultList != null);

        // Test method presentationAsset
        ESN_MB_Asset__c presentationAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s International Music Awards _ Spain', null, 'PPT', null);
        ESN_MB_Asset__c morePresentationAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s International Music Awards _ Spain', null, 'PPT', null);
        lastAssetIdList.add(morePresentationAsset.Id);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchMoreAssets('Ballantine whiskey', lastAssetIdList, 'presentationAsset', brand.Id);
        System.assert(resultList != null);

        // Test method pdf Asset
        ESN_MB_Asset__c pdfAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Limited GTR toolkit 2012', null, 'PDF', null);
        ESN_MB_Asset__c morePdfAsset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Limited GTR toolkit 2012', null, 'PDF', null);
        lastAssetIdList.add(morePdfAsset.Id);

        resultList = ESN_MB_NOP_SearchAsset_Cx.searchMoreAssets('Ballantine whiskey', lastAssetIdList, 'other', brand.Id);
        System.assert(resultList != null);
    }*/

    static testMethod void retrieveSelectedAssetsTest() {
        // create asset
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');

        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Aged 21 Years Logo', null, null, null);
        ESN_MB_Asset__c asset2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null, 'Ballantine\'s Aged 18 Years Logo', null, null, null);

        List<String> assetIdList = new List<String>();
        assetIdList.add(asset1.Id);
        assetIdList.add(asset2.Id);

        // Test method
        List<ESN_MB_Asset__c> resultList = ESN_MB_NOP_SearchAsset_Cx.retrieveSelectedAssets(assetIdList);
        System.assertEquals(2, resultList.size());
    }
    
    static testMethod void searchWebinarsTest() {
        // Get brand record type id
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        // Create a brand
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        // Get dam asset record type id
        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        // Create 3 assets with webinar as true
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createWebinarAsset(assetRecordTypeId, null, null, 'Ballantine1', null, null, 'brandName');
        ESN_MB_Asset__c asset2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createWebinarAsset(assetRecordTypeId, null, null, 'Ballantine2', null, null, 'brandName');
        ESN_MB_Asset__c asset3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createWebinarAsset(assetRecordTypeId, null, null, 'Ballantine3', null, null, 'brandName');
/*
        List<String> assetIdList = new List<String>();
        assetIdList.add(asset1.Id);
        assetIdList.add(asset2.Id);
        assetIdList.add(asset3.Id);
*/
        List<ESN_MB_Asset__c> resultList = ESN_MB_NOP_SearchAsset_Cx.searchWebinars(brand.Id);
    //    System.assertEquals(3, resultList.size());
    }
    
     static testMethod void searchMoreAssetsTest() {
        List<String> listTest = new List<String>();
        listTest.add('test');
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_NOP_SearchAsset_Cx.searchMoreAssets('text',  listTest, 'test', brand.Id);
     }
     
     static testMethod void isBroadCasterAssignedTest() {
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);
        ESN_MB_NOP_SearchAsset_Cx.isBroadCasterAssigned(brand.Id);
      }
      
      static testMethod void changeWebinarOrderTest() {
        String brandRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brandName', brandRTId, 10.0);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createWebinarAsset(assetRecordTypeId, null, null, 'Ballantine1', null, null, 'brandName');
        ESN_MB_Asset__c asset2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createWebinarAsset(assetRecordTypeId, null, null, 'Ballantine2', null, null, 'brandName');
        ESN_MB_Asset__c asset3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createWebinarAsset(assetRecordTypeId, null, null, 'Ballantine3', null, null, 'brandName');
        
        List<String> listWebinarId = new List<String>();
        listWebinarId.add(asset1.Id);
        listWebinarId.add(asset2.Id);
        listWebinarId.add(asset3.Id);
        
        ESN_MB_NOP_SearchAsset_Cx.changeWebinarOrder(listWebinarId);
      }
}