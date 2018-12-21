public with sharing class MMPJ_TOPG_CockPitInteractionController {

    
	public list<Event> listInteractions;
    public list<Event> listCalls;
    public list<MMPJ_TOPG_Visit__c> listVisits;
    public MMPJ_TOPG_RAID__c filterRAID{get;set;}
    public Boolean actionDone{get;set;}
    public Boolean mapIsEmpty{get;set;}
    public date SelectedDate{
        get{
            return filterRAID.MMPJ_TOPG_Tech_FocusDate__c;
        }
        set{
            if(value != null){        
                SelectedDate = value;
                LoadCalendar();
            }
        }
    }        
    
    public List<SelectOption> allBrands
    {
            get
            {
                if(allBrands == null)
                {
                    allBrands = new List<SelectOption>();
                    for(MMPJ_TOPG_Brand__c brand : [SELECT Name FROM MMPJ_TOPG_Brand__c order by name asc])
                        allBrands.add(new SelectOption(brand.Id, brand.Name));
                }
                return allBrands;
            }
            set;
    }
    
    public List<SelectOption> selectedBrands
    {
        get
        {
            if(selectedBrands == null)
            {
                selectedBrands = new List<SelectOption>();
            }
            else{
            
            }
            return selectedBrands;
        }
        set;
    }
    public String AllMarketsId {get;set;}
    public List<SelectOption> allMarkets
    {
        get
        {
            if(allMarkets == null)
            {
                allMarkets = new List<SelectOption>();
                allMarkets.add(new SelectOption('All Markets', 'All Markets'));
                AllMarketsId = 'All Markets';
                for(MMPJ_TOPG_BMC__c bmc : [SELECT Name FROM MMPJ_TOPG_BMC__c order by name asc]){
                      allMarkets.add(new SelectOption(bmc.Name, bmc.Name));
                /*if(bmc.Name == 'All Markets')
                    AllMarketsId = bmc.Id;*/
                }
            }
            return allMarkets;
        }
        set;
    }
    public List<SelectOption> selectedMarkets
    {
        get
        {
            if(selectedMarkets == null)
                selectedMarkets = new List<SelectOption>();
            return selectedMarkets;
        }
        set;
    }
    
    
    public list<SelectOption> listBrands{
        get;
        set{            
            if(value != null && value.size() > 0 /* && listBrands == null*/ ){
                listBrands = value;
                selectedBrands.clear();
                for(SelectOption tempBrand : allBrands){
                    for(SelectOption tempBrand2 : listBrands){
                        if(tempBrand.getLabel() == tempBrand2.getLabel()){
                            selectedBrands.add(tempBrand);
                            break;
                        }
                    }
                }                               
                
                if(listMarkets != null && listMarkets.size() > 0){
                    LoadItems(FirstDay, LastDay);
                }
            }
        }
    }
    public list<SelectOption> listMarkets{
        get;
        set{            
            if(value != null && value.size() > 0 /*&& listMarkets == null*/ ){
                listMarkets = value;
                selectedMarkets.clear();
                for(SelectOption tempMarket : allMarkets){
                    for(SelectOption tempMarket2 : listMarkets){
                        String marketName=tempMarket2.getLabel();
                        Integer theIndex =marketName.indexOfIgnoreCase(' ',0);
                        String  tempMarketName='';
                        if (theIndex != -1){
                        tempMarketName=marketName.substring(0,theIndex);
                        }
                        if(tempMarket.getLabel() == tempMarketName){
                            selectedMarkets.add(tempMarket);
                            break;
                        }
                    }
                }
               
                if(listBrands != null && listBrands.size() > 0)
                    LoadItems(FirstDay, LastDay);
            }
        }
    }
    
    public date FirstDay{
        get{
            if(SelectedDate != null)
                FirstDay = SelectedDate.toStartOfWeek().adddays(-12*7);
            return FirstDay;            
        }
        private set;
    }
    
    public date LastDay{
        get{
            if(SelectedDate != null)
                LastDay = SelectedDate.toStartOfWeek().adddays(12*8-1);
            return LastDay;       
        }
        private set;
    }
    
    
    public map<integer, string> monthnames{get;set;}
    
    public map<string, list<itemwrapper>> mapWeek_Items{get;set;}    
    public void LoadItems(date startDate, date endDate){
        system.debug('### LoadItems Start');
        system.debug('### startDate : ' + startDate);
        system.debug('### endDate : ' + endDate);
        mapWeek_Items = new map<string, list<itemwrapper>>();
        
        integer first_week_number = integer.valueof(datetime.newinstance(FirstDay,Time.newInstance(0, 0, 0, 0)).Format('w')); 
        integer last_week_number = integer.valueof(datetime.newinstance(LastDay,Time.newInstance(0, 0, 0, 0)).Format('w')); 
        for(integer i = 0; i<= 53; i++){
            mapWeek_Items.put(string.valueof(i), new list<itemwrapper>());
        }
        
        set<String> setBrands = new set<String>();
        set<String> setMarkets = new set<String>();
        
        for(SelectOption myopt : selectedBrands){
            setBrands.add(myopt.getValue());
        }
        for(SelectOption myopt : selectedMarkets){
            setMarkets.add(myopt.getValue());
        }
        
        system.debug('### setBrands: ' + setBrands);
        system.debug('### setMarkets: ' + setMarkets);
        
        //Select Physical
        string strBrands_Condition =  '';
      /*  if(setBrands.size() > 0  && !setBrands.contains(AllMarketsId))
            strBrands_Condition = '  AND MMPJ_TOPG_BMC__r.MMPJ_TOPG_Brand__c IN :setBrands';*/
        
        string strMarkets_Condition = '';
        if(setMarkets.size() > 0  && !setMarkets.contains(AllMarketsId) ){
            strMarkets_Condition = '  AND MMPJ_TOPG_BMC__r.Name IN :setMarkets';
        }/*else if(setMarkets.size() > 0  && setMarkets.contains(AllMarketsId) ) {
            strMarkets_Condition = '  AND MMPJ_TOPG_BMC__r.id =:'(+AllMarketsId+)';
        }*/
        
        string strInteractions_Query = 'SELECT Id, Subject, OwnerId, Owner.Name, WhatId, StartDateTime'
        + ' FROM Event'
        + ' WHERE WhatId IN (SELECT Id FROM MMPJ_TOPG_Meeting__c '
        + '  WHERE MMPJ_TOPG_Interaction__c = \'Physical interaction\''
        + strMarkets_Condition
       // + strBrands_Condition
        + '  )'
        + ' AND StartDateTime >= :startDate '
        + ' AND StartDateTime <= :endDate'
        + ' ORDER BY StartDateTime';
        
        system.debug('### strInteractions_Query: ' + strInteractions_Query);
        if(setMarkets.size() > 0 || setBrands.contains(AllMarketsId))
        listInteractions = (list<Event>) database.query(strInteractions_Query);
         
         system.debug('### listInteractions: ' + listInteractions);
         set<Id> setUniqueMeetings = new set<Id>();
         for(Event myEvent : listInteractions){
             if(!setUniqueMeetings.contains(myEvent.WhatId)){
                 setUniqueMeetings.add(myEvent.WhatId);
                 string tempweek = myEvent.StartDateTime.Format('w');
                 itemwrapper tempItem = new itemwrapper(myEvent.StartDateTime.date(), 'M', myEvent.Subject + ' / ' + myEvent.Owner.Name + ' / ' + myEvent.StartDateTime.Format('dddd dd-MM-yyyy hh:mm'), '/apex/MMPJ_TOPG_NewMeeting?Id=' + myEvent.WhatId + '&tabName=Agenda', myEvent.Id);             
                 mapWeek_Items.get(tempweek).add(tempItem);
             }
             
         }
                                               
                
        
        string strCalls_Query = 'SELECT Id, Subject, OwnerId, Owner.Name, WhatId, StartDateTime'
        + ' FROM Event'
        + ' WHERE WhatId IN (SELECT Id FROM MMPJ_TOPG_Meeting__c '
        + '  WHERE MMPJ_TOPG_Interaction__c = \'Call\''
        + strMarkets_Condition
        //+ strBrands_Condition
        + '  )'
        + ' AND StartDateTime >= :startDate '
        + ' AND StartDateTime <= :endDate'
        + ' ORDER BY StartDateTime';
        
        system.debug('### strCalls_Query: ' + strCalls_Query);
         if(setMarkets.size() > 0 || setBrands.contains(AllMarketsId))
        listCalls = (list<Event>) database.query(strCalls_Query);        
        system.debug('### listCalls : ' + listCalls);
        
        set<Id> setUniqueMeetings2 = new set<Id>();
        for(Event myEvent : listCalls){
            if(!setUniqueMeetings2.contains(myEvent.WhatId)){
                setUniqueMeetings2.add(myEvent.WhatId);
                string tempweek = myEvent.StartDateTime.Format('w');
                itemwrapper tempItem = new itemwrapper(myEvent.StartDateTime.date(), 'C', myEvent.Subject + ' / ' + myEvent.Owner.Name + ' / ' + myEvent.StartDateTime.Format('dddd dd-MM-yyyy hh:mm'), '/apex/MMPJ_TOPG_NewMeeting?Id=' + myEvent.WhatId + '&tabName=Agenda', myEvent.Id);
                mapWeek_Items.get(tempweek).add(tempItem);
            }
         }
         
        //Select Visits
        
        string strVisits_Query = 'SELECT Id, MMPJ_TOPG_Outlet__r.Name, MMPJ_TOPG_StatementDate__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Meeting__c, Owner.Name'
        + ' FROM MMPJ_TOPG_Visit__c'
        + ' WHERE MMPJ_TOPG_StatementDate__c >= :startDate'
        + ' AND MMPJ_TOPG_StatementDate__c <= :endDate'
       // + strBrands_Condition
        + strMarkets_Condition;
        
        system.debug('### strVisits_Query: ' + strVisits_Query);
        if(setMarkets.size() > 0 || setBrands.contains(AllMarketsId))
        listVisits = (list<MMPJ_TOPG_Visit__c>) database.query(strVisits_Query);         
        system.debug('### listVisits : ' + listVisits);
        
        for(MMPJ_TOPG_Visit__c visit : listVisits){
             string tempweek = datetime.newinstance(visit.MMPJ_TOPG_StatementDate__c,Time.newInstance(0, 0, 0, 0)).Format('w');
             itemwrapper tempItem = new itemwrapper(visit.MMPJ_TOPG_StatementDate__c, 'V', visit.MMPJ_TOPG_Outlet__r.Name + ' / ' + visit.Owner.Name + ' / ' + datetime.newinstance(visit.MMPJ_TOPG_StatementDate__c,Time.newInstance(0, 0, 0, 0)).Format('dddd dd-MM-yyyy'), '/apex/MMPJ_TOPG_NewMeeting?Id=' + visit.MMPJ_TOPG_Meeting__c + '&tabName=Visits', visit.Id);
             mapWeek_Items.get(tempweek).add(tempItem);             
         }
         if (listVisits.size()==0 && listCalls.size()==0 && listInteractions.size()==0){
          mapIsEmpty=true;
         }
         else {
          mapIsEmpty=false;
         }
    }
    
    public PageReference Apply_Filter() {
        actionDone=true;
        LoadCalendar();
        LoadItems(FirstDay, LastDay);
        system.debug('### mapIsEmpty: ' + mapIsEmpty);
         system.debug('### actionDone: ' + actionDone);
        return null;
    }
    
    public list<calendarwrapper> listCalendarBefore{get;set;}
    public list<calendarwrapper> listCalendarAfter{get;set;}
    public set<integer> mapCalendarBeforeKeys{
        get{
            return mapCalendarBefore.keyset();
        }
        set;
    }
    public map<integer, integer> mapCalendarBefore{get;set;}
    public set<integer> mapCalendarAfterKeys{
        get{
            return mapCalendarAfter.keyset();
        }
        set;
    }
    public map<integer, integer> mapCalendarAfter{get;set;}
    
    public MMPJ_TOPG_CockPitInteractionController (){
        listInteractions = new list<Event>();
        listCalls = new list<Event>();
        listVisits = new list<MMPJ_TOPG_Visit__c>();
        filterRAID = new MMPJ_TOPG_RAID__c(MMPJ_TOPG_Tech_FocusDate__c = date.today());
        monthnames = new map<integer, string>{ 
            1=> 'January', 
            2=> 'February', 
            3=> 'March', 
            4=> 'April', 
            5=> 'May', 
            6=> 'June', 
            7=> 'July', 
            8=> 'August', 
            9=> 'September', 
            10=> 'October', 
            11=> 'November',     
            12=> 'December'};
        
        SelectedDate = date.today();
    }
    
    public PageReference LoadCalendar(){
        system.debug('>>> LoadCalendar Start <<<');
        listCalendarBefore = new list<calendarwrapper>();
        listCalendarAfter = new list<calendarwrapper>();
        mapCalendarBefore = new map<integer, integer>();
        mapCalendarAfter = new map<integer, integer>();
        
        date SelectedDate_Start = SelectedDate.toStartOfWeek();
        
        for(integer i=0 ; i<12; i++){
            
            //Weeks Before
            listCalendarBefore.add(new calendarwrapper(SelectedDate_Start.adddays(-(12-i)*7)));
            
            //Weeks after
            listCalendarAfter.add(new calendarwrapper(SelectedDate_Start.adddays(i*7)));
        }
        
        
        for(calendarwrapper cw : listCalendarBefore){
            if(mapCalendarBefore.containskey(cw.month))
                mapCalendarBefore.put(cw.month, mapCalendarBefore.get(cw.month) + cw.mcolspan);
            else
                mapCalendarBefore.put(cw.month, cw.mcolspan);
                
            if(cw.mcolspan == 1){
                integer temp_nextmonth = math.mod(cw.month + 1 , 12);
                if(temp_nextmonth == 0) temp_nextmonth = 12;
                if(mapCalendarBefore.containskey(temp_nextmonth ))
                    mapCalendarBefore.put(temp_nextmonth , mapCalendarBefore.get(temp_nextmonth) + cw.mcolspan);
                else
                    mapCalendarBefore.put(temp_nextmonth, cw.mcolspan);
            }
        }
        for(calendarwrapper cw : listCalendarAfter){
            if(mapCalendarAfter.containskey(cw.month))
                mapCalendarAfter.put(cw.month, mapCalendarAfter.get(cw.month) + cw.mcolspan);
            else
                mapCalendarAfter.put(cw.month, cw.mcolspan);
                
            if(cw.mcolspan == 1){
                integer temp_nextmonth = math.mod(cw.month + 1 , 12);
                if(temp_nextmonth == 0) temp_nextmonth = 12;
                if(mapCalendarAfter.containskey(temp_nextmonth))
                    mapCalendarAfter.put(temp_nextmonth, mapCalendarBefore.get(cw.month + 1) + cw.mcolspan);
                else
                    mapCalendarAfter.put(temp_nextmonth, cw.mcolspan);
            }
        }
        return null;
    }
    
    class calendarwrapper{
        public date srartingweek{get;set;}
        public calendarwrapper(date thesrartingweek){
            srartingweek =  thesrartingweek;                        
       }
        
        public integer month{
            get{
                if(srartingweek != null)
                    return srartingweek.month();
                return null;
            }
            set;
        }
        public string week{
            get{
                if(srartingweek != null)
                    return datetime.newinstance(srartingweek,Time.newInstance(0, 0, 0, 0)).Format('w');
                return null;
            }
            set;
        }
        public integer mcolspan{
            get{
                if(srartingweek != null){
                    if(srartingweek.month() != srartingweek.adddays(6).month() )
                        return 1;
                }
                return 2;
            }
            set;
        }
    }
    
    class itemwrapper{
        public date thedate{get;set;}
        public string eventname{get;set;}
        public string hovermessage{get;set;}
        public string link{get;set;}
        public string itemId{get;set;}
        
        public itemwrapper(date mydate, string myname, string mymessage, string mylink, string myId){
            thedate = mydate;
            eventname= myname;
            hovermessage = mymessage;
            link = mylink;
            itemId = myId;
        }
    }

}