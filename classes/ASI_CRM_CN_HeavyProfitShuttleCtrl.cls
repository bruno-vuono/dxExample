public with sharing class ASI_CRM_CN_HeavyProfitShuttleCtrl {
    public String PageId {set;get;}
    public ASI_TH_CRM_Contract__c thisCC {set;get;}
    public string strPDF {set;get;}
    public boolean AdorAbove {set;get;}
    
    public boolean IsEmail  {set;get;}{IsEmail=false;}
    public String IsEmailStr  {set;get;}{IsEmailStr='0';}
    
    //Date to the String 
    public string thisCCStart {set;get;}
    public string thisCCEnd {set;get;}
    public string previousCCStart {set;get;}
    public string previousCCEnd {set;get;}
    public string PreviousCCSalesRep {set;get;} {PreviousCCSalesRep='';}
    
    public boolean showCN {set;get;}
    
    //get Contract Approval Comments
    public List<ASI_CRM_Approval_Comment__c> lstApprovalComment {set;get;}{lstApprovalComment= new List<ASI_CRM_Approval_Comment__c> ();}
    public String ApprovalComment {set;get;}
    
    public Set<String> SubbrandGroupNameSet {set;get;} {SubbrandGroupNameSet = new Set<String>(); }
    
    public Map<String, String> sbGroup_map {set;get;} {sbGroup_map = new Map<String, String>();}
    
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public Boolean ExistHistoricalData {set;get;} {ExistHistoricalData=true;}
    public ASI_CRM_Module__c BRSFModule {set;get;} {BRSFModule = new ASI_CRM_Module__c();}
    public List<ASI_CRM_Module__c> PSFModuleList {set;get;} {PSFModuleList = new List<ASI_CRM_Module__c>();}
    
    public map<String, ASI_CRM_Module__c> PSF_Item_Map {set;get;} {PSF_Item_Map= new map<String, ASI_CRM_Module__c>();}
    
    
    public ASI_CRM_Module__c VECModule {set;get;} {VECModule = new ASI_CRM_Module__c();}
    
    public Boolean displayBRSF {set;get;} {displayBRSF=false;}
    public Boolean displayVEC {set;get;} {displayVEC=false;}

    public boolean ShowPSF_VXTable {set;get;} {ShowPSF_VXTable=false;}
    public boolean ShowVEC_VXTable {set;get;} {ShowVEC_VXTable=false;}
    public boolean ShowFixCostable {set;get;} {ShowFixCostable=false;}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalV00Contract  {set;get;} { HistoricalV00Contract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalVFinalContract  {set;get;} { HistoricalVFinalContract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContractV0Esitimate  {set;get;} { NewContractV0Esitimate = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContactV0Contract  {set;get;} { NewContactV0Contract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalContractCompared  {set;get;} { HistoricalContractCompared = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HVfinalComparedContract  {set;get;} { HVfinalComparedContract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    
    public Map<String,ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine> SubBrandContractMap  {set;get;}  { SubBrandContractMap = new Map<String,ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine> ();}
    
    public Map<String,ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine> FixExpense_Map  {set;get;}  { FixExpense_Map = new Map<String,ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine> ();}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine PSFDetailTotal {set;get;} {PSFDetailTotal = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine VECDetailTotal {set;get;} {VECDetailTotal = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();}
    
    public Decimal HistoricalPSFEstTotal {set;get;}  {HistoricalPSFEstTotal=0;} 
    public Decimal HistoricalVECEstTotal {set;get;}  {HistoricalVECEstTotal=0;}
    
    public Decimal HistoricalVEAdjustment{set;get;}  {HistoricalVEAdjustment=0;} // HistoricalVariableExpenseAdjustment
    public Decimal EstimateVEAdjustment{set;get;}  {EstimateVEAdjustment=0;}
    public Decimal ContractVEAdjustment{set;get;}  {ContractVEAdjustment=0;}
    
    //HTML
    public string td_end {set;get;}
    public String ExistHistoricalDataTD {set;get;}
    public String ExistHisDataTD_dotted {set;get;}
    
    public String ExistHistoricalData1 {set;get;}
    public String ExistHistoricalData2 {set;get;}
    public String ExistHisDataTD_noBottom {set;get;}
    
    public String MainTableHeader1 {set;get;}
    public String MainTableHeader2 {set;get;}
    
    public String ExistHisDataTD_dottednoBottom {set;get;}
    public String MainTableHeader3 {set;get;}
    public String MainTableHeader4 {set;get;}
    public String MainTableHeaderdotted {set;get;}
    public String ExistHisDataTD_TradeExpenses {set;get;}
    
    Public Boolean ShowAchievementRecognition  {set;get;}  {ShowAchievementRecognition=false;} 
    
    public ASI_CRM_CN_HeavyProfitShuttleCtrl(){}
    
    public ASI_CRM_CN_HeavyProfitShuttleCtrl(ApexPages.StandardController controller) {
        PageId = ApexPages.currentPage().getParameters().get('id');
        
    }
    
    
    public boolean init(){
        showCN = USerInfo.getLanguage()=='zh_CN';
        
        td_end = '</td>';
        ExistHistoricalDataTD ='<td style=" border-right: 1px solid black; border-bottom: 1px solid black; " align="right">';
        ExistHisDataTD_noBottom ='<td style=" border-right: 1px solid black;" align="right">';
        
        ExistHisDataTD_dotted ='<td style="border-bottom: 1px solid black; border-right: 1px dotted gray;" align="right">';
        ExistHisDataTD_dottednoBottom ='<td style=" border-right: 1px dotted gray;" align="right">';
        
        ExistHistoricalData1='<td colspan="3" style=" border-right: 1px solid black; border-bottom: 1px solid black;white-space: pre;" align="center">Historical Contract<br/>历史合同</td> <td colspan="3" style="border-right: 1px solid black; border-bottom: 1px solid black;white-space: pre;" align="center">New Contract<br/>新合同</td>';
        ExistHistoricalData2='<td colspan="2" style="border-right: 1px solid black; border-bottom: 1px solid black;white-space: pre;" align="center">New Contract<br/>新合同</td>';
        
        MainTableHeader1='<td colspan="9" bgcolor="#99CCFF" style="border:1px solid black;" align="center" ><strong>P&L REVIEW (in RMB) 利润分析表 （元）</strong></td>';
        MainTableHeader2='<td colspan="5" bgcolor="#99CCFF" style="border:1px solid black;" align="center" ><strong>P&L REVIEW (in RMB) 利润分析表 （元）</strong></td>';
        MainTableHeader3='<td style=" border-right: 1px solid black; border-bottom: 1px solid black;white-space: pre;" align="center">';
        MainTableHeaderdotted='<td style=" border-right: 1px dotted gray; border-bottom: 1px solid black;white-space: pre;" align="center">';
        
        ExistHisDataTD_TradeExpenses='<td style=" border-bottom: 1px solid black; border-right: 1px dotted gray;" align="right"  bgcolor="#E3DFDA">';
        
        IsEmail = IsEmailStr == '1' ? true : false;
        map<integer, string> MonthMapping = new map<integer, string>();
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
        
        
        if (PageId != null){
            HistoricalContractCompared= new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();
            try{
                thisCC = [SELECT id,ASI_CRM_Last_RBA_Approver__c,ASI_CRM_Martell_BC_Rate__c, ASI_CRM_CN_Group_Contract__c, Name,ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_CN_Group_Contract__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c,ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c, ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_V0_0_PO_version__c, Owner.Name,ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c
                          FROM ASI_TH_CRM_Contract__c WHERE id = :PageId];
                
                if (thisCC.ASI_CRM_CN_PO_Start_Date__c!= null){
                    if (MonthMapping.containskey((thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH()))
                        thisCCStart = (thisCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + MonthMapping.get((thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH());
                }else
                    thisCCStart = (thisCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + (thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH();
                
                if (thisCC.ASI_CRM_CN_PO_End_Date__c!= null){
                    if (MonthMapping.containskey((thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH()))
                        thisCCEnd = (thisCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + MonthMapping.get((thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH());
                }else
                    thisCCEnd = (thisCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + (thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH();
                
                
                
                if(thisCC.ASI_CRM_CN_Vol_Budget_LE__c==null){
                    thisCC.ASI_CRM_CN_Vol_Budget_LE__c=0;
                }
                if(thisCC.ASI_CRM_CN_Budget_LE__c==null){
                    thisCC.ASI_CRM_CN_Budget_LE__c=0;
                }
                lstApprovalComment = [SELECT id, recordtypeid, ASI_CRM_BA_comments__c, ASI_CRM_Background_Objective__c, ASI_CRM_New_contract_Analsysis__c, ASI_CRM_Historical_Contract_Performance__c FROM ASI_CRM_Approval_Comment__c 
                                      WHERE ASI_CRM_Contract__c =:thisCC.id];  
                
                
                if(lstApprovalComment==null || lstApprovalComment.size()==0){
                    ApprovalComment ='';
                    lstApprovalComment.add(new ASI_CRM_Approval_Comment__c());
                }
                else{
                    for(ASI_CRM_Approval_Comment__c ac : lstApprovalComment){
                        if(ac.recordtypeid == Global_RecordTypeCache.getRTId('ASI_CRM_Approval_Comment__cASI_CRM_CN_New_Contract_Comment')){
                            ApprovalComment = 'new';
                            lstApprovalComment[0] = ac;
                        }
                        else if(ac.recordtypeid == Global_RecordTypeCache.getRTId('ASI_CRM_Approval_Comment__cASI_CRM_CN_PO_Contract_Comment')){
                            ApprovalComment = 'po';
                            lstApprovalComment[0] = ac;
                            break;
                        }
                        
                    }
                }
                
                
            }catch(exception e){
                String msg = 'Save Error : ' +e.getMessage() + '</br>';
                ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyProfitShuttleCtrl in init class have Error  '+msg,'ASI_CRM_CN_HeavyProfitShuttleCtrl','PDF function failed! with contract Id: '+PageId );
            }
            
        }
        if (strPDF == '1'){
            checkUserID();
        }
        
        if (strPDF == '0'){
            checkApprover();
        }
        if (strPDF == '3'){// check last RBA
            if(thisCC.ASI_CRM_Last_RBA_Approver__c!=null){
                checkLastRBAID();
            }else{
                checkUserID();
            }
        }
        
        
        //Geting HistoricalV0.0 and VFinal Data
        List<ASI_Attachment__c> AttachmentList= [select id,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_Contract__c,ASI_CRM_Type__c from ASI_Attachment__c where ASI_CRM_Contract__c = :thisCC.Id ];
        if(AttachmentList.size()>0){
            for(ASI_Attachment__c att:AttachmentList){
                if(att.ASI_CRM_Type__c=='Historical Data'){
                    String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&quot;','"');// 
                    
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> HistoricalContractList =(List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>.class);
                    if(HistoricalContractList.size()>0){
                        HistoricalV00Contract= DataRounding(HistoricalContractList[0]);
                        HistoricalVFinalContract= DataRounding(HistoricalContractList[1]);
                        
                        if(HistoricalVFinalContract.AddOnString!=''){
                            
                            Map<String,Decimal> TempMap = (Map<String,Decimal>)System.JSON.deserialize(HistoricalVFinalContract.AddOnString,Map<String,Decimal>.class);
                            if( TempMap.containsKey('PSFEstTotal')  ){
                                HistoricalPSFEstTotal= TempMap.get('PSFEstTotal');
                            }
                            
                            if( TempMap.containsKey('VECEstTotal')  ){
                                HistoricalVECEstTotal= TempMap.get('VECEstTotal');
                            }
                            
                            
                        }                        
                    } 
                }else if(att.ASI_CRM_Type__c=='Contract Data'){
                    String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&lt;','<');
                    JsonString = JsonString.replaceAll('&quot;','"');//system.debug('Test Contract Data : ' + JsonString);
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> ContractList =(List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>.class);
                    if(ContractList.size()>0){
                        NewContractV0Esitimate= DataRounding(ContractList[0]);
                        NewContactV0Contract= DataRounding(ContractList[1]);
                    } 
                }
                
            }
        }
        
        String BRSFDefaultMethodology='';
        String PSFDefaultMethodology='';
        String VECDefaultMethodology='';
        
        
        
        ASI_CRM_Methodology__c BRSFMethodology_Default= new ASI_CRM_Methodology__c();
        ASI_CRM_Methodology__c PSFMethodology_Default=new ASI_CRM_Methodology__c();
        ASI_CRM_Methodology__c VECMethodology_Default=new ASI_CRM_Methodology__c();
        
        
        for(ASI_CRM_Methodology__c meth: [Select Id,Name,ASI_CRM_Sequence__c,ASI_CRM_Type__c,ASI_CRM_Default__c,RecordType.DeveloperName 
                                          from ASI_CRM_Methodology__c where RecordType.DeveloperName like 'ASI_CRM_CN%' AND ASI_CRM_Default__c =TRUE ])
        {
            if(meth.ASI_CRM_Type__c=='BRSF'){
                BRSFDefaultMethodology=meth.Id;
                BRSFMethodology_Default=meth;
            }            
            if(meth.ASI_CRM_Type__c=='PSF'){
                PSFDefaultMethodology=meth.Id;
                PSFMethodology_Default=meth;
            }
            if(meth.ASI_CRM_Type__c=='Variable Event Cost'){
                VECDefaultMethodology=meth.Id;
                VECMethodology_Default=meth;
            }
        }
        
        //system.assertEquals(PSFDefaultMethodology, 'Tony Testing');
        Map<String,ASI_CRM_Module__c> ModuleMap= new Map<String,ASI_CRM_Module__c>(); // Map <Id, ASI_CRM_Module__c>
        
        
        //If contract version = v0.0 
        if(thisCC.ASI_CRM_CN_Status__c!='Archived'){
            for(ASI_CRM_Module__c Module: [select Id,ASI_CRM_Is_Default_Methodology__c,ASI_CRM_Remark_Display__c,ASI_CRM_Line_Type__c,ASI_CRM_Remark__c,ASI_CRM_Unit__c,ASI_CRM_Volume_Base__c,ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c,ASI_CRM_Methodology__c,ASI_CRM_Methodology__r.Name,ASI_CRM_Reason_Not_NCD_Methodology__c,ASI_CRM_Reason_NCD_Volume_Base__c from ASI_CRM_Module__c 
                                           where ASI_CRM_Contract__c =:pageId ])
            {
                ModuleMap.put(Module.Id,Module);
            }
        }else{//contract version != v0.0 
            for(ASI_CRM_Module__c Module: [select Id,ASI_CRM_Is_Default_Methodology__c,ASI_CRM_Remark_Display__c,ASI_CRM_Line_Type__c,ASI_CRM_Remark__c,ASI_CRM_Unit__c,ASI_CRM_Volume_Base__c,ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c,ASI_CRM_Methodology__c,ASI_CRM_Methodology__r.Name,ASI_CRM_Reason_Not_NCD_Methodology__c,ASI_CRM_Reason_NCD_Volume_Base__c from ASI_CRM_Module__c 
                                           where ASI_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c =:pageId ])
            {
                ModuleMap.put(Module.Id,Module);
            }
        }
        
        displayBRSF=false;
        displayVEC=false;
        
        Set<Id> PSFIdSet= new Set<Id>();
        PSF_Item_Map= new map<String, ASI_CRM_Module__c>();
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSFLine:[SELECT Id, ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Sequence__c ,ASI_CRM_Max_Incentive__c,ASI_CRM_Module__r.ASI_CRM_Volume_Base__c, ASI_CRM_Contract_Total_QTY_std_Btl__c,ASI_CRM_Est_Total_QTY_std_Btl__c,ASI_CRM_Contract_Total_QTY_CR12_Eqv__c,ASI_CRM_Est_Total_QTY_CR12_Eqv__c,ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name,  ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Product_Category__c , ASI_CRM_Volume_Base__c , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                            WHERE ASI_CRM_CN_Contract__c = :PageId] )
        {
            
            if(ModuleMap.containsKey(BRSFLine.ASI_CRM_Module__c)){
                if(BRSFLine.ASI_CRM_Type__c=='BRSF'){
                    BRSFModule=ModuleMap.get(BRSFLine.ASI_CRM_Module__c);
                    if(BRSFMethodology_Default.Id ==BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c || BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Sequence__c<BRSFMethodology_Default.ASI_CRM_Sequence__c){
                        BRSFModule.ASI_CRM_Is_Default_Methodology__c=true;
                        displayBRSF=true;
                    }
                    if(thisCC.ASI_CRM_CN_Group_Contract__c!=null){
                        BRSFModule.ASI_CRM_Is_Default_Methodology__c=true;
                    }
                }
                
                if(BRSFLine.ASI_CRM_Type__c=='PSF' && !PSFIdSet.contains(BRSFLine.ASI_CRM_Module__c)){
                    ASI_CRM_Module__c TempModule =ModuleMap.get(BRSFLine.ASI_CRM_Module__c);
                    if( (PSFMethodology_Default.Id ==BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c || BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Sequence__c<PSFMethodology_Default.ASI_CRM_Sequence__c ) && (BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Sub-Brand' || BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Grade')){
                        TempModule.ASI_CRM_Is_Default_Methodology__c=true;
                    }
                    if(thisCC.ASI_CRM_CN_Group_Contract__c!=null){
                        TempModule.ASI_CRM_Is_Default_Methodology__c=true;
                    }
                    
                    PSFModuleList.add(TempModule);
                    PSFIdSet.add(BRSFLine.ASI_CRM_Module__c);
                    
                    if(!PSF_Item_Map.containsKey(BRSFLine.ASI_CRM_Module__c)){
                        PSF_Item_Map.put(BRSFLine.ASI_CRM_Module__c, TempModule);
                    }
                }
                IF(BRSFLine.ASI_CRM_Type__c=='PSF'){
                    PSFDetailTotal.ContractTotalFees +=BRSFLine.ASI_CRM_CN_Contract_Total_Dummy__c !=null?BRSFLine.ASI_CRM_CN_Contract_Total_Dummy__c : 0;
                    PSFDetailTotal.EstimateTotalFees+=BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                    
                }
                if(BRSFLine.ASI_CRM_Type__c=='Variable Event Cost'){
                    displayVEC=true;
                    VECModule=ModuleMap.get(BRSFLine.ASI_CRM_Module__c);
                    if( (VECDefaultMethodology ==BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c ||  BRSFLine.ASI_CRM_Module__r.ASI_CRM_Methodology__r.ASI_CRM_Sequence__c<VECMethodology_Default.ASI_CRM_Sequence__c ) && (BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Total' || BRSFLine.ASI_CRM_Module__r.ASI_CRM_Volume_Base__c=='By Grade')){
                        VECModule.ASI_CRM_Is_Default_Methodology__c=true;
                    }
                     if(thisCC.ASI_CRM_CN_Group_Contract__c!=null){
                        VECModule.ASI_CRM_Is_Default_Methodology__c=true;
                    }
                    
                    VECDetailTotal.ContractTotalFees +=BRSFLine.ASI_CRM_CN_Contract_Total_Dummy__c !=null?BRSFLine.ASI_CRM_CN_Contract_Total_Dummy__c : 0;
                    VECDetailTotal.EstimateTotalFees+=BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?BRSFLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                    
                }
                
              
            }
        }
        DataFixing(MonthMapping);
      
        return true;
    }
    
    
    
     private String SplitLineIntoRow(String InputString,integer CutNumber ){
         String outputString ='';
         
         //if there is not english Character and all of them are Chinese, then break lines
         if(InputString!=null){
             if(!ASI_CRM_CN_HeavyContracFunctionClass.containsEnglishCharacters(InputString) && ASI_CRM_CN_HeavyContracFunctionClass.containsChineseCharacters(InputString) ){
                 try{
                     if(InputString.length() >= CutNumber ){
                         while(InputString.length() >= CutNumber ){
                             outputString = outputString + InputString.subString(0,CutNumber) + '<br/>';
                             InputString= InputString.subString(CutNumber);
                         }
                     }
                     outputString = outputString + InputString;
                 }catch(exception e){
                     outputString =  InputString;
                 }
                 
             }else{
                 outputString=InputString;
             }
         }
         
        return outputString;
    }
    
    
    
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator DataRounding(ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator InputData){
        //ROIIntake setScale
        
        InputData.GrossSalesRate = InputData.GrossSalesRate!=null? InputData.GrossSalesRate.setScale(1):0;
        InputData.ROIIntake = InputData.ROIIntake!=null? InputData.ROIIntake.setScale(2):0;
        
        return InputData;
    }
    
    
    public void DataFixing( map<integer, string> MonthMapping){
        SubbrandGroupNameSet= new Set<String> ();
        SubbrandGroupNameSet.add('1. Standard + Premium 标准档 + 高档');
        SubbrandGroupNameSet.add('2. Super Premium 超高档');
        
        SubbrandGroupNameSet.add('3. Ultra Premium 特级高档');
        SubbrandGroupNameSet.add('4. Prestige + Ultra Prestige 奢华档 + 特级奢华档');
        
        sbGroup_map = new Map<String, String>();
        sbGroup_map.put('1. Standard + Premium 标准档 + 高档', 'Standard + Premium 标准档 + 高档');
        sbGroup_map.put('2. Super Premium 超高档', 'Super Premium 超高档');
        sbGroup_map.put('3. Ultra Premium 特级高档', 'Ultra Premium 特级高档');
        sbGroup_map.put('4. Prestige + Ultra Prestige 奢华档 + 特级奢华档', 'Prestige + Ultra Prestige 奢华档 + 特级奢华档');
        
        for(String SBGName: sbGroup_map.keySet()){
           
            
            if(HistoricalV00Contract.SubBrandGradeMap==null || !HistoricalV00Contract.SubBrandGradeMap.containskey(SBGName)){
                HistoricalV00Contract.SubBrandGradeMap.put(SBGName,0.0);      
            }
            if(HistoricalVFinalContract.SubBrandGradeMap==null || !HistoricalVFinalContract.SubBrandGradeMap.containskey(SBGName)){
                HistoricalVFinalContract.SubBrandGradeMap.put(SBGName,0.0);      
            }
            if(NewContractV0Esitimate.SubBrandGradeMap==null || !NewContractV0Esitimate.SubBrandGradeMap.containskey(SBGName)){
                NewContractV0Esitimate.SubBrandGradeMap.put(SBGName,0.0);      
            }
            if(NewContactV0Contract.SubBrandGradeMap==null || !NewContactV0Contract.SubBrandGradeMap.containskey(SBGName)){
                NewContactV0Contract.SubBrandGradeMap.put(SBGName,0.0);      
            }
            
            if(HistoricalContractCompared.SubBrandGradeMap==null || !HistoricalContractCompared.SubBrandGradeMap.containskey(SBGName)){
                Decimal ComparedRate=0;
                if(HistoricalV00Contract.SubBrandGradeMap.get(SBGName)!=0){
                    ComparedRate=((HistoricalVFinalContract.SubBrandGradeMap.get(SBGName)-HistoricalV00Contract.SubBrandGradeMap.get(SBGName))*100)/HistoricalV00Contract.SubBrandGradeMap.get(SBGName);
                }
                HistoricalContractCompared.SubBrandGradeMap.put(SBGName,ComparedRate);      
            }
            
        }
        
        SubBrandContractMap = new Map<String, ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine>(NewContactV0Contract.ContractLineMap);
        for(String ContractLineKey:HistoricalVFinalContract.ContractLineMap.keySet()){
            if(SubBrandContractMap.containsKey(ContractLineKey)){
                SubBrandContractMap.get(ContractLineKey).HistoricalBottles=HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalBottles;
                SubBrandContractMap.get(ContractLineKey).HistoricalFees = HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalFees;
                SubBrandContractMap.get(ContractLineKey).HistoricalTotalFees = HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalTotalFees;
            }else{
                SubBrandContractMap.put(ContractLineKey, HistoricalVFinalContract.ContractLineMap.get(ContractLineKey));
            }
        }
        
        
        Decimal HistoricalTotalFees=0;
        Decimal Sum_EstimateTotalFees=0;
        Decimal Sum_ContractTotalFees=0;
        for(String SubBrandContractKey:SubBrandContractMap.keySet()){
            SubBrandContractMap.get(SubBrandContractKey).HistoricalFees=DecimalRounding(SubBrandContractMap.get(SubBrandContractKey).HistoricalFees);
            SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles=DecimalRounding(SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles);
            
            if(SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles==0 && SubBrandContractMap.get(SubBrandContractKey).EstimateBottles==0 && SubBrandContractMap.get(SubBrandContractKey).ContractBottles ==0 && SubBrandContractMap.get(SubBrandContractKey).HistoricalFees ==0 && SubBrandContractMap.get(SubBrandContractKey).EstimateFees==0 && SubBrandContractMap.get(SubBrandContractKey).ContractFees ==0 && SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees==0 && SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees==0 && SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees==0){
                SubBrandContractMap.remove(SubBrandContractKey);
            }else{
                //system.debug('*****************************');
                //system.debug(SubBrandContractMap.get(SubBrandContractKey));
                //Data Fixing
                integer intlength = SubBrandContractMap.get(SubBrandContractKey).SubBrandName.length();
                if(intlength >= 4 && SubBrandContractMap.get(SubBrandContractKey).SubBrandName.contains('-')){
                    SubBrandContractMap.get(SubBrandContractKey).strSubBrand =  SubBrandContractMap.get(SubBrandContractKey).SubBrandName.substring(0, (intlength-4));
                }
                if(SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles!=null){
                    SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles = SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles.setScale(0, RoundingMode.HALF_UP);
                }
              //  if(SubBrandContractMap.get(SubBrandContractKey).HistoricalFees<1 && SubBrandContractMap.get(SubBrandContractKey).HistoricalFees>0){
                //    SubBrandContractMap.get(SubBrandContractKey).HistoricalFees=0;
               // }
                
                HistoricalTotalFees+=SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees;
                Sum_EstimateTotalFees +=SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees!=null?SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees:0;
                Sum_ContractTotalFees +=SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees!=null? SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees:0;
            }
        }
        HistoricalVEAdjustment= -(HistoricalVFinalContract.VariableExpense-HistoricalPSFEstTotal-HistoricalVECEstTotal-HistoricalTotalFees);
        EstimateVEAdjustment=-(NewContractV0Esitimate.VariableExpense-PSFDetailTotal.EstimateTotalFees-VECDetailTotal.EstimateTotalFees-Sum_EstimateTotalFees);
        ContractVEAdjustment=-(NewContactV0Contract.VariableExpense-PSFDetailTotal.ContractTotalFees-VECDetailTotal.ContractTotalFees-Sum_ContractTotalFees);
        if(HistoricalVEAdjustment!=0 || EstimateVEAdjustment!=0 && ContractVEAdjustment!=0){
            ShowAchievementRecognition=true;
        }
		
        if(HistoricalVECEstTotal!=0 || VECDetailTotal.EstimateTotalFees!=0 || VECDetailTotal.ContractTotalFees!=0 ){
            ShowVEC_VXTable=true;
        }

         if(HistoricalPSFEstTotal!=0 || PSFDetailTotal.EstimateTotalFees!=0 || PSFDetailTotal.ContractTotalFees!=0 ){
            ShowPSF_VXTable=true;
        }

        FixExpense_Map = new Map<String, ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine>(NewContactV0Contract.FixedExpensesMap);
        for(String ContractLineKey:HistoricalVFinalContract.FixedExpensesMap.keySet()){
            if(FixExpense_Map.containsKey(ContractLineKey)){
                FixExpense_Map.get(ContractLineKey).HistoricalFees =HistoricalVFinalContract.FixedExpensesMap.get(ContractLineKey).HistoricalFees;
            }else{
                FixExpense_Map.put(ContractLineKey, HistoricalVFinalContract.FixedExpensesMap.get(ContractLineKey));
            }
        }
        
        if(FixExpense_Map.size()>0){
            
            for(string FXMapKey:FixExpense_Map.keySet()){
                if(FixExpense_Map.get(FXMapKey).HistoricalFees==0 && FixExpense_Map.get(FXMapKey).EstimateFees==0 && FixExpense_Map.get(FXMapKey).ContractFees==0 ){
                    FixExpense_Map.remove(FXMapKey);
                }
            }
        }
        
        if(FixExpense_Map.size()>0){
            ShowFixCostable=true;
        }
        
        
        
        if(HistoricalVFinalContract.ContractId !=null && HistoricalVFinalContract.ContractId !=''){
            if (HistoricalVFinalContract.POStartDate!= null){
                if (MonthMapping != null && MonthMapping.containskey((HistoricalVFinalContract.POStartDate).MONTH()))
                    previousCCStart = (HistoricalVFinalContract.POStartDate).YEAR() + ' ' + MonthMapping.get((HistoricalVFinalContract.POStartDate).MONTH());
            } else{
                previousCCStart = (HistoricalVFinalContract.POStartDate).YEAR() + ' ' + (HistoricalVFinalContract.POStartDate).MONTH();
            }
            
            if (HistoricalVFinalContract.POEndDate!= null){
                if (MonthMapping != null && MonthMapping.containskey((HistoricalVFinalContract.POEndDate).MONTH()))
                    previousCCEnd = (HistoricalVFinalContract.POEndDate).YEAR() + ' ' + MonthMapping.get((HistoricalVFinalContract.POEndDate).MONTH());
            }else{
                previousCCEnd = (HistoricalVFinalContract.POEndDate).YEAR() + ' ' + (HistoricalVFinalContract.POEndDate).MONTH();   
            }
            
        }
        
        
        
        
        if((HistoricalV00Contract.ContractId !=null && HistoricalV00Contract.ContractId !='') || Test.isRunningTest() ){ //system.assertEquals(HistoricalV00Contract.ContractId, Null);
           
            
            ASI_TH_CRM_Contract__c PreviousCC =new ASI_TH_CRM_Contract__c();
            try{
                
               PreviousCC = [select Id,OwnerId,Owner.Name from ASI_TH_CRM_Contract__c where Id =:HistoricalV00Contract.ContractId];
            }catch(exception e){
                PreviousCC =new ASI_TH_CRM_Contract__c();
            }
            

            
            
            
            if(previousCC.Owner != null){
                PreviousCCSalesRep = previousCC.Owner.Name;
            }
            
            HVfinalComparedContract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();
            
            if(HistoricalVFinalContract.Volumes !=0.0){
                HVfinalComparedContract.Volumes = ((NewContractV0Esitimate.Volumes - HistoricalVFinalContract.Volumes)/HistoricalVFinalContract.Volumes)*100;
            }
            
            if(HistoricalV00Contract.Volumes !=0.0){//
                HistoricalContractCompared.Volumes = ((HistoricalVFinalContract.Volumes-HistoricalV00Contract.Volumes)/HistoricalV00Contract.Volumes)*100;
            }
            if(HistoricalV00Contract.TradeExpenses !=0.0){//
                HistoricalContractCompared.TradeExpenses = ((HistoricalVFinalContract.TradeExpenses-HistoricalV00Contract.TradeExpenses)/HistoricalV00Contract.TradeExpenses)*100;
            }
            
            HistoricalContractCompared.GrossSalesRate =HistoricalVFinalContract.GrossSalesRate-HistoricalV00Contract.GrossSalesRate;
            if(HistoricalV00Contract.InvestmentCR12 !=0.0){//
                HistoricalContractCompared.InvestmentCR12 = ((HistoricalVFinalContract.InvestmentCR12-HistoricalV00Contract.InvestmentCR12)/HistoricalV00Contract.InvestmentCR12)*100;
            }
            if(HistoricalV00Contract.VariableExpense !=0.0){//
                HistoricalContractCompared.VariableExpense = ((HistoricalVFinalContract.VariableExpense-HistoricalV00Contract.VariableExpense)/HistoricalV00Contract.VariableExpense)*100;
            }
            if(HistoricalV00Contract.FixedExpense !=0.0){//
                HistoricalContractCompared.FixedExpense = ((HistoricalVFinalContract.FixedExpense-HistoricalV00Contract.FixedExpense)/HistoricalV00Contract.FixedExpense)*100;
            }
            
            HistoricalContractCompared.FixedExpenseRate =HistoricalVFinalContract.FixedExpenseRate-HistoricalV00Contract.FixedExpenseRate;
            
            if(HistoricalV00Contract.MarginAfterAnP !=0.0){//
                HistoricalContractCompared.MarginAfterAnP = ((HistoricalVFinalContract.MarginAfterAnP-HistoricalV00Contract.MarginAfterAnP)/HistoricalV00Contract.MarginAfterAnP)*100;
            }
            
            
            if(HistoricalV00Contract.MarginPerBottle !=0.0){//
                HistoricalContractCompared.MarginPerBottle = ((HistoricalVFinalContract.MarginPerBottle-HistoricalV00Contract.MarginPerBottle)/HistoricalV00Contract.MarginPerBottle)*100;
            }
            
            HistoricalContractCompared.ROIIntake =HistoricalVFinalContract.ROIIntake-HistoricalV00Contract.ROIIntake;
            
            HistoricalContractCompared.ROIProForma =HistoricalVFinalContract.ROIProForma-HistoricalV00Contract.ROIProForma;
            
            HistoricalContractCompared.BCRate =HistoricalVFinalContract.BCRate-HistoricalV00Contract.BCRate;
            HistoricalContractCompared.TotalBCRate=HistoricalVFinalContract.TotalBCRate-HistoricalV00Contract.BCRate;
            
            HistoricalContractCompared.TotalMBCRate=HistoricalVFinalContract.TotalMBCRate-HistoricalV00Contract.TotalMBCRate;
            
        }else{
            HistoricalVFinalContract.NoOfMonths=null;
            ExistHistoricalData=false;
        }
        
        
    }
    
    
    
    
    public Decimal DecimalRounding(Decimal InputNumber){
        if(InputNumber!=null){
            if(InputNumber<1 && InputNumber>0){
                InputNumber=0; 
            }
        }
        
        return InputNumber;
    }
    
    
    public void checkLastRBAID(){
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId=:thisCC.ASI_CRM_Last_RBA_Approver__c];
        if(gms.size()>0)
            AdorAbove = true;
    }
    
    public void checkUserID(){
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId=:UserInfo.getUserId()];
        if(gms.size()>0)
            AdorAbove = true;
    }
    
    
    
    public void checkApprover(){
        AdorAbove = false;
        set<Id> actorIds = new set<Id>();
        for(ProcessInstanceWorkitem piw :[SELECT ActorId FROM ProcessInstanceWorkitem WHERE processinstance.status = 'Pending' AND processinstance.targetobjectid = : thisCC.id]){
            actorIds.add(piw.ActorId);
        }
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId in :actorIds];
        if(gms.size()>0)
            AdorAbove = true;
    }
    
    
}