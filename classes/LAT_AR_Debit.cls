/*******************************************************************************
*   Company: Zimmic   Developer : Nicolás Marán    Fecha: 23/3/2016
*-------------------------------------------------------------------------------
*   Clase utilizada en los triggers del objeto LAT_AR_Debit
*******************************************************************************/
public with sharing class LAT_AR_Debit {
	

/*******************************************************************************
*   Company: Zimmic   Developer : Nicolás Marán    Fecha: 23/3/2016
*-------------------------------------------------------------------------------
*   //Metodo verifica el estado del padre del débito para ver si el débito puede ser modificado
*******************************************************************************/  

	public static void DebitCheckPrintStatus(Map<id,DBT_Debit_ARG__c> triggerNewMap){
			
		 Map<id,DBT_Debit_ARG__c> mapTemp = new Map<id,DBT_Debit_ARG__c>([Select id , ReceiptNo_AR__r.Status_AR__c from DBT_Debit_ARG__c where id IN : triggerNewMap.keyset()]);
        
        for (DBT_Debit_ARG__c deb : triggerNewMap.values()) { 

        	String statusReceipt = mapTemp.get(deb.id).ReceiptNo_AR__r.Status_AR__c;

        	 if(statusReceipt == null || Lat_RecieptValidationsUtil.checkBothStatus(statusReceipt)) 
                    deb.addError(Label.LAT_AR_TRIGGER_DebitForPrintReciept);
        
        }		
	}

}