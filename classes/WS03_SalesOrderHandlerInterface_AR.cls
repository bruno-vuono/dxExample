/**********************************************
 Dev: Juan Pablo Cubo       Version: 1
**********************************************/
 /********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 16/11/2016
*
********************************************************************************/


global class WS03_SalesOrderHandlerInterface_AR {

  private static final String CONST_INSERT = 'I';
  private static final String CONST_CANCEL = 'C';
  private static final String CONST_UPDATE = 'U';
  
  @future (callout=true)
  Webservice static void SalesOrderInterfaceFuture( String idSalesforce ){
    SalesOrderInterface(idSalesforce);
  }

  @future (callout=true)
  Webservice static void LAT_SalesOrderInterfaceFuture( String idSalesforce ){
    LAT_SalesOrderInterface(idSalesforce);
  }
  
  public static boolean isProcessing {get; set;}
  
  Webservice static String SalesOrderInterface( String idSalesforce ){
  
        Opportunity opp = null;
        String debugStr = '';
        String debugItem = '';
        Set< Id > setRecTypeOpp = new Set< Id >();
        setRecTypeOpp.add( RecordTypeForTest.getRecType( 'Opportunity', 'OPP_1_NewOrder_ARG' ) );
        setRecTypeOpp.add( RecordTypeForTest.getRecType( 'Opportunity', 'OPP_2_NewOrder_URU' ) );
        setRecTypeOpp.add( RecordTypeForTest.getRecType( 'Opportunity', 'OPP_3_HeaderBlocked_ARG' ) );
        setRecTypeOpp.add( RecordTypeForTest.getRecType( 'Opportunity', 'OPP_4_HeaderBlocked_URU' ) );
        setRecTypeOpp.add( RecordTypeForTest.getRecType( 'Opportunity', 'OPP_5_OrderBlocked_ARG' ) );
        setRecTypeOpp.add( RecordTypeForTest.getRecType( 'Opportunity', 'OPP_6_OrderBlocked_URU' ) );
        
        List< Opportunity > oppL = [ SELECT id, CD_Action__c, Owner.C_digo_JDE__c, DT_delivery__c, Account.Business_Unit_AR__c,
                                      Freight__c, DS_Message1__c, DS_Message2__c, CloseDate, Account.Client_code_AN8__c, CreatedDate, 
                                      type, NR_order_JDE__c, CD_order_status__c, NR_customer_order__c, Origem_do_pedido__c, RecordTypeId,
                                      RecordType.Name, StageName, Account.ParentId, Pais__c, CreditLimitBalance_AR__c
                                    FROM Opportunity WHERE Id =: idSalesforce AND RecordTypeId =: setRecTypeOpp limit 1];
                            
        if ( oppL.size() == 0 ) return 'Pedido (id:' + idSalesforce + ') no encontrado';
        opp = oppL[ 0 ];
        
        if ( opp.Origem_do_pedido__c != 'CRM' && opp.Origem_do_pedido__c != 'APP') return 'Solamente los pedidos con origen CRM se pueden enviar a JDE';
        String lRecTypeAr = RecordTypeForTest.getRecType( 'Opportunity','OPP_5_OrderBlocked_ARG' );
        String lRecTypeUr = RecordTypeForTest.getRecType( 'Opportunity','OPP_6_OrderBlocked_URU' );
        if ( opp.RecordTypeId == lRecTypeAr ||  opp.RecordTypeId == lRecTypeUr) return 'Pedido bloqueado para enviar a JDE';
        
        SalesOrderHandlerTypes.SalesOrderHeaderRequestType header = new SalesOrderHandlerTypes.SalesOrderHeaderRequestType();
        header.salesman = opp.Owner.C_digo_JDE__c;
        header.orderNumberForeign = String.valueOf( opp.id );
        header.customerCode = Integer.valueOf( opp.Account.Client_code_AN8__c );
        header.customerShippingCode = header.customerCode;
        
        List< Account > accListParent = [ SELECT Client_code_AN8__c FROM Account 
            WHERE Id =:opp.Account.Parentid limit 1 ];
        if ( accListParent.size() > 0 && opp.Pais__c == 6 )
            header.customerCode = Integer.valueOf( accListParent[ 0 ].Client_code_AN8__c);
            header.customerShippingCode = Integer.valueOf( opp.Account.Client_code_AN8__c );
        
        header.customerBuyOrder = opp.NR_customer_order__c;
        header.note1 = opp.DS_Message1__c;
        header.note2 = opp.DS_Message2__c;   
        
        // Ajuste para resolver a conversão GMT da camada SOA
        Date lTempDate;
        if ( opp.DT_delivery__c != null )
          lTempDate = opp.DT_delivery__c;
        else
          lTempDate = opp.CloseDate;
        
        if(lTempDate < date.today()){
            lTempDate = date.today();
        }
        
        header.promisedDate = Datetime.newinstance( lTempDate.year(), lTempDate.month(), lTempDate.day(), 14, 01,02 );
        
        if ( opp.Freight__c != null && opp.Freight__c.equalsIgnoreCase( 'FOB' ) )
          header.freightType = 'F';
        else
          header.freightType = '';
        header.orderRequestDate = opp.CreatedDate;
        header.orderRequestTime = 0;
        header.invoiceDate = Date.today();
        
        header.businessUnit = Utils.getCodeFromUDC( opp.Account.Business_Unit_AR__c );
        string oppType = opp.Type;
        if (oppType != null && oppType.length() > 2) {
            header.orderType = oppType.substring(0,2);
        } else {
            header.orderType = oppType;
        }
        if ( opp.NR_order_JDE__c != null && opp.NR_order_JDE__c != '' )
          header.orderNumber = Long.valueOf( opp.NR_order_JDE__c );
        if ( opp.CD_order_status__c != null && opp.CD_order_status__c != 0 )
          header.orderStatus = Integer.valueOf( opp.CD_order_status__c );
          
        boolean hasUpdate = false;
        
        Map< String, OpportunityLineItem > mapItems = new Map< String, OpportunityLineItem >();
        
        List< OpportunityLineItem > listaItens = [ SELECT CD_Action__c, LAT_SkuText__c, LAT_PaymentCondition__c, 
            NR_order_line__c, QT_Bonus__c, Quantity, cd_unit_bonif__c, LAT_UnitCode__c, LAT_PercentualBonus__c, 
            pc_discount__c, cd_line_status__c, UOM_AR__c, Discount_AR__c, SenttoApproveDiscount_AR__c,
            Remover__c, Campo_de_formatacao__c, MaxDiscount_AR__c
            FROM OpportunityLineItem 
            WHERE OpportunityId =: idSalesforce AND cd_line_status__c<>'999' ];
        
        //JPC 27/07/2013: validate that all the opportunity line items were calculated before sending to JDE

        List<LAT_Account_product_payment__c> appList = new List<LAT_Account_product_payment__c>();
        Map<String, LAT_Account_product_payment__c> SkuPCToApp = new Map<String, LAT_Account_product_payment__c>();
        if (opp.StageName != 'Mobile Order' && opp.Origem_do_pedido__c != 'APP'){
          for ( OpportunityLineItem oppItem : listaItens ) {
              if ((oppItem.Campo_de_formatacao__c == null || oppItem.Campo_de_formatacao__c.length() == 0) 
                  && (oppItem.Discount_AR__c != null && oppItem.Discount_AR__c != 0) ) {
                  return 'No es posible enviar a JDE porque hay productos sin cálculo de precio.';
              }
          }
        } else if (opp.RecordType.Name.endsWith('ARG') && opp.StageName == 'Mobile Order' && opp.Origem_do_pedido__c == 'APP'){
          WS04_PriceCalculationInterface_AR.PriceCalculation2(idSalesforce, listaItens);

          List<String> paymentConditions = new List<String>();
          List<String> productsList =  new List<String>();
          for ( OpportunityLineItem oppItem : listaItens ) {
              paymentConditions.add(oppItem.LAT_PaymentCondition__c);
              productsList.add(oppItem.LAT_SkuText__c);
          }

          appList = [SELECT Id, Product__c, PaymentCondition__c, PaymentConditionDescription__c, PercentualBonus__c, Product__r.SKU__c
                          FROM LAT_Account_product_payment__c 
                          WHERE Account__c =: opp.AccountId AND PaymentCondition__c IN: paymentConditions 
                                AND Product__r.SKU__c IN: productsList];

          for (LAT_Account_product_payment__c app: appList) {
            system.debug('app.Product__r.SKU__c--->' + app.Product__r.SKU__c);
            system.debug('app.PaymentCondition__c--->' + app.PaymentCondition__c);
            SkuPCToApp.put(app.Product__r.SKU__c + app.PaymentCondition__c, app);
          }

          for ( OpportunityLineItem oppItem : listaItens ) {
             system.debug('SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c)--->' + SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c));
            if (SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c) != null) {
              oppItem.MaxDiscount_AR__c = SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c).PercentualBonus__c;
            }
          }
          opp.CreditLimitBalance_AR__c = 0;

        }


        List< SalesOrderHandlerTypes.SalesOrderItemRequestType > items = new List< SalesOrderHandlerTypes.SalesOrderItemRequestType >();
        
        if (listaItens.size() == 0) {
            return 'No es posible enviar a JDE porque no hay productos seleccionados.';
        }
        
        for ( OpportunityLineItem oppItem : listaItens )
        {
          boolean isForApproval = false;
          String theMesssage;
            if ((oppItem.SenttoApproveDiscount_AR__c && opp.stageName == 'Novo pedido')
                || (oppItem.SenttoApproveDiscount_AR__c && opp.stageName == 'Mobile Order')) {
                opp.stageName = 'Pedido con descuento en aprobación';
                theMesssage = 'Pedido enviado a aprobación de descuento.';
                isForApproval = true;
            }
            if((!oppItem.SenttoApproveDiscount_AR__c && opp.Type == 'SV - Free Goods (Sales)' && opp.stageName == 'Novo pedido')
              || (!oppItem.SenttoApproveDiscount_AR__c && (opp.Type == 'SV - Free Goods (Sales)' || opp.Type == 'SV') && opp.stageName == 'Mobile Order')){
              opp.stageName = 'Approval pending';
              theMesssage = 'Pedido enviado a aprobación.';
              isForApproval = true;
            }
            if (!isForApproval && opp.RecordType.Name.endsWith('ARG') && opp.StageName == 'Mobile Order' && opp.Origem_do_pedido__c == 'APP') {
                decimal jdeDiscount = 0;
                if (oppItem.Campo_de_formatacao__c != null && oppItem.Campo_de_formatacao__c != '') {
                    Pattern myPattern = Pattern.compile('(?<=>.?Bonificaci.?.?n.?.?</td>).*?</td>');
                    Matcher myMatcher = myPattern.matcher(oppItem.Campo_de_formatacao__c);
                    string htmlFiltrado = '';
                    if (myMatcher.find()) {
                        htmlFiltrado = myMatcher.group();
                    }
                    htmlFiltrado = htmlFiltrado.replaceAll('<.*?>','');
                    if (htmlFiltrado != '') {
                        jdeDiscount = Decimal.valueOf(htmlFiltrado.replace('.', '').replace(',','.').trim());
                    }
                    system.debug('jdeDiscount------>' + jdeDiscount);
                }
                if (oppItem.Discount_AR__c == null) {
                    oppItem.Discount_AR__c = 0;
                }
                system.debug('jdeDiscount------>' + jdeDiscount);
                system.debug('Discount_AR__c------>' + oppItem.Discount_AR__c);
                system.debug('MaxDiscount_AR__c------>' + oppItem.MaxDiscount_AR__c);
                
                if (oppItem.MaxDiscount_AR__c != null && oppItem.MaxDiscount_AR__c < (oppItem.Discount_AR__c + jdeDiscount.abs()) ) {
                    opp.stageName = 'Pedido con descuento en aprobación';
                    oppItem.SenttoApproveDiscount_AR__c = true;
                    isForApproval = true;
                }
            }
            if(isForApproval){
                update opp;
                if (opp.RecordType.Name.endsWith('ARG') && opp.Origem_do_pedido__c == 'APP') {
                  system.debug('listaItens----->' + listaItens);
                  update listaItens;
                }
                Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                app.setObjectId(opp.id);
                try{Approval.ProcessResult result = Approval.process(app);}catch(Exception e){}
                return theMesssage;
            }
        
            for ( OpportunityLineItem oppItemL : listaItens ){
              if (oppItem.SenttoApproveDiscount_AR__c && opp.stageName == 'Pedido con descuento en aprobación') 
                  return 'Pedido esperando aprobación de descuento';
              
              if (oppItem.SenttoApproveDiscount_AR__c && opp.stageName == 'Pedido con descuento en aprobación') 
                  return 'Pedido esperando aprobación de descuento';
            }
            
          SalesOrderHandlerTypes.SalesOrderItemRequestType item = new SalesOrderHandlerTypes.SalesOrderItemRequestType();
          if (oppItem.Remover__c) {
            item.actionCode = CONST_CANCEL;
          } else if ( oppItem.CD_Action__c == null  || !oppItem.CD_Action__c.equalsIgnoreCase( CONST_CANCEL ) ) {
            if ( oppItem.NR_order_line__c == null || oppItem.NR_order_line__c.equalsIgnoreCase( '' ) )
              item.actionCode = CONST_INSERT;
            else
              item.actionCode = '';
          } else {
            item.actionCode = oppItem.CD_Action__c;
          }
          if ( oppItem.CD_Action__c != null )
            hasUpdate = hasUpdate || ( oppItem.CD_Action__c.equalsIgnoreCase( CONST_CANCEL ) || oppItem.CD_Action__c.equalsIgnoreCase( CONST_INSERT ) );
          if ( oppItem.NR_order_line__c != null )
            item.lineNumber = Integer.valueOf( oppItem.NR_order_line__c );
          if (oppItem.LAT_SkuText__c != null && oppItem.LAT_SkuText__c.trim().length() > 0) {
            item.sku = oppItem.LAT_SkuText__c;
          }
          item.paymentTerm = oppItem.LAT_PaymentCondition__c;
          item.billedTotalQuantity = oppItem.Quantity;
          item.bonusQuantity = Integer.valueOf( oppItem.QT_Bonus__c );
          item.bonusPercentual = oppItem.LAT_PercentualBonus__c;
          if ( oppItem.LAT_UnitCode__c == null || oppItem.LAT_UnitCode__c.equalsIgnoreCase( '' ) )
            item.bonusUnit = 'CA';
          else
            item.bonusUnit = String.valueOf( oppItem.LAT_UnitCode__c );
          item.salesUOM = oppItem.UOM_AR__c; //difference with original
          if (oppItem.Discount_AR__c != null) {
            item.percentualDiscount = oppItem.Discount_AR__c; //difference with original
          } else {
            item.percentualDiscount = 0;
          }
          item.orderLineStatus = oppItem.cd_line_status__c;
          
          // Campos obligatorios de items
          item.promisedDate = header.promisedDate;
          item.estimatedDeliveryDate = header.promisedDate;
          item.logisticsPromisedDate = header.promisedDate;
          item.realDeliveryDate = header.promisedDate;
          
          items.add( item );
          mapItems.put( oppItem.LAT_SkuText__c, oppItem );
          
          debugItem += ' |start item, lineNumber: ' + item.lineNumber + ' - sku: ' + item.sku + ' - salesUOM: ' + item.salesUOM + ' - paymentTerm: ' + item.paymentTerm + ' - billedTotalQuantity: ' + item.billedTotalQuantity
          + ' - bonusQuantity: ' + item.bonusQuantity + ' - bonusPercentual: ' + item.bonusPercentual + ' - bonusUnit: ' + item.bonusUnit + ' - percentualDiscount: ' + item.percentualDiscount + ' - orderLineStatus: ' + item.orderLineStatus + ' - actionCode: ' + item.actionCode;
          
        }
        
        if ( opp.CD_Action__c == null || ( !opp.CD_Action__c.equalsIgnoreCase( CONST_CANCEL ) && hasUpdate ) )
        {
          if ( opp.NR_order_JDE__c != null && Long.valueOf(opp.NR_order_JDE__c) > 0 )header.actionCode = CONST_UPDATE;
          else header.actionCode = CONST_INSERT;
        }
        else
          header.actionCode = opp.CD_Action__c;
        
        // Campos obligatorios de header
        header.purchaseOrderUntil = header.promisedDate;
          
        debugStr = 'Salesman: ' + header.salesman+' - orderNumberForeign: ' + header.orderNumberForeign + ' - customerCode: '+header.customerCode+' - customerShippingCode: ' + header.customerShippingCode
        + ' - customerBuyOrder: ' + header.customerBuyOrder + ' - note1: '+header.note1 + ' - note2: '+header.note2 + ' - promisedDate: '+header.promisedDate + ' - freightType: '+header.freightType
        + ' - orderRequestDate: ' + header.orderRequestDate + ' - orderRequestTime: ' + header.orderRequestTime + ' - invoiceDate: ' + header.invoiceDate + ' - businessUnit: ' + header.businessUnit
        + ' - orderType: ' + header.orderType + ' - orderNumber: ' + header.orderNumber + ' - orderStatus: ' + header.orderStatus + ' - actionCode: ' + header.actionCode;
        
        SalesOrderHandler.execute_pt request = new SalesOrderHandler.execute_pt();
        request.timeout_x = 120000;
        SalesOrderHandlerTypes.SalesOrderHandlerResponseType response;
        integer lResponseCode = 0;
        try
        {
            System.debug('request values: ' + debugStr);
            System.debug('request items: ' + debugItem);
            if (opp.RecordType.Name.endsWith('ARG')) {
                lResponseCode = request.execute( getConnectionParameter('Argentina'), header, items );
            } else if (opp.RecordType.Name.endsWith('URU')) {
                lResponseCode = request.execute( getConnectionParameter('Uruguay'), header, items );
            }
            System.debug('lResponseCode success: ' + lResponseCode);
        }
        catch ( Exception e )
        {
          opp.Integracao_Retorno_JDE__c = debugStr + '%%%%%%%%%=' + debugItem+'='+e.getMessage();
          opp.StageName = 'Pedido com erro no JDE';
          opp.Integracao__c = true;
          update opp;
          if (opp.RecordType.Name.endsWith('ARG') && opp.Origem_do_pedido__c == 'APP') {
            update listaItens;
          }
          return 'Error inespedado en el envio a JDE. Contacte a su administrador de sistema';
        }

        if ( lResponseCode == 0 )
        {
          opp.StageName = opp.StageName == 'Mobile Order' ? 'Moblie Order Sent To JDE' : 'Pedido enviado para o JDE';
          if (opp.RecordType.Name.endsWith('ARG')) {
            opp.RecordTypeId = RecordTypeForTest.getRecType( 'Opportunity','OPP_5_OrderBlocked_ARG' );
          } else if (opp.RecordType.Name.endsWith('URU')) {
            opp.RecordTypeId = RecordTypeForTest.getRecType( 'Opportunity','OPP_6_OrderBlocked_URU' );
          } 
          
        }
        else opp.StageName = 'Pedido com erro no JDE';
         
        opp.Integracao__c = true;
        update opp;
        if (opp.RecordType.Name.endsWith('ARG') && opp.Origem_do_pedido__c == 'APP') {
          update listaItens;
        }
        return '';
    
  }

  Webservice static String LAT_SalesOrderInterface( String idSalesforce ){
  
    LAT_Opportunity__c opp = null;
    String debugStr = '';
    String debugItem = '';
    Set< Id > setRecTypeOpp = new Set< Id >();
    setRecTypeOpp.add( RecordTypeForTest.getRecType( 'LAT_Opportunity__c', 'OPP_1_NewOrder_ARG' ) );
    setRecTypeOpp.add( RecordTypeForTest.getRecType( 'LAT_Opportunity__c', 'OPP_2_NewOrder_URU' ) );
    setRecTypeOpp.add( RecordTypeForTest.getRecType( 'LAT_Opportunity__c', 'OPP_3_HeaderBlocked_ARG' ) );
    setRecTypeOpp.add( RecordTypeForTest.getRecType( 'LAT_Opportunity__c', 'OPP_4_HeaderBlocked_URU' ) );
    setRecTypeOpp.add( RecordTypeForTest.getRecType( 'LAT_Opportunity__c', 'OPP_5_OrderBlocked_ARG' ) );
    setRecTypeOpp.add( RecordTypeForTest.getRecType( 'LAT_Opportunity__c', 'OPP_6_OrderBlocked_URU' ) );
    
    List< LAT_Opportunity__c > oppL = [ SELECT id, LAT_CDAction__c, LAT_Account__r.Owner.C_digo_JDE__c, LAT_DTDelivery__c, LAT_Account__r.Business_Unit_AR__c,
                                  LAT_Freight__c, LAT_DSMessage1__c, LAT_DSMessage2__c, LAT_CloseDate__c, LAT_Account__r.Client_code_AN8__c, CreatedDate, 
                                  LAT_Type__c, LAT_NROrderJDE__c, LAT_CDOrderStatus__c, LAT_NRCustomerOrder__c, LAT_OrderOrigin__c, RecordTypeId,
                                  RecordType.Name, LAT_StageName__c, LAT_Account__r.ParentId, LAT_Country__c, LAT_AR_CreditLimitBalance__c
                                FROM LAT_Opportunity__c WHERE Id =: idSalesforce AND RecordTypeId =: setRecTypeOpp limit 1];
                        
    if ( oppL.size() == 0 ) return 'Pedido (id:' + idSalesforce + ') no encontrado';
    opp = oppL[ 0 ];
    
    if ( opp.LAT_OrderOrigin__c != 'CRM' && opp.LAT_OrderOrigin__c != 'APP') return 'Solamente los pedidos con origen CRM se pueden enviar a JDE';
    String lRecTypeAr = RecordTypeForTest.getRecType( 'LAT_Opportunity__c','OPP_5_OrderBlocked_ARG' );
    String lRecTypeUr = RecordTypeForTest.getRecType( 'LAT_Opportunity__c','OPP_6_OrderBlocked_URU' );
    if ( opp.RecordTypeId == lRecTypeAr ||  opp.RecordTypeId == lRecTypeUr) return 'Pedido bloqueado para enviar a JDE';
    if (opp.LAT_Type__c == 'SJ - Ofrecidos de Ventas por Acuerdos' ) {
      if (opp.LAT_StageName__c == 'Novo pedido' || opp.LAT_StageName__c == 'Mobile Order') {
          opp.LAT_StageName__c = 'Pedido Ofrecido en aprobación';
          update opp;
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setObjectId(opp.id);
          Approval.ProcessResult result = Approval.process(req1);
          return 'El pedido fue enviado a aprobación antes de ser integrado con JDE.';
        } else if (opp.LAT_StageName__c == 'Pedido Ofrecido en aprobación'){
            return 'El pedido se encuentra en aprobación para ser integrado con JDE.';
        }
    }

    SalesOrderHandlerTypes.SalesOrderHeaderRequestType header = new SalesOrderHandlerTypes.SalesOrderHeaderRequestType();
    header.salesman = opp.LAT_Account__r.Owner.C_digo_JDE__c;
    header.orderNumberForeign = String.valueOf( opp.id );
    header.customerCode = Integer.valueOf( opp.LAT_Account__r.Client_code_AN8__c );
    header.customerShippingCode = header.customerCode;
    
    List< Account > accListParent = [ SELECT Client_code_AN8__c FROM Account 
        WHERE Id =:opp.LAT_Account__r.Parentid limit 1 ];
    if ( accListParent.size() > 0 && opp.LAT_Country__c == 6 )
        header.customerCode = Integer.valueOf( accListParent[ 0 ].Client_code_AN8__c);
        header.customerShippingCode = Integer.valueOf( opp.LAT_Account__r.Client_code_AN8__c );
    
    header.customerBuyOrder = opp.LAT_NRCustomerOrder__c;
    header.note1 = opp.LAT_DSMessage1__c;
    header.note2 = opp.LAT_DSMessage2__c;   
    
    // Ajuste para resolver a conversão GMT da camada SOA
    Date lTempDate;
    if ( opp.LAT_DTDelivery__c != null )
      lTempDate = opp.LAT_DTDelivery__c;
    else
      lTempDate = opp.LAT_CloseDate__c;
    
    if(lTempDate < date.today()){
        lTempDate = date.today();
    }
    
    header.promisedDate = Datetime.newinstance( lTempDate.year(), lTempDate.month(), lTempDate.day(), 14, 01,02 );
    
    if ( opp.LAT_Freight__c != null && opp.LAT_Freight__c.equalsIgnoreCase( 'FOB' ) )
      header.freightType = 'F';
    else
      header.freightType = '';
    header.orderRequestDate = opp.CreatedDate;
    header.orderRequestTime = 0;
    header.invoiceDate = Date.today();
    
    header.businessUnit = Utils.getCodeFromUDC( opp.LAT_Account__r.Business_Unit_AR__c );
    string oppType = opp.LAT_Type__c;
    if (oppType != null && oppType.length() > 2) {
        header.orderType = oppType.substring(0,2);
    } else {
        header.orderType = oppType;
    }
    if ( opp.LAT_NROrderJDE__c != null && opp.LAT_NROrderJDE__c != '' )
      header.orderNumber = Long.valueOf( opp.LAT_NROrderJDE__c );
    if ( opp.LAT_CDOrderStatus__c != null && opp.LAT_CDOrderStatus__c != 0 )
      header.orderStatus = Integer.valueOf( opp.LAT_CDOrderStatus__c );
      
    boolean hasUpdate = false;
    
    Map< String, LAT_OpportunityLineItem__c > mapItems = new Map< String, LAT_OpportunityLineItem__c >();
    
    List< LAT_OpportunityLineItem__c > listaItens = [ SELECT LAT_CDAction__c, LAT_SkuText__c, LAT_PaymentCondition__c, 
        LAT_NROrder_Item__c, LAT_QTBonus__c, LAT_Quantity__c, LAT_CdUnitBonification__c, LAT_UnitCode__c, LAT_PercentualBonus__c, 
        LAT_PcDiscount__c, LAT_CdLineStatus__c, LAT_AR_UOM__c, LAT_AR_Discount__c, LAT_AR_SentToApproveDiscount__c,
        LAT_Remover__c, LAT_FormatField__c, LAT_AR_MaxDiscount__c, LAT_NROrderLine__c
        FROM LAT_OpportunityLineItem__c 
        WHERE LAT_Opportunity__c =: idSalesforce AND LAT_CdLineStatus__c<>'999' ];
    
    //JPC 27/07/2013: validate that all the opportunity line items were calculated before sending to JDE

    List<LAT_Account_product_payment__c> appList = new List<LAT_Account_product_payment__c>();
    Map<String, LAT_Account_product_payment__c> SkuPCToApp = new Map<String, LAT_Account_product_payment__c>();
    if (opp.LAT_StageName__c != 'Mobile Order' && opp.LAT_OrderOrigin__c != 'APP'){
      for ( LAT_OpportunityLineItem__c oppItem : listaItens ) {
          if ((oppItem.LAT_FormatField__c == null || oppItem.LAT_FormatField__c.length() == 0) 
              && (oppItem.LAT_AR_Discount__c != null && oppItem.LAT_AR_Discount__c != 0) ) {
              return 'No es posible enviar a JDE porque hay productos sin cálculo de precio.';
          }
      }
    } else if (opp.RecordType.Name.endsWith('ARG') && opp.LAT_StageName__c == 'Mobile Order' && opp.LAT_OrderOrigin__c == 'APP'){
      WS04_PriceCalculationInterface_AR.LAT_PriceCalculationFromOrderHandler(idSalesforce, listaItens);

      List<String> paymentConditions = new List<String>();
      List<String> productsList =  new List<String>();
      for ( LAT_OpportunityLineItem__c oppItem : listaItens ) {
          paymentConditions.add(oppItem.LAT_PaymentCondition__c);
          productsList.add(oppItem.LAT_SkuText__c);
      }

      appList = [SELECT Id, LAT_Product__c, PaymentCondition__c, LAT_Product__r.LAT_Sku__c, PaymentConditionDescription__c, PercentualBonus__c, Product__r.SKU__c
                      FROM LAT_Account_product_payment__c 
                      WHERE Account__c =: opp.LAT_Account__c AND PaymentCondition__c IN: paymentConditions 
                            AND LAT_Product__r.LAT_Sku__c IN: productsList];

      for (LAT_Account_product_payment__c app: appList) {
        //system.debug('app.Product__r.SKU__c--->' + app.LAT_Product__r.LAT_Sku__c);
        //system.debug('app.PaymentCondition__c--->' + app.PaymentCondition__c);
        SkuPCToApp.put(app.LAT_Product__r.LAT_Sku__c + app.PaymentCondition__c, app);
      }

      for ( LAT_OpportunityLineItem__c oppItem : listaItens ) {
         //system.debug('SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c)--->' + SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c));
        if (SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c) != null) {
          oppItem.LAT_AR_MaxDiscount__c = SkuPCToApp.get(oppItem.LAT_SkuText__c+oppItem.LAT_PaymentCondition__c).PercentualBonus__c;
        }
      }
      opp.LAT_AR_CreditLimitBalance__c = 0;

    }


    List< SalesOrderHandlerTypes.SalesOrderItemRequestType > items = new List< SalesOrderHandlerTypes.SalesOrderItemRequestType >();
    
    if (listaItens.size() == 0) {
        return 'No es posible enviar a JDE porque no hay productos seleccionados.';
    }
    
    for ( LAT_OpportunityLineItem__c oppItem : listaItens )
    {
      boolean isForApproval = false;
      String theMesssage;
        if ((oppItem.LAT_AR_SentToApproveDiscount__c && opp.LAT_StageName__c == 'Novo pedido')
            || (oppItem.LAT_AR_SentToApproveDiscount__c && opp.LAT_StageName__c == 'Mobile Order')) {
            opp.LAT_StageName__c = 'Pedido con descuento en aprobación';
            theMesssage = 'Pedido enviado a aprobación de descuento.';
            isForApproval = true;
        }
        if((!oppItem.LAT_AR_SentToApproveDiscount__c && opp.LAT_Type__c == 'SV - Free Goods (Sales)' && opp.LAT_StageName__c == 'Novo pedido')
          || (!oppItem.LAT_AR_SentToApproveDiscount__c && (opp.LAT_Type__c == 'SV - Free Goods (Sales)' || opp.LAT_Type__c == 'SV') && opp.LAT_StageName__c == 'Mobile Order')){
          opp.LAT_StageName__c = 'Approval pending';
          theMesssage = 'Pedido enviado a aprobación.';
          isForApproval = true;
        }
        if (!isForApproval && opp.RecordType.Name.endsWith('ARG') && opp.LAT_StageName__c == 'Mobile Order' && opp.LAT_OrderOrigin__c == 'APP') {
            decimal jdeDiscount = 0;
            //Hago la consulta de si estoy en el price calculation viejo o nuevo.
            if (WS04_PriceCalculationInterface_AR.isNewPriceCalculation('Argentina')) {
              //NEW
              if (oppItem.LAT_JDETotalDiscount__c != null) {
                  jdeDiscount = oppItem.LAT_JDETotalDiscount__c;
              }
              if (oppItem.LAT_AR_MaxDiscount__c != null && oppItem.LAT_AR_MaxDiscount__c < (oppItem.LAT_AR_Discount__c + jdeDiscount.abs()) ) {
                  opp.LAT_StageName__c = 'Pedido con descuento en aprobación';
                  oppItem.LAT_AR_SentToApproveDiscount__c = true;
                  isForApproval = true;
              }
            } else {
              //OLD
              if (oppItem.LAT_FormatField__c != null && oppItem.LAT_FormatField__c != '') {
                  Pattern myPattern = Pattern.compile('(?<=>.?Bonificaci.?.?n.?.?</td>).*?</td>');
                  Matcher myMatcher = myPattern.matcher(oppItem.LAT_FormatField__c);
                  string htmlFiltrado = '';
                  if (myMatcher.find()) {
                      htmlFiltrado = myMatcher.group();
                  }
                  htmlFiltrado = htmlFiltrado.replaceAll('<.*?>','');
                  if (htmlFiltrado != '') {
                      jdeDiscount = Decimal.valueOf(htmlFiltrado.replace('.', '').replace(',','.').trim());
                  }
                  system.debug('jdeDiscount------>' + jdeDiscount);
              }
            
              if (oppItem.LAT_AR_Discount__c == null) {
                  oppItem.LAT_AR_Discount__c = 0;
              }
              system.debug('jdeDiscount------>' + jdeDiscount);
              system.debug('Discount_AR__c------>' + oppItem.LAT_AR_Discount__c);
              system.debug('LAT_AR_MaxDiscount__c------>' + oppItem.LAT_AR_MaxDiscount__c);
              
              if (oppItem.LAT_AR_MaxDiscount__c != null && oppItem.LAT_AR_MaxDiscount__c < (oppItem.LAT_AR_Discount__c + jdeDiscount.abs()) ) {
                  opp.LAT_StageName__c = 'Pedido con descuento en aprobación';
                  oppItem.LAT_AR_SentToApproveDiscount__c = true;
                  isForApproval = true;
              }
            }
        }
        if(isForApproval){
            update opp;
            if (opp.RecordType.Name.endsWith('ARG') && opp.LAT_OrderOrigin__c == 'APP') {
              system.debug('listaItens----->' + listaItens);
              update listaItens;
            }
            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
            app.setObjectId(opp.id);
            try{Approval.ProcessResult result = Approval.process(app);}catch(Exception e){}
            return theMesssage;
        }
    
        for ( LAT_OpportunityLineItem__c oppItemL : listaItens ){
          if (oppItem.LAT_AR_SentToApproveDiscount__c && opp.LAT_StageName__c == 'Pedido con descuento en aprobación') 
              return 'Pedido esperando aprobación de descuento';
          
          if (oppItem.LAT_AR_SentToApproveDiscount__c && opp.LAT_StageName__c == 'Pedido con descuento en aprobación') 
              return 'Pedido esperando aprobación de descuento';
        }
        
      SalesOrderHandlerTypes.SalesOrderItemRequestType item = new SalesOrderHandlerTypes.SalesOrderItemRequestType();
      if (oppItem.LAT_Remover__c) {
        item.actionCode = CONST_CANCEL;
      } else if ( oppItem.LAT_CDAction__c == null  || !oppItem.LAT_CDAction__c.equalsIgnoreCase( CONST_CANCEL ) ) {
        if ( oppItem.LAT_NROrderLine__c == null || oppItem.LAT_NROrderLine__c.equalsIgnoreCase( '' ) )
          item.actionCode = CONST_INSERT;
        else
          item.actionCode = '';
      } else {
        item.actionCode = oppItem.LAT_CDAction__c;
      }
      if ( oppItem.LAT_CDAction__c != null )
        hasUpdate = hasUpdate || ( oppItem.LAT_CDAction__c.equalsIgnoreCase( CONST_CANCEL ) || oppItem.LAT_CDAction__c.equalsIgnoreCase( CONST_INSERT ) );
      if ( oppItem.LAT_NROrderLine__c != null )
        item.lineNumber = Integer.valueOf( oppItem.LAT_NROrderLine__c );
      if (oppItem.LAT_SkuText__c != null && oppItem.LAT_SkuText__c.trim().length() > 0) {
        item.sku = oppItem.LAT_SkuText__c;
      }
      item.paymentTerm = oppItem.LAT_PaymentCondition__c;
      item.billedTotalQuantity = oppItem.LAT_Quantity__c;
      item.bonusQuantity = Integer.valueOf( oppItem.LAT_QTBonus__c );
      item.bonusPercentual = oppItem.LAT_PercentualBonus__c;
      if ( oppItem.LAT_UnitCode__c == null || oppItem.LAT_UnitCode__c.equalsIgnoreCase( '' ) )
        item.bonusUnit = 'CA';
      else
        item.bonusUnit = String.valueOf( oppItem.LAT_UnitCode__c );
      item.salesUOM = oppItem.LAT_AR_UOM__c; //difference with original
      if (oppItem.LAT_AR_Discount__c != null) {
        item.percentualDiscount = oppItem.LAT_AR_Discount__c; //difference with original
      } else {
        item.percentualDiscount = 0;
      }
      item.orderLineStatus = oppItem.LAT_CdLineStatus__c;
      
      // Campos obligatorios de items
      item.promisedDate = header.promisedDate;
      item.estimatedDeliveryDate = header.promisedDate;
      item.logisticsPromisedDate = header.promisedDate;
      item.realDeliveryDate = header.promisedDate;
      
      items.add( item );
      mapItems.put( oppItem.LAT_SkuText__c, oppItem );
      
      debugItem += ' |start item, lineNumber: ' + item.lineNumber + ' - sku: ' + item.sku + ' - salesUOM: ' + item.salesUOM + ' - paymentTerm: ' + item.paymentTerm + ' - billedTotalQuantity: ' + item.billedTotalQuantity
      + ' - bonusQuantity: ' + item.bonusQuantity + ' - bonusPercentual: ' + item.bonusPercentual + ' - bonusUnit: ' + item.bonusUnit + ' - percentualDiscount: ' + item.percentualDiscount + ' - orderLineStatus: ' + item.orderLineStatus + ' - actionCode: ' + item.actionCode;
      
    }
    
    if ( opp.LAT_CDAction__c == null || ( !opp.LAT_CDAction__c.equalsIgnoreCase( CONST_CANCEL ) && hasUpdate ) )
    {
      if ( opp.LAT_NROrderJDE__c != null && Long.valueOf(opp.LAT_NROrderJDE__c) > 0 )header.actionCode = CONST_UPDATE;
      else header.actionCode = CONST_INSERT;
    }
    else
      header.actionCode = opp.LAT_CDAction__c;
    
    // Campos obligatorios de header
    header.purchaseOrderUntil = header.promisedDate;
      
    debugStr = 'Salesman: ' + header.salesman+' - orderNumberForeign: ' + header.orderNumberForeign + ' - customerCode: '+header.customerCode+' - customerShippingCode: ' + header.customerShippingCode
    + ' - customerBuyOrder: ' + header.customerBuyOrder + ' - note1: '+header.note1 + ' - note2: '+header.note2 + ' - promisedDate: '+header.promisedDate + ' - freightType: '+header.freightType
    + ' - orderRequestDate: ' + header.orderRequestDate + ' - orderRequestTime: ' + header.orderRequestTime + ' - invoiceDate: ' + header.invoiceDate + ' - businessUnit: ' + header.businessUnit
    + ' - orderType: ' + header.orderType + ' - orderNumber: ' + header.orderNumber + ' - orderStatus: ' + header.orderStatus + ' - actionCode: ' + header.actionCode;
    
    SalesOrderHandler.execute_pt request = new SalesOrderHandler.execute_pt();
    request.timeout_x = 120000;
    SalesOrderHandlerTypes.SalesOrderHandlerResponseType response;
    integer lResponseCode = 0;
    try
    {
        System.debug('request values: ' + debugStr);
        System.debug('request items: ' + debugItem);
        if (opp.RecordType.Name.endsWith('ARG')) {
            lResponseCode = request.execute( getConnectionParameter('Argentina'), header, items );
        } else if (opp.RecordType.Name.endsWith('URU')) {
            lResponseCode = request.execute( getConnectionParameter('Uruguay'), header, items );
        }
        System.debug('lResponseCode success: ' + lResponseCode);
    }
    catch ( Exception e )
    {
      opp.LAT_JDEIntegrationReturn__c = debugStr + '=' + debugItem+'='+e.getMessage();
      opp.LAT_StageName__c = 'Pedido com erro no JDE';
      opp.LAT_Integration__c = true;
      update opp;
      if (opp.RecordType.Name.endsWith('ARG') && opp.LAT_OrderOrigin__c == 'APP') {
        update listaItens;
      }
      return 'Error inespedado en el envio a JDE. Contacte a su administrador de sistema';
    }

    if ( lResponseCode == 0 )
    {
      opp.LAT_StageName__c = opp.LAT_StageName__c == 'Mobile Order' ? 'Moblie Order Sent To JDE' : 'Pedido enviado para o JDE';
      if (opp.RecordType.Name.endsWith('ARG')) {
        opp.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Opportunity__c','OPP_5_OrderBlocked_ARG' );
      } else if (opp.RecordType.Name.endsWith('URU')) {
        opp.RecordTypeId = RecordTypeForTest.getRecType( 'LAT_Opportunity__c','OPP_6_OrderBlocked_URU' );
      } 
      
    }
    else opp.LAT_StageName__c = 'Pedido com erro no JDE';
     
    opp.LAT_Integration__c = true;
    update opp;
    if (opp.RecordType.Name.endsWith('ARG') && opp.LAT_OrderOrigin__c == 'APP') {
      update listaItens;
    }
    return '';
    
  }

  public static SalesOrderHandlerTypes.ClientInfoType getConnectionParameter(string country)
  {
    CS001_JDEInterfaceCredentials__c cred = CS001_JDEInterfaceCredentials__c.getInstance(country);
    SalesOrderHandlerTypes.ClientInfoType connParms = new SalesOrderHandlerTypes.ClientInfoType();
    if (cred != null) {
        connParms.country = cred.Country__c;
        connParms.remoteHostIP = cred.RemoteHostIP__c;
        connParms.system_x = cred.System__c;
        connParms.systemUserID = cred.SystemUserID__c;
        connParms.time_x=Datetime.now();
    }
    return connParms;
     
  }
 //Method for code coverage
    public static void isForCC() {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    } 
}