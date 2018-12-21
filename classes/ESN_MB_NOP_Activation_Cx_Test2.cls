@isTest
public class ESN_MB_NOP_Activation_Cx_Test2 {
    
    static testMethod void retrieveListBrandActivationTest() {
        // Create a brand
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
		
        // Create a masterbrand product for the brand
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c productMasterbrand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMasterbrand('productMasterbrand', 10.0, brand.Id);
        
        // Create another product for the brand
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 20.0, brand.Id);

        String rubricRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Rubric'].Id;
        ESN_MB_NodePage__c activationRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('activationRubric', rubricRTId, 10.0, 'Brand Activations Library');

        // create activation
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', null);
        
        // Create a "Activations_To_Assets" entry
        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');

        // Test method activationList 1
        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_Activation_Cx.retrieveListBrandActivation(brand.Id, product.Id, activationRubric.Id);
        //System.assert(resultList.size() > 0);

        // Test method activationList 2
        ESN_MB_NodePage__c rubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('Digital', rubricRTId, 10.00, null);

        User broadcasterUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getBroadcasterUser('brand1');
        System.runAs(broadcasterUser) {
            resultList = ESN_MB_NOP_Activation_Cx.retrieveListBrandActivation(brand.Id, product.Id, rubric.Id);
            //System.assert(resultList.size() > 0);
        }

        // Test method activationList 2
        resultList = ESN_MB_NOP_Activation_Cx.retrieveListBrandActivation(brand.Id, product.Id, rubric.Id);
        //System.assert(resultList.size() > 0);

        // Test method activationList 3
        ESN_MB_NodePage__c otherProduct = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('other product', productRecordTypeId, 10.0, null);
        ESN_MB_Activation__c otherActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, otherProduct.Id, 'Published', null, 'Digital', null);
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(otherActivation, activationAssetRTId, 'MainAsset');

        resultList = ESN_MB_NOP_Activation_Cx.retrieveListBrandActivation(brand.Id, otherProduct.Id, activationRubric.Id);
        //System.assert(resultList.size() > 0);

        System.runAs(broadcasterUser) {
            resultList = ESN_MB_NOP_Activation_Cx.retrieveListBrandActivation(brand.Id, otherProduct.Id, activationRubric.Id);
            //System.assert(resultList.size() > 0);
        }

        // Test method activationList 4
        resultList = ESN_MB_NOP_Activation_Cx.retrieveListBrandActivation(brand.Id, otherProduct.Id, rubric.Id);
        //System.assert(resultList.size() > 0);
    }
    
    static testMethod void retrieveBrandActivationByIdTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, null, null);
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, null, null);

        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_Activation_Cx.retrieveBrandActivationById(activation.Id);
        System.assertEquals(2, resultList.size());
    }
    
    static testMethod void retrieveListMarketActivationTest() {
        // create activation

        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brandNodePage1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brandNodePage1.Id);

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, null, null);

        // create entry
        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');

        // Test method
        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_Activation_Cx.retrieveListMarketActivation(brandNodePage1.Id);
        System.assertEquals(2, resultList.size());

        // Test 2
        User broadcasterUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getBroadcasterUser('brand1');
        System.runAs(broadcasterUser) {
            resultList = ESN_MB_NOP_Activation_Cx.retrieveListMarketActivation(brandNodePage1.Id);
            //System.assert(resultList.size() > 0);
        }
    }

    static testMethod void retrieveMarketActivationByIdTest() {
        // create activation
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        //String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, null, 'MainAsset');

        // Test method
        ESN_MB_Entry__c result = ESN_MB_NOP_Activation_Cx.retrieveMarketActivationById('brandId', activation.Id);
        System.assert(result != null);
        System.assertEquals(entry1.Id, result.Id);
    }

    static testMethod void retrieveUserInteractionTest() {

        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();

        // Test method
        System.RunAs(standardUser) {
            // create activation
            String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
            ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
            // Test method with no userInteraction
            ESN_MB_User_Interaction__c result = ESN_MB_NOP_Activation_Cx.retrieveUserInteraction(activation.Id);
            System.assert(result != null);
            
            // create userInteraction 
            ESN_MB_User_Interaction__c userInteraction = ESN_MB_NOP_Homepage_Cx_Test_Utils.createUserInteraction(standardUser, activation);

            // Test method with userInteraction
            result = ESN_MB_NOP_Activation_Cx.retrieveUserInteraction(activation.Id);
            System.assert(result != null);
            System.assertEquals(userInteraction.Id, result.Id);
        }
    }

    static testMethod void createActivationDraftTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            String activationIdResult = ESN_MB_NOP_Activation_Cx.createActivationDraft('ESN_MB_Brand_Activation');
            System.assert(String.isNotBlank(activationIdResult));

            ESN_MB_Activation__c activation = [SELECT Id, ESN_MB_Stage__c FROM ESN_MB_Activation__c WHERE Id = :activationIdResult];
            System.assertEquals('Draft', activation.ESN_MB_Stage__c);
        }
    }
    static testMethod void updateActivationToStageArchivedTest() {
        // create activation
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, 'Published', null, null, null);

        ESN_MB_NOP_Activation_Cx.updateActivationToStageArchived(activation.Id);

        List<ESN_MB_Activation__c> resultList = [SELECT Id, ESN_MB_Stage__c FROM ESN_MB_Activation__c WHERE Id = :activation.Id];
        System.assertEquals(1, resultList.size());       
        System.assertEquals('Archived', resultList.get(0).ESN_MB_Stage__c);
    }

    static testMethod void createEntryActivationAssetTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, 'Published', null, null, null);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        // Test method
        String resultId = ESN_MB_NOP_Activation_Cx.createEntryActivationAsset(activation.Id, asset.Id, 'MainAsset');
        System.assert(String.isNotBlank(resultId));

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where Id = :resultId];
        System.assertEquals(1, resultList.size());       
    }
}