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
private class MMPJ_TOPG_ImageCarouselController_Test {
    private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-NPLsupervisor@pernod-ricard.com', email = mailPrefix+'-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        
        //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='testmarket';
        insert market;
        
         //create brand
         MMPJ_TOPG_BRAND__c brand = new MMPJ_TOPG_BRAND__c();
         brand.name='Martell';
         insert brand;
     
     
        //create outlet
        MMPJ_TOPG_Outlet__c outlet = new MMPJ_TOPG_Outlet__c();
        outlet.Name='test outlet';
        outlet.MMPJ_TOPG_Market__c=market.id;
        insert outlet;
      
      //create partner      
      MMPJ_TOPG_Partner__c partner = new MMPJ_TOPG_Partner__c();
      partner.Name='partner1';
      partner.MMPJ_TOPG_Market__c=market.id;
      insert partner;
      
      MMPJ_TOPG_BMC__c bmcTest = new MMPJ_TOPG_BMC__c ();
        bmcTest.name='bmcTest';
        //BTO => BMC : delete "brand & Market"
        //bmcTest.MMPJ_TOPG_Market__c=market.id;
        //bmcTest.MMPJ_TOPG_Brand__c=brand.id;
       insert bmcTest ;
     // create visit 
       MMPJ_TOPG_Visit__c visit = new MMPJ_TOPG_Visit__c();
       visit.name= 'test visit';
       visit.MMPJ_TOPG_StatementDate__c=date.newInstance(1990, 11, 21);
       visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit.MMPJ_TOPG_Bench_Currency__c='Euro';
       visit.MMPJ_TOPG_Market__c=market.id;
       visit.MMPJ_TOPG_Outlet__c=outlet.id;
       visit.MMPJ_TOPG_PARTNER__c=partner.id;
       visit.MMPJ_TOPG_BMC__c= bmcTest.id;
       insert visit; 
       
      //create attachment 
        Attachment a = new Attachment ();
        a.Name='test Attach';
        a.body= Blob.valueOf('Unit Test Attachment Body');
        a.parentId=visit.id;
        insert a;
        
          ApexPages.StandardController sc = new ApexPages.StandardController(a);
           MMPJ_TOPG_ImageCarouselController mmpj = new MMPJ_TOPG_ImageCarouselController();
           Test.startTest();
           mmpj.LoadAttachments();
           //mmpj.listAttachments;
           mmpj.UploadPicture();
           mmpj.snapshot_attachment.body=Blob.valueOf('&&##!');
           mmpj.snapshot_attachment.name='&&##!';
           mmpj.theVisitId='aKX250000000006GAZ';
           //mmpj.theVisitId=visit.id;
           mmpj.UploadPicture();
           mmpj.listAttachments=null;
           mmpj.LoadAttachments();
           Test.stopTest();
    }
}