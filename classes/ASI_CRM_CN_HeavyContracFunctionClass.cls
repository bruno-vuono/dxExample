public class ASI_CRM_CN_HeavyContracFunctionClass {
    
    //Sending Email To Contract Owner
    public Static void SendingEmailToContractOwner(String originalId, String ContractId, String EmailTemplateName){
        try{
            ASI_TH_CRM_Contract__c ContractSelected = [select id,OwnerId from ASI_TH_CRM_Contract__c where id = : ContractId ];
            User ContractOwner = [Select id, Email from User Where id= :ContractSelected.OwnerId ];
            
            List <String> ToAddresses=  new List <String>();
            id  templateId = [select id, name from EmailTemplate where developername = : EmailTemplateName].id; 
            ToAddresses.add(ContractOwner.Email);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            email.setTargetObjectId(ContractSelected.ownerId);
            email.setToAddresses( ToAddresses ); 
            email.setWhatId(originalId);
            email.setSaveAsActivity(false);
            email.setBccSender(false);
            email.setUseSignature(false);
            email.setTemplateId(templateId);
            if(!Test.isRunningTest()){
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            
        }catch(dmlException e){
            ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyContracFunctionClass.SendingEmailToContractOwner <br/>  have Error  '+'Save Error : ' +e.getMessage() + '</br>','ASI_CRM_CN_HeavyContracFunctionClass','function failed! with contract Id: '+ContractId );
        }
    }




    
    public Static String ReplaceNumberInCustomer (string InputString){
        Integer StartPlace = InputString.indexOf('(');
        Integer EndPlace = InputString.indexOf(')');
        
        if(StartPlace>-1 && EndPlace>-1){
            String ReplaceString = InputString.substring(StartPlace,EndPlace+1);
            InputString = InputString.remove(ReplaceString);
        }
        
        return InputString;
    }
    
    
    
    
    
    
    
    //Local Group Contract Assign Approver
    public static void LocalGroupContractAssignApprover(ASI_TH_CRM_Contract__c ContractSelected){  //Contract ASI_CRM_Commercial_Team__c OwnerId
        //Set All Approver to Null
        ASI_CRM_CN_HeavyContract_TriggerClass.setApproverToNull(ContractSelected);
        
        List<ASI_TH_CRM_Contract__c> ChildContractList= [select Id,Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_Est_Total_Dummy__c,ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_Converted_From__r.ASI_CRM_CN_Status__c, ASI_CRM_Converted_From__r.ASI_CRM_CN_PO_Version__c,
                                         ASI_CRM_CN_Group_Contract__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_PSF_Estimate_Adjustment_Amount__c,ASI_CRM_Investment_Type__c,ASI_TH_CRM_Summary_Contract_Spending__c, ASI_CRM_CN_Total_Contract_Amount__c ,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,ASI_CRM_PSF_Grand_Estimate_Total__c,ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                         ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                         ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,  ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                         recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                         ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                         ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c
                                         from ASI_TH_CRM_Contract__c 
                                         where  ASI_CRM_CN_Status__c!='FY landing Archive' 
                                         and (ASI_CRM_CN_Group_Contract__c =:ContractSelected.ID  ) ];
        Decimal TotalAmount=0.0;
        for(ASI_TH_CRM_Contract__c ChildContract:ChildContractList ){
            if(ChildContract.ASI_CRM_CN_Status__c!='Archived' && ChildContract.ASI_CRM_CN_Status__c!='Draft'){
                 TotalAmount +=ASI_CRM_CN_HeavyContractUtilitiesClass.CalTotalContractAmount(ChildContract);
            }else if(ChildContract.ASI_CRM_CN_Status__c =='Archived' && ChildContract.ASI_CRM_Converted_From__r.ASI_CRM_CN_Status__c =='Draft'){
               // check if it is lastet version
               Decimal CurrentPOVersion = Decimal.valueOf(ChildContract.ASI_CRM_CN_PO_Version__c);
               Decimal MasterPOVersion = Decimal.valueOf(ChildContract.ASI_CRM_Converted_From__r.ASI_CRM_CN_PO_Version__c);
               if(CurrentPOVersion + 0.1 == MasterPOVersion){
                    TotalAmount +=ASI_CRM_CN_HeavyContractUtilitiesClass.CalTotalContractAmount(ChildContract);
               }
                
            }
        }
        
        
        
        User ContractOwner = [Select id, ManagerID, ASI_CRM_Sales_Team__c from User Where id= :ContractSelected.OwnerId ];
        String ApprovalSalesTeam='';
        if(ContractOwner.ASI_CRM_Sales_Team__c!=null ){
            ApprovalSalesTeam=ContractOwner.ASI_CRM_Sales_Team__c;
        }
        String CommercialTeam= ContractSelected.ASI_CRM_NationalGroup__r.ASI_CRM_Commercial_Team__c!=null ? ContractSelected.ASI_CRM_NationalGroup__r.ASI_CRM_Commercial_Team__c : '';
        //ASI_CRM_NationalGroup__r.ASI_CRM_Commercial_Team__c
        
        //OwnerId ASI_CRM_Sales_Team__c + Contract ASI_CRM_Commercial_Team__c             ASI_CRM_Sales_Team__c
        List<ASI_CRM_Fix_Approval_Route__c>  FixApprovalRoute = [Select Id,ASI_CRM_RVP__c,ASI_CRM_CN_Region_Area_Channel__c, ASI_CRM_Max_Amount__c, ASI_CRM_CN_Entry_Limit__c,ASI_CRM_CN_Approver_1__c, ASI_CRM_CN_Approver_2__c, ASI_CRM_CN_Approver_3__c,
                                                                 ASI_CRM_CN_Approver_4__c, ASI_CRM_CN_Approver_5__c, ASI_CRM_CN_Approver_6__c, ASI_CRM_CN_Approver_7__c,ASI_CRM_CN_Approver_8__c,ASI_CRM_CN_Approver_9__c,ASI_CRM_CN_Approver_10__c,ASI_CRM_CN_Approval_Limit_1__c, ASI_CRM_CN_Approval_Limit_2__c, ASI_CRM_CN_Approval_Limit_3__c,
                                                                 ASI_CRM_CN_Approval_Limit_4__c, ASI_CRM_CN_Approval_Limit_5__c, ASI_CRM_CN_Approval_Limit_6__c,ASI_CRM_CN_Approval_Limit_7__c,
                                                                 ASI_CRM_CN_Approval_Limit_8__c,ASI_CRM_CN_Approval_Limit_9__c,ASI_CRM_CN_Approval_Limit_10__c,
                                                                 ASI_CRM_CN_Type__c, ASI_CRM_CN_Regional_BA__c, ASI_CRM_Sales_Team__c , ASI_CRM_Commercial_Team__c
                                                                 from ASI_CRM_Fix_Approval_Route__c where ASI_CRM_CN_Type__c = 'Local Group Contract Header' and ASI_CRM_Sales_Team__c =:ApprovalSalesTeam
                                                                 and ASI_CRM_Commercial_Team__c= :CommercialTeam]; 
        if(FixApprovalRoute.size()>0){
            ASI_CRM_Fix_Approval_Route__c SelectedFixApprovalRoute;
            
            SelectedFixApprovalRoute=FixApprovalRoute[0];
            
            if(SelectedFixApprovalRoute != null && SelectedFixApprovalRoute.ASI_CRM_CN_Regional_BA__c!=null){
                ContractSelected.ASI_CRM_Last_RBA_Approver__c=SelectedFixApprovalRoute.ASI_CRM_CN_Regional_BA__c;
            }
            ContractSelected.ASI_CRM_Approval_Route_Id__c = SelectedFixApprovalRoute.Id ; 
            
            Integer approver_count = 0;
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_1__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_1__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_1__c);
                approver_count++;
            }
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_2__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_2__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_2__c);
                approver_count++;
            }
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_3__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_3__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_3__c);
                approver_count++;
            }
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_4__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_4__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_4__c);
                approver_count++;
            }
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_5__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_5__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_5__c);
                approver_count++;
            } 
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_6__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_6__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_6__c);
                approver_count++;
            } 
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_7__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_7__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_7__c);
                approver_count++;
            } 
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_8__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_8__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_8__c);
                approver_count++;
            } 
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_9__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_9__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_9__c);
                approver_count++;
            } 
            if(SelectedFixApprovalRoute.ASI_CRM_CN_Approver_10__c != null && SelectedFixApprovalRoute.ASI_CRM_CN_Approval_Limit_10__c < TotalAmount){
                ASI_CRM_CN_HeavyContract_TriggerClass.setApproverByCount(ContractSelected, approver_count, SelectedFixApprovalRoute.ASI_CRM_CN_Approver_10__c);
                approver_count++;
            }
        }                                              
        
        
        update ContractSelected; 
        
    }
    
    
    
    
    
    //Generate Contract Template  from  'Document'
    public static Document GenerateContractTemplate(String RegionName,Boolean Is2Party){
        Document DocumentFile  = new Document();
        String FolderDeveloperName='ASI_CRM_CN';
        if(Is2Party){
            FolderDeveloperName+='_2Party';
        }
        
        FolderDeveloperName+= RegionName!=null? '_'+RegionName.replace(' Region',''):'';
        
        if(RegionName==null){
            FolderDeveloperName+='_General';
        }
        
        FolderDeveloperName = FolderDeveloperName.replace(' ','');
        Folder FolderSelected = new Folder();
        
        
        try{
            system.debug('Finally we get1 '+FolderDeveloperName);
            FolderSelected =[select id,DeveloperName from Folder where DeveloperName=:FolderDeveloperName limit 1 ];
            DocumentFile =[select id,Body,FolderId,LastModifiedDate from Document where FolderId =:FolderSelected.Id order BY LastModifiedDate desc limit 1]; 
            
        }catch(exception e){
            system.debug('Finally we get ASI_CRM_CN_General ');
            if(!Test.isRunningTest() && !Is2Party){
                
                FolderSelected =[select id,DeveloperName from Folder where DeveloperName='ASI_CRM_CN_General' limit 1 ];
                DocumentFile =[select id,Body,FolderId,LastModifiedDate from Document where FolderId =:FolderSelected.Id order BY LastModifiedDate desc limit 1];
            }else if(!Is2Party){
                DocumentFile =[select id,Body,FolderId,LastModifiedDate from Document where DeveloperName ='ASI_CRM_CN_Heavy_Test_document' limit 1];
            }
            
        }    
        
        return DocumentFile;
        
    }
    
    
    //For Line Breaking 
    //check if string contain  a script keyword for Chinese characters
    public static Boolean containsChineseCharacters(String InputString){
        Pattern p = Pattern.compile('\\p{IsHan}');
        Matcher m = p.matcher( InputString );
        return m.find();
    }
    
    
    //Tell if string contains a-z or A-Z Character
    public static Boolean containsEnglishCharacters(String InputString){
        Boolean ContainEnglish=false;
        
        Pattern p = Pattern.compile('.*[A-Z].*');
        Matcher m = p.matcher( InputString );
        if(m.find()){
            ContainEnglish=true;
        }
        
        Pattern p2 = Pattern.compile('.*[a-z].*');
        Matcher m2 = p2.matcher( InputString );
        if(m2.find() && !ContainEnglish){
            ContainEnglish=true;
        }
        
        return ContainEnglish;
    }
    
    
    
    
    public static String ErrorMsgTransform(String InputErrorMsg){
        String ReturnString = '';
        if(InputErrorMsg!=null){
            if(InputErrorMsg.contains('Please select correct PO period')){
                ReturnString='Please select correct PO period.';
            }else if(InputErrorMsg.contains('Contract Date Overlap.')){
                ReturnString='Contract Date Overlap';
            }else if(InputErrorMsg.contains('合同日期重叠')){
                ReturnString='合同日期重叠'; 
            }else{
                ReturnString = InputErrorMsg;
            }
        }
        
        return ReturnString;
    }
}