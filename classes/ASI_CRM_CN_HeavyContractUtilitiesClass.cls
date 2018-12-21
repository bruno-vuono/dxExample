/* Filename:    ASI_CRM_CN_HeavyContractUtilitiesClass.cls
* Author:      Laputa
* Purpose:     CRM 4.2 CN help Class
* History  : Compare ASI_CRM_CN_ContractEmailCtrl  && ASI_CRM_CN_ContractEmail_Cmpnt
* -----------------------------------------------------------------------------
* 2017-07-29   Laputa      Created
*/

public class ASI_CRM_CN_HeavyContractUtilitiesClass {
    
    
    //'Financial Indicator' Data structure for checking point // PDF // Email // ROI  //  √ 
    public class FinancialIndicator { 
        public Decimal Volumes  {set;get;} {Volumes=0.0;}  //Intake(9L)
        public Decimal IntakeSTD  {set;get;} {IntakeSTD=0.0;}  //Intake(std. btl) 
        
        public Map<String,Decimal> SubBrandGradeMap  {set;get;} {SubBrandGradeMap = new Map<String,Decimal>();}  // For PDF 
        public Map<String,Decimal> SubBrandGradeGrouping  {set;get;} {SubBrandGradeGrouping = new Map<String,Decimal>();}  //For Check point
        public Map<String,Decimal> CategoryMap  {set;get;} {CategoryMap = new Map<String,Decimal>();}
        public Map<String,ContractLine> ContractLineMap  {set;get;} {ContractLineMap = new Map<String,ContractLine>();}
        public Map<String,ContractLine> FixedExpensesMap  {set;get;} {FixedExpensesMap = new Map<String,ContractLine>();}
        public Map<String,ContractLine> VariableExpensesMap  {set;get;} {VariableExpensesMap = new Map<String,ContractLine>();}
        
        public Decimal TradeExpenses  {set;get;} {TradeExpenses=0.0;}     
        public Decimal GrossSalesTotal  {set;get;} {GrossSalesTotal=0.0;}
        public Decimal GrossSalesRate  {set;get;} {GrossSalesRate=0.0;}
        public Decimal VariableExpense  {set;get;} {VariableExpense=0.0;}  // Theoretical Amount in PO Modification Data
        public Decimal FixedExpense  {set;get;} {FixedExpense=0.0;}    
        public Decimal FixedExpenseRate  {set;get;} {FixedExpenseRate=0.0;}  
        public Decimal IntakeCR12  {set;get;} {IntakeCR12=0.0;}   //Intake (CR12) 
        public Decimal CMTotal {set;get;} {CMTotal=0.0;} 
        public Decimal InvestmentCR12  {set;get;} {InvestmentCR12=0.0;}// Investment per CR12 eq btl
        
        public Decimal LatestBudgetCMTotal  {set;get;} {LatestBudgetCMTotal=0.0;}
        
        public Decimal MarginAfterAnP  {set;get;} {MarginAfterAnP=0.0;}
        public Decimal MarginPerBottle  {set;get;} {MarginPerBottle=0.0;}
        public Decimal ROIIntake  {set;get;} {ROIIntake=0.0;}
        public Decimal ROIActual  {set;get;} {ROIActual=0.0;}
        public Decimal ROIProForma  {set;get;} {ROIProForma=0.0;}
        
        public Decimal BCRate  {set;get;} {BCRate=0.0;} 
        
        
        public Decimal TotalBCRate  {set;get;} {TotalBCRate=0.0;}  // Total BC% = (Green Cap + Empty Btl) / Intake;
        public Decimal NetBCRate  {set;get;} {NetBCRate=0.0;}  //Net BC% = (Green Cap + Empty Btl – Black / Grey Caps) / Intake (without coefficient); Only for historical vFINAL
        
        public Decimal TotalMBCRate  {set;get;} {TotalMBCRate=0.0;} 
        public Decimal NetMBCRate  {set;get;} {NetMBCRate=0.0;}  
        
        public set<id> OutletSet {set;get;} {OutletSet=new set<id>();} 
        public Date POStartDate {set;get;} {POStartDate=date.today();} 
        public Date POEndDate {set;get;} {POEndDate=date.today();} 
        public String ContractId {set;get;} {ContractId='';}
        public String BRSFMethodologyName {set;get;} {BRSFMethodologyName='';} 
        public String PSFMethodologyName {set;get;} {PSFMethodologyName='';} 
        public String PSFVolumeBase {set;get;} {PSFVolumeBase='';} 
        
        public Integer NoOfMonths {set;get;} {NoOfMonths=1;}
        public String AddOnString {set;get;} {AddOnString ='';}
        
        Public String CMId  {set;get;} {CMId =' ';}
        Public String GSId  {set;get;} {GSId =' ';}
        //Public String LBCMId  {set;get;} {LBCMId =' ';}
        //Public String LBGSId  {set;get;} {LBGSId =' ';}
        
        public Map<String,String> DebugMap {set;get;} {DebugMap = new  Map<String,String>();}
        public FinancialIndicator(){  
        }
    }
    
    public Class ContractLine{
        public String SubBrandName {set;get;}{SubBrandName='';}
        public String SubBrandCategory {set;get;}{SubBrandCategory='';}
        public String SubBrandGrade {set;get;}{SubBrandGrade='';}
        public String strSubBrand {set;get;}{strSubBrand='';}
        
        
        public Decimal HistoricalBottles  {set;get;} {HistoricalBottles=0.0;}
        public Decimal EstimateBottles  {set;get;} {EstimateBottles=0.0;}
        public Decimal ContractBottles  {set;get;} {ContractBottles=0.0;}
        public Decimal VFinalBottles  {set;get;} {VFinalBottles=0.0;}
        
        public Decimal HistoricalFees  {set;get;} {HistoricalFees=0.0;}
        public Decimal EstimateFees  {set;get;} {EstimateFees=0.0;}
        public Decimal ContractFees  {set;get;} {ContractFees=0.0;}
        public Decimal VFinalFees  {set;get;} {VFinalFees=0.0;}
        
        public Decimal HistoricalTotalFees  {set;get;} {HistoricalTotalFees=0.0;}
        public Decimal EstimateTotalFees  {set;get;} {EstimateTotalFees=0.0;}
        public Decimal ContractTotalFees  {set;get;} {ContractTotalFees=0.0;}
        public Decimal VFinalTotalFees  {set;get;} {VFinalTotalFees=0.0;}
        


        
        //Used in Group Contract:   All period Volume in contract
        public Decimal HistoricalVolume  {set;get;} {HistoricalVolume=0.0;} // All period from contract 
        public Decimal EstimateVolume {set;get;} {EstimateVolume=0.0;}
        public Decimal ContractVolume  {set;get;} {ContractVolume=0.0;}
        public Decimal VFinalVolume  {set;get;} {VFinalVolume=0.0;} //Intake (std. btl.) for full contract period
        
            
        

        //Following used in Group Contract:  
        public Decimal HistoricalActualVolume  {set;get;} {HistoricalActualVolume=0.0;} // All period from Intake. For  Historical , all period, 
        public Decimal VFinalActualVolume  {set;get;} {VFinalActualVolume=0.0;} //For New contract Vfinal,  use prorated
        
        //Used in Group Contract:   All period Volume in contract
        // public Decimal AllPeriodContractVolume  {set;get;} {AllPeriodContractVolume=0.0;} // All period from contract 
        //Used in Group Contract:   All Contract/Estimate Total
        //public Decimal TotalAmount  {set;get;} {TotalAmount=0.0;}
        
        public ContractLine(){  
        }
    }
    
    
    //Data Class for Sub-Brand Sales(CM/GS)
    public Class subbrand_data{ 
        public string SubBrandId {set;get;}
        // public decimal BottleperMonth {set;get;}
        // public decimal FeesperMonth {set;get;}
        public decimal TotalVolume {set;get;}
        public decimal TotalEstVolume {set;get;}
        // public decimal TotalGS {set;get;}
        //public decimal TotalCM {set;get;}
        public decimal GS {set;get;}{GS=0;}
        public decimal CM {set;get;}{CM=0;}
        public decimal latestBudgetCM {set;get;}
        public decimal period {set;get;}
        // public decimal seqence {set;get;}
        public decimal target_vol {set;get;}{target_vol=0;}
        public decimal actual_vol {set;get;}{actual_vol=0;}
        public decimal actualCM {set;get;}{actualCM=0;}
        public decimal actualGS {set;get;}{actualGS=0;}
        
        public string year {set;get;}
        public subbrand_data(){} 
        
    }
    
    
    //New Contract V Final
    
    
    
    
    //PO Modification  Calculation
    //@description: Restructure Current PO Modi Record FI Data 
    //@param: input current Contract
    //@return
    public static void  ReconstructCurrentPOModiFIData(ASI_TH_CRM_Contract__c contract) {
        ASI_TH_CRM_Contract__c thisCC = [SELECT id, Name,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,  ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,  ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,   ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__c, Owner.Name, ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,  ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,  ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c ,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c  FROM ASI_TH_CRM_Contract__c WHERE id = :contract.Id];
        String strRegion= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c != null? thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c :'';
        
        Decimal CMTotal=0;
        Decimal LatestBudgetCMTotal = 0;
        Map<String, Decimal> AdditionalFIMap = new Map<String, Decimal>();
        // Calculate Variable Cost (变动费用) in Theoretical Amount(建议预估金额)
        Decimal TotalVariableCost = 0;
        FinancialIndicator  POModiContractFI= new FinancialIndicator(); 
        POModiContractFI.ContractLineMap = new Map<String,ContractLine>();
        POModiContractFI.ContractId = thisCC.Id;
        POModiContractFI.ContractLineMap = new Map<String,ContractLine>();
        POModiContractFI.BCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c!= null?thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c:0; 
        POModiContractFI.TotalMBCRate = thisCC.ASI_CRM_Martell_BC_Rate__c!= null?thisCC.ASI_CRM_Martell_BC_Rate__c:0; 
        
        
        String V0_0_POId=thisCC.Id;
        IF(thisCC.ASI_CRM_CN_V0_0_PO_version__c!=null){
            V0_0_POId=thisCC.ASI_CRM_CN_V0_0_PO_version__c;
        }
        
        if(thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null){
            POModiContractFI.FixedExpense = thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
        }
        
        if(thisCC.ASI_CRM_CN_No_of_Months__c != 0 &&  thisCC.ASI_CRM_CN_No_of_Months__c != null){
            POModiContractFI.NoOfMonths = Integer.valueOf(thisCC.ASI_CRM_CN_No_of_Months__c);
        }
        POModiContractFI.POStartDate = thisCC.ASI_CRM_CN_PO_Start_Date__c;
        POModiContractFI.POEndDate= thisCC.ASI_CRM_CN_PO_End_Date__c;
        
        //Looping v0.0 Contract Cost
        for (ASI_CRM_Contract_Cost__c v0cost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c FROM ASI_CRM_Contract_Cost__c  
                                                WHERE ASI_CRM_CN_Contract__c = :V0_0_POId])
        {
            if (v0cost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                TotalVariableCost += v0cost.ASI_CRM_CN_Estimate_Amount__c!=null?v0cost.ASI_CRM_CN_Estimate_Amount__c:0;
            }
        }
        
        
        //Contract v0.0 details Line
        for (ASI_CRM_CN_Contract_BRSF_Line_Item__c  ContractLine : [SELECT ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name,
                                                                    ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,
                                                                    ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                                                    FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :V0_0_POId] )
        {
            TotalVariableCost += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
        }
        
        Decimal PSFEstTotal=0;
        Decimal VECEstTotal=0;
        Decimal TotalBackCap=0;
        Decimal Total_IntakeBtl=0;
        Decimal TotalBC =0;
        for (ASI_CRM_Contract_Cost__c pccost : [SELECT Id,Name, ASI_CRM_CN_Activity_Code__r.Name,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c, 
                                                ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c 
                                                FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id])
        {
            if(pccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                POModiContractFI.VariableExpense +=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                if(pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('PSF') || pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('Promotion Service Fee')){
                    PSFEstTotal+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                }
                if(pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('Variable Event Cost') ){
                    VECEstTotal+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                }
            }
            POModiContractFI.TradeExpenses+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
        }
        
        //Looping current contract Detail Lines
        for (ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine : [SELECT Id,ASI_CRM_Volume_Base__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name,ASI_CRM_Type__c,ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c,RecordType.DeveloperName,ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Sub_Brand__r.Name,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Total__c ,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
            
            
            if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null ){
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF'  && ContractLine.ASI_CRM_Module__c!=null && ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c!=null){
                    POModiContractFI.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                }
                
                String LineKey=SBGradeSorting(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;
                if(POModiContractFI.ContractLineMap.containskey(LineKey)){
                    POModiContractFI.ContractLineMap.get(LineKey).VFinalFees = POModiContractFI.ContractLineMap.get(LineKey).VFinalFees + ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                    POModiContractFI.ContractLineMap.get(LineKey).VFinalVolume+=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c:0;
                }else{
                    ContractLine ContractDetail = new ContractLine ();
                    ContractDetail.VFinalFees = ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                    ContractDetail.VFinalTotalFees= ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c *ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c:0;
                    
                    ContractDetail.VFinalVolume=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c:0;
                    ContractDetail.SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;
                    ContractDetail.SubBrandGrade= ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    POModiContractFI.ContractLineMap.put(LineKey,ContractDetail);
                }
                
                
            }
            
            if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' ){
                PSFEstTotal+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
            }
            if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='Variable Event Cost' ){
                VECEstTotal+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
            }
            
            
            if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item'){
                POModiContractFI.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                POModiContractFI.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
            }else{
                POModiContractFI.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                POModiContractFI.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
            }
            
            
        }
        
        AdditionalFIMap.put('PSFEstTotal',PSFEstTotal);
        AdditionalFIMap.put('VECEstTotal',VECEstTotal);
        
        //POModiContractFI.VariableExpense=TotalVariableCost;
        
        map<string, decimal> POMv1_sbvol = new map<string, decimal>(); // Date --->Volume
        set<id> AllOutlet = new set<id>();
        if(thisCC.ASI_CRM_Volume_Option__c == 'Wholesaler Only' ){
            AllOutlet.add(thisCC.ASI_CRM_CN_Outlet_WS__c);
        }else{
            AllOutlet.add(thisCC.ASI_CRM_CN_Outlet_WS__c);
            for (ASI_CRM_CN_Covered_Outlet__c CO_temp: [SELECT ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
                AllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c); 
            }
        }
        
        POModiContractFI.OutletSet=AllOutlet;
        
        Date CutOffDay =GenerateCutOffDate();
        Date TillEndPOM = FindMinMaxDate(CutOffDay, thisCC.ASI_CRM_CN_PO_End_Date__c, 'MIN');
        date TillEnd;
        if (CutOffDay >= thisCC.ASI_CRM_CN_PO_End_Date__c)
            TillEnd = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c);
        else
            TillEnd = CutOffDay; 
        Integer PeriodA = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, TillEnd);
        Integer PeriodB = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
        
        system.debug(AllOutlet+'ReconstructCurrentPOModiFIData TillEndPOM: ' + TillEndPOM );
        system.debug('PeriodA: '+PeriodA);
        system.debug('PeriodB: '+PeriodB );
        set<id> POMv1_sbid = new set<id>();
        
        Decimal TotalBlackCap_prorate=0;
        Decimal Total_IntakeBtl_prorate=0;
        Decimal TotalBC_prorate=0;
        
        Decimal Total_MartellBC =0;  // total contract Martel BC
        Decimal Total_MartellIntakeBtl =0;  // total contract Martel Intake Btl
        Decimal Total_MartellBlackCap =0;  // total contract Martel BlackCap
        
        
        //**************************Looping Sub-Brand Volume**************************
        for (ASI_CRM_Subbrand_Volume__c SubBrandVolume: [SELECT id,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,
                                                         ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c,ASI_CRM_DeductCapWithIssue_StdBill__c,ASI_CRM_Cap_with_Issues_Std_Billing__c,ASI_CRM_Cap_with_Issues_Std_Btl__c,ASI_CRM_Grey_Cap_Std_Billing__c,ASI_CRM_Black_Cap_Std_Billing__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_Subbrand__r.Name, ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_Empty_Bottle_Std_Btl__c,ASI_CRM_DeductibleCapWithIssues_Std_Btl__c,ASI_CRM_Black_Cap_Btl__c,ASI_CRM_T1_Depletion_STD__c,ASI_CRM_Green_Cap_STD__c,ASI_CRM_T2_Depletion_STD__c,ASI_CRM_PR_Direct_STD__c,ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,ASI_CRM_PR_Direct_CR12__c,  ASI_CRM_End_Date__c,ASI_CRM_Subbrand__c ,ASI_CRM_T1_Depletion__c, ASI_CRM_T2_Depletion__c,ASI_CRM_PR_Direct__c
                                                         FROM ASI_CRM_Subbrand_Volume__c WHERE 
                                                         ASI_CRM_Account__c IN: AllOutlet and ASI_CRM_Subbrand__c !=null 
                                                         AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                                                         AND ASI_CRM_End_Date__c >= :thisCC.ASI_CRM_CN_PO_Start_Date__c
                                                         AND ASI_CRM_End_Date__c <= :TillEndPOM and ASI_CRM_CN_Exclude_From_Payment_Volume__c = false ])
        {
            String SubbrandGroupName='0. Not Specified';
            if(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c != null ){
                SubbrandGroupName=SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c!=null?SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c :SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
            }
            
            Decimal Volumes = 0;
            Volumes += SubBrandVolume.ASI_CRM_T1_Depletion__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion__c:0;
            Volumes += SubBrandVolume.ASI_CRM_T2_Depletion__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion__c:0;
            Volumes += SubBrandVolume.ASI_CRM_PR_Direct__c!=null? SubBrandVolume.ASI_CRM_PR_Direct__c:0;
            
            Decimal VolumeBtl=0;
            VolumeBtl += SubBrandVolume.ASI_CRM_T1_Depletion_STD__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion_STD__c:0;
            VolumeBtl += SubBrandVolume.ASI_CRM_T2_Depletion_STD__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion_STD__c:0;
            VolumeBtl += SubBrandVolume.ASI_CRM_PR_Direct_STD__c!=null? SubBrandVolume.ASI_CRM_PR_Direct_STD__c:0;
            Decimal VariableBottles =0;    
            Decimal VarTotal = VolumeBtl;
            
            //BC
            Decimal BottleCollection=0;
            BottleCollection += SubBrandVolume.ASI_CRM_Green_Cap_STD__c != null? SubBrandVolume.ASI_CRM_Green_Cap_STD__c:0;
            BottleCollection += SubBrandVolume.ASI_CRM_Empty_Bottle_Std_Btl__c != null? SubBrandVolume.ASI_CRM_Empty_Bottle_Std_Btl__c:0;
            
            TotalBC += BottleCollection;
            TotalBC_prorate+=BottleCollection;
            
            //Black Cap ASI_CRM_DeductCapWithIssue_StdBill__c
            Decimal BlackCap=0;
            BlackCap+= SubBrandVolume.ASI_CRM_Cap_with_Issues_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Cap_with_Issues_Std_Billing__c:0;
            
            TotalBackCap+=BlackCap;
            TotalBlackCap_prorate+=BlackCap;
            
            
            Total_IntakeBtl+=VolumeBtl;
            Total_IntakeBtl_prorate+=VolumeBtl;
            
            if( ASI_CRM_CN_HeavyPaymentUtilitiesClass.IsMartellSubBrandOrNot(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c) ){
                Total_MartellBC += BottleCollection;
                Total_MartellIntakeBtl+=VolumeBtl;
                Total_MartellBlackCap+=BlackCap;
            }
            
            
            //**prorate**
            if (PeriodA != 0 && PeriodA != null && PeriodB != 0 && PeriodB != null){
                Volumes = Volumes/PeriodA * PeriodB;
                VolumeBtl = VolumeBtl/PeriodA * PeriodB;
                BlackCap= BlackCap/PeriodA * PeriodB;
                BottleCollection=BottleCollection/PeriodA * PeriodB;
                VariableBottles = VolumeBtl/PeriodB ;//<----Monthly (Std. Btl)                               (VolumeBtl/PeriodA) * PeriodB;
                system.debug(SubBrandVolume.Id+  SubBrandVolume.ASI_CRM_Subbrand__r.Name+ ' VariableBottles : '+VariableBottles);
            }
            TotalBlackCap_prorate+=BlackCap;
            TotalBC_prorate+=BottleCollection;
            Total_IntakeBtl_prorate+=VolumeBtl;
            
            POModiContractFI.IntakeSTD+=VolumeBtl;
            POModiContractFI.Volumes += Volumes;
            
            date pomdate= FYConversion(SubBrandVolume.ASI_CRM_End_Date__c);
            String strkey = string.valueof(pomdate) + SubBrandVolume.ASI_CRM_Subbrand__c;
            
            POModiContractFI.InvestmentCR12 += SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c:0;
            POModiContractFI.InvestmentCR12 += SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c:0;
            POModiContractFI.InvestmentCR12 += SubBrandVolume.ASI_CRM_PR_Direct_CR12__c!=null? SubBrandVolume.ASI_CRM_PR_Direct_CR12__c:0;
            
            
            ////Actual Volume (9L) = T1_Depletion + T2_Depletion + PR_Direct
            Decimal ActualVolume=0;
            ActualVolume+=SubBrandVolume.ASI_CRM_T1_Depletion__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion__c:0;
            ActualVolume+=SubBrandVolume.ASI_CRM_T2_Depletion__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion__c:0;
            ActualVolume+=SubBrandVolume.ASI_CRM_PR_Direct__c!=null? SubBrandVolume.ASI_CRM_PR_Direct__c:0;
            
            //POModiContractFI.Volumes+=ActualVolume;
            if (POMv1_sbvol != null && POMv1_sbvol.containskey(strkey)){
                ActualVolume += POMv1_sbvol.get(strkey);
                POMv1_sbvol.put(strkey, ActualVolume);
            }else{
                POMv1_sbvol.put(strkey,ActualVolume);
            }
            
            POMv1_sbid.add(SubBrandVolume.ASI_CRM_Subbrand__c);
            
            
            
            if(POModiContractFI.SubBrandGradeMap.containskey(SubbrandGroupName)){
                Decimal TempVolumes=POModiContractFI.SubBrandGradeMap.get(SubbrandGroupName)+Volumes;
                //remove orignal one
                POModiContractFI.SubBrandGradeMap.remove(SubbrandGroupName);
                POModiContractFI.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
            }else{
                POModiContractFI.SubBrandGradeMap.put(SubbrandGroupName,Volumes); 
            }
            
            
            
            
            
            //ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c ASI_CRM_Subbrand__r.Name
            
            String SuBBrandKey =SBGradeSorting(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + SubBrandVolume.ASI_CRM_Subbrand__r.Name; 
            
            if(POModiContractFI.ContractLineMap.containskey(SuBBrandKey)){
                POModiContractFI.ContractLineMap.get(SuBBrandKey).VFinalBottles =POModiContractFI.ContractLineMap.get(SuBBrandKey).VFinalBottles + VariableBottles ;
                //POModiContractFI.ContractLineMap.get(SuBBrandKey).VFinalTotalFees +=  POModiContractFI.ContractLineMap.get(SuBBrandKey).VFinalFees * VarTotal;
                POModiContractFI.ContractLineMap.get(SuBBrandKey).VFinalActualVolume = POModiContractFI.ContractLineMap.get(SuBBrandKey).VFinalActualVolume + VariableBottles ;
            }else{
                ContractLine ContractDetail = new ContractLine ();
                ContractDetail.VFinalBottles = VariableBottles;
                ContractDetail.VFinalActualVolume=VariableBottles;
                ContractDetail.SubBrandName=SubBrandVolume.ASI_CRM_Subbrand__r.Name;
                ContractDetail.SubBrandGrade= SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                POModiContractFI.ContractLineMap.put(SuBBrandKey,ContractDetail);
            }
            
            
            
        }// End of Looping Sub-Brand Volume
        
        
        
        system.debug('POModiContractFI Volumes: '+POModiContractFI.Volumes);
        
        AdditionalFIMap.put('Total_MartellBC',Total_MartellBC); 
        AdditionalFIMap.put('Total_MartellIntakeBtl',Total_MartellIntakeBtl); 
        AdditionalFIMap.put('Total_MartellBlackCap',Total_MartellBlackCap); 
        
        
        AdditionalFIMap.put('TotalBackCap',TotalBackCap); 
        AdditionalFIMap.put('TotalBC',TotalBC); 
        AdditionalFIMap.put('Total_IntakeBtl',Total_IntakeBtl); 
        
        AdditionalFIMap.put('TotalBlackCap_prorate',TotalBlackCap_prorate); 
        AdditionalFIMap.put('Total_IntakeBtl_prorate',Total_IntakeBtl_prorate); 
        AdditionalFIMap.put('TotalBC_prorate',TotalBC_prorate); 
        
        if(TotalBC!=0 && TotalBC !=null && Total_IntakeBtl !=null && Total_IntakeBtl!=0){
            POModiContractFI.TotalBCRate=(TotalBC/Total_IntakeBtl)*100;
            POModiContractFI.NetBCRate=((TotalBC-TotalBackCap)/Total_IntakeBtl)*100;
        }


        //Prorate 
        if (thisCC.ASI_CRM_CN_PO_End_Date__c > CutOffDay){
            integer daysperiod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c,  CutOffDay);
            integer prorateperiod = MonthDiff(CutOffDay.addDays(+1), thisCC.ASI_CRM_CN_PO_End_Date__c);
            if (prorateperiod < 0)
                prorateperiod = 0;
            
            decimal AverageCR12= 0;
            decimal Average9L= 0;
            //for Latest Investment CR12
            if (daysperiod != null && daysperiod != 0 && POModiContractFI.InvestmentCR12 != 0)
                AverageCR12 = POModiContractFI.InvestmentCR12 / daysperiod;
            if (prorateperiod != 0 && prorateperiod != null && AverageCR12 != null && AverageCR12 !=0)
                POModiContractFI.InvestmentCR12 += AverageCR12 * prorateperiod ;
            
        }
        
        if (thisCC != null && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != null && POModiContractFI.InvestmentCR12 != 0){
            POModiContractFI.IntakeCR12=POModiContractFI.InvestmentCR12;
            POModiContractFI.InvestmentCR12 = thisCC.ASI_CRM_CN_Total_Contract_Amount__c / POModiContractFI.InvestmentCR12;
        }
        
        
        
        date v1startdate = getEndDate(thisCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1));
        date v1enddate;
        if (thisCC.ASI_CRM_CN_PO_End_Date__c < CutOffDay){
            v1enddate = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c);
        }else{
            v1enddate = CutOffDay;
        }
        
        map<date, decimal> Lastest_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
        system.debug('PO Modi : Lastest_Period_map'+Lastest_Period_map);
        map<string, subbrand_data> Lastest_ROImap = new map <string, subbrand_data>();
        if (Lastest_Period_map != null && Lastest_Period_map.size() > 0){
            String strkey = null;
            for (date v1period : Lastest_Period_map.keyset()){
                if (POMv1_sbid != null && POMv1_sbid.size() > 0){
                    for (id sbid : POMv1_sbid){
                        strkey = string.valueof(v1period) + sbid;
                        //system.debug('strkey: '+strkey);
                        subbrand_data newitem = new subbrand_data();
                        newitem.period = Lastest_Period_map.get(v1period);
                        newitem.SubBrandId = sbid;
                        newitem.year = string.valueof(FYConversion(v1period).year());
                        newitem.totalVolume = 0;
                        Lastest_ROImap.put(strkey, newitem);
                    }
                }
            }
        }
        
        //Calculate RegionSubBrandCM_Map
        string currentFY = String.valueOf(FYConversion(date.Today()).Year());
        string currentFY2 = (integer.valueOf(currentFY) - 1) + '';
        string currentFY3 = (integer.valueOf(currentFY) - 2) + '';

        system.debug('RegionSubBrandCM_Map SQL : currentFY:'+currentFY+'currentFY2:'+currentFY2);
        map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal> ();
        String LBCMIDstr_debug=' ';
        for (ASI_CRM_CM_GS__c lbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c FROM ASI_CRM_CM_GS__c
                                      WHERE ASI_CRM_CN_Month__c = 6  AND (ASI_CRM_YEAR__c = :currentFY OR ASI_CRM_YEAR__c = :currentFY2  OR ASI_CRM_YEAR__c = :currentFY3 ) AND
                                      ASI_CRM_Region__c = :strRegion  AND ASI_CRM_TYPE__c = 'Budget CM'
                                      AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_YEAR__c DESC, ASI_CRM_VERSION__c DESC ])
        {
            string ProductCode = lbcm.ASI_CRM_PRODUCTCODE__c;
            decimal cm=0.0;
            if (lbcm.ASI_CRM_CM_GS_per_9L__c != null){
                cm = lbcm.ASI_CRM_CM_GS_per_9L__c; 
            }
            if (!RegionSubBrandCM_Map.containsKey(ProductCode)){
                LBCMIDstr_debug +=lbcm.Id+',';
                RegionSubBrandCM_Map.put(ProductCode,cm) ;   
            }
        }
        system.debug('LBCMIDstr_debug: '+LBCMIDstr_debug);
        
        map<string, decimal> lastestroi = new map<string, decimal>();
        map<string, decimal> lastestproformaroi = new map<string, decimal>();
        map<string, decimal> Latest_ActualGS = new map<string, decimal>();
        
        system.debug('Now PO Mod v1startdate'+v1startdate);
        system.debug('Now PO Mod v1enddate'+v1enddate);
        
        for (ASI_CRM_CM_GS__c v1budgetcmtemp : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c,ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                                FROM ASI_CRM_CM_GS__c
                                                WHERE ASI_CRM_PRODUCTCODE__c IN :POMv1_sbid 
                                                AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                                AND ASI_CRM_CN_Month_End_Date__c >= :v1startdate
                                                AND ASI_CRM_CN_Month_End_Date__c <= :v1enddate
                                                AND (ASI_CRM_TYPE__c = 'YTD CM' OR ASI_CRM_TYPE__c = 'YTD GS' )
                                                AND ASI_CRM_CM_GS_per_9L__c != 0 AND ASI_CRM_CM_GS_per_9L__c != Null ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
        {
            String strkey = string.valueof(v1budgetcmtemp.ASI_CRM_CN_Month_End_Date__c) + v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c;
            //system.debug('CM GSstrkey:'+strkey);
            String lastestkey = v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c;
            Decimal ActualData = 0;
            
            if (v1budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != null){
                ActualData = v1budgetcmtemp.ASI_CRM_CM_GS_per_9L__c;                
            }
            
            if (v1budgetcmtemp.ASI_CRM_TYPE__c == 'YTD GS'){
                if (!Latest_ActualGS.containskey(v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c)){
                    Latest_ActualGS.put(v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c, v1budgetcmtemp.ASI_CRM_CM_GS_per_9L__c);
                } 
                if (Lastest_ROImap != null && Lastest_ROImap.containskey(strkey)){
                    if (Lastest_ROImap.get(strkey).GS == null || Lastest_ROImap.get(strkey).GS == 0){
                        Lastest_ROImap.get(strkey).GS = ActualData;
                        //POModiContractFI.GSId+=v1budgetcmtemp.Id+';';
                    }
                }
            }
            if (v1budgetcmtemp.ASI_CRM_TYPE__c == 'YTD CM'){
                if (Lastest_ROImap != null && Lastest_ROImap.containskey(strkey)){
                    if (Lastest_ROImap.get(strkey).CM == null || Lastest_ROImap.get(strkey).CM == 0){
                        Lastest_ROImap.get(strkey).CM = ActualData;
                        //POModiContractFI.CMId+=v1budgetcmtemp.Id+';';
                    }
                    //system.debug('Found  GSstrkey:'+v1budgetcmtemp);
                    
                    if (Lastest_ROImap.get(strkey).latestBudgetCM == null || Lastest_ROImap.get(strkey).latestBudgetCM == null){
                        if (RegionSubBrandCM_Map.containsKey(v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c)){
                            Lastest_ROImap.get(strkey).latestBudgetCM = RegionSubBrandCM_Map.get(v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c);
                        }
                    }
                    
                }
                
                if (Lastest_ROImap != null && !lastestroi.containskey(lastestkey) && ActualData != Null && ActualData != 0){//added actualcm != NULL and actualcm != 0
                    lastestroi.put(lastestkey, ActualData);
                }
                if (Lastest_ROImap != null && !lastestproformaroi.containskey(lastestkey)){
                    if (RegionSubBrandCM_Map.containsKey(v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c)) {
                        lastestproformaroi.put(lastestkey, RegionSubBrandCM_Map.get(v1budgetcmtemp.ASI_CRM_PRODUCTCODE__c));
                    }
                }
            }
            
            
            
        }// End of CM/GS Looping
        
        
        if(Lastest_ROImap != null && Lastest_ROImap.size() > 0){
            integer daysperiod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c,  CutOffDay);
            integer prorateperiod = MonthDiff(CutOffDay.addDays(+1), thisCC.ASI_CRM_CN_PO_End_Date__c);
            if (prorateperiod < 0) prorateperiod = 0;
            Decimal Average9L = 0;
            
            for (string v1roitemp : Lastest_ROImap.keyset()){
                Decimal strv1vol = 0;
                decimal prorate_actualcm = 0;
                system.debug('Key v1roitemp'+v1roitemp);
                if (POMv1_sbvol.containskey(v1roitemp)){
                    strv1vol = POMv1_sbvol.get(v1roitemp);
                }
                system.debug('PO Mod Actual Volume'+strv1vol);
                
                //**********Actual CM *********
                Decimal actualcm =0;
                if (Lastest_ROImap.get(v1roitemp).CM != null && Lastest_ROImap.get(v1roitemp).CM != 0){
                    system.debug('Found 1 actualcm'+v1roitemp);
                    actualcm = Lastest_ROImap.get(v1roitemp).CM;
                }else if (lastestroi != null && lastestroi.containskey(Lastest_ROImap.get(v1roitemp).SubBrandId)){
                    actualcm = lastestroi.get(Lastest_ROImap.get(v1roitemp).SubBrandId);
                    system.debug('Found 2 actualcm'+v1roitemp);
                }
                
                if (strv1vol != null && actualcm != null){
                    CMTotal += strv1vol * actualcm; // ROI_POM.strTotalB
                    system.debug('ROI_POM.strTotalB item: ' + strv1vol + ' * ' + actualcm);
                    Average9L = 0;
                    if (lastestroi != null && lastestroi.containskey(Lastest_ROImap.get(v1roitemp).SubBrandId))
                        prorate_actualcm = lastestroi.get(Lastest_ROImap.get(v1roitemp).SubBrandId);
                    if (strv1vol != 0 && strv1vol != null && daysperiod != null && daysperiod != 0)
                        Average9L = strv1vol / daysperiod;
                    if (Average9L != null && prorateperiod != null && prorate_actualcm != null){
                        CMTotal += Average9L *  prorateperiod * prorate_actualcm;
                        system.debug('log 3.6 CMTotal: ' + Average9L + ' * ' + prorateperiod+ ' * ' +prorate_actualcm);
                    }
                    
                }
                
                //*********Latest Budget CM*********
                Decimal lbcm = 0;
                Decimal prorate_lbcm = 0;
                if (Lastest_ROImap.get(v1roitemp).latestBudgetCM != null && Lastest_ROImap.get(v1roitemp).latestBudgetCM != 0)
                    lbcm = Lastest_ROImap.get(v1roitemp).latestBudgetCM;
                else if (lastestproformaroi != null && lastestproformaroi.containskey(Lastest_ROImap.get(v1roitemp).SubBrandId))
                    lbcm = lastestproformaroi.get(Lastest_ROImap.get(v1roitemp).SubBrandId);
                if (strv1vol != null && lbcm != null){
                    LatestBudgetCMTotal += strv1vol * lbcm; //ROI_POM.ProFormaROIstrTotalB
                    Average9L = 0;
                    if (lastestproformaroi != null && lastestproformaroi.containskey(Lastest_ROImap.get(v1roitemp).SubBrandId))
                        prorate_lbcm = lastestproformaroi.get(Lastest_ROImap.get(v1roitemp).SubBrandId);
                    if (strv1vol != 0 && strv1vol != null && daysperiod != null && daysperiod != 0)
                        Average9L = strv1vol / daysperiod;
                    if (Average9L != null && prorateperiod != null && prorate_lbcm != null)
                        LatestBudgetCMTotal += Average9L *  prorateperiod * prorate_lbcm;   //ROI_POM.ProFormaROIstrTotalB
                }
                
                //**********Actual GS*********
                Decimal ActualGS = null;
                if (Lastest_ROImap.get(v1roitemp).GS != null && Lastest_ROImap.get(v1roitemp).GS != 0){
                    ActualGS = Lastest_ROImap.get(v1roitemp).GS;
                }else{
                    if (Latest_ActualGS != null && Latest_ActualGS.containskey(Lastest_ROImap.get(v1roitemp).SubBrandId)){
                        ActualGS = Latest_ActualGS.get(Lastest_ROImap.get(v1roitemp).SubBrandId);
                    }else{
                        ActualGS=0;
                    }
                }
                
                if (strv1vol != null && ActualGS != null){
                    POModiContractFI.GrossSalesTotal += ActualGS * strv1vol;
                }
                
                Decimal ActualGS_prorate = 0;
                if (latest_ActualGS != null && latest_ActualGS.containskey(Lastest_ROImap.get(v1roitemp).SubBrandId)){
                    ActualGS_prorate = Latest_ActualGS.get(Lastest_ROImap.get(v1roitemp).SubBrandId);
                }  
                
                if(ActualGS_prorate!=null && strv1vol!=null && daysperiod!=null && daysperiod!=0 && prorateperiod!=null){
                //if (prorateperiod != null && prorateperiod != 0 && strv1vol != null && strv1vol != 0 && PeriodD_prorate != null && ActualGS_prorate != null && daysperiod!=null && daysperiod !=0){
                   POModiContractFI.GrossSalesTotal  += ActualGS_prorate * (strv1vol / daysperiod )* prorateperiod;
                }
                
                
            }
        }
        
        AdditionalFIMap.put('CMTotal',CMTotal);
        AdditionalFIMap.put('LatestBudgetCMTotal',LatestBudgetCMTotal);
        
        POModiContractFI.CMTotal=CMTotal;
        if (CMTotal != null && CMTotal != 0 && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != 0 && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != null){
            POModiContractFI.ROIIntake = POModiContractFI.CMTotal / thisCC.ASI_CRM_CN_Total_Contract_Amount__c; // ROI_POM.strB
        }
        
        if (LatestBudgetCMTotal != null && LatestBudgetCMTotal != 0 && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != 0 && thisCC.ASI_CRM_CN_Total_Contract_Amount__c != null){
            POModiContractFI.LatestBudgetCMTotal=LatestBudgetCMTotal;
            POModiContractFI.ROIProForma = LatestBudgetCMTotal / thisCC.ASI_CRM_CN_Total_Contract_Amount__c; //ROI_POM.ProFormaROIstrB 
        }
        
        
        
        
        
        list<ASI_CRM_subbrand_Volume__c> v0_VolList = new list<ASI_CRM_Subbrand_Volume__c>();
        date v0TillEndPOM = getEndDate(FindMinMaxDate(CutOffDay, thisCC.ASI_CRM_CN_PO_End_Date__c, 'MIN'));
        system.debug('PO Modi:AllOutlet'+AllOutlet);
        system.debug('PO Modi:Start Date'+thisCC.ASI_CRM_CN_PO_Start_Date__c);
        system.debug('PO Modi:End Date'+v0TillEndPOM);
        v0_VolList = [SELECT id, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,  ASI_CRM_PR_Direct_CR12__c,ASI_CRM_End_Date__c,ASI_CRM_Subbrand__c
                      FROM ASI_CRM_Subbrand_Volume__c WHERE  ASI_CRM_Account__c IN: AllOutlet AND ASI_CRM_CN_Competitor_Sub_brand__c != true  
                      AND ASI_CRM_End_Date__c >= :thisCC.ASI_CRM_CN_PO_Start_Date__c  AND ASI_CRM_End_Date__c <= :v0TillEndPOM AND ASI_CRM_CN_Exclude_From_Payment_Volume__c = FALSE];
        
        
        decimal v0_actualvol_pom = 0;
        
        if (v0_VolList != null && v0_VolList.size() > 0){
            for(ASI_CRM_Subbrand_Volume__c v0vol : v0_VolList){
                if (v0vol.ASI_CRM_T1_Depletion_CR12__c != null)
                    v0_actualvol_pom += v0vol.ASI_CRM_T1_Depletion_CR12__c;
                if (v0vol.ASI_CRM_T2_Depletion_CR12__c != null)
                    v0_actualvol_pom += v0vol.ASI_CRM_T2_Depletion_CR12__c;
                if (v0vol.ASI_CRM_PR_Direct_CR12__c != null)
                    v0_actualvol_pom += v0vol.ASI_CRM_PR_Direct_CR12__c;
            }
        }
        
        Decimal v0_estvol_pom=0;
        List<ASI_Attachment__c> AttachmentList= [select id,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_Contract__c,ASI_CRM_Type__c 
                                                 from ASI_Attachment__c where ASI_CRM_Contract__c = : thisCC.Id and ASI_CRM_Type__c ='Historical Modi Data' ];
        if(AttachmentList.size()>0){
            for(ASI_Attachment__c att:AttachmentList){ 
                String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&quot;','"');
                List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> HistoricalContractList =(List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>.class); // system.debug(HistoricalContractList[0].AddOnString);
                Map<String,Decimal> TempMap = (Map<String,Decimal>)System.JSON.deserialize(HistoricalContractList[0].AddOnString,Map<String,Decimal>.class);
                if( TempMap.containsKey('v0_estvol_pom')  ){
                    v0_estvol_pom= TempMap.get('v0_estvol_pom');
                }
                
            }
        }
        
        
        
        date cutoffend;
        if (CutOffDay > thisCC.ASI_CRM_CN_PO_End_Date__c)
            cutoffend = thisCC.ASI_CRM_CN_PO_End_Date__c;
        else
            cutoffend = CutOffDay;
        Integer thisCCPeriod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
        Integer v0CCPeriod = thisCCPeriod;
        if (thisCC.ASI_CRM_CN_V0_0_PO_version__c != null)
            v0CCPeriod = MonthDiff(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c);
        Integer THCTDPeriod = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, cutoffend);
        Decimal ActVSEst_Vol = 0;
        Decimal v0_actualVol_Period = 0;
        Decimal v0_actualVol_Period_Month = 0;
        AdditionalFIMap.put('v0_actualvol_pom',v0_actualvol_pom);
        
        system.debug('log1.2:'+v0_actualvol_pom + '/'+THCTDPeriod);
        if (THCTDPeriod != null && THCTDPeriod != 0 && v0_actualvol_pom != null && v0_actualvol_pom != 0){
            v0_actualVol_Period_Month =  v0_actualvol_pom /  THCTDPeriod ;
        }
        
        system.debug('log1.3:'+v0_actualVol_Period_Month + '*'+thisCCPeriod);    
        if (v0_actualVol_Period_Month != null && v0_actualVol_Period_Month  != 0 && thisCCPeriod != null && thisCCPeriod != 0){
            v0_actualVol_Period  = v0_actualVol_Period_Month * thisCCPeriod ;
        }
        
        system.debug('log1.3:'+v0_actualVol_Period+'/'+v0_estvol_pom + '*'+v0CCPeriod);  
        
        if (v0_actualVol_Period != null && v0_actualVol_Period != 0 && v0_estvol_pom != null && v0_estvol_pom != 0 && v0CCPeriod != null && v0CCPeriod != 0){
            ActVSEst_Vol = v0_actualVol_Period / (v0_estvol_pom * v0CCPeriod);
        }
        system.debug('log1.4:'+ActVSEst_Vol+'*'+TotalVariableCost );  
        
        if(ActVSEst_Vol!=null){
            ActVSEst_Vol= ActVSEst_Vol*TotalVariableCost; 
        }
        
        AdditionalFIMap.put('ActVSEst_Vol',ActVSEst_Vol);
        
        
        
        POModiContractFI.AddOnString = System.JSON.serialize(AdditionalFIMap);
        
        
        List<FinancialIndicator> ReturnList = new List<FinancialIndicator>();
        ReturnList.add(POModiContractFI);
        UpsertAttachment(thisCC.Id, System.JSON.serialize(ReturnList),'PO Modification Data' );
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //PO Modification  (ASI_CRM_CN_ContractEmailCtrl - 2535)
    //@description: Restructure Historical PO Modi Record FI Data 
    //@param: input current Contract
    //@return
    public static void RestructureHistoricalPOModiFIData(ASI_TH_CRM_Contract__c contract) {
        
        map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal> ();
        Decimal CMTotalV0=0;
        Decimal LatestBudgetCMTotalV0 = 0;
        //Get Current PO data
        ASI_TH_CRM_Contract__c thisCC = [SELECT id, Name,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,  ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,  ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,   ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__c, Owner.Name, ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,  ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,  ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c ,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c  FROM ASI_TH_CRM_Contract__c WHERE id = :contract.Id];
        String strRegion= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c != null? thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c :'';
        String CommercialTeam= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null?thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
        
        
        FinancialIndicator  V0POModiContractFI= new FinancialIndicator(); 
        Map<String, Decimal> AdditionalFIMap = new Map<String, Decimal>();
        V0POModiContractFI.ContractId = thisCC.ASI_CRM_CN_V0_0_PO_version__c;
        
        
        decimal v0_estvol_pom = 0;
        decimal strv0VarCost = 0;
        
        map<id, decimal> BRSF_SBVol = new map<id, decimal>();
        Set<Id> V0SubBrandIdSet= new Set<Id>();
        
        //**************************Looping V0.0 BRSF Lines**************************
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>  ContractLineList = [SELECT Id,ASI_CRM_Type__c,RecordType.DeveloperName,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                                                         FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :
                                                                         thisCC.ASI_CRM_CN_V0_0_PO_version__c];
        
        for (ASI_CRM_CN_Contract_BRSF_Line_Item__c  ContractLine : ContractLineList){
            //if(pombrsf.ASI_CRM_CN_Sub_Brand__c !=null){
                if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||
                 (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null ){
                     
             
                V0SubBrandIdSet.add(ContractLine.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        Map<String,Decimal> CR12FactorMap = GenerateCR12FactorMap(V0SubBrandIdSet, CommercialTeam, strRegion);
        
        for (ASI_CRM_CN_Contract_BRSF_Line_Item__c  pombrsf : ContractLineList){
            decimal brsfvol_roi = 0;
            //if(pombrsf.ASI_CRM_CN_Sub_Brand__c !=null){
            
            if( ((pombrsf.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||  (pombrsf.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && pombrsf.ASI_CRM_Type__c=='BRSF' ) ) && pombrsf.ASI_CRM_CN_Sub_Brand__c!=null ){
                
                decimal v0Brsf = 0;
                if (pombrsf.ASI_CRM_CN_Est_Monthly_Qty__c != null){
                    Decimal CR12Factor=1;
                    if(CR12FactorMap.containsKey(pombrsf.ASI_CRM_CN_Sub_Brand__c)){
                        CR12Factor=CR12FactorMap.get(pombrsf.ASI_CRM_CN_Sub_Brand__c);
                    }
                    v0Brsf = pombrsf.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor;
                }
                v0_estvol_pom += v0Brsf ;
                if (pombrsf.ASI_CRM_CN_No_of_Months__c != null){
                    v0Brsf *= pombrsf.ASI_CRM_CN_No_of_Months__c;
                }
                if (pombrsf.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null){
                    brsfvol_roi = pombrsf.ASI_CRM_CN_Estimate_Volume_9L_Month__c ;
                }
                if (pombrsf.ASI_CRM_CN_Est_Total__c!= null)
                    strv0VarCost += pombrsf.ASI_CRM_CN_Est_Total__c;
                
                V0POModiContractFI.InvestmentCR12 += v0Brsf;
                
                
                if (BRSF_SBVol.containskey(pombrsf.ASI_CRM_CN_Sub_Brand__c)){
                    brsfvol_roi += BRSF_SBVol.get(pombrsf.ASI_CRM_CN_Sub_Brand__c);
                    BRSF_SBVol.put(pombrsf.ASI_CRM_CN_Sub_Brand__c, brsfvol_roi);
                }else{
                    BRSF_SBVol.put(pombrsf.ASI_CRM_CN_Sub_Brand__c, brsfvol_roi);
                }
            }
        }
        AdditionalFIMap.put('v0_estvol_pom',v0_estvol_pom);
        
        system.debug('Now Total Contract Amount: '+thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c);
        system.debug('V0POModiContractFI.InvestmentCR12 '+V0POModiContractFI.InvestmentCR12);
        
        if (V0POModiContractFI.InvestmentCR12 != null && V0POModiContractFI.InvestmentCR12 != 0 && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != null && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != 0)
            V0POModiContractFI.InvestmentCR12 = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c / V0POModiContractFI.InvestmentCR12 ;
        
        date v0startdate= Date.today();
        date v0enddate= Date.today();
        
        if(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!= null){
            v0startdate = getEndDate(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c.addYears(-1));
        }
        
        if(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!= null){   
            v0enddate = getEndDate(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c.addYears(+1));
        }
        
        string currentFY = String.valueOf(FYConversion(date.Today()).Year());
        string currentFY2 = (integer.valueOf(currentFY) - 1) + '';
        string currentFY3 = (integer.valueOf(currentFY) - 2) + '';
        
        //Calculate RegionSubBrandCM_Map
        for (ASI_CRM_CM_GS__c lbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c FROM ASI_CRM_CM_GS__c
                                      WHERE ASI_CRM_CN_Month__c = 6  AND (ASI_CRM_YEAR__c = :currentFY OR ASI_CRM_YEAR__c = :currentFY2 OR ASI_CRM_YEAR__c = :currentFY3 )
                                      AND ASI_CRM_Region__c = :strRegion  AND ASI_CRM_TYPE__c = 'Budget CM' and ASI_CRM_PRODUCTCODE__c IN :V0SubBrandIdSet 
                                      AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  
                                      ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_YEAR__c DESC, ASI_CRM_VERSION__c DESC ])
        {
            
            string ProductCode = lbcm.ASI_CRM_PRODUCTCODE__c;
            decimal cm=0.0;
            if (lbcm.ASI_CRM_CM_GS_per_9L__c != null){
                cm = lbcm.ASI_CRM_CM_GS_per_9L__c; 
            }
            if (!RegionSubBrandCM_Map.containsKey(ProductCode)){
                RegionSubBrandCM_Map.put(ProductCode,cm) ;   
            }
        }
        
        
        
        
        
        
        map<date, decimal> v0_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c);
        map<string, subbrand_data> v0_ROImap = new map <string, subbrand_data>();
        
        if (v0_Period_map != null && v0_Period_map.size() > 0){
            String strkey = null;
            for (date v0period : v0_Period_map.keyset()){
                if (V0SubBrandIdSet != null && V0SubBrandIdSet.size() > 0){
                    for (id sbid : V0SubBrandIdSet){
                        strkey = string.valueof(v0period) + sbid;
                        subbrand_data newitem = new subbrand_data();
                        newitem.period = v0_Period_map.get(v0period);
                        newitem.SubBrandId = sbid;
                        newitem.totalVolume = 0;
                        v0_ROImap.put(strkey, newitem);
                    }
                }
            }
        }
        
        
        //Getting CM GS Data
        
        //Old version
        //date strStartBGDate2 = date.newInstance(v0startdate.addYears(-2).year(), 6, 30);
        //date strEndBGDate2 = date.newInstance(v0enddate.addYears(-1).year(), 6, 30);
        
        
        date strStartBGDate2 = date.newInstance(v0startdate.addYears(-1).year(), 6, 30);
        date strEndBGDate2 = date.newInstance(v0enddate.year(), 6, 30);
        
        Map<String, ASI_CRM_CM_GS__c> cmgsMap = new Map<String, ASI_CRM_CM_GS__c>();   
        
         
        system.debug('PO Modi V0.0 CM GS strStartBGDate:'+v0startdate);
        system.debug('strEndBGDate:'+v0enddate);
        system.debug('strStartBGDate2:'+strStartBGDate2);
        system.debug(' strEndBGDate2:'+strEndBGDate2);

        
        //AND ((ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c AND ASI_CRM_Channel__c = Null   )
         //                                            OR ( ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c 
        //                                                 AND ASI_CRM_Channel__c = : thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c) )
                                                         
        for (ASI_CRM_CM_GS__c v0budgetcmtemp : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c,ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Month__c
                                                FROM ASI_CRM_CM_GS__c  WHERE ASI_CRM_PRODUCTCODE__c IN :V0SubBrandIdSet
                                                AND (ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c   ) 
                                                AND ((ASI_CRM_CN_Month_End_Date__c >= :v0startdate AND ASI_CRM_CN_Month_End_Date__c <= :v0enddate ) OR 
                                                     (ASI_CRM_CN_Month_End_Date__c >= :strStartBGDate2   AND ASI_CRM_CN_Month_End_Date__c <= :strEndBGDate2  AND ASI_CRM_CN_Month__c = 6 ))
                                                AND ASI_CRM_TYPE__c = 'Budget CM' AND ASI_CRM_CM_GS_per_9L__c != 0 AND ASI_CRM_CM_GS_per_9L__c != Null 
                                                ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
        {
            String strkey = string.valueof(v0budgetcmtemp.ASI_CRM_CN_Month_End_Date__c) + v0budgetcmtemp.ASI_CRM_PRODUCTCODE__c;
            decimal budgetcm = 0;
            if(v0budgetcmtemp.ASI_CRM_CN_Month__c == 6 && !cmgsMap.containsKey(v0budgetcmtemp.ASI_CRM_PRODUCTCODE__c + v0budgetcmtemp.ASI_CRM_TYPE__c) && v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != null && v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != 0){
                cmgsMap.put(v0budgetcmtemp.ASI_CRM_PRODUCTCODE__c + v0budgetcmtemp.ASI_CRM_TYPE__c, v0budgetcmtemp);
            }
            if (v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != null)
                budgetcm = v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c;
            if (v0_ROImap != null && v0_ROImap.containskey(strkey)){
                if (v0_ROImap.get(strkey).CM == null || v0_ROImap.get(strkey).CM == 0){
                    
                    if (v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != null && v0budgetcmtemp.ASI_CRM_CM_GS_per_9L__c != 0){
                        v0_ROImap.get(strkey).CM = budgetcm;
                        //V0POModiContractFI.CMId+=v0budgetcmtemp.Id+';';
                    }
                }
                if (v0_ROImap.get(strkey).latestBudgetCM == null ||  v0_ROImap.get(strkey).latestBudgetCM == 0){
                    if (RegionSubBrandCM_Map.containsKey(v0budgetcmtemp.ASI_CRM_PRODUCTCODE__c)){
                        v0_ROImap.get(strkey).latestBudgetCM = RegionSubBrandCM_Map.get(v0budgetcmtemp.ASI_CRM_PRODUCTCODE__c);
                    }
                }
            }
        }
        
        
        //replace null/0 value with latest CMGS data
        for(String key : v0_ROImap.keySet()){
            if(v0_ROImap.get(key).CM == Null || v0_ROImap.get(key).CM == 0 || v0_ROImap.get(key).latestBudgetCM == Null || v0_ROImap.get(key).latestBudgetCM == 0){
                if((v0_ROImap.get(key).CM == Null || v0_ROImap.get(key).CM == 0) && cmgsMap.containsKey(v0_ROImap.get(key).SubBrandId + 'Budget CM')){
                    ASI_CRM_CM_GS__c cmgs = cmgsMap.get(v0_ROImap.get(key).SubBrandId + 'Budget CM');
                    
                    v0_ROImap.get(key).CM = cmgs.ASI_CRM_CM_GS_per_9L__c;
                }
                
                if(v0_ROImap.get(key).latestBudgetCM == Null || v0_ROImap.get(key).latestBudgetCM == 0){
                    if(RegionSubBrandCM_Map.containsKey(v0_ROImap.get(key).SubBrandId)){
                        v0_ROImap.get(key).latestBudgetCM = RegionSubBrandCM_Map.get(v0_ROImap.get(key).SubBrandId);
                    }
                }
            }
        }
        
        
        if (v0_ROImap != null && v0_ROImap.size() > 0){
            for (string roitemp : v0_ROImap.keyset()){
                if (BRSF_SBVol != null && BRSF_SBVol.containskey(v0_ROImap.get(roitemp).SubBrandId)){
                    v0_ROImap.get(roitemp).TotalVolume = BRSF_SBVol.get(v0_ROImap.get(roitemp).SubBrandId);
                }
                if (v0_ROImap.get(roitemp).TotalVolume != null && v0_ROImap.get(roitemp).CM != null && v0_ROImap.get(roitemp).period != null){
                    CMTotalV0 += v0_ROImap.get(roitemp).TotalVolume * v0_ROImap.get(roitemp).CM * v0_ROImap.get(roitemp).period;
                    
                }
                
                if (v0_ROImap.get(roitemp).TotalVolume != null && v0_ROImap.get(roitemp).latestBudgetCM != null && v0_ROImap.get(roitemp).period != null){
                    system.debug('LatestBudgetCMTotalV0: '+LatestBudgetCMTotalV0 +'+='+ v0_ROImap.get(roitemp).TotalVolume +'*'+ v0_ROImap.get(roitemp).latestBudgetCM +'*'+  v0_ROImap.get(roitemp).period);
                    LatestBudgetCMTotalV0 += v0_ROImap.get(roitemp).TotalVolume * v0_ROImap.get(roitemp).latestBudgetCM * v0_ROImap.get(roitemp).period;
                }
                
            }
        }
        
        
        
        if (CMTotalV0 != null && CMTotalV0 != 0 && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != null && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != 0){
            V0POModiContractFI.CMTotal=CMTotalV0;
            V0POModiContractFI.ROIIntake = (CMTotalV0 / thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c).SetSCale(2);
        }
        
        if (LatestBudgetCMTotalV0 != null && LatestBudgetCMTotalV0 != 0 && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != null && thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c != 0){
            V0POModiContractFI.LatestBudgetCMTotal=LatestBudgetCMTotalV0;
            V0POModiContractFI.ROIProForma = (LatestBudgetCMTotalV0 / thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c).SetSCale(2);
        }
        AdditionalFIMap.put('CMTotalV0',CMTotalV0);
        AdditionalFIMap.put('LatestBudgetCMTotalV0',LatestBudgetCMTotalV0);
        V0POModiContractFI.AddOnString = System.JSON.serialize(AdditionalFIMap);
        
        List<FinancialIndicator> RetuenList = new List<FinancialIndicator>();
        RetuenList.add(V0POModiContractFI);
        UpsertAttachment(thisCC.Id, System.JSON.serialize(RetuenList),'Historical Modi Data' );
        
        
        
    }
    
    
    
    
    
    //@description: Restructure current PO Record
    //@param: input current Contract
    //@return NewContactV0Contract and NewContractV0Esitimate
    public static List<FinancialIndicator>  RestructureCurrentFinancialIndicatorData(ASI_TH_CRM_Contract__c contract){
        String strRegion='',CommercialTeam='';
        Set<Id> V00SubBrandIdSet= new Set<Id>();
        Map<String, Decimal> AdditionalFIMap = new Map<String, Decimal>();
        map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal> ();
        //Get Current PO data
        ASI_TH_CRM_Contract__c thisCC = [SELECT id, Name,ASI_CRM_Martell_BC_Rate__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,  ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,  ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,   ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__c, Owner.Name, ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,  ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,  ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c ,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c  FROM ASI_TH_CRM_Contract__c WHERE id = :contract.Id];
        
        strRegion= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c != null? thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c :'';
        CommercialTeam= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null?thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
        
        FinancialIndicator  NewContractV0Esitimate= new FinancialIndicator(); //B    New Contract V0.0 Est.
        FinancialIndicator NewContactV0Contract = new FinancialIndicator(); //D  New Contact V0.0 Contract
        NewContractV0Esitimate.ContractId = thisCC.Id;
        NewContractV0Esitimate.ContractId = thisCC.Id;
        if (thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c != null){
            NewContractV0Esitimate.BCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c;
            NewContactV0Contract.BCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c;
            NewContractV0Esitimate.TotalBCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c;
            NewContactV0Contract.TotalBCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c;
            
            NewContractV0Esitimate.TotalMBCRate = thisCC.ASI_CRM_Martell_BC_Rate__c!= null?thisCC.ASI_CRM_Martell_BC_Rate__c:0; 
            NewContactV0Contract.TotalMBCRate = thisCC.ASI_CRM_Martell_BC_Rate__c!= null?thisCC.ASI_CRM_Martell_BC_Rate__c:0; 
        }
        
        if (thisCC.ASI_CRM_CN_PO_Start_Date__c!= null){
            NewContractV0Esitimate.POStartDate= thisCC.ASI_CRM_CN_PO_Start_Date__c;
            NewContactV0Contract.POStartDate= thisCC.ASI_CRM_CN_PO_Start_Date__c;
        }
        if (thisCC.ASI_CRM_CN_PO_End_Date__c!= null){
            NewContractV0Esitimate.POEndDate= thisCC.ASI_CRM_CN_PO_End_Date__c;
            NewContactV0Contract.POEndDate= thisCC.ASI_CRM_CN_PO_End_Date__c;
        }
        
        if (thisCC.ASI_CRM_CN_Contract_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Cost_Total__c != null){
            NewContactV0Contract.TradeExpenses += thisCC.ASI_CRM_CN_Contract_Cost_Total__c;
            NewContactV0Contract.FixedExpense += thisCC.ASI_CRM_CN_Contract_Cost_Total__c;
        }
        
        if (thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null){
            NewContractV0Esitimate.FixedExpense= thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
        }
        
        //Trade Expenses, Esitmate               
        if (thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c!= 0 &&  thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c!= 0){
            NewContractV0Esitimate.TradeExpenses += thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c;  
        } 
        
        if(thisCC.ASI_CRM_CN_No_of_Months__c != 0 &&  thisCC.ASI_CRM_CN_No_of_Months__c != null){
            NewContactV0Contract.NoOfMonths = Integer.valueOf(thisCC.ASI_CRM_CN_No_of_Months__c);
            NewContractV0Esitimate.NoOfMonths = Integer.valueOf(thisCC.ASI_CRM_CN_No_of_Months__c);
        }
        
        //New Contract Period
        map<date, decimal> thisCC_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
        //key: date+SubBrand    for Current v0.0
        map <string, subbrand_data> current_sbDataROI_map =new map <string, subbrand_data>();
        
        map<id, decimal> ConVolume_map = new map<id, decimal>();        
        map<id, decimal> EstVolume_map  = new map<id, decimal>();
        Decimal BRSFEstimateVolumesTotal=0;
        Decimal BRSFContractVolumesTotal=0;
        
        NewContactV0Contract.ContractLineMap = new Map<String,ContractLine>();
        NewContactV0Contract.FixedExpensesMap = new Map<String,ContractLine>();
        NewContactV0Contract.VariableExpensesMap= new Map<String,ContractLine>();
        
        for (ASI_CRM_Contract_Cost__c  ccost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract_Amount__c,ASI_CRM_CN_Activity_Code__c,
                                                ASI_CRM_CN_Activity_Code__r.ASI_MFM_A_C_Description__c,
                                                ASI_CRM_CN_Estimate_Amount__c, ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c
                                                FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id])
        {
            if (ccost.ASI_CRM_CN_Cost_Type__c == 'Fixed'){
                if (NewContactV0Contract.FixedExpensesMap != null && NewContactV0Contract.FixedExpensesMap.containskey(ccost.Name + ' ' +ccost.ASI_CRM_CN_Chinese_Description__c)){
                    NewContactV0Contract.FixedExpensesMap.get(ccost.Name + ' ' +ccost.ASI_CRM_CN_Chinese_Description__c).EstimateFees+= ccost.ASI_CRM_CN_Estimate_Amount__c !=null? ccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    NewContactV0Contract.FixedExpensesMap.get(ccost.Name + ' ' +ccost.ASI_CRM_CN_Chinese_Description__c).ContractFees+= ccost.ASI_CRM_CN_Contract_Amount__c !=null? ccost.ASI_CRM_CN_Contract_Amount__c:0;
                }else{
                    ContractLine ContractDetail = new ContractLine ();
                    ContractDetail.EstimateFees =ccost.ASI_CRM_CN_Estimate_Amount__c !=null? ccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    ContractDetail.ContractFees = ccost.ASI_CRM_CN_Contract_Amount__c !=null? ccost.ASI_CRM_CN_Contract_Amount__c:0;
                    NewContactV0Contract.FixedExpensesMap.put(ccost.Name + ' ' +ccost.ASI_CRM_CN_Chinese_Description__c,ContractDetail);
                    
                }
            }else{
                String MapKeyStr='';
                if(ccost.ASI_CRM_CN_Activity_Code__c!=null && ccost.ASI_CRM_CN_Activity_Code__r.ASI_MFM_A_C_Description__c!=null){
                    MapKeyStr=ccost.ASI_CRM_CN_Activity_Code__r.ASI_MFM_A_C_Description__c;
                }
                if(NewContactV0Contract.VariableExpensesMap!=null && NewContactV0Contract.FixedExpensesMap.containskey(MapKeyStr)){
                    NewContactV0Contract.VariableExpensesMap.get(MapKeyStr).EstimateFees+= ccost.ASI_CRM_CN_Estimate_Amount__c !=null? ccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    NewContactV0Contract.VariableExpensesMap.get(MapKeyStr).ContractFees+= ccost.ASI_CRM_CN_Contract_Amount__c !=null? ccost.ASI_CRM_CN_Contract_Amount__c:0;
                    
                }else{
                    ContractLine ContractDetail = new ContractLine ();
                    ContractDetail.EstimateFees =ccost.ASI_CRM_CN_Estimate_Amount__c !=null? ccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    ContractDetail.ContractFees = ccost.ASI_CRM_CN_Contract_Amount__c !=null? ccost.ASI_CRM_CN_Contract_Amount__c:0;
                    NewContactV0Contract.VariableExpensesMap.put(MapKeyStr,ContractDetail);
                }
            }
        }
        
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> thisCC_BRSFList = [SELECT Id,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_External_ID__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c,RecordType.DeveloperName, ASI_CRM_CN_Contract_Total_Dummy__c,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c,
                                                                       ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name, 
                                                                       ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c,
                                                                       ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name,
                                                                       ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, 
                                                                       ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,
                                                                       ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c, 
                                                                       ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_Volume_Base__c,ASI_CRM_Type__c  from ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                       WHERE ASI_CRM_CN_Contract__c = :thisCC.id];
        
        Set<String> PSFMethodologySet = new Set<String>();
        Set<String> PSFVolumeBaseSet = new Set<String>();
        //Looping BRSF Line
        for (ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine : thisCC_BRSFList){
            
            if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||
                 (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null ){
                     system.debug('NewcontractV00SubBrandIdSet :'+ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_External_ID__c);
                     //if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){
                     V00SubBrandIdSet.add(ContractLine.ASI_CRM_CN_Sub_Brand__c);
                     Decimal EstimateVolumes=0.0;
                     Decimal ContractVolumes=0.0;
                     
                     //Get All BRSF Estimate Volumes and contract volume 
                     if((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  || (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ){
                         BRSFEstimateVolumesTotal += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c:0;
                         BRSFContractVolumesTotal += ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c:0;
                         if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF'  && ContractLine.ASI_CRM_Module__c!=null && ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c!=null){
                             NewContactV0Contract.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                             NewContractV0Esitimate.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                         }
                     }
                     
                     
                     // (Estimate Qty Convert 9L * No of Months) ASI_CRM_CN_Estimate_Volume_9L_Month__c
                     if (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null && ContractLine.ASI_CRM_CN_No_of_Months__c != null){
                         NewContractV0Esitimate.Volumes += (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c* ContractLine.ASI_CRM_CN_No_of_Months__c);
                         EstimateVolumes = (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c * ContractLine.ASI_CRM_CN_No_of_Months__c);
                     }else{
                         EstimateVolumes = 0;
                     }
                     // Volume 9L (Contract Qty Convert 9L * No of Months) ASI_CRM_CN_Contract_Monthly_Vol9L__c
                     if (ContractLine.ASI_CRM_CN_Contract_Monthly_Vol9L__c != null && ContractLine.ASI_CRM_CN_No_of_Months__c != null){
                         NewContactV0Contract.Volumes += (ContractLine.ASI_CRM_CN_Contract_Monthly_Vol9L__c * ContractLine.ASI_CRM_CN_No_of_Months__c);
                         ContractVolumes = (ContractLine.ASI_CRM_CN_Contract_Monthly_Vol9L__c * ContractLine.ASI_CRM_CN_No_of_Months__c);
                     }else{
                         ContractVolumes = 0;
                     }
                     //Calculate Trade Expenses    
                     
                     //Sub-Brand Grouping for 'NewContractV0Esitimate' and 'NewContactV0Contract'
                     String SubbrandGroupName='0. Not Specified';
                     String SubBrandName='';
                     if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c != null ){
                         SubbrandGroupName=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c!=null? ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c:ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                         SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                         system.debug(SubbrandGroupName+' &&&&&&'+SubBrandName);
                     }
                     system.debug('1170 SubbrandGroupName '+SubbrandGroupName);
                     system.debug(ContractLine);
                     //String SuBBrandKey = SubbrandGroupName+ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;
                     String LineKey=NameSortingASC(ContractLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c) +ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;//SuBBrandKey;//
                     
                     if(NewContactV0Contract.ContractLineMap.containskey(LineKey)){
                         NewContactV0Contract.ContractLineMap.get(LineKey).EstimateBottles += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c:0;
                         NewContactV0Contract.ContractLineMap.get(LineKey).ContractBottles += ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c:0;
                         NewContactV0Contract.ContractLineMap.get(LineKey).EstimateFees += ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null? ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c:0;
                         NewContactV0Contract.ContractLineMap.get(LineKey).ContractFees += ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null? ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c:0;
                         
                         NewContactV0Contract.ContractLineMap.get(LineKey).EstimateVolume +=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c:0;
                         NewContactV0Contract.ContractLineMap.get(LineKey).ContractVolume +=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c:0;
                         
                         
                         
                         
                         if(ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null){
                             NewContactV0Contract.ContractLineMap.get(LineKey).EstimateTotalFees += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c * thisCC.ASI_CRM_CN_No_of_Months__c;
                         }
                         if(ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null ){
                             NewContactV0Contract.ContractLineMap.get(LineKey).ContractTotalFees += ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *thisCC.ASI_CRM_CN_No_of_Months__c;
                         }
                     }else{
                         ContractLine ContractDetail = new ContractLine ();
                         ContractDetail.EstimateBottles=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c:0;
                         ContractDetail.ContractBottles = ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c:0;
                         ContractDetail.EstimateFees  = ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null?ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c:0;
                         ContractDetail.ContractFees =  ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null?ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c:0;
                         
                         ContractDetail.EstimateVolume=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c:0;
                         ContractDetail.ContractVolume=ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c*thisCC.ASI_CRM_CN_No_of_Months__c:0;
                         
                         if(ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null){
                             ContractDetail.EstimateTotalFees = ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c * thisCC.ASI_CRM_CN_No_of_Months__c;
                         }
                         if(ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null ){
                             ContractDetail.ContractTotalFees = ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c *thisCC.ASI_CRM_CN_No_of_Months__c;
                         }
                         ContractDetail.SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;
                         ContractDetail.SubBrandGrade= ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                         NewContactV0Contract.ContractLineMap.put(LineKey,ContractDetail);
                     }
                     
                     
                     if(NewContractV0Esitimate.SubBrandGradeGrouping.containskey(SubBrandName)){
                         Decimal TempVolumes=NewContractV0Esitimate.SubBrandGradeGrouping.get(SubBrandName)+EstimateVolumes;
                         NewContractV0Esitimate.SubBrandGradeGrouping.remove(SubBrandName);//remove orignal one
                         NewContractV0Esitimate.SubBrandGradeGrouping.put(SubBrandName,TempVolumes); 
                     }else{
                         NewContractV0Esitimate.SubBrandGradeGrouping.put(SubBrandName,EstimateVolumes); 
                     }
                     
                     if(NewContactV0Contract.SubBrandGradeGrouping.containskey(SubBrandName)){
                         Decimal TempVolumes=NewContactV0Contract.SubBrandGradeGrouping.get(SubBrandName)+ContractVolumes;
                         NewContactV0Contract.SubBrandGradeGrouping.remove(SubBrandName); //remove orignal one
                         NewContactV0Contract.SubBrandGradeGrouping.put(SubBrandName,TempVolumes); 
                     }else{
                         NewContactV0Contract.SubBrandGradeGrouping.put(SubBrandName,ContractVolumes); 
                     }
                     
                     
                     if(NewContractV0Esitimate.SubBrandGradeMap.containskey(SubbrandGroupName)){
                         Decimal TempVolumes=NewContractV0Esitimate.SubBrandGradeMap.get(SubbrandGroupName)+EstimateVolumes;
                         //remove orignal one
                         NewContractV0Esitimate.SubBrandGradeMap.remove(SubbrandGroupName);
                         NewContractV0Esitimate.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
                     }else{
                         NewContractV0Esitimate.SubBrandGradeMap.put(SubbrandGroupName,EstimateVolumes); 
                     }
                     
                     if(NewContactV0Contract.SubBrandGradeMap.containskey(SubbrandGroupName)){
                         Decimal TempVolumes=NewContactV0Contract.SubBrandGradeMap.get(SubbrandGroupName)+ContractVolumes;
                         //remove orignal one
                         NewContactV0Contract.SubBrandGradeMap.remove(SubbrandGroupName);
                         NewContactV0Contract.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
                     }else{
                         NewContactV0Contract.SubBrandGradeMap.put(SubbrandGroupName,ContractVolumes); 
                     }                
                     
                     //By Brande Product Category Grouping 'NewContractV0Esitimate' and 'NewContactV0Contract'
                     if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c !=null && ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c !=null ){
                         String CategoryName = ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name;
                         if(NewContractV0Esitimate.CategoryMap.containskey(CategoryName)){
                             Decimal TempVolumes=NewContractV0Esitimate.CategoryMap.get(CategoryName)+EstimateVolumes;
                             //remove orignal one
                             NewContractV0Esitimate.CategoryMap.remove(CategoryName);
                             NewContractV0Esitimate.CategoryMap.put(CategoryName,TempVolumes); 
                         }else{
                             NewContractV0Esitimate.CategoryMap.put(CategoryName,EstimateVolumes);
                         }
                         if(NewContactV0Contract.CategoryMap.containskey(CategoryName)){
                             Decimal TempVolumes=NewContactV0Contract.CategoryMap.get(CategoryName)+ContractVolumes;
                             //remove orignal one
                             NewContactV0Contract.CategoryMap.remove(CategoryName);
                             NewContactV0Contract.CategoryMap.put(CategoryName,TempVolumes); 
                         }else{
                             NewContactV0Contract.CategoryMap.put(CategoryName,ContractVolumes);
                         }
                     }// end of By Brande Product Category Grouping      
                     
                     
                     if(thisCC_Period_map != null && thisCC_Period_map.size() > 0){
                         for (date V0CCdate : thisCC_Period_map.keyset() ){
                             date strDateCC = FYConversion(V0CCdate);
                             String strkey_p = string.valueof(strDateCC) + ContractLine.ASI_CRM_CN_Sub_Brand__c ;
                             subbrand_data newitem = new subbrand_data();
                             newitem.period = thisCC_Period_map.get(V0CCdate);//This fiscal year's month number
                             newitem.SubBrandId = ContractLine.ASI_CRM_CN_Sub_Brand__c;
                             newitem.TotalVolume = 0;
                             newitem.TotalEstVolume = 0;
                             current_sbDataROI_map.put(strkey_p, newitem);
                         }
                     }
                     
                     if (ConVolume_map.containskey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                         decimal convol = ConVolume_map.get(ContractLine.ASI_CRM_CN_Sub_Brand__c) + ContractLine.ASI_CRM_CN_Contract_Monthly_Vol9L__c;
                         ConVolume_map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, convol);
                     }else{
                         ConVolume_map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Contract_Monthly_Vol9L__c);
                     }
                     
                     if (EstVolume_map.containskey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                         Decimal estvol = EstVolume_map.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c;
                         EstVolume_map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, estvol );
                     }else{
                         EstVolume_map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c);
                     }
                     
                 }else{ // not by sub-Brand
                     //NewContractV0Esitimate.TradeExpenses +=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                     //NewContactV0Contract.TradeExpenses+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c;
                 }
            
            IF(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' && ContractLine.ASI_CRM_Module__c!=null){
                if(!PSFMethodologySet.contains(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name)){
                    PSFMethodologySet.add(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name);
                    NewContactV0Contract.PSFMethodologyName+= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c+';';
                    NewContractV0Esitimate.PSFMethodologyName+=ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c+';';
                }
                if(!PSFVolumeBaseSet.contains(ContractLine.ASI_CRM_Volume_Base__c)){
                    PSFVolumeBaseSet.add(ContractLine.ASI_CRM_Volume_Base__c);
                    NewContactV0Contract.PSFVolumeBase+= VolumeBaseTranslation(ContractLine.ASI_CRM_Volume_Base__c)+';';
                    NewContractV0Esitimate.PSFVolumeBase+=VolumeBaseTranslation(ContractLine.ASI_CRM_Volume_Base__c)+';';
                }
            }
            
            
            //system.debug('Now Est Total Dummy'+ContractLine.ASI_CRM_CN_Est_Total_Dummy__c);
            NewContractV0Esitimate.TradeExpenses+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
            
            NewContactV0Contract.TradeExpenses+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
            
            NewContractV0Esitimate.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
            NewContactV0Contract.VariableExpense+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
            
        }// end of Looping BRSF Line
        
        
        //CR12Factor 
        Map<String,Decimal> CR12FactorMap = GenerateCR12FactorMap(V00SubBrandIdSet, CommercialTeam, strRegion);
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine :thisCC_BRSFList){
            if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||  (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null ){
                
                Decimal CR12Factor=1;
                if(CR12FactorMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                    CR12Factor=CR12FactorMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c);
                }
                system.debug('Estimate CR12 : '+ ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c +'*'+ CR12Factor +'*'+  ContractLine.ASI_CRM_CN_No_of_Months__c);
                system.debug('Contract CR12 : '+ ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c +'*'+ CR12Factor +'*'+  ContractLine.ASI_CRM_CN_No_of_Months__c);
                if (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c != null){
                    NewContractV0Esitimate.IntakeCR12 += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor * ContractLine.ASI_CRM_CN_No_of_Months__c;
                }
                if(ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!= null){
                    NewContactV0Contract.IntakeCR12 += ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * CR12Factor * ContractLine.ASI_CRM_CN_No_of_Months__c;
                }
                
            }
        }
        
        
        //Calculate RegionSubBrandCM_Map
        string currentFY = String.valueOf(FYConversion(date.Today()).Year());
        string currentFY2 = (integer.valueOf(currentFY) - 1) + '';
        string currentFY3 = (integer.valueOf(currentFY) - 2) + '';
        map<string,ASI_CRM_CM_GS__c> SubBrandCM_Map = new map<string,ASI_CRM_CM_GS__c> ();
        
        for (ASI_CRM_CM_GS__c lbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c FROM ASI_CRM_CM_GS__c
                                      WHERE ASI_CRM_CN_Month__c = 6  AND (ASI_CRM_YEAR__c = :currentFY OR ASI_CRM_YEAR__c = :currentFY2 OR ASI_CRM_YEAR__c = :currentFY3) AND
                                      ASI_CRM_Region__c = :strRegion  AND ASI_CRM_TYPE__c = 'Budget CM' 
                                      AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_YEAR__c DESC, ASI_CRM_VERSION__c DESC ])
        {// and ASI_CRM_PRODUCTCODE__c IN :V00SubBrandIdSet 
            string ProductCode = lbcm.ASI_CRM_PRODUCTCODE__c;
            decimal cm=0.0;
            if (lbcm.ASI_CRM_CM_GS_per_9L__c != null){
                cm = lbcm.ASI_CRM_CM_GS_per_9L__c; 
            }
            if (!RegionSubBrandCM_Map.containsKey(ProductCode)){
                RegionSubBrandCM_Map.put(ProductCode,cm) ;   
                SubBrandCM_Map.put(ProductCode,lbcm);
            }
        }
        
        
        
        
        //for querying Budget CM
        date strStartBGDate;
        date strEndBGDate;
        if(thisCC != null && thisCC.ASI_CRM_CN_PO_Start_Date__c != null)
            strStartBGDate = getEndDate(thisCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1));
        if(thisCC != null && thisCC.ASI_CRM_CN_PO_End_Date__c != null)
            strEndBGDate = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c.addYears(+1));
        
        date strStartBGDate2 = date.newInstance(strStartBGDate.addYears(-1).year(), 6, 30);
        date strEndBGDate2 = date.newInstance(strEndBGDate.year(), 6, 30);
        
        Map<String, ASI_CRM_CM_GS__c> cmgsMap = new Map<String, ASI_CRM_CM_GS__c>();
        
        system.debug('RestructureCurrentFinancialIndicatorData CM GS strStartBGDate:'+strStartBGDate);
        system.debug('strEndBGDate:'+strEndBGDate);
        system.debug('strStartBGDate2:'+strStartBGDate2);
        system.debug(' strEndBGDate2:'+strEndBGDate2);

        for (ASI_CRM_CM_GS__c thisbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c,
                                         ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c , ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c , ASI_CRM_CN_Month__c
                                         FROM ASI_CRM_CM_GS__c  WHERE ASI_CRM_PRODUCTCODE__c IN :V00SubBrandIdSet 
                                         AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                         AND ((ASI_CRM_CN_Month_End_Date__c >= :strStartBGDate AND ASI_CRM_CN_Month_End_Date__c <= :strEndBGDate ) OR
                                         (ASI_CRM_CN_Month_End_Date__c >= :strStartBGDate2 AND ASI_CRM_CN_Month_End_Date__c <= :strEndBGDate2 AND ASI_CRM_CN_Month__c = 6 ))
                                         AND (ASI_CRM_TYPE__c = 'Budget CM' OR ASI_CRM_TYPE__c = 'Budget GS')
                                         AND ASI_CRM_CM_GS_per_9L__c != 0 AND ASI_CRM_CM_GS_per_9L__c != Null
                                         ORDER BY ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
        {
             //system.debug('new thisbcm New contract :'+thisbcm);    
            Date strCMdate = thisbcm.ASI_CRM_CN_Month_End_Date__c;
            String strkey = string.valueof(strCMdate) + thisbcm.ASI_CRM_PRODUCTCODE__c;
            
            if(thisbcm.ASI_CRM_CN_Month__c == 6 && !cmgsMap.containsKey(thisbcm.ASI_CRM_PRODUCTCODE__c + thisbcm.ASI_CRM_TYPE__c) && thisbcm.ASI_CRM_CM_GS_per_9L__c != null && thisbcm.ASI_CRM_CM_GS_per_9L__c != 0){
                cmgsMap.put(thisbcm.ASI_CRM_PRODUCTCODE__c + thisbcm.ASI_CRM_TYPE__c, thisbcm);
            }
            
            if (current_sbDataROI_map.containskey(strkey)){
                if (thisbcm.ASI_CRM_TYPE__c == 'Budget CM'){
                    if (current_sbDataROI_map.get(strkey).CM == null || current_sbDataROI_map.get(strkey).CM == 0){
                        current_sbDataROI_map.get(strkey).CM = thisbcm.ASI_CRM_CM_GS_per_9L__c;
                        //NewContactV0Contract.CMId+=thisbcm.Id+';';
                    }
                    /*if (current_sbDataROI_map.get(strkey).latestBudgetCM == null){ current_sbDataROI_map.get(strkey).latestBudgetCM =thisbcm.ASI_CRM_CM_GS_per_9L__c;}*/
                }
                
                if (thisbcm.ASI_CRM_TYPE__c == 'Budget GS'){
                    if (current_sbDataROI_map.get(strkey).GS == null || current_sbDataROI_map.get(strkey).GS == 0){
                        current_sbDataROI_map.get(strkey).GS= thisbcm.ASI_CRM_CM_GS_per_9L__c;
                        //NewContactV0Contract.GSId+=thisbcm.Id+';';
                    }
                }
                
                if (current_sbDataROI_map.containskey(strkey)){
                    if (current_sbDataROI_map.get(strkey).latestBudgetCM == null){
                        if ( RegionSubBrandCM_Map.containsKey(thisbcm.ASI_CRM_PRODUCTCODE__c)){
                            system.debug('RestructureCurrentFinancialIndicatorData 222： '+SubBrandCM_Map.get(thisbcm.ASI_CRM_PRODUCTCODE__c));
                            current_sbDataROI_map.get(strkey).latestBudgetCM = RegionSubBrandCM_Map.get(thisbcm.ASI_CRM_PRODUCTCODE__c);
                        }
                    }
                }
                
            }  
        }// End of looping Budget CM/GS
        
        
        //Replace null/0 value with latest CMGS data
        
        for(String key : current_sbDataROI_map.keySet()){
            if(current_sbDataROI_map.get(key).CM == Null || current_sbDataROI_map.get(key).CM == 0 || current_sbDataROI_map.get(key).GS == Null || 
               current_sbDataROI_map.get(key).GS == 0 || current_sbDataROI_map.get(key).latestBudgetCM == Null || current_sbDataROI_map.get(key).latestBudgetCM == 0){
                 system.debug('new contract Replace 00');
                if((current_sbDataROI_map.get(key).CM == Null || current_sbDataROI_map.get(key).CM == 0) && cmgsMap.containsKey(current_sbDataROI_map.get(key).SubBrandId + 'Budget CM')){
                    ASI_CRM_CM_GS__c cmgs = cmgsMap.get(current_sbDataROI_map.get(key).SubBrandId + 'Budget CM');
                    
                    current_sbDataROI_map.get(key).CM = cmgs.ASI_CRM_CM_GS_per_9L__c;
                    system.debug('new contract Replace 1');
                }
                
                if((current_sbDataROI_map.get(key).GS == Null || current_sbDataROI_map.get(key).GS == 0) && cmgsMap.containsKey(current_sbDataROI_map.get(key).SubBrandId + 'Budget GS')){
                    ASI_CRM_CM_GS__c cmgs = cmgsMap.get(current_sbDataROI_map.get(key).SubBrandId + 'Budget GS');
                    current_sbDataROI_map.get(key).GS = cmgs.ASI_CRM_CM_GS_per_9L__c;
                    system.debug('new contract Replace 2');
                }
                
                if(current_sbDataROI_map.get(key).latestBudgetCM == Null || current_sbDataROI_map.get(key).latestBudgetCM == 0){
                    if(RegionSubBrandCM_Map.containsKey(current_sbDataROI_map.get(key).SubBrandId))
                        current_sbDataROI_map.get(key).latestBudgetCM = RegionSubBrandCM_Map.get(current_sbDataROI_map.get(key).SubBrandId);
                    system.debug('new contract Replace 3');
                }
            }
        }
        
        
        Decimal CMTotalV0Estimate=0;
        Decimal CMTotalV0Contract=0;
        Decimal LatestBudgetCMTotalV0Estimate = 0;
        Decimal LatestBudgetCMTotalV0Contract = 0;
        
        if (current_sbDataROI_map != null && current_sbDataROI_map.size() > 0){
            decimal ActualCM;
            decimal LatestBudgetCM; // lbcm--> LatestBudgetCM
            decimal ActualGS;
            decimal TotalActualVol;// totalactualvol--->TotalActualVol
            decimal TotalEstimateVol; // totalestimatevol--> TotalEstimateVol
            decimal PeriodStr; //change from strperiod to PeriodStr
            for (string key : current_sbDataROI_map.keyset()){
                PeriodStr= null;
                if (current_sbDataROI_map.get(key).period != null){
                    PeriodStr = current_sbDataROI_map.get(key).period;
                }
                
                //Budget CM
                ActualCM = null;
                if (current_sbDataROI_map.get(key).CM != null){
                    ActualCM = current_sbDataROI_map.get(key).CM;
                }
                
                //Latest Budget CM
                LatestBudgetCM = null;
                if (current_sbDataROI_map.get(key).latestBudgetCM != null){
                    LatestBudgetCM = current_sbDataROI_map.get(key).latestBudgetCM;
                }
                //Budget GS
                ActualGS = null;
                if (current_sbDataROI_map.get(key).GS != null){
                    ActualGS = current_sbDataROI_map.get(key).GS;
                }
                
                //Total Volume
                TotalActualVol = null;
                if (ConVolume_map != null && current_sbDataROI_map.get(key) != null && current_sbDataROI_map.get(key).SubBrandId != null && ConVolume_map.containskey(current_sbDataROI_map.get(key).SubBrandId)){
                    TotalActualVol = ConVolume_map.get(current_sbDataROI_map.get(key).SubBrandId);
                }
                TotalEstimateVol = null;
                if (EstVolume_map != null && current_sbDataROI_map.get(key) != null && current_sbDataROI_map.get(key).SubBrandId != null && EstVolume_map.containskey(current_sbDataROI_map.get(key).SubBrandId)){
                    TotalEstimateVol = EstVolume_map.get(current_sbDataROI_map.get(key).SubBrandId);
                }
                if (TotalEstimateVol != null && ActualCM != null && PeriodStr != null){
                    CMTotalV0Estimate += ActualCM * TotalEstimateVol * PeriodStr;
                    system.debug('New contract CMTotalV0Estimate: '+ ActualCM +'*'+ TotalEstimateVol+'*'+ PeriodStr);
                }
                
                if (TotalEstimateVol != null && LatestBudgetCM != null && PeriodStr != null){
                    system.debug('LatestBudgetCMTotalV0: '+ LatestBudgetCM+ '*'+ TotalEstimateVol + '*'+  PeriodStr);
                    LatestBudgetCMTotalV0Estimate += LatestBudgetCM * TotalEstimateVol * PeriodStr;
                }
                
                if (TotalEstimateVol != null && ActualGS != null && PeriodStr != null){
                    NewContractV0Esitimate.GrossSalesTotal += ActualGS * TotalEstimateVol * PeriodStr;
                }               
                if (TotalActualVol != null && ActualCM != null && PeriodStr != null){
                    CMTotalV0Contract += ActualCM * TotalActualVol * PeriodStr;
                }
                
                if (TotalActualVol != null && LatestBudgetCM != null && PeriodStr != null){
                    LatestBudgetCMTotalV0Contract += LatestBudgetCM * TotalActualVol * PeriodStr;
                }
                
                if (TotalActualVol != null && ActualGS != null && PeriodStr != null){
                    NewContactV0Contract.GrossSalesTotal += ActualGS * TotalActualVol * PeriodStr;
                }
                
            }
        } // end of looping current_sbDataROI_map 
        
        //**************************Calculation**************************
        
        if(NewContractV0Esitimate.TradeExpenses !=0 && NewContractV0Esitimate.TradeExpenses !=null ){
            NewContractV0Esitimate.FixedExpenseRate = (NewContractV0Esitimate.FixedExpense / NewContractV0Esitimate.TradeExpenses *100).SetSCale(2);
            
        }
        if(NewContactV0Contract.TradeExpenses !=0 && NewContactV0Contract.TradeExpenses !=null ){
            NewContactV0Contract.FixedExpenseRate = (NewContactV0Contract.FixedExpense / NewContactV0Contract.TradeExpenses *100).SetSCale(2);  
        }
        
        //Calculate 'Investment per CR12 eq btl ' = Trade expenses / (CR12 Conversion Factor in Sub-brand * estimate Monthly vol. * PO Period in Sub-Brand )
        if (NewContractV0Esitimate.IntakeCR12 != 0 && NewContractV0Esitimate.IntakeCR12!= null &&  NewContractV0Esitimate.TradeExpenses != 0 &&  NewContractV0Esitimate.TradeExpenses != null){
            //NewContractV0Esitimate.IntakeCR12=NewContractV0Esitimate.InvestmentCR12;
            NewContractV0Esitimate.InvestmentCR12 =  (NewContractV0Esitimate.TradeExpenses / NewContractV0Esitimate.IntakeCR12).SetSCale(2);
        }
        if (NewContactV0Contract.IntakeCR12 != 0 && NewContactV0Contract.IntakeCR12!= null &&  NewContactV0Contract.TradeExpenses != 0 &&  NewContactV0Contract.TradeExpenses != null){
            //NewContactV0Contract.IntakeCR12=NewContactV0Contract.InvestmentCR12;
            NewContactV0Contract.InvestmentCR12 =  (NewContactV0Contract.TradeExpenses / NewContactV0Contract.IntakeCR12).SetSCale(2);
        }
        
        //Calculate Historical V0 Cont. Margin after A&P = SUM( Budget CMs * estimate Monthly vol. in 9L  of PO period) - Trade expenses
        if (CMTotalV0Estimate != null && NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.MarginAfterAnP = CMTotalV0Estimate - NewContractV0Esitimate.TradeExpenses;
        }
        if (CMTotalV0Estimate != null && NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.MarginAfterAnP = CMTotalV0Contract - NewContactV0Contract.TradeExpenses;
        }
        
        if (BRSFContractVolumesTotal != null && NewContractV0Esitimate.NoOfMonths != null){//system.debug(NewContactV0Contract.MarginAfterAnP +'VarExp_AllProducts.strB1.0'+BRSFContractVolumesTotal+'*'+NewContractV0Esitimate.NoOfMonths);
            
            //NewContractV0Esitimate.MarginPerBottle =BRSFContractVolumesTotal * NewContractV0Esitimate.NoOfMonths;
            NewContractV0Esitimate.IntakeSTD=BRSFEstimateVolumesTotal * NewContractV0Esitimate.NoOfMonths;
        }
        if (BRSFEstimateVolumesTotal != null && NewContractV0Esitimate.NoOfMonths != null){//system.debug(NewContractV0Esitimate.MarginAfterAnP +'VarExp_AllProducts.strB'+BRSFEstimateVolumesTotal+'*'+NewContactV0Contract.NoOfMonths);
            //NewContactV0Contract.MarginPerBottle =BRSFEstimateVolumesTotal * NewContractV0Esitimate.NoOfMonths;
            NewContactV0Contract.IntakeSTD = BRSFContractVolumesTotal* NewContactV0Contract.NoOfMonths;
        }
        
        
        //Margin Per Bottle
        if (NewContractV0Esitimate.IntakeSTD!= 0 && NewContractV0Esitimate.IntakeSTD != null && NewContractV0Esitimate.MarginAfterAnP != 0 && NewContractV0Esitimate.MarginAfterAnP != null){
            NewContractV0Esitimate.MarginPerBottle = (NewContractV0Esitimate.MarginAfterAnP /NewContractV0Esitimate.IntakeSTD).SetSCale(2);
        }
        if (NewContactV0Contract.IntakeSTD!= 0 && NewContactV0Contract.IntakeSTD != null && NewContactV0Contract.MarginAfterAnP != 0 && NewContactV0Contract.MarginAfterAnP != null){
            NewContactV0Contract.MarginPerBottle = (NewContactV0Contract.MarginAfterAnP / NewContactV0Contract.IntakeSTD).SetSCale(2);
        }
        
        //Gross Sales Rate Historical V0
        if (NewContractV0Esitimate.GrossSalesTotal  != null && NewContractV0Esitimate.GrossSalesTotal  != 0 && NewContractV0Esitimate.TradeExpenses!= 0 && NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.GrossSalesRate = (NewContractV0Esitimate.TradeExpenses / NewContractV0Esitimate.GrossSalesTotal  *100).SetSCale(2);
        }
        if (NewContactV0Contract.GrossSalesTotal  != null && NewContactV0Contract.GrossSalesTotal  != 0 && NewContactV0Contract.TradeExpenses!= 0 && NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.GrossSalesRate = (NewContactV0Contract.TradeExpenses / NewContactV0Contract.GrossSalesTotal  *100).SetSCale(2);
        }
        
        
        // ROI Intake Historical V0 = Cont. Margin before A&P / Trade expenses
        if (CMTotalV0Estimate != null && CMTotalV0Estimate != 0 && NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.CMTotal=CMTotalV0Estimate;
            NewContractV0Esitimate.ROIIntake = (CMTotalV0Estimate / NewContractV0Esitimate.TradeExpenses).SetSCale(2);
            NewContractV0Esitimate.ROIActual=NewContractV0Esitimate.ROIIntake;
        }                
        
        if (CMTotalV0Contract != null && CMTotalV0Contract != 0 && NewContactV0Contract.TradeExpenses != 0 && NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.CMTotal=CMTotalV0Contract;
            NewContactV0Contract.ROIIntake = CMTotalV0Contract / NewContactV0Contract.TradeExpenses;
            NewContactV0Contract.ROIActual=NewContactV0Contract.ROIIntake;
        }
        
        //Calculate ROIProForma = Cont. Margin before A&P from latest CM regardless FY / Trade expenses 
        if (LatestBudgetCMTotalV0Estimate != null && LatestBudgetCMTotalV0Estimate != 0 && NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses!= null){
            NewContractV0Esitimate.LatestBudgetCMTotal=LatestBudgetCMTotalV0Estimate;
            NewContractV0Esitimate.ROIProForma = LatestBudgetCMTotalV0Estimate/ NewContractV0Esitimate.TradeExpenses;
        }
        
        if (LatestBudgetCMTotalV0Contract != null && LatestBudgetCMTotalV0Contract != 0 && NewContactV0Contract.TradeExpenses != 0 && NewContactV0Contract.TradeExpenses!= null){
            NewContactV0Contract.LatestBudgetCMTotal=LatestBudgetCMTotalV0Contract;
            NewContactV0Contract.ROIProForma = LatestBudgetCMTotalV0Contract/ NewContactV0Contract.TradeExpenses;
        }
        
        List<FinancialIndicator> ReturnList = new List<FinancialIndicator>();
        
        ReturnList.add(NewContractV0Esitimate);
        system.debug(NewContractV0Esitimate);
        system.debug(NewContactV0Contract);
        ReturnList.add(NewContactV0Contract);
        system.debug('RestructureCurrentFinancialIndicatorData ReturnList');
        system.debug(ReturnList);
        UpsertAttachment(thisCC.Id, System.JSON.serialize(ReturnList),'Contract Data' );
        
        return ReturnList;
    }
    
    
    
    
    
    
    
    
    
    //@description: Restructure latest PO record of the Historical V0.0 and v0.0 PO (historical PO record which its PO end date is within 6 months to the PO start date of the selected PO)
    //@param: input current Contract
    //@return
    public static void RestructureHistoricalFinancialIndicatorData(ASI_TH_CRM_Contract__c contract){
        //Get Current PO data
        ASI_TH_CRM_Contract__c thisCC = [SELECT id, Name,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,  ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,   ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__c, Owner.Name, ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,  ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,  ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c ,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c  FROM ASI_TH_CRM_Contract__c WHERE id = :contract.Id];
        map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal> ();
        //Define variable 
        ASI_TH_CRM_Contract__c PreviousCC = new ASI_TH_CRM_Contract__c();
        FinancialIndicator HistoricalV00Contract = new FinancialIndicator();
        FinancialIndicator HistoricalVFinalContract = new FinancialIndicator();
        date startDate;
        date endDate;
        String strRegion='',CommercialTeam='';
        set<id> HistoricalAllOutlet = new set<id>();
        Map<String, Decimal> AdditionalFIMap = new Map<String, Decimal>();
        //key: date+SubBrand    for historical v0.0
        map <string, subbrand_data> historicalV0_sbDataROI_map =new map <string, subbrand_data>();
        
        //Calculate RegionSubBrandCM_Map
        string currentFY = String.valueOf(FYConversion(date.Today()).Year());
        string currentFY2 = (integer.valueOf(currentFY) - 1) + '';
        string currentFY3 = (integer.valueOf(currentFY) - 2) + '';

        //Finding Old Promotion Types
        Set<String> oldPromotionTypes = new Set<String>();
        if(thisCC.ASI_CRM_New_FY_PO__c){
            for(ASI_CRM_Special_Promotion_Type_Mapping__c obj:[SELECT Id,ASI_CRM_Mapping_of_New_Promotion_Type__c , ASI_CRM_Mapping_of_Old_Promotion_Type__c , ASI_CRM_Mapping_of_New_Promotion_Type__r.ASI_CRM_Promotion_Type__c , ASI_CRM_Mapping_of_Old_Promotion_Type__r.ASI_CRM_Promotion_Type__c FROM ASI_CRM_Special_Promotion_Type_Mapping__c WHERE RecordType.DeveloperName = 'ASI_CRM_CN_Special_Promotion_Type_Mapping' AND ASI_CRM_Mapping_of_New_Promotion_Type__r.ASI_CRM_Promotion_Type__c = : thisCC.ASI_TH_CRM_Promotion_Type__c ]){
                oldPromotionTypes.add(obj.ASI_CRM_Mapping_of_Old_Promotion_Type__r.ASI_CRM_Promotion_Type__c);
            }
        }
        
        
        if (thisCC.ASI_CRM_CN_PO_Start_Date__c != null && thisCC.ASI_CRM_CN_PO_End_Date__c != null && thisCC.ASI_TH_CRM_Promotion_Type__c != null){
            //Criteria within 6 Months (from PO start date)
            Integer strDays = 365/12*6;
            Date strDate = thisCC.ASI_CRM_CN_PO_Start_Date__c - strDays;
            //Retrieve Historical v0.0 contract
            
            try{ 
                PreviousCC = [SELECT id,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_CN_Expected_BRSF_Est_Total__c,ASI_CRM_EVC_Cost_Estimate_Total__c,
                              ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_PO_Version__c,ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_Volume_Option__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c, ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_New_FY_PO__c, ASI_CRM_CN_Status__c
                              FROM ASI_TH_CRM_Contract__c WHERE ASI_CRM_CN_Outlet_WS__c = :thisCC.ASI_CRM_CN_Outlet_WS__c AND ASI_CRM_CN_PO_End_Date__c != null AND
                              ASI_CRM_CN_PO_Start_Date__c != null
                              AND ASI_CRM_CN_PO_End_Date__c <= :thisCC.ASI_CRM_CN_PO_Start_Date__c  AND ASI_CRM_CN_PO_End_Date__c >= :strDate AND 
                              (ASI_TH_CRM_Promotion_Type__c = :thisCC.ASI_TH_CRM_Promotion_Type__c OR ASI_TH_CRM_Promotion_Type__c IN : oldPromotionTypes)
                              AND (ASI_CRM_CN_Status__c = 'Final' OR ASI_CRM_CN_Status__c = 'Archived' OR ASI_CRM_CN_Status__c = 'Submitted') 
                              ORDER BY ASI_CRM_CN_Status__c DESC, ASI_CRM_CN_PO_End_Date__c DESC, Name DESC, ASI_CRM_CN_PO_Version__c DESC LIMIT 1];
            }catch(exception e){
                PreviousCC = new ASI_TH_CRM_Contract__c();
            }
            
            if(PreviousCC!=null && PreviousCC.ASI_CRM_CN_Status__c == 'Archived'){
                String v0Id = PreviousCC.ASI_CRM_CN_V0_0_PO_version__c == Null ? PreviousCC.id : PreviousCC.ASI_CRM_CN_V0_0_PO_version__c;
                List<ASI_TH_CRM_Contract__c> CheckLatestContract  = new List<ASI_TH_CRM_Contract__c>([SELECT id,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_CN_Expected_BRSF_Est_Total__c,ASI_CRM_EVC_Cost_Estimate_Total__c,
                                                                                                      ASI_CRM_CN_PO_Version__c,ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_Volume_Option__c, ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c,ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_CN_Status__c
                                                                                                      FROM ASI_TH_CRM_Contract__c  WHERE ASI_CRM_CN_V0_0_PO_version__c = : v0Id
                                                                                                      AND ASI_CRM_CN_Status__c != 'Draft'  AND (NOT ASI_CRM_CN_Status__c Like 'FY Landing Archive')
                                                                                                      AND ASI_CRM_CN_PO_End_Date__c != null AND ASI_CRM_CN_PO_Start_Date__c != null Order By createddate DESC limit 1]);
                
                if(CheckLatestContract.size()>0){
                    if(CheckLatestContract[0].ASI_CRM_CN_PO_End_Date__c <= thisCC.ASI_CRM_CN_PO_Start_Date__c && CheckLatestContract[0].ASI_CRM_CN_PO_End_Date__c >= strDate){
                        PreviousCC = CheckLatestContract[0];
                    }else{
                        PreviousCC = new ASI_TH_CRM_Contract__c();
                    }
                }
            }
            //End of finding Historical v0.0 contract
        }
        
        
        //Assign/Calculate data
        if(PreviousCC.id != null){
            string HistoricalV00ContractId = null;
            date StartDateExtend;
            date EndDateExtend;
            Set<Id> V00SubBrandIdSet = new Set<Id> ();
            HistoricalAllOutlet.add(PreviousCC.ASI_CRM_CN_Outlet_WS__c);
            //Getting Historical Outlet Id  for vFinal
            if(PreviousCC.ASI_CRM_Volume_Option__c == 'Wholesaler Only' ){
                system.debug('Now Outlet HC:'+PreviousCC.ASI_CRM_CN_Outlet_WS__c);
                HistoricalAllOutlet.add(PreviousCC.ASI_CRM_CN_Outlet_WS__c);
            }else{
                for (ASI_CRM_CN_Covered_Outlet__c CO_temp: [SELECT ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id]){
                    system.debug('Now Outlet HC 2:'+CO_temp.ASI_CRM_CN_Outlet__c);
                    HistoricalAllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
                }
            }
            
            HistoricalVFinalContract.OutletSet=HistoricalAllOutlet;
            
            
            //Contract level Handling
            if(PreviousCC != null && PreviousCC.id != null && PreviousCC.ASI_CRM_CN_V0_0_PO_version__c == null){ 
                HistoricalV00Contract.ContractId = PreviousCC.Id;
                HistoricalV00ContractId = PreviousCC.id;
                
                HistoricalV00Contract.TotalMBCRate = PreviousCC.ASI_CRM_Martell_BC_Rate__c!= null?PreviousCC.ASI_CRM_Martell_BC_Rate__c:0;
                HistoricalV00Contract.BCRate = PreviousCC.ASI_CRM_CN_Bottle_Collection_Rate__c!= null?PreviousCC.ASI_CRM_CN_Bottle_Collection_Rate__c:0;
                HistoricalV00Contract.POStartDate =PreviousCC.ASI_CRM_CN_PO_Start_Date__c!=null?PreviousCC.ASI_CRM_CN_PO_Start_Date__c:null;
                HistoricalV00Contract.POEndDate =PreviousCC.ASI_CRM_CN_PO_End_Date__c!=null?PreviousCC.ASI_CRM_CN_PO_End_Date__c:null;
                
                startDate = PreviousCC.ASI_CRM_CN_PO_Start_Date__c!=null?PreviousCC.ASI_CRM_CN_PO_Start_Date__c:null;
                endDate = PreviousCC.ASI_CRM_CN_PO_End_Date__c!= null?PreviousCC.ASI_CRM_CN_PO_End_Date__c : null;
                StartDateExtend= PreviousCC.ASI_CRM_CN_PO_Start_Date__c!=null? getEndDate(PreviousCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1)) :null;
                EndDateExtend = PreviousCC.ASI_CRM_CN_PO_End_Date__c!=null? getEndDate(PreviousCC.ASI_CRM_CN_PO_End_Date__c.addYears(+1)):null;   
                strRegion= PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c != null? PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c :'';
                CommercialTeam= PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null?PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
                
                //Current Contract is V0.0
                if(PreviousCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != 0 &&  PreviousCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != null)
                    HistoricalV00Contract.TradeExpenses = PreviousCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c;
                if(PreviousCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  PreviousCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)
                    HistoricalV00Contract.FixedExpense = PreviousCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
                if(PreviousCC.ASI_CRM_CN_No_of_Months__c != 0 &&  PreviousCC.ASI_CRM_CN_No_of_Months__c != null)
                    HistoricalV00Contract.NoOfMonths = Integer.valueOf(PreviousCC.ASI_CRM_CN_No_of_Months__c);
                
                
            }else if(PreviousCC != null && PreviousCC.ASI_CRM_CN_V0_0_PO_version__c != null){
                HistoricalV00Contract.ContractId = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.Id;
                HistoricalV00ContractId = PreviousCC.ASI_CRM_CN_V0_0_PO_version__c;
                
                HistoricalV00Contract.TotalMBCRate = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c!=null? PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c:0;
                HistoricalV00Contract.BCRate = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c!=null? PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c:0;
                
                HistoricalV00Contract.POStartDate = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!=null?PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c:Null;
                HistoricalV00Contract.POEndDate = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!=null?PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c:Null;
                
                startDate = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!=null?PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c:Null;
                endDate = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!=null?PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c:Null;
                StartDateExtend= PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!=null? getEndDate(PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c.addYears(-1)) :null;
                EndDateExtend = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!=null? getEndDate(PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c.addYears(+1)):null;   
                strRegion = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c !=null? PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c: '';
                CommercialTeam= PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null?PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
                
                
                //Current Contract is VFinal
                if(PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != 0 &&  PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != null)
                    HistoricalV00Contract.TradeExpenses = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c;
                if(PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)   
                    HistoricalV00Contract.FixedExpense = PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
                if(PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c != 0 &&  PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c != null)
                    HistoricalV00Contract.NoOfMonths = Integer.valueOf(PreviousCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c);
            } else{
                HistoricalV00ContractId = null;
            }
            
            //Historical v0.0 BRSF Line only for By Sub-Brand
            list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> PreviousV0CC_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
            
            system.debug('HistoricalV00ContractId : '+HistoricalV00ContractId);
            if(HistoricalV00ContractId != null){
                map<date, decimal> PreviousV0CC_Period_map = checkFYDayPeriod(startDate, endDate);
                //CMTotalV0 :  Cont. Margin before A&P  
                Decimal CMTotalV0=0;
                Decimal LatestBudgetCMTotalV0 = 0;
                Decimal BRSFEstimateVolumesTotalV0 = 0; // Calculate BRSF Estimate Volumes Total for V0.0 contract
                
                
                List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> BRSFList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
                
                //<Sub-Brand Id, Estimate Volume Amount> : the Estimate Volume for each Sub-Brand Mapping
                Map<string, decimal> EstimateVolumeV0Map =new Map<string, decimal>();
                List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = [SELECT Id,RecordType.DeveloperName, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c,
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_External_ID__c,ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name, 
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c,
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name,
                                                                                ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, 
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c, 
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_Volume_Base__c,ASI_CRM_Type__c  
                                                                                FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c =:HistoricalV00ContractId ];
                
                
                
                for (ASI_CRM_Contract_Cost__c  ccost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c  FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :HistoricalV00ContractId])
                {
                    if (ccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                        HistoricalV00Contract.VariableExpense += ccost.ASI_CRM_CN_Estimate_Amount__c!=null?ccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    }
                }
                
                
                Set<String> PSFMethodologySet = new  Set<String>();
                Set<String> PSFVolumeBaseSet= new  Set<String>();
                //Looping the Contract Line
                for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine : ContractLineList){       //By Sub-Brand
                    //if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){
                    if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  || (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null )
                    {
                        system.debug('V00SubBrandIdSet :'+ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_External_ID__c);
                        V00SubBrandIdSet.add(ContractLine.ASI_CRM_CN_Sub_Brand__c);
                        Decimal V00Volumes = 0; 
                        if (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null && ContractLine.ASI_CRM_CN_No_of_Months__c != null){
                            V00Volumes = (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c* ContractLine.ASI_CRM_CN_No_of_Months__c);
                        }
                        //system.debug(ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c+'V00H	 Volumes: '+ContractLine.ASI_CRM_CN_No_of_Months__c);
                        //Get All BRSF Estimate Volumes
                        if((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  || (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ){
                            BRSFEstimateVolumesTotalV0 += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c:0;
                            BRSFList.add(ContractLine);
                            if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF'  && ContractLine.ASI_CRM_Module__c!=null && ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c!=null){
                                HistoricalV00Contract.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                            }
                        }
                        IF(ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c!=NULL){
                            if(EstimateVolumeV0Map.containskey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                                Decimal TempEstimateVolume = EstimateVolumeV0Map.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+ ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c ;
                                EstimateVolumeV0Map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, TempEstimateVolume);
                            }else{
                                EstimateVolumeV0Map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c);
                            }
                        }
                        
                        
                        //Calculate Volume
                        HistoricalV00Contract.Volumes += V00Volumes;
                        
                        //By Sub-Brand Grade Grouping
                        String SubbrandGroupName='0. Not Specified';
                        String SubBrandName='';
                        if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c != null ){
                            SubbrandGroupName=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c!=null?ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c:ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                            SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                        }
                        
                        if(HistoricalV00Contract.SubBrandGradeGrouping.containskey(SubBrandName)){
                            Decimal TempVolumes=HistoricalV00Contract.SubBrandGradeGrouping.get(SubBrandName)+V00Volumes;
                            HistoricalV00Contract.SubBrandGradeGrouping.remove(SubBrandName);//remove orignal one
                            HistoricalV00Contract.SubBrandGradeGrouping.put(SubBrandName,TempVolumes); 
                        }else{
                            HistoricalV00Contract.SubBrandGradeGrouping.put(SubBrandName,V00Volumes); 
                        }
                        
                        if(HistoricalV00Contract.SubBrandGradeMap.containskey(SubbrandGroupName)){
                            Decimal TempVolumes=HistoricalV00Contract.SubBrandGradeMap.get(SubbrandGroupName)+V00Volumes;
                            //remove orignal one
                            HistoricalV00Contract.SubBrandGradeMap.remove(SubbrandGroupName);
                            HistoricalV00Contract.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
                        }else{
                            HistoricalV00Contract.SubBrandGradeMap.put(SubbrandGroupName,V00Volumes); 
                        }
                        
                        //By Brande Product Category Grouping  
                        if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c !=null && ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c !=null ){
                            String CategoryName = ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name;
                            if(HistoricalV00Contract.CategoryMap.containskey(CategoryName)){
                                Decimal TempVolumes=HistoricalV00Contract.CategoryMap.get(CategoryName)+V00Volumes;
                                //remove orignal one
                                HistoricalV00Contract.CategoryMap.remove(CategoryName);
                                HistoricalV00Contract.CategoryMap.put(CategoryName,TempVolumes); 
                            }else{
                                HistoricalV00Contract.CategoryMap.put(CategoryName,V00Volumes);
                            }
                        }// end of By Brande Product Category Grouping      
                        
                        
                        if (PreviousV0CC_Period_map != null && PreviousV0CC_Period_map.size() > 0){
                            for (date previousV0CCdate : PreviousV0CC_Period_map.keyset() ){
                                
                                date strDateCC = FYConversion(previousV0CCdate);
                                String strkey_p = string.valueof(strDateCC) + ContractLine.ASI_CRM_CN_Sub_Brand__c ;
                                subbrand_data newitem = new subbrand_data();
                                newitem.period = PreviousV0CC_Period_map.get(previousV0CCdate);//This fiscal year's month number
                                newitem.SubBrandId = ContractLine.ASI_CRM_CN_Sub_Brand__c;
                                newitem.TotalVolume = 0;
                                newitem.TotalEstVolume = 0;
                                historicalV0_sbDataROI_map.put(strkey_p, newitem);
                            }
                        }
                        //HistoricalV00Contract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c; 
                        
                    }else{//Not By Sub-Brand
                        
                    }
                    IF(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' && ContractLine.ASI_CRM_Module__c!=null){
                        if(!PSFMethodologySet.contains(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name)){
                            PSFMethodologySet.add(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name);
                            HistoricalV00Contract.PSFMethodologyName+= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c+';';
                        }
                        if(!PSFVolumeBaseSet.contains(ContractLine.ASI_CRM_Volume_Base__c)){
                            PSFVolumeBaseSet.add(ContractLine.ASI_CRM_Volume_Base__c);
                            HistoricalV00Contract.PSFVolumeBase+= VolumeBaseTranslation(ContractLine.ASI_CRM_Volume_Base__c)+';';
                        }
                    }
                    //Estimate contract cost total 
                    if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item'){
                        HistoricalV00Contract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                        HistoricalV00Contract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                    }else{
                        HistoricalV00Contract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                        //SUM(BRSF estimate cost, Other variable cost)
                        HistoricalV00Contract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                    }
                    
                }//end of Looping the Contract Line
                
                
                
                Map<String,Decimal> CR12FactorMap = GenerateCR12FactorMap(V00SubBrandIdSet, CommercialTeam, strRegion);
                for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine :BRSFList){
                    if (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c != null){
                        Decimal CR12Factor=1;
                        if(CR12FactorMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                            CR12Factor=CR12FactorMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c);
                        }//system.debug(' NOW h :'+ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c +'*'+ CR12Factor +'*'+ ContractLine.ASI_CRM_CN_No_of_Months__c);
                        HistoricalV00Contract.IntakeCR12 += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor * ContractLine.ASI_CRM_CN_No_of_Months__c;
                    }
                }
                
                
                date StartDateExtend2 = date.newInstance(StartDateExtend.addYears(-1).year(), 6, 30);
                date EndDateExtend2 = date.newInstance(EndDateExtend.year(), 6, 30);
                
                //Getting GM/GS Data
                
                system.debug(' HistoricalV00Contract Now currentFY : '+currentFY);
                system.debug('Now currentFY2 : '+currentFY2);
                
                for (ASI_CRM_CM_GS__c lbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c FROM ASI_CRM_CM_GS__c
                                              WHERE ASI_CRM_CN_Month__c = 6  AND (ASI_CRM_YEAR__c = :currentFY OR ASI_CRM_YEAR__c = :currentFY2 OR ASI_CRM_YEAR__c = :currentFY3) AND
                                              ASI_CRM_Region__c = :strRegion  AND ASI_CRM_TYPE__c = 'Budget CM'
                                              AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_YEAR__c DESC, ASI_CRM_VERSION__c DESC ])
                {// and ASI_CRM_PRODUCTCODE__c IN :V00SubBrandIdSet 
                    string ProductCode = lbcm.ASI_CRM_PRODUCTCODE__c;
                    decimal cm=0.0;
                    if (lbcm.ASI_CRM_CM_GS_per_9L__c != null){
                        cm = lbcm.ASI_CRM_CM_GS_per_9L__c; 
                    }
                    if (!RegionSubBrandCM_Map.containsKey(ProductCode)){
                        RegionSubBrandCM_Map.put(ProductCode,cm) ;   
                    }
                }
                
                
                Map<String, ASI_CRM_CM_GS__c> cmgsMap = new Map<String, ASI_CRM_CM_GS__c>();   
                system.debug('historicalV0_sbDataROI_map StartDateExtend:'+StartDateExtend);
                system.debug('EndDateExtend:'+EndDateExtend);
                system.debug('StartDateExtend2:'+StartDateExtend2);
                system.debug('EndDateExtend2:'+EndDateExtend2);
                system.debug('strRegion:'+strRegion);
                for (ASI_CRM_CM_GS__c line : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c, ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c , ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Month__c FROM ASI_CRM_CM_GS__c
                                              WHERE ASI_CRM_PRODUCTCODE__c IN :V00SubBrandIdSet   AND ASI_CRM_Region__c = :strRegion AND (ASI_CRM_TYPE__c = 'Budget CM' OR ASI_CRM_TYPE__c = 'Budget GS') 
                                              AND ( (ASI_CRM_CN_Month_End_Date__c >= :StartDateExtend AND ASI_CRM_CN_Month_End_Date__c <= :EndDateExtend )
                                                   OR (ASI_CRM_CN_Month_End_Date__c >= :StartDateExtend2   AND ASI_CRM_CN_Month_End_Date__c <= :EndDateExtend2 
                                                       AND ASI_CRM_CN_Month__c = 6  ) )  
                                              AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
                {
                    
                    String strkey_v0 = string.valueof(line.ASI_CRM_CN_Month_End_Date__c) + line.ASI_CRM_PRODUCTCODE__c;
                    if(line.ASI_CRM_CN_Month__c == 6 && !cmgsMap.containsKey(line.ASI_CRM_PRODUCTCODE__c + line.ASI_CRM_TYPE__c) &&
                       line.ASI_CRM_CM_GS_per_9L__c != null && line.ASI_CRM_CM_GS_per_9L__c != 0){
                        cmgsMap.put(line.ASI_CRM_PRODUCTCODE__c +line.ASI_CRM_TYPE__c, line);
                    }
                    
                    if (historicalV0_sbDataROI_map.containskey(strkey_v0) && line.ASI_CRM_CM_GS_per_9L__c != null && line.ASI_CRM_CM_GS_per_9L__c != 0  ){
                        if ( historicalV0_sbDataROI_map.get(strkey_v0).CM == null || historicalV0_sbDataROI_map.get(strkey_v0).CM == 0 ){
                            if (line.ASI_CRM_TYPE__c == 'Budget CM'){
                                historicalV0_sbDataROI_map.get(strkey_v0).CM = line.ASI_CRM_CM_GS_per_9L__c;
                                //HistoricalV00Contract.CMId+=line.Id+';';
                            }                           
                        }
                        if(historicalV0_sbDataROI_map.get(strkey_v0).GS == null || historicalV0_sbDataROI_map.get(strkey_v0).GS == 0){
                            if (line.ASI_CRM_TYPE__c == 'Budget GS'){
                                historicalV0_sbDataROI_map.get(strkey_v0).GS = line.ASI_CRM_CM_GS_per_9L__c;
                                //HistoricalV00Contract.GSId+=line.Id+';';
                            }
                        }
                        
                        if (historicalV0_sbDataROI_map.containskey(strkey_v0)){
                            if (historicalV0_sbDataROI_map.get(strkey_v0).latestBudgetCM == null || historicalV0_sbDataROI_map.get(strkey_v0).latestBudgetCM == 0){
                                if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                                    historicalV0_sbDataROI_map.get(strkey_v0).latestBudgetCM = RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c);
                                }
                            }
                        }
                    }
                }// End of CM/GS Looping 
                
                
                
                // to replace null value with latest CMGS data
                for(String key : historicalV0_sbDataROI_map.keySet()){
                    if(historicalV0_sbDataROI_map.get(key).CM == Null || historicalV0_sbDataROI_map.get(key).CM == 0 || historicalV0_sbDataROI_map.get(key).GS == Null || historicalV0_sbDataROI_map.get(key).GS == 0 || historicalV0_sbDataROI_map.get(key).latestBudgetCM == Null || historicalV0_sbDataROI_map.get(key).latestBudgetCM == 0){
                        if((historicalV0_sbDataROI_map.get(key).CM == Null || historicalV0_sbDataROI_map.get(key).CM == 0) && 
                           cmgsMap.containsKey(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget CM')){
                            ASI_CRM_CM_GS__c cmgs = cmgsMap.get(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget CM');
                            historicalV0_sbDataROI_map.get(key).CM = cmgs.ASI_CRM_CM_GS_per_9L__c;
                            //HistoricalV00Contract.GSId+=cmgs.Id+';';
                            system.debug(' CM to replace null value with latest CMGS data');
                        }
                        
                        if((historicalV0_sbDataROI_map.get(key).GS == Null || historicalV0_sbDataROI_map.get(key).GS == 0) && cmgsMap.containsKey(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget GS')){
                            ASI_CRM_CM_GS__c cmgs = cmgsMap.get(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget GS');
                            historicalV0_sbDataROI_map.get(key).GS = cmgs.ASI_CRM_CM_GS_per_9L__c;
                            //HistoricalV00Contract.CMId+=cmgs.Id+';';
                            system.debug(' GS to replace null value with latest CMGS data');
                        }
                        
                        if(historicalV0_sbDataROI_map.get(key).latestBudgetCM == Null || historicalV0_sbDataROI_map.get(key).latestBudgetCM == 0){
                            if(RegionSubBrandCM_Map.containsKey(historicalV0_sbDataROI_map.get(key).SubBrandId)){
                                historicalV0_sbDataROI_map.get(key).latestBudgetCM = RegionSubBrandCM_Map.get(historicalV0_sbDataROI_map.get(key).SubBrandId);
                                system.debug('latestBudgetCM  to replace null value with latest CMGS data');
                            }
                            
                        }
                    }
                }
                
                
                
                //Calculate Total CM
                if (historicalV0_sbDataROI_map != null && historicalV0_sbDataROI_map.size() > 0){
                    decimal ActualGS;
                    decimal ActualCM; //Budget CM 
                    decimal LatestBudgetCM; // Latest Budget CM
                    decimal TotalEstimateVol;
                    decimal PeriodStr; // Number of month 
                    
                    for (string key : historicalV0_sbDataROI_map.keyset()){
                        PeriodStr= null;
                        if (historicalV0_sbDataROI_map.get(key).period != null){
                            PeriodStr = historicalV0_sbDataROI_map.get(key).period;
                        }
                        //Budget CM
                        ActualCM = null;
                        if (historicalV0_sbDataROI_map.get(key).CM != null){
                            ActualCM = historicalV0_sbDataROI_map.get(key).CM;
                        }
                        // Latest Budget CM
                        LatestBudgetCM = null;
                        if (historicalV0_sbDataROI_map.get(key).latestBudgetCM != null){
                            LatestBudgetCM = historicalV0_sbDataROI_map.get(key).latestBudgetCM;
                        }
                        //Budget GS
                        ActualGS = null;
                        if (historicalV0_sbDataROI_map.get(key).GS != null){
                            ActualGS = historicalV0_sbDataROI_map.get(key).GS;
                        }
                        TotalEstimateVol = null;
                        if (EstimateVolumeV0Map != null && historicalV0_sbDataROI_map.get(key) != null && historicalV0_sbDataROI_map.get(key).SubBrandId != null && EstimateVolumeV0Map.containskey(historicalV0_sbDataROI_map.get(key).SubBrandId)){
                            TotalEstimateVol = EstimateVolumeV0Map.get(historicalV0_sbDataROI_map.get(key).SubBrandId);
                        }//system.debug('NEW totalestimatevol : '+TotalEstimateVol);                        
                        //Total Volume
                        if (TotalEstimateVol != null && ActualCM != null && PeriodStr != null){
                            CMTotalV0 += ActualCM * TotalEstimateVol * PeriodStr;
                        }
                        
                        if (TotalEstimateVol != null && LatestBudgetCM != null && PeriodStr != null){
                            LatestBudgetCMTotalV0 += LatestBudgetCM * TotalEstimateVol * PeriodStr;
                        }
                        //Gross Sales
                        if (TotalEstimateVol != null && ActualGS != null && PeriodStr != null){
                            HistoricalV00Contract.GrossSalesTotal += ActualGS * TotalEstimateVol * PeriodStr;
                        }
                    }
                }// end of historicalV0_sbDataROI_map Looping 
                
                //**************************Calculation**************************
                
                if(HistoricalV00Contract.TradeExpenses != null && HistoricalV00Contract.TradeExpenses != 0 ){
                    HistoricalV00Contract.FixedExpenseRate = HistoricalV00Contract.FixedExpense / HistoricalV00Contract.TradeExpenses *100;
                    
                }
                
                //Calculate 'Investment per CR12 eq btl ' = Trade expenses / (CR12 Conversion Factor in Sub-brand * estimate Monthly vol. * PO Period in Sub-Brand )
                if (HistoricalV00Contract.IntakeCR12 != 0 && HistoricalV00Contract.IntakeCR12!= null &&  HistoricalV00Contract.TradeExpenses != 0 &&  HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.InvestmentCR12 =  (HistoricalV00Contract.TradeExpenses / HistoricalV00Contract.IntakeCR12).SetSCale(2);
                }
                
                //Calculate Historical V0 Cont. Margin after A&P = SUM( Budget CMs * estimate Monthly vol. in 9L  of PO period) - Trade expenses
                if (CMTotalV0 != null && HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.MarginAfterAnP = CMTotalV0 - HistoricalV00Contract.TradeExpenses;
                }
                
                //
                if (BRSFEstimateVolumesTotalV0 != null && HistoricalV00Contract.NoOfMonths != null){
                    //HistoricalV00Contract.MarginPerBottle =BRSFEstimateVolumesTotalV0 * HistoricalV00Contract.NoOfMonths;
                    HistoricalV00Contract.IntakeSTD=BRSFEstimateVolumesTotalV0 * HistoricalV00Contract.NoOfMonths;
                }
                
                if (HistoricalV00Contract.IntakeSTD!= 0 && HistoricalV00Contract.IntakeSTD != null && HistoricalV00Contract.MarginAfterAnP != 0 && HistoricalV00Contract.MarginAfterAnP != null){
                    HistoricalV00Contract.MarginPerBottle = (HistoricalV00Contract.MarginAfterAnP / HistoricalV00Contract.IntakeSTD).SetSCale(2);
                }
                
                //Gross Sales Rate Historical V0
                if (HistoricalV00Contract.GrossSalesTotal  != null && HistoricalV00Contract.GrossSalesTotal  != 0 && HistoricalV00Contract.TradeExpenses!= 0 && HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.GrossSalesRate = (HistoricalV00Contract.TradeExpenses / HistoricalV00Contract.GrossSalesTotal  * 100).SetSCale(2);
                }
                
                // ROI Intake Historical V0 = Cont. Margin before A&P / Trade expenses
                if (CMTotalV0 != null && CMTotalV0 != 0 && HistoricalV00Contract.TradeExpenses != 0 && HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.CMTotal=CMTotalV0;
                    HistoricalV00Contract.ROIIntake = (CMTotalV0 / HistoricalV00Contract.TradeExpenses).SetSCale(2);
                    HistoricalV00Contract.ROIActual=HistoricalV00Contract.ROIIntake;
                }                
                
                //Calculate ROIProForma = Cont. Margin before A&P from latest CM regardless FY / Trade expenses 
                if (LatestBudgetCMTotalV0 != null && LatestBudgetCMTotalV0 != 0 && HistoricalV00Contract.TradeExpenses != 0 && HistoricalV00Contract.TradeExpenses!= null){
                    HistoricalV00Contract.LatestBudgetCMTotal=LatestBudgetCMTotalV0;
                    HistoricalV00Contract.ROIProForma = (LatestBudgetCMTotalV0/ HistoricalV00Contract.TradeExpenses).SetSCale(2);
                }
                
                
            }//Finished getting/Calculate V0.0 data
            
            
            //
            //******************************************************   Starting Calculating VFinal Data**********************************************
            if(PreviousCC.ASI_CRM_CN_No_of_Months__c != 0 &&  PreviousCC.ASI_CRM_CN_No_of_Months__c != null){
                HistoricalVFinalContract.NoOfMonths = Integer.valueOf(PreviousCC.ASI_CRM_CN_No_of_Months__c);
            }
            
            
            if(PreviousCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  PreviousCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null){
                HistoricalVFinalContract.FixedExpense = PreviousCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
            }
            
           
            HistoricalVFinalContract.BCRate = PreviousCC.ASI_CRM_CN_Bottle_Collection_Rate__c!= null?PreviousCC.ASI_CRM_CN_Bottle_Collection_Rate__c:0;    
            HistoricalVFinalContract.ContractId = PreviousCC.Id;
            HistoricalVFinalContract.POStartDate = PreviousCC.ASI_CRM_CN_PO_Start_Date__c;
            HistoricalVFinalContract.POEndDate= PreviousCC.ASI_CRM_CN_PO_End_Date__c;
            
            HistoricalVFinalContract.ContractLineMap = new Map<String,ContractLine>();
            HistoricalVFinalContract.FixedExpensesMap = new Map<String,ContractLine>();
            Decimal TotalHC_VolumeBtl =0; // total historical contract Volume BTL
            Decimal TotalHC_IntakeBtl =0; 
            Decimal TotalHC_BC =0;  // total historical contract BC
                       
            Decimal TotalBackCap=0;
            Decimal PSFEstTotal=0;
            Decimal VECEstTotal=0;
            
            
             
            Decimal TotalHistorical_MartellBC =0;  // total historical contract Martel BC
            Decimal TotalHistorical_MartellIntakeBtl =0;  // total historical contract Martel Intake Btl
            Decimal TotalHistorical_MartellBlackCap =0;  // total historical contract Martel BlackCap
            
            
            
            
            for (ASI_CRM_Contract_Cost__c pccost : [SELECT Id,Name, ASI_CRM_CN_Activity_Code__c,ASI_CRM_CN_Activity_Code__r.Name,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c, 
                                                    ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c 
                                                    FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id])
            {
                if (pccost.ASI_CRM_CN_Cost_Type__c == 'Fixed' && pccost.ASI_CRM_CN_Estimate_Amount__c != null ){
                    if (HistoricalVFinalContract.FixedExpensesMap.containskey(pccost.Name + ' ' +pccost.ASI_CRM_CN_Chinese_Description__c)){
                        HistoricalVFinalContract.FixedExpensesMap.get(pccost.Name + ' ' +pccost.ASI_CRM_CN_Chinese_Description__c).HistoricalFees += pccost.ASI_CRM_CN_Estimate_Amount__c;
                    }else{
                        ContractLine ContractDetail = new ContractLine ();
                        ContractDetail.HistoricalFees=pccost.ASI_CRM_CN_Estimate_Amount__c;
                        HistoricalVFinalContract.FixedExpensesMap.put(pccost.Name + ' ' +pccost.ASI_CRM_CN_Chinese_Description__c, ContractDetail);
                    }
                }
                if(pccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                    HistoricalVFinalContract.VariableExpense +=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    if(pccost.ASI_CRM_CN_Activity_Code__c!=null ){
                        if(pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('PSF') || pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('Promotion Service Fee')){
                            PSFEstTotal+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                        }
                    }
                    if(pccost.ASI_CRM_CN_Activity_Code__c!=null && pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('Variable Event Cost') ){
                        VECEstTotal+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    }
                    
                }
                HistoricalVFinalContract.TradeExpenses+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
            }
            
            
            
            
            Set<String> PSFMethodologySetVFinal = new Set<String>();
            Set<String> PSFVolumeBaseSetVFinal = new Set<String>();
            
            for (ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine : [SELECT Id,ASI_CRM_Volume_Base__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name,ASI_CRM_Type__c,ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c,RecordType.DeveloperName,ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Sub_Brand__r.Name,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Total__c ,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :PreviousCC.id]){
                
                if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null ){
                    
                    if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF'  && ContractLine.ASI_CRM_Module__c!=null && ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c!=null){
                        HistoricalVFinalContract.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                    }
                    
                    String LineKey=SBGradeSorting(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;//ContractLineSBGradeName; //NameSortingASC(ContractLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c) +SuBBrandKey;//
                    
                    if(HistoricalVFinalContract.ContractLineMap.containskey(LineKey)){
                        HistoricalVFinalContract.ContractLineMap.get(LineKey).HistoricalFees = HistoricalVFinalContract.ContractLineMap.get(LineKey).HistoricalFees + ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                    }else{
                        ContractLine ContractDetail = new ContractLine ();
                        ContractDetail.HistoricalFees = ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                        ContractDetail.SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;
                        ContractDetail.SubBrandGrade= ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                        HistoricalVFinalContract.ContractLineMap.put(LineKey,ContractDetail);
                    }
                }
                
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' ){
                    PSFEstTotal+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                }
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='Variable Event Cost' ){
                    VECEstTotal+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                }
                
                
                IF(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' && ContractLine.ASI_CRM_Module__c!=null){
                    if(!PSFMethodologySetVFinal.contains(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name)){
                        PSFMethodologySetVFinal.add(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name);
                        HistoricalVFinalContract.PSFMethodologyName+= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c+';';
                    }
                    if(!PSFVolumeBaseSetVFinal.contains(ContractLine.ASI_CRM_Volume_Base__c)){
                        PSFVolumeBaseSetVFinal.add(ContractLine.ASI_CRM_Volume_Base__c);
                        HistoricalVFinalContract.PSFVolumeBase+= VolumeBaseTranslation(ContractLine.ASI_CRM_Volume_Base__c)+';';
                    }
                }
                
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item'){
                    HistoricalVFinalContract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                    HistoricalVFinalContract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                    
                }else{
                    HistoricalVFinalContract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                    HistoricalVFinalContract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                }
                
            }
            
            //V0.1+ PO will calculate BRSF + PSF VEC part amount
            if(PreviousCC.ASI_CRM_CN_PO_Version__c!='0.0' && PreviousCC.ASI_TH_CRM_Promotion_Type__c== 'Heavy Contract On'){// ASI_CRM_CN_Total_Contract_Amount__c
                HistoricalVFinalContract.TradeExpenses=PreviousCC.ASI_CRM_CN_Total_Contract_Amount__c;
                HistoricalVFinalContract.VariableExpense=0;
                HistoricalVFinalContract.VariableExpense+=PreviousCC.ASI_CRM_CN_Expected_PSF_Est_Total__c!=null?PreviousCC.ASI_CRM_CN_Expected_PSF_Est_Total__c:0;
                HistoricalVFinalContract.VariableExpense+=PreviousCC.ASI_CRM_CN_Expected_BRSF_Est_Total__c!=null?PreviousCC.ASI_CRM_CN_Expected_BRSF_Est_Total__c:0;
                HistoricalVFinalContract.VariableExpense+=PreviousCC.ASI_CRM_EVC_Cost_Estimate_Total__c!=null?PreviousCC.ASI_CRM_EVC_Cost_Estimate_Total__c:0;
                HistoricalVFinalContract.VariableExpense+=PreviousCC.ASI_CRM_CN_Contract_Variable_Cost_Total__c!=null?PreviousCC.ASI_CRM_CN_Contract_Variable_Cost_Total__c:0;
    
            }
            AdditionalFIMap.put('PSFEstTotal',PSFEstTotal);
            AdditionalFIMap.put('VECEstTotal',VECEstTotal);
            
            
            Set<Id> HistoricalVFinalSBIdSet = new Set<Id> ();         
            Date CutOffDay =GenerateCutOffDate();
            date TillEnd;
            if (CutOffDay >= PreviousCC.ASI_CRM_CN_PO_End_Date__c)
                TillEnd = getEndDate(PreviousCC.ASI_CRM_CN_PO_End_Date__c);
            else
                TillEnd = CutOffDay; 
            
            Integer PeriodA = MonthDiff(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, TillEnd);
            Integer PeriodB = MonthDiff(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, PreviousCC.ASI_CRM_CN_PO_End_Date__c);
            
            Decimal TotalHCVolumeBtl=0;
            map<date, decimal> HistoricalVFinal_Period_map = checkFYDayPeriod(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, PreviousCC.ASI_CRM_CN_PO_End_Date__c);    
            system.debug('PeriodA 0.1: '+PeriodA); 
            system.debug('PeriodB 0.1: '+PeriodB); 
            system.debug('PreviousCC PreviousCC.ASI_CRM_CN_PO_Start_Date__c : '+PreviousCC.ASI_CRM_CN_PO_Start_Date__c ); 
            system.debug('PreviousCC TillEnd 0.1: '+TillEnd); 
            
            HistoricalVFinalContract.DebugMap.put('HistoricalVFTillEnd',string.valueOf(TillEnd));
            map <string, subbrand_data> historical_sbDataROI_map = new map <string, subbrand_data> ();
            List<ASI_CRM_Subbrand_Volume__c> HistoricalSBVolumeList = [SELECT id, Name,ASI_CRM_Cap_with_Issues_Std_Billing__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c,
                                                                       ASI_CRM_DeductCapWithIssue_StdBill__c,ASI_CRM_Grey_Cap_Std_Billing__c,ASI_CRM_Black_Cap_Std_Billing__c,ASI_CRM_Green_Cap_Std_Billing__c,ASI_CRM_Offtake__c,ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_External_ID__c,
                                                                       ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_Code__c,ASI_CRM_Offtake_CR12__c, ASI_CRM_Subbrand__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c, ASI_CRM_Subbrand__r.Name,  ASI_CRM_T1_Depletion_BTL__c, ASI_CRM_Offtake_Btl__c, ASI_CRM_T2_Depletion_BTL__c,ASI_CRM_T1_Depletion__c, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,ASI_CRM_PR_Direct_CR12__c, ASI_CRM_T2_Depletion__c, ASI_CRM_PR_Direct__c, ASI_CRM_PR_Direct_Btl__c,ASI_CRM_End_Date__c ,ASI_CRM_T1_Depletion_STD__c, ASI_CRM_T2_Depletion_STD__c, 
                                                                       ASI_CRM_PR_Direct_STD__c,ASI_CRM_Black_Cap_Btl__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c, ASI_CRM_DeductibleCapWithIssues_Std_Btl__c,ASI_CRM_Green_Cap_STD__c, ASI_CRM_Empty_Bottle_Std_Btl__c
                                                                       FROM ASI_CRM_Subbrand_Volume__c WHERE  ASI_CRM_Account__c IN :HistoricalAllOutlet 
                                                                       AND ASI_CRM_CN_Competitor_Sub_brand__c != true and ASI_CRM_Subbrand__c !=null 
                                                                       AND ASI_CRM_End_Date__c >= :PreviousCC.ASI_CRM_CN_PO_Start_Date__c AND 
                                                                       ASI_CRM_End_Date__c <= :TillEnd AND ASI_CRM_CN_Exclude_From_Payment_Volume__c = FALSE];
            
            set<id> PreviousCC_SBId = new set<id>();
            
            for (ASI_CRM_Subbrand_Volume__c sbid : HistoricalSBVolumeList){
                PreviousCC_SBId.add(sbid.ASI_CRM_Subbrand__c);
            }
            
            for (date PCCperiod: HistoricalVFinal_Period_map.keyset() ){
                if (PreviousCC_SBId.size() > 0){
                    for (id sbidtemp : PreviousCC_SBId){
                        String   PeriodKey = string.valueof(PCCperiod) + sbidtemp;
                        subbrand_data newitem = new subbrand_data();
                        newitem.period = HistoricalVFinal_Period_map.get(PCCperiod);
                        newitem.SubBrandId = sbidtemp;
                        newitem.year = string.valueof(PCCperiod.year());
                        newitem.TotalVolume = 0;
                        historical_sbDataROI_map.put(PeriodKey, newitem);
                        
                    }
                }
            }
            
            Decimal TotalBlackCap_prorate=0;
            Decimal Total_IntakeBtl_prorate=0;
            Decimal TotalBC_prorate=0;
            
            for (ASI_CRM_Subbrand_Volume__c SubBrandVolume: HistoricalSBVolumeList){
                system.debug(SubBrandVolume.Id+ 'HistoricalVFinalSBIdSet SubBrandVolume:'+SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_External_ID__c);
                
                HistoricalVFinalSBIdSet.add(SubBrandVolume.ASI_CRM_Subbrand__c);
                //Calculate Volume 
                Decimal Volumes = 0;
                Volumes += SubBrandVolume.ASI_CRM_T1_Depletion__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion__c:0;
                Volumes += SubBrandVolume.ASI_CRM_T2_Depletion__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion__c:0;
                Volumes += SubBrandVolume.ASI_CRM_PR_Direct__c!=null? SubBrandVolume.ASI_CRM_PR_Direct__c:0;
                
                
                //Intake
                Decimal VolumeBtl=0;
                VolumeBtl += SubBrandVolume.ASI_CRM_T1_Depletion_STD__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion_STD__c:0;
                VolumeBtl += SubBrandVolume.ASI_CRM_T2_Depletion_STD__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion_STD__c:0;
                VolumeBtl += SubBrandVolume.ASI_CRM_PR_Direct_STD__c!=null? SubBrandVolume.ASI_CRM_PR_Direct_STD__c:0;
                TotalHC_IntakeBtl+=VolumeBtl;
                
                //Bottle Collection
                Decimal BottleCollection=0;
                BottleCollection += SubBrandVolume.ASI_CRM_Green_Cap_STD__c != null? SubBrandVolume.ASI_CRM_Green_Cap_STD__c:0;
                BottleCollection += SubBrandVolume.ASI_CRM_Empty_Bottle_Std_Btl__c != null? SubBrandVolume.ASI_CRM_Empty_Bottle_Std_Btl__c:0;
                //BottleCollection += SubBrandVolume.ASI_CRM_DeductibleCapWithIssues_Std_Btl__c != null? SubBrandVolume.ASI_CRM_DeductibleCapWithIssues_Std_Btl__c:0;
                TotalHC_BC += BottleCollection;
             
                //Black Cap ASI_CRM_DeductCapWithIssue_StdBill__c
                Decimal BlackCap=0;
                BlackCap+= SubBrandVolume.ASI_CRM_Cap_with_Issues_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Cap_with_Issues_Std_Billing__c:0;   // BlackCap+= SubBrandVolume.ASI_CRM_Black_Cap_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Black_Cap_Std_Billing__c:0;
                
                TotalBackCap+=BlackCap;   // BlackCap+= SubBrandVolume.ASI_CRM_Grey_Cap_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Grey_Cap_Std_Billing__c:0;
                
                   
                if( ASI_CRM_CN_HeavyPaymentUtilitiesClass.IsMartellSubBrandOrNot(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c) ){
                    system.debug(VolumeBtl+ 'Martell Sub Brand Volume Id: '+SubBrandVolume.Id);
                    
                    TotalHistorical_MartellBC += BottleCollection;
                    TotalHistorical_MartellIntakeBtl+=VolumeBtl;
                    TotalHistorical_MartellBlackCap+=BlackCap;
                }
                
                
                
                
                Decimal VarHistTotal = VolumeBtl;
                Decimal VarHistTotalVolume=Volumes;
                Decimal VariableHistoricalBottles = VolumeBtl/PeriodA;
                
                if (PeriodA != 0 && PeriodA != null && PeriodB != 0 && PeriodB != null){
                    Volumes = Volumes/PeriodA * PeriodB;
                    VolumeBtl = VolumeBtl/PeriodA * PeriodB;
                    BottleCollection = BottleCollection/PeriodA * PeriodB;
                    BlackCap = BlackCap/PeriodA * PeriodB;
                }
                
                
                Total_IntakeBtl_prorate+=VolumeBtl;
                TotalBC_prorate+=BottleCollection;
                TotalBlackCap_prorate+=BlackCap;
                
                TotalHC_VolumeBtl += VolumeBtl;
                // Historical VFinal Contract Volume (in 9L cs) INTAKE (Historical Contract vFinal)
                HistoricalVFinalContract.Volumes += Volumes; 
                //Sub-Brand Grade Grouping
                String SubbrandGroupName='0. Not Specified';
                String SubBrandName='';
                if(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c != null ){
                    SubbrandGroupName=SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c!=null?SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c:SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    SubBrandName=SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                }
                
                if(HistoricalVFinalContract.SubBrandGradeGrouping.containskey(SubBrandName)){
                    Decimal TempVolumes=HistoricalVFinalContract.SubBrandGradeGrouping.get(SubBrandName)+Volumes;
                    //remove orignal one
                    HistoricalVFinalContract.SubBrandGradeGrouping.remove(SubBrandName);
                    HistoricalVFinalContract.SubBrandGradeGrouping.put(SubBrandName,TempVolumes); 
                }else{
                    HistoricalVFinalContract.SubBrandGradeGrouping.put(SubBrandName,Volumes); 
                }
                
                if(HistoricalVFinalContract.SubBrandGradeMap.containskey(SubbrandGroupName)){
                    Decimal TempVolumes=HistoricalVFinalContract.SubBrandGradeMap.get(SubbrandGroupName)+Volumes;
                    //remove orignal one
                    HistoricalVFinalContract.SubBrandGradeMap.remove(SubbrandGroupName);
                    HistoricalVFinalContract.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
                }else{
                    HistoricalVFinalContract.SubBrandGradeMap.put(SubbrandGroupName,Volumes); 
                }
                
                //By Brande Product Category Grouping  
                if(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__c !=null && SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c !=null ){
                    String CategoryName = SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name;
                    if(HistoricalVFinalContract.CategoryMap.containskey(CategoryName)){
                        Decimal TempVolumes=HistoricalVFinalContract.CategoryMap.get(CategoryName)+Volumes;
                        //remove orignal one
                        HistoricalVFinalContract.CategoryMap.remove(CategoryName);
                        HistoricalVFinalContract.CategoryMap.put(CategoryName,TempVolumes); 
                    }else{
                        HistoricalVFinalContract.CategoryMap.put(CategoryName,Volumes);
                    }
                }// end of By Brande Product Category Grouping      
                
                
                date SubbrandVolumeDateKey = FYConversion(SubBrandVolume.ASI_CRM_End_Date__c);
                String SubbrandVolumeStrKey = string.valueof(SubbrandVolumeDateKey) + SubBrandVolume.ASI_CRM_Subbrand__c;
                
                if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(SubbrandVolumeStrKey)){
                    historical_sbDataROI_map.get(SubbrandVolumeStrKey).TotalVolume += VarHistTotalVolume;
                }
                
                String SuBBrandKey =SBGradeSorting(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + SubBrandVolume.ASI_CRM_Subbrand__r.Name; 
                
                if(HistoricalVFinalContract.ContractLineMap.containskey(SuBBrandKey)){
                    HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalBottles =HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalBottles + VariableHistoricalBottles ;
                    HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalTotalFees +=  HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalFees * VarHistTotal;
                }else{
                    ContractLine ContractDetail = new ContractLine ();
                    ContractDetail.HistoricalBottles = VariableHistoricalBottles;
                    //ContractDetail.HistoricalTotalFees=0;
                    ContractDetail.SubBrandName=SubBrandVolume.ASI_CRM_Subbrand__r.Name;
                    ContractDetail.SubBrandGrade= SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    HistoricalVFinalContract.ContractLineMap.put(SuBBrandKey,ContractDetail);
                }
                
                Decimal VolumesCR12 = 0; 
                VolumesCR12 += SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c:0;
                VolumesCR12 += SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c:0;
                VolumesCR12 += SubBrandVolume.ASI_CRM_PR_Direct_CR12__c!=null? SubBrandVolume.ASI_CRM_PR_Direct_CR12__c:0;
                HistoricalVFinalContract.IntakeCR12 += VolumesCR12;
                
            }//end of Sub Brand Volume for looping
            
            
            
            AdditionalFIMap.put('TotalBlackCap_prorate',TotalBlackCap_prorate); 
            AdditionalFIMap.put('Total_IntakeBtl_prorate',Total_IntakeBtl_prorate); 
            AdditionalFIMap.put('TotalBC_prorate',TotalBC_prorate); 
            
           
            //Prorate Investment CR12 for Historical Contract
            if (PeriodA != 0 && PeriodB!= 0 && PeriodA != null && PeriodB!= null){
                HistoricalVFinalContract.IntakeCR12 = HistoricalVFinalContract.IntakeCR12/PeriodA * PeriodB;
            }
            
            
            
            //YTD CM/GS
            map<string, decimal> Latest_ActualCM = new map<string, decimal>();
            map<string, decimal> Latest_ActualGS = new map<string, decimal>();
            map<string, decimal> ProForma_LatestBudgetCM = new map<string, decimal>();
            date HistoricalVFinalStartDate = PreviousCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
            
            system.debug('HistoricalVFinalStartDate : '+HistoricalVFinalStartDate);
            system.debug('HistoricalVFinalStartDate TillEnd : '+TillEnd);
            
            for (ASI_CRM_CM_GS__c line : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c,ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                                          ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                          FROM ASI_CRM_CM_GS__c
                                          WHERE ASI_CRM_PRODUCTCODE__c IN :HistoricalVFinalSBIdSet
                                          AND ASI_CRM_Region__c = :PreviousCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                          AND ASI_CRM_CN_Month_End_Date__c >= :HistoricalVFinalStartDate   AND ASI_CRM_CN_Month_End_Date__c <= :TillEnd 
                                          AND (ASI_CRM_TYPE__c = 'YTD CM' OR ASI_CRM_TYPE__c = 'YTD GS') AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0 ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
            {
                
                String strkey = string.valueof(line.ASI_CRM_CN_Month_End_Date__c) + line.ASI_CRM_PRODUCTCODE__c;
                if (line.ASI_CRM_TYPE__c == 'YTD CM'){
                    
                    if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(strkey)){
                        if (historical_sbDataROI_map.get(strkey).CM == null || historical_sbDataROI_map.get(strkey).CM == 0){
                            historical_sbDataROI_map.get(strkey).CM = line.ASI_CRM_CM_GS_per_9L__c;
                            
                            historical_sbDataROI_map.get(strkey).SubBrandId = line.ASI_CRM_PRODUCTCODE__c;
                        }
                    }
                    if (!Latest_ActualCM.containskey(line.ASI_CRM_PRODUCTCODE__c)){
                        Latest_ActualCM.put(line.ASI_CRM_PRODUCTCODE__c, line.ASI_CRM_CM_GS_per_9L__c);
                    }
                    
                    if(!ProForma_LatestBudgetCM.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                        if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                            ProForma_LatestBudgetCM.put(line.ASI_CRM_PRODUCTCODE__c,RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c));// system.debug(line.ASI_CRM_PRODUCTCODE__c+'Debug7.1:'+RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c));
                        }
                    }
                }
                
                if (line.ASI_CRM_TYPE__c == 'YTD GS'){
                    if (!Latest_ActualGS.containskey(line.ASI_CRM_PRODUCTCODE__c)){
                        Latest_ActualGS.put(line.ASI_CRM_PRODUCTCODE__c, line.ASI_CRM_CM_GS_per_9L__c);
                    } 
                    if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(strkey)){
                        if (historical_sbDataROI_map.get(strkey).GS == null || historical_sbDataROI_map.get(strkey).GS == 0){
                            historical_sbDataROI_map.get(strkey).GS =  line.ASI_CRM_CM_GS_per_9L__c;
                            historical_sbDataROI_map.get(strkey).SubBrandId = line.ASI_CRM_PRODUCTCODE__c;
                        }
                    } 
                }
                
                if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(strkey)){
                    if (historical_sbDataROI_map.get(strkey).latestBudgetCM == null || historical_sbDataROI_map.get(strkey).latestBudgetCM == 0){
                         SYSTEM.DEBUG('LatestBudgetCM Found :  '+line.ASI_CRM_PRODUCTCODE__c);
                        if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                            historical_sbDataROI_map.get(strkey).latestBudgetCM = RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c);
                        }
                    }
                    historical_sbDataROI_map.get(strkey).SubBrandId = line.ASI_CRM_PRODUCTCODE__c;
                }
                
                if(!ProForma_LatestBudgetCM.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                      SYSTEM.DEBUG('HVFinal ENTER '+line.ASI_CRM_PRODUCTCODE__c);
                    if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                        ProForma_LatestBudgetCM.put(line.ASI_CRM_PRODUCTCODE__c,RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c));
                        SYSTEM.DEBUG('HVFinal '+line.ASI_CRM_PRODUCTCODE__c);
                    }
                }
                
                
            } // end of CM /GS Looping
            
            
            
            Decimal CMTotalVFinal=0;
            Decimal LatestBudgetCMTotalVFinal = 0;
            //ROI Calculations for Historical
            if (historical_sbDataROI_map != null && historical_sbDataROI_map.size() > 0){
                decimal ActualCM;
                decimal LatestBudgetCM;
                decimal LatestBudgetCM_prorate;
                decimal ActualGS;
                decimal TotalActualVol;
                decimal PeriodStr;
                decimal ActualCM_prorate;
                decimal ActualGS_prorate;
                date historicalVFinalTillEnd;
                
                if (PreviousCC.ASI_CRM_CN_PO_End_Date__c != null && CutOffDay >= PreviousCC.ASI_CRM_CN_PO_End_Date__c)
                    historicalVFinalTillEnd = getEndDate(PreviousCC.ASI_CRM_CN_PO_End_Date__c);
                else
                    historicalVFinalTillEnd = CutOffDay;
                
                Integer PeriodA_prorate = MonthDiff(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, historicalVFinalTillEnd);
                Integer PeriodB_prorate = MonthDiff(PreviousCC.ASI_CRM_CN_PO_Start_Date__c, PreviousCC.ASI_CRM_CN_PO_End_Date__c);
                Integer PeriodD_prorate = PeriodB_prorate - PeriodA_prorate;
                
                for (string key : historical_sbDataROI_map.keyset()){
                    PeriodStr= null;
                    if (historical_sbDataROI_map.get(key).period != null){
                        PeriodStr = historical_sbDataROI_map.get(key).period;
                    }
                    //Actual CM
                    ActualCM = null;
                    if (historical_sbDataROI_map.get(key).CM != null && historical_sbDataROI_map.get(key).CM != 0){
                        ActualCM = historical_sbDataROI_map.get(key).CM;
                    }else{
                        if (Latest_ActualCM != null && Latest_ActualCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                            ActualCM = Latest_ActualCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                        }
                    }
                    
                    //Latest Budget CM
                    LatestBudgetCM = null;
                    if (historical_sbDataROI_map.get(key).latestBudgetCM != null){
                        LatestBudgetCM = historical_sbDataROI_map.get(key).latestBudgetCM;
                    }else{
                        if (ProForma_LatestBudgetCM != null && ProForma_LatestBudgetCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                            LatestBudgetCM = ProForma_LatestBudgetCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                        }
                    }
                    //Actual GS
                    ActualGS = null;
                    if (historical_sbDataROI_map.get(key).GS != null && historical_sbDataROI_map.get(key).GS != 0){
                        ActualGS = historical_sbDataROI_map.get(key).GS;
                    }else{
                        if (Latest_ActualGS != null && Latest_ActualGS.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                            ActualGS = Latest_ActualGS.get(historical_sbDataROI_map.get(key).SubBrandId);
                        }
                    }
                    system.debug('ActualGS:'+ActualGS);
                    //Total Volume
                    TotalActualVol = null;
                    if (historical_sbDataROI_map.get(key).TotalVolume != null){
                        TotalActualVol = historical_sbDataROI_map.get(key).TotalVolume;
                    }
                    if (TotalActualVol != null && ActualCM != null ){ 
                        CMTotalVFinal += ActualCM * TotalActualVol; 
                    }
                    
                    if (TotalActualVol != null && LatestBudgetCM != null ){
                        LatestBudgetCMTotalVFinal += LatestBudgetCM * TotalActualVol;
                    }
                    
                    ActualCM_prorate = 0;
                    if (latest_ActualCM != null && latest_ActualCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                        ActualCM_prorate = latest_ActualCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                    }  
                    
                    LatestBudgetCM_prorate = 0;
                    if (ProForma_LatestBudgetCM != null && ProForma_LatestBudgetCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                        LatestBudgetCM_prorate = ProForma_LatestBudgetCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                    } 
                    
                    if (PeriodA_prorate != null && PeriodA_prorate != 0 && TotalActualVol != null && TotalActualVol != 0 && PeriodD_prorate != null && ActualCM_prorate != null)
                        CMTotalVFinal += ActualCM_prorate * TotalActualVol / PeriodA_prorate * PeriodD_prorate;
                    
                    if (PeriodA_prorate != null && PeriodA_prorate != 0 && TotalActualVol != null && TotalActualVol != 0 && PeriodD_prorate != null && LatestBudgetCM_prorate != null){
                        LatestBudgetCMTotalVFinal += LatestBudgetCM_prorate * TotalActualVol / PeriodA_prorate * PeriodD_prorate;
                    }
                    
                    if (TotalActualVol != null && ActualGS != null){
                        HistoricalVFinalContract.GrossSalesTotal += ActualGS * TotalActualVol;//
                        system.debug('New Historical Gross Sales: ' + historical_sbDataROI_map.get(key).SubBrandId + ' ' + ActualGS + ' * ' + TotalActualVol );
                    }
                    ActualGS_prorate = 0;
                    if (latest_ActualGS != null && latest_ActualGS.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                        ActualGS_prorate = latest_ActualGS.get(historical_sbDataROI_map.get(key).SubBrandId);
                    }   
                    if (PeriodA_prorate != null && PeriodA_prorate != 0 && TotalActualVol != null && TotalActualVol != 0 && PeriodD_prorate != null && ActualGS_prorate != null){
                        HistoricalVFinalContract.GrossSalesTotal  += ActualGS_prorate * TotalActualVol / PeriodA_prorate * PeriodD_prorate;
                    }
                    
                } // end of looping historical_sbDataROI_map
                
            }
            system.debug(CMTotalVFinal+'Laputa system.debug latestBudgetCMTotal.strA '+LatestBudgetCMTotalVFinal);
            //Historical V Final Calculation
            
            //%Gross Sales Historical
            if (HistoricalVFinalContract.GrossSalesTotal != null && HistoricalVFinalContract.GrossSalesTotal != 0 && HistoricalVFinalContract.TradeExpenses != 0 && HistoricalVFinalContract.TradeExpenses!= null){
                HistoricalVFinalContract.GrossSalesRate = (HistoricalVFinalContract.TradeExpenses/ HistoricalVFinalContract.GrossSalesTotal) *100;
            }
            
            //Fixed Expense Rate
            if (HistoricalVFinalContract.FixedExpense != 0 &&  HistoricalVFinalContract.TradeExpenses!= 0 && HistoricalVFinalContract.FixedExpense != null &&  HistoricalVFinalContract.TradeExpenses != null){
                HistoricalVFinalContract.FixedExpenseRate = HistoricalVFinalContract.FixedExpense/ HistoricalVFinalContract.TradeExpenses * 100;
            }
            //Historical Contract Margin after A&P
            if (CMTotalVFinal != null && HistoricalVFinalContract.TradeExpenses != null){
                HistoricalVFinalContract.MarginAfterAnP = CMTotalVFinal - HistoricalVFinalContract.TradeExpenses;
            }
            
            if (TotalHC_VolumeBtl != 0 && TotalHC_VolumeBtl!= null && HistoricalVFinalContract.MarginAfterAnP != 0 && HistoricalVFinalContract.MarginAfterAnP != null){
                HistoricalVFinalContract.MarginPerBottle = HistoricalVFinalContract.MarginAfterAnP / TotalHC_VolumeBtl;
                HistoricalVFinalContract.IntakeSTD=TotalHC_VolumeBtl;
            }
            
            
            if(HistoricalVFinalContract.IntakeCR12!=null && HistoricalVFinalContract.IntakeCR12 !=0 && HistoricalVFinalContract.TradeExpenses!=null){
                HistoricalVFinalContract.InvestmentCR12 =HistoricalVFinalContract.TradeExpenses/HistoricalVFinalContract.IntakeCR12; 
            }
            
            if (CMTotalVFinal != null && CMTotalVFinal != 0 && HistoricalVFinalContract.TradeExpenses != 0 && HistoricalVFinalContract.TradeExpenses!= null){
                HistoricalVFinalContract.CMTotal=CMTotalVFinal;
                HistoricalVFinalContract.ROIIntake = CMTotalVFinal / HistoricalVFinalContract.TradeExpenses;
            }
            //ProForma_ROI Historical
            if (LatestBudgetCMTotalVFinal != null && LatestBudgetCMTotalVFinal != 0 &&   HistoricalVFinalContract.TradeExpenses!= 0 &&  HistoricalVFinalContract.TradeExpenses!= null){
                HistoricalVFinalContract.LatestBudgetCMTotal=LatestBudgetCMTotalVFinal;
                HistoricalVFinalContract.ROIProForma = LatestBudgetCMTotalVFinal / HistoricalVFinalContract.TradeExpenses;
            }
            
            if(TotalHC_BC!=0 && TotalHC_BC !=null && TotalHC_IntakeBtl !=null && TotalHC_IntakeBtl!=0){
                HistoricalVFinalContract.TotalBCRate=(TotalHC_BC/TotalHC_IntakeBtl)*100;
                HistoricalVFinalContract.NetBCRate=((TotalHC_BC-TotalBackCap)/TotalHC_IntakeBtl)*100;
            }
            
             if(TotalHistorical_MartellBC!=0 && TotalHistorical_MartellBC !=null && TotalHistorical_MartellIntakeBtl !=null && TotalHistorical_MartellIntakeBtl!=0){
                HistoricalVFinalContract.TotalMBCRate=(TotalHistorical_MartellBC/TotalHistorical_MartellIntakeBtl)*100;
                HistoricalVFinalContract.NetMBCRate=((TotalHistorical_MartellBC-TotalHistorical_MartellBlackCap)/TotalHistorical_MartellIntakeBtl)*100;
            }
            
            
            AdditionalFIMap.put('TotalHistorical_MartellBC',TotalHistorical_MartellBC); 
            AdditionalFIMap.put('TotalHistorical_MartellIntakeBtl',TotalHistorical_MartellIntakeBtl); 
            AdditionalFIMap.put('TotalHistorical_MartellBlackCap',TotalHistorical_MartellBlackCap); 
            
            
            AdditionalFIMap.put('TotalHC_BC',TotalHC_BC); 
            AdditionalFIMap.put('TotalBackCap',TotalBackCap); 
            AdditionalFIMap.put('TotalHC_IntakeBtl',TotalHC_IntakeBtl); 
        }
        
        HistoricalVFinalContract.AddOnString = System.JSON.serialize(AdditionalFIMap);
        
        List<FinancialIndicator> FinancialIndicatorList = new List<FinancialIndicator>();
        FinancialIndicatorList.add(HistoricalV00Contract);
        FinancialIndicatorList.add(HistoricalVFinalContract);
        
        UpsertAttachment(thisCC.Id, System.JSON.serialize(FinancialIndicatorList),'Historical Data' );
        
    } // end of RestructureHistoricalData
    
    
    
    
    
    
    //Restructure Current v0 and VFinal Data
    public static void RestructureCurrentFIData(ASI_TH_CRM_Contract__c contract){
        //Get Current PO data
        ASI_TH_CRM_Contract__c thisCC = [SELECT id, ASI_CRM_Martell_BC_Rate__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_CN_Expected_BRSF_Est_Total__c,
                                         ASI_CRM_EVC_Cost_Estimate_Total__c,
                                         ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,Name,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c ,
                                         ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,
                                         ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,  ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,   ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__c, Owner.Name, ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,  ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,  ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c ,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c  FROM ASI_TH_CRM_Contract__c 
                                         WHERE id = :contract.Id];
        map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal> ();
        //Define variable 
        
        FinancialIndicator HistoricalV00Contract = new FinancialIndicator();
        FinancialIndicator HistoricalVFinalContract = new FinancialIndicator();
        date startDate;
        date endDate;
        String strRegion='',CommercialTeam='';
        set<id> HistoricalAllOutlet = new set<id>();
        Map<String, Decimal> AdditionalFIMap = new Map<String, Decimal>();
        //key: date+SubBrand    for historical v0.0
        map <string, subbrand_data> historicalV0_sbDataROI_map =new map <string, subbrand_data>();
        
        //Calculate RegionSubBrandCM_Map
        string currentFY = String.valueOf(FYConversion(date.Today()).Year());
        string currentFY2 = (integer.valueOf(currentFY) - 1) + '';
        string currentFY3 = (integer.valueOf(currentFY) - 2) + '';
        
        //Finding Old Promotion Types
        Set<String> oldPromotionTypes = new Set<String>();
        if(thisCC.ASI_CRM_New_FY_PO__c){
            for(ASI_CRM_Special_Promotion_Type_Mapping__c obj:[SELECT Id,ASI_CRM_Mapping_of_New_Promotion_Type__c , ASI_CRM_Mapping_of_Old_Promotion_Type__c , ASI_CRM_Mapping_of_New_Promotion_Type__r.ASI_CRM_Promotion_Type__c , ASI_CRM_Mapping_of_Old_Promotion_Type__r.ASI_CRM_Promotion_Type__c FROM ASI_CRM_Special_Promotion_Type_Mapping__c WHERE RecordType.DeveloperName = 'ASI_CRM_CN_Special_Promotion_Type_Mapping' AND ASI_CRM_Mapping_of_New_Promotion_Type__r.ASI_CRM_Promotion_Type__c = : thisCC.ASI_TH_CRM_Promotion_Type__c ]){
                oldPromotionTypes.add(obj.ASI_CRM_Mapping_of_Old_Promotion_Type__r.ASI_CRM_Promotion_Type__c);
            }
        }
        
        
        //Assign/Calculate data
        if(thisCC.id != null){
            string HistoricalV00ContractId = null;
            date StartDateExtend;
            date EndDateExtend;
            Set<Id> V00SubBrandIdSet = new Set<Id> ();
            HistoricalAllOutlet.add(thisCC.ASI_CRM_CN_Outlet_WS__c);
            //Getting Historical Outlet Id  for vFinal
            if(thisCC.ASI_CRM_Volume_Option__c == 'Wholesaler Only' ){
                HistoricalAllOutlet.add(thisCC.ASI_CRM_CN_Outlet_WS__c);
            }else{
                for (ASI_CRM_CN_Covered_Outlet__c CO_temp: [SELECT ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
                    HistoricalAllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
                }
            }
            HistoricalVFinalContract.OutletSet=HistoricalAllOutlet;
            
            //Contract level Handling
            if(thisCC != null && thisCC.id != null && thisCC.ASI_CRM_CN_V0_0_PO_version__c == null){ 
                HistoricalV00Contract.ContractId = thisCC.Id;
                HistoricalV00ContractId = thisCC.id;
                
                HistoricalV00Contract.BCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c!= null?thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c:0;
                HistoricalV00Contract.TotalBCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c!= null?thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c:0;
                HistoricalV00Contract.TotalMBCRate = thisCC.ASI_CRM_Martell_BC_Rate__c!= null?thisCC.ASI_CRM_Martell_BC_Rate__c:0;
                
                HistoricalV00Contract.POStartDate =thisCC.ASI_CRM_CN_PO_Start_Date__c!=null?thisCC.ASI_CRM_CN_PO_Start_Date__c:null;
                HistoricalV00Contract.POEndDate =thisCC.ASI_CRM_CN_PO_End_Date__c!=null?thisCC.ASI_CRM_CN_PO_End_Date__c:null;
                
                startDate = thisCC.ASI_CRM_CN_PO_Start_Date__c!=null?thisCC.ASI_CRM_CN_PO_Start_Date__c:null;
                endDate = thisCC.ASI_CRM_CN_PO_End_Date__c!= null?thisCC.ASI_CRM_CN_PO_End_Date__c : null;
                StartDateExtend= thisCC.ASI_CRM_CN_PO_Start_Date__c!=null? getEndDate(thisCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1)) :null;
                EndDateExtend = thisCC.ASI_CRM_CN_PO_End_Date__c!=null? getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c.addYears(+1)):null;   
                strRegion= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c != null? thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c :'';
                CommercialTeam= thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null?thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
                
                //Current Contract is V0.0
                if(thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != null)
                    HistoricalV00Contract.TradeExpenses = thisCC.ASI_CRM_CN_Contract_Estimate_Cost_Total__c;
                if(thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)
                    HistoricalV00Contract.FixedExpense = thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
                if(thisCC.ASI_CRM_CN_No_of_Months__c != 0 &&  thisCC.ASI_CRM_CN_No_of_Months__c != null)
                    HistoricalV00Contract.NoOfMonths = Integer.valueOf(thisCC.ASI_CRM_CN_No_of_Months__c);
                
                
            }else if(thisCC != null && thisCC.ASI_CRM_CN_V0_0_PO_version__c != null){
                HistoricalV00Contract.ContractId = thisCC.ASI_CRM_CN_V0_0_PO_version__r.Id;
                HistoricalV00ContractId = thisCC.ASI_CRM_CN_V0_0_PO_version__c;
                
                HistoricalV00Contract.BCRate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c!=null?HistoricalV00Contract.BCRate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c:0;
                HistoricalV00Contract.TotalBCRate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c!=null?HistoricalV00Contract.BCRate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c:0;
                 HistoricalV00Contract.TotalMBCRate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c!=null?thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c:0;
                
                
                HistoricalV00Contract.POStartDate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!=null?thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c:Null;
                HistoricalV00Contract.POEndDate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!=null?thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c:Null;
                
                startDate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!=null?thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c:Null;
                endDate = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!=null?thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c:Null;
                StartDateExtend= thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c!=null? getEndDate(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c.addYears(-1)) :null;
                EndDateExtend = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c!=null? getEndDate(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c.addYears(+1)):null;  
                
                strRegion = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c !=null? thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c: '';
                CommercialTeam= thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c!=null?thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c:'';
                
                
                //Current Contract is VFinal
                if(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c != null)
                    HistoricalV00Contract.TradeExpenses = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c;
                if(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null)   
                    HistoricalV00Contract.FixedExpense = thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
                if(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c != 0 &&  thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c != null)
                    HistoricalV00Contract.NoOfMonths = Integer.valueOf(thisCC.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c);
            } else{
                HistoricalV00ContractId = null;
            }
            
            //Historical v0.0 BRSF Line only for By Sub-Brand
            list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> PreviousV0CC_BRSFList = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
            
            
            if(HistoricalV00ContractId != null){
                map<date, decimal> PreviousV0CC_Period_map = checkFYDayPeriod(startDate, endDate);
                //CMTotalV0 :  Cont. Margin before A&P  
                Decimal CMTotalV0=0;
                Decimal LatestBudgetCMTotalV0 = 0;
                Decimal BRSFEstimateVolumesTotalV0 = 0; // Calculate BRSF Estimate Volumes Total for V0.0 contract
                
                
                List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> BRSFList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
                
                //<Sub-Brand Id, Estimate Volume Amount> : the Estimate Volume for each Sub-Brand Mapping
                Map<string, decimal> EstimateVolumeV0Map =new Map<string, decimal>();
                List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = [SELECT Id,RecordType.DeveloperName, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c,
                                                                                ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name, 
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c,
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name,
                                                                                ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, 
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c, 
                                                                                ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_Volume_Base__c,ASI_CRM_Type__c  
                                                                                FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c =:HistoricalV00ContractId ];
                
                
                
                for (ASI_CRM_Contract_Cost__c  ccost : [SELECT Name, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c  FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :HistoricalV00ContractId])
                {
                    if (ccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                        HistoricalV00Contract.VariableExpense += ccost.ASI_CRM_CN_Estimate_Amount__c!=null?ccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    }
                }
                
                
                Set<String> PSFMethodologySet = new  Set<String>();
                Set<String> PSFVolumeBaseSet= new  Set<String>();
                //Looping the Contract Line
                for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine : ContractLineList){       //By Sub-Brand
                    //if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){
                    if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  || (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null )
                    {
                        
                        V00SubBrandIdSet.add(ContractLine.ASI_CRM_CN_Sub_Brand__c);
                        Decimal V00Volumes = 0; 
                        if (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c != null && ContractLine.ASI_CRM_CN_No_of_Months__c != null){
                            V00Volumes = (ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c* ContractLine.ASI_CRM_CN_No_of_Months__c);
                        }
                        
                        //Get All BRSF Estimate Volumes
                        if((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  || (ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ){
                            BRSFEstimateVolumesTotalV0 += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c:0;
                            BRSFList.add(ContractLine);
                            if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF'  && ContractLine.ASI_CRM_Module__c!=null && ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c!=null){
                                HistoricalV00Contract.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                            }
                        }
                        IF(ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c!=NULL){
                            if(EstimateVolumeV0Map.containskey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                                Decimal TempEstimateVolume = EstimateVolumeV0Map.get(ContractLine.ASI_CRM_CN_Sub_Brand__c)+ ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c ;
                                EstimateVolumeV0Map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, TempEstimateVolume);
                            }else{
                                EstimateVolumeV0Map.put(ContractLine.ASI_CRM_CN_Sub_Brand__c, ContractLine.ASI_CRM_CN_Estimate_Volume_9L_Month__c);
                            }
                        }
                        
                        
                        //Calculate Volume
                        HistoricalV00Contract.Volumes += V00Volumes;
                        
                        //By Sub-Brand Grade Grouping
                        String SubbrandGroupName='0. Not Specified';
                        String SubBrandName='';
                        if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c != null ){
                            SubbrandGroupName=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c!=NULL? ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c:ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                            SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                        }
                        
                        if(HistoricalV00Contract.SubBrandGradeGrouping.containskey(SubBrandName)){
                            Decimal TempVolumes=HistoricalV00Contract.SubBrandGradeGrouping.get(SubBrandName)+V00Volumes;
                            HistoricalV00Contract.SubBrandGradeGrouping.remove(SubBrandName);//remove orignal one
                            HistoricalV00Contract.SubBrandGradeGrouping.put(SubBrandName,TempVolumes); 
                        }else{
                            HistoricalV00Contract.SubBrandGradeGrouping.put(SubBrandName,V00Volumes); 
                        }
                        
                        if(HistoricalV00Contract.SubBrandGradeMap.containskey(SubbrandGroupName)){
                            Decimal TempVolumes=HistoricalV00Contract.SubBrandGradeMap.get(SubbrandGroupName)+V00Volumes;
                            //remove orignal one
                            HistoricalV00Contract.SubBrandGradeMap.remove(SubbrandGroupName);
                            HistoricalV00Contract.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
                        }else{
                            HistoricalV00Contract.SubBrandGradeMap.put(SubbrandGroupName,V00Volumes); 
                        }
                        
                        //By Brande Product Category Grouping  
                        if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c !=null && ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c !=null ){
                            String CategoryName = ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name;
                            if(HistoricalV00Contract.CategoryMap.containskey(CategoryName)){
                                Decimal TempVolumes=HistoricalV00Contract.CategoryMap.get(CategoryName)+V00Volumes;
                                //remove orignal one
                                HistoricalV00Contract.CategoryMap.remove(CategoryName);
                                HistoricalV00Contract.CategoryMap.put(CategoryName,TempVolumes); 
                            }else{
                                HistoricalV00Contract.CategoryMap.put(CategoryName,V00Volumes);
                            }
                        }// end of By Brande Product Category Grouping      
                        
                        
                        if (PreviousV0CC_Period_map != null && PreviousV0CC_Period_map.size() > 0){
                            for (date previousV0CCdate : PreviousV0CC_Period_map.keyset() ){
                                
                                date strDateCC = FYConversion(previousV0CCdate);
                                String strkey_p = string.valueof(strDateCC) + ContractLine.ASI_CRM_CN_Sub_Brand__c ;
                                subbrand_data newitem = new subbrand_data();
                                newitem.period = PreviousV0CC_Period_map.get(previousV0CCdate);//This fiscal year's month number
                                newitem.SubBrandId = ContractLine.ASI_CRM_CN_Sub_Brand__c;
                                newitem.TotalVolume = 0;
                                newitem.TotalEstVolume = 0;
                                historicalV0_sbDataROI_map.put(strkey_p, newitem);
                            }
                        }
                        //HistoricalV00Contract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c; 
                        
                    }else{//Not By Sub-Brand
                        
                    }
                    IF(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' && ContractLine.ASI_CRM_Module__c!=null){
                        if(!PSFMethodologySet.contains(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name)){
                            PSFMethodologySet.add(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name);
                            HistoricalV00Contract.PSFMethodologyName+= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c+';';
                        }
                        if(!PSFVolumeBaseSet.contains(ContractLine.ASI_CRM_Volume_Base__c)){
                            PSFVolumeBaseSet.add(ContractLine.ASI_CRM_Volume_Base__c);
                            HistoricalV00Contract.PSFVolumeBase+= VolumeBaseTranslation(ContractLine.ASI_CRM_Volume_Base__c)+';';
                        }
                    }
                    //Estimate contract cost total 
                    HistoricalV00Contract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                    
                    //SUM(BRSF estimate cost, Other variable cost)
                    HistoricalV00Contract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                }//end of Looping the Contract Line
                
                
                
                Map<String,Decimal> CR12FactorMap = GenerateCR12FactorMap(V00SubBrandIdSet, CommercialTeam, strRegion);
                for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine :BRSFList){
                    if (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c != null){
                        Decimal CR12Factor=1;
                        if(CR12FactorMap.containsKey(ContractLine.ASI_CRM_CN_Sub_Brand__c)){
                            CR12Factor=CR12FactorMap.get(ContractLine.ASI_CRM_CN_Sub_Brand__c);
                        }//system.debug(' NOW h :'+ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c +'*'+ CR12Factor +'*'+ ContractLine.ASI_CRM_CN_No_of_Months__c);
                        HistoricalV00Contract.IntakeCR12 += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * CR12Factor * ContractLine.ASI_CRM_CN_No_of_Months__c;
                    }
                }
                
                
                date StartDateExtend2 = date.newInstance(StartDateExtend.addYears(-1).year(), 6, 30);
                date EndDateExtend2 = date.newInstance(EndDateExtend.year(), 6, 30);
                
                //Getting GM/GS Data
                
                
                
                for (ASI_CRM_CM_GS__c lbcm : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c FROM ASI_CRM_CM_GS__c
                                              WHERE ASI_CRM_CN_Month__c = 6  AND (ASI_CRM_YEAR__c = :currentFY OR ASI_CRM_YEAR__c = :currentFY2 OR ASI_CRM_YEAR__c = :currentFY3) AND
                                              ASI_CRM_Region__c = :strRegion  AND ASI_CRM_TYPE__c = 'Budget CM'
                                              AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_YEAR__c DESC, ASI_CRM_VERSION__c DESC ])
                {// and ASI_CRM_PRODUCTCODE__c IN :V00SubBrandIdSet 
                    string ProductCode = lbcm.ASI_CRM_PRODUCTCODE__c;
                    decimal cm=0.0;
                    if (lbcm.ASI_CRM_CM_GS_per_9L__c != null){
                        cm = lbcm.ASI_CRM_CM_GS_per_9L__c; 
                    }
                    if (!RegionSubBrandCM_Map.containsKey(ProductCode)){
                        RegionSubBrandCM_Map.put(ProductCode,cm) ;   
                    }
                }
                
                
                Map<String, ASI_CRM_CM_GS__c> cmgsMap = new Map<String, ASI_CRM_CM_GS__c>();   
                system.debug('RestructureCurrentFIData StartDateExtend : '+StartDateExtend);
                system.debug('RestructureCurrentFIData EndDateExtend : '+EndDateExtend);
                system.debug('RestructureCurrentFIData StartDateExtend2 : '+StartDateExtend2);
                system.debug('RestructureCurrentFIData EndDateExtend2 : '+EndDateExtend2);
                
                for (ASI_CRM_CM_GS__c line : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c, ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c , ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Month__c FROM ASI_CRM_CM_GS__c
                                              WHERE ASI_CRM_PRODUCTCODE__c IN :V00SubBrandIdSet   AND ASI_CRM_Region__c = :strRegion AND (ASI_CRM_TYPE__c = 'Budget CM' OR ASI_CRM_TYPE__c = 'Budget GS') 
                                              AND ( (ASI_CRM_CN_Month_End_Date__c >= :StartDateExtend AND ASI_CRM_CN_Month_End_Date__c <= :EndDateExtend )
                                                   OR (ASI_CRM_CN_Month_End_Date__c >= :StartDateExtend2   AND ASI_CRM_CN_Month_End_Date__c <= :EndDateExtend2  AND ASI_CRM_CN_Month__c = 6  ) )  
                                              AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
                {
                    
                    String strkey_v0 = string.valueof(line.ASI_CRM_CN_Month_End_Date__c) + line.ASI_CRM_PRODUCTCODE__c;
                    if(line.ASI_CRM_CN_Month__c == 6 && !cmgsMap.containsKey(line.ASI_CRM_PRODUCTCODE__c + line.ASI_CRM_TYPE__c) && line.ASI_CRM_CM_GS_per_9L__c != null && line.ASI_CRM_CM_GS_per_9L__c != 0){
                        cmgsMap.put(line.ASI_CRM_PRODUCTCODE__c +line.ASI_CRM_TYPE__c, line);
                    }
                    
                    if (historicalV0_sbDataROI_map.containskey(strkey_v0) && line.ASI_CRM_CM_GS_per_9L__c != null && line.ASI_CRM_CM_GS_per_9L__c != 0  ){
                        if ( historicalV0_sbDataROI_map.get(strkey_v0).CM == null || historicalV0_sbDataROI_map.get(strkey_v0).CM == 0 ){
                            if (line.ASI_CRM_TYPE__c == 'Budget CM'){
                                historicalV0_sbDataROI_map.get(strkey_v0).CM = line.ASI_CRM_CM_GS_per_9L__c;
                            }                           
                        }
                        if(historicalV0_sbDataROI_map.get(strkey_v0).GS == null || historicalV0_sbDataROI_map.get(strkey_v0).GS == 0){
                            if (line.ASI_CRM_TYPE__c == 'Budget GS'){
                                historicalV0_sbDataROI_map.get(strkey_v0).GS = line.ASI_CRM_CM_GS_per_9L__c;
                            }
                        }
                        
                        if (historicalV0_sbDataROI_map.containskey(strkey_v0)){
                            if (historicalV0_sbDataROI_map.get(strkey_v0).latestBudgetCM == null || historicalV0_sbDataROI_map.get(strkey_v0).latestBudgetCM == 0){
                                if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                                    historicalV0_sbDataROI_map.get(strkey_v0).latestBudgetCM = RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c);
                                }
                            }
                        }
                    }
                }// End of CM/GS Looping 
                
                
                
                // to replace null value with latest CMGS data
                for(String key : historicalV0_sbDataROI_map.keySet()){
                    if(historicalV0_sbDataROI_map.get(key).CM == Null || historicalV0_sbDataROI_map.get(key).CM == 0 || historicalV0_sbDataROI_map.get(key).GS == Null || historicalV0_sbDataROI_map.get(key).GS == 0 || historicalV0_sbDataROI_map.get(key).latestBudgetCM == Null || historicalV0_sbDataROI_map.get(key).latestBudgetCM == 0){
                        if((historicalV0_sbDataROI_map.get(key).CM == Null || historicalV0_sbDataROI_map.get(key).CM == 0) && cmgsMap.containsKey(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget CM')){
                            ASI_CRM_CM_GS__c cmgs = cmgsMap.get(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget CM');
                            historicalV0_sbDataROI_map.get(key).CM = cmgs.ASI_CRM_CM_GS_per_9L__c;
                            
                        }
                        
                        if((historicalV0_sbDataROI_map.get(key).GS == Null || historicalV0_sbDataROI_map.get(key).GS == 0) && cmgsMap.containsKey(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget GS')){
                            ASI_CRM_CM_GS__c cmgs = cmgsMap.get(historicalV0_sbDataROI_map.get(key).SubBrandId + 'Budget GS');
                            historicalV0_sbDataROI_map.get(key).GS = cmgs.ASI_CRM_CM_GS_per_9L__c;
                        }
                        
                        if(historicalV0_sbDataROI_map.get(key).latestBudgetCM == Null || historicalV0_sbDataROI_map.get(key).latestBudgetCM == 0){
                            if(RegionSubBrandCM_Map.containsKey(historicalV0_sbDataROI_map.get(key).SubBrandId)){
                                historicalV0_sbDataROI_map.get(key).latestBudgetCM = RegionSubBrandCM_Map.get(historicalV0_sbDataROI_map.get(key).SubBrandId);
                            }
                            
                        }
                    }
                }
                
                
                
                //Calculate Total CM
                if (historicalV0_sbDataROI_map != null && historicalV0_sbDataROI_map.size() > 0){
                    decimal ActualGS;
                    decimal ActualCM; //Budget CM 
                    decimal LatestBudgetCM; // Latest Budget CM
                    decimal TotalEstimateVol;
                    decimal PeriodStr; // Number of month 
                    
                    for (string key : historicalV0_sbDataROI_map.keyset()){
                        PeriodStr= null;
                        if (historicalV0_sbDataROI_map.get(key).period != null){
                            PeriodStr = historicalV0_sbDataROI_map.get(key).period;
                        }
                        //Budget CM
                        ActualCM = null;
                        if (historicalV0_sbDataROI_map.get(key).CM != null){
                            ActualCM = historicalV0_sbDataROI_map.get(key).CM;
                        }
                        // Latest Budget CM
                        LatestBudgetCM = null;
                        if (historicalV0_sbDataROI_map.get(key).latestBudgetCM != null){
                            LatestBudgetCM = historicalV0_sbDataROI_map.get(key).latestBudgetCM;
                        }
                        //Budget GS
                        ActualGS = null;
                        if (historicalV0_sbDataROI_map.get(key).GS != null){
                            ActualGS = historicalV0_sbDataROI_map.get(key).GS;
                        }
                        TotalEstimateVol = null;
                        if (EstimateVolumeV0Map != null && historicalV0_sbDataROI_map.get(key) != null && historicalV0_sbDataROI_map.get(key).SubBrandId != null && EstimateVolumeV0Map.containskey(historicalV0_sbDataROI_map.get(key).SubBrandId)){
                            TotalEstimateVol = EstimateVolumeV0Map.get(historicalV0_sbDataROI_map.get(key).SubBrandId);
                        }                        
                        //Total Volume
                        if (TotalEstimateVol != null && ActualCM != null && PeriodStr != null){
                            CMTotalV0 += ActualCM * TotalEstimateVol * PeriodStr;
                        }
                        
                        if (TotalEstimateVol != null && LatestBudgetCM != null && PeriodStr != null){
                            LatestBudgetCMTotalV0 += LatestBudgetCM * TotalEstimateVol * PeriodStr;
                        }
                        //Gross Sales
                        if (TotalEstimateVol != null && ActualGS != null && PeriodStr != null){
                            HistoricalV00Contract.GrossSalesTotal += ActualGS * TotalEstimateVol * PeriodStr;
                        }
                    }
                }// end of historicalV0_sbDataROI_map Looping 
                
                //**************************Calculation**************************
                
                if(HistoricalV00Contract.TradeExpenses != null && HistoricalV00Contract.TradeExpenses != 0 ){
                    HistoricalV00Contract.FixedExpenseRate = HistoricalV00Contract.FixedExpense / HistoricalV00Contract.TradeExpenses *100;
                    
                }
                
                //Calculate 'Investment per CR12 eq btl ' = Trade expenses / (CR12 Conversion Factor in Sub-brand * estimate Monthly vol. * PO Period in Sub-Brand )
                if (HistoricalV00Contract.IntakeCR12 != 0 && HistoricalV00Contract.IntakeCR12!= null &&  HistoricalV00Contract.TradeExpenses != 0 &&  HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.InvestmentCR12 =  (HistoricalV00Contract.TradeExpenses / HistoricalV00Contract.IntakeCR12).SetSCale(2);
                }
                
                //Calculate Historical V0 Cont. Margin after A&P = SUM( Budget CMs * estimate Monthly vol. in 9L  of PO period) - Trade expenses
                if (CMTotalV0 != null && HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.MarginAfterAnP = CMTotalV0 - HistoricalV00Contract.TradeExpenses;
                }
                
                //
                if (BRSFEstimateVolumesTotalV0 != null && HistoricalV00Contract.NoOfMonths != null){
                    //HistoricalV00Contract.MarginPerBottle =BRSFEstimateVolumesTotalV0 * HistoricalV00Contract.NoOfMonths;
                    HistoricalV00Contract.IntakeSTD=BRSFEstimateVolumesTotalV0 * HistoricalV00Contract.NoOfMonths;
                }
                
                if (HistoricalV00Contract.IntakeSTD!= 0 && HistoricalV00Contract.IntakeSTD != null && HistoricalV00Contract.MarginAfterAnP != 0 && HistoricalV00Contract.MarginAfterAnP != null){
                    HistoricalV00Contract.MarginPerBottle = (HistoricalV00Contract.MarginAfterAnP / HistoricalV00Contract.IntakeSTD).SetSCale(2);
                }
                
                //Gross Sales Rate Historical V0
                if (HistoricalV00Contract.GrossSalesTotal  != null && HistoricalV00Contract.GrossSalesTotal  != 0 && HistoricalV00Contract.TradeExpenses!= 0 && HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.GrossSalesRate = (HistoricalV00Contract.TradeExpenses / HistoricalV00Contract.GrossSalesTotal  * 100).SetSCale(2);
                }
                
                // ROI Intake Historical V0 = Cont. Margin before A&P / Trade expenses
                if (CMTotalV0 != null && CMTotalV0 != 0 && HistoricalV00Contract.TradeExpenses != 0 && HistoricalV00Contract.TradeExpenses != null){
                    HistoricalV00Contract.CMTotal=CMTotalV0;
                    HistoricalV00Contract.ROIIntake = (CMTotalV0 / HistoricalV00Contract.TradeExpenses).SetSCale(2);
                    HistoricalV00Contract.ROIActual=HistoricalV00Contract.ROIIntake;
                }                
                
                //Calculate ROIProForma = Cont. Margin before A&P from latest CM regardless FY / Trade expenses 
                if (LatestBudgetCMTotalV0 != null && LatestBudgetCMTotalV0 != 0 && HistoricalV00Contract.TradeExpenses != 0 && HistoricalV00Contract.TradeExpenses!= null){
                    HistoricalV00Contract.LatestBudgetCMTotal=LatestBudgetCMTotalV0;
                    HistoricalV00Contract.ROIProForma = (LatestBudgetCMTotalV0/ HistoricalV00Contract.TradeExpenses).SetSCale(2);
                }
                
                
            }//Finished getting/Calculate V0.0 data
            
            
            //
            //******************************************************   Starting Calculating VFinal Data**********************************************
            if(thisCC.ASI_CRM_CN_No_of_Months__c != 0 &&  thisCC.ASI_CRM_CN_No_of_Months__c != null){
                HistoricalVFinalContract.NoOfMonths = Integer.valueOf(thisCC.ASI_CRM_CN_No_of_Months__c);
            }
            
            
            if(thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != 0 &&  thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c != null){
                HistoricalVFinalContract.FixedExpense = thisCC.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c;
            }
            HistoricalVFinalContract.BCRate = thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c!= null?thisCC.ASI_CRM_CN_Bottle_Collection_Rate__c:0;    
            HistoricalVFinalContract.ContractId = thisCC.Id;
            HistoricalVFinalContract.POStartDate = thisCC.ASI_CRM_CN_PO_Start_Date__c;
            HistoricalVFinalContract.POEndDate= thisCC.ASI_CRM_CN_PO_End_Date__c;
            
            HistoricalVFinalContract.ContractLineMap = new Map<String,ContractLine>();
            HistoricalVFinalContract.FixedExpensesMap = new Map<String,ContractLine>();
            Decimal TotalHC_VolumeBtl =0; // total historical contract Volume BTL
            Decimal TotalHC_IntakeBtl =0; 
            Decimal TotalHC_BC =0;  // total historical contract BC
            Decimal TotalBackCap=0;
            Decimal PSFEstTotal=0;
            Decimal VECEstTotal=0;
            
             
            Decimal TotalHistorical_MartellBC =0;  // total historical contract Martel BC
            Decimal TotalHistorical_MartellIntakeBtl =0;  // total historical contract Martel Intake Btl
            Decimal TotalHistorical_MartellBlackCap =0;  // total historical contract Martel BlackCap
            
            
            for (ASI_CRM_Contract_Cost__c pccost : [SELECT Id,Name, ASI_CRM_CN_Activity_Code__r.Name,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c, 
                                                    ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c 
                                                    FROM ASI_CRM_Contract_Cost__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id])
            {
                if (pccost.ASI_CRM_CN_Cost_Type__c == 'Fixed' && pccost.ASI_CRM_CN_Estimate_Amount__c != null ){
                    if (HistoricalVFinalContract.FixedExpensesMap.containskey(pccost.Name + ' ' +pccost.ASI_CRM_CN_Chinese_Description__c)){
                        HistoricalVFinalContract.FixedExpensesMap.get(pccost.Name + ' ' +pccost.ASI_CRM_CN_Chinese_Description__c).HistoricalFees += pccost.ASI_CRM_CN_Estimate_Amount__c;
                    }else{
                        ContractLine ContractDetail = new ContractLine ();
                        ContractDetail.HistoricalFees=pccost.ASI_CRM_CN_Estimate_Amount__c;
                        HistoricalVFinalContract.FixedExpensesMap.put(pccost.Name + ' ' +pccost.ASI_CRM_CN_Chinese_Description__c, ContractDetail);
                    }
                }
                if(pccost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                    HistoricalVFinalContract.VariableExpense +=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    if(pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('PSF') || pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('Promotion Service Fee') ){
                        PSFEstTotal+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    }
                    if(pccost.ASI_CRM_CN_Activity_Code__r.Name.contains('Variable Event Cost') ){
                        VECEstTotal+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
                    }
                    
                }
                HistoricalVFinalContract.TradeExpenses+=pccost.ASI_CRM_CN_Estimate_Amount__c!=null?pccost.ASI_CRM_CN_Estimate_Amount__c:0;
            }
            
            
            
            
            Set<String> PSFMethodologySetVFinal = new Set<String>();
            Set<String> PSFVolumeBaseSetVFinal = new Set<String>();
            
            for (ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine : [SELECT Id,ASI_CRM_Volume_Base__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name,ASI_CRM_Type__c,ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c,RecordType.DeveloperName,ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Sub_Brand__r.Name,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Contract_Total__c,ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Total__c ,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_COnvfactor_Ltocr12_C__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Estimate_Volume_9L_Month__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :thisCC.id]){
                
                if( ((ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item')  ||(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF' ) ) && ContractLine.ASI_CRM_CN_Sub_Brand__c!=null ){
                    
                    if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='BRSF'  && ContractLine.ASI_CRM_Module__c!=null && ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c!=null){
                        HistoricalVFinalContract.BRSFMethodologyName= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c;
                    }
                    
                    String LineKey=SBGradeSorting(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;//ContractLineSBGradeName; //NameSortingASC(ContractLine.ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c) +SuBBrandKey;//
                    
                    if(HistoricalVFinalContract.ContractLineMap.containskey(LineKey)){
                        HistoricalVFinalContract.ContractLineMap.get(LineKey).HistoricalVolume += ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null? ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c* ContractLine.ASI_CRM_CN_No_of_Months__c:0;
                        HistoricalVFinalContract.ContractLineMap.get(LineKey).HistoricalFees = HistoricalVFinalContract.ContractLineMap.get(LineKey).HistoricalFees + ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                    }else{
                        ContractLine ContractDetail = new ContractLine ();
                        ContractDetail.HistoricalVolume=ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c* ContractLine.ASI_CRM_CN_No_of_Months__c:0;
                        ContractDetail.HistoricalFees = ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c;
                        ContractDetail.SubBrandName=ContractLine.ASI_CRM_CN_Sub_Brand__r.Name;
                        ContractDetail.SubBrandGrade= ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                        HistoricalVFinalContract.ContractLineMap.put(LineKey,ContractDetail);
                    }
                }
                
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' ){
                    PSFEstTotal+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                }
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='Variable Event Cost' ){
                    VECEstTotal+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                }
                
                
                IF(ContractLine.RecordType.DeveloperName =='ASI_CRM_CRM_CN_Contract_Heavy_BRSF' && ContractLine.ASI_CRM_Type__c=='PSF' && ContractLine.ASI_CRM_Module__c!=null){
                    if(!PSFMethodologySetVFinal.contains(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name)){
                        PSFMethodologySetVFinal.add(ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name);
                        HistoricalVFinalContract.PSFMethodologyName+= ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c+';';
                    }
                    if(!PSFVolumeBaseSetVFinal.contains(ContractLine.ASI_CRM_Volume_Base__c)){
                        PSFVolumeBaseSetVFinal.add(ContractLine.ASI_CRM_Volume_Base__c);
                        HistoricalVFinalContract.PSFVolumeBase+= VolumeBaseTranslation(ContractLine.ASI_CRM_Volume_Base__c)+';';
                    }
                }
                
                if(ContractLine.RecordType.DeveloperName =='ASI_CRM_CN_Contract_BRSF_Line_Item'){
                    HistoricalVFinalContract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                    HistoricalVFinalContract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total__c==null?0:ContractLine.ASI_CRM_CN_Est_Total__c;
                }else{
                    HistoricalVFinalContract.TradeExpenses += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                    HistoricalVFinalContract.VariableExpense += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c==null?0:ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;  
                }
            }
            AdditionalFIMap.put('PSFEstTotal',PSFEstTotal);
            AdditionalFIMap.put('VECEstTotal',VECEstTotal);
            
            
            if(thisCC.ASI_CRM_CN_PO_Version__c!='0.0' && thisCC.ASI_TH_CRM_Promotion_Type__c== 'Heavy Contract On'){// ASI_CRM_CN_Total_Contract_Amount__c
                HistoricalVFinalContract.TradeExpenses=thisCC.ASI_CRM_CN_Total_Contract_Amount__c!=null?thisCC.ASI_CRM_CN_Total_Contract_Amount__c:0;
                HistoricalVFinalContract.VariableExpense=0;
                HistoricalVFinalContract.VariableExpense+=thisCC.ASI_CRM_CN_Expected_PSF_Est_Total__c!=null?thisCC.ASI_CRM_CN_Expected_PSF_Est_Total__c:0;
                HistoricalVFinalContract.VariableExpense+=thisCC.ASI_CRM_CN_Expected_BRSF_Est_Total__c!=null?thisCC.ASI_CRM_CN_Expected_BRSF_Est_Total__c:0;
                HistoricalVFinalContract.VariableExpense+=thisCC.ASI_CRM_EVC_Cost_Estimate_Total__c!=null?thisCC.ASI_CRM_EVC_Cost_Estimate_Total__c:0;
                HistoricalVFinalContract.VariableExpense+=thisCC.ASI_CRM_CN_Contract_Variable_Cost_Total__c!=null?thisCC.ASI_CRM_CN_Contract_Variable_Cost_Total__c:0;
                
            }
 
 
            
            Set<Id> HistoricalVFinalSBIdSet = new Set<Id> ();         
            Date CutOffDay =GenerateCutOffDate();
            date TillEnd;
            if (CutOffDay >= thisCC.ASI_CRM_CN_PO_End_Date__c)
                TillEnd = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c);
            else
                TillEnd = CutOffDay; 
            
            Integer PeriodA = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, TillEnd);
            Integer PeriodB = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
            
            Decimal TotalHCVolumeBtl=0;
            map<date, decimal> HistoricalVFinal_Period_map = checkFYDayPeriod(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);    
            
            system.debug(HistoricalAllOutlet+'RestructureCurrentFIData TillEnd 0.1: '+TillEnd); 
            system.debug('PeriodA: '+PeriodA);
            system.debug('PeriodB: '+PeriodA);    
            
            map <string, subbrand_data> historical_sbDataROI_map = new map <string, subbrand_data> ();
            List<ASI_CRM_Subbrand_Volume__c> HistoricalSBVolumeList = [SELECT id, Name,ASI_CRM_DeductCapWithIssue_StdBill__c,
                                                                       ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c,
                                                                       ASI_CRM_Cap_with_Issues_Std_Billing__c,ASI_CRM_Black_Cap_Std_Billing__c,ASI_CRM_Grey_Cap_Std_Billing__c,ASI_CRM_Offtake__c, ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_Code__c,ASI_CRM_Offtake_CR12__c, ASI_CRM_Subbrand__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c, ASI_CRM_Subbrand__r.Name,  ASI_CRM_T1_Depletion_BTL__c, ASI_CRM_Offtake_Btl__c, ASI_CRM_T2_Depletion_BTL__c,ASI_CRM_T1_Depletion__c, ASI_CRM_T1_Depletion_CR12__c, ASI_CRM_T2_Depletion_CR12__c,ASI_CRM_PR_Direct_CR12__c, ASI_CRM_T2_Depletion__c, ASI_CRM_PR_Direct__c, ASI_CRM_PR_Direct_Btl__c,ASI_CRM_End_Date__c ,ASI_CRM_T1_Depletion_STD__c, ASI_CRM_T2_Depletion_STD__c, 
                                                                       ASI_CRM_PR_Direct_STD__c,ASI_CRM_Black_Cap_Btl__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c, ASI_CRM_DeductibleCapWithIssues_Std_Btl__c,ASI_CRM_Green_Cap_STD__c, ASI_CRM_Empty_Bottle_Std_Btl__c
                                                                       FROM ASI_CRM_Subbrand_Volume__c WHERE  ASI_CRM_Account__c IN :HistoricalAllOutlet 
                                                                       AND ASI_CRM_CN_Competitor_Sub_brand__c != true and ASI_CRM_Subbrand__c !=null 
                                                                       AND ASI_CRM_End_Date__c >= :thisCC.ASI_CRM_CN_PO_Start_Date__c AND 
                                                                       ASI_CRM_End_Date__c <= :TillEnd AND ASI_CRM_CN_Exclude_From_Payment_Volume__c = FALSE];
            
            
            set<id> PreviousCC_SBId = new set<id>();
            
            for (ASI_CRM_Subbrand_Volume__c sbid : HistoricalSBVolumeList){
                PreviousCC_SBId.add(sbid.ASI_CRM_Subbrand__c);
            }
            
            for (date PCCperiod: HistoricalVFinal_Period_map.keyset() ){
                if (PreviousCC_SBId.size() > 0){
                    for (id sbidtemp : PreviousCC_SBId){
                        String   PeriodKey = string.valueof(PCCperiod) + sbidtemp;
                        subbrand_data newitem = new subbrand_data();
                        newitem.period = HistoricalVFinal_Period_map.get(PCCperiod);
                        newitem.SubBrandId = sbidtemp;
                        newitem.year = string.valueof(PCCperiod.year());
                        newitem.TotalVolume = 0;
                        historical_sbDataROI_map.put(PeriodKey, newitem);
                        
                    }
                }
            }
            
            
            Decimal TotalBlackCap_prorate=0;
            Decimal Total_IntakeBtl_prorate=0;
            Decimal TotalBC_prorate=0;
            for (ASI_CRM_Subbrand_Volume__c SubBrandVolume: HistoricalSBVolumeList){
                
                HistoricalVFinalSBIdSet.add(SubBrandVolume.ASI_CRM_Subbrand__c);
                //Calculate Volume 
                Decimal Volumes = 0;
                Volumes += SubBrandVolume.ASI_CRM_T1_Depletion__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion__c:0;
                Volumes += SubBrandVolume.ASI_CRM_T2_Depletion__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion__c:0;
                Volumes += SubBrandVolume.ASI_CRM_PR_Direct__c!=null? SubBrandVolume.ASI_CRM_PR_Direct__c:0;
                
                
                Decimal VolumeBtl=0;
                VolumeBtl += SubBrandVolume.ASI_CRM_T1_Depletion_STD__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion_STD__c:0;
                VolumeBtl += SubBrandVolume.ASI_CRM_T2_Depletion_STD__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion_STD__c:0;
                VolumeBtl += SubBrandVolume.ASI_CRM_PR_Direct_STD__c!=null? SubBrandVolume.ASI_CRM_PR_Direct_STD__c:0;
                
                
                Decimal BottleCollection=0;
                BottleCollection += SubBrandVolume.ASI_CRM_Green_Cap_STD__c != null? SubBrandVolume.ASI_CRM_Green_Cap_STD__c:0;
                BottleCollection += SubBrandVolume.ASI_CRM_Empty_Bottle_Std_Btl__c != null? SubBrandVolume.ASI_CRM_Empty_Bottle_Std_Btl__c:0;
                //BottleCollection += SubBrandVolume.ASI_CRM_DeductibleCapWithIssues_Std_Btl__c != null? SubBrandVolume.ASI_CRM_DeductibleCapWithIssues_Std_Btl__c:0;
                TotalHC_BC +=BottleCollection;
                
                Decimal BlackCap=0;
                BlackCap+= SubBrandVolume.ASI_CRM_Cap_with_Issues_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Cap_with_Issues_Std_Billing__c:0;   //BlackCap+= SubBrandVolume.ASI_CRM_Black_Cap_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Black_Cap_Std_Billing__c:0;
                //BlackCap+= SubBrandVolume.ASI_CRM_Grey_Cap_Std_Billing__c != null? SubBrandVolume.ASI_CRM_Grey_Cap_Std_Billing__c:0;
                TotalBackCap+=BlackCap;
                
                
                if( ASI_CRM_CN_HeavyPaymentUtilitiesClass.IsMartellSubBrandOrNot(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c) ){
                    TotalHistorical_MartellBC += BottleCollection;
                    TotalHistorical_MartellIntakeBtl+=VolumeBtl;
                    TotalHistorical_MartellBlackCap+=BlackCap;
                }
                system.debug('Total Historical VolumeBtl : '+VolumeBtl);
                
                TotalHC_IntakeBtl+=VolumeBtl;
                Decimal VarHistTotal = VolumeBtl;
                Decimal VarHistTotalVolume=Volumes;
                Decimal VariableHistoricalBottles = VolumeBtl/PeriodA;
                
                if (PeriodA != 0 && PeriodA != null && PeriodB != 0 && PeriodB != null){
                    Volumes = Volumes/PeriodA * PeriodB;
                    VolumeBtl = VolumeBtl/PeriodA * PeriodB;
                    BottleCollection = BottleCollection/PeriodA * PeriodB;
                    BlackCap = BlackCap/PeriodA * PeriodB;
                    
                }
                
                
                TotalBlackCap_prorate+=BlackCap;
                Total_IntakeBtl_prorate+=VolumeBtl;
                TotalBC_prorate+=BottleCollection;

                
                TotalHC_VolumeBtl += VolumeBtl;
                // Historical VFinal Contract Volume (in 9L cs) INTAKE (Historical Contract vFinal)
                HistoricalVFinalContract.Volumes += Volumes; 
                //Sub-Brand Grade Grouping
                String SubbrandGroupName='0. Not Specified';
                String SubBrandName='';
                if(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c != null ){
                    SubbrandGroupName=SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c!=NULL?SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Description__c:SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    SubBrandName=SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                }
                
                if(HistoricalVFinalContract.SubBrandGradeGrouping.containskey(SubBrandName)){
                    Decimal TempVolumes=HistoricalVFinalContract.SubBrandGradeGrouping.get(SubBrandName)+Volumes;
                    //remove orignal one
                    HistoricalVFinalContract.SubBrandGradeGrouping.remove(SubBrandName);
                    HistoricalVFinalContract.SubBrandGradeGrouping.put(SubBrandName,TempVolumes); 
                }else{
                    HistoricalVFinalContract.SubBrandGradeGrouping.put(SubBrandName,Volumes); 
                }
                
                if(HistoricalVFinalContract.SubBrandGradeMap.containskey(SubbrandGroupName)){
                    Decimal TempVolumes=HistoricalVFinalContract.SubBrandGradeMap.get(SubbrandGroupName)+Volumes;
                    //remove orignal one
                    HistoricalVFinalContract.SubBrandGradeMap.remove(SubbrandGroupName);
                    HistoricalVFinalContract.SubBrandGradeMap.put(SubbrandGroupName,TempVolumes); 
                }else{
                    HistoricalVFinalContract.SubBrandGradeMap.put(SubbrandGroupName,Volumes); 
                }
                
                //By Brande Product Category Grouping  
                if(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__c !=null && SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__c !=null ){
                    String CategoryName = SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_HK_CRM_Product_Category__r.Name;
                    if(HistoricalVFinalContract.CategoryMap.containskey(CategoryName)){
                        Decimal TempVolumes=HistoricalVFinalContract.CategoryMap.get(CategoryName)+Volumes;
                        //remove orignal one
                        HistoricalVFinalContract.CategoryMap.remove(CategoryName);
                        HistoricalVFinalContract.CategoryMap.put(CategoryName,TempVolumes); 
                    }else{
                        HistoricalVFinalContract.CategoryMap.put(CategoryName,Volumes);
                    }
                }// end of By Brande Product Category Grouping      
                
                
                date SubbrandVolumeDateKey = FYConversion(SubBrandVolume.ASI_CRM_End_Date__c);
                String SubbrandVolumeStrKey = string.valueof(SubbrandVolumeDateKey) + SubBrandVolume.ASI_CRM_Subbrand__c;
                
                if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(SubbrandVolumeStrKey)){
                    historical_sbDataROI_map.get(SubbrandVolumeStrKey).TotalVolume += VarHistTotalVolume;
                }
                
                String SuBBrandKey =SBGradeSorting(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c) + SubBrandVolume.ASI_CRM_Subbrand__r.Name; 
                
                if(HistoricalVFinalContract.ContractLineMap.containskey(SuBBrandKey)){
                    HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalBottles =HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalBottles + VariableHistoricalBottles ;
                    HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalTotalFees +=  HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalFees * VarHistTotal;
                    HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalActualVolume =HistoricalVFinalContract.ContractLineMap.get(SuBBrandKey).HistoricalActualVolume + VariableHistoricalBottles ;
                }else{
                    ContractLine ContractDetail = new ContractLine ();
                    ContractDetail.HistoricalBottles = VariableHistoricalBottles;
                    ContractDetail.HistoricalActualVolume= VariableHistoricalBottles;
                    //ContractDetail.HistoricalTotalFees=0;
                    ContractDetail.SubBrandName=SubBrandVolume.ASI_CRM_Subbrand__r.Name;
                    ContractDetail.SubBrandGrade= SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    HistoricalVFinalContract.ContractLineMap.put(SuBBrandKey,ContractDetail);
                }
                
                Decimal VolumesCR12 = 0; 
                VolumesCR12 += SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c:0;
                VolumesCR12 += SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c:0;
                VolumesCR12 += SubBrandVolume.ASI_CRM_PR_Direct_CR12__c!=null? SubBrandVolume.ASI_CRM_PR_Direct_CR12__c:0;
                HistoricalVFinalContract.IntakeCR12 += VolumesCR12;
                
            }//end of Sub Brand Volume for looping
            
            
            AdditionalFIMap.put('TotalBlackCap_prorate',TotalBlackCap_prorate); 
            AdditionalFIMap.put('Total_IntakeBtl_prorate',Total_IntakeBtl_prorate); 
            AdditionalFIMap.put('TotalBC_prorate',TotalBC_prorate); 
            system.debug('HistoricalVFinalContract Volumes: '+HistoricalVFinalContract.Volumes);
            
            
            //Prorate Investment CR12 for Historical Contract
            if (PeriodA != 0 && PeriodB!= 0 && PeriodA != null && PeriodB!= null){
                HistoricalVFinalContract.IntakeCR12 = HistoricalVFinalContract.IntakeCR12/PeriodA * PeriodB;
            }
            
            
            
            //YTD CM/GS
            map<string, decimal> Latest_ActualCM = new map<string, decimal>();
            map<string, decimal> Latest_ActualGS = new map<string, decimal>();
            map<string, decimal> ProForma_LatestBudgetCM = new map<string, decimal>();
            date HistoricalVFinalStartDate = thisCC.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
           
            system.debug('HistoricalVFinalStartDate: '+HistoricalVFinalStartDate);
            system.debug('TillEnd: '+TillEnd);
            for (ASI_CRM_CM_GS__c line : [SELECT id, ASI_CRM_CM_GS_per_9L__c, ASI_CRM_TYPE__c, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c,
                                          ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_CN_Month_End_Date__c,
                                          ASI_CRM_PRODUCTCODE__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c
                                          FROM ASI_CRM_CM_GS__c
                                          WHERE ASI_CRM_PRODUCTCODE__c IN :HistoricalVFinalSBIdSet
                                          AND ASI_CRM_Region__c = :thisCC.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                          AND ASI_CRM_CN_Month_End_Date__c >= :HistoricalVFinalStartDate   
                                          AND ASI_CRM_CN_Month_End_Date__c <= :TillEnd 
                                          AND (ASI_CRM_TYPE__c = 'YTD CM' OR ASI_CRM_TYPE__c = 'YTD GS') AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0 ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC ])
            {
                
                String strkey = string.valueof(line.ASI_CRM_CN_Month_End_Date__c) + line.ASI_CRM_PRODUCTCODE__c;
                if (line.ASI_CRM_TYPE__c == 'YTD CM'){
                    
                    if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(strkey)){
                        if (historical_sbDataROI_map.get(strkey).CM == null || historical_sbDataROI_map.get(strkey).CM == 0){
                            historical_sbDataROI_map.get(strkey).CM = line.ASI_CRM_CM_GS_per_9L__c;
                            historical_sbDataROI_map.get(strkey).SubBrandId = line.ASI_CRM_PRODUCTCODE__c;
                        }
                    }
                    if (!Latest_ActualCM.containskey(line.ASI_CRM_PRODUCTCODE__c)){
                        Latest_ActualCM.put(line.ASI_CRM_PRODUCTCODE__c, line.ASI_CRM_CM_GS_per_9L__c);
                    }
                    
                    if(!ProForma_LatestBudgetCM.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                        if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                            ProForma_LatestBudgetCM.put(line.ASI_CRM_PRODUCTCODE__c,RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c));// system.debug(line.ASI_CRM_PRODUCTCODE__c+'Debug7.1:'+RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c));
                        }
                    }
                }
                
                if (line.ASI_CRM_TYPE__c == 'YTD GS'){
                    if (!Latest_ActualGS.containskey(line.ASI_CRM_PRODUCTCODE__c)){
                        Latest_ActualGS.put(line.ASI_CRM_PRODUCTCODE__c, line.ASI_CRM_CM_GS_per_9L__c);
                    } 
                    if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(strkey)){
                        if (historical_sbDataROI_map.get(strkey).GS == null || historical_sbDataROI_map.get(strkey).GS == 0){
                            historical_sbDataROI_map.get(strkey).GS =  line.ASI_CRM_CM_GS_per_9L__c;
                            historical_sbDataROI_map.get(strkey).SubBrandId = line.ASI_CRM_PRODUCTCODE__c;
                        }
                    } 
                }
                
                if (historical_sbDataROI_map != null && historical_sbDataROI_map.containskey(strkey)){
                    if (historical_sbDataROI_map.get(strkey).latestBudgetCM == null || historical_sbDataROI_map.get(strkey).latestBudgetCM == 0){
                        if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                            historical_sbDataROI_map.get(strkey).latestBudgetCM = RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c);
                        }
                    }
                    historical_sbDataROI_map.get(strkey).SubBrandId = line.ASI_CRM_PRODUCTCODE__c;
                }
                
                if(!ProForma_LatestBudgetCM.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                    if ( RegionSubBrandCM_Map.containsKey(line.ASI_CRM_PRODUCTCODE__c)){
                        ProForma_LatestBudgetCM.put(line.ASI_CRM_PRODUCTCODE__c,RegionSubBrandCM_Map.get(line.ASI_CRM_PRODUCTCODE__c));
                    }
                }
                
                
            } // end of CM /GS Looping
            
            
            
            Decimal CMTotalVFinal=0;
            Decimal LatestBudgetCMTotalVFinal = 0;
            //ROI Calculations for Historical
            if (historical_sbDataROI_map != null && historical_sbDataROI_map.size() > 0){
                decimal ActualCM;
                decimal LatestBudgetCM;
                decimal LatestBudgetCM_prorate;
                decimal ActualGS;
                decimal TotalActualVol;
                decimal PeriodStr;
                decimal ActualCM_prorate;
                decimal ActualGS_prorate;
                date historicalVFinalTillEnd;
                
                if (thisCC.ASI_CRM_CN_PO_End_Date__c != null && CutOffDay >= thisCC.ASI_CRM_CN_PO_End_Date__c)
                    historicalVFinalTillEnd = getEndDate(thisCC.ASI_CRM_CN_PO_End_Date__c);
                else
                    historicalVFinalTillEnd = CutOffDay;
                
                Integer PeriodA_prorate = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, historicalVFinalTillEnd);
                Integer PeriodB_prorate = MonthDiff(thisCC.ASI_CRM_CN_PO_Start_Date__c, thisCC.ASI_CRM_CN_PO_End_Date__c);
                Integer PeriodD_prorate = PeriodB_prorate - PeriodA_prorate;
                
                for (string key : historical_sbDataROI_map.keyset()){
                    PeriodStr= null;
                    if (historical_sbDataROI_map.get(key).period != null){
                        PeriodStr = historical_sbDataROI_map.get(key).period;
                    }
                    //Actual CM
                    ActualCM = null;
                    if (historical_sbDataROI_map.get(key).CM != null && historical_sbDataROI_map.get(key).CM != 0){
                        ActualCM = historical_sbDataROI_map.get(key).CM;
                    }else{
                        if (Latest_ActualCM != null && Latest_ActualCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                            ActualCM = Latest_ActualCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                        }
                    }
                    
                    //Latest Budget CM
                    LatestBudgetCM = null;
                    if (historical_sbDataROI_map.get(key).latestBudgetCM != null){
                        LatestBudgetCM = historical_sbDataROI_map.get(key).latestBudgetCM;
                    }else{
                        if (ProForma_LatestBudgetCM != null && ProForma_LatestBudgetCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                            LatestBudgetCM = ProForma_LatestBudgetCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                        }
                    }
                    //Actual GS
                    ActualGS = null;
                    if (historical_sbDataROI_map.get(key).GS != null && historical_sbDataROI_map.get(key).GS != 0){
                        ActualGS = historical_sbDataROI_map.get(key).GS;
                    }else{
                        if (Latest_ActualGS != null && Latest_ActualGS.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                            ActualGS = Latest_ActualGS.get(historical_sbDataROI_map.get(key).SubBrandId);
                        }
                    }
                    //Total Volume
                    TotalActualVol = null;
                    if (historical_sbDataROI_map.get(key).TotalVolume != null){
                        TotalActualVol = historical_sbDataROI_map.get(key).TotalVolume;
                    }
                    if (TotalActualVol != null && ActualCM != null ){ 
                        CMTotalVFinal += ActualCM * TotalActualVol; 
                    }
                    
                    if (TotalActualVol != null && LatestBudgetCM != null ){
                        LatestBudgetCMTotalVFinal += LatestBudgetCM * TotalActualVol;
                    }
                    
                    ActualCM_prorate = 0;
                    if (latest_ActualCM != null && latest_ActualCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                        ActualCM_prorate = latest_ActualCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                    }  
                    
                    LatestBudgetCM_prorate = 0;
                    if (ProForma_LatestBudgetCM != null && ProForma_LatestBudgetCM.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                        LatestBudgetCM_prorate = ProForma_LatestBudgetCM.get(historical_sbDataROI_map.get(key).SubBrandId);
                    } 
                    
                    if (PeriodA_prorate != null && PeriodA_prorate != 0 && TotalActualVol != null && TotalActualVol != 0 && PeriodD_prorate != null && ActualCM_prorate != null)
                        CMTotalVFinal += ActualCM_prorate * TotalActualVol / PeriodA_prorate * PeriodD_prorate;
                    
                    if (PeriodA_prorate != null && PeriodA_prorate != 0 && TotalActualVol != null && TotalActualVol != 0 && PeriodD_prorate != null && LatestBudgetCM_prorate != null){
                        LatestBudgetCMTotalVFinal += LatestBudgetCM_prorate * TotalActualVol / PeriodA_prorate * PeriodD_prorate;
                    }
                    
                    if (TotalActualVol != null && ActualGS != null){
                        HistoricalVFinalContract.GrossSalesTotal += ActualGS * TotalActualVol;//system.debug('New Historical Gross Sales: ' + historical_sbDataROI_map.get(key).SubBrandId + ' ' + ActualGS + ' * ' + TotalActualVol );
                    }
                    ActualGS_prorate = 0;
                    if (latest_ActualCM != null && latest_ActualGS.containskey(historical_sbDataROI_map.get(key).SubBrandId)){
                        ActualGS_prorate = latest_ActualGS.get(historical_sbDataROI_map.get(key).SubBrandId);
                    }   
                    if (PeriodA_prorate != null && PeriodA_prorate != 0 && TotalActualVol != null && TotalActualVol != 0 && PeriodD_prorate != null && ActualGS_prorate != null){
                        HistoricalVFinalContract.GrossSalesTotal  += ActualGS_prorate * TotalActualVol / PeriodA_prorate * PeriodD_prorate;
                    }
                    
                } // end of looping historical_sbDataROI_map
                
            }
            system.debug(CMTotalVFinal+'Laputa system.debug latestBudgetCMTotal.strA '+LatestBudgetCMTotalVFinal);
            //Historical V Final Calculation
            
            //%Gross Sales Historical
            if (HistoricalVFinalContract.GrossSalesTotal != null && HistoricalVFinalContract.GrossSalesTotal != 0 && HistoricalVFinalContract.TradeExpenses != 0 && HistoricalVFinalContract.TradeExpenses!= null){
                HistoricalVFinalContract.GrossSalesRate = (HistoricalVFinalContract.TradeExpenses/ HistoricalVFinalContract.GrossSalesTotal) *100;
            }
            
            //Fixed Expense Rate
            if (HistoricalVFinalContract.FixedExpense != 0 &&  HistoricalVFinalContract.TradeExpenses!= 0 && HistoricalVFinalContract.FixedExpense != null &&  HistoricalVFinalContract.TradeExpenses != null){
                HistoricalVFinalContract.FixedExpenseRate = HistoricalVFinalContract.FixedExpense/ HistoricalVFinalContract.TradeExpenses * 100;
            }
            //Historical Contract Margin after A&P
            if (CMTotalVFinal != null && HistoricalVFinalContract.FixedExpense != null){
                HistoricalVFinalContract.MarginAfterAnP = CMTotalVFinal - HistoricalVFinalContract.TradeExpenses;
            }
            
            if (TotalHC_VolumeBtl != 0 && TotalHC_VolumeBtl!= null && HistoricalVFinalContract.MarginAfterAnP != 0 && HistoricalVFinalContract.MarginAfterAnP != null){
                HistoricalVFinalContract.MarginPerBottle = HistoricalVFinalContract.MarginAfterAnP / TotalHC_VolumeBtl;
                HistoricalVFinalContract.IntakeSTD=TotalHC_VolumeBtl;
            }
            
            
            if(HistoricalVFinalContract.IntakeCR12!=null && HistoricalVFinalContract.IntakeCR12 !=0 && HistoricalVFinalContract.TradeExpenses!=null){
                HistoricalVFinalContract.InvestmentCR12 =HistoricalVFinalContract.TradeExpenses/HistoricalVFinalContract.IntakeCR12; 
            }
            
            if (CMTotalVFinal != null && CMTotalVFinal != 0 && HistoricalVFinalContract.TradeExpenses != 0 && HistoricalVFinalContract.TradeExpenses!= null){
                HistoricalVFinalContract.CMTotal=CMTotalVFinal;
                HistoricalVFinalContract.ROIIntake = CMTotalVFinal / HistoricalVFinalContract.TradeExpenses;
            }
            //ProForma_ROI Historical
            if (LatestBudgetCMTotalVFinal != null && LatestBudgetCMTotalVFinal != 0 &&   HistoricalVFinalContract.TradeExpenses!= 0 &&  HistoricalVFinalContract.TradeExpenses!= null){
                HistoricalVFinalContract.LatestBudgetCMTotal=LatestBudgetCMTotalVFinal;
                HistoricalVFinalContract.ROIProForma = LatestBudgetCMTotalVFinal / HistoricalVFinalContract.TradeExpenses;
            }
            
            if(TotalHC_BC!=0 && TotalHC_BC !=null && TotalHC_IntakeBtl !=null && TotalHC_IntakeBtl!=0){
                HistoricalVFinalContract.TotalBCRate=(TotalHC_BC/TotalHC_IntakeBtl)*100;
                HistoricalVFinalContract.NetBCRate=((TotalHC_BC-TotalBackCap)/TotalHC_IntakeBtl)*100;
            }
            
            if(TotalHistorical_MartellBC!=0 && TotalHistorical_MartellBC !=null && TotalHistorical_MartellIntakeBtl !=null && TotalHistorical_MartellIntakeBtl!=0){
                HistoricalVFinalContract.TotalMBCRate=(TotalHistorical_MartellBC/TotalHistorical_MartellIntakeBtl)*100;
                HistoricalVFinalContract.NetMBCRate=((TotalHistorical_MartellBC-TotalHistorical_MartellBlackCap)/TotalHistorical_MartellIntakeBtl)*100;
            }
            
            
			            
            AdditionalFIMap.put('TotalHistorical_MartellBC',TotalHistorical_MartellBC); 
            AdditionalFIMap.put('TotalHistorical_MartellIntakeBtl',TotalHistorical_MartellIntakeBtl); 
            AdditionalFIMap.put('TotalHistorical_MartellBlackCap',TotalHistorical_MartellBlackCap); 
            
            AdditionalFIMap.put('TotalHC_BC',TotalHC_BC); 
            AdditionalFIMap.put('TotalHC_IntakeBtl',TotalHC_IntakeBtl); 
        }
        
        HistoricalVFinalContract.AddOnString = System.JSON.serialize(AdditionalFIMap);
        
        List<FinancialIndicator> FinancialIndicatorList = new List<FinancialIndicator>();
        FinancialIndicatorList.add(HistoricalV00Contract);
        FinancialIndicatorList.add(HistoricalVFinalContract);
        
        UpsertAttachment(thisCC.Id, System.JSON.serialize(FinancialIndicatorList),'Current V0VFinal Data' );
        
    } // end of RestructureHistoricalData
    
    
    
    
    //*****************************Function support for 'RestructureHistoricalData' class ****************************************************
    
    // Insert Attachment Json
    public static void  UpsertAttachment(String ContractId, String JSONString, String TypeName){// Update field ASI_CRM_Historical_Financial_Data__c 
        List<ASI_Attachment__c> AttachmentList= new  List<ASI_Attachment__c>();
        
        JSONString= JSONString.replaceAll('<','&lt;');
        
        
        try{
            ASI_Attachment__c FinancialData = new ASI_Attachment__c();
            AttachmentList= [select id,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_Contract__c,ASI_CRM_Type__c from ASI_Attachment__c where ASI_CRM_Contract__c = :ContractId and ASI_CRM_Type__c = : TypeName];
            //system.debug('Tony JSONString : '+JSONString);
            
            if(AttachmentList.size()>0){//exist
                FinancialData=AttachmentList[0];
                FinancialData.ASI_CRM_Historical_Financial_Data__c= JSONString;
                
            }else{
                FinancialData= new ASI_Attachment__c(ASI_CRM_For_Contract_Use__c=true,ASI_CRM_Contract__c=ContractId,ASI_CRM_Type__c=TypeName,ASI_CRM_Historical_Financial_Data__c=JSONString);
                
            }
            upsert FinancialData;//system.debug(FinancialData);
            
        }catch(Exception e){ 
            String msg = 'UpsertAttachment  Error : ' +e.getMessage();
            ASI_MFM_ByPass_Setting.ErrorHandling('UpsertAttachment '+ msg+' with contarct Id '+ContractId + ' with Json string : '+ JSONString , 'ASI_CRM_CN_HeavyContractUtilitiesClass','RestructureHistoricalFinancialIndicatorData.UpsertAttachment');
        }
    }
    
    //Generate Cut Off Date  If today <16, previous 2 month; else previous one month
    public static date GenerateCutOffDate(){
        integer strDay=16;
        Date returnDate;
        Integer strDate = Date.Today().Day();
        Integer strMonth;
        Integer strEndDay;
        
        if (strDate >= strDay){
            strMonth = Date.Today().Month() - 1;
        }
        else if (strDate < strDay){
            strMonth = Date.Today().Month() - 2;
        }
        strEndDay = Date.daysInMonth(Date.Today().Year(), strMonth);
        returnDate = Date.newinstance(Date.Today().Year(),strMonth,strEndDay);
        
        return returnDate;
    }
    
    
    
    
    //Generate CR12 Factor Mapping table : Sub-Brand Id, CR12 Factor 
    public static Map<String,Decimal> GenerateCR12FactorMap(Set<Id> SBIdSet, String CommercialTeam, String RegionName){
        Map<String,Decimal> CR12FactorMap = new Map<String,Decimal> ();
        for(ASI_MFM_Sub_brand__c SubBrand: [select Id,ASI_CRM_CN_COnvfactor_Ltocr12_C__c,(select id,ASI_CRM_CR12_Conversion_Factor__c,ASI_CRM_Commercial_Team__c,ASI_CRM_CN_Region__c from ASI_CRM_CR12_Factors__r) from ASI_MFM_Sub_brand__c  where id in : SBIdSet ]){
            Decimal CR12Factor=1;
            Boolean FoundFactor = false;
            for(ASI_CRM_Sub_Brand_Line__c SubBrandLine: SubBrand.ASI_CRM_CR12_Factors__r){
                if(RegionName !=null && CommercialTeam !=null && SubBrandLine.ASI_CRM_CR12_Conversion_Factor__c !=null &&  SubBrandLine.ASI_CRM_Commercial_Team__c == CommercialTeam && SubBrandLine.ASI_CRM_CN_Region__c == RegionName ){
                    CR12Factor=SubBrandLine.ASI_CRM_CR12_Conversion_Factor__c;
                    FoundFactor=true;
                }
            }
            if(!FoundFactor && SubBrand.ASI_CRM_CN_COnvfactor_Ltocr12_C__c!=null ){
                CR12Factor=SubBrand.ASI_CRM_CN_COnvfactor_Ltocr12_C__c;
                FoundFactor=true;
            }
            if(FoundFactor && CR12Factor!=null){
                CR12FactorMap.put(SubBrand.Id, CR12Factor);
            }
        }
        return CR12FactorMap;
    }
    
    
    public static date getEndDate(date strDate){
        Integer numberOfDays = Date.daysInMonth(strDate.year(), strDate.month());
        Date lastDayOfMonth = Date.newInstance(strDate.year(), strDate.month(), numberOfDays);
        return lastDayofMonth;
    }
    
    
    
    public static date FindMinMaxDate(date Date1, date Date2, string strType){
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
    
    
    
    public static map<date, decimal> checkFYDayPeriod(date startDate, date endDate){
        map<date, decimal> returnDateMap = new map<date, decimal>();
        Integer EndFY;
        Integer StartFY;
        date returnDate;
        date tempDate = startDate;
        if (startDate != null && endDate != null){
            if (startDate.Month() > 6 && startDate.Month() < 13){
                StartFY = startDate.Year() + 1;
            }else if (startDate.Month() < 7 && startDate.Month() > 0){
                StartFY = startDate.Year();
            }
            if (endDate.Month() > 6 && endDate.Month() < 13){
                EndFY = endDate.Year() + 1;
            }else if (endDate.Month() < 7 && endDate.Month() > 0){
                EndFY = endDate.Year();
            }
            integer strPeriod = EndFY - StartFY + 1;
            integer strtemp = 0;
            if (strPeriod >= 0){
                for (integer i=0; i<strPeriod; i++){
                    returnDate = Date.newinstance(StartFY,6,30);
                    if (returnDate <= startDate){
                        strtemp = MonthDiff(returnDate, startDate);
                    }else if (returnDate > startDate && returnDate < endDate){
                        strtemp = MonthDiff(tempDate, returnDate);
                    }else if (returnDate >= endDate){
                        strtemp = MonthDiff(tempDate, endDate);
                    }else if (returnDate >= startDate && returnDate >= endDate){
                        strtemp = MonthDiff(startDate, returnDate);
                    }
                    returnDateMap.put(returnDate, decimal.valueof(strtemp));
                    tempDate = Date.newinstance(StartFY,7,1);
                    StartFY++;
                }
            }
            return returnDateMap;
        }else{
            return null;
        }
    }
    
    public static date FYConversion(date strDate){
        date returndate;
        integer EndFY;
        if (strDate.Month() > 6 && strDate.Month() < 13){
            EndFY = strDate.Year() + 1;
        }else if (strDate.Month() < 7 && strDate.Month() > 0){
            EndFY = strDate.Year();
        }
        returndate = date.newinstance(EndFY,6,30);
        return returnDate;
    }
    
    //Calculate month difference : like Integer PeriodA = MonthDiff(date.newinstance(2016,7, 1), date.newinstance(2017,6, 30));
    public static integer MonthDiff(date startDate, date endDate){ 
        Integer monthDiff;
        if (startDate != null && endDate != null){
            monthDiff = ((endDate.YEAR() - startDate.YEAR() - 1) *12) + (12 - startDate.MONTH() +1) + endDate.MONTH();
            return monthDiff;
        }else{
            return null;
        }
    }
    
    
    
    //Payment Summary table in Payment view page 
    public Class PaymentSummary{
        public String Name {set;get;}{Name='';}
        public String EnglishDescription {set;get;}{EnglishDescription='';}
        public String ACCodeId {set;get;}{ACCodeId='';}
        public Decimal POEstimatedAmount {set;get;}{POEstimatedAmount=0;}
        public Decimal LastVersion_POEstimatedAmount {set;get;}{LastVersion_POEstimatedAmount=0;}
        public Decimal PaidAmount{set;get;}{PaidAmount=0;}
        public Decimal PaymentRequestAmount {set;get;} {PaymentRequestAmount=0;}
        
        public PaymentSummary(){
            
        }
    }
    
    
    
    
    //For PO Modification Page PDF
    public static List<PaymentSummary> POModificationPaymentSummaryTable( ASI_TH_CRM_Contract__c contract){
        Map<String,PaymentSummary> PaymentSummaryMap = new Map<String,PaymentSummary> (); 
        String BRSFName='空瓶回收费';
        String PSFName='合同奖励';
        String VECName= '活动费用(变动)';
        Id lastContractID; // Last version  Contract Id
        if(contract!=null){
            lastContractID = contract.ASI_CRM_CN_Last_PO_version__c; 
        }
        
        //Contract Cost Setting
        for(ASI_CRM_Contract_Cost__c ContractCost:[Select id, name,ASI_CRM_Other_Est__c,ASI_CRM_CN_Activity_Code__r.ASI_MFM_A_C_Description__c, ASI_CRM_CN_Activity_Code__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Contract__r.ASI_TH_CRM_Promotion_Type__c  from ASI_CRM_Contract_Cost__c 
                                                   where ASI_CRM_CN_Contract__c = :contract.Id or ASI_CRM_CN_Contract__c=:lastContractID  order by ASI_CRM_CN_Sequence__c ASC, 
                                                   ASI_CRM_CN_Activity_Code__r.ASI_CRM_Promotion_Type__r.ASI_CRM_Sequence__c ASC])
        {
            if(PaymentSummaryMap.containsKey(ContractCost.ASI_CRM_CN_Chinese_Description__c)){
                if(ContractCost.ASI_CRM_CN_Contract__c==lastContractID){
                    PaymentSummaryMap.get(ContractCost.ASI_CRM_CN_Chinese_Description__c).LastVersion_POEstimatedAmount += ContractCost.ASI_CRM_CN_Estimate_Amount__c !=null? ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                }else{
                    PaymentSummaryMap.get(ContractCost.ASI_CRM_CN_Chinese_Description__c).POEstimatedAmount += ContractCost.ASI_CRM_CN_Estimate_Amount__c !=null? ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                }
            }else{ // dont contain in the map
                PaymentSummary tempData= new PaymentSummary();
                tempData.ACCodeId=ContractCost.ASI_CRM_CN_Activity_Code__c;
                tempData.Name=ContractCost.ASI_CRM_CN_Chinese_Description__c;
                tempData.EnglishDescription=ContractCost.ASI_CRM_CN_Activity_Code__r.ASI_MFM_A_C_Description__c;
                if(ContractCost.ASI_CRM_CN_Contract__c==lastContractID){
                    tempData.POEstimatedAmount=ContractCost.ASI_CRM_CN_Estimate_Amount__c!=null? ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                }else{
                    tempData.POEstimatedAmount=ContractCost.ASI_CRM_CN_Estimate_Amount__c !=null? ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                }
                PaymentSummaryMap.put(tempData.Name, tempData);
            }
            
        }
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:[SELECT id,ASI_CRM_Module__c, ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Product_Category__c , ASI_CRM_Volume_Base__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c,ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c  FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                WHERE ASI_CRM_CN_Contract__c = :contract.Id  or ASI_CRM_CN_Contract__c=:lastContractID  ] )
        {
            if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                if(PaymentSummaryMap.containsKey(BRSFName)){
                    if(ContractLine.ASI_CRM_CN_Contract__c==lastContractID){
                        PaymentSummaryMap.get(BRSFName).LastVersion_POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }else{
                        // PaymentSummaryMap.get(BRSFName).POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total__c!=null? ContractLine.ASI_CRM_CN_Est_Total__c:0;
                    }
                }else{
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=ContractLine.ASI_CRM_CN_Activity_Code__c;
                    tempData.Name=BRSFName;
                    tempData.EnglishDescription='BRSF';
                    if(ContractLine.ASI_CRM_CN_Contract__c==lastContractID){
                        tempData.LastVersion_POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }else{
                        //tempData.POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total__c!=null? ContractLine.ASI_CRM_CN_Est_Total__c:0; 
                    }
                    PaymentSummaryMap.put(BRSFName, tempData); 
                }
            }
            
            if(ContractLine.ASI_CRM_Type__c=='PSF'){
                if(PaymentSummaryMap.containsKey(PSFName)){
                    if(ContractLine.ASI_CRM_CN_Contract__c==lastContractID){
                        PaymentSummaryMap.get(PSFName).LastVersion_POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }else{
                        // PaymentSummaryMap.get(PSFName).POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }
                }else{
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=ContractLine.ASI_CRM_CN_Activity_Code__c;
                    tempData.Name=PSFName;
                    tempData.EnglishDescription='PRC - PSF & Trading Term Incentives';
                    if(ContractLine.ASI_CRM_CN_Contract__c==lastContractID){
                        tempData.LastVersion_POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }else{
                        //  tempData.POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total__c!=null? ContractLine.ASI_CRM_CN_Est_Total__c:0; 
                    }
                    PaymentSummaryMap.put(PSFName, tempData);  
                }
            }
            
            if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                if(PaymentSummaryMap.containsKey(VECName)){
                    if(ContractLine.ASI_CRM_CN_Contract__c==lastContractID){
                        PaymentSummaryMap.get(VECName).LastVersion_POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }else{
                        //  PaymentSummaryMap.get(VECName).POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }
                }else{
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=ContractLine.ASI_CRM_CN_Activity_Code__c;
                    tempData.Name=VECName;
                    tempData.EnglishDescription='PRC - Variable Event Cost';
                    if(ContractLine.ASI_CRM_CN_Contract__c==lastContractID){
                        tempData.LastVersion_POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }else{
                        //  tempData.POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }
                    PaymentSummaryMap.put(VECName, tempData);  
                }
            }
        }//End of looping  Contract Line
        
        //ASI_CRM_CN_Expected_BRSF_Est_Total__c
        
        if(PaymentSummaryMap.containsKey(BRSFName)){
            if(contract.ASI_CRM_CN_PO_Version__c!='0.1' && contract.ASI_CRM_Copied_From__c!=null){
                PaymentSummaryMap.get(BRSFName).LastVersion_POEstimatedAmount=contract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_BRSF_Est_Total__c;
            }
            PaymentSummaryMap.get(BRSFName).POEstimatedAmount +=contract.ASI_CRM_CN_Expected_BRSF_Est_Total__c!=null? contract.ASI_CRM_CN_Expected_BRSF_Est_Total__c:0;
        }
        if(PaymentSummaryMap.containsKey(PSFName)){
            if(contract.ASI_CRM_CN_PO_Version__c!='0.1' && contract.ASI_CRM_Copied_From__c!=null ){
                PaymentSummaryMap.get(PSFName).LastVersion_POEstimatedAmount=contract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c;
            }
            PaymentSummaryMap.get(PSFName).POEstimatedAmount +=contract.ASI_CRM_CN_Expected_PSF_Est_Total__c!=null? contract.ASI_CRM_CN_Expected_PSF_Est_Total__c:0;
        }        
        if(PaymentSummaryMap.containsKey(VECName)){
            if(contract.ASI_CRM_CN_PO_Version__c!='0.1' && contract.ASI_CRM_Copied_From__c!=null  ){
                PaymentSummaryMap.get(VECName).LastVersion_POEstimatedAmount=contract.ASI_CRM_Copied_From__r.ASI_CRM_EVC_Cost_Estimate_Total__c;
            }
            PaymentSummaryMap.get(VECName).POEstimatedAmount +=contract.ASI_CRM_EVC_Cost_Estimate_Total__c!=null? contract.ASI_CRM_EVC_Cost_Estimate_Total__c:0;
        }
        
        
        
        //RecordType.DeveloperName like 'ASI_CRM_CN%'
        for(ASI_TH_CRM_PaymentRequestLineItem__c PaymentLine: [Select id, name,ASI_TH_CRM_Payment_Request__r.Name, RecordType.DeveloperName,ASI_CRM_CN_Total_Payable__c, recordtypeid, ASI_TH_CRM_Amount__c,ASI_CRM_CN_AC_Code__r.ASI_MFM_A_C_Description__c, ASI_CRM_CN_Expense_Type__c, ASI_CRM_CN_AC_Code__c  
                                                               from ASI_TH_CRM_PaymentRequestLineItem__c 
                                                               where ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c = :contract.Id 
                                                               and (ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Approved' or ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Submitted' or ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Paid') ])
        {
            if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_Other'){
                if(PaymentSummaryMap.containsKey(PaymentLine.ASI_CRM_CN_Expense_Type__c)){
                    PaymentSummaryMap.get(PaymentLine.ASI_CRM_CN_Expense_Type__c).PaymentRequestAmount += PaymentLine.ASI_TH_CRM_Amount__c !=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                }else{ // dont contain in the map
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=PaymentLine.ASI_CRM_CN_AC_Code__c;
                    tempData.Name=PaymentLine.ASI_CRM_CN_Expense_Type__c;
                    tempData.PaymentRequestAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                    PaymentSummaryMap.put(tempData.Name, tempData);
                }
            }else if(PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.length()>3){
                
                //Including 000- Payment 
                if(PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.substring(PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.length()-3, PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.length()) == '000'){
                    String PaymentSummaryKey ='';
                    Decimal PaymentAmount=0;
                    if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_BRSF'){
                       PaymentSummaryKey=BRSFName;
                       PaymentAmount=PaymentLine.ASI_CRM_CN_Total_Payable__c!=null? PaymentLine.ASI_CRM_CN_Total_Payable__c:0;
                   }
                   
                   if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_PSF'){
                        PaymentSummaryKey=PSFName;
                        PaymentAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                   }
                   
                   if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_VEC'){
                       PaymentSummaryKey=VECName;
                       PaymentAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                   }
                    system.debug(PaymentSummaryKey+'Actual_Payment Amount00:'+PaymentAmount);
                    
                    if(PaymentSummaryMap.containsKey(PaymentSummaryKey)){//ASI_CRM_CN_Total_Payable__c
                        PaymentSummaryMap.get(PaymentSummaryKey).PaymentRequestAmount += PaymentAmount;
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=PaymentSummaryKey;
                        tempData.PaymentRequestAmount=PaymentAmount;
                        PaymentSummaryMap.put(PaymentSummaryKey, tempData);  
                    }
                    
                }
                
            }
            
        }
        
        
        
        for(ASI_TH_CRM_PaymentRequest__c PaymentRequest : [select Id,Name,ASI_TH_CRM_Status__c,(select Id,ASI_CRM_Line_Type__c,ASI_CRM_Actual_Payment__c from ASI_CRM_Modules__r) 
                                                           from ASI_TH_CRM_PaymentRequest__c where ASI_TH_CRM_Contract__c = :contract.Id and (ASI_TH_CRM_Status__c = 'Approved' or ASI_TH_CRM_Status__c = 'Submitted' or ASI_TH_CRM_Status__c = 'Paid') ])
        {//or
            for(ASI_CRM_Module__c module:PaymentRequest.ASI_CRM_Modules__r){
                system.debug(module.ASI_CRM_Line_Type__c+'Actual_Payment Amount11:'+module.ASI_CRM_Actual_Payment__c);
                if(module.ASI_CRM_Line_Type__c=='BRSF'){
                    if(PaymentSummaryMap.containsKey(BRSFName)){
                        PaymentSummaryMap.get(BRSFName).PaymentRequestAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=BRSFName;
                        tempData.PaymentRequestAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        PaymentSummaryMap.put(BRSFName, tempData);  
                    }
                }
                
                if(module.ASI_CRM_Line_Type__c=='PSF'){
                    if(PaymentSummaryMap.containsKey(PSFName)){
                        PaymentSummaryMap.get(PSFName).PaymentRequestAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=PSFName;
                        tempData.PaymentRequestAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        PaymentSummaryMap.put(PSFName, tempData);  
                    }
                }
                
                if(module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                    if(PaymentSummaryMap.containsKey(VECName)){
                        PaymentSummaryMap.get(VECName).PaymentRequestAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=VECName;
                        tempData.PaymentRequestAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        PaymentSummaryMap.put(VECName, tempData);  
                    }
                }
                
            }
        }
        
        List<PaymentSummary> PaymentSummaryList= new List<PaymentSummary>();
        
        for(string key:PaymentSummaryMap.keySet()){
            PaymentSummaryList.add(PaymentSummaryMap.get(key));
        }
        
        
        
        return PaymentSummaryList;
    }
    
    
    
    
    
    
    //For Payment View Page
    public static List<PaymentSummary> PaymentSummaryTable(ASI_TH_CRM_PaymentRequest__c payment, ASI_TH_CRM_Contract__c contract){
        Map<String,PaymentSummary> PaymentSummaryMap = new Map<String,PaymentSummary> (); //AC Code/ PaymentSummary Table
        String BRSFName='空瓶回收费';
        String PSFName='合同奖励';
        String VECName= '活动费用(变动)';
        
        //*********************Contract Cost Looping******************************************
        for(ASI_CRM_Contract_Cost__c ContractCost:[Select id, name, ASI_CRM_Other_Est__c, ASI_CRM_CN_Activity_Code__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Contract__r.ASI_TH_CRM_Promotion_Type__c  from ASI_CRM_Contract_Cost__c 
                                                   where ASI_CRM_CN_Contract__c = :contract.Id order by ASI_CRM_CN_Sequence__c ASC, ASI_CRM_CN_Activity_Code__r.ASI_CRM_Promotion_Type__r.ASI_CRM_Sequence__c ASC])
        {
            if(PaymentSummaryMap.containsKey(ContractCost.ASI_CRM_CN_Chinese_Description__c))
            {
                PaymentSummaryMap.get(ContractCost.ASI_CRM_CN_Chinese_Description__c).POEstimatedAmount += ContractCost.ASI_CRM_CN_Estimate_Amount__c !=null? ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
            }else{ // dont contain in the map
                PaymentSummary tempData= new PaymentSummary();
                tempData.ACCodeId=ContractCost.ASI_CRM_CN_Activity_Code__c;
                tempData.Name=ContractCost.ASI_CRM_CN_Chinese_Description__c;
                tempData.POEstimatedAmount=ContractCost.ASI_CRM_CN_Estimate_Amount__c!=null? ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                PaymentSummaryMap.put(tempData.Name, tempData);
            }
        }
        
        
        //******************************************Contract Line******************************************
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:[SELECT id,ASI_CRM_Module__c, ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Product_Category__c , ASI_CRM_Volume_Base__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c,ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c  FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                WHERE ASI_CRM_CN_Contract__c = :contract.Id ] )
        {
            if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                if(PaymentSummaryMap.containsKey(BRSFName)){
                    PaymentSummaryMap.get(BRSFName).POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total__c!=null? ContractLine.ASI_CRM_CN_Est_Total__c:0;
                }else{
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=ContractLine.ASI_CRM_CN_Activity_Code__c;
                    tempData.Name=BRSFName;
                    tempData.POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total__c!=null? ContractLine.ASI_CRM_CN_Est_Total__c:0;
                    PaymentSummaryMap.put(BRSFName, tempData); 
                }
            }
            
            if(ContractLine.ASI_CRM_Type__c=='PSF'){
                if(PaymentSummaryMap.containsKey(PSFName)){
                    PaymentSummaryMap.get(PSFName).POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }else{
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=ContractLine.ASI_CRM_CN_Activity_Code__c;
                    tempData.Name=PSFName;
                    tempData.POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    PaymentSummaryMap.put(PSFName, tempData);  
                }
            }
            
            if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                if(PaymentSummaryMap.containsKey(VECName)){
                    PaymentSummaryMap.get(VECName).POEstimatedAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }else{
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=ContractLine.ASI_CRM_CN_Activity_Code__c;
                    tempData.Name=VECName;
                    tempData.POEstimatedAmount=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    PaymentSummaryMap.put(VECName, tempData);  
                }
            }
        }//End of looping  Contract Line
        
        if(contract.ASI_CRM_CN_PO_Version__c!='0.0'){
            if(PaymentSummaryMap.containsKey(PSFName)){
                PaymentSummaryMap.get(PSFName).POEstimatedAmount = contract.ASI_CRM_CN_Expected_PSF_Est_Total__c!=null? contract.ASI_CRM_CN_Expected_PSF_Est_Total__c:0;
            }else{
                PaymentSummary tempData= new PaymentSummary();
                tempData.Name=PSFName;
                tempData.POEstimatedAmount= contract.ASI_CRM_CN_Expected_PSF_Est_Total__c!=null?  contract.ASI_CRM_CN_Expected_PSF_Est_Total__c:0;
                PaymentSummaryMap.put(PSFName, tempData);  
            }
            
        }
        
        //RecordType.DeveloperName like 'ASI_CRM_CN%'
        for(ASI_TH_CRM_PaymentRequestLineItem__c PaymentLine: [Select id, name,ASI_TH_CRM_Payment_Request__r.Name,ASI_CRM_CN_Total_Payable__c,ASI_TH_CRM_Payment_Request__c, RecordType.DeveloperName, recordtypeid, ASI_TH_CRM_Amount__c,ASI_CRM_CN_AC_Code__r.ASI_MFM_A_C_Description__c, ASI_CRM_CN_Expense_Type__c, ASI_CRM_CN_AC_Code__c  
                                                               from ASI_TH_CRM_PaymentRequestLineItem__c where ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c = :contract.Id 
                                                               and (ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Approved' or ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Submitted' or ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Paid' 
                                                                    or ASI_TH_CRM_Payment_Request__c = :payment.Id )  ])
        {
            if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_Other'){
                if(PaymentSummaryMap.containsKey(PaymentLine.ASI_CRM_CN_Expense_Type__c)){
                    if(PaymentLine.ASI_TH_CRM_Payment_Request__c==payment.Id){
                        PaymentSummaryMap.get(PaymentLine.ASI_CRM_CN_Expense_Type__c).PaymentRequestAmount += PaymentLine.ASI_TH_CRM_Amount__c !=null? PaymentLine.ASI_TH_CRM_Amount__c:0;//tempData.PaymentRequestAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                    }else{
                        PaymentSummaryMap.get(PaymentLine.ASI_CRM_CN_Expense_Type__c).PaidAmount += PaymentLine.ASI_TH_CRM_Amount__c !=null? PaymentLine.ASI_TH_CRM_Amount__c:0;// tempData.PaidAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                    }
                    
                }else{ // dont contain in the map
                    PaymentSummary tempData= new PaymentSummary();
                    tempData.ACCodeId=PaymentLine.ASI_CRM_CN_AC_Code__c;
                    tempData.Name=PaymentLine.ASI_CRM_CN_Expense_Type__c;
                    if(PaymentLine.ASI_TH_CRM_Payment_Request__c==payment.Id){
                        tempData.PaymentRequestAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                    }else{
                        tempData.PaidAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                    }
                    
                    PaymentSummaryMap.put(tempData.Name, tempData);
                }
            }else if(PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.length()>3){
                if(PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.substring(PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.length()-3, PaymentLine.ASI_TH_CRM_Payment_Request__r.Name.length()) == '000'){
                   Decimal PaymentAmount=0;
                   String PaymentSummaryKey ='';
                   if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_BRSF'){
                       PaymentSummaryKey=BRSFName;
                       PaymentAmount=PaymentLine.ASI_CRM_CN_Total_Payable__c!=null? PaymentLine.ASI_CRM_CN_Total_Payable__c:0;
                   }
                   
                   if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_PSF'){
                        PaymentSummaryKey=PSFName;
                        PaymentAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                   }
                   
                   if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_VEC'){
                       PaymentSummaryKey=VECName;
                       PaymentAmount=PaymentLine.ASI_TH_CRM_Amount__c!=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
                   }
                   
                    if(PaymentSummaryMap.containsKey(PaymentSummaryKey)){
                        PaymentSummaryMap.get(PaymentSummaryKey).PaidAmount +=PaymentAmount;
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=PaymentSummaryKey;
                        tempData.PaidAmount=PaymentAmount;
                        PaymentSummaryMap.put(PaymentSummaryKey, tempData);  
                    }
                }
            }
            
            
        }
        
        
        
        //PaidAmount
        for(ASI_TH_CRM_PaymentRequest__c PaymentRequest : [select Id,Name,ASI_TH_CRM_Status__c,(select Id,ASI_CRM_Line_Type__c,ASI_CRM_Actual_Payment__c,ASI_CRM_Payment_Request__c from ASI_CRM_Modules__r) 
                                                           from ASI_TH_CRM_PaymentRequest__c where ASI_TH_CRM_Contract__c = :contract.Id and 
                                                           (ASI_TH_CRM_Status__c = 'Approved' or ASI_TH_CRM_Status__c = 'Submitted' or ASI_TH_CRM_Status__c = 'Paid' or Id= :payment.Id )])
        {
            for(ASI_CRM_Module__c module:PaymentRequest.ASI_CRM_Modules__r){
                if(module.ASI_CRM_Line_Type__c=='BRSF'){
                    if(PaymentSummaryMap.containsKey(BRSFName)){
                        if(module.ASI_CRM_Payment_Request__c==payment.Id){
                            PaymentSummaryMap.get(BRSFName).PaymentRequestAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }else{
                            PaymentSummaryMap.get(BRSFName).PaidAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=BRSFName;
                        if(module.ASI_CRM_Payment_Request__c==payment.Id){
                            tempData.PaymentRequestAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }else{
                            tempData.PaidAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }
                        PaymentSummaryMap.put(BRSFName, tempData);  
                    }
                }
                
                if(module.ASI_CRM_Line_Type__c=='PSF'){
                    if(PaymentSummaryMap.containsKey(PSFName)){
                        if(module.ASI_CRM_Payment_Request__c==payment.Id){
                            PaymentSummaryMap.get(PSFName).PaymentRequestAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }else{
                            PaymentSummaryMap.get(PSFName).PaidAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=PSFName;
                        if(module.ASI_CRM_Payment_Request__c==payment.Id){
                            tempData.PaymentRequestAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }else{
                            tempData.PaidAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }
                        PaymentSummaryMap.put(PSFName, tempData);  
                    }
                }
                
                if(module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                    if(PaymentSummaryMap.containsKey(VECName)){
                        if(module.ASI_CRM_Payment_Request__c==payment.Id){
                            PaymentSummaryMap.get(VECName).PaymentRequestAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }else{
                            PaymentSummaryMap.get(VECName).PaidAmount += module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }
                    }else{
                        PaymentSummary tempData= new PaymentSummary();
                        tempData.Name=VECName;
                        if(module.ASI_CRM_Payment_Request__c==payment.Id){
                            tempData.PaymentRequestAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }else{
                            tempData.PaidAmount=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
                        }
                        PaymentSummaryMap.put(VECName, tempData);  
                    }
                }
                
            }
        }
        
        List<PaymentSummary> PaymentSummaryList= new List<PaymentSummary>();
        
        for(string key:PaymentSummaryMap.keySet()){
            PaymentSummaryList.add(PaymentSummaryMap.get(key));
        }
        
        return PaymentSummaryList;
    }
    
    
    //Generate BRSF Line when Contratc create
    public static  void GeneratingBRSFLine(ASI_TH_CRM_Contract__c contract){
        
        String BRSFActivityCodeId='';
        ASI_CRM_Module__c Module = new ASI_CRM_Module__c();
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> BRSFLineInsert= new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');    
        //********************Insert module*************************************************************************
        //Find Default value for BRSF
        List<ASI_CRM_Methodology__c> MethodologyList=[select Id,ASI_CRM_Default__c from ASI_CRM_Methodology__c where ASI_CRM_Type__c='BRSF' and ASI_CRM_Default__c = true and RecordType.DeveloperName ='ASI_CRM_CN_Methodology'];
        // Sub-Brand Grade Map: Sub-Brand Grade Id,Sub-Brand Grade Object
        if(MethodologyList.size()>0){
            List<ASI_CRM_Module__c> InsertModuleList = new List<ASI_CRM_Module__c>();
            
            if(contract.ASI_CRM_CN_Group_Contract__c!=null){ // this is Group Contract
                //Finding Group Contract
                ASI_TH_CRM_Contract__c NationalGroup =[select id,ASI_CRM_NationalGroup__c from  ASI_TH_CRM_Contract__c where  id=:contract.ASI_CRM_CN_Group_Contract__c];
                
                
                //ASI_CRM_Group_Contract__c
                if(NationalGroup.ASI_CRM_NationalGroup__c !=null){ // if KA Account is not null
                    ASI_CRM_KA_Account__c KAAccount = [select Id,ASI_CRM_VEC_Methodology__c,ASI_CRM_VEC_Unit__c,ASI_CRM_VEC_Volume_Base__c,ASI_CRM_BRSF_Methodology__c,ASI_CRM_BRSF_Unit__c,ASI_CRM_BRSF_Volume_Base__c,
                                                       ASI_CRM_PSF_Meth_Mod1__c,ASI_CRM_PSF_Meth_Mod2__c,ASI_CRM_PSF_Meth_Mod3__c,
                                                       ASI_CRM_PSF_Unit_Mod1__c,ASI_CRM_PSF_Unit_Mod2__c,ASI_CRM_PSF_Unit_Mod3__c,
                                                       ASI_CRM_PSF_Volume_Base_Mod1__c,ASI_CRM_PSF_Volume_Base_Mod2__c,ASI_CRM_PSF_Volume_Base_Mod3__c
                                                       from ASI_CRM_KA_Account__c where id=:NationalGroup.ASI_CRM_NationalGroup__c];
                    
                    if(KAAccount.ASI_CRM_BRSF_Methodology__c!=null){
                        Module= New ASI_CRM_Module__c(ASI_CRM_Methodology__c=KAAccount.ASI_CRM_BRSF_Methodology__c,
                                                      ASI_CRM_Group_Contract__c=true,
                                                      ASI_CRM_Line_Type__c='BRSF',ASI_CRM_Contract__c=contract.id);
                        InsertModuleList.add(Module);
                    }
                    
                    if(KAAccount.ASI_CRM_PSF_Meth_Mod1__c!=null && KAAccount.ASI_CRM_PSF_Unit_Mod1__c!=null  && KAAccount.ASI_CRM_PSF_Volume_Base_Mod1__c!=null ){
                        ASI_CRM_Module__c TempModule =New ASI_CRM_Module__c(ASI_CRM_Methodology__c=KAAccount.ASI_CRM_PSF_Meth_Mod1__c,
                                                                            ASI_CRM_Line_Type__c='PSF',
                                                                            ASI_CRM_Group_Contract__c=true,
                                                                            ASI_CRM_Unit__c = KAAccount.ASI_CRM_PSF_Unit_Mod1__c,
                                                                            ASI_CRM_Volume_Base__c=KAAccount.ASI_CRM_PSF_Volume_Base_Mod1__c,
                                                                            ASI_CRM_Contract__c=contract.id);
                        InsertModuleList.add(TempModule);
                    }
                    if(KAAccount.ASI_CRM_PSF_Meth_Mod2__c!=null && KAAccount.ASI_CRM_PSF_Unit_Mod2__c!=null  && KAAccount.ASI_CRM_PSF_Volume_Base_Mod2__c!=null ){
                        ASI_CRM_Module__c TempModule =New ASI_CRM_Module__c(ASI_CRM_Methodology__c=KAAccount.ASI_CRM_PSF_Meth_Mod2__c,
                                                                            ASI_CRM_Line_Type__c='PSF',
                                                                            ASI_CRM_Group_Contract__c=true,
                                                                            ASI_CRM_Unit__c = KAAccount.ASI_CRM_PSF_Unit_Mod2__c,
                                                                            ASI_CRM_Volume_Base__c=KAAccount.ASI_CRM_PSF_Volume_Base_Mod2__c,
                                                                            ASI_CRM_Contract__c=contract.id);
                        InsertModuleList.add(TempModule);
                    }
                    if(KAAccount.ASI_CRM_PSF_Meth_Mod3__c!=null && KAAccount.ASI_CRM_PSF_Unit_Mod3__c!=null  && KAAccount.ASI_CRM_PSF_Volume_Base_Mod3__c!=null ){
                        ASI_CRM_Module__c TempModule =New ASI_CRM_Module__c(ASI_CRM_Methodology__c=KAAccount.ASI_CRM_PSF_Meth_Mod3__c,
                                                                            ASI_CRM_Line_Type__c='PSF',
                                                                            ASI_CRM_Group_Contract__c=true,
                                                                            ASI_CRM_Unit__c = KAAccount.ASI_CRM_PSF_Unit_Mod3__c,
                                                                            ASI_CRM_Volume_Base__c=KAAccount.ASI_CRM_PSF_Volume_Base_Mod3__c,
                                                                            ASI_CRM_Contract__c=contract.id);
                        InsertModuleList.add(TempModule);
                    }
                    if(KAAccount.ASI_CRM_VEC_Methodology__c!=null && KAAccount.ASI_CRM_VEC_Unit__c!=null  && KAAccount.ASI_CRM_VEC_Volume_Base__c!=null ){
                        ASI_CRM_Module__c TempModule =New ASI_CRM_Module__c(ASI_CRM_Methodology__c=KAAccount.ASI_CRM_VEC_Methodology__c,
                                                                            ASI_CRM_Line_Type__c='Variable Event Cost',
                                                                            ASI_CRM_Group_Contract__c=true,
                                                                            ASI_CRM_Unit__c = KAAccount.ASI_CRM_VEC_Unit__c,
                                                                            ASI_CRM_Volume_Base__c=KAAccount.ASI_CRM_VEC_Volume_Base__c,
                                                                            ASI_CRM_Contract__c=contract.id);
                        InsertModuleList.add(TempModule);
                    }
                    
                    if(InsertModuleList.size()>0){
                        
                        insert InsertModuleList;
                    }
                }
                
                
            }else{
                Module= New ASI_CRM_Module__c(ASI_CRM_Methodology__c=MethodologyList[0].Id,ASI_CRM_Line_Type__c='BRSF',ASI_CRM_Contract__c=contract.id);
                InsertModuleList.add(Module);
                
                if(InsertModuleList.size()>0){
                    try{ 
                        insert InsertModuleList;
                    }catch(Exception e){
                        String msg = 'Save Error : ' +e.getMessage() + '</br>';
                        ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingBRSFLine class have Error:  '+msg,'GeneratingBRSFLine','Contract Id: '+contract );
                    }
                }
                
            }
            
        }
        
        
        //----- get Contract Cost Setting List and then get ASI_CRM_CN_Activity_Code__c
        for (ASI_CRM_Contract_Cost_Setting__c ContractCostSetting:[SELECT id, Name, ASI_CRM_CN_Activity_Code__c,ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Fixed_Cost_Contract__c, ASI_CRM_CN_BRSF_Activity_Code_Default__c,ASI_CRM_CN_Promotion_Type__c, ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Variable_Cost_Contract__c, ASI_CRM_CN_Other_Cost_Payment_Request__c FROM ASI_CRM_Contract_Cost_Setting__c where ASI_CRM_CN_Promotion_Type__c='Heavy Contract On']) {
            if(ContractCostSetting.ASI_CRM_CN_BRSF_Activity_Code_Default__c){
                //if(ContractCostSetting.name.contains('Bottle Return Service')){
                BRSFActivityCodeId=ContractCostSetting.ASI_CRM_CN_Activity_Code__c;
            }
        }
        ASI_CRM_AccountsAdditionalField__c Outlet = new ASI_CRM_AccountsAdditionalField__c();
        
        try{ 
            Outlet = [select Id,ASI_CRM_CN_CCity__c, ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c,ASI_CRM_CN_New_Image__c,ASI_CRM_CN_NewChannel__c,ASI_CRM_CN_Region__c,ASI_CRM_CN_Commercial_Team__c from ASI_CRM_AccountsAdditionalField__c 
                                                         where Id =:contract.ASI_CRM_CN_Outlet_WS__c  and ASI_CRM_CN_New_Image__c!=null and ASI_CRM_CN_NewChannel__c !=null];
        }catch(exception e){
            
            
        }
        //SubBrandGradeMap: Sub Brand name + Region + Commercial Team,  ASI_CRM_Sub_Brand_Grade__c
        Map<String, ASI_CRM_Sub_Brand_Grade__c> SubBrandGradeMap  = new Map<String,ASI_CRM_Sub_Brand_Grade__c>();
        //Central Region Prestige GeneratingSubBrandGrade(Outlet.ASI_CRM_CN_Region__c,Outlet.ASI_CRM_CN_Commercial_Team__c) 
        for(ASI_CRM_Sub_Brand_Grade__c sbg:[SELECT ID, Name,ASI_CRM_CN_City_Tier__c,ASI_CRM_External_Key__c,ASI_CRM_CN_Incentive__c,RecordType.DeveloperName,ASI_CRM_Incentive_for_PSF__c,
                                            ASI_CRM_Max_Incentive_for_PSF__c,ASI_CRM_Max_Incentive__c 
                                            FROM ASI_CRM_Sub_Brand_Grade__c WHERE 
                                            RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade' or 
                                            ( RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade_Heavy_Contract_ON' 
                                             and ASI_CRM_Commercial_Team__c = :Outlet.ASI_CRM_CN_Commercial_Team__c 
                                             and ASI_CRM_Region__c = :Outlet.ASI_CRM_CN_Region__c) ])
        {//system.DEBUG('Put Now Value '+sbg);
            if(sbg.ASI_CRM_CN_City_Tier__c!=null){
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c+CityTierGeneration(sbg.ASI_CRM_CN_City_Tier__c), sbg);
            }else{
                SubBrandGradeMap.put(sbg.ASI_CRM_External_Key__c, sbg);
            }
            
        }
        
        
        if(Outlet.ASI_CRM_CN_NewChannel__c!=null && Outlet.ASI_CRM_CN_New_Image__c  !=null){
            // Segmentation Criteria Map 
            Map<String,ASI_CRM_SegmentationCriteria__c> SCMap =new Map<String,ASI_CRM_SegmentationCriteria__c>(); 
            for(ASI_CRM_SegmentationCriteria__c SCLine: [select Id,ASI_CRM_Outlet_New_Image__c,ASI_CRM_Channel__c,(select id,ASI_CRM_Sub_Brand__c,ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,
                                                                                                                   ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name from Sub_Brand_Assignments__r )  
                                                         from ASI_CRM_SegmentationCriteria__c where RecordType.DeveloperName =:'ASI_CRM_CN_Segmentation_Criteria' 
                                                         and ASI_CRM_Channel__c = :Outlet.ASI_CRM_CN_NewChannel__c and ASI_CRM_Outlet_New_Image__c =: Outlet.ASI_CRM_CN_New_Image__c 
                                                         and ASI_CRM_Channel__c !=null and ASI_CRM_Outlet_New_Image__c !=null ])
            {
                for(ASI_CRM_Sub_Brand_Assignment__c  Assignments:SCLine.Sub_Brand_Assignments__r){
                    Decimal Incentive=0.0;
                    String ExternalKey=Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name; //ExternalKey=ASI_CRM_CN_Region__c,ASI_CRM_CN_Commercial_Team__c
                    ExternalKey+=Outlet.ASI_CRM_CN_Region__c;
                    ExternalKey+=Outlet.ASI_CRM_CN_Commercial_Team__c;
                    
                    String CityTierExternalKey = ExternalKey;
                    if(Outlet.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c !=null){
                        CityTierExternalKey+= CityTierGeneration(Outlet.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c) ;
                    }//system.debug('trigger ExternalKey : '+ExternalKey +'CityTierExternalKey :'+ CityTierExternalKey);
                    if(SubBrandGradeMap.containsKey(CityTierExternalKey)){
                        Incentive=SubBrandGradeMap.get(CityTierExternalKey).ASI_CRM_CN_Incentive__c;
                    }else if(SubBrandGradeMap.containsKey(ExternalKey)){
                        Incentive=SubBrandGradeMap.get(ExternalKey).ASI_CRM_CN_Incentive__c;
                    }else if(SubBrandGradeMap.containsKey(Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name)){
                        Incentive=SubBrandGradeMap.get(Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name).ASI_CRM_CN_Incentive__c;
                    }
                    
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine= new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=contract.Id,
                                                                                                              ASI_CRM_Module__c=Module.Id,
                                                                                                              ASI_CRM_CN_Activity_Code__c=BRSFActivityCodeId,
                                                                                                              ASI_CRM_CN_Est_BRSF_Per_Bottle__c=Incentive,
                                                                                                              ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=Incentive,
                                                                                                              ASI_CRM_Sub_Brand_Grade__c=Assignments.ASI_CRM_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,
                                                                                                              ASI_CRM_CN_Sub_Brand__c =Assignments.ASI_CRM_Sub_Brand__c,
                                                                                                              ASI_CRM_Type__c='BRSF',recordTypeId=BRSFLineRtId);
                    BRSFLineInsert.add(BRSFLine);
                }
            }
            
        }
        
        if(BRSFLineInsert !=null && BRSFLineInsert.size()>0){
            insert BRSFLineInsert;
        }
        
        
    }
    
    
    public static String CityTierGeneration(String InputCityTier){
        if(InputCityTier=='5' || InputCityTier=='6'){
            return 'Other';
        }else{
            return InputCityTier;
        }
    }
    
    
    
    
    
    //Retrieve  Check Point Criteria Map   : Channel + Division > Region + Channel > Division > Region > Channel         //.size() 
    public static Map<String,ASI_CRM_SegmentationCriteria__c> RetrieveCheckPointCriteriaMap(ASI_TH_CRM_Contract__c contract, String RecordTypeName)
    {
        String SoqlStatement ='select Id,ASI_CRM_Floating_Interval_Percent_Up__c,ASI_CRM_Floating_Interval_Percent_Down__c , ASI_CRM_Floating_Interval_Down__c,ASI_CRM_Floating_Interval_Up__c,ASI_CRM_Max_Value__c,ASI_CRM_Min_Value__c, ASI_CRM_RVP_Special_Approval__c,ASI_CRM_Alignment_Value__c,ASI_CRM_Operation__c,AS_CRM_Predefined_Theoretical_Value__c,ASI_CRM_Alignment_Percentage__c,ASI_CRM_1st_Dimension__c,ASI_CRM_2nd_Dimension__c,ASI_CRM_Region__c,ASI_CRM_Channel__c,ASI_CRM_Division__c,ASI_CRM_Financial_Indicator__c,ASI_CRM_Region__r.name,ASI_CRM_Chinese_Interpretation__c,ASI_CRM_English_Interpretation__c '+ ' from ASI_CRM_SegmentationCriteria__c where RecordType.DeveloperName= \''+RecordTypeName+'\'  ';
        //Financial Indicator, Segmentation Criteria
        Map<String,ASI_CRM_SegmentationCriteria__c> SegmentationCriteriaMap = new Map<String,ASI_CRM_SegmentationCriteria__c>();
        
        
        // SQL1 : Channel + Division ,  Division = null
        if( contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Division_Name__c!=null && contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c !=null ){
            String AddOnStatement=' and ASI_CRM_Division__r.name = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Division_Name__c
                +'\'  and ASI_CRM_Channel__c = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c+'\' and ASI_CRM_Division__r.name  =null';
            SegmentationCriteriaMap=SQLSegmentationCriteria(SegmentationCriteriaMap,SoqlStatement+ AddOnStatement );
            system.debug('Enter SQL 1'+SoqlStatement+ AddOnStatement);
        }
        
        //SQL2 : Region + Channel 
        if(SegmentationCriteriaMap.size()==0 && contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c!=null && contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c !=null ){
            String AddOnStatement=' and ASI_CRM_Region__r.name = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c
                +'\'  and ASI_CRM_Channel__c = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c+'\' and  ASI_CRM_Division__r.name = Null ';
            SegmentationCriteriaMap=SQLSegmentationCriteria(SegmentationCriteriaMap,SoqlStatement+ AddOnStatement );
            system.debug('Enter SQL 2'+SoqlStatement+ AddOnStatement);
        }
        
        //Division
        if( SegmentationCriteriaMap.size()==0 && contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Division_Name__c!=null){
            String AddOnStatement=' and ASI_CRM_Division__r.name = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Division_Name__c+
                '\' and  ASI_CRM_Division__r.name = Null and ASI_CRM_Channel__c=null';
            SegmentationCriteriaMap=SQLSegmentationCriteria(SegmentationCriteriaMap,SoqlStatement+ AddOnStatement );
            system.debug('Enter SQL 3'+SoqlStatement+ AddOnStatement);
        }
        
        
        //Region
        if(SegmentationCriteriaMap.size()==0 && contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c!=null ){
            String AddOnStatement=' and ASI_CRM_Region__r.name = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c
                +'\'  and  ASI_CRM_Division__r.name = Null and ASI_CRM_Channel__c=null ';
            SegmentationCriteriaMap=SQLSegmentationCriteria(SegmentationCriteriaMap,SoqlStatement+ AddOnStatement );
            system.debug('Enter SQL 4'+SoqlStatement+ AddOnStatement);
            
        }        
        
        //Channel
        if(SegmentationCriteriaMap.size()==0 && contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c !=null ){
            String AddOnStatement= ' and ASI_CRM_Region__r.name = Null and ASI_CRM_Division__r.name = Null  and ASI_CRM_Channel__c = \''+contract.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c+'\' ';
            SegmentationCriteriaMap=SQLSegmentationCriteria(SegmentationCriteriaMap,SoqlStatement+ AddOnStatement );
            system.debug('Enter SQL 5'+SoqlStatement+ AddOnStatement);
        }        
        
     
        
        return SegmentationCriteriaMap;
    }
    
    
    //SQL Segmentation Criteria Object DaTa
    public static Map<String,ASI_CRM_SegmentationCriteria__c> SQLSegmentationCriteria (Map<String,ASI_CRM_SegmentationCriteria__c> SCMap, String Statement){
        for(ASI_CRM_SegmentationCriteria__c SegmentationCriteria : Database.query(Statement)){
            /*
             * if(!SCMap.containsKey(SegmentationCriteria.ASI_CRM_Financial_Indicator__c)){
                SCMap.put(SegmentationCriteria.ASI_CRM_Financial_Indicator__c, SegmentationCriteria);
            }
            */
            SCMap.put(SegmentationCriteria.Id, SegmentationCriteria);
            
        }
        return SCMap;
    }
    
    
    
    
    
    
    
    
    
    
    
    //return result Object 
    public Class ReturnResult{ 
        public string Msg {set;get;} {Msg= '';}
        public Boolean Process {set;get;} {Process=true;}
        public ReturnResult (){}
    }
    
    
    //checking the volume if it is ready in SFDC
    public static ReturnResult  CheckingVolumeIsReady(Date InputStartDate, Date InputEndDay){
        ReturnResult tempReturnResult = new ReturnResult ();
        date cutOffDate = GenerateCutOffDate();
        date ChangedStartDate;
        date ChangedEndDate;
        
        if(InputStartDate != null){
            ChangedStartDate = InputStartDate.toStartOfMonth().addMonths(1).addDays(-1); 
        }
        if(InputEndDay != null){
            ChangedEndDate = InputEndDay.toStartOfMonth().addMonths(1).addDays(-1); 
        }
        
        if(cutOffDate < ChangedStartDate || cutOffDate < ChangedEndDate){
            tempReturnResult.Process= false;
            String endString = '';
            endString = Label.ASI_CRM_CN_Volume_Not_Ready;
            
            date enddate = cutOffDate.addMonths(1);
            while(enddate <= ChangedEndDate){
                endString += (enddate.year() + '-' + enddate.month() + ', ');
                enddate = enddate.addMonths(1);
            }
            
            if(enddate>ChangedEndDate){
                endString ='销量尚未更新至SFDC.The volume is not ready yet in SFDC.';
            }else{
                endString += endString.substring(0, endString.length() - 2 );
            }
            //endString += endString.substring(0, endString.length() - 2 );
            tempReturnResult.Msg= endString;
        }
        
        
        return tempReturnResult;
    }
    
    
    
    
    //Change the date to String with formatting 
    // can be 'yyyy-MM-dd'
    public static String DateToString (Date InputDate, String formatingString){ //'yyyy-MM-dd'
        Integer d = InputDate.day(); 
        Integer mo = InputDate.month(); 
        Integer yr = InputDate.year(); 
        DateTime DT = DateTime.newInstance(yr, mo, d); 
        return  DT.format(formatingString);
    }
    
    
    
    public static Boolean checkUserID(){
        Boolean AdorAbove =false;
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId=:UserInfo.getUserId()];
        if(gms.size()>0){
            AdorAbove = true;
        }
        return AdorAbove;
    }
    
    //Convert Date to String
    public static string ConvertDate(date strDate){
        string datestring;
        if (strDate != null){
            datestring = string.valueof(strDate.DAY()) + '/' + string.valueof(strDate.MONTH()) + '/' + string.valueof(strDate.YEAR());
        }else{
            datestring = '';
        }
        return datestring;
    }
    
    public static date VolumeCutOffDate(integer strDay, date defaultDate, date startdate){
        Date returnDate;
        Integer strDate = Date.Today().Day();
        Integer strMonth;
        Integer strEndDay;
        
        if (defaultDate != null && startdate != null && strDay != null){
            if (strDay != 0){
                if (strDate >= strDay){
                    strMonth = Date.Today().Month() - 1;
                }
                if (strDate < strDay){
                    strMonth = Date.Today().Month() - 2;
                }
                strEndDay = Date.daysInMonth(Date.Today().Year(), strMonth);
                returnDate = Date.newinstance(Date.Today().Year(),strMonth,strEndDay);
                if (returnDate < startdate){
                    return null;
                }
                if (returnDate >= defaultDate){
                    returnDate = defaultDate;
                }
            }else{
                returnDate = defaultDate;
            }
        }
        return returnDate;
    }
    
    
    
    //Sort Descending for Map Name
    public static string NameSorting(decimal strSeq){
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
        returnString = string.valueof(99999 - integer.valueof(returnString));
        
        return returnString;
    }
    
    //Sort ascending  for Map Name
    public static string NameSortingASC(decimal strSeq){
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
        return returnString; 
    }
    
    
    
    
    public static String KeyNameSortingASC(decimal strSeq){
        if(strSeq==0){
            strSeq=9;
        }
        string returnString;
        if (strSeq != null){
            if (strSeq < 10){
                returnString = string.valueof(strSeq);
            }else if (strSeq > 9 && strSeq < 100){
                returnString =  string.valueof(strSeq);
            }else if (strSeq > 99 && strSeq < 1000){
                returnString =  string.valueof(strSeq);
            }else if (strSeq > 999 && strSeq < 10000){
                returnString = string.valueof(strSeq);
            }
        }else{
            returnString = '0';
        }
        return returnString; 
    }
    
    
    //Convert two dates into Period (No of Months)
    public static integer ConvertPeriod(date startDate, date endDate){
        integer strPeriod;
        if (startDate != null && endDate != null){
            strPeriod = ((endDate.YEAR() - startDate.YEAR() - 1) *12) + (12 - startDate.MONTH() +1) + endDate.MONTH();
        }else{
            strPeriod = 0;
        }
        
        return strPeriod;
    }
    
    
    // Getting Historical Module List 
    public static list<ASI_CRM_Module__c> HistoricalModuleQuerying(Set<Id> ParentModuleSet,String CurrentPaymentId){
        list<ASI_CRM_Module__c> HistoricalModuleList = new list<ASI_CRM_Module__c>();
        
        HistoricalModuleList = [select Id,ASI_CRM_Actual_Payment__c,ASI_CRM_End_Date__c,ASI_CRM_Parent_Module__c,ASI_CRM_Line_Type__c,
                                ASI_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c, ASI_CRM_Payment_Request__r.ASI_CRM_CN_PO_Start_Date__c,
                                ASI_CRM_Payment_Request__r.Name,ASI_CRM_Payment_Request__r.ASI_TH_CRM_Status__c,ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_PSF_Amount__c,
                                ASI_CRM_Payment_Request__r.ASI_CRM_CN_Adjustment__c,ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_BRSF_Amount__c,ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_VEC_Amount__c
                                from ASI_CRM_Module__c 
                                where ASI_CRM_Parent_Module__c in: ParentModuleSet 
                                and ASI_CRM_Payment_Request__c!=null 
                                and ASI_CRM_Payment_Request__r.ASI_TH_CRM_Status__c!='Draft'
                                and ASI_CRM_Payment_Request__r.ASI_TH_CRM_Status__c!='Submitted'
                                and ASI_CRM_Payment_Request__c !=:CurrentPaymentId];
        
        for(ASI_CRM_Module__c Module:HistoricalModuleList){
            if(Module.ASI_CRM_Payment_Request__r.Name.substring(Module.ASI_CRM_Payment_Request__r.Name.length()-3, Module.ASI_CRM_Payment_Request__r.Name.length()) == '000'){///000-Payment
                
                if(Module.ASI_CRM_Line_Type__c=='BRSF'){
                    if(Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_BRSF_Amount__c !=null){
                        if(Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Adjustment__c!=null){
                            Module.ASI_CRM_Actual_Payment__c =Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_BRSF_Amount__c * (Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Adjustment__c/100);
                        }else{
                            Module.ASI_CRM_Actual_Payment__c =Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_BRSF_Amount__c;
                        }
                        
                    }
                }
                if(Module.ASI_CRM_Line_Type__c=='PSF'){
                    Module.ASI_CRM_Actual_Payment__c = Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_PSF_Amount__c;
                }
                if(Module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                    Module.ASI_CRM_Actual_Payment__c =Module.ASI_CRM_Payment_Request__r.ASI_CRM_CN_Total_VEC_Amount__c;
                }
            }
            Module.ASI_CRM_Actual_Payment__c= Module.ASI_CRM_Actual_Payment__c!=null?Module.ASI_CRM_Actual_Payment__c.SetSCale(2):0;
        }
        
        
        // 
        return HistoricalModuleList;
    }
    
    
    
    // Getting Historical Actual Payment in ParentModule
    public static Map<String,Decimal> GetHistoricalModuleAmount(Set<Id> ParentModuleSet,String ContractId, list<ASI_CRM_Module__c> HistoricalPaidModulelist){
        Map<String,Decimal> HistoricalModuleMap = new Map<String,Decimal>();
        
        String BRSFModuleId='';
        String PSFModuleId='';
        String VECModuleId='';
        
        //list<ASI_CRM_Module__c> HistoricalPaidModulelist = HistoricalModuleQuerying(ParentModuleSet , CurrentPaymentId);
        for(ASI_CRM_Module__c ModuleItem:HistoricalPaidModulelist){
            if(HistoricalModuleMap.containsKey(ModuleItem.ASI_CRM_Parent_Module__c)){
                Decimal TempAmount= HistoricalModuleMap.get(ModuleItem.ASI_CRM_Parent_Module__c) !=null? HistoricalModuleMap.get(ModuleItem.ASI_CRM_Parent_Module__c) : 0;
                TempAmount =TempAmount+ModuleItem.ASI_CRM_Actual_Payment__c;
                HistoricalModuleMap.remove(ModuleItem.ASI_CRM_Parent_Module__c);
                HistoricalModuleMap.put(ModuleItem.ASI_CRM_Parent_Module__c, TempAmount);
            }else{
                HistoricalModuleMap.put(ModuleItem.ASI_CRM_Parent_Module__c,ModuleItem.ASI_CRM_Actual_Payment__c);
            }
            
            system.debug(ModuleItem.ASI_CRM_Line_Type__c+'Actual Payment Amount: '+ModuleItem.ASI_CRM_Actual_Payment__c);
            if(ModuleItem.ASI_CRM_Line_Type__c=='BRSF' && BRSFModuleId=='' ){
                BRSFModuleId=ModuleItem.ASI_CRM_Parent_Module__c;
            }
            if(ModuleItem.ASI_CRM_Line_Type__c=='PSF' && PSFModuleId==''){
                PSFModuleId=ModuleItem.ASI_CRM_Parent_Module__c;
            }
            if(ModuleItem.ASI_CRM_Line_Type__c=='Variable Event Cost' && VECModuleId ==''){
                VECModuleId=ModuleItem.ASI_CRM_Parent_Module__c;
            }
        }
        
        
        /*
        //For 000-payment
        for(ASI_TH_CRM_PaymentRequestLineItem__c PaymentLine: [Select id, name,ASI_TH_CRM_Payment_Request__r.Name,ASI_CRM_CN_Total_Payable__c,
                                                               ASI_TH_CRM_Payment_Request__c, RecordType.DeveloperName, recordtypeid, ASI_TH_CRM_Amount__c,ASI_CRM_CN_AC_Code__r.ASI_MFM_A_C_Description__c, ASI_CRM_CN_Expense_Type__c, ASI_CRM_CN_AC_Code__c  
                                                               from ASI_TH_CRM_PaymentRequestLineItem__c
                                                               where ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c = :ContractId and ASI_TH_CRM_Payment_Request__r.Name like '%-000%'
                                                               and (ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Approved' or ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Submitted' or
                                                                    ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Paid'  )  ])
        {
            if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_BRSF'){ // ASI_CRM_CN_Total_Payable__c
                if(HistoricalModuleMap.containsKey(BRSFModuleId)){
                    Decimal TempAmount= HistoricalModuleMap.get(BRSFModuleId) !=null? HistoricalModuleMap.get(BRSFModuleId) : 0;
                    TempAmount =TempAmount+PaymentLine.ASI_CRM_CN_Total_Payable__c;
                    HistoricalModuleMap.remove(BRSFModuleId);
                    HistoricalModuleMap.put(BRSFModuleId, TempAmount);
                }
            }else if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_PSF'){ //ASI_TH_CRM_Amount__c
                if(HistoricalModuleMap.containsKey(PSFModuleId)){
                    Decimal TempAmount= HistoricalModuleMap.get(PSFModuleId) !=null? HistoricalModuleMap.get(PSFModuleId) : 0;
                    TempAmount =TempAmount+PaymentLine.ASI_TH_CRM_Amount__c;
                    HistoricalModuleMap.remove(PSFModuleId);
                    HistoricalModuleMap.put(PSFModuleId, TempAmount);
                }
            }else if(PaymentLine.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_VEC'){ //
                if(HistoricalModuleMap.containsKey(VECModuleId)){
                    Decimal TempAmount= HistoricalModuleMap.get(VECModuleId) !=null? HistoricalModuleMap.get(VECModuleId) : 0;
                    TempAmount =TempAmount+PaymentLine.ASI_TH_CRM_Amount__c;
                    HistoricalModuleMap.remove(VECModuleId);
                    HistoricalModuleMap.put(VECModuleId, TempAmount);
                }
            }
        }
            */  
        return HistoricalModuleMap;
    }
    
    
    
    
    // Calculate Total Contract Amount
    public static Decimal CalTotalContractAmount(ASI_TH_CRM_Contract__c Contract){
        Decimal TotalAmount=0.0;
        if(Contract.ASI_CRM_CN_PO_Version__c=='0.0'){
            TotalAmount += Contract.ASI_CRM_Est_Total_Dummy__c!=null? Contract.ASI_CRM_Est_Total_Dummy__c: 0;
            TotalAmount += Contract.ASI_CRM_CN_Contract_Fixed_Cost_Total__c!=null? Contract.ASI_CRM_CN_Contract_Fixed_Cost_Total__c: 0;
        }else{
            TotalAmount += Contract.ASI_CRM_CN_Total_Contract_Amount__c!=null?Contract.ASI_CRM_CN_Total_Contract_Amount__c:0;
        }
        
        return TotalAmount;
    }
    
    
    
    
    
    
    //*********************************************************
    //@description:Generate Sub-Brand Grade for incentive
    //@param: Commercial Team &  Region Name
    //@return: List of Sub Brand Grade
    // *********************************************************
    public static List<ASI_CRM_Sub_Brand_Grade__c> GeneratingSubBrandGrade(String CommercialTeam,String RegionName){
        List<ASI_CRM_Sub_Brand_Grade__c> TempList = new List<ASI_CRM_Sub_Brand_Grade__c>();
        
        try{
            
            TempList = [SELECT ID, Name,ASI_CRM_Chinese_Name__c,ASI_CRM_CN_City_Tier__c,ASI_CRM_External_Key__c,ASI_CRM_CN_Incentive__c,RecordType.DeveloperName,ASI_CRM_Incentive_for_PSF__c,
                        ASI_CRM_Max_Incentive_for_PSF__c,ASI_CRM_Max_Incentive__c 
                        FROM ASI_CRM_Sub_Brand_Grade__c WHERE 
                        RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade' or 
                        ( RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade_Heavy_Contract_ON' 
                         and ASI_CRM_Commercial_Team__c = :CommercialTeam 
                         and ASI_CRM_Region__c = :RegionName) ];
            system.debug(RegionName+CommercialTeam+'TempList:  '+TempList.size());
        }catch(exception e){
            TempList = [SELECT ID, Name,ASI_CRM_Chinese_Name__c,ASI_CRM_CN_City_Tier__c,ASI_CRM_External_Key__c,ASI_CRM_CN_Incentive__c,RecordType.DeveloperName,ASI_CRM_Incentive_for_PSF__c,ASI_CRM_Max_Incentive_for_PSF__c,ASI_CRM_Max_Incentive__c 
                        FROM ASI_CRM_Sub_Brand_Grade__c WHERE 
                        RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade' or  RecordType.DeveloperName ='ASI_CRM_CN_Sub_brand_Grade_Heavy_Contract_ON'  ];
            
        }
        /*
        if(CommercialTeam!=null && RegionName!=null){
          
        }else{
         }
        
        */

        return TempList;                                
    }
    
    
    
    
    //Base on current Contract Promotion Types generate related old Promotion Types
    public static Set<String> GeneratingPromotionTypes(String CurrentPromotionType){
        Set<String> oldPromotionTypes = new Set<String>();
        
        for(ASI_CRM_Special_Promotion_Type_Mapping__c obj:[SELECT Id,ASI_CRM_Mapping_of_New_Promotion_Type__c , ASI_CRM_Mapping_of_Old_Promotion_Type__c ,
                                                           ASI_CRM_Mapping_of_New_Promotion_Type__r.ASI_CRM_Promotion_Type__c , ASI_CRM_Mapping_of_Old_Promotion_Type__r.ASI_CRM_Promotion_Type__c 
                                                           FROM ASI_CRM_Special_Promotion_Type_Mapping__c WHERE RecordType.DeveloperName = 'ASI_CRM_CN_Special_Promotion_Type_Mapping' AND 
                                                           ASI_CRM_Mapping_of_New_Promotion_Type__r.ASI_CRM_Promotion_Type__c = : CurrentPromotionType ])
        {
            oldPromotionTypes.add(obj.ASI_CRM_Mapping_of_Old_Promotion_Type__r.ASI_CRM_Promotion_Type__c);
        }
        return oldPromotionTypes;
    }
    
    
    
    
    
    
    //Generate Contract Detail Line List by Contract Line Id
    //RecordTypeName: ASI_CRM_CRM_CN_Contract_Heavy_BRSF 
    public static  List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> GenerateContractList( String ContractId,String RecordTypeName,String AddFilter){
        
        Map<String, Schema.SObjectField> ContractLine_FieldMap       = Schema.SObjectType.ASI_CRM_CN_Contract_BRSF_Line_Item__c.fields.getMap();
        String query = 'SELECT ' + genQueryField(ContractLine_FieldMap) + ',ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, RecordType.DeveloperName  from ASI_CRM_CN_Contract_BRSF_Line_Item__c where ASI_CRM_CN_Contract__c =\''+ ContractId+'\' AND RecordType.DeveloperName=\''+RecordTypeName+'\'' + AddFilter ;
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLineList = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
        ContractLineList=Database.query(query);
        return ContractLineList;
    }
    
    private static String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
        String queryField = '';
        for(String fields : fieldMap.keySet()) {
            queryField += fields + ',';
        }
        return queryField.subString(0, queryField.length() - 1);
    }
    
    
    
    
    //Genrate Newest Contract by KA Account 
    public static ASI_TH_CRM_Contract__c KAAccountQueryNewestContract(String KAAccountId){
        //ASI_CRM_KA_Account__c KAAccount
        ASI_TH_CRM_Contract__c contract = new ASI_TH_CRM_Contract__c();
        
        List<ASI_TH_CRM_Contract__c> TempList=[Select id,Name, CreatedDate,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_Martell_BC_Rate__c from ASI_TH_CRM_Contract__c 
                                               where (RecordType.DeveloperName ='ASI_CRM_CN_Group_Contract'  or RecordType.DeveloperName like 'ASI_CRM_CN_Local_Group_Contract%' ) and
                                               ASI_CRM_NationalGroup__c =:KAAccountId and ASI_CRM_Active_Dummy_PO__c=true 
                                               order by CreatedDate DESC];
        if(TempList.size()>0){
            contract=TempList[0];
        }
        //system.assertEquals(TempList, Null);

        return contract;
    }
    
    
    
    
    //Generate National contract select option
    public Static  List<SelectOption>  GenerateNationalContractOption(String KAAccountId){
        List<SelectOption> NationalContractOption = new List<SelectOption>();  //NationalContractOption.add(new SelectOption('', '--None--'));
        
        for(ASI_TH_CRM_Contract__c NationalContract: [Select Id,Name, CreatedDate from ASI_TH_CRM_Contract__c where RecordType.DeveloperName ='ASI_CRM_CN_Group_Contract' and ASI_CRM_NationalGroup__c =:KAAccountId and ASI_CRM_Active_Dummy_PO__c=true order by CreatedDate DESC]){
            NationalContractOption.add(new SelectOption(NationalContract.Id, NationalContract.Name));  
        }
        Return NationalContractOption;
    }
    
    
    //In V0.0 Contract, if user change PO start Date or end date , system will auto-modi the Contract Line
    Public Static void ContractChangingPeriod(ASI_TH_CRM_Contract__c Contract,Integer OriginalMonth,Date OriginalStartDate,Date OriginalEndDate){
        if( OriginalStartDate!=Contract.ASI_CRM_CN_PO_Start_Date__c || OriginalEndDate != Contract.ASI_CRM_CN_PO_End_Date__c){
            Contract.ASI_CRM_Expected_V0_BRSF_Estimated_Total__c=0;
            
            Contract.ASI_CRM_Expected_V0_PSF_Estimated_Total__c=0;
            Contract.ASI_CRM_CN_Expected_PSF_Est_Total__c=0;
            Contract.ASI_CRM_V0_PSF_Contract_Total__c=0;
            
            Contract.ASI_CRM_Expected_V0_0_VEC_Est_Total__c=0;
            
            ASI_TH_CRM_Contract__c SelectContract= [select Id,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,
                                                    ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,
                                                    ASI_CRM_CN_Expected_BRSF_Est_Total__c,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grand_Estimate_Total__c
                                                    from ASI_TH_CRM_Contract__c WHERE id =:Contract.Id];
            
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractDetailList =[SELECT Id,ASI_CRM_Contract_Monthly_Volume_CR12__c,ASI_CRM_Est_Monthly_Volume_CR12__c,ASI_CRM_Contract_Total_QTY_CR12_Eqv__c,ASI_CRM_Est_Total_QTY_CR12_Eqv__c,ASI_CRM_Contract_Total_QTY_std_Btl__c,ASI_CRM_Module__c, ASI_CRM_Est_Total_QTY_std_Btl__c,ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Volume_Base__c , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                             WHERE ASI_CRM_CN_Contract__c = :Contract.Id] ;
            //Looping all contract Lines
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:ContractDetailList){
                
                if((ContractLine.ASI_CRM_Type__c=='BRSF') || (ContractLine.ASI_CRM_Type__c=='PSF' && ContractLine.ASI_CRM_Volume_Base__c=='By Sub-Brand' ) ||
                   (ContractLine.ASI_CRM_Type__c=='Variable Event Cost' && ContractLine.ASI_CRM_Volume_Base__c=='By Sub-Brand') ){
                       if(ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c !=null && ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c !=null){
                           ContractLine.ASI_CRM_CN_Est_Total_Dummy__c= ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c * ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c; 
                       }
                       if( ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c  !=null && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c !=null ){
                           ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c= ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                           
                       }
                       
                       if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                           Contract.ASI_CRM_Expected_V0_BRSF_Estimated_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                       }
                       
                       
                       
                   }else{
                       
                       ContractLine.ASI_CRM_Contract_Total_QTY_std_Btl__c = (ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                       ContractLine.ASI_CRM_Est_Total_QTY_std_Btl__c = (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                       ContractLine.ASI_CRM_Contract_Total_QTY_CR12_Eqv__c = (ContractLine.ASI_CRM_Contract_Monthly_Volume_CR12__c==null) ? 0:ContractLine.ASI_CRM_Contract_Monthly_Volume_CR12__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                       ContractLine.ASI_CRM_Est_Total_QTY_CR12_Eqv__c = (ContractLine.ASI_CRM_Est_Monthly_Volume_CR12__c==null) ? 0:ContractLine.ASI_CRM_Est_Monthly_Volume_CR12__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                   }
                if(ContractLine.ASI_CRM_Type__c=='PSF'){
                    Contract.ASI_CRM_Expected_V0_PSF_Estimated_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    Contract.ASI_CRM_CN_Expected_PSF_Est_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    Contract.ASI_CRM_V0_PSF_Contract_Total__c += ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                }
                
                if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                    Contract.ASI_CRM_Expected_V0_0_VEC_Est_Total__c +=  ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null? ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
            }
            
            if(ContractDetailList.size()>0){
                update ContractDetailList;
            }
            
            update Contract ;
        }
    }
    
    
    
    
    
    
    
    
    
    
    // format number with comma in apex
    public Static string FormatNumber(Decimal InputNumber ){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
            String str = String.format(InputNumber.format(), args);
        return str;
        
    }
    
    
    //Payment check Point Page to calculate all Total Paid Amount
    Public Static Decimal RetrieveTotalPaidAmount(ASI_TH_CRM_PaymentRequest__c CurrentPayment){
        decimal allPaymentTotal = 0;
        //Query all payment request with vFinal contract
        list<ASI_TH_CRM_PaymentRequest__c> AllPaymentRequest = new list<ASI_TH_CRM_PaymentRequest__c>();
        try{
            AllPaymentRequest = [SELECT Id,Name,ASI_CRM_Total_Variable_Amount__c,ASI_CRM_CN_Promotion_Type__c,ASI_CRM_CN_Total_BRSF_Amount__c, ASI_CRM_CN_Total_PSF_Amount__c, ASI_CRM_CN_Total_VEC_Amount__c,ASI_CRM_CN_Total_Other_Amount__c, ASI_TH_CRM_Contract__c, ASI_CRM_CN_Total_Payment__c
                                 FROM ASI_TH_CRM_PaymentRequest__c
                                 WHERE ASI_TH_CRM_Contract__c =:CurrentPayment.ASI_TH_CRM_Contract__c
                                 AND (id = :CurrentPayment.id OR ASI_TH_CRM_Status__c = 'Approved' OR ASI_TH_CRM_Status__c = 'Submitted'  OR ASI_TH_CRM_Status__c = 'Paid')];
        }catch(exception e){
            String msg = 'Save Error : ' +e.getMessage() + '</br>';
            ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyPaymentCheckCtrl. RetrieveTotalPaidAmount  class have Error  '+msg,'ASI_CRM_CN_HeavyContractUtilitiesClass',' function failed! with Payment Id: '+CurrentPayment.id );
        }
        
        //Sum up previous payments amounts
        if (AllPaymentRequest.size() > 0){
            for (ASI_TH_CRM_PaymentRequest__c allPR_temp : AllPaymentRequest){
                if(allPR_temp.ASI_CRM_CN_Promotion_Type__c=='Heavy Contract On'){
                    allPaymentTotal+=allPR_temp.ASI_CRM_Total_Variable_Amount__c!=NULL?allPR_temp.ASI_CRM_Total_Variable_Amount__c:0;
                }else{
                    allPaymentTotal+=allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c:0;
                    allPaymentTotal+=allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c:0;
                    allPaymentTotal+=allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c:0;
                }
                
                //if (allPR_temp.ASI_CRM_CN_Total_Payment__c != null){
                    //allPaymentTotal += allPR_temp.ASI_CRM_CN_Total_Payment__c;
                      //allPaymentTotal+=allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c:0;
                        //allPaymentTotal+=allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c:0;
                        //allPaymentTotal+=allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c:0;
                    
                //}
            }
        }
        
        return allPaymentTotal;
    }
    
    
    
    //check Point compare : SecondDimension_1 : Min SecondDimension_2 : Max
    public static Boolean NumberOperationChecking (String Operation, Decimal FirstDimension,Decimal SecondDimension_1,Decimal SecondDimension_2){
        Boolean ReturnFlag = true;
        if(Operation=='Equal to'){
            if(math.abs(FirstDimension-SecondDimension_1)>0.1){
                ReturnFlag=false;
            }
        }else if(Operation=='Greater than'){
            if(FirstDimension<SecondDimension_1 ){
                ReturnFlag=false;
            }
        }else if(Operation=='Greater than or Equal to'){
            if(FirstDimension<SecondDimension_1 ){
                ReturnFlag=false;
            }
        }else if(Operation=='Less than'){
            if(FirstDimension>=SecondDimension_1 ){
                ReturnFlag=false;
            }
        }else if(Operation=='Less than or Equal to'){
            if(FirstDimension>SecondDimension_1 ){
                ReturnFlag=false;
            }
        }else if(Operation=='Within'){
            system.debug('FirstDimension : '+FirstDimension);
            system.debug('SecondDimension_1 : '+SecondDimension_1);
            system.debug('SecondDimension_2 : '+SecondDimension_2);
            if(FirstDimension<SecondDimension_1 || FirstDimension>SecondDimension_2){
                 ReturnFlag=false;
            }
        }
        
        return ReturnFlag;
    }
    
    //check Point Date compare
    public static Boolean DateOperationChecking  (String Operation, Date FirstDimension,Date SecondDimension){
        Boolean ReturnFlag = true;
        
        if(Operation=='Equal to'){
            if(FirstDimension!=SecondDimension){
                ReturnFlag=false;
            }
        }else if(Operation=='Greater than'){
            if(FirstDimension<SecondDimension ){
                ReturnFlag=false;
            }
        }else if(Operation=='Greater than or Equal to'){
            if(FirstDimension<=SecondDimension ){
                ReturnFlag=false;
            }
        }else if(Operation=='Less than'){
            if(FirstDimension>SecondDimension ){
                ReturnFlag=false;
            }
        }
        
        return ReturnFlag;
    }
    
    
    Public Static Boolean ChangeStringToBoolean(String InputString){
        Boolean ReturnFlag=false;
        if(InputString=='true' || InputString=='True' || InputString=='TRUE' ){
            ReturnFlag=true;
        }
        if(InputString=='false' || InputString=='False' || InputString=='FALSE'){
            ReturnFlag=false;
        }
        
        
        return ReturnFlag;
    }
    
    
    
    
    
    
    
    public static ASI_TH_CRM_Contract__c ArchivePO(ASI_TH_CRM_Contract__c InputContract){
        //---- original child objects ----
        
        ASI_TH_CRM_Contract__c Contract = [SELECT Id,Name,ASI_CRM_Reject_Return_Comments__c,ASI_CRM_CN_Return_Comments__c,ASI_CRM_CN_Last_Approved_By__c,ASI_CRM_CN_Last_Approved_Date__c,
                                           ASI_CRM_PSF_Estimate_Adjustment_Amount__c,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_CN_V0_0_PO_version__c,
                                           ASI_CRM_V0_PSF_Contract_Total__c,ASI_CRM_Expected_V0_PSF_Estimated_Total__c,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_Auto_PO_Modification_Time__c,ASI_CRM_Auto_PO_Modification__c,
                                           ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_Previous_Version_PSF_Est_Total__c,ASI_CRM_Converted_From__c,
                                           ASI_CRM_CN_Last_Recall_By__c,ASI_CRM_CN_Last_Recall_Date__c,ASI_CRM_CN_Last_Rejected_By__c,ASI_CRM_CN_Last_Submitted_By__c,
                                           ASI_CRM_CN_Group_Contract__c, ASI_CRM_Investment_Type__c,ASI_CRM_CN_Total_Contract_Amount__c , ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                           ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                           ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c , ASI_CRM_Expected_V0_0_VEC_Est_Total__c,ASI_CRM_Expected_V0_BRSF_Estimated_Total__c,  ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                           recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                           ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                           ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c,
                                           (Select Id, Name, ASI_CRM_CN_Last_Payment__c, ASI_TH_CRM_Contract__c,ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_End_Date__c,ASI_TH_CRM_Status__c,ASI_CRM_CN_Channel__c, ASI_CRM_CN_Total_Payment__c,ASI_CRM_CN_Paid__c,ASI_CRM_CN_Paid_In_Progress__c, ASI_CRM_CN_Payment_Raised_Date__c From ASI_TH_CRM_PaymentRequests_Contract__r)                       
                                           FROM ASI_TH_CRM_Contract__c WHERE id =:InputContract.Id ];
        
        
        string whereClause = 'ASI_CRM_CN_Contract__c =\'' + Contract.Id + '\'';
        string whereClauseAtth = 'Parentid = \'' + Contract.Id + '\'';
        string whereClauseFeed = 'Type = \'ContentPost\' AND ParentId = \'' + Contract.Id + '\' AND Id != null ORDER BY ContentFileName';
        
        //---- get original BRSF line items ----
        string soqlBRSF = ASI_CRM_Function.getCreatableFieldsSOQL('ASI_CRM_CN_Contract_BRSF_Line_Item__c', whereClause, '');
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> LBRSF = DATABASE.Query(soqlBRSF);
        
        //---- get original Contract Cost items ----
        string soqlContractCost = ASI_CRM_Function.getCreatableFieldsSOQL('ASI_CRM_Contract_Cost__c', whereClause, '');
        List<ASI_CRM_Contract_Cost__c> LContractCost = DATABASE.Query(soqlContractCost);
        
        //---- get original Covered Outlet items ----
        string soqlCoveredOutlet = ASI_CRM_Function.getCreatableFieldsSOQL('ASI_CRM_CN_Covered_Outlet__c', whereClause, '');
        List<ASI_CRM_CN_Covered_Outlet__c>  LCoveredOutlet = DATABASE.Query(soqlCoveredOutlet);
        
        
        
        
        
        //cloned header
        ASI_TH_CRM_Contract__c ContractCloned = Contract.clone(false, true);
        //ContractCloned.ASI_CRM_CN_V0_0_PO_version__c=Contract.ASI_CRM_CN_V0_0_PO_version__c;
        ContractCloned.ASI_CRM_CN_IsClone__c = true; 
        ContractCloned.ASI_TH_CRM_Contract_External_ID__c=null;
        ContractCloned.ASI_CRM_CN_PO_Modification__c = false;
        ContractCloned.ASI_CRM_CN_Status__c = 'Archived';
        ContractCloned.ASI_CRM_CN_PO_Version__c =Contract.ASI_CRM_CN_PO_Version__c;
        ContractCloned.ASI_CRM_Converted_From__c = InputContract.ID; // Master Contract ID 
        ContractCloned.id=null;
        insert ContractCloned;
        
        //************Detail**********************************************************************************************
        
        //move Contract Approval Comment   
        List<ASI_CRM_Approval_Comment__c> LTransferContractComment_Insert = [SELECT id, ASI_CRM_Contract__c FROM ASI_CRM_Approval_Comment__c WHERE ASI_CRM_Contract__c =: Contract.id];
        for(ASI_CRM_Approval_Comment__c tcc : LTransferContractComment_Insert){
            tcc.ASI_CRM_Contract__c = ContractCloned.id;
        }
        update LTransferContractComment_Insert;
        
        
        
        //------ Process BRSF Line Items ------
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> LBRSF_Clone = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        if(LBRSF != null && LBRSF.size()>0){
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c originalBRSF :LBRSF) {
                ASI_CRM_CN_Contract_BRSF_Line_Item__c cloneBRSF = originalBRSF.clone(false, true);
                cloneBRSF.ASI_CRM_CN_Contract__c = ContractCloned.Id;
                cloneBRSF.ASI_CRM_CN_External_ID__c=null;
                LBRSF_Clone.add(cloneBRSF);
            }
        }
        if(LBRSF_Clone != null && LBRSF_Clone.size() > 0) {
            insert LBRSF_Clone;
        }
        
        //------ Process Constract Cost Items ------
        List<ASI_CRM_Contract_Cost__c> LContractCost_Clone = new List<ASI_CRM_Contract_Cost__c>();
        if(LContractCost != null && LContractCost.size()>0){
            for(ASI_CRM_Contract_Cost__c originalCost :LContractCost) {
                ASI_CRM_Contract_Cost__c cloneCost = originalCost.clone(false, true);
                cloneCost.ASI_CRM_CN_Contract__c = ContractCloned.Id;
                cloneCost.ASI_CRM_CN_External_ID__c=null;
                LContractCost_Clone.add(cloneCost);
            }
        }
        
        if(LContractCost_Clone != null && LContractCost_Clone.size() > 0) {
            insert LContractCost_Clone;
        }
        
        
        
        
        //------ Process Covered Outlet Items ------
        List<ASI_CRM_CN_Covered_Outlet__c> LCoveredOutlet_Clone = new List<ASI_CRM_CN_Covered_Outlet__c>();
        
        if(LCoveredOutlet != null && LCoveredOutlet.size()>0)
        {
            for(ASI_CRM_CN_Covered_Outlet__c originalCoveredOutlet :LCoveredOutlet) {
                ASI_CRM_CN_Covered_Outlet__c cloneCoveredOutlet = originalCoveredOutlet.clone(false, true);
                cloneCoveredOutlet.ASI_CRM_CN_Contract__c = ContractCloned.Id;
                cloneCoveredOutlet.ASI_CRM_CN_External_ID__c=null;
                LCoveredOutlet_Clone.add(cloneCoveredOutlet);
            }
        }
        
        if(LCoveredOutlet_Clone != null && LCoveredOutlet_Clone.size() > 0) {
            insert LCoveredOutlet_Clone;
        }
        
        
        ASI_CRM_Approval_Comment__c ApprovalComment=new ASI_CRM_Approval_Comment__c(ASI_CRM_Contract__c = Contract.id,
                                                                                    recordtypeid = Global_RecordTypeCache.getRTId('ASI_CRM_Approval_Comment__cASI_CRM_CN_PO_Contract_Comment'));
        insert ApprovalComment; 
        
        
        
        return ContractCloned;
    }
    
    
    
    //Contract Generation class name helper class
    public Static string ContractGenClassNameHandler(String ClassName){
        String ReturnString= '';
        if(ClassName == 'colspan4'){
            ReturnString=' colspan="4" ';
        }
        if(ClassName == 'rowspan1'){
            ReturnString=' rowspan="1" ';
        }
        if(ClassName == 'rowspan2'){
            ReturnString=' rowspan="2" ';
        }
        if(ClassName == 'rowspan3'){
            ReturnString=' rowspan="3" ';
        }
        if(ClassName == 'rowspan4'){
            ReturnString=' rowspan="4" ';
        }
        if(ClassName == 'rowspan5'){
            ReturnString=' rowspan="5" ';
        }
        if(ClassName == 'rowspan6'){
            ReturnString=' rowspan="6" ';
        }
        
        
        return ReturnString;
    }
    
    
    
    public Static Boolean checkApprover(String RecordId){   
        Boolean AdorAbove = false;
        set<Id> actorIds = new set<Id>();
        for(ProcessInstanceWorkitem piw :[SELECT ActorId FROM ProcessInstanceWorkitem WHERE processinstance.status = 'Pending' AND  processinstance.targetobjectid = :RecordId]){
            actorIds.add(piw.ActorId);
        }
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId in :actorIds];
        if(gms.size()>0){
            AdorAbove = true;
        }
        
        return AdorAbove;
    }
    
    
    
    
    
    
    // Calculate Payment V0.0 Contract Detail Line Contarct Cost (not including Fix cost)
    Public Static Decimal CalculateV0ContractDetailCost(ASI_TH_CRM_PaymentRequest__c CurrentPayment){
        Decimal ContractAmount=0;
        
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLines = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
        
        String V0ContractId='';
        if(CurrentPayment.ASI_TH_CRM_Contract__c!=null && CurrentPayment.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c!=null){
            V0ContractId=CurrentPayment.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c;
        }else if(CurrentPayment.ASI_TH_CRM_Contract__c!=null){
            V0ContractId=CurrentPayment.ASI_TH_CRM_Contract__c;
        }
        
        try{
            //query ContractBRSF Sub Brands & Data
            ContractLines = [SELECT id, ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, 
                             ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Chinese_Name__c,
                             ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c, 
                             ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Monthly_Qty__c , ASI_CRM_CN_Sub_Brand_Conversion_Factor__c,
                             ASI_CRM_CN_Contract__c, ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c,ASI_CRM_CN_Contract_Total_Dummy__c,
                             ASI_CRM_CN_Contract_Monthly_Vol9L__c, ASI_CRM_CN_Contract_Monthly_Qty__c,
                             ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Standard_Bottle_Size__c,
                             ASI_CRM_CN_Contract__r.ASI_CRM_CN_PO_Version__c
                             FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :V0ContractId];
        }catch(exception e){
            String msg = 'Save Error : ' +e.getMessage() + '</br>';
            ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyContractUtilitiesClass.CalculateV0ContractDetailCost  class have Error  '+msg,'ASI_CRM_CN_HeavyContractUtilitiesClass',' function failed! with Payment Id: '+CurrentPayment.id );
        }
        if(ContractLines.size()>0){
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c contractDetail:ContractLines){
                ContractAmount+= contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c!=null? contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c:0;
            }
        }
        
        return ContractAmount;
    }
    
    
    
    public static string SBGradeSorting(decimal strSeq){
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
        return returnString;
    }
    
    
    
    
    
    public Static date getFiscalYearStart(Date inputDate , Integer orgFiscalMonth){        
      
        Date fiscalYearStart;
        if(inputDate != null){            
            fiscalYearStart = Date.newinstance(inputDate.year(), orgFiscalMonth, 1);
            if(inputDate.month() < orgFiscalMonth && inputDate.year() == inputDate.year())
                fiscalYearStart = fiscalYearStart.addYears(-1);
        }
      
        return fiscalYearStart;
    }
    
    //FOR ASI_CRM_CN_HeavyGenerateGroupShuttleJob
    public Static void UpdateAttachmentHistoricalData(String ContractId, String HistoricalId){
        List<ASI_Attachment__c> TempList = [select id,ASI_CRM_External_Key__c,ASI_CRM_For_Contract_Use__c,ASI_CRM_Last_Run_Time__c,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_New_Contract_v0_0__c,ASI_CRM_New_Contract_vFinal__c  
                                            from ASI_Attachment__c where ASI_CRM_Contract__c =:ContractId and ownerId=:UserInfo.getUserId() and ASI_CRM_Type__c='Group Contract'];
        
        if(TempList.size()>0){
            ASI_Attachment__c TempRecord= TempList[0];
            TempRecord.ASI_CRM_For_Contract_Use__c=true;
            if(TempRecord.ASI_CRM_Historical_Financial_Data__c=='' || TempRecord.ASI_CRM_Historical_Financial_Data__c==null){
                TempRecord.ASI_CRM_Historical_Financial_Data__c=HistoricalId+';';
            }else{
                TempRecord.ASI_CRM_Historical_Financial_Data__c=TempRecord.ASI_CRM_Historical_Financial_Data__c+=HistoricalId+';';
            } //=TempRecord.ASI_CRM_Historical_Financial_Data__c+HistoricalId+';';
            update TempRecord;
        }
    } 
    
    public Static string CheckPointTranslation(string InputString){
        if(InputString=='Historical V0.0'){
            InputString='旧合同V0.0';
        }else if(InputString=='Historical Vfinal'){
            InputString='旧合同最终版';
        }else if(InputString=='New Contact V0.0 Contract'){
            InputString='新合同V0.0合同';
        }else if(InputString=='New Contract V0.0 Est.'){
            InputString='新合同V0.0预估';
        }else if(InputString=='New Contract V Final'){
            InputString='新合同最终版';
        }else if(InputString=='Payment Speed%'){
            InputString='付款进度(除固定费用）';
        }else if(InputString=='Theoretical Value'){
            InputString='建议值';
        }else if(InputString=='Predefined Theoretical Value'){
            InputString='建议值';
        }else if(InputString=='Volume Speed%'){
            InputString='销量完成率';
        }else if(InputString=='PRC Guidance'){
            InputString='公司规定';
        }else if(InputString=='PO Submit Date'){
            InputString='PO提交日期';
        }else if(InputString=='PRC Default Methodology'){
            InputString='公司建议计算方式';
        }else if(InputString=='PRC Default Volume Base'){
            InputString='公司建议计算基础';
        }else if(InputString=='Min Key Strategy Achievement Rate'){
            InputString='最低战略品牌完成率';
        } else if(InputString=='Total Volume Achievement Rate'){
            InputString='销量完成率';
        }
        return InputString; 
    }
        
    public Static String VolumeBaseTranslation(String VolumeBaseName){
        if(VolumeBaseName!=null){
            if(VolumeBaseName.contains('Sub-Brand')){
                VolumeBaseName+='(按品牌)';
            }
            if(VolumeBaseName.contains('Grade')){
                VolumeBaseName+='(按品牌档次)';
            }
            if(VolumeBaseName.contains('Category')){
                VolumeBaseName+='(按产品类别)';
            }
            if(VolumeBaseName.contains('Total')){
                VolumeBaseName+='(按总销量)';
            }
        }
       
        return VolumeBaseName;
        
    }
        
    //FOR ASI_CRM_CN_HeavyGenerateGroupShuttleJob
    public Static void UpdateAttachmentContractData(String ContractId, String v00Id,String vFinalId){
        List<ASI_Attachment__c> TempList = [select id,ASI_CRM_External_Key__c,ASI_CRM_For_Contract_Use__c,ASI_CRM_Last_Run_Time__c,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_New_Contract_v0_0__c,ASI_CRM_New_Contract_vFinal__c  
                                            from ASI_Attachment__c where ASI_CRM_Contract__c =:ContractId and ownerId=:UserInfo.getUserId() and ASI_CRM_Type__c='Group Contract'];
        
        if(TempList.size()>0){
            ASI_Attachment__c TempRecord= TempList[0];
            TempRecord.ASI_CRM_For_Contract_Use__c=true;
            if(TempRecord.ASI_CRM_New_Contract_v0_0__c=='' || TempRecord.ASI_CRM_New_Contract_v0_0__c==null){
                TempRecord.ASI_CRM_New_Contract_v0_0__c=v00Id+';';
            }else{
                TempRecord.ASI_CRM_New_Contract_v0_0__c= TempRecord.ASI_CRM_New_Contract_v0_0__c+v00Id+';';
            }
            
            if(TempRecord.ASI_CRM_New_Contract_vFinal__c=='' || TempRecord.ASI_CRM_New_Contract_vFinal__c==null){
                TempRecord.ASI_CRM_New_Contract_vFinal__c=vFinalId+';';
            }else{
                TempRecord.ASI_CRM_New_Contract_vFinal__c=TempRecord.ASI_CRM_New_Contract_vFinal__c+vFinalId+';';
            }
            //TempRecord.ASI_CRM_New_Contract_v0_0__c!=''?TempRecord.ASI_CRM_New_Contract_v0_0__c+v00Id+';':v00Id+';';
            //TempRecord.ASI_CRM_New_Contract_vFinal__c=TempRecord.ASI_CRM_New_Contract_vFinal__c!=''? TempRecord.ASI_CRM_New_Contract_vFinal__c+vFinalId+';':vFinalId+';';
            update TempRecord;
        }
    } 
    
    
    public Static void SendGroupContractShuttle(String ContractId){
        
        //Getting user email
        ASI_TH_CRM_Contract__c Contract = [select id,Name from ASI_TH_CRM_Contract__c where Id=:ContractId];
        User u =[select id,Email from user where Id=:UserInfo.getUserId()];
        
        //get system debug email
        ASI_CRM_CN_CustomSetting__c CustomSetting = ASI_CRM_CN_CustomSetting__c.getInstance();
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> setToAddressList = new List<String>();
        setToAddressList.add(u.Email);
        mail.setToAddresses(setToAddressList);
        mail.setReplyTo(CustomSetting.ASI_CRM_System_Debug_Email__c);
        mail.setSenderDisplayName(' Group Contract Profit Shuttle');
        mail.setSubject('Group Contract Profit Shuttle');
        mail.setPlainTextBody('Please find your Group Contract Profit Shuttle as attached. Thanks. ');
        
        //Generate PDF
        PageReference pdf = Page.ASI_CRM_CN_HeavyGroupProfitShuttlePDF;
        pdf.getParameters().put('id',Contract.Id);
        //pdf.getParameters().put('EndDate','2017-07-31');
        //pdf.getParameters().put('StartDate','2017-07-01');
        Blob body;
        //Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pr.getContent();
        //body = pdf.getContent();
        body=Test.isRunningTest() ?Blob.valueOf('UNIT.TEST') :pdf.getContent();
        
        
        List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
        
        Messaging.EmailFileAttachment efa = NEW Messaging.EmailFileAttachment();   //Define the email
        efa.setFileName(Contract.Name+'.pdf');  
        efa.setBody(body);
        efa.setContentType('application/pdf');
        
        efaList.add(efa);    
        
        if(efaList.size()>0){
            mail.setFileAttachments(efaList);
        }
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
    }
    
    
    
    
    
}