global class LAT_UpdateAccountOwner_Batch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
	
	String query;
	LAT_MasiveOwnerHeader__c header;
	List <Account> toUpdateAcc = new List<Account>();
	List <LAT_MasiveOwnerLine__c> toUpdate = new List<LAT_MasiveOwnerLine__c>();
	List <String> accountsIds = new List<String>();

	
	global LAT_UpdateAccountOwner_Batch(String headerId) {
		List <LAT_MasiveOwnerHeader__c> lst = [SELECT Id, CreatedById FROM LAT_MasiveOwnerHeader__c WHERE Id =: headerId];
		toUpdateAcc = new List<Account>();
		toUpdate = new List<LAT_MasiveOwnerLine__c>();
		if (lst != null && lst.size() > 0) {
			header = lst[0];
		}

		query = 'SELECT Id, OwnerId, LAT_AccountAN8__c, LAT_NewValue__c,LAT_NewValue__r.C_digo_JDE__c, LAT_Executed__c,LAT_Account__r.Accept_applications_Incompleted__c,LAT_Account__r.Accept_Backorder__c, LAT_Account__r.Accept_line_incompleted__c, ' +
					'LAT_Account__r.Affiliate__c, LAT_Account__r.Agency__c, LAT_Account__r.Bank__r.Name, LAT_Account__r.Bank_number__c, ' +
					'LAT_Account__r.Barcode_EDI__c, LAT_Account__r.Billing_Address_Code__c, LAT_Account__r.Billing_Priority__c, ' +
					'LAT_Account__r.Business_Unit__r.CodDefUsuario__c, LAT_Account__r.Carriers_Numbers__c, LAT_Account__r.Channel__c, ' +
					'LAT_Account__r.Checking_account__c, LAT_Account__r.Client_code_AN8__c, LAT_Account__r.CNPJ__c, ' +
					'LAT_Account__r.Corporate_Name__c,LAT_Account__r.Credit_line__c, LAT_Account__r.Current_account__c, ' +
					'LAT_Account__r.Customer_Flag__r.CodDefUsuario__c, LAT_Account__r.Customer_Geographic_Region__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Customer_GL__r.CodDefUsuario__c, LAT_Account__r.Customer_Organization__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Discount_Group__c, LAT_Account__r.Email_NFE__c, LAT_Account__r.Fax, LAT_Account__r.Freight_Type__c, ' +
					'LAT_Account__r.LAT_BR_BusinessSize__c,LAT_Account__r.LAT_BR_FiscalBenefit__c,LAT_Account__r.LAT_BR_PriorityLevel__c, ' +
					'LAT_Account__r.Municipal_Registration__c, LAT_Account__r.Nielsen_Area__r.CodDefUsuario__c, LAT_Account__r.OwnerId, ' +
					'LAT_Account__r.ParentId,LAT_Account__r.Parent.Client_code_AN8__c, LAT_Account__r.Payment_Condition__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Payment_instrument__r.CodDefUsuario__c,LAT_Account__r.Phone, LAT_Account__r.Rating_segmentation_targert_market__c, ' +
					'LAT_Account__r.Rating, LAT_Account__r.Receiving_Freight__c, LAT_Account__r.RecordTypeId, LAT_Account__r.Regional__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Revenue_Address__c, LAT_Account__r.Revenue_City__r.Name,LAT_Account__r.Revenue_City_Code__c, ' +
					'LAT_Account__r.Revenue_Complement__c, LAT_Account__r.Revenue_Country__c, LAT_Account__r.Revenue_Neighbourhood__c, ' +
					'LAT_Account__r.Revenue_Number__c, LAT_Account__r.Revenue_Postal_Code__c,  LAT_Account__r.Revenue_UF__c, ' +
					'LAT_Account__r.Shipping_Address_Code__c, LAT_Account__r.State_registration__c, LAT_Account__r.Sub_Channel_Rating__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Type,LAT_Account__r.WebSite,LAT_Account__r.Yes_No__c, LAT_Account__r.CurrencyISOCode, ' +
					'LAT_Account__r.Owner.C_digo_JDE__c,LAT_Account__r.AddressLine1_AR__c, LAT_Account__r.CatCode02_AR__r.CodDefUsuario__c, ' +
					'LAT_Account__r.CollectionAgent_AR__r.CodDefUsuario__c,LAT_Account__r.CustomerPriceGroup_AR__r.CodDefUsuario__c, ' +
					'LAT_Account__r.CustomerPoRequired_AR__c,LAT_Account__r.Id,LAT_Account__r.Name,LAT_Account__r.Regional_AR__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Status__c,LAT_Account__r.AccountNumber,LAT_Account__r.Business_Unit_AR__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Client_country_AN8__c, LAT_Account__r.Is_interface_Process_AR__c,LAT_Account__r.LAT_MX_ABCCode__r.CodDefUsuario__c,' +
					'LAT_Account__r.LAT_MX_AmountReceiptCopies__c, LAT_Account__r.LAT_MX_BatchProcess__r.CodDefUsuario__c, ' +
					'LAT_Account__r.LAT_MX_BreakDownIEPS__c, LAT_Account__r.LAT_MX_CableCodeS__c, LAT_Account__r.LAT_MX_Chain__r.CodDefUsuario__c, ' +
					'LAT_Account__r.LAT_MX_City__c, LAT_Account__r.LAT_MX_County__c, LAT_Account__r.LAT_MX_CreditVersionLevel__c, ' +
					'LAT_Account__r.LAT_MX_CRMClientCode__c, LAT_Account__r.LAT_MX_FiscalEntityType__c, LAT_Account__r.LAT_MX_FiscalRate__r.CodDefUsuario__c, ' +
					'LAT_Account__r.LAT_MX_Group__r.CodDefUsuario__c, LAT_Account__r.LAT_MX_Language__c, LAT_Account__r.LAT_MX_Market__c, ' +
					'LAT_Account__r.LAT_MX_Neighbourhood__c, LAT_Account__r.LAT_MX_PostalCode__r.Name, LAT_Account__r.LAT_MX_RelatedAddressAN8__c, ' +
					'LAT_Account__r.LAT_MX_RouteCode__r.CodDefUsuario__c, LAT_Account__r.LAT_MX_State__c, LAT_Account__r.LAT_MX_ZoneNumber__r.CodDefUsuario__c, ' +
					'LAT_Account__r.Owner.Email, LAT_Account__r.Owner.Name,LAT_Account__r.Return_JDE_Integration__c, LAT_Account__r.Segmentation_Type_on_trade__c, ' +
					'LAT_Account__r.LAT_Account__r.LAT_JDEZone__c '+
					'FROM LAT_MasiveOwnerLine__c WHERE LAT_Header__c = \'' + headerId + '\'';
		

		//query = 'SELECT Id, LAT_Account__r.Id, OwnerId, LAT_Account__r.OwnerId, LAT_AccountAN8__c, LAT_NewValue__c, LAT_Executed__c FROM LAT_MasiveOwnerLine__c WHERE LAT_Header__c = \'' + headerId + '\'';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {return Database.getQueryLocator(query);
		
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List <LAT_MasiveOwnerLine__c> lines = (List<LAT_MasiveOwnerLine__c>)scope;
		
		for (LAT_MasiveOwnerLine__c line : lines) {
			if (line.LAT_AccountAN8__c == 'Not exists') {
				line.LAT_Account__r.OwnerId = line.LAT_NewValue__c;				
			} else {
				//Fix to run especific flow for Brasil
				if (line.LAT_Account__r.Client_country_AN8__c.startsWith('1-')) {
					line.LAT_Account__r.OwnerId = line.LAT_NewValue__c;
					line.LAT_Account__r.owner = line.LAT_NewValue__r;
					line.LAT_Account__r.Is_interface_Process_AR__c = true;
					line.LAT_Account__r.Status__c = 'Aprovado - Aguardando retorno do JDE';
					if(!Test.isRunningTest()){
						LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDESync(line.LAT_Account__r);
					}
					
				} else {
					line.LAT_Account__r.OwnerId = line.LAT_NewValue__c;
					line.LAT_Account__r.owner = line.LAT_NewValue__r;
					line.LAT_Account__r.Is_interface_Process_AR__c = true;
					line.LAT_Account__r.Status__c = 'Customer Sent to JDE - Please Wait';
					if(!Test.isRunningTest()){
						LAT_WS_CustomerHandlerInterface.CustomerInterfaceJDESync(line.LAT_Account__r);
					}	
				}
								
			}
			line.LAT_Executed__c = true;
			toUpdate.add(line);
			accountsIds.add(line.LAT_Account__c);
			update line.LAT_Account__r;
			
		}

		
	}
	
	global void finish(Database.BatchableContext BC) {
		if (header != null) {
			header.LAT_Status__c = 'Completed';
			update header;
			update toUpdate;
			User submitter = [SELECT Id, Email, Name FROM User WHERE id = :header.CreatedById];
			List <Account> accs = [SELECT Id, Name, Status__c, OwnerId, Owner.Name FROM Account WHERE Id IN :accountsIds];
			String[] emailAddresses = LAT_GeneralConfigDao.getValueAsStringArray('MASIVE_OWNER_EMAIL_TARGET_ADDRESSES', ',');
			emailAddresses.add(submitter.Email);
			String emailBody	= '<html><body><b>' + Label.LAT_UpdateAccountOwner_Mail01 + '</b> <br> <br><table width="75%" align="center" cellpadding="10"><tr><td><b>' + Label.LAT_UpdateAccountOwner_Mail02 + '<b/></td><td><b>' + Label.LAT_UpdateAccountOwner_Mail03 + '<b/></td><td><b>Status<b/></td></tr> ';
			for (Account acc : accs) {
				emailBody += '<tr><td>' + acc.Name + '</td><td>' + acc.Owner.Name + '</td><td>' + acc.Status__c + '</td></tr>';
			}
			emailBody += '</table></body></html>';
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(emailAddresses);
     		mail.setHtmlBody(emailBody);
	   		mail.setSenderDisplayName('noreply@pernod-ricard.com');
	   		mail.setSubject(Label.LAT_UpdateAccountOwner_Mail05);
	   		List<Messaging.SingleEmailMessage> list_emailsToSent = new List<Messaging.SingleEmailMessage>();
	   		list_emailsToSent.add(mail);	
	   		Messaging.sendEmail(list_emailsToSent);
		}
	}
	
}