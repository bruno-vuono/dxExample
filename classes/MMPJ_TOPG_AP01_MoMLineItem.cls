public class MMPJ_TOPG_AP01_MoMLineItem {
//static variable to prevent the infinite update calls between RAID update and MOM line item update 
    //when a MOM line item is updated the RAID is updated and when a RAID is updated MOM line item is updated
    public static boolean isFirstTime = true;
    
    //When a MOM line item is added to a project it should be added to the todo section of of its project
    public static void createProjectRAID(List <MMPJ_TOPG_MoMLineItem__c> listMoMLineItem){  
        List<MMPJ_TOPG_RAID__c> listRaidToInsert = new  List<MMPJ_TOPG_RAID__c>();  
        for(MMPJ_TOPG_MoMLineItem__c lineItem: listMoMLineItem){
            MMPJ_TOPG_RAID__c raid = new MMPJ_TOPG_RAID__c();
            setFieldsOfRaid(raid, lineItem);
            listRaidToInsert.add(raid);
        }
        if(listRaidToInsert.size() > 0){
            insert(listRaidToInsert);
        }
    }
   
    //When a MOM line item is delete the corresponding RAID should be also deleted
    public static void deleteRAID(Set<ID> MoMlineItemID){ 
        List<MMPJ_TOPG_RAID__c> listRelatedRaid = new  List<MMPJ_TOPG_RAID__c> ();
        //get the list of RAIDS releted to that line item
        listRelatedRaid = [Select id, MMPJ_TOPG_LineItem__c
                           From MMPJ_TOPG_RAID__c
                           Where MMPJ_TOPG_LineItem__c IN : MoMlineItemID];
        if(listRelatedRaid.size() > 0){
            delete(listRelatedRaid);
        }
    }
    
    //When a MOM line item is updated to a project it should be updated in the todo section of its project
    public static void updateProjectRAID(Map<Id,MMPJ_TOPG_MoMLineItem__c> newLineItem){ 
        List<MMPJ_TOPG_RAID__c> listRaidToUpdate = new  List<MMPJ_TOPG_RAID__c>();
        Set<ID> MoMlineItemID = newLineItem.keySet();
       
        List<MMPJ_TOPG_RAID__c> listRelatedRaid = new  List<MMPJ_TOPG_RAID__c> ();
        listRelatedRaid = [Select id,MMPJ_TOPG_ExpectedDate__c,MMPJ_TOPG_Highlight__c, MMPJ_TOPG_Rank__c,MMPJ_TOPG_Project__c, 
                           MMPJ_TOPG_LineItem__c, MMPJ_TOPG_raid__c, MMPJ_TOPG_Contact__c, MMPJ_TOPG_User__c 
                           From MMPJ_TOPG_RAID__c
                           Where MMPJ_TOPG_LineItem__c IN : MoMlineItemID];

        for(MMPJ_TOPG_RAID__c raid: listRelatedRaid){
            MMPJ_TOPG_MoMLineItem__c lineItem = newLineItem.get(raid.MMPJ_TOPG_LineItem__c);
            if(lineItem != null){
                setFieldsOfRaid(raid, lineItem);
                listRaidToUpdate.add(raid);
            }
        }
        
        if(listRaidToUpdate.size() > 0){
            update(listRaidToUpdate);
        }
    }
    
    //match the fields of Raid to the corresponding fields of the line item
    public static void setFieldsOfRaid(MMPJ_TOPG_RAID__c raid, MMPJ_TOPG_MoMLineItem__c lineItem){
        raid.MMPJ_TOPG_ExpectedDate__c = lineItem.MMPJ_TOPG_When__c;
        raid.MMPJ_TOPG_Highlight__c = lineItem.MMPJ_TOPG_IsHighlight__c;
        raid.MMPJ_TOPG_Rank__c = lineItem.MMPJ_TOPG_Rank__c;
        raid.MMPJ_TOPG_LineItem__c = lineItem.id;
        raid.MMPJ_TOPG_Project__c = lineItem.MMPJ_TOPG_RelatedProject__c;
        raid.MMPJ_TOPG_raid__c = lineItem.MMPJ_TOPG_RAID__c;
        raid.MMPJ_TOPG_Contact__c = lineItem.MMPJ_TOPG_WhoC__c;
        raid.MMPJ_TOPG_User__c = lineItem.MMPJ_TOPG_WhoU__c;  
    }
    
    
}