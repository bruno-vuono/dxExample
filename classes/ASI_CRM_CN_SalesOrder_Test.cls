@istest
private class ASI_CRM_CN_SalesOrder_Test {
    
    //webService
    Private Class salesOrderClass{
        private list<salesOrderStructure> salesOrderlist = new List<salesOrderStructure>();
    }
    
    Private Class salesOrderStructure{
        
        Private String Outlet;
        Private String recordTypeID;
        Private String recordID;
        Private String requestedDate;
        Private String orderDate;
        Private Boolean RTD;
        Private Boolean premium;
        Private String contactPerson;
        Private String otherRequirement;
        Private String TelMobile;
        Private String Address;
    }
    
    Private static List<ASI_MFM_Sub_brand__c> tmpSB = new List<ASI_MFM_Sub_brand__c>();
    
    Private static User tempU = [select id from user where CompanyName = 'Pernod Ricard China' limit 1];
    
    Private static User curU = [select id, ManagerId, CompanyName from user where id = : userInfo.getUserId()];
    
    Private static List<ASI_CRM_CN_Brand_Group__c> tmpBrandGroup = new List<ASI_CRM_CN_Brand_Group__c>();
    
    Private Static List<ASI_KOR_Sales_Order_Request__c> tmpSalesOrder = new List<ASI_KOR_Sales_Order_Request__c>();
    
    Private Static List<ASI_KOR_Sales_Order_Transaction__c> tmpSalesOrderLineItem = new List<ASI_KOR_Sales_Order_Transaction__c>();
    
    Private Static List<ASI_CRM_Order_Form__c> tmpOrderForm = new List<ASI_CRM_Order_Form__c>();
    
    Private Static List<ASI_CRM_Order_Form_Detail__c> tmpOrderFormLineItem = new List<ASI_CRM_Order_Form_Detail__c>();
    
    Private Static List<ASI_MFM_Item_Group__c> tmpItemGroup = new List<ASI_MFM_Item_Group__c>();
    
    Private Static List<ASI_MFM_SKU_Code__c> tmpSKU = new List<ASI_MFM_SKU_Code__c>();
    
    Private Static List<ASI_CRM_CN_T1_Price__c> tmpT1Price = new List<ASI_CRM_CN_T1_Price__c>();
    
    Private Static List<ASI_CRM_Order_Form_Customer_Relationship__c> tmpOFCR = new List<ASI_CRM_Order_Form_Customer_Relationship__c>();
    
    Private Static List<ASI_CRM_AccountsAdditionalField__c> tmpCustomer = new List<ASI_CRM_AccountsAdditionalField__c>();
    
    Private Static List<ASI_CRM_Item_Group_Customer_Price__c> tmpIGCP = new List<ASI_CRM_Item_Group_Customer_Price__c>();
    
    Private static List<ASI_CRM_Fix_Approval_Route__c> tmpFixRoute = new List<ASI_CRM_Fix_Approval_Route__c>();
    
    Private static List<ASI_CRM_Dynamic_Approval_Route__c> tmpDynamicRoute = new List<ASI_CRM_Dynamic_Approval_Route__c>();
    
    Private static List<ASI_CRM_Promotion_Master__c> tmpPromotionMaster = new List<ASI_CRM_Promotion_Master__c>();
    
    Private Static List<ASI_MFM_Sub_Channel__c> tmpSubChannel = new List<ASI_MFM_Sub_Channel__c>();
    
    Private Static List<ASI_CRM_Item_Group_Allocation__c> itemGroupAllocation = new List<ASI_CRM_Item_Group_Allocation__c>();
    
