@isTest
private class ESN_MB_Rest_Api_Callout_Test {

    private static String ASSET_ID_DUMMY = '123456789';

    static testMethod void postAuthTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        List<String> sessionList = ESN_MB_Rest_Api_Callout.postAuth();
        Test.stopTest();

        String jSessionId = sessionList[0];
        String token = sessionList[1];

        System.assertEquals('6E6E91CE0B7A5F2E6CE87D17DF05B5A5', jSessionId);
        System.assertEquals('D=6E6E91CE0B7A5F2E6CE87D17DF05B5A5', token);
    }

    static testMethod void getAssetsCountTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        Integer result = ESN_MB_Rest_Api_Callout.getAssetsCount(null, Datetime.newInstance(2014, 09, 10, 0, 0, 0), Datetime.newInstance(2014, 09, 11, 0, 0, 0), null);

        Test.stopTest();

        System.assertEquals(7, result);
    }

    static testMethod void postAssetsByIdTest() {
        // Init test
        ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandForDam('brand1', 'brand1_id', 'Enable', true);

        ESN_MB_Asset__c asset = new ESN_MB_Asset__c(Name = 'Jameson Bottle Test', ESN_MB_DAMId__c = ASSET_ID_DUMMY);
        insert asset;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        ESN_MB_Rest_Api_Callout.postAssetsById(ASSET_ID_DUMMY);

        Test.stopTest();

        // Test method
        ESN_MB_Asset__c assetResult = [SELECT Name, ESN_MB_DAMId__c, ESN_MB_creationDate__c, 
            ESN_MB_Taxonomy_BrandVariant__c, ESN_MB_Taxonomy_BrandMaterials__c 
            FROM ESN_MB_Asset__c WHERE ESN_MB_DAMId__c = :ASSET_ID_DUMMY];

        System.assertEquals(ASSET_ID_DUMMY, assetResult.ESN_MB_DAMId__c);
        System.assertEquals('Jameson Bottle Test', assetResult.Name);
        System.assertEquals(Date.newinstance(2014, 9, 11), assetResult.ESN_MB_creationDate__c);
        System.assertEquals('Jameson/Jameson Original', assetResult.ESN_MB_Taxonomy_BrandVariant__c);
        System.assertEquals('Photography/Pack Shots/Bottle/Gift', assetResult.ESN_MB_Taxonomy_BrandMaterials__c);        
    }
   
    static testMethod void getAssetsTest() {
        ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandForDam('brand1', 'brand1_id', 'Enable', true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        List<String> sessionList = ESN_MB_Rest_Api_Callout.postAuth();

        List<List<ESN_MB_Asset__c>> assetResultList = ESN_MB_Rest_Api_Callout.getAssets(0, 5, null,
                    Datetime.newInstance(2014, 09, 10, 0, 0, 0), Datetime.newInstance(2014, 09, 11, 0, 0, 0), sessionList);

        Test.stopTest();

        // Test method
        //List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(2, assetResultList.size()); // 1 for update / 1 for delete
        System.assertEquals(4, assetResultList.get(0).size()); // 3 assets updated in the first list + 1 asset not tagged MyBrands Public Library
    }

/*    static testMethod void postAssetsWithRangeCategoryTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        ESN_MB_Rest_Api_Callout.postAssets('0-2', 'pernod_ricard_client_jameson');

        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(3, assetResultList.size());
    }*/

    static testMethod void getAssetsByCategoryTest() {
        ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrandForDam('brand1', 'brand1_id', 'Enable', true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        List<String> sessionList = ESN_MB_Rest_Api_Callout.postAuth();

        List<List<ESN_MB_Asset__c>> assetResultList = ESN_MB_Rest_Api_Callout.getAssets(0, 3, 'pernod_ricard_client_jameson', null, null, sessionList);

        Test.stopTest();

        // Test method
        //List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(2, assetResultList.size()); // 1 for update / 1 for delete
        System.assertEquals(4, assetResultList.get(0).size()); // 3 assets updated in the first list + 1 asset not tagged MyBrands Public Library
    }
/*
    static testMethod void deleteOldAssetsTest() {

        List<ESN_MB_Asset__c> assetList = new List<ESN_MB_Asset__c>();
        // Add assets to delete
        assetList.add(buildAsset('assetToDelete1', Date.today().addDays(-5), true, true));
        assetList.add(buildAsset('assetToDelete2', Date.today().addDays(5), false, true));
//        assetList.add(buildAsset('assetToDelete3', Date.today().addDays(5), true, false));

        // Add assets to not delete
        assetList.add(buildAsset('assetToKeep1', Date.today().addDays(5), true, true));

        insert assetList;

        // Test method
        Test.startTest();
        ESN_MB_Rest_Api_Callout.deleteOldAssets(assetList);
        Test.stopTest();

        // Test method
        List<ESN_MB_Asset__c> assetResultList = [SELECT Name, ESN_MB_DAMId__c FROM ESN_MB_Asset__c];
        System.assertEquals(1, assetResultList.size());
        System.assertEquals('assetToKeep1', assetResultList.get(0).Name);
    }*/

    static testMethod void ESN_MB_JSONAsset2ApexTest() {
        new ESN_MB_JSONAsset2Apex();
        new ESN_MB_JSONAsset2Apex.ImageInformation();
        new ESN_MB_JSONAsset2Apex.BamArticleFull();
        new ESN_MB_JSONAsset2Apex.Metadata();
        new ESN_MB_JSONAsset2Apex.OriginalFile();
        new ESN_MB_JSONAsset2Apex.Storyboard();
        new ESN_MB_JSONAsset2Apex.Rating();
        new ESN_MB_JSONAsset2Apex.FileInfo();
        new ESN_MB_JSONAsset2Apex.DerivedFiles();
        new ESN_MB_JSONAsset2Apex.Category();
        new ESN_MB_JSONAsset2Apex.Taxonomy();
    }

    private static ESN_MB_Asset__c buildAsset(String name, Date expiryDate, Boolean isMyBrandsLibrary, Boolean isPublishedAsset) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();

        asset.Name = name;
        if (isMyBrandsLibrary) {
            asset.ESN_MB_Taxonomy_Permissions__c = 'MyBrands Library';
        }

        if (expiryDate != null) {
            asset.ESN_MB_expiry_date_required__c = true;
            asset.ESN_MB_expiry_date__c = expiryDate;
        }

        if (isPublishedAsset) {
            asset.ESN_MB_workflow_status__c = 'Published';
        } else {
            asset.ESN_MB_workflow_status__c = 'Archieved';
        }

        return asset;
    }

    /**
     * HTTP mock
     **/
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('HTTPRequest req:' + req);
            System.debug('Endpoint:' + req.getEndPoint());
            if (ESN_MB_Rest_Api_Callout.ENDPOINT_AUTH.equals(req.getEndPoint())) {
                // Authentification webservice
                res.setStatus('Created');
                res.setStatusCode(201);
                res.setHeader('Set-Cookie', 
                    'JSESSIONID=6E6E91CE0B7A5F2E6CE87D17DF05B5A5; Path=/; Secure; HttpOnly');
                res.setBody('{"id":"307","profileId":"1147","username":"test@northplains.com","fullName":"test user","email":"test@northplains.com"}');
            } else if ((ESN_MB_Rest_Api_Callout.ENDPOINT_ASSETS + ASSET_ID_DUMMY).equals(req.getEndPoint())) {
                // Get one asset
                String responseJson = '{"id":"' + ASSET_ID_DUMMY + '","creationDate":"11.09.2014 17:55","modificationDate":"15.09.2014 11:30","version":"7","collectionSchema":"6","name":"Jameson Bottle Test","description":"Jameson Bottle and Single Bottle Canister","locale":"en","keywords":"","metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","photographer_credit":"","sku":"","usage_rights_type":"None","expiry-date-required":"not-required","legacy-import-information":""},"fileInfo":{"name":"JAMESON Bottle & Canister21.jpg","mimeType":"image/jpeg","size":"487936","prettySize":"476 KB","md5":"810a687c1522645b7ce60eccafcdf117"},"rating":{"count":0,"sum":0,"average":0},' +
                    '"taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Brands', 'brand1_id') + ',{"id":"273","name":"Marketing Activity","localisedName":"Marketing Activity","description":"Select the marketing activity that the asset has been created for","path":"/Taxonomy/Marketing Activity","categories":[{"id":"275","name":"Branding","localisedName":"Branding","description":"Branding","path":"/Taxonomy/Marketing Activity/Branding","categories":[]}]},{"id":"331","name":"Market Suitability","localisedName":"Market Suitability","description":"Market Suitability","path":"/Taxonomy/Market Suitability","categories":[{"id":"332","name":"Global","localisedName":"Global","description":"Global","path":"/Taxonomy/Market Suitability/Global","categories":[]}]},{"id":"523","name":"Asset Type","localisedName":"Asset Type","description":"Asset Type","path":"/Taxonomy/Asset Type","categories":[{"id":"569","name":"Pack shots","localisedName":"Pack shots","description":"Pack shots","path":"/Taxonomy/Asset Type/Pack shots","categories":[]}]},{"id":"593","name":"Language","localisedName":"Language","description":"Language","path":"/Taxonomy/Language","categories":[{"id":"595","name":"English","localisedName":"English","description":"English","path":"/Taxonomy/Language/English","categories":[]}]},{"id":"795","name":"Permissions","localisedName":"Permissions","description":"Permissions","path":"/Taxonomy/Permissions","categories":[{"id":"1022","name":"MyBrands Public Library","localisedName":"MyBrands Public Library","description":"MyBrands Public Library","path":"/Taxonomy/Permissions/MyBrands Public Library","categories":[]}]},{"id":"844","name":"Brand and Variant","localisedName":"Brand and Variant","description":"Brand and Variant","path":"/Taxonomy/Brand and Variant","categories":[{"id":"1202","name":"Jameson","localisedName":"Jameson","description":"Jameson","path":"/Taxonomy/Brand and Variant/Jameson","categories":[{"id":"1203","name":"Jameson Original","localisedName":"Jameson Original","description":"Jameson Original","path":"/Taxonomy/Brand and Variant/Jameson/Jameson Original","categories":[]}]}]},{"id":"973","name":"Brand Materials","localisedName":"Brand Materials","description":"Brand Materials","path":"/Taxonomy/Brand Materials","categories":[{"id":"1000","name":"Photography","localisedName":"Photography","description":"Photography","path":"/Taxonomy/Brand Materials/Photography","categories":[{"id":"1007","name":"Pack Shots","localisedName":"Pack Shots","description":"Pack Shots","path":"/Taxonomy/Brand Materials/Photography/Pack Shots","categories":[{"id":"1008","name":"Bottle","localisedName":"Bottle","description":"Bottle","path":"/Taxonomy/Brand Materials/Photography/Pack Shots/Bottle","categories":[]},{"id":"1009","name":"Gift","localisedName":"Gift","description":"Gift","path":"/Taxonomy/Brand Materials/Photography/Pack Shots/Gift","categories":[]}]}]}]},{"id":"1024","name":"Market Information","localisedName":"Market Information","description":"Market Information","path":"/Taxonomy/Market Information","categories":[{"id":"1025","name":"Articles","localisedName":"Articles","description":"Articles","path":"/Taxonomy/Market Information/Articles","categories":[]}]},{"id":"1028","name":"Category","localisedName":"Category","description":"Category","path":"/Taxonomy/Category","categories":[{"id":"1204","name":"Whiskey","localisedName":"Whiskey","description":"Whiskey","path":"/Taxonomy/Category/Whiskey","categories":[]}]}]},' +
                    '"derivedFiles":{"storyboard": {"serviceName": "Storyboard","serviceId": "4","fileVersion": "1","mimeType": "image/jpeg","extension": "jpg","url": ["/servlet/file/96dbeaaa8.0.jpg?ITEM_ENT_ID=12610"]}, "bamArticleFull":{"serviceName":"bam-article-full","serviceId":"69","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_69_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=69"},"bamArticleHalf":{"serviceName":"bam-article-half","serviceId":"62","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_62_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=62"},"bamAssetPreview":{"serviceName":"bam-asset-preview","serviceId":"66","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_66_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=66"},"bamThumbnail":{"serviceName":"bam-thumbnail","serviceId":"65","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_65_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=65"},"cwAnnotationPreview":{"serviceName":"cw-annotation-preview","serviceId":"67","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_67_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=67"},"eXIF":{"serviceName":"EXIF","serviceId":"8","fileVersion":"1","mimeType":"text/xml","extension":"xml","url":"/servlet/file/12664_8_exif.xml?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=8"},"forsightLargePreview":{"serviceName":"forsight-large-preview","serviceId":"68","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_68_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=68"},"forsightPreview":{"serviceName":"forsight-preview","serviceId":"64","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_64_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=64"},"forsightThumbnail":{"serviceName":"forsight-thumbnail","serviceId":"61","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_61_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=61"},"imagePreview":{"serviceName":"Image Preview","serviceId":"2","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_2_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=2"},"imageInformation":{"serviceName":"image-information","serviceId":"91","fileVersion":"1","mimeType":"text/xml","extension":"xml","url":"/servlet/file/12664_91_image.xml?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=91"},"iPTC":{"serviceName":"IPTC","serviceId":"7","fileVersion":"1","mimeType":"text/xml","extension":"xml","url":"/servlet/file/12664_7_iptc.xml?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=7"},"thumbnail":{"serviceName":"Thumbnail","serviceId":"1","fileVersion":"1","mimeType":"image/jpeg","extension":"jpg","url":"/servlet/file/12664_1_preview.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7&FILE_SERVICE_CONF_ID=1"}},"originalFile":{"extension":"jpg","contentVersion":"1","url":"/servlet/file/JAMESON%20Bottle%20&%20Canister21.jpg?ITEM_ENT_ID=12664&COLLSPEC_ENT_ID=6&ITEM_VERSION=7"},' +
                    '"exif":[{"id":33434,"name":"Exposure Time","value":"1/180 sec"},{"id":33437,"name":"F-Number","value":"F22"},{"id":34850,"name":"Exposure Program","value":"Manual control"},{"id":34855,"name":"ISO Speed Ratings","value":"200"},{"id":36864,"name":"Exif Version","value":"2.30"},{"id":36867,"name":"Date/Time Original","value":"2014:07:11 12:01:07"},{"id":36868,"name":"Date/Time Digitized","value":"2014:07:11 12:01:07"},{"id":37377,"name":"Shutter Speed Value","value":"1/180 sec"},{"id":37378,"name":"Aperture Value","value":"F22"},{"id":37381,"name":"Max Aperture Value","value":"F4"},{"id":37382,"name":"Subject Distance","value":"1.049 metres"},{"id":37383,"name":"Metering Mode","value":"Spot"},{"id":37385,"name":"Flash","value":"Flash did not fire"},{"id":37386,"name":"Focal Length","value":"120.0 mm"},{"id":40961,"name":"Color Space","value":"Undefined"},{"id":40962,"name":"Exif Image Width","value":"1502 pixels"},{"id":40963,"name":"Exif Image Height","value":"2480 pixels"},{"id":41486,"name":"Focal Plane X Resolution","value":"100/147059 cm"},{"id":41487,"name":"Focal Plane Y Resolution","value":"100/147059 cm"},{"id":41488,"name":"Focal Plane Resolution Unit","value":"cm"},{"id":41989,"name":"Focal Length 35","value":"94mm"},{"id":42016,"name":"Unique Image ID","value":"00000000000000000366972F00004431"},{"id":42036,"name":"Lens Model","value":"HC 120"},{"id":256,"name":"Unknown tag (0x0100)","value":"2991"},{"id":257,"name":"Unknown tag (0x0101)","value":"4938"},{"id":258,"name":"Unknown tag (0x0102)","value":"8 8 8"},{"id":259,"name":"Unknown tag (0x0103)","value":"1"},{"id":262,"name":"Unknown tag (0x0106)","value":"2"},{"id":270,"name":"Image Description","value":"JAMESON Whiskey"},{"id":271,"name":"Make","value":"Hasselblad"},{"id":272,"name":"Model","value":"Hasselblad H3D-31"},{"id":274,"name":"Orientation","value":"Top, left side (Horizontal / normal)"},{"id":277,"name":"Unknown tag (0x0115)","value":"3"},{"id":282,"name":"X Resolution","value":"300 dots per inch"},{"id":283,"name":"Y Resolution","value":"300 dots per inch"},{"id":284,"name":"Unknown tag (0x011c)","value":"1"},{"id":296,"name":"Resolution Unit","value":"Inch"},{"id":305,"name":"Software","value":"Adobe Photoshop CC 2014 (Macintosh)"},{"id":306,"name":"Date/Time","value":"2014:07:17 11:22:48"},{"id":315,"name":"Artist","value":"David Norton & Ronnie Norton of DN Design"},{"id":33432,"name":"Copyright","value":"© DN Design 2014"},{"id":259,"name":"Thumbnail Compression","value":"JPEG (old-style)"},{"id":282,"name":"X Resolution","value":"72 dots per inch"},{"id":283,"name":"Y Resolution","value":"72 dots per inch"},{"id":296,"name":"Resolution Unit","value":"Inch"},{"id":513,"name":"Thumbnail Offset","value":"958 bytes"},{"id":514,"name":"Thumbnail Length","value":"4874 bytes"}],' +
                    '"iptc":[{"id":346,"name":"Coded Character Set","value":"%G %G %G %G %G %G %G"},{"id":512,"name":"Application Record Version","value":"4"},{"id":632,"name":"Caption/Abstract","value":"JAMESON Whiskey"},{"id":592,"name":"By-line","value":"David Norton & Ronnie Norton of "},{"id":622,"name":"Credit","value":"DN Design"},{"id":567,"name":"Date Created","value":"Fri Jul 11 00:00:00 GMT 2014"},{"id":572,"name":"Time Created","value":"120107+0000"},{"id":574,"name":"Digital Date Created","value":"20140711"},{"id":628,"name":"Copyright Notice","value":"© DN Design 2014"}],"imageInformation":{"colorSpace":"srgb","compressionType":"jpeg","fileName":"0e58dca56952a35178e8a9a4cdfcc50c.jpg","fileSize":"487936","hasAlpha":"false","height":"2480","imageDepth":"8","numberOfPages":"1","exifOrientation":"1","colorSpace":"srgb","compressionType":"jpeg","hasAlpha":"false","height":"2480","imageDepth":"8","offsetX":"0","offsetY":"0","exifOrientation":"1","quality":"91","quantumDepth":"16","resolutionX":"300.0","resolutionY":"300.0","signature":"8ea4ba6bd49d010b09f75d9196ab7593d7d0d430ade9395e677af6fdf147ed43","width":"1502","quality":"91","quantumDepth":"16","resolutionUnit":"DPI","resolutionX":"300.0","resolutionY":"300.0","width":"1502"}}';
    
                res.setStatus('OK');
                res.setStatusCode(200);
                res.setBody(responseJson);
            } else if ((ESN_MB_Rest_Api_Callout.ENDPOINT_ASSETS).equals(req.getEndPoint())) {
                // Get all assets (postAssetsNoParameterTest)
                String responseJson = '['
                    + '{"id":"123456701","name":"Test Asset1", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456702","name":"Test Asset2", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456703","name":"Test Asset3", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}}'
                    + ']';
                res.setStatus('OK');
                res.setStatusCode(200);
                res.setBody(responseJson);
            } else if (req.getEndPoint().contains('lastModifiedDate') || req.getEndPoint().contains('category')) {
                System.debug('lastModifiedDate / category');
                // Get last modified assets
                String responseJson = '['
                    + '{"id":"123456701","name":"Test Asset1", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456702","name":"Test Asset2", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456703","name":"Test Asset3", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456704","name":"EXPIRATION-DATE", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"30.11.2010","usage_rights_type":"None","expiry-date-required":"required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456705","name":"ARCHIVED", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Archived","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}},'
                    + '{"id":"123456706","name":"WRONG-BRAND", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Archived","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'MyBrands Public Library') + ',' + buildTaxonomy('Brands', 'WRONG-BRAND') + ']}},'
                    + '{"id":"123456707","name":"WRONG-PERMISSION", "metadata":{"usage-rights":"","type":"brand_asset","workflow_status":"Published","expiry_date":"","usage_rights_type":"None","expiry-date-required":"not-required"}, "taxonomy":{"id":"root","name":"Taxonomy","localisedName":"Taxonomy","description":"This is the main parent for Taxonomy tree","path":"/Taxonomy","categories":[' + buildTaxonomy('Permissions', 'Internal Use Only') + ',' + buildTaxonomy('Brands', 'brand1_id') + ']}}'
                    + ']';
    
                res.setStatus('OK');
                res.setStatusCode(200);
                res.setBody(responseJson);
                res.setHeader('Content-Range', '0-6/7');
            } else {
                // Exception
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