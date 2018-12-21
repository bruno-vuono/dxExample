public without sharing class EUR_CRM_FI_ContractBuilderController extends EUR_CRM_PageControllerBase {
        
    private ApexPages.StandardController standardController {get;set;}
    private transient   List<String> contractFields = new List<String> {'EUR_CRM_Include_VAT__c','EUR_CRM_Contact__c', 'EUR_CRM_Account__c','EUR_CRM_Account__r.ownerid','EUR_CRM_Account__r.owner','EUR_CRM_Is_this_contract_material__c','EUR_CRM_Is_this_contract_profitable__c','RecordType.developername','EUR_CRM_Country_Code__c'};
    public final String POURING_REFUND_SPIRITS = 'Pouring Refund Spirits';
    public final String POURING_REFUND_WINES = 'Pouring Refund Wines';
    public final String SELECTION_BRANDS_SPIRITS = 'Selection Brands Spirits';
    public final String SELECTION_BRANDS_WINES = 'Selection Brands Wines';
    public final String MARKETING_ACTIVITY_SPIRITS= 'Marketing Activity Spirits';
    public final String MARKETING_ACTIVITY_WINES = 'Marketing Activity Wines';
    public final String TRIPS = 'Trips';
    public final String EDUCATION = 'Education';
    public final String FREE_STOCK = 'Free stock';
    public final string PROFITABILTY = 'EUR_CRM_Profitability';
    public final string CONTRACT_MATERIAL = 'EUR_CRM_ContractMaterial';

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
    
    // String to store product name. Used in the page's actionfunction in order for it to be able to pass
    // argument to a javascript function.
    public String productName {get; set;}
    
    private Map<String,String> mechanicProductMap = new Map<String,String>{
        POURING_REFUND_SPIRITS =>'EUR_CRM_Brand_Quality_Size__c',
        POURING_REFUND_WINES =>'EUR_CRM_SKU__c',
        SELECTION_BRANDS_SPIRITS =>'EUR_CRM_Brand_Quality_Size__c',
        SELECTION_BRANDS_WINES=>'EUR_CRM_Brand__c',
        MARKETING_ACTIVITY_SPIRITS =>'EUR_CRM_Brand__c',
        MARKETING_ACTIVITY_WINES =>'EUR_CRM_Brand__c',
        TRIPS=>'EUR_CRM_Brand__c',
        EDUCATION=>'EUR_CRM_Brand__c',
        FREE_STOCK=>'EUR_CRM_Brand_Quality__c'
    };

    
    //constructor
    public EUR_CRM_FI_ContractBuilderController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        if(!test.isRunningTest())
            this.standardController.addFields(contractFields);
        if (String.isEmpty(this.standardController.getId())){
            addMessage(ApexPages.Severity.ERROR, Label.EUR_CRM_MissingIdMessage);
        }else{
            contractObj = (EUR_CRM_Contract__c )standardController.getRecord();
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
        profitabilityThreshold = new List<EUR_CRM_Apex_Configuration__c>();
        contractMaterialThreshold = new List<EUR_CRM_Apex_Configuration__c>();
        for(EUR_CRM_Apex_Configuration__c config: [select EUR_CRM_Sub_Module__c, EUR_CRM_Text_Value__c, EUR_CRM_Decimal_Value__c from EUR_CRM_Apex_Configuration__c where
        EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder'
        order by EUR_CRM_Sequence__c asc]){
            if(config.EUR_CRM_Sub_Module__c == PROFITABILTY)
                profitabilityThreshold.add(config);
            if(config.EUR_CRM_Sub_Module__c == CONTRACT_MATERIAL)
                contractMaterialThreshold.add(config);
        } 
    }
    public String getContractMaterialColor(){
        Decimal cm = contractObj.EUR_CRM_Is_this_contract_material__c;
        String color = '#FF3333';
        //handle first element, value is < element element
        if(contractMaterialThreshold == null || contractMaterialThreshold.size() == 0)
            return color;
        EUR_CRM_Apex_Configuration__c config = contractMaterialThreshold.get(0);
        if(cm == null || cm < config.EUR_CRM_Decimal_Value__c)
            return config.EUR_CRM_Text_Value__c;
        //handle 2nd to last element, value is >= element
         //default
        for(Integer i = 1; i < contractMaterialThreshold.size(); i++){
            config = contractMaterialThreshold.get(i);
            if(cm >= config.EUR_CRM_Decimal_Value__c)
                color = config.EUR_CRM_Text_Value__c;
        }
        return color;
    }
    public String getProfitColor(){
        Decimal profit = contractObj.EUR_CRM_Is_this_contract_profitable__c;
        /*
        if(profit == null || profit < 20){
            return '#FF3333';
        }else if(profit < 40){
            return  '#FFFF75';
        }else
            return '#00FF33';
        */

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
            MechanicTypeWrapper mTypeWrapper = new MechanicTypeWrapper(this,mType,contractActivityItemMap.get(mType.id), contractProductItemMap.get(mType.id),
             productObject  ); 
            mechanicTypeWrapperMap.put(key,mTypeWrapper); 
        }
    }

    /**from Contract Class */

    private void retrieveMechanicTypes(){
        mechanicTypeMap = new  Map<String, EUR_CRM_Mechanic_Type__c>();        
        for (EUR_CRM_Mechanic_Type__c mechanic: [SELECT Id, Name, EUR_CRM_Country_Code__c,                                                 
                                                EUR_CRM_Mechanic_Type_Name_English__c
                                                FROM EUR_CRM_Mechanic_Type__c
                                                WHERE EUR_CRM_Country_Code__c =: contractObj.EUR_CRM_Country_Code__c
                                             
                                                LIMIT 49999]){
            mechanicTypeMap.put(mechanic.EUR_CRM_Mechanic_Type_Name_English__c, mechanic);
        }
        
        System.debug('Flag - Retrieve mechanicTypeMap:' + mechanicTypeMap); 
    } 
    private void retrieveContractActivityItems(){
        contractActivityItemMap = new  Map<Id, EUR_CRM_Contract_Activity_Item__c >();        
        for (EUR_CRM_Contract_Activity_Item__c contractActivityItem: [SELECT Id, Name, EUR_CRM_Amount__c,                                                 
                                                EUR_CRM_Contract__c,                                                  
                                                 EUR_CRM_Mechanic_Type__c,
                                                EUR_CRM_Mechanic_Type__r.name, EUR_CRM_Mechanic_Type__r.EUR_CRM_Mechanic_Type_Name_English__c,
                                                EUR_CRM_Name__c,
                                                EUR_CRM_Product_Items_Total__c,
                                                EUR_CRM_Contract_Activity_Total__c, EUR_CRM_Product_Qty_Total__c
                                                ,EUR_CRM_Lumpsum_Value__c 
                                                FROM EUR_CRM_Contract_Activity_Item__c 
                                                WHERE EUR_CRM_Contract__c =: contractObj.id                                             
                                                LIMIT 49999]){
            contractActivityItemMap.put(contractActivityItem.EUR_CRM_Mechanic_Type__c, contractActivityItem);
        }
        
        System.debug('Flag - Retrieve contractActivityItemMap :' + contractActivityItemMap ); 
    }
    /*
        Retrieve All Contract Products;
    */
    private void retrieveContractProductItems(){
        contractProductItemMap = new  Map<Id, List<EUR_CRM_Contract_Product_Item__c>>();        
        for (EUR_CRM_Contract_Product_Item__c productItem: [SELECT Id, Name, EUR_CRM_Brand__c, EUR_CRM_Brand__r.name,
                                                EUR_CRM_Brand_Quality_Size__c ,EUR_CRM_Brand_Quality_Size__r.name,
                                                EUR_CRM_Brand_Quality__c,EUR_CRM_Brand_Quality__r.name, EUR_CRM_Contract_Activity_Item__c,
                                                EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Mechanic_Type__c,
                                                EUR_CRM_Quantity__c, 
                                                EUR_CRM_Amount_Spent__c,
                                                EUR_CRM_Marketing_Amount__c,
                                                EUR_CRM_Name_Reference__c,
                                                EUR_CRM_SKU__c, EUR_CRM_SKU__r.name  , EUR_CRM_Amount__c,    
                                                 //EUR_CRM_Contract_Event_Education_Name__r.name,
                                                 //EUR_CRM_Contract_Event_Education_Name__c,
                                                 //EUR_CRM_Contract_Event_Trip_Name__r.name,
                                                 //EUR_CRM_Contract_Event_Trip_Name__c,
                                                 EUR_CRM_Contract_Event__r.name,
                                                 EUR_CRM_Contract_Event__c,
                                                 EUR_CRM_No_of_People__c 
                                                FROM EUR_CRM_Contract_Product_Item__c
                                                WHERE EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Contract__c =: contractObj.id                                             
                                                LIMIT 49999]){
            String key = productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Mechanic_Type__c;
            if(contractProductItemMap.get(key) == null)
                contractProductItemMap.put(key, new List<EUR_CRM_Contract_Product_Item__c>());
            contractProductItemMap.get(key).add(productItem);
        }
        // addMessage(ApexPages.Severity.ERROR,  'Flag - Retrieve contractProductItemMap:' + contractProductItemMap);
        System.debug('Flag - Retrieve contractProductItemMap:' + contractProductItemMap); 
    }
    private transient Map<Id,List<SObject>> selectableProductsByMechanicType;
 
    public void addContractLineItem(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_mechanicTypeName = params.get('PARAM_MECHANIC_TYPE_NAME');
        Id param_contractMechanicId = (Id) params.get('PARAM_CONTRACT_MECHANIC_ID');
        Id param_productId = (Id) params.get('PARAM_PRODUCT_ID');
        MechanicTypeWrapper mtWrap =  mechanicTypeWrapperMap.get(param_mechanicTypeName);
        mtWrap.addProduct(param_productId); 
    }
    public void removeContractLineItem(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_mechanicTypeName = params.get('PARAM_MECHANIC_TYPE_NAME'); 
        Integer row_Index = Integer.valueOf(params.get('PARAM_ROW_NUMBER')); 
        Id param_productId = (Id) params.get('PARAM_PRODUCT_ID');
        MechanicTypeWrapper mtWrap =  mechanicTypeWrapperMap.get(param_mechanicTypeName);
        mtWrap.removeProduct(param_productId, row_Index); 
    }
    /*
    public PageReference resetMarketingPackageHandling(){  
       system.debug('### reset. Flag 1');
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_mechanicTypeName = params.get('PARAM_MECHANIC_TYPE_NAME');
       system.debug('### reset. Flag 2: ' + param_mechanicTypeName);
        MechanicTypeWrapper mtWrap =  mechanicTypeWrapperMap.get(param_mechanicTypeName);
       system.debug('### reset. Flag 2: mtWrap ' + mtWrap);
        if(mtWrap == null || mtWrap.contractActivityItem == null)
                return null;
        mtWrap.contractActivityItem.EUR_CRM_Lumpsum_Value__c = null; 
       system.debug('### reset. Flag 2');
        if(mtWrap.allContractProductItems != null){
            for(EUR_CRM_Contract_Product_Item__c prod:mtWrap.allContractProductItems){
                if(prod.id != null){
                    if(mtWrap.deleteProducts == null)
                        mtWrap.deleteProducts = new List<EUR_CRM_Contract_Product_Item__c>();
                    mtWrap.deleteProducts.add(prod);
                }
            }
            mtWrap.allContractProductItems.clear();
        }
        mtWrap.existingProducts.clear();
        return null;
     }
*/
    private Boolean validateInputs(){ 
        Set<String> pouring = new Set<String>{'Pouring Refund Spirits','Pouring Refund Wines'};
        Set<String> selection = new Set<String>{'Selection Brands Spirits','Selection Brands Wines'};
        Set<String> marketingAct = new Set<String>{'Marketing Activity Spirits','Marketing Activity Wines'};
        Set<String> marketingMisc = new Set<String>{'Trips','Education','Free Stock'};
        for(MechanicTypeWrapper mType : mechanicTypeWrapperMap.values()){
            String mechName = mType.mechanicTypeEnglishName;
            if(pouring.contains(mechName)){
                 system.debug('@@@ mechName: ' + mechName);
                if(mType.getContractProductItems() != null && mType.getContractProductItems().size() > 0){
                    system.debug('@@@ allContractProductItems: ' + mType.getContractProductItems());
                    for(EUR_CRM_Contract_Product_Item__c prod : mType.getContractProductItems()){
                        if(prod.EUR_CRM_Quantity__c == null || prod.EUR_CRM_Amount__c == null){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_Missing_Values );
                            break;
                        }
                        if(prod.EUR_CRM_Quantity__c <= 0  ){ 
                            addMessage(ApexPages.Severity.WARNING, mType.mechanicTypeName +': ' +  (Label.EUR_CRM_Invalid_Field_Value).replace(':','')  );
                            break;
                        }
                        else if(prod.EUR_CRM_Amount__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                            break;
                        }
                    }
                }
            }else if(selection.contains(mechName)){
                if(mType.allContractProductItems != null && mType.allContractProductItems.size() > 0){
                    for(EUR_CRM_Contract_Product_Item__c prod : mType.allContractProductItems){
                        if(prod.EUR_CRM_Quantity__c == null || prod.EUR_CRM_Amount__c == null){
                            addMessage(ApexPages.Severity.WARNING, mType.mechanicTypeName +': ' +  (Label.EUR_CRM_Missing_Values).replace(':','')  );
                            break;
                        }
                        if(prod.EUR_CRM_Quantity__c <= 0  ){
                            addMessage(ApexPages.Severity.WARNING, mType.mechanicTypeName +': ' +  (Label.EUR_CRM_Invalid_Field_Value).replace(':','')  );
                            break;
                        }
                        else if(prod.EUR_CRM_Amount__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                            break;
                        }
                    }
                }               
            }else if(marketingAct.contains(mechName)){ 
                    if(mType.allContractProductItems != null && mType.allContractProductItems.size() > 0){
                        for(EUR_CRM_Contract_Product_Item__c prod : mType.allContractProductItems){
                            if(prod.EUR_CRM_Marketing_Amount__c == null){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_Missing_Values );
                                break;
                            }
                        else if(prod.EUR_CRM_Marketing_Amount__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                            break;
                        }
                        }
                    }
                    if(mType.contractActivityItem != null && mType.contractActivityItem.EUR_CRM_Lumpsum_Value__c != null && mType.contractActivityItem.EUR_CRM_Lumpsum_Value__c < 0){
                           addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                        
                    }             
            }else if('Trips' == mechName){             
                if(mType.allContractProductItems != null && mType.allContractProductItems.size() > 0){
                    for(EUR_CRM_Contract_Product_Item__c prod : mType.allContractProductItems){
                        if(prod.EUR_CRM_Marketing_Amount__c == null || prod.EUR_CRM_Contract_Event__c == null || prod.EUR_CRM_No_of_People__c == null){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_Missing_Values );
                            break;
                        }
                        if(prod.EUR_CRM_No_of_People__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + (Label.EUR_CRM_Invalid_Field_Value).replace(':','') );
                                break;
                            }
                        else if(prod.EUR_CRM_Marketing_Amount__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                            break;
                        }
                    }
                }                   
            }else if('Education' == mechName){             
                if(mType.allContractProductItems != null && mType.allContractProductItems.size() > 0){
                    for(EUR_CRM_Contract_Product_Item__c prod : mType.allContractProductItems){
                        if(prod.EUR_CRM_Marketing_Amount__c == null || prod.EUR_CRM_Contract_Event__c == null  ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_Missing_Values );
                            break;
                        }
                        else if(prod.EUR_CRM_Marketing_Amount__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                            break;
                        }
                    }
                }                   
            }else if('Free Stock' == mechName){             
                if(mType.allContractProductItems != null && mType.allContractProductItems.size() > 0){
                    for(EUR_CRM_Contract_Product_Item__c prod : mType.allContractProductItems){
                        if(prod.EUR_CRM_Marketing_Amount__c == null ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_Missing_Values );
                            break;
                        }
                        else if(prod.EUR_CRM_Marketing_Amount__c < 0 ){
                            addMessage(ApexPages.Severity.WARNING,  mType.mechanicTypeName + ': ' + Label.EUR_CRM_NegativeCurrency );
                            break;
                        }
                    }
                }                   
            }
        }
        return !ApexPages.hasMessages(); 
    }
    public PageReference save(){
        quickSave();
        if(isValid){
            PageReference p = new PageReference('/'+contractObj.id);
            p.setRedirect(true);
            return p; //standardController.view();
        }else{
            return null;
        }
    }
    private Boolean isValid = false;
    public void quickSave(){ 
        try{
            List<EUR_CRM_Contract_Product_Item__c> upsertContractProductItems = new List<EUR_CRM_Contract_Product_Item__c>();
            List<EUR_CRM_Contract_Product_Item__c> deleteContractProductItems = new List<EUR_CRM_Contract_Product_Item__c>();
            List<EUR_CRM_Contract_Activity_Item__c> upsertContractActivityItems = new List<EUR_CRM_Contract_Activity_Item__c>();
            List<EUR_CRM_Contract_Activity_Item__c> deleteContractActivityItems = new List<EUR_CRM_Contract_Activity_Item__c>();
            //EUR_CRM_Missing_Values
            //insert contract activity item first
            isValid = validateInputs();
            if(!isValid)
                return ;

            Set<Id> noValue = new Set<Id>(); 
            for(MechanicTypeWrapper mType : mechanicTypeWrapperMap.values()){
                if(!mType.hasValue()){
                    if(mType.contractActivityItem != null && mType.contractActivityItem.id != null){
                        deleteContractActivityItems.add(mType.contractActivityItem );
                        noValue.add(mType.mechanicTypeId);
                    }
                    continue;
                }
                if(mType.contractActivityItem != null)
                    upsertContractActivityItems.add(mType.contractActivityItem);
            }
            delete deleteContractActivityItems;
            upsert upsertContractActivityItems;
            //update the contract product items with contract activity items
            for(MechanicTypeWrapper mType : mechanicTypeWrapperMap.values()){
                if(mType.contractActivityItem == null)
                    continue;
                if(mType.allContractProductItems != null && mType.allContractProductItems.size() > 0){
                    for(EUR_CRM_Contract_Product_Item__c p : mType.allContractProductItems){
                        if(p.EUR_CRM_Contract_Activity_Item__c == null){
                            p.EUR_CRM_Contract_Activity_Item__c = mType.contractActivityItem.id;
                        }
                    }
                    upsertContractProductItems.addAll(mType.allContractProductItems);
                }
                if(!noValue.contains(mType.mechanicTypeId) && mType.deleteProducts != null && mType.deleteProducts.size() > 0){
                    deleteContractProductItems.addAll(mType.deleteProducts);
                }
            }
            delete deleteContractProductItems;
            upsert upsertContractProductItems;
            system.debug('@@@ upsertContractProductItems: ' +  upsertContractProductItems);
            calculateProfit();
            //contractObj.EUR_CRM_Is_Calculate_Profit__c = true;
            update contractObj;
            system.debug('@@@ contractObj: ' +  contractObj);

            for(MechanicTypeWrapper mType : mechanicTypeWrapperMap.values()){ 
                if(!noValue.contains(mType.mechanicTypeId) && mType.deleteProducts != null && mType.deleteProducts.size() > 0){
                     mType.deleteProducts.clear();
                }
            }
        }catch(Exception e){
             addMessage(ApexPages.Severity.Error,  Label.EUR_CRM_SaveError);
             system.debug('@@@ EUR_CRM_SaveError: ' + e);
             isValid = false;
        } 
    }
    

 
    private void calculateProfit(){   
        Set<String> PROFIT_GROUP = new Set<String>{POURING_REFUND_SPIRITS,POURING_REFUND_WINES,SELECTION_BRANDS_SPIRITS,SELECTION_BRANDS_WINES};
        Set<String> MARKETING_GROUP = new Set<String>{MARKETING_ACTIVITY_SPIRITS,MARKETING_ACTIVITY_WINES,TRIPS,FREE_STOCK  };

        system.debug('@@@ calculateProfit: ' );
        Map<Id,Decimal> productCM = new Map<Id,Decimal>();
        Decimal totalCM = 0;
        Decimal totalCMRetro = 0;
        Decimal totalLumpSum = 0;
        Set<id> skuCm = new Set<id>();
        Set<id> brandCm = new Set<id>();
        Set<id> bqsCm = new Set<id>();

        for(String key : mechanicTypeWrapperMap.keySet()){
            MechanicTypeWrapper mechType = mechanicTypeWrapperMap.get(key);
            if(PROFIT_GROUP.contains(key)){
                if(mechType.allContractProductItems != null){ 
                        if(key == POURING_REFUND_SPIRITS || key == SELECTION_BRANDS_SPIRITS){
                            bqsCm.addAll(mechType.existingProducts);
                        }else if(key == POURING_REFUND_WINES){
                            skuCm.addAll(mechType.existingProducts);
                        }else if(key == SELECTION_BRANDS_WINES){
                            brandCm.addAll(mechType.existingProducts);
                        } 
                }
            }else if(MARKETING_GROUP.contains(key)){
                 system.debug('@@@ MARKETING_GROUP: ' );
              EUR_CRM_Contract_Activity_Item__c contractActivityItem = mechType.contractActivityItem;
                 system.debug('@@@ contractActivityItem: ' + contractActivityItem);
              if(contractActivityItem != null && contractActivityItem.EUR_CRM_Lumpsum_Value__c != null){
                    totalLumpSum += contractActivityItem.EUR_CRM_Lumpsum_Value__c;
              }
              if(mechType.allContractProductItems != null ){
                for(EUR_CRM_Contract_Product_Item__c prod: mechType.allContractProductItems){
                    totalLumpSum += prod.EUR_CRM_Marketing_Amount__c == null ? 0 : prod.EUR_CRM_Marketing_Amount__c;
                }
              }
            }
        }
        if(skuCm.size() >0)
        for(EUR_CRM_SKU__c prod : [select id,EUR_CRM_Contributive_Margin_SKU__c from EUR_CRM_SKU__c where id in: skuCm]){
            productCM.put(prod.id, prod.EUR_CRM_Contributive_Margin_SKU__c);
        }
        if(brandCm.size() >0)
        for(EUR_CRM_Brand__c prod : [select id,EUR_CRM_Contributive_Margin_Brand__c from EUR_CRM_Brand__c where id in: brandCm]){
            productCM.put(prod.id, prod.EUR_CRM_Contributive_Margin_Brand__c);
        }
        if(bqsCm.size() >0)
        for(EUR_CRM_Size__c prod : [select id,EUR_CRM_Contributive_Margin_BQS__c from EUR_CRM_Size__c where id in: bqsCm]){
            productCM.put(prod.id, prod.EUR_CRM_Contributive_Margin_BQS__c);
        }
        //
        system.debug('### bqsCm: ' + bqsCm);
        system.debug('### brandCm: ' + brandCm);
        system.debug('### skuCm: ' + skuCm);
        system.debug('### productCM: ' + productCM);
        for(String key : mechanicTypeWrapperMap.keySet()){
            MechanicTypeWrapper mechType = mechanicTypeWrapperMap.get(key);
            if(PROFIT_GROUP.contains(key)){
                if(mechType.allContractProductItems != null){ 
                    for(EUR_CRM_Contract_Product_Item__c prod: mechType.allContractProductItems){
                        Id productId = (id) prod.get(mechType.productAPIName);
                        system.debug('### productId: ' + productId);
                        Decimal cm = productCM.get(productId) == null ? 0 : productCM.get(productId);
                        cm = cm.setScale(2);
                        Decimal volume = prod.EUR_CRM_Quantity__c == null ? 0 : prod.EUR_CRM_Quantity__c;
                        Decimal retro = prod.EUR_CRM_Amount__c == null ? 0 : prod.EUR_CRM_Amount__c; 
                        totalCM += (cm * volume);
                        totalCMRetro += (retro * volume);
                    }
                }
            } 
        }

        //
        system.debug('### totalCM: ' + totalCM);
        system.debug('### totalCMRetro: ' + totalCMRetro);
        system.debug('### totalLumpSum: ' + totalLumpSum);
        Decimal contractMaterial = totalCM - (totalLumpSum + totalCMRetro);
        contractObj.EUR_CRM_Is_this_contract_material__c = contractMaterial;
        contractObj.EUR_CRM_Is_this_contract_profitable__c = totalCM == 0 ? 0 : (contractMaterial/totalCM) * 100;

    } 

    public class EduTripProductWrapper{
        Id productId;
        Id mechanicTypeId;
        String productAPIName;
        public List<EUR_CRM_Contract_Event__c> contractEvents {get;set;} 
        public EduTripProductWrapper(Id productId,Id mechanicTypeId,
            String productAPIName, List<EUR_CRM_Contract_Event__c> contractEvents){
            this.productId = productId;
            this.mechanicTypeId = mechanicTypeId;
            this.productAPIName = productAPIName;
            this.contractEvents = contractEvents;
        }
        public List<SelectOption> getContractEventOptions(){ 
            List<SelectOption> s = new List<SelectOption>();
            if(contractEvents == null)
                contractEvents = retrieveContractEvents();
            for(EUR_CRM_Contract_Event__c cEvent: contractEvents){
                s.add(new SelectOption(cEvent.id,cEvent.name));
            }
            return s;
        }

        private List<EUR_CRM_Contract_Event__c> retrieveContractEvents(){
                List<EUR_CRM_Contract_Event__c> cEvents = new List<EUR_CRM_Contract_Event__c>();
                String productId = (String) this.productId;
                String mechTypeId = this.mechanicTypeId;
                String query = 'select id from EUR_CRM_Contract_Mechanic__c where ';
                query +=  productAPIName + ' =: productId';
                query += ' AND EUR_CRM_Mechanic__r.EUR_CRM_Mechanic_Type__c =:mechTypeId';

                String query2 = 'select EUR_CRM_Contract_Event__c, EUR_CRM_Contract_Event__r.Name, EUR_CRM_Contract_Event__r.id from EUR_CRM_Contract_Event_To_Prod_Mapping__c ';
                        query2 += ' where EUR_CRM_Contract_Mechanic__c in (' + query + ') order by EUR_CRM_Contract_Event__r.Name asc';
               // List<EUR_CRM_Contract_Mechanic__c> contractMechanics = (List<EUR_CRM_Contract_Mechanic__c>) Database.query(query);
                List<EUR_CRM_Contract_Event_To_Prod_Mapping__c> cEventProdMapping = (List<EUR_CRM_Contract_Event_To_Prod_Mapping__c>) Database.query(query2);
                system.debug('@@ cEventProdMapping: ' + cEventProdMapping);
                for(EUR_CRM_Contract_Event_To_Prod_Mapping__c mapping : cEventProdMapping){
                    cEvents.add((EUR_CRM_Contract_Event__c) mapping.getSObject('EUR_CRM_Contract_Event__r'));
                }
               // select EUR_CRM_Contract_Event__c, EUR_CRM_Contract_Event__r.Name, EUR_CRM_Contract_Event__r.id from EUR_CRM_Contract_Event_To_Prod_Mapping__c
                return cEvents;
        }
    }
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
        private EUR_CRM_FI_ContractBuilderController con;
        private Set<Id> existingProducts;
        public List<EUR_CRM_Contract_Product_Item__c> deleteProducts {get;set;}
        private String productObject; //quality, size, sku?
        public String productAPIName {get;set;}
 
        public Map<String, EduTripProductWrapper> productContractEventMap {get;set;} 

        public MechanicTypeWrapper(EUR_CRM_FI_ContractBuilderController con, EUR_CRM_Mechanic_Type__c mechanicType,EUR_CRM_Contract_Activity_Item__c contractActivityItem, List<EUR_CRM_Contract_Product_Item__c> contractProductItems,
         String productAPIName ){
            this.mechanicType = mechanicType;
            this.mechanicTypeName = mechanicType.Name;
            this.mechanicTypeId = mechanicType.Id; 
            this.mechanicTypeEnglishName = mechanicType.EUR_CRM_Mechanic_Type_Name_English__c; 
            this.allContractProductItems = contractProductItems;
           // this.allContractMechanics = contractMechanics;
            this.productAPIName = productAPIName == null ? 'EUR_CRM_Brand_Quality__c' : productAPIName;
            this.con = con;
            this.productObject = productObject;
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
            if(mechanicTypeEnglishName == 'Trips' || mechanicTypeEnglishName == 'Education'){ 
                retrieveExistingContractEvents(); 
            } else if(mechanicTypeEnglishName == con.POURING_REFUND_SPIRITS ||
                mechanicTypeEnglishName == con.SELECTION_BRANDS_SPIRITS ||
                mechanicTypeEnglishName == con.POURING_REFUND_WINES ||
                mechanicTypeEnglishName == con.SELECTION_BRANDS_WINES) {
                sortContractProductItems(con, mechanicTypeEnglishName);
            }
        }
    
        private void sortContractProductItems(EUR_CRM_FI_ContractBuilderController con, String mechanicTypeEnglishName) {
            // sort allContractProductItems based on the label names alphabetically
            if(this.allContractProductItems != null && this.allContractProductItems.size() > 0) {
	            sortList(
	                allContractProductItems,
	                con.mechanicProductMap.get(mechanicTypeEnglishName).replace('__c', '__r'),
	                'asc'
	            );                
                
	            List<EUR_CRM_Contract_Product_Item__c> sortedProductItemsWithRetro = new List<EUR_CRM_Contract_Product_Item__c>();
	            List<EUR_CRM_Contract_Product_Item__c> sortedProductItemsWithoutRetro =  new List<EUR_CRM_Contract_Product_Item__c>();
                
                // For each product item, check if they have retro or not
                for(EUR_CRM_Contract_Product_Item__c cpi: this.allContractProductItems) {
                    if(cpi.EUR_CRM_Amount__c != 0.00) {
                        // For product items with retro, put it in the items with retro list
                        sortedProductItemsWithRetro.add(cpi);
                    } else {
                        // For product items without retro, put it in the items without retro list
                        sortedProductItemsWithoutRetro.add(cpi);
                    }
                }
                
                // Concatenate those 2 lists to get the final sorted list
                this.allContractProductItems = sortedProductItemsWithRetro;
                this.allContractProductItems.addAll(sortedProductItemsWithoutRetro);
            }
        }

	    public void sortList(List<EUR_CRM_Contract_Product_Item__c> items, String sortAPIName, String order){
	        List<EUR_CRM_Contract_Product_Item__c> resultList = new List<EUR_CRM_Contract_Product_Item__c>();
	
	        //Create a map that can be used for sorting 
	        Map<object, List<EUR_CRM_Contract_Product_Item__c>> objectMap = new Map<object, List<EUR_CRM_Contract_Product_Item__c>>();
	           
	        for(EUR_CRM_Contract_Product_Item__c ob : items){
	           if(ob.getSObject(sortAPIName) == null) {
	               continue;
	           }
	           
	           if(objectMap.get(ob.getSObject(sortAPIName).get('Name')) == null) {
	               objectMap.put(ob.getSObject(sortAPIName).get('Name'), new List<EUR_CRM_Contract_Product_Item__c>());
	           }
	           objectMap.get(ob.getSObject(sortAPIName).get('Name')).add(ob);
	        }       
	        
	        //Sort the keys
	        List<object> keys = new List<object>(objectMap.keySet());
	        keys.sort();
	
	        for(object key : keys){ 
	            resultList.addAll(objectMap.get(key)); 
	        }
	
	        //Apply the sorted values to the source list
	        items.clear();
	        if(order.toLowerCase() == 'asc'){
	            for(EUR_CRM_Contract_Product_Item__c ob : resultList){
	                items.add(ob); 
	            }
	        }else if(order.toLowerCase() == 'desc'){
	            for(integer i = resultList.size()-1; i >= 0; i--){
	                items.add(resultList[i]);  
	            }
	        }
	    }        

        private void retrieveExistingContractEvents(){
                List<EUR_CRM_Contract_Event__c> cEvents = new List<EUR_CRM_Contract_Event__c>();
                Set<Id> products = existingProducts;
                String mechTypeId = this.mechanicTypeId;
                String query = 'select id from EUR_CRM_Contract_Mechanic__c where ';
                query +=  productAPIName + ' in: products';
                query += ' AND EUR_CRM_Mechanic__r.EUR_CRM_Mechanic_Type__c =:mechTypeId';

                String query2 = 'select EUR_CRM_Contract_Mechanic__r.'+productAPIName + ', EUR_CRM_Contract_Event__c, EUR_CRM_Contract_Event__r.Name, EUR_CRM_Contract_Event__r.id from EUR_CRM_Contract_Event_To_Prod_Mapping__c ';
                        query2 += ' where EUR_CRM_Contract_Mechanic__c in (' + query + ') order by EUR_CRM_Contract_Event__r.Name asc';
                 List<EUR_CRM_Contract_Event_To_Prod_Mapping__c> cEventProdMapping = (List<EUR_CRM_Contract_Event_To_Prod_Mapping__c>) Database.query(query2);
                system.debug('@@ cEventProdMapping: ' + cEventProdMapping);
                for(EUR_CRM_Contract_Event_To_Prod_Mapping__c mapping : cEventProdMapping){
                    cEvents.add((EUR_CRM_Contract_Event__c) mapping.getSObject('EUR_CRM_Contract_Event__r'));
                
                    if(productContractEventMap == null)
                        productContractEventMap = new Map<String, EduTripProductWrapper>();
                    EUR_CRM_Contract_Mechanic__c cm = (EUR_CRM_Contract_Mechanic__c) mapping.getSObject('EUR_CRM_Contract_Mechanic__r');
                    String prodId = (String) cm.get(productAPIName);
                    EduTripProductWrapper wrapper = productContractEventMap.get(prodId);
                    if(wrapper == null){
                        wrapper =  new EduTripProductWrapper(prodId,mechanicTypeId, productAPIName, new List<EUR_CRM_Contract_Event__c>());
                        productContractEventMap.put(prodId,wrapper);
                    }
                    wrapper.contractEvents.add((EUR_CRM_Contract_Event__c) mapping.getSObject('EUR_CRM_Contract_Event__r'));
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
        
        public void addProduct(Id productId){
            existingProducts.add(productId);
            if(allContractProductItems == null)
                allContractProductItems = new List<EUR_CRM_Contract_Product_Item__c>();
            EUR_CRM_Contract_Product_Item__c prodItem = new EUR_CRM_Contract_Product_Item__c();
            allContractProductItems.add(prodItem);
            prodItem.put(productAPIName,productId);

            if(mechanicTypeName == 'Trips' || mechanicTypeName == 'Education'){
                if(productContractEventMap == null)
                    productContractEventMap = new Map<String, EduTripProductWrapper>();
                productContractEventMap.put(productId, new EduTripProductWrapper(productId,mechanicTypeId, productAPIName, null));
            } 
        }
        
        public void removeProduct(Id productId, Integer index){
            existingProducts.remove(productId);
            if(allContractProductItems == null)
                return; 
            EUR_CRM_Contract_Product_Item__c product = allContractProductItems.remove(index);
            if(product.id == null)
                return;
            if(deleteProducts == null)
                deleteProducts = new List<EUR_CRM_Contract_Product_Item__c>();
            deleteProducts.add(product);
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