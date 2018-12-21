/*
+-----------------------+------------------------------------------------------------------------------------+
| Author                | Cécile Lartaud                                                                     |
+-----------------------+------------------------------------------------------------------------------------+
| Description           |                                                                                    |
|                       |                                                                                    |
|     - Object(s)       | ESN_Video__c                                                                       |
|     - Description     | Display a Chatter Video                                                            |
+-----------------------+------------------------------------------------------------------------------------+
| Creation Date         | 02/10/2013                                                                         |
+-----------------------+------------------------------------------------------------------------------------+
| Modifications         |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
| Governor informations |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
*/
public class ESN_VFC28_VideoDisplay {
    /*############################################################################
    #   A.T.T.R.I.B.U.T.E.S
    ##############################################################################*/
    public ESN_Video__c currVideo {get; set;}
    
    public List<ESN_Video__c> allChatterVideos_lst {get; set;}
    public List<ESN_Video__c> topFiveVideos_lst {get; set;}    
    public Set<String> videoCategories_set {get;set;}
    public Map<Id, User> ownerId2Owner_map {get; set;}
        
    public Map<String, List<ESN_Video__c>> categorie2listVideos_map {get; set;}
    public Map<String, String> cat2CatWithoutSpaces_map {get; set;}
    public Map<String, List<ESN_Video__c>> tag2listVideos_map {get; set;}
    public List<String> currVideoTags_lst {get;set;}
    public List<String> currVideoCats_lst {get;set;}
    
    // Informations from the custom Settings //
    public String ga_tokens {get;set;}
    public String videoAdmin {get; set;}
    public String flowplayerFlashKey {get;set;}
    public String flowplayerHTML5Key {get; set;}
    
    /*############################################################################
    #   C.O.N.S.T.R.U.C.T.O.R
    ##############################################################################*/
    public ESN_VFC28_VideoDisplay(ApexPages.StandardController controller) {
        currVideo = (ESN_Video__c)controller.getRecord();
        
        videoCategories_set = new Set<String>();
        categorie2listVideos_map = new Map<String, List<ESN_Video__c>>();
        cat2CatWithoutSpaces_map = new Map<String, String>();
        
        currVideoTags_lst = new List<String>();
        currVideoCats_lst = new List<String>();
        
        if(currVideo.ESN_VideoTags__c != null)
            currVideoTags_lst = currVideo.ESN_VideoTags__c.replaceall('; ',';').split(';', -1);
            
        if(currVideo.ESN_Categories__c != null){
            currVideoCats_lst = currVideo.ESN_Categories__c.split(';', -1);
            for(String item : currVideoCats_lst )
                cat2CatWithoutSpaces_map.put(item, item.replaceAll(' ', ''));
        }
            
        ownerId2Owner_map = new Map<Id, User>([SELECT Id, SmallPhotoUrl, Name FROM User WHERE Id = :currVideo.OwnerId]);
        topFiveVideos_lst = [SELECT CreatedDate,Name, Id, ESN_Categories__c, ESN_VideoTags__c, ESN_Description__c, ESN_VideoThumbnail__c, ESN_VideoURL__c, ESN_ViewsCount__c, OwnerId FROM ESN_Video__c ORDER BY ESN_ViewsCount__c DESC LIMIT 5];
                                    
      /*  List<Schema.PicklistEntry> catPicklistValues = ESN_Video__c.ESN_Categories__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry item : catPicklistValues) {
            videoCategories_set.add(item.getLabel());
            cat2CatWithoutSpaces_map.put(item.getLabel(), item.getLabel().replaceAll(' ', ''));
        } */
        
        // Get parameters from the custom settings //
        ga_tokens = ''+ESN_ChatterTVSettings__c.getOrgDefaults().ESN_GoogleAnalyticsToken__c;
        flowplayerFlashKey = ''+ESN_ChatterTVSettings__c.getOrgDefaults().ESN_FlowplayerFlashKey__c;
        flowplayerHTML5Key = ''+ESN_ChatterTVSettings__c.getOrgDefaults().ESN_FlowplayerHTML5Key__c;
        
        if(ESN_ChatterTVSettings__c.getOrgDefaults().ESN_AdminEmail__c == null || ESN_ChatterTVSettings__c.getOrgDefaults().ESN_AdminEmail__c == '')
            videoAdmin = 'chatter@test.com';
        else
            videoAdmin = ESN_ChatterTVSettings__c.getOrgDefaults().ESN_AdminEmail__c;
    }
    
    /*
     * Increments the number of views of this video.
     ***/
    public void incrementCountViews() {
        if(currVideo.ESN_ViewsCount__c == null)
            currVideo.ESN_ViewsCount__c = 1;
        else
            currVideo.ESN_ViewsCount__c += 1;
        try {
            update currVideo;
        }catch(Exception e) {
        }
    }
}