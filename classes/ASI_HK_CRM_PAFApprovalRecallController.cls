public without sharing class ASI_HK_CRM_PAFApprovalRecallController {
	
	private static final String STATUS_AFTER_RECALL = 'Draft';
	private static final Set<String> STATUS_ALLOW_RECALL = new Set<String> {
		'Submitted'
	};
	public ID pafId { get; private set; }
	
	public ASI_HK_CRM_PAFApprovalRecallController(ApexPages.StandardController stdCon) {
		this.pafId = stdCon.getId();
	}
	
	public PageReference doRecall() {
		PageReference redirectPage = null;
		if (pafId != null) {
			ASI_HK_CRM_Pre_Approval_Form__c paf = [SELECT Id, OwnerId, ASI_HK_CRM_PAF_Status__c FROM ASI_HK_CRM_Pre_Approval_Form__c WHERE Id = :pafId];
			if (UserInfo.getUserId() != paf.OwnerId) {
				showPageError('You are not the owner of this record');
			} else if (!STATUS_ALLOW_RECALL.contains(paf.ASI_HK_CRM_PAF_Status__c)) {
				showPageError('The current approval stage cannot be recalled');
			} else {
				ProcessInstanceWorkitem workitem = workitemFromRecordId(pafId);
				if (workitem != null) {
					Approval.ProcessWorkitemRequest recallReq = new Approval.ProcessWorkitemRequest();
					recallReq.setWorkitemId(workitem.Id);
					recallReq.setAction('Removed');
					paf.ASI_HK_CRM_PAF_Status__c = STATUS_AFTER_RECALL;
					System.Savepoint sp = database.setSavepoint();
					try {
						update paf;
						Approval.ProcessResult recallResult = Approval.process(recallReq);
						redirectPage = new PageReference('/' + pafId);
					} catch (Exception e) {
						database.rollback(sp);
						showPageError(e.getMessage());
					}
				} else {
					showPageError('No approval process is running');
				}
			}
		} else {
			showPageError('Invalid ID');
		}
		return redirectPage;
	}
	
	private ProcessInstanceWorkitem workitemFromRecordId(ID recordId) {
		if (recordId == null) return null;
		List<ProcessInstanceWorkitem> workitems = [SELECT Id, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :recordId];
		return (workitems.size() > 0) ? workitems[0] : null;
	}
	
	private void showPageMessage(ApexPages.Severity severity, String msg) { ApexPages.addMessage(new ApexPages.Message(severity, msg)); }
	private void showPageError(String msg) { showPageMessage(ApexPages.Severity.ERROR, msg); }
}