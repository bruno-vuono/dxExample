public class MMPJ_TOPG_CockPitRiskActionController { 
public Date StartDate{get;set;}
public Date EndDate{get;set;}  
public list<SelectOption> AllMarkets{get;set;}
public list<SelectOption> SelectedMarkets{get;set;}
public list<SelectOption> AllBrands{get;set;}
public list<SelectOption> TotalBrand{get;set;}
public list<SelectOption> SelectedBrands{get;set;}
public list<MMPJ_TOPG_RAID__c > ListRaids{get;set;} 
public list<MMPJ_TOPG_MoMLineItem__c > ListMoMLineItemAction{get;set;} 
public list<MMPJ_TOPG_RAID__c > ListHighlightedRaids{get;set;}
public list<MMPJ_TOPG_RAID__c > ListActionRaids{get;set;}
public map<String,MMPJ_TOPG_RAID__c > mapListActionRaids{get;set;}
public list<MMPJ_TOPG_RAID__c > ListRiskedRaids{get;set;}
public list<MMPJ_TOPG_MoMLineItem__c> ListRiskedmeetings{get;set;}
public list<MMPJ_TOPG_MoMLineItem__c> ListHighlightMeetings{get;set;}
public  MMPJ_TOPG_RAID__c Raid{get;set;}
public Integer SizeMultipicklist {get;set;}
public Boolean actionDone{get;set;}

public list<SelectOption> listBrands{
        get;
        set{    
            system.debug('valueeeeeee =='+value);        
            if(value != null && value.size() > 0 /* && listBrands == null*/ ){
                listBrands = value;

                SelectedBrands.clear();
              system.debug('AllBrands ==='+AllBrands);
                system.debug('listBrands==='+listBrands);
                for(SelectOption tempBrand : AllBrands){
                    for(SelectOption tempBrand2 : listBrands){
                        if(tempBrand.getLabel() == tempBrand2.getLabel()){
                           SelectedBrands.add(tempBrand);
                            break;
                        }
                    }
                }
               
            }
        }
    }
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
                    system.debug('SelectedBrands==='+SelectedMarkets);
        }
    }}
 //constructor   
