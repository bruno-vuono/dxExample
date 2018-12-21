@isTest
public with sharing class EUR_CRM_TerritoryOwnerChangeTest {

    public static testMethod void Test1NGTerritory() {
        User testUser = new User();
        System.runAs (new User(Id = UserInfo.getUserId())) {
            // Prepare data: EUR Account, Territory, region and user
            testUser.Username = 'testUserNG111@company.com';
            testUser.Email = 'testuser111@company.com';
            testUser.Lastname = 'user';
            testUser.Firstname = 'test';
            testUser.Alias = 'test';
            testUser.CommunityNickname = '12346';
            testUser.ProfileId = UserInfo.getProfileId();
            //testUser.CurrencyIsoCode = 'USD';
            testUser.TimeZoneSidKey = 'GMT';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.UserPermissionsMobileUser = false;
            System.debug (JSON.serializePretty(testUser));
            insert testUser;
        }

        EUR_CRM_Region__c regionTest = new EUR_CRM_Region__c();
        regionTest.name = 'Region 1';
        regionTest.EUR_CRM_Region_Code__c = 'R1';
        insert regionTest;

        EUR_CRM_Territory__c territoryTest = new EUR_CRM_Territory__c();
        Id territoryNGId;
        List<Recordtype> territoryTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Territory__c');
        for (Recordtype rt : territoryTypes) {
            if (rt.DeveloperName == 'EUR_CRM_NG_Territory')
                territoryNGId = rt.Id;
        }
        territoryTest.name = 'Territory 1';
        territoryTest.EUR_CRM_Region__c = regionTest.id;
        territoryTest.RecordTypeId = territoryNGId;
        territoryTest.EUR_CRM_Territory_Code__c = 'T12';
        insert territoryTest;

        EUR_CRM_Account__c testAccount = new EUR_CRM_Account__c();
        testAccount.name = 'Test account';
        testAccount.EUR_CRM_Status__c = 'Active';
        testAccount.EUR_CRM_Territory__c = territoryTest.id;
        testAccount.EUR_CRM_Priority__c = 'A';
        testAccount.EUR_CRM_Channel__c = 'ON TRADE';
//      testAccount.EUR_CRM_Sub_Channel__c = 'ON_STD';
        insert testAccount;

        test.startTest();

        // When no update needed
        PageReference pageRef = new PageReference('/apex/EUR_CRM_JB_AdminConsole');
        Test.setCurrentPageReference(pageRef);
        EUR_CRM_TerritoryOwner_UpdateController testTerritoryCon = new EUR_CRM_TerritoryOwner_UpdateController();
        testTerritoryCon.executeMassAccountOwnerUpdate();

        territoryTest.EUR_CRM_Territory_Owner__c = testUser.id;
        update territoryTest;

        // When account update owner needed
        testTerritoryCon.executeMassAccountOwnerUpdate();

        test.stopTest();

    }

    public static testMethod void Test2FITerritory() {
        User testUser = new User();
        System.runAs (new User(Id = UserInfo.getUserId())) {
            // Prepare data: EUR Account, Territory, region and user
            testUser.Username = 'testUserFI111@company.com';
            testUser.Email = 'testuser111@company.com';
            testUser.Lastname = 'user';
            testUser.Firstname = 'test';
            testUser.Alias = 'test';
            testUser.CommunityNickname = '12346';
            testUser.ProfileId = UserInfo.getProfileId();
            //testUser.CurrencyIsoCode = 'USD';
            testUser.TimeZoneSidKey = 'GMT';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.UserPermissionsMobileUser = false;
            System.debug (JSON.serializePretty(testUser));
            insert testUser;
        }

        EUR_CRM_Region__c regionTest = new EUR_CRM_Region__c();
        regionTest.name = 'Region 1';
        regionTest.EUR_CRM_Region_Code__c = 'R1';
        insert regionTest;

        EUR_CRM_Territory__c territoryTest = new EUR_CRM_Territory__c();
        Id territoryNGId;
        List<Recordtype> territoryTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Territory__c');
        for (Recordtype rt : territoryTypes) {
            if (rt.DeveloperName == 'EUR_FI_Territory')
                territoryNGId = rt.Id;
        }
        territoryTest.name = 'Territory 1';
        territoryTest.EUR_CRM_Region__c = regionTest.id;
        territoryTest.RecordTypeId = territoryNGId;
        territoryTest.EUR_CRM_Territory_Code__c = 'T12';
        insert territoryTest;

        EUR_CRM_Account__c testAccount = new EUR_CRM_Account__c();
        testAccount.name = 'Test account';
        testAccount.EUR_CRM_Status__c = 'Active';
        testAccount.EUR_CRM_Territory__c = territoryTest.id;
        testAccount.EUR_CRM_Priority__c = 'A';
        testAccount.EUR_CRM_Channel__c = 'ON TRADE';
//      testAccount.EUR_CRM_Sub_Channel__c = 'ON_STD';
        insert testAccount;

        test.startTest();

        // When no update needed
        PageReference pageRef = new PageReference('/apex/EUR_CRM_JB_AdminConsole');
        Test.setCurrentPageReference(pageRef);
        EUR_CRM_TerritoryOwner_UpdateController testTerritoryCon = new EUR_CRM_TerritoryOwner_UpdateController();
        testTerritoryCon.executeMassAccountOwnerUpdate();

        territoryTest.EUR_CRM_Territory_Owner__c = testUser.id;
        update territoryTest;

        // When account update owner needed
        testTerritoryCon.executeMassAccountOwnerUpdate();

        test.stopTest();

    }

    @IsTest
    static void test3DETerritory() {
        Integer accountsQty = 3;
        EUR_CRM_Account__c testAccount;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'EUR DE OFF Trade User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name = 'EUR DE BZL South'];
        RecordType territoryRt = [SELECT Id FROM RecordType WHERE Name = 'DE Territory' AND SobjectType = 'EUR_CRM_Territory__c'];
        RecordType accountRt = [SELECT Id FROM RecordType WHERE DeveloperName = 'EUR_DE_OFF_STD'];
        List<User> users = new List<User>();
        User u = new User(
                Alias = 'standt',
                Email = 'userEmail1234aoke@test.com',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                userroleid = r.id,
                LastName = 'User',
                ProfileId = p.Id,
                UserName = 'testUser7749374397@ctdev.io',
                TimeZoneSidKey = 'America/Los_Angeles',
                BypassTriggers__c = 'Autofollow_User_InsertUpdate;AutoJoin_User_InsertUpdate;ESN_User_AutojoinByAffiliates;ChatterEmailSettings');
        users.add(u);
        User u2 = new User(
                Alias = 'standt',
                Email = 'userEmail@test.com',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                userroleid = r.id,
                LastName = 'User2',
                ProfileId = p.Id,
                UserName = 'testUser7749374398@ctdev.io',
                TimeZoneSidKey = 'America/Los_Angeles',
                BypassTriggers__c = 'Autofollow_User_InsertUpdate;AutoJoin_User_InsertUpdate;ESN_User_AutojoinByAffiliates;ChatterEmailSettings');
        users.add(u2);
        insert users;
        System.runAs(users[0]) {
            EUR_CRM_Region__c regionTest = new EUR_CRM_Region__c();
            regionTest.name = 'Region 1';
            regionTest.EUR_CRM_Region_Code__c = 'R1';
            insert regionTest;
            EUR_CRM_Territory__c territoryTest = new EUR_CRM_Territory__c(
                    RecordTypeId = territoryRt.Id,
                    Name = 'test territory',
                    EUR_CRM_Territory_Owner__c = users[0].Id,
                    EUR_CRM_Region__c = regionTest.Id);
            insert territoryTest;
            EUR_CRM_Postal_Code_Territory_Mapping__c postalmapping = EUR_CRM_DE_TestClassUtilityHelper.createPostalCodeMapping('postalmap', '12345', territoryTest.id, EUR_CRM_DE_TestClassUtilityHelper.DE_POSTAL_CODE_MAPPING_RECORD_TYPE);

            createAccounts(territoryTest.Id, accountRt.Id,accountsQty);
            test.startTest();
            territoryTest.EUR_CRM_Territory_Owner__c = users[1].Id;
            update territoryTest;
            Set<Id> territoryIds = new Set<Id>{territoryTest.Id};
            new EUR_CRM_TerritoryOwnerChanged().createMassUpdateBatch(territoryIds);
            test.stopTest();
        }

        System.assertEquals(accountsQty, [SELECT Id FROM EUR_CRM_Account__c WHERE OwnerId = :users[1].Id].size());
    }

    static void createAccounts(Id territoryId, Id accountRtId, Integer accountsQty) {
        List<EUR_CRM_Account__c> accounts = new List<EUR_CRM_Account__c>();
        for (Integer i = 0; i < accountsQty; i++) {
            accounts.add(new EUR_CRM_Account__c(
                    Name = 'test account' + i,
                    EUR_CRM_Territory__c = territoryId,
                    RecordTypeId = accountRtId,
                    EUR_CRM_Status__c = 'Active',
                    EUR_CRM_Postal_Code__c = '12345'
            ));
        }
        insert accounts;
    }
}