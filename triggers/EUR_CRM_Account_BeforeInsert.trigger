/*
* Edit 10/20/14:
* Added territory assignment handler for Baltics
*/
trigger EUR_CRM_Account_BeforeInsert on EUR_CRM_Account__c (before insert) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        // DE Record Assign City By Postal Code
        new EUR_CRM_Account_City_PostalCode_Handler(),

        // Assign auto number to name
        new EUR_CRM_AccountAssignAutoNumber(),
        // Territory Management
        //new EUR_CRM_TerritoryAssignmentHandler(), 
        //new EUR_CRM_Baltics_TerritoryAssignmentClass(), 
        // Assign Customer taxonomy
        //new EUR_CRM_AssignAccountCustomerTaxonomy(),
        new EUR_CRM_TemplateAssignmentHandler(), 
        // Assign visit Frequency
        //new EUR_CRM_AccountVisitFrequencyHandler(),
        //new EUR_CRM_AO_KE_AccountTerritoryHandler(), // FEB.20.2015 : added for AO_KE Implenetation.
        ///*new EUR_CRM_ListingTemplateAssignmentHandler(), // FEB.20.2015 : added for AO_KE Implenetation. REPLACED BY EUR_CRM_ListingTemplateHandler*/

        // REFACTORING: Assign Account Owner
        //new EUR_CRM_AssignAccountOwnerHandler(),
        //new EUR_CRM_ListingTemplateHandler(),
        new EUR_CRM_AccountOwnerManagerHandler()
    };
    
    //Record Type Filtering
    Set<String> RecordTypes = New Set<String>();
    for(EUR_CRM_Account__c acc : trigger.new)
    {
        String objectRecordtypeDevName = Global_RecordTypeCache.getRt((string)acc.get('RecordTypeID')).DeveloperName;
        RecordTypes.add(objectRecordtypeDevName);
    }

    //If(RecordTypeValidation(EUR_CRM_DE_TerritoryAccountHandler.TargetRecordSet ,RecordTypes)){
    //    System.Debug('Trigger:EUR_CRM_DE_TerritoryAccountHandler');
        triggerClasses.add(new EUR_CRM_DE_TerritoryAccountHandler());
    //}

    If(RecordTypeValidation(EUR_CRM_Account_City_PostalCode_Handler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_Account_City_PostalCode_Handler');
        triggerClasses.add(new EUR_CRM_Account_City_PostalCode_Handler());
    }

    If(RecordTypeValidation(EUR_CRM_TerritoryAssignmentHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_TerritoryAssignmentHandler');
        triggerClasses.add(new EUR_CRM_TerritoryAssignmentHandler());
    }

    If(RecordTypeValidation(EUR_CRM_Baltics_TerritoryAssignmentClass.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_Baltics_TerritoryAssignmentClass');
        triggerClasses.add(new EUR_CRM_Baltics_TerritoryAssignmentClass());
    }

    If(RecordTypeValidation(EUR_CRM_AssignAccountCustomerTaxonomy.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_AssignAccountCustomerTaxonomy');
        triggerClasses.add(new EUR_CRM_AssignAccountCustomerTaxonomy());
    }

    If(RecordTypeValidation(EUR_CRM_AccountVisitFrequencyHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_AccountVisitFrequencyHandler');
        triggerClasses.add(new EUR_CRM_AccountVisitFrequencyHandler());
    }

    If(RecordTypeValidation(EUR_CRM_AO_KE_AccountTerritoryHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_AO_KE_AccountTerritoryHandler');
        triggerClasses.add(new EUR_CRM_AO_KE_AccountTerritoryHandler());
    }

    If(RecordTypeValidation(EUR_CRM_ListingTemplateAssignmentHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ListingTemplateAssignmentHandler');
        triggerClasses.add(new EUR_CRM_ListingTemplateAssignmentHandler());
    }

    If(RecordTypeValidation(EUR_CRM_PRS_ListingTplAssignmentHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_PRS_ListingTplAssignmentHandler');
        triggerClasses.add(new EUR_CRM_PRS_ListingTplAssignmentHandler());
    }

    If(RecordTypeValidation(EUR_CRM_ListingTemplateHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ListingTemplateHandler');
        triggerClasses.add(new EUR_CRM_ListingTemplateHandler());
    }

    If(RecordTypeValidation(EUR_CRM_AssignAccountOwnerHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_AssignAccountOwnerHandler');
        triggerClasses.add(new EUR_CRM_AssignAccountOwnerHandler());
    }
    

    //This feature will change to PRS driving
    /*If(RecordTypeValidation(EUR_CRM_PRS_AssignAspectFromCustomerTax.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_PRS_AssignAspectFromCustomerTax');
        triggerClasses.add(new EUR_CRM_PRS_AssignAspectFromCustomerTax());
    }*/

    //************EUR_CRM_FI_Account_BeforeInsert
    //EUR_CRM_FI_EUAccountHandler
    If(RecordTypeValidation(EUR_CRM_FI_EUAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_FI_EUAccountHandler');
        triggerClasses.add(new EUR_CRM_FI_EUAccountHandler());
    }

    //************EUR_CRM_NG_Account_BeforeInsert
    //EUR_CRM_NG_AssignVisitFrequencyHandler
    //EUR_CRM_NG_AssignAccountOwnerHandler
    If(RecordTypeValidation(EUR_CRM_NG_AssignVisitFrequencyHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_NG_AssignVisitFrequencyHandler');
        triggerClasses.add(new EUR_CRM_NG_AssignVisitFrequencyHandler());
    }
    If(RecordTypeValidation(EUR_CRM_NG_AssignAccountOwnerHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_NG_AssignAccountOwnerHandler');
        triggerClasses.add(new EUR_CRM_NG_AssignAccountOwnerHandler());
    }

    //************EUR_CRM_DE_Account_BeforeInsert
    //EUR_CRM_DE_ListingTemplateHandler
    If(RecordTypeValidation(EUR_CRM_DE_ListingTemplateHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_DE_ListingTemplateHandler(BeforeInsert)');
        triggerClasses.add(new EUR_CRM_DE_ListingTemplateHandler());
    }

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, null);
        System.debug('Resources:'+ String.valueOf(triggerClass).split(':')[0] +'Queries:[' + Limits.getQueries() + ']|' + 'Rows:[' + Limits.getDmlRows() + '|Statements:[' + Limits.getDmlStatements() + ']' );
    }

    public static Boolean RecordTypeValidation(Set<String> targetRecordTypeName, Set<String> recordTypeName){

        Integer OrgSize = targetRecordTypeName.Size();

        targetRecordTypeName.removeAll(recordTypeName);


        If(OrgSize != targetRecordTypeName.Size()){

            return True;
        }

        return False;
    }
}