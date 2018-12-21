/* Filename  :  ASI_CRM_CN_Heavy_PRForm_Cmpnt_Ctrl.cls
* Author     :  Laputa
* Purpose    :  Controller for Payment PDF 
* Study From :  ASI_CRM_CN_HeavyPaymentRequestForm
* Testing    :  
* History
* -----------------------------------------------------------------------------
* 2017-10-06   Laputa      Created

*/
public without sharing class ASI_CRM_CN_Heavy_PRForm_Cmpnt_Ctrl{
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public id HeaderId {set;get;}
    public string strPDF {set;get;}
    public ASI_TH_CRM_PaymentRequest__c thisPR {set;get;}
    public ASI_TH_CRM_Contract__c  ContractSelected {set;get;}{ContractSelected = new ASI_TH_CRM_Contract__c(); }
    public Decimal ContractBCRate {set;get;}{ContractBCRate=0;}
    
    public Decimal MartellBCRate {set;get;}{MartellBCRate=0;}
    
    
    public date CutOffDay {set;get;} //Pending Custom Setting follow for Sub Brand Volume 
    //AD or Above Identity checking
    public boolean AdorAbove {set;get;}
    public string UserId {set;get;}
    public list<ASI_CRM_CN_PH_Payee_Line_Item__c> PayeeList {set;get;}{PayeeList=new list<ASI_CRM_CN_PH_Payee_Line_Item__c>(); }
    public List<ASI_CRM_CN_HeavyContractUtilitiesClass.PaymentSummary> PaymentSummaryList {set;get;}{PaymentSummaryList = new List<ASI_CRM_CN_HeavyContractUtilitiesClass.PaymentSummary>();}
    public decimal Other_VOL_CR12 {set;get;} {Other_VOL_CR12 =0;}
    public decimal BRSF_CTD_CR12=0;// Total BRSF Volume all period 
    public decimal PaymentSpeed {set;get;}
    public decimal PaymentSpeedexcFixCost {set;get;}
    public date strStart;
    Public Decimal TotalPaymentAmount=0;
    //BA Comment
    public List<ASI_CRM_Approval_Comment__c> lstApprovalComment {set;get;}
    
    public Map<String, String> sbGroup_map {set;get;} {sbGroup_map = new Map<String, String>();}
    public Integer BRSFmonthsBetween   {set;get;} {BRSFmonthsBetween=1;}
    //BRSF
    public interimData BRSFItemMap {set;get;} {BRSFItemMap= new interimData();}
    //PSF
    public map<String, interimData> PSF_Item_Map {set;get;} {PSF_Item_Map= new map<String, interimData>();}
    
    public Map<String,VolumeObject> VolumeMap {set;get;} {VolumeMap= new Map<String,VolumeObject>(); }
    
    public map<string, string> SubbrandGroup {set;get;}{SubbrandGroup = new map<string, string>(); }
    public ASI_CRM_CN_Heavy_PRForm_Cmpnt_Ctrl(){}
    
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContractV0Esitimate  {set;get;} { NewContractV0Esitimate = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator NewContactV0Contract  {set;get;} { NewContactV0Contract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    public ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ActualPerformance  {set;get;} { ActualPerformance = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();}
    
    public map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data> v0_ROI_newMap  {set;get;} {v0_ROI_newMap=new map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data>();}
    public map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data> v1_ROI_newMap  {set;get;} {v1_ROI_newMap= new map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data>();}
    public Decimal TotalPaymentVariableAmount {set;get;} {TotalPaymentVariableAmount=0;}
    
    public map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal>();
    
    public Boolean DisplayBRSFPart {set;get;} {DisplayBRSFPart=false;}
    public Boolean DisplayPSFPart {set;get;} {DisplayPSFPart=false;}
    
    public ASI_CRM_CN_Heavy_PRForm_Cmpnt_Ctrl(ApexPages.StandardController controller) {
        
    }
    
    public boolean init(){
        if (HeaderId != null){
            thisPR = [SELECT Id, ASI_TH_CRM_Contract__c ,ASI_CRM_CN_Payment_Raised_Date__c,ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c,ASI_TH_CRM_Contract__r.ASI_CRM_Martell_BC_Rate__c,
                        ASI_TH_CRM_Contract__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Eng_Name__c, ASI_TH_CRM_Contract__r.ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Total_BRSF_Amount__c,
                      ASI_CRM_CN_Total_PSF_Amount__c, ASI_CRM_CN_Total_Other_Amount__c , ASI_CRM_CN_PO_Remain_Amount__c, ASI_TH_CRM_Contract__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_Payment__c, ASI_CRM_CN_PO_Version__c, 
                      ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.Name,ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,  ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c,
                      ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_Payment_Type__c, ASI_CRM_CN_Overpayment_Reason__c, ASI_CRM_CN_Other_Reason__c, ASI_CRM_CN_Description__c, ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_PO_End_Date__c,
                      ASI_TH_CRM_Contract__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PSF_End__c , ASI_CRM_CN_PSF_Start__c ,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name,
                      Owner.Name, ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c ,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,
                      ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c, ASI_CRM_CN_Promotion_Type__c,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Bottle_Collection_Rate__c,
                      ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.Name, ASI_TH_CRM_Total_Amount__c, ASI_CRM_CN_Currency__c,ASI_TH_CRM_Contract__r.ASI_CRM_CN_National_Group_Contract__c,
                      ASI_CRM_CN_BRSF_End_Date__c , ASI_CRM_CN_Adjustment__c, ASI_CRM_CN_BRSF_Start_Date__c, ASI_CRM_CN_Bottle_Collection_Rate__c,
                      ASI_CRM_CN_PO_No__c, ASI_CRM_CN_Region__c, ASI_CRM_CN_OutletWS__r.Name, name,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Group_Contract__r.Name,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Group_Contract__c,
                      ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,
                      ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c,
                      ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c,
                      ASI_CRM_CN_Total_Payment__c, ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c,
                      ASI_CRM_New_FY_Payment__c, ASI_TH_CRM_Contract__r.ASI_CRM_PO_Province__r.Name, ASI_TH_CRM_Contract__r.ASI_CRM_PO_Channel__r.Name ,ASI_TH_CRM_Contract__r.ASI_CRM_PO_City__c ,ASI_TH_CRM_Contract__r.ASI_CRM_PO_City__r.Name,ASI_TH_CRM_Contract__r.ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c , 
                      ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_NewChannel__c,ASI_TH_CRM_Contract__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name
                      FROM ASI_TH_CRM_PaymentRequest__c
                      WHERE id = :HeaderId];
            
            
        }
        InitVariable();
        if (thisPR != null){
            ContractSelected = [SELECT Id,Name, ASI_CRM_CN_Total_Contract_Amount__c , ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c, ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,   ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c ,ASI_CRM_CN_Expected_PSF_Est_Total__c, ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c              
                                FROM ASI_TH_CRM_Contract__c
                                WHERE id =:thisPR.ASI_TH_CRM_Contract__c ];
            
            try{
                PayeeList = [SELECT id, ASI_CRM_CN_Type__c, ASI_CRM_CN_Amount__c, ASI_CRM_CN_Payee_Name_T1__c, ASI_CRM_CN_Payee_Name_T2_lookup__c,ASI_CRM_CN_Payee_Name_T2_lookup__r.Name, ASI_CRM_CN_Payee_Name_T1__r.Name,ASI_CRM_CN_Cash_Payee_Name_T1__c, ASI_CRM_CN_Cash_Payee_Name_T1__r.Name,ASI_CRM_CN_Cash_Amount__c
                             FROM ASI_CRM_CN_PH_Payee_Line_Item__c WHERE ASI_CRM_CN_Payment_Request__c = :thisPR.id];
            }catch(exception e){
                PayeeList = new list<ASI_CRM_CN_PH_Payee_Line_Item__c>();
            }
            
            
            PaymentSummaryList = ASI_CRM_CN_HeavyContractUtilitiesClass.PaymentSummaryTable(thisPR,ContractSelected);
            
            List<integer> lstRemove = new List<integer>();
            Integer indexNum=0;
            integer c = 0;
            if (PaymentSummaryList != null && PaymentSummaryList.size() > 0){
                for(ASI_CRM_CN_HeavyContractUtilitiesClass.PaymentSummary displayLine:PaymentSummaryList){
                    if(displayLine.POEstimatedAmount==0 && displayLine.PaymentRequestAmount==0){
                        lstRemove.add(indexNum);
                    }
                    indexNum++;
                }        
                
                for(integer n : lstRemove){
                    if(n!=0){
                        if(c>0) 
                            n=n-c;
                        PaymentSummaryList.remove(n);
                        c++;
                    }else{
                        PaymentSummaryList.remove(0);
                        c++;
                    }
                }
            }
            

            
            
            //Will calculate Total Paid Amount and Variable Amount
            TotalPaymentAmount = RetrieveTotalPaidAmount();
            
            ActualPerformance.TradeExpenses=TotalPaymentAmount;
            ActualPerformance.VariableExpense+=TotalPaymentVariableAmount;
                
            Decimal V0FixCostAmount=CalculateV0FixCostAmount();
            
            Decimal V0ContractAmount =  CalculateV0ContractDetailCost();
            if (V0ContractAmount != null && V0ContractAmount !=0 && TotalPaymentVariableAmount != null && TotalPaymentVariableAmount != 0){
                system.debug('Now TotalPaymentVariableAmount:'+TotalPaymentVariableAmount);
                system.debug('Now V0ContractAmount:'+V0ContractAmount);
                PaymentSpeedexcFixCost = (TotalPaymentVariableAmount / V0ContractAmount) * 100; // No inculding Fix Cost
            }
            
            
             list<ASI_TH_CRM_PaymentRequestLineItem__c> PRLineItems = new list<ASI_TH_CRM_PaymentRequestLineItem__c>();
            try{
                //query All Payment Variable & Fixed Cost
                PRLineItems = [SELECT id, ASI_TH_CRM_Amount__c, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Total_Payable__c,ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c,
                               ASI_TH_CRM_Payment_Request__r.ASI_CRM_CN_Adjustment__c, RecordTypeId,RecordType.DeveloperName,ASI_CRM_Adjustment__c,
                               ASI_CRM_CN_Contract_Cost__r.ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Cost__c 
                               FROM ASI_TH_CRM_PaymentRequestLineItem__c WHERE ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c =:thisPR.ASI_TH_CRM_Contract__c and (ASI_TH_CRM_Payment_Request__c =:thisPR.id  
                                                                                                                                           OR ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Approved' OR 
                                                                                                                                           ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Submitted'  OR
                                                                                                                                           ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Paid')];
            }catch(exception e){
                PRLineItems = new list<ASI_TH_CRM_PaymentRequestLineItem__c >();
            }
            
            for ( ASI_TH_CRM_PaymentRequestLineItem__c  li_temp : PRLineItems ){
                if(li_temp.RecordType.DeveloperName!='ASI_CRM_CN_Payment_Request_Detail_Other'){
                    //ActualPerformance.VariableExpense+=li_temp.ASI_CRM_CN_Total_Payable__c!=null? li_temp.ASI_CRM_Adjustment__c*li_temp.ASI_CRM_CN_Total_Payable__c:0;
                }else{
                    if(li_temp.ASI_CRM_CN_Cost_Type__c == 'Fixed' ){
                       ActualPerformance.FixedExpense += li_temp.ASI_TH_CRM_Amount__c!=null? li_temp.ASI_TH_CRM_Amount__c:0;
                    }else{
                        ActualPerformance.VariableExpense+= li_temp.ASI_TH_CRM_Amount__c!=null? li_temp.ASI_TH_CRM_Amount__c:0;
                    }
                }
            }


                                
                                
            V0ContractAmount=V0ContractAmount+V0FixCostAmount;
            if (V0ContractAmount != null && V0ContractAmount !=0 && TotalPaymentAmount != null && TotalPaymentAmount != 0){
                system.debug('now V0FixCostAmount: '+V0FixCostAmount);
                PaymentSpeed = (TotalPaymentAmount / V0ContractAmount) * 100; 
            }
            

            LoopingSubBrandVolumeCMGSList();
            
            LoopingPaymentRequestLine();
            if(NewContractV0Esitimate.TradeExpenses!=null && NewContractV0Esitimate.TradeExpenses !=0){
                NewContractV0Esitimate.FixedExpenseRate = (NewContractV0Esitimate.FixedExpense/NewContractV0Esitimate.TradeExpenses)*100;
            }
            if(NewContactV0Contract.TradeExpenses!=null && NewContactV0Contract.TradeExpenses !=0){
                NewContactV0Contract.FixedExpenseRate = (NewContactV0Contract.FixedExpense/NewContactV0Contract.TradeExpenses)*100;
            }
            if(ActualPerformance.TradeExpenses!=null && ActualPerformance.TradeExpenses !=0){
                ActualPerformance.FixedExpenseRate = (ActualPerformance.FixedExpense/ActualPerformance.TradeExpenses)*100;
            }


            

            lstApprovalComment = [SELECT id, ASI_CRM_BA_comments__c FROM ASI_CRM_Approval_Comment__c
                                  WHERE ASI_CRM_Payment_Request__c =:thisPR.id];  
            if(lstApprovalComment==null || lstApprovalComment.size()==0){
                lstApprovalComment.add(new ASI_CRM_Approval_Comment__c());
            }
            
        }
        
        
        return true;    
    }
    
    
    
    
    //setup init variable
    public void InitVariable(){
        MartellBCRate=0;
        ContractBCRate=0;
         if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c != null){
             ContractBCRate=thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c;
         }else{
             ContractBCRate=thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Bottle_Collection_Rate__c;
         }
         
         
         if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c != null){
             MartellBCRate=thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_Martell_BC_Rate__c;
         }else{
             MartellBCRate=thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Martell_BC_Rate__c;
         }
         
        TotalPaymentVariableAmount=0;
        BRSF_CTD_CR12=0;
        PayeeList=new list<ASI_CRM_CN_PH_Payee_Line_Item__c>();
        CutOffDay=ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateCutOffDate();
        if (strPDF == '1'){
            AdorAbove = ASI_CRM_CN_HeavyContractUtilitiesClass.checkUserID();
        }else if (strPDF == '0'){
            AdorAbove=ASI_CRM_CN_HeavyContractUtilitiesClass.checkApprover(thisPR.id);
        }
        
        
        //Sub Brand Grade---> Sub Brand Grade Group
        SubbrandGroup = new map<string, string>();
        NewContractV0Esitimate = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();
        NewContactV0Contract = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();
        ActualPerformance = new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator ();
        RegionSubBrandCM_Map = new map<string,decimal>();
        if(thisPR.ASI_CRM_CN_Last_Payment__c){
            
            SubbrandGroup.put('Premium', '1. Standard + Premium / 标准档 + 高档');
            SubbrandGroup.put('Standard', '1. Standard + Premium / 标准档 + 高档');
            SubbrandGroup.put('Prestige', '4. Prestige + Ultra Prestige / 奢华档 + 特级奢华档');
            SubbrandGroup.put('Ultra Prestige', '4. Prestige + Ultra Prestige / 奢华档 + 特级奢华档');
            SubbrandGroup.put('Super Premium', '2. Super Premium / 超高档');
            SubbrandGroup.put('Ultra Premium', '3. Ultra Premium / 特级高档');
            SubbrandGroup.put('Not Specified / 未指定','5. Not Specified / 未指定');
            
            sbGroup_map = new Map<String, String>();
            sbGroup_map.put('1. Standard + Premium / 标准档 + 高档', 'Standard + Premium / 标准档 + 高档');
            sbGroup_map.put('2. Super Premium / 超高档', 'Super Premium / 超高档');
            sbGroup_map.put('3. Ultra Premium / 特级高档', 'Ultra Premium / 特级高档');
            sbGroup_map.put('4. Prestige + Ultra Prestige / 奢华档 + 特级奢华档', 'Prestige + Ultra Prestige / 奢华档 + 特级奢华档');
            sbGroup_map.put('5. Not Specified / 未指定', 'Not Specified / 未指定');
            
            for(String SBGName:sbGroup_map.keySet()){
                NewContractV0Esitimate.SubBrandGradeMap.put(SBGName,0.0); 
                NewContactV0Contract.SubBrandGradeMap.put(SBGName,0.0); 
                ActualPerformance.SubBrandGradeMap.put(SBGName,0.0); 
                
            }
        }
    }
    
    
    
    public void LoopingSubBrandVolumeCMGSList(){
        decimal Vol_CR12_1 =0; //All Payment Period
        
        
        map<string, decimal> ActualCM_v1_map = new map<string, decimal>();
        map<string, decimal> ActualGS_v1_map= new map<string, decimal>();
        map<string, decimal> lbcm_v1_map= new map<string, decimal>();
        Decimal ActualIntakeTotal = 0;//for calculating bc%
        Decimal ActualBCTotal = 0;//for calculating bc%
        
        Decimal ActualBlackCap = 0;
        
        Decimal TotalHistorical_MartellBC =0;  // total historical contract Martel BC
        Decimal TotalHistorical_MartellIntakeBtl =0;  // total historical contract Martel Intake Btl
        Decimal TotalHistorical_MartellBlackCap =0;  // total historical contract Martel BlackCap
        
        
        list<ASI_CRM_CN_Covered_Outlet__c> CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
        try{
            CoveredOutlet = [SELECT ASI_CRM_CN_Outlet__c
                             FROM ASI_CRM_CN_Covered_Outlet__c
                             WHERE ASI_CRM_CN_Contract__c = :thisPR.ASI_TH_CRM_Contract__c];
        }catch(exception e){
            CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
        }  
        set<id> AllOutlet = new set<id>();
        ASI_TH_CRM_PaymentRequest__c tempPR = [SELECT id, ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c FROM ASI_TH_CRM_PaymentRequest__c WHERE id = :thisPR.id]; 
        if (tempPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Normal' || tempPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Wholesaler Only' || tempPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == null ){
            AllOutlet.add(thisPR.ASI_CRM_CN_OutletWS__c);
        }
        if (tempPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Normal' || tempPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Covered Outlet Only' || tempPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == null ) {
            if (CoveredOutlet.size() > 0){
                for (ASI_CRM_CN_Covered_Outlet__c CO_temp: CoveredOutlet){
                    AllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
                }
            }
        }
        date TillEnd = ASI_CRM_CN_HeavyContractUtilitiesClass.getEndDate(ASI_CRM_CN_HeavyContractUtilitiesClass.FindMinMaxDate(CutOffDay, thisPR.ASI_CRM_CN_PO_End_Date__c, 'MIN'));
       
        
        system.debug('Payment thisPR.ASI_CRM_CN_PO_Start_Date__c: '+thisPR.ASI_CRM_CN_PO_Start_Date__c);
        system.debug('Payment TillEnd: '+TillEnd);
        list<ASI_CRM_Subbrand_Volume__c> SB_Vol_List = new list<ASI_CRM_Subbrand_Volume__c> ();
        
        try{
            SB_Vol_List = [SELECT Id,Name,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c , ASI_CRM_T1_Depletion_Std_Billing__c,ASI_CRM_Cap_with_Issues_Std_Billing__c,ASI_CRM_DeductibleCapWithIssues_Std_Btl__c, ASI_CRM_T1_Depletion_CR12__c,ASI_CRM_T2_Depletion_Std_Billing__c,
                           ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_External_ID__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c,
                           ASI_CRM_T2_Depletion_CR12__c,ASI_CRM_PR_Direct_Std_Billing__c, ASI_CRM_PR_Direct_CR12__c,ASI_CRM_End_Date__c, ASI_CRM_Subbrand__c, 
                           ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.Name,ASI_CRM_Green_Cap_Std_Billing__c  , ASI_CRM_T1_Depletion__c, ASI_CRM_T2_Depletion__c,ASI_CRM_PR_Direct__c, 
                           ASI_CRM_Empty_Bottle_Std_Billing__c, ASI_CRM_Subbrand__r.Name, ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,
                           ASI_CRM_T1_Depletion_STD__c, ASI_CRM_T2_Depletion_STD__c,ASI_CRM_PR_Direct_STD__c, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Chinese_Name__c, ASI_CRM_Green_Cap_STD__c,
                           ASI_CRM_Empty_Bottle_Std_Btl__c, ASI_CRM_Offtake_Std_Billing__c 
                           FROM ASI_CRM_Subbrand_Volume__c 
                           WHERE ASI_CRM_End_Date__c >= :thisPR.ASI_CRM_CN_PO_Start_Date__c AND ASI_CRM_End_Date__c <= :TillEnd  AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                           AND ASI_CRM_Account__c IN :AllOutlet and ASI_CRM_CN_Exclude_From_Payment_Volume__c =false and ASI_CRM_Subbrand__c !=null];
            
        }catch(exception e){
            SB_Vol_List = new list<ASI_CRM_Subbrand_Volume__c >();
        }
        
        if(thisPR.ASI_CRM_CN_Last_Payment__c){ // If it is last Payment
            list<ASI_CRM_CM_GS__c> ActualCM_List = new list<ASI_CRM_CM_GS__c>();
            map<date, decimal> V1_Period_map = checkFYDayPeriod(thisPR.ASI_CRM_CN_PO_Start_Date__c, thisPR.ASI_CRM_CN_PO_End_Date__c);
            SYSTEM.debug('Now V1_Period_map: '+ V1_Period_map);
            v1_ROI_newMap = new map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data>();
            
            set<id> v1_sbid_set = new set<id>(); //ActualPerformance
            if (SB_Vol_List.size() > 0){
                for (ASI_CRM_Subbrand_Volume__c SubBrandVolume : SB_Vol_List ){
                    system.debug('v1_sbid_set : '+SubBrandVolume.ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_External_ID__c);
                    v1_sbid_set.add(SubBrandVolume.ASI_CRM_Subbrand__c);
                    String sbGradeName ='';
                    Decimal ActualVolumes=0;
                    ActualVolumes+=SubBrandVolume.ASI_CRM_T1_Depletion__c!=null? SubBrandVolume.ASI_CRM_T1_Depletion__c:0;
                    ActualVolumes+=SubBrandVolume.ASI_CRM_T2_Depletion__c!=null? SubBrandVolume.ASI_CRM_T2_Depletion__c:0;
                    ActualVolumes+=SubBrandVolume.ASI_CRM_PR_Direct__c!=null? SubBrandVolume.ASI_CRM_PR_Direct__c:0;
                    
                    ActualPerformance.Volumes+=ActualVolumes;
                    
                    if (SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c != null){
                        if (SubbrandGroup.containskey(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name)){
                            sbGradeName = SubbrandGroup.get(SubBrandVolume.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name);
                        }else{
                            sbGradeName = 'Not Specified / 未指定';
                        }
                    }else{
                        sbGradeName = 'Not Specified / 未指定';
                    }
                    
                    if(ActualPerformance.SubBrandGradeMap.containskey(sbGradeName)){
                        Decimal TempVolumes=ActualPerformance.SubBrandGradeMap.get(sbGradeName)+ActualVolumes;
                        ActualPerformance.SubBrandGradeMap.remove(sbGradeName);//remove orignal one
                        ActualPerformance.SubBrandGradeMap.put(sbGradeName,TempVolumes); 
                    }else{
                        ActualPerformance.SubBrandGradeMap.put(sbGradeName,ActualVolumes); 
                    }
                    
                    
                }
            }
            
            if (V1_Period_map.size() > 0){
                string strkey;
                for (date v1temp : V1_Period_map.keyset()){
                    if (v1_sbid_set.size() > 0){
                        for (id sbtemp : v1_sbid_set){
                            strkey = string.valueof(v1temp) + sbtemp;
                            system.debug('V1 strkey : '+strkey);
                            ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data newitem = new ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data();                            
                            newitem.period = V1_Period_map.get(v1temp);
                            newitem.SubBrandId = sbtemp;
                            newitem.year = string.valueof(v1temp.year());
                            newitem.totalVolume = 0;
                            
                            if (!v1_ROI_newMap.containskey(strkey)){
                                v1_ROI_newMap.put(strkey, newitem);
                            }
                        }
                    }
                }
            }
            
            date strV1End = ASI_CRM_CN_HeavyContractUtilitiesClass.FindMinMaxDate(CutOffDay, thisPR.ASI_CRM_CN_PO_End_Date__c, 'MIN');
            system.debug('ActualCM Now strStart '+strStart);
            system.debug('ActualCM Now strV1End '+strV1End);

            try{
                ActualCM_List = [SELECT ASI_CRM_CM_GS_per_9L__c, ASI_CRM_CN_Standard_Bottle_Factor__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c, ASI_CRM_CN_Month__c,
                                 ASI_CRM_CN_Month_End_Date__c, ASI_CRM_PRODUCTCODE__r.Name, ASI_CRM_TYPE__c 
                                 FROM ASI_CRM_CM_GS__c
                                 WHERE ASI_CRM_PRODUCTCODE__c IN :v1_sbid_set
                                 AND ASI_CRM_Region__c = :thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                 AND ASI_CRM_CN_Month_End_Date__c >= :strStart
                                 AND ASI_CRM_CN_Month_End_Date__c <= :strV1End 
                                 AND (ASI_CRM_TYPE__c = 'YTD CM' OR ASI_CRM_TYPE__c = 'YTD GS')
                                 AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0
                                 ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC];
            }catch(exception e){
                ActualCM_List = new list<ASI_CRM_CM_GS__c>();
            }
            
            
            
            if (ActualCM_List.size() > 0){ 
                string strkey;
                string subbrand_id;
                string lastestkey;
                for (ASI_CRM_CM_GS__c ACM_temp : ActualCM_List){
                    subbrand_id = ACM_temp.ASI_CRM_PRODUCTCODE__c;
                    strkey = string.valueof(ACM_temp.ASI_CRM_CN_Month_End_Date__c) + subbrand_id;
                    
                    decimal ActualCMperBtl = null;
                    if (ACM_temp.ASI_CRM_CM_GS_per_9L__c != null){
                        ActualCMperBtl = ACM_temp.ASI_CRM_CM_GS_per_9L__c;  
                    }
                    
                    lastestkey = subbrand_id;
                    if (ACM_temp.ASI_CRM_TYPE__c == 'YTD CM'){
                        if (!ActualCM_v1_map.containskey(lastestkey) && ActualCMperBtl != Null && ActualCMperBtl != 0){//system.debug('Now Put '+lastestkey+' ActualCMperBtl : '+ActualCMperBtl);
                            ActualCM_v1_map.put(lastestkey, ActualCMperBtl);
                        }
                        if (v1_ROI_newMap.containskey(strkey)){
                            if ((v1_ROI_newMap.get(strkey).actualCM == null || v1_ROI_newMap.get(strkey).actualCM == 0) && ActualCMperBtl != Null && ActualCMperBtl != 0){
                                v1_ROI_newMap.get(strkey).actualCM = ActualCMperBtl; //v1_ROI_newMap.get(strkey).sbname = ACM_temp.ASI_CRM_PRODUCTCODE__r.Name;
                            } 
                        }
                    }
                    if (ACM_temp.ASI_CRM_TYPE__c == 'YTD GS'){
                        if (!ActualGS_v1_map.containskey(lastestkey) && ActualCMperBtl != Null && ActualCMperBtl != 0){//system.debug('Now Put '+lastestkey+' ActualCMperBtl : '+ActualCMperBtl);
                            ActualGS_v1_map.put(lastestkey, ActualCMperBtl);
                        }
                        
                        if (v1_ROI_newMap.containskey(strkey)){
                            if ((v1_ROI_newMap.get(strkey).actualGS == null || v1_ROI_newMap.get(strkey).actualGS == 0) && ActualCMperBtl != Null && ActualCMperBtl != 0){
                                v1_ROI_newMap.get(strkey).actualGS = ActualCMperBtl;
                                system.debug('YTD GS ACM_temp Id: '+ACM_temp.Id); //  v1_ROI_newMap.get(strkey).sbname = ACM_temp.ASI_CRM_PRODUCTCODE__r.Name;
                            }
                        }else{
                             system.debug(strkey+'Faild Now YTD GS ACM_temp Id: '+ACM_temp.Id);
                        }
                    }
                    
                    if (!lbcm_v1_map.containskey(lastestkey))
                        if ( RegionSubBrandCM_Map.containsKey(ACM_temp.ASI_CRM_PRODUCTCODE__c)) {
                            lbcm_v1_map.put(lastestkey, RegionSubBrandCM_Map.get(ACM_temp.ASI_CRM_PRODUCTCODE__c));
                        }
                    
                    
                    if (v1_ROI_newMap.containskey(strkey)){
                        if (v1_ROI_newMap.get(strkey).latestbudgetCM == null || v1_ROI_newMap.get(strkey).latestbudgetCM == 0){
                            if (RegionSubBrandCM_Map.containsKey(ACM_temp.ASI_CRM_PRODUCTCODE__c)) {
                                v1_ROI_newMap.get(strkey).latestbudgetCM = RegionSubBrandCM_Map.get(ACM_temp.ASI_CRM_PRODUCTCODE__c);
                            }
                        }// v1_ROI_newMap.get(strkey).sbname = ACM_temp.ASI_CRM_PRODUCTCODE__r.Name;
                    }
                    
                }
            }
            
            
        }
        
        
        
        
        //Looping Sub-brand Volume
        for (ASI_CRM_Subbrand_Volume__c  SB_Vol_temp : SB_Vol_List){
            system.debug('SB_Vol_temp Id : '+SB_Vol_temp.Id);
            Vol_CR12_1 += SB_Vol_temp.ASI_CRM_T1_Depletion_CR12__c!=null?SB_Vol_temp.ASI_CRM_T1_Depletion_CR12__c:0;
            Vol_CR12_1 += SB_Vol_temp.ASI_CRM_T2_Depletion_CR12__c!=null?SB_Vol_temp.ASI_CRM_T2_Depletion_CR12__c:0;
            Vol_CR12_1 += SB_Vol_temp.ASI_CRM_PR_Direct_CR12__c!=null?SB_Vol_temp.ASI_CRM_PR_Direct_CR12__c:0;
            
            Decimal  MarginUseTotalVol_std = 0;
            MarginUseTotalVol_std += SB_Vol_temp.ASI_CRM_PR_Direct_STD__c!=null?SB_Vol_temp.ASI_CRM_PR_Direct_STD__c:0;
            MarginUseTotalVol_std += SB_Vol_temp.ASI_CRM_T1_Depletion_STD__c!=null?SB_Vol_temp.ASI_CRM_T1_Depletion_STD__c:0;
            MarginUseTotalVol_std += SB_Vol_temp.ASI_CRM_T2_Depletion_STD__c!=null?SB_Vol_temp.ASI_CRM_T2_Depletion_STD__c:0;
            ActualIntakeTotal += MarginUseTotalVol_std;
            
            
            Decimal  ActualBC_std = 0;
            ActualBC_std += SB_Vol_temp.ASI_CRM_Green_Cap_STD__c != null? SB_Vol_temp.ASI_CRM_Green_Cap_STD__c:0;
            ActualBC_std += SB_Vol_temp.ASI_CRM_Empty_Bottle_Std_Btl__c != null? SB_Vol_temp.ASI_CRM_Empty_Bottle_Std_Btl__c:0;
            ActualBC_std += SB_Vol_temp.ASI_CRM_DeductibleCapWithIssues_Std_Btl__c != null? SB_Vol_temp.ASI_CRM_DeductibleCapWithIssues_Std_Btl__c:0;
            ActualBCTotal +=ActualBC_std;
                
            if( ASI_CRM_CN_HeavyPaymentUtilitiesClass.IsMartellSubBrandOrNot(SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c) ){
                system.debug('Now Martell: ActualBC_std: '+ActualBC_std + ' MarginUseTotalVol_std : ' + MarginUseTotalVol_std);
                TotalHistorical_MartellBC += ActualBC_std;
                TotalHistorical_MartellIntakeBtl+=MarginUseTotalVol_std;
                TotalHistorical_MartellBlackCap += SB_Vol_temp.ASI_CRM_Cap_with_Issues_Std_Billing__c != null? SB_Vol_temp.ASI_CRM_Cap_with_Issues_Std_Billing__c:0;   
            }
            
            ActualBlackCap +=  SB_Vol_temp.ASI_CRM_Cap_with_Issues_Std_Billing__c != null? SB_Vol_temp.ASI_CRM_Cap_with_Issues_Std_Billing__c:0;   
            
            
            String Mapkeystr= NameSortingASC(SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c)+SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c;
            Decimal CTDActualVol=0.0;
            CTDActualVol+= SB_Vol_temp.ASI_CRM_PR_Direct_STD_Billing__c == null ? 0 :SB_Vol_temp.ASI_CRM_PR_Direct_STD_Billing__c;
            CTDActualVol+= SB_Vol_temp.ASI_CRM_T1_Depletion_STD_Billing__c == null ? 0 :SB_Vol_temp.ASI_CRM_T1_Depletion_STD_Billing__c;
            CTDActualVol+= SB_Vol_temp.ASI_CRM_T2_Depletion_STD_Billing__c == null ? 0 :SB_Vol_temp.ASI_CRM_T2_Depletion_STD_Billing__c;
            
            CTDActualVol=CTDActualVol.setScale(0);
            if(VolumeMap.containsKey(Mapkeystr)){
                VolumeObject TempObject= VolumeMap.get(Mapkeystr);
                TempObject.CTDActualVol +=CTDActualVol;
                VolumeMap.remove(Mapkeystr);
                VolumeMap.put(Mapkeystr, TempObject);
            }else{
                VolumeObject TempObject= new VolumeObject();
                TempObject.SubBrandGradeName=SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                TempObject.SubBrandGradeCNName = SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c;
                TempObject.CTDActualVol=CTDActualVol;
                VolumeMap.put(Mapkeystr, TempObject);
            }
            
            Decimal   FC_actualvol_btl = 0;// Full Contract 
            if (SB_Vol_temp.ASI_CRM_T1_Depletion__c!= null) 
                FC_actualvol_btl = SB_Vol_temp.ASI_CRM_T1_Depletion__c;
            if (SB_Vol_temp.ASI_CRM_T2_Depletion__c!= null) 
                FC_actualvol_btl += SB_Vol_temp.ASI_CRM_T2_Depletion__c;
            if (SB_Vol_temp.ASI_CRM_PR_Direct__c!= null) 
                FC_actualvol_btl += SB_Vol_temp.ASI_CRM_PR_Direct__c;
            
            Date endDate = ASI_CRM_CN_HeavyContractUtilitiesClass.FYConversion(SB_Vol_temp.ASI_CRM_End_Date__c);
            String strkey = string.valueof(endDate) + SB_Vol_temp.ASI_CRM_Subbrand__c;
            system.debug('Now strkey SubBrand volume'+strkey);
            
            if (v1_ROI_newMap.containskey(strkey)){
                system.debug(strkey);
                if (v1_ROI_newMap.get(strkey).actual_vol != null)
                    v1_ROI_newMap.get(strkey).actual_vol += FC_actualvol_btl;
                else
                    v1_ROI_newMap.get(strkey).actual_vol = FC_actualvol_btl;
            }else{
                ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data newDC1 = new ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data();
                newDC1.actual_vol = FC_actualvol_btl;
                newDC1.SubBrandId = SB_Vol_temp.ASI_CRM_Subbrand__c;
                v1_ROI_newMap.put(strkey, newDC1);
            }  
            
        }
        
        
        
        
        
        for (String  VolumeMapKey:VolumeMap.keySet()){
            if(VolumeMap.get(VolumeMapKey).FullContractTarget==0 && VolumeMap.get(VolumeMapKey).CTDActualVol==0){
                VolumeMap.remove(VolumeMapKey);
            }
        }
        
        
        //************************Calculation****************************************
        if (Vol_CR12_1  != null && Vol_CR12_1  != 0 && BRSF_CTD_CR12 != null && BRSF_CTD_CR12 != 0){
            system.debug('Now Vol_CR12_1'+Vol_CR12_1);
            system.debug('Now BRSF_CTD_CR12'+BRSF_CTD_CR12);
            Other_VOL_CR12 =  (Vol_CR12_1 / BRSF_CTD_CR12)  * 100;
        }
        
        
        if(ActualBCTotal != null && ActualBCTotal != 0 && ActualIntakeTotal != null && ActualIntakeTotal != 0){
            ActualPerformance.BCRate = (ActualBCTotal / ActualIntakeTotal)*100;
            ActualPerformance.NetBCRate = ( (ActualBCTotal-ActualBlackCap) / ActualIntakeTotal)*100;
        }
        
        
        if(TotalHistorical_MartellBC != null && TotalHistorical_MartellBC != 0 && TotalHistorical_MartellIntakeBtl != null && TotalHistorical_MartellIntakeBtl != 0){
            system.debug('Now TotalHistorical_MartellBC : '+TotalHistorical_MartellBC);
            system.debug('Now TotalHistorical_MartellIntakeBtl : '+TotalHistorical_MartellIntakeBtl);
            ActualPerformance.TotalMBCRate = (TotalHistorical_MartellBC / TotalHistorical_MartellIntakeBtl)*100;
            ActualPerformance.NetMBCRate= ( (TotalHistorical_MartellBC - TotalHistorical_MartellBlackCap ) / TotalHistorical_MartellIntakeBtl)*100;
        }
        
        
         
        
        //VFinal ROI Actual Performance 1452
        if (v1_ROI_newMap.size() > 0){
            decimal totalsb_cm_v1 = 0;
            decimal totalsb_gs_v1 = 0;
            integer tilldateperiod;
            decimal totalsb_lbcm_v1 = 0; 

            for (ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data sb_v1 : v1_ROI_newMap.values()){
               
                decimal actualcm = null;
                if (sb_v1.actualCM != null && sb_v1.actualCM != 0){
                    actualcm = sb_v1.actualCM;
                }else if (ActualCM_v1_map.containskey(sb_v1.SubBrandId)){
                    system.debug('actualcm: '+sb_v1.SubBrandId);
                    actualcm = ActualCM_v1_map.get(sb_v1.SubBrandId);
                }

                if (sb_v1.actual_vol != null && actualcm != null){ 
                    system.debug('Calculate totalsb_cm_v1 : '+sb_v1.actual_vol+'*'+actualcm+ 'with SubBrand Id : '+sb_v1.SubBrandId);
                    totalsb_cm_v1 += sb_v1.actual_vol * actualcm; 
                }
                
                
                decimal lbcm = null;
                if (sb_v1.actualCM != null && sb_v1.actualCM != 0){
                    lbcm = sb_v1.latestbudgetCM;
                }else if (lbcm_v1_map.containskey(sb_v1.SubBrandId)){
                    lbcm = lbcm_v1_map.get(sb_v1.SubBrandId);
                }
                if (sb_v1.actual_vol != null && lbcm != null){ 
                    totalsb_lbcm_v1 += sb_v1.actual_vol * lbcm; 
                }
                
                
                //GS
                decimal actualgs = null;
                if (sb_v1.actualGS != null && sb_v1.actualGS != 0){
                    actualgs = sb_v1.actualGS;
                }else if (ActualGS_v1_map.containskey(sb_v1.SubBrandId)){
                    system.debug('Get ActualGS_v1_map'+ActualGS_v1_map.get(sb_v1.SubBrandId)+ 'with SubBrand Id : '+sb_v1.SubBrandId);
                    actualgs = ActualGS_v1_map.get(sb_v1.SubBrandId);
                }
                if (sb_v1.actual_vol != null && actualgs != null){ 
                    system.debug('totalsb_gs_v1=: '+sb_v1.actual_vol +'*'+actualgs);
                    totalsb_gs_v1 += sb_v1.actual_vol * actualgs;
                }
            }

            //vFinal Actual Gross Sales %
            if (totalsb_gs_v1 != 0 && totalsb_gs_v1 != null && ActualPerformance.TradeExpenses != 0 && ActualPerformance.TradeExpenses != null)
               ActualPerformance.GrossSalesRate = ActualPerformance.TradeExpenses / totalsb_gs_v1 *100;

            //vFinal Actual ROI
            if (TotalPaymentAmount != 0 && TotalPaymentAmount != null && totalsb_cm_v1 != null && totalsb_cm_v1 != 0)
                ActualPerformance.ROIIntake= totalsb_cm_v1 / TotalPaymentAmount;

            if(Vol_CR12_1!=null && Vol_CR12_1 !=0 && TotalPaymentAmount !=null && TotalPaymentAmount!=0 ){
                ActualPerformance.InvestmentCR12 = TotalPaymentAmount/Vol_CR12_1;
            }
            //vFinal Actual Margin AP
            if (ActualPerformance.TradeExpenses != null && totalsb_cm_v1 != null)
                ActualPerformance.MarginAfterAnP = totalsb_cm_v1 - ActualPerformance.TradeExpenses;
           
            //vFinal Actual Margin per Btl
            if (ActualIntakeTotal != null && ActualIntakeTotal != 0 &&  ActualPerformance.MarginAfterAnP!= null &&  ActualPerformance.MarginAfterAnP != 0)
                ActualPerformance.MarginPerBottle =  ActualPerformance.MarginAfterAnP / ActualIntakeTotal ;
            

            //vFinal Actual Pro-Forma ROI
            if (TotalPaymentAmount != 0 && TotalPaymentAmount != null && totalsb_lbcm_v1 != null && totalsb_lbcm_v1 != 0)
                ActualPerformance.ROIProForma = totalsb_lbcm_v1 / TotalPaymentAmount;
        }
        
        
        
        
        
        
    }
    
    
    
    
    // Calculate Payment V0.0 Contract Detail Line Contarct Cost (not including Fix cost)
    Public Decimal CalculateV0ContractDetailCost(){
        Decimal BRSF_CTD_CR12_contract =0;// BRSF Total Volume in CR 12 All period
        
        Decimal BRSF_CTD_CR12_estimate =0;
        Decimal ContractAmount=0;
        Decimal v0Contract_totalBtl =0; // V0.0 contract Total per bt
        Decimal v0Estimate_totalBtl =0;// V0.0 Estimate Total per bt
        Set<String> SubBrandIdSet = new Set<String> ();
        Map<String,Decimal> CR12FactorMap = new Map<String,Decimal> ();
        map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data> Subbrand_ROI_map_v0 =new map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data>();	 
        list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractLines = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ();
        
        String V0ContractId=GenerateV0ContractId();
        system.debug('Now V0ContractId'+V0ContractId);
        try{
            //query ContractBRSF Sub Brands & Data
            ContractLines = [SELECT id, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c,
                             ASI_CRM_CN_Est_Total_Dummy__c,ASI_CRM_CN_Contract_Total__c,ASI_CRM_Type__c , ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, 
                             ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Chinese_Name__c,
                             ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Monthly_Qty__c , ASI_CRM_CN_Sub_Brand_Conversion_Factor__c,  ASI_CRM_CN_Contract__c, ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c,ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Contract_Monthly_Vol9L__c, ASI_CRM_CN_Contract_Monthly_Qty__c,
                             ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Standard_Bottle_Size__c,
                             ASI_CRM_CN_Contract__r.ASI_CRM_CN_PO_Version__c
                             FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :V0ContractId];
        }catch(exception e){
            String msg = 'Save Error : ' +e.getMessage() + '</br>';
            ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyContractUtilitiesClass.CalculateV0EstCost  class have Error  '+msg,'ASI_CRM_CN_HeavyContractUtilitiesClass',' function failed! with Payment Id: '+thisPR.id );
        }
        
        //1st Time Looping
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractDetail:ContractLines){
            if(ContractDetail.ASI_CRM_Type__c=='BRSF'){
                Decimal ContractVolumes9L=ContractDetail.ASI_CRM_CN_Contract_Monthly_Vol9L__c!=null? ContractDetail.ASI_CRM_CN_Contract_Monthly_Vol9L__c * ContractDetail.ASI_CRM_CN_No_of_Months__c:0;
                Decimal EstimateVolumes9L=ContractDetail.ASI_CRM_CN_Estimate_Volume_9L_Month__c!=null?ContractDetail.ASI_CRM_CN_Estimate_Volume_9L_Month__c * ContractDetail.ASI_CRM_CN_No_of_Months__c:0;
               
                
                //v0Contract_totalBtl += ContractVolumes9L;
                //v0Estimate_totalBtl+=EstimateVolumes9L;
                v0Contract_totalBtl+= ContractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?ContractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c*ContractDetail.ASI_CRM_CN_No_of_Months__c:0;
                v0Estimate_totalBtl+= ContractDetail.ASI_CRM_CN_Est_Monthly_Qty__c!=null?ContractDetail.ASI_CRM_CN_Est_Monthly_Qty__c*ContractDetail.ASI_CRM_CN_No_of_Months__c:0;
                
                    
                Decimal ContractTarget=ContractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?ContractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c*ContractDetail.ASI_CRM_CN_No_of_Months__c:0;
                
                String Mapkeystr= NameSortingASC(ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c)+ ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c;
                
                if(VolumeMap.containsKey(Mapkeystr)){
                    VolumeObject TempObject= VolumeMap.get(Mapkeystr);
                    TempObject.FullContractTarget +=ContractTarget.setScale(0);
                    VolumeMap.remove(Mapkeystr);
                    VolumeMap.put(Mapkeystr, TempObject);
                }else{
                    VolumeObject TempObject= new VolumeObject();
                    TempObject.SubBrandGradeName=ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name;
                    TempObject.SubBrandGradeCNName = ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_Chinese_Name__c;
                    TempObject.FullContractTarget=ContractTarget.setScale(0);
                    VolumeMap.put(Mapkeystr, TempObject);
                }

                String sbGradeName='';
                if (ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c != null){
                    if (SubbrandGroup.containskey(ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name)){
                        sbGradeName = SubbrandGroup.get(ContractDetail.ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name);
                    }else{
                        sbGradeName = 'Not Specified / 未指定';
                    }
                }else{
                    sbGradeName = 'Not Specified / 未指定';
                }
                
                if(NewContractV0Esitimate.SubBrandGradeMap.containskey(sbGradeName)){
                    Decimal TempVolumes=NewContractV0Esitimate.SubBrandGradeMap.get(sbGradeName)+EstimateVolumes9L;
                    NewContractV0Esitimate.SubBrandGradeMap.remove(sbGradeName); //remove orignal one
                    NewContractV0Esitimate.SubBrandGradeMap.put(sbGradeName,TempVolumes); 
                }else{
                    NewContractV0Esitimate.SubBrandGradeMap.put(sbGradeName,EstimateVolumes9L); 
                }
                
                if(NewContactV0Contract.SubBrandGradeMap.containskey(sbGradeName)){
                    Decimal TempVolumes=NewContactV0Contract.SubBrandGradeMap.get(sbGradeName)+EstimateVolumes9L;
                    NewContactV0Contract.SubBrandGradeMap.remove(sbGradeName);//remove orignal one
                    NewContactV0Contract.SubBrandGradeMap.put(sbGradeName,TempVolumes); 
                }else{
                    NewContactV0Contract.SubBrandGradeMap.put(sbGradeName,EstimateVolumes9L); 
                }
                
                
                SubBrandIdSet.add(ContractDetail.ASI_CRM_CN_Sub_Brand__c);//ASI_CRM_CN_Estimate_Volume_9L_Month__c
                //Calculate Volume
                NewContactV0Contract.Volumes+=ContractVolumes9L;
                NewContractV0Esitimate.Volumes+=EstimateVolumes9L;
                
                Decimal ContractVolumes9LnoMonth=ContractDetail.ASI_CRM_CN_Contract_Monthly_Vol9L__c!=null? ContractDetail.ASI_CRM_CN_Contract_Monthly_Vol9L__c :0;
                Decimal EstimateVolumes9LnoMonth=ContractDetail.ASI_CRM_CN_Estimate_Volume_9L_Month__c!=null?ContractDetail.ASI_CRM_CN_Estimate_Volume_9L_Month__c :0;
                
               system.debug(ContractDetail.ASI_CRM_CN_Sub_Brand__c+' Subbrand_ROI_map_v0 '+EstimateVolumes9L);
                if (Subbrand_ROI_map_v0.containskey(ContractDetail.ASI_CRM_CN_Sub_Brand__c)){
                    SubBrand_ROI_map_v0.get(ContractDetail.ASI_CRM_CN_Sub_Brand__c).actual_vol += EstimateVolumes9LnoMonth; //estimate volume
                    SubBrand_ROI_map_v0.get(ContractDetail.ASI_CRM_CN_Sub_Brand__c).target_vol += ContractVolumes9LnoMonth ;
                }else{
                    ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data newDC1 = new ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data();
                    newDC1.actualCM = 0;
                    newDC1.actualGS = 0;
                    newDC1.actual_vol = EstimateVolumes9LnoMonth;
                    newDC1.target_vol = ContractVolumes9LnoMonth ;
                    Subbrand_ROI_map_v0.put(ContractDetail.ASI_CRM_CN_Sub_Brand__c, newDC1);
                }
                
                
            }
            
             NewContractV0Esitimate.TradeExpenses+= ContractDetail.ASI_CRM_CN_Est_Total_Dummy__c;
             NewContactV0Contract.TradeExpenses+= ContractDetail.ASI_CRM_CN_Contract_Total_Dummy__c;
                
                
        }
        
        if(SubBrandIdSet.size()>0){
            CR12FactorMap=GenerateCR12FactorMap(SubBrandIdSet);
        }
        
        
        //2nd Time Looping
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c contractDetail:ContractLines){
            ContractAmount+= contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c!=null? contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c:0;
            Decimal CR12Factor=1;
            if(CR12FactorMap.containsKey(contractDetail.ASI_CRM_CN_Sub_Brand__c)){
                CR12Factor=CR12FactorMap.get(contractDetail.ASI_CRM_CN_Sub_Brand__c);
            }
            
            
            if(ContractDetail.ASI_CRM_Type__c=='BRSF'){
                BRSF_CTD_CR12+=CR12Factor*contractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c* contractDetail.ASI_CRM_CN_No_of_Months__c;//CR12Factor*contractDetail.ASI_CRM_CN_Est_Monthly_Qty__c* contractDetail.ASI_CRM_CN_No_of_Months__c;
                BRSF_CTD_CR12_contract+=  contractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c!=null?  CR12Factor*contractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c*contractDetail.ASI_CRM_CN_No_of_Months__c :0;
                BRSF_CTD_CR12_estimate+= contractDetail.ASI_CRM_CN_Est_Monthly_Qty__c!=null?  CR12Factor*contractDetail.ASI_CRM_CN_Est_Monthly_Qty__c*contractDetail.ASI_CRM_CN_No_of_Months__c :0;
            }
       
            NewContractV0Esitimate.VariableExpense += contractDetail.ASI_CRM_CN_Est_Total_Dummy__c!=null? contractDetail.ASI_CRM_CN_Est_Total_Dummy__c:0;
            NewContactV0Contract.VariableExpense +=contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c!=null? contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c:0;
            
        }
        
        
        if(thisPR.ASI_CRM_CN_Last_Payment__c){ // If it is last Payment
            
            
            // get latest Budget CM for all Sub-Brands
            string currentFY = String.valueOf(ASI_CRM_CN_HeavyContractUtilitiesClass.FYConversion(date.Today()).Year());
            string currentFY2 = (integer.valueOf(currentFY) - 1) + '';
            string currentFY3 = (integer.valueOf(currentFY) - 2) + '';
            system.debug('currentFY'+currentFY);
            system.debug('currentFY2'+currentFY2);
            system.debug('currentFY3'+currentFY3);
            string ProductCode;
            decimal cm;
            for (ASI_CRM_CM_GS__c lbcm : [SELECT id, ASI_CRM_YEAR__c,ASI_CRM_CM_GS_per_9L__c,ASI_CRM_PRODUCTCODE__r.name, ASI_CRM_PRODUCTCODE__c, ASI_CRM_Region__c, ASI_CRM_CN_Month__c FROM ASI_CRM_CM_GS__c WHERE ASI_CRM_CN_Month__c = 6 
                                          AND ASI_CRM_Region__c = : thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                          AND (ASI_CRM_YEAR__c = :currentFY  OR ASI_CRM_YEAR__c = :currentFY2 OR ASI_CRM_YEAR__c = :currentFY3)
                                          AND (ASI_CRM_TYPE__c = 'Budget CM')  AND ASI_CRM_CM_GS_per_9L__c != Null AND ASI_CRM_CM_GS_per_9L__c != 0  ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_YEAR__c DESC, ASI_CRM_VERSION__c DESC ])
            { 
                ProductCode = lbcm.ASI_CRM_PRODUCTCODE__c;
                if (lbcm.ASI_CRM_CM_GS_per_9L__c == null){
                    cm = 0;
                }else{
                    cm = lbcm.ASI_CRM_CM_GS_per_9L__c;
                }
                if(!RegionSubBrandCM_Map.containsKey(ProductCode) && cm != Null && cm != 0){
                    system.debug('Now put '+lbcm.ASI_CRM_YEAR__c+' ' +lbcm.ASI_CRM_PRODUCTCODE__r.name+lbcm.id+' into the RegionSubBrandCM_Map ');
                    RegionSubBrandCM_Map.put(ProductCode,cm);
                }
                
            }
            
            
            
            
            
            
            map<date, decimal> V0_Period_map = new map<date, decimal>(); 
            if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c != null){
                if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c != null)
                    V0_Period_map = checkFYDayPeriod(thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c, thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c);
            }else{
                if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_PO_Start_Date__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_PO_End_Date__c != null)
                    V0_Period_map = checkFYDayPeriod(thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_PO_Start_Date__c, thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_PO_End_Date__c);
            }  
            
            v0_ROI_newMap=new map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data>();	
            if (V0_Period_map.size() > 0){
                string strkey;
                for (date v0temp : V0_Period_map.keyset()){
                    SYSTEM.debug('now v0temp'+ v0temp);
                    if (SubBrandIdSet.size() > 0){
                        for (String idtemp : SubBrandIdSet){
                            
                            strkey = string.valueof(v0temp) + idtemp;
                            SYSTEM.debug('now v0_ROI_newMap strkey'+ strkey);
                            if (!v0_ROI_newMap.containskey(strkey)){
                                ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data newitem = new ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data(); 
                                newitem.period = V0_Period_map.get(v0temp);
                                SYSTEM.debug('now V0_Period_map.get(v0temp)'+ V0_Period_map.get(v0temp));
                                newitem.SubBrandId = idtemp;
                                newitem.year = string.valueof(v0temp.year());
                                newitem.totalVolume = 0;
                                v0_ROI_newMap.put(strkey, newitem);
                            }
                        }
                    }
                }
            } 
            
            //V0ContractId
            ASI_TH_CRM_Contract__c Contractv0 =new ASI_TH_CRM_Contract__c();
            
            date strEnd;
            if (V0ContractId != null && V0ContractId != ''){
                Contractv0 = [SELECT ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_End_Date__c  FROM ASI_TH_CRM_Contract__c WHERE id = :V0ContractId];
            }
            if (Contractv0.ASI_CRM_CN_PO_Start_Date__c !=null ){
                strStart = Contractv0.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
            }else{
                strStart = thisPR.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
            }
            
            if (Contractv0.ASI_CRM_CN_PO_End_Date__c !=null ){
                strEnd = ASI_CRM_CN_HeavyContractUtilitiesClass.getEndDate(Contractv0.ASI_CRM_CN_PO_End_Date__c.addYears(+1));
            }else{
                strEnd = ASI_CRM_CN_HeavyContractUtilitiesClass.getEndDate(thisPR.ASI_CRM_CN_PO_End_Date__c.addYears(+1));
            }
            
            //last Payment 
            // Date strStart2 = date.newInstance(strStart.addYears(-1).year(), 6, 30);
            //Date strEnd2 = date.newInstance(strEnd.addYears(1).year(), 6, 30);
            
            Date strStart2 = date.newInstance(strStart.addYears(-3).year(), 6, 30);
            Date strEnd2 = date.newInstance(strEnd.year(), 6, 30);
            strStart=ASI_CRM_CN_HeavyContractUtilitiesClass.getEndDate(strStart);
            
            
            Map<String, ASI_CRM_CM_GS__c> cmgsMap = new Map<String, ASI_CRM_CM_GS__c>();
            List<ASI_CRM_CM_GS__c> BudgetCM_List_v0 = new List<ASI_CRM_CM_GS__c>();
            
            system.debug('CM GS strStart:'+strStart);
            system.debug('strEnd:'+strEnd);
            system.debug('strStart2:'+strStart2);
            system.debug(' strEnd2:'+strEnd2);
            
            
            try{
                BudgetCM_List_v0 = [SELECT ASI_CRM_CM_GS_per_9L__c, ASI_CRM_CN_Standard_Bottle_Factor__c, ASI_CRM_PRODUCTCODE__c,ASI_CRM_Region__c, ASI_CRM_CN_Month__c,ASI_CRM_CN_Month_End_Date__c, ASI_CRM_TYPE__c 
                                    FROM ASI_CRM_CM_GS__c
                                    WHERE ASI_CRM_PRODUCTCODE__c IN :SubBrandIdSet AND ASI_CRM_Region__c = :thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                    AND ((ASI_CRM_CN_Month_End_Date__c >= :strStart AND ASI_CRM_CN_Month_End_Date__c <= :strEnd)  
                                        OR (ASI_CRM_CN_Month_End_Date__c >= : strStart2  AND ASI_CRM_CN_Month_End_Date__c <= : strEnd2 AND ASI_CRM_CN_Month__c = 6 ) )
                                    AND (ASI_CRM_TYPE__c = 'Budget CM' OR ASI_CRM_TYPE__c = 'Budget GS')
                                    AND ASI_CRM_CM_GS_per_9L__c != 0 AND ASI_CRM_CM_GS_per_9L__c != Null
                                    ORDER BY ASI_CRM_PRODUCTCODE__c ASC, ASI_CRM_CN_Month_End_Date__c DESC, ASI_CRM_VERSION__c DESC];
            }catch(exception e){
                BudgetCM_List_v0 = new list<ASI_CRM_CM_GS__c>();
            }
            
            
            if (BudgetCM_List_v0.size() > 0){
                string strkey;
                string subbrand_id;
                decimal BrsfVol;
                decimal BrsfTargetVol;
                decimal ActualCMperBtl;
                
                for (ASI_CRM_CM_GS__c ACM_v0_temp : BudgetCM_List_v0){
                    subbrand_id = ACM_v0_temp.ASI_CRM_PRODUCTCODE__c;
                    strkey = string.valueof(ACM_v0_temp.ASI_CRM_CN_Month_End_Date__c) + subbrand_id;
                    SYSTEM.debug('now v0_ROI_newMap strkey'+ strkey);
                    
                    ActualCMperBtl = null;
                    
                    if(ACM_v0_temp.ASI_CRM_CN_Month__c == 6 && !cmgsMap.containsKey(ACM_v0_temp.ASI_CRM_PRODUCTCODE__c + ACM_v0_temp.ASI_CRM_TYPE__c) && ACM_v0_temp.ASI_CRM_CM_GS_per_9L__c != null && ACM_v0_temp.ASI_CRM_CM_GS_per_9L__c != 0){
                        cmgsMap.put(ACM_v0_temp.ASI_CRM_PRODUCTCODE__c + ACM_v0_temp.ASI_CRM_TYPE__c, ACM_v0_temp);
                    }
                    
                    if (ACM_v0_temp.ASI_CRM_CM_GS_per_9L__c != null)
                        ActualCMperBtl = ACM_v0_temp.ASI_CRM_CM_GS_per_9L__c;
                    
                    //Estimate volume 
                    BrsfVol = 0;
                    if (Subbrand_ROI_map_v0.containskey(subbrand_id)){
                        system.debug('Enter: ');
                        BrsfVol = Subbrand_ROI_map_v0.get(subbrand_id).actual_vol;
                    }
                    system.debug('BrsfVol: '+BrsfVol);
                    //Contract volume 
                    BrsfTargetVol = 0;
                    if (Subbrand_ROI_map_v0.containskey(subbrand_id)){
                        BrsfTargetVol = Subbrand_ROI_map_v0.get(subbrand_id).target_vol;
                    }
                    
                    //Budget CM
                    if (ACM_v0_temp.ASI_CRM_TYPE__c == 'Budget CM'){
                        if (v0_ROI_newMap.containskey(strkey)){
                            
                            if ((v0_ROI_newMap.get(strkey).actualCM == null || v0_ROI_newMap.get(strkey).actualCM == 0 )&& ActualCMperBtl != Null && ActualCMperBtl != 0)
                                v0_ROI_newMap.get(strkey).actualCM = ActualCMperBtl;
                            if (v0_ROI_newMap.get(strkey).actual_vol == null || v0_ROI_newMap.get(strkey).actual_vol == 0)
                                v0_ROI_newMap.get(strkey).actual_vol = BrsfVol;
                            if (v0_ROI_newMap.get(strkey).target_vol == null || v0_ROI_newMap.get(strkey).target_vol == 0)
                                v0_ROI_newMap.get(strkey).target_vol = BrsfTargetVol;
                        }
                    }  
                    //Budget GS
                    if (ACM_v0_temp.ASI_CRM_TYPE__c == 'Budget GS'){
                        if (v0_ROI_newMap.containskey(strkey)){
                            if((v0_ROI_newMap.get(strkey).actualGS == null || v0_ROI_newMap.get(strkey).actualGS == 0) && ActualCMperBtl != Null && ActualCMperBtl != 0)
                                v0_ROI_newMap.get(strkey).actualGS = ActualCMperBtl;
                            if (v0_ROI_newMap.get(strkey).target_vol == null || v0_ROI_newMap.get(strkey).target_vol == 0)
                                v0_ROI_newMap.get(strkey).target_vol = BrsfTargetVol;
                            if (v0_ROI_newMap.get(strkey).actual_vol == null || v0_ROI_newMap.get(strkey).actual_vol == 0)
                                v0_ROI_newMap.get(strkey).actual_vol = BrsfVol;
                        }
                    }
                    
                    if (v0_ROI_newMap.containskey(strkey)){
                        if (v0_ROI_newMap.get(strkey).latestbudgetCM == null || v0_ROI_newMap.get(strkey).latestbudgetCM == 0){
                            if(RegionSubBrandCM_Map.containsKey(ACM_v0_temp.ASI_CRM_PRODUCTCODE__c)){
                                v0_ROI_newMap.get(strkey).latestbudgetCM = RegionSubBrandCM_Map.get(ACM_v0_temp.ASI_CRM_PRODUCTCODE__c);
                            }
                        }
                        
                    }
                    
                    
                }
                
                for(String key : v0_ROI_newMap.keySet()){
                    if(v0_ROI_newMap.get(key).actualCM == Null || v0_ROI_newMap.get(key).actualCM == 0 || v0_ROI_newMap.get(key).actualGS == Null || v0_ROI_newMap.get(key).actualGS == 0 || v0_ROI_newMap.get(key).latestbudgetCM == Null || v0_ROI_newMap.get(key).latestbudgetCM == 0){
                        if((v0_ROI_newMap.get(key).actualCM == Null || v0_ROI_newMap.get(key).actualCM == 0) && cmgsMap.containsKey(v0_ROI_newMap.get(key).SubBrandId + 'Budget CM')){
                            ASI_CRM_CM_GS__c cmgs = cmgsMap.get(v0_ROI_newMap.get(key).SubBrandId + 'Budget CM');
                            
                            v0_ROI_newMap.get(key).actualCM = cmgs.ASI_CRM_CM_GS_per_9L__c;
                        }
                        
                        if((v0_ROI_newMap.get(key).actualGS == Null || v0_ROI_newMap.get(key).actualGS == 0) && cmgsMap.containsKey(v0_ROI_newMap.get(key).SubBrandId + 'Budget GS')){
                            ASI_CRM_CM_GS__c cmgs = cmgsMap.get(v0_ROI_newMap.get(key).SubBrandId + 'Budget GS');
                            
                            v0_ROI_newMap.get(key).actualGS = cmgs.ASI_CRM_CM_GS_per_9L__c;
                        }
                        
                        if(v0_ROI_newMap.get(key).latestBudgetCM == Null || v0_ROI_newMap.get(key).latestBudgetCM == 0){
                            if( RegionSubBrandCM_Map.containsKey(v0_ROI_newMap.get(key).SubBrandId))
                                v0_ROI_newMap.get(key).latestBudgetCM = RegionSubBrandCM_Map.get(v0_ROI_newMap.get(key).SubBrandId);
                        }
                    }
                    
                    if(v0_ROI_newMap.get(key).actual_vol == 0 && Subbrand_ROI_map_v0.containsKey(v0_ROI_newMap.get(key).SubBrandId))
                        v0_ROI_newMap.get(key).actual_vol = Subbrand_ROI_map_v0.get(v0_ROI_newMap.get(key).SubBrandId).actual_vol;
                    if(v0_ROI_newMap.get(key).target_vol == 0 && Subbrand_ROI_map_v0.containsKey(v0_ROI_newMap.get(key).SubBrandId))
                        v0_ROI_newMap.get(key).target_vol = Subbrand_ROI_map_v0.get(v0_ROI_newMap.get(key).SubBrandId).target_vol;
                }
            }
            
            if (v0_ROI_newMap.size() > 0){
                decimal TotalSubBrandCM_estimate = 0;
                decimal TotalSubBrandGS_estimate = 0;
                decimal TotalSubBrandCM_contract = 0;
                decimal TotalSubBrandGS_contract = 0;
                decimal TotalSubBrand_LBCM_contract = 0;
                decimal TotalSubBrand_LBCM_estimate = 0; 
                for (ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data sb_v0 : v0_ROI_newMap.values()){
                    //estimate volume * budget cm
                    if (sb_v0.actual_vol != null && sb_v0.period != null && sb_v0.actualCM != null){
                        system.debug(sb_v0.SubBrandId+'TotalSubBrandCM_estimate= '+ sb_v0.actual_vol +'*'+ sb_v0.actualCM +'*'+ sb_v0.period);
                        TotalSubBrandCM_estimate += sb_v0.actual_vol * sb_v0.actualCM * sb_v0.period;
                    }
                    //estimate volume * budget gs
                    if (sb_v0.actual_vol != null && sb_v0.period != null && sb_v0.actualGS != null){
                        TotalSubBrandGS_estimate += sb_v0.actual_vol * sb_v0.actualGS * sb_v0.period;
                    }
                    //contract volume * budget cm
                    if (sb_v0.target_vol != null && sb_v0.period != null && sb_v0.actualCM != null){
                        TotalSubBrandCM_contract += sb_v0.target_vol * sb_v0.actualCM * sb_v0.period;
                    }
                    //contract volume * budget gs
                    if (sb_v0.target_vol != null && sb_v0.period != null && sb_v0.actualGS != null){
                        
                        TotalSubBrandGS_contract += sb_v0.target_vol * sb_v0.actualGS * sb_v0.period;
                    }
                    
                    // contract volume * latest budget cm
                    if (sb_v0.target_vol != null && sb_v0.period != null && sb_v0.latestbudgetCM != null){
                        TotalSubBrand_LBCM_contract += sb_v0.target_vol * sb_v0.latestbudgetCM * sb_v0.period;
                    }
                    //estimate volume * budget cm
                    if (sb_v0.actual_vol != null && sb_v0.period != null && sb_v0.latestbudgetCM != null){
                        TotalSubBrand_LBCM_estimate += sb_v0.actual_vol * sb_v0.latestbudgetCM * sb_v0.period;
                    }
                    
                    
                }
                //v0.0 Estimate Gross Sales %
                if (TotalSubBrandGS_estimate != null && TotalSubBrandGS_estimate != 0 && NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses != null)
                    NewContractV0Esitimate.GrossSalesRate = NewContractV0Esitimate.TradeExpenses / TotalSubBrandGS_estimate * 100;
                //v0.0 Contract Gross Sales %
                if (TotalSubBrandGS_contract != null && TotalSubBrandGS_contract != 0 && NewContactV0Contract.TradeExpenses != 0 && NewContactV0Contract.TradeExpenses != null)
                    NewContactV0Contract.GrossSalesRate = NewContactV0Contract.TradeExpenses / TotalSubBrandGS_contract * 100;
                
                if(NewContactV0Contract.TradeExpenses!=null && BRSF_CTD_CR12_contract !=0 && BRSF_CTD_CR12_contract!=null ){
                   NewContactV0Contract.InvestmentCR12 = NewContactV0Contract.TradeExpenses/BRSF_CTD_CR12_contract;
                }
                
                
                if(NewContractV0Esitimate.TradeExpenses!=null && BRSF_CTD_CR12_estimate !=0 && BRSF_CTD_CR12_estimate !=null ){
                    NewContractV0Esitimate.InvestmentCR12 = NewContractV0Esitimate.TradeExpenses/BRSF_CTD_CR12_estimate;
                }


                
                //v0.0 estimate Margin AP
                if (NewContractV0Esitimate.TradeExpenses != null && TotalSubBrandCM_estimate != null)
                    NewContractV0Esitimate.MarginAfterAnP = TotalSubBrandCM_estimate - NewContractV0Esitimate.TradeExpenses;
                
                //v0.0 contract Margin AP
                if ( NewContactV0Contract.TradeExpenses!= null && TotalSubBrandCM_contract != null)
                    NewContactV0Contract.MarginAfterAnP= TotalSubBrandCM_contract -  NewContactV0Contract.TradeExpenses;
                
                //v0.0 estimate Margin per btl
                if (v0Estimate_totalBtl != null && v0Estimate_totalBtl != 0 && NewContractV0Esitimate.MarginAfterAnP != null && NewContractV0Esitimate.MarginAfterAnP!= 0)
                    NewContractV0Esitimate.MarginPerBottle = NewContractV0Esitimate.MarginAfterAnP / v0Estimate_totalBtl;
                
                //v0.0 contract Margin per btl
                if (v0Contract_totalBtl != null && v0Contract_totalBtl != 0 && NewContactV0Contract.MarginAfterAnP != null && NewContactV0Contract.MarginAfterAnP != 0)
                    NewContactV0Contract.MarginPerBottle = NewContactV0Contract.MarginAfterAnP / v0Contract_totalBtl ;
                
                //v0.0 estimate ROI
                if (NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses != null && TotalSubBrandCM_estimate != null && TotalSubBrandCM_estimate != 0){
                    //vALLROI.v0 = TotalSubBrandCM_estimate / NewContractV0Esitimate.TradeExpenses; //NewContractV0Esitimate.TradeExpenses----->v0_EstCost
                    NewContractV0Esitimate.ROIIntake = TotalSubBrandCM_estimate / NewContractV0Esitimate.TradeExpenses; //v0_EstCost
                }
                
                //v0.0 contract ROI
                if ( NewContactV0Contract.TradeExpenses != 0 &&  NewContactV0Contract.TradeExpenses != null && TotalSubBrandCM_contract != null && TotalSubBrandCM_contract != 0){
                    NewContactV0Contract.ROIIntake = TotalSubBrandCM_contract /  NewContactV0Contract.TradeExpenses;
                }
                
                
                
                // v0.0 Pro-Forma ROI
                if ( NewContactV0Contract.TradeExpenses!= 0 &&  NewContactV0Contract.TradeExpenses != null && TotalSubBrand_LBCM_contract != null && TotalSubBrand_LBCM_contract != 0){
                    NewContactV0Contract.ROIProForma = TotalSubBrand_LBCM_contract /  NewContactV0Contract.TradeExpenses;
                }
                //v0.0 Pro-Forma estimate ROI
                if (NewContractV0Esitimate.TradeExpenses != 0 && NewContractV0Esitimate.TradeExpenses != null && TotalSubBrand_LBCM_estimate != null && TotalSubBrand_LBCM_estimate != 0){
                    NewContractV0Esitimate.ROIProForma= TotalSubBrand_LBCM_estimate / NewContractV0Esitimate.TradeExpenses;  //NewContractV0Esitimate.TradeExpenses----->v0_EstCost
                }
                
            }
            
            
        }
        
        return ContractAmount;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public void LoopingPaymentRequestLine(){
        Map<String,ASI_CRM_Module__c> ModuleMap= new Map<String,ASI_CRM_Module__c>(); 
        for(ASI_CRM_Module__c Module: [select Id,ASI_CRM_Parent_Module__r.ASI_CRM_Payment_Reference__c,ASI_CRM_Methodology__r.ASI_CRM_Chinese_Name__c,ASI_CRM_Parent_Module__c,ASI_CRM_Payment_Reference__c,ASI_CRM_Parent_Module__r.ASI_CRM_Remark__c,ASI_CRM_Parent_Module__r.ASI_CRM_Reason_NCD_Volume_Base__c,ASI_CRM_Parent_Module__r.ASI_CRM_Reason_Not_NCD_Methodology__c,ASI_CRM_Methodology__r.ASI_CRM_Methodology_Code__c,ASI_CRM_End_Date__c,ASI_CRM_Parent_Module__r.ASI_CRM_Unit__c,ASI_CRM_Parent_Module__r.ASI_CRM_Volume_Base__c,ASI_CRM_Other_Comments__c,ASI_CRM_Overpayment_Reason__c,ASI_CRM_Actual_Payment__c,ASI_CRM_Adjustment__c,ASI_CRM_Application_Payment_Amount__c,ASI_CRM_Historical_Paid_Amount__c, ASI_CRM_Line_Type__c,ASI_CRM_Remark__c,ASI_CRM_Unit__c,ASI_CRM_Volume_Base__c,ASI_CRM_Methodology__c,ASI_CRM_Methodology__r.Name,ASI_CRM_Reason_Not_NCD_Methodology__c,ASI_CRM_Reason_NCD_Volume_Base__c 
                                       from ASI_CRM_Module__c where ASI_CRM_Payment_Request__c =:thisPR.Id AND (ASI_CRM_Line_Type__c='PSF' or ASI_CRM_Line_Type__c='BRSF')])
        {
            if(Module.ASI_CRM_Line_Type__c=='BRSF'){
                if(Module.ASI_CRM_End_Date__c!=null){
                    DisplayBRSFPart=true;
                }
                interimData TempData= new interimData(Module);
                BRSFItemMap=TempData;
            }
            if(Module.ASI_CRM_Line_Type__c=='PSF'){
                interimData TempData= new interimData(Module);
                if(Module.ASI_CRM_End_Date__c!=null){
                     PSF_Item_Map.put(Module.ID,TempData);
                }
               
                
            }
            ModuleMap.put(Module.Id,Module);
        }
        
        
        for(ASI_TH_CRM_PaymentRequestLineItem__c payline:[SELECT id, ASI_CRM_Suggested_Value__c ,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c,ASI_TH_CRM_Payment_Request__c,ASI_CRM_Volume_Base__c ,
                                                          ASI_CRM_Product_Category__c,ASI_CRM_Sub_Brand_Grade__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,
                                                          ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,
                                                          ASI_CRM_CTD_Actual_Vol__c , ASI_CRM_CN_Standard__c ,ASI_CRM_CTD_Cap_Collection_Vol__c ,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c,
                                                          ASI_CRM_CN_Payable_Vol__c  , ASI_CRM_Key_Sub_Brand__c, ASI_CRM_CN_Completion_Rate__c, 
                                                          ASI_CRM_V0_0_Full_Contract_Target__c, ASI_CRM_CN_Total_Payable__c , ASI_CRM_CN_Actual_Vol__c , 
                                                          ASI_CRM_CN_Bottle_Collected__c, ASI_CRM_CN_Collection_Rate__c ,ASI_CRM_CN_Incentive_BT__c , ASI_CRM_CN_Allow_Changing_Incentive__c , 
                                                          ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_Module__c ,ASI_CRM_CN_Sub_Brand__c,RecordType.DeveloperName, 
                                                          ASI_CRM_CN_Expense_Type__c, ASI_CRM_CN_Comment__c, ASI_TH_CRM_Amount__c, ASI_CRM_CN_Remaining_Amount__c, recordtypeid , ASI_CRM_CNY_Est__c,
                                                          ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c, ASI_TH_CRM_Payment_Request__r.ASI_CRM_CN_Promotion_Type__c, ASI_CRM_CN_AC_Code__c
                                                          FROM ASI_TH_CRM_PaymentRequestLineItem__c 
                                                          WHERE ASI_TH_CRM_Payment_Request__c =:thisPR.id ])
        {
            if(payline.ASI_CRM_Module__c !=null){
                if(payline.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_BRSF'){
                    BRSFItemMap.TotalIntake+=payline.ASI_CRM_CTD_Actual_Vol__c!=null?payline.ASI_CRM_CTD_Actual_Vol__c:0;
                    BRSFItemMap.TotalBC+=payline.ASI_CRM_CTD_Cap_Collection_Vol__c!=null?payline.ASI_CRM_CTD_Cap_Collection_Vol__c:0;
                    BRSFItemMap.DetailLineMap.put(payline.ASI_CRM_CN_Sub_Brand__c,payline);
                    
                    //ASI_CRM_V0_0_Full_Contract_Target__c
                }else if(payline.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_PSF'){
                    if(PSF_Item_Map.containsKey(payline.ASI_CRM_Module__c)){
                        PSF_Item_Map.get(payline.ASI_CRM_Module__c).DetailLineMap.put(payline.Id,payline);
                    }
                }
                
            }
            
        }
        
        
        if(PSF_Item_Map.size()>0){
            DisplayPSFPart=true;
        }
        
        if(BRSFItemMap.TotalIntake!=null && BRSFItemMap.TotalIntake!=0 && BRSFItemMap.TotalBC!=null ){
            BRSFItemMap.BCRate = (BRSFItemMap.TotalBC / BRSFItemMap.TotalIntake)*100;
        }
        if(BRSFItemMap.Module.ASI_CRM_End_Date__c !=null){
            BRSFmonthsBetween =  ContractSelected.ASI_CRM_CN_PO_Start_Date__c.monthsBetween(BRSFItemMap.Module.ASI_CRM_End_Date__c);
                //BRSFItemMap.Module.ASI_CRM_End_Date__c.monthsBetween(ContractSelected.ASI_CRM_CN_PO_Start_Date__c);
            BRSFmonthsBetween= BRSFmonthsBetween+1;
        }
        
    }
    
    
    
    //Get all Payment Amount(Approved/Submitted/Paid) 
    public decimal RetrieveTotalPaidAmount(){
        
        decimal allPaymentTotal = 0;
        //Query all payment request with vFinal contract
        list<ASI_TH_CRM_PaymentRequest__c> AllPaymentRequest = new list<ASI_TH_CRM_PaymentRequest__c>();
        try{
            AllPaymentRequest = [SELECT Id,Name,ASI_CRM_CN_Total_VEC_Amount__c,
                                 ASI_CRM_Total_Variable_Amount__c,ASI_CRM_CN_Promotion_Type__c,ASI_CRM_CN_Total_BRSF_Amount__c, ASI_CRM_CN_Total_PSF_Amount__c,
                                 ASI_CRM_CN_Total_Other_Amount__c,ASI_TH_CRM_Contract__c, ASI_CRM_CN_Total_Payment__c
                                 FROM ASI_TH_CRM_PaymentRequest__c
                                 WHERE ASI_TH_CRM_Contract__c =:thisPR.ASI_TH_CRM_Contract__c
                                 AND (id = :thisPR.id OR ASI_TH_CRM_Status__c = 'Approved' OR ASI_TH_CRM_Status__c = 'Submitted'  OR ASI_TH_CRM_Status__c = 'Paid')];
        }catch(exception e){
            String msg = 'Save Error : ' +e.getMessage() + '</br>';
            ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyPaymentCheckCtrl. RetrieveTotalPaidAmount  class have Error  '+msg,'ASI_CRM_CN_HeavyContractUtilitiesClass',' function failed! with Payment Id: '+thisPR.id );
        }
        
        //Sum up previous payments amounts
        if (AllPaymentRequest.size() > 0){
            for (ASI_TH_CRM_PaymentRequest__c allPR_temp : AllPaymentRequest){
                if (allPR_temp.ASI_CRM_CN_Total_Payment__c != null){
                    allPaymentTotal += allPR_temp.ASI_CRM_CN_Total_Payment__c;
                    
                    if(allPR_temp.ASI_CRM_CN_Promotion_Type__c=='Heavy Contract On'){
                        if(allPR_temp.Name.length()>3 && (allPR_temp.Name.substring(allPR_temp.Name.length()-3, allPR_temp.Name.length()) == '000')){///000-Payment
                            TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c:0;
                            TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c:0;
                            TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c:0;
                        }else{
                            TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_Total_Variable_Amount__c!=NULL?allPR_temp.ASI_CRM_Total_Variable_Amount__c:0;
                        }
                        
                    }else{
                        TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c:0;
                        TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c:0;
                        TotalPaymentVariableAmount+=allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c:0;
                    }
                    
                }
            }
        }
        return allPaymentTotal;
    }
    
    
    
    
    //Looping Fix cost 
    Public Decimal CalculateV0FixCostAmount(){
        Decimal FixCostAmount=0;
        String V0ContractId=GenerateV0ContractId();
        list<ASI_CRM_Contract_Cost__c>  v0_EstCostList = new list<ASI_CRM_Contract_Cost__c>();
        try{
            v0_EstCostList = [SELECT Id,Name,ASI_CRM_CN_Estimate_Amount__c, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Amount__c 
                              FROM ASI_CRM_Contract_Cost__c 
                              WHERE ASI_CRM_CN_Contract__c = :V0ContractId and ASI_CRM_CN_Cost_Type__c='Fixed'];
        }catch(exception e){
            system.debug('Try v0_EstCostList failed: ' + e);
        }
        
        
        if (v0_EstCostList.size() > 0){
            for (ASI_CRM_Contract_Cost__c V0ContractCost : v0_EstCostList){
                FixCostAmount += V0ContractCost.ASI_CRM_CN_Contract_Amount__c!=null?V0ContractCost.ASI_CRM_CN_Contract_Amount__c:0;
                NewContractV0Esitimate.TradeExpenses+= V0ContractCost.ASI_CRM_CN_Estimate_Amount__c!=null?V0ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                NewContactV0Contract.TradeExpenses+= V0ContractCost.ASI_CRM_CN_Contract_Amount__c!=null?V0ContractCost.ASI_CRM_CN_Contract_Amount__c:0;
                if (V0ContractCost.ASI_CRM_CN_Cost_Type__c == 'Variable'){
                    NewContractV0Esitimate.VariableExpense+= V0ContractCost.ASI_CRM_CN_Estimate_Amount__c!=null? V0ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                    NewContactV0Contract.VariableExpense+= V0ContractCost.ASI_CRM_CN_Contract_Amount__c!=null? V0ContractCost.ASI_CRM_CN_Contract_Amount__c:0;
                }else if (V0ContractCost.ASI_CRM_CN_Cost_Type__c == 'Fixed'){
                    
                    NewContractV0Esitimate.FixedExpense+= V0ContractCost.ASI_CRM_CN_Estimate_Amount__c!=null? V0ContractCost.ASI_CRM_CN_Estimate_Amount__c:0;
                    
                    NewContactV0Contract.FixedExpense+= V0ContractCost.ASI_CRM_CN_Contract_Amount__c!=null? V0ContractCost.ASI_CRM_CN_Contract_Amount__c:0;
                }
            }
        }
        return FixCostAmount;
    }
    
    
    
    //generate V0.0 Contract Id
    public String GenerateV0ContractId(){
        string V0ContractId='';
        if(thisPR.ASI_TH_CRM_Contract__c!=null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c!=null){
            V0ContractId=thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c;
        }else if(thisPR.ASI_TH_CRM_Contract__c!=null){
            V0ContractId=thisPR.ASI_TH_CRM_Contract__c;
        }
        return V0ContractId;
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
    
    
    public String NameSortingASC(decimal strSeq){
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
            if (startDate.Month() < 7 && startDate.Month() > 0){
                StartFY = startDate.Year();
            }
            if (endDate.Month() > 6 && endDate.Month() < 13){
                EndFY = endDate.Year() + 1;
            }
            if (endDate.Month() < 7 && endDate.Month() > 0){
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
            return returnDateMap;
        }else{
            return null;
        }
    }
    
     public static integer MonthDiff(date startDate, date endDate){ 
        Integer monthDiff;
        if (startDate != null && endDate != null){
            monthDiff = ((endDate.YEAR() - startDate.YEAR() - 1) *12) + (12 - startDate.MONTH() +1) + endDate.MONTH();
            return monthDiff;
        }else{
            return null;
        }
    }
    
    
    
    //*******************************************************************************************************
    //* @description custom class for Line Detail
    // ********************************************************************************************************
    public Class interimData{
        public ASI_CRM_Module__c Module {set;get;} 
        public String MethodologyValue  {set;get;} 
        public map<String, ASI_TH_CRM_PaymentRequestLineItem__c> DetailLineMap{set;get;}
        public Decimal TotalIntake {set;get;}{TotalIntake=0;}
        public Decimal TotalBC {set;get;}{TotalBC=0;}
        public Decimal BCRate {set;get;}{BCRate=0;}
        
        public interimData(){
            Module=new ASI_CRM_Module__c();
            MethodologyValue='';
            DetailLineMap= new map<String, ASI_TH_CRM_PaymentRequestLineItem__c>();
        }
        
        public interimData( ASI_CRM_Module__c ModuleInput){
            Module=ModuleInput;
            MethodologyValue=ModuleInput.ASI_CRM_Methodology__r.Name;
            DetailLineMap= new map<String, ASI_TH_CRM_PaymentRequestLineItem__c>();
        }
        
        public interimData( ASI_CRM_Module__c ModuleInput,boolean ClickRefresh){
            Module=ModuleInput;
            MethodologyValue=ModuleInput.ASI_CRM_Methodology__r.Name;
            DetailLineMap= new map<String, ASI_TH_CRM_PaymentRequestLineItem__c>();
            
        }
    }
    
    
    public Class VolumeObject{
        //V0.0 Full Contract Target/合同销量目标
        
        public Decimal FullContractTarget {set;get;}{FullContractTarget=0;}
        //Actual Performance
        public Decimal CTDActualVol {set;get;}{CTDActualVol=0;}
        public String SubBrandGradeName {set;get;}{SubBrandGradeName='';}
        public String SubBrandGradeCNName {set;get;}{SubBrandGradeCNName='';}
        public VolumeObject(){
            
        }
    }
    
}