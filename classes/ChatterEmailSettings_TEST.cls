@isTest
private class ChatterEmailSettings_TEST {    
static testMethod void ChatterEmailSettings_test() {
         User user = new User(
            Username = 'testEmailSetting@demo.com',
            Email = 'testEmailSetting@demo.com',
            LastName = 'test',
            Alias = 'test5',
            ProfileID = '00eD0000001Aezg',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8'
         );
        insert user;

}        
}