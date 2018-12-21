public with sharing class ASI_DFPM_ProjectCloneHelper {
	
	public static final Set<String> SKIP_CLONE_FIELD_PJ = new Set<String>{
	};
	public static final Set<String> SKIP_CLONE_FIELD_MST = new Set<String>{
	};
	public static final Set<String> SKIP_CLONE_FIELD_TASK = new Set<String>{
	};
	public static final Map<String, Object> FIELD_AND_NEW_VALUE_PJ = new Map<String, Object>{
		'ASI_DFPM_Status__c' => 'Planning'
	};
	
	public static final Set<String> pjQueryFields;
	public static final Set<String> mstQueryFields;
	public static final Set<String> taskQueryFields;
	private static final ID pjDefRTId;
	
	static {
		pjQueryFields = getProjectQueryFields();
		pjQueryFields.addAll(new String[] {'asi_dfpm_start_date__c'});
		mstQueryFields = getMilestoneQueryFields();
		mstQueryFields.addAll(new String[] {'asi_dfpm_start_date__c', 'ownerid', 'asi_dfpm_predeccessor_milestone__c', 'asi_dfpm_parent_milestone__c'});
		taskQueryFields = getTaskQueryFields();
		taskQueryFields.addAll(new String[] {'asi_dfpm_start_date__c', 'ownerid', 'asi_dfpm_predeccessor_task__c'});
		RecordType pjDefRT = ASI_DFPM_PromotionalProjectGenerator.getRecordTypeByDevName(ASI_DFPM_PromotionalProjectGenerator.RT_Standard);
		if (pjDefRT != null)
			pjDefRTId = pjDefRT.Id;
	}
	
	public static ID cloneAndSaveProject(ID fromPjId, Date initStartDate, ID pjOwnerId, Boolean includeChild) {
		if (fromPjId == null) return null;
		if (includeChild != true) includeChild = false;
		// Query the project, milestones and tasks
		List<ASI_DFPM_Promotional_Project__c> tempPjList = database.query(String.format(
			'SELECT {0} FROM ASI_DFPM_Promotional_Project__c WHERE Id = :fromPjId'
			, new String[] {
				String.join(new List<String>(pjQueryFields), ',')
			}
		));
		if (tempPjList.size() > 0) {
			ASI_DFPM_Promotional_Project__c pj = tempPjList.get(0);
			
			// Copy the project
			ASI_DFPM_Promotional_Project__c newPj = cloneProject(pj, initStartDate);
			newPj.OwnerId = pjOwnerId;
			Date origPjStartDate = pj.ASI_DFPM_Start_Date__c;
			if (FIELD_AND_NEW_VALUE_PJ != null) {
				Set<String> newValueFields = FIELD_AND_NEW_VALUE_PJ.keySet();
				for (String field : newValueFields) {
					newPj.put(field, FIELD_AND_NEW_VALUE_PJ.get(field));
				}
			}
			
			// Start writing the new records to database
			System.Savepoint sp = database.setSavepoint();
			try {
				insert newPj;
				ID newPjId = newPj.Id;
				
				cloneAndSaveMilestonesFromTemplateProject(fromPjId, newPjId, origPjStartDate, initStartDate, pjOwnerId);
				
				return newPjId;
			} catch (Exception e) {
				database.rollback(sp);
				throw e;
			}
		}
		return null;
	}
	
	public static List<ID> cloneAndSaveMilestonesFromTemplateProject(ID templatePjId, ID newPjId, Date origPjStartDate, Date newPjStartDate, ID replaceInactiveUserId) {
		Map<ID, ASI_DFPM_Project_Milestone__c> mstAndTaskMap = new Map<ID, ASI_DFPM_Project_Milestone__c>(
			(List<ASI_DFPM_Project_Milestone__c>)database.query(String.format(
				'SELECT {0}, (SELECT {1} FROM ASI_DFPM_Project_Tasks__r) FROM ASI_DFPM_Project_Milestone__c WHERE ASI_DFPM_Promotional_Project__c = :templatePjId'
				, new String[] {
					String.join(new List<String>(mstQueryFields), ',')
					, String.join(new List<String>(taskQueryFields), ',')
				}
			))
		);
		return cloneAndSaveMilestones(mstAndTaskMap, newPjId, origPjStartDate, newPjStartDate, true, replaceInactiveUserId);
	}
	
	public static ID cloneAndSaveMilestone(ID mstId, Date origPjStartDate, Date newPjStartDate, Boolean includeTasks, ID replaceInactiveUserId, ID mstOwnerId, String newNameFormatStr) {
		Map<ID, ASI_DFPM_Project_Milestone__c> mstMap = new Map<ID, ASI_DFPM_Project_Milestone__c>((List<ASI_DFPM_Project_Milestone__c>)database.query(String.format(
			'SELECT {0}, (SELECT {1} FROM ASI_DFPM_Project_Tasks__r) FROM ASI_DFPM_Project_Milestone__c WHERE Id = :mstId' , new String[] {
				String.join(new List<String>(ASI_DFPM_ProjectCloneHelper.mstQueryFields), ',')
				, String.join(new List<String>(ASI_DFPM_ProjectCloneHelper.taskQueryFields), ',')
			}
		)));
		ASI_DFPM_Project_Milestone__c mst = mstMap.get(mstId);
		if (mst == null) throw new ASI_DFPM_CustomException(String.format('Milestone not found for ID: ', new String[] {mstId}));
		List<ID> newMstIds = cloneAndSaveMilestones(
			mstMap
			, null
			, origPjStartDate
			, newPjStartDate
			, includeTasks
			, replaceInactiveUserId
			, mstOwnerId
			, newNameFormatStr
		);
		if (newMstIds == null || newMstIds.size() == 0) throw new ASI_DFPM_CustomException('Unknow error when cloning milestone');
		return newMstIds.get(0);
	}
	
	public static List<ID> cloneAndSaveMilestones(Map<ID, ASI_DFPM_Project_Milestone__c> mstAndTaskMap, ID pjId, Date origPjStartDate, Date newPjStartDate, Boolean includeTasks, ID replaceInactiveUserId) {
		return cloneAndSaveMilestones(mstAndTaskMap, pjId, origPjStartDate, newPjStartDate, includeTasks, replaceInactiveUserId, null, null);
	}
	
	public static List<ID> cloneAndSaveMilestones(Map<ID, ASI_DFPM_Project_Milestone__c> mstAndTaskMap, ID pjId, Date origPjStartDate, Date newPjStartDate, Boolean includeTasks, ID replaceInactiveUserId, ID mstOwnerId, String newNameFormatStr) {
		if (mstAndTaskMap != null) {
			if (includeTasks != true) includeTasks = false;
			Boolean sameProject = pjId == null;
			
			// Start copying the milestones and tasks if needed
			Map<ID, User> allActiveUserMap = new Map<ID, User>([SELECT Id FROM User WHERE IsActive = TRUE]);
			List<ASI_DFPM_Project_Milestone__c> mstAndTaskList = mstAndTaskMap.values();
			List<ASI_DFPM_Project_Milestone__c> newMstList = new List<ASI_DFPM_Project_Milestone__c>();
			List<ASI_DFPM_Project_Task__c> newTaskList = new List<ASI_DFPM_Project_Task__c>();
			Map<ID, ASI_DFPM_Project_Milestone__c> origMstIdToNewMstMap = new Map<ID, ASI_DFPM_Project_Milestone__c>(); // Used to update Predeccessor Milestone after knowing the IDs of new milestones
			Map<ID, ASI_DFPM_Project_Task__c> taskMap = new Map<ID, ASI_DFPM_Project_Task__c>();
			Map<ID, ASI_DFPM_Project_Task__c> origTkIdToNewTkMap = new Map<ID, ASI_DFPM_Project_Task__c>(); // Used to update Predeccessor Task after knowing the IDs of new tasks
			for (ASI_DFPM_Project_Milestone__c mstAndTasks : mstAndTaskList) {
				// Clone milestone
				ASI_DFPM_Project_Milestone__c newMst = cloneMilestone(mstAndTasks, origPjStartDate, newPjStartDate, sameProject);
				if (mstOwnerId != null) newMst.OwnerId = mstOwnerId;
				if (allActiveUserMap.get(newMst.OwnerId) == null) newMst.OwnerId = replaceInactiveUserId;
				if (newNameFormatStr != null) newMst.Name = String.format(newNameFormatStr, new String[] {newMst.Name});
				origMstIdToNewMstMap.put(mstAndTasks.Id, newMst);
				newMstList.add(newMst);
				if (includeTasks) {
					// Clone tasks
					List<ASI_DFPM_Project_Task__c> tasks = mstAndTasks.ASI_DFPM_Project_Tasks__r;
					if (tasks != null) {
						for (ASI_DFPM_Project_Task__c theTask : tasks) {
							taskMap.put(theTask.Id, theTask);
							ASI_DFPM_Project_Task__c newTask = cloneTask(theTask, origPjStartDate, newPjStartDate, true);
							if (allActiveUserMap.get(newTask.OwnerId) == null) newTask.OwnerId = replaceInactiveUserId;
							origTkIdToNewTkMap.put(theTask.Id, newTask);
							newTaskList.add(newTask);
						}
					}
				}
			}
			
			System.Savepoint sp = database.setSavepoint();
			try {
				if (newMstList.size() > 0) {
					if (!sameProject) { // Not cloned to same project
						// Link the milestones to new project
						for (ASI_DFPM_Project_Milestone__c newMst : newMstList) {
							newMst.ASI_DFPM_Promotional_Project__c = pjId;
						}
					}
					// Write milestone to database
					insert newMstList;
					
					if (!sameProject) { // Not cloned to same project
						// Assign the Predeccessor Milestone field
						// And link the tasks to newly created milestones
						List<ASI_DFPM_Project_Milestone__c> updateMstList = new List<ASI_DFPM_Project_Milestone__c>();
						Set<ID> origMstIdSet = origMstIdToNewMstMap.keySet();
						for (ID origMstId : origMstIdSet) {
							Boolean alreadyAddToUpdateList = false;
							ASI_DFPM_Project_Milestone__c newMst = origMstIdToNewMstMap.get(origMstId);
							ASI_DFPM_Project_Milestone__c origMst = mstAndTaskMap.get(origMstId);
							ID origPredeccessorMstId = origMst.ASI_DFPM_Predeccessor_Milestone__c;
							if (origPredeccessorMstId != null) {
								ASI_DFPM_Project_Milestone__c newPredeccessorMst = origMstIdToNewMstMap.get(origPredeccessorMstId);
								if (newPredeccessorMst != null) { // If the predeccessor milestone is included in this clone
									newMst.ASI_DFPM_Predeccessor_Milestone__c = newPredeccessorMst.Id;
									if (!alreadyAddToUpdateList) {
										updateMstList.add(newMst);
										alreadyAddToUpdateList = true;
									}
								}
							}
							ID origParentMstId = origMst.ASI_DFPM_Parent_Milestone__c;
							if (origParentMstId != null) {
								ASI_DFPM_Project_Milestone__c newParentMst = origMstIdToNewMstMap.get(origParentMstId);
								if (newParentMst != null) { // If the predeccessor milestone is included in this clone
									newMst.ASI_DFPM_Parent_Milestone__c = newParentMst.Id;
									if (!alreadyAddToUpdateList) {
										updateMstList.add(newMst);
										alreadyAddToUpdateList = true;
									}
								}
							}
						}
						if (updateMstList.size() > 0) {
							update updateMstList;
						}
					}
					
					// Start handling tasks
					if (includeTasks && newTaskList.size() > 0) {
						// Assign tasks to milestone and project
						for (ASI_DFPM_Project_Task__c newTask : newTaskList) {
							if (!sameProject) newTask.ASI_DFPM_Promotional_Project__c = pjId;
							ASI_DFPM_Project_Milestone__c origMst = mstAndTaskMap.get(newTask.ASI_DFPM_Project_Milestone__c);
							ASI_DFPM_Project_Milestone__c newMst = origMstIdToNewMstMap.get(origMst.Id);
							if (newMst != null) {
								newTask.ASI_DFPM_Project_Milestone__c = newMst.Id;
							}
						}
						
						// Write the tasks to database
						insert newTaskList;
						
						// Assign the Predeccessor Task field
						// And link the tasks to newly created tasks
						List<ASI_DFPM_Project_Task__c> updateTaskList = new List<ASI_DFPM_Project_Task__c>();
						Set<ID> origTaskIdSet = origTkIdToNewTkMap.keySet();
						for (ID origTaskId : origTaskIdSet) {
							ASI_DFPM_Project_Task__c newTask = origTkIdToNewTkMap.get(origTaskId);
							ASI_DFPM_Project_Task__c origTask = taskMap.get(origTaskId);
							ID origPredeccessorTaskId = origTask.ASI_DFPM_Predeccessor_Task__c;
							if (origPredeccessorTaskId != null) {
								ASI_DFPM_Project_Task__c newPredeccessorTask = origTkIdToNewTkMap.get(origPredeccessorTaskId);
								if (newPredeccessorTask != null) { // If the predeccessor task is included in this clone
									newTask.ASI_DFPM_Predeccessor_Task__c = newPredeccessorTask.Id;
									updateTaskList.add(newTask);
								}
							}
						}
						if (updateTaskList.size() > 0) {
							update updateTaskList;
						}
					}
				}
				
				List<ID> newMstIdList = new List<ID>();
				for (ASI_DFPM_Project_Milestone__c newMst : newMstList) newMstIdList.add(newMst.Id);
				return newMstIdList;
			} catch (Exception e) {
				database.rollback(sp);
				throw e;
			}
		}
		return new List<ID>();
	}
	
	private static ASI_DFPM_Promotional_Project__c cloneProject(ASI_DFPM_Promotional_Project__c fromPj, Date initStartDate) {
		ASI_DFPM_Promotional_Project__c newPj = null;
		if (fromPj != null) {
			newPj = fromPj.clone(false, false, false, false);
			newPj.Name = fromPj.Name + ' - Cloned on ' + System.today().format();
			newPj.ASI_DFPM_Start_Date__c = initStartDate;
			newPj.ASI_DFPM_End_Date__c = null;
			newPj.RecordTypeId = pjDefRTId;
		}
		return newPj;
	}
	
	private static ASI_DFPM_Project_Milestone__c cloneMilestone(ASI_DFPM_Project_Milestone__c fromMst, Date origPjStartDate, Date newPjStartDate, Boolean sameProject) {
		ASI_DFPM_Project_Milestone__c newMst = null;
		if (fromMst != null) {
			newMst = fromMst.clone(false, false, false, false);
			if (origPjStartDate != null) {
				Decimal durationFromPjStartDate = ASI_DFPM_DateDurationCalculator.calculateDuration(origPjStartDate, fromMst.ASI_DFPM_Start_Date__c);
				if (ASI_DFPM_DateDurationCalculator.isWeekend(fromMst.ASI_DFPM_Start_Date__c))
					durationFromPjStartDate += 1;
				newMst.ASI_DFPM_Start_Date__c = ASI_DFPM_DateDurationCalculator.calculateEndDate(newPjStartDate, durationFromPjStartDate);
			}
			newMst.ASI_DFPM_End_Date__c = null;
			if (sameProject != true) newMst.ASI_DFPM_Promotional_Project__c = null;
			if (sameProject != true) newMst.ASI_DFPM_Predeccessor_Milestone__c = null;
			if (sameProject != true) newMst.ASI_DFPM_Parent_Milestone__c = null;
		}
		return newMst;
	}
	
	private static ASI_DFPM_Project_Task__c cloneTask(ASI_DFPM_Project_Task__c fromTask, Date origPjStartDate, Date newPjStartDate, Boolean sameMilestone) {
		ASI_DFPM_Project_Task__c newTask = null;
		if (fromTask != null) {
			newTask = fromTask.clone(false, false, false, false);
			if (origPjStartDate != null) {
				Decimal durationFromPjStartDate = ASI_DFPM_DateDurationCalculator.calculateDuration(origPjStartDate, fromTask.ASI_DFPM_Start_Date__c);
				if (ASI_DFPM_DateDurationCalculator.isWeekend(fromTask.ASI_DFPM_Start_Date__c))
					durationFromPjStartDate += 1;
				newTask.ASI_DFPM_Start_Date__c = ASI_DFPM_DateDurationCalculator.calculateEndDate(newPjStartDate, durationFromPjStartDate);
			}
			newTask.ASI_DFPM_End_Date__c = null;
			if (sameMilestone != true) newTask.ASI_DFPM_Promotional_Project__c = null;
			if (sameMilestone != true) newTask.ASI_DFPM_Project_Milestone__c = null;
		}
		return newTask;
	}
	
	private static Set<String> getProjectQueryFields() {
		return getCreatableFields(Schema.SObjectType.ASI_DFPM_Promotional_Project__c, toLowerCaseStrSet(SKIP_CLONE_FIELD_PJ));
	}
	private static Set<String> getMilestoneQueryFields() {
		return getCreatableFields(Schema.SObjectType.ASI_DFPM_Project_Milestone__c, toLowerCaseStrSet(SKIP_CLONE_FIELD_MST));
	}
	private static Set<String> getTaskQueryFields() {
		return getCreatableFields(Schema.SObjectType.ASI_DFPM_Project_Task__c, toLowerCaseStrSet(SKIP_CLONE_FIELD_TASK));
	}
	
	private static Set<String> getCreatableFields(Schema.DescribeSObjectResult sObjDescribe, Set<String> skipFields) {
		Set<String> results = new Set<String>();
		Map<String, Schema.sObjectField> sObjFieldMap = sObjDescribe.fields.getMap();
		Set<String> allSObjFieldSet = sObjFieldMap.keySet();
		
		for (String theField : allSObjFieldSet) {
			String theFieldLC = theField.toLowerCase();
			if (!skipFields.contains(theFieldLC)) {
				Schema.DescribeFieldResult fieldDescribe = sObjFieldMap.get(theField).getDescribe();
				if (!fieldDescribe.isCalculated() && !fieldDescribe.isAutoNumber() && !fieldDescribe.isUnique()) {
					results.add(theFieldLC);
				}
			}
		}
		
		return results;
	}
	
	private static Set<String> toLowerCaseStrSet(Set<String> strSet) {
		Set<String> results = new Set<String>();
		if (strSet != null)
			for (String theStr : strSet)
				results.add(theStr.toLowerCase());
		return results;
	}
}