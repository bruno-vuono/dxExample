global class ESN_MB_Rest_DAM_Batch {

	private List<String> listDamIdToSync;
    private Integer currentRange;
    private Integer maxRange;
    private String brandId;
    private Datetime startDate;
    private Datetime endDate;
    private Integer currentRangeCount;
    private Integer maxLimitRange = 300; // Don't leverage otherwise Exception 'Exceeded maximum time allocated for callout (120000ms)

    private List<String> session;

    //private Set<String> brandIdEnabledInitSet;
	global ESN_MB_Rest_DAM_Batch(ESN_MB_Rest_DAM_BatchParams params) {
        if(params != null){
            this.listDamIdToSync = params.listDamIdToSync;
            this.currentRange = params.currentRange;
            this.maxRange = params.maxRange;
            this.brandId = params.brandId;
            this.startDate = params.startDate;
            this.endDate = params.endDate;
            this.session = params.session;
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug(Logginglevel.WARN, 'Start ESN_MB_Rest_DAM_Batch: currentRange=' + currentRange + ', maxRange=' + maxRange
            + ', startDate(-2hours)=' + startDate + ', endDate(-2hours)=' + endDate + ', brandId=' + brandId);
        System.debug(Logginglevel.WARN, 'Session before postAuth in start : ' + session);
        if(session == null) {
            System.debug(Logginglevel.WARN, 'La session est nulle, on appelle postAuth');
        	session = ESN_MB_REST_API_Callout.postAuth();
        }else{
            System.debug(Logginglevel.WARN, 'La session n\'est pas nulle, on n\'appelle pas postAuth');
        }
		System.debug(Logginglevel.WARN, 'Session after postAuth in start : ' + session);
        // Init when new batch
        if (maxRange == null || maxRange == 0) {
            // Get last import date
            Datetime lastImportDate;
            //If we are working on a list of brands, then we pick the first value of the list
            if(String.isEmpty(brandId) && listDamIdToSync != null && listDamIdToSync.size()>0){
                brandId = listDamIdToSync[0];
            }
            lastImportDate = getLastImportDate(brandId); // start from the last import date for the brand
            
            if (lastImportDate != null) {
                startDate = lastImportDate.addHours(-2); // Take 2 hours before: the last import date is not the date at the beginning of the previous batch
                endDate = Datetime.now();
            }
            
            maxRange = ESN_MB_REST_API_Callout.getAssetsCount(brandId, startDate, endDate, session);
            
        }

        if (currentRange == null) {
            currentRange = 0;
        }

        if (maxRange == 0) {
            // can't return null otherwise execute() won't be launched
            return Database.getQueryLocator('select ID from ESN_MB_Asset__c limit 0'); // go directly to finish() method
        } else {
            return Database.getQueryLocator('select ID from ESN_MB_Asset__c limit 1');
        }
    }

    global void execute(SchedulableContext sc) { execute();}

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        execute();
    }

    // method used when the batch is called manually (not by scheduling)
    global String execute() {
        System.debug(Logginglevel.WARN, 'Execute ESN_MB_Rest_DAM_Batch: currentRange=' + currentRange + ', maxRange=' + maxRange
            + ', startDate(GMT)=' + startDate + ', endDate(GMT)=' + endDate + ', brandId=' + brandId);

		// sfdcLimitRange variable
        Integer sfdcLimitRange = 100;
        Integer currentEndRange = (sfdcLimitRange > maxRange ? maxRange : currentRange + sfdcLimitRange);
        currentRangeCount = 0;
        List<ESN_MB_Asset__c> assetToUpsertList = new List<ESN_MB_Asset__c>();
        List<ESN_MB_Asset__c> assetToDeleteList = new List<ESN_MB_Asset__c>();

        // Loop until maxLimitRange or maxRange reached
        System.debug(Logginglevel.WARN, 'While loop incoming !!');
        while (currentRangeCount < maxLimitRange && currentRange <= maxRange && maxRange > 0) { // || Limits.getCallouts() < Limits.getLimitCallouts()) {
            List<List<ESN_MB_Asset__c>> assetResult = ESN_MB_REST_API_Callout.getAssets(currentRange, currentEndRange, brandId, startDate, endDate, session);
            if(assetResult != null && assetResult.size()>1){
                assetToUpsertList.addAll(assetResult.get(0));
                assetToDeleteList.addAll(assetResult.get(1));
            }
            // increment range
            currentRange += sfdcLimitRange;
            currentEndRange = currentRange + sfdcLimitRange;
            currentRangeCount += sfdcLimitRange;
        }

        String message = '';
        // update assets for enabled brands
        String listDamIdStr = '';
        for(ESN_MB_Asset__c assetTmp : assetToUpsertList) {
            listDamIdStr += assetTmp.ESN_MB_DAMId__c + ' - ';
        }
        System.debug(logginglevel.WARN, 'DAM Ids List : ' + listDamIdStr);
        if (assetToUpsertList.size() > 0) {
            Schema.SObjectField f = ESN_MB_Asset__c.ESN_MB_DAMId__c;
            List <Database.UpsertResult> srList = Database.upsert(assetToUpsertList, f, false);
            for(Integer i=0 ; i < srList.size() ; i++) {
                Database.UpsertResult srTmp = srList[i];
            	System.debug(Logginglevel.WARN, 'Upsert Result : ' + srTmp);
                if(!srTmp.isCreated()){
                    System.debug(Logginglevel.WARN, 'Updated Asset : ' + assetToUpsertList[i]);
                }
            }
            System.debug(Logginglevel.WARN, 'Upsert result size : ' + srList.size());
        }
        message += 'Assets created/updated: ' + assetToUpsertList.size();

        // delete old assets (not MyBrands, expired, not Published...) for enabled brands
        List<String> damIdAssetForDeleteList = new List<String>();
        for (ESN_MB_Asset__c deleteAsset : assetToDeleteList) {
            damIdAssetForDeleteList.add(deleteAsset.ESN_MB_DAMId__c);
        }
        List<ESN_MB_Asset__c> assetToDeleteWithId = [SELECT Id FROM ESN_MB_Asset__c WHERE ESN_MB_DAMId__c IN :damIdAssetForDeleteList];
        if (assetToDeleteWithId.size() > 0) {
            Database.delete(assetToDeleteWithId);
        }
        message += '. Old Assets deleted: ' + assetToDeleteWithId.size();
        if (startDate != null) {
            message += ' since ' + startDate + ' (GMT)';
        }
        if(maxRange>currentRange){
            message += '. Batch is still running, please wait for completion. (To do : ' + maxRange + ', current : ' + currentRange + ')';
        }
        System.debug(Logginglevel.WARN, message);
		System.debug(Logginglevel.WARN, 'Session execute : ' + session);
        return message;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(Logginglevel.WARN, 'Finish ESN_MB_Rest_DAM_Batch: end range=' + currentRange + ', maxRange=' + maxRange
                + ', startDate(GMT)=' + startDate + ', endDate(GMT)=' + endDate + ', brandId=' + brandId);
		System.debug(Logginglevel.WARN, 'Session execute : ' + session);
        
        // Schedule a new batch if necessary in 1 minut
        // batchName ONLY used for scheduled batch - not used here
        String batchName = 'MyBrands DAM ' + brandId;
        String sCronID = null;
        if (currentRange <= maxRange && maxRange > 0) { // Continue the batch for the next range
            sCronID = scheduleApexJob(currentRange, maxRange);
        } else if (String.isNotBlank(brandId)) {
			//The batch is finished for the current brand
			//So we notify about the end of the batch
			//And if we need ti sync more brands, then we run a new batch with the list minus the current brand
			
            updateLastModifiedDate(brandId);

            // send an email to the user who triggered the batch
            String emailUser = UserInfo.getUserEmail();
            if (String.isNotBlank(emailUser)) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // email address of the salesforce email service
                mail.setReplyTo(System.Label.ESN_MB_DamBatchEmailReplyTo);
                mail.setToAddresses(new String[] {emailUser});
                mail.setSubject(System.Label.ESN_MB_DamBatchEmailSubject);
                mail.setPlainTextBody(System.Label.ESN_MB_DamBatchEmailBody + '\n' + brandId);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            
            if(listDamIdToSync != null){
                listDamIdToSync.remove(0);
                if(listDamIdToSync.size()>0){
                    ESN_MB_Rest_DAM_BatchParams params = new ESN_MB_Rest_DAM_BatchParams(listDamIdToSync);
                    ESN_MB_Rest_DAM_Batch damAssetBatch = new ESN_MB_Rest_DAM_Batch(params);
                    damAssetBatch.scheduleApexJob(0, 0);
                }
            }
        }

    }

    global void updateLastModifiedDate(String brandDamId) {
        // update the lastModified date field in NodePage
        ESN_MB_NodePage__c brand = [SELECT Id, ESN_MB_Brand_DAM_Id__c, ESN_MB_Brand_LastImportAssetsDate__c 
                                    from ESN_MB_NodePage__c 
                                    where RecordType.DeveloperName='ESN_MB_Brand' and ESN_MB_Brand_DAM_Id__c = :brandDamId LIMIT 1];
        if (brand != null) {
            System.debug(Logginglevel.WARN, 'updateLastModifiedDate: brandDamId=' + brandDamId);
            brand.ESN_MB_Brand_LastImportAssetsDate__c = Datetime.now();
            update brand;
        }
    }


    global Datetime getLastImportDate(String brandDamId) {
        Datetime result = null;

        ESN_MB_NodePage__c brand = [SELECT ESN_MB_Brand_LastImportAssetsDate__c 
                                    from ESN_MB_NodePage__c 
                                    where RecordType.DeveloperName='ESN_MB_Brand' and ESN_MB_Brand_DAM_Id__c = :brandDamId 
                                    LIMIT 1];
        if (brand != null) {
            result = brand.ESN_MB_Brand_LastImportAssetsDate__c;
        }
        return result;
    }

    global Datetime getLastImportDate() {
        Datetime lastDate = null;

        List<ESN_MB_NodePage__c> brandEnabledList = ESN_MB_Rest_Api_Callout.getBrandEnabledInitList();
        for (ESN_MB_NodePage__c brand : brandEnabledList) {
            if (lastDate == null) {
                lastDate = brand.ESN_MB_Brand_LastImportAssetsDate__c;
            }
            if (brand.ESN_MB_Brand_LastImportAssetsDate__c != null && lastDate > brand.ESN_MB_Brand_LastImportAssetsDate__c) {
                lastDate = brand.ESN_MB_Brand_LastImportAssetsDate__c;                
            }
        }

        return lastDate;
    }
    
    global String scheduleApexJob(Integer startRange, Integer endRange) {
        String result = null;
        // batchName ONLY used for scheduled batch
        String batchName = 'MyBrands DAM ' + brandId;
        ESN_MB_Rest_DAM_BatchParams params = new ESN_MB_Rest_DAM_BatchParams(startRange, endRange, brandId, startDate, endDate, session, listDamIdToSync);
        ESN_MB_Rest_DAM_BatchImpl damBatch = new ESN_MB_Rest_DAM_BatchImpl(params);

        //check if there are less than 5 active batch jobs && the batch is not already in process or preparing
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5 ) {
            result = Database.executeBatch(damBatch); 
            System.debug(Logginglevel.WARN, 'Batch scheduled: sCronID =' + result
                            + ', brandId=' + brandId + ', range=' + currentRange + '-' + maxRange + ', startDate=' + startDate + ', endDate=' + endDate);

        } else {
            // schedule this same schedulable class again later
            Datetime dt = Datetime.now().addMinutes(1);// + (0.024305); // i.e. 30 mins
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy');

            result = System.Schedule(batchName, timeForScheduler, damBatch);

            System.debug(Logginglevel.WARN, 'Max active batch jobs. New schedule: sCronID =' + result
                            + ', brandId=' + brandId + ', range=' + startRange + '-' + endRange + ', startDate=' + startDate + ', endDate=' + endDate);
        }

        return result;
    }
}