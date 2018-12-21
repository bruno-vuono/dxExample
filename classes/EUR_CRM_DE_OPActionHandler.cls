/**
 
*/
public class EUR_CRM_DE_OPActionHandler  extends EUR_CRM_TriggerAbstract {
    
    private static Set<String> validRecordTypes= new Set<String>{
      'EUR_DE_OFF_Confirm_Agreement_To_Buy',
      'EUR_DE_OFF_Enter_Sell_In_Qty' ,
      
      'EUR_FI_Confirm_Participation',
      'EUR_FI_Enter_Sell_In_Volume_Estimate' ,
      'EUR_FI_Follow_Up' ,
      'EUR_FI_Presentation' ,
      'EUR_FI_Record_Additional_Material',
      
      'EUR_ZA_ON_Confirm_Display_Setup',
      'EUR_ZA_OFF_Sell_in_Promotion',
      'EUR_ZA_ON_Sell_In_Promotion',
      'EUR_ZA_Define_Particpation_Conditions',
      'EUR_ZA_OFF_Define_Participation_Conditions',
      'EUR_ZA_OFF_Follow_Up',
      'EUR_ZA_ON_Follow_Up',
      
      // RU Record Types
      'EUR_RU_OFF_OP_Action',
      'EUR_RU_ON_OP_Action',
      
      'EUR_DK_OFF_OP_Action'
    };
    /* 
    */
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        List<Recordtype> opActionRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_ObjPromo_Action__c');
        Map<Id,Recordtype> opActionRecordTypesMap = new Map<Id,Recordtype>();
        List<Recordtype> visitActionRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Visit_Action__c');
        Map<String,Recordtype> visitActionRecordTypesMap = new Map<String,Recordtype>();
        for(Recordtype rt : opActionRecordTypes ){
           opActionRecordTypesMap.put(rt.id,rt);
        }
        for(Recordtype rt : visitActionRecordTypes ){
           visitActionRecordTypesMap.put(rt.developername,rt);
        }
        for(EUR_CRM_ObjPromo_Action__c opAction: (List<EUR_CRM_ObjPromo_Action__c>) sObjList){
            String devName = opAction.EUR_CRM_Visit_Action_RecordType_DevName__c;
            /*if(validRecordTypes.contains(opActionRecordTypesMap .get(opAction.recordTypeId).developername) &&
                devName  != null && devName != '' &&
                visitActionRecordTypesMap.get(devName) != null){
                opAction.EUR_CRM_Visit_Action_RecordTypeID__c = visitActionRecordTypesMap.get(devName).id;
            }*/ 
             if(//opActionRecordTypesMap.get(opAction.recordTypeId).developername.contains('_DE_') &&
                devName  != null && devName != '' &&
                visitActionRecordTypesMap.get(devName) != null)
             opAction.EUR_CRM_Visit_Action_RecordTypeID__c = visitActionRecordTypesMap.get(devName).id;  
        }
    }
    
    public EUR_CRM_DE_OPActionHandler(){
        super('EUR_CRM_DE_OPActionHandler');
    }
    
}