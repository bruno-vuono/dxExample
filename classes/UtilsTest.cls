/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
*
* Classe que faz o teste de cobertura da classe Utils
* NAME: UtilsTest.cls
* AUTHOR: ROGERIO ALVARENGA                         DATE: 17/09/2012
*
*
* MAINTENANCE
* AUTHOR: CARLOS CARVALHO                           DATE: 11/01/2013
* DESC: INSERIDO FUNCIONALIDADE QUE VALIDA O ID DO TIPO DE REGISTRO DOS OBJETOS.
*******************************************************************************/

@isTest(SeeAllData=true)
private class UtilsTest {

    static testMethod void myUnitTest()
    {
      Id idRecTypeUDC = RecordTypeForTest.getRecType( 'UDC__c' , 'BRA_Standard' );
      
      Utils.decodeString( 'qwe|2|descriçao|23,11|222,33', true );
      Utils.decodeString( 'qwe|3|descriçao|111,34|222,33', false );
      Utils.decodeString( 'qwe', false );
      
      //Cria Regional
	    UDC__c lUDC = new UDC__c(
	      CodDefUsuario__c = '2',
	      CodProd__c     = '01',
	      CodUs__c     = '01',
	      Internal_Id__c   = '1234',
	      RecordTypeId = idRecTypeUdc
	    );
	    insert lUDC;
      
      Utils.getCodeFromUDC( lUDC.id );
      //Id hard code colocado propositalmente
      Utils.getCodeFromUDC( '001Q000000V3O95' );
      
      Utils.getNameFromUDC( lUDC.id );
      //Id hard code colocado propositalmente
      Utils.getNameFromUDC( '001Q000000V3O95' );
      
      Utils.getIDFromUDC( '03', 'CRM', 'DF' );
      
      String lStr = Utils.getUserNameSplit( 'Usuario teste' );

      Utils.isMobileUser(UserInfo.getUserId());
    }

    static testMethod void testIsPartOfGroup()
    {
      
      Boolean belongsToGroup = Utils.isPartOfGroup('LAT_MX_Alta_Grupos');

      system.assertEquals(false, belongsToGroup);

    }
    
}