trigger MMPJ_TOPG_ProjectAfterInsert on MMPJ_TOPG_Project__c (after insert) {
MMPJ_TOPG_AP01_RAID.updateProjMarketAndBrand(trigger.new);
//create default Milestones for each project
MMPJ_TOPG_AP01_MileStones.createDefaultMileStones(trigger.new);
}