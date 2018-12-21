/**
    About
    -----
    Description: Shared utilities user for MyBrand Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains methods for getting user custom informations
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------  
    Put all the strings into custom settings
*/

/*public with sharing*/
global class ESN_MB_UtilsUser{
        
   /**
    * Method getUserPS())
    * @return userPS: returns the permission sets of the user
    */
    @TestVisible private static List<String> getUserPS() {
        String userId = userInfo.getUserId();
        List<PermissionSetAssignment> permissionSets = [select PermissionSet.Name from PermissionSetAssignment where AssigneeId = :userId];
        List<String> userPS = new List<String>();
        for(PermissionSetAssignment ps : permissionSets) {
            userPS.add(ps.PermissionSet.Name);
        }        
        return userPS;
    }
    
   /**
    * Method isBroadcasterUser()
    * @return isBroadcasterBool: returns true if the user type has permission set ESN_MB_MyBrands_BroadCaster
    */
    public static boolean isBroadcasterUser() {
        boolean isBroadcasterBool = false;
        boolean isBasicUserBool = false;
        boolean isBrandManagerBool = false;
        List<String> userPS = getUserPS();
        for(String s : userPS){
            
            if(s == 'ESN_MB_MyBrands_BroadCaster') {
                isBroadcasterBool = true;
            }else if(s == 'ESN_MB_MyBrands_User') {
                isBasicUserBool = true;
            }
            else if(s == 'ESN_MB_MyBrands_BrandManager') {
                isBrandManagerBool = true;
            }
        }
        if(isBroadCasterBool && isBasicUserBool && isBrandManagerBool) {
            return true;
        }else if(isBroadCasterBool && !isBasicUserBool && !isBrandManagerBool) {
            return true;
        }else if(isBroadCasterBool && isBasicUserBool && !isBrandManagerBool) {
            return true;
        }else if(isBroadCasterBool && !isBasicUserBool && isBrandManagerBool) {
            return true;
        }else {
            return false;
        }
    }
    
    /**
    * Method isBrandManagerUser()
    * @return isBrandManagerBool: returns true if the user type has permission set ESN_MB_MyBrands_BrandManager
    */
    public static boolean isBrandManagerUser() {
        boolean isBroadcasterBool = false;
        boolean isBasicUserBool = false;
        boolean isBrandManagerBool = false;
        List<String> userPS = getUserPS();
        for(String s : userPS){

            // ABU : changement temporaire pour test
            if(s == 'ESN_MB_MyBrands_BroadCaster' || s == 'ESN_MB_MyBrands_BroadCasterClone') {
//            if(s == 'ESN_MB_MyBrands_BroadCaster') {
                isBroadcasterBool = true;
            }else if(s == 'ESN_MB_MyBrands_User') {
                isBasicUserBool = true;
            }
            else if(s == 'ESN_MB_MyBrands_BrandManager') {
                isBrandManagerBool = true;
            }
        }
        if(isBroadCasterBool && isBasicUserBool && isBrandManagerBool) {
            return true;
        }else if(!isBroadCasterBool && !isBasicUserBool && isBrandManagerBool) {
            return true;
        }else if(!isBroadCasterBool && isBasicUserBool && isBrandManagerBool) {
            return true;
        }else if(isBroadCasterBool && !isBasicUserBool && isBrandManagerBool) {
            return true;
        }else {
            return false;
        }
    }
    
    /**
    * Method isCockpitAdministrator()
    * @return isCockpitAdministrator: returns true if the user type has permission set ESN_MB_MyBrands_Cockpit_Administrator
    */
    public static boolean isCockpitAdministrator() {
        boolean isAdminBool = false;
        List<String> userPS = getUserPS();
        for(String s : userPS){
            // ABU : changement temporaire pour test
            if(s == 'ESN_MB_MyBrands_Cockpit_Administrator') {
                isAdminBool = true;
            }
        }
       return isAdminBool;
    }
    
    /**
    * Method isBasicUser()
    * @return isBasicUserBool: returns true if the user type has permission set ESN_MB_MyBrands_User
    */
    public static boolean isBasicUser() {
        return !ESN_MB_UtilsUser.isBrandManagerUser() && !ESN_MB_UtilsUser.isBroadcasterUser();
    }

    /**
    * Method isBroadcasterUser(String)
    * @return true if the user is a broadcaster and can edit elements (articles/activation) of a brand
    */
    public static boolean isBroadcasterUser(String brandId) {
        boolean result = false;

        if (ESN_MB_UtilsUser.isBroadcasterUser()) {
            result = isUserAssignedBrands(brandId);
        }
        return result;
    }
    public static boolean isBroadcasterManagerUser(String brandId) {
        boolean result = false;

        if (ESN_MB_UtilsUser.isBroadcasterUser()) {
            result = isUserAssignedBrands(brandId);
        } else { // managers have no limitations with assigned brands
            result = ESN_MB_UtilsUser.isBrandManagerUser();
        }
        return result;
    }

    /**
    * @return true if the user is a broadcaster and can edit elements (articles/activation) of a brand
    */
    private static boolean isUserAssignedBrands(String brandId) {
        boolean result = false;

        System.debug('brandId: ' + brandId);

        String userId = UserInfo.getUserId();
        String assignedBrands = [select ESN_MB_AssignedBrands__c from User where id = :userId].ESN_MB_AssignedBrands__c;

        if (String.isNotBlank(assignedBrands)) {
            String brandName = [select Name from ESN_MB_NodePage__c where id = :brandId].Name;

            if (assignedBrands.contains(brandName)) {
                result = true;
            }
        }
        System.debug('result: ' + result);
        return result;
    }

	/**
    * @return true if the user is owner of activation
    */
    public static boolean isBusinessActivationOwner(String activationId) {
        boolean result = false;

        String userId = UserInfo.getUserId();
        String activationOwner = [SELECT Id, OwnerId FROM ESN_MB_Activation__c WHERE Id = :activationId].OwnerId;

        if (String.isNotBlank(activationOwner)) {
			if (activationOwner.contains(userId)){
				result = true;
			}
        }
        return result;
    }
}