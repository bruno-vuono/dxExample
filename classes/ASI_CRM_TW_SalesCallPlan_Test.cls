/*Created by Twinkle Li @introv 04/24/2015
*
* Testclass for:
* ASI_CRM_TW_MarketSurvey_Ctrl
* ASI_CRM_TW_MerchanVisitationPlan_Ctrl
* ASI_CRM_TW_CapCollection_Ctrl 
* ASI_CRM_TW_SalesCallPlanPageNewCtrl
*/

@isTest
public class ASI_CRM_TW_SalesCallPlan_Test {
    static Id checkRecordType(string strsobject, string rt_name){
        id RT_id;
        List<recordType> sobjectlist = Global_RecordTypeCache.getRtList(strsobject);
        for (recordtype pl : sobjectlist ){
            if (pl.developername == rt_name)
            RT_id = pl.id;
        }
        system.debug('RT_id: ' + RT_id);
        return RT_id;           
    }
    
    /*For ASI_CRM_TW_SalesCallPlanPageCtrl*/
    public static testMethod void ASI_CRM_TW_SalesCallPlanPageCtrl_Test() {
        user u = [SELECT id from user where id = :userInfo.getUserId()]; 
        String strThisYear = String.valueof(Date.Today().Year());
        Date myDate = Date.newInstance(integer.valueof(Date.Today().Year()) , 1, 1);
        
        System.runAs(u) {
            String recordTypeid = checkRecordType('ASI_CRM_CN_Channel__c','ASI_CRM_TW_Channel');
            ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name = 'HBR', ASI_CRM_CN_Channel_Code__c = 'HBR', RecordTypeid = recordTypeid);
            insert channel ; 
            
            recordTypeid = checkRecordType('ASI_MFM_Sub_Channel__c','ASI_CRM_TW_SubChannel');
            ASI_MFM_Sub_Channel__c subChannel = new ASI_MFM_Sub_Channel__c(Name = 'Sub-Channel', ASI_CRM_CN_Channel__c = channel.id, RecordTypeid = recordTypeid);
            insert subChannel;         
        
            recordTypeid = checkRecordType('ASI_TH_CRM_OutletType__c','ASI_CRM_TW_Outlet_Type');
            ASI_TH_CRM_OutletType__c outletType = new ASI_TH_CRM_OutletType__c(Name = 'LS (零售菸專)', ASI_TH_CRM_Code__c = 'TW_LS', ASI_CRM_Sub_Channel__c = subChannel.id, RecordTypeid = recordTypeid);
            insert outletType;
        
            List<Account> insertAccountList = new List<Account>();
            List<ASI_CRM_AccountsAdditionalField__c> insertAccountAdditionalFieldList = new List<ASI_CRM_AccountsAdditionalField__c>();
            
            recordTypeid = checkRecordType('Account','ASI_CRM_TW_Outlet');    
            Account outlet = new Account(Name='Test Outlet', RecordTypeid = recordTypeid, ownerid = u.id);
            insertAccountList.add(outlet);                        
            insert insertAccountList;
            
            ASI_TH_CRM_OutletImage__c outletImage = new ASI_TH_CRM_OutletImage__c(Name = 'Iconic', ASI_TH_CRM_Code__c = 'TW_ICN');
            insert outletImage;
            
            recordTypeid = checkRecordType('ASI_CRM_AccountsAdditionalField__c','ASI_CRM_TW_Outlet');
            ASI_CRM_AccountsAdditionalField__c accountAdditionalField = new ASI_CRM_AccountsAdditionalField__c(
                Name = 'Test Outlet', ASI_CRM_Account__c = outlet.id, ASI_TH_CRM_OutletType__c = outletType.id, ASI_CRM_Region__c = 'North',RecordTypeid = recordTypeid,
                ASI_CRM_City__c = 'Test City', ASI_CRM_Town__c = 'Test Town', ASI_CRM_TW_Street__c = 'Test Street', ASI_CRM_TW_Number__c = '1', ASI_CRM_TW_Floor__c = '12',
                ASI_TH_CRM_OutletImage__c = outletImage.id, ASI_CRM_Channel__c = channel.id
            );
            insertAccountAdditionalFieldList.add(accountAdditionalField);
            
            insert insertAccountAdditionalFieldList;
        
            recordTypeid = checkRecordType('ASI_HK_CRM_Visitation_Plan__c','ASI_CRM_TW_Visitation_Plan');
            ASI_HK_CRM_Visitation_Plan__c visitationPlan = new ASI_HK_CRM_Visitation_Plan__c(Name = 'Test Visitation Plan', RecordTypeid = recordTypeid,
                ASI_HK_CRM_Year__c = strThisYear, ASI_HK_CRM_Month__c = 'January');
                
            insert visitationPlan;
            
            ASI_HK_CRM_Visitation_Plan_Detail__c vpDetail = new ASI_HK_CRM_Visitation_Plan_Detail__c(
                ASI_HK_CRM_Account__c = outlet.id, ASI_HK_CRM_Visit_Date__c = myDate, ASI_HK_CRM_Visitation_Plan__c = visitationPlan.id,
                ASI_TH_CRM_Visit_Date_Time_From__c = datetime.newInstance(myDate.year(), myDate.month(), myDate.day()), 
                ASI_TH_CRM_Visit_Date_Time_To__c = datetime.newInstance(myDate.year(), myDate.month(), myDate.day())
            );
            insert vpDetail;
            
            recordTypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_TW_ChannelPromotion');
            ASI_HK_CRM_Promotion__c promotion = new ASI_HK_CRM_Promotion__c(Name = 'Test Promotion', RecordTypeid = recordTypeid, 
                ASI_HK_CRM_Promotion_Start_Date__c = myDate, ASI_HK_CRM_Promotion_End_Date__c = myDate, ASI_CRM_Region__c = 'North');
            insert promotion;

            ASI_HK_CRM_Promotion_Detail__c promotionDetail = new ASI_HK_CRM_Promotion_Detail__c(ASI_HK_CRM_Account__c = outlet.id, ASI_HK_CRM_Promotion__c = promotion.id);
            insert promotionDetail;
            
            ASI_CRM_Sales_Movement__c salesMovement = new ASI_CRM_Sales_Movement__c(ASI_CRM_Account__c = outlet.id, ASI_CRM_Date__c = myDate);
            insert salesMovement;                                                
            
            ASI_CRM_ServicePack__c servicePack = new ASI_CRM_ServicePack__c(Name = 'Test Service Pack', ASI_CRM_Channel__c = channel.id, ASI_CRM_SubChannel__c = subChannel.id,
               ASI_CRM_OutletImage__c = outletImage.id );
            insert servicePack;                
            
            recordTypeid = checkRecordType('ASI_MFM_Sub_brand__c','ASI_MFM_TW_Sub_brand');
            ASI_MFM_Sub_brand__c subBrand = new ASI_MFM_Sub_brand__c(Name = 'Chivas18y', ASI_CRM_TW_TOT__c = true, ASI_CRM_TW_Company__c = 'PRT', RecordTypeid = recordTypeid);
            insert subBrand;
            
            ASI_MFM_Sub_brand__c subBrand2 = new ASI_MFM_Sub_brand__c(Name = 'TGL12y', ASI_CRM_TW_TOT__c = true, 
            ASI_CRM_TW_Company__c = 'PRT', RecordTypeid = recordTypeid);
            insert subBrand2;
            
            ASI_CRM_ServicePackItem__c servicePackItem = new ASI_CRM_ServicePackItem__c(ASI_CRM_ServicePack__c = servicePack.id, ASI_CRM_Subbrand__c = subbrand.id);
            insert servicePackItem;
            
            ASI_CRM_ServicePackItem__c servicePackItem2 = new ASI_CRM_ServicePackItem__c(ASI_CRM_ServicePack__c = servicePack.id, ASI_CRM_Subbrand__c = subBrand2.id);
            insert servicePackItem2;
            
            ASI_CRM_ConfirmedSalesVolume__c confirmedSalesVolume = new ASI_CRM_ConfirmedSalesVolume__c(ASI_CRM_Outlet__c = outlet.id, ASI_CRM_Date__c = date.valueOf('2015-05-01'),
                ASI_CRM_PRTVolume__c = 1000, ASI_CRM_Total__c = 1000 );
            insert confirmedSalesVolume;
            
            ASI_CRM_Promotion_Status__c promotionStatus = new ASI_CRM_Promotion_Status__c(ASI_CRM_Account__c = outlet.id, ASI_CRM_Promotion__c = promotion.id);
            insert promotionStatus;
            
            ASI_KOR_GMA__c gma = new ASI_KOR_GMA__c( ASI_KOR_Venue__c = outlet.id, ASI_KOR_Date__c = myDate, 
                ASI_KOR_Size_cl__c = 1, ASI_KOR_Remarks__c = 'Remarks', ASI_CRM_Back_Label_Reason__c = 'Not Found', ASI_CRM_Front_Label_Reason__c = 'Not Found', ASI_CRM_Lot_No_Reason__c = 'Not Found' );
            insert gma;
            
            ASI_CRM_TW_Settings__c customSetting = new ASI_CRM_TW_Settings__c(ASI_CRM_TW_GMA_VPD_Id__c = vpDetail.id,
            ASI_CRM_TW_GMA_Account_Id__c = outlet.id, ASI_CRM_TW_NoOfDays_VPD__c = 7);
            insert customSetting;
            
            //Added by Twinkle LI @20150622
            recordtypeId = checkRecordType('ASI_CRM_Pros_Segmentation__c', 'ASI_CRM_TW_PROS_Segmentation');
            ASI_CRM_Pros_Segmentation__c prosSegmentation = new ASI_CRM_Pros_Segmentation__c(RecordTypeId = recordtypeId, CurrencyIsoCode = 'TWD', ASI_CRM_SG_Account__c = outlet.id);
            insert prosSegmentation;
            //End by Twinkle LI @20150622
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(outlet);
            ApexPages.currentPage().getParameters().put('vpid', vpDetail.id);    
            ApexPages.currentPage().getParameters().put('accid', outlet.id);
            ASI_CRM_TW_SalesCallPlanPageCtrl controller = new ASI_CRM_TW_SalesCallPlanPageCtrl(stdController);                          
            
            controller.strObjective = 'Testing Objective';
            controller.strRemarks = 'Testing Remarks';
            controller.strCxlReason= 'Testing Reason';
            controller.VisitDateF = datetime.newInstance(myDate.year(), myDate.month(), myDate.day());
            controller.VisitDateT = datetime.newInstance(myDate.year(), myDate.month(), myDate.day());
            List<SelectOption> supplierList = controller.SupplierList;
            
            controller.AddRow();
            controller.RemoveRow();
            controller.QuickSave();
            controller.Save();
            
            controller.dateValidation();
            controller.errorMessage();
            
            //Test Photo Upload
            List<Attachment> listAtt = new List<Attachment>();
            
            Attachment att = new Attachment();
            att.ParentId = vpDetail.id;
            att.Name = 'General_0001';
            att.Body = EncodingUtil.base64Decode('Test Data');
            listAtt.add(att);
            
            Attachment att2 = att.clone();
            att2.Name = 'Mechan_0001';
            listAtt.add(att2);
            
            Attachment att3 = att.clone();
            att3.Name = 'GMA_0001';
            listAtt.add(att3);
            
            insert listAtt;
            
            String attachmentBody = 'Test Photo Upload';
            String attachmentName = 'Test Photo';
            ASI_CRM_TW_SalesCallPlanPageCtrl.insertAttachment(String.valueof(vpDetail.id), EncodingUtil.base64Encode(Blob.valueof(attachmentBody)),attachmentName, '1',null);
            ASI_CRM_TW_SalesCallPlanPageCtrl.insertAttachment(String.valueof(vpDetail.id), EncodingUtil.base64Encode(Blob.valueof(attachmentBody)),attachmentName, '2',null);
            ASI_CRM_TW_SalesCallPlanPageCtrl.insertAttachment(String.valueof(vpDetail.id), EncodingUtil.base64Encode(Blob.valueof(attachmentBody)),attachmentName, '3',null);
            
            List<SelectOption> listSalesMovntOpt = controller.getSalesMovntOpt();
            List<SelectOption> listPromoOpt = controller.getPromoOpt();
            
            PageReference page = controller.mktSurveyPage();
            page = controller.outletImageSetup();
            
            ASI_CRM_TW_SalesCallPlanPageCtrl.fileSeq(1);
        }
    }
    
    /*For ASI_CRM_TW_SalesCallPlanPageNewCtrl*/
    public static testMethod void ASI_CRM_TW_SalesCallPlanPageNewCtrl_Test() {
        user u = [SELECT id from user where id = :userInfo.getUserId()];                                                
        String strThisYear = String.valueof(Date.Today().Year());
        Date myDate = Date.newInstance(integer.valueof(Date.Today().Year()) , 1, 1);
        
        System.runAs(u) {
            String recordTypeid = checkRecordType('ASI_CRM_CN_Channel__c','ASI_CRM_TW_Channel');
            ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name = 'HBR', ASI_CRM_CN_Channel_Code__c = 'HBR', RecordTypeid = recordTypeid);
            insert channel; 
            
            recordTypeid = checkRecordType('ASI_MFM_Sub_Channel__c','ASI_CRM_TW_SubChannel');
            ASI_MFM_Sub_Channel__c subChannel = new ASI_MFM_Sub_Channel__c(Name = 'Sub-Channel', ASI_CRM_CN_Channel__c = channel.id, RecordTypeid = recordTypeid);
            insert subChannel;         
        
            recordTypeid = checkRecordType('ASI_TH_CRM_OutletType__c','ASI_CRM_TW_Outlet_Type');
            ASI_TH_CRM_OutletType__c outletType = new ASI_TH_CRM_OutletType__c(Name = 'LS (零售菸專)', ASI_TH_CRM_Code__c = 'TW_LS', ASI_CRM_Sub_Channel__c = subChannel.id, RecordTypeid = recordTypeid);
            insert outletType;
        
            List<Account> insertAccountList = new List<Account>();
            List<ASI_CRM_AccountsAdditionalField__c> insertAccountAdditionalFieldList = new List<ASI_CRM_AccountsAdditionalField__c>();
            
            recordTypeid = checkRecordType('Account','ASI_CRM_TW_Outlet');    
            Account outlet = new Account(Name='Test Outlet', RecordTypeid = recordTypeid, ownerid = u.id);
            insertAccountList.add(outlet);                        
            insert insertAccountList;
            
            ASI_TH_CRM_OutletImage__c outletImage = new ASI_TH_CRM_OutletImage__c(Name = 'Iconic', ASI_TH_CRM_Code__c = 'TW_ICN');
            insert outletImage;
            
            recordTypeid = checkRecordType('ASI_CRM_AccountsAdditionalField__c','ASI_CRM_TW_Outlet');
            ASI_CRM_AccountsAdditionalField__c accountAdditionalField = new ASI_CRM_AccountsAdditionalField__c(
                Name = 'Test Outlet', ASI_CRM_Account__c = outlet.id, ASI_TH_CRM_OutletType__c = outletType.id, ASI_CRM_Region__c = 'North', RecordTypeid = recordTypeid,
                ASI_CRM_City__c = 'Test City', ASI_CRM_Town__c = 'Test Town', ASI_CRM_TW_Street__c = 'Test Street', ASI_CRM_TW_Number__c = '1', ASI_CRM_TW_Floor__c = '12',
                ASI_TH_CRM_OutletImage__c = outletImage.id, ASI_CRM_Channel__c = channel.id, ASI_CRM_Longitude__c = 25, ASI_CRM_Latitude__c = 20 
            );
            insertAccountAdditionalFieldList.add(accountAdditionalField);
            
            insert insertAccountAdditionalFieldList;
        
            recordTypeid = checkRecordType('ASI_HK_CRM_Visitation_Plan__c','ASI_CRM_TW_Visitation_Plan');
            ASI_HK_CRM_Visitation_Plan__c visitationPlan = new ASI_HK_CRM_Visitation_Plan__c(Name = 'Test Visitation Plan', RecordTypeid = recordTypeid,
                ASI_HK_CRM_Year__c = strThisYear, ASI_HK_CRM_Month__c = 'January');
                
            insert visitationPlan;
            
            recordTypeid = checkRecordType('ASI_HK_CRM_Visitation_Plan_Detail__c', 'ASI_CRM_TW_Visitation_Plan_Detail');
            ASI_HK_CRM_Visitation_Plan_Detail__c vpDetail = new ASI_HK_CRM_Visitation_Plan_Detail__c(
                ASI_HK_CRM_Account__c = outlet.id, ASI_HK_CRM_Visit_Date__c = myDate, ASI_HK_CRM_Visitation_Plan__c = visitationPlan.id, RecordTypeid = recordTypeid,
                ASI_TH_CRM_Visit_Date_Time_From__c = datetime.newInstance(myDate.year(), myDate.month(), myDate.day()), 
                ASI_TH_CRM_Visit_Date_Time_To__c = datetime.newInstance(myDate.year(), myDate.month(), myDate.day())
            );
            insert vpDetail;
            
            recordTypeid = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Promotion__cASI_CRM_TW_ChannelPromotion');
            ASI_HK_CRM_Promotion__c promotion = new ASI_HK_CRM_Promotion__c(Name = 'Test Promotion', ASI_HK_CRM_Promotion_Start_Date__c = myDate, 
                RecordTypeid = recordTypeid, ASI_CRM_Region__c = 'North', ASI_HK_CRM_Promotion_End_Date__c = myDate);
            insert promotion;

            ASI_HK_CRM_Promotion_Detail__c promotionDetail = new ASI_HK_CRM_Promotion_Detail__c(ASI_HK_CRM_Account__c = outlet.id, ASI_HK_CRM_Promotion__c = promotion.id);
            insert promotionDetail;
            
            ASI_CRM_Sales_Movement__c salesMovement = new ASI_CRM_Sales_Movement__c(ASI_CRM_Account__c = outlet.id, ASI_CRM_Date__c = myDate);
            insert salesMovement;                                                
            
            ASI_CRM_ServicePack__c servicePack = new ASI_CRM_ServicePack__c(Name = 'Test Service Pack', ASI_CRM_Channel__c = channel.id, ASI_CRM_SubChannel__c = subChannel.id,
               ASI_CRM_OutletImage__c = outletImage.id );
            insert servicePack;                
            
            recordTypeid = checkRecordType('ASI_MFM_Sub_brand__c','ASI_MFM_TW_Sub_brand');
            ASI_MFM_Sub_brand__c subBrand = new ASI_MFM_Sub_brand__c(Name = 'Chivas18y', ASI_CRM_TW_TOT__c = true, ASI_CRM_TW_Company__c = 'PRT', RecordTypeid = recordTypeid);
            insert subBrand;
            
            ASI_MFM_Sub_brand__c subBrand2 = new ASI_MFM_Sub_brand__c(Name = 'TGL12y', ASI_CRM_TW_TOT__c = true, 
            ASI_CRM_TW_Company__c = 'PRT', RecordTypeid = recordTypeid);
            insert subBrand2;
            
            ASI_CRM_ServicePackItem__c servicePackItem = new ASI_CRM_ServicePackItem__c(ASI_CRM_ServicePack__c = servicePack.id, ASI_CRM_Subbrand__c = subbrand.id);
            insert servicePackItem;
            
            ASI_CRM_ServicePackItem__c servicePackItem2 = new ASI_CRM_ServicePackItem__c(ASI_CRM_ServicePack__c = servicePack.id, ASI_CRM_Subbrand__c = subBrand2.id);
            insert servicePackItem2;
            
            ASI_CRM_ConfirmedSalesVolume__c confirmedSalesVolume = new ASI_CRM_ConfirmedSalesVolume__c(ASI_CRM_Outlet__c = outlet.id, ASI_CRM_Date__c = myDate,
                ASI_CRM_PRTVolume__c = 1000, ASI_CRM_Total__c = 1000 );
            insert confirmedSalesVolume;

            //Insert Promotion Status
            recordTypeid = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Status__cASI_CRM_TW_PromotionStatus');
            List<ASI_CRM_Promotion_Status__c> listPromoStatus = new List<ASI_CRM_Promotion_Status__c>();
            listPromoStatus.add(new ASI_CRM_Promotion_Status__c(RecordTypeid = recordTypeid, ASI_CRM_Promotion__c = promotion.id, ASI_CRM_Account__c = outlet.id, ASI_CRM_Unit__c = 100));
            listPromoStatus.add(new ASI_CRM_Promotion_Status__c(RecordTypeid = recordTypeid, ASI_CRM_Promotion__c = promotion.id, ASI_CRM_Account__c = outlet.id, ASI_CRM_Confirmed__c = TRUE, ASI_CRM_Unit__c = 100));
            listPromoStatus.add(new ASI_CRM_Promotion_Status__c(RecordTypeid = recordTypeid, ASI_CRM_Promotion__c = promotion.id, ASI_CRM_Account__c = outlet.id, ASI_CRM_Confirmed__c = TRUE, ASI_CRM_Unit__c = 100));
            insert listPromoStatus;
            
            Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
            ASI_CRM_TW_PromotionStatus_Ctrl.insertAttachment(listPromoStatus[0].id, EncodingUtil.base64Encode(bodyBlob), 'Unit Test Attachment', '1', null);
            
            ASI_KOR_GMA__c gma = new ASI_KOR_GMA__c( ASI_KOR_Venue__c = outlet.id, ASI_KOR_Date__c = myDate, 
                ASI_KOR_Size_cl__c = 1, ASI_KOR_Remarks__c = 'Remarks', ASI_CRM_Back_Label_Reason__c = 'Not Found', ASI_CRM_Front_Label_Reason__c = 'Not Found', ASI_CRM_Lot_No_Reason__c = 'Not Found' );
            insert gma;
            
            ASI_CRM_TW_Settings__c customSetting = new ASI_CRM_TW_Settings__c(ASI_CRM_TW_GMA_VPD_Id__c = vpDetail.id,
            ASI_CRM_TW_GMA_Account_Id__c = outlet.id, ASI_CRM_TW_NoOfDays_VPD__c = 7);
            insert customSetting;
            
            //Added by Twinkle LI @20150622
            recordtypeId = checkRecordType('ASI_CRM_Pros_Segmentation__c', 'ASI_CRM_TW_PROS_Segmentation');
            ASI_CRM_Pros_Segmentation__c prosSegmentation = new ASI_CRM_Pros_Segmentation__c(RecordTypeId = recordtypeId, CurrencyIsoCode = 'TWD', ASI_CRM_SG_Account__c = outlet.id);
            insert prosSegmentation;
            //End by Twinkle LI @20150622
            
            recordtypeId = checkRecordType('ASI_CRM_Pass_Order__c', 'ASI_CRM_TW_Pass_Order');
            ASI_CRM_Pass_Order__c passOrder = new ASI_CRM_Pass_Order__c(RecordTypeId = recordtypeId, ASI_CRM_Visitation_Plan_Detail__c = vpDetail.id, ASI_CRM_Account__c = insertAccountList[0].id);
            insert passOrder;
            update passOrder;
            
            ASI_CRM_TW_Office_Location__c officeLoc = new ASI_CRM_TW_Office_Location__c(Name = 'North', ASI_CRM_TW_Longitude__c = 21, ASI_CRM_TW_Latitude__c = 10);
            insert officeLoc;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(outlet);
            ApexPages.currentPage().getParameters().put('vpid', vpDetail.id);    
            ApexPages.currentPage().getParameters().put('accid', outlet.id);
            ASI_CRM_TW_SalesCallPlanPageNewCtrl controller = new ASI_CRM_TW_SalesCallPlanPageNewCtrl(stdController);                          
            
            controller.strObjective = 'Testing Objective';
            controller.strRemarks = 'Testing Remarks';
            controller.strCxlReason= 'Testing Reason';
            controller.VisitDateF = datetime.newInstance(myDate.year(), myDate.month(), myDate.day());
            controller.VisitDateT = datetime.newInstance(myDate.year(), myDate.month(), myDate.day());
            List<SelectOption> supplierList = controller.SupplierList;
            List<SelectOption> itemGpList = controller.ItemGroupList;
            
            controller.Longitude = 22;
            controller.Latitude = 22;
            
            controller.AddRow();
            controller.RemoveRow();
            
            controller.AddRow_PassOrder();
            controller.RemoveRow_PassOrder();
            
            controller.QuickSave();
            controller.Save();
            
            controller.dateValidation();
            controller.errorMessage();
            
            //Test Photo Upload
            List<Attachment> listAtt = new List<Attachment>();
            
            Attachment att = new Attachment();
            att.ParentId = vpDetail.id;
            att.Name = 'General_0001';
            att.Body = EncodingUtil.base64Decode('Test Data');
            listAtt.add(att);
            
            Attachment att2 = att.clone();
            att2.Name = 'Mechan_0001';
            listAtt.add(att2);
            
            Attachment att3 = att.clone();
            att3.Name = 'GMA_0001';
            listAtt.add(att3);
            
            insert listAtt;
            
            String attachmentBody = 'Test Photo Upload';
            String attachmentName = 'Test Photo';
            ASI_CRM_TW_SalesCallPlanPageNewCtrl.insertAttachment(String.valueof(vpDetail.id), EncodingUtil.base64Encode(Blob.valueof(attachmentBody)),attachmentName, '1',null);
            ASI_CRM_TW_SalesCallPlanPageNewCtrl.insertAttachment(String.valueof(vpDetail.id), EncodingUtil.base64Encode(Blob.valueof(attachmentBody)),attachmentName, '2',null);
            ASI_CRM_TW_SalesCallPlanPageNewCtrl.insertAttachment(String.valueof(vpDetail.id), EncodingUtil.base64Encode(Blob.valueof(attachmentBody)),attachmentName, '3',null);
            
            List<SelectOption> listSalesMovntOpt = controller.getSalesMovntOpt();
            List<SelectOption> listPromoOpt = controller.getPromoOpt();
            
            PageReference page = controller.mktSurveyPage();
            page = controller.outletImageSetup();
            
            ASI_CRM_TW_SalesCallPlanPageNewCtrl.fileSeq(1);
        }
    }
    
    /*For ASI_CRM_TW_MarketSurvey_Ctrl*/
    static testMethod void ASI_CRM_TW_MarketSurvey_Ctrl_Test(){
        user u = [SELECT id from user where id = :userInfo.getUserId()];                                                
        
        System.runAs(u) {
            String recordTypeid = checkRecordType('ASI_TH_CRM_OutletType__c','ASI_CRM_TW_Outlet_Type');
            ASI_TH_CRM_OutletType__c outletType = new ASI_TH_CRM_OutletType__c(Name = 'LS (零售菸專)', ASI_TH_CRM_Code__c = 'TW_LS', RecordTypeid = recordTypeid);
            insert outletType;
        
            List<Account> insertAccountList = new List<Account>();
            List<ASI_CRM_AccountsAdditionalField__c> insertAccountAdditionalFieldList = new List<ASI_CRM_AccountsAdditionalField__c>();
            
            recordTypeid = checkRecordType('Account','ASI_CRM_TW_Outlet');    
            Account outlet = new Account(Name='Test Outlet', RecordTypeid = recordTypeid, ownerid = u.id);
            insertAccountList.add(outlet);            
            
            insert insertAccountList;
            
            recordTypeid = checkRecordType('ASI_CRM_AccountsAdditionalField__c','ASI_CRM_TW_Outlet');
            ASI_CRM_AccountsAdditionalField__c accountAdditionalField = new ASI_CRM_AccountsAdditionalField__c(
                Name = 'Test Outlet', ASI_CRM_Account__c = outlet.id, ASI_TH_CRM_OutletType__c = outletType.id, ASI_CRM_Region__c = 'North',RecordTypeid = recordTypeid,
                ASI_CRM_City__c = 'Test City', ASI_CRM_Town__c = 'Test Town', ASI_CRM_TW_Street__c = 'Test Street', ASI_CRM_TW_Number__c = '1', ASI_CRM_TW_Floor__c = '12'
            );
            insertAccountAdditionalFieldList.add(accountAdditionalField);
            
            insert insertAccountAdditionalFieldList;
            
            recordTypeid = checkRecordType('ASI_MFM_Sub_brand__c','ASI_MFM_TW_Sub_brand');
            ASI_MFM_Sub_brand__c subBrand = new ASI_MFM_Sub_brand__c(Name = 'Chivas18y', ASI_CRM_TW_TOT__c = true, RecordTypeid = recordTypeid);
            insert subBrand;
            
            ASI_CRM_OutletDepletion__c outletDepletion = new ASI_CRM_OutletDepletion__c(ASI_CRM_Outlet__c = outlet.id);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(outletDepletion );
            ApexPages.currentPage().getParameters().put('accountId', outlet.id);  
            ApexPages.currentPage().getParameters().put('channelCode', 'TOT');    
            ASI_CRM_TW_MarketSurvey_Ctrl controller = new ASI_CRM_TW_MarketSurvey_Ctrl(stdController);                          
            
            controller.search();                   
            controller.save(); 
        }
    }
    
    /*For ASI_CRM_TW_CapCollection_Ctrl*/
    static testMethod void ASI_CRM_TW_CapCollection_Ctrl_Test(){
        user u = [SELECT id from user where id = :userInfo.getUserId()];                                                
        
        System.runAs(u) {
            String recordTypeid = checkRecordType('ASI_TH_CRM_OutletType__c','ASI_CRM_TW_Outlet_Type');
            ASI_TH_CRM_OutletType__c outletType = new ASI_TH_CRM_OutletType__c(Name = 'LS (零售菸專)', ASI_TH_CRM_Code__c = 'TW_LS', RecordTypeid = recordTypeid);
            insert outletType;
        
            List<Account> insertAccountList = new List<Account>();
            List<ASI_CRM_AccountsAdditionalField__c> insertAccountAdditionalFieldList = new List<ASI_CRM_AccountsAdditionalField__c>();
            
            recordTypeid = checkRecordType('Account','ASI_CRM_TW_Outlet');    
            Account outlet = new Account(Name='Test Outlet', RecordTypeid = recordTypeid, ownerid = u.id);
            insertAccountList.add(outlet);            
            
            insert insertAccountList;
            
            recordTypeid = checkRecordType('ASI_CRM_AccountsAdditionalField__c','ASI_CRM_TW_Outlet');
            ASI_CRM_AccountsAdditionalField__c accountAdditionalField = new ASI_CRM_AccountsAdditionalField__c(
                Name = 'Test Outlet', ASI_CRM_Account__c = outlet.id, ASI_TH_CRM_OutletType__c = outletType.id, ASI_CRM_Region__c = 'North',RecordTypeid = recordTypeid,
                ASI_CRM_City__c = 'Test City', ASI_CRM_Town__c = 'Test Town', ASI_CRM_TW_Street__c = 'Test Street', ASI_CRM_TW_Number__c = '1', ASI_CRM_TW_Floor__c = '12'
            );
            insertAccountAdditionalFieldList.add(accountAdditionalField);
            
            insert insertAccountAdditionalFieldList;
            
            recordTypeid = checkRecordType('ASI_MFM_Sub_brand__c','ASI_MFM_TW_Sub_brand');           
            List<ASI_MFM_Sub_brand__c> listSubBrand = new List<ASI_MFM_Sub_brand__c>();
            listSubBrand.add(new ASI_MFM_Sub_brand__c(RecordTypeid = recordTypeid, Name = 'Chivas18y', ASI_CRM_TW_TOT__c = true, ASI_CRM_TW_Company__c = 'PRT'));
            listSubBrand.add(new ASI_MFM_Sub_brand__c(RecordTypeid = recordTypeid, Name = 'Chivas18y', ASI_CRM_TW_LS__c = true, ASI_CRM_TW_Company__c = 'PRT'));
            listSubBrand.add(new ASI_MFM_Sub_brand__c(RecordTypeid = recordTypeid, Name = 'Chivas18y', ASI_CRM_TW_HBR__c = true, ASI_CRM_TW_Company__c = 'PRT'));
            listSubBrand.add(new ASI_MFM_Sub_brand__c(RecordTypeid = recordTypeid, Name = 'Chivas18y', ASI_CRM_TW_CR__c = true, ASI_CRM_TW_Company__c = 'PRT'));
            listSubBrand.add(new ASI_MFM_Sub_brand__c(RecordTypeid = recordTypeid, Name = 'Chivas18y', ASI_CRM_TW_Company__c = 'Testing'));
            insert listSubBrand;
            
            recordTypeid = checkRecordType('ASI_CRM_OutletDepletion__c','ASI_CRM_TW_OutletDepletion_RcrdTyp');        
            List<ASI_CRM_OutletDepletion__c> listOutletDepletion = new List<ASI_CRM_OutletDepletion__c>();
            listOutletDepletion.add(new ASI_CRM_OutletDepletion__c(RecordTypeid = recordTypeid, ASI_CRM_Outlet__c = outlet.id, ASI_CRM_SubBrand__c = listSubBrand[0].id, ASI_CRM_Date__c = date.today()));
            listOutletDepletion.add(new ASI_CRM_OutletDepletion__c(RecordTypeid = recordTypeid, ASI_CRM_Outlet__c = outlet.id, ASI_CRM_SubBrand__c = listSubBrand[1].id, ASI_CRM_Date__c = date.today()));
            listOutletDepletion.add(new ASI_CRM_OutletDepletion__c(RecordTypeid = recordTypeid, ASI_CRM_Outlet__c = outlet.id, ASI_CRM_SubBrand__c = listSubBrand[2].id, ASI_CRM_Date__c = date.today()));
            listOutletDepletion.add(new ASI_CRM_OutletDepletion__c(RecordTypeid = recordTypeid, ASI_CRM_Outlet__c = outlet.id, ASI_CRM_SubBrand__c = listSubBrand[3].id, ASI_CRM_Date__c = date.today()));
            insert listOutletDepletion;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(listOutletDepletion[0]);
            ApexPages.currentPage().getParameters().put('accountId', outlet.id);  
            ApexPages.currentPage().getParameters().put('channelCode', 'TOT');    
            ASI_CRM_TW_CapCollection_Ctrl controller = new ASI_CRM_TW_CapCollection_Ctrl(stdController);    
            
            stdController = new ApexPages.StandardController(listOutletDepletion[1]);
            ApexPages.currentPage().getParameters().put('accountId', outlet.id);  
            ApexPages.currentPage().getParameters().put('channelCode', 'LS');    
            controller = new ASI_CRM_TW_CapCollection_Ctrl(stdController);     
            
            stdController = new ApexPages.StandardController(listOutletDepletion[2]);
            ApexPages.currentPage().getParameters().put('accountId', outlet.id);  
            ApexPages.currentPage().getParameters().put('channelCode', 'HBR');    
            controller = new ASI_CRM_TW_CapCollection_Ctrl(stdController);
            
            stdController = new ApexPages.StandardController(listOutletDepletion[3]);
            ApexPages.currentPage().getParameters().put('accountId', outlet.id);  
            ApexPages.currentPage().getParameters().put('channelCode', 'CR');    
            controller = new ASI_CRM_TW_CapCollection_Ctrl(stdController);                  
                               
            controller.saveAction(); 
        }
    }
}