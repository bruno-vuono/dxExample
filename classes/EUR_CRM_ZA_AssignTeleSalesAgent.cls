public with sharing class EUR_CRM_ZA_AssignTeleSalesAgent extends EUR_CRM_TriggerAbstract {

	public EUR_CRM_ZA_AssignTeleSalesAgent() {
	    super('EUR_CRM_ZA_AssignTeleSalesAgent');
	}
	
	private Set<String> validRecordTypes = new Set<String>{
		'EUR_ZA_Direct_Sales_Order',
		'EUR_ZA_Free_Goods_Order'
	};
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		List<Recordtype> salesOrderRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Sales_Order__c');
        Map<Id,Recordtype> salesOrderRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : salesOrderRecordTypes ){
           salesOrderRecordTypesMap.put(rt.id,rt);
        }
        
        Id teleSalesAgentId = [Select Id, EUR_CRM_Telesales_Agent__c FROM User WHERE Id = :Userinfo.getUserId()].EUR_CRM_Telesales_Agent__c;
        
        for(EUR_CRM_Sales_Order__c so : (List<EUR_CRM_Sales_Order__c>) sObjList) {
        	String salesOrdeRTDevName = salesOrderRecordTypesMap.get(so.recordtypeid).developername;            
            if(validRecordTypes.contains(salesOrdeRTDevName)){
            	so.EUR_CRM_TeleSales_Agent__c = teleSalesAgentId;
            }
        }
	}
}