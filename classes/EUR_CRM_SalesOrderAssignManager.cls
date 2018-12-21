public with sharing class EUR_CRM_SalesOrderAssignManager extends EUR_CRM_TriggerAbstract  {

	public EUR_CRM_SalesOrderAssignManager() {
    	super('EUR_CRM_SalesOrderAssignManager');
	}

	private Set<String> validRecordTypes = new Set<String>{
      'EUR_ZA_Direct_Sales_Order',
      'EUR_ZA_Free_Goods_Order',
      'EUR_CH_Direct_Sales_Order',
      'EUR_CH_Indirect_Sales_Order',
      'EUR_DK_Free_Goods_Order_to_Customer'
	};
  
	public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
  		List<Recordtype> salesOrderRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Sales_Order__c');
		Map<Id,Recordtype> salesOrderRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : salesOrderRecordTypes ){
           salesOrderRecordTypesMap.put(rt.id,rt);
        }
        
        List<EUR_CRM_Sales_Order__c> salesOrderList = (List<EUR_CRM_Sales_Order__c>) sObjList;
        List<EUR_CRM_Sales_Order__c> validSalesOrderList = new List<EUR_CRM_Sales_Order__c>();
        
        Set<ID> ownerIDSet = new Set<ID>();
        Set<ID> salesOrderIDSet = new Set<ID>();
        
        for(EUR_CRM_Sales_Order__c so : salesOrderList) {
        	String salesOrdeRTDevName = salesOrderRecordTypesMap.get(so.recordtypeid).developername;
        	if(validRecordTypes.contains(salesOrdeRTDevName ) ){
        		ownerIDSet.add(so.CreatedById);
        		validSalesOrderList.add(so);
        		salesOrderIDSet.add(so.id);
        	}
        }
        
        if(validSalesOrderList.size() > 0) {
        	List<EUR_CRM_Sales_Order__c> queriedValidSalesOrderList = [SELECT ID, Name, CreatedById, EUR_CRM_Manager__c FROM EUR_CRM_Sales_Order__c WHERE ID IN : salesOrderIDSet];
        	Map<ID, User> ownerMap = new Map<ID, User>([SELECT ID, ManagerID FROM User WHERE ID IN : ownerIDSet]);
        	for(EUR_CRM_Sales_Order__c so : queriedValidSalesOrderList) {
        		User u = ownerMap.get(so.CreatedById);
        		so.EUR_CRM_Manager__c = u.managerID;
        	}
        	update queriedValidSalesOrderList;
        }
	}
}