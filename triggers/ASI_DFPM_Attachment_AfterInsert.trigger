trigger ASI_DFPM_Attachment_AfterInsert on Attachment (after insert) {
    
    List<Profile> lst_Profile = new List<Profile>();
    lst_Profile = [SELECT Id, Name FROM Profile WHERE Name LIKE 'ASI%' OR Name LIKE '%Admin%' OR Name LIKE '%ADF'];

    Boolean isAsiProfile = false;

    for(Profile p : lst_Profile){
        if(p.get('Id') == UserInfo.getProfileId()){
            isAsiProfile = true;
        }
    }

    if(isAsiProfile == true){
        List<ASI_DFPM_TriggerAbstract> triggerClasses = new List<ASI_DFPM_TriggerAbstract> {
            new ASI_DFPM_AttachParentIndicatorHandler()
        };
        
        for (ASI_DFPM_TriggerAbstract triggerClass : triggerClasses) {
            triggerClass.executeTriggerAction(ASI_DFPM_TriggerAbstract.TriggerAction.AFTER_INSERT, trigger.new, trigger.newMap, trigger.oldMap);
        }
    }    
}