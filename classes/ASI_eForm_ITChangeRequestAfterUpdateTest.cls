@isTest
private class ASI_eForm_ITChangeRequestAfterUpdateTest
{

    @isTest
    public static void testITChangeRequestAfterUpdateError()
    {
      User currentUser = ASI_eForm_TestClassHelper.createUser();
      Map<String,User> mapUser = new Map<String,User>();
      mapUser.put('owner',currentUser);
      
      //ASI_eForm_TestClassHelper.createRunningNumbers();
      try {
      ASI_eForm_IT_Change_Request__c  itChangeRequest = ASI_eForm_TestClassHelper.createITChangeRequest(mapUser);  
      
      /*
      List<ASI_eForm_IT_Change_Request_Item__c>  itChangeReqItems = ASI_eForm_TestClassHelper.createITChangeRequestItems(itChangeRequest,mapUser);    
      itChangeRequest.ASI_eForm_Status__c = 'Final';
      RecordType hkFinalRecordType = [SELECT Id from RecordType where DeveloperName = 'ASI_eForm_HK_IT_Change_Request_Final'];
      itChangeRequest.RecordTypeId = hkFinalRecordType.Id;
      update itChangeRequest;
      */
      
      } catch (Exception e)
      {
      
      
      }
      /*
      itChangeReqItems.get(0).ASI_eForm_IT_Action__c = 'Invalid Submission';
      
      update itChangeReqItems;  
      */
    }
    
    @isTest
    public static void testITChangeRequestAfterUpdateHK()
    {
      User currentUser = ASI_eForm_TestClassHelper.createUser();
      Map<String,User> mapUser = new Map<String,User>();
      mapUser.put('owner',currentUser);
      
      ASI_eForm_TestClassHelper.createRunningNumbers();
      
      ASI_eForm_IT_Change_Request__c  itChangeRequest = ASI_eForm_TestClassHelper.createITChangeRequest(mapUser);  
      List<ASI_eForm_IT_Change_Request_Item__c>  itChangeReqItems = ASI_eForm_TestClassHelper.createITChangeRequestItems(itChangeRequest,mapUser);    
      itChangeRequest.ASI_eForm_Status__c = 'Final';
      RecordType hkFinalRecordType = [SELECT Id from RecordType where DeveloperName = 'ASI_eForm_HK_IT_Change_Request_Final'];
      itChangeRequest.RecordTypeId = hkFinalRecordType.Id;
      update itChangeRequest;
      
      itChangeReqItems.get(0).ASI_eForm_IT_Action__c = 'Invalid Submission';
      
      update itChangeReqItems;  
    
    }
    
    @isTest
    public static void testITChangeRequestAfterUpdateCN()
    {
      User currentUser = ASI_eForm_TestClassHelper.createUser();
      Map<String,User> mapUser = new Map<String,User>();
      mapUser.put('owner',currentUser);
      
      ASI_eForm_TestClassHelper.createRunningNumbers();
      
      ASI_eForm_IT_Change_Request__c  itChangeRequest = ASI_eForm_TestClassHelper.createITChangeRequestCN(mapUser);  
      List<ASI_eForm_IT_Change_Request_Item__c>  itChangeReqItems = ASI_eForm_TestClassHelper.createITChangeRequestItems(itChangeRequest,mapUser);    
      itChangeRequest.ASI_eForm_Status__c = 'Final';
      RecordType hkFinalRecordType = [SELECT Id from RecordType where DeveloperName = 'ASI_eForm_CN_IT_Change_Request_Final'];
      itChangeRequest.RecordTypeId = hkFinalRecordType.Id;
      update itChangeRequest;
      
      itChangeReqItems.get(0).ASI_eForm_IT_Action__c = 'Invalid Submission';
      
      update itChangeReqItems;  
    
    }

}