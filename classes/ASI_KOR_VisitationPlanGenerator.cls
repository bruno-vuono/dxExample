public with sharing class ASI_KOR_VisitationPlanGenerator {
	public static final String DEF_VALUE_NAME = 'Test Visitation';
	public static final String DEF_VALUE_YEAR = String.valueOf(System.today().year());
	public static final String DEF_VALUE_MONTH = 'December';
	private static Map<String, Integer> monthPLValueToIntMap;
	private static List<String> monthPLValueList;
	
	public static Integer convertMonthPLValueToInteger(String plValue) {
		return getMonthPLValueToIntegerMap().get(plValue);
	}
	public static Map<String, Integer> getMonthPLValueToIntegerMap() {
		if (monthPLValueToIntMap == null) {
			monthPLValueToIntMap = new Map<String, Integer>();
			List<Schema.PicklistEntry> monthPLEntryList = ASI_KOR_Visitation_Plan__c.ASI_KOR_Month__c.getDescribe().getPicklistValues();
			Integer month = 0;
			for (Schema.PicklistEntry plEntry : monthPLEntryList) {
				if (plEntry.isActive() && plEntry.getLabel() != null && plEntry.getLabel().trim() != '') {
					month++;
					monthPLValueToIntMap.put(plEntry.getValue(), month);
				}
			}
		}
		return monthPLValueToIntMap;
	}
	/*public static List<String> getMonthPLValueList() {
		if (monthPLValueList == null) {
			monthPLValueList = new List<String>();
			List<Schema.PicklistEntry> monthPLEntryList = ASI_KOR_Visitation_Plan__c.ASI_KOR_Month__c.getDescribe().getPicklistValues();
			for (Schema.PicklistEntry plEntry : monthPLEntryList) {
				if (plEntry.isActive() && plEntry.getLabel() != null && plEntry.getLabel().trim() != '') {
					monthPLValueList.add(plEntry.getValue());
				}
			}
		}
		return monthPLValueList;
	}*/
	
	public ASI_KOR_Visitation_Plan__c generateBasicVisitationPlan(String name, String theYear, String theMonth) {
		return new ASI_KOR_Visitation_Plan__c(
			Name = name
			, ASI_KOR_Year__c = theYear
			, ASI_KOR_Month__c = theMonth
		);
	}

	public ASI_KOR_Visitation_Plan__c generateVisitationPlan() {
		ASI_KOR_Visitation_Plan__c result = generateBasicVisitationPlan(DEF_VALUE_NAME, DEF_VALUE_YEAR, DEF_VALUE_MONTH);
		return result;
	}
	
	public ASI_KOR_Visitation_Plan_Detail__c generateBasicVisitationPlanDetail(ASI_KOR_Visitation_Plan__c visit, Account acct, Date visitDate) {
		return new ASI_KOR_Visitation_Plan_Detail__c(
			ASI_KOR_Visitation_Plan__c = visit.Id
			, ASI_KOR_Wholesaler__c = acct.Id
			, ASI_KOR_Visit_Date__c = visitDate
		);
	}

	public ASI_KOR_Visitation_Plan_Detail__c generateVisitationPlanDetail(ASI_KOR_Visitation_Plan__c visit, Account acct, Date visitDate) {
		ASI_KOR_Visitation_Plan_Detail__c result = generateBasicVisitationPlanDetail(visit, acct, visitDate);
		return result;
	}

}