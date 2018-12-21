trigger EUR_CRM_DE_Account_BeforeUpdate on EUR_CRM_Account__c (before update) {
	//new EUR_CRM_DE_TerritoryAccountHandler(), Removed on DEP2W2
    /*List<EUR_CRM_TriggerAbstract> triggerClasses = new List<EUR_CRM_TriggerAbstract> { 
      new EUR_CRM_DE_ListingTemplateHandler() 
    };
    
    for (EUR_CRM_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }*/
}