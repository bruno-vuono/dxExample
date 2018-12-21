/*
* A class to provide RSS and SOAP end point for returning content of type "News Article" related to a specific Site.
*
* *Please note*: because client needed to generate RSS feed for arbitrary sites we had to bypass normal OCMS API
*                which means we can not guarantee this code will continue to function in subsequent version of OCMS.
*
*/
global with sharing class ArticleRSS {
    
    public String response { get; set; }
    public String siteName { get; set; }
    private String domain = '';
    // IMPRV: combine this with the domainList query 
    public List<sObject> siteObjectList = Database.query('SELECT cms__Site_Name__c, cms__Site_Domain__c FROM cms__Sites__c'); 
    private List<cms__Content__c> contentList;
    private Map<Id, Attachment> attachments;
    private Map<Id, List<cms__Attribute__c>> content_attributes;

    // Empty Constructor
    public ArticleRSS() {}

    //Method - Returns a trimmed List of cms__Attribute__c, will only contain SummaryContent, ImageId, and Headline.
    private List<cms__Attribute__c> getAttributes( String contentId ){

        List<cms__Attribute__c> attributeList = Database.query( 'SELECT cms__Name__c, cms__Value__c FROM cms__Attribute__c WHERE cms__Content__c = \'' + contentId + '\'' );
        List<cms__Attribute__c> trimmedAttrList = new List<cms__Attribute__c>();

        for ( cms__Attribute__c attr : attributeList ){
            if ( attr.cms__Name__c == 'SummaryContent' ){
                trimmedAttrList.add(attr);
            }
            if ( attr.cms__Name__c == 'ImageId' ){
                trimmedAttrList.add(attr);
            }
            if ( attr.cms__Name__c == 'Headline' ){
                trimmedAttrList.add(attr);
            }
        }
        return trimmedAttrList;
    }

    public void generateArticleJSON(){

        response = '{"success":true, "articles":[';

        for ( cms__Content__c cont : contentList ){
            response += '{"articleName":"' + cont.cms__Name__c + '", "attributes":[';
            List<cms__Attribute__c> attrList = getAttributes(cont.Id);
            for ( cms__Attribute__c attr : attrList){
                response += '{';
                response += '"attrName" : "' + attr.cms__Name__c + '", ';
                response += '"attrValue" : "' + attr.cms__Value__c + '"';
                response += '},';
            }
            response.removeEnd(',');
            response += ']},';
        }
        response.removeEnd(',');
        response += ']}';
    }

    public void loadResponseJSON(){
        generateArticleJSON();
    }

    private String generateRSSItemNodes() {
        String itemNodes = '';
        
        for ( cms__Content__c cont : contentList ){
            itemNodes += '\t<item>\n';

            itemNodes += '\t\t<pubDate>';
                Datetime dt = cont.cms__Published_Start_Date__c;
                itemNodes += dt.format('EEE, d MMM yyyy HH:mm:ss z');
            itemNodes += '</pubDate>\n';

            itemNodes += '\t\t<link>' 
                        + ('https://' 
                        + domain + '/apex/cms__Main?sname=InSite&name=News_Article_Contents_Displayed&content_id=' 
                        + cont.Id).escapeXml()
                        + '</link>\n';

            //List<cms__Attribute__c> attrList = getAttributes(cont.Id);
            
            for (cms__attribute__c attr : content_attributes.get(cont.id)){
                if (attr.cms__Name__c == 'Headline'){
                    itemNodes += '\t\t<title>' + attr.cms__Value__c.escapeXml() + '</title>\n';
                }
                if (attr.cms__Name__c == 'SummaryContent'){
                    // client wanted to keep the CDATA in the description so we are not escaping it 
                    itemNodes += '\t\t<description><![CDATA[' + attr.cms__Value__c + ']]></description>\n';
                }
                if (attr.cms__Name__c == 'ImageId'){
                    if (attachments.containsKey(attr.cms__Value__c.substringAfter('='))) {
                        String strContentType = attachments.get(attr.cms__Value__c.substringAfter('=')).ContentType;
                        if (String.IsBlank(strContentType)) { strContentType = 'image/jpeg'; }
                        itemNodes += '\t\t<enclosure url="https://' + domain + attr.cms__Value__c 
                                  + '" type="' + strContentType
                                  + '" length="' 
                                  + string.valueof(attachments.get(attr.cms__Value__c.substringAfter('=')).BodyLength)
                                  + '" />\n';
                    }
                }
            }

            itemNodes += '\t\t<guid isPermaLink="false">' + cont.Id + '</guid>\n';

            itemNodes += '\t</item>\n';
        }

        return itemNodes;
    }

    public void generateArticleRSS() {
        String itemNodes = generateRSSItemNodes();

        response = '';
        response += '<?xml version="1.0" encoding="utf-8"?>\n';
        response += '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\n';
        response += '<channel>\n';
        response += '<title>' + this.siteName + ' RSS Feed</title>\n';
        //response += '<link><![CDATA[http://myportal.pernod-ricard.com/_layouts/PernodRicard/SalesForce/AutoLogin.aspx?StartUrl=https://pernod-ricard--cms.eu1.visual.force.com/apex/Main?sname=InSite&name=InSite_Home]]></link>\n';
        response += '<link>http://' + this.domain.escapeXml() + '</link>\n';
        response += '<description>News articles from the ' + this.siteName + ' site</description>\n';
        response += '<language>en</language>\n';
        response += '<copyright>Copyright ' + String.valueOf(System.Today().year()) + '</copyright>\n';
        response += '<ttl>30</ttl>\n';
        response += '<pubDate>' + System.Now().format('EEE, d MMM yyyy HH:mm:ss z') + '</pubDate>\n';
        response += '<lastBuildDate>' + System.Now().format('EEE, d MMM yyyy HH:mm:ss z') +  '</lastBuildDate>\n';
        //response += '<atom:link href="http://gtsb1conf-pernod-ricard.cs7.force.com/testrss" rel="self" type="application/rss+xml" />\n';
        response += itemNodes;
        response += '</channel>\n';
        response += '</rss>\n';
    }

    private void loadContentList() {
        contentList = new List<cms__Content__c>();
        content_attributes = new Map<Id, List<cms__Attribute__c>>();

        List<cms__Content_Type__c> lstTypeId = [SELECT Id FROM cms__Content_Type__c WHERE cms__Label__c = 'News Article'];
        DateTime val = DateTime.now();
        if (siteName != null){
            contentList = [SELECT Id, cms__name__c, cms__Published_Start_Date__c 
                            FROM cms__Content__c 
                            WHERE cms__Content_Type__c IN :lstTypeId 
                            AND cms__published__c = true 
                            AND cms__Site_Name__c = 'InSite' 
                            AND cms__Published_Start_Date__c <= :val 
                            AND (cms__Published_End_Date__c > :val OR cms__Published_End_Date__c = null) 
                            ORDER BY cms__Published_Start_Date__c DESC LIMIT 50];
        } 

        if (!contentList.isEmpty()) {
            Set<Id> content_ids = (new Map<Id, cms__Content__c>(contentList)).keySet();
            Set<Id> attachment_ids = new Set<Id>();
            

            for(cms__Attribute__c att : [SELECT cms__Name__c, cms__Value__c, cms__Content__c FROM cms__Attribute__c WHERE cms__Content__c IN :content_ids]) {
                If (att.cms__Name__c == 'Headline' || att.cms__Name__c == 'SummaryContent' || att.cms__Name__c == 'ImageId') {
                    if(!content_attributes.containsKey(att.cms__Content__c)) {
                        content_attributes.put(att.cms__Content__c, new List<cms__Attribute__c>());
                    }
                    content_attributes.get(att.cms__Content__c).add(att);
                    if(att.cms__Name__c == 'ImageId') {
                        attachment_ids.add(att.cms__Value__c.substringAfter('='));
                    }
                }
            }

            List<Attachment> attachmentList = [SELECT ContentType, BodyLength From Attachment WHERE id IN :attachment_ids];
            attachments = new Map<Id, Attachment>(attachmentList);
        }

    }

    /**
    * loadResponseRSS() called by apex pages with 'siteName' GET variable
    */
    public void loadResponseRSS(){
        siteName = System.currentPageReference().getParameters().get('siteName'); // GET variable
        // check if siteName is valid
        Set<String> siteNameList = new Set<string>();
        For (sObject site: this.siteObjectList) {
            siteNameList.add((String)site.get('cms__Site_Name__c'));
        }
        if (siteNameList.contains(siteName) == false) {
            siteName = null; //(String)this.siteObjectList[0].get('cms__Site_Name__c');
        }
        this.siteName = siteName; 
        
        // now set the domain now 
        For (sObject site: this.siteObjectList) {
            if ((String)site.get('cms__Site_Name__c') == this.siteName) {
                this.domain = (String)site.get('cms__Site_Domain__c');
                break;
            }
        }
        
        loadContentList();
        generateArticleRSS();
    }
    
    /**
    * loadResponseRSS() overladed to take siteName variable called by the SOAP service
    */
    public void loadFullResponseRSS(String siteName){
        // check if siteName is valid
        Set<String> siteNameList = new Set<string>();
        For (sObject site: this.siteObjectList) {
            siteNameList.add((String)site.get('cms__Site_Name__c'));
        }
        if (siteNameList.contains(siteName) == false) {
            siteName = null; //(String)this.siteObjectList[0].get('cms__Site_Name__c');
        }
        this.siteName = siteName; 
        
        // now set the domain now 
        For (sObject site: this.siteObjectList) {
            if ((String)site.get('cms__Site_Name__c') == this.siteName) {
                this.domain = (String)site.get('cms__Site_Domain__c');
                break;
            }
        }
        
        loadContentList(); // populates the classes contentList
        generateArticleRSS();
    }

    webService static String getArticleRSSFeedBySiteName(String siteName){ //IMPRV: perhaps remove BySiteName?
        ArticleRSS arss = new ArticleRSS();
        arss.loadFullResponseRSS(siteName); 
        return arss.response;
    }
}