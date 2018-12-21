/**
    About
    -----
    Description: test class for ESN_MB_Homepage_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_Activation_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_Activation_Cx_Test {
    

    static testMethod void deleteAssetEntryTest() {
        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);
        ESN_MB_Entry__c entry = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAssetEntry(asset);

        // Test method
        String resultId = ESN_MB_NOP_Activation_Cx.deleteAssetEntry(entry.Id);
        System.assertEquals(entry.Id, resultId);

        List<ESN_MB_Entry__c> existingEntryList = [SELECT Id From ESN_MB_Entry__c WHERE Id = :entry.Id];
        System.assertEquals(0, existingEntryList.size());
        List<ESN_MB_Asset__c> existingAssetList = [SELECT Id FROM ESN_MB_Asset__c WHERE Id = :asset.Id];
        System.assertEquals(0, existingAssetList.size());
    }

    static testMethod void deleteActivationTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        // Test method
        String resultId = ESN_MB_NOP_Activation_Cx.deleteActivation(activation.Id);
        System.assertEquals(activation.Id, resultId);

        List<ESN_MB_Activation__c> resultList = [Select Id From ESN_MB_Activation__c Where Id = :activation.Id];
        System.assertEquals(0, resultList.size());
    }

    static testMethod void prepareDTOFromActivationTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');

        List<ESN_MB_Entry__c> entryList = new List<ESN_MB_Entry__c>();
        entryList.add(entry1);

        ESN_MB_NOP_Activation_DTO result = ESN_MB_NOP_Activation_Cx.prepareDTOFromActivation(activation, entryList);
        System.assert(result != null);
    }

    static testMethod void cloneArticleStageDraftTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'ImageAsset');

        // Test method
        ESN_MB_NOP_Activation_DTO result = ESN_MB_NOP_Activation_Cx.cloneArticleStageDraft(activation.Id);
        System.assert(result != null);

        // Check
//        List<ESN_MB_Activation__c> activationCloneList = [SELECT Id FROM ESN_MB_Activation__c WHERE ESN_MB_Stage__c = 'Draft' And ESN_MB_MainActivationId__c = :activation.Id];
//        System.assertEquals(1, activationCloneList.size());

//        List<ESN_MB_Entry__c> entryCloneList = [Select Id FROM ESN_MB_Entry__c WHERE ESN_MB_Activation__c = :activationCloneList.get(0).Id];
//        System.assertEquals(2, entryCloneList.size());
    }

    static testMethod void cloneActivationStageDraftTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');
        ESN_MB_Entry__c entry2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(activation, activationAssetRTId, 'MainAsset');

        // Test method
        ESN_MB_NOP_Activation_DTO result = ESN_MB_NOP_Activation_Cx.cloneActivationStageDraft(activation.Id);
        System.assert(result != null);

        // check
        List<ESN_MB_Activation__c> activationCloneList = [SELECT Id FROM ESN_MB_Activation__c WHERE ESN_MB_Stage__c = 'Draft' And ESN_MB_MainActivationId__c = :activation.Id];
        System.assertEquals(1, activationCloneList.size());

        List<ESN_MB_Entry__c> entryCloneList = [Select Id FROM ESN_MB_Entry__c WHERE ESN_MB_Activation__c = :activationCloneList.get(0).Id];
        System.assertEquals(2, entryCloneList.size());
    }

    static testMethod void rateMACriteriaTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
            ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

            // Test with no ESN_MB_User_Interaction__c created before
            ESN_MB_NOP_Activation_Cx.rateMACriteria(activation.Id, 1, 2);
            List<ESN_MB_User_Interaction__c> resultList = [Select ESN_MB_Rating_Criteria_1__c, ESN_MB_Rating_Criteria_2__c, ESN_MB_Rating_Criteria_3__c, ESN_MB_Rating_Criteria_4__c, 
                                                    ESN_MB_Rating_Criteria_5__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(2, resultList.get(0).ESN_MB_Rating_Criteria_1__c);

            // Test with ESN_MB_User_Interaction__c already created
            //ESN_MB_User_Interaction__c userInteraction = ESN_MB_NOP_Homepage_Cx_Test_Utils.createUserInteraction(standardUser, activation);
            ESN_MB_NOP_Activation_Cx.rateMACriteria(activation.Id, 2, 4);
            ESN_MB_NOP_Activation_Cx.rateMACriteria(activation.Id, 3, 1);
            ESN_MB_NOP_Activation_Cx.rateMACriteria(activation.Id, 4, 2);
            ESN_MB_NOP_Activation_Cx.rateMACriteria(activation.Id, 5, 3);

            resultList = [Select ESN_MB_Rating_Criteria_1__c, ESN_MB_Rating_Criteria_2__c, ESN_MB_Rating_Criteria_3__c, ESN_MB_Rating_Criteria_4__c, 
                            ESN_MB_Rating_Criteria_5__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(2, resultList.get(0).ESN_MB_Rating_Criteria_1__c);
            System.assertEquals(4, resultList.get(0).ESN_MB_Rating_Criteria_2__c);
            System.assertEquals(1, resultList.get(0).ESN_MB_Rating_Criteria_3__c);
            System.assertEquals(2, resultList.get(0).ESN_MB_Rating_Criteria_4__c);
            System.assertEquals(3, resultList.get(0).ESN_MB_Rating_Criteria_5__c);
        }
    }
    
    static testMethod void thumbUpMATest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
            ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

            // Test method
            ESN_MB_NOP_Activation_Cx.thumbUpMA(activation.Id);

            List<ESN_MB_User_Interaction__c> resultList = [Select ESN_MB_Like__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(true, resultList.get(0).ESN_MB_Like__c);
        }
    }

    static testMethod void likeMATest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
            ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

            // Test method
            ESN_MB_NOP_Activation_Cx.likeMA(activation.Id);

            List<ESN_MB_User_Interaction__c> resultList = [Select ESN_MB_Like__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(true, resultList.get(0).ESN_MB_Like__c);
        }
    }

    static testMethod void unlikeMATest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
            ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
    
            // Test method
            ESN_MB_NOP_Activation_Cx.unlikeMA(activation.Id);

            List<ESN_MB_User_Interaction__c> resultList = [Select ESN_MB_Like__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(false, resultList.get(0).ESN_MB_Like__c);
        }
    }
/*
    static testMethod void followMATest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            // Test method
            ESN_MB_NOP_Activation_Cx.followMA(activation.Id);

            List<ESN_MB_User_Interaction__c> resultList = [Select ESN_MB_Follow__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(true, resultList.get(0).ESN_MB_Follow__c);
        }
    }

    static testMethod void unfollowMATest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            // Test method
            ESN_MB_NOP_Activation_Cx.unfollowMA(activation.Id);

            List<ESN_MB_User_Interaction__c> resultList = [Select ESN_MB_Follow__c From ESN_MB_User_Interaction__c Where ESN_MB_User__c = :standardUser.Id And ESN_MB_Activation__c = :activation.Id];
            System.assertEquals(1, resultList.size());
            System.assertEquals(false, resultList.get(0).ESN_MB_Follow__c);
        }
    }
*/
    static testMethod void createEntryAssetActivationTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        // Test method
        String resultId = ESN_MB_NOP_Activation_Cx.createEntryAssetActivation(activation.Id, asset.Id, 'MainAsset');
        System.assert(String.isNotBlank(resultId));

        List<ESN_MB_Entry__c> entryCloneList = [Select Id FROM ESN_MB_Entry__c WHERE Id = :resultId];
        System.assertEquals(1, entryCloneList.size());
    }

    static testMethod void deleteEntryAssetActivationTest() {
        // entry creation
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);

        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        String entryId = ESN_MB_NOP_Activation_Cx.createEntryAssetActivation(activation.Id, asset.Id, 'MainAsset');

        // Test method
        ESN_MB_NOP_Activation_Cx.deleteEntryAssetActivation(activation.Id, asset.Id, 'MainAsset');

        List<ESN_MB_Entry__c> entryCloneList = [Select Id FROM ESN_MB_Entry__c WHERE Id = :entryId];
        System.assertEquals(0, entryCloneList.size());
    }

    static testMethod void deleteParentActivationTest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c parentActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, null, null, null, parentActivation.Id);

        ESN_MB_NOP_Activation_Cx.deleteParentActivation(activation.Id);

        List<ESN_MB_Activation__c> resultList = [Select Id, ESN_MB_Parent_Activation__c FROM ESN_MB_Activation__c WHERE Id = :activation.Id];
        System.assertEquals(1, resultList.size());
        System.assertEquals(null, resultList.get(0).ESN_MB_Parent_Activation__c);
    }

    static testMethod void retrieveMALinkToBATest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        ESN_MB_Activation__c parentActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, null, null, null, parentActivation.Id);

        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(parentActivation, activationAssetRTId, 'MainAsset');

        ESN_MB_Entry__c result = ESN_MB_NOP_Activation_Cx.retrieveMALinkToBA(activation.Id);
        System.assert(result != null);
        System.assertEquals(entry1.Id, result.Id);
    }
    
    static testMethod void retrieveMAToDisplayOnBATest() {
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c parentActivation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId);
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, null, null, null, parentActivation.Id);

        String activationAssetRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_to_Assets');
        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivationEntry(parentActivation, activationAssetRTId, 'MainAsset');

        List <ESN_MB_Entry__c> result = ESN_MB_NOP_Activation_Cx.retrieveMAToDisplayOnBA(activation.Id);
        //System.assert(result[0] != null);
        //System.assertEquals(entry1.Id, result[0].Id);
    }
    
    static testMethod void retrieveUserMALikesTest() {
        // Get a user
       	String userId = userInfo.getUserId();
        // Get market activation record type
        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        // Create 3 activations
        ESN_MB_Activation__c activation1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, null, null, null, null);
        ESN_MB_Activation__c activation2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, null, null, null, null);
        ESN_MB_Activation__c activation3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, null, null, null, null, null);
        // Create 3 user interactions
        ESN_MB_User_Interaction__c userInteraction1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createUserInteractionLike(userId, activation1);
        ESN_MB_User_Interaction__c userInteraction2 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createUserInteractionLike(userId, activation2);
        ESN_MB_User_Interaction__c userInteraction3 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createUserInteractionLike(userId, activation3);
        
        List<String> activationIdsList = new List<String>();
        activationIdsList.add(activation1.id);
        activationIdsList.add(activation2.id);
        activationIdsList.add(activation3.id);
        
        List<ESN_MB_User_Interaction__c> retrievedUserMALikes = ESN_MB_NOP_Activation_Cx.retrieveUserMALikes(activationIdsList);
        Integer retrieveNb = retrievedUserMALikes.size();
        System.assertEquals(3, retrieveNb);
    }

	static testMethod void retrieveCoordinator() {
		ESN_MB_NOP_Activation_Cx controller = new ESN_MB_NOP_Activation_Cx();
		controller.getCoordinator();
		controller.getListCoordinators();
	}
}