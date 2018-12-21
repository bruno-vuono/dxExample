/*********************************************************************************
 * Name:ASI_CRM_SG_PromotionLetterSelection_Ctrl
 * Description: Controller for select the promotion's outlet (ASI_CRM_SG_PromotionLetterSelection_Page)
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 04/04/2018       Hugo Cheung             Created
*********************************************************************************/
public class ASI_CRM_SG_PromotionLetterSelection_Ctrl {
    //Public Data Storage Parameters
    public ASI_HK_CRM_Promotion__c promotion {get; set;}
    public Map<String, Id> customerNameMap {get; set;}
    
    //Private Data Storage Parameters
    private Map<Id, Contact> customerContactMap;
    
    //Data Stroage => JSON String for VF Page
    public String customerContactMapJson {get {return toJsonString(customerContactMap);}}
    
    //Other Parameters
    private final static String CUSTOMER_ID         = 'customerId';
    private final static String CONTACT_NAME        = 'contactName';
    private final static String CONTACT_DESIGNATION = 'contactDesignation';
    private final static String CONTACT_NUMBER      = 'contactNumber';
    private final static String PDF_PAGE_NAME       = 'ASI_CRM_SG_PromotionLetter_Page';
    
    public ASI_CRM_SG_PromotionLetterSelection_Ctrl(ApexPages.StandardController standardController) {
        String promotionId = ApexPages.currentPage().getParameters().get('id');
        init(promotionId);
    }
    
    //Initialize controller
    private void init(String promotionId) {
        if(String.isBlank(promotionId)) return;
        
        //Init Record
        promotion = retrievePromotion(promotionId);
        customerNameMap = new Map<String, Id>();
        customerContactMap = new Map<Id, Contact>();
        
        Set<Id> customerIdSet = new Set<Id>();
        for(ASI_HK_CRM_Promotion_Detail__c promotionDetail : retrievePromotionDetailList(promotionId)) {
            customerNameMap.put(promotionDetail.ASI_CRM_SG_Customer__r.Name, promotionDetail.ASI_CRM_SG_Customer__c);
            customerIdSet.add(promotionDetail.ASI_CRM_SG_Customer__c);
        }
        
        for(Contact con : retrieveContactList(customerIdSet)) {
            customerContactMap.put(con.ASI_CRM_AccountAdditionalField__c, con);
        }
        System.debug(customerContactMap);
    }
    
    public PageReference openPDF() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String customerId          = params.get(CUSTOMER_ID);
		String contactName         = params.get(CONTACT_NAME);
		String contactDesignation  = params.get(CONTACT_DESIGNATION);
		String contactNumber       = params.get(CONTACT_NUMBER);
        
        PageReference pageRef = new PageReference('/apex/' + PDF_PAGE_NAME + '?promotionId=' + promotion.Id 
                                                + '&customerId=' + customerId 
                                                + '&contactName=' + contactName 
                                                + '&contactDesignation=' + contactDesignation
                                                + '&contactNumber=' + contactNumber);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference cancel() {
    	PageReference pageRef = new PageReference('/' + promotion.Id);
	    pageRef.setRedirect(true);
	    return pageRef;
    }
    
    /***************
    Data Retrievement Function
    ***************/
    private ASI_HK_CRM_Promotion__c retrievePromotion(Id promotionId) {
    	String query = 'SELECT Id, Name '
                     + 'FROM ASI_HK_CRM_Promotion__c '
                     + 'WHERE Id = :promotionId ';
       	
        List<ASI_HK_CRM_Promotion__c> promotionList = (List<ASI_HK_CRM_Promotion__c>) Database.query(query);
        return promotionList.size() > 0 ? promotionList.get(0) : null;
    }
    
    private List<ASI_HK_CRM_Promotion_Detail__c> retrievePromotionDetailList(Id promotionId) {
        String query = 'SELECT Id, ASI_HK_CRM_Promotion__c, ASI_CRM_SG_Customer__c, ASI_CRM_SG_Customer__r.Name '
                     + 'FROM ASI_HK_CRM_Promotion_Detail__c '
                     + 'WHERE ASI_HK_CRM_Promotion__c = :promotionId ';
        
        return (List<ASI_HK_CRM_Promotion_Detail__c>) Database.query(query);
    }
    
    private List<Contact> retrieveContactList(Set<Id> customerIdSet) {
    	String query = 'SELECT Id, Name, Phone, ASI_CRM_AccountAdditionalField__c '
                     + 'FROM Contact '
                     + 'WHERE ASI_CRM_AccountAdditionalField__c in :customerIdSet ';
        
        return (List<Contact>) Database.query(query);
    }
    
    /***************
	Tools Function
	***************/
    private String toJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private Object fromJsonString(String jsonString, System.Type apexType) {
        if(String.isBlank(jsonString)) {
            return null;
        }
        return System.JSON.deserialize(jsonString, apexType);
    }
}