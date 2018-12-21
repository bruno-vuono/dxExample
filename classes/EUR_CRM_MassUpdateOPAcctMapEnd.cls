global class EUR_CRM_MassUpdateOPAcctMapEnd implements Database.Batchable<sObject>{

    global final String query;
    global final Set<String> validRecordTypes = EUR_CRM_RecordTypeHelper.MassUpdateOPAcctMap_validRecordTypes;
    global final String OP_ACTION_STATUS_PRE_SELL = 'Pre-sell';
    global final String OP_ACTION_STATUS_EXECUTION = 'Execution';
    
    // TODO: Refactor in RecordTypeHelper
    global final String OFF_FOLLOW_UP = 'EUR_RU_OFF_Follow_Up';
    // TODO: Refactor in RecordTypeHelper
    global final String RU_OFF_INSTALL_POSM = 'EUR_RU_OFF_Install_POSM';
    
    
    global EUR_CRM_MassUpdateOPAcctMapEnd() {
        // TODO: Refactor query using RecordTypeHelper
        String q =  'SELECT Id, EUR_CRM_Is_Active__c, EUR_CRM_Evaluation_Required__c, EUR_CRM_Account__c, EUR_CRM_ObjPromo__r.EUR_CRM_Active_End_Date__c, EUR_CRM_ObjPromo__r.EUR_CRM_Evaluation_Period_End_Date__c, ' + 
                    ' EUR_CRM_ObjPromo__c, EUR_CRM_ObjPromo__r.EUR_CRM_Status__c, RecordTypeId' +
                    ' FROM EUR_CRM_ObjPromo_Account_Mapping__c' +
                    ' WHERE Recordtype.DeveloperName =: validRecordTypes' +
                    ' AND EUR_CRM_Is_Active__c = TRUE';
        query = q;        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        System.debug('$$SCOPE2: '+scope);
        List<EUR_CRM_ObjPromo_Account_Mapping__c> opAcctMapList = (List<EUR_CRM_ObjPromo_Account_Mapping__c>)scope;
        Map<Id, EUR_CRM_ObjPromo_Account_Mapping__c> opAccountMappingToUpdate = new Map<Id, EUR_CRM_ObjPromo_Account_Mapping__c>();
        Map<String, EUR_CRM_ObjPromo_Account_Mapping__c> opAccountMappingMap = new Map<String, EUR_CRM_ObjPromo_Account_Mapping__c>();
        List<Recordtype> visitActionTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Visit_Action__c');        
        List<EUR_CRM_Visit_Action__c> visitActionFollowUps = new List<EUR_CRM_Visit_Action__c>();
        Map<String, Id> visitActionRTDevNameToId = new Map<String, Id>();
        Set<Id> opIds = new Set<Id>();
        Map<Id, EUR_CRM_ObjPromo__c> objPromMap;
        Map<Id, EUR_CRM_ObjPromo__c> objPromMapToUpdate = new Map<Id, EUR_CRM_ObjPromo__c>();
        
        // TODO: Refactor in RecordTypeHelper
        List<String> followUpRecordTypes = new List<String>{OFF_FOLLOW_UP};
        List<EUR_CRM_ObjPromo_Action__c> followUpActions = [SELECT Id, EUR_CRM_Visit_Action_RecordType_DevName__c
                                                            FROM EUR_CRM_ObjPromo_Action__c 
                                                            WHERE EUR_CRM_Visit_Action_RecordType_DevName__c IN :followUpRecordTypes]; 
        
        // TODO: Refactor using RecordTypeHelper
        EUR_CRM_ObjPromo_Action__c followUpActionOFF;
        for(EUR_CRM_ObjPromo_Action__c followUpAction: followUpActions) {
            if(followUpAction.EUR_CRM_Visit_Action_RecordType_DevName__c == OFF_FOLLOW_UP) {
                followUpActionOFF = followUpAction;
            }
        }

        for(RecordType rt: visitActionTypes) {
            visitActionRTDevNameToId.put(rt.developername, rt.Id);
        }
        
        System.debug('$$SCOPE: '+opAcctMapList);


        for(EUR_CRM_ObjPromo_Account_Mapping__c opMap : opAcctMapList){
            opIds.add(opMap.EUR_CRM_ObjPromo__c);
            opAccountMappingMap.put(createKey((String)opMap.EUR_CRM_ObjPromo__c, (String)opMap.EUR_CRM_Account__c), opMap);
            if(opMap.EUR_CRM_ObjPromo__r.EUR_CRM_Active_End_Date__c < Date.Today()) {
                opMap.EUR_CRM_Is_Active__c = FALSE;
                opAccountMappingToUpdate.put(opMap.Id, opMap);
                if(opMap.EUR_CRM_ObjPromo__r.EUR_CRM_Evaluation_Period_End_Date__c != null) {
                    if(opMap.EUR_CRM_ObjPromo__r.EUR_CRM_Evaluation_Period_End_Date__c >= Date.Today()) {
                        // The O/P Evaluation date hasn't passed yet. Change Status to 'Under Evaluation'
                        opMap.EUR_CRM_ObjPromo__r.EUR_CRM_Status__c = 'Under Evaluation';
                    }
                    objPromMapToUpdate.put(opMap.EUR_CRM_ObjPromo__c, opMap.EUR_CRM_ObjPromo__r);
                }
            }
        }
     
        for(EUR_CRM_Visit_Action__c visitAction: [SELECT Id, EUR_CRM_Account__c, EUR_CRM_Status__c, EUR_CRM_Stage__c,
                                                    EUR_CRM_ObjPromo__c, RecordType.DeveloperName, EUR_CRM_ObjPromo__r.RecordType.DeveloperName, EUR_CRM_ObjPromo__r.EUR_CRM_Status__c
                                                  FROM EUR_CRM_Visit_Action__c WHERE EUR_CRM_ObjPromo__c IN :opIds]) {
                                                                  
            // Set OP Mapping to inactive when the active end date has elapsed
            EUR_CRM_ObjPromo_Account_Mapping__c opMap = opAccountMappingMap.get(createKey(visitAction.EUR_CRM_ObjPromo__c, visitAction.EUR_CRM_Account__c));
            
            if( opMap != null && 
                visitAction.RecordType.DeveloperName == 'EUR_RU_ON_Enter_Promo_Kit_Quantity' && 
                visitAction.EUR_CRM_ObjPromo__r.RecordType.DeveloperName == 'EUR_RU_ON_Trade_Phase_2')
            {
                if(visitAction.EUR_CRM_ObjPromo__r.EUR_CRM_Status__c == 'Active'){
                    opMap.EUR_CRM_Evaluation_Required__c = TRUE;
                    opAccountMappingToUpdate.put(opMap.Id, opMap);
                }
                else if(opMap.EUR_CRM_ObjPromo__r.EUR_CRM_Status__c == 'Under Evaluation'){
                    opMap.EUR_CRM_Is_Active__c = FALSE;
                    opAccountMappingToUpdate.put(opMap.Id, opMap); 
                }
            }
            // For execution action which is successful, need to create visit action follow up
            else if(opMap != null && visitAction.EUR_CRM_Stage__c == OP_ACTION_STATUS_EXECUTION && isVisitActionSuccessful(visitAction)) {
                // Set O/P Account Mappings Evaluation Required = TRUE
                opMap.EUR_CRM_Is_Active__c = FALSE;
                opMap.EUR_CRM_Evaluation_Required__c = TRUE;
                
                opAccountMappingToUpdate.put(opMap.Id, opMap);
            }
        }
        
        System.debug(opAccountMappingToUpdate);
        System.debug(visitActionFollowUps);
        System.debug(objPromMapToUpdate);

        if(opAccountMappingToUpdate.size() > 0){
            update opAccountMappingToUpdate.values();
        }
        
        if(visitActionFollowUps.size() > 0) {
            insert visitActionFollowUps;
        }
        
        if(objPromMapToUpdate.size() > 0) {
            update objPromMapToUpdate.values();
        }
        
    }
    
    public Boolean isVisitActionSuccessful(EUR_CRM_Visit_Action__c visitAction) {
        // Visit action is successful depending on the value of its Status picklist
        if(visitAction.EUR_CRM_Status__c == 'Participating') {
            return true;
        }
        return false;
    }    
    
    public String createKey(String objPromoId, String accountId) {
        return objPromoId + accountId;
    }
    
    global void finish(Database.BatchableContext BC){   
        EUR_CRM_BatchApexUtilityClass.sendBatchResultEmail(UserInfo.getUserId(), BC.getJobId(), new String[] {});
    }

}