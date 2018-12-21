trigger MMPJ_TOPG_MoMLineItem_BeforeDelete on MMPJ_TOPG_MoMLineItem__c (before delete) {
     //if a MOM line item is delete if a Task is linked to that item it should be deleted
    MMPJ_TOPG_AP02_MoMLineItem.deleteTask(trigger.oldMap.keySet());
}