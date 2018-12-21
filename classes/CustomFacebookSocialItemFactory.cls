/**
*    This class creates each Facebook Social Item, according to Social TV design
*    @author Marion Aubard (Sylpheo)
*    @revision 1.0 06-2014 Anthony Raingeval (Sylpheo) : first version
*    @revision 1.1 08-08-2014 Marion Aubard (Sylpheo) : manage custom settings
*/
public class CustomFacebookSocialItemFactory {
    public CustomFacebookSocialItemFactory() {
        //init();
    }
    
    
        
    
        
    public static void init() {
        System.debug('init');
        List<socialtv__Social_Configuration__c> configuration = [SELECT custom_facebook_api_url__c FROM socialtv__Social_Configuration__c];
        if (configuration.size() > 0) {
            String facebookURL = configuration[0].custom_facebook_api_url__c;
            if (facebookURL != null) {
                System.debug('Create items');
                createItems(facebookURL);
            } else {
                System.debug('Facebook URL is empty : no Facebook item retrieved');
            }
        } else {
             System.debug('No custom setting : no Facebook item retrieved');
        }
        
    }
    
    public static void createItems(String endpoint) {
        HttpRequest request = new HttpRequest();

        //request.setEndpoint('https://prmobmyportalmobiledev.azure-mobile.net/tables/facebook?$orderby=createdtime%20desc');
        request.setEndpoint(endpoint);
        request.setMethod('GET');
            
        Http http = new Http();
        HTTPResponse response ;
         if (!Test.isRunningTest()) {
          response = http.send(request);
        } else {
          response = CustomFacebookMockHttpResponse.getMockResponse(request);
         }
        List<Object> mapResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
      
        System.debug('mapResponse ' + mapResponse);
        List<socialtv__Social_Item__c> socialItems = new List<socialtv__Social_Item__c>();
        List<socialtv__Social_Source__c> socialSources = [SELECT Id, socialtv__Channel__c, socialtv__Source_ID__c, socialtv__Quantity__c FROM socialtv__Social_Source__c WHERE socialtv__Type__c = 'Facebook (Custom API)' LIMIT 199];
        Map<Id, socialtv__Channel__c> channels = new Map<Id,socialtv__Channel__c>([SELECT Id, socialtv__Day_Limit__c FROM socialtv__Channel__c LIMIT 199]);
        
        
        List<socialtv__Social_Item__c> oldItems = new List<socialtv__Social_Item__c>();
        for (List<socialtv__Social_Item__c> Items : [SELECT Id, socialtv__External_Item_ID__c, socialtv__Post_Date__c, socialtv__Channel__c, socialtv__Source_Id__c FROM socialtv__Social_Item__c WHERE socialtv__Type__c = 'Facebook' ORDER BY socialtv__Post_Date__c DESC])
        {
            for (socialtv__Social_Item__c Item : Items) 
            {
                oldItems.add(Item);
            }
        }
        //---------------------------------- end old items loop --------------------------------------------------------------------------------


        for (socialtv__Social_Source__c s : socialSources) {
            Decimal qty = s.socialtv__Quantity__c;
            integer i = 1; 
            if (qty > 0)
            {
                socialtv__Channel__c dayLimitChannel;
                for (Object post : mapResponse){
                    Map<String, Object> mapPostInfo = (Map<String, Object>)post;
                    socialtv__Social_Item__c item = new socialtv__Social_Item__c();
                    String tmpDate = String.valueOf(mapPostInfo.get('createdtime'));
                    String[] splitStr = tmpDate.split('\\.', 0);
                    String[] strTmp = splitStr[0].split('T', 0); 
                    String[] strDate = strTmp[0].split('-', 0);
                    String[] strTime = strTmp[1].split(':', 0);
                    
                    // non ajout des doublons
                    Boolean itemExists = false;
                    for (socialtv__Social_Item__c oldItem : oldItems)
                    {
                        if ((oldItem.socialtv__External_Item_ID__c == String.valueOf(mapPostInfo.get('externalid'))) && (oldItem.socialtv__Channel__c == s.socialtv__Channel__c))
                        {
                            itemExists = true;
                        }       
                    }
                    if (!itemExists)
                    {                 
                        item.socialtv__Post_Date__c = DateTime.newInstanceGmt(Integer.valueOf(strDate[0]), Integer.valueOf(strDate[1]), Integer.valueOf(strDate[2]), Integer.valueOf(strTime[0]), Integer.valueOf(strTime[1]), Integer.valueOf(strTime[2]));
                        item.socialtv__Channel__c = s.socialtv__Channel__c;
                        dayLimitChannel = channels.get(item.socialtv__Channel__c); //[SELECT socialtv__Day_limit__c FROM socialtv__Channel__c WHERE Id = :item.socialtv__Channel__c];
                        
                        if (((dayLimitChannel != null && dayLimitChannel.socialtv__Day_limit__c != null) && ((DateTime.now().getTime() - item.socialtv__Post_Date__c.getTime())/86400000 < dayLimitChannel.socialtv__Day_limit__c)) || (dayLimitChannel != null && dayLimitChannel.socialtv__Day_limit__c == null))
                        {

                            if (String.valueOf(mapPostInfo.get('networksourcename')) == s.socialtv__Source_ID__c)
                            {
                                item.socialtv__Content__c = String.valueOf(mapPostInfo.get('message'));
                                item.socialtv__Source_ID__c = String.valueOf(mapPostInfo.get('networksourcename'));
                                item.socialtv__Background_URL__c = String.valueOf(mapPostInfo.get('medialarge'));
                                item.socialtv__External_Item_ID__c = String.valueOf(mapPostInfo.get('externalid'));
                                item.socialtv__LikeNumber__c = Integer.valueOf(mapPostInfo.get('likecount'));
                                item.socialtv__Login_Image_URL__c = String.valueOf(mapPostInfo.get('frompicturesmall'));
                                item.socialtv__Nickname__c = String.valueOf(mapPostInfo.get('fromname'));
                                item.socialtv__QRCode_URL__c = String.valueOf(mapPostInfo.get('actionview'));
                                item.socialtv__Shared_Image_URL__c = String.valueOf(mapPostInfo.get('medialarge'));
                                item.socialtv__User_Name__c = String.valueOf(mapPostInfo.get('networksourcename')); 
                                item.socialtv__Type__c = 'Facebook';
                                
                                socialItems.add(item);
  
                                i++;
                                if (i>qty) break;
                                
                            }
                        }
                    }
                }
            }
        }
        
        insert socialItems;
        
        
        
        
        // ------------------------------------------- end recup new item -------------------------------------------------------------------------------------------
        list<socialtv__Social_Item__c> oldItemsToDelete = new list<socialtv__Social_Item__c>();

        
        for (socialtv__Social_Item__c i : oldItems)
        {
            
            if (i.socialtv__Channel__c != null && channels.get(i.socialtv__Channel__c).socialtv__Day_Limit__c != null && (DateTime.now().addDays(- (integer)channels.get(i.socialtv__Channel__c).socialtv__Day_Limit__c)).getTime() > i.socialtv__Post_Date__c.getTime())
            {
                oldItemsToDelete.add(i);
            }
            
        }
        system.debug('old items '+oldItemsToDelete);
        delete oldItemsToDelete;
        map<Id,map<String, socialtv__Social_Source__c>> mapOfSourcesByChannel = new map<Id,map<String, socialtv__Social_Source__c>>(); 
        for (socialtv__Social_Source__c source : socialSources)
        {
            if (mapOfSourcesByChannel.get(source.socialtv__Channel__c) == null)
            {
                map<String, socialtv__Social_Source__c> m = new map<String, socialtv__Social_Source__c>();
                m.put(source.socialtv__Source_Id__c, source); 
                mapOfSourcesByChannel.put(source.socialtv__Channel__c, m);
            }
            else
            {
                mapOfSOurcesByChannel.get(source.socialtv__Channel__c).put(source.socialtv__Source_Id__c, source);
            }
        }
        map<Id, list<socialtv__Social_Item__c>> mapOfItems = new map<Id, list<socialtv__Social_Item__c>>();
        for (list<socialtv__Social_Item__c> items : [SELECT Id, socialtv__Source_Id__c, socialtv__Channel__c FROM socialtv__Social_Item__c WHERE socialtv__Type__c = 'Facebook' ORDER BY socialtv__Post_Date__c DESC])
        {
            for (socialtv__Social_Item__c item : items)
            {
                 // mettre tous les items dans une map de source id, items.
                if (mapOfSourcesByChannel.get(item.socialtv__Channel__c) != null && mapOfSourcesByChannel.get(item.socialtv__Channel__c).get(item.socialtv__Source_Id__c)!= null ){
                    if (mapOfItems.get(mapOfSourcesByChannel.get(item.socialtv__Channel__c).get(item.socialtv__Source_Id__c).Id) == null)
                    {
                        mapOfItems.put(mapOfSourcesByChannel.get(item.socialtv__Channel__c).get(item.socialtv__Source_Id__c).Id, new List<socialtv__Social_Item__c>{item});
                    }
                    else
                    {
                        mapOfItems.get(mapOfSourcesByChannel.get(item.socialtv__Channel__c).get(item.socialtv__Source_Id__c).Id).add(item);
                    }
                }
                
            }
        }
        List<socialtv__Social_Item__c> itemsToDelete = new List<socialtv__Social_Item__c>();
        for (Id sourceID : mapOfItems.KeySet() )
        {
            Integer maxCount = null;
            
            for(socialtv__Social_Source__c s : socialSources){
                if (s.id == sourceId){
                    maxCount = (integer)s.socialtv__Quantity__c;
                    break;
                }
            }
            if ( mapOfItems.get(sourceId).size() > maxCount){
                for(Integer i = maxCount; i < mapOfItems.get(sourceId).size(); i++){
                    itemsToDelete.add(mapOfItems.get(sourceId).get(i));
                }
            }   
        }
        delete itemsToDelete;
        
        
        //--------------------- end delete old items------------------------------------------------------------------------------------------------
          
          System.debug('mapOfItems ' + mapOfItems );
    }
}