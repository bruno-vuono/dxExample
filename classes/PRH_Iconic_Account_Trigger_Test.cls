@isTest(SeeAllData=true) 
public class PRH_Iconic_Account_Trigger_Test{
    
    /*public static testMethod void testTrigger() {
        //ID rtID = Global_RecordTypeCache.getRtID('Account'+'ASI_HK_CRM_Potential_Account');
        ID rtID = Global_RecordTypeCache.getRtID('Account'+'On_Trade');
        //Account testAcc = new Account();
        //testAcc.Name = 'Test 1';
        //testAcc.RecordTypeID = rtID;
        //insert testAcc;
        List<PRH_Luxury_Accounts__c> iconicAccounts = new List<PRH_Luxury_Accounts__c>();
        PRH_Luxury_Accounts__c acc;

        DateTime dt = DateTime.now(); 
        String dateTimeStr = dt.format('YYMMDD_hhmmss'); 
        Profile adminp = [select id from profile where Name = 'System Administrator' limit 1];    
        System.debug('dateTimeStr : '+ dateTimeStr);

        Account testAcc2 = new Account();
        testAcc2.RecordTypeID = rtID;
        testAcc2.Name = 'Test 2';
        testAcc2.PRH_Iconic_Account__c = true;
        
        insert testAcc2;
        
        // Creation of 5 users (iconic account's owners)
        Profile p = [SELECT Id FROM Profile WHERE Name='PRH_Iconic_Platform']; 
        User u1 = new User(Alias = 'user1', Email='PRH_testuser1'+dateTimeStr+'@prhtestorg.com', 
                            EmailEncodingKey='UTF-8', LastName='TestingUser1', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='PRH_testuser1'+dateTimeStr+'@prhtestorg.com');
        insert u1;

        User ic_myUser = [SELECT Id FROM User WHERE Email LIKE 'PRH_testuser1%prhtestorg.com' LIMIT 1];
        System.runAs(ic_myUser) {   
            //System.Test.startTest();
           
            PRH_Brand_Luxury_Brand__c ib1 = new PRH_Brand_Luxury_Brand__c();
            ib1.Name = 'Martell XO';
            ib1.PRH_Competitor_Brand__c = false;
            ib1.PRH_Sequence__c = 'LCEB9981';
            ib1.PRH_Active__c = true;
            ib1.recordTypeId = Schema.SObjectType.PRH_Brand_Luxury_Brand__c.getRecordTypeInfosByName().get('Luxury Account - Pernod').getRecordTypeId();
            insert ib1;

            // Creation of the Iconic Accounts
            for (Integer i=0; i < 6; i++) { 
                if (i < 3) {
                    acc = new PRH_Luxury_Accounts__c(
                        Name = 'Fraccount-'+i,
                        PRH_High_Networth_Individuals__c = false,
                        PRH_Suppress_and_archive__c = false,
                        PRH_Account_Region__c = 'PR LATAM'
                    );
                    iconicAccounts.add(acc); 
                } else {
                    acc = new PRH_Luxury_Accounts__c(
                        Name = 'Zoo-'+i,
                        PRH_High_Networth_Individuals__c = false,
                        PRH_Suppress_and_archive__c = false
                        //PRH_Number_of_Pernod_Ricard_products__c = 1
                    );
                    iconicAccounts.add(acc); 
                }
            }   
            insert iconicAccounts;
        }

            ApexPages.StandardController sc = new ApexPages.standardController(testAcc2);
            PageReference pageRef = new PageReference('/apex/PRH_Acc_Luxury_Account?id=' + testAcc2.Id);
            Test.setCurrentPageReference(pageRef);
            PRH_Acc_Luxury_Account_Controller testObjCON = new PRH_Acc_Luxury_Account_Controller(sc);
            
            //testAcc2.PRH_Iconic_Account__c = false;
            //update testAcc2;
            //delete testAcc;
            //delete testAcc2; 

            //System.Test.stopTest(); 
    }*/
    
    public static testMethod void testTriggerBrazil() {
        ID rtID = Global_RecordTypeCache.getRtID('Account'+'On_Trade');
        Account testAcc = new Account();
        testAcc.Name = 'Test 1';
        testAcc.RecordTypeID = rtID;
        testAcc.Segmentation_Type_on_trade__c ='Bar Agitado';
        testAcc.Revenue_Address__c = 'TEST ADD';
        testAcc.PRH_Iconic_Account__c = true;
        insert testAcc;
    }
    
