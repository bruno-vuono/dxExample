/*********************************************************************************
 * Name: ASI_CRM_SG_PromotionPlanEnrollCust_Ctrl
 * Description: Controller class for showing all enrolled outlet (ASI_CRM_SG_PromotionPlanEnrollCust_Page)
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 25/04/2018       Hugo Cheung             Created          
*/
public class ASI_CRM_SG_PromotionPlanEnrollCust_Ctrl {
    
    private final static String REJECTED = 'Rejected';
	private final static String RECORDTYPEID_PROMOTIONREADONLY = Global_RecordTypeCache.getRTId('ASI_HK_CRM_Promotion__cASI_CRM_SG_Ad_hoc_Trade_Promotion_Read_Only');
    
    public Map<String, String> outletIdNameMap {get; set;}
    
    public ASI_CRM_SG_PromotionPlanEnrollCust_Ctrl(ApexPages.StandardController standardController) {
        String promotionPlanId = ApexPages.currentPage().getParameters().get('id');
        init(promotionPlanId);
    }
    
    //Initialize controller
    private void init(String promotionPlanId) {
        if(String.isBlank(promotionPlanId)) return;
        
        outletIdNameMap = new Map<String, String>();
        for(ASI_HK_CRM_Promotion_Detail__c promotionDetail : retrievePromotionDetailList(promotionPlanId)) {
        	if(promotionDetail.ASI_HK_CRM_Promotion__r.recordtypeId == RECORDTYPEID_PROMOTIONREADONLY &&
              promotionDetail.ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Status__c == REJECTED
              ) continue;
            outletIdNameMap.put(promotionDetail.ASI_CRM_SG_Customer__c, promotionDetail.ASI_CRM_SG_Customer__r.Name);
        }
    }
    
    /***************
    Data Retrievement Function
    ***************/
    private List<ASI_HK_CRM_Promotion_Detail__c> retrievePromotionDetailList(Id promotionPlanId) {
    	String query = 'SELECT Id, ASI_CRM_SG_Customer__r.Name, ASI_CRM_SG_Customer__c, '
            		 + 'ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Status__c, ASI_HK_CRM_Promotion__r.recordtypeid '
                     + 'FROM ASI_HK_CRM_Promotion_Detail__c ' 
                     + 'WHERE ASI_HK_CRM_Promotion__r.ASI_CRM_Promotion_Plan__c = :promotionPlanId ';
        
        return (List<ASI_HK_CRM_Promotion_Detail__c>) Database.query(query);
    }
}