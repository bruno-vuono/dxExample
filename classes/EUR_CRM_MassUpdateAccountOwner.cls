global class EUR_CRM_MassUpdateAccountOwner implements Database.Batchable<sObject> {

    global final String query;

    Set<ID> territoriesIds = new Set<Id>();
    Boolean doPostProcessing;

    global EUR_CRM_MassUpdateAccountOwner(Set<ID> territoriesIds) {
        this.territoriesIds = territoriesIds;
        query = 'SELECT Id,OwnerId,EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__r.id ' +
                'FROM EUR_CRM_Account__c ' +
                'WHERE EUR_CRM_Territory__c IN :territoriesIds ' +
                'AND EUR_CRM_Territory__r.EUR_CRM_IsOwnerChanged__c = true';
    }

    global EUR_CRM_MassUpdateAccountOwner(String q) {
        query = q;
        doPostProcessing = true;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    //Main Logic Implementation
    global void execute(Database.Batchablecontext BC, List<sObject> scope) {
        List<EUR_CRM_Account__c> acctList = (List<EUR_CRM_Account__c>) scope;
        List<EUR_CRM_Account__c> acctToUpdateList = new List<EUR_CRM_Account__c>();
        Set<ID> territoryIDSet = new Set<ID>();

        for (EUR_CRM_Account__c acct : acctList) {
            Boolean isChanged = false;
            if (acct.EUR_CRM_Territory__r != null) {
                if (acct.EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__c != null) {
                    acct.OwnerID = acct.EUR_CRM_Territory__r.EUR_CRM_Territory_Owner__r.id;
                    territoryIDSet.add(acct.EUR_CRM_Territory__c);
                    isChanged = true;
                }
            }
            Boolean isPrestige = false;
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(acct));
            isPrestige = m.get('EUR_CRM_Prestige_Territory__c') != null;
            if (isPrestige) {
                acct.EUR_CRM_Prestige_Sales_Rep__c = acct.EUR_CRM_Prestige_Territory__r.EUR_CRM_Territory_Owner__r.Name;
                acct.EUR_CRM_Prestige_Sales_Rep_ID__c = acct.EUR_CRM_Prestige_Territory__r.EUR_CRM_Territory_Owner__r.Id;
                territoryIDSet.add(acct.EUR_CRM_Prestige_Territory__c);
                isChanged = true;
            }
            if (isChanged) {
                acctToUpdateList.add(acct);
            }
        }

        if (acctToUpdateList.size() > 0)
            update acctToUpdateList;

        if (territoriesIds.isEmpty()) {
            List <EUR_CRM_Territory__c> territoriesToUpdate = [SELECT ID, Name, EUR_CRM_IsOwnerChanged__c FROM EUR_CRM_Territory__c WHERE ID IN:territoryIDSet];

            for (EUR_CRM_Territory__c i : territoriesToUpdate)
                i.EUR_CRM_IsOwnerChanged__c = false;

            if (territoriesToUpdate.size() > 0)
                update territoriesToUpdate;
        }

    }

    // Send email, clean and end execution
    global void finish(Database.BatchableContext BC) {
        if (doPostProcessing == true) {
            AsyncApexJob apexjob = [Select Id From AsyncApexJob WHERE Id = :BC.getJobId()];
            EUR_CRM_BatchApexUtilityClass.sendBatchResultEmail(UserInfo.getUserId(), apexjob.id, new String[]{
            });
        }
    }

}