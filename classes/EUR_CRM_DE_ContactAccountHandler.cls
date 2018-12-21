/**
PR DE Contact ownership re-assignemt triger - if Account owner changes, contact owner must also change

*/
public class EUR_CRM_DE_ContactAccountHandler  extends EUR_CRM_TriggerAbstract {
     
    private static Set<String> allGermnayAccountRecordTypeSet = new Set<String>{
      'EUR_DE_ON_Consumers',
      'EUR_DE_ON_Enquiry_Acquisition',
      'EUR_DE_ON_Gastronomy',
      'EUR_DE_ON_Service_agency',
      'EUR_DE_ON_Wholesaler',
      'EUR_DE_OFF_STD'
    }; 


    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(allGermnayAccountRecordTypeSet);

            return TRt;
        }private set;
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        
        List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
        
        for(Recordtype rt : accountRecordTypes){
           accountRecordTypesMap.put(rt.id,rt);
        }
        Set<Id> validAccounts = new Set<id>(); 
        
        for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){
            EUR_CRM_Account__c oldAccount = oldMap != null ? (EUR_CRM_Account__c) oldMap.get(euAccount.id) : null;
            if(allGermnayAccountRecordTypeSet.contains(accountRecordTypesMap.get(euAccount.recordtypeid).developername) &&
                    oldAccount != null &&
                    oldAccount.ownerid != euAccount.ownerid ){
                validAccounts.add(euAccount.id);
            }
        } 
        List<Contact> contactsForUpdate = new List<Contact>();
        if(validAccounts.size() > 0)
        for(Contact c : [select id,EUR_CRM_Account__c,ownerid from Contact where EUR_CRM_Account__c in: validAccounts
        and EUR_CRM_Account__c != null]){
            EUR_CRM_Account__c euAccount = (EUR_CRM_Account__c) newMap.get(c.EUR_CRM_Account__c);
            if(c.ownerid != euAccount.ownerid ){
                c.ownerid = euAccount.ownerid ;
                contactsForUpdate.add(c);
            }
        }
        if(contactsForUpdate.size() > 0)
            update contactsForUpdate;
    }
    
    public EUR_CRM_DE_ContactAccountHandler(){
        super('EUR_CRM_DE_ContactAccountHandler');
    }  
}