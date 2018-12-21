/*********************************************************************************
 * Name: ASI_CRM_MY_PaymentRequestReportCtl
 * Description: Controller class for ASI_CRM_MY_PaymentRequestReportPage
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2015-01-06       Daniel WONG             Created 
 */


public with sharing class ASI_CRM_MY_PaymentRequestReportCtl{
        
    private ApexPages.StandardController standardController {get;set;}
    private Id PaymentRequestId{
        get{
            if (this.standardController!=null){
                return this.standardController.getId();                                 
            }
            return null;
        }
    }
    
    public decimal total{get; set;} {total = 0;}
    public decimal nettotal{get; set;} {nettotal = 0;}
    public decimal taxtotal{get; set;} {taxtotal = 0;}
    
    public list<ASI_TH_CRM_PaymentRequestLineItem__c> getPaymentLineItem(){    
        List<ASI_TH_CRM_PaymentRequestLineItem__c> lstSalesTarget = [
            SELECT id, ASI_CRM_SKU__r.Name, ASI_CRM_SKU__r.ASI_TH_CRM_Sub_brand_Code__c, ASI_CRM_CN_Actual_Vol__c, ASI_CRM_CN_Target_BT__c, ASI_TH_CRM_Amount__c,
                   ASI_CRM_SetupCode__c, ASI_CRM_CN_AC_Code__r.ASI_MFM_A_C_Code__c,
                   ASI_CRM_Net_Amount__c, ASI_CRM_Tax_Amount__c, ASI_CRM_MY_Adjusted_Amount__c
            FROM ASI_TH_CRM_PaymentRequestLineItem__c
            WHERE ASI_TH_CRM_Payment_Request__c = :PaymentRequestId
            ORDER BY ASI_CRM_SKU__r.Name
        ];
        
        for(ASI_TH_CRM_PaymentRequestLineItem__c i : lstSalesTarget ){
            if(i.ASI_TH_CRM_Amount__c != NULL) {
                total = total + i.ASI_TH_CRM_Amount__c;
                //total += i.ASI_CRM_MY_Adjusted_Amount__c;
            }
            if(i.ASI_CRM_MY_Adjusted_Amount__c != NULL) {
                //nettotal += i.ASI_CRM_Net_Amount__c;
                nettotal += i.ASI_CRM_MY_Adjusted_Amount__c;
            }
            if(i.ASI_CRM_Tax_Amount__c != NULL) {
                taxtotal += i.ASI_CRM_Tax_Amount__c;
            }
        }
          
        return lstSalesTarget;
    }
        
    public ASI_CRM_MY_PaymentRequestReportCtl(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
}