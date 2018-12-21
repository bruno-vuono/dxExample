@isTest
public with sharing class ASI_HK_CRM_PreApprovalFormDetailEditTest {
    
    static testMethod void test_pafEditPage(){
        Test.startTest();
        ASI_HK_CRM_AccountGenerator acctGenerator = new ASI_HK_CRM_AccountGenerator();
        ASI_HK_CRM_PreApprovalFormGenerator pafGenerator = new ASI_HK_CRM_PreApprovalFormGenerator();
        ASI_HK_CRM_PreApprovalFormItemGenerator paflineGenerator = new ASI_HK_CRM_PreApprovalFormItemGenerator();
        ASI_HK_CRM_SKUGenerator skuGenerator = new ASI_HK_CRM_SKUGenerator();
        ASI_HK_CRM_RunningNumberGenerator.initPAFRunningNumber();
        ASI_HK_CRM_BrandGenerator BrandGenerator = new ASI_HK_CRM_BrandGenerator(); 
        ASI_HK_CRM_SubBrandGenerator subBrandGenerator = new ASI_HK_CRM_SubBrandGenerator();
        
        //20160410, added by Leo
        ASI_CRM_HK_PAF_All_Product__c allPrdtSetting
            = new ASI_CRM_HK_PAF_All_Product__c(Name = 'All Product - Testing', ASI_CRM_HK_isActive__c = TRUE);
        insert allPrdtSetting;
        
        ASI_HK_CRM_Channel_Local_Channel_Map__c channel 
            = new ASI_HK_CRM_Channel_Local_Channel_Map__c(ASI_HK_CRM_Channel__c = '1JS - Japanese Store'
                                                          , ASI_HK_CRM_Local_Channel__c = 'F12 - Japanese Store'
                                                          , ASI_HK_CRM_Pricing_Channel__c = '1DL');
        insert channel;
        //20160410, added by Leo
        
        Account acctCredit = acctGenerator.generateAccount('ASI_HK_CRM_Outlet');    //Credit Account
        insert acctCredit;
        //System.debug('abc1'+acctCredit.id);
        
        /*Account acctPotential = acctGenerator.generateAccount('ASI_HK_CRM_Potential_Account');    //Credit Account
        insert acctPotential;*/
        
        ASI_HK_CRM_Pre_Approval_Form__c paf = pafGenerator.generatePreApprovalForm(acctCredit, 'ASI_HK_Pre_Approval_Form');        
        Insert paf;
        
        ASI_MFM_Brand__c Brand = brandGenerator.generateBrand(); 
        Insert Brand;
        
        ASI_MFM_Sub_brand__c subBrand = subBrandGenerator.generateSubBrand(Brand);
        Insert subBrand;
        
        ASI_MFM_SKU_Code__c sku = skuGenerator.generateBasicSKU(true);
        Insert sku;        
        
        /*ASI_MFM_SKU_Code__c sku2 = skuGenerator.generateBasicSKU(true);
        sku2.ASI_MFM_Sub_brand__c = subBrand.id;
        Insert sku2;*/

        ASI_MFM_SKU_Code__c sku3 = skuGenerator.generateBasicSKU(true);
        sku3.ASI_MFM_Sub_brand__c = subBrand.id;
        sku3.ASI_HK_CRM_IsPOSProduct__c = false;
        sku3.Name = allPrdtSetting.Name;
        Insert sku3;
        
        //List<ASI_MFM_SKU_Code__c> skuList = [select id, name from ASI_MFM_SKU_Code__c where ASI_MFM_Sub_brand__c <> null];
        
        ASI_HK_CRM_Pre_Approval_Form_Mechanic__c mech1 = new ASI_HK_CRM_Pre_Approval_Form_Mechanic__c();
        mech1.ASI_HK_CRM_Mechanic_Type__c = 'PAF Item - Fixed Amount';
        Insert mech1;
        
        ASI_HK_CRM_Pre_Approval_Form_Mechanic__c mech2 = new ASI_HK_CRM_Pre_Approval_Form_Mechanic__c();
        mech2.ASI_HK_CRM_Mechanic_Type__c = 'PAF Item - Variable';
        mech2.Name = 'V-On-Invoice Discount';
        Insert mech2;
        
        ASI_HK_CRM_Pre_Approval_Form_Item__c pafline = paflineGenerator.generateBasicPreApprovalFormItem(paf,sku);
        pafline.ASI_HK_CRM_Target_Volume_Qty__c = 50;
        pafline.ASI_HK_CRM_Price__c = 200;
        pafline.ASI_HK_CRM_Mechanic__c = mech1.Id;
        pafline.ASI_HK_CRM_Fixed_Amount__c = 5;
        insert pafline;
        
        ASI_HK_CRM_Pre_Approval_Form_Item__c pafline2 = paflineGenerator.generateBasicPreApprovalFormItem(paf,sku3);
        pafline2.ASI_HK_CRM_Mechanic__c = mech2.Id;
        pafline2.ASI_HK_CRM_Rebate_Disc_Percent__c = 5;
        pafline2.ASI_CRM_HK_All_Product__c = TRUE;
		pafline2.recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Pre_Approval_Form_Item__cASI_HK_CRM_PAF_Item_Variable');
        //insert pafline2;
        
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> paflineList = new List<ASI_HK_CRM_Pre_Approval_Form_Item__c>();
        paflineList.add(pafline);
        //paflineList.add(pafline2);
   
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(paflineList);
        
        PageReference testPage = Page.ASI_HK_CRM_PreApprovalFormDetailEditPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put('id', paf.id);
        Test.setCurrentPageReference(testPage);
        
        ASI_HK_CRM_PreApprovalFormDetailEditCON testController = new ASI_HK_CRM_PreApprovalFormDetailEditCON(stdSetController);
       
        //ASI_HK_CRM_PreApprovalFormDetailEditCON.lineItemList(testController.headerId);
        ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem pafChange;
        ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem pafChange2;
        List<ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem> pafChangeList = new List<ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem>();
        /*
        for(Integer i = 0; i <3; i++){
            pafChange = new ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem();
            pafChange.id= String.valueOf(i);
            pafChangeList.add(pafChange);
        }
        */
        
        pafChange = new ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem();
        pafChange.id = pafline.id;
        pafChange.skuId = pafline.ASI_HK_CRM_SKU_Lookup__c;
        pafChange.mechanicId = pafline.ASI_HK_CRM_Mechanic__c;
        pafChange.qty = pafline.ASI_HK_CRM_Target_Volume_Qty__c;
        pafChange.price = pafline.ASI_HK_CRM_Price__c;
        pafChange.allPrdt = pafline.ASI_CRM_HK_All_Product__c;
        pafChange2 = new ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem();
        pafChange2.id = pafline2.id;
        pafChange2.skuId = pafline2.ASI_HK_CRM_SKU_Lookup__c;
        pafChange2.mechanicId = pafline2.ASI_HK_CRM_Mechanic__c;
        pafChange2.qty = pafline2.ASI_HK_CRM_Target_Volume_Qty__c;
        pafChange2.price = pafline2.ASI_HK_CRM_Price__c;
        pafChange2.allPrdt = pafline2.ASI_CRM_HK_All_Product__c;
        pafChangeList.add(pafChange);
        pafChangeList.add(pafChange2);
        /*
        pafChange = new ASI_HK_CRM_PreApprovalFormDetailEditCON.ASI_HK_CRM_PAFLineItem();
        pafChange.id = paf.id;
        pafChangeList.add(pafChange);
        */
        ASI_HK_CRM_PreApprovalFormDetailEditCON.lineItemList(paf.id);
        ASI_HK_CRM_PreApprovalFormDetailEditCON.normalProductList(acctCredit.id);
        ASI_HK_CRM_PreApprovalFormDetailEditCON.saveChanges(paf.id, pafChangeList);
        testController.refreshPage();
        //ASI_HK_CRM_PreApprovalFormDetailEditCON.updateLineItemFromRemote(pafline, pafChange);
        
        Test.stopTest();
    }
}