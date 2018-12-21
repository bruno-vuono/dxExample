/*********************************************************************************
 * Name:ASI_TnE_TW_ClaimsDetailValidation
 * Description: Validation for claims detail
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------
 * 23/11/2015         Laputa: Hank            Created
*********************************************************************************/

public without sharing class ASI_TnE_TW_ClaimsDetailValidation extends ASI_TnE_TriggerAbstract {

    public ASI_TnE_TW_ClaimsDetailValidation() {
        super('ASI_TnE_TW_ClaimsDetailValidation');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        List<ASI_TnE_ClaimDetail__c> detailList = (List<ASI_TnE_ClaimDetail__c>)sObjList;
        Set<Id> headerIdSet = new Set<Id>();
        if(oldMap == null){
            for(ASI_TnE_ClaimDetail__c detail:detailList){
                headerIDSet.add(detail.ASI_TnE_ClaimHeader__c);    
            }
        }else{
            Map<Id, ASI_TnE_ClaimDetail__c> detailOldMap = (Map<Id, ASI_TnE_ClaimDetail__c>)oldMap;
            for(ASI_TnE_ClaimDetail__c detail:detailList){
                if(detail.ASI_TnE_Receipt_Date__c != detailOldMap.get(detail.Id).ASI_TnE_Receipt_Date__c || detail.ASI_TnE_KR_Receipt_Time__c == null){
                    headerIDSet.add(detail.ASI_TnE_ClaimHeader__c);    
                }  
            }
        }
        
        //Get owner/payee information from header
        Map<Id, ASI_TnE_ClaimHeader__c> headerMap = new Map<Id, ASI_TnE_ClaimHeader__c>(
            [Select Id, 
                    ownerId, 
                    owner.firstname,
                    ASI_TnE_Payee_Employee__c
             From ASI_TnE_ClaimHeader__c 
             Where Id In:headerIdSet
            ]
        );
        
        
        if(oldMap == null){
            for(ASI_TnE_ClaimDetail__c detail:detailList){
               detail.ASI_TnE_KR_Receipt_Time__c = headerMap.get(detail.ASI_TnE_ClaimHeader__c).ownerId + 
                                                   headerMap.get(detail.ASI_TnE_ClaimHeader__c).owner.firstname + 
                                                   ((detail.ASI_TnE_Receipt_Date__c == null)?'':string.valueof(detail.ASI_TnE_Receipt_Date__c.year())) + 
                                                   ((detail.ASI_TnE_Receipt_Date__c == null)?'':string.valueof(detail.ASI_TnE_Receipt_Date__c.month())) +
                                                   ((detail.ASI_TnE_Receipt_Date__c == null)?'':string.valueof(detail.ASI_TnE_Receipt_Date__c.day()));
            }
        }else{
            Map<Id, ASI_TnE_ClaimDetail__c> detailOldMap = (Map<Id, ASI_TnE_ClaimDetail__c>)oldMap;
            for(ASI_TnE_ClaimDetail__c detail:detailList){
                if(detail.ASI_TnE_Receipt_Date__c != detailOldMap.get(detail.Id).ASI_TnE_Receipt_Date__c || detail.ASI_TnE_KR_Receipt_Time__c == null){
                    system.debug('Validation check: ' + headerMap.get(detail.ASI_TnE_ClaimHeader__c).ownerId);
                    detail.ASI_TnE_KR_Receipt_Time__c = headerMap.get(detail.ASI_TnE_ClaimHeader__c).ownerId + 
                                                        headerMap.get(detail.ASI_TnE_ClaimHeader__c).owner.firstname + 
                                                        ((detail.ASI_TnE_Receipt_Date__c == null)?'':string.valueof(detail.ASI_TnE_Receipt_Date__c.year())) + 
                                                        ((detail.ASI_TnE_Receipt_Date__c == null)?'':string.valueof(detail.ASI_TnE_Receipt_Date__c.month())) +
                                                        ((detail.ASI_TnE_Receipt_Date__c == null)?'':string.valueof(detail.ASI_TnE_Receipt_Date__c.day()));  
                }      
            } 
        }
    }
}