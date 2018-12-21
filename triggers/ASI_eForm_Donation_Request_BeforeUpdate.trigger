trigger ASI_eForm_Donation_Request_BeforeUpdate on ASI_eForm_Donation_Request__c (before update) {
    if(Global_RecordTypeCache.getRt(trigger.new[0].recordtypeid).DeveloperName.contains('ASI_eForm_KR')) {
        //ASI_eForm_KR_DonationRequestTriggerClass.routineBeforeUpsert(trigger.new, Null); 
    }
}