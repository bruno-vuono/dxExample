/*******************************************************************************
*                           Company: ValueNet
*-------------------------------------------------------------------------------
*   Clase que contiene los triggers PRM del objeto Account
*******************************************************************************/

public without sharing class LAT_BR_AP01_AccountWOS {
	
	/*****************************************************************************************
    * Nombre del metodo: ValidateDuplicatesCNPJ
    * Descripcion: Valida que no se inserten cnpj duplicados.
    * Desarrollador: Tomás Etchegaray
    * Fecha: 21/03/2013
    * Modo: before insert, before update
    *****************************************************************************************/
    public static void validateDuplicatesCNPJ(List<Account> triggerNew){
        
        set<string> setCNPJsOnTrigger = new set<string>();
        set<string> setCNPJsOnTriggerRepeted = new set<string>();
        
        for(Account acc : triggerNew){
            if(acc.CNPJ__c != null){
                if(setCNPJsOnTrigger.contains(acc.CNPJ__c)){
                    setCNPJsOnTriggerRepeted.add(acc.CNPJ__c);
                }
                setCNPJsOnTrigger.add(acc.CNPJ__c);
            }
        }
        
        //Verifico que en el mismo triggerNew no vengan repetidos
        for (Account acc : triggerNew){
            if(acc.CNPJ__c != null && setCNPJsOnTriggerRepeted.contains(acc.CNPJ__c)){
                acc.adderror(Label.AP01_00010_AR+' '+acc.CNPJ__c);
            }
        }
        
        //Verifico que en la base de datos no haya otro CNPJ igual
        map<String, Account> mapCNPJAcc = new map<String, Account>();
        set<Id> setIdsRT =  Global_RecordTypeCache.getRtIdSet('Account', new Set<String>{'On_Trade', 'Off_Trade', 'Eventos'});
        for(Account acc : [SELECT Id, CNPJ__c, OwnerId, Owner.Name, Client_code_AN8__c FROM Account WHERE cnpj__c IN: setCNPJsOnTrigger AND RecordTypeId IN: setIdsRT]){
            mapCNPJAcc.put(acc.CNPJ__c , acc);
        }
        
        for (Account acc : triggerNew){
            if(acc.CNPJ__c != null){
                if(mapCNPJAcc.containsKey(acc.CNPJ__c) && acc.id != mapCNPJAcc.get(acc.CNPJ__c).id){
                    acc.addError(label.AP01_00001_AR + mapCNPJAcc.get(acc.CNPJ__c).Client_code_AN8__c + '  -  ' + mapCNPJAcc.get(acc.CNPJ__c).Owner.Name);
                }
            }
        }
    }

    /*****************************************************************************************
    * Nombre del metodo: completeAgencyAccount
    * Descripcion: Valida que no se inserten cnpj duplicados.
    * Desarrollador: Tomás Etchegaray
    * Fecha: 21/03/2013
    * Modo: before insert, before update
    *****************************************************************************************/
    public static void completeAgencyAccount(List<Account> triggerNew){
        for (Account acc: triggerNew) {
            if (acc.Agency__c != null) {
                Integer agLength = acc.Agency__c.length();
                if (agLength < 4) {
                    for (Integer i = agLength; i < 4; i++) {
                        acc.Agency__c = 0 + acc.Agency__c; 
                    }
                }
            }
        }
    }
}