/*
+-----------------------+------------------------------------------------------------------------------------+
| Author                | Cécile Lartaud                                                                     |
+-----------------------+------------------------------------------------------------------------------------+
| Description           |                                                                                    |
|                       |                                                                                    |
|     - Object(s)       | ESN_Video                                                                          |
|     - Description     | Controller of the Chatter TV.                                                                                                                 |
+-----------------------+------------------------------------------------------------------------------------+
| Creation Date         | 02/10/2013                                                                         |
+-----------------------+------------------------------------------------------------------------------------+
| Modifications         |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
| Governor informations |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
*/
public class ESN_VFC29_ChatterTV {
    /*############################################################################
    #   A.T.T.R.I.B.U.T.E.S
    ##############################################################################*/
    public List<ESN_Video__c> allChatterVideos_lst {get; set;}
    public Set<String> videoCategories_set {get;set;}
    public Map<String, List<ESN_Video__c>> categorie2listVideos_map {get; set;}
    
    public Map<String, List<ESN_Video__c>> tag2listVideos_map {get; set;}
    public Map<Id, User> ownerId2Owner_map {get; set;}
    public Map<String, String> cat2CatWithoutSpaces_map {get; set;}
    public List<ESN_Video__c> topFiveVideos_lst {get; set;}
    public String paramCateg {get;set;}
    public String paramTags {get;set;}
    public String paramOpenTab {get;set;}
    public String errmsg {get;set;}
    

public List<ESN_Video__c> listCatVideosFTR {get; set;}
    
    // Informations from the custom Settings //
    public String ga_tokens {get;set;}
    public String videoAdmin {get; set;}
    
    /*############################################################################
    #   C.O.N.S.T.R.U.C.T.O.R
    ##############################################################################*/
    public ESN_VFC29_ChatterTV() {
        videoCategories_set = new Set<String>();
        categorie2listVideos_map = new Map<String, List<ESN_Video__c>>();
        
        cat2CatWithoutSpaces_map = new Map<String, String>();
        
        
        paramCateg = ApexPages.currentPage().getParameters().get('cat');
        paramTags = ApexPages.currentPage().getParameters().get('tag');
        paramOpenTab = ApexPages.currentPage().getParameters().get('tab');
        
    /*    if(paramCateg != null) 
        {
            allChatterVideos_lst = [SELECT Name, Id, ESN_Categories__c, ESN_VideoTags__c, ESN_Description__c, ESN_VideoThumbnail__c, ESN_VideoURL__c, Owner
                                    FROM ESN_Video__c WHERE ESN_Categories__c includes (:paramCateg)];
        }
        if(paramTags != null) 
        {
            String query = '%' + paramTags + '%';
            allChatterVideos_lst = [SELECT Name, Id, ESN_Categories__c, ESN_VideoTags__c, ESN_Description__c, ESN_VideoThumbnail__c, ESN_VideoURL__c, Owner
                                    FROM ESN_Video__c WHERE ESN_VideoTags__c LIKE :query];
        }*/
        
        if(paramCateg == null && paramTags == null) 
        {
            allChatterVideos_lst = [SELECT ESN_SmallDescription__c, ESN_OrderNumber__c, CreatedDate, ESN_PublishedDate__c,Name, Id, ESN_Categories__c, ESN_VideoTags__c, ESN_Description__c, ESN_VideoThumbnail__c, ESN_VideoURL__c, ESN_ViewsCount__c, OwnerId, ESN_dont_display_on_home__c
                                    FROM ESN_Video__c 
                                    ORDER BY ESN_OrderNumber__c ASC, CreatedDate DESC];
        } 
        ownerId2Owner_map = new Map<Id, User>([SELECT Id, SmallPhotoUrl, Name FROM User WHERE Id IN (SELECT OwnerId FROM ESN_Video__c WHERE Id IN :allChatterVideos_lst)]);
        topFiveVideos_lst = [SELECT ESN_SmallDescription__c, CreatedDate,Name, Id, ESN_Categories__c, ESN_VideoTags__c, ESN_Description__c, ESN_VideoThumbnail__c, ESN_VideoURL__c, ESN_ViewsCount__c, OwnerId
                                    FROM ESN_Video__c ORDER BY ESN_ViewsCount__c DESC LIMIT 5];
        errmsg = ''+allChatterVideos_lst.size();
        buildRelationCategory2Videos(allChatterVideos_lst);
        
        // Get parameters from the custom settings //
        ga_tokens = ''+ESN_ChatterTVSettings__c.getOrgDefaults().ESN_GoogleAnalyticsToken__c;
        if(ESN_ChatterTVSettings__c.getOrgDefaults().ESN_AdminEmail__c == null || ESN_ChatterTVSettings__c.getOrgDefaults().ESN_AdminEmail__c == '')
            videoAdmin = 'chatter@test.com';
        else
            videoAdmin = ESN_ChatterTVSettings__c.getOrgDefaults().ESN_AdminEmail__c;
    }
    
