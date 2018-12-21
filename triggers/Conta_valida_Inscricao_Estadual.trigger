/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
********************************************************************************
* Verifica se o estado selecionado condiz com o número de inscrição estadual.
* NAME: Conta_valida_Inscricao_Estadual.trigger
* AUTHOR:                                           DATE: 11/06/2012
*
* MAINTENANCE: retirado after insert. Registro vem cadastrado errado do JDE.
* AUTHOR:                                           DATE: 
*
* MAINTENANCE: Inserido método RecordTypeForTest com validação de tipo de registro.
* Alterado trigger para melhores práticas
* AUTHOR: CARLOS CARVALHO                           DATE: 07/01/2013 
*******************************************************************************/
trigger Conta_valida_Inscricao_Estadual on Account (after update){

//    Check if this trigger is bypassed by SESAME (data migration Brazil)
if((UserInfo.getProfileId()!='00eM0000000QNYPIA4') && (UserInfo.getProfileId()!= '00eD0000001AnFlIAK')) {
    
    Set<Id> setIdsRecType = Global_RecordTypeCache.getRtIdSet('Account', new set<String>{'Eventos', 'Off_Trade', 'On_Trade'});
    
    for( Account c : trigger.new ) {
        if( setIdsRecType.contains( c.RecordTypeId ) && c.State_registration__c <> null
            && c.State_registration__c <> 'Isento' && c.Revenue_UF__c != null ){
               Boolean result = InscricaoEstadual.ValidaIE( c.Revenue_UF__c, c.State_registration__c);
               if(!result) c.State_registration__c.AddError('Combinação de Inscrição estadual e Estado de faturamento inválida.');
        }
    }
 }
}