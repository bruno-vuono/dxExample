public without sharing class ASI_CRM_CN_TOV_PDF_Controller {
    public Boolean dummyVar { get { if (dummyVar != true) {dummyVar = init();} return dummyVar; } set; }
    public String currentHeaderID {set;get;}
    public List<ASI_FOC_Request_Item__c> lineItemFGR{get;set;}
    public ASI_CRM_TOV__c TOCurrent{get;set;}
    public list<ASI_CRM_TOV_Detail__c> lineItem{get;set;}
    Public Double totalQty {get;set;}
    public boolean init(){
        {
            TOCurrent = [select id
                         ,ASI_CRM_Customer_Code__c
                         ,ASI_CRM_SO_Number__c
                         ,ASI_CRM_Order_Date__c
                         ,ASI_CRM_SF_SO_Request_Number__r.name
                         ,ASI_CRM_SF_SO_Request_Number__r.ASI_CRM_CN_Address__c
                         ,ASI_CRM_SF_SO_Request_Number__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_Legal_Name__c
                         ,ASI_CRM_SF_SO_Request_Number__r.ASI_CRM_CN_Customer__r.ASI_CRM_CN_CRM_Code__c
                         ,ASI_CRM_SF_SO_Request_Number__r.ASI_CRM_CN_Tel_Mobile__c
                         ,ASI_CRM_SF_SO_Request_Number__r.ASI_CRM_SG_Order_Date__c
                         ,ASI_CRM_SF_SO_Request_Number__r.ASI_CRM_CN_Other_Requirement__c
                         ,ASI_CRM_Free_Goods_Request__r.name
                         ,ASI_CRM_Free_Goods_Request__r.ASI_FOC_Receiptor_Name__c
                         ,ASI_CRM_Free_Goods_Request__r.ASI_FOC_Deliver_to_Address_Line_1__c
                         ,ASI_CRM_Free_Goods_Request__r.ASI_FOC_Date_of_Delivery__c
                         ,ASI_CRM_Free_Goods_Request__r.ASI_FOC_Receiptor_Mobile__c
                         from ASI_CRM_TOV__c 
                         where id = : currentHeaderID
                        ]; 
            lineItem = new list<ASI_CRM_TOV_Detail__c>();
            lineItem = [select id,ASI_CRM_SKU__c
                        ,ASI_CRM_Order_QTY__c
                        ,ASI_CRM_UOM__c 
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_pack__c
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.name
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Pack_Value__c
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_BT_Size_C__c
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.ASI_MFM_Item_Group_Code__c
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Chinese_Name__c
                        ,ASI_CRM_SF_SO_Request_Line_Number__r.ASI_CRM_CN_Product_Name__r.ASI_CRM_CN_Eng_Name__c
                        ,ASI_CRM_SF_FOC_Request_Line_Number__r.ASI_FOC_CN_Packing_Description__c
                        ,ASI_CRM_SF_FOC_Request_Line_Number__r.ASI_FOC_SKU_Chinese_Description__c
                        ,ASI_CRM_SF_FOC_Request_Line_Number__r.ASI_FOC_SKU__r.Name
                        ,ASI_CRM_Item_Group__c
                        ,ASI_CRM_Pack_Description__c
                        ,ASI_CRM_SKU_Description__c
                        from ASI_CRM_TOV_Detail__c 
                        where ASI_CRM_TOV__c = : currentHeaderID];   
            
            for(ASI_CRM_TOV_Detail__c obj : lineItem){
                if(totalQty == NULL)
                    totalQty = 0;
                if(obj.ASI_CRM_Order_QTY__c != NULL)
                    totalQty += obj.ASI_CRM_Order_QTY__c;
            }
            return true;
        }
    }
}