/*****************************************************************************************************************************************
*                                         Company: ValueNet                                      										 *
*----------------------------------------------------------------------------------------------------------------------------------------*
*           Test del controlador "LAT_VFC04_AccountAdicionalFields" de la Visualforce page LAT_VFP04_AccountAdicionalFields          *
*****************************************************************************************************************************************/

@IsTest
public with sharing class LAT_VFC04_AccountAdicionalFields_TEST {
	static testMethod void unitTest(){
		
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
            LAT_MX_FiscalEntityType__c = 'Individual',
            RecordTypeId = rtOffMX
        );
        insert acc;
		
		ApexPages.StandardController controller = new ApexPages.StandardController(acc);
		LAT_VFC04_AccountAdicionalFields testPage = new LAT_VFC04_AccountAdicionalFields(controller);
		testPage.doEdit();
		testPage.doSave();
		testPage.doCancel();
	}
}