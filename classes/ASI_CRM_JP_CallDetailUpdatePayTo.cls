/*********************************************************************************
 * Name:ASI_CRM_JP_CallDetailUpdatePayTo
 * Description: Update PayTo when status changes to 'Achieved' 
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 18/03/2016       Laputa: Hank          Created
*********************************************************************************/

public with sharing class ASI_CRM_JP_CallDetailUpdatePayTo extends ASI_CRM_JP_TriggerAbstract {

    public ASI_CRM_JP_CallDetailUpdatePayTo() {
        super('ASI_CRM_JP_CallDetailUpdatePayTo');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        List<ASI_CRM_Call_Detail__c> detailList = (List<ASI_CRM_Call_Detail__c>)sObjList;
        Set<Id> cusIdSet = new Set<Id>();
        Map<ID, ASI_CRM_Call_Detail__c> oldDetailMap= new Map<ID, ASI_CRM_Call_Detail__c>();
        if (oldMap != null){
            oldDetailMap = (Map<ID, ASI_CRM_Call_Detail__c>) oldMap;
        }
        if(oldMap == null){
        }
        else{
            for(ASI_CRM_Call_Detail__c detail: detailList){
                if(detail.ASI_CRM_Status__c == 'Achieved' && detail.ASI_CRM_Status__c != oldDetailMap.get(detail.Id).ASI_CRM_Status__c && detail.ASI_CRM_Payment_Option__c == 'Invoice'){
                    cusIdSet.add(detail.ASI_CRM_Customer__c);   
                }
            }    
        }
        //Get CRM Code from customer
        Map<Id, ASI_CRM_AccountsAdditionalField__c> cusMap = new Map<Id, ASI_CRM_AccountsAdditionalField__c>([Select Id, ASI_CRM_CN_JDE_Code__c From ASI_CRM_AccountsAdditionalField__c Where Id In :cusIdSet]);
        List<String> crmCodeList = new List<String>();
        for(ASI_CRM_AccountsAdditionalField__c acc:cusMap.values()){
            crmCodeList.add(acc.ASI_CRM_CN_JDE_Code__c);
        }
        Map<String, ASI_CRM_Pay_To__c> payToMap = new map<String,ASI_CRM_Pay_To__c>();
        for(ASI_CRM_Pay_To__c payTo:[Select Id, ASI_CRM_Pay_to_No__c, Name From ASI_CRM_Pay_To__c Where ASI_CRM_Pay_to_No__c In:crmCodeList]){
            payToMap.put(payTo.ASI_CRM_Pay_to_No__c, payTo);
        }
        if(oldMap == null){
        }
        else{
            for(ASI_CRM_Call_Detail__c detail: detailList){
                if(detail.ASI_CRM_Status__c == 'Achieved' && detail.ASI_CRM_Status__c != oldDetailMap.get(detail.Id).ASI_CRM_Status__c && detail.ASI_CRM_Payment_Option__c == 'Invoice'){
                    if(cusMap.get(detail.ASI_CRM_Customer__c).ASI_CRM_CN_JDE_Code__c == null ||
                            payToMap.get(cusMap.get(detail.ASI_CRM_Customer__c).ASI_CRM_CN_JDE_Code__c) == null){
                        detail.addError(System.Label.ASI_CRM_JP_CannotFindPayTo);
                    }else{
                        detail.ASI_CRM_Pay_To__c = payToMap.get(cusMap.get(detail.ASI_CRM_Customer__c).ASI_CRM_CN_JDE_Code__c).Id; 
                    }   
                }
            }    
        }
    }
    
}