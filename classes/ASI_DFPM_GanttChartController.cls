global with sharing class ASI_DFPM_GanttChartController {
	
	private enum ELEMENT_TYPE {MILESTONE, TASK}
	
	public String myTargetId { get; set; }
	
	public Boolean hasError { get; private set; }
	public Boolean initVar { get { if (initVar != true) initComponent(); initVar = true; return initVar; } private set; }
	
	private Schema.DescribeSObjectResult sObjDescribe;
	private String sObjTypeName;
	private String startDateFN;
	private String endDateFN;
	
	public ASI_DFPM_GanttChartController() {
		this.hasError = false;
	}
	
	public void initComponent() {
		if (this.myTargetId == null) {
			this.hasError = true;
		}
	}
	
	// Method to get gantt chart content objects
	@RemoteAction
	global static List<ASI_DFPM_GanttChartElement> queryGanttChartElements(String targetId) {
		List<ASI_DFPM_GanttChartElement> result = new List<ASI_DFPM_GanttChartElement>();
		if (targetId != null) {
			// Get the information of requested object
			ELEMENT_TYPE eleType = null;
			String contentSObjTypeName = null;
			String contentParentLookupFN = null;
			String contentNameFN = null;
			String contentStartDateFN = null;
			String contentEndDateFN = null;
			String contentColorFN = null;
			String contentPrefixNumFN = null;
			if (targetId.startsWith(Schema.SObjectType.ASI_DFPM_Promotional_Project__c.getKeyPrefix())) { // is project ID
				eleType = ELEMENT_TYPE.MILESTONE;
				contentSObjTypeName = 'ASI_DFPM_Project_Milestone__c';
				contentParentLookupFN = 'ASI_DFPM_Promotional_Project__c';
				contentNameFN = 'ASI_DFPM_Milestone_Name__c';
				contentStartDateFN = 'ASI_DFPM_Start_Date__c';
				contentEndDateFN = 'ASI_DFPM_End_Date__c';
				contentColorFN = 'ASI_DFPM_Gantt_Chart_Color__c';
				contentPrefixNumFN = 'ASI_DFPM_Prefix_Number__c';
			} else if (targetId.startsWith(Schema.SObjectType.ASI_DFPM_Project_Milestone__c.getKeyPrefix())) { // is milestone ID
				eleType = ELEMENT_TYPE.TASK;
				contentSObjTypeName = 'ASI_DFPM_Project_Task__c';
				contentParentLookupFN = 'ASI_DFPM_Project_Milestone__c';
				contentNameFN = 'ASI_DFPM_Task_Name__c';
				contentStartDateFN = 'ASI_DFPM_Start_Date__c';
				contentEndDateFN = 'ASI_DFPM_End_Date__c';
				contentColorFN = 'ASI_DFPM_Gantt_Chart_Color__c';
				contentPrefixNumFN = 'ASI_DFPM_Prefix_Number__c';
			}
			
			if (contentSObjTypeName != null) {
				// Query the records
				List<String> queryFields = new List<String>{contentNameFN, contentStartDateFN, contentEndDateFN, contentColorFN, contentPrefixNumFN};
				String orderFields = String.format('{0}', new String[] {eleType == ELEMENT_TYPE.MILESTONE ? contentPrefixNumFN : contentNameFN});
				List<sObject> contentDataList = database.query(String.format(
					'SELECT Id, {0} FROM {1} WHERE {2} = :targetId ORDER BY {3}'
					, new String[] {
						String.join(queryFields, ',')
						, contentSObjTypeName
						, contentParentLookupFN
						, orderFields
					}
				));
				
				List<sObject> sortedContentDataList = new List<sObject>();
				List<sObject> noPrefixContentDataList = new List<sObject>();
				// Use start date and end date for sorting if any record does not have prefix number
				for (sObject theRecord : contentDataList) {
					if (theRecord.get(contentPrefixNumFN) != null) {
						sortedContentDataList.add(theRecord);
					} else {
						noPrefixContentDataList.add(theRecord);
					}
				}
				for (sObject noPrefixRecord : noPrefixContentDataList) {
					Integer sortedRecordSize = sortedContentDataList.size();
					Date noPrefixStartDate = (Date)noPrefixRecord.get(contentStartDateFN);
					Date noPrefixEndDate = (Date)noPrefixRecord.get(contentEndDateFN);
					Boolean added = false;
					for (Integer i = 0; i < sortedRecordSize; i++) {
						sObject sortedRecord = sortedContentDataList.get(i);
						Date sortedStartDate = (Date)sortedRecord.get(contentStartDateFN);
						if (noPrefixStartDate < sortedStartDate) {
							added = true;
							sortedContentDataList.add(i, noPrefixRecord);
						} else if (noPrefixStartDate == sortedStartDate) {
							Date sortedEndDate = (Date)sortedRecord.get(contentEndDateFN);
							if (noPrefixEndDate >= sortedEndDate) {
								added = true;
								sortedContentDataList.add(i, noPrefixRecord);
							}
						}
						if (added) break;
					}
					if (!added) {
						sortedContentDataList.add(noPrefixRecord);
					}
				}
				
				// Put the queried records to result list
				for (sObject theRecord : sortedContentDataList) {
					result.add(new ASI_DFPM_GanttChartElement(
						theRecord.Id
						, (String)theRecord.get(contentNameFN)
						, (Date)theRecord.get(contentStartDateFN)
						, (Date)theRecord.get(contentEndDateFN)
						, (String)theRecord.get(contentColorFN)
					));
				}
			}
		}
		return result;
	}
	
	/**
	 * Methods used by VF page
	 */
	
	public PageReference redirectToContentDetailPage() {
		String recordId = ApexPages.currentPage().getParameters().get('recordId');
		if (recordId != null) {
			return new PageReference('/' + recordId);
		}
		return null;
	}
}