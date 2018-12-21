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
private class MMPJ_TOPG_LoadMileStoneController_Test {
    
		private static  Datetime myDT = Datetime.now();
     	private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test-supervisor@pernod-ricard.com', email = mailPrefix+'-test-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        insert u;
        
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
        
        MMPJ_TOPG_ProjectMilestone__c miles = new MMPJ_TOPG_ProjectMilestone__c();
        miles.MMPJ_TOPG_A__c='Brand';
        miles.MMPJ_TOPG_Date__c= Date.newInstance(2016,12,12);
        miles.MMPJ_TOPG_MilestoneTitle__c ='Test miles';
        miles.MMPJ_TOPG_Project__c = project.id;
        miles.MMPJ_TOPG_MMPJ_Status__c='Planned';
        insert miles;
        MMPJ_TOPG_ProjectMilestone__c miles2 = new MMPJ_TOPG_ProjectMilestone__c();
        miles2.MMPJ_TOPG_A__c='Brand';
        miles2.MMPJ_TOPG_Date__c= Date.newInstance(2016,12,12);
        miles2.MMPJ_TOPG_MilestoneTitle__c ='Test miles2';
        miles2.MMPJ_TOPG_Project__c = project.id;
        miles2.MMPJ_TOPG_MMPJ_Status__c='Planned';
        
         
       MMPJ_TOPG_LoadMileStoneController mmpj = new MMPJ_TOPG_LoadMileStoneController();
           Test.startTest();
           mmpj.project=project;
           Boolean bool = mmpj.ShowSaveMessage;
           Boolean bool2 = mmpj.isEditMode;
           mmpj.getMilesFromCustom();
           mmpj.saveMilestones();
           mmpj.addMileStone();
           mmpj.deletetMileStone();
           mmpj.hideMilesStonePopup();
           mmpj.MoveUpMilesStones();
           mmpj.LeavingMilestones();
           mmpj.SelectedCounter= 0;
           mmpj.EditMileStones();
           mmpj.ChangeRACI();
           Test.stopTest();
    }
}