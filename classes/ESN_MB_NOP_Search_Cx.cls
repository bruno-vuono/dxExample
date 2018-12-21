global class ESN_MB_NOP_Search_Cx {
    /**
    * Method searchMyBrands()
    * @param searchText: String param corresponding to the text typed by user
    * @return searchList: returns a list containing lists of results for each object
    */
    @RemoteAction
    global static List<List<SObject>> searchMyBrands(String searchText, String brandId) {
//        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        ESN_MB_NodePage__c brandPage = [Select Name, ESN_MB_ChatterGroup_Id__c, ESN_MB_Brand_Category__c from ESN_MB_NodePage__c Where id = :brandId];

        //String rawBrandName = brandPage.Name;
        //String brandName = '%' + rawBrandName + '%';
        String brandName = brandPage.Name;
        String brandCategory = brandPage.ESN_MB_Brand_Category__c;
        
        String brandVariantValue = [Select ESN_MB_Default_Brand_Variant_Value__c 
                            From ESN_MB_NodePage__c 
                            Where Id = : brandId 
                            limit 1].ESN_MB_Default_Brand_Variant_Value__c;
        brandVariantValue = '%' + brandVariantValue + '%';
        

        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        
        String chatterGroupId = brandPage.ESN_MB_ChatterGroup_Id__c;
        
        system.debug('--------------------------- ' + searchValue + ' -------------------------------');
        List<List<SObject>> searchList;
        if (brandCategory == Label.ESN_MB_LeCercle) {
            searchList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                          ESN_MB_Article__c (Id, Name, ESN_MB_Abstract__c, ESN_MB_Bottom_Text__c, ESN_MB_Top_Text__c WHERE ESN_MB_Stage__c = 'Published' AND ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC), 
                                          ESN_MB_Asset__c (Id, Name, ESN_MB_Description__c, ESN_MB_fileName__c, ESN_MB_isWebinar__c, ESN_MB_originalFile_extension__c, ESN_MB_DAMId__c WHERE ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC),
                                          ESN_MB_Activation__c (Id, Name, CreatedDate, ESN_MB_Market__c WHERE ESN_MB_Stage__c = 'Published' AND ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC),
                                          FeedItem (Id, Body, Type, linkUrl, title, CreatedById, CreatedBy.Name, CreatedBy.Profile.CreatedBy.SmallPhotoUrl where parentId = :chatterGroupId ORDER BY CreatedDate DESC),
                                          FeedComment(Id, CommentBody, CommentType, CreatedBy.Name, FeedItemId, InsertedById, ParentId where parentId = :chatterGroupId ORDER BY CreatedDate DESC)];
        } else {
            searchList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                          ESN_MB_Article__c (Id, Name, ESN_MB_Abstract__c, ESN_MB_Bottom_Text__c, ESN_MB_Top_Text__c WHERE ESN_MB_Stage__c = 'Published' AND ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC), 
                                          ESN_MB_Asset__c (Id, Name, ESN_MB_Description__c, ESN_MB_fileName__c, ESN_MB_isWebinar__c, ESN_MB_originalFile_extension__c, ESN_MB_DAMId__c WHERE ESN_MB_Brand_Scope_Text__c LIKE :brandVariantValue ORDER BY CreatedDate DESC),
                                          ESN_MB_Activation__c (Id, Name, CreatedDate, ESN_MB_Market__c WHERE ESN_MB_Stage__c = 'Published' AND ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC),
                                          FeedItem (Id, Body, Type, linkUrl, title, CreatedById, CreatedBy.Name, CreatedBy.Profile.CreatedBy.SmallPhotoUrl where parentId = :chatterGroupId ORDER BY CreatedDate DESC),
                                          FeedComment(Id, CommentBody, CommentType, CreatedBy.Name, FeedItemId, InsertedById, ParentId where parentId = :chatterGroupId ORDER BY CreatedDate DESC)];            
        }
        return searchList;
    }

