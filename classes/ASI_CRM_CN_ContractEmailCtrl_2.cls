public with sharing class ASI_CRM_CN_ContractEmailCtrl_2 {
    
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public String PageId {set;get;}
    public set<string> PromotionTypeFilter {set;get;}
    public map<string, string> SubbrandGroup = new map<string, string>();
    public map<integer, string> MonthMapping = new map<integer, string>();
    public set<id> thisCC_Subbrand {get;set;}
    public decimal PriorityBrand {set;get;}
    //Highlight output cell
    public string td_prefix {set;get;}
    public string td_end {set;get;}
    public string highlight1_td_prefix {set;get;}
    public string highlight2_td_prefix {set;get;}
    public decimal strpb {set;get;}
    Transient string color1 {set;get;}
    Transient string color2 {set;get;}
    public string strTitle {set;get;}
    public decimal THVarGap {set;get;}
    public decimal THFixGap {set;get;}
    public string positiveGreen {set;get;}
    public string negativeRed {set;get;}
    public string normalBlack {set;get;}
    public string positiveGreen_bottom {set;get;}
    public string negativeRed_bottom {set;get;}
    public string normalBlack_bottom {set;get;}
    
    public set<id> AllOutlet {set;get;}
    
    public ASI_TH_CRM_Contract__c PreviousCC {set;get;}
    //public ASI_TH_CRM_Contract__c PreviousCC_InitV {set;get;}
    //private list<ASI_CRM_Contract_Cost__c> PreviousCC_CostList {set;get;}
    private list<ASI_CRM_Subbrand_Volume__c> PreviousCC_SBVolumeList {set;get;}
    //private list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> PreviousCC_BRSFList {set;get;}
    //public list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> InitPreviousCC_BRSFList {set;get;}//lokman 23/5/2014
    //public Decimal base_version_InverstmentperCR_douze {set;get;}//lokman 23/5/2014
    //public Decimal last_version_InverstmentperCR_douze {set;get;}//lokman 23/5/2014
   
    //private list<ASI_CRM_CM_GS__c> PreviousCC_ActualCM {set;get;}
    private set<id> PreviousCC_Subbrand {get;set;}
    public decimal POMVariance {set;get;}
    
    public string thisCCStart {set;get;}
    public string thisCCEnd {set;get;}
    public string previousCCStart {set;get;}
    public string previousCCEnd {set;get;}
    public decimal previousCCNoMonths {set;get;}
    public string previousCCSalesRep {set;get;}
    public string InitPreviousCCStart {set;get;}
    public string InitPreviousCCEnd {set;get;}
    public string InitPreviousCCSalesRep {set;get;}
    public decimal InitPreviousCCNoMonths {set;get;}
    Transient decimal TotalHC_VolumeBtl {set;get;}
    
    public ASI_TH_CRM_Contract__c thisCC {set;get;}
    //private list<ASI_CRM_Contract_Cost__c> thisCC_CostList {set;get;}
    private list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> thisCC_BRSFList {set;get;}
    //private list<ASI_CRM_CM_GS__c> thisCC_BudgetCM {set;get;}
    
    public CalculateData VolumeData {set;get;}
    public CalculateData MarginperBottle {set;get;}
    public CalculateData MarginAP {set;get;}
    public CalculateData InvestmentCR12 {set;get;}
    public CalculateData TradeExpense {set;get;}
    public CalculateData VExpense {set;get;}
    public CalculateData FExpense {set;get;}
    public CalculateData FExpenseRate {set;get;}
    public CalculateData GrossSales {set;get;}
    public CalculateData GrossSalesTotal {set;get;}
    public CalculateData CMTotal {set;get;}
    public CalculateData ROI {set;get;}
    public CalculateData VarExp_AllProducts {set;get;}
    public CalculateData FixExp_Total {set;get;}
    public CalculateData VarExp_Total {set;get;}
    
    //public map<string, map<id, subbrand_data>> Subbrand_DataMap {set;get;}
    public map <string, subbrand_data> current_sbDataROI_map{set;get;}
    public map <string, subbrand_data> historical_sbDataROI_map{set;get;}
    private map<string, decimal> latest_actualcm = new map<string, decimal>();
    private map<string, decimal> latest_actualgs = new map<string, decimal>();
    private map<id, decimal> EstVolume_map {set;get;}
    private map<id, decimal> ConVolume_map {set;get;}
    
    public map<string, CalculateData> sbGroup_map {set;get;}
    public map<string, map<string, CalculateData>> sbVarExp {set;get;}
    
    //private list<ASI_CRM_CN_Channel_Strategy_Line_Item__c> CS_list {set;get;}
    private map<id, integer> CS_Sbmap {set;get;}
    public map<string, CalculateData> FixExpense_Map {set;get;}
    public map<string, CalculateData> VarExpense_Map {set;get;}
    
    //Set up CutOff Date
    public date CutOffDay {set;get;}
    public integer strCutOffDay {set;get;}
    
    //AD or Above Identity checking
    public boolean ADorAbove {set;get;}
    public string UserId {set;get;}
    public string strPDF {set;get;}
    
    //Covered Outlet
    //private set<id> AllOutlet {set;get;}
    //public list<ASI_CRM_CN_Covered_Outlet__c> CoveredOutlet {set;get;}
    
    //PO MOdification Investment CR12 
    public CalculateData InvestmentCR12_POM {set;get;}
    public CalculateData ROI_POM {set;get;}
    //private list<ASI_CRM_Subbrand_Volume__c> POM_SBVolumeList {set;get;}
    //private list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> POM_BRSFList {set;get;}
    //private list<ASI_CRM_CM_GS__c> v0_BudgetCM {set;get;}
    public decimal THAmount {set;get;}
    public decimal strv0FixCost {set;get;}
    public decimal strv0VarCost {set;get;}
    public decimal ActVSEst_Vol {set;get;}
    public decimal THGap {set;get;}
    
    //add PO Summary to PO Modification PDF 
    public list<ASI_CRM_CN_PaymentRequestUtilCls.PaymentSummary> paymentRequestSummary {set;get;}
    public decimal PS_TotalPOEstAmt {set;get;}
    public decimal PS_TotalPORemainAmt {set;get;}
    public decimal PS_TotalPODeltaAmt {set;get;}
    public decimal PS_TotalPaidAmt {set;get;}
    public decimal PS_TotalLastEstAmt {set;get;}
    
    public decimal Mod_VCost {set;get;}
    
    
    public ASI_CRM_CN_ContractEmailCtrl_2(ApexPages.StandardController controller) {
        PageId = ApexPages.currentPage().getParameters().get('id');
        if (PageId != null){
            try{
                thisCC = [SELECT id, Name, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, 
                          ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,
                          ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,
                          ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,
                          ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,
                          ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,
                          ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,
                          ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name,
                          ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,
                          ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c,
                          ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,
                          ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c,
                          ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c,
                          ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,
                          ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name,
                          ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,
                          ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c,
                          ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c,
                          ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,
                          ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c,
                          ASI_CRM_CN_V0_0_PO_version__c, Owner.Name,
                          ASI_CRM_CN_Status__c ,
                          ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c
                          FROM ASI_TH_CRM_Contract__c WHERE id = :PageId];
                
                init();
            }catch(exception e){
                //throw new ASI_CRM_CN_Function.CRMException(e.getMessage() + '\r\n' + e.getStackTraceString());
                //system.debug('Try thisContract failed: ' + e);
                thisCC = new ASI_TH_CRM_Contract__c();
                PreviousCC = new ASI_TH_CRM_Contract__c();
            }
        }else{
            thisCC = new ASI_TH_CRM_Contract__c();
            PreviousCC = new ASI_TH_CRM_Contract__c();
        }
        //system.debug('Subbrand_DataMap: '+ Subbrand_DataMap);
        //system.debug('sbVarExp: ' + sbVarExp);
    }
    public ASI_CRM_CN_ContractEmailCtrl_2(){
        //init();
    }
    public boolean init(){
        /*********************************  SET UP CUTOFF DATE ************************************/
        strCutOffDay = 16;
        positiveGreen = '<td  style="border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;text-align:right;margin-left:30px;color:#33CC33;">';
        negativeRed = '<td  style="border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;text-align:right;margin-left:30px;color:#FF0000;">';
        normalBlack = '<td  style="border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;text-align:right;margin-left:30px;">';
        positiveGreen_bottom = '<td  style="border-bottom:1px solid black;border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;text-align:right;margin-left:30px;color:#33CC33;">';
        negativeRed_bottom = '<td  style="border-bottom:1px solid black;border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;text-align:right;margin-left:30px;color:#FF0000;">';
        normalBlack_bottom = '<td  style="border-bottom:1px solid black;border-top:1px solid black;border-left:1px solid black;border-right:1px solid black;text-align:right;margin-left:30px;">';
        //AD Identity checking
        if (strPDF == '1')
            checkUserID();
        if (strPDF == '0')
            checkApprover();
        
        //Covered Outlet
        AllOutlet = new set<id>();
        //html table <td> </td> highlight prefix
        td_prefix = '<td style="border-right:1px solid black;" valign="top">';
        td_end = '</td>';
        highlight1_td_prefix = '<td style="border-right:1px solid black;" bgcolor="#FF7171" valign="top">';
        highlight2_td_prefix = '<td style="border-right:1px solid black;" bgcolor="#66FFFF" valign="top">';
        color1 = 'bgcolor="#FF7171"';
        color2 = 'bgcolor="#66FFFF"';
        strpb = 0;
        //Promotion Type Filter (New Contract On/Off no PO Start/End Date overlap)
        set<string> PromotionTypeFilter = new set<string>();
        PromotionTypeFilter.add('New Contract ON');
        PromotionTypeFilter.add('New Contract OFF');
        //System.debug('PromotionTypeFilter: ' + PromotionTypeFilter);
        //Only these Promotion type need to find historical contract
        set<string> PromotionTypes = new set<string>();
        PromotionTypes.add('RTD ON');
        PromotionTypes.add('RTD OFF');
        PromotionTypes.add('New Contract ON');
        PromotionTypes.add('New Contract OFF');
        //-------------------------------------------------------------------------
        //Sub-Brand Grade Grouping
        SubbrandGroup.put('Premium', '1. Standard + Premium');
        SubbrandGroup.put('Standard', '1. Standard + Premium');
        SubbrandGroup.put('Prestige', '4. Prestige + Ultra Prestige');
        SubbrandGroup.put('Ultra Prestige', '4. Prestige + Ultra Prestige');
        SubbrandGroup.put('Super Premium', '2. Super Premium');
        SubbrandGroup.put('Ultra Premium', '3. Ultra Premium');
        SubbrandGroup.put('Not Specified','0. Not Specified');
        //System.debug('SubbrandGroup: ' + SubbrandGroup);
        //------------------------------------------------------------------------- 
        //Month Mapping
        MonthMapping.put(1,'Jan');
        MonthMapping.put(2,'Feb');
        MonthMapping.put(3,'Mar');
        MonthMapping.put(4,'Apr');
        MonthMapping.put(5,'May');
        MonthMapping.put(6,'Jun');
        MonthMapping.put(7,'Jul');
        MonthMapping.put(8,'Aug');
        MonthMapping.put(9,'Sept');
        MonthMapping.put(10,'Oct');
        MonthMapping.put(11,'Nov');
        MonthMapping.put(12,'Dec');
        //-------------------------------------------------------------------------     
        
        init_Data();
        
        if (thisCC!= null){
            if (thisCC.ASI_CRM_CN_PO_Version__c == '0.0'){
                strTitle = 'PO Application Form';
            }else{
                strTitle = 'PO Modification Form';
            }
            //Add Covered outlet id
            /*
            try{
                CoveredOutlet = [SELECT ASI_CRM_CN_Outlet__c
                                 FROM ASI_CRM_CN_Covered_Outlet__c
                                 WHERE ASI_CRM_CN_Contract__c = :thisCC.id];
            }catch(exception e){
                CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
            }  */
            //set<id> AllOutlet = new set<id>();
            AllOutlet.add(thisCC.ASI_CRM_CN_Outlet_WS__c);
            //if (CoveredOutlet.size() > 0){
                for (ASI_CRM_CN_Covered_Outlet__c CO_temp: [SELECT ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
                    AllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
                }
            //}
            //system.debug('AllOutlet1: ' + AllOutlet);
            
            CutOffDay = CutOffDate(strCutOffDay); // 0 = ASI_CRM_CN_PO_End_Date__c
            if (thisCC.ASI_CRM_CN_PO_Start_Date__c != null && thisCC.ASI_CRM_CN_PO_End_Date__c != null){
                set<string> subP_set = checkFiscalYear(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
                //System.debug('subP_set: ' + subP_set);
                //System.debug('City Area: ' + thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c);
                /*CS_list = [SELECT ASI_CRM_CN_Brand__c, ASI_CRM_CN_Sub_brand__c
                           FROM ASI_CRM_CN_Channel_Strategy_Line_Item__c
                           WHERE ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Image__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c
                           AND ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Area__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c
                           AND ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Fiscal_Year__c IN :subP_set
                           AND ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Sub_Channel__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c
                           AND (ASI_CRM_CN_Brand__c = 'Priority 1' OR ASI_CRM_CN_Brand__c = 'Priority 2')];*/
                //System.debug('CS_List: ' + CS_List.size() + ' - ' + CS_List);
                //if (CS_List.size() > 0){
                    for (ASI_CRM_CN_Channel_Strategy_Line_Item__c cs : [SELECT ASI_CRM_CN_Brand__c, ASI_CRM_CN_Sub_brand__c
                           FROM ASI_CRM_CN_Channel_Strategy_Line_Item__c
                           WHERE ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Image__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c
                           AND ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Area__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c
                           AND ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Fiscal_Year__c IN :subP_set
                           AND ASI_CRM_CN_Channel_Strategy__r.ASI_CRM_CN_Sub_Channel__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c
                           AND (ASI_CRM_CN_Brand__c = 'Priority 1' OR ASI_CRM_CN_Brand__c = 'Priority 2')]){
                        if (cs.ASI_CRM_CN_Brand__c == 'Priority 1')
                            CS_Sbmap.put(cs.ASI_CRM_CN_Sub_brand__c, 1);
                        if (cs.ASI_CRM_CN_Brand__c == 'Priority 2')
                            CS_Sbmap.put(cs.ASI_CRM_CN_Sub_brand__c, 2);
                    }
                //}
                //2014-08-27 release heap
                //CS_list = null;
                //System.debug('CS_Sbmap: ' + CS_Sbmap);
            }
            
            //get thisCC Data
            getthisCCData();
            if (thisCC.ASI_CRM_CN_Vol_Budget_LE__c != null){
                VolumeData.strE = thisCC.ASI_CRM_CN_Vol_Budget_LE__c;
            }else{
                VolumeData.strE = 0;
            }
            if (VolumeData.strE != null && VolumeData.strB != null){
                VolumeData.strF = VolumeData.strE - VolumeData.strB;
            }
            if (thisCC.ASI_CRM_CN_Budget_LE__c != null){
                TradeExpense.strE = thisCC.ASI_CRM_CN_Budget_LE__c;//decimal.valueof(thisCC.ASI_CRM_CN_Budget_LE__c);
            }else{
                TradeExpense.strE = 0;
            }
            if (thisCC.ASI_CRM_CN_PO_Start_Date__c!= null)
                if (MonthMapping.containskey((thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH()))
                thisCCStart = (thisCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + MonthMapping.get((thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH());
            else
                thisCCStart = (thisCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + (thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH();
            if (thisCC.ASI_CRM_CN_PO_End_Date__c!= null)
                if (MonthMapping.containskey((thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH()))
                thisCCEnd = (thisCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + MonthMapping.get((thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH());
            else
                thisCCEnd = (thisCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + (thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH();
              
            if (thisCC.ASI_CRM_CN_Contract_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Cost_Total__c != null)
                TradeExpense.strD += thisCC.ASI_CRM_CN_Contract_Cost_Total__c;
            
            if (thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)
                FExpense.strB = thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
            
            //Trade Expenses, Esitmate               
            if (thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c!= 0 &&  thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c!= 0)
                TradeExpense.strB += thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c;  
             
            if (TradeExpense.strE != null && TradeExpense.strB != null){
                //if ((TradeExpense.strE - TradeExpense.strB) > 0)
                TradeExpense.strF = TradeExpense.strE - TradeExpense.strB;
                //else
                //TradeExpense.strF = -(TradeExpense.strE - TradeExpense.strB);
            }
            //Total Variable Cost (Estimate & Contract)
            
            //system.debug('VarExp_Total.strTotalC: '+ VarExp_Total.strTotalC); 
            //if (thisCC.ASI_CRM_CN_PO_Modification__c == true){  
            if (thisCC.ASI_CRM_CN_PO_Start_Date__c != null && thisCC.ASI_CRM_CN_PO_End_Date__c != null && thisCC.ASI_TH_CRM_Promotion_Type__c != null){
                //Criteria to get last contract     
                //String QueryStringWHERE = '';
                if (PromotionTypeFilter.contains(thisCC.ASI_TH_CRM_Promotion_Type__c)){
                    //System.debug('Promotion Type does NOT allow Overlapping of PO Period');
                    //QueryStringWHERE = 'AND ASI_CRM_CN_PO_End_Date__c <= :thisCC.ASI_CRM_CN_PO_Start_Date__c';
                    try{
                        PreviousCC = [SELECT id, ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c,
                                      ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,
                                      ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,
                                      ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c,
                                      ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,
                                      ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name,
                                      ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c
                                      //FROM ASI_TH_CRM_Contract__c WHERE id=:thisCC.ASI_CRM_CN_Last_PO_version__c//lokman 23/5/2014
                                      FROM ASI_TH_CRM_Contract__c WHERE ASI_CRM_CN_Outlet_WS__c = :thisCC.ASI_CRM_CN_Outlet_WS__c
                                      AND ASI_CRM_CN_PO_End_Date__c != null AND ASI_CRM_CN_PO_Start_Date__c != null
                                      AND ASI_CRM_CN_PO_End_Date__c <= :thisCC.ASI_CRM_CN_PO_Start_Date__c
                                      AND ASI_TH_CRM_Promotion_Type__c IN :PromotionTypes
                                      AND ASI_TH_CRM_Promotion_Type__c = :thisCC.ASI_TH_CRM_Promotion_Type__c
                                      AND (ASI_CRM_CN_Status__c = 'Final' OR ASI_CRM_CN_Status__c = 'Archived')
                                      ORDER BY ASI_CRM_CN_PO_End_Date__c DESC, ASI_CRM_CN_PO_Version__c DESC LIMIT 1];
                        //System.debug('PreviousCC.id: ' + PreviousCC.id);
                    }catch(exception e){
                        PreviousCC = new ASI_TH_CRM_Contract__c();
                        system.debug('Try Exception (PreviousCC): ' + e);
                    }
                    
                }else{
                    //System.debug('Promotion Type allows Overlapping of PO Period');
                    //QueryStringWHERE = 'AND ASI_CRM_CN_PO_End_Date__c < :thisCC.ASI_CRM_CN_PO_End_Date__c AND ASI_CRM_CN_PO_Start_Date__c < :thisCC.ASI_CRM_CN_PO_Start_Date__c';
                    try{    
                        PreviousCC = [SELECT id, ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, 
                                      ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,
                                      ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c ,
                                      ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c,
                                      ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, Owner.Name,
                                      ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c
                                      FROM ASI_TH_CRM_Contract__c WHERE //id =:thisCC.ASI_CRM_CN_Last_PO_version__c
                                      ASI_CRM_CN_Outlet_WS__c = :thisCC.ASI_CRM_CN_Outlet_WS__c
                                      AND ASI_CRM_CN_PO_End_Date__c != null AND ASI_CRM_CN_PO_Start_Date__c != null
                                      AND ASI_CRM_CN_PO_End_Date__c < :thisCC.ASI_CRM_CN_PO_End_Date__c
                                      AND ASI_TH_CRM_Promotion_Type__c IN :PromotionTypes
                                      AND ASI_TH_CRM_Promotion_Type__c = :thisCC.ASI_TH_CRM_Promotion_Type__c
                                      AND (ASI_CRM_CN_Status__c = 'Final' OR ASI_CRM_CN_Status__c = 'Archived')
                                      ORDER BY ASI_CRM_CN_PO_End_Date__c DESC, ASI_CRM_CN_PO_Version__c DESC LIMIT 1];
                    }catch(exception e){
                        PreviousCC = new ASI_TH_CRM_Contract__c();
                        //system.debug('Try Exception (PreviousCC): ' + e);
                    }
                    
                }
            }else{
                PreviousCC = new ASI_TH_CRM_Contract__c();
                //PreviousCC_InitV = new ASI_TH_CRM_Contract__c();
            }
            //System.debug('PreviousCC: ' + PreviousCC);
            if (PreviousCC.id != null){
                //Contract Version Final Start & End Date
                if (previousCC.ASI_CRM_CN_PO_Start_Date__c!= null)
                    if (MonthMapping.containskey((previousCC.ASI_CRM_CN_PO_Start_Date__c).MONTH()))
                    previousCCStart = (previousCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + MonthMapping.get((previousCC.ASI_CRM_CN_PO_Start_Date__c).MONTH());
                else
                    previousCCStart = (previousCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + (previousCC.ASI_CRM_CN_PO_Start_Date__c).MONTH();
                if (previousCC.ASI_CRM_CN_PO_End_Date__c!= null)
                    if (MonthMapping.containskey((previousCC.ASI_CRM_CN_PO_End_Date__c).MONTH()))
                    previousCCEnd = (previousCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + MonthMapping.get((previousCC.ASI_CRM_CN_PO_End_Date__c).MONTH());
                else
                    previousCCEnd = (previousCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + (previousCC.ASI_CRM_CN_PO_End_Date__c).MONTH();           
                
                //if (previousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c != null){
                PreviousCCSalesRep = previousCC.Owner.Name;
                //PreviousCCSalesRep = previousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name;
                //}
                if (previousCC.ASI_CRM_CN_No_of_Months__c != null)
                    PreviousCCNoMonths = previousCC.ASI_CRM_CN_No_of_Months__c;
                
                //-----------------
                
                //Contract Version 0.0 Start & End Date
                if (strPDF == '0' || thisCC.ASI_CRM_CN_PO_Version__c == '0.0')
                    getPreviousCCData();
            }else{
                //PreviousCC_CostList = new list<ASI_CRM_Contract_Cost__c>();
                //PreviousCC_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
                PreviousCC_SBVolumeList = new list<ASI_CRM_Subbrand_Volume__c>();
                //PreviousCC_ActualCM = new list<ASI_CRM_CM_GS__c>();
            }
            finalize_data();
            LoopSubbrand_data();
            
        }else{
            thisCC = new ASI_TH_CRM_Contract__c();
            PreviousCC = new ASI_TH_CRM_Contract__c();
            //PreviousCC_InitV = new ASI_TH_CRM_Contract__c();
            //thisCC_CostList = new list<ASI_CRM_Contract_Cost__c>();
            thisCC_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            //thisCC_BudgetCM = new list<ASI_CRM_CM_GS__c>();
            
        }
        
        return true;
    }
    //************************** HISTORICAL CONTRACT DATA *****************************************//
    public void getPreviousCCData(){
       
        /*
        try{
            PreviousCC_CostList = [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c
                                   FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id];
            PreviousCC_BRSFList = [SELECT ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Est_Monthly_Qty__c,
                                   ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Sub_Brand__r.Name,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,
                                   ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Contract_Total__c,
                                   ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Total__c ,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c
                                   , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                   FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id];
        }catch(exception e){
            PreviousCC_CostList = new list<ASI_CRM_Contract_Cost__c>();
            PreviousCC_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            //system.debug('Try Exception (PreviousCC_CostList/PreviousCC_BRSFList): ' + e);
        }*/
        string sbName;
        string SbGradeName = null;
        string SBGradeGroup = null;
        string SBGradeSort = '0000';
        decimal strAVol9L;
        decimal strA = 0;
        decimal strA2 = 0;
        decimal strTotalA = 0;
        boolean highlight1 = false;
        boolean highlight2 = false;
        decimal strD2 = 0;
        
        //string whichContract = 'Historical';
        //if (PreviousCC_BRSFList.size() > 0){
            for (ASI_CRM_CN_Contract_BRSF_Line_Item__c a : [SELECT ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Est_Monthly_Qty__c,
                                   ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Sub_Brand__r.Name,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,
                                   ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Contract_Total__c,
                                   ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Total__c ,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c
                                   , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                   FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id]){
                PreviousCC_Subbrand.add(a.ASI_CRM_CN_Sub_Brand__c);
                map<string, CalculateData> data2_map = new map<string, CalculateData>();
                CalculateData data2 = new CalculateData();
                //Sub Brand Name
                if (a.ASI_CRM_CN_Sub_Brand__c != null){
                    sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                }
                //Sub Brand Grade
                if (a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c != null)
                    sbGradeName = a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                else
                    sbGradeName = 'Not Specified';
                
                sbGradeSort =  SBGradeSorting(a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + sbGradeName;
                //System.debug('PreviousCC_BRSFList CS_Sbmap: ' + CS_Sbmap);
                if (CS_Sbmap.containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                    if (CS_Sbmap.get(a.ASI_CRM_CN_Sub_Brand__c) == 1){
                        highlight1 = true;
                    }
                    if (CS_Sbmap.get(a.ASI_CRM_CN_Sub_Brand__c) == 2){
                        highlight2 = true;
                    }
                }
                //System.debug('hightlight1: ' + highlight1 + ' highlight2: ' + highlight2);
                //Table 2 - Variable Expenses (in RMB) Historical Total Fees
                if (a.ASI_CRM_CN_Est_Monthly_Qty__c != null){
                    strA2 = a.ASI_CRM_CN_Est_Monthly_Qty__c;
                }else{
                    strA2 = 0;
                }
                
                if (a.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!= null){
                    strD2 = a.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                }else{
                    strD2 = 0;
                }
                
                
                //Historical Contract Varible Expense + BRSF Estimate
                if (a.ASI_CRM_CN_Est_Total__c!= null){
                    strTotalA = a.ASI_CRM_CN_Est_Total__c;
                }else{
                    strTotalA = 0;
                }
                //data2.strTotalA = 0; //strTotalA; //Historical Bottles/month
                
                data2.strhighlight1 = highlight1; //hasSubBrand in Priority 1
                data2.strhighlight2 = highlight2; //hasSubBrand in Priority 2
                data2.strA = 0; //strA2;
                data2.strB = 0;
                data2.strC = 0;
                data2.strD = strD2; //Historical Fees/month
                data2.strE = 0;
                data2.strF = 0;
                data2.strTotalA = 0; //strTotalA;
                data2.strTotalB = 0;
                data2.strTotalC = 0;
                if (sbVarExp.containskey(sbGradeSort)){
                    if (sbVarExp.get(sbGradeSort).containskey(sbName)){
                        //sbVarExp.get(sbGradeSort).get(sbName).strA += strA2;
                        sbVarExp.get(sbGradeSort).get(sbName).strD += strD2;
                        //sbVarExp.get(sbGradeSort).get(sbName).strTotalA += strTotalA;
                        if (sbVarExp.get(sbGradeSort).get(sbName).strhighlight1 != true)
                            sbVarExp.get(sbGradeSort).get(sbName).strhighlight1 = highlight1;
                        if (sbVarExp.get(sbGradeSort).get(sbName).strhighlight2 != true)
                            sbVarExp.get(sbGradeSort).get(sbName).strhighlight2 = highlight2;
                        if (highlight1 == true){
                            sbVarExp.get(sbGradeSort).get(sbName).strformat = highlight1_td_prefix;
                        }else if (highlight2 == true){
                            sbVarExp.get(sbGradeSort).get(sbName).strformat = highlight2_td_prefix;
                        }else if (highlight1 != true && highlight2 != true){
                            sbVarExp.get(sbGradeSort).get(sbName).strformat = td_prefix;
                        }
                    }else{
                        sbVarExp.get(sbGradeSort).put(sbName, data2);
                    }
                }else{
                    data2_map.put(sbName, data2);
                    sbVarExp.put(sbGradeSort, data2_map);
                }
                
                
                //Remove 2014-07-10 Table 2 - (VarExp_AllProducts) All Products Historical Bottles/month
                //VarExp_AllProducts.strA += strA2;
                //Table 2 - All Products Historical Fees/month
                VarExp_AllProducts.strD += strD2;
                //VarExp_AllProducts.strTotalA += strTotalA;
                VExpense.strA += strTotalA;
                TradeExpense.strA += strTotalA;
                //Remove 2014-07-10 Table 2 - (VarExp_Total) Total Variable
                VarExp_Total.strTotalA += strTotalA;
                //Used to calculate Acheivement Recognition
                //VarExp_Total.strD += strTotalA;
                
                /*
                //Subbrand_Data (Historical Subbrand Volume)
                map <id, subbrand_data> sb_data = new map <id, subbrand_data>();
                subbrand_data sbdata1 = new subbrand_data();
                sbdata1.TotalVolume = strA;
                sbdata1.BottleperMonth = strA2;
                sbdata1.FeesperMonth = strD2;
                sbdata1.TotalGS = 0;
                sbdata1.TotalCM = 0;
                sbdata1.CM = 0;
                sbdata1.GS = 0;
                sbdata1.sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                if (Subbrand_DataMap.containskey(whichContract)){
                    if (Subbrand_DataMap.get(whichContract).containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).TotalVolume += strA;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).BottleperMonth += strA2;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).FeesperMonth += strD2;
                        
                    }else{
                        Subbrand_DataMap.get(whichContract).put(a.ASI_CRM_CN_Sub_Brand__c, sbdata1);
                    }
                }else{
                    sb_data.put(a.ASI_CRM_CN_Sub_Brand__c, sbdata1);
                    Subbrand_DataMap.put(whichContract, sb_data );
                }*/
            }
        //}
        //2014-08-27 release heap
        //PreviousCC_BRSFList = null;
        
        
        set<id> Previous_AllOutlet = new set<id>();
        Previous_AllOutlet.add(PreviousCC.ASI_CRM_CN_Outlet_WS__c);
        
            for (ASI_CRM_CN_Covered_Outlet__c CO_temp: [SELECT ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id]){
                Previous_AllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
            }
        
        date TillEnd;
        if (CutOffDay >= PreviousCC.ASI_CRM_CN_PO_End_Date__c)
            TillEnd = getEndDate(PreviousCC.ASI_CRM_CN_PO_End_Date__c);
        else
            TillEnd = CutOffDay;
        
        //System.debug('TillEnd (Previous): ' + TillEnd);
        //if (PreviousCC_Subbrand.size() > 0){
            
            try{
                PreviousCC_SBVolumeList = [SELECT id, ASI_CRM_Offtake__c, ASI_CRM_Offtake_CR12__c, ASI_CRM_Subbrand__c, 
                                           ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_Subbrand__r.Name,
                                           ASI_CRM_T1_Depletion_BTL__c, ASI_CRM_Offtake_Btl__c, ASI_CRM_T2_Depletion_BTL__c,
                                           ASI_CRM_T1_Depletion__c, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,
                                           ASI_CRM_PR_Direct_CR12__c, ASI_CRM_T2_Depletion__c, ASI_CRM_PR_Direct__c,
                                           ASI_CRM_PR_Direct_Btl__c,ASI_CRM_End_Date__c ,
                                           ASI_CRM_T1_Depletion_STD__c, ASI_CRM_T2_Depletion_STD__c, ASI_CRM_PR_Direct_STD__c,
                                           ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                           FROM ASI_CRM_Subbrand_Volume__c WHERE //ASI_CRM_Subbrand__c IN :PreviousCC_Subbrand
                                           ASI_CRM_Account__c IN :AllOutlet // = :PreviousCC.ASI_CRM_CN_Outlet_WS__c
                                           AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                                           AND ASI_CRM_End_Date__c >= :PreviousCC.ASI_CRM_CN_PO_Start_Date__c
                                           AND ASI_CRM_End_Date__c <= :TillEnd];
            }catch(exception e){
                PreviousCC_SBVolumeList = new list<ASI_CRM_Subbrand_Volume__c>();
                //system.debug('Try Exception (ASI_CRM_Subbrand_Volume__c): ' + e);
            }
        //}else{
         //   PreviousCC_SBVolumeList = new list<ASI_CRM_Subbrand_Volume__c>();
        //}
        //System.debug('PreviousCC_SBVolumeList: ' + PreviousCC_SBVolumeList.size());
        //get All SB Volume id for Actual CM
        map<date, decimal> PreviousCC_Period_map = checkFYDayPeriod(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, PreviousCC.ASI_CRM_CN_PO_End_Date__c);
        set<id> PreviousCC_SBId = new set<id>();
        
        string strkey;
        //if (PreviousCC_SBVolumeList.size() > 0){
            for (ASI_CRM_Subbrand_Volume__c sbid : PreviousCC_SBVolumeList){
                PreviousCC_SBId.add(sbid.ASI_CRM_Subbrand__c);
            }
        //}
        //System.debug('PreviousCC_SBId: ' + PreviousCC_SBId );
        if (PreviousCC_Period_map != null && PreviousCC_Period_map.size() > 0){
            for (date PCCperiod: PreviousCC_Period_map.keyset() ){
                if (PreviousCC_SBId.size() > 0){
                    for (id sbidtemp : PreviousCC_SBId){
                        strkey = string.valueof(PCCperiod) + sbidtemp;
                        subbrand_data newitem = new subbrand_data();
                        newitem.period = PreviousCC_Period_map.get(PCCperiod);
                        newitem.sbname = sbidtemp;
                        newitem.year = string.valueof(PCCperiod.year());
                        newitem.TotalVolume = 0;
                        historical_sbDataROI_map.put(strkey, newitem);
                    }
                }
            }
        }
        //System.debug('historical_sbDataROI_map: ' + historical_sbDataROI_map);
        //Actual CM
        /*
        try{
            date strStartDate = PreviousCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
            PreviousCC_ActualCM = [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                                   ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                                   ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                   FROM ASI_CRM_CM_GS__c
                                   WHERE ASI_CRM_PRODUCTCODE__c IN :PreviousCC_SBId 
                                   AND ASI_CRM_Region__c = :PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                   //AND ASI_CRM_Sub_Channel__c = :PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c
                                   AND ASI_CRM_CN_Month_End_Date__c >= :strStartDate 
                                   AND ASI_CRM_CN_Month_End_Date__c <= :TillEnd
                                   AND (ASI_CRM_TYPE__c = 'YTD CM' OR ASI_CRM_TYPE__c = 'YTD GS')
                                   ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ];
            
        }catch(exception e){
            PreviousCC_ActualCM = new list<ASI_CRM_CM_GS__c>();
            //system.debug('Try Exception (ASI_CRM_CM_GS__c): ' + e);
        }*/
        //System.debug('PreviousCC_ActualCM: ' + PreviousCC_ActualCM);
        //get Gross Sales & Gross Sales before A&P (CM)
        //PreviousCC_ActualCM = new list<ASI_CRM_CM_GS__c>();
        date strStartDate = PreviousCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
        //if (PreviousCC_ActualCM.size() >0){
            decimal totalGS;
            decimal totalCM;
            //string whichContract;
            date CMdate;
            string CMYear;
            //string strkey;
            //Actual CM/GS for Historical Contract
            for (ASI_CRM_CM_GS__c acm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                                   ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                                   ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                   FROM ASI_CRM_CM_GS__c
                                   WHERE ASI_CRM_PRODUCTCODE__c IN :PreviousCC_SBId 
                                   AND ASI_CRM_Region__c = :PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                   //AND ASI_CRM_Sub_Channel__c = :PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c
                                   AND ASI_CRM_CN_Month_End_Date__c >= :strStartDate 
                                   AND ASI_CRM_CN_Month_End_Date__c <= :TillEnd
                                   AND (ASI_CRM_TYPE__c = 'YTD CM' OR ASI_CRM_TYPE__c = 'YTD GS')
                                   ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ]){
                CMdate = acm.ASI_CRM_CN_Month_End_Date__c;
                strkey = string.valueof(CMdate) + acm.ASI_CRM_PRODUCTCODE__c;
                CMYear = string.valueof(FYConversion(acm.ASI_CRM_CN_Month_End_Date__c).Year()) + acm.ASI_CRM_PRODUCTCODE__c;
                //whichContract = 'Historical';
                if (acm.ASI_CRM_CM_GS_per_9L__c != null){
                    if (acm.ASI_CRM_TYPE__c == 'YTD CM'){
                        //ROI.strA += acm.ASI_CRM_CM_GS_per_9L__c;
                        totalCM = acm.ASI_CRM_CM_GS_per_9L__c;
                        if (historical_sbDataROI_map.containskey(strkey)){
                            if (historical_sbDataROI_map.get(strkey).CM == null)
                                historical_sbDataROI_map.get(strkey).CM = totalCM;
                            //System.debug('YTD CM: '+acm.id + ' = ' + totalCM );
                        }
                        if (!latest_actualcm.containskey(CMYear)){
                            latest_actualcm.put(CMYear, totalCM);
                        }
                    }
                    if (acm.ASI_CRM_TYPE__c == 'YTD GS'){
                        //GrossSalesTotal.strA += acm.ASI_CRM_CM_GS_per_9L__c;
                        totalGS = acm.ASI_CRM_CM_GS_per_9L__c;
                        if (historical_sbDataROI_map.containskey(strkey)){
                            if (historical_sbDataROI_map.get(strkey).GS == null)
                                historical_sbDataROI_map.get(strkey).GS = totalGS;
                            //System.debug('YTD GS: '+ acm.id + ' = ' + totalGS );
                        } 
                        if (!latest_actualgs.containskey(CMYear)){
                            latest_actualgs.put(CMYear, totalGS);
                        } 
                    } 
                }
                //system.debug('Historical Actual CM strkey: '+ acm.id + ' ' + strkey + ' GS : ' + totalGS + ' CM: ' + totalCM);
                //Subbrand_Data (Historical Actual GS CM)
                
            }
        //}
        //2014-08-27 release heap
        //PreviousCC_ActualCM = null;
        
        //System.debug('historical_sbDataROI_map GS/CM: ' + historical_sbDataROI_map);
        TotalHC_VolumeBtl =0;
        decimal StdBtlVol = 0;
        Integer PeriodA = MonthDiff(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, TillEnd);
        Integer PeriodB = MonthDiff(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, PreviousCC.ASI_CRM_CN_PO_End_Date__c);
        Integer PeriodDiff;
        if (PeriodA != null && PeriodB != null)
            PeriodDiff = PeriodB - PeriodA;
        //System.debug('PreviousCC_SBVolumeList: ' + PreviousCC_SBVolumeList.size());
        //if (PreviousCC_SBVolumeList.size() > 0){
            //string strkey;
            date datekey;
            decimal VarHistBtl = 0;
            decimal VarHistTotal = 0;
            for (ASI_CRM_Subbrand_Volume__c b : PreviousCC_SBVolumeList){
                CalculateData data1 = new CalculateData();
                CalculateData data2 = new CalculateData();
                map<string, CalculateData> data2_map = new map<string, CalculateData>();
                datekey = FYConversion(b.ASI_CRM_End_Date__c);
                strkey = string.valueof(datekey) + b.ASI_CRM_Subbrand__c;
                //Sub Brand Name
                if (b.ASI_CRM_Subbrand__c != null){
                    sbName = b.ASI_CRM_Subbrand__r.Name;    
                }   
                //Sub Brand Grade
                if (b.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c != null)
                    sbGradeName = b.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                else
                    sbGradeName = 'Not Specified';
                //get Sub Brand Grade Grouping (refer to Map: SubbrandGroup)
                if (SubbrandGroup.containskey(sbGradeName)){
                    SBGradeGroup = SubbrandGroup.get(sbGradeName);
                }
                //System.debug('SBGradeGroup : ' + SBGradeGroup );
                sbGradeSort =  SBGradeSorting(b.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + sbGradeName;
                //Table 1 - Historical Contract INTAKE = ASI_CRM_T1_Depletion__c + ASI_CRM_T2_Depletion__c (9L cs)
                if (b.ASI_CRM_T1_Depletion__c != null){
                    strA = b.ASI_CRM_T1_Depletion__c;
                }else{
                    strA = 0;
                }
                if (b.ASI_CRM_T2_Depletion__c != null){
                    strA += b.ASI_CRM_T2_Depletion__c;
                }
                if (b.ASI_CRM_PR_Direct__c != null){
                    strA += b.ASI_CRM_PR_Direct__c ;
                }
                //system.debug('Vol Item: ' + strA + '/' + PeriodA+' * ' + PeriodDiff);
                //Prorated each subbrand Volume
                if (PeriodA != 0 && PeriodDiff != 0)
                    strA = strA/PeriodA * PeriodDiff + strA;
                
                //Table 1 - (VolumeData.strA) Volume (in 9L cs) INTAKE (Historical Contract vFinal)
                VolumeData.strA += strA;
                //system.debug('Historical Vol strA: ' + strA);
                //Variable Expenses (in RMB) Historical
                
                //Table 2 - (strA2) Historical Contract Bottles (for Cont.Margin per Bottle)
                //(ASI_CRM_T1_Depletion_BTL__c + ASI_CRM_T2_Depletion_BTL__c + ASI_CRM_PR_Direct_Btl__c)    
                strA2 = 0;
                if (b.ASI_CRM_T1_Depletion_STD__c != null){
                    strA2 = b.ASI_CRM_T1_Depletion_STD__c ;
                }
                if (b.ASI_CRM_T2_Depletion_STD__c!= null){
                    strA2 += b.ASI_CRM_T2_Depletion_STD__c;
                }
                if (b.ASI_CRM_PR_Direct_STD__c!= null){
                    strA2 += b.ASI_CRM_PR_Direct_STD__c;
                }
                
                //2014-07-10 Average Bottle per Month per Subbrand
                VarHistBtl = 0;
                VarHistTotal = strA2;
                if (PeriodA != null && PeriodA != 0 && VarHistTotal != 0){
                    VarHistBtl = VarHistTotal / PeriodA;
                }
                //system.debug('VarHistBtl = ' + b.ASI_CRM_Subbrand__r.Name + ' - ' + VarHistBtl + ' = ' + VarHistTotal +' / ' + PeriodA);
                //Prorate Bottle
                if (PeriodA != 0 && PeriodDiff != 0)
                    strA2 = strA2/PeriodA * PeriodDiff + strA2;
                
                
                TotalHC_VolumeBtl += strA2;
                
                //Table 1 - (InvestmentCR12.strA) CR12 eq btl (ASI_CRM_T1_Depletion_CR12__c + ASI_CRM_T2_Depletion_CR12__c + ASI_CRM_PR_Direct_CR12__c)
                if (b.ASI_CRM_T1_Depletion_CR12__c != null)
                    InvestmentCR12.strA += b.ASI_CRM_T1_Depletion_CR12__c;
                if (b.ASI_CRM_T2_Depletion_CR12__c != null)
                    InvestmentCR12.strA += b.ASI_CRM_T2_Depletion_CR12__c;
                if (b.ASI_CRM_PR_Direct_CR12__c!= null)
                    InvestmentCR12.strA += b.ASI_CRM_PR_Direct_CR12__c;
                
                //system.debug('InvestmentCR12: ' + InvestmentCR12.strA);     
                //Sub Brand Grade Grouping (Historical Contract vFinal)
                if (sbGroup_map.containskey(SBGradeGroup)){
                    //System.debug('sbGroup_map hits');
                    if (sbGroup_map.get(SBGradeGroup).strA != null)
                        sbGroup_map.get(SBGradeGroup).strA += strA;
                    else
                        sbGroup_map.get(SBGradeGroup).strA = strA;
                }else{
                    //System.debug('sbGroup_map NOT hits');
                    data1.strA = strA;
                    sbGroup_map.put(SBGradeGroup, data1);
                }
                //System.debug('sbGroup_map: ' + sbGroup_map);
                /********************** Table 1 - Historical Contract ROI ************************************/
                if (historical_sbDataROI_map.containskey(strkey)){
                    historical_sbDataROI_map.get(strkey).TotalVolume += strA;
                }
                
                /********************** Table 2 - Historical Contract (sbVarExp) ***************************/   
                //place in map (Variable Expenses subbrand)
                if (sbVarExp.containskey(sbGradeSort)){
                    if (sbVarExp.get(sbGradeSort).containskey(sbName)){
                        if (sbVarExp.get(sbGradeSort).get(sbName).strD != null && sbVarExp.get(sbGradeSort).get(sbName).strD != 0){
                            strTotalA = sbVarExp.get(sbGradeSort).get(sbName).strD * VarHistTotal; //strA2;
                        }else{
                            strTotalA = 0;
                        }
                    }else{
                        strTotalA = 0;
                    }
                }else{
                    strTotalA = 0;
                }
                
                //Table 2 2014-07-10 Historical Bottles/month & Total Fees
                data2.strhighlight1 = highlight1; //hasSubBrand in Priority 1
                data2.strhighlight2 = highlight2; //hasSubBrand in Priority 2
                data2.strA = VarHistBtl; //Historical Bottles/month
                data2.strB = 0;
                data2.strC = 0;
                data2.strD = 0; 
                data2.strE = 0;
                data2.strF = 0;
                data2.strTotalA = strTotalA;  //Historical Total Fees
                data2.strTotalB = 0;
                data2.strTotalC = 0;
                if (sbVarExp.containskey(sbGradeSort)){
                    if (sbVarExp.get(sbGradeSort).containskey(sbName)){
                        sbVarExp.get(sbGradeSort).get(sbName).strA += VarHistBtl ; //strA2;
                        if (sbVarExp.get(sbGradeSort).get(sbName).strhighlight1 != true)
                            sbVarExp.get(sbGradeSort).get(sbName).strhighlight1 = highlight1;
                        if (sbVarExp.get(sbGradeSort).get(sbName).strhighlight2 != true)
                            sbVarExp.get(sbGradeSort).get(sbName).strhighlight2 = highlight2;
                        sbVarExp.get(sbGradeSort).get(sbName).strTotalA += strTotalA;
                    }else{
                        sbVarExp.get(sbGradeSort).put(sbName, data2);
                    }
                }else{
                    data2_map.put(sbName, data2);
                    sbVarExp.put(sbGradeSort, data2_map);
                }
                VarExp_AllProducts.strA += VarHistBtl;
                VarExp_AllProducts.strTotalA += strTotalA;
                //VExpense.strA += strTotalA;
                //TradeExpense.strA += strTotalA;
                //VarExp_Total.strTotalA += strTotalA; 
                //Used to calculate Acheivement Recognition
                VarExp_Total.strD += strTotalA;
                /********************** END - Table 2 - Historical Contract (sbVarExp) ***************************/
                
                
                
                /*
                //Subbrand_Data (Historical Subbrand Volume)
                map <id, subbrand_data> sb_data = new map <id, subbrand_data>();
                subbrand_data sbdata1 = new subbrand_data();
                sbdata1.TotalVolume = strA;
                sbdata1.BottleperMonth = strA2;
                sbdata1.TotalGS = 0;
                sbdata1.TotalCM = 0;
                sbdata1.CM = 0;
                sbdata1.GS = 0;
                sbdata1.sbName = b.ASI_CRM_Subbrand__r.Name;
                if (Subbrand_DataMap.containskey(whichContract)){
                    if (Subbrand_DataMap.get(whichContract).containskey(b.ASI_CRM_Subbrand__c)){
                        Subbrand_DataMap.get(whichContract).get(b.ASI_CRM_Subbrand__c).sbName = b.ASI_CRM_Subbrand__r.Name;
                        Subbrand_DataMap.get(whichContract).get(b.ASI_CRM_Subbrand__c).TotalVolume += strA;
                        Subbrand_DataMap.get(whichContract).get(b.ASI_CRM_Subbrand__c).BottleperMonth += strA2;
                        
                    }else{
                        Subbrand_DataMap.get(whichContract).put(b.ASI_CRM_Subbrand__c, sbdata1);
                    }
                }else{
                    sb_data.put(b.ASI_CRM_Subbrand__c, sbdata1);
                    Subbrand_DataMap.put(whichContract, sb_data );
                }*/
            }
            //Prorate Investment CR12 for Historical Contract
            if (PeriodA != 0 && PeriodDiff != 0)
                InvestmentCR12.strA = InvestmentCR12.strA/PeriodA * PeriodDiff + InvestmentCR12.strA;
            
            
        //}
        //2014-08-27 release heap
        PreviousCC_SBVolumeList = null;
        
        //if (PreviousCC_CostList.size() > 0){
            for (ASI_CRM_Contract_Cost__c pccost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c
                                   FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id]){
                if (pccost.ASI_CRM_CN_Estimate_Amount__c != null){
                    TradeExpense.strA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                    //Historical Contract - Fixed Expenses
                    if (pccost.ASI_CRM_CN_Cost_Type__c == 'Fixed'){
                        FixExp_Total.strA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        FExpense.strA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        CalculateData data0 = new CalculateData();
                        if (FixExpense_Map.containskey(pccost.Name)){
                            FixExpense_Map.get(pccost.Name).strA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        }else{
                            data0.strA = pccost.ASI_CRM_CN_Estimate_Amount__c;
                            data0.strB = 0;
                            data0.strC = 0;
                            FixExpense_Map.put(pccost.Name, data0);
                        }
                    }
                    //Historical Contract - Variable Expense
                    if (pccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                        VarExp_Total.strTotalA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        VarExp_Total.strD += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        VExpense.strA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        
                        //Place VarExpense Total
                        CalculateData data0_var = new CalculateData(pccost.ASI_CRM_CN_Estimate_Amount__c,0,0);
                        if (VarExpense_Map.containskey(pccost.Name)){
                            VarExpense_Map.get(pccost.Name).strA += pccost.ASI_CRM_CN_Estimate_Amount__c;
                        }else{
                            VarExpense_Map.put(pccost.Name, data0_var);
                        }
                        
                    }
                }
            }
        //}
        //2014-08-27 release heap
        //PreviousCC_CostList = null;
        
    }
    //***************************************** CURRENT CONTRACT **********************************************//
    public void getthisCCData(){
        /*try{
            thisCC_CostList = [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c
                               FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id];
        }catch(exception e){
            system.debug('Try Exception (thisCC_CostList): ' + e);
            thisCC_CostList = new list<ASI_CRM_Contract_Cost__c>();
        }*/
        try{
            thisCC_BRSFList = [SELECT ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c,
                               ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, 
                               ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name,
                               ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,
                               ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,
                               ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                               FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id];
        }catch(exception e){
            system.debug('Try Exception (thisCC_BRSFList): ' + e);
            thisCC_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        }
        if (thisCC_BRSFList.size()>0){
            for (ASI_CRM_CN_Contract_BRSF_Line_Item__c a : thisCC_BRSFList){
                thisCC_Subbrand.add(a.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        //New Contract Period
        map<date, decimal> thisCC_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
        if (thisCC_Period_map!=null && thisCC_Period_map.size() > 0){
            string strkey;
            date strDateCC;
            for (date thisCCdate : thisCC_Period_map.keyset() ){
                strDateCC = FYConversion(thisCCdate);
                if (thisCC_Subbrand.size() > 0){
                    for (id sbid : thisCC_Subbrand){
                        strkey = string.valueof(strDateCC) + sbid ;
                        subbrand_data newitem = new subbrand_data();
                        newitem.period = thisCC_Period_map.get(thisCCdate);
                        newitem.sbname = sbid;
                        newitem.TotalVolume = 0;
                        newitem.TotalEstVolume = 0;
                        current_sbDataROI_map.put(strkey, newitem);
                    }
                }
            }
        }
        //System.debug('current_sbDataROI_map BUDGET: ' + current_sbDataROI_map);
        //Budget CM
        date strStartBGDate = getEndDate(thisCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1));
        date strEndBGDate = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c.addYears(+1));
        /*try{
            thisCC_BudgetCM = [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                               ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c , ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                               FROM ASI_CRM_CM_GS__c
                               WHERE ASI_CRM_PRODUCTCODE__c IN :thisCC_Subbrand 
                               AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                               //AND ASI_CRM_Sub_Channel__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c
                               AND ASI_CRM_CN_Month_End_Date__c >= :strStartBGDate 
                               AND ASI_CRM_CN_Month_End_Date__c <= :strEndBGDate 
                               AND (ASI_CRM_TYPE__c = 'Budget CM' OR ASI_CRM_TYPE__c = 'Budget GS')
                               ORDER BY ASI_CRM_CN_Month_End_Date__c ASC, ASI_CRM_VERSION__c DESC ];
        }catch(exception e){
            system.debug('Try Exception (thisCC_BudgetCM): ' + e);
            thisCC_BudgetCM = new list<ASI_CRM_CM_GS__c>();
        }*/
        //system.debug('thisCC_BudgetCM: ' + thisCC_BudgetCM );
        //if (thisCC_CostList.size() > 0){
            decimal strB;
            decimal strC;
            for (ASI_CRM_Contract_Cost__c  ccost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c
                               FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
                
                if (ccost.ASI_CRM_CN_Estimate_Amount__c != null){
                    strB = ccost.ASI_CRM_CN_Estimate_Amount__c;
                }else{
                    strB = 0;
                }
                if (ccost.ASI_CRM_CN_Contract_Amount__c != null){
                    strC = ccost.ASI_CRM_CN_Contract_Amount__c;
                }else{
                    strC = 0;
                }
                if (ccost.ASI_CRM_CN_Cost_Type__c == 'Fixed'){
                    if (FixExpense_Map.containskey(ccost.Name)){
                        FixExpense_Map.get(ccost.Name).strB += strB;
                        FixExpense_Map.get(ccost.Name).strC += strC;
                    }else{
                        FixExpense_Map.put(ccost.Name, new CalculateData(0,strB,strC));
                    }
                    FixExp_Total.strB += strB;
                    FixExp_Total.strC += strC;
                    FExpense.strB += strB;
                    FExpense.strD += strC;
                }
                if (ccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                    Mod_VCost += strB;
                    if (VarExpense_Map.containskey(ccost.Name)){
                        VarExpense_Map.get(ccost.Name).strB += strB;
                        VarExpense_Map.get(ccost.Name).strC += strC;
                    }else{
                        VarExpense_Map.put(ccost.Name, new CalculateData(0,strB,strC));
                    }
                    
                    VarExp_Total.strTotalB += strB;
                    VarExp_Total.strTotalC += strC;
                    VExpense.strB += strB;
                    VExpense.strD += strC;
                }
            }
            
        //}
        //2014-08-27 release heap
        //thisCC_CostList = null;
        if (thisCC_BRSFList.size() > 0){
            //for ROI vol 9L without * period
            decimal estvol;
            decimal convol;
            //P&L Review(in RMB) table
            strB = 0;
            decimal strD;
            //Variable Expenses(in RMB) table
            decimal strB2;
            decimal strC2;
            decimal strE2;
            decimal strF2;
            decimal totalB;
            decimal totalC;
            //uses on Investment per CR12 eq btl
            decimal strCR12Factor;
            //shared variables
            string sbGradeName;
            string SBGradeGroup;
            string SBGradeSort;
            string sbName;
            
            boolean highlight1 = false;
            boolean highlight2 = false;
            for (ASI_CRM_CN_Contract_BRSF_Line_Item__c a : thisCC_BRSFList){
                
                
                //thisCC_Subbrand.add(a.ASI_CRM_CN_Sub_Brand__c);
                //P&L Review (in RMB)
                CalculateData data1 = new CalculateData();
                //data1.strHighlight1 = false;
                //data1.strHighlight2 = false;
                //Variable Expenses(in RMB)
                CalculateData data2 = new CalculateData();
                //data2.strHighlight1 = false;
                //data2.strHighlight2 = false;
                map<string, CalculateData> data2_sbmap = new map<string, CalculateData>();
                //Sub Brand Name
                if (a.ASI_CRM_CN_Sub_Brand__c != null){
                    sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                }
                system.debug('thisCC_BRSFList CS_Sbmap: ' + CS_Sbmap);
                //Check if Channel Strategy contains sub brand in Priority 1 & 2
                if (CS_Sbmap.containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                    if (CS_Sbmap.get(a.ASI_CRM_CN_Sub_Brand__c) == 1){
                        highlight1 = true;
                    }
                    if (CS_Sbmap.get(a.ASI_CRM_CN_Sub_Brand__c) == 2){
                        highlight2 = true;
                    }
                }
                //System.debug('hightlight1: ' + highlight1 + ' highlight2: ' + highlight2);
                //Sub Brand Grade
                if (a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c != null)
                    sbGradeName = a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                else
                    sbGradeName = 'Not Specified';
                SBGradeSort = SBGradeSorting(a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + sbGradeName;
                //System.debug('sbGradeName: ' + sbGradeName);
                //get Sub Brand Grade Grouping (refer to Map: SubbrandGroup)
                if (SubbrandGroup.containskey(sbGradeName)){
                    SBGradeGroup = SubbrandGroup.get(sbGradeName);
                }
                
                //CR12 Conversion Factor
                if (a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c != 0 && a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c != null)
                    strCR12Factor = a.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c;
                else
                    strCR12Factor = 1;
                
                //Table 1 - CR12 eq btl 
                //Table 1 - Cont. Margin per Bottle: (New Contract - Estimate & Contract)
                if (a.ASI_CRM_CN_Est_BRSF_Per_Bottle__c != null){
                    //MarginperBottle.strB += a.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                    //Table 2 (Estimate Fees / Bottle)
                    strE2 = a.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                }else{
                    strE2 = 0;
                }
                if (a.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c != null){
                    
                    //MarginperBottle.strD += a.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
                    //Table 2 (Contract Fees / Bottle)
                    strF2 = a.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c;
                }else{
                    strF2 = 0;
                }
                //Table 2 (Estimate Bottles / month)
                if (a.ASI_CRM_CN_Est_Monthly_Qty__c!= null){
                    strB2 = a.ASI_CRM_CN_Est_Monthly_Qty__c;
                    if (highlight1 != false || highlight2 != false)
                        strpb += a.ASI_CRM_CN_Est_Monthly_Qty__c;
                }else{
                    strB2 = 0;
                }
                //Table 1 Estimate CR12 / Month
                if (a.ASI_CRM_CN_Est_Monthly_Qty__c!= null)
                    InvestmentCR12.strB += a.ASI_CRM_CN_Est_Monthly_Qty__c * strCR12Factor * a.ASI_CRM_CN_No_of_Months__c;
                 
                if (a.ASI_CRM_CN_Est_Total__c != null)
                    Mod_VCost += a.ASI_CRM_CN_Est_Total__c;
                //System.debug('highlight1: ' + highlight1  + ' highlight2: ' + highlight2);
                //System.debug('strpb: ' + strpb);
                //Table 2 (Contract Bottles / Month)
                if (a.ASI_CRM_CN_Contract_Monthly_Qty__c != null){
                    
                    strC2 = a.ASI_CRM_CN_Contract_Monthly_Qty__c;
                }else{
                    strC2 = 0;
                }
                //Table 1 Contract CR12 / Month
                if (a.ASI_CRM_CN_Contract_Monthly_Qty__c != null)
                    InvestmentCR12.strD += a.ASI_CRM_CN_Contract_Monthly_Qty__c * strCR12Factor * a.ASI_CRM_CN_No_of_Months__c;
                //Volumes (in 9L cs): (New Contract - Estimate & Contract)
                
                //Table 1 (Estimate Qty Convert 9L * No of Months) ASI_CRM_CN_Estimate_Volume_9L_Month__c
                if (a.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null && a.ASI_CRM_CN_No_of_Months__c != null){
                    VolumeData.strB += (a.ASI_CRM_CN_Estimate_Volume_9L_Month__c* a.ASI_CRM_CN_No_of_Months__c);
                    
                    //Table 1 (Estimate Qty (BTL) * No of Months)  
                    //if (a.ASI_CRM_CN_Est_Monthly_Qty__c != null && a.ASI_CRM_CN_No_of_Months__c != null){
                    //strB = (a.ASI_CRM_CN_Est_Monthly_Qty__c * a.ASI_CRM_CN_No_of_Months__c);
                    strB = (a.ASI_CRM_CN_Estimate_Volume_9L_Month__c * a.ASI_CRM_CN_No_of_Months__c);
                }else{
                    strB = 0;
                }
                //Table 1 Volume 9L (Contract Qty Convert 9L * No of Months) ASI_CRM_CN_Contract_Monthly_Vol9L__c
                if (a.ASI_CRM_CN_Contract_Monthly_Vol9L__c != null && a.ASI_CRM_CN_No_of_Months__c != null){
                    VolumeData.strD += (a.ASI_CRM_CN_Contract_Monthly_Vol9L__c * a.ASI_CRM_CN_No_of_Months__c);
                    
                    //Table 1 (Contract Qty (BTL) * No of Months)                        
                    //if (a.ASI_CRM_CN_Contract_Monthly_Qty__c != null && a.ASI_CRM_CN_No_of_Months__c != null){
                    //strD = (a.ASI_CRM_CN_Contract_Monthly_Qty__c * a.ASI_CRM_CN_No_of_Months__c);
                    strD = (a.ASI_CRM_CN_Contract_Monthly_Vol9L__c * a.ASI_CRM_CN_No_of_Months__c);
                }else{
                    strD = 0;
                }
                //Volume 9L for ROI
                estvol = 0;
                if (a.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null)
                    estvol = a.ASI_CRM_CN_Estimate_Volume_9L_Month__c;
                convol = 0;
                if (a.ASI_CRM_CN_Contract_Monthly_Vol9L__c != null)
                    convol = a.ASI_CRM_CN_Contract_Monthly_Vol9L__c;
                
                //Sub Brand Estimate & Contract 9L cs Volume
                if (sbGroup_map.containskey(SBGradeGroup)){
                    sbGroup_map.get(SBGradeGroup).strB += strB;
                    sbGroup_map.get(SBGradeGroup).strD += strD;
                }else{
                    data1.strB = strB; //New Contract - Estimate Volume
                    data1.strD = strD; //New Contract - Contract Volume
                    sbGroup_map.put(SBGradeGroup, data1);
                }
                //Variable Expenses (in RMB)
                data2.strA = 0;
                data2.strB = strB2; //Estimate Bottles/month
                data2.strC = strC2; //Contract Bottles/month
                data2.strD = 0; 
                data2.strE = strE2; //Estimate Fees/month
                data2.strF = strF2; //Contract Fees/month
                data2.strhighlight1 = highlight1; //hasSubBrand in Priority 1
                data2.strhighlight2 = highlight2; //hasSubBrand in Priority 2
                if (thisCC.ASI_CRM_CN_No_of_Months__c != null){
                    //Total Estimate Fees
                    TotalB = strB2 * strE2 * thisCC.ASI_CRM_CN_No_of_Months__c;
                    //Total Contract Fees
                    TotalC = strC2 * strF2 * thisCC.ASI_CRM_CN_No_of_Months__c;
                }else{
                    TotalB = 0;
                    TotalC = 0;
                }
                data2.strTotalA = 0;
                data2.strTotalB = TotalB;
                data2.strTotalC = TotalC;
                //Trade Expenses
                TradeExpense.strB += TotalB;
                TradeExpense.strD += TotalC;
                //Variable Expense
                VExpense.strB += TotalB;
                VExpense.strD += TotalC;
                
                //Total Variable Expenses (Include BRSF Cost)
                VarExp_Total.strTotalB += TotalB;
                VarExp_Total.strTotalC += TotalC;
                //Variable Expenses (ALL PRODUCTS)
                VarExp_AllProducts.strB += strB2;
                VarExp_AllProducts.strC += strC2;
                VarExp_AllProducts.strE += strE2;
                VarExp_AllProducts.strF += strF2;
                VarExp_AllProducts.strTotalB += TotalB;
                VarExp_AllProducts.strTotalC += TotalC;
                //Variable Expenses SB Estimate & Contract
                if (sbVarExp.containskey(sbGradeSort)){
                    if (sbVarExp.get(sbGradeSort).containskey(sbName)){
                        sbVarExp.get(sbGradeSort).get(sbName).strB += strB2;
                        sbVarExp.get(sbGradeSort).get(sbName).strC += strC2;
                        sbVarExp.get(sbGradeSort).get(sbName).strE += strE2;
                        sbVarExp.get(sbGradeSort).get(sbName).strF += strF2;
                        if (sbVarExp.get(sbGradeSort).get(sbName).strhighlight1 != true)
                            sbVarExp.get(sbGradeSort).get(sbName).strhighlight1 = highlight1;
                        if (sbVarExp.get(sbGradeSort).get(sbName).strhighlight2 != true)
                            sbVarExp.get(sbGradeSort).get(sbName).strhighlight2 = highlight2; 
                        if (highlight1 == true){
                            sbVarExp.get(sbGradeSort).get(sbName).strformat = color1;
                        }else if (highlight2 == true){
                            sbVarExp.get(sbGradeSort).get(sbName).strformat = color2;
                        }else if (highlight1 != true && highlight2 != true){
                            sbVarExp.get(sbGradeSort).get(sbName).strformat = '';
                        }
                        sbVarExp.get(sbGradeSort).get(sbName).strTotalB += TotalB;
                        sbVarExp.get(sbGradeSort).get(sbName).strTotalC += TotalC;
                        
                        
                    }else{
                        sbVarExp.get(sbGradeSort).put(sbName, data2);
                    }
                }else{
                    data2_sbmap.put(sbName, data2);
                    sbVarExp.put(sbGradeSort, data2_sbmap);
                }
                /*
                string whichContract;
                //Subbrand_Data (Estimate Volume)
                whichContract = 'Estimate';
                map <id, subbrand_data> sb_data = new map <id, subbrand_data>();
                subbrand_data sbdata1 = new subbrand_data();
                sbdata1.TotalVolume = strB;
                sbdata1.BottleperMonth = strB2;
                sbdata1.FeesperMonth = strE2;
                sbdata1.TotalGS = 0;
                sbdata1.TotalCM = 0;
                sbdata1.CM = 0;
                sbdata1.GS = 0;
                sbdata1.sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                if (Subbrand_DataMap.containskey(whichContract)){
                    if (Subbrand_DataMap.get(whichContract).containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).TotalVolume += strB;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).BottleperMonth += strB2 ;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).FeesperMonth += strE2 ;
                    }else{
                        Subbrand_DataMap.get(whichContract).put(a.ASI_CRM_CN_Sub_Brand__c, sbdata1);
                    }
                }else{
                    sb_data.put(a.ASI_CRM_CN_Sub_Brand__c, sbdata1);
                    Subbrand_DataMap.put(whichContract, sb_data );
                }
                //Subbrand_Data (Contract Volume)
                whichContract = 'Contract';
                map <id, subbrand_data> sb_data_c = new map <id, subbrand_data>();
                subbrand_data sbdata2 = new subbrand_data();
                sbdata2.TotalVolume = strD;
                sbdata2.BottleperMonth = strC2;
                sbdata2.FeesperMonth = strF2;
                sbdata2.TotalGS = 0;
                sbdata2.TotalCM = 0;
                sbdata2.CM = 0;
                sbdata2.GS = 0;
                sbdata2.sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                if (Subbrand_DataMap.containskey(whichContract)){
                    if (Subbrand_DataMap.get(whichContract).containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).sbName = a.ASI_CRM_CN_Sub_Brand__r.Name;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).TotalVolume += strD;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).BottleperMonth += strC2 ;
                        Subbrand_DataMap.get(whichContract).get(a.ASI_CRM_CN_Sub_Brand__c).FeesperMonth += strF2 ;
                    }else{
                        Subbrand_DataMap.get(whichContract).put(a.ASI_CRM_CN_Sub_Brand__c, sbdata2);
                    }
                }else{
                    sb_data_c.put(a.ASI_CRM_CN_Sub_Brand__c, sbdata2);
                    Subbrand_DataMap.put(whichContract, sb_data_c );
                }*/
                
                //Map for ROI     
                if (ConVolume_map.containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                    convol += ConVolume_map.get(a.ASI_CRM_CN_Sub_Brand__c);
                    ConVolume_map.put(a.ASI_CRM_CN_Sub_Brand__c, convol);
                }else{
                    ConVolume_map.put(a.ASI_CRM_CN_Sub_Brand__c, convol);
                }
                if (EstVolume_map.containskey(a.ASI_CRM_CN_Sub_Brand__c)){
                    estvol += EstVolume_map.get(a.ASI_CRM_CN_Sub_Brand__c);
                    EstVolume_map.put(a.ASI_CRM_CN_Sub_Brand__c, estvol);
                }else{
                    EstVolume_map.put(a.ASI_CRM_CN_Sub_Brand__c, estvol);
                }
                
            }
            
            //System.debug('thisCC_Subbrand: ' + thisCC_Subbrand);
            if (VolumeData.strA != 0 && VolumeData.strB != 0){
                VolumeData.strC = ((VolumeData.strB - VolumeData.strA)/VolumeData.strA)*100;
            }
        }
        //2014-08-27 release heap
        thisCC_BRSFList = null;
        //if (thisCC_BudgetCM.size() > 0){
            decimal totalGS;
            decimal totalCM;
            //string whichContract;
            string strkey;
            date strCMdate;
            // Budget CM / GS for Current Contract
            for (ASI_CRM_CM_GS__c thisbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                               ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c , ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                               FROM ASI_CRM_CM_GS__c
                               WHERE ASI_CRM_PRODUCTCODE__c IN :thisCC_Subbrand 
                               AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                               //AND ASI_CRM_Sub_Channel__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c
                               AND ASI_CRM_CN_Month_End_Date__c >= :strStartBGDate 
                               AND ASI_CRM_CN_Month_End_Date__c <= :strEndBGDate 
                               AND (ASI_CRM_TYPE__c = 'Budget CM' OR ASI_CRM_TYPE__c = 'Budget GS')
                               ORDER BY ASI_CRM_CN_Month_End_Date__c ASC, ASI_CRM_VERSION__c DESC ]){
                strCMdate = thisbcm.ASI_CRM_CN_Month_End_Date__c;
                strkey = string.valueof(strCMdate) + thisbcm.ASI_CRM_PRODUCTCODE__c;
                
                if (thisbcm.ASI_CRM_TYPE__c == 'Budget CM'){
                    //whichContract = 'Estimate';
                    totalCM = thisbcm.ASI_CRM_CM_GS_per_9L__c;
                    if (current_sbDataROI_map.containskey(strkey)){
                        if (current_sbDataROI_map.get(strkey).CM == null)
                            current_sbDataROI_map.get(strkey).CM = totalCM;
                    }
                }
                if (thisbcm.ASI_CRM_TYPE__c == 'Budget GS'){
                    //whichContract = 'Estimate';
                    totalGS = thisbcm.ASI_CRM_CM_GS_per_9L__c;
                    if (current_sbDataROI_map.containskey(strkey)){
                        if (current_sbDataROI_map.get(strkey).GS == null)
                            current_sbDataROI_map.get(strkey).GS = totalGS;
                    }
                }
                //Subbrand_Data (Budget & YTD GS CM)
                
                
               
            }
        //}
        //2014-08-27 release heap
        //thisCC_BudgetCM = null;
        
        //System.debug('current_sbDataROI_map: ' + current_sbDataROI_map);
    }
    public void finalize_data(){
        //Sb Grouping %vFinal
        //System.debug('sbGroup_map: ' + sbGroup_map);
        for (CalculateData a : sbGroup_map.values()){
            if (a.strB != 0 && a.strA !=0 && a.strB != null && a.strA !=null){
                a.strC = ((a.strB - a.strA)/a.strA)*100;
            }
        }
        //Fixed Expenses %
        system.debug('FExpense.strB: ' + FExpense.strB + ' / TradeExpense.strB: ' + TradeExpense.strB);
        system.debug('FExpense.strD: ' + FExpense.strD + ' / TradeExpense.strD: ' + TradeExpense.strD);
        if (FExpense.strB != null && FExpense.strB != 0 && TradeExpense.strB != null && TradeExpense.strB != 0)
            FExpenseRate.strB = FExpense.strB / TradeExpense.strB *100;
        if (FExpense.strD != null && FExpense.strD != 0 && TradeExpense.strD != null && TradeExpense.strD != 0)
            FExpenseRate.strD = FExpense.strD / TradeExpense.strD *100;
        //Historical Contract Fixed Expenses Rate %                        
        if (FExpense.strA != 0 &&  FExpense.strA != 0 && TradeExpense.strA != null &&  TradeExpense.strA != null)
            FExpenseRate.strA = FExpense.strA / TradeExpense.strA * 100;
        //Investment per CR12 eq btl
        if (InvestmentCR12.strA != 0 && InvestmentCR12.strA != null && TradeExpense.strA != 0 && TradeExpense.strA != null){
            InvestmentCR12.strA = TradeExpense.strA / InvestmentCR12.strA;    
        }
        system.debug('InvestmentCR12.strA: ' + InvestmentCR12.strA);
        system.debug('InvestmentCR12.strA = ' + TradeExpense.strA + ' / ' + InvestmentCR12.strA);
        if (InvestmentCR12.strB != 0 && InvestmentCR12.strB != null && TradeExpense.strB != 0 && TradeExpense.strB != null)
            InvestmentCR12.strB = TradeExpense.strB / InvestmentCR12.strB;
        if (InvestmentCR12.strD != 0 && InvestmentCR12.strD != null && TradeExpense.strD != 0 && TradeExpense.strD != null)
            InvestmentCR12.strD = TradeExpense.strD / InvestmentCR12.strD;
        if (InvestmentCR12.strA != 0 && InvestmentCR12.strA != null && InvestmentCR12.strB != 0 && InvestmentCR12.strB != null)
            InvestmentCR12.strC = ((InvestmentCR12.strB - InvestmentCR12.strA) / InvestmentCR12.strA)*100;
        system.debug('InvestmentCR12: ' + InvestmentCR12.strB + ' - ' + InvestmentCR12.strA + ' / ' + InvestmentCR12.strA + '*100' );
        if (investmentCR12.strA != null && InvestmentCR12.strB != null)
            POMVariance = InvestmentCR12.strB - InvestmentCR12.strA;
        /********************** Table 1 - vFinal % ***************************/
        //Table 1 Volume (in 9L cs)
        if (VolumeData.strA != null && VolumeData.strB != null && VolumeData.strA != 0 && VolumeData.strB != 0)
            VolumeData.strC = (VolumeData.strB - VolumeData.strA)/VolumeData.strA *100;
        
        //Table 1 Trade Expenses            
        if (TradeExpense.strA != null && TradeExpense.strB != null && TradeExpense.strA != 0 && TradeExpense.strB != 0)
            TradeExpense.strC = (TradeExpense.strB - TradeExpense.strA)/TradeExpense.strA *100;
        
        if (VExpense.strA != null && VExpense.strB != null && VExpense.strA != 0 && VExpense.strB != 0)
            VExpense.strC = (VExpense.strB - VExpense.strA)/VExpense.strA *100;
        if (FExpense.strA != null && FExpense.strB != null && FExpense.strA != 0 && FExpense.strB != 0)
            FExpense.strC = (FExpense.strB - FExpense.strA)/FExpense.strA *100;
        
        /********************** END - Table 1 - vFinal % ***************************/
        //%vFinal Fixed Expense % 
        if (FExpenseRate.strA != 0 && FExpenseRate.strB != 0 && FExpenseRate.strA != null && FExpenseRate.strB != null)
            FExpenseRate.strC = (FExpenseRate.strB/100 - FExpenseRate.strA/100)*100;
        //Acheivement Recognition (Actual Variable Expenses - Estimate Variable Expenses)
        if (VarExp_Total.strTotalA != null && VarExp_Total.strD != null){
            VarExp_Total.strA = VarExp_Total.strD - VarExp_Total.strTotalA;
        }
    }
    public void LoopSubbrand_data(){
        //ROI Calculations for Historical
        System.debug('latest_actualcm: ' + latest_actualcm);
        System.debug('latest_actualgs: ' + latest_actualgs); 
        System.debug('historical_sbDataROI_map: ' + historical_sbDataROI_map);
        if (historical_sbDataROI_map.size() > 0){
            decimal actualcm;
            decimal actualgs;
            decimal totalactualvol;
            decimal strperiod;
            decimal temptotal;
            for (string hctemp : historical_sbDataROI_map.keyset()){
                strperiod= null;
                if (historical_sbDataROI_map.get(hctemp).period != null){
                    strperiod = historical_sbDataROI_map.get(hctemp).period;
                }
                //Actual CM
                actualcm = null;
                if (historical_sbDataROI_map.get(hctemp).CM != null){
                    actualcm = historical_sbDataROI_map.get(hctemp).CM;
                }else{
                    if (latest_actualcm.containskey(historical_sbDataROI_map.get(hctemp).year + historical_sbDataROI_map.get(hctemp).sbname)){
                        actualcm = latest_actualcm.get(historical_sbDataROI_map.get(hctemp).year + historical_sbDataROI_map.get(hctemp).sbname);
                    }
                }
                //Actual GS
                actualgs = null;
                if (historical_sbDataROI_map.get(hctemp).GS != null){
                    actualgs = historical_sbDataROI_map.get(hctemp).GS;
                }else{
                    if (latest_actualgs.containskey(historical_sbDataROI_map.get(hctemp).year + historical_sbDataROI_map.get(hctemp).sbname)){
                        actualgs = latest_actualgs.get(historical_sbDataROI_map.get(hctemp).year + historical_sbDataROI_map.get(hctemp).sbname);
                    }
                }
                //Total Volume
                totalactualvol = null;
                if (historical_sbDataROI_map.get(hctemp).TotalVolume != null){
                    totalactualvol = historical_sbDataROI_map.get(hctemp).TotalVolume;
                }
                if (totalactualvol != null && actualcm != null & strperiod != null){
                    CMTotal.strA += actualcm * totalactualvol; // * strperiod;
                    temptotal = actualcm * totalactualvol;
                    system.debug('Historical ROI Volume: ' + historical_sbDataROI_map.get(hctemp).sbname + ' ' + actualcm + ' * ' + totalactualvol + ' = ' + temptotal); // + ' * ' + strperiod);
                }
                if (totalactualvol != null && actualgs != null & strperiod != null){
                    GrossSalesTotal.strA += actualgs * totalactualvol; // * strperiod;
                    system.debug('Historical Gross Sales: ' + historical_sbDataROI_map.get(hctemp).sbname + ' ' + actualgs + ' * ' + totalactualvol ); //+ ' * ' + strperiod);
                }
                
                
                system.debug('GrossSalesTotal.strA: ' + GrossSalesTotal.strA);
            }
        }
        //New Contract ROI Calculation
        system.debug('current_sbDataROI_map: ' + current_sbDataROI_map);
        system.debug('current_sbDataROI_map.size(): ' + current_sbDataROI_map.size());
        if (current_sbDataROI_map.size() > 0){
            decimal actualcm;
            decimal actualgs;
            decimal totalactualvol;
            decimal totalestimatevol;
            decimal strperiod;
            for (string ccroi : current_sbDataROI_map.keyset()){
                strperiod= null;
                if (current_sbDataROI_map.get(ccroi).period != null){
                    strperiod = current_sbDataROI_map.get(ccroi).period;
                }
                //Budget CM
                actualcm = null;
                if (current_sbDataROI_map.get(ccroi).CM != null){
                    actualcm = current_sbDataROI_map.get(ccroi).CM;
                }
                //Budget GS
                actualgs = null;
                if (current_sbDataROI_map.get(ccroi).GS != null){
                    actualgs = current_sbDataROI_map.get(ccroi).GS;
                }
                
                //Total Volume
                totalactualvol = null;
                if (ConVolume_map.containskey(current_sbDataROI_map.get(ccroi).sbname)){
                    totalactualvol = ConVolume_map.get(current_sbDataROI_map.get(ccroi).sbname);
                }
                totalestimatevol = null;
                if (EstVolume_map.containskey(current_sbDataROI_map.get(ccroi).sbname)){
                    totalestimatevol = EstVolume_map.get(current_sbDataROI_map.get(ccroi).sbname);
                }
                if (totalestimatevol != null && actualcm != null & strperiod != null){
                    CMTotal.strB += actualcm * totalestimatevol * strperiod;
                    system.debug('New ROI Estimate Volume: ' + actualcm + ' * ' + totalestimatevol + ' * ' + strperiod);
                }
                if (totalestimatevol != null && actualgs != null & strperiod != null){
                    GrossSalesTotal.strB += actualgs * totalestimatevol * strperiod;
                    system.debug('New Estimate Gross Sales: ' + actualgs + ' * ' + totalestimatevol + ' * ' + strperiod);
                }
                if (totalactualvol != null && actualcm != null & strperiod != null){
                    CMTotal.strD += actualcm * totalactualvol * strperiod;
                    system.debug('New ROI Contract Volume: ' + actualcm + ' * ' + totalactualvol + ' * ' + strperiod);
                }
                if (totalactualvol != null && actualgs != null & strperiod != null){
                    GrossSalesTotal.strD += actualgs * totalactualvol * strperiod;
                    system.debug('New Contract Gross Sales: ' + actualgs + ' * ' + totalactualvol + ' * ' + strperiod);
                }   
            }
        }
        system.debug('GrossSalesTotal: ' + GrossSalesTotal);
        //Historical Cont. Margin after A&P
        if (CMTotal.strA != null && TradeExpense.strA != null){
            //if (GrossSalesTotal.strA - TradeExpense.strA > 0)
            //MarginAP.strA = GrossSalesTotal.strA - TradeExpense.strA;
            MarginAP.strA = CMTotal.strA - TradeExpense.strA;
        }
        system.debug('Final Historical Margin AP: ' + CMTotal.strA + ' - ' + TradeExpense.strA);
        //Estimate Cont. Margin after A&P
        if (CMTotal.strB != null && TradeExpense.strB != null){
            //if (GrossSalesTotal.strB - TradeExpense.strB > 0)
            //MarginAP.strB = GrossSalesTotal.strB - TradeExpense.strB;
            MarginAP.strB = CMTotal.strB - TradeExpense.strB;
        }
        system.debug('Final Estimate Margin AP: ' + CMTotal.strB + ' - ' + TradeExpense.strB);
        system.debug('MarginAP.strB: ' + MarginAP.strB);
        //Contract Cont. Margin after A&P
        if (CMTotal.strD != null && TradeExpense.strD != null){
            //if (CMTotal.strD - TradeExpense.strD > 0)
            //MarginAP.strD = GrossSalesTotal.strD - TradeExpense.strD;
            MarginAP.strD = CMTotal.strD - TradeExpense.strD;
        }
        system.debug('Final Contract Margin AP: ' + CMTotal.strD + ' - ' + TradeExpense.strD);
        if (MarginAP.strB != null && MarginAP.strA != null && MarginAP.strA !=0){
            MarginAP.strC = ((MarginAP.strB - MarginAP.strA)/MarginAP.strA)*100;
        }
        //%vFinal Cont. Margin after A&P
        if (GrossSalesTotal.strA != null && GrossSalesTotal.strA != 0 && GrossSalesTotal.strB != null && GrossSalesTotal.strB != 0){
            GrossSalesTotal.strC = ((GrossSalesTotal.strB - GrossSalesTotal.strA)/GrossSalesTotal.strA)*100;
        }
        if (TotalHC_VolumeBtl != 0 && TotalHC_VolumeBtl != null && MarginAP.strA != 0 && MarginAP.strA != null){
            MarginperBottle.strA = MarginAP.strA / TotalHC_VolumeBtl;
        }
        system.debug('Historical Margin per Bottle: ' + MarginAP.strA + ' / ' + TotalHC_VolumeBtl);
        //Estimate Cont Margin per Bottle
        if (VarExp_AllProducts.strB != null && thisCC.ASI_CRM_CN_No_of_Months__c != null){
            MarginperBottle.strB = VarExp_AllProducts.strB * thisCC.ASI_CRM_CN_No_of_Months__c;
        }
        if (MarginperBottle.strB != 0 && MarginperBottle.strB != null && MarginAP.strB != 0 && MarginAP.strB != null){
            MarginperBottle.strB = MarginAP.strB / MarginperBottle.strB;
        }
        
        
        //Contract Cont Margin per Bottle
        if (VarExp_AllProducts.strD != null && thisCC.ASI_CRM_CN_No_of_Months__c != null){
            MarginperBottle.strD = VarExp_AllProducts.strC * thisCC.ASI_CRM_CN_No_of_Months__c;
        }
        if (MarginperBottle.strD != 0 && MarginperBottle.strD != null && MarginAP.strD != 0 && MarginAP.strD != null){
            MarginperBottle.strD = MarginAP.strD / MarginperBottle.strD;
        }
        //%vFinal Cont Margin per Bottle
        if (MarginperBottle.strA != null && MarginperBottle.strA != 0 && MarginperBottle.strB != null && MarginperBottle.strB != 0){
            MarginperBottle.strC = ((MarginperBottle.strB - MarginperBottle.strA)/MarginperBottle.strA)*100;
        }
        //%Gross Sales Historical
        if (GrossSalesTotal.strA != null && GrossSalesTotal.strA != 0 && TradeExpense.strA != 0 && TradeExpense.strA != null){
            GrossSales.strA = TradeExpense.strA / GrossSalesTotal.strA *100;
        }
        system.debug('GrossSales %: ' + TradeExpense.strA + '/' + GrossSalesTotal.strA + '*100');
        //%Gross Sales Estimate
        if (GrossSalesTotal.strB != null && GrossSalesTotal.strB != 0 && TradeExpense.strB != 0 && TradeExpense.strB != null){
            GrossSales.strB = TradeExpense.strB / GrossSalesTotal.strB *100;
        }
        system.debug('GrossSales %: ' + TradeExpense.strB + '/' + GrossSalesTotal.strB + '*100');
        //%Gross Sales Contract
        if (GrossSalesTotal.strD != null && GrossSalesTotal.strD != 0 && TradeExpense.strD != 0 && TradeExpense.strD != null){
            GrossSales.strD = TradeExpense.strD / GrossSalesTotal.strD *100;
        }
        system.debug('GrossSales %: ' + TradeExpense.strD + '/' + GrossSalesTotal.strD + '*100');
        //%Gross Sales %vFinal
        if (GrossSales.strA != null && GrossSales.strA != 0 && GrossSales.strB != 0 && GrossSales.strB != null){
            GrossSales.strC = (GrossSales.strB - GrossSales.strA);
        }
        
        //ROI Historical
        if (CMTotal.strA != null && CMTotal.strA != 0 && TradeExpense.strA != 0 && TradeExpense.strA != null){
            ROI.strA = CMTotal.strA / TradeExpense.strA;
        }
        system.debug('Final Historical ROI: ' + CMTotal.strA + ' / ' + TradeExpense.strA);
        //ROI Estimate
        if (CMTotal.strB != null && CMTotal.strB != 0 && TradeExpense.strB != 0 && TradeExpense.strB != null){
            ROI.strB = CMTotal.strB / TradeExpense.strB;
        }
        system.debug('Final Estimate ROI: ' + CMTotal.strB + ' / ' + TradeExpense.strB);
        //ROI Contract
        if (CMTotal.strD != null && CMTotal.strD != 0 && TradeExpense.strD != 0 && TradeExpense.strD != null){
            ROI.strD = CMTotal.strD / TradeExpense.strD;
        }
        system.debug('Final Contract ROI: ' + CMTotal.strB + ' / ' + TradeExpense.strB);
        //ROI %vFinal
        if (ROI.strB != null && ROI.strB != 0 && ROI.strA != null && ROI.strA != 0){
            ROI.strC = ((ROI.strB - ROI.strA) / ROI.strA)*100;
        }
       
        if (strpb != null && strpb != 0 &&  VarExp_AllProducts.strB != null &&  VarExp_AllProducts.strB !=0)
            PriorityBrand = strpb / VarExp_AllProducts.strB * 100;
        system.debug('strpb: ' + strpb + ' PriorityBrand: '+ PriorityBrand );
        
        //2014-08-27
        system.debug('before release: ' + Limits.getHeapSize());
        releaseHeapsize();
        system.debug('after release: ' + Limits.getHeapSize());
        
        /*********************************** PO Modification Email Template *********************************************/
        //if ((thisCC.ASI_CRM_CN_PO_Modification__c == true){
        if (thisCC.ASI_CRM_CN_PO_Version__c != '0.0'){
            //Add Covered outlet id
            /*
            set<id> AllOutlet = new set<id>();
            AllOutlet.add(thisCC.ASI_CRM_CN_Outlet_WS__c);
            //if (CoveredOutlet.size() > 0){
                for (ASI_CRM_CN_Covered_Outlet__c CO_temp:  [SELECT ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
                    AllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
                }
            //}
            */
            
            system.debug('AllOutlet2: ' + AllOutlet);
            Date TillEndPOM = getEndDate(FindMinMaxDate(CutOffDay, thisCC.ASI_CRM_CN_PO_End_Date__c, 'MIN'));
            system.debug('TillEndPOM: ' + TillEndPOM );
            /*try{
                POM_SBVolumeList = [SELECT id, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,
                                    ASI_CRM_PR_Direct_CR12__c,  
                                    ASI_CRM_End_Date__c,ASI_CRM_Subbrand__c ,
                                    ASI_CRM_T1_Depletion__c, ASI_CRM_T2_Depletion__c,
                                    ASI_CRM_PR_Direct__c
                                    FROM ASI_CRM_Subbrand_Volume__c WHERE //ASI_CRM_Subbrand__c IN :PreviousCC_Subbrand
                                    ASI_CRM_Account__c IN: AllOutlet//= :thisCC.ASI_CRM_CN_Outlet_WS__c
                                    AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                                    AND ASI_CRM_End_Date__c >= :thisCC.ASI_CRM_CN_PO_Start_Date__c
                                    AND ASI_CRM_End_Date__c <= :TillEndPOM];
            }catch(exception e){
                POM_SBVolumeList = new list<ASI_CRM_Subbrand_Volume__c>();
                system.debug('Try Exception (POM ASI_CRM_Subbrand_Volume__c): ' + e);
            }*/
            map<string, decimal> POMv1_sbvol = new map<string, decimal>();
            set<id> POMv1_sbid = new set<id>();
            //system.debug('POM_SBVolumeList: ' + POM_SBVolumeList );
            //if (POM_SBVolumeList.size() > 0){
                decimal pomv1_vol;
                string strkey;
                date pomdate;
                for (ASI_CRM_Subbrand_Volume__c pom: [SELECT id, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,
                                    ASI_CRM_PR_Direct_CR12__c,  
                                    ASI_CRM_End_Date__c,ASI_CRM_Subbrand__c ,
                                    ASI_CRM_T1_Depletion__c, ASI_CRM_T2_Depletion__c,
                                    ASI_CRM_PR_Direct__c
                                    FROM ASI_CRM_Subbrand_Volume__c WHERE //ASI_CRM_Subbrand__c IN :PreviousCC_Subbrand
                                    ASI_CRM_Account__c IN: AllOutlet//= :thisCC.ASI_CRM_CN_Outlet_WS__c
                                    AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                                    AND ASI_CRM_End_Date__c >= :thisCC.ASI_CRM_CN_PO_Start_Date__c
                                    AND ASI_CRM_End_Date__c <= :TillEndPOM]){
                    pomdate = FYConversion(pom.ASI_CRM_End_Date__c);
                    strkey = string.valueof(pomdate) + pom.ASI_CRM_Subbrand__c;
                    
                    if (pom.ASI_CRM_T1_Depletion_CR12__c != null)
                        InvestmentCR12_POM.strB += pom.ASI_CRM_T1_Depletion_CR12__c;
                    if (pom.ASI_CRM_T2_Depletion_CR12__c != null)
                        InvestmentCR12_POM.strB += pom.ASI_CRM_T2_Depletion_CR12__c;
                    if (pom.ASI_CRM_PR_Direct_CR12__c!= null)
                        InvestmentCR12_POM.strB += pom.ASI_CRM_PR_Direct_CR12__c;
                    //ROI Volume
                    pomv1_vol = 0;    
                    if (pom.ASI_CRM_T1_Depletion__c != null)
                        pomv1_vol += pom.ASI_CRM_T1_Depletion__c;
                    if (pom.ASI_CRM_T2_Depletion__c != null)
                        pomv1_vol += pom.ASI_CRM_T2_Depletion__c;
                    if (pom.ASI_CRM_PR_Direct__c!= null)
                        pomv1_vol += pom.ASI_CRM_PR_Direct__c;
                    
                    if (POMv1_sbvol.containskey(strkey)){
                        pomv1_vol += POMv1_sbvol.get(strkey);
                        POMv1_sbvol.put(strkey, pomv1_vol);
                    }else{
                        POMv1_sbvol.put(strkey, pomv1_vol);
                    }
                    system.debug('POM vol id: ' + pom.id);
                    POMv1_sbid.add(pom.ASI_CRM_Subbrand__c);
                }
            //}
            //2014-08-27 release heap
            //POM_SBVolumeList = null;
            
            //system.debug('POMv1_sbvol: ' + POMv1_sbvol);
            //system.debug('POMv1_sbid: '+ POMv1_sbid);
            //Prorate 
            if (thisCC.ASI_CRM_CN_PO_End_Date__c > CutOffDay){
                integer daysperiod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c,  CutOffDay);
                integer prorateperiod = MonthDiff(CutOffDay.addDays(+1), thisCC.ASI_CRM_CN_PO_End_Date__c);
                decimal AverageCR12;
                decimal Average9L;
                //for Latest Investment CR12
                if (daysperiod != null && daysperiod != 0 && InvestmentCR12_POM.strB != 0)
                    AverageCR12 = InvestmentCR12_POM.strB / daysperiod;
                if (prorateperiod != 0 && prorateperiod != null && AverageCR12 != null && AverageCR12 !=0)
                    InvestmentCR12_POM.strB += AverageCR12 * prorateperiod ;
                
            }
            system.debug('InvestmentCR12_POM.strB: ' + InvestmentCR12_POM.strB);
            //system.debug('ROI_POM.strTotalB: ' + ROI_POM.strTotalB);
            system.debug('thisCC.ASI_CRM_CN_Total_Contract_Amount__c: ' + thisCC.ASI_CRM_CN_Total_Contract_Amount__c);
            if (thisCC.ASI_CRM_CN_Total_Contract_Amount__c != null && InvestmentCR12_POM.strB != 0)
                InvestmentCR12_POM.strB = thisCC.ASI_CRM_CN_Total_Contract_Amount__c / InvestmentCR12_POM.strB;
            /*try{
                POM_BRSFList = [SELECT ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c,
                                ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, 
                                ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name,
                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,
                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,
                                ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :thisCC.ASI_CRM_CN_V0_0_PO_version__c];
            }catch(exception e){
                system.debug('Try Exception (POM_BRSFList): ' + e);
                POM_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            }*/
            decimal v0Brsf;
            decimal brsfvol_roi;
            decimal v0_estvol_pom = 0;
            strv0VarCost = 0;
            set<id>POMv0_sbid =new set<id>();
            map<id, decimal> BRSF_SBVol = new map<id, decimal>();
            //if (POM_BRSFList.size() > 0){
                for (ASI_CRM_CN_Contract_BRSF_Line_Item__c  pombrsf : [SELECT ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c,
                                ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, 
                                ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name,
                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,
                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,
                                ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :thisCC.ASI_CRM_CN_V0_0_PO_version__c] ){
                    if (pombrsf.ASI_CRM_CN_Est_Monthly_Qty__c != null && pombrsf.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c != null)
                        v0Brsf = pombrsf.ASI_CRM_CN_Est_Monthly_Qty__c * pombrsf.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c;
                    
                    /*if (pombrsf.ASI_CRM_CN_No_of_Months__c != null){
                        v0Brsf *= pombrsf.ASI_CRM_CN_No_of_Months__c;
                    }*/
                    if (pombrsf.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null){
                        brsfvol_roi = pombrsf.ASI_CRM_CN_Estimate_Volume_9L_Month__c ;
                    }
                    if (pombrsf.ASI_CRM_CN_Est_Total__c!= null)
                        strv0VarCost += pombrsf.ASI_CRM_CN_Est_Total__c;
                    v0_estvol_pom += v0Brsf ;
                    
                    InvestmentCR12_POM.strA += v0Brsf;
                    POMv0_sbid.add(pombrsf.ASI_CRM_CN_Sub_Brand__c);
                    if (BRSF_SBVol.containskey(pombrsf.ASI_CRM_CN_Sub_Brand__c)){
                        brsfvol_roi += BRSF_SBVol.get(pombrsf.ASI_CRM_CN_Sub_Brand__c);
                        BRSF_SBVol.put(pombrsf.ASI_CRM_CN_Sub_Brand__c, brsfvol_roi);
                    }else{
                        BRSF_SBVol.put(pombrsf.ASI_CRM_CN_Sub_Brand__c, brsfvol_roi);
                    }
                }
                system.debug('InvestmentCR12_POM.strA: ' + InvestmentCR12_POM.strA);
            //}
            //2014-08-27 release heap
            //POM_BRSFList = null;
            if (InvestmentCR12_POM.strA != null && InvestmentCR12_POM.strA != 0 && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != null && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != 0)
                InvestmentCR12_POM.strA = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c / InvestmentCR12_POM.strA ;
            //Investment CR12 gap
            if (InvestmentCR12_POM.strA != null && InvestmentCR12_POM.strB != null && InvestmentCR12_POM.strA != 0 && InvestmentCR12_POM.strB != 0)
                InvestmentCR12_POM.strC = (InvestmentCR12_POM.strB - InvestmentCR12_POM.strA) /InvestmentCR12_POM.strA*100;
            system.debug('POMv0_sbid: ' + POMv0_sbid);   
            date v0startdate = getEndDate(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c.addYears(-1));
            date v0enddate = getEndDate(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c.addYears(+1));
            /*try{
                v0_BudgetCM = [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                               ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                               ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                               FROM ASI_CRM_CM_GS__c
                               WHERE ASI_CRM_PRODUCTCODE__c IN :POMv0_sbid
                               AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                               AND ASI_CRM_CN_Month_End_Date__c >= :v0startdate
                               AND ASI_CRM_CN_Month_End_Date__c <= :v0enddate 
                               AND ASI_CRM_TYPE__c = 'Budget CM'
                               ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ];
            }catch(exception e){
                system.debug('try v0_budgetCM failed: ' + e);
                v0_BudgetCM = new list<ASI_CRM_CM_GS__c>();
            }*/
            map<date, decimal> v0_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c);
            map<string, subbrand_data> v0_ROImap = new map <string, subbrand_data>();
            if (v0_Period_map.size() > 0){
                strkey = null;
                for (date v0period : v0_Period_map.keyset()){
                    if (POMv0_sbid.size() > 0){
                        for (id sbid : POMv0_sbid){
                            strkey = string.valueof(v0period) + sbid;
                            subbrand_data newitem = new subbrand_data();
                            newitem.period = v0_Period_map.get(v0period);
                            newitem.sbname = sbid;
                            newitem.totalVolume = 0;
                            //newitem.CM = 0;
                            v0_ROImap.put(strkey, newitem);
                        }
                    }
                }
            }
            //system.debug('v0_ROImap: ' + v0_ROImap.size() + ' - ' + v0_ROImap);
            //system.debug('v0_BudgetCM: ' + v0_BudgetCM.size() + ' - ' + v0_BudgetCM);
            //if (v0_BudgetCM.size() > 0){
                strkey = null;
                decimal budgetcm;
                for (ASI_CRM_CM_GS__c v0budgetcmtemp : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                               ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                               ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                               FROM ASI_CRM_CM_GS__c
                               WHERE ASI_CRM_PRODUCTCODE__c IN :POMv0_sbid
                               AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                               AND ASI_CRM_CN_Month_End_Date__c >= :v0startdate
                               AND ASI_CRM_CN_Month_End_Date__c <= :v0enddate 
                               AND ASI_CRM_TYPE__c = 'Budget CM'
                               ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ]){
                    strkey = string.valueof(v0budgetcmtemp.ASI_CRM_CN_Month_End_Date__c) + v0budgetcmtemp.ASI_CRM_PRODUCTCODE__c;
                    budgetcm = 0;
                    system.debug('v0Budgetcm strkey: ' + strkey);
                    if (v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != null)
                        budgetcm = v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c;
                    if (v0_ROImap.containskey(strkey)){
                        if (v0_ROImap.get(strkey).CM == null)
                            v0_ROImap.get(strkey).CM = budgetcm;
                    }
                }
            //}
            system.debug('v0_ROImap (BudgetCM): ' + v0_ROImap );
            if (v0_ROImap.size() > 0){
                for (string roitemp : v0_ROImap.keyset()){
                    if (BRSF_SBVol.containskey(v0_ROImap.get(roitemp).sbname)){
                        v0_ROImap.get(roitemp).TotalVolume = BRSF_SBVol.get(v0_ROImap.get(roitemp).sbname);
                    }
                    if (v0_ROImap.get(roitemp).TotalVolume != null && v0_ROImap.get(roitemp).CM != null && v0_ROImap.get(roitemp).period != null){
                        ROI_POM.strTotalA += v0_ROImap.get(roitemp).TotalVolume * v0_ROImap.get(roitemp).CM * v0_ROImap.get(roitemp).period;
                        system.debug('ROI_POM.strTotalA: ' + ' += ' + v0_ROImap.get(roitemp).TotalVolume + ' * ' + v0_ROImap.get(roitemp).CM  + ' * ' + v0_ROImap.get(roitemp).period);
                    }
                }
            }
            if (ROI_POM.strTotalA != null && ROI_POM.strTotalA != 0 && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != null && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != 0){
                ROI_POM.strA = ROI_POM.strTotalA / thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c;
            }
            system.debug('ROI_POM.strA: ' + ROI_POM.strTotalA + ' / ' + thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c);
            
            //Lastest ROI (Actual CM)
            //list<ASI_CRM_CM_GS__c> Lastest_ActualCM = new list<ASI_CRM_CM_GS__c>();
            date v1startdate = getEndDate(thisCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1));
            date v1enddate;
            if (thisCC.ASI_CRM_CN_PO_End_Date__c > CutOffDay){
                v1enddate = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c);
            }else{
                v1enddate = CutOffDay;
            }
            /*try{
                Lastest_ActualCM = [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                                    ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                                    ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                    FROM ASI_CRM_CM_GS__c
                                    WHERE ASI_CRM_PRODUCTCODE__c IN :POMv1_sbid
                                    AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                    AND ASI_CRM_CN_Month_End_Date__c >= :v1startdate 
                                    AND ASI_CRM_CN_Month_End_Date__c <= :v1enddate 
                                    AND ASI_CRM_TYPE__c = 'YTD CM'
                                    ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ];
            }catch(exception e){
                system.debug('try v1Latest_ActualCM failed: ' + e);
            }
            system.debug('Lastest_ActualCM: ' + Lastest_ActualCM);*/
            map<date, decimal> Lastest_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c);
            map<string, subbrand_data> Lastest_ROImap = new map <string, subbrand_data>();
            if (Lastest_Period_map.size() > 0){
                strkey = null;
                for (date v1period : Lastest_Period_map.keyset()){
                    if (POMv1_sbid.size() > 0){
                        for (id sbid : POMv1_sbid){
                            strkey = string.valueof(v1period) + sbid;
                            subbrand_data newitem = new subbrand_data();
                            newitem.period = Lastest_Period_map.get(v1period);
                            newitem.sbname = sbid;
                            newitem.year = string.valueof(FYConversion(v1period).year());
                            newitem.totalVolume = 0;
                            Lastest_ROImap.put(strkey, newitem);
                        }
                    }
                }
            }
            system.debug('Lastest_Period_map: ' + Lastest_Period_map);
            //map<id, decimal> lastestroi = new map<id, decimal>();
            map<string, decimal> lastestroi = new map<string, decimal>();
            //if (Lastest_ActualCM.size() > 0){
                strkey = null;
                decimal actualcm;
                string lastestkey;
                for (ASI_CRM_CM_GS__c v1budgetcmtemp : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,
                                    ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                                    ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                    FROM ASI_CRM_CM_GS__c
                                    WHERE ASI_CRM_PRODUCTCODE__c IN :POMv1_sbid
                                    AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                    AND ASI_CRM_CN_Month_End_Date__c >= :v1startdate 
                                    AND ASI_CRM_CN_Month_End_Date__c <= :v1enddate 
                                    AND ASI_CRM_TYPE__c = 'YTD CM'
                                    ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ]){
                    strkey = string.valueof(v1budgetcmtemp.ASI_CRM_CN_Month_End_Date__c) + v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c;
                    lastestkey = string.valueof(FYConversion(v1budgetcmtemp.ASI_CRM_CN_Month_End_Date__c)) + v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c;
                    actualcm = 0;
                    system.debug('v1Budgetcm strkey: ' + strkey);
                    if (v1budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != null)
                        actualcm = v1budgetcmtemp.ASI_CRM_CM_GS_per_9L__c;
                    if (Lastest_ROImap.containskey(strkey)){
                        if (Lastest_ROImap.get(strkey).CM == null)
                            Lastest_ROImap.get(strkey).CM = actualcm;
                    }
                    if (!lastestroi.containskey(lastestkey)){
                        lastestroi.put(lastestkey, actualcm);
                    }
                }
                system.debug('Lastest_ROImap: ' + Lastest_ROImap);
            //}
            if (Lastest_ROImap.size() > 0){
                decimal strv1vol;
                actualcm = 0;
                for (string v1roitemp : Lastest_ROImap.keyset()){
                    strv1vol = 0;
                    if (POMv1_sbvol.containskey(v1roitemp)){
                        strv1vol = POMv1_sbvol.get(v1roitemp);
                    }
                    actualcm = null;
                    if (Lastest_ROImap.get(v1roitemp).CM != null)
                        actualcm = Lastest_ROImap.get(v1roitemp).CM;
                    else 
                        //if (lastestroi.containskey(Lastest_ROImap.get(v1roitemp).year + Lastest_ROImap.get(v1roitemp).sbname))
                        //actualcm = lastestroi.get(Lastest_ROImap.get(v1roitemp).year + Lastest_ROImap.get(v1roitemp).sbname);
                        if (lastestroi.containskey(v1roitemp))
                            actualcm = lastestroi.get(v1roitemp);
                    system.debug('Latest ROI actualcm: ' + actualcm);
                    if (strv1vol != null && actualcm != null){
                        ROI_POM.strTotalB += strv1vol * actualcm;
                        system.debug('ROI_POM.strTotalB item: ' + strv1vol + ' * ' + actualcm);
                    }
                }
                
            }
            //Prorate POM Lastest ROI Volume
            integer daysperiod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c,  CutOffDay);
            integer prorateperiod = MonthDiff(CutOffDay.addDays(+1), thisCC.ASI_CRM_CN_PO_End_Date__c);
            decimal Average9L = 0;
            if (ROI_POM.strTotalB != 0 && ROI_POM.strTotalB != null && daysperiod != null && daysperiod != 0)
                Average9L = ROI_POM.strTotalB / daysperiod;
            if (Average9L != null && prorateperiod != null)
                ROI_POM.strTotalB += Average9L *  prorateperiod;  
            //POM ROI
            if (ROI_POM.strTotalB != null && ROI_POM.strTotalB != 0 && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != 0 && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != null)
                ROI_POM.strB = ROI_POM.strTotalB / thisCC.ASI_CRM_CN_Total_Contract_Amount__c;
            system.debug('ROI_POM.strTotalB: ' + ROI_POM.strTotalB + ' / ' + thisCC.ASI_CRM_CN_Total_Contract_Amount__c);
            //POM ROI Gap
            if (ROI_POM.strA != null && ROI_POM.strB != null)
                if (ROI_POM.strA != 0 && ROI_POM.strB != 0 && (ROI_POM.strB - ROI_POM.strA) != 0)
                    ROI_POM.strC = (ROI_POM.strB - ROI_POM.strA)/ROI_POM.strA * 100;
  
            
            //Theoretical Amount
            /*list<ASI_CRM_Contract_Cost__c> v0_CostList = new list<ASI_CRM_Contract_Cost__c>();
            try{
                v0_CostList = [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c
                               FROM ASI_CRM_Contract_Cost__c 
                               WHERE ASI_CRM_CN_Contract__c = :thisCC.ASI_CRM_CN_V0_0_PO_version__c];
            }catch(exception e){
                system.debug('Try v0_CostList failed: ' + e);
            }*/
            //strv0FixCost = 0;
            
            //if (v0_CostList.size() > 0){
                for (ASI_CRM_Contract_Cost__c v0cost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c
                               FROM ASI_CRM_Contract_Cost__c 
                               WHERE ASI_CRM_CN_Contract__c = :thisCC.ASI_CRM_CN_V0_0_PO_version__c]){
                    
                    if (v0cost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                        if (v0cost.ASI_CRM_CN_Estimate_Amount__c != null)
                            strv0VarCost += v0cost.ASI_CRM_CN_Estimate_Amount__c;
                    }
                }
                //system.debug('strv0FixCost: ' + strv0FixCost);
                system.debug('strv0VarCost: ' + strv0VarCost);
                system.debug('v0_estvol_pom: ' + v0_estvol_pom );
            //}
            //2014-08-27 release heap
            //v0_CostList = null;
            
            if (thisCC.ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)
                strv0FixCost = thisCC.ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
            if (thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null && thisCC.ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)
                THFixGap = thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c - thisCC.ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;

            //v0 Actual Volume CTD
            list<ASI_CRM_subbrand_Volume__c> v0_VolList = new list<ASI_CRM_Subbrand_Volume__c>();
            date v0TillEndPOM = getEndDate(FindMinMaxDate(CutOffDay, thisCC.ASI_CRM_CN_PO_End_Date__c, 'MIN'));
            try{
                v0_VolList = [SELECT id, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,
                              ASI_CRM_PR_Direct_CR12__c,  
                              ASI_CRM_End_Date__c,ASI_CRM_Subbrand__c
                              FROM ASI_CRM_Subbrand_Volume__c WHERE //ASI_CRM_Subbrand__c IN :PreviousCC_Subbrand
                              ASI_CRM_Account__c IN: AllOutlet//= :thisCC.ASI_CRM_CN_Outlet_WS__c
                              AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                              AND ASI_CRM_End_Date__c >= :thisCC.ASI_CRM_CN_PO_Start_Date__c
                              AND ASI_CRM_End_Date__c <= :v0TillEndPOM];
            }catch(exception e){
                system.debug('Try Exception (v0_VolList ): ' + e);
            }
            decimal v0_actualvol_pom = 0;
            system.debug('v0_VolList: ' + v0_VolList );
            if (v0_VolList.size() > 0){
                for(ASI_CRM_Subbrand_Volume__c v0vol : v0_VolList){
                    if (v0vol.ASI_CRM_T1_Depletion_CR12__c != null)
                        v0_actualvol_pom += v0vol.ASI_CRM_T1_Depletion_CR12__c;
                    if (v0vol.ASI_CRM_T2_Depletion_CR12__c != null)
                        v0_actualvol_pom += v0vol.ASI_CRM_T2_Depletion_CR12__c;
                    if (v0vol.ASI_CRM_PR_Direct_CR12__c != null)
                        v0_actualvol_pom += v0vol.ASI_CRM_PR_Direct_CR12__c;
                }
            }
            //2014-08-27 release heap size
            v0_VolList = null;
            
            system.debug('v0_actualvol_pom: ' + v0_actualvol_pom );
            //Theoretical Amount Final Calculation
            
            date cutoffend;
            if (CutOffDay > thisCC.ASI_CRM_CN_PO_End_Date__c)
                cutoffend = thisCC.ASI_CRM_CN_PO_End_Date__c;
            else
                cutoffend = CutOffDay;
            Integer thisCCPeriod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
            Integer THCTDPeriod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, cutoffend);
            system.debug('thisCCPeriod: ' + thisCCPeriod);
            system.debug('THCTDPeriod: ' + THCTDPeriod );
            ActVSEst_Vol = 0;
            decimal v0_actualVol_Period = 0;
            decimal v0_actualVol_Period_Month = 0;
            if (THCTDPeriod != null && THCTDPeriod != 0 && v0_actualvol_pom != null && v0_actualvol_pom != 0)
                v0_actualVol_Period_Month =  v0_actualvol_pom /  THCTDPeriod ;
            if (v0_actualVol_Period_Month != null && v0_actualVol_Period_Month  != 0 && thisCCPeriod != null && thisCCPeriod != 0)
                v0_actualVol_Period  = v0_actualVol_Period_Month * thisCCPeriod ;
            system.debug('v0_actualVol_Period_Month: ' + v0_actualVol_Period_Month );
            if (v0_actualVol_Period != null && v0_actualVol_Period != 0 && v0_estvol_pom != null && v0_estvol_pom != 0)
                ActVSEst_Vol = v0_actualVol_Period / (v0_estvol_pom * thisCCPeriod);
            system.debug('v0_actualVol_Period: ' + v0_actualVol_Period );
            if (strv0VarCost != null)
                ActVSEst_Vol  *= strv0VarCost;
            if (ActVSEst_Vol <= 0 || ActVSEst_Vol == null)
                ActVSEst_Vol = 0; //strv0VarCost;
            if (ActVSEst_Vol != null && strv0FixCost != null)
                THAmount = strv0FixCost + ActVSEst_Vol ;
            if (THAmount != null && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != null)
                THGap = thisCC.ASI_CRM_CN_Total_Contract_Amount__c - THAmount;
            if (ActVSEst_Vol != null && Mod_VCost != null)
                THVarGap = Mod_VCost - ActVSEst_Vol;
                
            //Payment Request Summary
            try{
                paymentRequestSummary = ASI_CRM_CN_PaymentRequestUtilCls.genPaymentSummary(null, thisCC);
            }catch(exception e){
                system.debug('Try paymentRequestSummary failed: ' + e);
            }
            PS_TotalPOEstAmt = 0;
            PS_TotalPORemainAmt = 0;
            PS_TotalPODeltaAmt = 0;
            PS_TotalPaidAmt = 0;
            PS_TotalLastEstAmt = 0;
            if (paymentRequestSummary.size() > 0){
                for (ASI_CRM_CN_PaymentRequestUtilCls.PaymentSummary prtemp : paymentRequestSummary){
                    PS_TotalPOEstAmt += prtemp.POEstimateAmt ;
                    PS_TotalPORemainAmt += prtemp.PORemainAmt ;
                    PS_TotalPODeltaAmt += prtemp.PODeltaAmt;
                    PS_TotalPaidAmt += prtemp.PaidAmt;
                    PS_TotalLastEstAmt += prtemp.LastPOEstimateAmt;
                }
            }
        }
        
        
    }
    public date FindMinMaxDate(date Date1, date Date2, string strType){
        //strType: MIN, MAX
        Date returnDate;
        if (strType == 'MIN'){
            if (Date1 <= Date2)
                returnDate = Date1;
            else
                returnDate = Date2;
        }
        else if (strType == 'MAX'){
            if (Date1 >= Date2)
                returnDate = Date1;
            else
                returnDate = Date2;
        }
        return returnDate;
    }
    public void init_Data(){
        //PreviousCC_ActualCM = new list<ASI_CRM_CM_GS__c >();
        PreviousCC_Subbrand = new set<id>();
        thisCC_Subbrand = new set<id>();
        sbVarExp = new map<string, map<string, CalculateData>>();
        sbGroup_map = new map<string, CalculateData>();
        FixExpense_Map = new map<string, CalculateData>();
        VarExpense_Map = new map<string, CalculateData>();
        historical_sbDataROI_map = new map <string, subbrand_data>();
        current_sbDataROI_map = new map <string, subbrand_data>();
        latest_actualcm = new map<string, decimal>();
        latest_actualgs = new map<string, decimal>();
        EstVolume_map = new map<id, decimal>();
        ConVolume_map = new map<id, decimal>();
        //v0_BudgetCM = new list<ASI_CRM_CM_GS__c >();
        
        paymentRequestSummary = new list<ASI_CRM_CN_PaymentRequestUtilCls.PaymentSummary>();
        
        CS_Sbmap = new map<id, integer>();
        
        CalculateData tempNull = new CalculateData(0,0,0,0);
        CalculateData tempNull1 = new CalculateData(0,0,0,0);
        CalculateData tempNull2 = new CalculateData(0,0,0,0);
        CalculateData tempNull3 = new CalculateData(0,0,0,0);
        sbGroup_map.put('1. Standard + Premium', tempNull);
        sbGroup_map.put('2. Super Premium', tempNull1);
        sbGroup_map.put('3. Ultra Premium', tempNull2);
        sbGroup_map.put('4. Prestige + Ultra Prestige', tempNull3);
        
        VolumeData = new CalculateData(0,0,0,0,0,0);
        VolumeData.strName = 'Volume (in 9L cs)';
        
        GrossSales = new CalculateData(0,0,0,0);
        GrossSales.strName = '% Gross Sales ';
        
        InvestmentCR12 = new CalculateData(0,0,0,0);
        InvestmentCR12.strName = 'Investment per CR12 eq btl';
        
        VExpense = new CalculateData(0,0,0,0);
        VExpense.strName = 'Variable Expense';
        
        FExpense = new CalculateData(0,0,0,0,0,0);
        FExpense.strName = 'Fixed Expense';
        
        FExpenseRate = new CalculateData();
        FExpenseRate.strName = 'Fixed Expense %';
        
        TradeExpense = new CalculateData(0,0,0,0,0,0);
        TradeExpense.strName = 'Trade Expenses';
        
        MarginAP = new CalculateData(0,0,0,0);
        MarginAP.strName = 'Cont. Margin after A&P ';
        
        MarginperBottle = new CalculateData(0,0,0,0);
        MarginperBottle.strName = 'Cont. Margin per Bottle ';
        
        ROI = new CalculateData(0,0,0,0,0,0);
        ROI.strName = 'ROI ';
        
        VarExp_AllProducts = new CalculateData(0,0,0,0,0,0,0,0,0);
        VarExp_AllProducts.strName = 'ALL PRODUCTS';
        
        FixExp_Total = new CalculateData(0,0,0);
        
        VarExp_Total = new CalculateData(0,0,0,0,0,0,0,0,0);
        
        GrossSalesTotal = new CalculateData(0,0,0,0);
        GrossSalesTotal.strName = 'Gross Sales';
        
        CMTotal = new CalculateData(0,0,0,0);
        CMTotal.strName = 'Gross Sales before A&P (CM)';
        
        //InvestmentCR12_POM = new CalculateData(0,0,0,0,null,null,0,0,null);
        InvestmentCR12_POM = new CalculateData(0,0,0,0,0,0,0,0,0);
        InvestmentCR12_POM.strName = 'PO Modification Key Fin. Indicator';
        
        //ROI_POM = new CalculateData(0,0,0,0,null,null,0,0,null);
        ROI_POM = new CalculateData(0,0,0,0,0,0,0,0,0);
        ROI_POM.strName = 'PO Modification Key Fin. Indicator ROI';        
        Mod_VCost =0;
        //Subbrand_DataMap = new map<string, map<id, subbrand_data>>(); 
        THGap = 0;
        THFixGap = 0;
        THVarGap = 0;
    }
    
    public set<string> checkFiscalYear(Date strStart, Date strEnd){
        //system.debug('checkFiscalYear()');
        Integer strSYear = strStart.Year();
        Integer strEYear = strEnd.Year();
        Integer strSMonth = strStart.Month();
        Integer strEMonth = strEnd.Month();
        Integer strPeriodY = 0;
        Integer outputSFY;
        Integer outputEFY;
        set<string> FY_set = new set<string>();
        if (strSMonth > 6)
            outputSFY = strSYear;
        else if (strSMonth < 7)
            outputSFY = strSYear - 1;
        if (strEMonth > 6)
            outputEFY = strEYear + 1;
        else if (strEMonth < 7)
            outputEFY = strEYear;
        strPeriodY = outputEFY - outputSFY ;
        if (strPeriodY <= 1){
            FY_set.add(outputSFY + '/' + outputEFY);
        }else{
            for (Integer i=0; i< strPeriodY; i++ ){
                FY_set.add(string.valueof(outputSFY + i) + '/' + string.valueof(outputSFY + i + 1));
            }
        }
        //system.debug('FY_set: ' + FY_set);
        return FY_set;
    }
    public class CalculateData{
        public string strName {set;get;}
        public decimal strA {set;get;}
        public decimal strB {set;get;}
        public decimal strC {set;get;}
        public decimal strD {set;get;}
        public decimal strE {set;get;}
        public decimal strF {set;get;}
        public decimal strTotalA {set;get;}
        public decimal strTotalB {set;get;}
        public decimal strTotalC {set;get;}
        public boolean strHighlight1 {set;get;}
        public boolean strHighlight2 {set;get;}
        public string strformat {set;get;}
        public CalculateData() {
            this(null,null,null,null,null,null,null,null,null);
        }
        public CalculateData(decimal a, decimal b, decimal c) {
            this(a,b,c,null,null,null,null,null,null);
        }
        public CalculateData(decimal a, decimal b, decimal c, decimal d) {
            this(a,b,c,d,null,null,null,null,null);
        }
        public CalculateData(decimal a, decimal b, decimal c, decimal d, decimal e, decimal f) {
            this(a,b,c,d,e,f,null,null,null);
        }
        public CalculateData(decimal a, decimal b, decimal c, decimal d, decimal e, decimal f, decimal totalA, decimal totalB, decimal totalC) {
            strA = a;
            strB = b;
            strC = c;
            strD = d;
            strE = e;
            strF = f;
            strTotalA = totalA;
            strTotalB = totalB;
            strTotalC = totalC;
        }
    }
    public class subbrand_data{
        public string sbname {set;get;}
        public decimal BottleperMonth {set;get;}
        public decimal FeesperMonth {set;get;}
        public decimal TotalVolume {set;get;}
        public decimal TotalEstVolume {set;get;}
        public decimal TotalGS {set;get;}
        public decimal TotalCM {set;get;}
        public decimal GS {set;get;}
        public decimal CM {set;get;}
        public decimal period {set;get;}
        public decimal seqence {set;get;}
        public string year {set;get;}
    }
    public void releaseHeapsize(){
        //PreviousCC_CostList = null;
        PreviousCC_SBVolumeList = null;
        //PreviousCC_BRSFList = null;
        //InitPreviousCC_BRSFList = null;
        //PreviousCC_ActualCM = null;
        //thisCC_CostList = null;
        thisCC_BRSFList = null;
        //thisCC_BudgetCM = null;
        //CS_list = null;
        //CoveredOutlet = null;
        //POM_SBVolumeList = null;
        //POM_BRSFList = null;
        //v0_BudgetCM = null;
    }
    public date CutOffDate(integer strDay){
        Date returnDate;
        Integer strDate = Date.Today().Day();
        Integer strMonth;
        Integer strEndDay;
        if (strDay != 0){
            if (strDate >= strDay){
                strMonth = Date.Today().Month() - 1;
            }
            else if (strDate < strDay){
                strMonth = Date.Today().Month() - 2;
            }
            strEndDay = Date.daysInMonth(Date.Today().Year(), strMonth);
            returnDate = Date.newinstance(Date.Today().Year(),strMonth,strEndDay);
            //if (returnDate > thisCC.ASI_CRM_CN_PO_End_Date__c){
            //        returnDate = thisCC.ASI_CRM_CN_PO_End_Date__c;
            //    }
        }else{
            returnDate = thisCC.ASI_CRM_CN_PO_End_Date__c;
        }
        //system.debug('CutOffDate: ' + returnDate);
        return returnDate;
    }
    public void checkUserID(){
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId=:UserInfo.getUserId()];
        if(gms.size()>0)
            AdorAbove = true;
    }
    public date getEndDate(date strDate){
        Integer numberOfDays = Date.daysInMonth(strDate.year(), strDate.month());
        Date lastDayOfMonth = Date.newInstance(strDate.year(), strDate.month(), numberOfDays);
        return lastDayofMonth;
    }
    public void checkApprover(){
        AdorAbove = false;
        set<Id> actorIds = new set<Id>();
        for(ProcessInstanceWorkitem piw 
            :[SELECT ActorId FROM ProcessInstanceWorkitem 
              WHERE processinstance.status = 'Pending' AND
              processinstance.targetobjectid = : thisCC.id]) {
                  actorIds.add(piw.ActorId);
              }
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId in :actorIds];
        if(gms.size()>0)
            AdorAbove = true;
    }
    public map<date, decimal> checkFYDayPeriod(date startDate, date endDate){
        map<date, decimal> returnDateMap = new map<date, decimal>();
        Integer EndFY;
        Integer StartFY;
        date returnDate;
        date tempDate = startDate;
        if (startDate != null && endDate != null){
            if (startDate.Month() > 6 && startDate.Month() < 13){
                StartFY = startDate.Year() + 1;
            }
            else if (startDate.Month() < 7 && startDate.Month() > 0){
                StartFY = startDate.Year();
            }
            if (endDate.Month() > 6 && endDate.Month() < 13){
                EndFY = endDate.Year() + 1;
            }
            else if (endDate.Month() < 7 && endDate.Month() > 0){
                EndFY = endDate.Year();
            }
            integer strPeriod = EndFY - StartFY + 1;
            integer strtemp = 0;
            if (strPeriod >= 0){
                for (integer i=0; i<strPeriod; i++){
                    returnDate = Date.newinstance(StartFY,6,30);
                    if (returnDate <= startDate){
                        strtemp = MonthDiff(returnDate, startDate);
                        //system.debug('returnDate <= startDate: ' + returnDate + ' - ' + startDate);
                    }else if (returnDate > startDate && returnDate < endDate){
                        strtemp = MonthDiff(tempDate, returnDate);
                        //system.debug('(returnDate > startDate && returnDate < endDate): ' + tempDate + ' - ' + returnDate);
                    }else if (returnDate >= endDate){
                        strtemp = MonthDiff(tempDate, endDate);
                        //system.debug('returnDate >= endDate: ' + endDate + ' - ' + returnDate);
                    }else if (returnDate >= startDate && returnDate >= endDate){
                        strtemp = MonthDiff(startDate, returnDate);
                        //system.debug('returnDate >= startDate && returnDate >= endDate: ' + startDate + ' - ' + returnDate);
                    }
                    returnDateMap.put(returnDate, decimal.valueof(strtemp));
                    tempDate = Date.newinstance(StartFY,7,1);
                    //system.debug('tempDate: ' + tempDate );
                    StartFY++;
                }
            }
            //system.debug('checkFYDayPeriod: ' + returnDateMap);
            return returnDateMap;
        }else{
            return null;
        }
    }
    public date FYConversion(date strDate){
        date returndate;
        integer EndFY;
        if (strDate.Month() > 6 && strDate.Month() < 13){
            EndFY = strDate.Year() + 1;
        }
        else if (strDate.Month() < 7 && strDate.Month() > 0){
            EndFY = strDate.Year();
        }
        returndate = date.newinstance(EndFY,6,30);
        return returnDate;
    }
    public integer MonthDiff(date startDate, date endDate){
        Integer monthDiff;
        if (startDate != null && endDate != null){
            monthDiff = ((endDate.YEAR() - startDate.YEAR() - 1) *12) + (12 - startDate.MONTH() +1) + endDate.MONTH();
            //system.debug('monthDiff: ' + monthDiff);
            return monthDiff;
        }else{
            return null;
        }
    }
    public string SBGradeSorting(decimal strSeq){
        string returnString;
        if (strSeq != null){
            if (strSeq < 10){
                returnString = '0000' + string.valueof(strSeq);
            }else if (strSeq > 9 && strSeq < 100){
                returnString = '000' + string.valueof(strSeq);
            }else if (strSeq > 99 && strSeq < 1000){
                returnString = '00' + string.valueof(strSeq);
            }else if (strSeq > 999 && strSeq < 10000){
                returnString = '0' + string.valueof(strSeq);
            }
        }else{
            returnString = '00000';
        }
        //system.debug('SBGradeSorting: ' + returnString);
        return returnString;
    }
}