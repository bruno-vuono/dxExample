public with sharing class LAT_BR_IMM_RestCallHandler {


    public static final String IMM_API_KEY_HEADER = 'x-api-key';
    public static final String IMM_SERVICE_NAME_HEADER = 'x-service-name';
    public static final String IMM_SERVICE_OPERATION_HEADER = 'x-service-operation';

    // Operations
    public static final String IMM_OPERATION_GET_FREEGOOD = 'GetFreeGood';
    public static final String IMM_OPERATION_GET_PAYMENT = 'GetCashPayment';
    public static final String IMM_OPERATION_PAYMEMTN = 'CreateCashPayment';
    public static final String IMM_OPERATION_POST_FREEGOOD = 'CreateAndSendFreeGood';


    //CONSTANST POST FREE GOOD
    public static final Integer IMM_FREE_GOOD_CONCEPTO_PAGO = 0;

    //CONSTANST POST CASH PAYMENT
    public static final Integer IMM_FREE_PAYMENT_CONCEPTO_PAGO = 0;

    // TODO: USE custom setting
    //public static String BASE_URL = 'https://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller';

    public static string bodyTest {
        get {
            if( bodyTest == null ) {
                 bodyTest = '';
            }
            return bodyTest;
        }
        set;
    }



    // Util callouts
    public static GenericBodyIMM createFreeGood(List < LAT_Payment__c > payments) {
        GenericBodyIMM req = new GenericBodyIMM();
        Set < Id > products = new Set < Id > ();
        for (LAT_Payment__c pay: payments) {
            products.add(pay.ProductGroup__c);
        }
        LAT_IMM_Operations__c operation = LAT_IMM_Operations__c.getInstance(IMM_OPERATION_POST_FREEGOOD);
        system.debug(operation);
        req.confiPriceCatalogue = true;
        //req.userName = operation.userLDAP__c;
        req.userLDAP = operation.userLDAP__c;
        req.type = operation.type__c;
        req.description =  payments[0].Finality__c + ' || ' + payments[0].LAT_Contract__r.Name + '||' + payments[0].CreatedDate.month() + '/' + payments[0].CreatedDate.year();
        req.requestDate = String.valueof(Datetime.now()); //2017-11-02T15:21:56.000Z
        req.almacen = new cls_almacen();
        if (payments[0].LAT_Contract__r.account__r.Business_Unit__r != null){
            // internal id es 1-05-crm-df el segundo numero correspo de al almacen
            List<String> internalIdList = payments[0].LAT_Contract__r.account__r.Business_Unit__r.Internal_Id__c.split('-');
            req.almacen.idAlmacen = internalIdList.get(1);
        } else {
            req.almacen.idAlmacen = String.valueOf(operation.idAlmacen__c);
        }



        
        req.idActivity = Integer.valueOf(payments[0].WFNumber__c);
        req.activity = new cls_activity();
        req.activity.idActivity = Integer.valueOf(payments[0].WFNumber__c);
        req.conceptoGasto = new cls_conceptoGasto();
        req.conceptoGasto.idConceptoGasto = Integer.valueOf(operation.idConceptoGasto__c);
        req.currency_p = new cls_currency();
        req.currency_p.idCurrency = Integer.valueOf(operation.idCurrency__c);
        req.provider = new cls_provider();
        req.provider.id = Integer.valueOf(payments[0].LAT_Contract__r.account__r.Client_code_AN8__c);
        req.status = new cls_status();
        req.status.idStatus = Integer.valueOf(operation.idStatus__c);
        req.soldTo = new cls_soldTo();
        req.soldTo.Id = Integer.valueOf(payments[0].LAT_Contract__r.account__r.Client_code_AN8__c);
        req.shipTo = new cls_shipTo();
        req.shipTo.idAddress =  Integer.valueOf(payments[0].LAT_Contract__r.account__r.Client_code_AN8__c);
        req.deliveryClient =  payments[0].LAT_Contract__r.account__r.Client_code_AN8__c;

        List < LAT_ReferenceProduct__c > referenceProducts = [SELECT Id, Name, LAT_Product__c, LAT_Product__r.LAT_ProductCode__c, ReferenceGrouping__c FROM
            LAT_ReferenceProduct__c where ReferenceGrouping__c IN: products
        ];


        Map < String, Integer > productsSKU = new Map < String, Integer > ();
        for (LAT_ReferenceProduct__c lrg: referenceProducts) {
            productsSKU.put(lrg.ReferenceGrouping__c, Integer.valueOf(lrg.LAT_Product__r.LAT_ProductCode__c));
        }
        req.skus = new List < cls_skus > ();
        for (LAT_Payment__c pay: payments) {
            cls_skus currProd = new cls_skus();
            currProd.sku = new cls_sku();
            currProd.sku.code = String.valueOf(productsSKU.get(pay.ProductGroup__c));
            system.debug('the sku is:');
            if (String.isBlank(currProd.sku.code)){
                throw new IMMNoskuException();
            }
            pay.Sku_at_Integration__c = currProd.sku.code;
            currProd.measureUnit = new cls_measureUnit();
            currProd.measureUnit.uniMed = operation.measureUnit__c;
            currProd.measureUnit.unitCost = 0;
            currProd.requestedQuantity = Integer.valueOf(pay.Volumen__c);
            req.skus.add(currProd);
        }

        String requestString = json.serialize(req);
        requestString = replaceAllTagsRequest(requestString);
        system.debug(requestString);

        httpResponse res = sentRequestGenericCaller(requestString, '', operation);
        system.debug('response' + String.valueOf(res.getBody()));
        String replacedString = replaceAllTagsResponse(String.valueOf(res.getBody()));
        system.debug(replacedString);
            system.debug('response' + String.valueOf(res.getStatusCode()));
        if (res.getStatusCode() != 200){
            IMMException exc = new IMMException('Error');
            system.debug('Error on integrate resp: +++' + replacedString);
            exc.messageBody = replacedString;
            //payment.integrationMessage__c = replacedString;
            system.debug('Error on integrate msg: +++' + payments[0].integrationMessage__c);
            throw exc;
        }
        return (GenericBodyIMM) JSON.deserialize(replacedString, GenericBodyIMM.class);

    }


// Util callouts
    public static GenericBodyIMM createFreeGoodGroup(LAT_Payment__c parent, List < LAT_Payment__c > payments) {
        GenericBodyIMM req = new GenericBodyIMM();
        Set < Id > products = new Set < Id > ();
        for (LAT_Payment__c pay: payments) {
            products.add(pay.ProductGroup__c);
        }
        LAT_IMM_Operations__c operation = LAT_IMM_Operations__c.getInstance(IMM_OPERATION_POST_FREEGOOD);
        system.debug(operation);
        req.confiPriceCatalogue = true;
        //req.userName = operation.userLDAP__c;
        req.userLDAP = operation.userLDAP__c;
        req.type = operation.type__c;
        system.debug(parent.Finality__c);
        system.debug(parent.Finality__c);
        system.debug(parent.Finality__c);
        req.description =  parent.Finality__c + ' || ' + parent.LAT_Contract__r.Name + '||' + parent.CreatedDate.month() + '/' + parent.CreatedDate.year();
        req.requestDate = String.valueof(Datetime.now()); //2017-11-02T15:21:56.000Z
        req.almacen = new cls_almacen();

        if (payments[0].LAT_Contract__r.account__r.Business_Unit__r != null){
            // internal id es 1-05-crm-df el segundo numero correspo de al almacen
            List<String> internalIdList = parent.LAT_Contract__r.account__r.Business_Unit__r.Internal_Id__c.split('-');
            req.almacen.idAlmacen = internalIdList.get(1);
        } else {
            req.almacen.idAlmacen = String.valueOf(operation.idAlmacen__c);
        }
        req.idActivity = Integer.valueOf(parent.WFNumber__c);
        req.activity = new cls_activity();
        req.activity.idActivity = Integer.valueOf(parent.WFNumber__c);
        req.conceptoGasto = new cls_conceptoGasto();
        req.conceptoGasto.idConceptoGasto = Integer.valueOf(operation.idConceptoGasto__c);
        req.currency_p = new cls_currency();
        req.currency_p.idCurrency = Integer.valueOf(operation.idCurrency__c);
        req.provider = new cls_provider();
        req.provider.id = Integer.valueOf(parent.LAT_Contract__r.account__r.Client_code_AN8__c);
        req.status = new cls_status();
        req.status.idStatus = Integer.valueOf(operation.idStatus__c);
        req.soldTo = new cls_soldTo();
        req.soldTo.Id = Integer.valueOf(parent.LAT_Contract__r.account__r.Client_code_AN8__c);
        req.shipTo = new cls_shipTo();
        req.shipTo.idAddress =  Integer.valueOf(parent.LAT_Contract__r.account__r.Client_code_AN8__c);
        req.deliveryClient =  parent.LAT_Contract__r.account__r.Client_code_AN8__c;

        List < LAT_ReferenceProduct__c > referenceProducts = [SELECT Id, Name, LAT_Product__c, LAT_Product__r.LAT_ProductCode__c, ReferenceGrouping__c FROM
            LAT_ReferenceProduct__c where ReferenceGrouping__c IN: products
        ];


        Map < String, Integer > productsSKU = new Map < String, Integer > ();
        for (LAT_ReferenceProduct__c lrg: referenceProducts) {
            productsSKU.put(lrg.ReferenceGrouping__c, Integer.valueOf(lrg.LAT_Product__r.LAT_ProductCode__c));
        }
        req.skus = new List < cls_skus > ();
        for (LAT_Payment__c pay: payments) {
            cls_skus currProd = new cls_skus();
            currProd.sku = new cls_sku();
            currProd.sku.code = String.valueOf(productsSKU.get(pay.ProductGroup__c));
            system.debug('the sku is:');
            if (String.isBlank(currProd.sku.code)){
                throw new IMMNoskuException();
            }
            pay.Sku_at_Integration__c = currProd.sku.code;
            currProd.measureUnit = new cls_measureUnit();
            currProd.measureUnit.uniMed = operation.measureUnit__c;
            currProd.measureUnit.unitCost = 0;
            currProd.requestedQuantity = Integer.valueOf(pay.Volumen__c);
            req.skus.add(currProd);
        }

        String requestString = json.serialize(req);
        requestString = replaceAllTagsRequest(requestString);
        system.debug(requestString);

        httpResponse res = sentRequestGenericCaller(requestString, '', operation);
        system.debug('response' + String.valueOf(res.getBody()));
        system.debug('response' + String.valueOf(res.getStatusCode()));
        String replacedString = replaceAllTagsResponse(String.valueOf(res.getBody()));
        system.debug(replacedString);
        if (res.getStatusCode() != 200){
            IMMException exc = new IMMException('Error');
            system.debug('Error on integrate resp: +++' + replacedString);
            exc.messageBody = replacedString;
            //payment.integrationMessage__c = replacedString;
            //system.debug('Error on integrate msg: +++' + payment.integrationMessage__c);
            throw exc;
        }
        
        return (GenericBodyIMM) JSON.deserialize(replacedString, GenericBodyIMM.class);

    }
    /**
     * Get a FreeGood based on a payment Id
     * @return genericBodyIMM - data for the freegood
     */
    public static GenericBodyIMM getFreeGood(String id) {
        LAT_IMM_Operations__c operation = LAT_IMM_Operations__c.getInstance(IMM_OPERATION_GET_FREEGOOD);
        //String reqUrl = 'http://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller';
        String reqUrl = '?id=' + id;
        httpResponse res = sentRequestGenericCaller(null, reqUrl, operation);
        String replacedString = replaceAllTagsResponse(String.valueOf(res.getBody()));
        system.debug('getFreeGood ++++ ' + replacedString);
        if (res.getStatusCode() != 200){
            IMMException exc = new IMMException('Error No existePago');
            throw exc;
        }
        return (GenericBodyIMM) JSON.deserialize(replacedString, GenericBodyIMM.class);
    }


    public static GenericBodyIMM createCashPayment(LAT_Payment__c payment) {

        LAT_IMM_Operations__c operation = LAT_IMM_Operations__c.getInstance(IMM_OPERATION_PAYMEMTN);
        GenericBodyIMM req = new GenericBodyIMM();
        req.userName = operation.userLDAP__c;
        req.type = operation.type__c;
        req.description = payment.Finality__c + ' ||' + payment.LAT_Contract__r.Name + '||' + payment.CreatedDate.month() + '/' + payment.CreatedDate.year();
        req.requestDate = String.valueof(Datetime.now()); //2017-11-02T15:21:56.000Z
        req.almacen = new cls_almacen();
        req.almacen.idAlmacen = operation.idAlmacen__c;
        req.activity = new cls_activity();
        req.activity.idActivity = Integer.valueOf(payment.WFNumber__c);
        req.conceptoGasto = new cls_conceptoGasto();
        req.conceptoGasto.idConceptoGasto = Integer.valueOf(operation.idConceptoGasto__c);
        req.currency_p = new cls_currency();
        req.currency_p.idCurrency = Integer.valueOf(operation.idCurrency__c);
        req.amount = Double.valueOf(payment.Ammount__c);
        req.provider = new cls_provider();
        req.provider.id = Integer.valueOf(payment.LAT_Contract__r.account__r.Client_code_AN8__c);
        String requestString = json.serialize(req);
        requestString = replaceAllTagsRequest(requestString);
        system.debug('request: +++' + requestString);

        httpResponse res = sentRequestGenericCaller(requestString, '', operation);
        String replacedString = replaceAllTagsResponse(String.valueOf(res.getBody()));
        if (res.getStatusCode() != 200){
            IMMException exc = new IMMException('Error');
            system.debug('Error on integrate resp: +++' + replacedString);
            exc.messageBody = replacedString;
            payment.integrationMessage__c = replacedString;
            system.debug('Error on integrate msg: +++' + payment.integrationMessage__c);
            throw exc;
        }
        system.debug('resp: +++' + replacedString);
        return (GenericBodyIMM) JSON.deserialize(replacedString, GenericBodyIMM.class);
    }


    /**
     * Get a FreeGood based on a payment Id
     * @return genericBodyIMM - data for the freegood
     */
    public static GenericBodyIMM getCashPayment(String id) {

        LAT_IMM_Operations__c operation = LAT_IMM_Operations__c.getInstance(IMM_OPERATION_GET_PAYMENT);
        String reqUrl = '?id=' + id;
        //String reqUrl = 'http://osbqa.pramericas.com/IMM/Proxy_Services/RestGenericCaller';
        httpResponse res = sentRequestGenericCaller(null, reqUrl, operation);
        String replacedString = replaceAllTagsResponse(String.valueOf(res.getBody()));
        system.debug(replacedString);
        if (res.getStatusCode() != 200){
            IMMException exc = new IMMException('Error No existePago');
            throw exc;
        }
        return (GenericBodyIMM) JSON.deserialize(replacedString, GenericBodyIMM.class);
    }

    /**
     * Sent an request to docusing, handle the authentication and generate the request
     * @return httpresponse - resp from the server
     */
    public static HttpResponse sentRequestGenericCaller(String reqBody,
        String partialUrl,
        LAT_IMM_Operations__c operation) {


        if (Test.isRunningTest()) {
            partialUrl = 'test';
            reqBody = 'test';
        }
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(operation.EndpointUrl__c + partialUrl);
        req.setMethod(operation.Http_operation__c);
        req.setHeader(IMM_SERVICE_OPERATION_HEADER, operation.operation_Name_header__c);
        req.setHeader(IMM_SERVICE_NAME_HEADER, operation.Service_Name_Header__c);
        req.setHeader(IMM_API_KEY_HEADER, operation.x_Api_key__c);
        req.setTimeout(2 * 60 * 1000);


        if (reqBody != null) {
            req.setBody(reqBody);
        }
        Http http = new Http();
        HTTPResponse res;
        if (Test.isRunningTest()) {
            res = new HTTPResponse();
            res.setBody(bodyTest);
        } else {
            res = http.send(req);
        }

        return res;
    }

    public class GenericBodyIMM {

        public String userName;
        public String userLDAP;
        public Integer id; //32
        public String type; //PSC
        public String companyId; //PSC
        public String description; //Teste de IntegraciÃ³n
        public String requestDate; //2017-11-02T15:21:56.000Z
        public cls_soldTo soldTo;
        public cls_almacen almacen;
        public cls_conceptoGasto conceptoGasto;
        public cls_shipTo shipTo;
        public boolean confiPriceCatalogue;
        public Integer idActivity;
        public cls_currency currency_p;


        public Double amount; //200
        public cls_status status;
        public cls_activity activity;
        public cls_subarea subarea;
        public String invoiceName;
        public Double totalAmount; //200
        public Integer bottles; //2
        public String deliveryClient;
        public String requestingUser; //JGOMES01 - Jefferson Gomes
        public String jdeId;
        public Integer idErp;
        public cls_provider provider;
        public String balance;
        public String orderType; //SM
        public Double phone; //551192223333
        public String contact; //Lionel Messi
        public String deliveryInstructions; //delivery Instructions
        public Integer indBoi; //0
        public List < cls_skus > skus;
        //public List < cls_devs > devs;

        public GenericBodyIMM() {}

    }

    class cls_soldTo {
        public Integer id; //9968
        public String name; //CONDOMINIO SAO PAULO CORPORATE TOWERS
        public Integer internalClient; //0
    }
    class cls_name {}
    class cls_almacen {
        public String idAlmacen; //4
        public String name; //Resende
    }
    class cls_conceptoGasto {
        public Integer idConceptoGasto; //18
        public String name; //Consumer & Shopper Insight & Analytics
    }
    class cls_shipTo {
        public Integer idAddress; //322
        public String cliente;
        public String address1;
        public String address2;
        public String country;
        public String state;
        public String city;
        public String postalCode;
    }

    class cls_currency {
        public Integer idCurrency; //1
        public String name; //Brazil - Real
        public String code; //BRL
    }
    public class cls_status {
        public Integer idStatus;
        public String description;
        public String name;
    }
    class cls_activity {
        public Integer idActivity; //1
    }
    class cls_subarea {
        public Integer idSubarea; //9
    }

    public class cls_skus {
        public cls_sku sku;
        public cls_measureUnit measureUnit;
        public Integer requestedQuantity; //1
        public Double totalCost; //100
        public String deliverDate; //2017-10-20T11:00:00.000Z
        public cls_status status; 
        public Integer accountBatchNumber;
    }
    public class cls_sku {
        public String code; //76162
        public String description; //GARRAFA VODKA WYBOROWA EXQUISITE 750ML

    }
    public class cls_measureUnit {
        public String uniMed; //BT
        public Double unitCost; //100
    }
    class cls_id {}
    class cls_description {}
    class cls_devs {}

    public class cls_skustatus {
        public Integer idStatus;
        public String description;
    }

    class cls_provider {
        public Integer id; //51557
        public Integer code; //16274
        public String providerName; //CIA BRASILEIRA DE DISTRIBUICAO
    }
    class cls_dateApproval {}
    //class cls_idErp {}
    class cls_erpDocumentType {}
    class cls_idAttachment {}
    class cls_dateAccount {}


    private static String replaceAllTagsResponse(String toReplace) {
        String replaced = toReplace.replaceAll('currency', 'currency_p');
        return replaced;
    }

    private static String replaceAllTagsRequest(String toReplace) {
        String replaced = toReplace.replaceAll('currency_p', 'currency');
        return replaced;
    }

    public class IMMException extends Exception {
        public String messageBody {get;set;}

    }

    public class IMMNoskuException extends Exception {

    }



}