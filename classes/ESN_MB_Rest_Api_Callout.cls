global class ESN_MB_Rest_Api_Callout {

    private static String ENDPOINT = Label.ESN_MB_EndPointURL;
    public static String ENDPOINT_AUTH = ENDPOINT + Label.ESN_MB_EndPoint_Auth;
    public static String ENDPOINT_ASSETS  = ENDPOINT + Label.ESN_MB_EndPoint_Assets;
    
    public static Map<String, String> mapBrands;

    public static final String INDEX_STORYBOARD_URL = '-INDEX-';

    /**
    * Post one Asset
    *
    * @param damAssetId: the DAM Asset Id
    **/
    @future (callout=true)
    public static void postAssetsById(String damAssetId) {
        HTTPResponse res = callWebserviceAssets(ENDPOINT_ASSETS + damAssetId);
//        HTTPResponse res = callWebserviceAssets(ENDPOINT_ASSETS + '12664');

        ESN_MB_JSONAsset2Apex damAsset = (ESN_MB_JSONAsset2Apex)JSON.deserialize(res.getBody().replace('-','_'),ESN_MB_JSONAsset2Apex.class);

        List<ESN_MB_JSONAsset2Apex> damAssetsList = new List<ESN_MB_JSONAsset2Apex>();
        damAssetsList.add(damAsset);

        List<ESN_MB_Asset__c> assetsList = buildAssetList(damAssetsList);

        // Get unflagged Assets
        //List<ESN_MB_Asset__c> Unflagged_List = [SELECT Id, Name  FROM ESN_MB_Asset__c];
        Schema.SObjectField f = ESN_MB_Asset__c.ESN_MB_DAMId__c;
        Database.upsert(assetsList, f, false);

    }

    /**
    * Post assets
    *
    * @param range : from to (ie '0-9') - Limited to 101 assets (ie 0-100 100-200...)
    * @param category : brand id (ie pernod_ricard_client_jameson)
    **/
/*    @future (callout=true)
    public static void postAssets(String range, String category) {
        String endpointParams = buildAssetsEndpoint(range, category, null, null);
        HTTPResponse res = callWebserviceAssets(endpointParams);
        System.debug(Logginglevel.WARN, 'HTTPResponse : ' + res);

        List<ESN_MB_JSONAsset2Apex> DAM_Assets_List = (List<ESN_MB_JSONAsset2Apex>)JSON.deserialize(res.getBody().replace('-','_'),List<ESN_MB_JSONAsset2Apex>.class);
        System.debug(Logginglevel.WARN, 'category: ' + category + ', range: ' + range + ', DAM_Assets_List.size()=' + DAM_Assets_List.size());

        buildAndUpsertAssets(DAM_Assets_List);
    }

    @future (callout=true)
    public static void postAssetsByCategory(String category) {
        Integer countAssets = getAssetsCount(category, null, null);
        System.debug(Logginglevel.WARN, 'postAssetsByCategory countAssets:' + countAssets);
        postAssets(0, countAssets, category, null, null);
    }
*/
/*    public static void postAssetsByCategory(String category) {
        postAssets(null, null, category, null, null);
    }

    public static void postAssetsByCategory(String category, Integer startRange, Integer endRange) {
        postAssets(startRange, endRange, category, null, null);
    }

    public static void postAssetsByCategory(String category, Integer startRange, Integer endRange, List<String> session) {
        postAssets(startRange, endRange, category, null, null, session);
    }*/

    /**
    * @param startRange : index of start range. If more than 1000 assets, the batch should be relaunched automatically (with startRange + 1000)
    */
//    @future (callout=true)
/*    public static void postAssetsByLastModified(Date startDate, Date endDate) {
        postAssets(null, null, null, startDate, endDate);
    }

    public static void postAssetsByLastModified(Date startDate, Date endDate, Integer startRange, Integer endRange) {
        postAssets(startRange, endRange, null, startDate, endDate);
    }

    public static void postAssetsByLastModified(Date startDate, Date endDate, Integer startRange, Integer endRange, List<String> session) {
        postAssets(startRange, endRange, null, startDate, endDate, session);
    }

    public static void postAssets(Integer startRange, Integer endRange) {
        postAssets(startRange, endRange, null, null, null);
    }

    public static void postAssets(Integer startRange, Integer endRange, List<String> session) {
        postAssets(startRange, endRange, null, null, null, session);
    }*/
    
    private static Integer getAssetsCount(HTTPResponse res) {
        Integer result = 0;

        if (res != null) {
            String contentRange = res.getHeader('Content-Range');
            if (String.isNotBlank(contentRange)) {
                String[] contentRangeArray = contentRange.split('/');
                result = Integer.valueOf(contentRangeArray[1]);
            }
        }
        System.debug(Logginglevel.WARN, 'getAssetsCount Content-Range=' + result);
        return result;
    }

/*    public static Integer getAssetsCount(String category, Date startDate, Date endDate, List<String> session) {
        Integer result = 0;

        String range = '0-1';
        String endpointParams = buildAssetsEndpoint(range, category, startDate, endDate);

        HTTPResponse res = callWebserviceAssets(endpointParams, session);
        result = getAssetsCount(res);

        return result;
    }*/
    
    public static Integer getAssetsCount(String category, Datetime startDate, Datetime endDate, List<String> session) {
        Integer result = 0;

        String range = '0-1';
        String endpointParams = buildAssetsEndpoint(range, category, startDate, endDate);

        HTTPResponse res = callWebserviceAssets(endpointParams, session);
        result = getAssetsCount(res);

        return result;
    }

/*
//    @future (callout=true)
    private static void postAssets(Integer startRange, Integer endRange, String category, Date startDate, Date endDate) {
        postAssets(startRange, endRange, category, startDate, endDate, null);
    }*/
/*
    private static void postAssets(Integer startRange, Integer endRange, String category, Date startDate, Date endDate, List<String> session) {
        if (session == null) {
            session = postAuth();
        }

        Integer maxRange = 100; // Max assets to get
        if (startRange == null) {
            startRange = 0;
        }
        if (endRange == null) {
            endRange = maxRange;
        }

        String range = startRange + '-' + String.valueOf(endRange);
        String endpointParams = buildAssetsEndpoint(range, category, startDate, endDate);

        HTTPResponse res = callWebserviceAssets(endpointParams, session);

        List<ESN_MB_JSONAsset2Apex> DAM_Assets_List = (List<ESN_MB_JSONAsset2Apex>)JSON.deserialize(res.getBody().replace('-','_'),List<ESN_MB_JSONAsset2Apex>.class);
        List<ESN_MB_Asset__c> assetsList = buildAssetList(DAM_Assets_List);

        System.debug(Logginglevel.WARN, 'range=' + range + '/' + endRange + ', DAM_Assets_List.size()=' + DAM_Assets_List.size() + ', Upsert assetsList.size()=' + assetsList.size());
        if (assetsList.size() > 0) {
            upsertAssets(assetsList);
        }
    }
*/
    /**
    * Get all assets
    * Call this method only by batch (new ESN_MB_Rest_DAM_Batch())
    **/
/*    public static List<ESN_MB_Asset__c> getAssets(Integer startRange, Integer endRange, List<String> session) {
        return getAssets(startRange, endRange, null, null, null, session);
    }
    public static List<ESN_MB_Asset__c> getAssetsByLastModified(Date startDate, Date endDate, Integer startRange, Integer endRange, List<String> session) {
        return getAssets(startRange, endRange, null, startDate, endDate, session);
    }
    public static List<ESN_MB_Asset__c> getAssetsByCategory(String category, Integer startRange, Integer endRange, List<String> session) {
        return getAssets(startRange, endRange, category, null, null, session);
    }
    private static List<ESN_MB_Asset__c> getAssets(Integer startRange, Integer endRange, String category, Date startDate, Date endDate, List<String> session) {
        return getAssetsWithFilter(startRange, endRange, category, startDate, endDate, session).get(0);
    }

    public static List<List<ESN_MB_Asset__c>> getAssetsWithFilter(Integer startRange, Integer endRange, List<String> session) {
        return getAssetsWithFilter(startRange, endRange, null, null, null, session);
    }
    public static List<List<ESN_MB_Asset__c>> getAssetsByLastModifiedWithFilter(Date startDate, Date endDate, Integer startRange, Integer endRange, List<String> session) {
        return getAssetsWithFilter(startRange, endRange, null, startDate, endDate, session);
    }
    public static List<List<ESN_MB_Asset__c>> getAssetsByCategoryWithFilter(String category, Integer startRange, Integer endRange, List<String> session) {
        return getAssetsWithFilter(startRange, endRange, category, null, null, session);
    }
    public static List<List<ESN_MB_Asset__c>> getAssetsWithFilter(Integer startRange, Integer endRange, String category, Date startDate, Date endDate, List<String> session) {
        Datetime startTime = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
        Datetime endTime = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day());
        return getAssets(startRange, endRange, category, startTime, endTime, session);
    }*/
    public static List<List<ESN_MB_Asset__c>> getAssets(Integer startRange, Integer endRange, String category, Datetime startDate, Datetime endDate, List<String> session) {
        if (session == null) {
            session = postAuth();
        }

        Integer maxRange = 100; // Max assets to get
        if (startRange == null) {
            startRange = 0;
        }
        if (endRange == null) {
            endRange = maxRange;
        }

        String range = startRange + '-' + String.valueOf(endRange-1);
        String endpointParams = buildAssetsEndpoint(range, category, startDate, endDate);
        
        HTTPResponse res = callWebserviceAssets(endpointParams, session);
        List<List<ESN_MB_Asset__c>> assetsList = new List<List<ESN_MB_Asset__c>>();
        if(res != null){
            List<ESN_MB_JSONAsset2Apex> DAM_Assets_List = (List<ESN_MB_JSONAsset2Apex>)JSON.deserialize(res.getBody().replace('-','_'),List<ESN_MB_JSONAsset2Apex>.class);
            assetsList = buildAssetListWithFilter(DAM_Assets_List);
        }

        return assetsList;
    }

    private static HTTPResponse callWebserviceAssets(String endpointUrl) {
        return callWebserviceAssets(endpointUrl, null);
    }

    private static HTTPResponse callWebserviceAssets(String endpointUrl, List<String> session) {
        if (session == null || session.size() != 2) {
            session = postAuth();
        }
        String jSessionId = session[0];
        String token = session[1];
        
        // Build the request
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpointUrl);
        //req.setEndpoint(ENDPOINT_ASSETS + '?httpRange=30-31');
        //req.setEndpoint(ENDPOINT_ASSETS + '12664');
        //req.setEndpoint(ENDPOINT_ASSETS + '?httpRange=0-14&query=%2Bcategory%3Apernod_ricard_client_jameson');
        //req.setEndpoint(ENDPOINT_ASSETS + '?query=%2Bcategory%pernod_ricard_client_beefeater_gin');
        
        req.setTimeout(120000);
         //req.setHeader('Content-Type', 'application/json');
        
        req.setHeader('JSESSIONID',jSessionId);
        req.setHeader('X-XSRF-TOKEN',token);
        req.setHeader('Cookie','JSESSIONID='+jSessionId+'; formToken='+token);
        
        Http http = new Http();
        HTTPResponse res = null;
        try {
            res = http.send(req);
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
        }

        //System.debug(Logginglevel.WARN, 'Returned status: ' + res.getStatusCode()); 
        return res;
    }

    /**
    * Get Token from DAM
    **/
    public static List<String> postAuth() { 
        
         // Set the login credentials
         //String username = 'test@northplains.com';
         //String password = 'TEST_123';
         
         String username = ESN_MB_Utils.cs_NPUser();
         String password = ESN_MB_Utils.cs_NPPassword();         
         
         // Build the request
         HttpRequest loginReq = new HttpRequest();
         loginReq.setMethod('POST');
         loginReq.setEndpoint(ENDPOINT_AUTH);
         loginReq.setHeader('Content-Type', 'application/json');
         loginReq.setBody('{"username":"' + username + '","password":"' + password + '"}');
         
         Http http = new Http();
         HTTPResponse res = http.send(loginReq);
         System.debug(Logginglevel.WARN, 'Response body: ' + res.getBody());
         // Get the cookie
         String cookie = res.getHeader('Set-Cookie');
         System.debug(Logginglevel.WARN, 'Set-Cookie: ' + cookie );
         // Get the index of the beginning of the JSESSIONID (after 'JSESSIONID=')
         Integer indexSession = cookie.indexOf('JSESSIONID=')+11;
         String cookieSession = cookie.substring(indexSession);
         Integer indexEndSession = cookieSession.indexOf(';');
         String jSessionId = cookieSession.substring(0,indexEndSession);
         // Get the index of the beginning of the JSESSIONID (after 'formToken=')
         Integer indexToken = cookie.indexOf('formToken=')+10;
         String cookieToken = cookie.substring(indexToken);
         Integer indexEndToken= cookieToken.indexOf(';');
         String token = cookieToken.substring(0, indexEndToken);
         System.debug(Logginglevel.WARN, 'JSESSIONID: ' + jSessionId + ' - X-XSRF-TOKEN: ' + token);
         //Add the session and token to a list to return
         List<String> session = new List<String>();
         session.add(jSessionId);
         session.add(token);
         System.debug(Logginglevel.WARN, session[0] + session[1]);
         
         return session;
    }             
