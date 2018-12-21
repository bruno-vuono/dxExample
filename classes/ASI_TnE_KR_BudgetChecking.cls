public without sharing class ASI_TnE_KR_BudgetChecking
{
    public static void BudgetCheck(list<ASI_TnE_ClaimHeader__c> trigger_new)
    {
        User curUser = [SELECT BypassTriggers__c FROM User WHERE Id =: userinfo.getUserId()];
        if(curUser.BypassTriggers__c == null 
           ||(curUser.BypassTriggers__c != null
              &&!curUser.BypassTriggers__c.contains('ASI_TnE_KR_BudgetChecking')))
        {
            //variable for storage info
            String fiscalYear;
            Map<Id, String> fiscalYearMap = new Map<Id, String>();
            Date startDate;
            Map<Id, Date>startDateMap = new Map<Id, Date>();
            Date dueDate;
            Map<Id, Date>dueDateMap = new Map<Id, Date>();
            Date statementDate;
            Map<Id, Date>statementDateMap = new Map<Id, Date>();
            String curStatus;
            Map<Id, String>curStatusMap = new Map<Id, String>();
            String curHeaderId;
            Map<Id, ASI_TnE_ClaimHeader__c> curHeaderIdMap = new Map<Id, ASI_TnE_ClaimHeader__c>();
            
            
            //record type API name
            String developerNameOfTnE = 'ASI_TnE_KR_TnE';
            String developerNameOfTnEFV = 'ASI_TnE_KR_TnE_Finance_View';
            String developerNameOfCash = 'ASI_TnE_KR_Cash';
            String developerNameOfCashFV = 'ASI_TnE_KR_Cash_Finance_View';
            String developerNameOfAnP = 'ASI_TnE_KR_AnP';
            String developerNameOfAnPFV = 'ASI_TnE_KR_AnP_Finance_View';
            String developerNameOfDetail = 'ASI_TnE_KR_Claim_Detail';
            
            //status
            String statusDraft = 'Draft';
            String statusReject = 'Rejected';
            String statusSubmitted = 'Submitted';
            String statusApproved = 'Approved';
            String statusFinal = 'Final';
            String statusCompleted = 'Complete';
            
            List<double> budgetUsed = new List<double>();
            List<ASI_TnE_Employee_Budget__c> budgetList = new List<ASI_TnE_Employee_Budget__c>();
            Map<String, ASI_TnE_Employee_Budget__c> budgetMap = new Map<String, ASI_TnE_Employee_Budget__c>();
            List<ASI_TnE_ClaimDetail__c> allSpent = new List<ASI_TnE_ClaimDetail__c>();
            List<ASI_TnE_ClaimDetail__c> allTnERecord = new List<ASI_TnE_ClaimDetail__c>();
            List<ASI_TnE_ClaimDetail__c> allAnPRecord = new List<ASI_TnE_ClaimDetail__c>();
            List<ASI_TnE_ClaimDetail__c> allTnESpent = new List<ASI_TnE_ClaimDetail__c>();
            List<ASI_TnE_ClaimDetail__c> allAnPSpent = new List<ASI_TnE_ClaimDetail__c>();
            Map<String, Double> ytdAmountMap = new Map<String, Double>();
            Map<id,RecordType> mapRt = new Map<id,RecordType>
                ([SELECT id,DeveloperName FROM RecordType WHERE sObjectType =:'ASI_TnE_ClaimHeader__c' and DeveloperName like 'ASI_TnE_KR%']);
            Map<id,User> userMapping = new Map<id,User>
                ([SELECT id,ASI_KOR_Commission_Code__c FROM USER WHERE ASI_KOR_Commission_Code__c != null]);
            Set<String> userDetail = new Set<String>();
            Map<Integer,Integer> monthConvert = new Map<Integer,Integer>();
            monthConvert.put(7, 1);
            monthConvert.put(8, 2);
            monthConvert.put(9, 3);
            monthConvert.put(10, 4);
            monthConvert.put(11, 5);
            monthConvert.put(12, 6);
            monthConvert.put(1, 7);
            monthConvert.put(2, 8);
            monthConvert.put(3, 9);
            monthConvert.put(4, 10);
            monthConvert.put(5, 11);
            monthConvert.put(6, 12);
            
            //define variables
            for(ASI_TnE_ClaimHeader__c obj : trigger_new)
            {
                if(userMapping.get(obj.ASI_TnE_KR_Payee__c) != null && userMapping.get(obj.ASI_TnE_KR_Payee__c).ASI_KOR_Commission_Code__c != null)
                    userDetail.add(userMapping.get(obj.ASI_TnE_KR_Payee__c).ASI_KOR_Commission_Code__c); //store a set of payee commission code
                statementDateMap.put(obj.Id, obj.ASI_TnE_KR_GL_Date__c);//store current header GL date
                curStatusMap.put(obj.Id, obj.ASI_TnE_Status__c); //store current header status
                curHeaderIdMap.put(obj.Id, obj); //store current header id
                
                //define fiscal year
                if(statementDateMap.get(obj.Id) != null && statementDateMap.get(obj.Id).month()>=7){
                    startDateMap.put(obj.Id, Date.newInstance(statementDateMap.get(obj.Id).year(), 7, 1));
                    dueDateMap.put(obj.Id, Date.newInstance(statementDateMap.get(obj.Id).year()+1, 6, 30));
                    fiscalYearMap.put(obj.Id, 'FY' + String.valueOf(statementDateMap.get(obj.Id).year()-2000) + String.valueOf(statementDateMap.get(obj.Id).year()-1999));
                }//end if
                else if(statementDateMap.get(obj.Id) != null && statementDateMap.get(obj.Id).month()<7)
                {
                    startDateMap.put(obj.Id, Date.newInstance(statementDateMap.get(obj.Id).year()-1, 7, 1));
                    dueDateMap.put(obj.Id, Date.newInstance(statementDateMap.get(obj.Id).year(), 6, 30));
                    fiscalYearMap.put(obj.Id, 'FY' + String.valueOf(statementDateMap.get(obj.Id).year()-2001) + String.valueOf(statementDateMap.get(obj.Id).year()-2000));
                }//end else if
                //finish define variables
            }//end for
            
            for(Id d : startDateMap.keySet())
            {
                if(startDate == null)
                    startDate = startDateMap.get(d);
                else if(startDate != null && startDateMap.get(d) <= startDate)
                    startDate = startDateMap.get(d);
                
                if(dueDate == null)
                    dueDate = dueDateMap.get(d);
                else if(dueDate != null && dueDateMap.get(d) >= dueDate)
                    dueDate = dueDateMap.get(d);
            }
            
            
            
            //getting budget records
            budgetList = [SELECT Id,
                          ASI_TnE_Employee_No__c,
                          ASI_TnE_P1_Amount__c,ASI_TnE_P2_Amount__c,ASI_TnE_P3_Amount__c,
                          ASI_TnE_P4_Amount__c,ASI_TnE_P5_Amount__c,ASI_TnE_P6_Amount__c,
                          ASI_TnE_P7_Amount__c,ASI_TnE_P8_Amount__c,ASI_TnE_P9_Amount__c,
                          ASI_TnE_P10_Amount__c,ASI_TnE_P11_Amount__c,ASI_TnE_P12_Amount__c,
                          ASI_TnE_Fiscal_Year__c FROM ASI_TnE_Employee_Budget__c WHERE ASI_TnE_Fiscal_Year__c IN: fiscalYearMap.values() 
                          AND ASI_TnE_Employee_No__c IN: userDetail
                         ];
            //put list of budget into a map
            for(ASI_TnE_Employee_Budget__c obj : budgetList)
            {
                budgetMap.put(obj.ASI_TnE_Employee_No__c, obj);
            }
            
            //get TnE spent records
            allTnERecord = [SELECT Id,
                            ASI_TnE_Non_Taxable_Amount__c,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__c,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c,
                            ASI_TnE_KR_Owner__r.ASI_KOR_Commission_Code__c,
                            ASI_TnE_Receipt_Amount__c,
                            ASI_TnE_Receipt_Date__c,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c,
                            ASI_TnE_ClaimHeader__r.id,
                            ASI_TnE_ClaimHeader__r.RecordType.DeveloperName,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c,
                            ASI_TnE_Expense_Classification__r.ASI_JP_TnE_Account_Mapping__r.ASI_TnE_KR_TnE_Budget__c,
                            Name
                            FROM ASI_TnE_ClaimDetail__c
                            WHERE recordtype.DeveloperName LIKE: developerNameOfDetail
                            AND ((ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c>=:startDate
                                  AND ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c<=:dueDate)
                                 OR ASI_TnE_ClaimHeader__r.id IN: curHeaderIdMap.keySet())
                            AND 
                            (
                                ASI_TnE_Expense_Classification__r.ASI_JP_TnE_Account_Mapping__r.ASI_TnE_KR_TnE_Budget__c = TRUE
                                OR ASI_TnE_Expense_Classification__c = NULL
                                OR ASI_TnE_Expense_Classification__c = ''
                            )
                            AND
                            (
                                ASI_TnE_ClaimHeader__r.RecordType.DeveloperName LIKE: developerNameOfTnE
                                OR ASI_TnE_ClaimHeader__r.RecordType.DeveloperName LIKE: developerNameOfTnEFV
                                OR ASI_TnE_ClaimHeader__r.RecordType.DeveloperName LIKE: developerNameOfCash
                                OR ASI_TnE_ClaimHeader__r.RecordType.DeveloperName LIKE: developerNameOfCashFV
                            )
                            AND
                            (
                                ASI_TnE_KR_Owner__r.ASI_KOR_Commission_Code__c IN : userDetail
                                OR ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c IN : userDetail
                            )];
            
            //get AnP wrong spent records
            allAnPRecord = [SELECT Id,
                            ASI_TnE_Non_Taxable_Amount__c,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__c,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c,
                            ASI_TnE_KR_Owner__r.ASI_KOR_Commission_Code__c,
                            ASI_TnE_Receipt_Amount__c,
                            ASI_TnE_Receipt_Date__c,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c,
                            ASI_TnE_ClaimHeader__r.id,
                            ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c,
                            ASI_TnE_ClaimHeader__r.RecordType.DeveloperName,
                            Name
                            FROM ASI_TnE_ClaimDetail__c
                            WHERE RecordType.DeveloperName LIKE: developerNameOfDetail
                            AND ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c>=:startDate
                            AND ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c<=:dueDate
                            AND ASI_TnE_Dept_in_Charge__c = 'Wrong Use'
                            AND
                            (
                                ASI_TnE_ClaimHeader__r.RecordType.DeveloperName LIKE: developerNameOfAnP
                                OR ASI_TnE_ClaimHeader__r.RecordType.DeveloperName LIKE: developerNameOfAnPFV
                            )
                            AND
                            (
                                ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__r.ASI_KOR_Commission_Code__c IN : userDetail
                            )];
            System.debug('CHECK000:  '+allTnERecord.size());
            //--------------------------------------------------Filter Record-------------------------------------------------------------//        
            //filter TnE calculation records
            for(ASI_TnE_ClaimDetail__c records : allTnERecord)
            {
                //if is TnE card
                if((records.ASI_TnE_ClaimHeader__r.RecordType.DeveloperName == developerNameOfTnE
                    ||records.ASI_TnE_ClaimHeader__r.RecordType.DeveloperName == developerNameOfTnEFV))
                {
                    allTnESpent.add(records);
                }//end if: TnE card record type
                //if is TnE Cash
                else if(records.ASI_TnE_ClaimHeader__r.RecordType.DeveloperName == developerNameOfCash
                        ||records.ASI_TnE_ClaimHeader__r.RecordType.DeveloperName == developerNameOfCashFV)
                {
                    //if current header is changing status, Rejected => Submitted / Draft => Submitted
                    if((curHeaderIdMap.containsKey(records.ASI_TnE_ClaimHeader__r.Id))
                       &&(records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == statusReject && curStatusMap.get(records.ASI_TnE_ClaimHeader__r.Id) == statusSubmitted
                          ||records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == statusDraft && curStatusMap.get(records.ASI_TnE_ClaimHeader__r.Id) == statusSubmitted))
                    {
                        allTnESpent.add(records);
                    }//end if
                    //if current header is changing status, Submitted => Rejected / Approved => Rejected / Submitted => Draft / Approved => Draft
                    else if((curHeaderIdMap.containsKey(records.ASI_TnE_ClaimHeader__r.Id))
                            &&(records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == statusSubmitted && curStatusMap.get(records.ASI_TnE_ClaimHeader__r.Id) == statusReject
                               ||records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == statusApproved && curStatusMap.get(records.ASI_TnE_ClaimHeader__r.Id) == statusReject
                               ||records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == statusSubmitted && curStatusMap.get(records.ASI_TnE_ClaimHeader__r.Id) == statusDraft
                               ||records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == statusApproved && curStatusMap.get(records.ASI_TnE_ClaimHeader__r.Id) == statusDraft))
                    {
                        //DO NOT add to list
                    }//end else if
                    //for other claim detail records, not in status Rejected / Draft
                    else if(records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != statusReject && records.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != statusDraft)
                    {
                        allTnESpent.add(records);
                    }//end else if
                }//end else if: Cash record type
            }//end for: loop all TnE record
            
            //filter AnP calculation records
            for(ASI_TnE_ClaimDetail__c records : allAnPRecord)
            {
                //if is AnP card
                if((records.ASI_TnE_ClaimHeader__r.RecordType.DeveloperName == developerNameOfAnP
                    ||records.ASI_TnE_ClaimHeader__r.RecordType.DeveloperName == developerNameOfAnPFV))
                {
                    allAnPSpent.add(records);
                }//end if
            }//end for
            
            
            System.debug('CHECK001:  '+allTnESpent.size());
            //add all records into one list
            allSpent.addAll(allTnESpent);
            allSpent.addAll(allAnPSpent);
            //--------------------------------------------------Filter Record-------------------------------------------------------------//
            
            //-----------------------------------------------Calculate Spenting-----------------------------------------------------------//
            for(Id curHeader : curHeaderIdMap.keySet())
            {
                System.debug('CHECK002:  '+curHeader);
                ytdAmountMap.clear();
                for(ASI_TnE_ClaimDetail__c checkRecord : allSpent)
                {
                    System.debug('CHECK003.1:  '+checkRecord.ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__c+'  3.1.1:  '+curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c);
                    System.debug('CHECK003.2:  '+checkRecord.ASI_TnE_KR_Owner__c+'  3.2.1:  '+curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c);
                    System.debug('CHECK003.3:  '+checkFiscalYear(curHeaderIdMap.get(curHeader).ASI_TnE_KR_GL_Date__c)+'  3.3.1:  '+checkFiscalYear(checkRecord.ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c));
                    if(checkRecord.ASI_TnE_ClaimHeader__r.Id == curHeader 
                       ||(
                           (checkRecord.ASI_TnE_ClaimHeader__r.ASI_TnE_KR_Payee__c == curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c
                            ||checkRecord.ASI_TnE_KR_Owner__c == curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c)
                           &&(checkFiscalYear(curHeaderIdMap.get(curHeader).ASI_TnE_KR_GL_Date__c) == checkFiscalYear(checkRecord.ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c))
                       ))
                    {
                        System.debug('CHECK004:  '+ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c));
                        if((checkRecord.ASI_TnE_ClaimHeader__r.Id == curHeader || startDateMap.get(curHeader).monthsBetween(checkRecord.ASI_TnE_ClaimHeader__r.ASI_TnE_KR_GL_Date__c)
                            <=startDateMap.get(curHeader).monthsBetween(statementDateMap.get(curHeader)))
                           &&((checkRecord.ASI_TnE_KR_Owner__c != null && checkRecord.ASI_TnE_KR_Owner__c == curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c)
                              ||checkRecord.ASI_TnE_KR_Owner__c == null))
                        {
                            if(checkRecord.ASI_TnE_Non_Taxable_Amount__c!=null&&checkRecord.ASI_TnE_Non_Taxable_Amount__c!=0)
                            {
                                System.debug('CHECK005.1:  '+ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c));
                                if(ytdAmountMap.containsKey(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c))
                                    ytdAmountMap.put(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c, ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c) + checkRecord.ASI_TnE_Non_Taxable_Amount__c);
                                else
                                    ytdAmountMap.put(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c, checkRecord.ASI_TnE_Non_Taxable_Amount__c);
                            }//end if
                            else
                            {
                                System.debug('CHECK005.2:  '+ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c));
                                if(ytdAmountMap.containsKey(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c))
                                    ytdAmountMap.put(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c, ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c) + checkRecord.ASI_TnE_Receipt_Amount__c);
                                else
                                    ytdAmountMap.put(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c, checkRecord.ASI_TnE_Receipt_Amount__c);
                            }//end else
                        }//end if:
                    }
                }//for detail loop - all spent
                curHeaderIdMap.get(curHeader).ASI_TnE_KR_YTD_Spending__c = ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c) != null ? ytdAmountMap.get(curHeaderIdMap.get(curHeader).ASI_TnE_KR_Payee__c) : 0;
            }//for currrent header loop
            //-----------------------------------------------Calculate Spenting-----------------------------------------------------------//
            
            //calculate budget
            for(ASI_TnE_ClaimHeader__c triggerNew : trigger_new)
            {
                Double ytdAmount=0;
                //check record type
                if(mapRt.get(triggerNew.RecordTypeId).DeveloperName==developerNameOfTnE||mapRt.get(triggerNew.RecordTypeId).DeveloperName==developerNameOfCash
                   ||mapRt.get(triggerNew.RecordTypeId).DeveloperName==developerNameOfTnEFV||mapRt.get(triggerNew.RecordTypeId).DeveloperName==developerNameOfCashFV)
                {
                    Double totalBudget = 0;
                    Integer GLMonth = Integer.valueOf(triggerNew.ASI_TnE_KR_GL_Date__c.month());
                    if(budgetList.size() != 0)
                    {
                        if(budgetMap.containsKey(userMapping.get(triggerNew.ASI_TnE_KR_Payee__c).ASI_KOR_Commission_Code__c)
                           &&budgetMap.get(userMapping.get(triggerNew.ASI_TnE_KR_Payee__c).ASI_KOR_Commission_Code__c).ASI_TnE_Fiscal_Year__c==fiscalYearMap.get(triggerNew.Id))
                        {
                            for(Integer i = 1 ; i<=12;i++)
                            {
                                String monthBudget = 'ASI_TnE_P'+i+'_Amount__c';
                                if(budgetMap.get(userMapping.get(triggerNew.ASI_TnE_KR_Payee__c).ASI_KOR_Commission_Code__c).get(monthBudget)!=null)
                                    totalBudget += Double.valueOf(budgetMap.get(userMapping.get(triggerNew.ASI_TnE_KR_Payee__c).ASI_KOR_Commission_Code__c).get(monthBudget));
                            }//end for
                            totalBudget = totalBudget*monthConvert.get(GLMonth)/12;
                            triggerNew.ASI_TnE_KR_YTD_Budget__c = totalBudget;
                            
                            if(triggerNew.ASI_TnE_KR_YTD_Spending__c > totalBudget)
                                triggerNew.ASI_tnE_KR_Over_Budget__c = 'Yes';
                            else
                                triggerNew.ASI_tnE_KR_Over_Budget__c = 'No';
                        }//end if
                    }//end if
                    else
                    {
                        triggerNew.ASI_TnE_KR_YTD_Budget__c = totalBudget;
                        if(triggerNew.ASI_TnE_KR_YTD_Spending__c > totalBudget)
                            triggerNew.ASI_tnE_KR_Over_Budget__c = 'Yes';
                        else
                            triggerNew.ASI_tnE_KR_Over_Budget__c = 'No';
                    }//end else
                }//if: record type check
            }//end header loop
        }//end if: check byPass
    }//end method
    
    public static String checkFiscalYear(Date day)
    {
        String fiscalYear;
        //define fiscal year
        if(day.month()>=7){
            return fiscalYear = 'FY' + String.valueOf(day.year()-2000) + String.valueOf(day.year()-1999);
        }//end if
        else if(day.month()<7)
        {
            return fiscalYear = 'FY' + String.valueOf(day.year()-2001) + String.valueOf(day.year()-2000);
        }//end else if
        //finish define variables
        return fiscalYear = 'FY';
    }
}//end class