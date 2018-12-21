public class MMPJ_TOPG_AgendaPDFcontroller{
    public event Agenda{get;set;}
    public MMPJ_TOPG_Meeting__c meeting{get;set;}
    public list<Contact> listInviteesContacts{get;set;}
    public list<user> listInviteesUsers {get;set;}
    public list<PersWrapper> ListInvitees {get;set;}
    /*public date todayDate {get;set;}
    public string comments {get;set;}
    public list<MMPJ_TOPG_4P__c > listpValues {get;set;}
    public list<MMPJ_TOPG_MeetingMarketPerf__c>  listMarketPref {get;set;}
    public list<MMPJ_TOPG_MeetingProject__c>  listProjects {get;set;}
    public list<MMPJ_TOPG_MeetingCompetitor__c>  listCompetitors {get;set;}*/
    public list<WrapperTopic> ListWrapperTopic {get;set;}
    public MMPJ_TOPG_MinuteOfMeeting__c Minute {get;set;}
	public String theOrganizer {get;set;}
  
    //BTO => used for add highlights section in pdf
    public class PersWrapper{
        public string name{get;set;}
        public string todo{get;set;}        
        public string comment{get;set;}  
        public string title{get;set;} 
    }
  
    public MMPJ_TOPG_AgendaPDFcontroller()
    {
        ListWrapperTopic = new list<WrapperTopic>();
        //todayDate = date.Today();
        string eventid = ApexPages.currentPage().getParameters().get('EventId');
        
        Agenda =[select Subject, owner.name,StartDateTime, EndDateTime,ActivityDate,Location,
                 (select relation.name, RelationId, response from EventRelations order by response )
                 from event
                 where id =:eventid];
        System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), Agenda : ' + Agenda);	         
        //get the invitees list         
        list<string> listInviteesIDs = new list<string>();
        for(EventRelation er : Agenda.EventRelations)    
        {
            listInviteesIDs.add(er.RelationId )  ;  
        }   
        
        //BTO => Attendees list
         map <String,PersWrapper> mapListInvitees = new map <String,PersWrapper>();       
        //get the contact list
        listInviteesContacts = new list<Contact>();
        listInviteesContacts = [select Id, Name, title
                                From Contact
                                Where id IN: listInviteesIDs];
        for( Contact c : listInviteesContacts ){
            PersWrapper pers = new PersWrapper();
             pers.Name = c.Name;
             pers.title = c.title;
             mapListInvitees.put(c.Id,pers);
        }
        
        //get the users list
        listInviteesUsers = new list<user>();
        listInviteesUsers = [select Id, Name, Division, title
                             From User
                             Where id IN: listInviteesIDs];
        
        //BTO => 
        for( user u : listInviteesUsers ){
            PersWrapper pers = new PersWrapper();
            pers.Name = u.Name;
            pers.title = u.title;
            mapListInvitees.put(u.Id,pers);
        }
        //Get all attendees 
        ListInvitees = new list<PersWrapper>();
        for (String s : listInviteesIDs){
            ListInvitees.add(mapListInvitees.get(s));
        }
        System.debug('==> MMPJ_TOPG_AgendaPDFcontroller, ListInvitees=' + ListInvitees);
        string meetingId = ApexPages.currentPage().getParameters().get('MeetingId');
        
        /*Meeting = [select id,MMPJ_TOPG_BMC__r.name,MMPJ_TOPG_Comments__c,
                   (select MMPJ_TOPG_Competitor__r.name,MMPJ_TOPG_Comment__c from Meeting_Competitors__r),
                   (select MMPJ_TOPG_Project__r.name,MMPJ_TOPG_Comment__c from Meeting_Projects__r),
                   (select MMPJ_TOPG_MarketPerf__r.name,MMPJ_TOPG_Comment__c,MMPJ_TOPG_FileName__c from  Meeting_Market_Perfs__r),
                   (select name,MMPJ_TOPG_Comment__c from  Meeting_4P__r )
                   from MMPJ_TOPG_Meeting__c 
                   where id =:meetingId limit 1];*/
        // TGS-46
        Meeting = [select id,MMPJ_TOPG_BMC__r.name,MMPJ_TOPG_Comments__c,
                   (select MMPJ_TOPG_Competitor__r.name,MMPJ_TOPG_Comment__c from Meeting_Competitors__r),
                   (select MMPJ_TOPG_Project__r.name,MMPJ_TOPG_Comment__c from Meeting_Projects__r),
                   (select MMPJ_TOPG_MarketPerf__r.name,MMPJ_TOPG_Comment__c,MMPJ_TOPG_FileName__c from  Meeting_Market_Perfs__r),
                   (select name,MMPJ_TOPG_Comment__c,MMPJ_TOPG_Topic__c from  Meeting_4P__r )
                   from MMPJ_TOPG_Meeting__c 
                   where id =:meetingId limit 1];
        
		System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), Meeting : ' + Meeting);
		
        //get the minutes of meeting id
		list<MMPJ_TOPG_MinuteOfMeeting__c> ListminutesOfMeeting = new list<MMPJ_TOPG_MinuteOfMeeting__c>([Select Id,MMPJ_TOPG_Title__c,MMPJ_TOPG_Location__c,MMPJ_TOPG_Assist__c
                                                                                                         From MMPJ_TOPG_MinuteOfMeeting__c
                                                                                                         Where MMPJ_TOPG_Meeting__c =:meetingId]);
        Minute = ListminutesOfMeeting[0];
        System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), Minute : ' + Minute);
		
		//==BTO => Organizer Attend 
		if (Minute.MMPJ_TOPG_Assist__c == true) {
			theOrganizer = Agenda.owner.name;
		} else {
			theOrganizer ='-';
		}
                
        /*listpValues = Meeting.Meeting_4P__r; 
        listMarketPref =  Meeting.Meeting_Market_Perfs__r;
        listProjects =  Meeting.Meeting_Projects__r;
        listCompetitors = Meeting.Meeting_Competitors__r; */
        
        for(MMPJ_TOPG_4P__c PPPP : Meeting.Meeting_4P__r)
        {
			System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), PPPP : ' + PPPP);
            WrapperTopic W = new WrapperTopic();
            // TGS-46 W.Topic = wrapText(PPPP.name,19);
            W.Topic = wrapText(PPPP.MMPJ_TOPG_Topic__c,19);
            W.Comment ='';
            if(PPPP.MMPJ_TOPG_Comment__c !=null) {
                W.Comment = PPPP.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
                W.Comment = W.Comment.replaceall('&','&amp;');
                W.Comment = W.Comment.replaceall('<','&lt;');
                W.Comment = W.Comment.replaceall('>','&gt;');
                W.Comment = W.Comment.replaceall('"','&quot;');
            }
            System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), W : ' + W);
			ListWrapperTopic.add(W);
        }
        for(MMPJ_TOPG_MeetingMarketPerf__c Market: Meeting.Meeting_Market_Perfs__r)
        {
			System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), Market : ' + Market);
            WrapperTopic W = new WrapperTopic();
            W.Topic = wrapText(Market.MMPJ_TOPG_FileName__c ,19);
            // TGS-50
            W.Topic = W.Topic.replaceall('File or text','Add document');  // TGS-50
            W.Comment ='';
            if(Market.MMPJ_TOPG_Comment__c != null) {
                W.Comment =Market.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
                W.Comment = W.Comment.replaceall('&','&amp;');
                W.Comment = W.Comment.replaceall('<','&lt;');
                W.Comment = W.Comment.replaceall('>','&gt;');
                W.Comment = W.Comment.replaceall('"','&quot;');
            }
            System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), W : ' + W);
			ListWrapperTopic.add(W);
        }
        for(MMPJ_TOPG_MeetingProject__c Project : Meeting.Meeting_Projects__r)
        {
			System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), Project : ' + Project);
            WrapperTopic W = new WrapperTopic();
            W.Topic = wrapText(Project.MMPJ_TOPG_Project__r.name ,19);
            W.Comment ='';
            if(Project.MMPJ_TOPG_Comment__c != null) {
                W.Comment = Project.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
                W.Comment = W.Comment.replaceall('&','&amp;');
                W.Comment = W.Comment.replaceall('<','&lt;');
                W.Comment = W.Comment.replaceall('>','&gt;');
                W.Comment = W.Comment.replaceall('"','&quot;');
            }
            System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), W : ' + W);
			ListWrapperTopic.add(W);
        }
        for(MMPJ_TOPG_MeetingCompetitor__c Competitor : Meeting.Meeting_Competitors__r)
        {
			System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), Competitor : ' + Competitor);
            WrapperTopic W = new WrapperTopic();
            W.Topic = wrapText(Competitor.MMPJ_TOPG_Competitor__r.name,19);
            W.Comment ='';
            if(Competitor.MMPJ_TOPG_Comment__c != null) {
				W.Comment = Competitor.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
                W.Comment = W.Comment.replaceall('&','&amp;');
                W.Comment = W.Comment.replaceall('<','&lt;');
                W.Comment = W.Comment.replaceall('>','&gt;');
                W.Comment = W.Comment.replaceall('"','&quot;');
            }
			System.debug('==> MMPJ_TOPG_AgendaPDFcontroller(), W : ' + W);
            ListWrapperTopic.add(W);
        }
    }
    
    public string wrapText(string LineToBreak,Integer Length)
    {
		System.debug('==> wrapText(), LineToBreak : ' + LineToBreak + ', Length= ' + Length);
        string ReturnString = '';
        // TGS-43
        if(LineToBreak == null || LineToBreak == '') {
            System.debug('==> wrapText(), ReturnString : ' + ReturnString);
            return ReturnString ;
        } else if(LineToBreak.length() < 1) {
            System.debug('==> wrapText(), ReturnString : ' + ReturnString);
            return ReturnString ;
        }
        list<string> ListWords = LineToBreak.split(' ');
        List<string> ListWordsToCombine = new list<string>();
        System.debug('==> wrapText(), ListWords : ' + ListWords);
        for(string Word : ListWords)
        {
            integer y = 1;
            while(Word.length() > Length)
            {
                ListWordsToCombine.add(Word.subString(0,length));
                Word = Word.subString(length,Word.length());
                y++;
            }
            ListWordsToCombine.add(Word);
        }
        for(string WordToCombine : ListWordsToCombine)
			ReturnString = ReturnString + ' ' + WordToCombine;
		System.debug('==> wrapText(), ReturnString : ' + ReturnString);
        return ReturnString;
    }
    public class wrapperTopic{
        public string Topic {get;set;}
        public string Comment {get;set;}
    }
        //public list<detailedAgenda> listDetailedAgenda {get;set;}
        //listDetailedAgenda = new list<detailedAgenda>();
        /*
        integer sizelistMarketPref = listMarketPref.size();
        integer sizelistProjects = listProjects.size();
        integer sizelistCompetitors = listCompetitors.size();
        integer sizelistpValues = listpValues.size();
        
        listDetailedAgenda = new list<detailedAgenda>();
        integer i=0;
        for(MMPJ_TOPG_MeetingMarketPerf__c meetingMarket : listMarketPref )
        {
            detailedAgenda detAgen = new detailedAgenda();
            detAgen.meetingPref =  meetingMarket.MMPJ_TOPG_MarketPerf__r.name;
            if(sizelistpValues > i)
            {
                detAgen.pField =  listpValues[i].name;  
            }
            else 
            {
                detAgen.pField = '';   
            }
            if(sizelistProjects > i )
            {
                detAgen.project = listProjects[i].MMPJ_TOPG_Project__r.name;
            } 
            else 
            {
                detAgen.project = '';
            }
            if(sizelistCompetitors > i)
            {
                detAgen.competitor = listCompetitors[i].MMPJ_TOPG_Competitor__r.name;   
            } 
            else
            {
                detAgen.competitor ='';
            }
            listDetailedAgenda.add(detAgen);
            i++;
        }
        system.debug('listDetailedAgenda ' + listDetailedAgenda);
        if(sizelistProjects > sizelistMarketPref)
        {
            for(MMPJ_TOPG_MeetingProject__c proj : listProjects)
            {
                detailedAgenda detAgen = new detailedAgenda();
                detAgen.meetingPref = '';
                if(sizelistProjects > i)
                {
                    detAgen.project = listProjects[i].MMPJ_TOPG_Project__r.name;
                }                
                if(sizelistpValues > i)
                {
                    detAgen.pField =  listpValues[i].name;  
                }
                else 
                {
                    detAgen.pField = '';   
                }
                if(sizelistCompetitors > i )
                {
                    detAgen.competitor = listCompetitors[i].MMPJ_TOPG_Competitor__r.name;      
                }
                else
                {
                    detAgen.competitor = '';
                }
                listDetailedAgenda.add(detAgen);
                i ++; 
            }
           i = i-1;     
        }
        
        system.debug('i competitors' + i);
        if(sizelistCompetitors > sizelistMarketPref || sizelistCompetitors > sizelistProjects )
        {
            for( MMPJ_TOPG_MeetingCompetitor__c comp :  listCompetitors )
            {
                detailedAgenda detAgen = new detailedAgenda();
                detAgen.meetingPref = '';
                detAgen.project = '';
                if(sizelistCompetitors > i)
                {
                    detAgen.competitor = listCompetitors[i].MMPJ_TOPG_Competitor__r.name;
                }                   
                if(sizelistpValues > i)
                {
                    detAgen.pField =  listpValues[i].name;  
                }
                else 
                {
                    detAgen.pField = '';   
                }           
                listDetailedAgenda.add(detAgen); 
                i++; 
            }
           i = i-1; 
        } 
        
        system.debug('i pvalus' + i);
        if(sizelistpValues > sizelistCompetitors || sizelistpValues > sizelistProjects || sizelistpValues > sizelistMarketPref )
        {
            for(MMPJ_TOPG_4P__c  val : listpValues)
            {
                system.debug('i inside for '  + i );
                detailedAgenda detAgen = new detailedAgenda();
                detAgen.meetingPref = '';
                detAgen.project = '';
                detAgen.competitor = '';
                if(sizeListpValues > i)
                {
                    detAgen.pField =  listpValues[i].name;
                    listDetailedAgenda.add(detAgen);
                }                
                 
                i++;
            }
            
            
        } 
       
    public class detailedAgenda
    {
        public string pField {get;set;}
        public string competitor {get;set;}
        public string project {get;set;}
        public string meetingPref {get;set;}
    }*/
}