global class LAT_UpdateVisitasOwner_Batch implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
		
	String query;
	Map <Id, Id> accountNewOwner = new Map<Id, Id>();
	Set <Id> accounts = new Set <Id>();
	Id newOwner = null;
	
	global LAT_UpdateVisitasOwner_Batch(String headerId) {


		List <LAT_MasiveOwnerLine__c> lines = [Select LAT_Account__c, LAT_NewValue__c From LAT_MasiveOwnerLine__c Where LAT_Header__c = :headerId];
	

		for(LAT_MasiveOwnerLine__c line :lines){
			accounts.add(line.LAT_Account__c);
			accountNewOwner.put(line.LAT_Account__c, line.LAT_NewValue__c);
			newOwner = line.LAT_NewValue__c;
		}

		String status = 'Encerrada';

		query = 'Select Id, Conta__c, Planejamento__c, Planejamento__r.ownerid, Planejamento__r.Ano_de_Referencia__c, Planejamento__r.M_s_de_Ref_rencia__c From Visitas__c where status__c != \'Encerrada\' and Conta__c in :accounts';

	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		List <Visitas__c> visitas = (List<Visitas__c>)scope;
		   		
		Map <String, Planejamento__c> pvpsNewOwner = new Map<String, Planejamento__c>();

		List<Planejamento__c> listaPVP = [select id, ownerid, M_s_de_Ref_rencia__c, Ano_de_Referencia__c from Planejamento__c where ownerid = :newOwner and createddate = Last_N_Months:6];

		for(Planejamento__c plan :listaPVP){
			
			pvpsNewOwner.put(plan.M_s_de_Ref_rencia__c+plan.Ano_de_Referencia__c, plan);
		}

		for (Visitas__c visita : visitas) {
						
			if(!pvpsNewOwner.isEmpty() && pvpsNewOwner.get(visita.Planejamento__r.M_s_de_Ref_rencia__c+visita.Planejamento__r.Ano_de_Referencia__c) != null){
				
				visita.Planejamento__c = pvpsNewOwner.get(visita.Planejamento__r.M_s_de_Ref_rencia__c+visita.Planejamento__r.Ano_de_Referencia__c).id;
			}
		}

		update visitas;
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}