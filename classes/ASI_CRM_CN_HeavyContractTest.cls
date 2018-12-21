@isTest

public class ASI_CRM_CN_HeavyContractTest {

    
    
    static testMethod void HeavyProfitShuttleCtrlTest1() {//Test ASI_CRM_CN_HeavyProfitShuttleCtrl
          ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id,ASI_CRM_CN_City_Tier__c='2');
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        
        ASI_CRM_SegmentationCriteria__c SegmentationCriteria= new ASI_CRM_SegmentationCriteria__c (Name='Test',ASI_CRM_Channel__c=channel.Id, ASI_CRM_Outlet_New_Image__c='Iconic',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SegmentationCriteria__cASI_CRM_CN_Segmentation_Criteria'));
        INSERT SegmentationCriteria;

        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c,LanguageLocaleKey FROM USER WHERE id =:UserInfo.getUserId()];
        currentUser.LanguageLocaleKey='zh_CN';
        update currentUser;
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        
        
        
        
        List<ASI_HK_CRM_Product_Category__c> ProductCategoryList= new List<ASI_HK_CRM_Product_Category__c> ();
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category1',ASI_CRM_CN_Chinese_Name__c='Category',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=1,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category2',ASI_CRM_CN_Chinese_Name__c='Category2',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=2,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category3',ASI_CRM_CN_Chinese_Name__c='Category1',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=3,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        
        insert ProductCategoryList;
        
        
        
        
        List<ASI_TH_CRM_Sub_category__c> SubCategoryList= new List<ASI_TH_CRM_Sub_category__c>();
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory1',ASI_CRM_CN_Product_Category__c=ProductCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory2',ASI_CRM_CN_Product_Category__c=ProductCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory3',ASI_CRM_CN_Product_Category__c=ProductCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        
        insert SubCategoryList;
        
        
        List<ASI_MFM_Brand__c> BrandList = new List<ASI_MFM_Brand__c> ();
        BrandList.add(new ASI_MFM_Brand__c (Name='Test1',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test2',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test3',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        
        Insert BrandList;
        
        
        
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='Premium',ASI_CRM_Chinese_Name__c='Test1',ASI_CRM_Chinese_Description__c='1. Standard + Premium 标准档 + 高档',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_MFM_Active_for_CRM__c=true,ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[1].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[2].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
        }
        
        insert subBrands;
        
        
        List<ASI_CRM_Sub_Brand_Assignment__c> SubBrandAssignmentList= new List<ASI_CRM_Sub_Brand_Assignment__c>();
        for(ASI_MFM_Sub_brand__c SubBrandItem:subBrands){
        	SubBrandAssignmentList.add(new ASI_CRM_Sub_Brand_Assignment__c(ASI_CRM_Sub_Brand__c=SubBrandItem.Id,ASI_CRM_Segmentation_Criteria__c=SegmentationCriteria.Id));
        }
        
        insert SubBrandAssignmentList;


        List<ASI_MFM_A_C_Code__c> ACCodeList = new  List<ASI_MFM_A_C_Code__c>();
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='0000000000000', ASI_MFM_A_C_Code__c='000010000',ASI_MFM_A_C_Description__c='ASI_CRM_CN_Variable_Cost_Contract',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.010000 PRC - Bottle Return Service', ASI_MFM_A_C_Code__c='5275.010000',ASI_MFM_A_C_Description__c='Bottle Return Service',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.020000 Promotion Service Fee', ASI_MFM_A_C_Code__c='5275.020000',ASI_MFM_A_C_Description__c='Promotion Service Fee',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.030000 PRC - Variable Event Cost', ASI_MFM_A_C_Code__c='5275.030000',ASI_MFM_A_C_Description__c='Variable Event Cost',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        
        insert ACCodeList;
        
        
        List<ASI_CRM_Contract_Cost_Setting__c> ContractCostSettingList= new List<ASI_CRM_Contract_Cost_Setting__c>();
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=true,ASI_CRM_CN_Variable_Cost_Contract__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_CN_BRSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_PSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_VEC_Activity_Code_Defaul__c=true));
        
        insert ContractCostSettingList;
        
        ASI_CRM_SpecialPromotionTypeSetting__c oldspts = new ASI_CRM_SpecialPromotionTypeSetting__c( ASI_CRM_Promotion_Type__c = 'a');
        insert oldspts;
        
        ASI_CRM_SpecialPromotionTypeSetting__c newspts = new ASI_CRM_SpecialPromotionTypeSetting__c(ASI_CRM_Promotion_Type__c = 'Heavy Contract On',recordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SpecialPromotionTypeSetting__cASI_CRM_CN_SpecialPromotionTypeSetting'));
        insert newspts;
        
        ASI_CRM_Special_Promotion_Type_Mapping__c sptm = new ASI_CRM_Special_Promotion_Type_Mapping__c(ASI_CRM_Mapping_of_New_Promotion_Type__c = newspts.Id,ASI_CRM_Mapping_of_Old_Promotion_Type__c = oldspts.Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Special_Promotion_Type_Mapping__cASI_CRM_CN_Special_Promotion_Type_Mapping'));
        insert sptm;
        
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;
        
        
        ASI_TH_CRM_Contract__c GroupContract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Group_Contract'),
                                                                          ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                          ASI_CRM_CN_PO_End_Date__c =PO_End_Date,ASI_CRM_Martell_BC_Rate__c=0.95,
                                                                          Name = 'Noah C4',ASI_CRM_CN_Bottle_Collection_Rate__c=0.97,
                                                                          ASI_CRM_CN_Outlet_WS__c=Customers[1].Id);
        insert GroupContract;
        
        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Final',ASI_CRM_CN_Group_Contract__c=GroupContract.Id,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,ASI_CRM_Martell_BC_Rate__c=0.95,
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date,ASI_CRM_CN_Bottle_Collection_Rate__c=0.97,
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract1',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
        
        
        List<ASI_CRM_Methodology__c> MethodologyList= new List<ASI_CRM_Methodology__c> ();
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='PSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='Variable Event Cost',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        
        
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF'));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='PSF'));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='Variable Event Cost'));
        insert MethodologyList;
        
        
        //Methodology Assignment
        List<ASI_CRM_Methodology_Assignment__c> MethodologyAssignmentList = new List<ASI_CRM_Methodology_Assignment__c>();
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[0].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[1].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[2].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[3].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[4].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[5].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        
        insert MethodologyAssignmentList ;
        
        
        
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF',ASI_CRM_Methodology__c=MethodologyList[0].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Grade',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Category',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='Variable Event Cost',ASI_CRM_Methodology__c=MethodologyList[2].Id));
        
        insert ModuleList;
        
        
        List<ASI_CRM_Contract_Cost__c> ContractCostList = new List<ASI_CRM_Contract_Cost__c>();
        ASI_CRM_Contract_Cost__c contractCost1 = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,ASI_CRM_CN_Chinese_Description__c='店家支持',
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',ASI_CRM_CN_Contract_Amount__c=100,
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        ContractCostList.add(contractCost1);
        ASI_CRM_Contract_Cost__c contractCost2 = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,ASI_CRM_CN_Chinese_Description__c='Test1',
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',ASI_CRM_CN_Contract_Amount__c=100,
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        ContractCostList.add(contractCost2);
        
        insert ContractCostList;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='PSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }

        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Grade',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Sub_Brand_Grade__c=grades[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Category',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[3].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Product_Category__c=ProductCategoryList[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[4].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[5].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='Variable Event Cost',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
         }
        
        insert ContractLineList;
        
        
        List<ASI_Attachment__c> AttachmentList=new List<ASI_Attachment__c>();
        ASI_Attachment__c Attachment1=new ASI_Attachment__c (ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Type__c='Historical Data',ASI_CRM_For_Contract_Use__c=true);
        Attachment1.ASI_CRM_Historical_Financial_Data__c='[{"Volumes":0.0,"TotalMBCRate":97.00,"VariableExpensesMap":{},"VariableExpense":0.0,"TradeExpenses":0.0,"TotalBCRate":79.00,"SubBrandGradeMap":{},"SubBrandGradeGrouping":{},"ROIProForma":0.0,"ROIIntake":0.0,"ROIActual":0.0,"PSFVolumeBase":"","PSFMethodologyName":"","POStartDate":"2017-11-24","POEndDate":"2017-11-24","OutletSet":[],"NoOfMonths":1,"NetBCRate":0.0,"MarginPerBottle":0.0,"MarginAfterAnP":0.0,"LBGSId":" ","LBCMId":" ","LatestBudgetCMTotal":0.0,"InvestmentCR12":0.0,"IntakeSTD":0.0,"IntakeCR12":0.0,"GSId":" ","GrossSalesTotal":0.0,"GrossSalesRate":0.0,"FixedExpensesMap":{},"FixedExpenseRate":0.0,"FixedExpense":0.0,"DebugMap":{},"ContractLineMap":{},"ContractId":"","CMTotal":0.0,"CMId":" ","CategoryMap":{},"BRSFMethodologyName":"","BCRate":0.0,"AddOnString":""},{"Volumes":0.0,"VariableExpensesMap":{},"VariableExpense":0.0,"TradeExpenses":0.0,"TotalMBCRate":97.00,"TotalBCRate":0.0,"SubBrandGradeMap":{},"SubBrandGradeGrouping":{},"ROIProForma":0.0,"ROIIntake":0.0,"ROIActual":0.0,"PSFVolumeBase":"","PSFMethodologyName":"","POStartDate":"2017-11-24","POEndDate":"2017-11-24","OutletSet":[],"NoOfMonths":1,"NetBCRate":0.0,"MarginPerBottle":0.0,"MarginAfterAnP":0.0,"LBGSId":" ","LBCMId":" ","LatestBudgetCMTotal":0.0,"InvestmentCR12":0.0,"IntakeSTD":0.0,"IntakeCR12":0.0,"GSId":" ","GrossSalesTotal":0.0,"GrossSalesRate":0.0,"FixedExpensesMap":{},"FixedExpenseRate":0.0,"FixedExpense":0.0,"DebugMap":{},"ContractLineMap":{},"ContractId":"","CMTotal":0.0,"CMId":" ","CategoryMap":{},"BRSFMethodologyName":"","BCRate":0.0,"AddOnString":"{}"}]';
       
         AttachmentList.add(Attachment1);
        
        ASI_Attachment__c Attachment2=new ASI_Attachment__c (ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Type__c='Contract Data',ASI_CRM_For_Contract_Use__c=true);    
        Attachment2.ASI_CRM_Historical_Financial_Data__c='[{"Volumes":693.666684,"VariableExpensesMap":{},"VariableExpense":1018000.00,"TradeExpenses":1887000.00,'+
            '"TotalBCRate":95.00,"TotalMBCRate":97.00,"SubBrandGradeMap":{"3. Ultra Premium 特级高档":506.666676,"4. Prestige + Ultra Prestige 奢华档 + 特级奢华档":187.000008},'+
            '"SubBrandGradeGrouping":{"Ultra Premium":506.666676,"Prestige":182.000004,"Ultra Prestige":5.000004},"ROIProForma":1.72276737916712241653418124006359,"ROIIntake":1.72,'+
            '"ROIActual":1.72,"PSFVolumeBase":"By Sub-Brand(按品牌);By Grade(按品牌档次);By Category(按产品类别);By Total(按总销量);","PSFMethodologyName":"aGmM0000000002fKAA;","POStartDate":"2017-07-01","POEndDate":"2018-06-30","OutletSet":[],'+
            '"NoOfMonths":12,"NetBCRate":0.0,"MarginPerBottle":156.77,"MarginAfterAnP":1363862.044488360000,"LBGSId":" ","LBCMId":" ","LatestBudgetCMTotal":3250862.044488360000,"InvestmentCR12":87.60,"IntakeSTD":8700,"IntakeCR12":21540.00,"GSId":" ",'+
            '"GrossSalesTotal":4437343.493984880000,"GrossSalesRate":42.53,"FixedExpensesMap":{},"FixedExpenseRate":46.05,"FixedExpense":869000.00,"DebugMap":{},"ContractLineMap":{},"ContractId":"a8cM00000004YapIAE","CMTotal":3250862.044488360000,"CMId":" ","CategoryMap":{"Whisky":247.333332,"Wine":186.666672,"Champagne":125.000004,"Brandy":130.000008,"Others":4.666668},"BRSFMethodologyName":"aGmM0000000002BKAQ","BCRate":95.00,"AddOnString":""},{"Volumes":1387.333332,"VariableExpensesMap":{},"VariableExpense":2036000.00,"TradeExpenses":3774000.00,"TotalBCRate":95.00,"SubBrandGradeMap":'+
            '{"3. Ultra Premium 特级高档":1013.333328,"4. Prestige + Ultra Prestige 奢华档 + 特级奢华档":374.000004},"SubBrandGradeGrouping":{"Ultra Premium":1013.333328,"Prestige":364.000008,"Ultra Prestige":9.999996},"ROIProForma":1.72276733288937996820349761526232,"ROIIntake":1.72276733288937996820349761526232,"ROIActual":1.72276733288937996820349761526232,"PSFVolumeBase":"By Sub-Brand(按品牌);By Grade(按品牌档次);By Category(按产品类别);By Total(按总销量);","PSFMethodologyName":"aGmM0000000002fKAA;","POStartDate":"2017-07-01","POEndDate":"2018-06-30","OutletSet":[],'+
            '"NoOfMonths":12,"NetBCRate":0.0,"MarginPerBottle":156.77,"MarginAfterAnP":2727723.914324520000,"LBGSId":" ","LBCMId":" ","LatestBudgetCMTotal":6501723.914324520000,"InvestmentCR12":87.60,"IntakeSTD":17400,"IntakeCR12":43080.00,"GSId":" aA2M0000000BG8cKAG;aA2M0000000BG6iKAG;aA2M0000000BG39KAG;aA2M0000000BG2iKAG;aA2M0000000BG2cKAG;aA2M0000000BG2CKAW;aA2M0000000BG12KAG;aA2M0000000BG4pKAG;","GrossSalesTotal":8874686.744130720000,"GrossSalesRate":42.53,"FixedExpensesMap":{"PRC - Fixed event cost - On Premise 夜店活动费用(固定)":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"","SubBrandGrade":"","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"'+
            'HistoricalBottles":0.0,"EstimateVolume":0.0,"EstimateTotalFees":0.0,"EstimateFees":0.00,"EstimateBottles":0.0,"ContractVolume":0.0,"ContractTotalFees":0.0,"ContractFees":0.00,"ContractBottles":0.0},"PRC - Store/Outlet Support 店家支持":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"","SubBrandGrade":"","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":0.0,"EstimateTotalFees":0.0,"EstimateFees":869000.00,"EstimateBottles":0.0,"ContractVolume":0.0,"ContractTotalFees":0.0,"ContractFees":1738000.00,"ContractBottles":0.0}},"FixedExpenseRate":46.05,"FixedExpense":1738000.00,"DebugMap":{},"ContractLineMap":{"00003芝华士18年 Chivas 18YO-CH2":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"芝华士18年 Chivas 18YO-CH2","SubBrandGrade":"Ultra Premium","SubBrandCategory":"","strSubBrand":"","'+
            'HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":900,"EstimateTotalFees":27000.00,"EstimateFees":30.00,"EstimateBottles":75,"ContractVolume":1800,"ContractTotalFees":54000.00,"ContractFees":30.00,"ContractBottles":150},"00003百龄坛15年 Ballantines 15YO-B15":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"百龄坛15年 Ballantines 15YO-B15","SubBrandGrade":"Ultra Premium","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"'+
            'HistoricalBottles":0.0,"EstimateVolume":2400,"EstimateTotalFees":72000.00,"EstimateFees":30.00,"EstimateBottles":200,"ContractVolume":4800,"ContractTotalFees":144000.00,"ContractFees":30.00,"ContractBottles":400},"00003玛姆红带特级干型 Mumm Cordon Rouge-MUR":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"玛姆红带特级干型 Mumm Cordon Rouge-MUR","SubBrandGrade":"Ultra Premium","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":1500'+
            ',"EstimateTotalFees":45000.00,"EstimateFees":30.00,"EstimateBottles":125,"ContractVolume":3000,"ContractTotalFees":90000.00,"ContractFees":30.00,"ContractBottles":250},"00003巴黎之花干型 Perrier Jouet Others-PJO":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"巴黎之花干型 Perrier Jouet Others-PJO","SubBrandGrade":"Ultra Premium","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":1500,"EstimateTotalFees":45000.00,"EstimateFees":30.00,"EstimateBottles":125,"ContractVolume":3000,"ContractTotalFees":90000.00,"ContractFees":30.00,"ContractBottles":250},"00002马爹利蓝带 Martell Cordon Bleu-ML2":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"马爹利蓝带 Martell Cordon Bleu-ML2","SubBrandGrade":"Prestige","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":1140,"'+
            'EstimateTotalFees":57000.00,"EstimateFees":50.00,"EstimateBottles":95,"ContractVolume":2280,"ContractTotalFees":114000.00,"ContractFees":50.00,"ContractBottles":190},"00002马爹利XO Martell XO-ML6":{"VFi'+
            'nalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"马爹利XO Martell XO-ML6","SubBrandGrade":"Prestige","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":1140,"EstimateTotalFees":57000.00,"EstimateFees":50.00,"EstimateBottles":95,"ContractVolume":2280,"ContractTotalFees":114000.00,"ContractFees":50.00,"ContractBottles":190},"00002皇家礼炮21年 Royal Salute 21YO-ROC":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"皇家礼炮21年 Royal Salute 21YO-ROC","SubBrandGrade":"Prestige","SubBrandCategory":"","strSubBrand":"","HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":60,"EstimateTotalFees":3000.00,"EstimateFees":50.00,"EstimateBottles":5,"ContractVolume":120,"ContractTotalFees":6000.00,"ContractFees":50.00,"ContractBottles":10},"00001巴黎之花美丽时光 Perrier Jouet Belle Epoque-PJB":{"VFinalVolume":0.0,"VFinalTotalFees":0.0,"VFinalFees":0.0,"VFinalBottles":0.0,"SubBrandName":"巴黎之花美丽时光 Perrier Jouet Belle Epoque-PJB","SubBrandGrade":"Ultra Prestige","SubBrandCategory":"","strSubBrand":"","'+
            'HistoricalVolume":0.0,"HistoricalTotalFees":0.0,"HistoricalFees":0.0,"HistoricalBottles":0.0,"EstimateVolume":60,"EstimateTotalFees":3000.00,"EstimateFees":50.00,"EstimateBottles":5,"ContractVolume":120,"ContractTotalFees":6000.00,"ContractFees":50.00,"ContractBottles":10}},"ContractId":"","CMTotal":6501723.914324520000,"CMId":" aA2M0000000BFrCKAW;aA2M0000000BFkmKAG;aA2M0000000BFjcKAG;aA2M0000000BFnPKAW;aA2M0000000BFljKAG;aA2M0000000BFlIKAW;aA2M0000000BFlCKAW;aA2M0000000BFpIKAW;","CategoryMap":{"Whisky":494.666676,"Wine":373.333332,"Champagne":249.999996,"Brandy":259.999992,"Others":9.333336},"BRSFMethodologyName":"aGmM0000000002BKAQ","BCRate":95.00,"AddOnString":""}]';
        AttachmentList.add(Attachment2); 
        insert AttachmentList;
        
        
        test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',Contract.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(Contract);  
        ASI_CRM_CN_HeavyProfitShuttleCtrl con = new ASI_CRM_CN_HeavyProfitShuttleCtrl(stdController);
        con.init();
        con.strPDF='1';
        con.checkLastRBAID();
        con.checkUserID();
        con.checkApprover();
        
        List<ASI_CRM_Approval_Comment__c> ApprovalCommentList= new List<ASI_CRM_Approval_Comment__c>();
        ApprovalCommentList.add(new ASI_CRM_Approval_Comment__c(ASI_CRM_Contract__c=Contract.Id,recordtypeid = Global_RecordTypeCache.getRTId('ASI_CRM_Approval_Comment__cASI_CRM_CN_New_Contract_Comment'),ASI_CRM_Background_Objective__c='Test1',ASI_CRM_New_contract_Analsysis__c='Test2',ASI_CRM_Historical_Contract_Performance__c='Test3'));
        ApprovalCommentList.add(new ASI_CRM_Approval_Comment__c(ASI_CRM_Contract__c=Contract.Id,recordtypeid = Global_RecordTypeCache.getRTId('ASI_CRM_Approval_Comment__cASI_CRM_CN_PO_Contract_Comment'),ASI_CRM_Background_Objective__c='Test1',ASI_CRM_New_contract_Analsysis__c='Test2',ASI_CRM_Historical_Contract_Performance__c='Test3'));
        
        
        insert ApprovalCommentList;
        
        ApexPages.currentPage().getParameters().put('id',Contract.Id);
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(Contract);  
        ASI_CRM_CN_HeavyProfitShuttleCtrl con2 = new ASI_CRM_CN_HeavyProfitShuttleCtrl(stdController2);
        con2.strPDF='3';
        con2.init();
        
        test.stopTest(); 
        
    }
    
    
    
    static testMethod void HeavyContractGenerationTest1() {//Test ASI_CRM_CN_HeavyContractGenerationCtrl
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id,ASI_CRM_CN_City_Tier__c='2');
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        
        ASI_CRM_SegmentationCriteria__c SegmentationCriteria= new ASI_CRM_SegmentationCriteria__c (Name='Test',ASI_CRM_Channel__c=channel.Id, ASI_CRM_Outlet_New_Image__c='Iconic',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SegmentationCriteria__cASI_CRM_CN_Segmentation_Criteria'));
        INSERT SegmentationCriteria;

        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c,LanguageLocaleKey FROM USER WHERE id =:UserInfo.getUserId()];
        currentUser.LanguageLocaleKey='zh_CN';
        update currentUser;
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        
        
        
        
        List<ASI_HK_CRM_Product_Category__c> ProductCategoryList= new List<ASI_HK_CRM_Product_Category__c> ();
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category1',ASI_CRM_CN_Chinese_Name__c='Category',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=1,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category2',ASI_CRM_CN_Chinese_Name__c='Category2',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=2,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category3',ASI_CRM_CN_Chinese_Name__c='Category1',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=3,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        
        insert ProductCategoryList;
        
        
        
        
        List<ASI_TH_CRM_Sub_category__c> SubCategoryList= new List<ASI_TH_CRM_Sub_category__c>();
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory1',ASI_CRM_CN_Product_Category__c=ProductCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory2',ASI_CRM_CN_Product_Category__c=ProductCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory3',ASI_CRM_CN_Product_Category__c=ProductCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        
        insert SubCategoryList;
        
        
        List<ASI_MFM_Brand__c> BrandList = new List<ASI_MFM_Brand__c> ();
        BrandList.add(new ASI_MFM_Brand__c (Name='Test1',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test2',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test3',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        
        Insert BrandList;
        
        
        
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='Premium',ASI_CRM_Chinese_Name__c='Test1',ASI_CRM_Chinese_Description__c='1. Standard + Premium 标准档 + 高档',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_MFM_Active_for_CRM__c=true,ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[1].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[2].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
        }
        
        insert subBrands;
        
        
        List<ASI_CRM_Sub_Brand_Assignment__c> SubBrandAssignmentList= new List<ASI_CRM_Sub_Brand_Assignment__c>();
        for(ASI_MFM_Sub_brand__c SubBrandItem:subBrands){
        	SubBrandAssignmentList.add(new ASI_CRM_Sub_Brand_Assignment__c(ASI_CRM_Sub_Brand__c=SubBrandItem.Id,ASI_CRM_Segmentation_Criteria__c=SegmentationCriteria.Id));
        }
        
        insert SubBrandAssignmentList;


        List<ASI_MFM_A_C_Code__c> ACCodeList = new  List<ASI_MFM_A_C_Code__c>();
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='0000000000000', ASI_MFM_A_C_Code__c='000010000',ASI_MFM_A_C_Description__c='ASI_CRM_CN_Variable_Cost_Contract',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.010000 PRC - Bottle Return Service', ASI_MFM_A_C_Code__c='5275.010000',ASI_MFM_A_C_Description__c='Bottle Return Service',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.020000 Promotion Service Fee', ASI_MFM_A_C_Code__c='5275.020000',ASI_MFM_A_C_Description__c='Promotion Service Fee',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.030000 PRC - Variable Event Cost', ASI_MFM_A_C_Code__c='5275.030000',ASI_MFM_A_C_Description__c='Variable Event Cost',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        
        insert ACCodeList;
        
        
        List<ASI_CRM_Contract_Cost_Setting__c> ContractCostSettingList= new List<ASI_CRM_Contract_Cost_Setting__c>();
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=true,ASI_CRM_CN_Variable_Cost_Contract__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_CN_BRSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_PSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_VEC_Activity_Code_Defaul__c=true));
        
        insert ContractCostSettingList;
        
        ASI_CRM_SpecialPromotionTypeSetting__c oldspts = new ASI_CRM_SpecialPromotionTypeSetting__c( ASI_CRM_Promotion_Type__c = 'a');
        insert oldspts;
        
        ASI_CRM_SpecialPromotionTypeSetting__c newspts = new ASI_CRM_SpecialPromotionTypeSetting__c(ASI_CRM_Promotion_Type__c = 'Heavy Contract On',recordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SpecialPromotionTypeSetting__cASI_CRM_CN_SpecialPromotionTypeSetting'));
        insert newspts;
        
        ASI_CRM_Special_Promotion_Type_Mapping__c sptm = new ASI_CRM_Special_Promotion_Type_Mapping__c(ASI_CRM_Mapping_of_New_Promotion_Type__c = newspts.Id,ASI_CRM_Mapping_of_Old_Promotion_Type__c = oldspts.Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Special_Promotion_Type_Mapping__cASI_CRM_CN_Special_Promotion_Type_Mapping'));
        insert sptm;
        
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;
        
        
        ASI_TH_CRM_Contract__c GroupContract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Group_Contract'),
                                                                          ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                          ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                          Name = 'Noah C4',ASI_CRM_CN_Bottle_Collection_Rate__c=0.97,
                                                                          ASI_CRM_CN_Outlet_WS__c=Customers[1].Id);
        insert GroupContract;
        
        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Final',ASI_CRM_CN_Group_Contract__c=GroupContract.Id,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,ASI_CRM_Martell_BC_Rate__c=0.97,
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date,ASI_CRM_CN_Bottle_Collection_Rate__c=0.97,
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract1',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
        
        
        List<ASI_CRM_Methodology__c> MethodologyList= new List<ASI_CRM_Methodology__c> ();
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF'));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='PSF'));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='Variable Event Cost'));
        
        
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF'));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='PSF'));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='Variable Event Cost'));
        insert MethodologyList;
        
        
        //Methodology Assignment
        List<ASI_CRM_Methodology_Assignment__c> MethodologyAssignmentList = new List<ASI_CRM_Methodology_Assignment__c>();
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[0].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[1].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[2].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[3].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[4].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[5].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        
        insert MethodologyAssignmentList ;
        
        
        
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF',ASI_CRM_Methodology__c=MethodologyList[0].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Grade',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Category',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='Variable Event Cost',ASI_CRM_Methodology__c=MethodologyList[2].Id));
        
        insert ModuleList;
        
        
        List<ASI_CRM_Contract_Cost__c> ContractCostList = new List<ASI_CRM_Contract_Cost__c>();
        ASI_CRM_Contract_Cost__c contractCost1 = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,ASI_CRM_CN_Chinese_Description__c='店家支持',
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',ASI_CRM_CN_Contract_Amount__c=100,
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        ContractCostList.add(contractCost1);
        ASI_CRM_Contract_Cost__c contractCost2 = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,ASI_CRM_CN_Chinese_Description__c='Test1',
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',ASI_CRM_CN_Contract_Amount__c=100,
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        ContractCostList.add(contractCost2);
        
        insert ContractCostList;
        String ContractCostLinesJson = '["'+contractCost1.Id+'// Test"]';
        
        
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='PSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }

        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Grade',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Sub_Brand_Grade__c=grades[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Category',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[3].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Product_Category__c=ProductCategoryList[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[4].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[5].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='Variable Event Cost',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
         }
        
        insert ContractLineList;
        folder f=[select id from folder where Type='Document' limit 1 ];

        
        
        String XMLTestString='<source> <header> <section name="Sales and Branding Promotion Agreement" displayNumber="" style="text-align: center;font-size: 20px;" class="" > <content>销售和品牌推广协议</content> <type>Read</type> </section> <section name="drink on the premises" displayNumber="" style="text-align: center;font-size: 18px;" class="" > <content>堂饮</content> <type>Read</type> </section> <section name="Party A" displayNumber="" style="" class="" > <content>甲方：{1}(店家名称) </content> <type>Read</type> </section> <section name="Party B" displayNumber="" style="" class="" > <content>乙方：保乐力加（中国）贸易有限公司 </content> <type>Read</type> </section> <section name="Party C" displayNumber="" style="" class="" > <content>丙方：{1}(批发商名称) </content> <type>Read</type> </section> </header> <body> <section name="Header with original contract" displayNumber="" style="font-weight: bold;" class="" > <content>鉴于：</content> <type>Read</type> </section> <section name="WhereasA" displayNumber="A" style="" class="" > <title></title> <content>甲方为堂饮服务类企业；乙方为保乐力加产品在中国的独家总经销商；丙方为保乐力加产品在甲方所在城市的批发商及甲方的供货商。</content> <type>Read</type> </section> <section name="WhereasB" displayNumber="B" style="" class="" > <content>乙方为在甲方所在地方推广保乐力加产品品牌、提高产品的知名度并打击假冒伪劣产品，愿意与甲方合作，由甲方配合其市场营销活动提供有关品牌推广服务。丙方作为甲方的直接供货商，愿意为甲方和乙方在品牌发展方面的合作提供物流等方面的协助。</content> <type>Read</type> </section> <section name="WhereasC" displayNumber="C" style="" class="" > <content>同时，为促进保乐力加产品在甲方渠道的销售，协议三方将在甲方渠道开展以打折让利等形式进行促销。</content> <type>Read</type> </section> <section name="Agreement" displayNumber="" style="" class="" > <content>现经友好协商，三方达成协议如下：</content> <type>Read</type> </section> <section name="TermsofthisAgreement" displayNumber="1" style="font-weight: bold;" class="" > <content>协议期限</content> <type>Read</type> </section> <section name="Terms of this Agreement" displayNumber="" style="" class="" > <content>本协议期限自{1}年{2}月{3}日 至{4}年{5}月{6}日。</content> <type>Read</type> </section> <section name="Products" displayNumber="1" style="font-weight: bold;" class="" > <content>产品</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="" style="" class="" > <content>三方同意在甲方店内销售保乐力加产品，产品具体名称、规格等见产品清单 （下称“保乐力加产品”或“产品”）。</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="3" style="font-weight: bold;" class="" > <content>订货和交付</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="a" style="" class="" > <content>甲方应通过订单的形式向丙方订购产品，该订单中应明确订购产品的数量和要求的交货日期。产品的所有订单均须获得丙方的批准。丙方可对所订购产品的数量根据现有库存进行调整，同时不应就未经其接受的购买订单向该客户承担责任。 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="b" style="" class="" > <content>丙方应在订单约定的时间期限内，将货物交付到指定地点和接收人。订单发出后，未经丙方同意，不得对丙方已经收到的任何订单做出修改。</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="c" style="" class="" > <content>甲方订购的所有产品均根据标准商业惯例进行包装以便运输和储存。订购产品的灭失和损害风险在指定的交货地点向甲方交付该等订购产品后转移给甲方。如有承运人的，则订购产品的灭失和损害风险自交由第一承运人起转移给甲方。甲方应在收到货物后对货物进行检验。如果货物有破损或包装货物发生短缺，则甲方应立即通知丙方，且在运输公司代表在场的情况下，甲方可拒收破损的货物。破损或短缺的问题应通过召回或调换的方式予以解决。</content> <type>Read</type> </section> <section name="Conditions for Payment" displayNumber="3" style="font-weight: bold;" class="" > <content>货款的付款条件</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="" style="" class="" > <content>本协议项下有关订购产品货款的支付，甲方应以人民币通过银行转账或约定的其他付款方式支付给丙方。</content> <type>Read</type> </section> <section name="Promotion, sales target and sales discount" displayNumber="5" style="font-weight: bold;" class="" > <content>品牌推广服务、销量目标和销售折扣</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="a" style="" class="" > <content>甲方的承诺和责任。 乙方致力于在甲方渠道提高保乐力加产品及品牌的知名度和形象，甲方同意在其店内向其提供如下品牌推广服务，并尽其最大努力完成约定的销量目标：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>在店内外提供如下品牌的形象宣传服务(具体计划和安排，由双方另行协商确定）</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 陈列放有保乐力加产品广告的灯箱；</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 在店内电子LED上（如有）播放保乐力加产品信息或广告；</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 店内装饰装修上采用与保乐力加产品品牌相关的元素和装饰；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内显著位置放置保乐力加产品陈列柜或在店内陈列柜及显著位置陈列保乐力加产品；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内派送保乐力加产品的宣传品与物料；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 保乐力加产品信息出现在酒水单前列；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内桌上放置含有保乐力加产品信息的台卡等。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>授予保乐力加产品在店内的促销权，并配合乙方的促销活动提供如下服务：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 为乙方的促销服务提供场地；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 同意乙方向店内派驻促销代表以宣传、推广保乐力加产品。该促销代表的数量和来源由甲、乙双方协商确定；乙方促销员应遵守店内的规章制度；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 同意配合乙方的市场营销计划在店内开展保乐力加产品的促销活动（具体促销活动计划和安排，由双方另行协商确定）。</content> <type>Read</type> </section> <section name="" displayNumber="(3)" style="" class="" > <content>同意并配合乙方在各类节庆及其他时间开展各种品牌活动，包括各种派对、演出、晚宴或品酒会及品牌展示和促销活动（由乙方根据其具体的市场营销计划最终确定）等。</content> <type>Read</type> </section> <section name="" displayNumber="(4)" style="" class="" > <content>尽最大努力完成销量目标。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="b" style="" class="" > <content>乙方的权利和义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>因品牌推广计划尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的上述服务项目进行调整，包括增加、取消或变更部分服务项目等，并和甲方协商确定销量目标。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>乙方同意：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 甲方可获得一定服务费用（具体金额和付款条件根据最终确定后的形象宣传活动细节、促销活动方案、甲方品牌活动计划另行约定）和在符合约定条件的前提下享受相应的销售折扣，甲乙双方必须将折扣如实入账；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 及时向甲方提供和品牌形象宣传有关的宣传品、酒具、物料等材料。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 根据甲方的需要向其员工提供一定酒类培训，具体培训的次数、地点和内容由双方协商确定。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="c" style="" class="" > <content>丙方的义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>本条所述品牌推广服务费和销售折扣的全部或部分由丙方支付给甲方。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="d" style="" class="" > <content>服务费用及销售折扣的支付应以甲方在协议期限内遵守本协议之约定为前提。在付款方向甲方支付任何费用之前，甲方应开具符合中国法律、法规规定及中国税务部门要求的、由中国税务部门监制的记载相应款项的发票。各方对上述各项收付款应在其财务帐上真实明确记载。</content> <type>Read</type> </section> <section name="" displayNumber="6" style="font-weight: bold;" class="" > <content> 打假措施 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content> 为保护乙方的知识产权，防止制假者利用保乐力加产品的空瓶、瓶盖或瓶套等产品包装生产假冒伪劣产品,根据乙方要求，甲方应尽力将被要求回收的产品包装悉数退还乙方，由乙方统一回收和销毁。各产品具体的包装回收要求由乙方另行以函件形式通知甲方。为行文简便起见，非经特别说明下文所称“包装“指甲方从丙方进货的保乐力加产品的或乙方要求回收的保乐力加产品的包装。 </content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content> 规范的产品包装回收由乙方委托的人员或委托的第三方物流公司进行，并经乙方确认符合要求，具体回收频率和时间将根据本协议履行过程中甲方的实际的销量确定。 </content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>包装回收率=包装回收的实际数/甲方从丙方的实际进货量。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>乙方包装回收制度的目的是打击假冒伪劣产品，而非鼓励甲方通过从他处回收包装牟利。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>虽然乙方不要求回收包装的所有组件，但甲方承诺不会将保乐力加回收产品包装后剩余的包装组件如空瓶、瓶塞、瓶口防回灌装置或外盒等其它产品包装直接或间接赠送、出售给制假者或者随意丢弃，或自行使用保乐力加产品包装的全部或部分制作伪劣的、假冒的保乐力加产品，否则乙方有权行使本协议第7条第j款下约定的权利。</content> <type>Read</type> </section> <section name="" displayNumber="7" style="font-weight: bold;" class="" > <content>保证</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方承诺其为依法设立并有效存续的法人实体，在签订本协议时并确保在本协议有效期内拥有在其合法登记注册的经营场所内从事酒类销售及相关餐饮娱乐服务的合法有效的营业执照等所有必需的政府批准和许可。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方承诺只在乙方认可的销售渠道中购买保乐力加产品，拒绝销售任何伪劣产品、假货和走私货并且按乙方要求回收产品包装给乙方或其指定人员处理。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方同意，其所采购的保乐力加产品仅限于在自身经营的场所内销售，不得转售任何第三方，除非经乙方和丙方的事先书面同意</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>甲、丙两方须对其与乙方购销产品数量和价格保密，若因甲/丙方泄露相关信息而导致给乙方造成经济损失的，甲/丙方方须赔偿乙方由此产生的全部经济损失。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>甲方声明并同意，未曾且将不会，在为乙方、丙方开展业务的过程中， </content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>违反任何适用的反贿赂政策和反贿赂法；</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>提供、承诺给与、给予、同意接受或接受任何非法贿赂、回扣、回报、影响付款、返利或其他非法支付（包括疏通费）。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>应乙方的要求，甲方随时应将其向乙方提供服务的记录和会计账册提供，以供审查和/或审计使用。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>如果甲方或其关联方、雇员、集团公司、分包商、代理或代表违反陈述，且/或因涉及或从事任何可能构成反贿赂法下犯罪的行为被指控或被调查，乙方应有权单方面立即停止付款或终止本协议，或按照本协议的条款采取适当行为。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>为本条款之目的，“贿赂”是指某人向另一人提供、承诺提供或者给予某项利益，旨在使其（或另外之人）不适当地履行职责，或者将其用作对上述人员不当履行职责之酬劳。索取或者同意收受上述利益也属于贿赂行为。 通过第三方提供或者收受贿赂并不影响行为性质，仍应认定为贿赂行为。贿赂所涉及的利益可以采用财物或其他手段。财物是指现金和实物，包括现金和实物，任何包括假借促销费、宣传、赞助费、科研费、劳务费、咨询费、佣金等名义，或者以报销各种费用等方式，给付另一方的财物；任何其他手段包括提供国内外各种名义的旅游、考察等给付财物以外的其他利益的手段。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>甲方同意向乙方提供保乐力加产品的销售信息（包括进货、存货、价格、销售情况、消费者反映等）以及与乙方业务相关的其它市场信息。甲方同意，乙方人员有权查看甲方账目和销售情况以核实甲方提供的销售信息，甲方工作人员应当予以积极配合，否则乙方有权决定甲方不予获得当期的品牌推广服务费以及A类销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="g" style="" class="" > <content>甲方应遵守酒类销售相关法规并将对理性饮酒行动提供适当的支持，包括但不限于： </content> <type>Read</type> <subSection> <section name="" displayNumber="●" style="" class="" > <content>拒绝向疑似未成年人或孕妇出售酒精饮料；</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力避免向醉酒人员出售或推销酒精饮料；及</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力劝阻酒后驾车行为。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="h" style="" class="" > <content>甲方保证，甲方及其关联方在任何时候均遵守所有适用的反洗钱法律法规，并且未曾涉及任何未决或潜在的反洗钱法律诉讼。如果有合理的理由怀疑甲方的任何交易涉及洗钱活动，甲方应当在知悉该等理由后三（3）个工作日以内，向乙方提交一份列明可疑理由的报告。甲方应当停止与涉及可疑交易的任何客户的所有活动，直至进一步的调查使得乙方断定客户并未涉及该等活动。甲方不得向其客户或任何第三方披露提交给乙方报告有关的任何信息，也不得披露正在、已经或将要执行的调查细节或事实。 </content> <type>Read</type> </section> <section name="" displayNumber="i" style="font-weight: bold;" class="" > <content>利益冲突</content> <type>Read</type> </section> <section name="" displayNumber="i" style="" class="" > <content>甲方在此承诺：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>至本协议签署之日，在其最大的认知程度内保证没有导致利益冲突（定义如下）的情况出现，或保证已经就已存在的利益冲突向乙方批露了相关信息。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>在本协议有效期内，如有任何确切或潜在的利益冲突情况发生或可能发生，自知道或应该知道之日起三日内，以书面形式通知乙方。乙方有权决定是否继续本协议。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>利益冲突的定义：当甲方或其雇员、代理或代表在履行本协议时，因自身利益或与乙方有竞争或有业务往来的任何组织存在义务、亲属关系或其他特殊利害关系，这些关系可能使得甲方在履行本协议时影响其的判断或评价，导致对乙方产生实际的或潜在的损害。</content> <type>Read</type> </section> <section name="" displayNumber="j" style="font-weight: bold;" class="" > <content>违反本条第a、b、c、d、e、f、g、h、i款的规定构成对本协议的根本违约，乙方有权停止支付本协议下的任何费用并有权随时终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="8" style="font-weight: bold;" class="" > <content>知识产权</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方/丙方保证不论在本协议期间或终止后其不会生产或销售或恶意致使任何人或任何单位生产或销售假冒保乐力加产品或任何其名称、商标或包装、装潢与保乐力加产品相似并易引起混淆的产品。一旦发现存在侵犯或潜在侵犯乙方或其母公司或关联方的专利、商标、著作权、商业秘密以及其它知识产权权益的行为，甲方/丙方应立即通知乙方，并应与乙方通力合作制止此类侵权行为。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方/丙方不得变更、修改或移除任何保乐力加产品上的任何商标、专利声明、著作权声明及产品之上的任何其它标志，也不得在任何此类产品上附加任何其它的标志。甲方/丙方保证从本协议生效之日起，对产品的销售和使用均不会构成任何对乙方或其母公司或关联公司的专利、商标、著作权、商业秘密以及其它知识产权权益的侵犯。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方/丙方不得使用 "Pernod Ricard”，“保乐力加”或保乐力加任何产品的品牌（包括中英文） 作为其名称、简称的一部分。未经乙方明确的书面同意，亦不得用任何方式使用乙方或其母公司或关联公司的字号、任何标志、图形、文字、代号。 在任何情况下，甲方/丙方也不得使用乙方、其母公司及关联方的企业名称作为其企业名称。</content> <type>Read</type> </section> <section name="" displayNumber="9" style="font-weight: bold;" class="" > <content>违约责任</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>本协议存续期间，如果一方未能履行本协议规定的义务和保证，除本协议明确约定的救济手段以外， 违约方还应向其它协议方承担损失赔偿责任。</content> <type>Read</type> </section> <section name="" displayNumber="10" style="font-weight: bold;" class="" > <content>协议的延长和终止 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>如任何一方在协议期内严违约（如违反第7条和第8条）、有欺诈性行为、遇政府法令禁止经营活动或被申请破产、清算或解散的，协议其它方有权向该方发出书面要求终止协议，本协议即随即终止。丙方具有上述情况的，乙方有权通过一级分销商立即终止丙方二级分销商的资格，同时通知甲方与新的二级分销商签订本协议，甲/丙方对上述安排应积极配合。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>除上述情况以外，如果甲/丙方未能履行本协议规定的其它义务和保证，乙方将给予违约方十五（15）个工作日的改正期，若期满后违约方行为未能得到改善和纠正，则视为严重违约，乙方有权立即终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>协议的终止不影响无过错方向违约方主张经济上的违约或损害赔偿的权利以及协议中有关保密义务和知识产权义务的继续。</content> <type>Read</type> </section> <section name="" displayNumber="11" style="font-weight: bold;" class="" > <content>其它</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>本协议期满后，在同等条件下，乙方有优先续约权。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>在任何情况下，未经一方允许，协议其它方不得将本协议的签署、本协议的内容及在本协议履行过程中获悉的该方的机密信息（包括该方或其关联公司的任何非公开资料包括商业策略，客户信息，批发商信息，活动计划，销量，价格、生意模式及商业秘密等）泄漏给任何第三方或本方的无关人员或用于本协议以外的目的。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>除非本协议另有约定，否则任何一方在征得另二方事先书面同意之前均不得转让本协议或其相关权益。但乙方有权在书面通知甲方和丙方后，将本协议或其相关权益转让给乙方的关联方。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>若本协议规定一方不得作出某行为，则应当解释为该一方均不得以任何直接或间接的方式或通过任何第三方作出该行为。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>凡因本协议引起的或与本协议有关的任何争议，应先协商解决；协商不成的，任何一方均有权向上海市黄浦区人民法院提起诉讼。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>本协议一式三份，三方各持有一份。本协议自双方授权代表签字或盖章后生效。其它未尽事宜，由各方协商解决。</content> <type>Read</type> </section> </body> <BodySignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>甲方： {1}// 乙方：保乐力加（中国）贸易有限公司</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： // 签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // 日 期： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="BodySignature2" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>丙 方：// </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>签字盖章： // </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // </content> <type>Read</type> </section> </BodySignature> <appendix> <section name="Appendix 1" displayNumber="" style="font-size: 18px;" class="" > <content>附件一</content> <type>Read</type> </section> <section name="Brand promotion plan and target of sales" displayNumber="" style="text-align: center;font-size: 16px;" class="" > <content>品牌推广计划和销售目标</content> <type>Read</type> </section> <section name="FixCostTableHeader" displayNumber="1" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务及费用明细 &lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="FixCostTableLineHeader" displayNumber="" style="" class="" > <content>因品牌推广计划在签订协议时尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的下述服务项目进行调整，包括增加、取消或变更部分服务项目等。</content> <type>Read</type> </section> <section name="FixCostTable" displayNumber="" style="" class="" description="Do Not change the name" > <content></content> <type>Read</type> <subSection> <section name="" displayNumber="1" style="" class="" > <content> 形象推广服务//形象推广费用//金额//备注</content> <type>Read</type> </section> <section name="" displayNumber="2" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount} " > <content> {FixedCostACCode}// 1)灯箱、LED、电子屏幕、其它广告形式 &lt;br/&gt; 2)产品陈列、店内外装饰、酒水单、台卡等附加广告宣传&lt;br/&gt; 3)派送宣传物料、广告礼品等 // 1)灯箱、LED等广告租赁费 &lt;br/&gt; 2)陈列广告费 // {InputAmount} //该项费用在本协议签订后【 】个月后支付，甲方需要提供相应的形象宣传照片等支持文件。 </content> <type>Read</type> </section> <section name="" displayNumber="4" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount}" > <content> {FixedCostACCode}// 同意并协助乙方在店内举行品牌活动，如派对活动等 // N/A // {InputAmount} //该项费用在双方确定具体活动计划时确定具体支付时间和方式。</content> <type>Read</type> </section> <section name="" displayNumber="5" style="" class="" > <content> &lt;br/&gt; // &lt;br/&gt; // 总计： // {FXTotalAmount} //&lt;br/&gt;</content> <type>Read</type> </section> <section name="FixCostTable_InputText" displayNumber="6" style="" class="colspan4" > <content> 备注：// {InputText}</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="2" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;销量目标和销售折扣&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="SalesDiscount" displayNumber="" style="" class="AppendixLineHeader" > <content>为进一步推广保乐力加产品，乙方对其产品的经销企业实行销售折扣的政策。在符合约定前提条件的情况下，甲方可享受一定的销售折扣。具体要求如下：</content> <type>Read</type> <subSection> <section name="Sales_Discount_of_A_Class" displayNumber="2.1" style="font-weight: bold;" class="displayNumber" > <content>A类销售折扣: </content> <type>Read</type> </section> <section name="BRSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品名称和规格// 单瓶月销量目标//单瓶销售折扣//合同总销量//合同总销售折扣</content> <type>Read</type> <subSection> <section name="BRSFTableA" displayNumber="" style="" class="2colspan4" > <content>季度A类销售折扣计算方式 //季度A类销售折扣=单瓶销售折扣X确认为甲方从丙方进货的且当季包装被规范回收的保乐力加产品数量单位：瓶）于下一季度内结算。 </content> <type>Read</type> </section> <section name="BRSFTableB" displayNumber="" style="" class="2colspan4 2InputText" description="Do Not change the name" > <content>备注//享受A类销售折扣的前提 1) 季度销量（或进货额）不低于XXX（可选项）;且2) 符合其他约定条件 </content> <type>Read</type> </section> </subSection> </section> <section name="Non_standard_Convert" displayNumber="" style="" class="" > <content>非标准规格折算：[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;] </content> <type>Read</type> </section> <section name="PSFTableHeader" displayNumber="2.2" style="font-weight: bold;" class="displayNumber" > <content>B类销售折扣: </content> <type>Read</type> </section> <section name="PSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标// 合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="BySubBrand displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByGrade displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌档次完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByCategory displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按产品类别完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByTotal displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按总销量完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="PSFTableA" displayNumber="" style="" class="1rowspan1 2colspan4 2InputText BySubBrand" description="Do Not change the name format and the name should be unique" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableD" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByGrade" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableG" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByCategory" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableI" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByTotal" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> <section name="Event_Support" displayNumber="2.3" style="font-weight: bold;" class="displayNumber" > <content>活动支持费用 </content> <type>Read</type> </section> <section name="Event_Support 1" displayNumber="" style="" class="" > <content>甲方完成下述约定的销量指标是进一步享受活动支持费用的前提条件。 </content> <type>Read</type> </section> <section name="VECTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标 //合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="VECTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="VECTableA" displayNumber="" style="" class="2colspan4 2InputText BySubBrand" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableB" displayNumber="" style="" class="2colspan4 2InputText ByGrade" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableC" displayNumber="" style="" class="2colspan4 2InputText ByCategory" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableD" displayNumber="" style="" class="2colspan4 2InputText ByTotal" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> </subSection> </section> <section name="Payment Conditions" displayNumber="3" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务费及销售折扣的支付条件&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="1)" style="" class="" > <content>甲方依据约定为乙方开展的各项品牌推广活动提供场地、便利和其他支持是甲方获得品牌推广服务费的前提条件。 </content> <type>Read</type> </section> <section name="Payment_Conditions_BC_Rate" displayNumber="2)" style="" class="" > <content>包装回收率不低于 {BCRate} ，系甲方享受各类销售折扣的前提条件之一。包装回收率超过100%时，按100%封顶计。 </content> <type>Read</type> </section> <section name="Payment_ConditionsC" displayNumber="3)" style="" class="" description="Do Not change the {1}-{6}" > <content>{0}年{1}月{2}日至{3}年{4}月{5}日期间，假设甲方100%完成销量目标，且包装回收率为100%，则预计A类销售折扣总计人民币{6}元。本条系预估，对乙方不具有约束力。 </content> <type>Selectable</type> </section> <section name="Selectable1" displayNumber="4)" style="" class="" description="Please Input Name Field" > <content>如果本协议期内，甲方未能完成约定的年度B类销量指标，则本协议自动延期直至B类销量指标完成为止。协议延续期间本协议各方的权利义务保持不变，品牌推广服务费除外(无自动延续)。 </content> <type>Selectable</type> </section> <section name="" displayNumber="5)" style="" class="" > <content>甲方同意上述各项品牌推广服务费可以现金或产品实物的形式支付。 </content> <type>Read</type> </section> <section name="" displayNumber="6)" style="" class="" > <content>甲方始终遵守以下第4条的各项承诺。 </content> <type>Read</type> </section> </subSection> </section> <section name="Party A undertakes" displayNumber="4" style="font-weight: bold;" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;甲方承诺&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="a)" style="" class="" > <content>将在法律允许的范围内在甲方场地尽其最大商业努力推销乙方产品。 </content> <type>Read</type> </section> <section name="" displayNumber="b)" style="" class="" > <content>甲方场地内用于调制杯饮类的副酒将尽量使用乙方品类中相应品种的产品。 </content> <type>Read</type> </section> <section name="" displayNumber="c)" style="" class="" > <content>在甲方场地重点展示乙方产品及其品牌。 </content> <type>Read</type> </section> <section name="" displayNumber="d)" style="" class="" > <content>应乙方不时之请求，为乙方的品牌在场内举行促销活动提供场地和服务。 </content> <type>Read</type> </section> <section name="PartyAUndertakes_e" displayNumber="e)" style="" class="" > <content>{InputText} </content> <type>Selectable</type> </section> </subSection> </section> <section name="Affiliates_List" displayNumber="5" style="font-weight: bold;" class="AppendixLineHeader" description="Party A under the Agreement shall also include its affiliates " > <content> &lt;b&gt;&lt;u&gt;为避免疑义，本协议项下的甲方亦指其关联公司&lt;/u&gt; &lt;/b&gt; ：{Outlet}</content> <type>Read</type> </section> </appendix> <AppendixSignature> </AppendixSignature> </source>';
       
            
            
       String XMLTestString2='<source> <header> <section name="Sales and Branding Promotion Agreement" displayNumber="" style="text-align: center;font-weight: bold;"> <content>销售和品牌推广协议</content> <type>Read</type> </section> <section name="drink on the premises" displayNumber="" style="text-align: center;font-weight: bold;"> <content>堂饮</content> <type>Read</type> </section> <section name="Party A" displayNumber="" style=""> <content>甲方：{InputWholesaler}(店家名称) </content> <type>Read</type> </section> <section name="Party B" displayNumber="" style=""> <content>乙方：保乐力加（中国）贸易有限公司 </content> <type>Read</type> </section> </header> <body> <section name="Header with original contract" displayNumber="" style="font-weight: bold;"> <content>鉴于：</content> <type>Read</type> </section> <section name="WhereasA" displayNumber="A" style=""> <title></title> <content>甲方为保乐力加产品在甲方所在市场的批发商，在传统堂饮渠道拥有丰富客户资源；乙方为保乐力加产品在中国的独家总经销商；</content> <type>Read</type> </section> <section name="WhereasB" displayNumber="B" style=""> <content>乙方为在甲方所在渠道推广保乐力加产品品牌、提高产品的知名度并打击假冒伪劣产品，愿意与甲方合作。</content> <type>Read</type> </section> <section name="Agreement" displayNumber="" style=""> <content>现经友好协商，双方达成协议如下：</content> <type>Read</type> </section> <section name="TermsofthisAgreement" displayNumber="1" style="font-weight: bold;"> <content>协议期限</content> <type>Read</type> </section> <section name="Terms of this Agreement" displayNumber="" style=""> <content>本协议期限自{1}年{2}月{3}日 至{4}年{5}月{6}日。</content> <type>Read</type> </section> <section name="ProductsPart" displayNumber="2" style="font-weight: bold;" class="" > <content>拓展堂饮门店及产品</content> <type>Read</type> <subSection> <section name="" displayNumber="a" style="" class="" > <content>双方同意在以下堂饮门店（以下简称“门店“）内推广并销售保乐力加产品：</content> <type>Read</type> </section> <section name="ProductsPart1" displayNumber="" style="" class="" > <content>{CoveredOutletTable}</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方在上述堂饮渠道销售之保乐力加产品的具体名称、规格等见产品清单 （下称“保乐力加产品” 或“产品”）。</content> <type>Read</type> </section> </subSection> </section> <section name="All parties sell Products" displayNumber="3" style="font-weight: bold;"> <content>订货、交付与货款支付 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="a" style=""> <content>甲方应当通过乙方认可的销售渠道采购保乐力加产品。 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="b" style=""> <content>甲方向门店供应产品，具体订货、交付和货款支付细节由甲方与门店另行约定，与乙方无涉。</content> <type>Read</type> </section> <section name="Conditions for Payment" displayNumber="4" style="font-weight: bold;"> <content>货款的付款条件</content> <type>Read</type> </section> <section name="Promotion, sales target and sales discount" displayNumber="4" style="font-weight: bold;"> <content>品牌推广服务、销量目标和销售折扣</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="a" style=""> <content>甲方的承诺和责任。 乙方致力于在甲方渠道提高保乐力加产品及品牌的知名度和形象，甲方同意在其店内向其提供如下品牌推广服务，并尽其最大努力完成约定的销量目标：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style=""> <content>在店内外提供如下品牌的形象宣传服务(具体计划和安排，由双方另行协商确定）</content> <type>Read</type> </section> <section name=" " displayNumber="" style=""> <content>• 陈列放有保乐力加产品广告的灯箱；</content> <type>Read</type> </section> <section name=" " displayNumber="" style=""> <content>• 在店内电子LED上（如有）播放保乐力加产品信息或广告；</content> <type>Read</type> </section> <section name=" " displayNumber="" style=""> <content>• 店内装饰装修上采用与保乐力加产品品牌相关的元素和装饰；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 在店内显著位置放置保乐力加产品陈列柜或在店内陈列柜及显著位置陈列保乐力加产品；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 在店内派送保乐力加产品的宣传品与物料；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 保乐力加产品信息出现在酒水单前列；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 在店内桌上放置含有保乐力加产品信息的台卡等。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style=""> <content>授予保乐力加产品在店内的促销权，并配合乙方的促销活动提供如下服务：</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 为乙方的促销服务提供场地；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 同意乙方向店内派驻促销代表以宣传、推广保乐力加产品。该促销代表的数量和来源由甲、乙双方协商确定；乙方促销员应遵守店内的规章制度；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 同意配合乙方的市场营销计划在店内开展保乐力加产品的促销活动（具体促销活动计划和安排，由双方另行协商确定）。</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 在店内桌上放置含有保乐力加产品信息的台卡等。</content> <type>Read</type> </section> <section name="" displayNumber="(3)" style=""> <content>同意并配合乙方在各类节庆及其他时间开展各种品牌活动，包括各种派对、演出、晚宴或品酒会及品牌展示和促销活动（由乙方根据其具体的市场营销计划最终确定）等。</content> <type>Read</type> </section> <section name="" displayNumber="(4)" style=""> <content>尽最大努力完成销量目标。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="b" style=""> <content>乙方的权利和义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style=""> <content>因品牌推广计划尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的上述服务项目进行调整，包括增加、取消或变更部分服务项目等，并和甲方协商确定销量目标。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style=""> <content>乙方同意：</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 甲方可获得一定服务费用（具体金额和付款条件根据最终确定后的形象宣传活动细节、促销活动方案、甲方品牌活动计划另行约定）和在符合约定条件的前提下享受相应的销售折扣，甲乙双方必须将折扣如实入账；</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 及时向甲方提供和品牌形象宣传有关的宣传品、酒具、物料等材料。</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>• 根据甲方的需要向其员工提供一定酒类培训，具体培训的次数、地点和内容由双方协商确定。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="c" style=""> <content>丙方的义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style=""> <content>本条所述品牌推广服务费和销售折扣的全部或部分由丙方支付给甲方。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="d" style=""> <content>服务费用及销售折扣的支付应以甲方在协议期限内遵守本协议之约定为前提。在付款方向甲方支付任何费用之前，甲方应开具符合中国法律、法规规定及中国税务部门要求的、由中国税务部门监制的记载相应款项的发票。各方对上述各项收付款应在其财务帐上真实明确记载。</content> <type>Read</type> </section> <section name="" displayNumber="5" style="font-weight: bold;"> <content> 打假措施 </content> <type>Read</type> </section> <section name="" displayNumber="a" style=""> <content> 为保护乙方的知识产权，防止制假者利用保乐力加产品的空瓶、瓶盖或瓶套等产品包装生产假冒伪劣产品,根据乙方要求，甲方应尽力将被要求回收的产品包装悉数退还乙方，由乙方统一回收和销毁。各产品具体的包装回收要求由乙方另行以函件形式通知甲方。为行文简便起见，非经特别说明下文所称“包装“指甲方从丙方进货的保乐力加产品的或乙方要求回收的保乐力加产品的包装。 </content> <type>Read</type> </section> <section name="" displayNumber="b" style=""> <content> 规范的产品包装回收由乙方委托的人员或委托的第三方物流公司进行，并经乙方确认符合要求，具体回收频率和时间将根据本协议履行过程中甲方的实际的销量确定。 </content> <type>Read</type> </section> <section name="" displayNumber="c" style=""> <content>包装回收率=包装回收的实际数/甲方从丙方的实际进货量。</content> <type>Read</type> </section> <section name="" displayNumber="d" style=""> <content>乙方包装回收制度的目的是打击假冒伪劣产品，而非鼓励甲方通过从他处回收包装牟利。</content> <type>Read</type> </section> <section name="" displayNumber="e" style=""> <content>虽然乙方不要求回收包装的所有组件，但甲方承诺不会将保乐力加回收产品包装后剩余的包装组件如空瓶、瓶塞、瓶口防回灌装置或外盒等其它产品包装直接或间接赠送、出售给制假者或者随意丢弃，或自行使用保乐力加产品包装的全部或部分制作伪劣的、假冒的保乐力加产品，否则乙方有权行使本协议第7条第j款下约定的权利。</content> <type>Read</type> </section> <section name="" displayNumber="6" style="font-weight: bold;"> <content>保证</content> <type>Read</type> </section> <section name="" displayNumber="a" style=""> <content>甲方承诺其为依法设立并有效存续的法人实体，在签订本协议时并确保在本协议有效期内拥有在其合法登记注册的经营场所内从事酒类销售及相关餐饮娱乐服务的合法有效的营业执照等所有必需的政府批准和许可。</content> <type>Read</type> </section> <section name="" displayNumber="b" style=""> <content>甲方承诺只在乙方认可的销售渠道中购买保乐力加产品，拒绝销售任何伪劣产品、假货和走私货并且按乙方要求回收产品包装给乙方或其指定人员处理。</content> <type>Read</type> </section> <section name="" displayNumber="c" style=""> <content>甲方同意，其所采购的保乐力加产品仅限于在自身经营的场所内销售，不得转售任何第三方，除非经乙方和丙方的事先书面同意</content> <type>Read</type> </section> <section name="" displayNumber="d" style=""> <content>甲、丙两方须对其与乙方购销产品数量和价格保密，若因甲/丙方泄露相关信息而导致给乙方造成经济损失的，甲/丙方方须赔偿乙方由此产生的全部经济损失。</content> <type>Read</type> </section> <section name="" displayNumber="e" style=""> <content>甲方声明并同意，未曾且将不会，在为乙方、丙方开展业务的过程中， </content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style=""> <content>违反任何适用的反贿赂政策和反贿赂法；</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style=""> <content>提供、承诺给与、给予、同意接受或接受任何非法贿赂、回扣、回报、影响付款、返利或其他非法支付（包括疏通费）。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style=""> <content>应乙方的要求，甲方随时应将其向乙方提供服务的记录和会计账册提供，以供审查和/或审计使用。</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>如果甲方或其关联方、雇员、集团公司、分包商、代理或代表违反陈述，且/或因涉及或从事任何可能构成反贿赂法下犯罪的行为被指控或被调查，乙方应有权单方面立即停止付款或终止本协议，或按照本协议的条款采取适当行为。</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>为本条款之目的，“贿赂”是指某人向另一人提供、承诺提供或者给予某项利益，旨在使其（或另外之人）不适当地履行职责，或者将其用作对上述人员不当履行职责之酬劳。索取或者同意收受上述利益也属于贿赂行为。 通过第三方提供或者收受贿赂并不影响行为性质，仍应认定为贿赂行为。贿赂所涉及的利益可以采用财物或其他手段。财物是指现金和实物，包括现金和实物，任何包括假借促销费、宣传、赞助费、科研费、劳务费、咨询费、佣金等名义，或者以报销各种费用等方式，给付另一方的财物；任何其他手段包括提供国内外各种名义的旅游、考察等给付财物以外的其他利益的手段。</content> <type>Read</type> </section> <section name="" displayNumber="f" style=""> <content>甲方同意向乙方提供保乐力加产品的销售信息（包括进货、存货、价格、销售情况、消费者反映等）以及与乙方业务相关的其它市场信息。甲方同意，乙方人员有权查看甲方账目和销售情况以核实甲方提供的销售信息，甲方工作人员应当予以积极配合，否则乙方有权决定甲方不予获得当期的品牌推广服务费以及A类销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="g" style=""> <content>甲方应遵守酒类销售相关法规并将对理性饮酒行动提供适当的支持，包括但不限于： </content> <type>Read</type> <subSection> <section name="" displayNumber="●" style=""> <content>在适当范围内努力避免向醉酒人员出售或推销酒精饮料；及</content> <type>Read</type> </section> <section name="" displayNumber="●" style=""> <content>在适当范围内努力劝阻酒后驾车行为。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="h" style=""> <content>甲方保证，甲方及其关联方在任何时候均遵守所有适用的反洗钱法律法规，并且未曾涉及任何未决或潜在的反洗钱法律诉讼。如果有合理的理由怀疑甲方的任何交易涉及洗钱活动，甲方应当在知悉该等理由后三（3）个工作日以内，向乙方提交一份列明可疑理由的报告。甲方应当停止与涉及可疑交易的任何客户的所有活动，直至进一步的调查使得乙方断定客户并未涉及该等活动。甲方不得向其客户或任何第三方披露提交给乙方报告有关的任何信息，也不得披露正在、已经或将要执行的调查细节或事实。 </content> <type>Read</type> </section> <section name="" displayNumber="i" style="font-weight: bold;"> <content>利益冲突</content> <type>Read</type> </section> <section name="" displayNumber="i" style=""> <content>甲方在此承诺：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style=""> <content>至本协议签署之日，在其最大的认知程度内保证没有导致利益冲突（定义如下）的情况出现，或保证已经就已存在的利益冲突向乙方批露了相关信息。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style=""> <content>在本协议有效期内，如有任何确切或潜在的利益冲突情况发生或可能发生，自知道或应该知道之日起三日内，以书面形式通知乙方。乙方有权决定是否继续本协议。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style=""> <content>利益冲突的定义：当甲方或其雇员、代理或代表在履行本协议时，因自身利益或与乙方有竞争或有业务往来的任何组织存在义务、亲属关系或其他特殊利害关系，这些关系可能使得甲方在履行本协议时影响其的判断或评价，导致对乙方产生实际的或潜在的损害。</content> <type>Read</type> </section> <section name="" displayNumber="j" style="font-weight: bold;"> <content>违反本条第a、b、c、d、e、f、g、h、i款的规定构成对本协议的根本违约，乙方有权停止支付本协议下的任何费用并有权随时终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="7" style="font-weight: bold;"> <content>知识产权</content> <type>Read</type> </section> <section name="" displayNumber="a" style=""> <content>甲方/丙方保证不论在本协议期间或终止后其不会生产或销售或恶意致使任何人或任何单位生产或销售假冒保乐力加产品或任何其名称、商标或包装、装潢与保乐力加产品相似并易引起混淆的产品。一旦发现存在侵犯或潜在侵犯乙方或其母公司或关联方的专利、商标、著作权、商业秘密以及其它知识产权权益的行为，甲方/丙方应立即通知乙方，并应与乙方通力合作制止此类侵权行为。</content> <type>Read</type> </section> <section name="" displayNumber="b" style=""> <content>甲方/丙方不得变更、修改或移除任何保乐力加产品上的任何商标、专利声明、著作权声明及产品之上的任何其它标志，也不得在任何此类产品上附加任何其它的标志。甲方/丙方保证从本协议生效之日起，对产品的销售和使用均不会构成任何对乙方或其母公司或关联公司的专利、商标、著作权、商业秘密以及其它知识产权权益的侵犯。</content> <type>Read</type> </section> <section name="" displayNumber="b" style=""> <content>甲方/丙方不得使用 "Pernod Ricard”，“保乐力加”或保乐力加任何产品的品牌（包括中英文） 作为其名称、简称的一部分。未经乙方明确的书面同意，亦不得用任何方式使用乙方或其母公司或关联公司的字号、任何标志、图形、文字、代号。 在任何情况下，甲方/丙方也不得使用乙方、其母公司及关联方的企业名称作为其企业名称。</content> <type>Read</type> </section> <section name="" displayNumber="8" style="font-weight: bold;"> <content>违约责任</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>本协议存续期间，如果一方未能履行本协议规定的义务和保证，除本协议明确约定的救济手段以外， 违约方还应向其它协议方承担损失赔偿责任。</content> <type>Read</type> </section> <section name="" displayNumber="9" style="font-weight: bold;"> <content>协议的延长和终止 </content> <type>Read</type> </section> <section name="" displayNumber="a" style=""> <content>如任何一方在协议期内严违约（如违反第7条和第8条）、有欺诈性行为、遇政府法令禁止经营活动或被申请破产、清算或解散的，协议其它方有权向该方发出书面要求终止协议，本协议即随即终止。丙方具有上述情况的，乙方有权通过一级分销商立即终止丙方二级分销商的资格，同时通知甲方与新的二级分销商签订本协议，甲/丙方对上述安排应积极配合。</content> <type>Read</type> </section> <section name="" displayNumber="b" style=""> <content>除上述情况以外，如果甲/丙方未能履行本协议规定的其它义务和保证，乙方将给予违约方十五（15）个工作日的改正期，若期满后违约方行为未能得到改善和纠正，则视为严重违约，乙方有权立即终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="c" style=""> <content>协议的终止不影响无过错方向违约方主张经济上的违约或损害赔偿的权利以及协议中有关保密义务和知识产权义务的继续。</content> <type>Read</type> </section> <section name="" displayNumber="10" style="font-weight: bold;"> <content>其它</content> <type>Read</type> </section> <section name="" displayNumber="a" style=""> <content>本协议期满后，在同等条件下，乙方有优先续约权。</content> <type>Read</type> </section> <section name="" displayNumber="b" style=""> <content>在任何情况下，未经一方允许，协议其它方不得将本协议的签署、本协议的内容及在本协议履行过程中获悉的该方的机密信息（包括该方或其关联公司的任何非公开资料包括商业策略，客户信息，批发商信息，活动计划，销量，价格、生意模式及商业秘密等）泄漏给任何第三方或本方的无关人员或用于本协议以外的目的。</content> <type>Read</type> </section> <section name="" displayNumber="c" style=""> <content>除非本协议另有约定，否则任何一方在征得另二方事先书面同意之前均不得转让本协议或其相关权益。但乙方有权在书面通知甲方和丙方后，将本协议或其相关权益转让给乙方的关联方。</content> <type>Read</type> </section> <section name="" displayNumber="d" style=""> <content>若本协议规定一方不得作出某行为，则应当解释为该一方均不得以任何直接或间接的方式或通过任何第三方作出该行为。</content> <type>Read</type> </section> <section name="" displayNumber="e" style=""> <content>凡因本协议引起的或与本协议有关的任何争议，应先协商解决；协商不成的，任何一方均有权向上海市黄浦区人民法院提起诉讼。</content> <type>Read</type> </section> <section name="" displayNumber="f" style=""> <content>本协议一式贰份，双方各持有一份。本协议自双方授权代表签字或盖章后生效。其它未尽事宜，由双方协商解决。</content> <type>Read</type> </section> </body> <BodySignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;"> <content>甲方： {InputWholesaler}// 乙方：保乐力加（中国）贸易有限公司</content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content></content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>签字盖章： // 签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content></content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>日 期： // 日 期： </content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content></content> <type>Read</type> </section> </BodySignature> <appendix> <section name="Appendix 1" displayNumber="" style="font-size: 18px;" > <content>附件一</content> <type>Read</type> </section> <section name="Brand promotion plan and target of sales" displayNumber="" style="text-align: center;font-size: 16px;" class="" > <content>品牌推广计划和销售目标</content> <type>Read</type> </section> <section name="" displayNumber="1" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务及费用明细 &lt;/u&gt; &lt;/b&gt;因品牌推广计划在签订协议时尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的下述服务项目进行调整，包括增加、取消或变更部分服务项目等。</content> <type>Read</type> </section> <section name="FixCostTable" displayNumber="" style="" description="Do Not change the name" > <content></content> <type>Read</type> <subSection> <section name="" displayNumber="1" style="" class="" > <content> 形象推广服务//形象推广费用//金额//备注</content> <type>Read</type> </section> <section name="" displayNumber="2" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount} " > <content> {FixedCostACCode}// 1)灯箱、LED、电子屏幕、其它广告形式 2)产品陈列、店内外装饰、酒水单、台卡等附加广告宣传 3)派送宣传物料、广告礼品等 // 1)灯箱、LED等广告租赁费 2)陈列广告费 // {InputAmount} //该项费用在本协议签订后【 】个月后支付，甲方需要提供相应的形象宣传照片等支持文件。 </content> <type>Read</type> </section> <section name="" displayNumber="4" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount}" > <content> {FixedCostACCode}// 同意并协助乙方在店内举行品牌活动，如派对活动等 // N/A // {InputAmount} //该项费用在双方确定具体活动计划时确定具体支付时间和方式。</content> <type>Read</type> </section> <section name="" displayNumber="5" style="" class="" > <content> &lt;br/&gt; // &lt;br/&gt; // 总计： // {FXTotalAmount} //&lt;br/&gt;</content> <type>Read</type> </section> <section name="FixCostTable_InputText" displayNumber="6" style="" class="colspan4" > <content> 备注：// {InputText}</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="2" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;销量目标和销售折扣&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="SalesDiscount" displayNumber="" style="" class="AppendixLineHeader" > <content>为进一步推广保乐力加产品，乙方对其产品的经销企业实行销售折扣的政策。在符合约定前提条件的情况下，甲方可享受一定的销售折扣。具体要求如下：</content> <type>Read</type> <subSection> <section name="Sales_Discount_of_A_Class" displayNumber="2.1" style="font-weight: bold;" class="displayNumber" > <content>A类销售折扣: </content> <type>Read</type> </section> <section name="BRSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品名称和规格// 单瓶月销量目标//单瓶销售折扣//合同总销量//合同总销售折扣</content> <type>Read</type> <subSection> <section name="BRSFTableB" displayNumber="" style="" class="2colspan4 2InputText" description="Do Not change the name" > <content>备注//享受A类销售折扣的前提 1) 季度销量（或进货额）不低于XXX（可选项）;且2) 符合其他约定条件 </content> <type>Read</type> </section> </subSection> </section> <section name="Non_standard_Convert" displayNumber="" style="" class="" > <content>非标准规格折算：[1L = 1.3x70cl; 1.5L = 2x70cl; 3L = 4x70cl; 4.5L = 6x70cl] </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content> A类销售折扣的支付条件: </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>当各品牌包装回收率超过100%时，乙方根据超出的品牌实际进货量计算以支付店家A类销售折扣。 </content> <type>Read</type> </section> <section name="ContractLineAddOn" displayNumber="" style="" class="" > <content>在合同期间，假设甲方100%完成销量目标，且包装回收率为100%，则预计A类销售折扣总计{BRSFTotalEstAmount}元。本条为预估，对乙方不具有约束力。 </content> <type>Read</type> </section> <section name="" displayNumber="2.2" style="font-weight: bold;"> <content>B类销售折扣: </content> <type>Read</type> </section> <section name="Sales_Discount_of_B_Class" displayNumber="" style=""> <content>甲方完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标// 合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="BySubBrand displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByGrade displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌档次完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByCategory displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按产品类别完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByTotal displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按总销量完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="PSFTableA" displayNumber="" style="" class="1rowspan1 2colspan4 2InputText BySubBrand" description="Do Not change the name format and the name should be unique" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableD" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByGrade" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableG" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByCategory" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableI" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByTotal" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="font-size: 14px; " description="Do Not change the name" > <content>B类销售折扣的支付条件: </content> <type>Read</type> </section> <section name="KeySubBrandPart" displayNumber="" style="" description="Do Not change the name" > <content>● 店家选择{Key-SubBrand}作为主要策略品牌，合同期内进货上述策略品牌达到其销量目标的100%（不能以其他品牌销量抵扣），是B类销售折扣支付的前提条件。</content> <type>Read</type> </section> <section name="ContractLineAddOn" displayNumber="" style="" description="Do Not change the name" > <content>● 每次申请支付的金额以上述策略品牌中最低的目标销量达成率乘以合同B类销售折扣总额为限。全年B类销售折扣总额不超过{OutputPSFTotalAmount}元。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" description="Do Not change the name" > <content>● 芝华士12年以下级别产品不参加B类销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="" style="" description="Do Not change the name" > <content>● B类销售折扣支付需要考核各品牌合同至今包装回收率，计算方式如下：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" description="Do Not change the name" > <content> a) 若各品牌的合同至今包装回收率达到规定值，支付金额 = 各品牌B类单瓶销售折扣X各品牌确认为甲方拓展门店从甲方进货的保乐力加产品数量的加总之和；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" description="Do Not change the name" > <content> b) 若各品牌的合同至今包装回收率未达到规定值，支付金额 = 各品牌B类单瓶销售折扣 X 确认为甲方拓展门店从甲方进货的且包装被规范回收的保乐力加产品数量的加总之和。</content> <type>Read</type> </section> <section name="Event_Support" displayNumber="2.3" style="font-weight: bold;"> <content>活动支持费用 </content> <type>Read</type> </section> <section name="Event_Support 1" displayNumber="" style=""> <content>甲方完成下述约定的销量指标是进一步享受活动支持费用的前提条件。 </content> <type>Read</type> </section> <section name="VECTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标 //合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="VECTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="VECTableA" displayNumber="" style="" class="2colspan4 2InputText BySubBrand" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableB" displayNumber="" style="" class="2colspan4 2InputText ByGrade" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableC" displayNumber="" style="" class="2colspan4 2InputText ByCategory" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableD" displayNumber="" style="" class="2colspan4 2InputText ByTotal" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style=""> <content>活动赞助费用的支付条件： </content> <type>Read</type> </section> <section name="Event_Support Remark" displayNumber="" style=""> <content>1) 合同期内进货策略品牌达到其销售目标的{InputPercent1}%，是活动赞助费用支付的前提条件。活动赞助费用按上述表格的总额封顶计，并按干邑类和非干邑类的实际销量达成率考核，每期申请支付的金额以上述策略品牌中最低的销量达成率乘以活动赞助费总额为限。 </content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>2) 芝华士新境12年以下级别产品不参与活动赞助费用。 </content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content>3) 活动赞助费用支付需要考核马爹利产品和非马爹利产品各自的合同至今包装回收率， 计算方式如下： </content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content> a) 若马爹利系列产品和非马爹利系列产品的包装回收率达到规定值，支付金额 = 马爹利系列产品的活动赞助费X马爹利系列产品的销量达成率+非马爹利系列产品的活动赞助费X非马爹利系列产品的销量达成率； </content> <type>Read</type> </section> <section name="" displayNumber="" style=""> <content> b) 若马爹利系列产品和非马爹利系列产品的包装回收率未达到规定值，支付金额 = 马爹利系列产品的活动赞助费X马爹利系列产品的销量达成率X马爹利系列产品的包装回收率+非马爹利系列产品的活动赞助费X非马爹利系列产品的销量达成率X非马爹利系列产品的包装回收率 </content> <type>Read</type> </section> </subSection> </section> <section name="Payment Conditions" displayNumber="3" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务费及销售折扣的支付条件&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="1)" style="" class="" > <content>甲方依据约定为乙方开展的各项品牌推广活动提供场地、便利和其他支持是甲方获得品牌推广服务费的前提条件。 </content> <type>Read</type> </section> <section name="Payment_Conditions_BC_Rate" displayNumber="2)" style="" class="" > <content>马爹利系列产品包装回收率不低于97%，非马爹利系列产品包装回收率不低于 {BCRate} ，系甲方享受各类销售折扣的前提条件之一。包装回收率超过100%时，按100%封顶计。 </content> <type>Read</type> </section> <section name="Payment_ConditionsC" displayNumber="3)" style="" class="" description="Do Not change the {1}-{6}" > <content>{0}年{1}月{2}日至{3}年{4}月{5}日期间，假设甲方100%完成销量目标，且包装回收率为100%，则预计A类销售折扣总计人民币{6}元。本条系预估，对乙方不具有约束力。 </content> <type>Selectable</type> </section> <section name="Selectable1" displayNumber="4)" style="" class="" description="Please Input Name Field" > <content>如果本协议期内，甲方未能完成约定的年度B类销量指标，则本协议自动延期直至B类销量指标完成为止。协议延续期间本协议各方的权利义务保持不变，品牌推广服务费除外(无自动延续)。 </content> <type>Selectable</type> </section> <section name="" displayNumber="5)" style="" class="" > <content>甲方同意上述各项品牌推广服务费可以现金或产品实物的形式支付。 </content> <type>Read</type> </section> <section name="" displayNumber="6)" style="" class="" > <content>甲方始终遵守以下第4条的各项承诺。 </content> <type>Read</type> </section> </subSection> </section> <section name="Party A undertakes" displayNumber="4" style="font-weight: bold;" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;甲方承诺&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="a)" style="" class="" > <content>将在法律允许的范围内在甲方场地尽其最大商业努力推销乙方产品。 </content> <type>Read</type> </section> <section name="" displayNumber="b)" style="" class="" > <content>甲方场地内用于调制杯饮类的副酒将尽量使用乙方品类中相应品种的产品。 </content> <type>Read</type> </section> <section name="" displayNumber="c)" style="" class="" > <content>在甲方场地重点展示乙方产品及其品牌。 </content> <type>Read</type> </section> <section name="" displayNumber="d)" style="" class="" > <content>应乙方不时之请求，为乙方的品牌在场内举行促销活动提供场地和服务。 </content> <type>Read</type> </section> <section name="PartyAUndertakes_e" displayNumber="e)" style="" class="" > <content>{InputText} </content> <type>Selectable</type> </section> </subSection> </section> </appendix> <AppendixSignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" > <content>甲方： {1} </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： </content> <type>Read</type> </section> </AppendixSignature> </source>';
       String XMLTestString3='<source> <header> <section name="Sales and Branding Promotion Agreement" displayNumber="" style="text-align: center;font-size: 20px;" class="" > <content>销售和品牌推广协议</content> <type>Read</type> </section> <section name="drink on the premises" displayNumber="" style="text-align: center;font-size: 18px;" class="" > <content>堂饮</content> <type>Read</type> </section> <section name="Party A" displayNumber="" style="" class="" > <content>甲方：{1}(店家名称) </content> <type>Read</type> </section> <section name="Party B" displayNumber="" style="" class="" > <content>乙方：保乐力加（中国）贸易有限公司 </content> <type>Read</type> </section> <section name="Party C" displayNumber="" style="" class="" > <content>{1} </content> <type>Read</type> </section> </header> <body> <section name="Header with original contract" displayNumber="" style="font-weight: bold;" class="" > <content>鉴于：</content> <type>Read</type> </section> <section name="WhereasA" displayNumber="A" style="" class="" > <title></title> <content>甲方为堂饮服务类企业；乙方为保乐力加产品在中国的独家总经销商；丙方为保乐力加产品在甲方所在城市的批发商及甲方的供货商。</content> <type>Read</type> </section> <section name="WhereasB" displayNumber="B" style="" class="" > <content>乙方为在甲方所在地方推广保乐力加产品品牌、提高产品的知名度并打击假冒伪劣产品，愿意与甲方合作，由甲方配合其市场营销活动提供有关品牌推广服务。丙方作为甲方的直接供货商，愿意为甲方和乙方在品牌发展方面的合作提供物流等方面的协助。</content> <type>Read</type> </section> <section name="WhereasC" displayNumber="C" style="" class="" > <content>同时，为促进保乐力加产品在甲方渠道的销售，协议三方将在甲方渠道开展以打折让利等形式进行促销。</content> <type>Read</type> </section> <section name="Agreement" displayNumber="" style="" class="" > <content>现经友好协商，三方达成协议如下：</content> <type>Read</type> </section> <section name="TermsofthisAgreement" displayNumber="1" style="font-weight: bold;" class="" > <content>协议期限</content> <type>Read</type> </section> <section name="Terms of this Agreement" displayNumber="" style="" class="" > <content>本协议期限自{1}年{2}月{3}日 至{4}年{5}月{6}日。</content> <type>Read</type> </section> <section name="Products" displayNumber="2" style="font-weight: bold;" class="" > <content>产品</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="" style="" class="" > <content>三方同意在甲方店内销售保乐力加产品，产品具体名称、规格等见产品清单 （下称“保乐力加产品”或“产品”）。</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="3" style="font-weight: bold;" class="" > <content>订货和交付</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="a" style="" class="" > <content>甲方应通过订单的形式向丙方订购产品，该订单中应明确订购产品的数量和要求的交货日期。产品的所有订单均须获得丙方的批准。丙方可对所订购产品的数量根据现有库存进行调整，同时不应就未经其接受的购买订单向该客户承担责任。 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="b" style="" class="" > <content>丙方应在订单约定的时间期限内，将货物交付到指定地点和接收人。订单发出后，未经丙方同意，不得对丙方已经收到的任何订单做出修改。</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="c" style="" class="" > <content>甲方订购的所有产品均根据标准商业惯例进行包装以便运输和储存。订购产品的灭失和损害风险在指定的交货地点向甲方交付该等订购产品后转移给甲方。如有承运人的，则订购产品的灭失和损害风险自交由第一承运人起转移给甲方。甲方应在收到货物后对货物进行检验。如果货物有破损或包装货物发生短缺，则甲方应立即通知丙方，且在运输公司代表在场的情况下，甲方可拒收破损的货物。破损或短缺的问题应通过召回或调换的方式予以解决。</content> <type>Read</type> </section> <section name="Conditions for Payment" displayNumber="4" style="font-weight: bold;" class="" > <content>货款的付款条件</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="" style="" class="" > <content>本协议项下有关订购产品货款的支付，甲方应以人民币通过银行转账或约定的其他付款方式支付给丙方。</content> <type>Read</type> </section> <section name="Promotion, sales target and sales discount" displayNumber="5" style="font-weight: bold;" class="" > <content>品牌推广服务、销量目标和销售折扣</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="a" style="" class="" > <content>甲方的承诺和责任。 乙方致力于在甲方渠道提高保乐力加产品及品牌的知名度和形象，甲方同意在其店内向其提供如下品牌推广服务，并尽其最大努力完成约定的销量目标：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>在店内外提供如下品牌的形象宣传服务(具体计划和安排，由双方另行协商确定）</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 陈列放有保乐力加产品广告的灯箱；</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 在店内电子LED上（如有）播放保乐力加产品信息或广告；</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 店内装饰装修上采用与保乐力加产品品牌相关的元素和装饰；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内显著位置放置保乐力加产品陈列柜或在店内陈列柜及显著位置陈列保乐力加产品；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内派送保乐力加产品的宣传品与物料；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 保乐力加产品信息出现在酒水单前列；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内桌上放置含有保乐力加产品信息的台卡等。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>授予保乐力加产品在店内的促销权，并配合乙方的促销活动提供如下服务：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 为乙方的促销服务提供场地；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 同意乙方向店内派驻促销代表以宣传、推广保乐力加产品。该促销代表的数量和来源由甲、乙双方协商确定；乙方促销员应遵守店内的规章制度；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 同意配合乙方的市场营销计划在店内开展保乐力加产品的促销活动（具体促销活动计划和安排，由双方另行协商确定）。</content> <type>Read</type> </section> <section name="" displayNumber="(3)" style="" class="" > <content>同意并配合乙方在各类节庆及其他时间开展各种品牌活动，包括各种派对、演出、晚宴或品酒会及品牌展示和促销活动（由乙方根据其具体的市场营销计划最终确定）等。</content> <type>Read</type> </section> <section name="" displayNumber="(4)" style="" class="" > <content>尽最大努力完成销量目标。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="b" style="" class="" > <content>乙方的权利和义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>因品牌推广计划尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的上述服务项目进行调整，包括增加、取消或变更部分服务项目等，并和甲方协商确定销量目标。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>乙方同意：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 甲方可获得一定服务费用（具体金额和付款条件根据最终确定后的形象宣传活动细节、促销活动方案、甲方品牌活动计划另行约定）和在符合约定条件的前提下享受相应的销售折扣，甲乙双方必须将折扣如实入账；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 及时向甲方提供和品牌形象宣传有关的宣传品、酒具、物料等材料。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 根据甲方的需要向其员工提供一定酒类培训，具体培训的次数、地点和内容由双方协商确定。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="c" style="" class="" > <content>丙方的义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>本条所述品牌推广服务费和销售折扣的全部或部分由丙方支付给甲方。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="d" style="" class="" > <content>服务费用及销售折扣的支付应以甲方在协议期限内遵守本协议之约定为前提。在付款方向甲方支付任何费用之前，甲方应开具符合中国法律、法规规定及中国税务部门要求的、由中国税务部门监制的记载相应款项的发票。各方对上述各项收付款应在其财务帐上真实明确记载。</content> <type>Read</type> </section> <section name="" displayNumber="6" style="font-weight: bold;" class="" > <content> 打假措施 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content> 为保护乙方的知识产权，防止制假者利用保乐力加产品的空瓶、瓶盖或瓶套等产品包装生产假冒伪劣产品,根据乙方要求，甲方应尽力将被要求回收的产品包装悉数退还乙方，由乙方统一回收和销毁。各产品具体的包装回收要求由乙方另行以函件形式通知甲方。为行文简便起见，非经特别说明下文所称“包装“指甲方从丙方进货的保乐力加产品的或乙方要求回收的保乐力加产品的包装。 </content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content> 规范的产品包装回收由甲方自己回收并快递至乙方指定的复核中心，并经乙方确认符合要求，具体回收频率和时间将根据本协议履行过程中门店的实际的销量确定。如甲方在回收过程中偷换、伪造乙方的瓶塞/瓶盖以获取折扣奖励，乙方有权取消或收回该相关折扣奖励，并向甲方主张损害赔偿责任。 </content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>包装回收率=包装回收的实际数/甲方从丙方的实际进货量。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>乙方包装回收制度的目的是打击假冒伪劣产品，而非鼓励甲方通过从他处回收包装牟利。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>虽然乙方不要求回收包装的所有组件，但甲方承诺不会将保乐力加回收产品包装后剩余的包装组件如空瓶、瓶塞、瓶口防回灌装置或外盒等其它产品包装直接或间接赠送、出售给制假者或者随意丢弃，或自行使用保乐力加产品包装的全部或部分制作伪劣的、假冒的保乐力加产品，否则乙方有权行使本协议第7条第j款下约定的权利。</content> <type>Read</type> </section> <section name="" displayNumber="7" style="font-weight: bold;" class="" > <content>保证</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方承诺其为依法设立并有效存续的法人实体，在签订本协议时并确保在本协议有效期内拥有在其合法登记注册的经营场所内从事酒类销售及相关餐饮娱乐服务的合法有效的营业执照等所有必需的政府批准和许可。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方承诺只在乙方认可的销售渠道中购买保乐力加产品，拒绝销售任何伪劣产品、假货和走私货并且按乙方要求回收产品包装给乙方或其指定人员处理。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方同意，其所采购的保乐力加产品仅限于在自身经营的场所内销售，不得转售任何第三方，除非经乙方和丙方的事先书面同意</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>甲、丙两方须对其与乙方购销产品数量和价格保密，若因甲/丙方泄露相关信息而导致给乙方造成经济损失的，甲/丙方方须赔偿乙方由此产生的全部经济损失。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>甲方声明并同意，未曾且将不会，在为乙方、丙方开展业务的过程中， </content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>违反任何适用的反贿赂政策和反贿赂法；</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>提供、承诺给与、给予、同意接受或接受任何非法贿赂、回扣、回报、影响付款、返利或其他非法支付（包括疏通费）。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>应乙方的要求，甲方随时应将其向乙方提供服务的记录和会计账册提供，以供审查和/或审计使用。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>如果甲方或其关联方、雇员、集团公司、分包商、代理或代表违反陈述，且/或因涉及或从事任何可能构成反贿赂法下犯罪的行为被指控或被调查，乙方应有权单方面立即停止付款或终止本协议，或按照本协议的条款采取适当行为。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>为本条款之目的，“贿赂”是指某人向另一人提供、承诺提供或者给予某项利益，旨在使其（或另外之人）不适当地履行职责，或者将其用作对上述人员不当履行职责之酬劳。索取或者同意收受上述利益也属于贿赂行为。 通过第三方提供或者收受贿赂并不影响行为性质，仍应认定为贿赂行为。贿赂所涉及的利益可以采用财物或其他手段。财物是指现金和实物，包括现金和实物，任何包括假借促销费、宣传、赞助费、科研费、劳务费、咨询费、佣金等名义，或者以报销各种费用等方式，给付另一方的财物；任何其他手段包括提供国内外各种名义的旅游、考察等给付财物以外的其他利益的手段。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>甲方同意向乙方提供保乐力加产品的销售信息（包括进货、存货、价格、销售情况、消费者反映等）以及与乙方业务相关的其它市场信息。甲方同意，乙方人员有权查看甲方账目和销售情况以核实甲方提供的销售信息，甲方工作人员应当予以积极配合，否则乙方有权决定甲方不予获得当期的品牌推广服务费以及A类销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="g" style="" class="" > <content>甲方应遵守酒类销售相关法规并将对理性饮酒行动提供适当的支持，包括但不限于： </content> <type>Read</type> <subSection> <section name="" displayNumber="●" style="" class="" > <content>拒绝向疑似未成年人或孕妇出售酒精饮料；</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力避免向醉酒人员出售或推销酒精饮料；及</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力劝阻酒后驾车行为。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="h" style="" class="" > <content>甲方保证，甲方及其关联方在任何时候均遵守所有适用的反洗钱法律法规，并且未曾涉及任何未决或潜在的反洗钱法律诉讼。如果有合理的理由怀疑甲方的任何交易涉及洗钱活动，甲方应当在知悉该等理由后三（3）个工作日以内，向乙方提交一份列明可疑理由的报告。甲方应当停止与涉及可疑交易的任何客户的所有活动，直至进一步的调查使得乙方断定客户并未涉及该等活动。甲方不得向其客户或任何第三方披露提交给乙方报告有关的任何信息，也不得披露正在、已经或将要执行的调查细节或事实。 </content> <type>Read</type> </section> <section name="" displayNumber="i" style="font-weight: bold;" class="" > <content>利益冲突</content> <type>Read</type> </section> <section name="" displayNumber="i" style="" class="" > <content>甲方在此承诺：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>至本协议签署之日，在其最大的认知程度内保证没有导致利益冲突（定义如下）的情况出现，或保证已经就已存在的利益冲突向乙方批露了相关信息。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>在本协议有效期内，如有任何确切或潜在的利益冲突情况发生或可能发生，自知道或应该知道之日起三日内，以书面形式通知乙方。乙方有权决定是否继续本协议。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>利益冲突的定义：当甲方或其雇员、代理或代表在履行本协议时，因自身利益或与乙方有竞争或有业务往来的任何组织存在义务、亲属关系或其他特殊利害关系，这些关系可能使得甲方在履行本协议时影响其的判断或评价，导致对乙方产生实际的或潜在的损害。</content> <type>Read</type> </section> <section name="" displayNumber="j" style="font-weight: bold;" class="" > <content>违反本条第a、b、c、d、e、f、g、h、i款的规定构成对本协议的根本违约，乙方有权停止支付本协议下的任何费用并有权随时终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="8" style="font-weight: bold;" class="" > <content>知识产权</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方/丙方保证不论在本协议期间或终止后其不会生产或销售或恶意致使任何人或任何单位生产或销售假冒保乐力加产品或任何其名称、商标或包装、装潢与保乐力加产品相似并易引起混淆的产品。一旦发现存在侵犯或潜在侵犯乙方或其母公司或关联方的专利、商标、著作权、商业秘密以及其它知识产权权益的行为，甲方/丙方应立即通知乙方，并应与乙方通力合作制止此类侵权行为。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方/丙方不得变更、修改或移除任何保乐力加产品上的任何商标、专利声明、著作权声明及产品之上的任何其它标志，也不得在任何此类产品上附加任何其它的标志。甲方/丙方保证从本协议生效之日起，对产品的销售和使用均不会构成任何对乙方或其母公司或关联公司的专利、商标、著作权、商业秘密以及其它知识产权权益的侵犯。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方/丙方不得使用 "Pernod Ricard”，“保乐力加”或保乐力加任何产品的品牌（包括中英文） 作为其名称、简称的一部分。未经乙方明确的书面同意，亦不得用任何方式使用乙方或其母公司或关联公司的字号、任何标志、图形、文字、代号。 在任何情况下，甲方/丙方也不得使用乙方、其母公司及关联方的企业名称作为其企业名称。</content> <type>Read</type> </section> <section name="" displayNumber="9" style="font-weight: bold;" class="" > <content>违约责任</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>本协议存续期间，如果一方未能履行本协议规定的义务和保证，除本协议明确约定的救济手段以外， 违约方还应向其它协议方承担损失赔偿责任。</content> <type>Read</type> </section> <section name="" displayNumber="10" style="font-weight: bold;" class="" > <content>协议的延长和终止 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>如任何一方在协议期内严违约（如违反第7条和第8条）、有欺诈性行为、遇政府法令禁止经营活动或被申请破产、清算或解散的，协议其它方有权向该方发出书面要求终止协议，本协议即随即终止。丙方具有上述情况的，乙方有权通过一级分销商立即终止丙方二级分销商的资格，同时通知甲方与新的二级分销商签订本协议，甲/丙方对上述安排应积极配合。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>除上述情况以外，如果甲/丙方未能履行本协议规定的其它义务和保证，乙方将给予违约方十五（15）个工作日的改正期，若期满后违约方行为未能得到改善和纠正，则视为严重违约，乙方有权立即终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>协议的终止不影响无过错方向违约方主张经济上的违约或损害赔偿的权利以及协议中有关保密义务和知识产权义务的继续。</content> <type>Read</type> </section> <section name="" displayNumber="11" style="font-weight: bold;" class="" > <content>其它</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>本协议期满后，在同等条件下，乙方有优先续约权。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>在任何情况下，未经一方允许，协议其它方不得将本协议的签署、本协议的内容及在本协议履行过程中获悉的该方的机密信息（包括该方或其关联公司的任何非公开资料包括商业策略，客户信息，批发商信息，活动计划，销量，价格、生意模式及商业秘密等）泄漏给任何第三方或本方的无关人员或用于本协议以外的目的。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>除非本协议另有约定，否则任何一方在征得另二方事先书面同意之前均不得转让本协议或其相关权益。但乙方有权在书面通知甲方和丙方后，将本协议或其相关权益转让给乙方的关联方。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>若本协议规定一方不得作出某行为，则应当解释为该一方均不得以任何直接或间接的方式或通过任何第三方作出该行为。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>凡因本协议引起的或与本协议有关的任何争议，应先协商解决；协商不成的，任何一方均有权向上海市黄浦区人民法院提起诉讼。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>本协议一式三份，三方各持有一份。本协议自双方授权代表签字或盖章后生效。其它未尽事宜，由各方协商解决。</content> <type>Read</type> </section> </body> <BodySignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>甲方： {1}// 乙方：保乐力加（中国）贸易有限公司</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： // 签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // 日 期： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="BodySignature2" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>丙 方：// </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>签字盖章： // </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // </content> <type>Read</type> </section> </BodySignature> <appendix> <section name="Appendix 1" displayNumber="" style="font-size: 18px;" class="" > <content>附件一</content> <type>Read</type> </section> <section name="Brand promotion plan and target of sales" displayNumber="" style="text-align: center;font-size: 16px;" class="" > <content>品牌推广计划和销售目标</content> <type>Read</type> </section> <section name="FixCostTableHeader" displayNumber="1" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务及费用明细 &lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="FixCostTableLineHeader" displayNumber="" style="" class="" > <content>因品牌推广计划在签订协议时尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的下述服务项目进行调整，包括增加、取消或变更部分服务项目等。</content> <type>Read</type> </section> <section name="FixCostTable" displayNumber="" style="" class="" description="Do Not change the name" > <content></content> <type>Read</type> <subSection> <section name="" displayNumber="1" style="" class="" > <content> 形象推广服务//形象推广费用//金额//备注</content> <type>Read</type> </section> <section name="" displayNumber="2" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount} " > <content> {FixedCostACCode}// 1)灯箱、LED、电子屏幕、其它广告形式 2)产品陈列、店内外装饰、酒水单、台卡等附加广告宣传 3)派送宣传物料、广告礼品等 // 1)灯箱、LED等广告租赁费 2)陈列广告费 // {InputAmount} //该项费用在本协议签订后【 】个月后支付，甲方需要提供相应的形象宣传照片等支持文件。 </content> <type>Read</type> </section> <section name="" displayNumber="4" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount}" > <content> {FixedCostACCode}// 同意并协助乙方在店内举行品牌活动，如派对活动等 // N/A // {InputAmount} //该项费用在双方确定具体活动计划时确定具体支付时间和方式。</content> <type>Read</type> </section> <section name="" displayNumber="5" style="" class="" > <content> &lt;br/&gt; // &lt;br/&gt; // 总计： // {FXTotalAmount} //&lt;br/&gt;</content> <type>Read</type> </section> <section name="FixCostTable_InputText" displayNumber="6" style="" class="colspan4" > <content> 备注：// {InputText}</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="2" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;销量目标和销售折扣&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="SalesDiscount" displayNumber="" style="" class="AppendixLineHeader" > <content>为进一步推广保乐力加产品，乙方对其产品的经销企业实行销售折扣的政策。在符合约定前提条件的情况下，甲方可享受一定的销售折扣。具体要求如下：</content> <type>Read</type> <subSection> <section name="Sales_Discount_of_A_Class" displayNumber="2.1" style="font-weight: bold;" class="displayNumber" > <content>A类销售折扣: </content> <type>Read</type> </section> <section name="BRSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品名称和规格// 单瓶月销量目标//单瓶销售折扣//合同总销量//合同总销售折扣</content> <type>Read</type> <subSection> <section name="BRSFTableA" displayNumber="" style="" class="2colspan4" > <content>季度A类销售折扣计算方式 //季度A类销售折扣=单瓶销售折扣X确认为甲方从丙方进货的且当季包装被规范回收的保乐力加产品数量单位：瓶）于下一季度内结算。 </content> <type>Read</type> </section> <section name="BRSFTableB" displayNumber="" style="" class="2colspan4 2InputText" description="Do Not change the name" > <content>备注//享受A类销售折扣的前提 1) 季度销量（或进货额）不低于XXX（可选项）;且2) 符合其他约定条件 </content> <type>Read</type> </section> </subSection> </section> <section name="Non_standard_Convert" displayNumber="" style="" class="" > <content>非标准规格折算：[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;] </content> <type>Read</type> </section> <section name="PSFTableHeader" displayNumber="2.2" style="font-weight: bold;" class="displayNumber" > <content>B类销售折扣: </content> <type>Read</type> </section> <section name="PSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标// 合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="BySubBrand displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByGrade displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌档次完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByCategory displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按产品类别完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByTotal displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按总销量完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="PSFTableA" displayNumber="" style="" class="1rowspan1 2colspan4 2InputText BySubBrand" description="Do Not change the name format and the name should be unique" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableD" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByGrade" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableG" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByCategory" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableI" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByTotal" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> <section name="Event_Support" displayNumber="2.3" style="font-weight: bold;" class="displayNumber" > <content>活动支持费用 </content> <type>Read</type> </section> <section name="Event_Support 1" displayNumber="" style="" class="" > <content>甲方完成下述约定的销量指标是进一步享受活动支持费用的前提条件。 </content> <type>Read</type> </section> <section name="VECTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标 //合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="VECTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="VECTableA" displayNumber="" style="" class="2colspan4 2InputText BySubBrand" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableB" displayNumber="" style="" class="2colspan4 2InputText ByGrade" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableC" displayNumber="" style="" class="2colspan4 2InputText ByCategory" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableD" displayNumber="" style="" class="2colspan4 2InputText ByTotal" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> </subSection> </section> <section name="Payment Conditions" displayNumber="3" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务费及销售折扣的支付条件&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="1)" style="" class="" > <content>甲方依据约定为乙方开展的各项品牌推广活动提供场地、便利和其他支持是甲方获得品牌推广服务费的前提条件。 </content> <type>Read</type> </section> <section name="Payment_Conditions_BC_Rate" displayNumber="2)" style="" class="" > <content>马爹利系列产品包装回收率不低于97%，非马爹利系列产品包装回收率不低于 {BCRate} ，系甲方享受各类销售折扣的前提条件之一。包装回收率超过100%时，按100%封顶计。 </content> <type>Read</type> </section> <section name="Payment_ConditionsC" displayNumber="3)" style="" class="" description="Do Not change the {1}-{6}" > <content>{0}年{1}月{2}日至{3}年{4}月{5}日期间，假设甲方100%完成销量目标，且包装回收率为100%，则预计A类销售折扣总计人民币{6}元。本条系预估，对乙方不具有约束力。 </content> <type>Selectable</type> </section> <section name="Selectable1" displayNumber="4)" style="" class="" description="Please Input Name Field" > <content>如果本协议期内，甲方未能完成约定的年度B类销量指标，则本协议自动延期直至B类销量指标完成为止。协议延续期间本协议各方的权利义务保持不变，品牌推广服务费除外(无自动延续)。 </content> <type>Selectable</type> </section> <section name="" displayNumber="5)" style="" class="" > <content>甲方同意上述各项品牌推广服务费可以现金或产品实物的形式支付。 </content> <type>Read</type> </section> <section name="" displayNumber="6)" style="" class="" > <content>甲方始终遵守以下第4条的各项承诺。 </content> <type>Read</type> </section> </subSection> </section> <section name="Party A undertakes" displayNumber="4" style="font-weight: bold;" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;甲方承诺&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="a)" style="" class="" > <content>将在法律允许的范围内在甲方场地尽其最大商业努力推销乙方产品。 </content> <type>Read</type> </section> <section name="" displayNumber="b)" style="" class="" > <content>甲方场地内用于调制杯饮类的副酒将尽量使用乙方品类中相应品种的产品。 </content> <type>Read</type> </section> <section name="" displayNumber="c)" style="" class="" > <content>在甲方场地重点展示乙方产品及其品牌。 </content> <type>Read</type> </section> <section name="" displayNumber="d)" style="" class="" > <content>应乙方不时之请求，为乙方的品牌在场内举行促销活动提供场地和服务。 </content> <type>Read</type> </section> <section name="PartyAUndertakes_e" displayNumber="e)" style="" class="" > <content>{InputText} </content> <type>Selectable</type> </section> </subSection> </section> </appendix> <AppendixSignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>甲方： {1} </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： </content> <type>Read</type> </section> </AppendixSignature> </source>';
       String XMLTestString4='<source> <header> <section name="Sales and Branding Promotion Agreement" displayNumber="" style="text-align: center;font-size: 20px;" class="" > <content>销售和品牌推广协议</content> <type>Read</type> </section> <section name="drink on the premises" displayNumber="" style="text-align: center;font-size: 18px;" class="" > <content>堂饮</content> <type>Read</type> </section> <section name="Party A" displayNumber="" style="" class="" > <content>甲方：{1}(店家名称) </content> <type>Read</type> </section> <section name="Party B" displayNumber="" style="" class="" > <content>乙方：保乐力加（中国）贸易有限公司 </content> <type>Read</type> </section> <section name="Party C" displayNumber="" style="" class="" > <content>{1} </content> <type>Read</type> </section> </header> <body> <section name="Header with original contract" displayNumber="" style="font-weight: bold;" class="" > <content>鉴于：</content> <type>Read</type> </section> <section name="WhereasA" displayNumber="A" style="" class="" > <title></title> <content>甲方为堂饮服务类企业；乙方为保乐力加产品在中国的独家总经销商；丙方为保乐力加产品在甲方所在城市的批发商及甲方的供货商。</content> <type>Read</type> </section> <section name="WhereasB" displayNumber="B" style="" class="" > <content>乙方为在甲方所在地方推广保乐力加产品品牌、提高产品的知名度并打击假冒伪劣产品，愿意与甲方合作，由甲方配合其市场营销活动提供有关品牌推广服务。丙方作为甲方的直接供货商，愿意为甲方和乙方在品牌发展方面的合作提供物流等方面的协助。</content> <type>Read</type> </section> <section name="WhereasC" displayNumber="C" style="" class="" > <content>同时，为促进保乐力加产品在甲方渠道的销售，协议三方将在甲方渠道开展以打折让利等形式进行促销。</content> <type>Read</type> </section> <section name="Agreement" displayNumber="" style="" class="" > <content>现经友好协商，三方达成协议如下：</content> <type>Read</type> </section> <section name="TermsofthisAgreement" displayNumber="1" style="font-weight: bold;" class="" > <content>协议期限</content> <type>Read</type> </section> <section name="Terms of this Agreement" displayNumber="" style="" class="" > <content>本协议期限自{1}年{2}月{3}日 至{4}年{5}月{6}日。</content> <type>Read</type> </section> <section name="Products" displayNumber="2" style="font-weight: bold;" class="" > <content>产品</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="" style="" class="" > <content>三方同意在甲方店内销售保乐力加产品，产品具体名称、规格等见产品清单 （下称“保乐力加产品”或“产品”）。</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="3" style="font-weight: bold;" class="" > <content>订货和交付</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="a" style="" class="" > <content>甲方应通过订单的形式向丙方订购产品，该订单中应明确订购产品的数量和要求的交货日期。产品的所有订单均须获得丙方的批准。丙方可对所订购产品的数量根据现有库存进行调整，同时不应就未经其接受的购买订单向该客户承担责任。 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="b" style="" class="" > <content>丙方应在订单约定的时间期限内，将货物交付到指定地点和接收人。订单发出后，未经丙方同意，不得对丙方已经收到的任何订单做出修改。</content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="c" style="" class="" > <content>甲方订购的所有产品均根据标准商业惯例进行包装以便运输和储存。订购产品的灭失和损害风险在指定的交货地点向甲方交付该等订购产品后转移给甲方。如有承运人的，则订购产品的灭失和损害风险自交由第一承运人起转移给甲方。甲方应在收到货物后对货物进行检验。如果货物有破损或包装货物发生短缺，则甲方应立即通知丙方，且在运输公司代表在场的情况下，甲方可拒收破损的货物。破损或短缺的问题应通过召回或调换的方式予以解决。</content> <type>Read</type> </section> <section name="Conditions for Payment" displayNumber="4" style="font-weight: bold;" class="" > <content>货款的付款条件</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="" style="" class="" > <content>本协议项下有关订购产品货款的支付，甲方应以人民币通过银行转账或约定的其他付款方式支付给丙方。</content> <type>Read</type> </section> <section name="Promotion, sales target and sales discount" displayNumber="5" style="font-weight: bold;" class="" > <content>品牌推广服务、销量目标和销售折扣</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="a" style="" class="" > <content>甲方的承诺和责任。 乙方致力于在甲方渠道提高保乐力加产品及品牌的知名度和形象，甲方同意在其店内向其提供如下品牌推广服务，并尽其最大努力完成约定的销量目标：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>在店内外提供如下品牌的形象宣传服务(具体计划和安排，由双方另行协商确定）</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 陈列放有保乐力加产品广告的灯箱；</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 在店内电子LED上（如有）播放保乐力加产品信息或广告；</content> <type>Read</type> </section> <section name=" " displayNumber="" style="" class="" > <content>• 店内装饰装修上采用与保乐力加产品品牌相关的元素和装饰；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内显著位置放置保乐力加产品陈列柜或在店内陈列柜及显著位置陈列保乐力加产品；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内派送保乐力加产品的宣传品与物料；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 保乐力加产品信息出现在酒水单前列；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 在店内桌上放置含有保乐力加产品信息的台卡等。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>授予保乐力加产品在店内的促销权，并配合乙方的促销活动提供如下服务：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 为乙方的促销服务提供场地；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 同意乙方向店内派驻促销代表以宣传、推广保乐力加产品。该促销代表的数量和来源由甲、乙双方协商确定；乙方促销员应遵守店内的规章制度；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 同意配合乙方的市场营销计划在店内开展保乐力加产品的促销活动（具体促销活动计划和安排，由双方另行协商确定）。</content> <type>Read</type> </section> <section name="" displayNumber="(3)" style="" class="" > <content>同意并配合乙方在各类节庆及其他时间开展各种品牌活动，包括各种派对、演出、晚宴或品酒会及品牌展示和促销活动（由乙方根据其具体的市场营销计划最终确定）等。</content> <type>Read</type> </section> <section name="" displayNumber="(4)" style="" class="" > <content>尽最大努力完成销量目标。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="b" style="" class="" > <content>乙方的权利和义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>因品牌推广计划尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的上述服务项目进行调整，包括增加、取消或变更部分服务项目等，并和甲方协商确定销量目标。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>乙方同意：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 甲方可获得一定服务费用（具体金额和付款条件根据最终确定后的形象宣传活动细节、促销活动方案、甲方品牌活动计划另行约定）和在符合约定条件的前提下享受相应的销售折扣，甲乙双方必须将折扣如实入账；</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 及时向甲方提供和品牌形象宣传有关的宣传品、酒具、物料等材料。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>• 根据甲方的需要向其员工提供一定酒类培训，具体培训的次数、地点和内容由双方协商确定。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="c" style="" class="" > <content>丙方的义务。</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>本条所述品牌推广服务费和销售折扣的全部或部分由丙方支付给甲方。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="d" style="" class="" > <content>服务费用及销售折扣的支付应以甲方在协议期限内遵守本协议之约定为前提。在付款方向甲方支付任何费用之前，甲方应开具符合中国法律、法规规定及中国税务部门要求的、由中国税务部门监制的记载相应款项的发票。各方对上述各项收付款应在其财务帐上真实明确记载。</content> <type>Read</type> </section> <section name="" displayNumber="6" style="font-weight: bold;" class="" > <content> 打假措施 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content> 为保护乙方的知识产权，防止制假者利用保乐力加产品的空瓶、瓶盖或瓶套等产品包装生产假冒伪劣产品,根据乙方要求，甲方应尽力将被要求回收的产品包装悉数退还乙方，由乙方统一回收和销毁。各产品具体的包装回收要求由乙方另行以函件形式通知甲方。为行文简便起见，非经特别说明下文所称“包装“指甲方从丙方进货的保乐力加产品的或乙方要求回收的保乐力加产品的包装。 </content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content> 规范的产品包装回收由甲方自己回收并快递至乙方指定的复核中心，并经乙方确认符合要求，具体回收频率和时间将根据本协议履行过程中门店的实际的销量确定。如甲方在回收过程中偷换、伪造乙方的瓶塞/瓶盖以获取折扣奖励，乙方有权取消或收回该相关折扣奖励，并向甲方主张损害赔偿责任。 </content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>包装回收率=包装回收的实际数/甲方从丙方的实际进货量。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>乙方包装回收制度的目的是打击假冒伪劣产品，而非鼓励甲方通过从他处回收包装牟利。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>虽然乙方不要求回收包装的所有组件，但甲方承诺不会将保乐力加回收产品包装后剩余的包装组件如空瓶、瓶塞、瓶口防回灌装置或外盒等其它产品包装直接或间接赠送、出售给制假者或者随意丢弃，或自行使用保乐力加产品包装的全部或部分制作伪劣的、假冒的保乐力加产品，否则乙方有权行使本协议第7条第j款下约定的权利。</content> <type>Read</type> </section> <section name="" displayNumber="7" style="font-weight: bold;" class="" > <content>保证</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方承诺其为依法设立并有效存续的法人实体，在签订本协议时并确保在本协议有效期内拥有在其合法登记注册的经营场所内从事酒类销售及相关餐饮娱乐服务的合法有效的营业执照等所有必需的政府批准和许可。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方承诺只在乙方认可的销售渠道中购买保乐力加产品，拒绝销售任何伪劣产品、假货和走私货并且按乙方要求回收产品包装给乙方或其指定人员处理。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方同意，其所采购的保乐力加产品仅限于在自身经营的场所内销售，不得转售任何第三方，除非经乙方和丙方的事先书面同意</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>甲、丙两方须对其与乙方购销产品数量和价格保密，若因甲/丙方泄露相关信息而导致给乙方造成经济损失的，甲/丙方方须赔偿乙方由此产生的全部经济损失。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>甲方声明并同意，未曾且将不会，在为乙方、丙方开展业务的过程中， </content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>违反任何适用的反贿赂政策和反贿赂法；</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>提供、承诺给与、给予、同意接受或接受任何非法贿赂、回扣、回报、影响付款、返利或其他非法支付（包括疏通费）。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>应乙方的要求，甲方随时应将其向乙方提供服务的记录和会计账册提供，以供审查和/或审计使用。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>如果甲方或其关联方、雇员、集团公司、分包商、代理或代表违反陈述，且/或因涉及或从事任何可能构成反贿赂法下犯罪的行为被指控或被调查，乙方应有权单方面立即停止付款或终止本协议，或按照本协议的条款采取适当行为。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>为本条款之目的，“贿赂”是指某人向另一人提供、承诺提供或者给予某项利益，旨在使其（或另外之人）不适当地履行职责，或者将其用作对上述人员不当履行职责之酬劳。索取或者同意收受上述利益也属于贿赂行为。 通过第三方提供或者收受贿赂并不影响行为性质，仍应认定为贿赂行为。贿赂所涉及的利益可以采用财物或其他手段。财物是指现金和实物，包括现金和实物，任何包括假借促销费、宣传、赞助费、科研费、劳务费、咨询费、佣金等名义，或者以报销各种费用等方式，给付另一方的财物；任何其他手段包括提供国内外各种名义的旅游、考察等给付财物以外的其他利益的手段。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>甲方同意向乙方提供保乐力加产品的销售信息（包括进货、存货、价格、销售情况、消费者反映等）以及与乙方业务相关的其它市场信息。甲方同意，乙方人员有权查看甲方账目和销售情况以核实甲方提供的销售信息，甲方工作人员应当予以积极配合，否则乙方有权决定甲方不予获得当期的品牌推广服务费以及A类销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="g" style="" class="" > <content>甲方应遵守酒类销售相关法规并将对理性饮酒行动提供适当的支持，包括但不限于： </content> <type>Read</type> <subSection> <section name="" displayNumber="●" style="" class="" > <content>拒绝向疑似未成年人或孕妇出售酒精饮料；</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力避免向醉酒人员出售或推销酒精饮料；及</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力劝阻酒后驾车行为。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="h" style="" class="" > <content>甲方保证，甲方及其关联方在任何时候均遵守所有适用的反洗钱法律法规，并且未曾涉及任何未决或潜在的反洗钱法律诉讼。如果有合理的理由怀疑甲方的任何交易涉及洗钱活动，甲方应当在知悉该等理由后三（3）个工作日以内，向乙方提交一份列明可疑理由的报告。甲方应当停止与涉及可疑交易的任何客户的所有活动，直至进一步的调查使得乙方断定客户并未涉及该等活动。甲方不得向其客户或任何第三方披露提交给乙方报告有关的任何信息，也不得披露正在、已经或将要执行的调查细节或事实。 </content> <type>Read</type> </section> <section name="" displayNumber="i" style="font-weight: bold;" class="" > <content>利益冲突</content> <type>Read</type> </section> <section name="" displayNumber="i" style="" class="" > <content>甲方在此承诺：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>至本协议签署之日，在其最大的认知程度内保证没有导致利益冲突（定义如下）的情况出现，或保证已经就已存在的利益冲突向乙方批露了相关信息。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>在本协议有效期内，如有任何确切或潜在的利益冲突情况发生或可能发生，自知道或应该知道之日起三日内，以书面形式通知乙方。乙方有权决定是否继续本协议。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>利益冲突的定义：当甲方或其雇员、代理或代表在履行本协议时，因自身利益或与乙方有竞争或有业务往来的任何组织存在义务、亲属关系或其他特殊利害关系，这些关系可能使得甲方在履行本协议时影响其的判断或评价，导致对乙方产生实际的或潜在的损害。</content> <type>Read</type> </section> <section name="" displayNumber="j" style="font-weight: bold;" class="" > <content>违反本条第a、b、c、d、e、f、g、h、i款的规定构成对本协议的根本违约，乙方有权停止支付本协议下的任何费用并有权随时终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="8" style="font-weight: bold;" class="" > <content>知识产权</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方/丙方保证不论在本协议期间或终止后其不会生产或销售或恶意致使任何人或任何单位生产或销售假冒保乐力加产品或任何其名称、商标或包装、装潢与保乐力加产品相似并易引起混淆的产品。一旦发现存在侵犯或潜在侵犯乙方或其母公司或关联方的专利、商标、著作权、商业秘密以及其它知识产权权益的行为，甲方/丙方应立即通知乙方，并应与乙方通力合作制止此类侵权行为。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方/丙方不得变更、修改或移除任何保乐力加产品上的任何商标、专利声明、著作权声明及产品之上的任何其它标志，也不得在任何此类产品上附加任何其它的标志。甲方/丙方保证从本协议生效之日起，对产品的销售和使用均不会构成任何对乙方或其母公司或关联公司的专利、商标、著作权、商业秘密以及其它知识产权权益的侵犯。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方/丙方不得使用 "Pernod Ricard”，“保乐力加”或保乐力加任何产品的品牌（包括中英文） 作为其名称、简称的一部分。未经乙方明确的书面同意，亦不得用任何方式使用乙方或其母公司或关联公司的字号、任何标志、图形、文字、代号。 在任何情况下，甲方/丙方也不得使用乙方、其母公司及关联方的企业名称作为其企业名称。</content> <type>Read</type> </section> <section name="" displayNumber="9" style="font-weight: bold;" class="" > <content>违约责任</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>本协议存续期间，如果一方未能履行本协议规定的义务和保证，除本协议明确约定的救济手段以外， 违约方还应向其它协议方承担损失赔偿责任。</content> <type>Read</type> </section> <section name="" displayNumber="10" style="font-weight: bold;" class="" > <content>协议的延长和终止 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>如任何一方在协议期内严违约（如违反第7条和第8条）、有欺诈性行为、遇政府法令禁止经营活动或被申请破产、清算或解散的，协议其它方有权向该方发出书面要求终止协议，本协议即随即终止。丙方具有上述情况的，乙方有权通过一级分销商立即终止丙方二级分销商的资格，同时通知甲方与新的二级分销商签订本协议，甲/丙方对上述安排应积极配合。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>除上述情况以外，如果甲/丙方未能履行本协议规定的其它义务和保证，乙方将给予违约方十五（15）个工作日的改正期，若期满后违约方行为未能得到改善和纠正，则视为严重违约，乙方有权立即终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>协议的终止不影响无过错方向违约方主张经济上的违约或损害赔偿的权利以及协议中有关保密义务和知识产权义务的继续。</content> <type>Read</type> </section> <section name="" displayNumber="11" style="font-weight: bold;" class="" > <content>其它</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>本协议期满后，在同等条件下，乙方有优先续约权。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>在任何情况下，未经一方允许，协议其它方不得将本协议的签署、本协议的内容及在本协议履行过程中获悉的该方的机密信息（包括该方或其关联公司的任何非公开资料包括商业策略，客户信息，批发商信息，活动计划，销量，价格、生意模式及商业秘密等）泄漏给任何第三方或本方的无关人员或用于本协议以外的目的。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>除非本协议另有约定，否则任何一方在征得另二方事先书面同意之前均不得转让本协议或其相关权益。但乙方有权在书面通知甲方和丙方后，将本协议或其相关权益转让给乙方的关联方。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>若本协议规定一方不得作出某行为，则应当解释为该一方均不得以任何直接或间接的方式或通过任何第三方作出该行为。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>凡因本协议引起的或与本协议有关的任何争议，应先协商解决；协商不成的，任何一方均有权向上海市黄浦区人民法院提起诉讼。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>本协议一式三份，三方各持有一份。本协议自双方授权代表签字或盖章后生效。其它未尽事宜，由各方协商解决。</content> <type>Read</type> </section> </body> <BodySignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>甲方： {1}// 乙方：保乐力加（中国）贸易有限公司</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： // 签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // 日 期： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="BodySignature2" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>丙 方：// </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>签字盖章： // </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // </content> <type>Read</type> </section> </BodySignature> <appendix> <section name="Appendix 1" displayNumber="" style="font-size: 18px;" class="" > <content>附件一</content> <type>Read</type> </section> <section name="Brand promotion plan and target of sales" displayNumber="" style="text-align: center;font-size: 16px;" class="" > <content>品牌推广计划和销售目标</content> <type>Read</type> </section> <section name="FixCostTableHeader" displayNumber="1" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务及费用明细 &lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="FixCostTableLineHeader" displayNumber="" style="" class="" > <content>因品牌推广计划在签订协议时尚未完全确定，乙方有权在具体履行协议时根据其最终确定的品牌推广计划对甲方提供的下述服务项目进行调整，包括增加、取消或变更部分服务项目等。</content> <type>Read</type> </section> <section name="FixCostTable" displayNumber="" style="" class="" description="Do Not change the name" > <content></content> <type>Read</type> <subSection> <section name="" displayNumber="1" style="" class="" > <content> 形象推广服务//形象推广费用//金额//备注</content> <type>Read</type> </section> <section name="" displayNumber="2" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount} " > <content> {FixedCostACCode}// 1)灯箱、LED、电子屏幕、其它广告形式 2)产品陈列、店内外装饰、酒水单、台卡等附加广告宣传 3)派送宣传物料、广告礼品等 // 1)灯箱、LED等广告租赁费 2)陈列广告费 // {InputAmount} //该项费用在本协议签订后【 】个月后支付，甲方需要提供相应的形象宣传照片等支持文件。 </content> <type>Read</type> </section> <section name="" displayNumber="4" style="" class="" description="Do Not change the {FixedCostACCode} {InputAmount}" > <content> {FixedCostACCode}// 同意并协助乙方在店内举行品牌活动，如派对活动等 // N/A // {InputAmount} //该项费用在双方确定具体活动计划时确定具体支付时间和方式。</content> <type>Read</type> </section> <section name="" displayNumber="5" style="" class="" > <content> &lt;br/&gt; // &lt;br/&gt; // 总计： // {FXTotalAmount} //&lt;br/&gt;</content> <type>Read</type> </section> <section name="FixCostTable_InputText" displayNumber="6" style="" class="colspan4" > <content> 备注：// {InputText}</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="2" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;销量目标和销售折扣&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="SalesDiscount" displayNumber="" style="" class="AppendixLineHeader" > <content>为进一步推广保乐力加产品，乙方对其产品的经销企业实行销售折扣的政策。在符合约定前提条件的情况下，甲方可享受一定的销售折扣。具体要求如下：</content> <type>Read</type> <subSection> <section name="Sales_Discount_of_A_Class" displayNumber="2.1" style="font-weight: bold;" class="displayNumber" > <content>A类销售折扣: </content> <type>Read</type> </section> <section name="BRSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品名称和规格// 单瓶月销量目标//单瓶销售折扣//合同总销量//合同总销售折扣</content> <type>Read</type> <subSection> <section name="BRSFTableA" displayNumber="" style="" class="2colspan4" > <content>季度A类销售折扣计算方式 //季度A类销售折扣=单瓶销售折扣X确认为甲方从丙方进货的且当季包装被规范回收的保乐力加产品数量单位：瓶）于下一季度内结算。 </content> <type>Read</type> </section> <section name="BRSFTableB" displayNumber="" style="" class="2colspan4 2InputText" description="Do Not change the name" > <content>备注//享受A类销售折扣的前提 1) 季度销量（或进货额）不低于XXX（可选项）;且2) 符合其他约定条件 </content> <type>Read</type> </section> </subSection> </section> <section name="Non_standard_Convert" displayNumber="" style="" class="" > <content>非标准规格折算：[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;] </content> <type>Read</type> </section> <section name="PSFTableHeader" displayNumber="2.2" style="font-weight: bold;" class="displayNumber" > <content>B类销售折扣: </content> <type>Read</type> </section> <section name="PSFTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标// 合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="BySubBrand displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByGrade displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按品牌档次完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByCategory displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按产品类别完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_HeaderTerm" displayNumber="2.2." style="" class="ByTotal displayNumber" description="Do Not change the name and displayNumber format"> <content>甲方按总销量完成下述约定的销量指标是进一步享受B类销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="PSFTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="PSFTableA" displayNumber="" style="" class="1rowspan1 2colspan4 2InputText BySubBrand" description="Do Not change the name format and the name should be unique" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableD" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByGrade" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableG" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByCategory" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> <section name="PSFTableI" displayNumber="" style="" class="1rowspan1 2colspan2 2InputText ByTotal" description="Do Not change the name format" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> <section name="Event_Support" displayNumber="2.3" style="font-weight: bold;" class="displayNumber" > <content>活动支持费用 </content> <type>Read</type> </section> <section name="Event_Support 1" displayNumber="" style="" class="" > <content>甲方完成下述约定的销量指标是进一步享受活动支持费用的前提条件。 </content> <type>Read</type> </section> <section name="VECTable" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品列表//月销量指标//月达标销售折扣//合同销量指标 //合同达标销售折扣 </content> <type>Read</type> <subSection> <section name="VECTableA_In_total" displayNumber="" style="" class="" > <content>总计： </content> <type>Read</type> </section> <section name="VECTableA" displayNumber="" style="" class="2colspan4 2InputText BySubBrand" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableB" displayNumber="" style="" class="2colspan4 2InputText ByGrade" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableC" displayNumber="" style="" class="2colspan4 2InputText ByCategory" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> <section name="VECTableD" displayNumber="" style="" class="2colspan4 2InputText ByTotal" description="Do Not change the name" > <content>备注// </content> <type>Read</type> </section> </subSection> </section> </subSection> </section> <section name="Payment Conditions" displayNumber="3" style="" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;品牌推广服务费及销售折扣的支付条件&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="1)" style="" class="" > <content>甲方依据约定为乙方开展的各项品牌推广活动提供场地、便利和其他支持是甲方获得品牌推广服务费的前提条件。 </content> <type>Read</type> </section> <section name="Payment_Conditions_BC_Rate" displayNumber="2)" style="" class="" > <content>马爹利系列产品包装回收率不低于97%，非马爹利系列产品包装回收率不低于 {BCRate} ，系甲方享受各类销售折扣的前提条件之一。包装回收率超过100%时，按100%封顶计。 </content> <type>Read</type> </section> <section name="Payment_ConditionsC" displayNumber="3)" style="" class="" description="Do Not change the {1}-{6}" > <content>{0}年{1}月{2}日至{3}年{4}月{5}日期间，假设甲方100%完成销量目标，且包装回收率为100%，则预计A类销售折扣总计人民币{6}元。本条系预估，对乙方不具有约束力。 </content> <type>Selectable</type> </section> <section name="Selectable1" displayNumber="4)" style="" class="" description="Please Input Name Field" > <content>如果本协议期内，甲方未能完成约定的年度B类销量指标，则本协议自动延期直至B类销量指标完成为止。协议延续期间本协议各方的权利义务保持不变，品牌推广服务费除外(无自动延续)。 </content> <type>Selectable</type> </section> <section name="" displayNumber="5)" style="" class="" > <content>甲方同意上述各项品牌推广服务费可以现金或产品实物的形式支付。 </content> <type>Read</type> </section> <section name="" displayNumber="6)" style="" class="" > <content>甲方始终遵守以下第4条的各项承诺。 </content> <type>Read</type> </section> </subSection> </section> <section name="Party A undertakes" displayNumber="4" style="font-weight: bold;" class="AppendixLineHeader" > <content>&lt;b&gt;&lt;u&gt;甲方承诺&lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> <subSection> <section name="" displayNumber="a)" style="" class="" > <content>将在法律允许的范围内在甲方场地尽其最大商业努力推销乙方产品。 </content> <type>Read</type> </section> <section name="" displayNumber="b)" style="" class="" > <content>甲方场地内用于调制杯饮类的副酒将尽量使用乙方品类中相应品种的产品。 </content> <type>Read</type> </section> <section name="" displayNumber="c)" style="" class="" > <content>在甲方场地重点展示乙方产品及其品牌。 </content> <type>Read</type> </section> <section name="" displayNumber="d)" style="" class="" > <content>应乙方不时之请求，为乙方的品牌在场内举行促销活动提供场地和服务。 </content> <type>Read</type> </section> <section name="PartyAUndertakes_e" displayNumber="e)" style="" class="" > <content>{InputText} </content> <type>Selectable</type> </section> </subSection> </section> </appendix> <AppendixSignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>甲方： {1} </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： </content> <type>Read</type> </section> </AppendixSignature> </source>';     
            
       String XMLTestString5='<source> <header> <section name="Sales and Branding Promotion Agreement" displayNumber="" style="text-align: center;font-size: 20px;" class="" > <content>销售和品牌推广协议</content> <type>Read</type> </section> <section name="drink on the premises" displayNumber="" style="text-align: center;font-size: 18px;" class="" > <content>堂饮</content> <type>Read</type> </section> <section name="Party A" displayNumber="" style="" class="" > <content>甲方：{InputWholesaler}(店家名称) </content> <type>Read</type> </section> <section name="Party B" displayNumber="" style="" class="" > <content>乙方：保乐力加（中国）贸易有限公司 </content> <type>Read</type> </section> </header> <body> <section name="Header with original contract" displayNumber="" style="font-weight: bold;" class="" > <content>鉴于：</content> <type>Read</type> </section> <section name="WhereasA" displayNumber="A" style="" class="" > <title></title> <content>甲方为保乐力加产品在甲方所在市场的批发商，在传统堂饮渠道拥有丰富客户资源；乙方为保乐力加产品在中国的独家总经销商；</content> <type>Read</type> </section> <section name="WhereasB" displayNumber="B" style="" class="" > <content>乙方为在甲方所在渠道推广保乐力加产品品牌、提高产品的知名度并打击假冒伪劣产品，愿意与甲方合作。</content> <type>Read</type> </section> <section name="Agreement" displayNumber="" style="" class="" > <content>现经友好协商，三方达成协议如下：</content> <type>Read</type> </section> <section name="TermsofthisAgreement" displayNumber="1" style="font-weight: bold;" class="" > <content>协议期限</content> <type>Read</type> </section> <section name="Terms of this Agreement" displayNumber="" style="" class="" > <content>本协议期限自{1}年{2}月{3}日 至{4}年{5}月{6}日。</content> <type>Read</type> </section> <section name="ProductsPart" displayNumber="2" style="font-weight: bold;" class="" > <content>拓展堂饮门店及产品</content> <type>Read</type> <subSection> <section name="" displayNumber="a" style="" class="" > <content>双方同意在以下堂饮门店（以下简称“门店“）内推广并销售保乐力加产品：</content> <type>Read</type> </section> <section name="ProductsPart1" displayNumber="" style="" class="" > <content>{CoveredOutletTable}</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方在上述堂饮渠道销售之保乐力加产品的具体名称、规格等见产品清单 （下称“保乐力加产品” 或“产品”）。</content> <type>Read</type> </section> </subSection> </section> <section name="All parties sell Products" displayNumber="3" style="font-weight: bold;" class="" > <content>订货、交付与货款支付 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="a" style="" class="" > <content>甲方应当通过乙方认可的销售渠道采购保乐力加产品。 </content> <type>Read</type> </section> <section name="All parties sell Products" displayNumber="b" style="" class="" > <content>甲方向门店供应产品，具体订货、交付和货款支付细节由甲方与门店另行约定，与乙方无涉。</content> <type>Read</type> </section> <section name="Promotion, sales target and sales discount" displayNumber="4" style="font-weight: bold;" class="" > <content>销量目标和销售折扣</content> <type>Read</type> </section> <section name="The payment relating " displayNumber="a" style="" class="" > <content>甲方的承诺和责任。 乙方致力于在甲方渠道提高保乐力加产品及品牌的知名度和形象，甲方同意在其店内向其提供如下品牌推广服务，并尽其最大努力完成约定的销量目标：</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>乙方的义务：</content> <type>Read</type> <subSection> <section name="" displayNumber="" style="" class="" > <content>作为甲方全面履约的对价，乙方同意：</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>甲方能够享受一定的销售折扣（具体数额和支付条件由甲、乙双方另行约定）；</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="c" style="" class="" > <content>销售折扣的支付应以甲方在协议期限内遵守本协议之各项约定为前提。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>d 各方对各项收付款应在其财务帐上真实明确记载。</content> <type>Read</type> </section> <section name="" displayNumber="5" style="font-weight: bold;" class="" > <content> 打假措施 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content> 为保护乙方的知识产权，防止制假者利用保乐力加产品的空瓶、瓶盖或瓶套等产品包装生产假冒伪劣产品,根据乙方要求，甲方应尽力将被要求回收的产品包装悉数退还乙方，由乙方统一回收和销毁。各产品具体的包装回收要求由乙方另行以函件形式通知甲方。为行文简便起见，非经特别说明下文所称“包装“指甲方从丙方进货的保乐力加产品的或乙方要求回收的保乐力加产品的包装。 </content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content> 规范的产品包装回收由乙方委托的人员或委托的第三方物流公司进行，并经乙方确认符合要求，具体回收频率和时间将根据本协议履行过程中甲方的实际的销量确定。 </content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>包装回收率=包装回收的实际数/甲方从丙方的实际进货量。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>乙方包装回收制度的目的是打击假冒伪劣产品，而非鼓励甲方通过从他处回收包装牟利。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>虽然乙方不要求回收包装的所有组件，但甲方承诺不会将保乐力加回收产品包装后剩余的包装组件如空瓶、瓶塞、瓶口防回灌装置或外盒等其它产品包装直接或间接赠送、出售给制假者或者随意丢弃，或自行使用保乐力加产品包装的全部或部分制作伪劣的、假冒的保乐力加产品，否则乙方有权行使本协议第7条第j款下约定的权利。</content> <type>Read</type> </section> <section name="" displayNumber="6" style="font-weight: bold;" class="" > <content>保证</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方承诺其为依法设立并有效存续的法人实体，在签订本协议时并确保在本协议有效期内拥有在其合法登记注册的经营场所内从事酒类销售及相关餐饮娱乐服务的合法有效的营业执照等所有必需的政府批准和许可。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方承诺只在乙方认可的销售渠道中购买保乐力加产品，拒绝销售任何伪劣产品、假货和走私货并且按乙方要求回收产品包装给乙方或其指定人员处理。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方同意，其所采购的保乐力加产品仅限于在自身经营的场所内销售，不得转售任何第三方，除非经乙方和丙方的事先书面同意</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>甲、丙两方须对其与乙方购销产品数量和价格保密，若因甲/丙方泄露相关信息而导致给乙方造成经济损失的，甲/丙方方须赔偿乙方由此产生的全部经济损失。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>甲方声明并同意，未曾且将不会，在为乙方、丙方开展业务的过程中， </content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>违反任何适用的反贿赂政策和反贿赂法；</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>提供、承诺给与、给予、同意接受或接受任何非法贿赂、回扣、回报、影响付款、返利或其他非法支付（包括疏通费）。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>应乙方的要求，甲方随时应将其向乙方提供服务的记录和会计账册提供，以供审查和/或审计使用。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>如果甲方或其关联方、雇员、集团公司、分包商、代理或代表违反陈述，且/或因涉及或从事任何可能构成反贿赂法下犯罪的行为被指控或被调查，乙方应有权单方面立即停止付款或终止本协议，或按照本协议的条款采取适当行为。</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>为本条款之目的，“贿赂”是指某人向另一人提供、承诺提供或者给予某项利益，旨在使其（或另外之人）不适当地履行职责，或者将其用作对上述人员不当履行职责之酬劳。索取或者同意收受上述利益也属于贿赂行为。 通过第三方提供或者收受贿赂并不影响行为性质，仍应认定为贿赂行为。贿赂所涉及的利益可以采用财物或其他手段。财物是指现金和实物，包括现金和实物，任何包括假借促销费、宣传、赞助费、科研费、劳务费、咨询费、佣金等名义，或者以报销各种费用等方式，给付另一方的财物；任何其他手段包括提供国内外各种名义的旅游、考察等给付财物以外的其他利益的手段。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>甲方同意向乙方提供保乐力加产品的销售信息（包括进货、存货、价格、销售情况、消费者反映等）以及与乙方业务相关的其它市场信息。甲方同意，乙方人员有权查看甲方账目和销售情况以核实甲方提供的销售信息，甲方工作人员应当予以积极配合，否则乙方有权决定甲方不予获得当期的品牌推广服务费以及A类销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="g" style="" class="" > <content>甲方应遵守酒类销售相关法规并将对理性饮酒行动提供适当的支持，包括但不限于： </content> <type>Read</type> <subSection> <section name="" displayNumber="●" style="" class="" > <content>拒绝向疑似未成年人或孕妇出售酒精饮料；</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力避免向醉酒人员出售或推销酒精饮料；及</content> <type>Read</type> </section> <section name="" displayNumber="●" style="" class="" > <content>在适当范围内努力劝阻酒后驾车行为。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="h" style="" class="" > <content>甲方保证，甲方及其关联方在任何时候均遵守所有适用的反洗钱法律法规，并且未曾涉及任何未决或潜在的反洗钱法律诉讼。如果有合理的理由怀疑甲方的任何交易涉及洗钱活动，甲方应当在知悉该等理由后三（3）个工作日以内，向乙方提交一份列明可疑理由的报告。甲方应当停止与涉及可疑交易的任何客户的所有活动，直至进一步的调查使得乙方断定客户并未涉及该等活动。甲方不得向其客户或任何第三方披露提交给乙方报告有关的任何信息，也不得披露正在、已经或将要执行的调查细节或事实。 </content> <type>Read</type> </section> <section name="" displayNumber="i" style="font-weight: bold;" class="" > <content>利益冲突</content> <type>Read</type> </section> <section name="" displayNumber="i" style="" class="" > <content>甲方在此承诺：</content> <type>Read</type> <subSection> <section name="" displayNumber="(1)" style="" class="" > <content>至本协议签署之日，在其最大的认知程度内保证没有导致利益冲突（定义如下）的情况出现，或保证已经就已存在的利益冲突向乙方批露了相关信息。</content> <type>Read</type> </section> <section name="" displayNumber="(2)" style="" class="" > <content>在本协议有效期内，如有任何确切或潜在的利益冲突情况发生或可能发生，自知道或应该知道之日起三日内，以书面形式通知乙方。乙方有权决定是否继续本协议。</content> <type>Read</type> </section> </subSection> </section> <section name="" displayNumber="" style="" class="" > <content>利益冲突的定义：当甲方或其雇员、代理或代表在履行本协议时，因自身利益或与乙方有竞争或有业务往来的任何组织存在义务、亲属关系或其他特殊利害关系，这些关系可能使得甲方在履行本协议时影响其的判断或评价，导致对乙方产生实际的或潜在的损害。</content> <type>Read</type> </section> <section name="" displayNumber="j" style="font-weight: bold;" class="" > <content>违反本条第a、b、c、d、e、f、g、h、i款的规定构成对本协议的根本违约，乙方有权停止支付本协议下的任何费用并有权随时终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="7" style="font-weight: bold;" class="" > <content>知识产权</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>甲方/丙方保证不论在本协议期间或终止后其不会生产或销售或恶意致使任何人或任何单位生产或销售假冒保乐力加产品或任何其名称、商标或包装、装潢与保乐力加产品相似并易引起混淆的产品。一旦发现存在侵犯或潜在侵犯乙方或其母公司或关联方的专利、商标、著作权、商业秘密以及其它知识产权权益的行为，甲方/丙方应立即通知乙方，并应与乙方通力合作制止此类侵权行为。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>甲方/丙方不得变更、修改或移除任何保乐力加产品上的任何商标、专利声明、著作权声明及产品之上的任何其它标志，也不得在任何此类产品上附加任何其它的标志。甲方/丙方保证从本协议生效之日起，对产品的销售和使用均不会构成任何对乙方或其母公司或关联公司的专利、商标、著作权、商业秘密以及其它知识产权权益的侵犯。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>甲方/丙方不得使用 "Pernod Ricard”，“保乐力加”或保乐力加任何产品的品牌（包括中英文） 作为其名称、简称的一部分。未经乙方明确的书面同意，亦不得用任何方式使用乙方或其母公司或关联公司的字号、任何标志、图形、文字、代号。 在任何情况下，甲方/丙方也不得使用乙方、其母公司及关联方的企业名称作为其企业名称。</content> <type>Read</type> </section> <section name="" displayNumber="8" style="font-weight: bold;" class="" > <content>违约责任</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>本协议存续期间，如果一方未能履行本协议规定的义务和保证，除本协议明确约定的救济手段以外， 违约方还应向其它协议方承担损失赔偿责任。</content> <type>Read</type> </section> <section name="" displayNumber="9" style="font-weight: bold;" class="" > <content>协议的延长和终止 </content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>如任何一方在协议期内严违约（如违反第7条和第8条）、有欺诈性行为、遇政府法令禁止经营活动或被申请破产、清算或解散的，协议其它方有权向该方发出书面要求终止协议，本协议即随即终止。丙方具有上述情况的，乙方有权通过一级分销商立即终止丙方二级分销商的资格，同时通知甲方与新的二级分销商签订本协议，甲/丙方对上述安排应积极配合。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>除上述情况以外，如果甲/丙方未能履行本协议规定的其它义务和保证，乙方将给予违约方十五（15）个工作日的改正期，若期满后违约方行为未能得到改善和纠正，则视为严重违约，乙方有权立即终止本协议。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>协议的终止不影响无过错方向违约方主张经济上的违约或损害赔偿的权利以及协议中有关保密义务和知识产权义务的继续。</content> <type>Read</type> </section> <section name="" displayNumber="10" style="font-weight: bold;" class="" > <content>其它</content> <type>Read</type> </section> <section name="" displayNumber="a" style="" class="" > <content>本协议期满后，在同等条件下，乙方有优先续约权。</content> <type>Read</type> </section> <section name="" displayNumber="b" style="" class="" > <content>在任何情况下，未经一方允许，协议其它方不得将本协议的签署、本协议的内容及在本协议履行过程中获悉的该方的机密信息（包括该方或其关联公司的任何非公开资料包括商业策略，客户信息，批发商信息，活动计划，销量，价格、生意模式及商业秘密等）泄漏给任何第三方或本方的无关人员或用于本协议以外的目的。</content> <type>Read</type> </section> <section name="" displayNumber="c" style="" class="" > <content>除非本协议另有约定，否则任何一方在征得另二方事先书面同意之前均不得转让本协议或其相关权益。但乙方有权在书面通知甲方和丙方后，将本协议或其相关权益转让给乙方的关联方。</content> <type>Read</type> </section> <section name="" displayNumber="d" style="" class="" > <content>若本协议规定一方不得作出某行为，则应当解释为该一方均不得以任何直接或间接的方式或通过任何第三方作出该行为。</content> <type>Read</type> </section> <section name="" displayNumber="e" style="" class="" > <content>凡因本协议引起的或与本协议有关的任何争议，应先协商解决；协商不成的，任何一方均有权向上海市黄浦区人民法院提起诉讼。</content> <type>Read</type> </section> <section name="" displayNumber="f" style="" class="" > <content>本协议一式贰份，双方各持有一份。本协议自双方授权代表签字或盖章后生效。其它未尽事宜，由双方协商解决。</content> <type>Read</type> </section> </body> <BodySignature> <section name="BodySignature1" displayNumber="" style="font-weight: bold;font-size: 16px;" class="" > <content>甲方： {InputWholesaler}// 乙方：保乐力加（中国）贸易有限公司</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="ChopSignature" displayNumber="" style="" class="" description="Do Not change the name" > <content>签字盖章： // 签字盖章： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>日 期： // 日 期： </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content></content> <type>Read</type> </section> </BodySignature> <appendix> <section name="Appendix 1" displayNumber="" style="font-size: 18px;" class="" > <content>附件一</content> <type>Read</type> </section> <section name="Brand promotion plan and target of sales" displayNumber="" style="text-align: center;font-size: 16px;" class="" > <content>销售目标</content> <type>Read</type> </section> <section name="FixCostTableHeader" displayNumber="1" style="" class="AppendixLineHeader" description="Do Not change the name" > <content>&lt;b&gt;&lt;u&gt;销量目标和销售折扣 &lt;/u&gt; &lt;/b&gt;</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" description="Do Not change the name" > <content>为进一步推广保乐力加产品，乙方对其产品的经销企业实行销售折扣的政策。在符合约定前提条件的情况下，甲方可享受一定的销售折扣。具体要求如下：</content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" description="Do Not change the name" > <content>1.1 甲方拓展门店情况：</content> <type>Read</type> </section> <section name="CoveroutletTable" displayNumber="" style="" class="AppendixLineHeader ReplaceItem" > <content>{CoveredOutletTable} </content> <type>Read</type> </section> <section name="" displayNumber="" style="" class="" > <content>1.2 销售折扣</content> <type>Read</type> </section> <section name="SalesDiscount" displayNumber="" style="" class="" > <content></content> <type>Read</type> <subSection> <section name="BRSFTable_Incentive" displayNumber="" style="" class="" description="Do Not change the name" > <content>产品名称和规格// 单瓶销售折扣(元/瓶)</content> <type>Read</type> <subSection> <section name="BRSFTableB" displayNumber="" style="" class="2colspan2 2InputText" description="Do Not change the name" > <content>备注//以上产品皆为NCO产品，不收取回瓶。 </content> <type>Read</type> </section> </subSection> </section> </subSection> </section> <section name="Payment Conditions" displayNumber="2" style="" class="AppendixLineHeader" > <content>销售折扣的支付条件</content> <type>Read</type> <subSection> <section name="" displayNumber="a)" style="" class="" > <content>甲方完成约定条件是享受销售折扣的前提条件。 </content> <type>Read</type> </section> <section name="" displayNumber="b)" style="" class="" > <content> 甲方不回收包装，包含瓶盖上的二维码。 </content> <type>Read</type> </section> <section name="" displayNumber="c)" style="" class="" description=" " > <content>甲方按照实际进货量给予销售折扣。 </content> <type>Read</type> </section> <section name="" displayNumber="d)" style="" class="" description="Please Input Name Field" > <content> 甲方同意上述各项销售折扣可以从上一级经销商进货折让方式或产品实物的形式支付。 </content> <type>Read</type> </section> <section name="" displayNumber="e)" style="" class="" > <content>甲方始终遵守以下第3条的各项承诺。 </content> <type>Read</type> </section> </subSection> </section> <section name="Party A undertakes" displayNumber="3" style="font-weight: bold;" class="AppendixLineHeader" > <content>甲方承诺</content> <type>Read</type> <subSection> <section name="" displayNumber="a)" style="" class="" > <content>将在法律允许的范围内在甲方场地尽其最大商业努力推销乙方产品。 </content> <type>Read</type> </section> <section name="" displayNumber="b)" style="" class="" > <content>尽最大努力促使门店场地内用于调制杯饮类的副酒尽量使用乙方品类中相应品种的产品。 </content> <type>Read</type> </section> <section name="" displayNumber="c)" style="" class="" > <content>在门店场地重点展示乙方产品及其品牌。 </content> <type>Read</type> </section> <section name="" displayNumber="d)" style="" class="" > <content>应乙方不时之请求，促使门店为乙方的品牌在场内举行促销活动提供场地和服务 </content> <type>Read</type> </section> <section name="Editable12" displayNumber="e)" style="" class="" > <content>甲方承诺新开拓店点不少于XXX家，并保证协议期内每月新开店点不少于XXX家。 </content> <type>Editable</type> </section> </subSection> </section> </appendix> <AppendixSignature> </AppendixSignature> </source>';     
            
        String TextUpdatedList ='["FixCostTable_2_5//该项费用在本协议签订后3个月后支付，甲方需要提供相应的形象宣传照片等支持文件。", "FixCostTable_3_5//该项费用在双方确定具体活动计划时确定具体支付时间和方式。", "BRSFTableB//享受A类销售折扣的前提 1) 季度销量（或进货额）不低于ddd（可选项）;且2) 符合其他约定条件", "PSFTableA//B类销售折扣B类销售折扣B类销售折扣", "PSFTableD//B类销售折扣2甲方按品牌档次完成下述约定的销量指标是进一步享受B类销售折扣的前提条件", "Payment_ConditionsC//true", "Selectable1//true", "PartyAUndertakes_e//true", "Party C//华盛贸易(WSSHA228):a8bM00000008P59IAE"]';
        String InputAmountUpdatedList='[]';
        
        
        String ModuleRefList='["'+ModuleList[0].Id+'//享受A类销售折扣的前提 1) 季度销量（或进货额）不低于ddd（可选项）;且2) 符合其他约定条件",'+
            ' "'+ModuleList[1].Id+'//B类销售折扣B类销售折扣B类销售折扣",'+
            ' "'+ModuleList[5].Id+'//B类销售折扣2甲方按品牌档次完成下述约定的销量指标是进一步享受B类销售折扣的前提条件"]';
        Document document;
        
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/xml';
        document.DeveloperName = 'ASI_CRM_CN_Heavy_Test_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId =f.Id;// [select id from folder limit 1].id;
        insert document;
        
        
        test.startTest();
        ASI_CRM_CN_HeavyContractGenerationCtrl con = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con.xmlStringTestClass=XMLTestString;
        con.contractId=Contract.Id;
        con.isEditable=true;
        con.HightLight=false;
        con.init();
        
        
        ASI_CRM_CN_HeavyContractGenerationCtrl con2 = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con2.xmlStringTestClass=XMLTestString;
        con2.contractId=Contract.Id;
        con2.isEditable=false;
        con2.HightLight=false;
        con2.init();
        
        List<sObject>  TempList = ASI_CRM_CN_HeavyContractGenerationCtrl.findList('ASI_CRM_AccountsAdditionalField__c','Id,Name,ASI_CRM_CN_Legal_Name__c, ASI_CRM_Account__c, ASI_CRM_Account__r.id','');
        String TestString = ASI_CRM_CN_HeavyContractGenerationCtrl.saveTemplate('back',Contract.Id,TextUpdatedList,InputAmountUpdatedList,ModuleRefList,ContractCostLinesJson);
        
        
        ASI_CRM_CN_HeavyContractGenerationCtrl con3 = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con3.xmlStringTestClass=XMLTestString;
        con3.contractId=Contract.Id;
        con3.isEditable=false;
        con3.HightLight=true;
        con3.init();

        
        ApexPages.currentPage().getParameters().put('id',Contract.Id);
        ApexPages.currentPage().getParameters().put('edit','1');
        ApexPages.currentPage().getParameters().put('external','1');
        ApexPages.currentPage().getParameters().put('ForHightLight', '1');
        
        
        ASI_CRM_CN_HeavyContractGenerationCtrl con4 = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con4.xmlStringTestClass=XMLTestString2;
        con4.contractId=Contract.Id;
        con4.isEditable=false;
        con4.HightLight=true;
        con4.init();

        
        ASI_CRM_CN_HeavyContractGenerationCtrl con5 = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con5.xmlStringTestClass=XMLTestString3;
        con5.contractId=Contract.Id;
        con5.isEditable=false;
        con5.HightLight=true;
        con5.init();

        
        
        ASI_CRM_CN_HeavyContractGenerationCtrl con6 = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con6.xmlStringTestClass=XMLTestString4;
        con6.contractId=Contract.Id;
        con6.isEditable=false;
        con6.HightLight=true;
        con6.init();

        
        
        ASI_CRM_CN_HeavyContractGenerationCtrl con7 = new ASI_CRM_CN_HeavyContractGenerationCtrl();
        con7.xmlStringTestClass=XMLTestString5;
        con7.contractId=Contract.Id;
        con7.isEditable=false;
        con7.HightLight=true;
        con7.init();
        con7.CheckingIsVisibleOrNot('PartyA');
        con7.LineBreakProcess('TestTestTestTestTestTest',3,1);
        
        string TempStr= ASI_CRM_CN_HeavyContractGenerationCtrl.ChangeTemplate(Contract, region.Name, false);
        
        TempStr= con7.StringCaseHandler('{TotalMonthlyVolume} Test {ContractTotal} Test {BCRate} Test {MartellBCRate} Test {Key-SubBrand}',20.0, 20.0);
        
        
        
        
        
        
        test.stopTest(); 
        
    }
    
    
    
    
    static testMethod void EditHeavyContractDetailCtrlTest1() {
        //Test Class for ASI_CRM_CN_EditHeavyContractDetailCtrl
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id,ASI_CRM_CN_City_Tier__c='2');
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        
        ASI_CRM_SegmentationCriteria__c SegmentationCriteria= new ASI_CRM_SegmentationCriteria__c (Name='Test',ASI_CRM_Channel__c=channel.Id, ASI_CRM_Outlet_New_Image__c='Iconic',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SegmentationCriteria__cASI_CRM_CN_Segmentation_Criteria'));
        INSERT SegmentationCriteria;

        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        

        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c,LanguageLocaleKey FROM USER WHERE id =:UserInfo.getUserId()];
        currentUser.LanguageLocaleKey='zh_CN';
        update currentUser;
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        
        
        
        
        List<ASI_HK_CRM_Product_Category__c> ProductCategoryList= new List<ASI_HK_CRM_Product_Category__c> ();
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category1',ASI_CRM_CN_Chinese_Name__c='Category',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=1,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category2',ASI_CRM_CN_Chinese_Name__c='Category2',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=2,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category3',ASI_CRM_CN_Chinese_Name__c='Category1',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=3,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        
        insert ProductCategoryList;
        
        
        
        
        List<ASI_TH_CRM_Sub_category__c> SubCategoryList= new List<ASI_TH_CRM_Sub_category__c>();
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory1',ASI_CRM_CN_Product_Category__c=ProductCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory2',ASI_CRM_CN_Product_Category__c=ProductCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory3',ASI_CRM_CN_Product_Category__c=ProductCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        
        insert SubCategoryList;
        
        
        List<ASI_MFM_Brand__c> BrandList = new List<ASI_MFM_Brand__c> ();
        BrandList.add(new ASI_MFM_Brand__c (Name='Test1',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test2',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test3',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        
        Insert BrandList;
        
        
        
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='Premium',ASI_CRM_Chinese_Name__c='Test1',ASI_CRM_Chinese_Description__c='1. Standard + Premium 标准档 + 高档',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_MFM_Active_for_CRM__c=true,ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[1].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[2].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
        }
        
        insert subBrands;
        
        
        List<ASI_CRM_Sub_Brand_Assignment__c> SubBrandAssignmentList= new List<ASI_CRM_Sub_Brand_Assignment__c>();
        for(ASI_MFM_Sub_brand__c SubBrandItem:subBrands){
        	SubBrandAssignmentList.add(new ASI_CRM_Sub_Brand_Assignment__c(ASI_CRM_Sub_Brand__c=SubBrandItem.Id,ASI_CRM_Segmentation_Criteria__c=SegmentationCriteria.Id));
        }
        
        insert SubBrandAssignmentList;


        List<ASI_MFM_A_C_Code__c> ACCodeList = new  List<ASI_MFM_A_C_Code__c>();
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='0000000000000', ASI_MFM_A_C_Code__c='000010000',ASI_MFM_A_C_Description__c='ASI_CRM_CN_Variable_Cost_Contract',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.010000 PRC - Bottle Return Service', ASI_MFM_A_C_Code__c='5275.010000',ASI_MFM_A_C_Description__c='Bottle Return Service',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.020000 Promotion Service Fee', ASI_MFM_A_C_Code__c='5275.020000',ASI_MFM_A_C_Description__c='Promotion Service Fee',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.030000 PRC - Variable Event Cost', ASI_MFM_A_C_Code__c='5275.030000',ASI_MFM_A_C_Description__c='Variable Event Cost',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        
        insert ACCodeList;
        
        
        List<ASI_CRM_Contract_Cost_Setting__c> ContractCostSettingList= new List<ASI_CRM_Contract_Cost_Setting__c>();
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=true,ASI_CRM_CN_Variable_Cost_Contract__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_CN_BRSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_PSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_VEC_Activity_Code_Defaul__c=true));
        
        insert ContractCostSettingList;
        
        ASI_CRM_SpecialPromotionTypeSetting__c oldspts = new ASI_CRM_SpecialPromotionTypeSetting__c( ASI_CRM_Promotion_Type__c = 'a');
        insert oldspts;
        
        ASI_CRM_SpecialPromotionTypeSetting__c newspts = new ASI_CRM_SpecialPromotionTypeSetting__c(ASI_CRM_Promotion_Type__c = 'Heavy Contract On',recordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SpecialPromotionTypeSetting__cASI_CRM_CN_SpecialPromotionTypeSetting'));
        insert newspts;
        
        ASI_CRM_Special_Promotion_Type_Mapping__c sptm = new ASI_CRM_Special_Promotion_Type_Mapping__c(ASI_CRM_Mapping_of_New_Promotion_Type__c = newspts.Id,ASI_CRM_Mapping_of_Old_Promotion_Type__c = oldspts.Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Special_Promotion_Type_Mapping__cASI_CRM_CN_Special_Promotion_Type_Mapping'));
        insert sptm;
        
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;
        
        
        ASI_TH_CRM_Contract__c GroupContract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Group_Contract'),
                                                                          ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                          ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                          Name = 'Noah C4',
                                                                          ASI_CRM_CN_Outlet_WS__c=Customers[1].Id);
        insert GroupContract;
        
        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Final',ASI_CRM_CN_Group_Contract__c=GroupContract.Id,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract1',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
        
        
        List<ASI_CRM_Methodology__c> MethodologyList= new List<ASI_CRM_Methodology__c> ();
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='PSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='Variable Event Cost',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        
        
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='PSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='Variable Event Cost',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        insert MethodologyList;
        
        
        //Methodology Assignment
        List<ASI_CRM_Methodology_Assignment__c> MethodologyAssignmentList = new List<ASI_CRM_Methodology_Assignment__c>();
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[0].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[1].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[2].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[3].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[4].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[5].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        
        insert MethodologyAssignmentList ;
        
        
        
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF',ASI_CRM_Methodology__c=MethodologyList[0].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Grade',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Category',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='Variable Event Cost',ASI_CRM_Methodology__c=MethodologyList[2].Id));
        
        insert ModuleList;
        
        ASI_CRM_Contract_Cost__c contractCost = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        insert contractCost;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='PSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }

        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Grade',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Sub_Brand_Grade__c=grades[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Category',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[3].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Product_Category__c=ProductCategoryList[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[4].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[5].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='Variable Event Cost',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        
        insert ContractLineList;
        
        
        test.startTest();
        
          
        Integer coun = 1;
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:ContractLineList){
            system.debug(coun+'ContractLineList: '+ContractLine);
            coun++;
        }  

        
        
        
        ASI_CRM_CN_EditHeavyContractDetailCtrl con2 = new ASI_CRM_CN_EditHeavyContractDetailCtrl(new ApexPages.Standardcontroller(Contract));
        
        
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[17].id);
        ApexPages.currentPage().getParameters().put('PARAM_item_ID', ModuleList[1].id);
        ApexPages.currentPage().getParameters().put('PARAM_Unit_ID','Std. Btl.');
        con2.RemovePSFLine();
        
        
         ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[17].id);
        ApexPages.currentPage().getParameters().put('PARAM_item_ID', ModuleList[1].id);
        con2.PSFChangingSB();
        
        
        
        
        PageReference EnterPage = Page.ASI_CRM_CN_ViewHeavyContractPage;
        
        Map<String, String> pageParams = EnterPage.getParameters();
        
        pageParams.put('id', Contract.id);
        ApexPages.StandardController sc = new ApexPages.standardController(new ASI_TH_CRM_Contract__c());
        
        ASI_CRM_CN_EditHeavyContractDetailCtrl con = new ASI_CRM_CN_EditHeavyContractDetailCtrl(new ApexPages.Standardcontroller(Contract));
        con.saveItems();
        
       
        
        
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[0].id);
        con.Clone_BRSF();
        
        
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[1].id);
        con.Remove_BRSF();
        con.AddNew_BRSF();
        
      
         
        con.LoopingReCalculatePSF();
        
        con.PSFAddModule();
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ModuleList[1].id);
        con.RefreshPSFModule();
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ModuleList[2].id);
        con.RefreshPSFModule();
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ModuleList[3].id);
        con.RefreshPSFModule();
         ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ModuleList[4].id);
        con.RefreshPSFModule();
        
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ModuleList[1].id);
        con.AddNewPSFLine();
        
     
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[33].id);
        con.VECChangingSB();
        con.AddNewVECLine();
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[34].id);
        con.CloneVECLine();
        ApexPages.currentPage().getParameters().put('PARAM_Line_ID', ContractLineList[35].id);
        con.RemoveVECLine();
        
        
        con.AddNew_CoveredOutlet();
        
        con.saveItems();
        
           
        ApexPages.currentPage().getParameters().put('PARAMID', ModuleList[1].id);
        con.DeletePSFModule();
        
        con.BRSFClearAll();
        con.ModuleChecking();
        con.RefreshVECModule();
        con.ResetVECDetails();
        
        List<sObject> TempList= ASI_CRM_CN_EditHeavyContractDetailCtrl.FindSubBrandList('ASI_MFM_Sub_brand__c',' WHERE RecordType.DeveloperName = \'ASI_FOC_CN_Sub_brand\' ','Premium',region.Name,'2');
        test.stopTest(); 
    }
    
    
    
    static testMethod void EditHeavyContractDetailCtrlTest2() {
        //Test Class for ASI_CRM_CN_EditHeavyContractDetailCtrl
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='TEST',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id,ASI_CRM_CN_City_Tier__c='2');
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        
        ASI_CRM_SegmentationCriteria__c SegmentationCriteria= new ASI_CRM_SegmentationCriteria__c (Name='Test',ASI_CRM_Channel__c=channel.Id, ASI_CRM_Outlet_New_Image__c='Iconic',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SegmentationCriteria__cASI_CRM_CN_Segmentation_Criteria'));
        INSERT SegmentationCriteria;

        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',ASI_CRM_CN_New_Image__c='Iconic',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        
        
           
         list<ASI_CRM_AccountsAdditionalField__c> ChildChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=ChildCustomers[0].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildChildCustomers;
        
        
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c,LanguageLocaleKey FROM USER WHERE id =:UserInfo.getUserId()];
        currentUser.LanguageLocaleKey='zh_CN';
        update currentUser;
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        
        
        
        
        List<ASI_HK_CRM_Product_Category__c> ProductCategoryList= new List<ASI_HK_CRM_Product_Category__c> ();
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category1',ASI_CRM_CN_Chinese_Name__c='Category',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=1,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category2',ASI_CRM_CN_Chinese_Name__c='Category2',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=2,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        ProductCategoryList.add(new ASI_HK_CRM_Product_Category__c(Name='Category3',ASI_CRM_CN_Chinese_Name__c='Category1',ASI_HK_CRM_English_Name__c='Category',ASI_HK_CRM_Sequence__c=3,recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Product_Category__cASI_CRM_CN_Product_Category')));
        
        insert ProductCategoryList;
        
        
        
        
        List<ASI_TH_CRM_Sub_category__c> SubCategoryList= new List<ASI_TH_CRM_Sub_category__c>();
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory1',ASI_CRM_CN_Product_Category__c=ProductCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory2',ASI_CRM_CN_Product_Category__c=ProductCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        SubCategoryList.add(new ASI_TH_CRM_Sub_category__c(Name='SubCategory3',ASI_CRM_CN_Product_Category__c=ProductCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Sub_category__cASI_CRM_CN_Sub_Category')));
        
        insert SubCategoryList;
        
        
        List<ASI_MFM_Brand__c> BrandList = new List<ASI_MFM_Brand__c> ();
        BrandList.add(new ASI_MFM_Brand__c (Name='Test1',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[0].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test2',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[1].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        BrandList.add(new ASI_MFM_Brand__c (Name='Test3',ASI_CRM_CN_Competitor__c=false,ASI_TH_CRM_Sub_category__c=SubCategoryList[2].Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Brand__cASI_FOC_CN_Brand')));
        
        Insert BrandList;
        
        
        
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='Premium',ASI_CRM_Chinese_Name__c='Test1',ASI_CRM_Chinese_Description__c='1. Standard + Premium 标准档 + 高档',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_MFM_Active_for_CRM__c=true,ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[1].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',ASI_MFM_Active_for_CRM__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[2].Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id,ASI_MFM_Brand__c=BrandList[0].Id));
        }
        
        insert subBrands;
        
        
        List<ASI_CRM_Sub_Brand_Assignment__c> SubBrandAssignmentList= new List<ASI_CRM_Sub_Brand_Assignment__c>();
        for(ASI_MFM_Sub_brand__c SubBrandItem:subBrands){
        	SubBrandAssignmentList.add(new ASI_CRM_Sub_Brand_Assignment__c(ASI_CRM_Sub_Brand__c=SubBrandItem.Id,ASI_CRM_Segmentation_Criteria__c=SegmentationCriteria.Id));
        }
        
        insert SubBrandAssignmentList;


        List<ASI_MFM_A_C_Code__c> ACCodeList = new  List<ASI_MFM_A_C_Code__c>();
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='0000000000000', ASI_MFM_A_C_Code__c='000010000',ASI_MFM_A_C_Description__c='ASI_CRM_CN_Variable_Cost_Contract',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.010000 PRC - Bottle Return Service', ASI_MFM_A_C_Code__c='5275.010000',ASI_MFM_A_C_Description__c='Bottle Return Service',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.020000 Promotion Service Fee', ASI_MFM_A_C_Code__c='5275.020000',ASI_MFM_A_C_Description__c='Promotion Service Fee',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        ACCodeList.add(new ASI_MFM_A_C_Code__c( Name='5275.030000 PRC - Variable Event Cost', ASI_MFM_A_C_Code__c='5275.030000',ASI_MFM_A_C_Description__c='Variable Event Cost',recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code') ));
        
        insert ACCodeList;
        
        
        List<ASI_CRM_Contract_Cost_Setting__c> ContractCostSettingList= new List<ASI_CRM_Contract_Cost_Setting__c>();
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=true,ASI_CRM_CN_Variable_Cost_Contract__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_CN_BRSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_PSF_Activity_Code_Default__c=true));
        
        ContractCostSettingList.add(new ASI_CRM_Contract_Cost_Setting__c(ASI_CRM_CN_Activity_Code__c=ACCodeList[0].Id,ASI_CRM_CN_Promotion_Type__c='Heavy Contract ON',ASI_CRM_CN_Variable_Cost_Contract__c=true,
                                                                         ASI_CRM_CN_Fixed_Cost_Contract__c=false,ASI_CRM_VEC_Activity_Code_Defaul__c=true));
        
        insert ContractCostSettingList;
        
        ASI_CRM_SpecialPromotionTypeSetting__c oldspts = new ASI_CRM_SpecialPromotionTypeSetting__c( ASI_CRM_Promotion_Type__c = 'a');
        insert oldspts;
        
        ASI_CRM_SpecialPromotionTypeSetting__c newspts = new ASI_CRM_SpecialPromotionTypeSetting__c(ASI_CRM_Promotion_Type__c = 'Heavy Contract On',recordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_SpecialPromotionTypeSetting__cASI_CRM_CN_SpecialPromotionTypeSetting'));
        insert newspts;
        
        ASI_CRM_Special_Promotion_Type_Mapping__c sptm = new ASI_CRM_Special_Promotion_Type_Mapping__c(ASI_CRM_Mapping_of_New_Promotion_Type__c = newspts.Id,ASI_CRM_Mapping_of_Old_Promotion_Type__c = oldspts.Id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Special_Promotion_Type_Mapping__cASI_CRM_CN_Special_Promotion_Type_Mapping'));
        insert sptm;
        
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;
        
        
        ASI_TH_CRM_Contract__c GroupContract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Group_Contract'),
                                                                          ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                          ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                          Name = 'Noah C4',
                                                                          ASI_CRM_CN_Outlet_WS__c=Customers[1].Id);
        insert GroupContract;
        
        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Final',ASI_CRM_CN_Group_Contract__c=GroupContract.Id,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract1',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
                 
        test.startTest();
         
        List<ASI_CRM_Methodology__c> MethodologyList= new List<ASI_CRM_Methodology__c> ();
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='PSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Default__c=true,ASI_CRM_Chinese_Name__c='Test 123',ASI_CRM_Type__c='Variable Event Cost',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        
        
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test1',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='BRSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test2',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='PSF',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        MethodologyList.add(new ASI_CRM_Methodology__c(Name='Test3',ASI_CRM_Methodology_Code__c='01',ASI_CRM_Chinese_Name__c='123',ASI_CRM_Type__c='Variable Event Cost',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Methodology__cASI_CRM_CN_Methodology')));
        insert MethodologyList;
        
        
        //Methodology Assignment
        List<ASI_CRM_Methodology_Assignment__c> MethodologyAssignmentList = new List<ASI_CRM_Methodology_Assignment__c>();
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[0].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[1].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[2].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[3].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[4].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        MethodologyAssignmentList.add(new ASI_CRM_Methodology_Assignment__c(ASI_CRM_Methodology__c=MethodologyList[5].Id,ASI_CRM_Key_Principle__c=true,ASI_CRM_Methodology_Commercial_Team__c='Premium',ASI_CRM_Region__c=region.Id));
        
        //insert MethodologyAssignmentList ;
        
        
        
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF',ASI_CRM_Methodology__c=MethodologyList[0].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Grade',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Category',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Methodology__c=MethodologyList[1].Id));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='Variable Event Cost',ASI_CRM_Methodology__c=MethodologyList[2].Id));
        
        insert ModuleList;
        
        ASI_CRM_Contract_Cost__c contractCost = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        insert contractCost;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='PSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }

        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Grade',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Sub_Brand_Grade__c=grades[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Category',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[3].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,ASI_CRM_Product_Category__c=ProductCategoryList[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=4,ASI_CRM_Module__c=ModuleList[4].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=4,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
         for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[5].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='Variable Event Cost',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
       
      
                  
        
        
        
        PageReference EnterPage = Page.ASI_CRM_CN_ViewHeavyContractPage;
        
        Map<String, String> pageParams = EnterPage.getParameters();
        
        pageParams.put('id', Contract.id);
        ApexPages.StandardController sc = new ApexPages.standardController(new ASI_TH_CRM_Contract__c());
        
        ASI_CRM_CN_EditHeavyContractDetailCtrl con = new ASI_CRM_CN_EditHeavyContractDetailCtrl(new ApexPages.Standardcontroller(Contract));
        con.AddAllChildOutlets();
        
        con.saveItems();
        
       
        con.CancelProcess();
        test.stopTest(); 
    }
    
    
    
    
    
    static testMethod void ASI_CRM_CN_ContractTrigger() {
        ///Test class for ASI_CRM_CN_HeavyRejectedCommentCtrl
        //ASI_CRM_CN_HeavyContract_TriggerClass
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id);
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c FROM USER WHERE id =:UserInfo.getUserId()];
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        List<User> LUser = new List<User>();
        LUser.add(new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', ManagerId=userInfo.getUserId(),
                           LocaleSidKey='en_US', ProfileId = p.Id, ASI_CRM_Sales_Team__c = 'a',
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_c1@testing123.com', CompanyName = 'Pernod Ricard China'));
        insert LUser[0];
        
        
        List<User> userList= new List<User> ();
        userList.add(new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, ManagerID = LUser[0].id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_c2@testing123.com', CompanyName = 'Pernod Ricard China', ASI_CRM_Sales_Team__c = 'a'));
         userList.add(new User(Alias = 'standts', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_c3@testing123.com', CompanyName = 'Pernod Ricard China', ASI_CRM_Sales_Team__c = 'a'));

        insert userList;
        
        update new User(Id=LUser[0].id, BypassTriggers__c='');
        //update new User(Id=UserInfo.getUserId(), BypassTriggers__c='');
        
        
        List<ASI_CRM_Dynamic_Approval_Route__c> DynamicApprovalRouteList = new List<ASI_CRM_Dynamic_Approval_Route__c>();
        ASI_CRM_Dynamic_Approval_Route__c dar = new ASI_CRM_Dynamic_Approval_Route__c(ASI_CRM_Type__c='Contract',ASI_CRM_Approval_Limit__c=1,ASI_CRM_User__c=LUser[0].id);
        DynamicApprovalRouteList.add(dar);
        ASI_CRM_Dynamic_Approval_Route__c dar2 = new ASI_CRM_Dynamic_Approval_Route__c(ASI_CRM_Type__c='Contract',ASI_CRM_Approval_Limit__c=1,ASI_CRM_User__c=userInfo.getUserId(),ASI_CRM_End_of_Dynamic_Route__c=true);
        DynamicApprovalRouteList.add(dar2);
        
        insert DynamicApprovalRouteList;
        
        list<ASI_CRM_Fix_Approval_Route__c> fars = new list<ASI_CRM_Fix_Approval_Route__c>();
        fars.add(new ASI_CRM_Fix_Approval_Route__c(	ASI_CRM_Sales_Team__c = 'a', ASI_CRM_CN_Approver_1__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_2__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_3__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_4__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_5__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_6__c = userInfo.getUserId(), ASI_CRM_CN_Approver_7__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_8__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_9__c = userInfo.getUserId()
                                                   , ASI_CRM_CN_Approver_10__c = userList[1].Id
                                                   ,ASI_CRM_RVP__c= userList[1].Id,
                                                   ASI_CRM_CN_Regional_BA__c= userInfo.getUserId()
                                                   , ASI_CRM_CN_Approval_Limit_1__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_2__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_3__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_4__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_5__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_6__c = -999999, ASI_CRM_CN_Approval_Limit_7__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_8__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_9__c = -999999
                                                   , ASI_CRM_CN_Approval_Limit_10__c = -999999
                                                   ,ASI_CRM_CN_Type__c = 'Heavy Contract On',ASI_CRM_CN_Region_Area_Channel__c='TEST',ASI_CRM_CN_Entry_Limit__c=-999999));
        insert fars;
        
        
        
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='Premium',ASI_CRM_Chinese_Name__c='Test1',ASI_CRM_Chinese_Description__c='1. Standard + Premium 标准档 + 高档',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
        }
        insert subBrands;
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;
        
        
        List<ASI_TH_CRM_Contract__c> ContractList = new List<ASI_TH_CRM_Contract__c> ();
        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Draft',ownerId = userList[0].id,ASI_CRM_System_Debug__c=true,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract1',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        ContractList.add(Contract);
          ASI_TH_CRM_Contract__c Contract2 = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Draft',ownerId = LUser[0].id,ASI_CRM_System_Debug__c=true,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date.addYears(1),
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date.addYears(1),
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract2',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        ContractList.add(Contract2);
        insert ContractList;
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Grade',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='Variable Event Cost'));
        
        insert ModuleList;
        
        ASI_CRM_Contract_Cost__c contractCost = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        insert contractCost;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Est_Total_Dummy__c=100,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Est_Total_Dummy__c=100,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=subBrands[0].Id,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Grade',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Sub_Brand_Grade__c=grades[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,ASI_CRM_CN_Est_Total_Dummy__c=100,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[3].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_CN_Est_Total_Dummy__c=100,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='Variable Event Cost',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[4].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_CN_Est_Total_Dummy__c=100,ASI_CRM_CN_Contract_Total_Dummy__c=100,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        insert ContractLineList;
        
        
      
        
        
        test.startTest();
        //trigger: ASI_CRM_CN_HeavyContract_TriggerClass
        Contract.ASI_CRM_CN_Status__c='Submitted';
        update Contract;
        
        Contract.ASI_CRM_CN_Status__c='Draft';
        Contract.ASI_CRM_RVP_Approval__c=true;
        update Contract;
        
        Contract.ASI_CRM_CN_Return_Flag__c=true;
        update Contract;
        
        Contract.ASI_CRM_RVP_Approval__c=false;
        //Contract.CreatedDate=null;
        update Contract;
        
        test.stopTest(); 
        
    }
    
    
    
    static testMethod void ASI_CRM_CN_HeavyRejectedCommentCtrlTest() {
        ASI_eForm_HR_MDM__c tempMDM = new ASI_eForm_HR_MDM__c(Name='1234567', ASI_eForm_MDM_Department__c='tempHR',ASI_eForm_Employee_Company_Code__c = '222', 
    	ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='none', ASI_eForm_Employee_Bank_Account_Code__c='none', 
    	ASI_eForm_Employee_Bank_Name__c='none',	ASI_eForm_Employee_Eligible_PD__c = true, ASI_eForm_Employee_Branch_Code__c='300-Management', ASI_eForm_Employee_Is_Salesman__c=True, ASI_eForm_Employee_Gender__c='M', 
        ASI_eForm_Employee_Work_Email__c='123.345@email.com');
        
        insert tempMDM;
        
        
        User tempU = [select id,ASI_KOR_Commission_Code__c,ASI_CRM_Region__c from user where id = :userInfo.getUserId()];
        tempU.ASI_KOR_Commission_Code__c = '1234567';
        tempU.ASI_CRM_Region__c='CN-Admin';
        update tempU;

        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_eForm_Home_Appliance__cASI_eForm_KR_Home_Appliance');
        
        ASI_eForm_Home_Appliance__c a2 = new ASI_eForm_Home_Appliance__c(
            RecordTypeId=rtOutlet
            , ownerID=tempU.id
            , ASI_eForm_Status__c= 'draft');
        insert a2;
        
        test.startTest();
            
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(a2.Id);
        req1.setNextApproverIds(new Id[] {tempU.id});
        req1.setSubmitterID(tempU.id);
        req1.setSkipEntryCriteria(true);
        req1.setProcessDefinitionNameOrId('ASI_eForm_KR_HA_2');
        Approval.ProcessResult result =Approval.process(req1);
        
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Reject request.');
        req2.setAction('Reject');//     
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        if(result.getNewWorkitemIds().size()>0){
            req2.setWorkitemId(result.getNewWorkitemIds().get(0));
            Approval.process(req2);
        }
        
        
        ASI_CRM_CN_HeavyRejectedCommentCtrl con = new ASI_CRM_CN_HeavyRejectedCommentCtrl();
        con.currentHeaderId=a2.Id;
        con.init();
        test.stopTest();
    }
    
    
    
    
    
    static testMethod void ASI_CRM_CN_ViewHeavyContractCtrlTest1() {
        //Test Class for ASI_CRM_CN_ViewHeavyContractCtrl
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id);
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        
        
        // list<ASI_CRM_AccountsAdditionalField__c> ChildChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        //ChildChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=ChildCustomers[0].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        //insert ChildChildCustomers;
        
        //ASI_CRM_CN_Parent_Outlet__c
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c FROM USER WHERE id =:UserInfo.getUserId()];
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='Premium',ASI_CRM_Chinese_Name__c='Test1',ASI_CRM_Chinese_Description__c='1. Standard + Premium 标准档 + 高档',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_Sub_Brand_Grade__cASI_CRM_CN_Sub_brand_Grade')));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
        }
        insert subBrands;
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;

        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                               ASI_CRM_CN_Status__c = 'Final',
                                                               ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                               ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                               ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                               Name = 'Contract1',
                                                               ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Grade',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Contract__c=Contract.Id,ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='Variable Event Cost'));
        
        insert ModuleList;
        
        ASI_CRM_Contract_Cost__c contractCost = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,
                                                                             ASI_CRM_CN_Cost_Type__c = 'Fixed',
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        insert contractCost;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=subBrands[0].Id,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Grade',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,ASI_CRM_Sub_Brand_Grade__c=grades[0].Id,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[3].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        
          ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='Variable Event Cost',ASI_CRM_Volume_Base__c='By Total',

                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        insert ContractLineList;
        
        
        test.startTest();
        
        
        PageReference EnterPage = Page.ASI_CRM_CN_ViewHeavyContractPage;

        Map<String, String> pageParams = EnterPage.getParameters();
        
        pageParams.put('id', Contract.id);
        ApexPages.StandardController sc = new ApexPages.standardController(new ASI_TH_CRM_Contract__c());
        
        ASI_CRM_CN_ViewHeavyContractCtrl con = new ASI_CRM_CN_ViewHeavyContractCtrl(new ApexPages.Standardcontroller(Contract));
        con.ContractSelected.ASI_CRM_CN_Expected_BRSF_Est_Total__c=10;
        con.ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c=100;
         con.AddAllChildOutlets();
        con.SaveItems();
       
        con.AddNew_CoveredOutlet();
        con.GoEditDetailPage();
        con.GoCheckPointPage();
        con.GoEditHeaderPage();
        con.ViewCheckPointPage();
        con.GoEditDetailPage();
        con.POModification();
        con.GoPayment();
        con.GoReturn();
        con.UploadCompletion();
        con.Calculation();
        con.UncheckContractUploading();
        con.SetToFinal();
        con.CancelProcess();
        con.restorePO();
        test.stopTest(); 
    }
    
    
    
    
    
    
    static testMethod void ASI_CRM_CN_ViewHeavyContractCtrlTest2() {
        //Test Class for ASI_CRM_CN_ViewHeavyContractCtrl
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id);
        insert city;
        
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c FROM USER WHERE id =:UserInfo.getUserId()];
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST1'));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2'));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3'));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST4',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
        }
        insert subBrands;
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;

        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                                     ASI_CRM_CN_Status__c = 'Final',ASI_CRM_System_Debug__c=true,
                                                                     ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                                     ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                                     ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                                     Name = 'Contract1',
                                                                     ASI_CRM_CN_Outlet_WS__c=Customers[0].Id,ASI_CRM_Volume_Option__c = 'Normal'
                                                                    );
        insert Contract;
        
        ASI_CRM_Contract_Cost__c contractCost = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,
                                                                             ASI_CRM_CN_Cost_Type__c = 'Variable',
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        insert contractCost;
        
        test.startTest();
        
        
        PageReference EnterPage = Page.ASI_CRM_CN_ViewHeavyContractPage;
        Test.setCurrentPage(EnterPage);
        Map<String, String> pageParams = EnterPage.getParameters();
        
        pageParams.put('id', Contract.id);
        ApexPages.StandardController sc = new ApexPages.standardController(new ASI_TH_CRM_Contract__c());
        
        ASI_CRM_CN_ViewHeavyContractCtrl con = new ASI_CRM_CN_ViewHeavyContractCtrl(new ApexPages.Standardcontroller(Contract));
        
        con.Calculation();
       
        test.stopTest(); 
    }
    
    
    static testMethod void ASI_CRM_CN_ViewHeavyContractCtrlTest3() {
        //Test Class for ASI_CRM_CN_ViewHeavyContractCtrl
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id);
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        
        
         list<ASI_CRM_AccountsAdditionalField__c> ChildChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=ChildCustomers[0].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildChildCustomers;
        
        //ASI_CRM_CN_Parent_Outlet__c
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c FROM USER WHERE id =:UserInfo.getUserId()];
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST1'));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2'));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3'));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
        }
        insert subBrands;
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;

        ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                               ASI_CRM_CN_Status__c = 'Final',
                                                               ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                               ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                               ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                               Name = 'Contract1',
                                                               ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
        
        
        test.startTest();
        
        
        PageReference EnterPage = Page.ASI_CRM_CN_ViewHeavyContractPage;
        Test.setCurrentPage(EnterPage);
        Map<String, String> pageParams = EnterPage.getParameters();
        
        pageParams.put('id', Contract.id);
        ApexPages.StandardController sc = new ApexPages.standardController(new ASI_TH_CRM_Contract__c());
        
        ASI_CRM_CN_ViewHeavyContractCtrl con = new ASI_CRM_CN_ViewHeavyContractCtrl(new ApexPages.Standardcontroller(Contract));
        
        con.AddAllChildOutlets();
        con.SaveItems();
       
        test.stopTest(); 
    }
    
    

    static testMethod void ASI_CRM_CN_ViewHeavyContractCtrlTest4() {
        //Test Class for ASI_CRM_CN_ViewHeavyContractCtrl-----> Test restore
        ASI_CRM_Region__c region = new ASI_CRM_Region__c (Name='Central Region',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Region__cASI_CRM_CN_Region'));
        insert region;
        
        ASI_CRM_Division__c division = new ASI_CRM_Division__c(Name='TEST', ASI_CRM_Region__c=region.Id);
        insert division;
        
        ASI_CRM_CN_Area__c area = new ASI_CRM_CN_Area__c(Name='TEST', ASI_CRM_English_Name__c='TEST', ASI_CRM_Division__c=division.Id);
        insert area;
        
        ASI_CRM_City__c city = new ASI_CRM_City__c(Name='TEST', ASI_CRM_CN_Area__c=area.Id);
        insert city;
        
        ASI_CRM_CN_Channel__c channel = new ASI_CRM_CN_Channel__c(Name='KTV',ASI_CRM_BC_Rate__c=98,ASI_CRM_CN_On_Off__c='ON',ASI_CRM_For_Outlet__c=true,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_CRM_CN_Channel__cASI_CRM_CN_New_Channel'),ASI_CRM_For_Contract__c=TRUE);
        insert channel;
        
        Id rtWS = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_CN_WS');
        Id rtOutlet = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_Outlet_CN');
        
        list<ASI_CRM_AccountsAdditionalField__c> Customers = new list<ASI_CRM_AccountsAdditionalField__c>();
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtWS,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        Customers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert Customers;
        
        //Covered_Outlet
        list<ASI_CRM_AccountsAdditionalField__c> ChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        ChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=Customers[1].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        insert ChildCustomers;
        
        
        // list<ASI_CRM_AccountsAdditionalField__c> ChildChildCustomers = new list<ASI_CRM_AccountsAdditionalField__c>();
        //ChildChildCustomers.add(new ASI_CRM_AccountsAdditionalField__c(ASI_CRM_CN_Parent_Outlet__c=ChildCustomers[0].Id,ASI_CRM_CN_Commercial_Team__c = 'Premium',RecordTypeId=rtOutlet,Name='TEST', ASI_CRM_CN_Image__c='Iconic',ASI_CRM_CN_CCity__c=city.Id,ASI_CRM_CN_NewChannel__c=channel.Id));
        //insert ChildChildCustomers;
        
        //ASI_CRM_CN_Parent_Outlet__c
        
        User currentUser = [SELECT id, name, Managerid, ASI_CRM_CN_Prefix__c FROM USER WHERE id =:UserInfo.getUserId()];
        
        list<ASI_HK_CRM_Running_Number__c> rns = new list<ASI_HK_CRM_Running_Number__c>();
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_Contract__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_TH_CRM_PaymentRequest__c', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        if(!String.isBlank(currentUser.ASI_CRM_CN_Prefix__c))
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_'+currentUser.ASI_CRM_CN_Prefix__c, recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        else{
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_NULL', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
            rns.add(new ASI_HK_CRM_Running_Number__c(ASI_HK_CRM_Object_Name__c='ASI_CRM_CN_ContractPONo_', recordTypeId = Global_RecordTypeCache.getRtId('ASI_HK_CRM_Running_Number__cASI_CN_Running_Number')));
        }
        insert rns;
        
        //Sub Brand Grade
        list<ASI_CRM_Sub_Brand_Grade__c> grades = new list<ASI_CRM_Sub_Brand_Grade__c>();
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST1'));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST2'));
        grades.add(new ASI_CRM_Sub_Brand_Grade__c (Name='TEST3'));
        insert grades;
        
        
        list<ASI_MFM_Sub_brand__c> subBrands = new list<ASI_MFM_Sub_brand__c>();
        for(ASI_CRM_Sub_Brand_Grade__c grade :grades) {
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST1',ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c (Name='TEST2',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='TEST3',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
            subBrands.add(new ASI_MFM_Sub_brand__c ( Name='999',RecordTypeId=Global_RecordTypeCache.getRtId('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand'),
                                                    ASI_CRM_CN_COnvfactor_Ltocr12_C__c=1,ASI_MFM_Sub_brand_Code__c = '999' ,ASI_MFM_Active_for_CRM__c = true ,
                                                    ASI_CRM_CN_Sub_brand_Grade__c=grade.Id));
        }
        insert subBrands;
        
        
        Date PO_Start_Date = date.newinstance(system.today().year(), system.today().month(), 1);
        Date PO_End_Date = PO_Start_Date.addMonths(1)-1;

        ASI_TH_CRM_Contract__c Contract2 = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                               ASI_CRM_CN_Status__c = 'Archived',
                                                               ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                               ASI_CRM_CN_PO_End_Date__c =PO_End_Date,
                                                               ASI_CRM_CN_PO_Version__c = '0.0',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                               Name = 'Contract1',
                                                               ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract2;
        
          ASI_TH_CRM_Contract__c Contract = new ASI_TH_CRM_Contract__c(recordtypeid = Global_RecordTypeCache.getRTID('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                               ASI_CRM_CN_Status__c = 'Draft',
                                                               ASI_CRM_CN_PO_Start_Date__c = PO_Start_Date,
                                                               ASI_CRM_CN_PO_End_Date__c =PO_End_Date,ASI_CRM_CN_V0_0_PO_version__c=Contract2.Id,ASI_CRM_CN_Last_PO_version__c=Contract2.Id,
                                                               ASI_CRM_CN_PO_Version__c = '0.1',ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',
                                                               Name = 'Contract2',
                                                               ASI_CRM_CN_Outlet_WS__c=Customers[1].Id,ASI_CRM_Volume_Option__c = 'Normal');
        insert Contract;
        
        
        List<ASI_CRM_Module__c> ModuleList = new List<ASI_CRM_Module__c>();
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Line_Type__c='BRSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='PSF'));
        ModuleList.add(new ASI_CRM_Module__c(ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Line_Type__c='Variable Event Cost'));
        
        insert ModuleList;
        
        ASI_CRM_Contract_Cost__c contractCost = new ASI_CRM_Contract_Cost__c(ASI_CRM_CN_Contract__c = Contract.id,
                                                                             ASI_CRM_CN_Estimate_Amount__c = 100000,
                                                                             ASI_CRM_CN_Cost_Type__c = 'Variable',
                                                                             ASI_CRM_CN_Other_Cost_Payment_Request__c = true,
                                                                             recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_Contract_Cost__cASI_CRM_CN_Contract_Cost') );
        insert contractCost;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        list<ASI_CRM_CN_Covered_Outlet__c> cos = new list<ASI_CRM_CN_Covered_Outlet__c>();
        for(ASI_MFM_Sub_brand__c subBrand :subBrands) {
            ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,
                                                                           ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[0].Id,
                                                                           ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                           ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,ASI_CRM_Type__c='BRSF',
                                                                           ASI_CRM_CN_Sub_Brand__c=subBrand.Id,
                                                                           recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF')));
        }
        ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='PSF',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[1].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
          ContractLineList.add(new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=Contract.Id,ASI_CRM_Type__c='Variable Event Cost',ASI_CRM_Volume_Base__c='By Total',
                                                                       ASI_CRM_CN_Est_Monthly_Qty__c=1,ASI_CRM_Module__c=ModuleList[2].Id,
                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=1,
                                                                       ASI_CRM_CN_Est_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=10,
                                                                       ASI_CRM_CN_Sub_Brand__c=null,
                                                                       recordtypeid = Global_RecordTypeCache.getRTID('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF') ));
        insert ContractLineList;
        
        
        test.startTest();
        PageReference EnterPage = Page.ASI_CRM_CN_ViewHeavyContractPage;
        Test.setCurrentPage(EnterPage);
        ApexPages.currentPage().getParameters().put('id', Contract.id);
        
        
        ASI_CRM_CN_ViewHeavyContractCtrl con = new ASI_CRM_CN_ViewHeavyContractCtrl(new ApexPages.Standardcontroller(Contract));
        
        con.restorePO();
        con.POModification();
        con.ErrorHandling('Test');
        con.Calculation();
        test.stopTest(); 
    }
    
    
    
    
    
}