/*
    // Not use yet
    @TestVisible
    private static void deleteOldAssets(List<ESN_MB_Asset__c> assetList) {
        List<Id> oldAssetList = new List<Id>();
        for (ESN_MB_Asset__c a : assetList) {
            if ((String.isBlank(a.ESN_MB_Taxonomy_Permissions__c) || !a.ESN_MB_Taxonomy_Permissions__c.containsIgnoreCase('MyBrands'))
                    || (a.ESN_MB_expiry_date_required__c && Date.today() > a.ESN_MB_expiry_date__c)
                // TODO which status to delete assets?
                //    || (!'Published'.equals(a.ESN_MB_workflow_status__c))) {
                ) {
                oldAssetList.add(a.Id);
            }
        }
        System.debug(Logginglevel.WARN, 'oldAssetList: ' + oldAssetList);

        // Get unflagged Assets
        //List<ESN_MB_Asset__c> Unflagged_List = [SELECT Id, Name  FROM ESN_MB_Asset__c];
        Schema.SObjectField f = ESN_MB_Asset__c.ESN_MB_DAMId__c;
        Database.delete(oldAssetList);
    }
*/
    /**
    * Build the endpoint url to call the webservice
    *
    * @param range : from to (ie '30-31')
    * @param category : brand name (ie pernod_ricard_client_jameson)
    **/
