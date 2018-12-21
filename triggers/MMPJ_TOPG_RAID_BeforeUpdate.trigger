trigger MMPJ_TOPG_RAID_BeforeUpdate  on MMPJ_TOPG_RAID__c (before update) {
MMPJ_TOPG_AP01_RAID.updateRaidsMarketAndBrand(trigger.new);
}