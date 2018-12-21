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
private class ESN_MB_ConnectApi_Helper_Test {
/*
    static testMethod void postFeedItemWithMentionsTest() {
        CollaborationGroup cg = ESN_MB_NOP_Homepage_Cx_Test_Utils.insertCollaborationGroup('cg test' + Datetime.now());

        // Test method
        ESN_MB_ConnectApi_Helper.postFeedItemWithMentions('internal', cg.Id, 'textWithMentions');

        ConnectApi.Feed result = ConnectApi.ChatterFeeds.getFeed('internal', ConnectApi.FeedType.Record, cg.Id);
        System.assert(result != null);

        // Test method with exception
        try {
            ESN_MB_ConnectApi_Helper.postFeedItemWithMentions('internal', cg.Id, null);
        } catch(ESN_MB_ConnectApi_Helper.InvalidParameterException e) {
            System.assert(e.getMessage().contains('textWithMentions parameter'), 'message=' + e.getMessage());
        }
    }

    static testMethod void postFeedItemWithMentionsAndUrlTest() {
        CollaborationGroup cg = ESN_MB_NOP_Homepage_Cx_Test_Utils.insertCollaborationGroup('cg test' + Datetime.now());

        // Test method
        ESN_MB_ConnectApi_Helper.postFeedItemWithMentionsAndUrl('internal', cg.Id, 'textWithMentions', 'url', 'urlName');

        ConnectApi.Feed result = ConnectApi.ChatterFeeds.getFeed('internal', ConnectApi.FeedType.Record, cg.Id);
        System.assert(result != null);

        // Test method with exception
        try {
            ESN_MB_ConnectApi_Helper.postFeedItemWithMentionsAndUrl('internal', cg.Id, null, 'url', 'urlName');
        } catch(ESN_MB_ConnectApi_Helper.InvalidParameterException e) {
            System.assert(e.getMessage().contains('textWithMentions parameter'), 'message=' + e.getMessage());
        }
    }

    static testMethod void postCommentWithMentionsTest() {
        ConnectApi.FeedElement fi = ConnectApi.ChatterFeeds.postFeedElement(null, 'me', ConnectApi.FeedElementType.FeedItem, 'hi');
        String mentionId = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser().Id;//UserInfo.getUserId();
        String text = '{' + mentionId + '}';

        // Test method
        ConnectApi.Comment comment = ESN_MB_ConnectApi_Helper.postCommentWithMentions(null, fi.id, text);

        List<ConnectApi.MessageSegment> segments = comment.body.messageSegments;
        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegment);
        ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.record.id);

        // Test method with exception
        try {
            ESN_MB_ConnectApi_Helper.postCommentWithMentions(null, fi.Id, null);
        } catch(ESN_MB_ConnectApi_Helper.InvalidParameterException e) {
            System.assert(e.getMessage().contains('textWithMentions parameter'), 'message=' + e.getMessage());
        }
    }*/
/*
    static testMethod void getMessageSegmentInputsTest() {



        // Test method with exception
        try {
            ESN_MB_ConnectApi_Helper.getMessageSegmentInputs(null);
        } catch(ESN_MB_ConnectApi_Helper.InvalidParameterException e) {
            System.assert(e.getMessage().contains('inputText parameter'), 'message=' + e.getMessage());
        }

        List<ConnectApi.MessageSegmentInput> result = ESN_MB_ConnectApi_Helper.getMessageSegmentInputs(String inputText) {

    }*/
}