@isTest
public class ESN_MB_NOP_Homepage_Cx_Test3 {

    static testMethod void isBroadCasterUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Homepage_Cx.isBroadCasterUser();
        }
    }

    static testMethod void getIsBasicUserTest() {
        String northPlainsUrl = 'http://www.test.com';
		// Create a brand
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', northPlainsUrl);
		// Create a masterbrand product for the brand
        ESN_MB_NodePage__c productMasterbrand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createMasterbrand('productMasterbrand', 10.0, brand.Id);
        
        PageReference newReference = new PageReference(northPlainsUrl);
        newReference.getParameters().put('brandId', brand.Id);
        Test.setCurrentPage(newReference);
        
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        ESN_MB_NOP_Homepage_Cx homepage = new ESN_MB_NOP_Homepage_Cx();
        System.RunAs(standardUser) {
            boolean result = homepage.getIsBasicUser();
            System.assertEquals(true, result);
        }
    }
    
    static testMethod void isBroadCasterAssignedTest() {
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brandName', null);
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Homepage_Cx.isBroadCasterAssigned(brand.Id);
        }
    }

}