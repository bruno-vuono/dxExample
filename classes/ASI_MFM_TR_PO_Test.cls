@isTest
/*****************************
Tested Classes:
1. ASI_MFM_TR_PO_PDF_PageController
2. ASI_MFM_PO_SEND_PDF_Controller 
3. ASI_MFM_SetPOStatusController
4. ASI_MFM_PO_TriggerClass
5. ASI_MFM_TR_InputPOItemsPage_MassEdit
6. ASI_MFM_SelectPOPrefixController
7. ASI_MFM_SavePDFAsAttachment
*************************/
public class ASI_MFM_TR_PO_Test{
    private static string getFiscalYear(){
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;  //i.e. 7
        Date orgFiscalYear = Date.newinstance(system.today().year(), orgFiscalMonth, 1);    
        Datetime GMTdate = Datetime.now();
        String yearA1 = GMTdate.format('YY');
        Integer yearA0 = Integer.valueOf(yearA1) -1;
        Integer yearA2 = Integer.valueOf(yearA1) +1;
        String Current_Fiscal_year;

        if(system.today()< orgFiscalYear){
            Current_Fiscal_year = 'FY' + yearA0 + yearA1 ;
        }else{
            Current_Fiscal_year = 'FY' + yearA1 + yearA2 ;
        }
        
        return Current_Fiscal_year;
    }
    /*
    static testMethod void ASI_MFM_TR_PO_PDF_PageController_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
              Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');        
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
       ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), ASI_MFM_Route_Type__c=rt.id,name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        
        test.starttest();
        
        ASI_MFM_TR_PO_PDF_PageController ext = new ASI_MFM_TR_PO_PDF_PageController();
        ext.POID = po.id;
        ext.dummyVar = false;
        ext.dummyVar = true;
        ext.init();
        ext.ConvertDateTime(Datetime.now(), 'Month');
        ext.ConvertDateTime(Datetime.now(), 'Day');
        ext.ConvertDateTime(Datetime.now(), 'Hour');
        ext.ConvertDateTime(Datetime.now(), 'Min');
        ext.ConvertDateTime(Datetime.now(), 'Sec');
        ext.ConvertDateTime(Datetime.now(), null);
        ext.ConvertDateTime(null, null);
        
        test.stoptest();
    }
    static testMethod void ASI_MFM_PO_SEND_PDF_Controller_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
         Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');                    
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'),ASI_MFM_Route_Type__c=rt.id, name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        
        test.starttest();
        
        ApexPages.StandardController scons1 = new ApexPages.StandardController(po);
        ApexPages.currentPage().getParameters().put('id', scons1.getId());
        ASI_MFM_PO_SEND_PDF_Controller ext = new ASI_MFM_PO_SEND_PDF_Controller(scons1);
        ext.send();
        test.stoptest();
    }
    static testMethod void ASI_MFM_PO_SEND_PDF_Controller_GF_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
         Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');                     
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        
        test.starttest();
        
        ApexPages.StandardController scons1 = new ApexPages.StandardController(po);
        ApexPages.currentPage().getParameters().put('id', scons1.getId());
        ASI_MFM_PO_SEND_PDF_Controller ext = new ASI_MFM_PO_SEND_PDF_Controller(scons1);
        ext.send();
        test.stoptest();
    }
    static testMethod void ASI_MFM_SetPOStatusController1_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
        Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');              
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',ASI_MFM_Route_Type__c=rt.id,
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c =1,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
                test.starttest();
        system.debug(Limits.getDmlRows());
        ASI_MFM_PO_Receipt__c recp = new ASI_MFM_PO_Receipt__c(RecordTypeid=Global_RecordTypeCache.getRTid('ASI_MFM_PO_Receipt__cASI_MFM_TR_PO_Receipt'),ASI_MFM_Status__c='Draft');
        insert recp;
        recp.ASI_MFM_Status__c='Final';
        update recp;
        ASI_MFM_PO_Receipt_Item__c recpli = new ASI_MFM_PO_Receipt_Item__c(RecordTypeid=Global_recordtypecache.getRTid('ASI_MFM_PO_Receipt_Item__cASI_MFM_TR_PO_Receipt_item'),ASI_MFM_PO_Receipt__c=recp.id, ASI_MFM_PO__c=po.id,ASI_MFM_PO_Line_Item__c=poi.id);
        insert recpli;
        
        /*  ERROR: No applicable approval process found 
        //create Approval Process
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(po.Id);
        Approval.ProcessResult result1 = Approval.process(req1);
        
        List<Id> newWorkItemIds = result1.getNewWorkitemIds();
        
        system.debug('newWorkItemIds: ' + newWorkItemIds.size());
        if (newWorkItemIds.size() > 0){
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(newWorkItemIds.get(0));
            Approval.ProcessResult result2 =  Approval.process(req2);
        }
        */
/*
        ApexPages.StandardController scons = new ApexPages.StandardController(po);
        ApexPages.currentPage().getParameters().put('id', scons.getId());
        ApexPages.currentPage().getParameters().put('status', 'voided');
        ASI_MFM_SetPOStatusController conpdf = new ASI_MFM_SetPOStatusController(scons);
        conpdf.setStatus();
        
        test.stoptest();
    }
    static testMethod void ASI_MFM_SetPOStatusController2_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
        Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');               
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), ASI_MFM_Route_Type__c=rt.id,name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        
        test.starttest();
        
        ApexPages.StandardController scons1 = new ApexPages.StandardController(po);
        ApexPages.currentPage().getParameters().put('id', scons1.getId());
        ApexPages.currentPage().getParameters().put('status', 'Draft');
        ASI_MFM_SetPOStatusController conpdf1 = new ASI_MFM_SetPOStatusController(scons1);
        conpdf1.setStatus();
        test.stoptest();
    }*/
    /*
    static testMethod void ASI_MFM_SetPOStatusController3_Test() {
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_JP_Plan'), name='test',
                                                ASI_MFM_End_Date__c=Date.today().addMonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                                                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_JP_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_JP_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
        Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_JP_Customer'), Name='Name3');           
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_JP_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_JP_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
                                                                     ,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription');   
        insert pi;  
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
        
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id,Brand_MFM__c=brand1.id);
        insert rtbr;
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_JP_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Final',
                                             ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        test.startTest();
        
        ApexPages.StandardController scons1 = new ApexPages.StandardController(po);
        ApexPages.currentPage().getParameters().put('id', scons1.getId());
        ApexPages.currentPage().getParameters().put('status', 'Draft');
        ASI_MFM_SetPOStatusController conpdf1 = new ASI_MFM_SetPOStatusController(scons1);
        conpdf1.setStatus();
        
        test.stopTest();
        
    }
*/
    static testMethod void ASI_MFM_PO_TriggerClass_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
         Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');              
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        List<ASI_MFM_Route_Rule_Detail__c> rrdlist = new List<ASI_MFM_Route_Rule_Detail__c>();
        ASI_MFM_Route_Rule_Detail__c rrd1 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=1);
        ASI_MFM_Route_Rule_Detail__c rrd2 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=2);
        ASI_MFM_Route_Rule_Detail__c rrd3 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=3);
        ASI_MFM_Route_Rule_Detail__c rrd4 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=4);
        ASI_MFM_Route_Rule_Detail__c rrd5 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=5);
        ASI_MFM_Route_Rule_Detail__c rrd6 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=6);
        ASI_MFM_Route_Rule_Detail__c rrd7 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=7);
        ASI_MFM_Route_Rule_Detail__c rrd8 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=8);
        ASI_MFM_Route_Rule_Detail__c rrd9 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=9);
        rrdlist.add(rrd1);
        rrdlist.add(rrd2);
        rrdlist.add(rrd3);
        rrdlist.add(rrd4);
        rrdlist.add(rrd5);
        rrdlist.add(rrd6);
        rrdlist.add(rrd7);
        rrdlist.add(rrd8);
        rrdlist.add(rrd9);
        insert rrdlist;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;
        
        test.starttest();
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), ASI_MFM_Route_Type__c=rt.id, name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c =1,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        
        ASI_MFM_SavePDFAsAttachment.savePDF(po.id, po.Name, 'TR');
        /*
        ASI_MFM_PO_Receipt__c recp = new ASI_MFM_PO_Receipt__c(RecordTypeid=Global_RecordTypeCache.getRTid('ASI_MFM_PO_Receipt__cASI_MFM_TR_PO_Receipt'),ASI_MFM_Status__c='Final');
        insert recp;
        
        list<ASI_MFM_PO_Receipt_Item__c> recpliList = new list<ASI_MFM_PO_Receipt_Item__c>();
        ASI_MFM_PO_Receipt_Item__c recpli = new ASI_MFM_PO_Receipt_Item__c(RecordTypeid=Global_recordtypecache.getRTid('ASI_MFM_PO_Receipt_Item__cASI_MFM_TR_PO_Receipt_item'),ASI_MFM_PO_Receipt__c=recp.id, ASI_MFM_PO__c=po.id,ASI_MFM_PO_Line_Item__c=poi.id);
        recpliList.add(recpli);
        ASI_MFM_PO_Receipt_Item__c recpli1 = new ASI_MFM_PO_Receipt_Item__c(RecordTypeid=Global_recordtypecache.getRTid('ASI_MFM_PO_Receipt_Item__cASI_MFM_TR_PO_Receipt_item'),ASI_MFM_PO_Receipt__c=recp.id, ASI_MFM_PO__c=po.id,ASI_MFM_PO_Line_Item__c=poi.id);
        recpliList.add(recpli1);
        
        insert recpliList;
        */
        delete poi;
        delete po;
        
        
        test.stoptest();
    }
    
    static testMethod void ASI_MFM_TR_PO_TriggerClass_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        System.runAs(u){
            ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
            insert pr;
            
            ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
                                                    ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                                                    ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
            insert p;
            
            ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
            insert brand1;
            ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
            insert subBrand1;
            
            ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
            insert ac;
            ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
            insert ap;
            
            List<Account> accToInsert = new List<Account>();
            Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');              
            accToInsert.add(acc2);
            Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
            accToInsert.add(acc1);
            
            insert accToInsert;
            
            ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
            insert bu;
            
            ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
                                                                         ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
            insert pi;  
            system.debug('Linus check SQL no.: ' + Limits.getQueries() + ' & check limit SQL no: ' + Limits.getLimitQueries());
            ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
            insert pxo;
            
            ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
            insert rt;
            
            List<ASI_MFM_Route_Rule_Detail__c> rrdlist = new List<ASI_MFM_Route_Rule_Detail__c>();
            ASI_MFM_Route_Rule_Detail__c rrd1 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=1);
            ASI_MFM_Route_Rule_Detail__c rrd2 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=2);
            ASI_MFM_Route_Rule_Detail__c rrd3 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=3);
            ASI_MFM_Route_Rule_Detail__c rrd4 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=4);
            ASI_MFM_Route_Rule_Detail__c rrd5 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=5);
            ASI_MFM_Route_Rule_Detail__c rrd6 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=6);
            ASI_MFM_Route_Rule_Detail__c rrd7 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=7);
            ASI_MFM_Route_Rule_Detail__c rrd8 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=8);
            ASI_MFM_Route_Rule_Detail__c rrd9 = new ASI_MFM_Route_Rule_Detail__c(ASI_MFM_Approver__c=u.id, ASI_MFM_Minimum_Amount__c=0, ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Sequence__c=9);
            rrdlist.add(rrd1);
            rrdlist.add(rrd2);
            rrdlist.add(rrd3);
            rrdlist.add(rrd4);
            rrdlist.add(rrd5);
            rrdlist.add(rrd6);
            rrdlist.add(rrd7);
            rrdlist.add(rrd8);
            rrdlist.add(rrd9);
            insert rrdlist;
            
            ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
            insert rtm;
            
            ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
            insert pro;                   
            
            ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
            insert rtbr;
            
            date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
            ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
            insert podr;
            
            ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), ASI_MFM_Route_Type__c=rt.id, name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
                                                 ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()+1); 
            insert po;
            
            system.debug('Linus check SQL no.: ' + Limits.getQueries() + ' & check limit SQL no: ' + Limits.getLimitQueries());
            Test.startTest();
            
            ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c =1,
                                                                      ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                                                                      ASI_MFM_G_L_Date__c = Date.today());
            insert poi;
            
            
            system.debug('Linus check SQL no.: ' + Limits.getQueries() + ' & check limit SQL no: ' + Limits.getLimitQueries());
            po.ASI_MFM_Status__c = 'Submitted';
            update po;
            po.ASI_MFM_Status__c = 'Draft';
            update po;
			system.debug('Linus check SQL no.: ' + Limits.getQueries() + ' & check limit SQL no: ' + Limits.getLimitQueries());
            delete po;
            Test.stopTest();
        }
    }
    /*
    static testMethod void ASI_MFM_TR_InputPOItemsPage_MassEdit_TEST(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Location__c = 'hongkong', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id,ASI_MFM_TR_Rec_Type__c='ATR');
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP',ASI_MFM_TR_Rec_Type__c='ATR');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
         Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');    
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2',ASI_HK_CRM_Type__c='ATR');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO',ASI_MFM_TR_Rec_Type__c='ATR');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr; 
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), ASI_MFM_Route_Type__c=rt.id,name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        list<ASI_MFM_PO_Line_Item__c> liList = new list<ASI_MFM_PO_Line_Item__c>();
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c =1,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        liList.add(poi);
        
        ASI_MFM_PO_Line_Item__c poi1 = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c =1,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        liList.add(poi1);
        
        insert liList;
        
        test.starttest();

        ApexPages.StandardController scon = new ApexPages.StandardController(po);
        ApexPages.StandardsetController setcon = new ApexPages.StandardsetController(liList);
        ApexPages.currentPage().getParameters().put('id', po.id);
        ASI_MFM_TR_InputPOItemsPage_MassEdit con = new ASI_MFM_TR_InputPOItemsPage_MassEdit(setcon);
        con.pid = po.id;
        
        
        //con.rowObjAll.ASI_MFM_Customer_Name__c = 'testAbc';
        con.results.clear();
        con.ADDNEW();
        con.APPLY();
        con.DELETESELECTED() ;
        con.CLONESELECTED();
        con.ADDNEW();
        
        
        for (ASI_MFM_PO_Line_Item__c templist : liList){
            ASI_MFM_TR_InputPOItemsPage_MassEdit.POLineobj item1 = new ASI_MFM_TR_InputPOItemsPage_MassEdit.POLineobj();
            item1.ppl = templist;
            item1.selected = true;
            con.results.add(item1);
        }
        
        //Set searching variables
        con.SB_Name = 'subBrand1';
        con.AP_Code = 'testAP';
        
        
        con.search();
        con.getPOAmount();
        con.getAPCode('testAP', 'AP');
        con.getAPCOde('subBrand1', 'SB');
        con.APPLY();
        con.ADDNEW();
        con.CLONESELECTED();
        con.DELETESELECTED() ;
        
        for (ASI_MFM_PO_Line_Item__c templist : liList){
            ASI_MFM_TR_InputPOItemsPage_MassEdit.POLineobj item1 = new ASI_MFM_TR_InputPOItemsPage_MassEdit.POLineobj();
            item1.ppl = templist;
            item1.selected = true;
            con.results.add(item1);
        }
        con.CLONESELECTED();
        con.ADDNEW();
        con.Previous();
        con.Beginning();
        con.Next() ;
        con.End() ;
        con.getDisablePrevious() ;
        con.getDisableNext();
        //con.searchCurrentPage();
        con.onclickCheckbox();
        con.onclickAllCheckbox();
        for (ASI_MFM_PO_Line_Item__c templist : liList){
            ASI_MFM_TR_InputPOItemsPage_MassEdit.POLineobj item1 = new ASI_MFM_TR_InputPOItemsPage_MassEdit.POLineobj();
            item1.id = templist.Name;
            item1.APCode = templist.ASI_MFM_AP_Code__r.Name;
            item1.SBCode = templist.ASI_MFM_Sub_brand_Code__r.Name;
            item1.ppl = templist;
            item1.selected = true;
            con.results.add(item1);
        }
        con.save();
        con.quickSave();
        ASI_MFM_TR_InputPOItemsPage_MassEdit.findCustSObjects('Account','Commercial;c;ATR');
        ASI_MFM_TR_InputPOItemsPage_MassEdit.findSObjects('ASI_MFM_Sub_brand__c','WHERE ASI_MFM_Inactive__c = false and ASI_MFM_TR_Rec_Type__c = \'ATR\'');
        ASI_MFM_TR_InputPOItemsPage_MassEdit.findCustSObjects('Account','Commercial;c;JDF');        
        ASI_MFM_TR_InputPOItemsPage_MassEdit.findSObjects('ASI_MFM_Sub_brand__c','WHERE ASI_MFM_Inactive__c = false and ASI_MFM_TR_Rec_Type__c = \'JDF\'');
        ASI_MFM_TR_InputPOItemsPage_MassEdit.findRecSObjects('ASI_MFM_Sub_brand__c', 'WHERE ASI_MFM_Inactive__c = false', 'TR Sub-brand');
        test.stoptest();
    }
    
    static testmethod void ASI_MFM_SelectPOPrefixController_TEST(){
        
             ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 

        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
            
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Final');
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
        Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');           
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        insert bu;
        
        ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
            ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;
        /*
        User Auser = [SELECT id FROM User WHERE Profile.Name = 'System Administrator' AND isActive=true LIMIT 1];
        system.runAs(Auser){
            PermissionSet ps = [SELECT id FROM PermissionSet WHERE Name = 'ASI_TR_MFM_Admin_User'];
            if (ps != null){
                PermissionSetAssignment psA = new PermissionSetAssignment(PermissionSetId=ps.id,AssigneeId=Userinfo.getUserid());
                insert psA;
            }
        }*/
