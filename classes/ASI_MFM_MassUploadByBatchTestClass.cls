/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ASI_MFM_MassUploadByBatchTestClass {

    @isTest
    public static void ASI_MFM_MassUploadByBatch_Test(){
        Account a = new Account(name='test', PersonDoNotCall=false, recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_GF_Customer'));
        insert a;
        Contact c = new Contact(accountid=a.id,firstname='James',lastname='test', recordTypeId = Global_RecordTypeCache.getRtId('ContactASI_HK_CRM_Wholesalers_Outlets'));
        insert c;
        
        //Added by Introv @20170322 for TW CRM3
        ASI_MFM_Sub_brand__c sub = new ASI_MFM_Sub_brand__c(
            name = 'testSubBrand',
            ASI_CRM_TW_Company__c = 'PRT', 
            ASI_CRM_Active__c = TRUE, 
            ASI_TH_CRM_Active__c = TRUE,
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TW_Sub_brand')
        );
        insert sub;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_TW_Channel'), 
            Name = 'TOT (酒店)',
            ASI_CRM_CN_Channel_Code__c = 'TOT');
        insert channel;
        
        ASI_MFM_Sub_Channel__c subChannel = new ASI_MFM_Sub_Channel__c(
            Name = 'Piano Bar (PB)', 
            ASI_CRM_CN_Sub_Channel_Code__c = 'PB',
            ASI_CRM_CN_Channel__c = channel.id, 
            RecordTypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_Channel__cASI_CRM_TW_SubChannel'));
        insert subChannel;   
        
        ASI_TH_CRM_OutletType__c outletType = new ASI_TH_CRM_OutletType__c(
            RecordTypeid = Global_RecordTypeCache.getRtId('ASI_TH_CRM_OutletType__cASI_CRM_TW_Outlet_Type'),
            Name = 'PB (鋼琴酒吧)', 
            ASI_TH_CRM_Code__c = 'TW_PB',
            ASI_CRM_Sub_Channel__c = subChannel.id
        );
        insert outletType;
            
        List<Account> listAcc = new List<Account>();
        listAcc.add(new Account(
            RecordTypeid = Global_RecordTypeCache.getRtId('AccountASI_CRM_TW_Outlet'), 
            Name='TW Outlet', 
            ASI_TH_CRM_Region__c ='North',
            ASI_KOR_Customer_Code__c = 'EXID_123')
        );   
        listAcc.add(new Account(
            RecordTypeid = Global_RecordTypeCache.getRtId('AccountASI_TH_CRM_Outlet'), 
            Name='TH Outlet', 
            ASI_KOR_Customer_Code__c = 'EXID_123_TH')
        );   
        insert listAcc;
        
        List<ASI_CRM_AccountsAdditionalField__c> listAccountAdditionalField = new List<ASI_CRM_AccountsAdditionalField__c>();
        listAccountAdditionalField.add(new ASI_CRM_AccountsAdditionalField__c(
            RecordTypeid = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_TW_Outlet'),
            Name = 'Test Outlet', 
            ASI_CRM_Account__c = listAcc[0].id, 
            ASI_TH_CRM_OutletType__c = outletType.id, 
            ASI_CRM_Region__c = 'North',
            ASI_CRM_Channel__c = channel.id,
            ASI_CRM_CN_Sub_Channel__c = subChannel.id,
            ASI_CRM_City__c = 'Test City', 
            ASI_CRM_Town__c = 'Test Town', 
            ASI_CRM_TW_Street__c = 'Test Street', 
            ASI_CRM_TW_Number__c = '1', 
            ASI_CRM_TW_Floor__c = '12')
        );
        insert listAccountAdditionalField;
            
        List<ASI_FOC_Free_Goods_Request__c> listFGR = new List<ASI_FOC_Free_Goods_Request__c>();
        //POSM
        listFGR.add(new ASI_FOC_Free_Goods_Request__c(
            recordTypeId = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_CRM_TW_POSM_Request'),
            ASI_CRM_Target_Outlet__c = listAcc[0].Id,
            ASI_CRM_Receiver__c = 'Mary',
            ASI_CRM_SG_Order_Date__c = date.today(),
            ASI_CRM_Purpose__c = 'purpose')
        );
        insert listFGR;
        
        List<ASI_MFM_SKU_Code__c> listSKU = new List<ASI_MFM_SKU_Code__c>();
        listSKU.add(new ASI_MFM_SKU_Code__c(
            name = 'POSM SKU',
            ASI_HK_CRM_Active__c = TRUE,
            ASI_MFM_Sub_brand__c = sub.id,
            //ASI_MFM_Item_Group__c = listItemGp[0].id,
            ASI_HK_CRM_IsPOSProduct__c = TRUE,
            ASI_MFM_SKU_External_ID__c = 'EXID_123',
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_MFM_TW_SKU_Code'))
        );
        insert listSKU;
        
        ASI_MFM_Mass_Upload_Log__c uploadLog = new ASI_MFM_Mass_Upload_Log__c();
        insert uploadLog;
        //End by Introv @20170322 for TW CRM3
        
        //Added by Introv @20170411 for TH
        ASI_TH_CRM_Offtake_Stock_In_Trade__c offtakeSIT = new ASI_TH_CRM_Offtake_Stock_In_Trade__c();
        offtakeSIT.ASI_TH_CRM_Account__c = listAcc[1].id;
        offtakeSIT.ASI_TH_CRM_OfftakeSIT_External_ID__c = 'EXID_123';
        
        ASI_TH_CRM_Offtake_Stock_In_Trade__c offtakeSIT1 = new ASI_TH_CRM_Offtake_Stock_In_Trade__c();
        offtakeSIT.ASI_TH_CRM_Account__c = listAcc[1].id;
        offtakeSIT.ASI_TH_CRM_OfftakeSIT_External_ID__c = 'EXID123';
        insert offtakeSIT1;
        //Added by Introv @20170411 for TH
        
        test.startTest();
        ASI_MFM_MassUploadByBatchController controller = new ASI_MFM_MassUploadByBatchController();
        controller.emailNotification = true;
        controller.ObjAPIName = 'Contact';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'AccountID';
        controller.recordtypeName = 'contactType1';
        controller.fields = 'firstname,lastname,description,reportstoid,DoNotCall,Birthdate,reportstoid';
        controller.fieldsLabel = 'firstname,lastname,description,reportsto,DoNotCall,Birthdate,reportsto';
        controller.lookupEXID = 'contact/reportstoid:reportsto-lastname';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = 'birthdate:2013-01-01';
        controller.upsertMode = false;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.opt_allOrNone = false;
        
        controller.init();
        controller.filesize = 2000;
        controller.namefile = 'test.csv';
        controller.contentFile = blob.valueOf('firstname,lastname,description,DoNotCall,Birthdate,ASI_KOR_Venue_PR_Market_Share__c,reportsto\rJohn,Test,desc,Y,2013-08-01,test\rJohn,Test,desc,N,2013-08-01,test,10');
        controller.uploadCSVByBatch();
        controller.uploadCSV();
        
        
        controller.ObjAPIName = 'Account';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'ParentId';
        controller.recordtypeName = '';
        //controller.fields = 'name,NumberOfEmployees,AnnualRevenue,PersonDoNotCall,PersonBirthdate,PersonMobilePhone';
        controller.fields = 'PersonDoNotCall,PersonBirthdate,PersonMobilePhone';
        controller.fieldsLabel = 'DoNotCall,Birthdate,mobile';
        controller.lookupEXID = 'account/ParentId:ParentId-par';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = false;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.contentFile = blob.valueOf('name,,NumberOfEmployeesAnnualRevenue\rJohn,1,3');
        controller.emailNotification = true;
        controller.opt_allOrNone = false;
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        
        controller.ObjAPIName = 'Account';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'ParentId';
        controller.recordtypeName = '';
        controller.fields = 'name,NumberOfEmployees,AnnualRevenue';
        controller.fieldsLabel = 'name,NumberOfEmployees,AnnualRevenue';
        controller.lookupEXID = 'account/ParentId:ParentId-par';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = true;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.contentFile = blob.valueOf('name,,NumberOfEmployeesAnnualRevenue\rJohn,1,3');
        controller.emailNotification = true;
        controller.opt_allOrNone = false;
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        
        //Added by Introv @20170322 for TW CRM3
        controller.ObjAPIName = 'ASI_FOC_Request_Item__c';
        controller.parentID = String.valueof(uploadLog.id);
        controller.parentField = 'ASI_FOC_Request_Order__c';
        controller.recordtypeName = 'ASI CRM TW POSM Request Item';
        controller.fields = 'ASI_FOC_SKU__c,ASI_FOC_Request_Quantity_Bottle__c,ASI_CRM_Target_Outlet__c,ASI_CRM_Delivery_To__c,ASI_CRM_Delivery_Address__c,ASI_CRM_Delivery_Tel__c,ASI_CRM_Receiver__c';
        controller.fieldsLabel = 'SKU,Request Quantity(Bottle),Target Outlet,Delivery To,Delivery Address,Delivery Tel,Receiver';
        controller.lookupEXID = 'ASI_MFM_SKU_Code__c/ASI_FOC_SKU__c:FOC Recordtype&RecordTypeid,SKU&ASI_MFM_SKU_External_ID__c; Account/ASI_CRM_Target_Outlet__c:Target Recordtype&RecordTypeid,Target Outlet&ASI_KOR_Customer_Code__c;Account/ASI_CRM_Delivery_To__c:Delivery Recordtype&RecordTypeid,Delivery To&ASI_KOR_Customer_Code__c';
        controller.template = 'ASI_CRM_TW_POSM_Upload_Template';
        controller.currentPageURL = String.valueof(listFGR[0].id);
        controller.inlineVF = true;
        controller.DefaultValues = 'FOC Recordtype:TW SKU Code;Target Recordtype:Outlet (TW);Delivery Recordtype:Outlet (TW)';
        controller.upsertMode = true;
        controller.parentObjectAPIName = 'ASI_MFM_Mass_Upload_Log__c';
        controller.ParentObjectUploadMsg = 'ASI_MFM_Error_Message__c';
        controller.emailNotification = true;
        controller.opt_allOrNone = false;
        controller.recEXIDcol = 'Id';
        
        controller.contentFile = blob.valueOf('SKU,Request Quantity(Bottle),Target Outlet,Delivery To,Delivery Address,Delivery Tel,Receiver\rEXID_123,3,EXID_123,EXID_123,address,22223333,Mary');
        controller.uploadCSVByBatch();
        //End by Introv @20170322 for TW CRM3
        
        //Added by Introv @20170411 for TH
        controller.ObjAPIName = 'ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c';
        controller.parentID = String.valueof(offtakeSIT.id);
        controller.parentField = 'ASI_TH_CRM_SIT__c';
        controller.recordtypeName = 'ASI_TH_CRM_WS_Stock-In-Trade Detail';
        controller.fields = 'ASI_TH_CRM_Account__c,ASI_TH_CRM_Sub_brand__c,ASI_TH_CRM_Date__c,ASI_TH_CRM_Ending_Stock_Final__c,ASI_TH_CRM_OfftakeSITDetail_External_ID__c';
        controller.fieldsLabel = 'Customer Code,SubBrand Code,SIT Date,Ending Stock (Final),External ID';
        controller.lookupEXID = 'Account/ASI_TH_CRM_Account__c:Account Recordtype&RecordTypeid,Customer Code&ASI_KOR_Customer_Code__c;ASI_MFM_Sub_brand__c/ASI_TH_CRM_Sub_brand__c:SubBrand Recordtype&RecordTypeid,SubBrand Code&ASI_MFM_Sub_brand_External_ID__c';
        controller.template = 'ASI_TH_CRM_WS_Offtake_Template';
        controller.currentPageURL = String.valueof(offtakeSIT.id);
        controller.inlineVF = true;
        controller.DefaultValues = 'Account Recordtype:Wholesaler (TH);SubBrand Recordtype:TH CRM Sub-brand';
        controller.upsertMode = true;
        controller.parentObjectAPIName = 'ASI_MFM_Mass_Upload_Log__c';
        controller.ParentObjectUploadMsg = 'ASI_MFM_Error_Message__c';
        controller.emailNotification = true;
        controller.opt_allOrNone = false;
        controller.recEXIDcol = 'ASI_TH_CRM_OfftakeSITDetail_External_ID__c';
        
        controller.contentFile = blob.valueOf('Customer Code,SubBrand Code,SIT Date,Ending Stock (Final),External ID\rEXID_123,3,EXID_123,EXID_123,2/2/2017,1000,EXID123');
        controller.uploadCSVByBatch();
        //End by Introv @20170411 for TH
        
        
        test.stopTest();
    }
}