trigger MMPJ_Ext_Vign_ContentDocumentLinkAfterInsert on ContentDocumentLink (After insert) {
    system.debug('>>> Trigger contentDocumentLinkAfterInsert : trigger.new[0]: ' + trigger.new[0]);
    if (trigger.new[0].LinkedEntityId != userInfo.getUserId()){
        
        Id entityId = trigger.new[0].LinkedEntityId;
        String sObjectName = entityId.getSObjectType().getDescribe().getName();
        system.debug('FileSharing : sObjectName: ' + sObjectName);
        if (sObjectName == 'Campaign')
        {
            MMPJ_Ext_Vign_FileSharing.insertDocument(sObjectName,entityId, trigger.new[0].ContentDocumentId);
        }
    }
}