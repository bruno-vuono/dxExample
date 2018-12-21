public with sharing class ASI_CRM_CN_POPaymentCO_Cmpnt_Ctrl{
/* Commented by Michael Yip (Introv) 07Aug2014 class no longer used
    public ASI_CRM_CN_POPaymentCO_Cmpnt_Ctrl() {

    }


    public ASI_CRM_CN_POPaymentCO_Cmpnt_Ctrl(ApexPages.StandardController controller) {

    }


    public String relatedto { get; set; }
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public ASI_TH_CRM_PaymentRequest__c thisPR {set;get;}
    
    //Query List
    public list<ASI_TH_CRM_PaymentRequestLineItem__c> PSF_List {set;get;}
    public list<ASI_CRM_CN_Contract_BRSF_Line_Item__c> BRSF_List {set;get;}
    public list<ASI_CRM_Subbrand_Volume__c> SB_Vol_List {set;get;}
    public list<ASI_CRM_Subbrand_Volume__c> SB_Vol_List_v0 {set;get;}
    public list<ASI_CRM_CM_GS__c> ActualCM_List {set;get;}
    public list<ASI_CRM_CM_GS__c> ActualCM_List_v0 {set;get;}

    //Manual assign List & Map & Set    
    public map<string, DataClass> PSF_map {set;get;}
    public map<string, DataClass> SubBrand_ROI_map_v1 {set;get;}
    public map<string, DataClass> SubBrand_ROI_map_v0 {set;get;}
    public set<id> BRSF_SBId {set;get;}
    public set<id> BRSF_SBId_v0 {set;get;}
    public map<date, date> PSF_Period_map {set;get;}
    public DataClass TotalVolCR12 {set;get;}
    public DataClass TotalVolBtl {set;get;}
    public DataClass Investment_CR12 {set;get;}
    public map<id, decimal> ActualCM_v0_map {set;get;}
    public map<id, decimal> ActualCM_v1_map {set;get;}
    public DataClass vAllROI {set;get;}
    
    //String & Decimal
    public decimal Other_VOL_CR12 {set;get;}
    public decimal TotalCR12_Volume_v0 {set;get;}
    public decimal TotalCR12_Volume_v1 {set;get;}
    
    
    public void InitVariable(){
        PSF_map = new map<string, DataClass>();
        SubBrand_ROI_map_v1 = new map<string, DataClass>();
        SubBrand_ROI_map_v0 = new map<string, DataClass>();
        PSF_Period_map = new map<date, date>();
        BRSF_SBId = new set<id>();
        BRSF_SBId_v0 = new set<id>();
        PSF_List = new list<ASI_TH_CRM_PaymentRequestLineItem__c>();
        BRSF_List = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
        SB_Vol_List = new list<ASI_CRM_Subbrand_Volume__c>();
        SB_Vol_List_v0 = new list<ASI_CRM_Subbrand_Volume__c>();
        ActualCM_List = new list<ASI_CRM_CM_GS__c>();
        ActualCM_List_v0 = new list<ASI_CRM_CM_GS__c>();
        ActualCM_v0_map = new map<id, decimal>();
        ActualCM_v1_map = new map<id, decimal>();
        
        //Total Volume (std btl)
        TotalVolBtl = new DataClass();
        TotalVolBtl.target_vol = 0;
        TotalVolBtl.actual_vol = 0;
        
        //Total Volume (std btl)
        TotalVolCR12 = new DataClass();
        TotalVolCR12.target_vol = 0;
        TotalVolCR12.actual_vol = 0;
        
        //Investment per Btl
        Investment_CR12 = new DataClass();
        Investment_CR12.v0 = 0;
        Investment_CR12.v1 = 0;
        Investment_CR12.gap = 0;
        
        //(Total BRSF CR12) - Prepare for calculating Investment per BTL (Contract Total Cost / Total BRSF CR12)
        TotalCR12_Volume_v0 = 0; 
        TotalCR12_Volume_v1 = 0;
        
        //ROI Only for AD Above
        vALLROI = new DataClass();
        vALLROI.v0 = 0;
        vALLROI.v1 = 0;
        vALLROI.gap = 0;
        
    }
    
    public boolean init(){
        InitVariable();
        
        if (thisPR != null){
            Id PSF_RTId = Global_RecordTypeCache.getRtId('ASI_TH_CRM_PaymentRequestLineItem__cASI_CRM_CN_Payment_Request_Detail_PSF');
            try{
//query PSF Period Date
                PSF_List = [SELECT id, ASI_CRM_CN_Period_End__c, ASI_CRM_CN_Period_Start__c
                            FROM ASI_TH_CRM_PaymentRequestLineItem__c WHERE ASI_TH_CRM_Payment_Request__c = :thisPR.id
                            AND ASI_CRM_CN_Period_Start__c != null AND ASI_CRM_CN_Period_End__c != null
                            AND RecordTypeId = :PSF_RTId ];
            }catch(exception e){
                PSF_List = new list<ASI_TH_CRM_PaymentRequestLineItem__c >();
            }
//get & map Start + End date
            if (PSF_List.size() > 0){
                for (ASI_TH_CRM_PaymentRequestLineItem__c  PSF_List_temp: PSF_List){
                     //Add Data Collection Period
                     PSF_Period_map.put(PSF_List_temp.ASI_CRM_CN_Period_Start__c, PSF_List_temp.ASI_CRM_CN_Period_End__c);
                }
            }
            try{
//query Contract BRSF Sub Brands & Data
                BRSF_List = [SELECT id, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.Name,
                            ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Sub_Brand_Conversion_Factor__c,
                            ASI_CRM_CN_Contract__c
                            FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :thisPR.ASI_TH_CRM_Contract__c
                            OR ASI_CRM_CN_Contract__c = :thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c];
                }catch(exception e){
                    BRSF_List = new list<ASI_CRM_CN_Contract_BRSF_Line_Item__c >();
                }
//get BRSF Target Volume from BRSF
            system.debug('BRSF_List.size(): ' + BRSF_List.size());            
            if (BRSF_List.size() > 0){
                string sb_brand;
                decimal BRSF_targetvol = 0;
                decimal BRSF_targetvol_CR12 = 0;
                decimal BRSF_targetvol_CR12_v0 = 0; 
                for (ASI_CRM_CN_Contract_BRSF_Line_Item__c BRSF_List_temp : BRSF_List){
                
                //V0.0 Target Volume (CR12) = Total ASI_CRM_CN_Contract_Total__c 
                    if (BRSF_List_temp.ASI_CRM_CN_Contract_Total__c != null)
                        BRSF_targetvol_CR12_v0 = BRSF_List_temp.ASI_CRM_CN_Contract_Total__c;
                
                //Last PO
                    if (BRSF_List_temp.ASI_CRM_CN_Contract__c == thisPR.ASI_TH_CRM_Contract__c){
                        
                        //Uses to select Actual volume from Subbrand Volume table
                        BRSF_SBId.add(BRSF_List_temp.ASI_CRM_CN_Sub_Brand__c);
                        
                        //Define Target Volume value & Sub brand - Brand name
                        DataClass BRSF_Class = new DataClass();
                        BRSF_Class.target_vol = 0;
                        BRSF_Class.actual_vol = 0;
                        
                        //PSF Map key (by Brand Name)
                        if (BRSF_List_temp.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__c != null)
                            sb_brand = BRSF_List_temp.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Brand__r.Name;
                        else
                            sb_brand = 'Not Specified';
                            
                        //Target Volume (Btl) = Contract Monthly Qty * Contract Period #of Months
                        if (BRSF_List_temp.ASI_CRM_CN_Contract_Monthly_Qty__c != null && BRSF_List_temp.ASI_CRM_CN_No_of_Months__c != null)
                            BRSF_targetvol = BRSF_List_temp.ASI_CRM_CN_Contract_Monthly_Qty__c * BRSF_List_temp.ASI_CRM_CN_No_of_Months__c;
                        
                        //Target Volume (CR12) = Contract Monthly Qty * Contract Period #of Months * Factor
                        if (BRSF_List_temp.ASI_CRM_CN_Contract_Monthly_Qty__c != null && BRSF_List_temp.ASI_CRM_CN_No_of_Months__c != null && BRSF_List_temp.ASI_CRM_CN_Sub_Brand_Conversion_Factor__c != null)
                            BRSF_targetvol_CR12 = BRSF_List_temp.ASI_CRM_CN_Contract_Monthly_Qty__c * BRSF_List_temp.ASI_CRM_CN_No_of_Months__c * BRSF_List_temp.ASI_CRM_CN_Sub_Brand_Conversion_Factor__c;
                        
                        //Add Contract Target to Brand Map
                        if (PSF_map.containskey(sb_brand)){
                            PSF_map.get(sb_brand).target_vol += BRSF_targetvol;
                        }else{
                            PSF_map.put(sb_brand, BRSF_Class);
                        }

                        //Add VFinal Total Target Volume (CR12) For Investment Calculation
                        TotalCR12_Volume_v1 += BRSF_targetvol_CR12_v0;
                        
                        //Add Total Target Volume (Btl)
                        TotalVolBtl.target_vol += BRSF_targetvol;
                        
                        //Add Total Target Volume (CR12)
                        TotalVolCR12.target_vol += BRSF_targetvol_CR12;
                    }
                    
                //V0.0 PO
                    system.debug('BRSF_List_temp.ASI_CRM_CN_Contract__c: ' + BRSF_List_temp.ASI_CRM_CN_Contract__c);
                    system.debug('thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c: ' + thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c);
                    if (BRSF_List_temp.ASI_CRM_CN_Contract__c == thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c){
                        BRSF_SBId_v0.add(BRSF_List_temp.ASI_CRM_CN_Sub_Brand__c);
                        //Add V0.0 Total Target Volume (CR12) For Investment Calculation
                        TotalCR12_Volume_v0 += BRSF_targetvol_CR12_v0;
                    }
                }
            }
//query Actual YTD CM for both V0.0 & VFinal
            try{
                ActualCM_List = [SELECT ASI_CRM_CM_GS_per_9L__c, ASI_CRM_CN_Standard_Bottle_Factor__c, ASI_CRM_PRODUCTCODE__c
                                FROM ASI_CRM_CM_GS__c
                                WHERE ASI_CRM_PRODUCTCODE__c IN :BRSF_SBId
                                AND ASI_CRM_Sub_Channel__c = :thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Sub_Channel__c
                                AND ASI_CRM_Region__c = :thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                AND ASI_CRM_CN_Month_End_Date__c >= :thisPR.ASI_CRM_CN_PSF_Start__c
                                AND ASI_CRM_CN_Month_End_Date__c <= :thisPR.ASI_CRM_CN_PSF_End__c
                                ORDER BY ASI_CRM_VERSION__c DESC, ASI_CRM_PRODUCTCODE__c ASC];
            }catch(exception e){
                ActualCM_List = new list<ASI_CRM_CM_GS__c>();
            }
            try{
                ActualCM_List_v0 = [SELECT ASI_CRM_CM_GS_per_9L__c, ASI_CRM_CN_Standard_Bottle_Factor__c, ASI_CRM_PRODUCTCODE__c
                                FROM ASI_CRM_CM_GS__c
                                WHERE ASI_CRM_PRODUCTCODE__c IN :BRSF_SBId_v0
                                AND ASI_CRM_Sub_Channel__c = :thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Sub_Channel__c
                                AND ASI_CRM_Region__c = :thisPR.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c
                                AND ASI_CRM_CN_Month_End_Date__c >= :thisPR.ASI_CRM_CN_PSF_Start__c
                                AND ASI_CRM_CN_Month_End_Date__c <= :thisPR.ASI_CRM_CN_PSF_End__c
                                ORDER BY ASI_CRM_VERSION__c DESC, ASI_CRM_PRODUCTCODE__c ASC];
            }catch(exception e){
                ActualCM_List_v0 = new list<ASI_CRM_CM_GS__c>();
            }
            
//get Actual YTD CM vFinal            
            decimal ActualCMperBtl = 0;
            if (ActualCM_List.size() > 0){ 
                for (ASI_CRM_CM_GS__c ACM_temp : ActualCM_List){
                    if (ACM_temp.ASI_CRM_CM_GS_per_9L__c != null)
                        ActualCMperBtl = ACM_temp.ASI_CRM_CM_GS_per_9L__c;
                    //Conversion to Btl     
                    if (ACM_temp.ASI_CRM_CN_Standard_Bottle_Factor__c != null && ACM_temp.ASI_CRM_CN_Standard_Bottle_Factor__c != 0)
                        ActualCMperBtl = ActualCMperBtl * ACM_temp.ASI_CRM_CN_Standard_Bottle_Factor__c ;
                        
                    if (!ActualCM_v1_map.containskey(ACM_temp.ASI_CRM_PRODUCTCODE__c))
                        ActualCM_v1_map.put(ACM_temp.ASI_CRM_PRODUCTCODE__c, ActualCMperBtl);
                }
            }
//get Actual YTD CM v0.0
            if (ActualCM_List_v0.size() > 0){
                for (ASI_CRM_CM_GS__c ACM_v0_temp : ActualCM_List_v0){
                    if (ACM_v0_temp.ASI_CRM_CM_GS_per_9L__c != null)
                        ActualCMperBtl = ACM_v0_temp.ASI_CRM_CM_GS_per_9L__c;
                    //Conversion to Btl     
                    if (ACM_v0_temp.ASI_CRM_CN_Standard_Bottle_Factor__c != null && ACM_v0_temp.ASI_CRM_CN_Standard_Bottle_Factor__c != 0)
                        ActualCMperBtl = ActualCMperBtl * ACM_v0_temp.ASI_CRM_CN_Standard_Bottle_Factor__c;
                        
                    if (!ActualCM_v0_map.containskey(ACM_v0_temp.ASI_CRM_PRODUCTCODE__c))
                        ActualCM_v0_map.put(ACM_v0_temp.ASI_CRM_PRODUCTCODE__c, ActualCMperBtl);
                }
            }
            try{
//query Actual Sub Brand Volume Data (PSF Period dates & BRSF Sub brands)
                SB_Vol_List = [SELECT ASI_CRM_T1_Depletion_BTL__c, ASI_CRM_T1_Depletion_CR12__c,
                                ASI_CRM_T2_Depletion_BTL__c, ASI_CRM_T2_Depletion_CR12__c,
                                ASI_CRM_PR_Direct_Btl__c, ASI_CRM_PR_Direct_CR12__c,ASI_CRM_End_Date__c, 
                                ASI_CRM_Subbrand__c, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.Name
                                FROM ASI_CRM_Subbrand_Volume__c WHERE ASI_CRM_Subbrand__c IN:BRSF_SBId
                                AND ASI_CRM_End_Date__c >= :thisPR.ASI_CRM_CN_PSF_Start__c
                                AND ASI_CRM_End_Date__c <= :thisPR.ASI_CRM_CN_PSF_End__c
                                AND ASI_CRM_Account__c = :thisPR.ASI_CRM_CN_OutletWS__c ];
            }catch(exception e){
                SB_Vol_List = new list<ASI_CRM_Subbrand_Volume__c >();
            }
//get & map Actual Sub Brand Volume 
            if (SB_Vol_List.size() > 0){
                string sb_vol_brand;
                decimal PSF_actual_vol = 0;
                decimal PSF_actual_vol_CR12 = 0;
                decimal strActualCM_v0 = 0;
                decimal strActualCM_v1 = 0;
                if (PSF_Period_map.size() > 0){
                    for (date PSF_date_temp : PSF_Period_map.keyset()){
                        for (ASI_CRM_Subbrand_Volume__c  SB_Vol_temp : SB_Vol_List){
                            if (SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_MFM_Brand__c != null)
                                sb_vol_brand = SB_Vol_temp.ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.Name;
                            else
                                sb_Vol_brand = 'Not Specified';
                            
                            if (SB_Vol_temp.ASI_CRM_End_Date__c >= PSF_date_temp  && SB_Vol_temp.ASI_CRM_End_Date__c <= PSF_Period_map.get(PSF_date_temp)){
                                
                                //Define Target Volume value & Sub brand - Brand name
                                DataClass BRSF_Class = new DataClass();
                                BRSF_Class.target_vol = 0;
                                BRSF_Class.actual_vol = 0;
                                
                                //Actual Volume (Btl) = T1_Depletion + T2_Depletion + PR_Direct
                                if (SB_Vol_temp.ASI_CRM_T1_Depletion_BTL__c != null) 
                                    PSF_actual_vol = SB_Vol_temp.ASI_CRM_T1_Depletion_BTL__c;
                                if (SB_Vol_temp.ASI_CRM_T2_Depletion_BTL__c != null) 
                                    PSF_actual_vol += SB_Vol_temp.ASI_CRM_T2_Depletion_BTL__c;
                                if (SB_Vol_temp.ASI_CRM_PR_Direct_Btl__c!= null) 
                                    PSF_actual_vol += SB_Vol_temp.ASI_CRM_PR_Direct_Btl__c;
                                    
                                //Actual Volume (CR12) = T1_Depletion + T2_Depletion + PR_Direct
                                if (SB_Vol_temp.ASI_CRM_T1_Depletion_CR12__c != null) 
                                    PSF_actual_vol = SB_Vol_temp.ASI_CRM_T1_Depletion_CR12__c;
                                if (SB_Vol_temp.ASI_CRM_T2_Depletion_CR12__c != null) 
                                    PSF_actual_vol += SB_Vol_temp.ASI_CRM_T2_Depletion_CR12__c;
                                if (SB_Vol_temp.ASI_CRM_PR_Direct_CR12__c != null) 
                                    PSF_actual_vol += SB_Vol_temp.ASI_CRM_PR_Direct_CR12__c;
                                
                                
                                //Add Actual Volume to Brand Map
                                if (PSF_map.containskey(sb_vol_brand)){
                                    PSF_map.get(sb_vol_brand).actual_vol += PSF_actual_vol;
                                }else{
                                    PSF_map.put(sb_vol_brand, BRSF_Class);
                                }
                                //Prepare for ROI calculation
                                if (ActualCM_v1_map.containskey(SB_Vol_temp.ASI_CRM_Subbrand__c))
                                    strActualCM_v1 = ActualCM_v1_map.get(SB_Vol_temp.ASI_CRM_Subbrand__c);
                                    
                                if (SubBrand_ROI_map_v1.containskey(SB_Vol_temp.ASI_CRM_Subbrand__c)){
                                    SubBrand_ROI_map_v1.get(SB_Vol_temp.ASI_CRM_Subbrand__c).actual_vol += PSF_actual_vol;
                                }else{
                                    DataClass newDC1 = new DataClass();
                                    newDC1.actualCM = strActualCM_v1;
                                    newDC1.actual_vol = PSF_actual_vol;
                                    SubBrand_ROI_map_v1.put(SB_Vol_temp.ASI_CRM_Subbrand__c, newDC1);
                                }
                                
                                //Add Total Target Volume (Btl)
                                TotalVolBtl.actual_vol += PSF_actual_vol ;
                                
                                //Add Total Target Volume (CR12)
                                TotalVolCR12.actual_vol += PSF_actual_vol_CR12;
                            }
                        }
                    }
                }
            } 
            try{
//query V0.0 Actual Sub Brand Volume Data (PSF Period dates & BRSF Sub brands)
                SB_Vol_List_v0 = [SELECT ASI_CRM_T1_Depletion_BTL__c, ASI_CRM_T1_Depletion_CR12__c,
                                ASI_CRM_T2_Depletion_BTL__c, ASI_CRM_T2_Depletion_CR12__c,
                                ASI_CRM_PR_Direct_Btl__c, ASI_CRM_PR_Direct_CR12__c,
                                ASI_CRM_Subbrand__c, ASI_CRM_Subbrand__r.ASI_MFM_Brand__r.Name,
                                ASI_CRM_End_Date__c
                                FROM ASI_CRM_Subbrand_Volume__c WHERE ASI_CRM_Subbrand__c IN:BRSF_SBId_v0
                                AND ASI_CRM_End_Date__c >= :thisPR.ASI_CRM_CN_PSF_Start__c
                                AND ASI_CRM_End_Date__c <= :thisPR.ASI_CRM_CN_PSF_End__c
                                AND ASI_CRM_Account__c = :thisPR.ASI_CRM_CN_OutletWS__c ];
            }catch(exception e){
                SB_Vol_List_v0 = new list<ASI_CRM_Subbrand_Volume__c >();
            } 
            if (SB_Vol_List.size() > 0){
                string sb_vol_brand;
                decimal PSF_actual_vol = 0;
                decimal strActualCM_v0 = 1;
                decimal strActualCM_v1 = 1;
                if (PSF_Period_map.size() > 0){
                    for (date PSF_date_temp : PSF_Period_map.keyset()){
                        for (ASI_CRM_Subbrand_Volume__c  SB_Vol_v0_temp : SB_Vol_List_v0){
                            
                            if (SB_Vol_v0_temp.ASI_CRM_End_Date__c >= PSF_date_temp  && SB_Vol_v0_temp.ASI_CRM_End_Date__c <= PSF_Period_map.get(PSF_date_temp)){
                                
                                //Actual Volume (Btl) = T1_Depletion + T2_Depletion + PR_Direct
                                if (SB_Vol_v0_temp.ASI_CRM_T1_Depletion_BTL__c != null) 
                                    PSF_actual_vol = SB_Vol_v0_temp.ASI_CRM_T1_Depletion_BTL__c;
                                if (SB_Vol_v0_temp.ASI_CRM_T2_Depletion_BTL__c != null) 
                                    PSF_actual_vol += SB_Vol_v0_temp.ASI_CRM_T2_Depletion_BTL__c;
                                if (SB_Vol_v0_temp.ASI_CRM_PR_Direct_Btl__c!= null) 
                                    PSF_actual_vol += SB_Vol_v0_temp.ASI_CRM_PR_Direct_Btl__c;

                                //Prepare for ROI calculation
                                if (ActualCM_v1_map.containskey(SB_Vol_v0_temp.ASI_CRM_Subbrand__c))
                                    strActualCM_v1 = ActualCM_v1_map.get(SB_Vol_v0_temp.ASI_CRM_Subbrand__c);
                                    
                                if (SubBrand_ROI_map_v0.containskey(SB_Vol_v0_temp.ASI_CRM_Subbrand__c)){
                                    SubBrand_ROI_map_v0.get(SB_Vol_v0_temp.ASI_CRM_Subbrand__c).actual_vol += PSF_actual_vol;
                                }else{
                                    DataClass newDC1 = new DataClass();
                                    newDC1.actualCM = strActualCM_v1;
                                    newDC1.actual_vol = PSF_actual_vol;
                                    SubBrand_ROI_map_v0.put(SB_Vol_v0_temp.ASI_CRM_Subbrand__c, newDC1);
                                }
                            }
                        }
                    }
                }
            } 
            
            //Other - VOL % (CR12)
            if (TotalVolCR12.target_vol != null && TotalVolCR12.target_vol != 0 && TotalVolCR12.actual_vol != null && TotalVolCR12.actual_vol != 0)
                Other_VOL_CR12 =  TotalVolCR12.actual_vol / TotalVolCR12.target_vol * 100;
                
            //Total Investment per Btl V0.0
            if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c != 0
                && TotalCR12_Volume_v0 != null && TotalCR12_Volume_v0 != 0)
                Investment_CR12.v0 = thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c / TotalCR12_Volume_v0;
            
            //Total Investment per Btl VFinal
            if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c != 0
                && TotalCR12_Volume_v1 != null && TotalCR12_Volume_v1 != 0)
                Investment_CR12.v1 = thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c / TotalCR12_Volume_v1;

            //Total Investment per Btl GAP
            if (Investment_CR12.v0 != null && Investment_CR12.v0 != 0 && Investment_CR12.v1 != null && Investment_CR12.v1 != 0)
                Investment_CR12.gap = Investment_CR12.v0 - Investment_CR12.v1;

            //V0.0 ROI  
            if (SubBrand_ROI_map_v0.size() > 0){
                decimal totalAP = 0;
                if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c != null)
                    if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c != 0)
                        totalAP = thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c;
                decimal totalsb_cm_v0 = 0;
                if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c != null)
                    if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c != 0)
                        totalAP = thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Cost_Total__c;
                for (DataClass sb_v0 : SubBrand_ROI_map_v0.values()){
                    if (sb_v0.actual_vol != null)
                        totalsb_cm_v0 += sb_v0.actual_vol * sb_v0.actualCM;
                        if (totalAP != 0 && totalAP != null && totalsb_cm_v0 != null && totalsb_cm_v0 != 0)
                            vALLROI.v0 = totalsb_cm_v0 / totalAP;
                }
            }
            //VFinal ROI
            if (SubBrand_ROI_map_v1.size() > 0){
                decimal totalAP = 0;
                if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_V0_0_PO_version__c != null)
                    if (thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c != null && thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c != 0)
                        totalAP = thisPR.ASI_TH_CRM_Contract__r.ASI_CRM_CN_Contract_Cost_Total__c;
                decimal totalsb_cm_v1 = 0;
                for (DataClass sb_v1 : SubBrand_ROI_map_v1.values()){
                    if (sb_v1.actual_vol != null)
                        totalsb_cm_v1 += sb_v1.actual_vol * sb_v1.actualCM;
                        if (totalAP != 0 && totalAP != null && totalsb_cm_v1 != null && totalsb_cm_v1 != 0)
                            vALLROI.v1 = totalsb_cm_v1 / totalAP;
                }
            }
            //ROI Gap
            if (vALLROI.v1 != 0 && vALLROI.v1 != null && vALLROI.v0 != null && vALLROI.v0 != 0)
                vALLROI.gap = vALLROI.v0 - vALLROI.v1;
        }
        return true;
    }
    
    
    public class DataClass{
        public string brand {set;get;}
        public decimal target_vol {set;get;}
        public decimal actual_vol {set;get;}
        public decimal v0 {set;get;}
        public decimal v1 {set;get;}
        public decimal gap {set;get;}
        public decimal actualCM {set;get;}
    }*/
}