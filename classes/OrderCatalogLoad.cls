/********************************************************************************
*                         Copyright 2012 - Cloud2b
********************************************************************************
* 
* NAME: OrderCatalogLoad.CLS
* AUTHOR: ROGÉRIO ALVARENGA                       DATE: 
*
* MAINTENANCE: INSERIDO LÓGICA DE VALIDAÇÃO DO TIPO DE REGISTRO DOS OBJETOS.
* AUTHOR: CARLOS CARVALHO                         DATE: 11/01/2013 
********************************************************************************/
global class OrderCatalogLoad {
  /*
  private static final String DEFAULT_CATALOG = 'Catálogo de preços padrão';
  private static Id idRecTypeProd = RecordTypeForTest.getRecType( 'Product2', 'BRA_Standard' );
  
  WebService static String ETL_OrderCatalogLoad(Integer country, Integer customer_Group, Integer product, 
    String cd_payment_term, String CD_unit, String CD_warehouse, Integer QT_lead_time, Integer VL_list_price, 
      Integer QT_multiple, Integer QT_base_Bonus, Integer QT_Bonus,Integer PC_Bonus, String ds_payment_term, String aName) 
  {
    if ( country <= 0 )
      return 'Country must be filled';
    if ( customer_Group <= 0 )
      return 'Customer_group must be filled';
    if ( product <= 0 )
      return 'Product must be filled';
    
    try
    {
      
      String lProdCode = String.valueOf( customer_Group ) +'-'+ String.valueOf( product ) +'-'+ cd_payment_term;
      
      List< Product2 > prodL = [Select id from Product2 
                                       where Internal_id__c =: lProdCode 
                                       AND RecordTypeId =: idRecTypeProd limit 1 ];
      Product2 prod;
      if ( prodL.size() == 0 )
      {
        prod = new Product2();
        prod.Internal_id__c = lProdCode;
        prod.Name = aName;
      }
      else prod = prodL[ 0 ];
      prod.Country__c = country;
      prod.customer_Group__c = customer_Group;
      prod.SKU__c = String.valueOf( product );
      prod.cd_payment_term__c = cd_payment_term;
      prod.CD_Unit__c = CD_unit; 
      prod.CD_Wherehouse__c = CD_warehouse;
      prod.QT_lead_time__c = QT_lead_time;
      prod.QT_multiple__c = QT_multiple;
      prod.QT_base_bonus__c = QT_base_Bonus;
      prod.QT_Bonus__c = QT_Bonus;
      prod.PC_Bonus__c = PC_Bonus;
      prod.ds_payment_term__c = ds_payment_term;
      upsert prod;
      
      List< Pricebook2 > priceL = [Select id from Pricebook2 where name=:DEFAULT_CATALOG limit 1];
      if ( priceL.size() == 0 ) return DEFAULT_CATALOG + ' not found';
      Pricebook2 price = priceL[ 0 ];
      PricebookEntry entry = getPriceBookEntry( price.id, prod.id );
      entry.UnitPrice = 0;
      upsert entry;
          
      priceL = [select id from Pricebook2 where name=:String.valueOf( customer_Group ) limit 1];
      if ( priceL.size() == 0 )
      {
        price = new Pricebook2();
        price.Description = String.valueOf( customer_Group );
        price.Name = String.valueOf( customer_Group );
        price.IsActive = true;
        insert price;
      }
      else price = priceL[ 0 ];
      entry = getPriceBookEntry( price.id, prod.id );
      entry.UnitPrice = VL_list_price;
      upsert entry;
    } catch(Exception e) {
      return e.getMessage();
    } finally{
    }
    return '';
  }
  
  private static PricebookEntry getPriceBookEntry( Id aPrice, Id aProduct )
  {
    List< PricebookEntry > entryL = [Select Pricebook2Id, Product2Id, UnitPrice from PricebookEntry where Pricebook2Id=:aPrice and Product2Id=:aProduct limit 1];
    PricebookEntry entry;
    if ( entryL.size() == 0 )
    {
      entry = new PricebookEntry();
      entry.Pricebook2Id = aPrice;
      entry.Product2Id = aProduct;
      entry.IsActive = true;
    }
    else entry = entryL[ 0 ];
    return entry;
  }*/
}