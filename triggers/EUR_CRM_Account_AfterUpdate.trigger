trigger EUR_CRM_Account_AfterUpdate on EUR_CRM_Account__c (after update) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        new EUR_CRM_EUAccountLinkHandler(),
        new EUR_CRM_EventCleanUpHandler()
        //new EUR_CRM_OutletToSupplierHandler()
    };
    //Record Type Filtering
    Set<String> RecordTypes = New Set<String>();
    for(EUR_CRM_Account__c acc : trigger.new)
    {
        String objectRecordtypeDevName = Global_RecordTypeCache.getRt((string)acc.get('RecordTypeID')).DeveloperName;
        RecordTypes.add(objectRecordtypeDevName);
    }

    If(RecordTypeValidation(EUR_CRM_OutletToSupplierHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_OutletToSupplierHandler');
        triggerClasses.add(new EUR_CRM_OutletToSupplierHandler());
    }

    //************EUR_CRM_DE_Account_AfterUpdate
    //EUR_CRM_DE_AccountHandler
    //EUR_CRM_DE_PrestigeAccountHandler
    //EUR_CRM_DE_SalesAgencyAccountHandler
    //EUR_CRM_DE_ContactAccountHandler
    If(RecordTypeValidation(EUR_CRM_DE_AccountHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_DE_AccountHandler');
        triggerClasses.add(new EUR_CRM_DE_AccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_DE_PrestigeAccountHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_DE_PrestigeAccountHandler');
        triggerClasses.add(new EUR_CRM_DE_PrestigeAccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_DE_SalesAgencyAccountHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_DE_SalesAgencyAccountHandler');
        triggerClasses.add(new EUR_CRM_DE_SalesAgencyAccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_DE_ContactAccountHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_DE_ContactAccountHandler');
        triggerClasses.add(new EUR_CRM_DE_ContactAccountHandler());
    }
    
    //************EUR_CRM_FI_Account_AfterUpdate
    //EUR_CRM_FI_OPAccountHandler
    //EUR_CRM_FI_ContractAccountHandler
    If(RecordTypeValidation(EUR_CRM_FI_OPAccountHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_FI_OPAccountHandler');
        triggerClasses.add(new EUR_CRM_FI_OPAccountHandler());
    }
    If(RecordTypeValidation(EUR_CRM_FI_ContractAccountHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_FI_ContractAccountHandler');
        triggerClasses.add(new EUR_CRM_FI_ContractAccountHandler());
    }

    //************EUR_CRM_NG_Account_AfterUpdate
    //EUR_CRM_NG_ShareEUAccountHandler
    If(RecordTypeValidation(EUR_CRM_NG_ShareEUAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_NG_ShareEUAccountHandler');
        triggerClasses.add(new EUR_CRM_NG_ShareEUAccountHandler());
    }

    //************EUR_CRM_DE_Account_AfterUpdate
    //EUR_CRM_ZA_OPAccountFlowHandler
    //EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr
    //EUR_CRM_ZA_UpdateMngrsOnContractHandler
    If(RecordTypeValidation(EUR_CRM_ZA_OPAccountFlowHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ZA_OPAccountFlowHandler');
        triggerClasses.add(new EUR_CRM_ZA_OPAccountFlowHandler());
    }
    If(RecordTypeValidation(EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr');
        triggerClasses.add(new EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr());
    }
    If(RecordTypeValidation(EUR_CRM_ZA_UpdateMngrsOnContractHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ZA_UpdateMngrsOnContractHandler');
        triggerClasses.add(new EUR_CRM_ZA_UpdateMngrsOnContractHandler());
    }


    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.AFTER_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
        System.debug('Resources:'+ String.valueOf(triggerClass).split(':')[0] +'Queries:[' + Limits.getQueries() + ']|' + 'Rows:[' + Limits.getDmlRows() + '|Statements:[' + Limits.getDmlStatements() + ']' );
    }
    
    if (trigger.isUpdate){
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