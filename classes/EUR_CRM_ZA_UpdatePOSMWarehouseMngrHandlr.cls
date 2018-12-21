public with sharing class EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr extends EUR_CRM_TriggerAbstract {

	public EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr() {
	    super('EUR_CRM_ZA_UpdatePOSMWarehouseMngrHandlr');
	}
	
	private Set<String> validPOSMRecordTypes = new Set<String>{
		'EUR_ZA_POSM_Order'
	};
	
	private static Set<String> validEUAcctRecordTypes = new Set<String>{
		'EUR_ZA_Distributor',
		'EUR_ZA_Off_Trade',
		'EUR_ZA_On_Trade_Direct',
		'EUR_ZA_On_Trade_Indirect',
		'EUR_ZA_On_Trade_Informal'
	};

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(validEUAcctRecordTypes);

            return TRt;
        }private set;
    }
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		List<Recordtype> posmOrderRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_POSM_Order__c');
        Map<Id,Recordtype> posmOrderRecordTypesMap = new Map<Id,Recordtype>();
        List<Recordtype> euAccountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        Map<Id,Recordtype> euAccountRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : posmOrderRecordTypes ){
           posmOrderRecordTypesMap.put(rt.id,rt);
        }
        
        for(Recordtype rt : euAccountRecordTypes ){
           euAccountRecordTypesMap.put(rt.id,rt);
        }
        
        Map<Id, EUR_CRM_Account__c> accountMap = new Map<Id, EUR_CRM_Account__c>();
        for(EUR_CRM_Account__c account : (List<EUR_CRM_Account__c>) sObjList) { 
        	String euAccountRTDevName = euAccountRecordTypesMap.get(account.RecordtypeId).developername;   
        	if(validEUAcctRecordTypes.contains(euAccountRTDevName)){
        		EUR_CRM_Account__c oldRecord = (EUR_CRM_Account__c ) oldMap.get(account.Id);   
	            if(account.EUR_CRM_Warehouse_Manager__c != oldRecord.EUR_CRM_Warehouse_Manager__c){
	            	accountMap.put(account.id, account);
	            }
        	}    
        }
        
        List<EUR_CRM_POSM_Order__c> posmOrderToUpdate = new List<EUR_CRM_POSM_Order__c>();
        for(EUR_CRM_POSM_Order__c posmOrder : [SELECT id, EUR_CRM_Account__c, EUR_CRM_Warehouse_Manager__c, RecordtypeId, EUR_CRM_Order_Status__c FROM EUR_CRM_POSM_Order__c WHERE EUR_CRM_Account__c IN :accountMap.keyset()]){
        	String posmOrdeRTDevName = posmOrderRecordTypesMap.get(posmOrder.RecordtypeId).developername;            
            if(validPOSMRecordTypes.contains(posmOrdeRTDevName)){
            	if(posmOrder.EUR_CRM_Order_Status__c != 'Finished'){
            		posmOrderToUpdate.add(posmOrder);
            	}
            }
        }
        
        if(posmOrderToUpdate.size() > 0){
        	update posmOrderToUpdate;
        }
	}
}