global with sharing class OCMS_RSSFeedTemplateController extends cms.ContentTemplateController{

    public String RSSFeedUrl {
      get {
          return getProperty('RSSFeedUrl');
      }
      set;
    }
    
    public String RSSFeedLimit {
      get {
          return getProperty('RSSFeedLimit');
      }
      set;
    }
     
    public String RandomId {
    get {
      try {
        return page_content_layout_instance.Id;
      }
      catch (Exception ex)
      {
        return '';
      }
    }
    set;
    }

    public Boolean OpenLinksInNewWindow {
        get {
            return '1' == getProperty('OpenLinksInNewWindow');
        }
    }
    
    global override String getHTML(){
        return '';
    }

    public OCMS_RSSFeedTemplateController() {}
   
    @IsTest(SeeAllData=true)
    public static void testRSSFeedTemplateControler(){

        OCMS_RSSFeedTemplateController objRight = new OCMS_RSSFeedTemplateController();        
        System.assertEquals(null, objRight.RSSFeedUrl);
        System.assertEquals(null, objRight.RSSFeedLimit);
        String testRandomId = objRight.RandomId;
        String html = objRight.getHTML();   
        Boolean blink = objRight.OpenLinksInNewWindow;
    }   
}