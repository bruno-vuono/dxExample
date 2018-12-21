public with sharing class LAT_BR_TR_Opportunity {
    
    /*****************************************************************************************
    * Nombre del metodo: createFeedOnStatusUpdate
    * Descripcion: Creates a feed indicating that the status of the orther has change
    * Desarrollador: Mariano Boezio
    * Fecha: 26/03/2015
    * Modo: after update
    *****************************************************************************************/
    /********************************************************************************
    *                       
    * MIGRACION LICENCIAS 
    * AUTHOR: ZIMMIC                     DATE: 03/11/2016
    *
    ********************************************************************************/
    public static void createFeedOnStatusUpdate(List<Opportunity> triggerNew, List<Opportunity> triggerOld){
        LAT_CS007_PushNotifications__c PushNotificationSetting = new LAT_CS007_PushNotifications__c();

        // See if the notifications are enabled
        List<LAT_CS007_PushNotifications__c> PNList = [SELECT Id, LAT_isEnabled__c FROM LAT_CS007_PushNotifications__c LIMIT 1];
        if (!PNList.isEmpty()) {
            PushNotificationSetting = PNList.get(0);
        }
        
        if (PushNotificationSetting.LAT_isEnabled__c) {
            Map<id, Opportunity> oldMap = new Map<id, Opportunity>();
            Map<id, List<OpportunityLineItem>> oliMap = new Map<id, List<OpportunityLineItem>>();
            List<ConnectApi.BatchInput> feedList = new List<ConnectApi.BatchInput>();

            // Get stages that will send notification
            Set<String> stages = new Set<String>();
            stages.addAll(LAT_GeneralConfigDao.getValueAsStringArray('OPP_STAGES_TO_PUSH',','));

            // Get stages that will to show line items in feed post
            Set<String> lineItemStages = new Set<String>();
            lineItemStages.addAll(LAT_GeneralConfigDao.getValueAsStringArray('OPP_PUSH_STAGE_TO_SHOW_ITEMS',','));
            
            // Construct Map with list of line items to be displayed if the oppty stage
            // is in the previously created set
            for (OpportunityLineItem oli: [SELECT sku__c,LAT_MX_RealDeliveryDate__c, PricebookEntry.Product2.Name, Descricao_do_status__c, OpportunityId 
                                                FROM OpportunityLineItem 
                                                WHERE OpportunityId IN: triggerNew]) {
                if (oliMap.get(oli.OpportunityId) == null) {
                    oliMap.put(oli.OpportunityId, new List<OpportunityLineItem>{oli});
                } else {
                    oliMap.get(oli.OpportunityId).add(oli);
                }
            }

            // Construct map with old information of the opportunity
            for (Opportunity opp: triggerOld) {
                oldMap.put(opp.id, opp);
            }

            // For each of the updated opportunities, check that the stageName is changed.
            // if it is then a feed is created to this opportunity if it isn't nothing is done.
            for (Opportunity opp: triggerNew) {

                if (opp.StageName != oldMap.get(opp.id).StageName 
                    && opp.Integracao__c && stages.contains(opp.StageName)) {
                    //ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;

                    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
                    //input.feedElementType = ConnectApi.​FeedElement​Type.FeedItem;
                    input.subjectId = opp.id;

                    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
                    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

                    // Create mention to Opportunity Owner
                    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
                    mentionSegment.id = opp.OwnerId;
                    messageInput.messageSegments.add(mentionSegment);

                    // Create Status change text
                    ConnectApi.TextSegmentInput textSegment;
                    textSegment = new ConnectApi.TextSegmentInput();
                    textSegment.text = '\n\n' + String.format(Label.LAT_OPP_PushMessage, new List<String>{opp.Name, LAT_BR_TR_Opportunity.getTranslatedStageName(oldMap.get(opp.id).StageName), LAT_BR_TR_Opportunity.getTranslatedStageName(opp.StageName)}) + '\n';
                    Integer textlength = textSegment.text.length();
                    messageInput.messageSegments.add(textSegment);

                    // Check if the the line items should be shown for this opportunity
                    if (lineItemStages.contains(opp.StageName) &&
                        oliMap.get(opp.id) != null) {
                        
                        ConnectApi.TextSegmentInput linetextSegment = new ConnectApi.TextSegmentInput();
                        linetextSegment.text = '';

                        // For each line item show SKU | Product Name | Status Description
                        for (OpportunityLineItem oli: oliMap.get(opp.id)) {
                            String lineSegment = '\n' + oli.sku__c + ' | ' + oli.PricebookEntry.Product2.Name + ' | ' + (oli.Descricao_do_status__c != null ? oli.Descricao_do_status__c : '') + (oli.LAT_MX_RealDeliveryDate__c != null ?  ' | ' + oli.LAT_MX_RealDeliveryDate__c.format() : '');
                            if ((linetextSegment.text.length() + textlength + lineSegment.length()) < 5000) {
                                linetextSegment.text += lineSegment;
                            } else {
                                break;
                            }
                        }
                        messageInput.messageSegments.add(linetextSegment);
                    }
                    input.body = messageInput;
                    
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                    feedList.add(batchInput);
                }
            }

            // Post FeedElement
            if (feedList != null && !feedList.isEmpty() && !Test.isRunningTest()) {
                ConnectApi.ChatterFeeds.postFeedElementBatch(null, feedList); 
            }
        }
    }

    //MIGRATED 03/11/2016 
    public static void createFeedOnStatusUpdate(List<LAT_Opportunity__c> triggerNew, List<LAT_Opportunity__c> triggerOld){
        LAT_CS007_PushNotifications__c PushNotificationSetting = new LAT_CS007_PushNotifications__c();

        // See if the notifications are enabled
        List<LAT_CS007_PushNotifications__c> PNList = [SELECT Id, LAT_isEnabled__c FROM LAT_CS007_PushNotifications__c LIMIT 1];
        if (!PNList.isEmpty()) {
            PushNotificationSetting = PNList.get(0);
        }
        
        if (PushNotificationSetting.LAT_isEnabled__c) {
            Map<id, LAT_Opportunity__c> oldMap = new Map<id, LAT_Opportunity__c>();
            Map<id, List<LAT_OpportunityLineItem__c>> oliMap = new Map<id, List<LAT_OpportunityLineItem__c>>();
            List<ConnectApi.BatchInput> feedList = new List<ConnectApi.BatchInput>();

            // Get stages that will send notification
            Set<String> stages = new Set<String>();
            stages.addAll(LAT_GeneralConfigDao.getValueAsStringArray('OPP_STAGES_TO_PUSH',','));

            // Get stages that will to show line items in feed post
            Set<String> lineItemStages = new Set<String>();
            lineItemStages.addAll(LAT_GeneralConfigDao.getValueAsStringArray('OPP_PUSH_STAGE_TO_SHOW_ITEMS',','));
            
            // Construct Map with list of line items to be displayed if the oppty stage
            // is in the previously created set
            for (LAT_OpportunityLineItem__c oli: [SELECT LAT_Sku__c,LAT_MX_RealDeliveryDate__c, LAT_Product__r.Name, LAT_StatusDescription__c, LAT_Opportunity__c 
                                                FROM LAT_OpportunityLineItem__c 
                                                WHERE LAT_Opportunity__c IN: triggerNew]) {
                if (oliMap.get(oli.LAT_Opportunity__c) == null) {
                    oliMap.put(oli.LAT_Opportunity__c, new List<LAT_OpportunityLineItem__c>{oli});
                } else {
                    oliMap.get(oli.LAT_Opportunity__c).add(oli);
                }
            }

            // Construct map with old information of the opportunity
            for (LAT_Opportunity__c opp: triggerOld) {
                oldMap.put(opp.id, opp);
            }

            // For each of the updated opportunities, check that the stageName is changed.
            // if it is then a feed is created to this opportunity if it isn't nothing is done.
            for (LAT_Opportunity__c opp: triggerNew) {

                if (opp.LAT_StageName__c != oldMap.get(opp.id).LAT_StageName__c 
                    && opp.LAT_Integration__c && stages.contains(opp.LAT_StageName__c)) {
                    //ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;

                    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
                    //input.feedElementType = ConnectApi.​FeedElement​Type.FeedItem;
                    input.subjectId = opp.id;

                    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
                    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

                    // Create mention to Opportunity Owner
                    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
                    mentionSegment.id = opp.OwnerId;
                    messageInput.messageSegments.add(mentionSegment);

                    // Create Status change text
                    ConnectApi.TextSegmentInput textSegment;
                    textSegment = new ConnectApi.TextSegmentInput();
                    textSegment.text = '\n\n' + String.format(Label.LAT_OPP_PushMessage, new List<String>{opp.Name, LAT_BR_TR_Opportunity.getTranslatedStageName(oldMap.get(opp.id).LAT_StageName__c), LAT_BR_TR_Opportunity.getTranslatedStageName(opp.LAT_StageName__c)}) + '\n';
                    Integer textlength = textSegment.text.length();
                    messageInput.messageSegments.add(textSegment);

                    // Check if the the line items should be shown for this opportunity
                    if (lineItemStages.contains(opp.LAT_StageName__c) &&
                        oliMap.get(opp.id) != null) {
                        
                        ConnectApi.TextSegmentInput linetextSegment = new ConnectApi.TextSegmentInput();
                        linetextSegment.text = '';

                        // For each line item show SKU | Product Name | Status Description
                        for (LAT_OpportunityLineItem__c oli: oliMap.get(opp.id)) {
                            String lineSegment = '\n' + oli.LAT_Sku__c + ' | ' + oli.LAT_Product__r.Name + ' | ' + (oli.LAT_StatusDescription__c != null ? oli.LAT_StatusDescription__c : '') + (oli.LAT_MX_RealDeliveryDate__c != null ?  ' | ' + oli.LAT_MX_RealDeliveryDate__c.format() : '');
                            if ((linetextSegment.text.length() + textlength + lineSegment.length()) < 5000) {
                                linetextSegment.text += lineSegment;
                            } else {
                                break;
                            }
                        }
                        messageInput.messageSegments.add(linetextSegment);
                    }
                    input.body = messageInput;
                    
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                    feedList.add(batchInput);
                }
            }

            // Post FeedElement
            if (feedList != null && !feedList.isEmpty() && !Test.isRunningTest()) {
                ConnectApi.ChatterFeeds.postFeedElementBatch(null, feedList); 
            }
        }
    }

    public static String getTranslatedStageName(String stageName) {
        if (stageName.contains('Totally billed')) {
            return Label.LAT_BR_TR_TotallyBilled;
        } else if (stageName.contains('Partially billed')) {
            return Label.LAT_BR_TR_PartiallyBilled;
        } else if (stageName.contains('Partially Delivered')) {
            return Label.LAT_BR_TR_PartiallyDelivered;
        } else if (stageName.contains('Totally Delivered')) {
            return Label.LAT_BR_TR_TotallyDelivered;
        } else {
            return stageName;
        }
    }

    public static void validateAndIntegrate(List<Opportunity> triggerNew){
        /*String msg = '';
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for (Opportunity opp: triggerNew) {
            if (opp.StageName == 'Mobile Order') {
                msg = LAT_Cota.validateCotaAndIntegrate(opp.id);
                if (msg != '') {
                    opp.LAT_errorMessage__c = msg;
                    oppToUpdate.add(opp);
                }
            }
        }

        if (!oppToUpdate.isEmpty()) {
            update oppToUpdate;
        }*/

        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for (Opportunity opp: triggerNew) {
            if (opp.StageName == 'Mobile Order') {
                if  (LAT_Cota.isProcessing == null) {
                    LAT_Cota.isProcessing = false;
                }
                if (!LAT_Cota.isProcessing) {
                    LAT_Cota.validateCotaAndIntegrateFuture(opp.id);
                    LAT_Cota.isProcessing = true;
                }
       
            }
        }

    }

    //MIGRATED 03/11/2016 
    public static void validateAndIntegrate(List<LAT_Opportunity__c> triggerNew){
        /*String msg = '';
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for (Opportunity opp: triggerNew) {
            if (opp.StageName == 'Mobile Order') {
                msg = LAT_Cota.validateCotaAndIntegrate(opp.id);
                if (msg != '') {
                    opp.LAT_errorMessage__c = msg;
                    oppToUpdate.add(opp);
                }
            }
        }

        if (!oppToUpdate.isEmpty()) {
            update oppToUpdate;
        }*/

        List<LAT_Opportunity__c> oppToUpdate = new List<LAT_Opportunity__c>();
        for (LAT_Opportunity__c opp: triggerNew) {
            if (opp.LAT_StageName__c == 'Mobile Order') {
                if  (LAT_Cota.isProcessing == null) {
                    LAT_Cota.isProcessing = false;
                }
                if (!LAT_Cota.isProcessing) {
                    LAT_Cota.validateCotaAndIntegrateFuture(opp.id);
                    LAT_Cota.isProcessing = true;
                }
       
            }
        }

    }


    public static void cancelOpportunity(List<Opportunity> triggerNew, Map<id, Opportunity> mapOld) {
        List<Opportunity> toCancel = new List<Opportunity>();

        for (Opportunity opp: triggerNew) {
            if (opp.CD_Action__c == 'C' && mapOld.get(opp.id).CD_Action__c != 'C') {
                toCancel.add(opp);
            }
        }
 
        if (!toCancel.isEmpty()) {

            List<OpportunityLineItem> oportunidadeLista = [ SELECT id, CD_Action__c, Remover__c 
                                                               FROM OpportunityLineItem 
                                                               WHERE OpportunityId IN: toCancel];
       
            for(OpportunityLineItem item : oportunidadeLista){
                item.CD_Action__c = 'C';
                item.Remover__c = true;
            }
                    
            update oportunidadeLista;

            String oppId = toCancel.get(0).id;
            SalesOrderHandlerInterface.SalesOrderInterfaceFuture(oppId);
        }
    }

    //MIGRATED 03/11/2016 
    public static void cancelOpportunity(List<LAT_Opportunity__c> triggerNew, Map<id, LAT_Opportunity__c> mapOld) {
        List<LAT_Opportunity__c> toCancel = new List<LAT_Opportunity__c>();

        for (LAT_Opportunity__c opp: triggerNew) {
            system.debug('aaaa ' + opp.LAT_CDAction__c + ' ' + mapOld.get(opp.id).LAT_CDAction__c);
            if (opp.LAT_CDAction__c == 'C' && mapOld.get(opp.id).LAT_CDAction__c != 'C') {
                toCancel.add(opp);
            }
        }
 
        if (!toCancel.isEmpty()) {

            List<LAT_OpportunityLineItem__c> oportunidadeLista = [ SELECT id, LAT_CDAction__c, LAT_Remover__c 
                                                               FROM LAT_OpportunityLineItem__c 
                                                               WHERE LAT_Opportunity__c IN: toCancel];
       
            for(LAT_OpportunityLineItem__c item : oportunidadeLista){
                item.LAT_CDAction__c = 'C';
                item.LAT_Remover__c = true;
            }
                    
            update oportunidadeLista;

            String oppId = toCancel.get(0).id;
            SalesOrderHandlerInterface.LAT_SalesOrderInterfaceFuture(oppId);
        }
    }

   
}