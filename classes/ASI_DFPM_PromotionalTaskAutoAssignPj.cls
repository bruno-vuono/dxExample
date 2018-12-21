public with sharing class ASI_DFPM_PromotionalTaskAutoAssignPj extends ASI_DFPM_TriggerAbstract {

	public ASI_DFPM_PromotionalTaskAutoAssignPj() {
		super('ASI_DFPM_PromotionalTaskAutoAssignPj');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE) {
			List<ASI_DFPM_Project_Task__c> taskList = (List<ASI_DFPM_Project_Task__c>)sObjList;
			// Query all project IDs of relevant milestones
			Set<ID> mstIdSet = new Set<ID>();
			for (ASI_DFPM_Project_Task__c tk : taskList) {
				mstIdSet.add(tk.ASI_DFPM_Project_Milestone__c);
			}
			Map<ID, ASI_DFPM_Project_Milestone__c> mstMap = new Map<ID, ASI_DFPM_Project_Milestone__c>([SELECT Id, ASI_DFPM_Promotional_Project__c FROM ASI_DFPM_Project_Milestone__c WHERE Id IN :mstIdSet]);
			
			// Assign the correct project
			for (ASI_DFPM_Project_Task__c tk : taskList) {
				ASI_DFPM_Project_Milestone__c mst = mstMap.get(tk.ASI_DFPM_Project_Milestone__c);
				tk.ASI_DFPM_Promotional_Project__c = mst.ASI_DFPM_Promotional_Project__c;
			}
		}
	}

}