/*********************************************************************************
 * Name:ASI_CRM_VN_AssignAutoNumber_Customer
 * Description: Class to Assign Custom Auto Number to CRM Code.            
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 29/10/2015       Neha Sonawane           Created
*********************************************************************************/

public with sharing class ASI_CRM_VN_AssignAutoNumber_Customer {

    public ASI_CRM_VN_AssignAutoNumber_Customer () {   
    }
    // Method to populate CRM code for Customer.
    public void populateCRMCode(List<ASI_CRM_AccountsAdditionalField__c> newCustomerList) {
    
        ASI_CRM_VN_AutoNumberAssignment autoNumAssign = null;
      
        for (ASI_CRM_AccountsAdditionalField__c customerObj : newCustomerList) {
            
            if (autoNumAssign == null) {
                autoNumAssign = new ASI_CRM_VN_AutoNumberAssignment(system.Label.ASI_CRM_VN_Customer_Code);
                customerObj.ASI_CRM_CN_CRM_Code__c = autoNumAssign.nextAutoNumStr();
            }
        }
        if (autoNumAssign != null)
            autoNumAssign.writeToDB();
    }
}