public with sharing class MMPJ_TOPG_ProjecttodoController {
    public string DestURL {get;set;} 
    public integer SaveComp{get;set;}
    public integer ShowSaveMessage_oldCounter = 0;
    public integer ShowSaveMessage_newCounter = 0;
    public boolean ShowSaveMessage{
        get{
            if(ShowSaveMessage_newCounter > ShowSaveMessage_oldCounter){
                ShowSaveMessage = true;
                ShowSaveMessage_newCounter = ShowSaveMessage_oldCounter;
            }
            else
                ShowSaveMessage = false;

            return ShowSaveMessage;
        }
        set;
    }
    public list<ChartWrapper> ListChart{get;set;}
    public PageReference ViewAll() {
        showLiveView = false;
        return null;
    }

   //============================================ LiveView disabled, on demande then not used now ==================//
   //
 /*   public PageReference LiveView() {
        showLiveView = true;
        ListChart = new list<ChartWrapper>();
        map<integer,ChartWrapper> mapMonthChart = new map<integer,ChartWrapper>();
        AggregateResult[] listRaids= [SELECT  calendar_month(MMPJ_TOPG_ExpectedDate__c) month,MMPJ_TOPG_Status__c,count(id) Nbr_id
                                      from MMPJ_TOPG_Raid__c
                                      where MMPJ_TOPG_Project__c =:project.id  
                                      group by calendar_month(MMPJ_TOPG_ExpectedDate__c),MMPJ_TOPG_Status__c];
        system.debug('&&&&&& listRaids ' + listRaids);
        for (AggregateResult ar : listRaids) 
        {
            if(mapMonthChart.containsKey((Integer)ar.get('month')))
            {
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'Planned')
                    mapMonthChart.get((Integer)ar.get('month')).nbr_Planned = (Integer)ar.get('Nbr_id');
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'On Going')
                    mapMonthChart.get((Integer)ar.get('month')).nbr_OnGoing = (Integer)ar.get('Nbr_id');
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'Done')
                    mapMonthChart.get((Integer)ar.get('month')).nbr_Done = (Integer)ar.get('Nbr_id');
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'Late')
                    mapMonthChart.get((Integer)ar.get('month')).nbr_Late = (Integer)ar.get('Nbr_id');
            }
            else
            {
                ChartWrapper ChartWrap = new ChartWrapper();
                datetime dT = date.newinstance(date.today().year(),(Integer)ar.get('month'),date.today().day());
                ChartWrap.MonthName = dT.format('MMM - dd');
                ChartWrap.nbr_OnGoing = 0 ;
                ChartWrap.nbr_Done = 0 ;
                ChartWrap.nbr_Planned = 0 ;
                ChartWrap.nbr_Late = 0 ;
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'Planned')
                    ChartWrap.nbr_Planned = (Integer)ar.get('Nbr_id');
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'On Going')
                    ChartWrap.nbr_OnGoing = (Integer)ar.get('Nbr_id');
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'Done')
                    ChartWrap.nbr_Done = (Integer)ar.get('Nbr_id');
                if((String)ar.get('MMPJ_TOPG_Status__c') == 'Late')
                    ChartWrap.nbr_Late = (Integer)ar.get('Nbr_id');
                mapMonthChart.put((Integer)ar.get('month'),ChartWrap);
            }
        }
        if(mapMonthChart.containskey(date.today().month() -1 ))
            ListChart.add(mapMonthChart.get(date.today().month() -1));
        else
        {
            ChartWrapper ChartWrap = new ChartWrapper();
            datetime dT = date.newinstance(date.today().year(),date.today().month() - 1,date.today().day());
            ChartWrap.MonthName = dT.format('MMM - dd');
            ChartWrap.nbr_OnGoing = 0 ;
            ChartWrap.nbr_Done = 0 ;
            ChartWrap.nbr_Planned = 0 ;
            ChartWrap.nbr_Late = 0 ;
            ListChart.add(ChartWrap);
        } 
        if(mapMonthChart.containskey(date.today().month()))
            ListChart.add(mapMonthChart.get(date.today().month()));
        else
        {
            ChartWrapper ChartWrap = new ChartWrapper();
            datetime dT = date.newinstance(date.today().year(),date.today().month(),date.today().day());
            ChartWrap.MonthName = dT.format('MMM - dd');
            ChartWrap.nbr_OnGoing = 0 ;
            ChartWrap.nbr_Done = 0 ;
            ChartWrap.nbr_Planned = 0 ;
            ChartWrap.nbr_Late = 0 ;
            ListChart.add(ChartWrap);
        } 
        if(mapMonthChart.containskey(date.today().month() + 1))
            ListChart.add(mapMonthChart.get(date.today().month() + 1));
        else
        {
            ChartWrapper ChartWrap = new ChartWrapper();
            datetime dT = date.newinstance(date.today().year(),date.today().month() + 1,date.today().day());
            ChartWrap.MonthName = dT.format('MMM - dd');
            ChartWrap.nbr_OnGoing = 0 ;
            ChartWrap.nbr_Done = 0 ;
            ChartWrap.nbr_Planned = 0 ;
            ChartWrap.nbr_Late = 0 ;
            ListChart.add(ChartWrap);
        }
        system.debug('$$$$$ ListChart' + ListChart);
        return null;
    } */


    //Passrd through an attribute attribute
    public MMPJ_TOPG_Project__c project{
        get;
        set{
            system.debug('projectID1 ==='+this.project );
            if(this.project == null){
                this.project = value;
                system.debug('projectID2 ==='+project.id);
                if(this.project.RAIDs__r != null)
                    listTodos = this.project.RAIDs__r;
                LoadTodo();         
            }   
        }
    }
    
    //Main List
    public list<MMPJ_TOPG_RAID__c> listTodos{get;set;}
    public list<MMPJ_TOPG_RAID__c> listTodos_todel{get;set;}
    
    //Table clicked todo Id
    public Integer SelectedTodoCounter{get;set;}
    
    //Popup Item
    public MMPJ_TOPG_RAID__c SelectedTodo{get;set;}
    public boolean ShowPopup{get;set;}
    public string SelectTodo_Responsible{get;set;}
    
    
    //Chart
    public boolean showLiveView{get;set;}
    /*public list<ChartWrapper> listChartWrappers{
        get{
            map<date, map<string, integer>> mapDate_Status_NbrTodos = new map<date, map<string, integer>>();
            for(MMPJ_TOPG_RAID__c todo : listTodos){
                if( todo.MMPJ_TOPG_ExpectedDate__c >= date.today().addmonths(-1).toStartOfMonth()
                    && todo.MMPJ_TOPG_ExpectedDate__c < date.today().addmonths(2).toStartOfMonth() ){
                    
                    map<string, integer> mapStatus_Nbr = new map<string, integer>();
                    if(mapDate_Status_NbrTodos.containskey(todo.MMPJ_TOPG_ExpectedDate__c)){
                         mapStatus_Nbr = mapDate_Status_NbrTodos.get(todo.MMPJ_TOPG_ExpectedDate__c);                                                  
                    }
                    
                    if(mapStatus_Nbr.containskey(todo.MMPJ_TOPG_Status__c)){
                        mapStatus_Nbr.put(todo.MMPJ_TOPG_Status__c, mapStatus_Nbr.get(todo.MMPJ_TOPG_Status__c) + 1);
                    }
                    else
                        mapStatus_Nbr.put(todo.MMPJ_TOPG_Status__c, 1);
                        
                    mapDate_Status_NbrTodos.put(todo.MMPJ_TOPG_ExpectedDate__c, mapStatus_Nbr);  
                }
            }
            
            return null;
        }
    }
    */
    public MMPJ_TOPG_ProjecttodoController(){
    // this variable is only so that the pdf open in a new window
        DestURL = '/apex/MMPJ_TOPG_VF03_ToDoPDF' ;  
        saveComp =0;
        listTodos = new list<MMPJ_TOPG_RAID__c>();
        listTodos_todel = new list<MMPJ_TOPG_RAID__c>();        
    }
    
    public  PageReference LoadTodo(){            
        //SelectedTodoCounter = null;
        list<Id> ListMomLineItemsID = new List<ID>();
        system.debug('listTodos  =='+listTodos );
        for(MMPJ_TOPG_RAID__c RAID :listTodos )
            if(RAID.MMPJ_TOPG_LineItem__c != null)
                ListMomLineItemsID.add(RAID.MMPJ_TOPG_LineItem__c);
         system.debug('ListMomLineItemsID =='+ListMomLineItemsID);       
         system.debug('Project =='+Project);
         //to be reviewed with Serouj 
        list<MMPJ_TOPG_MoMLineItem__c> ListMoMLineItems = new List<MMPJ_TOPG_MoMLineItem__c>();        
         if (project!=null && project.id!=null){
          ListMoMLineItems = [select MMPJ_TOPG_RAID__c,MMPJ_TOPG_Topic__c,MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.name,MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c,MMPJ_TOPG_WhoC__c,MMPJ_TOPG_WhoU__c,RecordType.Name,MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__c ,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_RelatedProject__c,MMPJ_TOPG_Title__c,MMPJ_TOPG_When__c,MMPJ_TOPG_IsHighlight__c,MMPJ_TOPG_Comment__c
                                                           from MMPJ_TOPG_MoMLineItem__c
                                                           Where RecordType.Name = 'Line Item Project' AND Id NOT IN:ListMomLineItemsID AND MMPJ_TOPG_RAID__c ='Action' AND MMPJ_TOPG_RelatedProject__c =:Project.id order by MMPJ_TOPG_When__c asc];
        }
        for(MMPJ_TOPG_RAID__c Todo : listTodos )
        {
            if(Todo .MMPJ_TOPG_Description__c != null && !string.isEmpty(Todo.MMPJ_TOPG_Description__c))
                Todo.MMPJ_TOPG_Desc__c = true;
            else
                Todo.MMPJ_TOPG_Desc__c = false;
        }
        if(ListMoMLineItems.size()>0)
        {
            for(MMPJ_TOPG_MoMLineItem__c MomLineItem : ListMoMLineItems )
            {
                MMPJ_TOPG_RAID__c RAIDum = new MMPJ_TOPG_RAID__c();
                RAIDum.MMPJ_TOPG_RAID__c = MomLineItem.MMPJ_TOPG_RAID__c;
                RAIDum.MMPJ_TOPG_Highlight__c = MomLineItem.MMPJ_TOPG_IsHighlight__c;
                RAIDum.MMPJ_TOPG_ExpectedDate__c = MomLineItem.MMPJ_TOPG_When__c;
                RAIDum.MMPJ_TOPG_Status__c = 'Planned';
                RAIDum.MMPJ_TOPG_Project__c = Project.id;
                RAIDum.MMPJ_TOPG_Description__c  = MomLineItem.MMPJ_TOPG_Comment__c;
                RAIDum.MMPJ_TOPG_LineItem__c = MomLineItem.id;
                RAIDum.MMPJ_TOPG_Meeting__c = MomLineItem.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__c ;
                if(RAIDum.MMPJ_TOPG_Description__c != null && !string.isEmpty(RAIDum.MMPJ_TOPG_Description__c))
                    RAIDum.MMPJ_TOPG_Desc__c = true;
                else
                    RAIDum.MMPJ_TOPG_Desc__c = false;
                RAIDum.MMPJ_TOPG_Title__c = MomLineItem.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__r.MMPJ_TOPG_Title__c;
                if(MomLineItem.MMPJ_TOPG_WhoU__c != null)
                    RAIDum.MMPJ_TOPG_User__c  = MomLineItem.MMPJ_TOPG_WhoU__c;
                else
                    RAIDum.MMPJ_TOPG_Contact__c  = MomLineItem.MMPJ_TOPG_WhoC__c;
                listTodos.add(RAIDum);
            }
        }
        return null;
    }    
    public void LeavingTODO()
    {
        try{
            SaveTodos();
        }
        catch(exception ex)
        {
            SaveComp=0;
        }
        SaveComp=1;
    }
    public PageReference SaveTodos() {
        list<MMPJ_TOPG_RAID__c> ListNewTODO = new list<MMPJ_TOPG_RAID__c>();
        Map<id,MMPJ_TOPG_RAID__c> MapIdRAID = new Map<id,MMPJ_TOPG_RAID__c>();
        list<task> ListTaskToInsert = new list<Task>();
        for(integer i = 0; i < listTodos.size(); i++){
            listTodos[i].MMPJ_TOPG_Rank__c = i; 
            if(listTodos[i].MMPJ_TOPG_Description__c != null && !string.isEmpty(listTodos[i].MMPJ_TOPG_Description__c))
                listTodos[i].MMPJ_TOPG_Desc__c = true;
            else
                listTodos[i].MMPJ_TOPG_Desc__c = false;   
            if(listTodos[i].id == null)
            {  
                listTodos[i].MMPJ_TOPG_Project__c = Project.id;
                ListNewTODO.add(listTodos[i]);
            }
            else
                MapIdRAID.put(listTodos[i].id,listTodos[i]);
        }
        if(ListNewTODO.size() > 0)
            insert ListNewTODO;
        upsert listTodos;
        if(ListNewTODO.size() > 0)
        {
            for(MMPJ_TOPG_RAID__c TODO : ListNewTODO)
            {
                Task Tache = new Task();
                if(TODO.MMPJ_TOPG_User__c != null)
                    Tache.OwnerId = TODO.MMPJ_TOPG_User__c;
                else
                    Tache.Whoid= TODO.MMPJ_TOPG_Contact__c;
                Tache.Description = TODO.MMPJ_TOPG_Description__c;
                Tache.ActivityDate = TODO.MMPJ_TOPG_ExpectedDate__c;
                Tache.WhatId = TODO.id;
                Tache.Status = TODO.MMPJ_TOPG_Status__c;
                Tache.Subject = TODO.MMPJ_TOPG_Title__c;
                Tache.MMPJ_TOPG_ProjectRaid__c = true;
                Tache.MMPJ_TOPG_ProjectChanged__c = true;
                ListTaskToInsert.add(Tache);
                MapIdRAID.put(TODO.id,TODO);
            }
        }
        List<Task> ListTaskExistant = [SELECT id, OwnerId, Description, ActivityDate, WhatId, Status, Subject, MMPJ_TOPG_ProjectRaid__c, MMPJ_TOPG_ProjectChanged__c
                                       FROM task
                                       WHERE WhatId in: MapIdRAID.keySet() AND MMPJ_TOPG_ProjectRaid__c = true];
        for(task Tache : ListTaskExistant)
        {
            if(MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_User__c != null)
            {
                Tache.OwnerId = MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_User__c;
                Tache.Whoid= null;
            }
            else
            {
                Tache.Whoid= MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_Contact__c;
                Tache.OwnerId = UserInfo.getUserId();
            }
            Tache.Description = MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_Description__c;
            Tache.ActivityDate = MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_ExpectedDate__c;
            Tache.Status = MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_Status__c;
            Tache.Subject = MapIdRAID.get(Tache.WhatId).MMPJ_TOPG_Title__c;
            if(Tache.MMPJ_TOPG_ProjectChanged__c == true)
                Tache.MMPJ_TOPG_ProjectChanged__c = false;
            else
                Tache.MMPJ_TOPG_ProjectChanged__c = true;
        }
        system.debug( '######3 ListTaskExistant ' + ListTaskExistant );
        system.debug( '######5 ListTaskToInsert ' + ListTaskToInsert );
        update ListTaskExistant;
        if(ListTaskToInsert.size() > 0)
            insert ListTaskToInsert;
        if(listTodos_todel.size() > 0)
            delete listTodos_todel;
        listTodos_todel = new list<MMPJ_TOPG_RAID__c>();
        ShowSaveMessage_newCounter++;
        LoadTodo();
        return null;
    }
    
    //TODO
    public PageReference PrintPdf() {
         //PageReference pagePDF= Page.MMPJ_TOPG_VF03_ToDoPDF;
         //pagePDF.getParameters().put('ProjectId', Project.id );
          //return pagePDF.setRedirect(true);  
        return null;
    }
            
    //Table Buttons
    public PageReference DelTodo() {
        MMPJ_TOPG_RAID__c todo_todel= listTodos.remove(SelectedTodoCounter);
        if(todo_todel.Id != null)
            listTodos_todel.add(todo_todel);            
        //LoadTodo();
        return null;
    }

    //TODO
    public PageReference EditTodo() {        
        SelectedTodo = listTodos.get(SelectedTodoCounter);
        if(SelectedTodo.MMPJ_TOPG_User__c  == null)
            SelectTodo_Responsible = 'Contact';
        else
            SelectTodo_Responsible = 'User';
        ShowPopup = true;
        //LoadTodo();
        return null;
    }

    public PageReference OpenNewToDo() {
        SelectedTodoCounter = null;
        SelectedTodo = new MMPJ_TOPG_RAID__c();
        SelectTodo_Responsible = 'User';
        ShowPopup = true;
        return null;
    }

    public PageReference MoveUpTodo() {
        if(SelectedTodoCounter > 0)
            listTodos.add(SelectedTodoCounter-1, listTodos.remove(SelectedTodoCounter));

        //LoadTodo();
        return null;
    }    


    public PageReference SaveSelectedTodo() {
        SelectedTodo.MMPJ_TOPG_Project__c = project.Id;
        //BTO=> TODO = always an action ?
        //SelectedTodo.MMPJ_TOPG_RAID__c = 'Action';
        system.debug('SelectedTodo.MMPJ_TOPG_Description__c :' + SelectedTodo.MMPJ_TOPG_Description__c );
        if(SelectedTodo.MMPJ_TOPG_Description__c != null && !string.isEmpty(SelectedTodo.MMPJ_TOPG_Description__c))
            SelectedTodo.MMPJ_TOPG_Desc__c = true;
        else
            SelectedTodo.MMPJ_TOPG_Desc__c = false;
        
        if(SelectTodo_Responsible == 'Contact')
            SelectedTodo.MMPJ_TOPG_User__c  = null;
        else
            SelectedTodo.MMPJ_TOPG_Contact__c  = null;
            
        //SelectedTodo.recalculateFormulas();
        if(SelectedTodoCounter == null)
        {
            SelectedTodo.MMPJ_TOPG_Rank__c = listTodos.size();
            listTodos.add(SelectedTodo);
        }
        else
            listTodos.set(SelectedTodoCounter, SelectedTodo);
        
        boolean isNew = false;
        if(SelectedTodo.id == null)
            isNew = true;
        upsert SelectedTodo;
        if(isNew)
        {
            Task Tache = new Task();
            if(SelectedTodo.MMPJ_TOPG_User__c != null)
                Tache.OwnerId = SelectedTodo.MMPJ_TOPG_User__c;
            else
                Tache.Whoid= SelectedTodo.MMPJ_TOPG_Contact__c;
            Tache.Description = SelectedTodo.MMPJ_TOPG_Description__c;
            Tache.ActivityDate = SelectedTodo.MMPJ_TOPG_ExpectedDate__c;
            Tache.WhatId = SelectedTodo.id;
            Tache.Status = SelectedTodo.MMPJ_TOPG_Status__c;
            Tache.Subject = SelectedTodo.MMPJ_TOPG_Title__c;
            Tache.MMPJ_TOPG_ProjectRaid__c = true;
            Tache.MMPJ_TOPG_ProjectChanged__c = true;
            insert Tache; 
            system.debug('##### Tache ' + Tache);  
        }
        if(!isNew)
        {
            List<Task> ListTaskExistant = [SELECT id, OwnerId, Description, ActivityDate, WhatId, Status, Subject, MMPJ_TOPG_ProjectRaid__c, MMPJ_TOPG_ProjectChanged__c
                                           FROM task
                                           WHERE WhatId =: SelectedTodo.id AND MMPJ_TOPG_ProjectRaid__c = true];
            for(task Tache : ListTaskExistant)
            {
                if(SelectedTodo.MMPJ_TOPG_User__c != null)
                {
                    Tache.OwnerId = SelectedTodo.MMPJ_TOPG_User__c;
                    Tache.Whoid= null;
                }
                else
                {
                    Tache.Whoid= SelectedTodo.MMPJ_TOPG_Contact__c;
                    Tache.OwnerId = UserInfo.getUserId();
                }
                Tache.Description = SelectedTodo.MMPJ_TOPG_Description__c;
                Tache.ActivityDate = SelectedTodo.MMPJ_TOPG_ExpectedDate__c;
                Tache.Status = SelectedTodo.MMPJ_TOPG_Status__c;
                Tache.Subject = SelectedTodo.MMPJ_TOPG_Title__c;
                if(Tache.MMPJ_TOPG_ProjectChanged__c == true)
                    Tache.MMPJ_TOPG_ProjectChanged__c = false;
                else
                    Tache.MMPJ_TOPG_ProjectChanged__c = true;
            }
            update ListTaskExistant;
            system.debug('##### ListTaskExistant ' + ListTaskExistant);
        }
        ShowPopup = false;
        return null;
    }
    
    public PageReference CancelSelectedTodo() {
        ShowPopup = false;
        return null;
    }
    
    //Chart Wrapper
    class ChartWrapper{
        public Date ExpectedDate{get;set;}
        public string Status{get;set;}
        public string MonthName{get;set;}
        public integer nbr_Planned{get;set;}
        public integer nbr_OnGoing{get;set;}
        public integer nbr_Done{get;set;}
        public integer nbr_Late{get;set;}
    }
}