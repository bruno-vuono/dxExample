/**
    About
    -----
    Description: Shared utilities for MyBrand Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains methods that cover
        - ByPass trigger 
    
    Update History
    --------------
    Jul 2014 / Created by Xavier Defossez

    Issues / TODOs
    --------------
*/

/*public with sharing*/
global class ESN_MB_Utils {

    public static final string bypassTrigger; //List of bypassed triggers
    public static final User user;
    
    static {
        System.debug('*** PAD constructor : BEGIN run by ' +  UserInfo.getName()+ ' User Id: ' + UserInfo.getUserId());
        user = [Select BypassTriggers__c from User where Id=:UserInfo.getUserId() limit 1];
        bypassTrigger = ';'+ user.BypassTriggers__c + ';';                                                                                                                                  
        System.debug('*** PAD constructor : END ***');
    }
    
    /**
    * Method used for the class PAD
    * @param c object of type 
    * @return boolean
    */
    public static boolean canTrigger(string Name){
        return (bypassTrigger.indexof(';' + Name + ';') == -1);
    }
   
    
    /**
    *   Generic shortcut methods 
    *   Used to shorcut common methods sucha as testing null values
    **/
    
    public static Boolean empty(Object o)
    {
        return o==null || String.valueOf(o)=='';
    }
    public static Boolean empty(Integer o)
    {
        return o==null || o==0;
    }
    public static Boolean empty(Decimal o)
    {
        return o==null || o==0;
    }
    public static Boolean empty(List<Object> o)
    {
        return o.size()==0; 
    }
    /*
    public static String strField(List<Object> o)
    {   
        return empty(o) ? empty(o) : '';
    } */
    
     /**** Custom Settings ****/
      
     public static String cs_NPAPIDomain()
    {
        return (String) cs('ESN_MB_NP_API_Domain__c'); 
    } 
    public static String cs_NP_URL()
    {
        return (String) cs('ESN_MB_NP_URL__c'); 
    }
    public static String cs_POS_URL()
    {
        return (String) cs('ESN_MB_POS_URL__c'); 
    }
    public static String cs_NPUser()
    {
        return (String) cs('ESN_MB_NP_User__c'); 
    } 
    public static String cs_NPPassword()
    {
        return (String) cs('ESN_MB_NP_Password__c'); 
    } 
    public static String cs_NewsCoverRubricId()
    {
        return (String) cs('ESN_MB_NewsCover_Rubric_Id__c'); 
    } 
    public static String cs_360ActivationPlatformRubricId()
    {
        return (String) cs('ESN_MB_360ActivationPlatfor_Rubric_Id__c'); 
    } 
    
    static Object cs(String field)
    {
       Object value =  ESN_MB_MyBrandsSettings__c.getOrgDefaults().get(field);
       return value;
    }
    
/*    public static String GetBrandCssStaticResourceURL(String brandName){
        String srName = 'ESN_MB_MyBrands_'+brandName;
        return GetResourceURL(srName);
    }
  */  
        // Pass the resource name
        public static String GetResourceURL(String resourceName){

            // Fetching the resource
            List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];

            // Checking if the result is returned or not
            if(resourceList.size() == 1){

               // Getting namespace
               String namespace = resourceList[0].NamespacePrefix;
               // Resource URL
               return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
            }
            else return '';
        }
       /**
        * Method getRecordTypeId(String recordTypeName)
        * @param recordTypeName: param of type String, recordtype developer Name to get id from
        * @return recordTypeId: returns the record type Id depending on its developerame
        * DeveloperName field is its API name, used to fill the recordTypeId field
        * Dynamically on the creation of a record
        */
        public static String getRecordTypeId(String recordTypeName) {
            String recordTypeId = [select id 
                                   from recordtype 
                                   where DeveloperName = :recordTypeName limit 1].id;
    
            return recordTypeId;
        }

    public static String getBrandNameClean(String brandId) {
        String rawBrandName = [Select Name from ESN_MB_NodePage__c Where id = :brandId].Name;
        String cleanBrandName = rawBrandName.replaceAll('_', ' '); // chivas_regal => chivas regal
        cleanBrandName = cleanBrandName.replaceAll('\'', ''); // ballantine's => ballantines
        return cleanBrandName;
    }

}