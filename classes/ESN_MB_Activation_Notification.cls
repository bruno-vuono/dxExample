/**
    About
    -----
    Description: Controler Class for MyBrands Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    Activation notification class used to post a chatter feed when an activation is uploaded
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    -------------- 
    Kevin Gerard 15/09/2014 - Get the group Id from the brand.
    Kevin Gerard 15/09/2014 - Set the url of mybrands app directly to the activation
*/
global class ESN_MB_Activation_Notification { 

    //Method that gets the group owner Id
    public static String getGroupOwner(String groupId) {
        //String groupId = '0F9c00000008nq6';
        String owner = [Select Id from user where Id IN (Select OwnerId FROM CollaborationGroup WHERE Id = :groupId)].Id;
        return owner;
    }

    // TODO remove this method    
    public static String getGroupOwner() {
        return getGroupOwner('0F9c00000008nq6');
    }
    
    //Method that sends the feed item to chatter
    @RemoteAction
    public static void sendFeedItem(String activationId, String activationName, String activationProduct, String activationMarket, String groupId) {
        //String groupId = '0F9c00000008nq6';
        String host = ApexPages.currentPage().getHeaders().get('Host');
        String url = host + '/'; // Set the activation direct url
        String groupOwnerId = getGroupOwner(groupId);
        ConnectApi.FeedItem fi = ESN_MB_ConnectApi_Helper.postFeedItemWithMentionsAndUrl(null, groupId, 'Check out my new activation "' 
        + activationName + '"' + ' of ' + activationProduct + ' for ' + activationMarket + ' ! ' + '\n' + '{' + groupOwnerId + '}', url, activationName);    
    }

    // TODO remove this method and use the method below
    @RemoteAction
    public static void sendFeedItem(String activationId, String activationName, String activationProduct, String activationMarket) {
        sendFeedItem(activationId, activationName, activationProduct, activationMarket, '0F9c00000008nq6');
    }
}