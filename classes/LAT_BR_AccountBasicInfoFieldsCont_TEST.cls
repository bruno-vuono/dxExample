@isTest
public class LAT_BR_AccountBasicInfoFieldsCont_TEST {
	
	static testMethod void unitTest(){
        
		LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
     		Name = 'AR_CANT_UPDATE_BASIC_INFO_FIELDS_PROF',
   			LAT_Value__c = 'LAT_AR2_Vendedor');
        insert cfg;
                
        Account acc = new Account(            
            Name = 'TEST',
        	AccountNumber = '1000', 
        	Status__c = 'Novo cadastro', 
        	Type = 'Payer', 
        	Phone = '11 1111-1111', 
        	Notes__c = 'TEST', 
        	AddressLine1_AR__c = 'TEST', 
        	CNPJ__c = '30641670223', 
        	Corporate_Name__c = 'TEST', 
        	Channel__c = 'WS', 
        	RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'ACC_1_OffTrade_ARG')
        );        
        insert acc;
                            
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);            
        LAT_BR_AccountBasicInfoFieldsCont testPage = new LAT_BR_AccountBasicInfoFieldsCont(sc);
        testPage.doEdit();
        testPage.updateAccount();
        testPage.doSave();
        testPage.doCancel();        
    }

	static testMethod void unitTest_LatAccountBefore(){
                
		LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
     		Name = 'AR_CANT_UPDATE_BASIC_INFO_FIELDS_PROF',
   			LAT_Value__c = 'LAT_AR2_Vendedor');
        insert cfg;
        
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
            LAT_MX_FiscalEntityType__c = 'Individual',
            SaveDuplicatedFiscalID_AR__c = true,
            Client_code_AN8__c = '100',
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade')
        );        
        insert acc;
                            
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);            
        LAT_BR_AccountBasicInfoFieldsCont testPage = new LAT_BR_AccountBasicInfoFieldsCont(sc);
        testPage.doEdit();
        testPage.updateAccount();
        testPage.doSave();
        testPage.doCancel();        
    }
    
	static testMethod void unitTest_LatAccountBefore2(){
                
		LAT_GeneralConfig__c cfg = new LAT_GeneralConfig__c(
     		Name = 'AR_CANT_UPDATE_BASIC_INFO_FIELDS_PROF',
   			LAT_Value__c = 'LAT_AR2_Vendedor');
        insert cfg;
        
        Account acc = new Account(            
            RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'Off_Trade'), 
            CNPJ__c = '58815921000192',
            Name = 'testAccount',
            Overdue__c = false,
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
            Billing_Country__c ='test',
            Status__c = 'Em análise - Crédito e Cobrança'
        );        
        insert acc;
                            
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);            
        LAT_BR_AccountBasicInfoFieldsCont testPage = new LAT_BR_AccountBasicInfoFieldsCont(sc);
        testPage.doEdit();
        testPage.updateAccount();
        testPage.doSave();
        testPage.doCancel();        
    }
}