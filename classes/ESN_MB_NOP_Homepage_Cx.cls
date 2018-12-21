/**
    About
    -----
    Description: Controler Class for MyBrands Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains methods for controlling MyBrand Homepage VisualForce
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / 
    s
    --------------
    Kevin Gerard 20/08/2014 - CHANGE CONTENT WITH ESN_MB_Brand_Cx
*/


global class ESN_MB_NOP_Homepage_Cx {
    public static List<Attachment> brandsLogos{get;set;}
    public static List<Attachment> logosBottleIds{get;set;}
    public static List<Attachment> logosRubricsIds{get;set;}
    public static List<ESN_MB_NodePage__c> brandsNames{get;set;}
    public static List<ESN_MB_NodePage__c> rubrics{get;set;}
    public static List<ESN_MB_NodePage__c> rubricsImages{get;set;}
    public static List<ESN_MB_Entry__c> products{get;set;}
    public static List<ESN_MB_Entry__c> resources{get;set;}
    public static List<String> productsLogosIds{get;set;}
    public String brandName{get; set;}
    public String brandCategory{get; set;}
    public String newsCoverRubricID{get; set;}
    public static String currentBrandStaticResource;
    public static String currentBrandCss{get; set;}
    public String currentBrandCssURL;
    public String brandId{get; set;}
    public String background;
    public String portfolioBackground;
    public static List<String> categoryList{get;set;}
    public String currentCategory{get; set;}
    
    public ESN_MB_NOP_Homepage_Cx () {
        //Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge'); 
        brandId = ApexPages.currentPage().getParameters().get('BrandId');
        brandName = getBrand();
        brandCategory = getCategory();
        newsCoverRubricID = ESN_MB_Utils.cs_NewsCoverRubricId();
        System.debug('BrandId = ' + brandId);
        /*getBrandNames();
        getSplashScreens();
        getListProductLogosIds();
        getListProduct();
        //getRubricList();
        getRubricsLogosIds();*/  
        getCategoryList();
        currentCategory = getCurrentCategory();
    }  
    
     public List<String> getCategoryList(){
        categoryList = new List<String>();
        Schema.DescribeFieldResult fieldResult = ESN_MB_NodePage__c.ESN_MB_Brand_Category__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();  
        for(Schema.picklistEntry f:ple) 
        {
            categoryList.add(f.getValue());
        }
        return categoryList;
    }
    
    public String getNorthPlainsPortalUrl() {
        ESN_MB_NodePage__c brandTmp = [SELECT ESN_MB_NorthPlains_Portal_URL__c
                                       FROM ESN_MB_NodePage__c
                                       WHERE id=:brandId LIMIT 1];
        System.debug('NorthPlains Portal URL = ' + brandTmp.ESN_MB_NorthPlains_Portal_URL__c);
        return brandTmp.ESN_MB_NorthPlains_Portal_URL__c;
    }
    
   /**
    * Method getIsBasicUser()
    * returns true if the user is not a broadcaster nor a brand manager
    */
    public Boolean getIsBasicUser() {
        return ESN_MB_UtilsUser.isBasicUser();
    }
    
   /**
    * Method retrieveLogosIds()
    * @return logosIds: returns the ids and parentIds of the logos
    * to display for each brand depending on the order
    */
    @RemoteAction
    global static List<String> retrieveLogosIds() {
        List<String> resourcesIds = new List<String>();
        List<String> logosIds = new List<String>();
        resources = [Select ESN_MB_Resource__c 
                     from ESN_MB_Entry__c 
                     where ESN_MB_Node_Page__r.RecordType.DeveloperName='ESN_MB_Brand' 

                     and ESN_MB_Resource__r.ESN_MB_Type__c='Tile' 
                     order by ESN_MB_Node_Page__r.ESN_MB_Order__c];
        for(ESN_MB_Entry__c e : resources) {
            resourcesIds.add(e.ESN_MB_Resource__c);
        }
        System.debug('resourcesIds.size()= ' + resourcesIds.size());

        brandsLogos = [Select id, ParentId from Attachment where ParentId IN :resourcesIds];
        System.debug('brandsLogos.size()= ' + brandsLogos.size());
        for(ESN_MB_Entry__c e : resources) {
            for(Attachment a : brandsLogos) {
                if (e.ESN_MB_Resource__c == a.ParentId) {
                    logosIds.add(a.id);
                }
            }
        }
        return logosIds;
    }
      
   /**
    * Method retrieveBrandNames()
    * @return brandsNames: returns the ids and names of each brand
    */
    public String getBrandNames(){
        List<ESN_MB_NodePage__c> listBrandNames = retrieveBrandNames();
        return JSON.serialize(listBrandNames);
        
    }
    @TestVisible private static List<ESN_MB_NodePage__c> retrieveBrandNames() {
        brandsNames = [select id, Name, ESN_MB_Deployment_Status__c, ESN_MB_Brand_Category__c, ESN_MB_Title__c
                       from ESN_MB_NodePage__c 
                       Where RecordType.DeveloperName = 'ESN_MB_Brand' 
                       order by ESN_MB_Order__c];    

        return brandsNames;
    }
    
   /**
    * Method retrieveProducts(String brandId)
    * @param brandName: param of type String, name of the brand
    * @return products: returns the products ids, names and resources ids for the brand
    * in the order precised on the object (ESN_MB_Order__c field on ESN_MB_NodePage__c object)
    */
    public String getListProduct() {
        List<ESN_MB_Entry__c> listProduct = retrieveProducts(brandId);
        return JSON.serialize(listProduct);
    }
    @TestVisible private static List<ESN_MB_Entry__c> retrieveProducts(String brandId) {
        products = [select ESN_MB_Node_Page__c, ESN_MB_Node_Page__r.Name, ESN_MB_Resource__c 
                    from ESN_MB_Entry__c 
                    where RecordType.DeveloperName != 'Articles_To_Products'
                    And RecordType.DeveloperName != 'Activations_To_Products'
                    And ESN_MB_Node_Page__r.ESN_MB_ParentId__c = :brandId 
                    order by ESN_MB_Node_Page__r.ESN_MB_Order__c];    
        return products;
    }
    
   /**
    * Method retrieveProductsLogosIds(String brandId)
    * @param brandId: param of type String, brand Id to get the related products logos
    * @return logosIds: returns the ids and Names of the logos
    * of the products to display for the brand
    */
    public String getListProductLogosIds() {
        
        List<String> listProductLogosIds = retrieveProductsLogosIds(brandId);
        return JSON.serialize(listProductLogosIds);
    }
    @TestVisible private static List<String> retrieveProductsLogosIds(String brandId) {
        products = retrieveProducts(brandId);
        productsLogosIds = new List<String>();
        List<String> logosIds = new List<String>();
        for(ESN_MB_Entry__c e : products) {
            productsLogosIds.add(e.ESN_MB_Resource__c);
        }
        System.debug('retrieveProductsLogosIds() > productsLogosIds.size()=' + productsLogosIds.size());

        logosBottleIds = [select id, Name, ParentId 
                          from Attachment 
                          where ParentId IN :productsLogosIds];
        System.debug('retrieveProductsLogosIds() > logosBottleIds.size()= ' + logosBottleIds.size());
        
        for(ESN_MB_Entry__c e : products) {
            for(Attachment a : logosBottleIds) {
                if (e.ESN_MB_Resource__c == a.ParentId) {
                    logosIds.add(a.id);
                }
            }
        }
        return logosIds;
    }   
    
    
   /**
    * Method createActivationDraft()
    * @return activation.Id: returns the activation id to match on entry with an asset.
    * This method creates an activation draft
    */
    @RemoteAction
    global static String createActivation() {
        ESN_MB_Activation__c activation = new ESN_MB_Activation__c();
        activation.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Market_Activation');
        activation.CurrencyIsoCode = UserInfo.getDefaultCurrency();    
        insert(activation);    
        return activation.Id;
    }
    
   /**
    * Method addAsset(String contentId)
    * @param contentId: param of type String, content Id to match on the entry
    * @return asset.Id: returns the asset id to match on entry with activation
    * This method adds an entry depending on the content Id
    */
    @RemoteAction
    global static String addAsset(String contentId) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Internal_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
        asset.ESN_MB_DocumentId__c = contentId;
        insert(asset);
        return asset.Id;
    }
    
   /**
    * Method matchEntry(String activationId, String assetId)
    * @param activationId: param of type String, content Id to match on the entry
    * @param assetId: param of type String, asset Id to match on the entry
    * @return entry.Id: returns the id of the new entry
    * This method adds an entry depending on the content Id and the asset Id
    */
    @RemoteAction
    global static String matchEntryActivationAsset(String activationId, String assetId) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Activation__c = activationId;
        entry.ESN_MB_Asset__c = assetId;
        insert(entry);
        return entry.Id;
    }
    
    /**
    * Method matchEntryAssetArticle(String articleId, String assetId)
    * @param articleId: param of type String, content Id to match on the entry
    * @param assetId: param of type String, asset Id to match on the entry
    * @return entry.Id: returns the id of the new entry
    * This method adds an entry depending on the content Id and the asset Id
    */
    @RemoteAction
    global static String matchEntryAssetArticle(String articleId, String assetId) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Article__c = articleId;
        entry.ESN_MB_Asset__c = assetId;
        insert(entry);
        return entry.Id;
    }

   /**
    * Method retrieveBrandCss(String brandName)
    * @param brandName: param of type String, name of the brand
    * @return brandCss: returns the id of the attachment corresponding
    * to the css file of the brand
    */
    //public String getBrandCss() {
    //    String brandId = ApexPages.currentPage().getParameters().get('BrandId');
    //    String brandName = [Select Name from ESN_MB_NodePage__c where id = :brandId].Name;
    //    String brandCss = retrieveBrandCss(brandName);
    //    return JSON.serialize(brandCss);
    //}
    @remoteaction
    global static String retrieveBrandCss(String brandName) {
        String thisBrandCss = brandName + '.css';
        String brandCssId = [Select id from Attachment where name = :thisBrandCss limit 1].id;
        return brandCssId;
    }
    
    public String getBackground() {
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='Background' and ESN_MB_Node_Page__r.Id = :brandId];
        if(resourceId.size() >0){
            List <Attachment> attachmentId = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
            if(attachmentId.size() >0){
                return attachmentId[0].Id;
            }else{
                return 'noBackground';
            }
        }else{
            return 'noBackground';
        }
 
    }
    
    public String getPortfolioBackground() {
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='PortfolioBackground' and ESN_MB_Node_Page__r.Id = :brandId];
        if(resourceId.size() >0){
            List <Attachment> attachmentId = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
            if(attachmentId.size() >0){
                return attachmentId[0].Id;
            }else{
                return 'noPortfolioBackground';
            }
        }else{
            return 'noPortfolioBackground';
        }
 
    }
    
   /**
    * Method retrieveSplashScreens(String brandName)
    * @param brandName: param of type String, name of the brand
    * @return urls: returns urls of each splashscreen depending of the brand
    */
    public String getSplashScreens() {
        System.debug('getSplashScreens --> BrandId = ' + brandId);
        List<ESN_MB_Entry__c> newsCoversUrls = retrieveSplashScreens(brandName);
        return JSON.serialize(newsCoversUrls);
    }
    @TestVisible private static List<ESN_MB_Entry__c> retrieveSplashScreens(String brandName) {
        List<ESN_MB_Entry__c> listEntryArticle = new List<ESN_MB_Entry__c>();
        listEntryArticle = [Select ESN_MB_Article__c, ESN_MB_Article__r.ESN_MB_Abstract__c 
                from ESN_MB_Entry__c
                where ESN_MB_Article__r.ESN_MB_Node_Page__r.Name = :brandName
                and ESN_MB_Rubric__r.Name = 'News Cover'
                and ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c = true
                and ESN_MB_Article__r.ESN_MB_Stage__c = 'Published'
                and ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c = true
                order by ESN_MB_Article__r.LastModifiedDate desc Limit 3];
                
        List<ESN_MB_Article__c> listArticle = new List<ESN_MB_Article__c>();
        for(ESN_MB_Entry__c entryTmp:listEntryArticle){
            ESN_MB_Article__c articleTmp = new ESN_MB_Article__c();
            articleTmp.Id = entryTmp.ESN_MB_Article__r.Id;
            listArticle.add(articleTmp);
        }
        System.debug('getSplashScreens > listArticle.size()=' + listArticle.size());

        List<ESN_MB_Entry__c> listUrls = [Select ESN_MB_Article__c, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Abstract__c, ESN_MB_Asset__c,
                                          ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_URL_bamAssetPreview__c,ESN_MB_Asset__r.ESN_MB_DocumentId__c
                from ESN_MB_Entry__c
                where ESN_MB_RoleAsset__c = 'MainAsset'
                and ESN_MB_Article__c in :listArticle order by ESN_MB_Article__r.LastModifiedDate desc];
        return listUrls;
    }
    

    /**
    * Method retrieveRubricList(String brandName)
    * @param brandName: param of type String, name of the brand to set as brandscope of the products
    * @return productRubricList: returns the rubrics available for the selected product depending on user permission set
    * 
    */
    public String getRubricList(){
        List<ESN_MB_NodePage__c> retrievedRubricList = retrieveRubricList(brandName);
        return JSON.serialize(retrievedRubricList);
    }
    @TestVisible private static List<ESN_MB_NodePage__c> retrieveRubricList(String brandName) {
        List<ESN_MB_NodePage__c> rubricsList= new List<ESN_MB_NodePage__c>();
        List<ESN_MB_NodePage__c> articlesList= new List<ESN_MB_NodePage__c>();
        List<ESN_MB_NodePage__c> activationsList= new List<ESN_MB_NodePage__c>();

        String currentBrandId = [select id from ESN_MB_NodePage__c 
                       Where RecordType.DeveloperName = 'ESN_MB_Brand' 
                       and name = :brandName limit 1].Id;   

//        boolean addRubrics = ESN_MB_UtilsUser.isBroadCasterUser();
        boolean addRubrics = isBroadCasterAssigned(currentBrandId);
        System.debug('addRubrics=' + addRubrics);
        // Retrieve all the rubrics for sections "Strategy", "Guidelines", "History & Education" and "Assets"
        // The first 3 ones are retrieved depending on articles content and user PS, assets rubrics are always added
        articlesList = prepareListRubricsArticle(brandName, addRubrics, currentBrandId);
        // Retrieve all the activations rubrics
        activationsList = prepareListRubricsActivation(brandName, addRubrics, currentBrandId);
        
        rubricsList.addAll(articlesList);
        rubricsList.addAll(activationsList);
        return rubricsList;
    }    
    
   /**
    * Method prepareListRubricsArticle((String brandscope, boolean removeEmptyRubrics, boolean addAllRubrics)
    * @param brandscope: name of the brand parent of the products
    * @param addRubrics: boolean used to know if user is broadcaster
    * @return rubricAddList: list of the rubrics depending on user persmission set (booleans above)
    */ 
    public static List<ESN_MB_NodePage__c> prepareListRubricsArticle(String brandscope, boolean addRubrics, String currentBrandId) {
        // Get the record type id of "articles to rubrics" entries
        String articlesToRubricRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Articles_To_Rubrics');
        List<ESN_MB_Entry__c> rubricArticleList = new List<ESN_MB_Entry__c>();
        List<ESN_MB_Entry__c> rubricArticleAlsoInMasterbrandList = new List<ESN_MB_Entry__c>();
        List<ESN_MB_NodePage__c> rubricAssetList = new List<ESN_MB_NodePage__c>();
        List<ESN_MB_NodePage__c> allRubricList = new List<ESN_MB_NodePage__c>();
        List<ESN_MB_NodePage__c> rubricAddList = new List<ESN_MB_NodePage__c>();
        Set<String> rubricSet = new Set<String>();
        ESN_MB_NodePage__c rubricAdd;
        String rubricForProduct = '';
        //We retrieve the article ids linked to the given Brand Scope
        List<ESN_MB_Entry__c> listEntryArticleByBrand = [Select ESN_MB_Article__c, ESN_MB_Node_Page__c
                                                            From ESN_MB_Entry__c
                                                            Where RecordType.DeveloperName='Articles_To_Products'
                                                            And ESN_MB_Node_Page__r.ESN_MB_Brand_Scope__c=:brandscope];
        //We build a map using article ids as keys and matching for each article the product ids it is attached to
        Map<String, List<String>> mapArticleProducts = new Map<String, List<String>>();
        for(ESN_MB_Entry__c entryTmp:listEntryArticleByBrand){
            List<String> listProductsTmp = mapArticleProducts.get(entryTmp.ESN_MB_Article__c);
            if(listProductsTmp == null){
                listProductsTmp = new List<String>();
                mapArticleProducts.put(entryTmp.ESN_MB_Article__c, listProductsTmp);
            }
            listProductsTmp.add(entryTmp.ESN_MB_Node_Page__c);
        }
        
        
        // If boolean is true, user type is basic user, only rubrics with articles are added
        if(!addRubrics) {
            // Check the rubrics with articles for the brand
            rubricArticleList = [Select ESN_MB_Rubric__r.Id, ESN_MB_Rubric__r.Name, 
                                 ESN_MB_Rubric__r.ESN_MB_Abstract__c, ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Article__r.ESN_MB_Node_Page__c, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,
                                 ESN_MB_Rubric__r.ESN_MB_CssClassName__c
                                 from ESN_MB_Entry__c 
                                 where ESN_MB_Article__r.Id in :mapArticleProducts.keySet()
                                 and ESN_MB_Rubric__r.Name != null
                                 and ESN_MB_Article__r.ESN_MB_Stage__c = 'Published'
                                 and recordTypeId = :articlesToRubricRTId
                                 order by ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_Order__c, ESN_MB_Article__r.ESN_MB_Node_Page__c];

            for(ESN_MB_Entry__c rubricEntryTmp : rubricArticleList) {
                System.debug('Rubric : ' + rubricEntryTmp.ESN_MB_Rubric__r.Name + ' --- Article : ' + rubricEntryTmp.ESN_MB_Article__r.Name + ' -- Product : ' + rubricEntryTmp.ESN_MB_Article__r.ESN_MB_Node_Page__c);
            }
            
            System.debug('rubricArticleList.size()=' + rubricArticleList.size());
            // Check each rubric and product, add them to the returning list if they weren't added,
            for(ESN_MB_Entry__c entryTmp : rubricArticleList) {
                List<String> listProductForThisArticle = mapArticleProducts.get(entryTmp.ESN_MB_Article__r.id);
                for(String idProduct:listProductForThisArticle){
                    rubricForProduct = entryTmp.ESN_MB_Rubric__r.Name + idProduct;
                    System.debug('rubricForProduct: ' + rubricForProduct );
                    System.debug('rubricSet: ' + rubricSet);
                    System.debug('news cover rubric id: ' + ESN_MB_Utils.cs_NewsCoverRubricId());
                    if(!rubricSet.contains(rubricForProduct) && !ESN_MB_Utils.cs_NewsCoverRubricId().equals(entryTmp.ESN_MB_Rubric__r.Id)) {
                        rubricSet.add(rubricForProduct);
                        rubricAdd = new ESN_MB_NodePage__c();
                        rubricAdd.Id = entryTmp.ESN_MB_Rubric__r.Id;
                        rubricAdd.Name = entryTmp.ESN_MB_Rubric__r.Name;
                        rubricAdd.ESN_MB_Abstract__c = entryTmp.ESN_MB_Rubric__r.ESN_MB_Abstract__c;
                        rubricAdd.ESN_MB_CssClassName__c = entryTmp.ESN_MB_Rubric__r.ESN_MB_CssClassName__c;
                        rubricAdd.ESN_MB_Section__c = entryTmp.ESN_MB_Rubric__r.ESN_MB_Section__c;
                        rubricAdd.ESN_MB_ParentId__c = idProduct;
                        rubricAddList.add(rubricAdd);
                    }
                }
            }
            
            /*
             SCH 18/06/2015 Asset rubrics are not displayed anymore in MyBrands. The "Assets" section now directly redirects the user to the DAM.
            // Retrieve the assets rubrics and add them to the list
            List<ESN_MB_Entry__c> rubricEntriesForThisBrand = [Select ESN_MB_Rubric__r.Id, ESN_MB_Rubric__r.Name, ESN_MB_Rubric__r.ESN_MB_Abstract__c,
                                                               ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_ParentId__c,ESN_MB_Rubric__r.ESN_MB_CssClassName__c
                                                               From ESN_MB_Entry__c 
                                                               WHERE ESN_MB_Node_Page__c=:currentBrandId
                                                               And ESN_MB_Rubric__r.ESN_MB_Section__c = 'Assets'
                                                               And ESN_MB_Rubric__c != NULL
                                                               Order by ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_Order__c];
            
            
            System.debug('allRubricList.size()=' + allRubricList.size());
            for(ESN_MB_Entry__c e : rubricEntriesForThisBrand) {
                ESN_MB_NodePage__c rubricTmp = e.ESN_MB_Rubric__r;
                rubricAddList.add(rubricTmp);
            }         
            */

        //Else, user is Broadcaster, all rubrics are added but the 'Brand Activations Library' one
        }else if(addRubrics){
            //Let's retrieve "rubric entries" for this brand
            List<ESN_MB_Entry__c> rubricEntriesForThisBrand = [Select ESN_MB_Rubric__r.Id, ESN_MB_Rubric__r.Name, ESN_MB_Rubric__r.ESN_MB_Abstract__c,
                                                               ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_ParentId__c,ESN_MB_Rubric__r.ESN_MB_CssClassName__c
                                                               From ESN_MB_Entry__c 
                                                               WHERE ESN_MB_Node_Page__c=:currentBrandId
                                                               And ESN_MB_Rubric__r.ESN_MB_Section__c != 'Brand Activations Library'
															   And ESN_MB_Rubric__r.ESN_MB_Section__c != 'Business Activation Library'
                                                               //SCH 18/06/2015 Asset rubrics are not displayed anymore in MyBrands. The "Assets" section now directly redirects the user to the DAM.
                                                               And ESN_MB_Rubric__r.ESN_MB_Section__c != 'Assets'
                                                               And ESN_MB_Rubric__c != NULL
                                                               Order by ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_Order__c];
            
            
            System.debug('allRubricList.size()=' + allRubricList.size());
            for(ESN_MB_Entry__c e : rubricEntriesForThisBrand) {
                ESN_MB_NodePage__c rubricTmp = e.ESN_MB_Rubric__r;
                rubricAddList.add(rubricTmp);
            }
        }
        return rubricAddList;
    }
    
   /**
    * Method prepareListRubricsActivation(String brandscope, boolean removeEmptyRubrics, boolean addAllRubrics)
    * @param brandscope: name of the brand parent of the products
    * @param addAllRubrics: boolean used to know if user is broadcaster
    * @return rubricAddList: list of the rubrics depending on user persmission set (booleans above)
    */ 
    public static List<ESN_MB_NodePage__c> prepareListRubricsActivation(String brandscope, boolean addRubrics, String currentBrandId) {
        List<ESN_MB_Activation__c> rubricActivationList= new List<ESN_MB_Activation__c>();
        List<ESN_MB_Activation__c> rubricActivationAlsoInMasterbrandList = new List<ESN_MB_Activation__c>();
        List<ESN_MB_NodePage__c> allActivationList= new List<ESN_MB_NodePage__c>();
        List<ESN_MB_NodePage__c> activationAddList= new List<ESN_MB_NodePage__c>();
        set<String> activationSet = new set<String>();
        ESN_MB_NodePage__c activationAdd;
        String rubricForProduct = '';
        String rubricAbstract = '';
        String brandActivationSection = 'Brand Activations Library';

		ESN_MB_NodePage__c brand = [SELECT Name FROM ESN_MB_NodePage__c WHERE Id=:currentBrandId LIMIT 1];        
        if(brand.Name.equals('Pernod_Ricard')) {
			brandActivationSection = 'Business Activation Library';
			addRubrics = true;
        }

        // If boolean is true, user type is basic user, only rubrics with activations are added
        if(!addRubrics) {
			allActivationList= [Select Id, Name, ESN_MB_Abstract__c, 
                            ESN_MB_Section__c, ESN_MB_ParentId__c, ESN_MB_CssClassName__c
                            from ESN_MB_NodePage__c 
                            where RecordType.DeveloperName = 'ESN_MB_Rubric'
                            and ESN_MB_Section__c = :brandActivationSection 
                            order by ESN_MB_Order__c];
			System.debug('allActivationList.size()=' + allActivationList.size());
            
			// Get the brand masterbrand Id
            String brandMasterbrandId = [Select Id
                                         From ESN_MB_Nodepage__c
                                         Where ESN_MB_IsMasterbrand__c = true
                                         And recordType.DeveloperName = 'ESN_MB_Product'
                                         And ESN_MB_Brand_Scope__c = :brandscope].Id;
            
            rubricActivationList= [Select ESN_MB_Activation_Type__c, ESN_MB_Product__c, ESN_MB_Product__r.Name, ESN_MB_AlsoInMasterbrand__c
                                   from ESN_MB_Activation__c 
                                   where ESN_MB_Product__r.ESN_MB_Brand_Scope__c = :brandscope 
                                   and recordType.Developername = 'ESN_MB_Brand_Activation'
                                   and ESN_MB_Stage__c = 'Published'];
            
            for(ESN_MB_Activation__c activationTmp : rubricActivationList) {
                if(activationTmp.ESN_MB_AlsoInMasterbrand__c == true) {
                    ESN_MB_Activation__c activationAlsoInMasterbrand = activationTmp.clone();
                    activationAlsoInMasterbrand.ESN_MB_Product__c = brandMasterbrandId;
                    rubricActivationAlsoInMasterbrandList.add(activationAlsoInMasterbrand);
                }
            }
            rubricActivationList.addAll(rubricActivationAlsoInMasterbrandList);
            
            System.debug('rubricActivationList.size()=' + rubricActivationList.size());
            for(ESN_MB_NodePage__c a : allActivationList) {
                for(ESN_MB_Activation__c e : rubricActivationList) {
                    String[] activationTypeTab = e.ESN_MB_Activation_Type__c.split(';');
                    for(String s : activationTypeTab) {
                        rubricForProduct = s + e.ESN_MB_Product__c;
                        if(!activationSet.contains(rubricForProduct) && s == a.Name) {
                            activationSet.add(rubricForProduct);
                            System.debug('RUBRIC >>>>> ' + s + ' <<<<<' + ' ----- Product >>>>> ' + e.ESN_MB_Product__r.Name + ' <<<<<');
                            activationAdd = new ESN_MB_NodePage__c();
                            activationAdd.Name = s;
                            activationAdd.Id = a.Id;
                            activationAdd.ESN_MB_Abstract__c = a.ESN_MB_Abstract__c;
                            activationAdd.ESN_MB_Section__c = brandActivationSection;
                            activationAdd.ESN_MB_ParentId__c = e.ESN_MB_Product__c;
                            activationAdd.ESN_MB_CssClassName__c = a.ESN_MB_CssClassName__c;
                            System.debug('Activation add = ' + activationAdd);
                            activationAddList.add(activationAdd);
                        }
                    }
                }
            }               
        //Else, user is Broadcaster, all rubrics are added
        }else if(addRubrics) {
            //Let's retrieve "rubric entries" for this brand
            List<ESN_MB_Entry__c> rubricEntriesForThisBrand = [Select ESN_MB_Rubric__r.Id, ESN_MB_Rubric__r.Name, ESN_MB_Rubric__r.ESN_MB_Abstract__c,
                                                               ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_ParentId__c,ESN_MB_Rubric__r.ESN_MB_CssClassName__c
                                                               From ESN_MB_Entry__c 
                                                               WHERE ESN_MB_Node_Page__c=:currentBrandId
                                                               And ESN_MB_Rubric__r.ESN_MB_Section__c = :brandActivationSection
                                                               And ESN_MB_Rubric__c != NULL
                                                               Order by ESN_MB_Rubric__r.ESN_MB_Section__c, ESN_MB_Rubric__r.ESN_MB_Order__c];
            
            
            
            for(ESN_MB_Entry__c e : rubricEntriesForThisBrand) {
                ESN_MB_NodePage__c rubricTmp = e.ESN_MB_Rubric__r;
                
                activationAddList.add(rubricTmp);
            }
           
        }
        return activationAddList;
    }
    
    /**
    * Method retrieveGlobalActivation 

    * @return globalActivation: returns the rubric global activation platforms
    */ 
    public static ESN_MB_NodePage__c retrieveGlobalActivation() {
        ESN_MB_NodePage__c result = null;List<ESN_MB_NodePage__c> listResult = [Select Name, ESN_MB_Abstract__c, ESN_MB_Section__c, ESN_MB_ParentId__c from ESN_MB_NodePage__c where Id = :ESN_MB_Utils.cs_360ActivationPlatformRubricId()];
        if(listResult.size() > 0){result = listResult[0];}return result;   
    }
        
    /**
    * Method retrieveRubricArticles(String productId, String rubricName)
    * @param productId: param of type String, id of the product to get the articles from
    * @param rubricName: param of type String, name of the rubric clicked on
    * @return articlesList
    */
    @RemoteAction
    global static List<ESN_MB_NOP_Article_DTO> retrieveRubricArticles(String productId, String rubricId, String brandId) {
        // Get the brand masterbrand
        String brandMasterbrandId = [Select Id
                                     From ESN_MB_Nodepage__c
                                     Where ESN_MB_IsMasterbrand__c = true
                                     And ESN_MB_ParentId__c = :brandId].Id;
        System.debug('masterbrand Id : ' + brandMasterbrandId);
        System.debug('retrieveRubricArticles parameters = ' + productId + ' - ' + rubricId + ' - ' + brandId);
        List<ESN_MB_Entry__c> articleEntryList = null;
        
        
        //We retrieve the article ids linked to the given product Id
        List<ESN_MB_Entry__c> listEntryArticleByProduct = [Select ESN_MB_Article__c from ESN_MB_Entry__c
                                                        Where RecordType.DeveloperName = 'Articles_To_Products'
                                                        And ESN_MB_Node_Page__c  = :productId];
        List<String> listArticleByProduct = new List<String>();
        for(ESN_MB_Entry__c entryTmp:listEntryArticleByProduct){
            listArticleByProduct.add(entryTmp.ESN_MB_Article__c);
        }

        
        // If the user is broadcaster then we add all articles, even archived and drafts
        if (isBroadCasterAssigned(brandId)) {
            System.debug('######### Entering the big If condition');
            //If the rubric prompted is NewsCover, we also add articles linked to the brand (news covers)
            if(ESN_MB_Utils.cs_NewsCoverRubricId() == rubricId){ 
                articleEntryList = [select ESN_MB_Article__c, ESN_MB_Article__r.Id, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Abstract__c,
                                    ESN_MB_Article__r.ESN_MB_Top_Text__c, ESN_MB_Article__r.ESN_MB_Bottom_Text__c, ESN_MB_Article__r.ESN_MB_Stage__c,
                                    ESN_MB_Article__r.CreatedDate, ESN_MB_Article__r.CreatedById, ESN_MB_Article__r.ESN_MB_Embedded_Video__c,ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c,ESN_MB_Article__r.LastModifiedDate,
                                    ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c, ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c
                                    from ESN_MB_Entry__c
                                    where (ESN_MB_Article__r.Id in :listArticleByProduct OR ESN_MB_Article__r.ESN_MB_Node_Page__c=:brandId)
                                    and ESN_MB_Article__r.ESN_MB_Stage__c != 'Draft'
                                    and ESN_MB_Rubric__r.Id = :rubricId
                                    order by ESN_MB_Article__r.LastModifiedDate desc];
                
            } else {
                //Otherwise, just articles linked to the product for the rubric
                articleEntryList = [select ESN_MB_Article__c, ESN_MB_Article__r.Id, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Abstract__c,
                                    ESN_MB_Article__r.ESN_MB_Top_Text__c, ESN_MB_Article__r.ESN_MB_Bottom_Text__c, ESN_MB_Article__r.ESN_MB_Stage__c,
                                    ESN_MB_Article__r.CreatedDate, ESN_MB_Article__r.CreatedById, ESN_MB_Article__r.ESN_MB_Embedded_Video__c,ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c,ESN_MB_Article__r.LastModifiedDate,
                                    ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c, ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c
                                    from ESN_MB_Entry__c 
                                    where ESN_MB_Article__r.Id in :listArticleByProduct
                                    and ESN_MB_Article__r.ESN_MB_Stage__c != 'Draft'
                                    and ESN_MB_Rubric__r.Id = :rubricId
                                    order by ESN_MB_Article__r.LastModifiedDate desc];
            }
        } else {
            
            // Else, the user is a basic user, we add the articles linked to the product for the rubric that are published and the published newscover
            if(ESN_MB_Utils.cs_NewsCoverRubricId() == rubricId){ 
                articleEntryList = [select ESN_MB_Article__c, ESN_MB_Article__r.Id, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Abstract__c,
                                    ESN_MB_Article__r.ESN_MB_Top_Text__c, ESN_MB_Article__r.ESN_MB_Bottom_Text__c, ESN_MB_Article__r.ESN_MB_Stage__c,
                                    ESN_MB_Article__r.CreatedDate, ESN_MB_Article__r.CreatedById, ESN_MB_Article__r.ESN_MB_Embedded_Video__c,ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c,ESN_MB_Article__r.LastModifiedDate,
                                    ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c, ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c
                                    from ESN_MB_Entry__c
                                    where (ESN_MB_Article__r.Id in :listArticleByProduct OR ESN_MB_Article__r.ESN_MB_Node_Page__c=:brandId)
                                    and ESN_MB_Rubric__r.Id = :rubricId
                                    and ESN_MB_Article__r.ESN_MB_Stage__c = 'Published'
                                    order by ESN_MB_Article__r.LastModifiedDate desc];
                
            } else {
                articleEntryList = [select ESN_MB_Article__c, 
                                    ESN_MB_Article__r.Id, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Abstract__c,
                                    ESN_MB_Article__r.ESN_MB_Top_Text__c, ESN_MB_Article__r.ESN_MB_Bottom_Text__c, ESN_MB_Article__r.ESN_MB_Stage__c,
                                    ESN_MB_Article__r.CreatedDate, ESN_MB_Article__r.CreatedById, ESN_MB_Article__r.ESN_MB_Embedded_Video__c,ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c,ESN_MB_Article__r.LastModifiedDate,
                                    ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c, ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c
                                    from ESN_MB_Entry__c 
                                    where ESN_MB_Article__r.Id in :listArticleByProduct 
                                    and ESN_MB_Rubric__r.Id = :rubricId
                                    and ESN_MB_Article__r.ESN_MB_Stage__c = 'Published'
                                    order by ESN_MB_Article__r.LastModifiedDate desc];      
            }
        }
        System.debug('articleEntryList.size='+ articleEntryList.size());

        List<Id> articleIdList = new List<Id>();
        for(ESN_MB_Entry__c entryTmp:articleEntryList){
            articleIdList.add(entryTmp.ESN_MB_Article__r.Id);
        }
        
        List<ESN_MB_Entry__c> assetEntryList = [Select ESN_MB_Article__c, 
                                                ESN_MB_Article__r.Id, ESN_MB_Asset__c, ESN_MB_Asset__r.Name,
                                                ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_description__c,
                                                ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_prettySize__c,ESN_MB_Asset__r.ESN_MB_Size__c,
                                                ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c,
                                                ESN_MB_Node_Page__r.Id, RecordType.DeveloperName
                                                From ESN_MB_Entry__c
                                                Where ESN_MB_Article__r.Id in :articleIdList
                                                And ESN_MB_Asset__c<>null];
        
        List<ESN_MB_NOP_Article_DTO> listArticleDTO = new List <ESN_MB_NOP_Article_DTO>();
        
        for(ESN_MB_Entry__c articleEntryTmp:articleEntryList){
            ESN_MB_NOP_Article_DTO articleDTO = ESN_MB_NOP_Article_Cx.prepareDTOFromArticle(articleEntryTmp.ESN_MB_Article__r, assetEntryList);

            listArticleDTO.add(articleDTO);
        }

        System.debug('articleDTO.listAsset='+ listArticleDTO);
        
        return listArticleDTO;
    }
    
    /*Method findUltimateParentCreatedDate is used to find the last parent of an article
    in order to find the created date
    */
    @TestVisible
    private static Datetime findUltimateParentCreatedDate(String articleId){
        DateTime ultimateCreatedDate;
        Boolean ultimateParentFound = false;
        
        // We loop until we find the ultimate parent
        While(ultimateParentFound == false){
            // We are looking for the ultimate parent 5 by 5 in order to limit call to SOQL
            ESN_MB_Article__c ultimateParentArticle = [ Select CreatedDate, 
                                                        ESN_MB_ParentArticle__r.CreatedDate,
                                                        ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate,
                                                        ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate,
                                                        ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate,
                                                        ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate,
                                                       ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__c
                                                        from ESN_MB_Article__c 
                                                        where ESN_MB_Article__c.Id = :articleId];
            
            // If the parentArticle is null it's mean is the ultimate parent
            if(ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate == null){
                if(ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate != null){
                    ultimateCreatedDate = ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate;
                    ultimateParentFound = true;
                }else{
                    if(ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate != null){
                        ultimateCreatedDate = ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate;
                        ultimateParentFound = true;
                    }else{
                         if(ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate != null){
                            ultimateCreatedDate = ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.CreatedDate;
                            ultimateParentFound = true;
                         }else{
                             if(ultimateParentArticle.ESN_MB_ParentArticle__r.CreatedDate != null){
                                ultimateCreatedDate = ultimateParentArticle.ESN_MB_ParentArticle__r.CreatedDate;
                                ultimateParentFound = true;
                             }else{
                                 if(ultimateParentArticle.CreatedDate != null){
                                    ultimateCreatedDate = ultimateParentArticle.CreatedDate;
                                    ultimateParentFound = true;
                                }  
                             }
                         }
                    }  
             }
           }else{
                 articleId = ultimateParentArticle.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__r.ESN_MB_ParentArticle__c;                
            }
        }
        return ultimateCreatedDate;
    }
    

    @RemoteAction
    global static ESN_MB_NOP_Article_DTO retrieveArticle(String articleId) {
        System.debug('retrieveArticle param =' + articleId);
        Datetime ultimateCreatedDate = findUltimateParentCreatedDate(articleId);
        List<ESN_MB_Entry__c> assetEntryList = [Select ESN_MB_Article__c, 
                                                ESN_MB_Article__r.Id, ESN_MB_Article__r.Name, ESN_MB_Article__r.ESN_MB_Abstract__c,
                                                ESN_MB_Article__r.ESN_MB_Top_Text__c, ESN_MB_Article__r.ESN_MB_Bottom_Text__c, ESN_MB_Article__r.ESN_MB_Stage__c,
                                                ESN_MB_Article__r.ESN_MB_Embedded_Video__c,ESN_MB_Article__r.ESN_MB_LinkRelatedAssets__c, ESN_MB_Article__r.CreatedDate, ESN_MB_Article__r.CreatedById,
                                                ESN_MB_Asset__c, ESN_MB_Asset__r.Name,ESN_MB_Article__r.LastModifiedDate,
                                                ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_description__c,
                                                ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_Size__c, ESN_MB_Asset__r.ESN_MB_prettySize__c,
                                                ESN_MB_Article__r.OwnerId, ESN_MB_Article__r.ESN_MB_AlsoInMasterbrand__c,ESN_MB_Article__r.ESN_MB_Apply_To_All_Products__c, ESN_MB_Article__r.ESN_MB_FlagSplashScreen__c,
                                                ESN_MB_Node_Page__r.Id, RecordType.DeveloperName
                                                From ESN_MB_Entry__c
                                                Where ESN_MB_Article__r.Id = :articleId];
        System.debug('assetEntryList.size() = ' + assetEntryList.size());
        ESN_MB_NOP_Article_DTO articleDTO = null;
        if(assetEntryList.size()>0){
            articleDTO = ESN_MB_NOP_Article_Cx.prepareDTOFromArticle(assetEntryList[0].ESN_MB_Article__r, assetEntryList );
            System.debug('create Date DTO =' + ultimateCreatedDate);
            articleDTO.createdDate = ultimateCreatedDate;
        }
        System.debug('Output articleDTO HOMEPAGE = ' + articleDTO);
        return articleDTO;
    }
   

    
   /**
    * Method retrieveAllAssets()
    * @return assetList: returns the list of all the assets
    */ 
    @remoteAction 
    global static List<ESN_MB_Asset__c> retrieveAllAssets() {
        List<ESN_MB_Asset__c> assetList = [select Name, ESN_MB_fileName__c, 
                                           ESN_MB_mimeType__c, ESN_MB_size__c, ESN_MB_prettySize__c, ESN_MB_description__c,
                                           ESN_MB_Taxonomy__c, ESN_MB_URL_thumbnail__c, ESN_MB_URL_imagePreview__c,
                                           ESN_MB_originalFile_extension__c, ESN_MB_URL_originalFile__c, CreatedDate, LastModifiedDate
                                           from ESN_MB_Asset__c 
                                           Where recordType.Developername='ESN_MB_DAM_Asset' 
                                           order by Name];

        return assetList;
    }
    
    /**
    * Method retrieveAssets(String assetFilter)
    * @param assetFilter: string param containing the filter to select the asset
    * @return assetList: returns the list of all the assets with this filter
    */ 
    @remoteAction 
    global static List<ESN_MB_Asset__c> retrieveAssetsByFilter(String assetFilter) {
        List<ESN_MB_Asset__c> assetList = [select Name, ESN_MB_fileName__c, 
                                           ESN_MB_mimeType__c, ESN_MB_size__c, ESN_MB_prettySize__c, ESN_MB_description__c,
                                           ESN_MB_Taxonomy__c, ESN_MB_URL_thumbnail__c, ESN_MB_URL_imagePreview__c,
                                           ESN_MB_originalFile_extension__c, ESN_MB_URL_originalFile__c, CreatedDate, LastModifiedDate
                                           from ESN_MB_Asset__c 
                                           Where recordType.Developername='ESN_MB_DAM_Asset' 
                                           //And    ESN_MB_Taxonomy_AssetType__c Like :assetFilter
                                           order by Name];
        return assetList;
    }
    
    public String getBrand() {
        System.debug('Entree dans getBrand. On cherche l\'id de la brand ' + brandId);
        String brandName = '';
        List<ESN_MB_NodePage__c> brandList = retrieveBrandNames();
        for(ESN_MB_NodePage__c nodeTmp:brandList){
            if(nodeTmp.id == brandId){
                brandName = nodeTmp.Name;
                break;
            }
        }
        return brandName;
    } 
    
    public String getCategory() {
        String brandCategory = '';
        List<ESN_MB_NodePage__c> brandList = retrieveBrandNames();
        for(ESN_MB_NodePage__c nodeTmp:brandList){
            if(nodeTmp.id == brandId){
                brandCategory = nodeTmp.ESN_MB_Brand_Category__c;
                break;
            }
        }
        return brandCategory;
    }
    
    public String getNPUrl(){ return ESN_MB_Utils.cs_NP_URL();}
    public String getPOSUrl(){ return ESN_MB_Utils.cs_POS_URL();}
    
    public String getCurrentBrandStaticResource() { 
        String bName = reformatBrandName(brandName);
        return '$Resource.ESN_MB_Theme_'+ bName;
    }
    
    /* ALN 13/10/14 - Fix for uncommon brand names with '.úë- */
    private String reformatBrandName(String brandNameParam){
        return brandNameParam.replaceAll('[\\W]+', '');
    }
    
    // Pass the resource name
    public String getcurrentBrandCssURL(){

        String bName = reformatBrandName(brandName);
        String resourceName = 'ESN_MB_Theme_' + bName;
        System.debug(':::: ResourceName :::: ' + resourceName);
        
        // Fetching the resource
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
        
        
        // Checking if the result is returned or not
        if(resourceList.size() == 1){
            
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            // Resource URL
            String url = '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
            return url;
        }
        else {
            return '';   
        }
    }
    
    public String getBrandResourceName(){return '$Resource.ESN_MB_BrandNOP_Images';}

    /**
    * Method retrieveParentProductId()
    * @param childId: String param containing the id of the child to get the parent product id from
    * @param childType: String param containing the type of the child to get the parent product id from
    * @return parentProductId: returns the id of the parent product
    */ 
    @remoteAction 
    global static String retrieveParentProductId(String childId, String childType) {
        String parentProductId;
        if(childType == 'article') {
            parentProductId = [Select ESN_MB_Node_Page__c 
                               from ESN_MB_Article__c 
                               where Id = :childId].ESN_MB_Node_Page__c;
        }else if(childType == 'activation') {
            parentProductId = [Select ESN_MB_Product__c 
                               from ESN_MB_Activation__c 
                               where Id = :childId]. ESN_MB_Product__c;
        }
        return parentProductId;
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
    
    /**
    * Method getBreadCrumbValues()
    * @param screen, indicates on which page the user is
    * @param contentId, indicates the id of content (article, activation)
    * @param contentId2, indicates product related to the screen (List of articles)
    * 
    * @return a JSON preformated for the breadcumb
    */ 
    @RemoteAction 
    global static String getBreadCrumbValues(String screen, String contentId, String contentId2) {
        String jGen='{"Breadcrumb":"Values"';
         If (screen== 'Article') {
            ESN_MB_Entry__c cArticle = [SELECT ESN_MB_Article__r.ESN_MB_Node_Page__c, ESN_MB_Article__r.ESN_MB_Node_Page__r.name, ESN_MB_Article__r.name,ESN_MB_Article__r.id,ESN_MB_Rubric__r.name,ESN_MB_Rubric__r.id,ESN_MB_Rubric__r.ESN_MB_Section__c FROM ESN_MB_Entry__c where ESN_MB_Article__r.id=:contentId and recordType.name='Articles To Rubrics' LIMIT 1];
            jGen+=',"Product":"'+ cArticle.ESN_MB_Article__r.ESN_MB_Node_Page__r.name +'"';jGen+=',"ProductId":"'+ cArticle.ESN_MB_Article__r.ESN_MB_Node_Page__c +'"';jGen+=',"Section":"'+ cArticle.ESN_MB_Rubric__r.ESN_MB_Section__c + '"';
            jGen+=',"Rubric":"'+ cArticle.ESN_MB_Rubric__r.name + '"';jGen+=',"RubricId":"'+ cArticle.ESN_MB_Rubric__r.id + '"';jGen+=',"Name":"'+ cArticle.ESN_MB_Article__r.name + '"';jGen+=',"id":"'+ cArticle.ESN_MB_Article__r.id + '"';
        } else {
             if (screen=='forum') {
                ESN_MB_NodePage__c cNOP = [SELECT ESN_MB_ChatterGroup_Id__c FROM ESN_MB_NodePage__c where id=:contentId LIMIT 1];
                jGen+=',"GroupId":"'+ cNOP.ESN_MB_ChatterGroup_Id__c +'"'; 
             }
            else {
                if (screen=='Influencers' || screen=='accueil-global-activations' || screen=='all_assets') {
                    for (ESN_MB_NodePage__c cNOP : [SELECT id, name, ESN_MB_Section__c, RecordType.Name from ESN_MB_NodePage__c where id=:contentId or id=:contentId2 LIMIT 2]) {
                        if (cNOP.RecordType.Name=='Rubric') {
                            jGen+=',"Section":"'+ cNOP.ESN_MB_Section__c + '"';
                            jGen+=',"Rubric":"'+ cNOP.name + '"';
                            jGen+=',"RubricId":"'+ cNOP.id + '"';
                            jGen+=',"Name":"'+ cNOP.name + '"'; 
                            jGen+=',"id":"'+ cNOP.id + '"';
                        }
                        else {
                            if (cNOP.RecordType.Name=='Product') {
                                jGen+=',"Product":"'+ cNOP.Name +'"';
                                jGen+=',"ProductId":"'+ cNOP.id +'"';
                            }
                        }
                    }
                }
                else { 
                    if (screen=='article-global-activation' || screen=='article-local-activation') {
                         ESN_MB_Activation__c cActivation = [SELECT id,name,ESN_MB_Product__r.name,ESN_MB_Product__r.id  FROM ESN_MB_Activation__c  where id=:contentId LIMIT 1];
                        jGen+=',"Product":"'+ cActivation.ESN_MB_Product__r.name +'"';jGen+=',"ProductId":"'+ cActivation.ESN_MB_Product__r.id +'"';
                        String listName = (screen=='article-global-activation') ? Label.ESN_MB_Toolkits_Library :  Label.ESN_MB_Market_Activations;
                        jGen+=',"ActList":"'+ listName +'"';jGen+=',"Name":"'+ cActivation.name + '"';jGen+=',"id":"'+ cActivation.id + '"';
                    } 
                   
                }
            }
          }
        return jGen+'}';
    }
    
    /**
    * Method retrieveBrandSocialLinks(brandId)
    * @param brandId: id of the brand to get the social links from
    * @return brandSocialLinks: list containing the social links of the brand
    */
    @RemoteAction
    global static ESN_MB_NodePage__c retrieveBrandSocialLinks(String brandId) {
        ESN_MB_NodePage__c brandSocialLinks = [Select ESN_MB_Url_Facebook_Link__c, 
                                               ESN_MB_Url_Flickr_Link__c, ESN_MB_Url_GooglePlus_Link__c, 
                                               ESN_MB_Url_Twitter_Link__c, ESN_MB_Url_Youtube_Link__c, ESN_MB_Url_Instagram_Link__c, ESN_MB_Url_Pinterest_Link__c   
                                               From ESN_MB_NodePage__c 
                                               Where Id = :brandId
                                               Limit 1];
        return brandSocialLinks;
    }
    
    @RemoteAction 
    global static boolean getIsBroadCasterUser(){
        return ESN_MB_UtilsUser.isBroadCasterUser();
    }
    
    @RemoteAction 
    global static boolean isBroadCasterUser(){
        return ESN_MB_UtilsUser.isBroadCasterUser();
    }
    @RemoteAction 
    global static boolean isBroadCasterAssigned(String brandId){
        return ESN_MB_UtilsUser.isBroadCasterUser(brandId);
    }
    
    @RemoteAction 
    global static String getCategory(String brandId){
        ESN_MB_NodePage__c brand = [SELECT ESN_MB_Brand_Category__c FROM ESN_MB_NodePage__c WHERE ID = :brandId LIMIT 1];
        return brand.ESN_MB_Brand_Category__c;
    }
    
    public String getCurrentCategory() {
        String currentCategory= '';
        List<ESN_MB_NodePage__c> brandList = retrieveBrandNames();
        for(ESN_MB_NodePage__c nodeTmp:brandList){
            if(nodeTmp.id == brandId){
                currentCategory= nodeTmp.ESN_MB_Brand_Category__c;
                break;
            }
        }
        return currentCategory;
    } 

    @RemoteAction 
    global static String getLeCercleNewsId(){
        String ret = '';
        ESN_MB_NodePage__c[] nodePage = [SELECT Id FROM ESN_MB_NodePage__c WHERE RecordType.DeveloperName='ESN_MB_Rubric' AND ESN_MB_Section__c='News' LIMIT 1];
        if(nodePage.size() > 0) {
            ret = nodePage[0].Id;
        } else {
            ret = '';
        }
        return ret;
    }
    
    @RemoteAction 
    global static String getLeCercleProductId(){
        String ret = '';
        ESN_MB_NodePage__c[] nodePage = [SELECT Id FROM ESN_MB_NodePage__c WHERE RecordType.DeveloperName='ESN_MB_Product' AND Name='LeCercle MasterBrand' LIMIT 1];
        if(nodePage.size() > 0) {
            ret = nodePage[0].Id;
        } else {
            ret = '';
        }
        return ret;
    }
}