/*******************************************************************************
*                           Company: ValueNet
*-------------------------------------------------------------------------------
*   Clase que contiene los triggers del objeto RCP_Receipt_ARG__c
*******************************************************************************/

public with sharing class AP01_Receipt_AR {

    /*****************************************************************************************
    * Nombre del metodo: UpdateCurrency
    * Descripcion: Metodo que asigna al recibo el tipo de moneda que utiliza el cliente
    * Desarrollador: Tomás Etchegaray
    * Fecha: Date:04/04/2013
    * Modo: before insert, before update
    *****************************************************************************************/
    public static void UpdateCurrency (List<RCP_Receipt_ARG__c> triggerNew){
        set<Id> setParentIdsAcc = new set<Id>();
        for(RCP_Receipt_ARG__c rec : triggerNew){
            setParentIdsAcc.add(rec.Account_AR__c);
        }

        map<Id, Account> mapParentAccount = new map<Id, Account>([SELECT Id, CurrencyIsoCode, CollectionAgent_AR__r.Name, CollectionAgent_AR__c, Client_code_AN8__c FROM Account WHERE Id IN: setParentIdsAcc]);

        for(RCP_Receipt_ARG__c rec : triggerNew){
            rec.CurrencyIsoCode = mapParentAccount.get(rec.Account_AR__c).CurrencyIsoCode;
            if(trigger.isInsert){
                rec.Date_AR__c = date.today();
                rec.AN8_AR__c = mapParentAccount.get(rec.Account_AR__c).Client_code_AN8__c;
                rec.CollectionAgent_AR__c = mapParentAccount.get(rec.Account_AR__c).CollectionAgent_AR__r.Name;
            }
        }
    }

     /*****************************************************************************************
    * Nombre del metodo: UpdateName
    * Descripcion: Metodo que asigna el siguiente numero disponible al name
    * Desarrollador: Zimmic
    * Fecha: Date:19/03/2015
    * Modo: before insert
    *****************************************************************************************/
    public static void updateName (List<RCP_Receipt_ARG__c> triggerNew){
        List<LAT_GeneralConfig__c> lstConfig = [Select id,LAT_Value__c,name from LAT_GeneralConfig__c where name = 'RECEIPT_NRO' for update];
        if(lstConfig != null && lstConfig.size() > 0){
            LAT_GeneralConfig__c config = lstConfig[0];
            integer receiptNro = Integer.valueOf(config.LAT_Value__c);
            for(RCP_Receipt_ARG__c rc : triggerNew){
                receiptNro += 1;
                rc.name = String.valueOf(receiptNro);
            }
            config.LAT_Value__c = String.valueOf(receiptNro);
            update config;
        }
    }

    /*****************************************************************************************
   * Nombre del metodo: validateCreation
   * Descripcion: Metodo que valida si el customSetting allowCreateReceipt = True
   * Desarrollador: Zimmic
   * Fecha: Date:19/07/2015
   * Modo: before insert
   *****************************************************************************************/
   public static void validateCreation (List<RCP_Receipt_ARG__c> triggerNew){
      Boolean tmpAllow = True;
      String[] allow = LAT_GeneralConfigDao.getValueAsStringArray('ALLOW_CREATE_RECEIPT', ' ');
      try{
        if(allow != null && allow.size()>0)tmpAllow = Boolean.valueOf(allow[0]);
      }catch(Exception ex){

      }
      for(RCP_Receipt_ARG__c rec : triggerNew){
          if(!tmpAllow)rec.addError(Label.LAT_AR_AP01_RCP_002);
      }
   }


     /*****************************************************************************************
    * Nombre del metodo: maintainName
    * Descripcion: Metodo que mantiene el nombre anterior al modificar el recibo
    * Desarrollador: Zimmic
    * Fecha: Date:19/03/2015
    * Modo: before insert
    *****************************************************************************************/

    public static void maintainName (List<RCP_Receipt_ARG__c> triggerNew, List<RCP_Receipt_ARG__c> triggerOld){
        for(integer i = 0; i < triggerNew.size(); i++){
            triggerNew[i].name = triggerOld[i].name;
        }

    }


    /*****************************************************************************************
    * Nombre del metodo: UpdateReceiptType
    * Descripcion: keeps the type the same for all the Deposits
    * Desarrollador: Denis Aranda
    * Fecha: Date: 14/05/2014
    * Modo: after update
    *****************************************************************************************/
    public static void UpdateReceiptType (List<RCP_Receipt_ARG__c> triggerNew, Map<Id, RCP_Receipt_ARG__c> triggerOld){
        List<String> listIdReceipts = new List<String>();

        for(RCP_Receipt_ARG__c rec: triggerNew){
            if(rec.LAT_AR_DepositAccountType__c != triggerOld.get(rec.Id).LAT_AR_DepositAccountType__c){
                listIdReceipts.add(rec.id);
            }
        }
        system.debug('listIdReceipts: ' + listIdReceipts);

        if(listIdReceipts.size()>0){
            Map<Id, List<DPT_Deposit_ARG__c>> mapIdToDep = new Map<Id, List<DPT_Deposit_ARG__c>>();
            List<DPT_Deposit_ARG__c> listDeposits = [SELECT id, Name, AccType_AR__c, ReceiptNo_AR__c FROM DPT_Deposit_ARG__c WHERE ReceiptNo_AR__c IN: listIdReceipts];
            List<DPT_Deposit_ARG__c> listDepToUpdate = new List<DPT_Deposit_ARG__c>();

            for(DPT_Deposit_ARG__c dep: listDeposits){
                if(mapIdToDep.containsKey(dep.ReceiptNo_AR__c)){
                    mapIdToDep.get(dep.ReceiptNo_AR__c).add(dep);
                }else{
                    mapIdToDep.put(dep.ReceiptNo_AR__c, new List<DPT_Deposit_ARG__c>{dep});
                }
            }

            for(RCP_Receipt_ARG__c rec: triggerNew){
                if(mapIdToDep.containsKey(rec.id)){
                    for(DPT_Deposit_ARG__c dep: mapIdToDep.get(rec.id)){
                        if(rec.LAT_AR_DepositAccountType__c == 'C' && dep.AccType_AR__c != 'Bank Account'){
                            dep.AccType_AR__c = 'Bank Account';
                            listDepToUpdate.add(dep);
                        }
                        if(rec.LAT_AR_DepositAccountType__c == 'R' && dep.AccType_AR__c != 'Collection Bank Account'){
                            dep.AccType_AR__c = 'Collection Bank Account';
                            listDepToUpdate.add(dep);
                        }
                    }
                }
            }
            system.debug('listDepToUpdate: ' +listDepToUpdate);
            try{update listDepToUpdate;}catch(System.DmlException e){}
        }
    }

    /*****************************************************************************************
    * Nombre del metodo: ReceiptToJDE
    * Descripcion: Sends receipts and relations to JDE
    * Desarrollador: Denis Aranda
    * Fecha: Date: 16/05/2014
    * Modo: after update
    *****************************************************************************************/
    public static void ReceiptToJDE (List<RCP_Receipt_ARG__c> triggerNew, Map<Id, RCP_Receipt_ARG__c> triggerOld){

        List<String> listIdReceipts = new List<String>();


        for(RCP_Receipt_ARG__c rec: triggerNew){
            if(rec.RecordTypeId != Global_RecordTypeCache.getRtId('RCP_Receipt_ARG__c' + 'LAT_AR_RCP_ReceiptOfApplyingDocuments') && rec.Status_AR__c == 'Receipt Verified' && rec.Status_AR__c != triggerOld.get(rec.Id).Status_AR__c){
                listIdReceipts.add(rec.id);
            }
        }

        if(listIdReceipts.size()>0){

            Set<Id> setRecIdOfSons = new Set<Id>();

            // Query of the Sons of Receipts
            List<TXC_TaxCertificates_ARG__c> listTaxCert =  [SELECT id, Name, WithhRecordedinJDE_AR__c, ReceiptNo_AR__c FROM TXC_TaxCertificates_ARG__c WHERE ReceiptNo_AR__c IN: listIdReceipts];
            List<DPT_Deposit_ARG__c> listDeposits =         [SELECT id, Name, LAT_AR_DepositRecordedJDE__c, ReceiptNo_AR__c FROM DPT_Deposit_ARG__c WHERE ReceiptNo_AR__c IN: listIdReceipts];
            List<VLS_Values_ARG__c> listValues =            [SELECT id, Name, ValueRecordedinJDE_AR__c, ReceiptNo_AR__c FROM VLS_Values_ARG__c WHERE ReceiptNo_AR__c IN: listIdReceipts];


            for(TXC_TaxCertificates_ARG__c tax: listTaxCert){
                if(!setRecIdOfSons.contains(tax.ReceiptNo_AR__c)){
                    setRecIdOfSons.add(tax.ReceiptNo_AR__c);
                }

            }

            for(DPT_Deposit_ARG__c dep: listDeposits){
                if(!setRecIdOfSons.contains(dep.ReceiptNo_AR__c)){
                    setRecIdOfSons.add(dep.ReceiptNo_AR__c);
                }
            }

            for(VLS_Values_ARG__c val: listValues){
                if(!setRecIdOfSons.contains(val.ReceiptNo_AR__c)){
                    setRecIdOfSons.add(val.ReceiptNo_AR__c);
                }
            }

            for(RCP_Receipt_ARG__c rec: triggerNew){
                if(setRecIdOfSons.contains(rec.Id)){
                    LAT_AR_WS01_ReceiptHandlerInterface.ReceiptInterfaceJDE(rec.Id);
                }
            }

        }
    }

    /**********************************************************************************************************
    * Nombre del metodo: ValidatesDepositAccountType
    * Descripcion: checks that there is no value with type '0' when DepositAccountType is updated to 'R'
    * Desarrollador: Denis Aranda
    * Fecha: Date: 23/06/2014
    * Modo: before update
    **********************************************************************************************************/
    public static void ValidatesDepositAccountType (List<RCP_Receipt_ARG__c> triggerNew, Map<Id, RCP_Receipt_ARG__c> triggerOld){

        Map<String, VLS_Values_ARG__c> mapReceiptsIdToValue = new Map<String, VLS_Values_ARG__c>();
        List<String> listIdReceipts = new List<String>();

        for(RCP_Receipt_ARG__c rec: triggerNew){
            if(rec.LAT_AR_DepositAccountType__c == 'R'  && rec.LAT_AR_DepositAccountType__c != triggerOld.get(rec.Id).LAT_AR_DepositAccountType__c){
                listIdReceipts.add(rec.Id);
            }
        }

        List<VLS_Values_ARG__c> listDeposits = [SELECT id, Name, ValueType_AR__c, ReceiptNo_AR__c FROM VLS_Values_ARG__c WHERE ReceiptNo_AR__c IN: listIdReceipts AND ValueType_AR__c = '0'];

        for(VLS_Values_ARG__c dep: listDeposits){
            if(!mapReceiptsIdToValue.containsKey(dep.Id)){
                mapReceiptsIdToValue.put(dep.ReceiptNo_AR__c, dep);
            }
        }

        for(RCP_Receipt_ARG__c rec: triggerNew){
            if(mapReceiptsIdToValue.containsKey(rec.Id)){
                rec.addError(Label.LAT_AR_AP01_RCP_001);
            }
        }
    }
}