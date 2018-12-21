/* Filename  :  ASI_CRM_CN_HeavyContractHeaderCtrl.cls
* Author     :  Laputa
* Purpose    :  Controller for editing heavy contract header on Page 
* Study From :  ASI_CRM_CN_HeavyContractHeaderEditPage
* Testing    :  
* History
* -----------------------------------------------------------------------------
* 2017-06-26   Laputa      Created

*/
public class ASI_CRM_CN_HeavyContractHeaderCtrl {
    public ASI_TH_CRM_Contract__c ContractSelected {set;get;}
    public String PageId {set;get;}
    
    public boolean showCN {set;get;}
    public boolean EditDate {get; set;}{EditDate=true;}
    
    public boolean ReadOnlyModule {get; set;}{ReadOnlyModule=false;}
    
    public boolean POModification {get; set;}
    
    public Boolean AutoLinkToPO {get; set;} {AutoLinkToPO = false;}
    public Date StartDate  {get; set;}
    public Date EndDate  {get; set;}
    
    public boolean UpsertPermission {get;set;}{UpsertPermission=true;}
    public String Msg {get;set;} {Msg='';}
    public Integer NoOfMonths {get; set;}{NoOfMonths=1;}
    
    //**********Group Contract**************
    public boolean IsNewContract  {get;set;} {IsNewContract=false;}
    public list<selectOption> GroupContractOptionType {Get; Set;}
    Public Boolean needChannelnProvince{Get; Set;}
    
    
    
    
    public ASI_CRM_CN_HeavyContractHeaderCtrl(ApexPages.StandardController controller) {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String CustomerId = ApexPages.currentPage().getParameters().get('ASI_CRM_CN_Outlet_WS__c');
        
        String isEdit = params.get('POModification');
        POModification = isEdit == '1' ? true : false;
        
        
        if(CustomerId!=null){// create New with KA Account 
            AutoLinkToPO = false;
            ContractSelected = new ASI_TH_CRM_Contract__c(ASI_CRM_Investment_Type__c='Heavy',ASI_CRM_New_FY_PO__c=true, ASI_CRM_CN_PO_Version__c='0.0',ASI_CRM_SG_Events__c=true,ASI_TH_CRM_Promotion_Type__c='Heavy Contract On',recordtypeid = Global_RecordTypeCache.getRtId('ASI_TH_CRM_Contract__cASI_CRM_CN_Contract'),
                                                          ASI_CRM_CN_Outlet_WS__c=CustomerId,name='Automated, Do not Change');
            
            IsNewContract=true;
            List<ASI_CRM_AccountsAdditionalField__c> tmpCustomer = new List<ASI_CRM_AccountsAdditionalField__c>([SELECT id, ASI_CRM_CN_NewChannel__c, ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_Local_Group__c ,
                                                                                                                 ASI_CRM_CN_CCity__r.ASI_CRM_CN_Province__c, 
                                                                                                                 recordType.DeveloperName,ASI_CRM_CN_Commercial_Team__c,ASI_CRM_CN_NewChannel__r.ASI_CRM_CN_On_Off__c , ASI_CRM_CN_Channel_CN__c, ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_National_Group__c,
                                                                                                                 ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_Auto_link_to_PO_Open__c, ASI_CRM_CN_KA_Account_Chain__c, ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_Inactive__c,
                                                                                                                 ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_National_Group__c, ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_Apply_National_Approval__c
                                                                                                                 FROM ASI_CRM_AccountsAdditionalField__c
                                                                                                                 WHERE id = : ContractSelected.ASI_CRM_CN_Outlet_WS__c ]);
            
            
            
            
            if(tmpCustomer.size() > 0 && tmpCustomer[0].recordType.DeveloperName.contains('ASI_CRM_Outlet_CN')){
                if(tmpCustomer[0].ASI_CRM_CN_NewChannel__c != NULL && !tmpCustomer[0].ASI_CRM_CN_NewChannel__r.Name.contains('All Customer')){
                    needChannelnProvince = FALSE;
                    ContractSelected.ASI_CRM_PO_Channel__c = tmpCustomer[0].ASI_CRM_CN_NewChannel__c;
                    ContractSelected.ASI_CRM_PO_Province__c = tmpCustomer[0].ASI_CRM_CN_CCity__r.ASI_CRM_CN_Province__c;
                }else if(tmpCustomer[0].ASI_CRM_CN_NewChannel__c == NULL && !tmpCustomer[0].ASI_CRM_CN_Channel_CN__c.contains('All Customer')){
                    
                    needChannelnProvince = FALSE;
                    ContractSelected.ASI_CRM_PO_Channel__c = tmpCustomer[0].ASI_CRM_CN_NewChannel__c;
                    ContractSelected.ASI_CRM_PO_Province__c = tmpCustomer[0].ASI_CRM_CN_CCity__r.ASI_CRM_CN_Province__c;
                    
                }else{
                    needChannelnProvince = TRUE;
                }
                
                
                if(tmpCustomer[0].ASI_CRM_CN_KA_Account_Chain__c!=null ){
                    if(tmpCustomer[0].ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_National_Group__c){
                        ContractSelected.ASI_CRM_CN_National_Group_Contract__c = True;
                    }
                    if(tmpCustomer[0].ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_Local_Group__c){
                        ContractSelected.ASI_CRM_CN_Local_Group_Contract__c = True;
                    }
                    
                    if(tmpCustomer[0].ASI_CRM_CN_KA_Account_Chain__r.ASI_CRM_Auto_link_to_PO_Open__c){
                        AutoLinkToPO = true;
                        //finding the last One in this KA Account
                        ASI_TH_CRM_Contract__c contract=ASI_CRM_CN_HeavyContractUtilitiesClass.KAAccountQueryNewestContract(tmpCustomer[0].ASI_CRM_CN_KA_Account_Chain__c);
                        ContractSelected.ASI_CRM_CN_Group_Contract__c=contract.Id;
                        ContractSelected.ASI_CRM_CN_Bottle_Collection_Rate__c= contract.ASI_CRM_CN_Bottle_Collection_Rate__c!=null? contract.ASI_CRM_CN_Bottle_Collection_Rate__c:97;
                        ContractSelected.ASI_CRM_Martell_BC_Rate__c= contract.ASI_CRM_Martell_BC_Rate__c!=null? contract.ASI_CRM_Martell_BC_Rate__c:97;
                        
                    }else{
                        //ASI_CRM_CN_Bottle_Collection_Rate__c ASI_CRM_Martell_BC_Rate__c
                        List<ASI_TH_CRM_Contract__c> ContractList = [Select Id,Name, CreatedDate,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_Martell_BC_Rate__c from ASI_TH_CRM_Contract__c 
                                                                     where ( RecordType.DeveloperName ='ASI_CRM_CN_Group_Contract' or RecordType.DeveloperName like 'ASI_CRM_CN_Local_Group_Contract%') 
                                                                     and ASI_CRM_NationalGroup__c =:tmpCustomer[0].ASI_CRM_CN_KA_Account_Chain__c and 
                                                                     ASI_CRM_Active_Dummy_PO__c=true order by CreatedDate DESC];
                        GroupContractOptionType = new list<selectOption>();
                        system.debug('ContractList 2018 : '+ ContractList);
                        if(ContractList.size()>0){
                            ContractSelected.ASI_CRM_CN_Bottle_Collection_Rate__c= ContractList[0].ASI_CRM_CN_Bottle_Collection_Rate__c!=null? ContractList[0].ASI_CRM_CN_Bottle_Collection_Rate__c:97;
                            ContractSelected.ASI_CRM_Martell_BC_Rate__c= ContractList[0].ASI_CRM_Martell_BC_Rate__c!=null? ContractList[0].ASI_CRM_Martell_BC_Rate__c:97;
                            for(ASI_TH_CRM_Contract__c NationalContract: ContractList){
                                GroupContractOptionType.add(new SelectOption(NationalContract.Id, NationalContract.Name)); 
                            }
                        }
                    }
                }
            }
            
            
            
        }else{
            this.ContractSelected = (ASI_TH_CRM_Contract__c )controller.getRecord();
            if(this.ContractSelected != null)
                PageId = ContractSelected.id;
            
            
            
            this.ContractSelected = [SELECT Id,Name,ASI_CRM_Auto_PO_Modification_Time__c,ASI_CRM_Auto_PO_Modification__c,ASI_CRM_Martell_BC_Rate__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_Previous_Version_PSF_Est_Total__c,ASI_CRM_CN_IsClone__c,
                                     ASI_CRM_CN_Group_Contract__r.ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_Group_Contract__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Group_Contract__c, ASI_CRM_CN_V0_0_PO_version__c,ASI_CRM_Investment_Type__c,ASI_CRM_CN_Total_Contract_Amount__c , ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                     ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                     ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c , ASI_CRM_Expected_V0_0_VEC_Est_Total__c,ASI_CRM_Expected_V0_BRSF_Estimated_Total__c,  ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                     recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                     ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                     ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c,
                                     (Select Id, Name, ASI_CRM_CN_Last_Payment__c, ASI_TH_CRM_Contract__c,ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_End_Date__c,ASI_TH_CRM_Status__c,ASI_CRM_CN_Channel__c, ASI_CRM_CN_Total_Payment__c,ASI_CRM_CN_Paid__c,ASI_CRM_CN_Paid_In_Progress__c, ASI_CRM_CN_Payment_Raised_Date__c From ASI_TH_CRM_PaymentRequests_Contract__r)                       
                                     FROM ASI_TH_CRM_Contract__c WHERE id =:pageId ];
            //save the contract Date
            StartDate=ContractSelected.ASI_CRM_CN_PO_Start_Date__c;
            EndDate=ContractSelected.ASI_CRM_CN_PO_End_Date__c;
            
            
            NoOfMonths=integer.valueOf(ContractSelected.ASI_CRM_CN_No_of_Months__c) ;
            if(ContractSelected.ASI_CRM_CN_PO_Version__c!='0.0'){
                EditDate=false;
            }else if(ContractSelected.ASI_CRM_CN_Status__c!='Draft'){
                EditDate=false;
            }
            if(POModification){
                EditDate=true;
            }
            
            if(ContractSelected.ASI_CRM_CN_Status__c=='Archived' || ContractSelected.ASI_CRM_CN_Status__c=='FY landing Archive'){ 
                ReadOnlyModule=true;
            }
        }
        
        
    }
    
    
    
