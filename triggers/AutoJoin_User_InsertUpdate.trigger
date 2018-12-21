trigger AutoJoin_User_InsertUpdate on User (after insert, before update)  {
    String triggerName = 'AutoJoin_User_InsertUpdate';
 
     /* Get User profile for bypassing execution by System Administrator GDT - Jef 01/10/2013 */
    if((UserInfo.getProfileId()!='00eD0000001ApvPIAS') && (UserInfo.getProfileId()!= '00eL0000000DkgiIAC'))
{   
    /* Add group where Users should be added in a list */
    List<Id> autoJoinGroupsId = new List<Id>();
    String groupAutoJoinID = '';
    if(PR_Settings__c.getOrgDefaults().PR_AutoJoin_GroupID__c != null){
        System.debug('##### custom setting ok ');
        groupAutoJoinID = PR_Settings__c.getOrgDefaults().PR_AutoJoin_GroupID__c;
    }else{
        List<CollaborationGroup> searchList = [SELECT Id FROM CollaborationGroup WHERE Name LIKE 'Well\'Com'];
        if(searchList.size() != 0)
            groupAutoJoinID = searchList[0].Id;
    }
    
    if(groupAutoJoinID != '')
        autoJoinGroupsId.add(groupAutoJoinID);
    
    /* Get context User */
    User thisUser = [ SELECT Id,BypassTriggers__c FROM User WHERE Id = :UserInfo.getUserId() ];
    String bypass = ''+thisUser.BypassTriggers__c;
    
    /* Check if this trigger is bypassed or not */
    if(!bypass.contains(triggerName)){  
            
        /* Before Update : If user is activited */
        if (Trigger.isBefore && trigger.isupdate ) {
            List<Id> usersToTreatID_upd = new List<Id>();
            
            for(User newUser : Trigger.new){
                //Create an old and new map so that we can compare values
                User oldUser = Trigger.oldMap.get(newUser.ID);  
                //Retrieve the old and new Reseller Email Field            
                boolean oldIsActive = oldUser.IsActive;
                boolean newIsActive = newUser.IsActive;
                
                //If the fields are different        
                if (oldIsActive != newIsActive && newIsActive == true && newUser.ProfileId != EXT_USR_Config__c.getOrgDefaults().EXT_USR_RQT_External_Profile_Id__c) {
                    usersToTreatID_upd.add(newUser.Id);
                    System.debug('#### AutoJoin : add user to treat ');
                }
            }
            if(usersToTreatID_upd.size() != 0)
                AP02_AutoJoin_CollaborationGroupMember.AutoJoinGroups(usersToTreatID_upd,autoJoinGroupsId);
        }
        
        /* After Insert : If user is new */
        if (Trigger.isAfter && Trigger.isinsert) {
            List<Id> usersToTreatID_ins = new List<Id>();
    
            for(User newUser : Trigger.new){            
                if (newUser.IsActive == true && newUser.ProfileId != EXT_USR_Config__c.getOrgDefaults().EXT_USR_RQT_External_Profile_Id__c) {
                    usersToTreatID_ins.add(newUser.Id);
                }
            }
            if(usersToTreatID_ins.size() != 0)
                AP02_AutoJoin_CollaborationGroupMember.AutoJoinGroups(usersToTreatID_ins,autoJoinGroupsId);
        }
    }
} }