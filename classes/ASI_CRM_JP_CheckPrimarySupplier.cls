/*********************************************************************************
 * Name:ASI_CRM_JP_CheckPrimarySupplier
 * Description: Check for changes in Primary Regular Supplier
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------
 * 23/1/2015       Laputa: Hank             Created
*********************************************************************************/

public without sharing class ASI_CRM_JP_CheckPrimarySupplier extends ASI_CRM_JP_TriggerAbstract {

    public ASI_CRM_JP_CheckPrimarySupplier() {
        super('ASI_CRM_JP_CheckPrimarySupplier');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        List<ASI_CRM_Regular_Supplier__c> supList = (List<ASI_CRM_Regular_Supplier__c>)sObjList;
        Set<Id> cusIdSet = new Set<Id>();
        Set<Id> supIdSet = new Set<Id>();
        
        if (oldMap == null) {
            for (ASI_CRM_Regular_Supplier__c sup: supList) {
                if(sup.ASI_CRM_Primary__c == true){
                    cusIdSet.add(sup.ASI_CRM_Customer__c);
                    supIdSet.add(sup.Id);
                }
            }
        }
        else {
            Map<ID, ASI_CRM_Regular_Supplier__c> oldSupMap = (Map<ID, ASI_CRM_Regular_Supplier__c>) oldMap;
            for (ASI_CRM_Regular_Supplier__c sup: supList) {
                if(sup.ASI_CRM_Primary__c == true && oldSupMap.get(sup.Id).ASI_CRM_Primary__c == false){
                    cusIdSet.add(sup.ASI_CRM_Customer__c);
                    supIdSet.add(sup.Id);
                }
            }
        }
        
        List<ASI_CRM_Regular_Supplier__c> supUpdateList = [Select ASI_CRM_Primary__c From ASI_CRM_Regular_Supplier__c Where ASI_CRM_Customer__c In :cusIdSet And ASI_CRM_Primary__c = true And Id Not In :supIdSet];
        if(supUpdateList.size() > 0){
            for(ASI_CRM_Regular_Supplier__c s:supUpdateList){
                s.ASI_CRM_Primary__c = false;
            }   
            update supUpdateList;
        }
    }
    
}