/************************
*Create Date: 2016-12-29
*Created By : Jay
*Purpose    : Auto assign city after user enter postal code, reference EUR_CRM_Postal_Code_City_Mapping__c
*Record Type: 
*************************/

public class EUR_CRM_Account_City_PostalCode_Handler extends EUR_CRM_TriggerAbstract
{

    /*static Map<String, String> AccountCityPostalCodeMap_validRecordTypes = new Map<String, String> {
        'EUR_DE_OFF_STD' => 'EUR_DE_Postal_Code_City_Mapping',
        'EUR_DE_ON_Consumers' => 'EUR_DE_Postal_Code_City_Mapping',
        'EUR_DE_ON_Enquiry_Acquisition' => 'EUR_DE_Postal_Code_City_Mapping',
        'EUR_DE_ON_Gastronomy' => 'EUR_DE_Postal_Code_City_Mapping',
        'EUR_DE_ON_Service_agency' => 'EUR_DE_Postal_Code_City_Mapping',
        'EUR_DE_ON_Wholesaler' => 'EUR_DE_Postal_Code_City_Mapping'
    };*/

    

    private static Map<String, String> validRecordTypes = EUR_CRM_RecordTypeHelper.AccountCityPostalCodeMap_validRecordTypes; 

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(validRecordTypes.KeySet());

            return TRt;
        }private set;
    }

    public EUR_CRM_Account_City_PostalCode_Handler() {
        super('EUR_CRM_Account_City_PostalCode_Handler');
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        System.Debug('EUR_CRM_Account_City_PostalCode_Handler');
        if(tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE){

        
            List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
            Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
            Set<String> accPostalCodeList = New Set<String>();// Account postal Code
            Set<String> postalCodertList = New Set <String>(); //EUR_CRM_Postal_Code_City_Mapping__c record type
            List<EUR_CRM_Postal_Code_City_Mapping__c> postalCodeList = New List<EUR_CRM_Postal_Code_City_Mapping__c>();
            Map<String,String> postalCodeCityMap = New Map<String,String>(); //Postal Code : City
            List<EUR_CRM_Account__c> targetAccount = New List<EUR_CRM_Account__c>();

            for(Recordtype rt : accountRecordTypes ){
               accountRecordTypesMap.put(rt.id,rt);
            }

            //Loop account list for valid record type,postal code, target account
            for (EUR_CRM_Account__c acc : (List<EUR_CRM_Account__c>) sObjList) {
                String accountTDevName = accountRecordTypesMap.get(acc.recordtypeid).developername;  

                if(validRecordTypes.containsKey(accountTDevName) && acc.EUR_CRM_Postal_Code__c <> null){
                    accPostalCodeList.add(acc.EUR_CRM_Postal_Code__c);
                    postalCodertList.add(validRecordTypes.get(accountTDevName));
                    targetAccount.add(acc);
                }
            }
            //if there is valid account get City by PostalCode and record type
System.Debug('@@EUR_CRM_Account_City_PostalCode_Handler : accPostalCodeList :' + accPostalCodeList);
System.Debug('@@EUR_CRM_Account_City_PostalCode_Handler : postalCodertList :' + postalCodertList);

            if (accPostalCodeList.size() > 0 && postalCodertList.size() > 0){
                postalCodeList = [SELECT EUR_CRM_City__c,EUR_CRM_Postal_Code__c 
                                  FROM EUR_CRM_Postal_Code_City_Mapping__c 
                                  WHERE EUR_CRM_Postal_Code__c in :accPostalCodeList and RecordType.developername in : postalCodertList];

                for(EUR_CRM_Postal_Code_City_Mapping__c pc : postalCodeList){
                    postalCodeCityMap.put(pc.EUR_CRM_Postal_Code__c, pc.EUR_CRM_City__c);
                }
            }
System.Debug('@@EUR_CRM_Account_City_PostalCode_Handler : postalCodeCityMap :' + postalCodeCityMap);
            //Assign City to Accont
            for (EUR_CRM_Account__c acc : (List<EUR_CRM_Account__c>) targetAccount) {
                acc.EUR_CRM_City__c = postalCodeCityMap.get(acc.EUR_CRM_Postal_Code__c);
            }
System.Debug('@@EUR_CRM_Account_City_PostalCode_Handler : targetAccount :' + targetAccount);
        }
    }
}