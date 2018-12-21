/**
    About
    -----
    Description: Controler Class for MyBrands Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains methods for controlling MyBrand Brand VisualForce Page
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------
    Kevin Gerard 20/08/2014 - CHANGE CONTENT WITH ESN_MB_Homepage_Cx
    
*/


global class ESN_MB_NOP_Brand_Cx {
	public String oldVersion {get; set;}

    public static List<Attachment> brandsLogos{get;set;}
    public static List<ESN_MB_Entry__c> resources{get;set;}
    public static List<String> categoryList{get;set;}
    
    public ESN_MB_NOP_Brand_Cx() {
        oldVersion = ApexPages.currentPage().getParameters().get('OldVersion');
		getBrandNames();
        getLogosIds();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge'); 
        getCategoryList();
        getMoreApps();
		getBannerData();
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
        
    /**
    * Method getIsBasicUser()
    * returns true if the user is not a broadcaster nor a brand manager
    */
    public Boolean getIsBasicUser() {return ESN_MB_UtilsUser.isBasicUser();}
    
    
   /**
    * Method retrieveLogosIds()
    * @return logosIds: returns the ids and parentIds of the logos
    * to display for each brand depending on the order
    */
    public String getLogosIds() {
        List<String> listLogosIds = retrieveLogosIds();
        return JSON.serialize(listLogosIds);
    }
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
    
    /**
    * Method retrieveBrandNames()
    * @return brandsNames: returns the ids and names of each brand
    */
    public String getBrandNames(){
        List<ESN_MB_NodePage__c> listBrandNames = retrieveBrandNames();
        return JSON.serialize(listBrandNames);
        
    }
    @TestVisible private static List<ESN_MB_NodePage__c> retrieveBrandNames() {
        List<ESN_MB_NodePage__c> brandsNames = [select id, Name, ESN_MB_Deployment_Status__c, ESN_MB_Brand_Category__c, ESN_MB_Title__c from ESN_MB_NodePage__c Where RecordType.DeveloperName = 'ESN_MB_Brand' order by ESN_MB_Order__c];    
        return brandsNames;
    }
    
    public String getCurrentBrandStaticResource(String brand) { 
        return '$Resource.ESN_MB_MyBrands_'+brand;
    }
    public String getCurrentBrandCss(String brand) { 
        return '/css/themes/'+brand+'.css';
    }
    
    @RemoteAction 
    global static boolean isBasicUser(){return ESN_MB_UtilsUser.isBasicUser();}
    
     @RemoteAction 
    global static boolean getIsBroadCasterUser(){return ESN_MB_UtilsUser.isBroadCasterUser();}
    
    @RemoteAction 
    global static boolean isBroadCasterUser(){return ESN_MB_UtilsUser.isBroadCasterUser();}
    
        @RemoteAction 
    global static boolean isBrandManagerUser(){return ESN_MB_UtilsUser.isBrandManagerUser();}
    
        /**
    * Method retrieveSectionsValues()
    * return the values for brand category picklist
    */
    @RemoteAction 
    global static Map<String, List<String>> retrieveBrandValues() 
    { 
        Map<String, List<String>> result = new Map<String, List<String>>();
        
        List<Schema.DescribeFieldResult> listFieldResult = new List<Schema.DescribeFieldResult>{
            ESN_MB_NodePage__c.ESN_MB_Alcohol_Type__c.getDescribe(),
            ESN_MB_NodePage__c.ESN_MB_Brand_Company__c.getDescribe()
            };
        
        for(Schema.DescribeFieldResult field : listFieldResult){
            List<String> listOptions = new List<String>();
            List<Schema.PicklistEntry> ple = field.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
                listOptions.add(f.getValue());
            }
            
            result.put(field.Name, listOptions);
        }
        
        return result;
    }
    
    @RemoteAction 
    global static boolean getIsLeCercleBroadCaster(){
        String leCercleBrandId;
        List<ESN_MB_NodePage__c> brandLeCercle = [select id, ESN_MB_Deployment_Status__c from ESN_MB_NodePage__c Where RecordType.DeveloperName = 'ESN_MB_Brand' AND Name =: Label.ESN_MB_LeCercle LIMIT 1];
        if (brandLeCercle.size() > 0) {
            for(ESN_MB_NodePage__c brand : brandLeCercle) {
                leCercleBrandId = brand.Id;
            }   
            return ESN_MB_UtilsUser.isBroadCasterUser(leCercleBrandId);
        } else {
            return false;
        }
    }

    public String getPortfolioBackground() {
        String leCercleBrandId;
        List<ESN_MB_NodePage__c> brandLeCercle = [select id, ESN_MB_Deployment_Status__c from ESN_MB_NodePage__c Where RecordType.DeveloperName = 'ESN_MB_Brand' AND Name =: Label.ESN_MB_LeCercle LIMIT 1];
        for(ESN_MB_NodePage__c brand : brandLeCercle) {
            leCercleBrandId = brand.Id;
        }
        
        List <ESN_MB_Entry__c> resourceId =  [Select ESN_MB_Resource__c from ESN_MB_Entry__c where ESN_MB_Resource__r.ESN_MB_Type__c='PortfolioBackground' and ESN_MB_Node_Page__r.Id = :leCercleBrandId];
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
    
    public String getMoreApps(){
        Map<String, ESN_MB_MoreApps__c> apps = ESN_MB_MoreApps__c.getAll();
        return JSON.serialize(apps.values());
    }
    
	public String getBannerData(){
		List<Id> listContentDocumentId = new List<Id>();
		for(ESN_MB_Banner__c obj : ESN_MB_Banner__c.getall().values()) {
			listContentDocumentId.add(obj.PictureId__c);
		}

		if(listContentDocumentId.size() > 0) {
			List <ContentVersion> listContentVersionId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE IsLatest = true AND ContentDocumentId =: listContentDocumentId];
			for(ContentVersion obj : listContentVersionId) {
				for(ESN_MB_Banner__c data : ESN_MB_Banner__c.getall().values()) {
					if(obj.ContentDocumentId == data.PictureId__c) {
						data.PictureId__c = obj.Id;
					}
				}	
			}
		}

        return JSON.serialize(ESN_MB_Banner__c.getall().values());
    }
}