/*********************************************************************************
 * Name: ASI_TnE_HK_AssignApproverCtrl
 * Description: Controller class for T&E HK reassign approver controller
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 11/05/2017       Hugo Cheung             Created          
*/
public class ASI_TnE_HK_AssignApproverCtrl {
    
    //Field Map
    private final static Map<String, Schema.SObjectField> TNE_FIELD_MAP               = Schema.SObjectType.ASI_TnE_ClaimHeader__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> ROUTE_TYPE_FIELD_MAP        = Schema.SObjectType.ASI_TnE_Route_Type__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> ROUTE_TYPE_DETAIL_FIELD_MAP = Schema.SObjectType.ASI_TnE_Route_Rule_Detail__c.fields.getMap();
    
    public ASI_TnE_HK_AssignApproverCtrl() {
        
    }
    
    public PageReference reassignApprover() {
        String tneId = apexpages.currentpage().getparameters().get('id');
        
        ASI_TnE_ClaimHeader__c tneRecord = retrieveTnE(tneId);
        tneRecord = resetApprover(tneRecord);
        
        Set<Id> userIdSet = new Set<Id>();
        userIdSet.add(tneRecord.ASI_TnE_Payee_Employee__c == null ? tneRecord.ownerId : tneRecord.ASI_TnE_Payee_Employee__c);
        
        Map<String, ASI_TnE_Route_Type__c> routeTypeMap = new Map<String, ASI_TnE_Route_Type__c>();
        for(ASI_TnE_Route_Type__c routeType : retrieveRouteTypeWithDetailList()) {
            String key = '';
            if(String.isBlank(routeType.ASI_TnE_User__c)) {
                String companyName    = String.isBlank(routeType.ASI_TnE_Company__c) ? '' : routeType.ASI_TnE_Company__c;
                String departmentName = String.isBlank(routeType.ASI_TnE_Department__c) ? '' : routeType.ASI_TnE_Department__c;
                routeTypeMap.put(companyName + departmentName, routeType);
            } else {
                String userName = String.isBlank(routeType.ASI_TnE_User__c) ? '' : routeType.ASI_TnE_User__c;
                routeTypeMap.put(userName, routeType);
            }
            for(ASI_TnE_Route_Rule_Detail__c detail : routeType.ASI_TnE_Route_Rule_Details__r) {
                if(String.isNotBlank(detail.ASI_TnE_Approver_Name__c)) {
                    userIdSet.add(detail.ASI_TnE_Approver_Name__c);
                }
            }
        }
        
        Map<Id, User> userMap = new Map<Id, User>(retrieveUserList(userIdSet));
        
        Set<Id> classificationApproverList = new Set<Id>();
        
        Boolean needBUApproval = findClassificationApprover(tneRecord, classificationApproverList);
        tneRecord = assignApprover(tneRecord, userMap, routeTypeMap, needBUApproval, classificationApproverList);
        
        PageReference pageRef = new PageReference('/apex/ASI_SubmitApprovalPage?id=' + tneId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private ASI_TnE_ClaimHeader__c resetApprover(ASI_TnE_ClaimHeader__c tneRecord) {
        for(Integer i = 1 ; i <= 7 ; i++) {
            tneRecord.put('ASI_TnE_Sys_Approver_' + i + '__c', null) ;
        }
        tneRecord.put('ASI_TnE_Sys_Last_Approver__c', null) ;
        return tneRecord;
    }
    
    private Boolean findClassificationApprover(ASI_TnE_ClaimHeader__c tneRecord, Set<Id> classificationApproverList) {
        Boolean needBUApproval = false;
        for(ASI_TnE_ClaimDetail__c claimDetail : tneRecord.ASI_TnE_ClaimDetail__r) {
            ASI_JP_TnE_Expense_Classification__c expenseClassification = claimDetail.ASI_TnE_Expense_Classification__r;
            if(expenseClassification !=null){
                if(String.isNotBlank(expenseClassification.ASI_TnE_Approver__c)) {
                    classificationApproverList.add(expenseClassification.ASI_TnE_Approver__c);
                }
                for(Integer i = 2 ; i <= 4 ; i++) {
                    if(String.isNotBlank((String) expenseClassification.get('ASI_TnE_Approver_' + i + '__c'))) {
                        classificationApproverList.add((Id) expenseClassification.get('ASI_TnE_Approver_' + i + '__c'));
                    }
                }
                if(expenseClassification.ASI_TnE_BU_Finance__c) {
                    needBUApproval = true;
                }
            }
        }
        return needBUApproval;
    }
    
    private ASI_TnE_ClaimHeader__c assignApprover(ASI_TnE_ClaimHeader__c tneRecord, Map<Id, User> userMap, 
                                                  Map<String, ASI_TnE_Route_Type__c> routeTypeMap, Boolean needBUApproval, 
                                                  Set<Id> classificationApproverList) {
        Id ownerId = tneRecord.ASI_TnE_Payee_Employee__c == null ? tneRecord.ownerId : tneRecord.ASI_TnE_Payee_Employee__c;
        String key = (String.isNotBlank(userMap.get(ownerId).ASI_Company_Name__c) ? userMap.get(ownerId).ASI_Company_Name__c : '')
                                        + (String.isNotBlank(userMap.get(ownerId).ASI_Department__c) ? userMap.get(ownerId).ASI_Department__c : '');

        if(routeTypeMap.containsKey(ownerId)) {
            key = ownerId;
        }
        
        if(routeTypeMap.containsKey(key)) {
            Id buApprover = null;
            
            Id[] sortedApproverList = new Id[7];
            List<ASI_TnE_Route_Rule_Detail__c> routeTypeDetailList = routeTypeMap.get(key).ASI_TnE_Route_Rule_Details__r;
            for(ASI_TnE_Route_Rule_Detail__c routeTypeDetal : routeTypeDetailList) {
                if(routeTypeDetal.ASI_TnE_Approver_Type__c == 'Line Manager') {
                    sortedApproverList = checkApproverDuplication(sortedApproverList, userMap.get(ownerId).ManagerId);
                } else if(routeTypeDetal.ASI_TnE_Approver_Type__c == 'User') {
                    sortedApproverList = checkApproverDuplication(sortedApproverList, routeTypeDetal.ASI_TnE_Approver_Name__c);
                } else if(routeTypeDetal.ASI_TnE_Approver_Type__c == 'Checker') {
                    tneRecord.ASI_TnE_Checker__c = routeTypeDetal.ASI_TnE_Approver_Name__c;
                } else if(routeTypeDetal.ASI_TnE_Approver_Type__c == 'BU Finance') {
                    buApprover = routeTypeDetal.ASI_TnE_Approver_Name__c;
                }
            }
            
            if(needBUApproval && String.isNotBlank(buApprover)) {
                sortedApproverList = checkApproverDuplication(sortedApproverList, buApprover);
            }
            
            //Assign Sorted Approver
            for(Integer sortedApproverIndex = 0 ; sortedApproverIndex < 7 ; sortedApproverIndex++) {
                Id sortedApprover = sortedApproverList[sortedApproverIndex];
                for(Integer i = 1 ; i <= 7 ; i++) {
                    if(String.isBlank((String) tneRecord.get('ASI_TnE_Sys_Approver_' + i + '__c'))) {
                        tneRecord.put('ASI_TnE_Sys_Approver_' + i + '__c', sortedApprover);
                        break;
                    }
                }
            }
            
            for(Id classificationApprover : classificationApproverList) {
                for(Integer i = 1 ; i <= 7 ; i++) {
                    if(String.isBlank((String) tneRecord.get('ASI_TnE_Sys_Approver_' + i + '__c'))) {
                        tneRecord.put('ASI_TnE_Sys_Approver_' + i + '__c', classificationApprover);
                        break;
                    }
                }
            }
        }
        
        return tneRecord;
    }
    
    private List<Id> checkApproverDuplication(Id[] sortedApproverList, Id approval) {
        if(String.isBlank(approval)) return sortedApproverList;
        
        Boolean isDuplicate = false;
        for(Integer i = 0 ; i < 7 ; i++) {
            if(isDuplicate) {
                sortedApproverList[i] = null;
            }
            if(sortedApproverList[i] == approval) {
                isDuplicate = true;
            }
        }
        
        if(isDuplicate) {
            return sortedApproverList;
        }
        
        for(Integer i = 0 ; i < 7 ; i++) {
            if(sortedApproverList[i] == null) {
                sortedApproverList[i] = approval;
                break;
            }
        }
        
        return sortedApproverList;
    }
    
    /***************
    Data Retrievement Function
    ***************/
    private ASI_TnE_ClaimHeader__c retrieveTnE(Id tneId) {
        String query = 'SELECT ' + genQueryFIeld(TNE_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       ', (SELECT Id, ASI_TnE_Expense_Classification__r.ASI_TnE_Approver__c, ASI_TnE_Expense_Classification__r.ASI_TnE_Approver_4__c ' + 
                       ', ASI_TnE_Expense_Classification__r.ASI_TnE_Approver_2__c, ASI_TnE_Expense_Classification__r.ASI_TnE_Approver_3__c ' +
                       ', ASI_TnE_Expense_Classification__r.ASI_TnE_BU_Finance__c ' + 
                       'FROM ASI_TnE_ClaimDetail__r) ' + 
                       'FROM ASI_TnE_ClaimHeader__c ' + 
                       'WHERE Id = :tneId';
        List<ASI_TnE_ClaimHeader__c> tneList = (List<ASI_TnE_ClaimHeader__c>) Database.query(query);
        return tneList.size() > 0 ? tneList.get(0) : null;
    }
    
    private List<ASI_TnE_Route_Type__c> retrieveRouteTypeWithDetailList() {
        String query = 'SELECT ' + genQueryFIeld(ROUTE_TYPE_FIELD_MAP) +
                       ', (SELECT ' + genQueryFIeld(ROUTE_TYPE_DETAIL_FIELD_MAP) + ' FROM ASI_TnE_Route_Rule_Details__r Order By Name ASC) ' + 
                       'FROM ASI_TnE_Route_Type__c ' + 
                       'WHERE RecordType.DeveloperName = \'ASI_TnE_HK_Route_Type\'';
        return (List<ASI_TnE_Route_Type__c>) Database.query(query);
    }
    
    private List<User> retrieveUserList(Set<Id> userIdSet) {
        String query = 'SELECT Id, Name, ManagerId, Manager.ManagerId, CompanyName, Department, ASI_Company_Name__c, ASI_Department__c ' + 
                       'FROM User ' + 
                       'WHERE Id in :userIdSet';
        return (List<User>) Database.query(query);
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