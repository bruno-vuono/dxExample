/*********************************************************************************
 * Name: ASI_TnE_HK_ManageClaimDetailController
 * Description: Controller class for HK Managing T&E Claims(Javascript).
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 19/12/2016       Hugo Cheung             Created          
*/
public class ASI_TnE_HK_ManageClaimDetailController {

	//Inner class for storing the exception
	private class ExceptionWrapper {
		private Integer lineNumber            {get; set;}
		private String errorMessage           {get; set;}
		private List<String> fieldAPINameList {get; set;}

		private ExceptionWrapper(Integer lineNumber, String errorMessage) {
			this.lineNumber = lineNumber;
			this.errorMessage = errorMessage;
            this.fieldAPINameList = new List<String>();
		}

		private ExceptionWrapper(Integer lineNumber, String errorMessage, List<String> fieldAPINameList) {
			this(lineNumber, errorMessage);
			this.fieldAPINameList = fieldAPINameList;
		}
	}

	private final static String CLAIM_HEADER_FINANCE_RECORD_TYPE     = 'ASI_TnE_HK_Claim_Header_Finance';
	private final static String CLAIM_HEADER_RECORD_TYPE             = 'ASI_TnE_HK_Claim_Header';
  	private final static String CATEGORY_RECORD_TYPE                 = 'ASI_TnE_HK_Expense_Category';
  	private final static String PUBLIC_GROUP_RECORD_TYPE             = 'ASI_TnE_HK_Finance_Users';
  	private final static String COUNTRY_CODE                         = 'HK';
  	private final static String HK_CURRENCY                          = 'HKD';
  	private final static String OVERRIDE_SUB_LEDGER_AC_CODE          = '1270.060000';

  	private final static String CLAIM_DETAIL_RECORD_TYPE_ID          = Global_RecordTypeCache.getRTId('ASI_TnE_ClaimDetail__cASI_TnE_HK_Claim_Detail');
	private final static String EMPLOYEE_CODE_MAPPING_RECORD_TYPE_ID = Global_RecordTypeCache.getRTId('ASI_TnE_Employee_Code_Mapping__cASI_TnE_HK_Employee_Code_Mapping');

  	//T&E Claim Data
  	public ASI_TnE_ClaimHeader__c claimHeader            {get; set;}
  	private List<ASI_TnE_ClaimDetail__c> claimDetailList {get; set;}

  	//T&E Claim Field Name
  	private List<String> tneFieldNameList {get; set;}

  	//Expense Category & Classification
  	private List<ASI_JP_TnE_Expense_Category__c> categoryList {get; set;}

  	//Currency and Exchange Rate
  	private List<String> currencyList {get; set;}
  	private Map<String, List<ASI_MFM_Exchange_Rate__c>> exchangeRateMap {get; set;}

  	//Field API & Id Map
  	private Map<String, Id> fieldIdMap {get; set;}

  	//Ower and Payee
  	public User ownerUser {get; set;}
  	public User payeeUser {get; set;}

  	//Page Control
  	public Boolean isFinanceView  {get; set;}
  	public Boolean isEmployeeView {get; set;}

  	//JSON String for VF Page
  	public String claimDetailListJson  {get {return toJsonString(claimDetailList);}}
  	public String categoryListJson     {get {return toJsonString(categoryList);}}
  	public String exchangeRateMapJson  {get {return toJsonString(exchangeRateMap);}}
  	public String tneFieldNameListJson {get {return toJsonString(tneFieldNameList);}}
  	public String currencyListJson     {get {return toJsonString(currencyList);}}
  	public String fieldIdMapJson       {get {return toJsonString(fieldIdMap);}}
  	public String exceptionListJson    {get {return toJsonString(exceptionList);}}

  	//Variable for VF Page
  	public String claimDetailRecordTypeId       {get {return CLAIM_DETAIL_RECORD_TYPE_ID;}}
  	public Boolean hasError                     {get; set;}
  	public List<ExceptionWrapper> exceptionList {get; set;}

