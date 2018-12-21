trigger PRH_Account_BeforeDelete on Account (before delete) {
    
    boolean isRT = false;
    
    List<AggregateResult> recordTypes = [Select PRH_Account_Record_Type__c From PRH_Iconic_Account_Trigger__c Group By PRH_Account_Record_Type__c];
    
    for (AggregateResult rt : recordTypes){
        System.debug('Trigger Test : ' + (string)rt.get('PRH_Account_Record_Type__c'));
        if(Global_RecordTypeCache.getRt(trigger.old[0].recordTypeid).developerName.contains((string)rt.get('PRH_Account_Record_Type__c'))){
            isRT = true;
        }
    }
    
    
    List<PRH_TriggerAbstract> triggerClasses = new List<PRH_TriggerAbstract> {
        new PRH_Account_To_Luxury_Account()
    };
    
    for (PRH_TriggerAbstract triggerClass : triggerClasses) {
        if(isRT)
            triggerClass.executeTriggerAction(PRH_TriggerAbstract.TriggerAction.BEFORE_DELETE, trigger.old, trigger.newMap, trigger.oldMap);
    }
    
}