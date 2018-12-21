/*******************************************************************************
*                           Company: ValueNet
*-------------------------------------------------------------------------------
*   Clase que contiene los triggers PRM del objeto Opportunity
*******************************************************************************/
/********************************************************************************
*                       
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 04/11/2016
*
********************************************************************************/
    
public with sharing class LAT_MX_AP01_Opportunity{
       
    /*****************************************************************************************
    * Nombre del metodo: parentCustomerUpdate--
    * Descripcion: Método que completa el campo Parent Customer
    * Desarrollador: Elena J. Schwarzböck
    * Fecha: 12/11/2013
    * Modo: before insert, before update
    *****************************************************************************************/
    
    public static void parentCustomerUpdate(List<Opportunity> triggerNew){
        Set<String> setAccountsId = new Set<String>();      
        for(Opportunity opp: triggerNew){
            setAccountsId.add(opp.AccountId);
        }
        if(!setAccountsId.isEmpty()){
            Map<String,Account> mapAccounts = new Map<String,Account>([SELECT Id, ParentId FROM Account WHERE Id IN: setAccountsId]);
            for(Opportunity opp: triggerNew){
                if(mapAccounts.get(opp.AccountId).ParentId != null){
                    opp.ParentAccount_AR__c = mapAccounts.get(opp.AccountId).ParentId;
                }
            }
        }
    }

    //MIGRATED 04/11/2016
    public static void parentCustomerUpdate(List<LAT_Opportunity__c> triggerNew){
        Set<String> setAccountsId = new Set<String>();      
        for(LAT_Opportunity__c opp: triggerNew){
            setAccountsId.add(opp.LAT_Account__c);
        }
        if(!setAccountsId.isEmpty()){
            Map<String,Account> mapAccounts = new Map<String,Account>([SELECT Id, ParentId FROM Account WHERE Id IN: setAccountsId]);
            for(LAT_Opportunity__c opp: triggerNew){
                if(mapAccounts.get(opp.LAT_Account__c).ParentId != null){
                    opp.LAT_AR_ParentAccount__c = mapAccounts.get(opp.LAT_Account__c).ParentId;
                }
            }
        }

    }

    /*****************************************************************************************
    * Nombre del metodo: initialStageUpdate
    * Descripcion: Método que completa el campo Stage Name cuando se crea un registro
    * Desarrollador: Elena J. Schwarzböck
    * Fecha: 12/11/2013
    * Modo: before insert
    *****************************************************************************************/
    
    public static void initialStageUpdate(List<Opportunity> triggerNew){
    
        for(Opportunity opp: triggerNew){
            opp.StageName = 'Novo pedido';
        }
    }

    //MIGRATED 04/11/2016
    public static void initialStageUpdate(List<LAT_Opportunity__c> triggerNew){
    
        for(LAT_Opportunity__c opp: triggerNew){
            if (opp.LAT_StageName__c == 'Mobile Order') {
                opp.LAT_OrderOrigin__c = 'APP';
            } else {
                opp.LAT_StageName__c = 'Novo pedido';
            }
            
        }
    }
    
    /*****************************************************************************************
    * Nombre del metodo: salesOrderHandlerInterfaceAfterAP
    * Descripcion: Sends record to JDE when it was approved (LAT_MX_PaymentPeriodApproved__c = true)
    * Desarrollador: Elena J. Schwarzböck
    * Fecha: 03/12/2013
    * Modo: before update
    *****************************************************************************************/
    
    public static void salesOrderHandlerInterfaceAfterAP(List<Opportunity> triggerNew,Map<Id,Opportunity> OldMap){   
        for(Opportunity opp: triggerNew){
            if(opp.LAT_MX_PaymentPeriodApproved__c && !OldMap.get(opp.Id).LAT_MX_PaymentPeriodApproved__c){
                LAT_MX_WS03_SalesOrderHandlerInterface.SalesOrderInterfaceFuture(String.valueof(opp.Id));      
            }  
        }
    }

    //MIGRATED 04/11/2016
    public static void salesOrderHandlerInterfaceAfterAP(List<LAT_Opportunity__c> triggerNew,Map<Id,LAT_Opportunity__c> OldMap){   
        for(LAT_Opportunity__c opp: triggerNew){
            if(opp.LAT_MX_PaymentPeriodApproved__c && !OldMap.get(opp.Id).LAT_MX_PaymentPeriodApproved__c){
                LAT_MX_WS03_SalesOrderHandlerInterface.SalesOrderInterfaceFuture(String.valueof(opp.Id));      
            }  
        }
    }
    

    /*****************************************************************************************
    * Nombre del metodo: updatesKAMPromisedDate
    * Descripcion: Método que copia el fecha del campo DT_delivery__c a los hijos
    * Desarrollador: Elena J. Schwarzböck
    * Fecha: 07/01/2014
    * Modo: before update
    *****************************************************************************************/
    
    public static void updatesKAMPromisedDate(Map<Id,Opportunity> NewMap, Map<Id,Opportunity> oldMap){    
               
        List<Opportunity> listOpp = [SELECT Id, DT_delivery__c, (SELECT Id, LAT_MX_KAMPromisedDate__c FROM OpportunityLineItems) FROM Opportunity WHERE Id IN: NewMap.keySet()];

        List<OpportunityLineItem> listOlisToUpdate = new List<OpportunityLineItem>();
        
        for(Opportunity opp: listOpp){
            if(opp.DT_delivery__c != NewMap.get(opp.Id).DT_delivery__c){
                for(OpportunityLineItem oli: opp.OpportunityLineItems){
                    oli.LAT_MX_KAMPromisedDate__c = opp.DT_delivery__c;
                    listOlisToUpdate.add(oli);
                }
            }
        }

        if(!listOlisToUpdate.isEmpty()){
            try{update listOlisToUpdate;}catch(DMLException e){}
        }   
    }

    //MIGRATED 04/11/2016
    public static void updatesKAMPromisedDate(Map<Id,LAT_Opportunity__c> NewMap, Map<Id,LAT_Opportunity__c> oldMap){    
               
        List<LAT_Opportunity__c> listOpp = [SELECT Id, LAT_DTDelivery__c, (SELECT Id, LAT_MX_KAMPromisedDate__c FROM OpportunityLineItems__r) FROM LAT_Opportunity__c WHERE Id IN: NewMap.keySet()];

        List<LAT_OpportunityLineItem__c> listOlisToUpdate = new List<LAT_OpportunityLineItem__c>();
        
        for(LAT_Opportunity__c opp: listOpp){
            if(opp.LAT_DTDelivery__c != NewMap.get(opp.Id).LAT_DTDelivery__c){
                for(LAT_OpportunityLineItem__c oli: opp.OpportunityLineItems__r){
                    oli.LAT_MX_KAMPromisedDate__c = opp.LAT_DTDelivery__c;
                    listOlisToUpdate.add(oli);
                }
            }
        }

        if(!listOlisToUpdate.isEmpty()){
            try{update listOlisToUpdate;}catch(DMLException e){}
        }   
    }
    
    /*****************************************************************************************
    * Nombre del metodo: ValidationOnDelete
    * Descripcion: Valida los recordtypes para borrar las opportunities
    * Desarrollador: Denis Aranda
    * Fecha: 06/30/2013
    * Modo: before delete
    *****************************************************************************************/
    
    public static void ValidationOnDelete(List<Opportunity> triggerNew){
        
        Set<String> idsOfProfiles = new Set<String>();
        idsOfProfiles.add(LAT_GlobalProfileCache.getStandardAdminProfileId());
        idsOfProfiles.add(LAT_GlobalProfileCache.getProfileIdByName('LAT_MX_System Administrator'));
        
        for(Opportunity opp: triggerNew){
            if(opp.RecordTypeId != Global_RecordTypeCache.getRtId('Opportunity' + 'LAT_MX_OPP_NewOrder') && !idsOfProfiles.contains(Userinfo.getProfileId())){
                opp.addError(Label.LAT_MX_AP01_OPP_001);
            }
        }
    }

    //MIGRATED 04/11/2016
    public static void ValidationOnDelete(List<LAT_Opportunity__c> triggerNew){
        
        Set<String> idsOfProfiles = new Set<String>();
        idsOfProfiles.add(LAT_GlobalProfileCache.getStandardAdminProfileId());
        idsOfProfiles.add(LAT_GlobalProfileCache.getProfileIdByName('LAT_SystemAdministrator'));
        
        for(LAT_Opportunity__c opp: triggerNew){
            if(opp.RecordTypeId != Global_RecordTypeCache.getRtId('LAT_Opportunity__c' + 'LAT_MX_OPP_NewOrder') && !idsOfProfiles.contains(Userinfo.getProfileId())){
                opp.addError(Label.LAT_MX_AP01_OPP_001);
            }
        }
    }

    /*****************************************************************************************
    * Nombre del metodo: ChangeOwnerIfCoordinatorCRM
    * Descripcion: Cambia el Owner del Pedido si el que lo crea es un Coordinador de CRM
    * Desarrollador: Javier Fagian
    * Fecha: 08/12/2017
    * Modo: before insert
    *****************************************************************************************/
    
    public static void ChangeOwnerIfCoordinatorCRM(List<LAT_Opportunity__c> triggerNew){
        //List<LAT_Opportunity__c> listOpp = [SELECT Id, Owner.ProfileId, OwnerId FROM LAT_Opportunity__c WHERE Id IN: NewMap.keySet()];
        Set<Id> ownerIds = new Set<Id>();
        for (LAT_Opportunity__c opp : triggerNew) {
            ownerIds.add(opp.OwnerId);
        }
        Map<Id, User> users = new Map<Id, User>([SELECT id, Name, ManagerId, ProfileId FROM User WHERE Id IN: ownerIds]);
        for (LAT_Opportunity__c opp : triggerNew) {
            System.debug('%%%%%% opp.Owner.ProfileId : '+users.get(opp.OwnerId).ProfileId);
            System.debug('%%%%%% LAT_GlobalProfileCache.getProfileIdByName(LAT_MX2_Coordinador_CRM) : '+LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_Coordinador_CRM'));
            if (users.get(opp.OwnerId).ProfileId == LAT_GlobalProfileCache.getProfileIdByName('LAT_MX2_Coordinador_CRM')) {
                System.debug('%%%%%% entramamos');

                if (users.get(opp.OwnerId).ManagerId != null) {
                    opp.OwnerId = users.get(opp.OwnerId).ManagerId;
                }
            }
        }

    }




}