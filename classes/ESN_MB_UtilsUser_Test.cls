/**
    About
    -----
    Description: test class for ESN_MB_UtilsUser class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains unit tests for ESN_MB_UtilsUser class
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------  
	Update the test class depending on permission sets and not on custom user type anymore.
*/
@isTest
private class ESN_MB_UtilsUser_Test {
    
    /*
    * testMethod testGetUserType()
    * This method tests myBrands user type retrieving
    *
    static testMethod void testGetUserType() {
        User standardUser = ESN_MB_TestsUtils.createStandardUser();
        System.RunAs(standardUser) {
            String userType = ESN_MB_UtilsUser.getUserType();
            System.assertEquals('Standard MyBrands User', userType);
        }
    }
    
    /*
    * testMethod testIsBasicUser()
    * This method tests myBrands user type being standardUser
    *
    static testMethod void testIsBasicUser() {
        User standardUser = ESN_MB_TestsUtils.createStandardUser();
        system.RunAs(standardUser) {
            boolean isBasicUserBool = ESN_MB_UtilsUser.isBasicUser();
            System.assertEquals(true,isBasicUserBool);
        }
    }
    
    /*
    * testMethod testIsNotBasicUser()
    * This method tests myBrands user type not being standardUser
    *
    static testMethod void testIsNotBasicUser() {
        User bcUser = ESN_MB_TestsUtils.createBroadcasterUser();
        System.RunAs(bcUser) {
            boolean isBasicUserBool = ESN_MB_UtilsUser.isBasicUser();
            System.assertEquals(false,isBasicUserBool);
        }
    }
    
    /*
    * testMethod testIsBroadcasterUser()
    * This method tests myBrands user type being BroadcasterUser
    *
    static testMethod void testIsBroadcasterUser() {
        User bcUser = ESN_MB_TestsUtils.createBroadcasterUser();
        System.RunAs(bcUser) {
            boolean isBroadcasterBool = ESN_MB_UtilsUser.isBroadcaster();
            System.assertEquals(true,isBroadcasterBool);
        }
    }
    
    /*
    * testMethod testIsNotBroadcasterUser()
    * This method tests myBrands user type not being BroadcasterUser
    *
    static testMethod void testIsNotBroadcasterUser() {
        User standardUser = ESN_MB_TestsUtils.createStandardUser();
        System.RunAs(standardUser) {
           boolean isBroadcasterBool = ESN_MB_UtilsUser.isBroadcaster();
           System.assertEquals(false,isBroadcasterBool);
        }
    }
    
    /*
    * testMethod testIsMarketCoBrandManagerUser()
    * This method tests myBrands user type being MarketCoBrandManager
    *
    static testMethod void testIsMarketCoBrandManagerUser() {
        User mcbmUser = ESN_MB_TestsUtils.createMarketCoBrandManagerUser();
        System.RunAs(mcbmUser) {
            boolean isMarketCoBrandManagerBool = ESN_MB_UtilsUser.isMarketCoBrandManager();
            System.assertEquals(true,isMarketCoBrandManagerBool);
        }
    }
    
    /*
    * testMethod testIsNotMarketCoBrandManagerUser()
    * This method tests myBrands user type not being MarketCoBrandManager
    *
    static testMethod void testIsNotMarketCoBrandManagerUser() {
        
        User standardUser = ESN_MB_TestsUtils.createStandardUser();
        System.RunAs(standardUser) {
            boolean isMarketCoBrandManagerBool = ESN_MB_UtilsUser.isMarketCoBrandManager();
            System.assertEquals(false,isMarketCoBrandManagerBool);
        }
    }   
*/
}