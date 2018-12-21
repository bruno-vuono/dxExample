@isTest
public class MMPJ_TOPG_CockPitInteractController_test {
     private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
 static testMethod void myUnitTest() {
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test@supervisor.com', email = mailPrefix+'-test@supervisor.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        
        //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='France ID';
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
        
        MMPJ_TOPG_CockPitInteractionController mmpj = new MMPJ_TOPG_CockPitInteractionController();
           Test.startTest();
           List <SelectOption> lstBrands =mmpj.AllBrands;
           List <SelectOption> lstMarkets =mmpj.AllMarkets;
           list <SelectOption> TheLstBrands = new list<SelectOption>();
           list <SelectOption> TheLstmarkets = new list<SelectOption>();
           TheLstBrands.add(new selectOption(brand.id,brand.name));
           TheLstmarkets.add(new selectOption(market.id,market.name));
           mmpj.listBrands = TheLstBrands;
           mmpj.listMarkets = TheLstmarkets;
           mmpj.SelectedBrands = new List <SelectOption>();
           mmpj.SelectedMarkets= new List <SelectOption>();
           mmpj.SelectedDate= Date.newInstance(2016,11,11);
           mmpj.SelectedBrands.add(new SelectOption(brand.id,brand.name));
           mmpj.SelectedMarkets.add(new SelectOption(market.id,market.name));
           mmpj.apply_Filter(); 
           Test.stopTest();
    }
}