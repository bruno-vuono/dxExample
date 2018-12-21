/**
    About
    -----
    Description: utils class for ESN_MB_UtilsUser_Test class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains utils for tests of ESN_MB_UtilsUser_Test class
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------  
	Update the test utils class depending on permission sets and not on custom user type anymore.
*/
public class ESN_MB_UtilsUser_Test_Utils {
    /*
    public static User createStandardUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User standardUser = new User(lastName = 'standardUser', alias = 'stdUser', email = 'stdUser@test.com', 
                                     username = 'stdUser@test.com', ESN_MB_UserType__c = 'Standard MyBrands User', 
                                     TimeZoneSidKey = 'GMT' , LocaleSidKey = 'fr_FR_EURO', EmailEncodingKey = 'ISO-8859-1', 
                                     ProfileId = p.Id, LanguageLocaleKey = 'en_US');
        Database.SaveResult result = Database.insert(standardUser);
        return standardUser;
    }
    
    public static User createBroadcasterUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User broadcasterUser = new User(lastName = 'broadcasterUser', alias='bcUser', email = 'bcUser@test.com', 
                                        username = 'bcUser@test.com', ESN_MB_UserType__c = 'MyBrands Broadcaster', 
                                        TimeZoneSidKey = 'GMT' , LocaleSidKey = 'fr_FR_EURO', EmailEncodingKey = 'ISO-8859-1', 
                                        ProfileId = p.Id, LanguageLocaleKey = 'en_US');
        Database.SaveResult result = Database.insert(broadcasterUser);
        return broadcasterUser;
    }
    
    public static User createMarketCoBrandManagerUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User MarketCoBrandManagerUser = new User(lastName = 'MarketCoBrandManagerUser', alias='mcbmUser', email = 'mcbmUser@test.com', 
                                                 username = 'mcbmUser@test.com', ESN_MB_UserType__c = 'Market Co Brand Manager', 
                                                 TimeZoneSidKey = 'GMT', LocaleSidKey = 'fr_FR_EURO', EmailEncodingKey = 'ISO-8859-1', 
                                                 ProfileId = p.Id, LanguageLocaleKey = 'en_US');
        Database.SaveResult result = Database.insert(MarketCoBrandManagerUser);
        return MarketCoBrandManagerUser;
    }
	*/
}