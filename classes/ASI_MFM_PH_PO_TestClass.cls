@isTest
private class ASI_MFM_PH_PO_TestClass {
   //---------------ASI_MFM_SelectPOPrefixController -------------------Start --------------------
    
      static testMethod void testPODFPrefix()
    {
        //DF :  2 PO Prefix with 2 DF
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', ASI_MFM_Fiscal_year__c=ASI_MFM_PH_TestClassHelper.getFiscalYear());
        prefixList.add(px);
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='DFPHPO1', ASI_MFM_Module__c='PO');
        prefixList.add(pxo);
        ASI_MFM_Prefix__c pxa = new ASI_MFM_Prefix__c(name='DFPHPO2', ASI_MFM_Module__c='PO');
        prefixList.add(pxa);
        insert prefixList;
        
        //User
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        u.ASI_MFM_Country__c = 'PH';
        update u;
        
        // Role Prefix Relationship
        List<ASI_MFM_Role_Prefix_Relationship__c> RPList = new List<ASI_MFM_Role_Prefix_Relationship__c>();
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pr);
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pro);
        ASI_MFM_Role_Prefix_Relationship__c pra = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxa.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pra);
        insert RPList;
     
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DF_Plan'), ASI_MFM_Prefix__c=px.id, ASI_MFM_Start_Date__c=date.today(), ASI_MFM_End_Date__c=date.today().addMonths(1), ASI_MFM_Status__c = 'Final');
        insert plan;
       

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DF_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Plan__c=plan.id); //    Final
        insert po;
        
        ApexPages.currentPage().getParameters().put('pid',po.ASI_MFM_Plan__c);
        ApexPages.currentPage().getParameters().put('RecordType',Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DF_PO') );
	
            
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
        ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
        ASI_MFM_SelectPOPrefixController.getPrefixes();
        ASI_MFM_SelectPOPrefixController.proceed();
    
    }
    
    
    
      static testMethod void testPODFPrefix2()
    {
        //DF :  2 PO Prefix with one DF
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', ASI_MFM_Fiscal_year__c=ASI_MFM_PH_TestClassHelper.getFiscalYear());
        prefixList.add(px);
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='DFPHPO1', ASI_MFM_Module__c='PO');
        prefixList.add(pxo);
        ASI_MFM_Prefix__c pxa = new ASI_MFM_Prefix__c(name='PHPO2', ASI_MFM_Module__c='PO');
        prefixList.add(pxa);
        insert prefixList;
        
        //User
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        u.ASI_MFM_Country__c = 'PH';
        update u;
        
        // Role Prefix Relationship
        List<ASI_MFM_Role_Prefix_Relationship__c> RPList = new List<ASI_MFM_Role_Prefix_Relationship__c>();
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pr);
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pro);
        ASI_MFM_Role_Prefix_Relationship__c pra = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxa.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pra);
        insert RPList;
     
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DF_Plan'), ASI_MFM_Prefix__c=px.id, ASI_MFM_Start_Date__c=date.today(), ASI_MFM_End_Date__c=date.today().addMonths(1), ASI_MFM_Status__c = 'Final');
        insert plan;
       

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DF_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Plan__c=plan.id); //    Final
        insert po;
        
        ApexPages.currentPage().getParameters().put('pid',po.ASI_MFM_Plan__c);
         string tempid=String.valueOf(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DF_PO')).substring(0,15);
        ApexPages.currentPage().getParameters().put('RecordType',tempid );
	
            
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
        ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
        ASI_MFM_SelectPOPrefixController.getPrefixes();
        ASI_MFM_SelectPOPrefixController.proceed();
    
    }
    
    
      static testMethod void testPODPPrefix()
    {
        //DP :  2 PO Prefix with 2 DP
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', ASI_MFM_Fiscal_year__c=ASI_MFM_PH_TestClassHelper.getFiscalYear());
        prefixList.add(px);
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='DPPHPO1', ASI_MFM_Module__c='PO');
        prefixList.add(pxo);
        ASI_MFM_Prefix__c pxa = new ASI_MFM_Prefix__c(name='DPPHPO2', ASI_MFM_Module__c='PO');
        prefixList.add(pxa);
        insert prefixList;
        
        //User
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        u.ASI_MFM_Country__c = 'PH';
        update u;
        
        // Role Prefix Relationship
        List<ASI_MFM_Role_Prefix_Relationship__c> RPList = new List<ASI_MFM_Role_Prefix_Relationship__c>();
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pr);
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pro);
        ASI_MFM_Role_Prefix_Relationship__c pra = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxa.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pra);
        insert RPList;
     
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DP_Plan'), ASI_MFM_Prefix__c=px.id, ASI_MFM_Start_Date__c=date.today(), ASI_MFM_End_Date__c=date.today().addMonths(1), ASI_MFM_Status__c = 'Final');
        insert plan;
       

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DP_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Plan__c=plan.id,ASI_MFM_Tax_Rate__c='12%'); 
        insert po;
        
        ApexPages.currentPage().getParameters().put('pid',po.ASI_MFM_Plan__c);
        ApexPages.currentPage().getParameters().put('RecordType',Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DP_PO') );
	
            
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
        ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
        ASI_MFM_SelectPOPrefixController.getPrefixes();
        ASI_MFM_SelectPOPrefixController.proceed();
    
    }
    
    
    
      static testMethod void testPODPPrefix2()
    {
        //DP :  2 PO Prefix with one DP
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', ASI_MFM_Fiscal_year__c=ASI_MFM_PH_TestClassHelper.getFiscalYear());
        prefixList.add(px);
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='DPPHPO1', ASI_MFM_Module__c='PO');
        prefixList.add(pxo);
        ASI_MFM_Prefix__c pxa = new ASI_MFM_Prefix__c(name='PHPO2', ASI_MFM_Module__c='PO');
        prefixList.add(pxa);
        insert prefixList;
        
        //User
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        u.ASI_MFM_Country__c = 'PH';
        update u;
        
        // Role Prefix Relationship
        List<ASI_MFM_Role_Prefix_Relationship__c> RPList = new List<ASI_MFM_Role_Prefix_Relationship__c>();
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pr);
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pro);
        ASI_MFM_Role_Prefix_Relationship__c pra = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxa.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pra);
        insert RPList;
     
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DP_Plan'), ASI_MFM_Prefix__c=px.id, ASI_MFM_Start_Date__c=date.today(), ASI_MFM_End_Date__c=date.today().addMonths(1), ASI_MFM_Status__c = 'Final');
        insert plan;
       

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DP_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Plan__c=plan.id,ASI_MFM_Tax_Rate__c='12%');
        insert po;
        
        ApexPages.currentPage().getParameters().put('pid',po.ASI_MFM_Plan__c);
        ApexPages.currentPage().getParameters().put('RecordType',Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DP_PO') );
	
            
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
        ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
        ASI_MFM_SelectPOPrefixController.getPrefixes();
        ASI_MFM_SelectPOPrefixController.proceed();
    
    }
    
    
   static testMethod void testPODPPrefix3()
    {
        //DP :  2 PO Prefix with 2 DP
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', ASI_MFM_Fiscal_year__c=ASI_MFM_PH_TestClassHelper.getFiscalYear());
        prefixList.add(px);
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='DPPHPO1', ASI_MFM_Module__c='PO');
        prefixList.add(pxo);
        ASI_MFM_Prefix__c pxa = new ASI_MFM_Prefix__c(name='DPPHPO2', ASI_MFM_Module__c='PO');
        prefixList.add(pxa);
        insert prefixList;
        
        //User
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        u.ASI_MFM_Country__c = 'PH';
        update u;
        
        // Role Prefix Relationship
        List<ASI_MFM_Role_Prefix_Relationship__c> RPList = new List<ASI_MFM_Role_Prefix_Relationship__c>();
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pr);
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pro);
        ASI_MFM_Role_Prefix_Relationship__c pra = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxa.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pra);
        insert RPList;
     
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DP_Plan'), ASI_MFM_Prefix__c=px.id, ASI_MFM_Start_Date__c=date.today(), ASI_MFM_End_Date__c=date.today().addMonths(1), ASI_MFM_Status__c = 'Final');
        insert plan;
       

        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId= Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DP_PO'), name='test', ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Plan__c=plan.id,ASI_MFM_Tax_Rate__c='12%'); 
        insert po;
        
        ApexPages.currentPage().getParameters().put('pid',po.ASI_MFM_Plan__c);
        ApexPages.currentPage().getParameters().put('RecordType',po.ASI_MFM_Plan__c);
	
            
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);        
        ASI_MFM_SelectPOPrefixController ASI_MFM_SelectPOPrefixController = new ASI_MFM_SelectPOPrefixController(stdController);
        ASI_MFM_SelectPOPrefixController.getPrefixes();
        //ASI_MFM_SelectPOPrefixController.proceed();
    
    }
    
    
    
   //---------------ASI_MFM_SelectPOPrefixController ------------------- End --------------------
    
    static testMethod void  SupplierEditSupplierNoCtrlTest() {
        map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('Account');
        Account acc1 = new Account(recordTypeId=rt_map.get('ASI_MFM_PH_Supplier'),Name='Name2');  
        insert acc1;
        
        Test.startTest();
        ASI_MFM_PH_SupplierEditSupplierNoCtrl ext2 = new ASI_MFM_PH_SupplierEditSupplierNoCtrl(new ApexPages.StandardController(acc1));
        ext2.supplierNumber='1234';
        ext2.customsave();
        ext2.cancel();
        test.stopTest(); 
    }
    
    
    
    static testMethod void SetPOSatus_Test() {
        
        //User
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        u.ASI_MFM_Country__c = 'PH';
        update u;
        
        
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        ASI_MFM_Prefix__c px = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c='Plan', ASI_MFM_Fiscal_year__c=ASI_MFM_PH_TestClassHelper.getFiscalYear());
        prefixList.add(px);
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='testpo', ASI_MFM_Module__c='PO');
        prefixList.add(pxo);
        insert prefixList;
        
        
        
        // Role Prefix Relationship
        List<ASI_MFM_Role_Prefix_Relationship__c> RPList = new List<ASI_MFM_Role_Prefix_Relationship__c>();
        ASI_MFM_Role_Prefix_Relationship__c pr = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=px.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pr);
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        RPList.add(pro);

        insert RPList;
        
        
        List<Account> accList = ASI_MFM_PH_TestClassHelper.createDFAccount();
       
        ASI_MFM_A_C_Code__c ac = ASI_MFM_PH_TestClassHelper.createACPHDFCode();
        ASI_MFM_Sub_brand__c sub =ASI_MFM_PH_TestClassHelper.CreateDFSBrand();
        
        // Create Plan 
        ASI_MFM_Plan__c p1 = new ASI_MFM_Plan__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_PH_DF_Plan'), ASI_MFM_Prefix__c=px.id, ASI_MFM_Start_Date__c=date.today(), ASI_MFM_End_Date__c=date.today().addMonths(1),ASI_MFM_Currency__c='SGD',
                                                 ASI_MFM_Plan_Description__c='planDescription', ASI_MFM_Plan_Name__c='testplanName', ASI_MFM_Status__c = 'Final');
        insert p1;
        
   
        // Create PO
          
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_PH_DF_PO'), ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Plan__c=p1.id, ASI_MFM_PO_Raised_Date__c=date.today(),
                                             ASI_MFM_Currency__c='SGD', ASI_MFM_Supplier_Name__c = accList[0].id, ASI_MFM_Status__c = 'Final');
        insert po;
        
        
        
        // Create PO line Items
        List<ASI_MFM_PO_Line_Item__c> poLineList = new List<ASI_MFM_PO_Line_Item__c>();
        ASI_MFM_PO_Line_Item__c poi = new ASI_MFM_PO_Line_Item__c(recordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_PH_PO_Line_Item'), ASI_MFM_PO__c=po.id,ASI_MFM_Amount__c=10000,
                                                                  ASI_MFM_A_C_Code__c=ac.id, ASI_MFM_Customer_Name__c=accList[1].id, ASI_MFM_List_Item_Description__c='testDescription', ASI_MFM_Sub_brand_Code__c=sub.id, ASI_MFM_G_L_Date__c = Date.today());
        poLineList.add(poi);                                                          
        insert poLineList;
  

        
        
        
        Test.startTest();
        PageReference pageRef = new Pagereference('/apex/ASI_MFM_PODetailPage');
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('status', 'Complete');   // change status as draft
        ASI_MFM_SetPOStatusController ext1 = new ASI_MFM_SetPOStatusController(new ApexPages.StandardController(po));
        ext1.setStatus();
        test.stopTest(); 
    }
    
    
    
     static testMethod void POPDF_Test() {
         // ASI_MFM_PH_PO_PDF_PageController  and ASI_MFM_PH_BAverifyController
         ASI_MFM_Plan__c plan = ASI_MFM_PH_TestClassHelper.createPHDPPlanReadOnly();
         ASI_MFM_Plan_Line_Item__c planLine = ASI_MFM_PH_TestClassHelper.createPHPlanLines1(plan);
         
        ASI_MFM_PO__c po= ASI_MFM_PH_TestClassHelper.createPHDPPO2(plan);
        
         
         ASI_MFM_PO_Line_Item__c poLine = ASI_MFM_PH_TestClassHelper.createPHPOLines2(po);
         
         Test.startTest();
         ASI_MFM_PH_PO_PDF_PageController ext = new ASI_MFM_PH_PO_PDF_PageController(new ApexPages.StandardController(po));
         
         ext.POID= po.Id; 
         ext.dummyVar = ext.init();
         
         ASI_MFM_PH_BAverifyController ext2 = new ASI_MFM_PH_BAverifyController();
         ext2.initDP();
         ext2.save();
         ext2.BAVerify='Checked';
         ext2.Plan_ID='t';
         
         ext2.PO_ID='1';
         ext2.POLine_ID='1';
         ext2.Suppl='1';
         ext2.Fiscalyear='1';
         ext2.ACCode='1';
         ext2.SBCode='1';
         ext2.Userfilter='1';
         
         ext2.runSearch();
         test.stopTest(); 
     }
    
     static testMethod void InputPOItems_Test() {
        // Test class:  ASI_MFM_PH_InputPOItemsController         
        ASI_MFM_Plan__c plan = ASI_MFM_PH_TestClassHelper.createPHDPPlanReadOnly();
        ASI_MFM_Plan_Line_Item__c planLine = ASI_MFM_PH_TestClassHelper.createPHPlanLines1(plan);
        ASI_MFM_PO__c po= ASI_MFM_PH_TestClassHelper.createPHDPPO(plan);
        ASI_MFM_PO_Line_Item__c poLine = ASI_MFM_PH_TestClassHelper.createPHPOLines1(po);
        
        List<ASI_MFM_PO_Line_Item__c> poLineSet = new List<ASI_MFM_PO_Line_Item__c>();
        poLineSet.add(poLine);
        
        ApexPages.standardSetController sc = new ApexPages.standardSetController(poLineSet);
        
        PageReference inputPOItemsPage = Page.ASI_MFM_PH_InputPOItemsPage;
        Map<String, String> pageParams = inputPOItemsPage.getParameters();
        Test.startTest();
        
        pageParams.put('id', po.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(po);
         ASI_MFM_PH_InputPOItemsController POManageAllCtler = new ASI_MFM_PH_InputPOItemsController(stdController);
        //Test function
        POManageAllCtler.init();
        System.currentPageReference().getParameters().put('IS_QUICK_SAVE', 'Yes');
        POManageAllCtler.SaveItems();
        POManageAllCtler.addLineItem();
        System.currentPageReference().getParameters().put('PARAM_clone_ID', (String)poLine.id);
        POManageAllCtler.cloneLine();
        System.currentPageReference().getParameters().put('PARAM_Line_ID', (String)poLine.id);
        POManageAllCtler.removeLine();
        System.currentPageReference().getParameters().put('IS_QUICK_SAVE', 'Yes');
        POManageAllCtler.SaveItems();
        
        System.currentPageReference().getParameters().put('mode', 'full');
        POManageAllCtler.copyPlan();
         
        POManageAllCtler.cancel();
        List<Account> remo= ASI_MFM_PH_InputPOItemsController.findSObjects('Account','WHERE RecordType.DeveloperName = ASI_MFM_PH_DP_Customer');
       
        test.stopTest(); 
     }



}