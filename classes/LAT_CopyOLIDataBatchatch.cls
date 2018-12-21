/**********************************************
 Dev: Juan Pablo Cubo       Version: 1
**********************************************/

global class LAT_CopyOLIDataBatchatch implements Database.Batchable<sObject>,Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id, PercentualBonus__c, PC_Bonus__c, PaymentCondition__c, cd_payment_term__c, PaymentConditionDescription__c,' + 
        ' ds_payment_term__c, MultipleQuantity__c, QT_multiple__c, SkuText__c, Sku__c, UnitCode__c, CD_unit__c FROM OpportunityLineItem' +
        ' WHERE Opportunity.RecordType.DeveloperName = \'OPP_1_NewOrder_ARG\' OR Opportunity.RecordType.DeveloperName = \'OPP_2_NewOrder_URU\'' +
        ' OR Opportunity.RecordType.DeveloperName = \'OPP_3_HeaderBlocked_ARG\' OR Opportunity.RecordType.DeveloperName = \'OPP_4_HeaderBlocked_URU\'' +
        ' OR Opportunity.RecordType.DeveloperName = \'OPP_5_OrderBlocked_ARG\' OR Opportunity.RecordType.DeveloperName = \'OPP_6_OrderBlocked_URU\'' + 
        ' OR Opportunity.RecordType.DeveloperName = \'Bloqueia_alteracao\' OR Opportunity.RecordType.DeveloperName = \'Bloqueia_alteracao_do_cabecalho\'' + 
        ' OR Opportunity.RecordType.DeveloperName = \'LAT_MX_OPP_HeaderBlocked\' OR Opportunity.RecordType.DeveloperName = \'LAT_MX_OPP_NewOrder\'' + 
        ' OR Opportunity.RecordType.DeveloperName = \'LAT_MX_OPP_OrderBlocked\' OR Opportunity.RecordType.DeveloperName = \'Nova_oportunidade\''; 
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        
    }

    global void finish(Database.BatchableContext BC){
        
    }
    
}