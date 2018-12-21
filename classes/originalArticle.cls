public without sharing class originalArticle {

	public string getOriginContentId() {
		// get the content_id parameter
		String givenCid = ApexPages.currentPage().getParameters().get('content_id');

		// query to see if it has a pointer to the "origin" content
		cms__Content__c thisContent = [select Id, cms__Version_Origin__c, cms__Version_Original__c from cms__Content__c where id = :givenCid];
		
		// either the content id that was passed or its origin 
		String originCid = (thisContent.cms__Version_Origin__c == null ? givenCid : thisContent.cms__Version_Origin__c); 
		
		System.debug('getOriginContentId: given cid="' + givenCid + '", origin cid is: ' + originCid );

		return originCid;		
	} // getOriginContentId
	
	@isTest
	public static void testThisClass() {
		// - TEST SETUP METHODS ---
		cms__Content_Type__c ct = new cms__Content_Type__c(cms__Name__c = 'ARTICLE', cms__Site_Name__c = 'Public');
		insert ct;

		cms__Content__c txc = new cms__Content__c(
                cms__Content_Type__c         = ct.Id,
                cms__Name__c                 = 'AnArticle',
                cms__Description__c          = 'Testing',
                cms__Preview__c              = true,
                cms__Published__c            = false,
                cms__Published_Start_Date__c = System.now(),
                cms__Site_Name__c            = 'Public',
                cms__Revision_Number__c      = 0,
                cms__Revision_Origin__c      = null,
                cms__Version_Number__c       = 1,
                cms__Version_Origin__c       = null,
                cms__Version_Original__c     = true,
                cms__Version_Parent__c       = null,
                cms__Depth__c                = 0
        );
        insert txc;
        
        // test equals content id
        originalArticle oaObj = new originalArticle();
        ApexPages.currentPage().getParameters().put('content_id', (String) txc.Id);
        String oId = oaObj.getOriginContentId();
        System.assertEquals((String) txc.id, oId);
        
		cms__Content__c txc2 = new cms__Content__c(
                cms__Content_Type__c         = ct.Id,
                cms__Name__c                 = 'AnArticle new version',
                cms__Description__c          = 'Testing',
                cms__Preview__c              = true,
                cms__Published__c            = false,
                cms__Published_Start_Date__c = System.now(),
                cms__Site_Name__c            = 'Public',
                cms__Revision_Number__c      = 1,
                cms__Revision_Origin__c      = txc.Id,
                cms__Version_Number__c       = 1,
                cms__Version_Origin__c       = txc.Id,
                cms__Version_Original__c     = false,
                cms__Version_Parent__c       = txc.Id,
                cms__Depth__c                = 0
        );
        insert txc2;
        
        // test equals origin content id
        ApexPages.currentPage().getParameters().put('content_id', (String) txc2.Id);
        oId = oaObj.getOriginContentId();
        System.assertEquals((String) txc.id, oId);
        
	} // testThisÇlass

}