@RestResource(urlMapping='/LAT_ContractCalculationRest/')
global with sharing class LAT_ContractCalculationRest {
	@HttpPost
	global static void post(String contractId) {
        System.debug('%%%%%%%LAT_ContractCalculationRest : '+contractId);
		Double roi =  LAT_ContractsWS.emulateRoi(contractId);
		RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{ "roi" : "'+String.valueOf(roi)+'"  }');


	}
}