@isTest
private class ESN_MB_Rest_DAM_Batch_Test {

    private static void init() {
        ESN_MB_NodePage__c  brand1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandForDam('brand1', 'brand1_id', 'Enable', true);
        brand1.ESN_MB_Brand_LastImportAssetsDate__c = Datetime.now();
        update brand1;

        ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandForDam('brand2', 'brand2_id', 'Disable', true);

        // Disabled brand should not be deleted
        ESN_MB_Asset__c assetDisabledBrand = createAsset('123456704', 'brand2_id', true, true, false);

        // Assets with enabled brand but Not MyBrands/Published/Expiry should be deleted
        ESN_MB_Asset__c assetNotMyBrands = createAsset('123456706', 'brand1_id', true, false, false);
        ESN_MB_Asset__c assetNotPublished = createAsset('123456707', 'brand1_id', false, true, false);
        ESN_MB_Asset__c assetExpiry = createAsset('123456708', 'brand1_id', true, true, true);
    }

    /*static testMethod void executeWithNoParameterTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch());
       // Database.BatchableContext batchCtx = new Database.BatchableContext();
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch();
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }*/
/*
    static testMethod void executeWithRangeTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch(0, 0));
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(0, 0);
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }
*/

/*    static testMethod void executeByLastModifiedTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch(Date.today().addDays(-1), Date.today()));
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(Date.today().addDays(-1), Date.today());
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }*/

    static testMethod void executeByBrandIdTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch('brandId'));
        ESN_MB_Rest_DAM_BatchParams params = new ESN_MB_Rest_DAM_BatchParams('brand1_id');
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(params);
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets + 1 asset not tagged MyBrands Public Library
    }

    static testMethod void executeByBrandIdWithAllParametersTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch('brandId'));
        ESN_MB_Rest_DAM_BatchParams params = new ESN_MB_Rest_DAM_BatchParams(0, 0, 'brand1_id', null, null,null, null);
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(params);
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets + 1 asset not tagged MyBrands Public Library
    }

/*    static testMethod void executeByLastModifiedWithRangeTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch(0, 0, Date.today().addDays(-1), Date.today()));
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(0, 0, Date.today().addDays(-1), Date.today());
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }*/

/*    static testMethod void executeByBrandIdAndLastModifiedTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch(0, 0, Date.today().addDays(-1), Date.today()));
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch('brand1_id', Date.today().addDays(-1), Date.today());
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }

    static testMethod void executeByBrandIdAndLastModifiedWithRangeTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch(0, 0, Date.today().addDays(-1), Date.today()));
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(0, 0, 'brand1_id', Datetime.now().addDays(-1), Datetime.now());
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }

    static testMethod void executeByBrandIdWithRangeTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch(0, 0, 'brandId'));
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch(0, 0, 'brand1_id');
        batch.start(null);
        batch.execute(null, null);
        batch.finish(null);

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3+1, assetResultList.size()); // 1 asset with disabled brand upsert + 3 new Assets
    }*/

    /*static testMethod void updateLastModifiedDateExceptInitTest() {
        init();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Test method
//        ID batchprocessid = Database.executeBatch(new ESN_MB_Rest_DAM_Batch());
       // Database.BatchableContext batchCtx = new Database.BatchableContext();
        ESN_MB_Rest_DAM_Batch batch = new ESN_MB_Rest_DAM_Batch();
        batch.start(null);
        batch.updateLastModifiedDateExceptInit();

        Test.stopTest();

        // Test method
        ESN_MB_NodePage__c result = [SELECT ESN_MB_Brand_LastImportAssetsDate__c from ESN_MB_NodePage__c where RecordType.DeveloperName='ESN_MB_Brand' and Name = 'brand1' LIMIT 1];
        System.assert(result.ESN_MB_Brand_LastImportAssetsDate__c != null);
    }*/

    /**
     * HTTP mock
     **/
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();

            if (ESN_MB_Rest_Api_Callout.ENDPOINT_AUTH.equals(req.getEndPoint())) {
                // Authentification webservice
                res.setStatus('Created');
                res.setStatusCode(201);
                res.setHeader('Set-Cookie', 
                    'JSESSIONID=6E6E91CE0B7A5F2E6CE87D17DF05B5A5; Path=/; Secure; HttpOnly');
                res.setBody('{"id":"307","profileId":"1147","username":"test@northplains.com","fullName":"test user","email":"test@northplains.com"}');
            } else {
                String responseJson = '['
                    + '{"id":"123456701","name":"Test Asset1", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456702","name":"Test Asset2", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456703","name":"Test Asset3", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456704","name":"DISABLED BRAND", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand2_id') + ']}},'
                    + '{"id":"123456705","name":"UNKNOWN BRAND", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brandUnknown_id') + ']}},'
                    + '{"id":"123456706","name":"NOT MYBRANDS", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'Internal Use Only') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456707","name":"ENABLED BRAND - ARCHIVED ASSET", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Archived","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456708","name":"EXPIRATION-DATE", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"30.11.2010","usage_rights_type":"None","expiry-date-required":"required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}}'
                    + ']';
                res.setStatus('OK');
                res.setStatusCode(200);
                res.setBody(responseJson);
                res.setHeader('Content-Range', '0-7/8');
            }
            return res;
        }

        private String buildTaxonomy(String name, String value) {
            // buildTaxonomy('Permissions', 'MyBrands Public Library');
            // buildTaxonomy('Brands', 'brand_id');
           // return '{"id":"795","name":"' + name + '","localisedName":"' + name + '","description":"' + name + '","path":"/Taxonomy/' + name + '","categories":[{"id":"1022","name":"' + value + '","localisedName":"' + name + '","description":"' + name + '","path":"/Taxonomy/Permissions/ + ' + name + '","categories":[]}]}';
            return '{"id":"795","name":"' + name + '","localisedName":"' + name + '","description":"' + name + '","path":"/Taxonomy/' + name + '","categories":[{"id":"1117","name":"' + value + '","localisedName":"' + value + '","description":"' + value + '","path":"/Taxonomy/' + name + '/' + value + '","categories":[]}]}';
        }
    }

    private static ESN_MB_Asset__c createAsset(String damId, String brandId, Boolean isPublished, Boolean isMyBrands, Boolean isExpiry) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();//
        asset.ESN_MB_DAMID__c = damId;
        asset.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        asset.ESN_MB_Taxonomy_Brands__c = brandId;

        String status = 'Archived';
        if (isPublished) {
            status = 'Published';
        }
        asset.ESN_MB_Workflow_status__c = status;
        
        String permission = 'Internal Use Only';
        if (isMyBrands) {
            permission = 'MyBrands Public Library';
        }
        asset.ESN_MB_Taxonomy_Permissions__c = permission;

        String expiryDate = '';
        if (isExpiry) {
            asset.ESN_MB_expiry_date__c = Date.today().addDays(-30);
        }
        asset.ESN_MB_expiry_date_required__c = isExpiry;

        Database.SaveResult result = Database.insert(asset);    
        return asset;
    }
}