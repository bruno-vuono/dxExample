trigger EUR_CRM_Account_AfterInsert on EUR_CRM_Account__c (after insert) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_EUAccountLinkHandler(),
        //new EUR_CRM_NG_ShareEUAccountHandler(),
        new EUR_CRM_EUAccountCreatePRSegHandler()
    };


    Set<String> RecordTypes = New Set<String>();
    for(EUR_CRM_Account__c acc : trigger.new)
    {
        String objectRecordtypeDevName = Global_RecordTypeCache.getRt((string)acc.get('RecordTypeID')).DeveloperName;
        RecordTypes.add(objectRecordtypeDevName);
    }

    If(RecordTypeValidation(EUR_CRM_NG_ShareEUAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_NG_ShareEUAccountHandler');
        triggerClasses.add(new EUR_CRM_NG_ShareEUAccountHandler());
    }

    //************EUR_CRM_DE_Account_AfterInsert
    //EUR_CRM_DE_AccountHandler
    //EUR_CRM_DE_PrestigeAccountHandler
    //EUR_CRM_DE_SalesAgencyAccountHandler

    If(RecordTypeValidation(EUR_CRM_DE_AccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_DE_AccountHandler');
        triggerClasses.add(new EUR_CRM_DE_AccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_DE_PrestigeAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_DE_PrestigeAccountHandler');
        triggerClasses.add(new EUR_CRM_DE_PrestigeAccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_DE_SalesAgencyAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_DE_SalesAgencyAccountHandler');
        triggerClasses.add(new EUR_CRM_DE_SalesAgencyAccountHandler());
    }

    //************EUR_CRM_FI_Account_AfterInsert
    //EUR_CRM_FI_ContractAccountHandler
    //EUR_CRM_FI_OPAccountHandler
    If(RecordTypeValidation(EUR_CRM_FI_ContractAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_FI_ContractAccountHandler');
        triggerClasses.add(new EUR_CRM_FI_ContractAccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_FI_OPAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_FI_OPAccountHandler');
        triggerClasses.add(new EUR_CRM_FI_OPAccountHandler());
    }

    //************EUR_CRM_ZA_Account_AfterInsert
    //EUR_CRM_ZA_CreateVolumeTrackerHandler
    If(RecordTypeValidation(EUR_CRM_ZA_CreateVolumeTrackerHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Tigger:EUR_CRM_ZA_CreateVolumeTrackerHandler');
        triggerClasses.add(new EUR_CRM_ZA_CreateVolumeTrackerHandler());
    }


    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, null);
        System.debug('Resources:'+ String.valueOf(triggerClass).split(':')[0] +'Queries:[' + Limits.getQueries() + ']|' + 'Rows:[' + Limits.getDmlRows() + '|Statements:[' + Limits.getDmlStatements() + ']' );
    }
    
    if (trigger.isInsert){
        EUR_CRM_EU_AccountCreateProsSegHandler handler = new EUR_CRM_EU_AccountCreateProsSegHandler();
        handler.createProsSegRecord(trigger.new);
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
    }
}