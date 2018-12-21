/*
* LAT_ContractDocumentsPDFController
* Author: Martin Prado (martin@zimmic.com)
* Date: 07/13/2017
*/
public with sharing class LAT_ContractDocumentsPDFController {

	// Vars
	public String body { get; set; }
	public String contractName { get; set; }
	public Boolean isApproved { get; set; }
	public boolean needsPresidentSign {get;set;}
    public boolean needsDirectorFinanciero {get;set;}
    public boolean needsDirectorComercial {get;set;}
    public LAT_Contract2__c contract {get;set;}

	//Constructor
	public LAT_ContractDocumentsPDFController() {
		Id contractId = system.CurrentPageReference().getParameters().get('id');
		String docName = system.CurrentPageReference().getParameters().get('docName');
		contractName = '';
		body = '';
		isApproved = false;

		if (String.isBlank(docName)) {
			docName = 'MinutaPadrao';
		}

		List<LAT_ContractDocs__c> lcd = [Select Id, body__c from LAT_ContractDocs__c where Name =: docName];
		body  = (lcd.size() >0) ? convertTags(lcd[0].body__c, contractId) : '';
		// if(lcd.size() >0){
		// 	body = convertTags(lcd[0].body__c, contractId);
		// }
		List<LAT_Contract2__c> contractResults = [SELECT  Revenue__c, Comments__c, (select Provider__c, CNPJ__c from LAT_Providers__r),
        (SELECT Category__c,Contract__c,CurrencyIsoCode,ExclusivityPromotional__c,Id,Name,Notes__c,Priority__c,VisualExclusivity__c FROM Acordos_Promocionales__r),
          VodkaClubCabinets__c, WhiskyClubCabinets__c, DJBooth__c, BarsShelves__c,
          (Select ProductGroup__r.name, BoxesContract__c,BusinessCondition__c,CurrencyIsoCode,Id,LAT_Contract__c,Name,ProductGroup__c from LAT_ContractVolumes__r),
          Name ,  CustomerSignatory__c, CustomerSignatory__r.name, Status__c, createdBy.Name,
          (Select  Ammount__c,Finality__c,PaymentDate__c,ProductGroup__c,RecordTypeId,Status__c,ProductGroup__r.name,  RecordType.Name, Type__c,Volumen__c from LAT_Payments__r order by PaymentDate__c asc ),
          RecordType.Name, Account__r.regional__r.Name, Account__r.Nielsen_Area__r.Name, Account__r.Billing_Address__c, Account__r.Billing_Number__c,
          Account__r.Revenue_City__c,  Account__r.Revenue_Postal_Code__c,  Account__r.Revenue_Address__c, Account__r.Revenue_Number__c ,
           Account__r.Revenue_UF__c, Account__r.Billing_UF__c, Account__r.Billing_City_Code__c, Account__r.Billing_PostalCode__c,
           Account__r.Corporate_Name__c, Account__r.name, Account__r.Revenue_City__r.name, Account__r.Sub_Channel_Rating__r.name,
           account__r.CNPJ__c, account__r.State_Registration__c, Account__r.subType__c, StartDate__c, EndDate__c, ContractTerms__c,
           ROI__c, TotalProductsPerceivedValue__c, TotalMoneyPerceivedValue__c,convertCurrency(ContractValue__c),
           (SELECT Type__c, Comment__c FROM Contrapartidas_de_Visibilidades__r),
       (SELECT Client__c, Client__r.Name, Client__r.CNPJ__c  FROM Clientes_do_Contrato__r), OriginalContractNumber__c, OriginalContractName__c
       FROM LAT_Contract2__c where id =: contractId];
	    if(contractResults.size() > 0){
	      contract = contractResults[0];
	      if(contract.Status__c == 'Aprovado'){
	        isApproved = true;
	      }
	     contract = contractResults[0];


	    needsPresidentSign = (contract.ContractValue__c!= null && contract.ContractValue__c >= LAT_Docusign_Utils.SENT_TO_PRESIDENT_GREATER_THAN);
	    system.debug('Ernestop+++++ ContractValue = ' + contract.ContractValue__c);
	    needsDirectorFinanciero = (contract.ContractValue__c!= null && contract.ContractValue__c >= LAT_Docusign_Utils.SENT_TO_FINANCIAL_DIRECTOR_GREATER_THAN);
	      
	    needsDirectorComercial = (contract.ContractValue__c!= null && contract.ContractValue__c >= LAT_Docusign_Utils.SENT_TO_COMERCIAL_DIRECTOR_GREATER_THAN);
	    system.debug('Ernestop+++++ needsPresidentSign = ' + needsPresidentSign);
	    system.debug('Ernestop+++++ needsPresidentSign = ' + needsDirectorFinanciero);
	    system.debug('Ernestop+++++ needsPresidentSign = ' + needsPresidentSign);


	}
}

	private String convertTags(String body, Id contractId) {

		List<LAT_Contract2__c> contractResults = [SELECT  Revenue__c, Comments__c, Name ,   Status__c,
										          RecordType.Name, Account__r.regional__r.Name, Account__r.Nielsen_Area__r.Name, Account__r.Billing_Address__c, Account__r.Billing_Number__c,
										          Account__r.Revenue_City__c,  Account__r.Revenue_Postal_Code__c,  Account__r.Revenue_Address__c, Account__r.Revenue_Number__c ,
										          Account__r.Revenue_UF__c, Account__r.Billing_UF__c, Account__r.Billing_City_Code__c, Account__r.Billing_PostalCode__c,
										          Account__r.Corporate_Name__c, Account__r.name, Account__r.Revenue_City__r.name, Account__r.Sub_Channel_Rating__r.name,
										          account__r.CNPJ__c, account__r.State_Registration__c, Account__r.subType__c, StartDate__c, EndDate__c, TradingConditionNegotiated__c
		   							  				FROM LAT_Contract2__c where id =: contractId];
		if(contractResults.size()>0){
			LAT_Contract2__c contract = contractResults.get(0);
			String ccNegociated = (contract.TradingConditionNegotiated__c != null) ? contract.TradingConditionNegotiated__c : 'N/A';
			contractName =  contract.Name;
			isApproved =  (contract.Status__c == 'Aprovado');

			body = body.replace('[STARTDATE]', String.valueOf(contract.StartDate__c.format())).replace('[ENDATE]', String.valueOf(contract.EndDate__c.format())).replace('[CCNEGOCIATED]', ccNegociated);
		}
		return body;
	}
}