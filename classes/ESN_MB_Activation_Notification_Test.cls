/**
    About
    -----
    Description: test class for ESN_MB_Activation_Notification class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_Activation_Notification class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest(SeeAllData=true)
private class ESN_MB_Activation_Notification_Test {

    static testMethod void getGroupOwnerTest() {
        CollaborationGroup cg = ESN_MB_NOP_Homepage_Cx_Test_Utils.insertCollaborationGroup('cg test' + Datetime.now());

        String resultId = ESN_MB_Activation_Notification.getGroupOwner(cg.Id);
        System.assert(String.isNotBlank(resultId));

        // Test2 : KO in Staging / OK in Dev
        //ESN_MB_Activation_Notification.getGroupOwner();
    }

    static testMethod void sendFeedItemTest() {
        String productRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        ESN_MB_NodePage__c product = ESN_MB_NOP_Homepage_Cx_Test_Utils.createProduct('product1', productRecordTypeId, 10.0, null);

        String activationRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        ESN_MB_Activation__c activation = ESN_MB_NOP_Homepage_Cx_Test_Utils.createActivation(activationRTId, product.Id, 'Published', null, null, null);

        CollaborationGroup cg = ESN_MB_NOP_Homepage_Cx_Test_Utils.insertCollaborationGroup('cg test' + Datetime.now());

        // Test method
        ESN_MB_Activation_Notification.sendFeedItem(activation.Id, 'activationName', 'activationProduct', 'activationMarket', cg.Id);

        ConnectApi.Feed result = ConnectApi.ChatterFeeds.getFeed(null, ConnectApi.FeedType.Record, cg.Id);
        System.assert(result != null);

        // Test2 : KO in Staging / OK in Dev
        //ESN_MB_Activation_Notification.sendFeedItem(activation.Id, 'activationName', 'activationProduct', 'activationMarket');
    }
}