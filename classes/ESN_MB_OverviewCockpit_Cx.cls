/**
    About
    -----
    Description: Controler Class for MyBrands OverviewCockpit project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Janv 2015

    Details
    -------
    This class contains methods for controlling MyBrand OverviewCockpit VisualForce
    
    Update History
    --------------
    Janv 2015 / Created by Valentin PLITTA

    Issues / TODOs
    --------------
*/

global class ESN_MB_OverviewCockpit_Cx {
    public static List<Attachment> brandsLogos{get;set;}
    public static List<ESN_MB_Entry__c> resources{get;set;}
    
    /**
    * Method retrieveLogosIds()
    * @return logosIds: returns the ids and parentIds of the logos
    * to display for each brand depending on the order
    */
    public static String getLogosIds() {
        List<String> listLogosIds = retrieveLogosIds();
        return JSON.serialize(listLogosIds);
    }
    
    /**
    * Method getIsCockpitAdmin()
    * returns true if the user is not a cockpit admin
    */
    public Boolean getIsCockpitAdministrator() {return ESN_MB_UtilsUser.isCockpitAdministrator();}
    
    @TestVisible private static List<String> retrieveLogosIds() {
        List<String> resourcesIds = new List<String>();
        List<String> logosIds = new List<String>();
        resources = [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Node_Page__r.RecordType.DeveloperName='ESN_MB_Brand' 
                      and ESN_MB_Resource__r.ESN_MB_Type__c='Tile' order by ESN_MB_Node_Page__r.ESN_MB_Order__c];
        for(ESN_MB_Entry__c e : resources) {
            resourcesIds.add(e.ESN_MB_Resource__c);
        }
        brandsLogos = [Select id, ParentId from Attachment where ParentId IN :resourcesIds];
        for(ESN_MB_Entry__c e : resources) {
            for(Attachment a : brandsLogos) {
                if (e.ESN_MB_Resource__c == a.ParentId) {
                    logosIds.add(a.id);
                }
            }
        }
        return logosIds;
    }
    
    @RemoteAction 
    global static List<String> retrieveLogosIds2() {
        return retrieveLogosIds();
    }
    
    @RemoteAction 
    global static List<ESN_MB_NodePage__c> retrieveBrandNames2() {
          return retrieveBrandNames();
    }
    
    /**
    * Method retrieveBrandNames()
    * @return brandsNames: returns the ids and names of each brand
    */
    public static String getBrandNames(){
        List<ESN_MB_NodePage__c> listBrandNames = retrieveBrandNames();
         for(ESN_MB_Nodepage__c listBrandNamesTmp : listBrandNames){
             listBrandNamesTmp.Name = listBrandNamesTmp.Name;//.replaceAll('"', '\"').replaceAll('\'', '\\\'');
        }
        return JSON.serialize(listBrandNames);
        
    }
    @TestVisible private static List<ESN_MB_NodePage__c> retrieveBrandNames() {
       List<ESN_MB_NodePage__c> brandsNames = [SELECT id, Name, ESN_MB_NorthPlains_Portal_URL__c, ESN_MB_ChatterGroup_Id__c, 
                                               ESN_MB_Default_Brand_Variant_Value__c, ESN_MB_Order__c, ESN_MB_Brand_DAM_Id__c, 
                                               ESN_MB_Deployment_Status__c, ESN_MB_Brand_Category__c, ESN_MB_Alcohol_Type__c, ESN_MB_Brand_Company__c, ESN_MB_Title__c, ESN_MB_BrandParentId__c
                                               FROM ESN_MB_NodePage__c WHERE RecordType.DeveloperName = 'ESN_MB_Brand' order BY ESN_MB_Order__c];
        return brandsNames;
    }
    
    /**
    * Method changeBrandStatus()
    * update status of a brand
    */
    private static void changeBrandStatus (List<String> listBrandId, String status){
        List<ESN_MB_Nodepage__c> listBrandsStatus = [SELECT Id, Name, ESN_MB_Deployment_Status__c 
                                                        FROM ESN_MB_Nodepage__c 
                                                        WHERE recordType.DeveloperName = 'ESN_MB_Brand'
                                                        AND Id IN :listBrandId];
        for(ESN_MB_Nodepage__c nodePageTmp : listBrandsStatus){
            nodePageTmp.ESN_MB_Deployment_Status__c = status;
        }
        update(listBrandsStatus); 
    }
    @RemoteAction
    global static void brandStatusToEnable (List<String> listBrandId){
        changeBrandStatus(listBrandId,'Enable');
    }
    
    @RemoteAction
    global static void brandStatusToWIP (List<String> listBrandId){
         changeBrandStatus(listBrandId,'Work in progress');
    }
    
    @RemoteAction
    global static void brandStatusToArchive (List<String> listBrandId){
         changeBrandStatus(listBrandId,'Archive');
    }
    
    /**
    * Method retrieveAssignedBrand()
    * return assigned brand for the current user
    */
    @RemoteAction
    global static String retrieveAssignedBrand (){
         String userId = UserInfo.getUserId();
         String assignedBrands = [select ESN_MB_AssignedBrands__c from User where id = :userId].ESN_MB_AssignedBrands__c;
        
        return assignedBrands;
    }
    
    /**
    * Method updateBrandInformations()
    * update information in the key settings section of the overview cockpit
    */
    @RemoteAction
    global static void updateBrandInformations (String nPUrl, String chatterGroupId, String defaultBrandVariantValue,
                                                String brandDAMId, Decimal customOrder, String imageBase64, String brandId,
                                                String logoName, String brandCategory, String alcoholType, String brandCompany, String title, String brandParentId){
        ESN_MB_NodePage__c productToUpload = [select id, Name, ESN_MB_NorthPlains_Portal_URL__c, ESN_MB_ChatterGroup_Id__c, ESN_MB_Default_Brand_Variant_Value__c, ESN_MB_Order__c, ESN_MB_Brand_DAM_Id__c, ESN_MB_Deployment_Status__c, ESN_MB_Brand_Category__c, ESN_MB_Title__c, ESN_MB_BrandParentId__c
                                                from ESN_MB_NodePage__c Where RecordType.DeveloperName = 'ESN_MB_Brand' and ESN_MB_NodePage__c.Id = :brandId];
        
        productToUpload.ESN_MB_NorthPlains_Portal_URL__c = nPUrl;
        productToUpload.ESN_MB_ChatterGroup_Id__c = chatterGroupId;
        productToUpload.ESN_MB_Default_Brand_Variant_Value__c = defaultBrandVariantValue;
        productToUpload.ESN_MB_Order__c = customOrder;
        productToUpload.ESN_MB_Brand_DAM_Id__c = brandDAMId;
        productToUpload.ESN_MB_Brand_Category__c = brandCategory;
        productToUpload.ESN_MB_Alcohol_Type__c = alcoholType;
        productToUpload.ESN_MB_Brand_Company__c = brandCompany;
        productToUpload.ESN_MB_Title__c = title;
        productToUpload.ESN_MB_BrandParentId__c = brandParentId;
        
        update(productToUpload);
        if(!imageBase64.equals('noUpdateForImage')){ 
            updateAttachmentTile(brandId, imageBase64,logoName);
        }
    }
    
    /**
    * Method createNewBrand()
    * Create a new brand, the brand's tile with a default image and the rubrics
    */
    @RemoteAction
    global static void createNewBrand (String brandName, String imageBase64, String brandCategory){
        
        /* Create New Disable Brand */
        Decimal orderMax = [SELECT ESN_MB_Order__c FROM ESN_MB_Nodepage__c WHERE recordType.DeveloperName = 'ESN_MB_Brand' ORDER BY ESN_MB_Order__c DESC Limit 1].ESN_MB_Order__c;
        ESN_MB_Nodepage__c brand = new ESN_MB_Nodepage__c();
        brand.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        brand.Name = brandName;
        brand.ESN_MB_Deployment_Status__c = 'Disable';
        brand.ESN_MB_Brand_Category__c = brandCategory;
        brand.ESN_MB_Order__c = (orderMax+10);
        brand.ESN_MB_Brand_Initialization__c = true;
        brand.CurrencyIsoCode = UserInfo.getDefaultCurrency();    
        insert(brand);
        
        /* Create Resource with default image */
        ESN_MB_Resource__c resource = new ESN_MB_Resource__c();
        resource.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Image');
        resource.Name = 'ESN_MB_Default';
        resource.ESN_MB_Type__c = 'Tile';
        resource.CurrencyIsoCode = UserInfo.getDefaultCurrency();  
        insert resource;
       
        Attachment attachment = new Attachment();
        attachment.Body = EncodingUtil.base64Decode(imageBase64);
        attachment.Name = String.valueOf('unavailable_doc.png');
        attachment.ParentId = resource.Id;
        insert attachment;
        
        /* Link with entry brand with the default resource */
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Nodepage_To_Resource');
        entry.ESN_MB_Node_Page__c = brand.Id;
        entry.ESN_MB_Resource__c = resource.Id;
        insert(entry);
        
        List<ESN_MB_NodePage__c> listRubric = [Select Id, Name from ESN_MB_NodePage__c where RecordType.DeveloperName='ESN_MB_Rubric' And ESN_MB_AvailableByDefault__c = true];
        /*List<ESN_MB_NodePage__c> listRubric;
        if(brandCategory != Label.ESN_MB_LeCercle) {
            listRubric = [Select Id, Name from ESN_MB_NodePage__c where RecordType.DeveloperName='ESN_MB_Rubric' And ESN_MB_Brand_Category__c!='LeCercle' And ESN_MB_AvailableByDefault__c = true];
        } else {
            listRubric = [Select Id, Name from ESN_MB_NodePage__c where RecordType.DeveloperName='ESN_MB_Rubric' And ESN_MB_Brand_Category__c='LeCercle' And ESN_MB_AvailableByDefault__c = true];
        }*/
        
        List <ESN_MB_Entry__c> listEntryForRubric = new List <ESN_MB_Entry__c>();
        for(ESN_MB_NodePage__c rubricTmp : listRubric){
            ESN_MB_Entry__c entryForRubric = new  ESN_MB_Entry__c();
            entryForRubric.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Nodepage_To_Resource');
            entryForRubric.ESN_MB_Node_Page__c =brand.Id;
            entryForRubric.ESN_MB_Rubric__c = rubricTmp.Id;
            listEntryForRubric.add(entryForRubric);
        }
        
        insert(listEntryForRubric);
        
        if(brandCategory == Label.ESN_MB_LeCercle) {
            ESN_MB_Nodepage__c product = new ESN_MB_Nodepage__c();
            product.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Product');
            product.Name = brand.Name.replace('_', ' ') + ' MasterBrand';
            product.ESN_MB_Order__c = 10;
            product.ESN_MB_ParentId__c = brand.Id;
            product.ESN_MB_IsMasterbrand__c = true;
            product.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
            product.ESN_MB_Default_Brand_Variant_Value__c = '';
            insert(product);
            
            ESN_MB_Resource__c resourceProduct = new ESN_MB_Resource__c();
            resourceProduct.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Image');
            resourceProduct.Name = 'ESN_MB_' + brand.Name + '_Masterbrand';
            resourceProduct.ESN_MB_Type__c = 'Logo';
            resourceProduct.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
            insert(resourceProduct);
            
            ESN_MB_Entry__c entryProduct = new  ESN_MB_Entry__c();
            entryProduct.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Nodepage_To_Resource');
            entryProduct.ESN_MB_Node_Page__c = product.Id;
            entryProduct.ESN_MB_Resource__c = resourceProduct.Id;
            entryProduct.CurrencyIsoCode = UserInfo.getDefaultCurrency();
            insert(entryProduct);
        }
   
    }
    
    /**
    * Method reformatBrandName()
    * return brand's name without special caracter
    */
    @TestVisible private static String reformatBrandName(String brandNameParam){
        return brandNameParam.replaceAll('[\\W]+', '');
    }
    
    /**
    * Method grantSREditorPS()
    * grand the rights to a user to upload a static resource
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
    private static Boolean currentUserIsSREditor(){
        List<PermissionSet> listPs = [select id, name
                                      from PermissionSet
                                      where name = 'ESN_MB_MyBrands_Cockpit_StaticResourceEditor'];
        
       
        List<PermissionSetAssignment> listRes = [Select Id from PermissionSetAssignment Where AssigneeId = :UserInfo.getUserId() And PermissionSetId=:listPS[0].Id];
        
        return listRes.size() > 0;
    }
    
    /**
    * Method createStaticResource()
    * call a webservice to create a new static resource
    */
    @RemoteAction
    public static ESN_MB_MetadataService.SaveResult[] createStaticResource(String brandName, String zipContent) {
        System.debug('--------------------------');
        System.debug(zipContent);
        System.debug('--------------------------');
        ESN_MB_MetadataService.SaveResult[] results = null;
        try {
        ESN_MB_MetadataService.MetadataPort service = new ESN_MB_MetadataService.MetadataPort();
        service.SessionHeader = new ESN_MB_MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
  
        ESN_MB_MetadataService.StaticResource staticResource = new ESN_MB_MetadataService.StaticResource();
         ESN_MB_MetadataService.StaticResource staticResource2 = new ESN_MB_MetadataService.StaticResource();
        
        String brandNameClean = reformatBrandName(brandName);
        staticResource.fullName = 'ESN_MB_Theme_'+brandNameClean;
        staticResource.contentType = 'application/zip';
        staticResource.cacheControl = 'public';
        staticResource.content = zipContent;
        
        staticResource2.fullName = 'ESN_MB_Theme_'+brandNameClean+'_Old';
        staticResource2.contentType = 'application/zip';
        staticResource2.cacheControl = 'public';
        staticResource2.content = zipContent;

        results = service.createMetadata(new List<ESN_MB_MetadataService.Metadata> {staticResource});
        ESN_MB_MetadataService.SaveResult[] results2 = service.createMetadata(new List<ESN_MB_MetadataService.Metadata> {staticResource2});
        } finally {
            removeSREditorPS();
        }
        System.debug('--------------------------');
        System.debug(results);
        System.debug('--------------------------');

        return results;
    }
    
    /* Method updateStaticResource()
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
    * Method createStaticResource()
    * return URL of a static resource
    */
    @RemoteAction
    public static String getCurrentBrandSRURL(String currentCategory){
        String resourceName = '';
        if (currentCategory != Label.ESN_MB_LeCercle) {
            resourceName = 'ESN_MB_TemplateBrandSR';
        } else {
            resourceName = 'ESN_MB_TemplateBrandLeCercleSR';    
        }
        
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
    * Method getCurrentBrandStaticResourceURL()
    * return URL of a static resource
    */
    @RemoteAction
    public static String getCurrentBrandStaticResourceURL(String brandName){
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
    * Method updateAttachmentTile()
    * update tile which is attached to a brand
    */
    @TestVisible private static void updateAttachmentTile(String brandId, String imageBase64, String nameLogo){
        ESN_MB_Entry__c resource = [Select ESN_MB_Resource__c 
                                    from ESN_MB_Entry__c 
                                    where ESN_MB_Node_Page__r.Id = :brandId 
                                    and ESN_MB_Node_Page__r.RecordType.DeveloperName='ESN_MB_Brand' 
                                    and ESN_MB_Resource__r.ESN_MB_Type__c='Tile'];
            

        Attachment brandLogo = [Select id, ParentId from Attachment where ParentId = :resource.ESN_MB_Resource__c];

        brandLogo.Body = EncodingUtil.base64Decode(imageBase64);
        brandLogo.Name = String.valueOf(nameLogo);
        update brandLogo;
    }
    
    /**
    * Method retrieveSectionsValues()
    * return the values for brand category picklist
    */
    @RemoteAction 
    global static Map<String, List<SelectOption>> retrieveSectionsValues() 
    { 
        Map<String, List<SelectOption>> result = new Map<String, List<SelectOption>>();
        
        List<Schema.DescribeFieldResult> listFieldResult = new List<Schema.DescribeFieldResult>{
            ESN_MB_NodePage__c.ESN_MB_Brand_Category__c.getDescribe(),
            ESN_MB_NodePage__c.ESN_MB_Alcohol_Type__c.getDescribe(),
            ESN_MB_NodePage__c.ESN_MB_Brand_Company__c.getDescribe()
                };
        
        for(Schema.DescribeFieldResult field : listFieldResult){
            List<SelectOption> listOptions = new List<SelectOption>();
            List<Schema.PicklistEntry> ple = field.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
                listOptions.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            
            result.put(field.Name, listOptions);
        }
        
        return result;
    }
    
    /**
    * Method removeSREditorPS()
    * remove the rights to upload a static resource
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
}