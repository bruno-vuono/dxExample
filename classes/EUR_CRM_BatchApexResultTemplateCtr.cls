public with sharing class EUR_CRM_BatchApexResultTemplateCtr {
	private ApexPages.StandardController standardController;
	public AsyncApexJob asyncJob {get;set;}
	
	 public EUR_CRM_BatchApexResultTemplateCtr (ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
        
        asyncJob = retrieveAsyncJob(this.standardController.getId());
    }
    
    private AsyncApexJob retrieveAsyncJob(Id jobId){
    	AsyncApexJob asyncJob = [SELECT Id,
		                             Status,
		                             NumberOfErrors,
		                             JobItemsProcessed,
		                             TotalJobItems,
		                             CompletedDate,
		                             ExtendedStatus,
		                             ApexClass.name,
		                             CreatedBy.Email,
		                             CreatedBy.Name,
		                             CreatedBy.Id
		                      FROM AsyncApexJob 
		                      WHERE Id =:jobId LIMIT 1];
		
		return asyncJob;
    }
}