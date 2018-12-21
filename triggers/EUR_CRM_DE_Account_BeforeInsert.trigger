trigger EUR_CRM_DE_Account_BeforeInsert on EUR_CRM_Account__c (before insert) {
    /*
	//new EUR_CRM_DE_TerritoryAccountHandler(),  
	//Removed By Jay 2016-12-29, DEP2W2
    List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> {
      
      //new EUR_CRM_DE_ListingTemplateHandler() 
    };
    
    //Record Type Filtering
    Set<String> RecordTypes = New Set<String>();
    for(EUR_CRM_Account__c acc : trigger.new)
    {
        String objectRecordtypeDevName = Global_RecordTypeCache.getRt((string)acc.get('RecordTypeID')).DeveloperName;
        RecordTypes.add(objectRecordtypeDevName);
    }

    If(RecordTypeValidation(EUR_CRM_DE_ListingTemplateHandler.TargetRecordSet, RecordTypes)){
    	System.Debug('Trigger:EUR_CRM_DE_ListingTemplateHandler');
        triggerClasses.add(new EUR_CRM_DE_ListingTemplateHandler());
    }


    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT, trigger.new, trigger.newMap, null);
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