public without sharing class ASI_DFPM_PromotionalTaskParentSummaryUP extends ASI_DFPM_TriggerAbstract {
	
	public ASI_DFPM_PromotionalTaskParentSummaryUP() {
		super('ASI_DFPM_PromotionalTaskParentSummaryUP');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UPDATE
			|| tAction == TriggerAction.AFTER_DELETE || tAction == TriggerAction.AFTER_UNDELETE) {
			Set<ID> parentPjIdSet = new Set<ID>();
			Set<ID> parentMstIdSet = new Set<ID>();
			List<ASI_DFPM_Project_Task__c> taskList = (List<ASI_DFPM_Project_Task__c>)sObjList;
			for (ASI_DFPM_Project_Task__c theTask : taskList) {
				if (theTask.ASI_DFPM_Promotional_Project__c != null) {
					parentPjIdSet.add(theTask.ASI_DFPM_Promotional_Project__c);
				}
				if (theTask.ASI_DFPM_Project_Milestone__c != null) {
					parentMstIdSet.add(theTask.ASI_DFPM_Project_Milestone__c);
				}
			}
			System.Savepoint sp = database.setSavepoint();
			try {
				if (parentPjIdSet.size() > 0) {
					ASI_DFPM_PromotionalPjStatisticManager pjStatisticManager = new ASI_DFPM_PromotionalPjStatisticManager();
					List<ASI_DFPM_Promotional_Project__c> parentPjList = pjStatisticManager.getRefreshedProjects(parentPjIdSet);
					update parentPjList;
				}
				if (parentMstIdSet.size() > 0) {
					ASI_DFPM_PromotionalMstStatisticManager mstStatisticManager = new ASI_DFPM_PromotionalMstStatisticManager();
					List<ASI_DFPM_Project_Milestone__c> parentMstList = mstStatisticManager.getRefreshedMilestones(parentMstIdSet);
					update parentMstList;
				}
			} catch (Exception e) {
				database.rollback(sp);
				throw e;
			}
		}
	}
}