    public void ChangingGroupContract(){
        List<ASI_TH_CRM_Contract__c> ContractList = [Select Id,Name, CreatedDate,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_Martell_BC_Rate__c from ASI_TH_CRM_Contract__c 
                                                     where id=:ContractSelected.ASI_CRM_CN_Group_Contract__c];
        if(ContractList.size()>0){
            ContractSelected.ASI_CRM_CN_Bottle_Collection_Rate__c= ContractList[0].ASI_CRM_CN_Bottle_Collection_Rate__c!=null? ContractList[0].ASI_CRM_CN_Bottle_Collection_Rate__c:97;
            ContractSelected.ASI_CRM_Martell_BC_Rate__c= ContractList[0].ASI_CRM_Martell_BC_Rate__c!=null? ContractList[0].ASI_CRM_Martell_BC_Rate__c:97;
        }
        
    }
    
    
    
    //*****************Save the record for Group Contract*****************
    public PageReference SaveNewContract(){
        PageReference pageRef = null;
        UpsertPermission=true;
        msg='';
        
        
        
        //Start Date/End Day should be within Group Contract period
        if(ContractSelected.ASI_CRM_CN_Group_Contract__c!=null && ContractSelected.ASI_TH_CRM_Promotion_Type__c == 'Heavy Contract On'){
            ASI_TH_CRM_Contract__c NationalGroup =[select id,ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_Group_Contract__c,ASI_CRM_CN_Group_Contract__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Group_Contract__r.ASI_CRM_CN_PO_End_Date__c 
                                                   from  ASI_TH_CRM_Contract__c where  id=:ContractSelected.ASI_CRM_CN_Group_Contract__c];
            if(ContractSelected.ASI_CRM_CN_PO_Start_Date__c<NationalGroup.ASI_CRM_CN_PO_Start_Date__c || ContractSelected.ASI_CRM_CN_PO_End_Date__c>NationalGroup.ASI_CRM_CN_PO_End_Date__c){
                UpsertPermission=false;
                msg=Label.ASI_CRM_CN_PO_Date_GroupContract;
            }
        }
        
        Set<id> checkCitySet = new Set<id>();
        
        List<ASI_CRM_City__c> citys = new List<ASI_CRM_City__c>([SELECT id,ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.ASI_CRM_Create_Heavy_Contract_On__c FROM ASI_CRM_City__c  WHERE recordType.developerName = 'ASI_CRM_CN_City'
                                                                 AND ASI_CRM_CN_Province__c =: ContractSelected.ASI_CRM_PO_Province__c ORDER BY Name]);
        
        List<ASI_CRM_AccountsAdditionalField__c> selectedOutlet = new List<ASI_CRM_AccountsAdditionalField__c>([SELECT id, ASI_CRM_CN_Inactive_Flag__c   From ASI_CRM_AccountsAdditionalField__c WHERE id = : ContractSelected.ASI_CRM_CN_Outlet_WS__c
                                                                                                                limit 1 ]);
        
        Map<Id, ASI_CRM_KA_Account__c> mapKAAccount = new Map<Id, ASI_CRM_KA_Account__c>();
        if(pageId == Null && ContractSelected.ASI_CRM_NationalGroup__c != Null){
            mapKAAccount = new Map<Id, ASI_CRM_KA_Account__c>([SELECT id, ASI_CRM_Apply_National_Approval__c,ASI_CRM_National_Group__c,ASI_CRM_Local_Group__c FROM ASI_CRM_KA_Account__c 
                                                               WHERE id = : ContractSelected.ASI_CRM_NationalGroup__c]);
        }
        
        if(selectedOutlet[0].ASI_CRM_CN_Inactive_Flag__c){
            if(USerInfo.getLanguage()=='zh_CN'){
                UpsertPermission=false;
                msg='不能为已关闭店家修改或创建合同';
            }else{
                UpsertPermission=false;
                msg='Not allowed to create/modify a PO with inactive Outlet';
            }
        }
        
        
        if(ContractSelected.ASI_CRM_PO_City__c != NULL && String.valueOf(ContractSelected.ASI_CRM_PO_City__c).trim() != '' && !checkCitySet.contains(ContractSelected.ASI_CRM_PO_City__c)){
            if(USerInfo.getLanguage()=='zh_CN'){
                UpsertPermission=false;
                msg='该城市不在省份内';
            }else{
                UpsertPermission=false;
                msg= 'City is not in Province' ;
            }
            
        }
        
        
        if(UpsertPermission){
            System.Savepoint pSavepoint = Database.setSavepoint();
            try{//ContractSelected.ASI_CRM_CN_National_Group_Contract__c = True;//ASI_CRM_CN_Local_Group_Contract__c
                
                insert ContractSelected;
                PageId = ContractSelected.id;
                
                //generate BRSF Lines
                ASI_CRM_CN_HeavyContractUtilitiesClass.GeneratingBRSFLine(ContractSelected);
                
                pageRef= new PageReference('/apex/ASI_CRM_CN_ViewHeavyContractPage');
                pageRef.getParameters().put('id',PageId);
                pageRef.setRedirect(true);
            } catch(Exception e){
                UpsertPermission=false;
                msg += ASI_CRM_CN_HeavyContracFunctionClass.ErrorMsgTransform(e.getMessage()) ;
                Database.rollback(pSavepoint);
                //ASI_MFM_ByPass_Setting.ErrorHandling( e.getMessage() , 'Fialed 123 : ASI_CRM_CN_HeavyContractHeaderCtrl','ASI_CRM_CN_HeavyContractHeaderCtrl.SaveNewContract');
            }
        }
        return pageRef; 
    }
    
    
    
