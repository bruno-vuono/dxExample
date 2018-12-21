/*********************************************************************************
 * Name:ASI_CRM_SG_PromotionLetterPDF_Ctrl
 * Description: Controller for promotion letter PDF (ASI_CRM_SG_PromotionLetterPDF_Com)
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 04/04/2018       Hugo Cheung             Created
*********************************************************************************/
public class ASI_CRM_SG_PromotionLetterPDF_Ctrl {
    
    //Component Parameters
    public String promotionId        {get; set;}
    public String customerId         {get; set;}
    public String contactName        {get; set;}
    public String contactDesignation {get; set;}
    public String contactNumber      {get; set;}
    
    //Public Data Storage Parameters
    public ASI_CRM_AccountsAdditionalField__c customer               {get; set;}
    public ASI_HK_CRM_Promotion__c promotion                         {get; set;}
    public List<ASI_CRM_Promotion_Mechanic__c> promotionMechanicList {get; set;}
    public List<ASI_HK_CRM_Promotion_Detail__c> promotionDetailList {get; set;}
    
    //Page parameter
    public Boolean isPageInit { get { if(isPageInit != true) {isPageInit = init();} return isPageInit;} set;}
    
    public ASI_CRM_SG_PromotionLetterPDF_Ctrl() {
    }
    
    public Boolean init() {
        customer  = retrieveCustomer(customerId);
        promotion = retrievePromotion(promotionId);
        promotionMechanicList = retrievePromotionMechanicList(promotion.ASI_CRM_Promotion_Plan__c);
        promotionDetailList = retrievePromotionDetailList(promotionId, customerId);
    	return true;
    }
    
    /***************
    Data Retrievement Function
    ***************/
    private ASI_CRM_AccountsAdditionalField__c retrieveCustomer(Id customerId) {
    	String query = 'SELECT Id, ASI_CRM_Legal_Outlet_Name__c, ASI_CRM_Business_Registration_Number__c '
                     + ', ASI_CRM_JP_City_Ward__c, ASI_CRM_JP_Town__c, ASI_CRM_Street_Number__c '
                     + 'FROM ASI_CRM_AccountsAdditionalField__c '
                     + 'WHERE Id = :customerId ';
       	
        List<ASI_CRM_AccountsAdditionalField__c> customerList = (List<ASI_CRM_AccountsAdditionalField__c>) Database.query(query);
        return customerList.size() > 0 ? customerList.get(0) : null;
    }
    
    private ASI_HK_CRM_Promotion__c retrievePromotion(Id promotionId) {
    	String query = 'SELECT Id, ASI_CRM_Promotion_Plan__c, ASI_CRM_Promotion_Plan__r.Name, '
                     + 'ASI_CRM_Promotion_Plan__r.ASI_CRM_Start_Date__c, ASI_CRM_Promotion_Plan__r.ASI_CRM_End_Date__c '
                     + 'FROM ASI_HK_CRM_Promotion__c '
                     + 'WHERE Id = :promotionId ';
        
        List<ASI_HK_CRM_Promotion__c> promotionPlanList = (List<ASI_HK_CRM_Promotion__c>) Database.query(query);
        return promotionPlanList.size() > 0 ? promotionPlanList.get(0) : null;
    }
    
    private List<ASI_CRM_Promotion_Mechanic__c> retrievePromotionMechanicList(Id promotionPlanId) {
        String query = 'SELECT Id, ASI_CRM_Target_Qty_Bottle__c, ASI_CRM_Buy_Qty__c, ASI_CRM_Buy_Unit__c, ASI_CRM_Additional_SKU_POSM__c, '
                     + 'ASI_CRM_Promotional_SKU__r.ASI_CRM_Short_Description__c, ASI_CRM_Trade_Deal_Bottle_Qty__c, '
                     + 'ASI_CRM_Additional_SKU_Bottle_Qty__c, ASI_CRM_Additional_SKU_POSM__r.ASI_CRM_Short_Description__c, '
                     + 'ASI_CRM_Ad_hoc_Cash__c, '
                     + 'ASI_CRM_Gift_Voucher__r.ASI_CRM_Short_Description__c, ASI_CRM_Gift_Voucher__r.Name, '
                     + 'ASI_CRM_Other_in_Kind_Cash__c '
                     + 'FROM ASI_CRM_Promotion_Mechanic__c '
                     + 'WHERE ASI_CRM_Promotion_Plan__c = :promotionPlanId ';
        
        return (List<ASI_CRM_Promotion_Mechanic__c>) Database.query(query);
    }
    
    private List<ASI_HK_CRM_Promotion_Detail__c> retrievePromotionDetailList(Id promotionId, Id customerId) {
        String query = 'SELECT Id, ASI_CRM_Target_Qty_Bottle__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_Qty__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Buy_Unit__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__c, '
                     + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.ASI_CRM_Short_Description__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Trade_Deal_Bottle_Qty__c, '
                     + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_Bottle_Qty__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__r.ASI_CRM_Short_Description__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__r.ASI_HK_CRM_IsPOSProduct__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.ASI_HK_CRM_Packaging_Size__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.ASI_HK_CRM_Std_Bottle_Size__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Promotional_SKU__r.ASI_MFM_Sub_brand__r.ASI_MFM_Sub_brand_Description__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__r.ASI_HK_CRM_Packaging_Size__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__r.ASI_HK_CRM_Std_Bottle_Size__c, '
            		 + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Additional_SKU_POSM__r.ASI_MFM_Sub_brand__r.ASI_MFM_Sub_brand_Description__c, '
                     + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Ad_hoc_Cash__c, '
                     + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__r.ASI_CRM_Short_Description__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Gift_Voucher__r.Name, '
                     + 'ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Other_in_Kind_Cash__c, ASI_CRM_Promotion_Mechanic__r.ASI_CRM_Remark__c '
                     + 'FROM ASI_HK_CRM_Promotion_Detail__c '
                     + 'WHERE ASI_HK_CRM_Promotion__c = :promotionId '
                     + 'AND ASI_CRM_SG_Customer__c = :customerId ';
        
        return (List<ASI_HK_CRM_Promotion_Detail__c>) Database.query(query);
    }
}