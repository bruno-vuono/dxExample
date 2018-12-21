/**
    About
    -----
    Description: utils class for ESN_MB_NOP_Homepage_Cx_Test class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains utils for tests of ESN_MB_NOP_Homepage_Cx_Test class
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------  
*/
@isTest
public class ESN_MB_NOP_Homepage_Cx_Test_Utils {
    
   /**
    * Method createNodePage
    * @param name: String value corresponding to the nodePage name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @param order: Decimal value corresponding to the order of the record (10/20/30...)
    * @return nodePage: returns the created local record of nodePage.
    */
    public static ESN_MB_NodePage__c createNodePage(String name, String recordTypeId, Decimal order) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = recordTypeId;
        nodePage.Name = name;
        nodePage.ESN_MB_Order__c = order;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        nodePage.ESN_MB_Brand_DAM_Id__c = 'test';
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }
    
    /**
    * Method createNodePage
    * @param name: String value corresponding to the nodePage name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @param order: Decimal value corresponding to the order of the record (10/20/30...)
    * @param order: String value corresponding to the nodePage category to set
    * @return nodePage: returns the created local record of nodePage.
    */
    public static ESN_MB_NodePage__c createNodePage(String name, String recordTypeId, Decimal order, String brandCategory) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = recordTypeId;
        nodePage.Name = name;
        nodePage.ESN_MB_Order__c = order;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        nodePage.ESN_MB_Brand_DAM_Id__c = 'test';
        nodePage.ESN_MB_Brand_Category__c = brandCategory;
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }
    
     /**
    * Method createNodePageDisable
    * @param name: String value corresponding to the nodePage name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @param order: Decimal value corresponding to the order of the record (10/20/30...)
    * @return nodePage: returns the created local record of nodePage set to disable
    */
    public static ESN_MB_NodePage__c createNodePageDisable(String name, String recordTypeId, Decimal order) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = recordTypeId;
        nodePage.Name = name;
        nodePage.ESN_MB_Order__c = order;
        nodePage.ESN_MB_Deployment_Status__c = 'Disable';
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }
    
   /**
    * Method createProduct
    * @param name: String value corresponding to the product name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @param order: Decimal value corresponding to the order of the record (10/20/30...)
    * @param parentId: String value corresponding to the parent of the product (brand)
    * @return nodePage: returns the created local record of nodePage.
    */
    public static ESN_MB_NodePage__c createProduct(String name, String recordTypeId, Decimal order, id parentId) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = recordTypeId;
        nodePage.Name = name;
        nodePage.ESN_MB_Order__c = order;
        nodePage.ESN_MB_ParentId__c = parentId;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }

    public static ESN_MB_NodePage__c createProduct(String name, Decimal order, id parentId) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        nodePage.Name = name;
        nodePage.ESN_MB_Order__c = order;
        nodePage.ESN_MB_ParentId__c = parentId;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }
    
    public static ESN_MB_NodePage__c createMasterbrand(String name, Decimal order, id parentId) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        nodePage.Name = name;
        nodePage.ESN_MB_Order__c = order;
        nodePage.ESN_MB_ParentId__c = parentId;
        nodePage.ESN_MB_IsMasterbrand__c = true;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }

   /**
    * Method createRubric
    * @param name: String value corresponding to the nodePage Rubric name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @param order: Decimal value corresponding to the order of the record (10/20/30...)
    * @param section: String value corresponding to the section whose belongs the rubric
    * @return nodePage: returns the created local record of nodePage rubric.
    */
    public static ESN_MB_NodePage__c createRubric(String name, String recordTypeId, Decimal order, String section) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = recordTypeId;
        nodePage.Name = name;
        nodePage.ESN_MB_Section__c = section;
        nodePage.ESN_MB_Order__c = order;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }

    public static ESN_MB_NodePage__c createRubric(String name, Decimal order, String section) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Rubric');
        nodePage.Name = name;
        nodePage.ESN_MB_Section__c = section;
        nodePage.ESN_MB_Order__c = order;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }

    public static ESN_MB_NodePage__c createBrandForDam(String name, String brandDamId, String status, Boolean isInitBatch) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        nodePage.Name = name;
        nodePage.ESN_MB_Brand_DAM_Id__c = brandDamId;
        nodePage.ESN_MB_Deployment_Status__c = status;
        nodePage.ESN_MB_Brand_Initialization__c = isInitBatch;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }

    public static ESN_MB_NodePage__c createBrand(String name, String url) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        nodePage.Name = name;
        nodePage.ESN_MB_NorthPlains_Portal_URL__c = url;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }

    public static ESN_MB_NodePage__c createBrandWithSocialLinks(String name, String facebookUrl, String flickrUrl, String googlePlusUrl, 
                                                                String twitterUrl, String youtubeUrl) {
        ESN_MB_NodePage__c nodePage = new ESN_MB_NodePage__c();
        nodePage.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        nodePage.Name = name;
        nodePage.ESN_MB_Url_Facebook_Link__c = facebookUrl;
        nodePage.ESN_MB_Url_Flickr_Link__c = flickrUrl;
        nodePage.ESN_MB_Url_GooglePlus_Link__c = googlePlusUrl;
        nodePage.ESN_MB_Url_Twitter_Link__c = twitterUrl;
        nodePage.ESN_MB_Url_Youtube_Link__c = youtubeUrl;
        nodePage.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(nodePage);
        return nodePage;
    }
    
   /**
    * Method createImageResource
    * @param name: String value corresponding to the resource name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @param resourceType: String value corresponding to the resource type (Logo/Tile)
    * @return nodePage: returns the created local record of resource.
    */
    public static ESN_MB_Resource__c createImageResource(String name, String recordTypeId, String resourceType) {
        ESN_MB_Resource__c resource = new ESN_MB_Resource__c();
        resource.Name = name;
        resource.RecordTypeId = recordTypeId;
        resource.ESN_MB_Type__c = resourceType;
        resource.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(resource);
        return resource;
    }
   /**
    * Method createCssResource
    * @param name: String value corresponding to the resource name to set
    * @param recordTypeId: String value corresponding to the recordType Id to set
    * @return nodePage: returns the created local record of resource.
    */
    public static ESN_MB_Resource__c createCssResource(String name, String recordTypeId) {
        ESN_MB_Resource__c resource = new ESN_MB_Resource__c();
        resource.Name = name;
        resource.RecordTypeId = recordTypeId;
        resource.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(resource);
        return resource;
    }
    
   /**
    * Method createAttachment
    * @param name: String value corresponding to the attachment name to set
    * @param resource: ESN_MB_Resource__c value corresponding to the resource on which to set the attachment
    * @return attachment: returns the created local record of attachment.
    */
    public static Attachment createAttachment(String name, ESN_MB_Resource__c resource) {
        Blob b = Blob.valueOf('Test Data body'); 
        Attachment attachment = new Attachment();
        attachment.Name = name;
        attachment.Body = b;
        attachment.ParentId = resource.Id;
        Database.SaveResult result = Database.insert(attachment);
        return attachment;
    }
    
   /**
    * Method createActivation
    * @param recordTypeId: String value corresponding to the activation record type id
    * @return activation: returns the created local activation
    */
    public static ESN_MB_Activation__c createActivation(String recordTypeId) {
        return createActivation(recordTypeId, null, null, null, null, null);
    }

    public static ESN_MB_Activation__c createActivation(String recordTypeId, String productId, String stage, 
                                                            String mainActivationId, String activationType, String parentActivation) {
        ESN_MB_Activation__c activation = new ESN_MB_Activation__c();
        activation.RecordTypeId = recordTypeId;
        activation.ESN_MB_Product__c = productId;
        activation.ESN_MB_Stage__c = stage;
        activation.ESN_MB_MainActivationId__c = mainActivationId;
        activation.ESN_MB_Activation_Type__c = activationType;
        activation.ESN_MB_Parent_Activation__c = parentActivation;

        Database.SaveResult result = Database.insert(activation);    
        return activation;
    }

   /**
    * Method createContent
    * @return content: returns the created local content
    */
    public static ContentVersion createContent(String title) {
        Blob b = Blob.valueOf('1'); 
        ContentVersion content = new ContentVersion();
        content.PathOnClient = title;
        content.Title = title;
        content.VersionData = b;
        Database.SaveResult result = Database.insert(content);    
        return content;
    }
    
   /**
    * Method createAsset
    * @param recordTypeId: String value corresponding to the record type Id
    * @param contentId: Id value corresponding to the related content id
    * @return asset: returns the created local asset
    */
    public static ESN_MB_Asset__c createAsset(String recordTypeId, Id contentId, String urlAsset) {
        return createAsset(recordTypeId, contentId, urlAsset, null, null, null, null);
    }

    public static ESN_MB_Asset__c createAsset(String recordTypeId, Id contentId, String urlAsset, String name, String mimeType, String fileExtension, String brandScope) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.name = name;
        asset.RecordTypeId = recordTypeId;
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        if(contentId != null) {
            asset.ESN_MB_DocumentId__c = contentId;
        }
        asset.ESN_MB_UrlAsset__c = urlAsset;
        asset.ESN_MB_mimeType__c = mimeType;
        asset.ESN_MB_originalFile_extension__c = fileExtension;
        asset.ESN_MB_Brand_Scope_Text__c = brandScope;

        Database.SaveResult result = Database.insert(asset);    
        return asset;
    }
    
    public static ESN_MB_Asset__c createAssetWithDamId(String recordTypeId, Id contentId, String urlAsset, String name, String mimeType, String fileExtension, String brandScope, String damId) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.name = name;
        asset.RecordTypeId = recordTypeId;
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        if(contentId != null) {
            asset.ESN_MB_DocumentId__c = contentId;
        }
        asset.ESN_MB_UrlAsset__c = urlAsset;
        asset.ESN_MB_mimeType__c = mimeType;
        asset.ESN_MB_originalFile_extension__c = fileExtension;
        asset.ESN_MB_Brand_Scope_Text__c = brandScope;
        asset.ESN_MB_DAMId__c = damId;
        Database.SaveResult result = Database.insert(asset);    
        return asset;
    }
    
    public static ESN_MB_Asset__c createWebinarAsset(String recordTypeId, Id contentId, String urlAsset, String name, String mimeType, String fileExtension, String brandScope) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.name = name;
        asset.RecordTypeId = recordTypeId;
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        if(contentId != null) {
            asset.ESN_MB_DocumentId__c = contentId;
        }
        asset.ESN_MB_UrlAsset__c = urlAsset;
        asset.ESN_MB_mimeType__c = mimeType;
        asset.ESN_MB_originalFile_extension__c = fileExtension;
        asset.ESN_MB_Brand_Scope_Text__c = brandScope;
        asset.ESN_MB_isWebinar__c = 'Webinar';
        Database.SaveResult result = Database.insert(asset);    
        return asset;
    }

    public static ESN_MB_Asset__c createAssetTaxonomy(String assetTypeTaxonomy, String marketInfoTaxonomy, String marketActivityTaxonomy) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        asset.ESN_MB_Taxonomy_AssetType__c = assetTypeTaxonomy;
        asset.ESN_MB_Taxonomy_MarketInformation__c = marketInfoTaxonomy;
        asset.ESN_MB_Taxonomy_MarketingActivity__c = marketActivityTaxonomy;

        Database.SaveResult result = Database.insert(asset);    
        return asset;
    }

    /**
    * Method createArticle
    * @param name: String value corresponding to the name of the article
    * @param parentNodePageId: String value corresponding to the id of the parent node page (brand/product)
    * @return article: returns the created local article
    */
    public static ESN_MB_Article__c createArticle(String name, Id parentNodePageId) {
        return createArticle(name, parentNodePageId, null, false, null);
    }

    /**
    * Method createArticle
    * @param name: String value corresponding to the name of the article
    * @param parentNodePageId: String value corresponding to the id of the parent node page (brand/product)
    * @param stage
    * @return article: returns the created local article
    */
    public static ESN_MB_Article__c createArticle(String name, Id parentNodePageId, String stage, boolean applyToAllProducts, String parentArticleId) {
        ESN_MB_Article__c article = new ESN_MB_Article__c();
        article.Name = name;
        article.ESN_MB_Top_Text__c = 'This is a test top description';
        article.ESN_MB_Bottom_Text__c = 'This is a test top description';
        article.ESN_MB_Node_Page__c = parentNodePageId;
        article.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        article.ESN_MB_Stage__c = stage;
        article.ESN_MB_Apply_To_All_Products__c = applyToAllProducts;
        article.ESN_MB_ParentArticle__c = parentArticleId;

        Database.SaveResult result = Database.insert(article);
        return article;
    }

    
    public static ESN_MB_Article__c createArticle(String name, Datetime createdDate, Datetime LastModifiedDate, String status){
        String articleJSON = '{"attributes":{"type":"ESN_MB_Article__c"},"CreatedDate":"' + JSON.serialize(createdDate).replace('"','') + '",' 
            + '"LastModifiedDate":"' + JSON.serialize(createdDate).replace('"','') + '",'
            + '"Name":"' + name + '","ESN_MB_Stage__c":"' + status + '"}';
        return (ESN_MB_Article__c) JSON.deserialize(articleJSON, ESN_MB_Article__c.class );
    }
    
    public static ESN_MB_Article__c createArticle(String name, Id parentNodePageId, String stage, boolean applyToAllProducts, String parentArticleId, Boolean flagSplashScreen) {
        ESN_MB_Article__c article = new ESN_MB_Article__c();
        article.Name = name;
        article.ESN_MB_Top_Text__c = 'This is a test top description';
        article.ESN_MB_Bottom_Text__c = 'This is a test top description';
        article.ESN_MB_Node_Page__c = parentNodePageId;
        article.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        article.ESN_MB_Stage__c = stage;
        article.ESN_MB_Apply_To_All_Products__c = applyToAllProducts;
        article.ESN_MB_ParentArticle__c = parentArticleId;
        article.ESN_MB_FlagSplashScreen__c = flagSplashScreen;
        Database.SaveResult result = Database.insert(article);
        return article;
    }
    
   /**
    * Method createNodePageResourceEntry
    * @param nodePage: ESN_MB_NodePage__c value corresponding to the nodePage to set on the Entry
    * @param resource: ESN_MB_Resource__c value corresponding to the resource to set on the Entry
    * @return createdEntry: returns the created local record of entry.
    */
    public static ESN_MB_Entry__c createNodePageResourceEntry(ESN_MB_NodePage__c nodePage, ESN_MB_Resource__c resource) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,null,null,resource.id,null,nodePage.id,null,null,null);
        return createdEntry;
    }

    public static ESN_MB_Entry__c createNodePageResourceEntry(ESN_MB_NodePage__c nodePage, ESN_MB_Resource__c resource, 
                                                              ESN_MB_NodePage__c rubric, String recordTypeId) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,null,null,resource.Id,rubric.Id,nodePage.Id,null,recordTypeId,null);
        return createdEntry;   
    }
    
   /**
    * Method createArticleAssetEntry
    * @param article: ESN_MB_Article__c value corresponding to the article to set on the Entry
    * @param asset: ESN_MB_Asset__c value corresponding to the asset to set on the Entry
    * @return createdEntry: returns the created local record of entry.
    */
    public static ESN_MB_Entry__c createArticleAssetEntry(ESN_MB_Article__c article, ESN_MB_Asset__c asset) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,asset.id,article.id,null,null,null,null,null,null);
        return createdEntry;   
    }
    
    public static ESN_MB_Entry__c createArticleAssetEntry(ESN_MB_Article__c article, ESN_MB_Asset__c asset, String roleAsset) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,asset.id,article.id,null,null,null,roleAsset,null,null);
        return createdEntry;   
    }

   /**
    * Method createNodePageResourceEntry
    * @param article: ESN_MB_Article__c value corresponding to the article to set on the Entry
    * @param rubric: ESN_MB_NodePage__c value corresponding to the rubric to set on the Entry
    * @return createdEntry: returns the created local record of entry.
    */
    public static ESN_MB_Entry__c createArticleRubricEntry(ESN_MB_Article__c article, ESN_MB_NodePage__c rubric) {
        String articlesToRubricRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Rubrics');
        ESN_MB_Entry__c createdEntry = createEntry(null,null,article.id,null,rubric.id,null,null,articlesToRubricRTId,null);
        return createdEntry;   
    }

    public static ESN_MB_Entry__c createArticleRubricEntry(ESN_MB_Article__c article, ESN_MB_NodePage__c rubric, ESN_MB_Asset__c asset) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,asset.Id,article.id,null,rubric.id,null,null,null,null);
        return createdEntry;   
    }

    public static ESN_MB_Entry__c createArticleSeeAlsoEntry(ESN_MB_Article__c parentArticle, ESN_MB_Article__c seeAlsoArticle, String recordTypeId) {
        ESN_MB_Entry__c createdEntry = createEntry(null,null,parentArticle.id,null,null,null,null,recordTypeId,seeAlsoArticle.Id);
        return createdEntry;
    }

    public static ESN_MB_Entry__c createArticleEntry(ESN_MB_Article__c article, String recordTypeId) {
        ESN_MB_Entry__c createdEntry = createEntry(null,null,article.id,null,null,null,null,recordTypeId,null);
        return createdEntry;
    }

    public static ESN_MB_Entry__c createSplashScreenEntry(ESN_MB_Article__c article, ESN_MB_NodePage__c rubric, ESN_MB_Asset__c asset) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,asset.Id,article.id,null,rubric.id,null,'MainAsset',null,null);
        return createdEntry;   
    }

    /**
    * Method createActivationAssetEntry
    * @param activation: ESN_MB_Activation__c value corresponding to the activation to set on the Entry
    * @param asset: ESN_MB_Asset__c value corresponding to the asset to set on the Entry
    * @return createdEntry: returns the created local record of entry.
    */
    public static ESN_MB_Entry__c createActivationAssetEntry(ESN_MB_Activation__c activation, ESN_MB_Asset__c asset) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(activation.Id,asset.Id,null,null,null,null,null,null,null);
        return createdEntry;   
    }
    
    public static ESN_MB_Entry__c createAssetEntry(ESN_MB_Asset__c asset) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,asset.Id,null,null,null,null,null,null,null);
        return createdEntry;   
    }
    
    public static ESN_MB_Entry__c createActivationEntry(ESN_MB_Activation__c activation, String recordTypeId, String roleAsset) {
        ESN_MB_Entry__c createdEntry = createEntry(activation.Id,null,null,null,null,null,roleAsset, recordTypeId, null);
        return createdEntry;
    }

    public static ESN_MB_Entry__c createProductEntry(String nodePageId, String resourceId) {
        //createEntry params: activation/asset/article/resource/rubric/nodepage
        ESN_MB_Entry__c createdEntry = createEntry(null,null,null,resourceId,null,nodePageId,null,null,null);
        return createdEntry;
    }

    /**
    * Method createEntry
    * @param activationId: Id value corresponding to the activation Id to set on the entry
    * @param assetId: Id value corresponding to the asset Id to set on the entry
    * @param articleId: Id value corresponding to the article Id to set on the entry
    * @param resourceId: Id value corresponding to the resource Id to set on the entry
    * @param rubricId: Id value corresponding to the rubric Id to set on the entry
    * @param nodePageId: Id value corresponding to the nodePage Id to set on the entry
    * @return entry: returns the created local record of entry.
    */    
    private static ESN_MB_Entry__c createEntry(Id activationId, Id assetId, 
                                               Id articleId, Id resourceId, 
                                               Id rubricId, Id nodePageId,
                                               String roleAsset, String recordTypeId,
                                               Id seeAlsoArticle) {

        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        if(activationId != null) {
            entry.ESN_MB_Activation__c = activationId;
        }
        if(assetId != null){
            entry.ESN_MB_Asset__c = assetId;
        }                                           
        if(articleId != null){
            entry.ESN_MB_Article__c = articleId;
        }
        if(resourceId != null){
            entry.ESN_MB_Resource__c = resourceId;                                            
        }
        if(rubricId != null) {
            entry.ESN_MB_Rubric__c = rubricId;
        }
        if(nodePageId != null) {
            entry.ESN_MB_Node_Page__c = nodePageId;
        }
        if (String.isNotBlank(recordTypeId)) {
            entry.RecordTypeId = recordTypeId;                                               
        }
        entry.ESN_MB_RoleAsset__c = roleAsset;
        entry.ESN_MB_Article_See_Also__c = seeAlsoArticle;

        //entry.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        Database.SaveResult result = Database.insert(entry);
        return entry;
    }

    public static User getBroadcasterUser() {
        return getUser('ESN_MB_MyBrands_BroadCaster');
    }

    public static User getStandardUser() {
        return getUser('ESN_MB_MyBrands_User');
    }

    public static User getBroadcasterUser(String brandScope) {
        return getUser('ESN_MB_MyBrands_BroadCaster', brandScope);
    }

    public static User getStandardUser(String brandScope) {
        return getUser('ESN_MB_MyBrands_User', brandScope);
    }
    
    public static User getCockpitAdmin() {
        return getUser('ESN_MB_MyBrands_Cockpit_Administrator');
    }

    private static User getUser(String permissionName, String brandScope) {
/*        String userId  = [select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :permissionName].get(0).AssigneeId;
        User user = [SELECT Id FROM User WHERE Id= :userId];
        return user;*/
        User user1 = null;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            user1 = new User(Username = System.now().millisecond() + 'emailtest2@emailtest.com', LastName = Userinfo.getLastName(), Email = 'email@email.com',
                Alias = 'ULAS', TimeZoneSidKey='America/Los_Angeles', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', profileid = UserInfo.getProfileId(), UserRoleId = Userinfo.getUserRoleId(), ESN_MB_AssignedBrands__c = brandScope);
            insert user1;

            PermissionSet ps = [select Id from PermissionSet where Name = :permissionName];
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = user1.id, PermissionSetId = ps.id);
            insert psa;
        }
        //User user = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
 /* 
        if (user1 != null) {
            User adminuser = [select Id from User where Profile.Name = 'System Administrator' and IsActive = true limit 1];
            System.runAs(adminuser){
                PermissionSet ps = [select Id from PermissionSet where Name = :permissionName];
                PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = user1.id, PermissionSetId = ps.id);
                insert psa;
            }
        }*/
