/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
*
* Provê serviço de retorno de informações da inclusão do contrato
* NAME: ContractManagerReturn.cls
* AUTHOR: ROGERIO ALVARENGA                         DATE: 21/08/2012
*
*
* MAINTENANCE: INSERIDO LÓGICA DE VALIDAÇÃO DO TIPO DE REGISTRO DOS OBJETOS.
* AUTHOR: CARLOS CARVALHO                           DATE: 09/01/2013 
*******************************************************************************/

global class ContractManagerReturn {
  
  WebService static Integer contractReturn( String aContractID, String aStatus, String aMessage )
  {
    //Recupera os Ids dos tipos de registro do objeto LAT_Contract__c
    Set< Id > setRecTypeLatCon = new Set< Id >();
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Alteracao_de_contrato_OFF'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Alteracao_de_contrato_on'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'AlteracaoContratoAtivoOffTrade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'AlteracaoContratoAtivoOnTrade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Alteracao_de_contrato_aprovada_Off_Trade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Alteracao_de_contrato_aprovada_On_Trade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato_Off_Trade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato_Off_Trade_aprovado'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato_Off_Trade_ativo'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato_aprovada'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato_com_aprovacao_Off_Trade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Assinatura_de_contrato_com_aprovacao'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Ativacao_de_contrato'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Cancelamento_de_contrato_Off_Trade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Cancelamento_de_contrato_On_Trade'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Cancelamento_de_contrato_aprovado_off'));
    setRecTypeLatCon.add( RecordTypeForTest.getRecType( 'LAT_Contract__c', 'Cancelamento_de_contrato_aprovado_on'));
    
    List< LAT_Contract__c > lContractList = [ SELECT Status_da_INtegra_o__c, MensagemIntegracao__c
                                      FROM LAT_Contract__c WHERE id =:aContractID AND status__c = 'Ativo' 
                                      AND Account__r.Channel__c = 'Off Trade'
                                      AND RecordTypeId =: setRecTypeLatCon ];
                                      
    if ( lContractList.size() == 0 ) return -1;
    LAT_Contract__c lContract = lContractList[ 0 ];
    if ( aStatus == '0' )
    {
      lContract.Status_da_INtegra_o__c = 'Cadastrado SCV';
      lContract.MensagemIntegracao__c = '';
    }
    else
    {
      lContract.Status_da_INtegra_o__c = 'Erro no envio para o SCV';
      lContract.MensagemIntegracao__c = aMessage;
    }
    try
    {
      update lContract;
    }
    catch ( Exception e ){ return -2;}
    return 0;
  }

}