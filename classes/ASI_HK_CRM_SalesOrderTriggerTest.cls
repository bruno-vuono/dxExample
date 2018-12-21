@isTest
/**********************************************************************************
 * Name : ASI_HK_CRM_SalesOrderTriggerTest
 * Created : 
 * Revision History:
 * 1. 19/09/2017 - [WL 1.0] testErrStrToTime does not exist in ASI_HK_CRM_SalesOrderAdjustDeliveryDate class
 **********************************************************************************/
public with sharing class ASI_HK_CRM_SalesOrderTriggerTest {
    
    private static ASI_HK_CRM_TestUtils.CommonData cmData;
    
    static {
        ASI_HK_CRM_TestUtils.initSOEssentialSettings();
        cmData = new ASI_HK_CRM_TestUtils.CommonData();
        ASI_HK_CRM_TestUtils.assignCreditAccountData(cmData, 3, 3);
        ASI_HK_CRM_TestUtils.assignSalesOrderData(cmData, 3, 3);
    }
        
    static testMethod void testMain() {
        Test.startTest();
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
        update so;
        Test.stopTest();
        delete so;
        undelete so;
    }
    

    static testMethod void testValidator() {
        Test.startTest();
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
        so.ASI_HK_CRM_Order_Status_Name__c = 'SA Approved';
        so.ASI_HK_CRM_Urgent_Order_Confirmed__c = 'No'; 
        so.ASI_HK_CRM_Urgent_Order__c = true;
        try{ update so;} 
        catch(exception e){}
        Test.stopTest();
    }    
    
    static testMethod void testDataManipulation() {
        Test.startTest();
        
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
        so.ASI_HK_CRM_Delivery_Window_Instruction__c = 'Before';
        so.ASI_HK_CRM_Delivery_Time_1__c = '08:00';
        so.ASI_HK_CRM_Payment_Method__c = 'CASH';
        update so;
        
        so.ASI_HK_CRM_Delivery_Window_Instruction__c = 'Between';
        update so;
        
        so.ASI_HK_CRM_Delivery_Time_1__c = '12:00';
        update so;
        
        so.ASI_HK_CRM_Delivery_Window_Instruction__c = 'Before';
        so.ASI_HK_CRM_Delivery_Time_1__c = '08:00';
        so.ASI_HK_CRM_Payment_Method__c = 'N/A';
        update so;
        
        Test.stopTest();
    }
    static testMethod void testDataManipulation2() {
        Test.startTest();
        
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
        so.ASI_HK_CRM_Delivery_Window_Instruction__c = 'Between';
        so.ASI_HK_CRM_Delivery_Time_1__c = '08:00';
        so.ASI_HK_CRM_Delivery_Time_2__c = '09:00';
        so.ASI_HK_CRM_Payment_Method__c = 'N/A';
        update so;
        
        ASI_HK_CRM_AccountGenerator accGen = new ASI_HK_CRM_AccountGenerator();
        Account acc_Potential = accGen.generateAccount(ASI_HK_CRM_AccountGenerator.RT_POTENTIAL);
        insert acc_Potential;
        so.ASI_HK_CRM_Account_PA__c = acc_Potential.id;
        update so;
        
        so.ASI_HK_CRM_Delivery_Time_2__c = null;
        update so;
                
        
        Test.stopTest();        
    }
   
    static testMethod void testUrgentOrder() {
        Test.startTest();
        
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
        so.ASI_HK_CRM_Urgent_Order__c = true;
        //update so;
        
        Test.stopTest();
    }
    
    static testMethod void testApproverAssign() {
        final String holdCode = 'Test';
        
        ASI_HK_CRM_Sales_Order__c so = [SELECT Id, Name FROM ASI_HK_CRM_Sales_Order__c WHERE Id = :cmData.so.Id];
        
        ASI_HK_CRM_RoutingTableGenerator rTableGen = new ASI_HK_CRM_RoutingTableGenerator();
        ASI_HK_CRM_SO_Routing_Table_Header__c rTableHeader = rTableGen.generateRoutingTableHeader();
        rTableHeader.Name = 'Test1';
        rTableHeader.ASI_HK_CRM_Field_API_Name_1__c = 'ASI_HK_CRM_Credit_Hold_Reason__c';
        rTableHeader.ASI_HK_CRM_Value_1__c = holdCode;
        insert rTableHeader;
        
        ASI_HK_CRM_SO_Routing_Table_Detail__c rTableDetail1 = rTableGen.generateRoutingTableDetail(rTableHeader, ASI_HK_CRM_RoutingTableGenerator.RT_DetailSpecificUser);
        rTableDetail1.ASI_HK_CRM_Approver_No__c = 1;
        String roleId = UserInfo.getUserRoleId();
        if (!String.isBlank(roleId)) {
            List<UserRole> uRole = [SELECT Id, DeveloperName FROM UserRole WHERE Id = :roleId];
            if (uRole.size() > 0)
                rTableDetail1.ASI_HK_CRM_Approver_Role_Name__c = uRole.get(0).DeveloperName;
        }
        rTableDetail1.ASI_HK_CRM_Approver__c = UserInfo.getUserId();
        rTableDetail1.ASI_HK_CRM_Jump_to_New_User__c = true;
        rTableDetail1.ASI_HK_CRM_Field_API_Name_1__c = 'Name';
        rTableDetail1.ASI_HK_CRM_Value_1__c = so.Name;
        
        ASI_HK_CRM_SO_Routing_Table_Detail__c rTableDetail2 = rTableGen.generateRoutingTableDetail(rTableHeader, ASI_HK_CRM_RoutingTableGenerator.RT_DetailUserField);
        rTableDetail2.ASI_HK_CRM_Approver_No__c = 2;
        rTableDetail2.ASI_HK_CRM_User_Field__c = 'ManagerId';
        rTableDetail2.ASI_HK_CRM_Field_API_Name_1__c = 'ASI_HK_CRM_User_D_O__c';
        rTableDetail2.ASI_HK_CRM_Value_1__c = '1';
        
        insert new ASI_HK_CRM_SO_Routing_Table_Detail__c[] {rTableDetail1, rTableDetail2};
        
        Test.startTest();
        
        so.ASI_HK_CRM_Credit_Hold_Reason__c = holdCode;
        so.ASI_HK_CRM_User_D_O__c = true;
        update so;
        
        Test.stopTest();
    }
    
    
    static testMethod void test_errorDelivery(){
        Test.startTest();
        try{
        ASI_HK_CRM_SalesOrderAdjustDeliveryDate soAdd = new ASI_HK_CRM_SalesOrderAdjustDeliveryDate();
        /*[WL 1.0 BEGIN]*/
		//soAdd.testErrStrToTime();
		/*[WL 1.0 END]*/
        }
        catch(exception e){}
        Test.stopTest();
        
    }
    
   /*static testMethod void test_soItemETLUpdate () {
        list<ASI_HK_CRM_Sales_Order_Item__c> soItems = cmData.soDetailList;
        list<ASI_HK_CRM_Sales_Order_Item__c> soItemsUpdate = new  list<ASI_HK_CRM_Sales_Order_Item__c>();
        for (ASI_HK_CRM_Sales_Order_Item__c soItem : soItems)
        {
            soItem.ASI_HK_CRM_Cancel_Qty__c = 1;
            soItemsUpdate.add(soItem);
        }
        update soItemsUpdate;
    }*/
/*    
    static testMethod void test_customException() {
        Test.startTest();
        ASI_HK_CRM_CustomException custExep = new ASI_HK_CRM_CustomException();
        //try{ASI_HK_CRM_CustomException custExep = new ASI_HK_CRM_CustomException();}
        //catch(exception e){}
        Test.stopTest();
    }    
*/
    
}