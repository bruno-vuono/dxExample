/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MMPJ_TOPG_NewProjectExt_Test {
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
        
        
        MMPJ_TOPG_Project__c project2 = new MMPJ_TOPG_Project__c();
        project2.name = 'testProject2';
        project2.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project2.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project2.MMPJ_TOPG_ProjectOwner__c=u.id;
        project2.MMPJ_TOPG_ProjectType__c='Central Development';
        
        
        MMPJ_TOPG_Project__c project3 = new MMPJ_TOPG_Project__c();
        project3.name = 'testProject3';
        project3.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project3.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project3.MMPJ_TOPG_ProjectOwner__c=u.id;
        project3.MMPJ_TOPG_ProjectType__c='Central Development';
        
        //product mix
        MMPJ_TOPG_ProductMix__c prodMix = new MMPJ_TOPG_ProductMix__c();
        prodMix.Name='product_mix';
        insert prodMix; 
        
        // project market 
        MMPJ_TOPG_Project_Market__c projMarket = new MMPJ_TOPG_Project_Market__c ();
        projMarket.MMPJ_TOPG_Project__c=project.id;
        projMarket.MMPJ_TOPG_Market__c = market.id;
        insert projMarket; 
        system.debug(' projMarketin test classs == '+project.id);
        // project product 
        MMPJ_TOPG_Project_Product__c projectProd = new MMPJ_TOPG_Project_Product__c();
        projectProd.MMPJ_TOPG_Project__c=project.id;
        projectProd.MMPJ_TOPG_Product__c=prodMix.id;
        insert projectProd;
        system.debug(' projectProduct in test classs == '+projectProd);
        
        // project Brand 
        MMPJ_TOPG_Project_Brand__c projBrand = new MMPJ_TOPG_Project_Brand__c();
        projBrand.MMPJ_TOPG_Project__c=project.id;
        projBrand.MMPJ_TOPG_Brand__c = brand.id;
        insert projBrand ; 
        // insert project team member 
        MMPJ_TOPG_ProjectTeamMember__c teamMember = new MMPJ_TOPG_ProjectTeamMember__c();
        teamMember.MMPJ_TOPG_Title__c = 'team member 1';
        teamMember.MMPJ_TOPG_User__c = u.id;
        teamMember.MMPJ_TOPG_Who__c = u.id;
        teamMember.MMPJ_TOPG_Project__c = project.id;
        insert teamMember;
        
        MMPJ_TOPG_ProjectTeamMember__c teamMember2 = new MMPJ_TOPG_ProjectTeamMember__c();
        teamMember2.MMPJ_TOPG_Title__c = 'team member 2';
        teamMember2.MMPJ_TOPG_Contact__c= c.id;
        teamMember2.MMPJ_TOPG_Who__c = c.id;
        teamMember2.MMPJ_TOPG_Project__c = project.id;
        insert teamMember2;
        
        Test.StartTest();
        PageReference PageTest  = page.MMPJ_TOPG_NewProject;
        Test.setCurrentPage(PageTest);
        ApexPages.StandardController ProjectStdController = new ApexPages.StandardController(project);
        ApexPages.currentPage().getParameters().put('ID',project.id);
        MMPJ_TOPG_NewProjectExt  mmpj = new MMPJ_TOPG_NewProjectExt(ProjectStdController);
        mmpj.SetNewTabValue();
        Test.StopTest();
    }
}