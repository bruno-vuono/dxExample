/* Filename:    ASI_CRM_CN_EditHeavyContractDetailCtrl.cls
* Author:      Laputa
* Purpose:     Controller for page over-ridding contract view, edit, new page for  CN CRM heavy contract on 
By Sub-Brand -- from 1) BRSF line sub brand if no , get  'ASI_CRM_SegmentationCriteria__c'
By Grade ---- > Sub-brand Grades
By Total---> one line
By Category--->      Product Category
* History     
* -----------------------------------------------------------------------------
* 2017-06-15   Laputa      Created

*/

public class ASI_CRM_CN_EditHeavyContractDetailCtrl {
    public ASI_TH_CRM_Contract__c ContractSelected {set;get;}
    
    public List<ASI_CRM_Contract_Cost__c> LFixCost {set;get;} {LFixCost = new List<ASI_CRM_Contract_Cost__c>();} //Fix cost
    List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> LBRSF {set;get;} {LBRSF=new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>(); }
    
    //BRSF
    //public map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c> BRSF_Item_Map {set;get;} {BRSF_Item_Map= new map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();}
    public interimData BRSFItemMap {set;get;} {BRSFItemMap= new interimData();}
    public boolean HideVEC  {set;get;} {HideVEC= true;}
    public List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> BRSFDeleteList {get;set;}{BRSFDeleteList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();}
    public List<ASI_CRM_Module__c> ModuleDeleteList {get;set;}{ModuleDeleteList = new List<ASI_CRM_Module__c>();}
    //PSF
    public map<String, interimData> PSF_Item_Map {set;get;} {PSF_Item_Map= new map<String, interimData>();}
    public Integer SizeOfPSFMap { get { return PSF_Item_Map.size(); } } 
    
    public Boolean showSuggestedAmountAndTargetVolume { get; set; } {showSuggestedAmountAndTargetVolume=false;}
    public Boolean ValidateTotalSuggestedAmount=false;
    public Decimal totalEstimate=0;
    
    
    
    //Variable Event Cost
    public interimData VariableEventCost {set;get;} {VariableEventCost= new interimData();} // Variable Event Cost= VEC
    public map<String, ASI_CRM_CN_Covered_Outlet__c> CoveredOutlet_Item_Map {set;get;}{CoveredOutlet_Item_Map= new map<String, ASI_CRM_CN_Covered_Outlet__c>();}
    public Map<String, ASI_CRM_Methodology__c> MethodologyMap  {set;get;} {MethodologyMap= new Map<String,ASI_CRM_Methodology__c>();}
    //@description : new line count
    public static String LINE_ITEM_NEWRECORD_PREFIX {get{ return 'z';}}
    public Integer LINE_ITEM_NEWRECORD_COUNTER {get;set;}
    public Boolean ShowWarning  {get;set;} {ShowWarning= false;}
    public String BRSFActivityCodeId  {get;set;}{BRSFActivityCodeId='';}
    public String PSFActivityCodeId  {get;set;}{PSFActivityCodeId='';}
    public String VECActivityCodeId  {get;set;}{VECActivityCodeId='';}
    
    public MethodType DisplayMethod {set;get;} {DisplayMethod = new MethodType();}
    
    public List<SelectOption> VolumeBasePickList {set;get;} {VolumeBasePickList = new List<SelectOption>();}
    
    public String msg {get;set;} {msg='';}
    public boolean UpsertPermission {get;set;}{UpsertPermission=true;}
    public boolean IsGroupContract {get;set;}{IsGroupContract=False;}
    
    public boolean ShowPSFPart {get;set;}{ShowPSFPart= true;}
    public boolean ShowVECPart {get;set;}{ShowVECPart= true;}
    
    
    
    public String BRSFDefaultMethodology  {get;set;} {BRSFDefaultMethodology='';}
    public String PSFDefaultMethodology  {get;set;} {PSFDefaultMethodology='';}
    public String VECDefaultMethodology  {get;set;} {VECDefaultMethodology='';}
    
    public Decimal DiffMonth {get;set;} {DiffMonth=0;}
      
    public ASI_CRM_Methodology__c BRSFMethodology_Default  {get;set;} {BRSFMethodology_Default= new ASI_CRM_Methodology__c();}
    public ASI_CRM_Methodology__c PSFMethodology_Default  {get;set;} {PSFMethodology_Default=new ASI_CRM_Methodology__c();}
    public ASI_CRM_Methodology__c VECMethodology_Default  {get;set;} {VECMethodology_Default=new ASI_CRM_Methodology__c();}
    
        
        //Save Historical Estimate Total Amount 
    public Decimal HistoricalBRSFEstimateTotal {set;get;} {HistoricalBRSFEstimateTotal=0;}
    public Decimal HistoricalVECEstimateTotal {set;get;} {HistoricalVECEstimateTotal=0;}
    
        
    Public Integer WarningTimes {get;set;} {WarningTimes=0;}
    Public String WarningMsg {get;set;} {WarningMsg='';}
    
    public Map<String, ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeMap  {get;set;}{SubBrandGradeMap= new Map<String, ASI_CRM_Sub_Brand_Grade__c>();}
    
    public List<ASI_CRM_CN_Covered_Outlet__c> ContractOutletList {set;get;}
    
    public String PageId {set;get;}
    
    public boolean showCN {set;get;}
    
    public Boolean HaveVEC999Line {set;get;} {HaveVEC999Line=false;}
    public String VEC999LineId {set;get;} {VEC999LineId='';}
    
    
    public ASI_CRM_CN_EditHeavyContractDetailCtrl(ApexPages.StandardController controller) {
        showCN = USerInfo.getLanguage()=='zh_CN';
        
        this.ContractSelected = (ASI_TH_CRM_Contract__c )controller.getRecord();
        if(this.ContractSelected != null)
            PageId = ContractSelected.id;
        
        this.ContractSelected = [SELECT Id,Name,ASI_CRM_CN_V00_No_of_Month__c,ASI_CRM_EVC_Cost_Estimate_Total__c ,ASI_CRM_V0_PSF_Contract_Total__c,ASI_CRM_Previous_Version_PSF_Est_Total__c ,ASI_CRM_PSF_Estimate_Adjustment_Amount__c ,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,
                                 ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_Expected_V0_PSF_Estimated_Total__c,ASI_CRM_CN_Group_Contract__c,
                                 ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c,ASI_CRM_CN_Total_Contract_Amount__c , ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c, ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                 ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                 ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,   ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                 recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                 ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                 ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c,
                                 (Select Id, Name, ASI_CRM_CN_Last_Payment__c, ASI_TH_CRM_Contract__c,ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_End_Date__c,ASI_TH_CRM_Status__c,ASI_CRM_CN_Channel__c, ASI_CRM_CN_Total_Payment__c,ASI_CRM_CN_Paid__c,ASI_CRM_CN_Paid_In_Progress__c, ASI_CRM_CN_Payment_Raised_Date__c From ASI_TH_CRM_PaymentRequests_Contract__r)                       
                                 FROM ASI_TH_CRM_Contract__c
                                 WHERE id =:pageId ];
        init();
    }
    
    
    public void init(){
        
        if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && ContractSelected.ASI_CRM_CN_V0_0_PO_version__c!=null ){
            //current version of month compare with V0.0 
            DiffMonth = ContractSelected.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c-ContractSelected.ASI_CRM_CN_No_of_Months__c;  
        }
        BRSFMethodology_Default= new ASI_CRM_Methodology__c();
        PSFMethodology_Default =new ASI_CRM_Methodology__c();
        VECMethodology_Default =new ASI_CRM_Methodology__c();
        ShowPSFPart= true;
        ShowVECPart= true;
        
        
        ShowWarning= false;
        String recordType = Global_RecordTypeCache.getRtId('ASI_CRM_SpecialPromotionTypeSetting__cASI_CRM_CN_SpecialPromotionTypeSetting');
        List<ASI_CRM_SpecialPromotionTypeSetting__c> SpecialPromotionTypeSettingList=[SELECT Id, Name, ASI_CRM_Validate_TotalSuggestedAmount__c, ASI_CRM_Promotion_Type_Chinese_Name__c, ASI_CRM_Bypass_Contract_Upload_Checking__c, ASI_CRM_Override_BC_Rate__c, ASI_CRM_SuggestedAmount_And_TargetVolume__c, ASI_CRM_Promotion_Type__c
                                                              FROM ASI_CRM_SpecialPromotionTypeSetting__c  WHERE  recordtypeid =: recordType  and ASI_CRM_Promotion_Type__c ='Heavy Contract On'];
        if(SpecialPromotionTypeSettingList.size()>0){
            showSuggestedAmountAndTargetVolume= SpecialPromotionTypeSettingList[0].ASI_CRM_SuggestedAmount_And_TargetVolume__c;
            ValidateTotalSuggestedAmount= SpecialPromotionTypeSettingList[0].ASI_CRM_Validate_TotalSuggestedAmount__c;
        }
                
        WarningTimes=0;
        if(ContractSelected.ASI_CRM_CN_Group_Contract__c!=null){
            IsGroupContract=true;
        }
        FindingDefaultValue();
        //Contract Cost
        for(ASI_CRM_Contract_Cost__c cc:[Select id, name, ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c, ASI_CRM_CN_Activity_Code__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Contract__r.ASI_TH_CRM_Promotion_Type__c from ASI_CRM_Contract_Cost__c where ASI_CRM_CN_Contract__c = :PageId order by ASI_CRM_CN_Sequence__c ASC, ASI_CRM_CN_Activity_Code__r.ASI_CRM_Promotion_Type__r.ASI_CRM_Sequence__c ASC]){
            if(cc.ASI_CRM_CN_Cost_Type__c == 'Fixed'){
                LFixCost.add(cc);
            }
        }
        
        //Module
        Map<String,ASI_CRM_Module__c> ModuleMap= new Map<String,ASI_CRM_Module__c>(); // Map <Id, ASI_CRM_Module__c>
        
        for(ASI_CRM_Module__c Module: [select Id,ASI_CRM_Remark_Display__c,ASI_CRM_Remark_Options__c,ASI_CRM_Created_PO_Version__c,ASI_CRM_CN_AC_Code__c,ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c,ASI_CRM_Group_Contract__c,ASI_CRM_Line_Type__c,ASI_CRM_Remark__c,ASI_CRM_Unit__c,ASI_CRM_Volume_Base__c,ASI_CRM_Methodology__c,ASI_CRM_Methodology__r.Name,ASI_CRM_Reason_Not_NCD_Methodology__c,ASI_CRM_Reason_NCD_Volume_Base__c from ASI_CRM_Module__c where ASI_CRM_Contract__c =:pageId ]){
            ModuleMap.put(Module.Id,Module);
        }
        //SubBrandGradeMap: Sub Brand name + Region + Commercial Team,  ASI_CRM_Sub_Brand_Grade__c
        SubBrandGradeMap  = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
        
