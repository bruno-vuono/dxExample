//Generate Group Contract Profit Shuttle PDF Schedule Job Page
public with sharing  class ASI_CRM_CN_HeavyGenGroupShuttleCtrl {
     public ASI_TH_CRM_Contract__c ContractSelected {set;get;}
    
    public String PageId {set;get;}
    public Id BatchId {set;get;}
    public string Msg {set;get;}
    Public String status {set;get;}
    Public Boolean RunningJob {set;get;}
    Public String LastCalTimeStr {set;get;}{LastCalTimeStr='';}
    public ASI_CRM_CN_HeavyGenGroupShuttleCtrl(ApexPages.StandardController controller) {
        
        this.ContractSelected = (ASI_TH_CRM_Contract__c )controller.getRecord();
        if(this.ContractSelected != null)
            PageId = ContractSelected.id;
        
        this.ContractSelected = [SELECT Id,Name,OwnerId,ASI_CRM_Commercial_Team__c,ASI_CRM_NationalGroup__c,ASI_CRM_CN_Group_Contract__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c,ASI_CRM_CN_Total_Contract_Amount__c , ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_New_Image__c, ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                 ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                 ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,   ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                 recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                 ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                 ASI_CRM_NationalGroup__r.ASI_CRM_Commercial_Team__c ,ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c,
                                 (Select Id, Name, ASI_CRM_CN_Last_Payment__c, ASI_TH_CRM_Contract__c,ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_End_Date__c,ASI_TH_CRM_Status__c,ASI_CRM_CN_Channel__c, ASI_CRM_CN_Total_Payment__c,ASI_CRM_CN_Paid__c,ASI_CRM_CN_Paid_In_Progress__c, ASI_CRM_CN_Payment_Raised_Date__c From ASI_TH_CRM_PaymentRequests_Contract__r)                       
                                 FROM ASI_TH_CRM_Contract__c
                                 WHERE id =:pageId ];
        
        List<ASI_Attachment__c> TempList = [select id,ASI_CRM_External_Key__c,ASI_CRM_Last_Run_Time__c from ASI_Attachment__c where ASI_CRM_Contract__c =:ContractSelected.Id and ownerId=:UserInfo.getUserId()];
        if(TempList.size()>0 && TempList[0].ASI_CRM_Last_Run_Time__c!=null ){
            datetime LastCalTime=TempList[0].ASI_CRM_Last_Run_Time__c;
            LastCalTimeStr=LastCalTime.format();
        }
        RunningJob=true;
    }
    
    
    
    public void RunJob(){
        
        //Finding Previous Contract
        ASI_TH_CRM_Contract__c PreviousCC = new ASI_TH_CRM_Contract__c();
        
        try{ 
            PreviousCC = [SELECT id,ASI_CRM_Volume_Option__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c, ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_New_FY_PO__c, ASI_CRM_CN_Status__c
                          FROM ASI_TH_CRM_Contract__c WHERE ASI_CRM_NationalGroup__c =:ContractSelected.ASI_CRM_NationalGroup__c and
                          ASI_CRM_CN_PO_End_Date__c != null and
                          ASI_CRM_CN_PO_Start_Date__c != null and ASI_CRM_CN_PO_End_Date__c<:ContractSelected.ASI_CRM_CN_PO_End_Date__c and 
                          ( RecordType.DeveloperName='ASI_CRM_CN_Group_Contract' or RecordType.DeveloperName like 'ASI_CRM_CN_Local_Group%'  )
                          ORDER BY ASI_CRM_CN_PO_End_Date__c DESC LIMIT 1];
        }catch(exception e){
            PreviousCC = new ASI_TH_CRM_Contract__c();
        }
        
        String PreviousContractId='';
        IF(PreviousCC.Id!=null){
            PreviousContractId=PreviousCC.Id;
        }
        //this will submit for approval
        BatchId = Database.executeBatch(new ASI_CRM_CN_HeavyGenerateGroupShuttleJob(ContractSelected.id,PreviousContractId,false),1);
        RunningJob=false;
        
    }
    
    
    public void RunJobFun(){
        //Running the Job and Submit Approval 
        ASI_TH_CRM_Contract__c PreviousCC = new ASI_TH_CRM_Contract__c();
        try{
            PreviousCC = [SELECT id,ASI_CRM_Volume_Option__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c, ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c,   ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__c, Owner.Name, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Estimate_Cost_Total__c,  ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Contract_Est_Var_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_New_FY_PO__c, ASI_CRM_CN_Status__c
                          FROM ASI_TH_CRM_Contract__c WHERE ASI_CRM_NationalGroup__c =:ContractSelected.ASI_CRM_NationalGroup__c and
                          ASI_CRM_CN_PO_End_Date__c != null and
                          ASI_CRM_CN_PO_Start_Date__c != null and ASI_CRM_CN_PO_End_Date__c<:ContractSelected.ASI_CRM_CN_PO_End_Date__c and 
                          ( RecordType.DeveloperName='ASI_CRM_CN_Group_Contract' or RecordType.DeveloperName like 'ASI_CRM_CN_Local_Group%' )
                          ORDER BY ASI_CRM_CN_PO_End_Date__c DESC LIMIT 1];
            
        }catch(exception e){
            PreviousCC = new ASI_TH_CRM_Contract__c();
            
        }
        String PreviousContractId='';
        IF(PreviousCC.Id!=null){
            PreviousContractId=PreviousCC.Id;
        }
        BatchId = Database.executeBatch(new ASI_CRM_CN_HeavyGenerateGroupShuttleJob(ContractSelected.id,PreviousContractId,true),1);
        RunningJob=false;
    }
    
    public PageReference RunJobAndSubmitApprovalbySteps(){
        
        //Assign Approver in Local Group Contract
        ASI_CRM_CN_HeavyContracFunctionClass.LocalGroupContractAssignApprover(ContractSelected);
        
        RunJobFun();
        
        return null; 
    }
    
    
    public PageReference RunJobAndSubmitApproval(){
        
        //Assign Approver in Local Group Contract
        ASI_CRM_CN_HeavyContracFunctionClass.LocalGroupContractAssignApprover(ContractSelected);
        
        
        if(LastCalTimeStr==''){
            //Finding Previous Contract
            RunJobFun();
        }else if (!Test.isRunningTest()){
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest(); req1.setObjectId(ContractSelected.id); Approval.ProcessResult result = Approval.process(req1);return new pageReference('/' + PageId);
        }
        
        
          return null;     
    }
    
    
    
    
    
    
    
    
     public string[] statusMsgs {
        get {
            string s = Msg==null? '': Msg;
            if(BatchId!=null) {
                
                list<AsyncApexJob> aajs = [SELECT Id, Status, ExtendedStatus FROM AsyncApexJob WHERE ID =: BatchId ];
                if(aajs.size()>0) {
                    s = aajs[0].Status;
                    status = aajs[0].Status;
                    if(aajs[0].Status=='Queued' && !Test.isRunningTest()){
                        s=' Waiting, there are other jobs are running now（我们正在排队计算《集团合同合并利润分析表》，请您耐心等候。）.....';
                    }else if(aajs[0].Status=='Holding' && !Test.isRunningTest() ){
                      s='Waiting,the job is running now....（我们正在努力地帮您计算《集团合同合并利润分析表》，请您耐心等候。）';
                    }else if(aajs[0].Status=='Completed' || Test.isRunningTest() ){
                         string link=System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/ASI_CRM_CN_HeavyGroupProfitShuttlePDF?id='+ContractSelected.Id;
                        s='3. The Calculation Job has completed! Please refer（计算已经完成，请浏览最新版本的《集团合同合并利润分析表》）: <a href='+link+'  style="font-weight: bold;font-size: 150%;color:red;"  >Link</a>';
                        if(aajs[0].ExtendedStatus!=null){
                            s+=aajs[0].ExtendedStatus;   
                        }
                    }else{
                         s = aajs[0].Status;
                    }
                   
                }
            }
            return s.split('\n');
        }
    }
    

  
        
}