/*        List<PermissionSetAssignment> assigneeList = [select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :permissionName];

        List<String> userIdList = new List<String>();
        for (PermissionSetAssignment assignee : assigneeList) {
            userIdList.add(assignee.assigneeId);
        }

        User user = [SELECT Id FROM User WHERE Id IN :userIdList AND IsActive = true].get(0);
*/
        return user1;
    }

    private static User getUser(String permissionName) {
        return getUser(permissionName, null);
    }

    public static ESN_MB_User_Interaction__c createUserInteraction(User user, ESN_MB_Activation__c activation) {
        ESN_MB_User_Interaction__c userInteraction = new ESN_MB_User_Interaction__c();
        userInteraction.ESN_MB_User__c = user.Id;
        userInteraction.ESN_MB_Activation__c = activation.Id;

        Database.SaveResult result = Database.insert(userInteraction);
        return userInteraction;
    }
    
    public static ESN_MB_User_Interaction__c createUserInteractionLike(String userId, ESN_MB_Activation__c activation) {
        ESN_MB_User_Interaction__c userInteraction = new ESN_MB_User_Interaction__c();
        userInteraction.ESN_MB_User__c = userId;
        userInteraction.ESN_MB_Activation__c = activation.Id;
        userInteraction.ESN_MB_Like__c = true;

        Database.SaveResult result = Database.insert(userInteraction);
        return userInteraction;
    }
    

    /**
    * use for Chatter test
    **/
    public static CollaborationGroup insertCollaborationGroup(String name) {
        User user1 = getStandardUser();

        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = name;
        cg.OwnerId = user1.Id;
        cg.CollaborationType = 'Public'; //can be 'Public' or 'Private'                   
        insert cg;

/*        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = name;
        cg.OwnerId = getStandardUser().Id;
        cg.CollaborationType = 'Public'; //can be 'Public' or 'Private'                   
        insert cg;
*/
        return cg;
    }
    
    /**
     * createMyBrandsCS()
     * This methods creates a custom setting with arguments values 
     */ 
    public static ESN_MB_MyBrandsSettings__c createMyBrandsCS(String crmContentId, String googleAnalytics, String activationPlatformRubricId, 
                                                              String jamesonBgColor, String jamesonFontColor, String newsCoverRubricId, 
                                                              String urlBis, String npApiDomain, String npPassword, String npUrl, String npUser, String posUrl) {
        ESN_MB_MyBrandsSettings__c myCustomSetting = new ESN_MB_MyBrandsSettings__c();
        if(crmContentId != null) {
            myCustomSetting.ESN_MB_CRM_Content_Id__c = crmContentId;
        }
        if(googleAnalytics != null) {
            myCustomSetting.ESN_MB_Google_Analytics__c = googleAnalytics;
        }
        if(activationPlatformRubricId != null) {
            myCustomSetting.ESN_MB_360ActivationPlatfor_Rubric_Id__c = activationPlatformRubricId;
        }
        if(jamesonBgColor != null) {
            myCustomSetting.ESN_MB_MyBrands_Jameson_BackgroundColor__c = jamesonBgColor;
        }
        if(jamesonFontColor != null) {
            myCustomSetting.ESN_MB_MyBrands_Jameson_FontColor__c = jamesonFontColor;
        }
        if(newsCoverRubricId != null) {
            myCustomSetting.ESN_MB_NewsCover_Rubric_Id__c = newsCoverRubricId;
        }
        if(urlBis != null) {
            myCustomSetting.ESN_MB_URL_Bis__c = urlBis;
        }
        if(npApiDomain != null) {
            myCustomSetting.ESN_MB_NP_API_Domain__c = npApiDomain;
        }
        if(npPassword != null) {
            myCustomSetting.ESN_MB_NP_Password__c = npPassword;
        }
        if(npUrl != null) {
            myCustomSetting.ESN_MB_NP_URL__c = npUrl;
        }
        if(npUser != null) {
            myCustomSetting.ESN_MB_NP_User__c = npUser;
        }
        if(posUrl != null) {
            myCustomSetting.ESN_MB_POS_URL__c = posUrl;
        }
        insert myCustomSetting;                                                                             
        return myCustomSetting;                                                           
    }
    
    
}