        for(ASI_CRM_Sub_Brand_Grade__c sbg:ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingSubBrandGrade(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c )){
            if(sbg.ASI_CRM_CN_City_Tier__c!=null){
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c+ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(sbg.ASI_CRM_CN_City_Tier__c), sbg);
            }else{
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c, sbg);
            }
            
        }
        
        //*****************Looping  BRSF/PSF/VEC Line
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine:[SELECT Id,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c,ASI_CRM_Adjustment_Line__c,ASI_CRM_Product_Category__r.Name,ASI_CRM_Product_Category__r.ASI_CRM_CN_Chinese_Name__c,ASI_CRM_Sub_Brand_Grade__r.Name,ASI_CRM_Line_Name__c,ASI_CRM_Product_Category_Name__c,ASI_CRM_Sub_Brand_Grade_Name__c,ASI_CRM_Sub_Brand_CR12_Factor__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_Chinese_Name__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c, ASI_CRM_Product_Category__r.ASI_HK_CRM_Sequence__c,ASI_CRM_Max_Incentive__c , ASI_CRM_Module__r.ASI_CRM_Volume_Base__c, ASI_CRM_Contract_Total_QTY_std_Btl__c,ASI_CRM_Est_Total_QTY_std_Btl__c,ASI_CRM_Contract_Total_QTY_CR12_Eqv__c,ASI_CRM_Est_Total_QTY_CR12_Eqv__c,ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name,  ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Product_Category__c , ASI_CRM_Volume_Base__c , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :PageId] ){
            if(BRSFLine.ASI_CRM_CN_Sub_Brand__c!=null && BRSFLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c !=null){
                BRSFLine.ASI_CRM_Sub_Brand_Grade__c=BRSFLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c;
            }
            if(BRSFLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c==null){
                BRSFLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0; 
            }
            if(BRSFLine.ASI_CRM_Type__c=='BRSF'){
                if(ModuleMap.containsKey(BRSFLine.ASI_CRM_Module__c)){
                    BRSFLine.ASI_CRM_Line_Name__c= BRSFLine.ASI_CRM_Sub_Brand_Grade__c!=null?BRSFLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_Chinese_Name__c:BRSFLine.ASI_CRM_Sub_Brand_Grade__r.Name;
                    BRSFItemMap.Module=ModuleMap.get(BRSFLine.ASI_CRM_Module__c);
                    BRSFItemMap.Module.ASI_CRM_Contract__c=PageId;
                    BRSFItemMap.Module.ASI_CRM_Line_Type__c='BRSF';
                    if(showCN){
                        BRSFItemMap.MethodologyDisplay= BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c;
                    }else{
                        BRSFItemMap.MethodologyDisplay = BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name;
                    }
                    BRSFItemMap.MethodologyValue = BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name;
                }
                BRSFLine.ASI_CRM_Max_Incentive__c = GeneratingIncentive(SubBrandGradeMap,BRSFLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,'BRSFMax');
                if(!BRSFLine.ASI_CRM_Adjustment_Line__c){
                    HistoricalBRSFEstimateTotal+=BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
                
                BRSFItemMap.DetailLineMap.put(BRSFLine.Id,BRSFLine);
            }
            
            if(BRSFLine.ASI_CRM_Type__c=='PSF'){
                if(BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                    BRSFLine.ASI_CRM_Line_Name__c= BRSFLine.ASI_CRM_Sub_Brand_Grade__c!=null?BRSFLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_Chinese_Name__c:BRSFLine.ASI_CRM_Sub_Brand_Grade__r.Name;
                    BRSFLine.ASI_CRM_Max_Incentive__c = GeneratingIncentive(SubBrandGradeMap,BRSFLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,'PSFMax');
                }else{
                    BRSFLine.ASI_CRM_Max_Incentive__c=0;
                }
                
                String LineKey=BRSFLine.Id;
                if(BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Grade'){
                    BRSFLine.ASI_CRM_Line_Name__c= BRSFLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_Chinese_Name__c!=null?BRSFLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_Chinese_Name__c:BRSFLine.ASI_CRM_Sub_Brand_Grade__r.Name;
                    LineKey=ASI_CRM_CN_HeavyContractUtilitiesClass.NameSortingASC(BRSFLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c) +LineKey;
                }else if(BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Category'){
                     BRSFLine.ASI_CRM_Line_Name__c= BRSFLine.ASI_CRM_Product_Category__r.ASI_CRM_CN_Chinese_Name__c!=null?BRSFLine.ASI_CRM_Product_Category__r.ASI_CRM_CN_Chinese_Name__c:BRSFLine.ASI_CRM_Product_Category__r.Name;
                    LineKey=ASI_CRM_CN_HeavyContractUtilitiesClass.NameSortingASC(BRSFLine.ASI_CRM_Product_Category__r.ASI_HK_CRM_Sequence__c) +LineKey;
                }
                
                system.debug('PSF  Line : ' + BRSFLine);
                    
                if(PSF_Item_Map.containsKey(BRSFLine.ASI_CRM_Module__c)){
                    system.debug('PSF_Item_Map  containsKey ');
                    PSF_Item_Map.get(BRSFLine.ASI_CRM_Module__c).DetailLineMap.put(LineKey,BRSFLine);
                }else{
                    if(ModuleMap.containsKey(BRSFLine.ASI_CRM_Module__c)){
                        system.debug('ModuleMap  containsKey2  ');
                        interimData TempData= new interimData(ModuleMap.get(BRSFLine.ASI_CRM_Module__c));
                        PSF_Item_Map.put(BRSFLine.ASI_CRM_Module__c,TempData);
                        PSF_Item_Map.get(BRSFLine.ASI_CRM_Module__c).DetailLineMap.put(LineKey,BRSFLine);
                        PSF_Item_Map.get(BRSFLine.ASI_CRM_Module__c).Module.ASI_CRM_Contract__c=PageId;
                        if(showCN){
                            PSF_Item_Map.get(BRSFLine.ASI_CRM_Module__c).MethodologyDisplay= BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c;
                        }else{
                            PSF_Item_Map.get(BRSFLine.ASI_CRM_Module__c).MethodologyDisplay = BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name; 
                        }
                        PSF_Item_Map.get(BRSFLine.ASI_CRM_Module__c).MethodologyValue = BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name;
                    }
                }
            }
            
            if(BRSFLine.ASI_CRM_Type__c=='Variable Event Cost'){
                
                if(ModuleMap.containsKey(BRSFLine.ASI_CRM_Module__c)){
                    VariableEventCost.Module=ModuleMap.get(BRSFLine.ASI_CRM_Module__c);
                    VariableEventCost.Module.ASI_CRM_Contract__c=PageId;
                    VariableEventCost.Module.ASI_CRM_Line_Type__c='Variable Event Cost';
                    if(showCN){
                        VariableEventCost.MethodologyDisplay= BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c;
                    }else{
                        VariableEventCost.MethodologyDisplay = BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name;
                    }
                    VariableEventCost.MethodologyValue = BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name;
                }
                if(!BRSFLine.ASI_CRM_Adjustment_Line__c){
                    HistoricalVECEstimateTotal +=BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
                if(BRSFLine.ASI_CRM_CN_Sub_Brand__c!=null && BRSFLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c =='999'){
                    HaveVEC999Line=true;
                    VEC999LineId=BRSFLine.Id;
                }
                VariableEventCost.DetailLineMap.put(BRSFLine.Id,BRSFLine);
            }
        }
        
        
        if(BRSFItemMap.DetailLineMap.size()==0 &&!IsGroupContract){
            ASI_CRM_Module__c Module = NEW ASI_CRM_Module__c(ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c);
            BRSFItemMap.MethodologyValue=BRSFDefaultMethodology ;
            BRSFItemMap.Module= Module;
        }
        
        if(VariableEventCost.DetailLineMap.size()>0){
            VariableEventCost.HaveRefresh=true;
        }else if(!IsGroupContract){  // VEC Lines = 0             
            VariableEventCost.HaveRefresh=False;
            ASI_CRM_Module__c Module = NEW ASI_CRM_Module__c(ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c);
            VariableEventCost.MethodologyValue=VECDefaultMethodology;
            VariableEventCost.Module= Module;
            
        }
        
      
        
        if(IsGroupContract){ // of this contract is Group Contract
            Boolean ExistPSF= false;
            Boolean ExistVEC= false;
            for(string ModuleKey: ModuleMap.keySet()){
                ASI_CRM_Module__c Module = ModuleMap.get(ModuleKey);
                if(ModuleMap.get(ModuleKey).ASI_CRM_Line_Type__c=='BRSF'){
                    
                    BRSFItemMap.MethodologyValue= ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.Name;
                    BRSFItemMap.Module= Module;
                }
                if(ModuleMap.get(ModuleKey).ASI_CRM_Line_Type__c=='PSF' && ModuleMap.get(ModuleKey).ASI_CRM_Group_Contract__c){
                    if(!PSF_Item_Map.containsKey(ModuleKey)){
                        PSF_Item_Map.put(ModuleKey, new interimData(Module,false)); 
                    }
                    system.debug('ModuleKey now: '+ModuleKey);
                    system.debug('Now Methodology  '+ ModuleMap.get(ModuleKey).ASI_CRM_Line_Type__c);
                    //
                    PSF_Item_Map.get(ModuleKey).MethodologyValue=ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.Name;
                    if(showCN){
                        PSF_Item_Map.get(ModuleKey).MethodologyDisplay= ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c;
                    }else{
                        PSF_Item_Map.get(ModuleKey).MethodologyDisplay = ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.Name; 
                    }
                    system.debug(Module.Id+'Enter 123'+ ModuleKey );
                    PSF_Item_Map.get(ModuleKey).HaveRefresh=true;
                    ExistPSF= true;
                }
                if(ModuleMap.get(ModuleKey).ASI_CRM_Line_Type__c=='Variable Event Cost' && ModuleMap.get(ModuleKey).ASI_CRM_Group_Contract__c){
                    VariableEventCost.HaveRefresh=true;
                    
                    VariableEventCost.MethodologyValue= ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.Name;
                    if(showCN){
                        VariableEventCost.MethodologyDisplay= ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c;
                    }else{
                        VariableEventCost.MethodologyDisplay = ModuleMap.get(ModuleKey).ASI_CRM_Methodology__r.Name; 
                    }
                    VariableEventCost.Module= Module;
                    ExistVEC= true;
                }
            }
            
            if(!ExistPSF){
                ShowPSFPart= false;
            }
            if(!ExistVEC){
                ShowVECPart=false;
            }
        }
        
        
        
        system.debug('New debug 0122  ');
        for(String key:PSF_Item_Map.keySet()){
            system.debug('New ContractLine 0307 enter  ');
            //Looping every Module 
            for(String keyline:PSF_Item_Map.get(key).DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =PSF_Item_Map.get(key).DetailLineMap.get(keyline);
                system.debug('New ContractLine 0307 : '+ContractLine);
            }
        }
        system.debug('New debug 02  ');
        
        
        
        VolumeBasePickList= getPickListValue(ASI_CRM_Module__c.ASI_CRM_Volume_Base__c.getDescribe());
        
        //Set up Methodology Pick List Value
        DisplayMethod = new MethodType();
        MethodologyMap = new Map<String,ASI_CRM_Methodology__c>();
        for(ASI_CRM_Methodology__c meth: [Select Id,Name,ASI_CRM_Sequence__c,ASI_CRM_Type__c,ASI_CRM_Default__c,RecordType.DeveloperName,ASI_CRM_Chinese_Name__c,
                                          (select Id,ASI_CRM_Region__c,ASI_CRM_Key_Principle__c,ASI_CRM_Region__r.Name,ASI_CRM_Methodology_Commercial_Team__c from ASI_CRM_Methodology_Assignment__r) 
                                          from ASI_CRM_Methodology__c where RecordType.DeveloperName like 'ASI_CRM_CN%' ])
        {
            String MethodologyLabel=meth.Name;
            if(showCN){
                MethodologyLabel = meth.ASI_CRM_Chinese_Name__c;
            }
            
            if(meth.ASI_CRM_Type__c=='BRSF'){
                if(meth.ASI_CRM_Default__c){
                    DisplayMethod.BRSFMethod.add(new SelectOption(meth.Name, MethodologyLabel));//SelectOption option = new SelectOption(value, label);
                }else{
                    for(ASI_CRM_Methodology_Assignment__c ma:meth.ASI_CRM_Methodology_Assignment__r){
                        if(MethodologyChecking(ma)){
                            DisplayMethod.BRSFMethod.add(new SelectOption(meth.Name, MethodologyLabel));
                        }
                    }
                }
                
            }
            
            if(meth.ASI_CRM_Type__c=='PSF'){
                if(meth.ASI_CRM_Default__c){
                    DisplayMethod.PSFMethod.add(new SelectOption(meth.Name, MethodologyLabel));
                }else{
                    for(ASI_CRM_Methodology_Assignment__c ma:meth.ASI_CRM_Methodology_Assignment__r){
                        if(MethodologyChecking(ma)){
                            DisplayMethod.PSFMethod.add(new SelectOption(meth.Name, MethodologyLabel));
                        }
                    }
                }
            }
            
            if(meth.ASI_CRM_Type__c=='Variable Event Cost'){
                if(meth.ASI_CRM_Default__c){
                    DisplayMethod.VECMethod.add(new SelectOption(meth.Name,MethodologyLabel));
                }else{
                    for(ASI_CRM_Methodology_Assignment__c ma:meth.ASI_CRM_Methodology_Assignment__r){
                        if(MethodologyChecking(ma)){
                            DisplayMethod.VECMethod.add(new SelectOption(meth.Name,MethodologyLabel));
                        }
                    }
                }
            }
            MethodologyMap.put(meth.ASI_CRM_Type__c+meth.Name, meth); // overall map
        }
        
        
        
        // Covered Outlet
        ContractOutletList = [SELECT id, ASI_CRM_CN_Contract__c, ASI_CRM_CN_Suggested_Amount__c, ASI_CRM_CN_Target_Volume_Std_Btl__c, ASI_CRM_CN_Outlet__c, ASI_CRM_CN_Outlet__r.ASI_CRM_Account__c, ASI_CRM_CN_Allocated_Amount__c, ASI_CRM_CN_Check_All__c, ASI_CRM_CN_Selected_Covered_Outlet__c 
                              FROM ASI_CRM_CN_Covered_Outlet__c 
                              WHERE ASI_CRM_CN_Contract__c = :PageId];
        
        for(ASI_CRM_CN_Covered_Outlet__c Outlet:ContractOutletList){
            CoveredOutlet_Item_Map.put(Outlet.Id,outlet);
        }
        
        
      
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //****************************************************************************init setup end********************************************************
    
    //MethodologyChecking : check if the Commercial Team,Region of Methodology Assignment is same with this Outlet
    private boolean MethodologyChecking(ASI_CRM_Methodology_Assignment__c MethodologyAssignment ){
        //system.debug('***MethodologyChecking***');
        //system.debug('***Region:'+ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c);
        //system.debug('***Commercial Team  : :'+ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c);
        boolean SetAsPickList=false;
        if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c !=null && 
           ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c !=null )
        {
           
            if(MethodologyAssignment.ASI_CRM_Key_Principle__c && 
               MethodologyAssignment.ASI_CRM_Region__r.Name == ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c && 
               MethodologyAssignment.ASI_CRM_Methodology_Commercial_Team__c == ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c)
            {
                
                SetAsPickList=true;
            }
        }
        
        return SetAsPickList;
    }
    
    
    //Retrieve default value
    public void FindingDefaultValue(){
        //Find Default value for PSF
        List<ASI_CRM_Methodology__c> MethodologyList=[select Id,ASI_CRM_Default__c,Name,ASI_CRM_Type__c,ASI_CRM_Sequence__c from ASI_CRM_Methodology__c where ASI_CRM_Default__c = true and RecordType.DeveloperName ='ASI_CRM_CN_Methodology'];
        
        for(ASI_CRM_Methodology__c Methodology:MethodologyList){
            if(Methodology.ASI_CRM_Type__c =='BRSF'){
                BRSFMethodology_Default=Methodology;
                BRSFDefaultMethodology=Methodology.Name;
            }
            if(Methodology.ASI_CRM_Type__c =='PSF'){
                PSFMethodology_Default=Methodology;
                PSFDefaultMethodology=Methodology.Name;
            }
            if(Methodology.ASI_CRM_Type__c =='Variable Event Cost'){
                VECMethodology_Default=Methodology;
                VECDefaultMethodology=Methodology.Name;
            }
        }        
        
        BRSFActivityCodeId='';
        PSFActivityCodeId='';
        VECActivityCodeId='';
        
        List<ASI_CRM_Contract_Cost_Setting__c> ContractCostSettingList = [SELECT id, Name, ASI_CRM_VEC_Activity_Code_Defaul__c,ASI_CRM_CN_BRSF_Activity_Code_Default__c,ASI_CRM_PSF_Activity_Code_Default__c,ASI_CRM_CN_Activity_Code__c,ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Fixed_Cost_Contract__c, ASI_CRM_CN_Promotion_Type__c, ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Variable_Cost_Contract__c,   ASI_CRM_CN_Other_Cost_Payment_Request__c  FROM ASI_CRM_Contract_Cost_Setting__c where ASI_CRM_CN_Promotion_Type__c ='Heavy Contract On' ];
        for(ASI_CRM_Contract_Cost_Setting__c ccs:ContractCostSettingList){
            if(ccs.ASI_CRM_CN_BRSF_Activity_Code_Default__c){ //ASI_CRM_VEC_Activity_Code_Defaul__c,ASI_CRM_CN_BRSF_Activity_Code_Default__c,ASI_CRM_PSF_Activity_Code_Default__c
                BRSFActivityCodeId=ccs.ASI_CRM_CN_Activity_Code__c;
            }
            if(ccs.ASI_CRM_PSF_Activity_Code_Default__c){
                PSFActivityCodeId=ccs.ASI_CRM_CN_Activity_Code__c;
            }
            if(ccs.ASI_CRM_VEC_Activity_Code_Defaul__c){
                VECActivityCodeId=ccs.ASI_CRM_CN_Activity_Code__c;
                
            }
        }
    }
    
    
    
    
    //***************************************************************BRSF Part: Add/ Delete/ Clone function  **********************************************************
    
    public void CalBRSFAmount(){
        //ASI_CRM_Max_Incentive__c
        //Assign Sub-Brand Grade 
        Set<Id> BRSFSubBrandIdSet = new Set<Id>();
        for(String key:BRSFItemMap.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine =BRSFItemMap.DetailLineMap.get(key);
            if(BRSFLine.ASI_CRM_CN_Sub_Brand__c != null){
                BRSFSubBrandIdSet.add(BRSFLine.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        
        Map<String,ASI_MFM_Sub_brand__c> SubBrandMap= new Map<String,ASI_MFM_Sub_brand__c> ([select Id,Name,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c
                                                                                             from ASI_MFM_Sub_brand__c where Id in: BRSFSubBrandIdSet]);
        
        Map<String, ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeMap  = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
        //Looping the Sub-Brand Grade
        for(ASI_CRM_Sub_Brand_Grade__c sbg:ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingSubBrandGrade(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c )){
            if(sbg.ASI_CRM_CN_City_Tier__c!=null){
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c+ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(sbg.ASI_CRM_CN_City_Tier__c), sbg);
            }else{
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c, sbg);  
            }
        }
        
        
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            if(line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null ){
                line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
            }
            if(line.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c !=null){
                line.ASI_CRM_CN_Contract_Total_Dummy__c=line.ASI_CRM_CN_Contract_Monthly_Qty__c * line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
            }
            if(line.ASI_CRM_CN_Est_Monthly_Qty__c!=null && line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c !=null){
                line.ASI_CRM_CN_Est_Total_Dummy__c=line.ASI_CRM_CN_Est_Monthly_Qty__c * line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
            }
            
            //Assign Max Incentive 
            Decimal MaxIncentive=99999;
            String ExternalKey='';
            if(SubBrandMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                line.ASI_CRM_Line_Name__c= SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c!=null?SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c:SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name;
                
                line.ASI_CRM_Sub_Brand_Grade__c = SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c;
                ExternalKey=SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name;
                ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c: '';
                ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c: '';
                
                String CityTierExternalKey = ExternalKey;
                if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c!=null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c !=null){
                    CityTierExternalKey+= ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c);
                }
                
                
                if(SubBrandGradeMap.containsKey(CityTierExternalKey)){
                    MaxIncentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Max_Incentive__c;
                }else if(SubBrandGradeMap.containsKey(ExternalKey)){
                    MaxIncentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_Max_Incentive__c;
                }else if(SubBrandGradeMap.containsKey(line.ASI_CRM_Sub_Brand_Grade__c)){
                    MaxIncentive=SubBrandGradeMap.get(line.ASI_CRM_Sub_Brand_Grade__c).ASI_CRM_Max_Incentive__c;
                }
                
                
            }
            line.ASI_CRM_Max_Incentive__c=MaxIncentive;
            
            
        }
    }
    
    
    // Copy Historical Contract V0.0 
    public void CopyHistoricalV0Contract(){
        SettingDefaultValue();
        Integer strDays = 365/12*6;
        Date strDate = ContractSelected.ASI_CRM_CN_PO_Start_Date__c - strDays;
        
        //Finding Old Promotion Types
        Set<String> oldPromotionTypes  = new  Set<String>();
        if(ContractSelected.ASI_CRM_New_FY_PO__c){
            oldPromotionTypes = ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingPromotionTypes(ContractSelected.ASI_TH_CRM_Promotion_Type__c);
        }
        
        ASI_TH_CRM_Contract__c PreviousCC = new ASI_TH_CRM_Contract__c();
        
        system.debug('Now oldPromotionTypes: '+oldPromotionTypes);
        system.debug('Now strDate: '+strDate);
        try{ 
            PreviousCC = [SELECT id,ASI_TH_CRM_Promotion_Type__c,RecordType.DeveloperName,ASI_CRM_Volume_Option__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c, ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_New_FY_PO__c, ASI_CRM_CN_Status__c
                          FROM ASI_TH_CRM_Contract__c WHERE ASI_CRM_CN_Outlet_WS__c = :ContractSelected.ASI_CRM_CN_Outlet_WS__c 
                          AND ASI_CRM_CN_PO_End_Date__c != null AND ASI_CRM_CN_PO_Start_Date__c != null
                          AND ASI_CRM_CN_PO_End_Date__c <= :ContractSelected.ASI_CRM_CN_PO_Start_Date__c  AND ASI_CRM_CN_PO_End_Date__c >= :strDate 
                          AND (ASI_TH_CRM_Promotion_Type__c = :ContractSelected.ASI_TH_CRM_Promotion_Type__c OR ASI_TH_CRM_Promotion_Type__c IN : oldPromotionTypes)
                          AND (ASI_CRM_CN_Status__c = 'Final' OR ASI_CRM_CN_Status__c = 'Archived' OR ASI_CRM_CN_Status__c = 'Submitted') 
                          ORDER BY ASI_CRM_CN_Status__c DESC, ASI_CRM_CN_PO_End_Date__c DESC, Name DESC, ASI_CRM_CN_PO_Version__c DESC LIMIT 1];
        }catch(exception e){
            PreviousCC = new ASI_TH_CRM_Contract__c();
        }
               
        if(PreviousCC.id != null){
            system.debug('Now PreviousCC.id'+ PreviousCC.id);
            //Found Historcal V0.0
            string HistoricalV00ContractId = null;
            
            if(PreviousCC != null && PreviousCC.id != null && PreviousCC.ASI_CRM_CN_V0_0_PO_version__c == null){ 
                HistoricalV00ContractId = PreviousCC.id;
            }else if(PreviousCC != null && PreviousCC.ASI_CRM_CN_V0_0_PO_version__c != null){
                HistoricalV00ContractId = PreviousCC.ASI_CRM_CN_V0_0_PO_version__c;
            }
            
            
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> NewBRSFList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            if(PreviousCC.ASI_TH_CRM_Promotion_Type__c=='Heavy Contract On'){
                 NewBRSFList = ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateContractList(HistoricalV00ContractId,'ASI_CRM_CRM_CN_Contract_Heavy_BRSF', ' and ASI_CRM_Type__c=\'BRSF\' ');
            
            }else{
                NewBRSFList = ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateContractList(HistoricalV00ContractId,'ASI_CRM_CN_Contract_BRSF_Line_Item', ' ');
            
            }
            
            system.debug('now HistoricalV00ContractId :'+HistoricalV00ContractId); 
    
            if(NewBRSFList.size()==0){
                ErrorHandling(Label.ASI_CRM_CN_Historical_V0_0_Contract_data);//'Please note that no Historical V0.0 Contract data found.'
            }else{
                //remove 
                for(String key:BRSFItemMap.DetailLineMap.keySet()){
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c DelTarget=BRSFItemMap.DetailLineMap.get(key);
                    if(DelTarget.id != null){
                        BRSFDeleteList.add(DelTarget);
                    }
                    BRSFItemMap.DetailLineMap.remove(key);
                }
                
                String ModuleId = '';
                if(BRSFItemMap.Module.Id !=null){
                    ModuleId= BRSFItemMap.Module.Id;
                }
                
                Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
                
                
                //Added---- Looping the BRSF Line
                for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine :NewBRSFList){
                    ContractLine.Id=null;
                    ContractLine.ASI_CRM_CN_External_ID__c =null;
                    if(ModuleId!=null){
                        try{ 
                            ContractLine.ASI_CRM_Module__c=ModuleId;
                        }catch(exception e){
                            
                        }
                    }
                    //reset incentive or max  incentive 
                    ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c= ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null? ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c:GeneratingIncentive(SubBrandGradeMap,ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,'BRSFDefault');
                    ContractLine.ASI_CRM_Max_Incentive__c= ContractLine.ASI_CRM_Max_Incentive__c!=null? ContractLine.ASI_CRM_Max_Incentive__c:GeneratingIncentive(SubBrandGradeMap,ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,'BRSFMax');
                    if(ContractLine.ASI_CRM_Sub_Brand_Grade__c==null){
                        ContractLine.ASI_CRM_Sub_Brand_Grade__c=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c;
                    }
                    ContractLine.ASI_CRM_Line_Name__c=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c!=null?ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c:ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    
                    ContractLine.ASI_CRM_Type__c='BRSF';
                    ContractLine.recordTypeId=BRSFLineRtId;
                    
                    if(ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null ){
                        ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
                    }
                    if(ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c !=null){
                        ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
                    }
                    if(ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c !=null){
                        ContractLine.ASI_CRM_CN_Est_Total_Dummy__c=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
                    }
                    
                 
                    ContractLine.ASI_CRM_CN_Contract__c=ContractSelected.Id;
                    BRSFItemMap.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), ContractLine);
                }
            }
        }else{
              ErrorHandling(Label.ASI_CRM_CN_Historical_V0_0_Contract_data);
        }
        
        
    }
    
    public void BRSFClearAll(){
        SettingDefaultValue();
        for(String key:BRSFItemMap.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c DelTarget=BRSFItemMap.DetailLineMap.get(key);
            if(DelTarget.id != null){
                BRSFDeleteList.add(DelTarget);
            }
            BRSFItemMap.DetailLineMap.remove(key);
        }
        
        
        String ModuleId = '';
        if(BRSFItemMap.Module.Id !=null){
            ModuleId= BRSFItemMap.Module.Id;
        }else{
            //Dont have module Id
        }
        
        //SubBrandGradeMap: External Key (Sub Brand name + Region + Commercial Team),  ASI_CRM_Sub_Brand_Grade__c
        Map<String, ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeMap  = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
        //Looping the Sub-Brand Grade
        for(ASI_CRM_Sub_Brand_Grade__c sbg:ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingSubBrandGrade(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c )){
            if(sbg.ASI_CRM_CN_City_Tier__c!=null){
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c+ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(sbg.ASI_CRM_CN_City_Tier__c), sbg);
            }else{
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c, sbg);  
            }
        }
        
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');//  system.assertEquals(null, ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c);
        
        for(ASI_CRM_SegmentationCriteria__c SCLine: [select Id,ASI_CRM_Outlet_New_Image__c,ASI_CRM_Channel__c, 
                                                     (select id,ASI_CRM_Sub_Brand__c,ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, 
                                                      ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c
                                                      from Sub_Brand_Assignments__r )   
                                                     from ASI_CRM_SegmentationCriteria__c   
                                                     where RecordType.DeveloperName =:'ASI_CRM_CN_Segmentation_Criteria' 
                                                     and ASI_CRM_Channel__c =: ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c 
                                                     and ASI_CRM_Outlet_New_Image__c =:ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c and ASI_CRM_Channel__c !=null 
                                                     and ASI_CRM_Outlet_New_Image__c !=null ])
        {
            for(ASI_CRM_Sub_Brand_Assignment__c Assignments : SCLine.Sub_Brand_Assignments__r){
                Decimal Incentive=0.0;
                String ExternalKey='';
                ExternalKey=Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c: '';
                ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c: '';
                
                String CityTierExternalKey = ExternalKey;
                if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c!=null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c !=null){
                    CityTierExternalKey+= ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c);
                }
                
                if(SubBrandGradeMap.containsKey(CityTierExternalKey)){
                    Incentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_CN_Incentive__c;
                }else if(SubBrandGradeMap.containsKey(ExternalKey)){
                    Incentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_CN_Incentive__c;
                }else if(SubBrandGradeMap.containsKey(Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name)){
                    Incentive=SubBrandGradeMap.get(Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name).ASI_CRM_CN_Incentive__c;
                }//system.debug('Test log 1.0 Sub_brand_Grade: '+Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c );
                
                ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine= new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=ContractSelected.Id,
                                                                                                          ASI_CRM_CN_Activity_Code__c=BRSFActivityCodeId,
                                                                                                          ASI_CRM_CN_Est_BRSF_Per_Bottle__c=Incentive,
                                                                                                          ASI_CRM_Sub_Brand_Grade__c=Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,
                                                                                                          ASI_CRM_Line_Name__c=Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c!=null?Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c:Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,
                                                                                                          ASI_CRM_Max_Incentive__c=Incentive,
                                                                                                          ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=Incentive, 
                                                                                                          ASI_CRM_CN_Sub_Brand__c =Assignments.ASI_CRM_Sub_Brand__c,ASI_CRM_Type__c='BRSF',recordTypeId=BRSFLineRtId);
                
                if(ModuleId!=null && ModuleId!=''){
                    //BRSFLine.ASI_CRM_Module__c=ModuleId;
                    
                    try{ 
                       BRSFLine.ASI_CRM_Module__c=ModuleId;
                    }catch(exception e){
                        ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_EditHeavyContractDetailCtrl.BRSFClearAll in ASI_CRM_CN_EditHeavyContractDetailPage class have Error  '+
                                                             'Save Error : ' +e.getMessage() + '</br>','ASI_CRM_CN_EditHeavyContractDetailPage','failed! with contract Id: '+ContractSelected.id );
                        
                    }

                    
                }
                BRSFItemMap.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), BRSFLine);
            }
            
        }
        
        CalBRSFAmount();
    }
    
   
    
    public void AddNew_BRSF(){
        
        
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF'); 
        BRSFItemMap.Module.ASI_CRM_Line_Type__c='BRSF';
        BRSFItemMap.Module.ASI_CRM_Contract__c=pageId;
        BRSFItemMap.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Type__c='BRSF',
                                                                                                                                    recordTypeId=BRSFLineRtId ,ASI_CRM_CN_Activity_Code__c=BRSFActivityCodeId,
                                                                                                                                    ASI_CRM_Max_Incentive__c=0,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0));
        
        //RefresgBRSFLine();
        CalBRSFAmount();
    }
    
    
    
    //@description: action for removing BRSF Line
    //@param: Null
    //@return: Null
    public void Remove_BRSF(){
        SettingDefaultValue();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(BRSFItemMap.DetailLineMap.containsKey(param_Id) && !BRSFItemMap.DetailLineMap.isEmpty()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=BRSFItemMap.DetailLineMap.get(param_Id);
            if(delTarget.id != null){
                BRSFDeleteList.add(delTarget);
            }
            BRSFItemMap.DetailLineMap.remove(param_Id);
        }
        CalBRSFAmount();
    }
    
    public void Clone_BRSF(){
        SettingDefaultValue();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(BRSFItemMap.DetailLineMap.containsKey(param_Id) && !BRSFItemMap.DetailLineMap.isEmpty()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c ClonedLine=BRSFItemMap.DetailLineMap.get(param_Id).clone(false);
            ClonedLine.Id=Null;
            BRSFItemMap.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), ClonedLine);
        }
        CalBRSFAmount();
    }
    
    //***************************************************************End of BRSF part  **********************************************************************
    
    
    
    
    //***************************************************************PSF Part **********************************************************************
    
    
    public void LoopingReCalculatePSF(){
        for(String key:PSF_Item_Map.keySet()){
            if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                for(String keyline:PSF_Item_Map.get(key).DetailLineMap.keySet()){
                    
                    if(!PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_Adjustment_Line__c){
                        if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null && ContractSelected.ASI_CRM_CN_PO_Version__c =='0.0' ){
                            PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_BRSF_Per_Bottle__c= PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
                        }
                        
                        if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null && PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                            PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_Total_Dummy__c=PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_Monthly_Qty__c * PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
                        }else{
                            PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_Total_Dummy__c=0;
                        }
                        
                        if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Monthly_Qty__c!=null && PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null){
                            PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Total_Dummy__c=PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Monthly_Qty__c * PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
                        }else{
                            PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Total_Dummy__c=0;
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    //Refresh Module based on Volume Base
    public void PSFAddModule(){
        LoopingReCalculatePSF();
        SettingDefaultValue();
        //Construct Key Id
        string keyId= LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine();
        ASI_CRM_Module__c module = new ASI_CRM_Module__c(ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Contract__c=pageId);
        PSF_Item_Map.put(keyId, new interimData(module,false)); 
        PSF_Item_Map.get(keyId).MethodologyValue=PSFDefaultMethodology;
    }
    
    
    
    public void CalPSFAmount(String ModuleId){ //Only Apply to By SubBrand Module
        
        Set<Id> SubBrandIdSet = new Set<Id>();
        for(String key:PSF_Item_Map.get(ModuleId).DetailLineMap.keySet()){
            if(PSF_Item_Map.get(ModuleId).DetailLineMap.get(key).ASI_CRM_CN_Sub_Brand__c != null){
                SubBrandIdSet.add(PSF_Item_Map.get(ModuleId).DetailLineMap.get(key).ASI_CRM_CN_Sub_Brand__c);
            }
        }
        
        //get all related subbrand's grade
        Map<String,ASI_MFM_Sub_brand__c> SubBrandMap= new Map<String,ASI_MFM_Sub_brand__c> ([select Id,Name,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c 
                                                                                             from ASI_MFM_Sub_brand__c where Id in: SubBrandIdSet]);        
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:PSF_Item_Map.get(ModuleId).DetailLineMap.values()){
            
            if(!line.ASI_CRM_Adjustment_Line__c){ // not 999-Line
                if(line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null && ContractSelected.ASI_CRM_CN_PO_Version__c =='0.0' ){
                    line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
                }
                if(line.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c !=null){
                    line.ASI_CRM_CN_Contract_Total_Dummy__c=line.ASI_CRM_CN_Contract_Monthly_Qty__c * line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
                }
                if(line.ASI_CRM_CN_Est_Monthly_Qty__c!=null && line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c !=null){
                    line.ASI_CRM_CN_Est_Total_Dummy__c=line.ASI_CRM_CN_Est_Monthly_Qty__c * line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
                }
                
                //Assign Max Incentive 
                Decimal MaxIncentive=99999;
                String ExternalKey='';
                
                if(SubBrandMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                    line.ASI_CRM_Sub_Brand_Grade__c = SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c;
                    line.ASI_CRM_Line_Name__c= SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c!=null?SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c:SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    
                    ExternalKey= SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c: '';
                    ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c: '';
                    
                    String CityTierExternalKey = ExternalKey;
                    if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c!=null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c !=null){
                        CityTierExternalKey+= ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c);
                    }
                    if(SubBrandGradeMap.containsKey(CityTierExternalKey)){
                        MaxIncentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Max_Incentive_for_PSF__c;
                    }else if(SubBrandGradeMap.containsKey(ExternalKey)){
                        MaxIncentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_Max_Incentive_for_PSF__c;
                    }else if(SubBrandGradeMap.containsKey(line.ASI_CRM_Sub_Brand_Grade__c)){
                        MaxIncentive=SubBrandGradeMap.get(line.ASI_CRM_Sub_Brand_Grade__c).ASI_CRM_Max_Incentive_for_PSF__c;
                    }
                }
                line.ASI_CRM_Max_Incentive__c=MaxIncentive;
            }
            
            
            
        }
    }
    
    
    public void ResetPSFDetails(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(PSF_Item_Map.containsKey(param_Id) && !PSF_Item_Map.isEmpty()){
            //reomve line
            for(String key : PSF_Item_Map.get(param_Id).DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=PSF_Item_Map.get(param_Id).DetailLineMap.get(key);
                if(delTarget.id != null){
                    BRSFDeleteList.add(delTarget);
                }
                PSF_Item_Map.get(param_Id).DetailLineMap.remove(key);
            }
            if(PSF_Item_Map.get(param_Id).Module.Id!=NULL){
                ModuleDeleteList.add(PSF_Item_Map.get(param_Id).Module);
            }
            
            PSF_Item_Map.get(param_Id).HaveRefresh=false;
            ASI_CRM_Module__c module = new ASI_CRM_Module__c(ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c,ASI_CRM_Unit__c='Std. Btl.',ASI_CRM_Line_Type__c='PSF',ASI_CRM_Contract__c=pageId);
            PSF_Item_Map.get(param_Id).MethodologyValue=PSFDefaultMethodology;
            PSF_Item_Map.get(param_Id).Module= Module;
        }
        
    }    
    
    
    
    
    public void RefreshPSFModule(){
        LoopingReCalculatePSF();
        SettingDefaultValue();
        //Pass module Id
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(PSF_Item_Map.containsKey(param_Id) && !PSF_Item_Map.isEmpty()){
            PSF_Item_Map.get(param_Id).HaveRefresh=true;
            Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
            
            if(MethodologyMap.containsKey('PSF'+PSF_Item_Map.get(param_Id).MethodologyValue)){
                if(showCN){
                    PSF_Item_Map.get(param_Id).MethodologyDisplay=MethodologyMap.get('PSF'+PSF_Item_Map.get(param_Id).MethodologyValue).ASI_CRM_Chinese_Name__c;
                }else{
                    PSF_Item_Map.get(param_Id).MethodologyDisplay=MethodologyMap.get('PSF'+PSF_Item_Map.get(param_Id).MethodologyValue).Name;
                }
            }

            //reomve line
            for(String key : PSF_Item_Map.get(param_Id).DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=PSF_Item_Map.get(param_Id).DetailLineMap.get(key);
                if(delTarget.id != null){
                    BRSFDeleteList.add(delTarget);
                }
                PSF_Item_Map.get(param_Id).DetailLineMap.remove(key);
            }
            //**************By Sub-Brand**************
            if(PSF_Item_Map.get(param_Id).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                Id subbrand999;

                ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine999= new ASI_CRM_CN_Contract_BRSF_Line_Item__c(); //DiffMonth = ContractSelected.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c-ContractSelected.ASI_CRM_CN_No_of_Months__c; 
                
                if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && ContractSelected.ASI_CRM_CN_V0_0_PO_version__c!=null ){ // v0.0 + 
                    subbrand999 = [SELECT Id FROM ASI_MFM_Sub_brand__c WHERE ASI_MFM_Active_for_CRM__c = true  AND ASI_MFM_Sub_brand_Code__c = '999'  AND recordtypeid = :Global_RecordTypeCache.getRTid('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand') LIMIT 1].id;
                    ContractLine999.ASI_CRM_CN_Contract__c=ContractSelected.Id;
                    ContractLine999.ASI_CRM_Adjustment_Line__c=true;
                    ContractLine999.recordTypeId=BRSFLineRtId;
                    ContractLine999.ASI_CRM_Volume_Base__c='By Sub-Brand';
                    ContractLine999.ASI_CRM_CN_Sub_Brand__c = subbrand999;
                    ContractLine999.ASI_CRM_CN_Est_Monthly_Qty__c = 0;
                    ContractLine999.ASI_CRM_CN_Contract_Monthly_Qty__c=0;
                    ContractLine999.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0;
                    ContractLine999.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0;
                    ContractLine999.ASI_CRM_CN_Contract_Total_Dummy__c=0; 
                    ContractLine999.ASI_CRM_CN_Est_Total_Dummy__c=0;
                    ContractLine999.ASI_CRM_Max_Incentive__c=99999;
                    ContractLine999.ASI_CRM_Type__c = 'PSF';
                }
                
                for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BySubBrandRefresh('PSF')){//system.debug('By PSF DiffMonth '+DiffMonth); system.debug('By PSF ASI_CRM_CN_Est_Monthly_Qty__c '+line.ASI_CRM_CN_Est_Monthly_Qty__c); system.debug('By PSF line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c '+line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c);
                    if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && ContractSelected.ASI_CRM_CN_V0_0_PO_version__c!=null ){
                        ContractLine999.ASI_CRM_CN_Est_Total_Dummy__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c!=null && line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null )? line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c*line.ASI_CRM_CN_Est_Monthly_Qty__c*DiffMonth: 0;
                    }
                   
                    PSF_Item_Map.get(param_Id).DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),line);
                }
                
                
                if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && DiffMonth !=0 ){ // put in the map
                    PSF_Item_Map.get(param_Id).DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),ContractLine999);
                }
                CalPSFAmount(param_Id);
                SettingDefaultValue();
            }
            
            
            //**************By Grade **************
            if(PSF_Item_Map.get(param_Id).Module.ASI_CRM_Volume_Base__c=='By Grade'){
                Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> SubBrandGradeGrouping =ByGradeGrouping('PSF');
               // Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> SubBrandGradeGrouping =ASI_CRM_CN_HeavyContracFunctionClass.ByGradeGrouping('PSF',BRSFItemMap.DetailLineMap.values(), ContractSelected);
                
                for(String key : SubBrandGradeGrouping.keySet()){
                    PSF_Item_Map.get(param_Id).DetailLineMap.put( SubBrandGradeGrouping.get(key).ASI_CRM_Map_Key__c+LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),SubBrandGradeGrouping.get(key));
                }
            }
            
            
            //**************By Category**************
            if(PSF_Item_Map.get(param_Id).Module.ASI_CRM_Volume_Base__c=='By Category'){
                Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> CategoryGrouping =ByProductCategoryGrouping('PSF');
                for(String key : CategoryGrouping.keySet()){
                    PSF_Item_Map.get(param_Id).DetailLineMap.put(CategoryGrouping.get(key).ASI_CRM_Map_Key__c+LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),CategoryGrouping.get(key));
                }
            }
            
            
            //************* By Total ***************
            if(PSF_Item_Map.get(param_Id).Module.ASI_CRM_Volume_Base__c=='By Total' ){
                PSF_Item_Map.get(param_Id).DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), ByTotalAmountGenerating('PSF'));
            }
            
        }
    }
    
    
    public void PSFChangingSB(){
        SettingDefaultValue();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String Module_Id = params.get('PARAM_Module_ID');
        String Line_Id = params.get('PARAM_Line_ID');
        if(PSF_Item_Map.containsKey(Module_Id) && !PSF_Item_Map.isEmpty()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c SelectedTarget=PSF_Item_Map.get(Module_Id).DetailLineMap.get(Line_Id);
            
            String SubBrandId= SelectedTarget.ASI_CRM_CN_Sub_Brand__c;
            ASI_MFM_Sub_brand__c SubBrand = [select Id,ASI_CRM_CN_Sub_brand_Grade__c from ASI_MFM_Sub_brand__c where Id =: SubBrandId ];
            
            PSF_Item_Map.get(Module_Id).DetailLineMap.get(Line_Id).ASI_CRM_Sub_Brand_Grade__c= SubBrand.ASI_CRM_CN_Sub_brand_Grade__c;
        }
        
    }
    
    public void AddNewPSFLine(){
        LoopingReCalculatePSF();
        SettingDefaultValue();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        if(PSF_Item_Map.containsKey(param_Id) && !PSF_Item_Map.isEmpty()){
            PSF_Item_Map.get(param_Id).DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Type__c='PSF',
                                                                                                                                                       ASI_CRM_Volume_Base__c='By Sub-Brand',
                                                                                                                                                       recordTypeId=BRSFLineRtId ,ASI_CRM_Max_Incentive__c=0,
                                                                                                                                                       ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0));
        }
        
        if(PSF_Item_Map.get(param_Id).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
            CalPSFAmount(param_Id);
            SettingDefaultValue();
        }
        
    }
    
    
    
    public void RemovePSFLine(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        String itm_Id = params.get('PARAM_item_ID');
        String UnitStr = params.get('PARAM_Unit_ID');
        system.debug('Orignal Unit: '+ PSF_Item_Map.get(itm_Id).Module.ASI_CRM_Unit__c );
        
        LoopingReCalculatePSF();
        SettingDefaultValue();
      
        //system.debug('Now Unit_Id: '+ UnitStr );
        if(PSF_Item_Map.containsKey(itm_Id) && !PSF_Item_Map.isEmpty()){
            system.debug('RemovePSFLine param_Id: '+ param_Id );
            ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=PSF_Item_Map.get(itm_Id).DetailLineMap.get(param_Id);
            if(delTarget.id != null){
                BRSFDeleteList.add(delTarget);
            }
            PSF_Item_Map.get(itm_Id).Module.ASI_CRM_Unit__c=UnitStr;
            system.debug('Now RemovePSFLine'+PSF_Item_Map.get(itm_Id).Module.ASI_CRM_Unit__c);
            PSF_Item_Map.get(itm_Id).DetailLineMap.remove(param_Id);
            if(PSF_Item_Map.get(itm_Id).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                SettingDefaultValue();
                CalPSFAmount(itm_Id);
            }
        }
    }
    
    
    
    public void DeletePSFModule(){
        LoopingReCalculatePSF();
        SettingDefaultValue();
        String param_Id = Apexpages.currentPage().getParameters().get('PARAMID');
        if(PSF_Item_Map.containsKey(param_Id) && !PSF_Item_Map.isEmpty()){
            for(String key : PSF_Item_Map.get(param_Id).DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=PSF_Item_Map.get(param_Id).DetailLineMap.get(key);
                if(delTarget.id != null){
                    BRSFDeleteList.add(delTarget);
                }
                //remove PSF Line
                PSF_Item_Map.get(param_Id).DetailLineMap.remove(key);
            }
            if(PSF_Item_Map.get(param_Id).Module.Id!=NULL){
                ModuleDeleteList.add(PSF_Item_Map.get(param_Id).Module);
            }
            //ModuleDeleteList
            //remove interimData
            PSF_Item_Map.remove(param_Id);
        }
    }
    
    
    
    //in PSF, after clicking 'refresh', if by sub-brand, get incentive from master
    public List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> BySubBrandRefresh(String LineType){ // System will refer to the default PSF incentive from sub-brand grade object
        Set<String> SBBrandSet= New Set<String>();
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            SBBrandSet.add(line.ASI_CRM_CN_Sub_Brand__c);
        }
        Map<String, ASI_MFM_Sub_brand__c> SubBrandGradeMapping= new Map<String, ASI_MFM_Sub_brand__c> ();  
        for(ASI_MFM_Sub_brand__c sb:[select Id,Name,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c 
                                     from ASI_MFM_Sub_brand__c where RecordType.DeveloperName  like '%CN%' and  id in: SBBrandSet])
        {
            SubBrandGradeMapping.put(sb.Id, sb);
        }
        
        //Sub-Brand Grade id, Sub-Brand Grade Record for 'ASI_CRM_CN_Sub_brand_Grade'
        Map<String,ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeNameMap = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
        String ExternalKey='';
        ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c: '';
        ExternalKey += ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c !=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c: '';
      
       
        //SubBrandGradeMap: External Key (Sub Brand name + Region + Commercial Team),  ASI_CRM_Sub_Brand_Grade__c
        Map<String, ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeMap  = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
        //Looping the Sub-Brand Grade 
        system.debug('Region '+ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c);
        system.debug('Now Comercial Team'+ ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c);
        for(ASI_CRM_Sub_Brand_Grade__c sbg: [SELECT ID, Name,ASI_CRM_Chinese_Name__c,ASI_CRM_CN_City_Tier__c,ASI_CRM_External_Key__c,ASI_CRM_CN_Incentive__c,RecordType.DeveloperName,ASI_CRM_Incentive_for_PSF__c,ASI_CRM_Max_Incentive_for_PSF__c,ASI_CRM_Max_Incentive__c 
                                             FROM ASI_CRM_Sub_Brand_Grade__c WHERE 
                                             RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade' or  RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade_Heavy_Contract_ON'  ])
        { 
             if(sbg.RecordType.DeveloperName =='ASI_CRM_CN_Sub_brand_Grade'){
                SubBrandGradeNameMap.put(sbg.Id,sbg);
            }
            if(sbg.ASI_CRM_CN_City_Tier__c!=null){
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c+ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(sbg.ASI_CRM_CN_City_Tier__c), sbg);
            }else{
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c, sbg);
            } 
        }
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLines = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            if(!line.ASI_CRM_Adjustment_Line__c){//not 999 Line
                 ASI_CRM_CN_Contract_BRSF_Line_Item__c TempLine = line.clone(false);
                 TempLine.Id=Null;
                 TempLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=null;
                 TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=null;
                 TempLine.ASI_CRM_CN_Activity_Code__c=PSFActivityCodeId;
                 TempLine.ASI_CRM_Type__c=LineType;
                 TempLine.ASI_CRM_Volume_Base__c='By Sub-Brand';
                 TempLine.ASI_CRM_Max_Incentive__c=9999999;
                 TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0;
                 if(TempLine.ASI_CRM_Sub_Brand_Grade__c==null && SubBrandGradeMapping.containsKey(TempLine.ASI_CRM_CN_Sub_Brand__c)){
                     TempLine.ASI_CRM_Sub_Brand_Grade__c= SubBrandGradeMapping.get(TempLine.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c!=null?SubBrandGradeMapping.get(TempLine.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c:null;
                 }
                 
                 if(TempLine.ASI_CRM_Sub_Brand_Grade__c!=null && SubBrandGradeNameMap.containsKey(TempLine.ASI_CRM_Sub_Brand_Grade__c)){
                     TempLine.ASI_CRM_Line_Name__c= SubBrandGradeNameMap.get(TempLine.ASI_CRM_Sub_Brand_Grade__c).ASI_CRM_Chinese_Name__c !=null?SubBrandGradeNameMap.get(TempLine.ASI_CRM_Sub_Brand_Grade__c).ASI_CRM_Chinese_Name__c:SubBrandGradeNameMap.get(TempLine.ASI_CRM_Sub_Brand_Grade__c).Name;
                     
                     String SubBrandGradeName= SubBrandGradeNameMap.get(TempLine.ASI_CRM_Sub_Brand_Grade__c).Name;
                     String CityTierExternalKey = SubBrandGradeName+ExternalKey;
                     if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c!=null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c !=null){
                         CityTierExternalKey+= ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c) ;
                     }
                     
                     system.debug('Point 2 : '+SubBrandGradeName+ExternalKey);
                     if(SubBrandGradeMap.containsKey(CityTierExternalKey)){
                         TempLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Incentive_for_PSF__c;
                         TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Incentive_for_PSF__c;
                     }else if(SubBrandGradeMap.containsKey(SubBrandGradeName+ExternalKey)){
                         system.debug('Now : enter 2'+SubBrandGradeName+ExternalKey);
                         system.debug('Now : level  2'+SubBrandGradeMap.get(SubBrandGradeName+ExternalKey).ASI_CRM_Incentive_for_PSF__c);
                         TempLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=SubBrandGradeMap.get(SubBrandGradeName+ExternalKey).ASI_CRM_Incentive_for_PSF__c;
                         TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=SubBrandGradeMap.get(SubBrandGradeName+ExternalKey).ASI_CRM_Incentive_for_PSF__c;
                     }else if(SubBrandGradeMap.containsKey(SubBrandGradeName)) {
                         system.debug('Now : enter 3'+SubBrandGradeName);
                         TempLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=SubBrandGradeMap.get(SubBrandGradeName).ASI_CRM_Incentive_for_PSF__c;
                         TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=SubBrandGradeMap.get(SubBrandGradeName).ASI_CRM_Incentive_for_PSF__c;
                    }
                 }
                 
                 //If not v0.0 version, all contract Base amount is 0
                 if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0'){
                     TempLine.ASI_CRM_CN_Contract_Total_Dummy__c=0;
                     TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0;
                 }
                 ContractLines.add(TempLine);
                 
            }
           
           
            
        }
        
        return ContractLines;
    }
    //***************************************************************************End of PSF Part **********************************************************************
    
    
    
    
    
    
    
    
    //************************************************************************Variable Event Cost(VEC) **********************************************************
    //Refresh Module based on Volume Base
    public void RefreshVECModule(){
        Id VECLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        VariableEventCost.HaveRefresh=true;        
        
        
        
        if(MethodologyMap.containsKey('Variable Event Cost'+VariableEventCost.MethodologyValue)){
            if(showCN){
                VariableEventCost.MethodologyDisplay=MethodologyMap.get('Variable Event Cost'+VariableEventCost.MethodologyValue).ASI_CRM_Chinese_Name__c;
            }else{
                VariableEventCost.MethodologyDisplay=MethodologyMap.get('Variable Event Cost'+VariableEventCost.MethodologyValue).Name;
            }
        }
        
        
        //remove previous lines
        for(String key : VariableEventCost.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=VariableEventCost.DetailLineMap.get(key);
            if(delTarget.id != null){
                BRSFDeleteList.add(delTarget);
            }
            VariableEventCost.DetailLineMap.remove(key);
        }
        
        //create line
        if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c TempLine = line.clone(false);
                TempLine.Id=Null;
                TempLine.ASI_CRM_Type__c='Variable Event Cost';
                TempLine.ASI_CRM_Volume_Base__c='By Sub-Brand';
                
                if(ContractSelected.ASI_CRM_CN_PO_Version__c =='0.0' ){
                    TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=NULL;
                    TempLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=NULL;
                    TempLine.ASI_CRM_CN_Contract_Total_Dummy__c=NULL;
                    TempLine.ASI_CRM_CN_Est_Total_Dummy__c=NULL;
                }else{
                    TempLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0;
                    TempLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0;
                    TempLine.ASI_CRM_CN_Contract_Total_Dummy__c=0;
                    TempLine.ASI_CRM_CN_Est_Total_Dummy__c=0;
                }
                if(!TempLine.ASI_CRM_Adjustment_Line__c){
                    VariableEventCost.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),TempLine);
                }
            }
            CalVECAmount();
        }
        
        if(VariableEventCost.Module.ASI_CRM_Volume_Base__c =='By Grade'){
            Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> SubBrandGradeGrouping = ByGradeGrouping('Variable Event Cost');
            for(String key : SubBrandGradeGrouping.keySet()){
                VariableEventCost.DetailLineMap.put( SubBrandGradeGrouping.get(key).ASI_CRM_Map_Key__c+LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),SubBrandGradeGrouping.get(key));
            }
        }        
        if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Category'){
            Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> CategoryGrouping =ByProductCategoryGrouping('Variable Event Cost');
            for(String key : CategoryGrouping.keySet()){
                VariableEventCost.DetailLineMap.put(CategoryGrouping.get(key).ASI_CRM_Map_Key__c+LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),CategoryGrouping.get(key));
            }
        }
        if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Total' ){
            VariableEventCost.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), ByTotalAmountGenerating('Variable Event Cost'));
        }
        
    }
    
    
    public void VECChangingSB(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(VariableEventCost.DetailLineMap.containsKey(param_Id) && !VariableEventCost.DetailLineMap.isEmpty()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c SelectedTarget=VariableEventCost.DetailLineMap.get(param_Id);
            String SubBrandId= SelectedTarget.ASI_CRM_CN_Sub_Brand__c;
            ASI_MFM_Sub_brand__c SubBrand = [select Id,ASI_CRM_CN_Sub_brand_Grade__c from ASI_MFM_Sub_brand__c where Id =: SubBrandId ];
            VariableEventCost.DetailLineMap.get(param_Id).ASI_CRM_Sub_Brand_Grade__c= SubBrand.ASI_CRM_CN_Sub_brand_Grade__c;
        }
    }
    
    
    public void AddNewVECLine(){
        Id VECLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        VariableEventCost.Module.ASI_CRM_Contract__c=PageId;
        VariableEventCost.Module.ASI_CRM_Line_Type__c='Variable Event Cost';
        VariableEventCost.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Volume_Base__c='By Sub-Brand',ASI_CRM_Type__c='Variable Event Cost',recordTypeId=VECLineRtId ));
        CalVECAmount();
    }
    
    
    public void RemoveVECLine(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(VariableEventCost.DetailLineMap.containsKey(param_Id) && !VariableEventCost.DetailLineMap.isEmpty()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=VariableEventCost.DetailLineMap.get(param_Id);
            if(delTarget.id != null){
                BRSFDeleteList.add(delTarget);
            }
            VariableEventCost.DetailLineMap.remove(param_Id);
        }
        if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
            CalVECAmount();
        }
        
    }
    
    
    
    public void CloneVECLine(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(VariableEventCost.DetailLineMap.containsKey(param_Id) && !VariableEventCost.DetailLineMap.isEmpty()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c ClonedLine=VariableEventCost.DetailLineMap.get(param_Id).clone(false);
            ClonedLine.Id=Null;
            VariableEventCost.DetailLineMap.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), ClonedLine);
        }
        CalVECAmount();
    }
    
    public void CalVECAmount(){// only apply for by subbrand module
        Set<Id> SubBrandIdSet = new Set<Id>();
        for(String key:VariableEventCost.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =VariableEventCost.DetailLineMap.get(key);
            if(ContractLine.ASI_CRM_CN_Sub_Brand__c != null){
                SubBrandIdSet.add(ContractLine.ASI_CRM_CN_Sub_Brand__c);
            }
            
        }
        
        Map<String,ASI_MFM_Sub_brand__c> SubBrandMap= new Map<String,ASI_MFM_Sub_brand__c> ([select Id,Name,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c
                                                                                             from ASI_MFM_Sub_brand__c where Id in: SubBrandIdSet]);
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:VariableEventCost.DetailLineMap.values()){
            if(line.ASI_CRM_CN_Sub_Brand__c!=null && SubBrandMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                line.ASI_CRM_Line_Name__c= SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c!=null?SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c:SubBrandMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name;
            }
            if(line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'  ){
                line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
            }
            
            if(line.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c !=null){
                line.ASI_CRM_CN_Contract_Total_Dummy__c=line.ASI_CRM_CN_Contract_Monthly_Qty__c * line.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
            }
            
            if(line.ASI_CRM_CN_Est_Monthly_Qty__c!=null && line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c !=null){
                line.ASI_CRM_CN_Est_Total_Dummy__c=line.ASI_CRM_CN_Est_Monthly_Qty__c * line.ASI_CRM_CN_Est_BRSF_Per_Bottle__c *  ContractSelected.ASI_CRM_CN_No_of_Months__c;
            }
        }
    }
    
    
    public void ResetVECDetails(){
        
        for(String key:VariableEventCost.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c delTarget=VariableEventCost.DetailLineMap.get(key);
            if(delTarget.id != null){
                BRSFDeleteList.add(delTarget);
            }
            VariableEventCost.DetailLineMap.remove(key);
        }
        
        if(VariableEventCost.Module.Id!=NULL){
            ModuleDeleteList.add(VariableEventCost.Module);
        }
        VariableEventCost.HaveRefresh=false;   
        ASI_CRM_Module__c Module = NEW ASI_CRM_Module__c(ASI_CRM_Line_Type__c='Variable Event Cost',ASI_CRM_Volume_Base__c='By Total',ASI_CRM_Unit__c='CR12 Extra Eqv.',ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c);
        VariableEventCost.MethodologyValue=VECDefaultMethodology;
        VariableEventCost.Module= Module;
    }
    
    //************************************************************************End of Variable Event Cost(VEC) **********************************************************************
    
    
    
    
    
    
    //****************************************************** Covered Outlet Line Item - functions End *****************************************************
    
    public void AddNew_CoveredOutlet(){
        ASI_CRM_CN_Covered_Outlet__c outlet = new ASI_CRM_CN_Covered_Outlet__c();
        CoveredOutlet_Item_Map.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(), outlet );
        outlet.ASI_CRM_CN_Selected_Covered_Outlet__c = true;
    }
    
    
    
    
    //*********************************************************
    //@description: Add All Child Outlets  in one time 
    //@param: Null
    //@return: Null
    // *********************************************************
    public void AddAllChildOutlets(){
        ASI_CRM_CN_Covered_Outlet__c outlet = new ASI_CRM_CN_Covered_Outlet__c();
        Set<id> Selecteddd = new Set<id>();
        Set<id> SChildCustomersIds = new Set<id>();
        String recordType = ContractSelected.ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName;
        Integer limitRecord = 0;
        if(recordType == 'ASI_CRM_Outlet_CN'){
            for ( ASI_CRM_CN_Covered_Outlet__c s:ContractOutletList ){
                Selecteddd.add(s.ASI_CRM_CN_Outlet__r.Id);
            }
            
            List<ASI_CRM_AccountsAdditionalField__c> childCustomers = [SELECT Id FROM ASI_CRM_AccountsAdditionalField__c where 
                                                                       ASI_CRM_CN_Parent_Outlet__c = :ContractSelected.ASI_CRM_CN_Outlet_WS__c AND Id NOT IN :Selecteddd  limit 200];
            
            if(childCustomers!= null && childCustomers.size() > 0) {          
                for(ASI_CRM_AccountsAdditionalField__c customer : childCustomers){ 
                    if(limitRecord < 200){                 
                        outlet = new ASI_CRM_CN_Covered_Outlet__c(ASI_CRM_CN_Outlet__c = customer.id);
                        outlet.ASI_CRM_CN_Selected_Covered_Outlet__c = true;
                        SChildCustomersIds.add(customer.Id);
                        CoveredOutlet_Item_Map.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),outlet);
                        limitRecord++;  
                    }  
                    else
                        break;
                }
            }  
            
            if(SChildCustomersIds != null && SChildCustomersIds.size() > 0 && limitRecord < 200){
                List<ASI_CRM_AccountsAdditionalField__c> childChildCustomers = [SELECT Id, Name FROM ASI_CRM_AccountsAdditionalField__c where ASI_CRM_CN_Parent_Outlet__c IN :SChildCustomersIds limit 200];        
                if(childChildCustomers != null && childChildCustomers.size() > 0 ) {                                  
                    for(ASI_CRM_AccountsAdditionalField__c childCustomer : childChildCustomers){  
                        if(limitRecord < 200){               
                            outlet = new ASI_CRM_CN_Covered_Outlet__c(ASI_CRM_CN_Outlet__c = childcustomer.id);
                            outlet.ASI_CRM_CN_Selected_Covered_Outlet__c = true;
                            CoveredOutlet_Item_Map.put(LINE_ITEM_NEWRECORD_PREFIX+newCounterCreatorLine(),outlet);
                            limitRecord++;  
                        }
                        else
                            break;
                    }
                }
            }
            
        }
        
        
        
    }
    
    
    //****************************************************** Covered Outlet Line Item - functions End ******************************************************
    
    
    
    // generate Grouping Map by BRSF Sub-Brand grade ContractSelected.ASI_CRM_CN_No_of_Months__c
    public Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> ByGradeGrouping (String LineType) {
        
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        //Store all Sub-Brand Id 
        Set<String> SBBrandSet= New Set<String>();
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            SBBrandSet.add(line.ASI_CRM_CN_Sub_Brand__c);
        }
        
        //Getting CR12 Factor Map
        Map<String,Decimal> CR12FactorMap= new Map<String,Decimal> ();
        
        CR12FactorMap= GenerateCR12FactorMap(SBBrandSet);
        
        //Map : <Sub-Brand Grade ,ASI_CRM_CN_Contract_BRSF_Line_Item__c >
        Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> SBGradeGrouping =new Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
        
        //Map : <Sub-BrandId,Sub-Brand Grade Id>
        Map<String, ASI_MFM_Sub_brand__c> SubBrandGradeMapping= new Map<String, ASI_MFM_Sub_brand__c> ();  
        for(ASI_MFM_Sub_brand__c sb:[select Id,Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c 
                                     from ASI_MFM_Sub_brand__c 
                                     where RecordType.DeveloperName  like '%CN%' and  id in: SBBrandSet]){
            SubBrandGradeMapping.put(sb.Id, sb);
        }
        
        
        Map<String,Decimal> GradeSequenceMap= new Map<String,Decimal>();
        for(ASI_CRM_Sub_Brand_Grade__c SBGrade : [select id,Name,ASI_CRM_Chinese_Name__c,ASI_CRM_CN_Sequence__c from ASI_CRM_Sub_Brand_Grade__c where RecordType.DeveloperName  ='ASI_CRM_CN_Sub_brand_Grade']){
            
            GradeSequenceMap.put(SBGrade.Id,SBGrade.ASI_CRM_CN_Sequence__c);
            ASI_CRM_CN_Contract_BRSF_Line_Item__c NewContractLine =  new ASI_CRM_CN_Contract_BRSF_Line_Item__c(
                ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Volume_Base__c='By Grade',
                ASI_CRM_Type__c=LineType,recordTypeId=BRSFLineRtId,
                ASI_CRM_Sub_Brand_Grade__c=SBGrade.Id,
                ASI_CRM_CN_Contract_Monthly_Qty__c= 0,ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0,
                ASI_CRM_Line_Name__c=SBGrade.ASI_CRM_Chinese_Name__c,
                ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0,
                ASI_CRM_Sub_Brand_Grade_Name__c=SBGrade.Name,
                ASI_CRM_CN_Est_Monthly_Qty__c=0,ASI_CRM_Contract_Monthly_Volume_CR12__c=0,ASI_CRM_Est_Monthly_Volume_CR12__c=0,
                ASI_CRM_Max_Incentive__c=0,
                ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c=0,
                ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c=0,
                ASI_CRM_Map_Key__c=ASI_CRM_CN_HeavyContractUtilitiesClass.NameSortingASC(SBGrade.ASI_CRM_CN_Sequence__c) ,
                ASI_CRM_Contract_Total_QTY_std_Btl__c=0,
                ASI_CRM_Est_Total_QTY_std_Btl__c=0,
                ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0,
                ASI_CRM_Est_Total_QTY_CR12_Eqv__c=0 );
            
            if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0'){
                NewContractLine.ASI_CRM_CN_Contract_Total_Dummy__c=0;
            }

            SBGradeGrouping.put(SBGrade.Id,NewContractLine);
            
            
        }       
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            if(SubBrandGradeMapping.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                Decimal CR12Factor=1;
                if(CR12FactorMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                    CR12Factor=CR12FactorMap.get(line.ASI_CRM_CN_Sub_Brand__c);
                }// system.debug(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c)+'Now By Grade : '+line.ASI_CRM_CN_Sub_Brand__c +CR12Factor);
                if(SBGradeGrouping.containsKey(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c)){
                    //All period Volume 
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_Total_QTY_CR12_Eqv__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor* ContractSelected.ASI_CRM_CN_No_of_Months__c;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_Total_QTY_CR12_Eqv__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor * ContractSelected.ASI_CRM_CN_No_of_Months__c;
                    
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_Total_QTY_std_Btl__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractSelected.ASI_CRM_CN_No_of_Months__c;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_Total_QTY_std_Btl__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * ContractSelected.ASI_CRM_CN_No_of_Months__c;
                    
                    //--------Volume per Month----
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_CN_Contract_Monthly_Qty__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c ;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_CN_Est_Monthly_Qty__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c ;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_Monthly_Volume_CR12__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor ;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_Monthly_Volume_CR12__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor ;
                    
                    if(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c<=4 ){
                        SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c ;
                        SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c ;
                        SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor ;
                        SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor ;                       
                    }
                    
                
                }else{
                    String MapKey='';
                    if(GradeSequenceMap.containsKey(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c)){
                        MapKey=ASI_CRM_CN_HeavyContractUtilitiesClass.NameSortingASC(GradeSequenceMap.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c));
                    }
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c TempContractLine= new ASI_CRM_CN_Contract_BRSF_Line_Item__c(
                        ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Volume_Base__c='By Grade', ASI_CRM_Type__c=LineType,
                        recordTypeId=BRSFLineRtId,  ASI_CRM_Map_Key__c=MapKey,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0,
                        ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c=0,
                        ASI_CRM_Max_Incentive__c=0,ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c=0,
                        ASI_CRM_Line_Name__c=SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c,
                        ASI_CRM_Sub_Brand_Grade__c=SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c, 
                        ASI_CRM_Sub_Brand_Grade_Name__c=SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).Name,
                        ASI_CRM_Contract_Monthly_Volume_CR12__c= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor,
                        ASI_CRM_Est_Monthly_Volume_CR12__c = (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor , 
                        ASI_CRM_CN_Contract_Monthly_Qty__c= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null)? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c , 
                        ASI_CRM_CN_Est_Monthly_Qty__c= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null)? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c , 
                        ASI_CRM_Contract_Total_QTY_CR12_Eqv__c= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null)? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor * ContractSelected.ASI_CRM_CN_No_of_Months__c , 
                        ASI_CRM_Est_Total_QTY_CR12_Eqv__c= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null)? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor * ContractSelected.ASI_CRM_CN_No_of_Months__c, 
                        ASI_CRM_Contract_Total_QTY_std_Btl__c= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null)? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor* ContractSelected.ASI_CRM_CN_No_of_Months__c, 
                        ASI_CRM_Est_Total_QTY_std_Btl__c= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null)? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor* ContractSelected.ASI_CRM_CN_No_of_Months__c )  ;                    
                    
                    SBGradeGrouping.put(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c,TempContractLine );
                }
                
                if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0'){
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_Total_QTY_std_Btl__c = 0;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_CN_Contract_Monthly_Qty__c = 0;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_Monthly_Volume_CR12__c = 0;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_CN_Contract_Total_Dummy__c = 0;
                }
                
                if(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c<=4 ){
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c = (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c ;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c = (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c ;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c = (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor ;
                    SBGradeGrouping.get(SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c).ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c = (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor ;                       
                }
                
            }
        }// end of Sub-Brand Grade Grouping 
        
        return SBGradeGrouping;
    }
    
    
    
    
    
    
    // ****************  For PSF/VEC,Product Category Map by BRSF Sub-Brand grade after clicking 'fresh'   ****************
    public Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> ByProductCategoryGrouping (String LineType) {
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        Set<String> SBBrandSet= New Set<String>();//Store all Sub-Brand Id 
        //Getting current sub-brand
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            if(line.ASI_CRM_CN_Sub_Brand__c != null){
                SBBrandSet.add(line.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        
        Map<String, ASI_MFM_Sub_brand__c> ProductCategoryMap= new Map<String, ASI_MFM_Sub_brand__c> ();   //Map : <Sub-Brand Id,Product Category Name>
        for(ASI_MFM_Sub_brand__c sb:[select Id,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_MFM_Brand__c, ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c,ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name,ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name from ASI_MFM_Sub_brand__c where RecordType.DeveloperName  like '%CN%' and  id in: SBBrandSet]){
            if(sb.ASI_MFM_Brand__c!=null){
                if(sb.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c !=null ){
                    ProductCategoryMap.put(sb.Id, sb);//sb.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name 
                } 
            }
        }
        
        //Map : <Product Category Name,Insert BRSF Line >        //ASI_CRM_CN_Contract_Total_Dummy__c=0.0, //ASI_CRM_CN_Est_Total_Dummy__c=0.0, //ASI_CRM_CN_Contract_BRSF_Per_Bottle__c= 0, //ASI_CRM_CN_Est_BRSF_Per_Bottle__c= 0,
        Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> ProductCategoryGrouping =new Map<String,ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
        //Getting all Product Category from DataBase
        for(ASI_HK_CRM_Product_Category__c ProductCategory:[select Id,Name,ASI_CRM_CN_Chinese_Name__c,ASI_HK_CRM_Sequence__c from ASI_HK_CRM_Product_Category__c where RecordType.DeveloperName  ='ASI_CRM_CN_Product_Category']){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c NewContractLine = new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Volume_Base__c='By Category',
                                                                                                              ASI_CRM_Product_Category__c=ProductCategory.Id,
                                                                                                              ASI_CRM_Product_Category_Name__c=ProductCategory.Name,ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0,
                                                                                                              ASI_CRM_Line_Name__c=ProductCategory.ASI_CRM_CN_Chinese_Name__c,
                                                                                                              ASI_CRM_CN_Contract_Monthly_Qty__c= 0,ASI_CRM_Contract_Monthly_Volume_CR12__c=0,ASI_CRM_Est_Monthly_Volume_CR12__c=0,
                                                                                                              ASI_CRM_Map_Key__c=ASI_CRM_CN_HeavyContractUtilitiesClass.NameSortingASC(ProductCategory.ASI_HK_CRM_Sequence__c),
                                                                                                              ASI_CRM_CN_Est_Monthly_Qty__c= 0,ASI_CRM_Max_Incentive__c=0,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0,
                                                                                                              ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0,
                                                                                                              ASI_CRM_Est_Total_QTY_CR12_Eqv__c=0,
                                                                                                              ASI_CRM_Contract_Total_QTY_std_Btl__c=0,
                                                                                                              ASI_CRM_Est_Total_QTY_std_Btl__c=0,
                                                                                                              ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c=0,
                                                                                                              ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c=0,
                                                                                                              ASI_CRM_Type__c=LineType,recordTypeId=BRSFLineRtId);
            if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0'){
                NewContractLine.ASI_CRM_CN_Contract_Total_Dummy__c=0;
            }                                                                                           
            ProductCategoryGrouping.put(ProductCategory.Name, NewContractLine);
        }
        
        
        //Getting CR12 Factor Map
        Map<String,Decimal> CR12FactorMap=GenerateCR12FactorMap(SBBrandSet);
        //Based on the SubBrand, calculate the volume in the detail list
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            if(ProductCategoryMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c) && ProductCategoryGrouping.containsKey(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name) ){
                Decimal CR12Factor=1;
                if(CR12FactorMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                    CR12Factor=CR12FactorMap.get(line.ASI_CRM_CN_Sub_Brand__c);
                }
                
                //------ Monthly Volume -------
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_Monthly_Volume_CR12__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*CR12Factor;
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Est_Monthly_Volume_CR12__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*CR12Factor;
                
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_CN_Contract_Monthly_Qty__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c;
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_CN_Est_Monthly_Qty__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c;
                
                //Total
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_Total_QTY_CR12_Eqv__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*CR12Factor*ContractSelected.ASI_CRM_CN_No_of_Months__c;
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Est_Total_QTY_CR12_Eqv__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*CR12Factor*ContractSelected.ASI_CRM_CN_No_of_Months__c;
                
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_Total_QTY_std_Btl__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*ContractSelected.ASI_CRM_CN_No_of_Months__c;
                ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Est_Total_QTY_std_Btl__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*ContractSelected.ASI_CRM_CN_No_of_Months__c;
            
                
                
                if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0'){
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_Total_QTY_std_Btl__c = 0;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_CN_Contract_Monthly_Qty__c = 0;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_Monthly_Volume_CR12__c = 0;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_CN_Contract_Total_Dummy__c = 0;
                }
                
                
                if(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c<4 ){
                    //------ Monthly Volume  (Excl. Premium and below)  -------
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*CR12Factor;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*CR12Factor;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c+= (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c;
                    ProductCategoryGrouping.get(ProductCategoryMap.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.Name).ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c+= (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c;
                    
                }
            }
        }
        
        
        Return ProductCategoryGrouping;
        
    }
    
    
    
    
    
    //*********************************************************
    //@description: Generate By Total Line 
    //@param: Null
    //@return: Null
    // *********************************************************
    public ASI_CRM_CN_Contract_BRSF_Line_Item__c ByTotalAmountGenerating(String LineType){
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        ASI_CRM_CN_Contract_BRSF_Line_Item__c InsertedLine = new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=pageId, ASI_CRM_Type__c=LineType, recordTypeId=BRSFLineRtId,
                                                                                                       ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0,ASI_CRM_Contract_Monthly_Volume_CR12__c=0,
                                                                                                       ASI_CRM_Est_Total_QTY_CR12_Eqv__c=0,ASI_CRM_Est_Monthly_Volume_CR12__c=0,
                                                                                                       ASI_CRM_Contract_Total_QTY_std_Btl__c=0,ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0,
                                                                                                       ASI_CRM_Est_Total_QTY_std_Btl__c=0,ASI_CRM_Max_Incentive__c=0,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0,
                                                                                                       ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c=0,
                                                                                                       ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c=0,ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c=0,
                                                                                                       ASI_CRM_CN_Contract_Monthly_Qty__c=0.0,ASI_CRM_CN_Est_Monthly_Qty__c=0.0,ASI_CRM_Volume_Base__c='By Total' );
        Set<String> SubBrandIdSet = new Set<String> ();
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            if(line.ASI_CRM_CN_Sub_Brand__c !=null){
                SubBrandIdSet.add(line.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        //Getting CR12 Factor Map
        Map<String,Decimal> CR12FactorMap=GenerateCR12FactorMap(SubBrandIdSet);
        
        
        //Map : <Sub-BrandId,Sub-Brand Grade Id>
        Map<String, ASI_MFM_Sub_brand__c> SubBrandGradeMapping= new Map<String, ASI_MFM_Sub_brand__c> ();  
        for(ASI_MFM_Sub_brand__c sb:[select Id,Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c 
                                     from ASI_MFM_Sub_brand__c 
                                     where RecordType.DeveloperName  like '%CN%' and  id in: SubBrandIdSet])
        {
            SubBrandGradeMapping.put(sb.Id, sb);
        }
        
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c line:BRSFItemMap.DetailLineMap.values()){
            Decimal CR12Factor=1;
            if(CR12FactorMap.containsKey(line.ASI_CRM_CN_Sub_Brand__c)){
                CR12Factor=CR12FactorMap.get(line.ASI_CRM_CN_Sub_Brand__c);
            }
            
            if(SubBrandGradeMapping.containsKey(line.ASI_CRM_CN_Sub_Brand__c) && SubBrandGradeMapping.get(line.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c<4){
                InsertedLine.ASI_CRM_Contract_MonthlyVol_std_ExclPrem__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c;
                InsertedLine.ASI_CRM_Contract_MonthlyVol_CR12ExclPrem__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*CR12Factor;
                InsertedLine.ASI_CRM_Est_Monthly_Vol_std_Btl_ExclPrem__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c;
                InsertedLine.ASI_CRM_Est_MonthlyVolume_CR12_ExclPrem__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*CR12Factor;
            }
            
            
            
            InsertedLine.ASI_CRM_CN_Est_Monthly_Qty__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c;
            InsertedLine.ASI_CRM_Est_Monthly_Volume_CR12__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*CR12Factor;
            InsertedLine.ASI_CRM_Est_Total_QTY_CR12_Eqv__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*CR12Factor*ContractSelected.ASI_CRM_CN_No_of_Months__c;
            InsertedLine.ASI_CRM_Est_Total_QTY_std_Btl__c += (line.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Est_Monthly_Qty__c*ContractSelected.ASI_CRM_CN_No_of_Months__c;
        
            if(ContractSelected.ASI_CRM_CN_PO_Version__c =='0.0'){
                InsertedLine.ASI_CRM_CN_Contract_Monthly_Qty__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c;
                InsertedLine.ASI_CRM_Contract_Monthly_Volume_CR12__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*CR12Factor;
                InsertedLine.ASI_CRM_Contract_Total_QTY_CR12_Eqv__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*CR12Factor*ContractSelected.ASI_CRM_CN_No_of_Months__c;
                InsertedLine.ASI_CRM_Contract_Total_QTY_std_Btl__c += (line.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:line.ASI_CRM_CN_Contract_Monthly_Qty__c*ContractSelected.ASI_CRM_CN_No_of_Months__c;
            }else{
                InsertedLine.ASI_CRM_CN_Contract_Monthly_Qty__c=0;
                InsertedLine.ASI_CRM_Contract_Monthly_Volume_CR12__c=0;
                InsertedLine.ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0;
                InsertedLine.ASI_CRM_Contract_Total_QTY_std_Btl__c=0;
                InsertedLine.ASI_CRM_CN_Contract_Total_Dummy__c=0;
            }
        }
        
        return InsertedLine;
        
    }
    
    
    //Generate CR12 Factor Mapping table : Sub-Brand Id, CR12 Factor 
    private Map<String,Decimal> GenerateCR12FactorMap(Set<String> SBIdSet){
        Map<String,Decimal> CR12FactorMap = new Map<String,Decimal> ();
        for(ASI_MFM_Sub_brand__c SubBrand: [select Id,ASI_CRM_CN_COnvfactor_Ltocr12_C__c,(select id,ASI_CRM_CR12_Conversion_Factor__c,ASI_CRM_Commercial_Team__c,ASI_CRM_CN_Region__c from ASI_CRM_CR12_Factors__r) from ASI_MFM_Sub_brand__c  where id in : SBIdSet ]){
            Decimal CR12Factor=1;
            Boolean FoundFactor = false;
            for(ASI_CRM_Sub_Brand_Line__c SubBrandLine: SubBrand.ASI_CRM_CR12_Factors__r){
                if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c !=null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c !=null && SubBrandLine.ASI_CRM_CR12_Conversion_Factor__c !=null &&  SubBrandLine.ASI_CRM_Commercial_Team__c == ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c && SubBrandLine.ASI_CRM_CN_Region__c == ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c ){
                    CR12Factor=SubBrandLine.ASI_CRM_CR12_Conversion_Factor__c;
                    FoundFactor=true;
                }
            }
            if(!FoundFactor && SubBrand.ASI_CRM_CN_COnvfactor_Ltocr12_C__c!=NULL ){
                CR12Factor=SubBrand.ASI_CRM_CN_COnvfactor_Ltocr12_C__c;
                FoundFactor=true;
            }
            if(FoundFactor){
                CR12FactorMap.put(SubBrand.Id, CR12Factor);
            }
        }
        return CR12FactorMap;
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    //***********************************************************Save the record ************************************************************************************
    public PageReference saveItems(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String isQuickSaveStr = params.get('IS_QUICK_SAVE');
        Boolean isQuickSave = (isQuickSaveStr==null)?false:Boolean.valueOf(isQuickSaveStr);    
        PageReference pageRef = null;
        msg = '';
        UpsertPermission = true;
        WarningMsg='';
        //Define variable
        UpsertPermission = true;
        totalEstimate=0;
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> UpsertBRSFList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
       
        ASI_CRM_Module__c BRSFModule= new ASI_CRM_Module__c();
        ASI_CRM_Module__c VECModule= new ASI_CRM_Module__c();
        List<ASI_CRM_CN_Covered_Outlet__c> Save_CoveredOutlet_Item = new List<ASI_CRM_CN_Covered_Outlet__c>();
        List<ASI_CRM_CN_Covered_Outlet__c> Saved_CoveredOutlet_Temp = new List<ASI_CRM_CN_Covered_Outlet__c>();
        
        
        Database.upsertResult[] UpsertTarget;
        Database.deleteResult[] DeleteTarget;
        
        Map<String,ASI_CRM_Module__c> PSFModuleMap = new Map<String,ASI_CRM_Module__c> ();
        
        if(ContractSelected.ASI_CRM_CN_Group_Contract__c==null){
            ModuleChecking();
        }
        
        
        if(UpsertPermission){ //Upsert Module Part 
            BRSFModule= BRSFItemMap.Module;
            if(MethodologyMap.containsKey('BRSF'+BRSFItemMap.MethodologyValue)){
                BRSFModule.ASI_CRM_CN_AC_Code__c=BRSFActivityCodeId!=null?BRSFActivityCodeId:null;
                BRSFModule.ASI_CRM_Methodology__c=MethodologyMap.get('BRSF'+BRSFItemMap.MethodologyValue).Id;
            }
            BRSFModule.ASI_CRM_Contract__c=PageId; 
           
            VECModule= VariableEventCost.Module;
            VECModule.ASI_CRM_Contract__c=PageId;
            
            if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
                BRSFModule.ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c;
                VECModule.ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c;
            }
            
            if(MethodologyMap.containsKey('Variable Event Cost'+VariableEventCost.MethodologyValue)){
                VECModule.ASI_CRM_CN_AC_Code__c=VECActivityCodeId!=null?VECActivityCodeId:null;
                VECModule.ASI_CRM_Methodology__c=MethodologyMap.get('Variable Event Cost'+VariableEventCost.MethodologyValue).Id;
            }
            for(String key:PSF_Item_Map.keySet()){
                if(MethodologyMap.containsKey('PSF'+PSF_Item_Map.get(key).MethodologyValue)){
                    PSF_Item_Map.get(key).Module.ASI_CRM_Methodology__c=MethodologyMap.get('PSF'+PSF_Item_Map.get(key).MethodologyValue).Id;
                }
                 if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
                     PSF_Item_Map.get(key).Module.ASI_CRM_Created_PO_Version__c=ContractSelected.ASI_CRM_CN_PO_Version__c;
                 }
                PSF_Item_Map.get(key).Module.ASI_CRM_CN_AC_Code__c=PSFActivityCodeId!=null?PSFActivityCodeId:null;
                PSFModuleMap.put(key, PSF_Item_Map.get(key).Module);
            }
        }          
        
        System.Savepoint pSavepoint = Database.setSavepoint();
        try{
            if(BRSFModule!=null){
                upsert BRSFModule;
            }
            if(VECModule!=null && VariableEventCost.HaveRefresh ){
                upsert VECModule;
            }
            if(PSFModuleMap.size()>0){
                upsert PSFModuleMap.values();
            }
        }catch(Exception e){
            msg += 'Save Error : ' +e.getMessage() + '</br>';
            pageRef = null;
            Database.rollback(pSavepoint);      
            UpsertPermission = false;
            return null;
        }
        
        
        if(VECModule.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
            CalVECAmount();
        }
        
        CalBRSFAmount();
        
        if(UpsertPermission){//Upsert detail Line 
            UpsertBRSFList=ValdationChecking(BRSFModule,VECModule,PSFModuleMap);
            
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> UpsertBRSFList2 =GenContractLine(BRSFModule,VECModule,PSFModuleMap);
            
            
            //  save Covered Outlet Line Items 
            for (String key : CoveredOutlet_Item_Map.keySet()){
                ASI_CRM_CN_Covered_Outlet__c outlet = CoveredOutlet_Item_Map.get(key);
                if(outlet.ASI_CRM_CN_Contract__c == null){
                    outlet.ASI_CRM_CN_Contract__c = ContractSelected.Id;
                    outlet.RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_CN_Covered_Outlet__cASI_CRM_CN_Covered_Outlet');
                }
                if(outlet != null && outlet.ASI_CRM_CN_Selected_Covered_Outlet__c == true && outlet.ASI_CRM_CN_Outlet__c != null){
                    Save_CoveredOutlet_Item.add(outlet);            
                }          
                else if (outlet.id != null && outlet.ASI_CRM_CN_Selected_Covered_Outlet__c == false) { 
                    Saved_CoveredOutlet_Temp.add(outlet);            
                }
            }
            
            if(Save_CoveredOutlet_Item != null && Save_CoveredOutlet_Item.size() > 0){
                CoveredOutletValdationChecking(Save_CoveredOutlet_Item);
            }
            
        }
        //system.assertEquals(WarningTimes, Null);
        if(UpsertPermission && WarningTimes!=1){
            
            pSavepoint = Database.setSavepoint();
            
            if(HistoricalVECEstimateTotal != ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c && ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && VariableEventCost.Module.ASI_CRM_Created_PO_Version__c!=ContractSelected.ASI_CRM_CN_PO_Version__c  ){
                system.debug('Now HistoricalVECEstimateTotal : '+HistoricalVECEstimateTotal);
                system.debug('Now ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c  : '+ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c);
                decimal Difference= HistoricalVECEstimateTotal-ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c;
                Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF'); 
                Id subbrand999 = [SELECT Id FROM ASI_MFM_Sub_brand__c WHERE ASI_MFM_Active_for_CRM__c = true  AND ASI_MFM_Sub_brand_Code__c = '999'  AND 
                                  recordtypeid = :Global_RecordTypeCache.getRTid('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand') LIMIT 1].id;
                
                if(HaveVEC999Line && VEC999LineId !=NULL){
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFAjustmentLine = new ASI_CRM_CN_Contract_BRSF_Line_Item__c(Id=VEC999LineId,ASI_CRM_CN_Contract__c=ContractSelected.Id,
                                                                                                                        ASI_CRM_CN_Est_Total_Dummy__c=0-Difference);
                    
                    UpsertBRSFList.add(BRSFAjustmentLine);
                }else{ // New 
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFAjustmentLine = new ASI_CRM_CN_Contract_BRSF_Line_Item__c(
                        ASI_CRM_CN_Contract__c=ContractSelected.Id, ASI_CRM_Type__c='Variable Event Cost',
                        recordTypeId=BRSFLineRtId, ASI_CRM_CN_Sub_Brand__c = subbrand999,ASI_CRM_Volume_Base__c='999-AdjustmentLine',
                        ASI_CRM_CN_Est_Monthly_Qty__c = 0,ASI_CRM_Adjustment_Line__c=true,
                        ASI_CRM_Contract_Total_QTY_CR12_Eqv__c=0,
                        ASI_CRM_Est_Total_QTY_CR12_Eqv__c=0,
                        ASI_CRM_CN_Contract_Monthly_Qty__c=0,ASI_CRM_Module__c=VECModule.Id,
                        ASI_CRM_CN_Est_Total_Dummy__c=0-Difference,
                        ASI_CRM_CN_Contract_Total_Dummy__c=0,
                        ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0,
                        ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0);
                    UpsertBRSFList.add(BRSFAjustmentLine);//
                }
                
            }

            
            try{
                
                     
                //Previous Version PSF Est. Total +Adjustment=Expected PSF Est. Total
                if(ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && ContractSelected.ASI_CRM_CN_Expected_PSF_Est_Total__c !=null && ContractSelected.ASI_CRM_Previous_Version_PSF_Est_Total__c!=null ){
                    ContractSelected.ASI_CRM_PSF_Estimate_Adjustment_Amount__c = ContractSelected.ASI_CRM_CN_Expected_PSF_Est_Total__c - ContractSelected.ASI_CRM_Previous_Version_PSF_Est_Total__c; 
                }
                //system.assertEquals(123456789, ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c);
                //system.debug('NowNowNowNowNowNow'+ ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c );
                update ContractSelected;
                
                
                if(ModuleDeleteList.size()>0){
                    DeleteTarget = Database.delete(ModuleDeleteList);
                    ModuleDeleteList.clear();
                }
                if(BRSFDeleteList.size()>0){
                    DeleteTarget = Database.delete(BRSFDeleteList);
                    BRSFDeleteList.clear();
                }
                if(LFixCost.size()>0){  //Upsert Fix Cost Line 
                    UpsertTarget = Database.upsert(LFixCost);
                }
                
                
                if(UpsertBRSFList.size()>0){//Upsert Contract Line 
                    UpsertTarget = Database.upsert(UpsertBRSFList);

                   
                }
                
                if(Save_CoveredOutlet_Item != null && Save_CoveredOutlet_Item.size() > 0){
                    upsert Save_CoveredOutlet_Item;
                }
                if(Saved_CoveredOutlet_Temp!= null && Saved_CoveredOutlet_Temp.size() > 0){
                    delete Saved_CoveredOutlet_Temp;    
                }
                //update ContractSelected;
                
                if (!isQuickSave){
                    pageRef = new PageReference('/'+PageId);
                    pageRef.setRedirect(true);
                }else{
                    if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
                        pageRef = new PageReference('/apex/ASI_CRM_CN_EditHeavyContractDetailPage?id='+PageId);
                        pageRef.setRedirect(true);
                    }else{
                        pageRef = new PageReference('/apex/ASI_CRM_CN_Heavy_POModiEditPage?id='+PageId);
                        pageRef.setRedirect(true);
                    }
                    
                }
                
                
            }catch(Exception e){
                msg += 'Save Error : ' +e.getMessage() + '</br>';
                pageRef = null;
                Database.rollback(pSavepoint);      
                UpsertPermission = false;
                return null;
            }
        }        
        return pageRef; 
    }
    
    
    
    
    
    
    public void CoveredOutletValdationChecking(List<ASI_CRM_CN_Covered_Outlet__c> Save_CoveredOutlet_Item){
        Set<Id> effectiveChildsSet = new Set<Id>();
        Boolean isAllCustomer = False;
        Set<Id> invalidChilds = new Set<Id>();
        
        
        if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName == 'ASI_CRM_CN_WS'){
            for(ASI_CRM_Effective_supplier__c obj : [SELECT id, ASI_CRM_Supplier__c , ASI_CRM_Account__c FROM ASI_CRM_Effective_supplier__c  WHERE ASI_CRM_Supplier__c = : ContractSelected.ASI_CRM_CN_Outlet_WS__c]){
                effectiveChildsSet.add(obj.ASI_CRM_Account__c);
            }
        }else if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName == 'ASI_CRM_Outlet_CN'){
            isAllCustomer = ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c != Null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name.toLowerCase().contains('all customer');
            
            if(!isAllCustomer){
                for(ASI_CRM_AccountsAdditionalField__c obj : [SELECT id FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_CN_Parent_Outlet__c = : ContractSelected.ASI_CRM_CN_Outlet_WS__c  ]){
                    effectiveChildsSet.add(obj.id);
                }
                for(ASI_CRM_AccountsAdditionalField__c obj : [SELECT id FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_CN_Parent_Outlet__c IN : effectiveChildsSet ]){
                    effectiveChildsSet.add(obj.id);
                }
            }
        }
        
        double totalSuggestedAmount = 0;
        for(ASI_CRM_CN_Covered_Outlet__c obj : Save_CoveredOutlet_Item) {
            if(obj.ASI_CRM_CN_Suggested_Amount__c != null){
                totalSuggestedAmount += obj.ASI_CRM_CN_Suggested_Amount__c;
            }
            if(!effectiveChildsSet.contains(obj.ASI_CRM_CN_Outlet__c)){
                invalidChilds.add(obj.ASI_CRM_CN_Outlet__c);
            }
        }
        
        
        if(invalidChilds.size() > 0 && !isAllCustomer){ String errorMsg = ContractSelected.ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName == 'ASI_CRM_CN_WS' ? 'This wholesaler is not effective supplier of below outlets and thus they can\'t be cover outlet : ' : 'This Outlet is not effective parent of below outlets and thus they can\'t be cover outlet : ';
            String errorMsgCN = ContractSelected.ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName == 'ASI_CRM_CN_WS' ? '该经销商并非以下店家的有效供货商，因此不能被添加为覆盖店家 ： ' : '该母店家并非以下店家的有效供货商，因此不能被添加为覆盖店家 ： ';
            for(ASI_CRM_AccountsAdditionalField__c obj : [SELECT id , Name   FROM ASI_CRM_AccountsAdditionalField__c WHERE Id IN : invalidChilds   ]){
                errorMsg += obj.Name + ',';
                errorMsgCN += obj.Name + ',';
            }
            errorMsg += ' If it is necessary to be covered, Please contact Admin';
            errorMsgCN += ContractSelected.ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName == 'ASI_CRM_CN_WS' ? ' 若此覆盖店家与供货商暂无展开合作，但确认需加入，请和Admin联系' : ' 如确认需加入，请和Admin联系';
            
            if(USerInfo.getLanguage()=='zh_CN')
                ErrorHandling(errorMsgCN);
            else
                ErrorHandling(errorMsg);
            
        }
        
        if(ValidateTotalSuggestedAmount){
            if(totalEstimate!=totalSuggestedAmount){//
                ErrorHandling(Label.ASI_CRM_CN_Total_amount_No_equal_PO_est_amount);//'Total suggested amount should equal to total PO est. amount.'
            }
        }
    }
    
    
    
    //******************************Validation Rule for Module****************************************
    public void ModuleChecking(){ // ASI_CRM_Volume_Base__c
        //BRSF
        Boolean BRSFHighPriority = false;
        if(MethodologyMap.containsKey('BRSF'+BRSFItemMap.MethodologyValue)){
            if(MethodologyMap.get('BRSF'+BRSFItemMap.MethodologyValue).ASI_CRM_Sequence__c <BRSFMethodology_Default.ASI_CRM_Sequence__c){
                BRSFHighPriority=true;
            }
        }
        if(!BRSFHighPriority && BRSFItemMap.MethodologyValue !=BRSFDefaultMethodology  && CheckRemarkInput(BRSFItemMap.Module.ASI_CRM_Remark__c,BRSFItemMap.Module.ASI_CRM_Remark_Options__c) ){
            //'Please fill in Reason for not choosing Default Methodology in BRSF.'   String.isEmpty(BRSFItemMap.Module.ASI_CRM_Remark__c) && String.isEmpty(BRSFItemMap.Module.ASI_CRM_Remark_Options__c)
            ErrorHandling(Label.ASI_CRM_CN_Reason_for_not_choosing_Default_Methodology_BRSF);
        }
        
        Boolean VECHighPriority = false;
        //VEC
        if(MethodologyMap.containsKey('Variable Event Cost'+VariableEventCost.MethodologyValue)){
            if(MethodologyMap.get('Variable Event Cost'+VariableEventCost.MethodologyValue).ASI_CRM_Sequence__c <VECMethodology_Default.ASI_CRM_Sequence__c){
                VECHighPriority=true;
            }
        }
        if(!VECHighPriority && VariableEventCost.MethodologyValue !=VECDefaultMethodology  && CheckRemarkInput(VariableEventCost.Module.ASI_CRM_Remark__c,VariableEventCost.Module.ASI_CRM_Remark_Options__c) ){
            ErrorHandling(Label.ASI_CRM_CN_Reason_for_not_choosing_Default_Methodology_VEC);//'Please fill in Reason for not choosing Default Methodology in Remark Field in Variable Event Cost. '
        }//&& String.isEmpty(VariableEventCost.Module.ASI_CRM_Remark__c) && String.isEmpty(VariableEventCost.Module.ASI_CRM_Remark_Options__c)
        /*if(VariableEventCost.Module.ASI_CRM_Volume_Base__c !='By Total' && VariableEventCost.Module.ASI_CRM_Volume_Base__c !='By Grade'  && String.isEmpty(VariableEventCost.Module.ASI_CRM_Remark__c) ){
            ErrorHandling(Label.ASI_CRM_CN_Reason_for_not_choosing_Default_Vol_Base_VEC);//'Please fill in Reason for not choosing Default Volume Base in Remark Field in Variable Event Cost. '
        }*/
        
        
        boolean PSFMethodologyValueError =false;
        Integer coun=1;
        for(String key:PSF_Item_Map.keySet()){
            Boolean PSFHighPriority = false;
            if(MethodologyMap.containsKey('PSF'+PSF_Item_Map.get(key).MethodologyValue)){
                if(MethodologyMap.get('PSF'+PSF_Item_Map.get(key).MethodologyValue).ASI_CRM_Sequence__c <PSFMethodology_Default.ASI_CRM_Sequence__c){// 1<2
                    PSFHighPriority=true;
                }
            }
            if(!PSFHighPriority && PSF_Item_Map.get(key).MethodologyValue != PSFDefaultMethodology  && CheckRemarkInput(PSF_Item_Map.get(key).Module.ASI_CRM_Remark__c,PSF_Item_Map.get(key).Module.ASI_CRM_Remark_Options__c) ){
                ErrorHandling(Label.ASI_CRM_CN_Reason_for_not_choosing_Default_Methodology_PSF+'('+PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c+')  ');
            }
            if( PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c !='By Sub-Brand' && PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c !='By Grade' && CheckRemarkInput(PSF_Item_Map.get(key).Module.ASI_CRM_Remark__c,PSF_Item_Map.get(key).Module.ASI_CRM_Remark_Options__c)  ){
                ErrorHandling(Label.ASI_CRM_CN_Reason_for_not_choosing_Default_Volume_Base_PSF+'('+PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c+')  ');// Please fill in Reason for not choosing Default Volume Base in Remark Field in PSF Module
                
            }
            coun++;
        }
        
    }    
    
    
    
    private Boolean CheckRemarkInput(String InputRemark, string RemarkOption){ //&&  String.isEmpty(PSF_Item_Map.get(key).Module.ASI_CRM_Remark__c) && String.isEmpty(PSF_Item_Map.get(key).Module.ASI_CRM_Remark_Options__c)  
        Boolean ReturnFlag=false;
        if(String.isEmpty(InputRemark) && String.isEmpty(RemarkOption) ){
            ReturnFlag=true;
        }else if(String.isEmpty(InputRemark) && !String.isEmpty(RemarkOption) && RemarkOption == '其他' ){
            ReturnFlag=true;
        }            
        return ReturnFlag;
    }
    
    //*********************************************************
    //@description:Generate Sub-Brand Grade incentive By Sub-Brand Grade Map
    //@param: 
    //@return:incentive
    // *********************************************************
    public Decimal GeneratingIncentive(Map<String, ASI_CRM_Sub_Brand_Grade__c> SBGradeMap ,String SubBrandGradeName,String TypeName){
        
        
        Decimal Incentive=0.0;
        String ExternalKey=SubBrandGradeName;
        
        ExternalKey+= ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c!=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c:'';
        ExternalKey+= ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null? ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
        
        String CityTierExternalKey = ExternalKey;
        if(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c!=null && ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c !=null){
            CityTierExternalKey+= ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(ContractSelected.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c) ;
        }
        
        if(TypeName =='BRSFDefault'){
            if(SBGradeMap.containsKey(CityTierExternalKey)){
                Incentive=SBGradeMap.get(CityTierExternalKey).ASI_CRM_CN_Incentive__c;
            }else if(SBGradeMap.containsKey(ExternalKey)){
                Incentive=SBGradeMap.get(ExternalKey).ASI_CRM_CN_Incentive__c;
            }else if(SBGradeMap.containsKey(SubBrandGradeName)){
                Incentive=SBGradeMap.get(SubBrandGradeName).ASI_CRM_CN_Incentive__c;
            }            
        }
        
        
        
        if(TypeName =='BRSFMax'){
            if(SBGradeMap.containsKey(CityTierExternalKey)){
                Incentive=SBGradeMap.get(CityTierExternalKey).ASI_CRM_Max_Incentive__c;
            }else if(SBGradeMap.containsKey(ExternalKey)){
                Incentive=SBGradeMap.get(ExternalKey).ASI_CRM_Max_Incentive__c;
            }else if(SBGradeMap.containsKey(SubBrandGradeName)){
                Incentive=SBGradeMap.get(SubBrandGradeName).ASI_CRM_Max_Incentive__c;
            }            
        }
        
        if(TypeName =='PSFMax'){
            if(SBGradeMap.containsKey(CityTierExternalKey)){
                Incentive=SBGradeMap.get(CityTierExternalKey).ASI_CRM_Max_Incentive_for_PSF__c;
            }else if(SBGradeMap.containsKey(ExternalKey)){
                Incentive=SBGradeMap.get(ExternalKey).ASI_CRM_Max_Incentive_for_PSF__c;
            }else if(SBGradeMap.containsKey(SubBrandGradeName)){
                Incentive=SBGradeMap.get(SubBrandGradeName).ASI_CRM_Max_Incentive_for_PSF__c;
            }
        }
        
        
        if(Incentive==null){
            Incentive=0;
        }
        return Incentive;
    }
    
    
    
    public List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>  GenContractLine( ASI_CRM_Module__c BRSFModule,ASI_CRM_Module__c VECModule,Map<String,ASI_CRM_Module__c> PSFModuleMap){
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>  ReturnList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
            ContractSelected.ASI_CRM_Expected_V0_PSF_Estimated_Total__c=0;
            ContractSelected.ASI_CRM_CN_Expected_PSF_Est_Total__c=0;
            ContractSelected.ASI_CRM_V0_PSF_Contract_Total__c=0;
            ContractSelected.ASI_CRM_Expected_V0_BRSF_Estimated_Total__c=0;
            ContractSelected.ASI_CRM_Expected_V0_0_VEC_Est_Total__c=0;
        }
        
        if(VariableEventCost.Module.ASI_CRM_Created_PO_Version__c==ContractSelected.ASI_CRM_CN_PO_Version__c){
            ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c=0 ;
        }
        
        //Looping BRSF
        for(String key:BRSFItemMap.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =BRSFItemMap.DetailLineMap.get(key);
            if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
                ContractSelected.ASI_CRM_Expected_V0_BRSF_Estimated_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                
            }
        }
        
        //Looping PSF
        for(String key:PSF_Item_Map.keySet()){
            for(String keyline:PSF_Item_Map.get(key).DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =PSF_Item_Map.get(key).DetailLineMap.get(keyline);
                if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
                    ContractSelected.ASI_CRM_Expected_V0_PSF_Estimated_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    ContractSelected.ASI_CRM_CN_Expected_PSF_Est_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    ContractSelected.ASI_CRM_V0_PSF_Contract_Total__c += ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                }
            }
        }
        
        for(String key:VariableEventCost.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =VariableEventCost.DetailLineMap.get(key);
            if(ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'){
                ContractSelected.ASI_CRM_Expected_V0_0_VEC_Est_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
            }
            if(VariableEventCost.Module.ASI_CRM_Created_PO_Version__c==ContractSelected.ASI_CRM_CN_PO_Version__c){
               //system.assertEquals(23232, ContractLine.ASI_CRM_CN_Est_Total_Dummy__c );
                system.debug('Enter Calculate EVC_Cost_Estimate_Total '+ContractLine.ASI_CRM_CN_Est_Total_Dummy__c );
                ContractSelected.ASI_CRM_EVC_Cost_Estimate_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
            }
        }
        
        
        return ReturnList;
    }    
    
    
    
    // **********Valdation Checking************
    public List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>  ValdationChecking( ASI_CRM_Module__c BRSFModule,ASI_CRM_Module__c VECModule,Map<String,ASI_CRM_Module__c> PSFModuleMap){
        Integer coun=1;
        String PSFBySuBrandModuleId= '';
        // Looping the fix cost
        for(ASI_CRM_Contract_Cost__c FixCost: LFixCost){
            if(FixCost.ASI_CRM_CN_Contract_Amount__c==null){
                FixCost.ASI_CRM_CN_Contract_Amount__c=0;
            }
            if(FixCost.ASI_CRM_CN_Estimate_Amount__c== null){
                FixCost.ASI_CRM_CN_Estimate_Amount__c=0;
            }else{
                totalEstimate+= FixCost.ASI_CRM_CN_Estimate_Amount__c;
            }
        }
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>  ReturnList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        
        //BRSF Sub-Brand Id Set 
        Set<Id> BRSFSubBrandIdSet= new Set<Id> (); //Decimal BRSFContractVol=0; // calculate BRSF Contract Vol//Decimal BRSFEstimateVol=0;// calculate BRSF Estimate 
        
        //Sub-Brand Id,Vol
        Map<String,Decimal> BRSFContractVolMap= new Map<String,Decimal>();
        Map<String,Decimal> BRSFEstimateVolMap= new Map<String,Decimal>();
       
        Map<String,Decimal> VECContractVolMap= new Map<String,Decimal>();
        Map<String,Decimal> VECEstimateVolMap= new Map<String,Decimal>();
        
        
        //Grade or Category Id// Vol
        Map<String,Decimal> BRSFGradeContractVolMap= new Map<String,Decimal>();
        Map<String,Decimal> BRSFGradeEstimateVolMap= new Map<String,Decimal>();
        Map<String,Decimal> BRSFCategoryContractVolMap= new Map<String,Decimal>();
        Map<String,Decimal> BRSFCategoryEstimateVolMap= new Map<String,Decimal>();
        Decimal BRSFContractVolume=0;
        Decimal BRSFEstimateVolume=0;
        
        Set<Id> SubBrandIdSet= new Set<Id> ();
        //First time looping getting all subBrand Id Set
        for(String key:BRSFItemMap.DetailLineMap.keySet()){
            ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine =BRSFItemMap.DetailLineMap.get(key);
            if(BRSFLine.ASI_CRM_CN_Sub_Brand__c != null){
                SubBrandIdSet.add(BRSFLine.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        
        Integer PSFSBAppearTime=0;
        for(String key:PSF_Item_Map.keySet()){
            
            String AdjustmentLineKey='';
            Decimal TotalAdjustmentAmount= 0;
            if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                //PSFSBAppearTime++;
                PSFBySuBrandModuleId =key;
                //key is the module Id, keyline is the Line Id,
                coun=1;
                //Checking Null Value
                for(String keyline:PSF_Item_Map.get(key).DetailLineMap.keySet()){
                    if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Sub_Brand__c!=null){
                        SubBrandIdSet.add(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Sub_Brand__c);
                    }
                    if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_Monthly_Qty__c==null){ //'Please Input Contract Monthly QTY (Std. Bottle) in Line '+ String.valueOf(coun) +' in PSF By Sub-Brand Module. '
                        String tempStr = Label.ASI_CRM_CN_PSF_Contract_Monthly_QTY_Validation;
                        List<String> fillers = new String[] {String.valueOf(coun) ,''};
                        ErrorHandling(String.format(tempStr,fillers));
                    }
                    if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Monthly_Qty__c==null){
                        String tempStr = Label.ASI_CRM_CN_PSF_Estimate_Monthly_QTY_Validation;
                        List<String> fillers = new String[] {String.valueOf(coun) ,''};
                        ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('Please Input Estimate Monthly QTY (Std. Bottle) in Line '+ String.valueOf(coun)+' in PSF By Sub-Brand Module. '); 
                    }
                    if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Contract_BRSF_Per_Bottle__c==null){
                        String tempStr = Label.ASI_CRM_CN_VEC_Contract_Monthly_QTY_Validation;
                        List<String> fillers = new String[] {String.valueOf(coun) ,''};
                            ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('Please Input Contract VEC (Per Bottle) in Line '+ String.valueOf(coun) +' in PSF By Sub-Brand Module. ');
                    }
                    coun++;
                    
                    
                    //Calculate 999-Line again when in saving records
                    if(PSF_Item_Map.get(key).Module.ASI_CRM_Created_PO_Version__c==ContractSelected.ASI_CRM_CN_PO_Version__c  && ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0' && PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Monthly_Qty__c!=null && PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_BRSF_Per_Bottle__c !=null){
                        if(PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_Adjustment_Line__c){
                            AdjustmentLineKey=keyline;
                        }else{
                            TotalAdjustmentAmount+= DiffMonth* PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_BRSF_Per_Bottle__c * PSF_Item_Map.get(key).DetailLineMap.get(keyline).ASI_CRM_CN_Est_Monthly_Qty__c;   
                        }
                    }
                }
                
                if(AdjustmentLineKey !='' && TotalAdjustmentAmount !=0 && ContractSelected.ASI_CRM_CN_PO_Version__c !='0.0'){
                    PSF_Item_Map.get(key).DetailLineMap.get(AdjustmentLineKey).ASI_CRM_CN_Est_Total_Dummy__c= TotalAdjustmentAmount;
                }
                
                
            }
        }
        
        if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
            coun=1;
            for(String key:VariableEventCost.DetailLineMap.keySet()){
                if(VariableEventCost.DetailLineMap.get(key).ASI_CRM_CN_Sub_Brand__c!=null){
                    SubBrandIdSet.add(VariableEventCost.DetailLineMap.get(key).ASI_CRM_CN_Sub_Brand__c);
                }
                 if(VariableEventCost.DetailLineMap.get(key).ASI_CRM_CN_Contract_Monthly_Qty__c==null){ 
                    ErrorHandling('Please Input Variable Event Cost Contract Monthly QTY (Std. Bottle) in line'+ String.valueOf(coun)   +'请输入活动赞助成本合同销量');
                }
                if(VariableEventCost.DetailLineMap.get(key).ASI_CRM_CN_Est_Monthly_Qty__c==null){
                    ErrorHandling('Please Input Variable Event Cost Est Monthly QTY (Std. Bottle) in line'+ String.valueOf(coun)  +'请输入活动赞助成本预计销量' );
                }
                coun++;
            }
        }
        
        
        
        Map<String,ASI_MFM_Sub_brand__c> SubBrandMap= new Map<String,ASI_MFM_Sub_brand__c> ([select Id,Name,ASI_CRM_CN_Sub_brand_Grade__r.Name,
                                                                                             ASI_MFM_Brand__c,ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__c,
                                                                                             ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__c,
                                                                                             ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__r.ASI_HK_CRM_Sequence__c,
                                                                                             ASI_CRM_CN_Sub_brand_Grade__c from ASI_MFM_Sub_brand__c where Id in: SubBrandIdSet]);        
        
        if(UpsertPermission){
            //*************************Looping the BRSF*************************
            coun=1;
            Boolean HaveBRSF999Line=false;
            String BRSF999LineId='';
            for(String key:BRSFItemMap.DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine =BRSFItemMap.DetailLineMap.get(key);
               
                
                if(BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c==null){
                    BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c=0;
                }
                totalEstimate += BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                
                if(BRSFLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c==null || BRSFLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c==0){
                    BRSFLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0;
                    BRSFLine.ASI_CRM_CN_Contract_Total_Dummy__c=0;
                    BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c=0;
                }
                
                if(BRSFLine.ASI_CRM_CN_Sub_Brand__c == null){
                    ErrorHandling(Label.ASI_CRM_CN_Sub_Brand_in_BRSF_Validation+ String.valueOf(coun));//Please Input Sub-Brand in BRSF in line.
                }else{
                    BRSFSubBrandIdSet.add(BRSFLine.ASI_CRM_CN_Sub_Brand__c); 
                    if(!BRSFContractVolMap.containsKey(BRSFLine.ASI_CRM_CN_Sub_Brand__c) && BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                        BRSFContractVolMap.put(BRSFLine.ASI_CRM_CN_Sub_Brand__c, BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c);
                    }else if(BRSFContractVolMap.containsKey(BRSFLine.ASI_CRM_CN_Sub_Brand__c)){
                        if(SubBrandMap.containsKey(BRSFLine.ASI_CRM_CN_Sub_Brand__c)){
                            ErrorHandling(Label.ASI_CRM_CN_Duplicate_Sub_brand_BRSF + SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).Name);//'Please found the duplicated in BRSF in Sub-Brand : '
                        }else{
                            ErrorHandling(Label.ASI_CRM_CN_Duplicate_Sub_brand_BRSF+ String.valueOf(coun));//'Please found the duplicated in BRSF in Sub-Brand '
                        }
                    }
                    if(!BRSFEstimateVolMap.containsKey(BRSFLine.ASI_CRM_CN_Sub_Brand__c) && BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null ){
                        BRSFEstimateVolMap.put(BRSFLine.ASI_CRM_CN_Sub_Brand__c, BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c);
                    }
                    If(SubBrandMap.containsKey(BRSFLine.ASI_CRM_CN_Sub_Brand__c) && BRSFLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null ){
                        BRSFLine.ASI_CRM_Max_Incentive__c = GeneratingIncentive(SubBrandGradeMap,SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name,'BRSFMax');
                        if(BRSFLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c >BRSFLine.ASI_CRM_Max_Incentive__c ){
                            String tempStr = LabeL.ASI_CRM_CN_BRSF_over_max_incentive+'<br/>';//'We found the {0} in PSF over the max incentive.';
                            List<String> fillers = new String[] {SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).Name,''};
                            WarningMsg+=String.format(tempStr,fillers);//'We found the ' + +' in BRSF over the max incentive.<br/>';
                            ShowWarning=true;
                        }
                    }
                    //Calculate BRSF Volume Map
                     If(SubBrandMap.containsKey(BRSFLine.ASI_CRM_CN_Sub_Brand__c) && BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                         if(SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c!=null){
                             String MapKeyStr=SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__c;
                             if(BRSFGradeContractVolMap.containsKey(MapKeyStr)){
                                 Decimal BRSFVolumes = BRSFGradeContractVolMap.get(MapKeyStr)+BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c;
                                 BRSFGradeContractVolMap.remove(MapKeyStr);
                                 BRSFGradeContractVolMap.put(MapKeyStr,BRSFVolumes);
                             }else{
                                 BRSFGradeContractVolMap.put(MapKeyStr, BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c);
                             }
                             
                             if(BRSFGradeEstimateVolMap.containsKey(MapKeyStr)){
                                 Decimal BRSFVolumes = BRSFGradeEstimateVolMap.get(MapKeyStr)+BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c;
                                 BRSFGradeEstimateVolMap.remove(MapKeyStr);
                                 BRSFGradeEstimateVolMap.put(MapKeyStr,BRSFVolumes);
                             }else{
                                 BRSFGradeEstimateVolMap.put(MapKeyStr, BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c);
                             } 
                         }
                         
                         if(SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__c!=null 
                            && SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__c!=null
                            && SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__c!=null)
                         {
                             String MapKeyStr= SubBrandMap.get(BRSFLine.ASI_CRM_CN_Sub_Brand__c).ASI_MFM_Brand__r.ASI_TH_CRM_Sub_category__r.ASI_CRM_CN_Product_Category__c; 
                             if(BRSFCategoryContractVolMap.containsKey(MapKeyStr)){
                                 Decimal BRSFVolumes = BRSFCategoryContractVolMap.get(MapKeyStr)+BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c;
                                 BRSFCategoryContractVolMap.remove(MapKeyStr);
                                 BRSFCategoryContractVolMap.put(MapKeyStr,BRSFVolumes);
                             }else{
                                 BRSFCategoryContractVolMap.put(MapKeyStr, BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c);
                             }
                             
                             if(BRSFCategoryEstimateVolMap.containsKey(MapKeyStr)){
                                 Decimal BRSFVolumes = BRSFCategoryEstimateVolMap.get(MapKeyStr)+BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c;
                                 BRSFCategoryEstimateVolMap.remove(MapKeyStr);
                                 BRSFCategoryEstimateVolMap.put(MapKeyStr,BRSFVolumes);
                             }else{
                                 BRSFCategoryEstimateVolMap.put(MapKeyStr, BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c);
                             }
                         }
                     }
                }
                
                if(BRSFModule!=null){
                    BRSFLine.ASI_CRM_Module__c=BRSFModule.Id;
                }
                if(BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c==null){//'Please Input BRSF Contract Monthly QTY (Std. Bottle) in line ' 
                    ErrorHandling(Label.ASI_CRM_CN_BRSF_Contract_Monthly_QTY_Validation+ String.valueOf(coun));
                }
                if(BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c==null){
                    ErrorHandling(Label.ASI_CRM_CN_BRSF_Estimate_Monthly_QTY_Validation+ String.valueOf(coun));//'Please Input BRSF Estimate Monthly QTY (Std. Bottle) in line '
                }
                
                
                BRSFContractVolume+= BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?BRSFLine.ASI_CRM_CN_Contract_Monthly_Qty__c:0;
                BRSFEstimateVolume+= BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?BRSFLine.ASI_CRM_CN_Est_Monthly_Qty__c:0;
                
                 if(BRSFLine.ASI_CRM_CN_Sub_Brand__c!=null && BRSFLine.ASI_CRM_Adjustment_Line__c){
                    HaveBRSF999Line=true;
                    BRSF999LineId = BRSFLine.Id;
                }else if(UpsertPermission){
                    ReturnList.add(SetAmountToZero(BRSFLine));
                }
                coun++; 
                
            }
            
             if(ContractSelected.ASI_CRM_CN_PO_Version__c!='0.0' &&  HistoricalBRSFEstimateTotal != ContractSelected.ASI_CRM_CN_Expected_BRSF_Est_Total__c){
                 system.debug('HistoricalBRSFEstimateTotal : '+ HistoricalBRSFEstimateTotal );
                 
                 decimal Difference= HistoricalBRSFEstimateTotal-ContractSelected.ASI_CRM_CN_Expected_BRSF_Est_Total__c;
                 Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF'); 
                 Id subbrand999 = [SELECT Id FROM ASI_MFM_Sub_brand__c WHERE ASI_MFM_Active_for_CRM__c = true  AND ASI_MFM_Sub_brand_Code__c = '999'  AND recordtypeid = :Global_RecordTypeCache.getRTid('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand') LIMIT 1].id;
                 if(HaveBRSF999Line && BRSF999LineId !=NULL){
                     ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFAjustmentLine = new ASI_CRM_CN_Contract_BRSF_Line_Item__c(Id=BRSF999LineId,ASI_CRM_CN_Contract__c=ContractSelected.Id,
                                                                                                                            ASI_CRM_CN_Est_Total_Dummy__c=0-Difference);
                    ReturnList.add(BRSFAjustmentLine); 
                 }else{ // New
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFAjustmentLine = new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=ContractSelected.Id, 
                                                                                                                        ASI_CRM_Type__c='BRSF', ASI_CRM_CN_Activity_Code__c=BRSFActivityCodeId,
                                                                                                                        recordTypeId=BRSFLineRtId,ASI_CRM_Adjustment_Line__c=true,
                                                                                                                        ASI_CRM_CN_Sub_Brand__c = subbrand999, 
                                                                                                                        ASI_CRM_CN_Est_Monthly_Qty__c = 0, ASI_CRM_Module__c=BRSFModule.ID,
                                                                                                                        ASI_CRM_CN_Contract_Monthly_Qty__c=0,
                                                                                                                        ASI_CRM_CN_Est_Total_Dummy__c=0-Difference,
                                                                                                                        ASI_CRM_CN_Contract_Total_Dummy__c=0, ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0, 
                                                                                                                        ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0);
                    ReturnList.add(BRSFAjustmentLine);
                 }
             }
            
            
            
            
            
            //*************************************Looping the PSF*************************************
            coun=1;
            Boolean HasPSFBySuBrand= false;
            
            for(String key:PSF_Item_Map.keySet()){
                //key is the module Id, keyline is the Line Id,
                if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                    PSFBySuBrandModuleId =key;
                }
                integer LineCount=1;
                if(PSF_Item_Map.get(key).DetailLineMap.size()==0 && !IsGroupContract){
                    String tempStr = Label.ASI_CRM_CN_No_line_in_PSF_Module; // 我们发现PSF中的项目指标1，您没有输入细节。请再次刷新或者删掉此请再次刷新或者删掉此项目指标。
                    List<String> fillers = new String[] {String.valueOf(coun) ,''};//ErrorHandling(Label.ASI_CRM_CN_BRSF_Contract_Monthly_QTY_Validation+String.valueOf(coun)+'. Please click refresh or delete this module.' );
                        ErrorHandling(String.format(tempStr,fillers));
                    
                }//'We found that there is no line in PSF Module '+
                Map<String,Decimal> PSFContractVolMap= new Map<String,Decimal>();
                Map<String,Decimal> PSFEstimateVolMap= new Map<String,Decimal>();
                
                //Looping every Module 
                for(String keyline:PSF_Item_Map.get(key).DetailLineMap.keySet()){
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =PSF_Item_Map.get(key).DetailLineMap.get(keyline);
                    
                    if(PSFModuleMap.containsKey(key)){// system.debug('Enter ass module !');
                        ContractLine.ASI_CRM_Module__c=PSFModuleMap.get(key).Id;
                        ContractLine.ASI_CRM_CN_Activity_Code__c=PSFActivityCodeId;
                    }
                    if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){// by sub-Brand checking
                        HasPSFBySuBrand=true;
                        if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){
                            if(!BRSFSubBrandIdSet.contains(ContractLine.ASI_CRM_CN_Sub_Brand__c) && !ContractLine.ASI_CRM_Adjustment_Line__c){
                                String tempStr = Label.ASI_CRM_CN_PSF_Sub_Brand_Validation;
                                List<String> fillers = new String[] {String.valueOf(LineCount),String.valueOf(coun)};
                                    ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('We found that the Sub-Brand dont not exist in BRSF in line of '+String.valueOf(LineCount) +' in PSF Module '+String.valueOf(coun) );
                            } 
                            
                            if(!PSFContractVolMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                                PSFContractVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c);
                            }else if(BRSFContractVolMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                                Decimal TempVol=BRSFContractVolMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+  ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c;
                                PSFContractVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c,TempVol);//ErrorHandling('Please found the duplicated Sub-Brand '+ String.valueOf(coun));
                            }
                            
                            if(!PSFEstimateVolMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null ){
                                PSFEstimateVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c);
                            }else{
                                Decimal TempVol=PSFEstimateVolMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+  ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c;
                                PSFEstimateVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c,TempVol);
                            }
                            
                            If(SubBrandMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null ){
                                ContractLine.ASI_CRM_Max_Incentive__c = GeneratingIncentive(SubBrandGradeMap,SubBrandMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c).ASI_CRM_CN_Sub_brand_Grade__r.Name,'PSFMax');
                                if(ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c >ContractLine.ASI_CRM_Max_Incentive__c ){
                                    String tempStr = Label.ASI_CRM_CN_PSF_over_max_incentive+'<br/>';
                                    List<String> fillers = new String[] {SubBrandMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c).Name ,''};  // ErrorHandling(String.format(tempStr,fillers));
                                   
                                        WarningMsg+=String.format(tempStr,fillers);//'We found the ' + SubBrandMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c).Name+' in PSF over the max incentive.<br/>';
                                    ShowWarning=true;
                                }
                            }
                            
                            
                        }else{
                            String tempStr = Label.ASI_CRM_CN_PSF_Sub_Brand_Null_Validation;
                            List<String> fillers = new String[] {String.valueOf(LineCount),String.valueOf(coun)};
                                ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('Please input Sub-Brand in line '+String.valueOf(LineCount) +' in PSF Module '+String.valueOf(coun) );
                        }
                        
                    }//Finished By Subbrand 
                    
                    
                    if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Grade'){
                        if(BRSFGradeContractVolMap.containsKey(ContractLine.ASI_CRM_Sub_Brand_Grade__c) && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'  ){
                            if(BRSFGradeContractVolMap.get(ContractLine.ASI_CRM_Sub_Brand_Grade__c)!=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c){
                                String tempStr = Label.ASI_CRM_CN_Contract_Monthly_Qty_BRSF_PSF_Not_Same;
                                List<String> fillers = new String[] {ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c,''};
                                    ErrorHandling(String.format(tempStr,fillers)+'(By Grade)');
                                //ErrorHandling('Please note that '+ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c+' of Contract Monthly Qty in BRSF and PSF(By Grade)  are not the same.');
                            }
                            
                        }
                        if(BRSFGradeEstimateVolMap.containsKey(ContractLine.ASI_CRM_Sub_Brand_Grade__c)){
                            if(BRSFGradeEstimateVolMap.get(ContractLine.ASI_CRM_Sub_Brand_Grade__c)!=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c){
                                String tempStr = Label.ASI_CRM_CN_Est_Monthly_Qty_BRSF_PSF_not_same;
                                List<String> fillers = new String[] {ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c,''};
                                    ErrorHandling(String.format(tempStr,fillers)+'(By Grade)');
                                //Please note that {0} of Contract Monthly Qty in BRSF and PSF are not the same.
                                //ErrorHandling('Please note that '+ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c+' of Estimate Monthly Qty in BRSF and PSF(By Grade) are not the same.');
                            }
                        }
                        
                    }
                    
                    if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Category' && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'    ){
                        if(BRSFCategoryContractVolMap.containsKey(ContractLine.ASI_CRM_Product_Category__c)  ){
                            if(BRSFCategoryContractVolMap.get(ContractLine.ASI_CRM_Product_Category__c)!=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c){//By Category Volume
                                ErrorHandling('Please note that '+BRSFCategoryContractVolMap.get(ContractLine.ASI_CRM_Product_Category__c) +' of Contract Monthly Qty in BRSF and PSF(By Category) are not the same. ');
                            }
                        }                        
                        if(BRSFCategoryEstimateVolMap.containsKey(ContractLine.ASI_CRM_Product_Category__c)){
                            if(BRSFCategoryEstimateVolMap.get(ContractLine.ASI_CRM_Product_Category__c)!=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c){
                                ErrorHandling('Please note that '+ContractLine.ASI_CRM_Product_Category_Name__c+' of Contract Monthly Qty in BRSF and PSF(By Category) are not the same.');
                            }
                        }
                    }
                    
                    if(PSF_Item_Map.get(key).Module.ASI_CRM_Volume_Base__c=='By Total' && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'   ){
                        if(math.abs(BRSFContractVolume-ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c)>0.1){
                            ErrorHandling(Label.ASI_CRM_CN_Contract_Vol_BRSF_PSF_No_Same);// 'Please note that Contract Volume in BRSF and PSF (by Total) are not the same,please refresh  PSF (by Total) again.'
                        }
                         if(math.abs(BRSFEstimateVolume-ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c)>0.1){
                            ErrorHandling(Label.ASI_CRM_CN_Est_Vol_BRSF_PSF_No_Same);  // 'Please note that Contract Estimate Volume in BRSF and PSF (by Total) are not the same,please refresh  PSF (by Total) again.'
                        }
                    }
                    
                    if(UpsertPermission){
                      
                        ReturnList.add(SetAmountToZero(ContractLine));
                    }
                    
                    LineCount++;
                }//End of looping PSF Line in each modolue
                
                
                for(String Key1:PSFContractVolMap.keySet()){
                    if(BRSFContractVolMap.containsKey(Key1)){
                        if(math.abs( BRSFContractVolMap.get(Key1) -PSFContractVolMap.get(Key1))>0.1){
                            String StringBrandName='';
                            if(SubBrandMap.containsKey(Key1)){
                                StringBrandName= SubBrandMap.get(Key1).Name;
                            }
                            String tempStr =Label.ASI_CRM_CN_PSF_Sub_Brand_Contract_QTY_Validation ;
                            List<String> fillers = new String[] {StringBrandName ,''};
                                ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('We found that the Sub Brand '+StringBrandName+' of Contract Monthly QTY (Std. Bottle) in PSF are not same with BRSF ');
                        }
                    }
                }
                for(String Key1:PSFEstimateVolMap.keySet()){
                    if(BRSFEstimateVolMap.containsKey(Key1)){
                        if(math.abs( BRSFEstimateVolMap.get(Key1) -PSFEstimateVolMap.get(Key1))>0.1){
                            String StringBrandName='';
                            if(SubBrandMap.containsKey(Key1)){
                                StringBrandName= SubBrandMap.get(Key1).Name;
                            }
                            String tempStr = Label.ASI_CRM_CN_PSF_Sub_Brand_Estimate_QTY_Validation;
                            List<String> fillers = new String[] {StringBrandName,''};//ErrorHandling('We found that the Sub Brand '+StringBrandName+' of  Estimate Monthly QTY (Std. Bottle) in PSF are not same with BRSF ');
                                ErrorHandling(String.format(tempStr,fillers));//ASI_CRM_CN_PSF_Sub_Brand_Estimate_QTY_Validation
                            
                        }
                    }
                }

                
                coun++;//looping module
            }
            
            
            
            if(ShowWarning){
                 WarningTimes++;
            }
            
            
            
            if(HasPSFBySuBrand){
                CalPSFAmount(PSFBySuBrandModuleId);
             
            }
            
            
            //********************************************Looping the VEC***********************************************
            coun=1;
            for(String key:VariableEventCost.DetailLineMap.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =new ASI_CRM_CN_Contract_BRSF_Line_Item__c();//boolean HasError=false;
                ContractLine=VariableEventCost.DetailLineMap.get(key);
                if(VECModule!=null){
                    ContractLine.ASI_CRM_Module__c=VECModule.Id;
                }
                
                if(VECActivityCodeId !=null && VECActivityCodeId!=''){
                    ContractLine.ASI_CRM_CN_Activity_Code__c=VECActivityCodeId;
                }
                
                if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){//By Sub-Brand Checking
                    
                    if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){
                        if(!VECContractVolMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                            VECContractVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c);
                        }else if(VECContractVolMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null ){
                            Decimal TempVol=VECContractVolMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+  ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c;
                            VECContractVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c,TempVol);
                        }
                        
                        if(!VECEstimateVolMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c) && ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null ){
                            VECEstimateVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c);
                        }else{
                            Decimal TempVol=VECEstimateVolMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+  ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c;
                            VECEstimateVolMap.put(ContractLine.ASI_CRM_CN_Sub_Brand__c,TempVol);
                        }
                        
                        if(!BRSFSubBrandIdSet.contains(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                            String tempStr = Label.ASI_CRM_CN_VEC_Sub_Brand_in_BRSF_Validation;
                            List<String> fillers = new String[] {String.valueOf(coun) ,''};
                                ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('We found that the Sub-Brand dont exist in BRSF in line '+String.valueOf(coun)+' in Variable Event Cost Module. ' ); //We found that the Sub-Brand dont exist in BRSF in line {0} in Variable Event Cost Module.﻿
                        }
                    }else{
                         String tempStr = Label.ASI_CRM_CN_VEC_Sub_Brand_in_BRSF_Validation;  //ErrorHandling('We found that the Sub-Brand dont exist in BRSF in line '+String.valueOf(coun)  );
                         List<String> fillers = new String[] {String.valueOf(coun) ,''};
                         ErrorHandling(String.format(tempStr,fillers));
                       
                    }
                }
                
                
                if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Grade' && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0' ){
                    if(BRSFGradeContractVolMap.containsKey(ContractLine.ASI_CRM_Sub_Brand_Grade__c)){
                        if(BRSFGradeContractVolMap.get(ContractLine.ASI_CRM_Sub_Brand_Grade__c)!=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c){
                            //Contract Monthly Qty BRSF VEC Not Same  
                            String tempStr = Label.ASI_CRM_CN_Contract_Monthly_Qty_BRSF_VEC_Not_Same;
                            List<String> fillers = new String[] {ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c ,''};
                                ErrorHandling(String.format(tempStr,fillers));//ErrorHandling('Please note that '+ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c+' of Contract Monthly Qty in BRSF and Variable Event Cost  are not the same.');
                        }
                        
                    }
                    if(BRSFGradeEstimateVolMap.containsKey(ContractLine.ASI_CRM_Sub_Brand_Grade__c)){
                        if(BRSFGradeEstimateVolMap.get(ContractLine.ASI_CRM_Sub_Brand_Grade__c)!=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c){ 
                            //Please note that {0} of Contract Monthly Qty in BRSF and PSF are not the same. ASI_CRM_Est_Monthly_Qty_BRSF_VEC_No_Same
                            String tempStr = Label.ASI_CRM_CN_Contract_Monthly_Qty_BRSF_VEC_Not_Same;
                            List<String> fillers = new String[] {ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c ,''};
                                ErrorHandling(String.format(tempStr,fillers));  //ErrorHandling('Please note that '+ContractLine.ASI_CRM_Sub_Brand_Grade_Name__c+' of Estimate Monthly Qty in BRSF and Variable Event Cost  are not the same.');
                        }
                    }
                }
                
                if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Category' && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0' ){
                    if(BRSFCategoryContractVolMap.containsKey(ContractLine.ASI_CRM_Product_Category__c) ){
                        if(BRSFCategoryContractVolMap.get(ContractLine.ASI_CRM_Product_Category__c)!=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c){
                            //Please note that  {0} of Contract Monthly Qty in BRSF and Variable Event Cost  are not the same.
                             ErrorHandling( 'Please note that '+ContractLine.ASI_CRM_Product_Category_Name__c+' of Contract Monthly Qty in BRSF and Variable Event Cost are not the same.');
                        }
                    }
                    
                     if(BRSFCategoryEstimateVolMap.containsKey(ContractLine.ASI_CRM_Product_Category__c) ){
                         if(BRSFCategoryEstimateVolMap.get(ContractLine.ASI_CRM_Product_Category__c)!=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c){
                             ErrorHandling('Please note that '+ContractLine.ASI_CRM_Product_Category_Name__c+' of Estimate Monthly Qty in BRSF and Variable Event Cost are not the same.');
                        }
                    }
                }
                
                if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Total' && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0'    ){
                    if(math.abs(BRSFContractVolume-ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c)>0.1  ){
                        ErrorHandling(Label.ASI_CRM_CN_Contract_Vol_BRSF_VEC_No_Same);//ErrorHandling('Please note that Contract Volume in BRSF and Variable Event Cost (by Total) are not the same,please refresh  PSF (by Total) again.');
                    }
                    if(math.abs(BRSFEstimateVolume-ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c)>0.1){
                        ErrorHandling(Label.ASI_CRM_CN_VEC_Contract_EsT_Vol_Not_Same_with_BRSF);//ErrorHandling('Please note that Contract Estimate Volume in BRSF and Variable Event Cost (by Total) are not the same,please refresh  PSF (by Total) again.');
                    }
                }
                
                system.debug(coun+'Now UpsertPermission VEC  :'+UpsertPermission);
                
                Boolean Allowput= true;
                if(ContractLine.Id!= null && VEC999LineId !=null && VEC999LineId!=''){
                    if(ContractLine.Id == VEC999LineId){
                        Allowput=false;
                    }
                }
                
                if(UpsertPermission && Allowput  ){
                   
                    ReturnList.add(SetAmountToZero(ContractLine));
                }
                
                coun++; 
                
            }// end of looping VEC 
            

            if(VariableEventCost.Module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                
                for(String Key:VECContractVolMap.keySet()){
                    if(BRSFContractVolMap.containsKey(Key)){
                        if(math.abs( BRSFContractVolMap.get(Key) -VECContractVolMap.get(Key))>0.1){
                            String StringBrandName='';
                            if(SubBrandMap.containsKey(Key)){
                                StringBrandName= SubBrandMap.get(Key).Name;
                            }
                            String tempStr = Label.ASI_CRM_CN_VEC_Sub_Brand_Contract_QTY_Validation;
                            List<String> fillers = new String[] {StringBrandName ,''};
                                ErrorHandling(String.format(tempStr,fillers));//We found that the Sub Brand {0} of Contract Monthly QTY (Std. Bottle) in Variable Event Cost are not same with BRSF ﻿
                            //ErrorHandling('We found that the Sub Brand '+StringBrandName+' of Contract Monthly QTY (Std. Bottle) in Variable Event Cost are not same with BRSF ');
                        }
                    }
                }
                for(String Key:VECEstimateVolMap.keySet()){
                    if(BRSFEstimateVolMap.containsKey(Key)){
                        if(math.abs( BRSFEstimateVolMap.get(Key) -VECEstimateVolMap.get(Key))>0.1){
                            String StringBrandName='';
                            if(SubBrandMap.containsKey(Key)){
                                StringBrandName= SubBrandMap.get(Key).Name;
                            }
                            String tempStr = Label.ASI_CRM_CN_VEC_Sub_Brand_Estimate_QTY_Validation;
                            List<String> fillers = new String[] {StringBrandName ,''};
                                ErrorHandling(String.format(tempStr,fillers));//We found that the Sub Brand {0} of  Estimate Monthly QTY (Std. Bottle) in Variable Event Cost are not same with BRSF﻿
                            //ErrorHandling('We found that the Sub Brand '+StringBrandName+' of  Estimate Monthly QTY (Std. Bottle) in Variable Event Cost are not same with BRSF ');
                        }
                    }
                }
                
            }
        }
        return ReturnList;
        
    }
    
    
    




    
    
    private ASI_CRM_CN_Contract_BRSF_Line_Item__c SetAmountToZero (ASI_CRM_CN_Contract_BRSF_Line_Item__c InputContractLine){
        InputContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c = InputContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c ==null? 0:InputContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c;
        InputContractLine.ASI_CRM_CN_Est_Monthly_Qty__c = InputContractLine.ASI_CRM_CN_Est_Monthly_Qty__c ==null? 0:InputContractLine.ASI_CRM_CN_Est_Monthly_Qty__c;
        InputContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c = InputContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c ==null? 0:InputContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
        InputContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c = InputContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c ==null? 0:InputContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
        InputContractLine.ASI_CRM_CN_Contract_Total_Dummy__c = InputContractLine.ASI_CRM_CN_Contract_Total_Dummy__c ==null? 0:InputContractLine.ASI_CRM_CN_Contract_Total_Dummy__c;
        InputContractLine.ASI_CRM_CN_Est_Total_Dummy__c = InputContractLine.ASI_CRM_CN_Est_Total_Dummy__c ==null? 0:InputContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
        return InputContractLine;
    }
    
    
    public void ErrorHandling(String ErrorMsg){ 
        msg += ErrorMsg + '<br/> ';
        //msg='Error,Can not Save!';
        UpsertPermission = false;
    }
    
    private void SettingDefaultValue(){        
        msg = '';
        UpsertPermission = true;
    }
    
    public PageReference CancelProcess(){ 
        PageReference pageRef = null;
        
        UpsertPermission = true;
        pageRef = new PageReference('/'+PageId);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    
    
    
    
    
    
    // shared function 
    public String newCounterCreatorLine() {
        
        String idNew;
        IF(LINE_ITEM_NEWRECORD_COUNTER == null) {
            LINE_ITEM_NEWRECORD_COUNTER = 0;
        }
        else {
            LINE_ITEM_NEWRECORD_COUNTER+=1;
        }
        
        String zParser = '';
        Integer oneDigitCounter = LINE_ITEM_NEWRECORD_COUNTER;
        
        if(LINE_ITEM_NEWRECORD_COUNTER > 9) {
            Integer zNumber = LINE_ITEM_NEWRECORD_COUNTER/10;
            for (Integer i = 0; i < zNumber; i++) {
                zParser += 'z';
            }
            oneDigitCounter = Math.mod(LINE_ITEM_NEWRECORD_COUNTER, 10);
        }
        
        idNew = zParser + string.valueof(oneDigitCounter);
        return idNew;
        
    }
    
    
    
    
    // @description: get Pick List Value by 'DescribeFieldResult' such as : getPickListValue(ASI_CRM_KR_A_P_Guideline__c.ASI_CRM_KR_Activity_Type__c.getDescribe());
    public List<SelectOption> getPickListValue(Schema.DescribeFieldResult fieldResult){
        List<SelectOption> Selectoptions = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            Selectoptions.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        return Selectoptions;
    }
    
    
    //*******************************************************************************************************
    //* @description custom class for PSF
    // ********************************************************************************************************
    public Class interimData{
        public ASI_CRM_Module__c Module {set;get;} 
        public boolean HaveRefresh  {set;get;} 
        public String MethodologyValue  {set;get;} {MethodologyValue='';}
        public String MethodologyDisplay  {set;get;} {MethodologyDisplay='';}
        
        
        public map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c> DetailLineMap{set;get;}
        
        public interimData(){
            this.Module=new ASI_CRM_Module__c();
            this.MethodologyValue='';
            DetailLineMap= new map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            this.HaveRefresh=true;
        }
        public interimData(boolean ClickRefresh){
            this.Module=new ASI_CRM_Module__c();
            this.MethodologyValue='';
            this.DetailLineMap= new map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            this.HaveRefresh=ClickRefresh;
        }
        
        public interimData( ASI_CRM_Module__c ModuleInput){
            this.Module=ModuleInput;
            this.DetailLineMap= new map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            this.HaveRefresh=true;
        }
        
        public interimData( ASI_CRM_Module__c ModuleInput,boolean ClickRefresh){
            this.Module=ModuleInput;
            this.DetailLineMap= new map<String, ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            this.HaveRefresh=ClickRefresh;
        }
    }
    
    
    
    //*******************************************************************************************************
    //* @description custom class for picklist value selection
    // ********************************************************************************************************
    public Class MethodType{
        public List<SelectOption> BRSFMethod {set;get;}
        public List<SelectOption> PSFMethod {set;get;}
        public List<SelectOption> VECMethod {set;get;} //Variable Event Cost = VEC
        public MethodType(){
            BRSFMethod= new List<SelectOption>();
            PSFMethod= new List<SelectOption>();
            VECMethod= new List<SelectOption>();
            
        }
    }
    
    
    @RemoteAction
    public static List<sObject> FindSubBrandList(string obj, string qry,String CommercialTeam,String Region,String CityTier){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(obj);
        if (sot == null){// Object name not valid
            return null;
        }
        // create the filter text
        String filter = qry;
        //begin building the dynamic soql query
        String soql;
        if(filter != '' || filter != null)
            soql = 'select Id, Name,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_Incentive_Central__c,ASI_CRM_Incentive_East__c,ASI_CRM_Incentive_North__c,ASI_CRM_Incentive_North_West__c  from ' + obj + filter +' order by Name';
        else
            soql = 'select Id, Name,ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c,ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_Incentive_Central__c,ASI_CRM_Incentive_East__c,ASI_CRM_Incentive_North__c,ASI_CRM_Incentive_North_West__c from ' + obj +' order by Name';
        
        List<sObject> sobjs = new List<sObject>();
        
        
        try{
            Map<String, ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeMap  = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
            
            for(ASI_CRM_Sub_Brand_Grade__c sbg:ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingSubBrandGrade(CommercialTeam,Region)){
                if(sbg.ASI_CRM_CN_City_Tier__c!=null){
                    SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c+ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(sbg.ASI_CRM_CN_City_Tier__c), sbg);
                }else{
                    SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c, sbg);
                }
            }
            
            
            //ASI_CRM_Max_Incentive__c,ASI_CRM_Max_Incentive_for_PSF__c,ASI_CRM_Incentive_for_PSF__c 
            sobjs = Database.query(soql);
            
            
            for(sObject SubBrand:sobjs){
                Decimal BRSFIncentive=0.0;
                Decimal PSFIncentive=0.0;
                Decimal BRSFMaxIncentive=99999999;
                Decimal PSFMaxIncentive=99999999;
                system.debug(SubBrand.Id);
                if(SubBrand.getSobject('ASI_CRM_CN_Sub_brand_Grade__r') !=NULL){//system.debug('now: '+SubBrand.getSobject('ASI_CRM_CN_Sub_brand_Grade__r') );          //system.debug('now: '+SubBrand.getSobject('ASI_CRM_CN_Sub_brand_Grade__r').get('Name')  );
                    String SubBrandGradeName=  (String) SubBrand.getSobject('ASI_CRM_CN_Sub_brand_Grade__r').get('Name');
                    String ExternalKey= (String) SubBrand.getSobject('ASI_CRM_CN_Sub_brand_Grade__r').get('Name');
                    ExternalKey+=Region!=NULL?Region:'';
                    ExternalKey+=CommercialTeam!=NULL? CommercialTeam:'';
                    
                    String CityTierExternalKey = ExternalKey;
                    if(CityTier!=null){
                        CityTierExternalKey+= ASI_CRM_CN_HeavyContractUtilitiesClass.CityTierGeneration(CityTier) ;
                    }
                    
                    if(SubBrandGradeMap.containsKey(CityTierExternalKey)){
                        BRSFIncentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_CN_Incentive__c;
                        PSFIncentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Incentive_for_PSF__c;
                        BRSFMaxIncentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Max_Incentive__c;
                        PSFMaxIncentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_Max_Incentive_for_PSF__c;
                    }else if(SubBrandGradeMap.containsKey(ExternalKey)){
                        BRSFIncentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_CN_Incentive__c;
                        PSFIncentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_Incentive_for_PSF__c;
                        BRSFMaxIncentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_Max_Incentive__c;
                        PSFMaxIncentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_Max_Incentive_for_PSF__c;
                    }else if(SubBrandGradeMap.containsKey(SubBrandGradeName)){
                        BRSFIncentive=SubBrandGradeMap.get(SubBrandGradeName).ASI_CRM_CN_Incentive__c;
                        PSFIncentive=SubBrandGradeMap.get(SubBrandGradeName).ASI_CRM_Incentive_for_PSF__c;
                        BRSFMaxIncentive=SubBrandGradeMap.get(SubBrandGradeName).ASI_CRM_Max_Incentive__c;
                        PSFMaxIncentive=SubBrandGradeMap.get(SubBrandGradeName).ASI_CRM_Max_Incentive_for_PSF__c;
                    }
                    
                    SubBrand.put('ASI_CRM_Incentive_Central__c', BRSFIncentive); //BRSF Incentive
                    SubBrand.put('ASI_CRM_Incentive_East__c', BRSFMaxIncentive); //BRSF Max Incentive
                    SubBrand.put('ASI_CRM_Incentive_North__c', PSFIncentive); //PSF Incentive
                    SubBrand.put('ASI_CRM_Incentive_North_West__c', PSFMaxIncentive); //PSF Max Incentive
                    
                }
                
            }
            return sobjs; 
        }catch (QueryException e){
            
            ASI_MFM_ByPass_Setting.ErrorHandling('RemoteAction.ASI_CRM_CN_EditHeavyContractDetailCtrl.FindSubBrandList class have Error  '+'Save Error : ' +e.getMessage() + '</br>','ASI_CRM_CN_EditHeavyContractDetailCtrl','failed! ');
            
            
            return null;
        }
        return sobjs;
    }
    
    
}