public MMPJ_TOPG_CockPitRiskActionController (){
 AllMarkets = new list<selectoption>();
 AllBrands = new list<selectoption>();
 TotalBrand = new list<selectoption>();
 SelectedMarkets= new list<selectoption>();
 SelectedBrands= new list<selectoption>();
 ListHighlightedRaids= new list<MMPJ_TOPG_RAID__c>();
 ListActionRaids= new list<MMPJ_TOPG_RAID__c>();
 ListRiskedRaids= new list<MMPJ_TOPG_RAID__c>();
 ListRiskedmeetings = new list<MMPJ_TOPG_MoMLineItem__c>();
 ListHighlightMeetings = new list<MMPJ_TOPG_MoMLineItem__c>();
 ListRaids = new list<MMPJ_TOPG_RAID__c>();
 ListMoMLineItemAction = new list<MMPJ_TOPG_MoMLineItem__c>();
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
// load data for raid object  
for(MMPJ_TOPG_RAID__c raid: [select id ,name,MMPJ_TOPG_Highlight__c,MMPJ_TOPG_Market__c,MMPJ_TOPG_Brand__c from MMPJ_TOPG_RAID__c]){
     ListRaids.add(raid);
     }        
getAllMarketsData();
getAllBrandsData();     
}
public list<SelectOption> getAllMarketsData(){
 List <SelectOption> lstMarkets = new List <SelectOption>();
 Set <SelectOption>SetMarket = new Set<SelectOption>();     
    allMarkets.add(new SelectOption('All Markets', 'All Markets'));
   //  used befor Evol makert = BMC now  =>  for(MMPJ_TOPG_Market__c market : [SELECT Name FROM MMPJ_TOPG_Market__c order by name asc])
     for(MMPJ_TOPG_BMC__c bmc : [SELECT Name FROM MMPJ_TOPG_BMC__c order by name asc])
         allMarkets.add(new SelectOption(bmc.Name, bmc.Name));
         
return lstMarkets; 
}
public list<SelectOption> getAllBrandsData(){
 List <SelectOption> lstBrands = new List <SelectOption>();
 Set <SelectOption> SetBrands = new Set<SelectOption>(); 
  
      for(MMPJ_TOPG_Brand__c brand : [SELECT Name FROM MMPJ_TOPG_Brand__c order by name asc])
        allBrands.add(new SelectOption(brand.Name, brand.Name));
return lstBrands ; 
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
    if (SelectedBrands.size()>0){
        brandfilter  = fitlerData(SelectedBrands);
    }
    if (SelectedMarkets.size()>0){
        Marketfilter  = fitlerData(SelectedMarkets);
    }
 
system.debug('Start Date =='+startDate );
system.debug('End Date =='+EndDate );
system.debug('Marketfilter =='+Marketfilter );
system.debug('brandfilter =='+brandfilter );

  String VarRisk ='Risk';
  String queryRiskMeeting ='select id,name,'+
                            'MMPJ_TOPG_IsHighlight__c'+
                            ',MMPJ_TOPG_RAID__c'+
                            ',MMPJ_TOPG_RelatedProject__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.name'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_NoAgenda__c'+
      						',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c '+
                             ',MMPJ_TOPG_WhoU__c'+
                            ',MMPJ_TOPG_WhoC__c'+
                            ',MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_Topic__c '+
                            ',MMPJ_TOPG_When__c '+
      						',MMPJ_TOPG_Detail_Line_Topic__c  '+
      						',MMPJ_TOPG_Comment__c  '+ 
                          'from MMPJ_TOPG_MoMLineItem__c'+
                           ' where MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c>=:startDate'+
                           ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c<=:endDate '+
                           ' and MMPJ_TOPG_RAID__c=:VarRisk';
                           /* if (brandfilter!='' && !brandfilter.contains('All Brands') ){
                               queryRiskMeeting += ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Brand__r.name in('+brandfilter+')';
                             }   */
                             if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
                               queryRiskMeeting += ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name in('+Marketfilter+')';
                             }
     queryRiskMeeting +=' order by MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c  Desc '; 
     if(!String.isEmpty(Marketfilter)){
          ListRiskedmeetings=Database.query(queryRiskMeeting);  
    }
    
String query='select id,name'+
            ',MMPJ_TOPG_Title__c'+
            ',MMPJ_TOPG_Highlight__c'+
            ',MMPJ_TOPG_Contact__c'+
            ',MMPJ_TOPG_Responsible__c'+
            ',MMPJ_TOPG_User__c'+
            ',MMPJ_TOPG_ExpectedDate__c'+
            ',MMPJ_TOPG_Flag__c'+
            ',MMPJ_TOPG_Market__c'+ 
            ',MMPJ_TOPG_Brand__c'+
            ',MMPJ_TOPG_Status__c'+
            ',MMPJ_TOPG_Meeting__c'+
            ',MMPJ_TOPG_Project__c'+
    		',MMPJ_TOPG_LineItem__r.id'+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_Detail_Line_Topic__c '+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Title__c '+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name '+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c'+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_NoAgenda__c '+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c'+
    		',MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_End_Date__c'+
    		',MMPJ_TOPG_Description__c'+
            ' from MMPJ_TOPG_RAID__c'+            
            ' where MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c>=:startDate'+     		
            ' and MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c <=:EndDate ';        
         if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
           query += ' and MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name in('+Marketfilter+')';
         }
                         
  query +=' order by  MMPJ_TOPG_LineItem__r.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_EndDate__c  Desc ';
  system.debug('query == '+query);
     if(!String.isEmpty(Marketfilter)){
          ListActionRaids  = Database.query(query);  
          system.debug('ListActionRaids == '+ListActionRaids);
    }
  