/*        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), ASI_MFM_Route_Type__c=rt.id, name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Draft',
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today()); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,
            ASI_MFM_Spread_by_Months__c=true,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;
        

        Test.startTest();

        System.runAs(u){
            ApexPages.currentPage().getParameters().put('pid',p.Id);
            ApexPages.currentPage().getParameters().put('POType','TEST');
            ApexPages.currentPage().getParameters().put('BudgetOwnerId','TEST');
            ApexPages.currentPage().getParameters().put('supplierId','TEST');
            ApexPages.currentPage().getParameters().put('RecordType','TEST');
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
            ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
            ASI_MFM_SelectPOPrefixController.getPrefixes();
            ASI_MFM_SelectPOPrefixController.proceed();
        }
        
        u.ASI_MFM_Country__c = null;
        update u;
        System.runAs(u){
            ApexPages.currentPage().getParameters().put('pid',p.Id);
            ApexPages.currentPage().getParameters().put('POType','TEST');
            ApexPages.currentPage().getParameters().put('BudgetOwnerId','TEST');
            ApexPages.currentPage().getParameters().put('supplierId','TEST');
            ApexPages.currentPage().getParameters().put('RecordType','TEST');
            
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
            ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
            ASI_MFM_SelectPOPrefixController.getPrefixes();
            ASI_MFM_SelectPOPrefixController.proceed();
        }
        
        Id roleId;
        System.runAs(new User(id = UserInfo.getUserId())){
            u.UserRoleId = null;
            update u;
        }
        System.runAs(u){
            ApexPages.currentPage().getParameters().put('pid',p.Id);
            ApexPages.currentPage().getParameters().put('POType','TEST');
            ApexPages.currentPage().getParameters().put('BudgetOwnerId','TEST');
            ApexPages.currentPage().getParameters().put('supplierId','TEST');
            ApexPages.currentPage().getParameters().put('RecordType','TEST');
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
            ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
            ASI_MFM_SelectPOPrefixController.getPrefixes();
            ASI_MFM_SelectPOPrefixController.proceed();
        }
         System.runAs(u){
            ApexPages.currentPage().getParameters().put('pid',p.Id);
            ApexPages.currentPage().getParameters().put('POType','TEST');
            ApexPages.currentPage().getParameters().put('BudgetOwnerId','TEST');
            ApexPages.currentPage().getParameters().put('supplierId','TEST');
            ApexPages.currentPage().getParameters().put('RecordType',null);
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
            ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
            ASI_MFM_SelectPOPrefixController.getPrefixes();
            ASI_MFM_SelectPOPrefixController.proceed();
        }
        
        Test.stopTest();
        
    }*/

    static testMethod void ASI_MFM_TR_CompletionPOController_Test(){
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', Plan_Type__c='test', ASI_MFM_Fiscal_year__c=getFiscalYear());
        insert px; 
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];  
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pr;
        
        ASI_MFM_Plan__c p = new ASI_MFM_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_TR_Plan'), name='test',
            ASI_MFM_End_Date__c=Date.today().addmonths(1), ASI_MFM_Plan_Description__c='testPlanDescription', 
                ASI_MFM_Plan_Name__c='testPlan', ASI_MFM_Start_Date__c=Date.today(), ASI_MFM_Prefix__c=px.id, ASI_MFM_Status__c = 'Draft',
                ASI_MFM_TR_PlanCompletionDate__c = Date.today(), ASI_MFM_Reference_1_List__c = 'CAPEX Plan', ASI_MFM_TR_Duration_Month__c = 24);
        insert p;
        
        ASI_MFM_Brand__c brand1 = new ASI_MFM_Brand__c(Name='Brand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_MFM_TR_Brand'));
        insert brand1;
        ASI_MFM_Sub_brand__c subBrand1 = new ASI_MFM_Sub_brand__c(Name='subBrand1', recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_MFM_TR_Sub_brand'), ASI_MFM_Brand__c=brand1.id);
        insert subBrand1;
        
        ASI_MFM_A_C_Code__c ac = new ASI_MFM_A_C_Code__c(name='testAC');
        insert ac;
        ASI_MFM_AP_Code__c ap = new ASI_MFM_AP_Code__c(name='testAP');
        insert ap;
        
        List<Account> accToInsert = new List<Account>();
        Account acc2 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Customer'), Name='Name3', ASI_HK_CRM_Location__c='hongkong');              
        accToInsert.add(acc2);
        Account acc1 = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_TR_Supplier'),Name='Name2');           
        accToInsert.add(acc1);
        
        insert accToInsert;
        
        // ASI_MFM_BU__c bu = new ASI_MFM_BU__c(Recordtypeid=Global_recordtypecache.getrtid('ASI_MFM_BU__cASI_MFM_TR_BU'), name='test', ASI_MFM_BU_Description__c='hongkong');
        // insert bu;
        
        // ASI_MFM_Plan_Line_Item__c pi = new ASI_MFM_Plan_Line_Item__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_TR_Plan_Line_Item'), ASI_MFM_Plan__c=p.id
        //     ,ASI_MFM_Total_Cost__c=0,ASI_MFM_Sub_brand_Code__c = subBrand1.id,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_List_Item_Description__c='testDescription',ASI_MFM_BU_Code__c=bu.id);   
        // insert pi;  

        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='PO');
        insert pxo;
         
        ASI_MFM_Route_Type__c rt = new ASI_MFM_Route_Type__c(name='testRT',ASI_MFM_Module__c='PO',ASI_MFM_ByPassThreshold__c=true);
        insert rt;
        
        ASI_MFM_Brand_Route_Type_Map__c rtm = new ASI_MFM_Brand_Route_Type_Map__c(ASI_MFM_Route_Type__c=rt.id,ASI_MFM_Responsible_By__c=u.id,ASI_MFM_Prefix__c=pxo.id );
        insert rtm;
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;                   
        
        ASI_MFM_Route_Type_Brands_Relationship__c rtbr= new ASI_MFM_Route_Type_Brands_Relationship__c(ASI_MFM_Route_Type__c=rt.id);
        insert rtbr;
        
        date startDate = date.newInstance(Date.Today().Year(), Date.Today().Month(), 1);
        ASI_MFM_PO_Date_Range__c podr = new ASI_MFM_PO_Date_Range__c(Name='testPODR',ASI_MFM_PO_Start_Date__c=startDate,ASI_MFM_PO_End_Date__c=startDate.addDays(30),ASI_MFM_GL_Date__c=Date.today(),asi_mfm_next_number__c=1,ASI_MFM_Fiscal_Period__c='201404');
        insert podr;

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId = Global_RecordTypeCache.getRTId('ASI_MFM_PO__cASI_MFM_TR_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Status__c='Final',ASI_MFM_Route_Type__c=rt.id,
            ASI_MFM_Plan__c = p.id,ASI_MFM_Supplier_Name__c = acc1.id, ASI_MFM_Responsible_By__c=u.id,ASI_MFM_PO_Raised_Date__c=Date.today(),ASI_MFM_PO_Start_Date__c=Date.today(),ASI_MFM_PO_End_Date__c=Date.today(),
            ASI_MFM_Reference_2__c = 'CAPEX', ASI_MFM_Invoice_Amount_from_JDE__c=8000); 
        insert po;
        
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_TR_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c =10000,ASI_MFM_Base_Currency_Amount__c=10000,
            ASI_MFM_Spread_by_Months__c=false,ASI_MFM_A_C_Code__c=ac.id,ASI_MFM_AP_Code__c=ap.id, ASI_MFM_Customer_Name__c=acc2.id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=subBrand1.id, 
                ASI_MFM_G_L_Date__c = Date.today());
        insert poi;

        test.starttest();

        PageReference testPage = new pagereference('/apex/ASI_MFM_TR_CompletionPOPage');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('pID', p.Id);
        ASI_MFM_TR_CompletionPOController cont = new ASI_MFM_TR_CompletionPOController();
        PageReference pageref = cont.doComplete();
        PageReference pageref2 = cont.cancel();
        
        test.stoptest();
    }
}