/**
    About
    -----
    Description: Controler Class for MyBrands Cockpit project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Janv 2015

    Details
    -------
    This class contains methods for controlling MyBrand Cockpit VisualForce
    
    Update History
    --------------
    Janv 2015 / Created by Valentin PLITTA

    Issues / TODOs 
    --------------
*/

global class ESN_MB_Cockpit_Cx {
    public String brandId{get; set;}
    public String brandName{get; set;}
    public String brandStatut{get; set;}
    public String brandCategory{get; set;}
    public static List<ESN_MB_NodePage__c> brandsNames{get;set;}
    
    /**
    * Constructor ESN_MB_Cockpit_Cx()
    * return the brand name and the brand status
    */
    public ESN_MB_Cockpit_Cx(){
        brandId = ApexPages.currentPage().getParameters().get('brandid');
        brandName = getBrand().get('BrandName').replaceAll('"', '\"').replaceAll('\'', '');
        brandStatut = getBrand().get('BrandStatut'); 
        brandCategory  = getBrand().get('BrandCategory');
    }
    
    /**
    * Method reformatBrandName()
    * return the brand name without special caracter
    */
    @TestVisible private Static String reformatBrandName(String brandNameParam){
        return brandNameParam.replaceAll('[\\W]+', '');
    }
    
    /**
    * Method updateStaticResource()
    * call a webservice to update a static resource
    */
    @RemoteAction
    public static ESN_MB_MetadataService.SaveResult[] updateStaticResource(String brandName, String zipContent, Boolean isOld) {
        System.debug('--------------------------');
        System.debug(zipContent);
        System.debug('--------------------------');
        ESN_MB_MetadataService.SaveResult[] results = null;
        try {
            ESN_MB_MetadataService.MetadataPort service = new ESN_MB_MetadataService.MetadataPort();
            service.SessionHeader = new ESN_MB_MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
    
    
            ESN_MB_MetadataService.StaticResource staticResource = new ESN_MB_MetadataService.StaticResource();
            String brandNameClean = reformatBrandName(brandName);
            if(isOld == true){
                staticResource.fullName = 'ESN_MB_Theme_'+brandNameClean+'_Old';
            } else {
                staticResource.fullName = 'ESN_MB_Theme_'+brandNameClean;
            }
            staticResource.contentType = 'application/zip';
            staticResource.cacheControl = 'public';
    
            staticResource.content = zipContent;
            results = service.updateMetadata(new List<ESN_MB_MetadataService.Metadata> {staticResource});
        }  finally {
            removeSREditorPS();
        }
        System.debug('--------------------------');
        System.debug(results);
        System.debug('--------------------------');

        return results;
    }
    
    /**
    * Method currentUserIsSREditor()
    * It's used by grantSREditorPS to autorize a user to update static resource
    */
    private static Boolean currentUserIsSREditor(){
        List<PermissionSet> listPs = [select id, name
                                      from PermissionSet
                                      where name = 'ESN_MB_MyBrands_Cockpit_StaticResourceEditor'];
        
       
        List<PermissionSetAssignment> listRes = [Select Id from PermissionSetAssignment Where AssigneeId = :UserInfo.getUserId() And PermissionSetId=:listPS[0].Id];
        
        return listRes.size() > 0;
    }
    
    /**
    * Method grantSREditorPS()
    * Grant the rights to upload a static resource
    */
    @RemoteAction
    public static Boolean grantSREditorPS(){
        Boolean res = false;
        if(!currentUserIsSREditor()){
            List<PermissionSet> listPs = [select id, name
                                          from PermissionSet
                                          where name = 'ESN_MB_MyBrands_Cockpit_StaticResourceEditor'];
            if(listPS.size()>0){
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.assigneeId = UserInfo.getUserId();
                
                psa.PermissionSetId = listPS[0].Id;
                System.debug('Preparing to insert : ' + psa);
                Database.SaveResult resInsert = Database.insert(psa);
                res = true;
                System.debug('res = ' + res);
            }
        } else {
            res = true;
        }
        return res;
    }
    
    /**
    * Method restorePreviousColors()
    * Change the name of a static resource to restore to the previous version
    */
    @RemoteAction
    public static ESN_MB_MetadataService.SaveResult restorePreviousColors(String brandName) {
        ESN_MB_MetadataService.SaveResult result = null;
            
        try{
            ESN_MB_MetadataService.MetadataPort service = new ESN_MB_MetadataService.MetadataPort();
            service.SessionHeader = new ESN_MB_MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            
            String brandNameClean = reformatBrandName(brandName);
            
            result = service.renameMetadata('StaticResource','ESN_MB_Theme_'+brandNameClean+'_Old','ESN_MB_Theme_'+brandNameClean+'_Old2');
            ESN_MB_MetadataService.SaveResult result2 = service.renameMetadata('StaticResource','ESN_MB_Theme_'+brandNameClean,'ESN_MB_Theme_'+brandNameClean+'_Old');
            ESN_MB_MetadataService.SaveResult result3 = service.renameMetadata('StaticResource','ESN_MB_Theme_'+brandNameClean+'_Old2','ESN_MB_Theme_'+brandNameClean);
        } finally {
            removeSREditorPS();
        }
        
        return result;
    }
    
    /**
    * Method removeSREditorPS()
    * Remove rights to a user to upload static resource
    */
    @TestVisible private static void removeSREditorPS(){
        List<PermissionSet> listPs = [select id, name
                                      from PermissionSet
                                      where name = 'ESN_MB_MyBrands_Cockpit_StaticResourceEditor'];
        if(listPs.size()>0){
            List<PermissionSetAssignment> listRes = [Select Id from PermissionSetAssignment Where AssigneeId = :UserInfo.getUserId() And PermissionSetId=:listPS[0].Id];
            if(listRes.size()>0){
                Database.DeleteResult resDel = Database.delete(listRes[0]);
            }
        }
    }

    /**
    * Method getCurrentBrandSRURL()
    * return URL of a static resource
    */
    public String getCurrentBrandSRURL(){
        String brandNameClean = reformatBrandName(brandName);
        String resourceName = 'ESN_MB_Theme_'+brandNameClean;
        
        // Fetching the resource
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
        
        String url = '';
        // Checking if the result is returned or not
        if(resourceList.size() == 1){
            
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            // Resource URL
            url = '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
        }
            
        return url;
    }
    
    /**
    * Method getBrandNames()
    * return all the brand name
    */
    public String getBrandNames(){
        List<ESN_MB_NodePage__c> listBrandNames = retrieveBrandNames();
        return JSON.serialize(listBrandNames);
        
    }
    @TestVisible private static List<ESN_MB_NodePage__c> retrieveBrandNames() {
        brandsNames = [select id, Name, ESN_MB_Deployment_Status__c, ESN_MB_Brand_Category__c
                       from ESN_MB_NodePage__c 
                       Where RecordType.DeveloperName = 'ESN_MB_Brand' 
                       order by ESN_MB_Order__c];    

        return brandsNames;
    }
    
    /**
    * Method getBrand()
    * return the curent brand name with the brandId in the URL
    */
    public map<String,String> getBrand() {
        System.debug('Entree dans getBrand. On cherche l\'id de la brand ' + brandId);
        map<String,String> brandInformation = new Map<String,String>();
        String brandName = '';
        String brandStatut = '';
        List<ESN_MB_NodePage__c> brandList = retrieveBrandNames();
        for(ESN_MB_NodePage__c nodeTmp:brandList){
            if(nodeTmp.id == brandId){
                brandInformation.put('BrandName',nodeTmp.Name);
                brandInformation.put('BrandStatut',nodeTmp.ESN_MB_Deployment_Status__c);
                brandInformation.put('BrandCategory',nodeTmp.ESN_MB_Brand_Category__c);
                break;
            }
        }
        return brandInformation;
    }
    
    /**
    * Method getBackgroundExist()
    * return if a background exist or not
    */
    public String getBackgroundExist(){
        String backgroundExist = 'No Background';
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='Background' and ESN_MB_Node_Page__r.Id = :brandId];
        if(resourceId.size() >0){
            List <Attachment> attachmentId = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
            if(attachmentId.size() >0){
                 backgroundExist = attachmentId[0].id;
            }
        }
        return backgroundExist;
        
    }
    
    /**
    * Method getPortfolioBackgroundExist()
    * return if a background exist or not
    */
    public String getPortfolioBackgroundExist(){
        String backgroundExist = 'No Portfolio Background';
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='PortfolioBackground' and ESN_MB_Node_Page__r.Id = :brandId];
        if(resourceId.size() >0){
            List <Attachment> attachmentId = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
            if(attachmentId.size() >0){
                 backgroundExist = attachmentId[0].id;
            }
        }
        return backgroundExist;
        
    }
    
    /**
    * Method manageBackground()
    * update or create attachment file to manage background of a brand
    */
    @RemoteAction
    global static void manageBackground (String imageBase64, String brandId, String brandName, Boolean backgroundDeleted){
        
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='Background' and ESN_MB_Node_Page__r.Id = :brandId];
        
        if(backgroundDeleted == true){
            if(resourceId.size() >0){
                List <Attachment> attachmentBackground = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
                if(attachmentBackground.size() >0){
                    delete(attachmentBackground);      
                }
            }
        }
        else if(resourceId.size() >0){
            List <Attachment> attachmentBackground = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
             if(attachmentBackground.size() >0){
                attachmentBackground[0].Body = EncodingUtil.base64Decode(imageBase64);
                attachmentBackground[0].Name = 'background';
                update(attachmentBackground);
             }else{
                Attachment attachmentNewBackground = new Attachment();
                attachmentNewBackground.Body = EncodingUtil.base64Decode(imageBase64);
                attachmentNewBackground.Name = 'background';
                attachmentNewBackground.ParentId = resourceId[0].ESN_MB_Resource__c;
                insert(attachmentNewBackground);
             }
           
        }else{
            
            ESN_MB_Resource__c resource = new ESN_MB_Resource__c();
            resource.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Image');
            String brandNameClean = reformatBrandName(brandName);
            resource.Name = 'ESN_MB_Background_'+ brandNameClean;
            resource.ESN_MB_Type__c = 'Background';
            resource.CurrencyIsoCode = UserInfo.getDefaultCurrency();
            insert(resource);
            
            Attachment attachmentBackground = new Attachment();
            attachmentBackground.Body = EncodingUtil.base64Decode(imageBase64);
            attachmentBackground.Name = 'background';
            attachmentBackground.ParentId = resource.Id;
            insert(attachmentBackground);
            
            ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
            entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Nodepage_To_Resource');
            entry.ESN_MB_Node_Page__c =brandId;
            entry.ESN_MB_Resource__c = resource.Id;
            insert(entry);
       }
        
    }
    
    /**
    * Method managePortfolioBackground()
    * update or create attachment file to manage background of a brand
    */
    @RemoteAction
    global static void managePortfolioBackground (String imageBase64, String brandId, String brandName, Boolean portfolioBackgroundDeleted ){
        
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='PortfolioBackground' and ESN_MB_Node_Page__r.Id = :brandId];
        
        if(portfolioBackgroundDeleted == true){
            if(resourceId.size() >0){
                List <Attachment> attachmentBackground = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
                if(attachmentBackground.size() >0){
                    delete(attachmentBackground);      
                }
            }
        }
        else if(resourceId.size() >0){
            List <Attachment> attachmentBackground = [Select id, ParentId from Attachment where ParentId =:resourceId[0].ESN_MB_Resource__c];
             if(attachmentBackground.size() >0){
                attachmentBackground[0].Body = EncodingUtil.base64Decode(imageBase64);
                attachmentBackground[0].Name = 'portfolioBackground';
                update(attachmentBackground);
             }else{
                Attachment attachmentNewBackground = new Attachment();
                attachmentNewBackground.Body = EncodingUtil.base64Decode(imageBase64);
                attachmentNewBackground.Name = 'portfolioBackground';
                attachmentNewBackground.ParentId = resourceId[0].ESN_MB_Resource__c;
                insert(attachmentNewBackground);
             }
           
        }else{
            
            ESN_MB_Resource__c resource = new ESN_MB_Resource__c();
            resource.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Image');
            String brandNameClean = reformatBrandName(brandName);
            resource.Name = 'ESN_MB_PortfolioBackground_'+ brandNameClean;
            resource.ESN_MB_Type__c = 'PortfolioBackground';
            resource.CurrencyIsoCode = UserInfo.getDefaultCurrency();
            insert(resource);
            
            Attachment attachmentBackground = new Attachment();
            attachmentBackground.Body = EncodingUtil.base64Decode(imageBase64);
            attachmentBackground.Name = 'portfolioBackground';
            attachmentBackground.ParentId = resource.Id;
            insert(attachmentBackground);
            
            ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
            entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Nodepage_To_Resource');
            entry.ESN_MB_Node_Page__c =brandId;
            entry.ESN_MB_Resource__c = resource.Id;
            insert(entry);
       }
        
    }
    
    /**
    * Method retrieveInformationCockpit()
    * return an ESN_MB_NOP_Product_DTO object with the name of all products with there informations
    */
    @RemoteAction
    global static List<ESN_MB_NOP_Product_DTO> retrieveInformationCockpit (String brandId){
        List<ESN_MB_NOP_Product_DTO> listProductDTO = new List<ESN_MB_NOP_Product_DTO>();
        
        List<ESN_MB_Entry__c> listProductFromDB = [select ESN_MB_Node_Page__c, ESN_MB_Node_Page__r.Name, ESN_MB_Resource__c,ESN_MB_Node_Page__r.ESN_MB_Order__c, ESN_MB_Node_Page__r.ESN_MB_Default_Brand_Variant_Value__c 
                                            from ESN_MB_Entry__c 
                                            where ESN_MB_Node_Page__r.ESN_MB_ParentId__c = :brandId 
                                            And RecordType.DeveloperName='ESN_MB_Nodepage_To_Resource'
                                            order by ESN_MB_Node_Page__r.ESN_MB_Order__c];
        
        List<String> productsLogosIds = new List<String>();
        List<String> logosIds = new List<String>();
        for(ESN_MB_Entry__c e : listProductFromDB) {
            productsLogosIds.add(e.ESN_MB_Resource__c);
        }
        System.debug('retrieveProductsLogosIds() > productsLogosIds.size()=' + productsLogosIds.size());

        List<Attachment> logosBottleIds = [select id, Name, ParentId 
                          from Attachment 
                          where ParentId IN :productsLogosIds];
        System.debug('retrieveProductsLogosIds() > logosBottleIds.size()= ' + logosBottleIds.size());
        
        for(ESN_MB_Entry__c e : listProductFromDB) {
            for(Attachment a : logosBottleIds) {
                if (e.ESN_MB_Resource__c == a.ParentId) {
                    logosIds.add(a.id);
                }
            }
        }
        
        for (Integer i = 0; i < listProductFromDB.size(); i++) {
            ESN_MB_NOP_Product_DTO productTmp = new ESN_MB_NOP_Product_DTO();
            productTmp.productName=listProductFromDB[i].ESN_MB_Node_Page__r.Name;
            productTmp.productId=listProductFromDB[i].ESN_MB_Node_Page__c;
            productTmp.brandId=brandId;
            productTmp.order=listProductFromDB[i].ESN_MB_Node_Page__r.ESN_MB_Order__c;
            productTmp.image = logosIds[i];
            productTmp.productBrandVariant = listProductFromDB[i].ESN_MB_Node_Page__r.ESN_MB_Default_Brand_Variant_Value__c;
            listProductDTO.add(productTmp);
        }
        
        return listProductDTO;
        
    }
    
    /**
    * Method retrieveSocialLinks()
    * return an ESN_MB_NOP_SocialLinks_DTO object with all the social links and there URL
    */
    @RemoteAction
    global static List<ESN_MB_NOP_SocialLinks_DTO> retrieveSocialLinks (String brandId){
        List<ESN_MB_NOP_SocialLinks_DTO> listSocialLinksDTO = new List<ESN_MB_NOP_SocialLinks_DTO>();
        
        List <ESN_MB_Nodepage__c> listUrl = [Select ESN_MB_Url_Facebook_Link__c,ESN_MB_Url_Flickr_Link__c,ESN_MB_Url_GooglePlus_Link__c,ESN_MB_Url_Instagram_Link__c,
                                             ESN_MB_Url_Pinterest_Link__c, ESN_MB_Url_Twitter_Link__c, ESN_MB_Url_Youtube_Link__c 
                                             from ESN_MB_NodePage__c where Id = :brandId];
        
        for (Integer i = 0; i < listUrl.size(); i++) {
            ESN_MB_NOP_SocialLinks_DTO socialLinksTmp = new ESN_MB_NOP_SocialLinks_DTO();
            socialLinksTmp.urlFacebook=listUrl[i].ESN_MB_Url_Facebook_Link__c;
            socialLinksTmp.urlFlickr=listUrl[i].ESN_MB_Url_Flickr_Link__c;
            socialLinksTmp.urlGooglePlus=listUrl[i].ESN_MB_Url_GooglePlus_Link__c;
            socialLinksTmp.urlInstagram=listUrl[i].ESN_MB_Url_Instagram_Link__c;
            socialLinksTmp.urlPinterest = listUrl[i].ESN_MB_Url_Pinterest_Link__c;
            socialLinksTmp.urlTwitter=listUrl[i].ESN_MB_Url_Twitter_Link__c;
            socialLinksTmp.urlYoutube=listUrl[i].ESN_MB_Url_Youtube_Link__c;
            listSocialLinksDTO.add(socialLinksTmp);
        }
        
        return listSocialLinksDTO; 
    }
    
    /**
    * Method updateSocialLinks()
    * update URL of social links
    */
    @RemoteAction
    global static void updateSocialLinks (String urlFacebook, String urlFlickr, String urlGooglePlus, String urlInstagram, String urlPinterest, String urlTwitter, String urlYoutube, String brandId){   
        ESN_MB_Nodepage__c UrlSocialLink = [Select ESN_MB_Url_Facebook_Link__c,ESN_MB_Url_Flickr_Link__c,ESN_MB_Url_GooglePlus_Link__c,ESN_MB_Url_Instagram_Link__c,
                                             ESN_MB_Url_Pinterest_Link__c, ESN_MB_Url_Twitter_Link__c, ESN_MB_Url_Youtube_Link__c, ESN_MB_Deployment_Status__c 
                                             from ESN_MB_NodePage__c where Id = :brandId Limit 1];
        
       UrlSocialLink.ESN_MB_Url_Facebook_Link__c = urlFacebook;
       UrlSocialLink.ESN_MB_Url_Flickr_Link__c = urlFlickr;
       UrlSocialLink.ESN_MB_Url_GooglePlus_Link__c = urlGooglePlus;
       UrlSocialLink.ESN_MB_Url_Instagram_Link__c = urlInstagram;
       UrlSocialLink.ESN_MB_Url_Pinterest_Link__c = urlPinterest;
       UrlSocialLink.ESN_MB_Url_Twitter_Link__c = urlTwitter;
       UrlSocialLink.ESN_MB_Url_Youtube_Link__c = urlYoutube;
        
        if(UrlSocialLink.ESN_MB_Deployment_Status__c.equals('Disable')){
            UrlSocialLink.ESN_MB_Deployment_Status__c = 'Work in progress';
        }

       update(UrlSocialLink);
    }
    
    private static ESN_MB_Nodepage__c buildNodepageFromProductDTO (ESN_MB_NOP_Product_DTO productDTO){
        
        ESN_MB_Nodepage__c product = new ESN_MB_Nodepage__c();
        product.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
        product.Name = productDTO.productName;
        product.ESN_MB_Order__c = productDTO.order;
        product.ESN_MB_ParentId__c = productDTO.brandId;
        product.ESN_MB_IsMasterbrand__c = productDTO.isMasterbrand;
        product.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
        product.ESN_MB_Default_Brand_Variant_Value__c = productDTO.productBrandVariant;
        
        return product;
    }
    
    private static ESN_MB_Nodepage__c updateNodepageFromProductDTO (ESN_MB_NOP_Product_DTO productDTO){
        
        ESN_MB_NodePage__c productInfo =[select Name,ESN_MB_Order__c,ESN_MB_IsMasterbrand__c, ESN_MB_Default_Brand_Variant_Value__c 
                                              from ESN_MB_NodePage__c 
                                              where Id= :productDTO.productId and RecordType.DeveloperName = 'ESN_MB_Product'];  
        productInfo.Name= productDTO.productName;
        productInfo.ESN_MB_Order__c= productDTO.order;
        productInfo.ESN_MB_IsMasterbrand__c = productDTO.isMasterbrand;
        productInfo.ESN_MB_Default_Brand_Variant_Value__c = productDTO.productBrandVariant;

        return productInfo;
    }
    
     private static ESN_MB_Resource__c buildResourceFromProductDTO (ESN_MB_NOP_Product_DTO productDTO){
        
        ESN_MB_Resource__c resource = new ESN_MB_Resource__c();
        resource.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Image');
        resource.Name = 'ESN_MB_'+ productDTO.productName;
        resource.ESN_MB_Type__c = 'Logo';
        resource.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
  
        return resource;
    }
    
    private static Attachment buildAttachmentFromProductDTO (ESN_MB_NOP_Product_DTO productDTO, String resourceId){
        
       Attachment attachment = new Attachment();
       attachment.Body = EncodingUtil.base64Decode(productDTO.image);
       attachment.Name = productDTO.productName;
       attachment.ParentId = resourceId;
  
       return attachment;
    }
    
    private static Attachment updateAttachmentFromProductDTO (ESN_MB_NOP_Product_DTO productDTO){       
       ESN_MB_Entry__c  resourceId =[select ESN_MB_Node_Page__c, ESN_MB_Node_Page__r.Name, ESN_MB_Resource__c,ESN_MB_Node_Page__r.ESN_MB_Order__c 
                                                from ESN_MB_Entry__c 
                                                where ESN_MB_Node_Page__c = :productDTO.productId
                                                And RecordType.DeveloperName='ESN_MB_Nodepage_To_Resource'];
       Attachment attachmentId = [select id from Attachment where ParentId = :resourceId.ESN_MB_Resource__c];
                    
       attachmentId.Body = EncodingUtil.base64Decode(productDTO.image);
       attachmentId.Name = productDTO.productName;
  
       return attachmentId;
    }
    
    private static ESN_MB_Entry__c buildEntry(String resourceId, String productId){
        
       ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
       entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Nodepage_To_Resource');
       entry.ESN_MB_Node_Page__c =productId;
       entry.ESN_MB_Resource__c = resourceId;
  
       return entry;
    }
    
    private static void insertListProductDTO( List <ESN_MB_NOP_Product_DTO> listProductDTO){
        List <ESN_MB_Nodepage__c> listProductToInsert = new List <ESN_MB_Nodepage__c>();
        List <ESN_MB_Resource__c> listResourceToInsert = new List <ESN_MB_Resource__c>();
        List <Attachment> listAttachmentToInsert = new List <Attachment>();
        List <ESN_MB_Entry__c> listEntryToInsert = new List <ESN_MB_Entry__c>();
        
        // In this for we prepare nodepage list and resource list to insert
        for(ESN_MB_NOP_Product_DTO productDTOTmp : listProductDTO){
            listProductToInsert.add(buildNodepageFromProductDTO(productDTOTmp));
            listResourceToInsert.add(buildResourceFromProductDTO(productDTOTmp));
        }
        List <Database.saveresult> listResultProduct = Database.insert(listProductToInsert);
        List <Database.saveresult> listResultResource = Database.insert(listResourceToInsert);
        
        //In this for we prepare attachment list and entry list to insert
        for(Integer i=0; i<listResultProduct.size(); i++){
            if(listResultProduct[i].isSuccess() && listResultResource[i].isSuccess()){
                String idProductTmp = listResultProduct[i].getId();
                String idResourceTmp = listResultResource[i].getId();
                listAttachmentToInsert.add(buildAttachmentFromProductDTO(listProductDTO[i], idResourceTmp));
                listEntryToInsert.add(buildEntry(idResourceTmp, idProductTmp));
            }
        }
        
        List <Database.saveresult> listResultAttachment = Database.insert(listAttachmentToInsert);
        List <Database.saveresult> listResultEntry = Database.insert(listEntryToInsert);
    }
    
    private static void updateListProductDTO( List <ESN_MB_NOP_Product_DTO> listProductDTO){
        List <ESN_MB_Nodepage__c> listProductToUpdate = new List <ESN_MB_Nodepage__c>();
        List <Attachment> listAttachmentToUpdate = new List <Attachment>();
        
        for(ESN_MB_NOP_Product_DTO productDTOTmp : listProductDTO){
            listProductToUpdate.add(updateNodepageFromProductDTO(productDTOTmp));
            if(!productDTOTmp.image.equals('noUpdateForImage')){   
                listAttachmentToUpdate.add(updateAttachmentFromProductDTO(productDTOTmp));
            }
        }
        
        List <Database.saveresult> listResultProduct = Database.update(listProductToUpdate);
        List <Database.saveresult> listResultAttachment = Database.update(listAttachmentToUpdate);
     
    }
    
    /**
    * Method bottleCanBeDeleted()
    * check if a bottle is attached to some content
    */
    @RemoteAction
    global static Boolean bottleCanBeDeleted (String productId){
        
        Boolean resultDeleteBottle = false;
        
        List<ESN_MB_Article__c> listArticleAttachToProduct = [select id, Name from ESN_MB_Article__c Where ESN_MB_Node_Page__r.Id = :productId];
        List<ESN_MB_Activation__c> listActivationAttachToProduct = [select id, Name from ESN_MB_Activation__c Where ESN_MB_Product__r.Id = :productId];
        
        if((listArticleAttachToProduct.size()>0) || (listActivationAttachToProduct.size()>0) ){
            resultDeleteBottle = false;
        }else{
             resultDeleteBottle = true;
        } 
        return resultDeleteBottle;
    }
    
    /**
    * Method deleteBottle()
    * Delete bottle(s)
    */
    @RemoteAction
    global static void deleteBottle (List<String> productId){
        List<ESN_MB_NodePage__c> productToBeDeleted = new List<ESN_MB_NodePage__c>();
        for(String productIdTmp : productId){
             ESN_MB_NodePage__c productToDeleteTmp = [select id, Name from ESN_MB_NodePage__c Where RecordType.DeveloperName = 'ESN_MB_Product' and ESN_MB_NodePage__c.Id = :productIdTmp];
            productToBeDeleted.add(productToDeleteTmp);
        }
         delete(productToBeDeleted); 
    }
    
    /**
    * Method manageListBottle()
    * manage bottle : delete, create, update
    */
    @RemoteAction
    global static void manageListBottle (List<ESN_MB_NOP_Product_DTO> listProductDTO){
        System.debug('createListBottle() > listProductDTO.size()= ' + listProductDTO.size());
        List <ESN_MB_Nodepage__c> listProduct = new List <ESN_MB_Nodepage__c>();
        
        List <ESN_MB_NOP_Product_DTO> listNewProductDTO = new List <ESN_MB_NOP_Product_DTO>();
        List <ESN_MB_NOP_Product_DTO> listExistingProductDTO = new List <ESN_MB_NOP_Product_DTO>();
        
        for (Integer i = 0; i < listProductDTO.size(); i++) {
            if(listProductDTO[i].productId.equals('newProduct')){
                
                listNewProductDTO.add(listProductDTO[i]);
            }
            else{
                listExistingProductDTO.add(listProductDTO[i]);
            }
        }
        insertListProductDTO(listNewProductDTO);
        updateListProductDTO(listExistingProductDTO);
   
    }
}