public class ASI_CRM_CN_HeavyPaymentUtilitiesClass {
    
    
    
    
    //key performance indicators
    public static void PaymentKPICalculation(ASI_TH_CRM_PaymentRequest__c PaymentRequest ){
        Map<String,Decimal> PaymentKPIMap= new Map<String,Decimal>();
        
        //KPI 
        Decimal FixedCostTotal = 0 ; 
        Decimal VariableCostTotal=0;
        Decimal PaymentSpeed = 0 ;
        Decimal VolumeSpeed=0;
        
        
        
        //Payment Speed
        Decimal TotalPaymentAmount = ASI_CRM_CN_HeavyContractUtilitiesClass.RetrieveTotalPaidAmount(PaymentRequest);
        Decimal v0_Cost = 0;
        Decimal V0ContractVolume=0;
        Decimal ActualIntake=0;
        
        //Min Key Strategy sub-brands achievement% should greater or equal to total volume achievement%.
        Decimal  MKSSBAR=9999999;// Min Key Strategy SubBrand Achievement Rate 
        
        for(ASI_TH_CRM_PaymentRequestLineItem__c PaymentLine: [Select id, name,ASI_CRM_CN_Completion_Rate__c, ASI_CRM_Key_Sub_Brand__c , ASI_CRM_Volume_Base__c,RecordType.DeveloperName, recordtypeid, ASI_TH_CRM_Amount__c,ASI_CRM_CN_AC_Code__r.ASI_MFM_A_C_Description__c, ASI_CRM_CN_Expense_Type__c, ASI_CRM_CN_AC_Code__c  
                                                               from ASI_TH_CRM_PaymentRequestLineItem__c 
                                                               where ASI_TH_CRM_Payment_Request__c = :PaymentRequest.Id ])
        {//and  RecordType.DeveloperName='ASI_CRM_CN_Payment_Request_Detail_Other' 
            if(PaymentLine.RecordType.DeveloperName =='ASI_CRM_CN_Payment_Request_Detail_Other'){
                FixedCostTotal+=PaymentLine.ASI_TH_CRM_Amount__c !=null? PaymentLine.ASI_TH_CRM_Amount__c:0;
            }
            if(PaymentLine.RecordType.DeveloperName =='ASI_CRM_CN_Payment_Request_Detail_PSF' && PaymentLine.ASI_CRM_Volume_Base__c!=null && PaymentLine.ASI_CRM_CN_Completion_Rate__c !=null && PaymentLine.ASI_CRM_Volume_Base__c=='By Sub-Brand'   && PaymentLine.ASI_CRM_Key_Sub_Brand__c ){
               PaymentKPIMap.put('Key Strategy sub-brands', 1);
                if(PaymentLine.ASI_CRM_CN_Completion_Rate__c<MKSSBAR){
                    MKSSBAR=PaymentLine.ASI_CRM_CN_Completion_Rate__c;
                }
            }
        }
        
        
        PaymentKPIMap.put('MKSSBAR', MKSSBAR);
        
        
        for(ASI_CRM_Module__c module:PaymentRequest.ASI_CRM_Modules__r){
            VariableCostTotal+=module.ASI_CRM_Actual_Payment__c!=null? module.ASI_CRM_Actual_Payment__c:0;
            
            if(module.ASI_CRM_Line_Type__c=='PSF' && module.ASI_CRM_Volume_Base__c=='By Sub-Brand'){
                PaymentKPIMap.put('PSFBySubBrandAchievementRate', module.ASI_CRM_Completion_Ratio__c);
            }
            
        }
        
        
        
        String V0ContractId='';
        if(PaymentRequest.ASI_TH_CRM_Contract__c!=null && PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c!=null){
            V0ContractId=PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c;
        }else if(PaymentRequest.ASI_TH_CRM_Contract__c!=null){
            V0ContractId=PaymentRequest.ASI_TH_CRM_Contract__c;
        }
        
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> contractDetailList=[SELECT id, ASI_CRM_Type__c,ASI_CRM_CN_Contract_Total_Dummy__c,ASI_CRM_CN_Est_Total_Dummy__c,
                                                                        ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, 
                                                                        ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Chinese_Name__c,
                                                                        ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c, 
                                                                        ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Est_Monthly_Qty__c , ASI_CRM_CN_Sub_Brand_Conversion_Factor__c,
                                                                        ASI_CRM_CN_Contract__c, ASI_CRM_CN_Estimate_Volume_9L_Month__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c,
                                                                        ASI_CRM_CN_Contract_Monthly_Vol9L__c, ASI_CRM_CN_Contract_Monthly_Qty__c,
                                                                        ASI_CRM_CN_Contract_BRSF_Per_Bottle__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Standard_Bottle_Size__c,
                                                                        ASI_CRM_CN_Contract__r.ASI_CRM_CN_PO_Version__c
                                                                        FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :V0ContractId];
        
        Set<Id> SubBrandIdSet = new Set<Id> ();
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractDetail:contractDetailList){
            if(ContractDetail.ASI_CRM_Type__c=='BRSF'){
                SubBrandIdSet.add(ContractDetail.ASI_CRM_CN_Sub_Brand__c);
            }
        }
        
