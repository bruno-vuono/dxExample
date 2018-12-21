public class AP01_Autofollow_EntitySubscription {    
	// method has to be @future as cannot mix setup/non-setup DML in the same transaction
	@future	
	public static void AutofollowUsers(List<Id> userIds) {  
		/* Variables definition */     
		// set up the users that should automatically be followed
		List<user> usersfollowed=[Select Id,IsActive From user Where autofollow__c = true AND IsActive = true];
		// Initiate the list of Entity Subscription that will be created. 
		List<EntitySubscription> entSubs=new List<EntitySubscription>();
		// Get the admin Email //
		String emailAdmin = Utils_UsefulMethods.adminEmailOfPRCustomSetting();

		/* Creation of subscriptions */
		// loop the users that have been created
		for (Id userId : userIds) {
			// Loop through all users to follow       
			for (user ufl : usersfollowed){
				// check if user to follow is not the same as the user followed
				if(userId != ufl.Id){
					EntitySubscription entSub = new EntitySubscription (parentId = ufl.Id, SubscriberId = userId);
					System.debug('#### Autofollow : add entsub '+ufl.Id+'/'+userId);
					entSubs.add(entSub);
				}
			}
		}
	  	Database.SaveResult[] results = Database.Insert(entSubs, false);
	  	
        // Check results of insert //
        String debugMsg = '';
		if (results != null){
			for (Database.SaveResult result : results) {
				if (!result.isSuccess()) {
					Database.Error[] errs = result.getErrors();
					for(Database.Error err : errs)
						if(''+err.getStatusCode() != 'DUPLICATE_VALUE')
							debugMsg += '\n' +'#### AP01_Autofollow_EntitySubscription -- EXECUTE Error : '+err.getStatusCode() + ' - ' + err.getMessage();
				}
			}
		}
        // If error, notify the administrator //
		if(debugMsg != ''){
    		Utils_UsefulMethods.notifyAdminMsg(emailAdmin, 'AP01_Autofollow_EntitySubscription', 'Exception during the future method.',debugMsg);
		}
	}
}