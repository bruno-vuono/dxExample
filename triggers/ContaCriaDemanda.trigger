/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
********************************************************************************
* A partir de conta são criadas demandas no objeto CASOS.
* NAME: ContaCriaDemanda.trigger
* AUTHOR:                                           DATE: 11/06/2012
*
* MAINTENANCE: INSERIDO LÓGICA COM RecordTypeForTest.
* E.S. 11/06/2014 
* Cambio 1: Linea 82 modificada por RFC Segmentacion BR
* Cambio 2: Lineas 85-88 comentadas por RFC Segmentacion BR
* AUTHOR: CARLOS CARVALHO                           DATE: 07/01/2013 
*******************************************************************************/
trigger ContaCriaDemanda on Account (after update) { 

//    Check if this trigger is bypassed by SESAME (data migration Brazil)
if((UserInfo.getProfileId()!='00eM0000000QNYPIA4') && (UserInfo.getProfileId()!= '00eD0000001AnFlIAK')) {
    
    Set< Id > setIdsRecType = Global_RecordTypeCache.getRtIdSet('Account', new set<String>{'Eventos', 'Off_Trade', 'On_Trade'});
    String idRecTypeTit = Global_RecordTypeCache.getRtId('Titulo__c'+'BRA_Standard');
    
    Map <String,Account> mapIdAcc = new Map<String,account>();
    Set<id> idAccs = New Set<id>();
    
    integer j=0;
    for(Account a:Trigger.new) {
         if( setIdsRecType.contains( a.RecordTypeId )){  
            if(a.Overdue__c && !trigger.old[j].Overdue__c){
                idAccs.add(a.id);
                mapIdAcc.put(a.id , a);
            }   
            j++; 
        }
    }
    
    //Si hay algun registro de BR sigue
    if(j==0){return;}
    
    List<Titulos__c>  titulos = [Select Id,Cliente__c from Titulos__c where Cliente__c IN: idAccs ];
    Map <String,Titulos__c> mapIdAccTit = new Map <String,Titulos__c>();

    
    for ( Titulos__c tit : titulos ){
        mapIdAccTit.put( tit.Cliente__c , tit );
    }
    
    
    List<Task> taskToInsert= new list<Task>();
    
    
        // PROCESSO DE INADIMPLÊNCIA
        // Se cliente ficou inadimplente e tem títulos inadimplentes, abre caso automático
        
        for( String key:mapIdAccTit.keySet() ){ 
            Task task = new Task();
            task.CallObject = 'Cliente inadimplente';
            task.WhatId = key;
            task.OwnerId = mapIdAcc.get(key).OwnerID;
            task.Subject = 'Cliente inadimplente';
            task.priority= 'Normal';
            task.status = 'Não iniciado';
            task.description = label.descriptionAccTask_BR + '( ' + mapIdAcc.get(key).Client_code_AN8__c + ' - ' + mapIdAcc.get(key).Name + ' )' ;
            task.ActivityDate = Date.Today() + 1;
            taskToInsert.add(task);
        }
    
    insert taskToInsert;
    
    
    
    
    integer i=0;
    for(Account a:Trigger.new) {
        if( !setIdsRecType.contains( a.RecordTypeId ) ){i++; continue;} 
        // PROCESSO DE CLIENTES:
        // Se status foi alterado, abre caso  (demanda) para a área correpondente
        if(a.Type == 'Outros'){i++; continue;}
        if(a.Status__c == 'Em análise - Customer Service' && trigger.old[i].Status__c <> 'Em análise - Customer Service'){
            DemandaInterna.criademanda('Customer service', null, 'Novo cadastro de cliente', a.id, null,
                'Cadastro de clientes','Análise/complementação de dados', 
                'Análise e complementação de dados de novo cadastro de cliente','', null, null);
        } else if (a.RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'Off_Trade')   && (a.Status__c == 'Em análise - Crédito e Cobrança' && trigger.old[i].Status__c <> 'Em análise - Crédito e Cobrança')){
            DemandaInterna.criademanda('Crédito e cobrança', null, 'Novo cadastro de cliente', a.id, null,
                'Cadastro de clientes','Análise/complementação de dados', 
                'Análise e complementação de dados de novo cadastro de cliente','', null, null);
        }
        else if (a.RecordTypeId == Global_RecordTypeCache.getRtId('Account' + 'Eventos')   && (a.Status__c == 'Em análise - Crédito e Cobrança' && trigger.old[i].Status__c <> 'Em análise - Crédito e Cobrança')){
            DemandaInterna.criademanda('Crédito e cobrança', null, 'Novo cadastro de cliente', a.id, null,
                'Cadastro de clientes','Análise/complementação de dados', 
                'Análise e complementação de dados de novo cadastro de cliente','', null, null);
        /*}else if(a.Status__c == 'Em análise - Planejamento Comercial' && trigger.old[i].Status__c <> 'Em análise - Planejamento Comercial'){
            DemandaInterna.criademanda('Planejamento comercial', null, 'Novo cadastro de cliente', a.id, null,
                'Cadastro de clientes','Análise/complementação de dados', 
                'Análise e complementação de dados de novo cadastro de cliente','', null, null);*/
        } else if(a.Status__c == 'Em análise - Controladoria' && trigger.old[i].Status__c <> 'Em análise - Controladoria'){
            DemandaInterna.criademanda('Controladoria', null, 'Novo cadastro de cliente', a.id, null,
                'Cadastro de clientes','Análise/complementação de dados', 
                'Análise e complementação de dados de novo cadastro de cliente','', null, null);           
        } 
        
        
        i++;
    }
 }
}