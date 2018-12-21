trigger MMPJ_TOPG_RAID_BeforeInsert on MMPJ_TOPG_RAID__c (before insert) {
MMPJ_TOPG_AP01_RAID.updateRaidsMarketAndBrand(trigger.new);
}