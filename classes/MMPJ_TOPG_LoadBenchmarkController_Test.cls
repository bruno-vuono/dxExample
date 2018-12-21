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
private class MMPJ_TOPG_LoadBenchmarkController_Test {
	 private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-NPLsupervisor@pernod-ricard.com', email = mailPrefix+'-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
         //create brand
     MMPJ_TOPG_BRAND__c brand = new MMPJ_TOPG_BRAND__c();
     brand.name='Martell';
     insert brand;
     MMPJ_TOPG_BRAND__c brand2 = new MMPJ_TOPG_BRAND__c();
     brand2.name='Marque';
     insert brand2;
               //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='Mumm';
        insert market;
        
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
            //BTO => BMC : delete "Brand & market"
           // bmcTest.MMPJ_TOPG_Market__c=market.id;
           // bmcTest.MMPJ_TOPG_Brand__c=brand.id;
       insert bmcTest ;
  
     // create visit 
       MMPJ_TOPG_Visit__c visit = new MMPJ_TOPG_Visit__c();
       visit.name= 'test visit';
       visit.MMPJ_TOPG_StatementDate__c=date.newInstance(1990, 11, 21);
       //lkp to user
       visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit.MMPJ_TOPG_Outlet__c=outlet.id;
       visit.MMPJ_TOPG_PARTNER__c=partner.id;
       visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
       visit.MMPJ_TOPG_Market__c=market.id;
       visit.MMPJ_TOPG_Bench_Currency__c='Euro';
       visit.MMPJ_TOPG_BMC__c=bmctest.id;
       insert visit; 
                       
           MMPJ_TOPG_VolumeBench__c vol = new MMPJ_TOPG_VolumeBench__c();
           vol.name='test volume1';
           vol.MMPJ_TOPG_IsCompetitor__c=false;
           vol.MMPJ_TOPG_Visit__c =visit.id;
           insert vol;
           
           MMPJ_TOPG_VolumeBench__c vol2 = new MMPJ_TOPG_VolumeBench__c();
           vol2.name='test volume';
           vol2.MMPJ_TOPG_IsCompetitor__c=true;
           vol2.MMPJ_TOPG_Visit__c =visit.id;
           insert vol2;
           
           ApexPages.StandardController sc = new ApexPages.StandardController(vol);
           MMPJ_TOPG_LoadBenchmarkController mmpj = new MMPJ_TOPG_LoadBenchmarkController();
           Test.startTest();
           mmpj.BenchmarkBlob='Marque Benchmarck;Marque;Type alcool;Prix; \n Martell;Martell;VS;test; \n Martell;Martell;VSOP;\n Martell;Martell;MCB; \n Martell;Martell;XO; \n Martell;Remy Martin;VS; \n';
           mmpj.LoadStatement();
           mmpj.BenchmarkBlob='Marque Benchmarck;Marque;Type alcool;Prix; \n tt;tt;tt;tt; \n ';
           mmpj.LoadStatement();
           mmpj.errortitle ='';
           mmpj.errordetail ='';
           List <MMPJ_TOPG_VolumeBench__c >lst1 = mmpj.ListProductBench;
           List <MMPJ_TOPG_VolumeBench__c >lst2 = mmpj.ListCompetitorBench;
          map<string,set<string>> testmap1 = mmpj.mapBrenchmarkSetMark;
           map<string,map<string,map<string,decimal>>> testmap= mmpj.mapMarqueTypeAlcoholPrix;
           Test.stopTest();
    }
}