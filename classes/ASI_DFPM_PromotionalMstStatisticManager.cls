public without sharing class ASI_DFPM_PromotionalMstStatisticManager {
	
	private ASI_DFPM_ChildRecordSummaryHelper summaryHelper;
	
	public ASI_DFPM_PromotionalMstStatisticManager() {
		this.summaryHelper = new ASI_DFPM_ChildRecordSummaryHelper('ASI_DFPM_Project_Milestone__c');
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Task__c', 'ASI_DFPM_Project_Tasks__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT
		));
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Complete_Task__c', 'ASI_DFPM_Project_Tasks__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT, null
			, 'ASI_DFPM_Complete__c', true
		));
		this.summaryHelper.addSummarySetting(new ASI_DFPM_ChildRecordSummaryHelper.ChildRecordSummarySetting(
			'ASI_DFPM_Total_Overdue_Task__c', 'ASI_DFPM_Project_Tasks__r'
			, ASI_DFPM_ChildRecordSummaryHelper.SummaryType.COUNT, null
			, 'ASI_DFPM_Overdue__c', 'Yes'
		));
	}
	
	public List<ASI_DFPM_Project_Milestone__c> getRefreshedMilestones(Set<ID> mstIdSet) {
		Map<ID, ASI_DFPM_Project_Milestone__c> mstMap = new Map<ID, ASI_DFPM_Project_Milestone__c>([SELECT Id
			, ASI_DFPM_Total_Task__c
			, ASI_DFPM_Total_Complete_Task__c
			, ASI_DFPM_Total_Overdue_Task__c
			FROM ASI_DFPM_Project_Milestone__c WHERE Id IN :mstIdSet
		]);
		List<ASI_DFPM_Project_Milestone__c> mstList = mstMap.values();
		Set<ID> updatedIdSet = this.summaryHelper.refreshSummaryValues(mstList);
		List<ASI_DFPM_Project_Milestone__c> updatedMstList = new List<ASI_DFPM_Project_Milestone__c>();
		for (ID updatedId : updatedIdSet) {
			ASI_DFPM_Project_Milestone__c tempMst = mstMap.get(updatedId);
			if (tempMst != null)
				updatedMstList.add(tempMst);
		}
		return updatedMstList;
	}
}