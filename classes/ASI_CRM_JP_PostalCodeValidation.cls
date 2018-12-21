/*********************************************************************************
 * Name:ASI_CRM_JP_PostalCodeValidation
 * Description: Check if Postal Code is valid or not
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 9/2/2014         Laputa: Hank            Created
*********************************************************************************/

public with sharing class ASI_CRM_JP_PostalCodeValidation extends ASI_CRM_JP_TriggerAbstract {

    public ASI_CRM_JP_PostalCodeValidation() {
        super('ASI_CRM_JP_PostalCodeValidation');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        List<ASI_CRM_Postal_Code__c> postalList = (List<ASI_CRM_Postal_Code__c>)sObjList;
        Set<String> postalNameSet = new Set<String>();
        
        if (oldMap == null) {
            for (ASI_CRM_Postal_Code__c postal: postalList) {
                postalNameSet.add(postal.Name);
            }
        }else{
          Map<Id, ASI_CRM_Postal_Code__c> oldPostalMap = (Map<Id, ASI_CRM_Postal_Code__c>)oldMap;
          for(ASI_CRM_Postal_Code__c postal:postalList){
              if(postal.Name != oldPostalMap.get(postal.Id).Name){
                  postalNameSet.add(postal.Name);
              }
          }
       }
       
       List<ASI_CRM_Postal_Code__c> allPostalList = [Select Id, Name From ASI_CRM_Postal_Code__c Where Name In :postalNameSet And RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_CRM_Postal_Code__cASI_CRM_JP_Postal_Code')];
       
       if (oldMap == null) {
            for (ASI_CRM_Postal_Code__c postal: postalList) {
                for(ASI_CRM_Postal_Code__c existPostal: allPostalList){
                    if(postal.Name == existPostal.Name && postal.Id != existPostal.Id){
                        postal.AddError(System.Label.ASI_CRM_JP_Duplicated_PostalCode);    
                    }
                } 
                if(!Pattern.matches('(\\d{7})', postal.name)){
                        postal.AddError(System.Label.ASI_CRM_JP_PostalCodeFormat);  
                } 
            }
        }else{
          Map<Id, ASI_CRM_Postal_Code__c> oldPostalMap = (Map<Id, ASI_CRM_Postal_Code__c>)oldMap;
          for(ASI_CRM_Postal_Code__c postal:postalList){
              if(postal.Name != oldPostalMap.get(postal.Id).Name){
                 for(ASI_CRM_Postal_Code__c existPostal: allPostalList){
                    if(postal.Name == existPostal.Name && postal.Id != existPostal.Id){
                        postal.AddError(System.Label.ASI_CRM_JP_Duplicated_PostalCode);   
                    }
                 }
                 if(!Pattern.matches('(\\d{7})', postal.name)){
                     postal.AddError(System.Label.ASI_CRM_JP_PostalCodeFormat);
                 }
              }
          }
       }
    }
    
}