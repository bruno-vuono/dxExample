/**
 * Docusign Utils:
 * Usage is to have all the static methods to create and sent envolopes to 
 * Docusign, also contains wrappers classes for create the requests
 * @author ernesto@zimmic.com
 */
global with sharing class LAT_Docusign_Utils {

    // Recipients Status
    public static final String DS_RECIPIENT_STATUS_COMPLETED = 'Completed';
    public static final String DS_RECIPIENT_STATUS_CREATED = 'Created';
    public static final String DS_RECIPIENT_STATUS_SENT = 'Sent';
    public static final String DS_RECIPIENT_STATUS_DELIVERED = 'Delivered';
    public static final String DS_RECIPIENT_STATUS_DELIVERY_FAIL = 'AutoResponded';
    public static final String DS_RECIPIENT_STATUS_DECLINED = 'Declined';

    // Docusign envelope status
    public static final String DS_ENVELOPE_STATUS_COMPLETED = 'Completed';
    public static final String DS_ENVELOPE_STATUS_CREATED = 'Created';
    public static final String DS_ENVELOPE_STATUS_SENT = 'Sent';
    public static final String DS_ENVELOPE_STATUS_DELIVERED = 'Delivered';
    public static final String DS_ENVELOPE_STATUS_DECLINED = 'Declined';

    // configuration of docusing used as singleton in the class
    public static LAT_Docusign_Config__c dsConfig {get;set;}

    // TODO: Move to docusign c
    public static  Double SENT_TO_PRESIDENT_GREATER_THAN = getDocusignConfig().Sent_to_President__c;
    public static  Double SENT_TO_FINANCIAL_DIRECTOR_GREATER_THAN = getDocusignConfig().Sent_to_Financial_Director__c;
    public static  Double SENT_TO_COMERCIAL_DIRECTOR_GREATER_THAN = getDocusignConfig().Sent_to_Comercial_Director__c;

    public static final String AUTH_HEADER = 'X-DocuSign-Authentication';


    public static final String RESEND_ENVELOPE_URL_PARAM = '?resend_envelope=true';

    
    webservice static String requestResendButton(id recipientId){
        HTTPResponse res = requestModifyRecipient(recipientId, true);

        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            // all good
            return 'Alteração realizada na Docusign.';
        } else {
            return 'Erro ao reenviar o Signatário a Docusign : ' + res.getStatusCode() + res.getBody();
        }
    }

    /**
     * 
     */
     @future(callout=true)
    public static void cancelDocusignFuture(Id contractId) {
        Lat_contract2__c con= [SELECT id, 
                                                Status__c, 
                                                RecordType.DeveloperName, 
                                                StandardClausesPRB__c, 
                                                Name,
                                                CustomerSignedBy__r.Email,
                                                CustomerSignedBy__r.Name,
                                                CustomerSignedBy__c,
                                                OwnerId,
                                                Owner.Name,
                                                Owner.Email,
                                                CustomerSignatory__r.Email,
                                                CustomerSignatory__r.Name,
                                                CustomerSignatory__c,
                                                ProcessStatus__c,
                                                GeneralManager__c,
                                                Manager__c,
                                                RegionalManager__c,
                                                Use_Consultant_to_Testify__c,
                                                Value__c,
                                                ContractValue__c
                                         FROM LAT_Contract2__c 
                                         WHERE id = :contractId];
        List<Attachment> att = [SELECT Name, Body FROM Attachment where ParentId= :con.Id and Name LIKE 'CANC%' AND ParentId = :con.Id];
        system.debug('VALOR CONTRATO++ = ' + con.ContractValue__c);
        if(!att.isEmpty()){
            requestEnvelopeCreation(con, att);
            system.debug('Ernesto+++ Attachment sent size :' + att.size() + 'Id:'  +att[0].Id);
        } else {
            con.ProcessStatus__c = 'Erro Integração DS';
            con.Docusign_Error_integration__c = 'NO CANCE ATTATCHMENT FOUND FOR ' + contractId;
            system.debug('NO CANCE ATT FOUND FOR ' + contractId);
        }
        
    }
    /**
     * update an recipient in docusign based on our user and resend
     */
     public static HTTPResponse requestModifyRecipient(id recipientId, boolean resend){
        

        LAT_DocuSign_Recipient_Status__c recObj = [SELECT Id, 
                                                        Name,
                                                        Routing_Order__c,
                                                        Parent_Status_Record__c,
                                                        Role__c,
                                                        RecipientId__c,
                                                        Envelope_Id__c,
                                                        Recipient_Name__c,
                                                        DocuSign_Recipient_Email__c
                                                  FROM
                                                     LAT_DocuSign_Recipient_Status__c
                                                  WHERE Id = :recipientId];
        
        
        Recipients recWrapper = new Recipients();

        List<Signers> reqObj= new List<Signers>();
        Signers sign = new Signers();
        // add only the necesary fiedls, recipientId to mapp the object in docusign
        sign = new Signers();
        sign.name = recObj.Recipient_Name__c;
        sign.email =  recObj.DocuSign_Recipient_Email__c;
        sign.recipientId = recObj.RecipientId__c;
        reqObj.add(sign);
        recWrapper.signers = reqObj;
        // GET REQ URL
        String url = getBaseUrl();
        url = url + '/envelopes/' + recObj.Envelope_Id__c +  '/recipients';
        if (resend){
            url = url + RESEND_ENVELOPE_URL_PARAM;
        }
        system.debug(url);
        system.debug(JSON.serialize(recWrapper, true));
        HTTPResponse res = sentRequestDocusign(JSON.serialize(recWrapper, true), url, 'PUT');
        return res;


        // TODO: ADD LOGIC

     }

     /**
     * update an recipient in docusign based on our user
     */
     public static void voidEnvelope(){

        // TODO: ADD LOGIC

     }


    /**
     * Create envelope and the docusign mapped objects:
     *      -get the base url to make the callouts
     *      -create the documents based on the attachment list
     *      -create the signers based on the contract information and other conditions
     *      -send request and create objects using the envelope id (those objects will be updated by docusign connect)
     * @param contract
     * @param attachments
     */
    public static void requestEnvelopeCreation(Lat_contract2__c contract, List<Attachment> docToInsert) {


        DS_envelope env = new DS_envelope();
        List<DS_document> documents = new List<DS_document>();
        List<Signers> signers = new List<Signers>();
        Recipients recip = new Recipients();
        env.recipients = recip;
        env.status = 'sent';
        env.emailSubject = 'Assinatura Contrato ' + contract.Name + ' - PERNOD RICARD BRASIL';
        Integer i = 0;
        try{
            for (Attachment doc:docToInsert){
                DS_document docForReq = new DS_document();
                docForReq.documentBase64 = EncodingUtil.base64Encode(doc.Body);
                i++;
                docForReq.documentId = String.valueOf(i);
                docForReq.fileExtension = 'pdf';
                docForReq.name = doc.Name;

                docForReq.order = String.valueOf(i);
                docForReq.transformPdfFields = 'true';
                documents.add(docForReq);
            }
            env.documents = documents;
            //List<Signers> = generateSignersFromContract();


            //GET REQ URL
            String url = getBaseUrl();
            url = url + '/envelopes';
            signers = generateSignersFromContract(contract);
            env.recipients.signers = signers;
            system.debug('++++RequestEnvCreation:' + signers);
            system.debug('++++RequestEnvCreation:' + JSON.serialize(env));

            //SENT REQ AND PARSE
            HTTPResponse res;
            if (Test.isRunningTest()){
                res = new HTTPResponse();
                res.setStatusCode(200);
                EnvelopeResponse response = new EnvelopeResponse();
                response.envelopeId = 'test';
                response.status = 'test';
                response.uri = 'test';
                res.setBody(JSON.serialize(response));
            } else {
                system.debug('status else++++');
                res = sentRequestDocusign(JSON.serialize(env), url, 'POST');
            }
             
            if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                // all good
                system.debug('status OK');
                EnvelopeResponse resp = (EnvelopeResponse) JSON.deserialize(String.valueOf(res.getBody()), EnvelopeResponse.class);
                
                system.debug('++++RespEnvCreation:' + JSON.serialize(resp));
                //Create objects with the id

                createDsMappingObjects(resp, contract.Id, env);
                contract.ProcessStatus__c = 'Em Assinatura';
                contract.Docusign_Error_integration__c = '';
                contract.ds_Envelope_Id__c = resp.envelopeId;
                update contract;
            } else {

        
                contract.ProcessStatus__c = 'Erro Integração DS';
                contract.Docusign_Error_integration__c = 
                'response: ' + res + 
                'Body: ' + res.getBody();
                system.debug(LoggingLevel.ERROR, 'Something went in the docusign Sync +++' + res);
                system.debug('Response: ' + res.getBody());
                update contract;
            }
        } catch (Lat_Docusign_Exception e) {
            contract.ProcessStatus__c = 'Erro Integração DS';
            contract.Docusign_Error_integration__c = e.getMessage();
            update contract;
            throw e;
        } catch (Exception e) {
            throw e;
        }
    }

