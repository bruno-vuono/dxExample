trigger MMPJ_Ext_Vign_Document_After_Insert on MMPJ_Ext_Vign_Documents_Fournis__c (after insert) {
	List<MMPJ_Ext_Vign_Documents_Fournis__c> documents = new List<MMPJ_Ext_Vign_Documents_Fournis__c>();
	for(MMPJ_Ext_Vign_Documents_Fournis__c doc:trigger.new)
		if(doc.MMPJ_Ext_Vign_Type__c == 'Brouillon de déclaration de récolte')
			documents.add(doc);
	if(documents.size()>0)
		MMPJ_Ext_Vign_Notifications.createDocumentNotification(documents);
}