public with sharing class MMPJ_TOPG_CockPitActionsController {
public DateTime StartDate{get;set;}
public DateTime EndDate{get;set;}
public list<SelectOption> AllMarkets{get;set;}
public list<SelectOption> SelectedMarkets{get;set;}
public list<SelectOption> AllBrands{get;set;}
public list<SelectOption> SelectedBrands{get;set;}
public list<MMPJ_TOPG_RAID__c > ListRaids{get;set;}
public list<MMPJ_TOPG_RAID__c > ListRaidsData{get;set;}
public list<Report> ListReports{get;set;}
public Map<String, Id> resultsReports{get;set;} 
public  MMPJ_TOPG_RAID__c Raid{get;set;}
public Integer SizeMultipicklist {get;set;}
Public Id reportId {get;set;}
Public String theFilter {get;set;}
Public String tempFilter {get;set;}
Public String MeetingFilter{get;set;}
Public Boolean ShowGraph{get;set;}
public String JsonMap{get;set;} 
//constructor
public MMPJ_TOPG_CockPitActionsController(){
 theFilter='';
 ShowGraph=false;
 resultsReports= new Map<String, Id>();
  SelectedMarkets= new list<selectoption>();
  SelectedBrands= new list<selectoption>();

 AllMarkets = new list<selectoption>();
 AllBrands = new list<selectoption>();
 Set<String> setOfSelectedBrands= new Set <String>();
 Set<String> setOfSelectedmarkets = new Set <String>();
 
  
 ListRaids = new list<MMPJ_TOPG_RAID__c>();
 ListRaidsData= new list<MMPJ_TOPG_RAID__c>();
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
 StartDate=raid.MMPJ_TOPG_TechStartDate__c;
 EndDate=raid.MMPJ_TOPG_TechEndDate__c;
  SizeMultipicklist=15;
   ListReports= [SELECT DeveloperName,id FROM Report WHERE DeveloperName in ('MMPJ_TOPG_RaidStatusPie','MMPJ_TOPG_RaidStatusInBars','MMPJ_TOPG_RaidTypes')];
   if (ListReports.size()>0){
       for (Report r : ListReports){
       resultsReports.put(r.DeveloperName,r.id);
       }
   }
   JsonMap=JSON.serialize(resultsReports); 
 // load data for raid object  to prepare Brands and Markets
//for(MMPJ_TOPG_RAID__c raid: [select id,name,MMPJ_TOPG_Highlight__c,MMPJ_TOPG_Market__c,MMPJ_TOPG_Brand__c from MMPJ_TOPG_RAID__c]){
     //ListRaids.add(raid);
  //   }        
getAllMarketsData();
getAllBrandsData();
String SelectedBrandParams=ApexPages.currentPage().getParameters().get('selectedBrands');
String SelectedMarketParams=ApexPages.currentPage().getParameters().get('selectedMarkets');
if (SelectedBrandParams!=null && SelectedBrandParams!=''){
      //setting selected brands
      system.debug('params brands ===='+SelectedBrandParams);
      for (String s :SelectedBrandParams.split(';')){
     selectedBrands.add(new SelectOption(s,s));
     setOfSelectedBrands.add(s);
     }
     //setting All brands
     system.debug('AllBrands ===='+AllBrands);
  }
  if (SelectedMarketParams!=null && SelectedMarketParams!=''){
      system.debug('params markets ===='+SelectedMarketParams);
      for (String marketName :SelectedMarketParams.split(';')){
          for(SelectOption tempMarket : AllMarkets){
           String tempMarketName=marketName.substring(0,marketName.indexOfIgnoreCase('_',0));
           system.debug('tempMarketName===='+tempMarketName);
           system.debug('tempMarket===='+tempMarketName);
            if(tempMarket.getLabel() == tempMarketName){
              selectedMarkets.add(new SelectOption(tempMarketName,tempMarketName));
                break;
            }
          }                   
     //selectedMarkets.add(new SelectOption(market ,market ));
     //setOfSelectedmarkets.add(market);
     }
  }  
}
public list<SelectOption> getAllMarketsData(){
 List <SelectOption> lstMarkets = new List <SelectOption>();
 Set <SelectOption>SetMarket = new Set<SelectOption>(); 
   /* if (ListRaids.size()>0)
     {
        for (MMPJ_TOPG_RAID__c raid :ListRaids)
        {
            if (raid.MMPJ_TOPG_Market__c!=null)
            {
               for (String m :raid.MMPJ_TOPG_Market__c.split(';'))
               {
                SetMarket.add(new SelectOption(m, m));  
              }
          }
        } 
         AllMarkets.addAll(SetMarket);
  
     }*/
     for(MMPJ_TOPG_Market__c market : [SELECT Name FROM MMPJ_TOPG_Market__c order by name asc])
         allMarkets.add(new SelectOption(market.Name, market.Name));
   
return lstMarkets; 
}
public list<SelectOption> getAllBrandsData(){
 List <SelectOption> lstBrands = new List <SelectOption>();
 Set <SelectOption> SetBrands = new Set<SelectOption>();
       for(MMPJ_TOPG_Brand__c brand : [SELECT Name FROM MMPJ_TOPG_Brand__c order by name asc])
        allBrands.add(new SelectOption(brand.Name, brand.Name));    
return lstBrands ; 
}

public PageReference applyFilter(){
String brandfilter ='';
String Marketfilter ='';
ShowGraph=true;
    if (SelectedBrands.size()>0){
        brandfilter  = fitlerData(SelectedBrands);
    }
    if (SelectedMarkets.size()>0){
        Marketfilter  = fitlerData(SelectedMarkets);
    }
  
   String dateS = StartDate.format('yyyy-MM-dd');
   String dateE = EndDate.format('yyyy-MM-dd');
    system.debug('brandfilter=='+brandfilter);
   system.debug('Marketfilter=='+Marketfilter);
   system.debug('dateS =='+dateS);
   system.debug('dateE =='+dateE );
theFilter='{column:\'MMPJ_TOPG_RAID__c.MMPJ_TOPG_ExpectedDate__c\', operator:\'greaterThan\', value:\''+dateS+'\'},'+
           '{column:\'MMPJ_TOPG_RAID__c.MMPJ_TOPG_ExpectedDate__c\', operator:\'lessThan\', value:\''+dateE+'\'}';
           if(brandfilter !='' && !brandfilter.contains('All Brands')){
               theFilter+=',{column:\'MMPJ_TOPG_RAID__c.MMPJ_TOPG_Brand__c\', operator:\'includes\', value:'+brandfilter+'}';
                
           }
           if(Marketfilter!='' && !Marketfilter.contains('All Markets')){
               theFilter+=',{column:\'MMPJ_TOPG_RAID__c.MMPJ_TOPG_Market__c\', operator:\'includes\', value:'+Marketfilter+'}';
               //theFilter+=',{column:\'MMPJ_TOPG_RAID__c.MMPJ_TOPG_Market__c\', operator:\'includes\', value:\'France,Italy,Spain\'}';
           }
           
   system.debug('theFilter ==='+theFilter) ;       
 //theFilter=JSON.serialize(tempFilter);
return null;
}
public String fitlerData(List <selectOption> theList){
String result ='\'';
for (SelectOption sel :theList){
        result+=sel.getValue();
    break;
    }
    if (theList.size()>1){
        for (SelectOption sel :theList){
            //result+=  ',\''+sel.getValue() +'\'';
             result+=','+sel.getValue();
        }
    }
 result +='\'';
system.debug('result=='+result );
return result ;
}
}