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
private class MMPJ_TOPG_NewVisitController_Test {
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
          Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-NPLsupervisor@pernod-ricard.com', email = mailPrefix+'-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US',BypassVR__c=true); 
       //System.runAs(u) {
        //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='mumm';
        insert market;
       
       //create brand
         MMPJ_TOPG_BRAND__c brand = new MMPJ_TOPG_BRAND__c();
     brand.name='Martell';
     insert brand;
     
        //create outlet
        MMPJ_TOPG_Outlet__c outlet = new MMPJ_TOPG_Outlet__c();
        outlet.Name='test outlet';
        outlet.MMPJ_TOPG_Market__c =market.id;
        insert outlet;
      
       MMPJ_TOPG_Outlet__c outlet2 = new MMPJ_TOPG_Outlet__c();
        outlet2.Name='test outlet';
        outlet2.MMPJ_TOPG_Market__c=market.id;
        //insert outlet;
      //create partner      
      MMPJ_TOPG_Partner__c partner = new MMPJ_TOPG_Partner__c();
      partner.Name='partner1';
      partner.MMPJ_TOPG_Market__c=market.id;
      insert partner;
  
     

       
       MMPJ_TOPG_BMC__c bmcTest = new MMPJ_TOPG_BMC__c ();
            bmcTest.name='bmcTest';
    		//BTO => delete Market fomr BMC
           // bmcTest.MMPJ_TOPG_Market__c=market.id;
           // bmcTest.MMPJ_TOPG_Brand__c=brand.id;
       insert bmcTest ;
       //lkp to user
       // create visit 
       MMPJ_TOPG_Visit__c visit = new MMPJ_TOPG_Visit__c();
       visit.name= 'test visit';
       visit.MMPJ_TOPG_StatementDate__c=date.newInstance(1990, 11, 21);
       visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit.MMPJ_TOPG_Outlet__c=outlet.id;
       visit.MMPJ_TOPG_PARTNER__c=partner.id;
       visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit.MMPJ_TOPG_BMC__c = bmcTest.id;
       visit.MMPJ_TOPG_Market__c= market.id;
       visit.MMPJ_TOPG_Bench_Currency__c='Euro';
       insert visit;
        
        MMPJ_TOPG_Meeting__c  meeting = new MMPJ_TOPG_Meeting__c ();
        meeting.MMPJ_TOPG_BMC__c = bmcTest.id;
        Meeting.MMPJ_TOPG_Interaction__c = 'test';
        insert meeting;
        
         MMPJ_TOPG_Visit__c visit2 = new MMPJ_TOPG_Visit__c();
       visit2.name= 'test visit2';
       visit2.MMPJ_TOPG_StatementDate__c=date.newInstance(1990, 11, 21);
       visit2.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit2.MMPJ_TOPG_Outlet__c=outlet.id;
       visit2.MMPJ_TOPG_PARTNER__c=partner.id;
       visit.MMPJ_TOPG_Market__c= market.id;
       visit2.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit2.MMPJ_TOPG_BMC__c = bmcTest.id;
       visit2.MMPJ_TOPG_Bench_Currency__c='Euro'; 
       
        ApexPages.StandardController sc = new ApexPages.StandardController(bmcTest);
           MMPJ_TOPG_NewVisitController mmpj = new MMPJ_TOPG_NewVisitController();
           Test.startTest();
            //mmpj.BMC =bmcTest;
            mmpj.editVisitId =visit.id;
            mmpj.meeting=meeting;
            mmpj.tempRichText='test';
            mmpj.ListVisits  = new list<MMPJ_TOPG_Visit__c >();
            mmpj.ListVisits.add(visit);
            mmpj.LoadVisits();
            mmpj.visitPopup =visit;
            mmpj.ShowVisitPopup();
            mmpj.editVisitId =visit.id;
            mmpj.AutomatePartnerFunction();
            mmpj.EditVisit();
            mmpj.outletPopup=outlet2;
            mmpj.hideVisitPopup();
            mmpj.NewOultetPopup();
            mmpj.SelectedRadioId =visit.id;
            mmpj.saveComment();
            mmpj.SaveOutlet();
            mmpj.SaveNewOutlet();
            mmpj.editVisitId =visit.id;
            mmpj.visitPopup=visit2;
            //mmpj.BMC=bmcTest;
            mmpj.SaveVisit();
            mmpj.SaveNewVisit();
            mmpj.DelVisit();
            Test.stopTest();
//}
}
}