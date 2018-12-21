@istest
Private class ASI_CRM_CN_MassUploadByBatch_Test {

    
    Private static List<ASI_MFM_Sub_brand__c> tmpSB = new List<ASI_MFM_Sub_brand__c>();
    
    Private static User tempU = [select id from user where CompanyName = 'Pernod Ricard China' limit 1];
    
    Private static List<ASI_CRM_CN_Brand_Group__c> tmpBrandGroup = new List<ASI_CRM_CN_Brand_Group__c>();
    
    Private Static List<ASI_KOR_Sales_Order_Request__c> tmpSalesOrder = new List<ASI_KOR_Sales_Order_Request__c>();
    
    Private Static List<ASI_KOR_Sales_Order_Transaction__c> tmpSalesOrderLineItem = new List<ASI_KOR_Sales_Order_Transaction__c>();
    
    Private Static List<ASI_CRM_Order_Form__c> tmpOrderForm = new List<ASI_CRM_Order_Form__c>();
    
    Private Static List<ASI_CRM_Order_Form_Detail__c> tmpOrderFormLineItem = new List<ASI_CRM_Order_Form_Detail__c>();
    
    Private Static List<ASI_MFM_Item_Group__c> tmpItemGroup = new List<ASI_MFM_Item_Group__c>();
    
    Private Static List<ASI_CRM_CN_T1_Price__c> tmpT1Price = new List<ASI_CRM_CN_T1_Price__c>();
    
    Private Static List<ASI_CRM_Order_Form_Customer_Relationship__c> tmpOFCR = new List<ASI_CRM_Order_Form_Customer_Relationship__c>();
    
    Private Static List<ASI_CRM_AccountsAdditionalField__c> tmpCustomer = new List<ASI_CRM_AccountsAdditionalField__c>();
    
    Private Static List<ASI_CRM_Item_Group_Customer_Price__c> tmpIGCP = new List<ASI_CRM_Item_Group_Customer_Price__c>();
    
    Private static List<ASI_CRM_Fix_Approval_Route__c> tmpFixRoute = new List<ASI_CRM_Fix_Approval_Route__c>();
    
    Private static List<ASI_CRM_Dynamic_Approval_Route__c> tmpDynamicRoute = new List<ASI_CRM_Dynamic_Approval_Route__c>();
    
    Private static List<ASI_CRM_Promotion_Master__c> tmpPromotionMaster = new List<ASI_CRM_Promotion_Master__c>();
    
    Private Static List<ASI_MFM_Sub_Channel__c> tmpSubChannel = new List<ASI_MFM_Sub_Channel__c>();
    
    Private TestMethod Static void uploadTest(){
        
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Region_Area_Channel__c = 'Test', ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - eCommerce'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - VIP'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - HQ'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id, ASI_CRM_CN_Approver_2__c = tempU.id, ASI_CRM_CN_Type__c='Sales Order - RTD'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Region_Area_Channel__c = '', ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - IHBR'));
        
        insert tmpFixRoute;
        
        tmpPromotionMaster.add(new ASI_CRM_Promotion_Master__c(	OwnerId = tempU.id
                                                               , recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Master__cASI_CRM_CN_Promotion_Master')
                                                               , Name = 'B2G1'
                                                              ));
        insert tmpPromotionMaster;
        
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='TEST');
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(ASI_CRM_CN_City_Code__c='TEST', ASI_CRM_CN_Area__c=area.Id);
        insert city;

        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(ASI_CRM_CN_On_Off__c='ON');
        insert channel;
        
        tmpSubChannel.add(new ASI_MFM_Sub_Channel__c(ASI_CRM_CN_Channel__c=channel.Id));
        tmpSubChannel.add(new ASI_MFM_Sub_Channel__c(Name = 'VIP', ASI_CRM_CN_Channel__c=channel.Id));
        
        insert tmpSubChannel;
        
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_JDE_Code_RTD__c = '555', ASI_CRM_CN_JDE_Code__c = '111', ASI_CRM_CN_Is_IHBR_Outlet__c = TRUE, ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[0].Id, ASI_CRM_CN_CCity__c=city.Id, RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_JDE_Code_RTD__c = '666', ASI_CRM_CN_JDE_Code__c = '222', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[1].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_JDE_Code_RTD__c = '777', ASI_CRM_CN_JDE_Code__c = '333', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[0].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN')));
        insert tmpCustomer;
        
        tmpSB.add(new ASI_MFM_Sub_brand__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand')
                                           , Name = 'TestSB'
                                           , OwnerId = tempU.id
                                           , ASI_MFM_Sub_brand_Code__c = '1'
                                           , ASI_HK_CRM_English_Name__c = 'TestSB'
                                          ));
        insert tmpSB;
        
        tmpBrandGroup.add(new ASI_CRM_CN_Brand_Group__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_CN_Brand_Group__cASI_CRM_CN_Brand_Group')
                                                        , Name = 'TestBrandGroup'
                                                        , OwnerId = tempU.id
                                                        , ASI_CRM_CN_English_Name__c = 'TestBrandGroup'
                                                        , ASI_CRM_CN_Chinese_Name__c = 'TestBrandGroup'
                                                        , ASI_CRM_CN_Sequence2__c = 10
                                                        , ASI_CRM_Brand_Group_Code__c = '1'
                                                       ));
        insert tmpBrandGroup;
        
        tmpItemGroup.add(new ASI_MFM_Item_Group__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Item_Group__cASI_CRM_CN_CRM_Item_Group')
                                                   , Name = 'TestItemGroup'
                                                   , ASI_MFM_Item_Group_Code__c = 'TestItemGroupCode'
                                                   , ASI_CRM_CN_Eng_Name__c = 'TestItemGroup'
                                                   , OwnerID = tempU.id
                                                   , ASI_MFM_Item_Group_External_ID__c = 'TestItemGroupCode'
                                                  ));
        insert tmpItemGroup;
        
        tmpT1Price.add(new ASI_CRM_CN_T1_Price__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_CN_T1_Price__cASI_CRM_CN_T1_Price')
                                                  , ASI_CRM_CN_Effective_Date__c = date.today().addDays(-1)
                                                  , ASI_CRM_CN_T1_Price__c = 1
                                                  , ASI_CRM_CN_Item_Group__c = tmpItemGroup[0].id
                                                 ));
		insert tmpT1Price;
        
        tmpIGCP.add(new ASI_CRM_Item_Group_Customer_Price__c(OwnerId = tempU.id
                                                             , RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Item_Group_Customer_Price__cASI_CRM_CN_ItemGroupCustomerPrice')
                                                             , ASI_CRM_Customer__c = tmpCustomer[0].id
                                                             , ASI_CRM_Item_Group__c = tmpItemGroup[0].id
                                                             , ASI_CRM_Unit_Price_BT__c = 1
                                                            ));
        tmpIGCP.add(new ASI_CRM_Item_Group_Customer_Price__c(OwnerId = tempU.id
                                                             , RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Item_Group_Customer_Price__cASI_CRM_CN_ItemGroupCustomerPrice')
                                                             , ASI_CRM_Customer__c = tmpCustomer[1].id
                                                             , ASI_CRM_Item_Group__c = tmpItemGroup[0].id
                                                             , ASI_CRM_Unit_Price_BT__c = 1
                                                            ));
        tmpIGCP.add(new ASI_CRM_Item_Group_Customer_Price__c(OwnerId = tempU.id
                                                             , RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Item_Group_Customer_Price__cASI_CRM_CN_ItemGroupCustomerPrice')
                                                             , ASI_CRM_Customer__c = tmpCustomer[2].id
                                                             , ASI_CRM_Item_Group__c = tmpItemGroup[0].id
                                                             , ASI_CRM_Unit_Price_BT__c = 1
                                                            ));
        insert tmpIGCP;
        
        tmpOrderForm.add(new ASI_CRM_Order_Form__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form__cASI_CRM_CN_Order_Form')
                                                   , ASI_CRM_Order_Form_Name__c = 'TestOrderForm'
                                                   , ASI_CRM_Order_Form_Type__c = 'Normal Item'
                                                   , ASI_CRM_T1_Master__c = TRUE
                                                   , OwnerID = tempU.id
                                                  ));
        tmpOrderForm.add(new ASI_CRM_Order_Form__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form__cASI_CRM_CN_Order_Form')
                                                   , ASI_CRM_Order_Form_Name__c = 'TestOrderForm'
                                                   , ASI_CRM_Order_Form_Type__c = 'RTD'
                                                   , ASI_CRM_T1_Master__c = TRUE
                                                   , OwnerID = tempU.id
                                                  ));
    	insert tmpOrderForm;
        
        tmpOrderFormLineItem.add(new ASI_CRM_Order_Form_Detail__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Detail__cASI_CRM_CN_Order_Form_Detail')
                                                                  , ASI_CRM_Available__c = TRUE
                                                                  , ASI_CRM_Order_Form__c = tmpOrderForm[0].id
                                                                  , ASI_CRM_Product_Name__c = tmpItemGroup[0].id
                                                                  , ASI_CRM_Remark__c = 'TestRemark'
                                                                 ));
        tmpOrderFormLineItem.add(new ASI_CRM_Order_Form_Detail__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Detail__cASI_CRM_CN_Order_Form_Detail')
                                                                  , ASI_CRM_Available__c = TRUE
                                                                  , ASI_CRM_Order_Form__c = tmpOrderForm[1].id
                                                                  , ASI_CRM_Product_Name__c = tmpItemGroup[0].id
                                                                  , ASI_CRM_Remark__c = 'TestRemark'
                                                                 ));
        
        insert tmpOrderFormLineItem;
        
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[0].id
                                                             , ASI_CRM_CN_RTD__c = FALSE
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[0].id
                                                             , ASI_CRM_CN_RTD__c = True
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[1].id
                                                             , ASI_CRM_CN_RTD__c = FALSE
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        
        insert tmpSalesOrder;
        
        tmpOFCR.add(new ASI_CRM_Order_Form_Customer_Relationship__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Customer_Relationship__cASI_CRM_CN_Order_Form_Customer_Relationship'), ASI_CRM_Customer__c = tmpCustomer[1].id, ASI_CRM_Order_Form__c = tmpOrderForm[0].id));
        
        insert tmpOFCR;
        
        test.startTest();
        
        ASI_CRM_CN_MassUploadByBatch_Controller tmpUploadCtrller = new ASI_CRM_CN_MassUploadByBatch_Controller();
        
        tmpUploadCtrller.ObjAPIName = 'ASI_KOR_Sales_Order_Transaction__c';
        tmpUploadCtrller.parentID = tmpSalesOrder[2].id;
        tmpUploadCtrller.recordtypeName = 'CN SalesOrder Item';
        tmpUploadCtrller.parentField = 'ASI_KOR_Sales_Order_Request__c';
        tmpUploadCtrller.fields = 'ASI_CRM_CN_Product_Name__c,ASI_KOR_Order_Qty__c,ASI_CRM_UOM_Text__c,ASI_CRM_CN_Unit_Price_BT_with_VAT__c,ASI_CRM_CN_Free_Qty_BT__c,ASI_CRM_CN_Promotion_Code__c,ASI_CRM_CN_Remark__c';
        tmpUploadCtrller.fieldsLabel = 'Item Group ID(Auto generated when download),Order Quantity(Wholesaler Input),UOM(BOTTLE/CASE)(Wholesaler input),Unit Price Per Bottle,Free Qty,Promotion Code,Remark';
        tmpUploadCtrller.lookupEXID = 'ASI_MFM_Item_Group__c/ASI_CRM_CN_Product_Name__c:Item Group Recordtype&RecordTypeid,Item Group ID(Auto generated when download)&ASI_MFM_Item_Group_External_ID__c;ASI_CRM_Promotion_Master__c/ASI_CRM_CN_Promotion_Code__c:Promotion Master Recordtype&RecordTypeid,Promotion Code&name';
        tmpUploadCtrller.template = 'OrderTemplate';
        tmpUploadCtrller.report = '';
        tmpUploadCtrller.opt_allOrNone = true;
        tmpUploadCtrller.currentPageURL = tmpSalesOrder[2].id;
        tmpUploadCtrller.inlineVF = true;
        tmpUploadCtrller.defaultValues = 'Sales Order Request Recordtype:CN SalesOrder;Item Group Recordtype:CN CRM Item Group;Promotion Master Recordtype:CN Promotion Master;headerId:' + tmpSalesOrder[2].id;
        tmpUploadCtrller.recEXID = 'Item Group ID(Auto generated when download);headerId';
        tmpUploadCtrller.recEXIDcol = 'ASI_CRM_CN_SOT_EXID__c';
        tmpUploadCtrller.parentObjectAPIName = 'ASI_KOR_Sales_Order_Request__c';
        tmpUploadCtrller.ParentObjectUploadMsg = 'ASI_CRM_CN_SOT_Msg_Log__c';
        tmpUploadCtrller.upsertmode = true;
        tmpUploadCtrller.batchMode = true;
        tmpUploadCtrller.emailNotification = false;
        tmpUploadCtrller.namefile = '2015-05-05.csv';
        tmpUploadCtrller.contentFile = blob.valueOf('Item Group ID(Auto generated when download),Order Quantity(Wholesaler Input),UOM(BOTTLE/CASE)(Wholesaler input),Unit Price Per Bottle,Free Qty,Promotion Code,Remark\rTestItemGroupCode,8,CASE,,,,');
        tmpUploadCtrller.filesize = 2000;
        tmpUploadCtrller.dummyVar = NULL;
        
        tmpUploadCtrller.uploadCSVByBatch();
        tmpUploadCtrller.uploadCSV();
        
        tmpUploadCtrller.fields = 'ASI_CRM_CN_Promotion_Expiration_Date__c,ASI_CRM_ETL_Complete__c,ASI_CRM_CN_Product_Name__c,ASI_KOR_Order_Qty__c,ASI_CRM_UOM_Text__c,ASI_CRM_CN_Unit_Price_BT_with_VAT__c,ASI_CRM_CN_Free_Qty_BT__c,ASI_CRM_CN_Promotion_Code__c,ASI_CRM_CN_Remark__c';
        tmpUploadCtrller.fieldsLabel = 'Date,ETL,Item Group ID(Auto generated when download),Order Quantity(Wholesaler Input),UOM(BOTTLE/CASE)(Wholesaler input),Unit Price Per Bottle,Free Qty,Promotion Code,Remark';
        tmpUploadCtrller.contentFile = blob.valueOf('Date,ETL,Item Group ID(Auto generated when download),Order Quantity(Wholesaler Input),UOM(BOTTLE/CASE)(Wholesaler input),Unit Price Per Bottle,Free Qty,Promotion Code,Remark\r2015/1/1,true,TestItemGroupCode,2,CASE,0,99,B2G1,test');
        
        tmpUploadCtrller.uploadCSVByBatch();
        tmpUploadCtrller.uploadCSV();
        
        tmpUploadCtrller.fields = 'ASI_CRM_CN_Promotion_Expiration_Date__c,ASI_CRM_ETL_Complete__c,ASI_CRM_CN_Product_Name__c,ASI_KOR_Order_Qty__c,ASI_CRM_UOM_Text__c,ASI_CRM_CN_Unit_Price_BT_with_VAT__c,ASI_CRM_CN_Free_Qty_BT__c,ASI_CRM_CN_Promotion_Code__c,ASI_CRM_CN_Remark__c';
        tmpUploadCtrller.fieldsLabel = 'Date,ETL,Item Group ID(Auto generated when download),Order Quantity(Wholesaler Input),UOM(BOTTLE/CASE)(Wholesaler input),Unit Price Per Bottle,Free Qty,Promotion Code,Remark';
        tmpUploadCtrller.contentFile = blob.valueOf('Date,ETL,Item Group ID(Auto generated when download),Order Quantity(Wholesaler Input),UOM(BOTTLE/CASE)(Wholesaler input),Unit Price Per Bottle,Free Qty,Promotion Code,Remark\r2015/1/1,OK,TestItemGroupCode,3,CASE,0,99,B2G1,test');
        
        tmpUploadCtrller.uploadCSVByBatch();
        tmpUploadCtrller.uploadCSV();
        
        for(String a : tmpUploadCtrller.StatusMsgs)
        {
            
        }
        
        test.stopTest();
    }
}