    public static testMethod void testTriggerBrazil2() {
        ID rtID = Global_RecordTypeCache.getRtID('Account'+'On_Trade');
        Account testAcc = new Account();
        testAcc.Name = 'Test 1';
        testAcc.RecordTypeID = rtID;
        testAcc.Segmentation_Type_on_trade__c ='Bar';
        testAcc.Revenue_Address__c = 'TEST ADD';
        testAcc.PRH_Iconic_Account__c = true;
        insert testAcc;
   
    }
    public static testMethod void testTriggerUSA() {
        ID rtID = Global_RecordTypeCache.getRtID('Account'+'USA_Account');
        Account testAcc = new Account();
        testAcc.Name = 'Test 1';
        testAcc.RecordTypeID = rtID;
        testAcc.BillingStreet = 'Test Street';
        testAcc.BillingCity = 'Test';
        testAcc.BillingState = 'Test';
        testAcc.BillingState = 'Test';
        testAcc.BillingPostalCode = 'TEST ADD';
        testAcc.BillingCountry = 'TEST ADD';
        testAcc.PRH_Iconic_Account__c = true;
        insert testAcc;
   
    }
     public static testMethod void testTriggerUSA2() {
        ID rtID = Global_RecordTypeCache.getRtID('Account'+'USA_Account');
        Account testAcc = new Account();
        testAcc.Name = 'Test 1';
        testAcc.RecordTypeID = rtID;

        testAcc.BillingCity = 'Test';
        testAcc.BillingState = 'Test';
        testAcc.BillingPostalCode = 'TEST ADD';
        testAcc.BillingCountry = 'TEST ADD';
        testAcc.PRH_Iconic_Account__c = true;
        insert testAcc;
   
    } 
    
    public static testMethod void testTrigger2() {

        ID rtIDEu = Global_RecordTypeCache.getRtID('EUR_CRM_Account__c'+'EUR_GB_FS_Indirect');
        
        EUR_CRM_Account__c testEUAcc = new EUR_CRM_Account__c(Name = 'Test', recordTypeID = rtIDEu );
        insert testEUAcc;
        Test.startTest();
        testEUAcc.EUR_CRM_Force_Iconic_Account__c = true;
        update testEUAcc;
        
        Test.stopTest(); 
    }
    
    public static testMethod void testTrigger3() {
         ID rtIDEu = Global_RecordTypeCache.getRtID('EUR_CRM_Account__c'+'EUR_GB_FS_Indirect');
        
        EUR_CRM_Account__c testEUAcc2 = new EUR_CRM_Account__c(Name = 'Test', recordTypeID = rtIDEu,EUR_CRM_Force_Iconic_Account__c = true);       
        insert testEUAcc2;
        
        // GDT TO AVOID ERRORS delete testEUAcc2;
       
        
        
    }
    /*
    AUG 10, 2015 - updated.
    */
    public static testMethod void testTrigger4() {
        ID rtIDEu = Global_RecordTypeCache.getRtID('EUR_CRM_Account__c'+'EUR_GB_FS_Indirect');
        ID rtIDEu2 = Global_RecordTypeCache.getRtID('EUR_CRM_Account__c'+'EUR_EE_DIR_ON_Trade');
        final String dtimestamp = '' + system.now();
        String accountName1 = 'Test GB Account' + dtimestamp;
        String accountName2 = 'Test EE Account' + dtimestamp;
        List<EUR_CRM_Account__c> toInsert = new List<EUR_CRM_Account__c>();
        EUR_CRM_Account__c testEUAcc1 = new EUR_CRM_Account__c(Name = accountName1, recordTypeID = rtIDEu,EUR_CRM_Force_Iconic_Account__c = true);       
        toInsert.add(testEUAcc1);
        EUR_CRM_Account__c testEUAcc2 = new EUR_CRM_Account__c(EUR_CRM_Postal_Code__c = '12345', Name = accountName2, recordTypeID = rtIDEu2,EUR_CRM_Force_Iconic_Account__c = true);       
        toInsert.add(testEUAcc2);
        insert toInsert;
        /*PRH_Luxury_Accounts__c iconicAccount = [select id from PRH_Luxury_Accounts__c where name =: accountName1 limit 1];
        system.assert(iconicAccount!= null);     
        List<PRH_Luxury_Accounts__c> iconicAccount2 = [select id from PRH_Luxury_Accounts__c where name =: accountName2 ];
        system.assert(iconicAccount2 == null || iconicAccount2.size() == 0);    */ 
    }
    
    
}