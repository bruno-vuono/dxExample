public with sharing class EUR_CRM_SalesOrderAssignAutoNumber extends EUR_CRM_TriggerAbstract  {
  
  public EUR_CRM_SalesOrderAssignAutoNumber() {
    super('EUR_CRM_SalesOrderAssignAutoNumber');
  }
  private Set<String> validRecordTypes = EUR_CRM_RecordTypeHelper.SalesOrderAssignAutoNumber_validRecordTypes; 
  
      private final Static String MODULE = 'EUR_CRM_Running_Number'; 
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
  
        List<Recordtype> salesOrderRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Sales_Order__c');
        Map<Id,Recordtype> salesOrderRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : salesOrderRecordTypes ){
           salesOrderRecordTypesMap.put(rt.id,rt);
        }
         
        Map<String, EUR_CRM_GenerateAutoNumber > autoNumGenerators = new Map<String, EUR_CRM_GenerateAutoNumber >();        
         
        for (EUR_CRM_Sales_Order__c so : (List<EUR_CRM_Sales_Order__c>) sObjList) {
            String salesOrdeRTDevName = salesOrderRecordTypesMap.get(so.recordtypeid).developername;            
            if(validRecordTypes.contains(salesOrdeRTDevName ) ){
                String countryCode = so.EUR_CRM_Country_Code__c;
                String key = MODULE + countryCode;
                if(autoNumGenerators.get(key) == null)
                    autoNumGenerators.put(key, new EUR_CRM_GenerateAutoNumber(MODULE, countryCode));
                EUR_CRM_GenerateAutoNumber  autoNumAssign = autoNumGenerators.get(key);
                if(autoNumAssign.isValid)
                    so.name=  autoNumAssign.nextAutoNumStr();
                else
                    so.addError('Cannot generate Auto Number. Please contact the system administrator');
            }
        }
        
        for(EUR_CRM_GenerateAutoNumber autoNumAssign: autoNumGenerators.values() )
            autoNumAssign.writeToDB(); 
    }
}