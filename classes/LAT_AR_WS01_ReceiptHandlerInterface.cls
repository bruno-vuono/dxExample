/******************************************************************************************************
*     Company:Valuenet     Developer:Denis Aranda / Elena J. Schwarzböck      Date:25/05/2014         *
*******************************************************************************************************/

global class LAT_AR_WS01_ReceiptHandlerInterface{
    
    private static RCP_Receipt_ARG__c receiptBackUp;
    
    @Future(callout = true)
    Webservice static void ReceiptInterfaceJDE(String idSalesforce){
        

        List<RCP_Receipt_ARG__c> listReceipts = [SELECT Id, Name, Account_AR__c, AmountsControl_AR__c, LAT_AR_DepositAccountType__c, AN8_AR__c, 
                                                        CollectionAgent_AR__c, Comment_AR__c, CustomerPaymentOrder_AR__c, Date_AR__c, 
                                                        Debit_AR__c, DepositsAmount_AR__c, Discount_AR__c, DocumentsAmount_AR__c, Downpayments_AR__c, 
                                                        Id_TXT_Aplications_Document_AR__c, Id_TXT_Values_Document_AR__c, LAT_AR_IntegrationStatus__c, 
                                                        LAT_AR_JDEReturnCode__c, ManualReceiptNumber_AR__c, RedemptionDateTime_AR__c, RedemptionNo_AR__c, 
                                                        Status_AR__c, TXT_Aplications_AR__c, TXT_Values_AR__c, ValuesAmount_AR__c, WithholdingsAmount_AR__c
                                                 FROM RCP_Receipt_ARG__c 
                                                 WHERE Id =: idSalesforce];
                                                 
        if(listReceipts.isEmpty()){return;}     
                                                                
        List<DPT_Deposit_ARG__c> listDeposits = [SELECT Id, Name, AccType_AR__c, Amount_AR__c, Bank_AR__c, Branch_AR__c, Comment_AR__c, Date_AR__c, 
                                                        LAT_AR_DepositRecordedJDE__c, ReceiptNo_AR__c, RecNumberInterfaceOk_AR__c, ReceiptNo_AR__r.Name
                                                 FROM DPT_Deposit_ARG__c 
                                                 WHERE ReceiptNo_AR__c =: idSalesforce];
        
        List<VLS_Values_ARG__c> listValues = [SELECT Id, Name, AccType_AR__c, Amount_AR__c, Bank_AR__c, BranBranch_AR__c, CommeComment_AR__c, 
                                                     Deposit_AR__c, DueDate_AR__c, IssueDate_AR_c__c, ReceiptNo_AR__c, ValueRecordedinJDE_AR__c, 
                                                     ValueTXTissued_AR__c, ValueType_AR__c, ReceiptNo_AR__r.Name, Deposit_AR__r.Name
                                              FROM VLS_Values_ARG__c 
                                              WHERE ReceiptNo_AR__c =: idSalesforce];   
                                                     
        List<TXC_TaxCertificates_ARG__c> listTaxCert = [SELECT Id, Name, Amount_AR__c, Comment_AR__c, Date_AR__c, RateRate_AR__c,Rate_AR__c, ReceiptNo_AR__c, 
                                                               TaxableAmount_AR__c, ValueType_AR__c, AplicationsTXTissued_AR__c, WithhRecordedinJDE_AR__c,
                                                               ReceiptNo_AR__r.Name
                                                        FROM TXC_TaxCertificates_ARG__c 
                                                        WHERE ReceiptNo_AR__c =: idSalesforce];     
                                                        
        List<DCM_Documents_ARG__c> listDocs = [SELECT Id, ReceiptNo_AR__c, LegalInvoice_AR__c, ReceiptNo_AR__r.Name
                                               FROM DCM_Documents_ARG__c
                                               WHERE ReceiptNo_AR__c =: idSalesforce];                                                            
        
        RCP_Receipt_ARG__c receipt = listReceipts[0];
        
        receiptBackUp = receipt.clone(true);
        
        LAT_ReceiptHandelerTypes.ReceiptType receiptArguments;

        try{    
            //Mapeo de recibo y sus hijos
            receiptArguments = mapReceipt(receipt,listDeposits,listValues,listTaxCert,listDocs);
            
            //Llamado a la interfase
            LAT_ReceiptHandelerTypes.CollectionManagerSFDCReqSOAPQSPort request = new LAT_ReceiptHandelerTypes.CollectionManagerSFDCReqSOAPQSPort();
            request.timeout_x = 120000;
            LAT_ReceiptHandelerTypes.CollectionManagerResponse_element response = request.CollectionManager(getConnectionParameter(), receiptArguments);
            
            system.debug('RETURN CODE: ' + String.valueOf(response.code));
            system.debug('RETURN MESSAGE: ' + String.valueOf(response.description));
            
            //Mapeo el retorno
            if(response.code == 0){
                receipt.LAT_AR_IntegrationStatus__c = 'Sent to JDE';
            }else{
                receipt.LAT_AR_MessageJDEIntegration__c = String.valueOf(response.description);
                receipt.LAT_AR_IntegrationStatus__c = 'Error en JDE';
            }        
        }catch(DMLException e){
            withError(receipt, e.getMessage());
            return;
        }
  
        //Actualizacion del recibo
        try{update receipt;}catch(Exception e){withError(receipt, e.getMessage());return;}

    }
    
    private static LAT_ReceiptHandelerTypes.ReceiptType mapReceipt(RCP_Receipt_ARG__c receipt, List<DPT_Deposit_ARG__c> listDeposits, List<VLS_Values_ARG__c> listValues, List<TXC_TaxCertificates_ARG__c> listTaxCert, List<DCM_Documents_ARG__c> listDocs){
        
        LAT_ReceiptHandelerTypes.ReceiptType receiptArguments = new LAT_ReceiptHandelerTypes.ReceiptType();
        //Campos Recibo
        receiptArguments.receiptNo            = receipt.Name;
        receiptArguments.amountsControl       = receipt.AmountsControl_AR__c;
        receiptArguments.clientAN8            = receipt.AN8_AR__c;
        receiptArguments.idCRM                = receipt.Id;
        receiptArguments.depositAccountType   = receipt.LAT_AR_DepositAccountType__c;
        receiptArguments.collectionAgent      = receipt.CollectionAgent_AR__c;
        receiptArguments.comment              = receipt.Comment_AR__c;
        receiptArguments.customerPaymentOrder = receipt.CustomerPaymentOrder_AR__c;
        receiptArguments.recDate              = receipt.Date_AR__c;
        receiptArguments.debit                = receipt.Debit_AR__c;
        receiptArguments.depositsAmount       = receipt.DepositsAmount_AR__c;
        receiptArguments.discount             = receipt.Discount_AR__c;
        receiptArguments.documentsAmount      = receipt.DocumentsAmount_AR__c;
        receiptArguments.downpayments         = receipt.Downpayments_AR__c;
        receiptArguments.manualReceiptNumber  = integer.valueOf(receipt.ManualReceiptNumber_AR__c);
        receiptArguments.redemptionDateTime   = receipt.RedemptionDateTime_AR__c;
        receiptArguments.redemptionNo         = receipt.RedemptionNo_AR__c;
        receiptArguments.status               = receipt.Status_AR__c;
        receiptArguments.valuesAmount         = receipt.ValuesAmount_AR__c;
        receiptArguments.withholdingsAmount   = receipt.WithholdingsAmount_AR__c;         
        
        receiptArguments.listDeposits = new LAT_ReceiptHandelerTypes.listDeposits_element();
        receiptArguments.listDeposits.deposit = new List<LAT_ReceiptHandelerTypes.DepositType>();
         
        if(!listDeposits.isEmpty()){            
            LAT_ReceiptHandelerTypes.DepositType depositArguments;
            for(DPT_Deposit_ARG__c deposit: listDeposits){
                depositArguments = new LAT_ReceiptHandelerTypes.DepositType();
                //se completan los campos de Depositos
                depositArguments.bankSlipNo = deposit.Name;
                depositArguments.accType    = deposit.AccType_AR__c;
                depositArguments.amount     = deposit.Amount_AR__c;
                depositArguments.bank       = deposit.Bank_AR__c;
                depositArguments.branch     = deposit.Branch_AR__c;
                depositArguments.comment    = deposit.Comment_AR__c;
                depositArguments.depDate    = deposit.Date_AR__c;
                depositArguments.receiptNo  = deposit.ReceiptNo_AR__r.Name;
                depositArguments.idCRMdep   = deposit.Id;
                
                receiptArguments.listDeposits.deposit.add(depositArguments); 
            }
        }  
        
        receiptArguments.listValues= new LAT_ReceiptHandelerTypes.listValues_element();
        receiptArguments.listValues.value = new List<LAT_ReceiptHandelerTypes.ValueType>();
        
        if(!listValues.isEmpty()){           
            LAT_ReceiptHandelerTypes.ValueType valueArguments;
            for(VLS_Values_ARG__c value: listValues){   
                valueArguments = new LAT_ReceiptHandelerTypes.ValueType();
                //se completan los campos de Valores
                valueArguments.chequeNo          = value.Name;
                valueArguments.accType           = value.AccType_AR__c;
                valueArguments.amount            = value.Amount_AR__c;
                valueArguments.bank              = value.Bank_AR__c;
                valueArguments.branch            = value.BranBranch_AR__c;
                valueArguments.comment           = value.CommeComment_AR__c;
                valueArguments.dueDate           = value.DueDate_AR__c;
                valueArguments.issueDate         = value.IssueDate_AR_c__c;
                valueArguments.receiptNo         = value.ReceiptNo_AR__r.Name;
                valueArguments.valueType         = value.ValueType_AR__c;
                valueArguments.idCRMval          = value.Id;
                valueArguments.depositBankSlipNo = value.Deposit_AR__r.Name;
                
                receiptArguments.listValues.value.add(valueArguments); 
            }
        }
        
        receiptArguments.listTaxCertificates = new LAT_ReceiptHandelerTypes.listTaxCertificates_element(); 
        receiptArguments.listTaxCertificates.taxCertificate = new List<LAT_ReceiptHandelerTypes.TaxCertificateType>();
        
        if(!listTaxCert.isEmpty()){         
            LAT_ReceiptHandelerTypes.TaxCertificateType taxCertArguments;
            for(TXC_TaxCertificates_ARG__c taxCert: listTaxCert){               
                taxCertArguments = new LAT_ReceiptHandelerTypes.TaxCertificateType();
                //se completan los campos de Retenciones
                taxCertArguments.certificateNo = taxCert.Name;
                taxCertArguments.amount        = taxCert.Amount_AR__c;
                taxCertArguments.comment       = taxCert.Comment_AR__c;
                taxCertArguments.taxDate       = taxCert.Date_AR__c;
                if(taxCert.Rate_AR__c != null)taxCertArguments.rateRate      = string.valueOf(taxCert.Rate_AR__c);
                else taxCertArguments.rateRate      = '';
                taxCertArguments.receiptNo     = taxCert.ReceiptNo_AR__r.Name;
                taxCertArguments.taxableAmount = taxCert.TaxableAmount_AR__c;
                taxCertArguments.valueType     = taxCert.ValueType_AR__c; 
                taxCertArguments.idCRMtax      = taxCert.Id;
                
                receiptArguments.listTaxCertificates.taxCertificate.add(taxCertArguments); 
            }
        } 

        receiptArguments.listDocuments = new LAT_ReceiptHandelerTypes.listDocuments_element(); 
        receiptArguments.listDocuments.document= new List<LAT_ReceiptHandelerTypes.DocumentType>();
        
        if(!listDocs.isEmpty()){         
            LAT_ReceiptHandelerTypes.DocumentType documentArguments;
            for(DCM_Documents_ARG__c document: listDocs){               
                documentArguments = new LAT_ReceiptHandelerTypes.DocumentType();
                //se completan los campos de Documentos
                documentArguments.legalInvoice = document.LegalInvoice_AR__c;
                documentArguments.receiptNo    = document.ReceiptNo_AR__r.Name;
                documentArguments.idCRMdoc     = document.Id;
                
                receiptArguments.listDocuments.document.add(documentArguments); 
            }
        } 

        return receiptArguments;        
    }
    
    private static void withError(RCP_Receipt_ARG__c receipt, String error){       
        receipt = receiptBackUp;
        receipt.LAT_AR_IntegrationStatus__c = 'Error in JDE';
        update receipt;       
    }
    
    private static LAT_ReceiptHandelerTypes.ClientInfoType getConnectionParameter(){
    
        LAT_ReceiptHandelerTypes.ClientInfoType connParms = new LAT_ReceiptHandelerTypes.ClientInfoType();
        CS001_JDEInterfaceCredentials__c cred = CS001_JDEInterfaceCredentials__c.getInstance('Argentina');
        if(cred != null){
            connParms.country = cred.Country__c;
            connParms.remoteHostIP = cred.RemoteHostIP__c;
            connParms.system_x = cred.System__c;
            connParms.systemUserID = cred.SystemUserID__c;
            connParms.time_x = Datetime.now();
        }
        return connParms;
        
    }
    
    
}