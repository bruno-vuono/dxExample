global class ESN_MB_NOP_SearchAsset_Cx {
    /**
    * Method searchAssets(String searchText)
    * @param searchText: String param corresponding to the text typed by user
    * @param assetType: String param corresponding to the type of asset to search
    * @return assetList: returns a list of assets
    */
    @RemoteAction
    global static List<List<Object>> searchAssets(String searchText, String assetType, String brandId) {
        //String brandVariantValue = '';

        List<ESN_MB_NodePage__c> listBrands = new List<ESN_MB_NodePage__c>();
        List<String> brandDamIds = new List<String>();          

        if(isLeCercleBrand(brandId)) {
            listBrands = [SELECT ESN_MB_Brand_DAM_Id__c FROM ESN_MB_NodePage__c WHERE ESN_MB_Brand_DAM_Id__c != null];
            for(ESN_MB_NodePage__c brand : listBrands) {
                brandDamIds.add(brand.ESN_MB_Brand_DAM_Id__c);
            }
        } else {
            //listBrands = [SELECT ESN_MB_Default_Brand_Variant_Value__c, ESN_MB_Brand_DAM_Id__c FROM ESN_MB_NodePage__c WHERE Id = :brandId LIMIT 1];
            listBrands = [SELECT ESN_MB_Brand_DAM_Id__c FROM ESN_MB_NodePage__c WHERE Id = :brandId LIMIT 1];
            if(listBrands.size() > 0) {
                brandDamIds.add(listBrands[0].ESN_MB_Brand_DAM_Id__c);
                //brandVariantValue = listBrands[0].ESN_MB_Default_Brand_Variant_Value__c;
            }
            //brandVariantValue = '%' + brandVariantValue + '%';
        }

        
        List<List<Object>> assetsList = new List<List<Object>>();
        String damAssetId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        String[] searchTextArray = searchText.split(' ');
        String searchValue = '%' + searchTextArray[0] + '%';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += searchTextArray[i] + '%';
            }
        }
        
        List<ESN_MB_Asset__c> results;
        if(assetType == 'videoAsset') {
            String[] filters = new String[]{'3GP%','AVI%','FLV%','M4V%','MPEG%','MPG','WMV%','SWF%','MP4%','MOV%'};
            results = [Select Id, Name, ESN_MB_description__c, ESN_MB_originalFile_extension__c, ESN_MB_SizeMo__c, ESN_MB_prettySize__c, ESN_MB_URL_thumbnail__c, ESN_MB_URL_imagePreview__c From ESN_MB_Asset__c WHERE recordTypeId = :damAssetId AND ESN_MB_originalFile_extension__c Like :filters AND ESN_MB_Taxonomy_Brands__c IN :brandDamIds AND (Name like :searchValue OR ESN_MB_TECH_keywords__c like :searchValue OR ESN_MB_TECH_description__c like :searchValue) ORDER BY CreatedDate DESC];
        } else {
            results = [Select Id, Name, ESN_MB_description__c, ESN_MB_originalFile_extension__c, ESN_MB_SizeMo__c, ESN_MB_prettySize__c, ESN_MB_URL_thumbnail__c, ESN_MB_URL_imagePreview__c From ESN_MB_Asset__c WHERE recordTypeId = :damAssetId AND ESN_MB_Taxonomy_Brands__c IN :brandDamIds AND (Name like :searchValue OR ESN_MB_TECH_keywords__c like :searchValue OR ESN_MB_TECH_description__c like :searchValue) ORDER BY CreatedDate DESC];
        }
        assetsList.add(results);
        return assetsList;
    }
    
    /**
    * Method searchMoreAssets(String searchText, List<String> lastAssetIdList)
    * @param searchText: String param corresponding to the text typed by user
    * @param lastAssetIdList: param of type List<String> corresponding to the list of ids of the last assets selected by user
    * @param assetType: String param corresponding to the type of asset to search
    * @return assetsList: returns a list of assets
    */
    @RemoteAction
    global static List<List<Object>> searchMoreAssets(String searchText, List<String> lastAssetIdList, String assetType, String brandId) {
        List<List<Object>> rawResult = searchAssets(searchText, assetType, brandId);
        List<Object> rawList = (rawResult.size()>0)?rawResult[0]:new List<Object>();

        List<Object> refinedList = new List<Object>();
        List<List<Object>> refinedResult = new List<List<Object>>();
        refinedResult.add(refinedList);
        
        Set<String> assetIdSet = new Set<String>();
        assetIdSet.addAll(lastAssetIdList);
        
        for(Object objectTmp:rawList){
            ESN_MB_Asset__c assetTmp = (ESN_MB_Asset__c)objectTmp;
            if(!assetIdSet.contains(assetTmp.Id)){
                refinedList.add(assetTmp);
            }
        }
        
        return refinedResult;
    }

    /**
    * Method retrieveSelectedAssets(List<String> assetsIdList)
    * @param assetsIdList: List of string param corresponding to the list of ids of assets selected by user
    * @return assetsList: returns the list of the selected assets
    */
    @RemoteAction
    global static List<ESN_MB_Asset__c> retrieveSelectedAssets(List<String> assetsIdList) {
        List<ESN_MB_Asset__c> assetsList = [Select Id, Name, ESN_MB_description__c, ESN_MB_originalFile_extension__c, ESN_MB_SizeMo__c, ESN_MB_prettySize__c, 
                                            ESN_MB_URL_thumbnail__c,ESN_MB_URL_imagePreview__c, ESN_MB_URL_originalFile__c, ESN_MB_URL_bamVideoPreview__c, ESN_MB_DAMId__c, ESN_MB_Storyboard_LargeURL__c,
                                            ESN_MB_Storyboard_Slide_Count__c, ESN_MB_URL_bamArticleFull__c, ESN_MB_mimeType__c
                                            FROM ESN_MB_Asset__c
                                            WHERE Id IN :assetsIdList];
        return assetsList;
    }
    
    @RemoteAction
    global static List<ESN_MB_Asset__c> searchWebinars(String brandId) {
        String brandVariantValue = [Select ESN_MB_Default_Brand_Variant_Value__c 
                            From ESN_MB_NodePage__c 
                            Where Id = : brandId 
                            limit 1].ESN_MB_Default_Brand_Variant_Value__c;
        brandVariantValue = '%' + brandVariantValue + '%';
        String damAssetId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        
        List<ESN_MB_Asset__c> assetsList = [Select Id, Name, ESN_MB_description__c, ESN_MB_URL_thumbnail__c,ESN_MB_creationDate__c, ESN_MB_URL_bamVideoPreview__c,ESN_MB_URL_bamArticleFull__c,ESN_MB_DAMId__c
                                            FROM ESN_MB_Asset__c
                                            WHERE ESN_MB_isWebinar__c != NULL
                                            AND recordTypeId = :damAssetId
                                            AND ESN_MB_Brand_Scope_Text__c LIKE :brandVariantValue
                                            ORDER BY ESN_MB_TECH_Webinar_Order__c ASC, CreatedDate DESC];
        return assetsList;
    }
    @RemoteAction
    global static void changeWebinarOrder(List <String> listWebinarId) {
        System.debug('changeWebinarOrder listWebinarId = ' + listWebinarId);
        Map<Id, ESN_MB_Asset__c> mapAssetToReorder = new Map<Id, ESN_MB_Asset__c>(
                                                            [Select Id, ESN_MB_TECH_Webinar_Order__c
                                                                From ESN_MB_Asset__c
                                                                Where Id in :listWebinarId]);
        Integer orderTmp = 0;
        for(String idTmp:listWebinarId){
            mapAssetToReorder.get(idTmp).ESN_MB_TECH_Webinar_Order__c = orderTmp;
            orderTmp++;
        }
        
        Database.update(mapAssetToReorder.values());
    }
    
    @RemoteAction 
    global static boolean isBroadCasterAssigned(String brandId){
        return ESN_MB_UtilsUser.isBroadCasterUser(brandId);
    }
    
    public static Boolean isLeCercleBrand(String brandId) {
        Boolean ret = false;
        List<ESN_MB_NodePage__c> brandLeCercle = [select Id from ESN_MB_NodePage__c Where RecordType.DeveloperName = 'ESN_MB_Brand' AND Name =: Label.ESN_MB_LeCercle LIMIT 1];
        if (brandLeCercle.size() > 0) {
            for(ESN_MB_NodePage__c brand : brandLeCercle) {
                if(brand.Id == brandId) {
                    ret = true;         
                } else {
                    ret = false;
                }
            }
        } else {
            ret = false;
        }
        return ret;
    }
    
}