/*************************************************************************************************
*           Company: Zimmic    Developer: Nicolás Marán    Fecha: 23/3/2016
*-------------------------------------------------------------------------------
*   Clase que contiene los triggers del objeto DPT_Deposit_ARG__c
**************************************************************************************************/

trigger LAT_DepositBeforeInsert on DPT_Deposit_ARG__c (before insert,before update,before delete) {
       if(Trigger.isDelete){
       		LAT_Deposit.DepositCheckPrintStatus(Trigger.oldMap);
       		//LAT_Deposit.deleteDeposit(Trigger.old);
       }
       	else{

       		if(Trigger.isUpdate) LAT_Deposit.DepositCheckPrintStatus(Trigger.newMap);
     	  	LAT_Deposit.createDeposit(Trigger.new);
	     	LAT_Deposit.updateBankSlipNo(Trigger.new);
   		}
}