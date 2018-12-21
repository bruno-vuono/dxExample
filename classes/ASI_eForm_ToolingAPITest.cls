@isTest
public class ASI_eForm_ToolingAPITest
{
  public static String customObjectResponse = '{"size":4,"totalSize":4,"done":true,"queryLocator":null,'+
  '"entityTypeName":"CustomEntityDefinition","records":[{"attributes":{"type":"CustomObject",'+
  '"url":"/services/data/v29.0/tooling/sobjects/CustomObject/01IM00000000tcoMAA"},"Id":"01IM00000000tcoMAA",'+
  '"DeveloperName":"ASI_eForm_IT_Change_Request","NamespacePrefix":null},{"attributes":{"type":"CustomObject",'+
  '"url":"/services/data/v29.0/tooling/sobjects/CustomObject/01IM00000000tcqMAA"},"Id":"01IM00000000tcqMAA",'+
  '"DeveloperName":"ASI_eForm_IT_Procurement_Service_Request","NamespacePrefix":null},{"attributes":'+
  '{"type":"CustomObject","url":"/services/data/v29.0/tooling/sobjects/CustomObject/01IM00000000tctMAA"},'+
  '"Id":"01IM00000000tctMAA","DeveloperName":"ASI_eForm_Pre_Trip_Approval","NamespacePrefix":null},{"attributes":'+
  '{"type":"CustomObject","url":"/services/data/v29.0/tooling/sobjects/CustomObject/01IM00000000tcxMAA"},'+
  '"Id":"01IM00000000tcxMAA","DeveloperName":"ASI_eForm_User_ID_Request","NamespacePrefix":null}]}';

  @isTest
  public static void testToolingAPIController()
  {
    
    ASI_eForm_TestClassHelper.createPrefillCustomSetting();
    ASI_eForm_ToolingController toolingController = new ASI_eForm_ToolingController();
    ASI_eForm_ToolingAPI apiToolingAPI = new ASI_eForm_ToolingAPI('sessionId');
    
    ASI_eForm_ToolingAPI.CustomObject customObject = new ASI_eForm_ToolingAPI.CustomObject();
    System.assert(customObject.Id==null,'Is not null');
    System.assert(customObject.DeveloperName==null,'Is not null');
    System.assert(customObject.NamespacePrefix==null,'Is not null');
    System.assert(customObject.customFields==null,'Is not null');
  
    ASI_eForm_ToolingAPI.CustomField customField = new ASI_eForm_ToolingAPI.CustomField();
    System.assert(customField.Id==null,'Is not null');
    System.assert(customField.DeveloperName==null,'Is not null');
    System.assert(customField.NamespacePrefix==null,'Is not null');
    System.assert(customField.TableEnumOrId==null,'Is not null');
    
    
    ASI_eForm_ToolingAPI.ErrorResponse errorResponse = new ASI_eForm_ToolingAPI.ErrorResponse();
    System.assert(errorResponse.errorCode==null,'Is not null');
    System.assert(errorResponse.message==null,'Is not null');
    
    ASI_eForm_ToolingAPI.CustomObjectQueryResult queryResult = new ASI_eForm_ToolingAPI.CustomObjectQueryResult();
    System.assert(queryResult.size==null,'Is not null');
    System.assert(queryResult.totalSize==null,'Is not null');
    System.assert(queryResult.done==null,'Is not null');  
  
  }

}