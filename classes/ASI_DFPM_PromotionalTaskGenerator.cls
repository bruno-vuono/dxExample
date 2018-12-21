public with sharing class ASI_DFPM_PromotionalTaskGenerator {
	public static final String DEF_VALUE_NAME = 'Test Task';
	public static final Date DEF_VALUE_START_DATE = System.today();
	public static final Decimal DEF_VALUE_DURATION = 6;
	public static final String RT_Standard = 'Deleted';

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
	
	public ASI_DFPM_Project_Task__c generateBasicTask(ASI_DFPM_Project_Milestone__c mst) {
		return new ASI_DFPM_Project_Task__c(
			Name = DEF_VALUE_NAME
			, ASI_DFPM_Project_Milestone__c = mst.Id
			, ASI_DFPM_Promotional_Project__c = mst.ASI_DFPM_Promotional_Project__c
			, ASI_DFPM_Start_Date__c = DEF_VALUE_START_DATE
			, ASI_DFPM_Duration__c = DEF_VALUE_DURATION
		);
	}

	public ASI_DFPM_Project_Task__c generateTask(ASI_DFPM_Project_Milestone__c mst) {
		return generateTask(mst, RT_Standard);
	}

	public ASI_DFPM_Project_Task__c generateTask(ASI_DFPM_Project_Milestone__c mst, String rtDevName) {
		return generateBasicTask(mst);
	}
	
	public List<ASI_DFPM_Project_Task__c> generateTasksInSequence(List<ASI_DFPM_Project_Milestone__c> mstList, Integer numOfTasksPerMst, Decimal taskDuration) {
		return generateTasksInSequence(mstList, RT_Standard, numOfTasksPerMst, taskDuration);
	}

	public List<ASI_DFPM_Project_Task__c> generateTasksInSequence(List<ASI_DFPM_Project_Milestone__c> mstList, String rtDevName, Integer numOfTasksPerMst, Decimal taskDuration) {
		List<ASI_DFPM_Project_Task__c> resultList = new List<ASI_DFPM_Project_Task__c>();
		for (ASI_DFPM_Project_Milestone__c mst : mstList) {
			for (Integer i = 0; i < numOfTasksPerMst; i++) {
	    		ASI_DFPM_Project_Task__c tk = generateTask(mst, rtDevName);
	    		tk.ASI_DFPM_Start_Date__c = mst.ASI_DFPM_Start_Date__c.addDays(i * taskDuration.intValue());
				tk.ASI_DFPM_Duration__c = taskDuration;
	    		resultList.add(tk);
			}
    	}
		return resultList;
	}

}