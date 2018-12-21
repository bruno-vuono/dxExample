public without sharing class ASI_DFPM_PromotionalMstParentSummaryUP extends ASI_DFPM_TriggerAbstract {
	
	public ASI_DFPM_PromotionalMstParentSummaryUP() {
		super('ASI_DFPM_PromotionalMstParentSummaryUP');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UPDATE
			|| tAction == TriggerAction.AFTER_DELETE || tAction == TriggerAction.AFTER_UNDELETE) {
			Set<ID> parentPjIdSet = new Set<ID>();
			List<ASI_DFPM_Project_Milestone__c> mstList = (List<ASI_DFPM_Project_Milestone__c>)sObjList;
			for (ASI_DFPM_Project_Milestone__c mst : mstList) {
				if (mst.ASI_DFPM_Promotional_Project__c != null) {
					parentPjIdSet.add(mst.ASI_DFPM_Promotional_Project__c);
				}
			}
			if (parentPjIdSet.size() > 0) {
				ASI_DFPM_PromotionalPjStatisticManager pjStatisticManager = new ASI_DFPM_PromotionalPjStatisticManager();
				List<ASI_DFPM_Promotional_Project__c> parentPjList = pjStatisticManager.getRefreshedProjects(parentPjIdSet);
				update parentPjList;
			}
		}
	}
}