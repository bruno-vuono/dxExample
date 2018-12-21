/***************************************************************************************************************************
 * Name:        ASI_CRM_SG_Voucher_Page_Ctrl
 * Description: Apex class for ASI_CRM_SG_Voucher_Page_Ctrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-04-11       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

public with sharing class ASI_CRM_SG_Voucher_Page_Ctrl {
    //Component Parameters
    public String voucherId { get; set; }
    public ASI_CRM_Voucher__c voucher { get; set; }
    public List<ASI_CRM_Voucher_Detail__c> voucherDetails { get; set; }
    public List<AggregateResult> voucherDetailsAr { get; set; }

    public ASI_CRM_SG_Voucher_Page_Ctrl() {
        Map<String, String> pageParaMap = ApexPages.currentPage().getParameters();
        voucherId = pageParaMap.get('voucherId');

        List<ASI_CRM_Voucher__c> vouchers = [SELECT Id, ASI_CRM_GL_Date__c, ASI_CRM_Customer__r.Name FROM ASI_CRM_Voucher__c WHERE Id = :voucherId LIMIT 1];
        voucher = (vouchers.size() == 1)? vouchers.get(0) : null;
        voucherDetails = [SELECT Id, ASI_CRM_Quantity__c, ASI_CRM_SKU__r.ASI_CRM_Short_Description__c, ASI_CRM_SKU__r.Name FROM ASI_CRM_Voucher_Detail__c WHERE ASI_CRM_Voucher_Header__c = :voucherId];
        voucherDetailsAr = [
            SELECT sum(ASI_CRM_Quantity__c) piece, ASI_CRM_SKU__r.Name voucherName
            FROM ASI_CRM_Voucher_Detail__c 
            WHERE ASI_CRM_Voucher_Header__c = :voucherId
            group by ASI_CRM_SKU__r.Name
        ];
    }
}