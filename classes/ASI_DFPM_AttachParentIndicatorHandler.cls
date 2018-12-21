public with sharing class ASI_DFPM_AttachParentIndicatorHandler extends ASI_DFPM_TriggerAbstract {
	
	private static final String ID_PREFIX_PMT_TASK = Schema.SObjectType.ASI_DFPM_Project_Task__c.getKeyPrefix();
	
	public ASI_DFPM_AttachParentIndicatorHandler() {
		super('ASI_DFPM_AttachParentIndicatorHandler');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UPDATE
			|| tAction == TriggerAction.AFTER_DELETE || tAction == TriggerAction.AFTER_UNDELETE) {
			Set<ID> parentPmtTaskIdSet = new Set<ID>();
			List<Attachment> attachList = (List<Attachment>)sObjList;
			for (Attachment attach : attachList) {
				String parentIdStr = String.valueOf(attach.ParentId);
				if (parentIdStr.indexOf(ID_PREFIX_PMT_TASK) == 0) {
					parentPmtTaskIdSet.add(attach.ParentId);
				}
			}
			
			if (parentPmtTaskIdSet.size() > 0) {
				ASI_DFPM_PromotionalTaskStatisticManager pmtTkStatisticManager = new ASI_DFPM_PromotionalTaskStatisticManager();
				List<ASI_DFPM_Project_Task__c> parentPmtTkList = pmtTkStatisticManager.getRefreshedTasks(parentPmtTaskIdSet);
				update parentPmtTkList;
			}
		}
	}
}