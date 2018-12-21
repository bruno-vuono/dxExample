/*******************************************************************************
*                           Company: ValueNet
*-------------------------------------------------------------------------------
*   Clase que contiene los triggers PRB del objeto Case
*******************************************************************************/
 /********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 02/11/2016
*
********************************************************************************/

public without sharing class LAT_BR_AP01_Case {
    /*********************************************************************************************************
    * Nombre del metodo: originalOwner
    * Descripcion: Cambia el Owner para el creador
    * Desarrollador: Rodrigo Aguirre
    * Fecha: 01/10/2013
    * Modo: before update
    ********************************************************************************************************/
    public static void originalOwner(Map<Id, Case> triggerNewMap, Map<Id, Case> triggerOldMap){
        for(Case c: triggerNewMap.values()){
             system.debug('1 '+c.type+'2 '+c.Status );
            if(triggerNewMap.get(c.Id).Status == 'Reprovado' && triggerNewMap.get(c.Id).Type == 'Alteração - Cadastro de cliente'){
                c.OwnerId = c.CreatedById;
            }
        }
    }
    
    /*********************************************************************************************************
    * Nombre del metodo: updateStatusNovoCadastroCliente
    * Descripcion: Change the status field of the client to "Novo Cadastro" if meets a set of conditions
    * Desarrollador: Nicolas Javier Romero
    * Fecha: 28/11/2013
    * Modo: before update
    ********************************************************************************************************/
    public static void updateStatusNovoCadastroCliente(List<Case> triggerNew){
        Set<Id> setIdAcc = new Set<Id>();
        

        for(Case caso :triggerNew){
            if(caso.Reason == 'Alt. tipo cliente' && (caso.Status == 'Fechado e cancelado' || caso.Status == 'Fechado e resolvido' || caso.Status == 'Reprovado')){
                setIdAcc.add(caso.AccountId);
            }
        }
        
        Map<Id, Account> mapIdAcc = new Map<Id, Account>([SELECT Id, Type, Status__c FROM Account WHERE Id IN: setIdAcc]);
        Id controladoriaId;
        try{controladoriaId = [SELECT Id FROM Group WHERE Name='Controladoria' AND Type='Queue'].Id;}catch(Exception e){}
        
        List<Account> listAccUpd = new List<Account>();
        for(Case caso :triggerNew){
             system.debug(Logginglevel.ERROR, '1 '+caso.type+'2 '+caso.Status );
            if(caso.Reason == 'Alt. tipo cliente' && (caso.Status == 'Fechado e cancelado' || caso.Status == 'Fechado e resolvido')){
                system.debug(Logginglevel.ERROR , 'caso.OwnerId: '+caso.OwnerId);
                if(caso.OwnerId == controladoriaId && mapIdAcc.containsKey(caso.AccountId) && mapIdAcc.get(caso.AccountId).Type == 'Outros'){
                    Account acc = mapIdAcc.get(caso.AccountId);
                    acc.Status__c = 'Novo Cadastro';
                    listAccUpd.add(acc);
                }
            }
        }
        
        system.debug('listAccUpd: '+listAccUpd);
        
        List<DataBase.saveresult> results = DataBase.update(listAccUpd, false);
        system.debug('results: '+results);
        for(DataBase.saveresult result: results){
            if(!result.isSuccess()){
                for(Database.Error error: result.getErrors()){
                    triggerNew[0].addError('Ocorreu um erro ao tentar atualizar o cliente: '+error.getMessage());
                }
            }
        }
    }
    
    /*********************************************************************************************************
    * Nombre del metodo: updateStatusCaseClose
    * Descripcion: 
    * Desarrollador: Bruno Vuono
    * Fecha: 10/07/2014
    * Modo: before update
    ********************************************************************************************************/
    public static void UpdateStatusCaseClose(List<Case> triggerNew) {

        QueueSobject controladoriaQueue;

        // TODO: move
        List<QueueSobject> tmpQueues = [Select id,Queue.id from QueueSobject where Queue.Name = 'Controladoria' limit 1];
        if(tmpQueues != null && tmpQueues.size() > 0){
            controladoriaQueue = tmpQueues[0];
            map<Id, RecordType> mapIdRtCase = new map<Id, RecordType>(Global_RecordTypeCache.getRtList('Case'));

            set<Id> setParentAcc = new set<Id>();
            for (Case cas : triggerNew ){
                if ('Solicitação de inativação de cliente'.equals(cas.Reason) && 'Fechado e resolvido'.equals(cas.Status) && mapIdRtCase.get(cas.RecordTypeid).DeveloperName == 'Alteracao_cadastro_de_clientes'  && cas.ownerId == controladoriaQueue.Queue.id){
                    setParentAcc.add(cas.AccountId);
                }
            }
            if(!setParentAcc.isEmpty()){
                List<Account> Accounts = [SELECT Id, Status__c,Type, RecordTypeId FROM Account WHERE Id IN: setParentAcc];
                for(Account con: Accounts){
                    con.Rating = 'Cliente inativo';
                    con.Status__c = 'Aprovado - Aguardando retorno do JDE';

                }
                update Accounts;
            }
        }
    
    }
    
    /*********************************************************************************************************
    * Nombre del metodo: updateStatusAccount
    * Descripcion: 
    * Desarrollador: Francisco Orzabal
    * Fecha: 12/06/2014
    * Modo: before update
    ********************************************************************************************************/
    public static void updateStatusAccount(List<Case> triggerNew) {
    
        Set<Id> setOwnerIds = new Set<Id>();
        Set<Id> setAccIds = new Set<Id>();
        Map<String, String> mapQueues;
        Map<Id, Account> mapAccs;
        List<Queuesobject> lQueueList;
        List<Account> listAccToUpdate;
        
        for (Case c : triggerNew) {
            setOwnerIds.add(c.OwnerId);
            setAccIds.add(c.AccountId);
        }
        
        lQueueList = [SELECT Id, queue.Name, QueueId 
                        FROM QueueSobject 
                        WHERE QueueId =: setOwnerIds];
        
        mapQueues = new Map<String, String>();      
        for (Queuesobject q : lQueueList) {
            mapQueues.put(q.QueueId, q.queue.name); 
        }           
        
        mapAccs = new Map<Id, Account>([SELECT Id, Status__c, Type, RecordTypeId, Channel__c FROM Account WHERE Id IN: setAccIds]);
        
        listAccToUpdate = new List<Account>();
        
        for (Case c : triggerNew) {

            if(mapAccs.get(c.AccountId).Status__c == 'Em análise - Crédito e Cobrança'){
                    listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Em análise - Controladoria'));

                }else{
                   listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Em análise - Crédito e Cobrança'));
                }  
         
            if (mapQueues.containsKey(c.OwnerId) && mapQueues.get(c.OwnerId) == 'Customer service' && c.Status == 'Fechado e resolvido') {
                // OFF TRADE
                if (mapAccs.get(c.AccountId).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'Off_Trade') 
                        && (mapAccs.get(c.AccountId).Channel__c == 'Off Trade'|| mapAccs.get(c.AccountId).Channel__c == 'Distribution')) {
                    if(c.Type == 'Alteração - Cadastro de cliente'){
                        listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Aprovado - Aguardando retorno do JDE'));

                    } else {
                       listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Em análise - Crédito e Cobrança'));

                    }                
                // ON TRADE
                } else if (mapAccs.get(c.AccountId).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'On_Trade') && mapAccs.get(c.AccountId).Channel__c == 'On Trade' && mapAccs.get(c.AccountId).Type == 'LD') {
                    
                    listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Em análise - Controladoria'));
                }

                else if (mapAccs.get(c.AccountId).Channel__c == 'Eventos' && mapAccs.get(c.AccountId).Type == 'LD') {
                    /*
                    System.debug('Enter1');
                    if (mapAccs.get(c.AccountId).Status__c == 'Em análise - Crédito e Cobrança')
                    {
                       listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Em análise - Controladoria'));
                    }
                    else{
                       listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Em análise - Crédito e Cobrança'));

                    }  
                    */
                }
                
            } else if (mapQueues.containsKey(c.OwnerId) && mapQueues.get(c.OwnerId) == 'Controladoria' && c.Status == 'Fechado e resolvido'&&  mapAccs.get(c.AccountId).Channel__c != 'Eventos'){
                   listAccToUpdate.add(new account(Id = c.AccountId, Status__c = 'Aprovado - Aguardando retorno do JDE'));

            }
                    
        }
                
        if (!listAccToUpdate.isEmpty()) {
            DataBase.update(listAccToUpdate);
        }
    
    }
    
    /*********************************************************************************************************
    * Nombre del metodo: shareWithAccountOwner
    * Descripcion: Comparte el caso con el owner de la cuenta. 
    * Desarrollador: Francisco Orzabal
    * Fecha: 12/06/2014
    * Modo: After insert
    ********************************************************************************************************/
    public static void shareWithAccountOwner(List<Case> triggerNew) {
        
        Set<Id> setAccIds = new Set<Id>();
        Map<Id, Account> mapAccs;
        List<CaseShare> listCaseShare = new List<CaseShare>();
        
        for(Case c : triggerNew){
            setAccIds.add(c.AccountId);            
        }
        
        mapAccs = new Map<Id, Account>([SELECT Id, OwnerId, Status__c
                                        FROM Account 
                                        WHERE Id IN: setAccIds]);
        
        system.debug(Logginglevel.ERROR, 'mapAccs: ' + mapAccs);
        if(!mapAccs.isEmpty()){
            for(Case c : triggerNew){
                CaseShare share = new CaseShare();
                share.CaseId = c.Id;
                share.UserOrGroupId = mapAccs.containskey(c.AccountId) && mapAccs.get(c.AccountId).OwnerId != null ? mapAccs.get(c.AccountId).OwnerId: '';
                share.CaseAccessLevel = 'Read';                                                           
                listCaseShare.add(share);
            }
                    
            if(!listCaseShare.isEmpty()){
                DataBase.insert(listCaseShare, false);
            }
        }
    }

    //MIGRATED 02/11/2016 
    public static void originalOwner(Map<Id, LAT_Case__c> triggerNewMap, Map<Id, LAT_Case__c> triggerOldMap){
        for(LAT_Case__c c: triggerNewMap.values()){
             system.debug('1 '+c.LAT_type__c+'2 '+c.LAT_Status__c );
            if(triggerNewMap.get(c.Id).LAT_Status__c == 'Reprovado' && triggerNewMap.get(c.Id).LAT_Type__c == 'Alteração - Cadastro de cliente'){
                c.OwnerId = c.CreatedById;
            }
        }
    }
    
    //MIGRATED 02/11/2016 
    public static void updateStatusNovoCadastroCliente(List<LAT_Case__c> triggerNew){
        Set<Id> setIdAcc = new Set<Id>();
        
        for(LAT_Case__c caso :triggerNew){
            if(caso.LAT_Reason__c == 'Alt. tipo cliente' && (caso.LAT_Status__c == 'Fechado e cancelado' || caso.LAT_Status__c == 'Fechado e resolvido' || caso.LAT_Status__c == 'Reprovado')){
                setIdAcc.add(caso.LAT_Account__c);
            }
        }
        
        Map<Id, Account> mapIdAcc = new Map<Id, Account>([SELECT Id, Type, Status__c FROM Account WHERE Id IN: setIdAcc]);
        Id controladoriaId;
        try{controladoriaId = [SELECT Id FROM Group WHERE Name='Controladoria' AND Type='Queue'].Id;}catch(Exception e){}
        
        List<Account> listAccUpd = new List<Account>();
        for(LAT_Case__c caso :triggerNew){
             system.debug(Logginglevel.ERROR, '1 '+caso.LAT_type__C+'2 '+caso.LAT_Status__c );
            if(caso.LAT_Reason__c == 'Alt. tipo cliente' && (caso.LAT_Status__c == 'Fechado e cancelado' || caso.LAT_Status__c == 'Fechado e resolvido')){
                system.debug(Logginglevel.ERROR , 'caso.OwnerId: '+caso.OwnerId);
                if(caso.OwnerId == controladoriaId && mapIdAcc.containsKey(caso.LAT_Account__C) && mapIdAcc.get(caso.LAT_Account__C).Type == 'Outros'){
                    Account acc = mapIdAcc.get(caso.LAT_Account__C);
                    acc.Status__c = 'Novo Cadastro';
                    listAccUpd.add(acc);
                }
            }
        }
        
        system.debug('listAccUpd: '+listAccUpd);
        
        List<DataBase.saveresult> results = DataBase.update(listAccUpd, false);
        system.debug('results: '+results);
        for(DataBase.saveresult result: results){
            if(!result.isSuccess()){
                for(Database.Error error: result.getErrors()){
                    triggerNew[0].addError('Ocorreu um erro ao tentar atualizar o cliente: '+error.getMessage());
                }
            }
        }
    }

    //MIGRATED 02/11/2016 
    public static void UpdateStatusCaseClose(List<LAT_Case__c> triggerNew) {

        QueueSobject controladoriaQueue;
        List<QueueSobject> tmpQueues = [Select id,Queue.id from QueueSobject where Queue.Name = 'Controladoria' limit 1];
        if(tmpQueues != null && tmpQueues.size() > 0){
            controladoriaQueue = tmpQueues[0];
            map<Id, RecordType> mapIdRtCase = new map<Id, RecordType>(Global_RecordTypeCache.getRtList('LAT_Case__c'));

            set<Id> setParentAcc = new set<Id>();
            for (LAT_Case__c cas : triggerNew ){
                if ('Solicitação de inativação de cliente'.equals(cas.LAT_Reason__c) && 'Fechado e resolvido'.equals(cas.LAT_Status__c) && mapIdRtCase.get(cas.RecordTypeid).DeveloperName == 'Alteracao_cadastro_de_clientes'  && cas.ownerId == controladoriaQueue.Queue.id){
                    setParentAcc.add(cas.LAT_Account__c);
                }
            }
            if(!setParentAcc.isEmpty()){
                List<Account> Accounts = [SELECT Id, Status__c,Type, RecordTypeId FROM Account WHERE Id IN: setParentAcc];
                for(Account con: Accounts){
                    con.Rating = 'Cliente inativo';
                    con.Status__c = 'Aprovado - Aguardando retorno do JDE';

                }
                update Accounts;
            }
        }
    
    }
    //MIGRATED 02/11/2016 
    public static void updateStatusAccount(List<LAT_Case__c> triggerNew) {
    
        Set<Id> setOwnerIds = new Set<Id>();
        Set<Id> setAccIds = new Set<Id>();
        Map<String, String> mapQueues;
        Map<Id, Account> mapAccs;
        List<Queuesobject> lQueueList;
        List<Account> listAccToUpdate;
        
        for (LAT_Case__c c : triggerNew) {
            setOwnerIds.add(c.OwnerId);
            setAccIds.add(c.LAT_Account__c);
        }
        
        lQueueList = [SELECT Id, queue.Name, QueueId 
                        FROM QueueSobject 
                        WHERE QueueId =: setOwnerIds];
        
        mapQueues = new Map<String, String>();      
        for (Queuesobject q : lQueueList) {
            mapQueues.put(q.QueueId, q.queue.name); 
        }           
        
        mapAccs = new Map<Id, Account>([SELECT Id, Type, Status__c, RecordTypeId, Channel__c,LAT_Account__r.LAT_DirectSale__c FROM Account WHERE Id IN: setAccIds]);
        
        listAccToUpdate = new List<Account>();
        
        for (LAT_Case__c c : triggerNew) {
        
            if (mapQueues.containsKey(c.OwnerId) && mapQueues.get(c.OwnerId) == 'Crédito e Cobrança' && c.LAT_Status__c == 'Fechado e resolvido') {
               
               // Case of trade direct sales
                if(c.LAT_Type__c == 'Alteração - Cadastro de cliente'){
                    //verificar con Leo si en este caso no hay que hacer nada
                    //listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Aprovado - Aguardando retorno do JDE',Checked_over_Sales_Administration__c = true));
                     system.debug('Enter Here Status1 entramos');
                } else {
                    //Es un alta de cliente  (NOVO CADASTRO)
                    if (mapAccs.get(c.LAT_Account__c).Status__c == 'Em análise - Crédito e Cobrança' && mapAccs.get(c.LAT_Account__c).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'On_Trade')) {
                        system.debug('Enter Here solo ontrade' + mapAccs.get(c.LAT_Account__c).Status__c);
                        listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em aprovação - Financeiro', Checked_over_Credit_and_collection__c = true));

                    } else if(mapAccs.get(c.LAT_Account__c).Status__c == 'Em análise - Crédito e Cobrança' && mapAccs.get(c.LAT_Account__c).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'Off_Trade')) {
                        system.debug('Enter Here StatusSoloOffTrade' + mapAccs.get(c.LAT_Account__c).Status__c);
                        listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em aprovação - Financeiro', Checked_over_Credit_and_collection__c = true));

                     } else if(mapAccs.get(c.LAT_Account__c).Status__c == 'Em análise - Crédito e Cobrança' && mapAccs.get(c.LAT_Account__c).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'Eventos') && mapAccs.get(c.LAT_Account__c).Channel__c == 'Eventos' && mapAccs.get(c.LAT_Account__c).Type == 'LD') {
                        listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Controladoria'));

                    }else{
                        system.debug('Enter Here else' + mapAccs.get(c.LAT_Account__c).Status__c);
                           listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Crédito e Cobrança'));
                    }
                }

            } else if (mapQueues.containsKey(c.OwnerId) && mapQueues.get(c.OwnerId) == 'Customer service' && c.LAT_Status__c == 'Fechado e resolvido') {
                
                // OFF TRADE
                if (mapAccs.get(c.LAT_Account__c).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'Off_Trade') && (mapAccs.get(c.LAT_Account__c).Channel__c == 'Off Trade'|| mapAccs.get(c.LAT_Account__c).Channel__c == 'Distribution')) {
                    if(c.LAT_Type__c == 'Alteração - Cadastro de cliente'){
                        //listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Aprovado - Aguardando retorno do JDE',Checked_over_Sales_Administration__c = true));
                        system.debug('Enter Here Status1');
                    }else{
                        system.debug('Enter Here Status2');
                       listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Crédito e Cobrança', Checked_over_Sales_Administration__c = true));

                    }                
                // ON TRADE If the direct sales checkbox is setted, change status to credito y cobranca
                } else if (mapAccs.get(c.LAT_Account__c).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'On_Trade')
                  && mapAccs.get(c.LAT_Account__c).LAT_Account__r.LAT_DirectSale__c 
                  && mapAccs.get(c.LAT_Account__c).Status__c != 'Em análise - Crédito e Cobrança'){
                    system.debug('Enter Here Status3');
                    listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Crédito e Cobrança', Checked_over_Sales_Administration__c = true));
                
                } else if (mapAccs.get(c.LAT_Account__c).RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'On_Trade') && mapAccs.get(c.LAT_Account__c).Channel__c == 'On Trade' && mapAccs.get(c.LAT_Account__c).Type == 'LD' && !mapAccs.get(c.LAT_Account__c).LAT_Account__r.LAT_DirectSale__c) {
                    system.debug('Enter Here Status4');

                    // if there is no Credito Cobranca status controladoria
                    listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Controladoria',Checked_over_Sales_Administration__c = true));
                } else if (mapAccs.get(c.LAT_Account__c).Channel__c == 'Eventos' && mapAccs.get(c.LAT_Account__c).Type == 'LD') {
                    system.debug('Enter Here Status5');
                     
                     System.debug('Enter2');
                     if(mapAccs.get(c.LAT_Account__c).Status__c == 'Em análise - Crédito e Cobrança'){
                        listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Controladoria'));

                    }else{
                       listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Em análise - Crédito e Cobrança', Checked_over_Sales_Administration__c = true));
                    }  
                    
                } 
                
            }  else if (mapQueues.containsKey(c.OwnerId) && mapQueues.get(c.OwnerId) == 'Controladoria' && c.LAT_Status__c == 'Fechado e resolvido'){//&&  mapAccs.get(c.LAT_Account__c).Channel__c != 'Eventos'){
                   listAccToUpdate.add(new account(Id = c.LAT_Account__c, Status__c = 'Aprovado - Aguardando retorno do JDE'));

            }
                    
        }
                
        if (!listAccToUpdate.isEmpty()) {
            DataBase.update(listAccToUpdate);
        }
    
    }


    //MIGRATED 02/11/2016 
    public static void shareWithAccountOwner(List<LAT_Case__c> triggerNew) {
        
        Set<Id> setAccIds = new Set<Id>();
        Map<Id, Account> mapAccs;
        List<LAT_Case__Share> listCaseShare = new List<LAT_Case__Share>();
        
        for(LAT_Case__c c : triggerNew){
            setAccIds.add(c.LAT_Account__c);            
        }
        
        mapAccs = new Map<Id, Account>([SELECT Id, OwnerId, Status__c
                                        FROM Account 
                                        WHERE Id IN: setAccIds]);
        
        system.debug(Logginglevel.ERROR, 'mapAccs: ' + mapAccs);
        if(!mapAccs.isEmpty()){
            for(LAT_Case__c c : triggerNew){
                LAT_Case__Share share = new LAT_Case__Share();
                share.ParentId = c.Id;
                share.UserOrGroupId = mapAccs.containskey(c.LAT_Account__c) && mapAccs.get(c.LAT_Account__c).OwnerId != null ? mapAccs.get(c.LAT_Account__c).OwnerId: '';
                share.AccessLevel = 'Read';                                                           
                listCaseShare.add(share);
            }
                    
            if(!listCaseShare.isEmpty()){
                DataBase.insert(listCaseShare, false);
            }
        }
    }
    //MIGRATED 02/11/2016 
    public static void shareWithAccountOwner(Map<Id,LAT_Case__c> triggerNew, Map<Id,LAT_Case__c> triggerOld) {
        List<LAT_Case__Share> listCaseShare = new List<LAT_Case__Share>();
        List<String> accIds = new List<String>();
        Map<String, String> accountOwners = new Map<String,String>();
      
        for(LAT_Case__c cs : triggerNew.values()){
            if(cs.LAT_Account__c != null){
                accIds.add(cs.LAT_Account__c);
            }
        }

        for(Account acc: [Select id, OwnerId from Account where id in : accIds]){
            accountOwners.put(acc.id, acc.OwnerId);
        }



        for(LAT_Case__c lcas : triggerNew.values()){
            if(triggerOld.get(lcas.id).ownerId != lcas.ownerId){
                if(accountOwners.get(lcas.LAT_Account__c) != null && accountOwners.get(lcas.LAT_Account__c) == triggerOld.get(lcas.id).ownerId){
                    LAT_Case__Share share = new LAT_Case__Share();
                    share.ParentId = lcas.Id;
                    share.UserOrGroupId = accountOwners.get(lcas.LAT_Account__c);
                    share.AccessLevel = 'Edit';    
                    listCaseShare.add(share);         
                }
            }
        }
        
         if(!listCaseShare.isEmpty()){
            DataBase.insert(listCaseShare, false);
        }
    }


}