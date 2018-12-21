/* Filename:    ASI_CRM_CN_Heavy_PR_TriggerCls.cls
* Author:      Laputa
* Purpose:     CRM 4.2 CN Payment Request Trigger Class
*
*
* History
* -----------------------------------------------------------------------------
* 2017-05-29   Laputa      Created
*/

public without sharing class ASI_CRM_CN_Heavy_PR_TriggerCls {
    public static String className = 'ASI_CRM_CN_Heavy_PR_TriggerCls';
    
    public static void routineAfterInsert(list<ASI_TH_CRM_PaymentRequest__c> trigger_new) {
        if(!ASI_CRM_CN_Function.IsBypassTrigger(className)) {
            //creating payment request line item according to contract
            Set<id> SContractID = new Set<id>();
            Map<id,id> MContractIDPaymentRequest = new Map<id,id>();
            Set<id> SOutletID = new Set<id>();
            
            //insert an approval comment
            List<ASI_CRM_Approval_Comment__c> LNewPRComment_Insert = new List<ASI_CRM_Approval_Comment__c>();
            
            String PaymentId='';
            for(ASI_TH_CRM_PaymentRequest__c p : trigger_new){
                PaymentId = p.id;
                SContractID.add(p.ASI_TH_CRM_Contract__c);
                MContractIDPaymentRequest.put(p.ASI_TH_CRM_Contract__c,p.id);
                SOutletID.add(p.ASI_CRM_CN_OutletWS__c);
                
                if(Global_RecordTypeCache.getRt(p.recordTypeId).developerName.contains('ASI_CRM_CN_Payment_Request')){
                    LNewPRComment_Insert.add(new ASI_CRM_Approval_Comment__c(ASI_CRM_Payment_Request__c = p.id, recordtypeid = Global_RecordTypeCache.getRTId('ASI_CRM_Approval_Comment__cASI_CRM_CN_Payment_Request_Comment')));
                }
              
            }
            if(LNewPRComment_Insert !=null && LNewPRComment_Insert.size() > 0){
                insert LNewPRComment_Insert;
            }
            
                
                
            
            List<ASI_TH_CRM_PaymentRequestLineItem__c> LPaymentRequestItem = new List<ASI_TH_CRM_PaymentRequestLineItem__c>();
            
            //Other Payment swap name and chinese description when copy to other payment
            for(ASI_CRM_Contract_Cost__c c : [Select id, name, ASI_CRM_CN_Contract__c, ASI_CRM_CN_Chinese_Description__c, ASI_CRM_CN_Activity_Code__c, ASI_CRM_CN_Cost_Type__c, ASI_CRM_CN_Sequence__c 
                                              from ASI_CRM_Contract_Cost__c   where ASI_CRM_CN_Other_Cost_Payment_Request__c = true and ASI_CRM_CN_Contract__c IN :SContractID order by ASI_CRM_CN_Contract__c, ASI_CRM_CN_Sequence__c])
            {
                ASI_TH_CRM_PaymentRequestLineItem__c PaymentRequestLine = new ASI_TH_CRM_PaymentRequestLineItem__c(ASI_CRM_CN_Contract_Cost__c = c.id,
                                                                                                                   recordtypeid = Global_recordTypeCache.getRtId('ASI_TH_CRM_PaymentRequestLineItem__cASI_CRM_CN_Payment_Request_Detail_Other'),
                                                                                                                   ASI_CRM_CN_Expense_Type__c = c.ASI_CRM_CN_Chinese_Description__c,
                                                                                                                   ASI_TH_CRM_Payment_Request__c = MContractIDPaymentRequest.get(c.ASI_CRM_CN_Contract__c),
                                                                                                                   ASI_CRM_CN_Payment_Description__c = c.Name,
                                                                                                                   ASI_CRM_CN_Cost_Type__c = c.ASI_CRM_CN_Cost_Type__c,
                                                                                                                   ASI_CRM_CN_Sequence__c = c.ASI_CRM_CN_Sequence__c,
                                                                                                                   ASI_CRM_CN_AC_Code__c = c.ASI_CRM_CN_Activity_Code__c);
                LPaymentRequestItem.add(PaymentRequestLine); 
            }           
            
            
            if(LPaymentRequestItem.size()>0){
                insert LPaymentRequestItem;
            }
            
            
            Map<String,ASI_CRM_Module__c> ModuleMap = new Map<String,ASI_CRM_Module__c>();
            //Insert Module
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:[SELECT id,ASI_CRM_Module__c,ASI_CRM_CN_Activity_Code__c,ASI_CRM_Type__c,ASI_CRM_CN_Contract__c,ASI_CRM_Module__r.ASI_CRM_Line_Type__c,ASI_CRM_Volume_Base__c,ASI_CRM_Module__r.ASI_CRM_Unit__c,ASI_CRM_Module__r.ASI_CRM_Volume_Base__c,ASI_CRM_Module__r.ASI_CRM_Methodology__c 
                                                                    FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c  IN :SContractID and ASI_CRM_Module__c !=null ] )
            {
                if(!ModuleMap.containsKey(ContractLine.ASI_CRM_Module__c)){//ASI_CRM_CN_AC_Code__c
                    ASI_CRM_Module__c Module = new ASI_CRM_Module__c(ASI_CRM_Parent_Module__c=ContractLine.ASI_CRM_Module__c,
                                                                     ASI_CRM_CN_AC_Code__c=ContractLine.ASI_CRM_CN_Activity_Code__c!=null?ContractLine.ASI_CRM_CN_Activity_Code__c:null,
                                                                     ASI_CRM_Contract__c=ContractLine.ASI_CRM_CN_Contract__c,
                                                                     ASI_CRM_Line_Type__c=ContractLine.ASI_CRM_Type__c,
                                                                     ASI_CRM_Payment_Request__c=PaymentId,
                                                                     ASI_CRM_Volume_Base__c=ContractLine.ASI_CRM_Volume_Base__c,ASI_CRM_Methodology__c=ContractLine.ASI_CRM_Module__r.ASI_CRM_Methodology__c);
                    
                    if(ContractLine.ASI_CRM_Module__r.ASI_CRM_Unit__c!=null){
                        Module.ASI_CRM_Unit__c=ContractLine.ASI_CRM_Module__r.ASI_CRM_Unit__c;
                    }
                    ModuleMap.put(ContractLine.ASI_CRM_Module__c,Module);
                }
                
            }
            
            
            if(ModuleMap.size()>0){
                insert ModuleMap.values();
            }
            
        }
    }
    
        
    public static void routineBeforeUpdate(list<ASI_TH_CRM_PaymentRequest__c> trigger_new, map<id, ASI_TH_CRM_PaymentRequest__c> trigger_oldMap) {
        
        if(!ASI_CRM_CN_Function.IsBypassTrigger(className)) {
            
            Set<ID> payID = new Set<ID>();
            Map<String, String> mapRejectedComment = new Map<String, String>();
            
            for(ASI_TH_CRM_PaymentRequest__c obj : trigger_new){
                if(trigger_oldMap.get(obj.id).ASI_TH_CRM_Status__c == 'Submitted' && obj.ASI_TH_CRM_Status__c == 'Draft'){
                    payID.add(obj.id);
                }
            }
            
            if(payID.size() > 0){
                List<ProcessInstance> processIn = new List<ProcessInstance>([SELECT Id, TargetObjectId, Status, (SELECT Comments FROM Steps WHERE StepStatus = 'Rejected') FROM ProcessInstance where TargetObjectId IN : payID AND Status = 'Rejected' ORDER BY CompletedDate DESC]);
                if(processIn.size() > 0){
                    for(ProcessInstance obj : processIn){
                        for(ProcessInstanceStep obj2 : obj.Steps){
                            if(!mapRejectedComment.containsKey(obj.TargetObjectId)){
                                if(obj2.Comments != NULL && obj2.Comments != '')
                                    mapRejectedComment.put(obj.TargetObjectId, obj2.Comments);
                            }
                        }
                    }
                    for(ASI_TH_CRM_PaymentRequest__c obj : trigger_new){
                        if(mapRejectedComment.containsKey(obj.id) && obj.ASI_CRM_CN_Approval_Status__c == 'Draft' && trigger_oldMap.get(obj.id).ASI_CRM_CN_Approval_Status__c == 'Submitted'){
                            obj.ASI_CRM_CN_Return_Comments__c = ( (obj.ASI_CRM_Branch__c == 'returned') ? 'Returned-': 'Rejected-')  + mapRejectedComment.get(obj.id);
                            
                            obj.ASI_CRM_Reject_Return_Comments__c = (obj.ASI_CRM_Reject_Return_Comments__c == NULL || obj.ASI_CRM_Reject_Return_Comments__c == '') ? ( (obj.ASI_CRM_Branch__c == 'returned') ? 'Return Comment / ': 'Reject Comment / ') + UserInfo.getName() + ' / ' + Datetime.now().format('YYYY-MM-dd') + ':' + '\n' + mapRejectedComment.get(obj.id) :  ( (obj.ASI_CRM_Branch__c == 'returned') ? 'Return Comment / ': 'Reject Comment / ')  + UserInfo.getName() + ' / ' + Datetime.now().format('YYYY-MM-dd') + ':' + '\n' + mapRejectedComment.get(obj.id)+ '\n' + obj.ASI_CRM_Reject_Return_Comments__c;
                        }
                    }
                }
            }
            
            
            //  Assign Approver
            // find the manager from hierarchy if it is not included in dynamic route       
            Map<id, ASI_CRM_Dynamic_Approval_Route__c> MAppRoute = new Map<id, ASI_CRM_Dynamic_Approval_Route__c>();
            Map<string, ASI_CRM_Fix_Approval_Route__c> MAppRouteFix = new Map<string, ASI_CRM_Fix_Approval_Route__c>();
            Map<string, ASI_CRM_Fix_Approval_Route__c> MAppRouteFix2 = new Map<string, ASI_CRM_Fix_Approval_Route__c>();
            Map<id, ASI_CRM_Dynamic_Approval_Route__c> MAppLastPaymentRoute = new Map<id, ASI_CRM_Dynamic_Approval_Route__c>();
            Map<string, ASI_CRM_Fix_Approval_Route__c> MAppLastPaymentRouteFix = new Map<string, ASI_CRM_Fix_Approval_Route__c>();
            Map<string, ASI_CRM_Fix_Approval_Route__c> MAppLastPaymentRouteFix2 = new Map<string, ASI_CRM_Fix_Approval_Route__c>();
            Map<id, User> MUser = new Map<id, User>();
            
            // for checking IHBR flag
            Set<id> SPaymentID = new Set<id>();
            Set<id> SIHBR = new Set<id>();
            
            List<User> LUser = [Select id, ManagerID, ASI_CRM_Sales_Team__c from User Where CompanyName = 'Pernod Ricard China' ];               
            for(User u : LUser){
                MUser.put(u.id, u);
            }        
            
            // limit set approver when status is draft
            Boolean needSetApprover = false;    
            for(ASI_TH_CRM_PaymentRequest__c payment: trigger_new){
                if(payment.ASI_TH_CRM_Status__c == 'Draft')
                {
                    SPaymentID.add(payment.id);
                    needSetApprover = true;
                    break;
                }
            }
            if(needSetApprover){
                List<ASI_TH_CRM_PaymentRequest__c> LFlag = [Select id, ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Is_IHBR_Outlet__c, ASI_CRM_CN_Return_Flag__c 
                                                            from ASI_TH_CRM_PaymentRequest__c
                                                            where id IN: SPaymentID];
                
                for(ASI_TH_CRM_PaymentRequest__c c:LFlag ){                                             
                    if(c.ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Is_IHBR_Outlet__c == true){
                        SIHBR.add(c.id);
                    }
                }
               
                
                for(ASI_CRM_Dynamic_Approval_Route__c a : [Select id, ASI_CRM_Approval_Limit__c,  ASI_CRM_End_of_Dynamic_Route__c, ASI_CRM_Manager_ID__c, ASI_CRM_Type__c, ASI_CRM_User__c from ASI_CRM_Dynamic_Approval_Route__c  where ASI_CRM_Type__c = 'Payment' or ASI_CRM_Type__c = 'Last Payment']){
                    if(a.ASI_CRM_Type__c =='Payment')
                        MAppRoute.put(a.ASI_CRM_User__c, a);
                    if(a.ASI_CRM_Type__c =='Last Payment')
                        MAppLastPaymentRoute .put(a.ASI_CRM_User__c, a);
                }
               
                
                for(ASI_CRM_Fix_Approval_Route__c a : [Select Id,ASI_CRM_RVP__c,ASI_CRM_CN_Regional_BA__c,ASI_CRM_CN_Region_Area_Channel__c, ASI_CRM_CN_Entry_Limit__c,ASI_CRM_CN_Approver_1__c, ASI_CRM_CN_Approver_2__c, ASI_CRM_CN_Approver_3__c,ASI_CRM_CN_Approver_4__c, ASI_CRM_CN_Approver_5__c, ASI_CRM_CN_Approver_6__c,ASI_CRM_CN_Type__c,  ASI_CRM_CN_Approval_Limit_1__c, ASI_CRM_CN_Approval_Limit_2__c, ASI_CRM_CN_Approval_Limit_3__c, ASI_CRM_CN_Approval_Limit_4__c, ASI_CRM_CN_Approval_Limit_5__c, ASI_CRM_CN_Approval_Limit_6__c,ASI_CRM_Sales_Team__c  , ASI_CRM_Commercial_Team__c from ASI_CRM_Fix_Approval_Route__c where 
                                                       ASI_CRM_CN_Type__c = 'Heavy Contract On Payment' or ASI_CRM_CN_Type__c = 'Heavy Contract On Last Payment']){
                    
                    String commercialTeam = a.ASI_CRM_Commercial_Team__c != Null && a.ASI_CRM_Commercial_Team__c != '' ? a.ASI_CRM_Commercial_Team__c : '';
                    
                    if(a.ASI_CRM_CN_Type__c =='Heavy Contract On Payment') 
                        MAppRouteFix2.put(a.ASI_CRM_Sales_Team__c + commercialTeam, a); 
                    else if(a.ASI_CRM_CN_Type__c  =='Heavy Contract On Last Payment') 
                        MAppLastPaymentRouteFix2.put(a.ASI_CRM_Sales_Team__c + commercialTeam, a);
                    
                }
            }
            
            //  (Check first payment flag) start
            String[] contract_id=new String[trigger_new.size()];
            Integer counter=0;
            for(ASI_TH_CRM_PaymentRequest__c payment : trigger_new){
                if(payment.ASI_CRM_CN_Last_Payment__c==false && payment.ASI_TH_CRM_Status__c == 'Draft'){
                    setApproverToNull(payment);
                    setApprovers(payment, MAppRoute, MAppRouteFix, MAppRouteFix2, MUser);
                }
                if(payment.ASI_CRM_CN_Last_Payment__c==true && payment.ASI_TH_CRM_Status__c == 'Draft'){
                    setApproverToNull(payment);
                    setApprovers(payment, MAppLastPaymentRoute , MAppLastPaymentRouteFix, MAppLastPaymentRouteFix2, MUser);
                }
                
                if(counter<trigger_new.size()){
                    contract_id[counter++]=payment.ASI_TH_CRM_Contract__c ;}
                
            }
            
            ASI_CRM_CN_CustomSetting__c customSetting = ASI_CRM_CN_CustomSetting__c.getOrgDefaults();
            String lastYrPaymentCode = customSetting.ASI_CRM_CN_Last_Year_Payment_Code__c;
            List<ASI_TH_CRM_PaymentRequest__c > check_1st_payment_List = [Select id, Name,ASI_TH_CRM_Contract__c,ASI_TH_CRM_Status__c, ASI_CRM_CN_Return_Flag__c from ASI_TH_CRM_PaymentRequest__c where ASI_TH_CRM_Contract__c in :contract_id];
            for(ASI_TH_CRM_PaymentRequest__c newpayment : trigger_new){
                //check the payments in same contract
                Integer no_of_Final=0;
                for(ASI_TH_CRM_PaymentRequest__c paymentRequest_checker:check_1st_payment_List ){
                    if(paymentRequest_checker.ASI_TH_CRM_Contract__c==newpayment.ASI_TH_CRM_Contract__c){
                        //check any final status
                        if((paymentRequest_checker.ASI_TH_CRM_Status__c =='Final'||paymentRequest_checker.ASI_TH_CRM_Status__c =='Approved') && paymentRequest_checker.id!=newpayment.id){no_of_Final++;}
                    }
                }
                // see how many final status existed.  
                if(no_of_Final==0){
                    if(newpayment.ASI_TH_CRM_Status__c =='Final'||newpayment.ASI_TH_CRM_Status__c =='Approved'){
                        newpayment.ASI_CRM_CN_First_Payment__c=true;
                    }
                }
                
                if(newpayment.ASI_CRM_CN_Last_Year_Payment__c && !trigger_oldMap.get(newpayment.id).ASI_CRM_CN_Last_Year_Payment__c ){
                    newpayment.ASI_CRM_CN_Reference_Code__c = lastYrPaymentCode; 
                }
                else if(!newpayment.ASI_CRM_CN_Last_Year_Payment__c && trigger_oldMap.get(newpayment.id).ASI_CRM_CN_Last_Year_Payment__c ){
                    newpayment.ASI_CRM_CN_Reference_Code__c = ''; 
                }
                
            }
               
        }
    }
    
   
    public static void routineAfterUpdate(list<ASI_TH_CRM_PaymentRequest__c> trigger_new, map<id, ASI_TH_CRM_PaymentRequest__c> trigger_oldMap) {
        Set<Id> PaidContractIdSet = new Set<Id> ();
        
        Set<Id> idPaymentRequest = new Set<Id>();
        List<ASI_TH_CRM_Contract__c> cs = new List<ASI_TH_CRM_Contract__c>();
        if(!ASI_CRM_CN_Function.IsBypassTrigger(className)) {
            for(ASI_TH_CRM_PaymentRequest__c paymentrequest : trigger_new){
                if(paymentrequest.ASI_CRM_CN_Payment_Type__c != trigger_oldMap.get(paymentrequest.id).ASI_CRM_CN_Payment_Type__c){
                    idPaymentRequest.add(paymentrequest.id);
                }
                if((paymentrequest.ASI_TH_CRM_Status__c != trigger_oldMap.get(paymentrequest.id).ASI_TH_CRM_Status__c && trigger_oldMap.get(paymentrequest.id).ASI_TH_CRM_Status__c =='draft' && paymentrequest.ASI_CRM_CN_Last_Payment__c==true)||(paymentrequest.ASI_CRM_CN_Last_Payment__c != trigger_oldMap.get(paymentrequest.id).ASI_CRM_CN_Last_Payment__c && paymentrequest.ASI_CRM_CN_Last_Payment__c ==true && paymentrequest.ASI_TH_CRM_Status__c !='draft')){
                    ASI_TH_CRM_Contract__c c = new ASI_TH_CRM_Contract__c();
                    c.id = paymentrequest.ASI_TH_CRM_Contract__c;
                    c.ASI_CRM_Last_Payment_Submitted__c = true;
                    cs.add(c);
                }
                if((paymentrequest.ASI_TH_CRM_Status__c != trigger_oldMap.get(paymentrequest.id).ASI_TH_CRM_Status__c && paymentrequest.ASI_TH_CRM_Status__c =='draft' && paymentrequest.ASI_CRM_CN_Last_Payment__c==true)||(paymentrequest.ASI_CRM_CN_Last_Payment__c != trigger_oldMap.get(paymentrequest.id).ASI_CRM_CN_Last_Payment__c && paymentrequest.ASI_CRM_CN_Last_Payment__c == false )){
                    ASI_TH_CRM_Contract__c c = new ASI_TH_CRM_Contract__c();
                    c.id = paymentrequest.ASI_TH_CRM_Contract__c;
                    c.ASI_CRM_Last_Payment_Submitted__c = false;
                    cs.add(c);
                }
                
                
                if(paymentrequest.ASI_TH_CRM_Status__c =='Approved' && paymentrequest.ASI_TH_CRM_Status__c != trigger_oldMap.get(paymentrequest.id).ASI_TH_CRM_Status__c && paymentrequest.ASI_CRM_CN_Last_Payment__c ){
                    PaidContractIdSet.add(paymentrequest.ASI_TH_CRM_Contract__c);
                }
            }
            List<ASI_CRM_CN_PH_Payee_Line_Item__c> listPHLineItem = [SELECT ID FROM ASI_CRM_CN_PH_Payee_Line_Item__c WHERE ASI_CRM_CN_Payment_Request__c IN:idPaymentRequest];
            delete listPHLineItem;
            update cs;
        }
        
        
        
        
    }
    
    public static void routineBeforeDelete(list<ASI_TH_CRM_PaymentRequest__c> trigger_old){
        
        if(!ASI_CRM_CN_Function.IsBypassTrigger(className)) {
            for(ASI_TH_CRM_PaymentRequest__c objPR : trigger_old) {
                if(objPR.ASI_TH_CRM_Status__c != 'Draft'){
                    objPR.addError('Only Draft Payment Request can be deleted.');
                }
            }
        }        
    }
    /*
    public static void routineBeforeInsert(list<ASI_TH_CRM_PaymentRequest__c> trigger_new, map<id, ASI_TH_CRM_PaymentRequest__c> trigger_oldMap) {
        if(!ASI_CRM_CN_Function.IsBypassTrigger(className)) {
            String [] trigger_new_id=new String[trigger_new.size()];
            Integer i=0;
            ASI_CRM_CN_CustomSetting__c customSetting = ASI_CRM_CN_CustomSetting__c.getOrgDefaults();
            String lastYrPaymentCode = customSetting.ASI_CRM_CN_Last_Year_Payment_Code__c;
            for(ASI_TH_CRM_PaymentRequest__c paymentrequest : trigger_new){
                trigger_new_id[i++]=paymentrequest.ASI_TH_CRM_Contract__c;
                if(paymentrequest.ASI_CRM_CN_Last_Year_Payment__c){
                    paymentrequest.ASI_CRM_CN_Reference_Code__c = lastYrPaymentCode; 
                }
            }
            
            //  payment with same contract
            List<ASI_TH_CRM_PaymentRequest__c> Payment_list=[Select id,Name,ASI_TH_CRM_Contract__c,ASI_CRM_CN_Last_Payment__c, ASI_TH_CRM_Status__c, ASI_CRM_CN_Return_Flag__c From ASI_TH_CRM_PaymentRequest__c where ASI_TH_CRM_Contract__c IN :trigger_new_id And ASI_TH_CRM_Status__c !='Draft'];
            Map<id,String> Payment_Map=new Map<id,String>();
            
            for(ASI_TH_CRM_PaymentRequest__c paymentrequest : Payment_list){
                if(paymentrequest.ASI_CRM_CN_Last_Payment__c==true){
                    Payment_Map.put(paymentrequest.ASI_TH_CRM_Contract__c,paymentrequest.Name);
                }
            }
            
            String error_Msg = Label.ASI_CRM_CN_ErrorMsg_MakePayment;  
            
            Map <String, String> labelAPIName = new Map <String, String> ();
            
            Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.ASI_TH_CRM_PaymentRequest__c.fields.getMap();
            for (Schema.SObjectField field : fieldsMap.values()){
                labelAPIName.put( field.getDescribe().getName(),field.getDescribe().getLabel());
            }
            
            String payment_no = labelAPIName.get('Name');
            User prof = [select id, Name, Profile.name, Profile.id, UserRole.developername from User where Id = :UserInfo.getUserId() ];
            boolean isuserAdmin = prof.profile.name.contains('System Administrator');    
            for(ASI_TH_CRM_PaymentRequest__c paymentrequest : trigger_new){
                if(Payment_Map.containskey(paymentrequest.ASI_TH_CRM_Contract__c) && !isuserAdmin){
                    paymentrequest.addError(error_Msg+' '+payment_no+Payment_Map.get(paymentrequest.ASI_TH_CRM_Contract__c));
                }
            }
            
        }
    }
    */
    //IHBR    
    public static void setApprovers(ASI_TH_CRM_PaymentRequest__c p,Map<id, ASI_CRM_Dynamic_Approval_Route__c> MAppRoute, Map<string, ASI_CRM_Fix_Approval_Route__c> MAppRouteFix, Map<string, ASI_CRM_Fix_Approval_Route__c> MAppRouteFix2, Map<id, User> MUser){
        Integer approver_count = 0;
        
        List<ASI_TH_CRM_PaymentRequest__c> LPayment = [Select id, ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_Is_IHBR_Outlet__c, ASI_CRM_CN_Return_Flag__c, OwnerId from ASI_TH_CRM_PaymentRequest__c where id =:p.id];
        
        // set last payment payment request limit start
        decimal paymentrequest_limit=0;
        if(p.ASI_CRM_CN_Last_Payment__c==true){
            paymentrequest_limit= 0;
            List<ASI_TH_CRM_Contract__c> LCont = [Select id, ASI_CRM_CN_Total_Contract_Amount__c  from ASI_TH_CRM_Contract__c where id =:p.ASI_TH_CRM_Contract__c limit 1]; 
            if(LCont != null && LCont.size()==1){
                paymentrequest_limit= LCont[0].ASI_CRM_CN_Total_Contract_Amount__c==null?0:LCont[0].ASI_CRM_CN_Total_Contract_Amount__c;
            }
        }
        else{
            paymentrequest_limit=p.ASI_CRM_CN_Total_Payment__c;
        }
        System.debug(paymentrequest_limit);
        //set last payment payment request limit end
        
        
        //Dynamic route        
        boolean proceed = true;
        id currentUserid = p.ASI_CRM_CN_Owner_Manager_ID__c;
        ASI_CRM_Dynamic_Approval_Route__c currentApprover = null;
        User currentApproverU = null;
        
        while(proceed){
            if(currentUserid!=null && (MAppRoute.containsKey(currentUserid) || MUser.containsKey(currentUserid))){
                if(MAppRoute.get(currentUserid) != null){
                    currentApprover = MAppRoute.get(currentUserid);
                    currentUserid = currentApprover.ASI_CRM_Manager_ID__c;
                }
                else{
                    if(MUser.get(currentUserid) != null){
                        currentApproverU = MUser.get(currentUserid);
                        currentUserid = currentApproverU.ManagerID;
                    }
                }
                
                if(currentApprover != null && currentApproverU == null){                            
                    setApproverByCount(p, approver_count, currentApprover.ASI_CRM_User__c);
                }
                else if(currentApprover == null && currentApproverU != null){
                    setApproverByCount(p, approver_count, currentApproverU.id);
                }
                approver_count++;
                
                if(currentApprover != null){
                    if( currentApprover.ASI_CRM_End_of_Dynamic_Route__c || currentApprover.ASI_CRM_Approval_Limit__c >= paymentrequest_limit){
                        proceed = false;
                    }
                }
                
                currentApprover = null;
                currentApproverU = null;
            }
            else{
                proceed = false;
            }
        } 
        
        //Second fix route
        ASI_CRM_Fix_Approval_Route__c fixApprover2;
        for(ASI_TH_CRM_PaymentRequest__c c: LPayment ){
            if(MUser.containsKey(p.OwnerId) && MUser.get(p.OwnerId).ASI_CRM_Sales_Team__c != null){
                fixApprover2 = MAppRouteFix2.containsKey(MUser.get(p.OwnerId).ASI_CRM_Sales_Team__c + p.ASI_CRM_Commercial_Team__c) ? MAppRouteFix2.get(MUser.get(p.OwnerId).ASI_CRM_Sales_Team__c + p.ASI_CRM_Commercial_Team__c) : MAppRouteFix2.get(MUser.get(p.OwnerId).ASI_CRM_Sales_Team__c); 
            }
        }
        
         
        if(fixApprover2 != null && fixApprover2.ASI_CRM_CN_Regional_BA__c!=null){
            p.ASI_CRM_CN_Last_RBA_Approver__c=fixApprover2.ASI_CRM_CN_Regional_BA__c;
        }
        
        if(fixApprover2 != null && fixApprover2.ASI_CRM_CN_Entry_Limit__c < paymentrequest_limit){           
            //set Return Approvers
            Integer return_approver_count = 0;
            
            if(fixApprover2.ASI_CRM_CN_Approver_1__c != null){         
                setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_1__c);
                approver_count++;
                
                if(p.ASI_CRM_CN_Return_Flag__c){
                    setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_1__c);
                    return_approver_count++;
                }
            }

            
            if(p.ASI_CRM_RVP_Approval__c && fixApprover2.ASI_CRM_RVP__c!=NULL){
                Boolean FoundRVP=False;
                Boolean AllowPut=False;
                //Approver_2
                if(fixApprover2 .ASI_CRM_CN_Approver_2__c != null){
                    if(!FoundRVP){ //Have not found RVP
                        if(fixApprover2.ASI_CRM_RVP__c==fixApprover2.ASI_CRM_CN_Approver_2__c){
                            FoundRVP=true;
                        } 
                        AllowPut=true;
                    }else{
                        if(fixApprover2 .ASI_CRM_CN_Approval_Limit_1__c < p.ASI_CRM_CN_Total_Payment__c ){
                            AllowPut=true;
                        }
                    }
                }
                if(AllowPut){
                    setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_2__c);
                    approver_count++;
                    if(p.ASI_CRM_CN_Return_Flag__c){
                        setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_2__c);
                        return_approver_count++;
                    }
                }
                
                
                
                  
                    //Approver_3
                    AllowPut=False;
                    if(fixApprover2 .ASI_CRM_CN_Approver_3__c != null){
                        if(!FoundRVP){ //Have not found RVP
                            if(fixApprover2.ASI_CRM_RVP__c==fixApprover2.ASI_CRM_CN_Approver_3__c){
                                FoundRVP=true;
                            } 
                            AllowPut=true;
                        }else{
                            if(fixApprover2 .ASI_CRM_CN_Approval_Limit_2__c < p.ASI_CRM_CN_Total_Payment__c ){
                                AllowPut=true;
                            }
                        }
                    }                    
                    if(AllowPut){
                        setApproverByCount(p, approver_count, fixApprover2 .ASI_CRM_CN_Approver_3__c);
                        approver_count++;
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_3__c);
                            return_approver_count++;
                        }
                    }
                    
                    
                    
                     //Approver_4
                    AllowPut=False;
                    if(fixApprover2 .ASI_CRM_CN_Approver_4__c != null){
                        if(!FoundRVP){ //Have not found RVP
                            if(fixApprover2.ASI_CRM_RVP__c==fixApprover2.ASI_CRM_CN_Approver_4__c){
                                FoundRVP=true;
                            } 
                            AllowPut=true;
                        }else{
                            if(fixApprover2 .ASI_CRM_CN_Approval_Limit_3__c < p.ASI_CRM_CN_Total_Payment__c ){
                                AllowPut=true;
                            }
                        }
                    }
                    if(AllowPut){
                        setApproverByCount(p, approver_count, fixApprover2 .ASI_CRM_CN_Approver_4__c);
                        approver_count++;
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_4__c);
                            return_approver_count++;
                        }
                    }
                    
                    
                      //Approver_5
                    AllowPut=False;
                    if(fixApprover2 .ASI_CRM_CN_Approver_5__c != null){
                        if(!FoundRVP){ //Have not found RVP
                            if(fixApprover2.ASI_CRM_RVP__c==fixApprover2.ASI_CRM_CN_Approver_5__c){
                                FoundRVP=true;
                            } 
                            AllowPut=true;
                        }else{
                            if(fixApprover2 .ASI_CRM_CN_Approval_Limit_4__c < p.ASI_CRM_CN_Total_Payment__c ){
                                AllowPut=true;
                            }
                        }
                    }
                    if(AllowPut){
                        setApproverByCount(p, approver_count, fixApprover2 .ASI_CRM_CN_Approver_5__c);
                        approver_count++;
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_5__c);
                            return_approver_count++;
                        }
                    }
                    
                    //Approver_6
                    AllowPut=False;
                    if(fixApprover2 .ASI_CRM_CN_Approver_6__c != null){
                        if(!FoundRVP){ //Have not found RVP
                            if(fixApprover2.ASI_CRM_RVP__c==fixApprover2.ASI_CRM_CN_Approver_6__c){
                                FoundRVP=true;
                            } 
                            AllowPut=true;
                        }else{
                            if(fixApprover2 .ASI_CRM_CN_Approval_Limit_5__c < p.ASI_CRM_CN_Total_Payment__c ){
                                AllowPut=true;
                            }
                        }
                    }
                    
                    if(AllowPut){
                        setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_6__c);
                        approver_count++;
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_6__c);
                            return_approver_count++;
                        }
                    }//Ending*************
                    
                
                
            }else{
                if(fixApprover2.ASI_CRM_CN_Approval_Limit_1__c < p.ASI_CRM_CN_Total_Payment__c){
                    if(fixApprover2.ASI_CRM_CN_Approver_2__c!=null){
                        setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_2__c);
                        approver_count++;
                        
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_2__c);
                            return_approver_count++;
                        }
                    }
                }
                if(fixApprover2.ASI_CRM_CN_Approval_Limit_2__c < p.ASI_CRM_CN_Total_Payment__c){
                    if(fixApprover2.ASI_CRM_CN_Approver_3__c!=null){
                        setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_3__c);
                        approver_count++;
                        
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_3__c);
                            return_approver_count++;
                        }
                    }
                }
                if(fixApprover2.ASI_CRM_CN_Approval_Limit_3__c < p.ASI_CRM_CN_Total_Payment__c){
                    if(fixApprover2.ASI_CRM_CN_Approver_4__c!=null){
                        setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_4__c);
                        approver_count++;
                        
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_4__c);
                            return_approver_count++;
                        }
                    }
                }
                if(fixApprover2.ASI_CRM_CN_Approval_Limit_4__c < p.ASI_CRM_CN_Total_Payment__c){
                    if(fixApprover2.ASI_CRM_CN_Approver_5__c!=null){
                        setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_5__c);
                        approver_count++;
                        
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_5__c);
                            return_approver_count++;
                        }
                    }
                }
                if(fixApprover2.ASI_CRM_CN_Approval_Limit_5__c < p.ASI_CRM_CN_Total_Payment__c){
                    if(fixApprover2.ASI_CRM_CN_Approver_6__c!=null){
                        setApproverByCount(p, approver_count, fixApprover2.ASI_CRM_CN_Approver_6__c);
                        approver_count++;
                        
                        if(p.ASI_CRM_CN_Return_Flag__c){
                            setReturnApproverByCount(p, return_approver_count, fixApprover2.ASI_CRM_CN_Approver_6__c);
                            return_approver_count++;
                        }
                    }
                }     
            }
            
        }
    }
    
    public static void setApproverByCount(ASI_TH_CRM_PaymentRequest__c p, integer approver_count, Id userId){
        if(approver_count == 0)
            p.ASI_CRM_CN_Sys_Approver_1__c = userId;
        
        else if(approver_count == 1)
            p.ASI_CRM_CN_Sys_Approver_2__c = userId;
        
        else if(approver_count == 2)
            p.ASI_CRM_CN_Sys_Approver_3__c = userId;
        
        else if(approver_count == 3)
            p.ASI_CRM_CN_Sys_Approver_4__c = userId;
        
        else if(approver_count == 4)
            p.ASI_CRM_CN_Sys_Approver_5__c = userId;
        
        else if(approver_count == 5)
            p.ASI_CRM_CN_Sys_Approver_6__c = userId;
        
        else if(approver_count == 6)
            p.ASI_CRM_CN_Sys_Approver_7__c = userId;
        
        else if(approver_count == 7)
            p.ASI_CRM_CN_Sys_Approver_8__c = userId;
        
        else if(approver_count == 8)
            p.ASI_CRM_CN_Sys_Approver_9__c = userId;
        
        else if(approver_count == 9)
            p.ASI_CRM_CN_Sys_Approver_10__c = userId;
        
        else if(approver_count == 10)
            p.ASI_CRM_CN_Sys_Approver_11__c = userId;
        
    }
    
    public static void setReturnApproverByCount(ASI_TH_CRM_PaymentRequest__c p, integer approver_count, Id userId){
        if(approver_count == 0)
            p.ASI_CRM_CN_Return_Approver_1__c = userId;
        
        else if(approver_count == 1)
            p.ASI_CRM_CN_Return_Approver_2__c = userId;
        
        else if(approver_count == 2)
            p.ASI_CRM_CN_Return_Approver_3__c = userId;
        
        else if(approver_count == 3)
            p.ASI_CRM_CN_Return_Approver_4__c = userId;
        
        else if(approver_count == 4)
            p.ASI_CRM_CN_Return_Approver_5__c = userId;
        
        else if(approver_count == 5)
            p.ASI_CRM_CN_Return_Approver_6__c = userId;
        
        else if(approver_count == 6)
            p.ASI_CRM_CN_Return_Approver_7__c = userId;
        
        else if(approver_count == 7)
            p.ASI_CRM_CN_Return_Approver_8__c = userId;
        
        else if(approver_count == 8)
            p.ASI_CRM_CN_Return_Approver_9__c = userId;
        
        else if(approver_count == 9)
            p.ASI_CRM_CN_Return_Approver_10__c = userId;
        
        else if(approver_count == 10)
            p.ASI_CRM_CN_Return_Approver_11__c = userId;
    }
    
    public static void setApproverToNull(ASI_TH_CRM_PaymentRequest__c p){
        p.ASI_CRM_CN_Sys_Approver_1__c = null;
        p.ASI_CRM_CN_Sys_Approver_2__c = null;
        p.ASI_CRM_CN_Sys_Approver_3__c = null;
        p.ASI_CRM_CN_Sys_Approver_4__c = null;
        p.ASI_CRM_CN_Sys_Approver_5__c = null;
        p.ASI_CRM_CN_Sys_Approver_6__c = null;
        p.ASI_CRM_CN_Sys_Approver_7__c = null;
        p.ASI_CRM_CN_Sys_Approver_8__c = null;
        p.ASI_CRM_CN_Sys_Approver_9__c = null;
        p.ASI_CRM_CN_Sys_Approver_10__c = null;
        p.ASI_CRM_CN_Sys_Approver_11__c = null;       
        
        p.ASI_CRM_CN_Return_Approver_1__c = null;
        p.ASI_CRM_CN_Return_Approver_2__c = null;
        p.ASI_CRM_CN_Return_Approver_3__c = null;
        p.ASI_CRM_CN_Return_Approver_4__c = null;
        p.ASI_CRM_CN_Return_Approver_5__c = null;
        p.ASI_CRM_CN_Return_Approver_6__c = null;
        p.ASI_CRM_CN_Return_Approver_7__c = null;
        p.ASI_CRM_CN_Return_Approver_8__c = null;
        p.ASI_CRM_CN_Return_Approver_9__c = null;
        p.ASI_CRM_CN_Return_Approver_10__c = null;
        p.ASI_CRM_CN_Return_Approver_11__c = null;  
    }   
}