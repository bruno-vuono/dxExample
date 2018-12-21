@isTest
public class ASI_CRM_MY_FOCRegen_TEST {

    static testMethod void focRegen_TEST() {
        
        User userA = ASI_CRM_MY_TestClassHelper.createUser();
        userA.BypassVR__c = TRUE;
        userA.BypassTriggers__c = 'ASI_CRM_MY_ContractTrigger';
        update userA;
        
        System.runAs(userA){

            Id idRTContractNormal = Global_RecordTypeCache.getRTId('ASI_TH_CRM_Contract__cASI_CRM_MY_Contract');
            
            ASI_CRM_MY_TestClassHelper.createMYSetting();
            ASI_CRM_MY_TestClassHelper.createRunningNumbers();
            ASI_CRM_AccountsAdditionalField__c customer1 = ASI_CRM_MY_TestClassHelper.createCustomer('customer1', 'ASI_CRM_AccountsAdditionalField__cASI_CRM_MY_Potential_Outlet');
            
            ASI_TH_CRM_Contract__c con = new ASI_TH_CRM_Contract__c(
                Name = 'Auto-generated Number', 
                ASI_TH_CRM_Start_Date__c = date.newinstance(1997, 7, 1),
                ASI_TH_CRM_End_Date__c = date.newinstance(2099, 2, 1),
                ASI_TH_CRM_Contract_Status__c = 'Draft',
                ASI_TH_CRM_Promotion_Type__c = 'Contract',
                ASI_CRM_CN_Outlet_WS__c = customer1.id,
                ASI_CRM_Version__c = '1',
                ASI_CRM_Obsolete_Version__c = FALSE,
                RecordTypeId = idRTContractNormal
            );
            insert con;
            
            //Create SKU
            ASI_MFM_SKU_Code__c sku1 = ASI_CRM_MY_TestClassHelper.createSKU('sku1');
            //Create AC code - Contract Setup Code
            ASI_CRM_MY_TestClassHelper.createContractSetupCode();
            
            ASI_CRM_ContractTarget__c ct = new ASI_CRM_ContractTarget__c(ASI_CRM_Contract__c = con.id, ASI_CRM_SKU__c = sku1.id, recordTypeid = Global_RecordTypeCache.getRTId('ASI_CRM_ContractTarget__cASI_CRM_MY_ContractTarget'));
            insert ct;
            
            ASI_CRM_ContractSalesStaffIncentive__c ss = new ASI_CRM_ContractSalesStaffIncentive__c(ASI_CRM_Contract__c = con.id, ASI_CRM_SKU__c = sku1.id, recordTypeid = Global_RecordTypeCache.getRTId('ASI_CRM_ContractSalesStaffIncentive__cASI_CRM_MY_SalesStaffIncentive'));
            insert ss;
            
            ASI_CRM_ContractVolumeIncentive__c vi = new ASI_CRM_ContractVolumeIncentive__c(ASI_CRM_Contract__c = con.id, ASI_CRM_SKU__c = sku1.id, ASI_CRM_Description__c = 'VOL', ASI_CRM_FOC__c = 11, ASI_CRM_SetupCode__c = 'VOLC', recordTypeid = Global_RecordTypeCache.getRTId('ASI_CRM_ContractVolumeIncentive__cASI_CRM_MY_VolumeIncentive'));
            insert vi;
            
            //Change the contract to Final status
            con.ASI_TH_CRM_Contract_Status__c = 'Final';
            update con;
            
            ASI_CRM_ActualOfftakeHeader__c Offtake_H = new ASI_CRM_ActualOfftakeHeader__c(ASI_CRM_ToOutlet__c = customer1.id, ASI_CRM_OfftakeDate__c= date.today().addmonths(-1), recordTypeid = Global_RecordTypeCache.getRTId('ASI_CRM_ActualOfftakeHeader__cASI_CRM_MY_ActualOfftakeHeader'));
            insert Offtake_H; 
                
            ASI_TH_CRM_Actual_Offtake__c Offtake_L = new ASI_TH_CRM_Actual_Offtake__c(ASI_CRM_ActualOfftakeHeader__c = Offtake_H.id, ASI_CRM_SKU__c = sku1.id, ASI_CRM_FromWS__c = customer1.id, ASI_TH_CRM_Quantity__c = 11, ASI_CRM_Price__c = 11, ASI_CRM_InvoiceDate__c = date.today().addmonths(-1), ASI_CRM_InvoiceNumber__c = 'INV01', recordTypeid = Global_RecordTypeCache.getRTId('ASI_TH_CRM_Actual_Offtake__cASI_CRM_MY_Actual_Offtake'));
            insert Offtake_L;
            
            Offtake_H.ASI_CRM_Status__c = 'Final';
            Offtake_H.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_ActualOfftakeHeader__cASI_CRM_MY_Actual_Offtake_Header_Read_Only');
            update Offtake_H;
            
            ASI_CRM_MY_FOCRegen_Ctl controller = new ASI_CRM_MY_FOCRegen_Ctl();
            controller.AOH1.ASI_CRM_ToOutlet__c = customer1.id;
            controller.AOH2.ASI_CRM_ToOutlet__c = customer1.id;
            controller.AOH3.ASI_CRM_ToOutlet__c = customer1.id;
            controller.AOH4.ASI_CRM_ToOutlet__c = customer1.id;
            controller.AOH5.ASI_CRM_ToOutlet__c = customer1.id;
            controller.strYear = String.valueOf(date.today().addMonths(-2).year());
            controller.strMonth = String.valueOf(date.today().addMonths(-2).month());
            
            controller.doSearch();
            controller.doChange();
            controller.doRegenFOC();
        }
    }
}