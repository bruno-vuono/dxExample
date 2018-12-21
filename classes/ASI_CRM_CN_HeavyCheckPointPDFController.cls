/* Filename  :  ASI_CRM_CN_HeavyCheckPointPDFController.cls
* Author     :  Laputa
* Purpose    :  Controller for Check Point PDF Page (ASI_CRM_CN_HeavyCheckPointPDF, ASI_CRM_CN_HeavyCheckPointPDFComponent)
* History
* -----------------------------------------------------------------------------
* 2017-09-04   Laputa      Created

*/
public class ASI_CRM_CN_HeavyCheckPointPDFController {
    
    public ASI_CRM_CN_HeavyCheckPointPDFController(ApexPages.StandardController controller) {
        String recordId = ((ASI_TH_CRM_Contract__c)controller.getRecord()).Id;
    }
    public id currentHeaderId {set;get;}
    public boolean showCN {set;get;}
    public List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData> SuccessCheckPointList {set;get;}  {SuccessCheckPointList = new List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData>();}
    public List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData> FailedCheckPointList {set;get;} {FailedCheckPointList = new List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData>();}
    public boolean AdorAbove {set;get;}{AdorAbove=false;}
    public ASI_TH_CRM_Contract__c ContractSelected {set;get;}
    
    public ASI_CRM_CN_HeavyCheckPointPDFController(){ }
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    
    public Boolean DisplaySuccessCheckPointPart {get;set;}{DisplaySuccessCheckPointPart=true;}
    public Boolean DisplayFailedCheckPointPart {get;set;}{DisplayFailedCheckPointPart=true;}
    
    
    
