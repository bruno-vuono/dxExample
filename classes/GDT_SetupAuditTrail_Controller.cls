public with sharing class GDT_SetupAuditTrail_Controller {

	private final sObject mysObject;

	public Date dt_StartDateForList_SetupAuditTrail {get;set;}
	public Date dt_EndDateForList_SetupAuditTrail {get;set;}

	// The extension constructor initializes the private member
	// variable mysObject by using the getRecord method from the standard
	// controller.
	public GDT_SetupAuditTrail_Controller(ApexPages.StandardController stdController) {
		//this.mysObject = (sObject)stdController.getRecord();
		
	}

	/**
	 * [runBatch description]
	 */
	public void runBatch(){
		
		Integer MAX_BATCHES = 5;
		Integer runningBatchJobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex' AND STATUS IN ('Queued', 'Processing', 'Preparing')];

		if(runningBatchJobs >= MAX_BATCHES){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No resources available.  Please try again later.'));
		}
		else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Records are being updated. An email will be sent once achived.'));

			GDT_SetupAuditTrail_Batch myBatchObject = new GDT_SetupAuditTrail_Batch();
			ID batchprocessid = Database.executebatch(myBatchObject);
		}
	}

	/**
	 * List Setup Audit Trail
	 */
	public List<GDT_Setup_Audit_Trail__c> cSetupAuditTrail {//get;set;}
	
		get {
			if (dt_StartDateForList_SetupAuditTrail == NULL && dt_EndDateForList_SetupAuditTrail != NULL){
				return [SELECT Action__c,CreatedDate__c,CreatedById__r.Name,DelegateUser__c,Display__c,Section__c FROM GDT_Setup_Audit_Trail__c WHERE CreatedDate__c <:dt_EndDateForList_SetupAuditTrail.addDays(1) ORDER BY CreatedDate__c DESC NULLS FIRST LIMIT 10000];
			}
			else if (dt_StartDateForList_SetupAuditTrail != NULL && dt_EndDateForList_SetupAuditTrail == NULL){
				return [SELECT Action__c,CreatedDate__c,CreatedById__r.Name,DelegateUser__c,Display__c,Section__c FROM GDT_Setup_Audit_Trail__c WHERE CreatedDate__c >=:dt_StartDateForList_SetupAuditTrail ORDER BY CreatedDate__c ASC NULLS FIRST LIMIT 10000];
			}
			else if (dt_StartDateForList_SetupAuditTrail != NULL && dt_EndDateForList_SetupAuditTrail != NULL){
				return [SELECT Action__c,CreatedDate__c,CreatedById__r.Name,DelegateUser__c,Display__c,Section__c FROM GDT_Setup_Audit_Trail__c WHERE CreatedDate__c >=:dt_StartDateForList_SetupAuditTrail AND CreatedDate__c <:dt_EndDateForList_SetupAuditTrail.addDays(1) ORDER BY CreatedDate__c DESC NULLS FIRST LIMIT 10000];
			}
			else{
				return [SELECT Action__c,CreatedDate__c,CreatedById__r.Name,DelegateUser__c,Display__c,Section__c FROM GDT_Setup_Audit_Trail__c ORDER BY CreatedDate__c DESC NULLS FIRST LIMIT 10000];
			}
		}
		set;
	}
	
	public void changeStartDate(){}
}