    //*****************Save the record po edit or PO Modification*****************
    public PageReference SaveItems(){
        PageReference pageRef = null;
        UpsertPermission=true;
        msg='';
        
        
        if(!ValdationChecking()){
            UpsertPermission=false;
        }
        if(UpsertPermission){
            System.Savepoint pSavepoint = Database.setSavepoint();
            //POModificationProcess1(contractSelected);
            
            
            
            try{
                if(POModification){
                    POModificationProcess1(contractSelected);
                }else{
                    update ContractSelected;
                    ASI_CRM_CN_HeavyContractUtilitiesClass.ContractChangingPeriod(ContractSelected,NoOfMonths,StartDate,EndDate);
                }
                
                system.debug('Passed');
                pageRef = new PageReference('/'+PageId);
                pageRef.setRedirect(true);
                
            } catch(Exception e){ 
                // String ErrorMsg=;
                //if(ErrorMsg.contains('Please select correct PO period')){ErrorMsg='Please select correct PO period.';}
                //if(ErrorMsg.contains('Contract Date Overlap.')){ErrorMsg='Contract Date Overlap';}
                //if(ErrorMsg.contains('合同日期重叠')){ErrorMsg='合同日期重叠'; }
                //ErrorMsgTransform
                msg += ASI_CRM_CN_HeavyContracFunctionClass.ErrorMsgTransform(e.getMessage()) + '</br>';
                UpsertPermission=false;
                Database.rollback(pSavepoint);
            }
            
        }
        
        return pageRef; 
    }
    
    
    
    
    public boolean ValdationChecking(){
        Boolean isProcess = true;
        
        if(ContractSelected.ASI_CRM_CN_Group_Contract__c!=null){// is group contract
            if(ContractSelected.ASI_CRM_CN_PO_Start_Date__c<ContractSelected.ASI_CRM_CN_Group_Contract__r.ASI_CRM_CN_PO_Start_Date__c || 
               ContractSelected.ASI_CRM_CN_PO_End_Date__c>ContractSelected.ASI_CRM_CN_Group_Contract__r.ASI_CRM_CN_PO_End_Date__c){
                   
                   msg +=Label.ASI_CRM_CN_PO_Date_GroupContract + '</br>';
                   isProcess=false;
               }
        }
        if(ContractSelected.ASI_CRM_CN_Source_of_Contract__c == Null || ContractSelected.ASI_CRM_CN_Source_of_Contract__c == ''){
            msg += ' Please input Source of Contract.请输入合同来源' + '</br>';
            isProcess=false;
        }
        
        
        if(ContractSelected.ASI_CRM_CN_PO_Start_Date__c == Null){
            msg += ' Please input Start Date.请输入开始日期' + '</br>';
            isProcess=false;
        }
        
        if(ContractSelected.ASI_CRM_CN_PO_End_Date__c == Null){
            msg += ' Please input End Date.请输入结束日期' + '</br>';
            isProcess=false;
        }
        
        if(ContractSelected.ASI_CRM_CN_Bottle_Collection_Rate__c == Null){
            msg += ' Please input Bottle Collection Rate.请输入空瓶回收率' + '</br>';
            isProcess=false;
        }
        if(ContractSelected.ASI_CRM_Martell_BC_Rate__c == Null && ContractSelected.ASI_CRM_CN_PO_Version__c=='0.0' && ContractSelected.ASI_CRM_CN_Status__c == 'Draft' && ContractSelected.ASI_CRM_CN_Group_Contract__c==null){
            msg += 'Please input Martell Bottle Collection Rate.请输入马爹利空瓶回收率' + '</br>';
            isProcess=false;
        }
        
        
        if(ContractSelected.ASI_CRM_CN_PO_Start_Date__c!=null && ContractSelected.ASI_CRM_CN_PO_Start_Date__c.day()!=1){
            msg += Label.ASI_CRM_CN_PO_Start_Date_Validation+'<br/>';
            isProcess=false;
        }
        
        //checking end day         
        Date LastEndDate = ContractSelected.ASI_CRM_CN_PO_End_Date__c!=null?ContractSelected.ASI_CRM_CN_PO_End_Date__c.addMonths(1).toStartOfMonth().addDays(-1):null;
        if(LastEndDate!=null && ContractSelected.ASI_CRM_CN_PO_End_Date__c != LastEndDate){
            msg +=Label.ASI_CRM_CN_PO_End_Date_Validation+'<br/>';// End Date should be the last day of the month .
            isProcess=false;
        }
        
        
        return isProcess;
    }
    
    
    // ******************PO Modification Process ******************
    Public void POModificationProcess1(ASI_TH_CRM_Contract__c Contract){
        
        // Date TempStartDate=ContractSelected.ASI_CRM_CN_PO_Start_Date__c;
        //Date TempEndDate=ContractSelected.ASI_CRM_CN_PO_End_Date__c;
        
        //ContractSelected.ASI_CRM_CN_PO_Start_Date__c=StartDate;
        //ContractSelected.ASI_CRM_CN_PO_End_Date__c=EndDate;
        
        
        ASI_TH_CRM_Contract__c ContractCloned  = ASI_CRM_CN_HeavyContractUtilitiesClass.ArchivePO(Contract);
        
        Contract.ASI_CRM_CN_Last_PO_version__c=ContractCloned.id;
        //ContractSelected.ASI_CRM_CN_PO_Start_Date__c=TempStartDate;
        //ContractSelected.ASI_CRM_CN_PO_End_Date__c=TempEndDate;
        
        Contract.ASI_CRM_CN_Status__c = 'Draft';
        Contract.ASI_TH_CRM_Start_Date__c = null;
        Contract.ASI_TH_CRM_End_Date__c = null;
        Contract.ASI_CRM_Reject_Return_Comments__c = '';
        Contract.ASI_CRM_CN_Return_Comments__c = '';
        Contract.ASI_CRM_CN_Last_Approved_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Approved_Date__c = NULL;
        Contract.ASI_CRM_CN_Last_Recall_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Recall_Date__c = NULL;
        Contract.ASI_CRM_CN_Last_Rejected_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Rejected_Date__c = NULL;
        Contract.ASI_CRM_CN_Last_Submitted_By__c = NULL;
        Contract.ASI_CRM_CN_Last_Submitted_Date__c = NULL;
        Contract.ASI_CRM_CN_Contract_Upload__c=true;
        Contract.ASI_CRM_Auto_PO_Modification_Time__c=null;
        Contract.ASI_CRM_Auto_PO_Modification__c=false;
        //update Contract;
        
        
        Contract.ASI_CRM_CN_PO_Modification__c = true;
        
        if(Contract.ASI_CRM_CN_PO_Version__c=='0.0'){
            Contract.ASI_CRM_CN_V0_0_PO_version__c=ContractCloned.id;
        }
        
        List<String> poVersionSplit = contract.ASI_CRM_CN_PO_Version__c.split('\\.',0);
        if(poVersionSplit != null && poVersionSplit.size() ==2){
            Contract.ASI_CRM_CN_PO_Version__c = poVersionSplit[0] + '.' + String.valueOf(Integer.valueOf(poVersionSplit[1])+1);
        }
        Contract.ASI_CRM_Copied_From__c=ContractCloned.Id; // Previous Contract
        system.debug('********************update Contract**********************');
        
        update Contract;
        
        system.debug('IsClon  :'+Contract.ASI_CRM_CN_IsClone__c);
        system.debug('Start_Date :'+Contract.ASI_CRM_CN_PO_Start_Date__c);
        system.debug('End_Date : '+Contract.ASI_CRM_CN_PO_End_Date__c);
        
        ASI_TH_CRM_Contract__c SelectContract= [select Id,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c,ASI_CRM_Copied_From__c,ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_CN_PO_Version__c,ASI_CRM_CN_Contract_Upload__c,ASI_CRM_V0_PSF_Contract_Total__c,ASI_CRM_CN_Expected_PSF_Est_Total__c,ASI_CRM_Expected_V0_PSF_Estimated_Total__c,ASI_CRM_Previous_Version_PSF_Est_Total__c,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,ASI_CRM_Expected_V0_0_VEC_Est_Total__c,ASI_CRM_Expected_V0_BRSF_Estimated_Total__c,ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,ASI_CRM_CN_Expected_BRSF_Est_Total__c,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grand_Estimate_Total__c
                                                from ASI_TH_CRM_Contract__c WHERE id =:pageId ];
        
        // if changing the 'start date' and 'end date', system will re-calculate the amount
        if( (StartDate!=Contract.ASI_CRM_CN_PO_Start_Date__c || EndDate != ContractSelected.ASI_CRM_CN_PO_End_Date__c)&& NoOfMonths !=integer.valueOf(SelectContract.ASI_CRM_CN_No_of_Months__c ) ){
            
            
            
            Boolean VECIsBySubBrand=false;
            //****Calculate v0.0 amount
            Decimal V0BRSFContractAmount=0;
            Decimal V0PSFContractAmount=0;
            Decimal V0PSFContractAmount_noSB=0;
            Decimal V0PSFEstimateAmount_noSB=0;
            Decimal V0VECContractAmount=0;
            
            Decimal V0BRSFEstimateAmount=0;
            Decimal V0PSFEstimateAmount=0;
            Decimal V0VECEstimateAmount=0;
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> V0ContractDetailLines =[SELECT Id,ASI_CRM_Module__c,ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Volume_Base__c ,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                                WHERE ASI_CRM_CN_Contract__c = :ContractSelected.ASI_CRM_CN_V0_0_PO_version__c] ;
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:V0ContractDetailLines){
                if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){// Volume base is by Sub-Brand
                    if(ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c !='999'){
                        if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                            V0BRSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                            V0BRSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }
                        if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                            V0PSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                            V0PSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }
                        if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                            VECIsBySubBrand=true;
                            V0VECContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                            
                        }
                    }
                }else{
                    if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                        V0PSFContractAmount_noSB+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                        V0PSFEstimateAmount_noSB+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    }
                }
                if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                    V0VECEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
            }
            
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> UpdatedDetailLines = new List<ASI_CRM_CN_Contract_BRSF_Line_Item__c>();
            //current version Contract Line
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractDetailLines =[SELECT Id,ASI_CRM_Adjustment_Line__c,ASI_CRM_Module__r.ASI_CRM_Created_PO_Version__c,ASI_CRM_Contract_Monthly_Volume_CR12__c,ASI_CRM_Est_Monthly_Volume_CR12__c,ASI_CRM_Est_Total_QTY_CR12_Eqv__c,ASI_CRM_Contract_Total_QTY_CR12_Eqv__c,ASI_CRM_Contract_Total_QTY_std_Btl__c,ASI_CRM_Est_Total_QTY_std_Btl__c,ASI_CRM_Module__c,ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Volume_Base__c ,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c 
                                                                              WHERE ASI_CRM_CN_Contract__c = :PageId] ;
            
            map<String, ASI_CRM_CN_EditHeavyContractDetailCtrl.interimData> ContractLineItem_Map = new map<String, ASI_CRM_CN_EditHeavyContractDetailCtrl.interimData> ();
            
            String BRSFModuleId= '';
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:ContractDetailLines){
                system.debug(ContractLine.ID+ 'Key Map : '+ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c );
                if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                    BRSFModuleId = ContractLine.ASI_CRM_Module__c;
                }
                //by Line Type(BRSF/PSF/VEC) + Module Id
                if(ContractLineItem_Map.containsKey(ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c)){
                    ContractLineItem_Map.get(ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c).DetailLineMap.put(ContractLine.Id,ContractLine);
                }else{//New 
                    ASI_CRM_Module__c TempModule= new ASI_CRM_Module__c(ASI_CRM_Volume_Base__c=ContractLine.ASI_CRM_Volume_Base__c,ASI_CRM_Line_Type__c=ContractLine.ASI_CRM_Type__c);
                    ASI_CRM_CN_EditHeavyContractDetailCtrl.interimData TempData= new ASI_CRM_CN_EditHeavyContractDetailCtrl.interimData(TempModule);
                    TempData.DetailLineMap.put(ContractLine.Id,ContractLine);
                    ContractLineItem_Map.put(ContractLine.ASI_CRM_Type__c+ContractLine.ASI_CRM_Module__c, TempData);
                    
                }
            }
            
            
            Decimal BRSFPreviousEstimateAmount=0;
            Decimal PSFPreviousEstimateAmount=0;
            Decimal VECPreviousEstimateAmount=0;
            
            Decimal BRSFContractAmount=0;
            Decimal PSFContractAmount=0;
            Decimal VECContractAmount=0;
            
            Decimal BRSFEstimateAmount=0;
            Decimal PSFEstimateAmount=0;
            Decimal VECEstimateAmount=0;
            Decimal DiffMonth = SelectContract.ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_No_of_Months__c-SelectContract.ASI_CRM_CN_No_of_Months__c;
            Id subbrand999 = [SELECT Id FROM ASI_MFM_Sub_brand__c WHERE ASI_MFM_Active_for_CRM__c = true  AND ASI_MFM_Sub_brand_Code__c = '999'  AND recordtypeid = :Global_RecordTypeCache.getRTid('ASI_MFM_Sub_brand__cASI_FOC_CN_Sub_brand') LIMIT 1].id;
            Id BRSFLineRtId =Global_RecordTypeCache.getRtId('ASI_CRM_CN_Contract_BRSF_Line_Item__cASI_CRM_CRM_CN_Contract_Heavy_BRSF');
            
            for(String HeaderKey:ContractLineItem_Map.keySet()){
                ASI_CRM_CN_Contract_BRSF_Line_Item__c AjustmentLine =new ASI_CRM_CN_Contract_BRSF_Line_Item__c(ASI_CRM_CN_Contract__c=pageId,ASI_CRM_Module__c=BRSFModuleId,
                                                                                                               ASI_CRM_Adjustment_Line__c=true,
                                                                                                               recordTypeId=BRSFLineRtId, ASI_CRM_CN_Sub_Brand__c = subbrand999,
                                                                                                               ASI_CRM_CN_Est_Monthly_Qty__c = 0,ASI_CRM_CN_Contract_Monthly_Qty__c=0,
                                                                                                               ASI_CRM_CN_Est_Total_Dummy__c=0,
                                                                                                               ASI_CRM_CN_Contract_Total_Dummy__c=0,
                                                                                                               ASI_CRM_CN_Est_BRSF_Per_Bottle__c=0,ASI_CRM_CN_Contract_BRSF_Per_Bottle__c=0);
                String CreatedModuleVersion ='';
                for(String keyline:ContractLineItem_Map.get(HeaderKey).DetailLineMap.keySet()){
                    ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine =ContractLineItem_Map.get(HeaderKey).DetailLineMap.get(keyline);
                    CreatedModuleVersion = ContractLine.ASI_CRM_Module__r.ASI_CRM_Created_PO_Version__c !=null ? ContractLine.ASI_CRM_Module__r.ASI_CRM_Created_PO_Version__c  : '';
                    if(ContractLine.ASI_CRM_CN_Sub_Brand__c!=null){// Volume base is by Sub-Brand
                        
                        if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                            BRSFPreviousEstimateAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }else if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                            PSFPreviousEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }else if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                            VECPreviousEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }
                        
                        
                        AjustmentLine.ASI_CRM_Type__c=ContractLine.ASI_CRM_Type__c!=null? ContractLine.ASI_CRM_Type__c : 'BRSF';
                        if(ContractLine.ASI_CRM_Module__c!=null){
                            AjustmentLine.ASI_CRM_Module__c = ContractLine.ASI_CRM_Module__c ;
                        }
                        
                        //if this contarct line is 999-line, save the id
                        if(ContractLine.ASI_CRM_Adjustment_Line__c || ContractLine.ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c =='999'){
                            AjustmentLine.Id=ContractLine.Id;
                        }else{//if this contarct line is not 999-line, perform calculation
                            ContractLine.ASI_CRM_CN_Est_Total_Dummy__c= ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c * ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                            ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c= ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                            
                            AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c += (ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c!=null )? ContractLine.ASI_CRM_CN_Contract_BRSF_Per_Bottle__c*  ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c*DiffMonth: 0;
                            AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c	 += (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c!=null && ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c!=null )? ContractLine.ASI_CRM_CN_Est_BRSF_Per_Bottle__c*  ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c*DiffMonth: 0;
                            
                            if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                                BRSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                                BRSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                                
                            }else if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                                PSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                                PSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                                
                            }else if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                                VECContractAmount+= ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                                VECEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                            }
                            UpdatedDetailLines.add(ContractLine);
                        }
                        
                        
                    }else{ // Not By SubBrand---> By Grade/Category/ Total
                        ContractLine.ASI_CRM_Contract_Total_QTY_std_Btl__c = (ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c==null) ? 0:ContractLine.ASI_CRM_CN_Contract_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                        ContractLine.ASI_CRM_Est_Total_QTY_std_Btl__c = (ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c==null) ? 0:ContractLine.ASI_CRM_CN_Est_Monthly_Qty__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                        ContractLine.ASI_CRM_Contract_Total_QTY_CR12_Eqv__c = (ContractLine.ASI_CRM_Contract_Monthly_Volume_CR12__c==null) ? 0:ContractLine.ASI_CRM_Contract_Monthly_Volume_CR12__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                        ContractLine.ASI_CRM_Est_Total_QTY_CR12_Eqv__c = (ContractLine.ASI_CRM_Est_Monthly_Volume_CR12__c==null) ? 0:ContractLine.ASI_CRM_Est_Monthly_Volume_CR12__c * SelectContract.ASI_CRM_CN_No_of_Months__c;
                        
                        UpdatedDetailLines.add(ContractLine);
                        
                        if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                            BRSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                            BRSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                            BRSFPreviousEstimateAmount += ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }else if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                            PSFPreviousEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0; 
                            PSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                            PSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }else if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                            VECContractAmount+= ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                            VECEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                            VECPreviousEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                        }
                    }
                }// end of looping this Module
                if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='BRSF'){
                    AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c = BRSFPreviousEstimateAmount-BRSFEstimateAmount; 
                }
                
                //checking if need to create/update 999-Line 
                if(AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c !=0 || AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c!=0){
                    if(CreatedModuleVersion!='0.0'){
                        AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c= 0 ;
                    }
                    
                    if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='BRSF'){
                        BRSFContractAmount+=AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c;
                        BRSFEstimateAmount+=AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c;
                        
                    }
                    if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='PSF' ){
                        PSFContractAmount+=AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c;
                        PSFEstimateAmount+=AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c;
                    }
                    
                    if(ContractLineItem_Map.get(HeaderKey).Module.ASI_CRM_Line_Type__c=='Variable Event Cost'){
                        VECContractAmount+=AjustmentLine.ASI_CRM_CN_Contract_Total_Dummy__c;
                        VECEstimateAmount+=AjustmentLine.ASI_CRM_CN_Est_Total_Dummy__c;
                    }
                    
                    system.debug('AjustmentLine: '+AjustmentLine.Id);
                    UpdatedDetailLines.add(AjustmentLine);
                }
                
                
                
                
            }//Ending of Contract Line looping
            
            if(SelectContract.ASI_CRM_CN_PO_Version__c!='0.1' && SelectContract.ASI_CRM_Copied_From__c!=null && SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c !=null){
                PSFPreviousEstimateAmount=SelectContract.ASI_CRM_Copied_From__r.ASI_CRM_CN_Expected_PSF_Est_Total__c;
            }
            
            
            ///**************************updating record **************************************************************
            if(UpdatedDetailLines.size()>0){
                upsert UpdatedDetailLines;
            }
            
            //BRSF
            SelectContract.ASI_CRM_CN_Expected_BRSF_Est_Total__c=BRSFPreviousEstimateAmount;
            SelectContract.ASI_CRM_Expected_V0_BRSF_Estimated_Total__c=V0BRSFEstimateAmount;
            
            //PSF
            
            SelectContract.ASI_CRM_Expected_V0_PSF_Estimated_Total__c=V0PSFEstimateAmount+V0PSFEstimateAmount_noSB;
            SelectContract.ASI_CRM_Previous_Version_PSF_Est_Total__c=PSFPreviousEstimateAmount;
            SelectContract.ASI_CRM_PSF_Estimate_Adjustment_Amount__c=0;
            SelectContract.ASI_CRM_CN_Expected_PSF_Est_Total__c=PSFPreviousEstimateAmount;
            
            SelectContract.ASI_CRM_PSF_Grand_Estimate_Total__c=PSFEstimateAmount+V0PSFEstimateAmount_noSB;
            SelectContract.ASI_CRM_PSF_Grand_Contract_Total__c=PSFContractAmount+V0PSFContractAmount_noSB;
            SelectContract.ASI_CRM_PSF_Contract_Adjustment_Amount__c=V0PSFContractAmount-PSFContractAmount;
            SelectContract.ASI_CRM_V0_PSF_Contract_Total__c=V0PSFContractAmount+V0PSFContractAmount_noSB;
            
            
            //VEC
            if(VECIsBySubBrand){
                if(SelectContract.ASI_CRM_CN_PO_Version__c!='0.1' ){
                    SelectContract.ASI_CRM_EVC_Cost_Estimate_Total__c= V0VECEstimateAmount;
                }else{
                    SelectContract.ASI_CRM_EVC_Cost_Estimate_Total__c=VECPreviousEstimateAmount;
                }
                
            }else{// is not by Sub-Brand
                SelectContract.ASI_CRM_EVC_Cost_Estimate_Total__c=VECPreviousEstimateAmount;
                
            }
            
            SelectContract.ASI_CRM_Expected_V0_0_VEC_Est_Total__c =V0VECEstimateAmount;
            
            
            update SelectContract;
            
            
            
            
            
            
            
        }else{
            Decimal BRSFContractAmount=0;
            Decimal PSFContractAmount=0;
            Decimal VECContractAmount=0;
            
            Decimal BRSFEstimateAmount=0;
            Decimal PSFEstimateAmount=0;
            Decimal VECEstimateAmount=0;
            List<ASI_CRM_CN_Contract_BRSF_Line_Item__c> ContractDetailLines =[SELECT Id,ASI_CRM_Module__c,ASI_CRM_Sub_Brand_Grade__c ,ASI_CRM_Volume_Base__c ,ASI_CRM_CN_Sub_Brand__r.ASI_MFM_Sub_brand_Code__c, ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__c,ASI_CRM_CN_Sub_Brand__r.ASI_CRM_CN_Sub_brand_Grade__r.Name,ASI_CRM_CN_Contract__c,ASI_CRM_Type__c, ASI_CRM_Key_Sub_brand__c, ASI_CRM_CN_Sub_Brand__r.Name, ASI_CRM_CN_Contract_BRSF_Per_Bottle__c, ASI_CRM_CN_Contract_Monthly_Qty__c, ASI_CRM_CN_Contract_Total__c, ASI_CRM_CN_Est_BRSF_Per_Bottle__c, ASI_CRM_CN_Est_Monthly_Qty__c, ASI_CRM_CN_Est_Total__c, ASI_CRM_CN_Sub_Brand__c, ASI_CRM_CN_Contract_Total_Dummy__c, ASI_CRM_CN_Est_Total_Dummy__c, ASI_CRM_CN_No_of_Months__c, ASI_CRM_CN_Activity_Code__c FROM ASI_CRM_CN_Contract_BRSF_Line_Item__c WHERE ASI_CRM_CN_Contract__c = :PageId] ;
            for(ASI_CRM_CN_Contract_BRSF_Line_Item__c ContractLine:ContractDetailLines){
                
                if(ContractLine.ASI_CRM_Type__c=='BRSF'){
                    BRSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                    BRSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
                
                if(ContractLine.ASI_CRM_Type__c=='PSF' ){
                    PSFContractAmount+=ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Contract_Total_Dummy__c:0;
                    PSFEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
                
                if(ContractLine.ASI_CRM_Type__c=='Variable Event Cost'){
                    VECContractAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                    VECEstimateAmount+= ContractLine.ASI_CRM_CN_Est_Total_Dummy__c!=null?ContractLine.ASI_CRM_CN_Est_Total_Dummy__c:0;
                }
            } 
            
            if(SelectContract.ASI_CRM_CN_PO_Version__c=='0.1' ){
                //BRSF
                SelectContract.ASI_CRM_CN_Expected_BRSF_Est_Total__c=BRSFEstimateAmount;
                SelectContract.ASI_CRM_Expected_V0_BRSF_Estimated_Total__c=BRSFEstimateAmount;
                
                //PSF
                SelectContract.ASI_CRM_PSF_Grand_Estimate_Total__c=PSFEstimateAmount;
                SelectContract.ASI_CRM_Previous_Version_PSF_Est_Total__c=PSFEstimateAmount;
                SelectContract.ASI_CRM_PSF_Estimate_Adjustment_Amount__c=0;
                SelectContract.ASI_CRM_CN_Expected_PSF_Est_Total__c=PSFEstimateAmount;
                SelectContract.ASI_CRM_Expected_V0_PSF_Estimated_Total__c=PSFEstimateAmount;
                SelectContract.ASI_CRM_PSF_Grand_Contract_Total__c=PSFContractAmount;
                SelectContract.ASI_CRM_V0_PSF_Contract_Total__c=PSFContractAmount;
                
                
                //VEC
                SelectContract.ASI_CRM_Expected_V0_0_VEC_Est_Total__c =VECEstimateAmount;
                SelectContract.ASI_CRM_EVC_Cost_Estimate_Total__c=VECEstimateAmount;
                
            }else{
                SelectContract.ASI_CRM_PSF_Estimate_Adjustment_Amount__c=0;
                SelectContract.ASI_CRM_Previous_Version_PSF_Est_Total__c=SelectContract.ASI_CRM_CN_Expected_PSF_Est_Total__c; 
            }
            
            
            
            
            update SelectContract;  
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //Cancel the record 
    public PageReference CancelProcess(){
        PageReference pageRef = null;
        pageRef = new PageReference('/'+PageId);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
}