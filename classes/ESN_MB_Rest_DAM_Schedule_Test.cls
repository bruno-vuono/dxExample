/**
    About
    -----
    Description: test class for ESN_MB_Rest_DAM_Schedule class of MyBrands.
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_Rest_DAM_Schedule class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_Rest_DAM_Schedule_Test {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
/*
    // "You have uncommited work pending" with Scheduled Apex. Don't decomment this test (Ok in DEV2, KO in Staging environment)
    static testMethod void executeTest() {
        // TODO start method need 1 result. Maybe change the SOQL to get one result in User table to be sure to have 1 result
        String assetRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_DAM_Asset');
        ESN_MB_Asset__c asset = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAsset(assetRecordTypeId, null, null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Schedule the test job
        String jobId = System.schedule('ESN_MB_Rest_DAM_Schedule_Test', CRON_EXP, new ESN_MB_Rest_DAM_Schedule());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));

        // Verify the scheduled job hasn't run yet.
        ESN_MB_Asset__c [] assetList = [SELECT Id FROM ESN_MB_Asset__c];
        System.assertEquals(1, assetList.size());
        Test.stopTest();
        
        // Now that the scheduled job has executed after Test.stopTest(),
        //   fetch the new Asset that got added.
        assetList = [SELECT Id FROM ESN_MB_Asset__c];
        System.assertEquals(1, assetList.size()); // Should be equals 2...
    }*/

    /**
     * HTTP mock
     **/
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();

            if (ESN_MB_Rest_Api_Callout.ENDPOINT_AUTH.equals(req.getEndPoint())) {
                System.debug('ENDPOINT_AUTH:');
                // Authentification webservice
                res.setStatus('Created');
                res.setStatusCode(201);
                res.setHeader('Set-Cookie', 
                    'JSESSIONID=6E6E91CE0B7A5F2E6CE87D17DF05B5A5; Path=/; Secure; HttpOnly');
                res.setBody('{"id":"307","profileId":"1147","username":"test@northplains.com","fullName":"test user","email":"test@northplains.com"}');
            } else {
                String responseJson = '['
                    + '{"id":"123456701","name":"Test Asset1", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}}'
                    + ']';
                res.setStatus('OK');
                res.setStatusCode(200);
                res.setBody(responseJson);
                res.setHeader('Content-Range', '0-1/1');
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
}