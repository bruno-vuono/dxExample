@isTest
private class LAT_Utils_Test {
	
	@isTest static void test_method_one() {
		try{LAT_Utils.getFieldId('LAT_Case__c','LAT_Account__c');}catch(Exception e){}
		LAT_Utils.getRtId('LAT_Case__c');
		LAT_Utils.wasMigrationDone('1');
		try{LAT_Utils.getFieldId2('LAT_Case__c','LAT_Account__c');}catch(Exception e){}
		//LAT_Utils.getFieldIdWS('LAT_Case__c','LAT_Account__c');
		LAT_Utils.parseCSV('This is a test',true);
		LAT_Utils.parseCSV('This is a test',false);
		try{LAT_Utils.getObjectId('LAT_Case__c');}catch(Exception e){}
		LAT_Utils.isRunningTest();
	}	

	@isTest static void test_method_two() {
		try{LAT_Utils.getObjectId('LAT_Case__c');}catch(Exception e){}
		try{LAT_Utils.getFieldId('LAT_Case__c','LAT_Account__c');}catch(Exception e){}
		LAT_Utils.getRtId('LAT_Case__c');
		LAT_Utils.wasMigrationDone('1');
		try{LAT_Utils.getFieldId2('LAT_Case__c','LAT_Account__c');}catch(Exception e){}
		//LAT_Utils.getFieldIdWS('LAT_Case__c','LAT_Account__c');
		LAT_Utils.parseCSV('This is a test',true);
		LAT_Utils.parseCSV('This is a test',false);
		LAT_Utils.isRunningTest();
	}
	
	@isTest static void test_method_three() {
		Utils.setMigrationDoneTest(false); 
       list<RecordType> record = [select id, DeveloperName from RecordType WHERE SobjectType='Case' order by Name ASC];
        RecordType recordOffTradeArg = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'ACC_1_OffTrade_ARG' AND SobjectType='Account'];
        list<Case> listCases = new list<Case>();
    
        system.Test.startTest();
        Utils.setMigrationDoneTest(false); 
        Account acc = new Account(
        RecordTypeId = recordOffTradeArg.Id, 
        CNPJ__c = '33700964049',
        Name = 'testAccount',
        Type = 'Prospect_ARG',
        Corporate_Name__c = 'test',
        Channel_Type__c = 'Direto',
        Sub_Channel__c = 'Delicatessen',
        AddressLine1_AR__c= 'test',
        Shipping_Neighbourhood__c = 'test',
        Revenue_Neighbourhood__c = 'test',
        Billing_Neighbourhood__c ='test',
        Shipping_Country__c ='test',
        Revenue_Country__c ='test',
        Billing_Country__c ='test'
        );
        
        insert acc;
        LAT_Utils.getLatAccountMapByAccId(new List<Account> {acc});

         Profile p = [SELECT Id FROM Profile WHERE Name='AR_System Administrator']; 
         User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US',  ProfileId = p.Id,
         TimeZoneSidKey='America/Los_Angeles', UserName='CaseAR@mail.com');
         insert u2;


        system.Test.stopTest();
       
        
        Case caso = new Case(
            RecordTypeId = record[0].id  , 
            status= 'Without customer proposal-Sent to Credit',
            Reason = 'Alt. cliente pai',
            Description = 'TEST',
            OwnerId = u2.id,
            Type = 'Account Alteration ARG',
            AccountId= acc.id
        );
        insert caso;



		LAT_UY_CreditLimitController cont = new LAT_UY_CreditLimitController();

		cont.setCaseId(caso.Id);
		cont.getCaseId();
        Utils.setMigrationDoneTest(true); 
       list<RecordType> record2 = [select id, DeveloperName from RecordType WHERE SobjectType='LAT_Case__c' order by Name ASC];

		LAT_Case__c LAT_caso = new LAT_Case__c(
            RecordTypeId = record2[0].id  , 
            LAT_status__c = 'Without customer proposal-Sent to Credit',
            LAT_Reason__c = 'Alt. cliente pai',
            LAT_Description__c = 'TEST',
            OwnerId = u2.id,
            LAT_Type__c = 'Account Alteration ARG',
            LAT_Account__c = acc.id
        );

        insert LAT_caso;

        cont.setlatCaseId(LAT_caso.Id);
        cont.getLatCaseId();
            

	}
    @isTest static void test_method_four() {
            LAT_Utils.testOn = true;
            LAT_GetStock.Port port = new LAT_GetStock.Port();
            LAT_GetStockTypes.ClientInfoType clientInf = new LAT_GetStockTypes.ClientInfoType();
            clientInf.country = '1';
            LAT_GetStockTypes.ItemType item = new LAT_GetStockTypes.ItemType();
            List<LAT_GetStockTypes.ItemType> lstItem = new List<LAT_GetStockTypes.ItemType >();
            lstItem.add(item);
            LAT_GetStockTypes.ItemListType itemLista = new LAT_GetStockTypes.ItemListType();
            itemLista.item = lstItem;
            try {
            port.getStockOperation(clientInf,itemLista);
            }
            catch(Exception e){
                
            }

           // getStockOperation(LAT_GetStockTypes.ClientInfoType ClientInfo,LAT_GetStockTypes.ItemListType itemList) {

    }


}