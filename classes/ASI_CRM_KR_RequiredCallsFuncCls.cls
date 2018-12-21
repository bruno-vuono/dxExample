public with sharing class ASI_CRM_KR_RequiredCallsFuncCls {
    
    private static Map<String, List<ASI_CRM_KR_Required_Number_of_Calls__c>> KRLogic = new Map<String, List<ASI_CRM_KR_Required_Number_of_Calls__c>> ();
    private static List<LogicWrapper> allLogics = new List<LogicWrapper>();
    private static Map<LogicWrapper, Decimal> results = new Map<LogicWrapper, Decimal>();
    
    private static String KRVenueRecordType = 'ASI_KOR_Venue'; //On Trade Record Type DevloperName 
    private static String KROffTradeRecordType = 'ASI_KR_Off_trade_Venue'; //Off Trade Record Type DevloperName  //Record Type is "Removed"
    private static String KRWholeSalerRecordType = 'ASI_KOR_Wholesaler'; //Wholesaler Record Type DevloperName 
    
    
    static {
        
        /*Custom Setting
            API Name : ASI_CRM_KR_Required_Number_of_Calls__c
            Record Type : 	ASI_CRM_KR_Account_Record_Type__c
            Branch Code : ASI_CRM_KR_Branch_Code__c
            Grade : ASI_CRM_KR_Grade__c
            Outlet Mapping : ASI_CRM_KR_Strategic_Outlet_Mapping__c
            Off HQ : ASI_CRM_KR_Off_HQ__c
            Off Type : 	ASI_CRM_KR_Off_Type__c
            Off Metro : ASI_CRM_KR_Off_Metro__c
            //Customer Record Type : ASI_CRM_KR_Customer_Record_Type__c
            //Region Code : ASI_CRM_KR_Region_Code__c
            Off Trade Customer : ASI_CRM_KR_Off_Trade_Customer__c		 						
            No. of required call : ASI_CRM_KR_No_of_Required_Visitation__c
        */
        
        List<ASI_CRM_KR_Required_Number_of_Calls__c> subLogic = new List<ASI_CRM_KR_Required_Number_of_Calls__c>();
        
        for(ASI_CRM_KR_Required_Number_of_Calls__c logic: ASI_CRM_KR_Required_Number_of_Calls__c.getAll().values()){
            
            subLogic = KRLogic.containsKey(logic.ASI_CRM_KR_Account_Record_Type__c) ? KRLogic.get(logic.ASI_CRM_KR_Account_Record_Type__c) : new List<ASI_CRM_KR_Required_Number_of_Calls__c>(); 
            subLogic.add(logic);
            KRLogic.put(logic.ASI_CRM_KR_Account_Record_Type__c, subLogic);
            
        }
        
        if(!KRLogic.isEmpty()){
            
             system.debug('KRLogic: ' + KRLogic.values());
             populateLogicMethod(ASI_CRM_KR_Required_Number_of_Calls__c.getAll().values());
             
        }
        

    }
    
    public class LogicWrapper{
        /*On Trade Start*/
        public String BranchCode {set;get;}
        public String Grade {set;get;}
        public String outletMapping {set;get;}
        /*On Trade End*/

        /*Off Trade Start*/
        public Boolean OffHQ {set;get;} 
        public String OffType {set;get;}    
        public Boolean offMetro {set;get;}
        /*Off Trade End*/
        
        
        public LogicWrapper(){
            
        }

    
        public LogicWrapper(String codes, String grade, String outletMapping){  /*On Trade Contructor Method*/
            this.BranchCode = codes;
            this.Grade = grade;
            this.outletMapping = outletMapping;
        }
        
        public LogicWrapper( Boolean OffHQ, String OffType, Boolean offMetro){ /*Off Trade Contructor Method*/
            this.OffHQ = offHQ;
            this.OffType = offType;
            this.offMetro = offMetro;
        }

        public LogicWrapper(String codes, String grade){  /*Wholesaler Contructor Method*/
            this.BranchCode = codes;
            this.Grade = grade;
        }
        
        public Boolean equals(Object obj) {
            if (obj instanceof LogicWrapper) {
                LogicWrapper p = (LogicWrapper)obj;
                return ((BranchCode == p.BranchCode) && (Grade==p.Grade) && (outletMapping==p.outletMapping) &&( offHQ == p.OffHQ) &&(offType ==p.OffType) && ( offMetro == p.offMetro) );
            } 
            return false;
        }
        
        public Integer hashCode() {

            return 1;
        }
        
    }
    

    
    
    private static void populateLogicMethod(List<ASI_CRM_KR_Required_Number_of_Calls__c> logics){

             for(ASI_CRM_KR_Required_Number_of_Calls__c logic : logics){
                 
                 
                 if(!logic.ASI_CRM_KR_Off_Trade_Customer__c && (logic.ASI_CRM_KR_Branch_Code__c!=null && logic.ASI_CRM_KR_Branch_Code__c!='')){ 
                        // system.debug('Set String of Branch Code :' + logic.ASI_CRM_KR_Branch_Code__c);
                         for(String code : logic.ASI_CRM_KR_Branch_Code__c.split(',')){
                            
                             if(logic.ASI_CRM_KR_Account_Record_Type__c == KRVenueRecordType ){  //On-Trade
                                 results.put(new LogicWrapper(code, logic.ASI_CRM_KR_Grade__c, logic.ASI_CRM_KR_Strategic_Outlet_Mapping__c), logic.ASI_CRM_KR_No_of_Required_Visitation__c );
                             }else if(logic.ASI_CRM_KR_Account_Record_Type__c == KRWholeSalerRecordType){ //Wholesaler
                                 results.put(new LogicWrapper(code, logic.ASI_CRM_KR_Grade__c), logic.ASI_CRM_KR_No_of_Required_Visitation__c );
                             }     
                        }
                        
                 }else{ // if(logic.ASI_CRM_KR_Account_Record_Type__c== KROffTradeRecordType)
                         //off-Trade Handling
                         results.put(new LogicWrapper(logic.ASI_CRM_KR_Off_HQ__c, logic.ASI_CRM_KR_Off_Type__c, logic.ASI_CRM_KR_Off_Metro__c), logic.ASI_CRM_KR_No_of_Required_Visitation__c );
                     }

             }
             
    }
    
    /*
     public class AccountObj{
        public Account Acc {get;set;}
        public ASI_CRM_AccountsAdditionalField__c additionalField { get; set; }
        public integer RequiredNum { get; set; }
        public List<Boolean> checkboxList {get;set;}{checkboxList = new  List<Boolean> ();}
    }*/
    
    //Method to calculate the the required calls 
    //Used for ASI_CRM_KR_VisitationPlanEditController
    public static List<ASI_CRM_KR_VisitationPlanEditController.AccountObj> findRequiredCall(List<ASI_CRM_KR_VisitationPlanEditController.AccountObj> accts ){
     if(!results.isEmpty() && !accts.isEmpty()){
         Boolean isOffTrade = false;
         for(ASI_CRM_KR_VisitationPlanEditController.AccountObj Obj : accts){
             Account acct = obj.acc; 
             ASI_CRM_AccountsAdditionalField__c additional = obj.additionalField;
             if(additional!=null){ //Need information from customer object
                 
                 isOffTrade = additional.ASI_CRM_Off_Trade_Customer__c;
                 //system.debug(obj.acc + '|' + additional +'?' + isOffTrade); 
                 
                 if(acct.RecordType.DeveloperName == KRVenueRecordType || acct.RecordType.DeveloperName == KRWholeSalerRecordType ){
                     
                     if(acct.RecordType.DeveloperName == KRVenueRecordType ){ 
                         //Venue
                            if(!isOffTrade)
                                Obj.RequiredNum = getValue(new LogicWrapper(acct.Owner.ASI_KOR_User_Branch_Code__c, acct.ASI_KOR_Grade__c, additional.ASI_CRM_Strategic_Outlet_Mapping__c));
                            else
                                Obj.RequiredNum = getValue(new LogicWrapper(additional.ASI_CRM_KR_Off_HQ__c, additional.ASI_CRM_KR_Off_Type__c, additional.ASI_CRM_KR_Off_Metro__c));
                     
                         
                     }else if(acct.RecordType.DeveloperName == KRWholeSalerRecordType){
                         //Wholesaler
                            if(!isOffTrade)
                                Obj.RequiredNum = getValue(new LogicWrapper(acct.Owner.ASI_KOR_User_Branch_Code__c,acct.ASI_KOR_Grade__c )); //acct.ASI_KOR_Grade__c //additional.ASI_CRM_KR_Branch__c //acct.ASI_KOR_Wholesaler_Type__c
                            else
                                Obj.RequiredNum = getValue(new LogicWrapper(additional.ASI_CRM_KR_Off_HQ__c, additional.ASI_CRM_KR_Off_Type__c, additional.ASI_CRM_KR_Off_Metro__c));
                         
                     }
                 }
                 /*
                 if(acct.RecordType.DeveloperName == KRVenueRecordType ){ //On Trade
                    Obj.RequiredNum = getValue(new LogicWrapper(acct.Owner.ASI_KOR_User_Branch_Code__c, acct.ASI_KOR_Grade__c, additional.ASI_CRM_Strategic_Outlet_Mapping__c));
                 }else if(acct.RecordType.DeveloperName == KROffTradeRecordType) { //Off Trade
                        Obj.RequiredNum = getValue(new LogicWrapper(additional.ASI_CRM_KR_Off_HQ__c, additional.ASI_CRM_KR_Off_Type__c, additional.ASI_CRM_KR_Off_Metro__c));
                    }
                */
             }

         }
     }
     return accts;
    }
    
    //Method to extract the required calls from the LogicWrapper Constructor
    public static Decimal getValue(LogicWrapper testWrapper){
           Decimal requiredNum = 0;
           system.debug('results.containsKey(testWrapper)? ' + results.containsKey(testWrapper));
           
           if(results!=null && results.containsKey(testWrapper)){
               system.debug(testWrapper + 'was matched in the logic ; Thus, No# of call: ' + results.get(testWrapper) );
               requiredNum = results.get(testWrapper);
           }

           return requiredNum;
    }
    
    
}