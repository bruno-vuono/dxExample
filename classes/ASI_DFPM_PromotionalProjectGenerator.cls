public with sharing class ASI_DFPM_PromotionalProjectGenerator {
	public static final String DEF_VALUE_NAME = 'Test Project';
	public static final Date DEF_VALUE_START_DATE = System.today();
	public static final Decimal DEF_VALUE_DURATION = 6;
	public static final String RT_Standard = 'ASI_DFPM_Standard';
	public static final String RT_Template = 'ASI_DFPM_Template';

	private static Map<String, RecordType> RTMap {
		get {
			if (RTMap == null) {
				List<RecordType> RTList = [SELECT Id, Name, DeveloperName, IsActive, SobjectType, NamespacePrefix, BusinessProcessId FROM RecordType WHERE SobjectType = 'ASI_DFPM_Promotional_Project__c'];
				RTMap = new Map<String, RecordType>();
				for (RecordType rt : RTList) {
					RTMap.put(rt.DeveloperName, rt);
				}
			}
			return RTMap;
		}
		set;
	}

	public static RecordType getRecordTypeByDevName(String devName) { return RTMap.get(devName); }
	
	public ASI_DFPM_Promotional_Project__c generateBasicProject() {
		return new ASI_DFPM_Promotional_Project__c(
			Name = DEF_VALUE_NAME
			, ASI_DFPM_Start_Date__c = DEF_VALUE_START_DATE
			, ASI_DFPM_Duration__c = DEF_VALUE_DURATION
		);
	}

	public ASI_DFPM_Promotional_Project__c generateProject(ID rtID) {
		ASI_DFPM_Promotional_Project__c result = generateBasicProject();
		result.RecordTypeId = rtID;
		return result;
	}

	public ASI_DFPM_Promotional_Project__c generateProject(String rtDevName) {
		return generateProject(getRecordTypeByDevName(rtDevName).Id);
	}

	public ASI_DFPM_Promotional_Project__c generateProject(String rtDevName, Integer numOfMst, Integer numOfTasksPerMst, Decimal duration) {
		ASI_DFPM_Promotional_Project__c result = generateProject(rtDevName);
		if (numOfMst == null) numOfMst = 1;
		if (numOfTasksPerMst == null) numOfTasksPerMst = 1;
		result.ASI_DFPM_Duration__c = numOfMst * numOfTasksPerMst * duration;
		return result;
	}

}