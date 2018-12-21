/**
*    FeedItem / FeedComment fields for Chatter Feed search
*
*   //FeedItem (Id, Body, Type, linkUrl, title, CreatedById, CreatedBy.Name, CreatedBy.Profile.CreatedBy.SmallPhotoUrl where parentId = :chatterGroupId ORDER BY CreatedDate DESC),
*   //FeedComment(Id, CommentBody, CommentType, CreatedBy.Name, FeedItemId, InsertedById, ParentId where parentId = :chatterGroupId ORDER BY CreatedDate DESC)];
**/
global class ESN_MB_NOP_Search_DTO {

    public String searchType; // FeedItem / FeedComment / Asset / Article
    
    public ESN_MB_Article__c article;
    public ESN_MB_Asset__c asset;
    public ESN_MB_Activation__c activation;

    public FeedItem feedItem;
    public FeedComment feedComment;

    public String createdBySmallPhotoUrl; // for chatter feeds

/*    public String id;
    public String body;
    public String type;
    
    public String title;
    public String linkUrl;
    
    public String createdById;
    public String createdByName;*/
    

 //   public String parentId;

}