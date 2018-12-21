/* Filename  :  ASI_CRM_CN_HeavyGenerateGroupShuttleJob.cls
* Author     :  Laputa
* Purpose    :  Batch Job to generate Contract in national Contract
* Testing    :  
* History

* -----------------------------------------------------------------------------
* 2017-09-12   Laputa      Created

*/

public  with sharing class ASI_CRM_CN_HeavyGenerateGroupShuttleJob implements Database.Batchable<sObject>{
    public string msg {set;get;}
    public string ContractId {set;get;}{ContractId='';}
    public String PreviousContractId {set;get;}{PreviousContractId='';}
    public Boolean SubmitApproval {set;get;}{SubmitApproval=false;}
    
    public ASI_CRM_CN_HeavyGenerateGroupShuttleJob(String ContractId , string PreviousContractId, Boolean SubmitApproval ){
        this.ContractId=ContractId;
        this.PreviousContractId=PreviousContractId;
        this.SubmitApproval=SubmitApproval;
        //ASI_CRM_CN_HeavyContractUtilitiesClass.InitAttachmentJson(ContractId);
        
        List<ASI_Attachment__c> TempList = [select id,ASI_CRM_External_Key__c,ASI_CRM_Last_Run_Time__c,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_New_Contract_v0_0__c,ASI_CRM_New_Contract_vFinal__c,ASI_CRM_Comments__c  
                                            from ASI_Attachment__c where ASI_CRM_Contract__c =:ContractId and ownerId=:UserInfo.getUserId() and ASI_CRM_Type__c='Group Contract'];
        
        if(TempList.size()>0){
            ASI_Attachment__c TempRecord= TempList[0];
            TempRecord.ASI_CRM_For_Contract_Use__c=true;
            TempRecord.ASI_CRM_Historical_Financial_Data__c='';
            TempRecord.ASI_CRM_New_Contract_v0_0__c='';
            TempRecord.ASI_CRM_New_Contract_vFinal__c='';
            TempRecord.ASI_CRM_Comments__c=ContractId;
            TempRecord.ASI_CRM_Comments__c+=PreviousContractId!=null? ';'+PreviousContractId:';';
            update TempRecord;
            
        }else{
            string Comments =ContractId;
            Comments+=PreviousContractId!=null? ';'+PreviousContractId:';';
            ASI_Attachment__c att= new ASI_Attachment__c(ASI_CRM_Contract__c=ContractId,ASI_CRM_For_Contract_Use__c=true,ASI_CRM_Historical_Financial_Data__c='',ASI_CRM_New_Contract_v0_0__c='',ASI_CRM_New_Contract_vFinal__c='',ASI_CRM_Comments__c=Comments,
                                                         ASI_CRM_Type__c='Group Contract');
            insert att;
            
        }
        
        
    }
    
    
    public database.querylocator start(Database.BatchableContext BC){
        
        // This methods returns a SOQL query locator containing the records
        if(PreviousContractId!=null &&  PreviousContractId!=''){
            return Database.getQueryLocator([select Id,Name, ASI_CRM_CN_V0_0_PO_version__c,
                                             ASI_CRM_CN_Group_Contract__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_PSF_Estimate_Adjustment_Amount__c,ASI_CRM_Investment_Type__c,ASI_TH_CRM_Summary_Contract_Spending__c, ASI_CRM_CN_Total_Contract_Amount__c ,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,ASI_CRM_PSF_Grand_Estimate_Total__c,ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                             ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                             ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,  ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                             recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                             ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                             ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c
                                             from ASI_TH_CRM_Contract__c 
                                             where ASI_CRM_CN_Status__c!='Archived' and ASI_CRM_CN_Status__c!='FY landing Archive' 
                                             and (ASI_CRM_CN_Group_Contract__c =:ContractId or ASI_CRM_CN_Group_Contract__c =:PreviousContractId) ]);
        }else{
            return Database.getQueryLocator([select Id,Name, ASI_CRM_CN_V0_0_PO_version__c,
                                             ASI_CRM_CN_Group_Contract__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_PSF_Estimate_Adjustment_Amount__c,ASI_CRM_Investment_Type__c,ASI_TH_CRM_Summary_Contract_Spending__c, ASI_CRM_CN_Total_Contract_Amount__c ,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,ASI_CRM_PSF_Grand_Estimate_Total__c,ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                             ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                             ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,   ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                             recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                             ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                             ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c
                                             from ASI_TH_CRM_Contract__c 
                                             where ASI_CRM_CN_Status__c!='Archived' and ASI_CRM_CN_Status__c!='FY landing Archive' 
                                             and ASI_CRM_CN_Group_Contract__c =:ContractId  ]);
        }
        
    }
    
    
    //Historical contract--->RestructureCurrentFIData---> Historical v0 and vFinal Data
    //Current contract v0.0-->RestructureCurrentFinancialIndicatorData---> New contract v0.0 Estimate and Contract FI Data
    //Current contract ----->RestructureCurrentFIData ---->Current vFinal Data 
    //
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        Boolean AllowcalCulation=true;
        List<ASI_TH_CRM_Contract__c> ContractList= scope;// for(ASI_TH_CRM_Contract__c ContractSelected:ContractList){
        ASI_TH_CRM_Contract__c ContractSelected = new ASI_TH_CRM_Contract__c();
        
        if(ContractList.size()>0 && ContractList.size()==1){
            ContractSelected=ContractList[0];
        }
        
        
        //if it is Draft contract, system will find the Last PO Version
        if(ContractSelected.ASI_CRM_CN_Status__c=='Draft' && ContractSelected.ASI_CRM_CN_V0_0_PO_version__c != Null && ContractSelected.ASI_CRM_CN_Last_PO_version__c!=null){
            String LastPOVersion=ContractSelected.ASI_CRM_CN_Last_PO_version__c;
            ContractSelected = [SELECT id,ASI_CRM_CN_Group_Contract__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_CN_Expected_BRSF_Est_Total__c,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_PO_Version__c,ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_Volume_Option__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c, ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_New_FY_PO__c, ASI_CRM_CN_Status__c FROM ASI_TH_CRM_Contract__c WHERE ID=:LastPOVersion LIMIT 1];
        }else if(ContractSelected.ASI_CRM_CN_Status__c=='Draft'){
            AllowcalCulation=false;
        }
        
        
        if(AllowcalCulation){
            if(ContractSelected.ASI_CRM_CN_Group_Contract__c==ContractId){ //Current Data
                
                if( ContractSelected.ASI_CRM_CN_V0_0_PO_version__c == null){ // current contract is v0.0 and vFinal
                    // Calculate new contract V0.0  estimate and Contract AMount
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> CurrentContractList =ASI_CRM_CN_HeavyContractUtilitiesClass.RestructureCurrentFinancialIndicatorData(ContractSelected);
                    
                    //Calculate new contract Vfinal Data
                    ASI_CRM_CN_HeavyContractUtilitiesClass.ReconstructCurrentPOModiFIData(ContractSelected); 
                    
                    
                    ASI_CRM_CN_HeavyContractUtilitiesClass.UpdateAttachmentContractData(ContractId,ContractSelected.Id,ContractSelected.Id);
                }else{// Finding v0.0
                    // v0.0 estimate and Contract AMount
                    String V00ContractId = ContractSelected.ASI_CRM_CN_V0_0_PO_version__c;
                    ASI_TH_CRM_Contract__c V0Contract = new ASI_TH_CRM_Contract__c();
                    try{
                        V0Contract = [SELECT id, Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,  ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,   ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__c, Owner.Name, ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,  ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,  ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c ,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c  FROM ASI_TH_CRM_Contract__c  WHERE id = :V00ContractId];
                    }catch(exception e){V0Contract = ContractSelected;}
                    
                    List<ASI_CRM_CN_HeavyContractUtilitiesClass.FinancialIndicator> CurrentContractList =ASI_CRM_CN_HeavyContractUtilitiesClass.RestructureCurrentFinancialIndicatorData(V0Contract);
                    
                    //Calculate new contract Vfinal Data
                    ASI_CRM_CN_HeavyContractUtilitiesClass.ReconstructCurrentPOModiFIData(ContractSelected); 
                    ASI_CRM_CN_HeavyContractUtilitiesClass.UpdateAttachmentContractData(ContractId,V0Contract.Id,ContractSelected.Id); 
                }
                
            }else if(ContractSelected.ASI_CRM_CN_Group_Contract__c==PreviousContractId){ //historical Data
                ASI_CRM_CN_HeavyContractUtilitiesClass.RestructureCurrentFIData(ContractSelected);
                ASI_CRM_CN_HeavyContractUtilitiesClass.UpdateAttachmentHistoricalData(ContractId,ContractSelected.Id);//HistoricalContractSet.add();
            }
            
        }
        
        
        
    }
    
    public void finish(Database.BatchableContext BC){//ASI_CRM_Historical_Financial_Data__c=System.JSON.serialize(JSONList),
        
        List<ASI_Attachment__c> TempList = [select id,ASI_CRM_External_Key__c,ASI_CRM_Last_Run_Time__c,ASI_CRM_Historical_Financial_Data__c  
                                            from ASI_Attachment__c where ASI_CRM_Contract__c =:ContractId and ownerId=:UserInfo.getUserId() and ASI_CRM_Type__c='Group Contract'];
        
        
        if(TempList.size()>0){
            ASI_Attachment__c TempRecord= TempList[0];
            TempRecord.ASI_CRM_Last_Run_Time__c=system.now();
            update TempRecord;
        }else{//ASI_Attachment__c att= new ASI_Attachment__c(ASI_CRM_Contract__c=ContractId,ASI_CRM_Type__c='Group Contract',ASI_CRM_Last_Run_Time__c=system.now());
            insert new ASI_Attachment__c(ASI_CRM_Contract__c=ContractId,ASI_CRM_Type__c='Group Contract',ASI_CRM_Last_Run_Time__c=system.now());
        }
        ASI_CRM_CN_HeavyContractUtilitiesClass.SendGroupContractShuttle(ContractId);
        
        
        
        
        if(SubmitApproval && !Test.isRunningTest()){ Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest(); req1.setObjectId(ContractId);Approval.ProcessResult result = Approval.process(req1);}
    }
}