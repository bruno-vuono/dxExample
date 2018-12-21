/*********************************************************************************
 * Name:ASI_CRM_JP_PaymentInvoiceTgrHdlr
 * Description: Payment Invoice Trigger Handler for CRM JP
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 20/11/2014       Laputa: Hank          Created
*********************************************************************************/

public with sharing class ASI_CRM_JP_PaymentInvoiceTgrHdlr extends ASI_CRM_JP_TriggerAbstract {

    public ASI_CRM_JP_PaymentInvoiceTgrHdlr() {
        super('ASI_CRM_JP_PaymentInvoiceTgrHdlr');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        List<ASI_CRM_Payment_Invoice__c> pmtList = (List<ASI_CRM_Payment_Invoice__c>)sObjList;
        Set<Id> ownerIdSet = new Set<Id>();
        if (oldMap == null) {
            for (ASI_CRM_Payment_Invoice__c pmt:pmtList) {
                if(Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_SPTD_Cash_Invoice') || 
                        Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_Cash_Invoice')){
                    ownerIdSet.add(pmt.ownerId);
                }
                if(pmt.ASI_CRM_Tax_Rate__c == null){
                    Date invoiceDate = pmt.ASI_CRM_Invoice_Date__c;
                    if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice') || 
                            pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice_Read_Only')){
                        invoiceDate = (pmt.ASI_CRM_To_Month__c == null?pmt.ASI_CRM_From_Month__c:pmt.ASI_CRM_To_Month__c);            
                    }   
                    for (ASI_JP_TnE_Tax_Date_Mapping__c taxmap:ASI_JP_TnE_Tax_Date_Mapping__c.getAll().values()){
                        if (taxmap.ASI_JP_TnE_Start_Date__c <= invoiceDate && invoiceDate <= taxmap.ASI_JP_TnE_End_Date__c) {
                            pmt.ASI_CRM_Tax_Rate__c = 100 * taxmap.ASI_JP_TnE_Tax_Rate__c;
                        }
                    }
                }
                if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice') || 
                        pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice_Read_Only')){
                    pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice');
                }else if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_Cash_Invoice') || 
                        pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_Cash_Invoice_Read_Only')){
                    pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_Cash_Invoice');
                }else if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_FOC_Invoice') || 
                        pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_FOC_Invoice_Read_Only')){
                    pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_FOC_Invoice');
                }else if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Cash_Invoice') || 
                        pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Cash_Invoice_Read_Only')){
                    pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Cash_Invoice');
                }
            }
        }else{
            Map<ID, ASI_CRM_Payment_Invoice__c> oldPmtMap = (Map<ID, ASI_CRM_Payment_Invoice__c>) oldMap;
            for (ASI_CRM_Payment_Invoice__c pmt:pmtList) {
                if ((pmt.ownerId != null && (pmt.ownerId != oldPmtMap.get(pmt.Id).ownerId)) && 
                    (Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_SPTD_Cash_Invoice') || 
                        Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_Cash_Invoice'))) {
                    ownerIdSet.add(pmt.ownerId);
                }
                if (pmt.ASI_CRM_Tax_Rate__c == null || pmt.ASI_CRM_To_Month__c != oldPmtMap.get(pmt.id).ASI_CRM_To_Month__c || 
                        pmt.ASI_CRM_From_Month__c != oldPmtMap.get(pmt.id).ASI_CRM_From_Month__c) {
                    Date invoiceDate = pmt.ASI_CRM_Invoice_Date__c;
                    if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice') || 
                            pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice_Read_Only')){
                        invoiceDate = (pmt.ASI_CRM_To_Month__c == null?pmt.ASI_CRM_From_Month__c:pmt.ASI_CRM_To_Month__c);            
                    }   
                    for (ASI_JP_TnE_Tax_Date_Mapping__c taxmap:ASI_JP_TnE_Tax_Date_Mapping__c.getAll().values()){
                        if (taxmap.ASI_JP_TnE_Start_Date__c <= invoiceDate && invoiceDate <= taxmap.ASI_JP_TnE_End_Date__c) {
                            pmt.ASI_CRM_Tax_Rate__c = 100* taxmap.ASI_JP_TnE_Tax_Rate__c;
                        }
                    }
                }
                if(pmt.RecordTypeId != oldPmtMap.get(pmt.Id).RecordTypeId){
                    if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice') || 
                            pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice_Read_Only')){
                        pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Indirect_Rebate_Invoice');
                    }else if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_Cash_Invoice') || 
                            pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_Cash_Invoice_Read_Only')){
                        pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_Cash_Invoice');
                    }else if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_FOC_Invoice') || 
                            pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_FOC_Invoice_Read_Only')){
                        pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_SPTD_FOC_Invoice');
                    }else if(pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Cash_Invoice') || 
                        pmt.RecordTypeId == Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Cash_Invoice_Read_Only')){
                    pmt.ASI_CRM_Clone_Record_Type_Id__c = Global_RecordTypeCache.getRtId('ASI_CRM_Payment_Invoice__cASI_CRM_JP_Cash_Invoice');
                }
                }
            }
        }
        Map<Id, User> ownerMap = new Map<Id, User>([Select Id, ASI_KOR_User_Branch_Code__c From User Where Id In :ownerIdSet]);
        if (oldMap == null) {
            for (ASI_CRM_Payment_Invoice__c pmt : pmtList) {
                if(Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_SPTD_Cash_Invoice') || 
                        Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_Cash_Invoice')){
                    pmt.ASI_CRM_Sales_Group__c = ownerMap.get(pmt.ownerId).ASI_KOR_User_Branch_Code__c;
                }
            }
        }
        else {
            Map<ID, ASI_CRM_Payment_Invoice__c> oldPmtMap = (Map<ID, ASI_CRM_Payment_Invoice__c>) oldMap;
            for (ASI_CRM_Payment_Invoice__c pmt: pmtList) {
                if ((pmt.ownerId != null && (pmt.ownerId != oldPmtMap.get(pmt.Id).ownerId)) && 
                    (Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_SPTD_Cash_Invoice') || 
                        Global_RecordTypeCache.getRt(pmt.recordTypeid).developerName.contains('ASI_CRM_JP_Cash_Invoice'))) {
                    pmt.ASI_CRM_Sales_Group__c = ownerMap.get(pmt.ownerId).ASI_KOR_User_Branch_Code__c;
                }
            }
        }       
    }
    
}