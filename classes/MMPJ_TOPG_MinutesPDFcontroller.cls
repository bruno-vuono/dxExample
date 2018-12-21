public with sharing class MMPJ_TOPG_MinutesPDFcontroller 
{
    public event Agenda{get;set;}
    public MMPJ_TOPG_Meeting__c meeting{get;set;}
    public list<Contact> listInviteesContacts{get;set;}
    public list<user> listInviteesUsers {get;set;}      
    public list<PersWrapper> ListInvitees{get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listMOMLineItem {get;set;}
    public MMPJ_TOPG_MinuteOfMeeting__c Minute {get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listMOMLinePPPP {get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listMOMLineMarket {get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listMOMLineProject {get;set;}
    public list<MMPJ_TOPG_MoMLineItem__c> listMOMLineCompetitor {get;set;}
	public String displayHighlights {get;set;}
	public String displayLineMarket {get;set;}
	public String displayLineProject {get;set;}
	public String displayLineCompetitor {get;set;}
	public String displayLinePPPP {get;set;}      
	public String theOrganizer {get;set;}  
	public Boolean healderAlreadyDisplayed;
    
    //BTO => used for add highlights section in pdf
    public class PersWrapper{
        public string name{get;set;}
        public string todo{get;set;}        
        public string comment{get;set;}  
        public string title{get;set;} 
        public Date whenHighlight{get;set;} 
    }
    public list<PersWrapper> listMOMHighLight {get;set;}
    public MMPJ_TOPG_MinutesPDFcontroller()
    {        
		displayHighlights = 'no display';
		displayLineMarket = 'no display';
		displayLineProject = 'no display';
		displayLineCompetitor = 'no display';
		displayLinePPPP = 'no display';  
		healderAlreadyDisplayed = false;
		
		date todayDate = date.Today();
        string eventid = ApexPages.currentPage().getParameters().get('EventId');
        
        Agenda =[select Subject, owner.name,StartDateTime, EndDateTime,Location,ActivityDate,
                 (select relation.name, RelationId,LastModifiedDate,response from EventRelations order by response )
                 from event
                 where id =:eventid];
		System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Agenda : ' + Agenda);		
        
		//get the invitees list         
        list<string> listInviteesIDs = new list<string>();
        
        for(EventRelation er : Agenda.EventRelations)    
        {
            listInviteesIDs.add(er.RelationId );              
        }    
        //get the contact list
        listInviteesContacts = new list<Contact>();
        listInviteesContacts = [select Id, Name, title
                                From Contact
                                Where id IN: listInviteesIDs];
        
        //get the users list
        listInviteesUsers = new list<user>();
        listInviteesUsers = [select Id, Name, Division, title
                             From User
                             Where id IN: listInviteesIDs];
        
        //=====BTO : to order Attendees
        map <String,PersWrapper> mapListInvitees = new map <String,PersWrapper>();
        for(Contact c : listInviteesContacts){
            PersWrapper pers = new PersWrapper(); 
            pers.name = c.Name;
            pers.title = c.title;
            mapListInvitees.put(c.Id,pers);
        }
        for(User u : listInviteesUsers){
            PersWrapper pers = new PersWrapper(); 
            pers.name = u.Name;
            pers.title = u.title;
            mapListInvitees.put(u.Id,pers);
        }
        
        ListInvitees = new list<PersWrapper>();
        for (String s : listInviteesIDs){
            ListInvitees.add(mapListInvitees.get(s));
        }
        System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, ListInvitees=' + ListInvitees);	
        //===========
        string meetingId = ApexPages.currentPage().getParameters().get('MeetingId');
        
        Meeting = [select id,MMPJ_TOPG_BMC__r.name,MMPJ_TOPG_Comments__c,MMPJ_TOPG_NoAgenda__c,
                   (select MMPJ_TOPG_Competitor__r.name from Meeting_Competitors__r),
                   (select MMPJ_TOPG_Project__r.name from Meeting_Projects__r),
                   (select MMPJ_TOPG_MarketPerf__r.name from  Meeting_Market_Perfs__r)
                   from MMPJ_TOPG_Meeting__c 
                   where id =:meetingId limit 1];
                   
		//get the minutes of meeting id
		list<MMPJ_TOPG_MinuteOfMeeting__c> ListminutesOfMeeting = new list<MMPJ_TOPG_MinuteOfMeeting__c>([Select Id,MMPJ_TOPG_Title__c,MMPJ_TOPG_Location__c,MMPJ_TOPG_Assist__c,MMPJ_TOPG_Start_Date__c,MMPJ_TOPG_End_Date__c
                                                                                                         From MMPJ_TOPG_MinuteOfMeeting__c
                                                                                                         Where MMPJ_TOPG_Meeting__c =:meetingId]);
		Minute = ListminutesOfMeeting[0];
		//==BTO => Organizer Attend 
		if (Minute.MMPJ_TOPG_Assist__c == true) {
			theOrganizer = Agenda.owner.name;
		} else {
			theOrganizer ='-';
		}
        
		// get the MOM line items
		listMOMLinePPPP = new list<MMPJ_TOPG_MoMLineItem__c>();
		listMOMLineMarket = new list<MMPJ_TOPG_MoMLineItem__c>();
		listMOMLineProject = new list<MMPJ_TOPG_MoMLineItem__c>();
		listMOMLineCompetitor = new list<MMPJ_TOPG_MoMLineItem__c>();
		listMOMHighLight = new list<PersWrapper>();
       
	    list<MMPJ_TOPG_MoMLineItem__c> listOfMoMDetail = [select RecordType.Name,MMPJ_TOPG_TopicPPPP__c,MMPJ_TOPG_Topic__c,MMPJ_TOPG_Competitor__r.name,MMPJ_TOPG_RelatedProject__r.name,MMPJ_TOPG_When__c,MMPJ_TOPG_WhoU__r.name,MMPJ_TOPG_WhoC__r.name,
                                                         MMPJ_TOPG_Comment__c,MMPJ_TOPG_FileName__c,MMPJ_TOPG_IsHighlight__c,MMPJ_TOPG_RAID__c, MMPJ_TOPG_Detail_Line_Topic__c, MMPJ_TOPG_Brand__c,MMPJ_TOPG_Action_Title__c from MMPJ_TOPG_MoMLineItem__c
                                                         where MMPJ_TOPG_MinutesofMeeting__c IN: ListminutesOfMeeting
                                                         Order By MMPJ_TOPG_Rank__c ASC];
		for(MMPJ_TOPG_MoMLineItem__c MomDetail: listOfMoMDetail )
		{
			//BTO = > adding highlights section in pdf
			System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, MomDetail=' + MomDetail);	
			if(MomDetail.MMPJ_TOPG_IsHighlight__c){                
				PersWrapper momHighlight = new PersWrapper();               
				if(MomDetail.MMPJ_TOPG_WhoU__r.name!= null){
					momHighlight.name = MomDetail.MMPJ_TOPG_WhoU__r.name;
				}else {
					momHighlight.name = MomDetail.MMPJ_TOPG_WhoC__r.name;
				}	
				//momHighlight.comment= MomDetail.MMPJ_TOPG_Comment__c;
				//System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, *** MomDetail.MMPJ_TOPG_Comment__c=[' + MomDetail.MMPJ_TOPG_Comment__c + ']');
				
				if (MomDetail.MMPJ_TOPG_Comment__c != null) {
					String topic = null;
					if (MomDetail.RecordType.Name == 'Line Item 4P') {
						if (MomDetail.MMPJ_TOPG_TopicPPPP__c != null) {
							topic = '<b>' + MomDetail.MMPJ_TOPG_TopicPPPP__c + '</b><br/>';
						} else if (MomDetail.MMPJ_TOPG_Detail_Line_Topic__c != null) {
							topic = '<b>' + MomDetail.MMPJ_TOPG_Detail_Line_Topic__c + '</b><br/>';
						}
					} else if (MomDetail.RecordType.Name == 'Line item Market Performance') {
						if (MomDetail.MMPJ_TOPG_Detail_Line_Topic__c != null) {
							if (MomDetail.MMPJ_TOPG_FileName__c != null) {
								topic = '<b>' + MomDetail.MMPJ_TOPG_FileName__c + '</b><br/>';
							} else {
								topic = '<b>' + MomDetail.MMPJ_TOPG_Detail_Line_Topic__c + '</b><br/>';
							}
						}
					} else if (MomDetail.RecordType.Name == 'Line Item Project') {
						if (MomDetail.MMPJ_TOPG_RelatedProject__r.name != null) {
							topic = '<b>' + MomDetail.MMPJ_TOPG_RelatedProject__r.name + '</b><br/>';
						}
					} else if (MomDetail.RecordType.Name == 'Line item Competitor') {
						if (MomDetail.MMPJ_TOPG_Competitor__r.name != null) {
							topic = '<b>' + MomDetail.MMPJ_TOPG_Competitor__r.name + '</b><br/>';
						}
					}
					if (topic != null)
						momHighlight.comment = topic + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					else
						momHighlight.comment = MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
				}
			
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, momHighlight.comment=[' + momHighlight.comment + ']');
				momHighlight.todo= MomDetail.MMPJ_TOPG_Action_Title__c;
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, momHighlight.todo=' + momHighlight.todo);
				momHighlight.whenHighlight = MomDetail.MMPJ_TOPG_When__c;
				listMOMHighLight.add(momHighlight);
			}
           
            if(MomDetail.RecordType.Name == 'Line Item 4P' && !MomDetail.MMPJ_TOPG_IsHighlight__c) {
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, MomDetail.MMPJ_TOPG_Comment__c=[' + MomDetail.MMPJ_TOPG_Comment__c + ']');
				MMPJ_TOPG_MoMLineItem__c momLineItem = new MMPJ_TOPG_MoMLineItem__c();
				momLineItem = MomDetail;
				if (MomDetail.MMPJ_TOPG_Comment__c != null) {
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('&','&amp;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('<','&lt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('>','&gt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('"','&quot;');
					if (MomDetail.MMPJ_TOPG_TopicPPPP__c != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_TopicPPPP__c + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					} else if (MomDetail.MMPJ_TOPG_Detail_Line_Topic__c != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_Detail_Line_Topic__c + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					} else {
						momLineItem.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line Item 4P - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				} else { // TGS-47
					if (MomDetail.MMPJ_TOPG_TopicPPPP__c != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_TopicPPPP__c + '</b><br/>';
					} else if (MomDetail.MMPJ_TOPG_Detail_Line_Topic__c != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_Detail_Line_Topic__c + '</b><br/>';
					} 
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line Item 4P - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				}
				listMOMLinePPPP.add(momLineItem);
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, listMOMLinePPPP.size()=' + listMOMLinePPPP.size());
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, listMOMLinePPPP=' + listMOMLinePPPP);
			}
            if(MomDetail.RecordType.Name == 'Line item Market Performance' && !MomDetail.MMPJ_TOPG_IsHighlight__c ) {
				MMPJ_TOPG_MoMLineItem__c momLineItem = new MMPJ_TOPG_MoMLineItem__c();
				momLineItem = MomDetail;
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, MomDetail=' + MomDetail); 
				if (MomDetail.MMPJ_TOPG_Comment__c != null) {
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('&','&amp;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('<','&lt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('>','&gt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('"','&quot;');
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, MomDetail.MMPJ_TOPG_Comment__c=[' + MomDetail.MMPJ_TOPG_Comment__c +']');
					if (MomDetail.MMPJ_TOPG_Detail_Line_Topic__c != null) {
						if (MomDetail.MMPJ_TOPG_FileName__c != null) {
							System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Market Performance - cas 1');
							momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_FileName__c + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
						} else {
							System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Market Performance - cas 2');
							momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_Detail_Line_Topic__c + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
						}
					} else {
						if ((MomDetail.MMPJ_TOPG_FileName__c != null) && (MomDetail.MMPJ_TOPG_FileName__c != 'File or text')) { // TGS-50
							System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Market Performance - cas 3');
							momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_FileName__c + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
						} else { 
							System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Market Performance - cas 4');
							// TGS-48, TGS-50
							momLineItem.MMPJ_TOPG_Comment__c = + '<b>Add document</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
						}
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Market Performance - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				} else { // TGS-47
					if (MomDetail.MMPJ_TOPG_Detail_Line_Topic__c != null) {
						if (MomDetail.MMPJ_TOPG_FileName__c != null) {
							momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_FileName__c + '</b><br/>';
						} else {
							momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_Detail_Line_Topic__c + '</b><br/>';
						}
					} else {
						if (MomDetail.MMPJ_TOPG_FileName__c != null) {
							momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_FileName__c + '</b><br/>';
						}
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Market Performance - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				}
				listMOMLineMarket.add(momLineItem);
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, listMOMLineMarket.size()=' + listMOMLineMarket.size());
			}
            if(MomDetail.RecordType.Name == 'Line Item Project' && !MomDetail.MMPJ_TOPG_IsHighlight__c) {
				MMPJ_TOPG_MoMLineItem__c momLineItem = new MMPJ_TOPG_MoMLineItem__c();
				momLineItem = MomDetail;
				if (MomDetail.MMPJ_TOPG_Comment__c != null) {
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('&','&amp;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('<','&lt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('>','&gt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('"','&quot;');
					if (MomDetail.MMPJ_TOPG_RelatedProject__r.name != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_RelatedProject__r.name + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					} else {
						momLineItem.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line Item Project - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				} else { // TGS-47
					if (MomDetail.MMPJ_TOPG_RelatedProject__r.name != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_RelatedProject__r.name + '</b><br/>';
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line Item Project - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				}
				listMOMLineProject.add(momLineItem);
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, listMOMLineProject.size()=' + listMOMLineProject.size());
			}
            if(MomDetail.RecordType.Name == 'Line item Competitor' && !MomDetail.MMPJ_TOPG_IsHighlight__c ) {
				MMPJ_TOPG_MoMLineItem__c momLineItem = new MMPJ_TOPG_MoMLineItem__c();
				momLineItem = MomDetail;
				if (MomDetail.MMPJ_TOPG_Comment__c != null) {
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('&','&amp;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('<','&lt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('>','&gt;');
					MomDetail.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('"','&quot;');
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, MomDetail.MMPJ_TOPG_Competitor__r.name : ' + MomDetail.MMPJ_TOPG_Competitor__r.name);
					if (MomDetail.MMPJ_TOPG_Competitor__r.name != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_Competitor__r.name + '</b><br/>' + MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					} else {
						momLineItem.MMPJ_TOPG_Comment__c = MomDetail.MMPJ_TOPG_Comment__c.replaceall('\n','<br/>');
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Competitor - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				} else { // TGS-47
					if (MomDetail.MMPJ_TOPG_Competitor__r.name != null) {
						momLineItem.MMPJ_TOPG_Comment__c = '<b>' + MomDetail.MMPJ_TOPG_Competitor__r.name + '</b><br/>';
					}
					System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, Line item Competitor - momLineItem.MMPJ_TOPG_Comment__c [' + momLineItem.MMPJ_TOPG_Comment__c + ']');
				}
				listMOMLineCompetitor.add(momLineItem);
				System.debug('==> MMPJ_TOPG_MinutesPDFcontroller, listMOMLineCompetitor.size()=' + listMOMLineCompetitor.size());
			}
        }
		
		if (listMOMHighLight.size() > 0) {
			displayHighlights = 'display with header';
			healderAlreadyDisplayed = true;
		}
		if (listMOMLineMarket.size() > 0) {
			if (healderAlreadyDisplayed == false) {
				displayLineMarket = 'display with header';
				healderAlreadyDisplayed = true;
			}
			else
				displayLineMarket = 'display with no header';
		} 
		if (listMOMLinePPPP.size() > 0) {
			if (healderAlreadyDisplayed == false) {
				displayLinePPPP = 'display with header';
				healderAlreadyDisplayed = true;
			}
			else
				displayLinePPPP = 'display with no header';
		} 
		if (listMOMLineProject.size() > 0) {
			if (healderAlreadyDisplayed == false) {
				displayLineProject = 'display with header';
				healderAlreadyDisplayed = true;
			}
			else
				displayLineProject = 'display with no header';
		} 
		if (listMOMLineCompetitor.size() > 0) {
			if (healderAlreadyDisplayed == false) {
				displayLineCompetitor = 'display with header';
				healderAlreadyDisplayed = true;
			}
			else
				displayLineCompetitor = 'display with no header';
		} 
    }
}