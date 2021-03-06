public  with sharing  class ASI_MFM_TH_PO_PDF_PageController {
     public ASI_MFM_TH_PO_PDF_PageController(ApexPages.StandardController controller) {
            this.poCurrent = (ASI_MFM_PO__c)controller.getRecord();
         
    }
    public id POID {set;get;}
    public String Year {set;get;}
    public ASI_MFM_PO__c poCurrent{get;set;}

   
    public ASI_MFM_Plan__c plan{get;set;}
    public List<ASI_MFM_PO_Line_Item__c> lineItem{get;set;}
    
    private final String object_ApiName = 'ASI_MFM_PO__c';
     // a dummy variable to invoke init() method
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }


    public ASI_MFM_TH_PO_PDF_PageController(){
      
    }
    
    public boolean init(){
        //try{
        //this.Po = (ASI_MFM_PO__c)stdController.getRecord();
        
        lineItem = new List<ASI_MFM_PO_Line_Item__c>();
   
        
        poCurrent = [select Name,ASI_MFM_Payment_Terms__c,ASI_MFM_Is_FOC_PO__c,ASI_MFM_Plan__r.ASI_MFM_Objectives_Quantified__c,ASI_MFM_Checked_By__r.name,Owner.name,ASI_MFM_Plan__r.name,ASI_MFM_Remarks__c, ASI_MFM_Supplier_Name__c,ASI_MFM_Plan__c,ASI_MFM_GL_Date__c ,ASI_MFM_PO_Start_Date__c,ASI_MFM_PO_End_Date__c
        ,ASI_MFM_PO_Raised_Date__c, ASI_MFM_Supplier_Fax_Number__c,ASI_MFM_Ship_to_Address__c,ASI_MFM_Responsible_By__r.Name,ASI_MFM_Responsible_By__r.ASI_TnE_Sub_Ledger__c, ASI_MFM_PO_Date_Range__r.Name, ASI_MFM_PO_Date_Range__r.ASI_MFM_Fiscal_Period__c,
        ASI_MFM_Supplier_Name__r.Name,ASI_MFM_Supplier_Phone_Number__c,ASI_MFM_Currency__c,ASI_MFM_PO_Amount__c,ASI_MFM_Subledger__c,ASI_MFM_Previous_Approved_By__r.Name,ASI_MFM_Previous_Approved_At__c,ASI_MFM_Previous_Approved_Amount__c,
            ASI_MFM_Payment_Date__c,ASI_MFM_Status__c,ASI_MFM_Supplier_Address_Line_1__c,ASI_MFM_Supplier_Address_Line_2__c ,ASI_MFM_Supplier_Address_Line_3__c,ASI_MFM_Supplier_Address_Line_4__c,ASI_MFM_Market__c,ASI_MFM_Sys_Plan_Name__c,
                     ASI_MFM_SG_Customer__c,ASI_MFM_Reference_1__c,ASI_MFM_Reference_2__c,ASI_MFM_SG_Delivery_To__c,ASI_MFM_Sys_Plan_Amount__c,CreatedBy.name,ASI_MFM_TH_PO_Total_Amount_in_Thai__c,
                     ASI_MFM_Plan_Balance__c,CreatedDate,ASI_MFM_Plan__r.ASI_MFM_TH_Department__c,ASI_MFM_Delivery_date__c,ASI_MFM_VAT__c,ASI_MFM_TH_PO_Total_Amount__c,ASI_MFM_TH_PO_Discount__c,ASI_MFM_SG_Customer__r.name,ASI_MFM_Payment_Term__c 
           from ASI_MFM_PO__c where id =: POID];
        System.debug('POId ' + POID);
        if (poCurrent.ASI_MFM_VAT__c==null)
        {
            poCurrent.ASI_MFM_VAT__c = 0;
        }
        ASI_MFM_ApprovalHistoryHelper appHistHelper = new ASI_MFM_ApprovalHistoryHelper (object_ApiName , POID );
        
        if(poCurrent.ASI_MFM_Plan__c != null){
            plan = [select id,Name,ASI_MFM_Plan_Description__c,ASI_MFM_Fiscal_year__c,
            owner.name from ASI_MFM_Plan__c where id =: poCurrent.ASI_MFM_Plan__c ]; 
            Year=plan.ASI_MFM_Fiscal_year__c.substring(4,6);
        }
        else{
            plan = new ASI_MFM_Plan__c();
            plan.Name = '';
            plan.ASI_MFM_Plan_Description__c = '';
        }
        List<ASI_MFM_PO_Line_Item__c> lineItemList = [select name,ASI_MFM_Print_Sequence__c, ASI_MFM_List_Item_Description__c,ASI_MFM_UOM__c,ASI_MFM_Unit_Price__c,ASI_MFM_Quantity__c,
        ASI_MFM_Amount__c,ASI_MFM_SKU_Code__r.Name, ASI_MFM_SKU_Code__r.ASI_MFM_SKU_Code__c ,ASI_MFM_AP_Code__r.Name,ASI_MFM_AP_Code__r.ASI_MFM_AP_Code__c,
        ASI_MFM_A_C_Code__r.ASI_MFM_A_C_Code__c,ASI_MFM_A_C_Code__r.ASI_MFM_A_C_Description__c, ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.Name, ASI_MFM_Sub_brand_Code__r.ASI_MFM_Sub_brand_Code__c ,
        ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c, ASI_MFM_BU_Code__r.ASI_MFM_L1__c,ASI_MFM_TH_Unit__c
        from ASI_MFM_PO_Line_Item__c where ASI_MFM_PO__c =: POID order by ASI_MFM_Print_Sequence__c,name];
        Integer lineNum = 1;
        for(ASI_MFM_PO_Line_Item__c poli : lineItemList){
            if(poli.ASI_MFM_Quantity__c == null){
                poli.ASI_MFM_Quantity__c = 0;
            }
            if(poli.ASI_MFM_Unit_Price__c == null){
                poli.ASI_MFM_Unit_Price__c = 0;
            }
            if(poli.ASI_MFM_Amount__c == null){
                poli.ASI_MFM_Amount__c = 0;
            }
            poli.ASI_MFM_Print_Sequence__c = lineNum ;
            lineNum ++ ;
            lineItem.add(poli);
        }
        if (lineNum < 15){ //25
            for (Integer i = lineNum; i <= 15; i++){ //25
                lineItem.add(new ASI_MFM_PO_Line_Item__c());
            }
        }
        //catch(exception e){e.getMessage();}
        return true;
    }

    

    
}