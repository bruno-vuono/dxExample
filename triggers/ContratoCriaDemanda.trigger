/********************************************************************************
*                         Copyright 2012 - Cloud2b
********************************************************************************
* Cria demandas no objeto CASOS a partir de contrato. Utilizado para fasear o 
* contrato
*
* NAME: ContratoCriaDemanda.trigger
* AUTHOR:                                               DATE: 
*
* MAINTENANCE: INSERIDO FUNCIONALIDADE QUE VALIDA O ID DO TIPO DE REGISTRO DOS OBJETOS.
* AUTHOR: CARLOS CARVALHO                               DATE: 07/01/2013
********************************************************************************/
trigger ContratoCriaDemanda on LAT_Contract__c (after update) {
 
  // Parâmetros da classe criademanda: 
    //    Nome da fila (pode ser passado como NULL mas então deve-se passar o Id do usuário)
    //    Id do usuário (se passou o nome da fila, não precisa passar este)
    //    Nome do Tipo de registro
    //    Id da conta
    //    Id do contato (opcional)
    //    Tipo
    //    Motivo
    //    Assunto
    //    Descricao
    //    Id do contrato
//    Check if this trigger is bypassed by SESAME (data migration Brazil)
if((UserInfo.getProfileId()!='00eM0000000QNYPIA4') && (UserInfo.getProfileId()!= '00eD0000001AnFlIAK')) {
    
    String idRecTypeUDC = Global_RecordTypeCache.getRtId('UDC__c'+'BRA_Standard');
    
    //Recupera os Ids dos tipos de registro do objeto Account
    Set< Id > setRecTypeAcc = Global_RecordTypeCache.getRtIdSet('Account', new set<String>{'Eventos', 'Off_Trade', 'On_Trade'});
    
    //Recupera os Ids dos tipos de registro do objeto LAT_Contract__c
    Set< Id > setRecTypeLatCon = Global_RecordTypeCache.getRtIdSet('LAT_Contract__c', 
    																new set<String>{
    																	'Alteracao_de_contrato_OFF',
    																	'Off_Trade',
    																	'On_Trade',
    																	'Alteracao_de_contrato_on',
    																	'AlteracaoContratoAtivoOffTrade',
    																	'AlteracaoContratoAtivoOnTrade',
    																	'Alteracao_de_contrato_aprovada_Off_Trade',
    																	'Alteracao_de_contrato_aprovada_On_Trade',
    																	'Assinatura_de_contrato_Off_Trade',
    																	'Assinatura_de_contrato_Off_Trade_aprovado',
    																	'Assinatura_de_contrato_Off_Trade_ativo',
    																	'Assinatura_de_contrato',
    																	'Assinatura_de_contrato_aprovada',
    																	'Assinatura_de_contrato_com_aprovacao_Off_Trade',
    																	'Assinatura_de_contrato_com_aprovacao',
    																	'Ativacao_de_contrato',
    																	'Cancelamento_de_contrato_Off_Trade',
    																	'Cancelamento_de_contrato_On_Trade',
    																	'Cancelamento_de_contrato_aprovado_off',
    																	'Cancelamento_de_contrato_aprovado_on'
    																});
    
    List< String > lContratoOrigianlIDs = new List< String >();
    List< String > lManagerIDs = new List< String >();
    List< String > lAccountIDs = new List< String >();
    for(LAT_Contract__c c:Trigger.new)
    {
      if( !setRecTypeLatCon.contains( c.RecordTypeId ) ) continue;
      
      if ( setRecTypeLatCon.contains(c.RecordtypeId) && c.Contrato_original__c != null )
        lContratoOrigianlIDs.add( c.Contrato_original__c );
      lManagerIDs.add( c.OwnerId );
      lAccountIDs.add( c.Account__c);
    }
    
    if(lContratoOrigianlIDs.IsEmpty() && lManagerIDs.IsEmpty() && lAccountIDs.IsEmpty()){
    	return;
    }
    
    integer i=0;
    List<UDC__c> listUDCRegionais = new List<UDC__c>();
    Map<String,String> mapUDCRegionais = new Map<String, String>();
    listUDCRegionais = [SELECT Id, CodDefUsuario__c FROM UDC__c WHERE CodProd__c = '01' 
        AND CodUs__c = '01' AND RecordTypeId =: idRecTypeUDC];
        
    for(UDC__c udc:listUDCRegionais)
    {
        if(udc.CodDefUsuario__c == '1'){
            mapUDCRegionais.put(udc.CodDefUsuario__c, 'Regional Norte/Nordeste');
        }else if(udc.CodDefUsuario__c == '2'){
            mapUDCRegionais.put(udc.CodDefUsuario__c, 'Regional São Paulo');
        }else if(udc.CodDefUsuario__c == '3'){
        mapUDCRegionais.put(udc.CodDefUsuario__c, 'Regional Centro Oeste');
      }else if(udc.CodDefUsuario__c == '4'){
        mapUDCRegionais.put(udc.CodDefUsuario__c, 'Regional Sul');
      }else if(udc.CodDefUsuario__c == '5'){
        mapUDCRegionais.put(udc.CodDefUsuario__c, 'KA');
      }else if(udc.CodDefUsuario__c == '6'){
        mapUDCRegionais.put(udc.CodDefUsuario__c, 'Canais Especiais');
      }
    }
    
    // Contrato Original - Rogerio
    List< LAT_Contract__c > lContratoOriginalList = new List< LAT_Contract__c >();
    if(lContratoOrigianlIDs.IsEmpty()){
    	lContratoOriginalList = [ SELECT Id, Status__c FROM LAT_Contract__c WHERE id=:lContratoOrigianlIDs AND RecordTypeId =: setRecTypeLatCon];
    }
    Map< String, LAT_Contract__c > lContratoOriginalMap = new Map< String, LAT_Contract__c >();
    for ( LAT_Contract__c c : lContratoOriginalList )
      lContratoOriginalMap.put( c.ID, c );
      
    // Manager - Rogerio
    List< User > lManagerList = [SELECT ManagerId FROM User WHERE Id = :lManagerIDs ];
    Map< String, String > lManagerMap = new Map< String, String >();
    for ( User u : lManagerList )
      lManagerMap.put( u.id, u.ManagerId );
      
    // Account - Rogerio
    List< Account > lAccountList = [ SELECT Channel__c, Regional__r.CodDefUsuario__c, Regional_Manager__r.C_digo_JDE__c FROM Account WHERE Id = :lAccountIDs AND RecordTypeId =: setRecTypeAcc];
    Map< id, Account > lAccountMap = new Map< id, Account >();
    for ( Account acc : lAccountList )
      lAccountMap.put( acc.id, acc );
    
    //Process to Update
    List< LAT_Contract__c > lContratoOriginalUpdateList = new List< LAT_Contract__c >();
    for(LAT_Contract__c c:Trigger.new) {
      if( !setRecTypeLatCon.contains( c.RecordTypeId ) ) continue;
       
      if ( c.trigger_on__c ) continue;
      
        if ( c.Status__c == 'Ativo' && c.Contrato_original__c != null )
        {
          LAT_Contract__c co = lContratoOriginalMap.get( c.Contrato_original__c );
          co.Status__c = 'Aditado';
          co.trigger_on__c = true;
          lContratoOriginalUpdateList.add( co );
        }
       
        // PROCESSO DE ASSINATURA DE CONTRATOS:
        // Se status foi alterado, abre caso  (demanda) para a área correpondente
        
        Account lAccount = lAccountMap.get( c.Account__c );
        String lCodDef = lAccount.Regional__r.CodDefUsuario__c;
        if ( lCodDef == '7' ) lCodDef = lAccount.Regional_Manager__r.C_digo_JDE__c;
        
        String lFila = mapUDCRegionais.get(lCodDef);
        if ( lFila == null ) { c.addError( 'Regional do cliente inexistente' ); return; }
        

        if(c.Status_do_processo__c == 'Oportunidade aprovada pela PRB' && trigger.old[i].Status_do_processo__c <> 'Oportunidade aprovada pela PRB'){
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - Aprovação de proposta', c.Account__c, null,
                'Assinatura de contrato','Aprovação do cliente', 
                'Solicitar ao cliente aprovação da proposta contratual.','', c.id, null);
        
        } else if(c.Status_do_processo__c == 'Proposta aprovada pelo cliente'  && !(trigger.old[i].status_do_processo__c == 'Proposta aprovada pelo cliente')){
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - coleta de assinatura do cliente', c.Account__c, null,
                'Assinatura de contrato','Coleta de assinatura do cliente', 
                'Imprimir contrato e anexo (3 vias), encaminhar para assinatura, solicitar documentação do cliente. Coletar vias assinadas com o cliente',
                'Solicitar reconhecimento de firma e cópias dos seguintes documentos: Contrato social do cliente, Documentos dos Sócios (RG e CPF) e Comprovante de Inscrição e de situação Cadastral de Pessoa Jurídica. Registrar data para retirada do contrato. Retirar 3 vias do contrato e encaminhar para o coordenador conferir.', c.id, null);
        } else if(c.Status_do_processo__c == 'Contrato assinado encaminhado para o coordenador'  && !(trigger.old[i].status_do_processo__c == 'Contrato assinado encaminhado para o coordenador')){
       // JL 30/5 - Traz o gerente do proprietário do contrato para que a demanda seja atribuída a ele (gerente).
      Id ManagerId = lManagerMap.get( c.OwnerId );
 
            DemandaInterna.criademanda(null, ManagerId, 'Contrato - conferência de documentação', c.Account__c, null,
                'Assinatura de contrato','Conferência de contrato', 
                'Conferência de contrato pendente',' Verificar a entrega das 3 vias do contrato e do Anexo I, Assinaturas e vistos / rubricas em todas as páginas do contrato, Entrega da documentação do cliente', c.ID, null);
       
        } else if(c.Status_do_processo__c == 'Encaminhado para o assistente da regional'  && Trigger.oldMap.get(c.Id).Status_do_processo__c != 'Encaminhado para o assistente da regional'){

      //REG SP    = Regional São Paulo
      //REG NO/NE = Regional Norte/Nordeste
      //REG CO    = Regional Centro Oeste
      //REG SUL   = Regional Sul
            DemandaInterna.criademanda(lFila, null, 'Contrato - Assinatura do procurador', c.Account__c, null,
                'Assinatura de contrato','Assinatura do procurador', 
                'Conferir contrato e encaminhar para assinatura do procurador','Entrega das vias do contrato e do Anexo I, Assinaturas e vistos / rubricas em todas as páginas do contrato e Entrega da documentação do cliente e encaminhar para assinatura do procurador de sua regional.',c.id, null); 

        } else if(c.Status_do_processo__c == 'Encaminhado para o assistente de Trade ou Regional'  && !(trigger.old[i].status_do_processo__c == 'Encaminhado para o assistente de Trade ou Regional')){// && c.Tipo_de_contrato__c == 'Contrato'

      // 'Assistente de On Trade'
    
      String sFila = 'Assistente de Off Trade' ;
      if (lAccount.Channel__c == 'On Trade') {sFila = 'Assistente de On Trade';}
            DemandaInterna.criademanda(sFila,null , 'Contrato - Assinatura da diretoria', c.Account__c, null,
                'Assinatura de contrato','Assinatura da diretoria', 
                'Conferir contrato e encaminhar para assinatura da diretoria','Entrega das vias do contrato e do Anexo I, Assinaturas e vistos / rubricas em todas as páginas do contrato e Entrega da documentação do cliente e encaminhar para assinatura do diretor responsável.',c.id, null);
 
        } else if(c.Status_do_processo__c == 'Assinado e encaminhado para assistente da regional'  && !(trigger.old[i].status_do_processo__c == 'Assinado e encaminhado para assistente da regional')) {
            DemandaInterna.criademanda(lFila, null, 'Contrato', c.Account__c, null,
                'Assinatura de contrato','Encaminhar via assinada para o Consultor', 
                'Encaminhar via assinada para o Consultor','Arquivar uma via do contrato e encaminhar a outra para o consultor.',c.id, null);
         } else if(c.Status_do_processo__c == 'Contrato devolvido para o Consultor'  && !(trigger.old[i].status_do_processo__c == 'Contrato devolvido para o Consultor')) {
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato', c.Account__c, null,
                'Assinatura de contrato','Providenciar correções de documentação', 
                'Providenciar correções de documentação','Providenciar acertos necessários na documentação.',c.id, null);
        } else if(c.Status_do_processo__c == 'Contrato assinado encaminhado para Consultor' && trigger.old[i].Status_do_processo__c <> 'Contrato assinado encaminhado para Consultor'){
            DemandaInterna.criademanda(null,c.OwnerId , 'Contrato - entrega do contrato', c.Account__c, null,
                'Assinatura de contrato','Entregar contrato assinado ao cliente', 
                'Entregar contrato assinado ao cliente','Entregar contrato assinado ao cliente e informar a data de entrega.',c.id, null);
        }    
        
  
        // PROCESSO DE ALTERAÇÃO DE CONTRATOS:
        // Se status foi alterado, abre caso  (demanda) para a área correpondente
    
    // JL 23/mai - ajuste no tipo de registro
        if(c.Status_do_processo__c == 'Aditamento encaminhado para o consultor' && lAccount.Channel__c == 'On Trade' && trigger.old[i].Status_do_processo__c <> 'Aditamento encaminhado para o consultor'){
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - Aprovação de proposta', c.Account__c, null,
                'Alteração de contrato','Impressão do aditamento', 
        'Imprimir aditamento (3 vias), encaminhar para assinatura, solicitar documentação do cliente',
                'Solicitar reconhecimento de firma.', c.id, null);}

      else if((c.Status_do_processo__c == 'Entregue para assinatura do cliente'&& lAccount.Channel__c == 'On Trade' && trigger.old[i].Status_do_processo__c <> 'Entregue para assinatura do cliente') ||
              (c.Status_do_processo__c == 'Aditamento encaminhado para o consultor' && lAccount.Channel__c == 'On Trade' && trigger.old[i].Status_do_processo__c <> 'Aditamento encaminhado para o consultor')){
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - coleta de assinatura do cliente', c.Account__c, null,
                'Alteração de contrato','Assinatura de aditamento',
                'Coletar vias assinadas com o cliente','Retirar 3 vias do aditamento e encaminhar para o coordenador conferir.', c.id, null);}    

      else if((c.Status_do_processo__c == 'Entregue para assinatura do cliente' && lAccount.Channel__c == 'Off Trade' && trigger.old[i].Status_do_processo__c <> 'Entregue para assinatura do cliente') ||
              (c.Status_do_processo__c == 'Aditamento encaminhado para o consultor' && lAccount.Channel__c == 'Off Trade' && trigger.old[i].Status_do_processo__c <> 'Aditamento encaminhado para o consultor')){
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - coleta de assinatura do cliente off', c.Account__c, null,
                'Alteração de contrato','Assinatura de aditamento',
                'Coletar vias assinadas com o cliente','Retirar 3 vias do aditamento e encaminhar para o coordenador conferir.', c.id, null);}    
      
      else if(c.Status_do_processo__c == 'Encaminhado para o coordenador' && trigger.old[i].Status_do_processo__c <> 'Encaminhado para o coordenador'){
            Id ManagerId = lManagerMap.get( c.OwnerId );
            DemandaInterna.criademanda(null, ManagerId , 'Contrato - conferência de documentação', c.Account__c, null,
                'Alteração de contrato','Conferência de aditamento',
        'Conferência de aditamento pendente',
        'Verificar a entrega das 3 vias do aditamento e do Anexo I, Assinaturas e vistos / rubricas em todas as páginas, Entrega da documentação do cliente', c.ID, null);}    
      
      else if(c.Status_do_processo__c == 'Encaminhado para assinaturas' && trigger.old[i].Status_do_processo__c <> 'Encaminhado para assinaturas'){
            DemandaInterna.criademanda(lFila,null , 'Contrato - Assinatura do procurador', c.Account__c, null,
                'Alteração de contrato','Assinatura do procurador', 
                'Conferir aditamento e encaminhar para assinaturas','Entrega das vias do aditamento e do Anexo I, Assinaturas e vistos / rubricas em todas as páginas e entrega da documentação do cliente e encaminhar para assinatura do procurador de sua regional.',c.id,null);}    

    else if(c.Status_do_processo__c == 'Aditamento assinado encaminhado para a Regional' && trigger.old[i].Status_do_processo__c <> 'Aditamento assinado encaminhado para a Regional'){
                String sFila = 'Assistente de Off Trade' ;
          if (lAccount.Channel__c == 'On Trade') {sFila = 'Assistente de On Trade';}
                DemandaInterna.criademanda(sFila,null , 'Contrato - Assinatura da diretoria', c.Account__c, null,
                        'Alteração de contrato','Assinatura da diretoria', 
                        'Conferir contrato e encaminhar para assinatura da diretoria','Entrega das vias do contrato e do Anexo I, Assinaturas e vistos / rubricas em todas as páginas do contrato e Entrega da documentação do cliente e encaminhar para assinatura do diretor responsável.',c.id, null);
 
    }
    else if(c.Status_do_processo__c == 'Aditamento assinado e encaminhado para assistente da regional' && trigger.old[i].Status_do_processo__c <> 'Aditamento assinado e encaminhado para assistente da regional'){
            DemandaInterna.criademanda(lFila,null , 'Contrato', c.Account__c, null,
                'Alteração de contrato','Encaminhar aditamento para o consultor', 
                'Encaminhar aditamento para o consultor','Arquivar uma via do aditamento e encaminhar a outra para o consultor.',c.id, null);}   
    else if(c.Status_do_processo__c == 'Aditamento assinado encaminhado para o consultor' && trigger.old[i].Status_do_processo__c <> 'Aditamento assinado encaminhado para o consultor'){
            DemandaInterna.criademanda(null,c.OwnerId , 'Contrato - entrega do contrato', c.Account__c, null,
                'Alteração de contrato','Entregar aditamento assinado ao cliente', 
                'Entregar aditamento assinado ao cliente','Entregar aditamento assinado ao cliente e informar a data de entrega.',c.id, null);}    
  
      
        // PROCESSO DE CANCELAMENTO DE CONTRATOS:
        // Se status foi alterado, abre caso  (demanda) para a área correpondente
    
    // JL 25/mai
        if(c.Status_do_processo__c == 'Encaminhado para negociação com o cliente' && trigger.old[i].Status_do_processo__c <> 'Encaminhado para negociação com o cliente')
        {
          //Alterado proprietário para ManagerID - Eduardo
          Id ManagerId = lManagerMap.get( c.OwnerId );
            DemandaInterna.criademanda(null, ManagerId, 'Contrato - Negociação de cancelamento', c.Account__c, null,
                'Cancelamento de Contrato','Negociação de cancelamento/pagamento', 
        'Negociar cancelamento/pagamento com o cliente',
                'Negociar com o cliente a forma de encerramento e eventuais pagamentos.', c.id, null);
        }
        
        if((c.Status_do_processo__c == 'Distrato encaminhado para o Consultor' && trigger.old[i].Status_do_processo__c <> 'Distrato encaminhado para o Consultor')
          || (c.Status_do_processo__c == 'Distrato devolvido para o Consultor' && trigger.old[i].Status_do_processo__c <> 'Distrato devolvido para o Consultor'))
        {
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - assinatura de distrato do cliente', c.Account__c, null,
                'Cancelamento de Contrato',
                'Providenciar assinatura do distrato',
                'Providenciar assinatura do distrato com o cliente',  
        'Imprimir 3 vias do distrato, providenciar junto ao cliente assinaturas e reconhecimento de firma.',
                c.id, null);
        }
        if(c.Status_do_processo__c == 'Distrato encaminhado para o Coordenador' && trigger.old[i].Status_do_processo__c <> 'Distrato encaminhado para o Coordenador')
        {
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - conferência de documentação', c.Account__c, null,
                'Cancelamento de Contrato',
                'Conferência de distrato',
                'Conferência de documentacão',  
        'Conferir entrega das 3 vias do distrato, assinaturas e vistos e rúbricas em todas as páginas. Encaminhar para assistente da Regional.',
                c.id, null);
        } 
        if(c.Status_do_processo__c == 'Distrato encaminhado para assinaturas' && trigger.old[i].Status_do_processo__c <> 'Distrato encaminhado para assinaturas')
        {
            DemandaInterna.criademanda(lFila, null, 'Contrato - Assinatura de distrato - procurador', c.Account__c, null,
                'Cancelamento de Contrato',
                'Providenciar assinatura do procurador',
                'Solicitar junto ao procurador a assinatura do distrato',  
                'Providenciar assinaturas caso solicitação do cliente, encaminhar carta pedido de distrato assinada pelo cliente.',
                c.id, null);
        }
        if(c.Status_do_processo__c == 'Distrato assinado pelo procurador' && trigger.old[i].Status_do_processo__c <> 'Distrato assinado pelo procurador')
        {
            String sFila = 'Assistente de Off Trade' ;
          if (lAccount.Channel__c == 'On Trade') {sFila = 'Assistente de On Trade';}
            DemandaInterna.criademanda(sFila, null, 'Contrato - Assinatura de distrato - diretoria', c.Account__c, null,
                'Cancelamento de Contrato',
                'Providenciar assinatura da Diretoria',
                'Solicitar junto à Diretoria a assinatura do distrato',  
        'Providenciar assinaturas da Diretoria caso solicitação do cliente, encaminhar carta pedido de distrato.',
                c.id, null);
        }
        if(c.Status_do_processo__c == 'Distrato assinado pela Diretoria' && trigger.old[i].Status_do_processo__c <> 'Distrato assinado pela Diretoria')
        {
            DemandaInterna.criademanda(lFila, null, 'Contrato', c.Account__c, null,
                'Cancelamento de Contrato',
                'Encaminhar distrato para o consultor',
                'Encaminhar distrato assinado para o consultor',  
                'Arquivar uma via do distrato e encaminhar a outra para o consultor',
                c.id, null); // Rogerio
        }    
        if(c.Status_do_processo__c == 'Distrato assinado encaminhado para a Regional' && trigger.old[i].Status_do_processo__c <> 'Distrato assinado encaminhado para a Regional')
        {
            DemandaInterna.criademanda(lFila, null, 'Contrato', c.Account__c, null,
                'Cancelamento de Contrato',
                'Encaminhar distrato para o consultor',
                'Encaminhar distrato assinado para o consultor',  
                'Encaminhar via do distrato ao consultor para ser entregue ao cliente',
                c.id, null);  // Rogerio
        }
        
        if(c.Status_do_processo__c == 'Distrato assinado encaminhado para o Consultor' && trigger.old[i].Status_do_processo__c <> 'Distrato assinado encaminhado para o Consultor')
        {
            DemandaInterna.criademanda(null, c.OwnerId, 'Contrato - entrega do contrato', c.Account__c, null,
                'Cancelamento de Contrato',
                'Entregar distrato assinado ao cliente',
                'Encaminhar distrato assinado para o cliente',  
                'Entregar via do distrato ao cliente e retirar materiais',
                c.id, null);  // Rogerio
        }      
         
        // PROCESSO DE TÉRMINO DE CONTRATO:
        // Se status foi alterado, abre caso  (demanda) para a área correpondente
    
    // JL 25/mai
        if(c.Status_do_processo__c == 'Em análise para renovação' && trigger.old[i].Status_do_processo__c <> 'Em análise para renovação')
        {
            DemandaInterna.criademanda(null, c.OwnerId, 'Término de Contrato', c.Account__c, null,
                'Término de Contrato',
                'Vencimento de Contrato', 
        'Solicitar análise de renovação de contrato',
                'Levantar histórico de pagamentos previstos x efetuados ao cliente, analisar cumprimento de contrapartidas e selecionar uma das seguintes ações: 1) Renovação de Contrato; 2) Não renovação; 3) Prorrogação de contrato.', c.id, null);
        }

      // Manter o contador!
        i++;
    }
    if ( lContratoOriginalUpdateList != null && lContratoOriginalUpdateList.size() > 0 ) update lContratoOriginalUpdateList;
 }
}

// Assinatura de contrato - Assinatura do Procurador
// Modelo de Email de cancelamento de contrato (clonar o aprovação de novo contrato)
//