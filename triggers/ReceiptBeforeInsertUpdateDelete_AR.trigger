trigger ReceiptBeforeInsertUpdateDelete_AR on RCP_Receipt_ARG__c (before insert, before update, after insert, after update) {

    //Filtrado de RecordTypes
    LAT_Trigger trigger_AR = new LAT_Trigger('RCP_Receipt_ARG__c', new set<String>{'LAT_AR_RCP_ReceiptCancelled', 'LAT_AR_RCP_ReceiptPrintedValueGuarantee', 'LAT_AR_RCP_ReceiptValueGuarantee', 'RCP_ReceiptGeneratedDepositDone_AR', 'RCP_ReceiptGeneratedDepositPending_AR', 'RCP_ReceiptPrintedDepositDone_AR', 'RCP_ReceiptPrintedDepositPending_AR', 'Receipt_withholding_certificates_AR','LAT_AR_RCP_ReceiptOfApplyingDocuments'});

    //Ejecucion de metodos especificos para AR
    if(trigger_AR.getNew() != null && !trigger_AR.getNew().IsEmpty()){
        if(trigger.isBefore){
            if(trigger.isInsert){
                AP01_Receipt_AR.UpdateCurrency(trigger_AR.getNew());
                AP01_Receipt_AR.updateName(trigger_AR.getNew());
            }
            if(trigger.isUpdate){
                AP01_Receipt_AR.maintainName(trigger_AR.getNew(),trigger_AR.getOld());
                AP01_Receipt_AR.UpdateCurrency(trigger_AR.getNew());
                AP01_Receipt_AR.ValidatesDepositAccountType(trigger_AR.getNew(),new map<Id,RCP_Receipt_ARG__c>((List<RCP_Receipt_ARG__c>)trigger_AR.getOld()));

            }
        }
        if(trigger.isAfter){
            if(trigger.isUpdate){
                AP01_Receipt_AR.UpdateReceiptType(trigger_AR.getNew(),new map<Id,RCP_Receipt_ARG__c>((List<RCP_Receipt_ARG__c>)trigger_AR.getOld()));
                AP01_Receipt_AR.ReceiptToJDE(trigger_AR.getNew(),new map<Id,RCP_Receipt_ARG__c>((List<RCP_Receipt_ARG__c>)trigger_AR.getOld()));
            }
        }
    }

}