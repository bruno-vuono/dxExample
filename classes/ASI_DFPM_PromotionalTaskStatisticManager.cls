public with sharing class ASI_DFPM_PromotionalTaskStatisticManager {
	
	private ASI_DFPM_ChildRecordSummaryHelper summaryHelper;
	
	public ASI_DFPM_PromotionalTaskStatisticManager() {
		this.summaryHelper = new ASI_DFPM_ChildRecordSummaryHelper('ASI_DFPM_Project_Task__c');
	}
	
	public List<ASI_DFPM_Project_Task__c> getRefreshedTasks(Set<ID> tkIdSet) {
		Set<ID> updatedIdSet = new Set<ID>();
		Map<ID, ASI_DFPM_Project_Task__c> tkAndAttachsMap = new Map<ID, ASI_DFPM_Project_Task__c>([SELECT Id
			, ASI_DFPM_Has_Attachment__c
			, (SELECT Id FROM Attachments)
			FROM ASI_DFPM_Project_Task__c WHERE Id IN :tkIdSet
		]);
		List<ASI_DFPM_Project_Task__c> tkAndAttachsList = tkAndAttachsMap.values();
		
		// Update ASI_DFPM_Has_Attachment__c field
		ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting attachSetting 
			= new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting('', 'Attachments', ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT);
		for (ASI_DFPM_Project_Task__c tkAndAttachs : tkAndAttachsList) {
			Boolean origHasAttach = tkAndAttachs.ASI_DFPM_Has_Attachment__c;
			Decimal numOfAttach = this.summaryHelper.calculateSummary(tkAndAttachs, attachSetting);
			if ((origHasAttach == true) != (numOfAttach > 0)) {
				tkAndAttachs.ASI_DFPM_Has_Attachment__c = numOfAttach > 0;
				updatedIdSet.add(tkAndAttachs.Id);
			}
		}
		List<ASI_DFPM_Project_Task__c> updatedTkList = new List<ASI_DFPM_Project_Task__c>();
		for (ID updatedId : updatedIdSet) {
			ASI_DFPM_Project_Task__c tempTk = tkAndAttachsMap.get(updatedId);
			if (tempTk != null)
				updatedTkList.add(tempTk);
		}
		return updatedTkList;
	}
}