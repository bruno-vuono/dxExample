public class MMPJ_TOPG_MarketDecisionInsightCtrl {
public Date StartDate{get;set;}
public Date EndDate{get;set;}
public list<SelectOption> AllMarkets{get;set;}
public list<SelectOption> SelectedMarkets{get;set;}
public list<MMPJ_TOPG_MoMLineItem__c > ListMoMLineItemDecisions{get;set;}
public list<MMPJ_TOPG_MoMLineItem__c > ListMoMLineItemInsights{get;set;} 
public  MMPJ_TOPG_RAID__c Raid{get;set;}
public Integer SizeMultipicklist {get;set;}
public Boolean actionDone{get;set;}

    public list<SelectOption> listMarkets{
        get;
        set{            
            if(value != null && value.size() > 0 /*&& listMarkets == null*/ ){
                listMarkets = value;
                SelectedMarkets.clear();
                for(SelectOption tempMarket : AllMarkets){
                    for(SelectOption tempMarket2 : listMarkets){
                         String marketName=tempMarket2.getLabel();
                        String  tempMarketName=marketName.substring(0,marketName.indexOfIgnoreCase(' ',0));    
                        if(tempMarket.getLabel() == tempMarketName){
                            SelectedMarkets.add(tempMarket);
                            break;
                        }
                    }
                }             
                    system.debug('SelectedMarkets==='+SelectedMarkets);
        }
    }}
 //constructor   
public MMPJ_TOPG_MarketDecisionInsightCtrl (){
 AllMarkets = new list<selectoption>(); 
 SelectedMarkets= new list<selectoption>(); 
 ListMoMLineItemInsights = new list<MMPJ_TOPG_MoMLineItem__c>();
 ListMoMLineItemDecisions = new list<MMPJ_TOPG_MoMLineItem__c>();
 Raid= new MMPJ_TOPG_RAID__c(); 
 //set Date by default for start Date and end Date
 DateTime dtStart=System.today().addMonths(-1);
 DateTime dtEnd=System.today().addMonths(+1);
 Date DateStart=date.newinstance(dtStart.year(), dtStart.month(), dtStart.day());
 Date dateEnd=date.newinstance(dtEnd.year(), dtEnd.month(), dtEnd.day());
 Date firstDayOfLastMonth=DateStart.toStartOfMonth();
 Integer numberOfDays = Date.daysInMonth(dateEnd.year(), dateEnd.month());
 Date lastDayOfMonth = Date.newInstance(dateEnd.year(), dateEnd.month(), numberOfDays);
 Raid.MMPJ_TOPG_TechStartDate__c=firstDayOfLastMonth; 
 raid.MMPJ_TOPG_TechEndDate__c =lastDayOfMonth;
 SizeMultipicklist=15;        
getAllMarketsData();
   
}
private list<SelectOption> getAllMarketsData(){
 List <SelectOption> lstMarkets = new List <SelectOption>();
 Set <SelectOption>SetMarket = new Set<SelectOption>();  
    allMarkets.add(new SelectOption('All Markets', 'All Markets'));
   //  used befor Evol makert = BMC now  =>  for(MMPJ_TOPG_Market__c market : [SELECT Name FROM MMPJ_TOPG_Market__c order by name asc])
     for(MMPJ_TOPG_BMC__c bmc : [SELECT Name FROM MMPJ_TOPG_BMC__c order by name asc])
         allMarkets.add(new SelectOption(bmc.Name, bmc.Name));
         
return lstMarkets; 
}

public pageReference applySearch(){
actionDone=true;
system.debug(' in applySearch==');
if (raid!=null){
    StartDate=Raid.MMPJ_TOPG_TechStartDate__c;
    EndDate=Raid.MMPJ_TOPG_TechEndDate__c;  
}
Set <String> lstFilterMarket  = new Set <String>();
Set <String> lstFilterBrand  = new Set <String>(); 
String brandfilter ='';
String Marketfilter ='';    
    if (SelectedMarkets.size()>0){
        Marketfilter  = fitlerData(SelectedMarkets);
    }
 
system.debug('Start Date =='+startDate );
system.debug('End Date =='+EndDate );
system.debug('Marketfilter =='+Marketfilter );
   
    String varDecision ='Decision';
    String queryDecision='select id,name,'+
                            'MMPJ_TOPG_IsHighlight__c'+
                            ',MMPJ_TOPG_RAID__c'+
        					',MMPJ_TOPG_RelatedProject__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.name'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_NoAgenda__c'+        					
       						',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_End_Date__c'+                           
       						',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c'+ 
                             ',MMPJ_TOPG_WhoU__c'+
                            ',MMPJ_TOPG_WhoC__c'+
                            ',MMPJ_TOPG_Title__c'+
        					',MMPJ_TOPG_Action_Title__c '+
                            ',MMPJ_TOPG_Topic__c '+
                            ',MMPJ_TOPG_When__c '+
      						',MMPJ_TOPG_Detail_Line_Topic__c  '+
      						',MMPJ_TOPG_Comment__c  '+ 
                          	'from MMPJ_TOPG_MoMLineItem__c'+
                           ' where MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c>=:startDate'+
                           ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c<=:endDate '+
                           ' and MMPJ_TOPG_RAID__c=:varDecision';        
         if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
           queryDecision+= ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name in('+Marketfilter+')';
         }
                         
  queryDecision+=' order by MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c Desc '; 
  system.debug ('queryAction =='+queryDecision);
    if(!String.isEmpty(Marketfilter)){
         ListMoMLineItemDecisions=Database.query(queryDecision); 
    }
   
   String varInsight ='Insight';
  String queryInsight ='select id,name,'+
                            'MMPJ_TOPG_IsHighlight__c'+
                            ',MMPJ_TOPG_RAID__c'+
                            ',MMPJ_TOPG_RelatedProject__c'+
                           ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.name'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_NoAgenda__c'+        					
       						',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_End_Date__c'+                           
       						',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c'+ 
                             ',MMPJ_TOPG_WhoU__c'+
                            ',MMPJ_TOPG_WhoC__c'+
                            ',MMPJ_TOPG_Title__c'+
      						',MMPJ_TOPG_Action_Title__c '+
                            ',MMPJ_TOPG_Topic__c '+
                            ',MMPJ_TOPG_When__c '+
      						',MMPJ_TOPG_Detail_Line_Topic__c  '+
      						',MMPJ_TOPG_Comment__c  '+ 
                          'from MMPJ_TOPG_MoMLineItem__c'+
                           ' where MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c>=:startDate'+
                           ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c<=:endDate '+
                           ' and MMPJ_TOPG_RAID__c=:varInsight';
                           /* if (brandfilter!='' && !brandfilter.contains('All Brands') ){
                               queryRiskMeeting += ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Brand__r.name in('+brandfilter+')';
                             }   */
                             if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
                               queryInsight += ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name in('+Marketfilter+')';
                             }
     queryInsight +=' order by MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c Desc '; 
    if(!String.isEmpty(Marketfilter)){
         ListMoMLineItemInsights=Database.query(queryInsight);
    }
   
                                                               
return null;
}
private String fitlerData(List <selectOption> theList){
String result =' ';
for (SelectOption sel :theList){
        result+=  '\''+sel.getValue() +'\'';
    break;
    }
    if (theList.size()>1){
        for (SelectOption sel :theList){
            result+=  ',\''+sel.getValue() +'\'';
        }
    }
return result ;
}
}