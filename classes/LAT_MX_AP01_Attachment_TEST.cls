/******************************************************************************
*   Company:Valuenet    Developers:Elena Schwarzböck       Date:09/10/2013    *
*******************************************************************************/

@istest
public with sharing class LAT_MX_AP01_Attachment_TEST {

   static testMethod void unitTest() {

        String rtOffMX = Global_RecordTypeCache.getRtId('Account' + 'LAT_MX_ACC_OffTrade');
        
        Account acc = new Account(
            Name = 'TEST',
            AccountNumber = '1000', 
            Type = 'Payer',
            Phone = '1-11-1111-1111',
            Fax = '11-1111-1111',
            Notes__c = 'TEST',
            AddressLine1_AR__c = 'TEST',
            CNPJ__c = 'LOZM701213E52',
            Corporate_Name__c = 'TEST',
            Channel__c = 'WS',
            Segmentation_Type_on_trade__c = 'MOP',
            RecordTypeId = rtOffMX
        );
        try{insert acc;} catch(exception e){}
        
        LAT_MX_CS001_AccountDocuments__c cs001a = new LAT_MX_CS001_AccountDocuments__c(
            Name = 'Form01',
            LAT_MX_RequiredForChannel__c = '"WS"',
            LAT_MX_TextToShow__c = 'Test Missing'
        );
        
        try{insert cs001a;} catch(exception e){}
        
        LAT_MX_CS001_AccountDocuments__c cs001b = new LAT_MX_CS001_AccountDocuments__c(
            Name = 'Form02',
            LAT_MX_RequiredForChannel__c = '"WS"',
            LAT_MX_TextToShow__c = 'Test Missing'
        );
        
        try{insert cs001b;} catch(exception e){}
        
        test.startTest();

        Blob b = Blob.valueOf('Test Data');  
          
        Attachment attach = new Attachment(
            ParentId = acc.Id,
            Name = 'Form01-test',
            Body = b
        );  
          
        try{insert attach;} catch(exception e){}    
        
        Attachment attach1 = new Attachment(
            ParentId = acc.Id,
            Name = 'Form02-test',
            Body = b
        );  
          
        try{insert attach1;} catch(exception e){} 

        test.stopTest(); 
        
   }
}