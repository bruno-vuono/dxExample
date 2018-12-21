@isTest(seealldata=false)
public with sharing class EUR_CRM_PRSegmentationTest {
    
//    static testMethod void unitTest1(){
//        test.startTest();
//        EUR_CRM_PRS_TestClassUtilityHelper.testInitBG();
//        test.stopTest();
//        //System.Debug('>>>Check Point:1');
//        //EUR_CRM_PRS_Segmentation__c PRS_Seg = [SELECT Id, RecordTypeId,RecordType.DeveloperName,EUR_CRM_Account__c FROM EUR_CRM_PRS_Segmentation__c WHERE EUR_CRM_PRS_Group_Outlet_Type__c <> null LIMIT 1];
//        //Id rtidAcc = [SELECT Id FROM recordType where DeveloperName = 'EUR_BG_Modern_Off_Trade' LIMIT 1 ].Id;
//        //EUR_CRM_Account__c accobj = new EUR_CRM_Account__c(
//        //RecordTypeId = rtidAcc ,                  // Record Type
//        //EUR_CRM_Channel__c = 'OFF TRADE',                  // Channel
//        //Name = 'BG Account Test',                    // Account Name
//        //EUR_CRM_Sub_Channel__c = 'Modern Off-Trade',       // Sub Channel
//        //EUR_CRM_Business_Type__c = 'Head Office',          // Business Type
//        //EUR_CRM_Status__c = 'Active',                      // Status
//        //EUR_CRM_Delivery_Type__c = 'Direct',               // Delivery Type
//        //EUR_CRM_Country__c = 'Bulgaria',                   // Country
//        //EUR_CRM_Force_GOT_OT_by_CT__c = false             // Force GroupOutletType/OutletType by CT
//        //);
//        //Test.startTest();
//        //insert accobj;
//        //Test.stopTest();
//
//        //EUR_CRM_PRS_Segmentation__c PRS_Seg = [SELECT Id, RecordTypeId,RecordType.DeveloperName,EUR_CRM_Account__c FROM EUR_CRM_PRS_Segmentation__c WHERE EUR_CRM_Account__c =:accobj.Id  LIMIT 1];
//
//        EUR_CRM_PRS_Segmentation__c PRS_Seg = [SELECT Id, RecordTypeId, RecordType.DeveloperName,
//                                               EUR_CRM_Account__c, EUR_CRM_PRS_Group_Outlet_Type__c, EUR_CRM_PRS_Outlet_Type__c
//                                               FROM EUR_CRM_PRS_Segmentation__c WHERE EUR_CRM_Account__c =:EUR_CRM_PRS_TestClassUtilityHelper.BG_Off_Account.id  LIMIT 1];
//        System.Debug('PRS_Seg:' + PRS_Seg);
//        System.Debug([SELECT Id, RecordType.DeveloperName, EUR_CRM_Group_Outlet_Type_Name__c
//                      FROM EUR_CRM_PRS_Group_Outlet_Type__c
//                      WHERE RecordType.DeveloperName LIKE '%PRS_Off_Trade_Group_Outlet_Type']);
//
//        //System.Debug('>>>Check Point:2');
//        ApexPages.Standardcontroller standardController = new Apexpages.Standardcontroller(PRS_Seg);
//        PageReference rf = new Pagereference('/apex/EUR_CRM_PRSegmentationPage');
//        rf.getParameters().put('id', PRS_Seg.id);
//        Test.setCurrentPage(rf);
//
//        EUR_CRM_PRSegmentationPageController controller = new EUR_CRM_PRSegmentationPageController(standardController);
//        //System.Debug('>>>Check Point:3');
//        PageReference rf2 = new Pagereference('/apex/EUR_CRM_PRS_GroupOutletTypeSheet');
//        rf2.getParameters().put('id', PRS_Seg.id);
//        Test.setCurrentPage(rf2);
//        //System.Debug('>>>Check Point:4');
//        EUR_CRM_PRS_GroupOutletTypeSheetCntrl GOTCtrl = new EUR_CRM_PRS_GroupOutletTypeSheetCntrl(standardController);
//        GOTCtrl.parentValue = GOTCtrl.parentOptions[0].getValue();
//        GOTCtrl.childValue = GOTCtrl.getChildOptions()[0].getValue();
//        GOTCtrl.Save();
//        GOTCtrl.exit();
//        GOTCtrl.clearPRSegmentationValues();
//        //System.Debug('>>>Check Point:5');
//        //Test.StopTest();
//
//        PageReference rf3 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//        rf3.getParameters().put('id', PRS_Seg.id);
//        rf3.getParameters().put('type', '1');
//        Test.setCurrentPage(rf3);
//
//        EUR_CRM_PRS_QuestionsSheetController QSCtrl1 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//        //QSCtrl1.getCustomForm();
//        for (String key : QSCtrl1.answerSheet.keySet()){
//            QSCtrl1.answerSheet.put(key,'TRUE');
//        }
//        QSCtrl1.saveCriteriaSheet();
//        try{
//            QSCtrl1.getCustomForm();
//        } catch(Exception e) {
//        }
//        //System.Debug('>>>Check Point:6');
//
//        PageReference rf4 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//        rf4.getParameters().put('id', PRS_Seg.id);
//        rf4.getParameters().put('type', '2');
//        Test.setCurrentPage(rf4);
//
//        EUR_CRM_PRS_QuestionsSheetController QSCtrl2 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//        QSCtrl2.saveCriteriaSheet();
//        //System.Debug('>>>Check Point:7');
//
//        EUR_CRM_PRSegmentationClass.returnImageLevelLabels();
//        EUR_CRM_PRSegmentationClass.returnVolumePotentialLabels();
//        EUR_CRM_PRSegmentationClass.returnBrandBuildingPotentialByCountry(new Set<String>{'BG'});
//        EUR_CRM_PRSegmentationClass.returnBusinessPotentialsByCountry(new Set<String>{'BG'});
//        EUR_CRM_PRSegmentationClass.returnImageLevelsByCountry(new Set<String>{'BG'});
//        EUR_CRM_PRSegmentationClass.returnVolumePotentialsByCountry(new Set<String>{'BG'});
//        EUR_CRM_PRSegmentationClass.returnGroupOutletTypeByCountry(new Set<String>{'BG'});
//        EUR_CRM_PRSegmentationClass.returnOutletTypeByCountry(new Set<String>{'BG'});
//        EUR_CRM_PRSegmentationClass.returnBusinessPotentialFinalResultsCriteria('Testing', 'BG');
//        EUR_CRM_PRSegmentationClass.returnImageLevelFinalResultsCriteria('Testing', 'BG');
//        EUR_CRM_PRSegmentationClass.returnVolumePotentialFinalResultsCriteria('Testing', 'BG');
//
//        //System.Debug('>>>Check Point:8');
//        try{EUR_CRM_PRSegmentationClass.returnEUAccountPROFSPotentialMatrix(null);} catch(Exception e) {}
//        try{EUR_CRM_PRSegmentationClass.returnPROSPotentialMatrix(null);} catch(Exception e) {}
//        try{EUR_CRM_PRSegmentationClass.returnEUAccountPROSPotentialMatrix(null);} catch(Exception e) {}
//        //System.Debug('>>>Check Point:9');
//        try{controller.gotoGroupOutletTypeSheet();}catch(Exception e) {}
//        try{controller.gotoBBPSheet();}catch(Exception e) {}
//        try{controller.gotoBPSheet();}catch(Exception e) {}
//        try{controller.gotoILSheet();}catch(Exception e) {}
//        try{controller.gotoVPSheet();}catch(Exception e) {}
//        //System.Debug('>>>Check Point:10');
//
//
//        Try{
//            System.runAs(EUR_CRM_PRS_TestClassUtilityHelper.BG_UserA){
//                EUR_CRM_Account__c account = [SELECT Id,Name,
//                                              EUR_CRM_Is_PRS_Dimensions_Forced__c,EUR_CRM_Force_PRS_Image_Level__c,
//                                              EUR_CRM_Force_PRS_Volume_Potential__c,EUR_CRM_Force_Group_Outlet_Type__c,EUR_CRM_Force_Outlet_Type__c,EUR_CRM_Force_GOT_OT_by_CT__c,
//                                              EUR_CRM_Force_Brand_Building_Potential__c,EUR_CRM_Force_Business_potential__c
//                                              FROM EUR_CRM_Account__c
//                                              Where Id = :PRS_Seg.EUR_CRM_Account__c];
//                System.Debug('PRS Account Before Update:' + account);
//                //account.EUR_CRM_Is_PRS_Dimensions_Forced__c = true;
//                account.EUR_CRM_Force_Business_potential__c = 'High';
//                account.EUR_CRM_Force_Brand_Building_Potential__c = 'High';
//                account.EUR_CRM_Force_GOT_OT_by_CT__c = True;
//                //account.EUR_CRM_Force_Group_Outlet_Type__c = 'Hyper/Supermarket';
//                //account.EUR_CRM_Force_Outlet_Type__c = 'Hypermarket';
//
//                Update account;
//                System.Debug('PRS Account After Update:' + account);
//            }
//
//
//            System.runAs(EUR_CRM_PRS_TestClassUtilityHelper.BG_UserA){
//                EUR_CRM_Account__c account = [SELECT Id,Name,
//                                              EUR_CRM_Is_PRS_Dimensions_Forced__c,EUR_CRM_Force_PRS_Image_Level__c,
//                                              EUR_CRM_Force_PRS_Volume_Potential__c,EUR_CRM_Force_Group_Outlet_Type__c,EUR_CRM_Force_Outlet_Type__c,EUR_CRM_Force_GOT_OT_by_CT__c,
//                                              EUR_CRM_Force_Brand_Building_Potential__c,EUR_CRM_Force_Business_potential__c
//                                              FROM EUR_CRM_Account__c
//                                              Where Id = :PRS_Seg.EUR_CRM_Account__c];
//                System.Debug('PRS Account Before Update:' + account);
//                //account.EUR_CRM_Is_PRS_Dimensions_Forced__c = true;
//                account.EUR_CRM_Force_Business_potential__c = 'Low';
//                account.EUR_CRM_Force_Brand_Building_Potential__c = 'Low';
//                //account.EUR_CRM_Force_GOT_OT_by_CT__c = True;
//                account.EUR_CRM_Force_Group_Outlet_Type__c = 'Hyper/Supermarket';
//                account.EUR_CRM_Force_Outlet_Type__c = 'Hypermarket';
//
//                Update account;
//                System.Debug('PRS Account After Update:' + account);
//            }
//
//        }Catch (Exception e){
//            System.Debug(e.getMessage());
//            System.Debug(e.getStackTraceString());
//        }
//
//    }
//    static testMethod void unitTest2(){
//        test.startTest();
//        EUR_CRM_PRS_TestClassUtilityHelper.testInitBG_2nd();
//        test.stopTest();
//        EUR_CRM_PRS_Segmentation__c PRS_Seg = [SELECT Id, RecordTypeId,RecordType.DeveloperName,EUR_CRM_Account__c
//                                               FROM EUR_CRM_PRS_Segmentation__c
//                                               WHERE EUR_CRM_Account__c =:EUR_CRM_PRS_TestClassUtilityHelper.BG_Off_Account_2nd.id  LIMIT 1];
//        System.Debug('PRS_Seg:' + PRS_Seg);
//        System.Debug([SELECT Id, RecordType.DeveloperName, EUR_CRM_Group_Outlet_Type_Name__c
//                      FROM EUR_CRM_PRS_Group_Outlet_Type__c
//                      WHERE RecordType.DeveloperName LIKE '%PRS_Off_Trade_Group_Outlet_Type']);
//
//        system.runAs(EUR_CRM_PRS_TestClassUtilityHelper.BG_UserB)
//        {
//
//            ApexPages.Standardcontroller standardController = new Apexpages.Standardcontroller(PRS_Seg);
//            PageReference rf = new Pagereference('/apex/EUR_CRM_PRSegmentationPage');
//            rf.getParameters().put('id', PRS_Seg.id);
//            Test.setCurrentPage(rf);
//
//            EUR_CRM_PRSegmentationPageController controller = new EUR_CRM_PRSegmentationPageController(standardController);
//
//            PageReference rf2 = new Pagereference('/apex/EUR_CRM_PRS_GroupOutletTypeSheet');
//            rf2.getParameters().put('id', PRS_Seg.id);
//            Test.setCurrentPage(rf2);
//
//            EUR_CRM_PRS_GroupOutletTypeSheetCntrl GOTCtrl = new EUR_CRM_PRS_GroupOutletTypeSheetCntrl(standardController);
//            GOTCtrl.parentValue = GOTCtrl.parentOptions[0].getValue();
//            GOTCtrl.childValue = GOTCtrl.getChildOptions()[0].getValue();
//            GOTCtrl.Save();
//            GOTCtrl.exit();
//
//            PageReference rf3 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//            rf3.getParameters().put('id', PRS_Seg.id);
//            rf3.getParameters().put('type', '1');
//            Test.setCurrentPage(rf3);
//
//            EUR_CRM_PRS_QuestionsSheetController QSCtrl1 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//            //QSCtrl1.getCustomForm();
//            for (String key : QSCtrl1.answerSheet.keySet()){
//                QSCtrl1.answerSheet.put(key,'TRUE');
//            }
//            QSCtrl1.saveCriteriaSheet();
//            try{
//                QSCtrl1.getCustomForm();
//            } catch(Exception e) {
//            }
//
//            PageReference rf4 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//            rf4.getParameters().put('id', PRS_Seg.id);
//            rf4.getParameters().put('type', '2');
//            Test.setCurrentPage(rf4);
//
//            EUR_CRM_PRS_QuestionsSheetController QSCtrl2 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//            QSCtrl2.saveCriteriaSheet();
//
//            EUR_CRM_PRSegmentationClass.returnImageLevelLabels();
//            EUR_CRM_PRSegmentationClass.returnVolumePotentialLabels();
//            EUR_CRM_PRSegmentationClass.returnBrandBuildingPotentialByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnBusinessPotentialsByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnImageLevelsByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnVolumePotentialsByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnGroupOutletTypeByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnOutletTypeByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnBusinessPotentialFinalResultsCriteria('Testing', 'BE');
//            EUR_CRM_PRSegmentationClass.returnImageLevelFinalResultsCriteria('Testing', 'BE');
//            EUR_CRM_PRSegmentationClass.returnVolumePotentialFinalResultsCriteria('Testing', 'BE');
//            try{
//                EUR_CRM_PRSegmentationClass.returnEUAccountPROFSPotentialMatrix(null);
//            } catch(Exception e) {
//            }
//            try {
//                EUR_CRM_PRSegmentationClass.returnPROSPotentialMatrix(null);
//            } catch(Exception e) {
//            }
//            try {
//                EUR_CRM_PRSegmentationClass.returnEUAccountPROSPotentialMatrix(null);
//            } catch(Exception e) {
//            }
//
//            try{controller.gotoGroupOutletTypeSheet();}catch(Exception e) {}
//            try{controller.gotoBBPSheet();}catch(Exception e) {}
//            try{controller.gotoBPSheet();}catch(Exception e) {}
//            try{controller.gotoILSheet();}catch(Exception e) {}
//            try{controller.gotoVPSheet();}catch(Exception e) {}
//        }
//    }
//    static testMethod void unitTest3(){
//        //Test.startTest();
//        EUR_CRM_PRS_TestClassUtilityHelper.testInitBE_OffTrade();
//        //Test.stopTest();
//
//        EUR_CRM_PRS_Segmentation__c PRS_Seg = [SELECT Id, RecordTypeId,RecordType.DeveloperName,EUR_CRM_Account__c
//                                               FROM EUR_CRM_PRS_Segmentation__c
//                                               WHERE EUR_CRM_Account__c =:EUR_CRM_PRS_TestClassUtilityHelper.BE_Off_Account.id  LIMIT 1];
//        System.Debug('PRS_Seg:' + PRS_Seg);
//        System.Debug([SELECT Id, RecordType.DeveloperName, EUR_CRM_Group_Outlet_Type_Name__c
//                      FROM EUR_CRM_PRS_Group_Outlet_Type__c
//                      WHERE RecordType.DeveloperName LIKE '%PRS_Off_Trade_Group_Outlet_Type']);
//
//
//        ApexPages.Standardcontroller standardController = new Apexpages.Standardcontroller(PRS_Seg);
//        PageReference rf = new Pagereference('/apex/EUR_CRM_PRSegmentationPage');
//        rf.getParameters().put('id', PRS_Seg.id);
//        Test.setCurrentPage(rf);
//
//        EUR_CRM_PRSegmentationPageController controller = new EUR_CRM_PRSegmentationPageController(standardController);
//
//        PageReference rf2 = new Pagereference('/apex/EUR_CRM_PRS_GroupOutletTypeSheet');
//        rf2.getParameters().put('id', PRS_Seg.id);
//        Test.setCurrentPage(rf2);
//
//        EUR_CRM_PRS_GroupOutletTypeSheetCntrl GOTCtrl = new EUR_CRM_PRS_GroupOutletTypeSheetCntrl(standardController);
//        GOTCtrl.parentValue = GOTCtrl.parentOptions[0].getValue();
//        GOTCtrl.childValue = GOTCtrl.getChildOptions()[0].getValue();
//        GOTCtrl.Save();
//        GOTCtrl.exit();
//
//        PageReference rf3 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//        rf3.getParameters().put('id', PRS_Seg.id);
//        rf3.getParameters().put('type', '1');
//        Test.setCurrentPage(rf3);
//
//        EUR_CRM_PRS_QuestionsSheetController QSCtrl1 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//        //QSCtrl1.getCustomForm();
//        for (String key : QSCtrl1.answerSheet.keySet()){
//            QSCtrl1.answerSheet.put(key,'TRUE');
//        }
//        QSCtrl1.saveCriteriaSheet();
//        try{
//            QSCtrl1.getCustomForm();
//        } catch(Exception e) {
//        }
//
//        PageReference rf4 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//        rf4.getParameters().put('id', PRS_Seg.id);
//        rf4.getParameters().put('type', '2');
//        Test.setCurrentPage(rf4);
//
//        EUR_CRM_PRS_QuestionsSheetController QSCtrl2 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//        QSCtrl2.saveCriteriaSheet();
//
//        EUR_CRM_PRSegmentationClass.returnImageLevelLabels();
//        EUR_CRM_PRSegmentationClass.returnVolumePotentialLabels();
//        EUR_CRM_PRSegmentationClass.returnBrandBuildingPotentialByCountry(new Set<String>{'BE'});
//        //EUR_CRM_PRSegmentationClass.returnBusinessPotentialsByCountry(new Set<String>{'BE'});
//        EUR_CRM_PRSegmentationClass.returnImageLevelsByCountry(new Set<String>{'BE'});
//        EUR_CRM_PRSegmentationClass.returnVolumePotentialsByCountry(new Set<String>{'BE'});
//        EUR_CRM_PRSegmentationClass.returnGroupOutletTypeByCountry(new Set<String>{'BE'});
//        EUR_CRM_PRSegmentationClass.returnOutletTypeByCountry(new Set<String>{'BE'});
//        //EUR_CRM_PRSegmentationClass.returnBusinessPotentialFinalResultsCriteria('Testing', 'BE');
//        EUR_CRM_PRSegmentationClass.returnImageLevelFinalResultsCriteria('Testing', 'BE');
//        EUR_CRM_PRSegmentationClass.returnVolumePotentialFinalResultsCriteria('Testing', 'BE');
//        try{
//            EUR_CRM_PRSegmentationClass.returnEUAccountPROFSPotentialMatrix(null);
//        } catch(Exception e) {
//        }
//        try {
//            EUR_CRM_PRSegmentationClass.returnPROSPotentialMatrix(null);
//        } catch(Exception e) {
//        }
//        try {
//            EUR_CRM_PRSegmentationClass.returnEUAccountPROSPotentialMatrix(null);
//        } catch(Exception e) {
//        }
//
//        try{controller.gotoGroupOutletTypeSheet();}catch(Exception e) {}
//        try{controller.gotoBBPSheet();}catch(Exception e) {}
//        //try{controller.gotoBPSheet();}catch(Exception e) {}
//        try{controller.gotoILSheet();}catch(Exception e) {}
//        try{controller.gotoVPSheet();}catch(Exception e) {}
//        try{
//            System.runAs(EUR_CRM_PRS_TestClassUtilityHelper.BE_UserA){
//                Id batchJobId = Database.executeBatch(new EUR_CRM_BE_PRS_SetReperformFlag(), 200);
//            }
//        }catch(Exception e){}
//    }
//    static testMethod void unitTest4(){
//        test.startTest();
//        EUR_CRM_PRS_TestClassUtilityHelper.testInitBE_OnTrade();
//        test.stopTest();
//
//        system.runAs(EUR_CRM_PRS_TestClassUtilityHelper.BE_UserB)
//        {
//            EUR_CRM_PRS_Segmentation__c PRS_Seg = [SELECT Id, RecordTypeId,RecordType.DeveloperName,EUR_CRM_Account__c
//                                                   FROM EUR_CRM_PRS_Segmentation__c
//                                                   WHERE EUR_CRM_Account__c =:EUR_CRM_PRS_TestClassUtilityHelper.BE_On_Account.id  LIMIT 1];
//
//
//            //System.Debug('PRS_Seg:' + PRS_Seg);
//            //System.Debug([SELECT Id, RecordType.DeveloperName, EUR_CRM_Group_Outlet_Type_Name__c
//            //FROM EUR_CRM_PRS_Group_Outlet_Type__c
//            //WHERE RecordType.DeveloperName LIKE '%PRS_On_Trade_Group_Outlet_Type']);
//
//            ApexPages.Standardcontroller standardController = new Apexpages.Standardcontroller(PRS_Seg);
//            PageReference rf = new Pagereference('/apex/EUR_CRM_PRSegmentationPage');
//            rf.getParameters().put('id', PRS_Seg.id);
//            Test.setCurrentPage(rf);
//
//            EUR_CRM_PRSegmentationPageController controller = new EUR_CRM_PRSegmentationPageController(standardController);
//
//            PageReference rf2 = new Pagereference('/apex/EUR_CRM_PRS_GroupOutletTypeSheet');
//            rf2.getParameters().put('id', PRS_Seg.id);
//            Test.setCurrentPage(rf2);
//
//            EUR_CRM_PRS_GroupOutletTypeSheetCntrl GOTCtrl = new EUR_CRM_PRS_GroupOutletTypeSheetCntrl(standardController);
//            GOTCtrl.parentValue = GOTCtrl.parentOptions[0].getValue();
//            GOTCtrl.childValue = GOTCtrl.getChildOptions()[0].getValue();
//            GOTCtrl.Save();
//            GOTCtrl.exit();
//
//            PageReference rf3 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//            rf3.getParameters().put('id', PRS_Seg.id);
//            rf3.getParameters().put('type', '3');
//            Test.setCurrentPage(rf3);
//
//            EUR_CRM_PRS_QuestionsSheetController QSCtrl1 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//            //QSCtrl1.getCustomForm();
//            for (String key : QSCtrl1.answerSheet.keySet()){
//                QSCtrl1.answerSheet.put(key,'TRUE');
//            }
//            QSCtrl1.saveCriteriaSheet();
//            try{
//                QSCtrl1.getCustomForm();
//            } catch(Exception e) {}
//
//            PageReference rf4 = new Pagereference('/apex/EUR_CRM_PRS_QuestionsSheet');
//            rf4.getParameters().put('id', PRS_Seg.id);
//            rf4.getParameters().put('type', '4');
//            Test.setCurrentPage(rf4);
//
//            EUR_CRM_PRS_QuestionsSheetController QSCtrl2 = new EUR_CRM_PRS_QuestionsSheetController(standardController);
//            for (String key : QSCtrl2.answerSheet.keySet()){
//                QSCtrl2.answerSheet.put(key,'TRUE');
//            }
//            QSCtrl2.saveCriteriaSheet();
//
//            EUR_CRM_PRSegmentationClass.returnImageLevelLabels();
//            EUR_CRM_PRSegmentationClass.returnVolumePotentialLabels();
//            EUR_CRM_PRSegmentationClass.returnBrandBuildingPotentialByCountry(new Set<String>{'BE'});
//            //EUR_CRM_PRSegmentationClass.returnBusinessPotentialsByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnImageLevelsByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnVolumePotentialsByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnGroupOutletTypeByCountry(new Set<String>{'BE'});
//            EUR_CRM_PRSegmentationClass.returnOutletTypeByCountry(new Set<String>{'BE'});
//            //EUR_CRM_PRSegmentationClass.returnBusinessPotentialFinalResultsCriteria('Testing', 'BE');
//            EUR_CRM_PRSegmentationClass.returnImageLevelFinalResultsCriteria('Testing', 'BE');
//            EUR_CRM_PRSegmentationClass.returnVolumePotentialFinalResultsCriteria('Testing', 'BE');
//            try{
//                EUR_CRM_PRSegmentationClass.returnEUAccountPROFSPotentialMatrix(null);
//            } catch(Exception e) {
//            }
//            try {
//                EUR_CRM_PRSegmentationClass.returnPROSPotentialMatrix(null);
//            } catch(Exception e) {
//            }
//            try {
//                EUR_CRM_PRSegmentationClass.returnEUAccountPROSPotentialMatrix(null);
//            } catch(Exception e) {
//            }
//
//            try{controller.gotoGroupOutletTypeSheet();}catch(Exception e) {}
//            try{controller.gotoBBPSheet();}catch(Exception e) {}
//            //try{controller.gotoBPSheet();}catch(Exception e) {}
//            try{controller.gotoILSheet();}catch(Exception e) {}
//            try{controller.gotoVPSheet();}catch(Exception e) {}
//            try{
//                System.runAs(EUR_CRM_PRS_TestClassUtilityHelper.BE_UserA){
//                    Id batchJobId = Database.executeBatch(new EUR_CRM_BE_PRS_SetReperformFlag(), 200);
//                }
//            }catch(Exception e){}
//        }
//    }

    @IsTest
    private static void coverageTest() {
        Test.startTest();
        EUR_CRM_PRSegmentationPageController.superMethod();
        Test.stopTest();
    }

}