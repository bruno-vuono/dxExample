public with sharing class ASI_DFPM_ChildRecordSummaryHelper {
	
	public enum SummaryType {COUNT, SUM, MIN, MAX}
	
	private String sObjTypeStr;
	private List<ChildRecordSummarySetting> summarySettings;
	
	public ASI_DFPM_ChildRecordSummaryHelper(String sObjTypeStr) {
		this.sObjTypeStr = sObjTypeStr;
		this.summarySettings = new List<ChildRecordSummarySetting>();
		this.childRelationToFieldsMap = null;
	}
	
	// Return Set of IDs whose objects have been updated
	public Set<ID> refreshSummaryValues(List<sObject> sObjList) {
		Set<ID> updatedIds = new Set<ID>();
		if (this.summarySettings.size() > 0) {
			Map<String, Set<String>> childRelToFMap = this.childRelationToFieldsMap;
			
			// Prepare query string
			List<String> childQueryStrList = new List<String>();
			Set<String> childRelationSet = childRelToFMap.keySet();
			for (String childRel : childRelationSet) {
				Set<String> fieldSet = childRelToFMap.get(childRel);
				childQueryStrList.add(String.format('SELECT {0} FROM {1}', new String[] {
					String.join(new List<String>(fieldSet), ',')
					, childRel
				}));
			}
			// Query the child records
			List<sObject> querySObjList = database.query(String.format('SELECT Id, ({0}) FROM {1} WHERE Id IN :sObjList', new String[] {
				String.join(childQueryStrList, '),(')
				, sObjTypeStr
			}));
			
			// Calculate the summary fields
			Map<ID, sObject> updateSObjMap = new Map<ID, sObject>();
			for (sObject tempSObj : sObjList) updateSObjMap.put(tempSObj.Id, tempSObj);
			for (sObject querySObj : querySObjList) {
				sObject updateSObj = updateSObjMap.get(querySObj.Id);
				if (updateSObj != null) {
					for (ChildRecordSummarySetting sSetting : this.summarySettings) {
						if (updateSummaryField(updateSObj, querySObj, sSetting))
							updatedIds.add(updateSObj.Id);
					}
				}
			}
		}
		return updatedIds;
	}
	
	public void addSummarySetting(ChildRecordSummarySetting setting) {
		this.childRelationToFieldsMap = null;
		this.summarySettings.add(setting);
	}
	
	// Return true if any field is updated
	private Boolean updateSummaryField(sObject updateSObj, sObject sObjAndChildRecords, ChildRecordSummarySetting setting) {
		Decimal origVal = (Decimal)updateSObj.get(setting.summaryField);
		Decimal newVal = calculateSummary(sObjAndChildRecords, setting);
		if (origVal == newVal) return false;
		updateSObj.put(setting.summaryField, newVal);
		return true;
	}
	
	public Decimal calculateSummary(sObject sObjAndChildRecords, ChildRecordSummarySetting setting) {
		Decimal result = null;
		List<sObject> childRecords = sObjAndChildRecords.getSObjects(setting.childRelationName);
		if (setting.aggregateType == SummaryType.COUNT) {
			Decimal theCount = 0;
			if (childRecords == null || childRecords.size() == 0) {
				theCount = 0;
			} else {
				String whereField = setting.whereField;
				Object compareToValue = setting.compareToValue;
				for (sObject childRecord : childRecords) {
					if (whereField == null || childRecord.get(whereField) == compareToValue) {
						theCount++;
					}
				}
			}
			result = theCount;
			
		} else if (setting.aggregateType == SummaryType.SUM) {
			Decimal theSum = 0;
			if (childRecords == null || childRecords.size() == 0) {
				theSum = 0;
			} else {
				String aggregateField = setting.aggregateField;
				String whereField = setting.whereField;
				Object compareToValue = setting.compareToValue;
				for (sObject childRecord : childRecords) {
					if (whereField == null || childRecord.get(whereField) == compareToValue) {
						Decimal aggregateVal = objToDecimal(childRecord.get(aggregateField));
						if (aggregateVal != null)
						theSum += aggregateVal;
					}
				}
			}
			result = theSum;
			
		} else if (setting.aggregateType == SummaryType.MIN) {
			Decimal theMin = null;
			if (childRecords == null || childRecords.size() == 0) {
				theMin = null;
			} else {
				String aggregateField = setting.aggregateField;
				String whereField = setting.whereField;
				Object compareToValue = setting.compareToValue;
				for (sObject childRecord : childRecords) {
					if ((whereField == null || childRecord.get(whereField) == compareToValue)
						&& (theMin == null || (Decimal)childRecord.get(aggregateField) < theMin)) {
						theMin = (Decimal)childRecord.get(aggregateField);
					}
				}
			}
			result = theMin;
			
		} else if (setting.aggregateType == SummaryType.MAX) {
			Decimal theMax = null;
			if (childRecords == null || childRecords.size() == 0) {
				theMax = null;
			} else {
				String aggregateField = setting.aggregateField;
				String whereField = setting.whereField;
				Object compareToValue = setting.compareToValue;
				for (sObject childRecord : childRecords) {
					if ((whereField == null || childRecord.get(whereField) == compareToValue)
						&& (theMax == null || (Decimal)childRecord.get(aggregateField) > theMax)) {
						theMax = (Decimal)childRecord.get(aggregateField);
					}
				}
			}
			result = theMax;
		}
		return result;
	}
	
	private Map<String, Set<String>> childRelationToFieldsMap {
		get {
			if (this.childRelationToFieldsMap == null) {
				this.childRelationToFieldsMap = new Map<String, Set<String>>();
				for (ChildRecordSummarySetting sSetting : summarySettings) {
					Set<String> childFieldSet = this.childRelationToFieldsMap.get(sSetting.childRelationName);
					if (childFieldSet == null) {
						childFieldSet = new Set<String>();
						this.childRelationToFieldsMap.put(sSetting.childRelationName, childFieldSet);
					}
					childFieldSet.add(sSetting.aggregateField.toLowerCase());
					if (sSetting.whereField != null)
						childFieldSet.add(sSetting.whereField.toLowerCase());
				}
			}
			return this.childRelationToFieldsMap;
		}
		private set;
	}
	
	private Decimal objToDecimal(Object theObj) {
		Decimal result = null;
		if (theObj instanceof Decimal)
			result = (Decimal)theObj;
		if (theObj instanceof String)
			result = Decimal.valueOf((String)theObj);
		else if (theObj instanceof Double)
			result = Decimal.valueOf((Double)theObj);
		else if (theObj instanceof Long)
			result = Decimal.valueOf((Long)theObj);
		return result;
	}
	
	public class ChildRecordSummarySetting {
		public String summaryField;
		public String childRelationName;
		public SummaryType aggregateType;
		public String aggregateField { get; set { if (value == null) value = 'Id'; aggregateField = value; } }
		public String whereField;
		public Object compareToValue;
		
		public ChildRecordSummarySetting(String summaryField, String childRelationName
											, SummaryType aggregateType) {
			this(summaryField, childRelationName, aggregateType, null);
		}
		
		public ChildRecordSummarySetting(String summaryField, String childRelationName
											, SummaryType aggregateType, String aggregateField) {
			this(summaryField, childRelationName, aggregateType, aggregateField, null, null);
		}
		
		public ChildRecordSummarySetting(String summaryField, String childRelationName
											, SummaryType aggregateType, String aggregateField
											, String whereField, Object compareToValue) {
			
			if (summaryField == null || childRelationName == null || aggregateType == null
				|| (aggregateField == null && aggregateType != SummaryType.COUNT)) {
				throw new ASI_DFPM_CustomException('Invalid ChildRecordSummarySetting');
			}
			this.summaryField = summaryField;
			this.childRelationName = childRelationName;
			this.aggregateType = aggregateType;
			this.aggregateField = aggregateField;
			this.whereField = whereField;
			this.compareToValue = compareToValue;
		}
	}
}