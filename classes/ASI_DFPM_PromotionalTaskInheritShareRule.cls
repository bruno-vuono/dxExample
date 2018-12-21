public with sharing class ASI_DFPM_PromotionalTaskInheritShareRule extends ASI_DFPM_TriggerAbstract {

	public ASI_DFPM_PromotionalTaskInheritShareRule() {
		super('ASI_DFPM_PromotionalTaskInheritShareRule');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UNDELETE) {
			final ASI_DFPM_SharingRuleHelper.AccessLevel ACCESS_LEVEL_FROM_PJ = ASI_DFPM_SharingRuleHelper.AccessLevel.EDIT;
			final ASI_DFPM_SharingRuleHelper.AccessLevel ACCESS_LEVEL_FROM_MST = ASI_DFPM_SharingRuleHelper.AccessLevel.EDIT;
			final String SHARING_REASON_FROM_PJ = Schema.ASI_DFPM_Project_Task__Share.RowCause.ASI_DFPM_Project_Owner__c;
			final String SHARING_REASON_FROM_MST = Schema.ASI_DFPM_Project_Task__Share.RowCause.ASI_DFPM_Milestone_Owner__c;
			final Set<String> INCLUDED_SHARING_REASONS = new Set<String>{SHARING_REASON_FROM_PJ, SHARING_REASON_FROM_MST};
			
			List<ASI_DFPM_Project_Task__c> tkList = [SELECT Id, ASI_DFPM_Project_Milestone__r.OwnerId, ASI_DFPM_Project_Milestone__r.ASI_DFPM_Promotional_Project__r.OwnerId FROM ASI_DFPM_Project_Task__c WHERE Id IN :sObjList];
			
			// Update the sharing rules according to parent project and milestone
			ASI_DFPM_SharingRuleHelper sharingRuleHelper = new ASI_DFPM_SharingRuleHelper('ASI_DFPM_Project_Task__Share');
			for (ASI_DFPM_Project_Task__c tk : tkList) {
				ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest sharingRuleChangeReq = new ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest(tk.Id, INCLUDED_SHARING_REASONS);
				sharingRuleChangeReq.addUserOrGroup(tk.ASI_DFPM_Project_Milestone__r.ASI_DFPM_Promotional_Project__r.OwnerId, ACCESS_LEVEL_FROM_PJ, SHARING_REASON_FROM_PJ);
				sharingRuleChangeReq.addUserOrGroup(tk.ASI_DFPM_Project_Milestone__r.OwnerId, ACCESS_LEVEL_FROM_MST, SHARING_REASON_FROM_MST);
				sharingRuleHelper.addChangeRequest(sharingRuleChangeReq);
			}
			
			sharingRuleHelper.commitChanges();
		}
	}
}