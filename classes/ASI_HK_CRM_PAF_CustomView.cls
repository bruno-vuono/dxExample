public class ASI_HK_CRM_PAF_CustomView {
    
    public final ASI_HK_CRM_Pre_Approval_Form__c paf              { get; set; }
    public List<ASI_HK_CRM_Pre_Approval_Form_Item__c> fullLineList{ get; set; }
    public List<ASI_HK_CRM_Pre_Approval_Form_Item__c> withDetailList { get; set; }
    public List<ASI_HK_CRM_Pre_Approval_Form_Item__c> skuWithDetails{ get; set;}
    public List<ASI_CRM_HK_Pre_Approval_Form_Customer__c> PAFCustomer{ get; set;} // Added By Alan Wong (Elufa) 20150924
    public List<ASI_HK_CRM_ProAndDetail> proAndDetailList{ get; set; }
    public List<CustomSKUMechanicDetail> CustomSKUMechanicDetailsList{ get; set; }
    public Map<String,Decimal> summaryMap{get;set;}
    public Map<String,String> summaryConditionMap{ get; set; }
    public Map<String,String> summaryFreeSKU {get;Set;} // Added by Ray Ui 20160113
    public ASI_HK_CRM_ProAndDetail pad;
    public CustomSKUMechanicDetail cmd;
    public summaryMechanic sm;
    public boolean hasFOC = false;
    public String currencyDisplay{get; set;} 
    public String editViewURL { get; set; }
    public Set<String> skuSet;
    public Boolean showCustList {get; set; }
    
    public static final Integer BOTTLE_NUMBER = 4; 
    public static final String BUY_HEAD_FIELD = 'ASI_HK_CRM_FOC_Buy_Bottle_Option_{0}__c';
    public static final String SELL_HEAD_FIELD = 'ASI_HK_CRM_FOC_Free_Bottle_Option_{0}__c';

    
    private Set<String> pafAllFields;
    
    private static Set<String> requiredLineFields() {
        return new Set<String> {
            'Id'
            , 'ASI_HK_CRM_SKU_Lookup__r.Name'
            , 'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__r.Name' // Added Sub-Brand 20180420'
            , 'ASI_HK_CRM_SKU_Lookup__c'
            , 'ASI_HK_CRM_SKU_Lookup__r.ASI_FOC_Packing_Description__c'
            , 'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c'
            , 'ASI_CRM_HK_Pricing_Item__c' // Added Pricing Item 20151218
            , 'ASI_CRM_HK_Free_SKU__r.Name' //Added 20160113
            , 'ASI_HK_CRM_Target_Volume_Qty__c'
            , 'ASI_HK_CRM_Price__c'
            , 'ASI_HK_CRM_Pouring__c'
            , 'ASI_HK_CRM_SKU_Value__c'
            , 'ASI_HK_CRM_Conditions_for_Payment__c'
            , 'ASI_HK_CRM_mechanic__r.Name'
            , 'ASI_HK_CRM_Investment_Value__c'
            , 'ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c'
            , 'ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c'
            , 'ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c'
            , 'ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c'
            , 'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_1__c'
            , 'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_2__c'
            , 'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_3__c'
            , 'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_4__c'
            , 'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_1__c'
            , 'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_2__c'
            , 'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_3__c'
            , 'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_4__c'
            , 'ASI_HK_CRM_FOC_Free_Bottle_Option_1__c'
            , 'ASI_HK_CRM_FOC_Free_Bottle_Option_2__c'
            , 'ASI_HK_CRM_FOC_Free_Bottle_Option_3__c'
            , 'ASI_HK_CRM_FOC_Free_Bottle_Option_4__c'
            , 'ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c'
            , 'ASI_HK_CRM_Rebate_Disc_Percent__c'
            , 'ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c'
            , 'CurrencyIsoCode'
            , 'ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c'
            
        };
    }
    
    public ASI_HK_CRM_PAF_CustomView (ApexPages.StandardController stdController){ 
        //this.paf = (ASI_HK_CRM_Pre_Approval_Form__c)stdController.getRecord();
        Id pafId = apexpages.currentPage().getParameters().get('id');
        this.editViewURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        summaryConditionMap = new Map<String, String>();
        summaryFreeSKU = new Map<String, String>();
        proAndDetailList = new List<ASI_HK_CRM_ProAndDetail>();
        skuSet = new Set<String>();
        CustomSKUMechanicDetailsList = new List<CustomSKUMechanicDetail>();
        summaryMap = new Map<String,Decimal>();
        pafAllFields = ASI_HK_CRM_CommonUtils.allFieldsOfSObject('ASI_HK_CRM_Pre_Approval_Form__c');
        pafAllFields.add('ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Customer_Code__c'); // Added By Alan Wong (Elufa) 20150924
        showCustList = false;
        this.paf = (ASI_HK_CRM_Pre_Approval_Form__c)database.query(ASI_HK_CRM_CommonUtils.genQueryString(
            pafAllFields
            , 'ASI_HK_CRM_Pre_Approval_Form__c'
            , 'id =: pafId'
        ));  
        retrieveFullLineList(pafId);
    }
    
    private void retrieveFullLineList(Id pafId){
        fullLineList = (List<ASI_HK_CRM_Pre_Approval_Form_Item__c>)database.query(ASI_HK_CRM_CommonUtils.genQueryString(
            requiredLineFields()
            , 'ASI_HK_CRM_Pre_Approval_Form_Item__c'
            , 'ASI_HK_CRM_Pre_Approval_Form_Lookup__c =: pafId'
            , 'ORDER BY ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__r.Name asc,ASI_CRM_HK_Pricing_Item__c' // Sort by Sub-brand 20180420
            //,'ORDER BY ASI_CRM_HK_Pricing_Item__c'
            //TODO: Add "Order by" the item name
        ));
        
        withDetailList = (List<ASI_HK_CRM_Pre_Approval_Form_Item__c>)database.query(ASI_HK_CRM_CommonUtils.genQueryString(
            requiredLineFields()
            , 'ASI_HK_CRM_Pre_Approval_Form_Item__c'
            , 'ASI_HK_CRM_Pre_Approval_Form_Lookup__c =: pafId'
            //, 'ORDER BY ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__r.Name asc,ASI_HK_CRM_Mechanic__r.name' // Sort by Sub-brand 20180420
            //, 'ORDER BY ASI_HK_CRM_Mechanic__r.name'
            
        ));

        //Added By Alan Wong (Elufa) 20150924
        if (this.paf.ASI_CRM_Short_Term_Promotion__c){ 
            showCustList = true;
            Set<String> fields = new Set<string>();
            fields.add('id');
            fields.add('name');
            fields.add('ASI_CRM_HK_Customer__c');
            fields.add('ASI_CRM_HK_Customer__r.Name');
            fields.add('ASI_CRM_Generate_Price_Set__c');
            fields.add('ASI_CRM_PA_DA__c');
            fields.add('ASI_CRM_HK_Customer__r.ParentId'); //20160628, edited by Leo
            fields.add('ASI_CRM_HK_Customer__r.Parent.Name'); //20160628, edited by Leo
            PAFCustomer = (List<ASI_CRM_HK_Pre_Approval_Form_Customer__c>)database.query(ASI_HK_CRM_CommonUtils.genQueryString(
                fields
                , 'ASI_CRM_HK_Pre_Approval_Form_Customer__c'
                , 'ASI_CRM_HK_Pre_Approval_Form__c =: pafId'
            ));
        }
        // End //
        if(fullLineList.size() > 0){
            for(ASI_HK_CRM_Pre_Approval_Form_Item__c paf_item : fullLineList){
                String tempComment = paf_item.ASI_HK_CRM_Conditions_for_Payment__c;
                if(paf_item.ASI_HK_CRM_Conditions_for_Payment__c == null){
                    tempComment = ' ';
                }
                summaryConditionMap.put(paf_item.ASI_HK_CRM_Mechanic__r.Name, tempComment);
                currencyDisplay = paf_item.currencyIsoCode;
                pad = new ASI_HK_CRM_ProAndDetail();
                pad.paf_displayItem = paf_item;
                if(paf_item.ASI_HK_CRM_Price__c != null) pad.priceShowDollarSign = true;
                if(paf_item.ASI_HK_CRM_SKU_Value__c != null) pad.skuValueShowDollarSign = true;
                
                if(paf_item.ASI_HK_CRM_Pouring__c)
                 pad.isPouring = true;
                else
                 pad.isPouring = false;
                if(!skuSet.contains(paf_item.ASI_HK_CRM_SKU_Lookup__r.Name))
                    proAndDetailList.add(pad);

                skuSet.add(paf_item.ASI_HK_CRM_SKU_Lookup__r.Name);                
                //Summary of mechanic
                if(paf_item.ASI_HK_CRM_Mechanic__r.Name != null && paf_item.ASI_HK_CRM_Investment_Value__c != null){
                    pad = new ASI_HK_CRM_ProAndDetail();
                    sm = new summaryMechanic(); 
                    if(summaryMap.get(paf_item.ASI_HK_CRM_Mechanic__r.Name) == null){
                        //String valueWithSign = String.valueOf(paf_item.CurrencyIsoCode) + ' ' + String.valueOf(paf_item.ASI_HK_CRM_Investment_Value__c);
                        summaryMap.put(paf_item.ASI_HK_CRM_Mechanic__r.Name, paf_item.ASI_HK_CRM_Investment_Value__c);
                        if (paf_item.ASI_CRM_HK_Free_SKU__c == null)
                        	summaryFreeSKU.put(paf_item.ASI_HK_CRM_Mechanic__r.Name, '');
                    	else
                            summaryFreeSKU.put(paf_item.ASI_HK_CRM_Mechanic__r.Name, paf_item.ASI_CRM_HK_Free_SKU__r.Name);
                    }
                    else{
                        //String retValue = summaryMap.get(paf_item.ASI_HK_CRM_Mechanic__r.Name);
                        //Decimal originValue = Decimal.valueOf();
                        //originValue += paf_item.ASI_HK_CRM_Investment_Value__c;
                        summaryMap.put(paf_item.ASI_HK_CRM_Mechanic__r.Name, summaryMap.get(paf_item.ASI_HK_CRM_Mechanic__r.Name) + paf_item.ASI_HK_CRM_Investment_Value__c);
                        
                    }
                    
                }
            }
        }
        if(withDetailList.size() > 0){
            for(ASI_HK_CRM_Pre_Approval_Form_Item__c paf_detail: withDetailList){ 
                Decimal targetVolume = paf_detail.ASI_HK_CRM_Target_Volume_Qty__c;
                Decimal price = paf_detail.ASI_HK_CRM_Price__c;
                
                if(paf_detail.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c == 'PAF Item - Variable' 
                || paf_detail.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c == 'PAF Item - Fixed Amount'){
                    cmd = new CustomSKUMechanicDetail();
                    cmd.paf_displaySKU = paf_detail;
                    cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                    cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                    cmd.sku_code = paf_detail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c;
                    cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                    cmd.pricing_item = paf_detail.ASI_CRM_HK_Pricing_Item__c; // Added Pricing Item 20151218
                    cmd.buy_bottle = null;
                    cmd.sell_bottle = null;
                    cmd.investmentValue = paf_detail.ASI_HK_CRM_Investment_Value__c;
                    if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;  
                    if(paf_detail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c != null) cmd.perBtShowDollarSign = true;              
                    CustomSKUMechanicDetailsList.add(cmd);       
                }
                //FOC and bulk FOC           
                else if(paf_detail.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c == 'PAF Item - FOC'  
                || paf_detail.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c == 'PAF Item - FOC Bulk'){
                    cmd = new CustomSKUMechanicDetail();
                    cmd.paf_displaySKU = paf_detail;
                    
                    if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c != null){
                        cmd = new CustomSKUMechanicDetail();
                        cmd.paf_displaySKU = paf_detail;
                        cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                        cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                        cmd.sku_code = paf_detail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c;
                        cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                        cmd.pricing_item = paf_detail.ASI_CRM_HK_Pricing_Item__c; // Added Pricing Item 20151218
                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c;
                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c;
                        if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c != null 
                           && paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c == null)
                            cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c,
                                                                     paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c,
                                                                     targetVolume, price);
                        else
                            cmd.investmentValue = getInvestmentValue2(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c,
                                                                      paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c,
                                                                      targetVolume, price,
                                                                      paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c,
                                                                      paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c);
                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                        hasFOC = true;
                        CustomSKUMechanicDetailsList.add(cmd);
                    }
                    if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c != null){
                        cmd = new CustomSKUMechanicDetail();
                        cmd.paf_displaySKU = paf_detail;
                        if(!hasFOC){
                            cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                            cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                            cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                        }
                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c;
                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c;
                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c,
                        paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c,
                        targetVolume, price);
                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                        CustomSKUMechanicDetailsList.add(cmd);
                    }
                    if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c != null){
                        cmd = new CustomSKUMechanicDetail();
                        cmd.paf_displaySKU = paf_detail;
                        cmd.pricing_item = paf_detail.ASI_CRM_HK_Pricing_Item__c; // Added Pricing Item 20151218
                        if(!hasFOC){
                            cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                            cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                            cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                        }
                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c;
                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_3__c;
                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c,
                        paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_3__c,
                        targetVolume, price);
                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                        CustomSKUMechanicDetailsList.add(cmd);
                    }
                    if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c != null){
                        cmd = new CustomSKUMechanicDetail();
                        cmd.paf_displaySKU = paf_detail;
                        cmd.pricing_item = paf_detail.ASI_CRM_HK_Pricing_Item__c; // Added Pricing Item 20151218
                        if(!hasFOC){
                            cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                            cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                            cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                        }
                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c;
                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_4__c;
                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c,
                        paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_4__c,
                        targetVolume, price);
                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                        CustomSKUMechanicDetailsList.add(cmd);
                    }                                   
                }
                

            }
        }
    }
    
    public class ASI_HK_CRM_ProAndDetail {
        public ASI_HK_CRM_Pre_Approval_Form_Item__c paf_displayItem{ get; set; }
        public boolean isPouring { get; set; }
        public boolean skuValueShowDollarSign{ get; set;}
        public boolean priceShowDollarSign{ get; set; }
        
    }
    
    public class CustomSKUMechanicDetail{
        public ASI_HK_CRM_Pre_Approval_Form_Item__c paf_displaySKU{ get; set; }
        public String mechanic_name{ get; set; }
        public String pricing_item {get; set;} // Added Pricing Item 20151218
        public String sku_name{ get; set; }
        public String sku_code{ get; set; }
        public String Adj_Name{ get; set; } // Added by Alan Wong (Elufa) 20150916
        public Decimal buy_bottle{ get; set; }
        public Decimal sell_bottle{ get; set; }
        public Decimal investmentValue{ get; set; }
        public boolean investValueShowDollarSign{ get; set; }
        public boolean perBtShowDollarSign{ get; set; }
    }
    public class summaryMechanic{
        decimal totalInvestmentValue{ get; set;}
        boolean showDollarSign{ get; set; }
    }
    
    
    //return the name with index
    public String getBuyBottle(Integer index){
        return String.format(BUY_HEAD_FIELD, new String[]{String.valueOf(index)});
    }
    
    public String getSellBottle(Integer index){
        return String.format(SELL_HEAD_FIELD, new String[]{String.valueOf(index)});
    }
    
    public Decimal getInvestmentValue(Decimal buyBt, Decimal freeBt, Decimal volume, Decimal price){
        Decimal result; 
        Integer totalFreeBt;
        
        if(buyBt == null){
            return null;
        }
        else if(volume == null){
            return null;
        }
        else if(freeBt == null){
            return null;
        }
        else if(Price == null){
            return null;
        }
        
        totalFreeBt = Integer.valueOf(volume)/Integer.valueOf(buyBt);
        totalFreeBt = totalFreeBt * Integer.valueOf(freeBt);
        result = totalFreeBt * price;
        return result;
        
        
        
    }
    
    public Decimal getInvestmentValue2(Decimal buyBt, Decimal freeBt, Decimal volume, Decimal price, Decimal buyBt2, Decimal freeBt2){
        Decimal result; 
        Integer totalFreeBt;
        
        if(buyBt == null){
            return null;
        }
        else if(volume == null){
            return null;
        }
        else if(freeBt == null){
            return null;
        }
        else if(Price == null){
            return null;
        }
        else if(buyBt2 == null){
            return null;
        }
        else if(freeBt2 == null){
            return null;
        }
        
        totalFreeBt = Math.mod(Integer.valueOf(volume),Integer.valueOf(buyBt2));
        if(totalFreeBt > 0)
        {
            totalFreeBt = Integer.valueOf(totalFreeBt)/Integer.valueOf(buyBt);
            totalFreeBt = totalFreeBt * Integer.valueOf(freeBt);
            result = totalFreeBt * price;
        }//end if
        else
        {
            result = 0;
        }//end else
        return result;
    }
    
    
}