    Private static testMethod void testMethod1(){
        
        curU.companyName = 'Pernod Ricard China';
        curU.ManagerId = tempU.id;
        Update curU;
        
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Region_Area_Channel__c = 'Test', ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - eCommerce'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - VIP'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - HQ'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Approver_1__c = tempU.id, ASI_CRM_CN_Approver_2__c = tempU.id, ASI_CRM_CN_Type__c='Sales Order - RTD'));
        tmpFixRoute.add(new ASI_CRM_Fix_Approval_Route__c(ASI_CRM_CN_Region_Area_Channel__c = '', ASI_CRM_CN_Approver_1__c = tempU.id,ASI_CRM_CN_Type__c='Sales Order - IHBR'));
        
        insert tmpFixRoute;
        
        //20170601
        tmpDynamicRoute.add(new ASI_CRM_Dynamic_Approval_Route__c(ASI_CRM_Type__c = 'Sales Order - IHBR', ASI_CRM_Approval_Limit__c = 1, ASI_CRM_User__c = tempU.id, ASI_CRM_End_of_Dynamic_Route__c = True
                                                                  , recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Dynamic_Approval_Route__cASI_CRM_CN_Dynamic_Approval_Route')
                                                                 ));
        
        Insert tmpDynamicRoute;
        
        tmpPromotionMaster.add(new ASI_CRM_Promotion_Master__c(	OwnerId = tempU.id
                                                               , recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Promotion_Master__cASI_CRM_CN_Promotion_Master')
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
        
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Eng_Name__c = 'test1', ASI_CRM_CN_Chi_Name__c = 'test1', ASI_CRM_CN_Commercial_Team__c = 'Premium', ASI_CRM_CN_JDE_Code_RTD__c = '555', ASI_CRM_CN_JDE_Code__c = '111', ASI_CRM_CN_JDE_Code_Premium__c = '456', ASI_CRM_CN_Is_IHBR_Outlet__c = TRUE, ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[0].Id, ASI_CRM_CN_CCity__c=city.Id, RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Eng_Name__c = 'test2', ASI_CRM_CN_Chi_Name__c = 'test2', ASI_CRM_CN_Commercial_Team__c = 'Premium', ASI_CRM_CN_JDE_Code_RTD__c = '666', ASI_CRM_CN_JDE_Code__c = '222', ASI_CRM_CN_JDE_Code_Premium__c = '789', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[1].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Eng_Name__c = 'test3', ASI_CRM_CN_Chi_Name__c = 'test3', ASI_CRM_CN_Commercial_Team__c = 'Premium', ASI_CRM_CN_JDE_Code_RTD__c = '777', ASI_CRM_CN_JDE_Code__c = '333', ASI_CRM_CN_JDE_Code_Premium__c = '123', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[0].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Eng_Name__c = 'test4', ASI_CRM_CN_Chi_Name__c = 'test4', ASI_CRM_CN_Commercial_Team__c = 'Presitge', ASI_CRM_CN_JDE_Code_RTD__c = '777', ASI_CRM_CN_JDE_Code__c = '333', ASI_CRM_CN_JDE_Code_Premium__c = '123', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[0].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Eng_Name__c = 'test5', ASI_CRM_CN_Chi_Name__c = 'test5', ASI_CRM_CN_Commercial_Team__c = 'Presitge', ASI_CRM_CN_JDE_Code_RTD__c = '666', ASI_CRM_CN_JDE_Code__c = '222', ASI_CRM_CN_JDE_Code_Premium__c = '789', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[1].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS')));
        tmpCustomer.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Eng_Name__c = 'test6', ASI_CRM_CN_Chi_Name__c = 'test6', ASI_CRM_CN_Is_IHBR_Outlet__c = True, ASI_CRM_CN_Commercial_Team__c = 'HQ/Hotel', ASI_CRM_CN_JDE_Code_RTD__c = '777', ASI_CRM_CN_JDE_Code__c = '333', ASI_CRM_CN_JDE_Code_Premium__c = '123', ASI_CRM_CN_Sub_Channel__c=tmpSubChannel[0].Id, ASI_CRM_CN_CCity__c=city.Id, ASI_CRM_Latest_Call_Plan_Date__c=system.today(), RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN')));
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
                                                   , ASI_CRM_Allocation_Information__c = true//20170217 Elufa
                                                  ));
        insert tmpItemGroup;
        
        tmpSKU.add(new ASI_MFM_SKU_Code__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_SKU_Code__cASI_FOC_CN_SKU')
                                           , Name = 'TestSKU'
                                           , ASI_CRM_SKU_Status__c = '000'
                                           , ASI_MFM_Item_Group__c = tmpItemGroup[0].id
                                           , OwnerID = tempU.id
                                          ));
        insert tmpSKU;
        
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

