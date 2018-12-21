public with sharing class ASI_DFPM_PromotionalMstInheritShareRule extends ASI_DFPM_TriggerAbstract {

	public ASI_DFPM_PromotionalMstInheritShareRule() {
		super('ASI_DFPM_PromotionalMstInheritShareRule');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UNDELETE) {
			final ASI_DFPM_SharingRuleHelper.AccessLevel ACCESS_LEVEL_MST = ASI_DFPM_SharingRuleHelper.AccessLevel.EDIT;
			final String SHARING_REASON_MST = Schema.ASI_DFPM_Project_Milestone__Share.RowCause.ASI_DFPM_Project_Owner__c;
			final Set<String> INCLUDED_SHARING_REASONS_MST = new Set<String>{SHARING_REASON_MST};
			
			List<ASI_DFPM_Project_Milestone__c> mstList = [SELECT Id, ASI_DFPM_Promotional_Project__r.OwnerId FROM ASI_DFPM_Project_Milestone__c WHERE Id IN :sObjList];
			
			// Update the sharing rules according to parent project
			ASI_DFPM_SharingRuleHelper sharingRuleHelper = new ASI_DFPM_SharingRuleHelper('ASI_DFPM_Project_Milestone__Share');
			for (ASI_DFPM_Project_Milestone__c mst : mstList) {
				ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest sharingRuleChangeReq = new ASI_DFPM_SharingRuleHelper.ASI_DFPM_ChangeRequest(mst.Id, INCLUDED_SHARING_REASONS_MST);
				sharingRuleChangeReq.addUserOrGroup(mst.ASI_DFPM_Promotional_Project__r.OwnerId, ACCESS_LEVEL_MST, SHARING_REASON_MST);
				sharingRuleHelper.addChangeRequest(sharingRuleChangeReq);
			}
			
			sharingRuleHelper.commitChanges();
		}
	}
}