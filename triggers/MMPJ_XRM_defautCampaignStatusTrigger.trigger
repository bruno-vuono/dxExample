/*
 * Trigger : à la création d'une campagne de type MMPJ Extranet Vigneron Viticulteur, les status des membres de campagne sont ceux définis dans la metadata Status_Campain_Members__mdt
 */ 
trigger MMPJ_XRM_defautCampaignStatusTrigger on Campaign (after insert) {
    Integer orderItem = 3;
    Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Campaign.getRecordTypeInfosById();
    //List des status à insérer
    List<CampaignMemberStatus> insertStatus = new List<CampaignMemberStatus>();
    Map<String,CampaignMemberStatus> existStatus = new Map<String,CampaignMemberStatus>();
    System.debug('DefautCampagin');
    for (Campaign c: trigger.new){
        String type = rtMap.get(c.RecordTypeId).getName();
        System.debug(type);
        if (type == 'MMPJ Extranet Vigneron Viticulteur') {
            for(CampaignMemberStatus CMS : [select ID, CampaignID,Label from CampaignMemberStatus where CampaignID = :c.Id]) {
                //on ajoute pour la suppression les status existants
                existStatus.put(CMS.Label,CMS);
                System.debug('Put : '+CMS);
                //On incrémente l'ordre pour insérer après les status existants
                orderItem++;
            }
            for(MMPJ_XRM_Status_Campain_Members__mdt statusItem : [SELECT MasterLabel, MMPJ_XRM_Isdefaut__c, MMPJ_XRM_Responded__c FROM MMPJ_XRM_Status_Campain_Members__mdt]){
                if (!existStatus.containsKey(statusItem.MasterLabel)) {
                    //On ajoute les status de Metadata pour insertion (s'il n'existe pas en tant que status par défaut)
                    CampaignMemberStatus cmsLoop = new CampaignMemberStatus(CampaignId = c.Id, Label = statusItem.MasterLabel, SortOrder = orderItem, isDefault = Boolean.ValueOf(statusItem.MMPJ_XRM_IsDefaut__c),HasResponded = Boolean.valueOf(statusItem.MMPJ_XRM_Responded__c));
                    insertStatus.add(cmsLoop);
                    System.debug('Loop : '+cmsLoop);
                    orderItem++;
                }   
            }
            System.debug('insertStatus : '+insertStatus);
            //Insertion des status définies dans la metadata
            insert insertStatus;
            //Suppression des status existant (par défaut)
            delete existStatus.values();

        }
    }
    
}