    public boolean init(){
        
        showCN = USerInfo.getLanguage()=='zh_CN';
        this.ContractSelected = [SELECT Name,Owner.Name,ASI_CRM_RVP_Approval__c,ASI_CRM_CN_Outlet_WS__r.Name,ASI_CRM_PSF_Grand_Contract_Total__c,ASI_CRM_PSFGrand_ContractTotal_BeforeAdj__c,ASI_CRM_PSF_Contract_Adjustment_Amount__c,ASI_CRM_PSF_Estimate_Adjustment_Amount__c,ASI_CRM_Investment_Type__c,ASI_TH_CRM_Summary_Contract_Spending__c, ASI_CRM_CN_Total_Contract_Amount__c ,ASI_CRM_EVC_Cost_Estimate_Total__c,ASI_CRM_PSF_Grd_Est_Total_before_Adj__c,ASI_CRM_PSF_Grand_Estimate_Total__c,ASI_CRM_CN_Vol_Budget_LE__c, ASI_CRM_CN_Status__c, ASI_CRM_CN_Source_of_Contract__c,ASI_CRM_CN_Source_Others__c,
                                 ASI_CRM_CN_Reason_without_Budget__c, ASI_TH_CRM_Promotion_Type__c, ASI_CRM_CN_PP_No__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c, ASI_CRM_CN_PO_No__c, ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Outlet_WS__c, 
                                 ASI_CRM_CN_Exchange_Rate__c, ASI_CRM_CN_Expected_BRSF_Est_Total__c ,   ASI_CRM_CN_Description__c, ASI_CRM_CN_Currency__c, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Bottle_Collection_Rate__c, ASI_CRM_CN_Effective_Date__c,
                                 recordtypeid, ASI_CRM_CN_No_of_Months__c , ASI_CRM_CN_PO_Modification__c , ASI_CRM_CN_Special_Promotion__c, ASI_CRM_CN_Contract_Upload__c,  ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_National_Group_Contract__c,ASI_CRM_CN_Business_License__c, createddate, ASI_CRM_CN_Outlet_WS__r.RecordType.DeveloperName, ASI_CRM_Volume_Option__c, lastModifiedDate, ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c, 
                                 ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__r.Name, ASI_CRM_PO_City__c, ASI_CRM_PO_City__r.Name,ASI_CRM_National_Group__c, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__c,
                                 ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_PO_version__r.ASI_CRM_National_Group__r.Name, ASI_CRM_CN_Last_Submitted_Date__c, ASI_CRM_CN_Last_Rejected_Date__c,
                                 (Select Id, Name, ASI_CRM_CN_Last_Payment__c, ASI_TH_CRM_Contract__c,ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_PO_End_Date__c,ASI_TH_CRM_Status__c,ASI_CRM_CN_Channel__c, ASI_CRM_CN_Total_Payment__c,ASI_CRM_CN_Paid__c,ASI_CRM_CN_Paid_In_Progress__c, ASI_CRM_CN_Payment_Raised_Date__c From ASI_TH_CRM_PaymentRequests_Contract__r)                       
                                 FROM ASI_TH_CRM_Contract__c
                                 WHERE id =:currentHeaderId ];
        checkApprover();
        //Geting check point Data
        List<ASI_Attachment__c> AttachmentList= [select id,ASI_CRM_Historical_Financial_Data__c,ASI_CRM_Contract__c,ASI_CRM_Type__c from ASI_Attachment__c where ASI_CRM_Contract__c = :ContractSelected.Id ];
        if(AttachmentList.size()>0){
            for(ASI_Attachment__c att:AttachmentList){ 
                String JsonString = att.ASI_CRM_Historical_Financial_Data__c.replaceAll('&quot;','"');
                if(att.ASI_CRM_Type__c=='CheckPoint-Success'){
                    JsonString = JsonString.replaceAll('&lt;','<');
                    JsonString = JsonString.replaceAll('&gt;','>');
                    system.debug(att.ASI_CRM_Type__c+'Now JsonString '+JsonString );
                    List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData> CheckPointResultList =(List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData>.class);
                    
                    SuccessCheckPointList=CheckPointResultList;
                }else if(att.ASI_CRM_Type__c=='CheckPoint-Failed'){
                    JsonString = JsonString.replaceAll('&lt;','<');
                    JsonString = JsonString.replaceAll('&gt;','>');
                    system.debug(att.ASI_CRM_Type__c+'Now JsonString '+JsonString );
                    List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData> CheckPointResultList =(List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData>)System.JSON.deserialize(JsonString,List<ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData>.class);
                    
                    FailedCheckPointList=CheckPointResultList;
                }
            }
        }
             
        if(FailedCheckPointList.size()==0){
            DisplayFailedCheckPointPart=false;
        }else{
            for(ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData TempinterimData:FailedCheckPointList){
                if(TempinterimData.SegmentationCriteria.ASI_CRM_Financial_Indicator__c.contains('ROI') && !AdorAbove){
                    TempinterimData.DisplayToUser=false;
                }else{
                    TempinterimData.DisplayToUser=true;
                }
            }
        }
        
        if(SuccessCheckPointList.size()==0){
            DisplaySuccessCheckPointPart=false;
        }else{
            for(ASI_CRM_CN_HeavyCheckPointResultCtrl.interimData TempinterimData:SuccessCheckPointList){
                if(TempinterimData.SegmentationCriteria.ASI_CRM_Financial_Indicator__c.contains('ROI') && !AdorAbove){
                    TempinterimData.DisplayToUser=false;
                }else{
                    TempinterimData.DisplayToUser=true;
                }
            }
        }
        
        Return true;
    }
    
     public void checkApprover(){
        AdorAbove = false;
        set<Id> actorIds = new set<Id>();
        for(ProcessInstanceWorkitem piw :[SELECT ActorId FROM ProcessInstanceWorkitem WHERE processinstance.status = 'Pending' AND processinstance.targetobjectid = : ContractSelected.id]){
            actorIds.add(piw.ActorId);
        }
        list<GroupMember> gms = [SELECT Id FROM GroupMember WHERE Group.DeveloperName='ASI_CRM_CN_AD_or_Above' AND UserOrGroupId in :actorIds];
        if(gms.size()>0)
            AdorAbove = true;
    }
    
    
}