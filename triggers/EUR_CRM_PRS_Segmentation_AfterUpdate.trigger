/*
    Universal Trigger for EUR_CRM_PRS_Segmentation__c
    Populates the PRS values on the EU Account according to its corresponding PRS Segmentation
    Used when the mobile app populates the PRS segmentation record 
    Update 2017-Feb-20 : Move to a generic function to handle After Update, After Insert
*/

Trigger EUR_CRM_PRS_Segmentation_AfterUpdate on EUR_CRM_PRS_Segmentation__c (after update) {
    
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_PRSSegmentationToAccHandler()
    };

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }

    /*EUR_CRM_Account__c euAccount;
    Set<Id> euAccountsIdSet = new Set<Id>();
    List<EUR_CRM_Account__c> euAccountsToUpdate = new List<EUR_CRM_Account__c>();

    for(EUR_CRM_PRS_Segmentation__c prsSeg : Trigger.new){
        if(prsSeg.EUR_CRM_Account__c != null){
            euAccountsIdSet.add(prsSeg.EUR_CRM_Account__c);
        }
    }

    Map<Id, EUR_CRM_Account__c> euAccountaMap = new Map<Id, EUR_CRM_Account__c>([SELECT Id, EUR_CRM_PRS_Group_Outlet_Type__c, EUR_CRM_PRS_Outlet_Type__c,
                                                                                        EUR_CRM_Business_Potential__c, EUR_CRM_PRS_Priority_Level_Criteria__c,
                                                                                        EUR_CRM_Brand_Building_Potential__c, EUR_CRM_PRS_Volume_Potential__c,
                                                                                        EUR_CRM_PRS_Image_Level__c
                                                                                 FROM EUR_CRM_Account__c
                                                                                 WHERE Id IN : euAccountsIdSet]);

    for(EUR_CRM_PRS_Segmentation__c prsSeg : Trigger.new) {

        euAccount = euAccountaMap.get(prsSeg.EUR_CRM_Account__c);

        euAccount.EUR_CRM_Business_Potential__c = prsSeg.EUR_CRM_Business_Potential__c; 
        euAccount.EUR_CRM_Brand_Building_Potential__c = prsSeg.EUR_CRM_Brand_Building_Potential__c;
        euAccount.EUR_CRM_PRS_Priority_Level_Criteria__c = prsSeg.EUR_CRM_PRS_Priority_Level_Criteria__c;
        euAccount.EUR_CRM_PRS_Group_Outlet_Type__c = prsSeg.EUR_CRM_PRS_Group_Outlet_Type__c;
        euAccount.EUR_CRM_PRS_Outlet_Type__c = prsSeg.EUR_CRM_PRS_Outlet_Type__c;
        euAccount.EUR_CRM_PRS_Volume_Potential__c = prsSeg.EUR_CRM_Volume_Potential__c;
        euAccount.EUR_CRM_PRS_Image_Level__c = prsSeg.EUR_CRM_Image_Level__c;

        euAccountsToUpdate.add(euAccount);
    }

    if(euAccountsToUpdate.size() > 0){
        EUR_CRM_CommonRoutine.dmlWithPartialSuccess('update', euAccountsToUpdate);
    }*/


}