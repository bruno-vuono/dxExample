trigger ASI_eForm_User_ID_Request_BeforeDelete on ASI_eForm_User_ID_Request__c (before delete) {
 ASI_eForm_GenericTriggerClass.validateHeaderStatus(Trigger.oldMap.values(),'ASI_eForm_Status__c', new Set<String>{'Complete','Final'});
}