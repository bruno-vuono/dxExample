public with sharing class LAT_PaymentBefore {

	public static void validateContractPayments (List <LAT_Payment__c> payments) {
		// Mobile must has this control 
		// for (LAT_Payment__c payment : payments) {
		// 	if ('Pendente' != payment.Status__c && 'Reprovado' != payment.Status__c) {
		// 		payment.addError('Somente pagamentos com Status igual a Pendente ou Reprovado poderão ser excluídos ou alterados');
		// 	}
		// }
	}

}