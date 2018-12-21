/*
* Edit 10/20/14:
* Added territory assignment handler for Baltics
*/
trigger EUR_CRM_Account_BeforeUpdate on EUR_CRM_Account__c (before update) {

    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
        
        //new EUR_CRM_TerritoryAssignmentHandler(),
        //new EUR_CRM_ForceIconicAccountHandler(),
        //new EUR_CRM_ForceImageLevelHandler(),
        //new EUR_CRM_ForcePRSegDimensionsHandler(),
        //new EUR_CRM_AccountVisitFrequencyHandler(),

        //new EUR_CRM_Baltics_TerritoryAssignmentClass(),
        new EUR_CRM_TemplateAssignmentHandler(), 
        //new EUR_CRM_ListingTemplateAssignmentHandler(), // FEB.20.2015 : added for AO_KE Implenetation.
        
        // REFACTORING: Assign Account Owner
        //new EUR_CRM_AssignAccountOwnerHandler(),
        //new EUR_CRM_ListingTemplateHandler(),
        new EUR_CRM_AccountOwnerManagerHandler()
       
        //new EUR_CRM_AccountPostalTerritoryHandler(), // SEPT.08.2014 : Added functionality for SFA Lite Implementation
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

    If(RecordTypeValidation(EUR_CRM_TerritoryAssignmentHandler.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_TerritoryAssignmentHandler');
        triggerClasses.add(new EUR_CRM_TerritoryAssignmentHandler());
    }
    
    If(RecordTypeValidation(EUR_CRM_Baltics_TerritoryAssignmentClass.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_Baltics_TerritoryAssignmentClass');
        triggerClasses.add(new EUR_CRM_Baltics_TerritoryAssignmentClass());
    }

    //System.Debug('EUR_CRM_PRS_AssignAspectFromCustomerTax:' + EUR_CRM_PRS_AssignAspectFromCustomerTax.RecordTypeValidation(RecordTypes));
    //This feature will change to PRS driving
    /*If(RecordTypeValidation(EUR_CRM_PRS_AssignAspectFromCustomerTax.TargetRecordSet,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_PRS_AssignAspectFromCustomerTax');
        triggerClasses.add(new EUR_CRM_PRS_AssignAspectFromCustomerTax());
    }*/

    If(RecordTypeValidation(EUR_CRM_ForceIconicAccountHandler.TargetRecordSet,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ForceIconicAccountHandler');
        triggerClasses.add(new EUR_CRM_ForceIconicAccountHandler());
    }

    If(RecordTypeValidation(EUR_CRM_ForceImageLevelHandler.TargetRecordSet,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ForceImageLevelHandler');
        triggerClasses.add(new EUR_CRM_ForceImageLevelHandler());
    }

    If(RecordTypeValidation(EUR_CRM_ForcePRSegDimensionsHandler.TargetRecordSet,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ForcePRSegDimensionsHandler');
        triggerClasses.add(new EUR_CRM_ForcePRSegDimensionsHandler());
    }

    If(RecordTypeValidation(EUR_CRM_AccountVisitFrequencyHandler.TargetRecordSet,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_AccountVisitFrequencyHandler');
        triggerClasses.add(new EUR_CRM_AccountVisitFrequencyHandler());
    }

    If(RecordTypeValidation(EUR_CRM_AssignAccountOwnerHandler.TargetRecordSet,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_AssignAccountOwnerHandler');
        triggerClasses.add(new EUR_CRM_AssignAccountOwnerHandler());
    }
    
    If(RecordTypeValidation(EUR_CRM_ListingTemplateAssignmentHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ListingTemplateAssignmentHandler');
        triggerClasses.add(new EUR_CRM_ListingTemplateAssignmentHandler());
    }

    If(RecordTypeValidation(EUR_CRM_ListingTemplateHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_ListingTemplateHandler');
        triggerClasses.add(new EUR_CRM_ListingTemplateHandler());
    }

    If(RecordTypeValidation(EUR_CRM_PRS_ListingTplAssignmentHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_PRS_ListingTplAssignmentHandler');
        triggerClasses.add(new EUR_CRM_PRS_ListingTplAssignmentHandler());
    }

    //*****************EUR_CRM_DE_Account_BeforeUpdate
    //EUR_CRM_DE_ListingTemplateHandler
    If(RecordTypeValidation(EUR_CRM_DE_ListingTemplateHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_DE_ListingTemplateHandler(BeforeUpdate)');
        triggerClasses.add(new EUR_CRM_DE_ListingTemplateHandler());
    }

    //*****************EUR_CRM_NG_Account_BeforeUpdate
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

    //*****************EUR_CRM_FI_Account_BeforeUpdate
    //EUR_CRM_FI_EUAccountHandler
    If(RecordTypeValidation(EUR_CRM_FI_EUAccountHandler.TargetRecordSet ,RecordTypes)){
        System.Debug('Trigger:EUR_CRM_FI_EUAccountHandler');
        triggerClasses.add(new EUR_CRM_FI_EUAccountHandler());
    }
    
    //*****************

    //*****************EUR_CRM_RU_Account_BeforeUpdate
   
    /*If(RecordTypeValidation(EUR_CRM_RU_ManageAccountSharing.TargetRecordSet, RecordTypes)){
        System.Debug('Trigger:EUR_CRM_RU_ManageAccountSharing');
        triggerClasses.add(new EUR_CRM_RU_ManageAccountSharing());
    }*/
    //*****************

    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
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