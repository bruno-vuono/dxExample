trigger MMPJ_TOPG_ProjectAfterUpdate on MMPJ_TOPG_Project__c (after update) {
//MMPJ_TOPG_AP01_RAID.updateProjMarketAndBrand(trigger.new); 
for( Id projectId : Trigger.newMap.keySet() )
    {
         if( (Trigger.oldMap.get(projectId).MMPJ_TOPG_ProjectType__c != Trigger.newMap.get(projectId).MMPJ_TOPG_ProjectType__c) 
         ||   Trigger.oldMap.get(projectId).MMPJ_TOPG_ProjectTopic__c != Trigger.newMap.get(projectId).MMPJ_TOPG_ProjectTopic__c)
      {
         // do something here because your field has changed
         system.debug (' in update mode =====');
         MMPJ_TOPG_AP01_MileStones.createDefaultMileStones(trigger.new);
      }
    }
}