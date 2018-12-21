public with sharing class ASI_DFPM_PromotionalProjectOwnerChange extends ASI_DFPM_TriggerAbstract {

	public ASI_DFPM_PromotionalProjectOwnerChange() {
		super('ASI_DFPM_PromotionalProjectOwnerChange');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_UPDATE) {
			List<ASI_DFPM_Promotional_Project__c> pjList = (List<ASI_DFPM_Promotional_Project__c>)sObjList;
			Map<ID, ASI_DFPM_Promotional_Project__c> oldPjMap = (Map<ID, ASI_DFPM_Promotional_Project__c>)oldMap;
			// Find all milstones whose owner is changed
			Set<ID> ownerChangedPjIdSet = new Set<ID>();
			for (ASI_DFPM_Promotional_Project__c pj : pjList) {
				if (oldMap == null || oldPjMap.get(pj.Id).OwnerId != pj.OwnerId)
					ownerChangedPjIdSet.add(pj.Id);
			}
			
			if (ownerChangedPjIdSet.size() > 0) {
				final ASI_DFPM_SharingRuleHelper.AccessLevel ACCESS_LEVEL_MST = ASI_DFPM_SharingRuleHelper.AccessLevel.EDIT;
				final ASI_DFPM_SharingRuleHelper.AccessLevel ACCESS_LEVEL_TASK = ASI_DFPM_SharingRuleHelper.AccessLevel.EDIT;
				final String SHARING_REASON_MST = Schema.ASI_DFPM_Project_Milestone__Share.RowCause.ASI_DFPM_Project_Owner__c;
				final String SHARING_REASON_TASK = Schema.ASI_DFPM_Project_Task__Share.RowCause.ASI_DFPM_Project_Owner__c;
				final Set<String> INCLUDED_SHARING_REASONS_MST = new Set<String>{SHARING_REASON_MST};
				final Set<String> INCLUDED_SHARING_REASONS_TASK = new Set<String>{SHARING_REASON_TASK};
				
				// Query relevant milestones and their child tasks
				List<ASI_DFPM_Project_Milestone__c> pjMstsAndTasksList = [SELECT Id, OwnerId, ASI_DFPM_Promotional_Project__c, ASI_DFPM_Promotional_Project__r.OwnerId, (SELECT Id, OwnerId FROM ASI_DFPM_Project_Tasks__r) FROM ASI_DFPM_Project_Milestone__c WHERE ASI_DFPM_Promotional_Project__c IN :ownerChangedPjIdSet];
				// Update the sharing rules
				ASI_DFPM_SharingRuleHelper sharingRuleHelperMst = new ASI_DFPM_SharingRuleHelper('ASI_DFPM_Project_Milestone__Share');
				ASI_DFPM_SharingRuleHelper sharingRuleHelperTask = new ASI_DFPM_SharingRuleHelper('ASI_DFPM_Project_Task__Share');
				for (ASI_DFPM_Project_Milestone__c pjMstsAndTasks : pjMstsAndTasksList) {
					ID pjOwnerId = pjMstsAndTasks.ASI_DFPM_Promotional_Project__r.OwnerId;
					
					// Handle milestone sharing rules
					ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest sharingRuleChangeReqMst = new ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest(pjMstsAndTasks.Id, INCLUDED_SHARING_REASONS_MST);
					sharingRuleChangeReqMst.addUserOrGroup(pjOwnerId, ACCESS_LEVEL_MST, SHARING_REASON_MST);
					sharingRuleHelperMst.addChangeRequest(sharingRuleChangeReqMst);
					
					// Handle task sharing rules
					if (pjMstsAndTasks.ASI_DFPM_Project_Tasks__r != null) {
						for (ASI_DFPM_Project_Task__c tk : pjMstsAndTasks.ASI_DFPM_Project_Tasks__r) {
							ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest sharingRuleChangeReqTask = new ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest(tk.Id, INCLUDED_SHARING_REASONS_TASK);
							sharingRuleChangeReqTask.addUserOrGroup(pjOwnerId, ACCESS_LEVEL_TASK, SHARING_REASON_TASK);
							sharingRuleHelperTask.addChangeRequest(sharingRuleChangeReqTask);
						}
					}
				}
				
				// Commit sharing rule changes to database
				System.Savepoint sp = database.setSavepoint();
				try {
					sharingRuleHelperMst.commitChanges();
					sharingRuleHelperTask.commitChanges();
				} catch (Exception e) {
					database.rollback(sp);
					throw e;
				}
			}
		}
	}
}