  	//Init function
  	public ASI_TnE_HK_ManageClaimDetailController(ApexPages.StandardController standardController) {
  		claimHeader      = retrieveClaimHeader(ApexPages.currentPage().getParameters().get('id'));
	    claimDetailList  = retrieveClaimDetailList(ApexPages.currentPage().getParameters().get('id'));
	    categoryList     = retrieveCategoryClassification();
	    exchangeRateMap  = retrieveExchangeRateMap();
	    tneFieldNameList = retrievePicklistValues(ASI_JP_TnE_Expense_Classification__c.ASI_TnE_Read_Only_Fields__c.getDescribe());
	    currencyList     = retrievePicklistValues(ASI_TnE_ClaimDetail__c.ASI_TnE_Currency__c.getDescribe());
	    fieldIdMap       = retrieveFieldId();

	    ownerUser = retrieveUser(claimHeader.OwnerId);
	    if(String.isNotBlank(claimHeader.ASI_TnE_Payee_Employee__c)) {
	    	payeeUser = retrieveUser(claimHeader.ASI_TnE_Payee_Employee__c);
	    }

	    setView();
  	}

  	private void setView() {
  		isFinanceView  = false;
	    isEmployeeView = false;
	    if(claimHeader.RecordType.DeveloperName.equalsIgnoreCase(CLAIM_HEADER_FINANCE_RECORD_TYPE) ||
	       (claimHeader.ASI_TnE_Status__c.equalsIgnoreCase('Submitted') &&
	    	claimHeader.RecordType.DeveloperName.equalsIgnoreCase(CLAIM_HEADER_RECORD_TYPE))) {
	    	isFinanceView = retrieveFinanceState(UserInfo.getUserId());
	    }

	    if(!claimHeader.ASI_TnE_Status__c.equalsIgnoreCase('Draft')) {
	      	isEmployeeView = true;
	    }
  	}

  	private Map<String, Id> retrieveFieldId() {
  		Map<String, String> tempFieldIdMap = new Map<String, String>();
  		List<ASI_TnE_Field_ID_Mappings__c> fieldIdMappingList = ASI_TnE_Field_ID_Mappings__c.getAll().values();
  		for(ASI_TnE_Field_ID_Mappings__c fieldIdMapping : fieldIdMappingList) {
  			tempFieldIdMap.put(fieldIdMapping.ASI_TnE_Field_Name__c, fieldIdMapping.ASI_TnE_Field_ID__c.subString(0, 15));
  		}
  		return tempFieldIdMap;
  	}

  	private User retrieveUser(Id userId) {
	    return [SELECT Id, Name, ASI_TnE_Department_Code__c, ASI_TnE_Sub_Ledger__c FROM User WHERE Id =: userId LIMIT 1];
	}

  	private Boolean retrieveFinanceState(Id userId) {
	    List<GroupMember> publicGroupList = [SELECT Id
	                                       	 FROM GroupMember
	                                         Where GroupId in (SELECT Id FROM Group WHERE DeveloperName =: PUBLIC_GROUP_RECORD_TYPE)
	                                         AND UserOrGroupId =: userId];
	    return publicGroupList.size() > 0 ? true : false;
  	}

