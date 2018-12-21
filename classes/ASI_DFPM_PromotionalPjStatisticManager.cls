public without sharing class ASI_DFPM_PromotionalPjStatisticManager {
	
	private ASI_DFPM_ChildRecordSummaryHelper summaryHelper;
	
	public ASI_DFPM_PromotionalPjStatisticManager() {
		this.summaryHelper = new ASI_DFPM_ChildRecordSummaryHelper('ASI_DFPM_Promotional_Project__c');
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Milestone__c', 'Milestones__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT
		));
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Complete_Milestone__c', 'Milestones__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT, null
			, 'ASI_DFPM_Complete__c', true
		));
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Task__c', 'Promotional_Tasks__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT
		));
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Complete_Task__c', 'Promotional_Tasks__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT, null
			, 'ASI_DFPM_Complete__c', true
		));
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Overdue_Task__c', 'Promotional_Tasks__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT, null
			, 'ASI_DFPM_Overdue__c', 'Yes'
		));
	}
	
	public List<ASI_DFPM_Promotional_Project__c> getRefreshedProjects(Set<ID> pjIdSet) {
		Map<ID, ASI_DFPM_Promotional_Project__c> pjMap = new Map<ID, ASI_DFPM_Promotional_Project__c>([SELECT Id
			, ASI_DFPM_Total_Milestone__c
			, ASI_DFPM_Total_Complete_Milestone__c
			, ASI_DFPM_Total_Task__c
			, ASI_DFPM_Total_Complete_Task__c
			, ASI_DFPM_Total_Overdue_Task__c
			FROM ASI_DFPM_Promotional_Project__c WHERE Id IN :pjIdSet
		]);
		List<ASI_DFPM_Promotional_Project__c> pjList = pjMap.values();
		Set<ID> updatedIdSet = this.summaryHelper.refreshSummaryValues(pjList);
		List<ASI_DFPM_Promotional_Project__c> updatedPjList = new List<ASI_DFPM_Promotional_Project__c>();
		for (ID updatedId : updatedIdSet) {
			ASI_DFPM_Promotional_Project__c tempPj = pjMap.get(updatedId);
			if (tempPj != null)
				updatedPjList.add(tempPj);
		}
		return updatedPjList;
	}
}