public class MMPJ_TOPG_AP01_Task {    
    //When a task is updated the corresponding lineIem should be updated
    public static void updateMOMLineItem(Map<Id,Task> mapLineItemAndTaskToUpdateLineItem){
         List<MMPJ_TOPG_MoMLineItem__c> listLineItemToUpdate = new List<MMPJ_TOPG_MoMLineItem__c >();
         List<MMPJ_TOPG_MoMLineItem__c> listRelatedLineItem = new List<MMPJ_TOPG_MoMLineItem__c>();
         listRelatedLineItem =  [Select MMPJ_TOPG_When__c , MMPJ_TOPG_IsHighlight__c  , MMPJ_TOPG_Rank__c , MMPJ_TOPG_RelatedProject__c , MMPJ_TOPG_WhoC__c , MMPJ_TOPG_RAID__c , MMPJ_TOPG_WhoU__c 
                                  From  MMPJ_TOPG_MoMLineItem__c 
                                  Where id IN: mapLineItemAndTaskToUpdateLineItem.KeySet()];
         for(MMPJ_TOPG_MoMLineItem__c  lineItem : listRelatedLineItem ){
             Task task = mapLineItemAndTaskToUpdateLineItem.get(lineItem.id);
             if (task!= null){
                 lineItem.MMPJ_TOPG_WhoU__c = task.OwnerId ;
                 lineItem.MMPJ_TOPG_WhoC__c = task.WhoId ;
                 lineItem.MMPJ_TOPG_Topic__c = task.Description ;
                 lineItem.MMPJ_TOPG_When__c = task.ActivityDate ;
                 lineItem.id = task.WhatId;
                 lineItem.MMPJ_TOPG_Title__c = task.Subject;
    
                 listLineItemToUpdate.add(lineItem);
             }
        }
        
        if(listLineItemToUpdate.size() > 0){
            update(listLineItemToUpdate);
        }
    }
    //When a task is updated the corresponding RAID should be updated
    public static void updateRAID(Map<Id,Task> mapLineItemAndTaskToUpdateLineItem){
         List<MMPJ_TOPG_RAID__c> listRaidToUpdate = new List<MMPJ_TOPG_RAID__c >();
         List<MMPJ_TOPG_RAID__c> listRelatedRaid = new List<MMPJ_TOPG_RAID__c>();
         listRelatedRaid =  [Select MMPJ_TOPG_User__c,MMPJ_TOPG_Contact__c, MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_Status__c, MMPJ_TOPG_Title__c  
                                  From  MMPJ_TOPG_RAID__c 
                                  Where id IN: mapLineItemAndTaskToUpdateLineItem.KeySet()];
         for(MMPJ_TOPG_RAID__c  raid : listRelatedRaid ){
             Task task = mapLineItemAndTaskToUpdateLineItem.get(raid.id);
             if (task!= null){
             	raid.MMPJ_TOPG_User__c = task.OwnerId ;
                raid.MMPJ_TOPG_Contact__c = task.WhoId ;
                raid.MMPJ_TOPG_Description__c = task.Description ;
                raid.MMPJ_TOPG_ExpectedDate__c  = task.ActivityDate ;
                raid.MMPJ_TOPG_Status__c = task.Status;
       			raid.MMPJ_TOPG_Title__c = task.Subject;
    
                listRaidToUpdate.add(raid);
             }
        }
        
        if(listRaidToUpdate.size() > 0){
            update(listRaidToUpdate);
        }
    }
}