public with sharing class ASI_CRM_KR_VisitationPlanEditController {
   
    public ASI_CRM_KR_VisitationPlanEditController(ApexPages.StandardSetController stdSetController) {
        
    }
    public ApexPages.StandardSetController stdSetController {get;set;}
    
    /***RecordType Setting**/
    public Transient String Holiday_RecordType_DeveloperName {set;get;}{Holiday_RecordType_DeveloperName='ASI_CRM_KR_Holiday';}
    
    
    /***Color Code Setting**/
    private final static String holidayColorCode = '#E77471'; // #FFFFFF
    private final static String holidayTextColorCode = '#3c3c3c';
 	
    public transient List<ASI_KR_Setting__c> ColorList {get;set;}{ ColorList = new  List<ASI_KR_Setting__c> ();}
    public String ColorListJSON {get{return JSON.serialize(ColorList);}}
    public Transient Map<string,string> ColorMap {get;set;} {ColorMap= new Map<string,string>();}
    
    public transient List<ASI_CRM_Holiday__c> HolidayList {get;set;}{ HolidayList = new  List<ASI_CRM_Holiday__c> ();}
    public String HolidaylineJSON {get{return JSON.serialize(HolidayList);}}
    
    public transient List<ASI_KOR_Visitation_Plan_Detail__c> DetailLineList {get;set;}{ DetailLineList = new  List<ASI_KOR_Visitation_Plan_Detail__c> ();}
    public String DetailLineJSON {get{return JSON.serialize(DetailLineList);}}
    
    public transient List<ASI_CRM_AccountsAdditionalField__c> CustomerList {get;set;}{ CustomerList = new  List<ASI_CRM_AccountsAdditionalField__c> ();}
    public String CustomerListJSON {get{return JSON.serialize(CustomerList);}}
    
    
    
    /***Visitation Header **/
    public Id visitationHeaderId  {set;get;}
    public ASI_KOR_Visitation_Plan__c visitationHeader {set;get;}
    public Integer vistationYear  {set;get;}
    public Integer vistationMonth {set;get;}
    
    public Integer OffTradeCall {set;get;}{OffTradeCall=0;}
    public boolean IsOffTradeUser {set;get;}{IsOffTradeUser=false;}

    public string FirstDateOfMonthStr {set;get;}
    // the number of days in the month for the specified year and month 
    public integer NumberOfDay {set;get;}{NumberOfDay=30;}
    
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    
    /*** Method for initalize load the visualforce page **/
    public PageReference pageLoad() {
        
        visitationHeaderId  = ApexPages.currentPage().getParameters().get('id');
        if(visitationHeaderId!=null){
            //Get Header info 
            visitationHeader = [Select id ,ASI_KOR_Month__c , ASI_KOR_Year__c,OwnerId,ASI_KOR_Confirmed__c from ASI_KOR_Visitation_Plan__c where id=:visitationHeaderId];
            
            User uinfo= [select id,ASI_KOR_User_Region_Code__c from user where id=:visitationHeader.OwnerId];
            
            if(uinfo.ASI_KOR_User_Region_Code__c!=null && uinfo.ASI_KOR_User_Region_Code__c=='R03'){
                Map<String,Integer> MonthMap = new Map<String,Integer>{'January' =>1,
                    'February'=> 2 ,
                    'March' =>3 ,
                    'April' =>4 ,
                    'May' => 5,
                    'June'=>  6,
                    'July' =>7 ,
                    'August'=> 8 ,
                    'September'=>  9,
                    'October'=>10  ,
                    'November'=> 11 ,
                    'December'=> 12 };
                
				IsOffTradeUser=true;   
             
                
                for(ASI_CRM_KR_Required_Calls_for_Off_Trade__c rc:ASI_CRM_KR_Required_Calls_for_Off_Trade__c.getAll().values()){
                    if(integer.valueOf(rc.ASI_CRM_KR_Month__c)==MonthMap.get(visitationHeader.ASI_KOR_Month__c) &&  rc.ASI_CRM_KR_Year__c ==visitationHeader.ASI_KOR_Year__c ){
                        OffTradeCall=integer.valueOf(rc.ASI_CRM_KR_Required_No_of_Call__c);
                    }
                }
               
            }// End of  Off Trade User
            
            
            
            //construct date
            vistationYear = visitationHeader.ASI_KOR_Year__c!=null? Integer.valueOf(visitationHeader.ASI_KOR_Year__c):Date.today().year();
            vistationMonth = visitationHeader.ASI_KOR_Month__c !=null? getVPMonthFromPicklistValue(visitationHeader.ASI_KOR_Month__c ):Date.today().month();
            Date FirstDateOfMonth = date.newInstance(vistationYear, vistationMonth, 1);
            FirstDateOfMonthStr=convertDatetoDateTime(FirstDateOfMonth).format('YYYY-MM-dd');
            NumberOfDay = date.daysInMonth(vistationYear, vistationMonth);
            Date lastDateOfMonth=FirstDateOfMonth.addMonths(2);
            FirstDateOfMonth= FirstDateOfMonth.addMonths(-1);
            
            
            //Get Holiday List
            HolidayList=[SELECT id, RecordTypeId, Name, ASI_CRM_Date_From__c, ASI_CRM_Date_To__c , ASI_CRM_Holiday_Type__c,RecordType.DeveloperName FROM ASI_CRM_Holiday__c WHERE (ASI_CRM_Date_From__c >= :FirstDateOfMonth AND ASI_CRM_Date_From__c < :lastDateOfMonth) and RecordType.DeveloperName like 'ASI_CRM_KR%'];
            
            
            //Get details line List 
            DetailLineList=[SELECT Id, Name, ASI_KOR_Status__c,ASI_KOR_Subject__c,ASI_KOR_Visit_Date__c,ASI_KOR_Wholesaler__c,ASI_KOR_Wholesaler__r.Name,ASI_KOR_Wholesaler__r.RecordType.DeveloperName FROM ASI_KOR_Visitation_Plan_Detail__c where ASI_KOR_Visitation_Plan__c=:visitationHeaderId and ASI_KOR_Wholesaler__c!=null];
            
            
            //Get Color List 
            ColorMap= new Map<string,string>();
            ColorList = new  List<ASI_KR_Setting__c> ();
            for(ASI_KR_Setting__c colorset: ASI_KR_Setting__c.getAll().values()){
                if(colorset.ASI_CRM_Type__c=='VisitationPlan'){
                    ColorList.add(colorset);
                    ColorMap.put(colorset.Name, colorset.ASI_CRM_Color__c);
                }
            }//End For Loop
            
            
        }
        return null;
    }
    
    
    
    /*** Convert Month (String) to Integer **/    /*** e.g. Jan > 1**/
    private Integer getVPMonthFromPicklistValue(String plValue) {
        Integer result = ASI_HK_CRM_VisitationPlanGenerator.convertMonthPLValueToInteger(plValue);
        if (result == null) return 0;
        return result;
    }
    
    
    
    
    
    public static datetime convertDatetoDateTime(Date inputDate){
        return datetime.newInstance(inputDate.year(), inputDate.month(),inputDate.day());
    }
  
    
    
    
     public class AccountObj{
        public Account Acc {get;set;}
        public ASI_CRM_AccountsAdditionalField__c additionalField { get; set; }
        public Decimal RequiredNum { get; set; }
        public List<Boolean> checkboxList {get;set;}{checkboxList = new  List<Boolean> ();}
    }
  
    
    
    public class VisitationPlanDetail {  
        public String startStr {get;set;}
        public String endStr   {get;set;}
        public ASI_KOR_Visitation_Plan_Detail__c VisitationDetail {get;set;}
        
        public VisitationPlanDetail (ASI_KOR_Visitation_Plan_Detail__c vp){
            this.VisitationDetail=vp;
            this.startStr=vp.ASI_KOR_Visit_Date__c!=null? convertDatetoDateTime(vp.ASI_KOR_Visit_Date__c).format('YYYY-MM-dd'):null;
            this.endStr=vp.ASI_KOR_Visit_Date__c!=null? convertDatetoDateTime(vp.ASI_KOR_Visit_Date__c+1).format('YYYY-MM-dd'):null;
        }
        
        
    }
    
    
   
    
    
    //**RemoteAction for retreive KR Venues (only venues owned by current user)
    //**if records more than 200, system should inform user to input venue information first
    @RemoteAction
    public static List<AccountObj> findAccount(string Cus, String UserId ){
        List<AccountObj> AccountObject=New List<AccountObj>();
        for(Account acc: [select Id,Name,ASI_KOR_Venue_Pillar__c,ASI_KOR_Venue_Type__c,ASI_MFM_Customer_Supplier_Name__c,ASI_MFM_Customer_Supplier_Number__c,
                          RecordType.Name,RecordType.DeveloperName,OwnerId, ASI_KOR_Grade__c, ASI_KOR_Customer_Code__c, ASI_KOR_Address__c, ASI_KOR_Wholesaler_Type__c,
                          Owner.ASI_KOR_User_Branch_Code__c,
                          (Select Id ,ASI_CRM_KR_Branch__c, ASI_CRM_Strategic_Outlet_Mapping__c,ASI_CRM_Off_Trade_Customer__c,
                           ASI_CRM_KR_Off_HQ__c, ASI_CRM_KR_Off_Type__c, ASI_CRM_KR_Off_Metro__c from ASI_CRM_Accounts_Additional_Fields__r limit 1)
                          from Account 
                          where ASI_KOR_Venue_Status__c ='Active' and (RecordType.DeveloperName like 'ASI_KOR%' OR RecordType.DeveloperName like 'ASI_KR%' ) AND OwnerId=: UserId]){
            AccountObj temp = new AccountObj();
            
            temp.Acc=acc;
            if(acc.ASI_CRM_Accounts_Additional_Fields__r!=null && acc.ASI_CRM_Accounts_Additional_Fields__r.size()>0){
                //system.assertEquals(acc.ASI_CRM_Accounts_Additional_Fields__r[0], null);
                temp.additionalField = acc.ASI_CRM_Accounts_Additional_Fields__r[0];
            }    
            
            temp.RequiredNum=0;
            
            for (Integer i = 1; i < 30; i++) {
                temp.checkboxList.add(false);
            }
            AccountObject.add(temp);
        }
        
        AccountObject =  ASI_CRM_KR_RequiredCallsFuncCls.findRequiredCall(AccountObject );
        
        return AccountObject;
    }
    
    
    //upsert data to databse
    @RemoteAction
    public static string updatePlan(List<ASI_KOR_Visitation_Plan_Detail__c> Planlist, List<String> deleteList,String HeaderId, string Savetype,string ReqPtTotal){
        Id RTid = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan_Detail__cASI_CRM_KR_Visitation_Plan_Detail_Call_Plan');
        //DELETE lINE LIST
        List <ASI_KOR_Visitation_Plan_Detail__c> deleteLinelist= new List <ASI_KOR_Visitation_Plan_Detail__c>();
        for(String items: deleteList){
            deleteLinelist.add(new ASI_KOR_Visitation_Plan_Detail__c(id=items));
        }
        
        string Mesg='';
        System.Savepoint sp = database.setSavepoint();
        try{
            ASI_KOR_Visitation_Plan__c header=[select id,ownerId,owner.name from ASI_KOR_Visitation_Plan__c where id= : HeaderId]; 
            
            if(deleteLinelist.size()>0){
                delete deleteLinelist;
            }
            
            if(Savetype=='Confirm'){//confirm Process  
            
                header.ASI_KOR_No_of_target__c= Double.valueOf(ReqPtTotal);
                header.ASI_KOR_Confirmed__c=true;
				update header; //ASI_KOR_Visitation_Plan__c header= new ASI_KOR_Visitation_Plan__c(id=HeaderId, ASI_KOR_Confirmed__c = true);

                
                List<ASI_KOR_Visitation_Plan_Detail__c> selectedList=[select id,ASI_KOR_Status__c from ASI_KOR_Visitation_Plan_Detail__c where ASI_KOR_Visitation_Plan__c=:HeaderId and ASI_KOR_Status__c!='Cancelled'];
                
                for(ASI_KOR_Visitation_Plan_Detail__c vp: Planlist){
                    vp.ASI_KOR_Status__c='Planned';
                    if(vp.id==null){
                        vp.recordtypeid=RTid;
                    }
                }
                
                for(ASI_KOR_Visitation_Plan_Detail__c vp: selectedList){
                    vp.ASI_KOR_Status__c='Planned';
                    Planlist.add(vp);
                }
                upsert Planlist;
                
                
                
                user OwnerDetail=[Select Id, ManagerId,Manager.email FROM User WHERE Id = :header.ownerId];
                
                if(OwnerDetail.ManagerId!=null && OwnerDetail.Manager.email!=null ){
                        //Send Email 
                    String templateApiName='ASI_CRM_KR_VPConfirmNotification';
                    List <String> ToAddresses=  new List <String>();
                    id  templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;
                    ToAddresses.add(OwnerDetail.Manager.email);  //ownerId
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                    email.setTargetObjectId(header.ownerId);
                    email.setToAddresses( ToAddresses );
                    email.setWhatId(HeaderId);
                    email.setSaveAsActivity(false); 
                    email.setBccSender(false);
                    email.setUseSignature(false);
                    email.setTemplateId(templateId);
                    
                    if(!Test.isRunningTest()){     
                        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    }
                }
                
                    
                
            }else{// Not Confirm
                header.ASI_KOR_No_of_target__c= Double.valueOf(ReqPtTotal);
                update header;
                
                for(ASI_KOR_Visitation_Plan_Detail__c vp: Planlist){
                    if(vp.id==null){
                        vp.recordtypeid=RTid;
                    }
                }
                upsert Planlist;
            }
        
            Mesg+='Save Success!';
        }catch (DmlException dmle) {
            Mesg=dmle.getMessage();
        }catch(Exception e){
            Mesg+=e.getMessage() ;
            database.rollback(sp);
        }
        
        return Mesg;
    }
    
      @RemoteAction
    public static string ResetProcess(String HeaderId){
        string Mesg='';
         try{
             List<ASI_KOR_Visitation_Plan_Detail__c> vpdList=[select id from ASI_KOR_Visitation_Plan_Detail__c where ASI_KOR_Visitation_Plan__c =: HeaderId];
             delete vpdList;
             Mesg+='Save Success!';
        }catch(Exception e){
            Mesg+=e.getMessage() ;
        }
        
        return Mesg;
        
    }
    
    
    //Get data from ASI_KOR_Visitation_Plan_Detail__c : copy from plan
     @RemoteAction 
     public static List<VisitationPlanDetail> findVisitationPlanDetail(string whereClause){
         List<VisitationPlanDetail> VisitationPlanDetailList= new List<VisitationPlanDetail>();
         
         String soql='SELECT Id, Name, ASI_KOR_Subject__c,ASI_KOR_Visit_Date__c,ASI_KOR_Wholesaler__c,ASI_KOR_Wholesaler__r.Name FROM ASI_KOR_Visitation_Plan_Detail__c ';
         
         for(ASI_KOR_Visitation_Plan_Detail__c vp:Database.query(soql+whereClause)){
             VisitationPlanDetailList.add(new VisitationPlanDetail(vp));
         }
         
         return VisitationPlanDetailList;
     }
    
    
   
    
    
}