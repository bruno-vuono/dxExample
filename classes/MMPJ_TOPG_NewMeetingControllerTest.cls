@isTest
public class MMPJ_TOPG_NewMeetingControllerTest 
{
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
    @testSetup static void methodName() {
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];      
        User u = new User(Username = mailPrefix+'-NPLsupervisor@pernod-ricard.com', email = mailPrefix+'-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        insert u;
        User u2 = new User(Username = mailPrefix+'-NPLsuper2visor@pernod-ricard.com', email = mailPrefix+'-super2visor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        system.debug('#### u => user Username ' +mailPrefix+'-NPLsupervisor@pernod-ricard.com');
        system.debug('#### u 2=>user Username ' +mailPrefix+'-NPLsuper2visor@pernod-ricard.com');
        insert u2;
        System.runAs(u){
            //create market
            List<MMPJ_TOPG_Market__c> marketList = new List<MMPJ_TOPG_Market__c>();
            MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
            market.Name='testmarket';
            marketList.add(market);
            
            MMPJ_TOPG_Market__c marketAll = new MMPJ_TOPG_Market__c();
            marketAll.Name='All Markets';
            marketList.add(marketAll);
            insert marketList;

            //create brand
            MMPJ_TOPG_BRAND__c brand = new MMPJ_TOPG_BRAND__c();
            brand.name='Martell';
            insert brand;
            
			      //=========Create BMCs=============//
            List<MMPJ_TOPG_BMC__c> bmcList = new List<MMPJ_TOPG_BMC__c>();
            MMPJ_TOPG_BMC__c bmcTest = new MMPJ_TOPG_BMC__c ();
            bmcTest.name='bmcTest';
            //BTO => delete "Brand & Market" from BMC
            //bmcTest.MMPJ_TOPG_Market__c=market.id;
            //bmcTest.MMPJ_TOPG_Brand__c=brand.id;
            bmcList.add(bmcTest);
            
            MMPJ_TOPG_BMC__c france = new MMPJ_TOPG_BMC__c ();
            france.name='France';  
            france.MMPJ_TOPG_BMCOwner__c = u.id;
            bmcList.add(france);
            
            MMPJ_TOPG_BMC__c china = new MMPJ_TOPG_BMC__c ();
            china.name='China'; 
            bmcList.add(china);           
            insert bmcList ;

            //=========Create Meetings=============//
            List<MMPJ_TOPG_Meeting__c> meetingList = new List<MMPJ_TOPG_Meeting__c>();
            MMPJ_TOPG_Meeting__c  meeting = new MMPJ_TOPG_Meeting__c();
            meeting.MMPJ_TOPG_BMC__c = bmcTest.id;
            Meeting.MMPJ_TOPG_Interaction__c = 'test';
            meetingList.add(meeting);
            
            MMPJ_TOPG_Meeting__c  franceMeeting = new MMPJ_TOPG_Meeting__c();
            franceMeeting.MMPJ_TOPG_BMC__c = france.id;
            franceMeeting.Name = 'France';
            franceMeeting.MMPJ_TOPG_Interaction__c = 'meet in Paris';
            meetingList.add(franceMeeting);
            
            MMPJ_TOPG_Meeting__c  chinaMeeting = new MMPJ_TOPG_Meeting__c();
            chinaMeeting.MMPJ_TOPG_BMC__c = china.id;
            chinaMeeting.MMPJ_TOPG_Interaction__c = 'test';
            meetingList.add(chinaMeeting);
            insert meetingList;

            //=========Create Events=============//
            List<Event> evtList = new List<Event>();
            Event ev = new Event();
            ev.Subject='tet';
            ev.StartDateTime = System.now(); //DateTime.parse('2/2/2016 10:53 AM') ;
            ev.ENDDateTime = System.now(); //DateTime.parse('2/2/2016 10:55 AM');
            ev.Location = 'est';
            ev.Whatid=meeting.id;
            evtList.add(ev);
            
            Event evFr = new Event();
            evFr.Subject='in Paris';
            evFr.StartDateTime = System.now();
            evFr.ENDDateTime = System.now(); 
            evFr.Location = 'est';
            evFr.ownerid = u.id;
            evFr.Whatid=franceMeeting.id;
            evtList.add(evFr);
            
            Event evCh = new Event();
            evCh.Subject='tet';
            evCh.StartDateTime = System.now(); 
            evCh.ENDDateTime = System.now(); 
            evCh.Location = 'est';
            evCh.Whatid=chinaMeeting.id;
            evtList.add(evCh);
            insert evtList;

            //=========Create Events=============//
            contact c = new contact();
            c.Lastname = 'test contact';
            insert c;
            
            contact c1 = new contact();
            c1.Lastname = 'test contact 1';
            insert c1;
            
            //========= eventRelation =============//             
            List<eventRelation> evtRelationList = new List<eventRelation>();
            eventRelation evRFr = new EventRelation();
            evRFr.relationid = u2.id;
            evRFr.EventId = evFr.id;
            evtRelationList.add(evRFr); 
            
            eventRelation evRFr1 = new EventRelation();
            evRFr1.relationid = c1.id;
            evRFr1.EventId = evFr.id;
            evtRelationList.add(evRFr1);  
            
            eventRelation evRCh = new EventRelation();
            evRCh.relationid = c.id;
            evRCh.EventId = evCh.id;
            evtRelationList.add(evRCh); 
            
            eventRelation evRCh1 = new EventRelation();
            evRCh1.relationid = u2.id;
            evRCh1.EventId = evCh.id;
            evtRelationList.add(evRCh1); 

            eventRelation evRl = new EventRelation();
            evRl.relationid = u2.id;
            evRl.EventId = ev.id;
            evtRelationList.add(evRl); 

            eventRelation evRl2 = new EventRelation();
            evRl2.relationid = c.id;
            evRl2.EventId = ev.id;
            evtRelationList.add(evRl2); 
            insert evtRelationList;

            // Attachements
            List<attachment> attachmentList = new List<attachment>();
            attachment attpdf = new attachment();
            attpdf.ParentId = franceMeeting.id;
            attpdf.name = franceMeeting.Name +'-Agenda.pdf';
            attpdf.Body = blob.valueof('testl');
            attachmentList.add(attpdf);    
            
            attachment att2l = new attachment();
            att2l.ParentId = franceMeeting.id;
            att2l.name = 'test2';
            att2l.Body = blob.valueof('testl');
            attachmentList.add(att2l); 
            insert attachmentList;     
            //=========Create competitor=============//
            List<MMPJ_TOPG_Competitor__c> compList = new List<MMPJ_TOPG_Competitor__c>();
            MMPJ_TOPG_Competitor__c competitor = new  MMPJ_TOPG_Competitor__c();
            competitor.name = 'Overview';
            compList.add(competitor); 
            
            MMPJ_TOPG_Competitor__c competitor1 = new  MMPJ_TOPG_Competitor__c();
            competitor1.name = 'luxury';
            compList.add(competitor1); 
            insert compList;
            
            //=========Create project=============//
            MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
            project.name = 'testProject';
            project.MMPJ_TOPG_NewProjectType__c = 'Classical Project';
            project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
            project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
            project.MMPJ_TOPG_ProjectOwner__c=u.id; 
            insert project;
            
            //Add meeting items (preparing meeting)
            List<MMPJ_TOPG_MeetingProject__c> meetingProjList = new List<MMPJ_TOPG_MeetingProject__c>();
            MMPJ_TOPG_MeetingProject__c meetingProj = new MMPJ_TOPG_MeetingProject__c();
            meetingProj.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            meetingProjList.add(meetingProj); 
            MMPJ_TOPG_MeetingProject__c meetingProj1 = new MMPJ_TOPG_MeetingProject__c();
            meetingProj1.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            meetingProjList.add(meetingProj1);
            insert meetingProjList;
            
            MMPJ_TOPG_MeetingMarketPerf__c MeetingMarketPerf = new MMPJ_TOPG_MeetingMarketPerf__c();
            MeetingMarketPerf.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            MeetingMarketPerf.MMPJ_TOPG_Comment__c ='comment';
            insert MeetingMarketPerf;
            MMPJ_TOPG_MeetingMarketPerf__c MeetingMarketPerf1 = new MMPJ_TOPG_MeetingMarketPerf__c();
            MeetingMarketPerf1.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            insert MeetingMarketPerf1;
            
            MMPJ_TOPG_MeetingCompetitor__c MeetingCompet = new MMPJ_TOPG_MeetingCompetitor__c();
            MeetingCompet.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            MeetingCompet.MMPJ_TOPG_Comment__c ='comment';
            insert MeetingCompet;
            MMPJ_TOPG_MeetingCompetitor__c MeetingCompet1 = new MMPJ_TOPG_MeetingCompetitor__c();
            MeetingCompet1.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            insert MeetingCompet1;
            
            MMPJ_TOPG_4P__c meeting4 = new MMPJ_TOPG_4P__c ();
            meeting4.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            meeting4.MMPJ_TOPG_Comment__c ='comment';
            insert meeting4;            
            MMPJ_TOPG_4P__c meeting41 = new MMPJ_TOPG_4P__c ();
            meeting41.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            insert meeting41;
			      
            // MOM
            List<MMPJ_TOPG_MinuteofMeeting__c> momList = new List<MMPJ_TOPG_MinuteofMeeting__c>();
            MMPJ_TOPG_MinuteofMeeting__c min = new MMPJ_TOPG_MinuteofMeeting__c();
            min.MMPJ_TOPG_Start_Date__c=ev.StartDateTime;
            min.MMPJ_TOPG_End_Date__c=ev.ENDDateTime;
            min.MMPJ_TOPG_RAID__c='Action';
            min.MMPJ_TOPG_Title__c='Test tilte';
            min.MMPJ_TOPG_Status__c='Planned';
            min.MMPJ_TOG_MinutesDate__c=system.today();
            min.MMPJ_TOPG_Location__c = ev.Location;           
            min.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            min.MMPJ_TOPG_Assist__c = true;
            momList.add(min); 
            
            MMPJ_TOPG_MinuteofMeeting__c mom = new MMPJ_TOPG_MinuteofMeeting__c();
            mom.MMPJ_TOPG_Start_Date__c=ev.StartDateTime;
            mom.MMPJ_TOPG_End_Date__c=ev.ENDDateTime;
            mom.MMPJ_TOPG_RAID__c='Action';
            mom.MMPJ_TOPG_Title__c='Paris tilte';
            mom.MMPJ_TOPG_Status__c='Planned';
            mom.MMPJ_TOG_MinutesDate__c=system.today();
            mom.MMPJ_TOPG_Location__c = ev.Location;           
            mom.MMPJ_TOPG_Meeting__c = franceMeeting.id;
            mom.MMPJ_TOPG_Assist__c = true;
            momList.add(mom); 
            insert momList;
	
            //Add detail line :Market
            List<MMPJ_TOPG_MoMLineItem__c> momLineItemList = new List<MMPJ_TOPG_MoMLineItem__c>();
            MMPJ_TOPG_MoMLineItem__c LineItemMark = new MMPJ_TOPG_MoMLineItem__c();
            LineItemMark.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
            LineItemMark.MMPJ_TOPG_Title__c='Test line Item';
            LineItemMark.MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance';
            LineItemMark.MMPJ_TOPG_FileName__c = 'File or text';
            LineItemMark.MMPJ_TOPG_Comment__c ='Comment line Item';
            LineItemMark.MMPJ_TOPG_When__c=system.Today();
            LineItemMark.MMPJ_TOPG_MinutesofMeeting__c =min.id;
            LineItemMark.MMPJ_TOPG_RelatedProject__c = project.id;
            momLineItemList.add(LineItemMark);

            //Add detail line : Competitor
            MMPJ_TOPG_MoMLineItem__c LineItemComp = new MMPJ_TOPG_MoMLineItem__c();
            LineItemComp.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
            LineItemComp.MMPJ_TOPG_Detail_Line_Topic__c ='Competition';
            LineItemComp.MMPJ_TOPG_Competitor__c=competitor.id;
            LineItemComp.MMPJ_TOPG_Title__c='Test line Item';
            LineItemComp.MMPJ_TOPG_Topic__c ='Test line Item';
            LineItemComp.MMPJ_TOPG_When__c=system.Today();
            LineItemComp.MMPJ_TOPG_MinutesofMeeting__c =min.id;
            LineItemComp.MMPJ_TOPG_RelatedProject__c = project.id;
            momLineItemList.add(LineItemComp);
            
            //Add detail line :Project-initiative
            MMPJ_TOPG_MoMLineItem__c LineItemProj = new MMPJ_TOPG_MoMLineItem__c();
            LineItemProj.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
            LineItemProj.MMPJ_TOPG_Detail_Line_Topic__c ='Project-Key Initiative';
            LineItemProj.MMPJ_TOPG_RelatedProject__c=project.id;
            LineItemProj.MMPJ_TOPG_Comment__c ='Comment Project-intiative';
            LineItemProj.MMPJ_TOPG_When__c=system.Today();
            LineItemProj.MMPJ_TOPG_MinutesofMeeting__c =min.id;
            LineItemProj.MMPJ_TOPG_RelatedProject__c = project.id;
            momLineItemList.add(LineItemProj);
            insert momLineItemList;
            
            //Insert RAID
            MMPJ_TOPG_RAID__c raid = new MMPJ_TOPG_RAID__c();
            raid.MMPJ_TOPG_Title__c = 'raid title';
            raid.MMPJ_TOPG_RAID__c = 'Action';
            raid.MMPJ_TOPG_Description__c = 'Desc raid';
            raid.MMPJ_TOPG_ExpectedDate__c = System.today();
            raid.MMPJ_TOPG_Status__c = 'Planned';
            raid.MMPJ_TOPG_User__c = u.id;
            raid.MMPJ_TOPG_Meeting__c = meeting.id;
            raid.MMPJ_TOPG_LineItem__c = LineItemMark.id;
            insert raid;
            
            //Attachement
            Attachment attach=new Attachment();
            Blob b = Blob.valueOf('Test');
      		  attach.Body=b;
     	      attach.Name='test';
            attach.ContentType='contentType';
            attach.ParentID=franceMeeting.id;
            insert attach;
            
            //========Pas encore evol on utilise market au lieu de bmc pour créer les visites
    		    MMPJ_TOPG_Outlet__c outlet = new MMPJ_TOPG_Outlet__c();
            outlet.Name='test outlet';
            outlet.MMPJ_TOPG_Market__c=market.id;
            insert outlet;
            //create partner      
            MMPJ_TOPG_Partner__c partner = new MMPJ_TOPG_Partner__c();
            partner.Name='partner1';
            partner.MMPJ_TOPG_Market__c=market.id;
            insert partner;
         
            MMPJ_TOPG_Visit__c visit = new MMPJ_TOPG_Visit__c();
            visit.name= 'test visit';
            visit.MMPJ_TOPG_StatementDate__c=date.newInstance(1990, 11, 21);
            visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
            visit.MMPJ_TOPG_Outlet__c=outlet.id;
            visit.MMPJ_TOPG_PARTNER__c=partner.id;
            visit.MMPJ_TOPG_MMPJVisitor__c=u.id;
            visit.MMPJ_TOPG_BMC__c = france.id;
            visit.MMPJ_TOPG_Market__c= market.id;
            visit.MMPJ_TOPG_Bench_Currency__c='Euro';
            insert visit;
            //========Pas encore evol on utilise market au lieu de bmc pour créer les visites
        }
    }

    static testMethod void testNewMeeting()
    {
        system.debug('==> call method testNewMeeting()');
        MMPJ_TOPG_BMC__c bmcFrance = [select id, MMPJ_TOPG_BMCOwner__c from MMPJ_TOPG_BMC__c where name='France' limit 1];
        Event ev = [select id from Event where Subject='tet'limit 1];
        Event evfr = [select id from Event where Subject='in Paris'limit 1];
        
        MMPJ_TOPG_Meeting__c  meeting = [select id from MMPJ_TOPG_Meeting__c where MMPJ_TOPG_Interaction__c = 'test' limit 1];
        MMPJ_TOPG_BMC__c bmcTest = [select id from MMPJ_TOPG_BMC__c where name='bmcTest' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemMarket = [select id,MMPJ_TOPG_Detail_Line_Topic__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemComp = [select id,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Competition' limit 1];
        
        system.debug('#### mailPrefix in SOQL :' +mailPrefix+'-NPLsupervisor@pernod-ricard.com');
        user u = [select id, Name from user where Username =: mailPrefix+'-NPLsupervisor@pernod-ricard.com'];
        
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;
        insert project;
        
        Test.startTest();
       
        PageReference PageMeeting  = page.MMPJ_TOPG_NewMeeting;    
        Test.setCurrentPage(PageMeeting);
        ApexPages.currentPage().getParameters().put('BMCID',bmcFrance.id);
      
        ApexPages.StandardController BmcFrStdController = new ApexPages.StandardController(bmcFrance);
        MMPJ_TOPG_NewMeetingController  meetingCtrl = new MMPJ_TOPG_NewMeetingController(BmcFrStdController);    
        meetingCtrl.agendaConstructor();
        meetingCtrl.PrintPdf();
        
        ApexPages.currentPage().getParameters().put('TabName','Agenda');
        meetingCtrl.BMCID_param = ApexPages.currentPage().getParameters().get('BMCID');
        meetingCtrl.ListWrapperClassOwner= new list<user>();
        meetingCtrl.ListWrapperClassOwner.add(u);
        meetingCtrl.meeting = [select id,name from MMPJ_TOPG_Meeting__c where MMPJ_TOPG_Interaction__c = 'meet in Paris' limit 1];
        meetingCtrl.Agenda = [select id, ownerid, StartDateTime,ENDDateTime,Subject from Event where Subject='in Paris'limit 1];        
     
        meetingCtrl.PrintPdf();
        System.assertEquals(meetingCtrl.Agenda.StartDateTime > meetingCtrl.Agenda.ENDDateTime, false);

        meetingCtrl.newTab = 'Agenda';
        meetingCtrl.PPPPpopup = new MMPJ_TOPG_4P__c();
		    //Meeting attachement
		
        attachment att = [select id,name,parentId,LastModifiedDate from attachment  where parentId =: meetingCtrl.meeting.id limit 1];
        MMPJ_TOPG_NewMeetingController.AttachmentWrapper attwrapper = new MMPJ_TOPG_NewMeetingController.AttachmentWrapper();
        attwrapper.id = att.id; 
        attwrapper.title = att.name;
        attwrapper.LastModified = att.LastModifiedDate;
        attwrapper.createdbyId = u.id;
        attwrapper.createdByName = u.Name;
        attwrapper.ischatterDocument = true;
        
        meetingCtrl.ListChatterMeeting =  new list<MMPJ_TOPG_NewMeetingController.AttachmentWrapper>();
        meetingCtrl.ChatterAttachments = [SELECT ContentDocumentId,ContentDocument.ContentModifiedDate,ContentDocument.FileType,ContentDocument.Title,ContentDocument.OwnerId,ContentDocument.Owner.name
                                     FROM ContentDocumentLink
                                     WHERE LinkedEntityId =:meetingCtrl.meeting.id];
                    
        attachment attl = new attachment();
        attl.ParentId = meetingCtrl.meeting.id;
        attl.name = 'test';
        attl.Body = blob.valueof('testl');
        insert attl;
       
        meetingCtrl.listAtt = [Select Name, parentId from attachment
                                       Where parentId =:meetingCtrl.meeting.id ];
           
        
        //Visit
		    meetingCtrl.visit = [select id from MMPJ_TOPG_Visit__c where MMPJ_TOPG_BMC__c =:bmcFrance.id limit 1];        
         
        meetingCtrl.MeetingAttachments = [select id,name,lastmodifieddate,createdby.name,createdbyid,ContentType
                             from Attachment
                             Where ParentId =:meetingCtrl.meeting.id];
        ContentVersion contentVersion_1 = new ContentVersion(
                                                         	   Title = 'Penguins',
                                                         	   PathOnClient = 'Penguins.jpg',
                                                          	 VersionData = Blob.valueOf('Test Content'),
                                                         	   IsMajorVersion = true
                                                            );
        insert contentVersion_1;      
        
        ContentDocumentLink link = new ContentDocumentLink();
        link.LinkedEntityId = meetingCtrl.meeting.id;
        link.ContentDocumentId =[SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion_1.Id].ContentDocumentId;
        link.ShareType = 'V';
        link.Visibility = 'AllUsers';
        insert link;
        
        meetingCtrl.AttachmentConstructor();
        meetingCtrl.AttachmentToDelete = attl.id;
        meetingCtrl.DelAtt();
        meetingCtrl.WrapperToDelete = 0;
        
        meetingCtrl.AddMeetingDocument();
        meetingCtrl.WrapperToDelete = 0;
        meetingCtrl.deleteWrapper();
        meetingCtrl.AddVisitDocument();
        attachment attVisit = new attachment();
        attVisit.ParentId = meetingCtrl.meeting.id;
        attVisit.name = meetingCtrl.meeting.Name +'-Agenda.pdf';
        attVisit.Body = blob.valueof('testl');
        insert attVisit;   
		    meetingCtrl.VisitsAttachments = new List<attachment>() ; 
           
        MMPJ_TOPG_NewMeetingController.WrapperAgendDetailLine TheWrapperAgendDetail = new MMPJ_TOPG_NewMeetingController.WrapperAgendDetailLine();
        TheWrapperAgendDetail.TopicType = 'Market Performance';
        TheWrapperAgendDetail.CommentThreeLine = 'Market Performance';
        TheWrapperAgendDetail.LineItemMeetingMarketPerf = new MMPJ_TOPG_MeetingMarketPerf__c();
        TheWrapperAgendDetail.LineItemMeetingCompetitor = new MMPJ_TOPG_MeetingCompetitor__c();
        TheWrapperAgendDetail.LineItemMeeting4P = new MMPJ_TOPG_4P__c();
        TheWrapperAgendDetail.MeetingTopic = false;
        meetingCtrl.detailAgendaComment ='comment';
        //Add Attendees
        meetingCtrl.ListCurrentAttendee = meetingCtrl.Agenda.EventRelations;
        
        EventRelation AttendeeOwner = new EventRelation();
                    AttendeeOwner.EventId = meetingCtrl.Agenda.id;
                    AttendeeOwner.RelationId = bmcFrance.MMPJ_TOPG_BMCOwner__c;
        
        MMPJ_TOPG_NewMeetingController.WrapperpaAttList awrapper = new MMPJ_TOPG_NewMeetingController.WrapperpaAttList();
        awrapper.function = 'function';
        awrapper.email= 'test@email.com';
        awrapper.SelectValue='User';
        awrapper.meeting=meeting;    
        meetingCtrl.ListWrapperAttendees.add(awrapper);  
        
        MMPJ_TOPG_NewMeetingController.WrapperpaAttList awrapper1 = new MMPJ_TOPG_NewMeetingController.WrapperpaAttList();
        awrapper1.function = 'function';
        awrapper1.email= 'test@email.com';
        awrapper1.SelectValue='User';
        awrapper1.meeting=meeting;    
        meetingCtrl.ListWrapperAttendees.add(awrapper1);  
        
        MMPJ_TOPG_NewMeetingController.WrapperpaAttList awrapperOwner = new MMPJ_TOPG_NewMeetingController.WrapperpaAttList();
        awrapperOwner.function = 'function';
        awrapperOwner.email= 'test@email.com';
        awrapperOwner.SelectValue='User';
        awrapperOwner.meeting = new MMPJ_TOPG_Meeting__c();
        awrapperOwner.meeting.MMPJ_TOPG_TECH_user__c = meetingCtrl.Agenda.ownerid;
        awrapperOwner.meeting=meeting;    
        meetingCtrl.ListWrapperAttendees.add(awrapperOwner);       
        meetingCtrl.LineItemCounter = 1;
        meetingCtrl.GoUPAttendeeLine();
        
        //Add Market Performance
        meetingCtrl.SetTopicAgendaPopUp = 'Market Performance';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance';
        MMPJ_TOPG_Project__c proje = [select id from MMPJ_TOPG_Project__c where MMPJ_TOPG_NewProjectType__c='Classical Project' limit 1];
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        MMPJ_TOPG_Competitor__c comp = [select id from MMPJ_TOPG_Competitor__c where Name='luxury' limit 1];
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world';
        meetingCtrl.SaveAndNewDetailAgendaPop();
        
        meetingCtrl.SetTopicAgendaPopUp = 'Market Performance';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance';       
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;       
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world again';
        meetingCtrl.SaveAndNewDetailAgendaPop();
        
        //Add Project
        meetingCtrl.showProjectPopup();
        meetingCtrl.SetTopicAgendaPopUp = 'Project';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Project';
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world';
        meetingCtrl.saveDetailAgendaPop();
        
        meetingCtrl.SetTopicAgendaPopUp = 'Project';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Project';
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world Again' ;
        meetingCtrl.saveDetailAgendaPop();
        
        meetingCtrl.SetTopicAgendaPopUp = 'Promotion / Communication';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Promotion / Communication';
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world Again' ;
        meetingCtrl.saveDetailAgendaPop();
        
        meetingCtrl.SetTopicAgendaPopUp = 'Competition';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Competition';
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world Again' ;
        meetingCtrl.saveDetailAgendaPop();
        meetingCtrl.closeAgendapopup();
        
        meetingCtrl.Error = false;
        meetingCtrl.ErrorMessage= 'This meeting has no Event';
        
        meetingCtrl.MapMeeting4PToinsert.put(1,new MMPJ_TOPG_4P__c(MMPJ_TOPG_Topic__c = 'test',MMPJ_TOPG_Comment__c = ' -test set - testset -esttse'));
        meetingCtrl.MapMeetingCompToinsert.put(1,new MMPJ_TOPG_MeetingCompetitor__c(MMPJ_TOPG_Competitor__c = LineItemComp.MMPJ_TOPG_Competitor__c, MMPJ_TOPG_Meeting__c = LineItemComp.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemComp.MMPJ_TOPG_Comment__c));
        meetingCtrl.MapMeetingMarketToinsert.put(1,new MMPJ_TOPG_MeetingMarketPerf__c(MMPJ_TOPG_Detail_Line_Topic__c = LineItemMarket.MMPJ_TOPG_Detail_Line_Topic__c, MMPJ_TOPG_Meeting__c = LineItemMarket.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemMarket.MMPJ_TOPG_Comment__c));
        meetingCtrl.MapMeetingProjectToinsert.put(1,new MMPJ_TOPG_MeetingProject__c(MMPJ_TOPG_Project__c = project.id, MMPJ_TOPG_Meeting__c = LineItemMarket.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemMarket.MMPJ_TOPG_Comment__c));
        meetingCtrl.MapMeeting4PToinsert.put(2,new MMPJ_TOPG_4P__c(MMPJ_TOPG_Meeting__c = meeting.id,MMPJ_TOPG_Topic__c = 'test23'));
        meetingCtrl.MapMeetingCompToinsert.put(2,new MMPJ_TOPG_MeetingCompetitor__c(MMPJ_TOPG_Meeting__c = meeting.id));
        meetingCtrl.MapMeetingCompToinsert.put(3,new MMPJ_TOPG_MeetingCompetitor__c(MMPJ_TOPG_Meeting__c = meeting.id));
        meetingCtrl.MapMeetingMarketToinsert.put(2,new MMPJ_TOPG_MeetingMarketPerf__c(MMPJ_TOPG_Meeting__c = meeting.id));
        meetingCtrl.MapMeetingMarketToinsert.put(3,new MMPJ_TOPG_MeetingMarketPerf__c(MMPJ_TOPG_Meeting__c = meeting.id));
        meetingCtrl.MapMeetingProjectToinsert.put(2,new MMPJ_TOPG_MeetingProject__c(MMPJ_TOPG_Meeting__c = meeting.id)); 
        meetingCtrl.MapMeetingProjectToinsert.put(3,new MMPJ_TOPG_MeetingProject__c(MMPJ_TOPG_Meeting__c = meeting.id)); 
        
        //Save/Update Agenda
       
        meetingCtrl.PrintPDF();
        meetingCtrl.UpdateAgenda();     
        meetingCtrl.SaveAndCloseAgenda();
        meetingCtrl.LeavingAgenda();
        meetingCtrl.ShowSaveMessage_newCounter = 1;
        meetingCtrl.ShowSaveMessage_oldCounter = 0;
        boolean showMessg = meetingCtrl.ShowSaveMessage;
        meetingCtrl.Cancel();
        
        //=============MOM================
        //listMOMLineProject
        meetingCtrl.newTab = 'Minutes';
        meetingCtrl.MinutesConstructor();
        meetingCtrl.listMOMLineMarket = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        meetingCtrl.listMOMLineProject = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        meetingCtrl.listMOMLineCompetitor = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        meetingCtrl.listMOMLinePPPP = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        
        //Add Item of MOM using pop Up
        meetingCtrl.SetTopicMinutePopUp = 'Place';
        meetingCtrl.AddPPPPMom();
        meetingCtrl.SaveAndNewDetailPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Market Performance';
        meetingCtrl.AddMarketMom();
        meetingCtrl.SaveAndNewDetailPop();
        
	      meetingCtrl.SetTopicMinutePopUp = 'Project-Key Initiative';
        meetingCtrl.AddProjectMom();
        meetingCtrl.SaveAndNewDetailPop();  
        
        meetingCtrl.SetTopicMinutePopUp = 'Competition';
        meetingCtrl.AddCompMom();
        meetingCtrl.SaveDetailPop();  
        
        //
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine itemDetailMarket = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        itemDetailMarket.SelectValue='User';
        itemDetailMarket.index=0;
        itemDetailMarket.Project='test Project';
        itemDetailMarket.comp='comp';
        itemDetailMarket.Product='product';
        itemDetailMarket.who='user1';
        itemDetailMarket.TopicType='call';
        itemDetailMarket.CommentThreeLine='comment';
        itemDetailMarket.LineItem=LineItemMarket;
        itemDetailMarket.MeetingTopic=true;          
        meetingCtrl.listMOMLineMarket.add(itemDetailMarket);
        
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine itemDetailComp = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        itemDetailComp.SelectValue='User';
        itemDetailComp.index=0;
        itemDetailComp.Project='test Project';
        itemDetailComp.comp='comp';
        itemDetailComp.Product='product';
        itemDetailComp.who='user1';
        itemDetailComp.TopicType='call';
        itemDetailComp.CommentThreeLine='comment';
        itemDetailComp.LineItem=LineItemMarket;
        itemDetailComp.MeetingTopic=true;       
        meetingCtrl.listMOMLineCompetitor.add(itemDetailComp);
        
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine itemDetailPPPP = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        itemDetailPPPP.SelectValue='User';
        itemDetailPPPP.index=0;
        itemDetailPPPP.Project='test Project';
        itemDetailPPPP.comp='comp';
        itemDetailPPPP.Product='product';
        itemDetailPPPP.who='user1';
        itemDetailPPPP.TopicType='call';
        itemDetailPPPP.CommentThreeLine='comment';
        itemDetailPPPP.LineItem=LineItemMarket;
        itemDetailPPPP.MeetingTopic=true;       
        meetingCtrl.listMOMLinePPPP.add(itemDetailPPPP);
        
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine itemDetailPPPP1 = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        itemDetailPPPP1.SelectValue='User';
        itemDetailPPPP1.index=1;
        itemDetailPPPP1.Project='test Project';
        itemDetailPPPP1.comp='comp';
        itemDetailPPPP1.Product='product';
        itemDetailPPPP1.who='user1';
        itemDetailPPPP1.TopicType='call';
        itemDetailPPPP1.CommentThreeLine='comment';
        itemDetailPPPP1.LineItem=LineItemMarket;
        itemDetailPPPP1.MeetingTopic=true;       
        meetingCtrl.listMOMLinePPPP.add(itemDetailPPPP1); 
       
        meetingCtrl.ShowSaveMessage = false;
        meetingCtrl.MoM = [select id,MMPJ_TOPG_Title__c,MMPJ_TOPG_RAID__c,MMPJ_TOPG_Status__c from MMPJ_TOPG_MinuteofMeeting__c where MMPJ_TOPG_Title__c='Paris tilte' limit 1];
        
        //Add Market item use popUp
        meetingCtrl.SetTopicMinutePopUp = 'Market Performance';
        meetingCtrl.AddMarketMom();
        
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_Detail_Line_Topic__c = 'Market Performance';
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_RAID__c = 'Action';
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_IsHighlight__c = true;
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_Action_Title__c ='Do it';
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_Comment__c = 'Hello';
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_When__c = system.Today();
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_RelatedProject__c = project.id;
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_WhoU__c = u.id;
        meetingCtrl.DetailPopUp.SelectValue = 'User';
        meetingCtrl.SaveAndNewDetailPop();
        
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine awrapperComp = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        awrapperComp.SelectValue='User';
        awrapperComp.index=0;
        awrapperComp.Project='test Project';
        awrapperComp.comp='comp';
        awrapperComp.Product='product';
        awrapperComp.who='user1';
        awrapperComp.TopicType='call';
        awrapperComp.CommentThreeLine='comment';
        awrapperComp.LineItem=LineItemComp;
        awrapperComp.MeetingTopic=true;      
        meetingCtrl.listMOMLineCompetitor.add(awrapperComp);
        
        //Add Competition item use popUp
        meetingCtrl.SetTopicMinutePopUp  = 'Competition';
        meetingCtrl.AddCompMom();  
        meetingCtrl.AddMarketMom();
       
        meetingCtrl.selectedTopic();
        meetingCtrl.DetailPopUp.LineItem.MMPJ_TOPG_Comment__c = 'Hello';
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Project';
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.SaveDetailPop();
        meetingCtrl.closeDetailPopup();
        
        Test.stopTest();
    }

static testMethod void testNewMeeting2()
    {
        system.debug('==> call method testNewMeeting2()');
        MMPJ_TOPG_BMC__c bmcFrance = [select id, MMPJ_TOPG_BMCOwner__c from MMPJ_TOPG_BMC__c where name='France' limit 1];
        Event ev = [select id from Event where Subject='tet'limit 1];
        Event evfr = [select id from Event where Subject='in Paris'limit 1];
        
        MMPJ_TOPG_Meeting__c  meeting = [select id from MMPJ_TOPG_Meeting__c where MMPJ_TOPG_Interaction__c = 'test' limit 1];
        MMPJ_TOPG_BMC__c bmcTest = [select id from MMPJ_TOPG_BMC__c where name='bmcTest' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemMarket = [select id,MMPJ_TOPG_Detail_Line_Topic__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemComp = [select id,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Competition' limit 1];
        
        system.debug('#### mailPrefix in SOQL :' +mailPrefix+'-NPLsupervisor@pernod-ricard.com');
        user u = [select id, Name from user where Username =: mailPrefix+'-NPLsupervisor@pernod-ricard.com'];
        
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;
        insert project;
        
        Test.startTest();
       
        PageReference PageMeeting  = page.MMPJ_TOPG_NewMeeting;    
        Test.setCurrentPage(PageMeeting);
        ApexPages.currentPage().getParameters().put('BMCID',bmcFrance.id);
      
        ApexPages.StandardController BmcFrStdController = new ApexPages.StandardController(bmcFrance);
        MMPJ_TOPG_NewMeetingController  meetingCtrl = new MMPJ_TOPG_NewMeetingController(BmcFrStdController);    
        meetingCtrl.agendaConstructor();
        
        meetingCtrl.SetTopicAgendaPopUp = 'Competition';
        meetingCtrl.DetailAgendapopup();
        meetingCtrl.meeting.MMPJ_TOPG_Detail_Line_Topic__c ='Competition';
        MMPJ_TOPG_Project__c proje = [select id from MMPJ_TOPG_Project__c where MMPJ_TOPG_NewProjectType__c='Classical Project' limit 1];
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingProject.MMPJ_TOPG_Project__c = proje.id;
        MMPJ_TOPG_Competitor__c comp = [select id from MMPJ_TOPG_Competitor__c where Name='luxury' limit 1];
        meetingCtrl.TheWrapperAgendDetail.LineItemMeetingCompetitor.MMPJ_TOPG_Competitor__c = comp.id;
        meetingCtrl.TheWrapperAgendDetail.CommentThreeLine ='Hello world Again' ;
        meetingCtrl.saveDetailAgendaPop();
        meetingCtrl.closeAgendapopup();
        
        meetingCtrl.newTab = 'Minutes';
        meetingCtrl.MinutesConstructor();
        meetingCtrl.listMOMLineMarket = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        meetingCtrl.listMOMLineProject = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        meetingCtrl.listMOMLineCompetitor = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        meetingCtrl.listMOMLinePPPP = new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();

        //Add Project
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperProject = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine(); 
        wrapperProject.SelectValue='User';
        wrapperProject.index=2;
        wrapperProject.Project='test Project';
        wrapperProject.comp='comp';
        wrapperProject.Product='product';
        wrapperProject.who='user1';
        wrapperProject.TopicType='call';
        wrapperProject.CommentThreeLine='comment';
        wrapperProject.LineItem=LineItemComp;
        wrapperProject.MeetingTopic=true;      
        meetingCtrl.listMOMLineProject.add(wrapperProject);
        
        //Add project with pop up
        meetingCtrl.AllBrand =new list<selectoption>();
        meetingCtrl.SelectedBrand =new list<selectoption>();
        meetingCtrl.AllBrand.add(new SelectOption('Mum', 'Mum'));
        meetingCtrl.SelectedBrand.add(new SelectOption('Mum', 'Mum'));
        meetingCtrl.AllMarket =new list<selectoption>();
        meetingCtrl.SelectedMarket =new list<selectoption>();
        meetingCtrl.AllMarket.add(new SelectOption('France', 'France'));
        meetingCtrl.AllMarket.add(new SelectOption('China', 'China'));
        meetingCtrl.SelectedMarket.add(new SelectOption('France', 'France'));
        
        meetingCtrl.SetTopicMinutePopUp = 'Project-Key Initiative';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Place';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Price';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Product';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Promotion';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Competition';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Market Performance';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();
        meetingCtrl.SaveAndNewProjectPop();
        
        meetingCtrl.SetTopicMinutePopUp = 'Add document';
        meetingCtrl.AddProjectMom();
        meetingCtrl.selectedTopic();     
        meetingCtrl.SaveProjectPop();
        
        //Init item idex
        meetingCtrl.LineItemCounter=0;
        meetingCtrl.rowToRemove=0;
        //meetingCtrl.DelAttendee();
        meetingCtrl.UPproject = 1;
        meetingCtrl.UP4P = 1;
        meetingCtrl.UPmarket = 1;
        meetingCtrl.UPcomp = 1;
        meetingCtrl.LineToRemove =1;
        meetingCtrl.LineToEdit =1;
    
        //insert list
        meetingCtrl.MapMeeting4PToinsert.put(0,new MMPJ_TOPG_4P__c(MMPJ_TOPG_Topic__c = 'test',MMPJ_TOPG_Comment__c = ' -test set - testset -esttse'));
        meetingCtrl.MapMeetingCompToinsert.put(0,new MMPJ_TOPG_MeetingCompetitor__c(MMPJ_TOPG_Competitor__c = LineItemComp.MMPJ_TOPG_Competitor__c, MMPJ_TOPG_Meeting__c = LineItemComp.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemComp.MMPJ_TOPG_Comment__c));
        meetingCtrl.MapMeetingMarketToinsert.put(0,new MMPJ_TOPG_MeetingMarketPerf__c(MMPJ_TOPG_Detail_Line_Topic__c = LineItemMarket.MMPJ_TOPG_Detail_Line_Topic__c, MMPJ_TOPG_Meeting__c = LineItemMarket.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemMarket.MMPJ_TOPG_Comment__c));
        meetingCtrl.MapMeetingProjectToinsert.put(0,new MMPJ_TOPG_MeetingProject__c(MMPJ_TOPG_Project__c = project.id, MMPJ_TOPG_Meeting__c = LineItemMarket.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemMarket.MMPJ_TOPG_Comment__c));
        meetingCtrl.MapMeeting4PToinsert.put(1,new MMPJ_TOPG_4P__c(MMPJ_TOPG_Topic__c = 'test23'));
        meetingCtrl.MapMeetingCompToinsert.put(1,new MMPJ_TOPG_MeetingCompetitor__c());
        meetingCtrl.MapMeetingCompToinsert.put(2,new MMPJ_TOPG_MeetingCompetitor__c());
        meetingCtrl.MapMeetingMarketToinsert.put(1,new MMPJ_TOPG_MeetingMarketPerf__c());
        meetingCtrl.MapMeetingMarketToinsert.put(2,new MMPJ_TOPG_MeetingMarketPerf__c());
        meetingCtrl.MapMeetingProjectToinsert.put(1,new MMPJ_TOPG_MeetingProject__c()); 
        meetingCtrl.MapMeetingProjectToinsert.put(2,new MMPJ_TOPG_MeetingProject__c()); 

        meetingCtrl.SetTopicMinutePopUp = 'Competition';
        meetingCtrl.AddCompMom(); 
        meetingCtrl.AddComp(new MMPJ_TOPG_MeetingCompetitor__c());
        
        meetingCtrl.PrintPDF();
        meetingCtrl.InsertAgenda();
        
        //Move  items
        meetingCtrl.GoUP4P();
        meetingCtrl.GoUPmarket();
        meetingCtrl.GoUPproject();
        meetingCtrl.GoUPComp();
        
        //Edit items
        //meetingCtrl.EditCompMom();
        meetingCtrl.EditProjectMom();
        //meetingCtrl.EditPPPPMom();
        //meetingCtrl.EditMarketMom();
        
        //Del items
        meetingCtrl.DelComp();
        meetingCtrl.Delproject();
        meetingCtrl.Del4P();
        meetingCtrl.Delmarket();
        
        meetingCtrl.PrintMomPDF();
        meetingCtrl.PrintMomPDFButton();
        meetingCtrl.SaveAndCloseMin();
        meetingCtrl.UpdateMin();
        meetingCtrl.SaveMin();
        meetingCtrl.ShowSaveMessage_oldCounter = 1;
        meetingCtrl.ShowSaveMessage_oldCounter = 0;
        meetingCtrl.SaveMin();
        
        system.debug('==> call method testNewMeeting() - avant new ApexPages.StandardController(bmcTest)');
        PageReference PageTest  = page.MMPJ_TOPG_NewMeeting;
        ApexPages.StandardController BmcStdController = new ApexPages.StandardController(bmcTest);
        MMPJ_TOPG_NewMeetingController  Ctrl = new MMPJ_TOPG_NewMeetingController(BmcStdController);
        MMPJ_TOPG_NewMeetingController.WrapperpaAttList wrapper = new MMPJ_TOPG_NewMeetingController.WrapperpaAttList();
        wrapper.function = 'function';
        wrapper.email= 'test@email.com';
        wrapper.SelectValue='User';
        Wrapper.meeting=meeting;
        Ctrl.ListWrapperClassOwner = new list<user>();
        Ctrl.ListWrapperClassOwner.add(u);
        Ctrl.MoM = new MMPJ_TOPG_MinuteOfMeeting__c();
        
        Ctrl.ListWrapperAttendees= new List<MMPJ_TOPG_NewMeetingController.WrapperpaAttList>();
        Ctrl.ListWrapperDetailLine= new list<MMPJ_TOPG_NewMeetingController.WrapperDetailLine>();
        Ctrl.ListWrapperAttendees.add(wrapper);
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperDetailMarket = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperComp = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine(); 
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperProj = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();  
        
        //Market
        Ctrl.AllMarket =new list<selectoption>();
        Ctrl.SelectedMarket =new list<selectoption>();
        Ctrl.AllMarket.add(new SelectOption('France', 'France'));
        Ctrl.SelectedMarket.add(new SelectOption('France', 'France'));        
        wrapperDetailMarket.SelectValue='User';
        wrapperDetailMarket.index=0;
        wrapperDetailMarket.Project='test Project';
        wrapperDetailMarket.comp='comp';
        wrapperDetailMarket.Product='product';
        wrapperDetailMarket.who='user1';
        wrapperDetailMarket.TopicType='call';
        wrapperDetailMarket.CommentThreeLine='comment';
        wrapperDetailMarket.LineItem=LineItemMarket;
        wrapperDetailMarket.MeetingTopic=true;       
        Ctrl.ListWrapperDetailLine.add(wrapperDetailMarket);
        
        //comp
        wrapperComp.SelectValue='User';
        wrapperComp.index=0;
        wrapperComp.Project='test Project';
        wrapperComp.comp='comp';
        wrapperComp.Product='product';
        wrapperComp.who='user1';
        wrapperComp.TopicType='call';
        wrapperComp.CommentThreeLine='comment';
        wrapperComp.LineItem=LineItemComp;
        wrapperComp.MeetingTopic=true;      
        Ctrl.ListWrapperDetailLine.add(wrapperComp);
        
        //Proj
        wrapperProj.SelectValue='User';
        wrapperProj.index=2;
        wrapperProj.Project='test Project';
        wrapperProj.comp='comp';
        wrapperProj.Product='product';
        wrapperProj.who='user1';
        wrapperProj.TopicType='call';
        wrapperProj.CommentThreeLine='comment';
        wrapperProj.LineItem=LineItemComp;
        wrapperProj.MeetingTopic=true;      
        Ctrl.ListWrapperDetailLine.add(wrapperProj);
        
        Test.stopTest();
    }

    static testMethod void testNewMeeting3()
    {
        system.debug('==> call method testNewMeeting3()');
        MMPJ_TOPG_BMC__c bmcFrance = [select id, MMPJ_TOPG_BMCOwner__c from MMPJ_TOPG_BMC__c where name='France' limit 1];
        Event ev = [select id from Event where Subject='tet'limit 1];
        Event evfr = [select id from Event where Subject='in Paris'limit 1];
        
        MMPJ_TOPG_Meeting__c  meeting = [select id from MMPJ_TOPG_Meeting__c where MMPJ_TOPG_Interaction__c = 'test' limit 1];
        MMPJ_TOPG_BMC__c bmcTest = [select id from MMPJ_TOPG_BMC__c where name='bmcTest' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemMarket = [select id,MMPJ_TOPG_Detail_Line_Topic__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemComp = [select id,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Competition' limit 1];
        system.debug('#### mailPrefix in SOQL :' +mailPrefix+'-NPLsupervisor@pernod-ricard.com');
        user u = [select id, Name from user where Username =: mailPrefix+'-NPLsupervisor@pernod-ricard.com'];
        
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'test2Project';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;
        insert project;
        
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperDetailMarket = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperComp = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine(); 
        MMPJ_TOPG_NewMeetingController.WrapperDetailLine wrapperProj = new MMPJ_TOPG_NewMeetingController.WrapperDetailLine();  
                   
        wrapperDetailMarket.SelectValue='User';
        wrapperDetailMarket.index=0;
        wrapperDetailMarket.Project='Project Test2';
        wrapperDetailMarket.comp='comp';
        wrapperDetailMarket.Product='product';
        wrapperDetailMarket.who='user1';
        wrapperDetailMarket.TopicType='call';
        wrapperDetailMarket.CommentThreeLine='comment';
        wrapperDetailMarket.LineItem=LineItemMarket;
        wrapperDetailMarket.MeetingTopic=true;       
                
        Test.startTest();
       
        ApexPages.StandardController BmcStdController = new ApexPages.StandardController(bmcTest);
        MMPJ_TOPG_NewMeetingController  Ctrl = new MMPJ_TOPG_NewMeetingController(BmcStdController);
        MMPJ_TOPG_NewMeetingController.WrapperpaAttList wrapper = new MMPJ_TOPG_NewMeetingController.WrapperpaAttList();
        wrapper.function = 'function';
        wrapper.email= 'test@email.com';
        wrapper.SelectValue='User';
        wrapper.meeting=meeting;
        
        PageReference PageTest  = page.MMPJ_TOPG_NewMeeting;
        Test.setCurrentPage(PageTest);
        ApexPages.currentPage().getParameters().put('BMCID',bmcTest.id);
        Ctrl.agendaConstructor();
        Ctrl.meeting = meeting;
        Ctrl.agendaConstructor();
        
        Ctrl.MapMeeting4PToinsert.put(0,new MMPJ_TOPG_4P__c(MMPJ_TOPG_Topic__c = 'test',MMPJ_TOPG_Comment__c = ' -test set - testset -esttse'));
        Ctrl.MapMeetingCompToinsert.put(0,new MMPJ_TOPG_MeetingCompetitor__c(MMPJ_TOPG_Competitor__c = LineItemComp.MMPJ_TOPG_Competitor__c, MMPJ_TOPG_Meeting__c = LineItemComp.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemComp.MMPJ_TOPG_Comment__c));
        Ctrl.MapMeetingMarketToinsert.put(0,new MMPJ_TOPG_MeetingMarketPerf__c(MMPJ_TOPG_Detail_Line_Topic__c = LineItemMarket.MMPJ_TOPG_Detail_Line_Topic__c, MMPJ_TOPG_Meeting__c = LineItemMarket.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemMarket.MMPJ_TOPG_Comment__c));
        Ctrl.MapMeetingProjectToinsert.put(0,new MMPJ_TOPG_MeetingProject__c(MMPJ_TOPG_Project__c = project.id, MMPJ_TOPG_Meeting__c = LineItemMarket.MMPJ_TOPG_MinutesofMeeting__c, MMPJ_TOPG_Comment__c = LineItemMarket.MMPJ_TOPG_Comment__c));
        Ctrl.MapMeeting4PToinsert.put(1,new MMPJ_TOPG_4P__c(MMPJ_TOPG_Topic__c = 'test23'));
        Ctrl.MapMeetingCompToinsert.put(1,new MMPJ_TOPG_MeetingCompetitor__c());
        Ctrl.MapMeetingMarketToinsert.put(1,new MMPJ_TOPG_MeetingMarketPerf__c());
        Ctrl.MapMeetingProjectToinsert.put(1,new MMPJ_TOPG_MeetingProject__c()); 
        
        Ctrl.PrintPDF();
        Ctrl.SaveAndCloseAgenda();
        Ctrl.LeavingAgenda();
        Ctrl.Agenda = new Event();
        Ctrl.VerifyDate();
        Ctrl.Agenda = ev;
        Ctrl.Agenda.StartDateTime = System.now(); 
        Ctrl.Agenda.ENDDateTime = System.now();
        Ctrl.VerifyDate();
        Ctrl.MapAttendee = new map<string,EventRelation>();
        Ctrl.VerifyDate();
        //Ctrl.agendaConstructor();
        Ctrl.FileInput = Blob.valueOf('test');
        Ctrl.FileInputName = 'test file';
        Ctrl.FileInput = Blob.valueOf('test2');
        Ctrl.FileInputName = 'test file2';
        Ctrl.addAttendee();
        Ctrl.rowToRemove=0;
        Ctrl.DelAttendee();
        Ctrl.UPproject = 1;
        Ctrl.UP4P = 1;
        Ctrl.UPmarket = 1;
        Ctrl.UPcomp = 1;
        Ctrl.Cancel();
        Ctrl.newTabTobe = 'test';
        Ctrl.SetNewTabValue();
        string timetest = Ctrl.agendastartdate;
        boolean Saved = Ctrl.ShowSaveMessage;
        Ctrl.PrintMomPDF();
        Ctrl.PrintMomPDFButton();
        Ctrl.SaveAndCloseMin();
        Ctrl.SaveMin();

        Ctrl.DetailPopUp = wrapperDetailMarket;
        Ctrl.ProjectPopUp =project;
        Ctrl.closeDetailPopup();
        Ctrl.ProjectPopUp.Name = 'Popup2';
        Ctrl.ProjectPopUp.MMPJ_TOPG_ProjectOwner__c = u.id;
        Ctrl.ProjectPopUp.MMPJ_TOPG_StartDate__c = Date.parse('2/2/2016');
        Ctrl.ProjectPopUp.MMPJ_TOPG_EndDate__c =Date.parse('2/2/2016');
        Ctrl.ProjectPopUp =new MMPJ_TOPG_Project__c();
        //Ctrl.AttachmentToDelete = att.id;
        Ctrl.DelAtt();
        Ctrl.WrapperToDelete = 0;
        
        PageReference PageMeetingNull  = page.MMPJ_TOPG_NewMeeting;    
        Test.setCurrentPage(PageMeetingNull);
        ApexPages.currentPage().getParameters().put('BMCID','aLS8E0000004CW2WAX');
      
        ApexPages.StandardController BmcFrStdControllerNull = new ApexPages.StandardController(new MMPJ_TOPG_BMC__c());
        //meetingCtrl.BMCID_param = ApexPages.currentPage().getParameters().get('BMCID');
        Ctrl.Error =true;
        Ctrl.ErrorMessage= 'Please select a valid Meeting id';
        Ctrl.DisplayPopupBackground = true;
        Ctrl.Meeting = null;
        Ctrl.Agenda = null;
        String agendaStartDate = Ctrl.agendastartdate;
        Ctrl.initAgenda();
        Ctrl.Meeting.id = null;
        Ctrl.Error = true;
        Ctrl.ErrorMessage= 'Please select a valid Meeting id';
        Ctrl.DisplayPopupBackground = true;
        MMPJ_TOPG_MinuteofMeeting__c minWithoutDetail = new MMPJ_TOPG_MinuteofMeeting__c();
            minWithoutDetail.MMPJ_TOPG_Start_Date__c=system.Today();
            minWithoutDetail.MMPJ_TOPG_End_Date__c=system.Today();
            minWithoutDetail.MMPJ_TOPG_RAID__c='Action';
            minWithoutDetail.MMPJ_TOPG_Title__c='without details';
            minWithoutDetail.MMPJ_TOPG_Status__c='Planned';
            minWithoutDetail.MMPJ_TOG_MinutesDate__c=system.today();
            minWithoutDetail.MMPJ_TOPG_Location__c = 'ev.Location';           
            minWithoutDetail.MMPJ_TOPG_Meeting__c = meeting.id;
            minWithoutDetail.MMPJ_TOPG_Assist__c = true;
            insert minWithoutDetail;
        Ctrl.Mom = minWithoutDetail;
        Ctrl.MinutesConstructor();
        Ctrl.SaveAttendeesMinutes();       
        Ctrl.PrintPDF();
        Ctrl.PrintMomPDF();
        Ctrl.deleteWrapper();
        Ctrl.SaveAndCloseAgenda();
        Ctrl.LeavingAgenda();
        
        Test.stopTest();
    }

    static testMethod void testNewMeetingNoAgenda()
    {
        Event ev = [select id from Event where Subject='tet'limit 1];
        MMPJ_TOPG_Meeting__c  meeting = [select id from MMPJ_TOPG_Meeting__c where MMPJ_TOPG_Interaction__c = 'test' limit 1];
        MMPJ_TOPG_BMC__c bmcTest = [select id from MMPJ_TOPG_BMC__c where name='bmcTest' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItem = [select id from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Title__c='Test line Item' limit 1];
        user u = [select id from user where Username =: mailPrefix+'-NPLsupervisor@pernod-ricard.com'];
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c = Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c = Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c = u.id;

        Test.startTest();

        PageReference PageTest  = page.MMPJ_TOPG_NewMeeting;
        Test.setCurrentPage(PageTest);
        ApexPages.currentPage().getParameters().put('BMCID',bmcTest.id);
        ApexPages.StandardController BmcStdController = new ApexPages.StandardController(bmcTest);
        MMPJ_TOPG_NewMeetingController  Ctrl = new MMPJ_TOPG_NewMeetingController(BmcStdController);
 		
        Ctrl.AllMarket =new list<selectoption>();
        Ctrl.SelectedMarket =new list<selectoption>();
        Ctrl.AllMarket.add(new SelectOption('France', 'France'));
        Ctrl.SelectedMarket.add(new SelectOption('France', 'France'));      
        Ctrl.CheckNoAgenda();
        Ctrl.meeting.MMPJ_TOPG_NoAgenda__c = true;
        Ctrl.UpdateAgenda();
        Ctrl.SaveAndCloseAgenda();
        Ctrl.LeavingAgenda();
        Ctrl.AddMeetingDocument();
        Ctrl.AddVisitDocument();
        Ctrl.DisplayPPPPpopup = false;
        Ctrl.PPPPpopup = new MMPJ_TOPG_4P__c();
        Ctrl.AddMarketMom();
        Ctrl.SaveDetailPop();
        Ctrl.LeavingMin();
        Ctrl.LineItemCounter = 0;
        Ctrl.EditMarketMom();
        Ctrl.DelMarketLine();
        Ctrl.AddMarketMom();
        Ctrl.SaveAndNewDetailPop();
        Ctrl.AddMarketMom();
        Ctrl.SaveDetailPop();
        Ctrl.LineItemCounter = 1;
        Ctrl.GoUPMarketLine();
        Ctrl.AddPPPPMom();
        Ctrl.SaveAndNewDetailPop();
        Ctrl.AddPPPPMom();
        Ctrl.SaveDetailPop();
        Ctrl.GoUPPPPPLine();
        Ctrl.EditPPPPMom();
        Ctrl.DelPPPPMom();

        Ctrl.AddProjectMom();
        Ctrl.SaveAndNewDetailPop();
        Ctrl.AddProjectMom();
        Ctrl.SaveDetailPop();
        Ctrl.GoUPProjectLine();
        Ctrl.EditProjectMom();
        Ctrl.DelProjectMom();

        Ctrl.AddCompMom();
        Ctrl.SaveAndNewDetailPop();
        Ctrl.AddCompMom();
        Ctrl.SaveDetailPop();
        Ctrl.GoUPCompLine();
        Ctrl.EditCompMom();
        Ctrl.DelCompMom();
		    Ctrl.SaveProjectPop(); 
        Ctrl.closeProjectPopup();
        Ctrl.showProjectPopup();
        Ctrl.ProjectPopUp.name='tests';
        Ctrl.ProjectPopUp.MMPJ_TOPG_ProjectOwner__c= U.id;
        Ctrl.ProjectPopUp.MMPJ_TOPG_StartDate__c= system.today();
        Ctrl.ProjectPopUp.MMPJ_TOPG_EndDate__c= system.today();
        Ctrl.SaveAndNewProjectPop();
        Ctrl.ProjectPopUp.name='tests23';
        Ctrl.ProjectPopUp.MMPJ_TOPG_ProjectOwner__c= U.id;
        Ctrl.ProjectPopUp.MMPJ_TOPG_StartDate__c= system.today();
        Ctrl.ProjectPopUp.MMPJ_TOPG_EndDate__c= system.today();
        Ctrl.SaveProjectPop();
        Ctrl.AttachmentConstructor();
        /*Ctrl.ChatterAttachments = new List<ContentDocumentLink> ();
        Ctrl.MeetingAttachments = new List<attachment>();
        Ctrl.VisitsAttachments  = new List<attachment>();*/

        Test.stopTest();
    }
}