  	private String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
	    String queryField = '';
	    for(String fields : fieldMap.keySet()) {
	      queryField += fields + ',';
	    }
	    return queryField.subString(0, queryField.length() - 1);
  	}

  	/***************
  	T&E Hong Kong Exchange Rate Logic
  	1. Collect currency's exchange rate that within 3 months
	2. If the currency does not exist in last 3 months, get the latest one
  	***************/
  	private Map<String, List<ASI_MFM_Exchange_Rate__c>> retrieveExchangeRateMap() {
	    Date threeMonths = Date.newInstance(System.today().year(), System.today().month(), 1).addMonths(-3);

	    Map<String, List<ASI_MFM_Exchange_Rate__c>> tempExchangeRateMap = new Map<String, List<ASI_MFM_Exchange_Rate__c>>();

	    //Backup exchange rate stores the currency's exchange rate that do not exist within 3 months 
	    Map<String, ASI_MFM_Exchange_Rate__c> backupExchangeRateMap = new Map<String, ASI_MFM_Exchange_Rate__c>();
	    for(ASI_MFM_Exchange_Rate__c exchangeRate : [SELECT Id, ASI_MFM_Country__c, ASI_MFM_Base_Currency__c, ASI_MFM_Counter_Currency__c, ASI_MFM_Effective_Date__c, ASI_MFM_Exchange_Rate__c
	                                                 FROM ASI_MFM_Exchange_Rate__c 
	                                                 WHERE ASI_MFM_Country__c =: COUNTRY_CODE
	                                                 AND ASI_MFM_Base_Currency__c =: HK_CURRENCY 
	                                                 ORDER BY ASI_MFM_Effective_Date__c DESC]) {

	    	//Collect currency's exchange rate that within 3 months
	      	if(exchangeRate.ASI_MFM_Effective_Date__c > threeMonths) {
	    		List<ASI_MFM_Exchange_Rate__c> exchangeRateList;
	      		if(!tempExchangeRateMap.containsKey(exchangeRate.ASI_MFM_Counter_Currency__c)) {
	      			exchangeRateList = new List<ASI_MFM_Exchange_Rate__c>();
	      		} else {
	      			exchangeRateList = tempExchangeRateMap.get(exchangeRate.ASI_MFM_Counter_Currency__c);
	      		}
	      		exchangeRateList.add(exchangeRate);
	      		tempExchangeRateMap.put(exchangeRate.ASI_MFM_Counter_Currency__c, exchangeRateList);
	      	}

	      	//Get all latest currency's exchange rate
	    	if(backupExchangeRateMap.containsKey(exchangeRate.ASI_MFM_Counter_Currency__c)) {
	      		if(backupExchangeRateMap.get(exchangeRate.ASI_MFM_Counter_Currency__c).ASI_MFM_Effective_Date__c < exchangeRate.ASI_MFM_Effective_Date__c) {
	      			backupExchangeRateMap.put(exchangeRate.ASI_MFM_Counter_Currency__c, exchangeRate);
	      		}
	      	} else {
	        	backupExchangeRateMap.put(exchangeRate.ASI_MFM_Counter_Currency__c, exchangeRate);
	      	}
	    }
	    //Assign the latest currency's exchange rate
	    for(String key : backupExchangeRateMap.keySet()) {
	    	if(!tempExchangeRateMap.containsKey(key)) {
		    	List<ASI_MFM_Exchange_Rate__c> exchangeRateList = new List<ASI_MFM_Exchange_Rate__c>();
		    	exchangeRateList.add(backupExchangeRateMap.get(key));
		    	tempExchangeRateMap.put(key, exchangeRateList);
	    	}
	    }

	    return tempExchangeRateMap;
  	}

  	private ASI_TnE_ClaimHeader__c retrieveClaimHeader(Id claimHeaderId) {
	    String query = 'SELECT ' + genQueryField(Schema.SObjectType.ASI_TnE_ClaimHeader__c.fields.getMap()) + 
	                   ', RecordType.DeveloperName ' + 
	                   'FROM ASI_TnE_ClaimHeader__c ' + 
	                   'WHERE Id = \'' + claimHeaderId + '\'';

	    List<ASI_TnE_ClaimHeader__c> claimList = (List<ASI_TnE_ClaimHeader__c>) Database.query(query);
	    return claimList.size() > 0 ? claimList.get(0) : new ASI_TnE_ClaimHeader__c();
	}

	private List<ASI_JP_TnE_Expense_Category__c> retrieveCategoryClassification() {
	  	List<ASI_JP_TnE_Expense_Category__c> tempCategoryList = new List<ASI_JP_TnE_Expense_Category__c>();

	    for(ASI_JP_TnE_Expense_Category__c category : [SELECT Id, Name, RecordType.DeveloperName,
	                                                     (SELECT Id, Name, ASI_JP_TnE_Expense_Category__c, ASI_TnE_WHT_Rate__c, 
	                                                     	ASI_TnE_Read_Only_Fields__c, ASI_TnE_Required_Fields__c
	                                                      FROM TnE_JP_Expense_Classifications__r
	                                                      Order By Name ASC)
	                                                   FROM ASI_JP_TnE_Expense_Category__c
	                                                   WHERE RecordType.DeveloperName =: CATEGORY_RECORD_TYPE
	                                                   AND Name != NULL
	                                                   AND Name != ''
	                                                   Order By ASI_JP_TnE_Expense_Category_Order__c ASC]) {
	      tempCategoryList.add(category);
	    }
	    return tempCategoryList;
	}

	private List<ASI_JP_TnE_Expense_Classification__c> retrieveClassification(Set<Id> classificationIdSet) {
		List<ASI_JP_TnE_Expense_Classification__c> classificationList = [SELECT Id, Name, ASI_TnE_Required_Fields__c, ASI_JP_TnE_Tax_Flag__c, ASI_TnE_Read_Only_Fields__c,
		                                                                 ASI_JP_TnE_Account_Mapping__r.ASI_TnE_Account_Number__c, ASI_TnE_WHT_Rate__c
		                                                                 FROM ASI_JP_TnE_Expense_Classification__c
		                                                                 WHERE Id in : classificationIdSet];
		return classificationList;
	}

	private List<ASI_TnE_ClaimDetail__c> retrieveClaimDetailList(Id claimHeaderId) {
	    String query = 'SELECT ' + genQueryField(Schema.SObjectType.ASI_TnE_ClaimDetail__c.fields.getMap()) + 
	                   ', ASI_TnE_SubBrand__r.Name, ASI_TnE_Expense_Category__r.Name, ASI_TnE_Expense_Classification__r.Name' +
	                   ', ASI_TnE_MFM_PO__r.Name, ASI_TnE_CAP_Plan__r.Name, ASI_TnE_Charge_To_Acc__r.Name, ASI_TnE_BU__r.Name, ASI_TnE_A_C_Code__r.Name' +
                       ', ASI_TnE_Pre_Trip_Approval_Form__r.Name ' + 
	                   'FROM ASI_TnE_ClaimDetail__c ' + 
	                   'WHERE ASI_TnE_ClaimHeader__c = \'' + claimHeaderId + '\'';
	    return (List<ASI_TnE_ClaimDetail__c>) Database.query(query);     
	}

  	private List<String> retrievePicklistValues(Schema.DescribeFieldResult fieldResult) {
  		List<String> picklistValueList = new List<String>();

  		List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
  		for(Schema.PicklistEntry picklistEntry : picklistEntryList) {
	    	picklistValueList.add(picklistEntry.getValue());
	    }

	    return picklistValueList;
  	}
	
    private Map<String, Id> retrieveObjNameIdMap(String objAPIName, Set<String> nameSet) {
    	String query = 'SELECT Id, Name ' + 
                       'FROM ' + objAPIName + ' ' +  
                       'WHERE Name in :nameSet ';
        
        Map<String, Id> nameIdMap = new Map<String, Id>();
        for(sObject sObj : Database.query(query)) {
            nameIdMap.put(String.valueOf(sObj.get('Name')), sObj.Id);
        }
        return nameIdMap;
    }
    
  	private List<Account> retrieveAccount(Set<Id> accountIdSet) {
  		List<Account> accountList = [SELECT Id, Name, ASI_MFM_Customer_Supplier_Number__c 
  		                             FROM Account
  		                             WHERE Id in : accountIdSet];
  		return accountList;
  	}

  	private List<ASI_MFM_A_C_Code__c> retrieveACCode(Set<Id> acCodeIdSet) {
  		List<ASI_MFM_A_C_Code__c> acCodeList = [SELECT Id, Name, ASI_MFM_A_C_Code__c
  		                                        FROM ASI_MFM_A_C_Code__c
  		                                        WHERE Id in : acCodeIdSet];
  		return acCodeList;
  	}

   	public PageReference save() {
   		hasError = false;

	    Map<String, String> params = ApexPages.currentPage().getParameters();
	    Boolean isQuickSave        = String.isBlank(params.get('IS_QUICK_SAVE')) ? false : Boolean.valueOf(params.get('IS_QUICK_SAVE'));
	    String upsertDataJson      = params.get('UPSERT_DATA_JSON');
	    String removeDataJson      = params.get('REMOVE_DATA_JSON');

	    List<ASI_TnE_ClaimDetail__c> upsertDataList;
	    List<String> removeDataIdList;
	    
	    System.Savepoint databaseSavepoint = Database.setSavepoint();
	    try {
	    	upsertDataList   = (List<ASI_TnE_ClaimDetail__c>) fromJsonString(upsertDataJson, List<ASI_TnE_ClaimDetail__c>.class);
	      	removeDataIdList = (List<String>) fromJsonString(removeDataJson, List<String>.class);

	      	if(removeDataIdList != null && removeDataIdList.size() > 0) {
	        	List<ASI_TnE_ClaimDetail__c> removeDataList = new List<ASI_TnE_ClaimDetail__c>();
	        	for(String removeId : removeDataIdList) {
	          		removeDataList.add(new ASI_TnE_ClaimDetail__c(Id = removeId));
	        	}
	        	Database.delete(removeDataList);
	      	}

	      	if(upsertDataList != null && upsertDataList.size() > 0) {

                Set<String> poNameSet           = new Set<String>();
                Set<String> planNameSet         = new Set<String>();
                Set<String> chargeToAccNameSet  = new Set<String>();
                Set<String> approvalFormNameSet = new Set<String>();
                Set<String> buNameSet           = new Set<String>();
                Set<String> acCodeNameSet       = new Set<String>();
                
	      		Set<Id> accountIdSet = new Set<Id>();
	      		Set<Id> acCodeIdSet  = new Set<Id>();
	      		Set<Id> classificationIdSet = new Set<Id>();
	      		Map<Id, Account> accountMap;
	      		Map<Id, ASI_MFM_A_C_Code__c> acCodeMap;
	      		Map<Id, ASI_JP_TnE_Expense_Classification__c> classificationMap;
                
                Decimal totalAmount = 0;

                for(ASI_TnE_ClaimDetail__c upsertData : upsertDataList) {
                	if(String.isNotBlank(upsertData.ASI_TnE_MFM_PO__c)) poNameSet.add(upsertData.ASI_TnE_MFM_PO__c); 
                	if(String.isNotBlank(upsertData.ASI_TnE_CAP_Plan__c)) planNameSet.add(upsertData.ASI_TnE_CAP_Plan__c); 
                	if(String.isNotBlank(upsertData.ASI_TnE_Charge_To_Acc__c)) chargeToAccNameSet.add(upsertData.ASI_TnE_Charge_To_Acc__c); 
                	if(String.isNotBlank(upsertData.ASI_TnE_Pre_Trip_Approval_Form__c)) approvalFormNameSet.add(upsertData.ASI_TnE_Pre_Trip_Approval_Form__c); 
                	if(String.isNotBlank(upsertData.ASI_TnE_BU__c)) buNameSet.add(upsertData.ASI_TnE_BU__c); 
                	if(String.isNotBlank(upsertData.ASI_TnE_A_C_Code__c)) acCodeNameSet.add(upsertData.ASI_TnE_A_C_Code__c);
                }
                
                System.debug(chargeToAccNameSet);
                System.debug(retrieveObjNameIdMap('Account', chargeToAccNameSet));
                
                Map<String, Id> poNameIdMap           = poNameSet.size() > 0 ? retrieveObjNameIdMap('ASI_MFM_PO__c', poNameSet) : null;
                Map<String, Id> planNameIdMap         = planNameSet.size() > 0 ? retrieveObjNameIdMap('ASI_MFM_Plan__c', planNameSet) : null;
                Map<String, Id> chargeToAccNameIdMap  = chargeToAccNameSet.size() > 0 ? retrieveObjNameIdMap('Account', chargeToAccNameSet) : null;
                Map<String, Id> approvalFormNameIdMap = approvalFormNameSet.size() > 0 ? retrieveObjNameIdMap('ASI_eForm_Pre_Trip_Approval__c', approvalFormNameSet) : null;
                Map<String, Id> buNameIdMap           = buNameSet.size() > 0 ? retrieveObjNameIdMap('ASI_MFM_BU__c', buNameSet) : null;
                Map<String, Id> acCodeNameIdMap       = acCodeNameSet.size() > 0 ? retrieveObjNameIdMap('ASI_MFM_A_C_Code__c', acCodeNameSet) : null;
                
	   			for(ASI_TnE_ClaimDetail__c upsertData : upsertDataList) {
                    if(String.isNotBlank(upsertData.ASI_TnE_MFM_PO__c) && poNameIdMap.containsKey(upsertData.ASI_TnE_MFM_PO__c)) 
                        upsertData.ASI_TnE_MFM_PO__c = poNameIdMap.get(upsertData.ASI_TnE_MFM_PO__c); 
                    
                	if(String.isNotBlank(upsertData.ASI_TnE_CAP_Plan__c) && planNameIdMap.containsKey(upsertData.ASI_TnE_CAP_Plan__c)) 
                        upsertData.ASI_TnE_CAP_Plan__c = planNameIdMap.get(upsertData.ASI_TnE_CAP_Plan__c); 
                    
                    System.debug('Log : ' + chargeToAccNameIdMap);
                    
                	if(String.isNotBlank(upsertData.ASI_TnE_Charge_To_Acc__c) && chargeToAccNameIdMap.containsKey(upsertData.ASI_TnE_Charge_To_Acc__c)) 
                        upsertData.ASI_TnE_Charge_To_Acc__c = chargeToAccNameIdMap.get(upsertData.ASI_TnE_Charge_To_Acc__c); 
                    
                	if(String.isNotBlank(upsertData.ASI_TnE_Pre_Trip_Approval_Form__c) && approvalFormNameIdMap.containsKey(upsertData.ASI_TnE_Pre_Trip_Approval_Form__c)) 
                        upsertData.ASI_TnE_Pre_Trip_Approval_Form__c = approvalFormNameIdMap.get(upsertData.ASI_TnE_Pre_Trip_Approval_Form__c); 
                    
                	if(String.isNotBlank(upsertData.ASI_TnE_BU__c) && buNameIdMap.containsKey(upsertData.ASI_TnE_BU__c)) 
                        upsertData.ASI_TnE_BU__c = buNameIdMap.get(upsertData.ASI_TnE_BU__c); 
                    
                	if(String.isNotBlank(upsertData.ASI_TnE_A_C_Code__c) && acCodeNameIdMap.containsKey(upsertData.ASI_TnE_A_C_Code__c)) 
                        upsertData.ASI_TnE_A_C_Code__c = acCodeNameIdMap.get(upsertData.ASI_TnE_A_C_Code__c); 
                    
                    if(String.isNotBlank(upsertData.ASI_TnE_Charge_To_Acc__c)) accountIdSet.add(upsertData.ASI_TnE_Charge_To_Acc__c); 
                    if(String.isNotBlank(upsertData.ASI_TnE_A_C_Code__c)) acCodeIdSet.add(upsertData.ASI_TnE_A_C_Code__c);
	   				if(String.isNotBlank(upsertData.ASI_TnE_Expense_Classification__c)) classificationIdSet.add(upsertData.ASI_TnE_Expense_Classification__c);
                    
                    totalAmount += (upsertData.ASI_TnE_Receipt_Amount__c == null ? 0 : upsertData.ASI_TnE_Receipt_Amount__c)
                                 * (upsertData.ASI_TnE_FX_Rate__c == null ? 0 : upsertData.ASI_TnE_FX_Rate__c);
	   			}
                
                if(totalAmount != claimHeader.ASI_TnE_Total_Amount_Approved__c && claimHeader.ASI_TnE_Type__c == 'Corp Card') {
                	exceptionList = new List<ExceptionWrapper>();
                    ExceptionWrapper exceptionWrapper = new ExceptionWrapper(-1, 'Total Payment Amount must be equal to the Total Amount Approved for Corp Card');
	      			exceptionList.add(exceptionWrapper);
	      			hasError = true;
                    Database.rollback(databaseSavepoint);
                    return null;
                }
                
	   			if(!accountIdSet.isEmpty()) accountMap = new Map<Id, Account>(retrieveAccount(accountIdSet)); 
	   			if(!acCodeIdSet.isEmpty()) acCodeMap = new Map<Id, ASI_MFM_A_C_Code__c>(retrieveACCode(acCodeIdSet));
	   			if(!classificationIdSet.isEmpty()) classificationMap = new Map<Id, ASI_JP_TnE_Expense_Classification__c>(retrieveClassification(classificationIdSet));

	   			for(ASI_TnE_ClaimDetail__c upsertData : upsertDataList) {
	   				Boolean requireOverrideSubLedger = true;
	   				if(String.isNotBlank(upsertData.ASI_TnE_A_C_Code__c) && 
	   				   acCodeMap != null &&
	   				   acCodeMap.containsKey(upsertData.ASI_TnE_A_C_Code__c) && 
	   				   acCodeMap.get(upsertData.ASI_TnE_A_C_Code__c).ASI_MFM_A_C_Code__c == OVERRIDE_SUB_LEDGER_AC_CODE) {
	   					requireOverrideSubLedger = false;
	   				}
	   				if(String.isNotBlank(upsertData.ASI_TnE_Expense_Classification__c) && 
	   				   classificationMap != null &&
	   				   classificationMap.containsKey(upsertData.ASI_TnE_Expense_Classification__c) &&
	   				   classificationMap.get(upsertData.ASI_TnE_Expense_Classification__c).ASI_JP_TnE_Account_Mapping__r.ASI_TnE_Account_Number__c == OVERRIDE_SUB_LEDGER_AC_CODE) {
	   					requireOverrideSubLedger = false;
	   				}

	   				if(payeeUser == null) {
	   					upsertData.ASI_TnE_SG_Sub_Ledger__c = ownerUser.ASI_TnE_Sub_Ledger__c;
	   				} else {
	   					upsertData.ASI_TnE_SG_Sub_Ledger__c = payeeUser.ASI_TnE_Sub_Ledger__c;
	   				}

	   				if(requireOverrideSubLedger) {
	   					if(String.isNotBlank(upsertData.ASI_TnE_Charge_To_Acc__c) &&
	   					   accountMap != null &&
	   					   accountMap.containsKey(upsertData.ASI_TnE_Charge_To_Acc__c)) {
	   						upsertData.ASI_TnE_SG_Sub_Ledger__c = accountMap.get(upsertData.ASI_TnE_Charge_To_Acc__c).ASI_MFM_Customer_Supplier_Number__c;
	   					}
	   				}

	   				Decimal paymentAmount = (upsertData.ASI_TnE_Receipt_Amount__c == null ? 0 : upsertData.ASI_TnE_Receipt_Amount__c) * 
	   				                        (upsertData.ASI_TnE_FX_Rate__c == null ? 0 : upsertData.ASI_TnE_FX_Rate__c);

                    upsertData.ASI_TnE_Taxable_Amount__c  = 0;
                    upsertData.ASI_TnE_Tax_Amount__c      = 0;
                    upsertData.ASI_TnE_Tax_Rate__c        = 0;
	   			}

	        	Database.upsert(upsertDataList);
	      	}

	    } catch(Exception e) {
	      	exceptionList = new List<ExceptionWrapper>();
	      	if(e.getTypeName() == 'System.DmlException') {
	      		DmlException dmlException = (DmlException) e;
	      		for(Integer i = 0 ; i < dmlException.getNumDml() ; i++) {
	      			ExceptionWrapper exceptionWrapper = new ExceptionWrapper(dmlException.getDmlIndex(i), dmlException.getDmlMessage(i), dmlException.getDmlFieldNames(i));
	      			exceptionList.add(exceptionWrapper);
	      		}
	      	} else {
	      		ExceptionWrapper exceptionWrapper = new ExceptionWrapper(e.getLineNumber(), e.getMessage());
	      		exceptionList.add(exceptionWrapper);
	      	}
	      	hasError = true;
	      	Database.rollback(databaseSavepoint);
	      	return null;
	    }

	    PageReference pageRef = null;
	    if(!isQuickSave) {
	      	pageRef = new PageReference('/' + claimHeader.Id);
	      	pageRef.setRedirect(true);
	    } else {
	    	claimDetailList = retrieveClaimDetailList(claimHeader.Id);
	    }
	    return pageRef;
  	}

  	public PageReference cancel() {
	    PageReference pageRef = new PageReference('/' + claimHeader.Id);
	    pageRef.setRedirect(true);
	    return pageRef;
  	}

  	//Tools function
	private String toJsonString(Object obj) {
	    return System.JSON.serialize(obj);
	}

	private List<Object> fromJsonString(String jsonString, System.Type apexType) {
		if(String.isBlank(jsonString)) {
			return null;
	    }
	    return (List<Object>) System.JSON.deserialize(jsonString, apexType);
	}
}