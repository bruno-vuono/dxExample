@isTest
public class MMPJ_TOPG_ProjectDescPDFCtrl_test{
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void myUnitTest() {
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test-supervisor@pernod-ricard.com', email = mailPrefix+'-test-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        insert u;
        
        Contact c = new Contact();
        c.LastName='Test Contact';
        c.FirstName='Test Contact';
        insert c;
         //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='France ID';
        insert market;
        //create brand 
        MMPJ_TOPG_Brand__c brand= new MMPJ_TOPG_brand__c();
        brand.Name='testBrand';
        insert brand;
        
         //insert project 
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert project;
        
        Test.StartTest();
        Pagereference PageTest = Page.MMPJ_TOPG_ProjectDescriptionPDF;
        Test.setCurrentPage(PageTest);
        ApexPages.currentPage().getParameters().put('ProjectId',project.id);
        MMPJ_TOPG_ProjectDescriptionPDFCtrl ctrl = new MMPJ_TOPG_ProjectDescriptionPDFCtrl();
        Test.StopTest();
    }
}