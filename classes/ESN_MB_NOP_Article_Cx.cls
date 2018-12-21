/**
    About
    -----
    Description: Controler Class for MyBrands Application project.
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains methods for controlling MyBrands Activations
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------
    Use custom labels for the strings used everywhere.
*/

global class ESN_MB_NOP_Article_Cx {
    
    /*
     * Creates a ESN_MB_NOP_Article_DTO based on the informations contained in the parameters 
     * - article : contains basic informations (id, title, abstract, texts)
     * - list of Entries : contains Entries (for assets) linked to this article (can contain other entries, only the ones attached to the article are added to the DTO)
     * The entries must contain the following fields of asset : Name, ESN_MB_URL_imagePreview__c, ESN_MB_description__c, ESN_MB_mimeType__c, ESN_MB_Size__c
     */
    public static ESN_MB_NOP_Article_DTO prepareDTOFromArticle(ESN_MB_Article__c article, List<ESN_MB_Entry__c> entryList){
        System.debug('INPUT article = ' + article);
        System.debug('INPUT entryList = ' + entryList);
        
        ESN_MB_NOP_Article_DTO articleDTO = new ESN_MB_NOP_Article_DTO();
        articleDTO.articleId = article.Id;
        articleDTO.titleText=article.Name;
        articleDTO.abstractText=article.ESN_MB_Abstract__c;
        articleDTO.topText=article.ESN_MB_Top_Text__c;
        articleDTO.bottomText=article.ESN_MB_Bottom_Text__c;
        articleDTO.embeddedVideo = article.ESN_MB_Embedded_Video__c;
        articleDTO.linkRelatedAssets = article.ESN_MB_LinkRelatedAssets__c;
        articleDTO.stage=article.ESN_MB_Stage__c;
        articleDTO.creatorId=article.CreatedById;
        articleDTO.ownerId=article.OwnerId;
        articleDTO.createdDate=article.CreatedDate;
        articleDTO.lastModifiedDate=article.LastModifiedDate;
        articleDTO.alsoInMasterbrand=article.ESN_MB_AlsoInMasterbrand__c;
        articleDTO.applyToAllProducts=article.ESN_MB_Apply_To_All_Products__c;
        articleDTO.flagSplashScreen=article.ESN_MB_FlagSplashScreen__c;
        List<ESN_MB_Asset__c> listAssetTmp = new List<ESN_MB_Asset__c>();
        List<String> listIdProductTmp = new List<String>();
        System.debug('Before List of entries articleDTO = ' + articleDTO);

        for(ESN_MB_Entry__c entryTmp:entryList){
            if(entryTmp.ESN_MB_Article__c == article.Id){
                //If this entry is a link between this article and a product
                if(entryTmp.RecordType.DeveloperName == 'Articles_To_Products'){
                    listIdProductTmp.add(entryTmp.ESN_MB_Node_Page__r.Id);
                } else { //Otherwise it's a link with an asset
                    System.debug('MATCH FOUND ' + entryTmp.ESN_MB_Asset__r.Name);
                    ESN_MB_Asset__c assetTmp = new ESN_MB_Asset__c();
                    assetTmp.Name = entryTmp.ESN_MB_Asset__r.Name;
                    assetTmp.ESN_MB_URL_imagePreview__c = entryTmp.ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c;
                    assetTmp.ESN_MB_description__c = entryTmp.ESN_MB_Asset__r.ESN_MB_description__c;
                    assetTmp.ESN_MB_mimeType__c = entryTmp.ESN_MB_Asset__r.ESN_MB_mimeType__c;
                    assetTmp.ESN_MB_Size__c = entryTmp.ESN_MB_Asset__r.ESN_MB_Size__c;
                    
                    listAssetTmp.add(assetTmp);
                    System.debug('assetTmp=' + assetTmp);
                    System.debug('listAssetTmp=' + listAssetTmp);
                }
            }
        }
        articleDTO.listIdProduct = listIdProductTmp;
        articleDTO.listAsset = listAssetTmp;
        System.debug('Output articleDTO = ' + articleDTO);
        return articleDTO;
    }
    
   /**
    * Method retrieveSelectedArticle(String articleId) 
    * @param articleId: param of type String, id of the article to retrieve
    * @return article
    */
    private static ESN_MB_Article__c retrieveArticle(String articleId) {

        ESN_MB_Entry__c articleEntry = [Select ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Embedded_Video__c,ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c, ESN_MB_Article__r.ESN_MB_Abstract__c, ESN_MB_Article__r.ESN_MB_Top_Text__c, ESN_MB_Article__r.ESN_MB_Stage__c,
                                        ESN_MB_Article__r.ESN_MB_Bottom_Text__c, ESN_MB_Article__r.ESN_MB_Node_Page__c, ESN_MB_Rubric__r.Name, ESN_MB_Article__r.ESN_MB_ParentArticle__c, ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c,
                                        ESN_MB_Article__r.CreatedById,ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.CreatedDate, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c, ESN_MB_Article__r.LastModifiedDate, ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c
                                        from ESN_MB_Entry__c where ESN_MB_Article__c = :articleId limit 1];


        return articleEntry.ESN_MB_Article__r;
    }
    
    /*
     * Clones an article in parameter. If the article already is a Draft, then it is not cloned, it is simply returned.
     * Also clones Entries (to link the article to the rubric and fetch the assets
     */
    @RemoteAction
    global static ESN_MB_NOP_Article_DTO cloneArticleStageDraft(String articleId){
        System.debug('articleId = ' + articleId);
        ESN_MB_Article__c articleToClone = retrieveArticle(articleId);
        System.debug('articleToClone = ' + articleToClone);
        if(articleToClone.ESN_MB_Stage__c == 'Draft'){
            List<ESN_MB_Entry__c> listEntries = [Select ESN_MB_Article__c, ESN_MB_Article__r.Id, ESN_MB_Asset__c, ESN_MB_Asset__r.Name, 
                                                    ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_description__c,
                                                    ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_Size__c,
                                                    ESN_MB_Article__r.CreatedById, ESN_MB_Article__r.OwnerId,ESN_MB_Article__r.CreatedDate,
                                                    ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c, ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c,
                                                    ESN_MB_Node_Page__r.Id, RecordType.DeveloperName, ESN_MB_Article__r.LastModifiedDate
                                                    From ESN_MB_Entry__c
                                                    Where ESN_MB_Article__r.Id = :articleId
                                                    And (ESN_MB_Asset__c<>null
                                                         Or recordType.DeveloperName='Articles_To_Products')];
            return prepareDTOFromArticle(articleToClone, listEntries);
        } else {
            ESN_MB_Article__c articleClone = articleToClone.clone(false, true);
            System.debug('articleClone before refining = ' + articleClone);
            
            articleClone.ESN_MB_Stage__c = 'Draft';
            if(articleToClone.ESN_MB_ParentArticle__c == null || articleToClone.ESN_MB_Stage__c == 'Published'){
                articleClone.ESN_MB_ParentArticle__c = articleId;
            }
            Database.SaveResult result = Database.insert(articleClone);
            
            List<ESN_MB_Entry__c> listEntryToClone = [Select id, ESN_MB_RoleAsset__c, ESN_MB_Activation__c, ESN_MB_Article__c,  ESN_MB_Article_See_Also__c, ESN_MB_Asset__c, ESN_MB_Node_Page__c, ESN_MB_Resource__c, ESN_MB_Rubric__c from ESN_MB_Entry__c
                Where ESN_MB_Article__r.id=:articleId];
            
            List<ESN_MB_Entry__c> listEntryClone = new List<ESN_MB_Entry__c>();
            for(ESN_MB_Entry__c entryToCloneTmp:listEntryToClone){
                ESN_MB_Entry__c cloneEntry = entryToCloneTmp.clone(false, true);
                System.debug('==========>entryToCloneTmp=' + entryToCloneTmp);
                System.debug('==========>cloneEntry=' + cloneEntry);
                
                cloneEntry.ESN_MB_Article__c = result.getId();
                listEntryClone.add(cloneEntry);
            }
            System.debug('listEntryClone=' + listEntryClone);
            List<Database.SaveResult> listResult = Database.insert(listEntryClone);
            
            List<ESN_MB_Entry__c> listEntries = [Select ESN_MB_Article__c, ESN_MB_Article__r.Id, ESN_MB_Asset__c, ESN_MB_Asset__r.Name,
                                                    ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_description__c,
                                                    ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_Size__c,
                                                    ESN_MB_Article__r.CreatedById,ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.CreatedDate,
                                                    ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c, ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c,
                                                    ESN_MB_Node_Page__r.Id, RecordType.DeveloperName, ESN_MB_Article__r.LastModifiedDate 
                                                    From ESN_MB_Entry__c
                                                    Where ESN_MB_Article__r.Id = :result.getId()
                                                    And (ESN_MB_Asset__c<>null
                                                         Or recordType.DeveloperName='Articles_To_Products')];
            return prepareDTOFromArticle(articleClone, listEntries);
        }
    }
        
    /**
    * Method createArticle(String currentItemId, String articleAbstract, String articleTopText, String articleBotText, String nodePageId, String rubricId, String brandId) 
    * @param currentItemId: param of type String, name of the article to insert on create button
    * @param articleAbstract: param of type String, abstract description of the insert to update on create button
    * @param articleTopText: param of type String, top text description of the insert to update on create button
    * @param articleBotText: param of type String, bottom text description of the insert to update on create button
    * @param nodePageId: param of type String, id of the nodePage on which the article references
    * @paranm rubricIds: param of type String, ids of the rubrics on which the article references
    */
    @RemoteAction
    global static ESN_MB_NOP_Article_DTO createArticle(String currentItemId, String articleAbstract, String articleTopText, String articleBotText, String nodePageId,
                                                       list<String> rubricIds, String rubricId, String brandId) {
        ESN_MB_Article__c article = new ESN_MB_Article__c();



        String newsCoverId = ESN_MB_Utils.cs_NewsCoverRubricId();
        article.Name = currentItemId;
        article.ESN_MB_Abstract__c = articleAbstract;
        article.ESN_MB_Top_Text__c = articleTopText;
        article.ESN_MB_Bottom_Text__c = articleBotText;
        article.ESN_MB_Node_Page__c = nodePageId;
        article.ESN_MB_Stage__c = 'Draft';
        
        // Check all the rubrics to know if one is news cover
        article.ESN_MB_Node_Page__c = brandId;
        if(rubricId == newsCoverId) {
            article.ESN_MB_Apply_To_All_Products__c = True;
        }
        
        Database.SaveResult articleResult = Database.insert(article);
        System.debug('articleResult = ' + articleResult);
        // Once the article has been inserted, insert all the entries depending on rubrics number
        List<ESN_MB_Entry__c> listEntryToInsert = new List<ESN_MB_Entry__c>();
        for(String s : rubricIds) {
            ESN_MB_Entry__c articleEntry = new ESN_MB_Entry__c();
            articleEntry.ESN_MB_Article__c = article.Id;
            articleEntry.ESN_MB_Rubric__c = s;

            listEntryToInsert.add(articleEntry);
        }

        List<Database.SaveResult> listResult = Database.insert(listEntryToInsert);
        
        //Finally we insert the Entry attaching the article to the right rubric
        ESN_MB_Entry__c rubricEntry = new ESN_MB_Entry__c();
        String articlesToRubricsRT = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Rubrics');
        rubricEntry.ESN_MB_Rubric__c = rubricId ;
        rubricEntry.ESN_MB_Article__c = article.Id;
        rubricEntry.recordTypeId = articlesToRubricsRT;
                                                           
        Database.SaveResult rubricResult = Database.insert(rubricEntry);                                   
        
        return prepareDTOFromArticle(article, listEntryToInsert);
    }
    
    /**
     * Updates the article in parameter, changes its stage to Published
     * If the article has a parent article (that means that it's a Draft), then the parent article's stage is changed to Archived
     */
    @RemoteAction
    global static void publishArticle(String articleId, String currentItemId, String articleAbstract, String articleTopText, String articleBotText, String embeddedVideo, List<String> listIdProduct, String articleLinkRelatedAssets, Boolean flagSplashScreen) {
        ESN_MB_Article__c article = [Select Id, ESN_MB_ParentArticle__c from ESN_MB_Article__c Where id = :articleId];
		if(article.ESN_MB_ParentArticle__c != null){
			System.debug('MDL1');
			article.ESN_MB_Stage__c = 'Archived';
			Database.update(article);

			ESN_MB_Article__c parentArticle = [Select Id from ESN_MB_Article__c Where id = :article.ESN_MB_ParentArticle__c];
			parentArticle.ESN_MB_Stage__c = 'Published';
			upsertArticle(parentArticle, currentItemId, articleAbstract, articleTopText, articleBotText, embeddedVideo, listIdProduct, articleLinkRelatedAssets, flagSplashScreen);
		} else {
			System.debug('MDL');
			article.ESN_MB_Stage__c = 'Published';
			upsertArticle(article, currentItemId, articleAbstract, articleTopText, articleBotText, embeddedVideo, listIdProduct, articleLinkRelatedAssets, flagSplashScreen);
		}

		//ESN_MB_Article__c article = [Select Id, ESN_MB_ParentArticle__c from ESN_MB_Article__c Where id = :articleId];
        //article.ESN_MB_Stage__c = 'Published';
        //upsertArticle(article, currentItemId, articleAbstract, articleTopText, articleBotText, embeddedVideo, listIdProduct, articleLinkRelatedAssets, flagSplashScreen);
        
        //if(article.ESN_MB_ParentArticle__c != null){
            //ESN_MB_Article__c parentArticle = [Select Id from ESN_MB_Article__c Where id = :article.ESN_MB_ParentArticle__c];
            //parentArticle.ESN_MB_Stage__c = 'Archived';
            //Database.update(parentArticle);
        //}
    }

   /**
    * Method updateArticle(String articleId, String currentItemId, String articleAbstract, String articleTopText, String articleBotText) 
    * @param articleId: param of type String, id of the article to update on save button
    * @param currentItemId: param of type String, name of the article to update on save button
    * @param articleAbstract: param of type String, abstract description of the article to update on save button
    * @param articleTopText: param of type String, top text description of the article to update on save button
    * @param articleBotText: param of type String, bottom text description of the article to update on save button
    * @param embeddedVideo: param of type String, embedded video code of the article to update on save button
    */
    @RemoteAction
    global static void updateArticle(String articleId, String currentItemId, String articleAbstract, String articleTopText, String articleBotText, String embeddedVideo, List<String> listIdProduct, String articleLinkRelatedAssets, Boolean flagSplashScreen) {
        ESN_MB_Article__c article = [Select Id from ESN_MB_Article__c Where id = :articleId];
        System.debug('Retrieved Article : ' + article);
        upsertArticle(article, currentItemId, articleAbstract, articleTopText, articleBotText, embeddedVideo, listIdProduct, articleLinkRelatedAssets, flagSplashScreen);
    }
    /**
     * Makes a simple upsert operation for the article in parameter
     */
    private static void upsertArticle(ESN_MB_Article__c article, String currentItemId, String articleAbstract, String articleTopText, String articleBotText, String embeddedVideo, List<String> listIdProduct, String articleLinkRelatedAssets, Boolean flagSplashScreen) {
        article.Name = currentItemId;
        article.ESN_MB_Abstract__c = articleAbstract;
        article.ESN_MB_Top_Text__c = articleTopText;
        article.ESN_MB_Bottom_Text__c = articleBotText;
        article.ESN_MB_Embedded_Video__c = embeddedVideo;
        article.ESN_MB_LinkRelatedAssets__c = articleLinkRelatedAssets; 
        article.ESN_MB_FlagSplashScreen__c = flagSplashScreen;
        System.debug('Article before Upsert : ' + article);
        
        Database.UpsertResult articleResult = Database.upsert(article);
        System.debug('Upsert result : ' + articleResult);
        
                
        //Let's re-create entries this article and the products it is related to
        //We remove all links, and insert new ones
        String articleId = articleResult.getId();
        List<ESN_MB_Entry__c> listEntryToDelete = [Select id 
                                                    From ESN_MB_Entry__c
                                                    Where RecordType.developerName = 'Articles_To_Products'
                                                    And ESN_MB_Article__c = :articleId];
        
        List<Database.DeleteResult> listDeleteResult = Database.delete(listEntryToDelete);
        System.debug('Entries deleted : ' + listDeleteResult);

        String recordTypeId = [Select Id From RecordType Where DeveloperName='Articles_To_Products' and SobjectType='ESN_MB_Entry__c' limit 1].Id;
        
        List<ESN_MB_Entry__c> listEntryToInsert = new List<ESN_MB_Entry__c>();
        for(String idProductTmp:listIdProduct){
            ESN_MB_Entry__c entryTmp = new ESN_MB_Entry__c();
            entryTmp.ESN_MB_Article__c = articleId;
            entryTmp.ESN_MB_Node_Page__c = idProductTmp;
            entryTmp.RecordTypeId = recordTypeId;
            listEntryToInsert.add(entryTmp);
        }
        
        List<Database.SaveResult> listInsertResult = Database.insert(listEntryToInsert);
        System.debug('Entries inserted : ' + listDeleteResult);
    }
    
    
   
   /**
    * Method retrieveArticleNodePageList()
    * @return articleNodePageList: returns the list of ids and names of the nodepages available when creating an article
    */ 
    @RemoteAction
    global static List<ESN_MB_NodePage__c> retrieveArticleNodePageList() {
        List<ESN_MB_NodePage__c> articleNodePageList = [Select Id, Name 
                                                        from ESN_MB_NodePage__c 
                                                        where recordType.Name = 'Brand' 
                                                        OR recordType.Name = 'Product' 
                                                        order by Name];


        return articleNodePageList;
    }
    
    
    /**
    * Method retrieveLinkedArticles(String articleId)
    * @param articleId: String param containing the current article id
    * @return linkedArticlesList: returns the list of articles linked to the current one (articleId, article Name, main asset thumbnail, section and rubric)
    */ 
    @RemoteAction
    global static List<ESN_MB_NOP_Related_Article_DTO> retrieveLinkedArticles(String articleId) {
        List<ESN_MB_Entry__c> linkedIdsList = [Select ESN_MB_Article_See_Also__c 
                                               From ESN_MB_Entry__c 
                                               Where recordType.DeveloperName = 'ESN_MB_Articles_To_Articles' 
                                               And ESN_MB_Article__c = :articleId
                                               And ESN_MB_Article_See_Also__c != null];
        List<String> idsList = new List<String>();
        for(ESN_MB_Entry__c e : linkedIdsList) {
            idsList.add(e.ESN_MB_Article_See_Also__c);
        }
        System.debug('retrieveLinkedArticles > idsList.size()=' + idsList.size());

        List<ESN_MB_Entry__c> articlesList = [Select ESN_MB_Article__c, ESN_MB_Article__r.Name, ESN_MB_Asset__r.ESN_MB_Url_Thumbnail__c,ESN_MB_Asset__r.ESN_MB_DocumentId__c 
                                              From ESN_MB_Entry__c 
                                              Where ESN_MB_RoleAsset__c = 'MainAsset' 
                                              And ESN_MB_Article__c in :idsList
                                              Order by CreatedDate Desc
                                              limit 3];
        System.debug('retrieveLinkedArticles > articlesList.size()=' + articlesList.size());
        
        List <ESN_MB_Entry__c> articleToRubricList = [Select ESN_MB_Article__c, ESN_MB_Rubric__r.Name, ESN_MB_Rubric__r.ESN_MB_Section__c 
                                                      From ESN_MB_Entry__c 
                                                      Where ESN_MB_Article__c in :idsList
                                                      And recordType.DeveloperName = 'ESN_MB_Articles_To_Rubrics'];
        System.debug('retrieveLinkedArticles > articleToRubricList.size()=' + articleToRubricList.size());

        List<ESN_MB_NOP_Related_Article_DTO> linkedArticlesList = new List<ESN_MB_NOP_Related_Article_DTO>();
        
        for(ESN_MB_Entry__c article : articlesList) {
            for(ESN_MB_Entry__c articleToRubric : articleToRubricList) {
                if(article.ESN_MB_Article__c == articleToRubric.ESN_MB_Article__c) {
                    ESN_MB_NOP_Related_Article_DTO relatedArticle = new ESN_MB_NOP_Related_Article_DTO();
                    relatedArticle.articleId = article.ESN_MB_Article__c;
                    relatedArticle.articleName = article.ESN_MB_Article__r.Name;
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
    
    /**
    * Method retrieveLinkedAssets(String articleId)
    * @param currentArticleId: String param containing the current article id 
    * @return assetsList: returns a list of assets
    */ 
    @remoteAction 
    global static List<ESN_MB_Entry__c> retrieveLinkedAssets(String currentArticleId) {
        String articlesToAssetsRT = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Assets');
        List<ESN_MB_Entry__c> linkedAssetsList = [Select ESN_MB_Asset__c, ESN_MB_Asset__r.Name, ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Asset__r.ESN_MB_originalFile_extension__c, ESN_MB_Asset__r.ESN_MB_URL_originalFile__c,ESN_MB_Asset__r.ESN_MB_DocumentId__c,
                                                  ESN_MB_Asset__r.ESN_MB_DAMId__c, ESN_MB_Asset__r.ESN_MB_SizeMo__c, ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c,ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c,ESN_MB_Asset__r.ESN_MB_URL_bamVideoPreview__c, ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c,
                                                  ESN_MB_RoleAsset__c, ESN_MB_Asset__r.ESN_MB_prettySize__c, ESN_MB_Asset__r.ESN_MB_URL_bamArticleFull__c, ESN_MB_Asset__r.ESN_MB_mimeType__c,ESN_MB_Asset__r.ESN_MB_Storyboard_Slide_Count__c,ESN_MB_Asset__r.ESN_MB_Storyboard_URL__c,ESN_MB_Asset__r.ESN_MB_Storyboard_LargeURL__c
                                                  From ESN_MB_Entry__c 
                                                  Where ESN_MB_Article__c = :currentArticleId
                                                  And recordTypeId = :articlesToAssetsRT];
        return linkedAssetsList;
    }
    
    
    /**
    * Method deleteRelatedArticle(String currentArticleId, String relatedArticleId)
    * @param currentArticleId: String param containing the current article id 
    * @param relatedArticleId: String param containing the related article id
    */ 
    @remoteAction 
    global static String deleteRelatedArticleEntry(String currentArticleId, String relatedArticleId) {
        ESN_MB_Entry__c entryRelatedArticle = [Select Id 
                                               From ESN_MB_Entry__c 
                                               Where ESN_MB_Article__c = :currentArticleId 
                                               And ESN_MB_Article_See_Also__c = :relatedArticleId
                                               limit 1];
        delete entryRelatedArticle;
        return currentArticleId;
    }
    
    /**
    * Method createEntryAssetArticle(String currentArticleId, String assetId, boolean mainAsset)
    * @param currentArticleId: String param containing the id of the current article
    * @param assetId: String param containing the asset to link to the article on the entry
    * @param roleAsset: String param containing the role of the asset on the entry
    * @return entry.Id: returns the id of the entry.
    */
    @RemoteAction
    global static String createEntryAssetArticle(String currentArticleId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Article__c = currentArticleId;
        entry.ESN_MB_Asset__c = assetId;
        entry.ESN_MB_RoleAsset__c = roleAsset;
        entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Assets');
        insert entry;
        return entry.Id;
    }
    
    /**
    * Method createInternalAsset(String contentId)
    * @param contentId: param of type String, content Id to match on the entry
    * @return asset.Id: returns the asset id to match on entry with activation
    * This method adds an asset (RT=Internal) depending on the content Id
    */
    @RemoteAction
    global static String createInternalAsset(String contentId, String description) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Internal_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
        asset.ESN_MB_DocumentId__c = contentId;
        asset.ESN_MB_description__c = description; 
        asset.Name = description; 
        insert(asset); 
        return asset.Id;
    }
    
    /**
    * Method createEntryAssetActivation(String article, String assetId, String roleAsset)
    * @param currentActivationId: String param containing the id of the current activation
    * @param assetId: String param containing the asset to link to the article on the entry
    * @param roleAsset: String param containing the role of the asset on the entry
    * @return entry.Id: returns the id of the entry.
    */
    @RemoteAction
    global static String createEntryArticleAsset(String articleId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Article__c = articleId;
        entry.ESN_MB_Asset__c = assetId;
        entry.ESN_MB_RoleAsset__c = roleAsset;
        entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Assets');
        insert entry;
        return entry.Id;
    }
    /**
    * Method setMainAsset(String currentArticleId, String newMainAssetId)
    * @param currentArticleId: String param containing the id of the current article
    * @param newMainAssetId: String param containing the new mainAssetId
    * @return newMainAssetEntry.Id
    */
    @RemoteAction
    global static String setMainAsset(String currentArticleId, String newMainAssetId) {
        List<ESN_MB_Entry__c> oldEntries = [Select Id, ESN_MB_RoleAsset__c
                                            From ESN_MB_Entry__c 
                                            Where ESN_MB_Article__c = :currentArticleId];
        for(ESN_MB_Entry__c e : oldEntries) {
            if(e.ESN_MB_RoleAsset__c == 'MainAsset') {
                e.ESN_MB_RoleAsset__c = 'BrandContent';
                update e;
            }
        }
        ESN_MB_Entry__c newMainAssetEntry = [Select Id, ESN_MB_RoleAsset__c
                                             From ESN_MB_Entry__c 
                                             Where ESN_MB_Article__c = :currentArticleId 
                                             And ESN_MB_Asset__c = :newMainAssetId
                                             limit 1];
        newMainAssetEntry.ESN_MB_RoleAsset__c = 'MainAsset';
        update newMainAssetEntry;
        return newMainAssetEntry.Id;
    }
    
    /**
    * Method deleteAssetArticleEntry(String currentArticleId, String assetId)
    * @param currentArticleId: String param containing the current article id 
    * @param assetId: String param containing the asset id linked to the article
    */ 
    @remoteAction 
    global static String deleteEntryAssetArticle(String currentArticleId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entryAssetArticle = [Select Id 
                                             From ESN_MB_Entry__c 
                                             Where ESN_MB_Article__c = :currentArticleId 
                                             And ESN_MB_Asset__c = :assetId
                                             And ESN_MB_RoleAsset__c = :roleAsset
                                             limit 1];
        delete entryAssetArticle;
        return currentArticleId;
    }
    
    @RemoteAction 
    global static void deleteArticle(String articleId) {
        //We also delete entries pointing to this article
        List<ESN_MB_Entry__c> listEntryArticle = [Select Id 
                                               From ESN_MB_Entry__c 
                                               Where ESN_MB_Article__c = :articleId];
        
        List <Database.DeleteResult> listResult = Database.delete(listEntryArticle);
        System.debug('deleteEnties '+ listResult);
        
        //We also delete entries where this article was in the See Also field (related articles)
        List<ESN_MB_Entry__c> listEntryRelatedArticle = [Select Id 
                                               From ESN_MB_Entry__c 
                                               Where recordType.DeveloperName = 'ESN_MB_Articles_To_Articles'
                                               And ESN_MB_Article_See_Also__c = :articleId];
        
        listResult = Database.delete(listEntryRelatedArticle);
        System.debug('deleteEntiesSeeAlso '+ listResult);
        
        
        ESN_MB_Article__c article = [Select Id From ESN_MB_Article__c Where Id=:articleId];
        Database.DeleteResult result = Database.delete(article);
        System.debug('deleteArticle '+ result);
    }
    @RemoteAction 
    global static boolean isBroadCasterUser(){
        return ESN_MB_UtilsUser.isBroadCasterUser();
    }
    @RemoteAction 
    global static boolean isBroadCasterAssigned(String brandId){
        return ESN_MB_UtilsUser.isBroadCasterUser(brandId);
    }

     /* method retrieveArticleOwner(userId)
    * @param userId: id of the user to get the infos from
    * @return articleOwner: returns the user that created the article
    */
    @RemoteAction
    global static User retrieveArticleOwner(String userId) {
        User articleOwner = [Select Name, Title, Email, SmallPhotoUrl
                                  From User
                                  Where id = :userId];
        return articleOwner;
    }
    
    @RemoteAction
    global static void updateArticleToStagePublish(String articleId) {
                                              
        ESN_MB_Article__c article = [SELECT Id, ESN_MB_Stage__c FROM ESN_MB_Article__c
                                           WHERE Id = :articleId];
        
        article.ESN_MB_Stage__c = 'Published';
        update(article);   
    } 
    
    @RemoteAction
    global static void updateArticleToStageArchive(String articleId) {
                                              
        ESN_MB_Article__c article = [SELECT Id, ESN_MB_Stage__c FROM ESN_MB_Article__c
                                           WHERE Id = :articleId];
        
        article.ESN_MB_Stage__c = 'Archived';
        update(article);   
    } 
}