public with sharing class EUR_CRM_FI_ProfitCalculatorExt {

    public final String LUMP_SUM = 'Lump Sum';
    public final String EDUCATION = 'Education';

    public EUR_CRM_Contract__c contractObj{get; set;}

    private ApexPages.StandardController standardController {get;set;}
    private Id contractId {
        get{if (this.standardController!=null){
                return this.standardController.getId();                                 
        }   
        return null;
    }}

    public EUR_CRM_ContractClass contractClassObject {get; private set;}

    public Map<Id,EUR_CRM_Mechanic_Type__c> mechanicTypeMap = new Map<Id,EUR_CRM_Mechanic_Type__c>();

    public Map<String,  List<EUR_CRM_Contract_Product_Item__c>> contractActivityItemsMap {get;set;}

    //public List<ProfitCalculatorWrapper> profCalculatorWrapList {get;set;}

    public List<ProfitCalculatorWrapper2> profCalculatorWrapList2 {get;set;}
    public String thousandSep {get;set;}
    public String decimalSep {get;set;}
    public EUR_CRM_FI_ProfitCalculatorExt(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        contractObj = (EUR_CRM_Contract__c )standardController.getRecord();

        //Init Contract
        contractClassObject = new EUR_CRM_ContractClass(contractId);

        //Init MechanicTypeMap
        retrieveMechanicTypes();

        //Init Wrapper
        buildProfitCalculatorWrapper(contractId);
        Decimal value = 1000.10;
        String formattedValue = value.format();
        thousandSep = formattedValue.substring(1,2);
        decimalSep = formattedValue.substring(5,6); 

        
    }

    public void buildProfitCalculatorWrapper(Id contractId){
        contractActivityItemsMap = new Map<String,  List<EUR_CRM_Contract_Product_Item__c>>();
        //profCalculatorWrapList = new List<ProfitCalculatorWrapper>();
        profCalculatorWrapList2 = new List<ProfitCalculatorWrapper2>();
        Map<Id,  List<EUR_CRM_Contract_Product_Item__c>> contractActivityItems = new Map<Id,  List<EUR_CRM_Contract_Product_Item__c>>();

        contractActivityItems = EUR_CRM_FI_UtilClass.retrieveContractProductLineItems(contractId);

        System.debug('FLAG - ITEMS: '+contractActivityItems);

        /*

        system.debug('FLAG - NEW MAP ITEMS: '+contractActivityItemsMap);*/


        /*for(String key : contractActivityItems.keyset()){
            System.debug('&&KEY: '+key);
            for(EUR_CRM_Contract_Product_Item__c productItem: contractActivityItems.get(key)){
                profCalculatorWrapList2.add(new ProfitCalculatorWrapper2(productItem, mechanicTypeMap, false, null));
            }
        }

        for(EUR_CRM_Contract_Activity_Item__c contractActivity : [SELECT Id, EUR_CRM_Mechanic_Type__r.Name, EUR_CRM_Lumpsum_Value__c, EUR_CRM_Mktg_Package_Mechanic_Handling__c FROM EUR_CRM_Contract_Activity_Item__c WHERE EUR_CRM_Contract__c = :contractId]){
            if(contractActivity.EUR_CRM_Mktg_Package_Mechanic_Handling__c == LUMP_SUM){
                profCalculatorWrapList2.add(new ProfitCalculatorWrapper2(null, null, true, contractActivity));
            }
        }*/
        
        //for(EUR_CRM_Contract_Activity_Item__c key : [SELECT Id, EUR_CRM_Mechanic_Type__c, EUR_CRM_Mechanic_Type__r.Name, EUR_CRM_Lumpsum_Value__c, EUR_CRM_Mktg_Package_Mechanic_Handling__c FROM EUR_CRM_Contract_Activity_Item__c WHERE EUR_CRM_Contract__c = :contractId ORDER BY EUR_CRM_Mechanic_Type__r.EUR_CRM_Display_Order__c]){
        for(EUR_CRM_Contract_Activity_Item__c key : [SELECT Id, EUR_CRM_Mechanic_Type__c, EUR_CRM_Mechanic_Type__r.Name, EUR_CRM_Lumpsum_Value__c, EUR_CRM_Mktg_Package_Mechanic_Handling__c FROM EUR_CRM_Contract_Activity_Item__c WHERE EUR_CRM_Contract__c = :contractId AND EUR_CRM_Mechanic_Type__r.Name <> :EDUCATION ORDER BY EUR_CRM_Mechanic_Type__r.EUR_CRM_Display_Order__c]){
            System.debug('&&KEY: '+key.Id);
            System.debug('&&KEY2: '+contractActivityItems.containskey(key.EUR_CRM_Mechanic_Type__c));
            if(contractActivityItems.containskey(key.EUR_CRM_Mechanic_Type__c)){
                for(EUR_CRM_Contract_Product_Item__c productItem: contractActivityItems.get(key.EUR_CRM_Mechanic_Type__c)){
                    profCalculatorWrapList2.add(new ProfitCalculatorWrapper2(productItem, mechanicTypeMap, false, null, false));
                }
                if(key.EUR_CRM_Lumpsum_Value__c != null && key.EUR_CRM_Lumpsum_Value__c != 0){
                    profCalculatorWrapList2.add(new ProfitCalculatorWrapper2(null, null, true, key, true));
                    //profCalculatorWrapList2.add(new ProfitCalculatorWrapper2(productItem, mechanicTypeMap, true, key, true));
                }
            } else {
                //if(key.EUR_CRM_Mktg_Package_Mechanic_Handling__c == LUMP_SUM){
                    profCalculatorWrapList2.add(new ProfitCalculatorWrapper2(null, null, true, key, false));
                //}
            }
        }
        
    }

    private void retrieveMechanicTypes(){
        mechanicTypeMap = new  Map<Id, EUR_CRM_Mechanic_Type__c>();        
        for (EUR_CRM_Mechanic_Type__c mechanic: [SELECT Id, Name, EUR_CRM_Grouping_Name__c, 
                                                EUR_CRM_Mechanic_Process_Type__c, EUR_CRM_Country_Code__c, 
                                                EUR_CRM_Has_Lump_Sum__c, EUR_CRM_Has_Per_BQ__c,
                                                EUR_CRM_Mechanic_Type_Name_English__c
                                                FROM EUR_CRM_Mechanic_Type__c
                                                WHERE EUR_CRM_Country_Code__c =: contractClassObject.contractDetails.EUR_CRM_Country_Code__c
                                             
                                                LIMIT 49999]){
            mechanicTypeMap.put(mechanic.Id, mechanic);
        }
        
        System.debug('Flag - Retrieve mechanicTypeMap:' + mechanicTypeMap); 
    } 

    public class ProfitCalculatorWrapper2{

        public final String POURING_REFUND_SPIRITS = 'Pouring Refund Spirits';
        public final String POURING_REFUND_WINES = 'Pouring Refund Wines';
        public final String SELECTION_BRANDS_SPIRITS = 'Selection Brands Spirits';
        public final String SELECTION_BRANDS_WINES = 'Selection Brands Wines';
        public final String MARKETING_ACTIVITY_SPIRITS= 'Marketing Activity Spirits';
        public final String MARKETING_ACTIVITY_WINES = 'Marketing Activity Wines';
        public final String TRIPS = 'Trips';
        public final String EDUCATION = 'Education';
        public final String FREE_STOCK = 'Free stock';
        public final Set<String> MARKETING_GROUP_NAME = new Set<String>{MARKETING_ACTIVITY_SPIRITS,MARKETING_ACTIVITY_WINES,TRIPS,EDUCATION,FREE_STOCK};
        public final String LUMP_SUM = 'Lump Sum';
        public final String BOTH_LUMP_SUM = 'Amount inputted as Lump sum';


        public String sourceName {get;set;}
        public String itemName {get;set;}
        public Decimal volBottles {get;set;}
        public Decimal cMargin {get;set;}
        public Decimal totalVolperCMargin {get;set;}
        public Decimal retroBottles {get;set;}
        public Decimal totalRetroperCMargin {get;set;}
        public Decimal totalCM {get;set;}
        public Decimal lumpSum {get;set;}
        public Decimal totalCMByRow {get;set;}

        public ProfitCalculatorWrapper2(EUR_CRM_Contract_Product_Item__c productItem, Map<Id, EUR_CRM_Mechanic_Type__c> mechanicTypeMap, Boolean isLumpSum, EUR_CRM_Contract_Activity_Item__c contractActivity, Boolean isBothLumpSum){
                    

            if(isLumpSum != true){
                sourceName = productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Mechanic_Type__r.Name;
                if(sourceName == POURING_REFUND_SPIRITS){
                    itemName = productItem.EUR_CRM_Brand_Quality_Size__r.Name;
                    if(productItem.EUR_CRM_Brand_Quality_Size__r.EUR_CRM_Contributive_Margin_BQS__c != null){
                        cMargin = productItem.EUR_CRM_Brand_Quality_Size__r.EUR_CRM_Contributive_Margin_BQS__c;
                    }
                }
                if(sourceName == POURING_REFUND_WINES){
                    itemName = productItem.EUR_CRM_SKU__r.Name;
                    if(productItem.EUR_CRM_SKU__r.EUR_CRM_Contributive_Margin_SKU__c != null){
                        cMargin = productItem.EUR_CRM_SKU__r.EUR_CRM_Contributive_Margin_SKU__c;
                    }
                }
                if(sourceName == SELECTION_BRANDS_SPIRITS){
                    itemName = productItem.EUR_CRM_Brand_Quality_Size__r.Name;
                    if(productItem.EUR_CRM_Brand_Quality_Size__r.EUR_CRM_Contributive_Margin_BQS__c != null){
                        cMargin = productItem.EUR_CRM_Brand_Quality_Size__r.EUR_CRM_Contributive_Margin_BQS__c;
                    }
                }
                if(sourceName == SELECTION_BRANDS_WINES){
                    itemName = productItem.EUR_CRM_Brand__r.Name;
                    if(productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c != null){
                        cMargin = productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c;
                    }
                }
                if(sourceName == MARKETING_ACTIVITY_SPIRITS){
                    /*itemName = productItem.EUR_CRM_Brand_Quality__r.Name;
                    if(productItem.EUR_CRM_Brand_Quality__r.EUR_CRM_Contributive_Margin_BQ__c != null){
                        cMargin = productItem.EUR_CRM_Brand_Quality__r.EUR_CRM_Contributive_Margin_BQ__c;
                    }*/
                    itemName = productItem.EUR_CRM_Brand__r.Name;
                    if(productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c != null){
                        cMargin = productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c;
                    }
                }
                if(sourceName == MARKETING_ACTIVITY_WINES){
                    /*itemName = productItem.EUR_CRM_Brand_Quality__r.Name;
                    if(productItem.EUR_CRM_Brand_Quality__r.EUR_CRM_Contributive_Margin_BQ__c != null){
                        cMargin = productItem.EUR_CRM_Brand_Quality__r.EUR_CRM_Contributive_Margin_BQ__c;
                    }*/
                    itemName = productItem.EUR_CRM_Brand__r.Name;
                    if(productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c != null){
                        cMargin = productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c;
                    }
                }
                if(sourceName == TRIPS){
                    itemName = productItem.EUR_CRM_Brand__r.Name;
                    if(productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c != null){
                        cMargin = productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c;
                    }
                }
                if(sourceName == EDUCATION){
                    itemName = productItem.EUR_CRM_Brand__r.Name;
                    if(productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c != null){
                        cMargin = productItem.EUR_CRM_Brand__r.EUR_CRM_Contributive_Margin_Brand__c;
                    }
                }
                if(sourceName == FREE_STOCK){
                    itemName = productItem.EUR_CRM_Brand_Quality__r.Name;
                    if(productItem.EUR_CRM_Brand_Quality__r.EUR_CRM_Contributive_Margin_BQ__c != null){
                        cMargin = productItem.EUR_CRM_Brand_Quality__r.EUR_CRM_Contributive_Margin_BQ__c;
                    }
                }

                if(cMargin != null){
                    //cMargin = cMargin.setScale(2);
                    if(!MARKETING_GROUP_NAME.contains(sourceName)){
                        cMargin = cMargin.setScale(2);
                    } else{cMargin = null;}
                }

                if(productItem.EUR_CRM_Quantity__c == 0){
                    volBottles = null;
                } else{volBottles = productItem.EUR_CRM_Quantity__c;}

                if(cMargin != null && volBottles != null){
                    totalVolperCMargin = volBottles * cMargin;
                    totalVolperCMargin = totalVolperCMargin.setScale(2);
                }
                //aug 07 2015 - 
                //if(productItem.EUR_CRM_Amount__c != 0){
                    retroBottles = productItem.EUR_CRM_Amount__c;
                    if(MARKETING_GROUP_NAME.contains(sourceName)){
                        retroBottles = null;
                    }
                //} else{retroBottles = null;}

                /*if(cMargin != null && retroBottles != null){
                    totalRetroperCMargin = cMargin - retroBottles;
                    totalRetroperCMargin = totalRetroperCMargin.setScale(2);
                }*/  
                
                /*if(retroBottles != null){
                    if(cMargin == null){
                        totalRetroperCMargin = 0 - retroBottles;
                    } else{
                        totalRetroperCMargin = cMargin - retroBottles;
                    }
                    totalRetroperCMargin = totalRetroperCMargin.setScale(2);
                }*/

                if(cMargin == null && retroBottles == null){
                    
                } else{
                    Decimal cMarginTemp = 0;
                    Decimal retroBottlesTemp = 0;

                    if(retroBottles != null){
                        retroBottlesTemp = retroBottles;
                    }
                    if(cMargin != null){
                        cMarginTemp = cMargin;
                    }
                    totalRetroperCMargin = cMarginTemp - retroBottlesTemp;
                    totalRetroperCMargin = totalRetroperCMargin.setScale(2);
                }

                

                if(totalRetroperCMargin != null && volBottles != null){
                    totalCM = totalRetroperCMargin * volBottles;
                    totalCM = totalCM.setScale(2);
                } 

                /*if(productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Lumpsum_Value__c != null){
                    lumpSum = productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Lumpsum_Value__c;
                } else{*/
                    if(MARKETING_GROUP_NAME.contains(sourceName)){
                        //if(productItem.EUR_CRM_Amount__c != 0){lumpSum = productItem.EUR_CRM_Amount__c;}
                        if(productItem.EUR_CRM_Marketing_Amount__c != 0){lumpSum = productItem.EUR_CRM_Marketing_Amount__c;}
                    }
                //}

                /*if(productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Lumpsum_Value__c != null){
                    lumpSum = productItem.EUR_CRM_Contract_Activity_Item__r.EUR_CRM_Lumpsum_Value__c;
                } else{
                    if(MARKETING_GROUP_NAME.contains(sourceName)){
                        //if(productItem.EUR_CRM_Amount__c != 0){lumpSum = productItem.EUR_CRM_Amount__c;}
                        if(productItem.EUR_CRM_Marketing_Amount__c != 0){lumpSum = productItem.EUR_CRM_Marketing_Amount__c;}
                    }
                }*/
            } else{
                sourceName = contractActivity.EUR_CRM_Mechanic_Type__r.Name;
                lumpSum = contractActivity.EUR_CRM_Lumpsum_Value__c;
                //itemName = LUMP_SUM;
                if(isBothLumpSum == false){
                    itemName = LUMP_SUM;
                } else{
                    itemName = BOTH_LUMP_SUM;
                }
                
            }

            

            if(lumpsum == null && totalCM != null){
                totalCMByRow = totalCM;
            }
            if(lumpsum != null && totalCM == null){
                totalCMByRow = 0 - lumpsum;
            }
            if(lumpsum == null && totalCM == null){
                totalCMByRow = 0;
            }
        }
    }

    /*public class ProfitCalculatorWrapper{

        public String key {get;set;}
        public List<EUR_CRM_Contract_Product_Item__c> productItems {get;set;}

        public ProfitCalculatorWrapper(String key, List<EUR_CRM_Contract_Product_Item__c> productItems){
            this.key = key;
            this.productItems = productItems;

            
        }
    }*/

   
}