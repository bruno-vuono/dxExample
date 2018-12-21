/**********************************************************************************
 * Name : ASI_HK_SubmitApprovalHelperController
 
 * Revision History:
 * 1. 2018-04-30	Wilken Lee		[WL 1.0] Add Try Catch handling when update SO
 **********************************************************************************/
public with sharing class ASI_HK_SubmitApprovalHelperController {
    public ASI_HK_SubmitApprovalHelperController(){
    }
    
    public PageReference submitHelper(){
        string id = apexpages.currentpage().getparameters().get('id');
        //System.debug('Test');
        // Modified 201512 Ray
        ASI_HK_CRM_Sales_Order__c soList = [SELECT Id, ASI_HK_CRM_Order_Status_Name__c ,ASI_CRM_HK_has_rejected__c
                                            FROM ASI_HK_CRM_Sales_Order__c
                                            WHERE Id =: id LIMIT 1];
                                            
        if(soList.ASI_CRM_HK_has_rejected__c==true){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot submit a rejected SO.'));
            return null;
        }
        
        if(soList.ASI_HK_CRM_Order_Status_Name__c !='Draft'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot submit a non-Draft SO.'));
            return null;
        }
                                            
                                             
        soList.ASI_HK_CRM_Order_Status_Name__c = 'Interfaced to JDE';
        //System.debug('Interfaced to JDE     '+soList.ASI_HK_CRM_Order_Status_Name__c );
		
		/*[WL 1.0] BEGIN*/
		try {
			update soList;  
		}
		catch (Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
			return null;
		}
		/*[WL 1.0] END*/
        
        PageReference pageRef = new PageReference('/'+id);
        return pageRef;
    }
}