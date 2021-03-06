/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
*
* Verifica se já existe uma cota regional para
* SKU - REGIONAL - CANAL - SUBCANAL - BANDEIRA - BANDEIRA REGIONAL - EXECUTIVO - CLIENTE
* NAME: CotaRegionalVerificaUnicidade.trigger
* AUTHOR: ROGERIO ALVARENGA                         DATE: 27/06/2012
*
*
*
* MAINTENANCE: INSERIDO FUNCIONALIDADE QUE VALIDA O ID DO TIPO DE REGISTRO DOS OBJETOS.
* AUTHOR: CARLOS CARVALHO                               DATE: 08/01/2013
*******************************************************************************/
trigger CotaRegionalVerificaUnicidade on Cota_regional__c (before insert, before update) {

//    Check if this trigger is bypassed by SESAME (data migration Brazil)
if((UserInfo.getProfileId()!='00eM0000000QNYPIA4') && (UserInfo.getProfileId()!= '00eD0000001AnFlIAK')) {
  
  Id idRecTypeCR = RecordTypeForTest.getRecType('Cota_regional__c', 'BRA_Standard');
  List< String > lListSku = new List< String >();
  for ( Cota_regional__c lCota: trigger.new )
    lListSku.add( lCota.SKU__c );
    
  List< Cota_regional__c > lListCota = [ SELECT SKU__c, Regional__c, Canal__c, Sub_canal__c, 
    Bandeira_referencia__c, Bandeira_regional__c, Executivo__c, Cliente__c
    FROM Cota_regional__c WHERE SKU__c =:lListSku AND RecordTypeId =: idRecTypeCR];
    
  Map< String, Cota_regional__c > lSetCrit = new Map< String, Cota_regional__c >();
  for ( Cota_regional__c lCota : lListCota )
  {
    String lKey = lCota.SKU__c + '|' + lCota.Regional__c + '|' + lCota.Canal__c + '|' + lCota.Sub_canal__c + '|' + lCota.Bandeira_referencia__c
                  + '|' + lCota.Bandeira_regional__c + '|' + lCota.Executivo__c + '|' + lCota.Cliente__c;
    lSetCrit.put( lKey, lCota );
  }
  
  boolean hasError = false;
  for ( Cota_regional__c lCota: trigger.new )
  {
    String lKey = lCota.SKU__c + '|' + lCota.Regional__c + '|' + lCota.Canal__c + '|' + lCota.Sub_canal__c + '|' + lCota.Bandeira_referencia__c
                  + '|' + lCota.Bandeira_regional__c + '|' + lCota.Executivo__c + '|' + lCota.Cliente__c;
    Cota_regional__c lExist = lSetCrit.get( lKey );
    if ( lExist != null && lExist.id != lCota.id ) 
    {
      hasError = true;
      break;
    }
  }
  
  if ( hasError )
  {
    for ( Cota_regional__c lCota: trigger.new )
    {
        if( lCota.RecordTypeId == idRecTypeCR){
           lCota.addError( 'Já existe uma cota regional cadastrada para essas informações' );   
        }
    }
  }
 }
}