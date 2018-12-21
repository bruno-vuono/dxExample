@isTest	
public with sharing class LAT_VFC06_MasiveOwnerUpdate_Test {
	static testMethod void  Test_01() {
		
		String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        
        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000', 
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX,
            client_country_an8__c = '12-1234'
        );
		insert acc;
		String thisUserId = UserInfo.getUserId();	

		LAT_VFC06_MasiveOwnerUpdate controller = new LAT_VFC06_MasiveOwnerUpdate();
		controller.toParse = blob.valueOf('AN8,New Owner\r\n1234,' + thisUserId + '\r\n');
		controller.upload();
	}


	@isTest static void Test_02() {
         User usuario = new User();
		String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','MX');   
	    insert usuario;

        Account acc = new Account(
        	OwnerId = usuario.Id,
            Name = 'TEST',
            AccountNumber = '1000', 
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX,
            client_country_an8__c = '12-1234'
        );
		insert acc;

		LAT_MasiveOwnerHeader__c header = new LAT_MasiveOwnerHeader__c();
    	header.LAT_Status__c = 'New';
    	header.LAT_Approver__c = UserInfo.getUserId();
    	insert header;

    	header.LAT_Status__c = 'Execution';
    	update header;
	}

	@isTest static void Test_03() {
		String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        User usuario = new User();
        usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
        insert usuario;  
	    
	    

        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000', 
            Status__c = 'Novo cadastro',
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            OwnerId = usuario.Id,
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX,
            client_country_an8__c = '12-1234',
            Credit_line__c = 10
        );
		insert acc;

		LAT_MasiveOwnerHeader__c header = new LAT_MasiveOwnerHeader__c();
    	header.LAT_Status__c = 'New';
    	header.LAT_Approver__c = UserInfo.getUserId();
    	insert header;

		LAT_MasiveOwnerLine__c line = new LAT_MasiveOwnerLine__c();
		line.LAT_Account__c = acc.id;
		line.LAT_AccountAN8__c = acc.client_country_an8__c;
		line.LAT_OldValue__c = acc.OwnerId;
		line.LAT_Header__c = header.Id;
		line.LAT_NewValue__c = UserInfo.getUserId();

		insert line;

		header.lat_status__c = 'Execution';
    	update header;

    	line.LAT_NewValue__c = UserInfo.getUserId();
    	update line;
	}	
}