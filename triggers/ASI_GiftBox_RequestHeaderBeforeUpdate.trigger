trigger ASI_GiftBox_RequestHeaderBeforeUpdate on ASI_GiftBox_Request_Header__c (before update) {
    ASI_GiftBox_RequestHeaderTriggerClass.routineBeforeUpdate(trigger.new);
}