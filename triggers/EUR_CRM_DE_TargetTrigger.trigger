/*
  @Company:     IP-Converge Data Services, Inc.
  @Description: Aggregate Actual Volume (Bottles)
  @Author:      IPC
  @History:     JUN.27.2014 - Created
*/
trigger EUR_CRM_DE_TargetTrigger on EUR_CRM_ObjPromo_Target__c (before insert, after insert, before update, after update, before delete, after delete) {
    //Insert Action
    if(Trigger.isBefore && Trigger.isInsert){}
    if(Trigger.isAfter && Trigger.isInsert){
        EUR_CRM_DE_TargetHandler.aggregateActualVolume_AIAU(Trigger.new);
    }
    
    //Update Action
    if(Trigger.isBefore && Trigger.isUpdate){}
    if(Trigger.isAfter && Trigger.isUpdate){
        EUR_CRM_DE_TargetHandler.aggregateActualVolume_AIAU(Trigger.new);
    }
    
    //Delete Action
    if(Trigger.isBefore && Trigger.isDelete){}
    if(Trigger.isAfter && Trigger.isDelete){}
}