@isTest 
private class ASI_FOC_HK_TestClass_DL {

    static testMethod void testTriggers_MKT_Normal() {
        ASI_HK_CRM_ThresholdValues__c threshold = new ASI_HK_CRM_ThresholdValues__c(ASI_HK_CRM_SO_Urgent_Cutoff_Time_1__c = '10:00', ASI_HK_CRM_SO_Urgent_Cutoff_Time_2__c = '16:00');
        insert threshold;
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        
        ASI_FOC_Route_Type__c rt = new ASI_FOC_Route_Type__c(ASI_FOC_Role_Name__c = u.userRole.developerName, ASI_FOC_Department__c = 'Marketing', ASI_FOC_Line_Manager__c = u.id, ASI_FOC_Director__c = u.id, ASI_FOC_Sales_POS_Approver__c = u.id, ASI_FOC_LUX_Approver__c = u.id, ASI_FOC_Finance_Director__c = u.id, recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Route_Type__cASI_FOC_HK_Route_Type'));
        insert rt;

        Account acc = new Account(recordtypeid = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'), Name = 'Outlet HK Test Data');
        insert acc;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c ='PO', recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_HK_Prefix'));
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;  
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(Name = 'Test PO', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'), ASI_MFM_Status__c = 'Final', ASI_MFM_Is_FOC_PO__c = true, ASI_MFM_Net_off_FOC_PO__c = false, ASI_MFM_JDE_FOC_Return_Amount__c = -1000, ASI_MFM_Prefix__c = pxo.id
            , ASI_MFM_Sys_Approver_2__c = u.id);
        insert po;
        
        ASI_MFM_SKU_Code__c sku = new ASI_MFM_SKU_Code__c(recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), Name = 'Testing SKU', ASI_FOC_Stock_Price__c  = 10, ASI_MFM_SKU_Code__c = 'Testing SKU', ASI_FOC_Inventory__c = 100, ASI_HK_CRM_Active__c = TRUE);
        insert sku;
        
        test.startTest();
        
        ASI_FOC_Free_Goods_Request__c fr = new ASI_FOC_Free_Goods_Request__c(ASI_FOC_Request_Type__c='Wine/Spirits', recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Free_Goods_Request__cASI_FOC_HK_Free_Goods_Request_Sales_Admin'),
            ASI_FOC_Account_DA__c = acc.id, ASI_FOC_MFM_Consumer_AP_PO_Number__c = po.id, ASI_FOC_Date_of_Delivery__c = Date.today(), ASI_FOC_Urgent_Order__c = true, ASI_FOC_Delivery_Window_Instruction__c = 'Between', ASI_FOC_Delivery_Time_1__c = '11:00');
        insert fr;      
        
        fr.ASI_FOC_Request_Type__c = 'POS';
        fr.ASI_FOC_Delivery_Remarks__c = 'test';
        fr.ASI_FOC_Urgent_Order__c = false;
        fr.ASI_FOC_Date_of_Delivery__c = Date.today()+1;
        
        update fr;
        
        ASI_FOC_Request_Item__c ri3 = new ASI_FOC_Request_Item__c(recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_HK_Request_Item'), ASI_FOC_Request_Order__c=fr.id, ASI_FOC_Free_Good_Cost__c=100, ASI_FOC_SKU__c = sku.id, ASI_FOC_Request_Quantity_Bottle__c = 10);
        insert ri3;
        
        PageReference pageRef = Page.ASI_FOC_HK_Request_NotifySalesAdminPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(fr);
        ASI_FOC_HK_Request_NotifySalesAdminCON con = new ASI_FOC_HK_Request_NotifySalesAdminCON(sc);
                
        con.notifySalesAdmin();
        
        test.stopTest();
    }
    
    static testMethod void testTriggers_MKT_Normal_2() {
        ASI_HK_CRM_ThresholdValues__c threshold = new ASI_HK_CRM_ThresholdValues__c(ASI_HK_CRM_SO_Urgent_Cutoff_Time_1__c = '10:00', ASI_HK_CRM_SO_Urgent_Cutoff_Time_2__c = '16:00');
        insert threshold;
        
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        
        ASI_FOC_Route_Type__c rt = new ASI_FOC_Route_Type__c(ASI_FOC_Role_Name__c = u.userRole.developerName, ASI_FOC_Department__c = 'Marketing', ASI_FOC_Line_Manager__c = u.id, ASI_FOC_Director__c = u.id, ASI_FOC_Sales_POS_Approver__c = u.id, ASI_FOC_LUX_Approver__c = u.id, ASI_FOC_Finance_Director__c = u.id, recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Route_Type__cASI_FOC_HK_Route_Type'));
        insert rt;

        Account acc = new Account(recordtypeid = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'), Name = 'Outlet HK Test Data');
        insert acc;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c ='PO', recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_HK_Prefix'));
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;  
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(Name = 'Test PO', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'), ASI_MFM_Status__c = 'Final', ASI_MFM_Is_FOC_PO__c = true, ASI_MFM_Net_off_FOC_PO__c = false, ASI_MFM_JDE_FOC_Return_Amount__c = -1000, ASI_MFM_Prefix__c = pxo.id
            , ASI_MFM_Sys_Approver_2__c = u.id);
        insert po;
        
        
        ASI_MFM_SKU_Code__c sku = new ASI_MFM_SKU_Code__c(recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), Name = 'Testing SKU', ASI_FOC_Stock_Price__c  = 10, ASI_MFM_SKU_Code__c = 'Testing SKU', ASI_FOC_Inventory__c = 100, ASI_HK_CRM_Active__c = TRUE);
        insert sku;
        
        sku.ASI_FOC_Inventory__c = 99;
        update sku;
        
        test.startTest();
        ASI_FOC_Free_Goods_Request__c fr = new ASI_FOC_Free_Goods_Request__c(ASI_FOC_Request_Type__c='Wine/Spirits', recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Free_Goods_Request__cASI_FOC_HK_Free_Goods_Request_Sales_Admin'),
            ASI_FOC_Account_DA__c = acc.id, ASI_FOC_MFM_Consumer_AP_PO_Number__c = po.id, ASI_FOC_Date_of_Delivery__c = Date.today(), ASI_FOC_Urgent_Order__c = true, ASI_FOC_Delivery_Window_Instruction__c = 'Between', ASI_FOC_Delivery_Time_1__c = '11:00');
        insert fr;      
                
        ASI_FOC_Request_Item__c ri2 = new ASI_FOC_Request_Item__c(recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_HK_Request_Item'), ASI_FOC_Request_Order__c=fr.id, ASI_FOC_Free_Good_Cost__c=100, ASI_FOC_SKU__c = sku.id, ASI_FOC_Request_Quantity_Bottle__c = 10);
        insert ri2;
        
        ri2.ASI_FOC_Request_Quantity_Bottle__c = 20;
        update ri2;
        
        delete ri2;
        
        test.stopTest();
    }
    
    static testMethod void testTriggers2_Sales_Normal() {
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        
        ASI_FOC_Route_Type__c rt = new ASI_FOC_Route_Type__c(ASI_FOC_Role_Name__c = u.userRole.developerName, ASI_FOC_Department__c = 'Sales', ASI_FOC_Line_Manager__c = u.id, ASI_FOC_Director__c = u.id, ASI_FOC_Sales_POS_Approver__c = u.id, ASI_FOC_LUX_Approver__c = u.id, ASI_FOC_Finance_Director__c = u.id, recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Route_Type__cASI_FOC_HK_Route_Type'));
        insert rt;

        Account acc = new Account(recordtypeid = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'), Name = 'Outlet HK Test Data');
        insert acc;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c ='PO', recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_HK_Prefix'));
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;  
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(Name = 'Test PO', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'), ASI_MFM_Status__c = 'Final', ASI_MFM_Is_FOC_PO__c = true, ASI_MFM_Net_off_FOC_PO__c = false, ASI_MFM_JDE_FOC_Return_Amount__c = -1000, ASI_MFM_Prefix__c = pxo.id);
        insert po;
        
        ASI_MFM_SKU_Code__c sku = new ASI_MFM_SKU_Code__c(recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), Name = 'Testing SKU', ASI_FOC_Stock_Price__c  = 10, ASI_MFM_SKU_Code__c = 'SKU1', ASI_HK_CRM_Active__c = TRUE);
        insert sku;
        
        ASI_FOC_Free_Goods_Request__c fr = new ASI_FOC_Free_Goods_Request__c(ASI_FOC_Request_Type__c='Wine/Spirits', recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Free_Goods_Request__cASI_FOC_HK_Free_Goods_Request_Sales'),
            ASI_FOC_Account_DA__c = acc.id, ASI_FOC_MFM_Consumer_AP_PO_Number__c = po.id, ASI_FOC_Date_of_Delivery__c = Date.today(), ASI_FOC_Urgent_Order__c = true, ASI_FOC_Delivery_Window_Instruction__c = 'Between', ASI_FOC_Delivery_Time_1__c = '11:00'
                , ASI_FOC_STK_4_Count_Sales_Volume__c = false);
        insert fr;
        
        test.startTest();
        
        ASI_FOC_Request_Item__c ri = new ASI_FOC_Request_Item__c(recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_HK_Request_Item'), ASI_FOC_Request_Order__c=fr.id, ASI_FOC_Free_Good_Cost__c=100, ASI_FOC_SKU__c = sku.id, ASI_FOC_Request_Quantity_Bottle__c = 1);
        insert ri;

        delete ri;
        
        test.stopTest();
    }
    
    static testMethod void testTriggers2_Sales_WineSpirit() {
        user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        
        ASI_FOC_Route_Type__c rt = new ASI_FOC_Route_Type__c(ASI_FOC_Role_Name__c = u.userRole.developerName, ASI_FOC_Department__c = 'Sales', ASI_FOC_Line_Manager__c = u.id, ASI_FOC_Director__c = u.id, ASI_FOC_Sales_POS_Approver__c = u.id, ASI_FOC_LUX_Approver__c = u.id, ASI_FOC_Finance_Director__c = u.id, recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Route_Type__cASI_FOC_HK_Route_Type'));
        insert rt;

        Account acc = new Account(recordtypeid = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'), Name = 'Outlet HK Test Data');
        insert acc;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c ='PO', recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_HK_Prefix'));
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;  
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(Name = 'Test PO', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'), ASI_MFM_Status__c = 'Final', ASI_MFM_Is_FOC_PO__c = true, ASI_MFM_Net_off_FOC_PO__c = false, ASI_MFM_JDE_FOC_Return_Amount__c = -1000, ASI_MFM_Prefix__c = pxo.id);
        insert po;
        
        ASI_MFM_SKU_Code__c sku = new ASI_MFM_SKU_Code__c(recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), Name = 'Testing SKU', ASI_FOC_Stock_Price__c  = 10, ASI_MFM_SKU_Code__c = 'SKU1', ASI_HK_CRM_Active__c = TRUE);
        insert sku;
        
        ASI_FOC_Free_Goods_Request__c fr = new ASI_FOC_Free_Goods_Request__c(ASI_FOC_Request_Type__c='Wine/Spirits', recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Free_Goods_Request__cASI_FOC_HK_Free_Goods_Request_Sales'),
            ASI_FOC_Account_DA__c = acc.id, ASI_FOC_MFM_Consumer_AP_PO_Number__c = po.id, ASI_FOC_Date_of_Delivery__c = Date.today(), ASI_FOC_Urgent_Order__c = true, ASI_FOC_Delivery_Window_Instruction__c = 'Between', ASI_FOC_Delivery_Time_1__c = '11:00'
                , ASI_FOC_STK_4_Count_Sales_Volume__c = false);
        insert fr;
        
        test.startTest();
        
        fr.ASI_FOC_Delivery_Remarks__c = 'test';
        fr.ASI_FOC_Urgent_Order__c = false;
        fr.ASI_FOC_Date_of_Delivery__c = Date.today()+1;
        update fr;
        
        PageReference pageRef = Page.ASI_FOC_HK_Request_NotifySalesAdminPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(fr);
        ASI_FOC_HK_Request_NotifySalesAdminCON con = new ASI_FOC_HK_Request_NotifySalesAdminCON(sc);
        
        //Test no request detail line
        con.notifySalesAdmin();
        con.goBack();
        
        ASI_FOC_Request_Item__c ri2 = new ASI_FOC_Request_Item__c(recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_HK_Request_Item'), ASI_FOC_Request_Order__c=fr.id, ASI_FOC_Free_Good_Cost__c=100, ASI_FOC_SKU__c = sku.id, ASI_FOC_Request_Quantity_Bottle__c = 10);
        insert ri2; 
        
        delete fr;
        
        test.stopTest();
    }
    
    static testMethod void test_ASI_FOC_HK_FreeGoodRequestCloneChildCON() {
        final Integer numOfSKU = 5;
        final Integer numOfFGReqDetail = 3;
        
        ASI_FOC_SKUGenerator skuGen = new ASI_FOC_SKUGenerator();
        ASI_FOC_FreeGoodRequestGenerator fgReqGen = new ASI_FOC_FreeGoodRequestGenerator();
        ASI_FOC_FreeGoodRequestDetailGenerator fgReqDetailGen = new ASI_FOC_FreeGoodRequestDetailGenerator();
        
        List<ASI_MFM_SKU_Code__c> skuList = new List<ASI_MFM_SKU_Code__c>();
        ASI_FOC_Free_Goods_Request__c cloneFromFGReq;
        ASI_FOC_Free_Goods_Request__c cloneToFGReq;
        List<ASI_FOC_Request_Item__c> fgReqDetailList = new List<ASI_FOC_Request_Item__c>();
        
        for (Integer i = 0; i < numOfSKU; i++) {
            skuList.add(skuGen.generateSKU(null));
        }
        insert skuList;
        
        cloneFromFGReq = fgReqGen.generateTradeFreeGoodRequest();
        insert cloneFromFGReq;
        
        for (Integer i = 0; i < numOfFGReqDetail; i++) {
            fgReqDetailList.add(fgReqDetailGen.generateFreeGoodRequestDetail(cloneFromFGReq, skuList[i]));
        }
        insert fgReqDetailList;
        
        cloneToFGReq = fgReqGen.generateTradeFreeGoodRequest();
        insert cloneToFGReq;
        
        Test.startTest();
        
        PageReference testPage = Page.ASI_FOC_FreeGoodRequestCloneChildPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put(ASI_FOC_HK_FreeGoodRequestCloneChildCON.URL_PARAM_NEW_ID, cloneToFGReq.Id);
        Test.setCurrentPageReference(testPage);
        ASI_FOC_HK_FreeGoodRequestCloneChildCON testController = new ASI_FOC_HK_FreeGoodRequestCloneChildCON();
        PageReference initRedirectPage = testController.initPage();
        PageReference linkRedirectPage = testController.redirectToAnotherPage();
        String linkDisplayStr = testController.anotherPageLabel;
        
        
        pageParams.put(ASI_FOC_HK_FreeGoodRequestCloneChildCON.URL_PARAM_FROM_ID, cloneFromFGReq.Id);
        testController = new ASI_FOC_HK_FreeGoodRequestCloneChildCON();
        initRedirectPage = testController.initPage();
        
        testController.newReqId = null;
        testController.redirectToAnotherPage();
        
        List<ASI_FOC_Request_Item__c> testReqItemList = [SELECT Id FROM ASI_FOC_Request_Item__c WHERE ASI_FOC_Request_Order__c = :cloneToFGReq.Id];
        
        Test.stopTest();
    }
    
   static testMethod void test_ASI_FOC_HK_RequestDetailEditCON() {
        /*user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        
        final Integer numOfFGReqDetail = 2;
        
        ASI_FOC_SKUGenerator skuGen = new ASI_FOC_SKUGenerator();
        ASI_FOC_FreeGoodRequestGenerator fgReqGen = new ASI_FOC_FreeGoodRequestGenerator();
        ASI_FOC_FreeGoodRequestDetailGenerator fgReqDetailGen = new ASI_FOC_FreeGoodRequestDetailGenerator();
        
        List<ASI_MFM_SKU_Code__c> skuList = new List<ASI_MFM_SKU_Code__c>();
        ASI_MFM_SKU_Code__c sku1 = new ASI_MFM_SKU_Code__c(Name = 'SKU 1', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU1', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c  = 5, ASI_FOC_Active__c = true);
        
        ASI_MFM_SKU_Code__c sku2 = new ASI_MFM_SKU_Code__c(Name = 'SKU 2', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU2', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c    = 5, ASI_FOC_Is_Premium__c = true, ASI_FOC_Active__c = true);
        
        ASI_MFM_SKU_Code__c sku3 = new ASI_MFM_SKU_Code__c(Name = 'SKU 1', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU1', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c  = 5, ASI_FOC_Active__c = true, ASI_HK_CRM_IsPOSProduct__c  = true);
        
        ASI_MFM_SKU_Code__c sku4 = new ASI_MFM_SKU_Code__c(Name = 'SKU 2', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU2', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c    = 5, ASI_FOC_Is_Premium__c = true, ASI_FOC_Active__c = true, ASI_HK_CRM_IsPOSProduct__c = false);
            
        skuList.add(sku1);
        skuList.add(sku2);
        skuList.add(sku3);
        skuList.add(sku4);
        insert skuList;
        
        List<ASI_FOC_Request_Item__c> fgReqDetailList = new List<ASI_FOC_Request_Item__c>();        
        
        Account acc = new Account(recordtypeid = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'), Name = 'Outlet HK Test Data');
        insert acc;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c ='PO', recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_HK_Prefix'));
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;  
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(Name = 'Test PO', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'), ASI_MFM_Status__c = 'Final', ASI_MFM_Is_FOC_PO__c = true, ASI_MFM_Net_off_FOC_PO__c = false, ASI_MFM_JDE_FOC_Return_Amount__c = -1000, ASI_MFM_Prefix__c = pxo.id);
        insert po;
        
        Test.startTest();
        
        ASI_FOC_Free_Goods_Request__c fgReq = new ASI_FOC_Free_Goods_Request__c(ASI_FOC_Request_Type__c='Wine/Spirits', recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Free_Goods_Request__cASI_FOC_HK_Free_Goods_Request_Sales'),
                ASI_FOC_Account_DA__c = acc.id, ASI_FOC_MFM_Consumer_AP_PO_Number__c = po.id, ASI_FOC_Date_of_Delivery__c = Date.today(), ASI_FOC_Urgent_Order__c = true);      
        insert fgReq;
        
        ASI_FOC_Request_Item__c ri = new ASI_FOC_Request_Item__c(recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_HK_Request_Item'), ASI_FOC_Request_Order__c = fgReq.id, ASI_FOC_Free_Good_Cost__c=100, ASI_FOC_SKU__c = sku1.id, ASI_FOC_Request_Quantity_Bottle__c = 1);
        fgReqDetailList.add(ri);

        insert fgReqDetailList;
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(fgReqDetailList);
        
        // Initialize the page
        PageReference testPage = Page.ASI_FOC_HK_RequestDetailEditPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put('id', fgReq.Id);
        pageParams.put('PARAM_PB_BTN_ID', fgReq.Id);
        pageParams.put('clone', '1');

        Test.setCurrentPageReference(testPage);
        ASI_FOC_HK_RequestDetailEditCON testCon = new ASI_FOC_HK_RequestDetailEditCON(stdSetController);
        ASI_FOC_MassCreateAndUpdateController mcauCon = new ASI_FOC_MassCreateAndUpdateController();
        ASI_FOC_SFObjSelectTableController sobjstCon = new ASI_FOC_SFObjSelectTableController();
        
        // Assign component attributes
        mcauCon.isFastModeBool = true;
        mcauCon.sObjTypeStr = 'ASI_FOC_Request_Item__c';
        mcauCon.displayFieldsStr = 'ASI_FOC_SKU__c&read=A, ASI_FOC_Request_Quantity_Bottle__c&req=T';
        mcauCon.fieldToURLParamStr = 'ASI_FOC_Request_Order__c=>id';
        mcauCon.whereStatm = 'ASI_FOC_Request_Order__c = \'' + fgReq.Id + '\'';
        mcauCon.orderByStr = 'Name';
        mcauCon.pageBlockTitleStr = 'Free Goods Request Items';
        mcauCon.successLinkStr = '/' + fgReq.Id;
        mcauCon.cancelLinkStr = '/' + fgReq.Id;
        mcauCon.modeStr = 'BOTH';
        mcauCon.isDefaultEditVal = true;
        mcauCon.isShowAllRT = true;
        mcauCon.isUseFirstRowForNew = false;
        mcauCon.myComponentKey = 'massCreateAndUpdate';
        mcauCon.myPageController = testCon.thisController;
        mcauCon.includeRecordTypesStr  = 'ASI_FOC_HK_Request_Item';
        
        sobjstCon.sObjTypeStr = 'ASI_MFM_SKU_Code__c';
        sobjstCon.displayFieldsStr = 'Name, ASI_MFM_SKU_Description__c, ASI_MFM_Sub_brand__c';
        sobjstCon.defWhereStatmStr = testCon.baseWhereStatm;
        sobjstCon.orderByStr = 'ASI_MFM_SKU_Description__c';
        sobjstCon.numOfRowInTable = 8;
        sobjstCon.myComponentKey = 'selectTable';
        sobjstCon.myPageController = testCon.thisController;
        
        Boolean initPageBool = mcauCon.dummyVar;
        initPageBool = sobjstCon.initDummyVar;
        
        // Start testing user actions
        
        // Change page number
        sobjstCon.nextPage();
        sobjstCon.lastPage();
        sobjstCon.prevPage();
        sobjstCon.firstPage();
        
        // Clone product
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        pageParams.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).id);
        //mcauCon.cloneRow();
        
        // Dummy test of enableForEdit
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        List<ASI_FOC_MassCreateAndUpdateController.TableRow> recordList = mcauCon.theRecordTypeElementList.get(0).myRecordList;
        pageParams.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
        mcauCon.enableForEdit();
        
        // Remove cloned product
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        recordList = mcauCon.theRecordTypeElementList.get(0).myRecordList;
        pageParams.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
        mcauCon.removeNew();
        
        // Filter products
        testCon.filterName = skuList[0].Name;
        testCon.filterSKU();

        
        // Add product
        pageParams.put('PARAM_BTN_ID', 'add');
        pageParams.put('PARAM_SOBJ_ID', sobjstCon.tableEleList.get(0).sObj.Id);
        sobjstCon.triggerRowAction();
        
        // Remove old product
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        pageParams.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).id);
        mcauCon.deleteOld();
        
        // Remove new product
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        recordList = mcauCon.theRecordTypeElementList.get(0).myRecordList;
        pageParams.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
        mcauCon.removeNew();
        
        // Dummy test of addMoreBlankRows
        mcauCon.addMoreBlankRows();
        
        // Add product
        pageParams.put('PARAM_BTN_ID', 'add');
        pageParams.put('PARAM_SOBJ_ID', sobjstCon.tableEleList.get(0).sObj.Id);
        sobjstCon.triggerRowAction();
        
        // Set values
        mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).mySObj.put('ASI_FOC_Request_Quantity_Bottle__c', 5);
        
        // Save
        mcauCon.commitAll();
        mcauCon.cancelPage();
        
               mcauCon.clearAll();
        mcauCon.triggerPageBlockAction();
        mcauCon.addNewRow(); 
        mcauCon.refresh();
        ASI_FOC_MassCreateAndUpdateController.PageBlockActionBtn  btn = new ASI_FOC_MassCreateAndUpdateController.PageBlockActionBtn('222222','Free Goods Request');    
        
        mcauCon.cancelLinkStr = null;
        mcauCon.cancelPage();

        Test.stopTest();
*/
       user u = [select userRole.developerName from user where id = :userInfo.getUserId()];
        
        final Integer numOfFGReqDetail = 2;
        
        ASI_FOC_SKUGenerator skuGen = new ASI_FOC_SKUGenerator();
        ASI_FOC_FreeGoodRequestGenerator fgReqGen = new ASI_FOC_FreeGoodRequestGenerator();
        ASI_FOC_FreeGoodRequestDetailGenerator fgReqDetailGen = new ASI_FOC_FreeGoodRequestDetailGenerator();
        
        List<ASI_MFM_SKU_Code__c> skuList = new List<ASI_MFM_SKU_Code__c>();
        ASI_MFM_SKU_Code__c sku1 = new ASI_MFM_SKU_Code__c(Name = 'SKU 1', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU1', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c  = 5, ASI_FOC_Active__c = true, ASI_HK_CRM_Active__c = TRUE);
        
        ASI_MFM_SKU_Code__c sku2 = new ASI_MFM_SKU_Code__c(Name = 'SKU 2', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU2', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c    = 5, ASI_FOC_Is_Premium__c = true, ASI_FOC_Active__c = true, ASI_HK_CRM_Active__c = TRUE);
        
        ASI_MFM_SKU_Code__c sku3 = new ASI_MFM_SKU_Code__c(Name = 'SKU 1', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU1', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c  = 5, ASI_FOC_Active__c = true, ASI_HK_CRM_IsPOSProduct__c  = true, ASI_HK_CRM_Active__c = TRUE);
        
        ASI_MFM_SKU_Code__c sku4 = new ASI_MFM_SKU_Code__c(Name = 'SKU 2', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_HK_CRM_SKU'), ASI_FOC_Stock_Price__c = 100, ASI_MFM_SKU_Code__c = 'SKU2', 
            ASI_MFM_SKU_Description__c = 'SKU1', ASI_FOC_Inventory__c    = 5, ASI_FOC_Is_Premium__c = true, ASI_FOC_Active__c = true, ASI_HK_CRM_IsPOSProduct__c = false, ASI_HK_CRM_Active__c = TRUE);
            
        skuList.add(sku1);
        skuList.add(sku2);
        skuList.add(sku3);
        skuList.add(sku4);
        insert skuList;
        
        List<ASI_FOC_Request_Item__c> fgReqDetailList = new List<ASI_FOC_Request_Item__c>();        
        
        Account acc = new Account(recordtypeid = Global_RecordTypeCache.getRtId('AccountASI_HK_CRM_Outlet'), Name = 'Outlet HK Test Data');
        insert acc;
        
        ASI_MFM_Prefix__c pxo = new ASI_MFM_Prefix__c(name='test', ASI_MFM_Module__c ='PO', recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_HK_Prefix'));
        insert pxo; 
        
        ASI_MFM_Role_Prefix_Relationship__c pro = new ASI_MFM_Role_Prefix_Relationship__c(ASI_MFM_Prefix__c=pxo.id, ASI_MFM_Role_Name__c=u.userRole.developerName);
        insert pro;  
        
        ASI_MFM_PO__c po = new ASI_MFM_PO__c(Name = 'Test PO', recordTypeID = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'), ASI_MFM_Status__c = 'Final', ASI_MFM_Is_FOC_PO__c = true, ASI_MFM_Net_off_FOC_PO__c = false, ASI_MFM_JDE_FOC_Return_Amount__c = -1000, ASI_MFM_Prefix__c = pxo.id);
        insert po;
        
        Test.startTest();
        
        ASI_FOC_Free_Goods_Request__c fgReq = new ASI_FOC_Free_Goods_Request__c(ASI_FOC_Request_Type__c='Wine/Spirits', recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Free_Goods_Request__cASI_FOC_HK_Free_Goods_Request_Sales'),
                ASI_FOC_Account_DA__c = acc.id, ASI_FOC_MFM_Consumer_AP_PO_Number__c = po.id, ASI_FOC_Date_of_Delivery__c = Date.today(), ASI_FOC_Urgent_Order__c = true);      
        insert fgReq;
        
        ASI_FOC_Request_Item__c ri = new ASI_FOC_Request_Item__c(recordtypeid = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_HK_Request_Item'), ASI_FOC_Request_Order__c = fgReq.id, ASI_FOC_Free_Good_Cost__c=100, ASI_FOC_SKU__c = sku1.id, ASI_FOC_Request_Quantity_Bottle__c = 1);
        fgReqDetailList.add(ri);

        insert fgReqDetailList;
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(fgReqDetailList);
        
        // Initialize the page
        PageReference testPage = Page.ASI_FOC_HK_RequestDetailEditPage;
        Map<String, String> pageParams = testPage.getParameters();
        pageParams.put('id', fgReq.Id);
        pageParams.put('PARAM_PB_BTN_ID', fgReq.Id);
        pageParams.put('clone', '1');

        Test.setCurrentPageReference(testPage);
        ASI_FOC_HK_RequestDetailEditCON testCon = new ASI_FOC_HK_RequestDetailEditCON(stdSetController);
        ASI_FOC_MassCreateAndUpdateController mcauCon = new ASI_FOC_MassCreateAndUpdateController();
        ASI_FOC_SFObjSelectTableController sobjstCon = new ASI_FOC_SFObjSelectTableController();
        
        // Assign component attributes
        mcauCon.isFastModeBool = true;
        mcauCon.sObjTypeStr = 'ASI_FOC_Request_Item__c';
        mcauCon.displayFieldsStr = 'ASI_FOC_SKU__c&read=A, ASI_FOC_Request_Quantity_Bottle__c&req=T';
        mcauCon.fieldToURLParamStr = 'ASI_FOC_Request_Order__c=>id';
        mcauCon.whereStatm = 'ASI_FOC_Request_Order__c = \'' + fgReq.Id + '\'';
        mcauCon.orderByStr = 'Name';
        mcauCon.pageBlockTitleStr = 'Free Goods Request Items';
        mcauCon.successLinkStr = '/' + fgReq.Id;
        mcauCon.cancelLinkStr = '/' + fgReq.Id;
        mcauCon.modeStr = 'BOTH';
        mcauCon.isDefaultEditVal = true;
        mcauCon.isShowAllRT = true;
        mcauCon.isUseFirstRowForNew = false;
        mcauCon.myComponentKey = 'massCreateAndUpdate';
        mcauCon.myPageController = testCon.thisController;
        mcauCon.includeRecordTypesStr  = 'ASI_FOC_HK_Request_Item';
        
        sobjstCon.sObjTypeStr = 'ASI_MFM_SKU_Code__c';
        sobjstCon.displayFieldsStr = 'Name, ASI_MFM_SKU_Description__c, ASI_MFM_Sub_brand__c';
        sobjstCon.defWhereStatmStr = testCon.baseWhereStatm;
        sobjstCon.orderByStr = 'ASI_MFM_SKU_Description__c';
        sobjstCon.numOfRowInTable = 8;
        sobjstCon.myComponentKey = 'selectTable';
        sobjstCon.myPageController = testCon.thisController;
        
        Boolean initPageBool = mcauCon.dummyVar;
        initPageBool = sobjstCon.initDummyVar;
        
        // Start testing user actions
        
        // Change page number
        sobjstCon.nextPage();
        sobjstCon.lastPage();
        sobjstCon.prevPage();
        sobjstCon.firstPage();
        
        // Clone product
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        pageParams.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).id);
        //mcauCon.cloneRow();
        
        // Dummy test of enableForEdit
        pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
        List<ASI_FOC_MassCreateAndUpdateController.TableRow> recordList = new List<ASI_FOC_MassCreateAndUpdateController.TableRow>();
        if (mcauCon.theRecordTypeElementList.size() > 0) {
          recordList = mcauCon.theRecordTypeElementList.get(0).myRecordList;
           pageParams.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
            if (recordList.size() > 0) {
        //mcauCon.enableForEdit();
            }
        }
        
        // Remove cloned product
      pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
    if (mcauCon.theRecordTypeElementList.size() > 0) {
          recordList = mcauCon.theRecordTypeElementList.get(0).myRecordList;
          pageParams.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
            if (recordList.size() > 0) {
            //mcauCon.removeNew();
            }
      }
        
        // Filter products
        testCon.filterName = skuList[0].Name;
        testCon.filterSKU();

        
        // Add product
      if (sobjstCon.tableEleList.size() > 0) {
          pageParams.put('PARAM_BTN_ID', 'add');
          pageParams.put('PARAM_SOBJ_ID', sobjstCon.tableEleList.get(0).sObj.Id);
          sobjstCon.triggerRowAction();
        }
        
        // Remove old product
      if (mcauCon.theRecordTypeElementList.size() > 0 && mcauCon.theRecordTypeElementList.get(0).myRecordList.size() > 0) {
          pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
          pageParams.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).id);
          //mcauCon.deleteOld();
        }
        
        // Remove new product
      if (mcauCon.theRecordTypeElementList.size() > 0) {
          pageParams.put(mcauCon.PARAM_RTID, ASI_FOC_FreeGoodRequestDetailGenerator.RT_Default);
          recordList = mcauCon.theRecordTypeElementList.get(0).myRecordList;
          pageParams.put(mcauCon.PARAM_TRID, recordList.get(recordList.size() - 1).id);
            //mcauCon.removeNew();
        }
        
        // Dummy test of addMoreBlankRows
        //mcauCon.addMoreBlankRows();
        
        // Add product
      if (sobjstCon.tableEleList.size() > 0) {
          pageParams.put('PARAM_BTN_ID', 'add');
          pageParams.put('PARAM_SOBJ_ID', sobjstCon.tableEleList.get(0).sObj.Id);
          sobjstCon.triggerRowAction();
        }
            
        // Set values
      if (mcauCon.theRecordTypeElementList.size() > 0 && mcauCon.theRecordTypeElementList.get(0).myRecordList.size() > 0) {
          mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).mySObj.put('ASI_FOC_Request_Quantity_Bottle__c', 5);
        }
        
        // Save
        //mcauCon.commitAll();
        //mcauCon.cancelPage();
        
        //       mcauCon.clearAll();
        //mcauCon.triggerPageBlockAction();
        //mcauCon.addNewRow(); 
        //mcauCon.refresh();
        ASI_FOC_MassCreateAndUpdateController.PageBlockActionBtn  btn = new ASI_FOC_MassCreateAndUpdateController.PageBlockActionBtn('222222','Free Goods Request');    
        
        mcauCon.cancelLinkStr = null;
        //mcauCon.cancelPage();

        Test.stopTest();
    }
}