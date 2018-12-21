/*********************************************************************************
 * Name:ASI_MFM_HK_PO_BalanceCheck
 * Description: 
 * Test Class: ASI_MFM_HK_PO_BalanceCheck_Test
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 30/05/2018       Wilken        			[WL 1.0] Add two more expense type for validating PO
 * 10/07/2018       Wilken        			[WL 2.0] Handle Concur user with "2" in the username (e.g. Philippe.guettat2@pernod-ricard.com)
*********************************************************************************/
@RestResource(UrlMapping='/ASI_MFM_HK_PO_BalanceCheck/*')
Global without Sharing class ASI_MFM_HK_PO_BalanceCheck{
    //{\"poId\":\"a9NM00000004EbC\"}
    @HttpPost
    Global Static void getPORecord(){
        
        List<UserRecordAccess> userAccess = new List<UserRecordAccess>();
        List<detailDataClass> returnErrorList = new List<detailDataClass>();
        Set<Id> noAccessRec = new Set<Id>();
        Map<Id, ASI_MFM_PO__c> po = new Map<Id, ASI_MFM_PO__c>();
        Map<Id, ASI_MFM_Plan__c> plan = new Map<Id, ASI_MFM_Plan__c>();
        Map<String, Decimal> mapPOAmountByName = new Map<String, Decimal>();
        Map<String, ASI_MFM_PO__c> mapPOByName = new Map<String, ASI_MFM_PO__c>();
        Map<String, ASI_MFM_Plan__c> mapPlanByName = new Map<String, ASI_MFM_Plan__c>();
        Map<String, Boolean> mapExpenseType = new Map<String, Boolean>{'capex - hardware (pre-approved)' => true
            , 'capex - software (pre-approved)' => true
            , 'po accrued' => false
            , 'marketing expense' => false
			/*[WL 1.0] BEGIN*/
			, 'marketing expense (gift)' => false
			, 'marketing expense (hospitality)' => false
			/*[WL 1.0] END*/			
            };// true = Plan, false = PO
        
        Boolean isAllsuccess = True;
        String currentUserId = '';
        //String poRecordType = '';
        Set<Id> poRecordType = new Set<Id>();
        restRequest req = restcontext.request;
        restResponse res = RestContext.response;
        
        system.debug('req.requestBody.toString()' + req.requestBody.toString());
        
        parametersClass parameterList = (parametersClass)system.JSON.deserialize(req.requestBody.toString(), parametersClass.class);
        res.addHeader('Content-Type','application/json');
        
        system.debug(parameterList);
        
        //res.statusCode = 200;

        Set<String> poNumberSet = new Set<String>();
        Set<String> planNumberSet = new Set<String>();
        
        replaceNullValue(parameterList, poNumberSet, planNumberSet, mapExpenseType);
        
        if(!parameterList.success){
            res.responseBody = blob.valueOf(JSON.serialize(parameterList));
            Return;
        }
        
        if(parameterList.currentUser != Null && parameterList.currentUser != ''){
			/*[WL 2.0] BEGIN*/
			if (parameterList.currentUser.contains('2'))
				parameterList.currentUser = parameterList.currentUser.replace('2','');
			
			system.debug('parameterList.currentUser: ' + parameterList.currentUser);
			/*[WL 2.0] END*/
            List<User> tmpU = new List<User>([SELECT id, username, ASI_MFM_Country__c FROM User WHERE username Like : parameterList.currentUser OR username Like : (parameterList.currentUser + '.asisb6conf')]);
            
            if(tmpU.size() > 0){
                currentUserId = tmpU[0].id;
                if(tmpU[0].ASI_MFM_Country__c == 'TR'){
                    
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_TR_PO'));
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_TR_PO_Read_Only'));
                }else{
                    
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO'));
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_HK_PO_Read_Only'));
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_RM_PO'));
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_RM_PO_Read_Only'));
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_CAP_Accrual_PO'));
                    poRecordType.add(Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_CAP_Accrual_PO_Read_Only'));
                }
                //poRecordType = tmpU[0].ASI_MFM_Country__c == 'TR' ? 'ASI_MFM_TR_PO%' : 'ASI_MFM_HK_PO%';
            }else{
                
                parameterList.success = False;
                parameterList.returnMsg = appendMsg(parameterList.returnMsg, 'User: ' + parameterList.currentUser + ' cannot be found.');//+= ' User: ' + parameterList.currentUser + ' cannot be found.';
                res.responseBody = blob.valueOf(JSON.serialize(parameterList));
                Return;
            }
        }
        
        List<ASI_TnE_ClaimDetail__c> existingTnE = new List<ASI_TnE_ClaimDetail__c>([SELECT id, ASI_TnE_HK_Payment_Amount__c 
                                                                                     , ASI_TnE_MFM_PO__c
                                                                                     FROM ASI_TnE_ClaimDetail__c 
                                                                                     WHERE ASI_TnE_ClaimHeader__r.ASI_TnE_KR_External_ID__c = : parameterList.concurReportId 
                                                                                     AND ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c = 'Final'
                                                                                     AND ASI_TnE_ClaimHeader__r.recordTypeId = : Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_HK_Claim_Header')
                                                                                     Order By ASI_TnE_ClaimHeader__r.CreatedDate DESC
                                                                                     Limit 1]);
        Map<Id, Decimal> previousTnEAmount = new Map<Id, Decimal>();
        
        if(existingTnE.size() > 0){
            for(ASI_TnE_ClaimDetail__c obj : existingTnE){
                
                Decimal amt = obj.ASI_TnE_HK_Payment_Amount__c != Null ? obj.ASI_TnE_HK_Payment_Amount__c : 0;
                
                if(previousTnEAmount.containsKey(obj.ASI_TnE_MFM_PO__c)){
                    amt += previousTnEAmount.get(obj.ASI_TnE_MFM_PO__c);
                }
                
                previousTnEAmount.put(obj.ASI_TnE_MFM_PO__c, amt);
            }
        }
        
        if(poNumberSet.size() > 0 || planNumberSet.size() > 0){
            
            Set<String> poSet = new Set<String>();
            Set<String> planSet = new Set<String>();
            
            if(poNumberSet.size() > 0)
                po = new Map<Id, ASI_MFM_PO__c>([SELECT ID
                                                 , Name
                                                 , ASI_MFM_PO_Balance__c
                                                 , ASI_MFM_Plan__r.Name
                                                 , ASI_MFM_Supplier_Name__r.Name
                                                 , ASI_MFM_Invoice_Amount_from_JDE__c
                                                 , ASI_MFM_Base_Currency_Amount__c
                                                 , ASI_MFM_T_E_Amount__c
                                                 , ASI_MFM_Status__c
                                                 , (SELECT id, ASI_MFM_Amount__c
                                                    , ASI_MFM_Customer_Name__c
                                                    , ASI_MFM_Currency__c
                                                    , ASI_MFM_Sub_brand_Code__r.Name
                                                    FROM PO_Line_Items__r)
                                                 FROM ASI_MFM_PO__c
                                                 WHERE Name IN : poNumberSet
                                                 AND RecordTypeId IN : poRecordType
                                                ]);
            system.debug('poNumberSet : '+poNumberSet); 
            if(planNumberSet.size() > 0)
                plan = new Map<Id, ASI_MFM_Plan__c>([SELECT ID
                                                     , Name
                                                     , ASI_MFM_Status__c
                                                     FROM ASI_MFM_Plan__c
                                                     WHERE Name IN : planNumberSet
                                                     AND RecordType.DeveloperName Like 'ASI_MFM_CAP_Plan%'
                                                     ]);
            system.debug('po.keySet() : '+po.keySet());
            if(po.keySet().size() > 0 || plan.keySet().size() > 0){
                
                Set<String> existingRecordNumber = new Set<String>();
                Set<String> notExistingRecordNumber = new Set<String>();
                Boolean hasMissing = False;
                
                if(po.keySet().size() > 0){
                    for(ASI_MFM_PO__c obj : po.values()){
                        poSet.add(obj.Name.toLowerCase());
                    }
                }
                
                if(plan.keySet().size() > 0){
                    for(ASI_MFM_PLan__c obj : plan.values()){
                        planSet.add(obj.Name.toLowerCase());
                    }
                }
                
                for(detailDataClass trans : parameterList.transactions){
                    if(trans.CAPEXPlanNumber != '' && trans.CAPEXPlanNumber != Null && !planSet.contains(trans.CAPEXPlanNumber.toLowerCase())){
                        
                        parameterList.success = False;
                        trans.success = False;
                        trans.returnMsg = 'Plan(' + trans.CAPEXPlanNumber + ') does not exist';
                        hasMissing = True;
                    }else if(trans.poNumber != '' && trans.poNumber != Null && !poSet.contains(trans.poNumber.toLowerCase())){
                        
                        parameterList.success = False;
                        trans.success = False;
                        trans.returnMsg = 'PO(' + trans.poNumber + ') does not exist';
                        hasMissing = True;
                    }
                    
                    parameterList.returnMsg = appendMsg(parameterList.returnMsg, trans.returnMsg);
                }
                
                /*if(po.keySet().size() > 0){
                    
                    for(String poNumber : poNumberSet){
                        
                        String tmpPONumber = poNumber;
                        
                        for(ASI_MFM_PO__c obj : po.values()){
                            if(existingRecordNumber.contains(poNumber.toLowerCase()) || poNumber.toLowerCase() == obj.Name.toLowerCase()){
                                existingRecordNumber.add(poNumber.toLowerCase());
                                tmpPONumber = '';
                                Break;
                            }
                        }
                        
                        if(tmpPONumber != '')
                            notExistingRecordNumber.add(tmpPONumber);
                    }
                }
                
                if(plan.keySet().size() > 0){
                    
                    for(String planNumber : planNumberSet){
                        
                        String tmpPlanNumber = planNumber;
                        
                        for(ASI_MFM_PLan__c obj : plan.values()){
                            if(existingRecordNumber.contains(planNumber.toLowerCase()) || planNumber.toLowerCase() == obj.Name.toLowerCase()){
                                existingRecordNumber.add(planNumber.toLowerCase());
                                tmpPlanNumber = '';
                                Break;
                            }
                        }
                        
                        if(tmpPlanNumber != '')
                            notExistingRecordNumber.add(tmpPlanNumber);
                    }
                }
                
                if(notExistingRecordNumber.size() > 0){
                    for(String RecNumber : notExistingRecordNumber){
                        
                        parameterList.success = False;
                        
                        for(detailDataClass trans : parameterList.transactions){
                            
                            if(trans.poNumber != '' && trans.poNumber != Null){
                                if(trans.poNumber.toLowerCase() == RecNumber.toLowerCase()){
                                    trans.success = False;
                                    trans.returnMsg = 'PO(' + RecNumber + ') does not exist';
                                }
                            }else if(trans.CAPEXPlanNumber != '' && trans.CAPEXPlanNumber != Null){
                                if(trans.CAPEXPlanNumber.toLowerCase() == RecNumber.toLowerCase()){
                                    trans.success = False;
                                    trans.returnMsg = 'Plan(' + RecNumber + ') does not exist';
                                }
                            }
                            
                            parameterList.returnMsg = appendMsg(parameterList.returnMsg, trans.returnMsg);//+= ' ' + trans.returnMsg;
                        }
                    }
                }*/
                    
                if(hasMissing){
                    res.responseBody = blob.valueOf(JSON.serialize(parameterList));
                    return;
                }
                
                Set<Id> allRecordId = new Set<Id>();
                allRecordId.addAll(po.keySet());
                allRecordId.addAll(plan.keySet());
                
                for(UserRecordAccess ura : [SELECT HasReadAccess, RecordId FROM UserRecordAccess WHERE RecordId IN : allRecordId AND UserId = : currentUserId]){
                    if(!ura.HasReadAccess)
                        noAccessRec.add(ura.RecordId);
                }
                
                if(noAccessRec.size() > 0){
                    
                    parameterList.success = False;

                    for(Id resId : noAccessRec){
                        for(detailDataClass trans : parameterList.transactions){
                            if(po.containsKey(resId) && trans.poNumber.toLowerCase() == po.get(resId).Name.toLowerCase()){
                                
                                trans.success = False;
                                trans.returnMsg = po.get(resId).Name + ': no access right';
                                
                            }else if(plan.containsKey(resId) && trans.CAPEXPlanNumber.toLowerCase() == plan.get(resId).Name.toLowerCase()){
                                
                                trans.success = False;
                                trans.returnMsg = plan.get(resId).Name + ': no access right';
                                
                            }
                            parameterList.returnMsg = appendMsg(parameterList.returnMsg, trans.returnMsg);//+= ' ' + trans.returnMsg;
                        }
                    }
                    
                    res.responseBody = blob.valueOf(JSON.serialize(parameterList));
                    return;
                }
                
                for(ASI_MFM_PO__c obj : po.values()){
                    
                    mapPOByName.put(obj.Name.toLowerCase(), obj);
                    mapPOAmountByName.put(obj.Name.toLowerCase(), obj.ASI_MFM_PO_Balance__c + ( previousTnEAmount.containsKey(obj.id) ? previousTnEAmount.get(obj.id) : 0 ));
                }
                
                for(ASI_MFM_Plan__c obj : plan.values()){
                    mapPlanByName.put(obj.Name.toLowerCase(), obj);
                }
                
                for(detailDataClass trans : parameterList.transactions){
                    
                    if(trans.poNumber != Null && trans.poNumber != '' && mapPOAmountByName.containsKey(trans.poNumber.toLowerCase())){
                        
                        if(mapPOByName.get(trans.poNumber.toLowerCase()).ASI_MFM_Status__c == 'Draft'
                           || mapPOByName.get(trans.poNumber.toLowerCase()).ASI_MFM_Status__c == 'Submitted'
                           || mapPOByName.get(trans.poNumber.toLowerCase()).ASI_MFM_Status__c == 'Voided'
                          ){
                              
                              trans.success = False;
                              trans.returnMsg = 'Not allowed to create expense with ' + mapPOByName.get(trans.poNumber.toLowerCase()).ASI_MFM_Status__c + ' PO(' + trans.poNumber + ')';
                              parameterList.returnMsg = appendMsg(parameterList.returnMsg, trans.returnMsg);//+= ' ' + trans.returnMsg;
                              continue;
                          }
                        
                        Decimal expenseAmount = (trans.expenseAmount * (trans.fxRate != Null ? trans.fxRate : 1)).setScale(2); // 20180313 Introv Added setScale(2);
                        
                        if(mapPOAmountByName.get(trans.poNumber.toLowerCase()) - expenseAmount < 0){
                            
                            parameterList.success = False;

                            trans.returnMsg = 'PO(' + trans.poNumber + ') Balance: ' + mapPOAmountByName.get(trans.poNumber.toLowerCase()) + '- Insufficient'; //expenseAmount).setScale(2);//, PO remaining: ' + mapPOAmountByName.get(trans.poNumber.toLowerCase()).setScale(2) + ', transaction amount: ' + expenseAmount.setScale(2);
                            trans.success = False;
                        }else{
                            trans.returnMsg = ''; //'Success';//, PO remaining: ' + mapPOAmountByName.get(trans.poNumber.toLowerCase()).setScale(2) + ', transaction amount: ' + expenseAmount.setScale(2);
                            trans.success = True;
                        }
                        
                        //trans.returnMsg = trans.returnMsg + ', after deduction: ' + (mapPOAmountByName.get(trans.poNumber.toLowerCase()) - expenseAmount).setScale(2);
                        parameterList.returnMsg = appendMsg(parameterList.returnMsg, trans.returnMsg);//+= ' ' + trans.returnMsg;
                        
                        mapPOAmountByName.put(trans.poNumber.toLowerCase(), mapPOAmountByName.get(trans.poNumber.toLowerCase()) - expenseAmount);
                        
                    }else if(trans.CAPEXPlanNumber != Null && trans.CAPEXPlanNumber != '' && mapPlanByName.containsKey(trans.CAPEXPlanNumber.toLowerCase())){
                        
                        if(mapPlanByName.get(trans.CAPEXPlanNumber.toLowerCase()).ASI_MFM_Status__c == 'Draft'
                           || mapPlanByName.get(trans.CAPEXPlanNumber.toLowerCase()).ASI_MFM_Status__c == 'Submitted'
                          ){

                              parameterList.success = False;
                              trans.success = False;
                              trans.returnMsg = 'Not allowed to create expense with ' + mapPlanByName.get(trans.CAPEXPlanNumber.toLowerCase()).ASI_MFM_Status__c + ' Plan(' + trans.CAPEXPlanNumber + ')';
                              continue;
                          }
                    }
                }
            }else{
                
                for(detailDataClass obj : parameterList.transactions){
                    
                    obj.success = False;
                    
                    if(obj.poNumber != '' && obj.poNumber != Null)
                        obj.returnMsg = 'PO(' + obj.poNumber + ') does not exist';
                    else if(obj.CAPEXPlanNumber != '' && obj.CAPEXPlanNumber != Null)
                        obj.returnMsg = 'Plan(' + obj.CAPEXPlanNumber + ') does not exist';
                    
                    parameterList.returnMsg = appendMsg(parameterList.returnMsg, obj.returnMsg);//+= ' ' + obj.returnMsg;
                }

                parameterList.success = False;
                res.responseBody = blob.valueOf(JSON.serialize(parameterList));
                Return;
            }
        }
        
        res.responseBody = blob.valueOf(JSON.serialize(parameterList));
        Return;
    }
    
    Private Static String appendMsg(String currentMsg, String appendMsg){
        
        String msg = currentMsg;
        
        if(appendMsg != '')
            msg = ' ' + currentMsg + appendMsg + '\r\n';
        
        Return msg;
    }
    
    Private Static Void replaceNullValue(parametersClass parameterList, Set<String> poNumberSet, Set<String> planNumberSet, Map<String, Boolean> mapExpenseType){
        
        parameterList.concurReportId = parameterList.concurReportId != Null ? parameterList.concurReportId : '';
        parameterList.currentUser = parameterList.currentUser != Null ? parameterList.currentUser : '';
        parameterList.success = parameterList.success != Null ? parameterList.success : True;
        parameterList.returnMsg = parameterList.returnMsg != Null ? parameterList.returnMsg : '';
        parameterList.transactions = parameterList.transactions != Null ? parameterList.transactions : new List<detailDataClass>();
        
        for(detailDataClass obj : parameterList.transactions){
            
            obj.returnMsg = obj.returnMsg != Null ? obj.returnMsg : '';
            obj.concurReportId = obj.concurReportId != Null ? obj.concurReportId : '';
            obj.poNumber = obj.poNumber != Null ? obj.poNumber : '';
            obj.CAPEXPlanNumber = obj.CAPEXPlanNumber != Null ? obj.CAPEXPlanNumber : '';
            obj.concurLineId = obj.concurLineId != Null ? obj.concurLineId : '';
            obj.fxRate = obj.fxRate != Null ? obj.fxRate : 0;
            obj.expenseAmount = obj.expenseAmount != Null ? obj.expenseAmount : 1;
            obj.success = obj.success != Null ? obj.success : True;
            obj.expenseType = obj.expenseType != Null ? obj.expenseType : '';
            obj.RecordNumber = obj.RecordNumber != Null ? obj.RecordNumber : '';
            
            if(mapExpenseType.containsKey(obj.expenseType.toLowerCase()) && mapExpenseType.get(obj.expenseType.toLowerCase()) && obj.expenseType != ''){
                
                obj.CAPEXPlanNumber = obj.RecordNumber;
            }else if(mapExpenseType.containsKey(obj.expenseType.toLowerCase()) && !mapExpenseType.get(obj.expenseType.toLowerCase()) && obj.expenseType != ''){
                
                obj.poNumber = obj.RecordNumber;
            }
            
            if(obj.poNumber != '' && obj.poNumber != Null)
                poNumberSet.add(obj.poNumber);
            if(obj.CAPEXPlanNumber != Null && obj.CAPEXPlanNumber != '')
                planNumberSet.add(obj.CAPEXPlanNumber);
            
            if(obj.expenseType == '' || obj.recordNumber == ''){
                parameterList.success = False;
                obj.success = False;
                obj.returnMsg = 'Expense Type and Plan/PO Number cannot be null';
                parameterList.returnMsg += ' Expense Type and Plan/PO Number cannot be null';
            }
        }
    }
    
    public class parametersClass{
        
        Public String concurReportId;
        Public String currentUser;
        Public Boolean success; // allOrNone;
        Public String returnMsg;
        Public List<detailDataClass> transactions = new List<detailDataClass>();
    }
    
    Public Class detailDataClass{
        
        Public String returnMsg;
        Public String concurReportId;
        Public String poNumber;
        Public String CAPEXPlanNumber;
        Public String concurLineId;
        Public Decimal fxRate;
        Public Decimal expenseAmount;
        Public Boolean success;
        Public String expenseType;
        Public String RecordNumber;
    }
}