/**
    About
    -----
    Description: test class for ESN_MB_Homepage_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Oct 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_GlobalDirectory_Cx class
    
    Update History
    --------------
    Oct 2014 / Created by Valentin PLITTA

    Issues / TODOs
    --------------
*/

@isTest
private class ESN_MB_NOP_GlobalDirectory_Cx_Test {
    
    static testMethod void createGlobalDirectoryTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);
         
       String result = ESN_MB_NOP_GlobalDirectory_Cx.createGlobalDirectory(brand.Id, product.Id);
       System.assert(result!= null);
        
    }
    
    static testMethod void createEntryAssetGlobalDirectoryTest() {
        
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        // Test method
        String resultId = ESN_MB_NOP_GlobalDirectory_Cx.createEntryAssetGlobalDirectory(activation.Id, asset.Id, 'MainAsset');
        System.assert(String.isNotBlank(resultId));

        List<ESN_MB_Entry__c> entryCloneList = [Select Id FROM ESN_MB_Entry__c WHERE Id = :resultId];
        System.assertEquals(1, entryCloneList.size());
    }
    
     static testMethod void retrieveGlobalDirectoryAssetsTest() {
         String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        // create entry
        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');

        // Test method
        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_GlobalDirectory_Cx.retrieveGlobalDirectoryAssets(activation.Id);
        System.assertEquals(2, resultList.size());     
     }
    static testMethod void deleteEntryAssetGlobalDirectoryTest() {
        // entry creation
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String entryId = ESN_MB_NOP_Activation_Cx.createEntryAssetActivation(activation.Id, asset.Id, 'MainAsset');

        // Test method
        ESN_MB_NOP_GlobalDirectory_Cx.deleteEntryAssetGlobalDirectory(activation.Id, asset.Id, 'MainAsset');

        List<ESN_MB_Entry__c> entryCloneList = [Select Id FROM ESN_MB_Entry__c WHERE Id = :entryId];
        System.assertEquals(0, entryCloneList.size());
    }

}