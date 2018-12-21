public with sharing class MMPJ_TOPG_NewMeetingController {
    public List <User> AllUsers{get;set;}
    public List <Contact> AllContacts{get;set;}
    public Id BMCID_param{
        get{
            if(!string.isblank(ApexPages.currentPage().getParameters().get('BMCID')))
                BMCID_param = ApexPages.currentPage().getParameters().get('BMCID');
            return BMCID_param;
        }
        set;
    }
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
    public string SuccessMessage{get;set;}
    public string agendastartdate{
        get{
            if(Agenda!=null)
                return string.valueof(Agenda.StartDateTime);
            return '';
        }
    }
    public MMPJ_TOPG_NewMeetingController(ApexPages.StandardController controller) {
        system.debug('Page Controller');
        if (AllUsers==null || AllUsers.size()==0){
        AllUsers = new List<User>();
        //AllUsers=[SELECT id,Title,email FROM User];
        }
        if (AllContacts==null || AllContacts.size()==0){
        AllContacts = new List<Contact>();
        //AllContacts =[SELECT id,Title,email FROM Contact];
        }
        DisplayPopupBackground = false;
        SuccessMessage ='';
        saveComplete= 0;
        string TabName = ApexPages.currentPage().getParameters().get('TabName');
        if(String.IsBlank(TabName ))
            newTab = 'Agenda';
        else
            newTab = TabName;
        FileInputname ='';
        listForDisplayMOMLine = new list<MMPJ_TOPG_MoMLineItem__c>(); // To delete later

        agendaConstructor();
    }

    public void SetNewTabValue()
    {
        newTab = newTabTobe;
    }

    public integer saveComplete{get;set;}
    public string newtabTobe {get;set;}
    public string newTab{get;set;}
    public boolean DisplayPopupBackground {get;set;}
    public boolean DisplayAgendaPopupBackground {get;set;}

    /***********************************/
    /***********************************/
    /********Controller of Agenda*******/
    /***********************************/
    /***********************************/
    public boolean Error{get;set;}
    public String ErrorMessage{get;set;}
    public Map<string,EventRelation> MapAttendee {get;set;}    
    public Map<string,EventRelation> MapCurrentAttendee {get;set;}   
    public list<EventRelation> ListCurrentAttendee {get;set;}
    public list<WrapperpaAttList> ListWrapperAttendees {get;set;}  
    public Event Agenda{get;set;}
    public MMPJ_TOPG_Meeting__c Meeting {get;set;}
    public Integer rowToRemove {get;set;}
    public MMPJ_TOPG_BMC__c Bmc {get;set;}
    public map<decimal,MMPJ_TOPG_MeetingProject__c > MapMeetingProjectToinsert {get;set;}
    public map<decimal,MMPJ_TOPG_MeetingMarketPerf__c > MapMeetingMarketToinsert {get;set;}
    public map<decimal,MMPJ_TOPG_MeetingCompetitor__c> MapMeetingCompToinsert {get;set;}
    public map<decimal,MMPJ_TOPG_4P__c> MapMeeting4PToinsert {get;set;}
    public decimal UP4P{get;set;}
    public decimal UPcomp{get;set;}
    public decimal UPproject{get;set;}
    public decimal UPmarket{get;set;}
    public boolean PrintPDFActive {get;set;}
    public string EmailAgenda{get;set;}
    public boolean DisplayPPPPpopup {get;set;}
    public MMPJ_TOPG_4P__c PPPPpopup {get;set;}
    public blob FileInput {get;set;}
    public string FileInputname{get;set;}  
    public boolean showFileInputname {get;set;}
    public boolean showCompInput {get;set;}
    public boolean showProjectInput {get;set;}   

    public list<MMPJ_TOPG_MeetingProject__c > ListProjectToDelete {get;set;}
    public list<MMPJ_TOPG_MeetingCompetitor__c> ListCompetitorToDelete {get;set;}
    public list<MMPJ_TOPG_4P__c> ListPPPPToDelete {get;set;}
    
    
    //public MMPJ_TOPG_MeetingMarketPerf__c DetailMeetingMarketPerfPopUp {get;set;}
    //public MMPJ_TOPG_4P__c DetailMeeting4PPopUp {get;set;}
    public MMPJ_TOPG_MeetingProject__c DetailMeetingProjectPopUp {get;set;}
    public MMPJ_TOPG_MeetingCompetitor__c DetailMeetingCompPopUp {get;set;}
    public String  SetTopicAgendaPopUp {get;set;}
    public String  SetTopicMinutePopUp {get;set;}   
    public String  detailAgendaComment {get;set;}
    public  List<attachment> listAtt;
    
    Public class WrapperAgendDetailLine
    {
        
        public string TopicType {get;set;}
        public string CommentThreeLine {get;set;}
        public MMPJ_TOPG_MeetingProject__c LineItemMeetingProject{get;set;}
        public MMPJ_TOPG_MeetingMarketPerf__c LineItemMeetingMarketPerf{get;set;}
        public MMPJ_TOPG_MeetingCompetitor__c LineItemMeetingCompetitor{get;set;}
        public MMPJ_TOPG_4P__c LineItemMeeting4P{get;set;}
        public Boolean MeetingTopic {get;set;}
       
    }
    
     public WrapperAgendDetailLine TheWrapperAgendDetail {get;set;}

    public void agendaConstructor()
    {
        isRenderedWhoWhen = true;
        showFileInputname = false;
        showCompInput = false;
        showProjectInput = false;
		DisplayAgendaPopupBackground = false;
		DisplayPPPPpopup = false;
        DetailMeetingProjectPopUp = new MMPJ_TOPG_MeetingProject__c();
        DetailMeetingCompPopUp = new MMPJ_TOPG_MeetingCompetitor__c();         
        ProjectPopUp = new MMPJ_TOPG_Project__c();
        
        system.debug('agendaConstructor()');
        MoM = new MMPJ_TOPG_MinuteOfMeeting__c();
        String idMeeting;
        EmailAgenda ='javascript:void(0)';
        ListProjectToDelete = new list<MMPJ_TOPG_MeetingProject__c >();
        ListCompetitorToDelete = new list<MMPJ_TOPG_MeetingCompetitor__c >();
        ListPPPPToDelete = new list<MMPJ_TOPG_4P__c >();
        Error =false;
        PrintPDFActive =false;
        if(Meeting == null || Meeting.id == null)
        {
            idMeeting  = ApexPages.currentPage().getParameters().get('Id');
        }
        else
        {
            idMeeting  = Meeting.id;
        }
        ErrorMessage= '';
        Error = false;
        ListCurrentAttendee = new list<EventRelation>();
        MapCurrentAttendee = new Map<String,EventRelation>();
        if(String.IsBlank(idMeeting))
        {
            Meeting =new MMPJ_TOPG_Meeting__c();
            string bmcId = ApexPages.currentPage().getParameters().get('BMCId');
            List<MMPJ_TOPG_BMC__c > ListBmc = [select id, name,MMPJ_TOPG_BMCOwner__c
                                               from MMPJ_TOPG_BMC__c
                                               where id = :bmcId  ];
            if(ListBmc.size() > 0 )
                Bmc = ListBmc[0];
            else
            {
                Error =true;
                ErrorMessage= 'Please select a valid BMC id';
                DisplayPopupBackground = true;
                return;
            }
            Meeting.MMPJ_TOPG_BMC__c = Bmc.id;

            initAgenda();
        }
        else
        {
            list<MMPJ_TOPG_Meeting__c> ListMeeting =[Select id,Name, MMPJ_TOPG_BMC__r.name,MMPJ_TOPG_BMC__r.id,MMPJ_TOPG_Comments__c,MMPJ_TOPG_Interaction__c,MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__c,MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__r.email,MMPJ_TOPG_NoAgenda__c,MMPJ_TOPG_EndDate__c ,MMPJ_TOPG_Title__c,MMPJ_TOPG_StartDate__c,MMPJ_TOPG_Brand__c,
                                                     (select id,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_Comment__c,MMPJ_TOPG_Rank__c  from Meeting_Competitors__r ORDER BY MMPJ_TOPG_Rank__c ASC),
                                                     (select id,MMPJ_TOPG_Project__c,MMPJ_TOPG_Comment__c,MMPJ_TOPG_Rank__c from Meeting_Projects__r ORDER BY MMPJ_TOPG_Rank__c ASC),
                                                     (select id,MMPJ_TOPG_MarketPerf__c,MMPJ_TOPG_Comment__c,MMPJ_TOPG_Rank__c,MMPJ_TOPG_FileName__c  from  Meeting_Market_Perfs__r ORDER BY MMPJ_TOPG_Rank__c ASC),
                                                     (select id,name,MMPJ_TOPG_Comment__c,MMPJ_TOPG_Rank__c,MMPJ_TOPG_Topic__c from  Meeting_4P__r ORDER BY MMPJ_TOPG_Rank__c ASC),
                                                     (select id,createdDate,Createdby.name,Lastmodifiedby.name,MMPJ_TOG_MinutesDate__c,MMPJ_TOPG_Status__c,MMPJ_TOPG_Title__c ,MMPJ_TOPG_Meeting__c ,MMPJ_TOPG_Location__c,MMPJ_TOPG_Start_Date__c,MMPJ_TOPG_End_Date__c from Minutes_of_Meeting__r limit 1)
                                                     From MMPJ_TOPG_Meeting__c
                                                     Where id =:idMeeting ];
            if(ListMeeting.size() > 0 )
                Meeting = ListMeeting[0];
            else
            {
                Error =true;
                ErrorMessage= 'Please select a valid Meeting id';
                DisplayPopupBackground = true;
                return;
            }
            MapMeetingProjectToinsert = new map<decimal,MMPJ_TOPG_MeetingProject__c >();
            for(MMPJ_TOPG_MeetingProject__c  proj : Meeting.Meeting_Projects__r)
            {
				MapMeetingProjectToinsert.put(proj.MMPJ_TOPG_Rank__c,proj);
            }
			system.debug('agendaConstructor() MapMeetingProjectToinsert=' + MapMeetingProjectToinsert);

            MapMeetingMarketToinsert = new map<Decimal,MMPJ_TOPG_MeetingMarketPerf__c>();
            list<attachment> ListMarketAttachmentDum = [select id,name,parentId
                                                        from attachment
                                                        where parentId IN: Meeting.Meeting_Market_Perfs__r];
            Map<string,string> MapMarketAttachmentName = new Map<string,string>();
            for(attachment A : ListMarketAttachmentDum )
                MapMarketAttachmentName.put(A.parentID,A.name);
			system.debug('agendaConstructor() MapMarketAttachmentName=' + MapMarketAttachmentName);
			
            for(MMPJ_TOPG_MeetingMarketPerf__c Market: Meeting.Meeting_Market_Perfs__r)
            {
                system.debug('agendaConstructor() Market=' + Market);
                if(MapMarketAttachmentName.containskey(Market.id))
                    Market.MMPJ_TOPG_FileName__c  = MapMarketAttachmentName.get(Market.id);
                MapMeetingMarketToinsert.put(Market.MMPJ_TOPG_Rank__c,Market);
            }
			system.debug('agendaConstructor() MapMeetingMarketToinsert=' + MapMeetingMarketToinsert);

            MapMeetingCompToinsert = new map<Decimal,MMPJ_TOPG_MeetingCompetitor__c>();
            for(MMPJ_TOPG_MeetingCompetitor__c Comp: Meeting.Meeting_Competitors__r)
            {
				MapMeetingCompToinsert.put(Comp.MMPJ_TOPG_Rank__c,Comp);
            }
			system.debug('agendaConstructor() MapMeetingCompToinsert=' + MapMeetingCompToinsert);

            MapMeeting4PToinsert = new map<decimal,MMPJ_TOPG_4P__c>();
            for(MMPJ_TOPG_4P__c PPPP: Meeting.Meeting_4P__r)
            {
				MapMeeting4PToinsert.put(PPPP.MMPJ_TOPG_Rank__c,PPPP);
            }
			system.debug('agendaConstructor() MapMeeting4PToinsert=' + MapMeeting4PToinsert);

            bmc = new MMPJ_TOPG_BMC__c();
            Bmc.id = Meeting.MMPJ_TOPG_BMC__r.id;
            Bmc.name = Meeting.MMPJ_TOPG_BMC__r.name;
            Bmc.MMPJ_TOPG_BMCOwner__c = Meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__c ;

            if(Meeting.Minutes_of_Meeting__r.size() > 0)
            {
                MoM=Meeting.Minutes_of_Meeting__r[0];
            }
            List<Event> listEvent = [select id,Subject,StartDateTime,ENDDateTime,IsRecurrence,Location,ownerid,whatid,
                                    (select relationid,response from EventRelations  order by response)
                                   from event
                                   where Whatid =:idMeeting];
            for(Event Ev : listEvent )
            {
                if(Ev.EventRelations.size() > 0)
                {
                    Agenda = Ev;
                    break;
                }
            }
            if(Agenda == null )
            {
                Error =true;
                ErrorMessage= 'This meeting has no Event';
                DisplayPopupBackground = true;
                return;
            }
           
            //BTO: Begin ====== Add Metting owner to the Attendees list
            WrapperpaAttList WrapperClassOwner = new WrapperpaAttList();
            ListWrapperClassOwner= new list<user>();
            ListWrapperClassOwner = [select Id, Name, Division, title, Email
                             From User
                             Where id =: Agenda.ownerid];     
            //BTO : End=======
            MapCurrentAttendee = new Map<String,EventRelation>();
            ListCurrentAttendee = Agenda.EventRelations;
            system.debug('agendaConstructor() ListCurrentAttendee=' + ListCurrentAttendee);
            ListWrapperAttendees = new list<WrapperpaAttList>();           
            for(EventRelation Att: ListCurrentAttendee)
            {
                system.debug('agendaConstructor() Att=' + Att);
                MapCurrentAttendee.put(Att.relationid,Att);

                WrapperpaAttList WrapperClass = new WrapperpaAttList();
                WrapperClass.meeting = new MMPJ_TOPG_Meeting__c();
                if( String.valueOf(Att.relationid).startswith('003'))
                {
                    WrapperClass.meeting.MMPJ_TOPG_TECH_contact__c = Att.relationid;
                    WrapperClass.SelectValue ='Contact';
                    WrapperClass.index = ListWrapperAttendees.size();
                    ListWrapperAttendees.add(WrapperClass);
                }
                else if( String.valueOf(Att.relationid).startswith('005') && Att.relationid != Bmc.MMPJ_TOPG_BMCOwner__c )
                {
                    WrapperClass.meeting.MMPJ_TOPG_TECH_User__c = Att.relationid;
                    WrapperClass.SelectValue ='User';
                    WrapperClass.index = ListWrapperAttendees.size();
                    ListWrapperAttendees.add(WrapperClass);
                }
                system.debug('agendaConstructor() MapCurrentAttendee=' + MapCurrentAttendee);
                system.debug('agendaConstructor() ListWrapperAttendees=' + ListWrapperAttendees);
            }
            AutomateFunction();

            String PDFname = Meeting.Name +'-Agenda.pdf';
			System.debug('==> agendaConstructor(), PDFname : ' + PDFname);
            //List<attachment> 
			listAtt = [Select Name from attachment
                                   Where Name =: PDFname ];
            if(listAtt.size() > 0 && listAtt != null)
            {
                //BTO => put Organizer Email as copy 
                //String KPOKEmail = Meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__r.email == null ? '' : Meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__r.email;
                String KPOKEmail = ListWrapperClassOwner.get(0).Email == null ? '' : ListWrapperClassOwner.get(0).Email ;
                PrintPDFActive = true;
                EmailAgenda ='mailto:';
                for(WrapperpaAttList  Wrapper : ListWrapperAttendees)
                   if(Wrapper.email != null)
                       EmailAgenda += Wrapper.email + ';';
                EmailAgenda += + '?cc='+ KPOKEmail + ';'
                             +'&subject=' + Agenda.Subject
                             +'&body=Hello,%0D%0A%0D%0A'
                             +'You have been invited to attend the following meeting regarding '+ Agenda.Subject + ' in the time slot from ' + Agenda.StartDateTime.format() + ' to '+ Agenda.EndDateTime.format() +'.%0D%0A%0D%0A'
                             +'If you want to consult the proposed agenda for the meeting please click the link here below:%0D%0A'
                             + Label.MMPJ_TOPG_GetMeetingsLink +'?what=pdfAgenda%26relatedId=' + Meeting.Id +'%0D%0A%0D%0A'
                             +'If you want to create this meeting in your calendar, click the link here below:%0D%0A'
                             + Label.MMPJ_TOPG_GetMeetingsLink +'?what=ics%26relatedId=' + Meeting.Id  +'%0D%0A%0D%0A'
                             +'Kindest Regards,%0D%0A%0D%0A'
                             +UserInfo.getName()+'%0D%0ASent from TOPGUN App';
            }
            MinutesConstructor();
        }
    }

    public void initAgenda()
    {
        ErrorMessage= '';
        Error = false;
        Agenda = new Event();
        if(Meeting  == null)
        {
            Meeting = new MMPJ_TOPG_Meeting__c();
        }

        MapMeetingCompToinsert = new map<Decimal,MMPJ_TOPG_MeetingCompetitor__c>();
        MapMeetingProjectToinsert = new map<decimal,MMPJ_TOPG_MeetingProject__c >();
        MapMeetingMarketToinsert = new map<decimal,MMPJ_TOPG_MeetingMarketPerf__c>();
        MapMeeting4PToinsert = new map<decimal,MMPJ_TOPG_4P__c>();
        ListWrapperAttendees =new list<WrapperpaAttList>();
        //addAttendee();
    }
    public pagereference SaveAndCloseAgenda()
    {
        if(meeting.MMPJ_TOPG_NoAgenda__c == true)
        {
            boolean success =InserNoAgenda();
            if(!success)
                return null;
        }
        else
        {
            boolean ErrorVerify = VerifyDate();
            if(ErrorVerify)
                return null;
            Boolean ErrorUpsert = insertAgenda();
            if(ErrorUpsert)
                return null;
        }
        return new pagereference('/'+Bmc.id);
    }
    Public pagereference LeavingAgenda()
    {
        if(meeting.MMPJ_TOPG_NoAgenda__c == true)
        {
            boolean success =InserNoAgenda();
            if(!success)
                return null;
        }
        else
        {
            boolean ErrorVerify = VerifyDate();
            if(ErrorVerify)
                return null;
            Boolean ErrorUpsert = insertAgenda();
            if(ErrorUpsert)
                return null;
            system.debug('NEW TAB ' + newTabTobe);
        }
        saveComplete++;
        ShowSaveMessage_newCounter--; ///we Dont want to show the success message when moving between tabs
        agendaConstructor();
        system.debug('NEW TAB ' + newTabTobe);
        newTab = newTabTobe;
        return null;
    }
    Public pagereference UpdateAgenda()
    {
        if(meeting.MMPJ_TOPG_NoAgenda__c == true)
        {
            boolean success =InserNoAgenda();
            System.debug('==> UpdateAgenda : meeting.MMPJ_TOPG_NoAgenda__c == true, success=' + success);
            if(!success)
                return null;
        }
        else
        {
            boolean ErrorVerify = VerifyDate();
            System.debug('==> UpdateAgenda : meeting.MMPJ_TOPG_NoAgenda__c == false, ErrorVerify=' + ErrorVerify);
            if(ErrorVerify)
                return null;
            Boolean ErrorUpsert = insertAgenda();
            System.debug('==> UpdateAgenda : meeting.MMPJ_TOPG_NoAgenda__c == false, ErrorUpsert=' + ErrorUpsert);
            if(ErrorUpsert)
                return null;
        }
        System.debug('==> UpdateAgenda : avant appel agendaConstructor()');
        agendaConstructor();
        return null;
    }
    
    public boolean VerifyDate()
    {
        Error = false;
        ErrorMessage= '';
        if(Agenda.StartDateTime == null || Agenda.EndDateTime == null || String.isblank(Agenda.Subject) || String.isblank(Meeting.MMPJ_TOPG_Interaction__c))
        {
            if(Agenda.StartDateTime == null)
                Agenda.StartDateTime.addError('Please enter a date.');
            if(Agenda.EndDateTime == null)
                Agenda.EndDateTime.addError('Please enter a date.');
            if(String.isblank(Agenda.Subject))
                Agenda.Subject.addError('Please enter a title.');
            if(String.isblank(Meeting.MMPJ_TOPG_Interaction__c))
                Meeting.MMPJ_TOPG_Interaction__c.addError('Please enter an interaction.');
            return true;
        }
        if(Agenda.StartDateTime >  Agenda.EndDateTime )
        {
            Error = true;
            ErrorMessage= 'The End date must be greater than the Start date.';
            return true;
        }       

        MapAttendee =new Map<string,EventRelation>();
        set<id> SetIdAttendee = new set<id>();
        //== Begin BTO :Attendees can be empty
       /* if(ListWrapperAttendees.size() <1)
        {
            Error = true;
            ErrorMessage= 'You should atleast have one attendee.';
            return true;
        }*/
        //==End BTO
           
        for(WrapperpaAttList Att : ListWrapperAttendees )
        {
            EventRelation Attendee = new EventRelation();
            Attendee.EventId = agenda.id;           
            
            if(Att.meeting.MMPJ_TOPG_TECH_user__c == Agenda.ownerid)
            {
                Att.meeting.MMPJ_TOPG_TECH_user__c.addError('You cannot add the owner of the event as an invitee.');
                return true;
            }
            if(Att.SelectValue == 'User' && Att.meeting.MMPJ_TOPG_TECH_user__c != null && Bmc.MMPJ_TOPG_BMCOwner__c != Att.meeting.MMPJ_TOPG_TECH_user__c)
            {
                Attendee.RelationId = Att.meeting.MMPJ_TOPG_TECH_user__c;
                SetIdAttendee.add(Att.meeting.MMPJ_TOPG_TECH_user__c);
                MapAttendee.put(Attendee.RelationId,Attendee);
            }
            else if(Att.SelectValue == 'Contact' && Att.meeting.MMPJ_TOPG_TECH_contact__c!= null)
            {
                Attendee.RelationId = Att.meeting.MMPJ_TOPG_TECH_contact__c;
                SetIdAttendee.add(Att.meeting.MMPJ_TOPG_TECH_contact__c);
                MapAttendee.put(Attendee.RelationId,Attendee);
            }            
              
        }
      /*  if(MapAttendee.isEmpty())
        {
            ListWrapperAttendees[0].meeting.MMPJ_TOPG_TECH_contact__c.addError('You should atleast have one attendee.');
            ListWrapperAttendees[0].meeting.MMPJ_TOPG_TECH_user__c.addError('You should atleast have one attendee.');
            Error = true;
            ErrorMessage= 'You should atleast have one attendee.';
            return true;
        }*/
        if(MapAttendee.size() != SetIdAttendee.size())
        {

            Error = true;
            ErrorMessage= 'DUPLICATE_VALUE : Please verify the attendees for duplicate value.';
            return true;
        }

        if(MapMeetingProjectToinsert.size() <1 && MapMeetingMarketToinsert.size() <1 && MapMeetingCompToinsert.size() <1 && MapMeeting4PToinsert.size() < 1)
        {
            Error = true;
            ErrorMessage= 'At least one topic should be chosen.';
            return true;
        }
        if(!MapAttendee.isEmpty())
        {
            if(Bmc.MMPJ_TOPG_BMCOwner__c != Agenda.ownerid )
            {
                if( Agenda.ownerid == null && Bmc.MMPJ_TOPG_BMCOwner__c != Userinfo.getUserId())
                {
                    EventRelation Attendee = new EventRelation();
                    Attendee.EventId = agenda.id;
                    Attendee.RelationId = Bmc.MMPJ_TOPG_BMCOwner__c;
                    MapAttendee.put(Attendee.RelationId,Attendee);
                }
            }
            if(Meeting.id != null)
                MapAttendee.put(Meeting.id,new EventRelation());
        }        
        return false;
    }

    Public boolean insertAgenda()
    {
        Savepoint spAgenda = Database.setSavepoint();
        try
        {
            upsert agenda;
            system.debug('#### Agenda '+ Agenda );
            
            //BTO => added to save the attendees ranks
           for(String KeyCurrent : MapCurrentAttendee.keySet())
            {
                 if(MapCurrentAttendee.get(KeyCurrent).relationId == meeting.id)
                {
                    MapCurrentAttendee.remove(KeyCurrent);
                    MapAttendee.remove(KeyCurrent);
                }
                
               /* if(MapAttendee.containsKey(KeyCurrent))
                {
                    MapAttendee.remove(KeyCurrent);
                    MapCurrentAttendee.remove(KeyCurrent);
                }*/
            }   
            
            Integer rank = 0;
            for(EventRelation  eva : MapAttendee.values())
            {
                eva.EventId = agenda.id;   
                eva.response = rank.format();
                rank++;
                
            }
            
            if(MapCurrentAttendee.size() > 0)
                delete MapCurrentAttendee.values();
            if(MapAttendee.size() > 0)
                upsert MapAttendee.values();
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            Database.rollback(spAgenda);
            return true;
        }
        try
        {
            //
            meeting.name = agenda.subject;
            meeting.MMPJ_TOPG_EndDate__c = Agenda.EndDateTime;
            meeting.MMPJ_TOPG_StartDate__c = Agenda.StartDateTime;
            meeting.MMPJ_TOPG_Title__c = Agenda.Subject;
            meeting.MMPJ_TOPG_BMC__c = Bmc.id;
            meeting.MMPJ_TOPG_TECH_user__c = null;
            meeting.MMPJ_TOPG_TECH_contact__c= null;
            upsert meeting;
            //system.debug('#### meeting'+ meeting);
            MoM.MMPJ_TOPG_Title__c = Agenda.Subject;
            if(MoM.MMPJ_TOPG_Meeting__c == null)
            {
                MoM.MMPJ_TOPG_Meeting__c = meeting.id;
                MoM.MMPJ_TOPG_Start_Date__c=DateTime.now();
                MoM.MMPJ_TOPG_End_Date__c=DateTime.now();
                
            }
            upsert MoM;
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            Database.rollback(spAgenda);
            return true;
        }

        try
        {
            if(agenda.whatid != meeting.id)
            {
                agenda.whatid = meeting.id;
                update agenda;
            }
            if(ListProjectToDelete.size() > 0)
                delete ListProjectToDelete;
            if(ListCompetitorToDelete.size() > 0)
                delete ListCompetitorToDelete;
            /*if(Meeting.Meeting_Market_Perfs__r.size() > 0)
                delete Meeting.Meeting_Market_Perfs__r;*/
            if(ListPPPPToDelete.size() > 0)
                delete ListPPPPToDelete;
            if(MapMeetingProjectToinsert.size() > 0 &&  MapMeetingProjectToinsert != null)
            {
                for(Decimal Key : MapMeetingProjectToinsert.keyset())
                {
                    MapMeetingProjectToinsert.get(Key).MMPJ_TOPG_Meeting__c = meeting.id;
                    MapMeetingProjectToinsert.get(Key).MMPJ_TOPG_Rank__c = key;
                }
                upsert MapMeetingProjectToinsert.values();
            }
            if(MapMeetingMarketToinsert.size() > 0 &&  MapMeetingMarketToinsert != null)
            {
                for(Decimal Key : MapMeetingMarketToinsert.keyset())
                {
                    MapMeetingMarketToinsert.get(Key).MMPJ_TOPG_Rank__c = key;
                }
                upsert MapMeetingMarketToinsert.values();
            }

            if(MapMeetingCompToinsert.size() > 0 &&  MapMeetingCompToinsert!= null)
            {
                for(Decimal Key : MapMeetingCompToinsert.keyset())
                {
                    MapMeetingCompToinsert.get(Key).MMPJ_TOPG_Meeting__c = meeting.id;
                    MapMeetingCompToinsert.get(Key).MMPJ_TOPG_Rank__c = key;
                }
                upsert MapMeetingCompToinsert.values();
            }
            if(MapMeeting4PToinsert.size() > 0 &&  MapMeeting4PToinsert != null)
            {
                for(Decimal Key : MapMeeting4PToinsert.keyset())
                {
                    MapMeeting4PToinsert.get(Key).MMPJ_TOPG_Meeting__c = meeting.id;
                    MapMeeting4PToinsert.get(Key).MMPJ_TOPG_Rank__c = key;
                    /* Modif MCH
					MapMeeting4PToinsert.get(Key).name = MapMeeting4PToinsert.get(Key).MMPJ_TOPG_Topic__c; */
					MapMeeting4PToinsert.get(Key).name = MapMeeting4PToinsert.get(Key).name;
                    MapMeeting4PToinsert.get(Key).MMPJ_TOPG_Topic__c = MapMeeting4PToinsert.get(Key).MMPJ_TOPG_Topic__c;
					system.debug('==> insertAgenda() key=[' + Key + '], MMPJ_TOPG_Topic__c=' +  MapMeeting4PToinsert.get(Key).MMPJ_TOPG_Topic__c + ', name=' + MapMeeting4PToinsert.get(Key).name);
                }
                upsert MapMeeting4PToinsert.values();
				system.debug('==> insertAgenda() upsert data, MapMeeting4PToinsert= ' + MapMeeting4PToinsert);
            }
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            Database.rollback(spAgenda);
            return true;
        }
        if(!Error)
        {
            SuccessMessage ='The agenda has been saved successfully!';
            ShowSaveMessage_newCounter++;
            system.debug('==> insertAgenda(), SuccessMessage= ' + SuccessMessage + ', ShowSaveMessage_newCounter=' + ShowSaveMessage_newCounter);
        }
        MinutesConstructor();
        return false;
    }

    public pagereference Cancel()
    {
        return new Pagereference('/' + Bmc.id);
    }

    public pagereference CheckNoAgenda()
    {
        try{
            Agenda.Subject = 'No Agenda';
            Agenda.Location = 'No Location' ;
            Meeting.MMPJ_TOPG_Interaction__c = 'No Agenda';
            Agenda.StartDateTime = DateTime.now();
            Agenda.ENDDateTime = DateTime.now();
            meeting.MMPJ_TOPG_EndDate__c = Agenda.EndDateTime;
            meeting.MMPJ_TOPG_StartDate__c = Agenda.StartDateTime;
            meeting.MMPJ_TOPG_Title__c = Agenda.Subject;
            meeting.name= Agenda.Subject;
            upsert Meeting;
            if(MoM.MMPJ_TOPG_Meeting__c == null)
            {
                MoM.MMPJ_TOPG_Meeting__c = meeting.id;
            }
            //MoM.MMPJ_TOPG_Title__c = Agenda.Subject;
            upsert MoM;
            Agenda.whatid = meeting.id;
            upsert agenda;
            MinutesConstructor();
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return null;
        }
        newTab = 'Minutes';
        return null;
    }

    Public boolean InserNoAgenda()
    {
        try{
            upsert Meeting;
            upsert agenda;
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return false;
        }
        SuccessMessage ='The agenda has been saved successfully!';
        ShowSaveMessage_newCounter++;
        system.debug('==> InserNoAgenda(), SuccessMessage ' + SuccessMessage + 'ShowSaveMessage_newCounter=' + ShowSaveMessage_newCounter);
        return true;
    }
    public Void PrintPDF()
    {
        try{
            boolean ErrorVerify = VerifyDate();
            system.debug('#### Error ' + Error);
            if(ErrorVerify)
                return;
            Boolean ErrorUpsert = insertAgenda();
             system.debug('#### ErrorUpsert ' + ErrorUpsert);
            if(ErrorUpsert)
                return;
            PageReference AgendaPDF= Page.MMPJ_TOPG_AgendaPDF;
			system.debug('==> PrintPDF(), AgendaPDF ' + AgendaPDF);
            AgendaPDF.getParameters().put('MeetingId', Meeting.id );
            AgendaPDF.getParameters().put('EventId',Agenda.id);
            blob body;
            if(Test.isRunningTest())
                body = Blob.valueOf('test');
            else
                body = AgendaPDF.getContentAsPDF();
            String PDFname = Meeting.Name +'-Agenda.pdf';
           // list<attachment> 
                ListAtt =[Select id,Name,Body
                                       From Attachment
                                       Where Name = :PDFname
                                       Limit 1];
            if(ListAtt.size() > 0 && ListAtt !=null)
            {
                delete ListAtt;
            }
            attachment AttAgenda = new attachment();
            AttAgenda.Body = body ;
            AttAgenda.isPrivate = false;
            AttAgenda.Name =  Meeting.Name +'-Agenda.pdf';
            AttAgenda.parentId = Meeting.id;
            Insert AttAgenda;
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return;
        }
        agendaConstructor();
        SuccessMessage ='Agenda PDF file generated successfully, please go Doc/File tab to view it';
        PrintPDFActive =true;
    }
    //Topics
    public pagereference AddProject(MMPJ_TOPG_MeetingProject__c proj)
    {
        proj.MMPJ_TOPG_Comment__c = TheWrapperAgendDetail.CommentThreeLine;
        MapMeetingProjectToinsert.put( MapMeetingProjectToinsert.size(),proj);
        return null;
    }
    public Pagereference AddMarket(MMPJ_TOPG_MeetingMarketPerf__c market)
    {
        System.debug('==> AddMarket()');
        try{
            if(meeting.id == null)
            {
                System.debug('==> AddMarket() : meeting.id == null');
                MapMeetingMarketToinsert.put(9999,new MMPJ_TOPG_MeetingMarketPerf__c());
                boolean ErrorVerify = VerifyDate();
                MapMeetingMarketToinsert.remove(9999);
                if(ErrorVerify)
                    return null;
                Boolean ErrorUpsert = insertAgenda();
                System.debug('==> AddMarket() : apres insertAgenda(), ErrorUpsert=' + ErrorUpsert);
                if(ErrorUpsert)
                    return null;
                agendaConstructor();
            }
            
            /*MMPJ_TOPG_MeetingMarketPerf__c MeetingMarket = new MMPJ_TOPG_MeetingMarketPerf__c();
            MeetingMarket.MMPJ_TOPG_Meeting__c = meeting.id;
            MeetingMarket.MMPJ_TOPG_Rank__c = MapMeetingMarketToinsert.size();
            MeetingMarket.MMPJ_TOPG_FileName__c = market.MMPJ_TOPG_FileName__c; 
            MeetingMarket.MMPJ_TOPG_Comment__c = market.MMPJ_TOPG_Comment__c;
            insert MeetingMarket;*/
            market.MMPJ_TOPG_Meeting__c = meeting.id;
            market.MMPJ_TOPG_Comment__c = TheWrapperAgendDetail.CommentThreeLine;           
            market.MMPJ_TOPG_Rank__c = MapMeetingMarketToinsert.size();
            System.debug('==> AddMarket() : market=' + market);
            insert market;
            MapMeetingMarketToinsert.put(MapMeetingMarketToinsert.size(),market);
            // TGS-45 : do a real Save of Agenda
            UpdateAgenda();
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
        }
        return null;
    }


    public pagereference AddComp(MMPJ_TOPG_MeetingCompetitor__c comp)
    {
        comp.MMPJ_TOPG_Comment__c = TheWrapperAgendDetail.CommentThreeLine;
        MapMeetingCompToinsert.put(MapMeetingCompToinsert.size(),comp);
        return null;
    }
    public pagereference Add4P(MMPJ_TOPG_4P__c pppp)
    {
        pppp.MMPJ_TOPG_Comment__c = TheWrapperAgendDetail.CommentThreeLine;
        MapMeeting4PToinsert.put(MapMeeting4PToinsert.size(),pppp);
		system.debug('Add4P() : pppp=' + pppp + ', MapMeeting4PToinsert=' + MapMeeting4PToinsert);
        return null;
    }


    //Attendee Functions
    public void DelAttendee()
    {
        System.debug('==> DelAttendee() : rowToRemove' + rowToRemove);
        ListWrapperAttendees.remove(rowToRemove);
    }

    public  PageReference addAttendee()
    {
        System.debug('==> addAttendee()');
        WrapperpaAttList WrapperClass = new WrapperpaAttList();
        WrapperClass.meeting = new MMPJ_TOPG_Meeting__c();
        WrapperClass.index = ListWrapperAttendees.size();
        WrapperClass.SelectValue ='User';
        ListWrapperAttendees.add(WrapperClass);
        System.debug('==> addAttendee() : WrapperClass' + WrapperClass);
        return null ;
    }
    
    /****  BTO => permet de déplacer un attendees dans la liste Attendees*/
    public void GoUPAttendeeLine(){
        if(LineItemCounter > 0)
            ListWrapperAttendees.add(LineItemCounter-1, ListWrapperAttendees.remove(LineItemCounter));
    }   

    public void GoUPproject()
    {
        MMPJ_TOPG_MeetingProject__c ProjectToGoUP = new MMPJ_TOPG_MeetingProject__c();
        ProjectToGoUP = MapMeetingProjectToinsert.get(UPproject);
        MapMeetingProjectToinsert.put(UPproject,MapMeetingProjectToinsert.get(UPproject - 1));
        MapMeetingProjectToinsert.put(UPproject - 1,ProjectToGoUP );
    }

    public void Delproject()
    {
        While(MapMeetingProjectToinsert.containskey(UPproject + 1))
        {
            UPproject++;
            GoUPproject();
        }
        if(MapMeetingProjectToinsert.get(UPproject).id != null)
            ListProjectToDelete.add( MapMeetingProjectToinsert.remove(UPproject));
        else
            MapMeetingProjectToinsert.remove(UPproject);
    }

    public void GoUP4P()
    {
        MMPJ_TOPG_4P__c PPPPToGoUP = new MMPJ_TOPG_4P__c();
        PPPPToGoUP = MapMeeting4PToinsert.get(UP4P);
        MapMeeting4PToinsert.put(UP4P,MapMeeting4PToinsert.get(UP4P- 1));
        MapMeeting4PToinsert.put(UP4P- 1 , PPPPToGoUP );
		System.Debug('GoUP4P() : UP4P=' + UP4P + ', MapMeeting4PToinsert=' + MapMeeting4PToinsert);
    }

    public void Del4P()
    {
        While(MapMeeting4PToinsert.containskey(UP4P+ 1))
        {
            UP4P++;
            GoUP4P();
        }
        if(MapMeeting4PToinsert.get(UP4P).id != null)
            ListPPPPToDelete.add(MapMeeting4PToinsert.remove(UP4P));
        else
            MapMeeting4PToinsert.remove(UP4P);
		System.Debug('Del4P() : UP4P=' + UP4P + ', MapMeeting4PToinsert=' + MapMeeting4PToinsert);
    }

    public void GoUPmarket()
    {
        MMPJ_TOPG_MeetingMarketPerf__c MarketToGoUP = new MMPJ_TOPG_MeetingMarketPerf__c();
        MarketToGoUP= MapMeetingMarketToinsert.get(UPmarket);
        MapMeetingMarketToinsert.put(UPmarket,MapMeetingMarketToinsert.get(UPmarket - 1));
        MapMeetingMarketToinsert.put(UPmarket - 1,MarketToGoUP);
    }
    public void Delmarket()
    {
        try{
            While(MapMeetingMarketToinsert.containskey(UPmarket + 1))
            {
                UPmarket++;
                GoUPmarket();
            }
            delete MapMeetingMarketToinsert.get(UPmarket);
            MapMeetingMarketToinsert.remove(UPmarket);
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
        }
    }

    public void GoUPComp()
    {
        MMPJ_TOPG_MeetingCompetitor__c CompToGoUP = new MMPJ_TOPG_MeetingCompetitor__c();
        CompToGoUP = MapMeetingCompToinsert.get(UPcomp);
        MapMeetingCompToinsert.put(UPcomp,MapMeetingCompToinsert.get(UPcomp- 1));
        MapMeetingCompToinsert.put(UPcomp- 1,CompToGoUP );
    }

    public void DelComp()
    {
        While(MapMeetingCompToinsert.containskey(UPcomp + 1))
        {
            UPcomp++;
            GoUPComp();
        }
        if(MapMeetingCompToinsert.get(UPcomp).id != null)
            ListCompetitorToDelete.add(MapMeetingCompToinsert.remove(UPcomp));
        else
            MapMeetingCompToinsert.remove(UPcomp);
    }
    //Function automated
    public void AutomateFunction()
    {
        List<String> ListIds = new List<String>();
        for(WrapperpaAttList Wrapp : ListWrapperAttendees)
        {
            if(Wrapp.SelectValue == 'User' && Wrapp.meeting.MMPJ_TOPG_TECH_user__c != null){
                System.debug('==> AutomateFunction() : add User' + Wrapp.meeting.MMPJ_TOPG_TECH_user__c);
                ListIds.add(Wrapp.meeting.MMPJ_TOPG_TECH_user__c);
            }
            else if(Wrapp.SelectValue == 'Contact' && Wrapp.meeting.MMPJ_TOPG_TECH_contact__c!= null){
                System.debug('==> AutomateFunction() : add Contact' + Wrapp.meeting.MMPJ_TOPG_TECH_contact__c);
                ListIds.add(Wrapp.meeting.MMPJ_TOPG_TECH_contact__c);
            }
        }
        System.debug('#### List Ids ' + ListIds);
        
        Map<ID, Contact> mContact = new Map<ID, Contact>([SELECT id,Title,email
                                                          FROM Contact
                                                          WHERE id IN : ListIds]);
        Map<ID, User> mUser = new Map<ID, User>([SELECT id,Title,email
                                                 FROM User
                                                 WHERE id IN : ListIds]);
        
        /*Map<ID, Contact> mContact = new Map<ID, Contact>();
        Map<ID, User> mUser = new Map<ID, User>();
        if (ListIds.size() > 0) {
            
            for (Contact c : [SELECT id, Title, email FROM Contact
                                                 WHERE id IN : ListIds]) { 
                mContact.put(c.id, c);
            } 
            for (User u : [SELECT id, Title, email FROM User
                                                 WHERE id IN : ListIds]) { 
                mUser.put(u.id, u);
            } 
        }*/

        /* Set<String>SetListIds = new Set<String>();                                      
         Map<ID, Contact> mContact = new Map<ID, Contact>();
         if (AllContacts.size()>0){
            for (Contact c :AllContacts){
                if(SetListIds.contains(c.id)){ 
                    mContact.put(c.id,c);
                } 
            }
        }                                        
        Map<ID, User> mUser = new Map<ID, User>();
        
        SetListIds.addAll(ListIds); 
        if (AllUsers.size()>0){
            for (User u :AllUsers){
                if(SetListIds.contains(u.id)){ 
                    mUser.put(u.id,u);
                } 
            }
        } */                                       
        System.debug('#### mUser  ' + mUser + '#### mContact ' + mContact );
        Integer rank = 0;
        for(WrapperpaAttList Wrapp : ListWrapperAttendees)             
        {
             Wrapp.index = rank;
              rank++; 
            
            Wrapp.Function='';
            if(Wrapp.SelectValue == 'User' && Wrapp.meeting.MMPJ_TOPG_TECH_user__c != null && mUser.containsKey(Wrapp.meeting.MMPJ_TOPG_TECH_user__c))
            {
                if(mUser.get(Wrapp.meeting.MMPJ_TOPG_TECH_user__c).Title != null)
                    Wrapp.Function = mUser.get(Wrapp.meeting.MMPJ_TOPG_TECH_user__c).Title;
                Wrapp.email = mUser.get(Wrapp.meeting.MMPJ_TOPG_TECH_user__c).Email;
                system.debug('$$$$$ email ' + mUser.get(Wrapp.meeting.MMPJ_TOPG_TECH_user__c).Email);
            }
            else if(Wrapp.SelectValue == 'Contact' && Wrapp.meeting.MMPJ_TOPG_TECH_contact__c!= null && mContact.containsKey(Wrapp.meeting.MMPJ_TOPG_TECH_contact__c))
            {
                if(mContact.get(Wrapp.meeting.MMPJ_TOPG_TECH_contact__c).Title != null)
                    Wrapp.Function = mContact.get(Wrapp.meeting.MMPJ_TOPG_TECH_contact__c).Title;
                Wrapp.email = mContact.get(Wrapp.meeting.MMPJ_TOPG_TECH_contact__c).Email;
            }
        }
    }
    
    //BTO = > Agenda pop up
    public void DetailAgendapopup()
    {      
          initAgendaPopUp();
          TheWrapperAgendDetail = new WrapperAgendDetailLine(); 
          TheWrapperAgendDetail.LineItemMeetingMarketPerf = new MMPJ_TOPG_MeetingMarketPerf__c();
          TheWrapperAgendDetail.LineItemMeetingMarketPerf.MMPJ_TOPG_FileName__c = 'File or text'; 
          
          TheWrapperAgendDetail.LineItemMeeting4P = new MMPJ_TOPG_4P__c();            
          TheWrapperAgendDetail.LineItemMeetingProject = new MMPJ_TOPG_MeetingProject__c();         
          TheWrapperAgendDetail.LineItemMeetingCompetitor = new MMPJ_TOPG_MeetingCompetitor__c();           
          DisplayAgendaPopupBackground = true;        
    }
    public void closeAgendapopup()
    {        
        DisplayAgendaPopupBackground = false;
    }
    
    public void SaveDetailAgendaPop()
    {
        if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Place / Channel' || meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Other' ||
           meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Price' || meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Product' ||
           meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Promotion / Communication'){
            System.debug('==> SaveDetailAgendaPop() : MMPJ_TOPG_Detail_Line_Topic__c=' + meeting.MMPJ_TOPG_Detail_Line_Topic__c);
            TheWrapperAgendDetail.LineItemMeeting4P.MMPJ_TOPG_Topic__c = meeting.MMPJ_TOPG_Detail_Line_Topic__c;
            Add4P(TheWrapperAgendDetail.LineItemMeeting4P);
            DisplayAgendaPopupBackground = false;
        }
        if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Market Performance'){     
            //TheWrapperAgendDetail.LineItemMeetingMarketPerf.MMPJ_TOPG_Brand__c = meeting.MMPJ_TOPG_Brand__c;
            System.debug('==> SaveDetailAgendaPop() : MMPJ_TOPG_Detail_Line_Topic__c=' + meeting.MMPJ_TOPG_Detail_Line_Topic__c);
            System.debug('==> SaveDetailAgendaPop() : TheWrapperAgendDetail.LineItemMeetingMarketPerf=' + TheWrapperAgendDetail.LineItemMeetingMarketPerf);
            AddMarket(TheWrapperAgendDetail.LineItemMeetingMarketPerf);
            DisplayAgendaPopupBackground = false;
        }
        if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Project'){  
            System.debug('==> SaveDetailAgendaPop() : MMPJ_TOPG_Detail_Line_Topic__c=' + meeting.MMPJ_TOPG_Detail_Line_Topic__c);          
            AddProject(TheWrapperAgendDetail.LineItemMeetingProject);
            DisplayAgendaPopupBackground = false;
        }
        if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Competition'){
            System.debug('==> SaveDetailAgendaPop() : MMPJ_TOPG_Detail_Line_Topic__c=' + meeting.MMPJ_TOPG_Detail_Line_Topic__c);       
            AddComp(TheWrapperAgendDetail.LineItemMeetingCompetitor);
            DisplayAgendaPopupBackground = false;
        }       
    }
    
     public void SaveAndNewDetailAgendaPop()
     {
         SaveDetailAgendaPop();
         DetailAgendapopup();
         
    }
    //BTO : Selected Topic function
     public void selectedTopicAgendaPop() { 
        if (meeting.MMPJ_TOPG_Detail_Line_Topic__c =='Market Performance'){
                showFileInputname = true;
                showCompInput = false;
                showProjectInput = false;       
            }
         if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Competition'){
                showFileInputname = false;
                showCompInput = true;
                showProjectInput = false;
            }   
          if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Project'){
                showFileInputname = false;
                showCompInput = false;
                showProjectInput = true;
            } 
         if(meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Place / Channel' || meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Other' ||
                meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Price' || meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Product' ||
                meeting.MMPJ_TOPG_Detail_Line_Topic__c == 'Promotion / Communication'){
                showFileInputname = false;
                showCompInput = false;
                showProjectInput = false;
        }
    }
    
    //For init Agenda popUp if topic = None
     private void initAgendaPopUp() {        
            meeting.MMPJ_TOPG_Detail_Line_Topic__c = SetTopicAgendaPopUp;
            selectedTopicAgendaPop();
    }
    
   
    // PPPP Popup Fonctions
    /*public void closePPPPpopup()
    {
        displayPPPPpopup = false;
        DisplayPopupBackground = false;
    }
    public void ShowPPPPpopup()
    {
        displayPPPPpopup = true;
        DisplayPopupBackground = true;
        UP4P= -1;
        PPPPpopup = new MMPJ_TOPG_4P__c();

    }
    public void SavePPPPpopup()
    {
        PPPPpopup.Name = PPPPpopup.MMPJ_TOPG_Topic__c;
        if(UP4P<0)
            MapMeeting4PToinsert.put(MapMeeting4PToinsert.size(),PPPPpopup);
        else
            MapMeeting4PToinsert.put(UP4P,PPPPpopup);
        displayPPPPpopup = false;
        DisplayPopupBackground = false;
    }
    public void EditPPPPpopup()
    {
        DisplayPPPPpopup = true;
        DisplayPopupBackground = true;
        PPPPpopup = MapMeeting4PToinsert.get(UP4P);
    }*/
    //Wrapper class Attendees
    public class WrapperpaAttList
    {
        public string Function{get;set;}
        public string email {get;set;}
        public String SelectValue {get;set;}
        public Integer index {get;set;}
        public MMPJ_TOPG_Meeting__c meeting {get;set;}
    }   
   
    

    /***********************************/
    /***********************************/
    /*******Controller of Minutes*******/
    /***********************************/
    /***********************************/
    public Integer LineToRemove {get;set;}
    public Integer LineToEdit {get;set;}
    Public MMPJ_TOPG_MinuteOfMeeting__c MoM{get;set;}
    Public list<WrapperDetailLine> ListWrapperDetailLine{get;set;}
    public MMPJ_TOPG_Project__c ProjectPopUp {get;set;}
    public WrapperDetailLine DetailPopUp {get;set;}
    public boolean displayPopup {get; set;}
    public boolean displayDetailPopUp {get; set;}   
    public list<MMPJ_TOPG_MoMLineItem__c> ListDetailToDelete {get;set;}
    public Map<Id,WrapperDetailLine> mapIndexMomDetail {get;set;}
    public integer LineItemCounter{get;set;}
    public String EmailMinute{get;set;}
    public boolean MomStatusCompleted {get;set;}
    public list<SelectOption> AllMarket{get;set;}
    public list<SelectOption> SelectedMarket{get;set;}
    public list<SelectOption> AllBrand{get;set;}
    public list<SelectOption> SelectedBrand{get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listForDisplayMOMLine{get;set;}//To delete Later

    public list<WrapperDetailLine> listMOMLinePPPP {get;set;}
    public list<WrapperDetailLine> listMOMLineMarket {get;set;}
    public list<WrapperDetailLine> listMOMLineProject {get;set;}
    public list<WrapperDetailLine> listMOMLineCompetitor {get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listMOMLineToDelete{get;set;}
    public MMPJ_TOPG_RAID__c raid {get;set;}    
    public list<User> ListWrapperClassOwner {get;set;}
    public MMPJ_TOPG_Project__c currentCreatedProj {get;set;}
    public boolean isRenderedWhoWhen {get;set;}
    
    public pagereference MinutesConstructor()
    {
        system.debug('==> MinutesConstructor()');
        ListDetailToDelete = new list<MMPJ_TOPG_MoMLineItem__c>();
        listMOMLineToDelete  = new list<MMPJ_TOPG_MoMLineItem__c>();
        listMOMLinePPPP = new list<WrapperDetailLine>();
        listMOMLineMarket = new list<WrapperDetailLine>();
        listMOMLineProject = new list<WrapperDetailLine>();
        listMOMLineCompetitor =  new list<WrapperDetailLine>();
        isRenderedWhoWhen = true;       
        MomStatusCompleted =false;
        if(Meeting.id == null)
        {
            return null;
        }
        ListWrapperDetailLine = new list<WrapperDetailLine>();
        Meeting =[Select id,Name, MMPJ_TOPG_BMC__r.name,MMPJ_TOPG_BMC__r.id,MMPJ_TOPG_Comments__c,MMPJ_TOPG_Title__c,MMPJ_TOPG_Interaction__c,MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__c,MMPJ_TOPG_BMC__r.MMPJ_TOPG_BMCOwner__r.email,MMPJ_TOPG_NoAgenda__c,MMPJ_TOPG_Detail_Line_Topic__c,MMPJ_TOPG_Brand__c,
                   (select id,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_Competitor__r.name,MMPJ_TOPG_Comment__c from Meeting_Competitors__r),
                   (select id,MMPJ_TOPG_Project__c,MMPJ_TOPG_Project__r.name,MMPJ_TOPG_Comment__c from Meeting_Projects__r),
                   (select id,MMPJ_TOPG_MarketPerf__c,MMPJ_TOPG_MarketPerf__r.name,MMPJ_TOPG_FileName__c,MMPJ_TOPG_Comment__c from  Meeting_Market_Perfs__r),
                   (select id,name,MMPJ_TOPG_Comment__c,MMPJ_TOPG_Rank__c,MMPJ_TOPG_Topic__c from  Meeting_4P__r ORDER BY MMPJ_TOPG_Rank__c ASC),
                   (select id,createdDate,Createdby.name,Lastmodifiedby.name,MMPJ_TOG_MinutesDate__c,MMPJ_TOPG_Status__c,MMPJ_TOPG_Title__c ,MMPJ_TOPG_Meeting__c, MMPJ_TOPG_Location__c,MMPJ_TOPG_Start_Date__c,MMPJ_TOPG_End_Date__c,MMPJ_TOPG_Assist__c from Minutes_of_Meeting__r limit 1)
                    From MMPJ_TOPG_Meeting__c
                    Where id =:Meeting.id ];
        list<MMPJ_TOPG_MoMLineItem__c> listOfMoMDetail = new list<MMPJ_TOPG_MoMLineItem__c>();
        Map<string,MMPJ_TOPG_MoMLineItem__c> mapTopicMomDetail = new map<string,MMPJ_TOPG_MoMLineItem__c>();
        mapIndexMomDetail = new map<ID,WrapperDetailLine>();
        List<Event> listEvent = [select id,Subject,StartDateTime,ENDDateTime,IsRecurrence,Location,ownerid,whatid,
                                (select relationid,response from EventRelations  order by response)
                                from event
                                where Whatid =:Meeting.id];
        for(Event Ev : listEvent )
        {
            if(Ev.EventRelations.size() > 0)
            {
                Agenda = Ev;
                break;
            }
        }
        system.debug('==> MinutesConstructor() Agenda=' + Agenda);
        system.debug('==> MinutesConstructor() AgendaEventRelations='+ Agenda.EventRelations );
        MapCurrentAttendee = new Map<String,EventRelation>();
        ListCurrentAttendee = Agenda.EventRelations;
        ListWrapperAttendees = new list<WrapperpaAttList>();       
        
        //BTO: Begin ====== Add Metting owner to the Attendees list
        WrapperpaAttList WrapperClassOwner = new WrapperpaAttList();
        ListWrapperClassOwner= new list<user>();
        ListWrapperClassOwner = [select Id, Name, Division, title,Email
                             From User
                             Where id =: Agenda.ownerid];     
        //BTO : End=======
        for(EventRelation Att: ListCurrentAttendee )
        {         
            System.debug('==> MinutesConstructor() : Att=' + Att);
            MapCurrentAttendee.put(Att.relationid,Att);     
            WrapperpaAttList WrapperClass = new WrapperpaAttList();
            WrapperClass.meeting = new MMPJ_TOPG_Meeting__c();
            if( String.valueOf(Att.relationid).startswith('003'))
            {
                WrapperClass.meeting.MMPJ_TOPG_TECH_contact__c = Att.relationid;
                WrapperClass.SelectValue ='Contact';
                WrapperClass.index = ListWrapperAttendees.size();
                ListWrapperAttendees.add(WrapperClass);
            }
            else if( String.valueOf(Att.relationid).startswith('005') && Att.relationid != Bmc.MMPJ_TOPG_BMCOwner__c )
            {
                WrapperClass.meeting.MMPJ_TOPG_TECH_User__c = Att.relationid;
                WrapperClass.SelectValue ='User';
                WrapperClass.index = ListWrapperAttendees.size();
                ListWrapperAttendees.add(WrapperClass);
            }
        }

        if(meeting.id != null && Meeting.Minutes_of_Meeting__r.size() >0)
        {
			system.debug('MinutesConstructor(), Meeting.Minutes_of_Meeting__r[0]=' + Meeting.Minutes_of_Meeting__r[0]);
            MoM= Meeting.Minutes_of_Meeting__r[0];
            listOfMoMDetail = [select MMPJ_TOPG_RAID__c,MMPJ_TOPG_Topic__c,MMPJ_TOPG_Detail_Line_Topic__c,RecordType.Name,MMPJ_TOPG_RelatedProduct__r.name,MMPJ_TOPG_TopicPPPP__c,MMPJ_TOPG_MeetingProject__c,MMPJ_TOPG_MeetingMarketPerf__c ,MMPJ_TOPG_MeetingCompetitor__c,MMPJ_TOPG_MeetingPPPP__c ,MMPJ_TOPG_Competitor__r.name,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_MinutesofMeeting__c,
                                MMPJ_TOPG_RelatedProject__r.name,MMPJ_TOPG_Title__c,Createdby.name,MMPJ_TOPG_When__c,MMPJ_TOPG_IsHighlight__c,MMPJ_TOPG_RelatedProject__c,
                                MMPJ_TOPG_RelatedProduct__c,MMPJ_TOPG_WhoU__c,MMPJ_TOPG_WhoU__r.name,MMPJ_TOPG_Rank__c,MMPJ_TOPG_WhoC__c,MMPJ_TOPG_WhoC__r.name,MMPJ_TOPG_Comment__c,
                                MMPJ_TOPG_FileName__c,MMPJ_TOPG_Brand__c,MMPJ_TOPG_Action_Title__c,
                               (select id,name,parentId from attachments)
                               from MMPJ_TOPG_MoMLineItem__c
                               where MMPJ_TOPG_MinutesofMeeting__c =:MoM.id
                               Order By MMPJ_TOPG_Rank__c ASC];

            List<Attachment> att = [SELECT Name, Id, ContentType, CreatedDate, ParentId FROM Attachment WHERE ParentId=:MoM.id];
			system.debug('MinutesConstructor(), att.size=' + att.size() + ', att=' + att);
            for(MMPJ_TOPG_MoMLineItem__c MomDetail: listOfMoMDetail )
            {
				system.debug('MinutesConstructor(), MomDetail=' + MomDetail);
                WrapperDetailLine Wrapper = new WrapperDetailLine();
                Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                Wrapper.LineItem = MomDetail;
                Wrapper.index = Integer.valueof(MomDetail.MMPJ_TOPG_Rank__c);
                if(MomDetail.MMPJ_TOPG_MeetingPPPP__c != null || MomDetail.MMPJ_TOPG_MeetingCompetitor__c != null || MomDetail.MMPJ_TOPG_MeetingMarketPerf__c != null || MomDetail.MMPJ_TOPG_MeetingProject__c != null)
                {
                    if(MomDetail.MMPJ_TOPG_MeetingPPPP__c != null)
                        mapIndexMomDetail.put(MomDetail.MMPJ_TOPG_MeetingPPPP__c,Wrapper);
                    if(MomDetail.MMPJ_TOPG_MeetingCompetitor__c != null)
                        mapIndexMomDetail.put(MomDetail.MMPJ_TOPG_MeetingCompetitor__c,Wrapper);
                    if(MomDetail.MMPJ_TOPG_MeetingMarketPerf__c != null) {
						mapIndexMomDetail.put(MomDetail.MMPJ_TOPG_MeetingMarketPerf__c,Wrapper);
						system.debug('MinutesConstructor(), mapIndexMomDetail.put(MomDetail.MMPJ_TOPG_MeetingMarketPerf__c,Wrapper)=' + MomDetail.MMPJ_TOPG_MeetingMarketPerf__c);
					}
                    if(MomDetail.MMPJ_TOPG_MeetingProject__c != null)
                        mapIndexMomDetail.put(MomDetail.MMPJ_TOPG_MeetingProject__c ,Wrapper);
                    Wrapper.MeetingTopic = true;
                }
                else
                {
                    Wrapper.MeetingTopic = false;
                }

                if(MomDetail.MMPJ_TOPG_WhoU__c != null)
                {
                    Wrapper.SelectValue = 'User';
                    Wrapper.Who = MomDetail.MMPJ_TOPG_WhoU__r.name;
                }
                else
                {
                    Wrapper.SelectValue = 'Contact';
                    Wrapper.Who = MomDetail.MMPJ_TOPG_WhoC__r.name;
                }
                string s = '';
                if(Wrapper.LineItem.MMPJ_TOPG_Comment__c!=null)                    
                    s = Wrapper.LineItem.MMPJ_TOPG_Comment__c;
                Wrapper.CommentThreeLine =s;              
                //===BTO== Begin: Suppression de l'affichage des 3 premières ligne du commentaire ===*/
                /* if(s.length() > 240)
                    Wrapper.CommentThreeLine =s.abbreviate(230);
                if(s.countMatches('\n') > 2)
                   Wrapper.CommentThreeLine =s.abbreviate(3 + s.indexOf('\n', 1 + s.indexOf('\n', 1 + s.indexOf('\n')))); */
                //===BTO== End: Suppression de l'affichage des 3 premières ligne du commentaire ===*/
                Wrapper.CommentThreeLine = Wrapper.CommentThreeLine.replaceAll('\n','<br/>');
                Wrapper.Project = MomDetail.MMPJ_TOPG_RelatedProject__r.name;
                Wrapper.comp = MomDetail.MMPJ_TOPG_Competitor__r.name;
                Wrapper.Product= MomDetail.MMPJ_TOPG_RelatedProduct__r.name;
                if(MomDetail.RecordType.Name == 'Line Item 4P' ) {
					system.debug('MinutesConstructor(), MomDetail.RecordType.Name=(Line Item 4P), Wrapper= ' + Wrapper);
					listMOMLinePPPP.add(Wrapper);
				}
                if(MomDetail.RecordType.Name == 'Line item Market Performance' )
                {
					system.debug('MinutesConstructor(), TGS-33, MomDetail.attachments.size()= ' + MomDetail.attachments.size());
                    system.debug('MinutesConstructor(), MomDetail= ' + MomDetail);
                    if(MomDetail.attachments.size() > 0) {
                        Wrapper.LineItem.MMPJ_TOPG_FileName__c = MomDetail.attachments[0].name;
						system.debug('MinutesConstructor(), MomDetail.attachments[0].name= ' + MomDetail.attachments[0].name);
					} else if (( MomDetail.MMPJ_TOPG_FileName__c != null ) && ( MomDetail.MMPJ_TOPG_FileName__c != 'File or text')) { // TGS-33
						Wrapper.LineItem.MMPJ_TOPG_FileName__c = MomDetail.MMPJ_TOPG_FileName__c;
                    } else {
                        Wrapper.LineItem.MMPJ_TOPG_FileName__c = '';
                    }
					listMOMLineMarket.add(Wrapper);
					system.debug('MinutesConstructor(), MomDetail.RecordType.Name=(Line item Market Performance), listMOMLineMarket.add(Wrapper)= ' + listMOMLineMarket);
                }
                if(MomDetail.RecordType.Name == 'Line Item Project' ) {
					system.debug('MinutesConstructor(), MomDetail.RecordType.Name=(Line Item Project), Wrapper.Project= ' + Wrapper.Project);
					listMOMLineProject.add(Wrapper);
				}
                if(MomDetail.RecordType.Name == 'Line item Competitor' ) {
					system.debug('MinutesConstructor(), MomDetail.RecordType.Name=(Line item Competitor), Wrapper.comp= ' + Wrapper.comp);
					listMOMLineCompetitor.add(Wrapper);
				}
            }
        }
        system.debug('%%%% mapIndexMomDetail ' + mapIndexMomDetail);
        For(MMPJ_TOPG_4P__c fourP : Meeting.Meeting_4P__r )
        {
			system.debug('MinutesConstructor(), fourP= ' + fourP);
            if(mapIndexMomDetail.containskey(fourP.Id))
                continue;
            if(fourP.MMPJ_TOPG_Comment__c == null)
            {
                WrapperDetailLine Wrapper = new WrapperDetailLine();
                Wrapper.MeetingTopic =true;
                Wrapper.index =mapIndexMomDetail.size();
                Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                Wrapper.LineItem.MMPJ_TOPG_TopicPPPP__c = fourP.MMPJ_TOPG_Topic__c ;
                // Wrapper.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = fourP.MMPJ_TOPG_Topic__c ;
                Wrapper.LineItem.MMPJ_TOPG_Comment__c= '' ;
                Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item 4P').getRecordTypeId();
                Wrapper.LineItem.MMPJ_TOPG_MeetingPPPP__c = fourP.Id;
                Wrapper.SelectValue = 'Contact';
                listMOMLinePPPP.add(Wrapper);
            }
            else
            {
                list<string> ListWords = fourP.MMPJ_TOPG_Comment__c.split('-');
                for(string Word : ListWords)
                {
                    if(Word.length()<1)
                        continue;
                    WrapperDetailLine Wrapper = new WrapperDetailLine();
                    Wrapper.MeetingTopic =true;
                    Wrapper.index =mapIndexMomDetail.size();
                    Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                    Wrapper.LineItem.MMPJ_TOPG_TopicPPPP__c = fourP.MMPJ_TOPG_Topic__c ;
                    Wrapper.LineItem.MMPJ_TOPG_Comment__c= '-' + Word  ;
                    string s = '';
                    if(Wrapper.LineItem.MMPJ_TOPG_Comment__c!=null)
                        s = Wrapper.LineItem.MMPJ_TOPG_Comment__c;
                    Wrapper.CommentThreeLine =s;
                   
                //===BTO== Begin: Suppression de l'affichage des 3 premières ligne du commentaire ===//                    
                  /*  if(s.length() > 240)
                        Wrapper.CommentThreeLine =s.abbreviate(230);
                    if(s.countMatches('\n') > 2)
                        Wrapper.CommentThreeLine =s.abbreviate(3 + s.indexOf('\n', 1 + s.indexOf('\n', 1 + s.indexOf('\n'))));*/
                    //===BTO== End: Suppression de l'affichage des 3 premières ligne du commentaire ===//
                    Wrapper.CommentThreeLine = Wrapper.CommentThreeLine.replaceAll('\n','<br/>');
                    Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item 4P').getRecordTypeId();
                    Wrapper.LineItem.MMPJ_TOPG_MeetingPPPP__c = fourP.Id;
                    Wrapper.SelectValue = 'Contact';
                    listMOMLinePPPP.add(Wrapper);
                }
            }
        }

        for(MMPJ_TOPG_MeetingProject__c Project : Meeting.Meeting_Projects__r)
        {
			system.debug('MinutesConstructor(), Project= ' + Project);
            if(mapIndexMomDetail.containskey(Project.id))
                continue;
            if(Project.MMPJ_TOPG_Comment__c == null)
            {
                WrapperDetailLine Wrapper = new WrapperDetailLine();
                Wrapper.MeetingTopic =true;
                Wrapper.Project =Project.MMPJ_TOPG_Project__r.name;
                Wrapper.index =mapIndexMomDetail.size();
                Wrapper.SelectValue = 'Contact';
                Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                Wrapper.LineItem.MMPJ_TOPG_RelatedProject__c = Project.MMPJ_TOPG_Project__c ;
                Wrapper.LineItem.MMPJ_TOPG_Comment__c= '';
                Wrapper.LineItem.MMPJ_TOPG_MeetingProject__c = Project.id ;
                Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
                Wrapper.SelectValue = 'Contact';
                listMOMLineProject.add(Wrapper);
            }
            else
            {
                list<string> ListWords = Project.MMPJ_TOPG_Comment__c.split('-');               
                for(string Word : ListWords)
                {
                    if(Word.length()<1)
                        continue;
                    WrapperDetailLine Wrapper = new WrapperDetailLine();
                    Wrapper.MeetingTopic =true;
                    Wrapper.Project =Project.MMPJ_TOPG_Project__r.name;
                    Wrapper.index =mapIndexMomDetail.size();
                    Wrapper.SelectValue = 'Contact';
                    Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                    Wrapper.LineItem.MMPJ_TOPG_RelatedProject__c = Project.MMPJ_TOPG_Project__c ;
                    Wrapper.LineItem.MMPJ_TOPG_Comment__c= '-' + Word  ;
                    string s = '';
                    if(Wrapper.LineItem.MMPJ_TOPG_Comment__c!=null)
                        s = Wrapper.LineItem.MMPJ_TOPG_Comment__c;
                    Wrapper.CommentThreeLine =s;
                   //===BTO== Begin: Suppression de l'affichage des 3 premières ligne du commentaire ===*/
                   /* if(s.length() > 240)
                        Wrapper.CommentThreeLine =s.abbreviate(230);
                    if(s.countMatches('\n') > 2)
                        Wrapper.CommentThreeLine =s.abbreviate(3 + s.indexOf('\n', 1 + s.indexOf('\n', 1 + s.indexOf('\n'))));*/
                    //===BTO== End: Suppression de l'affichage des 3 premières ligne du commentaire ===*/
                    Wrapper.CommentThreeLine = Wrapper.CommentThreeLine.replaceAll('\n','<br/>');
                    Wrapper.LineItem.MMPJ_TOPG_MeetingProject__c = Project.id ;
                    Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
                    Wrapper.SelectValue = 'Contact';
                    listMOMLineProject.add(Wrapper);
                }
            }
        }
        for(MMPJ_TOPG_MeetingMarketPerf__c Market : Meeting.Meeting_Market_Perfs__r )
        {
			system.debug('MinutesConstructor(), Market= ' + Market);
            if(mapIndexMomDetail.containskey(Market.id))
                continue;
            if(Market.MMPJ_TOPG_Comment__c == null)
            {
                WrapperDetailLine Wrapper = new WrapperDetailLine();
                Wrapper.MeetingTopic =true;
                Wrapper.index =mapIndexMomDetail.size();
                Wrapper.SelectValue = 'Contact';
                Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                Wrapper.LineItem.MMPJ_TOPG_FileName__c = Market.MMPJ_TOPG_FileName__c;
                Wrapper.LineItem.MMPJ_TOPG_Comment__c = '' ;
                Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
                Wrapper.LineItem.MMPJ_TOPG_MeetingMarketPerf__c = Market.id;
                Wrapper.SelectValue = 'Contact';
                listMOMLineMarket.add(Wrapper);
				system.debug('MinutesConstructor(), listMOMLineMarket= ' + listMOMLineMarket);
            }
            else
            {
                list<string> ListWords = Market.MMPJ_TOPG_Comment__c.split('-');
                for(string Word : ListWords)
                {
                    if(Word.length()<1)
                        continue;
                    WrapperDetailLine Wrapper = new WrapperDetailLine();
                    Wrapper.MeetingTopic =true;
                    Wrapper.index =mapIndexMomDetail.size();
                    Wrapper.SelectValue = 'Contact';
                    Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                    Wrapper.LineItem.MMPJ_TOPG_FileName__c = Market.MMPJ_TOPG_FileName__c;
                    Wrapper.LineItem.MMPJ_TOPG_Comment__c = '-' + Word  ;
                    string s = '';
                    if(Wrapper.LineItem.MMPJ_TOPG_Comment__c!=null)
                        s = Wrapper.LineItem.MMPJ_TOPG_Comment__c;
                    Wrapper.CommentThreeLine =s;
                    //===BTO== Begin: Suppression de l'affichage des 3 premières ligne du commentaire ===*/
                   /* if(s.length() > 240)
                        Wrapper.CommentThreeLine =s.abbreviate(230);
                    if(s.countMatches('\n') > 2)
                        Wrapper.CommentThreeLine =s.abbreviate(3 + s.indexOf('\n', 1 + s.indexOf('\n', 1 + s.indexOf('\n'))));*/
                    //===BTO== End: Suppression de l'affichage des 3 premières ligne du commentaire ===//
                    Wrapper.CommentThreeLine = Wrapper.CommentThreeLine.replaceAll('\n','<br/>');
                    Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
                    Wrapper.LineItem.MMPJ_TOPG_MeetingMarketPerf__c = Market.id;
                    Wrapper.SelectValue = 'Contact';
                    listMOMLineMarket.add(Wrapper);
					system.debug('MinutesConstructor(), listMOMLineMarket= ' + listMOMLineMarket);
                }
            }
        }
        for(MMPJ_TOPG_MeetingCompetitor__c Comp : Meeting.Meeting_Competitors__r )
        {
			system.debug('MinutesConstructor(), Comp= ' + Comp);
            if(mapIndexMomDetail.containskey(Comp.Id))
                continue;
            if(Comp.MMPJ_TOPG_Comment__c == null)
            {
                WrapperDetailLine Wrapper = new WrapperDetailLine();
                Wrapper.MeetingTopic = true;
                Wrapper.Comp = Comp.MMPJ_TOPG_Competitor__r.name;
				system.debug('MinutesConstructor(), Cas 1 : Wrapper.Comp= ' + Wrapper.Comp);
                Wrapper.index = mapIndexMomDetail.size();
                Wrapper.SelectValue = 'Contact';
                Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                Wrapper.LineItem.MMPJ_TOPG_Competitor__c = Comp.MMPJ_TOPG_Competitor__c ;
                Wrapper.LineItem.MMPJ_TOPG_Comment__c = '' ;
                Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
                Wrapper.LineItem.MMPJ_TOPG_MeetingCompetitor__c = Comp.Id;
                Wrapper.SelectValue = 'Contact';
                listMOMLineCompetitor.add(Wrapper);
            }
            else
            {
                list<string> ListWords = Comp.MMPJ_TOPG_Comment__c.split('-');
				system.debug('MinutesConstructor(), ListWords= ' + ListWords);
                for(string Word : ListWords)
                {
                    if(Word.length()<1)
                        continue;
                    WrapperDetailLine Wrapper = new WrapperDetailLine();
                    Wrapper.MeetingTopic = true;
                    Wrapper.Comp = Comp.MMPJ_TOPG_Competitor__r.name;
					system.debug('MinutesConstructor(), Cas 2 : Wrapper.Comp= ' + Wrapper.Comp);
                    Wrapper.index = mapIndexMomDetail.size();
                    Wrapper.SelectValue = 'Contact';
                    Wrapper.LineItem = new MMPJ_TOPG_MoMLineItem__c();
                    Wrapper.LineItem.MMPJ_TOPG_Competitor__c = Comp.MMPJ_TOPG_Competitor__c ;
                    Wrapper.LineItem.MMPJ_TOPG_Comment__c = '-' + Word  ;
                    string s = '';
                    if(Wrapper.LineItem.MMPJ_TOPG_Comment__c!=null)
                        s = Wrapper.LineItem.MMPJ_TOPG_Comment__c;
                    Wrapper.CommentThreeLine =s;
                    //===BTO== Begin: Suppression de l'affichage des 3 premières ligne du commentaire ===*/
                   /* if(s.length() > 240)
                        Wrapper.CommentThreeLine =s.abbreviate(230);
                    if(s.countMatches('\n') > 2)
                        Wrapper.CommentThreeLine =s.abbreviate(3 + s.indexOf('\n', 1 + s.indexOf('\n', 1 + s.indexOf('\n'))));*/
                    //===BTO== End: Suppression de l'affichage des 3 premières ligne du commentaire ===//
                    Wrapper.CommentThreeLine = Wrapper.CommentThreeLine.replaceAll('\n','<br/>');
                    Wrapper.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
                    Wrapper.LineItem.MMPJ_TOPG_MeetingCompetitor__c = Comp.Id;
                    Wrapper.SelectValue = 'Contact';
                    listMOMLineCompetitor.add(Wrapper);
                }
            }

        }

        String PDFname = Meeting.Name +'-Minute.pdf';
        EmailMinute ='javascript:void(0)';
        //List<attachment> 
            listAtt = [Select Name
                                   from attachment
                                   Where Name =: PDFname ];
        AutomateFunction();
        if(listAtt.size() > 0 && listAtt != null)
        {
            //BTO= > put email organizer as copy 
            String KPOKEmail = ListWrapperClassOwner.get(0).Email == null ? '' : ListWrapperClassOwner.get(0).Email ;
            String noagendaTxt = '';
            if(!Meeting.MMPJ_TOPG_NoAgenda__c)
                noagendaTxt = 'As a reminder, you can find the meeting agenda clicking the link below:%0D%0A'+ Label.MMPJ_TOPG_GetMeetingsLink +'?what=pdfAgenda%26relatedId=' + Meeting.Id +'%0D%0A%0D%0A';
            PrintPDFActive = true;
            EmailMinute='mailto:';
            for(WrapperpaAttList  Wrapper : ListWrapperAttendees)
                if(Wrapper.email != null)
                    EmailMinute+= Wrapper.email + ';';
                                   EmailMinute += + '?cc='+ KPOKEmail + ';'
                                   +'&subject=' + Mom.MMPJ_TOPG_title__c
                                   +'&body=Hello,%0D%0A%0D%0A'
                                   +'Please find here below the link to the minutes of meeting regarding '+ Agenda.Subject + ' that took place on ' + Agenda.StartDateTime.format() +'%0D%0A'
                                   + Label.MMPJ_TOPG_GetMeetingsLink +'?what=pdfMinute%26relatedId=' + Meeting.Id +'%0D%0A%0D%0A'
                                   +noagendaTxt
                                   +'Kindest Regards,%0D%0A%0D%0A'
                                   +UserInfo.getName()+'%0D%0ASent from TOPGUN App';
        }
        if(MoM.MMPJ_TOPG_Status__c =='Completed')
            MomStatusCompleted = true ;

        return null;
    }
    public boolean UpdateMin()
    {
        try{
            if(Meeting.Id == null)
            {
                Error = true;
                ErrorMessage= 'You should create an Agenda first' ;
                return false;
            }
            
            //BTO === controle on minutes dates
            if((Meeting.MMPJ_TOPG_NoAgenda__c == true)&& (MoM.MMPJ_TOPG_Start_Date__c > MoM.MMPJ_TOPG_End_Date__c ))
            {
				Error = true;
				ErrorMessage= 'The End date must be greater than the Start date.';
				return false;
            }
            system.debug('#### Update Mom ' + MoM);
            upsert MoM;
            
            //BTO => Set  meeting title = Agenda title
            if(Meeting.MMPJ_TOPG_NoAgenda__c == true){              
                Agenda.Subject = MoM.MMPJ_TOPG_Title__c;
                Agenda.Location = MoM.MMPJ_TOPG_Location__c ;                 
                Meeting.MMPJ_TOPG_Title__c = MoM.MMPJ_TOPG_Title__c;
                Meeting.name = MoM.MMPJ_TOPG_Title__c;
                InserNoAgenda(); 
            }
            list<MMPJ_TOPG_MoMLineItem__c> listDetailToInsert = new list<MMPJ_TOPG_MoMLineItem__c>();
            list<MMPJ_TOPG_MoMLineItem__c> listDetailToUpdate = new list<MMPJ_TOPG_MoMLineItem__c>();
            list<WrapperDetailLine> listallWrapper = new list<WrapperDetailLine>();
            for(integer i = 0; i < listMOMLineCompetitor.size(); i++){
                listMOMLineCompetitor[i].LineItem.MMPJ_TOPG_Rank__c = i;
                system.debug('####  listMOMLineCompetitor[i] MMPJ_TOPG_RelatedProject__cMMPJ_TOPG_RelatedProject__c :' +  listMOMLineCompetitor[i].LineItem.MMPJ_TOPG_RelatedProject__c);
            }
            for(integer i = 0; i < listMOMLineProject.size(); i++){
                listMOMLineProject[i].LineItem.MMPJ_TOPG_Rank__c = i;
            }
            for(integer i = 0; i < listMOMLineMarket.size(); i++){
                listMOMLineMarket[i].LineItem.MMPJ_TOPG_Rank__c = i;
            }
            for(integer i = 0; i < listMOMLinePPPP.size(); i++){
                listMOMLinePPPP[i].LineItem.MMPJ_TOPG_Rank__c = i;
            }
            listallWrapper.addAll(listMOMLinePPPP);
            listallWrapper.addAll(listMOMLineMarket);
            listallWrapper.addAll(listMOMLineProject);
            listallWrapper.addAll(listMOMLineCompetitor);
			system.debug('=> UpdateMin() : listMOMLinePPPP=' + listMOMLinePPPP);
			system.debug('=> UpdateMin() : listMOMLineMarket=' + listMOMLineMarket);
			system.debug('=> UpdateMin() : listMOMLineProject=' + listMOMLineProject);
			system.debug('=> UpdateMin() : listMOMLineCompetitor=' + listMOMLineCompetitor);
            for(WrapperDetailLine Wrapper : listallWrapper )
            {
				//system.debug('=> UpdateMin() : Wrapper=' + Wrapper);
                if(Wrapper.SelectValue == 'Contact' )
                {
                    Wrapper.LineItem.MMPJ_TOPG_WhoU__c = null;
                }
                else
                {
                    Wrapper.LineItem.MMPJ_TOPG_WhoC__c = null;
                }

                if(Wrapper.LineItem.MMPJ_TOPG_MinutesofMeeting__c == null)
                {
                    Wrapper.LineItem.MMPJ_TOPG_MinutesofMeeting__c = MoM.id;
                    listDetailToInsert.add(Wrapper.LineItem );
                }
                else
                {
                    listDetailToUpdate.add(Wrapper.LineItem);
                }
            }
            system.debug('=> UpdateMin() : listDetailToInsert=' + listDetailToInsert);
            system.debug('=> UpdateMin() : listDetailToUpdate=' + listDetailToUpdate);
            if(!SaveAttendeesMinutes())
                return false;
            insert listDetailToInsert;
            update listDetailToUpdate;
            if(listMOMLineToDelete.size() >0)
                delete listMOMLineToDelete;

        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return false;
        }
        Error = false;
        SuccessMessage ='The Minutes has been saved successfully!';
        ShowSaveMessage_newCounter++;
        return true;
    }
    public Boolean SaveAttendeesMinutes(){
        System.debug('==> SaveAttendeesMinutes() : ListWrapperAttendees.size()=' + ListWrapperAttendees.size());
        try{
           /* if(ListWrapperAttendees.size() ==0 && !Meeting.MMPJ_TOPG_NoAgenda__c)
            {
                Error = true;
                ErrorMessage= 'You should atleast have one attendee.';
                return false;
            } */
           
            if(ListWrapperAttendees.size() ==0)
            {
                for(String KeyCurrent : MapCurrentAttendee.keySet())
                    if(MapCurrentAttendee.get(KeyCurrent).relationId == meeting.id)
                        MapCurrentAttendee.remove(KeyCurrent);
                if(MapCurrentAttendee.size()>0)
                    delete MapCurrentAttendee.values();
                return true;
            }

            MapAttendee =new Map<string,EventRelation>();
            set<id> SetIdAttendee = new set<id>();           
            for(WrapperpaAttList Att : ListWrapperAttendees )
            {
                EventRelation Attendee = new EventRelation();
                Attendee.EventId = agenda.id;             
               
                if(Att.meeting.MMPJ_TOPG_TECH_user__c == Agenda.ownerid)
                {
                    Att.meeting.MMPJ_TOPG_TECH_user__c.addError('You cannot add the owner of the event as an invitee.');
                    return false;
                }
                if(Att.SelectValue == 'User' && Att.meeting.MMPJ_TOPG_TECH_user__c != null && Bmc.MMPJ_TOPG_BMCOwner__c != Att.meeting.MMPJ_TOPG_TECH_user__c)
                {
                    Attendee.RelationId = Att.meeting.MMPJ_TOPG_TECH_user__c;
                    SetIdAttendee.add(Att.meeting.MMPJ_TOPG_TECH_user__c);
                    MapAttendee.put(Attendee.RelationId,Attendee);
                }
                else if(Att.SelectValue == 'Contact' && Att.meeting.MMPJ_TOPG_TECH_contact__c!= null)
                {
                    Attendee.RelationId = Att.meeting.MMPJ_TOPG_TECH_contact__c;
                    SetIdAttendee.add(Att.meeting.MMPJ_TOPG_TECH_contact__c);
                    MapAttendee.put(Attendee.RelationId,Attendee);
                }                
            }

            system.debug('SaveAttendeesMinutes => ####MapAttendee.isEmpty() : ' + MapAttendee.size()); 
            system.debug('SaveAttendeesMinutes => ####MapAttendee.isEmpty() values : ' + MapAttendee.values());
            if(MapAttendee.isEmpty())
            {
                ListWrapperAttendees[0].meeting.MMPJ_TOPG_TECH_contact__c.addError('You should atleast have one attendee.');
                ListWrapperAttendees[0].meeting.MMPJ_TOPG_TECH_user__c.addError('You should atleast have one attendee.');
                system.debug('==> SaveAttendeesMinutes : MapAttendee isEmpty, error : You should atleast have one attendee');
                return false;
            }
            if(MapAttendee.size() != SetIdAttendee.size())
            {
                Error = true;
                ErrorMessage= 'DUPLICATE_VALUE : Please verify the attendees for duplicate value.';
                system.debug('==> SaveAttendeesMinutes : duplicate value error');
                return false;
            }

            if(!MapAttendee.isEmpty())
            {
                if(Bmc.MMPJ_TOPG_BMCOwner__c != Agenda.ownerid )
                {
                    if( Agenda.ownerid == null && Bmc.MMPJ_TOPG_BMCOwner__c != Userinfo.getUserId())
                    {
                        EventRelation Attendee = new EventRelation();
                        Attendee.EventId = agenda.id;
                        Attendee.RelationId = Bmc.MMPJ_TOPG_BMCOwner__c;
                        MapAttendee.put(Attendee.RelationId,Attendee);
                    }
                }
            }
            system.debug('SaveAttendeesMinutes #### Update Attendees');
            system.debug('SaveAttendeesMinutes #### MapCurrentAttendee ' + MapCurrentAttendee);
            system.debug('SaveAttendeesMinutes #### MapAttendee.values() before remove ' + MapAttendee.values());
            system.debug('SaveAttendeesMinutes #### MapAttendee.size before remove ' + MapAttendee.size());
            for(String KeyCurrent : MapCurrentAttendee.keySet())
            {
                if(MapCurrentAttendee.get(KeyCurrent).relationId == meeting.id)
                {
                    MapCurrentAttendee.remove(KeyCurrent);
                    MapAttendee.remove(KeyCurrent);
                }
            }
            
            system.debug('SaveAttendeesMinutes #### MapAttendee.values() after remove ' + MapAttendee.values());
            system.debug('SaveAttendeesMinutes #### MapAttendee.size after remove ' + MapAttendee.size());
            integer rank = 0;
            for(EventRelation  eva : MapAttendee.values())
            {
                eva.EventId = agenda.id;
                eva.response = rank.format();
                rank++;
            }
            system.debug('#### AttendeeToDelete '+ MapCurrentAttendee);
            system.debug('#### MapAttendee '+ MapAttendee);
            if(MapCurrentAttendee.size() > 0)
                delete MapCurrentAttendee.values();
            if(MapAttendee.size() > 0){
                Set<EventRelation> setAttendToInsert = new set<EventRelation>();
                setAttendToInsert.addAll(MapAttendee.values()); 
                List<EventRelation> lstToInsert = new list<EventRelation>();
                lstToInsert.addAll(setAttendToInsert);
                upsert lstToInsert;                
            }
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return false;
        }
        return true;
    }
    public pagereference SaveAndCloseMin()
    {
        Boolean Succeed = false;
        if(MoM.MMPJ_TOPG_Status__c =='Completed')
            Succeed = PrintMomPDF();
        else
            Succeed = UpdateMin();
        if(!Succeed)
            return null;
        return cancel();
    }
    public pagereference SaveMin()
    {
        Boolean Succeed = false;
        if(MoM.MMPJ_TOPG_Status__c =='Completed')
           Succeed = PrintMomPDF();
        else
            Succeed = UpdateMin();
        if(!Succeed)
            return null;
        agendaConstructor();
        return null;
    }
    public pagereference LeavingMin()
    {
        Boolean Succeed = false;
        if(MoM.MMPJ_TOPG_Status__c =='Completed')
            Succeed = PrintMomPDF();
        else
            Succeed = UpdateMin();
        if(Succeed)
        {
            saveComplete++;
            system.debug(' newTab  ' +newTab + ' newTabTobe ' + newTabTobe);
            newTab = newTabTobe;
        }
        agendaConstructor();
        return null;
    }
    
    //========BTO => Begin Add TODO Method=========//
	private Void AddTodo( MMPJ_TOPG_RAID__c raid) {     
        
        boolean isNew = false;
		system.debug('=> AddTodo() : raid=' + raid);
        if(raid.id == null)
            isNew = true;
        upsert raid;
        if(isNew)
        {
            Task Tache = new Task();
            if(raid.MMPJ_TOPG_User__c != null)
                Tache.OwnerId = raid.MMPJ_TOPG_User__c;
            else
            Tache.Whoid= raid.MMPJ_TOPG_Contact__c;
            Tache.Description = raid.MMPJ_TOPG_Description__c;
            Tache.ActivityDate = raid.MMPJ_TOPG_ExpectedDate__c;
            Tache.WhatId = raid.id;
            Tache.Status = raid.MMPJ_TOPG_Status__c;
            Tache.Subject = raid.MMPJ_TOPG_Title__c;
            Tache.MMPJ_TOPG_ProjectRaid__c = true;
            Tache.MMPJ_TOPG_ProjectChanged__c = true;
            insert Tache; 
            system.debug('##### Tache ' + Tache);  
        }
    /*  if(!isNew)
        {
            List<Task> ListTaskExistant = [SELECT id, OwnerId, Description, ActivityDate, WhatId, Status, Subject, MMPJ_TOPG_ProjectRaid__c, MMPJ_TOPG_ProjectChanged__c
                                           FROM task
                                           WHERE WhatId =: raid.id AND MMPJ_TOPG_ProjectRaid__c = true];
            for(task Tache : ListTaskExistant)
            {
                if(raid.MMPJ_TOPG_User__c != null)
                {
                    Tache.OwnerId = raid.MMPJ_TOPG_User__c;
                    Tache.Whoid= null;
                }
                else
                {
                    Tache.Whoid= raid.MMPJ_TOPG_Contact__c;
                    Tache.OwnerId = UserInfo.getUserId();
                }
                Tache.Description = raid.MMPJ_TOPG_Description__c;
                Tache.ActivityDate = raid.MMPJ_TOPG_ExpectedDate__c;
                Tache.Status = raid.MMPJ_TOPG_Status__c;
                Tache.Subject = raid.MMPJ_TOPG_Title__c;
                if(Tache.MMPJ_TOPG_ProjectChanged__c == true)
                    Tache.MMPJ_TOPG_ProjectChanged__c = false;
                else
                    Tache.MMPJ_TOPG_ProjectChanged__c = true;
            }
            update ListTaskExistant;
            system.debug('##### ListTaskExistant ' + ListTaskExistant);
        }*/
      
    }
    //========BTO => End Add TODO Method=========//
    
    //Detail Line Function

     
    /************************************************************* MARKET PERFORMANCE **************************************************************************/
    public void AddMarketMom()
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
        DetailPopUp.index = listMOMLineMarket.size();
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';
        DetailPopUp.LineItem.MMPJ_TOPG_FileName__c = ' ';
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=SetTopicMinutePopUp;        
        DetailPopUp.TopicType ='Market';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = true;
		system.debug('=> AddMarketMom(), DetailPopUp=' + DetailPopUp);
        /*
        Id MarketLineRecordTypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
        //system.debug('#### FileInput ' + FileInput + ' ##### FileInputname ' + FileInputname);
        if(FileInput == null)
            return null;
        try{
            if(FileInput.size() > 0)
            {
                MMPJ_TOPG_MoMLineItem__c MomLineMarket = new MMPJ_TOPG_MoMLineItem__c();
                MomLineMarket.MMPJ_TOPG_Rank__c = listMOMLineMarket.size();
                MomLineMarket.MMPJ_TOPG_FileName__c = FileInputname;
                MomLineMarket.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
                MomLineMarket.recordtypeId = MarketLineRecordTypeId ;
                insert MomLineMarket;

                Attachment AttachmentMarket = new Attachment();
                AttachmentMarket.body = FileInput;
                AttachmentMarket.name = FileInputname;
                AttachmentMarket.parentId = MomLineMarket.Id;
                insert AttachmentMarket;

                WrapperDetailLine Wrapper = new WrapperDetailLine();
                Wrapper.MeetingTopic = false;
                Wrapper.index = listMOMLineMarket.size();
                Wrapper.SelectValue = 'Contact';
                Wrapper.LineItem = MomLineMarket;

                listMOMLineMarket.add(Wrapper);
            }
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
        }
        */
    }
    public void EditMarketMom()
    {
        DetailPopUp  = listMOMLineMarket[LineItemCounter] ;
		system.debug('=> EditMarketMom(), DetailPopUp=' + DetailPopUp);
        if(DetailPopUp.MeetingTopic){
            if(DetailPopUp.LineItem.MMPJ_TOPG_FileName__c == 'File or text') {
                DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Add document';
            }else {
                DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Market Performance';
            }           
        }
        
        if( DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c == null && DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c == null ){
            DetailPopUp.SelectValue ='User';
        }
        DetailPopUp.TopicType ='Market';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = true;
    }
    public void DelMarketLine()
    {
        try{

            delete listMOMLineMarket.get(LineItemCounter).LineItem ;
            listMOMLineMarket.remove(LineItemCounter);
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
        }
    }
    public void GoUPMarketLine(){
        if(LineItemCounter > 0)
            listMOMLineMarket.add(LineItemCounter-1, listMOMLineMarket.remove(LineItemCounter));
    }
    
    //BTO
     private void AddMarketMomFromTopic(String topic)
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
        DetailPopUp.index = listMOMLineMarket.size();
        if(topic == 'Add document'){
             DetailPopUp.LineItem.MMPJ_TOPG_FileName__c = 'File or text';
        }else {
             DetailPopUp.LineItem.MMPJ_TOPG_FileName__c = ' ';  
        }             
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = topic;        
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';        
        DetailPopUp.TopicType ='Market';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = true;
		system.debug('=> AddMarketMomFromTopic(), DetailPopUp=' + DetailPopUp);
    }
    /**************************************************************************************************************************************************************/
    /******************************************************************************** 4P **************************************************************************/
    public void AddPPPPMom()
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item 4P').getRecordTypeId();
        DetailPopUp.index = listMOMLinePPPP.size();
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=SetTopicMinutePopUp;        
        DetailPopUp.TopicType ='PPPP';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = true;
		system.debug('=> AddPPPPMom(), DetailPopUp=' + DetailPopUp);
    }
    public void EditPPPPMom()
    {
		system.debug('=> EditPPPPMom(), LineItemCounter=' + LineItemCounter + ', SetTopicMinutePopUp=' + SetTopicMinutePopUp);
        DetailPopUp = listMOMLinePPPP[LineItemCounter] ;  
        if(DetailPopUp.MeetingTopic){
            // TGS-35
            if(SetTopicMinutePopUp == 'Place / Channel') {
                DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Place';
            } else if (SetTopicMinutePopUp == 'Promotion / Communication') {
                DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Promotion';
            } else {
                DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = SetTopicMinutePopUp;
            }
            //TGS-35 DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = SetTopicMinutePopUp;   
            system.debug('=> EditPPPPMom(), DetailPopUp.MeetingTopic=' + DetailPopUp.MeetingTopic);       
        }        
        if( DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c == null && DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c == null ){
            DetailPopUp.SelectValue ='User';
            system.debug('=> EditPPPPMom(), DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c=' + DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c + ', DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c=' + DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c);
        }
        DetailPopUp.TopicType ='PPPP';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = true;
		system.debug('=> EditPPPPMom(), DetailPopUp=' + DetailPopUp);
    }
    public void DelPPPPMom()
    {
        if(listMOMLinePPPP.get(LineItemCounter).LineItem.Id != null)
            listMOMLineToDelete.add(listMOMLinePPPP.get(LineItemCounter).LineItem);
        listMOMLinePPPP.remove(LineItemCounter);
    }
    public void GoUPPPPPLine(){
        if(LineItemCounter > 0)
            listMOMLinePPPP.add(LineItemCounter-1, listMOMLinePPPP.remove(LineItemCounter));
    }
    
    //BTO
    private void AddPPPPMomFromTopic(String topic)
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item 4P').getRecordTypeId();
        DetailPopUp.index = listMOMLinePPPP.size();
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=topic;       
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';
        DetailPopUp.TopicType ='PPPP';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = true;
		system.debug('=> AddPPPPMomFromTopic(), DetailPopUp=' + DetailPopUp);
    }
    /**************************************************************************************************************************************************************/
    /*****************************************************************************Project**************************************************************************/
    public void AddProjectMom()
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
        DetailPopUp.index = listMOMLineProject.size();
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=SetTopicMinutePopUp;      
         system.debug('#### DetailPopUp.ProjectId  :'+ DetailPopUp.ProjectId);
         system.debug('####  DetailPopUp.Project  :'+  DetailPopUp.Project);
        DetailPopUp.SelectValue ='User';
        DetailPopUp.TopicType ='Project';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = false;
		system.debug('=> AddProjectMom(), DetailPopUp=' + DetailPopUp);
    }
    public void EditProjectMom()
    {
        DetailPopUp  = listMOMLineProject[LineItemCounter] ;
        if(DetailPopUp.MeetingTopic){
            DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Project-Key Initiative';           
        }
       if( DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c == null && DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c == null ){
            DetailPopUp.SelectValue ='User';
        }
        DetailPopUp.TopicType ='Project';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
		system.debug('=> EditProjectMom(), DetailPopUp=' + DetailPopUp);
    }
    public void DelProjectMom()
    {
        if(listMOMLineProject.get(LineItemCounter).LineItem.Id != null)
            listMOMLineToDelete.add(listMOMLineProject.get(LineItemCounter).LineItem);
        listMOMLineProject.remove(LineItemCounter);
    }
    public void GoUPProjectLine(){
        if(LineItemCounter > 0)
            listMOMLineProject.add(LineItemCounter-1, listMOMLineProject.remove(LineItemCounter));
    }
    
    //BTO
	private void AddProjectMomFromTopic(String topic)
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
        DetailPopUp.index = listMOMLineProject.size();
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=topic;        
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';
        DetailPopUp.TopicType ='Project';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = false;
		system.debug('=> AddProjectMomFromTopic(), DetailPopUp=' + DetailPopUp);
    }
    /**************************************************************************************************************************************************************/
    /****************************************************************************Competitor************************************************************************/
    public void AddCompMom()
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
        DetailPopUp.index = listMOMLineCompetitor.size();
        list<MMPJ_TOPG_Competitor__c> listCompsOverview =[select id from MMPJ_TOPG_Competitor__c  where name = 'Overview' ];
        if(listCompsOverview .size() >0)
            DetailPopUp.LineItem.MMPJ_TOPG_Competitor__c = listCompsOverview[0].id;
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=SetTopicMinutePopUp;        
        DetailPopUp.TopicType ='Competitor';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = false;
		system.debug('=> AddCompMom(), DetailPopUp=' + DetailPopUp);
    }
    public void EditCompMom()
    {
        DetailPopUp  = listMOMLineCompetitor[LineItemCounter] ;
         if(DetailPopUp.MeetingTopic){
            DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Competition';            
        }
        if( DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c == null && DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c == null ){
            DetailPopUp.SelectValue ='User';
        }
        DetailPopUp.TopicType ='Competitor';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
		system.debug('=> EditCompMom(), DetailPopUp=' + DetailPopUp);
    }
    public void DelCompMom()
    {
        if(listMOMLineCompetitor.get(LineItemCounter).LineItem.Id != null)
            listMOMLineToDelete.add(listMOMLineCompetitor.get(LineItemCounter).LineItem);
        listMOMLineCompetitor.remove(LineItemCounter);
    }
    public void GoUPCompLine(){
        if(LineItemCounter > 0)
            listMOMLineCompetitor.add(LineItemCounter-1, listMOMLineCompetitor.remove(LineItemCounter));
    }
    //BTO 
    private void AddCompMomFromTopic(String topic)
    {
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
        DetailPopUp.index = listMOMLineCompetitor.size();
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=topic;       
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';
        DetailPopUp.TopicType ='Competitor';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
        isRenderedWhoWhen = false;
		system.debug('=> AddCompMomFromTopic(), DetailPopUp=' + DetailPopUp);
    }
    /*****************************************************************************************************************************************************************/
    /************************************************************Line item PopUP common methods***********************************************************************/
    Public pagereference SaveDetailPop()
    {
        //BTO => Add action in TODO List
        boolean isAction = false;
		system.debug('=> SaveDetailPop(), start');
        if (DetailPopUp.LineItem.MMPJ_TOPG_RAID__c == 'Action' && DetailPopUp.SelectValue == 'User'){
			system.debug('SaveDetailPop() DetailPopUp.LineItem.MMPJ_TOPG_RAID__c == "Action"');
			raid = new MMPJ_TOPG_RAID__c();
			isAction = true;
			raid.MMPJ_TOPG_RAID__c = 'Action';
			raid.MMPJ_TOPG_Meeting__c = Meeting.id;                
			raid.MMPJ_TOPG_Highlight__c = DetailPopUp.LineItem.MMPJ_TOPG_IsHighlight__c;
			if(DetailPopUp.LineItem.MMPJ_TOPG_When__c!=null){
				raid.MMPJ_TOPG_ExpectedDate__c = DetailPopUp.LineItem.MMPJ_TOPG_When__c;
			}else {
				raid.MMPJ_TOPG_ExpectedDate__c = date.today();
			}               
			raid.MMPJ_TOPG_Status__c = 'Planned';
			//raid.MMPJ_TOPG_Project__c = Project.id;                
		    // raid.MMPJ_TOPG_LineItem__c = MomLineItem.id;
		    // raid.MMPJ_TOPG_Meeting__c = MomLineItem.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__c ;
        }
        if(DetailPopUp.LineItem.MMPJ_TOPG_Competitor__c != null)
        {
			system.debug('SaveDetailPop() DetailPopUp.LineItem.MMPJ_TOPG_Competitor__c != null');
            MMPJ_TOPG_Competitor__c CompDum = [select id , name from MMPJ_TOPG_Competitor__c where Id =:DetailPopUp.LineItem.MMPJ_TOPG_Competitor__c limit 1];
            DetailPopUp.Comp= CompDum.name;
        }
        /* if(DetailPopUp.LineItem.MMPJ_TOPG_RelatedProduct__c != null)
        {
            MMPJ_TOPG_ProductMix__c ProductDum = [select id , name from MMPJ_TOPG_ProductMix__c where Id =:DetailPopUp.LineItem.MMPJ_TOPG_RelatedProduct__c limit 1];
            DetailPopUp.Product= ProductDum.name;
        }*/

        if(DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c != null)
        {
			system.debug('SaveDetailPop() DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c != null');
            MMPJ_TOPG_Project__c ProjectDum = [select id , name from MMPJ_TOPG_Project__c where Id =:DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c limit 1];
            DetailPopUp.Project= ProjectDum.name;   
            DetailPopUp.ProjectId= ProjectDum.id;
            if(isAction){
                raid.MMPJ_TOPG_Title__c = DetailPopUp.LineItem.MMPJ_TOPG_Action_Title__c;
                raid.MMPJ_TOPG_Project__c=ProjectDum.id;
            }
            
        }
        if((DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c != null && DetailPopUp.SelectValue == 'User') || (DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c != null && DetailPopUp.SelectValue == 'Contact') )
        {
			system.debug('SaveDetailPop() DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c != null');
            if(DetailPopUp.SelectValue == 'User')
            {
                user U = [select id,name from user where id =:DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c limit 1];
                DetailPopUp.Who = U.name;
                if(isAction)
					raid.MMPJ_TOPG_User__c = U.id;
            }
            if(DetailPopUp.SelectValue == 'Contact')
            {
                contact C = [select id,name from contact where id =:DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c limit 1];
                DetailPopUp.Who = C.name;
            }
        }
        string s = '';
        if(DetailPopUp.LineItem.MMPJ_TOPG_Comment__c != null){
			system.debug('SaveDetailPop() DetailPopUp.LineItem.MMPJ_TOPG_Comment__c != null');
			system.debug('SaveDetailPop() DetailPopUp=' + DetailPopUp);
            s = DetailPopUp.LineItem.MMPJ_TOPG_Comment__c;
            if(isAction){
                raid.MMPJ_TOPG_Description__c  = DetailPopUp.LineItem.MMPJ_TOPG_Comment__c;
                raid.MMPJ_TOPG_Desc__c = true;
            }               
        } else {
            if(isAction){
                raid.MMPJ_TOPG_Description__c  = DetailPopUp.LineItem.MMPJ_TOPG_Comment__c;
				raid.MMPJ_TOPG_Desc__c = false;
            }           
        }
        DetailPopUp.CommentThreeLine = s;
        /*if(s.length() > 240)
            DetailPopUp.CommentThreeLine =s.abbreviate(230);
        if(s.countMatches('\n') > 2)
            DetailPopUp.CommentThreeLine =s.abbreviate(3 + s.indexOf('\n',1 + s.indexOf('\n',1 + s.indexOf('\n'))));*/
        DetailPopUp.CommentThreeLine = DetailPopUp.CommentThreeLine.replaceAll('\n','<br/>');
        if( (DetailPopUp.index == listMOMLinePPPP.size() && DetailPopUp.TopicType == 'PPPP') )
        { 
			DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
            listMOMLinePPPP.add(DetailPopUp);
			system.debug('SaveDetailPop() DetailPopUp = ' + DetailPopUp);
        }
        if( (DetailPopUp.index == listMOMLineProject.size() && DetailPopUp.TopicType == 'Project') )
		{ 
            DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
            listMOMLineProject.add(DetailPopUp);
			system.debug('SaveDetailPop() DetailPopUp = ' + DetailPopUp);
	    }
        if( (DetailPopUp.index == listMOMLineCompetitor.size() && DetailPopUp.TopicType == 'Competitor') )
		{
			DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
			insert DetailPopUp.LineItem;
			listMOMLineCompetitor.add(DetailPopUp);
			system.debug('SaveDetailPop() DetailPopUp = ' + DetailPopUp);
		}
        if( (DetailPopUp.index == listMOMLineMarket.size() && DetailPopUp.TopicType == 'Market') )
		{
            DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
            listMOMLineMarket.add(DetailPopUp);
			system.debug('SaveDetailPop() DetailPopUp = ' + DetailPopUp);
	    }
        //BTO => Add in TODO   
        // insert raid;   
        if(isAction){
            raid.MMPJ_TOPG_LineItem__c = DetailPopUp.LineItem.id;
            AddTodo(raid);
        }
        //====
		system.debug('=> SaveDetailPop(), before closeDetailPopup()');
        closeDetailPopup();
        return null;
    }

     public void SaveAndNewDetailPop()
     {
         SaveDetailPop();
         AddMarketMom();
         
    }
    
   /* Public pagereference odlSaveAndNewDetailPop()
    {
        //BTO => Add action in TODO List
         boolean isAction = false;
        if (DetailPopUp.LineItem.MMPJ_TOPG_RAID__c == 'Action' && DetailPopUp.SelectValue == 'User'){
                raid = new MMPJ_TOPG_RAID__c();
                isAction = true;
                raid.MMPJ_TOPG_RAID__c = 'Action';
                raid.MMPJ_TOPG_Highlight__c = DetailPopUp.LineItem.MMPJ_TOPG_IsHighlight__c;
                if(DetailPopUp.LineItem.MMPJ_TOPG_When__c!=null){
                     raid.MMPJ_TOPG_ExpectedDate__c = DetailPopUp.LineItem.MMPJ_TOPG_When__c;
                }else {
                    raid.MMPJ_TOPG_ExpectedDate__c = date.today();
                }               
                raid.MMPJ_TOPG_Status__c = 'Planned';
                //raid.MMPJ_TOPG_Project__c = Project.id;                
               // raid.MMPJ_TOPG_LineItem__c = MomLineItem.id;
               // raid.MMPJ_TOPG_Meeting__c = MomLineItem.MMPJ_TOPG_MinutesofMeeting__r.MMPJ_TOPG_Meeting__c ;
        }
        
        if(DetailPopUp.LineItem.MMPJ_TOPG_RelatedProduct__c != null)
        {
            MMPJ_TOPG_ProductMix__c ProductDum = [select id , name from MMPJ_TOPG_ProductMix__c where Id =:DetailPopUp.LineItem.MMPJ_TOPG_RelatedProduct__c limit 1];
            DetailPopUp.Product= ProductDum.name;
        }

        if(DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c != null)
        {
            MMPJ_TOPG_Project__c ProjectDum = [select id , name from MMPJ_TOPG_Project__c where Id =:DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c limit 1];
            DetailPopUp.Project= ProjectDum.name;
            if(isAction){
                raid.MMPJ_TOPG_Title__c = DetailPopUp.LineItem.MMPJ_TOPG_Action_Title__c;
                raid.MMPJ_TOPG_Project__c=ProjectDum.id;
            }
        }
        if((DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c != null && DetailPopUp.SelectValue == 'User') || (DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c != null && DetailPopUp.SelectValue == 'Contact') )
        {
            if(DetailPopUp.SelectValue == 'User')
            {
                user U = [select id,name from user where id =:DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c limit 1];
                DetailPopUp.Who = U.name;
                if(isAction)
                 raid.MMPJ_TOPG_User__c = U.id;
            }
            if(DetailPopUp.SelectValue == 'Contact')
            {
                contact C = [select id,name from contact where id =:DetailPopUp.LineItem.MMPJ_TOPG_WhoC__c limit 1];
                DetailPopUp.Who = C.name;
            }
        }
        string s = '';
        if(DetailPopUp.LineItem.MMPJ_TOPG_Comment__c!=null)
            s = DetailPopUp.LineItem.MMPJ_TOPG_Comment__c;
           if(isAction){
                raid.MMPJ_TOPG_Description__c  = DetailPopUp.LineItem.MMPJ_TOPG_Comment__c;
                raid.MMPJ_TOPG_Desc__c = true;
            }else {
                if(isAction){
                raid.MMPJ_TOPG_Description__c  = DetailPopUp.LineItem.MMPJ_TOPG_Comment__c;
             raid.MMPJ_TOPG_Desc__c = false;
            }           
        }
        DetailPopUp.CommentThreeLine =s;
      
        DetailPopUp.CommentThreeLine = DetailPopUp.CommentThreeLine.replaceAll('\n','<br/>');
        if(DetailPopUp.index == listMOMLinePPPP.size() && DetailPopUp.TopicType == 'PPPP')
        {
            listMOMLinePPPP.add(DetailPopUp);
            AddPPPPMom();
        }
        if(DetailPopUp.index == listMOMLineProject.size() && DetailPopUp.TopicType == 'Project')
        {
            listMOMLineProject.add(DetailPopUp);
            AddProjectMom();
        }
        if(DetailPopUp.index == listMOMLineCompetitor.size() && DetailPopUp.TopicType == 'Competitor')
        {
            listMOMLineCompetitor.add(DetailPopUp);
            AddCompMom();
        }
        if(DetailPopUp.index == listMOMLineMarket.size() && DetailPopUp.TopicType == 'Market')
        {
            DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
            listMOMLineMarket.add(DetailPopUp);
           // AddMarketMom();
        }
        if(DetailPopUp.index != listMOMLineMarket.size() && DetailPopUp.TopicType == 'Market')
        {
             DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
            //AddMarketMom();
        }
        if(DetailPopUp.index != listMOMLinePPPP.size() && DetailPopUp.TopicType == 'PPPP')
        {
             DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
            //AddPPPPMom();
        }
        if(DetailPopUp.index != listMOMLineProject.size() && DetailPopUp.TopicType == 'Project')
        {
            DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
           // AddProjectMom();
        }
        if(DetailPopUp.index != listMOMLineCompetitor.size() && DetailPopUp.TopicType == 'Competitor')
        {
             DetailPopUp.LineItem.MMPJ_TOPG_MinutesofMeeting__c  = Mom.Id;
            insert DetailPopUp.LineItem;
           // AddCompMom();
        }
        //BTO => Add in TODO
         if(isAction){
            raid.MMPJ_TOPG_LineItem__c = DetailPopUp.LineItem.id;
          AddTodo(raid);
        }
        //====
        return null;
    }*/
    public void closeDetailPopup() {
        displayDetailPopUp = false;
        DisplayPopupBackground = false;
    }
    //Detail Line Wrapper
    Public class WrapperDetailLine
    {
        public String SelectValue {get;set;}
        public Integer index {get;set;}
        public string Project {get;set;}
		public string ProjectId {get;set;}
        public string Comp {get;set;}
        public string Product {get;set;}
        public string Who {get;set;}
        public string TopicType {get;set;}
        public string CommentThreeLine {get;set;}
        public MMPJ_TOPG_MoMLineItem__c LineItem{get;set;}
        public Boolean MeetingTopic {get;set;}
    }
    
     //BTO => initialize Add Detail line pop up for project section
    private void initDetailPopUp () {     
        DetailPopUp = new WrapperDetailLine();
        DetailPopUp.LineItem = new MMPJ_TOPG_MoMLineItem__c();
        DetailPopUp.LineItem.RecordtypeId = Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c ='Project-Key Initiative';
		if(currentCreatedProj!=null){
			DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c = currentCreatedProj.id ;
		}
        DetailPopUp.index = listMOMLineProject.size();
        DetailPopUp.MeetingTopic = false;
        DetailPopUp.SelectValue ='User';       
        DetailPopUp.TopicType ='Project';
        displayDetailPopUp = true;
        DisplayPopupBackground = true;
    }
    //PopUp Functions
    public void closeProjectPopup() {     
        initDetailPopUp ();
        displayPopup = false;
        DisplayPopupBackground = false;
        
    }
    
    //BTO : Selected Topic function
     public void selectedTopic() {
    if (DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Place' ||
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Price' || 
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Product' ||
        DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Promotion'){             
        AddPPPPMomFromTopic(DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c);           
        }
        if (DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Project-Key Initiative'){           
             AddProjectMomFromTopic(DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c);
                    
        }
        if (DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Competition'){            
             AddCompMomFromTopic(DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c);          
        }
        if (DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Market Performance' ||
            DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c=='Add document'){                
            AddMarketMomFromTopic(DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c);         
        }           
    }
    
    Public pagereference SaveProjectPop()
    {
       //Suppression des champs obligatoires
       /* if(String.IsBlank(ProjectPopUp.Name) || ProjectPopUp.MMPJ_TOPG_ProjectOwner__c == null || ProjectPopUp.MMPJ_TOPG_StartDate__c == null || ProjectPopUp.MMPJ_TOPG_EndDate__c == null )
        {
            if(String.IsBlank(ProjectPopUp.Name))
                ProjectPopUp.Name.addError('Please Fill this field');
            if(ProjectPopUp.MMPJ_TOPG_ProjectOwner__c == null)
                ProjectPopUp.MMPJ_TOPG_ProjectOwner__c.addError('Please Fill this field');
            if(ProjectPopUp.MMPJ_TOPG_StartDate__c == null)
                ProjectPopUp.MMPJ_TOPG_StartDate__c.addError('Please Fill this field');
            if(ProjectPopUp.MMPJ_TOPG_EndDate__c == null)
                ProjectPopUp.MMPJ_TOPG_EndDate__c.addError('Please Fill this field');
        }
        else
        {*/
            ProjectPopUp.MMPJ_TOPG_Market__c='';
            ProjectPopUp.MMPJ_TOPG_Brand__c='';
            for(SelectOption  Smarket : SelectedMarket )
                ProjectPopUp.MMPJ_TOPG_Market__c += Smarket.getLabel() + ';';
            //for(SelectOption  Sbrand : SelectedBrand )
              //  ProjectPopUp.MMPJ_TOPG_Brand__c += Sbrand.getLabel() + ';';
            system.debug('#### Market ' + ProjectPopUp.MMPJ_TOPG_Market__c+ ' &&&&& ' +ProjectPopUp);
            Upsert ProjectPopUp;
        //BTO => get the project
        currentCreatedProj = new MMPJ_TOPG_Project__c();
        currentCreatedProj=[Select id, CreatedDate,CreatedById from MMPJ_TOPG_Project__c where CreatedById =: UserInfo.getUserId() order by CreatedDate desc limit 1 ] ;
            closeProjectPopup();
       // }
        return null;
    }

    Public pagereference SaveAndNewProjectPop()
    {
        if(String.IsBlank(ProjectPopUp.Name) || ProjectPopUp.MMPJ_TOPG_ProjectOwner__c == null || ProjectPopUp.MMPJ_TOPG_StartDate__c == null || ProjectPopUp.MMPJ_TOPG_EndDate__c == null )
        {
            if(String.IsBlank(ProjectPopUp.Name))
                ProjectPopUp.Name.addError('Please Fill this field');
            if(ProjectPopUp.MMPJ_TOPG_ProjectOwner__c == null)
                ProjectPopUp.MMPJ_TOPG_ProjectOwner__c.addError('Please Fill this field');
            if(ProjectPopUp.MMPJ_TOPG_StartDate__c == null)
                ProjectPopUp.MMPJ_TOPG_StartDate__c.addError('Please Fill this field');
            if(ProjectPopUp.MMPJ_TOPG_EndDate__c == null)
                ProjectPopUp.MMPJ_TOPG_EndDate__c.addError('Please Fill this field');
        }
        else
        {
           /* for(SelectOption Smarket : SelectedMarket )
                ProjectPopUp.MMPJ_TOPG_Market__c += Smarket.getLabel() + ';';*/
           /* for(SelectOption  Sbrand : SelectedBrand )
                ProjectPopUp.MMPJ_TOPG_Brand__c += Sbrand.getLabel() + ';';*/           
            Upsert ProjectPopUp;
            showProjectPopup() ;
        }
        return null;
    }

     public pagereference showProjectPopup() {
       
        displayPopup = true;
        DisplayPopupBackground = true;
        AllMarket = new list<selectoption>();
        AllBrand = new list<selectoption>();
         //==========BTO : search values from table MMPJ_TOPG_BRAND__c And put "All Brands and All Markets" first in the list=============//
         /* MMPJ_TOPG_BRAND__c br = [select id ,name from MMPJ_TOPG_BRANDendDate__c where Name like 'All%Brands' limit 1 ];
         AllBrand.add(new SelectOption(br.Id, br.Name));*/
        /* SelectOption option = new SelectOption(value, label);
         MMPJ_TOPG_Market__c mk= [select id ,name from MMPJ_TOPG_Market__c where Name like 'All%Markets' limit 1];
         AllMarket.add(new SelectOption(mk.Id, mk.Name));
        for(MMPJ_TOPG_Market__c M : [select id ,name from MMPJ_TOPG_Market__c where not Name like 'All%Markets' order by Name])*/      
             AllMarket.add(new SelectOption('All Markets', 'All Markets'));
        /*for(MMPJ_TOPG_BRAND__c B : [select id ,name from MMPJ_TOPG_BRAND__c where not Name like 'All%Brands' order by Name])
             AllBrand.add(new SelectOption(B.Id, B.Name));*/
         
         //==========BTO En
        SelectedMarket =new list<selectoption>();
        SelectedBrand = new list<selectoption>();

        return null;
    }

    ///////////////////////////// PRINT PDF MINUTES /////////////////////////////////////////////////////////////////////////////////////////////
    public boolean PrintMomPDF()
    {
        try
        {
            Boolean Succeed = UpdateMin();
            if(!Succeed)
                return false;
            PageReference MinutesPDF= Page.MMPJ_TOPG_MinutesPDF;
            MinutesPDF.getParameters().put('MeetingId', Meeting.id );
            MinutesPDF.getParameters().put('EventId',Agenda.id);
            blob body;
            if(Test.isRunningTest())
                body = Blob.valueOf('test');
            else
                body = MinutesPDF.getContentAsPDF();
            String PDFname = Meeting.Name +'-Minutes.pdf';
           // list<attachment> 
                ListAtt =[Select id,Name,Body
                                       From Attachment
                                       Where Name = :PDFname];
            if(ListAtt.size() > 0 && ListAtt !=null)
            {
                delete ListAtt;
            }
            attachment AttAgenda = new attachment();
            AttAgenda.Body = body ;
            AttAgenda.isPrivate = false;
            AttAgenda.Name =  PDFname;
            AttAgenda.parentId = Meeting.id;
            Insert AttAgenda;
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return null;
        }
        MinutesConstructor();

        return true;
    }
    public pagereference PrintMomPDFButton()
    {
        try
        {
            System.debug('PrintMomPDFButton() : before call of SaveMin()');
            SaveMin();
            System.debug('PrintMomPDFButton() : before call of UpdateMin()');
            Boolean Succeed = UpdateMin();
            if(!Succeed)
                return null;
            PageReference MinutesPDF= Page.MMPJ_TOPG_MinutesPDF;
            MinutesPDF.getParameters().put('MeetingId', Meeting.id );
            MinutesPDF.getParameters().put('EventId', Agenda.id);
            System.debug('PrintMomPDFButton() : Agenda.id=' + Agenda.id + ', Meeting.id=' + Meeting.id);
            blob body;
            if(Test.isRunningTest())
                body = Blob.valueOf('test');
            else
                body = MinutesPDF.getContentAsPDF();
            String PDFname = Meeting.Name +'-Minute.pdf';
            //list<attachment> 
            ListAtt = [Select id,Name,Body
                                    From Attachment
                                    Where Name = :PDFname];

            if(ListAtt.size() > 0 && ListAtt != null)
            {
                System.debug('PrintMomPDFButton() : ListAtt.size()=' + ListAtt.size() + ', ListAtt=' + ListAtt);
                delete ListAtt;
            }

            attachment AttAgenda = new attachment();
            AttAgenda.Body = body ;
            AttAgenda.isPrivate = false;
            AttAgenda.Name =  PDFname;
            AttAgenda.parentId = Meeting.id;
            System.debug('PrintMomPDFButton() : AttAgenda=' + AttAgenda);
            Insert AttAgenda;
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
            return null;
        }
        MinutesConstructor();
        SuccessMessage ='Minutes PDF file generated successfully, please go Doc/File tab to view it';
        return null;
    }

    /****************************************/
    /****************************************/
    /*******Controller of Attachements*******/
    /****************************************/
    /****************************************/

    public list<AttachmentWrapper> ListChatterMeeting{set;}
    public List<ContentDocumentLink> ChatterAttachments {set;}
    public List<attachment> MeetingAttachments {set;}
    public List<attachment> VisitsAttachments {set;}
    public string ParentIdAttachement {get;set;}
    public MMPJ_TOPG_Visit__c Visit{get;set;}
    public id AttachmentToDelete {get;set;}
    public integer WrapperToDelete{get;set;}
    public void AttachmentConstructor()
    {
        Error =false;
        getVisitsAttachments() ;
        getMeetingAttachments() ;
        getListChatterMeeting() ;
    }

    public list<attachment> getMeetingAttachments()
    {
        list<attachment> listAttachments = new list<attachment>();
        if(meeting.id != null)
           listAttachments =[select id,name,lastmodifieddate,createdby.name,createdbyid,ContentType
                             from Attachment
                             Where ParentId =:meeting.id AND (name LIKE '%-Minute.pdf' OR name LIKE '%-Agenda.pdf')];
        return listAttachments;
    }

    public list<attachment> getVisitsAttachments()
    {
        list<MMPJ_TOPG_Visit__c> ListVisits = new list<MMPJ_TOPG_Visit__c>();
        if(BMC != null)
            ListVisits= [select id
                         from MMPJ_TOPG_Visit__c
                         where MMPJ_TOPG_BMC__c =:BMC.id ];
        list<attachment> listAttachments = new list<Attachment>();
        if(ListVisits.size() > 0)
            listAttachments =[select id,name,lastmodifieddate,createdby.name,createdbyid,ContentType
                              from Attachment
                              Where ParentId IN :ListVisits AND (NOT Name LIKE 'VIMG_%')];
        return listAttachments ;
    }
    public list<AttachmentWrapper> getListChatterMeeting()
    {
        list<AttachmentWrapper> ListWrapper = new list<AttachmentWrapper>();
        list<ContentDocumentLink> listChatterAttachments = new list<ContentDocumentLink>();
        list<attachment> listAttachments = new list<attachment>();
        list<attachment> listMinuteAttachments = new list<attachment>();
        list<attachment> ListMarketPerfsAttachment = new list<attachment>();
        if(meeting.id != null)
        {
            listChatterAttachments =[SELECT ContentDocumentId,ContentDocument.ContentModifiedDate,ContentDocument.FileType,ContentDocument.Title,ContentDocument.OwnerId,ContentDocument.Owner.name
                                     FROM ContentDocumentLink
                                     WHERE LinkedEntityId =:meeting.id];

            listAttachments =[select id,name,lastmodifieddate,createdby.name,createdbyid,ContentType
                              from Attachment
                              Where ParentId =:meeting.id AND (NOT name LIKE '%-Minute.pdf') AND (NOT name LIKE '%-Agenda.pdf')];
            
            //BTO: Get MOMItems Attachements
           
              list<MMPJ_TOPG_MoMLineItem__c> listOfMoMItems = [select id from MMPJ_TOPG_MoMLineItem__c
                               where MMPJ_TOPG_MinutesofMeeting__c =:MoM.id];
            
            listMinuteAttachments =[select id,name,lastmodifieddate,createdby.name,createdbyid,ContentType
                              from Attachment
                              Where ParentId in:listOfMoMItems ];
            
            ListMarketPerfsAttachment= [select id,name,lastmodifieddate,createdby.name,createdbyid,ContentType
                                                        from attachment
                                                        where parentId IN: Meeting.Meeting_Market_Perfs__r];
        	system.debug('getListChatterMeeting(), ListMarketPerfsAttachment= ' + ListMarketPerfsAttachment);
        }
        
        for(attachment att : ListMarketPerfsAttachment)
        {
            AttachmentWrapper Wrapper = new AttachmentWrapper();
            Wrapper.id = att.id;
            Wrapper.title = att.name;
            Wrapper.type = att.ContentType;
            Wrapper.LastModified = att.LastModifieddate;
            Wrapper.CreatedById = att.createdbyid;
            Wrapper.CreatedByName = att.createdby.name;
            Wrapper.ischatterDocument = false;
            ListWrapper.add(Wrapper);
        }
        
        for(ContentDocumentLink ChatterDoc : listChatterAttachments )
        {
            AttachmentWrapper Wrapper = new AttachmentWrapper();
            Wrapper.id = ChatterDoc.ContentDocumentId;
            Wrapper.title = ChatterDoc.ContentDocument.Title;
            Wrapper.type = ChatterDoc.ContentDocument.FileType;
            Wrapper.LastModified = ChatterDoc.ContentDocument.ContentModifiedDate;
            Wrapper.CreatedById = ChatterDoc.ContentDocument.OwnerId;
            Wrapper.CreatedByName = ChatterDoc.ContentDocument.Owner.name;
            Wrapper.ischatterDocument = true;
            ListWrapper.add(Wrapper);
        }
        for(attachment att : listAttachments)
        {
            AttachmentWrapper Wrapper = new AttachmentWrapper();
            Wrapper.id = att.id;
            Wrapper.title = att.name;
            Wrapper.type = att.ContentType;
            Wrapper.LastModified = att.LastModifieddate;
            Wrapper.CreatedById = att.createdbyid;
            Wrapper.CreatedByName = att.createdby.name;
            Wrapper.ischatterDocument = false;
            ListWrapper.add(Wrapper);
        }
        
        for(attachment att : listMinuteAttachments)
        {
            AttachmentWrapper Wrapper = new AttachmentWrapper();
            Wrapper.id = att.id;
            Wrapper.title = att.name;
            Wrapper.type = att.ContentType;
            Wrapper.LastModified = att.LastModifieddate;
            Wrapper.CreatedById = att.createdbyid;
            Wrapper.CreatedByName = att.createdby.name;
            Wrapper.ischatterDocument = false;
            ListWrapper.add(Wrapper);
        }
        return ListWrapper;
    }
    public Pagereference DelAtt()
    {
        try{
            attachment AttDelete = new attachment();
            AttDelete.id = AttachmentToDelete;
            delete AttDelete;
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
        }
        return null;
    }

    public pagereference AddMeetingDocument()
    {
        if(meeting.id == null || MoM.id == null)
        {
            Error = true;
            ErrorMessage= 'You should create a Agenda first ';
            return null;
        }
        ParentIdAttachement = meeting.id;
        return new pagereference('/p/attach/NoteAttach?pid=' + ParentIdAttachement + '&retURL=%2Fapex%2FMMPJ_TOPG_NewMeeting?ID=' + meeting.id + '%26TabName=Minutes' );//+ ParentIdAttachement); //+'&retURL=%2Fapex%2FMMPJ_TOPG_NewMeeting?ID=' + meeting.id );
    }
    public pagereference deleteWrapper()
    {
        try{
            list<AttachmentWrapper> ListWrapper = getListChatterMeeting();
            if(ListWrapper[WrapperToDelete].ischatterDocument)
            {
                ContentDocument contToDelete = new ContentDocument();
                contToDelete.id = ListWrapper[WrapperToDelete].Id;
                list<ContentVersion> ListContent = [select id, ContentDocumentId
                                                    from ContentVersion
                                                    where ContentDocumentId =:contToDelete.id];
                list<FeedItem> feedItemTodelete = [SELECT id,RelatedRecordId
                                                   FROM FeedItem
                                                   WHERE ParentId =:meeting.id];
                if(ListContent.size() > 0)
                {
                    for(FeedItem FdItem: feedItemTodelete)
                    {
                        if(FdItem.RelatedRecordId == ListContent[0].id)
                        {
                            delete FdItem;
                            break;
                        }
                    }
                }
                delete contToDelete ;
            }
            else
            {
                attachment AttDelete = new attachment();
                AttDelete.id = ListWrapper[WrapperToDelete].Id;
                delete AttDelete;
            }
        }
        catch(exception ex)
        {
            Error = true;
            ErrorMessage= ex.getMessage();
        }
        return null;
    }
    public pagereference AddVisitDocument()
    {
        list<MMPJ_TOPG_Visit__c> ListVisits = new list<MMPJ_TOPG_Visit__c>();
        if(BMC != null ) //&& meeting.id != null)
            ListVisits= [SELECT id
                         FROM MMPJ_TOPG_Visit__c
                         WHERE MMPJ_TOPG_BMC__c =:BMC.id //AND MMPJ_TOPG_Meeting__c =: Meeting.id
                         ORDER BY createdDate ASC];

        if(!( ListVisits.size() > 0))
        {
            Error = true;
            ErrorMessage= 'You should create a Visit first ';
            newTab = 'Visits';
            return null;
        }
        ParentIdAttachement = ListVisits[0].id;
         if(meeting.id == null)
            return new pagereference('/p/attach/NoteAttach?pid=' + ParentIdAttachement + '&retURL=%2F'+ BMC.id);//+ ParentIdAttachement); //+'&retURL=%2Fapex%2FMMPJ_TOPG_NewMeeting?ID=' + meeting.id );
        else
            return new pagereference('/p/attach/NoteAttach?pid=' + ParentIdAttachement + '&retURL=%2Fapex%2FMMPJ_TOPG_NewMeeting?ID=' + meeting.id + '%26TabName=Attachment' );//+ ParentIdAttachement); //+'&retURL=%2Fapex%2FMMPJ_TOPG_NewMeeting?ID=' + meeting.id );


    }

    public class AttachmentWrapper{
        public string Id{get;set;}
        public string title{get;set;}
        public datetime LastModified{get;set;}
        public string createdbyId{get;set;}
        public string createdbyName{get;set;}
        public string Type{get;set;}
        public boolean ischatterDocument{get;set;}
    }
}