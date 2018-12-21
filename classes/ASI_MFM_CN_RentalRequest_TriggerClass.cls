public without sharing class ASI_MFM_CN_RentalRequest_TriggerClass {
    
    Private Final Static Map<String, Schema.SObjectField> RentalRequestDetail_FIELD_MAP = Schema.SObjectType.ASI_MFM_Payment__c.fields.getMap();
    Private Final Static Map<String, Schema.SObjectField> FixApproval_FIELD_MAP = Schema.SObjectType.ASI_CRM_Fix_Approval_Route__c.fields.getMap();
    
    Public static void beforeUpdate(List<ASI_MFM_Rental_Request__c> triggerNew, Map<Id, ASI_MFM_Rental_Request__c> triggerOldMap){
        
        //Fix Approval
        Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixRoute = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
        Set<id> hasDetailSet = new Set<id>();
        Map<id, String> detailsMap = new Map<id, String>();
        
        String whereClause =  ' WHERE ASI_CRM_CN_Type__c Like \'%Rental%\' AND RecordType.DeveloperName Like \'ASI_CRM_CN_Fix_Approval_Route\'';
        
        for(ASI_CRM_Fix_Approval_Route__c fa : ASI_MFM_CN_StructureCostHelperClass.RetrieveFixApprovalInfo(FixApproval_FIELD_MAP, whereClause)){
            
            mapFixRoute.put(fa.ASI_CRM_CN_Type__c + fa.ASI_MFM_BU__c, fa);
        }
        
        //CIP Logic
        List<ASI_MFM_Rental_Request_Line__c> finalRentalContractList = new List<ASI_MFM_Rental_Request_Line__c>();
        Set<Id> finalRental = new Set<Id>();
        Map<Id, ASI_MFM_Payment__c> mapDummyPayment = new Map<id, ASI_MFM_Payment__c>();
        List<ASI_MFM_Payment__c> insertPaymentList = new List<ASI_MFM_Payment__c>();
		Set<Id> expensetypeIdSet = new Set<Id>();
        Map<id, ASI_MFM_PO__c> mapBudget = new Map<id, ASI_MFM_PO__c>();
        String fy = ASI_MFM_CN_StructureCostHelperClass.fyconversion(date.today());
        List<ASI_MFM_Prefix__c> prefixList = new List<ASI_MFM_Prefix__c>();
        Map<id, ASI_MFM_Rental_Request_Line__c> mapContract = new Map<Id, ASI_MFM_Rental_Request_Line__c>();
        Boolean hasError = False;
        
        for(ASI_MFM_Rental_Request__c obj : triggerNew){
            
            if(obj.ASI_MFM_Status__c == 'Draft'){
                
                setApproverToNull(obj);
                
                if(obj.recordTypeId == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Approval') && mapFixRoute.containsKey('Rental Approval Form' + obj.ASI_MFM_BU__c)){
                    
                    setFixApprover(obj, mapFixRoute.get('Rental Approval Form' + obj.ASI_MFM_BU__c));
                }else if(obj.recordTypeId == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Renovation_Form') && mapFixRoute.containsKey('Rental Renovation Form' + obj.ASI_MFM_BU__c)){
                    
                    setFixApprover(obj, mapFixRoute.get('Rental Renovation Form' + obj.ASI_MFM_BU__c));
                }else if(obj.recordTypeId == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Request') && mapFixRoute.containsKey('Rental Request Form' + obj.ASI_MFM_BU__c)){
                    
                    setFixApprover(obj, mapFixRoute.get('Rental Request Form' + obj.ASI_MFM_BU__c));
                }
            }
            
            //CIP Logic
            if(obj.ASI_MFM_Status__c == 'Final' && triggerOldMap.get(obj.id).ASI_MFM_Status__c == 'Submitted'){
                
                finalRental.add(obj.id);
            }        }
        
        if(finalRental.size() > 0){
            //get all dummy payment
            for(ASI_MFM_Payment__c dp : [SELECT id
                                         , ASI_MFM_Contract__r.ASI_MFM_Rental_Request__c
                                         , ASI_MFM_Contract__c
                                         FROM ASI_MFM_Payment__c 
                                         WHERE ASI_MFM_Dummy_Payment__c = True
                                         AND ASI_MFM_Contract__r.ASI_MFM_Rental_Request__c IN : triggerNew
                                         AND recordtype.developerName like '%ASI_MFM_CAP_CN_StructureCost_Payment%'
                                        ]){
                                            mapDummyPayment.put(dp.ASI_MFM_Contract__c, dp);
                                        }
        }
        
        for(ASI_MFM_Rental_Request_Line__c obj : [SELECT id, ASI_MFM_Rental_Request__c
                                                  , ASI_MFM_Detail__c
                                                  , ASI_MFM_ExpenseType__r.ASI_MFM_ExpenseType__c
                                                  , ASI_MFM_ExpenseType__c
                                                  , ASI_MFM_Rental_Request_Line__r.ASI_MFM_ExpenseType__r.ASI_MFM_Mandatory_Contract_Details__c
                                                  , ASI_MFM_ExpenseType__r.ASI_MFM_Mandatory_Contract_Details__c
                                                  , ASI_MFM_ExpenseType__r.ASI_MFM_BudgetControlLevel__c
                                                  , ASI_MFM_ExpenseType__r.ASI_MFM_BudgetControlMethod__c
                                                  , ASI_MFM_Apply_CIP_Logic__c
                                                  , ASI_MFM_Completion__c
                                                  , ASI_MFM_Rental_Request__r.ASI_MFM_BU__c
                                                  , ASI_MFM_Tax_Code__c
                                                  , ASI_MFM_Total_Amount__c
                                                  , ASI_MFM_Paid_Amount__c
                                                  , ASI_MFM_Department__c
                                                  , ASI_MFM_Expense_Type_Text__c
                                                  FROM ASI_MFM_Rental_Request_Line__c
                                                  WHERE ASI_MFM_Rental_Request__c IN : triggerNew
                                                 ]){
                                                     
                                                     if(obj.ASI_MFM_Rental_Request_Line__r.ASI_MFM_ExpenseType__r.ASI_MFM_Mandatory_Contract_Details__c || obj.ASI_MFM_ExpenseType__r.ASI_MFM_Mandatory_Contract_Details__c){
                                                         if(obj.ASI_MFM_Detail__c)
                                                             hasDetailSet.add(obj.ASI_MFM_Rental_Request__c);
                                                         
                                                         if(!obj.ASI_MFM_Detail__c){
                                                             
                                                             String et = '';
                                                             
                                                             if(detailsMap.containsKey(obj.ASI_MFM_Rental_Request__c)){
                                                                 et = detailsMap.get(obj.ASI_MFM_Rental_Request__c) + ', ' + obj.ASI_MFM_ExpenseType__r.ASI_MFM_ExpenseType__c;
                                                             }else{
                                                                 et = obj.ASI_MFM_ExpenseType__r.ASI_MFM_ExpenseType__c;
                                                             }
                                                             
                                                             detailsMap.put(obj.ASI_MFM_Rental_Request__c, et);
                                                         }
                                                     }
                                                     
                                                     //insert payment logic
                                                     if(!obj.ASI_MFM_Detail__c && obj.ASI_MFM_Apply_CIP_Logic__c && obj.ASI_MFM_Completion__c && !mapDummyPayment.containsKey(obj.id) && finalRental.contains(obj.ASI_MFM_Rental_Request__c)){
                                                         
                                                         mapContract.put(obj.id, obj);
                                                         expensetypeIdSet.add(obj.ASI_MFM_ExpenseType__c);
                                                         finalRentalContractList.add(obj);
                                                     }
                                                 }
        
        for(ASI_MFM_Rental_Request__c obj : triggerNew){
            
            if(obj.ASI_MFM_Status__c == 'Submitted' && triggerOldMap.get(obj.id).ASI_MFM_Status__c == 'Draft'){
                
                if(detailsMap.containsKey(obj.id) && !hasDetailSet.contains(obj.id)){
                    obj.addError('The following Expense must has detail breakdown :' + detailsMap.get(obj.id) + ', Please add back before submission.');
                }
            }
        }
        
        if(finalRentalContractList.size() > 0){
            
            Set<id> budgetId = new Set<Id>();
            Set<String> expensetypeSet = new Set<String>();
            Set<String> fySet = new Set<String>();
            
            List<ASI_MFM_Tax_Code__c> OTHtaxcode = new List<ASI_MFM_Tax_Code__c>([SELECT id FROM ASI_MFM_Tax_Code__c WHERE Name Like 'OTH' AND RecordType.DeveloperName Like 'ASI_MFM_CN_Tax_Code']);
            List<Account> dummySupplier = new List<Account>([Select id From Account Where recordtypeId = : Global_RecordTypeCache.getRtId('AccountASI_MFM_CN_Structure_Cost_Supplier') And ASI_MFM_Dummy_Supplier__c = True]);
            //20171227 Introv
            
            prefixList = [SELECT id FROM ASI_MFM_Prefix__c WHERE ASI_MFM_Module__c = 'Structure Cost Rental Payment' AND ASI_MFM_Fiscal_year__c = : fy AND recordtype.developerName like 'ASI_MFM_CN_Prefix'];
            
            for(ASI_MFM_PO__c budget : [SELECT id, ASI_MFM_Budget_Owner__c, ASI_MFM_CN_Amount_Ex__c, ASI_MFM_Expense_Type__c FROM ASI_MFM_PO__c WHERE ASI_MFM_PO_Fiscal_Year__c Like : fy AND ASI_MFM_Expense_Type__c IN : expensetypeIdSet AND ASI_MFM_Status__c != 'Archived' AND recordtype.developerName like '%ASI_MFM_CAP_CN_Structure_Cost%']){
                
                mapBudget.put(budget.ASI_MFM_Expense_Type__c, budget);
            }
            
            for(ASI_MFM_Rental_Request_Line__c obj : finalRentalContractList){
                
                if(mapBudget.containsKey(obj.ASI_MFM_ExpenseType__c) && prefixList.size() > 0 && dummySupplier.size() > 0){
                    
                    budgetId.add(mapBudget.get(obj.ASI_MFM_ExpenseType__c).id);
                    expensetypeSet.add(obj.ASI_MFM_Expense_Type_Text__c);
                    fySet.add(fy);
                    
                    insertPaymentList.add(new ASI_MFM_Payment__c(ASI_MFM_Expense_Type__c = obj.ASI_MFM_ExpenseType__c
                                                                 , ASI_MFM_BU__c = obj.ASI_MFM_Rental_Request__r.ASI_MFM_BU__c
                                                                 , ASI_MFM_Status__c = 'Final'
                                                                 , ASI_MFM_Tax_Code__c = obj.ASI_MFM_Tax_Code__c //OTHtaxcode.size() > 0 ? OTHtaxcode[0].id : Null
                                                                 , ASI_MFM_Dummy_Payment__c = True
                                                                 , ASI_MFM_Period_From__c = date.today()
                                                                 , ASI_MFM_Period_To__c = date.today()
                                                                 , ASI_MFM_Currency__c = 'RMB'
                                                                 , ASI_MFM_Contract__c = obj.id
                                                                 , ASI_MFM_Prefix__c = prefixList[0].id
                                                                 , ASI_MFM_Invoice_Amount__c = ((obj.ASI_MFM_Total_Amount__c != Null ? obj.ASI_MFM_Total_Amount__c : 0) - (obj.ASI_MFM_Paid_Amount__c != Null ? obj.ASI_MFM_Paid_Amount__c : 0))
                                                                 , ASI_MFM_PO__c = mapBudget.get(obj.ASI_MFM_ExpenseType__c).id
                                                                 , ASI_MFM_Supplier_Name__c = dummySupplier[0].id
                                                                 , recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Payment__cASI_MFM_CAP_CN_StructureCost_Payment')
                                                                 , ASI_MFM_Department_Text__c = obj.ASI_MFM_Department__c
                                                                 , ASI_MFM_Budget_Owner__c = mapBudget.get(obj.ASI_MFM_ExpenseType__c).ASI_MFM_Budget_Owner__c
                                                                ));
                }else{
                    
                    hasError = True;
                }
            }
            
            if(!hasError && insertPaymentList.size() > 0){
                
                Map<String, Map<String, Double>> mapAmount = ASI_MFM_CN_StructureCostHelperClass.calculateBudgetRemaining(null, budgetId, fySet, true, expensetypeSet);
                
                for(ASI_MFM_Payment__c obj : insertPaymentList){
                    
                    if(mapContract.containsKey(obj.ASI_MFM_Contract__c) && mapContract.get(obj.ASI_MFM_Contract__c).ASI_MFM_ExpenseType__r.ASI_MFM_BudgetControlMethod__c){
                        
                        if(mapAmount.containsKey(obj.ASI_MFM_PO__c)){
                            
                            if((mapBudget.get(obj.ASI_MFM_Expense_Type__c).ASI_MFM_CN_Amount_Ex__c - obj.ASI_MFM_Invoice_Amount__c - mapAmount.get(obj.ASI_MFM_PO__c).get('ActualAmount') - mapAmount.get(obj.ASI_MFM_PO__c).get('JDEAmount') < 0) && mapContract.get(obj.ASI_MFM_Contract__c).ASI_MFM_ExpenseType__r.ASI_MFM_BudgetControlLevel__c != 'By Expense Type'){
                                
                                hasError = true;
                            }else if((mapAmount.get(obj.ASI_MFM_PO__c).get('TotalExpenseRemaining') - obj.ASI_MFM_Invoice_Amount__c < 0) && mapContract.get(obj.ASI_MFM_Contract__c).ASI_MFM_ExpenseType__r.ASI_MFM_BudgetControlLevel__c == 'By Expense Type'){
                                
                                hasError = true;
                            }
                        }else if(mapBudget.get(obj.ASI_MFM_Expense_Type__c).ASI_MFM_CN_Amount_Ex__c - obj.ASI_MFM_Invoice_Amount__c < 0){
                            
                            hasError = true;
                        }
                    }
                }
                
                if(!hasError){
                    try{
                        Insert insertPaymentList;
                    }catch(dmlException dmle){
                        triggerNew[0].addError(dmle.getMessage());
                    }
                }
            }
        }
        
        if(hasError){
            triggerNew[0].addError('Budget/Prefix/Supplier cannot be found or over budget.');
        }
    }
    
    Public Static void beforeInsertMethod(List<ASI_MFM_Rental_Request__c> triggerNew){
        
        List<ASI_MFM_Rental_Request__c> rentalRequestList = new List<ASI_MFM_Rental_Request__c>();
        Set<id> citySetId = new Set<Id>();
        Map<Id, ASI_CRM_City__c> cityMap;
        
        //Fix Approval
        Map<String, ASI_CRM_Fix_Approval_Route__c> mapFixRoute = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
        
        String whereClause =  ' WHERE ASI_CRM_CN_Type__c Like \'%Rental%\' AND RecordType.DeveloperName Like \'ASI_CRM_CN_Fix_Approval_Route\'';
        
        for(ASI_CRM_Fix_Approval_Route__c fa : ASI_MFM_CN_StructureCostHelperClass.RetrieveFixApprovalInfo(FixApproval_FIELD_MAP, whereClause)){
            
            mapFixRoute.put(fa.ASI_CRM_CN_Type__c + fa.ASI_MFM_BU__c, fa);
        }
        
        for(ASI_MFM_Rental_Request__c obj : triggerNew){
            
             if(obj.ASI_MFM_Status__c == 'Draft'){
                
                setApproverToNull(obj);
                
                if(obj.recordTypeId == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Approval') && mapFixRoute.containsKey('Rental Approval Form' + obj.ASI_MFM_BU__c)){
                    
                    setFixApprover(obj, mapFixRoute.get('Rental Approval Form' + obj.ASI_MFM_BU__c));
                }else if(obj.recordTypeId == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Renovation_Form') && mapFixRoute.containsKey('Rental Renovation Form' + obj.ASI_MFM_BU__c)){
                    
                    setFixApprover(obj, mapFixRoute.get('Rental Renovation Form' + obj.ASI_MFM_BU__c));
                }else if(obj.recordTypeId == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Request') && mapFixRoute.containsKey('Rental Request Form' + obj.ASI_MFM_BU__c)){
                    
                    setFixApprover(obj, mapFixRoute.get('Rental Request Form' + obj.ASI_MFM_BU__c));
                }
            }
            
            if(obj.recordtypeid == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Request')){
                
                if(obj.ASI_MFM_City__c != Null){
                    citySetId.add(obj.ASI_MFM_City__c);
                    rentalRequestList.add(obj);
                }
            }
        }
        
        if(citySetId.size() > 0){
            
            cityMap = new Map<Id, ASI_CRM_City__c>([SELECT id, ASI_CRM_Stage_1_Preparation__c
                                                    , ASI_CRM_Stage_2_Internal_Process__c
                                                    , ASI_CRM_Stage_3_Execution__c
                                                    , ASI_CRM_Task_1__c
                                                    , ASI_CRM_Task_2__c
                                                    , ASI_CRM_Task_3__c
                                                    , ASI_MFM_Lead_Time__c
                                                    FROM ASI_CRM_City__c
                                                    WHERE id IN : citySetId
                                                   ]);
            
            for(ASI_MFM_Rental_Request__c obj : rentalRequestList){
                
                if(cityMap.containsKey(obj.ASI_MFM_City__c)){
                    obj.ASI_MFM_Stage_1_Preparation__c = cityMap.get(obj.ASI_MFM_City__c).ASI_CRM_Stage_1_Preparation__c;
                    obj.ASI_MFM_Stage_2_Internal_Process__c = cityMap.get(obj.ASI_MFM_City__c).ASI_CRM_Stage_2_Internal_Process__c;
                    obj.ASI_MFM_Stage_3_Execution__c = cityMap.get(obj.ASI_MFM_City__c).ASI_CRM_Stage_3_Execution__c;
                    obj.ASI_MFM_Task_1__c = cityMap.get(obj.ASI_MFM_City__c).ASI_CRM_Task_1__c;
                    obj.ASI_MFM_Task_2__c = cityMap.get(obj.ASI_MFM_City__c).ASI_CRM_Task_2__c;
                    obj.ASI_MFM_Task_3__c = cityMap.get(obj.ASI_MFM_City__c).ASI_CRM_Task_3__c;
                    obj.ASI_MFM_Lead_Time__c = cityMap.get(obj.ASI_MFM_City__c).ASI_MFM_Lead_Time__c;
                }
            }
        }
    }
    
    Public static void afterInsertMethod(List<ASI_MFM_Rental_Request__c> triggerNew){
        
        List<ASI_MFM_Rental_Request__c> rentalApprovalList = new List<ASI_MFM_Rental_Request__c>();
        
        for(ASI_MFM_Rental_Request__c obj : triggerNew){
            
            if(obj.recordtypeid == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Approval') || obj.recordtypeid == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Renovation_Form')){
                
                rentalApprovalList.add(obj);
            }
        }
        
        if(rentalApprovalList.size() > 0){
            List<ASI_MFM_Rental_Request_Line__c> insertDefaultLine = new List<ASI_MFM_Rental_Request_Line__c>();
            List<ASI_MFM_CN_RentalRequestSetting__c> customSetting = new List<ASI_MFM_CN_RentalRequestSetting__c>([SELECT ASI_MFM_Default_Renovation_Item_1__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_2__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_3__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_4__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_5__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_6__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_7__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_8__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_9__c
                                                                                                                   , ASI_MFM_Default_Renovation_Item_10__c
                                                                                                                   FROM ASI_MFM_CN_RentalRequestSetting__c
                                                                                                                   WHERE Name Like 'Default Renovation Item'
                                                                                                                  ]);
            List<String> defaultItems = new List<String>();
            
            if(customSetting.size() > 0){
                for(integer i = 1 ; i <= 10 ; i++){
                    
                    String a = 'ASI_MFM_Default_Renovation_Item_' + i + '__c';
                    
                    if(customSetting.get(0).get(a) != '' && customSetting.get(0).get(a) != Null)
                        defaultItems.add((String)customSetting.get(0).get(a));
                }
            }
            
            for(ASI_MFM_Rental_Request__c obj : rentalApprovalList){
                
                if(obj.recordtypeid == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Rental_Approval') || obj.recordtypeid == Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request__cASI_MFM_CN_Renovation_Form')){
                    
                    for(string defaultItem : defaultItems){
                        ASI_MFM_Rental_Request_Line__c tmp = new ASI_MFM_Rental_Request_Line__c(recordtypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Rental_Request_Line__cASI_MFM_CN_Rental_Item')
                                                                                                , ASI_MFM_Renovation_Item__c = defaultItem
                                                                                                , ASI_MFM_Rental_Request__c = obj.id
                                                                                               );
                        
                        insertDefaultLine.add(tmp);
                    }
                }
            }
            
            if(insertDefaultLine.size() > 0){
                try{
                    
                    Insert insertDefaultLine;
                }catch(dmlException dmle){
                    
                }
            }
        }
    }
    
    Public Static void setFixApprover(ASI_MFM_Rental_Request__c p, ASI_CRM_Fix_Approval_Route__c fixApproval){
        
        Integer i = 1;
        Integer j = 1;
        String fieldname = 'asi_mfm_sys_approver_' + i + '__c';
        String fixApprover = 'asi_crm_cn_approver_' + j + '__c';
        String fixApprovalLimits = 'asi_crm_cn_approval_limit_' + j + '__c';
        
        while(RentalRequestDetail_FIELD_MAP.containsKey(fieldname) && FixApproval_FIELD_MAP.containsKey(fixApprover)){
            
            if(p.get(fieldname) != Null){
                i++;
                fieldname = 'asi_mfm_sys_approver_' + i + '__c';
                continue;
            }
            
            if(fixApproval.get(fixApprover) == Null || fixApproval.get(fixApprover) == p.ownerId){//20180606 Introv skip approver if approver equal record owner
                j++;
                fixApprover = 'asi_crm_cn_approver_' + j + '__c';
                fixApprovalLimits = 'asi_crm_cn_approval_limit_' + j + '__c';
                continue;
            }
            
            if(fixApproval.get(fixApprover) != Null && ( fixApproval.get(fixApprovalLimits) == Null || p.ASI_MFM_Total_Contract_Amount__c >= Double.valueOf(fixApproval.get(fixApprovalLimits)))){
                p.put(fieldname, fixApproval.get(fixApprover));
            }else{
                p.put(fieldname, fixApproval.get(fixApprover));
                break;
            }
            
            i++;
            j++;
            
            fieldname = 'asi_mfm_sys_approver_' + i + '__c';
            fixApprover = 'asi_crm_cn_approver_' + j + '__c';
            fixApprovalLimits = 'asi_crm_cn_approval_limit_' + j + '__c';
        }
    }
    
    Private Static List<ASI_CRM_Fix_Approval_Route__c> RetrieveFixApprovalInfo() {
        
        String query = 'SELECT ' + genQueryField(FixApproval_FIELD_MAP) + ' FROM ASI_CRM_Fix_Approval_Route__c Where ASI_CRM_CN_Type__c Like \'Structure Cost Payment\' AND RecordType.DeveloperName Like \'ASI_CRM_CN_Fix_Approval_Route\'';
        
        List<ASI_CRM_Fix_Approval_Route__c> fixApprovalList = (List<ASI_CRM_Fix_Approval_Route__c>) Database.query(query);
        return fixApprovalList.size() > 0 ? fixApprovalList : new List<ASI_CRM_Fix_Approval_Route__c>();
    }
    
    private Static String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
        String queryField = '';
        for(String fields : fieldMap.keySet()) {
            queryField += fields + ',';
        }
        return queryField.subString(0, queryField.length() - 1);
    }
    
    public static void setApproverToNull(ASI_MFM_Rental_Request__c p){   
        p.ASI_MFM_Sys_Approver_1__c = null;
        p.ASI_MFM_Sys_Approver_2__c = null;
        p.ASI_MFM_Sys_Approver_3__c = null;
        p.ASI_MFM_Sys_Approver_4__c = null;
        p.ASI_MFM_Sys_Approver_5__c = null;
        p.ASI_MFM_Sys_Approver_6__c = null;
        p.ASI_MFM_Sys_Approver_7__c = null;
        p.ASI_MFM_Sys_Approver_8__c = null;
        p.ASI_MFM_Sys_Approver_9__c = null;
        p.ASI_MFM_Sys_Approver_10__c = null;
    }
}