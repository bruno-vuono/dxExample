/*********************************************************************************
 * Name: ASI_CRM_VN_MCF_Contract_Batch
 * Description: Batch job to calculate the achievement of MCF contract
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 11/01/2018       Hugo Cheung             Created          
*/
global class ASI_CRM_VN_MCF_Contract_Batch implements Database.Batchable<sObject>, Database.Stateful {
    
    private class ContractWrapper {
    	private ASI_CRM_VN_Contract__c contract                      {get; set;}
        private Set<Id> subBrandIdSet                                {get; set;}
        private List<ASI_TH_CRM_Actual_Offtake__c> actualOfftakeList {get; set;}
        
        private Decimal targetBottle {get; set;}
        private Decimal actualBottle {get; set;}
        
        private ContractWrapper(ASI_CRM_VN_Contract__c contract) {
            this.contract          = contract;
            this.targetBottle      = contract.ASI_CRM_Converted_Total_Sales_Target__c != null
                                   ? contract.ASI_CRM_Converted_Total_Sales_Target__c 
                                   : 0;
            this.actualBottle      = 0;
            this.subBrandIdSet     = new Set<Id>();
            this.actualOfftakeList = new List<ASI_TH_CRM_Actual_Offtake__c>();
        }
        
        private void addSubBrand(Id subBrandId) {
            subBrandIdSet.add(subBrandId);
        }
        
        private void addActualOfftake(ASI_TH_CRM_Actual_Offtake__c actualOfftake) {
            Date startDate = contract.ASI_CRM_Start_Date__c.toStartOfMonth();
            Date endDate = contract.ASI_CRM_End_Date__c;
            Integer numberOfDays = Date.daysInMonth(endDate.year(), endDate.month());
            endDate = Date.newInstance(endDate.year(), endDate.month(), numberOfDays);
            
            if(startDate <= actualOfftake.ASI_TH_CRM_Offtake_G_L_Date__c && 
               endDate >= actualOfftake.ASI_TH_CRM_Offtake_G_L_Date__c) {
            	actualOfftakeList.add(actualOfftake);
            }
        }
        
        private void calculateActualBottle(Map<String, ASI_CRM_VN_Sub_Brand_Conversion_Factor__c> conversionFactorMap) {
            Id toSubBrandId = contract.ASI_CRM_Key_Brand__c;
            for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : actualOfftakeList) {
                Id fromSubBrandId = actualOfftake.ASI_TH_CRM_Sub_brand__c;
                if(conversionFactorMap.containsKey(fromSubBrandId + '_' + toSubBrandId) == false &&
                   fromSubBrandId != toSubBrandId) {
                    continue;
                }
                
                if(fromSubBrandId == toSubBrandId) {
                	actualBottle += actualOfftake.ASI_TH_CRM_Quantity__c;
                } else {
                	ASI_CRM_VN_Sub_Brand_Conversion_Factor__c conversionFactor = conversionFactorMap.get(fromSubBrandId + '_' + toSubBrandId);
                    actualBottle += actualOfftake.ASI_TH_CRM_Quantity__c * conversionFactor.ASI_CRM_VN_Conversion_Factor__c;
                }
            }
        }
        
        private Boolean isEarlyTerminate() {
            return actualBottle > targetBottle;
        }
        
        private Boolean isExtend() {
            if(contract.ASI_CRM_End_Date__c == Date.today()) {
                System.debug('Log : ' + contract);
            	Decimal minTarget = targetBottle * ASI_CRM_VN_Settings__c.getInstance().ASI_CRM_VN_Min_Contract_AchieveTarget__c / 100;
                if(minTarget > actualBottle) {
                    return true;
                }
            }
            return false;
        }
    }
    
    private final static Map<String, Schema.SObjectField> BOTTLE_ANALYSIS_FIELD_MAP      = Schema.SObjectType.ASI_CRM_VN_Bottle_Analysis__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> ACTUAL_OFFTAKE_FIELD_MAP       = Schema.SObjectType.ASI_TH_CRM_Actual_Offtake__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> CONVERSION_FACTOR_FIELD_MAP    = Schema.SObjectType.ASI_CRM_VN_Sub_Brand_Conversion_Factor__c.fields.getMap();
    
    private final static String ACTUAL_OFFTAKE_RECORD_TYPE = 'ASI_CRM_VN_Actual_Offtake';
    
    private static String APPROVED_STATUS = 'Approved';
    
    private final static Set<String> OUTLET_RECORD_TYPE_SET = new Set<String> {
    	'ASI_CRM_VN_Outlet',
        'ASI_CRM_VN_Outlet_Inactive',
        'ASI_CRM_VN_PG_Outlets',
        'ASI_CRM_VN_Inactive_Off_Trade_Outlet',
        'ASI_CRM_VN_Off_Trade_Outlet'
    };
    
    private static String queryStr = 'SELECT Id, Name, ASI_CRM_Outlet_WS__c, ASI_CRM_Converted_Total_Sales_Target__c ' 
                                   + ', ASI_CRM_Start_Date__c, ASI_CRM_End_Date__c, OwnerId '
                                   + ', ASI_CRM_Key_Brand__c, ASI_CRM_No_Of_Months__c, ASI_CRM_Outlet_WS__r.Name '
                                   + 'FROM ASI_CRM_VN_Contract__c ' + 
                                   + 'WHERE ASI_CRM_Contract_Status__c = :APPROVED_STATUS';
    
    global Map<Id, List<ASI_CRM_VN_Contract__c>> earlyTerminateContractMap;
    global Map<Id, List<ASI_CRM_VN_Contract__c>> extendContractMap;
    
    global ASI_CRM_VN_MCF_Contract_Batch() {
        earlyTerminateContractMap = new Map<Id, List<ASI_CRM_VN_Contract__c>>();
        extendContractMap         = new Map<Id, List<ASI_CRM_VN_Contract__c>>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext contextInstance) {
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext contextInstance, List<ASI_CRM_VN_Contract__c> contractList) {
        Map<Id, ContractWrapper> contractWrapperMap = new Map<Id, ContractWrapper>();
        for(ASI_CRM_VN_Contract__c contract : contractList) {
            ContractWrapper wrapper = new ContractWrapper(contract);
            contractWrapperMap.put(contract.Id, wrapper);
        }
        
        //Step 1 : Generate Customer Contract Id Map
        //Step 2 : Get oldest start date and latest end date
        Map<Id, Id> customerContractIdMap = new Map<Id, Id>(); 
        Date contractStartDate;
        Date contractEndDate;
        Set<Id> fromSubBrandIdSet = new Set<Id>();
        Set<Id> toSubBrandIdSet = new Set<Id>();
        for(ASI_CRM_VN_Contract__c contract : contractList) {
        	customerContractIdMap.put(contract.ASI_CRM_Outlet_WS__c, contract.Id);
            
            if(contractStartDate == null || 
               contractStartDate > contract.ASI_CRM_Start_Date__c) {
            	contractStartDate = contract.ASI_CRM_Start_Date__c;
            }
            
            if(contractEndDate == null || 
               contractEndDate < contract.ASI_CRM_End_Date__c) {
                contractEndDate = contract.ASI_CRM_End_Date__c;
            }
            
            toSubBrandIdSet.add(contract.ASI_CRM_Key_Brand__c);
        }
        
        contractStartDate = contractStartDate.toStartOfMonth();
        Integer endMonthNumberOfDays = Date.daysInMonth(contractEndDate.year(), contractEndDate.month());
        contractEndDate = Date.newInstance(contractEndDate.year(), contractEndDate.month(), endMonthNumberOfDays);
        
        //Step 3 : Get Parent Child Relation Map
        Map<Id, Id> parentChildCustomerContractIdMap = new Map<Id, Id>();
        
        ASI_CRM_VN_OutletHierarchy outletHierarchyHelper = new ASI_CRM_VN_OutletHierarchy(retrieveCustomerList());
        for(Id customerId : customerContractIdMap.keySet()) {
            Id contractId = customerContractIdMap.get(customerId);
        	for(ASI_CRM_AccountsAdditionalField__c customer : outletHierarchyHelper.getAllOutlet(customerId)) {
                parentChildCustomerContractIdMap.put(customer.Id, contractId);
            }
        }
        
        //Step 4 : Get Bottle Analysis sku list
        Set<Id> skuIdSet = new Set<Id>();
        Map<Id, Set<Id>> skuContractMap = new Map<Id, Set<Id>>();
        for(ASI_CRM_VN_Bottle_Analysis__c bottleAnalysis : retrieveBottleAnalysisList(contractWrapperMap.keySet())) {
            fromSubBrandIdSet.add(bottleAnalysis.ASI_CRM_VN_SKU__r.ASI_MFM_Sub_brand__c);
            
            ContractWrapper wrapper = contractWrapperMap.get(bottleAnalysis.ASI_CRM_VN_Contract__c);
            wrapper.addSubBrand(bottleAnalysis.ASI_CRM_VN_SKU__r.ASI_MFM_Sub_brand__c);
            contractWrapperMap.put(bottleAnalysis.ASI_CRM_VN_Contract__c, wrapper);
        }
        
        //Step 5 : Get actual offtake
        List<ASI_TH_CRM_Actual_Offtake__c> actualOfftakeList = retrieveActualOfftakeList(parentChildCustomerContractIdMap.keySet(), contractStartDate, contractEndDate);
    	Map<Id, List<ASI_TH_CRM_Actual_Offtake__c>> contractActaulOfftakeMap = new Map<Id, List<ASI_TH_CRM_Actual_Offtake__c>>();
    	for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : actualOfftakeList) {
            Id contractId = parentChildCustomerContractIdMap.get(actualOfftake.ASI_CRM_SG_Customer__c);
            ContractWrapper wrapper = contractWrapperMap.get(contractId);
            wrapper.addActualOfftake(actualOfftake);
            contractWrapperMap.put(contractId, wrapper);
        }
        
        //Step 6 : Convert Actual Offtake Sub Brand to Key Brand
        Map<String, ASI_CRM_VN_Sub_Brand_Conversion_Factor__c> conversionFactorMap = new Map<String, ASI_CRM_VN_Sub_Brand_Conversion_Factor__c>();
        for(ASI_CRM_VN_Sub_Brand_Conversion_Factor__c conversionFactor : retrieveConversionFactorList(toSubBrandIdSet)) {
            conversionFactorMap.put(conversionFactor.ASI_CRM_VN_Sub_brand_From__c + '_' + conversionFactor.ASI_CRM_VN_Sub_brand_To__c, conversionFactor);
        }
        
        //Step 7 : Calculate Actual Bottle 
       	//Step 8 : Check is allow early termination or extend contract
        for(ContractWrapper wrapper : contractWrapperMap.values()) {
            wrapper.calculateActualBottle(conversionFactorMap);
            
            if(wrapper.isEarlyTerminate()) {
                List<ASI_CRM_VN_Contract__c> tempContractList = earlyTerminateContractMap.containsKey(wrapper.contract.OwnerId)
                                                              ? earlyTerminateContractMap.get(wrapper.contract.OwnerId)
                                                              : new List<ASI_CRM_VN_Contract__c>();
                tempContractList.add(wrapper.contract);
            	earlyTerminateContractMap.put(wrapper.contract.OwnerId, tempContractList);
            }
            
            if(wrapper.isExtend()) {
            	List<ASI_CRM_VN_Contract__c> tempContractList = extendContractMap.containsKey(wrapper.contract.OwnerId)
                                                              ? extendContractMap.get(wrapper.contract.OwnerId)
                                                              : new List<ASI_CRM_VN_Contract__c>();
                tempContractList.add(wrapper.contract);
            	extendContractMap.put(wrapper.contract.OwnerId, tempContractList);
            }
        }
        
    }
    
    global void finish(Database.BatchableContext contextInstance) {
        //Step 1 : Get owner email
        Set<Id> ownerIdSet = new Set<Id>();
        ownerIdSet.addAll(earlyTerminateContractMap.keySet());
        ownerIdSet.addAll(extendContractMap.keySet());
        Map<Id, User> userMap = new Map<Id, User>(retrieveUserList(ownerIdSet));
        
        //Step 2 : Set email
        //Step 3 : Update contract
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Map<Id, ASI_CRM_VN_Contract__c> updateContractMap = new Map<Id, ASI_CRM_VN_Contract__c>();
        for(Id ownerId : earlyTerminateContractMap.keySet()) {
            List<ASI_CRM_VN_Contract__c> tempContractList = earlyTerminateContractMap.get(ownerId);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{userMap.get(ownerId).Email});
			email.setSubject('[MCF Contract]' + tempContractList.size() + ' MCF Contracts can early terminate.');
            email.setHtmlBody(generateEmailBody(true, userMap.get(ownerId).Name, tempContractList));
            emailList.add(email);
            
            for(ASI_CRM_VN_Contract__c contract : tempContractList) {
                contract.ASI_CRM_Allow_Early_Termination__c = true;
                updateContractMap.put(contract.Id, contract);
            }
        }
        
        for(Id ownerId : extendContractMap.keySet()) {
            List<ASI_CRM_VN_Contract__c> tempContractList = extendContractMap.get(ownerId);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{userMap.get(ownerId).Email});
			email.setSubject('[MCF Contract]' + tempContractList.size() + ' MCF Contracts do not achieved before ' + System.now().format('yyyy-MM-dd'));
            email.setHtmlBody(generateEmailBody(false, userMap.get(ownerId).Name, tempContractList));
            emailList.add(email);
            
            for(ASI_CRM_VN_Contract__c contract : extendContractMap.get(ownerId)) {
                contract.ASI_CRM_Allow_Extend__c = true;
                updateContractMap.put(contract.Id, contract);
            }
        }
    	
        Messaging.sendEmail(emailList);
        if(updateContractMap.size() > 0) update updateContractMap.values(); 
    }
    
    private String generateEmailBody(Boolean isEarlyTerminate, String ownerName, List<ASI_CRM_VN_Contract__c> contractList) {
        String body = 'Dear ' + ownerName;
        body += '<br /><br />';
        if(isEarlyTerminate) {
        	body += 'Please note the following MCF Contracts can early completion: ';
        } else {
        	body += 'Please note the following MCF Contracts do not achieved before ' + System.now().format('yyyy-MM-dd');
        }
        
        body += '<br /><br />';
        body += 'Chào ' + ownerName;
        body += '<br /><br />';
        if(isEarlyTerminate) {
        	body += 'Vui lòng lưu ý những MCF sau đây có thể được hoàn tất sớm: ';
        } else {
        	body += 'Vui lòng lưu ý những MCF sau đây sẽ không thể hoàn tất trước ngày ' + System.now().format('yyyy-MM-dd');
        }
        
        body += '<br /><br />';
        body += '<table cellpadding="0" cellspacing="0" width="100%">';
        body += '<thead>';
        body += '<tr>';
        body += '<th style="border:1px solid #CCCCCC; background: #CCCCCC;">Contract Reference</th>';
        body += '<th style="border:1px solid #CCCCCC; background: #CCCCCC;">Outlet/WS</th>';
        body += '<th style="border:1px solid #CCCCCC; background: #CCCCCC;">Start Date</th>';
        body += '<th style="border:1px solid #CCCCCC; background: #CCCCCC;">End Date</th>';
        body += '<th style="border:1px solid #CCCCCC; background: #CCCCCC;">No. of Month</th>';
        body += '<th style="border:1px solid #CCCCCC; background: #CCCCCC;">Link</th>';
        body += '</tr>';
        body += '</thead>';
        
        body += '<tbody>';
        for(ASI_CRM_VN_Contract__c contract : contractList) {
        	body += '<tr>';
            body += '<td style="text-align: left; border:1px solid #CCCCCC;">' + contract.Name + '</td>';
            body += '<td style="text-align: left; border:1px solid #CCCCCC;">' + contract.ASI_CRM_Outlet_WS__r.Name + '</td>';
            body += '<td style="text-align: left; border:1px solid #CCCCCC;">' + ((Datetime)contract.ASI_CRM_Start_Date__c).format('yyyy-MM-dd') + '</td>';
            body += '<td style="text-align: left; border:1px solid #CCCCCC;">' + ((Datetime)contract.ASI_CRM_End_Date__c).format('yyyy-MM-dd') + '</td>';
            body += '<td style="text-align: left; border:1px solid #CCCCCC;">' + contract.ASI_CRM_No_Of_Months__c + '</td>';
            body += '<td style="text-align: left; border:1px solid #CCCCCC;">' 
                 + '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + contract.Id + '" target="_blank">link</a>' 
                 + '</td>';
            body += '</tr>';
        }
        body += '</tbody>';
        body += '</table>';
        
        return body;
    }
    
    /***************
  	Data Retrievement Function
  	***************/
    private List<User> retrieveUserList(Set<Id> userIdSet) {
    	String query = 'SELECT Id, Email, Name ' + 
                       'FROM User ' +
                       'WHERE Id in :userIdSet ';
        
        return (List<User>) Database.query(query);
    }
    
    private List<ASI_CRM_AccountsAdditionalField__c> retrieveCustomerList() {
        String query = 'SELECT Id, ASI_CRM_CN_Parent_Outlet__c ' + 
                       'FROM ASI_CRM_AccountsAdditionalField__c ' + 
                       'WHERE RecordType.DeveloperName in :OUTLET_RECORD_TYPE_SET ';
        
        return (List<ASI_CRM_AccountsAdditionalField__c>) Database.query(query);
    }
    
    private List<ASI_CRM_VN_Bottle_Analysis__c> retrieveBottleAnalysisList(Set<Id> contractIdSet) {
        String query = 'SELECT ' + genQueryField(BOTTLE_ANALYSIS_FIELD_MAP) + 
                       ', RecordType.DeveloperName, ASI_CRM_VN_SKU__r.ASI_MFM_Sub_brand__c ' + 
                       'FROM ASI_CRM_VN_Bottle_Analysis__c ' + 
                       'Where ASI_CRM_VN_Contract__c in :contractIdSet ';
        
    	return (List<ASI_CRM_VN_Bottle_Analysis__c>) Database.query(query);
    }
    
    private List<ASI_TH_CRM_Actual_Offtake__c> retrieveActualOfftakeList(Set<Id> customerIdSet, Date offtakeStartDate, Date offtakeEndDate) {
    	String query = 'SELECT ' + genQueryField(ACTUAL_OFFTAKE_FIELD_MAP) +  
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_TH_CRM_Actual_Offtake__c ' + 
                       'WHERE ASI_CRM_SG_Customer__c in :customerIdSet ' + 
                       'AND ASI_TH_CRM_Offtake_G_L_Date__c >= :offtakeStartDate ' + 
                       'AND ASI_TH_CRM_Offtake_G_L_Date__c <= :offtakeEndDate ' + 
                       'AND RecordType.DeveloperName = :ACTUAL_OFFTAKE_RECORD_TYPE ';
        
    	return (List<ASI_TH_CRM_Actual_Offtake__c>) Database.query(query);
  	}
    
    private List<ASI_CRM_VN_Sub_Brand_Conversion_Factor__c> retrieveConversionFactorList(Set<Id> toSubBrandIdSet) {
        String query = 'SELECT ' + genQueryField(CONVERSION_FACTOR_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_VN_Sub_Brand_Conversion_Factor__c ' + 
                       'WHERE ASI_CRM_VN_Sub_brand_To__c in :toSubBrandIdSet ' + 
                       'AND ASI_CRM_VN_Active_Flag__c = true';
        
    	return (List<ASI_CRM_VN_Sub_Brand_Conversion_Factor__c>) Database.query(query);
    }
    
    /***************
  	Tools Function
  	***************/
	private String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
      	String queryField = '';
      	for(String fields : fieldMap.keySet()) {
       		queryField += fields + ',';
   		}
    	return queryField.subString(0, queryField.length() - 1);
    }
}