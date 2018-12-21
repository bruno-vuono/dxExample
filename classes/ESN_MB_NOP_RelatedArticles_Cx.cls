global class ESN_MB_NOP_RelatedArticles_Cx {
    /**
    * Method searchRelatedArticles(String searchText)
    * @param searchText: String param corresponding to the text typed by user
    * @param brandId: param of type String containing the id of the current brand
    * @return articlesList: returns a list of articles
    */
    @RemoteAction
    global static List<List<Object>> searchRelatedArticles(String searchText, String brandId) {
        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        String brandName = '%' + rawBrandName + '%';
        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        List<List<Object>> articlesList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                           ESN_MB_Article__c (Id, Name, ESN_MB_Abstract__c, ESN_MB_Bottom_Text__c, ESN_MB_Top_Text__c
                                                              WHERE ESN_MB_Stage__c = 'Published'
                                                              AND ESN_MB_Brand_Scope_Text__c LIKE :brandName
                                                              ORDER BY CreatedDate DESC)];
                                          
        return articlesList;
    }
    
     /**
    * Method searchMoreRelatedArticles(String searchText, List<String> lastArticleIdList)
    * @param searchText: String param corresponding to the text typed by user
    * @param lastArticleIdList: param of type List<String> corresponding to the list of ids of the last articles selected by user
    * @param brandId: param of type String containing the id of the current brand
    * @return articlesList: returns a list of articles
    */
    @RemoteAction
    global static List<List<Object>> searchMoreRelatedArticles(String searchText, List<String> lastArticleIdList, String brandId) {
        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        String brandName = '%' + rawBrandName + '%';
        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        List<List<Object>> articlesList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                           ESN_MB_Article__c (Id, Name, ESN_MB_Abstract__c, ESN_MB_Bottom_Text__c, ESN_MB_Top_Text__c 
                                                              WHERE Id NOT IN :lastArticleIdList 
                                                              AND ESN_MB_Stage__c = 'Published'
                                                              AND ESN_MB_Brand_Scope_Text__c LIKE :brandName
                                                              ORDER BY CreatedDate DESC)];
                                          
        return articlesList;
    }
    
    /**
    * Method retrieveSelectedArticles(List<String> articleIdList)
    * @param articleId: List of string param corresponding to the list of ids of articles selected by user
    * @return articlesList: returns the list of the articles
    */
    @RemoteAction
    global static List<ESN_MB_NOP_Related_Article_DTO> retrieveSelectedArticles(List<String> articleIdList) {
        List<ESN_MB_Entry__c> articlesList = [Select ESN_MB_Article__c, 
                                              ESN_MB_Article__r.Name, ESN_MB_Asset__r.ESN_MB_Url_Thumbnail__c, ESN_MB_Article__r.ESN_MB_Abstract__c,
                                              ESN_MB_Article__r.LastModifiedDate, ESN_MB_Article__r.LastModifiedById, ESN_MB_Asset__r.ESN_MB_DocumentId__c
                                              From ESN_MB_Entry__c 
                                              Where ESN_MB_RoleAsset__c = 'MainAsset' 
                                              And ESN_MB_Article__c in :articleIdList
                                              Order by CreatedDate Desc];
        
        List <ESN_MB_Entry__c> articleToRubricList = [Select ESN_MB_Article__c, ESN_MB_Rubric__r.Name, ESN_MB_Rubric__r.ESN_MB_Section__c 
                                                      From ESN_MB_Entry__c 
                                                      Where ESN_MB_Article__c in :articleIdList
                                                      And recordType.DeveloperName = 'ESN_MB_Articles_To_Rubrics'];
        
        List<ESN_MB_NOP_Related_Article_DTO> linkedArticlesList = new List<ESN_MB_NOP_Related_Article_DTO>();
        
        for(ESN_MB_Entry__c article : articlesList) {
            for(ESN_MB_Entry__c articleToRubric : articleToRubricList) {
                if(article.ESN_MB_Article__c == articleToRubric.ESN_MB_Article__c) {
                    ESN_MB_NOP_Related_Article_DTO relatedArticle = new ESN_MB_NOP_Related_Article_DTO();
                    String lastModifiedById = article.ESN_MB_Article__r.LastModifiedById;
                    String lastModifiedByName = [Select Name
                                                 From User
                                                 Where id = :lastModifiedById].Name;
                    relatedArticle.articleId = article.ESN_MB_Article__c;
                    relatedArticle.articleName = article.ESN_MB_Article__r.Name;
                    relatedArticle.articleAbstract = article.ESN_MB_Article__r.ESN_MB_Abstract__c;
                    relatedArticle.articleLastModifiedBy = lastModifiedByName;
                    relatedArticle.articleLastModifiedDate = article.ESN_MB_Article__r.LastModifiedDate;
                    relatedArticle.mainAssetThumbnail = article.ESN_MB_Asset__r.ESN_MB_Url_Thumbnail__c;
                    relatedArticle.section = articleToRubric.ESN_MB_Rubric__r.ESN_MB_Section__c;
                    relatedArticle.rubric = articleToRubric.ESN_MB_Rubric__r.Name;
                    relatedArticle.mainAssetDocumentId = article.ESN_MB_Asset__r.ESN_MB_DocumentId__c;
                    linkedArticlesList.add(relatedArticle);
                }
            }
        }
        return linkedArticlesList;
    }
    
    //Creates an entry to link two Articles that are related
    @RemoteAction
    global static String createEntryRelatedArticle(String sourceArticleId, String targetArticleId) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Article__c = sourceArticleId;
        entry.ESN_MB_Article_See_Also__c = targetArticleId;
        entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Articles');
        insert(entry);
        return entry.Id;
    }

    
   /**
    * Method searchBrandActivations(String searchText)
    * @param searchText: String param corresponding to the text typed by user
    * @param brandId: param of type String containing the id of the current brand
    * @return activationsList: returns a list of activations
    */
    @RemoteAction
    global static List<List<Object>> searchBrandActivations(String searchText, String brandId) {
        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        String brandName = '%' + rawBrandName + '%';
        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        String brandActivationRtId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        List<List<Object>> activationsList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                              ESN_MB_Activation__c (Id, Name, ESN_MB_Product__r.Name
                                                                    WHERE recordTypeId = :brandActivationRtId 
                                                                    AND ESN_MB_Stage__c = 'Published'
                                                                    AND ESN_MB_Brand_Scope_Text__c LIKE :brandName
                                                                    ORDER BY CreatedDate DESC)];
                                          
        return activationsList;
    }
    
     /**
    * Method searchMoreBrandActivations(String searchText, List<String> lastActivationIdList)
    * @param searchText: String param corresponding to the text typed by user
    * @param lastActivationIdList: param of type List<String> corresponding to the list of ids of the last activations selected by user
    * @param brandId: param of type String containing the id of the current brand
    * @return activationsList: returns a list of activations
    */
    @RemoteAction
    global static List<List<Object>> searchMoreBrandActivations(String searchText, List<String> lastActivationIdList, String brandId) {
        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        String brandName = '%' + rawBrandName + '%';
        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        String brandActivationRtId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand_Activation');
        List<List<Object>> activationsList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                               ESN_MB_Activation__c (Id, Name, ESN_MB_Product__r.Name
                                                                     WHERE Id NOT IN :lastActivationIdList 
                                                                     AND recordTypeId = :brandActivationRtId
                                                                     AND ESN_MB_Stage__c = 'Published'
                                                                     AND ESN_MB_Brand_Scope_Text__c LIKE :brandName
                                                                     ORDER BY CreatedDate DESC)];
                                              
        return activationsList;
    }
    
    /**
    * Method retrieveSelectedActivations(List<String> activationIdsList)
    * @param activationIdsList: List of string param corresponding to the list of ids of activations selected by user
    * @return linkedActivationList: returns the list of the activations
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveSelectedActivations(List<String> activationIdsList) {
        List<ESN_MB_Entry__c> linkedActivationList = [Select ESN_MB_Activation__c, 
                                                      ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Product__r.Name, 
                                                      ESN_MB_Asset__r.ESN_MB_Url_Thumbnail__c, ESN_MB_Asset__r.ESN_MB_DocumentId__c
                                                      From ESN_MB_Entry__c 
                                                      Where ESN_MB_RoleAsset__c = 'MainAsset' 
                                                      And ESN_MB_Activation__c in :activationIdsList
                                                      Order by CreatedDate Desc];
        return linkedActivationList;
    }
    
    /**
    * Method setParentActivation(String marketActivationId, String brandActivationId)
    * @param marketActivationId: id of the market activation to edit
    * @param brandActivationId: id of the brand activation to set as the toolkit
    */
    @RemoteAction
    global static void setParentActivation(String marketActivationId, String brandActivationId) {
        ESN_MB_Activation__c currentActivation = [Select Id, ESN_MB_Parent_Activation__c 
                                                  From ESN_MB_Activation__c 
                                                  Where Id = :marketActivationId];
        currentActivation.ESN_MB_Parent_Activation__c = brandActivationId;
        update currentActivation;
    }
    
    /**
    * Method searchKeyContact(String searchText)
    * @param searchText: String param corresponding to the text typed by user
    * @return keyContactList: returns a list of activations
    */
    @RemoteAction
    global static List<List<Object>> searchKeyContact(String searchText) {
        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        List<List<Object>> keyContactList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                             User (Id, Name)];
                                          
        return keyContactList;
    }
    
     /**
    * Method searchMoreKeyContact(String searchText, List<String> lastKeyContactIdsList)
    * @param searchText: String param corresponding to the text typed by user
    * @param lastKeyContactIdsList: param of type List<String> corresponding to the list of ids of the last key contacts selected by user
    * @return keyContactList: returns a list of activations
    */
    @RemoteAction
    global static List<List<Object>> searchMoreKeyContact(String searchText, List<String> lastKeyContactIdsList) {
        String[] searchTextArray = searchText.split(' ');
        String searchValue = searchTextArray[0] + '*';
        integer arrayLength = searchTextArray.size();
        if(arrayLength  > 1) {
            for(integer i = 1; i < arrayLength; i++) {
                searchValue += ' and ' + searchTextArray[i] + '*';
            }
        }
        List<List<Object>> keyContactList = [FIND :searchValue IN ALL FIELDS RETURNING 
                                             User (Id, Name
                                                   WHERE Id NOT IN :lastKeyContactIdsList)];
                                              
        return keyContactList;
    }
    
    /**
    * Method retrieveSelectedKeyContact(List<String> keyContactIdsList)
    * @param keyContactIdsList: List of string param corresponding to the list of ids of key Contacts selected by user
    * @return keyContactList: returns the list of the key contacts (users)
    */
    @RemoteAction
    global static List<User> retrieveSelectedKeyContact(List<String> keyContactIdsList) {
        List<User> keyContactList = [Select Id, 
                                     Name, Title, SmallPhotoUrl
                                     From User
                                     Where Id in :keyContactIdsList];
        return keyContactList;
    }
    
    /**
    * Method updateOwner(String OwnerId, String activationId)
    * @param OwnerId: It's the new Owner ID
    * @param activationId: It's the activation ID
    */
    @RemoteAction
    global static void updateOwner(String OwnerId, String activationId, Boolean isActivation) {
        if(isActivation) {
            ESN_MB_Activation__c retrieveOwner = [Select Id, Name, OwnerId From ESN_MB_Activation__c Where Id = :activationId];
            retrieveOwner.OwnerId  = OwnerId;
            update retrieveOwner; 
        } else {
            ESN_MB_Article__c retrieveOwner= [Select Id, Name, OwnerId From ESN_MB_Article__c Where Id = :activationId];
            retrieveOwner.OwnerId  = OwnerId;
            update retrieveOwner; 
        }

    }
    
    /**
    * Method createEntryActivationKeyContact(String activationId, String keyContactId)
    * @param activationId: String param containing the activation id
    * @param keyContactId: String param containing the key contact id
    * @return entry.Id: returns the id of the created entry
    */
    @RemoteAction
    global static String createEntryActivationKeyContact(String activationId, String keyContactId) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();entry.ESN_MB_Activation__c = activationId;
        entry.ESN_MB_KeyContact__c = keyContactId;entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_KeyContacts');insert(entry);return entry.Id;
    }
}