@isTest

public class ASI_TnE_HK_ClaimHeader_Test {
    public static ASI_MFM_PO__c createPO(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c='FY1314');
        insert px;   
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_HK_Plan'), name='test',
            ASI_MFM_End_Date__c = Date.today().addMonths(1), ASI_MFM_Plan_Description__c = 'testDescription', 
                ASI_MFM_Plan_Name__c = 'planName test', ASI_MFM_Start_Date__c = Date.today(),  ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p; 
        
        List<Account> accList = new List<Account>();
        
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_HK_Supplier'),Name='Name2');           
        accList.add(acc1);
        Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'),Name='Name3');           
        accList.add(acc2);
        insert accList;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO'), name='test', ASI_MFM_Plan__c=p.id, ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Status__c = 'Final');
        insert po;  
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        
        ASI_MFM_Sub_brand__c sub = new ASI_MFM_Sub_brand__c(name='testSubBrand', ASI_MFM_Inactive__c = false, recordtypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_HK_CRM_Sub_brand'));
        insert sub;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_HK_PO_Line_Item'), ASI_MFM_PO__c=po.id, ASI_MFM_Quantity__c=10, ASI_MFM_Unit_Price__c=10, 
            ASI_MFM_Base_Currency_Amount__c = 9999, ASI_MFM_Amount__c = 9999,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=sub.id, ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        
       return po;
   }//End createPO method
    
    //Test : ASI_TnE_HK_ClaimHeaderTriggerClass
    static testMethod void ASI_TnE_HK_ClaimHeader_Test() {
    

        ASI_MFM_PO__c po = ASI_TnE_HK_ClaimHeader_Test.createPO();  
        update po;
		
		
        ASI_TnE_TestClassHelper.createTaxDateMapping();
        ASI_TnE_TestClassHelper.createRunningNumbers();

        
        test.startTest();
        ASI_TnE_ClaimHeader__c header = ASI_TnE_TestClassHelper.createTestClaimHeader('1234567','ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header');
        ASI_TnE_ClaimDetail__c detail = ASI_TnE_TestClassHelper.createClaimDetail(header.Id, 'ASI_TnE_ClaimDetail__cASI_TnE_HK_Claim_Detail', po.id, 10);

        //detail.ASI_TnE_MFM_PO__c = po.Id;
        //detail.ASI_TnE_Receipt_Amount__c = 100;
        //update detail;

        try{
            header.ASI_TnE_Status__c = 'Final';
            header.ASI_TnE_Export_to_AP_Voucher_GL__c=true;
            
            update header;
        }Catch(Exception e){
            system.debug('**Exception Update**' + e.getMessage());
            system.assert(e <> null);
            system.assert(e.getMessage().contains('Exceeding the PO#'));
        } 
        
        test.stopTest();
        
    }
    
}