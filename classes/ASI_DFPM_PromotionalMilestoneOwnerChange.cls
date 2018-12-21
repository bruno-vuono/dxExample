public with sharing class ASI_DFPM_PromotionalMilestoneOwnerChange extends ASI_DFPM_TriggerAbstract {

	public ASI_DFPM_PromotionalMilestoneOwnerChange() {
		super('ASI_DFPM_PromotionalMilestoneOwnerChange');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_UPDATE) {
			List<ASI_DFPM_Project_Milestone__c> mstList = (List<ASI_DFPM_Project_Milestone__c>)sObjList;
			Map<ID, ASI_DFPM_Project_Milestone__c> oldMstMap = (Map<ID, ASI_DFPM_Project_Milestone__c>)oldMap;
			// Find all milstones whose owner is changed
			Set<ID> ownerChangedMstIdSet = new Set<ID>();
			for (ASI_DFPM_Project_Milestone__c mst : mstList) {
				if (oldMap == null || oldMstMap.get(mst.Id).OwnerId != mst.OwnerId)
					ownerChangedMstIdSet.add(mst.Id);
			}
			
			if (ownerChangedMstIdSet.size() > 0) {
				final ASI_DFPM_SharingRuleHelper.AccessLevel ACCESS_LEVEL_TASK = ASI_DFPM_SharingRuleHelper.AccessLevel.EDIT;
				final String SHARING_REASON_TASK = Schema.ASI_DFPM_Project_Task__Share.RowCause.ASI_DFPM_Milestone_Owner__c;
				final Set<String> INCLUDED_SHARING_REASONS_TASK = new Set<String>{SHARING_REASON_TASK};
				
				// Query the milestone and child tasks
				List<ASI_DFPM_Project_Milestone__c> mstAndTasksList = [SELECT Id, OwnerId, (SELECT Id, OwnerId FROM ASI_DFPM_Project_Tasks__r) FROM ASI_DFPM_Project_Milestone__c WHERE Id IN :ownerChangedMstIdSet];
				// Update the sharing rules of child tasks
				ASI_DFPM_SharingRuleHelper sharingRuleHelper = new ASI_DFPM_SharingRuleHelper('ASI_DFPM_Project_Task__Share');
				for (ASI_DFPM_Project_Milestone__c mstAndTasks : mstAndTasksList) {
					if (mstAndTasks.ASI_DFPM_Project_Tasks__r != null) {
						ID mstOwnerId = mstAndTasks.OwnerId;
						for (ASI_DFPM_Project_Task__c tk : mstAndTasks.ASI_DFPM_Project_Tasks__r) {
							ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest sharingRuleChangeReq = new ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest(tk.Id, INCLUDED_SHARING_REASONS_TASK);
							sharingRuleChangeReq.addUserOrGroup(mstOwnerId, ACCESS_LEVEL_TASK, SHARING_REASON_TASK);
							sharingRuleHelper.addChangeRequest(sharingRuleChangeReq);
						}
					}
				}
				
				sharingRuleHelper.commitChanges();
			}
		}
	}
}