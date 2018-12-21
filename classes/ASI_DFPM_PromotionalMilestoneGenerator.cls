public with sharing class ASI_DFPM_PromotionalMilestoneGenerator {
	public static final String DEF_VALUE_NAME = 'Test Milestone';
	public static final Date DEF_VALUE_START_DATE = System.today();
	public static final Decimal DEF_VALUE_DURATION = 6;

	private static Map<String, RecordType> RTMap {
		get {
			if (RTMap == null) {
				RTMap = new Map<String, RecordType>();
			}
			return RTMap;
		}
		set;
	}

	public static RecordType getRecordTypeByDevName(String devName) { return RTMap.get(devName); }
	
	public ASI_DFPM_Project_Milestone__c generateBasicMilestone(ASI_DFPM_Promotional_Project__c pj) {
		return new ASI_DFPM_Project_Milestone__c(
			Name = DEF_VALUE_NAME
			, ASI_DFPM_Promotional_Project__c = pj.Id
			, ASI_DFPM_Start_Date__c = DEF_VALUE_START_DATE
			, ASI_DFPM_Duration__c = DEF_VALUE_DURATION
		);
	}

	public ASI_DFPM_Project_Milestone__c generateMilestone(ASI_DFPM_Promotional_Project__c pj) {
		ASI_DFPM_Project_Milestone__c result = generateBasicMilestone(pj);
		return result;
	}

	public List<ASI_DFPM_Project_Milestone__c> generateMilestonesInSequence(ASI_DFPM_Promotional_Project__c pj, Integer numOfMst, Integer numOfTasksPerMst, Decimal taskDuration) {
		List<ASI_DFPM_Project_Milestone__c> resultList = new List<ASI_DFPM_Project_Milestone__c>();
		if (numOfTasksPerMst == null) numOfTasksPerMst = 1;
		Decimal duration = taskDuration == null ? DEF_VALUE_DURATION : taskDuration;
		for (Integer i = 0; i < numOfMst; i++) {
    		ASI_DFPM_Project_Milestone__c mst = generateMilestone(pj);
    		mst.ASI_DFPM_Start_Date__c = DEF_VALUE_START_DATE.addDays(i * numOfTasksPerMst * duration.intValue());
			mst.ASI_DFPM_Duration__c = duration * numOfTasksPerMst;
    		resultList.add(mst);
    	}
		return resultList;
	}

}