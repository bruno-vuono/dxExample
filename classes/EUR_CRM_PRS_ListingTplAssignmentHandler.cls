/*********************************************************************************
 * Name: EUR_CRM_SE_AssignTemplateToAccountHandlr
 * Description: Automatically assign listing template to an Account when create and update
 *
 * Version History
 * Date         Developer   Comments
 * ----------   ----------  -------------------------------------------------------     
 *  18-4-2017  Jay Chau     Created. Replace EUR_CRM_SE_AssignTemplateToAccountHandlr and EUR_CRM_NL_AssignTemplateToAccountHandlr
*********************************************************************************/

public with sharing class EUR_CRM_PRS_ListingTplAssignmentHandler  extends EUR_CRM_TriggerAbstract{

   
    public EUR_CRM_PRS_ListingTplAssignmentHandler() {
        super('EUR_CRM_PRS_ListingTplAssignmentHandler');
    }

    private static Set<String> validateRecordTypes = new Set<String>{
        'EUR_NL_On_Trade',
        'EUR_SE_On_Trade',
        'EUR_SE_Wholesaler',
        'EUR_BE_On_Trade' 
    };

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(validateRecordTypes);
            
            return TRt;
        }private set;
    }

    private Map<String,String> accountTemplateCriteriaMapping = new Map<String,String>{'EUR_NL_On_Trade'=>'EUR_NL_On_Trade_Template_Criteria',
    																				   'EUR_SE_On_Trade'=>'EUR_SE_On_Trade_Template_Criteria',
                                                                                       'EUR_SE_Wholesaler'=>'EUR_SE_On_Trade_Template_Criteria',
                                                                                       'EUR_BE_On_Trade'=>'EUR_BE_On_Trade_Template_Criteria' };
    private Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
    private Set<String> targetTemplateRecordType = new Set<String>();

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
    Set<String> groupOutletType = new Set<String>();
    Set<String> outletType = new Set<String>();
    Set<String> imageLevel = new Set<String>();
    Set<String> volumePotential = new Set<String>();
    
    List<EUR_CRM_Account__c> validAccount = new List<EUR_CRM_Account__c>();
    List<EUR_CRM_Account__c> accountList = (List<EUR_CRM_Account__c>) sObjList;

    List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');    
        
        for(Recordtype rt : accountRecordTypes){
            accountRecordTypesMap.put(rt.id,rt);
            }

        for (EUR_CRM_Account__c acc : accountList){
            if (validateRecordTypes.contains(accountRecordTypesMap.get(acc.recordtypeId).developername) && (tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE)){
                validAccount.add(acc);
                groupOutletType.add(acc.EUR_CRM_PRS_Group_Outlet_Type__c);
                outletType.add(acc.EUR_CRM_PRS_Outlet_Type__c);
                imageLevel.add(acc.EUR_CRM_PRS_Image_Level__c);
                volumePotential.add(acc.EUR_CRM_PRS_Volume_Potential__c);
                targetTemplateRecordType.add(accountTemplateCriteriaMapping.get(accountRecordTypesMap.get(acc.recordtypeId).DeveloperName));
            }
        }

        if (validAccount.size() > 0){
            assignTemplate(validAccount, groupOutletType, outletType, imageLevel, volumePotential);
        }
    }

    private void assignTemplate(List<EUR_CRM_Account__c> validAccount, Set<String> groupOutletType, Set<String> outletType, Set<String> imageLevel, Set<String> volumePotential){
        List<EUR_CRM_JB_Template_Criteria__c> criteriaTemplates = new List<EUR_CRM_JB_Template_Criteria__c>();
        Map<String, String> criteriaTemplateMap = new Map<String, String>();
        

        criteriaTemplates = [SELECT Name,EUR_JB_Template__c, EUR_CRM_PRS_Group_Outlet_Type__c, EUR_CRM_PRS_Group_Outlet_Type_Name__c,
                                EUR_CRM_PRS_Outlet_Type__c, EUR_CRM_PRS_Outlet_Type_Name__c, 
                                EUR_CRM_PRS_Seg_Aspect_IL__c,EUR_CRM_PRS_Segmentation_IL_Aspect_Name__c, 
                                EUR_CRM_PRS_Seg_Aspect_VP__c, EUR_CRM_PRS_Segmentation_VP_Aspect_Name__c,EUR_JB_Active__c
                                FROM EUR_CRM_JB_Template_Criteria__c 
                                WHERE EUR_CRM_PRS_Group_Outlet_Type__c IN: groupOutletType 
                                    AND EUR_CRM_PRS_Outlet_Type__c IN: outletType 
                                    AND EUR_CRM_PRS_Seg_Aspect_IL__c IN: imageLevel 
                                    AND EUR_CRM_PRS_Seg_Aspect_VP__c IN: volumePotential AND EUR_JB_Active__c = true
                                    AND RecordTYpe.DeveloperName IN : targetTemplateRecordType];

        for (EUR_CRM_JB_Template_Criteria__c template : criteriaTemplates){
        criteriaTemplateMap.put((String)template.EUR_CRM_PRS_Group_Outlet_Type__c
                                +(String)template.EUR_CRM_PRS_Outlet_Type__c
                                +(String)template.EUR_CRM_PRS_Seg_Aspect_IL__c
                                +(String)template.EUR_CRM_PRS_Seg_Aspect_VP__c,(String)template.EUR_JB_Template__c);
        }

        for (EUR_CRM_Account__c acc : validAccount){
            String accPros = (String)acc.EUR_CRM_PRS_Group_Outlet_Type__c
                            +(String)acc.EUR_CRM_PRS_Outlet_Type__c
                            +(String)acc.EUR_CRM_PRS_Image_Level__c
                            +(String)acc.EUR_CRM_PRS_Volume_Potential__c;

            if (criteriaTemplateMap.containsKey(accPros)){
                acc.EUR_CRM_Listing_Template__c = criteriaTemplateMap.get(accPros);
            }
        }
    }
}