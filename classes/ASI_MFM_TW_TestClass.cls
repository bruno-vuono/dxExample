@isTest
public class ASI_MFM_TW_TestClass{
    static testMethod void ASI_MFM_TW_AccrualGenerationCtrlTest() {      
		//insert custom setting
        ASI_MFM_Setting__c setting = new ASI_MFM_Setting__c(ASI_MFM_TW_Accrual_PO_Generation_Day__c=1);
        insert setting;
		
		//insert custom object for setting 
		ASI_MFM_Settings__c settings = new ASI_MFM_Settings__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Settings__cASI_MFM_TW_Setting'),
																ASI_MFM_TW_Accrual_PO_Generation_Day__c = System.Today().day());
																

		insert settings;
		
        Test.startTest();
        
        PageReference pageRef = new Pagereference('/apex/ASI_MFM_TW_AccrualGenerationPage');
        Test.setCurrentPage(pageRef);
        ASI_MFM_TW_AccrualGenerationCtrl ext = new ASI_MFM_TW_AccrualGenerationCtrl();
        
        PageReference result;       
        
        result = ext.save();
        
        result = ext.generate();
        
        result = ext.refreshStatus();
		
		ext.mfmSetting.ASI_MFM_TW_Accrual_PO_Generation_Day__c = System.Today().day()+1;
		
        result = ext.save();
    }
}