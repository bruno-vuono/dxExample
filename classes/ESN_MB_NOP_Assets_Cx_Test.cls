/**
    About
    -----
    Description: test class for ESN_MB_NOP_Assets_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_Assets_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_Assets_Cx_Test {

    static testMethod void retrieveAssetsTest() {
        /*ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
//        ESN_MB_Article__c article = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('article1', brandNodePage.Id, null, true, null);

        ESN_MB_NodePage__c product1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product1', 10.0, brand.Id);

        String assetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, null, null, null, 'product');
        ESN_MB_Asset__c asset2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRTId, null, null, null, null, null, 'product');*/

/*        // Test method with 'All Assets' rubric
        ESN_MB_NodePage__c allAssetsRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('All Assets', rubricRTId, 10.0, null);
        
        List<List<Object>> resultList = ESN_MB_NOP_Assets_Cx.retrieveAssets(allAssetsRubric.Id, brand.Id, product1.Id);
        System.assert(resultList.size() > 0);

        ESN_MB_NodePage__c masterProduct = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('masterProduct', 10.0, brand.Id);

        resultList = ESN_MB_NOP_Assets_Cx.retrieveAssets(allAssetsRubric.Id, brand.Id, masterProduct.Id);
        System.assert(resultList.size() > 0);
*/
        // Test method with 'ID Assets' rubric
        /*ESN_MB_NodePage__c idAssetsRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('ID Assets', 10.0, null);

        
        ESN_MB_Asset__c assetForIdAssetTaxonomy1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAssetTaxonomy('secondIdAssets1', 'thirdIdAssets1', 'fourthIdAssets1');
        ESN_MB_Asset__c assetForIdAssetTaxonomy2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAssetTaxonomy('secondIdAssets2', 'thirdIdAssets2', 'fourthIdAssets2');

        List<List<Object>> resultList = ESN_MB_NOP_Assets_Cx.retrieveAssets(idAssetsRubric.Id, brand.Id, product1.Id);
        System.debug('resultList: ' + resultList);
        System.assert(resultList.size() > 0);

        // Test method with 'Campaign' rubric
        ESN_MB_NodePage__c campaignRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('Campaign', 10.0, null);

        ESN_MB_Campaign_Taxonomy__c campaignTaxonomy1 = insertCampaignTaxonomy('Test campaign tax1', 'secondCampaign1', 'thirdCampaign1', 'fourthCampaign1');
        ESN_MB_Campaign_Taxonomy__c campaignTaxonomy2 = insertCampaignTaxonomy('Test campaign tax2', 'secondCampaign2', 'thirdCampaign2', 'fourthCampaign2');

        ESN_MB_Asset__c assetForCampaignTaxonomy1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAssetTaxonomy('secondCampaign1', 'thirdCampaign1', 'fourthCampaign1');
        ESN_MB_Asset__c assetForCampaignTaxonomy2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAssetTaxonomy('secondCampaign2', 'thirdCampaign2', 'fourthCampaign2');

        resultList = ESN_MB_NOP_Assets_Cx.retrieveAssets(campaignRubric.Id, brand.Id, product1.Id);
        System.assert(resultList.size() > 0);

        // Test method with 'Packshots & Beauty shots' rubric
        ESN_MB_NodePage__c packageBeautyShotsRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('Packshots & Beauty shots', 10.0, null);

        ESN_MB_Packshots_Taxonomy__c packshotTaxonomy1 = insertPackshotsTaxonomy('Test packshots tax1', 'secondPackshot1', 'thirdPackshot1', 'fourthPackshot1');

        ESN_MB_Asset__c assetForPackshotsTaxonomy1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAssetTaxonomy('secondPackshot1', 'thirdPackshot1', 'fourthPackshot1');

        resultList = ESN_MB_NOP_Assets_Cx.retrieveAssets(packageBeautyShotsRubric.Id, brand.Id, product1.Id);
        System.assert(resultList.size() > 0);

        // Test Method masterBrand
        ESN_MB_NodePage__c masterProduct = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('masterProduct', 10.0, brand.Id);

        resultList = ESN_MB_NOP_Assets_Cx.retrieveAssets(packageBeautyShotsRubric.Id, brand.Id, masterProduct.Id);
        System.assert(resultList.size() > 0);*/
    }
/* TODO : Methods defined as TestMethod do not support Web service callouts, test skipped
    static testMethod void importLastModifiedAssetsTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        brand.ESN_MB_Brand_DAM_Id__c = '12345';
        update brand;

        String result = ESN_MB_NOP_Assets_Cx.importLastModifiedAssets(brand.Id);
        System.assert(String.isNotBlank(result));
    }*/
    
    static testMethod void isBroadCasterUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Assets_Cx.isBroadCasterUser();
        }
    }
    static testMethod void isBroadCasterAssignedTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Assets_Cx.isBroadCasterAssigned(brand.Id);
        }
    }
    
    static testMethod void importLastModifiedAssetsTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        String result = ESN_MB_NOP_Assets_Cx.importLastModifiedAssets(brand.Id);
    }
}