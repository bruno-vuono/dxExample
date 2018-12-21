// This class manages the autjoin function
public class AP02_AutoJoin_CollaborationGroupMember	{	
   	/*
     * Add a list of user Ids to a list of Chatter groups.
     * 	/!\ method has to be @future as cannot mix setup/non-setup DML in the same transaction.
     ***/ 
    @future
  	public static void AutoJoinGroups(List<Id> userIds, List<Id> groupIds)	{
		/* Get the admin Email */
		String emailAdmin = Utils_UsefulMethods.adminEmailOfPRCustomSetting();
			
		/* Variables definition */      
		String debugMsg = '';
	    List<CollaborationGroupMember> entMembers = new List<CollaborationGroupMember>();
	    
      	// loop the users that have been created or activated
      	for (Id userId : userIds)	{
     		// Loop through all groups to join
          	for (Id autoJoinGroupID : groupIds)	{
            	CollaborationGroupMember entMember = new CollaborationGroupMember (CollaborationGroupId = autoJoinGroupID, MemberId = userId);
				System.debug('#### Autojoin : add entMemb '+userId+'/'+autoJoinGroupID);
            	entMembers.add(entMember);
          	}
      	}	      	
      	
        Database.SaveResult[] results;
        if(entMembers.size() != 0)
	  		results = Database.Insert(entMembers, false);  
	  		 
		if (results != null){
			for (Database.SaveResult result : results) {
				System.debug('####### '+result.isSuccess());
				if (!result.isSuccess()) {
					Database.Error[] errs = result.getErrors();
					for(Database.Error err : errs)
						if(''+err.getStatusCode() != 'DUPLICATE_VALUE')
							debugMsg += '\n #### AP02_AutoJoin_CollaborationGroupMember -- EXECUTE Error : '+err.getStatusCode() + ' - ' + err.getMessage();
				}
			}
		}
		
		if(debugMsg != ''){
			Utils_UsefulMethods.notifyAdminMsg(emailAdmin, 'AP02_AutoJoin_CollaborationGroupMember', 'Exception during insert list of CollaborationGroupMembers.',debugMsg);
			System.debug('####### '+debugMsg);
		}
   	}
		
   	/*
     * Add a list of user Ids to a group.
     * 	/!\ method has to be @future as cannot mix setup/non-setup DML in the same transaction.
     ***/
 /*  	@future
   	public static void AutoJoinListUsersToGroup(Set<Id> userIds, Id groupId)	{  		
		// Variables definition //     
	    List<CollaborationGroupMember> entMembers = new List<CollaborationGroupMember>();
	    
	  	// loop the users that have been created or activated
	  	for (Id userId : userIds)	{
	 		// Loop through all groups to join         
	 		system.debug('##### group['+groupId+']where add the user['+userId+']');
	 			system.debug('##### added');
		    	CollaborationGroupMember entMember = new CollaborationGroupMember (CollaborationGroupId = groupId, MemberId = userId);
		    	entMembers.add(entMember);
	  	}
	  	Database.SaveResult[] result = Database.Insert(entMembers, false);
   	}*/
   	   	
   	/*
     * Add a user Id to the map in parameters for the key in parameters.
     ***/ 
  /*  public static Map<Id,Set<Id>> addUserId2GroupMap(Map<Id,Set<Id>> currmap, Id UserID, Id groupID){ 
    	Set<Id> UserID_list;
    	if(currmap.get(groupID) != null)         
        	UserID_list = currmap.get(groupID);
    	else
        	UserID_list = new Set<Id>();
    	
    	// Check if user is not already in list //
    	if(!UserID_list.contains(UserID))	
        	UserID_list.add(UserID);
        
        currmap.put(groupID, UserID_list);
        
        return currmap;
    }*/
   	   	
   	/*
     * Add a Chatter group Id to the map in parameters for the key in parameters.
     ***/ 
 /*   public static Map<String,Set<Id>> addGroupId2CompMap(Map<String,Set<Id>> currmap, Id groupID, String CompName){ 
    	Set<Id> groupID_list;
    	if(currmap.get(CompName) != null)         
        	groupID_list = currmap.get(CompName);
    	else
        	groupID_list = new Set<Id>();
    	
    	// Check if group is not already in list //
    	if(!groupID_list.contains(groupID))	
        	groupID_list.add(groupID);
        
        currmap.put(CompName, groupID_list);
        
        return currmap;
    }	*/
}