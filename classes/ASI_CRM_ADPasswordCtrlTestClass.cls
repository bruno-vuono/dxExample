@istest
public class ASI_CRM_ADPasswordCtrlTestClass { // Test Class : ASI_CRM_ADPasswordController
	 static testMethod void TestMainClass(){
         Test.startTest();
         ASI_CRM_ADPasswordController ext = new ASI_CRM_ADPasswordController();
         ext.save();
         ext.ResetPassword();
         Test.stopTest();
     }
         
}