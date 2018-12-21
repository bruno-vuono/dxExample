public class ASI_CRM_HK_AccChannelRelatedListCtrl {
    public ApexPages.StandardController standardController {get;set;}
    public Account Header {get;set;}
    private String soql {get;set;} 
    public transient List<ASI_HK_CRM_Pre_Approval_Form__c> HeaderItem{get;set;}
    public transient List<ASI_HK_CRM_Pre_Approval_Form_Item__c> LineItem{get;set;}
    public Set<Id> childAc = new Set<Id>(); //20160704, added by Leo
    
    //public List<CustomSKUMechanicDetail> CustomSKUMechanicDetailsList{ get; set; }
    //public CustomSKUMechanicDetail cmd;
    public boolean hasFOC = false;
    
    //public Map<string, List<CustomSKUMechanicDetail>> POLinesMap {set;get;}{ POLinesMap = new Map<string, List<CustomSKUMechanicDetail>>(); }
    //public String mapPOlineJSON {get{return JSON.serialize(POLinesMap);}}

    public ASI_CRM_HK_AccChannelRelatedListCtrl(ApexPages.StandardController controller){
        this.standardController = controller;
        this.Header = (Account) this.standardController.getRecord();   
        if(this.Header !=null && this.Header.Id !=null){
            for(Account outlet : [Select id, Name, ASI_HK_CRM_Customer_Code__c FROM Account where Id =: this.Header.Id limit 1]){
                this.Header = outlet;
                system.debug('----Header: '+this.Header);
            }
            //20160704, added by Leo
            List<Account> childL = new List<Account>([SELECT id FROM Account WHERE parentId =: this.Header.Id]);
            for(Account da: childL)
            {
                childAc.add(da.Id);
            }
            //20160704, added by Leo
            init(); 
        } else {system.debug('Null Header');}
    }

    public Set<id> PAFSet {set; get;}
    public void init() {

        PAFSet = new set<id>();
        List<ASI_CRM_HK_Pre_Approval_Form_Customer__c> PAFCusts = [SELECT id, ASI_CRM_HK_Pre_Approval_Form__c FROM ASI_CRM_HK_Pre_Approval_Form_Customer__c WHERE ASI_CRM_HK_Customer__c = :header.id OR ASI_CRM_HK_Customer__c IN: childAc]; //20160704, edited by Leo, add child set id
        for(ASI_CRM_HK_Pre_Approval_Form_Customer__c PAFCust :PAFCusts) {
            PAFSet.add(PAFCust.ASI_CRM_HK_Pre_Approval_Form__c);
        }
        List<ASI_HK_CRM_Pre_Approval_Form__c> PAFHead = [SELECT id FROM ASI_HK_CRM_Pre_Approval_Form__c WHERE (ASI_HK_CRM_PAF_Customer__c = :header.id Or ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_JDE_Account_Number__c =: header.ASI_HK_CRM_Customer_Code__c) OR ASI_HK_CRM_PAF_Customer__c IN: childAc]; //20160704, edited by Leo, add child set id
        for(ASI_HK_CRM_Pre_Approval_Form__c PAF :PAFHead) {
            PAFSet.add(PAF.id);
        }
        
        soql = 'Select ' + 
            /*'(select ' + 
            'id, ' +
            //'Owner.Name, ' +
            //'CreatedBy.Name, ' +
            //'ASI_CRM_Promotion_Category__r.Name, ' +
            'ASI_HK_CRM_SKU_Lookup__r.Name, ' +
            'ASI_HK_CRM_SKU_Lookup__c, ' +
            'ASI_HK_CRM_SKU_Lookup__r.ASI_FOC_Packing_Description__c, ' +
            'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c, ' +
            'ASI_HK_CRM_Target_Volume_Qty__c, ' +
            'ASI_HK_CRM_Price__c, ' +
            'ASI_HK_CRM_Pouring__c, ' +
            'ASI_HK_CRM_SKU_Value__c, ' +
            'ASI_HK_CRM_Conditions_for_Payment__c, ' +
            'ASI_HK_CRM_mechanic__r.Name, ' +
            'ASI_HK_CRM_Investment_Value__c, ' +
            'ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c, ' +
            'ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c, ' +
            'ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c, ' +
            'ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_1__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_2__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_3__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_4__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_1__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_2__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_3__c, ' +
            'ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_4__c, ' +
            'ASI_HK_CRM_FOC_Free_Bottle_Option_1__c, ' +
            'ASI_HK_CRM_FOC_Free_Bottle_Option_2__c, ' +
            'ASI_HK_CRM_FOC_Free_Bottle_Option_3__c, ' +
            'ASI_HK_CRM_FOC_Free_Bottle_Option_4__c, ' +
            'ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c, ' +
            'ASI_HK_CRM_Rebate_Disc_Percent__c, ' +
            'ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c, ' +
            'ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c, ' +
            'ASI_HK_CRM_Pre_Approval_Form_Lookup__c ' +
            //'ASI_HK_CRM_Total_Investment_Value__c' +
            'From Pre_Approval_Form_Items_Link_To_PAF_Form__r ORDER BY ASI_HK_CRM_Mechanic__r.name), ' +*/
            'id, Name, ASI_HK_CRM_PAF_Raised_Date__c, ASI_HK_CRM_PAF_Status__c, ASI_HK_CRM_PAF_Customer__c, ASI_HK_CRM_PAF_Customer__r.Name, ASI_HK_CRM_PAF_Start_Date__c, ASI_HK_CRM_PAF_End_Date__c ' +
            // Arthur 20180222 Start
            ',ASI_HK_CRM_Adjusted_Start_Date__c, ASI_HK_CRM_Adjusted_End_Date__c '+
            // Arthur 20180222 End
            ',Owner.Name ' +
            ',CreatedBy.Name ' +
            ',ASI_CRM_Promotion_Category__r.Name ' +
            ',ASI_HK_CRM_Total_Investment_Value__c ' +
            ',ASI_HK_CRM_PAF_Customer__r.parentId ' +
            'FROM ASI_HK_CRM_Pre_Approval_Form__c ' +
            'WHERE id IN :PAFSet' 
            +
            ' Order by ASI_HK_CRM_PAF_Start_Date__c DESC'
            ;
        system.debug('soql:::' + soql);
        runQuery();
        
    }
 
 
     public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {                
                try{
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
                }catch(Exception e){
                    System.debug('---------------SetCon:------'+e);
                }
            }
            setCon.setPageSize(1000);//20160823 Ben @ Elufa
            return setCon;
        }
        set;
    }


    // Initialize setCon and return a list of record    
     
    public List<ASI_HK_CRM_Pre_Approval_Form__c> getPAFHeaders() {
         return (List<ASI_HK_CRM_Pre_Approval_Form__c>) setCon.getRecords();
    }    

    public PageReference NewPAF() {
        ASI_CRM_HK_FieldIdMapping__c CustomSetting = [SELECT ASI_CRM_Object_Short__c, ASI_CRM_Customer_Field_Id__c, ASI_CRM_RecordTypeId__c FROM ASI_CRM_HK_FieldIdMapping__c WHERE Name = 'ASI_CRM_HK_NewPAFFields'];
        string headerDesc = encodingutil.urlEncode(this.Header.Name, 'UTF-8'); //20160201, added by Leo, encode string into html format
        //20160201, changed by Leo, change url sequence, id first than value
        string url='/' + CustomSetting.ASI_CRM_Object_Short__c + '/e?' + CustomSetting.ASI_CRM_Customer_Field_Id__c + '_lkid=' + Header.id + '&' + CustomSetting.ASI_CRM_Customer_Field_Id__c + '=' + headerDesc + '&Name=%5BAuto+Assign-Do+Not+Change%5D&RecordType=' + CustomSetting.ASI_CRM_RecordTypeId__c;
        PageReference pageRef = new PageReference(url);
        return pageRef;
    }
    
    public void runQuery() {
            
            HeaderItem = new  List<ASI_HK_CRM_Pre_Approval_Form__c>();
            //LineItem = new List<ASI_HK_CRM_Pre_Approval_Form_Item__c>();
            
            HeaderItem = getPAFHeaders();  

            /*for(ASI_HK_CRM_Pre_Approval_Form__c pos:HeaderItem ){
                CustomSKUMechanicDetailsList = new List<CustomSKUMechanicDetail>();
                //LineItem = pos.getSObjects('Pre_Approval_Form_Items_Link_To_PAF_Form__r'); 
                //system.debug('--------------LineItem--------');
                system.debug(pos.owner.name);
                //system.debug(LineItem.);
                try{
                for(ASI_HK_CRM_Pre_Approval_Form_Item__c paf_detail:LineItem){ 
                    if(paf_detail.ASI_HK_CRM_Pre_Approval_Form_Lookup__c== pos.id){
                        
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
                               cmd.sku_id = paf_detail.ASI_HK_CRM_SKU_Lookup__c;
                               cmd.buy_bottle = null;
                               cmd.sell_bottle = null;
                               cmd.investmentValue = paf_detail.ASI_HK_CRM_Investment_Value__c;
                               cmd.RebateDisc_Percent = paf_detail.ASI_HK_CRM_Rebate_Disc_Percent__c;
                               cmd.RebateDiscAmt_PerBT = paf_detail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                               cmd.CurrencyCode = paf_detail.CurrencyIsoCode;
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
                                        cmd.sku_id = paf_detail.ASI_HK_CRM_SKU_Lookup__c;
                                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c;
                                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c;
                                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c,
                                                                                 paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c,
                                                                                 targetVolume, price);
                                        cmd.RebateDisc_Percent = paf_detail.ASI_HK_CRM_Rebate_Disc_Percent__c;
                                        cmd.RebateDiscAmt_PerBT = paf_detail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                                        if(!Test.isRunningTest())
                                            cmd.CurrencyCode = paf_detail.CurrencyIsoCode;
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
                                            cmd.sku_code = paf_detail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c;
                                            cmd.sku_id = paf_detail.ASI_HK_CRM_SKU_Lookup__c;
                                        }
                                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c;
                                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c;
                                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c,
                                                                                 paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c,
                                                                                 targetVolume, price);
                                        cmd.RebateDisc_Percent = paf_detail.ASI_HK_CRM_Rebate_Disc_Percent__c;
                                        cmd.RebateDiscAmt_PerBT = paf_detail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                                        if(!Test.isRunningTest())
                                            cmd.CurrencyCode = paf_detail.CurrencyIsoCode;
                                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                                        CustomSKUMechanicDetailsList.add(cmd);
                                    }
                                    if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c != null){
                                        cmd = new CustomSKUMechanicDetail();
                                        cmd.paf_displaySKU = paf_detail;
                                        if(!hasFOC){
                                            cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                                            cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                                            cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                                            cmd.sku_code = paf_detail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c;
                                            cmd.sku_id = paf_detail.ASI_HK_CRM_SKU_Lookup__c; 
                                        }
                                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c;
                                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_3__c;
                                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c,
                                                                                 paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_3__c,
                                                                                 targetVolume, price);
                                        cmd.RebateDisc_Percent = paf_detail.ASI_HK_CRM_Rebate_Disc_Percent__c;
                                        cmd.RebateDiscAmt_PerBT = paf_detail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                                        if(!Test.isRunningTest())
                                            cmd.CurrencyCode = paf_detail.CurrencyIsoCode;
                                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                                        CustomSKUMechanicDetailsList.add(cmd);
                                    }
                                    if(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c != null){
                                        cmd = new CustomSKUMechanicDetail();
                                        cmd.paf_displaySKU = paf_detail;
                                        if(!hasFOC){
                                            cmd.mechanic_name = paf_detail.ASI_HK_CRM_mechanic__r.Name;
                                            cmd.Adj_Name = paf_detail.ASI_HK_CRM_Mechanic__r.ASI_CRM_Adjustment_Name__c;
                                            cmd.sku_name = paf_detail.ASI_HK_CRM_SKU_Lookup__r.Name;
                                            cmd.sku_code = paf_detail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c;
                                            cmd.sku_id = paf_detail.ASI_HK_CRM_SKU_Lookup__c;
                                        }
                                        cmd.buy_bottle = paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c;
                                        cmd.sell_bottle = paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_4__c;
                                        cmd.investmentValue = getInvestmentValue(paf_detail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c,
                                                                                 paf_detail.ASI_HK_CRM_FOC_Free_Bottle_Option_4__c,
                                                                                 targetVolume, price);
                                        cmd.RebateDisc_Percent = paf_detail.ASI_HK_CRM_Rebate_Disc_Percent__c;
                                        cmd.RebateDiscAmt_PerBT = paf_detail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                                        if(!Test.isRunningTest())
                                            cmd.CurrencyCode = paf_detail.CurrencyIsoCode;
                                        if(cmd.investmentValue != null) cmd.investValueShowDollarSign = true;
                                        CustomSKUMechanicDetailsList.add(cmd);
                                    }                                   
                                }
                    }
                }
                }catch(Exception e){
                    
                }
                POLinesMap.put(pos.name, CustomSKUMechanicDetailsList);
                    
            }*/
   
    }
    
    /*public class CustomSKUMechanicDetail{
        public ASI_HK_CRM_Pre_Approval_Form_Item__c paf_displaySKU{ get; set; }
        public String mechanic_name{ get; set; }
        public String sku_name{ get; set; }
        public String sku_code{ get; set; }
        public String Adj_Name{ get; set; } // Added by Alan Wong (Elufa) 20150916
        public Decimal buy_bottle{ get; set; }
        public Decimal sell_bottle{ get; set; }
        public Decimal investmentValue{ get; set; }
        public boolean investValueShowDollarSign{ get; set; }
        public boolean perBtShowDollarSign { get; set; }
        public Decimal RebateDisc_Percent { get; set; }
        public Decimal RebateDiscAmt_PerBT { get; set; }
        public String CurrencyCode { get; set; }   
        public Id sku_id { get; set; }   
    }*/
    
    /*public Decimal getInvestmentValue(Decimal buyBt, Decimal freeBt, Decimal volume, Decimal price){
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
        
        
        
    }*/
}