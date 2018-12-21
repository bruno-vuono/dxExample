public with sharing class ASI_CRM_CN_PaymentRequestLine_TriggerCls{
    public static void routineBeforeUpsert(list<ASI_TH_CRM_PaymentRequestLineItem__c> trigger_new, map<id, ASI_TH_CRM_PaymentRequestLineItem__c> trigger_oldMap) {
           Set<id> StID = new Set<id>();
           for (ASI_TH_CRM_PaymentRequestLineItem__c  prli:trigger_new){
               StID.add(prli.ASI_TH_CRM_Payment_Request__c);
           }
           Map<id,ASI_TH_CRM_PaymentRequest__c > LPRL= new Map<Id, ASI_TH_CRM_PaymentRequest__c>([Select id, CurrencyIsoCode 
                        FROM ASI_TH_CRM_PaymentRequest__c WHERE id IN :StID]);                           
           for (ASI_TH_CRM_PaymentRequestLineItem__c  prli:trigger_new){
                   prli.CurrencyIsoCode = LPRL.get(prli.ASI_TH_CRM_Payment_Request__c).CurrencyIsoCode ;
           }
    }
}