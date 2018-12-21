/* ArticleEditController.cls
 * 
 * $Date$
 * $Revision$
 * $Author$
 * $HeadURL$
 *
 * @description Retrieves and saves content for article content using OrchestraCMS.  Includes several methods for
 * retrieving markup in different layouts
 *
*/
global without sharing class ArticleEditController extends cms.ContentTemplateController {

    String pageLink;       

    global ArticleEditController(cms.GenerateContent gs) {
        super(gs);
    }

    global ArticleEditController(){}
    
    public cms.Link DynamicTargetPageLinkObj { 
        get{
            if (this.getProperty('DynamicTargetPageLink') != null) {
                return new cms.Link(this.getProperty('DynamicTargetPageLink'), this.pm, this.sn);
            }
            return null;
        }
    }

    public String ImageId {
        get {
            return getValidImageUrl(this.getProperty('ImageId'));
        }
    }

    public String LargeImageId {
        get {
            return getValidImageUrl(this.getProperty('LargeImageId'));
        }
    }

    public String Headline {
        get {
            String title= this.getProperty('Headline');
            if (title==null) {
                title=this.content.cms__Name__c;
            }
            return title;
        } set;
    }

    public String getHTMLContent() { 
        return  this.getProperty('HTMLContent');
    }

    public String getSummaryContent() { 
        return  this.getProperty('SummaryContent');
    }
    
    public String getSubContent() { 
        return  this.getProperty('SubContent');
    }
    
    public String getHighlightsContent() { 
        return  this.getProperty('HighlightsContent');
    }

    public String AltImageText {
        get {
            return this.getProperty('AltImageText');
        } set;
    }

    public String TitleImageText {
        get {
            return this.getProperty('TitleImageText');
        } set;
    }


    public String accessLevel {
        get{
            if (isAccessLevelEnabled()) {
                return this.content.cms__Access_Level__c;
            } else {
                return null;
            }
        } set;
    }

    public Boolean showAccessLevel {
        get{
            if (isAccessLevelEnabled()) {
                return true;
            } else {
                return false;
            }
        } set;
    }

    public String priorityWeight {
        get{

            if (this.content.cms__Priority_Weight__c == null) {
                return '';
            }
            return  '' +this.content.cms__Priority_Weight__c;
        } set;
    }

    public String priorityDuration {
        get{
            if (this.content.cms__Priority_Duration__c==null) {
                return '';
            }
            return '' + this.content.cms__Priority_Duration__c ;
        } set;
    }

    public Boolean getPublished() {
        if (this.content != null) {
            return this.content.cms__Published__c;
        }
        return false;
    }     


    public String StartDate {
        get{
            DateTime tmpnow=DateTime.now();

            if (this.content.cms__Published__c == true) {
                return this.content.cms__Published_Start_Date__c.format('yyyy-MM-dd HH:mm:ss');
            } else{
                if (this.content.cms__Published_Start_Date__c != null && this.content.cms__Published_Start_Date__c >= tmpnow) {
                    return this.content.cms__Published_Start_Date__c.format('yyyy-MM-dd HH:mm:ss');
                } else {
                    return  tmpnow.format('yyyy-MM-dd HH:mm:ss');
                }
            }
        } set;
    }

    public String StartDateOnly {
        get{
            DateTime tmpnow=DateTime.now();
            DateTime contentPublishedStartDate;

            if (this.content.cms__Original_Published_Start_Date__c != null) {
                contentPublishedStartDate=this.content.cms__Original_Published_Start_Date__c;
            } else {
                contentPublishedStartDate = tmpnow;   
            }
            return contentPublishedStartDate.format('d MMMMM, yyyy');
        } set;
    }

    public String StartDateOnlyShort {
        get{
            DateTime tmpnow=DateTime.now();
            DateTime contentPublishedStartDate;

            if (this.content.cms__Original_Published_Start_Date__c != null) {
                contentPublishedStartDate=this.content.cms__Original_Published_Start_Date__c;
            } else {
                contentPublishedStartDate = tmpnow;   
            }
            return contentPublishedStartDate.format('M/d/yy');
        } set;
    }

    public String Expiry {
        get{
            if (this.content.cms__Published_End_Date__c != null) {
                return this.content.cms__Published_End_Date__c.format('yyyy-MM-dd HH:mm:ss');
            } else {
                return null;
            }
        } set;
    }


    /**
     * The function is used to support old legacy url's where they were just stored and the  file id.
     * New urls are either stored with the filedownload url or with an http: url so just use them otherwise
     * we format the url with the standard SalesForce FileDownload servlet url.
     * @function {public static String} getValidImageUrl
     * @param {String} sImgUrl The image url
     * @return A valid image url.
     */
    public String getValidImageUrl(String sImgUrl) {
        if (sImgUrl != null) {
            String url = '';
            if (sImgUrl.startsWith('http') || sImgUrl.startsWith('/servlet/servlet.FileDownload')) {
                url = sImgUrl;
            } else {
                url = '/servlet/servlet.FileDownload?file=' + sImgUrl;
            }
            if (Site.getPrefix() != null && url.startsWith('/servlet')) {
                url = Site.getPrefix() + url;
            }
            return url;
        }
        return null;
    }


    /*
     *   To generate the page link we should switch to using the Service API
     *   String getLinkToPage(String pageName) function
     */
    public String taxonomyPageLink { 
        get{
            String siteName = Site.getName();
            if (this.pageLink != null) {
                if (this.pm == 'production') {
                    return  '/cms__Main?name=' + this.pageLink;
                } else {
                    return '/apex/Preview?name=' +this.pageLink +'&sname='+this.sn;
                }
            }
            return null;
        }
    }

    private String buildPageLinkWithContentId(String page) {
        cms.ServiceAPI sAPI = this.getServiceAPI();
        if (sAPI != null) {
            Map<String, String> params = new Map<String, String>();
            params.put('content_id', this.content.Id);
            return sAPI.getLinkToPage(page, params);
        }
        return null;
    }

    /*
        Retrieves a link to the preview page stored in Orchestra's Content Type's Preview page selector for the detail layout.
    */
    private String getPreviewLink() {
        String link = '';
        try {
            cms__Content_Template_Relationship__c ctr = [SELECT Id, cms__Preview_Page__c, cms__Preview_Page__r.cms__Search_Optimized_Name__c FROM cms__Content_Template_Relationship__c WHERE cms__Content_Type__c = :this.content.cms__Content_Type__c AND cms__Content_Layout__r.cms__Name__c = 'ArticleDetail'];
            link = buildPageLinkWithContentId(ctr.cms__Preview_Page__r.cms__Search_Optimized_Name__c);
            if (link == null) {
                link = '';
            }
        } catch(Exception e) {
            System.debug(e.getStackTraceString() + e.getLineNumber() + e.getMessage());
        }
        return link;
    }
    
    /*This is a temporary solution to determine if access levels are enabled.
     * This needs to change when this becomes available through service api
     * */
    public Boolean isAccessLevelEnabled(){
        Schema.SObjectType sot1 = Schema.Sobjecttype.User.getsObjectType();
        Map<String, SObjectField> userFields = sot1.getDescribe().fields.getMap();
        if (userFields.containsKey('Access_Level__c')) {
            return true;
        }
        return false;
    }

    //override
    global override String getHTML() {
        String cID = '0';
        String topicList='';
        if (this.content_layout_instance != null) {
            cID = this.content_layout_instance.cms__content_layout__c;
        }
        String html = '<div class="fullArticle" data-clid="' + cID + '" data-cid="' + this.content.Id + '">';
        try {
            html += '<h2>' + Headline + '</h2>';
            // removed for change request 2-10-2013
            //html += '<div class="full-image">';
            //html += getImgHTML(true);
            //html += '<span class="articleDateWrapper"><span class="articleDate">' + StartDateOnlyShort + '</span></span></div>';
            html += '<div class="introText"><p>' + (getHTMLContent() == null ? '' : getHTMLContent()) + '</p></div>';
            html += '<div class="subContent"><div class="highlightsText">' + (getHighlightsContent() == null ? '' : getHighlightsContent()) + '</div>';
            html += '<div class="subText">' + (getSubContent() == null ? '' : getSubContent()) + '</div></div>';
            html += '</div>';
            html += getRelatedArticlesHTML(5);

        } catch(Exception e){
            html ='<div>Error getting the article: ' + e.getStackTraceString() + e.getLineNumber() + e.getMessage() +'</div>';
            system.debug( e.getStackTraceString() + e.getLineNumber() + e.getMessage()  );
        }
        if (html == null) {
            html = '<div></div>';
        }
        return html; 
    }

    private String getDetailPageLink() {
        String sDetailLink = '';
        if (this.DynamicTargetPageLinkObj != null && this.DynamicTargetPageLinkObj.targetPage != null) {
            return DynamicTargetPageLinkObj.targetPage+'&content_id='+this.content.Id+'&origin_id'+this.content.cms__Version_Origin__c;              
        }
        return sDetailLink;
    }

    private List<cms__Content__c> getRelatedArticles() {
        List<cms__Content__c> relatedContent = new List<cms__Content__c>();
        Set<Id> relatedIds = new Set<Id>();
        relatedIds.add(this.content.Id);
        try {
            cms.ServiceAPI sAPI = this.getServiceAPI();
            if (sAPI != null) {
                Set<String> cl = new Set<String>();
                cl.add('ArticleRelated');
                List<List<cms__Tag__c>> tags = sAPI.getActiveTagsForContent(this.content.id);
                System.debug('# of ACTIVE TAGS FOR CONTENT = ' + tags.size());
                for (List<cms__Tag__c> tagList : tags) {
                    List<String> lsTagList = new List<String>();
                    for (cms__Tag__c t : taglist) {
                        lsTagList.add(t.cms__Tag_Definition__r.cms__Name__c);
                    }
                    System.debug('GETTING CONTENTS BY TAGS: ' + lsTagList);
                    Boolean bExactMatch = true;
                    Integer numOfMatches = 20;
                    List<cms__Content__c> lc = sAPI.getContentsByTag(lsTagList, cl, numOfMatches, bExactMatch);
                    for (cms__Content__c c : lc) {
                        if (!relatedIds.contains(c.Id)) {
                            relatedContent.add(c);
                            relatedIds.add(c.Id);
                        }
                    }
                }               
            }
        } catch(Exception e) {
            system.debug( e.getStackTraceString() + e.getLineNumber() + e.getMessage()  );
        }
        System.debug('# OF RELATED ARTICLES = ' + relatedContent.size());
        System.debug('RELATED CONTENT:  ' + relatedContent);
        return relatedContent;  
    }

    global String getRelatedArticlesHTML(Integer numOfArticles) {
        String html = '';
        try {
            cms.ServiceAPI sAPI = this.getServiceAPI();
            List<cms__Content__c> lc = getRelatedArticles();
            Integer i = 0;   
            if (lc.size() > 0) {
                String sTemplate = 'ArticleRelated';
                html = '<div class="articleRelatedList">';
                html += '<h1 class="articleSectionHeading">RELATED ARTICLES</h1>';
               for (cms__Content__c c : lc) {
                    if (i < numOfArticles) {
                        html += '<div class="articleRelated" data-cid="' + c.Id + '">';
                        html += sAPI.getGeneratedContent(c.Id, sTemplate);
                        html += '</div>';
                        i++;
                    } else {
                        break;
                    }
                }
                html += '</div>';
            } // IF
        } catch(Exception e) {
            system.debug( e.getStackTraceString() + e.getLineNumber() + e.getMessage()  );
        }
        System.debug('RELATED ARTICLE HTML ' + html);
        return html;
    }
    
    global String getRelatedHTML() {

        String html = '';
        String sDetailPage = getDetailPageLink();
            
        if (this.content != null && this.content.id != null) {
            //if (this.DynamicTargetPageLinkObj != null) {
                //html = '<a class="summary-link title-article-link" href="' + sDetailPage + '">';
            //} else {
                //html = '<a class="ocms-title-taxonomy-detail-link summary-link title-article-link" href="">';
            //}
            html += '<div class="rArticle-title">' + getArticleHeadline('summary') + '</div>';
            html += '<p class="rArticle-text">' + getSummaryContent() + '</p>';
            //html += '</a>';
        }
        return html;
    }
    
    private String getArticleHeadline(String className){
        String htmlFullContent = getHTMLContent();
        Integer readTime=1;
        if (htmlFullContent != null && htmlFullContent.length()>0) {
            readTime =htmlFullContent.length()/2000;
        }
        if (readTime==0) {
            readTime=1;
        }
        boolean access=false;
        String query;
        sObject loginUser;
        if (this.pm  !=null && this.pm!= 'production') {
            access=true;
        } else {
            if(isAccessLevelEnabled()) {
                query ='Select Access_Level__c From User Where Id=\'' + UserInfo.getUserId() + '\'';
                loginUser = Database.query(query);
            }   else {
                access=true;
            }
            String userType=null;
            String accessLevel ='Guest';
            if (loginUser != null) {
                if (loginUser.get('Access_Level__c')!= null) {
                    accessLevel=(String)loginUser.get('Access_Level__c');
                }
                query='Select cms__Name__c,cms__Value__c From cms__Access_Level__c Where  cms__Name__c=\''+accessLevel+'\'';
                List<sObject> contLevel = Database.query(query); 

                if (contLevel.size()>0 ) {
                    Decimal levelValue= (Decimal)contLevel[0].get('cms__Value__c');
                    if (this.content.cms__Access_Level__r != null  && this.content.cms__Access_Level__r.cms__Value__c>= levelValue) {
                        access=true;
                    }
                }
            }       
        }
        cms.ServiceAPI sAPI = this.getServiceAPI();
        if (sAPI ==null ) {
            return'serviceAPI is null ';
        }
        String html = '';
        if (this.content!= null && this.content.id != null) {
            String sDetailPage = getDetailPageLink();
            html += '<h2 class="articleTitle">';

            if (this.DynamicTargetPageLinkObj != null && this.DynamicTargetPageLinkObj.targetPage != null) {
                html += '<a class="'+className+'-link title-article-link" href="'+ sDetailPage +'">' + Headline +'</a>';              
            } else {
                if (access) {
                    if (String.isNotBlank(sDetailPage)) {
                        html += '<a class="'+className+'-link title-article-link" href="' + sDetailPage + '">' + Headline +'</a>';
                    } else {
                        html += '<a class="ocms-title-taxonomy-detail-link '+className+'-link title-article-link" href="">' + Headline +'</a>';
                    }
                } else {
                    html += Headline + '<span class="article-lock">&nbsp;&nbsp;</span>';
                }
            }
            html += '</h2>';
            html += '<span class="articleDateWrapper"><span class="articleDate">' + StartDateOnlyShort + '</span></span>';            
        }
        return html;
    } 

    //  choose either large image (true) or small image (false)
    public String getImgHTML(boolean bLarge) {
        String imgHTML = '';
        String imgId = (bLarge == true ? LargeImageId : ImageId);
        if (imgId != null) {
            String hoverText = TitleImageText;
            if (hoverText == null) {
                hoverText = '';
            }

            String altText = AltImageText;
            if (altText == null) {
                altText = '';
            }
            imgHTML = '<img alt="' + altText + '" title ="' + hoverText+'" src="' + imgId + '" />';
        }
        return imgHTML;
    }

    public String getSummary() {

        String headlineHTML = getArticleHeadline('summary');
        String imgHTML = getImgHTML(false);
        String lImgHTML = getImgHTML(true);
        String summaryContent = getSummaryContent();
        if (summaryContent == null) {
            summaryContent = '';
        }
        String html = '<div class="summary"><div class="summary-image">' + imgHTML + '</div>';
        html += '<div class="carousel-image">' + lImgHTML + '</div>';
        html += '<div class="summary-content">' + headlineHTML;
        html += '<p class="summary-text">' + summaryContent + '</p></div>';
        html += '<div class="clear"></div></div>';
        return html;
    } 
    
    
    @IsTest(SeeAllData=true)
    public static void ArticleEditorControllerTest(){

        String siteName = 'InSiteTest'; 
        Map <String, String> contextProperties = new Map<String, String>(); 
        cms__Sites__c mySite = cms.TestExtensionFixtures.InitiateTest(siteName, contextProperties); 

        // --- TEST SETUP METHODS ---
        cms__Content_Type__c ct = new cms__Content_Type__c(cms__Name__c = 'Taxonomy', cms__Site_Name__c = 'Public');
        insert ct;
        ct = new cms__Content_Type__c(cms__Name__c = 'TaxonomyItem', cms__Site_Name__c = 'Public');
        insert ct;

        cms__Content__c txc = new cms__Content__c(
                cms__Content_Type__c         = ct.Id,
                cms__Name__c                 = 'News Articles',
                cms__Description__c          = 'Taxonomy',
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
        
        cms__Content_Layout__c cl = new cms__Content_Layout__c(cms__Name__c = 'ArticleDetail');
        insert cl;
        cms__Content_Layout__c cl2 = new cms__Content_Layout__c(cms__Name__c = 'ArticleSummary');
        insert cl2;
        
        cms__Page__c page = new cms__Page__c(cms__Name__c = 'TestTaxonomyDetail', cms__Site_Name__c = 'Public');
        insert page;
        
        cms__Content_Type__c ctype = new cms__Content_Type__c(cms__Name__c = 'Article', cms__Site_Name__c = 'Public');
        insert ctype;

        cms__Content__c ic = new cms__Content__c(cms__Name__c = 'Test Article 1', cms__Content_Type__c = ctype.Id, cms__Site_Name__c = 'Public');
        insert ic;
        cms__Content_Layout_Instance__c cli = new cms__Content_Layout_Instance__c(cms__Content__c = ic.Id, cms__Content_Layout__c = cl.Id);
        insert cli;

        cms__Content__c ic2 = new cms__Content__c(cms__Name__c = 'Test Article 2', cms__Content_Type__c = ctype.Id, cms__Site_Name__c = 'Public');
        insert ic2;
        cms__Content_Layout_Instance__c cli2 = new cms__Content_Layout_Instance__c(cms__Content__c = ic2.Id, cms__Content_Layout__c = cl.Id);           
        insert cli2;

        cms__Page_Content_Layout_Instance__c pcli = new cms__Page_Content_Layout_Instance__c(cms__Content_Layout_Instance__c=cli.Id,cms__Page__c=page.Id);
        insert pcli;
        //  --- END OF TEST SETUP RECORDS ---
        
        cms__Content__c c = [Select cms__Name__c,cms__Access_Level__c,cms__Is_Not_Targeted__c, cms__Version_Origin__c, cms__All_Shared_With_Portal__c, cms__All_Shared_With_Guest__c, cms__Original_Published_Start_Date__c, cms__Access_Level__r.cms__Value__c,cms__Published_End_Date__c,cms__Published_Start_Date__c,cms__Published__c From cms__Content__c Where cms__Content_Type__r.cms__Name__c='Article' And cms__Name__c='Test Article 1' Limit 1];   

        cms.API anAPI = new cms.API(null, 'prev');
        anAPI.site_name = 'Public';

        cms__Content_Layout_Instance__c pcli2 = [SELECT Id, cms__Content__c FROM cms__Content_Layout_Instance__c WHERE cms__Content__r.cms__Name__c = 'Test Article 2' LIMIT 1];
        
        System.currentPageReference().getParameters().put('ecms', anAPI.getSerialize());
        System.currentPageReference().getParameters().put('content_id', pcli2.cms__Content__c);
        System.currentPageReference().getParameters().put('cli_id', pcli2.Id);
        System.currentPageReference().getParameters().put('pcli_id', pcli.Id);
        cms.GenerateContent gc = new cms.GenerateContent();
        gc.content=c;
        gc.cli= cli;
        gc.pcli=pcli; 
        ArticleEditController aCont= new ArticleEditController(gc);                 
        aCont.getHTMLContent();
        aCont.getSummaryContent();
        aCont.content_layout_instance = cli2;
        System.currentPageReference().getParameters().put('ecms', anAPI.getSerialize());
        aCont.getSummary();
        aCont.getHTML();
        aCont.getRelatedHTML();
        aCont.getPreviewLink();
        aCont.getRelatedArticlesHTML(5);
        
        String accessLevel = aCont.accessLevel;
        String AltImageText = aCont.AltImageText;
        String Expiry = aCont.Expiry;
        String StartDate = aCont.StartDate;
        String ImageId = aCont.ImageId;
        String Headline = aCont.Headline;
        String title = aCont.TitleImageText;
        String startDateOnly = aCont.StartDateOnly;
        String startDateOnlyShort = aCont.StartDateOnlyShort;
        boolean published = aCont.getPublished();
        Boolean showAccess = aCont.showAccessLevel;
        String image = aCont.getValidImageUrl('/servlet/servlet.FileDownload');

        System.debug(aCont.DynamicTargetPageLinkObj);
        System.debug(aCont.ImageId);
        System.debug(aCont.Headline);
        System.debug(aCont.AltImageText);
        System.debug(aCont.TitleImageText);
        System.debug(aCont.accessLevel);
        System.debug(aCont.showAccessLevel);
        System.debug(aCont.StartDate);
        System.debug(aCont.StartDateOnly);
        System.debug(aCont.StartDateOnlyShort);
        System.debug(aCont.Expiry);
        System.debug(aCont.taxonomyPageLink);
    }
}