/*********************************************************************************
 * Name:ASI_TnE_HK_TnEDetailCheckDel
 * Description: Cannot T&E Header Type is 'Corp Card'
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------
 * 09/18/2016       Laputa: Hugo            Created
*********************************************************************************/
public class ASI_TnE_HK_TnEDetailCheckDel extends ASI_TnE_TriggerAbstract {
    
  	private static final String PUBLIC_GROUP_RECORD_TYPE = 'ASI_TnE_HK_Finance_Users';
    private static final String CORP_CARD_TYPE           = 'Corp Card';
    
    public ASI_TnE_HK_TnEDetailCheckDel() {
        super('ASI_TnE_HK_TnEDetailCheckDel');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	List<ASI_TnE_ClaimDetail__c> claimDetailList      = (List<ASI_TnE_ClaimDetail__c>) sObjList;
        Map<Id, ASI_TnE_ClaimDetail__c> oldClaimDetailMap = (Map<Id, ASI_TnE_ClaimDetail__c>) oldMap;
        
        List<ASI_TnE_ClaimDetail__c> filteredClaimDetailList = filterClaimDetailList(claimDetailList, oldClaimDetailMap);
        if(filteredClaimDetailList != null && 
           filteredClaimDetailList.size() > 0) {
            checkClaimDetailDelete(filteredClaimDetailList);
        }
    }
    
    private List<ASI_TnE_ClaimDetail__c> filterClaimDetailList(List<ASI_TnE_ClaimDetail__c> claimDetailList, Map<Id, ASI_TnE_ClaimDetail__c> oldClaimDetailMap) {
        return oldClaimDetailMap.values();
    }
    
    private void checkClaimDetailDelete(List<ASI_TnE_ClaimDetail__c> claimDetailList) {
        if(retrieveFinanceState(UserInfo.getUserId())) {
            return;
        }
        
        Set<Id> headerIdSet = new Set<Id>();
        for(ASI_TnE_ClaimDetail__c claimDetail : claimDetailList) {
            headerIdSet.add(claimDetail.ASI_TnE_ClaimHeader__c);
        }
        
        Map<Id, ASI_TnE_ClaimHeader__c> claimHeaderMap = new Map<Id, ASI_TnE_ClaimHeader__c>(retrieveHeaderList(headerIdSet));
        for(ASI_TnE_ClaimDetail__c claimDetail : claimDetailList) {
            if(claimDetail.ASI_TnE_Sys_IsClone__c) {
                continue;
            }
            
       		if(claimHeaderMap.get(claimDetail.ASI_TnE_ClaimHeader__c).ASI_TnE_Type__c == CORP_CARD_TYPE) {
            	claimDetail.addError(Label.ASI_TnE_HK_Cannot_Del_Corp_Card);
            }
        }
    }
    
    private Boolean retrieveFinanceState(Id userId) {
	    List<GroupMember> publicGroupList = [SELECT Id
	                                       	 FROM GroupMember
	                                         Where GroupId in (SELECT Id FROM Group WHERE DeveloperName =: PUBLIC_GROUP_RECORD_TYPE)
	                                         AND UserOrGroupId =: userId];
	    return publicGroupList.size() > 0 ? true : false;
  	}
    
    /***************
  	Data Retrievement Function
  	***************/
    private List<ASI_TnE_ClaimHeader__c> retrieveHeaderList(Set<Id> headerIdSet) {
    	String query = 'SELECT Id, ASI_TnE_Type__c ' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_TnE_ClaimHeader__c ' + 
                       'Where Id in :headerIdSet ';
        
    	return (List<ASI_TnE_ClaimHeader__c>) Database.query(query);
  	}
}