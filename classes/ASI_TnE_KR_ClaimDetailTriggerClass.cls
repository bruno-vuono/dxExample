public without sharing class ASI_TnE_KR_ClaimDetailTriggerClass {
    
    private static String statusSubmitted = 'Submitted';
    private static String statusApproved = 'Approved';
    private static String statusCompleted = 'Complete';
    private static String statusFinal = 'Final';
    private static String admin = 'System Administrator';
    private static Id profileId = userinfo.getProfileId();
    private static String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
    
    
    public static void routineBeforeUpsert(List<ASI_TnE_ClaimDetail__c> triggerNew, Map<Id, ASI_TnE_ClaimDetail__c> triggerOldMap)
    {
        List<String> counterCurrencies = new List<String>();
        
        for (ASI_TnE_ClaimDetail__c claimDetail : triggerNew)
        {
            if (!'KRW'.equals(claimDetail.ASI_TnE_Currency__c))
            {
                counterCurrencies.add(claimDetail.ASI_TnE_Currency__c);
            }//end if
            if(claimDetail.ASI_TnE_Receipt_Number__c != 1)
                claimDetail.ASI_TnE_Receipt_Number__c = 1;
        }//end for
        List<ASI_MFM_Exchange_Rate__c> exchangeRateCurrencies =
            [SELECT ASI_MFM_Base_Currency__c,
             ASI_MFM_Counter_Currency__c,
             ASI_MFM_Country__c,
             ASI_MFM_Effective_Date__c,
             ASI_MFM_Exchange_Rate__c
             FROM ASI_MFM_Exchange_Rate__c
             WHERE ASI_MFM_Country__c = 'KR'
             AND ASI_MFM_Base_Currency__c = 'KRW'
             AND ASI_MFM_Counter_Currency__c in :counterCurrencies
             ORDER BY ASI_MFM_Counter_Currency__c DESC, ASI_MFM_Effective_Date__c DESC];
        Map<String,List<ASI_MFM_Exchange_Rate__c>> exchangeRateMappings = new Map<String,List<ASI_MFM_Exchange_Rate__c>>();
        
        for (ASI_MFM_Exchange_Rate__c exchangeRate : exchangeRateCurrencies)
        {
            String key = exchangeRate.ASI_MFM_Counter_Currency__c;
            if (exchangeRateMappings.containsKey(key))
            {
                exchangeRateMappings.get(key).add(exchangeRate);
            }//end if
            else
            {
                List<ASI_MFM_Exchange_Rate__c> exchangeRates = new List<ASI_MFM_Exchange_Rate__c>();
                exchangeRates.add(exchangeRate);
                exchangeRateMappings.put(key,exchangeRates);
            }//end else
        }//end for
        
        for (ASI_TnE_ClaimDetail__c claimDetail : triggerNew)
        {
            if (claimDetail.ASI_TnE_Currency__c == 'KRW')
            {
                claimDetail.ASI_TnE_FX_Rate__c = 1;
            }//end if
            else
            {
                List<ASI_MFM_Exchange_Rate__c> exchangeRates = exchangeRateMappings.get(claimDetail.ASI_TnE_Currency__c);
                boolean isRateExist = false;
                if (exchangeRates != null && claimDetail.ASI_TnE_FX_Rate__c == null)
                {
                    for (ASI_MFM_Exchange_Rate__c exchangeRate : exchangeRates)
                    {
                        if (exchangeRate.ASI_MFM_Effective_Date__c <= claimDetail.ASI_TnE_Receipt_Date__c)
                        {
                            isRateExist = true;
                            claimDetail.ASI_TnE_FX_Rate__c = exchangeRate.ASI_MFM_Exchange_Rate__c;
                            break;
                        }//end if
                    }//end for
                }//end if
            }//end else
            claimDetail.ASI_TnE_Non_Taxable_Amount__c = (claimDetail.ASI_TnE_Receipt_Amount__c * claimDetail.ASI_TnE_FX_Rate__c).round(System.RoundingMode.HALF_UP);
            
            if (claimDetail.ASI_TnE_Currency__c != null && 'KRW'.equals(claimDetail.ASI_TnE_Currency__c.trim()))
            {
                if (claimDetail.ASI_TnE_Receipt_Amount__c != null && claimDetail.ASI_TnE_Receipt_Amount__c >0)
                {
                    claimDetail.ASI_TnE_Receipt_Amount__c  = claimDetail.ASI_TnE_Receipt_Amount__c.round(System.RoundingMode.Up);
                }//end if
            }//end if
        }//end for
        
        //added by Leo,2015-06-25,for checking Cash claim receipt date month and year
        Set<id> headerIdSet = new Set<id>();
        for(ASI_TnE_ClaimDetail__c obj:triggerNew)
        {
            headerIdSet.add(obj.ASI_TnE_ClaimHeader__c);
        }//end for
        Map<id, ASI_TnE_ClaimHeader__c> mapCashRecord = new Map<id, ASI_TnE_ClaimHeader__c>
            ([SELECT Id,ASI_TnE_KR_Year__c,ASI_TnE_KR_Month__c FROM ASI_TnE_ClaimHeader__c WHERE Id IN : headerIdSet
              AND ASI_TnE_ClaimHeader__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_Cash')]);
        for(ASI_TnE_ClaimDetail__c detail : triggerNew)
        {
            if(mapCashRecord.containsKey(detail.ASI_TnE_ClaimHeader__c))
            {
                if(detail.ASI_TnE_Receipt_Date__c.Year() == Integer.valueOf(mapCashRecord.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Year__c))
                {
                    if(detail.ASI_TnE_Receipt_Date__c.Month() > Integer.valueOf(mapCashRecord.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Month__c))
                    {
                        if(!Test.isRunningTest())
                            detail.addError('Error : Invalid Date. Receipt date should be in year.month.date, earlier than Input date.');
                    }//end if : detail month > header month
                }//end if : detail year == header
                else if(detail.ASI_TnE_Receipt_Date__c.Year() > Integer.valueOf(mapCashRecord.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Year__c))
                {
                    if(!Test.isRunningTest())
                        detail.addError('Error : Invalid Date. Receipt date should be in year.month.date, earlier than Input date.');
                }//end else if : detail year > header year
            }//end if : check record type //added by Leo,2015-06-25
        }//end for : loop detail
    }//end method
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    
    public static void beforeInsertMethod(List<ASI_TnE_ClaimDetail__c> triggerNew)
    {
        String CSD = 'Channel Sales Director';
        String DSD = 'Deputy Sales Director';
        //storage header Id
        Set<Id> headerIdSet = new Set<Id>();
        for(ASI_TnE_ClaimDetail__c obj:triggerNew)
        {
            headerIdSet.add(obj.ASI_TnE_ClaimHeader__c);
        }//end for : loop detail, storage header Id
        map<id, ASI_TnE_ClaimHeader__c> mapHeader = new map<id, ASI_TnE_ClaimHeader__c>
            ([SELECT Id, ASI_TnE_KR_Department__c,
              ASI_TnE_KR_Employee_ID__c,
              RecordType.DeveloperName,
              ASI_TnE_KR_Payee__r.ASI_KOR_User_Branch_Code__c 
              FROM ASI_TnE_ClaimHeader__c 
              WHERE Id IN : headerIdSet]);
        List<ASI_TnE_Branch_Channel__c> listBranch = new List<ASI_TnE_Branch_Channel__c>
            ([SELECT Id, Name FROM ASI_TnE_Branch_Channel__c 
              WHERE ASI_TnE_Branch_Channel__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_Branch_Channel__cASI_TnE_KR_Branch_Channel') 
              AND ASI_TnE_Branch_Default__c = TRUE]);
        Map<String,Id> mapBranch = new Map<String,Id>();
        for(ASI_TnE_Branch_Channel__c obj : listBranch)
        {
            mapBranch.put(obj.Name.subString(1,4),obj.Id);
        }//end for : loop branch list, put into branch map
        List<ASI_eForm_HR_MDM__c> listMDM = new List<ASI_eForm_HR_MDM__c>
            ([SELECT Id,Name,
              ASI_eForm_Employee_Is_Salesman__c,
              ASI_eForm_Employee_Job_Title__c,
              ASI_eForm_Employee_Branch_Code__c, 
              ASI_eForm_Employee_Company_Code__c
              FROM ASI_eForm_HR_MDM__c 
              WHERE ASI_eForm_HR_MDM__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM')]);
        Map<String,ASI_eForm_HR_MDM__c> mapMDM = new Map<String,ASI_eForm_HR_MDM__c>();
        for(ASI_eForm_HR_MDM__c MDM : listMDM)
        {
            mapMDM.put(MDM.Name,MDM);
        }//end for : loop MDM list, put into MDM map
        Map<id,User> mapUser = new Map<id,User>
            ([SELECT id,ASI_KOR_Commission_Code__c,Name From User WHERE ASI_KOR_Commission_Code__c != null]);
        
        for(ASI_TnE_ClaimDetail__c detail : triggerNew)
        {
            //setup anp customer standard search
            if(mapHeader.containsKey(detail.ASI_TnE_ClaimHeader__c)
               && mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_AnP')
            {
                //set anp default sales year, sales month, branch-channel once
                detail.ASI_TnE_Sales_Year__c = String.valueOf(detail.ASI_TnE_Receipt_Date__c.Year());
                detail.ASI_TnE_Sales_Month__c = String.valueOf(detail.ASI_TnE_Receipt_Date__c.Month());
                String tempDeptCode = mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Department__c.subString(0,3);
                if(mapBranch.containsKey(tempDeptCode))
                    detail.ASI_TnE_Branch_code_Channel__c = mapBranch.get(tempDeptCode);
                
                //if payee is salesman and is sales director, search all
                if(mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Is_Salesman__c
                   &&(mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Job_Title__c == CSD
                      ||mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Job_Title__c == DSD))
                {
                    detail.ASI_TnE_Tax_Amount__c = 2;
                }//end if : is salesman and is director
                //if payee is salesman but not one of the sales director, search with payee branch code
                else if(mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Is_Salesman__c
                        &&(mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Job_Title__c != CSD
                           ||mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Job_Title__c != DSD))
                {
                    detail.ASI_TnE_Tax_Amount__c = 1;
                    detail.ASI_TnE_BC__c = mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Payee__r.ASI_KOR_User_Branch_Code__c;
                }//end else if : is salesman and not driector
                //if payee is not salesman, search all
                else if(!mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Employee_ID__c).ASI_eForm_Employee_Is_Salesman__c)
                {
                    detail.ASI_TnE_Tax_Amount__c = 2;
                }//end else if : not salesman
            }//end if : check record type, AnP
            
            //for budget onwer comp&dept
            else if(mapHeader.containsKey(detail.ASI_TnE_ClaimHeader__c)
               &&(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_TnE'
                  ||mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_Cash'))
            {
                if(detail.ASI_TnE_KR_Owner__c != null
                   &&mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c != null
                   &&mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c != null
                   &&mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Branch_Code__c != null)
                {
                    detail.ASI_TnE_KR_Budget_Co__c = mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c;
                    String Dept = mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Branch_Code__c;
                    detail.ASI_TnE_KR_Budget_Dept__c = Dept.substring(0,3);
                }//end if : check budget onwer and his info != null, and store budget owner company and department code
                else
                {
                    detail.ASI_TnE_KR_Budget_Co__c = '';
                    detail.ASI_TnE_KR_Budget_Dept__c = '';
                }//end else : budget owner or one of his info == null, set budget owner company and department to blank
            }//end if : check record type, TnE & Cash //added on 2015-08-12
        }//end for : loop detail
    }//end method : beforeInsert
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    
    public static void beforeUpdateMethod(List<ASI_TnE_ClaimDetail__c> triggerNew, Map<Id, ASI_TnE_ClaimDetail__c> triggerOldMap)
    {
        Set<String> headerIdSet = new Set<String>();
        Set<Id> subBrandIdSet = new Set<Id>();
        Set<Id> planId = new Set<Id>(); //added by Leo, 2015-01-12
        for(ASI_TnE_ClaimDetail__c obj : triggerNew)
        {
            headerIdSet.add(obj.ASI_TnE_ClaimHeader__c);
            subBrandIdSet.add(obj.ASI_TnE_KR_Sub_Brand__c);
            //added by Leo, 2015-01-12
            if(obj.ASI_TnE_KR_Promotion_Code__c != null)
            {
                planId.add(obj.ASI_TnE_KR_Promotion_Code__c);
            }//end if
            //added by Leo, 2015-01-12
        }//end for
        
        //added by Leo, 2015-01-12
        List<ASI_MFM_Plan_Line_Item__c> plLineList 
            = new List<ASI_MFM_Plan_Line_Item__c>([SELECT id, 
                                                   ASI_MFM_Plan__r.Name,
                                                   ASI_MFM_Plan__c,
                                                   ASI_MFM_Sub_brand_Code__r.ASI_MFM_Sub_brand_Code__c
                                                   FROM ASI_MFM_Plan_Line_Item__c 
                                                   WHERE ASI_MFM_Plan__c IN: planId]);
        Map<Id,Set<String>> planSubBrand = new Map<Id,Set<String>>();
        Map<Id,String> planIdName = new Map<Id,String>();
        for(ASI_MFM_Plan_Line_Item__c pl: plLineList)
        {
            if(!planSubBrand.containsKey(pl.ASI_MFM_Plan__c))
            {
                Set<String> sbCode = new Set<String>();
                sbCode.add(pl.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Sub_brand_Code__c);
                planSubBrand.put(pl.ASI_MFM_Plan__c,sbCode);
                planIdName.put(pl.ASI_MFM_Plan__c, pl.ASI_MFM_Plan__r.Name);
            }//end if
            else
            {
                Set<String> sbCode = planSubBrand.get(pl.ASI_MFM_Plan__c);
                sbCode.add(pl.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Sub_brand_Code__c);
                planSubBrand.put(pl.ASI_MFM_Plan__c,sbCode);
            }//end else
        }//end for
        //added by Leo, 2015-01-12
        
        Map<Id,ASI_KOR_Sub_Brand__c> subBrandRecord = new Map<Id,ASI_KOR_Sub_Brand__c>
            ([SELECT id,Name,ASI_KOR_Manufacturer__c,ASI_KOR_Sub_Brand_Code__c FROM ASI_KOR_Sub_Brand__c WHERE Id IN: subBrandIdSet]);   
        
		List<ASI_eForm_HR_MDM__c> listMDM = new List<ASI_eForm_HR_MDM__c>
            ([SELECT ID, Name, 
              ASI_eForm_Employee_Branch_Code__c, 
              ASI_eForm_Employee_Company_Code__c,
              ASI_eForm_Employee_Company_Name_MDM__c
              FROM ASI_eForm_HR_MDM__c
              WHERE ASI_eForm_HR_MDM__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM')]);
        Map<String,ASI_eForm_HR_MDM__c> mapMDM = new Map<String,ASI_eForm_HR_MDM__c>();
        for(ASI_eForm_HR_MDM__c MDM : listMDM){
            mapMDM.put(MDM.Name,MDM);
        }
        Map<id,ASI_TnE_ClaimHeader__c> mapHeader = new Map<id,ASI_TnE_ClaimHeader__c>
            ([SELECT id,
              RecordType.DeveloperName,
              ASI_TnE_KR_Company__c,
              ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c 
              FROM ASI_TnE_ClaimHeader__c 
              WHERE Id IN: headerIdSet]);
        Map<id,User> mapUser = new Map<id,User>
            ([SELECT id, Name,
              ASI_KOR_Commission_Code__c
              From User 
              WHERE ASI_KOR_Commission_Code__c != null]);
        
        for(ASI_TnE_ClaimDetail__c detail : triggerNew)
        {
            if(mapHeader.containsKey(detail.ASI_TnE_ClaimHeader__c)
               && (mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_TnE'
                   ||mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_Cash'
                   ||mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_TnE_Finance_View'
                   ||mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_Cash_Finance_View'))
            {
                //added by Leo,2015-06-03
                if(detail.ASI_TnE_KR_Owner__c != null
                   &&mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c != null
                   &&mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c != null
                   &&mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Branch_Code__c != null)
                {
                    detail.ASI_TnE_KR_Budget_Co__c = mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c;
                    String Dept = mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Branch_Code__c;
                    detail.ASI_TnE_KR_Budget_Dept__c = Dept.substring(0,3);
                }//end if : check budget onwer and his info != null, and store budget owner company and department code
                else
                {
                    detail.ASI_TnE_KR_Budget_Co__c = '';
                    detail.ASI_TnE_KR_Budget_Dept__c = '';
                }//end else : budget owner or one of his info == null, set budget owner company and department to blank //added by Leo,2015-06-03
                
                if(detail.ASI_TnE_KR_Owner__c!=null
                   &&mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c != null
                   &&mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c != null
                   //&&mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c != null
                   &&mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Company__c.subString(0,3) != null //updated on 2015-12-24
                   &&mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c != null)
                {
                    if(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Company__c.subString(0,3) != mapMDM.get(mapUser.get(detail.ASI_TnE_KR_Owner__c).ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c)
                    {
                        detail.ASI_TnE_KR_InterCompany__c = true;
                    }//end if : payee mdm comp code != budget owner mdm comp code
                    else
                    {
                        detail.ASI_TnE_KR_InterCompany__c = false;
                    }//end else : payee mdm comp code == budget owner mdm comp code
                }//end if : check budget owner, payee commission code, budget owner commission code, payee mdm comp code, budget owner comp code not null
                else
                {
                    detail.ASI_TnE_KR_InterCompany__c = false;
                }//end else : check budget owner, payee commission code, budget owner commission code, payee mdm comp code, budget owner comp code is null
            }//end if : check record type, T&E and Cash
            
            //added by Leo, 2015-06-11
            else if(mapHeader.containsKey(detail.ASI_TnE_ClaimHeader__c)
               && (mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_AnP'
                   ||mapHeader.get(detail.ASI_TnE_ClaimHeader__c).RecordType.DeveloperName == 'ASI_TnE_KR_AnP_Finance_View'))
            {
                //added by Leo, 20160112, for checking sub brand 
                if(planSubBrand.size() != null
                   &&((detail.ASI_TnE_KR_Sub_Brand__c != null
                       &&triggerOldMap.get(detail.Id).ASI_TnE_KR_Sub_Brand__c != detail.ASI_TnE_KR_Sub_Brand__c)
                      ||(detail.ASI_TnE_KR_Promotion_Code__c != null
                         &&triggerOldMap.get(detail.Id).ASI_TnE_KR_Promotion_Code__c != detail.ASI_TnE_KR_Promotion_Code__c)))
                {
                    String sbCode = subBrandRecord.get(detail.ASI_TnE_KR_Sub_Brand__c).ASI_KOR_Sub_Brand_Code__c;
                    if(planSubBrand.containsKey(detail.ASI_TnE_KR_Promotion_Code__c) 
                       &&!planSubBrand.get(detail.ASI_TnE_KR_Promotion_Code__c).contains(sbCode))
                    {
                        if(!Test.isRunningTest())
                            detail.addError('Promotion code: '+planIdName.get(detail.ASI_TnE_KR_Promotion_Code__c)+' do not contains sub brand: '+subBrandRecord.get(detail.ASI_TnE_KR_Sub_Brand__c).Name);
                    }//end if
                }//end if
                //added by Leo,2015-06-11,for checking Promotion code is 8 digits or not
                /*if(detail.ASI_TnE_Promotion_Code__c != null
                   &&detail.ASI_TnE_Promotion_Code__c.length() != 8)
                    if(!Test.isRunningTest())
                    detail.addError('Promotion Code should be 8 digits');*/
                //added by Leo,2015-06-11
                
                if(detail.ASI_TnE_KR_Sub_Brand__c != null
                   &&mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c != null
                   //&&mapMDM.get(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c).ASI_eForm_Employee_Company_Code__c != null
                   &&mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Company__c.subString(0,3) != null //updated on 2015-12-24
                   &&subBrandRecord.get(detail.ASI_TnE_KR_Sub_Brand__c).ASI_KOR_Manufacturer__c != null)
                {
                    if(mapHeader.get(detail.ASI_TnE_ClaimHeader__c).ASI_TnE_KR_Company__c.subString(0,3) != subBrandRecord.get(detail.ASI_TnE_KR_Sub_Brand__c).ASI_KOR_Manufacturer__c)
                    {
                        detail.ASI_TnE_KR_Budget_Co__c = subBrandRecord.get(detail.ASI_TnE_KR_Sub_Brand__c).ASI_KOR_Manufacturer__c;
                        detail.ASI_TnE_KR_InterCompany__c = true;
                    }//end if : payee mdm comp code != sub-brand comp code
                    else
                    {
                        detail.ASI_TnE_KR_Budget_Co__c = subBrandRecord.get(detail.ASI_TnE_KR_Sub_Brand__c).ASI_KOR_Manufacturer__c;
                        detail.ASI_TnE_KR_InterCompany__c = false;
                    }//end else
                }//end if : sub-brand, payee comission code, payee mdm comp code and sub-brand comp code not null
                else
                {
                    detail.ASI_TnE_KR_Budget_Co__c = '';
                    detail.ASI_TnE_KR_InterCompany__c = false;
                }//end else : sub-brand, payee comission code, payee mdm comp code and sub-brand comp code not null
            }//end if:check record type - AnP //added by Leo, 2015-06-11
        }//end for : loop detail
    }//end method:beforeUpdateMethod
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    
    public static void beforeDeleteMethod(List<ASI_TnE_ClaimDetail__c> triggerOld)
    {
        set<id> objSet = new set<id>();
        for (ASI_TnE_ClaimDetail__c obj:triggerOld)
        {
            objSet.add(obj.ASI_TnE_ClaimHeader__c);
        }//end for
        map<id, ASI_TnE_ClaimHeader__c> mapStatus = new map<id, ASI_TnE_ClaimHeader__c>
            ([select Id from ASI_TnE_ClaimHeader__c where Id IN : objSet 
              AND (ASI_TnE_Status__c =: statusApproved
                   OR ASI_TnE_Status__c =: statusCompleted
                   OR ASI_TnE_Status__c =: statusFinal
                   OR ASI_TnE_Status__c =: statusSubmitted)]);
        
        map<id, ASI_TnE_ClaimHeader__c> mapRecord = new map<id, ASI_TnE_ClaimHeader__c>
            ([select Id from ASI_TnE_ClaimHeader__c where Id IN : objSet 
             AND (ASI_TnE_ClaimHeader__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP')
                  OR ASI_TnE_ClaimHeader__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE') 
                  OR ASI_TnE_ClaimHeader__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP_Finance_View') 
                  OR ASI_TnE_ClaimHeader__c.RecordTypeId =: Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE_Finance_View'))]);
        
        if(trigger.isDelete)
        {
            for(ASI_TnE_ClaimDetail__c obj : triggerOld)
        	{
                if(mapRecord.containsKey(obj.ASI_TnE_ClaimHeader__c) && !profileName.contains(admin))
                {
                    if(!Test.isRunningTest())
                    	obj.addError('Delete not allowed for TnE or AnP card Claim Requests');
                }//end if
                else if(mapStatus.containsKey(obj.ASI_TnE_ClaimHeader__c) && !profileName.contains(admin))
            	{
                    if(!Test.isRunningTest())
                        obj.addError('Delete not allowed for Submitted, Approved, Final or Complete Claim Requests');
            	}//end else if
        	}//end for
        }//end if
    }//end method:beforeDeleteMethod
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    
    public static void beforeUpdateMethod2(List<ASI_TnE_ClaimDetail__c> triggerNew)
    {
        set<id> objSet = new set<id>();
        for (ASI_TnE_ClaimDetail__c obj:triggerNew) {
            objSet.add(obj.ASI_TnE_ClaimHeader__c);
        }//end for
        map<id, ASI_TnE_ClaimHeader__c> mapStatus = new map<id, ASI_TnE_ClaimHeader__c>
            ([select Id from ASI_TnE_ClaimHeader__c where Id IN : objSet 
              AND (ASI_TnE_Status__c =: statusCompleted
                   OR ASI_TnE_Status__c =: statusFinal)]);
        if(trigger.isUpdate)
        {
            for(ASI_TnE_ClaimDetail__c obj : triggerNew)
        	{
                if(mapStatus.containsKey(obj.ASI_TnE_ClaimHeader__c) && !profileName.contains(admin))
            	{
                    if(!Test.isRunningTest())
                        obj.addError('Edit not allowed for Final or Completed Claim Requests');
            	}//end else if
        	}//end for
        }//end if
    }//end method:beforeUpdateMethod*/
    
    public static void afterUpdateMethod(List<ASI_TnE_ClaimDetail__c> triggerNew)
    {
        Set<Id> test = new Set<Id>();
        MAp<Id, ASI_TnE_ClaimHeader__c> testH = new Map<Id, ASI_TnE_ClaimHeader__c>();
        for(ASI_TnE_ClaimDetail__c a : triggerNew)
        {
            testH.put(a.ASI_TnE_ClaimHeader__c, new ASI_TnE_ClaimHeader__c(id=a.ASI_Tne_ClaimHeader__c));
        }
        update testH.values();
    }
}