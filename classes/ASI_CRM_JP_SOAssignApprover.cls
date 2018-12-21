/*********************************************************************************
 * Name: ASI_CRM_JP_SOAssignApprover
 * Description: Assign the approver of sales order
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 31/05/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_JP_SOAssignApprover extends ASI_CRM_JP_TriggerAbstract {
    
	private final static Map<String, Schema.SObjectField> ROUTE_TYPE_FIELD_MAP        = Schema.SObjectType.ASI_CRM_Route_Type__c.fields.getMap();
	private final static Map<String, Schema.SObjectField> ROUTE_TYPE_DETAIL_FIELD_MAP = Schema.SObjectType.ASI_CRM_Route_Rule_Detail__c.fields.getMap();
    
    private final static String ROUTE_TYPE_RECORD_TYPE = 'ASI_CRM_JP_Sales_Order_Route_Type';
    
    private final static String ENTERTAINMENT_SALES_ORDER_RECORD_TYPE = 'ASI_CRM_JP_Entertainment_Sales';
    private final static String MARKETING_FOC_SALES_ORDER_RECORD_TYPE = 'ASI_CRM_JP_Marketing_FOC';
    
    private final static Map<String, String> RECORD_TYPE_FILTER_SET = new Map<String, String> {
    	'ASI_CRM_JP_Direct_Sales' => 'Direct Sales SO',
        'ASI_CRM_JP_Entertainment_Sales' => 'Entertainment SO',
        'ASI_CRM_JP_Marketing_FOC' => 'Marketing FOC',
        'ASI_CRM_JP_Sample_Sales' => 'Sample SO'
    };
    
    private final static List<String> RECORD_TYPE_MODULE_FILTER_LIST = RECORD_TYPE_FILTER_SET.values();
    
    private final static String ROUTE_TYPE_MODULE = 'Sales Order';
    
    public ASI_CRM_JP_SOAssignApprover() {
        super('ASI_CRM_JP_SOAssignApprover');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	List<ASI_CRM_JP_Sales_Order__c> salesOrderList = (List<ASI_CRM_JP_Sales_Order__c>) sObjList;
        Map<Id, ASI_CRM_JP_Sales_Order__c> salesOrderMap = (Map<Id, ASI_CRM_JP_Sales_Order__c>) oldMap;
        
        List<ASI_CRM_JP_Sales_Order__c> filteredSalesOrderList = filterSalesOrderList(salesOrderList, salesOrderMap);
       	if(filteredSalesOrderList == null || filteredSalesOrderList.size() == 0) {
            return;
        }
        
        resetApprover(filteredSalesOrderList);
        assignApprover(filteredSalesOrderList);
    }
    
    private List<ASI_CRM_JP_Sales_Order__c> filterSalesOrderList(List<ASI_CRM_JP_Sales_Order__c> salesOrderList, Map<Id, ASI_CRM_JP_Sales_Order__c> salesOrderMap) {        
        List<ASI_CRM_JP_Sales_Order__c> filteredSalesOrderList = new List<ASI_CRM_JP_Sales_Order__c>();
        for(ASI_CRM_JP_Sales_Order__c salesOrder : salesOrderList) {
            if(RECORD_TYPE_FILTER_SET.containsKey(Global_RecordTypeCache.getRt(salesOrder.RecordTypeId).developerName)) {
                filteredSalesOrderList.add(salesOrder);
            }
        }
        
        return filteredSalesOrderList;
    }
    
    private void resetApprover(List<ASI_CRM_JP_Sales_Order__c> salesOrderList) {
        for(ASI_CRM_JP_Sales_Order__c salesOrder : salesOrderList) {
            for(Integer i = 1 ; i < 7 ; i++) {
                salesOrder.put('ASI_CRM_JP_Approver_' + i + '__c', null);
            }
        }
    }
    
    private void assignApprover(List<ASI_CRM_JP_Sales_Order__c> salesOrderList) {
        Map<String, ASI_CRM_Route_Type__c> routeTypeMap = retrieveRouteTypeList();
        if(routeTypeMap == null || routeTypeMap.size() == 0) {
        	return;
        }
        
        Set<Id> userIdSet = new Set<Id>();
        for(ASI_CRM_JP_Sales_Order__c salesOrder : salesOrderList) {
            if(Global_RecordTypeCache.getRt(salesOrder.RecordTypeId).developerName == ENTERTAINMENT_SALES_ORDER_RECORD_TYPE &&
               String.isNotBlank(salesOrder.ASI_CRM_JP_Entertainment_Owner__c)) {
                userIdSet.add(salesOrder.ASI_CRM_JP_Entertainment_Owner__c);
            } else {
            	userIdSet.add(salesOrder.ownerId);
            }
        }
        
        Map<Id, User> userMap = retrieveUser(userIdSet);
        
        for(ASI_CRM_JP_Sales_Order__c salesOrder : salesOrderList) {
            String moduleName = RECORD_TYPE_FILTER_SET.get(Global_RecordTypeCache.getRt(salesOrder.RecordTypeId).developerName);
            ASI_CRM_Route_Type__c routeType = routeTypeMap.get(moduleName);
            
            if(routeTypeMap.containsKey(moduleName + '_' + salesOrder.OwnerId)) {
                routeType = routeTypeMap.get(moduleName + '_' + salesOrder.OwnerId);
            }
            
            if(userMap.containsKey(salesOrder.ownerId) && 
               routeTypeMap.containsKey(moduleName + '_' + userMap.get(salesOrder.ownerId).UserRole.Name)) {
                routeType = routeTypeMap.get(moduleName + '_' + userMap.get(salesOrder.ownerId).UserRole.Name);
            }
            
            System.debug('Debug Log : ' + routeType);
            System.debug('Debug Log : ' + routeType.ASI_CRM_Route_Rule_Details__r);
            
            if(routeType == null) {
            	continue;
            }
            
            Integer approverIndex = 1;
            for(ASI_CRM_Route_Rule_Detail__c routeTypeDetail : routeType.ASI_CRM_Route_Rule_Details__r) {
                if(routeTypeDetail.ASI_CRM_JP_Approver_Type__c == 'Line Manager') {
                    if(Global_RecordTypeCache.getRt(salesOrder.RecordTypeId).developerName == ENTERTAINMENT_SALES_ORDER_RECORD_TYPE &&
                       String.isNotBlank(salesOrder.ASI_CRM_JP_Entertainment_Owner__c)) {
                		salesOrder.put('ASI_CRM_JP_Approver_' + approverIndex + '__c', userMap.get(salesOrder.ASI_CRM_JP_Entertainment_Owner__c).ManagerId);
                    	approverIndex++;
                	} else {
                		salesOrder.put('ASI_CRM_JP_Approver_' + approverIndex + '__c', userMap.get(salesOrder.ownerId).ManagerId);
                		approverIndex++;
                    }
                } else {
                    if(Global_RecordTypeCache.getRt(salesOrder.RecordTypeId).developerName == MARKETING_FOC_SALES_ORDER_RECORD_TYPE) {
                        if(String.isNotBlank(routeTypeDetail.ASI_CRM_Marketing_FOC_Mapping__c) &&
                           salesOrder.get(routeTypeDetail.ASI_CRM_Marketing_FOC_Mapping__c) == true) {
                    		salesOrder.put('ASI_CRM_JP_Approver_' + approverIndex + '__c', routeTypeDetail.ASI_CRM_Approver__c);
                			approverIndex++;
                        }
                    } else {
                    	salesOrder.put('ASI_CRM_JP_Approver_' + approverIndex + '__c', routeTypeDetail.ASI_CRM_Approver__c);
                		approverIndex++;
                    }
                }
            }
        }
    }
    
    /***************
	Data Retrievement Function
	***************/
    private Map<String, ASI_CRM_Route_Type__c> retrieveRouteTypeList() {
        String query = 'SELECT ' + genQueryField(ROUTE_TYPE_FIELD_MAP) + ' ' + 
                       ', (SELECT ' + genQueryField(ROUTE_TYPE_DETAIL_FIELD_MAP) + ' FROM ASI_CRM_Route_Rule_Details__r ORDER BY ASI_CRM_JP_Approval_Sequence__c) ' + 
                       'FROM ASI_CRM_Route_Type__c ' + 
                       'WHERE RecordType.DeveloperName = :ROUTE_TYPE_RECORD_TYPE ' + 
                       'AND ASI_CRM_Module__c = :ROUTE_TYPE_MODULE ' + 
                       'AND ASI_CRM_Module_Record_Type__c in :RECORD_TYPE_MODULE_FILTER_LIST';
        
        Map<String, ASI_CRM_Route_Type__c> routeTypeMap = new Map<String, ASI_CRM_Route_Type__c>();
        for(ASI_CRM_Route_Type__c routeType : (List<ASI_CRM_Route_Type__c>) Database.query(query)) {
            String key = routeType.ASI_CRM_Module_Record_Type__c;
            if(String.isNotBlank(routeType.ASI_CRM_User__c)) {
            	key += '_' + routeType.ASI_CRM_User__c;
            }
            if(String.isNotBlank(routeType.ASI_CRM_Role__c)) {
            	key += '_' + routeType.ASI_CRM_Role__c;
            }
            if(routeTypeMap.containsKey(key) == false) {
            	routeTypeMap.put(key, routeType);
            }
        }
        
        return routeTypeMap;
    }
    
    private Map<Id, User> retrieveUser(Set<Id> userIdSet) {
        String query = 'SELECT Id, ManagerId, UserRole.Name ' + 
                       'FROM User ' + 
                       'WHERE Id in : userIdSet';
        return new Map<Id, User>((List<User>) Database.query(query));
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