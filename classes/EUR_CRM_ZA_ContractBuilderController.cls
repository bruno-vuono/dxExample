public without sharing class EUR_CRM_ZA_ContractBuilderController extends EUR_CRM_PageControllerBase {
    
    private ApexPages.StandardController standardController {get;set;}
    private transient   List<String> contractFields = new List<String> {'EUR_CRM_Include_VAT__c','EUR_CRM_Contact__c', 'EUR_CRM_Account__c','EUR_CRM_Account__r.ownerid','EUR_CRM_Account__r.owner','EUR_CRM_Is_this_contract_material__c','EUR_CRM_Is_this_contract_profitable__c','RecordType.developername','EUR_CRM_Country_Code__c', 'EUR_CRM_Contract_Lumpsum_Amount__c'};
        public final String CONTRACT_LUMPSUM = 'Contract Lumpsum';
    public final String LISTING = 'Listing';
    public final String EXCLUSIVITY = 'Exclusivity';
    public final String HOUSE_POUR = 'House pour';
    public final String REBATE_STOCK_DEALS = 'Rebate Stock Deals';
    public final String STOCK_DEALS = 'Stock deals';
    public final String EVENTS= 'Events';
    public final String POS_MATERIAL = 'POS material';
    public final String UNIFORMS = 'Uniforms';
    public final String DRINKS_MENU = 'Drinks Menu';
    public final String BAR_STYLING = 'Bar Styling';
    public final String TRAININGS = 'Trainings';
    public final String DISPLAYS = 'Displays';
    public final String PROMOTIONS = 'Promotions';
    public final string PROFITABILTY = 'EUR_CRM_Profitability';
    public final string CONTRACT_MATERIAL = 'EUR_CRM_ContractMaterial';
    public final string EURADMINPROFILENAME = 'EUR System Admin';
    public Id EVENTS_MECHANIC_TYPE_ID {get; set;}
    
    public EUR_CRM_Contract__c contractObj{get; set;}
    public Map<String, MechanicTypeWrapper> mechanicTypeWrapperMap{get;set;}
    private transient  Map<String, EUR_CRM_Mechanic_Type__c> mechanicTypeMap; // key is English name 
    private transient  Map<id, EUR_CRM_Mechanic_Type__c> contractMechanicTypeMap; 
    private Map<id, EUR_CRM_Contract_Activity_Item__c > contractActivityItemMap; //key is mechanic type id
    private transient  Map<id, List<EUR_CRM_Contract_Product_Item__c>> contractProductItemMap; //key is contract activity item
    public String thousandSep {get;set;}
    public String decimalSep {get;set;}
    private List<EUR_CRM_Apex_Configuration__c> profitabilityThreshold;
    private List<EUR_CRM_Apex_Configuration__c> contractMaterialThreshold;
    // Add variable member to determine if the Contract is Outlet or Headquarter
    public boolean isContractHQ {get;set;}
    
    public Map<Id, EUR_CRM_Contract_Activity_Item__c> eventsContractActivityItemMap {get; set;} // Id is contract activity item Id
    
    private Map<String,String> mechanicProductMap = new Map<String,String>{
        LISTING =>'EUR_CRM_Brand_Quality__c',
            EXCLUSIVITY =>'EUR_CRM_Brand_Quality__c',
            HOUSE_POUR =>'EUR_CRM_Brand_Quality__c',
            REBATE_STOCK_DEALS=>'EUR_CRM_Brand_Quality__c',
            STOCK_DEALS=>'EUR_CRM_Brand_Quality__c',
            EVENTS =>'EUR_CRM_Brand__c',
            POS_MATERIAL =>'EUR_CRM_Brand__c',
            UNIFORMS=>'EUR_CRM_Brand__c',
            DRINKS_MENU=>'EUR_CRM_Brand__c',
            BAR_STYLING=>'EUR_CRM_Brand__c',
            TRAININGS=>'EUR_CRM_Brand__c',
            DISPLAYS=>'EUR_CRM_Brand__c',
            PROMOTIONS=>'EUR_CRM_Brand__c'
            };
                
                
                //constructor
                public EUR_CRM_ZA_ContractBuilderController(ApexPages.StandardController standardController){
                    this.standardController = standardController;
                    isContractHQ = false;
                    if(!test.isRunningTest())
                        this.standardController.addFields(contractFields);
                    if (String.isEmpty(this.standardController.getId())){
                        addMessage(ApexPages.Severity.ERROR, Label.EUR_CRM_MissingIdMessage);
                    }else{
                        contractObj = (EUR_CRM_Contract__c )standardController.getRecord();
                        if(Global_RecordTypeCache.getRt(contractObj.recordtypeID).developerName == 'EUR_ZA_Head_Office_Contract') {
                            isContractHQ = true;
                        }
                        initContractContent();
                    }  
                    thousandSep = EUR_CRM_FI_UtilClass.getThousandSep();
                    decimalSep = EUR_CRM_FI_UtilClass.getDecimalSep();
                    initThresholds();
                }
    public EUR_CRM_Account__c getContractAccount(){
        return [select ownerid, name from eur_crm_account__c where id = :contractObj.eur_crm_account__c];
    }
    
    void initThresholds(){
        profitabilityThreshold = new List<EUR_CRM_Apex_Configuration__c>( );
        contractMaterialThreshold = new List<EUR_CRM_Apex_Configuration__c>();
        for(EUR_CRM_Apex_Configuration__c config: [select EUR_CRM_Sub_Module__c, EUR_CRM_Text_Value__c, EUR_CRM_Decimal_Value__c from EUR_CRM_Apex_Configuration__c where
                                                   EUR_CRM_Module__c = 'EUR_CRM_ZA_ContractBuilder'
                                                   order by EUR_CRM_Sequence__c asc]){
                                                       if(config.EUR_CRM_Sub_Module__c == PROFITABILTY)
                                                           profitabilityThreshold.add(config);
                                                       if(config.EUR_CRM_Sub_Module__c == CONTRACT_MATERIAL)
                                                           contractMaterialThreshold.add(config);
                                                   } 
    }
    
    public String getProfitColor(){
        Decimal profit = contractObj.EUR_CRM_Is_this_contract_profitable__c;
        
        //Decimal profit = contractObj.EUR_CRM_Is_this_contract_material__c;
        String color = '#FF3333';
        //handle first element, value is < element element
        if(profitabilityThreshold == null || profitabilityThreshold.size() == 0)
            return color;
        EUR_CRM_Apex_Configuration__c config = profitabilityThreshold.get(0);
        if(profit == null || profit < config.EUR_CRM_Decimal_Value__c)
            return config.EUR_CRM_Text_Value__c;
        //handle 2nd to last element, value is >= element
        //default
        for(Integer i = 1; i < profitabilityThreshold.size(); i++){
            config = profitabilityThreshold.get(i);
            if(profit >= config.EUR_CRM_Decimal_Value__c)
                color = config.EUR_CRM_Text_Value__c;
        }
        return color;
    }
    
    public Boolean getIsCurrentUserApprover(){
        Set<Id> approvers = new Set<Id>();
        
        for(ProcessInstanceStep pStep : [select  OriginalActorId from ProcessInstanceStep where stepStatus not in ('Started', 'Submitted') 
                                         AND ProcessInstanceId in (select id from ProcessInstance where TargetObjectId = :contractObj.id)]){
                                             approvers.add(pStep.OriginalActorId);
                                         }
        return approvers.contains(UserInfo.getUserId());
    }
    
    /**
*   function: getHasDeactivatePermissionSet
*   Checks if the current user has 'EUR_ZA_Deactive_Contract' permission set assigned
*   Return: Boolean
**/
    public Boolean getHasDeactivatePermissionSet() {
        for(PermissionSetAssignment psa: [SELECT PermissionSetId
                                          FROM PermissionSetAssignment
                                          WHERE AssigneeId = :UserInfo.getUserId()
                                          AND PermissionSet.Name = 'EUR_ZA_Deactivate_Contract']) {
                                              
                                              return true;
                                          }
        
        Profile currentProfile = [select Id, Name from Profile where Id = :UserInfo.getProfileId()];
        if (currentProfile.Name == EURADMINPROFILENAME){
            return true;             
        }
        
        return false;
    }
    
    public void initContractContent(){
        mechanicTypeWrapperMap = new Map<String, MechanicTypeWrapper>();
        retrieveMechanicTypes(); // retrieve mechanic types
        //retrieveContractMechanics();
        retrieveContractActivityItems();
        retrieveContractProductItems();
        // retrieve contract line items
        selectableProductsByMechanicType = new Map<Id,List<SObject>>();
        
        for(EUR_CRM_Mechanic_Type__c mType: mechanicTypeMap.values()){
            //String key = mType.Mechanic_Type_Name_English__c;
            String key = mType.EUR_CRM_Mechanic_Type_Name_English__c;
            if(key == null)
                continue;
            String productObject = mechanicProductMap.get(key);
            MechanicTypeWrapper mTypeWrapper = new MechanicTypeWrapper(this,mType,contractActivityItemMap.get(mType.id), contractProductItemMap.get(mType.id),productObject); 
            mechanicTypeWrapperMap.put(key,mTypeWrapper); 
        }
        
        System.debug(mechanicTypeWrapperMap);
    }
    
    /**from Contract Class */
    
    private void retrieveMechanicTypes(){
        mechanicTypeMap = new  Map<String, EUR_CRM_Mechanic_Type__c>();        
        System.debug(contractObj.EUR_CRM_Country_Code__c);
        
        for (EUR_CRM_Mechanic_Type__c mechanic: [SELECT Id, Name, EUR_CRM_Country_Code__c,                                                 
                                                 EUR_CRM_Mechanic_Type_Name_English__c
                                                 FROM EUR_CRM_Mechanic_Type__c
                                                 WHERE EUR_CRM_Country_Code__c =: contractObj.EUR_CRM_Country_Code__c
                                                 LIMIT 49999]){
                                                     if(mechanic.EUR_CRM_Mechanic_Type_Name_English__c == 'Events') {
                                                         EVENTS_MECHANIC_TYPE_ID = mechanic.Id;
                                                     }
                                                     mechanicTypeMap.put(mechanic.EUR_CRM_Mechanic_Type_Name_English__c, mechanic);
                                                 }
        
        System.debug('Flag - Retrieve mechanicTypeMap:' + mechanicTypeMap); 
    }
    
    // TODO: Obsolete
    private Integer retrieveNumOfIncludedOutlets() {
        return [SELECT Count() FROM EUR_CRM_Account__c WHERE EUR_CRM_Parent_Account__c = :contractObj.EUR_CRM_Account__c];
    }
    
    private void retrieveContractActivityItems(){
        eventsContractActivityItemMap = new Map<Id, EUR_CRM_Contract_Activity_Item__c>();
        contractActivityItemMap = new  Map<Id, EUR_CRM_Contract_Activity_Item__c >();
        Integer numOfIncludedOutlets = retrieveNumOfIncludedOutlets();
        for (EUR_CRM_Contract_Activity_Item__c contractActivityItem: [SELECT Id, Name, EUR_CRM_Amount__c,                                                 
                                                                      EUR_CRM_Contract__c,                                                  
                                                                      EUR_CRM_Mechanic_Type__c,
                                                                      EUR_CRM_Mechanic_Type__r.name, EUR_CRM_Mechanic_Type__r.EUR_CRM_Mechanic_Type_Name_English__c,
                                                                      EUR_CRM_Name__c,
                                                                      EUR_CRM_Brand_Budget__c,
                                                                      EUR_CRM_Product_Items_Total__c,
                                                                      EUR_CRM_Lumpsum_Value__c,
                                                                      EUR_CRM_Payment_Term__c,
                                                                      EUR_CRM_Supplier_PR__c,
                                                                      EUR_CRM_Exclude_Budget_Deduction__c,
                                                                      EUR_CRM_Is_PR_Event__c,
                                                                      EUR_CRM_Start_Date__c,
                                                                      EUR_CRM_End_Date__c,
                                                                      EUR_CRM_Description__c
                                                                      FROM EUR_CRM_Contract_Activity_Item__c 
                                                                      WHERE EUR_CRM_Contract__c =: contractObj.id                                             
                                                                      LIMIT 49999]){
                                                                          if(contractActivityItem.EUR_CRM_Mechanic_Type__c == EVENTS_MECHANIC_TYPE_ID) {
                                                                              // put activity item in another map to be used later
                                                                              eventsContractActivityItemMap.put(contractActivityItem.Id, contractActivityItem);
                                                                          }
                                                                          
                                                                          contractActivityItemMap.put(contractActivityItem.EUR_CRM_Mechanic_Type__c, contractActivityItem);
                                                                      }
        
        System.debug('Flag - Retrieve contractActivityItemMap :' + contractActivityItemMap ); 
    }
    /*
Retrieve All Contract Products;
*/
    private void retrieveContractProductItems(){
        contractProductItemMap = new  Map<Id, List<EUR_CRM_Contract_Product_Item__c>>();      
        // TODO: Change retrieved fields according to the mechanic type  
        for (EUR_CRM_Contract_Product_Item__c productItem: [SELECT Id, Name,
                                                            EUR_CRM_Brand__c, EUR_CRM_Brand__r.name, EUR_CRM_Brand__r.EUR_CRM_Category__c, EUR_CRM_Brand__r.EUR_CRM_Category__r.Name,
                                                            EUR_CRM_Brand_Quality_Size__c, EUR_CRM_Brand_Quality_Size__r.name,
                                                            EUR_CRM_Brand_Quality__c, EUR_CRM_Brand_Quality__r.name, EUR_CRM_Brand_Quality__r.EUR_CRM_Category__c,
                                                            EUR_CRM_Contract_Activity_Item__c, EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Mechanic_Type__c,
                                                            EUR_CRM_Quantity__c,
                                                            EUR_CRM_Unit__c,
                                                            EUR_CRM_Discount_Rate__c,
                                                            EUR_CRM_Brand_Budget__c,
                                                            EUR_CRM_Amount__c,
                                                            EUR_CRM_Marketing_Amount__c,
                                                            EUR_CRM_Description__c,
                                                            EUR_CRM_No_of_People__c,
                                                            EUR_CRM_Exclude_Budget_Deduction__c,
                                                            EUR_CRM_Training_Name__c,
                                                            EUR_CRM_Stock_Deal_Mechanic__c,
                                                            EUR_CRM_Stock_Deal_Mechanic__r.EUR_CRM_Stock_Deal_Name__c 
                                                            FROM EUR_CRM_Contract_Product_Item__c
                                                            WHERE EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Contract__c =: contractObj.id                                             
                                                            LIMIT 49999]){
                                                                String key = productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Mechanic_Type__c;
                                                                if(contractProductItemMap.get(key) == null) {
                                                                    contractProductItemMap.put(key, new List<EUR_CRM_Contract_Product_Item__c>());                
                                                                }
                                                                contractProductItemMap.get(key).add(productItem);
                                                            }
        // addMessage(ApexPages.Severity.ERROR,  'Flag - Retrieve contractProductItemMap:' + contractProductItemMap);
        System.debug('Flag - Retrieve contractProductItemMap:' + contractProductItemMap); 
    }
    
    public Decimal getEventsActivitiesTotal() {
        Decimal eventsTotal = 0.00;
        eventsTotal.setScale(2);
        
        for(EUR_CRM_Contract_Activity_Item__c cai: eventsContractActivityItemMap.values()) {
            eventsTotal += cai.EUR_CRM_Product_Items_Total__c;
        }
        
        return eventsTotal;
    }
    
    private transient Map<Id,List<SObject>> selectableProductsByMechanicType;
    
    /*
inner wrapper class
*/
    public class MechanicTypeWrapper{
        
        public EUR_CRM_Mechanic_Type__c mechanicType{get;set;}
        public String mechanicTypeName {get;set;}
        public String mechanicTypeEnglishName {get;set;}
        public Id mechanicTypeId {get;set;} 
        
        public EUR_CRM_Contract_Activity_Item__c contractActivityItem {get;set;}
        public List<EUR_CRM_Contract_Product_Item__c> allContractProductItems {get;set;}
        private List<EUR_CRM_Contract_Mechanic__c> allContractMechanics ;
        //public transient List<Sobject> allProducts {get;set;}
        private EUR_CRM_ZA_ContractBuilderController con;
        private Set<Id> existingProducts;
        public List<EUR_CRM_Contract_Product_Item__c> deleteProducts {get;set;}
        private String productObject; //quality, size, sku?
        public String productAPIName {get;set;}
        
        public Decimal marketAmountTotal {get;set;}
        
        public Map<Id, List<EUR_CRM_Contract_Product_Item__c>> eventsContractProductItemMap {get; set;} // Id is contract activity item Id
        
        public MechanicTypeWrapper(EUR_CRM_ZA_ContractBuilderController con, EUR_CRM_Mechanic_Type__c mechanicType,EUR_CRM_Contract_Activity_Item__c contractActivityItem, List<EUR_CRM_Contract_Product_Item__c> contractProductItems, String productAPIName ){
            this.mechanicType = mechanicType;
            this.mechanicTypeName = mechanicType.Name;
            this.mechanicTypeId = mechanicType.Id; 
            this.mechanicTypeEnglishName = mechanicType.EUR_CRM_Mechanic_Type_Name_English__c; 
            this.allContractProductItems = contractProductItems;
            // this.allContractMechanics = contractMechanics;
            this.productAPIName = productAPIName == null ? 'EUR_CRM_Brand_Quality__c' : productAPIName;
            this.con = con;
            this.productObject = productObject;
            this.marketAmountTotal = 0;
            
            existingProducts = new Set<Id>();
            
            if(contractProductItems != null && productAPIName != null)
                for(EUR_CRM_Contract_Product_Item__c p : contractProductItems){
                    existingProducts.add((Id)p.get(productAPIName));
                }
            existingProducts.remove(null);
            if(contractActivityItem == null){
                this.contractActivityItem = new EUR_CRM_Contract_Activity_Item__c(
                    EUR_CRM_Contract__c = con.contractObj.id,
                    EUR_CRM_Mechanic_Type__c = mechanicType.id);
            }else{
                this.contractActivityItem = contractActivityItem;
            }
            
            
            if(mechanicTypeEnglishName == 'EVENTS' && allContractProductItems != null) {
                setEventsMap();
            }
            
            if(contractProductItems != null) {
                for(EUR_CRM_Contract_Product_Item__c productItem : contractProductItems) {
                    marketAmountTotal += productItem.EUR_CRM_Marketing_Amount__c != null ? productItem.EUR_CRM_Marketing_Amount__c : 0;
                }
            }
        }
        
        private void setEventsMap() {
            eventsContractProductItemMap = new Map<Id, List<EUR_CRM_Contract_Product_Item__c>>();
            
            for(EUR_CRM_Contract_Product_Item__c c: allContractProductItems) {
                if(eventsContractProductItemMap.get(c.EUR_CRM_Contract_Activity_Item__c) != null) {
                    // A list containing product items related to a particular event activity already exist
                    // Add to that list
                    eventsContractProductItemMap.get(c.EUR_CRM_Contract_Activity_Item__c).add(c);
                } else {
                    // associated contract activity has no product items yet
                    // Instantiate a list of product items
                    eventsContractProductItemMap.put(c.EUR_CRM_Contract_Activity_Item__c, new List<EUR_CRM_Contract_Product_Item__c>{c});
                }
            }            
        }
        
        public String getProductName(){
            if( String.isEmpty( productAPIName))
                return '';
            Integer l = productAPIName.length() - 3;
            return productAPIName.substring(0,l) + '__r.Name';
        }
        public String getProductActiveFlag(){
            if( String.isEmpty( productAPIName))
                return '';
            Integer l = productAPIName.length() - 3;
            return productAPIName.substring(0,l) + '__r.EUR_CRM_Active__c';
        }
        public List<SOBject> getSelectableProducts(){
            List<SOBject> sProducts = new List<SOBject>();
            String countryCode = con.contractObj.EUR_CRM_Country_Code__c;
            Set<Id> existingProducts = this.existingProducts;
            Id mechanicTypeId = this.mechanicTypeId;
            String activeFlag  = getProductActiveFlag();
            String query = 'select EUR_CRM_Brand__c,  EUR_CRM_Brand_Quality__c, EUR_CRM_Brand_Quality_Size__c, EUR_CRM_SKU__c';
            if(activeFlag != '')
                query +=   ' , ' + activeFlag;
            query +=' from EUR_CRM_Contract_Mechanic__c where EUR_CRM_Country_Code__c =: countryCode';
            query += ' AND '+productAPIName + ' NOT IN : existingProducts';
            query += ' AND EUR_CRM_Mechanic__r.EUR_CRM_Mechanic_Type__c =:mechanicTypeId'; 
            if(activeFlag != '')
                query += ' AND '+activeFlag + ' = true';
            
            return Database.query(query); 
        }
        
        public List<EUR_CRM_Contract_Product_Item__c> getContractProductItems(){
            return allContractProductItems;
        }
        
        //determine if the mechanic has products or lumpsum value.
        public Boolean hasValue(){
            return (allContractProductItems != null && allContractProductItems.size() > 0) ||
                (contractActivityItem != null && contractActivityItem.EUR_CRM_Lumpsum_Value__c !=null 
                 && contractActivityItem.EUR_CRM_Lumpsum_Value__c > 0); 
        } 
        public Boolean getHasValue(){
            return hasValue();
        } 
        public Boolean getHasLumpSumValue(){
            return  (contractActivityItem != null && contractActivityItem.EUR_CRM_Lumpsum_Value__c !=null);
        } 
        
        public Boolean getHasVolumeValue(){ 
            Boolean hasVolume = false;
            if(allContractProductItems == null)
                return hasVolume;
            for(EUR_CRM_Contract_Product_Item__c prod:allContractProductItems){
                if(prod.EUR_CRM_Quantity__c != null && prod.EUR_CRM_Quantity__c > 0){
                    hasVolume = true;
                    break;
                }
            }
            return hasVolume;
        } 
        
    }
    
    //###############################################################################
    private void addMessage(ApexPages.Severity severity, String message){
        ApexPages.addMessage(new ApexPages.Message(severity, message));
    }
    
}