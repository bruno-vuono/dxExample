trigger EUR_CRM_CriteriaThresholdTrigger on EUR_CRM_Criteria_Threshold__c (after insert, after update) 
/**
    * EUR_CRM_ProsSegmentationClass.processCriteriaSheetModification - finds all PROS Segmentation record using criteria set and updates EUR_CRM_Pros_Segmentation__c.EUR_CRM_Is_Image_Level_Modified__c and EUR_CRM_Pros_Segmentation__c.EUR_CRM_Is_Volume_Potential_Modified__c. 
    * 09/26
    * 1)For Germany (DE) and SFA Lite (E1)
    *       a) Warning Message show on PROS section on account page layout when met the following condition:
    *           - Add new criteria threshold
    *           - Edit the criteria threshold statement
    *           - Edit the selected picklist value of a criteria threshold
    *           - Remove selected picklist value of a criteria threshold
    *           - Update of criteria threshold type (the record type)
    *Edit: 12/18 - Apply new warning message change criteria (identified above, change 09/26) for all affiliates
    **/
{   
    Set<Id> criteriaSet = new Set<Id>();
    //Set<String> limitedUpdateAffiliateSet = new Set<String> {'DE', 'E1'};

    if (Trigger.isInsert){
        for (EUR_CRM_Criteria_Threshold__c cThreshold : Trigger.New)
        {
            criteriaSet.add(cThreshold.EUR_CRM_Criteria_Set__c);
        }
    }
    
    if(Trigger.isUpdate){
        for (EUR_CRM_Criteria_Threshold__c cThreshold : [Select Id, EUR_CRM_Question__c,
                                                        EUR_CRM_Criteria_Set__c, EUR_CRM_Criteria_Set__r.EUR_CRM_Country_Code__c 
                                                        FROM EUR_CRM_Criteria_Threshold__c
                                                        WHERE Id IN: Trigger.New])
        {
            if ((cThreshold.EUR_CRM_Question__c != Trigger.oldMap.get(cThreshold.Id).EUR_CRM_Question__c)){
                criteriaSet.add(cThreshold.EUR_CRM_Criteria_Set__c);
            }
        }
    }
    
    /*if (Trigger.isDelete){
        for (EUR_CRM_Criteria_Threshold__c cThreshold : [Select Id, EUR_CRM_Question__c,
                                                        EUR_CRM_Criteria_Set__c, EUR_CRM_Criteria_Set__r.EUR_CRM_Country_Code__c 
                                                        FROM EUR_CRM_Criteria_Threshold__c
                                                        WHERE Id IN: Trigger.Old])
        {
            if (! limitedUpdateAffiliateSet.contains(cThreshold.EUR_CRM_Criteria_Set__r.EUR_CRM_Country_Code__c))
                criteriaSet.add(cThreshold.EUR_CRM_Criteria_Set__c);
        }
    }*/
    
    
    //Process selected criteria set
    EUR_CRM_ProsSegmentationClass.processCriteriaSheetModification(criteriaSet);
    
}