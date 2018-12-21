global class GDT_SetupAuditTrail_Batch implements Database.Batchable<sObject> {
	
	String query;
	String userID;

	/** Custom Object : Setup Audit Trail */
	public Datetime dt_SetupAuditTrail_c {
		get {
			if([SELECT count() FROM GDT_Setup_Audit_Trail__c LIMIT 1] == 0){
				return [SELECT CreatedDate FROM SetupAuditTrail ORDER BY CreatedDate ASC NULLS FIRST LIMIT 1].CreatedDate; //2015-05-26T02:41:31.000Z
			}
			else {
				return [SELECT CreatedDate__c FROM GDT_Setup_Audit_Trail__c ORDER BY CreatedDate__c DESC NULLS FIRST LIMIT 1].CreatedDate__c; //2015-06-04T12:26:09.000Z
			}
		}
	}

	public List<GDT_Setup_Audit_Trail__c> list_SetupAuditTrail_c {
		get {
			if([SELECT count() FROM GDT_Setup_Audit_Trail__c WHERE CreatedDate__c = :dt_SetupAuditTrail_c LIMIT 1] == 0){
				return null;
			}
			else {
				return [SELECT Name, CreatedById__c FROM GDT_Setup_Audit_Trail__c WHERE CreatedDate__c = :dt_SetupAuditTrail_c LIMIT 2000]; //siez: 660
			}
		}
	}
	

	/** Standard Object : Setup Audit Trail */
	public List<SetupAuditTrail> listNewRecord_EqualTime_SetupAuditTrail_s {
		get {

			return [SELECT Action,CreatedById,CreatedDate,Display,Id,Section,DelegateUser FROM SetupAuditTrail WHERE CreatedDate = :dt_SetupAuditTrail_c ORDER BY CreatedDate ASC NULLS FIRST LIMIT 3000];
		}
	}
	public List<SetupAuditTrail> listNewRecord_UpperTime_SetupAuditTrail_s {
		get {

			return [SELECT Action,CreatedById,CreatedDate,Display,Id,Section,DelegateUser FROM SetupAuditTrail WHERE CreatedDate > :dt_SetupAuditTrail_c ORDER BY CreatedDate ASC NULLS FIRST LIMIT 7000];
		}
	}
	
	global GDT_SetupAuditTrail_Batch() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		this.query = 'SELECT Action,CreatedById,CreatedDate,Display,Id,Section,DelegateUser FROM SetupAuditTrail LIMIT 10';

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<SetupAuditTrail> scope) {
		try {
			Boolean recordExist = false;

			List<GDT_Setup_Audit_Trail__c> elist_SetupAuditTrail_c = this.list_SetupAuditTrail_c;
			List<SetupAuditTrail> elistNewRecord_EqualTime_SetupAuditTrail_s = this.listNewRecord_EqualTime_SetupAuditTrail_s;
			//List<SetupAuditTrail> elistNewRecord_UpperTime_SetupAuditTrail_s = this.listNewRecord_UpperTime_SetupAuditTrail_s;
			List<SetupAuditTrail> elistToBeInsert_SetupAuditTrail_s = this.listNewRecord_UpperTime_SetupAuditTrail_s;
			//List<SetupAuditTrail> elistToBeInsert_SetupAuditTrail_s = new List<SetupAuditTrail>();

			System.debug('LIMIT: ' +  Limits.getQueryRows() + ' :: ' + Limits.getLimitQueryRows());

			//if(Test.isRunningTest() == true){ listNewRecord_SetupAuditTrail_s = scope; }

			if(elist_SetupAuditTrail_c == NULL) {
				elistToBeInsert_SetupAuditTrail_s.addAll(elistNewRecord_EqualTime_SetupAuditTrail_s);
			}
			else if (elist_SetupAuditTrail_c.size() > 0) {
				for(SetupAuditTrail obj: elistNewRecord_EqualTime_SetupAuditTrail_s) {
					recordExist = false; // Initialise

					for(GDT_Setup_Audit_Trail__c cObj : elist_SetupAuditTrail_c) {
						if(cObj.Name == obj.Id) {
							recordExist = true;
						}
					}

					if(recordExist == false) {
						elistToBeInsert_SetupAuditTrail_s.add(obj);
					}
				}
			}

			List<GDT_Setup_Audit_Trail__c> elistToBeInsert_SetupAuditTrail_c = new List<GDT_Setup_Audit_Trail__c>();
			for(SetupAuditTrail obj : elistToBeInsert_SetupAuditTrail_s) {
				GDT_Setup_Audit_Trail__c cObj_SetupAuditTrail = new GDT_Setup_Audit_Trail__c(); //Custom Object : Setup Audit Trail
				cObj_SetupAuditTrail.Name               = obj.Id;
				cObj_SetupAuditTrail.Action__c          = obj.Action;
				cObj_SetupAuditTrail.CreatedById__c     = obj.CreatedById;
				cObj_SetupAuditTrail.CreatedDate__c     = obj.CreatedDate;
				cObj_SetupAuditTrail.DelegateUser__c    = obj.DelegateUser;
				cObj_SetupAuditTrail.Display__c         = obj.Display;
				cObj_SetupAuditTrail.Section__c         = obj.Section;
				elistToBeInsert_SetupAuditTrail_c.add(cObj_SetupAuditTrail);
			}

			insert elistToBeInsert_SetupAuditTrail_c;
			
		} catch(Exception e) {
			System.debug(e.getMessage());
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];

		// Send an email to the Apex job's submitter 
		// notifying of job completion. 
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Batch Setup Audit Trail '+ a.Status);
		mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
}