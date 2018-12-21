global class LAT_BR_Planejamento_Batch implements Database.Batchable<sObject> {
	
	String query;

	
	global LAT_BR_Planejamento_Batch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> integrationUsers = LAT_GeneralConfigDao.getValueAsStringArray('INTEGRATION_USERS',',');
        if(integrationUsers == null){
            integrationUsers = new List<String>();
        }
        List<AggregateResult> owners = [SELECT owner.id FROM Account where (recordtype.developerName = 'on_trade' or recordtype.developerName = 'off_trade') AND  Rating <> 'Cliente inativo'  AND Status__c != 'Não aprovado' AND owner.name not in: integrationUsers group by owner.id];
        query = 'SELECT Id FROM User where id in (\'\'' ;
        
        for(AggregateResult ar : owners){
        	query += ',\'' + ar.get('id') + '\'';
        }
        query += ')';


		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		LAT_BR_AP01_Planejamento.generateMonthlyPlans(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}