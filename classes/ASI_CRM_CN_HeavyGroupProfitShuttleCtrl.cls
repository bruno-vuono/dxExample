/* Filename  :  ASI_CRM_CN_HeavyGroupProfitShuttleCtrl.cls
* Author     :  Laputa
* Purpose    :  Controller for Group Contract PDF 
* Study From :  ASI_CRM_CN_HeavyGroupProfitShuttleCtrl
* Testing    :  
* History
"%v0.0 对比新合同V0.0"=(New contract Vfinal-New contract V0.0 Estimate)/(New contract V0.0 Estimate )

'"% vFinal对比历史完成'=(New contract V0.0 Estimate- Historical VFinal)/Historical VFinal
* -----------------------------------------------------------------------------
* 2017-10-15   Laputa      Created

*/

public with sharing class ASI_CRM_CN_HeavyGroupProfitShuttleCtrl {
    public String PageId {set;get;}
    public string strPDF {set;get;}{strPDF='1';}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalV00Contract  {set;get;} { HistoricalV00Contract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalVFinalContract  {set;get;} { HistoricalVFinalContract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContractV0Esitimate  {set;get;} { NewContractV0Esitimate = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContactV0Contract  {set;get;} { NewContactV0Contract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContactVFinal  {set;get;} { NewContactVFinal = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalContractCompared  {set;get;} { HistoricalContractCompared = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    //public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HVfinalComparedContract  {set;get;} { HVfinalComparedContract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public Map<String, String> sbGroup_map {set;get;} {sbGroup_map = new Map<String, String>();}
    
    
    
    
    
    public Map<String, ContractObject> SummaryContractMap {set;get;} {SummaryContractMap = new Map<String, ContractObject> (); } 
    
    public class ContractObject {
        public ASI_TH_CRM_Contract__c CurrentContract {set;get;}{CurrentContract= new ASI_TH_CRM_Contract__c();} 
        public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ContractFI   {set;get;}{ContractFI= new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator();}  
        public String ContractId {set;get;} { ContractId = ''; }
        public ContractObject(){  
        }
    }
    
    
    public Boolean ExistHistoricalData {set;get;} {ExistHistoricalData=false;}
    
    public Map<String,ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine> SubBrandContractMap  {set;get;}  { SubBrandContractMap = new Map<String,ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine> ();}
    
    
    public ASI_TH_CRM_Contract__c thisCC {set;get;}{thisCC=new ASI_TH_CRM_Contract__c();}
    public ASI_TH_CRM_Contract__c HistoricalContract {set;get;}{HistoricalContract=new ASI_TH_CRM_Contract__c();}
    public String ApprovalComment {set;get;} {ApprovalComment='';}
    
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public boolean AdorAbove {set;get;}
    public boolean showCN {set;get;}
    
    public ASI_CRM_KA_Account__c KAAccount {set;get;}{KAAccount=new ASI_CRM_KA_Account__c();}
    Public Boolean ShowAchievementRecognition  {set;get;}  {ShowAchievementRecognition=false;} 
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine PSFDetailTotal {set;get;} {PSFDetailTotal = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine VECDetailTotal {set;get;} {VECDetailTotal = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine AdjustmentRecognition  {set;get;} {AdjustmentRecognition = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();}
    
    public Decimal HistoricalPSFEstTotal {set;get;}  {HistoricalPSFEstTotal=0;} 
    public Decimal HistoricalVECEstTotal {set;get;}  {HistoricalVECEstTotal=0;}
    
    public ASI_CRM_CN_HeavyGroupProfitShuttleCtrl(){}
    
    public Decimal HistoricalVFinalTotalBCRate {set;get;}  {HistoricalVFinalTotalBCRate=0;} 
    public Decimal HistoricalVFinalNetBCRate {set;get;}  {HistoricalVFinalNetBCRate=0;}
    
    
    public Decimal Hist_VFinalTotalMarBCRate {set;get;}  {Hist_VFinalTotalMarBCRate=0;} 
    public Decimal Hist_VFinalNetMarBCRate {set;get;}  {Hist_VFinalNetMarBCRate=0;}
    
    
    public Decimal NewContractVFinalTotalBCRate {set;get;}  {NewContractVFinalTotalBCRate=0;} 
    public Decimal NewContractVFinalNetBCRate {set;get;}  {NewContractVFinalNetBCRate=0;} 
    
    
    public Decimal New_VFinalTotalMartellBCRate {set;get;}  {New_VFinalTotalMartellBCRate=0;} 
    public Decimal New_VFinalNetMartellBCRate {set;get;}  {New_VFinalNetMartellBCRate=0;} 
    
    
    
    //get Contract Approval Comments
    public List<ASI_CRM_Approval_Comment__c> lstApprovalComment {set;get;}{lstApprovalComment= new List<ASI_CRM_Approval_Comment__c> ();}
    
    public ASI_CRM_CN_HeavyGroupProfitShuttleCtrl(ApexPages.StandardController controller) {
        PageId = ApexPages.currentPage().getParameters().get('id');
    }
    
    Public Integer HistoricalCoveredOutletSize {set;get;}{HistoricalCoveredOutletSize=0;}
    Public Integer V0CoveredOutletSize {set;get;}{V0CoveredOutletSize=0;}
    Public Integer VFinalCoveredOutletSize {set;get;}{VFinalCoveredOutletSize=0;}
    
    public Boolean IsLocalGroupContract {set;get;} {IsLocalGroupContract=false;}
    
    public boolean init(){
        HistoricalPSFEstTotal=0;
        HistoricalVECEstTotal=0;
        
        sbGroup_map = new Map<String, String>();
        sbGroup_map.put('1. Standard + Premium 标准档 + 高档', 'Standard + Premium 标准档 + 高档');
        sbGroup_map.put('2. Super Premium 超高档', 'Super Premium 超高档');
        sbGroup_map.put('3. Ultra Premium 特级高档', 'Ultra Premium 特级高档');
        sbGroup_map.put('4. Prestige + Ultra Prestige 奢华档 + 特级奢华档', 'Prestige + Ultra Prestige 奢华档 + 特级奢华档');
        
        
        HistoricalV00Contract = InitData( new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator () ) ;
        HistoricalVFinalContract =InitData( new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator () );
        NewContractV0Esitimate = InitData( new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator () );
        NewContactV0Contract = InitData( new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator () );
        NewContactVFinal = InitData( new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator () );
        
        
        
        
        
        
        
        
        PSFDetailTotal = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();
        VECDetailTotal = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();
        AdjustmentRecognition = new ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine();
        
        if (PageId != null){
            try{
                thisCC = [SELECT id, ASI_CRM_Martell_BC_Rate__c,ASI_CRM_SG_PRS_Contract_No__c,ASI_TH_CRM_Target_Distribution_Channel__c,Name,RecordType.DeveloperName,ownerId,ASI_CRM_Remarks__c,ASI_CRM_NationalGroup__c,ASI_CRM_NationalGroup__r.name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c,ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c, ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_V0_0_PO_version__c, Owner.Name,ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c
                          FROM ASI_TH_CRM_Contract__c WHERE id = :PageId];
                
                if(thisCC.RecordType.DeveloperName.contains('Local')){
                    IsLocalGroupContract=true;
                }
                KAAccount = [select Id,RecordType.DeveloperName,ASI_CRM_VEC_Methodology__c,ASI_CRM_VEC_Unit__c,ASI_CRM_VEC_Volume_Base__c,ASI_CRM_BRSF_Methodology__c,ASI_CRM_BRSF_Unit__c,ASI_CRM_BRSF_Volume_Base__c,
                             ASI_CRM_PSF_Meth_Mod1__c,ASI_CRM_PSF_Meth_Mod2__c,ASI_CRM_PSF_Meth_Mod3__c,
                             ASI_CRM_PSF_Unit_Mod1__c,ASI_CRM_PSF_Unit_Mod2__c,ASI_CRM_PSF_Unit_Mod3__c,
                             ASI_CRM_PSF_Volume_Base_Mod1__c,ASI_CRM_PSF_Volume_Base_Mod2__c,ASI_CRM_PSF_Volume_Base_Mod3__c,
                             ASI_CRM_PSF_Meth_Mod1__r.Name,ASI_CRM_PSF_Meth_Mod2__r.Name,ASI_CRM_PSF_Meth_Mod3__r.Name,ASI_CRM_BRSF_Methodology__r.Name,ASI_CRM_VEC_Methodology__r.Name,
                             ASI_CRM_PSF_Meth_Mod1__r.ASI_CRM_Chinese_Name__c,ASI_CRM_PSF_Meth_Mod2__r.ASI_CRM_Chinese_Name__c,ASI_CRM_PSF_Meth_Mod3__r.ASI_CRM_Chinese_Name__c,ASI_CRM_BRSF_Methodology__r.ASI_CRM_Chinese_Name__c,ASI_CRM_VEC_Methodology__r.ASI_CRM_Chinese_Name__c
                             from ASI_CRM_KA_Account__c where id=:thisCC.ASI_CRM_NationalGroup__c];
                
            }catch(exception e){
                
                system.debug(e.getMessage());
                ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyGroupProfitShuttleCtrl in init class have Error  '+'Save Error : ' +e.getMessage() + '</br>','ASI_CRM_CN_HeavyGroupProfitShuttleCtrl','PDF function failed! with contract Id: '+PageId );
            }
            
            LoadingFIData();
            
            DataConsolidation();
            DataReconstruct();
            
        }
        showCN = USerInfo.getLanguage()=='zh_CN';
        
        
        if (strPDF == '0'){
            checkApprover();
        }else{
            checkUserID();
        }
        
        
        return true;   
    }
    
    
    
    
    
    public void LoadingFIData(){
        
        
        
        SummaryContractMap = new Map<String, ContractObject> ();       
        Decimal TotalHC_BC=0;
        Decimal TotalHC_BackCap=0;
        Decimal TotalHC_IntakeBtl=0;
        
        Decimal Total_BC=0;
        Decimal Total_BackCap=0;
        Decimal Total_IntakeBtl=0;
        
        Decimal TotalHC_BC_Martell=0;
        Decimal TotalHC_BackCap_Martell=0;
        Decimal TotalHC_IntakeBtl_Martell=0;
        
        Decimal Total_BC_Martell=0;
        Decimal Total_BackCap_Martell=0;
        Decimal Total_IntakeBtl_Martell=0;
        
        
        
        //Historical Contract set
        Set<String> HistoricalContractset = new Set<String>();
        Set<String> Check_HistoricalContractset = new Set<String>();
        
        //New contract V0.0 Id Set
        Set<String> NewContractV00set = new Set<String>();
        Set<String> Check_NewContractV00set = new Set<String>();
        
        //New contract VFinal Id Set
        Set<String> NewContractVFinalset = new Set<String>();
        Set<String> Check_NewContractVFinalset = new Set<String>();
        
        
        //Historical Contract set
        Set<String> HistoricalContractOutletset = new Set<String>();
        //New contract V0.0 Id Set
        Set<String> NewContractV00Outletset = new Set<String>();
        //New contract VFinal Id Set
        Set<String> NewContractVFinalOutletset = new Set<String>();
        
        Set<String> AllContractIdSet = new Set<String>();
        
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
        
        
        
        
        if(thisCC.ASI_CRM_CN_PO_Start_Date__c!= null){
            if (MonthMapping.containskey((thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH())){
                thisCC.ASI_CRM_SG_PRS_Contract_No__c = (thisCC.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + MonthMapping.get((thisCC.ASI_CRM_CN_PO_Start_Date__c).MONTH());
            }
        }
        
        if (thisCC.ASI_CRM_CN_PO_End_Date__c!= null){
            if (MonthMapping.containskey((thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH())){
                thisCC.ASI_TH_CRM_Target_Distribution_Channel__c = (thisCC.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + MonthMapping.get((thisCC.ASI_CRM_CN_PO_End_Date__c).MONTH());
            }
        }
        
        
        
        //Finding bacth job contract ID 
        List<ASI_Attachment__c> AttList = [select id,ownerId,ASI_CRM_External_Key__c,ASI_CRM_Last_Run_Time__c,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_New_Contract_v0_0__c,ASI_CRM_New_Contract_vFinal__c,ASI_CRM_Comments__c  
                                           from ASI_Attachment__c where ASI_CRM_Contract__c =:thisCC.Id 
                                           and (ownerId=:UserInfo.getUserId() or ownerId=:thisCC.ownerId) and ASI_CRM_Type__c='Group Contract'];
        if(AttList.size()>0){
            Boolean Found=false;
            ASI_Attachment__c TempRecord= new ASI_Attachment__c();
            for(ASI_Attachment__c att:AttList){
                if(att.ownerId==UserInfo.getUserId() ||att.ownerId==thisCC.ownerId ){
                    TempRecord=att;
                    Found=true;
                    
                }
                
                IF(att.ownerId==UserInfo.getUserId()){
                    Break;
                }
                /*
                if(att.ownerId==UserInfo.getUserId() && !Found){
                    TempRecord=att;
                    
                }
                if(!Found && att.ownerId==thisCC.ownerId ){
                    TempRecord=att;
                    Found=true;
                }*/
            }
            
            
            //ASI_Attachment__c TempRecord= AttList[0];
            
            if(TempRecord.ASI_CRM_Historical_Financial_Data__c!=null && TempRecord.ASI_CRM_Historical_Financial_Data__c!=''){
                
                system.debug('Historical Financial_Data : '+TempRecord.ASI_CRM_Historical_Financial_Data__c);
                List<String> HistoricalContractIdList=TempRecord.ASI_CRM_Historical_Financial_Data__c.split(';');
                HistoricalContractset=ListToSet(HistoricalContractIdList);
                system.debug('HistoricalContractIdList : '+HistoricalContractIdList);
                
                AllContractIdSet.addAll(HistoricalContractset);
            }
            if(TempRecord.ASI_CRM_New_Contract_v0_0__c!=null && TempRecord.ASI_CRM_New_Contract_v0_0__c!=''){
                List<String> NewContractV00IdList=TempRecord.ASI_CRM_New_Contract_v0_0__c.split(';');
                NewContractV00set=ListToSet(NewContractV00IdList);
                AllContractIdSet.addAll(NewContractV00set);
            }
            if(TempRecord.ASI_CRM_New_Contract_vFinal__c!=null && TempRecord.ASI_CRM_New_Contract_vFinal__c!=''){
                List<String> NewContractVFinalIdList=TempRecord.ASI_CRM_New_Contract_vFinal__c.split(';');
                NewContractVFinalset=ListToSet(NewContractVFinalIdList);
                AllContractIdSet.addAll(NewContractVFinalset);
            }//List<String> IdSet =str.split(';');
            
            if(TempRecord.ASI_CRM_Comments__c!=null && TempRecord.ASI_CRM_Comments__c!='' && TempRecord.ASI_CRM_Comments__c.contains(';')){
                List<String> ContractIdList=TempRecord.ASI_CRM_Comments__c.split(';');
                String HistoricalContractID='';
                if(ContractIdList.size()>1){
                    HistoricalContractID=ContractIdList[1];
                    ExistHistoricalData=true;
                }
                if(HistoricalContractID!=''){
                    HistoricalContract=[select id,Name,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,ASI_CRM_Remarks__c,ASI_CRM_CN_Description__c  FROM ASI_TH_CRM_Contract__c WHERE id = :HistoricalContractID];
                    if (HistoricalContract.ASI_CRM_CN_PO_Start_Date__c!= null){
                        if (MonthMapping.containskey((HistoricalContract.ASI_CRM_CN_PO_Start_Date__c).MONTH())){
                            HistoricalContract.ASI_CRM_Remarks__c = (HistoricalContract.ASI_CRM_CN_PO_Start_Date__c).YEAR() + ' ' + MonthMapping.get((HistoricalContract.ASI_CRM_CN_PO_Start_Date__c).MONTH());
                        }
                    }
                    
                    if (HistoricalContract.ASI_CRM_CN_PO_End_Date__c!= null){
                        if (MonthMapping.containskey((HistoricalContract.ASI_CRM_CN_PO_End_Date__c).MONTH())){
                            HistoricalContract.ASI_CRM_CN_Description__c = (HistoricalContract.ASI_CRM_CN_PO_End_Date__c).YEAR() + ' ' + MonthMapping.get((HistoricalContract.ASI_CRM_CN_PO_End_Date__c).MONTH());
                        }
                    }
                    
                }
            }
            
            //HistoricalContract
        }
        
        system.debug('AllContractIdSet: '+AllContractIdSet);
        system.debug('HistoricalContractset: '+HistoricalContractset);
        
        List<ASI_Attachment__c> AttachmentList= [select id,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_Contract__c,ASI_CRM_Type__c from ASI_Attachment__c 
                                                 where ASI_CRM_Contract__c in:AllContractIdSet and ASI_CRM_Contract__c!=null ];
        
        
        system.debug('Enter 12: '+AttachmentList);
        
        for(ASI_Attachment__c att:AttachmentList){
            system.debug('Enter 12: ');
            if(HistoricalContractset.contains(att.ASI_CRM_Contract__c) && !Check_HistoricalContractset.contains(att.ASI_CRM_Contract__c)){//Historical Contract V0.0 and Historical VFinal 
                if(att.ASI_CRM_Type__c=='Current V0VFinal Data'){
                    String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&quot;','"');
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> HistoricalContractList =(List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>.class);
                    system.debug('HistoricalContractList: '+HistoricalContractList);
                    if(HistoricalContractList.size()>0){
                        
                        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalV00Temp= HistoricalContractList[0];
                        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator HistoricalVFinalTemp= HistoricalContractList[1];
                        
                        if(HistoricalVFinalTemp.AddOnString!=''){
                            Check_HistoricalContractset.add(att.ASI_CRM_Contract__c);
                            Map<String,Decimal> TempMap = (Map<String,Decimal>)System.JSON.deserialize(HistoricalVFinalTemp.AddOnString,Map<String,Decimal>.class);
                            if( TempMap.containsKey('PSFEstTotal')  ){//HistoricalPSFEstTotal += TempMap.get('PSFEstTotal');
                                PSFDetailTotal.HistoricalTotalFees+= TempMap.get('PSFEstTotal');
                            }
                            if( TempMap.containsKey('VECEstTotal')  ){//HistoricalVECEstTotal+= TempMap.get('VECEstTotal');
                                VECDetailTotal.HistoricalTotalFees+= TempMap.get('VECEstTotal');
                            }
                            
                            if( TempMap.containsKey('TotalBC_prorate')  ){//TotalHC_BC
                                TotalHC_BC+= TempMap.get('TotalBC_prorate');
                            }
                            if( TempMap.containsKey('TotalBlackCap_prorate')  ){//TotalBackCap
                                TotalHC_BackCap+= TempMap.get('TotalBlackCap_prorate');
                            }
                            if( TempMap.containsKey('Total_IntakeBtl_prorate')  ){//TotalHC_IntakeBtl
                                TotalHC_IntakeBtl+= TempMap.get('Total_IntakeBtl_prorate');
                            }
                            
                            if( TempMap.containsKey('TotalHistorical_MartellBC')  ){//TotalHC_BC
                                TotalHC_BC_Martell+= TempMap.get('TotalHistorical_MartellBC');
                            }
                            if( TempMap.containsKey('TotalHistorical_MartellIntakeBtl')  ){//TotalBackCap
                                TotalHC_IntakeBtl_Martell+= TempMap.get('TotalHistorical_MartellIntakeBtl');
                            }
                            if( TempMap.containsKey('TotalHistorical_MartellBlackCap')  ){//TotalHC_IntakeBtl
                                TotalHC_BackCap_Martell += TempMap.get('TotalHistorical_MartellBlackCap');
                            } 
                        }        
                        HistoricalV00Contract= FIConsolidation(HistoricalV00Contract,HistoricalV00Temp);
                        HistoricalVFinalContract= FIConsolidation(HistoricalVFinalContract,HistoricalVFinalTemp);
                    }
                }
            }
            
            if(NewContractV00set.contains(att.ASI_CRM_Contract__c) && !Check_NewContractV00set.contains(att.ASI_CRM_Contract__c) ){ // new contract V0.0 and new Contract VFinal Data
                if(att.ASI_CRM_Type__c=='Contract Data'){
                    String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&lt;','<');
                    JsonString = JsonString.replaceAll('&quot;','"');
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> ContractList =(List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>.class);
                    if(ContractList.size()>0){
                        Check_NewContractV00set.add(att.ASI_CRM_Contract__c);
                        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContractV0EsitimateTemp= ContractList[0];
                        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContactV0ContractTemp= ContractList[1];
                        
                        NewContactV0Contract= FIConsolidation(NewContactV0Contract,NewContactV0ContractTemp);
                        NewContractV0Esitimate= FIConsolidation(NewContractV0Esitimate,NewContractV0EsitimateTemp);
                        
                        
                        ContractObject TempContract = new ContractObject ();
                        TempContract.ContractFI= ContractList[0];
                        IF(ContractList[0].ContractId!='' ){
                            TempContract.ContractId= ContractList[0].ContractId;
                        }
                        SummaryContractMap.put(ContractList[0].ContractId,TempContract);
                        
                    } 
                }
            }
            
            if(NewContractVFinalset.contains(att.ASI_CRM_Contract__c) && !Check_NewContractVFinalset.contains(att.ASI_CRM_Contract__c)){// new contract VFinal 
                if(att.ASI_CRM_Type__c=='PO Modification Data'){//new contract Vfinal
                    String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&quot;','"');
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> ContractList =(List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>.class); 
                    if(ContractList.size()>0){
                        Check_NewContractVFinalset.add(att.ASI_CRM_Contract__c);
                        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator CurrentContractVFinal= ContractList[0];
                        NewContactVFinal= FIConsolidation(NewContactVFinal,CurrentContractVFinal);
                        system.debug('CurrentContractVFinal Volumes: '+CurrentContractVFinal.Volumes);
                        
                        if(CurrentContractVFinal.AddOnString!=''){
                            Map<String,Decimal> TempMap = (Map<String,Decimal>)System.JSON.deserialize(CurrentContractVFinal.AddOnString,Map<String,Decimal>.class);
                            if( TempMap.containsKey('TotalBC_prorate')  ){//TotalBC
                                Total_BC+= TempMap.get('TotalBC_prorate');
                            }
                            if( TempMap.containsKey('TotalBlackCap_prorate')  ){//TotalBackCap
                                Total_BackCap+= TempMap.get('TotalBlackCap_prorate');
                            }
                            if( TempMap.containsKey('Total_IntakeBtl_prorate')  ){//Total_IntakeBtl
                                Total_IntakeBtl+= TempMap.get('Total_IntakeBtl_prorate');
                            }
                            
                            if( TempMap.containsKey('Total_MartellBC')  ){//Total Martell BC
                                Total_BC_Martell+= TempMap.get('Total_MartellBC');
                            }
                            if( TempMap.containsKey('Total_MartellIntakeBtl')  ){//Total Martell BackCap
                                Total_IntakeBtl_Martell+= TempMap.get('Total_MartellIntakeBtl');
                            }
                            if( TempMap.containsKey('Total_MartellBlackCap')  ){//Total Martell Intake Btl
                                Total_BackCap_Martell+= TempMap.get('Total_MartellBlackCap');
                            }
                            
                            
                        }
                    }
                }
                
            }
            
        }
        
        //Calculate Historical and new contract vFinal Total BC Rate and Net BC Rate
        
        if(TotalHC_IntakeBtl!=0){
            HistoricalVFinalTotalBCRate=(TotalHC_BC/TotalHC_IntakeBtl)*100;
            HistoricalVFinalNetBCRate=((TotalHC_BC-TotalHC_BackCap)/TotalHC_IntakeBtl)*100;
        }
        
        
        if(Total_IntakeBtl!=0){
            NewContractVFinalTotalBCRate=(Total_BC/Total_IntakeBtl)*100;
            NewContractVFinalNetBCRate=((Total_BC-Total_BackCap)/Total_IntakeBtl)*100;
        }
        
        
        if(TotalHC_IntakeBtl!=0 && TotalHC_IntakeBtl_Martell!=0){
            Hist_VFinalTotalMarBCRate=(TotalHC_BC_Martell/TotalHC_IntakeBtl_Martell)*100;
            Hist_VFinalNetMarBCRate=((TotalHC_BC_Martell-TotalHC_BackCap_Martell)/TotalHC_IntakeBtl_Martell)*100;
        }
        
        
        if(Total_IntakeBtl!=0 && Total_IntakeBtl_Martell!=0){
            New_VFinalTotalMartellBCRate=(Total_BC_Martell/Total_IntakeBtl_Martell)*100;
            New_VFinalNetMartellBCRate=((Total_BC_Martell-Total_BackCap_Martell)/Total_IntakeBtl_Martell)*100;
        }
        
        
        
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:[SELECT Id, ASI_CRM_Max_Incentive__c,ASI_CRM_Module__r.ASI_CRM_Volume_Base__c, ASI_CRM_Contract_Total_QTY_std_Btl__c,ASI_CRM_Est_Total_QTY_std_Btl__c,ASI_CRM_Contract_Total_QTY_CR12_Eqv__c,ASI_CRM_Est_Total_QTY_CR12_Eqv__c,ASI_CRM_Module__c,ASI_CRM_Module__r.ASI_CRM_Methodology__r.Name,  ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Product_Category__c , ASI_CRM_Volume_Base__c , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                WHERE ASI_CRM_CN_Contract__c!=null and (ASI_CRM_CN_Contract__c in :NewContractV00set or ASI_CRM_CN_Contract__c in :NewContractVFinalset) ] )
        {
            IF(ContractLine.ASI_CRM_Type__c=='PSF'){
                if(NewContractV00set.contains(ContractLine.ASI_CRM_CN_Contract__c)){
                    PSFDetailTotal.ContractTotalFees +=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c !=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c : 0;
                    PSFDetailTotal.EstimateTotalFees+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                }
                if(NewContractVFinalset.contains(ContractLine.ASI_CRM_CN_Contract__c)){
                    PSFDetailTotal.VFinalTotalFees +=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c !=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c : 0;
                } 
            }
            
            if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                if(NewContractV00set.contains(ContractLine.ASI_CRM_CN_Contract__c)){
                    VECDetailTotal.ContractTotalFees +=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c !=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c : 0;
                    VECDetailTotal.EstimateTotalFees+=ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c : 0;
                }
                
                if(NewContractVFinalset.contains(ContractLine.ASI_CRM_CN_Contract__c)){
                    VECDetailTotal.VFinalTotalFees +=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c !=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c : 0;
                }
                
            }
            
        }
        
        
        //Looping the Real contract
        for(ASI_TH_CRM_Contract__c RealContract:[select Id,Name,ASI_CRM_CN_Outlet_WS__c,ASI_CRM_CN_Outlet_WS__r.Name,ASI_CRM_CN_PO_No__c from ASI_TH_CRM_Contract__c where id in:AllContractIdSet and ASI_CRM_CN_Outlet_WS__c!=null]){
            if(SummaryContractMap.containsKey(RealContract.Id)){
                SummaryContractMap.get(RealContract.Id).CurrentContract = RealContract ;
            }
            if(HistoricalContractset.contains(RealContract.Id)){
                HistoricalContractOutletset.add(RealContract.ASI_CRM_CN_Outlet_WS__c);
            }
            if(NewContractV00set.contains(RealContract.Id)){
                NewContractV00Outletset.add(RealContract.ASI_CRM_CN_Outlet_WS__c);
            }
            if(NewContractVFinalset.contains(RealContract.Id)){
                NewContractVFinalOutletset.add(RealContract.ASI_CRM_CN_Outlet_WS__c);
            }
        }
        
        
        for(ASI_CRM_CN_Covered_Outlet__c CoveredOutlet:[SELECT id, ASI_CRM_CN_Contract__c,ASI_CRM_CN_Outlet__c FROM ASI_CRM_CN_Covered_Outlet__c   WHERE ASI_CRM_CN_Contract__c in:AllContractIdSet and ASI_CRM_CN_Outlet__c!=null ]){
            if(HistoricalContractset.contains(CoveredOutlet.ASI_CRM_CN_Contract__c)){
                HistoricalContractOutletset.add(CoveredOutlet.ASI_CRM_CN_Outlet__c);
            }
            if(NewContractV00set.contains(CoveredOutlet.ASI_CRM_CN_Contract__c)){
                NewContractV00Outletset.add(CoveredOutlet.ASI_CRM_CN_Outlet__c);
            }
            if(NewContractVFinalset.contains(CoveredOutlet.ASI_CRM_CN_Contract__c)){
                NewContractVFinalOutletset.add(CoveredOutlet.ASI_CRM_CN_Outlet__c);
            }
        }
        
        HistoricalCoveredOutletSize=HistoricalContractOutletset.size();
        V0CoveredOutletSize=NewContractV00Outletset.size();
        VFinalCoveredOutletSize=NewContractVFinalOutletset.size();
        
    }
    
    
    
    
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator FIConsolidation(ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator CurrentFIData,ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator RawFIData){
        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator TempFIData = CurrentFIData;
        //Volumes 销量 (in 9L cs)
        TempFIData.Volumes+=RawFIData.Volumes!=null?RawFIData.Volumes:0;
        //Trade expenses 销售费用
        TempFIData.TradeExpenses+=RawFIData.TradeExpenses!=null?RawFIData.TradeExpenses:0;
        
        //Gross Sales Total
        SYSTEM.debug('GrossSalesTotal   : '+RawFIData.GrossSalesTotal);
        TempFIData.GrossSalesTotal +=RawFIData.GrossSalesTotal!=null?RawFIData.GrossSalesTotal:0;
        //Investment CR12
        TempFIData.IntakeCR12 +=RawFIData.IntakeCR12!=null?RawFIData.IntakeCR12:0;
        
        //Variable expense 变动费用
        TempFIData.VariableExpense +=RawFIData.VariableExpense!=null?RawFIData.VariableExpense:0;
        
        //Fixed Expense 固定费用
        TempFIData.FixedExpense +=RawFIData.FixedExpense!=null?RawFIData.FixedExpense:0;
        TempFIData.CMTotal +=RawFIData.CMTotal!=null?RawFIData.CMTotal:0;
        TempFIData.IntakeSTD +=RawFIData.IntakeSTD!=null?RawFIData.IntakeSTD:0;
        TempFIData.LatestBudgetCMTotal+=RawFIData.LatestBudgetCMTotal!=null?RawFIData.LatestBudgetCMTotal:0;
        
        if(CurrentFIData.ContractLineMap.size()>0){
            TempFIData.ContractLineMap=CurrentFIData.ContractLineMap;
        }else{
            TempFIData.ContractLineMap=new Map<String, ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine>();
        }
        
        //Bottles / month ---> adding all Bottles calculated of real PO
        //Historical 'Est. BRSF'(Fees/Month 单瓶费用)= Total Amount / Total Volume all period
        for(String ContractLineKey:RawFIData.ContractLineMap.keySet()){
            if(TempFIData.ContractLineMap.containsKey(ContractLineKey)){
                TempFIData.ContractLineMap.get(ContractLineKey).HistoricalBottles+=RawFIData.ContractLineMap.get(ContractLineKey).HistoricalBottles;
                TempFIData.ContractLineMap.get(ContractLineKey).EstimateBottles+=RawFIData.ContractLineMap.get(ContractLineKey).EstimateBottles;
                TempFIData.ContractLineMap.get(ContractLineKey).ContractBottles+=RawFIData.ContractLineMap.get(ContractLineKey).ContractBottles;
                TempFIData.ContractLineMap.get(ContractLineKey).VFinalBottles+=RawFIData.ContractLineMap.get(ContractLineKey).VFinalBottles;
                
                TempFIData.ContractLineMap.get(ContractLineKey).HistoricalVolume+=RawFIData.ContractLineMap.get(ContractLineKey).HistoricalVolume;
                TempFIData.ContractLineMap.get(ContractLineKey).EstimateVolume+=RawFIData.ContractLineMap.get(ContractLineKey).EstimateVolume;
                TempFIData.ContractLineMap.get(ContractLineKey).ContractVolume+=RawFIData.ContractLineMap.get(ContractLineKey).ContractVolume;
                TempFIData.ContractLineMap.get(ContractLineKey).VFinalVolume+=RawFIData.ContractLineMap.get(ContractLineKey).VFinalVolume;
                
                TempFIData.ContractLineMap.get(ContractLineKey).HistoricalTotalFees+=RawFIData.ContractLineMap.get(ContractLineKey).HistoricalTotalFees;
                TempFIData.ContractLineMap.get(ContractLineKey).EstimateTotalFees+=RawFIData.ContractLineMap.get(ContractLineKey).EstimateTotalFees;
                TempFIData.ContractLineMap.get(ContractLineKey).ContractTotalFees+=RawFIData.ContractLineMap.get(ContractLineKey).ContractTotalFees;
                TempFIData.ContractLineMap.get(ContractLineKey).VFinalTotalFees+=RawFIData.ContractLineMap.get(ContractLineKey).VFinalTotalFees;
                
                TempFIData.ContractLineMap.get(ContractLineKey).HistoricalActualVolume+=RawFIData.ContractLineMap.get(ContractLineKey).HistoricalActualVolume;
                TempFIData.ContractLineMap.get(ContractLineKey).VFinalActualVolume+=RawFIData.ContractLineMap.get(ContractLineKey).VFinalActualVolume;
                
            }else{
                TempFIData.ContractLineMap.put(ContractLineKey, RawFIData.ContractLineMap.get(ContractLineKey));
            }
        }
        
        
        
        
        for(String SBGName: sbGroup_map.keySet()){//CurrentFIData
            if( (RawFIData.SubBrandGradeMap==null || !RawFIData.SubBrandGradeMap.containskey(SBGName) ) && (TempFIData.SubBrandGradeMap==null || !TempFIData.SubBrandGradeMap.containskey(SBGName)) ){
                TempFIData.SubBrandGradeMap.put(SBGName,0.0);  
            }else if( RawFIData.SubBrandGradeMap!=null && RawFIData.SubBrandGradeMap.containskey(SBGName) && (TempFIData.SubBrandGradeMap==null || !TempFIData.SubBrandGradeMap.containskey(SBGName) ) ){
                TempFIData.SubBrandGradeMap.put(SBGName,RawFIData.SubBrandGradeMap.get(SBGName));  
            }else if ( RawFIData.SubBrandGradeMap!=null && RawFIData.SubBrandGradeMap.containskey(SBGName) && TempFIData.SubBrandGradeMap!=null && TempFIData.SubBrandGradeMap.containskey(SBGName) )  {
                Decimal SubBrandVolume = RawFIData.SubBrandGradeMap.get(SBGName) + TempFIData.SubBrandGradeMap.get(SBGName);
                TempFIData.SubBrandGradeMap.remove(SBGName);
                TempFIData.SubBrandGradeMap.put(SBGName,SubBrandVolume ); 
            }
            
            
        }
        
        
        return TempFIData;
    }//*********************Finished FIConsolidation *********************
    
    
    
    
    
    
    
    
    
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator InitData(ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator InputFIData){
        
        for(String SBGName: sbGroup_map.keySet()){
            InputFIData.SubBrandGradeMap.put(SBGName,0.0);  
        }
        
        return InputFIData;
    }
    
    
    
    
    //Sub-Brand Data 
    public void DataReconstruct(){
        SubBrandContractMap = new Map<String, ASI_CRM_CN_HeavyContractUtilitiesClass.ContractLine>(NewContactV0Contract.ContractLineMap);
        //Historical VFinal Contract FI Data 
        for(String ContractLineKey:HistoricalVFinalContract.ContractLineMap.keySet()){
            if(SubBrandContractMap.containsKey(ContractLineKey)){
                SubBrandContractMap.get(ContractLineKey).HistoricalBottles+=HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalBottles;
                SubBrandContractMap.get(ContractLineKey).HistoricalFees += HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalFees;
                SubBrandContractMap.get(ContractLineKey).HistoricalTotalFees += HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalTotalFees;
                SubBrandContractMap.get(ContractLineKey).HistoricalVolume += HistoricalVFinalContract.ContractLineMap.get(ContractLineKey).HistoricalVolume;
            }else{
                SubBrandContractMap.put(ContractLineKey, HistoricalVFinalContract.ContractLineMap.get(ContractLineKey));
            }
        }
        
        //New Contract VFinal  FI Data 
        for(String ContractLineKey:NewContactVFinal.ContractLineMap.keySet()){
            if(SubBrandContractMap.containsKey(ContractLineKey)){
                SubBrandContractMap.get(ContractLineKey).VFinalBottles+=NewContactVFinal.ContractLineMap.get(ContractLineKey).VFinalBottles;
                SubBrandContractMap.get(ContractLineKey).VFinalActualVolume += NewContactVFinal.ContractLineMap.get(ContractLineKey).VFinalActualVolume;
                SubBrandContractMap.get(ContractLineKey).VFinalTotalFees += NewContactVFinal.ContractLineMap.get(ContractLineKey).VFinalTotalFees;
                SubBrandContractMap.get(ContractLineKey).VFinalVolume += NewContactVFinal.ContractLineMap.get(ContractLineKey).VFinalVolume;
                
            }else{
                SubBrandContractMap.put(ContractLineKey, NewContactVFinal.ContractLineMap.get(ContractLineKey));
            }
        }
        
        //Looping SubBrandContractMap to calculate 'Fees / month'
        for(String SubBrandContractKey:SubBrandContractMap.keySet()){
            if(SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume !=null && SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume !=0 ){
                SubBrandContractMap.get(SubBrandContractKey).HistoricalFees = SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees / SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume ;
            }else{
                SubBrandContractMap.get(SubBrandContractKey).HistoricalFees =0;
            }
            
            if(SubBrandContractMap.get(SubBrandContractKey).EstimateVolume !=null && SubBrandContractMap.get(SubBrandContractKey).EstimateVolume !=0 ){
                SubBrandContractMap.get(SubBrandContractKey).EstimateFees = SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees / SubBrandContractMap.get(SubBrandContractKey).EstimateVolume ;
            }else{
                SubBrandContractMap.get(SubBrandContractKey).EstimateFees =0;
            }
            
            
            if(SubBrandContractMap.get(SubBrandContractKey).ContractVolume !=null && SubBrandContractMap.get(SubBrandContractKey).ContractVolume !=0 ){
                SubBrandContractMap.get(SubBrandContractKey).ContractFees = SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees / SubBrandContractMap.get(SubBrandContractKey).ContractVolume ;
            }else{
                SubBrandContractMap.get(SubBrandContractKey).ContractFees =0;
            }
            
            if(SubBrandContractMap.get(SubBrandContractKey).VFinalVolume !=null && SubBrandContractMap.get(SubBrandContractKey).VFinalVolume !=0 ){
                system.debug('VFinalTotalFees : '+  SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees );
                system.debug('VFinalVolume : '+  SubBrandContractMap.get(SubBrandContractKey).VFinalVolume );
                SubBrandContractMap.get(SubBrandContractKey).VFinalFees = SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees / SubBrandContractMap.get(SubBrandContractKey).VFinalVolume ;
            }else{
                SubBrandContractMap.get(SubBrandContractKey).VFinalFees =0;
            }
            
            
            if(SubBrandContractMap.get(SubBrandContractKey).HistoricalFees !=null &&  SubBrandContractMap.get(SubBrandContractKey).HistoricalActualVolume!=null ){
                SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees= SubBrandContractMap.get(SubBrandContractKey).HistoricalFees * SubBrandContractMap.get(SubBrandContractKey).HistoricalActualVolume;
            }
            if(SubBrandContractMap.get(SubBrandContractKey).VFinalFees !=null && SubBrandContractMap.get(SubBrandContractKey).VFinalActualVolume !=null ){
                 system.debug('VFinalFees : '+  SubBrandContractMap.get(SubBrandContractKey).VFinalFees );
                 system.debug('VFinalActualVolume : '+  SubBrandContractMap.get(SubBrandContractKey).VFinalActualVolume );
                SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees=SubBrandContractMap.get(SubBrandContractKey).VFinalFees  * SubBrandContractMap.get(SubBrandContractKey).VFinalActualVolume;
                
            }
            
        }
        
        
        Decimal Sum_HistoricalTotalFees=0;
        Decimal Sum_EstimateTotalFees=0;
        Decimal Sum_ContractTotalFees=0;
        Decimal Sum_vFinalTotalFees=0;
        
        
        //Fix rounding case
        for(String SubBrandContractKey:SubBrandContractMap.keySet()){
            
            SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles=DecimalRounding(SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles);
            SubBrandContractMap.get(SubBrandContractKey).HistoricalFees=DecimalRounding(SubBrandContractMap.get(SubBrandContractKey).HistoricalFees);
            
            SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees=DecimalRounding(SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees);
            
            
            SubBrandContractMap.get(SubBrandContractKey).VFinalFees=DecimalRounding(SubBrandContractMap.get(SubBrandContractKey).VFinalFees);
            
            
            SubBrandContractMap.get(SubBrandContractKey).EstimateBottles=Math.floor(SubBrandContractMap.get(SubBrandContractKey).EstimateBottles);
            SubBrandContractMap.get(SubBrandContractKey).EstimateFees=Math.floor(SubBrandContractMap.get(SubBrandContractKey).EstimateFees);
            SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees=Math.floor(SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees);
            
            
            
            SubBrandContractMap.get(SubBrandContractKey).ContractBottles=Math.floor(SubBrandContractMap.get(SubBrandContractKey).ContractBottles);
            SubBrandContractMap.get(SubBrandContractKey).ContractFees=Math.floor(SubBrandContractMap.get(SubBrandContractKey).ContractFees);
            SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees=Math.floor(SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees);
            
            
            SubBrandContractMap.get(SubBrandContractKey).VFinalBottles=Math.floor(SubBrandContractMap.get(SubBrandContractKey).VFinalBottles);
            SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees=Math.floor(SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees);
            
            
            
            
            
            
            
            if(SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles==0 && SubBrandContractMap.get(SubBrandContractKey).EstimateBottles==0 && SubBrandContractMap.get(SubBrandContractKey).ContractBottles ==0 && SubBrandContractMap.get(SubBrandContractKey).VFinalBottles==0
               && SubBrandContractMap.get(SubBrandContractKey).HistoricalFees ==0 && SubBrandContractMap.get(SubBrandContractKey).EstimateFees==0 && SubBrandContractMap.get(SubBrandContractKey).ContractFees ==0 && SubBrandContractMap.get(SubBrandContractKey).VFinalFees==0
               && SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees==0 && SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees==0 && SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees==0 && SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees==0 )
            {
                SubBrandContractMap.remove(SubBrandContractKey);
            }else{
                integer intlength = SubBrandContractMap.get(SubBrandContractKey).SubBrandName.length();
                if(intlength >= 4 && SubBrandContractMap.get(SubBrandContractKey).SubBrandName.contains('-')){
                    SubBrandContractMap.get(SubBrandContractKey).strSubBrand =  SubBrandContractMap.get(SubBrandContractKey).SubBrandName.substring(0, (intlength-4));
                }
                
                
                SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles =SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles!=null? SubBrandContractMap.get(SubBrandContractKey).HistoricalBottles.setScale(0, RoundingMode.HALF_UP):0;
                system.debug(' VFinalBottles : '+SubBrandContractMap.get(SubBrandContractKey).VFinalBottles );
                SubBrandContractMap.get(SubBrandContractKey).VFinalBottles =SubBrandContractMap.get(SubBrandContractKey).VFinalBottles!=null? SubBrandContractMap.get(SubBrandContractKey).VFinalBottles.setScale(0, RoundingMode.HALF_UP):0;
                
                
                //calculate Fees / month
                if(SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume!=0 && SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees !=null){
                    SubBrandContractMap.get(SubBrandContractKey).HistoricalFees= NumberRounding(SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees/SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume);
                }
                
                if(SubBrandContractMap.get(SubBrandContractKey).EstimateVolume!=0 && SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees !=null){
                    SubBrandContractMap.get(SubBrandContractKey).EstimateFees= NumberRounding(SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees/SubBrandContractMap.get(SubBrandContractKey).EstimateVolume);
                }
                
                if(SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume!=0 && SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees !=null){
                    SubBrandContractMap.get(SubBrandContractKey).ContractFees= NumberRounding(SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees/SubBrandContractMap.get(SubBrandContractKey).HistoricalVolume);
                }
                
                //if(SubBrandContractMap.get(SubBrandContractKey).VFinalVolume!=0 && SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees !=null){
                //SubBrandContractMap.get(SubBrandContractKey).VFinalFees= NumberRounding(SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees/SubBrandContractMap.get(SubBrandContractKey).VFinalVolume);
                //}
                //Calculate Sum                 
                Sum_HistoricalTotalFees+=SubBrandContractMap.get(SubBrandContractKey).HistoricalTotalFees;
                Sum_EstimateTotalFees +=SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees!=null?SubBrandContractMap.get(SubBrandContractKey).EstimateTotalFees:0;
                Sum_ContractTotalFees +=SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees!=null? SubBrandContractMap.get(SubBrandContractKey).ContractTotalFees:0;
                Sum_vFinalTotalFees +=SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees!=null? SubBrandContractMap.get(SubBrandContractKey).VFinalTotalFees:0;
                
            }
        }
        
        
        
        
        //AdjustmentRecognition
        AdjustmentRecognition.HistoricalTotalFees= -(HistoricalVFinalContract.VariableExpense-PSFDetailTotal.HistoricalTotalFees-VECDetailTotal.HistoricalTotalFees-Sum_HistoricalTotalFees);
        AdjustmentRecognition.EstimateTotalFees=-(NewContractV0Esitimate.VariableExpense-PSFDetailTotal.EstimateTotalFees-VECDetailTotal.EstimateTotalFees-Sum_EstimateTotalFees);
        AdjustmentRecognition.ContractTotalFees=-(NewContactV0Contract.VariableExpense-PSFDetailTotal.ContractTotalFees-VECDetailTotal.ContractTotalFees-Sum_ContractTotalFees);
        AdjustmentRecognition.VFinalTotalFees=-(NewContactVFinal.VariableExpense-PSFDetailTotal.VFinalTotalFees-VECDetailTotal.VFinalTotalFees-Sum_vFinalTotalFees);
        
        if(AdjustmentRecognition.HistoricalTotalFees!=0 || AdjustmentRecognition.ContractTotalFees!=0 || AdjustmentRecognition.EstimateTotalFees!=0 ||  AdjustmentRecognition.VFinalTotalFees!=0){
            ShowAchievementRecognition=true;
        }
        
    }
    
    
    
    public Decimal NumberRounding(Decimal InputNumber){
        Decimal ResultValue =0;
        if(InputNumber!=null){
            ResultValue = InputNumber.round();
        }else{
            ResultValue=0;
        }
        
        if(math.abs(InputNumber-ResultValue)==0.5){
            ResultValue= ResultValue+ 1;
            
        }
        system.debug(ResultValue);
        
        return ResultValue;
    }
    
    
    
    
    public Decimal DecimalRounding(Decimal InputNumber){
        if(InputNumber!=null){
            if(InputNumber<1 && InputNumber>0){
                InputNumber=0; 
            }
        }
        
        return InputNumber;
    }
    
    
    
    public void DataConsolidation(){
        //Gross Sales Rate
        if (HistoricalV00Contract.GrossSalesTotal  != null && HistoricalV00Contract.GrossSalesTotal  != 0 && HistoricalV00Contract.TradeExpenses!= 0 && HistoricalV00Contract.TradeExpenses != null){
            HistoricalV00Contract.GrossSalesRate = (HistoricalV00Contract.TradeExpenses / HistoricalV00Contract.GrossSalesTotal  *100).SetSCale(2);
        }
        if (HistoricalVFinalContract.GrossSalesTotal  != null && HistoricalVFinalContract.GrossSalesTotal  != 0 && HistoricalVFinalContract.TradeExpenses!= 0 && HistoricalVFinalContract.TradeExpenses != null){
            HistoricalVFinalContract.GrossSalesRate = (HistoricalVFinalContract.TradeExpenses / HistoricalVFinalContract.GrossSalesTotal  *100).SetSCale(2);
        }
        
       
        
        system.debug('**************debug0.1 **************');
        system.debug(NewContractV0Esitimate.TradeExpenses);
        system.debug(NewContractV0Esitimate.GrossSalesTotal);
        
        if (NewContractV0Esitimate.GrossSalesTotal  != null && NewContractV0Esitimate.GrossSalesTotal  != 0 && NewContractV0Esitimate.TradeExpenses!= 0 && NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.GrossSalesRate = (NewContractV0Esitimate.TradeExpenses / NewContractV0Esitimate.GrossSalesTotal  *100).SetSCale(2);
        }
        if (NewContactV0Contract.GrossSalesTotal  != null && NewContactV0Contract.GrossSalesTotal  != 0 && NewContactV0Contract.TradeExpenses!= 0 && NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.GrossSalesRate = (NewContactV0Contract.TradeExpenses / NewContactV0Contract.GrossSalesTotal  *100).SetSCale(2);
        }
        if (NewContactVFinal.GrossSalesTotal  != null && NewContactVFinal.GrossSalesTotal  != 0 && NewContactVFinal.TradeExpenses!= 0 && NewContactVFinal.TradeExpenses != null){
            NewContactVFinal.GrossSalesRate = (NewContactVFinal.TradeExpenses / NewContactVFinal.GrossSalesTotal  *100).SetSCale(2);
        }
        
        
        //InvestmentCR12
        if (HistoricalV00Contract.IntakeCR12 != 0 && HistoricalV00Contract.IntakeCR12!= null &&  HistoricalV00Contract.TradeExpenses != 0 &&  HistoricalV00Contract.TradeExpenses != null){
            HistoricalV00Contract.InvestmentCR12 =  (HistoricalV00Contract.TradeExpenses / HistoricalV00Contract.IntakeCR12).SetSCale(2);
        }
        if (HistoricalVFinalContract.IntakeCR12 != 0 && HistoricalVFinalContract.IntakeCR12!= null &&  HistoricalVFinalContract.TradeExpenses != 0 &&  HistoricalVFinalContract.TradeExpenses != null){
            HistoricalVFinalContract.InvestmentCR12 =  (HistoricalVFinalContract.TradeExpenses / HistoricalVFinalContract.IntakeCR12).SetSCale(2);
        }
        if (NewContractV0Esitimate.IntakeCR12 != 0 && NewContractV0Esitimate.IntakeCR12!= null &&  NewContractV0Esitimate.TradeExpenses != 0 &&  NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.InvestmentCR12 =  (NewContractV0Esitimate.TradeExpenses / NewContractV0Esitimate.IntakeCR12).SetSCale(2);
        }
        if (NewContactV0Contract.IntakeCR12 != 0 && NewContactV0Contract.IntakeCR12!= null &&  NewContactV0Contract.TradeExpenses != 0 &&  NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.InvestmentCR12 =  (NewContactV0Contract.TradeExpenses / NewContactV0Contract.IntakeCR12).SetSCale(2);
        }
        if (NewContactVFinal.IntakeCR12 != 0 && NewContactVFinal.IntakeCR12!= null &&  NewContactVFinal.TradeExpenses != 0 &&  NewContactVFinal.TradeExpenses != null){
            NewContactVFinal.InvestmentCR12 =  (NewContactVFinal.TradeExpenses / NewContactVFinal.IntakeCR12).SetSCale(2);
        }
        
        //Fix Expense Rate
        if(HistoricalV00Contract.TradeExpenses !=0 && HistoricalV00Contract.TradeExpenses !=null && HistoricalV00Contract.FixedExpense!=null ){
            HistoricalV00Contract.FixedExpenseRate = (HistoricalV00Contract.FixedExpense / HistoricalV00Contract.TradeExpenses *100).SetSCale(2);  
        }
        if(HistoricalVFinalContract.TradeExpenses !=0 && HistoricalVFinalContract.TradeExpenses !=null && HistoricalVFinalContract.FixedExpense!=null ){
            HistoricalVFinalContract.FixedExpenseRate = (HistoricalVFinalContract.FixedExpense / HistoricalVFinalContract.TradeExpenses *100).SetSCale(2);  
        }        
        if(NewContractV0Esitimate.TradeExpenses !=0 && NewContractV0Esitimate.TradeExpenses !=null && NewContractV0Esitimate.FixedExpense!=null ){
            NewContractV0Esitimate.FixedExpenseRate = (NewContractV0Esitimate.FixedExpense / NewContractV0Esitimate.TradeExpenses *100).SetSCale(2);  
        }
        if(NewContactV0Contract.TradeExpenses !=0 && NewContactV0Contract.TradeExpenses !=null && NewContactV0Contract.FixedExpense!=null ){
            NewContactV0Contract.FixedExpenseRate = (NewContactV0Contract.FixedExpense / NewContactV0Contract.TradeExpenses *100).SetSCale(2);  
        }
        if(NewContactVFinal.TradeExpenses !=0 && NewContactVFinal.TradeExpenses !=null && NewContactVFinal.FixedExpense!=null ){
            NewContactVFinal.FixedExpenseRate = (NewContactVFinal.FixedExpense / NewContactVFinal.TradeExpenses *100).SetSCale(2);  
        }        
        
        
        //MarginAfterAnP
        if (HistoricalV00Contract.CMTotal != null && HistoricalV00Contract.TradeExpenses != null){
            HistoricalV00Contract.MarginAfterAnP = HistoricalV00Contract.CMTotal - HistoricalV00Contract.TradeExpenses;
        }
        if (HistoricalVFinalContract.CMTotal != null && HistoricalVFinalContract.TradeExpenses != null){
            HistoricalVFinalContract.MarginAfterAnP = HistoricalVFinalContract.CMTotal - HistoricalVFinalContract.TradeExpenses;
        }
        if (NewContractV0Esitimate.CMTotal != null && NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.MarginAfterAnP = NewContractV0Esitimate.CMTotal - NewContractV0Esitimate.TradeExpenses;
        }
        if (NewContactV0Contract.CMTotal != null && NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.MarginAfterAnP = NewContactV0Contract.CMTotal - NewContactV0Contract.TradeExpenses;
        }
        if (NewContactVFinal.CMTotal != null && NewContactVFinal.TradeExpenses != null){
            NewContactVFinal.MarginAfterAnP = NewContactVFinal.CMTotal - NewContactVFinal.TradeExpenses;
        }
        
        
        
        
        //MarginPerBottle
        if (HistoricalV00Contract.IntakeSTD!= 0 && HistoricalV00Contract.IntakeSTD != null && HistoricalV00Contract.MarginAfterAnP != 0 && HistoricalV00Contract.MarginAfterAnP != null){
            HistoricalV00Contract.MarginPerBottle = (HistoricalV00Contract.MarginAfterAnP / HistoricalV00Contract.IntakeSTD).SetSCale(2);
        }
        if (HistoricalVFinalContract.IntakeSTD!= 0 && HistoricalVFinalContract.IntakeSTD != null && HistoricalVFinalContract.MarginAfterAnP != 0 && HistoricalVFinalContract.MarginAfterAnP != null){
            HistoricalVFinalContract.MarginPerBottle = (HistoricalVFinalContract.MarginAfterAnP / HistoricalVFinalContract.IntakeSTD).SetSCale(2);
        }
        if (NewContractV0Esitimate.IntakeSTD!= 0 && NewContractV0Esitimate.IntakeSTD != null && NewContractV0Esitimate.MarginAfterAnP != 0 && NewContractV0Esitimate.MarginAfterAnP != null){
            NewContractV0Esitimate.MarginPerBottle = (NewContractV0Esitimate.MarginAfterAnP / NewContractV0Esitimate.IntakeSTD).SetSCale(2);
        }
        if (NewContactV0Contract.IntakeSTD!= 0 && NewContactV0Contract.IntakeSTD != null && NewContactV0Contract.MarginAfterAnP != 0 && NewContactV0Contract.MarginAfterAnP != null){
            NewContactV0Contract.MarginPerBottle = (NewContactV0Contract.MarginAfterAnP / NewContactV0Contract.IntakeSTD).SetSCale(2);
        }
        if (NewContactVFinal.IntakeSTD!= 0 && NewContactVFinal.IntakeSTD != null && NewContactVFinal.MarginAfterAnP != 0 && NewContactVFinal.MarginAfterAnP != null){
            NewContactVFinal.MarginPerBottle = (NewContactVFinal.MarginAfterAnP / NewContactVFinal.IntakeSTD).SetSCale(2);
        }
        
        
        
        //ROI Intake
        if (HistoricalV00Contract.CMTotal != null && HistoricalV00Contract.CMTotal != 0 && HistoricalV00Contract.TradeExpenses != 0 && HistoricalV00Contract.TradeExpenses != null){
            HistoricalV00Contract.ROIIntake = HistoricalV00Contract.CMTotal / HistoricalV00Contract.TradeExpenses;
        }
        if (HistoricalVFinalContract.CMTotal != null && HistoricalVFinalContract.CMTotal != 0 && HistoricalVFinalContract.TradeExpenses != 0 && HistoricalVFinalContract.TradeExpenses != null){
            HistoricalVFinalContract.ROIIntake = HistoricalVFinalContract.CMTotal / HistoricalVFinalContract.TradeExpenses;
        }
        if (NewContractV0Esitimate.CMTotal != null && NewContractV0Esitimate.CMTotal != 0 && NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses != null){
            NewContractV0Esitimate.ROIIntake = NewContractV0Esitimate.CMTotal / NewContractV0Esitimate.TradeExpenses;
        }
        if (NewContactV0Contract.CMTotal != null && NewContactV0Contract.CMTotal != 0 && NewContactV0Contract.TradeExpenses != 0 && NewContactV0Contract.TradeExpenses != null){
            NewContactV0Contract.ROIIntake = NewContactV0Contract.CMTotal / NewContactV0Contract.TradeExpenses;
        }
        if (NewContactVFinal.CMTotal != null && NewContactVFinal.CMTotal != 0 && NewContactVFinal.TradeExpenses != 0 && NewContactVFinal.TradeExpenses != null){
            NewContactVFinal.ROIIntake = NewContactVFinal.CMTotal / NewContactVFinal.TradeExpenses;
        }
        
        
        //Calculate ROIProForma = Cont. Margin before A&P from latest CM regardless FY / Trade expenses 
        if (HistoricalV00Contract.LatestBudgetCMTotal!= null && HistoricalV00Contract.LatestBudgetCMTotal != 0 && HistoricalV00Contract.TradeExpenses != 0 && HistoricalV00Contract.TradeExpenses!= null){
            HistoricalV00Contract.ROIProForma = HistoricalV00Contract.LatestBudgetCMTotal/ HistoricalV00Contract.TradeExpenses;
        }
        if (HistoricalVFinalContract.LatestBudgetCMTotal!= null && HistoricalVFinalContract.LatestBudgetCMTotal != 0 && HistoricalVFinalContract.TradeExpenses != 0 && HistoricalVFinalContract.TradeExpenses!= null){
            HistoricalVFinalContract.ROIProForma = HistoricalVFinalContract.LatestBudgetCMTotal/ HistoricalVFinalContract.TradeExpenses;
        }
        if (NewContractV0Esitimate.LatestBudgetCMTotal!= null && NewContractV0Esitimate.LatestBudgetCMTotal != 0 && NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses!= null){
            NewContractV0Esitimate.ROIProForma = NewContractV0Esitimate.LatestBudgetCMTotal/ NewContractV0Esitimate.TradeExpenses;
        }
        if (NewContactV0Contract.LatestBudgetCMTotal!= null && NewContactV0Contract.LatestBudgetCMTotal != 0 && NewContactV0Contract.TradeExpenses != 0 && NewContactV0Contract.TradeExpenses!= null){
            NewContactV0Contract.ROIProForma = NewContactV0Contract.LatestBudgetCMTotal/ NewContactV0Contract.TradeExpenses;
        }
        if (NewContactVFinal.LatestBudgetCMTotal!= null && NewContactVFinal.LatestBudgetCMTotal != 0 && NewContactVFinal.TradeExpenses != 0 && NewContactVFinal.TradeExpenses!= null){
            NewContactVFinal.ROIProForma = NewContactVFinal.LatestBudgetCMTotal/ NewContactVFinal.TradeExpenses;
        }
    }
    
    
    public set<String> ListToSet(List<String>  InputList){
        set<String> ReturnSet = new set<String> ();
        for(string str: InputList){
            ReturnSet.add(str);
        }
        return ReturnSet;
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