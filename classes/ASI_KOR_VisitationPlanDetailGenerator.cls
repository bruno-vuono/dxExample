public with sharing class ASI_KOR_VisitationPlanDetailGenerator {
	public static final Date DEF_VALUE_VISIT_DATE = System.today().addDays(1);
	
	public ASI_KOR_Visitation_Plan_Detail__c generateBasicVisitationPlanDetail(ASI_KOR_Visitation_Plan__c visitPlan, Account acct, Date visitDate) {
		return new ASI_KOR_Visitation_Plan_Detail__c(
			ASI_KOR_Visitation_Plan__c = visitPlan.Id
			, ASI_KOR_Wholesaler__c = acct.Id
			, ASI_KOR_Visit_Date__c = visitDate,
             recordtypeid=Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan_Detail__cASI_CRM_KR_Visitation_Plan_Detail_Call_Plan')
		);
	}

	public ASI_KOR_Visitation_Plan_Detail__c generateVisitationPlanDetail(ASI_KOR_Visitation_Plan__c visitPlan, Account acct) {
		return generateBasicVisitationPlanDetail(visitPlan, acct, DEF_VALUE_VISIT_DATE);
	}

	public ASI_KOR_Visitation_Plan_Detail__c generateVisitationPlanDetail(ASI_KOR_Visitation_Plan__c visitPlan, Account acct, Date visitDate) {
		return generateBasicVisitationPlanDetail(visitPlan, acct, visitDate);
	}
}