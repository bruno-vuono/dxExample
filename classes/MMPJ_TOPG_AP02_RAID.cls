public class MMPJ_TOPG_AP02_RAID {    
    //When a RAID is updated the corresponding lineIem should be updated
    public static void updateMOMLineItem(Map<Id,MMPJ_TOPG_RAID__c> mapLineItemAndRAIDToUpdateLineItem){
         List<MMPJ_TOPG_MoMLineItem__c> listLineItemToUpdate = new List<MMPJ_TOPG_MoMLineItem__c >();
         Set<ID> setRaidIDToDelete = new Set<ID>();
         List<MMPJ_TOPG_MoMLineItem__c> listRelatedLineItem = new List<MMPJ_TOPG_MoMLineItem__c>();
         listRelatedLineItem =  [Select MMPJ_TOPG_When__c , MMPJ_TOPG_IsHighlight__c  , MMPJ_TOPG_Rank__c , MMPJ_TOPG_RelatedProject__c , MMPJ_TOPG_WhoC__c , MMPJ_TOPG_RAID__c , MMPJ_TOPG_WhoU__c 
                                  From  MMPJ_TOPG_MoMLineItem__c 
                                  Where id IN: mapLineItemAndRAIDToUpdateLineItem.KeySet()];
         for(MMPJ_TOPG_MoMLineItem__c  lineItem : listRelatedLineItem ){
             MMPJ_TOPG_RAID__c raid = mapLineItemAndRAIDToUpdateLineItem.get(lineItem.id);
             if (raid != null){      
                 lineItem.MMPJ_TOPG_When__c = raid.MMPJ_TOPG_ExpectedDate__c  ;
                 lineItem.MMPJ_TOPG_IsHighlight__c  = raid.MMPJ_TOPG_Highlight__c     ;
                 lineItem.MMPJ_TOPG_Rank__c = raid.MMPJ_TOPG_Rank__c  ;
                 lineItem.MMPJ_TOPG_RAID__c = raid.MMPJ_TOPG_raid__c  ;                
                 lineItem.MMPJ_TOPG_WhoC__c = raid.MMPJ_TOPG_Contact__c   ;
                 lineItem.MMPJ_TOPG_WhoU__c = raid.MMPJ_TOPG_User__c  ;
                 listLineItemToUpdate.add(lineItem);
             }
             System.debug('??raid: ' + raid);
             //if the raid field of RAID = None and it is related to a project then this raid should be removed
             if (String.ISBLANK(raid.MMPJ_TOPG_raid__c )){   
                 setRaidIDToDelete.add(raid.id);
             }
        }
        
        if(listLineItemToUpdate.size() > 0){
            update(listLineItemToUpdate);
        }
        
        List<MMPJ_TOPG_RAID__c> listRaidToDelete = new List<MMPJ_TOPG_RAID__c>();
        listRaidToDelete = [Select id 
                            From MMPJ_TOPG_RAID__c 
                            Where ID IN:setRaidIDToDelete ];
        if(listRaidToDelete.size() > 0){
            delete(listRaidToDelete);
        } 
    }
}