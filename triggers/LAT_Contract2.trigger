/*
* LAT_Contract2
* Author: Martin Prado (martin@zimmic.com)
* Date: 07/28/2016
*/
trigger LAT_Contract2 on Lat_Contract2__c (before insert, before update, after update, after insert, before delete) {

    // New control to allow to update and create via mobile
    if (trigger.isBefore) {
        // We compare the actual profile name, with the admin list from the custom setting,
        // if the user has permission we save the var haveWebPermission
        final String[] adminProfiles = LAT_GeneralConfigDao.getValueAsStringArray('Admin', ' ');
        final Id profileId = userinfo.getProfileId();
        final List <Profile> profileName = [SELECT Name FROM Profile WHERE id = :profileId];
        Boolean haveWebPermission =  false;

        // Check if the profile is vendas
        if (profileName.size() > 0) {

            haveWebPermission = (profileName[0].Name != 'LAT_BR2_Vendas');
            System.debug('=================> haveWebPermission: ' + haveWebPermission);
        }

        // Check if the profile is admin
        if (adminProfiles != null && adminProfiles.size() > 0 && profileName.size() > 0) {
            for (String pName : adminProfiles) {
                if (pName == profileName[0].Name) {
                    haveWebPermission = true;
                }
            }
            System.debug('=================> haveWebPermission admin: ' + haveWebPermission);
        }

        // Check if the profile is admin
        if (!Utils.isPartOfMobileCRM(UserInfo.getUserId())) {
            haveWebPermission = true;
            System.debug('=================> haveWebPermission isPartOfMobileCRM: ' + haveWebPermission);
        }


        // If the user doen't has permission and the source is not mobile,
        // we must show an error
        //if(!haveWebPermission) {
        System.debug('=================> SOAP: ' + String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('services/soap'));
        Boolean isSoap = false; //String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('services/soap');
        String requestUrl = String.valueOf(URL.getCurrentRequestUrl());
        if(requestUrl.toLowerCase().contains('services/soap') || requestUrl.toLowerCase().contains('services/data') || requestUrl.toLowerCase().contains('services/apexrest')  ) {
            isSoap = true;
        }

        System.debug('=================> isSoap : ' + isSoap);


        //List <Lat_Contract2__c> contracts = (trigger.isDelete) ? trigger.old : trigger.new;
        List <Lat_Contract2__c> contracts = (trigger.isDelete) ? trigger.old : trigger.new;
        for (Lat_Contract2__c ct : contracts) {
            System.debug('=================> Source: ' + ct.source__c);
            System.debug('=================> Exlusivity__c: ' + ct.Exlusivity__c);

            if (!isSoap && !haveWebPermission ) {
                // HOT FIX, when we use the api service from anonther object(task) the contract is locked
                //if ((ct.Status__c == 'Ativo'  && ct.SignaturesFlow__c == 'Consultor-Contrato Ativado') ||  ct.ProcessStatus__c == 'Contrato Não Assinado Cliente' || ct.SignaturesFlow__c == 'Consultor-Assinatura Cliente'  ) {
                //    System.debug('Updated form Task');

                //}
                if (trigger.isDelete && ('Novo Contrato' != ct.Status__c && 'Reprovado' != ct.Status__c)) {
                    ct.addError('Você não tem acesso para Deletar Contratos via CRM Web. Favor utilizar o Compass.');
                }
                if (trigger.isUpdate ||trigger.isInsert ) {
                    ct.addError('Você não tem acesso para Criar/Editar Contratos via CRM Web. Favor utilizar o Compass.');
                }

            }
        }
    }


    if (trigger.isInsert) {
        Set<Id> userIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> toReviewIds = new Set<Id>();

        for ( Lat_Contract2__c ct : trigger.new ) {
            // Save the userID to query the information that we need to save in the contract to start the approval process
            userIds.add(ct.OwnerId);
            accountIds.add(ct.Account__c);
            toReviewIds.add(ct.Id);
        }


        if (trigger.isAfter) {
            List<LAT_Contract2__c> toUpdate = new List<LAT_Contract2__C>();
            for ( Lat_Contract2__c ct : [SELECT Name, LAT_ContractNumber__c, LAT_IsAdmin__c FROM LAT_Contract2__c WHERE ID IN :toReviewIds] ) {
                // define if the name is filled by an autonumber or set in by insertion (old record re-inserted for history tracking)
                if (!ct.LAT_IsAdmin__c) {
                    ct.Name = ct.LAT_ContractNumber__c;
                    toUpdate.add(ct);
                }

            }
            if (!toUpdate.isEmpty()){
                update toUpdate;
            }
        }

        if (trigger.isBefore) {

            Map<Id, User> idUserMap =  new Map<Id,User>([SELECT Gerente_de_area__c,Gerente_regional__c,ManagerId FROM User where Id in: userIds]);
            Map<Id, Account> idAccountMap =  new Map<Id,Account>([SELECT Client_code_AN8__c, Id FROM Account where Id in: accountIds]);
            List<LAT_ROISegments__c> roiSegments = [Select ROI__c, Segment__c from LAT_ROISegments__c];
            Map<String, Double> roiSegmentMap = new Map<String, Double>();

            //Load segments values
            for(LAT_ROISegments__c rS : roiSegments){
                roiSegmentMap.put(rS.Segment__c.toLowerCase(), rS.ROI__c );
            }

            for ( Lat_Contract2__c ct : trigger.new ) {
                if (!ct.LAT_IsAdmin__c) {
                    // Update the managers fields in contract based on the User object information
                    if(idUserMap.containsKey(ct.ownerId)){
                        User owner = idUserMap.get(ct.ownerId);
                        ct.GeneralManager__c = owner.Gerente_de_area__c;
                        ct.Manager__c = owner.ManagerId;
                        ct.RegionalManager__c = owner.Gerente_regional__c;
                    }
                    // Only we can create contracts if we have AN8
                    if(idAccountMap.containsKey(ct.Account__c)){
                        Account acc = idAccountMap.get(ct.Account__c);
                        if(String.isBlank(acc.Client_code_AN8__c)){
                            ct.Account__c.addError(Label.LAT_ContractAN8Error);
                        }
                    }

                    if(ct.ROISegment__c != null){
                        if(roiSegmentMap.containsKey(ct.ROISegment__c.toLowerCase())){
                            ct.ROI_Target__c = roiSegmentMap.get(ct.ROISegment__c.toLowerCase());
                        }
                    }
                }
            }
        }

    }

    if (trigger.isUpdate) {


        if (trigger.isAfter) {


            Set<Id> contractClosedDate = new Set<Id>();
            for ( Lat_Contract2__c ct : trigger.new ) {
                // If the contract is active we must save the Original Payment Date on payments
                if (ct.Status__c == 'Ativo' && trigger.oldMap.get(ct.id).Status__c != 'Ativo') {
                    LAT_ContractsCalculations.updateOriginalDate(ct.id);

                    if(ct.OriginalContractNumber__c != null) {
                        contractClosedDate.add(ct.OriginalContractNumber__c);
                    }

                }

                // Account has active contracts
                if(ct.Status__c == 'Ativo' && trigger.oldMap.get(ct.id).Status__c != 'Ativo' || ct.Status__c != 'Ativo' && trigger.oldMap.get(ct.id).Status__c == 'Ativo') {
                    LAT_CustomerContractsClassification.accountHasMoreThanOneActiveContract(trigger.newMap);
                }

                // Cancel contract process:
                if ((ct.Status__c == 'Em Distrato' && trigger.oldMap.get(ct.id).Status__c != 'Em Distrato') && (ct.ProcessStatus__c == 'Distrato em Aprovação' && trigger.oldMap.get(ct.id).ProcessStatus__c != 'Distrato em Aprovação')  ) {
                    // Run approval process
                    LAT_ContractDAHandlerInterface.runApprovalProcess(String.valueOf(ct.Id));
                }
            }
            //
            List<Lat_Contract2__c> contractsParent = [Select Id from Lat_Contract2__c where Id IN :contractClosedDate];
            if(contractsParent.size()>0){
                for(Lat_Contract2__c con :contractsParent){
                    con.Status__c = 'Encerrado';
                }
                update contractsParent;
            }

        }

        if(trigger.isBefore){

            // Function to control the value of the contract if is "condicao comercial"
            LAT_ContractErrorsController.letterOfAgreementValidation(trigger.new);
            

            LAT_ContractsCalculations.addAttachmentsAndTasks(trigger.new, trigger.oldMap);
            
            LAT_ContractsCalculations.chatterGroupNotification(trigger.new, trigger.oldMap);

            List<LAT_ROISegments__c> roiSegments = [Select ROI__c, Segment__c from LAT_ROISegments__c];
            Map<String, Double> roiSegmentMap = new Map<String, Double>();

            //Load segments values
            for(LAT_ROISegments__c rS : roiSegments){
                roiSegmentMap.put(rS.Segment__c.toLowerCase(), rS.ROI__c );
            }

            Set<Id> userIds = new Set<Id>();

            for ( Lat_Contract2__c ct : trigger.new ) {
                // When the contract is closed, we have to save the current date
                // If the contrac is "Em aprovacao" we save the roi segment again
                if(ct.ROISegment__c != null){
                    if(roiSegmentMap.containsKey(ct.ROISegment__c.toLowerCase())){
                        ct.ROI_Target__c = roiSegmentMap.get(ct.ROISegment__c.toLowerCase());
                    }
                }

                if (ct.Status__c == 'Encerrado' && trigger.oldMap.get(ct.id).Status__c != 'Encerrado') {
                    ct.ClosedDate__c = Date.today();
                }
                if (ct.Status__c == 'Em Aprovação' && trigger.oldMap.get(ct.id).Status__c != 'Em Aprovação') {
                                    
                    userIds.add(ct.OwnerId);
                // if the contract is cancelled send the Docusign pdf to sign
                } else if (ct.Status__c == 'Distrato Aprovado' && trigger.oldMap.get(ct.id).Status__c != 'Distrato Aprovado'){
                    LAT_Docusign_Utils.cancelDocusignFuture(ct.Id);
                }



                // Uses the signature flow only according to the flow configuration
                LAT_Docusign_Config__c config = LAT_Docusign_Utils.getDocusignConfig();


                if (!config.Enable_Docusign_Contracts__c){
                  // Signature flow status must udpdate the status do proceso
                  if (ct.SignaturesFlow__c != trigger.oldMap.get(ct.id).SignaturesFlow__c ) {
                      LAT_ContractsCalculations.updateProcessStatus(trigger.new);
                  }
                }


                // Extend Contract
                if (ct.Status__c == 'Ativo' && ct.ProcessStatus__c == 'Contrato Prorrogado' && trigger.oldMap.get(ct.id).ProcessStatus__c != 'Contrato Prorrogado') {
                    // If mobile change the status to Prorrogado, we must set some values and don't recaculate values or Roi
                    ct.OriginalEndDate__c = ct.EndDate__c;
                    ct.OriginalContractTerms__c = ct.ContractTerms__c;
                    ct.EndDate__c = ct.EndDate__c.addMonths(12);

                }
            }

            Map<Id, User> idUserMap =  new Map<Id,User>([SELECT Gerente_de_area__c,Gerente_regional__c,ManagerId FROM User where Id in: userIds]);
            for ( Lat_Contract2__c ct : trigger.new ) {
                if (ct.Status__c == 'Em Aprovação' && trigger.oldMap.get(ct.id).Status__c != 'Em Aprovação') {
                    if(idUserMap.containsKey(ct.ownerId)){
                        User owner = idUserMap.get(ct.ownerId);
                        ct.GeneralManager__c = owner.Gerente_de_area__c;
                        ct.Manager__c = owner.ManagerId;
                        ct.RegionalManager__c = owner.Gerente_regional__c;
                    }

                    // Run approval process
                    LAT_ContractDAHandlerInterface.runApprovalProcess(String.valueOf(ct.Id));
                }

            }
        }
    }

}