        Map<String,Decimal> CR12FactorMap = new Map<String,Decimal> ();
        if(SubBrandIdSet.size()>0){
            CR12FactorMap=ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateCR12FactorMap(SubBrandIdSet,
                                                                                       PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,
                                                                                       PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c);
        }
        
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c contractDetail:contractDetailList)
        {
            v0_Cost+= contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c!=null? contractDetail.ASI_CRM_CN_Contract_Total_Dummy__c:0;
            if(contractDetail.ASI_CRM_Type__c=='BRSF'){
                Decimal CR12Factor=1;
                if(CR12FactorMap.containsKey(contractDetail.ASI_CRM_CN_Sub_Brand__c)){
                    CR12Factor=CR12FactorMap.get(contractDetail.ASI_CRM_CN_Sub_Brand__c);
                }
                V0ContractVolume+=CR12Factor*contractDetail.ASI_CRM_CN_Contract_Monthly_Qty__c * contractDetail.ASI_CRM_CN_No_of_Months__c;
            }
        }
        
        
        
        if (v0_Cost != null && v0_Cost !=0 && TotalPaymentAmount != null && TotalPaymentAmount != 0){
            system.debug('Now TotalPaymentAmount'+ TotalPaymentAmount);
            system.debug('Now v0_Cost'+ v0_Cost);
            PaymentSpeed = TotalPaymentAmount / v0_Cost * 100;
        }
        
        
        ///*******************Calculate Volume Speed*******************************************************************
        list<ASI_CRM_CN_Covered_Outlet__c> CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
        try{
            CoveredOutlet = [SELECT ASI_CRM_CN_Outlet__c
                             FROM ASI_CRM_CN_Covered_Outlet__c
                             WHERE ASI_CRM_CN_Contract__c = :PaymentRequest.ASI_TH_CRM_Contract__c];
        }catch(exception e){
            CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
        }  
        
        set<id> AllOutlet = new set<id>();
        //ASI_TH_CRM_PaymentRequest__c tempPR = [SELECT id, ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c FROM ASI_TH_CRM_PaymentRequest__c WHERE id = :thisPR.id]; 
        if (PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Normal' || PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Wholesaler Only' || PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == null ){
            AllOutlet.add(PaymentRequest.ASI_CRM_CN_OutletWS__c);
        }
        if (PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Normal' || PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Covered Outlet Only' || PaymentRequest.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == null ) {
            if (CoveredOutlet.size() > 0){
                for (ASI_CRM_CN_Covered_Outlet__c CO_temp: CoveredOutlet){
                    AllOutlet.add(CO_temp.ASI_CRM_CN_Outlet__c);
                }
            }
        }
        
        list<ASI_CRM_Subbrand_Volume__c> SB_Vol_List = new list<ASI_CRM_Subbrand_Volume__c> ();
        date TillEnd = ASI_CRM_CN_HeavyContractUtilitiesClass.getEndDate(ASI_CRM_CN_HeavyContractUtilitiesClass.FindMinMaxDate(ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateCutOffDate(), PaymentRequest.ASI_CRM_CN_PO_End_Date__c, 'MIN'));
        system.debug('SB Vol TillEnd : '+TillEnd);
        try{
            SB_Vol_List = [SELECT Id,Name,ASI_CRM_T1_Depletion_Std_Billing__c,ASI_CRM_DeductibleCapWithIssues_Std_Btl__c, ASI_CRM_T1_Depletion_CR12__c,ASI_CRM_T2_Depletion_Std_Billing__c, ASI_CRM_T2_Depletion_CR12__c,ASI_CRM_PR_Direct_Std_Billing__c, ASI_CRM_PR_Direct_CR12__c,ASI_CRM_End_Date__c, ASI_CRM_Subbrand__c, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.Name,ASI_CRM_Green_Cap_Std_Billing__c  , ASI_CRM_T1_Depletion__c, ASI_CRM_T2_Depletion__c,ASI_CRM_PR_Direct__c, ASI_CRM_Empty_Bottle_Std_Billing__c, ASI_CRM_Subbrand__r.Name, ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_T1_Depletion_STD__c, ASI_CRM_T2_Depletion_STD__c,ASI_CRM_PR_Direct_STD__c, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_CRM_CN_Chinese_Name__c, ASI_CRM_Green_Cap_STD__c, ASI_CRM_Empty_Bottle_Std_Btl__c, ASI_CRM_Offtake_Std_Billing__c 
                           FROM ASI_CRM_Subbrand_Volume__c 
                           WHERE ASI_CRM_End_Date__c >= :PaymentRequest.ASI_CRM_CN_PO_Start_Date__c AND ASI_CRM_End_Date__c <= :TillEnd  AND ASI_CRM_CN_Competitor_Sub_brand__c != true
                           AND ASI_CRM_Account__c IN :AllOutlet and ASI_CRM_CN_Exclude_From_Payment_Volume__c =false and ASI_CRM_Subbrand__c !=null];
            
        }catch(exception e){
            SB_Vol_List = new list<ASI_CRM_Subbrand_Volume__c >();
        }
        
        if (SB_Vol_List.size() > 0){
            for (ASI_CRM_Subbrand_Volume__c SubBrandVolume : SB_Vol_List ){
                ActualIntake += SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c!=null?SubBrandVolume.ASI_CRM_T1_Depletion_CR12__c:0;
                ActualIntake += SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c!=null?SubBrandVolume.ASI_CRM_T2_Depletion_CR12__c:0;
                ActualIntake += SubBrandVolume.ASI_CRM_PR_Direct_CR12__c!=null?SubBrandVolume.ASI_CRM_PR_Direct_CR12__c:0;
                
            }
            
        }
        
        
        if (V0ContractVolume != null && V0ContractVolume !=0 && ActualIntake != null && ActualIntake != 0){
            system.debug('ActualIntake'+ActualIntake);
            system.debug('V0ContractVolume'+V0ContractVolume);
            VolumeSpeed = (ActualIntake / V0ContractVolume) * 100;
        }
        
        
        PaymentKPIMap.put('FixedCostTotal',FixedCostTotal);
        
        PaymentKPIMap.put('VariableCostTotal',VariableCostTotal);
        PaymentKPIMap.put('PaymentSpeed',PaymentSpeed);
        
        PaymentKPIMap.put('VolumeSpeed',VolumeSpeed);
        
        
        ASI_CRM_CN_HeavyContractUtilitiesClass.UpsertAttachment(PaymentRequest.ASI_TH_CRM_Contract__c, System.JSON.serialize(PaymentKPIMap),'Payment Data' );
    }
    
    
    
    
    
    
    
    
    public static void  ReconstructLastPaymentFIData(ASI_TH_CRM_PaymentRequest__c thisPR) {
        date strStart;
        Date CutOffDay=ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateCutOffDate();
        Map<String,VolumeObject> VolumeMap= new Map<String,VolumeObject>();
        
        ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator  ActualPerformance= new ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator(); 
        Map<String, String> sbGroup_map = new Map<String, String>();
        sbGroup_map.put('1. Standard + Premium / 标准档 + 高档', 'Standard + Premium / 标准档 + 高档');
        sbGroup_map.put('2. Super Premium / 超高档', 'Super Premium / 超高档');
        sbGroup_map.put('3. Ultra Premium / 特级高档', 'Ultra Premium / 特级高档');
        sbGroup_map.put('4. Prestige + Ultra Prestige / 奢华档 + 特级奢华档', 'Prestige + Ultra Prestige / 奢华档 + 特级奢华档');
        sbGroup_map.put('5. Not Specified / 未指定',  'Not Specified / 未指定');
        
        
        
        map<string, string> SubbrandGroup = new map<string, string>();
        SubbrandGroup.put('Premium', '1. Standard + Premium / 标准档 + 高档');
        SubbrandGroup.put('Standard', '1. Standard + Premium / 标准档 + 高档');
        SubbrandGroup.put('Prestige', '4. Prestige + Ultra Prestige / 奢华档 + 特级奢华档');
        SubbrandGroup.put('Ultra Prestige', '4. Prestige + Ultra Prestige / 奢华档 + 特级奢华档');
        SubbrandGroup.put('Super Premium', '2. Super Premium / 超高档');
        SubbrandGroup.put('Ultra Premium', '3. Ultra Premium / 特级高档');
        SubbrandGroup.put('Not Specified / 未指定','5. Not Specified / 未指定');
        
        map<string,decimal> RegionSubBrandCM_Map = new map<string,decimal>();
        
        
        for(String SBGName:sbGroup_map.keySet()){
            ActualPerformance.SubBrandGradeMap.put(SBGName,0.0); 
        }
        
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
            ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyPaymentCheckCtrl. RetrieveTotalPaidAmount  class have Error  '+'Save Error : ' +e.getMessage() + '</br>','ASI_CRM_CN_HeavyContractUtilitiesClass',' function failed! with Payment Id: '+thisPR.id );
        }
        
        //Sum up previous payments amounts
        if (AllPaymentRequest.size() > 0){
            for (ASI_TH_CRM_PaymentRequest__c allPR_temp : AllPaymentRequest){
                if (allPR_temp.ASI_CRM_CN_Total_Payment__c != null){
                    ActualPerformance.TradeExpenses += allPR_temp.ASI_CRM_CN_Total_Payment__c;
                    
                    if(allPR_temp.ASI_CRM_CN_Promotion_Type__c=='Heavy Contract On'){
                        ActualPerformance.VariableExpense +=allPR_temp.ASI_CRM_Total_Variable_Amount__c!=NULL?allPR_temp.ASI_CRM_Total_Variable_Amount__c:0;
                    }else{
                        ActualPerformance.VariableExpense +=allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_BRSF_Amount__c:0;
                        ActualPerformance.VariableExpense +=allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_PSF_Amount__c:0;
                        ActualPerformance.VariableExpense +=allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c!=NULL?allPR_temp.ASI_CRM_CN_Total_VEC_Amount__c:0;
                    }
                    
                }
            }
        }
        
        
        list<ASI_TH_CRM_PaymentRequestLineItem__c> PRLineItems = new list<ASI_TH_CRM_PaymentRequestLineItem__c>();
        try{
            //query All Payment Variable & Fixed Cost
            PRLineItems = [SELECT id, ASI_TH_CRM_Amount__c, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Total_Payable__c,ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c,
                           ASI_TH_CRM_Payment_Request__r.ASI_CRM_CN_Adjustment__c, RecordTypeId,RecordType.DeveloperName,ASI_CRM_Adjustment__c,
                           ASI_CRM_CN_Contract_Cost__r.ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Contract_Cost__c 
                           FROM ASI_TH_CRM_PaymentRequestLineItem__c WHERE ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c =:thisPR.ASI_TH_CRM_Contract__c and (ASI_TH_CRM_Payment_Request__c =:thisPR.id OR ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Approved' OR 
                                                                                                                                                                     ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Submitted'  OR
                                                                                                                                                                     ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c = 'Paid')];
        }catch(exception e){
            PRLineItems = new list<ASI_TH_CRM_PaymentRequestLineItem__c >();
        }
        
        for ( ASI_TH_CRM_PaymentRequestLineItem__c  li_temp : PRLineItems ){
            if(li_temp.RecordType.DeveloperName=='ASI_CRM_CN_Payment_Request_Detail_Other'){
                if(li_temp.ASI_CRM_CN_Cost_Type__c == 'Fixed' ){
                    ActualPerformance.FixedExpense += li_temp.ASI_TH_CRM_Amount__c!=null? li_temp.ASI_TH_CRM_Amount__c:0;
                }else{
                    ActualPerformance.VariableExpense+= li_temp.ASI_TH_CRM_Amount__c!=null? li_temp.ASI_TH_CRM_Amount__c:0;
                }
            }
        }
        if(ActualPerformance.TradeExpenses!=null && ActualPerformance.TradeExpenses !=0){
            ActualPerformance.FixedExpenseRate = (ActualPerformance.FixedExpense/ActualPerformance.TradeExpenses)*100;
        }
        
        
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
        
        
        
        decimal Vol_CR12_1 =0; //All Payment Period
        map<string, decimal> ActualCM_v1_map = new map<string, decimal>();
        map<string, decimal> ActualGS_v1_map= new map<string, decimal>();
        map<string, decimal> lbcm_v1_map= new map<string, decimal>();
        Decimal ActualIntakeTotal = 0;//for calculating bc%
        Decimal ActualBCTotal = 0;//for calculating bc%
        
        
        Decimal Total_MartellBC =0;  // total contract Martel BC
        Decimal Total_MartellIntakeBtl =0;  // total contract Martel Intake Btl
        Decimal Total_MartellBlackCap =0;  // total contract Martel BlackCap
        
        
        list<ASI_CRM_CN_Covered_Outlet__c> CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
        try{
            CoveredOutlet = [SELECT ASI_CRM_CN_Outlet__c
                             FROM ASI_CRM_CN_Covered_Outlet__c
                             WHERE ASI_CRM_CN_Contract__c = :thisPR.ASI_TH_CRM_Contract__c];
        }catch(exception e){
            CoveredOutlet = new list<ASI_CRM_CN_Covered_Outlet__c>();
        }  
        set<id> AllOutlet = new set<id>();
        
        if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Normal' || thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Wholesaler Only' || thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == null ){
            AllOutlet.add(thisPR.ASI_CRM_CN_OutletWS__c);
        }
        if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Normal' || thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == 'Covered Outlet Only' || thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_Volume_Option__c == null ) {
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
            SB_Vol_List = [SELECT Id,Name,ASI_CRM_Cap_with_Issues_Std_Billing__c,ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c,
                           ASI_CRM_T1_Depletion_Std_Billing__c,ASI_CRM_DeductibleCapWithIssues_Std_Btl__c, ASI_CRM_T1_Depletion_CR12__c,ASI_CRM_T2_Depletion_Std_Billing__c,
                           ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c,ASI_CRM_Subbrand__r.ASI_MFM_Sub_brand_External_ID__c,
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
        
        
        list<ASI_CRM_CM_GS__c> ActualCM_List = new list<ASI_CRM_CM_GS__c>();
        map<date, decimal> V1_Period_map = ASI_CRM_CN_HeavyContractUtilitiesClass.checkFYDayPeriod(thisPR.ASI_CRM_CN_PO_Start_Date__c, thisPR.ASI_CRM_CN_PO_End_Date__c);
        SYSTEM.debug('Now V1_Period_map: '+ V1_Period_map);
        map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data> v1_ROI_newMap = new map<string, ASI_CRM_CN_HeavyContractUtilitiesClass.subbrand_data>();
        
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
        
        //V0ContractId
        ASI_TH_CRM_Contract__c Contractv0 =new ASI_TH_CRM_Contract__c();
        
        date strEnd;
        String V0ContractId='';
        if(thisPR.ASI_TH_CRM_Contract__c!=null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c!=null){
            V0ContractId=thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c;
        }else if(thisPR.ASI_TH_CRM_Contract__c!=null){
            V0ContractId=thisPR.ASI_TH_CRM_Contract__c;
        }
        if (V0ContractId != null && V0ContractId != ''){
            Contractv0 = [SELECT ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_End_Date__c  FROM ASI_TH_CRM_Contract__c WHERE id = :V0ContractId];
        }
        if (Contractv0.ASI_CRM_CN_PO_Start_Date__c !=null ){
            strStart = Contractv0.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
        }else{
            strStart = thisPR.ASI_CRM_CN_PO_Start_Date__c.addYears(-1);
        }
        
        
        strStart=ASI_CRM_CN_HeavyContractUtilitiesClass.getEndDate(strStart);
        
        system.debug('234'+v1_sbid_set+'ActualCM Now strStart '+strStart);
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
        
        //Looping Sub-brand Volume
        for (ASI_CRM_Subbrand_Volume__c  SB_Vol_temp : SB_Vol_List){
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
            ActualBCTotal += ActualBC_std ;
            
            if( ASI_CRM_CN_HeavyPaymentUtilitiesClass.IsMartellSubBrandOrNot(SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c) ){
                system.debug('Now Martell: ActualBC_std: '+ActualBC_std + ' MarginUseTotalVol_std : ' + MarginUseTotalVol_std);
                Total_MartellBC += ActualBC_std;
                Total_MartellIntakeBtl+=MarginUseTotalVol_std;
                Total_MartellBlackCap += SB_Vol_temp.ASI_CRM_Cap_with_Issues_Std_Billing__c != null? SB_Vol_temp.ASI_CRM_Cap_with_Issues_Std_Billing__c:0;   
            }
            
            
            
            
            String Mapkeystr= ASI_CRM_CN_HeavyContractUtilitiesClass.NameSortingASC(SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__r.ASI_CRM_CN_Sequence__c)+SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_CRM_CN_Sub_brand_Grade__c;
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
        
        
        
        if(ActualBCTotal != null && ActualBCTotal != 0 && ActualIntakeTotal != null && ActualIntakeTotal != 0){
            ActualPerformance.BCRate = (ActualBCTotal / ActualIntakeTotal)*100;
        }
        
        if(Total_MartellBC != null && Total_MartellBC != 0 && Total_MartellIntakeBtl != null && Total_MartellIntakeBtl != 0){
            system.debug('Now TotalHistorical_MartellBC : '+Total_MartellBC);
            system.debug('Now TotalHistorical_MartellIntakeBtl : '+Total_MartellIntakeBtl);
            ActualPerformance.TotalMBCRate = (Total_MartellBC / Total_MartellIntakeBtl)*100;
            ActualPerformance.NetMBCRate= ( (Total_MartellBC - Total_MartellBlackCap ) / Total_MartellIntakeBtl)*100;
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
            if (ActualPerformance.TradeExpenses != 0 && ActualPerformance.TradeExpenses != null && totalsb_cm_v1 != null && totalsb_cm_v1 != 0){
                ActualPerformance.CMTotal=totalsb_cm_v1;
                ActualPerformance.ROIIntake= totalsb_cm_v1 / ActualPerformance.TradeExpenses;
            }
            
            
            if(Vol_CR12_1!=null && Vol_CR12_1 !=0 && ActualPerformance.TradeExpenses !=null && ActualPerformance.TradeExpenses!=0 ){
                ActualPerformance.InvestmentCR12 = ActualPerformance.TradeExpenses/Vol_CR12_1;
            }
            //vFinal Actual Margin AP
            if (ActualPerformance.TradeExpenses != null && totalsb_cm_v1 != null){
                ActualPerformance.MarginAfterAnP = totalsb_cm_v1 - ActualPerformance.TradeExpenses;
            }
            
            
            //vFinal Actual Margin per Btl
            if (ActualIntakeTotal != null && ActualIntakeTotal != 0 &&  ActualPerformance.MarginAfterAnP!= null &&  ActualPerformance.MarginAfterAnP != 0){
                ActualPerformance.MarginPerBottle =  ActualPerformance.MarginAfterAnP / ActualIntakeTotal ;
            }
            
            //vFinal Actual Pro-Forma ROI
            if (ActualPerformance.TradeExpenses != 0 && ActualPerformance.TradeExpenses != null && totalsb_lbcm_v1 != null && totalsb_lbcm_v1 != 0){
                ActualPerformance.LatestBudgetCMTotal=totalsb_lbcm_v1;
                ActualPerformance.ROIProForma = totalsb_lbcm_v1 / ActualPerformance.TradeExpenses;
            }
            
        }
        
        
        //**Finish 
        List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> RetuenList = new List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator>();
        RetuenList.add(ActualPerformance);
        ASI_CRM_CN_HeavyContractUtilitiesClass.UpsertAttachment(thisPR.ASI_TH_CRM_Contract__c, System.JSON.serialize(RetuenList),'Last Payment Data' );
    }
    
    
    
    
    
    public Static date getFiscalYearStart(Date inputDate){        
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        Date fiscalYearStart;
        if(inputDate != null){            
            fiscalYearStart = Date.newinstance(inputDate.year(), orgFiscalMonth, 1);
            if(inputDate.month() < orgFiscalMonth && inputDate.year() == inputDate.year())
                fiscalYearStart = fiscalYearStart.addYears(-1);
        }
        System.debug(inputDate + '/' + fiscalYearStart);
        return fiscalYearStart;
    }
    
    
    //******************Last Payment Auto PO Modification*****************
    public Static void LastPaymentAutoPOModification(ASI_TH_CRM_Contract__c Contract,Date PaymentCutOffDate){
        //clone contract as archived po
        ASI_TH_CRM_Contract__c ContractCloned  =ASI_CRM_CN_HeavyContractUtilitiesClass.ArchivePO(Contract);
        
        
        //****update exsiting PO****
        Contract.ASI_CRM_CN_Last_PO_version__c=ContractCloned.id;
        
        
        
        //Contract.ASI_CRM_CN_Status__c = 'Final';
        if(Contract.ASI_CRM_CN_PO_Version__c=='0.0'){
            Contract.ASI_CRM_CN_V0_0_PO_version__c=ContractCloned.id;
        }
        List<String> poVersionSplit = contract.ASI_CRM_CN_PO_Version__c.split('\\.',0);
        if(poVersionSplit != null && poVersionSplit.size() ==2){
            Contract.ASI_CRM_CN_PO_Version__c = poVersionSplit[0] + '.' + String.valueOf(Integer.valueOf(poVersionSplit[1])+1);
        }
        //Set cut off Date
        if(PaymentCutOffDate!=null){
           Contract.ASI_CRM_CN_PO_End_Date__c =PaymentCutOffDate;
        }else{
           Contract.ASI_CRM_CN_PO_End_Date__c = ASI_CRM_CN_HeavyContractUtilitiesClass.GenerateCutOffDate();
        }
        
        
        if(Contract.ASI_CRM_CN_PO_Start_Date__c != null){
            if(Contract.ASI_CRM_CN_PO_Start_Date__c <getFiscalYearStart(system.today()).addYears(1)){ 
                Contract.ASI_CRM_CN_Effective_Date__c=getFiscalYearStart(System.today());
            }
            else{
                Contract.ASI_CRM_CN_Effective_Date__c=getFiscalYearStart(Contract.ASI_CRM_CN_PO_Start_Date__c);
            }
        }else{
            Contract.ASI_CRM_CN_Effective_Date__c=getFiscalYearStart(System.today());
        }
        
        
        
        Contract.ASI_CRM_Copied_From__c=ContractCloned.Id; // Previous Contract
        Contract.ASI_TH_CRM_Start_Date__c = null;
        Contract.ASI_TH_CRM_End_Date__c = null;
        Contract.ASI_CRM_Reject_Return_Comments__c = '';
        Contract.ASI_CRM_CN_Return_Comments__c = '';
        Contract.ASI_CRM_CN_Last_Approved_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Approved_Date__c = NULL;
        Contract.ASI_CRM_CN_Last_Recall_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Recall_Date__c = NULL;
        Contract.ASI_CRM_CN_Last_Rejected_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Rejected_Date__c = NULL;
        Contract.ASI_CRM_CN_Last_Submitted_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Submitted_Date__c = NULL;
        Contract.ASI_CRM_Auto_PO_Modification_Time__c= Datetime.now();
        Contract.ASI_CRM_CN_PO_Modification__c = true;
        //Contract.ASI_CRM_CN_Contract_Upload__c=False;
        update Contract;
        
        
        ASI_TH_CRM_Contract__c SelectContract= [select Id,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_Auto_PO_Modification__c,ASI_CRM_CN_Effective_Date__c,ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Description__c,ASI_CRM_Copied_From__c,ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_CN_PO_Version__c,ASI_CRM_CN_Contract_Upload__c,ASI_CRM_V0_PSF_Contract_Total__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_Expected_V0_PSF_Estimated_Total__c,ASI_CRM_Previous_Version_PSF_Est_Total__c,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,ASI_CRM_Expected_V0_0_VEC_Est_Total__c,ASI_CRM_Expected_V0_BRSF_Estimated_Total__c,ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,ASI_CRM_CN_Expected_BRSF_Est_Total__c,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grand_Estimate_Total__c
                                                from ASI_TH_CRM_Contract__c WHERE id =:Contract.Id ];
        
        
        //****************** get Payment info **************************************************
        Decimal BRSFPaidAmount=0;
        Decimal PSFPaidAmount=0;
        Decimal VECPaidAmount=0;
        Map<String,Decimal> FixedCostMap= new Map<String,Decimal>();
        
        for(ASI_TH_CRM_PaymentRequestLineItem__c payline:[SELECT id, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_Sub_Brand_Grade_Sequence__c,ASI_CRM_Sub_Brand_Grade__r.ASI_CRM_CN_Sequence__c,
                                                          ASI_CRM_Over_Incentive__c,ASI_CRM_Suggested_Value__c,ASI_CRM_Module__r.ASI_CRM_Parent_Module__c,ASI_CRM_Product_Category__r.ASI_HK_CRM_Sequence__c,
                                                          ASI_TH_CRM_Payment_Request__c,ASI_CRM_Volume_Base__c ,ASI_CRM_Product_Category__c,ASI_CRM_Sub_Brand_Grade__c, ASI_CRM_CTD_Actual_Vol__c , ASI_CRM_CN_Standard__c ,ASI_CRM_CTD_Cap_Collection_Vol__c , ASI_CRM_CN_Payable_Vol__c  , ASI_CRM_Key_Sub_Brand__c, ASI_CRM_CN_Completion_Rate__c, ASI_CRM_V0_0_Full_Contract_Target__c, ASI_CRM_CN_Total_Payable__c , ASI_CRM_CN_Actual_Vol__c , ASI_CRM_CN_Bottle_Collected__c, ASI_CRM_CN_Collection_Rate__c ,ASI_CRM_CN_Incentive_BT__c , ASI_CRM_CN_Allow_Changing_Incentive__c , ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name, ASI_CRM_Module__c ,ASI_CRM_CN_Sub_Brand__c,RecordType.DeveloperName, ASI_CRM_CN_Expense_Type__c, ASI_CRM_CN_Comment__c, ASI_TH_CRM_Amount__c, ASI_CRM_CN_Remaining_Amount__c, recordtypeid , ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c, ASI_TH_CRM_Payment_Request__r.ASI_CRM_CN_Promotion_Type__c, ASI_CRM_CN_AC_Code__c 
                                                          FROM ASI_TH_CRM_PaymentRequestLineItem__c 
                                                          WHERE ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Contract__c =:contract.Id 
                                                          and ASI_TH_CRM_Payment_Request__r.ASI_TH_CRM_Status__c!='Draft' and
                                                          RecordType.DeveloperName='ASI_CRM_CN_Payment_Request_Detail_Other' ])
        {
            if(payline.ASI_CRM_CN_AC_Code__c!=null && payline.ASI_TH_CRM_Amount__c!=null){
                if(FixedCostMap.containsKey(payline.ASI_CRM_CN_AC_Code__c)){
                    Decimal TempAmount=FixedCostMap.get(payline.ASI_CRM_CN_AC_Code__c)+payline.ASI_TH_CRM_Amount__c;
                    FixedCostMap.remove(payline.ASI_CRM_CN_AC_Code__c);
                    FixedCostMap.put(payline.ASI_CRM_CN_AC_Code__c,TempAmount);
                }else{
                    FixedCostMap.put(payline.ASI_CRM_CN_AC_Code__c,payline.ASI_TH_CRM_Amount__c);
                }
            }
        }
        
        
        List<ASI_CRM_Contract_Cost__c> LFixCost= new List<ASI_CRM_Contract_Cost__c>();
        for(ASI_CRM_Contract_Cost__c cc:[Select id, name, ASI_CRM_CNY_Est__c, ASI_CRM_MAF_Est__c, ASI_CRM_Other_Est__c, ASI_CRM_CN_Activity_Code__c, 
                                         ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Contract__c, ASI_CRM_CN_Contract_Amount__c, ASI_CRM_CN_Estimate_Amount__c,ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Sequence__c, ASI_CRM_CN_Contract__r.ASI_TH_CRM_Promotion_Type__c 
                                         from ASI_CRM_Contract_Cost__c where ASI_CRM_CN_Contract__c = :contract.Id])
        {
            if(cc.ASI_CRM_CN_Cost_Type__c == 'Fixed'){
                if(FixedCostMap.containsKey(cc.ASI_CRM_CN_Activity_Code__c)){
                    cc.ASI_CRM_CN_Estimate_Amount__c=FixedCostMap.get(cc.ASI_CRM_CN_Activity_Code__c);
                }
                LFixCost.add(cc);
            }
        }
        
        
        //Update Contract Fix cost
        if(LFixCost.size()>0){
            update LFixCost;
        }
        
        
        Map<String,Decimal> PSFPaidMap = new Map<String,Decimal>();
        
        //Calculate actual paid amount
        for(ASI_TH_CRM_PaymentRequest__c PaymentRequest : [select Id,Name,ASI_TH_CRM_Status__c,
                                                           (select Id,ASI_CRM_Line_Type__c,ASI_CRM_Actual_Payment__c,ASI_CRM_Parent_Module__c from ASI_CRM_Modules__r) 
                                                           from ASI_TH_CRM_PaymentRequest__c
                                                           where ASI_TH_CRM_Contract__c = :contract.Id and ASI_TH_CRM_Status__c!='Draft'  ])
        {
            for(ASI_CRM_Module__c module:PaymentRequest.ASI_CRM_Modules__r){
                if(module.ASI_CRM_Line_Type__c=='BRSF'){
                    BRSFPaidAmount+=module.ASI_CRM_Actual_Payment__c!=null?module.ASI_CRM_Actual_Payment__c:0;
                }
                if(module.ASI_CRM_Line_Type__c=='PSF'){
                    PSFPaidAmount+=module.ASI_CRM_Actual_Payment__c!=null?module.ASI_CRM_Actual_Payment__c:0;
                    if(PSFPaidMap.containsKey(module.ASI_CRM_Parent_Module__c)){
                        
                        Decimal TempAmount =   module.ASI_CRM_Actual_Payment__c!=null?module.ASI_CRM_Actual_Payment__c:0;
                        TempAmount += PSFPaidMap.get(module.ASI_CRM_Parent_Module__c) ;
                        PSFPaidMap.remove(module.ASI_CRM_Parent_Module__c);
                        PSFPaidMap.put(module.ASI_CRM_Parent_Module__c, TempAmount);
                    }else{
                       PSFPaidMap.put(module.ASI_CRM_Parent_Module__c, module.ASI_CRM_Actual_Payment__c!=null?module.ASI_CRM_Actual_Payment__c:0 ); 
                    }
                    
                }
                if(module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                    VECPaidAmount +=module.ASI_CRM_Actual_Payment__c!=null?module.ASI_CRM_Actual_Payment__c:0;
                }
            }
        }
        //***********************************Finish Getting Payment Info ********************************************
        
        
        
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> UpdatedDetailLines = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        //current version Contract Line
        List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractDetailLines =[SELECT Id,ASI_CRM_Contract_Monthly_Volume_CR12__c,ASI_CRM_Est_Monthly_Volume_CR12__c,ASI_CRM_Est_Total_QTY_CR12_Eqv__c,ASI_CRM_Contract_Total_QTY_CR12_Eqv__c,ASI_CRM_Contract_Total_QTY_std_Btl__c,ASI_CRM_Est_Total_QTY_std_Btl__c,ASI_CRM_Module__c,ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Volume_Base__c ,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                          WHERE ASI_CRM_CN_Contract__c = :contract.Id ] ;
        
        
        map<String,interimData> ContractLineItem_Map = new map<String,interimData> ();
        
        
        for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:ContractDetailLines){
            //by Line Type(BRSF/PSF/VEC) + Module Id
            if(ContractLineItem_Map.containsKey(ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c)){
                ContractLineItem_Map.get(ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c).DetailLineMap.put(ContractLine.Id,ContractLine);
            }else{//New 
                ASI_CRM_Module__c TempModule= new ASI_CRM_Module__c(ASI_CRM_Volume_Base__c=ContractLine.ASI_CRM_Volume_Base__c,ASI_CRM_Line_Type__c=ContractLine.ASI_CRM_Type__c);
                
                interimData TempData= new interimData(TempModule);
                TempData.DetailLineMap.put(ContractLine.Id,ContractLine);
                ContractLineItem_Map.put(ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c, TempData);
                
            }
        }
        
        Decimal BRSFEstimateAmount=0;
        Decimal VECEstimateAmount=0;
        Decimal PSFEstimateAmount=0;
        
        Decimal PSFContractAmount=0;
        
        Decimal PSFPreviousEstimateAmount=0;
        
        
        
        Decimal DiffMonth = SelectContract.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c-SelectContract.ASI_CRM_CN_No_of_Months__c;
        Id subbrand999 = [SELECT Id FROM ASI_MFM_Sub_brand__c WHERE ASI_MFM_Active_for_CRM__c = true  AND ASI_MFM_Sub_brand_Code__c = '999'  AND recordtypeid = :Global_RecordTypeCache.getRTid('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand') LIMIT 1].id;
        Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
        
        for(String HeaderKey:ContractLineItem_Map.keySet()){
            Decimal EstimateAmount=0;// For BRSF VEC Use
            ASI_CRM_CN_Contract_BRSF_Line_Item__c AjustmentLine =new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=contract.Id ,
                                                                                                           ASI_CRM_Adjustment_Line__c=true,
                                                                                                           recordTypeId=BRSFLineRtId, ASI_CRM_CN_Sub_Brand__c = subbrand999,
                                                                                                           ASI_CRM_CN_Est_Monthly_Qty__c = 0,ASI_CRM_CN_Contract_Monthly_Qty__c=0,
                                                                                                           ASI_CRM_CN_Est_Total_Dummy__c=0,
                                                                                                           ASI_CRM_CN_Contract_Total_Dummy__c=0,
                                                                                                           ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0);
            String PSFBySubBrandModuleId='';  
            Decimal PSFAmount_BySubBrand=0;
            //looping every contract Line
            for(String keyline:ContractLineItem_Map.get(HeaderKey).DetailLineMap.keySet()){
                
                
                ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =ContractLineItem_Map.get(HeaderKey).DetailLineMap.get(keyline);
                AjustmentLine.ASI_CRM_Type__c=ContractLine.ASI_CRM_Type__c!=null? ContractLine.ASI_CRM_Type__c : 'BRSF';
                if(ContractLine.ASI_CRM_Module__c!=null){
                    AjustmentLine.ASI_CRM_Module__c = ContractLine.ASI_CRM_Module__c ;
                }
                
                
                if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){// Volume base is by Sub-Brand
                    PSFBySubBrandModuleId= ContractLine.ASI_CRM_Module__c!=null? ContractLine.ASI_CRM_Module__c:'';
                    if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                        PSFPreviousEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }
                    //if this contarct line is 999-line, save the id
                    if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c =='999'){
                        AjustmentLine.Id=ContractLine.Id;
                    }else{//if this contarct line is not 999-line, perform calculation
                        ContractLine.ASI_CRM_CN_Est_Total_Dummy__c= ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c * ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                        ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c= ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                        PSFAmount_BySubBrand+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c;
                        //AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c += (ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null )? ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c*  ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c*DiffMonth: 0;
                        //AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c	 += (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null )? ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c*  ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*DiffMonth: 0;
                        UpdatedDetailLines.add(ContractLine);
                        
                        if(ContractLine.ASI_CRM_Type__c=='BRSF' || ContractLine.ASI_CRM_Type__c=='Variable Event Cost' ){
                            EstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                            
                        }
                        
                    }                    
                }else{
                    ContractLine.ASI_CRM_Contract_Total_QTY_std_Btl__c = (ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                    ContractLine.ASI_CRM_Est_Total_QTY_std_Btl__c = (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                    ContractLine.ASI_CRM_Contract_Total_QTY_CR12_Eqv__c = (ContractLine.ASI_CRM_Contract_Monthly_Volume_CR12__c==null) ? 0:ContractLine.ASI_CRM_Contract_Monthly_Volume_CR12__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                    ContractLine.ASI_CRM_Est_Total_QTY_CR12_Eqv__c = (ContractLine.ASI_CRM_Est_Monthly_Volume_CR12__c==null) ? 0:ContractLine.ASI_CRM_Est_Monthly_Volume_CR12__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                    UpdatedDetailLines.add(ContractLine);
                    
                    if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                        PSFPreviousEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0; 
                    }
                    if(ContractLine.ASI_CRM_Type__c=='BRSF' || ContractLine.ASI_CRM_Type__c=='Variable Event Cost' ){
                        EstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        
                    }
                }
                
                
               
                
                if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                    PSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                    PSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    
                }
            }// end of looping this Module
            
            if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='BRSF'){
                system.debug('BRSF PaidAmount : '+BRSFPaidAmount);
                system.debug('BRSF EstimateAmount : '+EstimateAmount);
                AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c=BRSFPaidAmount-EstimateAmount;
            }else if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='PSF' && PSFBySubBrandModuleId!=''){
                if(PSFPaidMap.containsKey(PSFBySubBrandModuleId)){
                     AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c = PSFPaidMap.get(PSFBySubBrandModuleId) - PSFAmount_BySubBrand;
                }
            }else if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                system.debug('VECPaidAmount : '+VECPaidAmount);
                system.debug('VEC EstimateAmount : '+EstimateAmount);
                AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c =VECPaidAmount-EstimateAmount;
            }
            
            
            //PSFPaidMap
            
            system.debug('EstimateAmount : '+EstimateAmount);
            system.debug('**********AjustmentLine*********'+AjustmentLine.ASI_CRM_Type__c);
            system.debug(AjustmentLine);
            
            //checking if need to create/update 999-Line 
            if(AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c !=0 || AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c!=0 || (AjustmentLine.Id!=NULL && ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='Variable Event Cost' ) )  {
                if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='BRSF'){
                    BRSFEstimateAmount+=AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c;
                }
                if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='PSF' ){
                    PSFContractAmount+=AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c;
                    PSFEstimateAmount+=AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c;
                }
                
                if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                    //VECContractAmount+=AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c;
                    VECEstimateAmount+=AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c;
                }
                
                UpdatedDetailLines.add(AjustmentLine);
            }
            
            
            
            
        }//Ending of Contract Line looping
        
        
        //update exsting contract Line
        if(UpdatedDetailLines.size()>0){
            Upsert UpdatedDetailLines;
        }
        
         if(SelectContract.ASI_CRM_Copied_From__c!=null && SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c !=null){
            PSFPreviousEstimateAmount=SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c!=null?SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c: 0 ;
        }

        /*
        if(SelectContract.ASI_CRM_CN_PO_Version__c!='0.1' && SelectContract.ASI_CRM_Copied_From__c!=null && SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c !=null){
            PSFPreviousEstimateAmount=SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c;
        }
        else{//PO_Version =='0.1'
            PSFPreviousEstimateAmount=PSFEstimateAmount;
        }*/          
        
        
        
        //**************************Contract Details**************************************************
      
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        if(SelectContract.ASI_CRM_CN_PO_Start_Date__c != null){
            if(SelectContract.ASI_CRM_CN_PO_Start_Date__c <ASI_CRM_CN_HeavyContractUtilitiesClass.getFiscalYearStart(system.today(),orgFiscalMonth).addYears(1)){ 
                SelectContract.ASI_CRM_CN_Effective_Date__c=ASI_CRM_CN_HeavyContractUtilitiesClass.getFiscalYearStart(System.today(),orgFiscalMonth);
            }else{
                SelectContract.ASI_CRM_CN_Effective_Date__c=ASI_CRM_CN_HeavyContractUtilitiesClass.getFiscalYearStart(SelectContract.ASI_CRM_CN_PO_Start_Date__c,orgFiscalMonth);
            }
        }else{
            SelectContract.ASI_CRM_CN_Effective_Date__c=ASI_CRM_CN_HeavyContractUtilitiesClass.getFiscalYearStart(System.today(),orgFiscalMonth);
        }
        
        
        
        //BRSF
        SelectContract.ASI_CRM_CN_Expected_BRSF_Est_Total__c=BRSFPaidAmount;
        //PSF
        //ASI_CRM_Expected_V0_PSF_Estimated_Total__c
        SelectContract.ASI_CRM_Previous_Version_PSF_Est_Total__c=PSFPreviousEstimateAmount;
        SelectContract.ASI_CRM_PSF_Estimate_Adjustment_Amount__c=PSFPaidAmount-PSFPreviousEstimateAmount;
        SelectContract.ASI_CRM_CN_Expected_PSF_Est_Total__c=PSFPaidAmount;
        SelectContract.ASI_CRM_PSF_Grand_Contract_Total__c=PSFContractAmount;
        SelectContract.ASI_CRM_V0_PSF_Contract_Total__c=PSFContractAmount;
        SelectContract.ASI_CRM_Auto_PO_Modification__c=true;
        //VEC
        SelectContract.ASI_CRM_EVC_Cost_Estimate_Total__c=VECPaidAmount;
        
        
        update SelectContract;
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MethodologyCode : M01: Min (BC, Intake)  (Min of CTD Actual Vol (Std Btl) &&     CTD Cap Collection Vol (Std Btl)   )
    //M02  :  BC%>=V0.0 BC%, Intake; BC%<V0.0 BC%, BC                  
    //M03: Min (BC/V0.0 BC%, Intake)       
    //M04 : Intake 
    //M05: Others 
    //UseInputBCRateOrNot ---> if true, use (InputBC/InputIntake) to calculate BC Rate
    //UseInputBCRateOrNot ---> if false, use InputBCRate to calculate BC Rate , but  for return value , it will be 'InputIntake or InputBC'
    public static Decimal MethodologyDecision(String MethodologyCode,Decimal InputIntake,Decimal InputBC,Decimal InputBCRate, Decimal ComparedBCRate,Boolean UseInputBCRateOrNot){
        Decimal ReturnNumber=0;
        Decimal BCRate=0;
        system.debug('Enter MethodologyDecision:InputBC :  '+InputBC+'InputIntake : '+InputIntake+ '  MethodologyCode  : '+MethodologyCode );
        if(!UseInputBCRateOrNot){
            BCRate=InputBCRate;
        }else if(InputIntake!=0 && InputIntake!=null){ // UseInputBCRateOrNot = true
            BCRate=(InputBC/InputIntake)*100;
        }
        
        if(InputIntake==null){
            InputIntake=0;
        }
        if(InputBC==null){
            InputBC=0;
        }
        //************************compare**********************************
        if(MethodologyCode=='M01'){
            if(InputIntake>InputBC){
                ReturnNumber=InputBC;
            }else{
                ReturnNumber=InputIntake;
            }
        }else if(MethodologyCode=='M02'){
            if(BCRate>=ComparedBCRate){
                ReturnNumber=InputIntake;
            }else{
                ReturnNumber=InputBC;
            }
            
            if(InputIntake<=0){
                ReturnNumber=0;
            }
        }else if(MethodologyCode=='M03'){
            
            Decimal CalIntake=0;
            CalIntake=(InputBC/ComparedBCRate)*100;
            if(CalIntake>InputIntake){
                ReturnNumber=InputIntake;
            }else{
                ReturnNumber=CalIntake;
            }
            
        }else if(MethodologyCode=='M04'){
            ReturnNumber=InputIntake;
        }else if(MethodologyCode=='M05'){
            ReturnNumber=0;
        }else{
            ReturnNumber=InputIntake;
        }
        
        
        return ReturnNumber;
    }
    
    
    public Static Boolean IsMartellSubBrandOrNot(String BrandCode){
        boolean IsMartellSubBrand=false;
        if(BrandCode=='MAR'){
            IsMartellSubBrand=true;
        }
        return IsMartellSubBrand;
    }
    
    public Class VolumeObject{
        //V0.0 Full Contract Target/合同销量目标
        
        public Decimal FullContractTarget {set;get;}{FullContractTarget=0;}
        //Actual Performance
        public Decimal CTDActualVol {set;get;}{CTDActualVol=0;}
        public String SubBrandGradeName {set;get;}{SubBrandGradeName='';}
        public VolumeObject(){
            
        }
    }
    
    
    
    public static String SplitLineIntoRow(String InputString,integer CutNumber ){
        String outputString ='';
        if(InputString!=null){
            system.debug('Now InputString: '+InputString);
            system.debug('Now 1: '+ASI_CRM_CN_HeavyContracFunctionClass.containsEnglishCharacters(InputString) );
            system.debug('Now 2: '+ASI_CRM_CN_HeavyContracFunctionClass.containsChineseCharacters(InputString) );
            if(!ASI_CRM_CN_HeavyContracFunctionClass.containsEnglishCharacters(InputString) && ASI_CRM_CN_HeavyContracFunctionClass.containsChineseCharacters(InputString) ){
                
                system.debug('Enter!!!');
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
                outputString =  InputString;
            }
        }
        
        return outputString;
    }
    
    
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
    
    
}