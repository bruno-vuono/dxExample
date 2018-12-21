/*********************************************************************************
 * Name:ASI_CRM_VN_AfterUpdateRegion
 * Description: Update RSP Region field when customers' Region field change
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 16/12/2014       Laputa: Patrick          Created
*********************************************************************************/

public with sharing class ASI_CRM_VN_AccountsAdditional_TriggerCls extends ASI_HK_CRM_TriggerAbstract {

    public ASI_CRM_VN_AccountsAdditional_TriggerCls() {
        super('ASI_CRM_VN_AccountsAdditional_TriggerCls');
    }
    
     public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
     
       
        List<ASI_CRM_AccountsAdditionalField__c> detailList = (List<ASI_CRM_AccountsAdditionalField__c>)sObjList; //get AccountsAdditionalField object details
        Map<Id, ASI_CRM_AccountsAdditionalField__c> customerMap = new Map<Id, ASI_CRM_AccountsAdditionalField__c>();    
        List<ASI_TH_CRM_RSP__c> rsps = new List<ASI_TH_CRM_RSP__c>();
        
        // change AccountsAdditionalField  object data list to map
        for (ASI_CRM_AccountsAdditionalField__c customer: detailList ) {
            customerMap.put(customer.Id,customer);
        }
       
        //get all rsp details related to customers      
        rsps = [select id, ASI_CRM_CN_Customer__c,ASI_CRM_Region__c from ASI_TH_CRM_RSP__c where ASI_CRM_CN_Customer__c In :customerMap.keySet()];      
         
        for(ASI_TH_CRM_RSP__c rsp : rsps){
           rsp.ASI_CRM_Region__c = customerMap.get(rsp.ASI_CRM_CN_Customer__c).ASI_CRM_VN_Region__c;
        }

        update rsps;
     
     
     }
}