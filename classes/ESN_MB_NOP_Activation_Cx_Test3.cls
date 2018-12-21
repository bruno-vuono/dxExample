@isTest
public class ESN_MB_NOP_Activation_Cx_Test3 {

    static testMethod void retrieveActivationAssetsTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        // create entry
        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');

        // Test method
        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_Activation_Cx.retrieveGlobalActivationAssets(activation.Id);
        System.assertEquals(2, resultList.size());      
    }

    static testMethod void addAssetTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            // Test method
            String resultId = ESN_MB_NOP_Activation_Cx.addAsset('contentId', 'description');
            System.assert(String.isNotBlank(resultId));

            List<ESN_MB_Asset__c> resultList = [Select Id From ESN_MB_Asset__c Where Id = :resultId];
            System.assertEquals(1, resultList.size());
        }
    }
    static testMethod void retrieveMarketActivationAssetsTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');

        // Test method
        List<ESN_MB_Entry__c> resultList = ESN_MB_NOP_Activation_Cx.retrieveMarketActivationAssets(activation.Id);
        System.assertEquals(2, resultList.size());
    }

    static testMethod void matchEntryAssetActivationTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String internalAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Internal_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(internalAssetRTId, null, null);

        // Test method
        String resultId = ESN_MB_NOP_Activation_Cx.matchEntryAssetActivation(activation.Id, asset.Id);

        List<ESN_MB_Entry__c> resultList = [Select Id From ESN_MB_Entry__c Where Id = :resultId];
        System.assertEquals(1, resultList.size());
    }

    static testMethod void retrieveActivationValuesTest() {

        List<SelectOption> resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('ActivationType', '');
        System.assert(resultList.size() == 0);

		resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('BusinessPriority', '');
        System.assert(resultList.size() > 0);

		resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Affiliate', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Maturity', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Pros', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Target', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Bugdet', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Legal', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('Market', '');
        System.assert(resultList.size() > 0);

        resultList = ESN_MB_NOP_Activation_Cx.retrieveActivationValues('MarketType', '');
        System.assert(resultList.size() > 0);
    }

    static testMethod void retrieveToolkitUsedNbTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c parentActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);

        //String rubricRTId = [Select Id from RecordType Where DeveloperName = 'ESN_MB_Rubric'].Id;
        //ESN_MB_NodePage__c activationRubric = ESN_MB_NOP_Homepage_Cx_Test_Utils.createRubric('activationRubric', rubricRTId, 10.0, 'Brand Activations Library');

        // Values to insert
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', parentActivation.Id);
        ESN_MB_Activation__c activation2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', parentActivation.Id);
      
        List<String> parentActivationIdList = new List<String>();
        parentActivationIdList.add(parentActivation.Id);
        
        // Test method
        List<ESN_MB_NOP_ToolkitUsed_DTO> resultList = ESN_MB_NOP_Activation_Cx.retrieveToolkitUsedNb(parentActivationIdList);
        System.assert(resultList.size() > 0);
    }

    static testMethod void retrieveBAByIdTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);

        // Values to insert
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, 'Digital', null);
        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');

        // Test Method
        ESN_MB_Entry__c entry = ESN_MB_NOP_Activation_Cx.retrieveBAById(brand.Id, activation.Id);
        System.assert(entry != null);
    }

    static testMethod void retrieveActivationOwnerTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();

        User result = ESN_MB_NOP_Activation_Cx.retrieveActivationOwner(standardUser.Id);
        System.assert(result != null);
    }

    static testMethod void updateActivationTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);

        // Values to insert
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c mainActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        CollaborationGroup cg = ESN_MB_NOP_Homepage_Cx_Test_Utils.insertCollaborationGroup('cg test' + Datetime.now());

        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Draft', mainActivation.Id, 'Digital', null);

		Map<String, String> activationDatas = new Map<String, String>();
		activationDatas.put('activationBigIdea', 'activationBigIdea');
		activationDatas.put('activationStrategicFit', 'activationStrategicFit');
		activationDatas.put('activationExcellenceOfExecution', 'activationExcellenceOfExecution');
		activationDatas.put('activationBusinessImpact', 'activationBusinessImpact');
		activationDatas.put('activationScalabilityAndReplicability', 'activationScalabilityAndReplicability');

        ESN_MB_NOP_Activation_Cx.updateActivation(activation.Id, 'activationName', 'activationAudience', 'activationBudget',
                                          'activationLegalConstraints', 'activationMarket', 'activationBusinessPriority', 'activationAffiliate', 'activationMaturityStage', 'activationPros',
                                          'activationResults', 'activationHow', 'activationToWhom', 'activationWhat', 'activationWhy', activationDatas,
										  product.Id,'activationActivationType', true, '2014-10-10', '2014-11-11',false, true, '007','007',false,false, 'activationVideo', true);
        ESN_MB_NOP_Activation_Cx.updateActivation(activation.Id, 'activationName', 'activationAudience', 'activationBudget',
                                          'activationLegalConstraints', 'activationMarket', 'activationBusinessPriority', 'activationAffiliate', 'activationMaturityStage', 'activationPros',
                                          'activationResults', 'activationHow', 'activationToWhom', 'activationWhat', 'activationWhy', activationDatas,
										  product.Id,'activationActivationType', true, '2014-10-10', '2014-11-11',false, true, '007','007',false,false, 'activationVideo', false);
    }
    
    static testMethod void updateActivationToStagePublishTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product', productRecordTypeId, 10.0, brand.Id);

        // Values to insert
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c mainActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Draft', mainActivation.Id, 'Digital', null);

        // Test Method
        ESN_MB_NOP_Activation_Cx.updateActivationToStagePublish(activation.Id);
    }
    
    static testMethod void addLinkTest() {
        String result = ESN_MB_NOP_Activation_Cx.addLink('urlText', 'url');
        System.assert(result != null);
    }
/*
    static testMethod void isBroadCasterUserTest(){
        ESN_MB_NOP_Activation_Cx.isBroadCasterUser();
    }
    static testMethod void isBasicUserTest(){
        ESN_MB_NOP_Activation_Cx.isBasicUser();
    }
    static testMethod void isBroadCasterAssignedTest(){
     //   ESN_MB_NOP_Activation_Cx.isBroadCasterAssigned(null);
    }
    static testMethod void isBroadCasterManagerAssignedTest(){
     //   ESN_MB_NOP_Activation_Cx.isBroadCasterManagerAssigned(null);
    }*/
/*
    static testMethod void deleteAssetTest() {
        String internalAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Internal_Asset');
        ESN_MB_Asset__c document = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(internalAssetRTId, null, null);
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(internalAssetRTId, document.Id, null);

        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            // Test method
            String resultId = ESN_MB_NOP_Activation_Cx.deleteAsset(document.Id);
            System.assertEquals(asset.Id, resultId);

            List<ESN_MB_Asset__c> resultList = [Select Id From ESN_MB_Asset__c Where Id = :asset.Id];
            System.assertEquals(0, resultList.size());
        }
    }
*/
}