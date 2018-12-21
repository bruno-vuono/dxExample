/*
+-----------------------+------------------------------------------------------------------------------------+
| Author                | Cécile Lartaud                                                                     |
+-----------------------+------------------------------------------------------------------------------------+
| Description           |                                                                                    |
|                       |                                                                                    |
|     - Object(s)       | User                                                                               |
|     - Description     | automatically add created and updated user in a chatter group defined by           |
|                       | custom setting.                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
| Creation Date         | 07/05/2013                                                                         |
+-----------------------+------------------------------------------------------------------------------------+
| Modifications         |            Jef le 01/10/2013 pour bypass par "System Administrator GDT"                                                                        |
+-----------------------+------------------------------------------------------------------------------------+
| Governor informations |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
*/
trigger ESN_User_AutojoinByAffiliates on User (after insert, after update) {    
    String triggerName = 'ESN_User_AutojoinByAffiliates';
    
    /* Get User profile for bypassing execution by System Administrator GDT - Jef 01/10/2013 */
    if((UserInfo.getProfileId()!='00eD0000001ApvPIAS') && (UserInfo.getProfileId()!= '00eL0000000DkgiIAC'))
{
     
   /* Get ID of the External profile  */
    String extProfileID = EXT_USR_Config__c.getOrgDefaults().EXT_USR_RQT_External_Profile_Id__c;

    /* Get context User */
    User thisUser = [ SELECT Id,BypassTriggers__c FROM User WHERE Id = :UserInfo.getUserId() ];
    String bypass = ''+thisUser.BypassTriggers__c;
    
    /* Check if this trigger is bypassed or not */
    if(!bypass.contains(triggerName)){  
        
        /* Get the admin Email */
        String emailAdmin = Utils_UsefulMethods.adminEmailOfPRCustomSetting();

        /* Create a list of allowed users */
        List<Id> usersConcerned_list = new List<Id>();
        
        /*
         * After Update : If user is activated 
         ****/
        if (Trigger.isAfter && trigger.isupdate ) {
            try{       
                /** Get all couples (group ; company) in a map then build a map (key: company; value: group ID) **/
                List<ESN_AutojoinByAffiliates_Config__c> configs_list = ESN_AutojoinByAffiliates_Config__c.getAll().values();
                Map<String,Set<Id>> configAffiliate2SetGroup_map = new Map<String,Set<Id>>();
                List<Id> allUsersJoinGroup_list = new List<Id>();
                
                for(ESN_AutojoinByAffiliates_Config__c conf : configs_list){
                    if(conf.Affiliate__c != 'All'){
                        Set<Id> ChatterGroupID_list;
                        if(configAffiliate2SetGroup_map.get(conf.Affiliate__c) != null)         
                            ChatterGroupID_list = configAffiliate2SetGroup_map.get(conf.Affiliate__c);
                        else
                            ChatterGroupID_list = new Set<Id>();
                        
                        // Check if user is not already in list //
                        if(!ChatterGroupID_list.contains(conf.Chatter_Group_ID__c)) 
                            ChatterGroupID_list.add(conf.Chatter_Group_ID__c);
                        
                        configAffiliate2SetGroup_map.put(conf.Affiliate__c, ChatterGroupID_list);
                    }else{
                        allUsersJoinGroup_list.add(conf.Chatter_Group_ID__c);
                    }
                }   
                
                /** If more than 5 users are processed in a same time, use the batch **/
                if(Trigger.new.size() > 5){
                    for(User newUser : Trigger.new){
                        //Create an old and new map so that we can compare values
                        User oldUser = Trigger.oldMap.get(newUser.ID);  
                        //Retrieve the old and new isActive Field            
                        boolean oldIsActive = oldUser.IsActive;
                        boolean newIsActive = newUser.IsActive;
    
                        //If the fields are different        
                        if (newUser.ProfileId != extProfileID && newIsActive == true && newUser.CompanyName != null && ( oldUser.CompanyName != newUser.CompanyName || oldIsActive != newIsActive  )) {
                            // Check if the Company of this user is configured in the custom settings //
                            if(configAffiliate2SetGroup_map.containsKey(newUser.CompanyName)){
                                System.debug('###### user modif '+newUser.alias +'/'+newUser.Id +'/'+newUser.CompanyName);
                                usersConcerned_list.add(newUser.Id);
                            }
                        }
                    }
                    
                    if(usersConcerned_list.size() != 0){
                        // Concatenate all users Ids into a string to pass it in the soql query. //
                        String usersId = String.join(usersConcerned_list,'\',\'');
                        System.debug('###### user id concatene '+usersId);
                        
                        // Execute the batch //
                        APB03_Autojoin_By_Affiliate batch = new APB03_Autojoin_By_Affiliate();
                        batch.soql = 'SELECT Id,CompanyName FROM User WHERE Id IN (\''+usersId+'\')';
                        ID batch_processId = Database.executeBatch(batch, 200); //execute the batch
                    }
                }               
                /** If not, use the @future method **/
                else{
                    
                    // For each users in the pipe, join the concerned groups // 
                    for(User newUser : Trigger.new){    
                        // Create an old and new map so that we can compare values
                        User oldUser = Trigger.oldMap.get(newUser.ID);  
                        // Retrieve the old and new isActive Field            
                        boolean oldIsActive = oldUser.IsActive;
                        boolean newIsActive = newUser.IsActive;
                        
                        if (newUser.ProfileId != extProfileID && newIsActive == true && newUser.CompanyName != null && ( oldUser.CompanyName != newUser.CompanyName || oldIsActive != newIsActive ) ) {
                            List<Id> joinGroups_list = new List<Id>();
                            // Check if the Company of this user is configured in the custom settings //
                            if(configAffiliate2SetGroup_map.containsKey(newUser.CompanyName)){
                                joinGroups_list.addAll(configAffiliate2SetGroup_map.get(newUser.CompanyName));
                                joinGroups_list.addAll(allUsersJoinGroup_list);                             
                                AP02_AutoJoin_CollaborationGroupMember.AutoJoinGroups(new List<Id>{newUser.Id},joinGroups_list); 
                            }
                        }
                    }
                }
            }catch (Exception e){
                if(!e.getMessage().contains('DUPLICATE_VALUE, duplicate value found'))
                    Utils_UsefulMethods.notifyAdminException(emailAdmin, 'ESN_User_AutojoinByAffiliates', 'Exception during the trigger.',e);
            }
        }
        
        /*
         * After Insert : If user is new 
         ****/
        if (Trigger.isAfter && Trigger.isinsert) {
            try{
                /** Get all couples (group ; company) in a map then build a map (key: company; value: group ID) **/
                List<ESN_AutojoinByAffiliates_Config__c> configs_list = ESN_AutojoinByAffiliates_Config__c.getAll().values();
                Map<String,Set<Id>> configAffiliate2SetGroup_map = new Map<String,Set<Id>>();
                List<Id> allUsersJoinGroup_list = new List<Id>();
                
                for(ESN_AutojoinByAffiliates_Config__c conf : configs_list){
                    if(conf.Affiliate__c != 'All'){
                        Set<Id> ChatterGroupID_list;
                        if(configAffiliate2SetGroup_map.get(conf.Affiliate__c) != null)         
                            ChatterGroupID_list = configAffiliate2SetGroup_map.get(conf.Affiliate__c);
                        else
                            ChatterGroupID_list = new Set<Id>();
                        
                        // Check if user is not already in list //
                        if(!ChatterGroupID_list.contains(conf.Chatter_Group_ID__c)) 
                            ChatterGroupID_list.add(conf.Chatter_Group_ID__c);
                        
                        configAffiliate2SetGroup_map.put(conf.Affiliate__c, ChatterGroupID_list);
                    }else{
                        allUsersJoinGroup_list.add(conf.Chatter_Group_ID__c);
                    }
                }
                    
                /** If more than 5 users are processed in a same time, use the batch **/
                if(Trigger.new.size() > 5){
                    for(User newUser : Trigger.new){            
                        if (newUser.IsActive == true && newUser.ProfileId != extProfileID && newUser.CompanyName != null) {
                            // Check if the Company of this user is configured in the custom settings //
                            if(configAffiliate2SetGroup_map.containsKey(newUser.CompanyName)){
                                System.debug('###### user modif '+newUser.alias +'/'+newUser.Id +'/'+newUser.CompanyName);
                                usersConcerned_list.add(newUser.Id);
                            }
                        }
                    }
                    
                    if(usersConcerned_list.size() != 0){
                        // Concatenate all users Ids into a string to pass it in the soql query. //
                        String usersId = String.join(usersConcerned_list,'\',\'');
                        
                        // Execute the batch //
                        APB03_Autojoin_By_Affiliate batch = new APB03_Autojoin_By_Affiliate();
                        batch.soql = 'SELECT Id,CompanyName FROM User WHERE Id IN (\''+usersId+'\')';                
                        ID batch_processId = Database.executeBatch(batch, 200); //execute the batch
                    }
                }               
                /** If not, use the @future method **/
                else{                   
                    // For each users in the pipe, join the concerned groups // 
                    for(User newUser : Trigger.new){    
                        if (newUser.IsActive == true && newUser.ProfileId != extProfileID && newUser.CompanyName != null) {
                            List<Id> joinGroups_list = new List<Id>();
                            
                            // Check if the Company of this user is configured in the custom settings //
                            if(configAffiliate2SetGroup_map.containsKey(newUser.CompanyName)){
                                joinGroups_list.addAll(configAffiliate2SetGroup_map.get(newUser.CompanyName));
                                joinGroups_list.addAll(allUsersJoinGroup_list);
                                AP02_AutoJoin_CollaborationGroupMember.AutoJoinGroups(new List<Id>{newUser.Id},joinGroups_list);
                            } 
                        }
                    }                   
                }
            }catch (Exception e){
                    Utils_UsefulMethods.notifyAdminException(emailAdmin, 'ESN_User_AutojoinByAffiliates', 'Exception during the trigger.',e);
            }
        }
    }
} }