/**
    * Method searchMyBrandsLeCercle()
    * @param searchText: String param corresponding to the text typed by user
    * @return searchList: returns a list containing lists of results for each object
    */
    @RemoteAction
    global static List<List<SObject>> searchMyBrandsLeCercle(String searchText, String brandId) {
//        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        ESN_MB_NodePage__c brandPage = [Select Name, ESN_MB_ChatterGroup_Id__c from ESN_MB_NodePage__c Where id = :brandId];

        String rawBrandName = brandPage.Name;
        String brandName = '%' + rawBrandName + '%';

        String brandVariantValue = [Select ESN_MB_Default_Brand_Variant_Value__c 
                            From ESN_MB_NodePage__c 
                            Where Id = : brandId 
                            limit 1].ESN_MB_Default_Brand_Variant_Value__c;
        brandVariantValue = '%' + brandVariantValue + '%';
        

        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        
        String chatterGroupId = brandPage.ESN_MB_ChatterGroup_Id__c;
        
        system.debug('--------------------------- ' + searchValue + ' -------------------------------');
        List<List<SObject>> searchList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                          ESN_MB_Article__c (Id, Name, ESN_MB_Abstract__c, ESN_MB_Bottom_Text__c, ESN_MB_Top_Text__c WHERE ESN_MB_Stage__c = 'Published' AND ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC), 
                                          ESN_MB_Asset__c (Id, Name, ESN_MB_Description__c, ESN_MB_fileName__c, ESN_MB_isWebinar__c, ESN_MB_originalFile_extension__c, ESN_MB_DAMId__c WHERE ESN_MB_Brand_Scope_Text__c LIKE :brandVariantValue ORDER BY CreatedDate DESC),
                                          ESN_MB_Activation__c (Id, Name, CreatedDate, ESN_MB_Market__c WHERE ESN_MB_Stage__c = 'Published' AND ESN_MB_LeCercle__c = true AND ESN_MB_Brand_Scope_Text__c LIKE :brandName ORDER BY CreatedDate DESC),
                                          FeedItem (Id, Body, Type, linkUrl, title, CreatedById, CreatedBy.Name, CreatedBy.Profile.CreatedBy.SmallPhotoUrl where parentId = :chatterGroupId ORDER BY CreatedDate DESC),
                                          FeedComment(Id, CommentBody, CommentType, CreatedBy.Name, FeedItemId, InsertedById, ParentId where parentId = :chatterGroupId ORDER BY CreatedDate DESC)];            
        return searchList;
    }

    @RemoteAction
    global static List<List<ESN_MB_NOP_Search_DTO>> search(String searchText, String currentBrandId) {
        String brandId = '';
        List<ESN_MB_NodePage__c> brandInfo = [SELECT Id, Name, ESN_MB_Brand_Category__c, ESN_MB_BrandParentId__c FROM ESN_MB_NodePage__c WHERE RecordType.DeveloperName = 'ESN_MB_Brand' AND Id=:currentBrandId LIMIT 1];
        for(ESN_MB_NodePage__c brand : brandInfo) {
            if(brand.ESN_MB_Brand_Category__c == Label.ESN_MB_LeCercle && brand.Name != Label.ESN_MB_LeCercle && brand.ESN_MB_BrandParentId__c != null) {
                brandId = brand.ESN_MB_BrandParentId__c;
            } else {
                brandId = '';
            }
        }
        
        List<List<ESN_MB_NOP_Search_DTO>> resultList = new List<List<ESN_MB_NOP_Search_DTO>>();

        List<List<sObject>> searchList = searchMyBrands(searchText, currentBrandId);

        List<ESN_MB_NOP_Search_DTO> articleDtoList = new List<ESN_MB_NOP_Search_DTO>();

        List<ESN_MB_Article__c> articleList = searchList.get(0);
        for (ESN_MB_Article__c article : articleList) {
            ESN_MB_NOP_Search_DTO searchDto = new ESN_MB_NOP_Search_DTO();
            searchDto.searchType = 'Article';
            searchDto.article = article;
            articleDtoList.add(searchDto);
        }
        resultList.add(articleDtoList);

        List<ESN_MB_NOP_Search_DTO> assetDtoList = new List<ESN_MB_NOP_Search_DTO>();
        List<ESN_MB_NOP_Search_DTO> feedItemAndWebinarsDtoList = new List<ESN_MB_NOP_Search_DTO>();

        List<ESN_MB_Asset__c> assetList = searchList.get(1);
        for (ESN_MB_Asset__c asset : assetList) {
            ESN_MB_NOP_Search_DTO searchDto = new ESN_MB_NOP_Search_DTO();
            searchDto.searchType = 'Asset';
            searchDto.asset = asset;
            if ('Webinar'.equals(asset.ESN_MB_isWebinar__c)) {
                feedItemAndWebinarsDtoList.add(searchDto);
            } else {
                assetDtoList.add(searchDto);
            }
        }
        resultList.add(assetDtoList);

        List<ESN_MB_NOP_Search_DTO> activationDtoList = new List<ESN_MB_NOP_Search_DTO>();
        if (brandId != '') {
            List<List<sObject>> searchListLeCercle = searchMyBrandsLeCercle(searchText, brandId);
            List<ESN_MB_Activation__c> activationList = searchListLeCercle.get(2);
            for (ESN_MB_Activation__c activation : activationList) {
                ESN_MB_NOP_Search_DTO searchDto = new ESN_MB_NOP_Search_DTO();
                searchDto.searchType = 'Activation';
                searchDto.activation = activation;
                activationDtoList.add(searchDto);
            }
            resultList.add(activationDtoList);
        } else {
            List<ESN_MB_Activation__c> activationList = searchList.get(2);
            for (ESN_MB_Activation__c activation : activationList) {
                ESN_MB_NOP_Search_DTO searchDto = new ESN_MB_NOP_Search_DTO();
                searchDto.searchType = 'Activation';
                searchDto.activation = activation;
                activationDtoList.add(searchDto);
            }
            resultList.add(activationDtoList);  
        }

        Map<Id, User> userList = new Map<Id, User>([select Id, SmallPhotoUrl from User where SmallPhotoUrl != null]);

        List<FeedItem> feedItemList = searchList.get(3);
        for (FeedItem feedItem : feedItemList) {
            ESN_MB_NOP_Search_DTO searchDto = new ESN_MB_NOP_Search_DTO();
            searchDto.searchType = 'FeedItem';
            searchDto.feedItem = feedItem;

            String createdBySmallPhoto = userList.get(feedItem.CreatedById).SmallPhotoUrl;
            System.debug('createdBySmallPhoto :' + createdBySmallPhoto);
            searchDto.createdBySmallPhotoUrl = createdBySmallPhoto;
            feedItemAndWebinarsDtoList.add(searchDto);
        }
        resultList.add(feedItemAndWebinarsDtoList);

        List<ESN_MB_NOP_Search_DTO> feedCommentDtoList = new List<ESN_MB_NOP_Search_DTO>();
        List<FeedComment> feedCommentList = searchList.get(4);
        for (FeedComment feedComment : feedCommentList) {
            ESN_MB_NOP_Search_DTO searchDto = new ESN_MB_NOP_Search_DTO();
            searchDto.searchType = 'FeedComment';
            searchDto.feedComment = feedComment;

            String createdBySmallPhoto = userList.get(feedComment.CreatedById).SmallPhotoUrl;
            System.debug('createdBySmallPhoto :' + createdBySmallPhoto);
            searchDto.createdBySmallPhotoUrl = createdBySmallPhoto;
            feedCommentDtoList.add(searchDto);
        }
        resultList.add(feedCommentDtoList);

        return resultList;
    }
    
}