public with sharing class EUR_CRM_TemplateAssignmentHandler extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_TemplateAssignmentHandler(){
        super('EUR_CRM_TemplateAssignmentHandler');
    }
    
    /*  //TODO CHECK FILTER: For all JB, UK on trade customer record, if the territory field is empty
    *   Automatically assign the template record based on the Account segmentation details
    */
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        Set<String> groupOutletTypeSet = new Set<String>();
        Set<String> outletTypeSet = new Set<String>();
        Set<String> imageLevelSet = new Set<String>();
        Set<String> volumePotentialSet = new Set<String>();
        Set<Id> taxonomySet = new Set<Id>(); 
        
        List<EUR_CRM_Account__c> acctTaxonomyUpdate = new List<EUR_CRM_Account__c>();
        List<EUR_CRM_Account__c> acctSegmentationUpdate = new List<EUR_CRM_Account__c>();
        
        List<EUR_CRM_Account__c> acctlist = (List<EUR_CRM_Account__c>) sObjList;
        
        //Init variables
        if(tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE){
            for(EUR_CRM_Account__c acct : acctlist){
                //Include account with complete segmentation details or JB Taxonomy
                //TODO: Consider report type
                if(acct.EUR_CRM_Group_Outlet_Type__c!=null && acct.EUR_CRM_Outlet_Type__c!=null && acct.EUR_CRM_Volume_Potential__c!=null && acct.EUR_CRM_Image_Level__c!=null){
                    //Add to Segmentation details set
                    groupOutletTypeSet.add(acct.EUR_CRM_Group_Outlet_Type__c);
                    outletTypeSet.add(acct.EUR_CRM_Outlet_Type__c);
                    imageLevelSet.add(acct.EUR_CRM_Image_Level__c);
                    volumePotentialSet.add(acct.EUR_CRM_Volume_Potential__c);
                    //Add to map
                    acctSegmentationUpdate.add(acct);
                }
                else if(acct.EUR_JB_Customer_Taxonomy__c!= null){
                    //Add to taxonomy set
                    taxonomySet.add(acct.EUR_JB_Customer_Taxonomy__c);
                    //Add to map
                    acctTaxonomyUpdate.add(acct);
                }
            }
        }
        
        if(tAction == TriggerAction.BEFORE_INSERT){
            if(acctSegmentationUpdate.size()>0){
                assignTemplateViaSegmentation(acctSegmentationUpdate, 
                                        groupOutletTypeSet, outletTypeSet, 
                                        imageLevelSet, volumePotentialSet);
            }
            
            if(acctTaxonomyUpdate.size()>0){
                assignTemplateViaTaxonomy(acctTaxonomyUpdate, taxonomySet);
            }
        }
        
          if(tAction == TriggerAction.BEFORE_UPDATE){
                if(acctSegmentationUpdate.size()>0){
                    assignTemplateViaSegmentation(acctSegmentationUpdate, 
                                            groupOutletTypeSet, outletTypeSet, 
                                            imageLevelSet, volumePotentialSet);
                }
            
                if(acctTaxonomyUpdate.size()>0){
                    assignTemplateViaTaxonomy(acctTaxonomyUpdate, taxonomySet);
                }
            }
    
    }
    
    
    private void assignTemplateViaSegmentation(List<EUR_CRM_Account__c> acctSegmentationUpdate, 
                                        Set<String> groupOutletTypeSet, Set<String> outletTypeSet, 
                                        Set<String> imageLevelSet, Set<String> volumePotentialSet){
        //Retrieve Map of Template Criteria
        Map<Id, Recordtype> accountRecordTypeMap = EUR_CRM_AccountUtils.recordtypeMap;
        //Key:Concat of segmentation details
        Map<String, EUR_CRM_JB_Template_Criteria__c> templateCriteriaMap = new Map<String, EUR_CRM_JB_Template_Criteria__c>();
        
        for(EUR_CRM_JB_Template_Criteria__c tCriteria: [SELECT Id, EUR_JB_Active__c, EUR_JB_Template__r.EUR_CRM_Record_Type_Name__c,
                                                            EUR_JB_External_ID__c, EUR_JB_Group_Outlet_Type__c, EUR_JB_Image_Level__c, 
                                                            EUR_JB_Outlet_Type__c, EUR_JB_Template__c, EUR_JB_Volume_Potential__c
                                                            FROM EUR_CRM_JB_Template_Criteria__c
                                                            WHERE EUR_JB_Group_Outlet_Type__c IN: groupOutletTypeSet
                                                            AND EUR_JB_Outlet_Type__c IN:outletTypeSet
                                                            AND EUR_JB_Image_Level__c IN:imageLevelSet
                                                            AND EUR_JB_Volume_Potential__c IN:volumePotentialSet
                                                            AND EUR_JB_Active__c=true
                                                            LIMIT 49999]){
            
            String key = createKey(tCriteria.EUR_JB_Group_Outlet_Type__c,tCriteria.EUR_JB_Outlet_Type__c,
                                    tCriteria.EUR_JB_Image_Level__c,tCriteria.EUR_JB_Volume_Potential__c,
                                    tCriteria.EUR_JB_Template__r.EUR_CRM_Record_Type_Name__c);
            templateCriteriaMap.put(key, tCriteria);
        }
        //Iterate Account List to set value
        for(EUR_CRM_Account__c acct: acctSegmentationUpdate){
            if(accountRecordTypeMap.containsKey(acct.RecordTypeId)){
                String acctKey = createKey(acct.EUR_CRM_Group_Outlet_Type__c,acct.EUR_CRM_Outlet_Type__c,
                                        acct.EUR_CRM_Image_Level__c,acct.EUR_CRM_Volume_Potential__c,
                                        accountRecordTypeMap.get(acct.RecordTypeId).DeveloperName); 
                if (templateCriteriaMap.containsKey(acctKey)){
                    acct.EUR_JB_Default_Template__c = templateCriteriaMap.get(acctKey).EUR_JB_Template__c;
                }/*else{
                	acct.EUR_JB_Default_Template__c = null;
                }*/
            }
        }
    }
    
    private String createKey(String g, String o, String i, String v, String recordTypeName){
        return g+'-'+o+'-'+i+'-'+v + recordTypeName.substring(0,6);
    }
    
    private void assignTemplateViaTaxonomy(List<EUR_CRM_Account__c> acctTaxonomyUpdate, Set<Id> taxonomySet){
        //Customer Taxonomy contains Template lookup

        //Get Map of Customer Taxonomy
        Map<Id, EUR_CRM_Customer_Taxonomy__c> taxonomyMap = new Map<Id, EUR_CRM_Customer_Taxonomy__c>();
        
        for (EUR_CRM_Customer_Taxonomy__c taxonomy: [SELECT Id, EUR_JB_Template__c  
                                                    FROM EUR_CRM_Customer_Taxonomy__c 
                                                    WHERE Id IN: taxonomySet
                                                    AND EUR_JB_Template__c != null
                                                    LIMIT 49999]){
            taxonomyMap.put(taxonomy.Id, taxonomy);
        }
        //Assign Template to Account
        for (EUR_CRM_Account__c acct: acctTaxonomyUpdate){
            if (taxonomyMap.containsKey(acct.EUR_JB_Customer_Taxonomy__c)){
                acct.EUR_JB_Default_Template__c = taxonomyMap.get(acct.EUR_JB_Customer_Taxonomy__c).EUR_JB_Template__c;
            }else{
            	acct.EUR_JB_Default_Template__c = null;
            }
        }
    }
    
}