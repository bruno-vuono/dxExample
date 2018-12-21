/*
* LAT_Payments
* Author: Martin Prado (martin@zimmic.com)
* Date: 08/15/2016
*/
trigger LAT_Payments on LAT_Payment__c (before insert, before update, after insert, after update) {

		if (Trigger.isBefore) {
			System.debug('%%%% entro1');
			Set<Id> contractsIds = new Set<Id>();
			List<LAT_Payment__c> paymentsRecalculateCost = new List<LAT_Payment__c>();
			Set<String> fys = new Set<String>();
			Set<String> clientsOnPromise = new Set<String>();

			// Set the manager and regional manager to use on the approval process
			Set<Id> userIds = new Set<Id>();
			for ( LAT_Payment__c payment : trigger.new ) {

				System.debug('%%%% entro2 : '+ payment.LAT_Contract__r.OwnerId);
				contractsIds.add(payment.LAT_Contract__c);
				fys.add(LAT_FiscalYearHelper.getInstance().getFiscalYearCode(payment.PaymentDate__c));

				if (Trigger.isInsert || payment.PaymentDate__c != trigger.oldMap.get(payment.id).PaymentDate__c
														|| payment.ProductGroup__c != trigger.oldMap.get(payment.id).ProductGroup__c) {
					// we only save the cost for product payments

					System.debug('%%%% entro3');
					if (payment.ProductGroup__c != null) {

						System.debug('%%%% entro4');
						System.debug('\n=============payment\n' +payment.ProductGroup__c +'\n=============\n');
						paymentsRecalculateCost.add(payment);
					}
					System.debug('\n=============payment\n' +payment +'\n=============\n');
				}
			}

			if (paymentsRecalculateCost.size()>0) {

				System.debug('%%%% entro5');
				LAT_ContractsCalculations cc = new LAT_ContractsCalculations();
				cc.setProductCostOnPayment(paymentsRecalculateCost);
			}

			Map <Id, LAT_Contract2__c> contractsInfo = new Map <Id, LAT_Contract2__c>([SELECT Id, Account__r.LAT_BR_RegionalClientOnPremise__c, OwnerId FROM LAT_Contract2__c WHERE id IN:contractsIds]);
			System.debug('\n=============paymentsMap\n' +contractsInfo +'\n=============\n');

			for (Id conId : contractsInfo.keySet()) {

				userIds.add(contractsInfo.get(conId).OwnerId);	
				System.debug('%%%% entro6');
				String clientOP = contractsInfo.get(conId).Account__r.LAT_BR_RegionalClientOnPremise__c;
				if (clientOP != null) {

					System.debug('%%%% entro7');
					clientsOnPromise.add(clientOP);
				}
			}

			List<LAT_ContractWorflow__c> workflows = [SELECT FY__c,RegionalClientOnPremise__c,WF__c,WorkflowNumber__c, Id FROM LAT_ContractWorflow__c where FY__c in:fys or RegionalClientOnPremise__c in: clientsOnPromise ];
			for (LAT_Payment__c payment : trigger.new) {
				 System.debug('%%%% entro8');
				String fy = payment.FY__c;
				String clientOP = contractsInfo.get(payment.LAT_Contract__c).Account__r.LAT_BR_RegionalClientOnPremise__c;
				// System.debug('\n=============\n' +fy +'\n=============\n');
				// System.debug('\n=============\n' +clientOP +'\n=============\n');
				payment.WorkflowME__c = null;
				for (LAT_ContractWorflow__c wf : workflows) {
					System.debug('%%%% entro9');
					// System.debug('\n=============wf\n' +wf.RegionalClientOnPremise__c +'\n=============\n');
					// System.debug('\n=============wf\n' +wf.FY__c +'\n=============\n');
					if (fy == wf.FY__c && clientOP == wf.RegionalClientOnPremise__c ) {
						// System.debug('\n=============true\n' +fy +'\n=============\n');
						// System.debug('\n=============true\n' +clientOP +'\n=============\n');
						System.debug('%%%% entro10');
						payment.WorkflowME__c = wf.Id;
					}

				}
			}
			System.debug('%%%% entro11');
			Map<Id, User> idUserMap =  new Map<Id,User>([SELECT Gerente_de_area__c,Gerente_regional__c,ManagerId FROM User where Id in: userIds]);
			System.debug('%%%% idUserMap : '+ idUserMap);
				for (LAT_Payment__c payment : trigger.new) {
					System.debug('%%%% entro12');
					if (idUserMap.containsKey(contractsInfo.get(payment.LAT_Contract__c).OwnerId)){
						System.debug('%%%% entro13');
						User owner = idUserMap.get(contractsInfo.get(payment.LAT_Contract__c).OwnerId);
						payment.Manager__c = owner.ManagerId;
						payment.RegionalManager__c = owner.Gerente_regional__c;
					}
				}

		} else if (Trigger.isAfter) {

			Set<Id> contractIds = new Set<Id>();

      for (LAT_Payment__c payment : trigger.new) {
				contractIds.add(payment.LAT_Contract__c);

				// ME integration
				//si esta aprobado y el status es "en aprovacao"
				System.debug('payment.ApprovedPayment__c' + payment.ApprovedPayment__c);
				System.debug('payment.ApprovedPayment__c' + payment.Id);

				if (payment.Status__c != 'Erro Integração' ) {
					if (payment.IntegrationStatus__c != 'Integrado com Sucesso'
							&& (
									(payment.ApprovedPayment__c == true && payment.Status__c == 'Em Aprovação'  && payment.ParentPayment__c == null )
									|| (payment.ApprovedPayment__c == true && trigger.oldMap.get(payment.Id).ApprovedPayment__c != true  && payment.ParentPayment__c == null
											&& (payment.ApprovedPayment__c == true && payment.Status__c == 'P' ||  payment.Status__c == 'Em Aprovação'))
									)) {
						LAT_ContractPaymentsHandlerInterface.sendPaymentToME(payment.Id);
					}
				}

				//Update childs payments
				if (trigger.isUpdate) {
					if ((payment.paymentGoals__c != trigger.oldMap.get(payment.Id).paymentGoals__c )
							|| (payment.GoalNotReached__c != trigger.oldMap.get(payment.Id).GoalNotReached__c )
							|| (payment.ReleaseReason__c != trigger.oldMap.get(payment.Id).ReleaseReason__c )
							|| (payment.Status__c != trigger.oldMap.get(payment.Id).Status__c )){

						List<LAT_Payment__c> payChilds = [SELECT paymentGoals__c, GoalNotReached__c, ReleaseReason__c, Status__c FROM LAT_Payment__c WHERE ParentPayment__c =: payment.id];
						System.debug('---------------\n ' + payChilds);
						List<LAT_Payment__c> paymentsToUpdate = new List<LAT_Payment__c>();
						if (payChilds.size() > 0) {
							for (LAT_Payment__c paychild : payChilds) {
								paychild.paymentGoals__c =  payment.paymentGoals__c;
								paychild.GoalNotReached__c = payment.GoalNotReached__c;
								paychild.ReleaseReason__c = payment.ReleaseReason__c;
								paychild.Status__c = payment.Status__c;
								paymentsToUpdate.add(paychild);
							}
							update paymentsToUpdate;
						}

					}
				}
			} // End (LAT_Payment__c payment : trigger.new)

			// Create all the calculation based on the payments
			LAT_ContractsCalculations cc = new LAT_ContractsCalculations();
			cc.calculatePaymentsInformation(contractIds);
		} // End isAfter
}