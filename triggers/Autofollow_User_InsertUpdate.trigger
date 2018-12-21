trigger Autofollow_User_InsertUpdate on User (after insert, before update)  {
    String triggerName = 'Autofollow_User_InsertUpdate';
 
     /* Get User profile for bypassing execution by System Administrator GDT - Jef 01/10/2013 */
    if((UserInfo.getProfileId()!='00eD0000001ApvPIAS') && (UserInfo.getProfileId()!= '00eL0000000DkgiIAC'))
{   
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
                System.debug('#### Autofollow : oldIsActive '+oldIsActive);
                System.debug('#### Autofollow : newIsActive '+newIsActive);
                
                //If the fields are different        
                if (oldIsActive != newIsActive && newIsActive == true && newUser.ProfileId != EXT_USR_Config__c.getOrgDefaults().EXT_USR_RQT_External_Profile_Id__c) {
                    usersToTreatID_upd.add(newUser.Id);
                    System.debug('#### AutoFollow : add user to treat ');
                }
            }
            System.debug('#### AutoFollow : user to treat [update] : '+usersToTreatID_upd.size());
            if(usersToTreatID_upd.size() != 0)
                AP01_Autofollow_EntitySubscription.AutofollowUsers(usersToTreatID_upd);
        }
        
        /* After Insert : If user is new */
        if (Trigger.isAfter && Trigger.isinsert) {
            List<Id> usersToTreatID_ins = new List<Id>();
    
            for(User newUser : Trigger.new){
                if (newUser.IsActive == true && newUser.ProfileId != EXT_USR_Config__c.getOrgDefaults().EXT_USR_RQT_External_Profile_Id__c) {                   
                    usersToTreatID_ins.add(newUser.Id);
                }
            }
            System.debug('#### AutoFollow : user to treat[insert] : '+usersToTreatID_ins.size());
            if(usersToTreatID_ins.size() != 0)
                AP01_Autofollow_EntitySubscription.AutofollowUsers(usersToTreatID_ins);
        }
    }
}
}