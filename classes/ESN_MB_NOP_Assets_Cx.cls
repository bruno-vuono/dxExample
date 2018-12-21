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

    Issues / TODOs
    --------------
    
*/
global class ESN_MB_NOP_Assets_Cx {
    global static String buildSOSLSearchString(String rawTaxonomy) {
        String result = '';
        if(!String.isEmpty(rawTaxonomy)){
            String [] listTaxo = rawTaxonomy.split(',');
            Boolean firstParam = true;
            for(String taxoTmp:listTaxo){
                if(firstParam){
                    result += '(';
                    firstParam = false;
                } else {
                    result += ' OR ';
                }
                result += '\"' + taxoTmp + '\"';
            }
            result += ')';
        }
        
        return result;
    }
    
    /**
    * Method retrieveAssets(String rubricId, String brandId)
    * @param rubricId: Id of the rubric the user clicked on (all assets / campaign.. etc)
    * @param brandId: Id of the current brand, to get only the related assets
    * @return assetList: returns the list of the assets
    */ 
    @remoteAction 
    global static List<List<Object>> retrieveAssets(String rubricId, String brandId, String productId) {
        
        String rubricTaxonomy = [Select ESN_MB_Default_Brand_Variant_Value__c From ESN_MB_NodePage__c 
                             Where Id = :rubricId 
                             limit 1].ESN_MB_Default_Brand_Variant_Value__c;
        String productTaxonomy = [Select ESN_MB_Default_Brand_Variant_Value__c 
                              From ESN_MB_NodePage__c 
                              Where Id = :productId 
                              limit 1].ESN_MB_Default_Brand_Variant_Value__c;
        String brandVariantValue = [Select ESN_MB_Default_Brand_Variant_Value__c 
                            From ESN_MB_NodePage__c 
                            Where Id = : brandId 
                            limit 1].ESN_MB_Default_Brand_Variant_Value__c;
        
		String brandDAMId = [Select ESN_MB_Brand_DAM_Id__c 
                            From ESN_MB_NodePage__c 
                            Where Id = : brandId 
                            limit 1].ESN_MB_Brand_DAM_Id__c;


        String brandVariantLike = '%' + brandVariantValue + '%';
        System.debug('Brand name like used in query : ' + brandVariantLike);
       

        
        Boolean SOQLPossible = true;
        Boolean isProductFiltered = false;
        Boolean isRubricFiltered = false;
        String productFilter = '';
        String rubricFilter = '';
        
        //If we need to do any filtering on products or rubrics
        if(!String.isEmpty(productTaxonomy)){
            //If we need to filter using ESN_MB_Taxonomy_BrandMaterials__c or ESN_MB_Taxonomy_AssetType__c,
            //then we can't use SOQL (they are Long Text Fields, and cannot be filtered using WHERE clause)
            SOQLPossible = false;
            isProductFiltered = true;
            productFilter = buildSOSLSearchString(productTaxonomy);
        }
        if(!String.isEmpty(rubricTaxonomy)){
            //If we need to filter using ESN_MB_Taxonomy_BrandMaterials__c or ESN_MB_Taxonomy_AssetType__c,
            //then we can't use SOQL (they are Long Text Fields, and cannot be filtered using WHERE clause)
            SOQLPossible = false;
            isRubricFiltered = true;
            rubricFilter = buildSOSLSearchString(rubricTaxonomy);
        }
        
        String searchValue = '';
        if(isProductFiltered && isRubricFiltered) {
            searchValue = productFilter + ' AND ' + rubricFilter;
        } else {
            if(isProductFiltered) {
                searchValue = productFilter;
            } else {
                searchValue = rubricFilter;
            }
        }
            
        System.debug('SEARCH VALUE HERE ----------> ' + searchValue + ' <----------');
        System.debug('brandVariantLike HERE ----------> ' + brandVariantLike + ' <----------');
        
        List<List<Object>> assetList;
        if(SOQLPossible){
            System.debug('SOQL is possible, we call it instead of SOSL');
            List<ESN_MB_Asset__c> soqlResults;
            
            soqlResults = [Select Id, Name, ESN_MB_fileName__c, ESN_MB_mimeType__c, ESN_MB_size__c, ESN_MB_prettySize__c, ESN_MB_description__c,ESN_MB_Storyboard_LargeURL__c,
                           ESN_MB_URL_thumbnail__c, ESN_MB_URL_imagePreview__c, CreatedDate, LastModifiedDate,ESN_MB_Storyboard_URL__c,ESN_MB_Storyboard_Slide_Count__c,
                           ESN_MB_originalFile_extension__c, ESN_MB_URL_originalFile__c, ESN_MB_DAMId__c,ESN_MB_URL_bamArticleFull__c, ESN_MB_URL_bamVideoPreview__c,
                           ESN_MB_TECH_description__c, ESN_MB_TECH_keywords__c
                           FROM ESN_MB_Asset__c
                           Where recordType.Developername='ESN_MB_DAM_Asset'
                           AND ESN_MB_Brand_Scope_Text__c Like :brandVariantLike
                           AND ESN_MB_Taxonomy_Brands__c = :brandDAMId
                           ORDER BY CreatedDate DESC];
            
            assetList = new List<List<Object>>();
            assetList.add(soqlResults);

        } else {
            assetList = [FIND :searchValue IN ALL FIELDS RETURNING
                         ESN_MB_Asset__c (Id, Name, ESN_MB_fileName__c, ESN_MB_mimeType__c, ESN_MB_size__c, ESN_MB_prettySize__c, ESN_MB_description__c,ESN_MB_Storyboard_LargeURL__c,
                                          ESN_MB_URL_thumbnail__c, ESN_MB_URL_imagePreview__c, CreatedDate, LastModifiedDate,ESN_MB_Storyboard_URL__c,ESN_MB_Storyboard_Slide_Count__c,
                                          ESN_MB_originalFile_extension__c, ESN_MB_URL_originalFile__c, ESN_MB_DAMId__c,ESN_MB_URL_bamArticleFull__c, ESN_MB_URL_bamVideoPreview__c,
                                          ESN_MB_TECH_description__c, ESN_MB_TECH_keywords__c
                                          Where recordType.Developername='ESN_MB_DAM_Asset'
                                          AND ESN_MB_Brand_Scope_Text__c Like :brandVariantLike 
                                          AND ESN_MB_Taxonomy_Brands__c = :brandDAMId
                                          ORDER BY CreatedDate DESC)];
        }
        return assetList;
    }
    
    public String getNPUrl(){return ESN_MB_Utils.cs_NP_URL();}

    /**
    * Import last modified assets in a brand from DAM/Northplains
    * @param brandId: Id of the current brand, to get only the related assets
    * @return a message (number of asserts created/updated or deleted).
    */ 
    @remoteAction 
    global static String importLastModifiedAssets(String brandId) {
        ESN_MB_NodePage__c brand = [Select ESN_MB_Brand_DAM_Id__c From ESN_MB_NodePage__c Where Id = :brandId limit 1];

        String message = '';
        if (brand != null && String.isNotBlank(brand.ESN_MB_Brand_DAM_Id__c)) {
            //ESN_MB_Rest_DAM_Schedule.importLastModifiedAssets(brand.ESN_MB_Brand_DAM_Id__c);
            // Don't use System.scheduleBatch or Database.executeBatch: we don't want the batch to be in Apex Jobs Queue (because it takes time)
            ESN_MB_Rest_DAM_BatchParams params = new ESN_MB_Rest_DAM_BatchParams(brand.ESN_MB_Brand_DAM_Id__c);
            ESN_MB_Rest_DAM_BatchImpl damAssetBatch = new ESN_MB_Rest_DAM_BatchImpl(params);
            damAssetBatch.start(null);message = damAssetBatch.execute();damAssetBatch.finish(null);
        }
        return message;
    }
    
    @RemoteAction 
    public static boolean isBroadCasterUser(){
        return ESN_MB_UtilsUser.isBroadCasterUser();
    }

    @RemoteAction 
    public static boolean isBroadCasterAssigned(String brandId){
        return ESN_MB_UtilsUser.isBroadCasterUser(brandId);
    }
}