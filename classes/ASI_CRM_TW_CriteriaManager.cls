/*********************************************************************************
 * Name: ASI_CRM_TW_CriteriaManager
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 05/03/2015       Introv: Twinkle         Cloned from ASI_CRM_CriteriaManager
*********************************************************************************/

public without sharing class ASI_CRM_TW_CriteriaManager {
    private List<RecordType> criteriaRecordTypes{get;set;}
    private Map<Id, String> criteriaTypeMap{get;set;}
    private Map<Id, RecordType> criteriaRecordTypeMap{get;set;}
    private Map<String, RecordType> answerRecordTypeMap{get;set;}
    
    private RecordType booleanRecordType{get;set;}
    
    private final String BOOLEAN_CRITERIA = 'ASI_CRM_TW_CriteriaFactory.BooleanCriteria';
    private final String INTEGERINPUT_CRITERIA = 'ASI_CRM_TW_CriteriaFactory.IntegerInputCriteria';
    private final String CURRENCYINPUT_CRITERIA = 'ASI_CRM_TW_CriteriaFactory.CurrencyInputCriteria';
    private final String PICKLIST_CRITERIA = 'ASI_CRM_TW_CriteriaFactory.PicklistCriteria';
    private final String TEXTINPUT_CRITERIA = 'ASI_CRM_TW_CriteriaFactory.TextInputCriteria';
    
    private final String BOOLEAN_CRITERIA_DEVNAME = 'ASI_CRM_TW_Boolean';
    private final String INTEGERINPUT_CRITERIA_DEVNAME = 'ASI_CRM_TW_Number_Input';
    private final String CURRENCYINPUT_CRITERIA_DEVNAME = 'ASI_CRM_TW_Currency_Input';
    private final String PICKLIST_CRITERIA_DEVNAME = 'ASI_CRM_TW_Picklist';
    private final String TEXTINPUT_CRITERIA_DEVNAME = 'ASI_CRM_TW_Text_Input';
    
    //List of criteria thresholds without weight calculation
    private Set<Id> noAnswerCriteria{get;set;}
    
    public ASI_CRM_TW_CriteriaManager(){
        //Instantiate criteria record type maps and no answer set
        noAnswerCriteria = new Set<Id>();
        criteriaTypeMap = new Map<Id, String> ();
        criteriaRecordTypeMap = new Map<Id, RecordType>();
        
        criteriaRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SobjectType='ASI_CRM_Criteria_Threshold__c'];

        for(RecordType recordType: criteriaRecordTypes){
            //Criteria Type Map: Key-Record Type ID, Value:Factory class name
            if (recordType.DeveloperName.equalsIgnoreCase(BOOLEAN_CRITERIA_DEVNAME)){
                criteriaTypeMap.put(recordType.Id,BOOLEAN_CRITERIA);
                booleanRecordType = recordType;
            }
            else if (recordType.DeveloperName.equalsIgnoreCase(INTEGERINPUT_CRITERIA_DEVNAME)) criteriaTypeMap.put(recordType.Id,INTEGERINPUT_CRITERIA);
            else if (recordType.DeveloperName.equalsIgnoreCase(CURRENCYINPUT_CRITERIA_DEVNAME)) criteriaTypeMap.put(recordType.Id,CURRENCYINPUT_CRITERIA);
            else if (recordType.DeveloperName.equalsIgnoreCase(PICKLIST_CRITERIA_DEVNAME)) criteriaTypeMap.put(recordType.Id,PICKLIST_CRITERIA);
            else if (recordType.DeveloperName.equalsIgnoreCase(TEXTINPUT_CRITERIA_DEVNAME)) {
                criteriaTypeMap.put(recordType.Id,TEXTINPUT_CRITERIA);
                noAnswerCriteria.add(recordType.Id);
            }
            
            //Criteria Record Type Map: Key-Record Type ID, Value:Record Type Instance
            criteriaRecordTypeMap.put(recordType.Id, recordType);
        }
        //Instantiate answer record type map
        //Criteria Answer Record Type: Key-Developer Name, Value: Record type
        answerRecordTypeMap = new Map<String, RecordType>();
        List<RecordType> answerRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType 
                                                WHERE SobjectType='ASI_CRM_Criteria_Answer__c'];
        for (RecordType recordType: answerRecordTypes){
            answerRecordTypeMap.put(recordType.DeveloperName, recordType);
        }
    }
    
    public ASI_CRM_TW_CriteriaFactory.ICriteriaInterface newClassInstance(Id recordTypeId){
        String className = null;

        if(criteriaTypeMap.containsKey(recordTypeId)){
            className = criteriaTypeMap.get(recordTypeId);
            System.debug('Flag- ClassName:' + className);
            
            Type t = Type.forName(className);
            System.debug('Flag- TypeName:' + t);
            
            return (ASI_CRM_TW_CriteriaFactory.ICriteriaInterface) t.newInstance();
        }
        return null;
    }
    
    public Id getDefaultRecordType(){
        return booleanRecordType.Id;
    }
    
    public Id getAnswerRecordType (Id criteriaRecordTypeId){
        String developerName = null;
        Id answerRecordTypeId = null;
        
        if (criteriaRecordTypeMap.containsKey(criteriaRecordTypeId)){
            developerName = criteriaRecordTypeMap.get(criteriaRecordTypeId).DeveloperName;
            if (answerRecordTypeMap.containsKey(developerName)) 
                answerRecordTypeId = answerRecordTypeMap.get(developerName).Id;
        }
        
        return answerRecordTypeId;
    }
    
    public List<SelectOption> getCriteriaRecordTypes(){
        List<SelectOption> options = new List<SelectOption>();
        for (List<RecordType> rts : [SELECT ID, name FROM RecordType WHERE SObjectType = 'ASI_CRM_Criteria_Threshold__c' ORDER BY name]) {
            for (RecordType rt : rts) {
                options.add(new SelectOption(rt.ID, rt.Name));
            } 
        }
        return options;
    }
    
    public Boolean hasCriteriaAnswer(Id recordTypeId){
        if (noAnswerCriteria.contains(recordTypeId)){
            return false;
        }
        return true;
    }
    
    public Id returnBooleanRecordTypeId(){
        return booleanRecordType.Id;
    }
}