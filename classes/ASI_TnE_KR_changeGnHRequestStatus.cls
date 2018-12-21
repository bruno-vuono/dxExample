/*********************************************************************************
 * Name:ASI_TnE_KR_changeGnHRequestStatus 
 * Description: Handler for ASI_TnE_ClaimHeader__c to 
 *              update GnH status after the TnE is approved or rejected
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    -------------------------------------
 * 29/5/2017         Laputa: Kevin Choi      Created
*********************************************************************************/
public with sharing class ASI_TnE_KR_changeGnHRequestStatus extends ASI_TnE_TriggerAbstract{
    private final static String approvedStatus = 'Approved';
    private final static String completedStatus = 'Completed';
    
    public ASI_TnE_KR_changeGnHRequestStatus(){
        super('ASI_TnE_KR_changeGnHRequestStatus');
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        List<ASI_TnE_ClaimHeader__c> tneClaimList = (List<ASI_TnE_ClaimHeader__c>) sObjList;  
        Map<ID,ASI_TnE_ClaimHeader__c> tneClaimOldMap = (Map<ID,ASI_TnE_ClaimHeader__c>) oldMap;
        Map<ID,ASI_TnE_ClaimHeader__c> tneClaimMap = (Map<ID,ASI_TnE_ClaimHeader__c>) newMap;
        //system.debug('Start Changing GnH Request Status');

        Set<Id> claimUpdateList = new Set<Id>();
        Set<Id> claimRestoreList = new Set<Id>();
        for (ASI_TnE_ClaimHeader__c claim : tneClaimList){
           //system.debug('Old status: '+tneClaimOldMap.get(claim.Id).ASI_TnE_Status__c+' Now Status: '+tneClaimMap.get(claim.Id).ASI_TnE_Status__c); 
            if ((tneClaimOldMap.get(claim.Id).ASI_TnE_Status__c == 'Draft' && tneClaimMap.get(claim.Id).ASI_TnE_Status__c =='Submitted')||
                (tneClaimOldMap.get(claim.Id).ASI_TnE_Status__c == 'Rejected' && tneClaimMap.get(claim.Id).ASI_TnE_Status__c =='Submitted')){
                claimUpdateList.add(claim.Id);
                //system.debug('Added to Update List');
            }
            else if ((tneClaimOldMap.get(claim.Id).ASI_TnE_Status__c == 'Submitted' && tneClaimMap.get(claim.Id).ASI_TnE_Status__c =='Rejected')||
                 (tneClaimOldMap.get(claim.Id).ASI_TnE_Status__c == 'Submitted' && tneClaimMap.get(claim.Id).ASI_TnE_Status__c =='Draft')){
                claimRestoreList.add(claim.Id); 
                //system.debug('Added to Restore List');
            }   
        }
        //system.debug('Update List: '+claimUpdateList+' Restore List: '+claimRestoreList);
        if (claimUpdateList.size() > 0 || claimRestoreList.size() > 0){
            retrieveClaimDetails(claimUpdateList,claimRestoreList);
        }
    }
 /**********************************
  get all related claim details and 
  retrieve GnH requests
***********************************/

    private void retrieveClaimDetails(Set<Id> claimUpdateList, Set<Id> claimRestoreList){
        claimUpdateList = claimUpdateList == null? new Set<Id>():claimUpdateList;
        claimRestoreList = claimRestoreList == null? new Set<Id>():claimRestoreList;
        //system.debug('Start finding claim details');
        List<ASI_TnE_ClaimDetail__c> claimDetailsList = [select Id,ASI_TnE_GnH_Request__c,ASI_TnE_ClaimHeader__c from ASI_TnE_ClaimDetail__c 
                                                         where ASI_TnE_ClaimHeader__c IN :claimUpdateList OR ASI_TnE_ClaimHeader__c IN :claimRestoreList];

        Set<Id> changeGnHCompleted = new Set<Id>();
        Set<Id> changeGnHApproved = new Set<Id>();
        for (ASI_TnE_ClaimDetail__c detail : claimDetailsList){            
            if (claimUpdateList.contains(detail.ASI_TnE_ClaimHeader__c)){

                changeGnHCompleted.add(detail.ASI_TnE_GnH_Request__c);

            }else if(claimRestoreList.contains(detail.ASI_TnE_ClaimHeader__c)){

                changeGnHApproved.add(detail.ASI_TnE_GnH_Request__c);

            }
        }
        //system.debug('Change to Completed List: '+changeGnHCompleted+' Restore to Approved List: '+changeGnHApproved);
        if (changeGnHCompleted.size() > 0 ||changeGnHApproved.size() > 0){
            changeGnHStatus(changeGnHCompleted, changeGnHApproved);
        }        
    }
 /**************************************
  get the GnH request and update status
***************************************/
    private void changeGnHStatus(Set<Id> changeGnHCompleted, Set<Id> changeGnHApproved){
        List<ASI_GnH_Request__c> requestUpdateList = new List<ASI_GnH_Request__c>();
        if (!changeGnHCompleted.isEmpty()){
            List<ASI_GnH_Request__c> gnhRequestList = [select Id,Name,  ASI_GnH_Status__c 
                                                       from ASI_GnH_Request__c where Id IN : changeGnHCompleted];

            for (ASI_GnH_Request__c request : gnhRequestList){
                request.ASI_GnH_Status__c = 'Completed';
                requestUpdateList.add(request);
                //system.debug(request.Name+' changed to '+request.ASI_GnH_Status__c);
            }

        }
        if (!changeGnHApproved.isEmpty()){
            List<ASI_GnH_Request__c> gnhRequestList = [select Id,Name, ASI_GnH_Status__c 
                                                       from ASI_GnH_Request__c where Id IN : changeGnHApproved];
            
            for (ASI_GnH_Request__c request : gnhRequestList){
                request.ASI_GnH_Status__c = 'Approved';
                requestUpdateList.add(request);
                //system.debug(request.Name+' changed to ' + request.ASI_GnH_Status__c);
            }
        }
        
        if(requestUpdateList.size() > 0){
            ///system.debug('To be updated: ' + requestUpdateList);
            update requestUpdateList;
        }
    }
}