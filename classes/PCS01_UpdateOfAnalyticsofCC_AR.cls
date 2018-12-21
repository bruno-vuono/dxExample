/*********************************************************************
 Dev: Denis Aranda-Elena Schwarzböck  Version: 1  Consulting: Valuenet
**********************************************************************/

public with sharing class PCS01_UpdateOfAnalyticsofCC_AR {
    /*
    public static String UpdateOfDocuments(){
        system.debug(LoggingLevel.ERROR, 'entroupdate:');
        
        RecordType rtAR = [select id, DeveloperName FROM RecordType WHERE SobjectType = 'Titulos__c'and DeveloperName = 'Standard_AR'];
        RecordType rtUY = [select id, DeveloperName FROM RecordType WHERE SobjectType = 'Titulos__c'and DeveloperName = 'Standard_UY'];
        set<Id> setRts = new set<Id>{rtAR.Id, rtUY.Id};
        
        List<Titulos__c> titulos = [SELECT Id, Name, Internal_id_pk__c, NetSRReceipts_AR__c, Status__c, Cliente__c, RecordTypeId FROM Titulos__c WHERE RecordTypeId IN: setRts];
        
        map<Id, Account> mapIdAccountAccounts = new map<Id, Account>(); 
        
        set<string> internalId = new set<string>();
        
        for(Titulos__c tit: titulos){
            internalId.add(tit.Internal_id_pk__c);
            if(tit.Cliente__c != null){
                if( !mapIdAccountAccounts.containsKey(tit.Cliente__c) ) {
                    if( tit.Status__c == true){
                        Account acc = new Account (id = tit.Cliente__c, Overdue__c = true);
                        mapIdAccountAccounts.put(tit.Cliente__c, acc);
                    }else{
                        Account acc = new Account (id = tit.Cliente__c, Overdue__c = false);
                        mapIdAccountAccounts.put(tit.Cliente__c, acc);
                    }
                }else if( tit.Status__c == true && mapIdAccountAccounts.get(tit.Cliente__c).Overdue__c == false ){
                    mapIdAccountAccounts.get(tit.Cliente__c).Overdue__c = true;
                }
            }
        }
        
        List<DCM_Documents_ARG__c>  documentos = [SELECT Id, Name, Internal_id_pk_AR__c, Amounttoapply_AR__c FROM DCM_Documents_ARG__c WHERE Internal_id_pk_AR__c IN: internalId AND DocAppliedinJDE_AR__c = false AND Amounttoapply_AR__c != null];
        if(documentos.isEmpty()){
            return 'OK';
        }
        
        map<String, Decimal> mapIdPk = new map<String, Decimal>();
        Map<String, List<DCM_Documents_ARG__c>> mapTituloListDocumentos = new Map<String, List<DCM_Documents_ARG__c>>();
        for(DCM_Documents_ARG__c doc: documentos){
            
            if(mapTituloListDocumentos.containskey(doc.Internal_id_pk_AR__c)){
                mapTituloListDocumentos.get(doc.Internal_id_pk_AR__c).add(doc);
            }else{
                mapTituloListDocumentos.put(doc.Internal_id_pk_AR__c, new List<DCM_Documents_ARG__c>{doc});
            }
            
        }
        List<Titulos__c> titulosToUpdate = new List<Titulos__c>();
        for(Titulos__c tit: titulos){
            
            if(mapTituloListDocumentos.containskey(tit.Internal_id_pk__c)){
                Decimal amountToApply = 0;
                for(DCM_Documents_ARG__c d: mapTituloListDocumentos.get(tit.Internal_id_pk__c)){
                     amountToApply += d.Amounttoapply_AR__c;
                }
                tit.NetSRReceipts_AR__c = amountToApply;
                titulosToUpdate.add(tit);
            }
        }
        
        string error = '';
        
        if(titulosToUpdate.size() > 0){
            system.debug(LoggingLevel.ERROR,'entroTitulos:');
            try{
                update titulosToUpdate;
            }catch(exception e){
                error = 'Se ha producido un error en analitico de cuentas: '+e.getMessage();
            }
        }
        
        if(mapIdAccountAccounts.values().size() > 0){
            system.debug(LoggingLevel.ERROR,'entrocuentas:');
            try {
                update mapIdAccountAccounts.values();
            } catch(exception e){
                if(error == ''){
                    error = 'Se ha producido un error en Clientes: '+e.getMessage();
                }else{
                    error += ' y en Clientes' + e.getMessage();
                }
                
            }
            
        }
        
        if(error == ''){
            return 'OK';
        }else{
            return error;
        }
        
        
    }
    */
}

/*TEST CODE IN PCS01_UpdateOfAnalyticsofCC_Arg_Test CLASS*/