/*    private static String buildAssetsEndpoint(String range, String category, Date startDate, Date endDate) {
        Datetime startTime = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
        Datetime endTime = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day());

        return buildAssetsEndpoint(range, category, startTime, endTime);
    }*/
    private static String buildAssetsEndpoint(String range, String category, Datetime startDate, Datetime endDate) {
        System.debug(Logginglevel.WARN, 'buildAssetsEndpoint: range=' + range + ', category=' + category + ', startDate=' + startDate + ', endDate=' + endDate);

        String endPointParams = ENDPOINT_ASSETS + '?';

        //req.setEndpoint(ENDPOINT_ASSETS + '?httpRange=0-14&query=%2Bcategory%3Apernod_ricard_client_jameson');
        //req.setEndpoint(ENDPOINT_ASSETS + '?query=%2Bcategory%pernod_ricard_client_beefeater_gin');
        // ?httpRange=0-10&query=%2BlastModifiedDate%3A%5B2014091000000+TO+2014091100000%5D
        // ?httpRange=0-10&query=%2BcreationDate%3A%5B2014091000000+TO+2014091100000%5D

        if (String.isNotBlank(range)) {
            endPointParams += 'httpRange=' + range + '&';
        }
        endPointParams += 'query=';

        boolean hasNewParameter = false;
        if (String.isNotBlank(category)) {
            endPointParams += '%2Bcategory%3A' + category;
            hasNewParameter = true;
        }

        if (startDate != null && endDate != null && startDate < endDate) {
            if (hasNewParameter) {
                endPointParams += '+%2B';
            }
            String startMonth = (startDate.month() < 10 ? '0' + String.valueOf(startDate.month()) : String.valueOf(startDate.month()));
            String startDay = (startDate.day() < 10 ? '0' + String.valueOf(startDate.day()) : String.valueOf(startDate.day()));
            String startHour = (startDate.hour() < 10 ? '0' + String.valueOf(startDate.hour()) : String.valueOf(startDate.hour()));
            String startMinute = (startDate.minute() < 10 ? '0' + String.valueOf(startDate.minute()) : String.valueOf(startDate.minute()));
//            endPointParams += '%2BlastModifiedDate%3A%5B' + startDate.year() + startMonth + startDay + '00000+TO+';
            endPointParams += 'lastModifiedDate%3A%5B' + startDate.year() + startMonth + startDay + startHour + startMinute + '0+TO+';

            String endMonth = (endDate.month() < 10 ? '0' + String.valueOf(endDate.month()) : String.valueOf(endDate.month()));
            String endDay = (endDate.day() < 10 ? '0' + String.valueOf(endDate.day()) : String.valueOf(endDate.day()));
            String endHour = (endDate.hour() < 10 ? '0' + String.valueOf(endDate.hour()) : String.valueOf(endDate.hour()));
            String endMinute = (endDate.minute() < 10 ? '0' + String.valueOf(endDate.minute()) : String.valueOf(endDate.minute()));
            endPointParams += endDate.year() + endMonth + endDay + endHour + endMinute + '0%5D';
            //endPointParams += Label.ESN_MB_DAM_TaggedForMB;
            hasNewParameter = true;
        }

        System.debug(Logginglevel.WARN, 'endpoint:' + endPointParams);
        return endPointParams;
    }

    /**
    * Format the DAM date to a Salesforce date format
    * 
    * @param dateString : format 'DD.MM.YYYY HH:MM'
    **/
    private static Date formatDate(String dateString) {
        Date dateResult = null;
        if(String.isNotBlank(dateString)) {
            String dateSplit = dateString.split(' ', 2)[0];

            String[] dateArray = dateSplit.split('\\.', 3);
            dateResult = Date.newInstance(Integer.valueOf(dateArray[2]), Integer.valueOf(dateArray[1]), Integer.valueOf(dateArray[0]));
        }
        return dateResult;
    }

    /**
    * Build the taxonomy by type
    * @param taxonomy: the taxonomy structure
    * @return Map<String, String>: Map <taxonomy type, categories (split by '/' caracter)> 
    */
    private static Map<String, String> buildTaxonomyMap(ESN_MB_JSONAsset2Apex.Taxonomy taxonomy) {
        Map<String, String> taxonomyMap = new Map<String, String>();

        if (!ESN_MB_Utils.empty(taxonomy) && taxonomy.categories != null) {
            // For each taxonomy type (ie Brand, Market Suitability...), build its category list
            for (ESN_MB_JSONAsset2Apex.Category taxonomyType : taxonomy.categories) {
                List<String> categoryNameList = getTaxonomyNameList(taxonomyType.categories);
                taxonomyMap.put(taxonomyType.name, String.join(categoryNameList, '/'));
            }
        }

        //System.debug(Logginglevel.WARN, 'buildTaxonomyMap/taxonomyMap:' + taxonomyMap);
        return taxonomyMap;
    }

    /**
    * get all categories' name for a taxonomy type
    * @param categoryList: categories' list from a taxonomy type
    * @return all categories' name
    **/
    private static List<String> getTaxonomyNameList(List<ESN_MB_JSONAsset2Apex.Category> categoryList) {
        List<String> categoryNameList = new List<String>();

        if (categoryList != null) {
            for (ESN_MB_JSONAsset2Apex.Category category: categoryList) {
				if (category.Name != 'pernod_ricard_client_ibp') {
					categoryNameList.add(category.Name);
					categoryNameList.addAll(getTaxonomyNameList(category.categories));
				}
            }
        }
        return categoryNameList;
    }

    private static List<ESN_MB_Asset__c> buildAssetList(List<ESN_MB_JSONAsset2Apex> DAM_Assets_List) {
        return buildAssetListWithFilter(DAM_Assets_List).get(0);
    }
    private static List<List<ESN_MB_Asset__c>> buildAssetListWithFilter(List<ESN_MB_JSONAsset2Apex> DAM_Assets_List) {
        List<ESN_MB_Asset__c> assetsList = new List<ESN_MB_Asset__c>();
        List<ESN_MB_Asset__c> filterAssetDamIdList = new List<ESN_MB_Asset__c>();

        String assetDamRecordType = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        Set<String> brandEnabledSet = getBrandIdEnabledSet();
        
        System.debug(Logginglevel.WARN, 'DAM_Assets_List size : ' + DAM_Assets_List.size());
        
        for (ESN_MB_JSONAsset2Apex DAM_Asset : DAM_Assets_List) {
            if (String.isNotBlank(Dam_Asset.Id)) {
                try {
                    ESN_MB_Asset__c a = new ESN_MB_Asset__c();
                    a.recordTypeId = assetDamRecordType;
                    a.ESN_MB_DAMId__c = Dam_Asset.id;
                    a.ESN_MB_creationDate__c = formatDate(Dam_Asset.creationDate);
                    a.ESN_MB_modificationDate__c = formatDate(Dam_Asset.modificationDate);
                    a.ESN_MB_version__c = (String.isNotBlank(Dam_Asset.version) ? Integer.valueOf(Dam_Asset.version) : 0);
                    a.ESN_MB_collectionSchema__c = Dam_Asset.collectionSchema;
                    if(Dam_Asset.name.length() > 80) {
                        a.Name = Dam_Asset.name.substring(0, 79);
                    }else {
                        a.Name = Dam_Asset.name;
                    }
                 //   a.ESN_MB_shortName__c = (name.length() > 25 ? name.substring(0,25) : name);
                    a.ESN_MB_description__c = Dam_Asset.description;
                    a.ESN_MB_locale__c = Dam_Asset.locale;
                    a.ESN_MB_keywords__c = Dam_Asset.keywords;
    
                    if (!ESN_MB_Utils.empty(Dam_Asset.metadata)) {
                        a.ESN_MB_usage_rights__c = (Dam_Asset.metadata.usage_rights != null)?Dam_Asset.metadata.usage_rights.left(255):'';
                        a.ESN_MB_type__c = (Dam_Asset.metadata.type != null)?Dam_Asset.metadata.type.left(255):'';
                        a.ESN_MB_workflow_status__c = (Dam_Asset.metadata.workflow_status != null)?Dam_Asset.metadata.workflow_status.left(255):'';
                        a.ESN_MB_expiry_date__c = formatDate(Dam_Asset.metadata.expiry_date);
                        // Dam_Asset.metadata.photographer_credit ?
                        // Dam_Asset.metadata.sku ?
                        a.ESN_MB_usage_rights_type__c = (Dam_Asset.metadata.usage_rights_type != null)?Dam_Asset.metadata.usage_rights_type.left(255):'';
                        a.ESN_MB_expiry_date_required__c = ('required'.equals(Dam_Asset.metadata.expiry_date_required) ? true : false);
                        a.ESN_MB_client__c = (Dam_Asset.metadata.client != null)?Dam_Asset.metadata.client.left(255):''; // Not in DAM anymore?
                    } else {
                        a.ESN_MB_usage_rights__c = null;
                        a.ESN_MB_type__c = null;
                        a.ESN_MB_workflow_status__c = null;
                        a.ESN_MB_expiry_date__c = null;
                        a.ESN_MB_usage_rights_type__c = null;
                        a.ESN_MB_expiry_date_required__c = false;
                        a.ESN_MB_client__c = null; // Not in DAM anymore?
                    }
    
                    if (!ESN_MB_Utils.empty(Dam_Asset.FileInfo)) {
                        a.ESN_MB_fileName__c = (Dam_Asset.FileInfo.name != null)?Dam_Asset.FileInfo.name.left(255):'';
                        a.ESN_MB_mimeType__c = (Dam_Asset.FileInfo.mimeType != null)?Dam_Asset.FileInfo.mimeType.left(255):'';
                        a.ESN_MB_size__c = Long.valueOf(Dam_Asset.FileInfo.size) / 1000; // Size to be in Ko
                        a.ESN_MB_prettySize__c = Dam_Asset.FileInfo.prettySize; // Size already in Ko
                        a.ESN_MB_md5__c = (Dam_Asset.FileInfo.md5 != null)?Dam_Asset.FileInfo.md5.left(255):'';
                    } else {
                        a.ESN_MB_fileName__c = null;
                        a.ESN_MB_mimeType__c = null;
                        a.ESN_MB_size__c = null;
                        a.ESN_MB_prettySize__c = null;
                        a.ESN_MB_md5__c = null;
                    }
    
                    if (!ESN_MB_Utils.empty(Dam_Asset.Rating)) {
                        a.ESN_MB_count__c=Dam_Asset.rating.count;
                        a.ESN_MB_sum__c=Dam_Asset.Rating.sum;
                        a.ESN_MB_average__c=Dam_Asset.Rating.average;
                    } else {
                        a.ESN_MB_count__c = null;
                        a.ESN_MB_sum__c = null;
                        a.ESN_MB_average__c = null;                    
                    }
    
                    // Field to delete: a.ESN_MB_Taxonomy__c = buildTaxonomy(Dam_Asset.Taxonomy);
                    Map<String, String> taxonomyMap = buildTaxonomyMap(Dam_Asset.Taxonomy);
                    a.ESN_MB_Taxonomy_Brands__c = taxonomyMap.get('Brands');

                    String brandVariantValue = taxonomyMap.get('Brand and Variant');
                    if (String.isBlank(brandVariantValue)) {
                        brandVariantValue = getDefaultBrandVariant(a.ESN_MB_Taxonomy_Brands__c);
                    }
                    a.ESN_MB_Taxonomy_BrandVariant__c = brandVariantValue;
                    a.ESN_MB_Taxonomy_AssetType__c = taxonomyMap.get('Asset Type');
                    a.ESN_MB_Taxonomy_MarketingActivity__c = taxonomyMap.get('Marketing Activity');
                    a.ESN_MB_Taxonomy_BrandMaterials__c = taxonomyMap.get('Brand Materials');
                    a.ESN_MB_Taxonomy_MarketInformation__c = taxonomyMap.get('Market Information');
                    a.ESN_MB_Taxonomy_Category__c = taxonomyMap.get('Category');
                    a.ESN_MB_Taxonomy_MarketSuitability__c = taxonomyMap.get('Market Suitability');
                    a.ESN_MB_Taxonomy_Language__c = taxonomyMap.get('Language');
                    a.ESN_MB_Taxonomy_Permissions__c = taxonomyMap.get('Permissions');
    
                    if (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles)) {
                        a.ESN_MB_URL_bamArticleFull__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamArticleFull) ? Dam_Asset.DerivedFiles.bamArticleFull.url : null);
                        a.ESN_MB_URL_bamArticleHalf__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamArticleHalf) ? Dam_Asset.DerivedFiles.bamArticleHalf.url : null);
                        a.ESN_MB_URL_bamAssetPreview__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamAssetPreview) ? Dam_Asset.DerivedFiles.bamAssetPreview.url : null);
                        a.ESN_MB_URL_bamThumbnail__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamThumbnail) ? Dam_Asset.DerivedFiles.bamThumbnail.url : null);
                        a.ESN_MB_URL_cwAnnotationPreview__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.cwAnnotationPreview) ? Dam_Asset.DerivedFiles.cwAnnotationPreview.url : null);
                        a.ESN_MB_URL_forsightLargePreview__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.forsightLargePreview) ? Dam_Asset.DerivedFiles.forsightLargePreview.url : null);
                        a.ESN_MB_URL_forsightPreview__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.forsightPreview) ? Dam_Asset.DerivedFiles.forsightPreview.url : null);
                        a.ESN_MB_URL_forsightThumbnail__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.forsightThumbnail) ? Dam_Asset.DerivedFiles.forsightThumbnail.url : null);
                        a.ESN_MB_URL_imagePreview__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.imagePreview) ? Dam_Asset.DerivedFiles.imagePreview.url : null);
                        a.ESN_MB_URL_thumbnail__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.thumbnail) ? Dam_Asset.DerivedFiles.thumbnail.url : null);
                        a.ESN_MB_URL_bamPresentationUse__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamPresentationUse) ? Dam_Asset.DerivedFiles.bamPresentationUse.url : null);
                        a.ESN_MB_URL_bamVideoPreview__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamVideoPreview) ? Dam_Asset.DerivedFiles.bamVideoPreview.url : null);
                        a.ESN_MB_URL_bamVideoPreview720__c = (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.bamVideoPreview720) ? Dam_Asset.DerivedFiles.bamVideoPreview720.url : null);
                        
                        if (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.storyboard)) {
                            List<String> storyBoardUrlList = Dam_Asset.DerivedFiles.storyboard.url;

                            a.ESN_MB_Storyboard__c = (storyBoardUrlList.size() > 0 ? true : false);
                            a.ESN_MB_Storyboard_Slide_Count__c = storyBoardUrlList.size();
                            
                            // Replace '/servlet/file/a35428c92ae4.16.jpg?ITEM_ENT' by '/servlet/file/a35428c92ae4.<INDEX>.jpg?ITEM_ENT
                            if (storyBoardUrlList.size() > 0) {
                                String[] storyUrlSplit = storyBoardUrlList.get(0).split('\\.');
                                
                                if (storyUrlSplit.size() > 1) {
                                    storyUrlSplit[1] = INDEX_STORYBOARD_URL;
                                
                                    String urlFinal = String.join(storyUrlSplit, '.');
                                    System.debug(Logginglevel.WARN, 'urlFinal: ' + urlFinal);
                                    a.ESN_MB_Storyboard_URL__c = urlFinal;
                                }
                            }
                        }
                        if (!ESN_MB_Utils.empty(Dam_Asset.DerivedFiles.storyboardlarge)) {
                            List<String> storyBoardUrlList = Dam_Asset.DerivedFiles.storyboardlarge.url;

                            // Replace '/servlet/file/a35428c92ae4.16.jpg?ITEM_ENT' by '/servlet/file/a35428c92ae4.<INDEX>.jpg?ITEM_ENT
                            if (storyBoardUrlList.size() > 0) {
                                String[] storyUrlSplit = storyBoardUrlList.get(0).split('\\.');
                                
                                if (storyUrlSplit.size() > 1) {
                                    storyUrlSplit[1] = INDEX_STORYBOARD_URL;
                                
                                    String urlFinal = String.join(storyUrlSplit, '.');
                                    System.debug(Logginglevel.WARN, 'urlFinal: ' + urlFinal);
                                    a.ESN_MB_Storyboard_LargeURL__c = urlFinal;
                                }
                            }
                        }
                        
                    } else {
                        a.ESN_MB_URL_bamArticleFull__c = null;
                        a.ESN_MB_URL_bamArticleHalf__c = null;
                        a.ESN_MB_URL_bamAssetPreview__c = null;
                        a.ESN_MB_URL_bamThumbnail__c = null;
                        a.ESN_MB_URL_cwAnnotationPreview__c = null;
                        a.ESN_MB_URL_forsightLargePreview__c = null;
                        a.ESN_MB_URL_forsightPreview__c = null;
                        a.ESN_MB_URL_forsightThumbnail__c = null;
                        a.ESN_MB_URL_imagePreview__c = null;
                        a.ESN_MB_URL_thumbnail__c = null;
                        a.ESN_MB_URL_bamPresentationUse__c = null;
                        a.ESN_MB_URL_bamVideoPreview__c = null;
                        a.ESN_MB_URL_bamVideoPreview720__c = null;
                        a.ESN_MB_Storyboard__c = false;
                    }

                    //System.debug(Logginglevel.WARN, 'Start ESN_MB_Utils.empty(Dam_Asset.ImageInfo)');
                    if (!ESN_MB_Utils.empty(Dam_Asset.ImageInformation)) {
                        System.debug(Logginglevel.WARN, 'Dam_Asset.ImageInformation :' + Dam_Asset.ImageInformation );
                        a.ESN_MB_height__c = Integer.valueOf(Dam_Asset.ImageInformation.height); 
                        a.ESN_MB_width__c = Integer.valueOf(Dam_Asset.ImageInformation.width);
                        System.debug(Logginglevel.WARN, 'a.ESN_MB_height__c :' + a.ESN_MB_height__c );
                        System.debug(Logginglevel.WARN, 'a.ESN_MB_width__c:' + a.ESN_MB_width__c);
                        // Dam_Asset.DerivedFiles.imageInformation.url?
                    } else {
                        a.ESN_MB_height__c = null; 
                        a.ESN_MB_width__c = null;
                    }

                    if (!ESN_MB_Utils.empty(Dam_Asset.OriginalFile)) {
                        a.ESN_MB_originalFile_extension__c = Dam_Asset.OriginalFile.extension;
                        if(Dam_Asset.OriginalFile.url.length()>255) {
                            a.ESN_MB_URL_originalFile__c = Dam_Asset.OriginalFile.url.substring(0,254);
                        }else {
                            a.ESN_MB_URL_originalFile__c = Dam_Asset.OriginalFile.url;
                        }
                    } else {
                        a.ESN_MB_originalFile_extension__c = null;
                        a.ESN_MB_URL_originalFile__c = null;
                    }

                    //System.debug(Logginglevel.WARN, 'a.ESN_MB_Taxonomy_Brands__c:' + a.ESN_MB_Taxonomy_Brands__c+ ', brandEnabledSet:' + brandEnabledSet + ', a.ESN_MB_Taxonomy_Permissions__c:' + a.ESN_MB_Taxonomy_Permissions__c + ', a.ESN_MB_expiry_date_required__c:' + a.ESN_MB_expiry_date_required__c);
                    // Filter Assets: Don't upsert/delete an asset in a disabled brand
                    if (brandEnabledSet.contains(a.ESN_MB_Taxonomy_Brands__c)) { 
                        if ((!a.ESN_MB_expiry_date_required__c || ( a.ESN_MB_expiry_date_required__c && Date.today() < a.ESN_MB_expiry_date__c))
                                && 'Published'.equals(a.ESN_MB_workflow_status__c)) {
                            System.debug(Logginglevel.WARN, 'To upsert:' + Dam_Asset.Id + ', ' + Dam_Asset.name);// + ' --- avec : ' + Dam_Asset.metadata.expiry_date_required); 
                            assetsList.add(a);
                        } else {
                            System.debug(Logginglevel.WARN, 'To delete:' + Dam_Asset.Id + ', ' + Dam_Asset.name);
                            filterAssetDamIdList.add(a);
                        }

						//if (String.isNotBlank(a.ESN_MB_Taxonomy_Permissions__c) && a.ESN_MB_Taxonomy_Permissions__c.containsIgnoreCase('MyBrands Public Library')
                                //&& (!a.ESN_MB_expiry_date_required__c || ( a.ESN_MB_expiry_date_required__c && Date.today() < a.ESN_MB_expiry_date__c))
                                //&& 'Published'.equals(a.ESN_MB_workflow_status__c)) {
                            //System.debug(Logginglevel.WARN, 'To upsert:' + Dam_Asset.Id + ', ' + Dam_Asset.name);// + ' --- avec : ' + Dam_Asset.metadata.expiry_date_required); 
                            //assetsList.add(a);
                        //} else {
                            //System.debug(Logginglevel.WARN, 'To delete:' + Dam_Asset.Id + ', ' + Dam_Asset.name);
                            //filterAssetDamIdList.add(a);
                        //}
                    } else {
                        System.debug(Logginglevel.WARN, 'No action for a disabled brand ' + a.ESN_MB_Taxonomy_Brands__c + ', Asset ' + Dam_Asset.Id + ', ' + Dam_Asset.name);
                    }
                } catch (Exception e) {
                    System.debug(Logginglevel.WARN, 'Error ' + Dam_Asset.Id + ', ' + Dam_Asset.name + ': ' + e);
                }
            }
        }
        System.debug(Logginglevel.WARN, 'assetsList.size()=' + assetsList.size() + ', filterAssetDamIdList.size()=' + filterAssetDamIdList.size());
        
        List<List<ESN_MB_Asset__c>> result = new List<List<ESN_MB_Asset__c>>();
        result.add(assetsList);
        result.add(filterAssetDamIdList);

        return result;
    }

    private static String getDefaultBrandVariant(String damId) {
        if(mapBrands == null){
            List<ESN_MB_NodePage__c> listBrand = [Select ESN_MB_Brand_DAM_Id__c, ESN_MB_Default_Brand_Variant_Value__c FROM ESN_MB_NodePage__c WHERE RecordType.DeveloperName = 'ESN_MB_Brand'];

            mapBrands = new Map<String, String>();
            for(ESN_MB_NodePage__c brandTmp : listBrand){
                mapBrands.put(brandTmp.ESN_MB_Brand_DAM_Id__c, brandTmp.ESN_MB_Default_Brand_Variant_Value__c);
            }
        }
        return mapBrands.get(damId);
    }

    /**
    * Get all enabled brands
    * @return : set of DAM Brand Id
    **/
    private static Set<String> getBrandIdEnabledSet() {
        Set<String> brandIdEnabledSet = new Set<String>();

        List<ESN_MB_NodePage__c> brandList = getBrandEnabledInitList();
        //List<ESN_MB_NodePage__c> brandList = ESN_MB_Rest_DAM_Batch.getBrandEnabledList();
        for (ESN_MB_NodePage__c brand : brandList) {
            String damId = brand.ESN_MB_Brand_DAM_Id__c;
            if (String.isNotBlank(damId)) {
                brandIdEnabledSet.add(damId);
            }
        }
        return brandIdEnabledSet;
    }
    public static List<ESN_MB_NodePage__c> getBrandEnabledInitList() {
        List<ESN_MB_NodePage__c> brandList = [SELECT Id, Name, ESN_MB_Brand_DAM_Id__c, ESN_MB_Brand_Initialization__c, ESN_MB_Brand_LastImportAssetsDate__c from ESN_MB_NodePage__c where RecordType.DeveloperName='ESN_MB_Brand' and ESN_MB_Deployment_Status__c in ('Enable', 'Work in progress') and ESN_MB_Brand_Initialization__c = true];

        System.debug(Logginglevel.WARN, 'getBrandEnabledInitList:size=' + brandList.size());
        return brandList;
    }
}