        itemGroupAllocation.add(new ASI_CRM_Item_Group_Allocation__c(ASI_CRM_Allocation_Quantity__c = 100
                                                                     , ASI_CRM_Commercial_Team__c = 'Premium'
                                                                     , ASI_CRM_Effective_Date__c = date.today()
                                                                     , ASI_CRM_Item_Group__c = tmpItemGroup[0].id
                                                                     , ASI_CRM_Region__c = region.id
                                                                     , ASI_CRM_UOM__c = 'CA'
                                                                     , recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Item_Group_Allocation__cASI_CRM_CN_Item_Group_Allocation') 
                                                                    ));
        Insert itemGroupAllocation;
        Update itemGroupAllocation;
        
        test.startTest();
        
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
        tmpOrderForm.add(new ASI_CRM_Order_Form__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form__cASI_CRM_CN_Order_Form')
                                                   , ASI_CRM_Order_Form_Name__c = 'TestOrderForm'
                                                   , ASI_CRM_Order_Form_Type__c = 'Premium'
                                                   , ASI_CRM_T1_Master__c = TRUE
                                                   , OwnerID = tempU.id
                                                  ));
    	insert tmpOrderForm;
        
        tmpOrderFormLineItem.add(new ASI_CRM_Order_Form_Detail__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Detail__cASI_CRM_CN_Order_Form_Detail')
                                                                  , ASI_CRM_Available__c = TRUE
                                                                  , ASI_CRM_Order_Form__c = tmpOrderForm[0].id
                                                                  , ASI_CRM_Product_Name__c = tmpItemGroup[0].id
                                                                  , ASI_CRM_Remark__c = 'TestRemark'
                                                                  , ASI_CRM_Sequence__c = 1//20170217 Elufa
                                                                 ));
        tmpOrderFormLineItem.add(new ASI_CRM_Order_Form_Detail__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Detail__cASI_CRM_CN_Order_Form_Detail')
                                                                  , ASI_CRM_Available__c = TRUE
                                                                  , ASI_CRM_Order_Form__c = tmpOrderForm[1].id
                                                                  , ASI_CRM_Product_Name__c = tmpItemGroup[0].id
                                                                  , ASI_CRM_Remark__c = 'TestRemark'
                                                                  , ASI_CRM_Sequence__c = 1//20170217 Elufa
                                                                 ));
        tmpOrderFormLineItem.add(new ASI_CRM_Order_Form_Detail__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Detail__cASI_CRM_CN_Order_Form_Detail')
                                                                  , ASI_CRM_Available__c = TRUE
                                                                  , ASI_CRM_Order_Form__c = tmpOrderForm[2].id
                                                                  , ASI_CRM_Product_Name__c = tmpItemGroup[0].id
                                                                  , ASI_CRM_Remark__c = 'TestRemark'
                                                                  , ASI_CRM_Sequence__c = 1//20170217 Elufa
                                                                 ));
        
        insert tmpOrderFormLineItem;
        
        tmpOFCR.add(new ASI_CRM_Order_Form_Customer_Relationship__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Customer_Relationship__cASI_CRM_CN_Order_Form_Customer_Relationship'), ASI_CRM_Customer__c = tmpCustomer[1].id, ASI_CRM_Order_Form__c = tmpOrderForm[0].id));
        tmpOFCR.add(new ASI_CRM_Order_Form_Customer_Relationship__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Customer_Relationship__cASI_CRM_CN_Order_Form_Customer_Relationship'), ASI_CRM_Customer__c = tmpCustomer[1].id, ASI_CRM_Order_Form__c = tmpOrderForm[1].id));
        tmpOFCR.add(new ASI_CRM_Order_Form_Customer_Relationship__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Customer_Relationship__cASI_CRM_CN_Order_Form_Customer_Relationship'), ASI_CRM_Customer__c = tmpCustomer[1].id, ASI_CRM_Order_Form__c = tmpOrderForm[2].id));
        tmpOFCR.add(new ASI_CRM_Order_Form_Customer_Relationship__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Order_Form_Customer_Relationship__cASI_CRM_CN_Order_Form_Customer_Relationship'), ASI_CRM_Customer__c = tmpCustomer[5].id, ASI_CRM_Order_Form__c = tmpOrderForm[2].id));
        
        insert tmpOFCR;
        
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[0].id
                                                             , ASI_CRM_CN_RTD__c = FALSE
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[2].id
                                                             , ASI_CRM_CN_RTD__c = False
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[1].id
                                                             , ASI_CRM_CN_RTD__c = FALSE
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[1].id
                                                             , ASI_CRM_CN_RTD__c = False
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[3].id
                                                             , ASI_CRM_CN_RTD__c = True
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[4].id
                                                             , ASI_CRM_CN_RTD__c = True
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        tmpSalesOrder.add(new ASI_KOR_Sales_Order_Request__c(OwnerId = tempU.id
                                                             , ASI_KOR_Order_Status__c = 'Open'
                                                             , ASI_CRM_CN_Customer__c = tmpCustomer[5].id
                                                             , ASI_CRM_CN_RTD__c = True
                                                             , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder')
                                                            ));
        
        insert tmpSalesOrder;
        
        tmpSalesOrderLineItem.add(new ASI_KOR_Sales_Order_Transaction__c(ASI_CRM_CN_Product_Name__c = tmpItemGroup[0].id
                                                                         , ASI_KOR_Order_Qty__c = 1
                                                                         , ASI_CRM_CN_Unit_Price_BT_with_VAT__c = 1
                                                                         , ASI_CRM_CN_Promotion_Code__c = tmpPromotionMaster[0].id
                                                                         , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item')
                                                                         , ASI_KOR_Sales_Order_Request__c = tmpSalesOrder[0].id
                                                                        ));
        tmpSalesOrderLineItem.add(new ASI_KOR_Sales_Order_Transaction__c(ASI_CRM_CN_Product_Name__c = tmpItemGroup[0].id
                                                                         , ASI_KOR_Order_Qty__c = 1
                                                                         , ASI_CRM_CN_Unit_Price_BT_with_VAT__c = 1
                                                                         , ASI_CRM_CN_Promotion_Code__c = tmpPromotionMaster[0].id
                                                                         , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item')
                                                                         , ASI_KOR_Sales_Order_Request__c = tmpSalesOrder[1].id
                                                                        ));
        tmpSalesOrderLineItem.add(new ASI_KOR_Sales_Order_Transaction__c(ASI_CRM_CN_Product_Name__c = tmpItemGroup[0].id
                                                                         , ASI_KOR_Order_Qty__c = 1
                                                                         , ASI_CRM_CN_Unit_Price_BT_with_VAT__c = 1
                                                                         , ASI_CRM_CN_Promotion_Code__c = tmpPromotionMaster[0].id
                                                                         , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item')
                                                                         , ASI_KOR_Sales_Order_Request__c = tmpSalesOrder[2].id
                                                                        ));
        tmpSalesOrderLineItem.add(new ASI_KOR_Sales_Order_Transaction__c(ASI_CRM_CN_Product_Name__c = tmpItemGroup[0].id
                                                                         , ASI_KOR_Order_Qty__c = 1
                                                                         , ASI_CRM_CN_Unit_Price_BT_with_VAT__c = 1
                                                                         , ASI_CRM_CN_Promotion_Code__c = tmpPromotionMaster[0].id
                                                                         , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item')
                                                                         , ASI_KOR_Sales_Order_Request__c = tmpSalesOrder[3].id
                                                                        ));
        tmpSalesOrderLineItem.add(new ASI_KOR_Sales_Order_Transaction__c(ASI_CRM_CN_Product_Name__c = tmpItemGroup[0].id
                                                                         , ASI_KOR_Order_Qty__c = 1
                                                                         , ASI_CRM_CN_Unit_Price_BT_with_VAT__c = 1
                                                                         , ASI_CRM_CN_Promotion_Code__c = tmpPromotionMaster[0].id
                                                                         , recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item')
                                                                         , ASI_KOR_Sales_Order_Request__c = tmpSalesOrder[6].id
                                                                        ));
        insert tmpSalesOrderLineItem;
        
        update tmpSalesOrder;
        
        ASI_CRM_TOV__c tmpTOV = new ASI_CRM_TOV__c(ASI_CRM_Status__c = 'Draft'
                                                   , recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_TOV__cASI_CRM_CN_TOV')
                                                   , ASI_CRM_SF_SO_Request_Number__c = tmpSalesOrder[0].id
                                                  );
        insert tmpTOV;
        update tmpTOV;
        
        ASI_CRM_CN_Field_ID_Mapping__c tmpCustomeObject = new ASI_CRM_CN_Field_ID_Mapping__c(Name = 'SalesOrder Field Id');
        insert tmpCustomeObject;
        
        Test.setCurrentPage(Page.ASI_CRM_CN_SalesOrderNewRequestPage);
        Apexpages.currentPage().getParameters().put('id', tmpCustomer[0].id);
        Apexpages.StandardController sc1 = new apexpages.StandardController(tmpCustomer[0]);
        ASI_CRM_CN_SalesOrderNewRequestCRTLLER newSalesOrder = new ASI_CRM_CN_SalesOrderNewRequestCRTLLER(sc1);
        newSalesOrder.newSalesOrder();
        
        Test.setCurrentPage(Page.ASI_CRM_CN_SalesOrderNewRequestPage);
        Apexpages.currentPage().getParameters().put('id', tmpCustomer[2].id);
        Apexpages.StandardController sc5 = new apexpages.StandardController(tmpCustomer[2]);
        ASI_CRM_CN_SalesOrderNewRequestCRTLLER newSalesOrder2 = new ASI_CRM_CN_SalesOrderNewRequestCRTLLER(sc5);
        newSalesOrder2.newSalesOrder();
        
        Test.setCurrentPage(Page.ASI_CRM_CN_OrderFormRequestPage);
        Apexpages.currentPage().getParameters().put('id', tmpSalesOrder[0].id);
        Apexpages.StandardSetController sc = new apexpages.StandardSetController(tmpSalesOrder);
        ASI_CRM_CN_SalesOrderRequestCtrller so = new ASI_CRM_CN_SalesOrderRequestCtrller(sc);
        ASI_CRM_CN_SalesOrder_EmailController so2 = new ASI_CRM_CN_SalesOrder_EmailController();
        
        so2.dummyVar = false;
        so2.lineItem = tmpSalesOrderLineItem;
        so2.currentHeaderID = tmpSalesOrder[0].id;
        so2.init();
        so.getBrandType();
        
        ASI_CRM_CN_SalesOrder_EmailController so3 = new ASI_CRM_CN_SalesOrder_EmailController();
        
        List<ASI_KOR_Sales_Order_Transaction__c> l = new List<ASI_KOR_Sales_Order_Transaction__c>();
        l.add(tmpSalesOrderLineItem[3]);
        so3.dummyVar = false;
        so3.lineItem = l;
        so3.currentHeaderID = tmpSalesOrder[3].id;
        so3.init();
        
        List<ASI_CRM_CN_SalesOrderRequestCtrller.ASI_HK_CRM_SOLineItem> tmpSOLineItem = new List<ASI_CRM_CN_SalesOrderRequestCtrller.ASI_HK_CRM_SOLineItem>();
        
        //ASI_CRM_CN_SalesOrderRequestCtrller.getBrandType();
        ASI_CRM_CN_SalesOrderRequestCtrller.lineItemList(tmpSalesOrder[0].id);
        ASI_CRM_CN_SalesOrderRequestCtrller.normalProductList(tmpSalesOrder[0].id, '', false);
        
        ASI_CRM_CN_SalesOrderRequestCtrller.ASI_HK_CRM_SOLineItem tmpSOLineItem2 = new ASI_CRM_CN_SalesOrderRequestCtrller.ASI_HK_CRM_SOLineItem();
        
        tmpSOLineItem2.skuId = tmpItemGroup[0].id;
        tmpSOLineItem2.remark = 'TestRemark';
        tmpSOLineItem2.price = 1;
        tmpSOLineItem2.unitPriceSource = 'a';
        tmpSOLineItem2.promotionCodeID = tmpPromotionMaster[0].id;
        tmpSOLineItem2.promotionExpirationDate = '7-5-2015';
        tmpSOLineItem2.qty = 1;
        
        tmpSOLineItem.add(tmpSOLineItem2);
        
        ASI_CRM_CN_SalesOrderRequestCtrller.ASI_HK_CRM_SOLineItem tmpSOLineItem3 = new ASI_CRM_CN_SalesOrderRequestCtrller.ASI_HK_CRM_SOLineItem();
        
        tmpSOLineItem3.skuId = tmpItemGroup[0].id;
        tmpSOLineItem3.remark = 'TestRemark';
        tmpSOLineItem2.price = 1;
        tmpSOLineItem2.unitPriceSource = 'a';
        tmpSOLineItem2.promotionCodeID = tmpPromotionMaster[0].id;
        tmpSOLineItem2.promotionExpirationDate = '7-5-2015';
        tmpSOLineItem2.qty = 1;
        tmpSOLineItem3.id = tmpOrderFormLineItem[0].id;
        
        tmpSOLineItem.add(tmpSOLineItem3);
        
        ASI_CRM_CN_SalesOrderRequestCtrller.saveChanges(tmpOrderForm[0].id, tmpSOLineItem);
        
        String headerRecord = '{\"salesOrderlist\":[{\"recordID\":\"\",\"requestedDate\":\"' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() + '\",\"orderDate\":\"' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() + '\",\"RTD\":false,\"contactPerson\":\"Test\",\"otherRequirement\":\"No!!!\",\"TelMobile\":\"12345678\",\"Address\":\"HK\",\"Outlet\":\"' + tmpCustomer[0].id + '\",\"recordTypeID\":\"' + Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Request__cASI_CRM_CN_SalesOrder') + '\"}]}';
        ASI_CRM_CN_SalesOrder_Upsert.UpsertSalesOrder(headerRecord);
        
        String lineRecord = '{\"salesOrderLIlist\":[{\"recordID\":\"\",\"SOHeader\":\"' + tmpSalesOrder[0].id + '\",\"OrderQty\":\"100\",\"recordTypeID\":\"' + Global_RecordTypeCache.getRtId('ASI_KOR_Sales_Order_Transaction__cASI_CRM_CN_SalesOrder_Item') + '\",\"itemGroup\":\"' + tmpItemGroup[0].id + '\",\"UOM\":\"CA\"}]}';
        ASI_CRM_CN_SalesOrderLineItem_Upsert.UpsertSalesOrderLI(lineRecord);
        
        String deleteLine = '{\"salesOrderLIlist\":[{\"recordID\":\"' + tmpSalesOrderLineItem[0].id + '\"}]}';
        ASI_CRM_CN_SalesOrderLineItem_Delete.deleteSalesOrderLI(deleteLine);
        
        String deleteRecord = '{\"salesOrderlist\":[{\"recordID\":\"' + tmpSalesOrder[0].id + '\"}]}';
        ASI_CRM_CN_SalesOrder_Detele.DeleteSalesOrder(deleteRecord);
        
        String submitRecord = '{\"salesOrderlist\":[{\"recordID\":\"' + tmpSalesOrder[2].id + '\"}]}';
        ASI_CRM_CN_SalesOrder_Submit.submitSalesOrder(submitRecord);
        
        test.stopTest();
        
    }
}