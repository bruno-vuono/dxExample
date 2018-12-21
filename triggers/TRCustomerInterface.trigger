/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
*
* Essa trigger dispara a chamada para enviar dados do cliente para o JDE quando
* o status for 'Aprovado - Aguardando retorno do JDE'. Ou Criar o fornecedor
* baseado no cliente quando o status for 'Cliente cadastrado no JDE'
* NAME: TRCustomerInterface.trigger
* AUTHOR: ROGERIO ALVARENGA                         DATE: 10/07/2012
*
*
* MAINTENANCE: INSERIDO FUNCIONALIDADE QUE VALIDA O ID DO TIPO DE REGISTRO DOS 
* OBJETOS.
* AUTHOR: CARLOS CARVALHO                               DATE: 09/01/2013
*******************************************************************************/

trigger TRCustomerInterface on Account ( after insert, after update ) {
  private final String ENVIAR_ACTION = 'Aprovado - Aguardando retorno do JDE';
  private final String APROVADO_ACTION = 'Cliente cadastrado no JDE';
  
//    Check if this trigger is bypassed by SESAME (data migration Brazil)
if((UserInfo.getProfileId()!='00eM0000000QNYPIA4') && (UserInfo.getProfileId()!= '00eD0000001AnFlIAK')) {
  
  //Declaração de variáveis
  Set<String> lListAN8s = new Set<String>();
  Set<Id> setRecTypeAcc = Global_RecordTypeCache.getRtIdSet('Account', new set<String>{'Eventos', 'Off_Trade', 'On_Trade'});
  Id idRecTypeFor = Global_RecordTypeCache.getRtId('Fornecedor__c'+'BRA_Standard');
  
  for(Account x : Trigger.New){
    LAT_DebugUtil.insertDebug('TRCustomerInterfaceTRNEW', String.valueOf(Trigger.New.size()), '');
    if(setRecTypeAcc.contains(x.RecordTypeId)){
        if(setRecTypeAcc.contains(x.RecordTypeId) && x.Status__c.equalsIgnoreCase(ENVIAR_ACTION)){
            CustomerHandlerInterface.CustomerInterfaceJDE(String.valueof(x.Id));
        }else if (x.Status__c.equalsIgnoreCase(APROVADO_ACTION )){
            lListAN8s.add( x.Client_code_AN8__c );
        }
    }
  }
  
  if ( lListAN8s.size() > 0 )
  {
    List< Fornecedor__c > lListFornecedor;
    lListFornecedor = [ SELECT Codigo_do_Fornecedor_AN8__c 
                               FROM Fornecedor__c 
                               WHERE Codigo_do_Fornecedor_AN8__c =: lListAN8s 
                               AND RecordTypeId =: idRecTypeFor ];

    for ( Fornecedor__c lForn : lListFornecedor )
    {
      lListAN8s.remove( lForn.Codigo_do_Fornecedor_AN8__c );
    }
    lListFornecedor = new List< Fornecedor__c >();
    for(Account x : Trigger.New)
    {
      if (setRecTypeAcc.contains( x.RecordTypeId ) && x.Status__c.equalsIgnoreCase( APROVADO_ACTION ) && lListAN8s.contains( x.Client_code_AN8__c ) )
      {
        Fornecedor__c lForn = new Fornecedor__c();
        lForn.Name = x.Name;
        lForn.Razao_social__c = x.Corporate_Name__c;
        lForn.Codigo_do_Fornecedor_AN8__c = x.Client_code_AN8__c;
        lForn.Telefone__c = x.Phone;
        lForn.CNPJ__c = x.CNPJ__c;
        lForn.RecordTypeId = idRecTypeFor;
        lListFornecedor.add( lForn );
      }
    }
    if ( lListFornecedor.size() > 0 ) insert lListFornecedor;
  }
 }
  
}