/**
    About
    -----
    Description: test class for ESN_MB_NOP_Brand_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_Brand_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_Brand_Cx_Test {

    static testMethod void retrieveListBrandActivationTest() {
        String imageRTId = ESN_MB_Utils.getRecordTypeId('ESN_MB_IMAGE');
        ESN_MB_Resource__c resource = ESN_MB_NOP_Homepage_Cx_Test_Utils.createImageResource('image.jpg', imageRTId, 'Tile');

        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        ESN_MB_Entry__c entry1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePageResourceEntry(brand, resource);
        
        Attachment attachment1 = ESN_MB_NOP_Homepage_Cx_Test_Utils.createAttachment('attachment1', resource);

        // Test method
        List<String> resultList = ESN_MB_NOP_Brand_Cx.retrieveLogosIds();
        System.assertEquals(1, resultList.size());
    }

    static testMethod void retrieveBrandNamesTest() {
        String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('brand1', brandRecordTypeId, 10.0);

        List<ESN_MB_NodePage__c> resultList = ESN_MB_NOP_Brand_Cx.retrieveBrandNames();
        System.assertEquals(1, resultList.size());
    }

    static testMethod void constructorTest() {
        ESN_MB_NOP_Brand_Cx cx = new ESN_MB_NOP_Brand_Cx();
        cx.getBrandNames();
        cx.getCurrentBrandStaticResource('brand');
        cx.getCurrentBrandCss('brand');
    }
    
    static testMethod void isBroadCasterUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Brand_Cx.isBroadCasterUser();
        }
    }
    static testMethod void isBasicUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Brand_Cx.isBasicUser();
        }
    }
    static testMethod void isBrandManagerUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Brand_Cx.isBrandManagerUser();
        }
    }
    static testMethod void getIsBasicUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        ESN_MB_NOP_Brand_Cx cx = new ESN_MB_NOP_Brand_Cx();
        System.RunAs(standardUser) {
            boolean result = cx.getIsBasicUser();
        }
    }
    static testMethod void getIsBroadCasterUserTest() {
        User standardUser = ESN_MB_NOP_Homepage_Cx_Test_Utils.getStandardUser();
        System.RunAs(standardUser) {
            boolean result = ESN_MB_NOP_Brand_Cx.getIsBroadCasterUser();
        }
    }
    static testMethod void getIsLeCercleBroadCasterTest() {
    	String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
		ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('LeCercle', brandRecordTypeId, 10.0);
		ESN_MB_NOP_Brand_Cx.getIsLeCercleBroadCaster();
    }
    static testMethod void getPortfolioBackgroundTest() {
		String brandRecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Brand');
		ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createNodePage('LeCercle', brandRecordTypeId, 10.0);
    	ESN_MB_NOP_Brand_Cx cx = new ESN_MB_NOP_Brand_Cx();
        cx.getPortfolioBackground();
    }
    static testMethod void retrieveBrandValuesTest() {
    	ESN_MB_NOP_Brand_Cx.retrieveBrandValues();
    }
}