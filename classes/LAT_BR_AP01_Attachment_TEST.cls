/****************************************************
 Dev: Denis Aranda  Version: 1  Consulting: Valuenet
****************************************************/
@isTest
public with sharing class LAT_BR_AP01_Attachment_TEST {
    
    static testmethod void unitTest(){
        
        Account acc = new Account(
			RecordTypeId = Global_RecordTypeCache.getRtId('Account' + 'On_Trade'), 
			CNPJ__c = '54651716001150',
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
			Client_code_AN8__c = '123697',
			Billing_Country__c ='test'
		);
		insert acc;  
        
        Planejamento__c plan = new Planejamento__c(
            Name = 'Test', 
            M_s_de_Ref_rencia__c = 'Janeiro', 
            Ano_de_Referencia__c = '2013', 
            RecordTypeId = Global_RecordTypeCache.getRtId('Planejamento__c' + 'BRA_Standard')
        );
        insert plan;
        
        Visitas__c vis = new Visitas__c(
            Name = 'TEST', 
            Planejamento__c = plan.id, 
            Hora_da_Visita__c = '02:00', 
            Descrever_Motivo__c = 'Test', 
            Resumo_da_Visita__c = 'Test', 
            RecordTypeId = Global_RecordTypeCache.getRtId('Visitas__c' + 'BRA_Standard') 
        );
        insert vis;
        
        test.startTest();
        
        Blob b = Blob.valueOf('Test Data'); 
        
        Attachment attach = new Attachment(
            ParentId = vis.Id,
            Name = 'test',
            Body = b
        );  
          
        try{insert attach;} catch(exception e){} 
        
        try{delete attach;} catch(exception e){} 
        
        test.stopTest();    
        
    }
}