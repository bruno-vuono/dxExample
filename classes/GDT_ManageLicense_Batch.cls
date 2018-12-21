global class GDT_ManageLicense_Batch implements Database.Batchable<sObject>{
	
	/** Variable Declaration */
	String idUser {get;set;}
	String query {get;set;}
	Date dateToday {get;set;}

	String licenseID {get;set;}
	String licenseName {get;set;}
	String application {get;set;}
	String affiliate {get;set;}
	

	/** User list */
	public List<User> listAll_User {
		get {
			if(Test.isRunningTest())
				return [SELECT Id, ProfileId, Name FROM User WHERE isActive = true LIMIT 500];
			else
				return [SELECT Id, ProfileId, Name FROM User WHERE isActive = true];
		}
	}
	/** Retrieves the purchase list */
	public List<GDT_ManageLicense_Purchase__c> listAll_Purchase {
		get {
			System.debug('Date TODAY: ' + this.dateToday);
			return [SELECT Id,  GDT_Purchase_Description__c ,GDT_Purchase_AffiliateGroup__c, GDT_Purchase_LicenseType__r.Name, GDT_Purchase_LicenseType__r.GDT_License_APIName__c, GDT_Purchase_TotalLicenses__c, GDT_Purchase_ExpirationDate__c, GDT_Purchase_PurchaseDate__c, GDT_Purchase_AppName__c FROM GDT_ManageLicense_Purchase__c WHERE GDT_Purchase_PurchaseDate__c < :dateToday AND GDT_Purchase_ExpirationDate__c > :dateToday];
		}
	}

	/** Listing all profiles */
	public List<GDT_CustomSettings_Profile__c> listUpdate_csProfile_All = new List<GDT_CustomSettings_Profile__c>();
	public List<GDT_CustomSettings_Profile__c> csProfile_All {
		get {
			try {
				listUpdate_csProfile_All = [SELECT ProfileID__c, ProfileName__c, UserLicenseID__c, AffiliateGroup__c, ApplicationName__c FROM GDT_CustomSettings_Profile__c ORDER BY ProfileName__c ASC NULLS FIRST]; 
				return listUpdate_csProfile_All; 
			} catch(Exception e) {
				System.debug(e.getMessage());
				return null;
			}           
		}
	}

	// Return affiliate list
	public List<String> listAffiliate_CustomSettings {
		get {
			List<String> listToReturn = new List<String>();
			//Browse a CustomSettings to get a affiliate list
			for(GDT_CustomSettings_Profile__c lp : csProfile_All){
				listToReturn.add(lp.AffiliateGroup__c);
			}
			//Sets, by definition, contain no duplicates.
			Set<String> mySet = new Set<String>();
			mySet.addAll(listToReturn);
			listToReturn.clear();
			listToReturn.addAll(mySet);

			return listToReturn;
		}
	}
	// Return application list
	public List<String> listApplication_CustomSettings {
		get {
			List<String> listToReturn = new List<String>();
			//Browse a CustomSettings to get a affiliate list
			for(GDT_CustomSettings_Profile__c lp : csProfile_All){
				if(lp.ApplicationName__c != null)
					listToReturn.add(lp.ApplicationName__c);
			}
			//Sets, by definition, contain no duplicates.
			Set<String> mySet = new Set<String>();
			mySet.addAll(listToReturn);
			listToReturn.clear();
			listToReturn.addAll(mySet);

			return listToReturn;
		}
	}
	

	/** [GDT_ManageLicense_Batch Description] */
	global GDT_ManageLicense_Batch() {}
	global GDT_ManageLicense_Batch(String licenseName, String licenseID) {
		this.licenseName = licenseName;
		this.licenseID = licenseID;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		this.idUser = UserInfo.getUserId();
		this.query = 'SELECT Id, ProfileId, Name FROM User WHERE isActive = true AND Id =:idUser';
		
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		this.dateToday = Date.today();
		execute_Update();
	}
	
	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];

		// Send an email to the Apex job's submitter 
		// notifying of job completion. 
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Batch Manage License updating licenses used: (Type: '+ this.licenseName + ') '+ a.Status);
		mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

	/***/
	public List<GDT_CustomSettings_Profile__c> listProfile_Filter() {
		List<GDT_CustomSettings_Profile__c> lp = new List<GDT_CustomSettings_Profile__c>();

		for(GDT_CustomSettings_Profile__c cs : csProfile_All) {
			if(cs.UserLicenseID__c == this.licenseName && cs.AffiliateGroup__c == this.affiliate && cs.ApplicationName__c == this.application) {
				lp.add(cs);
			}
		}

		return lp;
	}

	/** Uncheck the last record for the object 'GDT_ManageLicense_Analysis__c' */
	global void UncheckLastUpdate() {
		try {
			List<GDT_ManageLicense_Analysis__c> uAnalysis = null;
			
			uAnalysis = [SELECT Id, GDT_Analysis_LastUpdate__c, GDT_Analysis_TotalLicenses__c FROM GDT_ManageLicense_Analysis__c WHERE GDT_Analysis_LastUpdate__c = true AND GDT_Analysis_LicenseType__c = :this.licenseID];

			if(uAnalysis.isEmpty() == false) {
				for(GDT_ManageLicense_Analysis__c oLoop : uAnalysis) {
					oLoop.GDT_Analysis_LastUpdate__c = false;
					update oLoop;
				}
			}
		} catch(Exception e) {
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'CATCH: '+e.getMessage()));
			System.debug(e.getMessage());
		}
	}


	global void execute_Update() {
		//Uncheck the field 'LastUpdate' for other record
		UncheckLastUpdate();

		try {
			List<User> list_User = listAll_User;

				for(String affiliate : listAffiliate_CustomSettings){
					this.affiliate = affiliate;

					for(String application : listApplication_CustomSettings){
						this.application = application;

						createRecordAnalysis(list_User);

					}
					this.application = null;
					createRecordAnalysis(list_User);

				}

		} catch(Exception e) {
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'E01: '+e.getMessage()));
			System.debug(e.getMessage());
		}

	}

	public void createRecordAnalysis(List<User> list_User) {

		GDT_ManageLicense_Analysis__c oAnalysis = new GDT_ManageLicense_Analysis__c();
			oAnalysis.GDT_Analysis_LicenseType__c = this.licenseID;
			oAnalysis.GDT_Analysis_AffiliateGroup__c = this.affiliate;
			oAnalysis.GDT_Analysis_AppName__c = this.application;

			oAnalysis.GDT_Analysis_UsedLicenses__c = 0;
			oAnalysis.GDT_Analysis_TotalLicenses__c = 0;

			for(GDT_CustomSettings_Profile__c csProfile : listProfile_Filter()){
				//oAnalysis.GDT_Analysis_UsedLicenses__c += [SELECT count() FROM User WHERE isActive=true AND ProfileId = :csProfile.ProfileID__c];
				
				for(User usr : list_User){
					if(usr.ProfileId == csProfile.ProfileID__c) {oAnalysis.GDT_Analysis_UsedLicenses__c++;}
				}
				
			}
			
			/**Calculate TotalLicences */
			for(GDT_ManageLicense_Purchase__c lp : listAll_Purchase) {
				if(lp.GDT_Purchase_LicenseType__c == this.LicenseID && lp.GDT_Purchase_AffiliateGroup__c == this.affiliate && lp.GDT_Purchase_AppName__c == this.application)
					oAnalysis.GDT_Analysis_TotalLicenses__c += lp.GDT_Purchase_TotalLicenses__c;
			}

			if(oAnalysis.GDT_Analysis_UsedLicenses__c == 0 && oAnalysis.GDT_Analysis_TotalLicenses__c == 0) {/* No insert */}
			else {
				insert oAnalysis;
			}
	}
}