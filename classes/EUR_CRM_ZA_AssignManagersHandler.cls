public with sharing class EUR_CRM_ZA_AssignManagersHandler extends EUR_CRM_TriggerAbstract {

	public EUR_CRM_ZA_AssignManagersHandler() {
	    super('EUR_CRM_ZA_AssignManagersHandler');
	}
	
	private Set<String> validRecordTypes = new Set<String>{
		'EUR_ZA_Head_Office_Contract',
		'EUR_ZA_Outlet_Contract'
	};
	
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		List<Recordtype> contractRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Contract__c');
        Map<Id,Recordtype> contractRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : contractRecordTypes ){
           contractRecordTypesMap.put(rt.id,rt);
        }
        
        if(tAction == TriggerAction.BEFORE_INSERT){
        	Set<Id> accountIds = new Set<Id>();
	        Map<Id, EUR_CRM_Account__c> accountManagersMap = new Map<Id, EUR_CRM_Account__c>();
	        
	        Id managerId = [SELECT Id, ManagerId FROM User WHERE Id = :Userinfo.getUserId()].ManagerId;
	        
	        for(EUR_CRM_Contract__c contract : (List<EUR_CRM_Contract__c>) sObjList) {
	        	String contractRTDevName = contractRecordTypesMap.get(contract.recordtypeid).developername;            
	            if(validRecordTypes.contains(contractRTDevName)){
	            	accountIds.add(contract.EUR_CRM_Account__c);
	            	//contract.EUR_CRM_Event_Manager__c = contract.EUR_CRM_Account__r.EUR_CRM_Event_Manager__c;
	            	//contract.EUR_CRM_Warehouse_Manager__c = contract.EUR_CRM_Account__r.EUR_CRM_Warehouse_Manager__c;
	            }
	        }
	        
	        for(EUR_CRM_Account__c account : [SELECT Id, EUR_CRM_Event_Manager__c, EUR_CRM_Warehouse_Manager__c FROM EUR_CRM_Account__c WHERE Id IN :accountIds]){
	        	accountManagersMap.put(account.Id, account);
	        }
	        
	        for(EUR_CRM_Contract__c contract : (List<EUR_CRM_Contract__c>) sObjList) {
	        	String contractRTDevName = contractRecordTypesMap.get(contract.recordtypeid).developername;            
	            if(validRecordTypes.contains(contractRTDevName)){
	            	if(accountManagersMap.containskey(contract.EUR_CRM_Account__c)){
	            		contract.EUR_CRM_Event_Manager__c = accountManagersMap.get(contract.EUR_CRM_Account__c).EUR_CRM_Event_Manager__c;
	            		contract.EUR_CRM_Warehouse_Manager__c = accountManagersMap.get(contract.EUR_CRM_Account__c).EUR_CRM_Warehouse_Manager__c;
	            	}
	            	contract.EUR_CRM_Sales_Manager__c = managerId;
	            }
	        }
        } else if(tAction == TriggerAction.BEFORE_UPDATE){
        	Set<Id> accountIds = new Set<Id>();
	        Map<Id, EUR_CRM_Account__c> accountManagersMap = new Map<Id, EUR_CRM_Account__c>();
	        
	        for(EUR_CRM_Contract__c contract : (List<EUR_CRM_Contract__c>) sObjList) {
	        	String contractRTDevName = contractRecordTypesMap.get(contract.recordtypeid).developername; 
	        	EUR_CRM_Contract__c oldRecord = (EUR_CRM_Contract__c ) oldMap.get(contract.id);           
	            if(validRecordTypes.contains(contractRTDevName)){
	            	if(contract.EUR_CRM_Account__c != oldRecord.EUR_CRM_Account__c){
	            		accountIds.add(contract.EUR_CRM_Account__c);
	            	}
	            }
	        }
	        
	        for(EUR_CRM_Account__c account : [SELECT Id, EUR_CRM_Event_Manager__c, EUR_CRM_Warehouse_Manager__c FROM EUR_CRM_Account__c WHERE Id IN :accountIds]){
	        	accountManagersMap.put(account.Id, account);
	        }
	        
	        for(EUR_CRM_Contract__c contract : (List<EUR_CRM_Contract__c>) sObjList) {
	        	String contractRTDevName = contractRecordTypesMap.get(contract.recordtypeid).developername;            
	            EUR_CRM_Contract__c oldRecord = (EUR_CRM_Contract__c ) oldMap.get(contract.id);
	            if(validRecordTypes.contains(contractRTDevName)){
	            	if(accountManagersMap.containskey(contract.EUR_CRM_Account__c)){
	            		if(contract.EUR_CRM_Account__c != oldRecord.EUR_CRM_Account__c){
	            			contract.EUR_CRM_Event_Manager__c = accountManagersMap.get(contract.EUR_CRM_Account__c).EUR_CRM_Event_Manager__c;
	            			contract.EUR_CRM_Warehouse_Manager__c = accountManagersMap.get(contract.EUR_CRM_Account__c).EUR_CRM_Warehouse_Manager__c;
	            		}
	            	}
	            }
	        }
        }
	}
}