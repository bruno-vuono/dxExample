global class ASI_MFM_CN_WebServiceForEMarket {
    global ASI_MFM_CN_WebServiceForEMarket (){
        
    }       
    
    global class Plan{
        webservice String Id {get;set;}
        webservice String Name {get;set;}
    }
    
    global class GetMFMPlansIdResult{
        webservice List<Plan> Plans {get;set;}
        webservice String CompletionCode {get;set;} // S = Success, F = Fail
        webservice String FailMsg {get;set;} // Filled when Completion Code = F
    }
    
    global class PPCategoryAC{
        webservice String Code {get;set;}
        webservice String Description {get;set;}
    }
    
    global class EventPP{
        webservice String Code {get;set;}
        webservice String Description {get;set;}
    }
    
    global class GetMFMPlanDetailsResult{
        webservice String Name {get;set;}
        webservice Double Amount {get;set;}
        webservice Double TtlPoAmount {get;set;}
        webservice Boolean DummyInd {get;set;}
        webservice List<PPCategoryAC> PPCategoryACs {get;set;}
        webservice List<EventPP> EventPPs {get;set;}
        webservice String CompletionCode {get;set;} // S = Success, F = Fail
        webservice String FailMsg {get;set;} // Filled when Completion Code = F
    }
    
    global class POInfo{
        webservice String Id {get;set;}
        webservice Double Amount {get;set;}
        webservice Double AmountInLocalCurrency {get;set;}
    }
    
    global class GetMFMPlanBalanceResult{
        webservice String Id {get;set;}
        webservice String Name {get;set;}
        webservice Double Amount {get;set;}
        webservice List<POInfo> POInfos {get;set;}
        webservice Boolean DummyInd {get;set;}              
        webservice String CompletionCode {get;set;} // S = Success, F = Fail
        webservice String FailMsg {get;set;} // Filled when Completion Code = F
    }
    
    global class PODetail{
        webservice String AccountCode {get;set;}
        webservice Double Amount {get;set;}
        webservice String SkuCode {get;set;}
        webservice String Description {get;set;}
        webservice Double Quantity {get;set;}
        webservice Double UnitPrice {get;set;}
//        webservice String UnitPrice {get;set;}
    }
    
    global class CreatePORequestArgs{
        webservice String eMarketBuyerEmail {get;set;}//20160427 Ben @ Elufa
        webservice String PlanId {get;set;}
        webservice String PrDept {get;set;}
        webservice Boolean BudgetControlReqInd {get;set;}
        webservice String Bu {get;set;}
        webservice String SubBrand {get;set;}
        webservice String ResponsibleBy {get;set;}
        webservice String EventId {get;set;}
        webservice String SupplierNo {get;set;}
        webservice String PrNo {get;set;}
        webservice String Vat {get;set;}
        webservice String DeemSalesApplies {get;set;}
        webservice List<PoDetail> PoDetails {get;set;}
        webservice String TaskID {get;set;} 
    }
    
    global class CreatePOResult{                        
        webservice String CompletionCode {get;set;} // S = Success, F = Fail
        webservice String FailMsg {get;set;} // Filled when Completion Code = F
        webservice String PoId {get;set;}
    }
    
    global class CompletePOResult{                      
        webservice String CompletionCode {get;set;} // S = Success, F = Fail
        webservice String FailMsg {get;set;} // Filled when Completion Code = F     
    }
    
    Webservice static GetMFMPlansIdResult GetMFMPlansIdRequest(String prDept, String fiscalYear, String subBrand){
        GetMFMPlansIdResult result = new GetMFMPlansIdResult();         
        result.CompletionCode = 'S';
        result.Plans = new List<Plan>();                
        
        if (prDept.equals('') || prDept.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'PR Department cannot be empty.';          
            return result;
        }
        
        if (!prDept.equals('22') && !prDept.equals('25')){
            result.CompletionCode = 'F';
            result.FailMsg = 'PR Department must be 22 or 25.';         
            return result;
        }
        
        if (fiscalYear == ''){
            result.CompletionCode = 'F';
            result.FailMsg = 'Fiscal Year cannot be empty.';            
            return result;
        }
        
        if (fiscalYear.left(2) != 'FY' || fiscalYear.length() !=  4){
            result.CompletionCode = 'F';
            result.FailMsg = 'Fiscal Year pattern must be prefixed with FY with 2 digits.';         
            return result;
        }
        
        try {
            Integer x = Integer.valueOf(fiscalYear.right(2));
        }
        Catch (exception e) {
            result.CompletionCode = 'F';
            result.FailMsg = 'Fiscal Year pattern must be prefixed with FY with 2 digits.';         
            return result;
        }
        
                                
        fiscalYear += '%';
        try{
            if (prDept.equals('22') ){
                prDept = 'CNB%';
            }else if (prDept.equals('25') ){
                prDept = 'CNT%';
            }
            
            List<ASI_MFM_Plan_Line_Item__c> plans = [SELECT ASI_MFM_Plan__r.Name, 
                ASI_MFM_Plan__r.ASI_MFM_Plan_Description__c, 
                ASI_MFM_Plan__r.ASI_MFM_Plan_Name__c  FROM ASI_MFM_Plan_Line_Item__c 
//            WHERE ASI_MFM_Plan__r.ASI_MFM_Fiscal_Year_look_up__r.Name like :fiscalYear 
              WHERE ASI_MFM_Plan__r.ASI_MFM_Fiscal_year__c like :fiscalYear
            AND ASI_MFM_Plan__r.ASI_MFM_Prefix__r.name like :prDept
            AND ASI_MFM_Sub_brand_Code__r.ASI_MFM_Sub_brand_Code__c = :subBrand];
            
            for (ASI_MFM_Plan_Line_Item__c plan : plans){
                Plan p = new Plan();
                //p.id = plan.ASI_MFM_Plan__r.ASI_MFM_Plan_Description__c;
                p.Id = plan.ASI_MFM_Plan__r.Name;  //Edited by Michael Yip (Introv) 23Jun2014 to replace plan name with description
                //p.Name = plan.ASI_MFM_Plan__r.ASI_MFM_Plan_Name__c;
                p.Name = plan.ASI_MFM_Plan__r.ASI_MFM_Plan_Description__c;
                result.Plans.add(p);
            }
        } catch (Exception e) {
                // Process exception here                   
                result.CompletionCode = 'F';
                result.FailMsg = 'System runtime exception error (' + String.valueof(e) + ')';
        }
        
        return result; 
    }   
    
    Webservice static GetMFMPlanDetailsResult GetMFMPlanDetailsRequest(String planId){
        GetMFMPlanDetailsResult result = new GetMFMPlanDetailsResult();         
        result.CompletionCode = 'S';
        result.PPCategoryACs = new List<PPCategoryAC>();
        result.EventPPs = new List<EventPP>();
        
        if (planId.equals('') || planId.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Plan ID cannot be empty.';            
            return result;
        }
        
        try{
            List<ASI_MFM_Plan__c> plans = [SELECT Id, ASI_MFM_Plan_Name__c, ASI_MFM_Plan_Amount__c, 
                ASI_MFM_CN_Total_PO_Amount__c, ASI_MFM_CN_Dummy__c, ASI_MFM_PP_Category__c, ASI_MFM_Plan_Description__c  
                FROM ASI_MFM_Plan__c 
                WHERE (recordtype.developername = 'ASI_MFM_CN_Plan' OR recordtype.developername = 'ASI_MFM_CN_Plan_Read_Only') and name = :planId ];
            
            System.debug('planId:'+planId);
                
            if (plans.size() == 0){
                result.CompletionCode = 'F';
                result.FailMsg = 'Invalid Plan ID.';            
                return result;
            }               
            
            ASI_MFM_Plan__c plan = plans[0];
            result.Name = plan.ASI_MFM_Plan_Description__c;
            //result.Name = plan.ASI_MFM_Plan_Name__c; //Edited by Michael Yip (Introv) 23Jun2014 to replace plan name with description
            result.Amount = plan.ASI_MFM_Plan_Amount__c;
            result.TtlPoAmount = plan.ASI_MFM_CN_Total_PO_Amount__c;
            result.DummyInd = plan.ASI_MFM_CN_Dummy__c;
            
            List<ASI_MFM_PP_Category_A_C__c> ppCategorys = [SELECT ASI_MFM_A_C_Code__r.Name, ASI_MFM_A_C_Name__c  FROM ASI_MFM_PP_Category_A_C__c 
            WHERE ASI_MFM_PP_Category__c = :plan.ASI_MFM_PP_Category__c];
            
            for (ASI_MFM_PP_Category_A_C__c ppCategory : ppCategorys){
                PPCategoryAC p = new PPCategoryAC();
                
                p.Code = ppCategory.ASI_MFM_A_C_Code__r.Name;
                p.Description = ppCategory.ASI_MFM_A_C_Name__c;
                result.PPCategoryACs.add(p);
            }
            
          List<ASI_MFM_Event_PP__c> eventPPs = [SELECT id, ASI_MFM_Event__r.Name, ASI_MFM_Event__r.ASI_MFM_Event_ID__c FROM ASI_MFM_Event_PP__c 
            WHERE ASI_MFM_Plan__c = :plan.Id];
            
            for (ASI_MFM_Event_PP__c eventPP : eventPPs){
                EventPP p = new EventPP();
                
                p.Code = eventPP.id;
//              p.Description = eventPP.ASI_MFM_Event__r.ASI_MFM_Event_ID__c;
                p.Description = eventPP.ASI_MFM_Event__r.Name;
                result.EventPPs.add(p);

            }
        } catch (Exception e) {
                // Process exception here                   
                result.CompletionCode = 'F';
                result.FailMsg = 'System runtime exception error (' + String.valueof(e) + ')';
        }       
        
        return result;
    }
    
    Webservice static GetMFMPlanBalanceResult GetMFMPlanBalanceRequest(String planId){
        GetMFMPlanBalanceResult result = new GetMFMPlanBalanceResult();         
        result.CompletionCode = 'S';
        result.POInfos = new List<POInfo>();        
        
        if (planId.equals('') || planId.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Plan ID cannot be empty.';            
            return result;
        }
        
        try{
            List<ASI_MFM_Plan__c> plans = [SELECT Id, Name, ASI_MFM_Plan_Name__c, ASI_MFM_Plan_Amount__c, ASI_MFM_CN_Total_PO_Amount__c, ASI_MFM_CN_Dummy__c, ASI_MFM_PP_Category__c 
                FROM ASI_MFM_Plan__c 
                WHERE (recordtype.developername = 'ASI_MFM_CN_Plan' OR recordtype.developername = 'ASI_MFM_CN_Plan_Read_Only') and name = :planId ];
                
            if (plans.size() == 0){
                result.CompletionCode = 'F';
                result.FailMsg = 'Invalid Plan ID.';            
                return result;
            }               
            
            ASI_MFM_Plan__c plan = plans[0];
            
            result.Id = plan.name;
            result.Name = plan.ASI_MFM_Plan_Name__c;
            //result.Amount = plan.ASI_MFM_Plan_Amount__c;
            result.Amount = plan.ASI_MFM_CN_Total_PO_Amount__c;
            result.DummyInd = plan.ASI_MFM_CN_Dummy__c;
            
            List<ASI_MFM_PO__c> pos = [SELECT Name, ASI_MFM_PO_Amount__c, ASI_MFM_Base_Currency_Amount__c  FROM ASI_MFM_PO__c 
            WHERE ASI_MFM_Plan__c = :plan.Id];
            
            for (ASI_MFM_PO__c po : pos){
                POInfo p = new POInfo();
                
                p.Id = po.Name;
                p.Amount = po.ASI_MFM_PO_Amount__c;
                p.AmountInLocalCurrency = po.ASI_MFM_Base_Currency_Amount__c;
                
                result.POInfos.add(p);
            }
                        
        } catch (Exception e) {
                // Process exception here                   
                result.CompletionCode = 'F';
                result.FailMsg = 'System runtime exception error (' + String.valueof(e) + ')';
        }       
        
        return result;
    }
    
    Webservice static CreatePOResult CreatePORequest(CreatePORequestArgs args){
        CreatePOResult result = new CreatePOResult();           
        result.CompletionCode = 'S';
        RecordType cnPOrecordType = Global_RecordTypeCache.getRtRec('ASI_MFM_PO__cASI_MFM_CN_PO');//[SELECT Id FROM RecordType WHERE Name = 'CN PO'];
        
        if (args.PrDept.equals('') || args.PrDept.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'PR Department cannot be empty.';          
            return result;
        }
        
        if (!args.PrDept.equals('22') && !args.PrDept.equals('25')){
            result.CompletionCode = 'F';
            result.FailMsg = 'PR Department must be 22 or 25.';         
            return result;
        }   
        system.debug('e001: ' + args.PrDept); 
        if (args.PlanId.equals('') || args.PlanId.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Plan ID cannot be empty.';            
            return result;
        }
        system.debug('e002: ' + args.PlanId);
        /*
        if (args.BudgetControlReqInd == null){
            result.CompletionCode = 'F';
            result.FailMsg = 'Budget Control Required Indicator cannot be empty.';          
            return result;
        }       */
        
        if (args.Bu.equals('') || args.Bu.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'BU cannot be empty.';         
            return result;
        }
        system.debug('e003: ' + args.Bu);
        if (args.SubBrand.equals('') || args.SubBrand.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Sub-Brand cannot be empty.';          
            return result;
        }
        system.debug('e004: ' + args.SubBrand);
        if (args.ResponsibleBy.equals('') || args.ResponsibleBy.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Responsible By cannot be empty.';         
            return result;
        }
        System.debug(args);
        /*if (args.PrDept == '25' && (args.EventId.equals('') || args.EventId.equals(null))){
            result.CompletionCode = 'F';
            result.FailMsg = 'Event ID cannot be empty.';           
            return result;
        }*/
        
        if (args.SupplierNo.equals('') || args.SupplierNo.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Supplier cannot be empty.';           
            return result;
        }
        system.debug('e005: ' + args.SupplierNo);
        if (args.PrNo.equals('') || args.PrNo.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'PR Number cannot be empty.';          
            return result;
        }   
        system.debug('e006: ' + args.PrNo);
        if (args.Vat.equals('') || args.Vat.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'VAT Savings cannot be empty.';            
            return result;
        }   
        system.debug('e007: ' + args.Vat);
       	
        if (args.TaskID.equals('') || args.TaskID.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'Task ID cannot be empty.';            
            return result;
        }  
		
        system.debug('e008: ' + args.TaskID);

        if (args.PoDetails == null){
            result.CompletionCode = 'F';
            result.FailMsg = 'Provide at least one PO Detail Line.';            
            return result;
        }
        
        if (args.PoDetails.size() == 0){
            result.CompletionCode = 'F';
            result.FailMsg = 'Provide at least one PO Detail Line.';            
            return result;
        }
        system.debug('e009: ' + args.PoDetails);
        Integer currentLineNumber = 1;
        for (PODetail poDetail : args.PoDetails){
            if (poDetail.AccountCode.equals('') || poDetail.AccountCode.equals(null)){
                result.CompletionCode = 'F';
                result.FailMsg = 'Account Code cannot be empty (line ' + currentLineNumber + ').';          
                return result;
            }
            currentLineNumber++;
            system.debug('e0010: ' + poDetail.AccountCode);
        }
                        
        Date startDate = Date.today();
        Date endDate = Date.today();
        
        try{
            ASI_MFM_PO__c po = new ASI_MFM_PO__c();
                                
          //  List<ASI_MFM_Plan__c> plan = [SELECT Id, ASI_MFM_Fiscal_Year_look_up__r.name FROM ASI_MFM_Plan__c WHERE name = :args.PlanId];
              List<ASI_MFM_Plan__c> plan = [SELECT Id, ASI_MFM_Fiscal_year__c,ASI_MFM_Prefix__r.ASI_MFM_Fiscal_year__c FROM ASI_MFM_Plan__c WHERE (recordtype.developername = 'ASI_MFM_CN_Plan' OR recordtype.developername = 'ASI_MFM_CN_Plan_Read_Only') and name = :args.PlanId];                      
                system.debug('e0011: ' + plan[0].id);                    
            if (plan.size() == 0){
                result.CompletionCode = 'F';
                result.FailMsg = 'Invalid Plan ID.';            
                return result;
            }
            if (plan.size() > 0){
                if(plan[0].ASI_MFM_Prefix__r.ASI_MFM_Fiscal_year__c != null){ 
                    startDate = date.newinstance((2000+integer.valueof(plan[0].ASI_MFM_Prefix__r.ASI_MFM_Fiscal_year__c.substring(2,4))),7,1);
                    endDate = date.newinstance((2000+integer.valueof(plan[0].ASI_MFM_Prefix__r.ASI_MFM_Fiscal_year__c.substring(4,6))),6,30);
            	}
            }
                                    
            po.ASI_MFM_Plan__c = plan[0].id;
            po.ASI_MFM_PO_Type__c = 'eMarket';
            po.ASI_MFM_BudgetControlReqInd__c = false;
            
            RecordType cnPOReadOnlyrecordType = Global_RecordTypeCache.getRTRec('ASI_MFM_PO__cASI_MFM_CN_PO_Read_Only');//[SELECT Id FROM RecordType WHERE Name = 'CN PO Read-Only'];
            po.RecordTypeId = cnPOReadOnlyrecordType.Id;
            
            // Added by Alan Wong(Elufa) 20150428 Block user from creating duplicated PO
            if (args.TaskID != '00000000-0000-0000-0000-000000000000'){
                List<ASI_MFM_PO__c> existing_po = [SELECT Id, Name FROM ASI_MFM_PO__c WHERE ASI_MFM_Task_ID__c = :args.TaskID AND RecordTypeId =:cnPOReadOnlyrecordType.Id];
                system.debug('f001: SELECT Id, Name FROM ASI_MFM_PO__c WHERE ASI_MFM_Task_ID__c = '+ args.TaskID + ' AND RecordTypeId = ' + cnPOReadOnlyrecordType.Id);
                system.debug('f003: ' + existing_po);
                if (!existing_po.isEmpty()){
                    result.CompletionCode = 'F';
                    result.FailMsg = 'PO existed. PO ID: ' + existing_po[0].Name;         
                    return result;
                }    
            }
            po.ASI_MFM_Task_ID__c = args.TaskID;
            //args.PrDept += '%';
            
            if (args.prDept.equals('22') ){
                args.prDept = '22%';
            }else if (args.prDept.equals('25') ){
                args.prDept = '25%';
            }
            
            List<ASI_MFM_Prefix__c> prefix = [SELECT Id FROM ASI_MFM_Prefix__c WHERE recordtype.developername = 'ASI_MFM_CN_Prefix' and ASI_MFM_Module__c = 'PO' and Name like :args.PrDept and ASI_MFM_Fiscal_year__c = :plan[0].ASI_MFM_Fiscal_year__c limit 1];
            //20160503 Ben @ Elufa
            if(prefix.size() > 0){
            	po.ASI_MFM_Prefix__c = prefix[0].Id;
            }else{
                result.CompletionCode = 'F';
                result.FailMsg = 'Prefix can not be found';
                return result;
            }
            //20160503 End
            
            system.debug('d002: prefix id: ' + po.ASI_MFM_Prefix__c + 'prDept: ' + args.PrDept);
            system.debug('d003: soql- SELECT Id FROM ASI_MFM_Prefix__c WHERE Name like '+args.PrDept+' and ASI_MFM_Fiscal_year__c = ' + plan[0].ASI_MFM_Fiscal_year__c + ' limit 1');
            List<ASI_MFM_BU__c> bu = [SELECT Id, Name FROM ASI_MFM_BU__c WHERE ASI_MFM_CN_Country__c = 'CN' and ASI_MFM_BU_Code__c = :args.Bu];
            if (bu.size() == 0){
                result.CompletionCode = 'F';
                result.FailMsg = 'Invalid BU.';         
                return result;
            }               
            po.ASI_MFM_BU_Code__c = bu[0].Id;                                                               
            po.ASI_MFM_CN_BU_Picklist__c = bu[0].Name;
            
            List<User> user = [SELECT Id FROM User WHERE CompanyName = 'Pernod Ricard China' and ASI_MFM_CN_Staff_No__c = :args.ResponsibleBy];
            if (user.size() == 0){
                result.CompletionCode = 'F';
                result.FailMsg = 'Invalid Responsible By.';         
                return result;
            }
            po.ASI_MFM_Budget_Owner__c = user[0].Id;    
            po.OwnerID = user[0].Id;    
            
            List<ASI_MFM_Event_PP__c> eventPP = [SELECT Id FROM ASI_MFM_Event_PP__c WHERE id = :args.EventId];
            if (args.PrDept == '25' && eventPP.size() == 0){
                /*result.CompletionCode = 'F';
                result.FailMsg = 'Invalid Event ID.';           
                return result;*/
            }else if (eventPP.size() > 0 ){
                po.ASI_MFM_Event_ID__c = eventPP[0].Id;
            }
            
            List<Account> supplier = [SELECT Id FROM Account WHERE recordtype.developername = 'ASI_MFM_CN_Supplier' and ASI_MFM_Customer_Supplier_Number__c = :args.SupplierNo];
            if (supplier.size() == 0){
                result.CompletionCode = 'F';
                result.FailMsg = 'Invalid Supplier No.';            
                return result;
            }
            po.ASI_MFM_Supplier_Name__c = supplier[0].Id;
            
            //20160427 Ben @ Elufa
            
            if(args.eMarketBuyerEmail != NULL && args.eMarketBuyerEmail != ''){
                List<User> user2 = new List<User>([SELECT Id FROM User WHERE email = :args.eMarketBuyerEmail AND isActive = TRUE]);
                if(user2.size() > 0){
                    po.ASI_MFM_eMarket_Buyer__c = user2[0].id;
                }
            }
            //20160427 End
            
            po.ASI_MFM_Remarks__c = args.PrNo;
            po.ASI_MFM_CN_VAT_Savings__c = args.Vat;
            po.ASI_MFM_CN_Deem_Sales_Applies__c = args.DeemSalesApplies;
            po.ASI_MFM_Status__c = 'Final';
            // Added by Michael Yip (Introv) 12Sep2014 for copy final date to G\L Date
            po.ASI_MFM_PO_Final_Date__c = date.today();
            po.ASI_MFM_GL_Date__c = date.today();
            po.ASI_MFM_PO_Start_Date__c = startDate;
            po.ASI_MFM_PO_End_Date__c = endDate;
            system.debug('PO Header: ' + po);
            System.debug('Task ID: ' + args.TaskID);
            insert po;
            
            ASI_MFM_PO__c createdPO = [SELECT Name FROM ASI_MFM_PO__c WHERE Id = :po.Id];
            result.PoId = createdPO.Name;
            System.debug(args.PlanId);
            System.debug(args.PrDept);
            System.debug(args.BudgetControlReqInd);
            System.debug(args.Bu);
            System.debug(args.SubBrand);
            System.debug(args.ResponsibleBy);
            System.debug(args.EventId);
            System.debug(args.SupplierNo);
            System.debug(args.PrNo);
            System.debug(args.Vat);
            System.debug(args.DeemSalesApplies);
            System.debug(args.PoDetails);
            System.debug(args.TaskID);
            
            //Added by William Yang 20140806 to assign PO Line Item record type
            RecordType cnPOLineItemRecordType = Global_RecordTypeCache.getRTRec('ASI_MFM_PO_Line_Item__cASI_MFM_CN_PO_Line_Item');//[SELECT Id FROM RecordType WHERE Name = 'CN PO Line Item']; 
            //End
            
            //Edited by Michael Yip (Introv) 21Aug2014 for bulk insert po line item reducing soql
            List<ASI_MFM_PO_Line_Item__c> LPOLine = new List<ASI_MFM_PO_Line_Item__c>();
            Set<string> SSubBrandID = new Set<String>();
            Set<string> SAccodeID = new Set<String>();
            for (PODetail poDetail : args.PoDetails){
                SSubBrandID.add(args.SubBrand);
                SAccodeID.add(poDetail.AccountCode);
            }
            List<ASI_MFM_Sub_brand__c> LsubBrand = [SELECT Id, ASI_MFM_Sub_brand_Code__c FROM ASI_MFM_Sub_brand__c 
                    WHERE ASI_MFM_Sub_brand_Code__c IN :SSubBrandID 
                    and recordtype.developername = 'ASI_FOC_CN_Sub_brand'
                    and ASI_MFM_Active_for_MFM__c = true ];
            //poLineItem.ASI_MFM_Sub_brand_Code__c = subBrand.Id; 
                
            RecordType cnACRecordType = Global_RecordTypeCache.getRTRec('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code');//[SELECT Id FROM RecordType WHERE Name = 'CN A/C Code'];                         
                
            List<ASI_MFM_A_C_Code__c> LacCode = [SELECT Id, name FROM ASI_MFM_A_C_Code__c 
                    WHERE Name IN :SAccodeID AND RecordTypeId = :cnACRecordType.Id];
            
            for (PODetail poDetail : args.PoDetails){
                ASI_MFM_PO_Line_Item__c poLineItem = new ASI_MFM_PO_Line_Item__c();
                System.debug(PODetail);
                System.debug(PODetail.Amount);
                System.debug(PODetail.AccountCode);
                System.debug(PODetail.SkuCode);
                System.debug(PODetail.Description);
                System.debug(PODetail.Quantity);
                System.debug(PODetail.UnitPrice);
                
                //Added by William Yang 20140806 to assign PO Line Item record type
                poLineItem.RecordTypeId = cnPOLineItemRecordType.id;
                //End
                
                poLineItem.ASI_MFM_PO__c = po.Id;
                
                //modeify by Eric Tsang 20150108 to change amount round up to 2 decimal places
                poLineItem.ASI_MFM_Amount__c = Decimal.valueof(poDetail.Amount).setScale(2, RoundingMode.HALF_UP);
                System.debug(poDetail.Quantity);                
                if (poDetail.SkuCode != null)
                    poLineItem.ASI_MFM_List_Item_Description__c = PODetail.Description + '\nSku Code : ' + poDetail.SkuCode;
                if (poDetail.Quantity != null)
                    poLineItem.ASI_MFM_Quantity__c = poDetail.Quantity;
                if (poDetail.UnitPrice != null)
                    poLineItem.ASI_MFM_Unit_Price__c = poDetail.UnitPrice;
                System.debug(poDetail.UnitPrice); 
                /*System.debug([SELECT Id FROM ASI_MFM_Sub_brand__c 
                    WHERE ASI_MFM_Sub_brand_Code__c = :args.SubBrand 
                    and recordtype.developername = 'ASI_FOC_CN_Sub_brand'
                    and ASI_MFM_Active_for_MFM__c = true limit 1]);*/
                /*ASI_MFM_Sub_brand__c subBrand = [SELECT Id FROM ASI_MFM_Sub_brand__c 
                    WHERE ASI_MFM_Sub_brand_Code__c = :args.SubBrand 
                    and recordtype.developername = 'ASI_FOC_CN_Sub_brand'
                    and ASI_MFM_Active_for_MFM__c = true limit 1];*/
                for(ASI_MFM_Sub_brand__c subBrand : LsubBrand){
                    if(subBrand.ASI_MFM_Sub_brand_Code__c == args.SubBrand )
                        poLineItem.ASI_MFM_Sub_brand_Code__c = subBrand.Id; 
                }
                
                /*RecordType cnACRecordType = Global_RecordTypeCache.getRTRec('ASI_MFM_A_C_Code__cASI_MFM_CN_A_C_Code');//[SELECT Id FROM RecordType WHERE Name = 'CN A/C Code'];                         
                
                ASI_MFM_A_C_Code__c acCode = [SELECT Id FROM ASI_MFM_A_C_Code__c 
                    WHERE Name = :poDetail.AccountCode AND RecordTypeId = :cnACRecordType.Id];*/
                for(ASI_MFM_A_C_Code__c acCode : LacCode){
                    if(acCode.Name == poDetail.AccountCode)
                        poLineItem.ASI_MFM_A_C_Code__c = acCode.Id;
                }
                
                LPOLine.add(poLineItem);
                //insert poLineItem; 
            }
            if(LPOLine != null && LPOLine.size()>0){
                insert LPOLine;
            }
        } catch (Exception e) {
                // Process exception here                   
                result.CompletionCode = 'F';
                System.debug(string.valueof(e));
                result.FailMsg = 'System runtime exception error (' + String.valueof(e) + ')';
                System.debug(result.FailMsg);
        }       
        
        return result;
    }
    
    Webservice static CompletePoResult CompletePoRequest(String poId){
        CompletePoResult result = new CompletePoResult();           
        result.CompletionCode = 'S';    
        
        if (poId.equals('') || poId.equals(null)){
            result.CompletionCode = 'F';
            result.FailMsg = 'PO Id cannot be empty.';          
            return result;
        }
        
        try{
            ASI_MFM_PO__c po = [SELECT id,ASI_MFM_Status__c FROM ASI_MFM_PO__c WHERE Name = :poId];
            
            po.ASI_MFM_Status__c = 'Complete';
            update po;
        } catch (Exception e) {
                // Process exception here                   
                result.CompletionCode = 'F';
                result.FailMsg = 'System runtime exception error (' + String.valueof(e) + ')';
        }   
        
        return result;
    }
    
}