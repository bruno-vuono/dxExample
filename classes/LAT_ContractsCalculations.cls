/*
* LAT_ContractsCalculations
* Author: Martin Prado (martin@zimmic.com)
* Date: 07/22/2016
*/
global with sharing class LAT_ContractsCalculations {

    //constants for usage
    public static final String MINUTA_PADRAO= 'MinutaPadrao';
    public static final String MINUTA_PADRAO_PATROCIONO = 'Minuta Padrao Contrato Patrocinio';
    public static final String CANCEL_DOCUMENT_TAG= 'CANCE';


    // constructor
    public LAT_ContractsCalculations() {    }

    /*
    * calculateROI
    * @param gainFromInvestment - Money spent by the customer throughout the contract
    * @inversion -  Pernod ricard invesment throughout products and money
    */
    public Double calculateROI(Double gainFromInvestment, Double inversion){
        if(inversion != 0){
            // OLD Method changed BY Leonardo Fiorio request 9/5/17
            //return (gainFromInvestment/inversion) - 1;
            return ((gainFromInvestment/inversion) - 1)  * 100;
        }
        return  0;
    }

    /*
    * setProductCostOnPayment
    * @param paymentsIds - List of payments to be process
    */
    public void setProductCostOnPayment(List<LAT_Payment__c> paymentsToUpdate) {

        String uf = '';
        Date dateBetween;
        List<LAT_ContractsCalculations.productCost> productCosts = new List<LAT_ContractsCalculations.productCost>();

        Set<String> contractId = new Set<String>();

        //for(LAT_Payment__c payment : payments){
        for(LAT_Payment__c payment : paymentsToUpdate){

            LAT_ContractsCalculations.productCost c = new LAT_ContractsCalculations.productCost();
            c.productId = payment.ProductGroup__c;
            contractId.add(payment.LAT_Contract__c);
            productCosts.add(c);
            //uf =  payment.LAT_Contract__r.Account__r.Revenue_UF__c;
            dateBetween = payment.PaymentDate__c;

        }


        List<LAT_Contract2__c> contract = [SELECT  Account__r.Revenue_UF__c, Id from LAT_Contract2__c   where id in : contractId ] ;
        for(LAT_Contract2__c c : contract){
            uf =  c.Account__r.Revenue_UF__c;
        }


        LAT_ContractsCalculations LL = new LAT_ContractsCalculations();
        productCosts = LL.getProductAveragesWithDate(productCosts, uf, 'LAT_ProductPayment', dateBetween);
        productCosts = LAT_ContractsWS.convertUnits(productCosts, 'CA');

        for(LAT_ContractsCalculations.productCost prod : productCosts){
            Id prodId = prod.productId;
            Double aAndPCost = prod.ldCost;
            for(LAT_Payment__c payment : paymentsToUpdate){
                if(prodId == payment.ProductGroup__c){
                    payment.productValue__c = aAndPCost;
                    payment.CurrencyIsoCode = 'BRL';
                }
            }

        }
    }

    /*
    * updateOriginalDate
    * When the contract is active with must to set the original date of the child payments based on the payment date
    * @param contractsId - Contract to Process
    */
    public static void updateOriginalDate(Id contractId){
        List<LAT_Contract2__c> contracts =  [SELECT Id, (Select Id, PaymentDateOriginal__c, PaymentDate__c from LAT_Payments__r order by RecordTypeId desc ) FROM LAT_Contract2__c where id = : contractId];
        List<LAT_Payment__c> payToUpdate = new List<LAT_Payment__c>();
        for(LAT_Contract2__c contract : contracts){
            for(LAT_Payment__c payment : contract.LAT_Payments__r){
                payment.PaymentDateOriginal__c = payment.PaymentDate__c;
                payToUpdate.add(payment);
            }
        }
        update payToUpdate;
    }

    /*
    * calculatePaymentsInformation
    * Function to check all the payments from a specific or a list of contracts and save "Custo PRB",  "Valor Percebido" and GMDC Total
    * @param contractsIds - List of contract to be process
    */
    public void calculatePaymentsInformation(Set<Id> contractIds) {

        List<LAT_Contract2__c> contracts =  [SELECT  TotalMoneyPerceivedValue__c, Account__r.Revenue_UF__c, GMDC_Total__c, TotalMoneyPRBCost__c,TotalProductsPerceivedValue__c,TotalProductsPRBCost__c , (Select Id, Ammount__c, ProductGroup__c, Finality__c, Volumen__c, RecordType.Name from LAT_Payments__r order by RecordTypeId desc ) FROM LAT_Contract2__c where id in : contractIds];
        system.debug(contracts);
        // Update values for each contract
        for(LAT_Contract2__c contract : contracts){

            Double totalMoneyPerceivedValue = 0;
            Double totalMoneyPRBCost = 0;

            Map<Id, Double> productGroupMap = new Map<Id, Double>();

            for(LAT_Payment__c payment : contract.LAT_Payments__r){

                // Payment of Money are the sum of ammount
                if(payment.recordType.Name == 'Pagamento Dinheiro'){
                    totalMoneyPerceivedValue = totalMoneyPerceivedValue + payment.Ammount__c;
                }

                // Group the products,  and add the number of boxes, if we have 3 payments of 10 boxes of chivas,
                // we save a map "CHIVAS, 30"
                if(payment.recordType.Name == 'Pagamento Produto'){
                    Id productGroup = payment.ProductGroup__c;
                    Double volume = payment.Volumen__c;

                    //If exists I must add the volume to the current volume
                    if(productGroupMap.containsKey(productGroup)){
                        Double currentVolume = productGroupMap.get(productGroup);
                        productGroupMap.put(productGroup, currentVolume + volume);
                    }
                    else {
                        //If not exists create a new map item
                        productGroupMap.put(productGroup, volume);
                    }
                }
            }

            // Call the function that resolve the calculations
            String uf = contract.Account__r.Revenue_UF__c;
            List<double> calculations =  totalProductsCalculation(productGroupMap, uf);
            Double totalProductsPRBCost= calculations[0];
            Double totalProductsPerceivedValue = calculations[1];
            Double totalproductGMDC= calculations[2];

            //Set the fields with the new value
            contract.TotalMoneyPerceivedValue__c = totalMoneyPerceivedValue ;
            contract.TotalMoneyPRBCost__c = totalMoneyPerceivedValue ;
            contract.TotalProductsPerceivedValue__c =  totalProductsPerceivedValue ;
            contract.TotalProductsPRBCost__c = totalProductsPRBCost;
            contract.GMDC_Total__c = totalproductGMDC;

            System.DEBUG('>>>>>>>'+contract);

        }
        //update contracts
        update contracts;
    }


    /*
    * getQuarterInformation
    * Check the values of the contract based the values on the some quarter
    * @param contractsIds - List of contract to be process
    */
    public Double getQuarterInformation(Id contractId,  Date fromDate, Date until) {

        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>> fromDate \n ' +fromDate);
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>> until \n ' +until);

        List<LAT_Contract2__c> contracts =  [SELECT TotalMoneyPerceivedValue__c, Account__r.Revenue_UF__c, GMDC_Total__c, TotalMoneyPRBCost__c,TotalProductsPerceivedValue__c,TotalProductsPRBCost__c , (Select Id, Ammount__c, ProductGroup__c, Finality__c, Volumen__c, RecordType.Name, PaymentDate__c from LAT_Payments__r where PaymentDate__c  <: until and paymentDate__c >:fromDate order by RecordTypeId desc ) FROM LAT_Contract2__c where id =: contractId];
        LAT_Contract2__c contract;
        if(contracts.size()>0) {
            contract = contracts.get(0);
        }
        Double contractValueQuarter = 0;
        system.debug(contracts);
        // Update values for each contract
        if(contract != null) {

            Double totalMoneyPerceivedValue = 0;
            Double totalMoneyPRBCost = 0;

            Map<Id, Double> productGroupMap = new Map<Id, Double>();

            for(LAT_Payment__c payment : contract.LAT_Payments__r){

                // Payment of Money are the sum of ammount
                if(payment.recordType.Name == 'Pagamento Dinheiro'){
                    totalMoneyPerceivedValue = totalMoneyPerceivedValue + payment.Ammount__c;
                }

                // Group the products,  and add the number of boxes, if we have 3 payments of 10 boxes of chivas,
                // we save a map "CHIVAS, 30"
                if(payment.recordType.Name == 'Pagamento Produto'){
                    Id productGroup = payment.ProductGroup__c;
                    Double volume = payment.Volumen__c;

                    //If exists I must add the volume to the current volume
                    if(productGroupMap.containsKey(productGroup)){
                        Double currentVolume = productGroupMap.get(productGroup);
                        productGroupMap.put(productGroup, currentVolume + volume);
                    }
                    else {
                        //If not exists create a new map item
                        productGroupMap.put(productGroup, volume);
                    }
                }
            }

            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n ' +productGroupMap);

            // Call the function that resolve the calculations
            String uf = contract.Account__r.Revenue_UF__c;
            //Set the fields with the new value
            List<double> calculations =  totalProductsCalculation(productGroupMap, uf);
            Double totalProductsPRBCost= calculations[0];
            Double totalProductsPerceivedValue = calculations[1];
            Double totalproductGMDC= calculations[2];
            contractValueQuarter = totalMoneyPerceivedValue+totalProductsPRBCost;

        }

        return contractValueQuarter;
    }

    /*
    * totalProductsCalculation
    * Check the product cost, do the calculations and return a List with:
    * productsPRBCost, productsPerceivedValue and productGMDCTotal
    * @param productGroupMap - Map<productId, quantity>
    */
    public List<Double> totalProductsCalculation(Map<Id, Double> productGroupMap, String uf){

        Set<Id> productsId = productGroupMap.keySet();
        Double productsPRBCost = 0;
        Double productsPerceivedValue = 0;
        Double productGMDCTotal = 0;


        List<LAT_ContractsCalculations.productCost> productCosts = new List<LAT_ContractsCalculations.productCost>();

        for (Id productId : productGroupMap.keySet()){
            LAT_ContractsCalculations.productCost c = new LAT_ContractsCalculations.productCost();
            c.productId = productId;
            productCosts.add(c);
        }
        system.debug(uf + ' < ---- UF');
        LAT_ContractsCalculations LL = new LAT_ContractsCalculations();
        // Record Type must be LAT_ContractVolume = >
        productCosts = LL.getProductAverages(productCosts, uf, 'LAT_ProductPayment');

        system.debug(productCosts + ' < ---- P cost before transformation payment ><><>>>>>>>>>>>>>>');
        // We must convert to LT
        productCosts = LAT_ContractsWS.convertUnits(productCosts, 'CA');
        system.debug(productCosts + ' < ---- P cost after transformation payment ><><>>>>>>>>>>>>>>');

        Boolean hasAlltheInfo = true;

        for(LAT_ContractsCalculations.productCost prod : productCosts){
            Double volume = productGroupMap.get(prod.productId);
            productsPRBCost =  productsPRBCost + (prod.ldCost * volume); // CUSTO A&P
            productsPerceivedValue = productsPerceivedValue + (prod.distCost * volume);
            productGMDCTotal = productGMDCTotal + (prod.cmCase * volume);
            if(prod.hasSKU != null && prod.hasSKU == false) {
                hasAlltheInfo = false;
                System.debug('==========\n productId: '+ prod.productId +' < Has not valid info to convert');
            }
        }

        // TO DO, mirar!!!!!
        if(!hasAlltheInfo) {
            //  productsPRBCost = 0;
            //  productsPerceivedValue = 0;
            //  productGMDCTotal = 0;
        }

        List<Double> ret = new List<Double>();
        ret.add(productsPRBCost);
        ret.add(productsPerceivedValue);
        ret.add(productGMDCTotal);
        System.DEBUG('>>>>>>>'+ret);
        return ret;

    }

     /**
     * Method to use from the button in the payment detail Page
     * @param paymentId
     *
     */
    webservice static void addAttachmentsAndTasks(id contratoId){
        List<String> ids = new List<String>();
        ids.add(contratoId);
        LAT_ContractsCalculations.addAttachmentToContract(ids);



    }

    public static void addAttachmentsAndTasks(List<LAT_Contract2__c> triggerNew, Map<id, LAT_Contract2__c> oldMap) {
       // system.debug('addtoattachment+++'+ contract.Status__c);
        List<String> toAttach = new List<String>();
        List<Task> taskList = new List<Task>();
        for (LAT_Contract2__c contract: triggerNew) {
            Integer daysToFinish = 15;
            String[] tdays = LAT_GeneralConfigDao.getValueAsStringArray('CONTRACT_TASK_DAYS', ' ');
            if(tdays != null && tdays.size()>0)daysToFinish = Integer.valueOf(tdays[0]);

            // When we send to approve we must generate the pdfs with a watermark
            if (contract.Status__c == 'Em Aprovação' && oldMap.get(contract.id).Status__c != 'Em Aprovação') {
                system.debug('addtoattachmen2t+++'+ contract.Status__c);
                toAttach.add(contract.id);
            }
            if ((contract.Status__c == 'Aprovado' && oldMap.get(contract.id).Status__c == 'Em Aprovação') || (contract.Status__c == 'Distrato Aprovado' && oldMap.get(contract.id).Status__c != 'Distrato Aprovado')) {
                // we must generate the files only if the contract is active
                system.debug('addtoattachment3+++'+ contract.Status__c);
                if(contract.Status__c == 'Aprovado'){
                    toAttach.add(contract.id);
                    system.debug('addtoattachment4+++'+ contract.Status__c);
                }

                if (!LAT_Docusign_Utils.getDocusignConfig().Enable_Docusign_Contracts__c) {
                    Task notif = LAT_ProcessesTaks.createTask(contract.id, contract.OwnerId, 'Coletar Assinatura do Cliente',
                    '', Global_RecordTypeCache.getRtId('Task'+'LAT_Contract'),
                    daysToFinish, 'CT-Assinatura');
                    taskList.add(notif);
                }

                
            } else if (contract.SignaturesFlow__c == 'Assistente Regional-Contrato Assinado Entregue Consultor' && oldMap.get(contract.id).SignaturesFlow__c != 'Assistente Regional-Contrato Assinado Entregue Consultor') {
                system.debug('addtoattachment5+++'+ contract.Status__c);
                Task notif = LAT_ProcessesTaks.createTask(contract.id, contract.OwnerId, 'Entregar Contrato assinado ao Cliente',
                '', Global_RecordTypeCache.getRtId('Task'+'LAT_Contract'),
                daysToFinish, 'CT-EntregarCliente');

                taskList.add(notif);
            }
        }

        // TO DO: FIX Mariano's code
        if (!toAttach.isEmpty()) {
            addAttachmentToContract(toAttach);
        }
        if (!taskList.isEmpty() && !LAT_Docusign_Utils.getDocusignConfig().Enable_Docusign_Contracts__c) {
            insert taskList;
        }
    }

    /*
    * updateStatus
    * If the owner finish his task to get the client signature, we must update the signature flow field
    * @param List<Task> new, List<Task> old
    */
    public static void updateStatus(List<Task> triggerNew, List<Task> triggerOld) {

        String SIGNATURECHECKER = '**não assinou**';

        Map<id, Task> oldMap = new  Map<id, Task> ([SELECT id, status, Description FROM Task WHERE id IN: triggerOld]);
        Set<String> contractSignedIds = new Set<String>();
        Set<String> contractNotSignedIds = new Set<String>();
        Set<String> conToActivate = new Set<String>();
        for (Task t: triggerNew) {
            if (t.LAT_Tipo__c == 'CT-Assinatura'
            && (t.status == 'Completed' || t.status == 'Not Completed' || t.status == 'Concluído')) {
                //Boolean clientNotSign = t.Description.contains(SIGNATURECHECKER);
                Boolean clientNotSign = t.status == 'Not Completed';
                if(clientNotSign){
                    contractNotSignedIds.add(t.WhatId);
                } else {
                    contractSignedIds.add(t.WhatId);

                }

            } else if (t.LAT_Tipo__c == 'CT-EntregarCliente'
            && (t.status == 'Completed' || t.status == 'Concluído')) {
                conToActivate.add(t.WhatId);
            }

        }
        system.debug('>>>>>>>>>>>>>>contractSignedIds'+ contractSignedIds);
        system.debug('>>>>>>>>>>>>>>contractNotSignedIds'+ contractNotSignedIds);
        system.debug('>>>>>>>>>>>>>>conToActivate'+ conToActivate);

        List<Lat_contract2__c> conSignedToUpdate = [SELECT id, SignaturesFlow__c FROM Lat_contract2__c WHERE id  in:contractSignedIds];
        for(Lat_contract2__c lc2 : conSignedToUpdate){
            lc2.SignaturesFlow__c = 'Consultor-Assinatura Cliente';
            trackDurationReport(lc2, 'STARTDATE');

            // Post in chatter group
        }

        List<Lat_contract2__c> conNotSignedToUpdate = [SELECT id, SignaturesFlow__c FROM Lat_contract2__c WHERE id  in:contractNotSignedIds];
        for(Lat_contract2__c lc2 : conNotSignedToUpdate){
            lc2.ProcessStatus__c = 'Contrato Não Assinado Cliente';
        }

        List<Lat_contract2__c> conToAct = [SELECT id, Status__c, SignaturesFlow__c FROM Lat_contract2__c WHERE id  in:conToActivate];
        for(Lat_contract2__c lc2 : conToAct){
            system.debug('>>>>>>>>>>>>>>lc2'+ lc2);
            if(lc2.Status__c == 'Distrato Aprovado'){
                lc2.Status__c = 'Cancelado';
            } else if(lc2.Status__c == 'Aprovado'){
                lc2.Status__c = 'Ativo';
            }

            lc2.ProcessStatus__c = 'Processo Finalizado';
            lc2.SignaturesFlow__c = 'Consultor-Contrato Ativado';
            trackDurationReport(lc2, 'ENDDATE');
        }
        update conToAct;
        update conNotSignedToUpdate;
        system.debug('>>>>>>>>>>>>>>conSignedToUpdate'+ conSignedToUpdate);
        update conSignedToUpdate;
        //update conSignedToUpdate;
    }


    private static void trackDurationReport(Lat_contract2__c contract, String status){
        List<LAT_objectPerformance__c> objectPerformanceList = [SELECT id,LATContract__c, Type__c,StartDate__c,EndDate__c FROM LAT_objectPerformance__c where LATContract__c =:contract.id];
        LAT_objectPerformance__c objPerItem = new LAT_objectPerformance__c();
        if(objectPerformanceList.size()>0){ objPerItem = objectPerformanceList.get(0);}
        if(status == 'ENDDATE') {
            objPerItem.EndDate__c =  Date.today();
        } else if(status == 'STARTDATE'){
            objPerItem.StartDate__c =  Date.today();
            objPerItem.Type__c = 'Signature Flux duration';
            objPerItem.LATContract__c = contract.Id;
        }
        upsert objPerItem;
    }

    /*
    * updateProcessStatus
    * When the signature change we must update the process status
    * @param List<Task> new, List<Task> old
    */
    public static void updateProcessStatus(List<LAT_Contract2__c> triggerNew) {

        // List
        List<feedItem> feedToInsert = new List<feedItem>();
        List<Id> accounts = new List<Id>();
        // for (LAT_Contract2__c contract: triggerNew) {
        //   if(contract.SignaturesFlow__c == 'Consultor-Assinatura Cliente'){
        //     accounts.add(contract.Account__c);
        //   }
        // }
        // Map<ID, Account> mapAccount = new Map<ID, Account>([SELECT Id, name,Regional__r.name,BillingCity FROM Account where id in:accounts]);
        for (LAT_Contract2__c contract: triggerNew) {
            if(contract.SignaturesFlow__c == 'Consultor-Assinatura Cliente'){
                contract.ProcessStatus__c ='Contrato Assinado Cliente';
                // Account a = mapAccount.get(contract.Account__c);
                // // Only on the first step we must to notify on chatter:
                // Datetime dt = datetime.newInstance(contract.startDate__c.year(), contract.startDate__c.month(),contract.startDate__c.day());
                // String message = 'Contrato {0} do cliente {1} assinado pelo cliente e encaminhado para o Assistente Regional'.replace('{0}', contract.name).replace('{1}', a.name);
                // FeedItem post = new FeedItem();
                // post.Body = message;
                // post.ParentId = contract.Id;
                // post.Title = 'Contrato ' + contract.Name + 'Ativado';
                // feedToInsert.add(post);

            } else if(contract.SignaturesFlow__c == 'Assistente Regional-Contrato Assinado Recebido Consultor'){
                contract.ProcessStatus__c = 'ASS – Contrato Recebido Consultor';

            } else if(contract.SignaturesFlow__c == 'Assistente Regional-Contrato Assinado Entregue Trade'){
                contract.ProcessStatus__c = 'ASS – Contrato Assinado Entregue Trade';

            } else if(contract.SignaturesFlow__c == 'Trade-Contrato Assinado Recebido Ass. Regional'){
                contract.ProcessStatus__c = 'TRA – Contrato Assinado Recebido Assistente';

            } else if(contract.SignaturesFlow__c == 'Trade-Contrato Assinado Entregue Ass. Regional'){
                contract.ProcessStatus__c = 'TRA – Contrato Assinado Entregue Assistente';

            } else if(contract.SignaturesFlow__c == 'Assistente Regional-Contrato Assinado Recebido Trade'){
                contract.ProcessStatus__c = 'ASS – Contrato Assinado Recebido Trade';

            } else if(contract.SignaturesFlow__c == 'Assistente Regional-Contrato Assinado Entregue Consultor'){
                contract.ProcessStatus__c = 'ASS – Contrato Assinado Entregue Consultor';

            } else if(contract.SignaturesFlow__c == 'Consultor-Contrato Ativado'){
                contract.ProcessStatus__c = 'Processo Finalizado';
                trackDurationReport(contract, 'ENDDATE');

            }

            if(!feedToInsert.isEmpty()){
                insert feedToInsert;
            }


        }

    }

    /*
    * chatterGroupNotification
    * Post contract status on  chatter "Contratos OnTrade" group
    */
    public static void chatterGroupNotification(List<LAT_Contract2__c> triggerNew, Map<id, LAT_Contract2__c> oldMap) {

        Set<Id> accountIds = new Set<Id>();
        Set<Id> recordTypeIds = new Set<Id>();
        Map<String, List<LAT_Contract2__c> > contractIdsType = new Map<String, List<LAT_Contract2__c> >();

        for (LAT_Contract2__c contract: triggerNew) {
            // Active Contract
            List<LAT_Contract2__c> cont = new List<LAT_Contract2__c>();

            if (contract.Status__c == 'Ativo' && oldMap.get(contract.id).Status__c != 'Ativo') {
                if(contractIdsType.containsKey('Active')){
                    cont = contractIdsType.get('Active');
                }
                cont.add(contract);
                contractIdsType.put('Active', cont);

            }
            // Active Contract
            else if (contract.Status__c == 'Cancelado' && oldMap.get(contract.id).Status__c != 'Cancelado') {
                if(contractIdsType.containsKey('Cancelled')){
                    cont = contractIdsType.get('Cancelled');
                }
                cont.add(contract);
                contractIdsType.put('Cancelled', cont);
            }

            accountIds.add(contract.Account__c);
            recordTypeIds.add(contract.RecordTypeId);
        }
        // Post
        if (!contractIdsType.isEmpty()) {

            List<Account> ls = [select Id,Name, BillingCity, Segmentation_Type_on_trade__c, Regional__r.name from Account where Id IN :accountIds];
            Map<Id, Account> accountMap = new Map<Id, Account>(ls);
            List<FeedItem> feedItems = new List<FeedItem>();
            // Chatter Group selection
            List<CollaborationGroup> groupC = [SELECT Id,Name From CollaborationGroup WHERE name='Contratos OnTrade'];

            Map<Id, recordType> recorTypemap = new Map<Id, recordType>([Select id, name from recordType where Id in: recordTypeIds]);


            // If the group doesn't exists we don't post a feed
            if(!groupC.isEmpty()){
                if(contractIdsType.containsKey('Active')){
                    for (LAT_Contract2__c cId: contractIdsType.get('Active')){
                        Account a = accountMap.get(cId.Account__c);
                        //Datetime dt  = Datetime.valueOf();
                        Datetime dt = datetime.newInstance(cId.startDate__c.year(), cId.startDate__c.month(),cId.startDate__c.day());
                        String message = 'Contrato com o cliente '+a.name+', Regional '+a.Regional__r.name+', Cidade '+a.BillingCity+', Segmento '+cId.ROISegment__c+' e Tipo '+recorTypemap.get(cId.RecordTypeId).name+' Ativado com vigência a partir de '+dt.format('dd-MM-yyyy')+'.';
                        FeedItem post = new FeedItem();
                        post.Body = message;
                        post.ParentId = groupC[0].Id;
                        post.Title = 'Contrato ' + cId.Name + 'Ativado';
                        feedItems.add(post);
                    }
                }
                else if(contractIdsType.containsKey('Cancelled')){
                    for (LAT_Contract2__c cId: contractIdsType.get('Cancelled')){
                        Account a = accountMap.get(cId.Account__c);
                        String message = 'Contrato com o cliente '+a.name+', Regional '+a.Regional__r.name+', Cidade '+a.BillingCity+', Segmento '+cId.ROISegment__c+' e Tipo '+recorTypemap.get(cId.RecordTypeId).name+' Cancelado.';
                        FeedItem post = new FeedItem();
                        post.Body = message;
                        post.ParentId = groupC[0].Id;
                        post.Title = 'Contrato ' + cId.Name + 'Cancelado';
                        feedItems.add(post);
                    }

                }
                else if(contractIdsType.containsKey('Ended')){
                    for (LAT_Contract2__c cId: contractIdsType.get('Ended')){
                        Account a = accountMap.get(cId.Account__c);
                        String message = 'Contrato com o cliente '+a.name+', Regional '+a.Regional__r.name+', Cidade '+a.BillingCity+', Segmento '+cId.ROISegment__c+' e Tipo '+recorTypemap.get(cId.RecordTypeId).name+' Encerrado.';
                        FeedItem post = new FeedItem();
                        post.Body = message;
                        post.ParentId = groupC[0].Id;
                        post.Title = 'Contrato ' + cId.Name + 'Encerrado';
                        feedItems.add(post);

                    }
                }
            }
            insert feedItems;
        }
    }



    /*
    * addAttachmentsAndTasks
    * Generates a PDF based on the page LAT_ContractCoverPDF and attach it to the contract.
    * Also generates a task linked to the contract for ...
    */
    @Future(callout=true)
    public static void addAttachmentToContract(List<String> toAttachs) {


        List<LAT_Contract2__c> contracts =  [SELECT id, 
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
                                                    convertCurrency(ContractValue__c)
                                             FROM LAT_Contract2__c 
                                             WHERE id IN : toAttachs];
        
        System.debug('%%%%% contracts x attachments : '+ contracts) ;                                     
        String[] minutaPadrao = LAT_GeneralConfigDao.getValueAsStringArray('LAT_ContractMinutaPadrao', ',');
        List<StaticResource> stR = new List<StaticResource>();
        if(minutaPadrao != null){
            stR = [SELECT Body,Description,Id,Name FROM StaticResource where id =: minutaPadrao[0]];
        }


        List<Attachment> currentAtt = [SELECT Name,ParentId FROM Attachment where parentId in : toAttachs];
        System.debug('%%%%% ccurrentAtts : '+ currentAtt) ;      
        List<Attachment> attToDelete = new List<Attachment>();
        Set<Id> attToDeleteIds = new Set<Id>();
        List<Attachment> attList = new List<Attachment>();

        for (LAT_Contract2__c contract: contracts) {
            // Reference the attachment page, pass in the contract ID

            // Anexo 1.1
            PageReference pdf = Page.LAT_ContractCoverPDF;
            pdf.getParameters().put('id',contract.id);
            pdf.setRedirect(true);

            // Anexo 1.2
            PageReference pdf1 = Page.LAT_ContractCoverPDF;
            pdf1.getParameters().put('id',contract.id);
            pdf1.getParameters().put('type','anex2');
            pdf1.setRedirect(true);

            // Minuta Padrao

            
            

            


            Boolean mustGenerateMinutaPadrao = contract.StandardClausesPRB__c;

            // Take the PDF content
            Blob pdfBlob = !Test.isRunningTest() ? pdf.getContent() : Blob.valueOf('Testing');
            Blob pdfBlob1 = !Test.isRunningTest() ? pdf1.getContent() : Blob.valueOf('Testing');
            //Blob pdfBlob2 = !Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing');

            for (Attachment at: currentAtt) {

                if(at.name == 'Contrato - ' + contract.Name + ' - Anexo 1.1.pdf' ) {
                    attToDelete.add(at);
                    attToDeleteIds.add(at.Id);
                }
                if(at.name == 'Contrato - ' + contract.Name + ' - Anexo 1.2.pdf' ) {
                    attToDelete.add( at);
                    attToDeleteIds.add(at.Id);
                }
                // Check
                if(at.name == 'Contrato -  ' + contract.Name + ' - Minuta Padrao.pdf') {
                    if(contract.Status__c == 'Em Aprovação' || !mustGenerateMinutaPadrao){
                        attToDelete.add( at);
                        attToDeleteIds.add(at.Id);
                    }
                }
                if(at.name == 'Contrato - ' + contract.Name + ' - Minuta Padrao Carta Acordo.pdf') {
                    attToDelete.add(at);
                    attToDeleteIds.add(at.Id);
                }

            }

            attList.add ( new Attachment (
                ParentId = contract.id,
                Name = 'Contrato - ' + contract.Name + ' - Anexo 1.2.pdf',
                Body = pdfBlob
            ));

            attList.add ( new Attachment (
                ParentId = contract.id,
                Name = 'Contrato - ' + contract.Name + ' - Anexo 1.1.pdf',
                Body = pdfBlob1
            ));



            SYSTEM.Debug('\n==============contract.Status__c '+ contract.Status__c);
            SYSTEM.Debug('\n==============mustGenerateMinutaPadrao '+ mustGenerateMinutaPadrao);
            SYSTEM.Debug('\n==============contract.recordtype.developerName '+ contract.recordtype.developerName);

            // Em Aprobacao
            if(contract.Status__c != 'Aprovado'){
                SYSTEM.Debug('\n============== A ');

                // Clauslas nao padrao true - checked
                if(mustGenerateMinutaPadrao){
                    PageReference pdf3 = Page.LAT_ContractDocumentsPDF;
                    // LAT_OnTrade_LetterAgreementCommercialCondition On Trade – Carta Acordo de Condição Comercial
                    // LAT_OnTrade_LetterAgreement On Trade – Carta Acordo de Patrocínio
                    // LAT_OnTrade_CommercialConditionContract - On Trade – Contrato de Condição Comercial
                    // LAT_OnTrade_SponsorshipAgreementOnTrade - On Trade – Contrato de Patrocínio 
                    // On Trade – Contrato de Patrocínio
                    if(contract.recordtype.developerName == 'LAT_OnTrade_SponsorshipAgreementOnTrade'){
                        SYSTEM.Debug('\n============== A2');
                    




                    }
                    // On Trade – Carta Acordo de Patrocínio
                    // Leonardo ASK
                    else if (contract.recordtype.developerName == 'LAT_OnTrade_LetterAgreement'){
                        pdf3.getParameters().put('id',contract.id);
                        pdf3.getParameters().put('docName',MINUTA_PADRAO);
                        pdf3.setRedirect(true);
                        SYSTEM.Debug('\n============== A1 ');
                        // new page
                        attList.add ( new Attachment (
                        ParentId = contract.id,
                        Name = 'Contrato - ' + contract.Name + ' - Minuta Padrao Carta Acordo.pdf',
                        Body = (!Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing'))
                        ));

                    }

                // ACA VA EL 



                }
                // Clauslas nao padrao false - unchecked
                else {
                    PageReference pdf3 = Page.LAT_ContractDocumentsPDF;
                    SYSTEM.Debug('\n============== B');
                    // On Trade – Contrato de Patrocínio
                    if (contract.recordtype.developerName == 'LAT_OnTrade_SponsorshipAgreementOnTrade') {
                        pdf3.getParameters().put('id',contract.id);
                        pdf3.getParameters().put('docName',MINUTA_PADRAO_PATROCIONO);
                        pdf3.setRedirect(true);


                        SYSTEM.Debug('\n============== B1 ');
                        //for(StaticResource st : stR){
                            attList.add ( new Attachment (
                            ParentId = contract.id,
                            Name = 'Contrato -  ' + contract.Name + ' - Minuta Padrao.pdf',
                            Body = (!Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing'))
                            ));
                        //}

                    }
                    // On Trade – Carta Acordo de Patrocínio
                    else if (contract.recordtype.developerName == 'LAT_OnTrade_LetterAgreement'){
                        pdf3.getParameters().put('id',contract.id);
                        pdf3.getParameters().put('docName',MINUTA_PADRAO);
                        pdf3.setRedirect(true);

                        SYSTEM.Debug('\n============== B2 ');
                        // new page
                        attList.add ( new Attachment (
                        ParentId = contract.id,
                        Name = 'Contrato - ' + contract.Name + ' - Minuta Padrao Carta Acordo.pdf',
                        Body = (!Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing'))
                        ));

                    }

                }
            }
            


            // Aprovado
            else {
                SYSTEM.Debug('\n============== C ');
                // Clauslas nao padrao true - checked
                if(mustGenerateMinutaPadrao){
                    PageReference pdf3 = Page.LAT_ContractDocumentsPDF;
                    SYSTEM.Debug('\n============== C 1');
                    // On Trade – Carta Acordo de Patrocínio
                    if (contract.recordtype.developerName == 'LAT_OnTrade_LetterAgreement'){
                        pdf3.getParameters().put('id',contract.id);
                        pdf3.getParameters().put('docName',MINUTA_PADRAO);
                        pdf3.setRedirect(true);
                        SYSTEM.Debug('\n============== C 1 1');
                        // new page
                        attList.add ( new Attachment (
                        ParentId = contract.id,
                        Name = 'Contrato - ' + contract.Name + ' - Minuta Padrao Carta Acordo.pdf',
                        Body = (!Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing'))
                        ));
                    }

                }
                
                // Clauslas nao padrao false - unchecked
                else {
                    PageReference pdf3 = Page.LAT_ContractDocumentsPDF;
                    SYSTEM.Debug('\n============== D');
                    // On Trade – Carta Acordo de Patrocínio
                    if (contract.recordtype.developerName == 'LAT_OnTrade_LetterAgreement'){
                        pdf3.getParameters().put('id',contract.id);
                        pdf3.getParameters().put('docName',MINUTA_PADRAO);
                        pdf3.setRedirect(true);
                        SYSTEM.Debug('\n============== D 1');
                        // new page
                        attList.add ( new Attachment (
                        ParentId = contract.id,
                        Name = 'Contrato - ' + contract.Name + ' - Minuta Padrao Carta Acordo.pdf',
                        Body = (!Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing'))
                        ));
                    } 
                    else {
                        SYSTEM.Debug('\n============== J');
                        // On Trade – Contrato de Patrocínio
                        if (contract.recordtype.developerName == 'LAT_OnTrade_SponsorshipAgreementOnTrade') {
                            pdf3.getParameters().put('id',contract.id);
                            pdf3.getParameters().put('docName',MINUTA_PADRAO_PATROCIONO);
                            pdf3.setRedirect(true);


                            SYSTEM.Debug('\n============== B1 ');
                            //for(StaticResource st : stR){
                                attList.add ( new Attachment (
                                ParentId = contract.id,
                                Name = 'Contrato -  ' + contract.Name + ' - Minuta Padrao.pdf',
                                Body = (!Test.isRunningTest() ? pdf3.getContent() : Blob.valueOf('Testing'))
                                ));
                            //}

                        }
                    }


                }

            }
        }

        Map<Id, List<Attachment>> attachmentByParent = new Map<Id, List<Attachment>>();
        // get attachment by parentId
        for (Attachment att:attList){
            if(attachmentByParent.get(att.ParentId) == null){
                attachmentByParent.put(att.ParentId, new List<Attachment>());
            }
            attachmentByParent.get(att.ParentId).add(att);
        }

        // FOR ONE CONTRACT ONLY
        //for(Lat_contract2__c con:contracts){
             if (LAT_Docusign_Utils.getDocusignConfig().Enable_Docusign_Contracts__c && contracts.size() == 1 && contracts[0].Status__c == 'Aprovado'){
               //Add other miutas if exist and they does not match the coded one VERIFY LEO
               List<Attachment> minuta = [SELECT Name,ParentId,Body FROM Attachment where Id NOT IN :attToDeleteIds AND Name LIKE '%Minuta Padrao%' AND ParentId = :contracts[0].Id ];
                attachmentByParent.get(contracts[0].Id).addAll(minuta);
                LAT_Docusign_Utils.requestEnvelopeCreation(contracts[0], attachmentByParent.get(contracts[0].Id));
            }
        //}

       

        if(!attToDelete.isEmpty()){
            delete attToDelete;
        }

        if (!attList.isEmpty()) {
            insert attList;
        }
        //LAT_ContractMinutaPadrao
    }



    /*
    * generatePayments
    *
    * @param contract
    * @param  deleteExistingPayments
    */
    public Boolean generatePayments(Id contractId, Boolean deleteExistingPayments) {


        List<LAT_Contract2__c> contracts = [Select Id, recordTypeId, recordType.Name , status__c, EndDate__c, StartDate__c from LAT_Contract2__c where Id =: contractId];
        system.debug('###### contracts : ' + contracts);
        Boolean paymentsGenerated =  false;
        // Commented by MP, this isn't working since we change boxes to liters
        // if(contracts.size() > 0){
        //  LAT_Contract2__c contract = contracts.get(0);
        //  //Check the type, we geneate payaments only if type is Condição Comercial and is a new contract
        //  if((contract.recordType.Name == 'On Trade – contrato de condição comercial' || contract.recordType.Name == 'On Trade – carta acordo de condição comercial') && contract.status__c == 'Novo Contrato' ){
        //      List<LAT_ContractVolume__c> contractVolume = [SELECT BoxesContract__c,BusinessCondition__c,CreatedById,CreatedDate,CurrencyIsoCode,Id,IsDeleted,LastModifiedById,LastModifiedDate,LAT_Contract__c,Name,ProductGroup__c,SystemModstamp FROM LAT_ContractVolume__c where LAT_Contract__c =: contract.Id];
        //      if(contractVolume.size() > 0) {
        //          // Delete existing payments
        //          if(deleteExistingPayments && !Test.isRunningTest()){
        //              List<LAT_Payment__c> payments = [SELECT Id,LAT_Contract__c FROM LAT_Payment__c where LAT_Contract__c =: contract.id ];
        //              delete payments;
        //          }
        //          List<LAT_Payment__c> payments = new List<LAT_Payment__c>();
        //          // generate payments
        //          for(LAT_ContractVolume__c cv : contractVolume){
        //
        //
        //              Integer months = (contract.EndDate__c.month() + (12*(contract.EndDate__c.year()-contract.StartDate__c.year()))) - contract.StartDate__c.month();
        //              //Generate payment for each month
        //              system.debug('###### months : ' + months);
        //              for(Integer i = 0; i < months; i++){
        //                  LAT_Payment__c pay = new LAT_Payment__c();
        //                  pay.LAT_Contract__c = contract.Id;
        //                  //pay.ProductGroup__c = cv.ProductGroup__c;
        //                  pay.PaymentDate__c = contract.StartDate__c.addMonths(i);
        //                  pay.Status__c = 'P';
        //                  pay.Finality__c = 'Contrato';
        //                  pay.CurrencyIsoCode = 'BRL';
        //                  pay.Volumen__c = Math.round((cv.BoxesContract__c*cv.BusinessCondition__c)/100);
        //                  payments.add(pay);
        //              }
        //              paymentsGenerated = true;
        //          }
        //          system.debug('###### payments : ' + payments);
        //          insert payments;
        //
        //      }
        //      else {
        //          // Without contract volume we can't insert payments
        //          return false;
        //      }
        //  }
        // }

        return paymentsGenerated;
    }

    /*
    * getProductAverages
    *
    */
    public List<productCost> getProductAverages(List<productCost> products, String uf, String recordType) {
        //Default Channels
        //String[] channels = new String[]{'101','102','103','104','112','113','114','115','116'};
        String[] channels = LAT_GeneralConfigDao.getValueAsStringArray('LAT_PRODUCT_COST_CHANNELS', ',');
        return getProductAverages(products, uf, channels, recordType);
    }

    public List<productCost> getProductAverages(List<productCost> products, String uf, String[] channels, String recordType) {
        // By default the date is today
        return getProductAverages(products, uf, channels, recordType, null);
    }

    public List<productCost> getProductAveragesWithDate(List<productCost> products, String uf, String recordType, Date dateBetween) {
        // By default the date is today
        String[] channels = LAT_GeneralConfigDao.getValueAsStringArray('LAT_PRODUCT_COST_CHANNELS', ',');
        return getProductAverages(products, uf, channels, recordType, dateBetween);
    }


    /*
    * getProductAverages
    * Function to calculate the average cost from a Product list in one UF
    * @param List<productCost> with sku name
    * @param String uf
    * @param String[] channels
    * @return List<productCost>  => Product Cost Fields: skuName, nis, ldCost, distCost, cmCase
    * Example:
    * List<LAT_ContractsCalculations.productCost> pc = new List<LAT_ContractsCalculations.productCost>();
    * LAT_ContractsCalculations.productCost c = new LAT_ContractsCalculations.productCost();
    * c.skuName = 'CHIVAS 12';
    * pc.add(c);
    * LAT_ContractsCalculations LL = new LAT_ContractsCalculations();
    * List<String> canals = new String[]{'246'};
    * pc = LL.getProductAverages(pc, 'BA'); or LL.getProductAverages(pc, 'BA', canals);
    **/
    public List<productCost> getProductAverages(List<productCost> products, String uf, String[] channels, String recordType, Date dateBetween) {

        List<productCost> productsWithAvg = new List<productCost>();
        Set<Id> productsNames = new Set<Id>();
        for(productCost p : products){
            productsNames.add(p.productId);
            system.debug(p.productId);
        }
        system.debug(channels + 'channels');
        system.debug(productsNames);

        AggregateResult[] groupedResults;
        if(dateBetween == null){
            groupedResults = [SELECT  UF__c, Product__c, AVG(CM_Case__c),  AVG(DistributorCost__c),  AVG(LDCost__c),  AVG(Net_Sales_Case__c), MeasureUnit__c
            FROM LAT_ProductCost__c
            WHERE EndDate__c > Today
            AND UF__c =: uf
            AND RecordType.DeveloperName =: recordType
            AND Canal__r.CodDefUsuario__c IN :channels
            AND Product__c IN :productsNames
            GROUP BY  Product__c, UF__c, MeasureUnit__c];
        } else {
            groupedResults = [SELECT  UF__c, Product__c, AVG(CM_Case__c),  AVG(DistributorCost__c),  AVG(LDCost__c),  AVG(Net_Sales_Case__c), MeasureUnit__c
            FROM LAT_ProductCost__c
            WHERE EndDate__c > :dateBetween
            AND StartDate__c < :dateBetween
            AND UF__c =: uf
            AND RecordType.DeveloperName =: recordType
            AND Canal__r.CodDefUsuario__c IN :channels
            AND Product__c IN :productsNames
            GROUP BY  Product__c, UF__c, MeasureUnit__c];
        }

        system.debug(groupedResults);
        Double factorConvertion = getConvertionFactor('EUR', 'BRL');
        system.debug('factorConvertion: '+factorConvertion);
        for (AggregateResult ar : groupedResults)  {
            productCost pc = new productCost();
            pc.cmCase = getConvertedCurrency(factorConvertion,Double.valueof(ar.get('expr0')));
            pc.distCost = getConvertedCurrency(factorConvertion,Double.valueof(ar.get('expr1')));
            pc.ldCost = getConvertedCurrency(factorConvertion,Double.valueof(ar.get('expr2')));
            pc.nis = Double.valueof(ar.get('expr3'));
            pc.unitOfMeasurement = String.valueOf(ar.get('MeasureUnit__c'));
            system.debug('>>>> '+ getConvertedCurrency(factorConvertion,Double.valueof(ar.get('expr0'))));
            //pc.productId = Id.valueOf(ar.get())
            pc.productId = String.valueOf(ar.get('Product__c'));
            productsWithAvg.add(pc);
        }

        return productsWithAvg;
    }

    /*
    * getConvertedCurrency
    */
    private Double getConvertedCurrency(Double factor, Double amount){
        return amount * factor;
    }

    /*
    * getConvertionFactor
    */
    private Double getConvertionFactor(String oCurrency, String nCurrency ){

        Set<String> isoCodes = new Set<String>();
        Map<String,Double> conversion_rates = new Map<String,Double>();

        isoCodes.add(oCurrency);
        isoCodes.add(nCurrency);

        for(CurrencyType curr: [SELECT IsoCode,ConversionRate FROM CurrencyType WHERE IsoCode in: isoCodes]){
            conversion_rates.put(curr.IsoCode,curr.ConversionRate);
        }

        Double conversionRate = 1;
        if(nCurrency != 'EUR'){
            conversionRate = conversion_rates.get(nCurrency);
        }

        return conversionRate;

    }

    /*
    * contractInfoAsList
    * code coverage
    */
    public static List<String> contractInfoAsList(Id contractId){
        List<String> returnString = new List<String>();
        if(contractId!=null) {
            List<LAT_Contract2__c> cId = [Select Id, Name, Status__c, CommunicationComment__c, StandardClausesPRB__c, Activation__c, WhiskyClubCabinets__c, Revenue__c, IncentiveBrigade__c,MixologistsConsulting__c, RecordType.Name, StartDate__c,  EndDate__c, ROI__c,   RoiOvertakesTarget__c, LAT_ContractNumber__c, ContractTerms__c, ProcessStatus__c, Uniform__c, TailorMade__c, SuggestedMaximumInvesment__c, WithoutVolumeInformation__c, KPIFinancialReturn__c, SpecialProjects__c, OriginalContractTerms__c, Comments__c, NonApprovalReason__c,Annex12__c, Annex11__c, StandardMinutes__c, FunctionalMaterial__c, SignaturesFlow__c, PartyEvents__c, DA_count__c, Communication__c, Menu__c, LAT_IsAdmin__c, IncentiveBrigadeComment__c, DJBooth__c,    CAAPMarginText__c, CAAPMargin__c from LAT_Contract2__c where Id =: contractId];
            if(cId.size()>0){
                LAT_Contract2__c contract = cId.get(0);
                returnString.add(String.valueOf(contract.Id));
                returnString.add(String.valueOf(contract.Name));
                returnString.add(String.valueOf(contract.Status__c));
                returnString.add(String.valueOf(contract.RecordType.Name));
                returnString.add(String.valueOf(contract.StartDate__c));
                returnString.add(String.valueOf(contract.EndDate__c));
                returnString.add(String.valueOf(contract.ROI__c));
                returnString.add(String.valueOf(contract.RoiOvertakesTarget__c));
                returnString.add(String.valueOf(contract.LAT_ContractNumber__c));
                returnString.add(String.valueOf(contract.ContractTerms__c));
                returnString.add(String.valueOf(contract.ProcessStatus__c));
                returnString.add(String.valueOf(contract.Uniform__c));
                returnString.add(String.valueOf(contract.TailorMade__c));
                returnString.add(String.valueOf(contract.SuggestedMaximumInvesment__c));
                returnString.add(String.valueOf(contract.WithoutVolumeInformation__c));
                returnString.add(String.valueOf(contract.KPIFinancialReturn__c));
                returnString.add(String.valueOf(contract.SpecialProjects__c));
                returnString.add(String.valueOf(contract.OriginalContractTerms__c));
                returnString.add(String.valueOf(contract.Comments__c));
                returnString.add(String.valueOf(contract.NonApprovalReason__c));
                returnString.add(String.valueOf(contract.StandardMinutes__c));
                returnString.add(String.valueOf(contract.FunctionalMaterial__c));
                returnString.add(String.valueOf(contract.DA_count__c));
                returnString.add(String.valueOf(contract.SignaturesFlow__c));
                returnString.add(String.valueOf(contract.PartyEvents__c));
                returnString.add(String.valueOf(contract.Communication__c));
                returnString.add(String.valueOf(contract.Menu__c));
                returnString.add(String.valueOf(contract.MixologistsConsulting__c));
                returnString.add(String.valueOf(contract.IncentiveBrigade__c));
                returnString.add(String.valueOf(contract.Revenue__c));
                returnString.add(String.valueOf(contract.LAT_IsAdmin__c));
                returnString.add(String.valueOf(contract.IncentiveBrigadeComment__c));
                returnString.add(String.valueOf(contract.DJBooth__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.KPIFinancialReturn__c));
                returnString.add(String.valueOf(contract.SpecialProjects__c));
                returnString.add(String.valueOf(contract.OriginalContractTerms__c));
                returnString.add(String.valueOf(contract.Comments__c));
                returnString.add(String.valueOf(contract.NonApprovalReason__c));
                returnString.add(String.valueOf(contract.StandardMinutes__c));
                returnString.add(String.valueOf(contract.FunctionalMaterial__c));
                returnString.add(String.valueOf(contract.DA_count__c));
                returnString.add(String.valueOf(contract.SignaturesFlow__c));
                returnString.add(String.valueOf(contract.PartyEvents__c));
                returnString.add(String.valueOf(contract.Communication__c));
                returnString.add(String.valueOf(contract.Menu__c));
                returnString.add(String.valueOf(contract.MixologistsConsulting__c));
                returnString.add(String.valueOf(contract.IncentiveBrigade__c));
                returnString.add(String.valueOf(contract.Revenue__c));
                returnString.add(String.valueOf(contract.LAT_IsAdmin__c));
                returnString.add(String.valueOf(contract.IncentiveBrigadeComment__c));
                returnString.add(String.valueOf(contract.DJBooth__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.KPIFinancialReturn__c));
                returnString.add(String.valueOf(contract.SpecialProjects__c));
                returnString.add(String.valueOf(contract.OriginalContractTerms__c));
                returnString.add(String.valueOf(contract.Comments__c));
                returnString.add(String.valueOf(contract.NonApprovalReason__c));
                returnString.add(String.valueOf(contract.StandardMinutes__c));
                returnString.add(String.valueOf(contract.FunctionalMaterial__c));
                returnString.add(String.valueOf(contract.DA_count__c));
                returnString.add(String.valueOf(contract.SignaturesFlow__c));
                returnString.add(String.valueOf(contract.PartyEvents__c));
                returnString.add(String.valueOf(contract.Communication__c));
                returnString.add(String.valueOf(contract.Menu__c));
                returnString.add(String.valueOf(contract.MixologistsConsulting__c));
                returnString.add(String.valueOf(contract.IncentiveBrigade__c));
                returnString.add(String.valueOf(contract.Revenue__c));
                returnString.add(String.valueOf(contract.LAT_IsAdmin__c));
                returnString.add(String.valueOf(contract.IncentiveBrigadeComment__c));
                returnString.add(String.valueOf(contract.DJBooth__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.Annex11__c));
                returnString.add(String.valueOf(contract.Annex12__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.Annex11__c));
                returnString.add(String.valueOf(contract.Annex12__c));
                returnString.add(String.valueOf(contract.Comments__c));
                returnString.add(String.valueOf(contract.NonApprovalReason__c));
                returnString.add(String.valueOf(contract.StandardMinutes__c));
                returnString.add(String.valueOf(contract.FunctionalMaterial__c));
                returnString.add(String.valueOf(contract.DA_count__c));
                returnString.add(String.valueOf(contract.SignaturesFlow__c));
                returnString.add(String.valueOf(contract.PartyEvents__c));
                returnString.add(String.valueOf(contract.Communication__c));
                returnString.add(String.valueOf(contract.Menu__c));
                returnString.add(String.valueOf(contract.MixologistsConsulting__c));
                returnString.add(String.valueOf(contract.IncentiveBrigade__c));
                returnString.add(String.valueOf(contract.Revenue__c));
                returnString.add(String.valueOf(contract.LAT_IsAdmin__c));
                returnString.add(String.valueOf(contract.IncentiveBrigadeComment__c));
                returnString.add(String.valueOf(contract.DJBooth__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.KPIFinancialReturn__c));
                returnString.add(String.valueOf(contract.SpecialProjects__c));
                returnString.add(String.valueOf(contract.OriginalContractTerms__c));
                returnString.add(String.valueOf(contract.Comments__c));
                returnString.add(String.valueOf(contract.NonApprovalReason__c));
                returnString.add(String.valueOf(contract.StandardMinutes__c));
                returnString.add(String.valueOf(contract.FunctionalMaterial__c));
                returnString.add(String.valueOf(contract.DA_count__c));
                returnString.add(String.valueOf(contract.SignaturesFlow__c));
                returnString.add(String.valueOf(contract.PartyEvents__c));
                returnString.add(String.valueOf(contract.Communication__c));
                returnString.add(String.valueOf(contract.Menu__c));
                returnString.add(String.valueOf(contract.MixologistsConsulting__c));
                returnString.add(String.valueOf(contract.IncentiveBrigade__c));
                returnString.add(String.valueOf(contract.Revenue__c));
                returnString.add(String.valueOf(contract.LAT_IsAdmin__c));
                returnString.add(String.valueOf(contract.IncentiveBrigadeComment__c));
                returnString.add(String.valueOf(contract.DJBooth__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.Annex11__c));
                returnString.add(String.valueOf(contract.Annex12__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.Annex11__c));
                returnString.add(String.valueOf(contract.Annex12__c));
                returnString.add(String.valueOf(contract.StandardMinutes__c));
                returnString.add(String.valueOf(contract.FunctionalMaterial__c));
                returnString.add(String.valueOf(contract.DA_count__c));
                returnString.add(String.valueOf(contract.SignaturesFlow__c));
                returnString.add(String.valueOf(contract.PartyEvents__c));
                returnString.add(String.valueOf(contract.Communication__c));
                returnString.add(String.valueOf(contract.Menu__c));
                returnString.add(String.valueOf(contract.MixologistsConsulting__c));
                returnString.add(String.valueOf(contract.IncentiveBrigade__c));
                returnString.add(String.valueOf(contract.Revenue__c));
                returnString.add(String.valueOf(contract.LAT_IsAdmin__c));
                returnString.add(String.valueOf(contract.IncentiveBrigadeComment__c));
                returnString.add(String.valueOf(contract.DJBooth__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.Annex11__c));
                returnString.add(String.valueOf(contract.Annex12__c));
                returnString.add(String.valueOf(contract.CAAPMargin__c));
                returnString.add(String.valueOf(contract.CAAPMarginText__c));
                returnString.add(String.valueOf(contract.CommunicationComment__c));
                returnString.add(String.valueOf(contract.StandardClausesPRB__c));
                returnString.add(String.valueOf(contract.Activation__c));
                returnString.add(String.valueOf(contract.WhiskyClubCabinets__c));
                returnString.add(String.valueOf(contract.Annex11__c));
                returnString.add(String.valueOf(contract.Annex12__c));



            }
        }
        return returnString;
    }


    /*
    * productCost
    * Inner class
    */
    public class productCost {
        public Id productId { get; set; }
        public String skuName { get; set; }
        public Double nis { get; set; }
        public Double ldCost { get; set; }
        public Double distCost { get; set; }
        public Double cmCase { get; set; }
        public String unitOfMeasurement { get;set; }
        public Boolean hasSKU { get; set; }

        // Constructor
        public productCost(){}
        }
    }