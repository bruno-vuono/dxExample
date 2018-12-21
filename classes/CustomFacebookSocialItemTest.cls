/** Unit test for CustomFacebookSocialItemFactory
 * @author Marion Aubard (Sylpheo)
 * @version 1.0
 **/
@isTest
public class CustomFacebookSocialItemTest {

    /**
     *  If no Custom setting, no Social Item retrieved
     *  @since 1.0
     **/
    static testMethod void testCustomSettingDoesNotExist() {
        //CustomFacebookSocialItemFactory factory = new CustomFacebookSocialItemFactory();
        //factory.init();
        CustomFacebookSocialItemFactory.init();
        List<socialtv__Social_Item__c> items = [SELECT Id FROM socialtv__Social_Item__c];
        System.assertEquals(0, items.size());
    }
    
    /**
     *  If Custom setting, but no URL, no Social Item retrieved
     *  @since 1.0
     **/
    static testMethod void testFacebookURLDoesNotExist() {
        socialtv__Social_Configuration__c configuration = new socialtv__Social_Configuration__c();
        configuration.custom_facebook_api_url__c = null;
        insert configuration;
        
        socialtv__Channel__c channel = new socialtv__Channel__c();
        channel.Name = 'Facebook Channel';
        insert channel;
        
        socialtv__Social_Source__c source = new socialtv__Social_Source__c();
        source.Name = 'Facebook Source';
        source.socialtv__Channel__c = channel.Id;
        source.socialtv__Source_ID__c = 'sylpheo';
        source.socialtv__Quantity__c = 2;
        source.socialtv__Type__c = 'Facebook (Custom API)';
        insert source;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CustomFacebookMockHttpResponse());
        
        //CustomFacebookSocialItemFactory factory = new CustomFacebookSocialItemFactory();
        //factory.init();
        CustomFacebookSocialItemFactory.init();
        
        Test.stopTest();
        
        List<socialtv__Social_Item__c> items = [SELECT Id FROM socialtv__Social_Item__c];
        System.assertEquals(0, items.size());
    }
    
    /**
     *  If items retrieved, create Social Items
     *  @since 1.0
     **/
    static testMethod void testFacebookItemsCreated() {
        socialtv__Social_Configuration__c configuration = new socialtv__Social_Configuration__c();
        configuration.custom_facebook_api_url__c = 'http://www.test-api.com';
        insert configuration;
        
        socialtv__Channel__c channel = new socialtv__Channel__c();
        channel.Name = 'Facebook Channel';
        insert channel;
        
        socialtv__Social_Source__c source = new socialtv__Social_Source__c();
        source.Name = 'Facebook Source';
        source.socialtv__Channel__c = channel.Id;
        source.socialtv__Source_ID__c = 'sylpheo';
        source.socialtv__Quantity__c = 2;
        source.socialtv__Type__c = 'Facebook (Custom API)';
        insert source;
        
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CustomFacebookMockHttpResponse());
        
        // Step 1 : One element, so create one element
        
        //CustomFacebookSocialItemFactory factory = new CustomFacebookSocialItemFactory();
        //factory.init();
        CustomFacebookSocialItemFactory.init();
        
        
        List<socialtv__Social_Item__c> items = [SELECT Id FROM socialtv__Social_Item__c];
        for (socialtv__Social_Item__c item : items) {
            System.debug('(1) item ' + item);
        }
        System.assertEquals(1, items.size());
        
        // Step 2 : Two elements, one same and another, so create one element
        CustomFacebookMockHttpResponse.setStep(1);
        
        //factory.init();
        CustomFacebookSocialItemFactory.init();
        
        items = [SELECT Id FROM socialtv__Social_Item__c];
        for (socialtv__Social_Item__c item : items) {
            System.debug('(2) item ' + item);
        }
        System.assertEquals(2, items.size());
        
        // Step 3 : Two elements, two sames and another, but quantity 2 so no creation
        CustomFacebookMockHttpResponse.setStep(2);
        
        //factory.init();
        CustomFacebookSocialItemFactory.init();
        
        items = [SELECT Id FROM socialtv__Social_Item__c];
        for (socialtv__Social_Item__c item : items) {
            System.debug('(3) item ' + item);
        }
        System.assertEquals(2, items.size());
        Test.stopTest();
    }
}