    /*############################################################################
    #   M.E.T.H.O.D.S
    ##############################################################################*/
    
    /*
     * Build a map to get a videos list per category.
     *  - Key : Category
     *  - Value : list of videos related to this category
     ***/ 
    public void buildRelationCategory2Videos(List<ESN_Video__c> listVideos)
    {        
   
        for(ESN_Video__c var : listVideos)
        {        
            List<ESN_Video__c> listCatVideos;

            
            /* Add all videos in the map 'All' */
            
            // If category is already in the map, get its videos list. otherwise, create a new list //
            if(categorie2listVideos_map.containsKey('All')){
                listCatVideos = categorie2listVideos_map.get('All');

            } else {
                listCatVideos = new List<ESN_Video__c>();            

            }
            // Add the current video in the list related to the current category //
            // listCatVideos.add(var);

// FTR: {Solution1} L'ajout de la video est desormais conditionnel: Si la vidéo est liée à la catégorie "Not for homepage", on ne la gère pas.
/*
List<String> videoCategoryList = var.ESN_Categories__c.split(';', -1);
if (videoCategoryList.size() == 1){
    String videoCategory = videoCategoryList[0];
    if (videoCategory != 'Connect Tutorials'){
        listCatVideos.add(var);
    }

} else {
    listCatVideos.add(var);
} 
*/

   // FTR: {Solution2} L'ajout de la video est desormais conditionnel: Si la vidéo possède le paramètre "Do not display on home", on ne la gère pas.
if (var.ESN_dont_display_on_home__c == FALSE){
    listCatVideos.add(var);
}            



            // put the list in the map //
            categorie2listVideos_map.put('All', listCatVideos);

            
            /* Add video in the map for its categories */
            
            // The current video is related to at less one category //
            if(var.ESN_Categories__c != null)
            { 
                // Put all categories of the current video in a list //
                List<String> videoCat_lst = var.ESN_Categories__c.split(';', -1);
                                
                // Add the current video in the map for each category //
                for(String cat : videoCat_lst)
                {
                    // Add the category in set if not already in //
                    if(!videoCategories_set.contains(cat)){
                        videoCategories_set.add(cat);
                        cat2CatWithoutSpaces_map.put(cat, cat.replaceAll(' ', ''));
                    }
                    
                    // If category is already in the map, get its videos list. otherwise, create a new list //
                    if(categorie2listVideos_map.containsKey(cat))
                        listCatVideos = categorie2listVideos_map.get(cat);
                    else
                        listCatVideos = new List<ESN_Video__c>();
                    
                    // Add the current video in the list related to the current category //
                    listCatVideos.add(var);
                    
                    // put the list in the map //
                    categorie2listVideos_map.put(cat, listCatVideos);
                }
            }
            else 
            {
                categorie2listVideos_map.put('None', listVideos);
            }
                       
        }
    }
}