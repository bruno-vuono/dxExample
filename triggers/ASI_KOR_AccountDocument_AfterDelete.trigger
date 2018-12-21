trigger ASI_KOR_AccountDocument_AfterDelete on ASI_KOR_Account_Document__c (after delete) {
	
	List<ASI_KOR_TriggerAbstract> triggerClasses = new List<ASI_KOR_TriggerAbstract> {
		new ASI_KOR_AttachDocDeleteChatterFile()
	};
	
	for (ASI_KOR_TriggerAbstract triggerClass : triggerClasses) {
		triggerClass.executeTriggerAction(ASI_KOR_TriggerAbstract.TriggerAction.AFTER_DELETE, trigger.old, null, trigger.oldMap);
	}
}