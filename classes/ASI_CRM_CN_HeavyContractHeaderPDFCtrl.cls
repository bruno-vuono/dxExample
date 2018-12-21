public class ASI_CRM_CN_HeavyContractHeaderPDFCtrl {
    public String PageId {set;get;}
    
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public ASI_TH_CRM_Contract__c thisCC {set;get;}
    
    
    public ASI_CRM_CN_HeavyContractHeaderPDFCtrl(ApexPages.StandardController controller) {
        PageId = ApexPages.currentPage().getParameters().get('id');
        
    }
    
    public ASI_CRM_CN_HeavyContractHeaderPDFCtrl(){}
    
    
    public boolean init(){
     
        if (PageId != null){
            try{
                thisCC = [SELECT id, Name, ASI_CRM_CN_Budget_LE__c, ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c, ASI_CRM_CN_Vol_Budget_LE__c,ASI_CRM_CN_PO_Modification__c,ASI_CRM_CN_Contract_Est_Var_Cost_Total__c, ASI_CRM_CN_Contract_Estimate_Cost_Total__c,ASI_CRM_CN_Outlet_WS__c, ASI_CRM_CN_PO_Version__c, ASI_CRM_CN_PO_Start_Date__c,  ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_PO_No__c, ASI_TH_CRM_Promotion_Type__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Grade__c,ASI_CRM_CN_BRSF_Contract_Total__c, ASI_CRM_CN_Contract_Cost_Total__c, ASI_CRM_CN_Contract_Fixed_Cost_Total__c,ASI_CRM_CN_Contract_Variable_Cost_Total__c,ASI_CRM_CN_No_of_Months__c,ASI_CRM_CN_Outlet_WS__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Eng_Name__c, ASI_CRM_CN_Outlet_WS__r.ASI_TH_CRM_OutletType__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sales_Rep__r.Name,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Image__c,ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Region__r.Name, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__c,ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Description__c,  ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_Sub_Channel__r.Name,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_PO_End_Date__c, ASI_CRM_CN_Last_PO_version__c, ASI_CRM_CN_V0_0_PO_version__r.ASI_CRM_CN_Total_Contract_Amount__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_Start_Date__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_PO_End_Date__c,ASI_CRM_CN_V0_0_PO_version__c, Owner.Name,ASI_CRM_CN_Status__c , ASI_CRM_Volume_Option__c,ASI_CRM_CN_Last_PO_version__r.ASI_CRM_CN_Contract_Est_Fixed_Cost_Total__c,ASI_CRM_CN_Bottle_Collection_Rate__c,ASI_CRM_New_FY_PO__c, ASI_CRM_PO_Channel__c, ASI_CRM_PO_Province__c,ASI_CRM_PO_Channel__r.Name, ASI_CRM_PO_Province__r.Name,ASI_CRM_PO_City__c,ASI_CRM_PO_City__r.Name ,ASI_CRM_PO_City__r.ASI_CRM_CN_City_Tier__c, ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_NewChannel__c
                          FROM ASI_TH_CRM_Contract__c WHERE id = :PageId];
            }catch(exception e){ASI_MFM_ByPass_Setting.ErrorHandling('ASI_CRM_CN_HeavyContractHeaderPDFCtrl in init class have Error  '+e.getMessage(),'ASI_CRM_CN_HeavyContractHeaderPDFCtrl','PDF function failed! with contract Id: '+PageId );
            }
        }
        
        
     return true;   
    }
}