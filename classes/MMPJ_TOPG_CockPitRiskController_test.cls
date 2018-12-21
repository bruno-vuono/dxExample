@isTest
public class MMPJ_TOPG_CockPitRiskController_test {
    private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
 static testMethod void myUnitTest() {
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test@supervisor.com', email = mailPrefix+'-test@supervisor.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        
        //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='testmarket';
        insert market;
        //create brand 
        MMPJ_TOPG_Brand__c brand= new MMPJ_TOPG_brand__c();
        brand.Name='testBrand';
        insert brand;
        MMPJ_TOPG_Raid__c raid = new MMPJ_TOPG_Raid__c ();
        raid.MMPJ_TOPG_TechStartDate__c=Date.newInstance(2016,11,11);
        raid.MMPJ_TOPG_TechEndDate__c =Date.newInstance(2016,12,12);
        raid.MMPJ_TOPG_Title__c='test Raid';
        raid.MMPJ_TOPG_ExpectedDate__c =Date.newInstance(2016,12,12);
        raid.MMPJ_TOPG_Status__c = 'Planned';
        insert raid ;
        
        MMPJ_TOPG_CockPitRiskController mmpj = new MMPJ_TOPG_CockPitRiskController();
           Test.startTest();
           mmpj.SelectedBrands = new List <SelectOption>();
           mmpj.SelectedMarkets= new List <SelectOption>();
           mmpj.AllBrands = new List <SelectOption>();
     	   mmpj.AllMarkets = new List <SelectOption>();
           mmpj.StartDate= Date.newInstance(2016,11,11);
           mmpj.EndDate= Date.newInstance(2016,12,12);
           mmpj.AllBrands.add(new SelectOption('Martel','Martel'));
           mmpj.AllBrands.add(new SelectOption('Mumm','Mumm'));
           mmpj.SelectedBrands.add(new SelectOption('Mumm','Mumm'));
     	   mmpj.AllMarkets.add(new SelectOption('France','France'));
           mmpj.AllMarkets.add(new SelectOption('Japan','Japan'));
     	   mmpj.AllMarkets.add(new SelectOption('China','China'));
           mmpj.SelectedMarkets.add(new SelectOption('France','France'));
           mmpj.applySearch(); 
           Test.stopTest();
    }
}