/*******************************************************************************
*   Company: Zimmic   Developer : Nicolás Marán    Fecha: 23/3/2016
*-------------------------------------------------------------------------------
*   Clase utilizada en los triggers del objeto LAT_Deposit
*******************************************************************************/
/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 05/12/2016
*
********************************************************************************/


public without sharing class LAT_Deposit {
    
    public static void createDeposit(List<DPT_Deposit_ARG__c> records){
        Map<String,RCP_Receipt_ARG__c> toUpdate = new Map<String,RCP_Receipt_ARG__c>();
        
        List<Id> recIds = new List<Id>();
        for(DPT_Deposit_ARG__c dep : records){
            recIds.add(dep.ReceiptNo_AR__c);
        }
        
        Map<Id,RCP_Receipt_ARG__c> receipts = new map<Id, RCP_Receipt_ARG__c>([Select id,LAT_AR_DepositAccountType__c,(Select id,AccType_AR__c from deposits__r) from RCP_Receipt_ARG__c where id in: recIds]);
        
        for(DPT_Deposit_ARG__c dep : records){
            if(validateDeposit(receipts.get(dep.ReceiptNo_AR__c).deposits__r,dep)){
                if(dep.AccType_AR__c == 'Collection Bank Account'){
                    receipts.get(dep.ReceiptNo_AR__c).LAT_AR_DepositAccountType__c = 'R';
                    toUpdate.put(dep.ReceiptNo_AR__c,receipts.get(dep.ReceiptNo_AR__c));
                }else if(dep.AccType_AR__c == 'Bank Account'){
                    receipts.get(dep.ReceiptNo_AR__c).LAT_AR_DepositAccountType__c = 'C';
                    toUpdate.put(dep.ReceiptNo_AR__c,receipts.get(dep.ReceiptNo_AR__c));
                }
            }
        }
        update toUpdate.values();
    }
    
    public static Boolean validateDeposit(List<DPT_Deposit_ARG__c> deposits, DPT_Deposit_ARG__c newDeposit){
        for(DPT_Deposit_ARG__c dep : deposits){
            if(dep.AccType_AR__c != newDeposit.AccType_AR__c && dep.id != newDeposit.id){
                newDeposit.addError('El tipo de Cuenta del Depósito es distinto del informado en los otros Depósitos del Recibo. Favor revisar antes de seguir.');
                return false;
            }
        }
        return true;
    }

    public static void deleteDeposit(List<DPT_Deposit_ARG__c> deposits){
        // to Bypass the validation 'El perfil \'AR_Vendedor\' no puede eliminar un deposito creado desde un comprobante.'
        if(AP01_Document_AR.isDeletingFirst){
            if(userInfo.getProfileId() == LAT_GlobalProfileCache.getProfileIdByName('AR_Vendedor')
                || userInfo.getProfileId() == LAT_GlobalProfileCache.getProfileIdByName('LAT_AR2_Vendedor')){
                for(DPT_Deposit_ARG__c dep : deposits){
                    if(dep.From_Document__c){
                        dep.addError('Registros de Depósitos creados automáticamente no pueden ser eliminados. Favor eliminar los Comprobantes del Recibo.');
                    }
                }
            }
        }
    }

    
    
    public static void updateBankSlipNo(List<DPT_Deposit_ARG__c> records){
        for (DPT_Deposit_ARG__c dep: records) {
            system.debug('&&&&& ' + dep.name);
            if(dep.name == null)dep.name = '';
            Integer NameLength = dep.Name.length();
            for (Integer i = NameLength; i < 9; i++) {
                dep.Name = '0' + dep.Name;
            }
        }
    }
 /*******************************************************************************
*   Company: Zimmic   Developer : Nicolás Marán    Fecha: 23/3/2016
*-------------------------------------------------------------------------------
*   //Metodo verifica el estado del padre del depósit para ver si el depósito puede ser modificado
*******************************************************************************/   

    public static void DepositCheckPrintStatus(Map<id,DPT_Deposit_ARG__c> triggerNewMap){

        
         Map<id,DPT_Deposit_ARG__c> mapTemp = new Map<id,DPT_Deposit_ARG__c>([Select id , ReceiptNo_AR__r.Status_AR__c from DPT_Deposit_ARG__c where id IN : triggerNewMap.keyset()]);
        
        for (DPT_Deposit_ARG__c dep : triggerNewMap.values()) { 
            
            if((mapTemp.get(dep.id).ReceiptNo_AR__r.Status_AR__c == null 
                || Lat_RecieptValidationsUtil.checkBothStatus(mapTemp.get(dep.id).ReceiptNo_AR__r.Status_AR__c)) 
                && !Lat_RecieptValidationsUtil.allowUpdate()) 
                dep.addError(Label.LAT_AR_TRIGGER_DepositForPrintReciept    );
        }  
    }
    
}