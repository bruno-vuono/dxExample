public with sharing class ASI_DFPM_DateDurationCalculator extends ASI_DFPM_TriggerAbstract {

	public ASI_DFPM_DateDurationCalculator() {
		super('ASI_DFPM_DateDurationCalculator');
	}
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		if (tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE) {
			if (sObjList != null && sObjList.size() > 0) {
				Schema.SObjectType sObjType = sObjList.get(0).getSObjectType();
				if (sObjType == ASI_DFPM_Promotional_Project__c.SObjectType) {
					calculateDateForProjects(tAction, (List<ASI_DFPM_Promotional_Project__c>)sObjList, (Map<ID, ASI_DFPM_Promotional_Project__c>)newMap, (Map<ID, ASI_DFPM_Promotional_Project__c>)oldMap);
				} else if (sObjType == ASI_DFPM_Project_Milestone__c.SObjectType) {
					calculateDateForMilestones(tAction, (List<ASI_DFPM_Project_Milestone__c>)sObjList, (Map<ID, ASI_DFPM_Project_Milestone__c>)newMap, (Map<ID, ASI_DFPM_Project_Milestone__c>)oldMap);
				} else if (sObjType == ASI_DFPM_Project_Task__c.SObjectType) {
					calculateDateForTasks(tAction, (List<ASI_DFPM_Project_Task__c>)sObjList, (Map<ID, ASI_DFPM_Project_Task__c>)newMap, (Map<ID, ASI_DFPM_Project_Task__c>)oldMap);
				}
			}
		}
	}
	
	private void calculateDateForProjects(TriggerAction tAction, List<ASI_DFPM_Promotional_Project__c> sObjList, Map<ID, ASI_DFPM_Promotional_Project__c> newMap, Map<ID, ASI_DFPM_Promotional_Project__c> oldMap) {
		for (ASI_DFPM_Promotional_Project__c sObj : sObjList) {
			ASI_DFPM_Promotional_Project__c oldSObj = (oldMap != null) ? oldMap.get(sObj.Id) : null;
			calculateDateOfRecord(sObj, oldSObj, 'ASI_DFPM_Start_Date__c', 'ASI_DFPM_End_Date__c', 'ASI_DFPM_Duration__c');
		}
	}
	
	private void calculateDateForMilestones(TriggerAction tAction, List<ASI_DFPM_Project_Milestone__c> sObjList, Map<ID, ASI_DFPM_Project_Milestone__c> newMap, Map<ID, ASI_DFPM_Project_Milestone__c> oldMap) {
		for (ASI_DFPM_Project_Milestone__c sObj : sObjList) {
			ASI_DFPM_Project_Milestone__c oldSObj = (oldMap != null) ? oldMap.get(sObj.Id) : null;
			calculateDateOfRecord(sObj, oldSObj, 'ASI_DFPM_Start_Date__c', 'ASI_DFPM_End_Date__c', 'ASI_DFPM_Duration__c');
		}
	}
	
	private void calculateDateForTasks(TriggerAction tAction, List<ASI_DFPM_Project_Task__c> sObjList, Map<ID, ASI_DFPM_Project_Task__c> newMap, Map<ID, ASI_DFPM_Project_Task__c> oldMap) {
		for (ASI_DFPM_Project_Task__c sObj : sObjList) {
			ASI_DFPM_Project_Task__c oldSObj = (oldMap != null) ? oldMap.get(sObj.Id) : null;
			calculateDateOfRecord(sObj, oldSObj, 'ASI_DFPM_Start_Date__c', 'ASI_DFPM_End_Date__c', 'ASI_DFPM_Duration__c');
		}
	}
	
	public static void calculateDateOfRecord(sObject sObj, sObject oldSObj, String startDateFN, String endDateFN, String durationFN) {
		Date startDate = (Date)sObj.get(startDateFN);
		Date endDate = (Date)sObj.get(endDateFN);
		Decimal duration = (Decimal)sObj.get(durationFN);
		if (endDate == null && duration == null) return; // Two emtpy fields
		
		final Integer CHANGE_START_DATE = 1, CHANGE_END_DATE = 2, CHANGE_DURATION = 3;
		Integer change = 0;
		if (endDate == null) { // Empty end date
			change = CHANGE_END_DATE;
		} else if (duration == null) { // Empty duration
			change = CHANGE_DURATION;
		} else if (oldSObj == null) { // Insert new record
			change = CHANGE_END_DATE;
		} else { // No empty
			Boolean startDateChanged = (Date)oldSObj.get(startDateFN) != startDate;
			Boolean endDateChanged = (Date)oldSObj.get(endDateFN) != endDate;
			Boolean durationChanged = (Decimal)oldSObj.get(durationFN) != duration;
			
			if (!startDateChanged && !endDateChanged && !durationChanged) return;
			else if (startDateChanged && endDateChanged && durationChanged) change = CHANGE_END_DATE;
			else if (!endDateChanged) change = CHANGE_END_DATE;
			else if (durationChanged) change = CHANGE_START_DATE;
			else change = CHANGE_DURATION;
		}
		if (CHANGE_END_DATE == change) {
			sObj.put(endDateFN, calculateEndDate(startDate, duration));
		} else if (CHANGE_DURATION == change) {
			sObj.put(durationFN, calculateDuration(startDate, endDate));
		} else if (CHANGE_START_DATE == change) {
			sObj.put(startDateFN, calculateStartDate(endDate, duration));
		}
	}
	
	public static Date calculateEndDate(Date startDate, Decimal duration) {
		if (duration == 0) duration = 1;
		else if (duration < 0) return calculateStartDate(startDate, duration * -1);
		Integer durationInt = duration.intValue();
		Integer dayOfWeekOfStartDate = dayOfWeek(startDate);
		Integer addDays = (durationInt - 1) / 5 * 7;
		Integer modVal = Math.mod(durationInt - 1, 5);
		addDays += modVal;
		if (dayOfWeekOfStartDate == 6) { // Saturday
			addDays += 2;
		} else if (dayOfWeekOfStartDate == 0) { // Sunday
			addDays += 1;
		} else if (modVal + dayOfWeekOfStartDate > 5) { // Cross the weekend
			addDays += 2;
		}
		return startDate.addDays(addDays);
	}
	
	public static Decimal calculateDuration(Date startDate, Date endDate) {
		Date origStartDate = startDate;
		Date origEndDate = endDate;
		Integer dayOfWeekOfStartDate = dayOfWeek(startDate);
		Integer dayOfWeekOfEndDate = dayOfWeek(endDate);
		if (dayOfWeekOfStartDate == 6) {
			startDate = startDate.addDays(2);
		} else if (dayOfWeekOfStartDate == 0) {
			startDate = startDate.addDays(1);
		}
		if (dayOfWeekOfEndDate == 6) {
			endDate = endDate.addDays(-1);
		} else if (dayOfWeekOfEndDate == 0) {
			endDate = endDate.addDays(-2);
		}
		Integer actualDuration = startDate.daysBetween(endDate);
		
		// Reverse the start end date for calcuation if needed
		Boolean isReversed = false;
		if (actualDuration < 0) {
			if (origStartDate.daysBetween(origEndDate) >= 0)
				return 0;
			isReversed = true;
			Date tempDate = startDate;
			startDate = endDate;
			endDate = tempDate;
			actualDuration *= -1;
		}
		// Calculate new day of week
		dayOfWeekOfStartDate = dayOfWeek(startDate);
		dayOfWeekOfEndDate = dayOfWeek(endDate);
		
		Integer businessDuration = actualDuration / 7 * 5;
		Integer modVal = Math.mod(actualDuration, 7);
		businessDuration += modVal + 1;
		if (dayOfWeekOfStartDate > dayOfWeekOfEndDate) // Cross weekend
			businessDuration -= 2;
		
		if (businessDuration < 0) businessDuration = 0;
		return isReversed ? businessDuration * -1 : businessDuration;
	}
	
	public static Date calculateStartDate(Date endDate, Decimal duration) {
		if (duration == 0) duration = 1;
		else if (duration < 0) return calculateEndDate(endDate, duration * -1);
		Integer durationInt = duration.intValue();
		Integer dayOfWeekOfEndDate = dayOfWeek(endDate);
		Integer minusDays = (durationInt - 1) / 5 * 7;
		Integer modVal = Math.mod(durationInt - 1, 5);
		minusDays += modVal;
		if (dayOfWeekOfEndDate == 6) { // Saturday
			minusDays += 1;
		} else if (dayOfWeekOfEndDate == 0) { // Sunday
			minusDays += 2;
		} else if (dayOfWeekOfEndDate - modVal <= 0) { // Cross the weekend
			minusDays += 2;
		}
		return endDate.addDays(minusDays * -1);
	}
	
	// Return 0 = Sunday, 1 = Monday and so on
	public static Integer dayOfWeek(Date theDate) {
		return Math.mod(Date.newInstance(2000, 1, 2).daysBetween(theDate), 7);
	}
	
	public static Boolean isWeekend(Date theDate) {
		Integer dayOfWeek = dayOfWeek(theDate);
		return dayOfWeek == 0 || dayOfWeek == 6;
	}
}