/**
 *
 *
 */

    /**
     * Generate the objects that docusign will keep updating with status change
     * the objects represent a envelope, and each recipient for the envelope
     * @param evelopeId - returned by the docusign ws
     * @param signersInst - the list of signers (the same sent to docusign)
     */
    public static void createDsMappingObjects(EnvelopeResponse resp,Id contractId,DS_envelope env) {

        //emtpy the env base64 documents to avoid hitting the size limit
        for (DS_document doc: env.documents){
            doc.documentBase64 = '';
        }

        List<Signers> signersInst = env.recipients.signers;
        LAT_DocuSign_Status__c status = new LAT_DocuSign_Status__c();
        status.DocuSign_Envelope_ID__c = resp.envelopeId;
        status.RecipientsSize__c = signersInst.size();
        status.Lat_contract2__c = contractId;
        status.Api_request_body__c = JSON.serialize(env);
        insert status;

        List<LAT_DocuSign_Recipient_Status__c> recipients = new List<LAT_DocuSign_Recipient_Status__c>();
        for (Signers signer: signersInst){
            LAT_DocuSign_Recipient_Status__c recipient = new LAT_DocuSign_Recipient_Status__c();
            recipient.Recipient_Name__c = signer.name;
            recipient.Name = signer.name;
            recipient.Role__c = signer.RoleName;
            recipient.Parent_Status_Record__c = status.Id;
            recipient.DocuSign_Recipient_Email__c = signer.email;
            recipient.Lat_contract2__c = contractId;
            recipient.RecipientId__c = signer.recipientId;
            recipient.routing_Order__c = Integer.valueOf(signer.routingOrder);
            recipient.Recipient_Status__c = 'Created';
            recipient.related_sfId__c = signer.related_sfId;
            recipients.add(recipient);
        }
        insert recipients;


    }
    /**
     *
     */
    public static List<Signers> generateSignersNewUpdateContract(Lat_contract2__c contract){
        system.debug('entroAca+++');
        List<Signers> retSigners = new List<Signers>();
        Set<Id> signersIds = new Set<Id>();
        signersIds.add(contract.GeneralManager__c);
        signersIds.add(contract.Manager__c);
        signersIds.add(contract.RegionalManager__c);
        signersIds.add(getDocusignConfig().LAT_ComercialDirectorId__c);
        signersIds.add(getDocusignConfig().LAT_FinancialDirectorId__c);
        signersIds.add(getDocusignConfig().LAT_PresidentId__c);
        signersIds.add(getDocusignConfig().LAT_TradeManagerId__c);
        signersIds.add(getDocusignConfig().LAT_Testemunha_PRB_Id__c);

        Lat_contract2__c conValor = [SELECT id, ContractValue__c FROM LAT_Contract2__c WHERE ID = :contract.Id LIMIT 1];


        Double valor = conValor.ContractValue__c;

        Map<Id, User> userSignMap = new Map<Id, User>([SELECT Id, Name, Email from user where Id in:signersIds]);
        Integer i = 1;
        Integer routingOrder = 1;
        //First add the Client
        Signers client = new Signers();
        client.email = contract.CustomerSignatory__r.email;
        client.name = contract.CustomerSignatory__r.Name;
        client.recipientId = String.valueOf(i);
        client.related_sfId = contract.CustomerSignatory__c;
        client.roleName = 'Cliente';
        client.tabs = new Tabs(client.roleName);
        client.routingOrder = String.valueOf(routingOrder);
        routingOrder++;
        retSigners.add(client);
        //  Testemunha Cliente
        if (!contract.Use_Consultant_to_Testify__c){
            Signers testify = new Signers();
            testify.email = contract.CustomerSignedBy__r.email;
            testify.name = contract.CustomerSignedBy__r.Name;
            i++;
            testify.recipientId = String.valueOf(i);
            testify.roleName = 'Testemunha Cliente';
            testify.tabs = new Tabs(testify.roleName);
            testify.related_sfId = contract.CustomerSignedBy__c;
            testify.routingOrder =  String.valueOf(routingOrder);
            routingOrder++;
            retSigners.add(testify);
        } else {
            Signers testify = new Signers();
            testify.email = contract.Owner.email;
            testify.name = contract.Owner.Name;
            i++;
            testify.recipientId = String.valueOf(i);
            testify.roleName = 'Testemunha Cliente';
            testify.related_sfId = contract.OwnerId;
            testify.tabs = new Tabs(testify.roleName);
            testify.routingOrder = String.valueOf(routingOrder);
            routingOrder++;
            retSigners.add(testify);
        }

        // REGIONAL MANAGER
        user regManager = userSignMap.get(contract.RegionalManager__c);
        Signers sign1 = new Signers();
        i++;
        sign1.recipientId = String.valueOf(i);
        sign1.email = regManager.email;
        sign1.Name = regManager.Name;
        sign1.roleName = 'Gerente Regional';
        sign1.tabs = new Tabs(sign1.roleName);
        sign1.related_sfId =contract.RegionalManager__c;
        sign1.routingOrder = String.valueOf(routingOrder );
        routingOrder++;
        retSigners.add(sign1);

        // TRADE GERENTE
        user tradeManager = userSignMap.get(getDocusignConfig().LAT_TradeManagerId__c);
        Signers sign2 = new Signers();
        i++;
        sign2.recipientId = String.valueOf(i);
        sign2.email = tradeManager.email;
        sign2.Name = tradeManager.Name;

        sign2.roleName = 'Gerente Trade';
        sign2.tabs = new Tabs(sign2.roleName);
        sign2.related_sfId = tradeManager.Id;
        sign2.routingOrder = String.valueOf(routingOrder);
        routingOrder++;
        retSigners.add(sign2);



        // DIRECTOR COMERCIAL
        system.debug('VALOR CONTRATO++ = ' + contract.ContractValue__c);
        system.debug('VALOR SENT_TO_COMERCIAL_DIRECTOR_GREATER_THAN++ = ' + SENT_TO_COMERCIAL_DIRECTOR_GREATER_THAN);
        if (valor > SENT_TO_COMERCIAL_DIRECTOR_GREATER_THAN){
            if (userSignMap.get(getDocusignConfig().LAT_ComercialDirectorId__c) != null) {
                user comercialDir = userSignMap.get(getDocusignConfig().LAT_ComercialDirectorId__c);
                Signers sign3 = new Signers();
                i++;
                sign3.recipientId = String.valueOf(i);
                sign3.email = comercialDir.email;
                sign3.Name = comercialDir.Name;
                sign3.related_sfId = comercialDir.Id;
                sign3.roleName = 'Diretor Comercial';
                sign3.tabs = new Tabs(sign3.roleName);
                sign3.routingOrder = String.valueOf(routingOrder);
                routingOrder++;
                retSigners.add(sign3);
            } else {
                throw new Lat_Docusign_Exception('Diretro Comercial no encontrado');
            }
        }

        // DIRECTOR FINANCIERO
        system.debug('VALOR CONTRATO++ = ' + contract.ContractValue__c);
        system.debug('VALOR SENT_TO_FINANCIAL_DIRECTOR_GREATER_THAN++ = ' + SENT_TO_FINANCIAL_DIRECTOR_GREATER_THAN);
        if (valor > SENT_TO_FINANCIAL_DIRECTOR_GREATER_THAN){
            if (userSignMap.get(getDocusignConfig().LAT_FinancialDirectorId__c) != null) {
                user financialDir = userSignMap.get(getDocusignConfig().LAT_FinancialDirectorId__c);
                Signers sign4 = new Signers();
                i++;
                sign4.recipientId = String.valueOf(i);
                sign4.email = financialDir.email;
                sign4.Name = financialDir.Name;
                sign4.roleName = 'Diretor Financeiro';
                sign4.tabs = new Tabs(sign4.roleName);
                sign4.related_sfId = financialDir.Id;
                sign4.routingOrder = String.valueOf(routingOrder);
                routingOrder++;
                retSigners.add(sign4);
            } else {
                throw new Lat_Docusign_Exception('Diretor Financeiro no encontrado');
            }
        }



        // Presidente
        system.debug('VALOR CONTRATO++ = ' + contract.ContractValue__c);
        system.debug('VALOR CONTRAT222++ = ' + valor);
        system.debug('VALOR SENT_TO_PRESIDENT_GREATER_THAN++ = ' + SENT_TO_PRESIDENT_GREATER_THAN);
        if (valor > SENT_TO_PRESIDENT_GREATER_THAN){
            if (userSignMap.get(getDocusignConfig().LAT_PresidentId__c) != null) {
                user president = userSignMap.get(getDocusignConfig().LAT_PresidentId__c);
                Signers sign5 = new Signers();
                i++;
                sign5.recipientId = String.valueOf(i);
                sign5.email = president.email;
                sign5.Name = president.Name;
                sign5.roleName = 'Presidente';
                sign5.tabs = new Tabs(sign5.roleName);
                sign5.routingOrder = String.valueOf(routingOrder);  
                routingOrder++;
                retSigners.add(sign5);
            } else {
                throw new Lat_Docusign_Exception('President no encontrado');
            }
        }

        //  Testemunha PRB (ALLWAYS LAST)
        if (userSignMap.get(getDocusignConfig().LAT_Testemunha_PRB_Id__c) != null) {
            user testPRB = userSignMap.get(getDocusignConfig().LAT_Testemunha_PRB_Id__c);
            Signers sign6 = new Signers();
            i++;
            sign6.recipientId = String.valueOf(i);
            sign6.email = testPRB.email;
            sign6.Name = testPRB.Name;
            sign6.roleName = 'Testemunha PRB';
            sign6.tabs = new Tabs(sign6.roleName);
            sign6.routingOrder = String.valueOf(routingOrder);  
            routingOrder++;
            retSigners.add(sign6);
        } else {
            throw new Lat_Docusign_Exception('Testemunha Prb no encontrado');
        }
        

        return retSigners;
    }


    /**
     *
     */
    public static List<Signers> generateSignersForCancel(Lat_contract2__c contract){
        
        List<Signers> retSigners = new List<Signers>();
        Set<Id> signersIds = new Set<Id>();
        signersIds.add(contract.GeneralManager__c);
        signersIds.add(contract.Manager__c);
        signersIds.add(contract.RegionalManager__c);
        signersIds.add(getDocusignConfig().LAT_ComercialDirectorId__c);
        signersIds.add(getDocusignConfig().LAT_FinancialDirectorId__c);
        signersIds.add(getDocusignConfig().LAT_PresidentId__c);
        signersIds.add(getDocusignConfig().LAT_TradeManagerId__c);
        signersIds.add(getDocusignConfig().LAT_Testemunha_PRB_Id__c);


        Map<Id, User> userSignMap = new Map<Id, User>([SELECT Id, Name, Email from user where Id in:signersIds]);
        Integer i = 1;
        Integer routingOrder = 1;
        

        // REGIONAL MANAGER
        user regManager = userSignMap.get(contract.RegionalManager__c);
        Signers sign1 = new Signers();
        sign1.recipientId = String.valueOf(1);
        sign1.email = regManager.email;
        sign1.Name = regManager.Name;
        sign1.roleName = 'Gerente Regional';
        sign1.tabs = new Tabs(sign1.roleName);
        sign1.related_sfId =contract.RegionalManager__c;
        sign1.routingOrder = String.valueOf(routingOrder );
        routingOrder++;
        system.debug('Signers1+++' + sign1);
        retSigners.add(sign1);
        

        //First add the Client
        Signers client = new Signers();
        client.email = contract.CustomerSignatory__r.email;
        client.name = contract.CustomerSignatory__r.Name;
        client.recipientId = String.valueOf(2);
        client.related_sfId = contract.CustomerSignatory__c;
        client.roleName = 'Cliente';
        client.tabs = new Tabs(client.roleName);
        client.routingOrder = String.valueOf(routingOrder);
        routingOrder++;
        system.debug('Signers1+++' + client);
        retSigners.add(client);

        system.debug('Signers+++' + retSigners);
        return retSigners;

    }


    /**
     * Generate the List on signers based on a contract, this includes
     *  the signers itself and the routing for them
     * @param contract
     * @return list of signers
     */
    public static List<Signers> generateSignersFromContract(Lat_contract2__c contract){
        if (contract.Status__c == 'Distrato Aprovado')
        {
                system.debug('distrato Aprovado');
            return generateSignersForCancel(contract);
        } else {
            system.debug(' Aprovado');
            return generateSignersNewUpdateContract(contract);
        }
    }


    /**
     * get the base Url for the next callouts 
     */
    public static String getBaseUrl(){
        String initUrl = LAT_Docusign_Config__c.getInstance().ds_InitUrl__c;
        HTTPResponse res = sentRequestDocusign(null, initUrl, 'GET');
        system.debug(res);
        LoginInfo logindata;
        if(Test.isRunningTest()){
            logindata = new LoginInfo();
            logindata.loginAccounts = new List<LoginAccounts>();
            LoginAccounts dsAcc = new LoginAccounts();
            dsAcc.accountId = 'test';
            dsAcc.baseUrl = 'test';
            dsAcc.isDefault = 'test';
            dsAcc.userName = 'test';
            dsAcc.userId = 'test';
            dsAcc.email = 'test';
            dsAcc.siteDescription = 'test';
            logindata.loginAccounts.add(dsAcc);
        } else {
            logindata = (LoginInfo) JSON.deserialize(String.valueOf(res.getBody()), LoginInfo.class);
        }
        return logindata.loginAccounts[0].baseUrl;
    }

    /**
     * Sent an request to docusing, handle the authentication and generate the request
     * @return httpresponse - resp from the server
     */
    public static HttpResponse sentRequestDocusign(String reqBody, String reqUrl,String method){
        if(Test.isRunningTest()){
            reqUrl = 'test';
            method = 'POST';
            reqBody = 'test';
        }
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type' , 'application/json');
        req.setHeader(AUTH_HEADER , JSON.serialize(getCredentialData()));
        req.setEndPoint(reqUrl);
        req.setMethod(method);
        

        if (reqBody!= null){
            req.setBody(reqBody);
        }
        Http http = new Http();
        HTTPResponse res;
        if(Test.isRunningTest()){
            res = new HTTPResponse();
        } else {
            res = http.send(req);
        }
        
        return res;
    }

    /**
     * Wrapper classes to handle the envelope creation
     */
    public class DS_envelope{
          public List<ds_document> documents{get;set;}
          public String emailSubject{get;set;}
          public Recipients recipients{get;set;}
          public String status{get;set;}
    }


    public class DS_document{
          public String documentBase64{get;set;}
          public String documentId{get;set;} 
          public String fileExtension{get;set;} 
          public String name{get;set;} 
          public String order{get;set;} 
          public String transformPdfFields{get;set;} 
    }
    public class Signers{
          public String email{get;set;} 
          public String name{get;set;} 
          public String recipientId{get;set;} 
          public String roleName{get;set;} 
          public String routingOrder{get;set;} 
          public Tabs tabs{get;set;} 

          // Local usage only, transient to avoid sent to docusign
          public transient String related_sfId{get;set;} 

    }

    public class Recipients{
          public List<Signers> signers; 
    }


    public class Tabs {
        public List<SignHereTabs> signHereTabs{get;set;} 
        public List<TextTabs> textTabs{get;set;}
        public List<FullNameTabs> fullNameTabs{get;set;} 
        

        public Tabs(String role){
            this.signHereTabs = new List<SignHereTabs>();
            this.textTabs = new List<TextTabs>();
            this.fullNameTabs = new List<FullNameTabs>();

            this.signHereTabs.add(new SignHereTabs('/signTabv1' + role.replaceAll( '\\s+', '') + '/'));
            this.signHereTabs.add(new SignHereTabs('/signTabv2' + role.replaceAll( '\\s+', '') + '/'));
            this.signHereTabs.add(new SignHereTabs('/signTabMinuta' + role.replaceAll( '\\s+', '') + '/'));
            this.fullNameTabs.add(new FullNameTabs('/nameTabv1' + role.replaceAll( '\\s+', '') + '/'));
            this.fullNameTabs.add(new FullNameTabs('/nameTabv2' + role.replaceAll( '\\s+', '') + '/'));
            this.fullNameTabs.add(new FullNameTabs('/nameTabMinuta' + role.replaceAll( '\\s+', '') + '/'));
            this.textTabs.add(new textTabs('/textTabCPFv1' + role.replaceAll( '\\s+', '') + '/'));
            this.textTabs.add(new textTabs('/textTabCPFv2' + role.replaceAll( '\\s+', '') + '/'));
            this.textTabs.add(new textTabs('/textTabCPFMinuta' + role.replaceAll( '\\s+', '') + '/'));



        }

    }

    public class SignHereTabs {
        public String anchorString{get;set;}
        public String anchorUnits{get;set;} 
        public String anchorXOffset{get;set;}
        public String anchorYOffset{get;set;}
        public String width {get;set;}
        public String required {get;set;}
        public String anchorIgnoreIfNotPresent{get;set;}

        /*
         * Basic constructor, only set the anchor string and use constant data
         */
        public SignHereTabs (String tab){
            this.anchorString = tab;
            this.anchorUnits = 'cms';
            this.anchorXOffset = '0';
            this.anchorYOffset = '0';
            this.required = 'true';
            this.width = '50';
            this.anchorIgnoreIfNotPresent = 'true';
        }
    }

    public class TextTabs {
        public String anchorString{get;set;}
        public String anchorUnits{get;set;} 
        public String anchorXOffset{get;set;}
        public String anchorYOffset{get;set;}
        public String width {get;set;}
        public String required {get;set;}
        public String anchorIgnoreIfNotPresent{get;set;}
        /*
         * Basic constructor, only set the anchor string and use constant data
         */
        public TextTabs (String tab){
            this.anchorString = tab;
            this.anchorUnits = 'cms';
            this.anchorXOffset = '0';
            this.anchorYOffset = '0';
            this.width = '65';
            this.required = 'true';
            this.anchorIgnoreIfNotPresent = 'true';

        }

    }

    public class FullNameTabs {
        public String anchorString{get;set;}
        public String anchorUnits{get;set;} 
        public String anchorXOffset{get;set;}
        public String anchorYOffset{get;set;}
        public String width {get;set;}
        public String required {get;set;}
        public String anchorIgnoreIfNotPresent{get;set;}
        public String FontSize{get;set;}
        /*
         * Basic constructor, only set the anchor string and use constant data
         */
        public FullNameTabs (String tab){
            this.anchorString = tab;
            this.anchorUnits = 'cms';
            this.anchorXOffset = '0';
            this.anchorYOffset = '0';
            this.width = '50';
            this.required = 'true';
            this.anchorIgnoreIfNotPresent = 'true';
            this.FontSize = 'Size8';
        }

    }

    /**
     * Wrapper classes to handle the login info
     */
     public class LoginAccounts{
          public String name{get;set;}  
          public String accountId{get;set;}  
          public String baseUrl{get;set;}  
          public String isDefault{get;set;}  
          public String userName{get;set;}  
          public String userId{get;set;} 
          public String email{get;set;} 
          public String siteDescription{get;set;} 
    }
    public class LoginInfo{
          public List<LoginAccounts> loginAccounts{get;set;}  
    }



    public class AuthHeader {
        public String Username;
        public String Password;
        public String IntegratorKey;

        public AuthHeader(String Username, String Password, String IntegratorKey){
            this.Username = Username;
            this.Password = Password;
            this.IntegratorKey = IntegratorKey;
        }
    }

    public class EnvelopeResponse {
        public String envelopeId{get;set;} 
        public String status{get;set;} 
        public String uri{get;set;} 
        public String statusDateTime{get;set;}
    }

    /**
     * Method to get the Credentials to Log into docusign
     * TODO: usage of a custom setting to handle the data.
     */
    public static authHeader getCredentialData(){
        LAT_Docusign_Config__c config = getDocusignConfig();
        return new AuthHeader(config.ds_Username__c, config.ds_password__c, config.ds_integrationKey__c);
    }

    /**
     * class to get the docusign config data
     * singleton usage
     * @return - config for docusign confing
     */
    public static LAT_Docusign_Config__c getDocusignConfig(){
        if (dsConfig == null){
            dsConfig = LAT_Docusign_Config__c.getInstance();
        }
        return dsConfig;
    }


    public class Lat_Docusign_Exception extends Exception {}

}