/*BTO: Begin> ==================================================Not use y ================================================================ 

String queryRisk='select id,name'+
            ',MMPJ_TOPG_Title__c'+
            ',MMPJ_TOPG_Highlight__c'+
            ',MMPJ_TOPG_Contact__c'+
            ',MMPJ_TOPG_Responsible__c'+
            ',MMPJ_TOPG_User__c'+
            ',MMPJ_TOPG_ExpectedDate__c'+
            ',MMPJ_TOPG_Flag__c'+
            ',MMPJ_TOPG_Market__c'+ 
            ',MMPJ_TOPG_Brand__c'+
            ',MMPJ_TOPG_Status__c'+
            ',MMPJ_TOPG_Meeting__c'+
            ',MMPJ_TOPG_Project__c'+  
            ' from MMPJ_TOPG_RAID__c'+
            ' where MMPJ_TOPG_RAID__c=:VarRisk '+
            ' and MMPJ_TOPG_ExpectedDate__c >=:startDate'+
            ' and MMPJ_TOPG_ExpectedDate__c <=:EndDate';
        
         if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
           queryRisk+= ' and MMPJ_TOPG_Market__c includes('+Marketfilter+')';
         }
                         
  queryRisk+=' order by createdDate Desc '; 
  system.debug ('queryRisk =='+queryRisk);
      if(!String.isEmpty(Marketfilter)){
          ListRiskedRaids=Database.query(queryRisk);  
    }
  
   
    String varAction ='Action';
    String queryAction='select id,name,'+
                            'MMPJ_TOPG_IsHighlight__c'+
                            ',MMPJ_TOPG_RAID__c'+
        					',MMPJ_TOPG_RelatedProject__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.name'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_NoAgenda__c'+
                             ',MMPJ_TOPG_WhoU__c'+
                            ',MMPJ_TOPG_WhoC__c'+
                            ',MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_Topic__c '+
                            ',MMPJ_TOPG_When__c '+
      						',MMPJ_TOPG_Detail_Line_Topic__c  '+
      						',MMPJ_TOPG_Comment__c  '+ 
                          	'from MMPJ_TOPG_MoMLineItem__c'+
                           ' where MMPJ_TOPG_When__c>=:startDate'+
                           ' and MMPJ_TOPG_When__c<=:endDate '+
                           ' and MMPJ_TOPG_RAID__c=:varAction';        
         if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
           queryAction+= ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name in('+Marketfilter+')';
         }
                         
  queryAction+=' order by createdDate Desc '; 
  system.debug ('queryAction =='+queryAction);
     if(!String.isEmpty(Marketfilter)){
          ListMoMLineItemAction=Database.query(queryAction);   
    }
   
   String queryhighMeeting ='select id,name,'+
                            'MMPJ_TOPG_IsHighlight__c'+
                            ',MMPJ_TOPG_RAID__c'+
                            ',MMPJ_TOPG_RelatedProject__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_NoAgenda__c'+
                            ',MMPJ_TOPG_Title__c'+
                            ',MMPJ_TOPG_WhoU__c'+
                            ',MMPJ_TOPG_WhoC__c'+
                            ',MMPJ_TOPG_Topic__c '+
                            ',MMPJ_TOPG_When__c '+
       						',MMPJ_TOPG_Comment__c '+
       						',MMPJ_TOPG_Action_Title__c '+ 
       						',MMPJ_TOPG_Detail_Line_Topic__c '+        						
                          'from MMPJ_TOPG_MoMLineItem__c'+
                           ' where MMPJ_TOPG_IsHighlight__c=true'+
                           ' and MMPJ_TOPG_When__c>=:startDate'+
                           ' and MMPJ_TOPG_When__c<=:endDate ';
                           
                             if (Marketfilter!='' && !Marketfilter.contains('All Markets')){
                               queryhighMeeting += ' and MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_BMC__r.name in ('+Marketfilter+')';
                             }
     queryhighMeeting +=' order by createdDate Desc '; 
                            
   if(!String.isEmpty(Marketfilter)){
          ListHighlightMeetings=Database.query(queryhighMeeting);  
    }
           
==================================================Not use================================================================*/                 
                                                               
return null;
}
public String fitlerData(List <selectOption> theList){
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