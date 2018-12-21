trigger EUR_CRM_NG_Account_AfterUpdate on EUR_CRM_Account__c (after update) {
    /*List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
      //new EUR_CRM_NG_ShareEUAccountHandler()
    };
    
    Set<String> RecordTypes = New Set<String>();
    for(EUR_CRM_Account__c acc : trigger.new)
    {
        String objectRecordtypeDevName = Global_RecordTypeCache.getRt((string)acc.get('RecordTypeID')).DeveloperName;
        RecordTypes.add(objectRecordtypeDevName);
    }

    If(RecordTypeValidation(EUR_CRM_NG_ShareEUAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_NG_ShareEUAccountHandler');
        triggerClasses.add(new EUR_CRM_NG_ShareEUAccountHandler());
    }


    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
    
    public static Boolean RecordTypeValidation(Set<String> targetRecordTypeName, Set<String> recordTypeName){
        
        Integer OrgSize = targetRecordTypeName.Size();

        targetRecordTypeName.removeAll(recordTypeName);


        If(OrgSize != targetRecordTypeName.Size()){
            System.Debug('True');
            return True;
        }
        System.Debug('False');
        return False;
    }*/
}