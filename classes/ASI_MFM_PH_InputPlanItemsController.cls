public class ASI_MFM_PH_InputPlanItemsController {
    //Page ASI_MFM_PH_InputPOItemsPage
    public ApexPages.StandardController standardController {get;set;}
    public ASI_MFM_Plan__c Header {get;set;}
    
    public static final String Budget_RecordType_Developer_Name = 'ASI_MFM_PH_DF_Budget';
    public static final String Plan_Line_RecordType_Developer_Name =  'ASI_MFM_Plan_Line_Item__cASI_MFM_PH_Plan_Line_Item';
    
    //Customer
    public static final String DP_Customer_RecordType_Developer_Name ='ASI_MFM_PH_DP_Customer';
    public static final String DF_Customer_RecordType_Developer_Name ='ASI_MFM_PH_DF_Customer';
    public Transient String Customer_RecordType_Developer_Name {set;get;}//added on 2015-09-02*/
    
    // Sub-brand: ASI_MFM_Sub_brand__c
    public static final String DP_Sub_brand_RecordType_Developer_Name ='ASI_MFM_PH_DP_Sub_brand';
    public static final String DF_Sub_brand_RecordType_Developer_Name ='ASI_MFM_PH_DF_Sub_brand';
    public Transient String Sub_brand_RecordType_Developer_Name {set;get;}
    
    
     // A/C Code: ASI_MFM_A_C_Code__c
    public static final String DP_AC_Code_RecordType_Developer_Name ='ASI_MFM_PH_DP_A_C_Code';
    public static final String DF_AC_Code_RecordType_Developer_Name ='ASI_MFM_PH_DF_A_C_Code';
    public Transient String AC_Code_RecordType_Developer_Name {set;get;}
    
    
    
    public static final String DP_Plan_RecordType_Developer_Name= 'ASI_MFM_PH_DP_Plan';//added on 2015-09-02
    public static final String DF_Plan_RecordType_Developer_Name= 'ASI_MFM_PH_DF_Plan';//added on 2015-09-02
    
    
    public Map<String, interimData> allLineItemMap {get;set;} // final final result 
    public List<ASI_MFM_Plan_Line_Item__c> deleteLineItemList {get;set;}{deleteLineItemList = new List<ASI_MFM_Plan_Line_Item__c>();}
    
    public boolean SaveSuccess {get;set;}
    public boolean UpsertPermission {get;set;}{UpsertPermission=true;}
    
    //Setup DF Default Customer
    public String PHDFCustomerDefault {get;set;}{PHDFCustomerDefault=null;}
    public String PHDFCustomerName {get;set;}{PHDFCustomerDefault=null;}
    
    public String Msg {get;set;}    
    
    // From Plan Header : Start Date and End Date
    public Integer startMonth {get;set;}   
    public Integer EndMonth {get;set;}  
    public boolean CrossYear {get;set;}
    public Integer monthDiff {get;set;}
    public Integer avamonth {get;set;}
    
    public List<boolean> AllowInputList {get;set;}{AllowInputList = new List<boolean>();}
    
    //Index
    public static String LINE_ITEM_NEWRECORD_PREFIX {get{ return 'z';}}
    public Integer LINE_ITEM_NEWRECORD_COUNTER {get;set;}
    
    public ASI_MFM_PH_InputPlanItemsController(ApexPages.StandardController standardController){
        
        this.standardController = standardController;
        
        this.Header = (ASI_MFM_Plan__c) this.standardController.getRecord();
        
        if(this.Header !=null && this.Header.Id !=null){
            for(ASI_MFM_Plan__c plan:[select id,name,ASI_MFM_Start_Date__c,ASI_MFM_End_Date__c,ASI_MFM_Currency__c,ASI_MFM_Exchange_Rate__c, ASI_MFM_Plan_Name__c ,RecordType.DeveloperName, CreatedById,
                                      ASI_MFM_Status__c,ownerId,ASI_MFM_Other_Remark__c,ASI_MFM_Cross_Fiscal_Year__c,
                                      ASI_MFM_Fiscal_year__c ,ASI_MFM_Plan_Raised_Date__c ,ASI_MFM_Objectives_Others__c ,ASI_MFM_Mechanics__c,ASI_MFM_Plan_Amount__c from ASI_MFM_Plan__c where Id =: this.Header.Id limit 1]){
                                          this.Header = plan;
                                          //added on 2015-09-02    Setup customer, AC code,Sub-Brand Record Type
                                          this.Customer_RecordType_Developer_Name= plan.RecordType.DeveloperName.startsWithIgnoreCase(DP_Plan_RecordType_Developer_Name)? DP_Customer_RecordType_Developer_Name:DF_Customer_RecordType_Developer_Name;
                                          //added on 2015-09-02*/
                                          this.Sub_brand_RecordType_Developer_Name= plan.RecordType.DeveloperName.startsWithIgnoreCase(DP_Plan_RecordType_Developer_Name)? DP_Sub_brand_RecordType_Developer_Name:DF_Sub_brand_RecordType_Developer_Name;    
                                          this.AC_Code_RecordType_Developer_Name= plan.RecordType.DeveloperName.startsWithIgnoreCase(DP_Plan_RecordType_Developer_Name)? DP_AC_Code_RecordType_Developer_Name:DF_AC_Code_RecordType_Developer_Name;
                                      }
        }
    }
    
    public Class interimData{
        public ASI_MFM_Plan_Line_Item__c linetems {get; set;}
        public Decimal Amount {get; set;}
        public String ACCode {get; set;}
        public String ACCodeId {set;get;}
        public String Subbrand {set;get;}
        public String SubbrandId {set;get;}
      //  public String budgetAmount {set;get;}
        public String Customer {set;get;} //added on 2015-09-02    
        public String CustomerId {set;get;}//added on 2015-09-02*/
        public Boolean isProcess {set;get;}
    }
    
    
    /*Method: For Auto-Complete*/
    @RemoteAction
    public static List<sObject> findSObjects(string obj, string qry) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(obj);
        if (sot == null) {
            // Object name not valid
            return null;
        }
        
        // create the filter text
        String filter = qry;
        
        
        //begin building the dynamic soql query
        
        String soql = 'select Id, Name from ' + obj + filter +' order by Name';
        
        List<sObject> sobjs = new List<sObject>();
        
        List<String> results = new List<String>();
        
        System.debug('soql:' + soql);
        
        try {
            sobjs = Database.query(soql);
            return sobjs; 
        }
        catch (QueryException e) {
            return null;
        }
        return sobjs;
    }
    
    
   
    public void init() {
        if(this.Header !=null && this.Header.Id !=null){  
            //calculate month between start date and end date
            Date a = Header.ASI_MFM_Start_Date__c;
            Date b = Header.ASI_MFM_End_Date__c;
            monthDiff = a.monthsBetween(b);
            monthDiff++;
            
            
            
            allLineItemMap = new Map<String, interimData>();
            //calculate month between start date and this fiscal year's last month
            Date c = Header.ASI_MFM_Start_Date__c;
            Date d =  Date.newInstance(Integer.valueOf('20'+Header.ASI_MFM_Fiscal_year__c.substring(4,6)),6,30);
            avamonth = c.monthsBetween(d);
            avamonth++;
          	
            
            
                
           
            if(Header.ASI_MFM_End_Date__c.year()!=Header.ASI_MFM_Start_Date__c.year()){
                CrossYear=true;
            }else{
                CrossYear=false;
            }
             startMonth=Header.ASI_MFM_Start_Date__c.month();
            EndMonth=Header.ASI_MFM_End_Date__c.month();
            //construct monthly amount input boolean
            AllowInputList = new List<boolean>();
            for (Integer i = 1; i < 13; i++) {//1-12
                AllowInputList.add(false);
                
                if(Header.ASI_MFM_Start_Date__c.month()==i || (Header.ASI_MFM_End_Date__c.month()==i && !Header.ASI_MFM_Cross_Fiscal_Year__c)){
                    AllowInputList[i-1]=true;
                }
                //construct cut off date
                Date cutoffdate;
                if(i>0 && i<7){
                    Date selectedDate= Date.newInstance(2000+integer.valueOf(Header.ASI_MFM_Fiscal_year__c.substring(4,6)), i, 1);
                    Date firstDate = selectedDate.toStartOfMonth();
                    cutoffdate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
                    
                }else{
                    Date selectedDate= Date.newInstance(2000+integer.valueOf(Header.ASI_MFM_Fiscal_year__c.substring(2,4)), i, 1);
                    Date firstDate = selectedDate.toStartOfMonth();
                    cutoffdate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
                   
                }
                
                if(cutoffdate>Header.ASI_MFM_Start_Date__c && cutoffdate<Header.ASI_MFM_End_Date__c){
                    AllowInputList[i-1]=true;
                  
                }
            }
           
            if(Header.RecordType.DeveloperName.startsWithIgnoreCase(DF_Plan_RecordType_Developer_Name)){
                for (ASI_MFM_Default_Value__c Setting : ASI_MFM_Default_Value__c.getAll().values()) {
                    if(Setting.name == 'PH_DF_Customer_Name__c' && Setting.Country__c == 'PH'){
                        PHDFCustomerDefault = Setting.ASI_MFM_value__c;
                    }
                }
                PHDFCustomerName=[select name from account where id=:PHDFCustomerDefault].name;
            }   

            List<ASI_MFM_Plan_Line_Item__c> lineItemList=[select id ,name,ASI_MFM_Carry_Forward__c,ASI_MFM_Total_Cost__c,ASI_MFM_Plan__c,ASI_MFM_Month_1_Cost__c,ASI_MFM_Month_2_Cost__c,ASI_MFM_Month_3_Cost__c,ASI_MFM_Month_4_Cost__c,ASI_MFM_Month_5_Cost__c,ASI_MFM_Month_6_Cost__c,ASI_MFM_Month_7_Cost__c,ASI_MFM_Month_8_Cost__c,ASI_MFM_Month_9_Cost__c,ASI_MFM_Month_10_Cost__c,ASI_MFM_Month_11_Cost__c,ASI_MFM_Month_12_Cost__c,
                                                          ASI_MFM_A_C_Code__c,ASI_MFM_Customer_Name__c,ASI_MFM_Customer_Name__r.name,ASI_MFM_List_Item_Description__c,ASI_MFM_Sub_brand_Code__c,ASI_MFM_Sub_brand_Code__r.name,ASI_MFM_A_C_Code__r.name 
                                                          from ASI_MFM_Plan_Line_Item__c where ASI_MFM_Plan__c=:Header.id];
            system.debug('Testlinetems'+lineItemList);
            if(!lineItemList.isEmpty()){
                for(ASI_MFM_Plan_Line_Item__c lines:lineItemList){
                    String porlId = (String)(lines.id);
                    interimData temp= new interimData();
                    temp.linetems=lines;
                    
                    for (Integer i = 0; i < 12; i++) {
                        String mapField = 'ASI_MFM_Month_' + (i + 1) + '_Cost__c';
                        temp.linetems.put( mapField,  temp.linetems.get(mapField)==null?0.00:(Decimal)temp.linetems.get(mapField)) ;
                    }
                    
                    
                    temp.SubBrand=lines.ASI_MFM_Sub_brand_Code__r.name;
                    temp.SubbrandId=lines.ASI_MFM_Sub_brand_Code__c;
                    temp.ACCode=lines.ASI_MFM_A_C_Code__r.name;
                    temp.ACCodeId=lines.ASI_MFM_A_C_Code__c;
                    temp.Customer=lines.ASI_MFM_Customer_Name__r.name;//added on 2015-09-02
                    temp.CustomerId=lines.ASI_MFM_Customer_Name__c;//added on 2015-09-02*/
                    
                    allLineItemMap.put(porlId, temp);
                }
            }
            
            
        }
    }
    
    public void resetIsProcessFlag(){
        
        if(allLineItemMap == null) return;
        
         for(String key : allLineItemMap.keySet()){
            
            allLineItemMap.get(key).isProcess = true; 
         }
    }
    
    public void cloneLine() {
        
        UpsertPermission = true;
        SaveSuccess = false;
        resetIsProcessFlag();
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_clone_ID');
        if(allLineItemMap.containsKey(param_Id) && !allLineItemMap.isEmpty()){
            string newIDCounter = newCounterCreatorLine();
            interimData temp= new interimData();
            temp.linetems=new ASI_MFM_Plan_Line_Item__c(ASI_MFM_Plan__c=Header.id,
                                                        ASI_MFM_Customer_Name__c=allLineItemMap.get(param_Id).linetems.ASI_MFM_Customer_Name__c,//added on 2015-09-02*/
                                                        ASI_MFM_List_Item_Description__c=allLineItemMap.get(param_Id).linetems.ASI_MFM_List_Item_Description__c,
                                                        ASI_MFM_Carry_Forward__c=allLineItemMap.get(param_Id).linetems.ASI_MFM_Carry_Forward__c,
                                                        ASI_MFM_Total_Cost__c=allLineItemMap.get(param_Id).linetems.ASI_MFM_Total_Cost__c,
                                                        recordtypeid = Global_RecordTypeCache.getRTId(Plan_Line_RecordType_Developer_Name)
                                                       );
            
            
            for (Integer i = 0; i < 12; i++) {
                String mapField = 'ASI_MFM_Month_' + (i + 1) + '_Cost__c';
                temp.linetems.put( mapField, (Decimal)allLineItemMap.get(param_Id).linetems.get(mapField)) ;
            }                                                
            temp.ACCode=allLineItemMap.get(param_Id).ACCode;
            temp.ACCodeId=allLineItemMap.get(param_Id).ACCodeId;
            temp.SubBrand=allLineItemMap.get(param_Id).SubBrand;
            temp.SubbrandId=allLineItemMap.get(param_Id).SubbrandId;
            
            temp.Customer = allLineItemMap.get(param_Id).Customer;
            temp.CustomerId = allLineItemMap.get(param_Id).CustomerId;
            
            allLineItemMap.put(LINE_ITEM_NEWRECORD_PREFIX+newIDCounter, temp);
            SaveSuccess=false;
        }
        
    }
    
    
    public void removeLine() {

        
        UpsertPermission = true;
        SaveSuccess = false;
        resetIsProcessFlag(); 
        
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_Id = params.get('PARAM_Line_ID');
        if(allLineItemMap.containsKey(param_Id) && !allLineItemMap.isEmpty()){
            
            ASI_MFM_Plan_Line_Item__c delTarget=allLineItemMap.get(param_Id).linetems;
            if(delTarget.id != null){
                deleteLineItemList.add(delTarget);
            }
            
            allLineItemMap.remove(param_Id);
            SaveSuccess=false;
        }
    }
    
    public void addLineItem(){

        UpsertPermission = true;
        SaveSuccess = false;
        resetIsProcessFlag();
        
        string newIDCounter = newCounterCreatorLine();
        interimData temp= new interimData();
        
        temp.linetems=new ASI_MFM_Plan_Line_Item__c(ASI_MFM_Plan__c=Header.id,
                                                    recordtypeid = Global_RecordTypeCache.getRTId(Plan_Line_RecordType_Developer_Name));
        if(Header.RecordType.DeveloperName.startsWithIgnoreCase(DF_Plan_RecordType_Developer_Name)){
            system.debug('DFRT');
            temp.Customer=PHDFCustomerName;
            temp.CustomerId=PHDFCustomerDefault;//temp.linetems.ASI_MFM_Customer_Name__c=PHDFCustomerDefault;
        }                                        
        
        //for (Integer i = 0; i < 12; i++) {
        //    temp.linetems.put('ASI_MFM_Month_' + (i + 1) + '_Cost__c', 0.00);
       // }
        
        
        allLineItemMap.put(LINE_ITEM_NEWRECORD_PREFIX+newIDCounter, temp);
        SaveSuccess=false;
    }
    
  
    /*Method: For Quick-Save and Save Button*/
    public PageReference SaveItems(){ 
        
        PageReference pageRef = null;
        
        UpsertPermission = true;
        SaveSuccess = false;        

        Map<String, String> params = ApexPages.currentPage().getParameters();
        String isQuickSaveStr = params.get('IS_QUICK_SAVE');
        
        Boolean isQuickSave = (isQuickSaveStr==null)?false:Boolean.valueOf(isQuickSaveStr);    

        Database.upsertResult[] upsertTarget;
        Database.deleteResult[] deleteTarget;
        
        List<ASI_MFM_Plan_Line_Item__c> upsertTargetList = new List<ASI_MFM_Plan_Line_Item__c>();
        
        Boolean isRedirect = True; 
        
        if(!allLineItemMap.isEmpty()){
            
            isRedirect =  valdationCheckingStep(allLineItemMap);
            
        }
        
        
        if(!isRedirect){
            
            UpsertPermission = false;
            SaveSuccess = false;
            return null;
            
        }        


        if(UpsertPermission){
            for(String key : allLineItemMap.keySet()){
                ASI_MFM_Plan_Line_Item__c PLtemp =new ASI_MFM_Plan_Line_Item__c();
                PLtemp=allLineItemMap.get(key).linetems;
                
                if(String.isNotEmpty(allLineItemMap.get(key).ACCodeId)){
                    PLtemp.ASI_MFM_A_C_Code__c= Id.valueOf(allLineItemMap.get(key).ACCodeId);
                }
                if(String.isNotEmpty(allLineItemMap.get(key).SubBrandId)){
                    PLtemp.ASI_MFM_Sub_brand_Code__c= Id.valueOf(allLineItemMap.get(key).SubBrandId);
                }
                //added on 2015-09-02
                if(String.isNotEmpty(allLineItemMap.get(key).CustomerId)){
                    PLtemp.ASI_MFM_Customer_Name__c= Id.valueOf(allLineItemMap.get(key).CustomerId);
                }//added on 2015-09-02
                
                //default the total cost = 0 
                //PLtemp.ASI_MFM_Total_Cost__c=0;
                //sum up all monthly cost 
                /*
                for (Integer i = 0; i < 12; i++) {
                    String mapField = 'ASI_MFM_Month_' + (i + 1) + '_Cost__c';
                    PLtemp.ASI_MFM_Total_Cost__c=PLtemp.ASI_MFM_Total_Cost__c+(Decimal)allLineItemMap.get(key).linetems.get(mapField);
                }  
*/

                if(String.isNotEmpty(allLineItemMap.get(key).ACCodeId)&& String.isNotEmpty(allLineItemMap.get(key).SubBrandId)&& String.isNotEmpty(allLineItemMap.get(key).CustomerId)){
                    upsertTargetList.add(PLtemp);
                }
                
                system.debug('TestallLineItemMap_Now'+allLineItemMap);
            }
        }
        
        System.Savepoint pSavepoint = Database.setSavepoint();
        
        
        try{
            
            if(deleteLineItemList.size()>0){
                deleteTarget = Database.delete(deleteLineItemList);
                deleteLineItemList.clear();
            }
            if(upsertTargetList.size()>0){
                    upsertTarget = Database.upsert(upsertTargetList);
               
            }
            SaveSuccess = true;
            
        }catch(Exception e){
            system.debug('EnterFailes'+e);
            msg += 'Save Error : ' +e.getMessage() + '</br>';
            pageRef = null;
            Database.rollback(pSavepoint);      
            UpsertPermission = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Fatal,e.getDmlMessage(0)));
            return null;
        } 
       

        if (!isQuickSave && UpsertPermission){
            pageRef = new PageReference('/'+Header.Id);
            pageRef.setRedirect(true);
        }else{
            pageRef=null;
        } 
        
        return pageRef;        

    }

      
    /*Method: For valdationCheckingStep*/   
    public Boolean valdationCheckingStep(Map<String, interimData>allLineItemMap ){
        
        Boolean isProcess = true;
        Decimal totalamount=0;
        Integer idx = 1; 
        
        msg = '';
        
        if(allLineItemMap == null) return false;       
                
        for(String key : allLineItemMap.keySet()){
            
            //initalize isProcess for Line
            allLineItemMap.get(key).isProcess = true;

                //default the total cost = 0 
            //allLineItemMap.get(key).linetems.ASI_MFM_Total_Cost__c=0;
            
            /*
            //sum up all monthly cost 
            for (Integer i = 0; i < 12; i++) {
                String mapField = 'ASI_MFM_Month_' + (i + 1) + '_Cost__c';
                if(allLineItemMap.get(key).linetems.get(mapField)!=null || allLineItemMap.get(key).linetems.get(mapField)!=0){
                    allLineItemMap.get(key).linetems.ASI_MFM_Total_Cost__c= allLineItemMap.get(key).linetems.ASI_MFM_Total_Cost__c+(Decimal)allLineItemMap.get(key).linetems.get(mapField);
                }
                   
            }                */  
                
            if(allLineItemMap.get(key).linetems.ASI_MFM_Total_Cost__c<=0){
                allLineItemMap.get(key).linetems.addError('Total Amount should be larger than 0.');
                msg += 'Line ' + idx + ' : Total Amount should be larger than 0.' + '</br>';
                allLineItemMap.get(key).isProcess = false;
                isProcess = false;                
            }

             if(allLineItemMap.get(key).linetems.ASI_MFM_Total_Cost__c==null){
                allLineItemMap.get(key).linetems.addError('Total Amount can not be null.');
                msg += 'Line ' + idx + ' : Total Amount can not be null.' + '</br>';
                allLineItemMap.get(key).isProcess = false;
                isProcess = false;                
            }

            
           if(String.isEmpty(allLineItemMap.get(key).Subbrand) || String.isEmpty(allLineItemMap.get(key).SubbrandId)){
                allLineItemMap.get(key).linetems.addError('Please select Sub-Brand');
                msg += 'Line ' + idx + ' : Please select Sub-Brand1' + '</br>';
                allLineItemMap.get(key).isProcess = false;
                isProcess = false;  
            }else{
                if(!String.isEmpty(allLineItemMap.get(key).SubbrandId)){
                    try{
                        /*Need to map back the ID to ASI_MFM_Sub_brand_Code__c*/
                        Id SubbrandId = Id.valueOf(allLineItemMap.get(key).SubbrandId);
                        allLineItemMap.get(key).linetems.ASI_MFM_Sub_brand_Code__c = SubbrandId;
                    } catch(exception e){
                        msg += 'Line ' + idx + ' : Please select Sub-Brand2' + '</br>';
                        allLineItemMap.get(key).isProcess = false;
                        isProcess = false;  
                    }
                    
                }
            }
            
            
            if(String.isEmpty(allLineItemMap.get(key).Customer) || String.isEmpty(allLineItemMap.get(key).CustomerId)){
                allLineItemMap.get(key).linetems.addError('Please select Customer');
                msg += 'Line ' + idx + ' : Please select Customer' + '</br>';
                allLineItemMap.get(key).isProcess = false;
                isProcess = false;  
            }else{
                if(!String.isEmpty(allLineItemMap.get(key).CustomerId)){
                    try{
                        /*Need to map back the ID to Customer*/
                        Id CusId = Id.valueOf(allLineItemMap.get(key).CustomerId);
                        allLineItemMap.get(key).linetems.ASI_MFM_Customer_Name__c = CusId;
                    } catch(exception e){
                        msg += 'Line ' + idx + ' : Please select Customer' + '</br>';
                        allLineItemMap.get(key).isProcess = false;
                        isProcess = false;  
                    }
                    
                }
                
            }
            
            if(String.isEmpty(allLineItemMap.get(key).ACCode) || String.isEmpty(allLineItemMap.get(key).ACCodeId)){
                allLineItemMap.get(key).linetems.addError('Please select AC Code');
                msg += 'Line ' + idx + ' : Please select AC Code' + '</br>';
                isProcess = false;  
            }else{
                if(!String.isEmpty(allLineItemMap.get(key).ACCodeId)){
                    try{
                        /*Need to map back the ID to ASI_MFM_A_C_Code__c*/
                        Id AcId = Id.valueOf(allLineItemMap.get(key).ACCodeId);
                        allLineItemMap.get(key).linetems.ASI_MFM_A_C_Code__c = AcId;
                    } catch(exception e){
                        msg += 'Line ' + idx + ' : Please select AC Code' + '</br>';
                        allLineItemMap.get(key).isProcess = false;
                        isProcess = false;  
                    }
                    
                }
            }
            
            idx++;
        }
        
        
        
        
        return isProcess;
    }

    
    public PageReference cancel() {
        
        return standardController.cancel();
        
    }
    
    
    
    //Index
    public String newCounterCreatorLine() {
        
        String idNew;
        IF(LINE_ITEM_NEWRECORD_COUNTER == null) {
            LINE_ITEM_NEWRECORD_COUNTER = 0;
        }
        else {
            LINE_ITEM_NEWRECORD_COUNTER+=1;
        }
        
        String zParser = '';
        Integer oneDigitCounter = LINE_ITEM_NEWRECORD_COUNTER;
        
        if(LINE_ITEM_NEWRECORD_COUNTER > 9) {
            Integer zNumber = LINE_ITEM_NEWRECORD_COUNTER/10;
            for (Integer i = 0; i < zNumber; i++) {
                zParser += 'z';
            }
            oneDigitCounter = Math.mod(LINE_ITEM_NEWRECORD_COUNTER, 10);
        }
        
        idNew = zParser + string.valueof(oneDigitCounter);
        return idNew;
        
    }
    
}