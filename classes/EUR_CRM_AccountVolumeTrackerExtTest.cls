@isTest
public class EUR_CRM_AccountVolumeTrackerExtTest { 
	public static EUR_CRM_Account__c euaccount = new EUR_CRM_Account__c();
	public static EUR_CRM_Account_Volume_Tracker__c voltracker = new EUR_CRM_Account_Volume_Tracker__c();
	public static  EUR_CRM_Account_Volume_Tracker_Line_Item__c voltrackerLine = new  EUR_CRM_Account_Volume_Tracker_Line_Item__c();
	public static EUR_CRM_Brand__c brand = new EUR_CRM_Brand__c();
	public static EUR_CRM_Volume_Tracker_Period__c volTrackPeriod = new  EUR_CRM_Volume_Tracker_Period__c();
	public static EUR_CRM_Apex_Configuration__c apexConfig = new EUR_CRM_Apex_Configuration__c();
	public static User eurSysUser;
    public static void setUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='EUR System Admin']; 
        UserRole r = [select id from UserRole where Developername ='EMEA'];
        eurSysUser = new User(Alias = 'standt', Email='userEmail1234aoke@test.com', userroleid=r.id,
        EmailEncodingKey='UTF-8', LastName='userEmail1234aokelastName', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='userEmail1234aoke@test.com');
        insert eurSysUser; 

    }
	public static void testData(){
		apexConfig = EUR_CRM_RU_TestClassHelper.createApexConfig();
		insert apexConfig;
		euaccount = EUR_CRM_RU_TestClassHelper.createEUAccount('Test EU ACCOUNT');
		//euaccount = EUR_CRM_ZA_TestClassHelper.createEUAccount(1,'Test EU ACCOUNT', 'EUR_ZA_On_Trade_Indirect').get(0);
		system.debug('@@euaccount:'+euaccount);
        insert euaccount;

        system.assertNotEquals(euaccount, null);
        
        voltracker = new EUR_CRM_Account_Volume_Tracker__c(EUR_CRM_Account__c=euaccount.id);
        insert voltracker;
        
        brand = EUR_CRM_RU_TestClassHelper.createBrand(1, 'EUR_ZA_Brand', 'Test-Brand', '', null)[0];
        brand.EUR_CRM_Contributive_Margin_Brand__c = 0.5;
        brand.EUR_CRM_Enable_Account_Volume_Tracking__c = true;
        insert brand;
        
        voltrackerLine = new EUR_CRM_Account_Volume_Tracker_Line_Item__c(EUR_CRM_Account_Volume_Tracker__c=voltracker.id,EUR_CRM_Brand__c=brand.Id
        				);
      	insert voltrackerLine;  
      	
      	volTrackPeriod = new 	EUR_CRM_Volume_Tracker_Period__c(EUR_CRM_End_Date__c=date.today()+1,EUR_CRM_Start_Date__c=date.today(),EUR_CRM_Account_Volume_Tracker_Line_Item__c=voltrackerLine.Id,EUR_CRM_Volume_by_Bottles__c=2);
      	insert volTrackPeriod;			
	}
    static testMethod void myUnitTest1() {
    	setUser();
    	System.runAs(eurSysUser){
	         Test.startTest(); 
	         	testData();
	         	Test.setCurrentPageReference(new PageReference('Page.EUR_CRM_AccountVolumeTracker'));
            	System.currentPageReference().getParameters().put('IS_QUICK_SAVE', 'true');
	            ApexPages.StandardController sc = new ApexPages.StandardController(euaccount);
	            EUR_CRM_AccountVolumeTrackerExt AccountVolumeTrack = new EUR_CRM_AccountVolumeTrackerExt(sc);
	            List<EUR_CRM_Volume_Tracker_Period__c> periodList = new List<EUR_CRM_Volume_Tracker_Period__c>();
	            periodList.add(volTrackPeriod);
	            //AccountVolumeTrack.volTrackItemPeriodList.add(new EUR_CRM_AccountVolumeTrackerExt.VolumeTrackerItemPeriodWrapper(voltracker, periodList, null, null)); 

	            AccountVolumeTrack.volTrackItemPeriodList.add((new EUR_CRM_AccountVolumeTrackerExt.VolumeTrackerItemPeriodWrapper(voltrackerLine, periodList, volTrackPeriod.EUR_CRM_Start_Date__c, volTrackPeriod.EUR_CRM_End_Date__c))); 
	            
	            AccountVolumeTrack.addNewVolumePeriod();
	            AccountVolumeTrack.saveVolTracker(); 
	            List<EUR_CRM_Account_Volume_Tracker_Line_Item__c> volumeTrackerItemList = AccountVolumeTrack.volumeTrackerItemList;
	            AccountVolumeTrack.volumeTrackerObj = null;
	            AccountVolumeTrack.saveVolTracker(); 
				EUR_CRM_AccountVolumeTrackerExt.VolumeTrackerItemPeriodWrapper tracker = new EUR_CRM_AccountVolumeTrackerExt.VolumeTrackerItemPeriodWrapper(voltrackerLine, periodList, null, null);
				Decimal forecast = tracker.forecast;
	        	Decimal indexPercent = tracker.indexPercent;
	      		Decimal contractFromIndex = tracker.contractFromIndex;
	        	Decimal contractToIndex = tracker.contractToIndex;
	        	List<EUR_CRM_Account_Volume_Tracker_Line_Item__c> lines = new List<EUR_CRM_Account_Volume_Tracker_Line_Item__c>();
	        	lines.add(voltrackerLine);
	            AccountVolumeTrack.initVolumeTrackerPeriodExistWrapper(lines);
	         Test.stopTest();   
    	}	
    }
}