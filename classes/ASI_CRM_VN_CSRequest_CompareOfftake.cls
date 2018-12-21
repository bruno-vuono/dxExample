/*********************************************************************************
 * Name: ASI_CRM_VN_CSRequest_CompareOfftake
 * Description: Check the total actual offtake before save the cs request 
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 26/07/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_VN_CSRequest_CompareOfftake {
    
    private class ContractWrapper {
    	private ASI_CRM_VN_Contract__c contract                        {get; set;}
        private ASI_CRM_VN_Contract_Expenditure__c contractExpenditure {get; set;}
        private List<ASI_CRM_VN_Bottle_Analysis__c> bottleAnalysisList {get; set;}
        private List<ASI_TH_CRM_Actual_Offtake__c>  actualOfftakeList  {get; set;}
        private Map<Id, Decimal> subBrandBottleQtyMap                  {get; set;}
        private Set<Id> bottleAnalysisSKUIdSet                         {get; set;}
        
        private Decimal targetBottle {get; set;}
        private Decimal actualBottle {get; set;}
        
        private ContractWrapper(ASI_CRM_VN_Contract__c contract) {
            this.contract               = contract;
            this.bottleAnalysisList     = new List<ASI_CRM_VN_Bottle_Analysis__c>();
            this.actualOfftakeList      = new List<ASI_TH_CRM_Actual_Offtake__c>();
            this.subBrandBottleQtyMap   = new Map<Id, Decimal>();
            this.bottleAnalysisSKUIdSet = new Set<Id>();
        }
        
        private void addBottleAnalysis(ASI_CRM_VN_Bottle_Analysis__c bottleAnalysis) {
            bottleAnalysisSKUIdSet.add(bottleAnalysis.ASI_CRM_VN_SKU__c);
            bottleAnalysisList.add(bottleAnalysis);
        }
        
        private void addActualOfftake(ASI_TH_CRM_Actual_Offtake__c actualOfftake) {
            actualOfftakeList.add(actualOfftake);
        }
        
        private void addSubBrandQty(Id subBrandId, Decimal qty) {
            if(subBrandBottleQtyMap.containsKey(subBrandId)) {
            	qty += subBrandBottleQtyMap.get(subBrandId);
            }
            subBrandBottleQtyMap.put(subBrandId, qty);
        }
    }
    
	private final static Map<String, Schema.SObjectField> CONTRACT_FIELD_MAP             = Schema.SObjectType.ASI_CRM_VN_Contract__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> CONTRACT_EXPENDITURE_FIELD_MAP = Schema.SObjectType.ASI_CRM_VN_Contract_Expenditure__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> BOTTLE_ANALYSIS_FIELD_MAP      = Schema.SObjectType.ASI_CRM_VN_Bottle_Analysis__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> REQUEST_FIELD_MAP              = Schema.SObjectType.ASI_GiftBox_Request_Header__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> SKU_FIELD_MAP                  = Schema.SObjectType.ASI_MFM_SKU_Code__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> ACTUAL_OFFTAKE_FIELD_MAP       = Schema.SObjectType.ASI_TH_CRM_Actual_Offtake__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> CONVERSION_FACTOR_FIELD_MAP    = Schema.SObjectType.ASI_CRM_VN_Sub_Brand_Conversion_Factor__c.fields.getMap();
    
    private final static Set<String> OUTLET_RECORD_TYPE_SET = new Set<String> {
    	'ASI_CRM_VN_Outlet',
        'ASI_CRM_VN_Outlet_Inactive',
        'ASI_CRM_VN_PG_Outlets',
        'ASI_CRM_VN_Inactive_Off_Trade_Outlet',
        'ASI_CRM_VN_Off_Trade_Outlet'
    };
    
    private final static Set<String> CS_REQUEST_RECORD_TYPE_SET = new Set<String> {
    	'ASI_CRM_VN_CS_Request',
        'ASI_CRM_VN_CS_Request_Read_Only'
    };
    
    private final static String ACTUAL_OFFTAKE_RECORD_TYPE = 'ASI_CRM_VN_Actual_Offtake';
    
    private final static String LUMP_SUM_CONTRACT_EXPENDITURE = 'Lump Sum';
    
    public ASI_CRM_VN_CSRequest_CompareOfftake() {
    }                                                                                                                                                                                                                                                                            
    
    public void executeTrigger(List<sObject> newList, Map<Id, sObject> oldMap) {
    	List<ASI_GiftBox_Request_Header__c> requestList   = (List<ASI_GiftBox_Request_Header__c>) newList;
        Map<Id, ASI_GiftBox_Request_Header__c> requestMap = (Map<Id, ASI_GiftBox_Request_Header__c>) oldMap;
        
        List<ASI_GiftBox_Request_Header__c> filteredRequestList = filterRequest(requestList, requestMap);
        assignPaymentTime(filteredRequestList);
        checkActualOfftake(filteredRequestList);
    }
    
    private List<ASI_GiftBox_Request_Header__c> filterRequest(List<ASI_GiftBox_Request_Header__c> requestList, Map<Id, ASI_GiftBox_Request_Header__c> requestMap) {
        return requestList;
    }
    
    private void assignPaymentTime(List<ASI_GiftBox_Request_Header__c> requestList) {
        Set<Id> contractIdSet = new Set<Id>();
        for(ASI_GiftBox_Request_Header__c request : requestList) {
            contractIdSet.add(request.ASI_CRM_VN_Contract__c);
        }
        
        Map<Id, List<ASI_GiftBox_Request_Header__c>> contractRequestMap = new Map<Id, List<ASI_GiftBox_Request_Header__c>>();
        for(ASI_GiftBox_Request_Header__c request : retrieveRequestHeaderList(contractIdSet)) {
            List<ASI_GiftBox_Request_Header__c> tempRequestList;
            if(contractRequestMap.containsKey(request.ASI_CRM_VN_Contract__c)) {
                tempRequestList = contractRequestMap.get(request.ASI_CRM_VN_Contract__c);
            } else {
                tempRequestList = new List<ASI_GiftBox_Request_Header__c>();
            }
            tempRequestList.add(request);
            contractRequestMap.put(request.ASI_CRM_VN_Contract__c, tempRequestList);
        }
        
        for(ASI_GiftBox_Request_Header__c request : requestList) {
            if(contractRequestMap.containsKey(request.ASI_CRM_VN_Contract__c) == false) {
                request.ASI_CRM_Payment_Time__c = 1;
                continue;
            }
            
            Decimal paymentTime = contractRequestMap.get(request.ASI_CRM_VN_Contract__c).size();
            request.ASI_CRM_Payment_Time__c = paymentTime + 1;
        }
    }
    
    private void checkActualOfftake(List<ASI_GiftBox_Request_Header__c> requestList) {
        //Step 1 : Retrieve the related Contract record
        Set<Id> contractIdSet = new Set<Id>();
        Map<Id, ASI_GiftBox_Request_Header__c> contractRequestMap = new Map<Id, ASI_GiftBox_Request_Header__c>();
        for(ASI_GiftBox_Request_Header__c request : requestList) {
			contractIdSet.add(request.ASI_CRM_VN_Contract__c);
            contractRequestMap.put(request.ASI_CRM_VN_Contract__c, request);
        }
        
        List<ASI_CRM_VN_Contract__c> contractList = retrieveContract(contractIdSet);
        
        //Step 2 : Store Contract record to wrapper class
        Map<Id, ContractWrapper> contractWrapperMap = new Map<Id, ContractWrapper>();
        for(ASI_CRM_VN_Contract__c contract : contractList) {
            contractWrapperMap.put(contract.Id, new ContractWrapper(contract));
        }
        
        //Step 3 : Retrieve related bottle analysis 
		Set<Id> skuIdSet = new Set<Id>();
        for(ASI_CRM_VN_Bottle_Analysis__c bottleAnalysis : retrieveBottleAnalysisList(contractIdSet)) {
            skuIdSet.add(bottleAnalysis.ASI_CRM_VN_SKU__c);
            
            ContractWrapper tempContractWrapper = contractWrapperMap.get(bottleAnalysis.ASI_CRM_VN_Contract__c);
            tempContractWrapper.addBottleAnalysis(bottleAnalysis);
        }
        
        //Step 4 : Retrieve related contract expenditure
        for(ASI_CRM_VN_Contract_Expenditure__c contractExpenditure : retrieveContractExpenditureList(contractIdSet)) {
            ContractWrapper tempContractWrapper = contractWrapperMap.get(contractExpenditure.ASI_CRM_VN_Contract__c);
            tempContractWrapper.contractExpenditure = contractExpenditure;
        }
        
        //Step 5 : Retrieve related SKU & Actual Offtake record & Conversion Factor record
        Map<Id, ASI_MFM_SKU_Code__c> skuMap = new Map<Id, ASI_MFM_SKU_Code__c>(retrieveSKUList(skuIdSet));
        
        Date contractStartDate;
        Date contractEndDate;
        Set<Id> fromSubBrandIdSet         = new Set<Id>();
        Set<String> toSubBrandIdSet     = new Set<String>();
        Map<Id, Id> customerContractIdMap = new Map<Id, Id>();
        for(ASI_MFM_SKU_Code__c sku : skuMap.values()) {
            fromSubBrandIdSet.add(sku.ASI_MFM_Sub_brand__c);
        }
        
        for(ContractWrapper contractWrapper : contractWrapperMap.values()) {
            customerContractIdMap.put(contractWrapper.contract.ASI_CRM_Outlet_WS__c, contractWrapper.contract.Id);
            toSubBrandIdSet.add(contractWrapper.contract.ASI_CRM_Key_Brand__c);
            
            if(contractStartDate == null || 
               contractStartDate > contractWrapper.contract.ASI_CRM_Start_Date__c) {
            	contractStartDate = contractWrapper.contract.ASI_CRM_Start_Date__c;
            }
            
            if(contractEndDate == null || 
               contractEndDate < contractWrapper.contract.ASI_CRM_End_Date__c) {
                contractEndDate = contractWrapper.contract.ASI_CRM_End_Date__c;
            }
        }
        
        contractStartDate = contractStartDate.toStartOfMonth();
        Integer endMonthNumberOfDays = Date.daysInMonth(contractEndDate.year(), contractEndDate.month());
        contractEndDate = Date.newInstance(contractEndDate.year(), contractEndDate.month(), endMonthNumberOfDays);
        
        //New Step (11/01/2018) : Parent Child Relationship
        Map<Id, ASI_CRM_AccountsAdditionalField__c> childCustomerMap = new Map<Id, ASI_CRM_AccountsAdditionalField__c>(retrieveCustomerList());

        Set<Id> customerIdSet = new Set<Id>();
        for(ASI_CRM_AccountsAdditionalField__c customer : childCustomerMap.values()) {
            customerIdSet.add(customer.ASI_CRM_CN_Parent_Outlet__c);
        }

        for(ASI_CRM_AccountsAdditionalField__c customer : retrieveCustomerList(customerIdSet)) {
            childCustomerMap.put(customer.Id, customer);
        }
        
        Map<Id, Id> parentChildCustomerContractIdMap = new Map<Id, Id>();
        
        ASI_CRM_VN_OutletHierarchy outletHierarchyHelper = new ASI_CRM_VN_OutletHierarchy(childCustomerMap.values());
        for(Id customerId : customerContractIdMap.keySet()) {
            Id contractId = customerContractIdMap.get(customerId);
        	for(ASI_CRM_AccountsAdditionalField__c customer : outletHierarchyHelper.getAllOutlet(customerId)) {
                parentChildCustomerContractIdMap.put(customer.Id, contractId);
            }
            parentChildCustomerContractIdMap.put(customerId, contractId);
        }
        
        List<ASI_TH_CRM_Actual_Offtake__c> actualOfftakeList = retrieveActualOfftakeList(parentChildCustomerContractIdMap.keySet(), contractStartDate, contractEndDate);
        for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : actualOfftakeList) {
            Id contractId = parentChildCustomerContractIdMap.get(actualOfftake.ASI_CRM_SG_Customer__c);
            ContractWrapper contractWrapper = contractWrapperMap.get(contractId);
            
            Date startDate = contractWrapper.contract.ASI_CRM_Start_Date__c.toStartOfMonth();
            Date endDate = contractWrapper.contract.ASI_CRM_End_Date__c;
            Integer numberOfDays = Date.daysInMonth(endDate.year(), endDate.month());
            endDate = Date.newInstance(endDate.year(), endDate.month(), numberOfDays);
            
            if(actualOfftake.ASI_TH_CRM_Offtake_G_L_Date__c >= startDate &&
               actualOfftake.ASI_TH_CRM_Offtake_G_L_Date__c <= endDate) {
            	contractWrapper.addActualOfftake(actualOfftake);
            }
        }
        
        //Step 6 : Convert SKU to Sub brand standard size
       	for(ContractWrapper contractWrapper : contractWrapperMap.values()) {
        	for(ASI_CRM_VN_Bottle_Analysis__c bottleAnalysis : contractWrapper.bottleAnalysisList) {
            	ASI_MFM_SKU_Code__c sku = skuMap.get(bottleAnalysis.ASI_CRM_VN_SKU__c);
				Decimal convertedSubBrandSize = bottleAnalysis.ASI_CRM_Total_Contract_Target__c * sku.ASI_HK_CRM_Std_Bottle_Size__c / sku.ASI_MFM_Sub_brand__r.ASI_CRM_BottleSize__c;
                contractWrapper.addSubBrandQty(sku.ASI_MFM_Sub_brand__c, convertedSubBrandSize);
            }
        }
        
        //Step 7 : Convert Sub brand to key brand
        Map<String, ASI_CRM_VN_Sub_Brand_Conversion_Factor__c> conversionFactorMap = new Map<String, ASI_CRM_VN_Sub_Brand_Conversion_Factor__c>();
        for(ASI_CRM_VN_Sub_Brand_Conversion_Factor__c conversionFactor : retrieveConversionFactorList(toSubBrandIdSet)) {
            conversionFactorMap.put(conversionFactor.ASI_CRM_VN_Sub_brand_From__c + '_' + conversionFactor.ASI_CRM_VN_Sub_brand_To__c, conversionFactor);
        }
        
        for(ContractWrapper contractWrapper : contractWrapperMap.values()) {
            Map<Id, Decimal> subBrandBottleQtyMap = contractWrapper.subBrandBottleQtyMap;
            Id toSubBrandId = contractWrapper.contract.ASI_CRM_Key_Brand__c;
            
            Decimal targetBottle = 0;
            Decimal actualBottle = 0;
            for(Id subBrandId : subBrandBottleQtyMap.keySet()) {
                if(conversionFactorMap.containsKey(subBrandId + '_' + toSubBrandId) == false && 
                   subBrandId != toSubBrandId) {
                    continue;
            	}	
                
                if(subBrandId == toSubBrandId) {
                    targetBottle += subBrandBottleQtyMap.get(subBrandId);
                } else {
                	ASI_CRM_VN_Sub_Brand_Conversion_Factor__c conversionFactor = conversionFactorMap.get(subBrandId + '_' + toSubBrandId);
                	targetBottle += subBrandBottleQtyMap.get(subBrandId) * conversionFactor.ASI_CRM_VN_Conversion_Factor__c;
                }
            }
            
            for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : contractWrapper.actualOfftakeList) {
                if(conversionFactorMap.containsKey(actualOfftake.ASI_TH_CRM_Sub_brand__c + '_' + toSubBrandId) == false && 
                   actualOfftake.ASI_TH_CRM_Sub_brand__c != toSubBrandId) {
                    continue;
            	}
                
                if(actualOfftake.ASI_TH_CRM_Sub_brand__c == toSubBrandId) {
                    actualBottle += actualOfftake.ASI_TH_CRM_Quantity__c;
                } else {
                    ASI_CRM_VN_Sub_Brand_Conversion_Factor__c conversionFactor = conversionFactorMap.get(actualOfftake.ASI_TH_CRM_Sub_brand__c + '_' + toSubBrandId);
                    actualBottle += actualOfftake.ASI_TH_CRM_Quantity__c * conversionFactor.ASI_CRM_VN_Conversion_Factor__c;
                }
            }
            
            contractWrapper.targetBottle = targetBottle;
            contractWrapper.actualBottle = actualBottle;
        }
        
        //Step 8 : Check request amount
        for(ASI_GiftBox_Request_Header__c request : requestList) {
            ContractWrapper tempContractWrapper = contractWrapperMap.get(request.ASI_CRM_VN_Contract__c);
            if(tempContractWrapper.contractExpenditure == null) {
                showError(request, Label.ASI_CRM_VN_Contract_Lump_Sum_Not_Defined);
                continue;
            }
            
            if(String.isBlank(tempContractWrapper.contractExpenditure.ASI_CRM_VN_Payment_Times__c)) {
            	showError(request, Label.ASI_CRM_VN_CS_Request_Over_Payment_Time);
                continue;
            } else {
            	if(request.ASI_CRM_Payment_Time__c > Integer.valueOf(tempContractWrapper.contractExpenditure.ASI_CRM_VN_Payment_Times__c)) {
                    showError(request, Label.ASI_CRM_VN_CS_Request_Over_Payment_Time);
                    continue;
                }
            }
            
            tempContractWrapper.targetBottle = tempContractWrapper.contract.ASI_CRM_Converted_Total_Sales_Target__c == NULL 
                                             ? 1 : tempContractWrapper.contract.ASI_CRM_Converted_Total_Sales_Target__c;
            
            if(request.ASI_CRM_Payment_Time__c == 1) {
            } else if(request.ASI_CRM_Payment_Time__c == 2) {
                tempContractWrapper.targetBottle *= tempContractWrapper.contractExpenditure.ASI_CRM_VN_Achieved_Target_for_2nd_Pmt__c / 100;
            } else if(request.ASI_CRM_Payment_Time__c == 3) {
                tempContractWrapper.targetBottle *= tempContractWrapper.contractExpenditure.ASI_CRM_VN_Achieved_Target_for_3rd_Pmt__c / 100;
            } else if(request.ASI_CRM_Payment_Time__c == 4) {
                tempContractWrapper.targetBottle *= tempContractWrapper.contractExpenditure.ASI_CRM_VN_Achieved_Target_for_4th_Pmt__c / 100;
            }
            System.debug(tempContractWrapper.targetBottle);
            if(tempContractWrapper.targetBottle > tempContractWrapper.actualBottle && request.ASI_CRM_Payment_Time__c != 1) {
                Integer actualBottle = tempContractWrapper.actualBottle.intValue();
                Integer targetBottle = tempContractWrapper.targetBottle.intValue();
                showError(request, String.format(Label.ASI_CRM_VN_Target_Bottle_Not_Achieved, new String[]{String.valueOf(actualBottle), String.valueOf(targetBottle)}));
            }
             
            request.ASI_CRM_Vol_YTD_Bottle__c = tempContractWrapper.actualBottle;
            request.ASI_CRM_Achieved__c = tempContractWrapper.actualBottle 
                                        / (tempContractWrapper.contract.ASI_CRM_Converted_Total_Sales_Target__c == NULL 
                                           ? 1 : tempContractWrapper.contract.ASI_CRM_Converted_Total_Sales_Target__c) * 100;
            request = copyDataFromContract(request, tempContractWrapper.contract);
            request = assignAmount(request, tempContractWrapper.contract, tempContractWrapper.contractExpenditure);
        }
        
        //Step 9 : update Actual Offtake flag
        List<ASI_TH_CRM_Actual_Offtake__c> updateActualOfftakeList = new List<ASI_TH_CRM_Actual_Offtake__c>();
        for(Id contractId : contractWrapperMap.keySet()) {
       		ContractWrapper contractWrapper = contractWrapperMap.get(contractId);
            ASI_GiftBox_Request_Header__c request = contractRequestMap.get(contractId);
            for(ASI_TH_CRM_Actual_Offtake__c actualOfftake : contractWrapper.actualOfftakeList) {
                if(actualOfftake.ASI_CRM_Payment_Time__c == null) {
                	actualOfftake.ASI_CRM_Payment_Time__c = String.valueOf(request.ASI_CRM_Payment_Time__c);
                } else {
                	actualOfftake.ASI_CRM_Payment_Time__c += ',' + String.valueOf(request.ASI_CRM_Payment_Time__c);
                }
            }
            updateActualOfftakeList.addAll(contractWrapper.actualOfftakeList);
        }
        update updateActualOfftakeList;
    }
    
    private ASI_GiftBox_Request_Header__c copyDataFromContract(ASI_GiftBox_Request_Header__c request, ASI_CRM_VN_Contract__c contract) {
        request.ASI_CRM_Customer__c                   = contract.ASI_CRM_Outlet_WS__c;
        request.ASI_GiftBox_Delivery_Address__c       = contract.ASI_CRM_Outlet_Address__c;
        request.ASI_CRM_VN_Channel__c                 = contract.ASI_CRM_Outlet_Type__c;
        request.ASI_CRM_VN_Contract_Type__c           = contract.ASI_CRM_Type__c;
        request.ASI_CRM_VN_Contract_Start_Date__c     = contract.ASI_CRM_Start_Date__c;
       	request.ASI_CRM_VN_Contract_Ending_Date__c    = contract.ASI_CRM_End_Date__c;
        request.ASI_CRM_VN_Contract_Duration__c       = contract.ASI_CRM_No_Of_Months__c;
        request.ASI_CRM_VN_Image_Level__c             = contract.ASI_CRM_Outlet_Image__c;
        request.ASI_CRM_VN_Spirit_Volume_Potential__c = contract.ASI_CRM_Spirit_Volume_Potential__c;
        request.ASI_CRM_VN_Wine_Volume_Potential__c   = contract.ASI_CRM_Wine_Volume_Potential__c;
        request.ASI_CRM_VN_Outlet_Role__c             = contract.ASI_CRM_Outlet_Role__c;
        request.ASI_GiftBox_Region__c                 = contract.ASI_CRM_Outlet_Region__c;
        return request;
    }
    
    private ASI_GiftBox_Request_Header__c assignAmount(ASI_GiftBox_Request_Header__c request, ASI_CRM_VN_Contract__c contract, ASI_CRM_VN_Contract_Expenditure__c contractExpenditure) {
		request.ASI_CRM_VN_Amount__c = (contractExpenditure.ASI_CRM_VN_Quantity__c == null ? 0 : contractExpenditure.ASI_CRM_VN_Quantity__c)
                                     * (contractExpenditure.ASI_CRM_VN_Amount__c == null ? 0 : contractExpenditure.ASI_CRM_VN_Amount__c) 
                                     / Integer.valueOf((contractExpenditure.ASI_CRM_VN_Payment_Times__c == null ? '1' : contractExpenditure.ASI_CRM_VN_Payment_Times__c));
            
    	if(contract.ASI_CRM_Currency__c == 'USD') {
        	request.ASI_CRM_VN_Amount__c = request.ASI_CRM_VN_Amount__c * contract.ASI_CRM_To_VND_Exchange_Rate__c;
        }
        
        //Vincent@2017/10/06 Round down the amount to nearest 100,000 VND
        If (request.ASI_CRM_VN_Amount__c > 100000) {
        	request.ASI_CRM_VN_Amount__c = request.ASI_CRM_VN_Amount__c - dblMOD((Double)request.ASI_CRM_VN_Amount__c, 100000);
        }
        
        //Vincent@2017/10/06 Assign remaining balance if current payment is last payment
        if(request.ASI_CRM_Payment_Time__c == Integer.valueOf(contractExpenditure.ASI_CRM_VN_Payment_Times__c)) {
            request.ASI_CRM_VN_Amount__c = contractExpenditure.ASI_CRM_Balance_Amount__c;
        }
        
        return request;
    }
    
    private void showError(sObject sObj, String errorMsg) {
    	sObj.addError(errorMsg);
    }
    
    /***************
  	Data Retrievement Function
  	***************/
	private List<ASI_GiftBox_Request_Header__c> retrieveRequestHeaderList(Set<Id> contractIdSet) {
    	String query = 'SELECT ' + genQueryField(REQUEST_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_GiftBox_Request_Header__c ' + 
                       'Where ASI_CRM_VN_Contract__c in :contractIdSet ' + 
                       'AND RecordType.DeveloperName in :CS_REQUEST_RECORD_TYPE_SET';
        
    	return (List<ASI_GiftBox_Request_Header__c>) Database.query(query);
    }
    
    private List<ASI_CRM_VN_Contract__c> retrieveContract(Set<Id> contractIdSet) {
    	String query = 'SELECT ' + genQueryField(CONTRACT_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_VN_Contract__c ' + 
                       'Where Id in :contractIdSet ';
        
    	return (List<ASI_CRM_VN_Contract__c>) Database.query(query);
  	}
    
    private List<ASI_CRM_VN_Contract_Expenditure__c> retrieveContractExpenditureList(Set<Id> contractIdSet) {
    	String query = 'SELECT ' + genQueryField(CONTRACT_EXPENDITURE_FIELD_MAP) +  
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_VN_Contract_Expenditure__c ' + 
                       'WHERE ASI_CRM_VN_Contract__c in :contractIdSet ' + 
                       'AND ASI_CRM_VN_Item__c = :LUMP_SUM_CONTRACT_EXPENDITURE';
        
    	return (List<ASI_CRM_VN_Contract_Expenditure__c>) Database.query(query);
  	}
    
    private List<ASI_CRM_VN_Bottle_Analysis__c> retrieveBottleAnalysisList(Set<Id> contractIdSet) {
        String query = 'SELECT ' + genQueryField(BOTTLE_ANALYSIS_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_VN_Bottle_Analysis__c ' + 
                       'Where ASI_CRM_VN_Contract__c in :contractIdSet ';
        
    	return (List<ASI_CRM_VN_Bottle_Analysis__c>) Database.query(query);
    } 
    
    private List<ASI_CRM_AccountsAdditionalField__c> retrieveCustomerList() {
        String query = 'SELECT Id, ASI_CRM_CN_Parent_Outlet__c ' + 
                       'FROM ASI_CRM_AccountsAdditionalField__c ' + 
                       'WHERE RecordType.DeveloperName in :OUTLET_RECORD_TYPE_SET ' + 
            		   'AND ASI_CRM_CN_Parent_Outlet__c != null';
        
        return (List<ASI_CRM_AccountsAdditionalField__c>) Database.query(query);
    }
    
    private List<ASI_CRM_AccountsAdditionalField__c> retrieveCustomerList(Set<Id> customerIdSet) {
        String query = 'SELECT Id, ASI_CRM_CN_Parent_Outlet__c ' + 
                       'FROM ASI_CRM_AccountsAdditionalField__c ' + 
                       'WHERE Id in :customerIdSet ';

        return (List<ASI_CRM_AccountsAdditionalField__c>) Database.query(query);
    }
    
    private List<ASI_MFM_SKU_Code__c> retrieveSKUList(Set<Id> skuIdSet) {
    	String query = 'SELECT ' + genQueryField(SKU_FIELD_MAP) + 
                       ', ASI_MFM_Sub_brand__r.ASI_CRM_BottleSize__c ' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_MFM_SKU_Code__c ' + 
                       'Where Id in :skuIdSet ';
        
    	return (List<ASI_MFM_SKU_Code__c>) Database.query(query);
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
    
    private List<ASI_CRM_VN_Sub_Brand_Conversion_Factor__c> retrieveConversionFactorList(Set<String> toSubBrandIdSet) {
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
	private Double dblMOD(Double num1, Integer num2){
        Double c = 0;
        Double result;
        result = num1 / num2;
        c= Math.floor(result);
        result = num1 - (num2 * c);
        return result;
	}
}