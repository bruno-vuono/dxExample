/*********************************************************************************
 * Name:ASI_TnE_HK_TnEHeaderCheckDel
 * Description: Cannot T&E Header Type is 'Corp Card'
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------
 * 09/18/2016       Laputa: Hugo            Created
*********************************************************************************/
public class ASI_TnE_HK_TnEHeaderCheckDel extends ASI_TnE_TriggerAbstract {
    
  	private static final String PUBLIC_GROUP_RECORD_TYPE = 'ASI_TnE_HK_Finance_Users';
    private static final String CORP_CARD_TYPE           = 'Corp Card';
    
    public ASI_TnE_HK_TnEHeaderCheckDel() {
        super('ASI_TnE_HK_TnEHeaderCheckDel');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	List<ASI_TnE_ClaimHeader__c> claimHeaderList = (List<ASI_TnE_ClaimHeader__c>) sObjList;
        Map<Id, ASI_TnE_ClaimHeader__c> claimHeaderMap = (Map<Id, ASI_TnE_ClaimHeader__c>) oldMap;
        
        List<ASI_TnE_ClaimHeader__c> filteredClaimHeaderList = filterClaimHeaderList(claimHeaderList, claimHeaderMap);
        if(filteredClaimHeaderList != null && 
           filteredClaimHeaderList.size() > 0) {
            checkClaimHeaderDelete(filteredClaimHeaderList);
        }
    }
    
    private List<ASI_TnE_ClaimHeader__c> filterClaimHeaderList(List<ASI_TnE_ClaimHeader__c> claimHeaderList, Map<Id, ASI_TnE_ClaimHeader__c> claimHeaderMap) {
    	List<ASI_TnE_ClaimHeader__c> filteredClaimHeaderList = new List<ASI_TnE_ClaimHeader__c>();
        for(ASI_TnE_ClaimHeader__c claimHeader : claimHeaderMap.values()) {
            if(claimHeader.ASI_TnE_Type__c == CORP_CARD_TYPE) {
                filteredClaimHeaderList.add(claimHeader);
            }
        }
        return filteredClaimHeaderList;
    }
    
    private void checkClaimHeaderDelete(List<ASI_TnE_ClaimHeader__c> claimHeaderList) {
        if(retrieveFinanceState(UserInfo.getUserId())) {
            return;
        }
        for(ASI_TnE_ClaimHeader__c claimHeader : claimHeaderList) {
            claimHeader.addError(Label.ASI_TnE_HK_Cannot_Del_Corp_Card);
        }
    }
    
    private Boolean retrieveFinanceState(Id userId) {
	    List<GroupMember> publicGroupList = [SELECT Id
	                                       	 FROM GroupMember
	                                         Where GroupId in (SELECT Id FROM Group WHERE DeveloperName =: PUBLIC_GROUP_RECORD_TYPE)
	                                         AND UserOrGroupId =: userId];
	    return publicGroupList.size() > 0 ? true : false;
  	}
}