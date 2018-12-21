/*********************************************************************************
 * Name: ASI_CRM_VN_ContractCtrl
 * Description: Controller for ASI_CRM_VN_ContractPage
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 22/06/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_VN_ContractCtrl {
    
	//Field Map
	private final static Map<String, Schema.SObjectField> CONTRACT_FIELD_MAP = Schema.SObjectType.ASI_CRM_VN_Contract__c.fields.getMap();
    
    //Marketing Contract User Permission Set Name
    private final static String MARKETING_CONTRACT_USER_PERMISSION_SET = 'ASI CRM VN Marketing Contract User';
    
    //System Admin Profile
    private final static String SYSTEM_ADMIN_PROFILE = 'System Administrator';
    
    //Standard Variable
    private final static String DRAFT_STATUS          = 'Draft';
    private final static String PENDING_STATUS        = 'Pending Verification';
    private final static String APPROVED_STATUS       = 'Approved';
    private final static Set<String> CLOSE_STATUS_SET = new Set<String> {
    	'Closed', 
 		'Closed(Terminated)'
    };
    
    public String contractId {get; set;}
    
    //Page Control Flag
    public Boolean isEditable         {get; set;}
    public Boolean isMarketingUser    {get; set;}
    public Boolean isAdmin            {get; set;}
    public Boolean needApproval       {get; set;}
    public Boolean needVerificate     {get; set;}
    public Boolean needSetDraft       {get; set;}
    public Boolean allowCreateRequest {get; set;}
    public Boolean allowExtendClose   {get; set;}
    public Boolean showPDFButton      {get; set;}
    
    public ASI_CRM_VN_ContractCtrl(ApexPages.StandardController standardController) {
        contractId = standardController.getId();
        initPage(retrieveContract(contractId));
    }
    
    private void initPage(ASI_CRM_VN_Contract__c contract) {
		if(contract == null) {
        	return;
        }
        
        User owner       = retrieveUser(contract.ownerId);
        User currentUser = retrieveUser(UserInfo.getUserId());
        
        isMarketingUser = checkIsUserHasPermissionSet(UserInfo.getUserId(), MARKETING_CONTRACT_USER_PERMISSION_SET);
        isAdmin         = checkIsSystemAdmin(UserInfo.getUserId(), SYSTEM_ADMIN_PROFILE);
        
        if(contract.ASI_CRM_Contract_Status__c == DRAFT_STATUS) {
        	isEditable = true;
        } else {
        	isEditable = false;
        }
        
        if(contract.ASI_CRM_Contract_Status__c == DRAFT_STATUS) {
        	needApproval = true;
        } else {
        	needApproval = false;
        }
        
        if(contract.ASI_CRM_Contract_Status__c == PENDING_STATUS &&
           isMarketingUser) {
        	needVerificate = true;
        } else {
        	needVerificate = false;
        }
        
        if(CLOSE_STATUS_SET.contains(contract.ASI_CRM_Contract_Status__c) || 
           contract.ASI_CRM_Contract_Status__c == APPROVED_STATUS) {
        	allowCreateRequest = true;
        } else {
        	allowCreateRequest = false;
        }
        
        if(contract.ASI_CRM_Contract_Status__c == APPROVED_STATUS) {
        	allowExtendClose = true;
        } else {
        	allowExtendClose = false;
        }
        
        if(CLOSE_STATUS_SET.contains(contract.ASI_CRM_Contract_Status__c) || 
           contract.ASI_CRM_Contract_Status__c == APPROVED_STATUS) {
        	showPDFButton = true;
        } else {
            showPDFButton = false;
        }
        
        if(contract.ASI_CRM_Contract_Status__c == APPROVED_STATUS && 
           owner.ManagerId == UserInfo.getUserId()) {
        	needSetDraft = true; 
        } else if(contract.ASI_CRM_Contract_Status__c == PENDING_STATUS && 
                  isMarketingUser){
        	needSetDraft = true;
        } else {
        	needSetDraft = false;
        }
    }
    
    /***************
  	Data Retrievement Function
  	***************/
    private ASI_CRM_VN_Contract__c retrieveContract(Id contractId) {
    	String query = 'SELECT ' + genQueryField(CONTRACT_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_CRM_VN_Contract__c ' + 
                       'Where Id = :contractId ';
        
        List<ASI_CRM_VN_Contract__c> contractList = (List<ASI_CRM_VN_Contract__c>) Database.query(query);
        
    	return contractList.size() == 0 ? null : contractList.get(0);
  	}
    
    private User retrieveUser(Id userId) {
    	String query = 'SELECT Id, FirstName, ManagerId ' + 
                       'FROM User ' + 
                       'WHERE Id = :userId ';
        
        List<User> userList = (List<User>) Database.query(query);
        return userList.size() == 0 ? null : userList.get(0);
    }
    
    private Boolean checkIsUserHasPermissionSet(Id userId, String permissionName) {
    	String query = 'SELECT AssigneeId ' + 
                       'FROM PermissionSetAssignment ' + 
                       'WHERE AssigneeId = :userId ' + 
                       'AND PermissionSet.Label = :permissionName';
        List<PermissionSetAssignment> permissionSetAssignmentList = (List<PermissionSetAssignment>) Database.query(query);
        if(permissionSetAssignmentList.size() > 0) {
        	return true;
        } else {
        	return false;
        }   
    }
    
    private Boolean checkIsSystemAdmin(Id userId, String profileName) {
        Id profileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
        System.debug('Profile : ' + profileId);
        String query = 'SELECT profileId ' + 
                       'FROM User ' + 
                       'WHERE Id = :userId ' + 
                       'AND profileId = :profileId ';
        List<User> userList = (List<User>) Database.query(query);
        System.debug('User List : ' + userList);
        if(userList.size() > 0) {
        	return true;
        } else {
        	return false;
        }
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