public class ASI_eForm_ToolingController {

    public List<ASI_eForm_ToolingAPI.CustomField> customFields {get;set;}
    public List<ASI_eForm_ToolingAPI.CustomObject> customObjects {get;set;}
    
    public ASI_eForm_ToolingController() {
        init();
    }

  
    public ASI_eForm_ToolingController(ApexPages.StandardController controller) {
    
    }
    
    public void init() {
                ASI_eForm_ToolingAPI toolingAPI = new ASI_eForm_ToolingAPI();
                
                // Query CustomObject object by DeveloperName (note no __c suffix required)
                //List<ASI_eForm_ToolingAPI.CustomObject> 
                List<AggregateResult> customObjectAPIs =
                [SELECT Object_API_Name__c from ASI_eForm_Prefill_Fields__c GROUP BY Object_API_Name__c];
                
                
                String customObjectsQuery = '';
                
                for (AggregateResult customObjectAPI : customObjectAPIs)        
                {
                     if(customObjectsQuery!='' && customObjectAPI.get('Object_API_Name__c') != null)
                    {
                       customObjectsQuery+= ','; 
                    } 
                    
                    if (customObjectAPI.get('Object_API_Name__c') != null)
                    {
                     customObjectsQuery+= '\''+ customObjectAPI.get('Object_API_Name__c')+ '\'';                                                      
                    }                 
                }
                
                customObjectsQuery= '('+customObjectsQuery+')';
                
                //String customObjectsQuery = '(\'ASI_eForm_User_ID_Request\',\'ASI_eForm_IT_Change_Request\',\'ASI_eForm_IT_Procurement_Service_Request\',\'ASI_eForm_Pre_Trip_Approval\')';
                
                customObjects = 
                        toolingAPI.queryCustomObject('DeveloperName In ' + customObjectsQuery).records;
                    
                String customObjectIds = '';
                        
                for (ASI_eForm_ToolingAPI.CustomObject customObject : customObjects)        
                {
                    if(customObjectIds!='')
                    {
                       customObjectIds += ','; 
                    } 
                    customObjectIds += '\''+ customObject.Id + '\'';                                                      
                }
                
                customObjectIds = '('+customObjectIds+')';
                        
                
                // Query CustomField object by TableEnumOrId (use CustomObject Id not name for Custom Objects)
                //ASI_eForm_ToolingAPI.CustomObject customObject = customObjects[0];
                //Id customObjectId = customObject.Id;
                customFields = 
                        toolingAPI.queryCustomField(' TableEnumOrId IN '  + customObjectIds).records;
                
                
                List<ASI_eForm_Prefill_Fields__c> prefillFields = 
                     [SELECT Object_API_Name__c,Field_API_Name__c from ASI_eForm_Prefill_Fields__c];
                     
                Set<String> prefillSets = new Set<String>();
                
                for (ASI_eForm_Prefill_Fields__c prefillField : prefillFields )
                {
                    prefillSets.add(prefillField.Object_API_Name__c+prefillField.Field_API_Name__c);                
                }
                
                for (ASI_eForm_ToolingAPI.CustomObject customObject : customObjects)        
                {
                    customObject.customFields = new List<ASI_eForm_ToolingAPI.CustomField>();                                        
                    for (ASI_eForm_ToolingAPI.CustomField customField: customFields)
                    {
                      if (customObject.Id == customField.TableEnumOrId)
                      {
                        String objFieldAPIName = customObject.DeveloperName+customField.DeveloperName;
                        if (prefillSets.contains(objFieldAPIName))
                        {
                           customObject.customFields.add(customField);   
                        }
                      }                   
                    }
                }                
 
    } 
    
    
}